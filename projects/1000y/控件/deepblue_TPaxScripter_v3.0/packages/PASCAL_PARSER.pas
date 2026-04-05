////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: PASCAL_PARSER.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////


{$I PaxScript.def}
unit PASCAL_PARSER;

interface

uses
  SysUtils, Classes,
  BASE_CONSTS,
  BASE_SYS,
  BASE_SCANNER,
  BASE_EXTERN;

type
  TPascalScanner = class(TPAXScanner)
  public
    procedure ReadToken; override;
  end;

  TPascalParser = class
  public
    Scanner: TPascalScanner;
    CurrToken: TPAXToken;
    D: TPAXMethodDefinition;
    ResultType: String;
    NP: Integer;
    IsDynamicArrayType: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Call_SCANNER;
    function IsCurrText(const S: String): boolean;
    function Parse_Ident: String;
    procedure Match(const S: String);
    function Parse_Type(var TypeID, ExtraTypeID, Size: Integer): ShortString;
    procedure Parse_IdentList;
    procedure Parse_FormalParameter;
    procedure Parse_FormalParameters;
    procedure Parse_Heading;
    function Parse_Property(var ReadName, WriteName: String;
                            var Def: Boolean; DefList: TPAXDefinitionList): String;
    procedure ParseUsesClause(Output: TStrings);
  end;

implementation

procedure TPascalScanner.ReadToken;

procedure ScanChrs;
var
  S: String;
  I: Integer;
begin
  S := '';
  repeat
    GetNextChar;
    ScanDigits;
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

begin
  repeat
    GetNextChar;

    Token.TokenClass := tcNone;
    Token.ID := 0;

    case c of
      #8, #9, #10, #13, #32: ScanWhiteSpace;
      #255: ScanEOF;
      '0'..'9': ScanDigits;
      '$': ScanHexDigits;
      'A'..'Z', 'a'..'z', '_':
        ScanIdentifier;
      '+': ScanPlus;
      '-': ScanMinus;
      '=': ScanEQ;
      ':': ScanColon;
      ';': ScanSemiColon;
      '(': ScanLeftRoundBracket;
      ')': ScanRightRoundBracket;
      '[': ScanLeftBracket;
      ']': ScanRightBracket;
      ',': ScanComma;
      '''': ScanString('''');
      '#': ScanChrs;
      '{':
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
    else
      raise TPAXScriptFailure.Create(errIllegalCharacter);
    end;

    if Token.TokenClass <> tcNone then
      Exit;

  until false;
end;

constructor TPascalParser.Create;
begin
  inherited;

  Scanner := TPascalScanner.Create(Self);

  ResultType := '';
  NP := 0;
  IsDynamicArrayType := false;
end;

destructor TPascalParser.Destroy;
begin
  Scanner.Free;
  inherited;
end;

procedure TPascalParser.Call_SCANNER;
begin
  Scanner.ReadToken;
  CurrToken := Scanner.Token;

  if CurrToken.TokenClass = tcSeparator then
    if CurrToken.ID <> SP_EOF then
    begin
      Call_SCANNER;
      Exit;
    end;
end;

function TPascalParser.IsCurrText(const S: String): boolean;
begin
  result := StrEql(CurrToken.Text, S)
end;

procedure TPascalParser.Match(const S: String);
begin
  if not IsCurrText(S) then
    raise TPAXScriptFailure.Create(Format(err_X_expected_but_Y_fond, [S, CurrToken.Text]));
end;

function TPascalParser.Parse_Ident: String;
begin
  if CurrToken.TokenClass <> tcId then
    raise TPAXScriptFailure.Create(errIdentifierExpected);

  result := CurrToken.Text;
  Call_SCANNER;
end;

function TPascalParser.Parse_Type(var TypeID, ExtraTypeID, Size: Integer): ShortString;
var
  I: Integer;
  RTTIDef: TPAXRTTITypeDefinition;
  ClassDef: TPAXClassDefinition;
  S: String;
label
  Again;
begin
  ExtraTypeID := 0;
  IsDynamicArrayType := false;
  Size := -1;

  S := Parse_Ident;
  result := S;

  S := FindTypeAlias(result, true);
  if S <> '' then
    result := S;

  if StrEql(result, 'array') then
  begin
Again:
    ExtraTypeID := typeDYNAMICARRAY;
    Match('of');
    Call_SCANNER;

    result := Parse_Ident;

    if StrEql(result, 'array') then goto Again;

    if StrEql(result, 'const') then
      result := 'TVarRec';
  end
  else if StrEql(result, 'paxarray') then
  begin
    typeID := typeARRAY;
    ExtraTypeID := typeARRAY;
    Exit;
  end;

  for I:=0 to PAXTypes.Count - 1 do
    if StrEql(result, PAXTypes[I]) then
    begin
      typeID := I;
      Exit;
    end;

  typeID := typeCLASS;

  RTTIDef := D.DefList.FindRTTITypeDefByName(result);
  if RTTIDef <> nil then
  begin
    typeID := RTTIDef.FinalType;
    Exit;
  end;

  ClassDef := D.DefList.FindClassDefByName(result);

  if ClassDef <> nil then
  begin
    if ClassDef.classKind = ckEnum then
      typeID := typeINTEGER
    else if ClassDef.classKind = ckDynamicArray then
    begin
      IsDynamicArrayType := true;
      ExtraTypeId := typeDYNAMICARRAY;
      TypeID := ClassDef.ElType;
    end
    else if ClassDef.classKind = ckInterface then
      typeID := typeINTERFACE;
    Size := ClassDef.RecordSize;

    Exit;
  end;

  S := UpperCase(result);
  if UnresolvedTypes.IndexOf(S) = -1 then
    UnresolvedTypes.Add(S);

  if StrEql(result, 'IInterface') then
    typeID := typeINTERFACE;

  if Pos('CLASS', UpperCase(result)) > 0 then
    typeID := typeCLASSREF;
end;

procedure TPascalParser.Parse_IdentList;
var
  S: String;
begin
  Inc(D.NP);
  S := Parse_Ident;
  D.ParamNames[D.NP - 1] := S;
  while IsCurrText(',') do
  begin
    Inc(D.NP);
    Call_SCANNER;
    S := Parse_Ident;
    D.ParamNames[D.NP - 1] := S;
  end;
end;

procedure TPascalParser.Parse_FormalParameter;
var
  I, PrevNP, TypeID, ExtraTypeID, Size: Integer;
  ByRef, IsSelf, IsOut, IsConst: Boolean;
  StrType, S: String;
begin
  ByRef := false;
  IsOut := false;
  IsConst := false;
  if IsCurrText('var') then
  begin
    ByRef := true;
    Call_SCANNER;
  end
  else if IsCurrText('const') then
  begin
    IsConst := true;
    Call_SCANNER;
  end
  else if IsCurrText('out') then
  begin
    ByRef := true;
    IsOut := true;
    Call_SCANNER;
  end;

  PrevNP := D.NP;

  IsSelf := CurrToken.Text = 'Self';

  Parse_IdentList;

  if (D.NP = 1) and (PrevNP = 0) and D.NewFake and IsSelf then
    Dec(D.NP);

  TypeID := TypeVOID;
  if IsCurrText(':') then
  begin
    Call_SCANNER;
    StrType := Parse_Type(TypeID, ExtraTypeID, Size);
  end
  else
    if IsOut then
      TypeID := TypeINTERFACE;

  for I:= PrevNP + 1 to D.NP do
  begin
    D.Types[I - 1] := TypeID;
    D.ExtraTypes[I - 1] := ExtraTypeID;
    D.StrTypes[I - 1] := StrType;
    D.ByRefs[I - 1] := ByRef;
    D.Consts[I - 1] := IsConst;
    D.Sizes[I - 1] := Size;

  end;

  if IsCurrText('=') then
  begin
    Call_SCANNER;
    if CurrToken.Text = '-' then
    begin
      Call_SCANNER;
      D.DefParamList.Add(- CurrToken.Value);
    end
    else if StrEql('Low', CurrToken.Text) then
    begin
      Call_SCANNER; // low
      Call_SCANNER; // (
      if StrEql(CurrToken.Text, 'integer') then
        D.DefParamList.Add(Low(Integer))
      else if StrEql(CurrToken.Text, 'byte') then
        D.DefParamList.Add(Low(byte))
      else if StrEql(CurrToken.Text, 'smallint') then
        D.DefParamList.Add(Low(smallint))
      else if StrEql(CurrToken.Text, 'shortint') then
        D.DefParamList.Add(Low(shortint))
      else if StrEql(CurrToken.Text, 'char') then
        D.DefParamList.Add(Low(char))
      else if StrEql(CurrToken.Text, 'word') then
        D.DefParamList.Add(Low(word))
      else if StrEql(CurrToken.Text, 'cardinal') then
        D.DefParamList.Add(Low(cardinal));
      Call_SCANNER; // val
    end
    else if StrEql('High', CurrToken.Text) then
    begin
      Call_SCANNER; // high
      Call_SCANNER; // (
      if StrEql(CurrToken.Text, 'integer') then
        D.DefParamList.Add(high(Integer))
      else if StrEql(CurrToken.Text, 'byte') then
        D.DefParamList.Add(high(byte))
      else if StrEql(CurrToken.Text, 'smallint') then
        D.DefParamList.Add(high(smallint))
      else if StrEql(CurrToken.Text, 'shortint') then
        D.DefParamList.Add(high(shortint))
      else if StrEql(CurrToken.Text, 'char') then
        D.DefParamList.Add(high(char))
      else if StrEql(CurrToken.Text, 'word') then
        D.DefParamList.Add(high(word))
      else if StrEql(CurrToken.Text, 'cardinal') then
        D.DefParamList.Add(high(cardinal));
      Call_SCANNER; // val
    end
    else
    begin
      if CurrToken.Text = '[' then
      begin
        S := '[';
        Call_SCANNER;
        if CurrToken.Text <> ']' then
        begin
          repeat
            S := S + CurrToken.Text;
            Call_SCANNER; // ',' or ']'
            if CurrToken.Text = ']' then
              break
            else
            begin
              S := S + CurrToken.Text;
              Call_SCANNER;
            end;
          until false;
        end;
        S := S + ']';
        D.DefParamList.Add(S);
      end
      else
        D.DefParamList.Add(CurrToken.Value);
    end;
    Call_SCANNER;
  end;
end;

procedure TPascalParser.Parse_FormalParameters;
begin
  NP := 1;
  Parse_FormalParameter;
  while IsCurrText(';') do
  begin
    Inc(NP);
    Call_SCANNER;
    Parse_FormalParameter;
  end;
end;

procedure TPascalParser.Parse_Heading;
var
  I, ResType, ExtraTypeID, Size: Integer;
  StrType: String;
  b: boolean;
begin
  D.NP := 0;
  ResType := 0;
  SetLength(D.Types, 100);
  SetLength(D.ExtraTypes, 100);
  SetLength(D.StrTypes, 100);
  SetLength(D.ParamNames, 100);
  SetLength(D.ByRefs, 100);
  SetLength(D.Consts, 100);
  SetLength(D.Sizes, 100);
  for I:=0 to Length(D.Sizes) - 1 do D.Sizes[I] := -1;

  Scanner.SourceCode := D.Header;
  Call_SCANNER;

  if IsCurrText('class') then
  begin
    D.ml := D.ml + [modSTATIC];
    Call_SCANNER;
  end;

  if IsCurrText('function') then
  begin
    D.TypeSub := tsFunction;
  end
  else if IsCurrText('procedure') then
  begin
    D.TypeSub := tsProcedure;
  end
  else if IsCurrText('constructor') then
  begin
    D.TypeSub := tsConstructor;
  end
  else if IsCurrText('destructor') then
  begin
    D.TypeSub := tsDestructor;
  end
  else
    Match('function');

  Call_SCANNER;
  D.Name := Parse_Ident;

  if IsCurrText('(') then
  begin
    Call_SCANNER;
    if not IsCurrText(')') then
      Parse_FormalParameters;
    Match(')');
    Call_SCANNER;
  end;

  b := false;
  for I:=0 to D.NP - 1 do
    if D.ExtraTypes[I] = typeDYNAMICARRAY then
    begin
      b := true;
      break;
    end;

  if b then
  begin
    I := ArrayParamMethods.IndexOf(D.Name);
    if I = -1 then
      ArrayParamMethods.Add(D.Name);
  end;

  case D.TypeSub of
    tsFunction:
    begin
      Match(':');
      Call_SCANNER;
      ResultType := CurrToken.Text;
      D.ResultType := CurrToken.Text;
      StrType := Parse_Type(ResType, ExtraTypeID, Size);

      D.Types[D.NP] := ResType;
      D.ByRefs[D.NP] := true;
      D.Consts[D.NP] := false;
      D.Sizes[D.NP] := Size;
      D.StrTypes[D.NP] := StrType;
      D.ExtraTypes[D.NP] := ExtraTypeID;

      if IsDynamicArrayType then
      begin
        IsDynamicArrayType := false;
        D.ReturnsDynamicArray := true;
      end;
    end;
    tsConstructor:
    begin
      D.Types[D.NP] := typeCLASS;
      D.ByRefs[D.NP] := true;
      D.Consts[D.NP] := false;
    end;
  end;

  SetLength(D.Types, D.NP + 1);
  SetLength(D.ExtraTypes, D.NP + 1);
  SetLength(D.StrTypes, D.NP + 1);
  SetLength(D.ParamNames, D.NP + 1);
  SetLength(D.ByRefs, D.NP + 1);
  SetLength(D.Consts, D.NP + 1);
  SetLength(D.Sizes, D.NP + 1);

  while IsCurrText(';') do
  begin
   Call_SCANNER;
   if IsCurrText('cdecl') then begin
     D.CallConv := _ccCDecl;
     Call_SCANNER;
   end
   else if IsCurrText('pascal') then begin
     D.CallConv := _ccPascal;
     Call_SCANNER;
   end
   else if IsCurrText('stdcall') then begin
     D.CallConv := _ccStdCall;
     Call_SCANNER;
   end
   else if IsCurrText('safecall') then begin
     D.CallConv := _ccSafeCall;
     Call_SCANNER;
   end
   else if IsCurrText('virtual') then begin
     D.ml := D.ml + [modVIRTUAL];
     Call_SCANNER;
   end
   else if IsCurrText('override') then begin
     D.ml := D.ml + [modVIRTUAL];
     Call_SCANNER;
   end
   else if IsCurrText('dynamic') then begin
     D.ml := D.ml + [modVIRTUAL];
     Call_SCANNER;
   end
   else if IsCurrText('overload') or IsCurrText('register') then begin
     Call_SCANNER;
   end;
 end;

end;

function TPascalParser.Parse_Property(var ReadName, WriteName: String;
                                      var Def: Boolean; DefList: TPAXDefinitionList): String;
begin
  ReadName := '';
  WriteName := '';
  Def := false;

  Match('property');

  Call_SCANNER;
  result := Parse_Ident;

  if IsCurrText('[') then
  begin
    Call_SCANNER;
    D := TPAXMethodDefinition.Create(nil, '', nil, 0, nil, false);
    D.DefList := DefList;
    SetLength(D.Types, 100);
    SetLength(D.ExtraTypes, 100);
    SetLength(D.StrTypes, 100);
    SetLength(D.ParamNames, 100);
    SetLength(D.ByRefs, 100);
    SetLength(D.Consts, 100);
    SetLength(D.Sizes, 100);
    try
      Parse_FormalParameters;
    finally
      D.Free;
    end;
    Match(']');
    Call_SCANNER;
  end;

  Match(':');

  Call_SCANNER;
  ResultType := CurrToken.Text;
  Parse_Ident;

  repeat
    if IsCurrText('index') then
    begin
      Call_SCANNER;
      Parse_Ident;
    end
    else if IsCurrText('read') then
    begin
      Call_SCANNER;
      ReadName := Parse_Ident;
    end
    else if IsCurrText('write') then
    begin
      Call_SCANNER;
      WriteName := Parse_Ident;
    end
    else if IsCurrText('stored') then
    begin
      Call_SCANNER;
      Parse_Ident;
    end
    else if IsCurrText('default') then
    begin
      Call_SCANNER;
      Parse_Ident;
    end
    else if IsCurrText('nodefault') then
    begin
      Call_SCANNER;
    end
    else if IsCurrText('implements') then
    begin
      Call_SCANNER;
      Parse_Ident;
    end
    else
      Match('implements');

     if IsCurrText(';') then
       Break;

     if IsCurrText('EOF') then
       Break;
  until false;
  if IsCurrText(';') then
  begin
    Call_SCANNER;
    Def := IsCurrText('default');
  end;
end;

procedure TPascalParser.ParseUsesClause(Output: TStrings);
var
  S: String;
begin
  Match('uses');
  Call_SCANNER;
  repeat
    S := Parse_Ident;
    Output.Add(S);

    if IsCurrText(',') then
      Call_SCANNER
    else if IsCurrText(';') then
      break
    else
      Match(';');
  until false;
end;

end.
