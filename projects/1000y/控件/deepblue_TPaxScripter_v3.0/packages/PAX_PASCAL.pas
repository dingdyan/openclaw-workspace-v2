////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: PAX_PASCAL.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit PAX_PASCAL;

interface

uses
  SysUtils, Classes,
  BASE_CONSTS,
  BASE_SYNC,
  BASE_SYS,
  BASE_SCANNER, BASE_PARSER, BASE_SCRIPTER, BASE_CLASS, BASE_EXTERN;

const
  SP_INTERVAL = -1001;
  SP_ADDRESS = -1002;
  errForward = 'Unsatisfied forward declaration';
type
  TPAXPascalScanner = class(TPAXScanner)
  public
    procedure ReadToken; override;
  end;

  TPAXPascalParser = class(TPAXParser)
  private
    ForwardIds, ForwardPos, EnumIds,

    OperCompare, OperAdditive, OperMult, ConstIds

    : TPAXIds;

    IsInterfaceSection: Boolean;

    function IsUnitId: boolean;
    function IsTypeID: boolean;
  public
    function IsConstant: boolean; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure Reset; override;
    procedure Call_SCANNER; override;
    function IsBaseType(const S: String): Boolean; override;
    function Parse_OverloadableOperator: Integer; override;

/// expressions

    function Parse_EvalExpression: Integer; override;
    function Parse_ArgumentExpression: Integer; override;
    function Parse_ConstExpr: Integer;
    function Parse_Expression: Integer;
    function Parse_SimpleExpression: Integer;
    function Parse_Term: Integer;
    function Parse_Factor: Integer;
    function Parse_Designator(ResID: Integer = 0): Integer;
    function Parse_QualID: Integer;
    function Parse_UnitID: Integer;
    function Parse_TypeID: Integer;
    function Parse_SetConstructor: Integer;
    function Parse_SetElement: Integer;

// Statements
    procedure Parse_Statement;
    procedure Parse_StmtList; override;
    procedure Parse_SimpleStatement;

    procedure Parse_CompoundStmt;
    procedure Parse_IfStmt;
    procedure Parse_CaseStmt;
    procedure Parse_RepeatStmt;
    procedure Parse_WhileStmt;
    procedure Parse_ForStmt;
    procedure Parse_BreakStmt;
    procedure Parse_ContinueStmt;
    procedure Parse_ExitStmt;
    procedure Parse_LabelStmt;
    procedure Parse_HaltStmt;
    procedure Parse_WithStmt;
    procedure Parse_TryStmt;
    procedure Parse_RaiseStmt;
    procedure Parse_ProgramStmt;
    procedure Parse_UnitStmt;

    function Parse_FunctionStmt(ts: TPAXTypeSub; ml: TPAXModifierList): Integer;
    procedure Parse_VarStmt(IsField: Boolean; ml: TPAXModifierList; IsConst: Boolean);
    function Parse_VariableDeclaration(IsField: Boolean; ml: TPAXModifierList;
                                       Ids: TPAXIds; IsConst: Boolean): Integer;
    function Parse_ClassStmt(ClassML: TPAXModifierList; ck: TPAXClassKind; _ClassID: Integer = -1): Integer;
    function Parse_EnumStmt(_ClassID: Integer = -1): Integer;
    procedure Parse_NamespaceStmt(ml: TPAXModifierList);
    procedure Parse_TypeStmt;
    procedure Parse_ArrayStmt(ClassID: Integer);
    procedure Parse_DynamicArrayType(ClassID: Integer);

    procedure Parse_Program; override;
  end;


implementation

procedure TPAXPascalScanner.ReadToken;

procedure ScanChrs;
var
  S: String;
  I: Integer;
begin
  S := '';
  repeat
    GetNextChar;
    ScanHexDigits;
    I := StrToInt(Token.Text);
    S := S + Chr(I);

    if LA(1) = '#' then
      GetNextChar
    else
      Break;
  until false;

  Token.Text := S;
  Token.TokenClass := tcStringConst;

  if LA(1) = '''' then
  begin
    GetNextChar;
    ScanString('''');
    Token.Text := S + Token.Text;
  end;
end;

var
  S: String;
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
    Token.ID := 0;

    case c of
      #8, #9, #10, #13, #32: ScanWhiteSpace;
      #255: ScanEOF;
      '0'..'9':
        ScanDigits;
      '$':
        ScanHexDigits;
      'A'..'Z', 'a'..'z', '_':
      begin
        ScanIdentifier;
        if StrEql(Token.Text, 'mod') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_MOD;
        end
        else if StrEql(Token.Text, 'div') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_INT_DIV;
        end
        else if StrEql(Token.Text, 'and') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_AND;
        end
        else if StrEql(Token.Text, 'or') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_OR;
        end
        else if StrEql(Token.Text, 'xor') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_XOR;
        end
        else if StrEql(Token.Text, 'shl') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_LEFT_SHIFT;
        end
        else if StrEql(Token.Text, 'shr') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_RIGHT_SHIFT;
        end
        else if StrEql(Token.Text, 'in') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_IN_SET;
        end
        else if StrEql(Token.Text, 'as') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_TYPE_CAST;
        end
        else if StrEql(Token.Text, 'is') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_IS;
        end
        else if StrEql(Token.Text, 'not') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_NOT;
        end;
      end;
      '+': ScanPlus;
      '-': ScanMinus;
      '*': ScanMult;
      '/':
      begin
        if LA(1) = '/' then
        begin
          repeat
            GetNextChar;
          until LA(1) in [#13, #10];
          Continue;
        end;
        ScanDiv;
      end;
      '{':
      begin
        if (LA(1) = '$') and (not LookForward) then
          ScanCondDir('{', ['$'])
        else
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

          until LA(1) in ['}', #255];
          GetNextChar;
        end;
        Continue;
      end;
      '=': ScanEQ;
      '>':
      begin
        ScanGT;
        if LA(1) = '=' then
        begin
          GetNextChar;
          Token.Text := '>=';
          Token.ID := OP_GE;
        end;
      end;
      '?', '%':
      case ScannerState of
        ScanText:
          raise TPAXScriptFailure.Create(errIllegalCharacter);
        ScanProg:
        if LA(1) = '>' then
        begin
          ScannerState := scanText;
          GetNextChar;
          ScanHtmlString('');
        end
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
          else if LA(1) in ['a'..'z','A'..'Z', '!'] then
            ScanHtmlString(c)
          else
            raise TPAXScriptFailure.Create(errIllegalCharacter);
        end;
        scanProg:
        begin
          ScanLT;
          if LA(1) = '=' then
          begin
            GetNextChar;
            Token.Text := '<=';
            Token.ID := OP_LE;
          end
          else if LA(1) = '>' then
          begin
            GetNextChar;
            Token.Text := '<>';
            Token.ID := OP_NE;
          end;
        end;
      end;
      ':':
      begin
        ScanColon;
        if LA(1) = '=' then
        begin
          GetNextChar;
          Token.Text := ':=';
          Token.ID := OP_ASSIGN;
        end;
      end;
      '@':
      begin
        Token.Text := '@';
        Token.ID := SP_ADDRESS;
        Token.TokenClass := tcSpecial;
      end;
      '^':
      begin
        Token.Text := '^';
        Token.ID := OP_GET_TERMINAL;
        Token.TokenClass := tcSpecial;
      end;
      ';': ScanSemiColon;
      '(': ScanLeftRoundBracket;
      ')': ScanRightRoundBracket;
      '[': ScanLeftBracket;
      ']': ScanRightBracket;
      ',': ScanComma;
      '.':
      begin
        ScanPoint;
        if LA(1) = '.' then
        begin
          GetNextChar;
          Token.Text := '..';
          Token.ID := SP_INTERVAL;
        end;
      end;
      '''':
      begin
        ScanString('''');
        if LA(1) = '#' then
        begin
          S := Token.Text;
          GetNextChar;
          ScanChrs;
          Token.Text := S + Token.Text;
        end;
      end;
      '"': ScanString('"');
      '#':
      begin
        if LA(1) = '!' then
        begin
          repeat
            GetNextChar;
          until LA(1) in [#13, #10];
          Continue;
        end;
        ScanChrs;
      end;
    else
      raise TPAXScriptFailure.Create(errIllegalCharacter);
    end;

    if not (Token.TokenClass in [tcNone]) then
      Break;

  until false;
end;

constructor TPAXPascalParser.Create;
begin
  ConstIds := TPaxIds.Create(false);

  inherited;

  Scanner := TPAXPascalScanner.Create(Self);

  Upcase := true;
  IsArrayInitialization := true;

  IsInterfaceSection := false;
  IsImplementationSection := false;

  with Keywords do
  begin
    Add('AND');
    Add('ARRAY');
    Add('AS');
    Add('BEGIN');
    Add('BREAK');
    Add('CASE');
    Add('CLASS');
    Add('CONST');
    Add('CONSTRUCTOR');
    Add('CONTINUE');
    Add('DESTRUCTOR');
    Add('DIV');
    Add('DO');
    Add('ELSE');
    Add('END');
    Add('ENUM');
    Add('EXCEPT');
    Add('EXIT');
    Add('EXTERNAL');
    Add('HALT');
    Add('FINALLY');
    Add('FOR');
    Add('FORWARD');
    Add('FUNCTION');
    Add('GOTO');
    Add('IF');
    Add('IN');
    Add('INHERITED');
    Add('LABEL');
    Add('INHERITED');
    Add('NAMESPACE');
    Add('NEW');
    Add('NOT');
    Add('MOD');
    Add('ON');
    Add('OF');
    Add('OPERATOR');
    Add('OR');
    Add('OUT');
    Add('OVERRIDE');
    Add('PROCEDURE');
    Add('PROGRAM');
    Add('PRIVATE');
    Add('PRINT');
    Add('PRINTLN');
    Add('PUBLIC');
    Add('PROPERTY');
    Add('RAISE');
    Add('RECORD');
    Add('REDUCED');
    Add('STATIC');
//    Add('DELETE');
    Add('REPEAT');
    Add('SHL');
    Add('SHR');
    Add('THEN');
    Add('TO');
    Add('TRY');
    Add('TYPE');
    Add('VAR');
    Add('UNTIL');
    Add('USES');
    Add('VIRTUAL');
    Add('WHILE');
    Add('WITH');
    Add('XOR');

    Add('IS');

    Add('UNIT');
    Add('INTERFACE');
    Add('IMPLEMENTATION');
    Add('INITIALIZATION');
    Add('FINALIZATION');
    Add('OVERLOAD');
  end;

  ForwardIds := TPaxIds.Create(false);
  ForwardPos := TPaxIds.Create(false);
  EnumIds := TPaxIds.Create(false);

  OperCompare := TPaxIds.Create(false);
  with OperCompare do
  begin
    Add(OP_EQ);
    Add(OP_NE);
    Add(OP_GT);
    Add(OP_LT);
    Add(OP_GE);
    Add(OP_LE);
    Add(OP_IS);
    Add(OP_IN_SET);
    Add(OP_TYPE_CAST);
  end;

  OperAdditive := TPaxIds.Create(false);
  with OperAdditive do
  begin
    Add(OP_PLUS);
    Add(OP_MINUS);
    Add(OP_OR);
    Add(OP_XOR);
  end;

  OperMult := TPaxIds.Create(false);
  with OperMult do
  begin
    Add(OP_MULT);
    Add(OP_DIV);
    Add(OP_INT_DIV);
    Add(OP_MOD);
    Add(OP_AND);
    Add(OP_RIGHT_SHIFT);
    Add(OP_LEFT_SHIFT)
  end;

end;

procedure TPAXPascalParser.Call_SCANNER;
var
  S: String;
  TempID: Integer;
begin
  inherited;

  if CurrToken.TokenClass in [tcId, tcKeyword] then
  begin
    if IsCurrText('TDateTime') or IsCurrText('Real') then
    begin
      CurrToken.ID := typeDOUBLE;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('OleVariant') then
    begin
      CurrToken.ID := typeVARIANT;
      CurrToken.TokenClass := tcId;
    end
    else if IsCurrText('static') then
    begin
      CurrToken.Text := 'class';
    end
    else if IsCurrText('nil') then
      CurrToken.ID := UndefinedID
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

function TPAXPascalParser.Parse_OverloadableOperator: Integer;
begin
  if IsCurrText('=') then
    CurrToken.Text := '=='
  else if IsCurrText('<>') then
    CurrToken.Text := '!='
  else if IsCurrText('mod') then
    CurrToken.Text := '%'
  else if IsCurrText('shl') then
    CurrToken.Text := '<<'
  else if IsCurrText('shr') then
    CurrToken.Text := '>>';

  result := NewVar();
  Name[result] := CurrToken.Text;

  if OverloadableOperators.IndexOf(CurrToken.Text) = -1 then
    raise TPaxScriptFailure.Create(errOverloadableOperatorExpected);

  Call_SCANNER;
end;

function TPAXPascalParser.IsBaseType(const S: String): Boolean;
begin
  result := inherited IsBaseType(S);
  if result then
    Exit;
  result := (StrEql(S, 'TDateTime') or StrEql(S, 'Real'));
end;


destructor TPAXPascalParser.Destroy;
begin
  ForwardIds.Free;
  ForwardPos.Free;
  EnumIds.Free;

  OperCompare.Free;
  OperAdditive.Free;
  OperMult.Free;
  ConstIds.Free;

  inherited;
end;

procedure TPAXPascalParser.Reset;
begin
  inherited;

  if Assigned(ForwardIds) then
    ForwardIds.Clear;
  if Assigned(ForwardPos) then
    ForwardPos.Clear;
  if Assigned(EnumIds) then
    EnumIds.Clear;

  ConstIds.Clear;
end;

function TPAXPascalParser.Parse_EvalExpression: Integer;
begin
  result := Parse_Expression;
end;

function TPAXPascalParser.Parse_ArgumentExpression: Integer;
begin
  result := Parse_Expression;
end;

///////  EXPRESSIONS /////////////////////////////////////////////////////////

function TPAXPascalParser.Parse_ConstExpr: Integer;
begin
  result := Parse_Expression;
end;

function TPAXPascalParser.Parse_Expression: Integer;
var
  OP, TypeID: Integer;
  CallRec: TPaxCallRec;
begin
  result := Parse_SimpleExpression;
  if IsOperator(OperCompare, OP) then
  begin
    if OP = OP_TYPE_CAST then
    begin
      Gen(OP_PUSH, result, 0, 0);
      TypeID := Parse_Ident;
      result := NewVar;
      Gen(OP_CALL, TypeID, 1, result);

      CallRec := TPaxCallRec.Create;
      CallRec.CallP := Scanner.PosNumber;
      CallRec.CallN := Code.Card;
      TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);
    end
    else
    begin
      result := BinOp(OP, result, Parse_SimpleExpression);
      symboltable.PType[result] := typeBOOLEAN;
    end;
  end;
end;

function TPAXPascalParser.Parse_SimpleExpression: Integer;
var
  OP: Integer;
begin
  result := Parse_Term;
  while IsOperator(OperAdditive, OP) do
  begin
    if (OP = OP_OR) and ShortEvalSwitch and (TypeID[result] = typeBOOLEAN) then
    begin
      result := Parse_ShortEvalOR(result, Parse_Term, nil);
    end
    else
    begin
      result := BinOp(OP, result, Parse_Term);
    end;
  end;
end;

function TPAXPascalParser.Parse_Term: Integer;
var
  OP: Integer;
begin
  result := Parse_Factor;
  while IsOperator(OperMult, OP) do
  begin
    if (OP = OP_AND) and ShortEvalSwitch and (TypeID[result] = typeBOOLEAN) then
    begin
      result := Parse_ShortEvalAND(result, Parse_Factor, nil);
    end
    else
    begin
      result := BinOp(OP, result, Parse_Factor);
    end;
  end;
end;

function TPAXPascalParser.Parse_Factor: Integer;
var
  SubID, Vars: Integer;
  IsArrayItem: Boolean;
  CallRec: TPaxCallRec;
begin
  if IsTypeID then
  begin
    result := Parse_Ident;
    Match('(');
    Call_SCANNER;
    Parse_Expression;
    Match(')');
    Call_SCANNER;
  end
  else if IsCurrText('not') then
  begin
    Call_SCANNER;
    result := NewVar;
    Gen(OP_NOT, Parse_Factor, 0, result);
  end
  else if IsCurrText('-') then
  begin
    Call_SCANNER;
    result := NewVar;
    Gen(OP_UNARY_MINUS, Parse_Factor, 0, result);
  end
  else if IsCurrText('+') then
  begin
    Call_SCANNER;
    result := NewVar;
    Gen(OP_UNARY_PLUS, Parse_Factor, 0, result);
  end
  else if IsCurrText('/') then
    result := Parse_RegExpr('Create')
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
  else if IsCurrText('(') then
  begin
    Call_SCANNER;
    result := Parse_Expression;
    Match(')');
    Call_SCANNER;
  end
  else if IsCurrText('[') then
    result := Parse_SetConstructor
  else if IsCurrText('@') then
  begin
    result := NewVar;
    Call_SCANNER;
    if IsCallOperator then
      RemoveLastOperator;

    IsArrayItem := IsNextText('[') or IsNextText('(');;

    SubID := Parse_Designator;
    if IsCallOperator and (not IsArrayItem) then
       RemoveLastOperator;
    Gen(OP_ASSIGN_ADDRESS, result, SubID, result);
  end
  else if IsCurrText('inherited') then
  begin
    if CurrClassID = 0 then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);
    if CurrSubID <> CurrMethodID then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);

    FieldSwitch := true;
    Call_SCANNER;
    result := Parse_Ident;
    GenRef(CurrThisID, maMyBase, result);

    SubID := result;
    if IsCurrText('(') then
    begin
      Call_SCANNER;
      result := NewVar;
      Gen(OP_CALL, SubID, Parse_ArgumentList(SubID, Vars), result);
      SetVars(Vars);

      Match(')');
      Call_SCANNER;
    end
    else
    begin
      Gen(OP_CALL, SubID, 0, result);

      CallRec := TPaxCallRec.Create;
      CallRec.CallP := Scanner.PosNumber;
      CallRec.CallN := Code.Card;
      TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);
    end;
  end
  else
  begin // designator

{   if IsCurrText('new') then
    begin
      Call_SCANNER;
      ClassName := CurrToken.Text;
      ClassID := Parse_Ident;
      ObjectID := NewVar;

      Gen(OP_CREATE_OBJECT, ClassID, 0, ObjectID);

      result := NewRef;
      Gen(OP_CREATE_REF, ObjectID, NewConst(ClassName), result);
    end
    else }

    result := Parse_Designator;
  end;
end;

function TPAXPascalParser.Parse_Designator(ResID: Integer = 0): Integer;
var
  RefID, ID, Vars: Integer;
  ObjectID: Integer;
  CallRec: TPaxCallRec;
  K, Rank: Integer;
begin
  Vars := 0;

  if ResID = 0 then
  begin
    result := Parse_QualID;
    result := GenEvalWith(result);
  end
  else
    result := ResID;

  ID := result;  

  Rank := SymbolTable.Rank[result];
  while True do
    case CurrToken.Text[1] of
      '.':
      begin
        FieldSwitch := true;
        Call_SCANNER;

        if IsCurrText('Create') or IsCurrText('CreateNew') then
        begin
          ObjectID := NewVar;
          Gen(OP_CREATE_OBJECT, result, 0, ObjectID);
          result := Parse_Ident;
          GenRef(ObjectID, maAny, result);

          SymbolTable.PType[result] := ObjectID;
        end
        else
        begin
          if IsCurrText('free') then
          begin
            CurrToken.Text := 'Free';
            Name[CurrToken.ID] := 'Destroy';
          end;

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
        end;
        if not (CurrToken.Text[1] in ['(', '[']) then
        begin
          if Kind[ID] = KindVIRTUALOBJECT then
          begin
            ID := result;
            result := NewVar;
            Gen(OP_CALL, ID, 0, result);
          end
          else
            Gen(OP_CALL, result, 0, result);
        end;

{      if IsDestructor then
       begin
         Gen(OP_DESTROY_OBJECT, ObjectID, 0, 0);
         Gen(OP_CALL, 0, 0, 0);
       end;  }
      end;
      '[':
      begin
//        if Rank = -1 then
//          raise TPaxScriptFailure.Create(errCannotApplyToScalar);

        ID := result;
        result := NewVar;

        Call_SCANNER;
        K := Parse_ArgumentList(ID, Vars);
        Gen(OP_CALL, ID, K, result);
        SetVars(Vars);

        Match(']');

        if (Rank > 0) and (K <> Rank) then
           raise TPaxScriptFailure.Create(errRankMismatch);

        Call_SCANNER;
      end;
      '(':
      begin
        ID := result;
        result := NewVar;

        Call_SCANNER;
        if IsCurrText(')') then
        begin
          Gen(OP_CALL, ID, 0, result);

          CallRec := TPaxCallRec.Create;
          CallRec.CallP := Scanner.PosNumber;
          CallRec.CallN := Code.Card;
          TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);
        end
        else
        begin
          Gen(OP_CALL, ID, Parse_ArgumentList(ID, Vars), result);
        end;
        SetVars(Vars);
        Match(')');
        Call_SCANNER;
      end;
     '^':
      begin
        Call_SCANNER;
        ID := result;
        result := NewVar;
        Gen(OP_GET_TERMINAL, ID, 0, result);
      end;
      else
        Exit;
    end;
end;

function TPAXPascalParser.Parse_QualID: Integer;
begin
  if IsUnitID then
  begin
    Parse_Ident;
    Match('.');
    Call_SCANNER;
  end;

  result := Parse_Ident;
end;

function TPAXPascalParser.Parse_SetConstructor: Integer;
begin
  result := Parse_ArrayLiteral;
end;

function TPAXPascalParser.Parse_SetElement: Integer;
begin
  result := Parse_Expression;
  if IsCurrText('..') then
  begin
    Call_SCANNER;
    result := Parse_Expression;
  end;
end;

function TPAXPascalParser.Parse_UnitID: Integer;
begin
  result := Parse_Ident;
end;

function TPAXPascalParser.Parse_TypeID: Integer;
var
  S: String;
begin
  if IsCurrText('record') then
  begin
    result := NewVar;
    Kind[result] := KindTYPE;
    Parse_ClassStmt([], ckStructure, result);
    Exit;
  end;
  if IsCurrText('array') then
  begin
    result := NewVar;
    Name[result] := '__'+IntToStr(result);
    Kind[result] := KindTYPE;
    Parse_ArrayStmt(result);

    Exit;
  end;

  if IsCurrText('set') then
  begin
    result := typeSET;
    Call_SCANNER;

    if IsCurrText('of') then
    begin
      Call_SCANNER;
      Call_SCANNER;
    end;

    Exit;
  end;

  if IsCurrText('String') and IsNextText('[') then
    result := Parse_Ident
  else
    result := Parse_Designator;
  S := Name[result];

  if (result > PAXTypes.Count) or (result < 0) then
  begin
//    if Kind[result] <> KindTYPE then
//      raise TPAXScriptFailure.Create(Format(errTypeNotFound, [S]));
  end
  else
    if not (result in SupportedPaxTypes) then
    begin
      if StrEql(S, 'TextFile') or StrEql(S, 'File') then
      begin
        // ok
      end
      else
        raise TPAXScriptFailure.Create(Format(errTypeNotFound, [S]));
    end;
end;

function TPAXPascalParser.IsTypeID: boolean;
begin
  result := false;
end;

function TPAXPascalParser.IsConstant: boolean;
begin
  result := inherited IsConstant or IsCurrText('nil');
end;

function TPAXPascalParser.IsUnitId: boolean;
begin
  result := false;
end;

///////  STATEMENTS /////////////////////////////////////////////////////////

procedure TPAXPascalParser.Parse_Statement;
var
  ml: TPAXModifierList;
begin
  ml := [modPUBLIC];

  if IsLabelID then if Kind[CurrToken.ID] = KindLABEL then
  begin
    StatementLabel := CurrToken.Text;
    Parse_SetLabel;
    Match(':');
    Call_SCANNER;
  end;

  if IsCurrText('begin') then
  begin
    Parse_CompoundStmt;
    Call_SCANNER;

    if IsCurrText('.') then
      CurrToken.Text := ';';
  end
  else if IsCurrText('if') then
  begin
    IsExecutable := true;
    Parse_IfStmt;
    IsExecutable := false;
  end
  else if IsCurrText('namespace') then
    Parse_NamespaceStmt(ml)
  else if IsCurrText('function') then
  begin
    if LevelStack.KindTop <> KindSUB then
      ml := ml + [modSTATIC];
    Parse_FunctionStmt(tsGlobal, ml);
  end
  else if IsCurrText('procedure') then
  begin
    if LevelStack.KindTop <> KindSUB then
      ml := ml + [modSTATIC];
    Parse_FunctionStmt(tsGlobal, ml);
  end
  else if IsCurrText('constructor') then
    Parse_FunctionStmt(tsConstructor, ml)
  else if IsCurrText('destructor') then
    Parse_FunctionStmt(tsDestructor, ml)
  else if IsCurrText('var') then
  begin
    DeclareSwitch := true;
    Call_SCANNER;
    Parse_VarStmt(false, ml, false);
  end
  else if IsCurrText('const') then
  begin
    DeclareSwitch := true;
    Call_SCANNER;
    Parse_VarStmt(false, ml, true);
  end
  else if IsCurrText('class') then
    Parse_ClassStmt(ml, ckClass)
  else if IsCurrText('type') then
    Parse_TypeStmt
  else if IsCurrText('enum') then
    Parse_EnumStmt
  else if IsCurrText('record') then
    Parse_ClassStmt(ml, ckStructure)
  else if IsCurrText('case') then
    Parse_CaseStmt
  else if IsCurrText('repeat') then
  begin
    IsExecutable := true;
    Parse_RepeatStmt;
    IsExecutable := false;
  end
  else if IsCurrText('while') then
  begin
    IsExecutable := true;
    Parse_WhileStmt;
    IsExecutable := false;
  end
  else if IsCurrText('for') then
  begin
    IsExecutable := true;
    Parse_ForStmt;
    IsExecutable := false;
  end
  else if IsCurrText('break') then
  begin
    IsExecutable := true;
    Parse_BreakStmt;
    IsExecutable := false;
  end
  else if IsCurrText('continue') then
  begin
    IsExecutable := true;
    Parse_ContinueStmt;
    IsExecutable := false;
  end
  else if IsCurrText('exit') then
  begin
    IsExecutable := true;
    Parse_ExitStmt;
    IsExecutable := false;
  end
  else if IsCurrText('label') then
  begin
    IsExecutable := true;
    Parse_LabelStmt;
    IsExecutable := false;
  end
  else if IsCurrText('halt') then
  begin
    IsExecutable := true;
    Parse_HaltStmt;
    IsExecutable := false;
  end
  else if IsCurrText('with') then
  begin
    IsExecutable := true;
    Parse_WithStmt;
    IsExecutable := false;
  end
  else if IsCurrText('uses') then
    Parse_ImportsStmt
  else if IsCurrText('try') then
  begin
    IsExecutable := true;
    Parse_TryStmt;
    IsExecutable := false;
  end
  else if IsCurrText('raise') then
  begin
    IsExecutable := true;
    Parse_RaiseStmt;
    IsExecutable := false;
  end
  else if IsCurrText('program') then
    Parse_ProgramStmt
  else if IsCurrText('unit') then
    Parse_UnitStmt
  else
  begin
    IsExecutable := true;
    Parse_SimpleStatement;
    IsExecutable := false;
  end;

  GenDestroyArrayArgumentList;
end;

procedure TPAXPascalParser.Parse_DynamicArrayType(ClassID: Integer);
var
  ElTypeID: Integer;
  ClassDef: TPaxClassDefinition;
begin
  // match "of"
  Call_SCANNER();
  ElTypeID := Parse_TypeID();

  Gen(OP_CREATE_DYNAMIC_ARRAY_TYPE, ClassId, ElTypeId, 0);
  try
    _BeginWrite;
    ClassDef := DefinitionList.AddDynamicArrayType(Name[ClassID], Name[ElTypeID], nil);
    ClassDef.AddToScripter(Scripter);
  finally
    _EndWrite;
  end;
end;

procedure TPAXPascalParser.Parse_ArrayStmt(ClassID: Integer);

type
  TTypeRec = record
    B1, B2: String;
  end;

const
  BR = #13#10;

function L(J: Integer): String;
begin
  result := 'L' + IntToStr(J);
end;

function H(J: Integer): String;
begin
  result := 'H' + IntToStr(J);
end;

function I(J: Integer): String;
begin
  result := 'I' + IntToStr(J);
end;

var
  TypeRecords: array[1..20] of TTypeRec;
  K: Integer;
  J, P1, P2, TypeID: Integer;
  S, TypeName, ItemTypeName: String;

  TempScanner: TPAXScanner;
  temp: boolean;
begin
  // match "array"
  DeclareSwitch := false;

  K := 0;
  Call_SCANNER;

  if IsCurrText('of') then
  begin
    Parse_DynamicArrayType(ClassID);
    Exit;
  end;

  Match('[');

  TypeName := Name[ClassID];

  repeat
    Inc(K);

    Call_SCANNER;
    P1 := CurrToken.Position;
    Parse_Expression;
    P2 := CurrToken.Position;
    TypeRecords[K].B1 := Scanner.GetText(P1, P2 - 1);

    Match('..');
    Call_SCANNER;
    P1 := CurrToken.Position;
    Parse_Expression;
    P2 := CurrToken.Position;
    TypeRecords[K].B2 := Scanner.GetText(P1, P2 - 1);
  until not IsCurrText(',');

  DeclareSwitch := false;

  Match(']');
  Call_SCANNER;

  Match('of');
  Call_SCANNER;

  TypeID := Parse_TypeID;

  ItemTypeName := Name[TypeID];


  S := 'record ' + TypeName + BR +
       '  var' + BR;

  for J:=1 to K do
    S := S + L(J) + ',' + H(J) + ',';

  S := S + 'fItems;' + BR;

// Initialize

  S := S + 'procedure Initialize;' + BR
         + 'var V: ' + ItemTypeName + ';';

  S := S + 'var ';

  for J:=1 to K do
  begin
    S := S + I(J);
    if J < K then
      S := S + ','
    else
      S := S + ';'
  end;

  S := S + BR;

  S := S + 'begin' + BR;

  if TypeID = typeINTEGER then
    S := S + 'V := 0;' + BR
  else if TypeID = typeDOUBLE then
    S := S + 'V := 0.0;' + BR
  else if TypeID = typeSINGLE then
    S := S + 'V := 0.0;' + BR
  else if TypeID = typeCURRENCY then
    S := S + 'V := 0.0;' + BR
  else if TypeID = typeSTRING then
    S := S + 'V := "";' + BR
  else if TypeID = typeBOOLEAN then
    S := S + 'V := false; ' + BR;

  for J:=1 to K do
  begin
    S := S + L(J) + ':=' + TypeRecords[J].B1 + ';' + BR;
    S := S + H(J) + ':=' + TypeRecords[J].B2 + ';' + BR;
  end;

  S := S + 'var temp[';
  for J:=1 to K do
  begin
    S := S + H(J) + '-' + L(J);
    if J < K then
      S := S + ','
    else
      S := S + '];'
  end;

  S := S + BR;

  S := S + 'fItems := temp;' + BR;

  if IsArrayInitialization then
  begin
    for J:=1 to K do
      S := S + 'for ' + I(J) + ':=' + L(J) + ' to ' + H(J) + ' do ' + BR;
    S := S + 'fItems[';
    for J:=1 to K do
    begin
      S := S + I(J) + '-' + L(J);
      if J < K then
        S := S + ','
      else
        S := S + '] := V;'
    end;
  end;


  S := S + 'end;' + BR;

// end of Initialize

// GetItem
  S := S + 'function GetItem(';
  for J:=1 to K do
  begin
    S := S + I(J);
    if J < K then
      S := S + ','
    else
      S := S + ');'
  end;

  S := S + 'begin' + BR;
  S := S + 'result := @ fItems[';
  for J:=1 to K do
  begin
    S := S + I(J) + '-' + L(J);
    if J < K then
      S := S + ','
    else
      S := S + '];'
  end;
  S := S + 'end;' + BR;
// End of GetItem

// SetItem
  S := S + 'procedure SetItem(';
  for J:=1 to K do
    S := S + I(J) + ',';
  S := S + 'Value);';
  S := S + 'begin' + BR;


  S := S + 'fItems[';
  for J:=1 to K do
  begin
    S := S + I(J) + '-' + L(J);
    if J < K then
      S := S + ','
    else
      S := S + '] := Value;'
  end;

  S := S + 'end;' + BR;
// End of SetItem

// property Items

  S := S + 'property Items[';


  for J:=1 to K do
  begin
    S := S + I(J);
    if J < K then
      S := S + ','
    else
      S := S + '] read GetItem write SetItem; default;';
  end;

  S := S + 'end;' + BR;
// end of record

//    AddExtraCode(TypeName, S);

  TempScanner := Scanner;
  try
    Scanner := TPAXPascalScanner.Create(Self);
    Scanner.SetScripter(Scripter);
    Scanner.SourceCode := S;

//    SaveStringToTextFile(S, '1.txt');

    Call_SCANNER;
    Call_SCANNER;

    temp := IsInterfaceSection;
    IsInterfaceSection := false;
    Parse_ClassStmt([], ckSTRUCTURE, ClassID);
    IsInterfaceSection := temp;

  finally
    Scanner.Free;
  end;

  Scanner := TempScanner;
end;

procedure TPAXPascalParser.Parse_TypeStmt;
var
  ml: TPAXModifierList;
  I, ClassID: Integer;
begin
// match "type"
  ml := [];

  ClassID := LookUpID(NextToken.Text);
  if ClassID > 0 then
  begin
    I := ForwardIds.IndexOf(ClassID);
    if I >= 0 then
    begin
      ForwardIds.Delete(I);
      ForwardPos.Delete(I);
      Call_SCANNER;
      Call_SCANNER;
    end
    else
    begin
      DeclareSwitch := true;
      Call_SCANNER;
      DeclareSwitch := false;
      ClassID := Parse_Ident;
//    raise TPAXScriptFailure.Create(Format(errIdentifierIsRedeclared,
//         [Name[ClassID]]));
    end;
  end
  else
  begin
    DeclareSwitch := true;
    Call_SCANNER;
    DeclareSwitch := false;
//    ClassID := Parse_Designator;
    ClassID := Parse_Ident;
  end;

  Kind[ClassID] := KindTYPE;

  Match('=');

  Call_SCANNER;

  if IsCurrText('class') then
  begin
    if IsNextText(';') then
    begin
      Call_SCANNER;
      ForwardPos.Add(Code.Card);
      ForwardIds.Add(ClassID);
    end
    else
      Parse_ClassStmt(ml, ckClass, ClassID);
  end
  else if IsCurrText('record') then
    Parse_ClassStmt(ml, ckStructure, ClassID)
  else if IsCurrText('(') then
    Parse_EnumStmt(ClassID)
  else if IsCurrText('array') then
    Parse_ArrayStmt(ClassID)
  else
  begin
    TPaxBaseScripter(Scripter).TypeAliasList.Add(ClassID, Parse_TypeID);
  end;

  Match(';');

  if IsNext2Text('=') then
    Parse_TypeStmt;
end;

procedure TPAXPascalParser.Parse_StmtList;
begin
  repeat
    Parse_Statement;

    if CurrToken.ID = SP_EOF then
      Exit;
    if CurrToken.ID = SP_POINT then
      Exit;
    Match(';');

    Call_SCANNER;

    if CurrToken.ID = SP_EOF then
      Exit;
    if CurrToken.Text[1] = '.' then
      Exit;
    if IsCurrText('end') then
      Exit;
    if IsCurrText('except') then
      Exit;
    if IsCurrText('finally') then
      Exit;
  until false;
end;

procedure TPAXPascalParser.Parse_SimpleStatement;
var
  I, ID, LeftID, RightID, NP, Arg1, Arg2, Res, Vars, T: Integer;
  IsreducedAssignment: Boolean;
  CallRec: TPaxCallRec;
label
  Again;
begin
  if IsCurrText('inherited') then
  begin
    if CurrClassID = 0 then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);
    if CurrSubID <> CurrMethodID then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);
    if IsNextText(';') then
    begin
      ID := CurrMethodID;
      NP := Count[ID];
      Res := NewRef;
      Name[Res] := Name[ID];
      GenRef(CurrThisID, maMyBase, Res);
      for I:=1 to NP do
        Gen(OP_PUSH, SymbolTable.GetParamID(ID, I), 0, 0);
      if StrEql('Create', Name[ID]) then
        Gen(OP_CALL, Res, NP, CurrThisID)
      else
        Gen(OP_CALL, Res, NP, 0);

      CallRec := TPaxCallRec.Create;
      CallRec.CallP := Scanner.PosNumber;
      CallRec.CallN := Code.Card;
      TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);

      Call_SCANNER;
    end
    else
    begin
      FieldSwitch := true;
      Call_SCANNER;
      Gen(OP_NOP, 0, 0, 0);
      LeftID := Parse_Ident;
      GenRef(CurrThisID, maMyBase, LeftID);
      if IsCurrText('(') then
      begin
        Call_SCANNER;
        if not IsCurrText(')') then
          NP := Parse_ArgumentList(LeftID, Vars)
        else
        begin
          NP := 0;
          Vars := 0;

          CallRec := TPaxCallRec.Create;
          CallRec.CallP := Scanner.PosNumber;
          CallRec.CallN := Code.Card + 1;
          TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);
        end;
        Match(')');
        if StrEql('Create', Name[LeftID]) then
          Gen(OP_CALL, LeftID, NP, CurrThisID)
        else
          Gen(OP_CALL, LeftID, NP, 0);
        SetVars(Vars);

        Call_SCANNER;
      end
      else
      begin
        Match(';');
        if StrEql('Create', Name[LeftID]) then
          Gen(OP_CALL, LeftID, 0, CurrThisID)
        else
          Gen(OP_CALL, LeftID, 0, 0);

          CallRec := TPaxCallRec.Create;
          CallRec.CallP := Scanner.PosNumber;
          CallRec.CallN := Code.Card;
          TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);
      end;
    end;
  end
  else if IsCurrText('print') then
    Parse_PrintList
  else if IsCurrText('println') then
    Parse_PrintlnList
  else if IsCurrText('goto') then
    Parse_GoToStmt
  else if IsCurrText('delete') and (not IsNextText('(')) then
  begin
    Call_SCANNER;
    LeftID := Parse_Designator(0);
    Gen(OP_RELEASE, LeftID, 0, 0);
  end
  else if IsCurrText('abort') and (not IsNextText('(')) then
  begin
    LeftID := Parse_Ident;
    Gen(OP_CALL, LeftID, 0, 0);
    CallRec := TPaxCallRec.Create;
    CallRec.CallP := Scanner.PosNumber;
    CallRec.CallN := Code.Card;
    TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);
  end
  else
  begin
    IsreducedAssignment := IsCurrText('reduced');
    if IsreducedAssignment then
      Call_SCANNER;

    Res := 0;

    if IsCurrText('(') then
    begin
      Call_SCANNER;
      ID := Parse_Designator(0);
      Match('as');
      Call_SCANNER;
      T := Parse_Ident;
      Gen(OP_PUSH, ID, 0, 0);
      res := ID;
      Gen(OP_CALL, T, 1, res);

      CallRec := TPaxCallRec.Create;
      CallRec.CallP := Scanner.PosNumber;
      CallRec.CallN := Code.Card;
      TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);

      Match(')');
      Call_SCANNER;
    end;

Again:
    Gen(OP_NOP, 0, 0, 0);
    LeftID := Parse_Designator(Res);

    if IsCurrText(':=') then
    begin
      Call_SCANNER;

      if IsreducedAssignment then
        Parse_reducedAssignment(LeftID)
      else if IsCallOperator(Arg1, Arg2, Res) then
      begin
        if IsCurrText('@') and (Arg2 > 0) then
        begin
          Code.Prog[LastCodeLine].Op := OP_GET_ITEM;
          Parse_Expression;
          Code.Prog[LastCodeLine].Res := Res;
        end
        else
        begin
          RemoveLastOperator;
          RightID := Parse_Expression;
          Gen(OP_PUSH, RightID, 0, 0);
          Gen(OP_PUT_PROPERTY, Arg1, Arg2 + 1, 0);
        end;
      end
      else
      begin
        if LeftID = CurrSubID then
          LeftID := SymbolTable.GetResultID(CurrSubID);
        RightID := Parse_Expression;
        if RightID = UndefinedID then
          Gen(OP_DESTROY_INTF, LeftID, 0, 0);
        Gen(OP_ASSIGN, LeftID, RightID, LeftID);

        if ConstIds.IndexOf(LeftID) <> -1 then
        begin
          TPaxBaseScripter(scripter).Dump;
          raise TPAXScriptFailure.Create(errCannotAssignConstant + SymbolTable.Name[LeftID]);
        end;
      end;
    end
    else if IsCurrText('(') then
    begin
      Call_SCANNER;
      if not IsCurrText(')') then
        NP := Parse_ArgumentList(LeftID, Vars)
      else
      begin
        NP := 0;
        Vars := 0;

        CallRec := TPaxCallRec.Create;
        CallRec.CallP := Scanner.PosNumber;
        CallRec.CallN := Code.Card + 1;
        TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);
      end;

      Match(')');
      Call_SCANNER;

      if IsCurrText('.') then
      begin
        Res := NewVar;
        Gen(OP_CALL, LeftID, NP, Res);
        SetVars(Vars);
        goto Again;
      end
      else
      begin
        Gen(OP_CALL, LeftID, NP, 0);
        SetVars(Vars);
      end;
    end
    else if IsCurrText(';') then
    begin
      if not IsCallOperator then
      begin
        Gen(OP_CALL, LeftID, 0, 0);
      end;
      CallRec := TPaxCallRec.Create;
      CallRec.CallP := Scanner.PosNumber;
      CallRec.CallN := Code.Card;
      TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);
    end;
  end;
end;

procedure TPAXPascalParser.Parse_CompoundStmt;
begin
  // match "begin"

  BeginBlock;

  Call_SCANNER;
  if not IsCurrText('end') then
    Parse_StmtList;

  EndBlock;

  Match('end');
end;

procedure TPAXPascalParser.Parse_IfStmt;
var
  L, LF, ExprID: Integer;
begin
  // match "if"

  Call_SCANNER;

  LF := NewLabel;
  ExprID := Parse_Expression;
  GenDestroyArrayArgumentList;
  Gen(OP_GO_FALSE, LF, ExprID, 0);

  Match('then');

  Call_SCANNER;
  Parse_Statement;

  if IsCurrText('else') then
  begin
    L := NewLabel;
    Gen(OP_GO, L, 0, 0);
    SetLabelHere(LF);

    MoveUpSourceLine;

    Call_SCANNER;
    Parse_Statement;

    SetLabelHere(L);
  end
  else
    SetLabelHere(LF);
end;

function TPAXPascalParser.Parse_FunctionStmt(ts: TPAXTypeSub; ml: TPAXModifierList): Integer;

var
  SubID: Integer;

procedure Parse_Directives(MemberRec: TPaxMemberRec);
begin
  while IsNextText('virtual') or
        IsNextText('override') or
        IsNextText('overload') or
        IsNextText('dynamic') or
        IsNextText('reintroduce') do
  begin
    Call_SCANNER;

    if IsCurrText('virtual') or IsCurrText('override') then
    if MemberRec <> nil then
    begin
      MemberRec.ml := MemberRec.ml + [modVIRTUAL];

      if SubId <> 0 then
        SymbolTable.A[SubId].IsVirtual := true;
    end;

    Call_SCANNER;
    Match(';');
  end;
end;

var
  L, ClassID, ResID, T, ResTypeID, ParamCount, ParamID, WithCount, I: Integer;
  IsFunc: Boolean;
  Ids: TPAXIds;
  _EraseCard, _EraseCodeCard: Integer;
  S: String;
  _SaveLevelCard: Integer;
  ProcNameID, DllID: Integer;
  Impl: Boolean;
  cc: Integer;
  TempCard, ValID: Integer;
  MemberRec: TPaxMemberRec;
  Rank: Integer;
  byref: boolean;
  FoundForward: Boolean;
  sign: Integer;
label
  Again;
begin
  _SaveLevelCard := LevelStack.Card;
  MemberRec := nil;
  FoundForward := false;

  Ids := TPAXIds.Create(false);

  IsFunc := IsCurrText('function') or IsCurrText('operator');
  ResTypeID := typeVARIANT;

  // match "function"

  Impl := false;
  if IsNext2Text('.') then
  begin
    Impl := true;

    ClassID := LookUpID(NextToken.Text);
    if ClassID = 0 then
      raise TPAXScriptFailure.Create(Format(errUndeclaredIdentifier,
        [NextToken.Text]));
    if Kind[ClassID] <> KindTYPE then
    begin
      TPAXBaseScripter(Scripter).Dump();
      raise TPAXScriptFailure.Create(Format(errUndeclaredIdentifier,
        [NextToken.Text]));
    end;
    Call_SCANNER;
    Call_SCANNER;

    LevelStack.Push(ClassID);

    ml := ml - [modSTATIC];
  end;

  SubID := LookUpID(NextToken.Text);
  I := ForwardIds.IndexOf(SubID);
  if I >= 0 then
  begin
    _EraseCard := SymbolTable.Card;
    _EraseCodeCard := Code.Card;
    ForwardIds.Delete(I);
    ForwardPos.Delete(I);
    Call_SCANNER;
    Call_SCANNER;
    FoundForward := true;
  end
  else
  begin
    _EraseCard := 0;
    _EraseCodeCard := 0;
    DeclareSwitch := true;
    Call_SCANNER;
    DeclareSwitch := false;
    if CurrToken.TokenClass = tcId then
      SubID := Parse_Ident
    else
      SubID := Parse_OverloadableOperator;
  end;

  result := SubID;

  if Impl then
    LevelStack.Push(SubID)
  else
    MemberRec := LevelStack.PushSub(SubID, CurrClassID, ml);

  if IsImplementationSection and (MemberRec <> nil) and (not FoundForward) then
  begin
    MemberRec.IsImplementationSection := true;
  end;

  NewVar;
  NewVar;

  ParamCount := 0;
  ResID := SymbolTable.GetResultID(SubID);

  if IsCurrText('(') then
  begin
    DeclareSwitch := true;
    Call_SCANNER;
    if not IsCurrText(')') then
    begin
      ParamCount := 0;

Again:

      byref := false;

      repeat
        Inc(ParamCount);
        if IsCurrText('var') or IsCurrText('out') then
        begin
          Ids.Add(Parse_ByRef);
          byref := true;
        end
        else if IsCurrText('const') then
        begin
          Call_SCANNER;
          ParamID := Parse_Ident;
//          SymbolTable.ByRef[ParamID] := 2;
          Ids.Add(ParamID);

          if not FoundForward then
            ConstIds.Add(ParamID);
        end
        else
        begin
          ParamID := Parse_Ident;
          Ids.Add(ParamID);

          if byref then
            SymbolTable.ByRef[ParamID] := 1;
        end;

        if IsCurrText(',') then
          Call_SCANNER
        else
          break;
      until false;

      if IsCurrText(':') then
      begin
        DeclareSwitch := false;
        Call_SCANNER;
        DeclareSwitch := true;

        T := typeVARIANT;

        if NewID then
        begin

          for I:=0 to Ids.Count - 1 do
          begin
            SymbolTable.TypeNameIndex[Ids[I]] := CreateNameIndex(CurrToken.Text, Scripter);
            Gen(OP_SET_TYPE, Ids[I], SymbolTable.TypeNameIndex[Ids[I]], 0);
          end;

          SymbolTable.DecCard;
          Call_SCANNER;
        end
        else
        begin
          T := Parse_Ident;
          if T > PAXTypes.Count then
            for I:=0 to Ids.Count - 1 do
              SymbolTable.TypeNameIndex[Ids[I]] := CreateNameIndex(CurrToken.Text, Scripter);
        end;
        for I:=0 to Ids.Count - 1 do
          TypeID[Ids[I]] := T;

        if IsCurrText('[') then
          Rank := Parse_Rank
        else
        begin
          if (T <= PaxTypes.Count) and (T > 0) and (T <> typeVARIANT) then
            Rank := -1
          else
            Rank := 0;
        end;

        for I:=0 to Ids.Count - 1 do
          SymbolTable.Rank[Ids[I]] := Rank;
      end;

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

        ValID := Parse_Expression;
        for I:=0 to Ids.Count - 1 do
          with TPaxBaseScripter(Scripter) do
          begin
            if sign = -1 then
              DefaultParameterList.AddParameter(SubID, Ids[I], - SymbolTable.VariantValue[ValID])
            else
              DefaultParameterList.AddParameter(SubID, Ids[I], SymbolTable.VariantValue[ValID]);
          end;
        SymbolTable.EraseTail(TempCard);
      end;

      Ids.Clear;

      if IsCurrText(';') then
      begin
        Call_SCANNER;
        goto Again;
      end;
    end;
    Match(')');
    DeclareSwitch := false;

    Call_SCANNER;
  end;

  Ids.Free;

  if IsFunc then
  begin
    if IsCurrText(':') then
    begin
      Call_SCANNER;
      ResTypeID := Parse_TypeID;

      if ResTypeID = SubID then
        ResTypeID := SymbolTable.Level[ResTypeID];
    end;
  end
  else
    ResTypeID := typeVOID;

  Match(';');

  Parse_Directives(MemberRec);

  cc := Parse_CallConv;
  if cc < 0 then
    cc := DefaultCallConv;
  SymbolTable.CallConv[SubID] := cc;

  Kind[SubID] := KindSUB;
  Count[SubID] := ParamCount;
  Next[SubID] := ResID;
  TypeSub[SubID] := ts;
  TypeID[SubID] := ResTypeID;

  Name[ResID] := 'result';
  TypeID[ResID] := ResTypeID;

  if CurrThisID > 0 then
  begin
    Name[CurrThisID] := 'Self';
    TypeID[CurrThisID] := CurrClassID;

    S := NextToken.Text;
    if (not StrEql(S, 'begin')) and (not StrEql(S, 'var')) and (not StrEql(S, 'const')) and
       (not StrEql(S, 'type')) and (not StrEql(S, 'label')) then
    begin
      ForwardPos.Add(Code.Card);
      ForwardIds.Add(SubID);
      LevelStack.Pop;
      Exit;
    end;
  end;

  if IsInterfaceSection then
  begin
    ForwardPos.Add(Code.Card);
    ForwardIds.Add(SubID);
    LevelStack.Card := _SaveLevelCard;
//    LevelStack.Pop;
    Exit;
  end;

  Call_SCANNER;
  if IsCurrText('forward') then
  begin
    ForwardPos.Add(Code.Card);
    ForwardIds.Add(SubID);
    LevelStack.Card := _SaveLevelCard;
//    LevelStack.Pop;
    Call_SCANNER;
    Exit;
  end
  else if IsCurrText('overload') then
  begin
    Call_SCANNER;
  end
  else if IsCurrText('virtual') then
  begin
    Call_SCANNER;
    if MemberRec <> nil then
      MemberRec.ml := MemberRec.ml + [modVIRTUAL];
  end
  else if IsCurrText('override') then
  begin
    Call_SCANNER;
    if MemberRec <> nil then
      MemberRec.ml := MemberRec.ml + [modVIRTUAL];
  end
  else if IsCurrText('external') then
  begin
    Call_SCANNER;

    if CurrToken.ID < SymbolTable.Card then
    begin
      DllID := NewVar;
    end
    else
      DllID := CurrToken.ID;
    Name[DllID] := Value[CurrToken.ID];

    DeclareSwitch := true;
    Call_SCANNER;
    if IsCurrText('name') then
    begin
      ProcNameID := SymbolTable.Card;
      Call_SCANNER;
      Name[ProcNameID] := CurrToken.Text;
      Call_SCANNER;
    end
    else
    begin
      ProcNameID := NewVar;
      Name[ProcNameID] := Name[SubID];
    end;
    DeclareSwitch := false;

    LevelStack.Card := _SaveLevelCard;
    Next[SubID] := 0;
    Exit;
  end;

  if _EraseCard > 0 then
  begin
    SymbolTable.EraseTail(_EraseCard);
    Code.Card := _EraseCodeCard;
  end;

  Gen(OP_SKIP, 0, 0, 0);
  L := NewLabel;
  Gen(OP_GO, L, 0, 0);
  if Code.Prog[Code.Card].OP = OP_SEPARATOR then
    Value[SubID] := Code.Card
  else
    Value[SubID] := Code.Card + 1;

  if CurrThisID > 0 then
    WithCount := GenBeginWith(CurrThisID)
  else
    WithCount := GenBeginWith(CurrClassID);

  repeat

    if IsCurrText('function') then
    begin
      Parse_FunctionStmt(tsGlobal, []);
      Match(';');
      Call_SCANNER;
    end
    else if IsCurrText('operator') then
    begin
      Parse_FunctionStmt(tsGlobal, []);
      Match(';');
      Call_SCANNER;
    end
    else if IsCurrText('procedure') then
    begin
      Parse_FunctionStmt(tsGlobal, []);
      Match(';');
      Call_SCANNER;
    end
    else if IsCurrText('class') then
    begin
      Parse_ClassStmt([], ckClass);
      Match(';');
      Call_SCANNER;
    end
    else if IsCurrText('var') then
    begin
      DeclareSwitch := true;
      Call_SCANNER;
      Parse_VarStmt(false, ml, false);
      Match(';');
      Call_SCANNER;
    end
    else if IsCurrText('const') then
    begin
      DeclareSwitch := true;
      Call_SCANNER;
      Parse_VarStmt(false, ml, true);
      Match(';');
      Call_SCANNER;
    end
    else if IsCurrText('label') then
    begin
      Parse_LabelStmt;
      Match(';');
      Call_SCANNER;
    end
    else if IsCurrText('record') then
    begin
      Parse_ClassStmt([], ckStructure);
      Match(';');
      Call_SCANNER;
    end
    else if IsCurrText('enum') then
    begin
      Parse_EnumStmt;
      Match(';');
      Call_SCANNER;
    end
    else if IsCurrText('type') then
    begin
      Parse_TypeStmt;
      Match(';');
      Call_SCANNER;
    end
    else
      Match('begin');
  until IsCurrText('begin');

  if (ts <> tsConstructor) and IsFunc and (TypeID[ResID] < SymbolTable.Card) then
    Gen(OP_CREATE_RESULT, TypeID[ResID], 0, ResID);

  SymbolTable.StartPosition[SubId] := CurrToken.Position - 1 + 5;

  Parse_CompoundStmt;

  GenEndWith(WithCount);

  GenDestroyLocalVars;

  IsExecutable := true;
  Gen(OP_RET, 0, 0, 0);
  IsExecutable := false;
  SetLabelHere(L);

//  LevelStack.Pop;
  LevelStack.Card := _SaveLevelCard;
  LinkVariables(SubID, IsFunc);

  Call_SCANNER;
end;

procedure TPAXPascalParser.Parse_NamespaceStmt(ml: TPAXModifierList);
var
  NamespaceID: Integer;
begin
  // match "namespace"
  CurrClassRec.UsingInitList.Add(LastCodeLine);

  Call_SCANNER;

  NamespaceID := Parse_Ident;

  TPAXBaseScripter(Scripter).Modules.Items[ModuleID].Namespaces.Add(NamespaceID);

  Kind[NamespaceID] := KindTYPE;
  LevelStack.PushClass(NamespaceID, 0, ml + [modSTATIC], ckClass, true);

  Gen(OP_USE_NAMESPACE, UsingList.PushUnique(NamespaceID), 0, 0);
  Gen(OP_HALT_OR_NOP, 0, 0, 0);
  
  Parse_StmtList;
  Match('end');
  Gen(OP_END_OF_NAMESPACE, NamespaceID, 0, 0);

  Call_SCANNER;

  LevelStack.Pop;
  UsingList.Delete(NamespaceID);
end;

function TPAXPascalParser.Parse_ClassStmt(ClassML: TPAXModifierList; ck: TPAXClassKind; _ClassID: Integer = -1): Integer;
var
  ClassID, AncestorClassID: Integer;

procedure Parse_PropertyStmt(ml: TPAXModifierList);
var
  PropertyRec: TPAXMemberRec;
  I, PropID, T, K: Integer;
  ParamIds: TPaxIds;
label
  Again;
begin
  // match "property"

  DeclareSwitch := true;
  Call_SCANNER;
  PropID := Parse_Ident;
  Kind[PropID] := KindPROP;
  DeclareSwitch := false;

//  FieldSwitch := true;
  PropertyRec := CurrClassRec.AddProperty(PropID, ml);

  ParamIds := TPaxIds.Create(false);

  if IsCurrText('[') then
  begin
    DeclareSwitch := true;
    Call_SCANNER;
    if not IsCurrText(']') then
    begin
Again:
      K := ParamIds.Count;
      repeat
        if IsCurrText('var') then
          ParamIds.Add(Parse_ByRef)
        else if IsCurrText('const') then
        begin
          Call_SCANNER;
          ParamIds.Add(Parse_Ident);
        end
        else
          ParamIds.Add(Parse_Ident);
        if IsCurrText(',') then
          Call_SCANNER
        else
          break;
      until false;

      if IsCurrText(':') then
      begin
        DeclareSwitch := false;
        Call_SCANNER;
        DeclareSwitch := true;
        T := Parse_TypeID;
        for I:=K to ParamIds.Count - 1 do
          TypeID[ParamIds[I]] := T;
      end;

      if IsCurrText(';') then
      begin
        Call_SCANNER;
        goto Again;
      end;
    end;

    Match(']');
    DeclareSwitch := false;

    Call_SCANNER;
  end;

  if IsCurrText(':') then
  begin
    Call_SCANNER;
    TypeID[PropID] := Parse_TypeID;
  end;

  while IsCurrText('read') or
        IsCurrText('write')
  do
  begin
    if IsCurrText('read') then
    begin
      if PropertyRec.ReadID <> 0 then
        Match(';');

      Call_SCANNER;
      FieldSwitch := true;
      PropertyRec.ReadID := Parse_Ident;

      if Count[PropertyRec.ReadID] > ParamIds.Count then
        raise TPAXScriptFailure.Create(errNotEnoughParameters)
      else if Count[PropertyRec.ReadID] < ParamIds.Count then
        raise TPAXScriptFailure.Create(errTooManyParameters);
    end
    else if IsCurrText('write') then
    begin
      if PropertyRec.WriteID <> 0 then
        Match(';');

      Call_SCANNER;
      FieldSwitch := true;
      PropertyRec.WriteID := Parse_Ident;
    end
  end;

  if PropertyRec.ReadID + PropertyRec.WriteID = 0 then
    Match('read');

  PropertyRec.NParams := ParamIds.Count;  
    ParamIds.Free;

  if IsNextText('default') then
  begin
    PropertyRec.ml := PropertyRec.ml + [modDEFAULT];
    DirectiveSwitch := true;

    Call_SCANNER;
    Call_SCANNER;
  end;
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
  if _ClassID = -1 then
  begin
    Call_SCANNER;

    ClassID := Parse_Ident;
    Kind[ClassID] := KindTYPE;
  end
  else
  begin
    ClassID := _ClassID;
    Call_SCANNER;

    if CurrToken.TokenClass = tcID then
      SymbolTable.Level[CurrToken.ID] := ClassID;
  end;

  result := ClassID;

  if CurrSubID > 0 then
   SymbolTable.SetLocal(result);

  if IsCurrText('(') then
  begin
    Call_SCANNER;
    AncestorClassID := Parse_Ident;

    if AncestorClassID > PaxTypes.Count then
      TPaxBaseScripter(Scripter).UnknownTypes.AddObject(AncestorClassID,
        TPaxIDRec.Create(AncestorClassID, Code.Card, Scanner.PosNumber));

    Match(')');
    Call_SCANNER;

    SymbolTable.Level[AncestorClassID] := -1;
  end
  else
    AncestorClassID := 0;

  LevelStack.PushClass(ClassID, AncestorClassID, ClassML, ck, true);

  ml := [modPUBLIC];
  if not IsCurrText('end') then
  repeat

    while IsCurrText('public') or IsCurrText('private') or IsCurrText('protected') do
    begin
      if IsCurrText('public') then
        ml := [modPUBLIC]
      else if IsCurrText('private') then
        ml := [modPRIVATE]
      else if IsCurrText('protected') then
        ml := [modPROTECTED];
      Call_SCANNER;
    end;

    if IsCurrText('end') then
      Break;

    DeclareSwitch := true;
    if IsCurrText('class') then
    begin
      if IsNextText('function') then
      begin
        Call_SCANNER;
        Parse_FunctionStmt(tsMethod, ml + [modSTATIC]);
      end
      else if IsNextText('operator') then
      begin
        Call_SCANNER;
        Parse_FunctionStmt(tsMethod, ml + [modSTATIC]);
      end
      else if IsNextText('procedure') then
      begin
        Call_SCANNER;
        Parse_FunctionStmt(tsMethod, ml + [modSTATIC]);
      end
      else if IsNextText('property') then
      begin
        Call_SCANNER;
        Parse_PropertyStmt(ml + [modSTATIC]);
      end
      else if IsNextText('var') then
      begin
        Call_SCANNER;
        DeclareSwitch := true;
        Call_SCANNER;
        Parse_VarStmt(true, ml + [modSTATIC], false);
      end
      else if IsNextText('const') then
      begin
        Call_SCANNER;
        DeclareSwitch := true;
        Call_SCANNER;
        Parse_VarStmt(true, ml + [modSTATIC], true);
      end
      else if IsNextText('record') then
      begin
        Call_SCANNER;
        Parse_ClassStmt(ml + [modSTATIC], ckStructure);
      end
      else if IsNextText('enum') then
      begin
        Call_SCANNER;
        Parse_EnumStmt;
      end
      else
        Parse_ClassStmt(ml, ckClass);
    end
    else if IsCurrText('function') then
      Parse_FunctionStmt(tsMethod, ml)
    else if IsCurrText('operator') then
      Parse_FunctionStmt(tsMethod, ml)
    else if IsCurrText('procedure') then
      Parse_FunctionStmt(tsMethod, ml)
    else if IsCurrText('constructor') then
      Parse_FunctionStmt(tsConstructor, ml)
    else if IsCurrText('destructor') then
      Parse_FunctionStmt(tsDestructor, ml)
    else if IsCurrText('property') then
      Parse_PropertyStmt(ml)
    else if IsCurrText('record') then
      Parse_ClassStmt(ml, ckStructure)
    else if IsCurrText('enum') then
      Parse_EnumStmt
    else if IsCurrText('var') then
    begin
      DeclareSwitch := true;
      Call_SCANNER;
      Parse_VarStmt(true, ml, false);
    end
    else if IsCurrText('const') then
    begin
      DeclareSwitch := true;
      Call_SCANNER;
      Parse_VarStmt(true, ml, true);
    end
    else
    begin
      Parse_VarStmt(true, ml, false);
    end;

    Match(';');

    Call_SCANNER;

    if CurrToken.ID = SP_EOF then
      Break;
    if IsCurrText('end') then
      Break;
  until false;

  LevelStack.Pop;
  SetLabelHere(L);

  Call_SCANNER;
end;

function TPAXPascalParser.Parse_EnumStmt(_ClassID: Integer = -1): Integer;
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

  if _ClassID = -1 then
  begin
    DeclareSwitch := true;
    Call_SCANNER;
    DeclareSwitch := false;

    ClassID := Parse_Ident;
    Kind[ClassID] := KindTYPE;
  end
  else
  begin
    ClassID := _ClassID;

    if CurrToken.TokenClass = tcID then
      SymbolTable.Level[CurrToken.ID] := ClassID;
  end;

  result := ClassID;

  Kind[ClassID] := KindTYPE;

  AncestorClassID := 0;

  LevelStack.PushClass(ClassID, AncestorClassID, [modStatic], ckEnum, false);

  Match('(');
  Call_SCANNER;

  repeat
    ml := [];

    ID := Parse_Ident;
    MemberRec := CurrClassRec.AddField(ID, [modSTATIC]);
    TypeID[ID] := ClassID;
    SymbolTable.Level[ID] := 0;

    if IsCurrText('=') then
    begin
      Call_SCANNER;

      Gen(OP_NOP, 0, 0, 0);
      MemberRec.InitN := LastCodeLine;

      if ValueID = 0 then
        ValueID := NewVar;

      Gen(OP_ASSIGN, ValueID, Parse_Expression, ValueID);

      Gen(OP_ASSIGN, ID, ValueID, ID);
      Gen(OP_PLUS, ValueID, NewConst(1), ValueID);
      Gen(OP_HALT, 0, 0, 0);

      if IsCurrText(')') then
        Break;

      Match(',');
      Call_SCANNER;
    end
    else if IsCurrText(',') or IsCurrText(')') then
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

      if IsCurrText(')') then
        Break;

      Call_SCANNER;
    end
    else
      Break;

    if CurrToken.ID = SP_EOF then
      Break;
  until false;

  Match(')');

  LevelStack.Pop;
  SetLabelHere(L);

  Call_SCANNER;

  UsingList.Push(ClassID);
  EnumIDs.Add(ClassID);
end;

procedure TPAXPascalParser.Parse_VarStmt(IsField: Boolean; ml: TPAXModifierList; IsConst: Boolean);
label
  Again;
var
  Ids: TPAXIds;
  L: Integer;
begin
  L := 0;
  if not IsField then
  if (CurrClassID > 0) and (CurrSubID = 0) and (BlockCount = 0) then
  begin
    L := NewLabel;
    Gen(OP_SKIP, 0, 0, 0);
    Gen(OP_GO, L, 0, 0);
  end;

  Ids := TPAXIds.Create(false);

Again:
  Ids.Clear;
  Ids.Add(Parse_VariableDeclaration(IsField, ml, Ids, IsConst));

  while IsCurrText(',') do
  begin
    DeclareSwitch := true;
    Call_SCANNER;
    Ids.Add(Parse_VariableDeclaration(IsField, ml, Ids, IsConst));
  end;

  Match(';');

  if IsNext2Text(':') or IsNext2Text(',') or IsNext2Text('=') then
  begin
    DeclareSwitch := true;
    Call_SCANNER;
    goto Again;
  end;

  DeclareSwitch := false;
  Ids.Free;

  if not IsField then
  if (CurrClassID > 0) and (CurrSubID = 0) and (BlockCount = 0) then
  begin
    SetLabelHere(L);
  end;
end;

function TPAXPascalParser.Parse_VariableDeclaration(IsField: Boolean; ml: TPAXModifierList;
                                                    Ids: TPAXIds; IsConst: Boolean): Integer;
var
  ArrID, Vars, T, I, ID, N, Rank: Integer;
  MemberRec: TPAXMemberRec;
  ObjectInit, IsLocalVar: Boolean;
  L: Integer;
begin
  T := 0;
  MemberRec := nil;
  ObjectInit := false;

  result := Parse_Ident;
  Gen(OP_DECLARE, result, 0, 0);

  if IsConst then
    ConstIds.Add(result);

  IsLocalVar := false;

  if IsField then
  begin
    MemberRec := CurrClassRec.FindMember(NameIndex[result], maAny, true);
    if MemberRec <> nil then
      raise TPAXScriptFailure.Create(Format(errIdentifierIsRedeclared, [Name[result]]));

    MemberRec := CurrClassRec.AddField(result, ml);
  end
  else if (CurrClassID > 0) and (CurrSubID = 0) then
  begin
    MemberRec := CurrClassRec.FindMember(NameIndex[result], maAny, true);
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

    IsLocalVar := true;
  end;

  if BlockCount > 0 then
    MemberRec := nil;

  if (MemberRec <> nil) and IsImplementationSection then
    MemberRec.IsImplementationSection := true;

  if IsCurrText(':') then
  begin
    DeclareSwitch := false;
    Call_SCANNER;
    DeclareSwitch := true;
    T := Parse_TypeID;
    if (T > PAXTypes.Count) or (T < 0) then
    begin
      TPaxBaseScripter(Scripter).UnknownTypes.AddObject(T, TPaxIDRec.Create(T, Code.Card, Scanner.PosNumber));

      if MemberRec <> nil then
      begin
        MemberRec.InitN := LastCodeLine;

        if Code.Prog[MemberRec.InitN].Op = OP_EVAL_WITH then
          Dec(MemberRec.InitN);

        Gen(OP_CHECK_CLASS, T, 0, result);
        Gen(OP_CREATE_OBJECT, T, 0, result);
        if IsCurrText('=') and IsNextText('(') then
          ObjectInit := true
        else
          Gen(OP_HALT, 0, 0, 0);
      end
      else
      begin
        Gen(OP_CHECK_CLASS, T, 0, result);
        Gen(OP_CREATE_OBJECT, T, 0, result);
      end;

      for I:=0 to Ids.Count - 1 do
      begin
        ID := Ids[I];
        MemberRec := CurrClassRec.FindMember(NameIndex[ID], maAny);
        if (MemberRec <> nil) and (IsLocalVar = false) then
        begin
          MemberRec.InitN := LastCodeLine;
          T := GenEvalWith(T);

          Gen(OP_CHECK_CLASS, T, 0, result);
          Gen(OP_CREATE_OBJECT, T, 0, ID);
          Gen(OP_HALT, 0, 0, 0);
        end
        else
        begin
          Gen(OP_CHECK_CLASS, T, 0, result);
          Gen(OP_CREATE_OBJECT, T, 0, ID);
        end;
      end;
    end;

    for I:=0 to Ids.Count - 1 do
      TypeID[Ids[I]] := T;
    TypeID[result] := T;

  end;

  if IsCurrText('[') then
  begin
    if MemberRec <> nil then
      MemberRec.InitN := LastCodeLine;

    DeclareSwitch := false;
    Call_SCANNER;

    if CurrToken.TokenClass = tcIntegerConst then
      L := CurrToken.Value
    else
      L := 0;

    ArrID := 0;
    Rank := Parse_ArgumentList(ArrID, Vars);

    if T = typeSTRING then
    begin
      N := Gen(OP_CREATE_SHORT_STRING, result, L, 0);
      if L > 0 then
        SymbolTable.Count[result] := L;
    end
    else
      N := Gen(OP_CREATE_ARRAY, result, Rank, 0);

    if MemberRec <> nil then
       Gen(OP_HALT, 0, 0, 0);

    Match(']');
    Call_SCANNER;

    if IsCurrText('of') then
    begin
      DeclareSwitch := false;
      Call_SCANNER;
      DeclareSwitch := true;
      T := Parse_TypeID;

      Code.Prog[N].Res := T;

      SymbolTable.Rank[result] := Rank;
    end;
  end
  else if IsCurrText('=') then
  begin
    Gen(OP_NOP, 0, 0, 0);

    if (MemberRec <> nil) and (not ObjectInit) then
      MemberRec.InitN := LastCodeLine;

    DeclareSwitch := false;
    Call_SCANNER;

    Gen(OP_SKIP, 0, 0, 0);
    if IsCurrText('(') then
    begin
      Parse_ObjectInitializer(result);
      if MemberRec <> nil then
        Gen(OP_HALT, 0, 0, 0);
    end
    else
    begin
      ID := Parse_Expression;
      Gen(OP_ASSIGN, result, ID, result);
      if MemberRec <> nil then
      begin
        if Kind[ID] = KindCONST then
          Value[MemberRec.ID] := Value[ID];
        Gen(OP_HALT, 0, 0, 0);
      end;
    end;

    if not SymbolTable.IsLocal(result) then
      SymbolTable.Global[result] := true;

    TempObjectList.Clear;
  end
  else if T in [typeINTEGER, typeCARDINAL, typeBYTE, typeWORD, typeSHORTINT, typeSMALLINT, typeINT64, typeBOOLEAN,
      typeDOUBLE, typeSINGLE, typeCURRENCY, typeSTRING] then
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
    else if T in [typeDOUBLE, typeSINGLE, typeCURRENCY] then
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

procedure TPAXPascalParser.Parse_CaseStmt;

var
  CaseExprID: Integer;

function Parse_CaseLabel: Integer;
var
  ID1, ID2: Integer;
begin
  ID1 := Parse_ConstExpr;
  result := NewVar;
  if IsCurrText('..') then
  begin
    Gen(OP_GE, CaseExprID, ID1, result);

    ID2 := NewVar;
    Call_SCANNER;
    Gen(OP_LE, CaseExprID, Parse_ConstExpr, ID2);

    Gen(OP_AND, result, ID2, result);
  end
  else
    Gen(OP_EQ, CaseExprID, ID1, result);
end;

function Parse_CaseSelector: Integer;
begin
  result := Parse_CaseLabel;
  while IsCurrText(',') do
  begin
    Call_SCANNER;
    Gen(OP_OR, result, Parse_CaseLabel, result);
  end;
end;

var
  L, LF: integer;
begin
  // match "case"
  L := NewLabel;

  Call_SCANNER;
  CaseExprID := Parse_Expression;

  Match('of');

  Call_SCANNER;

  repeat
    LF := NewLabel;
    Gen(OP_GO_FALSE, LF, Parse_CaseSelector, 0);

    Match(':');
    Call_SCANNER;
    Parse_Statement;

    Gen(OP_GO, L, 0, 0);
    SetLabelHere(LF);

    Match(';');
    Call_SCANNER;
  until IsCurrText('else') or IsCurrText('end');

  if IsCurrText('else') then
  begin
    Call_SCANNER;
    Parse_Statement;
    if IsCurrText(';') then
      Call_SCANNER;
    Match('end');
  end;

  SetLabelHere(L);

  Call_SCANNER;
end;

procedure TPAXPascalParser.Parse_RepeatStmt;
var
  LB, LF, LC: Integer;
begin
  // match "repeat"
  LF := NewLabel;
  LB := NewLabel;
  LC := NewLabel;

  SetLabelHere(LF);

  EntryStack.Push(LB, LC, StatementLabel);
  Call_SCANNER;
  repeat
    if not IsCurrText('until') then
    begin
      Parse_Statement;
      if IsCurrText(';') then
        Call_SCANNER;
    end;
  until IsCurrText('until');
  EntryStack.Pop;

  Call_SCANNER;

  SetLabelHere(LC);
  Gen(OP_GO_FALSE, LF, Parse_Expression, 0);

  SetLabelHere(LB);
end;

procedure TPAXPascalParser.Parse_WhileStmt;
var
  L, LF: Integer;
begin
  // match "while"
  L := NewLabel;
  LF := NewLabel;
  SetLabelHere(L);

  Call_SCANNER;
  Gen(OP_GO_FALSE, LF, Parse_Expression, 0);
  Match('do');
  Call_SCANNER;
  EntryStack.Push(LF, L, StatementLabel);
  Parse_Statement;
  EntryStack.Pop;
  Gen(OP_GO, L, 0, 0);
  SetLabelHere(LF);
end;

procedure TPAXPascalParser.Parse_ForStmt;
var
  StepValue, Expr1ID, Expr2ID, StepID, RelExprID, L, LF, LI: Integer;
begin
  // match "for"

  L := NewLabel;
  LF := NewLabel;
  LI := NewLabel;

  RelExprID := NewVar;

  Call_SCANNER;
  Expr1ID := Parse_QualID;
  GenEvalWith(Expr1ID);

  Match(':=');
  Call_SCANNER;
  Gen(OP_ASSIGN, Expr1ID, Parse_Expression, Expr1ID);

  StepValue := 0;
  if IsCurrText('to') then
    StepValue := 1
  else if IsCurrText('downto') then
    StepValue := -1
  else
    Match('to');

  Call_SCANNER;
  Expr2ID := Parse_Expression;

  StepID := NewConst(StepValue);

  SetLabelHere(L);
  if StepValue > 0 then
    Gen(OP_LE, Expr1ID, Expr2ID, RelExprID)
  else
    Gen(OP_GE, Expr1ID, Expr2ID, RelExprID);

  Gen(OP_GO_FALSE, LF, RelExprID, 0);

  Match('do');
  Call_SCANNER;

  EntryStack.Push(LF, LI, StatementLabel);
  Parse_Statement;
  EntryStack.Pop;

  SetLabelHere(LI);
  Gen(OP_PLUS, Expr1ID, StepID, Expr1ID);

  Gen(OP_GO, L, 0, 0);

  SetLabelHere(LF);
end;

procedure TPAXPascalParser.Parse_ExitStmt;
begin
  // match "exit"
  Call_SCANNER;
  Gen(OP_EXIT0, 0, 0, 0);
  Gen(OP_EXIT, 0, 0, 0);
end;

procedure TPAXPascalParser.Parse_LabelStmt;
var
  ID: Integer;
begin
  // match "label"

  DeclareSwitch := true;

  repeat
    Call_SCANNER;
    ID := Parse_Ident;
    Kind[ID] := KindLABEL;

    if IsCurrText(',') then
      Call_SCANNER
    else
      Break;

  until false;

  DeclareSwitch := false;
end;


procedure TPAXPascalParser.Parse_HaltStmt;
begin
  // match "halt"
  Call_SCANNER;
  if not IsCurrText(';') then
    Call_SCANNER;
  Gen(OP_HALT_GLOBAL, 0, 0, 0);
end;

procedure TPAXPascalParser.Parse_ContinueStmt;
begin
  // match "continue"

  if EntryStack.Count = 0 then
    raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);

  if IsNextText(';') then
    Gen(OP_EXIT, EntryStack.TopContinueLabel, 0, 0)
  else
  begin
    Call_SCANNER;
    if CurrToken.TokenClass = tcId then
       Gen(OP_EXIT, EntryStack.TopContinueLabel(CurrToken.Text), 0, 0)
    else
    begin
      Gen(OP_EXIT, EntryStack.TopContinueLabel, 0, 0);
      Exit;
    end;
  end;
  Call_SCANNER;
end;

procedure TPAXPascalParser.Parse_BreakStmt;
begin
  // match "break"

  if EntryStack.Count = 0 then
    raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);

  if IsNextText(';') then
    Gen(OP_EXIT, EntryStack.TopBreakLabel, 0, 0)
  else
  begin
    Call_SCANNER;
    if CurrToken.TokenClass = tcId then
       Gen(OP_EXIT, EntryStack.TopBreakLabel(CurrToken.Text), 0, 0)
    else
    begin
      Gen(OP_EXIT, EntryStack.TopBreakLabel, 0, 0);
      Exit;
    end;
  end;
  Call_SCANNER;
end;

procedure TPAXPascalParser.Parse_WithStmt;
var
  I, K, ID, ID2: Integer;
begin
  // match "with"

  Inc(WithCount);

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

  K := 1;
  while IsCurrText(',') do
  begin
    Inc(K);
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
  end;

  Match('do');

  Call_SCANNER;
  Parse_Statement;

  for I:=1 to K do
  begin
    Gen(OP_END_WITH, 0, 0, 0);
    WithStack.Pop;
  end;

  Dec(WithCount);
end;

procedure TPAXPascalParser.Parse_TryStmt;
var
  L, LTRY, ID: Integer;
begin
  // match "try"

  L := NewLabel;
  LTRY := NewLabel;
  Gen(OP_TRY_ON, LTRY, 0, 0);

  Call_SCANNER;

  if not IsCurrText('except') then
    Parse_StmtList;

  Gen(OP_GO, L, 0, 0);

  if IsCurrText('except') then
  begin
    Call_SCANNER;

    if IsCurrText('on') then
    begin
      DeclareSwitch := true;
      Call_SCANNER;
      ID := Parse_Ident;
      Gen(OP_CATCH, ID, 0, 0);
      DeclareSwitch := false;

      CurrClassRec.AddField(ID, [modSTATIC]);

      Match('do');
      Call_SCANNER;
      Parse_Statement;
      Call_SCANNER;
    end
    else if IsCurrText('end') then
      Gen(OP_CATCH, 0, 0, 0)
    else
    begin
      Gen(OP_CATCH, 0, 0, 0);
      Parse_StmtList;
    end;

    SetLabelHere(L);
  end
  else if IsCurrText('finally') then
  begin
    Gen(OP_FINALLY, 0, 0, 0);

    SetLabelHere(L);

    Call_SCANNER;

    if not IsCurrText('end') then
      Parse_StmtList;
    Gen(OP_EXIT_ON_ERROR, 0, 0, 0);
  end
  else
    Match('except');

  SetLabelHere(LTRY);
  Gen(OP_TRY_OFF, 0, 0, 0);

  Match('end');
  Call_SCANNER;
end;

procedure TPAXPascalParser.Parse_RaiseStmt;
var
  ID: Integer;
begin
  // match "raise"

  Call_SCANNER;

  if IsCurrText(';') then
    ID := 0
  else
    ID := Parse_Expression;

  Gen(OP_THROW, ID, 0, 0);
end;

procedure TPAXPascalParser.Parse_ProgramStmt;
var
  NamespaceID, ID: Integer;
  P: Pointer;
begin
  // match "program"
  CurrClassRec.UsingInitList.Add(LastCodeLine);

  DeclareSwitch := true;
  Call_SCANNER;
  DeclareSwitch := false;

  NamespaceID := Parse_Ident;
  Kind[NamespaceID] := KindTYPE;
  LevelStack.PushClass(NamespaceID, 0, [modSTATIC], ckClass, true);

  if IsCurrText('(') then
  begin
    Call_SCANNER;
    if not IsCurrText(')') then
    begin
      DeclareSwitch := true;
      ID := Parse_Ident;
      P := TPAXBaseScripter(Scripter).ParamList.GetAddress(Name[ID]);
      if P <> nil then
        Address[ID] := P;
      CurrClassRec.AddField(ID, []);
      while IsCurrText(',') do
      begin
        Call_SCANNER;
        ID := Parse_Ident;
        P := TPAXBaseScripter(Scripter).ParamList.GetAddress(Name[ID]);
        if P <> nil then
          Address[ID] := P;
        CurrClassRec.AddField(ID, []);
      end;
      DeclareSwitch := false;
    end;
    Match(')');
    Call_SCANNER;
  end;
  TPaxBaseScripter(scripter).Dump();

  Gen(OP_USE_NAMESPACE, UsingList.Push(NamespaceID), 0, 0);
  Gen(OP_HALT_OR_NOP, 0, 0, 0);

  Call_SCANNER;
  Parse_StmtList;
  LevelStack.Pop;
  UsingList.Pop;

end;

procedure TPAXPascalParser.Parse_UnitStmt;
var
  NamespaceID, L, I, Op, Arg1, Arg2, Res: Integer;
label
  Lab, LabImpl;
begin
  // match "unit"
  CurrClassRec.UsingInitList.Add(LastCodeLine);

  DeclareSwitch := true;
  Call_SCANNER;
  DeclareSwitch := false;

  NamespaceID := Parse_Ident;
  Kind[NamespaceID] := KindTYPE;
  LevelStack.PushClass(NamespaceID, 0, [modSTATIC], ckClass, true);

  Gen(OP_USE_NAMESPACE, UsingList.Push(NamespaceID), 0, 0);
  Gen(OP_HALT_OR_NOP, 0, 0, 0);

  Match(';');
  Call_SCANNER;

  if IsCurrText('interface') then
    Match('interface')
  else
  begin
    goto LabImpl;
  end;

  IsInterfaceSection := true;

  Call_SCANNER;

  if not IsCurrText('implementation') then
  begin
    repeat
      if IsCurrText('type') or IsCurrText('const') or IsCurrText('var') or
         IsCurrText('procedure') or IsCurrText('function') or
         IsCurrText('operator') or
         IsCurrText('constructor') or IsCurrText('destructor') or
         IsCurrText('uses') then
        Parse_Statement;

      if CurrToken.ID = SP_EOF then
        break;
      Match(';');

      Call_SCANNER;

      if CurrToken.ID = SP_EOF then
        break;
      if IsCurrText('implementation') then
        break;
    until false;
  end;

  IsInterfaceSection := false;

  Match('implementation');
  Call_SCANNER;

LabImpl:

  if IsCurrText('initialization') then goto Lab;
  if IsCurrText('finalization') then goto Lab;
  if IsCurrText('begin') then goto Lab;

  IsImplementationSection := true;

  if not IsCurrText('end') then
  repeat
    if IsCurrText('type') or IsCurrText('const') or IsCurrText('var') or
       IsCurrText('procedure') or IsCurrText('function') or
       IsCurrText('operator') or
       IsCurrText('constructor') or IsCurrText('destructor') or
       IsCurrText('uses') then
      Parse_Statement;

    if CurrToken.ID = SP_EOF then
      break;
    if CurrToken.ID = SP_POINT then
      break;
    Match(';');

    Call_SCANNER;

    if CurrToken.ID = SP_EOF then
      break;
    if CurrToken.Text[1] = '.' then
      break;
    if IsCurrText('end') then
      break;
    if IsCurrText('begin') then
      break;
    if IsCurrText('initialization') then
      break;
  until false;

  IsImplementationSection := false;

Lab:

  if IsCurrText('end') then
  begin
    Call_SCANNER;
    Match('.');
    Call_SCANNER;
  end
  else if IsCurrText('begin') then
  begin
    L := NewLabel;
    Gen(OP_GO, L, 0, 0);

    Code.InitializationList.Add(Code.Card);
//
    for I:=1 to Code.Card do
    begin
      op := Code.Prog[I].Op;
      Arg1 := Code.Prog[I].Arg1;
      Arg2 := Code.Prog[I].Arg2;
      Res := Code.Prog[I].Res;
      Code.Add(op, Arg1, Arg2, Res);
      if op = OP_USE_LANGUAGE_NAMESPACE then break;
    end;
//
    Call_SCANNER;
    repeat
      if IsCurrText('end') then
        break;
      Parse_Statement;

      if CurrToken.ID = SP_EOF then
        break;
      Match(';');
      Call_SCANNER;
      if CurrToken.ID = SP_EOF then
        break;
      if CurrToken.Text[1] = '.' then
        break;
    until false;

    SetLabelHere(L);
    Gen(OP_HALT, 0, 0, 0);

      Match('end');
      Call_SCANNER;
      Match('.');
      Call_SCANNER;
  end
  else if IsCurrText('initialization') then
  begin
    L := NewLabel;
    Gen(OP_GO, L, 0, 0);

    Code.InitializationList.Add(Code.Card);

//

    for I:=1 to Code.Card do
    begin
      op := Code.Prog[I].Op;
      Arg1 := Code.Prog[I].Arg1;
      Arg2 := Code.Prog[I].Arg2;
      Res := Code.Prog[I].Res;
      Code.Add(op, Arg1, Arg2, Res);
      if op = OP_USE_LANGUAGE_NAMESPACE then break;
    end;

//

    Call_SCANNER;
    repeat
      if IsCurrText('finalization') then
        break;
      if IsCurrText('end') then
        break;
      Parse_Statement;

      if CurrToken.ID = SP_EOF then
        break;
      if CurrToken.ID = SP_POINT then
        break;
      Match(';');

      Call_SCANNER;

      if CurrToken.ID = SP_EOF then
        break;
      if CurrToken.Text[1] = '.' then
        break;
    until false;

    SetLabelHere(L);
    Gen(OP_HALT, 0, 0, 0);

    if IsCurrText('end') then
    begin
      Call_SCANNER;
      Match('.');
      Call_SCANNER;
    end
    else if IsCurrText('finalization') then
    begin
      L := NewLabel;
      Gen(OP_GO, L, 0, 0);

      Code.FinalizationList.Add(Code.Card);

      Call_SCANNER;
      repeat
        if IsCurrText('end') then
          break;
        Parse_Statement;

        if CurrToken.ID = SP_EOF then
          break;
        if CurrToken.ID = SP_POINT then
          break;
        Match(';');

        Call_SCANNER;

        if CurrToken.ID = SP_EOF then
          break;
        if CurrToken.Text[1] = '.' then
          break;
      until false;

      SetLabelHere(L);
      Gen(OP_HALT, 0, 0, 0);

      Match('end');
      Call_SCANNER;
      Match('.');
      Call_SCANNER;
    end;
  end
  else
    Match('end');

  LevelStack.Pop;
  UsingList.Pop;
end;

procedure TPAXPascalParser.Parse_Program;
var
  I, K, Id, Level: Integer;
  L: TPAXIds;
  C: TPaxClassRec;
  LTRY: Integer;
  M: TPaxMemberRec;
begin
  if CurrToken.ID = SP_EOF then
    Exit;

  Gen(OP_UPCASE_ON, 0, 0, 0);

  if VBArrays then
    Gen(OP_VBARRAYS_ON, 0, 0, 0)
  else
    Gen(OP_VBARRAYS_OFF, 0, 0, 0);

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

  Parse_StmtList;

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
        begin
          M := C.MemberList.GetMemberRec(SymbolTable.Name[Id], true);
          if M <> nil then
            if M.IsStatic then
              L.Add(Id);
        end;
      end;
    end;

  for I:=0 to L.Count - 1 do
    Gen(OP_DESTROY_INTF, L[I], 0, 1);

  L.Free;

  Gen(OP_EXIT_ON_ERROR, 0, 0, 0);
  SetLabelHere(LTRY);
  Gen(OP_TRY_OFF, 0, 0, 0);

  if ForwardIds.Count > 0 then
  begin
    Code.Card := ForwardPos[0];
    raise TPaxScriptFailure.Create(errForward + ' ' + Name[ForwardIds[0]]);
  end;

  for I:=0 to EnumIds.Count - 1 do
    Gen(OP_END_WITH, EnumIds[I], 0, 0);
end;

end.
