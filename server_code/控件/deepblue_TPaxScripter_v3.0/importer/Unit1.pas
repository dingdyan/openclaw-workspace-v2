unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uWDelphiParser, StdCtrls, Buttons, ExtCtrls, ComCtrls, Unit2;

const
  DeltaMargin = 2;

type
  TClassRec = class
    E: TClassEntry;
    ConstructorDef: String;
    constructor Create(E: TClassEntry);
  end;

  TBody = (bNone, bClass, bInterface);

  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SpeedButton3: TSpeedButton;
    Memo1: TRichEdit;
    Memo2: TRichEdit;
    Panel2: TPanel;
    Label1: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure WDelphiParser1UsedUnit(aFileName: String);
    procedure WDelphiParser1EndOfUsesClause(var aStopAnalyze: Boolean);
    procedure WDelphiParser1ConstEntry(aEntry: TEntry; aAddEntry: Boolean);
    procedure WDelphiParser1VarEntry(aEntry: TEntry; aAddEntry: Boolean);
    procedure WDelphiParser1AfterUnitEntry(aFileName: String);
    procedure WDelphiParser1TypeEntry(aEntry: TEntry; aAddEntry : boolean);
    procedure WDelphiParser1ClassEntry(aEntry: TEntry;  aAddEntry, IsForward: Boolean);
    procedure WDelphiParser1InterfaceEntry(aEntry: TEntry;
                                           aAddEntry, IsForward: Boolean);
    procedure WDelphiParser1DispInterfaceEntry(aEntry: TEntry;
                                           aAddEntry, IsForward: Boolean);
    procedure WDelphiParser1ClassFunctionEntry(aEntry: TEntry;
      aAddEntry: Boolean);
    procedure WDelphiParser1FunctionEntry(aEntry: TEntry;
      aAddEntry: Boolean);
    procedure WDelphiParser1ProcedureEntry(aEntry: TEntry;
      aAddEntry: Boolean);
    procedure WDelphiParser1ClassProcedureEntry(aEntry: TEntry;
      aAddEntry: Boolean);
    procedure SpeedButton3Click(Sender: TObject);
    procedure WDelphiParser1EndOfClassDef(var aStopAnalyze: Boolean);
    procedure WDelphiParser1EndOfInterfaceDef(var aStopAnalyze: Boolean);
    procedure WDelphiParser1ClassPropertyEntry(aEntry: TEntry;
      aAddEntry: Boolean);
    procedure WDelphiParser1EnumType(const TypeName: String);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
    UnitName: String;
    SourceUnitName: String;
    UsedUnits, VisitedClasses, VisitedRoutines,
    ExtraCode: TStringList;
    StandardTypes: TStringList;
    Margin, ExtraCodePoint: Integer;
    CurrentClass: String;
    UsesClauseHasBeenProcessed: Boolean;
    WDelphiParser1: TWDelphiParser;

    UserData: String;

    OverCount: Integer;
    body: TBody;
  public
    procedure AddLine(const S: String = '');
    procedure Blockquote(Value: Boolean);
    procedure EndOfClass;
    procedure EndOfUsesClause;
    function IsValidProcedureEntry(E: TProcedureEntry): Boolean;
    function IsValidFunctionEntry(E: TFunctionEntry): Boolean;
    function IsValidClassProcedureEntry(E: TClassProcedureEntry): Boolean;
    function IsValidClassFunctionEntry(E: TClassFunctionEntry): Boolean;
    { Public declarations }
  end;


function Space(L: Integer): String;

var
  Form1: TForm1;

const
  AP = '''';
var
  Z: Integer;

implementation

{$R *.DFM}

function StrEql(Const S1, S2: String): Boolean;
begin
  Result := CompareText(S1, S2) = 0;
end;

function IsStringConst(const S: String): Boolean;
var
  I: Integer;
begin
  if Length(S) < 2 then
  begin
    result := false;
    Exit;
  end;

  result := (S[1] = AP) and (S[Length(S)] = AP);
end;

function IsIntegerConst(const S: String): Boolean;
var
  I: Integer;
begin
  if S = '' then
  begin
    result := false;
    Exit;
  end;

  result := true;
  for I:=1 to Length(S) do
    if not (S[I] in ['0'..'9']) then
    begin
      result := false;
      Exit;
    end;
end;

function IsHexConst(const S: String): Boolean;
var
  I: Integer;
begin
  if Length(S) < 2 then
  begin
    result := false;
    Exit;
  end;
  if S[1] <> '$' then
  begin
    result := false;
    Exit;
  end;

  result := true;
  for I:=2 to Length(S) do
    if not (S[I] in ['0'..'9','A'..'F']) then
    begin
      result := false;
      Exit;
    end;
end;

function IsRealConst(const S: String): Boolean;
var
  I: Integer;
begin
  if S = '' then
  begin
    result := false;
    Exit;
  end;

  if Pos('.', S) = 0 then
  begin
    result := false;
    Exit;
  end;

  result := true;
  for I:=1 to Length(S) do
    if not (S[I] in ['0'..'9','.','-','+','e','E']) then
    begin
      result := false;
      Exit;
    end;
end;

constructor TClassRec.Create(E: TClassEntry);
begin
  Self.E := E;
  ConstructorDef := '';
end;

function Space(L: Integer): String;
var
  I: Integer;
begin
  result := '';
  for I:=1 to L do
    result := result + ' ';
end;

function StringConst(const S: String): String;
const
  AP: Char = '''';
  MaxSize = 250;
var
  I: Integer;
begin
  result := AP;
  for I:=1 to Length(S) do
    case S[I] of
      '''': result := result + AP + AP;
      #13: begin end;
      #10: begin end;
    else
      result := result + S[I];
    end;
  result := result + AP;

  if Length(result) > MaxSize then
  begin
     result := Copy(result, 1, MaxSize) + AP + '+' + AP + Copy(result, MaxSize + 1, Length(result));
  end;
end;

function ValidConst(const S: String): Boolean;
begin
  result := Pos('{', S) = 0;
end;

function RemoveSpaces(const S: String): String;
var
  I: Integer;
begin
  result := '';
  for I:=1 to Length(S) do
    if S[I] <> ' ' then
      result := result + S[I];
end;

function TForm1.IsValidProcedureEntry(E: TProcedureEntry): Boolean;
var
  S: String;
begin
  result := true;
  if Pos('=', E.Declaration) > 0 then
  begin
    S := RemoveSpaces(E.Declaration);
    if Pos('=(', S) > 0 then
      result := false
    else if Pos('..', S) > 0 then
      result := false
    else
      result := true;
  end;
  if Pos('_', E.Name) = 1 then
    result := false;
end;

function TForm1.IsValidFunctionEntry(E: TFunctionEntry): Boolean;
begin
  result := IsValidProcedureEntry(E);
end;

function TForm1.IsValidClassProcedureEntry(E: TClassProcedureEntry): Boolean;
var
  S: String;
begin
  result := true;
//  if Pos('=', E.Declaration) > 0 then
//    result := false;

  if Pos('=', E.Declaration) > 0 then
  begin
    S := RemoveSpaces(E.Declaration);
    if Pos('=(', S) > 0 then
      result := false
    else if Pos('..', S) > 0 then
      result := false
    else
      result := true;
  end;

  if Pos('_', E.Name) = 1 then
    result := false;

  if rdAbstract in E.RoutineDirectives then
    result := false;
  if rdMessageHandler in E.RoutineDirectives then
    result := false;
end;

function TForm1.IsValidClassFunctionEntry(E: TClassFunctionEntry): Boolean;
begin
  result := IsValidClassProcedureEntry(E);
end;

procedure TForm1.AddLine(const S: String = '');
begin
  Memo2.Lines.Add(Space(Margin) + S);
end;

procedure TForm1.Blockquote(Value: Boolean);
begin
  if Value then
    Inc(Margin, DeltaMargin)
  else
    Dec(Margin, DeltaMargin);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  S: String;
begin
  UserData := '';
  if ParamCount > 0 then
  begin
    UserData := ParamStr(1);
  end;

  WDelphiParser1 := TWDelphiParser.Create(Self);

  WDelphiParser1.MemberVisibility := [vaPublic];

  WDelphiParser1.OnUsedUnit := WDelphiParser1UsedUnit;
  WDelphiParser1.OnEndOfUsesClause := WDelphiParser1EndOfUsesClause;
  WDelphiParser1.OnConstEntry := WDelphiParser1ConstEntry;
  WDelphiParser1.OnVarEntry := WDelphiParser1VarEntry;
  WDelphiParser1.AfterUnitEntry := WDelphiParser1AfterUnitEntry;
  WDelphiParser1.OnTypeEntry := WDelphiParser1TypeEntry;
  WDelphiParser1.OnClassEntry := WDelphiParser1ClassEntry;
  WDelphiParser1.OnInterfaceEntry := WDelphiParser1InterfaceEntry;
  WDelphiParser1.OnDispInterfaceEntry := WDelphiParser1DispInterfaceEntry;
  WDelphiParser1.OnClassFunctionEntry := WDelphiParser1ClassFunctionEntry;
  WDelphiParser1.OnFunctionEntry := WDelphiParser1FunctionEntry;
  WDelphiParser1.OnProcedureEntry := WDelphiParser1ProcedureEntry;
  WDelphiParser1.OnClassProcedureEntry := WDelphiParser1ClassProcedureEntry;
  WDelphiParser1.OnEndOfClassDef := WDelphiParser1EndOfClassDef;
  WDelphiParser1.OnEndOfInterfaceDef := WDelphiParser1EndOfInterfaceDef;
  WDelphiParser1.OnClassPropertyEntry := WDelphiParser1ClassPropertyEntry;
  WDelphiParser1.OnEnumType := WDelphiParser1EnumType;

  body := bNone;

  UnitName := '';
  SourceUnitName := '';
  UsedUnits := TStringList.Create;
  VisitedClasses := TStringList.Create;
  VisitedRoutines := TStringList.Create;
  ExtraCode := TStringList.Create;
  StandardTypes := TStringList.Create;
  with StandardTypes do
  begin
    Add('LONGINT');
    Add('LONGWORD');
    Add('DWORD');
    Add('UINT');
    Add('ULONG');
    Add('THANDLE');

    Add('INTEGER');
    Add('BYTE');
    Add('SHORTINT');
    Add('SMALLINT');
    Add('WORD');
    Add('CARDINAL');
    Add('INT64');
    Add('SINGLE');
    Add('DOUBLE');
    Add('STRING');
    Add('CHAR');
  end;

  S := ExtractFileDir(Application.ExeName);
  SetCurrentDir(S);

  OpenDialog1.InitialDir := S;
  SaveDialog1.InitialDir := S;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  with OpenDialog1 do
  begin
    Filter := 'Delphi unit (*' + '.pas)' + '|*' + '.pas';
    if Execute then
    begin
      if Pos('.', FileName) = 0 then
        FileName := FileName + '.pas';
      Memo1.Lines.LoadFromFile(FileName);

      WDelphiParser1.FileName := FileName;

      UnitName := ExtractFileName(FileName);
      SourceUnitName := Copy(UnitName, 1, Pos('.', UnitName) - 1);

      UnitName := 'IMP_' + Copy(UnitName, 1, Pos('.', UnitName) - 1);
    end;
  end;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  with SaveDialog1 do
  begin
    if RadioButton1.Checked then
    begin
      Filter := 'Delphi unit (*' + '.pas)' + '|*' + '.pas';
      FileName := UnitName + '.pas';
    end
    else if RadioButton2.Checked then
    begin
      Filter := 'Delphi dll project (*' + '.dpr)' + '|*' + '.dpr';
      FileName := UnitName + '.dpr';
    end;
    if Execute then
    begin
      Memo2.Lines.SaveToFile(FileName);
    end;
  end;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  I: Integer;
  L: TStringList;
  T: TextFile;
  S: String;
begin
  body := bNone;

  Screen.Cursor := crHourGlass;
  ListBox1.Items.Clear;
  Label2.Caption := '0';

  Margin := 0;
  UsedUnits.Clear;
  VisitedClasses.Clear;
  VisitedRoutines.Clear;
  ExtraCode.Clear;
  Memo2.Lines.Clear;
  CurrentClass := '';
  UsesClauseHasBeenProcessed := false;
  OverCount := 0;

  if RadioButton1.Checked then
  begin
    AddLine('unit ' + UnitName + ';');
    AddLine('interface');
  end
  else if RadioButton2.Checked then
  begin
    AddLine('library ' + UnitName + ';');
  end;

  WDelphiParser1.Reset;
  WDelphiParser1.Analyze;

  L := TStringList.Create;
  Memo2.Lines.SaveToFile('t.txt');
  L.LoadFromFile('t.txt');
  AssignFile(T, 't.txt');
  Erase(T);

  S := Copy(UnitName, 5, 100);
  if StrEql(S, 'Graphics') then
  begin
    ExtraCode.Add('type');
    ExtraCode.Add('  TRegClass = class');
    ExtraCode.Add('    procedure  RegColor(const S: string);');
    ExtraCode.Add('  end;');
    ExtraCode.Add('procedure TRegClass.RegColor(const S: string);');
    ExtraCode.Add('var');
    ExtraCode.Add('  C: Integer;');
    ExtraCode.Add('begin');
    ExtraCode.Add('  if IdentToColor(S, C) then');
    ExtraCode.Add('    RegisterConstant(S, C, -1);');
    ExtraCode.Add('end;');
    ExtraCode.Add('procedure RegisterColorValues;');
    ExtraCode.Add('var');
    ExtraCode.Add('  X: TRegClass;');
    ExtraCode.Add('begin');
    ExtraCode.Add('  X := TRegClass.Create;');
    ExtraCode.Add('  GetColorValues(X.RegColor);');
    ExtraCode.Add('  X.Free;');
    ExtraCode.Add('end;');
  end;

  Memo2.Lines.Clear;

  for I:=0 to ExtraCodePoint - 1 do
    Memo2.Lines.Add(L[I]);

  for I:=0 to ExtraCode.Count - 1 do
    Memo2.Lines.Add(ExtraCode[I]);

  for I:=ExtraCodePoint to L.Count - 1 do
    Memo2.Lines.Add(L[I]);

  L.Free;

  Screen.Cursor := crDefault;
  Label2.Caption := IntToStr(ListBox1.Items.Count);
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  UsedUnits.Free;
  for I:=0 to VisitedClasses.Count - 1 do
    VisitedClasses.Objects[I].Free;
  VisitedClasses.Free;
  ExtraCode.Free;
  StandardTypes.Free;
  VisitedRoutines.Free;

  WDelphiParser1.Free;
end;

procedure TForm1.EndOfUsesClause;
var
  B: Boolean;
begin
  if not UsesClauseHasBeenProcessed then
    WDelphiParser1EndOfUsesClause(B);
end;

procedure TForm1.EndOfClass;
var
  C, C1: TClassRec;
  K: Integer;
  Found: Boolean;
begin
  Found := false;
  if CurrentClass <> '' then
  begin
    with VisitedClasses do
      C := TClassRec(Objects[Count - 1]);

    if (C.ConstructorDef = '') and (body <> bInterface) then
    begin
      K := C.E.Parents.Count - 1;
      if StrEql(C.E.Parents[K], 'TObject') or
         StrEql(C.E.Parents[K], 'TPersistent') then
      begin
        Found := true;
        C.ConstructorDef := 'constructor Create;';
      end
      else if StrEql(C.E.Parents[K], 'Exception') then
      begin
        Found := true;
        C.ConstructorDef := 'constructor Create(const Msg: string);';
      end
      else if StrEql(C.E.Parents[K], 'TComponent') or
              StrEql(C.E.Parents[K], 'TForm') then
      begin
        Found := true;
        C.ConstructorDef := 'constructor Create(AOwner: TComponent); virtual;';
      end;

      if not Found then
      begin
        K := VisitedClasses.IndexOf(C.E.Parents[K]);
        if K >= 0 then
        begin
          C1 := TClassRec(VisitedClasses.Objects[K]);
          if C1.ConstructorDef <> '' then
          begin
            Found := true;
            C.ConstructorDef := C1.ConstructorDef;
          end;
        end;
      end;

      if Found then
        Found := ValidConst(C.ConstructorDef);

      if Found then
      begin
        AddLine('RegisterMethod(' + CurrentClass + ',');
        AddLine(Space(5) + StringConst(C.ConstructorDef) + ',');

        if UserData = '' then
          AddLine(Space(5) + '@' + CurrentClass + '.Create);')
        else
          AddLine(Space(5) + '@' + CurrentClass + '.Create, false,' + UserData + ');');
      end
      else
      begin
        AddLine('// CONSTRUCTOR IS NOT FOUND!!!');
        ListBox1.Items.Add(CurrentClass + ': constructor is not found!');
      end;
    end;

    if body = bInterface then
      AddLine('// End of interface ' + CurrentClass)
    else
      AddLine('// End of class ' + CurrentClass);

    CurrentClass := '';
  end;
end;

//--------- Uses Clause -------------------//

procedure TForm1.WDelphiParser1UsedUnit(aFileName: String);
begin
  UsedUnits.Add(aFileName);
end;

procedure TForm1.WDelphiParser1EndOfUsesClause(var aStopAnalyze: Boolean);
var
  I: Integer;
  S: String;
begin
  S := Copy(UnitName, 5, 100);
  if UsedUnits.IndexOf(S) = -1 then
    UsedUnits.Add(S);

  if RadioButton1.Checked then
  begin
    if UsedUnits.IndexOf('VARIANTS') = -1 then
      UsedUnits.Add('Variants');
    if UsedUnits.IndexOf('BASE_SYS') = -1 then
      UsedUnits.Add('BASE_SYS');
    if UsedUnits.IndexOf('BASE_EXTERN') = -1 then
      UsedUnits.Add('BASE_EXTERN');
    if UsedUnits.IndexOf('PaxScripter') = -1 then
      UsedUnits.Add('PaxScripter');

    AddLine('uses');
  end
  else if RadioButton2.Checked then
  begin
    if UsedUnits.IndexOf('PaxImport') = -1 then
      UsedUnits.Add('PaxImport');
    AddLine('uses');
  end;

  Blockquote(true);
  for I:=0 to UsedUnits.Count - 1 do
  begin
    S := UsedUnits[I];
    if I = UsedUnits.Count - 1 then
      S := S + ';'
    else
      S := S + ',';
    AddLine(S);
  end;
  Blockquote(false);

  if RadioButton1.Checked then
  begin
    AddLine('procedure Register' + UnitName + ';');
    AddLine('implementation');

    ExtraCodePoint := Memo2.Lines.Count;

    AddLine('procedure Register' + UnitName + ';');
    AddLine('var H: Integer;');
    AddLine('begin');
    Blockquote(true);
  end
  else if RadioButton2.Checked then
  begin
    ExtraCodePoint := Memo2.Lines.Count;
    AddLine('procedure RegisterDllProcs(PaxRegisterProcs: TPaxRegisterProcs);');
    AddLine('var H: Integer;');
    AddLine('begin');
    AddLine('with PaxRegisterProcs do begin');
    Blockquote(true);
  end;

  S := Copy(UnitName, 5, 100);

  AddLine('H := RegisterNamespace(' + StringConst(S) + ', -1);');

  if StrEql(S, 'Graphics') then
    AddLine('RegisterColorValues;');

  UsesClauseHasBeenProcessed := true;
end;

//--------- Const Section -------------------//

procedure TForm1.WDelphiParser1ConstEntry(aEntry: TEntry;
  aAddEntry: Boolean);
const
  MAX_VALUE:extended=1.7E307;
  MIN_VALUE:extended=4.0E-324;
var
  E: TConstantEntry;
  I64: Int64;
  D: Extended;
  S: String;
  P: Integer;
begin
  EndOfUsesClause;

  E := TConstantEntry(aEntry);

  P := Pos('=', E.Declaration);
  if P > 0 then
  begin
    S := Trim(Copy(E.Declaration, 1, P - 1));
  end
  else
  begin
    S := E.Name;
  end;

  if IsIntegerConst(E.Value) or IsHexConst(E.Value) then
  begin
    I64 := StrToInt64(E.Value);
    if Abs(I64) > MaxInt then
    begin
      if UserData = '' then
        AddLine('RegisterInt64Constant(' + StringConst(S) + ', ' + E.Value + ', H);')
      else
        AddLine('RegisterInt64Constant(' + StringConst(S) + ', ' + E.Value + ', H, ' + UserData + ');');
    end
    else
    begin
      if UserData = '' then
        AddLine('RegisterConstant(' + StringConst(S) + ', ' + E.Value + ', H);')
      else
        AddLine('RegisterConstant(' + StringConst(S) + ', ' + E.Value + ', H, ' + UserData + ');');
    end;
  end
  else if IsRealConst(E.Value) then
  begin
    D := StrToFloatDef(E.Value, 0);
    if (D < MAX_VALUE) and (D > MIN_VALUE) then
    begin
      if UserData = '' then
        AddLine('RegisterConstant(' + StringConst(S) + ', ' + E.Value + ', H);')
      else
        AddLine('RegisterConstant(' + StringConst(S) + ', ' + E.Value + ', H, ' + UserData + ');');
    end;
  end
  else if IsStringConst(E.Value) then
  begin
    if UserData = '' then
      AddLine('RegisterConstant(' + StringConst(S) + ', ' + E.Value + ', H);')
    else
      AddLine('RegisterConstant(' + StringConst(S) + ', ' + E.Value + ', H, ' + UserData + ');');
  end;
end;

//--------- Variable Section -------------------//

procedure TForm1.WDelphiParser1VarEntry(aEntry: TEntry;
  aAddEntry: Boolean);
var
  E: TVariableEntry;
  UpTypeName: String;
begin
  EndOfUsesClause;

  E := TVariableEntry(aEntry);

  UpTypeName := UpperCase(E.TypeName);
  if StandardTypes.IndexOf(UpTypeName) > 0 then
  begin
    if UpTypeName = 'LONGINT' then
      UpTypeName := 'INTEGER'
    else if UpTypeName = 'LONGWORD' then
      UpTypeName := 'CARDINAL'
    else if UpTypeName = 'DWORD' then
      UpTypeName := 'CARDINAL'
    else if UpTypeName = 'UINT' then
      UpTypeName := 'CARDINAL'
    else if UpTypeName = 'ULONG' then
      UpTypeName := 'CARDINAL'
    else if UpTypeName = 'THANDLE' then
      UpTypeName := 'CARDINAL';

    if UserData = '' then
      AddLine('RegisterVariable(' + StringConst(E.Name) + ', ' +
                                  StringConst(UpTypeName) + ',' +
                                  '@' + E.Name + ', H);')
    else
      AddLine('RegisterVariable(' + StringConst(E.Name) + ', ' +
                                  StringConst(UpTypeName) + ',' +
                                  '@' + E.Name + ', H, ' + UserData + ');');
  end;
end;

//--------- Interface  -------------------//

procedure TForm1.WDelphiParser1InterfaceEntry(aEntry: TEntry;
  aAddEntry, IsForward: Boolean);
var
  E: TInterfaceEntry;
begin
  EndOfUsesClause;

  E := TInterfaceEntry(aEntry);

  if E.IsMetaClass then
    Exit;
  if IsForward then
    Exit;
  if E.Parents.Count = 0 then
    Exit;

  if E.GUID = '' then
  begin
    CurrentClass := '';
    Exit;
  end;

  CurrentClass := E.Name;

  VisitedClasses.AddObject(CurrentClass, TClassRec.Create(E));

  AddLine('// Begin of interface ' + CurrentClass);
//  AddLine('RegisterRTTIType(TypeInfo(' + CurrentClass + '), H);');


  if UserData = '' then
    AddLine('RegisterInterfaceType(' + StringConst(E.Name) + ',' +
                                    E.Name + ',' +
                                    StringConst(E.Parents[0]) + ',' +
                                    E.Parents[0] + ',' +
                                    'H);')
  else
    AddLine('RegisterInterfaceType(' + StringConst(E.Name) + ',' +
                                    E.Name + ',' +
                                    StringConst(E.Parents[0]) + ',' +
                                    E.Parents[0] +
                                    ', H, ' + UserData + ');');
  body := bInterface;
end;

procedure TForm1.WDelphiParser1DispInterfaceEntry(aEntry: TEntry;
  aAddEntry, IsForward: Boolean);
var
  E: TInterfaceEntry;
begin
  EndOfUsesClause;

  E := TInterfaceEntry(aEntry);

  if E.IsMetaClass then
    Exit;
  if IsForward then
    Exit;

  if E.GUID = '' then
  begin
    CurrentClass := '';
    Exit;
  end;

  CurrentClass := E.Name;

  VisitedClasses.AddObject(CurrentClass, TClassRec.Create(E));

  Exit; // not implemented yet

  AddLine('// Begin of interface ' + CurrentClass);
//  AddLine('RegisterRTTIType(TypeInfo(' + CurrentClass + '), H);');


  if UserData = '' then
      AddLine('RegisterInterfaceType(' + StringConst(E.Name) + ',' +
                                    E.Name + ',' +
                                    StringConst('IDispatch') + ',' +
                                    'IDispatch' + ',' +
                                    'H);')
  else
      AddLine('RegisterInterfaceType(' + StringConst(E.Name) + ',' +
                                    E.Name + ',' +
                                    StringConst('IDispatch') + ',' +
                                    'IDispatch' +
                                    ', H, ' + UserData + ');');

  body := bInterface;
end;

//--------- Type  -------------------//

procedure TForm1.WDelphiParser1TypeEntry(aEntry: TEntry; aAddEntry : boolean);
var
  E: TTypeEntry;
begin
  EndOfUsesClause;

  E := TTypeEntry(aEntry);

  if Pos('^', E.ExistingType) > 0 then
    Exit;
  if Pos('[', E.ExistingType) > 0 then
    Exit;
  if Pos(' of ', E.ExistingType) > 0 then
  begin
    if Pos('SET ', UpperCase(E.ExistingType)) = 1 then
      AddLine('RegisterRTTIType(TypeInfo(' + E.Name + '));');
    Exit;
  end;
  if Pos('(', E.ExistingType) > 0 then
    Exit;

  if Pos('..', E.ExistingType) > 0 then
    AddLine('RegisterRTTIType(TypeInfo(' + E.Name + '));')
  else
    AddLine('RegisterTypeAlias(' + StringConst(E.Name) + ',' + StringConst(E.ExistingType) + ');');
end;

//--------- Class  -------------------//

procedure TForm1.WDelphiParser1ClassEntry(aEntry: TEntry;  aAddEntry, IsForward: Boolean);
var
  E: TClassEntry;
begin
  EndOfUsesClause;

  E := TClassEntry(aEntry);

  if E.IsMetaClass then
    Exit;
  if IsForward then
    Exit;

  CurrentClass := E.Name;

  VisitedClasses.AddObject(CurrentClass, TClassRec.Create(E));

  AddLine('// Begin of class ' + CurrentClass);

  if UserData = '' then
    AddLine('RegisterClassType(' + CurrentClass + ', H);')
  else
    AddLine('RegisterClassType(' + CurrentClass + ', H, ' + UserData + ');');

  body := bClass;
end;

//--------- Global procedure -------------------//

procedure TForm1.WDelphiParser1ProcedureEntry(aEntry: TEntry;
  aAddEntry: Boolean);
var
  E: TProcedureEntry;
  P: TSimpleParser;
  S, TypeRes, Types, FakeName: String;
  I: Integer;
  SignEx: Boolean;
  PosOver: Integer;
begin
  EndOfUsesClause;

  E := TProcedureEntry(aEntry);

  if not IsValidProcedureEntry(E) then
    Exit;

  if VisitedRoutines.IndexOf(E.Name) >= 0 then
    Exit;

  if ValidConst(E.Declaration) then
  begin
    PosOver := Pos('OVERLOAD', UpperCase(E.Declaration));

    if PosOver > 0 then
    begin
      Inc(OverCount);
      FakeName := E.Name + IntToStr(OverCount);
    end
    else
      FakeName := E.Name;

    P := TSimpleParser.Create;
    try
      P.Parse_Header(E.Declaration);

      if RadioButton2.Checked then
        P.Fail := true;

      if not P.Fail then
      begin
        ExtraCode.Add('procedure _' + FakeName + '(MethodBody: TPAXMethodBody);');
        ExtraCode.Add('begin');
        ExtraCode.Add('  with MethodBody do');

        TypeRes := 'typeINTEGER';
        Types := '';
        SignEx := true;

        S := '';

        S := S + SourceUnitName + '.' + E.Name + '(';

        for I:=1 to P.NP do
        begin
          S := S + 'Params[' + IntToStr(I-1) + '].';

          if I > 1 then types := types + ',';

          if P.Types[I] = P.typCARDINAL then
          begin
            S := S + 'AsCardinal';
            types := types + 'typeCARDINAL';
          end
          else if P.Types[I] = P.typDWORD then
          begin
            S := S + 'AsCardinal';
            types := types + 'typeCARDINAL';
          end
          else if P.Types[I] = P.typUINT then
          begin
            S := S + 'AsCardinal';
            types := types + 'typeCARDINAL';
          end
          else if P.Types[I] = P.typBYTE then
          begin
            S := S + 'AsInteger';
            types := types + 'typeINTEGER';
          end
          else if P.Types[I] = P.typEXTENDED then
          begin
            S := S + 'AsDouble';
            types := types + 'typeDOUBLE';
          end
          else if P.Types[I] = P.typSINGLE then
          begin
            S := S + 'AsDouble';
            types := types + 'typeINTEGER';
          end
          else if P.Types[I] = P.typPOINTER then
          begin
            S := S + 'AsPointer';
            types := types + 'typePOINTER';
          end
          else if P.Types[I] = P.typSTRING then
          begin
            S := S + 'AsString';
            types := types + 'typeSTRING';
          end
          else if P.Types[I] = P.typBOOLEAN then
          begin
            S := S + 'AsBoolean';
            types := types + 'typeBOOLEAN';
          end
          else if P.Types[I] = P.typINTEGER then
          begin
            S := S + 'AsInteger';
            types := types + 'typeINTEGER';
          end
          else if P.Types[I] = P.typDOUBLE then
          begin
            S := S + 'AsDouble';
            types := types + 'typeDOUBLE';
          end
          else
          begin
            S := S + 'PValue^';
            SignEx := false;
          end;

          if I < P.NP then
            S := S + ',';
        end;

        S := S + ');';
        ExtraCode.Add(S);
        ExtraCode.Add('end;');

        if (Types <> '') and (TypeRes <> '') then
          Types := Types + ',';

        if SignEx then
        begin
          if UserData = '' then
            AddLine('RegisterStdRoutineEx(' +
                   StringConst(E.Name) + ', _' + FakeName + ',' + IntToStr(P.NP) +
                   ',[' + Types + TypeRes + ']' +
                   ', H);')
           else
             AddLine('RegisterStdRoutineEx(' +
                   StringConst(E.Name) + ', _' + FakeName + ',' + IntToStr(P.NP) +
                   ',[' + Types + TypeRes + ']' +
                   ', H, ' + UserData + ');');
        end
        else
        begin
          if UserData = '' then
            AddLine('RegisterStdRoutine(' +
                   StringConst(E.Name) + ', _' + FakeName + ',' + IntToStr(P.NP) +
                   ', H);')
          else
            AddLine('RegisterStdRoutine(' +
                   StringConst(E.Name) + ', _' + FakeName + ',' + IntToStr(P.NP) +
                   ', H, ' + UserData + ');');
        end;
      end
      else
      begin

        if PosOver > 0 then
        begin
          S := Copy(E.Declaration, 1, PosOver - 1);
          S := StringReplace(S, E.Name, FakeName, [rfIgnoreCase]);

          ExtraCode.Add(S);
          ExtraCode.Add('begin');
          S := '  ' + SourceUnitName + '.' + E.Name + '(';
          for I:=0 to P.ParamList.Count - 1 do
          begin
            S := S + P.ParamList[I];
            if I < P.ParamList.Count - 1 then
              S := S + ',';
          end;
          S := S + ');';
          ExtraCode.Add(S);
          ExtraCode.Add('end;');

          if UserData = '' then
            AddLine('RegisterRoutine(' +
                   StringConst(E.Declaration) + ', @' + FakeName + ', H);')
          else
            AddLine('RegisterRoutine(' +
                   StringConst(E.Declaration) + ', @' + FakeName +
                   ', H, ' + UserData + ');');
        end
        else
        begin
          if UserData = '' then
            AddLine('RegisterRoutine(' +
                   StringConst(E.Declaration) + ', @' + E.Name + ', H);')
          else
            AddLine('RegisterRoutine(' +
                   StringConst(E.Declaration) + ', @' + E.Name +
                   ', H, ' + UserData + ');');
        end;
      end;
    finally
      P.Free;
      VisitedRoutines.Add(FakeName);
    end;
  end;
end;

//--------- Global function -------------------//

procedure TForm1.WDelphiParser1FunctionEntry(aEntry: TEntry;
  aAddEntry: Boolean);
var
  E: TFunctionEntry;
  P: TSimpleParser;
  S, TypeRes, Types, FakeName: String;
  I: Integer;
  SignEx: Boolean;
  PosOver: Integer;
begin
  EndOfUsesClause;

  E := TFunctionEntry(aEntry);

  if not IsValidFunctionEntry(E) then
    Exit;

  if VisitedRoutines.IndexOf(E.Name) >= 0 then
    Exit;

  if StrEql(SourceUnitName, 'SysUtils') and StrEql(E.Name, 'StringReplace') then
  begin
    if UserData = '' then
    begin
      AddLine('RegisterConstant(''rfReplaceAll'', rfReplaceAll, H);');
      AddLine('RegisterConstant(''rfIgnoreCase'', rfIgnoreCase, H);');
      AddLine('RegisterStdRoutine(''StringReplace'', _StringReplace, 4, H);');
    end
    else
    begin
      AddLine('RegisterConstant(''rfReplaceAll'', rfReplaceAll, H, ' + UserData + ');');
      AddLine('RegisterConstant(''rfIgnoreCase'', rfIgnoreCase, H, ' + UserData + ');');
      AddLine('RegisterStdRoutine(''StringReplace'', _StringReplace, 4, H, ' + UserData + ');');
    end;

    ExtraCode.Add('procedure _StringReplace(MethodBody: TPAXMethodBody);');
    ExtraCode.Add('var');
    ExtraCode.Add('  Flags: TReplaceFlags;');
    ExtraCode.Add('begin');
    ExtraCode.Add('  with MethodBody do');
    ExtraCode.Add('  begin');
    ExtraCode.Add('    Flags := [];');
    ExtraCode.Add('    result.AsString := StringReplace(Params[0].AsString, Params[1].AsString, Params[2].AsString, Flags);');
    ExtraCode.Add('  end;');
    ExtraCode.Add('end;');
    Exit;
  end
  else if StrEql(SourceUnitName, 'SysUtils') and StrEql(E.Name, 'FileRead') then
  begin
    if UserData = '' then
      AddLine('RegisterStdRoutine(''FileRead'', _FileRead, 3, H);')
    else
      AddLine('RegisterStdRoutine(''FileRead'', _FileRead, 3, H, ' + UserData + ');');

    ExtraCode.Add('procedure _FileRead(MethodBody: TPAXMethodBody);');
    ExtraCode.Add('var');
    ExtraCode.Add('  Count, VT: Integer; V: Variant; S: String; P: Pointer;');
    ExtraCode.Add('begin');
    ExtraCode.Add('  with MethodBody do');
    ExtraCode.Add('  begin');
    ExtraCode.Add('    V := Params[1].AsVariant;');
    ExtraCode.Add('    P := Pointer(Integer(@V) + 8);');
    ExtraCode.Add('    Count := Params[2].AsVariant;');
    ExtraCode.Add('    VT := VarType(V);');
    ExtraCode.Add('    case VT of');
    ExtraCode.Add('      varString:');
    ExtraCode.Add('      begin');
    ExtraCode.Add('        P := AllocMem(Count + 1);');
    ExtraCode.Add('        FillChar(P^, Count + 1, 0);');
    ExtraCode.Add('        try');
    ExtraCode.Add('          Result.AsInteger := FileRead(Params[0].AsVariant, P^, Count);');
    ExtraCode.Add('        finally');
    ExtraCode.Add('          S := String(Pchar(P));');
    ExtraCode.Add('          FreeMem(P, Count + 1);');
    ExtraCode.Add('        end;');
    ExtraCode.Add('        Params[1].AsVariant := S;');
    ExtraCode.Add('      end;');
    ExtraCode.Add('      varVariant:');
    ExtraCode.Add('      begin');
    ExtraCode.Add('        Result.AsInteger := FileRead(Params[0].AsVariant, V, Count);');
    ExtraCode.Add('        Params[1].AsVariant := V;');
    ExtraCode.Add('      end;');
    ExtraCode.Add('      else');
    ExtraCode.Add('      begin');
    ExtraCode.Add('        Result.AsInteger := FileRead(Params[0].AsVariant, P^, Count);');
    ExtraCode.Add('        Params[1].AsVariant := V;');
    ExtraCode.Add('      end;');
    ExtraCode.Add('    end;');
    ExtraCode.Add('  end;');
    ExtraCode.Add('end;');

    Exit;
  end
  else if StrEql(SourceUnitName, 'SysUtils') and StrEql(E.Name, 'FileWrite') then
  begin
    if UserData = '' then
      AddLine('RegisterStdRoutine(''FileWrite'', _FileWrite, 3, H);')
    else
      AddLine('RegisterStdRoutine(''FileWrite'', _FileWrite, 3, H, ' + UserData + ');');

    ExtraCode.Add('procedure _FileWrite(MethodBody: TPAXMethodBody);');
    ExtraCode.Add('var');
    ExtraCode.Add('  Count, VT: Integer;  V: Variant;  I: Integer;  D: Double;  B: Boolean;  S: String;');
    ExtraCode.Add('begin');
    ExtraCode.Add('  with MethodBody do');
    ExtraCode.Add('  begin');
    ExtraCode.Add('    V := Params[1].AsVariant;');
    ExtraCode.Add('    Count := Params[2].AsVariant;');
    ExtraCode.Add('    VT := VarType(V);');
    ExtraCode.Add('    case VT of');
    ExtraCode.Add('      varInteger:');
    ExtraCode.Add('      begin');
    ExtraCode.Add('        I := V;');
    ExtraCode.Add('        Result.AsInteger := FileWrite(Params[0].AsVariant, I, Count);');
    ExtraCode.Add('      end;');
    ExtraCode.Add('      varDouble:');
    ExtraCode.Add('      begin');
    ExtraCode.Add('        D := V;');
    ExtraCode.Add('        Result.AsInteger := FileWrite(Params[0].AsVariant, D, Count);');
    ExtraCode.Add('      end;');
    ExtraCode.Add('      varBoolean:');
    ExtraCode.Add('      begin');
    ExtraCode.Add('        B := V;');
    ExtraCode.Add('        Result.AsInteger := FileWrite(Params[0].AsVariant, B, Count);');
    ExtraCode.Add('      end;');
    ExtraCode.Add('      varString:');
    ExtraCode.Add('      begin');
    ExtraCode.Add('        S := V;');
    ExtraCode.Add('        Result.AsInteger := FileWrite(Params[0].AsVariant, Pointer(S)^, Count);');
    ExtraCode.Add('      end;');
    ExtraCode.Add('      varVariant:');
    ExtraCode.Add('        Result.AsInteger := FileWrite(Params[0].AsVariant, V, Count);');
    ExtraCode.Add('    end;');
    ExtraCode.Add('  end;');
    ExtraCode.Add('end;');

    Exit;
  end;


  if ValidConst(E.Declaration) then
  begin
    PosOver := Pos('OVERLOAD', UpperCase(E.Declaration));

    if PosOver > 0 then
    begin
      Inc(OverCount);
      FakeName := E.Name + IntToStr(OverCount);
    end
    else
      FakeName := E.Name;

    P := TSimpleParser.Create;
    try
      P.Parse_Header(E.Declaration);

      if RadioButton2.Checked then
        P.Fail := true;

      if not P.Fail then
      begin
        ExtraCode.Add('procedure _' + FakeName + '(MethodBody: TPAXMethodBody);');
        ExtraCode.Add('begin');
        ExtraCode.Add('  with MethodBody do');

        TypeRes := '';
        Types := '';
        SignEx := true;

        if P.IsFunction then
        begin
          if P.TypeRes = P.typCARDINAL then
          begin
            S := '   result.AsCardinal := ';
            TypeRes := 'typeCARDINAL';
          end
          else if P.TypeRes = P.typDWORD then
          begin
            S := '   result.AsCardinal := ';
            TypeRes := 'typeCARDINAL';
          end
          else if P.TypeRes = P.typUINT then
          begin
            S := '   result.AsCardinal := ';
            TypeRes := 'typeCARDINAL';
          end
          else if P.TypeRes = P.typBYTE then
          begin
            S := '   result.AsInteger := ';
            TypeRes := 'typeINTEGER';
          end
          else if P.TypeRes = P.typEXTENDED then
          begin
            S := '   result.AsDouble := ';
            TypeRes := 'typeDOUBLE';
          end
          else if P.TypeRes = P.typSINGLE then
          begin
            S := '   result.AsDouble := ';
            TypeRes := 'typeDOUBLE';
          end
          else if P.TypeRes = P.typPOINTER then
          begin
            S := '   result.AsPOINTER := ';
            TypeRes := 'typePOINTER';
          end
          else if P.TypeRes = P.typSTRING then
          begin
            S := '   result.AsString := ';
            TypeRes := 'typeSTRING';
          end
          else if P.TypeRes = P.typBOOLEAN then
          begin
            S := '   result.AsBoolean := ';
            TypeRes := 'typeBOOLEAN';
          end
          else if P.TypeRes = P.typINTEGER then
          begin
            S := '   result.AsInteger := ';
            TypeRes := 'typeINTEGER';
          end
          else if P.TypeRes = P.typDOUBLE then
          begin
            S := '   result.AsDouble := ';
            TypeRes := 'typeDOUBLE';
          end
          else
          begin
            S := '   result.PValue^ := ';
            SignEx := false;
          end;
        end
        else
          S := '';

        S := S + SourceUnitName + '.' + E.Name + '(';

        for I:=1 to P.NP do
        begin
          S := S + 'Params[' + IntToStr(I-1) + '].';

          if I > 1 then types := types + ',';

          if P.Types[I] = P.typCARDINAL then
          begin
            S := S + 'AsCardinal';
            types := types + 'typeCARDINAL';
          end
          else if P.Types[I] = P.typDWORD then
          begin
            S := S + 'AsCardinal';
            types := types + 'typeCARDINAL';
          end
          else if P.Types[I] = P.typUINT then
          begin
            S := S + 'AsCardinal';
            types := types + 'typeCARDINAL';
          end
          else if P.Types[I] = P.typBYTE then
          begin
            S := S + 'AsInteger';
            types := types + 'typeINTEGER';
          end
          else if P.Types[I] = P.typEXTENDED then
          begin
            S := S + 'AsDouble';
            types := types + 'typeDOUBLE';
          end
          else if P.Types[I] = P.typSINGLE then
          begin
            S := S + 'AsDouble';
            types := types + 'typeINTEGER';
          end
          else if P.Types[I] = P.typPOINTER then
          begin
            S := S + 'AsPointer';
            types := types + 'typePOINTER';
          end
          else if P.Types[I] = P.typSTRING then
          begin
            S := S + 'AsString';
            types := types + 'typeSTRING';
          end
          else if P.Types[I] = P.typBOOLEAN then
          begin
            S := S + 'AsBoolean';
            types := types + 'typeBOOLEAN';
          end
          else if P.Types[I] = P.typINTEGER then
          begin
            S := S + 'AsInteger';
            types := types + 'typeINTEGER';
          end
          else if P.Types[I] = P.typDOUBLE then
          begin
            S := S + 'AsDouble';
            types := types + 'typeDOUBLE';
          end
          else
          begin
            S := S + 'PValue^';
            SignEx := false;
          end;

          if I < P.NP then
            S := S + ',';
        end;

        S := S + ');';
        ExtraCode.Add(S);
        ExtraCode.Add('end;');

        if (Types <> '') and (TypeRes <> '') then
          Types := Types + ',';

        if SignEx then
        begin
          if UserData = '' then
            AddLine('RegisterStdRoutineEx(' +
                   StringConst(E.Name) + ', _' + FakeName + ',' + IntToStr(P.NP) +
                   ',[' + Types + TypeRes + ']' +
                   ', H);')
          else
            AddLine('RegisterStdRoutineEx(' +
                   StringConst(E.Name) + ', _' + FakeName + ',' + IntToStr(P.NP) +
                   ',[' + Types + TypeRes + ']' +
                   ', H, ' + UserData + ');');
        end
        else
        begin
          if UserData = '' then
            AddLine('RegisterStdRoutine(' +
                   StringConst(E.Name) + ', _' + FakeName + ',' + IntToStr(P.NP) +
                   ', H);')
          else
            AddLine('RegisterStdRoutine(' +
                   StringConst(E.Name) + ', _' + FakeName + ',' + IntToStr(P.NP) +
                   ', H, ' + UserData + ');');
        end;
      end
      else
      begin

        if PosOver > 0 then
        begin
          S := Copy(E.Declaration, 1, PosOver - 1);
          S := StringReplace(S, E.Name, FakeName, [rfIgnoreCase]);

          ExtraCode.Add(S);
          ExtraCode.Add('begin');
          S := '  result := ' + SourceUnitName + '.' + E.Name + '(';
          for I:=0 to P.ParamList.Count - 1 do
          begin
            S := S + P.ParamList[I];
            if I < P.ParamList.Count - 1 then
              S := S + ',';
          end;
          S := S + ');';
          ExtraCode.Add(S);
          ExtraCode.Add('end;');

          if UserData = '' then
            AddLine('RegisterRoutine(' +
                   StringConst(E.Declaration) + ', @' + FakeName + ', H);')
          else
            AddLine('RegisterRoutine(' +
                   StringConst(E.Declaration) + ', @' + FakeName +
                   ', H, ' + UserData + ');');
        end
        else
        begin
          if UserData = '' then
            AddLine('RegisterRoutine(' +
                   StringConst(E.Declaration) + ', @' + E.Name + ', H);')
          else
            AddLine('RegisterRoutine(' +
                   StringConst(E.Declaration) + ', @' + E.Name +
                   ', H, ' + UserData + ');');
        end;
      end;
    finally
      P.Free;
      VisitedRoutines.Add(FakeName);
    end;
  end;
end;

procedure TForm1.WDelphiParser1ClassFunctionEntry(aEntry: TEntry;
  aAddEntry: Boolean);
var
  E: TClassFunctionEntry;
  P: TSimpleParser;
  S, TypeRes, Types: String;
  I: Integer;
  SignEx: Boolean;
  PosOver: Integer;
  FakeName: String;
begin
  EndOfUsesClause;

  if CurrentClass = '' then
    Exit;

  E := TClassFunctionEntry(aEntry);

  if not IsValidClassFunctionEntry(E) then
    Exit;

  if not ValidConst(E.Declaration) then Exit;

  P := TSimpleParser.Create;
  try
    PosOver := Pos('OVERLOAD', UpperCase(E.Declaration));

    if PosOver > 0 then
    begin
      Inc(OverCount);
      FakeName := E.Name + IntToStr(OverCount);
    end
    else
      FakeName := E.Name;

    P.Parse_Header(E.Declaration);

    if RadioButton2.Checked then
      P.Fail := true;

    if body = bInterface then
      P.Fail := true;

    if not P.Fail then
    begin
      ExtraCode.Add('procedure ' +
        CurrentClass + '_' + FakeName + '(MethodBody: TPAXMethodBody);');
      ExtraCode.Add('begin');
      ExtraCode.Add('  with MethodBody do');

      TypeRes := '';
      Types := '';
      SignEx := true;

      if P.IsFunction then
      begin
        if P.TypeRes = P.typCARDINAL then
        begin
          S := '   result.AsCardinal := ';
          TypeRes := 'typeCARDINAL';
        end
        else if P.TypeRes = P.typDWORD then
        begin
          S := '   result.AsCardinal := ';
          TypeRes := 'typeCARDINAL';
        end
        else if P.TypeRes = P.typUINT then
        begin
          S := '   result.AsCardinal := ';
          TypeRes := 'typeCARDINAL';
        end
        else if P.TypeRes = P.typBYTE then
        begin
          S := '   result.AsInteger := ';
          TypeRes := 'typeINTEGER';
        end
        else if P.TypeRes = P.typEXTENDED then
        begin
          S := '   result.AsDouble := ';
          TypeRes := 'typeDOUBLE';
        end
        else if P.TypeRes = P.typSINGLE then
        begin
          S := '   result.AsDouble := ';
          TypeRes := 'typeDOUBLE';
        end
        else if P.TypeRes = P.typPOINTER then
        begin
          S := '   result.AsPointer := ';
          TypeRes := 'typePOINTER';
        end
        else if P.TypeRes = P.typSTRING then
        begin
          S := '   result.AsString := ';
          TypeRes := 'typeSTRING';
        end
        else if P.TypeRes = P.typBOOLEAN then
        begin
          S := '   result.AsBoolean := ';
          TypeRes := 'typeBOOLEAN';
        end
        else if P.TypeRes = P.typINTEGER then
        begin
          S := '   result.AsInteger := ';
          TypeRes := 'typeINTEGER';
        end
        else if P.TypeRes = P.typDOUBLE then
        begin
          S := '   result.AsDouble := ';
          TypeRes := 'typeDOUBLE';
        end
        else
        begin
          S := '   result.PValue^ := ';
          SignEx := false;
        end;
      end
      else
        S := '';

      S := S + CurrentClass + '(Self).';

      S := S + E.Name + '(';
      for I:=1 to P.NP do
      begin
        S := S + 'Params[' + IntToStr(I-1) + '].';

        if I > 1 then types := types + ',';

        if P.Types[I] = P.typCARDINAL then
        begin
          S := S + 'AsCardinal';
          types := types + 'typeCARDINAL';
        end
        else if P.Types[I] = P.typDWORD then
        begin
          S := S + 'AsCardinal';
          types := types + 'typeCARDINAL';
        end
        else if P.Types[I] = P.typUINT then
        begin
          S := S + 'AsCardinal';
          types := types + 'typeCARDINAL';
        end
        else if P.Types[I] = P.typBYTE then
        begin
          S := S + 'AsInteger';
          types := types + 'typeINTEGER';
        end
        else if P.Types[I] = P.typEXTENDED then
        begin
          S := S + 'AsDouble';
          types := types + 'typeDOUBLE';
        end
        else if P.Types[I] = P.typSINGLE then
        begin
          S := S + 'AsDouble';
          types := types + 'typeINTEGER';
        end
        else if P.Types[I] = P.typPOINTER then
        begin
          S := S + 'AsPointer';
          types := types + 'typePOINTER';
        end
        else if P.Types[I] = P.typSTRING then
        begin
          S := S + 'AsString';
          types := types + 'typeSTRING';
        end
        else if P.Types[I] = P.typBOOLEAN then
        begin
          S := S + 'AsBoolean';
          types := types + 'typeBOOLEAN';
        end
        else if P.Types[I] = P.typINTEGER then
        begin
          S := S + 'AsInteger';
          types := types + 'typeINTEGER';
        end
        else if P.Types[I] = P.typDOUBLE then
        begin
          S := S + 'AsDouble';
          types := types + 'typeDOUBLE';
        end
        else
        begin
          S := S + 'PValue^';
          SignEx := false;
        end;

        if I < P.NP then
          S := S + ',';
      end;
      S := S + ');';
      ExtraCode.Add(S);
      ExtraCode.Add('end;');

      if (Types <> '') and (TypeRes <> '') then
        Types := Types + ',';

      if SignEx then
      begin
        if UserData = '' then
          AddLine('RegisterStdMethodEx(' + CurrentClass + ',' +
                 StringConst(E.Name) + ',' +
                 CurrentClass + '_' + FakeName + ',' + IntToStr(P.NP) +
                 ',[' + Types + TypeRes + ']' +
                 ');')
        else
          AddLine('RegisterStdMethodEx(' + CurrentClass + ',' +
                 StringConst(E.Name) + ',' +
                 CurrentClass + '_' + FakeName + ',' + IntToStr(P.NP) +
                 ',[' + Types + TypeRes + '], ' +
                 UserData + ');');
       end
      else
      begin
        if UserData = '' then
          AddLine('RegisterStdMethod(' + CurrentClass + ',' +
                 StringConst(E.Name) + ',' +
                 CurrentClass + '_' + FakeName + ',' + IntToStr(P.NP) + ');')
        else
          AddLine('RegisterStdMethod(' + CurrentClass + ',' +
                 StringConst(E.Name) + ',' +
                 CurrentClass + '_' + FakeName + ',' + IntToStr(P.NP) + ', ' + UserData + ');');

      end;
    end
    else
    begin
      if body = bInterface then
      begin
//      AddLine('RegisterInterfaceMethod(TypeInfo(' + CurrentClass + '),');


        AddLine('RegisterInterfaceMethod(' + CurrentClass + ',');

        if UserData = '' then
          AddLine(Space(5) + StringConst(E.Declaration) + ');')
        else
          AddLine(Space(5) + StringConst(E.Declaration) + ', - 1, ' + UserData + ');');
      end
      else if PosOver > 0 then
      begin
      end
      else
      begin
        AddLine('RegisterMethod(' + CurrentClass + ',');
        AddLine(Space(5) + StringConst(E.Declaration) + ',');

        if UserData = '' then
          AddLine(Space(5) + '@' + CurrentClass + '.' + E.Name + ');')
        else
          AddLine(Space(5) + '@' + CurrentClass + '.' + E.Name + ', false,' + UserData + ');');
      end;
    end;
  finally
    P.Free;
  end;

end;

procedure TForm1.WDelphiParser1ClassProcedureEntry(aEntry: TEntry;
  aAddEntry: Boolean);
var
  E: TClassProcedureEntry;
  P: TSimpleParser;
  S, TypeRes, Types: String;
  I: Integer;
  SignEx: Boolean;
  PosOver: Integer;
  FakeName: String;
begin
  EndOfUsesClause;

  if CurrentClass = '' then
    Exit;

  E := TClassProcedureEntry(aEntry);

  if not IsValidClassProcedureEntry(E) then
    Exit;

  if not ValidConst(E.Declaration) then Exit;

  P := TSimpleParser.Create;
  try
    PosOver := Pos('OVERLOAD', UpperCase(E.Declaration));

    if PosOver > 0 then
    begin
      Inc(OverCount);
      FakeName := E.Name + IntToStr(OverCount);
    end
    else
      FakeName := E.Name;

    P.Parse_Header(E.Declaration);

    if RadioButton2.Checked then
      P.Fail := true;

    if body = bInterface then
      P.Fail := true;

    if not P.Fail then
    begin
      ExtraCode.Add('procedure ' +
        CurrentClass + '_' + FakeName + '(MethodBody: TPAXMethodBody);');
      ExtraCode.Add('begin');
      ExtraCode.Add('  with MethodBody do');

      TypeRes := '';
      Types := '';
      SignEx := true;

      if P.IsFunction then
      begin
        if P.TypeRes = P.typCARDINAL then
        begin
          S := '   result.AsCardinal := ';
          TypeRes := 'typeCARDINAL';
        end
        else if P.TypeRes = P.typDWORD then
        begin
          S := '   result.AsCardinal := ';
          TypeRes := 'typeCARDINAL';
        end
        else if P.TypeRes = P.typUINT then
        begin
          S := '   result.AsCardinal := ';
          TypeRes := 'typeCARDINAL';
        end
        else if P.TypeRes = P.typBYTE then
        begin
          S := '   result.AsInteger := ';
          TypeRes := 'typeINTEGER';
        end
        else if P.TypeRes = P.typEXTENDED then
        begin
          S := '   result.AsDouble := ';
          TypeRes := 'typeDOUBLE';
        end
        else if P.TypeRes = P.typSINGLE then
        begin
          S := '   result.AsDouble := ';
          TypeRes := 'typeDOUBLE';
        end
        else if P.TypeRes = P.typPOINTER then
        begin
          S := '   result.AsPointer := ';
          TypeRes := 'typePOINTER';
        end
        else if P.TypeRes = P.typSTRING then
        begin
          S := '   result.AsString := ';
          TypeRes := 'typeSTRING';
        end
        else if P.TypeRes = P.typBOOLEAN then
        begin
          S := '   result.AsBoolean := ';
          TypeRes := 'typeBOOLEAN';
        end
        else if P.TypeRes = P.typINTEGER then
        begin
          S := '   result.AsInteger := ';
          TypeRes := 'typeINTEGER';
        end
        else if P.TypeRes = P.typDOUBLE then
        begin
          S := '   result.AsDouble := ';
          TypeRes := 'typeDOUBLE';
        end
        else
        begin
          S := '   result.PValue^ := ';
          SignEx := false;
        end;
      end
      else
      begin
        TypeRes := 'typeVARIANT';
        S := '';
      end;

      S := S + CurrentClass + '(Self).';

      S := S + E.Name + '(';
      for I:=1 to P.NP do
      begin
        S := S + 'Params[' + IntToStr(I-1) + '].';

        if I > 1 then types := types + ',';

        if P.Types[I] = P.typCARDINAL then
        begin
          S := S + 'AsCardinal';
          types := types + 'typeCARDINAL';
        end
        else if P.Types[I] = P.typDWORD then
        begin
          S := S + 'AsCardinal';
          types := types + 'typeCARDINAL';
        end
        else if P.Types[I] = P.typUINT then
        begin
          S := S + 'AsCardinal';
          types := types + 'typeCARDINAL';
        end
        else if P.Types[I] = P.typBYTE then
        begin
          S := S + 'AsInteger';
          types := types + 'typeINTEGER';
        end
        else if P.Types[I] = P.typEXTENDED then
        begin
          S := S + 'AsDouble';
          types := types + 'typeDOUBLE';
        end
        else if P.Types[I] = P.typSINGLE then
        begin
          S := S + 'AsDouble';
          types := types + 'typeINTEGER';
        end
        else if P.Types[I] = P.typPOINTER then
        begin
          S := S + 'AsPointer';
          types := types + 'typePOINTER';
        end
        else if P.Types[I] = P.typSTRING then
        begin
          S := S + 'AsString';
          types := types + 'typeSTRING';
        end
        else if P.Types[I] = P.typBOOLEAN then
        begin
          S := S + 'AsBoolean';
          types := types + 'typeBOOLEAN';
        end
        else if P.Types[I] = P.typINTEGER then
        begin
          S := S + 'AsInteger';
          types := types + 'typeINTEGER';
        end
        else if P.Types[I] = P.typDOUBLE then
        begin
          S := S + 'AsDouble';
          types := types + 'typeDOUBLE';
        end
        else
        begin
          S := S + 'PValue^';
          SignEx := false;
        end;

        if I < P.NP then
          S := S + ',';
      end;
      S := S + ');';
      ExtraCode.Add(S);
      ExtraCode.Add('end;');

      if (Types <> '') and (TypeRes <> '') then
        Types := Types + ',';

      if SignEx then
      begin
        if UserData = '' then
          AddLine('RegisterStdMethodEx(' + CurrentClass + ',' +
                 StringConst(E.Name) + ',' +
                 CurrentClass + '_' + FakeName + ',' + IntToStr(P.NP) +
                 ',[' + Types + TypeRes + ']' +
                  ');')
        else
          AddLine('RegisterStdMethodEx(' + CurrentClass + ',' +
                 StringConst(E.Name) + ',' +
                 CurrentClass + '_' + FakeName + ',' + IntToStr(P.NP) +
                 ',[' + Types + TypeRes + ']' + ', ' + UserData +
                  ');')
      end
      else
      begin
        if UserData = '' then
          AddLine('RegisterStdMethod(' + CurrentClass + ',' +
                   StringConst(E.Name) + ',' +
                   CurrentClass + '_' + FakeName + ',' + IntToStr(P.NP) + ');')
        else
          AddLine('RegisterStdMethod(' + CurrentClass + ',' +
                   StringConst(E.Name) + ',' +
                   CurrentClass + '_' + FakeName + ',' + IntToStr(P.NP) + ', ' + UserData + ');')
     end;
    end
    else
    begin
      if body = bInterface then
      begin
//     AddLine('RegisterInterfaceMethod(TypeInfo(' + CurrentClass + '),');

        AddLine('RegisterInterfaceMethod(' + CurrentClass + ',');

        if UserData = '' then
          AddLine(Space(5) + StringConst(E.Declaration) + ');')
        else
          AddLine(Space(5) + StringConst(E.Declaration) + ', -1, ' + UserData + ');')
      end
      else if PosOver > 0 then
      begin
      end
      else
      begin
        AddLine('RegisterMethod(' + CurrentClass + ',');
        AddLine(Space(5) + StringConst(E.Declaration) + ',');

        if UserData = '' then
          AddLine(Space(5) + '@' + CurrentClass + '.' + E.Name + ');')
        else
          AddLine(Space(5) + '@' + CurrentClass + '.' + E.Name + ', false, ' + UserData + ');')
      end;

      if Pos('constructor', E.Declaration) = 1 then
      with VisitedClasses do
        TClassRec(Objects[Count - 1]).ConstructorDef := E.Declaration;
    end;
  finally
    P.Free;
  end;
end;

procedure TForm1.WDelphiParser1EnumType(const TypeName: String);
begin
  if RadioButton1.Checked then
    AddLine('RegisterRTTIType(TypeInfo(' + TypeName + '));');
end;

procedure TForm1.WDelphiParser1ClassPropertyEntry(aEntry: TEntry;
  aAddEntry: Boolean);

var
  E: TClassPropertyEntry;
  ReadProc, WriteProc, Params: String;

function ActualParams: String;
var
  I: Integer;
  ch: Char;
  Skip: Boolean;
begin
  result := '';
  Skip := false;
  for I:=1 to Length(Params) do
  begin
    ch := Params[I];
    case ch of
      ';':
      begin
        result := result + ',';
        Skip := false;
      end;
      ':':
      begin
        Skip := true;
      end;
    else
    if not Skip then
      result := result + ch;
    end;
  end;

  I := Pos('CONST ', UpperCase(result));
  while I > 0 do
  begin
    Delete(result, I, 6);
    I := Pos('CONST ', UpperCase(result));
  end;
end;

{
function AddReadProc: Boolean;
var
  S: String;
begin
  result := true;

  ReadProc := CurrentClass + '_Get' + E.Name;

  if Params = '' then
    S := 'function ' + ReadProc + ':' + E.TypeName + ';'
  else
  begin
    result := Pos(':', Params) > 0;
    S := 'function ' + ReadProc + '(' + Params + '):' + E.TypeName + ';';
  end;

  if not result then
    Exit;

  AddLine('RegisterMethod(' + CurrentClass + ',');
  AddLine(Space(5) + StringConst(S) + ',');
  AddLine(Space(5) + '@' + ReadProc + ', Fake);');

  ExtraCode.Add(S);
  ExtraCode.Add('begin');
  S := 'result := ' + CurrentClass + '(_Self).' + E.Name;
  if Params <> '' then
    S := S + '[' + ActualParams + ']';
  S := S + ';';
  ExtraCode.Add(Space(DeltaMargin) + S);
  ExtraCode.Add('end;');
end;
}

function AddReadProc: Boolean;
var
  S: String;
begin
  result := true;

  ReadProc := CurrentClass + '__Get' + E.Name;

  if Params = '' then
    S := 'function ' + ReadProc + '(Self:' + CurrentClass +  '):' +
          E.TypeName + ';'
  else
  begin
    result := Pos(':', Params) > 0;
    S := 'function ' + ReadProc + '(Self:' + CurrentClass + ';' +
             Params + '):' + E.TypeName + ';';
  end;

  if not result then
    Exit;

  AddLine('RegisterMethod(' + CurrentClass + ',');
  AddLine(Space(5) + StringConst(S) + ',');

  if UserData = '' then
    AddLine(Space(5) + '@' + ReadProc + ', true);')
  else
    AddLine(Space(5) + '@' + ReadProc + ', true, ' + UserData + ');');

  ExtraCode.Add(S);
  ExtraCode.Add('begin');
  S := 'result := Self.' + E.Name;
  if Params <> '' then
    S := S + '[' + ActualParams + ']';
  S := S + ';';
  ExtraCode.Add(Space(DeltaMargin) + S);
  ExtraCode.Add('end;');
end;

{
function AddWriteProc: Boolean;
var
  S: String;
begin
  result := true;

  WriteProc := CurrentClass + '_Put' + E.Name;
  S := 'procedure ' + WriteProc + '(' + Params;
  if Params <> '' then
  begin
    result := Pos(':', Params) > 0;
    S := S + ';';
  end;

  if not result then
    Exit;

  S := S + 'const Value: ' + E.TypeName + ');';

  AddLine('RegisterMethod(' + CurrentClass + ',');
  AddLine(Space(5) + StringConst(S) + ',');
  AddLine(Space(5) + '@' + WriteProc + ', Fake);');

  ExtraCode.Add(S);
  ExtraCode.Add('begin');
  S := CurrentClass + '(_Self).' + E.Name;
  if Params <> '' then
    S := S + '[' + ActualParams + ']';
  S := S + ' := Value;';
  ExtraCode.Add(Space(DeltaMargin) + S);
  ExtraCode.Add('end;');
end;
}

function AddWriteProc: Boolean;
var
  S: String;
begin
  result := true;

  WriteProc := CurrentClass + '__Put' + E.Name;
  S := 'procedure ' + WriteProc + '(Self:' + CurrentClass + ';' + Params;
  if Params <> '' then
  begin
    result := Pos(':', Params) > 0;
    S := S + ';';
  end;

  if not result then
    Exit;

  S := S + 'const Value: ' + E.TypeName + ');';

  AddLine('RegisterMethod(' + CurrentClass + ',');
  AddLine(Space(5) + StringConst(S) + ',');

  if UserData = '' then
    AddLine(Space(5) + '@' + WriteProc + ', true);')
  else
    AddLine(Space(5) + '@' + WriteProc + ', true, ' + UserData + ');');

  ExtraCode.Add(S);
  ExtraCode.Add('begin');
  S := 'Self.' + E.Name;
  if Params <> '' then
    S := S + '[' + ActualParams + ']';
  S := S + ' := Value;';
  ExtraCode.Add(Space(DeltaMargin) + S);
  ExtraCode.Add('end;');
end;

var
  S: String;
  P1, P2: Integer;
  result: Boolean;
begin
  EndOfUsesClause;

  if CurrentClass = '' then
    Exit;

  E := TClassPropertyEntry(aEntry);

  if E.IsEvent then
    Exit;

  if Pos('On', E.Name) = 1 then
    Exit;

  if body = bInterface then
  begin
    if UserData = '' then
      AddLine('RegisterInterfaceProperty(' + CurrentClass + ',' + StringConst(E.Declaration) + ');')
    else
      AddLine('RegisterInterfaceProperty(' + CurrentClass + ',' + StringConst(E.Declaration) + ', ' + UserData + ');');
    Exit;
  end;

  ReadProc := '';
  WriteProc := '';
  Params := '';

  P1 := Pos('[', E.Declaration);
  P2 := Pos(']', E.Declaration);
  if P2 > P1 then
    Params := Copy(E.Declaration, P1 + 1, P2 - P1 - 1);

  result := true;

  if Pos(' read ', E.Declaration) > 0 then
    result := result and AddReadProc;

  if Pos(' write ', E.Declaration) > 0 then
    result := result and AddWriteProc;

  if (ReadProc = '') and (WriteProc = '') then
    Exit;

  if not result then
    Exit;

  AddLine('RegisterProperty(' + CurrentClass + ',');

  S := 'property ' + E.Name;
  if Params <> '' then
    S := S + '[' + Params + ']';
  S := S + ':' + E.TypeName;
  if ReadProc <> '' then
    S := S + ' read ' + ReadProc;
  if WriteProc <> '' then
    S := S + ' write ' + WriteProc;
  S := S + ';';
  if E.ArrayIsDefaultProperty then
    S := S + 'default;';

  if UserData = '' then
    AddLine(Space(5) + StringConst(S) + ');')
  else
    AddLine(Space(5) + StringConst(S) + ', ' + UserData + ');')
end;

procedure TForm1.WDelphiParser1EndOfClassDef(var aStopAnalyze: Boolean);
begin
  EndOfUsesClause;

  if CurrentClass = '' then
    Exit;

  EndOfClass;
  body := bNone;
end;

procedure TForm1.WDelphiParser1EndOfInterfaceDef(var aStopAnalyze: Boolean);
begin
  EndOfUsesClause;

  if CurrentClass = '' then
    Exit;

  EndOfClass;
  body := bNone;
end;

//---------- Initialization ------------------//

procedure TForm1.WDelphiParser1AfterUnitEntry(aFileName: String);
begin
  EndOfUsesClause;

  Blockquote(false);

  if RadioButton1.Checked then
  begin
    AddLine('end;');
    AddLine('initialization');
    AddLine('  Register' + UnitName + ';');
    AddLine('end.');
  end
  else if RadioButton2.Checked then
  begin
    AddLine('end;');
    AddLine('end;');
    AddLine('exports');
    AddLine('  RegisterDllProcs;');
    AddLine('begin');
    AddLine('end.');
  end;
end;

procedure TForm1.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  S: String;
begin
  if Key = vk_F1 then
    if ListBox1.ItemIndex >= 0 then
    begin
      S := ListBox1.Items[ListBox1.ItemIndex];
      S := Copy(S, 1, Pos(':', S) - 1);
      ShowMessage('Importer was not able to determine constructor of class ' + S + '.'#13#10 +
                  'To have possibility to create instances of class ' + S + 'in a script'#13#10 +
                  'you should update imp file manually. For example:'#13#10 +
                  'RegisterMethod(TMyClass, ''''constructor Create;'''', @TMyClass.Create)');
    end;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
var
  S: String;
begin
  if ListBox1.ItemIndex >= 0 then
  begin
    S := ListBox1.Items[ListBox1.ItemIndex];
    S := Copy(S, 1, Pos(':', S) - 1);
    ShowMessage('Importer was not able to determine constructor of class ' + S + '.'#13#10 +
                'To have possibility to create instances of class ' + S + 'in a script'#13#10 +
                'you should update imp file manually. For example:'#13#10 +
                'RegisterMethod(TMyClass, ''''constructor Create;'''', @TMyClass.Create)');
  end;
end;


end.
