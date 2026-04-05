////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: PAX_C.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit PAX_C;

interface

uses
  SysUtils, Classes,
  BASE_CONSTS,
  BASE_SYS, BASE_SCANNER, BASE_PARSER, BASE_SCRIPTER, BASE_EXTERN, BASE_CLASS;

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
  TSCScanner = class(TPAXScanner)
  public
    procedure ReadToken; override;
  end;

  TPAXCParser = class(TPAXParser)
  private
    ConstIds: TPAXIds;
    procedure ScanFIELD;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Reset; override;
    procedure Call_SCANNER; override;
    function IsBaseType(const S: String): Boolean; override;

    function Parse_EvalExpression: Integer; override;
    function Parse_ArgumentExpression: Integer; override;

    function Parse_PrimaryExpression: Integer;
    function Parse_ObjectLiteral: Integer;
    function Parse_MemberExpression(ID: Integer; IsConstructor: boolean = false): Integer;
    function Parse_NewExpression: Integer;
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
    procedure Parse_FunctionStmt(ml: TPAXModifierList;
                                 T: Integer = typeVARIANT;
                                 const DllName: String = '');
    procedure Parse_ReturnStmt;
    procedure Parse_HaltStmt;
    procedure Parse_VarStmt(IsField: Boolean; ml: TPAXModifierList;
                            T: Integer = 0;
                            IsLoopVar: Boolean = false);
    function Parse_VariableDeclaration(IsField: Boolean;
                       ml: TPAXModifierList; T: Integer;
                       IsLoopVar: Boolean = false): Integer;
    function Parse_ClassStmt(ClassML: TPAXModifierList; ck: TPAXClassKind): Integer;
    function Parse_EnumStmt: Integer;
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

    procedure Parse_Program; override;
  end;


implementation

procedure TSCScanner.ReadToken;
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
        end
      end;
      '%':
      case ScannerState of
        scanText:
          raise TPAXScriptFailure.Create(errIllegalCharacter);
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
      '''': ScanString('''');
      '"': ScanString('"');
    else
      raise TPAXScriptFailure.Create(errIllegalCharacter);
    end;

    if Token.TokenClass <> tcNone then
      Exit;

  until false;
end;

constructor TPAXCParser.Create;
begin
  ConstIds := TPAXIds.Create(false);
  inherited;

  Scanner := TSCScanner.Create(Self);

  UpCase := false;

  with Keywords do
  begin
    Add('base');
    Add('break');
    Add('bool');
    Add('byte');
    Add('case');
    Add('catch');
    Add('cdecl');
    Add('class');
    Add('const');
    Add('continue');
    Add('delete');
    Add('do');
    Add('double');
    Add('else');
    Add('extern');
    Add('false');
    Add('finally');
    Add('for');
    Add('function');
    Add('get');
    Add('goto');
    Add('enum');
    Add('if');
    Add('in');
    Add('int');
    Add('long');
    Add('float');
    Add('decimal');
    Add('namespace');
    Add('new');
    Add('operator');
    Add('override');
    Add('out');
    Add('pascal');
    Add('public');
    Add('private');
    Add('ref');
    Add('reduced');
    Add('register');
    Add('return');
    Add('safecall');
    Add('sbyte');
    Add('set');
    Add('short');
    Add('static');
    Add('stdcall');
    Add('string');
    Add('structure');
    Add('switch');
//    Add('THIS');
    Add('throw');
    Add('true');
    Add('try');
    Add('typeof');
    Add('var');
    Add('virtual');
    Add('void');
    Add('ushort');
    Add('using');
    Add('while');
    Add('with');

    Add('print');
    Add('println');
    Add('property');
    Add('uint');
    Add('variant');
  end;
end;

destructor TPAXCParser.Destroy;
begin
  ConstIds.Free;
  inherited;
end;

procedure TPAXCParser.Reset;
begin
  inherited;
  ConstIds.Clear;
end;


procedure TPAXCParser.Call_SCANNER;
var
  S: String;
  TempID: Integer;
begin
  inherited;

  if CurrToken.TokenClass in [tcId, tcKeyword] then
  begin
     if IsCurrText('null') then
     begin
       CurrToken.ID := UndefinedID;
       CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('int') then
    begin
      CurrToken.ID := typeINTEGER;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('uint') then
    begin
      CurrToken.ID := typeCARDINAL;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('byte') then
    begin
      CurrToken.ID := typeBYTE;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('sbyte') then
    begin
      CurrToken.ID := typeSHORTINT;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('short') then
    begin
      CurrToken.ID := typeSMALLINT;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('ushort') then
    begin
      CurrToken.ID := typeWORD;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('long') then
    begin
      CurrToken.ID := typeINT64;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('bool') then
    begin
      CurrToken.ID := typeBOOLEAN;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('double') then
    begin
      CurrToken.ID := typeDOUBLE;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('string') then
    begin
      CurrToken.ID := typeSTRING;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('float') then
    begin
      CurrToken.ID := typeSINGLE;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('decimal') then
    begin
      CurrToken.ID := typeCURRENCY;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('variant') then
    begin
      CurrToken.ID := typeVARIANT;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('void') then
    begin
      CurrToken.ID := typeVARIANT;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('set') then
    begin
      CurrToken.ID := typeSET;
      CurrToken.TokenClass := tcId;
    end
    else
    begin
      S := FindTypeAlias(CurrToken.Text, UpCase);
      if S <> '' then
      begin
        CurrToken.Text := S;
        TempID := SymbolTable.LookUpID(S, 0, UpCase);
        if TempID > 0 then
          CurrToken.ID := TempID
        else
          Name[CurrToken.ID] := S;
      end;
    end;
  end;
end;

function TPAXCParser.IsBaseType(const S: String): Boolean;
begin
  result := inherited IsBaseType(S);
  if result then
    Exit;
  result := (S = 'int') or
            (S = 'uint') or
            (S = 'sbyte') or
            (S = 'short') or
            (S = 'ushort') or
            (S = 'long') or
            (S = 'bool') or
            (S = 'double') or
            (S = 'string') or
            (S = 'variant') or
            (S = 'void') or
            (S = 'set');
end;

procedure TPAXCParser.ScanFIELD;
begin
  FieldSwitch := true;
  Call_SCANNER;
  if IsCurrText('~') then
  begin
    FieldSwitch := true;
    Call_SCANNER;
    CurrToken.Text := '~' + CurrToken.Text;
    CurrToken.ID := SymbolTable.Card;
    Name[CurrToken.ID] := CurrToken.Text;
  end;
end;

function TPAXCParser.Parse_EvalExpression: Integer;
begin
  result := Parse_LeftHandSideExpression;
end;

function TPAXCParser.Parse_ArgumentExpression: Integer;
begin
  result := Parse_AssignmentExpression;
end;

///////  EXPRESSIONS /////////////////////////////////////////////////////////

function TPAXCParser.Parse_PrimaryExpression: Integer;
var
  SubID, ID: Integer;
  IsArrayItem: Boolean;
  CallRec: TPaxCallRec;
  T: Integer;
begin
  if IsCurrText('(') then // (Expression)
  begin
    Call_SCANNER;
    result := Parse_Expression;
    Match(')');
    Call_SCANNER;

    if CurrToken.TokenClass <> tcSpecial then // type cast
    begin
      T := result;
      result := NewVar;
      Gen(OP_PUSH, Parse_UnaryExpression(0), 0, 0);
      Gen(OP_CALL, T, 1, result);

      CallRec := TPaxCallRec.Create;
      CallRec.CallP := Scanner.PosNumber;
      CallRec.CallN := Code.Card;
      TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);
    end;
  end
  else if IsCurrText('base') then // (base access)
  begin
    if CurrClassID = 0 then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);
    if CurrSubID <> CurrMethodID then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);

    Call_SCANNER;
    Match('.');
    ScanFIELD;
//    FieldSwitch := true;
//    Call_SCANNER;
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
      ScanFIELD;
//      FieldSwitch := true;
//      Call_SCANNER;
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
    result := Parse_Ident;
    GenEvalWith(result);
  end;
end;

function TPAXCParser.Parse_ObjectLiteral: Integer;
begin
  result := 0;
end;

function TPAXCParser.Parse_MemberExpression(ID: Integer; IsConstructor: boolean = false): Integer;
var
  SubID, RefID, Vars, Rank, K: Integer;
  CallRec: TPaxCallRec;
label
  Again;
begin
  if ID = 0 then
    result := Parse_PrimaryExpression
  else
    result := ID;

  Rank := SymbolTable.Rank[result];
  while CurrToken.Text[1] in ['(','[','.'] do
    case CurrToken.Text[1] of
      '[':
      begin
//        if Rank = -1 then
//          raise TPaxScriptFailure.Create(errCannotApplyToScalar);

        SubID := result;
        result := NewVar;

        Call_SCANNER;
        K := Parse_ArgumentList(SubID, Vars, true, false);
        Gen(OP_CALL, SubID, K, result);
        SetVars(Vars);

        Match(']');

        if (Rank > 0) and (K <> Rank) then
           raise TPaxScriptFailure.Create(errRankMismatch);

        Call_SCANNER;
      end;
      '.':
      begin
        ScanFIELD;
//        FieldSwitch := true;
//        Call_SCANNER;

        if IsKeyword(CurrToken.Text) then
        begin
          RefID := NewVar;
          Name[RefID] := CurrToken.Text;
          Call_SCANNER;
        end
        else
          RefID := Parse_Ident;

        GenRef(result, maAny, RefID);
        result := RefID;

        if not (CurrToken.Text[1] in ['(', '[']) then
          Gen(OP_CALL, result, 0, result);
      end;
      '(':
      begin
        SubID := result;
        result := NewVar;

        Call_SCANNER;
        if IsCurrText(')') then
        begin
          if IsConstructor then
            Gen(OP_CALL_CONSTRUCTOR, SubID, 0, result)
          else
            Gen(OP_CALL, SubID, 0, result);
          CallRec := TPaxCallRec.Create;
          CallRec.CallP := Scanner.PosNumber;
          CallRec.CallN := Code.Card;
          TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);
        end
        else
        begin
          if IsConstructor then
            Gen(OP_CALL_CONSTRUCTOR, SubID, Parse_ArgumentList(SubID, Vars), result)
          else
            Gen(OP_CALL, SubID, Parse_ArgumentList(SubID, Vars), result);
          SetVars(Vars);
        end;
        IsConstructor := false;

        Match(')');

        Call_SCANNER;
      end;
    end;
end;

function TPAXCParser.Parse_NewExpression: Integer;
var
  ClassID, ObjectID, RefID: Integer;
begin
  if IsCurrText('new') then
  begin
    Call_SCANNER;
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
      result := Parse_MemberExpression(result, true);
    end
    else
      result := ObjectID;
  end
  else
    result := Parse_MemberExpression(0);
end;

function TPAXCParser.Parse_LeftHandSideExpression: Integer;
begin
  result := Parse_NewExpression;
end;

function TPAXCParser.Parse_PostfixExpression(Left: Integer): Integer;
var
  temp, r: Integer;
begin
  if Left <> 0 then
    result := Left
  else
    result := Parse_LeftHandSideExpression;

  if CurrToken.ID = SP_INC then
  begin
    Call_SCANNER;
    temp := NewVar();
    Gen(OP_ASSIGN, temp, result, temp);
    r := NewVar();
    Gen(OP_PLUS, result, NewConst(1), r);
    Gen(OP_ASSIGN, result, r, result);
    result := temp;
  end
  else if CurrToken.ID = SP_DEC then
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

function TPAXCParser.Parse_UnaryExpression(Left: Integer): Integer;
begin
  if Left <> 0 then
  begin
    result := Parse_PostfixExpression(Left);
    Exit;
  end;

  if CurrToken.ID = SP_INC then
  begin
    Call_SCANNER;
    result := Parse_UnaryExpression(0);
    GEN(OP_PLUS, result, NewConst(1), result);
  end
  else if CurrToken.ID = SP_DEC then
  begin
    Call_SCANNER;
    result := Parse_UnaryExpression(0);
    GEN(OP_MINUS, result, NewConst(1), result);
  end
  else if CurrToken.ID = OP_DESTROY_OBJECT then
  begin
    Call_SCANNER;
    result := Parse_UnaryExpression(0);
    GEN(OP_DESTROY_HOST, result, 0, 0);
    GEN(OP_DESTROY_OBJECT, result, 0, 0);
  end
  else if CurrToken.ID = OP_PLUS then
  begin
    result := NewVar;
    Call_SCANNER;
    Gen(OP_UNARY_PLUS, Parse_UnaryExpression(0), 0, result);
  end
  else if CurrToken.ID = OP_MINUS then
  begin
    result := NewVar;
    Call_SCANNER;
    Gen(OP_UNARY_MINUS, Parse_UnaryExpression(0), 0, result);
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
  else if IsCurrText('(') then
    result := Parse_PrimaryExpression
  else
    result := Parse_PostfixExpression(0);
end;

function TPAXCParser.Parse_MultiplicativeExpression(Left: Integer): Integer;
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

function TPAXCParser.Parse_AdditiveExpression(Left: Integer): Integer;
var
  OP, ResID: Integer;
begin
  ResID := 0;
  result := Parse_MultiplicativeExpression(Left);

  while (CurrToken.ID = OP_PLUS) or
        (CurrToken.ID = OP_MINUS) do
  begin
    OP := CurrToken.ID;

    if ResID = 0 then
      ResID := NewVar;

    Call_SCANNER;
    Gen(OP, result, Parse_MultiplicativeExpression(0), ResID);
    result := ResID;
  end;
end;

function TPAXCParser.Parse_ShiftExpression(Left: Integer): Integer;
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

function TPAXCParser.Parse_RelationalExpression(Left: Integer): Integer;
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

function TPAXCParser.Parse_EqualityExpression(Left: Integer): Integer;
var
  OP, ResID: Integer;
begin
  ResID := 0;
  result := Parse_RelationalExpression(Left);

  while (CurrToken.ID = OP_EQ) or
        (CurrToken.ID = OP_NE) or
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

function TPAXCParser.Parse_BitwiseANDExpression(Left: Integer): Integer;
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

function TPAXCParser.Parse_BitwiseXORExpression(Left: Integer): Integer;
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

function TPAXCParser.Parse_BitwiseORExpression(Left: Integer): Integer;
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

function TPAXCParser.Parse_LogicalANDExpression(Left: Integer): Integer;
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

function TPAXCParser.Parse_LogicalORExpression(Left: Integer): Integer;
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

function TPAXCParser.Parse_ConditionalExpression(Left: Integer): Integer;
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

function TPAXCParser.Parse_AssignmentExpression: Integer;
var
  OP, Arg1, Arg2, Res, L1, L2, RightID: Integer;
  IsreducedAssignment: Boolean;
begin
  if IsCurrText('delete') or
     IsCurrText('(') or
     (CurrToken.ID = SP_INC) or
     (CurrToken.ID = SP_DEC) or
     (CurrToken.ID = OP_PLUS) or
     (CurrToken.ID = OP_MINUS) or
     (CurrToken.ID = SP_BITWISE_NOT) or
     (CurrToken.ID = SP_LOGICAL_NOT) then
  begin
    result := Parse_ConditionalExpression(0);
    Exit;
  end;

  L1 := LastCodeLine + 1;

  Gen(OP_NOP, 0, 0, 0);

  IsreducedAssignment := false;
  if IsCurrText('reduced') then
  begin
    IsreducedAssignment := true;
    Call_SCANNER;
    result := Parse_LeftHandSideExpression;
  end
  else
    result := Parse_LeftHandSideExpression;

  if CurrToken.TokenClass <> tcSpecial then
    Match('=');

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
       Code.Prog[LastCodeLine].Op := OP_GET_ITEM;
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

     RightID := Parse_AssignmentExpression;
     Gen(OP_ASSIGN, result, RightID, result);

     if ConstIds.IndexOf(result) <> -1 then
        raise TPAXScriptFailure.Create(errCannotAssignConstant + SymbolTable.Name[result]);
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
    begin
      Gen(OP, result, Parse_AssignmentExpression, result);

      if ConstIds.IndexOf(result) <> -1 then
        raise TPAXScriptFailure.Create(errCannotAssignConstant + SymbolTable.Name[result]);
    end;
  end
  else
    result := Parse_ConditionalExpression(result);
end;

function TPAXCParser.Parse_Expression: Integer;
begin
  result := Parse_AssignmentExpression;
  while CurrToken.ID = SP_COMMA do
  begin
    Call_SCANNER;
    result := Parse_AssignmentExpression;
  end;
end;

///////  STATEMENTS /////////////////////////////////////////////////////////

function TPAXCParser.Parse_ModifierList: TPAXModifierList;
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
  if IsCurrText('virtual') then
  begin
    result := result + [modVIRTUAL];
    Call_SCANNER;
    Goto Again;
  end;
  if IsCurrText('override') then
  begin
    result := result + [modVIRTUAL];
    Call_SCANNER;
    Goto Again;
  end;
end;

procedure TPAXCParser.Parse_Statement;
var
  ml: TPAXModifierList;
  DllName: String;
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
    IsExecutable := true;
    Parse_VarStmt(false, ml);
    IsExecutable := false;
    Match(';');
    Call_SCANNER;
  end
  else if IsCurrText('const') then
  begin
    IsExecutable := true;
    Parse_VarStmt(false, ml);
    IsExecutable := false;
    Match(';');
    Call_SCANNER;
  end
  else if IsCurrText('class') then
    Parse_ClassStmt(ml, ckClass)
  else if IsCurrText('structure') then
    Parse_ClassStmt(ml, ckStructure)
  else if IsCurrText('enum') then
    Parse_EnumStmt
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
  else if IsCurrText('extern') then
  begin
    Call_SCANNER;
    DllName := Value[CurrToken.ID];
    Call_SCANNER;

    if IsCurrText('function') then
      Parse_FunctionStmt(ml, typeVARIANT, DllName)
    else if IsNext2Text('(') or (NextToken.TokenClass = tcKeyword) then
      Parse_FunctionStmt(ml, CurrToken.ID, DllName)
    else
      Match('function');
  end
  else if (CurrToken.TokenClass = tcID) and (NextToken.TokenClass = tcId) then
  begin
    if IsNext2Text('(') then
      Parse_FunctionStmt(ml, CurrToken.ID)
    else
    begin
      IsExecutable := true;
      Parse_VarStmt(false, ml, CurrToken.ID);
      IsExecutable := false;
      Match(';');
      Call_SCANNER;
    end;
  end
  else if (CurrToken.TokenClass = tcID) and IsNextText('[') and
          (IsNext2Text(']') or IsNext2Text(',')) then
  begin
    IsExecutable := true;
    Parse_VarStmt(false, ml, CurrToken.ID);
    IsExecutable := false;
    Match(';');
    Call_SCANNER;
  end
  else
  begin
    IsExecutable := true;
    Parse_ExpressionStmt;
    IsExecutable := false;
    Match(';');
    Call_SCANNER;
  end;

  GenDestroyArrayArgumentList;
end;

procedure TPAXCParser.Parse_Block;
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
  Gen(OP_NOP, 0, 0, 0);
  IsExecutable := false;
  
  Match('}');
end;

procedure TPAXCParser.Parse_NamespaceStmt(ml: TPAXModifierList);
var
  NamespaceID: Integer;
begin
  // match "namespace"
  CurrClassRec.UsingInitList.Add(LastCodeLine);

  Call_SCANNER;
  NamespaceID := Parse_Ident;

  TPAXBaseScripter(Scripter).Modules.Items[ModuleID].Namespaces.Add(NamespaceID);

  Kind[NamespaceID] := KindTYPE;

  LevelStack.PushClass(NamespaceID, 0, ml + [modSTATIC], ckClass, false);

  Match('{');
  Gen(OP_USE_NAMESPACE, UsingList.PushUnique(NamespaceID), 0, 0);
  Gen(OP_HALT_OR_NOP, 0, 0, 0);

  Parse_Block;
  Gen(OP_END_OF_NAMESPACE, NamespaceID, 0, 0);

  Call_SCANNER;

  LevelStack.Pop;
  UsingList.Delete(NamespaceID);
end;

procedure TPAXCParser.Parse_IfStmt;
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

procedure TPAXCParser.Parse_DoStmt;
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

procedure TPAXCParser.Parse_ForStmt;
var
  LF, L, LStatement, LIncrement, TempClass: Integer;
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
  if not IsCurrText(';') then
  begin
    if IsCurrText('var') then
    begin
      if CurrSubID = 0 then
        TempClass := LevelStack.PushTempClass;
      Parse_VarStmt(false, [], 0, true);
      if CurrSubID = 0 then
        Gen(OP_BEGIN_WITH, TempClass, 0, 0);
    end
    else if (CurrToken.TokenClass = tcID) and (NextToken.TokenClass = tcId) then
    begin
      if CurrSubID = 0 then
        TempClass := LevelStack.PushTempClass;
      Parse_VarStmt(false, [], CurrToken.ID, true);
      if CurrSubID = 0 then
        Gen(OP_BEGIN_WITH, TempClass, 0, 0);
    end
    else
    begin
      Parse_Expression;
    end;
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

procedure TPAXCParser.Parse_WhileStmt;
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

procedure TPAXCParser.Parse_ContinueStmt;
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

procedure TPAXCParser.Parse_BreakStmt;
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

procedure TPAXCParser.Parse_FunctionStmt(ml: TPAXModifierList;
                                         T: Integer = typeVARIANT;
                                         const DllName: String = '');
var
  L, RefID, SubID, ResID, ParamCount, PropID, WithCount, ParamID, ParamTypeID,
  Vars: Integer;
  PropertyRec: TPAXMemberRec;
  IsDestructor: Boolean;
  cc, _SaveLevelCard: Integer;
  TypeIndex: Integer;
  TempCard, ValID: Integer;
  CallRec: TPaxCallRec;
  TypeName: String;
  ByRef: Boolean;
  Rank: Integer;
  sign: Integer;
begin
  _SaveLevelCard := LevelStack.Card;
  cc := Parse_CallConv;

  // match "function"
  Gen(OP_SKIP, 0, 0, 0);
  L := NewLabel;
  Gen(OP_GO, L, 0, 0);

  IsDestructor := false;

  DeclareSwitch := true;

  if cc < 0 then
  begin
    cc := DefaultCallConv;
    Call_SCANNER;
  end
  else
  begin
    CurrToken.ID := NewVar;
    SymbolTable.Name[CurrToken.ID] := CurrToken.Text;
  end;

  if IsCurrText('~') then
  begin
    IsDestructor := true;
    Call_SCANNER;
    Match(CurrClassRec.Name);

    CurrToken.Text := '~' + CurrToken.Text;
    CurrToken.ID := SymbolTable.Card;
    Name[CurrToken.ID] := CurrToken.Text;

    CurrClassRec.AutoDestructorID := CurrToken.ID;
  end;

  PropertyRec := nil;
  if IsCurrText('get') then
  begin
    Call_SCANNER;
    PropID := Parse_Ident;
    Kind[PropID] := KindPROP;
    PropertyRec := CurrClassRec.AddProperty(PropID, ml);
    SubID := NewVar;
    PropertyRec.ReadID := SubID;

    Name[SubID] := Name[PropID] + '_get';
  end
  else if IsCurrText('set') then
  begin
    Call_SCANNER;
    PropID := Parse_Ident;
    PropertyRec := CurrClassRec.AddProperty(PropID, ml);
    SubID := NewVar;
    PropertyRec.WriteID := SubID;

    Name[SubID] := Name[PropID] + '_set';
  end
  else if IsCurrText('operator') then
  begin
    Call_SCANNER;
    SubID := Parse_OverloadableOperator;
  end
  else
    SubID := Parse_Ident;

  LevelStack.PushSub(SubID, CurrClassID, ml);

  ResID := NewVar;
  NewVar;

  TypeID[SubID] := T;
  TypeID[ResID] := T;

  Gen(OP_BEGIN_METHOD, SubId, 0, 0);

  Match('(');

  DeclareSwitch := true;

  ParamCount := 0;
  if IsNextText(')') then
    Call_SCANNER
  else
    repeat
      Call_SCANNER;
      Inc(ParamCount);

      ByRef := IsCurrText('ref') or IsCurrText('out');
      if ByRef then
        Call_SCANNER;

      TypeIndex := 0;
      TypeName := 'variant';

      Rank := 0;
      if (NextToken.TokenClass = tcID) or (NextToken.Text = '[') then
      begin
        ParamTypeID := CurrToken.ID;
        TypeName := CurrToken.Text;

        if NewID then
        begin
          SymbolTable.DecCard;
          TypeIndex := CreateNameIndex(CurrToken.Text, Scripter);
          ParamTypeID := typeVARIANT;
        end
        else
          if ParamTypeID > PaxTypes.Count then
            TypeIndex := CreateNameIndex(CurrToken.Text, Scripter);

        if NextToken.Text = '[' then
        begin
          Call_SCANNER;
          Rank := Parse_Rank;
        end
        else
        begin
          if (ParamTypeID <= PaxTypes.Count) and (ParamTypeID > 0) and (ParamTypeID <> typeVARIANT) then
            Rank := -1
          else
            Rank := 0;

          Call_SCANNER;
        end;
      end
      else
        ParamTypeID := typeVARIANT;

      ParamID := Parse_Ident;
      SymbolTable.Rank[ParamID] := Rank;

      if ByRef then
        SymbolTable.ByRef[ParamID] := 1;

      TypeID[ParamID] := ParamTypeID;
      SymbolTable.TypeNameIndex[ParamID] := TypeIndex;

      Gen(OP_SET_TYPE, ParamID, TypeIndex, 0);

      if IsCurrText('=') then
      begin
        TempCard := SymbolTable.Card;
        Call_SCANNER;

        if IsCurrText('-') then
        begin
          sign := -1;
          Call_SCANNER;
        end
        else
          sign := 1;


        ValID := Parse_AssignmentExpression;
        with TPaxBaseScripter(Scripter) do
        begin
          if sign = - 1 then
            DefaultParameterList.AddParameter(SubID, ParamID, - SymbolTable.VariantValue[ValID])
          else
            DefaultParameterList.AddParameter(SubID, ParamID, SymbolTable.VariantValue[ValID]);
        end;
        SymbolTable.EraseTail(TempCard);
      end;

      if not IsCurrText(',') then
        Break;
    until false;

  if PropertyRec <> nil then
    PropertyRec.NParams := ParamCount;

  DeclareSwitch := false;

  Match(')');

  Kind[SubID] := KindSUB;
  Count[SubID] := ParamCount;
  Next[SubID] := ResID;

  if CurrClassID > 0 then
  begin
    if IsDestructor then
      TypeSub[SubID] := tsDestructor
    else if Name[SubID] = Name[CurrClassID] then
      TypeSub[SubID] := tsConstructor
    else
      TypeSub[SubID] := tsMethod;
  end
  else
    TypeSub[SubID] := tsGlobal;

  if Code.Prog[Code.Card].OP = OP_SEPARATOR then
    Value[SubID] := Code.Card
  else
    Value[SubID] := Code.Card + 1;
  Name[ResID] := 'result';
  DeclareSwitch := false;

  SymbolTable.CallConv[SubID] := cc;
  if DllName <> '' then
  begin
    Name[NewVar] := DllName;
    Name[NewVar] := Name[SubID];

    LevelStack.Card := _SaveLevelCard;
    Next[SubID] := 0;
    Value[SubID] := 0;

    SetLabelHere(L);

    Call_SCANNER;
    Exit;
  end;

  if CurrThisID > 0 then
  begin
    Name[CurrThisID] := 'this';
    TypeID[CurrThisID] := CurrClassID;
    WithCount := GenBeginWith(CurrThisID);
  end
  else
    WithCount := GenBeginWith(CurrClassID);

  Call_SCANNER;
  if IsCurrText(':') and (CurrClassID > 0) then
  begin
    Call_SCANNER;
    Match('base');
    Call_SCANNER;
    Match('(');

    RefID := NewRef;
    Gen(OP_GET_ANCESTOR_NAME, CurrClassID, 0, RefID);

    GenRef(CurrThisID, maMyBase, RefID);

    Call_SCANNER;
    if IsCurrText(')') then
    begin
      Gen(OP_CALL, RefID, 0, 0);
      CallRec := TPaxCallRec.Create;
      CallRec.CallP := Scanner.PosNumber;
      CallRec.CallN := Code.Card;
      TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);
    end
    else
    begin
      Gen(OP_CALL, RefID, Parse_ArgumentList(RefID, Vars), 0);
      SetVars(Vars);
    end;

    Match(')');
    Call_SCANNER;
  end;

  Match('{');
  Parse_Block;

  GenEndWith(WithCount);

  GenDestroyLocalVars;
  Gen(OP_RET, 0, 0, 0);
  SetLabelHere(L);

  LevelStack.Pop;

  LinkVariables(SubID, false);

  Call_SCANNER;
end;

procedure TPAXCParser.Parse_ReturnStmt;
var
  ResID: Integer;
begin
  // match "return"

  ResID := SymbolTable.GetResultID(CurrLevel);

  Call_SCANNER;

  if not IsCurrText(';') then
    Gen(OP_ASSIGN_RESULT, ResID, Parse_Expression, ResID);

  Gen(OP_EXIT, 0, 0, 0);
end;

procedure TPAXCParser.Parse_HaltStmt;
begin
  // match "halt"
  Call_SCANNER;
  if not IsCurrText(';') then
    Call_SCANNER;
  Gen(OP_HALT_GLOBAL, 0, 0, 0);
end;

function TPAXCParser.Parse_ClassStmt(ClassML: TPAXModifierList; ck: TPAXClassKind): Integer;
var
  ClassID, AncestorClassID: Integer;

procedure Parse_PropertyStmt(ml: TPAXModifierList);
var
  PropertyRec: TPAXMemberRec;
  PropID, SubID, ResID, ParamID, ParamTypeID, ValueID, I, ID, T: Integer;
  ParamIds: TPaxIds;
begin
  // match "property"

  DeclareSwitch := true;
  Call_SCANNER;

  T := typeVARIANT;
  if NextToken.TokenClass = tcID then
  begin
    if NewID then
      SymbolTable.DecCard
    else
      T := CurrToken.ID;
    Call_SCANNER;
  end;

  PropID := CurrToken.ID;
  DeclareSwitch := false;

  TypeID[PropID] := T;

  PropertyRec := CurrClassRec.AddProperty(Parse_Ident, ml);

  Kind[PropID] := KindPROP;
  if Name[PropID] = 'this' then
    PropertyRec.ml := PropertyRec.ml + [modDEFAULT];

  ParamIds := TPaxIds.Create(false);

  if IsCurrText('[') then
  begin
    DeclareSwitch := true;

    repeat
      Call_SCANNER;

      ParamTypeID := typeVARIANT;
      if NextToken.TokenClass = tcID then
      begin
        if NewID then
          SymbolTable.DecCard
        else
          ParamTypeID := CurrToken.ID;
        Call_SCANNER;
      end;

      if IsCurrText('ref') or IsCurrText('out') then
        ParamID := Parse_ByRef
      else
        ParamID := Parse_Ident;
       ParamIds.Add(ParamID);

       TypeID[ParamID] := ParamTypeID;

       if not IsCurrText(',') then
         Break;
    until false;

    DeclareSwitch := false;

    Match(']');
    Call_SCANNER;
  end;

  Match('{');
  Call_SCANNER;

  while IsCurrText('get') or
        IsCurrText('set')
  do
  begin
    if IsCurrText('get') then
    begin
      if PropertyRec.ReadID <> 0 then
        Match('}');

      SubID := NewVAR;
      PropertyRec.ReadID := SubID;

      Name[SubID] := Name[PropID] + '_get';

      LevelStack.PushSub(SubID, CurrClassID, ml);

      ResID := NewVar;
      NewVar;

      for I:=0 to ParamIds.Count - 1 do
      begin
        ID := NewVar;
        Name[ID] := Name[ParamIds[I]];
      end;

      Kind[SubID] := KindSUB;
      Count[SubID] := 0 + ParamIds.Count;
      Next[SubID] := ResID;
      TypeSub[SubID] := tsMethod;

      if Code.Prog[Code.Card].Op = OP_SEPARATOR then
        Value[SubID] := Code.Card
      else
        Value[SubID] := Code.Card + 1;
      Name[ResID] := 'result';
      Name[CurrThisID] := 'this';
      TypeID[CurrThisID] := CurrClassID;

      Gen(OP_BEGIN_WITH, WithStack.Push(CurrThisID), 0, 0);

      Call_SCANNER;
      Match('{');
      Parse_Block;

      Gen(OP_END_WITH, 0, 0, 0);
      WithStack.Pop;

      Gen(OP_RET, 0, 0, 0);
      LevelStack.Pop;

      LinkVariables(SubID, false);

      Call_SCANNER;
    end
    else if IsCurrText('set') then
    begin
      if PropertyRec.WriteID <> 0 then
        Match('}');

      SubID := NewVAR;
      PropertyRec.WriteID := SubID;

      Name[SubID] := Name[PropID] + '_set';

      LevelStack.PushSub(SubID, CurrClassID, ml);

      ResID := NewVar;
      NewVar;

      for I:=0 to ParamIds.Count - 1 do
      begin
        ID := NewVar;
        Name[ID] := Name[ParamIds[I]];
      end;

      ValueID := NewVar;

      Kind[SubID] := KindSUB;
      Count[SubID] := 1 + ParamIds.Count;
      Next[SubID] := ResID;
      TypeSub[SubID] := tsMethod;

      if Code.Prog[Code.Card].Op = OP_SEPARATOR then
        Value[SubID] := Code.Card
      else
        Value[SubID] := Code.Card + 1;
      Name[ResID] := 'result';
      Name[CurrThisID] := 'this';
      TypeID[CurrThisID] := CurrClassID;

      Gen(OP_BEGIN_WITH, WithStack.Push(CurrThisID), 0, 0);
      Name[ValueID] := 'value';

      Call_SCANNER;
      Match('{');
      Parse_Block;

      Gen(OP_END_WITH, 0, 0, 0);
      WithStack.Pop;

      Gen(OP_RET, 0, 0, 0);
      LevelStack.Pop;

      LinkVariables(SubID, false);

      Call_SCANNER;
    end
  end;

  if PropertyRec.ReadID + PropertyRec.WriteID = 0 then
    Match('get');

  Call_SCANNER;

  ParamIds.Free;
end;

var
  L: Integer;
  ml: TPAXModifierList;
begin
  // match "class"
  Gen(OP_SKIP, 0, 0, 0);
  L := NewLabel;
  Gen(OP_GO, L, 0, 0);

  DeclareSwitch := true;
  Call_SCANNER;
  DeclareSwitch := false;

  ClassID := Parse_Ident;
  result := ClassID;

  Kind[ClassID] := KindTYPE;

  if IsCurrText(':') then
  begin
    Call_SCANNER;
    AncestorClassID := Parse_Ident;
    SymbolTable.Level[AncestorClassID] := -1;

    if AncestorClassID > PaxTypes.Count then
      TPaxBaseScripter(Scripter).UnknownTypes.AddObject(AncestorClassID,
        TPaxIDRec.Create(AncestorClassID, Code.Card, Scanner.PosNumber));
  end
  else
    AncestorClassID := 0;

  LevelStack.PushClass(ClassID, AncestorClassID, ClassML, ck, false);

  Match('{');
  Call_SCANNER;

  repeat
    ml := Parse_ModifierList;

    if IsCurrText('function') then
      Parse_FunctionStmt(ml)
    else if IsCurrText('property') then
      Parse_PropertyStmt(ml)
    else if IsCurrText('var') then
    begin
      Parse_VarStmt(true, ml);
      Match(';');
      Call_SCANNER;
    end
    else if IsCurrText('const') then
    begin
      Parse_VarStmt(true, ml);
      Match(';');
      Call_SCANNER;
    end
    else if IsCurrText('class') then
      Parse_ClassStmt(ml, ckClass)
    else if IsCurrText('structure') then
      Parse_ClassStmt(ml, ckStructure)
    else if IsCurrText('enum') then
      Parse_EnumStmt
    else if (CurrToken.TokenClass = tcID) and
            ((NextToken.TokenClass = tcId) or (NextToken.Text = '~') or
             (NextToken.Text = 'operator')) then
    begin
      if IsNext2Text('(') or (NextToken.Text = '~') then
        Parse_FunctionStmt(ml, CurrToken.ID)
      else if NextToken.Text = 'operator' then
        Parse_FunctionStmt(ml, CurrToken.ID)
      else
      begin
        Parse_VarStmt(true, ml, CurrToken.ID);
        Match(';');
        Call_SCANNER;
      end;
    end
    else if (CurrToken.TokenClass = tcID) and IsNextText('[') and
          (IsNext2Text(']') or IsNext2Text(',')) then
    begin
      Parse_VarStmt(true, ml, CurrToken.ID);
      Match(';');
      Call_SCANNER;
    end
    else
      Match('function');

    if CurrToken.ID = SP_EOF then
      Break;
    if IsCurrText('}') then
      Break;
  until false;

  LevelStack.Pop;
  SetLabelHere(L);

  Call_SCANNER;
end;

function TPAXCParser.Parse_EnumStmt: Integer;
var
  ClassID, AncestorClassID: Integer;
  L, ID, ValueID: Integer;
  ml: TPAXModifierList;
  MemberRec: TPAXMemberRec;
begin
  // match "enum"

  ValueID := 0;

  Gen(OP_SKIP, 0, 0, 0);
  L := NewLabel;
  Gen(OP_GO, L, 0, 0);

  DeclareSwitch := true;
  Call_SCANNER;
  DeclareSwitch := false;

  ClassID := Parse_Ident;
  result := ClassID;

  Kind[ClassID] := KindTYPE;

  AncestorClassID := 0;

  LevelStack.PushClass(ClassID, AncestorClassID, [modStatic], ckEnum, false);

  Match('{');
  Call_SCANNER;

  repeat
    ml := Parse_ModifierList;

    ID := Parse_Ident;
    MemberRec := CurrClassRec.AddField(ID, [modSTATIC]);
    TypeID[ID] := ClassID;

    if IsCurrText('=') then
    begin
      Call_SCANNER;

      Gen(OP_NOP, 0, 0, 0);
      MemberRec.InitN := LastCodeLine;

      if ValueID = 0 then
        ValueID := NewVar;

      Gen(OP_ASSIGN, ValueID, Parse_AssignmentExpression, ValueID);

      Gen(OP_ASSIGN, ID, ValueID, ID);
      Gen(OP_PLUS, ValueID, NewConst(1), ValueID);
      Gen(OP_HALT, 0, 0, 0);

      if IsCurrText('}') then
        Break;

      Match(',');
      Call_SCANNER;
    end
    else if IsCurrText(',') or IsCurrText('}') then
    begin
      Gen(OP_NOP, 0, 0, 0);
      MemberRec.InitN := LastCodeLine;

      if ValueID = 0 then
      begin
        ValueID := NewVar;
        Gen(OP_ASSIGN, ValueID, NewConst(0), ValueID);
      end;

      Gen(OP_ASSIGN, ID, ValueID, ID);
      Gen(OP_PLUS, ValueID, NewConst(1), ValueID);
      Gen(OP_HALT, 0, 0, 0);

      if IsCurrText('}') then
        Break;

      Call_SCANNER;
    end
    else
      Break;

    if CurrToken.ID = SP_EOF then
      Break;
  until false;

  Match('}');

  LevelStack.Pop;
  SetLabelHere(L);

  Call_SCANNER;
end;

procedure TPaxCParser.Parse_SwitchStmt;

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

procedure TPAXCParser.Parse_WithStmt;
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

procedure TPAXCParser.Parse_ThrowStmt;
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

procedure TPAXCParser.Parse_TryStmt;
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

procedure TPAXCParser.Parse_VarStmt(IsField: Boolean; ml: TPAXModifierList;
                                    T: Integer = 0;
                                    IsLoopVar: Boolean = false);
var
  L: Integer;
  IsConst: Boolean;
  ID: Integer;
begin
  IsConst := IsCurrText('const');

  if T > PaxTypes.Count then
    TPaxBaseScripter(Scripter).UnknownTypes.AddObject(T, TPaxIDRec.Create(T, Code.Card, Scanner.PosNumber));

  L := 0;
  if not IsField then
  if (CurrClassID > 0) and (CurrSubID = 0) and (not IsLoopVar) then
  begin
    L := NewLabel;
    Gen(OP_SKIP, 0, 0, 0);
    Gen(OP_GO, L, 0, 0);
  end;

  DeclareSwitch := true;

  Call_SCANNER;

  if (not IsNextText('=')) and (IsConst) then
  begin
    T := CurrToken.ID;
    Call_SCANNER;
  end;

  repeat
    ID := Parse_VariableDeclaration(IsField, ml, T, IsLoopVar);
    if IsConst then
      ConstIds.Add(ID);

    if IsCurrText(',') then
      Call_SCANNER
    else
      Break;
  until false;

  DeclareSwitch := false;

  if not IsField then
  if (CurrClassID > 0) and (CurrSubID = 0) and (not IsLoopVar) then
  begin
    SetLabelHere(L);
  end;
end;

function TPAXCParser.Parse_VariableDeclaration(IsField: Boolean;
                                               ml: TPAXModifierList; T: Integer;
                                               IsLoopVar: Boolean = false): Integer;
var
  ArrID, Vars, ID, Rank, K: Integer;
  MemberRec: TPAXMemberRec;
  ObjectInit: Boolean;
begin
  MemberRec := nil;
  ObjectInit := false;

  Rank := 0;
  if IsCurrText('[') then
  begin
    Rank := Parse_Rank;
  end
  else
    if (T <= PaxTypes.Count) and (T > 0) and (T <> typeVARIANT) then
    begin
      Rank := -1;
    end;

  result := Parse_Ident;
  SymbolTable.Rank[result] := Rank;

  if IsField then
  begin
    MemberRec := CurrClassRec.FindMember(NameIndex[result], maAny, false);
    if MemberRec <> nil then
      raise TPAXScriptFailure.Create(Format(errIdentifierIsRedeclared, [Name[result]]));

    MemberRec := CurrClassRec.AddField(result, ml);
  end
  else if (CurrClassID > 0) and (CurrSubID = 0) then
  begin
    MemberRec := CurrClassRec.FindMember(NameIndex[result], maAny, false);
    if MemberRec <> nil then
      raise TPAXScriptFailure.Create(Format(errIdentifierIsRedeclared, [Name[result]]));

    MemberRec := CurrClassRec.AddField(result, ml + [modSTATIC]);
  end
  else if CurrSubID > 0 then
  begin
    SymbolTable.DecCard;
    if SymbolTable.LookUpID(Name[result], CurrSubID, true) > 0 then
      raise TPAXScriptFailure.Create(Format(errIdentifierIsRedeclared, [Name[result]]));
    SymbolTable.IncCard;
    SymbolTable.SetLocal(result);

    TestDupLocalVars(result);

    LocalVars.Add(result);
  end;

  if (T > 0) and (not IsLoopVar) then
  begin
    if (T > PAXTypes.Count) or (T < 0) then
    begin
      if MemberRec <> nil then
         MemberRec.InitN := LastCodeLine;
      GenEvalWith(T);
      Gen(OP_CHECK_CLASS, T, 0, result);
      Gen(OP_CREATE_OBJECT, T, 0, result);
      if MemberRec <> nil then
      begin
        if IsCurrText('=') and IsNextText('(') then
          ObjectInit := true
         else
           Gen(OP_HALT, 0, 0, 0);
      end;
    end;
    TypeID[result] := T;
  end;

  if IsCurrText('[') and (not IsLoopVar) then
  begin
    if MemberRec <> nil then
      MemberRec.InitN := LastCodeLine;

    DeclareSwitch := false;
    Call_SCANNER;

    ArrID := 0;
    K := Parse_ArgumentList(ArrID, Vars);
    Gen(OP_CREATE_ARRAY, result, K, T);
    TypeID[result] := typeVARIANT;

    if (K <> Rank) and (Rank > 0) then
       raise TPaxScriptFailure.Create(errRankMismatch);

    if MemberRec <> nil then
    begin
      if IsCurrText('=') then
      begin
//        ObjectInit := true;
       end
       else
         Gen(OP_HALT, 0, 0, 0);
    end;

    Match(']');
    DeclareSwitch := true;

    Call_SCANNER;
  end
  else if IsCurrText('=') then
  begin
    Gen(OP_NOP, 0, 0, 0);
    if (MemberRec <> nil) and (not IsLoopVar) and (not ObjectInit) then
       MemberRec.InitN := LastCodeLine;

    DeclareSwitch := false;
    Call_SCANNER;

    Gen(OP_SKIP, 0, 0, 0);

    if IsCurrText('(') and (T > PaxTypes.Count) then
    begin
      Parse_ObjectInitializer(result);
      if MemberRec <> nil then
        Gen(OP_HALT, 0, 0, 0);
    end
    else
    begin
      ID := Parse_AssignmentExpression;
      if ID = UndefinedID then
        Gen(OP_DESTROY_INTF, result, 0, 0);
      Gen(OP_ASSIGN, result, ID, result);

      if (MemberRec <> nil) and (not IsLoopVar) then
      begin
        if Kind[ID] = KindCONST then
          Value[MemberRec.ID] := Value[ID];
        Gen(OP_HALT, 0, 0, 0);
      end;
    end;

    DeclareSwitch := true;
    TempObjectList.Clear;
  end
  else if T in [typeINTEGER, typeCARDINAL, typeBYTE, typeWORD, typeSHORTINT, typeSMALLINT, typeINT64, typeBOOLEAN, typeDOUBLE, typeSTRING] then
  if modSTATIC in CurrClassRec.ml then
  begin
    if T in [typeINTEGER, typeCARDINAL, typeBYTE, typeWORD, typeSHORTINT, typeSMALLINT, typeINT64] then
    begin
      Gen(OP_NOP, 0, 0, 0);
      if (MemberRec <> nil) and (not ObjectInit) then
        MemberRec.InitN := LastCodeLine;
      Gen(OP_SKIP, 0, 0, 0);
      ID := NewConst(0);
      Gen(OP_ASSIGN, result, ID, result);
      if MemberRec <> nil then
        Gen(OP_HALT, 0, 0, 0);
    end
    else if T = typeBOOLEAN then
    begin
      Gen(OP_NOP, 0, 0, 0);
      if (MemberRec <> nil) and (not ObjectInit) then
        MemberRec.InitN := LastCodeLine;
      Gen(OP_SKIP, 0, 0, 0);
      ID := NewConst(false);
      Gen(OP_ASSIGN, result, ID, result);
      if MemberRec <> nil then
        Gen(OP_HALT, 0, 0, 0);
    end
    else if T = typeDOUBLE then
    begin
      Gen(OP_NOP, 0, 0, 0);
      if (MemberRec <> nil) and (not ObjectInit) then
        MemberRec.InitN := LastCodeLine;
      Gen(OP_SKIP, 0, 0, 0);
      ID := NewConst(0.0);
      Gen(OP_ASSIGN, result, ID, result);
      if MemberRec <> nil then
        Gen(OP_HALT, 0, 0, 0);
    end
    else if T = typeSTRING then
    begin
      Gen(OP_NOP, 0, 0, 0);
      if (MemberRec <> nil) and (not ObjectInit) then
        MemberRec.InitN := LastCodeLine;
      Gen(OP_SKIP, 0, 0, 0);
      ID := NewConst('');
      Gen(OP_ASSIGN, result, ID, result);
      if MemberRec <> nil then
        Gen(OP_HALT, 0, 0, 0);
    end;
  end;
end;

procedure TPAXCParser.Parse_ExpressionStmt;
begin
  Parse_Expression;
end;

procedure TPAXCParser.Parse_StmtList;
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
  Gen(OP_NOP, 0, 0, 0);
  IsExecutable := false;
end;

procedure TPAXCParser.Parse_SourceElements;
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

procedure TPAXCParser.Parse_Program;
var
  K, LTRY, I, Id, Level: Integer;
  L: TPaxIds;
  C: TPaxClassRec;
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

  if JavaScriptOperators then
    Gen(OP_JS_OPERS_ON, 0, 0, 0)
  else
    Gen(OP_JS_OPERS_OFF, 0, 0, 0);

  if ZeroBasedStrings then
    Gen(OP_ZERO_BASED_STRINGS_ON, 0, 0, 0)
  else
    Gen(OP_ZERO_BASED_STRINGS_OFF, 0, 0, 0);

  K := Code.Card;

  LTRY := NewLabel;
  Gen(OP_TRY_ON, LTRY, 0, 0);

  Parse_SourceElements;

  Gen(OP_FINALLY, 0, 0, 0);

  L := TPAXIds.Create(true);
  for I:=K to Code.Card do
    if Code.Prog[I].Op = OP_DECLARE then
    begin
      Id := Code.Prog[I].Arg1;
      Level := SymbolTable.Level[Id];

      if Level > 0 then
      if SymbolTable.Kind[Level] = KindTYPE then
      begin
        C := TPaxBaseScripter(scripter).ClassList.FindClass(Level);
        if C <> nil then
          if C.IsStatic then
            L.Add(Id);
      end;
    end;
  for I:=0 to L.Count - 1 do
    Gen(OP_DESTROY_INTF, L[I], 0, 1);

  L.Free;

  Gen(OP_EXIT_ON_ERROR, 0, 0, 0);
  SetLabelHere(LTRY);
  Gen(OP_TRY_OFF, 0, 0, 0);
end;

end.

