////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_SCANNER.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit BASE_SCANNER;

interface

uses
  Classes,
  SysUtils,
//  QStrings,
  BASE_CONSTS,
  BASE_SYS;
type
  TScannerState = (scanText, scanProg);
  TPAXScanner = class;

  TDefRec = class
  public
    Word: Integer;
    What: String;
    Vis: boolean;
  end;

  TDefStack = class
  private
    fItems: TList;
    function GetItem(I: Integer): TDefRec;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Count: Integer;
    procedure Push(Word: Integer; What: String; Vis: Boolean);
    procedure Pop;
    property Items[I: Integer]: TDefRec read GetItem; default;
  end;

  TScannerRec = class
  public
    LineNumber, PosNumber: Integer;
    c: Char;
    P: Integer;
    Buff: String;
  end;

  TScannerStack = class
  private
    fItems: TList;
    function GetItem(I: Integer): TScannerRec;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Count: Integer;
    procedure Push(Scanner: TPaxScanner);
    procedure Pop(Scanner: TPaxScanner);
    property Items[I: Integer]: TScannerRec read GetItem; default;
  end;

  TPAXScanner = class
  private
    Scripter: Pointer;
    fScannerState: TScannerState;
    Parser: Pointer;
    procedure SetSourceCode(const Value: String);
    function GetSourceCode: String;
    procedure SetScannerState(Value: TScannerState);
  public
    LineNumber, PosNumber: Integer;
    Token, BuffToken: TPAXToken;
    c: Char;
    P: Integer;
    Buff: String;
    VarNameList: TStringList;
    DefStack: TDefStack;
    ScannerStack: TScannerStack;
    LookForward: Boolean;

    constructor Create(Parser: Pointer);
    destructor Destroy; override;

    procedure SetScripter(AScripter: Pointer);
    procedure Reset;
    function EndOfTagExpected: Boolean;
    function GetText(P1, P2: Integer): String;
    function GetNextChar: Char;
    function LA(N: Integer ): Char;
    procedure ReadToken; virtual;
    function NextToken: TPAXToken;
    function Next2Token: TPAXToken;

    procedure ScanIdentifier;
    procedure ScanIdentifierEx(ExtraChars: TCharSet);
    procedure ScanChars(CSet: TCharSet);
    procedure ScanString(ch: Char);
    procedure ScanHtmlString(const Ch: String);
    procedure ScanFormatString;
    procedure ScanDigits;
    procedure ScanHexDigits;
    procedure ScanWhiteSpace;
    procedure ScanEOF;
    procedure ScanPlus;
    procedure ScanMinus;
    procedure ScanMult;
    procedure ScanDiv;
    procedure ScanMod;
    procedure ScanGT;
    procedure ScanLT;
    procedure ScanEQ;
    procedure ScanLeftRoundBracket;
    procedure ScanRightRoundBracket;
    procedure ScanLeftBracket;
    procedure ScanRightBracket;
    procedure ScanLeftBrace;
    procedure ScanRightBrace;
    procedure ScanColon;
    procedure ScanSemiColon;
    procedure ScanComma;
    procedure ScanPoint;
    procedure ScanBackslash;
    function GetRegExpr: String;
    procedure ScanCondDir(Start1: Char;
                          Start2: TCharSet);
    function IsEOF: Boolean;
    procedure IncLineNumber;

    property SourceCode: String read GetSourceCode write SetSourceCode;
    property ScannerState: TScannerState read fScannerState write SetScannerState;
  end;

implementation

uses
  BASE_SCRIPTER, BASE_PARSER;

const
  _IFDEF = 1;
  _IFNDEF = 2;
  _ELSE = 3;
  _ENDIF = 4;

constructor TDefStack.Create;
begin
  fItems := TList.Create;
end;

destructor TDefStack.Destroy;
begin
  Clear;
  fItems.Free;
  inherited;
end;

procedure TDefStack.Clear;
begin
  while Count > 0 do
    Pop;
end;

function TDefStack.Count: Integer;
begin
  result := fItems.Count;
end;

function TDefStack.GetItem(I: Integer): TDefRec;
begin
  result := TDefRec(fItems[I - 1]);
end;

procedure TDefStack.Push(Word: Integer; What: String; Vis: Boolean);
var
  R: TDefRec;
begin
  R := TDefRec.Create;
  R.Word := Word;
  R.What := What;
  R.Vis := Vis;
  fItems.Add(R);
end;

procedure TDefStack.Pop;
var
  R: TDefRec;
begin
  R := fItems[Count - 1];
  fItems.Delete(Count - 1);
  R.Free;
end;

constructor TScannerStack.Create;
begin
  fItems := TList.Create;
end;

destructor TScannerStack.Destroy;
begin
  Clear;
  fItems.Free;
  inherited;
end;

procedure TScannerStack.Clear;
begin
  while Count > 0 do
    Pop(nil);
end;

function TScannerStack.GetItem(I: Integer): TScannerRec;
begin
  result := TScannerRec(fItems[I - 1]);
end;

function TScannerStack.Count: Integer;
begin
  result := fItems.Count;
end;

procedure TScannerStack.Push(Scanner: TPaxScanner);
var
  R: TScannerRec;
begin
  R := TScannerRec.Create;

  R.LineNumber := Scanner.LineNumber;
  R.PosNumber := Scanner.PosNumber;
  R.c := Scanner.c;
  R.P := Scanner.P;
  R.Buff := Scanner.Buff;

  fItems.Add(R);
end;

procedure TScannerStack.Pop(Scanner: TPaxScanner);
var
  R: TScannerRec;
begin
  R := fItems[Count - 1];
  fItems.Delete(Count - 1);

  if Scanner <> nil then
  begin
    Scanner.LineNumber := R.LineNumber;
    Scanner.PosNumber := R.PosNumber;
    Scanner.c := R.c;
    Scanner.P := R.P;
    Scanner.Buff := R.Buff;
  end;

  R.Free;
end;

constructor TPAXScanner.Create(Parser: Pointer);
begin
  VarNameList := TStringList.Create;
  DefStack := TDefStack.Create;
  ScannerStack := TScannerStack.Create;
  Self.Parser := Parser;

  scripter := nil;

  Reset;
end;

destructor TPAXScanner.Destroy;
begin
  VarNameList.Free;
  DefStack.Free;
  ScannerStack.Free;

  inherited;
end;

procedure TPAXScanner.SetScripter(AScripter: Pointer);
begin
  Scripter := AScripter;
end;

function TPAXScanner.GetText(P1, P2: Integer): String;
var
  S: ShortString;
  L: Integer;
begin
  L := P2 - P1 + 1;
  Move(Buff[P1], S[1], L);
  S[0] := Chr(L);
  result := S;
end;

procedure TPAXScanner.ReadToken;
begin
  if scripter <> nil then
  with TPAXBaseScripter(Scripter) do
  begin
    if CancelMessage <> '' then
      raise TPaxScriptFailure.Create(CancelMessage);

    Code.N := Code.Card;
    if Assigned(OnCompilerProgress) then
      OnCompilerProgress(Owner, CurrModule);
    Code.N := 0;
  end;

  Token.Position := P + 1;
end;

procedure TPAXScanner.Reset;
begin
  P := 0;
  LineNumber := 0;
  PosNumber := -1;
  Buff := '';
  BuffToken.Text := '';
  fScannerState := scanText;
  VarNameList.Clear;
  DefStack.Clear;
  ScannerStack.Clear;
  LookForward := false;
end;

procedure TPAXScanner.SetSourceCode(const Value: String);
begin
  Reset;
  Buff := Value + #255#255#255;
end;

function TPAXScanner.GetSourceCode: String;
begin
  result := Buff;
end;

function TPAXScanner.GetNextChar: Char;
begin
  Inc(P);
  result := Buff[P];
  Inc(PosNumber);

  c := result;
end;

function TPAXScanner.LA(N: Integer ): Char;
begin
  if BuffToken.Text <> '' then
  begin
    result := BuffToken.Text[P + N];
    Exit;
  end;

  result := Buff[P + N];
end;

function TPAXScanner.EndOfTagExpected: Boolean;
var
  I: Integer;
  ch: Char;
begin
  result := false;
  I := 1;
  repeat
     Ch := LA(I);
     case Ch of
        '?','%':
        begin
          result := true;
          Exit;
        end;
        #8, #9, #10, #13, #32: begin end;
        else
          Exit;
     end;
     Inc(I);
  until false;
end;

function TPAXScanner.NextToken: TPAXToken;
var
  SaveP, SaveLineNumber, SavePosNumber, SaveTotal: Integer;
  SaveToken: TPAXToken;
  SaveC: Char;
  SaveState: TScannerState;
begin
  LookForward := true;

  if ScannerStack.Count > 0 then
  begin
    Token.Text := '';
    Token.TokenClass := tcSeparator;
    Exit;
  end;

  SaveTotal := TPAXBaseScripter(Scripter).fTotalLineCount;
  SaveP := P;
  SaveLineNumber := LineNumber;
  SavePosNumber := PosNumber;
  SaveToken := Token;
  SaveC := c;
  SaveState := fScannerState;

  ReadToken;
  while Token.TokenClass = tcSeparator do
  begin
    if Token.ID = SP_EOF then
      Break;
    ReadToken;
  end;

  result := Token;

  P := SaveP;
  LineNumber := SaveLineNumber;
  PosNumber := SavePosNumber;
  Token := SaveToken;
  c := SaveC;
  TPAXBaseScripter(Scripter).fTotalLineCount := SaveTotal;
  fScannerState := SaveState;

  VarNameList.Clear;

  LookForward := false;
end;

function TPAXScanner.Next2Token: TPAXToken;
label Fin;
var
  SaveP, SaveLineNumber, SavePosNumber, SaveTotal: Integer;
  SaveToken: TPAXToken;
  SaveC: Char;
  SaveState: TScannerState;
begin
  LookForward := true;

  if ScannerStack.Count > 0 then
  begin
    Token.Text := '';
    Token.TokenClass := tcSeparator;
    Exit;
  end;

  SaveTotal := TPAXBaseScripter(Scripter).fTotalLineCount;
  SaveP := P;
  SaveLineNumber := LineNumber;
  SavePosNumber := PosNumber;
  SaveToken := Token;
  SaveC := c;
  SaveState := fScannerState;

  ReadToken;
  while Token.TokenClass = tcSeparator do
  begin
    if Token.ID = SP_EOF then
      goto Fin;
    ReadToken;
  end;

  ReadToken;
  while Token.TokenClass = tcSeparator do
  begin
    if Token.ID = SP_EOF then
      goto Fin;
    ReadToken;
  end;

Fin:

  result := Token;

  P := SaveP;
  LineNumber := SaveLineNumber;
  PosNumber := SavePosNumber;
  Token := SaveToken;
  c := SaveC;
  TPAXBaseScripter(Scripter).fTotalLineCount := SaveTotal;
  fScannerState := SaveState;

  VarNameList.Clear;

  LookForward := false;
end;

{
procedure TPAXScanner.ScanIdentifier;
var
  S: String;
begin
  Token.Position := P;

  S := c;
  while LA(1) in ['A'..'Z', 'a'..'z', '0'..'9', '_'] do
    S := S + GetNextChar;
  Token.TokenClass := tcId;
  Token.Text := S;

  SetScannerState(scanProg);
end;
}


procedure TPAXScanner.ScanIdentifier;
begin
  Token.Position := P;

  repeat
    case LA(1) of
      'A'..'Z', 'a'..'z', '0'..'9', '_':
      begin
        Inc(P);
        Inc(PosNumber);
      end;
      else
        break;
    end;
  until false;

  Token.TokenClass := tcId;

  Token.Text := Copy(Buff, Token.Position, P - Token.Position + 1);

  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanIdentifierEx(ExtraChars: TCharSet);
begin
  Token.Position := P;

  repeat
    case LA(1) of
      'A'..'Z', 'a'..'z', '0'..'9', '_':
      begin
        Inc(P);
        Inc(PosNumber);
      end;
      else
      begin
        if LA(1) in ExtraChars then
        begin
          Inc(P);
          Inc(PosNumber);
        end
        else
          break;
      end;
    end;
  until false;

  Token.TokenClass := tcId;

  Token.Text := Copy(Buff, Token.Position, P - Token.Position + 1);

  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanChars(CSet: TCharSet);
var
  S: String;
begin
  Token.Position := P;

  S := c;
  while LA(1) in CSet do
    S := S + GetNextChar;
  Token.TokenClass := tcId;
  Token.Text := S;

  SetScannerState(scanProg);
end;

function GetVal(const StrVal: String): Variant;
var
  I, J, K: Integer;
  ch: Char;
  S: String;
begin
  I := Length(StrVal);
  ch := StrVal[I];
  case ch of
    'B', 'b':
    begin
      J := 0;
      K := 1;
      Dec(I);
      repeat
        ch := StrVal[I];

        if not (ch in ['0'..'1']) then
          raise TPaxScriptFailure.Create(errSyntaxError);

        if ch = '1' then
          Inc(J, K);

        K := K * 2;
        Dec(I);
      until I = 0;
      result := J;
    end;
    'D', 'd':
    begin
      result :=  SysUtils.StrToInt(Copy(StrVal, 1, I - 1));
    end;
    'H', 'h':
    begin
      S := '$' + Copy(StrVal, 1, I - 1);
      result := StrToInt(S);
    end;
    else
    begin
      S := Copy(StrVal, 1, 2);
      if (S = '0x') or (S = '0X') then
      begin
        S := '$' + Copy(StrVal, 3, Length(StrVal) - 2);
        result := StrToInt(S);
      end
      else if (S = '0b') or (S = '0B') then
      begin
        S := Copy(StrVal, 3, Length(StrVal) - 2);
        I := Length(S);
        J := 0;
        K := 1;
        repeat
          ch := S[I];

          if not (ch in ['0'..'1']) then
           raise TPaxScriptFailure.Create(errSyntaxError);

          if ch = '1' then
            Inc(J, K);
          K := K * 2;
          Dec(I);
        until I = 0;
        result := J;
      end
      else
        result := SysUtils.StrToFloat(StrVal);
    end;
  end;
end;

procedure TPAXScanner.ScanDigits;
var
  S: String;
  I64: Int64;
{$IFNDEF VARIANTS}
  D: Double;
{$ENDIF}
begin
  S := c;

  if c = '0' then
  begin
    case LA(1) of
      'x','X':
      begin
        GetNextChar;
        c := '$';
        ScanHexDigits;
        Exit;
      end;
      'b','B':
      begin
        GetNextChar;
        S := '';
        while LA(1) in ['0'..'1'] do
          S := S + GetNextChar;
        Token.TokenClass := tcIntegerConst;
        Token.Text := '0b' + S;
        Token.Value := StringToBinary(S);
        Exit;
      end;
      else
      begin
        while LA(1) in ['0'..'9', 'A'..'F'] do
          S := S + GetNextChar;
        Token.TokenClass := tcIntegerConst;
        if LA(1) in ['b','B','d','D','h','H'] then
        begin
          S := S + GetNextChar;
          Token.Value := GetVal(S);
          Exit;
        end;
      end;
    end;
  end;

  while LA(1) in ['0'..'9'] do
    S := S + GetNextChar;
  Token.TokenClass := tcIntegerConst;

  if ((LA(1) = '.') and (LA(2) <> '.')) or (LA(1) in ['e', 'E']) then
  begin
    S := S + GetNextChar;
    if LA(1) = '-' then
      S := S + GetNextChar;
    while LA(1) in ['0'..'9', 'e', 'E'] do
    begin
      S := S + GetNextChar;
      Token.TokenClass := tcFloatConst;
    end;
  end;

  if S[Length(S)] = '.' then
  begin
    Delete(S, Length(S), 1);
    Dec(P);
  end;

  Token.Text := S;

  if Token.TokenClass = tcIntegerConst then
  begin
    I64 := StrToInt64(S);

    if Abs(I64) > MaxInt then
    begin
{$IFDEF VARIANTS}
      Token.Value := i64;  //
{$ELSE}
      D := I64;
      Token.Value := D;
{$ENDIF}
    end
    else
      Token.Value := integer(I64);
  end
  else
  begin
    Token.Value := StrToFloat(StringReplace(S, '.', DecimalSeparator, []));
  end;

  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanHexDigits;
var
  S: String;
  I64: Int64;
  D: Double;
begin
  S := c;
  while LA(1) in ['0'..'9', 'A'..'F', 'a'..'f'] do
    S := S + GetNextChar;

  Token.TokenClass := tcIntegerConst;
  Token.Text := S;

  I64 := StrToInt64(S);
  if I64 > MaxInt then
  begin
    D := I64;
    Token.Value := D;
  end
  else
    Token.Value := StrToInt(S);
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanWhiteSpace;
begin
  if c in [#10,#13] then
  begin
    IncLineNumber;
    PosNumber := -1;

    if c = #13 then
      GetNextChar;
    Token.ID := LineNumber;
    Token.TokenClass := tcSeparator;
  end;
end;

procedure TPAXScanner.ScanEOF;
begin
  if ScannerStack.Count > 0 then
  begin
    ScannerStack.Pop(Self);
    Exit;
  end;

  Token.Text := 'EOF';
  Token.TokenClass := tcSeparator;
  Token.ID := SP_EOF;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanPlus;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := OP_PLUS;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanMinus;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := OP_MINUS;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanMult;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := OP_MULT;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanDiv;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := OP_DIV;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanGT;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := OP_GT;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanLT;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := OP_LT;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanEQ;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := OP_EQ;

  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanMod;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := OP_MOD;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanLeftRoundBracket;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := SP_ROUND_BRACKET_L;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanRightRoundBracket;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := SP_ROUND_BRACKET_R;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanLeftBracket;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := SP_BRACKET_L;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanRightBracket;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := SP_BRACKET_R;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanLeftBrace;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := SP_BRACE_L;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanRightBrace;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := SP_BRACE_R;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanColon;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := SP_COLON;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanSemiColon;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := SP_SEMICOLON;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanComma;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := SP_COMMA;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanBackslash;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := SP_BACKSLASH;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanPoint;
begin
  Token.Text := c;
  Token.TokenClass := tcSpecial;
  Token.ID := SP_POINT;
  SetScannerState(scanProg);
end;

function TPAXScanner.GetRegExpr: String;
begin
  result := '';
  while not ((LA(1) = '/') and (LA(0) <> '\')) do
  begin
    GetNextChar;
    if c = #255 then Exit;
    result := result + c;
  end;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.SetScannerState(Value: TScannerState);
begin
  fScannerState := Value;
end;

procedure TPAXScanner.ScanFormatString;
var
  P1, P2: Integer;
  StrFormat, VarName: String;
begin
//  "%" [index ":"] ["-"] [width] ["." prec] type
  GetNextChar;
  P1 := P;
  if LA(1) in ['0'..'9'] then // Index
  begin
    while (LA(1) in ['0'..'9']) do
      GetNextChar;
    if LA(1) <> ':' then
      raise TPAXScriptFailure.Create(':' + errExpected);
    GetNextChar;
  end;
  if LA(1) = '-' then
    GetNextChar;
  if LA(1) in ['0'..'9'] then // width
    while (LA(1) in ['0'..'9']) do
      GetNextChar;
  if LA(1) = '.' then
    GetNextChar;
  if LA(1) in ['0'..'9'] then // prec
    while (LA(1) in ['0'..'9']) do
      GetNextChar;
  GetNextChar; // type

  P2 := P;

  StrFormat := Copy(Buff, P1, P2 - P1 + 1);
  Token.Text := Token.Text + StrFormat;

  if LA(1) <> '=' then
    raise TPAXScriptFailure.Create('=' + errExpected);
  GetNextChar;

  if not (LA(1) in ['a'..'z','A'..'Z','_']) then
    raise TPAXScriptFailure.Create(errIdentifierExpected);
  VarName := GetNextChar;
  while (LA(1) in ['a'..'z','A'..'Z','_','0'..'9']) do
    VarName := VarName + GetNextChar;

  VarNameList.Add(VarName);
end;

procedure TPAXScanner.ScanHtmlString(const Ch: String);
var
  K1, K2: Integer;
  Backslash: Boolean;
begin
  Backslash := TPAXParser(Parser).Backslash;
  K1 := 0;
  K2 := 0;
  with Token do
  begin
    TokenClass := tcHtmlStringConst;
    Text := Ch;
    repeat
      c := GetNextChar;

      case c of
        #0,#13,#10:
        begin
          Text := Text + c;
          if c = #13 then
          begin
            c := GetNextChar;
            Text := Text + c;
          end;

          IncLineNumber;
          PosNumber := -1;

          with TPAXBaseScripter(Scripter).Code do
            Add(OP_SEPARATOR, ModuleID, LineNumber, 0);
        end;
        '\':
        if (K1 mod 2 = 0) and (K2 mod 2 = 0) then
        begin

          if not Backslash then
          Text := Text + c
          else

          case LA(1) of
          '%': ScanFormatString;
          'b':
          begin
            GetNextChar;
            Text := Text + #$08;
          end;
          't':
          begin
            GetNextChar;
            Text := Text + #$09;
          end;
          'n':
          begin
            GetNextChar;
            Text := Text + #$0A;
          end;
          'v':
          begin
            GetNextChar;
            Text := Text + #$0B;
          end;
          'f':
          begin
            GetNextChar;
            Text := Text + #$0C;
          end;
          'r':
          begin
            GetNextChar;
            Text := Text + #$0D;
          end;
          '\':
          begin
            GetNextChar;
            Text := Text + #$5C;
          end;

          else
           Text := Text + c;
          end;
        end
        else
          Text := Text + c;
        '''':
        begin
          Inc(K1);
          Text := Text + c;
        end;
        '"':
        begin
          Inc(K2);
          Text := Text + c;
        end;
        '<':
        if LA(1) = '?' then
        begin
          Dec(P);
          Break;
        end
        else if LA(1) = '%' then
        begin
          Dec(P);
          Break;
        end
        else
          Text := Text + c;
        #255:
          Break;
        else
          Text := Text + c;
      end;
    until false;
  end;
end;

procedure TPAXScanner.ScanString(ch: Char);
var
  LongStr: Boolean;
  Backslash: Boolean;
  S: String;
  I64: Int64;
begin
  with Token do
  begin
    TokenClass := tcStringConst;

    if scripter <> nil then
    begin
      LongStr := (LA(1) = ch) and (LA(2) = ch) and
         TPaxBaseScripter(Scripter).fLongStrLiterals;
      Backslash := TPAXParser(Parser).Backslash;
    end
    else
    begin
      LongStr := false;
      Backslash := false;
    end;

    Text := '';
    repeat
      if P >= Length(Buff) then
          raise TPAXScriptFailure.Create(errInvalidString);

      GetNextChar;

      if (c = '\') and (ch in ['"', '''']) and Backslash then
        case LA(1) of
          '%': ScanFormatString;
          'b':
          begin
            GetNextChar;
            Text := Text + #$08;
          end;
          't':
          begin
            GetNextChar;
            Text := Text + #$09;
          end;
          'n':
          begin
            GetNextChar;
            Text := Text + #$0A;
          end;
          'v':
          begin
            GetNextChar;
            Text := Text + #$0B;
          end;
          'f':
          begin
            GetNextChar;
            Text := Text + #$0C;
          end;
          '''':
          begin
            GetNextChar;
            Text := Text + '''';
          end;
          '"':
          begin
            GetNextChar;
            Text := Text + '"';
          end;
          'r':
          begin
            GetNextChar;
            Text := Text + #$0D;
          end;
          'x': // hex const
          begin
            GetNextChar;
            GetNextChar;
            S := c;
            while LA(1) in ['0'..'9', 'A'..'F', 'a'..'f'] do
              S := S + GetNextChar;

            I64 := StrToInt64('$' + S);
            if I64 > 255 then
              raise TPAXScriptFailure.Create(errInvalidEscapeSequence);

            Text := Text + Chr(I64);
          end;
          '\':
          begin
            GetNextChar;
            Text := Text + #$5C;
          end;
          else
          begin
//            Text := Text + c;
          end;
        end
      else if c = ch then
      begin
        if LongStr then
        begin
          if (LA(1) = ch) and (LA(2) = ch) then
          begin
            GetNextChar;
            GetNextChar;
            c := #0;
            Break;
          end;
        end
        else
        begin
          if LA(1) = ch then
          begin
            Text := Text + GetNextChar;
            c := #0;
          end
          else
            Break;
        end;
      end
      else if c in [#0,#13,#10] then
      begin
        if LongStr then
        begin
          Text := Text + c;
          if c = #13 then
          begin
            c := GetNextChar;
            Text := Text + c;
          end;

          IncLineNumber;
          PosNumber := -1;

          if scripter <> nil then
          with TPAXBaseScripter(Scripter).Code do
            Add(OP_SEPARATOR, ModuleID, LineNumber, 0);
        end
        else
          raise TPAXScriptFailure.Create(errInvalidString);
      end
      else
        Text := Text + c;
    until false;
  end;
  Token.Value := Token.Text;
  SetScannerState(scanProg);
end;

procedure TPAXScanner.ScanCondDir(Start1: Char;
                                  Start2: TCharSet);
label
  NextComment, Fin;
const
  IdsSet = ['a'..'z','A'..'Z','0'..'9','_'];
var
  S: String;
  I, J, J1, J2: Integer;
  Visible: Boolean;
  FileName: String;
  L: TStringList;
begin
  Visible := true;

NextComment:

  S := '';
  repeat
    GetNextChar;
    S := S + c;
    if c in [#10,#13] then
    begin
      IncLineNumber;
      PosNumber := -1;

      if c = #13 then
        GetNextChar;
    end;
  until not (c in (IdsSet + Start2));

  I := Pos('INCLUDE', UpperCase(S));
  if I = 0 then
    I := Pos('I ', UpperCase(S));

  if I > 0 then
  begin
    while not (c in IdsSet) do GetNextChar;
    ScanIdentifierEx(['\', ':']);

    FileName := Token.Text;

    if Pos('\', FileName) > 1 then
      if Pos(':', FileName) = 0 then
        FileName := '\' + FileName;

    if LA(1) = '.' then
    begin
      GetNextChar;
      ScanIdentifier;
      FileName := FileName + Token.Text;
    end;

    if Assigned(TPaxBaseScripter(Scripter).OnInclude) then
    begin
      S := '';
      TPaxBaseScripter(Scripter).OnInclude(TPaxBaseScripter(Scripter).Owner, FileName, S);
    end
    else
    begin
      if Pos('.', FileName) = 0 then
        if TPaxParser(Parser).IncludeFileExt <> '' then
          FileName := FileName + TPaxParser(Parser).IncludeFileExt;

      S := TPaxBaseScripter(Scripter).FindFullName(FileName);
    end;

    if S = '' then
    begin
      raise TPaxScriptFailure.Create(Format(errFileNotFound, [FileName]));
    end
    else if not Assigned(TPaxBaseScripter(Scripter).OnInclude) then
    begin
      FileName := S;

      L := TStringList.Create;
      L.LoadFromFile(FileName);
      S := L.Text;
      L.Free;
    end;

    if LA(1) = '}' then
      GetNextChar;
    if LA(1) = '"' then
      GetNextChar;
    if LA(1) = '''' then
      GetNextChar;

    ScannerStack.Push(Self);

    P := 0;
    Buff := S + #255#255#255;
    LineNumber := 1;
    PosNumber := 0;
    fScannerState := scanProg;

    Exit;
  end;

  I := Pos('DEFINE', UpperCase(S));
  if I > 0 then
  begin
    while not (c in IdsSet) do GetNextChar;
    ScanChars(['A'..'Z', 'a'..'z', '0'..'9', '_', '.', '-', '[', ']', '(', ')', ',']);
    Token.Text := UpperCase(Token.Text);

    TPaxBaseScripter(Scripter).DefList.Add(Token.Text);

    if StrEql(Token.Text, 'DECLARE_ON') then
      TPaxBaseScripter(Scripter).Code.Add(OP_DECLARE_ON, 0, 0, 0)
    else if StrEql(Token.Text, 'DECLARE_OFF') then
      TPaxBaseScripter(Scripter).Code.Add(OP_DECLARE_OFF, 0, 0, 0)
    else if StrEql(Token.Text, 'UPCASE_ON') then
      TPaxBaseScripter(Scripter).Code.Add(OP_UPCASE_ON, 0, 0, 0)
    else if StrEql(Token.Text, 'UPCASE_OFF') then
      TPaxBaseScripter(Scripter).Code.Add(OP_UPCASE_OFF, 0, 0, 0)
    else if StrEql(Token.Text, 'OPTIMIZATION_ON') then
      TPaxBaseScripter(Scripter).Code.Add(OP_OPTIMIZATION_ON, 0, 0, 0)
    else if StrEql(Token.Text, 'OPTIMIZATION_OFF') then
      TPaxBaseScripter(Scripter).Code.Add(OP_OPTIMIZATION_OFF, 0, 0, 0);

    with TPaxBaseScripter(Scripter) do
    begin
      if Assigned(OnDefine) then
        OnDefine(Owner, Token.Text);
      Code.Add(OP_DEFINE, SymbolTable.AppVariantConst(Token.Text), 0, 0);
    end;

    if LA(1) = '}' then
      GetNextChar;

    Exit;
  end;

  I := Pos('UNDEF', UpperCase(S));
  if I > 0 then
  begin
    while not (c in IdsSet) do GetNextChar;
    ScanIdentifier;
    Token.Text := UpperCase(Token.Text);

    I := TPaxBaseScripter(Scripter).DefList.IndexOf(Token.Text);
    if I <> -1 then
      TPaxBaseScripter(Scripter).DefList.Delete(I);

    if LA(1) = '}' then
      GetNextChar;

    Exit;
  end;

  I := Pos('IFDEF', UpperCase(S));
  if I > 0 then
  begin
    while not (c in IdsSet) do GetNextChar;
    ScanIdentifier;
    Token.Text := UpperCase(Token.Text);

    Visible := TPaxBaseScripter(Scripter).DefList.IndexOf(Token.Text) <> -1;
    DefStack.Push(_IFDEF, Token.Text, Visible);

    if Visible then
      for I := DefStack.Count - 1 downto 1 do
        if DefStack[I].Word in [_IFDEF, _IFNDEF] then
        begin
          Visible := DefStack[I].Vis;
          Break;
        end;

    if LA(1) = '}' then
      GetNextChar;

    goto Fin;
  end;

  I := Pos('IFNDEF', UpperCase(S));
  if I > 0 then
  begin
    while not (c in IdsSet) do GetNextChar;
    ScanIdentifier;
    Token.Text := UpperCase(Token.Text);

    Visible := TPaxBaseScripter(Scripter).DefList.IndexOf(Token.Text) = -1;
    DefStack.Push(_IFNDEF, Token.Text, Visible);

    if Visible then
      for I := DefStack.Count - 1 downto 1 do
        if DefStack[I].Word in [_IFDEF, _IFNDEF] then
        begin
          Visible := DefStack[I].Vis;
          Break;
        end;

    if LA(1) = '}' then
      GetNextChar;

    goto Fin;
  end;

  I := Pos('ELSE', UpperCase(S));
  if I > 0 then
  begin
    if LA(1) = '}' then
      GetNextChar;

    DefStack.Push(_ELSE, '', Visible);

    I := DefStack.Count - 1;
    if I <= 0 then
      raise TPaxScriptFailure.Create(errInvalidCompilerDirective);

    if DefStack[I].Word in [_IFDEF, _IFNDEF] then
    begin
      DefStack[DefStack.Count].What := DefStack[I].What;
      DefStack[DefStack.Count].Vis := not DefStack[I].Vis;

      Visible := DefStack[DefStack.Count].Vis;
      if Visible then
        for J:=I - 1 downto 1 do
          if DefStack[J].Word in [_IFDEF, _IFNDEF] then
          begin
            Visible := DefStack[J].Vis;
            Break;
          end;
    end
    else
      raise TPaxScriptFailure.Create(errInvalidCompilerDirective);

    goto Fin;
  end;

  I := Pos('ENDIF', UpperCase(S));
  if I > 0 then
  begin
    if LA(1) = '}' then
      GetNextChar;

    J1 := 0;
    J2 := 0;
    for I := DefStack.Count downto 1 do
      if DefStack[I].Word in [_IFDEF, _IFNDEF] then
        Inc(J1)
      else if DefStack[I].Word = _ENDIF then
        Inc(J2);
    if J2 >= J1 then
      raise TPaxScriptFailure.Create(errInvalidCompilerDirective);

    for I:=DefStack.Count downto 1 do
      if DefStack[I].Word in [_IFDEF, _IFNDEF] then
      begin
        while DefStack.Count > I - 1 do
          DefStack.Pop;
        Break;
      end;
    if DefStack.Count = 0 then
      Visible := true
    else
      Visible := DefStack[DefStack.Count].Vis;

    goto Fin;
  end;

  raise TPaxScriptFailure.Create(errInvalidCompilerDirective);

Fin:

  if not Visible then
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
    until ((c = Start1) and (LA(1) in Start2)) or IsEOF;

    if IsEOF then
      raise TPaxScriptFailure.Create(errMissingENDIFdirective);

    goto NextComment;
  end;
end;

function TPAXScanner.IsEOF: Boolean;
begin
  result := c = #255;
end;

procedure TPAXScanner.IncLineNumber;
begin
  if ScannerStack.Count = 0 then
  begin
    Inc(LineNumber);
    Inc(TPAXBaseScripter(Scripter).fTotalLineCount);
  end;
end;

end.


