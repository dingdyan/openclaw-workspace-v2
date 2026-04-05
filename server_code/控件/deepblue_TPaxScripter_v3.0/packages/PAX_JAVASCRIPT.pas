////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: PAX_JAVASCRIPT.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit PAX_JAVASCRIPT;

interface

uses
  SysUtils, Classes,
  BASE_CONSTS,
  BASE_SYS, BASE_SCANNER, BASE_PARSER, BASE_SCRIPTER, BASE_CLASS;

const
  SP_INC = -1001;
  SP_DEC = -1002;

  SP_PLUS_ASSIGN = -1003;
  SP_MINUS_ASSIGN = -1004;
  SP_MULT_ASSIGN = -1005;
  SP_DIV_ASSIGN = -1006;
  SP_MOD_ASSIGN = -1007;
  SP_LEFT_SHIFT_ASSIGN = -1008;
  SP_RIGHT_SHIFT_ASSIGN = -1009;
  SP_UNSIGNED_RIGHT_SHIFT_ASSIGN = -1011;

  SP_BITWISE_AND = -1012;
  SP_BITWISE_OR = -1013;
  SP_BITWISE_XOR = -1014;

  SP_LOGICAL_AND = -1015;
  SP_LOGICAL_OR = -1016;

  SP_BITWISE_NOT = -1017;
  SP_LOGICAL_NOT = -1018;

  SP_COND = -1019;

  SP_OR_ASSIGN = -1020;
  SP_AND_ASSIGN = -1021;
type
  TpaxJavaScriptScanner = class(TPAXScanner)
  public
    procedure ReadToken; override;
    function UsesIdent(const IdentName: String): Boolean;
  end;

  TPaxJavaScriptParser = class(TPAXParser)
  private
    NewLine: Boolean;
    FunctionObjectID: Integer;
    LeftSideID: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Reset; override;
    procedure Match(const S: String); override;
    procedure Call_SCANNER; override;
    function Gen(Op, Arg1, Arg2, Res: Integer): Integer; override;
    procedure GenDestroyLocalVars; override;

    function Parse_EvalExpression: Integer; override;
    function Parse_ArgumentExpression: Integer; override;

    function Parse_ArgumentList(SubID: Integer; var Vars: Integer;
                                CheckCall: Boolean = true;
                                Erase: Boolean = true): Integer; override;

    function Parse_PrimaryExpression: Integer;
    function Parse_ArrayLiteral: Integer; override;
    function Parse_ObjectLiteral: Integer;
    function Parse_MemberExpression(ID: Integer): Integer;
    function Parse_NewExpression: Integer;
    function Parse_Arguments: Integer;
    function Parse_LeftHandSideExpression: Integer;
    function Parse_PostfixExpression(Left: Integer): Integer;
    function Parse_UnaryExpression(Left: Integer): Integer;
    function Parse_MultiplicativeExpression(Left: Integer): Integer;
    function Parse_AdditiveExpression(Left: Integer): Integer;
    function Parse_ShiftExpression(Left: Integer): Integer;
    function Parse_RelationalExpression(Left: Integer): Integer;
    function Parse_EqualityExpression(Left: Integer): Integer;
    function Parse_BitwiseANDExpression(Left: Integer): Integer;
    function Parse_BitwiseXORExpression(Left: Integer): Integer;
    function Parse_BitwiseORExpression(Left: Integer): Integer;
    function Parse_LogicalANDExpression(Left: Integer): Integer;
    function Parse_LogicalORExpression(Left: Integer): Integer;
    function Parse_ConditionalExpression(Left: Integer): Integer;

    function Parse_AssignmentExpression: Integer;
    function Parse_Expression: Integer;

    function Parse_ModifierList: TPAXModifierList;
    procedure Parse_Statement;
    procedure Parse_Block;
    procedure Parse_IfStmt;
    procedure Parse_NamespaceStmt(ml: TPAXModifierList);
    function Parse_FunctionStmt(ml: TPAXModifierList): Integer;
    procedure Parse_ReturnStmt;
    procedure Parse_HaltStmt;
    function Parse_VarStmt(IsField: Boolean; ml: TPAXModifierList;
                           IsLoopVar: Boolean = false): Integer;
    function Parse_VariableDeclaration(IsField: Boolean; ml: TPAXModifierList;
                                       IsLoopVar: Boolean = false): Integer;
    procedure Parse_ExpressionStmt;
    procedure Parse_WhileStmt;
    procedure Parse_DoStmt;
    procedure Parse_ForStmt;
    procedure Parse_ContinueStmt;
    procedure Parse_BreakStmt;
    procedure Parse_SwitchStmt;
    procedure Parse_WithStmt;
    procedure Parse_ThrowStmt;
    procedure Parse_TryStmt;

    procedure Parse_StmtList; override;
    procedure Parse_SourceElements;

    procedure CreateGlobalObjects;
    procedure Parse_Program; override;
  end;


implementation

uses
  BASE_EXTERN;

procedure TPaxJavaScriptScanner.ReadToken;
begin
  inherited;

  repeat

    if BuffToken.Text <> '' then
    begin
      Token := BuffToken;
      BuffToken.Text := '';
      Exit;
    end;

    GetNextChar;

    Token.TokenClass := tcNone;

    case c of
      #8, #9, #10, #13, #32: ScanWhiteSpace;
      #255: ScanEOF;
      '0'..'9': ScanDigits;
      '$': ScanHexDigits;
      'A'..'Z', 'a'..'z', '_':
      begin
        ScanIdentifier;

        if StrEql(Token.Text, 'in') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_IN;
        end
        else if StrEql(Token.Text, 'instanceof') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_INSTANCEOF;
        end
        else if StrEql(Token.Text, 'typeof') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_TYPEOF;
        end
        else if StrEql(Token.Text, 'delete') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_DESTROY_OBJECT;
        end;
      end;
      '+':
      begin
        ScanPlus;
        case LA(1) of
          '+':
          begin
            GetNextChar;
            Token.Text := '++';
            Token.ID := SP_INC;
          end;
          '=':
          begin
            GetNextChar;
            Token.Text := '+=';
            Token.ID := SP_PLUS_ASSIGN;
          end;
        end;
      end;
      '-':
      begin
        ScanMinus;
        case LA(1) of
          '-':
          begin
            GetNextChar;
            Token.Text := '--';
            Token.ID := SP_DEC;
          end;
          '=':
          begin
            GetNextChar;
            Token.Text := '-=';
            Token.ID := SP_MINUS_ASSIGN;
          end;
        end;
      end;
      '*':
      begin
        ScanMult;
        if LA(1) = '=' then
        begin
          GetNextChar;
          Token.Text := '*=';
          Token.ID := SP_MULT_ASSIGN;
        end;
      end;
      '/':
      begin
        if LA(1) = '*' then
        begin
          repeat
            GetNextChar;

            if c in [#10,#13] then
            begin
              IncLineNumber;
              PosNumber := -1;

              if c = #13 then
                GetNextChar;
            end;

          until ((LA(1) = '*') and (LA(2) = '/')) or (LA(1) = #255);
          GetNextChar;
          GetNextChar;
          Continue;
        end
        else if LA(1) = '/' then
        begin
          repeat
            GetNextChar;
          until LA(1) in [#13, #10];
          Continue;
        end;

        ScanDiv;
        if LA(1) = '=' then
        begin
          GetNextChar;
          Token.Text := '/=';
          Token.ID := SP_DIV_ASSIGN;
        end;
      end;
      '=':
      begin
        ScanEQ;
        Token.ID := OP_ASSIGN;
        if LA(1) = '=' then
        begin
          GetNextChar;
          Token.Text := '==';
          Token.ID := OP_EQ;
          if LA(1) = '=' then
          begin
            GetNextChar;
            Token.Text := '==';
            Token.ID := OP_ID;
          end;
        end;
      end;
      '>':
      begin
        ScanGT;
        case LA(1) of
         '=':
          begin
            GetNextChar;
            Token.Text := '>=';
            Token.ID := OP_GE;
          end;
         '>':
          begin
            GetNextChar;
            Token.Text := '>>';
            Token.ID := OP_RIGHT_SHIFT;
            case LA(1) of
              '=':
              begin
                GetNextChar;
                Token.Text := '>>=';
                Token.ID := SP_RIGHT_SHIFT_ASSIGN;
              end;
              '>':
              begin
                GetNextChar;
                Token.Text := '>>>';
                Token.ID := OP_UNSIGNED_RIGHT_SHIFT;
                if LA(1) = '=' then
                begin
                  GetNextChar;
                  Token.Text := '>>>=';
                  Token.ID := SP_UNSIGNED_RIGHT_SHIFT_ASSIGN;
                end;
              end;
            end;
          end;
        end;
      end;
      '<':
      case ScannerState of
        scanText:
        begin
          if LA(1) = '?' then
          begin
            GetNextChar;
            GetNextChar;
            ScanIdentifier;

            if not StrEql('pax', Trim(Token.Text)) then
              raise TPAXScriptFailure.Create(errIllegalCharacter);

            ScannerState := scanProg;
            Continue;
          end
          else if LA(1) = '%' then
          begin
            GetNextChar;
            ScannerState := scanProg;

            if LA(1) = '=' then
            begin
              GetNextChar;
              BuffToken.Text := 'print';
            end;

            Continue;
          end
          else if LA(1) in ['a'..'z','A'..'Z'] then
            ScanHtmlString(c)
          else
            raise TPAXScriptFailure.Create(errIllegalCharacter);
        end;
        scanProg:
        begin
          ScanLT;
          case LA(1) of
            '=':
            begin

              GetNextChar;
              Token.Text := '<=';
              Token.ID := OP_LE;
            end;
           '<':
            begin
              GetNextChar;
              Token.Text := '<<';
              Token.ID := OP_LEFT_SHIFT;
              if LA(1) = '=' then
              begin
                GetNextChar;
                Token.Text := '<<=';
                Token.ID := SP_LEFT_SHIFT_ASSIGN;
              end;
            end;
          end;
        end;
      end;
      ':': ScanColon;
      '!':
      begin
        Token.Text := c;
        Token.ID := SP_LOGICAL_NOT;
        Token.TokenClass := tcSpecial;

        if LA(1) = '=' then
        begin
          GetNextChar;
          Token.Text := '!=';
          Token.ID := OP_NE;
          if LA(1) = '=' then
          begin
            GetNextChar;
            Token.Text := '!==';
            Token.ID := OP_NI;
          end;
        end
      end;
      '%':
      case ScannerState of
        scanText:
          raise TPAXScriptFailure.Create(errIllegalCharacter + ' ' + c);
        scanProg:
        if LA(1) = '>' then
        begin
          ScannerState := scanText;
          GetNextChar;
          ScanHtmlString('');
        end
        else
        begin
          ScanMod;
          if LA(1) = '=' then
          begin
            GetNextChar;
            Token.Text := '%=';
            Token.ID := SP_MOD_ASSIGN;
          end;
        end;
      end;
      '~':
      begin
        Token.Text := c;
        Token.ID := SP_BITWISE_NOT;
        Token.TokenClass := tcSpecial;
      end;
      '?':
      begin
        case ScannerState of
          ScanText:
            raise TPAXScriptFailure.Create(errIllegalCharacter);
          ScanProg:
          begin
            if LA(1) = '>' then
            begin
              ScannerState := scanText;
              GetNextChar;
              ScanHtmlString('');
            end
            else
            begin
              Token.Text := c;
              Token.ID := SP_COND;
              Token.TokenClass := tcSpecial;
            end;
          end;
        end;
      end;
      '|':
      begin
        Token.Text := c;
        Token.ID := SP_BITWISE_OR;
        Token.TokenClass := tcSpecial;
        if LA(1) = '|' then
        begin
          GetNextChar;
          Token.Text := '||';
          Token.ID := SP_LOGICAL_OR;
        end
        else if LA(1) = '=' then
        begin
          GetNextChar;
          Token.Text := '|=';
          Token.ID := SP_OR_ASSIGN;
        end;
      end;
      '&':
      begin
        Token.Text := c;
        Token.ID := SP_BITWISE_AND;
        Token.TokenClass := tcSpecial;
        if LA(1) = '&' then
        begin
          GetNextChar;
          Token.Text := '&&';
          Token.ID := SP_LOGICAL_AND;
        end
        else if LA(1) = '=' then
        begin
          GetNextChar;
          Token.Text := '|=';
          Token.ID := SP_AND_ASSIGN;
        end;
      end;
      '#':
      if LookForward then
      begin
        repeat
          GetNextChar;
        until LA(1) in [#13, #10];
        continue;
      end
      else
      begin
        ScanCondDir('#', ['a'..'z','A'..'Z','_','0'..'9']);
        continue;
      end;
      ';': ScanSemiColon;
      '(': ScanLeftRoundBracket;
      ')': ScanRightRoundBracket;
      '[': ScanLeftBracket;
      ']': ScanRightBracket;
      '{': ScanLeftBrace;
      '}': ScanRightBrace;
      ',': ScanComma;
      '.': ScanPoint;
//      '\': ScanBackslash;
      '''': ScanString('''');
      '"': ScanString('"');
    else
      raise TPAXScriptFailure.Create(errIllegalCharacter + ' ' + c);
    end;

    if Token.TokenClass <> tcNone then
      Exit;

  until false;
end;

function TPaxJavaScriptScanner.UsesIdent(const IdentName: String): Boolean;
var
  I, K: Integer;
  Ch: Char;
  InComments: Boolean;
begin
  result := false;
  InComments := false;
  K := 0;
  for I:=P to Length(Buff) do
  begin
    Ch := Buff[I];
    case Ch of
      '/': if Buff[I+1] = '/' then
      begin
        InComments := true;
      end;
      #10:
      begin
        InComments := false;
      end;
      '{':
         Inc(K);
      '}':
      begin
        Dec(K);
        if K = 0 then
          Exit;
      end;
      else
        if Ch = IdentName[1] then
          if not InComments then
          if Copy(Buff, I, Length(IdentName)) = IdentName then
          begin
            result := true;
            Exit;
          end;
    end;
  end;
end;

procedure TPaxJavaScriptParser.Match(const S: String);
begin
  if (S = ';') and (CurrToken.Text <> S) then
  begin
    Scanner.BuffToken := CurrToken;

    CurrToken.Text := ';';
    CurrToken.ID := SP_SEMICOLON;
    Exit;
  end;

  inherited;
end;

constructor TPaxJavaScriptParser.Create;
begin
  inherited;

  JavaScriptOperators := true;

  Scanner := TPaxJavaScriptScanner.Create(Self);

  UpCase := false;

  NewLine := false;

  LeftSideID := 0;

  with Keywords do
  begin
    Add('base');
    Add('break');
    Add('case');
    Add('catch');
    Add('class');
    Add('continue');
    Add('delete');
    Add('do');
    Add('else');
    Add('false');
    Add('finally');
    Add('for');
    Add('function');
    Add('get');
    Add('goto');
    Add('if');
    Add('in');
    Add('instanceof');

    Add('namespace');
    Add('new');
    Add('out');
    Add('public');
    Add('private');
    Add('reduced');
    Add('ref');
    Add('return');
    Add('set');
    Add('static');
    Add('structure');
    Add('switch');
//    Add('THIS');
    Add('throw');
    Add('true');
    Add('try');
    Add('typeof');
    Add('var');
    Add('void');
    Add('using');
    Add('while');
    Add('with');

    Add('print');
    Add('println');
    Add('property');
  end;
end;

function TPAXJavaScriptParser.Gen(Op, Arg1, Arg2, Res: Integer): Integer;
begin
  Code.RemoveNops;

  if Op = OP_PLUS then
    Op := Op_PLUS_EX
  else if Op = OP_MINUS then
    Op := Op_MINUS_EX
  else if Op = OP_UNARY_MINUS then
    Op := Op_UNARY_MINUS_EX
  else if Op = OP_MULT then
    Op := Op_MULT_EX
  else if Op = OP_DIV then
    Op := Op_DIV_EX
  else if Op = OP_MOD then
    Op := Op_MOD_EX
  else if Op = OP_LEFT_SHIFT then
    Op := Op_LEFT_SHIFT_EX
  else if Op = OP_RIGHT_SHIFT then
    Op := Op_RIGHT_SHIFT_EX
  else if Op = OP_UNSIGNED_RIGHT_SHIFT then
    Op := Op_UNSIGNED_RIGHT_SHIFT_EX
  else if Op = OP_EQ then
    Op := Op_EQ_EX
  else if Op = OP_NE then
    Op := Op_NE_EX
  else if Op = OP_ID then
    Op := Op_ID_EX
  else if Op = OP_NI then
    Op := Op_NI_EX
  else if Op = OP_LT then
    Op := Op_LT_EX
  else if Op = OP_LE then
    Op := Op_LE_EX
  else if Op = OP_GT then
    Op := Op_GT_EX
  else if Op = OP_GE then
    Op := Op_GE_EX;

  result := inherited Gen(Op, Arg1, Arg2, Res);
end;

procedure TPAXJavaScriptParser.Call_SCANNER;
var
  L1, L2: Integer;
begin
  L1 := Scanner.LineNumber;
  inherited;
  L2 := Scanner.LineNumber;
  NewLine := L2 > L1;

  if IsCurrText('null') then
  begin
    CurrToken.ID := UndefinedID;
    CurrToken.TokenClass := tcId;
  end;
end;

destructor TPAXJavaScriptParser.Destroy;
begin
  inherited;
end;

procedure TPaxJavaScriptParser.Reset;
begin
  inherited;
end;

function TPaxJavaScriptParser.Parse_EvalExpression: Integer;
begin
//  result := Parse_LeftHandSideExpression;
  result := Parse_Expression;
end;

function TPaxJavaScriptParser.Parse_ArgumentExpression: Integer;
begin
  result := Parse_AssignmentExpression;
end;

///////  EXPRESSIONS /////////////////////////////////////////////////////////

function TPaxJavaScriptParser.Parse_ArgumentList(SubID: Integer; var Vars: Integer;
                                    CheckCall: Boolean = true;
                                    Erase: Boolean = true): Integer;

procedure _ParseExpr;
var
  TempID, ExprID, K1, K2: Integer;
begin
  Inc(result);
  K1 := Code.Card;
  ExprID := Parse_ArgumentExpression;
  Code.RemoveNops;
  K2 := Code.Card;
  if K2 - K1 > 0 then
  begin
    TempID := NewVar;
    Gen(OP_ASSIGN_SIMPLE, TempID, ExprID, TempID);
    Gen(OP_PUSH, TempID, 0, 0);
  end
  else
    Gen(OP_PUSH, ExprID, 0, 0);
end;

var
  I: Integer;
  S: String;
begin
  Vars := 0;
  result := 0;
  ArgumentListSwitch := true;
  if Erase then
  begin
    S := Name[SubId];
    I := ArrayParamMethods.IndexOf(S);
    if I = -1 then
      ArgumentListSwitch := false;
  end;

  _ParseExpr;
  while IsCurrText(',') do
  begin
    Call_SCANNER;
    _ParseExpr;
  end;

  ArgumentListSwitch := false;
  if Erase then
  begin
    S := Name[SubId];
    I := ArrayParamMethods.IndexOf(S);
    if I = -1 then
      ArrayArgumentList.Clear;
  end;
end;

function TPaxJavaScriptParser.Parse_PrimaryExpression: Integer;
var
  SubID, ID: Integer;
  IsArrayItem: Boolean;
begin
  if IsCurrText('(') then // (Expression)
  begin
    Call_SCANNER;
    result := Parse_Expression;
    Match(')');
    Call_SCANNER;
  end
  else if IsCurrText('base') then // (base access)
  begin
    if CurrClassID = 0 then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);
    if CurrSubID <> CurrMethodID then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);

    Call_SCANNER;
    Match('.');
    FieldSwitch := true;
    Call_SCANNER;
    result := Parse_Ident;
    GenRef(CurrThisID, maMyBase, result);
  end
  else if IsCurrText('this') then // (base access)
  begin
    if CurrClassID = 0 then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);
    if CurrSubID <> CurrMethodID then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);

    if IsNextText('.') then
    begin
      Call_SCANNER;
      Match('.');
      FieldSwitch := true;
      Call_SCANNER;
      result := Parse_Ident;
      GenRef(CurrThisID, maMyClass, result);
    end
    else
    begin
      result := Parse_Ident;
    end;
  end
  else if IsCurrText('[') then // (array literal)
    result := Parse_ArrayLiteral
  else if IsCurrText('{') then // (object literal)
    result := Parse_ObjectLiteral
  else if IsCurrText('/') then // (regexp literal)
    result := Parse_RegExpr('RegExp')
  else if IsCurrText('&') then
  begin
    result := NewVar;
    Call_SCANNER;
    if IsCallOperator then
      RemoveLastOperator;

    IsArrayItem := IsNextText('[') or IsNextText('(');

    SubID := Parse_MemberExpression(0);
    if IsCallOperator and (not IsArrayItem) then
       RemoveLastOperator;
    Gen(OP_ASSIGN_ADDRESS, result, SubID, result);
  end
  else if IsCurrText('*') then
  begin
    Call_SCANNER;
    ID := Parse_MemberExpression(0);
    result := NewVar;
    Gen(OP_GET_TERMINAL, ID, 0, result);
  end
  else if IsCurrText('true') then
  begin
    result := NewConst(true);
    Call_SCANNER;
  end
  else if IsCurrText('function') then
  begin
    result := Parse_FunctionStmt([]);
    while Kind[result] <> KindTYPE do
      Dec(result);
  end
  else if IsCurrText('false') then
  begin
    result := NewConst(false);
    Call_SCANNER;
  end
  else if IsConstant then
  begin
    result := CurrToken.ID;
    if TypeID[result] = typeSTRING then
    begin
      result := Parse_StringLiteral;
    end
    else
      Call_SCANNER;
  end
  else
  begin
    if IsNextText('.') and IsNext2Text('arguments') then
    begin
      Call_SCANNER;
      Call_SCANNER;
      result := Parse_Ident;
      Exit;
    end;
    result := Parse_Ident;
    result := GenEvalWith(result);
  end;
end;

function TPaxJavaScriptParser.Parse_ArrayLiteral: Integer;
var
  L, K, ArgID: Integer;
begin
  // '['

  K := 0;
  result := NewVar;

  if ArgumentListSwitch then
    ArrayArgumentList.Add(result);


  Gen(OP_PUSH, 0, 0, 0);
  L := LastCodeLine;

  Gen(OP_CREATE_ARRAY, result, 1, 0);

  Call_SCANNER;
  if not IsCurrText(']') then
  begin
    Gen(OP_PUSH, NewConst(K), 0, 0);
    ArgID := Parse_AssignmentExpression;
    Gen(OP_PUSH, ArgID, 0, 0);
    Gen(OP_PUT_PROPERTY, result, 2, 0);

    while IsCurrText(',') do
    begin
      Inc(K);

      Call_SCANNER;
      Gen(OP_PUSH, NewConst(K), 0, 0);
      ArgID := Parse_AssignmentExpression;
      Gen(OP_PUSH, ArgID, 0, 0);
      Gen(OP_PUT_PROPERTY, result, 2, 0);
    end;
  end
  else
    K := -1;

  Code.Prog[L].Arg1 := NewConst(K);

  Match(']');
  Call_SCANNER;
end;

function TPaxJavaScriptParser.Parse_ObjectLiteral: Integer;
var
  RefID, ClassID: Integer;
begin
// Match "{"

  result := NewVar;
  RefID := NewVar;
  ClassID := NewVar;

  Name[ClassID] := 'Object';
  Name[RefID] := 'Object';

  Gen(OP_EVAL_WITH, 0, 0, ClassID);
  Gen(OP_CREATE_OBJECT, ClassID, 0, result);

  GenRef(result, maAny, RefID);
  Gen(OP_CALL, RefID, 0, result);

  Call_SCANNER;

  if not IsCurrText('}') then
  repeat
    Gen(OP_PUSH, CurrToken.ID, 0, 0);

    Call_SCANNER;
    Match(':');

    Call_SCANNER;
    Gen(OP_PUSH, Parse_AssignmentExpression, 0, 0);

    Gen(OP_PUT_PROPERTY, result, 2, 0);

    if IsCurrText(',') then
      Call_SCANNER
    else
      Break;
  until False;

  Match('}');
  Call_SCANNER;
end;

function TPaxJavaScriptParser.Parse_MemberExpression(ID: Integer): Integer;
var
  SubID, RefID, Vars: Integer;
label
  Again;
begin
  if ID = 0 then
    result := Parse_PrimaryExpression
  else
    result := ID;

  while CurrToken.Text[1] in ['(','[','.'] do
    case CurrToken.Text[1] of
      '[':
      begin

        SubID := result;
        result := NewVar;

        Call_SCANNER;
        Gen(OP_CALL, SubID, Parse_ArgumentList(SubID, Vars, true, false), result);
//        Code.Prog[Code.Card].AltArg1 := 1; // get property
        SymbolTable.JSIndex[SubId] := true;

        SetVars(Vars);

        Match(']');

        Call_SCANNER;
      end;
      '.':
      begin
        if IsNextText('arguments') then
        begin
          Call_SCANNER;
          result := CurrToken.ID;
          Gen(OP_EVAL_WITH, 0, 0, result);
          Call_SCANNER;
        end
        else
        begin
          FieldSwitch := true;
          Call_SCANNER;
          RefID := Parse_Ident;
          GenRef(result, maAny, RefID);
          result := RefID;

  //        if not (CurrToken.Text[1] in ['(', '[']) then
  //          Gen(OP_CALL, result, 0, result);
        end;
      end;
      '(':
      begin
        SubID := result;
        result := NewVar;

        Call_SCANNER;
        if IsCurrText(')') then
          Gen(OP_CALL, SubID, 0, result)
        else
        begin
          Gen(OP_CALL, SubID, Parse_ArgumentList(SubID, Vars), result);
          SetVars(Vars);
        end;

        Match(')');

        Call_SCANNER;
      end;
    end;
end;

function TPaxJavaScriptParser.Parse_NewExpression: Integer;
var
  ClassID, ObjectID, RefID, SubID: Integer;
  reg_exp, temp: Boolean;
begin
  temp := false;
  
  if IsCurrText('new') then
  begin
    Call_SCANNER;

    reg_exp := StrEql('RegExp', CurrToken.Text);
    if reg_exp then
    begin
      temp := Backslash;
      Backslash := false;
    end;

    ClassID := Parse_Ident;
    ClassID := GenEvalWith(ClassID);

    while IsCurrText('.') do
    begin
      FieldSwitch := true;
      Call_SCANNER;
      RefID := Parse_Ident;
      GenRef(ClassID, maAny, RefID);
      ClassID := RefID;
    end;

    ObjectID := NewVar;
    Gen(OP_CREATE_OBJECT, ClassID, 0, ObjectID);

    if IsCurrText('(') then
    begin
      result := NewRef;
      Name[result] := Name[ClassID];
      GenRef(ObjectID, maMyClass, result);
      result := Parse_MemberExpression(result);
    end
    else if IsCurrText(';') or NewLine then
    begin
      result := NewRef;
      Name[result] := Name[ClassID];
      GenRef(ObjectID, maMyClass, result);
      SubID := result;
      result := NewVar;
      Gen(OP_CALL, SubID, 0, result);
    end
    else
      result := ObjectID;

    TypeID[result] := ClassID;

    if reg_exp then
    begin
      Backslash := temp;
    end;
  end
  else
    result := Parse_MemberExpression(0);
end;

function TPaxJavaScriptParser.Parse_Arguments: Integer;
begin
  result := 0;
end;

function TPaxJavaScriptParser.Parse_LeftHandSideExpression: Integer;
begin
  result := Parse_NewExpression;
end;

function TPaxJavaScriptParser.Parse_PostfixExpression(Left: Integer): Integer;
var
  temp, r: Integer;
begin
  if Left <> 0 then
    result := Left
  else
    result := Parse_LeftHandSideExpression;

  if IsCurrText('++') then
  begin
    Call_SCANNER;
    temp := NewVar();
    Gen(OP_ASSIGN, temp, result, temp);
    r := NewVar();
    Gen(OP_PLUS, result, NewConst(1), r);
    Gen(OP_ASSIGN, result, r, result);
    result := temp;
  end
  else if IsCurrText('--') then
  begin
    Call_SCANNER;
    temp := NewVar();
    Gen(OP_ASSIGN, temp, result, temp);
    r := NewVar();
    Gen(OP_MINUS, result, NewConst(1), r);
    Gen(OP_ASSIGN, result, r, result);
    result := temp;
  end;
end;

function TPaxJavaScriptParser.Parse_UnaryExpression(Left: Integer): Integer;
begin
  if Left <> 0 then
  begin
    result := Parse_PostfixExpression(Left);
    Exit;
  end;

  if IsCurrText('++') then
  begin
    Call_SCANNER;
    result := Parse_UnaryExpression(0);
    GEN(OP_PLUS, result, NewConst(1), result);
  end
  else if IsCurrText('--') then
  begin
    Call_SCANNER;
    result := Parse_UnaryExpression(0);
    GEN(OP_MINUS, result, NewConst(1), result);
  end
  else if CurrToken.ID = OP_DESTROY_OBJECT then
  begin
    Call_SCANNER;
    result := Parse_UnaryExpression(0);
    GEN(OP_DESTROY_OBJECT, result, 0, 0);
  end
  else if IsCurrText('+') then
  begin
    Call_SCANNER;
    result := Parse_UnaryExpression(0);
  end
  else if CurrToken.ID = OP_TYPEOF then
  begin
    result := NewVar;
    Call_SCANNER;
    Gen(OP_TYPEOF, Parse_UnaryExpression(0), 0, result);
  end
  else if IsCurrText('-') then
  begin
    result := NewVar;
    Call_SCANNER;
    Gen(OP_UNARY_MINUS, Parse_UnaryExpression(0), 0, result);
  end
  else if IsCurrText('+') then
  begin
    result := NewVar;
    Call_SCANNER;
    Gen(OP_UNARY_PLUS, Parse_UnaryExpression(0), 0, result);
  end
  else if CurrToken.ID = SP_BITWISE_NOT then
  begin
    result := NewVar;
    Call_SCANNER;
    Gen(OP_TO_INTEGER, Parse_UnaryExpression(0), 0, result);
    Gen(OP_NOT, result, 0, result);
  end
  else if CurrToken.ID = SP_LOGICAL_NOT then
  begin
    result := NewVar;
    Call_SCANNER;
    Gen(OP_TO_BOOLEAN, Parse_UnaryExpression(0), 0, result);
    Gen(OP_NOT, result, 0, result);
  end
  else
    result := Parse_PostfixExpression(0);
end;

function TPaxJavaScriptParser.Parse_MultiplicativeExpression(Left: Integer): Integer;
var
  OP, ResID: Integer;
begin
  ResID := 0;
  result := Parse_UnaryExpression(Left);

  while (CurrToken.ID = OP_MULT) or
        (CurrToken.ID = OP_DIV) or
        (CurrToken.ID = OP_MOD) do
  begin
    OP := CurrToken.ID;

    if ResID = 0 then
      ResID := NewVar;

    Call_SCANNER;
    Gen(OP, result, Parse_UnaryExpression(0), ResID);
    result := ResID;
  end;
end;

function TPaxJavaScriptParser.Parse_AdditiveExpression(Left: Integer): Integer;
var
  OP, ResID: Integer;
begin
  ResID := 0;
  result := Parse_MultiplicativeExpression(Left);

  while IsCurrText('+') or IsCurrText('-') do
  begin
    OP := CurrToken.ID;

    if ResID = 0 then
      ResID := NewVar;

    Call_SCANNER;
    Gen(OP, result, Parse_MultiplicativeExpression(0), ResID);
    result := ResID;
  end;
end;

function TPaxJavaScriptParser.Parse_ShiftExpression(Left: Integer): Integer;
var
  OP, ResID: Integer;
begin
  ResID := 0;
  result := Parse_AdditiveExpression(Left);

  while (CurrToken.ID = OP_LEFT_SHIFT) or
        (CurrToken.ID = OP_RIGHT_SHIFT) or
        (CurrToken.ID = OP_UNSIGNED_RIGHT_SHIFT) do
  begin
    OP := CurrToken.ID;

    if ResID = 0 then
      ResID := NewVar;

    Call_SCANNER;
    Gen(OP, result, Parse_AdditiveExpression(0), ResID);
    result := ResID;
  end;
end;

function TPaxJavaScriptParser.Parse_RelationalExpression(Left: Integer): Integer;
var
  OP, ResID: Integer;
begin
  ResID := 0;
  result := Parse_ShiftExpression(Left);

  while (CurrToken.ID = OP_LT) or
        (CurrToken.ID = OP_GT) or
        (CurrToken.ID = OP_LE) or
        (CurrToken.ID = OP_GE) do
  begin
    OP := CurrToken.ID;

    if ResID = 0 then
      ResID := NewVar;

    Call_SCANNER;
    Gen(OP, result, Parse_ShiftExpression(0), ResID);
    result := ResID;
  end;
end;

function TPaxJavaScriptParser.Parse_EqualityExpression(Left: Integer): Integer;
var
  OP, ResID: Integer;
begin
  ResID := 0;
  result := Parse_RelationalExpression(Left);

  while (CurrToken.ID = OP_EQ) or
        (CurrToken.ID = OP_NE) or
        (CurrToken.ID = OP_ID) or
        (CurrToken.ID = OP_NI) or
        (CurrToken.ID = OP_IN) or
        (CurrToken.ID = OP_INSTANCEOF) do
  begin
    OP := CurrToken.ID;

    if ResID = 0 then
      ResID := NewVar;

    Call_SCANNER;
    Gen(OP, result, Parse_RelationalExpression(0), ResID);
    Result := ResID;
  end;
end;

function TPaxJavaScriptParser.Parse_BitwiseANDExpression(Left: Integer): Integer;
var
  ResID: Integer;
begin
  ResID := 0;
  result := Parse_EqualityExpression(Left);

  while CurrToken.ID = SP_BITWISE_AND do
  begin
    Call_SCANNER;
    if ResID = 0 then
    begin
      ResID := NewVar;
      Gen(OP_AND, ToInteger(result), ToInteger(Parse_EqualityExpression(0)), ResID);
    end
    else
      Gen(OP_AND, result, ToInteger(Parse_EqualityExpression(0)), ResID);
    result := ResID;
  end;
end;

function TPaxJavaScriptParser.Parse_BitwiseXORExpression(Left: Integer): Integer;
var
  ResID: Integer;
begin
  ResID := 0;
  result := Parse_BitwiseANDExpression(Left);

  while CurrToken.ID = SP_BITWISE_XOR do
  begin
    Call_SCANNER;
    if ResID = 0 then
    begin
      ResID := NewVar;
      Gen(OP_XOR, ToInteger(result), ToInteger(Parse_BitwiseANDExpression(0)), ResID);
    end
    else
      Gen(OP_XOR, result, ToInteger(Parse_BitwiseANDExpression(0)), ResID);
    result := ResID;
  end;
end;

function TPaxJavaScriptParser.Parse_BitwiseORExpression(Left: Integer): Integer;
var
  ResID: Integer;
begin
  ResID := 0;
  result := Parse_BitwiseXORExpression(Left);

  while CurrToken.ID = SP_BITWISE_OR do
  begin
    Call_SCANNER;
    if ResID = 0 then
    begin
      ResID := NewVar;
      Gen(OP_OR, ToInteger(result), ToInteger(Parse_BitwiseXORExpression(0)), ResID);
    end
    else
      Gen(OP_OR, result, ToInteger(Parse_BitwiseXORExpression(0)), ResID);
    result := ResID;
  end;
end;


function TPAXJavaScriptParser.Parse_LogicalANDExpression(Left: Integer): Integer;
begin
  result := Parse_BitwiseORExpression(Left);

  while CurrToken.ID = SP_LOGICAL_AND do
  begin
    Call_SCANNER;
    if ShortEvalSwitch then
    begin
      result := Parse_ShortEvalAND(result, nil, Parse_BitwiseORExpression);
    end
    else
    begin
      result := BinOp(OP_AND, result, Parse_BitwiseORExpression(0));
    end;
  end;
end;

function TPAXJavaScriptParser.Parse_LogicalORExpression(Left: Integer): Integer;
begin
  result := Parse_LogicalANDExpression(Left);

  while CurrToken.ID = SP_LOGICAL_OR do
  begin
    Call_SCANNER;
    if ShortEvalSwitch then
    begin
      result := Parse_ShortEvalOR(result, nil, Parse_LogicalANDExpression);
    end
    else
    begin
      result := BinOp(OP_OR, result, Parse_LogicalANDExpression(0));
    end;
  end;
end;

function TPaxJavaScriptParser.Parse_ConditionalExpression(Left: Integer): Integer;
var
  L, LF: Integer;
begin
  result := Parse_LogicalORExpression(Left);

  while CurrToken.ID = SP_COND do
  begin
    LF := NewLabel;
    L := NewLabel;

    Gen(OP_GO_FALSE, LF, result, 0);

    result := NewVar;

    Call_SCANNER;
    Gen(OP_ASSIGN, result, Parse_AssignmentExpression, result);
    Match(':');

    Gen(OP_GO, L, 0, 0);

    SetLabelHere(LF);

    Call_SCANNER;
    Gen(OP_ASSIGN, result, Parse_AssignmentExpression, result);

    SetLabelHere(L);
  end;
end;

function TPaxJavaScriptParser.Parse_AssignmentExpression: Integer;
var
  OP, Arg1, Arg2, Res, L1, L2, L: Integer;
  IsreducedAssignment: Boolean;
begin
  if IsCurrText('delete') or
     IsCurrText('void') or
     IsCurrText('typeof') or
     IsCurrText('(') or
     IsCurrText('++') or
     IsCurrText('--') or
     IsCurrText('+') or
     IsCurrText('-') or
     (CurrToken.ID = SP_BITWISE_NOT) or
     (CurrToken.ID = SP_LOGICAL_NOT) then

  begin
    result := Parse_ConditionalExpression(0);
    Exit;
  end;

  L1 := LastCodeLine + 1;

  Gen(OP_NOP, 0, 0, 0);

  IsReducedAssignment := false;
  if IsCurrText('reduced') then
  begin
    IsreducedAssignment := true;
    Call_SCANNER;
    result := Parse_LeftHandSideExpression;
  end
  else
    result := Parse_LeftHandSideExpression;

  LeftSideID := result;

//  if CurrToken.TokenClass <> tcSpecial then
//    Match('=');
  if IsCurrText(')') then
    Exit;
  if IsCurrText(']') then
    Exit;
  if IsCurrText(';') then
    Exit;

  if CurrToken.ID = OP_ASSIGN then
  begin
   Call_SCANNER;

   if IsreducedAssignment then
     Parse_ReducedAssignment(result)
   else if IsCallOperator(Arg1, Arg2, Res) then
   begin
     if IsCurrText('&') and (Arg2 > 0) then
     begin
       Code.Prog[LastCodeLine].Op := OP_GET_ITEM_EX;
       result := Parse_AssignmentExpression;
       Code.Prog[LastCodeLine].Res := Res;
     end
     else
     begin
       RemoveLastOperator;
       result := Parse_AssignmentExpression;
       Gen(OP_PUSH, result, 0, 0);
       Gen(OP_PUT_PROPERTY, Arg1, Arg2 + 1, 0);
     end;
   end
   else
   begin

     if CurrSubID > 0 then
     begin
       L := SymbolTable.Level[result];
       if L <> SymbolTable.RootNamespaceID then
       begin
         SymbolTable.SetLocal(result);
         LocalVars.Add(result);
       end;
     end
     else
     begin
       if Kind[result] = kindVAR then
         if CurrClassRec.FindMember(NameIndex[result], maAny) = nil then
            CurrClassRec.AddField(result, [modSTATIC]);
     end;

     Gen(OP_ASSIGN, result, Parse_AssignmentExpression, result);
   end;
  end
  else if (CurrToken.ID = SP_PLUS_ASSIGN) or
          (CurrToken.ID = SP_MINUS_ASSIGN) or
          (CurrToken.ID = SP_MULT_ASSIGN) or
          (CurrToken.ID = SP_DIV_ASSIGN) or
          (CurrToken.ID = SP_MOD_ASSIGN) or
          (CurrToken.ID = SP_OR_ASSIGN) or
          (CurrToken.ID = SP_AND_ASSIGN) or
          (CurrToken.ID = SP_LEFT_SHIFT_ASSIGN) or
          (CurrToken.ID = SP_RIGHT_SHIFT_ASSIGN) or
          (CurrToken.ID = SP_UNSIGNED_RIGHT_SHIFT_ASSIGN) then
  begin
    OP := 0;
    case CurrToken.ID of
      SP_PLUS_ASSIGN: OP := OP_PLUS;
      SP_MINUS_ASSIGN: OP := OP_MINUS;
      SP_MULT_ASSIGN: OP := OP_MULT;
      SP_DIV_ASSIGN: OP := OP_DIV;
      SP_MOD_ASSIGN: OP := OP_MOD;
      SP_OR_ASSIGN: OP := OP_OR;
      SP_AND_ASSIGN: OP := OP_AND;
      SP_LEFT_SHIFT_ASSIGN: OP := OP_LEFT_SHIFT;
      SP_RIGHT_SHIFT_ASSIGN: OP := OP_RIGHT_SHIFT;
      SP_UNSIGNED_RIGHT_SHIFT_ASSIGN: OP := OP_UNSIGNED_RIGHT_SHIFT;
    end;

    Call_SCANNER;
    if IsCallOperator(Arg1, Arg2, Res) then
    begin
      L2 := LastCodeLine - 1;
      Res := NewVar;
      Gen(OP, result, Parse_AssignmentExpression, Res);
      InsertCode(L1, L2);
      Gen(OP_PUSH, Res, 0, 0);
      Gen(OP_PUT_PROPERTY, Arg1, Arg2 + 1, 0);
      result := Res;
    end
    else
      Gen(OP, result, Parse_AssignmentExpression, result);
  end
  else
  begin
    result := Parse_ConditionalExpression(result);
  end;
end;

function TPaxJavaScriptParser.Parse_Expression: Integer;
begin
  result := Parse_AssignmentExpression;
  while CurrToken.ID = SP_COMMA do
  begin
    Call_SCANNER;
    result := Parse_AssignmentExpression;
  end;
end;

///////  STATEMENTS /////////////////////////////////////////////////////////

function TPaxJavaScriptParser.Parse_ModifierList: TPAXModifierList;
label
  Again;
begin
  result := [];

Again:

  if IsCurrText('public') then
  begin
    result := result + [modPUBLIC];
    Call_SCANNER;
    Goto Again;
  end;
  if IsCurrText('private') then
  begin
    result := result + [modPRIVATE];
    Call_SCANNER;
    Goto Again;
  end;
  if IsCurrText('static') then
  begin
    result := result + [modSTATIC];
    Call_SCANNER;
    Goto Again;
  end;
end;

procedure TPaxJavaScriptParser.Parse_Statement;
var
  ml: TPAXModifierList;
begin
  ml := Parse_ModifierList;

  if IsLabelID then
  begin
    StatementLabel := CurrToken.Text;
    Parse_SetLabel;
    Match(':');
    Call_SCANNER;
  end;

  if IsCurrText('{') then
  begin
    Parse_Block;
    Call_SCANNER;
  end
  else if IsCurrText(';') then
    Call_SCANNER
  else if IsCurrText('namespace') then
    Parse_NamespaceStmt(ml)
  else if IsCurrText('function') then
    Parse_FunctionStmt(ml)
  else if IsCurrText('goto') then
  begin
    IsExecutable := true;
    Parse_GoToStmt;
    IsExecutable := false;
    Match(';');
    Call_SCANNER;
  end
  else if IsCurrText('if') then
  begin
    IsExecutable := true;
    Parse_IfStmt;
    IsExecutable := false;
  end
  else if IsCurrText('throw') then
  begin
    IsExecutable := true;
    Parse_ThrowStmt;
    IsExecutable := false;
  end
  else if IsCurrText('try') then
  begin
    IsExecutable := true;
    Parse_TryStmt;
    IsExecutable := false;
  end
  else if IsCurrText('var') then
  begin
    Parse_VarStmt(false, ml);
    Match(';');
    Call_SCANNER;
  end
  else if IsCurrText('return') then
  begin
    IsExecutable := true;
    Parse_ReturnStmt;
    IsExecutable := false;
    Match(';');
    Call_SCANNER;
  end
  else if IsCurrText('do') then
  begin
    IsExecutable := true;
    Parse_DoStmt;
    IsExecutable := false;
  end
  else if IsCurrText('for') then
  begin
    IsExecutable := true;
    Parse_ForStmt;
    IsExecutable := false;
  end
  else if IsCurrText('while') then
  begin
    IsExecutable := true;
    Parse_WhileStmt;
    IsExecutable := false;
  end
  else if IsCurrText('continue') then
  begin
    IsExecutable := true;
    Parse_ContinueStmt;
    IsExecutable := false;
  end
  else if IsCurrText('break') then
  begin
    IsExecutable := true;
    Parse_BreakStmt;
    IsExecutable := false;
  end
  else if IsCurrText('switch') then
  begin
    IsExecutable := true;
    Parse_SwitchStmt;
    IsExecutable := false;
  end
  else if IsCurrText('with') then
  begin
    IsExecutable := true;
    Parse_WithStmt;
    IsExecutable := false;
  end
  else if IsCurrText('using') then
    Parse_ImportsStmt
  else if IsCurrText('print') then
  begin
    IsExecutable := true;
    Parse_PrintList;
    IsExecutable := false;
    Match(';');
    Call_SCANNER;
  end
  else if IsCurrText('println') then
  begin
    IsExecutable := true;
    Parse_PrintlnList;
    IsExecutable := false;
    Match(';');
    Call_SCANNER;
  end
  else
  begin
    IsExecutable := true;
    Parse_ExpressionStmt;
    IsExecutable := false;

    if Code.Prog[Code.Card].Op = OP_SAVE_RESULT then
      if Code.Prog[Code.Card - 1].Op = OP_CALL then
      begin
        Dec(Code.Card);
        SymbolTable.Level[Code.Prog[Code.Card].Res] := 0;
        Code.Prog[Code.Card].Res := 0;
      end;

    Match(';');
    Call_SCANNER;
  end;

  GenDestroyArrayArgumentList;
end;

procedure TPaxJavaScriptParser.Parse_Block;
begin
// Match "{"

  Call_SCANNER;
  if not IsCurrText('}') then
  repeat
     Parse_Statement;
     if IsCurrText('}') then
       Break;
  until false;
  IsExecutable := true;
  Gen(OP_SKIP, 0, 0, 0);
  IsExecutable := false;
  Match('}');
end;

procedure TPaxJavaScriptParser.Parse_NamespaceStmt(ml: TPAXModifierList);
var
  NamespaceID: Integer;
begin
  // match "namespace"
  CurrClassRec.UsingInitList.Add(LastCodeLine);

  Call_SCANNER;
  NamespaceID := Parse_Ident;

  Kind[NamespaceID] := KindTYPE;

  LevelStack.PushClass(NamespaceID, 0, ml + [modSTATIC], ckClass, false);

  Match('{');
  Gen(OP_USE_NAMESPACE, UsingList.Push(NamespaceID), 0, 0);
  Gen(OP_HALT_OR_NOP, 0, 0, 0);

  Parse_Block;
  Gen(OP_END_OF_NAMESPACE, 0, 0, 0);

  Call_SCANNER;

  LevelStack.Pop;
  UsingList.Pop;
end;

procedure TPaxJavaScriptParser.Parse_IfStmt;
var
  ExprID, L, LF: Integer;
begin
  // match "if"
  LF := NewLabel;

  Call_SCANNER;
  Match('(');

  Call_SCANNER;
  ExprID := Parse_Expression;
  GenDestroyArrayArgumentList;

  Gen(OP_GO_FALSE, LF, ExprID, 0);

  Match(')');

  Call_SCANNER;
  Parse_Statement;

  if IsCurrText('else') then
  begin
    L := NewLabel;
    Gen(OP_GO, L, 0, 0);

    SetLabelHere(LF);
    Call_SCANNER;
    Parse_Statement;

    SetLabelHere(L);
  end
  else
    SetLabelHere(LF);
end;

procedure TPaxJavaScriptParser.Parse_DoStmt;
var
  L, LF, ExprID, ID: Integer;
begin
// match "do"

  LF := NewLabel;
  L := NewLabel;

  SetLabelHere(LF);

  Call_SCANNER;

  EntryStack.Push(L, LF, StatementLabel);

  Parse_Statement;

  EntryStack.Pop;

  Match('while');

  Call_SCANNER;

  Match('(');
  Call_SCANNER;
  ExprID := Parse_Expression;
  Match(')');

  Call_SCANNER;

  ID := NewVar;
  Gen(OP_NOT, ExprID, 0, ID);
  Gen(OP_GO_FALSE, LF, ID, 0);

  SetLabelHere(L);
end;

procedure TPaxJavaScriptParser.Parse_ForStmt;
var
  LF, L, LStatement, LIncrement, TempClass,
  LoopCounterID, ResID: Integer;
begin
  // match "for"

  TempClass := 0;

  LevelStack.Save;

  L := NewLabel;
  SetLabelHere(L);

  LF := NewLabel;
  LStatement := NewLabel;
  LIncrement := NewLabel;

  Call_SCANNER;
  Match('(');

  Call_SCANNER;
  LoopCounterID := 0;
  if not IsCurrText(';') then
  begin
    if IsCurrText('var') then
    begin
      if CurrSubID = 0 then
        TempClass := LevelStack.PushTempClass;
      LoopCounterID := Parse_VarStmt(false, []);
      if CurrSubID = 0 then
        Gen(OP_BEGIN_WITH, TempClass, 0, 0);
    end
    else
    begin
      if IsNextText('in') then
        LoopCounterID := Parse_Ident
      else
        LoopCounterID := Parse_Expression;
    end;
  end;

  if IsCurrText('in') then
  begin
    Gen(OP_OPTIMIZATION_OFF, 0, 0, 0);

    ResID := NewVar(0);
    Call_SCANNER;
    SetLabelHere(LIncrement);
    Gen(OP_GET_NEXT_PROP, LoopCounterID, Parse_Expression, ResID);
    Gen(OP_GO_FALSE, LF, ResID, 0);
    Call_SCANNER;
    Parse_Statement;
    Gen(OP_GO, LIncrement, 0, 0);
    SetLabelHere(LF);
    LevelStack.Restore;
    if TempClass > 0 then
      Gen(OP_END_WITH, 0, 0, 0);

    Gen(OP_OPTIMIZATION_ON, 0, 0, 0);
    Exit;
  end;

  Match(';');
  SetLabelHere(L);

  Call_SCANNER;
  if not IsCurrText(';') then
    Gen(OP_GO_FALSE, LF, Parse_Expression, 0)
  else
    Gen(OP_GO_FALSE, LF, NewConst(true), 0);

  Match(';');

  Gen(OP_GO, LStatement, 0, 0);

  SetLabelHere(LIncrement);

  Call_SCANNER;
  if not IsCurrText(')') then
    Parse_Expression;

  Match(')');

  Gen(OP_GO, L, 0, 0);

  SetLabelHere(LStatement);

  EntryStack.Push(LF, LIncrement, StatementLabel);

  Call_SCANNER;
  Parse_Statement;

  EntryStack.Pop;

  Gen(OP_GO, LIncrement, 0, 0);

  SetLabelHere(LF);

  LevelStack.Restore;

  if TempClass > 0 then
    Gen(OP_END_WITH, 0, 0, 0);
end;

procedure TPaxJavaScriptParser.Parse_WhileStmt;
var
  L, LF, ExprID: Integer;
begin
// match "while"

  L := NewLabel;
  LF := NewLabel;

  SetLabelHere(L);

  Call_SCANNER;
  Match('(');

  Call_SCANNER;
  ExprID := Parse_Expression;

  Match(')');

  Gen(OP_GO_FALSE, LF, ExprID, 0);

  EntryStack.Push(LF, L, StatementLabel);

  Call_SCANNER;
  Parse_Statement;

  EntryStack.Pop;

  Gen(OP_GO, L, 0, 0);

  SetLabelHere(LF);
end;

procedure TPAXJavaScriptParser.Parse_ContinueStmt;
begin
  // match "continue"

  Call_SCANNER;

  if IsCurrText(';') then
    Gen(OP_EXIT, EntryStack.TopContinueLabel, 0, 0)
  else
  begin
    if not (CurrToken.TokenClass = tcId) then
      raise TPAXScriptFailure.Create(errIdentifierExpected);
    Gen(OP_EXIT, EntryStack.TopContinueLabel(CurrToken.Text), 0, 0);
    Call_SCANNER;
  end;

  Match(';');
  Call_SCANNER;
end;

procedure TPAXJavaScriptParser.Parse_BreakStmt;
begin
  // match "break"

  if EntryStack.Count = 0 then
    raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);

  Call_SCANNER;

  if IsCurrText(';') then
    Gen(OP_EXIT, EntryStack.TopBreakLabel, 0, 0)
  else
  begin
    if not (CurrToken.TokenClass = tcId) then
      raise TPAXScriptFailure.Create(errIdentifierExpected);
    Gen(OP_EXIT, EntryStack.TopBreakLabel(CurrToken.Text), 0, 0);
    Call_SCANNER;
  end;

  Match(';');
  Call_SCANNER;
end;

function TPaxJavaScriptParser.Parse_FunctionStmt(ml: TPAXModifierList): Integer;

var
  ParamCount, ArgumentsID, SubID: Integer;

procedure CreateArguments;
const
  MaxArg = 10;
var
  ID_REF,
  L_BREAK,
  L_CONTINUE,
  ID_I, ID_COUNT, ID_COMPARE, ID_VAL: Integer;
begin
  L_BREAK := NewLabel;
  L_CONTINUE := NewLabel;
  ID_I := NewVar;
  ID_COUNT := NewVar;
  ID_COMPARE := NewVar;
  ID_VAL := NewVar;
  Gen(OP_GET_PARAM_COUNT, ID_COUNT, 0, 0);

{  34   Line     5    arguments = new Array();               :20025
   38   CREATE OBJEC     Array[ 2493]                             $$20041
   39     CREATE REF          $$20041                 2      Array[20042]
   40           CALL     Array[20042]                 0           $$20043
   41             := arguments[20040]           $$20043  arguments[20040]
}
  ID_REF := NewVar;
  Name[ID_REF] := 'Array';
  Gen(OP_CREATE_OBJECT, ClassList.FindClassByName('Array').ClassID, 0, ArgumentsID);
  GenRef(ArgumentsID, maAny, ID_REF);
  Gen(OP_CALL, ID_REF, 0, ArgumentsID);

{  41   Line     6    Count = 2;                             :20027
   45             :=     Count[20044]                 2      Count[20044]
   47   Line     7    I = 0;                                 :20027
   51             :=         I[20045]                 0          I[20045]
   53   Line     8    while (I < Count) {                    :20027
   57          <(ex)         I[20045]      Count[20044]           $$20048
   58       GO_FALSE              81^           $$20048
   59   Line     9      arguments[I] = _1;                   :20027
   64           PUSH         I[20045]
   68           PUSH        _1[20030]
   69   PUT PROPERTY arguments[20040]                 2
   71   Line    10      I = I + 1;                           :20027
   76          +(ex)         I[20045]                 1           $$20050
   77             :=         I[20045]           $$20050          I[20045]
   80             GO              53^ }

  Gen(OP_ASSIGN, ID_I, NewConst(0), ID_I);

  SetLabelHere(L_CONTINUE);

  Gen(OP_LT, ID_I, ID_COUNT, ID_COMPARE);
  Gen(OP_GO_FALSE, L_BREAK, ID_COMPARE, 0);
  Gen(OP_GET_PARAM, SubID, ID_I, ID_VAL);
  Gen(OP_PUSH, ID_I, 0, 0);
  Gen(OP_PUSH, ID_VAL, 0, 0);
  Gen(OP_PUT_PROPERTY, ArgumentsID, 2, 0);
  Gen(OP_PLUS, ID_I, NewConst(1), ID_I);
  Gen(OP_GO, L_CONTINUE, 0, 0);

  SetLabelHere(L_BREAK);
end;

function FindLeftSideClassID: Integer;
var
  I, J: Integer;
begin
  result := 0;
  for I:=Code.Card downto 1 do
    if (Code.Prog[I].Op = OP_CREATE_REF) and (Code.Prog[I].Res = LeftSideID) then
    begin
      J := I;
      while Code.Prog[J].Op = OP_CREATE_REF do
        Dec(J);
      Inc(J);
      if Kind[Code.Prog[J].Arg1] = KindTYPE then
      begin
        result := Code.Prog[J].Arg1;
        Exit;
      end
      else
        break;
    end;
  if Kind[LevelStack.Top] = KindSUB then
  begin
    result := LevelStack.Top;
    while Kind[result] <> KindTYPE do
      Dec(result);
  end;
end;

var
  L, I, ID1, ID2, ClassID, AncestorClassID, ResID, PrototypeID, TempCard,
  ParamID, ValID: Integer;
  LeftSideClassID: Integer;
const
  MaxArg = 10;
begin
  // match "function"
  LeftSideClassID := 0;

  Gen(OP_SKIP, 0, 0, 0);
  L := NewLabel;
  Gen(OP_GO, L, 0, 0);

  DeclareSwitch := true;
  Call_SCANNER;

  if IsCurrText('(') then
  begin
    ClassID := NewVar;
    Name[ClassID] := Name[LeftSideID];
    LeftSideClassID := FindLeftSideClassID;
  end
  else
    ClassID := Parse_Ident;
  Kind[ClassID] := KindTYPE;

  AncestorClassID := NewVar;
  Name[AncestorClassID] := 'Function';

  if LeftSideClassID > 0 then
    LevelStack.Push(LeftSideClassID)
  else
    LevelStack.PushClass(ClassID, AncestorClassID, [], ckCLASS, false);

  PrototypeID := NewVar;
  Name[PrototypeID] := 'prototype';
  CurrClassRec.AddField(PrototypeID, [modSTATIC]);

  SubID := NewVar;

  if LeftSideClassID > 0 then
    SymbolTable.Position[SubID] := SymbolTable.Position[LeftSideID]
  else
    SymbolTable.Position[SubID] := SymbolTable.Position[ClassID];

  result := SubID;

  Name[SubID] := Name[ClassID];
  LevelStack.PushSub(SubID, CurrClassID, ml);

  ResID := NewVar;
  NewVar;

  Match('(');
  DeclareSwitch := true;
  Call_SCANNER;
  ParamCount := 0;
  if not IsCurrText(')') then
  repeat
    Inc(ParamCount);
    ParamID := Parse_Ident;

    if IsCurrText('=') then
    begin
      TempCard := SymbolTable.Card;
      Call_SCANNER;
      ValID := Parse_AssignmentExpression;
      with TPaxBaseScripter(Scripter) do
        DefaultParameterList.AddParameter(SubID, ParamID,
                                          SymbolTable.VariantValue[ValID]);
      SymbolTable.EraseTail(TempCard);
    end;

    if IsCurrText(',') then
      Call_SCANNER
    else
      Break;
  until false;
  DeclareSwitch := false;
  Match(')');

  Kind[SubID] := KindSUB;
  Count[SubID] := ParamCount;
  Next[SubID] := ResID;
  TypeSub[SubID] := tsConstructor;
  if Code.Prog[Code.Card].OP = OP_SEPARATOR then
    Value[SubID] := Code.Card
  else
    Value[SubID] := Code.Card + 1;

  Name[CurrThisID] := 'this';
  if LeftSideClassID > 0 then
     TypeID[CurrThisID] := LeftSideClassID
  else
     TypeID[CurrThisID] := ClassID;

  if TPAXJavaScriptScanner(Scanner).UsesIdent('arguments') then
  begin

    for I:=ParamCount + 1 to MaxArg do
    begin
      ID1 := NewVar;
      Name[ID1] := '_' + IntToStr(I);
    end;

    ArgumentsID := NewVar;
    Name[ArgumentsID] := 'arguments';

    CreateArguments;

  end;

{
  if TPAXJavaScriptScanner(Scanner).UsesIdent('this') then
  begin
 //     29   Line     5    this = base.Function();                :20009
//     32     CREATE REF      this[20011]                 1   Function[20013]
//     33           CALL  Function[20013]                 0           $$20014
//     34             :=      this[20011]           $$20014       this[20011]

    ID1 := NewVar;
    ID2 := NewVar;
    Name[ID1] := 'Function';
    GenRef(CurrThisID, maMyBase, ID1);
    Gen(OP_CALL, ID1, 0, ID2);
    Gen(OP_ASSIGN, CurrThisID, ID2, CurrThisID);
  end;
}

  Call_SCANNER;
  Match('{');
  Gen(OP_DECLARE_OFF, 0, 0, 0);

  Parse_Block;

  GenDestroyLocalVars;

  Gen(OP_RET, 0, 0, 0);
  SetLabelHere(L);
  Gen(OP_SAVE_RESULT, ClassID, 0, 0);

  if TPaxBaseScripter(Scripter).EvalCount > 0 then
    Gen(OP_ASSIGN, PrototypeID, FunctionObjectID, PrototypeID)
  else
  begin
    ID1 := NewVar;
    Name[ID1] := 'Function';
    SymbolTable.Level[ID1] := -1;
    Gen(OP_EVAL_WITH, 0, 0, ID1);
    ID2 := NewVar;
    Gen(OP_CREATE_OBJECT, ID1, 0, ID2);
    Gen(OP_CREATE_REF, ID2, 0, ID1);
    Gen(OP_CALL, ID1, 0, ID1);
    Gen(OP_ASSIGN, PrototypeID, ID1, PrototypeID);
  end;

  ID1 := NewField('constructor');
  Gen(OP_CREATE_REF, PrototypeID, 0, ID1);
  Gen(OP_ASSIGN, ID1, ClassID, ID1);

  LevelStack.Pop;
  LevelStack.Pop;

  LinkVariables(SubID, false);

  Call_SCANNER;
end;

procedure TPaxJavaScriptParser.Parse_ReturnStmt;
var
  ResID: Integer;
begin
  // match "return"

  ResID := SymbolTable.GetResultID(CurrLevel);

  Call_SCANNER;

  if not IsCurrText(';') then
      Gen(OP_ASSIGN_RESULT, ResID, Parse_Expression, ResID);

  Gen(OP_RETURN, 0, 0, 0);
end;

procedure TPaxJavaScriptParser.Parse_HaltStmt;
begin
  // match "halt"
  Call_SCANNER;
  if not IsCurrText(';') then
    Call_SCANNER;
  Gen(OP_HALT_GLOBAL, 0, 0, 0);
end;

procedure TPaxJavaScriptParser.Parse_SwitchStmt;

procedure Match(const S: String);
begin
  Self.Match(S);
  Call_SCANNER;
end;

var
  lg, l_default, bool_id, expr_id, case_expr_id, lf, l_skip, I, N1, N2: Integer;
  lt: TPaxStack;
  n_skips: TPaxIds;
begin
	lg := NewLabel();
	l_default := NewLabel();

	lt := TPaxStack.Create;
  n_skips := TPaxIds.Create(true);

	bool_id := NewVar();
	Gen(OP_ASSIGN, bool_id, symboltable.IDTRUE, bool_id);
  EntryStack.Push(lg, 0, StatementLabel);

	Match('switch');
	Match('(');
	expr_id := Parse_Expression();
	Match(')');
	Match('{'); // parse switch block

  repeat // parse switch sections

    repeat // parse switch labels
      if (IsCurrText('case')) then
      begin
        Match('case');

        lt.Push(NewLabel());
        case_expr_id := Parse_Expression();
        Gen(OP_EQ, expr_id, case_expr_id, bool_id);
        Gen(OP_GO_TRUE, lt.Top(), bool_id, 0);
      end
      else if (IsCurrText('default')) then
      begin
        Match('default');
        SetLabelHere(l_default);
        Gen(OP_ASSIGN, bool_id, symboltable.IDTRUE, bool_id);
      end
      else
        break; //switch labels
      Match(':');
    until false;

    while (lt.Card > 0) do
      SetLabelHere(lt.Pop());

    lf := NewLabel();
    Gen(OP_GO_FALSE, lf, bool_id, 0);

    // parse statement list
    repeat
      if (IsCurrText('case')) then
        break;
      if (IsCurrText('default')) then
        break;
      if (IsCurrText('}')) then
        break;

      l_skip := NewLabel();
      SetLabelHere(l_skip);
      Parse_Statement;
      Gen(OP_GO, l_skip, 0, 0);
      n_skips.Add(Code.Card);

    until false;
    SetLabelHere(lf);

    if (IsCurrText('}')) then
      break;
  until false;

	EntryStack.Pop();
	SetLabelHere(lg);
	Match('}');

  if n_skips.Count >= 2 then
  for I:=0 to n_skips.Count - 2 do
  begin
    N1 := n_skips[I];
    N2 := n_skips[I+1];
    Code.Prog[N1].Arg1 := Code.Prog[N2].Arg1;
  end;
  N1 := n_skips[n_skips.Count - 1];
  Code.Prog[N1].Op := OP_NOP;

  lt.Free;
  n_skips.Free;
end;

procedure TPaxJavaScriptParser.Parse_WithStmt;
var
  ID, ID2: Integer;
begin
  // match "with"
  Call_SCANNER;
  Match('(');
  Call_SCANNER;
  ID := Parse_Expression;
  if IsCallOperator then
  begin
    ID2 := NewVar;
    Gen(OP_ASSIGN, ID2, ID, ID2);
    Gen(OP_BEGIN_WITH, WithStack.Push(ID2), 0, 0);
  end
  else
    Gen(OP_BEGIN_WITH, WithStack.Push(ID), 0, 0);
  Match(')');

  Call_SCANNER;
  Parse_Statement;

  Gen(OP_END_WITH, 0, 0, 0);
  WithStack.Pop;
end;

procedure TPaxJavaScriptParser.Parse_ThrowStmt;
var
  ID: Integer;
begin
  // match "throw"

  Call_SCANNER;

  if IsCurrText(';') then
  begin
    ID := 0;
    Call_SCANNER;
  end
  else
  begin
    ID := Parse_Expression;
  end;
  Gen(OP_THROW, ID, 0, 0);
end;

procedure TPaxJavaScriptParser.Parse_TryStmt;
var
  L, LTRY, ID: Integer;
begin
  // match "try"

  LTRY := NewLabel;
  Gen(OP_TRY_ON, LTRY, 0, 0);

  Call_SCANNER;
  Parse_Block;
  Call_SCANNER;

  L := NewLabel;
  Gen(OP_GO, L, 0, 0);

  if  not IsCurrText('catch') or IsCurrText('finally') then
    Match('catch');

  while IsCurrText('catch') do
  begin
    Call_SCANNER;
    Match('(');
    DeclareSwitch := true;
    Call_SCANNER;
    ID := Parse_Ident;
    Gen(OP_CATCH, ID, 0, 0);
    DeclareSwitch := false;
    Match(')');

    CurrClassRec.AddField(ID, [modSTATIC]);

    Call_SCANNER;
    Parse_Block;
    Call_SCANNER;

    Gen(OP_DISCARD_ERROR, 0, 0, 0);
  end;

  SetLabelHere(L);

  if IsCurrText('finally') then
  begin
    Gen(OP_FINALLY, 0, 0, 0);
    Call_SCANNER;
    Parse_Block;
    Call_SCANNER;
    Gen(OP_EXIT_ON_ERROR, 0, 0, 0);
  end;

  SetLabelHere(LTRY);
  Gen(OP_TRY_OFF, 0, 0, 0);
end;

function TPaxJavaScriptParser.Parse_VarStmt(IsField: Boolean;
                                            ml: TPAXModifierList;
                                            IsLoopVar: Boolean = false): Integer;
begin
  DeclareSwitch := true;

  DuplicateVars := true;
  Call_SCANNER;
  DuplicateVars := false;

  result := Parse_VariableDeclaration(IsField, ml, IsLoopVar);

  while IsCurrText(',') do
  begin
    DeclareSwitch := true;

    Call_SCANNER;
    result := Parse_VariableDeclaration(IsField, ml, IsLoopVar);
  end;

  DeclareSwitch := false;
end;

function TPaxJavaScriptParser.Parse_VariableDeclaration(IsField: Boolean;
                                                        ml: TPAXModifierList;
                                                        IsLoopVar: Boolean = false): Integer;
var
  ID, ArrID, Vars: Integer;
  MemberRec: TPAXMemberRec;
  S: String;
begin
  MemberRec := nil;

  result := Parse_Ident;

  if IsField then
    MemberRec := CurrClassRec.AddField(result, ml)
  else if (CurrClassID > 0) and (CurrSubID = 0) then
    CurrClassRec.AddField(result, ml + [modSTATIC])
  else if CurrSubID > 0 then
  begin
    S := SymbolTable.Name[result];
    SymbolTable.DecCard;
    ID := SymbolTable.LookUpID(S, CurrSubId);
    SymbolTable.IncCard;
    if ID > 0 then
    begin
      if ID <> result then
        SymbolTable.Name[result] := '';
      result := ID;
    end
    else
    SymbolTable.SetLocal(result);

    LocalVars.Add(result);
  end;

  if IsCurrText('[') then
  begin
    if MemberRec <> nil then
      MemberRec.InitN := LastCodeLine;

    DeclareSwitch := false;
    Call_SCANNER;
    ArrID := 0;
    Gen(OP_CREATE_ARRAY, result, Parse_ArgumentList(ArrID, Vars), 0);

    if MemberRec <> nil then
       Gen(OP_HALT, 0, 0, 0);

    Match(']');
    Call_SCANNER;
  end
  else if IsCurrText('=') then
  begin
    Gen(OP_NOP, 0, 0, 0);

    if (MemberRec <> nil) and (not IsLoopVar) then
      MemberRec.InitN := LastCodeLine;

    DeclareSwitch := false;
    Call_SCANNER;

    LeftSideID := result;

    ID := Parse_AssignmentExpression;

    if ID = UndefinedID then
      Gen(OP_DESTROY_INTF, result, 0, 0);

    Gen(OP_ASSIGN, result, ID, result);
    if (MemberRec <> nil) and (not IsLoopVar) then
       Gen(OP_HALT, 0, 0, 0);

    TempObjectList.Clear;
  end;
end;

procedure TPaxJavaScriptParser.Parse_ExpressionStmt;
begin
  Gen(OP_SAVE_RESULT, Parse_Expression, 0, 0);
end;

procedure TPaxJavaScriptParser.Parse_StmtList;
begin
  repeat
    if CurrToken.ID = SP_POINT then
      Exit
    else if CurrToken.ID = SP_EOF then
      Exit
    else
      Parse_Statement;
  until false;
  IsExecutable := true;
  Gen(OP_SKIP, 0, 0, 0);
  IsExecutable := false;
end;

procedure TPaxJavaScriptParser.Parse_SourceElements;
begin
  repeat
    if CurrToken.ID = SP_POINT then
      Exit
    else if CurrToken.ID = SP_EOF then
      Exit
    else
      Parse_Statement;
  until false;
end;

procedure TPaxJavaScriptParser.CreateGlobalObjects;
var
  ID: Integer;
begin
  ID := NewVar;
  Name[ID] := 'Function';
  SymbolTable.Level[ID] := -1;
  Gen(OP_EVAL_WITH, 0, 0, ID);
  FunctionObjectID := NewVar;
  Gen(OP_CREATE_OBJECT, ID, 0, FunctionObjectID);
  Gen(OP_CREATE_REF, FunctionObjectID, 0, ID);
  Gen(OP_CALL, ID, 0, ID);
  Gen(OP_ASSIGN, FunctionObjectID, ID, FunctionObjectID);
end;

procedure TPaxJavaScriptParser.GenDestroyLocalVars;
var
  I, J, ID, SubID: Integer;
//  ok: Boolean;
begin
  SubID := LevelStack.Top;
  for I := LocalVars.Count - 1 downto 0 do
  begin
    ID := LocalVars[I];
    if SymbolTable.Level[ID] = SubID then
    if SymbolTable.GetResultID(SubId) <> ID then
    begin
//      ok := false;
      for J:=1 to Code.Card do
        if (Code.Prog[J].Op = OP_ASSIGN_RESULT) and (Code.Prog[J].Arg2 = ID) then
        begin
//          ok := true;
          break;
        end;

//      if not ok then
//        Gen(OP_DESTROY_OBJECT, ID, 0, 0);
        
      LocalVars.Delete(I);
    end;
  end;
end;


procedure TPaxJavaScriptParser.Parse_Program;
begin
  if CurrToken.ID = SP_EOF then
    Exit;

  if DeclareVariables then
    Gen(OP_DECLARE_ON, 0, 0, 0)
  else
    Gen(OP_DECLARE_OFF, 0, 0, 0);

  if VBArrays then
    Gen(OP_VBARRAYS_ON, 0, 0, 0)
  else
    Gen(OP_VBARRAYS_OFF, 0, 0, 0);

  Gen(OP_UPCASE_OFF, 0, 0, 0);
  Gen(OP_JS_OPERS_ON, 0, 0, 0);

  if ZeroBasedStrings then
    Gen(OP_ZERO_BASED_STRINGS_ON, 0, 0, 0)
  else
    Gen(OP_ZERO_BASED_STRINGS_OFF, 0, 0, 0);

  CreateGlobalObjects;

  Parse_SourceElements;
end;

end.

