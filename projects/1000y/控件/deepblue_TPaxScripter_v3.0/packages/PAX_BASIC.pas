////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: PAX_BASIC.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit PAX_BASIC;

interface

uses
  SysUtils, Classes,
  BASE_CONSTS,
  BASE_SYS, BASE_SCANNER, BASE_PARSER, BASE_SCRIPTER, BASE_CLASS, BASE_EXTERN;

const
  SP_INC = -1001;
  SP_DEC = -1002;

  SP_PLUS_ASSIGN = -1003;
  SP_MINUS_ASSIGN = -1004;
  SP_MULT_ASSIGN = -1005;
  SP_DIV_ASSIGN = -1006;
  SP_POWER_ASSIGN = -1007;
  SP_INT_DIV_ASSIGN = -1008;
  SP_CONCAT_ASSIGN = -1009;

  SP_LOGICAL_IMP = -1018;

  SP_CONCAT = -1019;
type
  TPAXBasicScanner = class(TPAXScanner)
  public
    procedure ReadToken; override;
  end;

  TPAXForLoopStack = class;

  TPAXBasicParser = class(TPAXParser)
  public
    SeparatorIDs: TList;
    EntryStackDO: TPAXEntryStack;
    EntryStackFOR: TPAXEntryStack;
    ForLoopStack: TPAXForLoopStack;

    constructor Create; override;
    destructor Destroy; override;
    procedure Reset; override;
    function IsBaseType(const S: String): Boolean; override;
    function Parse_OverloadableOperator: Integer; override;

    function Parse_TypeID: Integer;
    function Parse_EvalExpression: Integer; override;
    function Parse_ArgumentExpression: Integer; override;
    procedure _Call_SCANNER;
    procedure Call_SCANNER; override;
    procedure SkipColons;
    procedure Match(const S: String); override;
    function Parse_PrimaryExpression: Integer;
    function Parse_ObjectLiteral: Integer;
    function Parse_MemberExpression(ID: Integer): Integer;
    function Parse_NewExpression: Integer;
    function Parse_PowerExpression: Integer;
    function Parse_UnaryMinusExpression: Integer;
    function Parse_MultiplicativeExpression: Integer;
    function Parse_ModExpression: Integer;
    function Parse_AdditiveExpression: Integer;
    function Parse_ConcatenationExpression: Integer;
    function Parse_EqualityExpression: Integer;
    function Parse_Expression: Integer;

/// STATEMENTS ////////////////////////////////////////////
    procedure Parse_Statement;
    function Parse_ModifierList: TPAXModifierList;

    function Parse_ClassStmt(ClassML: TPAXModifierList; ck: TPAXClassKind): Integer;
    function Parse_EnumStmt: Integer;
    procedure Parse_NamespaceStmt(ml: TPAXModifierList);
    procedure Parse_DimStmt(IsField: Boolean; ml: TPAXModifierList);
    function Parse_VariableDeclaration(IsField: Boolean; ml: TPAXModifierList): Integer;
    procedure Parse_SimpleStatement;
    procedure Parse_FunctionStmt(ts: TPAXTypeSub;
                                 ml: TPAXModifierList;
                                 cc: Integer = _ccStdCall);
    procedure Parse_ReturnStmt;
    procedure Parse_HaltStmt;
    procedure Parse_IfStmt;
    procedure Parse_ThrowStmt;
    procedure Parse_TryStmt;
    procedure Parse_ExitStmt;
    procedure Parse_WhileStmt;
    function Parse_ForStmt: Boolean;
    procedure Parse_DoStmt;
    procedure Parse_SelectCaseStmt;
    procedure Parse_WithStmt;

    procedure Parse_StmtList; override;
    procedure Parse_SourceElements;
    procedure Parse_Program; override;
  end;


  TPAXForLoopRec = class
  public
    ID: Integer;
    StepID: Integer;
    L, LC, LF: Integer;
  end;

  TPAXForLoopStack = class(TList)
  public
    procedure Push(ID, StepID, L, LC, LF: Integer);
    procedure Pop;
    function Top: TPAXForLoopRec;
  end;

implementation

procedure TPAXForLoopStack.Push(ID, StepID, L, LC, LF: Integer);
var
  R: TPAXForLoopRec;
begin
  R := TPAXForLoopRec.Create;
  R.ID := ID;
  R.StepID := StepID;
  R.L := L;
  R.LC := LC;
  R.LF := LF;
  Add(R);
end;

procedure TPAXForLoopStack.Pop;
begin
  TPAXForLoopRec(Items[Count - 1]).Free;
  Delete(Count - 1);
end;

function TPAXForLoopStack.Top: TPAXForLoopRec;
begin
  result := TPAXForLoopRec(Items[Count - 1]);
end;

procedure TPAXBasicScanner.ReadToken;

function ColonWasScanned(): Boolean;
var
  I: Integer;
  ch: Char;
begin
  result := false;
  I := 1;
  repeat
     if P - I <= 1 then
       break;

     Ch := Buff[P - I];
     case Ch of
        ':',#13,#10:
        begin
          result := true;
          Exit;
        end;
        #8, #9, #32: begin end;
        else
          Exit;
     end;
     Dec(I);
  until false;
end;

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
      '0'..'9': ScanDigits;
      '$': ScanHexDigits;
      'A'..'Z', 'a'..'z', '_':
      begin
        ScanIdentifier;
        if StrEql(Token.Text, 'mod') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_MOD;
        end
        else if StrEql(Token.Text, 'and') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_AND;
        end
        else if StrEql(Token.Text, 'in') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_IN_SET;
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
        else if StrEql(Token.Text, 'not') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := OP_NOT;
        end
        else if StrEql(Token.Text, 'imp') then
        begin
          Token.TokenClass := tcSpecial;
          Token.ID := SP_LOGICAL_IMP;
        end;
      end;
      '+':
      begin
        ScanPlus;
        if LA(1) = '=' then
        begin
          GetNextChar;
          Token.Text := '+=';
          Token.ID := SP_PLUS_ASSIGN;
        end;
      end;
      '-':
      begin
        ScanMinus;
        if LA(1) = '=' then
        begin
          GetNextChar;
          Token.Text := '-=';
          Token.ID := SP_MINUS_ASSIGN;
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
        ScanDiv;
        if LA(1) = '=' then
        begin
          GetNextChar;
          Token.Text := '/=';
          Token.ID := SP_DIV_ASSIGN;
        end;
      end;
      '\':
      begin
        GetNextChar;
        Token.TokenClass := tcSpecial;
        Token.Text := '\';
        Token.ID := OP_INT_DIV;
        if c = '=' then
        begin
          GetNextChar;
          Token.Text := '\=';
          Token.ID := SP_INT_DIV_ASSIGN;
        end;
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
          if ColonWasScanned then
          begin
            ScannerState := scanText;
            GetNextChar;
            ScanHtmlString('');
          end
          else
          begin
            Token.Text := ':';
            Token.TokenClass := tcSpecial;
            Token.ID := SP_COLON;
            Insert(':', Buff, P);
          end;
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
          else if LA(1) in ['a'..'z','A'..'Z'] then
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
      '&':
      begin
        GetNextChar;
        Token.TokenClass := tcSpecial;
        Token.Text := '&';
        Token.ID := SP_CONCAT;
        if LA(1) = '=' then
        begin
          GetNextChar;
          Token.Text := '&=';
          Token.ID := SP_CONCAT_ASSIGN;
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
      '^':
      begin
        GetNextChar;
        Token.TokenClass := tcSpecial;
        Token.Text := '^';
        Token.ID := OP_POWER;
        if c = '=' then
        begin
          GetNextChar;
          Token.Text := '^=';
          Token.ID := SP_POWER_ASSIGN;
        end;
      end;
      ':':
      begin
        ScanColon;
      end;
      '(': ScanLeftRoundBracket;
      ')': ScanRightRoundBracket;
      '[': ScanLeftBracket;
      ']': ScanRightBracket;
      ',': ScanComma;
      '.': ScanPoint;
     '''':
     begin
       repeat
          GetNextChar;
       until LA(1) in [#13, #10];
       Continue;
     end;
      '"': ScanString('"');
    else
      raise TPAXScriptFailure.Create(errIllegalCharacter);
    end;

    if Token.TokenClass <> tcNone then
      Exit;

  until false;
end;

constructor TPAXBasicParser.Create;
begin
  inherited;

  Scanner := TPAXBasicScanner.Create(Self);

  Upcase := true;

  SeparatorIds := TList.Create;
  EntryStackDO := TPAXEntryStack.Create;
  EntryStackFOR := TPAXEntryStack.Create;
  ForLoopStack := TPAXForLoopStack.Create;

  with Keywords do
  begin
    Add('ALIAS');
    Add('ADDRESSOF');
    Add('AND');
    Add('AS');
    Add('BYVAL');
    Add('BYREF');
    Add('BYTE');
    Add('CASE');
    Add('CATCH');
    Add('CDECL');
    Add('CLASS');
    Add('DECLARE');
    Add('DEFAULT');
    Add('DELETE');
    Add('DIM');
    Add('DO');
    Add('ELSE');
    Add('ELSEIF');
    Add('END');
    Add('ENUM');
    Add('FINALLY');
    Add('FOR');
    Add('FUNCTION');
    Add('IN');
    Add('INHERITS');
    Add('GET');
    Add('GOTO');
    Add('IF');
    Add('IMPORTS');
    Add('INHERITS');
    Add('LIB');
    Add('LONG');
    Add('LOOP');
    Add('MYBASE');
    Add('MYCLASS');
    Add('NAMESPACE');
    Add('NEXT');
    Add('NEW');
    Add('NOT');
    Add('OPERATOR');
    Add('OR');
    Add('OVERRIDE');
    Add('PASCAL');
    Add('PRIVATE');
    Add('PUBLIC');
    Add('PROPERTY');
    Add('PROTECTED');
    Add('REDUCED');
    Add('REGISTER');
    Add('RETURN');
    Add('SAFECALL');
    Add('SBYTE');
    Add('SET');
    Add('SELECT');
    Add('SHARED');
    Add('SHORT');
    Add('STDCALL');
    Add('STEP');
    Add('STRUCTURE');
    Add('SUB');
    Add('TERMINALOF');
    Add('THEN');
    Add('THROW');
    Add('TO');
    Add('TRY');
    Add('UINT');
    Add('UNTIL');
    Add('USHORT');
    Add('VIRTUAL');
    Add('WHILE');
    Add('WITH');
    Add('XOR');

    Add('PRINT');
    Add('PRINTLN');
  end;
end;

procedure TPAXBasicParser.Reset;
begin
  inherited;

  if Assigned(SeparatorIDs) then
    SeparatorIDs.Clear;
  if Assigned(EntryStackDO) then
    EntryStackDO.Clear;
  if Assigned(EntryStackFOR) then
    EntryStackFOR.Clear;
  if Assigned(ForLoopStack) then
    ForLoopStack.Clear;
end;

function TPAXBasicParser.Parse_TypeID: Integer;
var
  S: String;
begin
  if StrEql(CurrToken.Text, 'set') then
  begin
    result := typeSET;
    Call_SCANNER;
  end
  else
    result := Parse_Ident;
  S := Name[result];
  if (result > PAXTypes.Count) or (result < 0) then
  begin
//    if Kind[result] <> KindTYPE then
//      raise TPAXScriptFailure.Create(Format(errTypeNotFound, [S]));
  end
  else
    if not (result in SupportedPaxTypes) then
     raise TPAXScriptFailure.Create(Format(errTypeNotFound, [S]));
end;

destructor TPAXBasicParser.Destroy;
begin
  SeparatorIDs.Free;
  EntryStackDO.Free;
  EntryStackFOR.Free;
  ForLoopStack.Free;

  inherited;
end;

function TPAXBasicParser.Parse_EvalExpression: Integer;
begin
  result := Parse_Expression;
end;

function TPAXBasicParser.Parse_ArgumentExpression: Integer;
begin
  result := Parse_Expression;
end;

procedure TPAXBasicParser.SkipColons;
begin
  while IsCurrText(':') do
    Parse_Statement;
end;

procedure TPAXBasicParser.Call_SCANNER;
var
  S: String;
  TempID: Integer;
begin
  _Call_SCANNER;
  if IsCurrText('NULL') then
  begin
    CurrToken.ID := UndefinedID
  end
  else if CurrToken.TokenClass in [tcId, tcKeyword] then
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

procedure TPAXBasicParser._Call_SCANNER;
begin
  NewID := false;

  Scanner.ReadToken;
  CurrToken := Scanner.Token;

  if CurrToken.TokenClass = tcHtmlStringConst then
  begin
    GenHtml;
    Call_SCANNER;
    Exit;
  end;

  if CurrToken.TokenClass = tcId then
    if IsKeyword(CurrToken.Text) then
    begin
      CurrToken.TokenClass := tcKeyword;
      CurrToken.ID := 0;

      if IsCurrText('New') and IsNextText('(') then
        CurrToken.TokenClass := tcID;

      if IsCurrText('Long') then
      begin
        CurrToken.ID := typeINT64;
        CurrToken.TokenClass := tcId;
        Exit;
      end
      else if IsCurrText('byte') then
      begin
        CurrToken.ID := typeBYTE;
        CurrToken.TokenClass := tcId;
        Exit;
      end
      else if IsCurrText('sbyte') then
      begin
        CurrToken.ID := typeSHORTINT;
        CurrToken.TokenClass := tcId;
        Exit;
      end
      else if IsCurrText('short') then
      begin
        CurrToken.ID := typeSMALLINT;
        CurrToken.TokenClass := tcId;
        Exit;
      end
      else if IsCurrText('ushort') then
      begin
        CurrToken.ID := typeWORD;
        CurrToken.TokenClass := tcId;
        Exit;
      end
      else if IsCurrText('uint') then
      begin
        CurrToken.ID := typeCARDINAL;
        CurrToken.TokenClass := tcId;
        Exit;
      end
      else if IsCurrText('set') then
      begin
        CurrToken.ID := typeSET;
        CurrToken.TokenClass := tcId;
      end;
    end;

  if CurrToken.TokenClass = tcSeparator then
    if CurrToken.ID <> SP_EOF then
    begin
      SeparatorIds.Add(Pointer(CurrToken.ID));

      CurrToken.ID := SP_COLON;
      CurrToken.Text := ':';
      CurrToken.TokenClass := tcSPECIAL;
      Exit;
    end;

  if FieldSwitch then
  begin
    CurrToken.ID := NewField(CurrToken.Text);
    FieldSwitch := false;
    Exit;
  end;

  case CurrToken.TokenClass of
    tcIntegerConst, tcFloatConst:
    begin
      CurrToken.ID := SymbolTable.CodeNumberConst(CurrToken.Value);
      if CurrToken.TokenClass = tcFloatConst then
        TypeID[CurrToken.ID] := typeDOUBLE;
      if JavaScriptOperators then
        TypeID[CurrToken.ID] := typeVARIANT;
      Exit;
    end;
    tcStringConst:
    begin
      CurrToken.ID := SymbolTable.CodeStringConst(CurrToken.Text);
      if JavaScriptOperators then
        TypeID[CurrToken.ID] := typeVARIANT;
      Exit;
    end;
    tcId:
    if DeclareSwitch then
      with SymbolTable do
      begin
        CurrToken.ID := AppVariant(Undefined);
        Name[CurrToken.ID] := CurrToken.Text;
        Level[CurrToken.ID] := CurrLevel;
        Module[CurrToken.ID] := ModuleID;
        Position[CurrToken.ID] := CurrToken.Position - 1;

        NewID := true;
      end
    else
    begin
      CurrToken.ID := LookUpID(CurrToken.Text);
      if CurrToken.ID = 0 then
      begin
        with SymbolTable do
        begin
          CurrToken.ID := AppVariant(Undefined);
          Name[CurrToken.ID] := CurrToken.Text;
          Level[CurrToken.ID] := CurrLevel;
          Module[CurrToken.ID] := ModuleID;
          Position[CurrToken.ID] := CurrToken.Position - 1;

          NewID := true;
        end;
      end;
    end;
  end;
end;

function TPAXBasicParser.IsBaseType(const S: String): Boolean;
begin
  result := inherited IsBaseType(S);
  if result then
    Exit;
  result := StrEql(S, 'int') or
            StrEql(S, 'uint') or
            StrEql(S, 'sbyte') or
            StrEql(S, 'short') or
            StrEql(S, 'ushort') or
            StrEql(S, 'long') or
            StrEql(S, 'bool') or
            StrEql(S, 'void') or
            StrEql(S, 'set');
end;

procedure TPAXBasicParser.Match(const S: String);
var
  I: Integer;
begin
  if S = ':' then
  begin
    for I:=0 to SeparatorIds.Count - 1 do
      Gen(OP_SEPARATOR, ModuleID, Integer(SeparatorIds[I]), CurrLevel);
    SeparatorIDs.Clear;
  end;
  inherited;
end;

function TPAXBasicParser.Parse_OverloadableOperator: Integer;
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

///////  EXPRESSIONS /////////////////////////////////////////////////////////

function TPAXBasicParser.Parse_PrimaryExpression: Integer;
var
  ma: TPAXMemberAccess;
  ID, SubID: Integer;
  IsArrayItem: Boolean;
begin
  if IsCurrText('(') then // (Expression)
  begin
    Call_SCANNER;
    result := Parse_Expression;
    Match(')');
    Call_SCANNER;
  end
  else if IsCurrText('MyBase') or IsCurrText('MyClass') then
  begin
    if CurrClassID = 0 then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);
    if CurrSubID <> CurrMethodID then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);

    if IsCurrText('MyBase') then
      ma := maMyBase
    else
      ma := maMyClass;

    Call_SCANNER;
    Match('.');
    FieldSwitch := true;
    Call_SCANNER;
    result := Parse_Ident;
    GenRef(CurrThisID, ma, result);
  end
  else if IsCurrText('[') then // (array literal)
    result := Parse_ArrayLiteral
  else if IsCurrText('{') then // (object literal)
    result := Parse_ObjectLiteral
  else if IsCurrText('/') then // (regexp literal)
    result := Parse_RegExpr('New')
  else if IsCurrText('AddressOf') then
  begin
    result := NewVar;
    Call_SCANNER;
    if IsCallOperator then
      RemoveLastOperator;

    IsArrayItem := IsNextText('(') or IsNextText('[');

    SubID := Parse_MemberExpression(0);
    if IsCallOperator and (not IsArrayItem) then
      RemoveLastOperator;
    Gen(OP_ASSIGN_ADDRESS, result, SubID, result);
  end
  else if IsCurrText('TerminalOf') then
  begin
    Call_SCANNER;
    ID := Parse_MemberExpression(0);
    result := NewVar;
    Gen(OP_GET_TERMINAL, ID, 0, result);
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
  else if IsCurrText('.') then
  begin
    FieldSwitch := true;
    Call_SCANNER;
    result := Parse_Ident;
    GenRef(WithStack.Top, maAny, result);

    if not (CurrToken.Text[1] in ['(', '[']) then
      Gen(OP_CALL, result, 0, result);
  end
  else
  begin
    result := Parse_Ident;
    result := GenEvalWith(result);
  end;
end;

function TPAXBasicParser.Parse_ObjectLiteral: Integer;
begin
  result := 0; // not implemented yet
end;

function TPAXBasicParser.Parse_MemberExpression(ID: Integer): Integer;
var
  SubID, RefID, NP, Vars: Integer;
  S: String;
  CallRec: TPaxCallRec;
  Rank: Integer;
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
      '.':
      begin
        FieldSwitch := true;
        Call_SCANNER;

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
      '(', '[':
      begin
        if Rank = -1 then
          raise TPaxScriptFailure.Create(errCannotApplyToScalar);

        if CurrToken.Text = '(' then
          S := ')'
        else
          S := ']';

        SubID := result;

        Call_SCANNER;
        if IsCurrText(S) then
        begin
          NP := 0;
          Vars := 0;

          CallRec := TPaxCallRec.Create;
          CallRec.CallP := Scanner.PosNumber;
          CallRec.CallN := Code.Card + 1;
          TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);
        end
        else
          NP := Parse_ArgumentList(SubID, Vars);
        Match(S);

        if (Rank > 0) and (NP <> Rank) then
           raise TPaxScriptFailure.Create(errRankMismatch);

        result := NewVar;
        Gen(OP_CALL, SubID, NP, result);
        SetVars(Vars);

        Call_SCANNER;
      end;
    end;
end;

function TPAXBasicParser.Parse_NewExpression: Integer;
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

    TypeID[ObjectID] := ClassID;

    if IsCurrText('(') then
    begin
      result := NewRef;
      Name[result] := 'New';
      GenRef(ObjectID, maMyClass, result);
      result := Parse_MemberExpression(result);
    end
    else
      result := ObjectID;
  end
  else
    result := Parse_MemberExpression(0);
end;

function TPAXBasicParser.Parse_PowerExpression: Integer;
var
  ResID: Integer;
begin
  ResID := 0;
  result := Parse_NewExpression;

  while CurrToken.ID = OP_POWER do
  begin
    if ResID = 0 then
      ResID := NewVar;

    Call_SCANNER;
    Gen(OP_POWER, result, Parse_NewExpression, ResID);

    result := ResID;
  end;
end;

function TPAXBasicParser.Parse_UnaryMinusExpression: Integer;
begin
  if CurrToken.ID = OP_MINUS then
  begin
    result := NewVar;
    Call_SCANNER;
    Gen(OP_UNARY_MINUS, Parse_UnaryMinusExpression, 0, result);
  end
  else if CurrToken.ID = OP_PLUS then
  begin
    result := NewVar;
    Call_SCANNER;
    Gen(OP_UNARY_PLUS, Parse_UnaryMinusExpression, 0, result);
  end
  else
    result := Parse_PowerExpression;
end;

function TPAXBasicParser.Parse_MultiplicativeExpression: Integer;
var
  OP, ResID: Integer;
begin
  ResID := 0;
  result := Parse_UnaryMinusExpression;

  while
    (CurrToken.ID = OP_MULT) or
    (CurrToken.ID = OP_DIV) or
    (CurrToken.ID = OP_INT_DIV)
  do
  begin
    OP := CurrToken.ID;
    if ResID = 0 then
      ResID := NewVar;

    Call_SCANNER;
    Gen(OP, result, Parse_UnaryMinusExpression, ResID);

    result := ResID;
  end;
end;

function TPAXBasicParser.Parse_ModExpression: Integer;
var
  ResID: Integer;
begin
  ResID := 0;
  result := Parse_MultiplicativeExpression;

  while CurrToken.ID = OP_MOD do
  begin
    if ResID = 0 then
      ResID := NewVar;

    Call_SCANNER;
    Gen(OP_MOD, result, Parse_MultiplicativeExpression, ResID);

    result := ResID;
  end;
end;

function TPAXBasicParser.Parse_AdditiveExpression: Integer;
var
  OP, ResID: Integer;
begin
  ResID := 0;
  result := Parse_ModExpression;

  while
    (CurrToken.ID = OP_PLUS) or
    (CurrToken.ID = OP_MINUS)
  do
  begin
    OP := CurrToken.ID;
    if ResID = 0 then
      ResID := NewVar;

    Call_SCANNER;
    Gen(OP, result, Parse_ModExpression, ResID);

    result := ResID;
  end;
end;

function TPAXBasicParser.Parse_ConcatenationExpression: Integer;
var
  ResID: Integer;
begin
  ResID := 0;
  result := Parse_AdditiveExpression;

  while CurrToken.ID = SP_CONCAT do
  begin
    Call_SCANNER;
    if ResID = 0 then
    begin
      ResID := NewVar;
      Gen(OP_PLUS, result, Parse_AdditiveExpression, ResID);
    end
    else
      Gen(OP_PLUS, result, Parse_AdditiveExpression, ResID);

    result := ResID;
  end;
end;

function TPAXBasicParser.Parse_EqualityExpression: Integer;
var
  OP, ResID: Integer;
begin
  ResID := 0;
  result := Parse_ConcatenationExpression;

  while
    (CurrToken.ID = OP_EQ) or
    (CurrToken.ID = OP_NE) or
    (CurrToken.ID = OP_GT) or
    (CurrToken.ID = OP_LT) or
    (CurrToken.ID = OP_GE) or
    (CurrToken.ID = OP_LE) or
    (CurrToken.ID = OP_IN_SET)
  do
  begin
    OP := CurrToken.ID;
    if ResID = 0 then
      ResID := NewVar;

    Call_SCANNER;
    Gen(OP, result, Parse_ConcatenationExpression, ResID);

    result := ResID;
  end;
end;

function TPAXBasicParser.Parse_Expression: Integer;
var
  OP, ResID, A: Integer;
begin
  ResID := 0;

  if CurrToken.ID = OP_NOT then
  begin
    result := NewVar;
    Call_SCANNER;
    Gen(OP_NOT, ToBoolean(Parse_EqualityExpression), 0, result);
  end
  else
    result := Parse_EqualityExpression;

  while
     (CurrToken.ID = OP_AND) or
     (CurrToken.ID = OP_OR) or
     (CurrToken.ID = OP_XOR) or
     (CurrToken.ID = SP_LOGICAL_IMP)
  do
  begin
    OP := CurrToken.ID;
    Call_SCANNER;
    if ResID = 0 then
    begin
      if OP = SP_LOGICAL_IMP then // A imp B --> (not A) or B
      begin
        A := NewVar;
        Gen(OP_NOT, ToBoolean(result), 0, A);
        ResID := NewVar;
        Gen(OP_OR, A, ToBoolean(Parse_EqualityExpression), ResID);
      end
      else
      begin
        if (OP = OP_OR) and ShortEvalSwitch then
        begin
          ResID := Parse_ShortEvalOR(result, Parse_EqualityExpression, nil);
        end
        else if (OP = OP_AND) and ShortEvalSwitch then
        begin
          ResID := Parse_ShortEvalAND(result, Parse_EqualityExpression, nil);
        end
        else
        begin
          ResID := NewVar;
          Gen(OP, ToBoolean(result), ToBoolean(Parse_EqualityExpression), ResID);
        end;
      end;
    end
    else
    begin
      if OP = SP_LOGICAL_IMP then
      begin
        A := NewVar;
        Gen(OP_NOT, result, 0, A);
        ResID := NewVar;
        Gen(OP_OR, A, ToBoolean(Parse_EqualityExpression), ResID);
      end
      else
      begin
        if (OP = OP_OR) and ShortEvalSwitch then
        begin
          ResID := Parse_ShortEvalOR(result, Parse_EqualityExpression, nil);
        end
        else if (OP = OP_AND) and ShortEvalSwitch then
        begin
          ResID := Parse_ShortEvalAND(result, Parse_EqualityExpression, nil);
        end
        else
        begin
          Gen(OP, result, ToBoolean(Parse_EqualityExpression), ResID);
        end;
      end;
    end;
    result := ResID;
  end;
end;

procedure TPAXBasicParser.Parse_Statement;
var
  ml: TPAXModifierList;
  Normal: Boolean;
  cc: Integer;
begin
  ml := Parse_ModifierList;
  Normal := true;

  if CurrToken.ID = SP_COLON then // EmptyStatement
  begin end
  else if IsCurrText('class') then
    Parse_ClassStmt(ml, ckClass)
  else if IsCurrText('structure') then
    Parse_ClassStmt(ml, ckStructure)
  else if IsCurrText('enum') then
    Parse_EnumStmt
  else if IsCurrText('dim') then
  begin
    DeclareSwitch := true;
    Call_SCANNER;

    Parse_DimStmt(false, ml);
  end
  else if IsCurrText('namespace') then
    Parse_NamespaceStmt(ml)
  else if IsCurrText('declare') then
  begin
    cc := Parse_CallConv;
    if cc < 0 then
    begin
      cc := DefaultCallConv;
      Call_SCANNER;
    end;
    if IsCurrText('function') then
      Parse_FunctionStmt(tsGlobal, ml, cc)
    else if IsCurrText('sub') then
      Parse_FunctionStmt(tsGlobal, ml, cc)
    else
      Match('sub');
  end
  else if IsCurrText('function') then
    Parse_FunctionStmt(tsGlobal, ml)
  else if IsCurrText('sub') then
    Parse_FunctionStmt(tsGlobal, ml)
  else if IsCurrText('goto') then
  begin
    IsExecutable := true;
    Parse_GoToStmt;
    IsExecutable := false;
  end
  else if IsCurrText('label') then
  begin
    IsExecutable := true;
    Call_SCANNER;
    Parse_SetLabel;
    IsExecutable := false;
  end
  else if IsCurrText('if') then
  begin
    IsExecutable := true;
    Parse_IfStmt;
    IsExecutable := false;
  end
  else if IsCurrText('return') then
  begin
    IsExecutable := true;
    Parse_ReturnStmt;
    IsExecutable := false;
  end
  else if IsCurrText('select') then
  begin
    IsExecutable := true;
    Parse_SelectCaseStmt;
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
  else if IsCurrText('exit') then
  begin
    IsExecutable := true;
    Parse_ExitStmt;
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
    Normal := Parse_ForStmt;
    IsExecutable := false;
  end
  else if IsCurrText('do') then
  begin
    IsExecutable := true;
    Parse_DoStmt;
    IsExecutable := false;
  end
  else if IsCurrText('with') then
  begin
    IsExecutable := true;
    Parse_WithStmt;
    IsExecutable := false;
  end
  else if IsCurrText('imports') then
    Parse_ImportsStmt
  else
  begin
    IsExecutable := true;
    Parse_SimpleStatement;
    IsExecutable := false;
  end;

  if CurrToken.ID = SP_EOF then
    Exit;

  if Normal then
  begin
    if IsCurrText('print') or IsCurrText('println') then
    begin
      IsExecutable := true;
      Parse_Statement;
      IsExecutable := false;
      Exit;
    end;

    Match(':');
    Call_SCANNER;
    if IsCurrText(':') then
      SkipColons;
  end;

  GenDestroyArrayArgumentList;
end;

procedure TPAXBasicParser.Parse_DimStmt(IsField: Boolean; ml: TPAXModifierList);
var
  L: Integer;
begin
  L := 0;
  if not IsField then
  if (CurrClassID > 0) and (CurrSubID = 0) then
  begin
    L := NewLabel;
    Gen(OP_SKIP, 0, 0, 0);
    Gen(OP_GO, L, 0, 0);
  end;

  Parse_VariableDeclaration(IsField, ml);

  while IsCurrText(',') do
  begin
    DeclareSwitch := true;

    Call_SCANNER;
    Parse_VariableDeclaration(IsField, ml);
  end;

  DeclareSwitch := false;

  if not IsField then
  if (CurrClassID > 0) and (CurrSubID = 0) then
  begin
    SetLabelHere(L);
  end;
end;

function TPAXBasicParser.Parse_VariableDeclaration(IsField: Boolean; ml: TPAXModifierList): Integer;
var
  ArrID, T, Vars, ID, N, Rank, K: Integer;
  MemberRec: TPAXMemberRec;
  ObjectInit: Boolean;
begin
  T := 0;
  MemberRec := nil;
  ObjectInit := false;

  result := Parse_Ident;

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
      raise TPAXScriptFailure.Create(Format(errIdentifierIsRedeclared,
                                     [Name[result]]));
    SymbolTable.IncCard;
    SymbolTable.SetLocal(result);

    TestDupLocalVars(result);

    LocalVars.Add(result);
  end;

  if IsCurrText('As') then
  begin
    DeclareSwitch := false;
    Call_SCANNER;
    DeclareSwitch := true;

    T := Parse_TypeID;

    if (T > PAXTypes.Count) or (T < 0) then
    begin
      TPaxBaseScripter(Scripter).UnknownTypes.AddObject(T, TPaxIDRec.Create(T, Code.Card, Scanner.PosNumber));

      if MemberRec <> nil then
         MemberRec.InitN := LastCodeLine;
      T := GenEvalWith(T);
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

  if IsCurrText('(') then
  begin
    if MemberRec <> nil then
      MemberRec.InitN := LastCodeLine;

    if VBArrays then
      Gen(OP_VBARRAYS_ON, 0, 0, 0)
    else
      Gen(OP_VBARRAYS_OFF, 0, 0, 0);

    DeclareSwitch := false;
    Call_SCANNER;

    ArrID := 0;
    K := Parse_ArgumentList(ArrID, Vars);
    N := Gen(OP_CREATE_ARRAY, result, K, 0);

    if MemberRec <> nil then
       Gen(OP_HALT, 0, 0, 0);

    Match(')');
    Call_SCANNER;

    if IsCurrText('As') then
    begin
      DeclareSwitch := false;
      Call_SCANNER;
      DeclareSwitch := true;
      T := Parse_TypeID;

      Code.Prog[N].Res := T;

      Rank := 0;
      if IsCurrText('[') then
        Rank := Parse_Rank
      else
        if (T <= PaxTypes.Count) and (T > 0) and (T <> typeVARIANT) then
           Rank := -1;

      SymbolTable.Rank[result] := Rank;
      if (K <> Rank) then
         raise TPaxScriptFailure.Create(errRankMismatch);
    end;
  end
  else if IsCurrText('[') then
  begin
    if MemberRec <> nil then
      MemberRec.InitN := LastCodeLine;

    if VBArrays then
      Gen(OP_VBARRAYS_ON, 0, 0, 0)
    else
      Gen(OP_VBARRAYS_OFF, 0, 0, 0);

    DeclareSwitch := false;
    Call_SCANNER;

    ArrID := 0;
    K := Parse_ArgumentList(ArrID, Vars);
    N := Gen(OP_CREATE_ARRAY, result, K, 0);

    if MemberRec <> nil then
       Gen(OP_HALT, 0, 0, 0);

    Match(']');
    Call_SCANNER;

    if IsCurrText('As') then
    begin
      DeclareSwitch := false;
      Call_SCANNER;
      DeclareSwitch := true;
      T := Parse_TypeID;

      Code.Prog[N].Res := T;

      Rank := 0;
      if IsCurrText('[') then
        Rank := Parse_Rank
      else
        if (T <= PaxTypes.Count) and (T > 0) and (T <> typeVARIANT) then
           Rank := -1;

      SymbolTable.Rank[result] := Rank;
      if (K <> Rank) and (Rank > 0) then
         raise TPaxScriptFailure.Create(errRankMismatch);
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

      if ID = UndefinedID then
        Gen(OP_DESTROY_INTF, result, 0, 0);
      Gen(OP_ASSIGN, result, ID, result);

      if MemberRec <> nil then
      begin
  //      if Kind[ID] = KindCONST then
          Value[MemberRec.ID] := Value[ID];
        Gen(OP_HALT, 0, 0, 0);
      end;
    end;

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

function TPAXBasicParser.Parse_ModifierList: TPAXModifierList;
label
  Again;
begin
  result := [];

Again:

  if IsCurrText('default') then
  begin
    result := result + [modDEFAULT];
    Call_SCANNER;
    Goto Again;
  end;
  if IsCurrText('public') then
  begin
    result := result + [modPUBLIC];
    Call_SCANNER;
    Goto Again;
  end;
  if IsCurrText('private') then
  begin
    result := result + [modPRIVATE];

    if NextToken.TokenClass <> tcKeyword then
    begin
      CurrToken.Text := NextToken.Text;
      CurrToken.Text := 'Dim';
      Exit;
    end;

    Call_SCANNER;
    Goto Again;
  end;
  if IsCurrText('protected') then
  begin
    result := result + [modPROTECTED];
    Call_SCANNER;
    Goto Again;
  end;
  if IsCurrText('shared') then
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

procedure TPAXBasicParser.Parse_FunctionStmt(ts: TPAXTypeSub;
                                             ml: TPAXModifierList;
                                             cc: Integer = _ccStdCall);
var
  L, SubID, ResID, ParamID, ParamCount, WithCount, T,
  _SaveLevelCard, TempCard, ValID: Integer;
  S, EndWord: String;
  IsDllDefined: Boolean;
  DllName, ProcName: String;
  Rank: Integer;
  sign: Integer;
begin
  // match "function" or "sub"
  _SaveLevelCard := LevelStack.Card;

  EndWord := CurrToken.Text;

  Gen(OP_SKIP, 0, 0, 0);
  L := NewLabel;
  Gen(OP_GO, L, 0, 0);

  DeclareSwitch := true;
  Call_SCANNER;

  if StrEql(EndWord, 'Operator') then
    SubID := Parse_OverloadableOperator
  else
    SubID := Parse_Ident;

  SymbolTable.CallConv[SubID] := cc;

  S := Name[SubID];

  LevelStack.PushSub(SubID, CurrClassID, ml);

  ResID := NewVar;
  NewVar;
  ParamCount := 0;

  if IsCurrText('Lib') then
  begin
    IsDllDefined := true;
    DeclareSwitch := false;

    TempCard := SymbolTable.Card;

    Call_SCANNER;
    DeclareSwitch := true;
    DllName := Value[CurrToken.ID];
    ProcName := Name[SubID];
    Call_SCANNER;
    if IsCurrText('Alias') then
    begin
      Call_SCANNER;
      ProcName := CurrToken.Text;
      Call_SCANNER;
    end;

    SymbolTable.EraseTail(TempCard);
    SymbolTable.Card := TempCard;
  end
  else
    IsDllDefined := false;

  if IsCurrText('(') then
  begin
    DeclareSwitch := true;
    Call_SCANNER;
    if not IsCurrText(')') then
    begin
      ParamCount := 1;

      repeat
        if IsCurrText('ByVal') then
        begin
          Call_SCANNER;
          ParamID := Parse_Ident;
        end
        else if IsCurrText('ByRef') then
          ParamID := Parse_ByRef
        else
          ParamID := Parse_Ident;

        if IsCurrText('As') then
        begin
          DeclareSwitch := false;
          Call_SCANNER;
          DeclareSwitch := true;

          T := typeVARIANT;
          if NewID then
          begin
            SymbolTable.TypeNameIndex[ParamID] := CreateNameIndex(CurrToken.Text, Scripter);

            Gen(OP_SET_TYPE, ParamID, SymbolTable.TypeNameIndex[ParamID], 0);

            SymbolTable.DecCard;
            Call_SCANNER;
          end
          else
          begin
            if CurrToken.ID > PaxTypes.Count then
              SymbolTable.TypeNameIndex[ParamID] := CreateNameIndex(CurrToken.Text, Scripter);
            T := Parse_Ident;
          end;
          TypeID[ParamID] := T;

          if IsCurrText('[') then
            Rank := Parse_Rank
          else
          begin
            if (T <= PaxTypes.Count) and (T > 0) and (T <> typeVARIANT) then
              Rank := -1
            else
              Rank := 0;
          end;

          SymbolTable.Rank[ParamID] := Rank;

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
          with TPaxBaseScripter(Scripter) do
          begin
            if sign = - 1 then
              DefaultParameterList.AddParameter(SubID, ParamID, - SymbolTable.VariantValue[ValID])
            else
              DefaultParameterList.AddParameter(SubID, ParamID, SymbolTable.VariantValue[ValID]);
          end;
          SymbolTable.EraseTail(TempCard);
        end;

        if IsCurrText(',') then
        begin
          Inc(ParamCount);
          Call_SCANNER;
        end
        else
          Break;
      until false;
    end;
    Match(')');
    DeclareSwitch := false;

    Call_SCANNER;
  end;

  if StrEql(EndWord, 'Function') or StrEql(EndWord, 'Operator') then
  begin
    if IsCurrText('As') then
    begin
      DeclareSwitch := false;
      Call_SCANNER;
      DeclareSwitch := true;
      TypeID[SubID] := Parse_TypeID;
      TypeID[ResID] := TypeID[SubID];
    end;
  end
  else
    TypeID[SubID] := typeVOID;

  Match(':');

  Kind[SubID] := KindSUB;
  Count[SubID] := ParamCount;
  Next[SubID] := ResID;
  TypeSub[SubID] := ts;
  if StrEql(Name[SubID], 'New') then
    TypeSub[SubID] := tsConstructor;
  Value[SubID] := Code.Card;

  DeclareSwitch := false;

  if IsDllDefined then
  begin
    Name[NewVar] := DllName;
    Name[NewVar] := ProcName;

    LevelStack.Card := _SaveLevelCard;
    Next[SubID] := 0;
    Value[SubID] := 0;

    SetLabelHere(L);
    Exit;
  end;

  if CurrThisID > 0 then
  begin
    Name[CurrThisID] := 'Me';
    TypeID[CurrThisID] := CurrClassID;
    WithCount := GenBeginWith(CurrThisID);
  end
  else
    WithCount := GenBeginWith(CurrClassID);

  repeat
    Parse_Statement;
  until IsCurrText('end');
  IsExecutable := true;

  GenEndWith(WithCount);

  GenDestroyLocalVars;
  Gen(OP_RET, 0, 0, 0);
  SetLabelHere(L);

  LevelStack.Pop;

  LinkVariables(SubID, StrEql(EndWord, 'Function') or StrEql(EndWord, 'Operator'));

  Call_SCANNER;
  IsExecutable := false;
  Match(EndWord);
  Call_SCANNER;
end;

procedure TPAXBasicParser.Parse_ReturnStmt;
var
  ResID: Integer;
begin
  // match "return"

  ResID := SymbolTable.GetResultID(CurrLevel);

  Call_SCANNER;

  if not IsCurrText(':') then
    Gen(OP_ASSIGN_RESULT, ResID, Parse_Expression, ResID);

  Gen(OP_EXIT, 0, 0, 0);
end;

procedure TPAXBasicParser.Parse_HaltStmt;
begin
  // match "halt"
  Call_SCANNER;
  Gen(OP_HALT_GLOBAL, 0, 0, 0);
end;

procedure TPAXBasicParser.Parse_NamespaceStmt(ml: TPAXModifierList);
var
  NamespaceID: Integer;
begin
  CurrClassRec.UsingInitList.Add(LastCodeLine);
  // match "namespace"
  Call_SCANNER;
  NamespaceID := Parse_Ident;

  TPAXBaseScripter(Scripter).Modules.Items[ModuleID].Namespaces.Add(NamespaceID);

  Kind[NamespaceID] := KindTYPE;

  LevelStack.PushClass(NamespaceID, 0, ml + [modSTATIC], ckClass, true);

  Gen(OP_USE_NAMESPACE, UsingList.PushUnique(NamespaceID), 0, 0);
  Gen(OP_HALT_OR_NOP, 0, 0, 0);

  SkipColons;

  repeat
    Parse_Statement;
  until IsCurrText('end') or IsCurrText(':');

  Call_SCANNER;
  Match('namespace');
  Gen(OP_END_OF_NAMESPACE, NamespaceID, 0, 0);

  Call_SCANNER;

  LevelStack.Pop;
  UsingList.Delete(NamespaceID);
end;

function TPAXBasicParser.Parse_ClassStmt(ClassML: TPAXModifierList; ck: TPAXClassKind): Integer;
var
  ClassID, AncestorClassID: Integer;

procedure Parse_PropertyStmt(ml: TPAXModifierList);
var
  PropertyRec: TPAXMemberRec;
  PropID, ParamID, SubID, ResID, ValueID, I, ID: Integer;
  ParamIds: TPaxIds;
begin
  // match "property"
  DeclareSwitch := true;
  Call_SCANNER;
  PropID := CurrToken.ID;

  PropertyRec := CurrClassRec.AddProperty(Parse_Ident, ml);

  Kind[PropID] := KindPROP;
  if modDEFAULT in ml then
    PropertyRec.ml := PropertyRec.ml + [modDEFAULT];

  ParamIds := TPaxIds.Create(false);

  if IsCurrText('(') then
  begin
    DeclareSwitch := true;
    Call_SCANNER;
    repeat
      ParamID := Parse_Ident;
      ParamIds.Add(ParamID);

      if IsCurrText('As') then
      begin
        DeclareSwitch := false;
        Call_SCANNER;
        DeclareSwitch := true;
        TypeID[ParamID] := Parse_TypeID;
      end;

      if IsCurrText(',') then
        Call_SCANNER
      else
        break;
    until false;

    Match(')');
    DeclareSwitch := false;
    Call_SCANNER;
  end;

  if IsCurrText('As') then
  begin
    Call_SCANNER;
    TypeID[PropID] := Parse_TypeID;
  end;

  Match(':');
  Call_SCANNER;
  SkipColons;

  while IsCurrText('get') or
        IsCurrText('set')
  do
  begin
    if IsCurrText('get') then
    begin
      if PropertyRec.ReadID <> 0 then
        Match('end');

      SubID := NewVAR;
      PropertyRec.ReadID := SubID;

      Name[SubID] := Name[PropID] + '_get';

      LevelStack.PushSub(SubID, CurrClassID, ml);

      ResID := NewVar;
      NewVar;

      for I:=0 to ParamIds.Count - 1 do
      begin
        ID := NewVar;
        Name[ID] := Name[Integer(ParamIds[I])];
      end;

      Kind[SubID] := KindSUB;
      Count[SubID] := 0 + ParamIds.Count;
      Next[SubID] := ResID;
      TypeSub[SubID] := tsMethod;

      if Code.Prog[Code.Card].OP = OP_SEPARATOR then
        Value[SubID] := Code.Card
      else
        Value[SubID] := Code.Card + 1;

      Name[ResID] := 'result';
      Name[CurrThisID] := 'Me';
      TypeID[CurrThisID] := CurrClassID;

      Gen(OP_BEGIN_WITH, WithStack.Push(CurrThisID), 0, 0);

      Call_SCANNER;
      DeclareSwitch := false;
      repeat
        Parse_Statement;
      until IsCurrText('end');

      if CurrThisID > 0 then
      begin
        Gen(OP_END_WITH, 0, 0, 0);
        WithStack.Pop;
      end;

      Gen(OP_RET, 0, 0, 0);
      LevelStack.Pop;

      LinkVariables(SubID, true);

      Call_SCANNER;
      Match('get');

      Call_SCANNER;
      SkipColons;
    end
    else if IsCurrText('set') then
    begin
      if PropertyRec.WriteID <> 0 then
        Match('end');

      SubID := NewVAR;
      PropertyRec.WriteID := SubID;

      Name[SubID] := Name[PropID] + '_set';

      LevelStack.PushSub(SubID, CurrClassID, ml);

      ResID := NewVar;
      NewVar;

      for I:=0 to ParamIds.Count - 1 do
      begin
        ID := NewVar;
        Name[ID] := Name[Integer(ParamIds[I])];
      end;

      if IsNextText('(') then
      begin
        Call_SCANNER;

        Call_SCANNER;
        Parse_Ident;
        Match(')');
      end
      else
      begin
        ValueID := NewVar;
        Name[ValueID] := 'Value';
      end;

      Kind[SubID] := KindSUB;
      Count[SubID] := 1 + ParamIds.Count;
      Next[SubID] := ResID;
      TypeSub[SubID] := tsMethod;
      Value[SubID] := Code.Card + 1;
      Name[ResID] := 'result';
      Name[CurrThisID] := 'Me';
      TypeID[CurrThisID] := CurrClassID;

      Gen(OP_BEGIN_WITH, WithStack.Push(CurrThisID), 0, 0);

      Call_SCANNER;
      DeclareSwitch := false;
      repeat
        Parse_Statement;
      until IsCurrText('end');

      if CurrThisID > 0 then
      begin
        Gen(OP_END_WITH, 0, 0, 0);
        WithStack.Pop;
      end;

      Gen(OP_RET, 0, 0, 0);
      LevelStack.Pop;

      LinkVariables(SubID, false);

      Call_SCANNER;
      Match('set');

      Call_SCANNER;
      SkipColons;
    end;
  end;

  if PropertyRec.ReadID + PropertyRec.WriteID = 0 then
    Match('get');

  Match('end');

  Call_SCANNER;
  Match('property');

  Call_SCANNER;

  PropertyRec.NParams := ParamIds.Count;
  ParamIds.Free;
end;

var
  L: Integer;
  ml: TPAXModifierList;
  cc: Integer;
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

  SkipColons;
  if IsCurrText('inherits') then
  begin
    Call_SCANNER;
    AncestorClassID := Parse_Ident;
    SymbolTable.Level[AncestorClassID] := -1;

    if AncestorClassID > PaxTypes.Count then
      TPaxBaseScripter(Scripter).UnknownTypes.AddObject(AncestorClassID,
        TPaxIDRec.Create(AncestorClassID, Code.Card, Scanner.PosNumber));

    Match(':');
    Call_SCANNER;
  end
  else
    AncestorClassID := 0;

  SkipColons;

  LevelStack.PushClass(ClassID, AncestorClassID, ClassML, ck, true);

  repeat
    ml := Parse_ModifierList;

    if IsCurrText('function') then
      Parse_FunctionStmt(tsMethod, ml)
    else if IsCurrText('operator') then
      Parse_FunctionStmt(tsMethod, ml)
    else if IsCurrText('sub') then
      Parse_FunctionStmt(tsMethod, ml)
    else if IsCurrText('declare') then
    begin
      cc := Parse_CallConv;
      if cc < 0 then
      begin
        cc := DefaultCallConv;
        Call_SCANNER;
      end;
      if IsCurrText('function') then
        Parse_FunctionStmt(tsMethod, ml, cc)
      else if IsCurrText('sub') then
        Parse_FunctionStmt(tsMethod, ml, cc)
      else
        Match('sub');
    end
    else if IsCurrText('property') then
      Parse_PropertyStmt(ml)
    else if IsCurrText('dim') then
    begin
      DeclareSwitch := true;
      Call_SCANNER;

      Parse_DimStmt(true, ml);
    end
    else if IsCurrText('class') then
      Parse_ClassStmt(ml, ckClass)
    else if IsCurrText('enum') then
      Parse_EnumStmt
    else if IsCurrText('structure') then
      Parse_ClassStmt(ml, ckStructure);

    Match(':');
    Call_SCANNER;

    if CurrToken.ID = SP_EOF then
      Break;
    if IsCurrText('end') then
      Break;
  until false;

  LevelStack.Pop;
  SetLabelHere(L);

  Call_SCANNER;
  case ck of
    ckClass: Match('class');
    ckStructure: Match('structure');
  end;
  Call_SCANNER;
end;

function TPAXBasicParser.Parse_EnumStmt: Integer;
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

  Match(':');
  SkipColons;

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

      Gen(OP_ASSIGN, ValueID, Parse_Expression, ValueID);

      Gen(OP_ASSIGN, ID, ValueID, ID);
      Gen(OP_PLUS, ValueID, NewConst(1), ValueID);
      Gen(OP_HALT, 0, 0, 0);

      if IsCurrText(',') then
      begin
        Call_SCANNER;
        continue;
      end;
    end
    else if IsCurrText(',') then
    begin
      Call_SCANNER;

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

      if not IsCurrText(':') then
        continue;
    end
    else if IsCurrText(':') then
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
    end
    else
      Break;

    Match(':');
    SkipColons;

    if CurrToken.ID = SP_EOF then
      Break;

    if IsCurrText('end') then
      Break;
  until false;

  Match('end');
  Call_SCANNER;
  Match('enum');

  LevelStack.Pop;
  SetLabelHere(L);

  Call_SCANNER;
end;

procedure TPAXBasicParser.Parse_IfStmt;
label
  Again;
var
  L, LF, ExprID: Integer;
begin
  // match "if"

  L := NewLabel;

Again:

  IsExecutable := true;

  Call_SCANNER;
  LF := NewLabel;
  ExprID := Parse_Expression;
  GenDestroyArrayArgumentList;
  Gen(OP_GO_FALSE_EX, LF, ExprID, 0);

  Match('then');

  Call_SCANNER;
  repeat
    Parse_Statement;
  until IsCurrText('else') or IsCurrText('elseif') or IsCurrText('end');

  Gen(OP_GO, L, 0, 0);

  while IsCurrText('elseif') do
  begin
    SetLabelHere(LF);

    MoveUpSourceLine;

    goto Again;
  end;

  if IsCurrText('else') then
  begin
    SetLabelHere(LF);

    MoveUpSourceLine;

    Call_SCANNER;
    repeat
      Parse_Statement;
    until IsCurrText('end');
  end
  else
    SetLabelHere(LF);

  SetLabelHere(L);

  Call_SCANNER;
  Match('if');

  Call_SCANNER;
end;

procedure TPAXBasicParser.Parse_ThrowStmt;
var
  ID: Integer;
begin
  // match "throw"

  Call_SCANNER;

  if IsCurrText(':') then
  begin
    ID := 0;
    SkipColons;
    Call_SCANNER;
  end
  else
    ID := Parse_Expression;

  Gen(OP_THROW, ID, 0, 0);
end;

procedure TPAXBasicParser.Parse_TryStmt;
var
  L, LTRY, ID: Integer;
begin
  // match "try"

  LTRY := NewLabel;
  Gen(OP_TRY_ON, LTRY, 0, 0);

  Call_SCANNER;
  repeat
    Parse_Statement;
  until IsCurrText('catch') or IsCurrText('finally');

  L := NewLabel;
  Gen(OP_GO, L, 0, 0);

  while IsCurrText('catch') do
  begin
    DeclareSwitch := true;
    Call_SCANNER;
    ID := Parse_Ident;
    Gen(OP_CATCH, ID, 0, 0);
    DeclareSwitch := false;

    CurrClassRec.AddField(ID, [modSTATIC]);

    repeat
      Parse_Statement;
    until IsCurrText('end') or IsCurrText('finally');

    Gen(OP_DISCARD_ERROR, 0, 0, 0);
  end;

  SetLabelHere(L);

  if IsCurrText('finally') then
  begin
    Gen(OP_FINALLY, 0, 0, 0);
    Call_SCANNER;
    repeat
      Parse_Statement;
    until IsCurrText('end');
    Gen(OP_EXIT_ON_ERROR, 0, 0, 0);
  end;

  SetLabelHere(LTRY);
  Gen(OP_TRY_OFF, 0, 0, 0);

  Match('end');
  Call_SCANNER;
  Match('try');
  Call_SCANNER;
end;

procedure TPAXBasicParser.Parse_ExitStmt;
var
  EntryStack: TPAXEntryStack;
begin
  // match "exit"
  Call_SCANNER;

  EntryStack := nil;
  if IsCurrText('do') then
    EntryStack := EntryStackDO
  else if IsCurrText('for') then
    EntryStack := EntryStackFOR
  else if IsCurrText('sub') then
  begin
    if CurrSubID = 0 then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);
    Gen(OP_EXIT, 0, 0, 0);
    Call_SCANNER;
    Exit;
  end
  else if IsCurrText('function') then
  begin
    if CurrSubID = 0 then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);
    Gen(OP_EXIT, 0, 0, 0);
    Call_SCANNER;
    Exit;
  end
  else if IsCurrText('property') then
  begin
    if CurrSubID = 0 then
      raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);
    Gen(OP_EXIT, 0, 0, 0);
    Call_SCANNER;
    Exit;
  end
  else
    Match('do');

  if EntryStack.Count = 0 then
    raise TPAXScriptFailure.Create(errStatementIsNotAllowedHere);

  Gen(OP_EXIT, EntryStack.TopBreakLabel, 0, 0);
  Call_SCANNER;
end;

procedure TPAXBasicParser.Parse_WhileStmt;
var
  L, LF: Integer;
begin
  // match "while"
  L := NewLabel;
  LF := NewLabel;
  SetLabelHere(L);

  Call_SCANNER;
  Gen(OP_GO_FALSE_EX, LF, Parse_Expression, 0);

  repeat
    Parse_Statement;
  until IsCurrText('end');

  Gen(OP_GO, L, 0, 0);
  SetLabelHere(LF);

  Call_SCANNER;
  Match('while');
  Call_SCANNER;
end;

function TPAXBasicParser.Parse_ForStmt: Boolean;
var
  StepDirID, Expr1ID, Expr2ID, StepID, RelExprID, L, LF, L1, L2, LC, ID: Integer;
  R: TPAXForLoopRec;
begin
  // match "for"

  result := true;

  L := NewLabel;
  LF := NewLabel;
  LC := NewLabel;

  RelExprID := NewVar;

  Call_SCANNER;
  Expr1ID := Parse_Ident;
  Match('=');
  Call_SCANNER;
  Gen(OP_ASSIGN, Expr1ID, Parse_Expression, Expr1ID);

  Match('to');
  Call_SCANNER;
  Expr2ID := Parse_Expression;

  if IsCurrText('step') then
  begin
    L1 := NewLabel;
    L2 := NewLabel;

    Call_SCANNER;
    SetLabelHere(L);

    StepID := Parse_Expression;

    StepDirID := NewVar;
    Gen(OP_GT, StepID, NewConst(0), StepDirID);

    Gen(OP_GO_FALSE_EX, L1, StepDirID, 0);

    Gen(OP_LE, Expr1ID, Expr2ID, RelExprID);

    Gen(OP_GO, L2, 0, 0);
    SetLabelHere(L1);

    Gen(OP_GE, Expr1ID, Expr2ID, RelExprID);

    SetLabelHere(L2);
  end
  else
  begin
    StepID := NewConst(1);
    SetLabelHere(L);
    Gen(OP_LE, Expr1ID, Expr2ID, RelExprID);
  end;

  Gen(OP_GO_FALSE_EX, LF, RelExprID, 0);

  EntryStackFOR.Push(LF, LC, StatementLabel);
  ForLoopStack.Push(Expr1ID, StepID, L, LC, LF);
  repeat
    Parse_Statement;
  until IsCurrText('next') or (ForLoopStack.Count = 0);
  IsExecutable := true;

  EntryStackFOR.Pop;

  if ForLoopStack.Count = 0 then
  begin
    result := false;
    Exit;
  end;

  Call_SCANNER;

  if IsCurrText(':') then
  begin
    SetLabelHere(LC);
    Gen(OP_PLUS, Expr1ID, StepID, Expr1ID);
    Gen(OP_GO, L, 0, 0);
    ForLoopStack.Pop;
    SetLabelHere(LF);
  end
  else
  begin
    ID := Parse_Ident;
    R := ForLoopStack.Top;
    if R.ID <> ID then
      raise TPAXScriptFailure.Create(Format(errIncorrectIdentifier,
         [Name[ID]]));
    SetLabelHere(R.LC);
    Gen(OP_PLUS, R.ID, R.StepID, R.ID);
    Gen(OP_GO, R.L, 0, 0);
    SetLabelHere(R.LF);

    ForLoopStack.Pop;
    while IsCurrText(',') do
    begin
      Call_SCANNER;
      ID := Parse_Ident;
      R := ForLoopStack.Top;
      if R.ID <> ID then
        raise TPAXScriptFailure.Create(Format(errIncorrectIdentifier,
           [Name[ID]]));
      SetLabelHere(R.LC);
      Gen(OP_PLUS, R.ID, R.StepID, R.ID);
      Gen(OP_GO, R.L, 0, 0);
      SetLabelHere(R.LF);
      ForLoopStack.Pop;
    end;
  end;
end;

procedure TPAXBasicParser.Parse_DoStmt;
var
  L, LF, ExprID, ID: Integer;
  SignWHILE: boolean;
begin
// match "do"

  L := NewLabel;
  LF := NewLabel;

  Call_SCANNER;
  if IsCurrText('while') or IsCurrText('until') then
  begin
    if IsCurrText('while') then
      SignWHILE := true
    else
      SignWHILE := false;

    SetLabelHere(L);

    Call_SCANNER;
    ExprID := Parse_Expression;

    if not SignWHILE then
    begin
      ID := NewVar;
      Gen(OP_NOT, ExprID, 0, ID);
    end
    else
      ID := ExprID;

    Gen(OP_GO_FALSE_EX, LF, ID, 0);

    EntryStackDO.Push(LF, L, StatementLabel);
    repeat
      Parse_Statement;
    until IsCurrText('loop');
    EntryStackDO.Pop;

    Gen(OP_GO, L, 0, 0);

    SetLabelHere(LF);

    Call_SCANNER;
    Exit;
  end;

  Match(':');

  SetLabelHere(LF);

  EntryStackDO.Push(L, LF, StatementLabel);
  repeat
    Parse_Statement;
  until IsCurrText('loop');

  Call_SCANNER;

  SignWHILE := false;
  if IsCurrText('while') then
    SignWHILE := true
  else
    Match('until');

  Call_SCANNER;
  ExprID := Parse_Expression;

  if SignWHILE then
  begin
    ID := NewVar;
    Gen(OP_NOT, ExprID, 0, ID);
  end
  else
    ID := ExprID;

  Gen(OP_GO_FALSE_EX, LF, ID, 0);

  SetLabelHere(L);
end;

procedure TPAXBasicParser.Parse_SelectCaseStmt;
var
  L, LF, ExprID, RelExprID: Integer;
begin
  // match "select"

  L := NewLabel;

  Call_SCANNER;
  Match('case');

  Call_SCANNER;
  ExprID := Parse_Expression;

  SkipColons;

  while IsCurrText('case') do
  begin
    LF := NewLabel;
    SetLabelHere(LF);

    Call_SCANNER;
    if IsCurrText('else') then
      Call_SCANNER
    else
    begin
      RelExprID := NewVar;
      Gen(OP_EQ, ExprID, Parse_Expression, RelExprID);
      Gen(OP_GO_FALSE_EX, LF, RelExprID, 0);
    end;

    repeat
      Parse_Statement;
    until IsCurrText('case') or IsCurrText('end');

    Gen(OP_GO, L, 0, 0);

    SetLabelHere(LF);
    if IsCurrText('end') then
      Break;
  end;

  Call_SCANNER;
  Match('select');
  Call_SCANNER;

  SetLabelHere(L);
end;

procedure TPAXBasicParser.Parse_WithStmt;
var
  I, K, ID, ID2: Integer;
begin
  // match "with"

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

  Match(':');

  Call_SCANNER;

  repeat
    Parse_Statement;
  until IsCurrText('end');
  Call_SCANNER;
  Match('with');
  Call_SCANNER;

  for I:=1 to K do
  begin
    Gen(OP_END_WITH, 0, 0, 0);
    WithStack.Pop;
  end;
end;

procedure TPAXBasicParser.Parse_SimpleStatement;
var
  LeftID, RightID, Arg1, Arg2, Res, OP, L1, L2, Vars: Integer;
  IsReducedAssignment: Boolean;
begin
  if IsCurrText('print') then
    Parse_PrintList
  else if IsCurrText('println') then
    Parse_PrintlnList
  else if IsCurrText('goto') then
  begin
    Call_SCANNER;
//    Parse_LabelID;
  end
  else if IsCurrText('delete') then
  begin
    Call_SCANNER;
    LeftID := Parse_MemberExpression(0);
    Gen(OP_RELEASE, LeftID, 0, 0);
  end
  else
  begin

    IsReducedAssignment := IsCurrText('reduced');
    if IsReducedAssignment then
      Call_SCANNER;

    L1 := LastCodeLine + 1;
    Gen(OP_NOP, 0, 0, 0);

    LeftID := Parse_MemberExpression(0);

    if IsCurrText('=') then
    begin
      Call_SCANNER;

      if IsReducedAssignment then
        Parse_ReducedAssignment(LeftID)
      else if IsCallOperator(Arg1, Arg2, Res) then
      begin
        if IsCurrText('AddressOf') and (Arg2 > 0) then
        begin
          Code.Prog[LastCodeLine].Op := OP_GET_ITEM;
          Parse_Expression;
          Code.Prog[LastCodeLine].Res := Res;
        end
        else
        begin
          RemoveLastOperator;
          RightID := Parse_Expression;
{
          if Arg2 = 0 then
          begin
            if Arg1 = CurrSubID then
              Arg1 := SymbolTable.GetResultID(CurrSubID);
            Gen(OP_ASSIGN, Arg1, RightID, Arg1);
          end
          else
}
          begin
            Gen(OP_PUSH, RightID, 0, 0);
            Gen(OP_PUT_PROPERTY, Arg1, Arg2 + 1, 0);
          end;
        end;
      end
      else
      begin
        if LeftID = CurrSubID then
          LeftID := SymbolTable.GetResultID(CurrSubID);
        Gen(OP_ASSIGN, LeftID, Parse_Expression, LeftID);
      end;
    end
    else if (CurrToken.ID = SP_PLUS_ASSIGN) or
            (CurrToken.ID = SP_MINUS_ASSIGN) or
            (CurrToken.ID = SP_MULT_ASSIGN) or
            (CurrToken.ID = SP_DIV_ASSIGN) or
            (CurrToken.ID = SP_INT_DIV_ASSIGN) or
            (CurrToken.ID = SP_POWER_ASSIGN) or
            (CurrToken.ID = SP_CONCAT_ASSIGN) then
    begin
      OP := 0;
      case CurrToken.ID of
        SP_PLUS_ASSIGN: OP := OP_PLUS;
        SP_MINUS_ASSIGN: OP := OP_MINUS;
        SP_MULT_ASSIGN: OP := OP_MULT;
        SP_DIV_ASSIGN: OP := OP_DIV;
        SP_INT_DIV_ASSIGN: OP := OP_INT_DIV;
        SP_POWER_ASSIGN: OP := OP_POWER;
        SP_CONCAT_ASSIGN: OP := OP_PLUS;
      end;

      Call_SCANNER;
      if IsCallOperator(Arg1, Arg2, Res) then
      begin
        L2 := LastCodeLine - 1;
        Res := NewVar;
        Gen(OP, LeftID, Parse_Expression, Res);
        InsertCode(L1, L2);
        Gen(OP_PUSH, Res, 0, 0);
        Gen(OP_PUT_PROPERTY, Arg1, Arg2 + 1, 0);
      end
      else
        Gen(OP, LeftID, Parse_Expression, LeftID);
    end
    else if IsCurrText(':') then
    begin
//    if SymbolTable.Kind[LeftID] = kindTYPE then
      if Code.Prog[Code.Card].Op <> OP_CALL then
        Gen(OP_CALL, LeftID, 0, 0);
    end
    else
    begin
      if IsCallOperator(Arg1, Arg2, Res) then
        RemoveLastOperator;
      Gen(OP_CALL, LeftID, Parse_ArgumentList(LeftID, Vars), 0);
      SetVars(Vars);
    end;
  end;
end;

procedure TPAXBasicParser.Parse_StmtList;
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

procedure TPAXBasicParser.Parse_SourceElements;
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

procedure TPAXBasicParser.Parse_Program;
var
  lastop: Integer;
var
  K, LTRY, I, Id, Level: Integer;
  L: TPaxIds;
  C: TPaxClassRec;
begin
  if CurrToken.ID = SP_EOF then
    Exit;

  lastop := Code.Prog[Code.Card].Op;
  if not (lastop = OP_DEFINE) then
  begin
    if DeclareVariables then
      Gen(OP_DECLARE_ON, 0, 0, 0)
    else
      Gen(OP_DECLARE_OFF, 0, 0, 0);
  end;

  if VBArrays then
    Gen(OP_VBARRAYS_ON, 0, 0, 0)
  else
    Gen(OP_VBARRAYS_OFF, 0, 0, 0);

  Gen(OP_UPCASE_ON, 0, 0, 0);

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
