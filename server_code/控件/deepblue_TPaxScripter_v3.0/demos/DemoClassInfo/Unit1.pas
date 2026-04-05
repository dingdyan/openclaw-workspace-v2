unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, TypInfo,
  Dialogs, BASE_PARSER, PaxScripter, PaxPascal, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    PaxScripter1: TPaxScripter;
    PaxPascal1: TPaxPascal;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    MemoScript: TMemo;
    ListBoxMethods: TListBox;
    ListBoxFields: TListBox;
    ListBoxProperties: TListBox;
    Label3: TLabel;
    ListBoxEvents: TListBox;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ListBoxMethodsDblClick(Sender: TObject);
    procedure ListBoxEventsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  IMP_StdCtrls, IMP_Controls, IMP_Forms;

procedure TForm1.Button1Click(Sender: TObject);
var
  S: String;
  L: TStrings;
begin
  PaxScripter1.ResetScripter;
  PaxScripter1.AddModule('1', 'paxPascal');
  PaxScripter1.AddCode('1', MemoScript.Lines.Text);
  PaxScripter1.Compile();

  S := Edit1.Text;

  L := ListBoxMethods.Items;
  L.Clear;
  PaxScripter1.GetClassInfo(S, mkMethod, L);
  ListBoxMethods.Invalidate;

  L := ListBoxFields.Items;
  L.Clear;
  PaxScripter1.GetClassInfo(S, mkField, L);
  ListBoxFields.Invalidate;

  L := ListBoxProperties.Items;
  L.Clear;
  PaxScripter1.GetClassInfo(S, mkProp, L);
  ListBoxProperties.Invalidate;

  L := ListBoxEvents.Items;
  L.Clear;
  PaxScripter1.GetClassInfo(S, mkEvent, L);
  ListBoxProperties.Invalidate;
end;

procedure TForm1.ListBoxMethodsDblClick(Sender: TObject);
var
  i, j, np, param_id: Integer;
  id: Integer;
  S: String;
begin
  for i := 0 to (ListBoxMethods.Items.Count - 1) do
    if ListBoxMethods.Selected[i] then
    begin
      id := Integer(ListBoxMethods.Items.Objects[i]);

      np := PaxScripter1.GetParamCount(id);

      S := 'Singnature=(';

      for j:=1 to np do
      begin
        S := S + PaxScripter1.GetParamTypeName(id, j);
        if j < np then
          S := S + ',';
      end;
      S := S + ')';

      ShowMessage(S);
    end;
end;

procedure TForm1.ListBoxEventsDblClick(Sender: TObject);


type
  TParamData = record
    Flags: TParamFlags;
    ParamName, TypeName: ShortString;
  end;
  PParamData = ^TParamData;

function ShiftPointer(P: Pointer; D: Integer): Pointer;
begin
  result := Pointer(Integer(P) + D);
end;

var
  i, j: Integer;
  S: String;
  C: TClass;
  pti: PTypeInfo;
  ptd: PTypeData;
  PropInfo: PPropInfo;
  prop_pti: PTypeInfo;
  ParamCount: Integer;
  PParam: PParamData;
  PTypeString: ^ShortString;
begin
  S := Edit1.Text;
  C := PaxScripter1.GetHostClass(S);
  if C = nil then
    Exit;
  pti := C.ClassInfo;
  if pti = nil then Exit;

  for i := 0 to (ListBoxEvents.Items.Count - 1) do
    if ListBoxEvents.Selected[i] then
    begin

      PropInfo := GetPropInfo(pti, ListBoxEvents.Items[i]);
      if PropInfo = nil then
        break;

      prop_Pti := PropInfo.PropType^;
      if prop_Pti = nil then
        break;

      ptd := GetTypeData(prop_pti);
      if ptd = nil then
        break;

      S := 'Type =' + prop_pti^.Name +   '. Singnature=(';

      ParamCount := ptd^.ParamCount;
      PParam := PParamData(@(ptd^.ParamList));
      for j:=0 to ParamCount - 1 do
      begin
        PTypeString := ShiftPointer(PParam, SizeOf(TParamFlags) + Length(PParam^.ParamName) + 1);
        S := S + PTypeString^;
        PParam := ShiftPointer(PTypeString, Length(PTypeString^) + 1);
        if j < ParamCount - 1 then
          S := S + ',';
      end;
      S := S + ')';

      ShowMessage(S);
    end;
end;

end.
