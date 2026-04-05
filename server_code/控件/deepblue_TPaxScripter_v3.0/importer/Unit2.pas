unit Unit2;
interface

uses
  SysUtils,
  Classes;
type
  TSimpleScanner = class
    Buff: String;
    P: Integer;
    constructor Create;
    function GetToken: String;
  end;

 TSimpleParser = class
   Scanner: TSimpleScanner;
   CurrToken: String;
   IsFunction: Boolean;
   Fail: Boolean;

   Name: String;
   NP: Integer;

   typINTEGER,
   typLONGINT,
   typCARDINAL,
   typWORD,
   typBYTE,
   typSMALLINT,
   typSHORTINT,
   typDWORD,
   typUINT,
   typPOINTER,
   typSTRING,
   typBOOLEAN,
   typDOUBLE,
   typEXTENDED,
   typSINGLE,
   typVARIANT: Integer;

   TypeRes: Integer;
   Types: array[1..100] of Integer;

   AdmissibleTypes: TStringList;

   ParamList: TStringList;

   constructor Create;
   procedure Call_SCANNER;
   procedure Match(const S: String);
   function IsCurrText(const S: String): boolean;
   function Parse_Ident: String;
   function Parse_Type: String;
   procedure Parse_IdentList;
   procedure Parse_FormalParameter;
   procedure Parse_FormalParameters;
   procedure Parse_Header(const Header: String);
   destructor Destroy; override;
 end;

implementation

constructor TSimpleScanner.Create;
begin
  Buff := '';
  P := 0;
end;

function TSimpleScanner.GetToken: String;
var
  ch: Char;
begin
  repeat
    Inc(P);
    ch := Buff[P];
    if ch in ['_', 'a'..'z', 'A'..'Z'] then
    begin
      result := UpCase(ch);
      while Buff[P + 1] in ['_', 'a'..'z', 'A'..'Z', '0'..'9'] do
      begin
        Inc(P);
        result := result + UpCase(Buff[P]);
      end;
      Exit;
    end
    else if ch in ['=', ':', '(', ')', ',', ';', #255] then
    begin
      result := ch;
      Exit;
    end;
  until false;
end;

constructor TSimpleParser.Create;
begin
  Scanner := TSimpleScanner.Create;
  AdmissibleTypes := TStringList.Create;
  Fail := false;
  NP := 0;
  ParamList := TStringList.Create;

  with AdmissibleTypes do
  begin
    typINTEGER := Add('INTEGER');
    typLONGINT := Add('LONGINT');
    typCARDINAL := Add('CARDINAL');
    typWORD := Add('WORD');
    typBYTE := Add('BYTE');
    typSMALLINT := Add('SMALLINT');
    typSHORTINT := Add('SHORTINT');
    typDWORD := Add('DWORD');
    typUINT := Add('UINT');

    typPOINTER := Add('POINTER');

    typSTRING := Add('STRING');
    typBOOLEAN := Add('BOOLEAN');
    typDOUBLE := Add('DOUBLE');
    typEXTENDED := Add('EXTENDED');
    typSINGLE := Add('SINGLE');
    typVARIANT := Add('VARIANT');
  end;
end;

destructor TSimpleParser.Destroy;
begin
  Scanner.Free;
  AdmissibleTypes.Free;
  ParamList.Free;
  inherited;
end;

procedure TSimpleParser.Match(const S: String);
begin
  if not IsCurrText(S) then
    Fail := true;
end;

procedure TSimpleParser.Call_SCANNER;
begin
  CurrToken := Scanner.GetToken;
end;

function TSimpleParser.IsCurrText(const S: String): boolean;
begin
  result := CompareText(CurrToken, S) = 0;
end;

function TSimpleParser.Parse_Ident: String;
begin
  result := CurrToken;
  Call_SCANNER;
end;

function TSimpleParser.Parse_Type: String;
begin
  result := Parse_Ident;
  if UpperCase(result) = 'ARRAY' then
  begin
    Call_SCANNER;
    result := result + ' OF ';
    result := result + ' ' + Parse_Ident;
  end;
end;

procedure TSimpleParser.Parse_IdentList;
begin
  ParamList.Add(CurrToken);
  Parse_Ident;
  Inc(NP);
  while IsCurrText(',') do
  begin
    Call_SCANNER;
    ParamList.Add(CurrToken);
    Parse_Ident;
    Inc(NP);
  end;
end;

procedure TSimpleParser.Parse_FormalParameter;
var
  ByRef: Boolean;
  T: Integer;
  I, PrevNP: Integer;
begin
  PrevNP := NP;

  if IsCurrText('var') then
  begin
    ByRef := true;
    Call_SCANNER;
  end
  else if IsCurrText('const') then
  begin
    Call_SCANNER;
  end
  else if IsCurrText('out') then
  begin
    ByRef := true;
    Call_SCANNER;
  end;

  if ByRef then
    Fail := true;

  Parse_IdentList;

  if IsCurrText(':') then
  begin
    Call_SCANNER;
    T := AdmissibleTypes.IndexOf(UpperCase(Parse_Type));
    if not Fail then
      Fail := T = -1;

    for I:= PrevNP + 1 to NP do
      Types[I] := T;
  end
  else
    Fail := true;
end;

procedure TSimpleParser.Parse_FormalParameters;
begin
  Parse_FormalParameter;
  while IsCurrText(';') do
  begin
    Call_SCANNER;
    Parse_FormalParameter;
  end;
end;

procedure TSimpleParser.Parse_Header(const Header: String);
begin
  Scanner.Buff := Header + #255;
  Call_SCANNER;

  IsFunction := IsCurrText('function');
  Fail := IsCurrText('constructor') or IsCurrText('destructor');

  Call_SCANNER;
  Name := Parse_Ident;

  if IsCurrText('(') then
  begin
    Call_SCANNER;
    if not IsCurrText(')') then
      Parse_FormalParameters;
    Match(')');
    Call_SCANNER;
  end;

  TypeRes := -1;
  if IsFunction then
  begin
    Match(':');
    Call_SCANNER;
    TypeRes := AdmissibleTypes.IndexOf(UpperCase(Parse_Type));
    if not Fail then
      Fail := TypeRes = -1;
  end;
end;

end.
