unit CodeExplorer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,
  contnrs, BASE_SYS,
  PaxScripter, PaxPascal, BASE_PARSER;
type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    TreeView1: TTreeView;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    PaxScripter1: TPaxScripter;
    PaxPascal1: TPaxPascal;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
  private
    { Private declarations }
    Module: Integer;
    PosList: TObjectList;
    procedure EnumProc(const Name: String;
                       ID: Integer;
                       Kind: TPAXMemberKind;
                       ml: TPAXModifierList;
                       Data: Pointer);
     procedure SetupClassNode(N: TTreeNode; ID: Integer);
     procedure SetupFuncNode(N: TTreeNode; ID: Integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

type
  PNodeRec = ^TNodeRec;
  TNodeRec = record
    NParams, NFields, NConsts, NMethods, NProperties, NClasses,
    NStructures, NEnums: TTreeNode;
  end;

  TPosObject = class
    Module, Position, Length: Integer;
    constructor Create(Module, Position, Length: Integer);
  end;

constructor TPosObject.Create(Module, Position, Length: Integer);
begin
  Self.Module := Module;
  Self.Position := Position;
  Self.Length := Length;
end;

procedure TForm1.SetupClassNode(N: TTreeNode; ID: Integer);
var
  R: TNodeRec;
begin
  with TreeView1.Items do
  begin
    with R do
    begin
      NConsts := AddChild(N, 'Constants');
      NFields := AddChild(N, 'Fields');
      NMethods := AddChild(N, 'Methods');
      NProperties := AddChild(N, 'Properties');
      NClasses := AddChild(N, 'Classes');
      NStructures := AddChild(N, 'Structures');
      NEnums := AddChild(N, 'Enums');
    end;

    PaxScripter1.EnumMembers(ID, Module, EnumProc, @R);

    with R do
    begin
      if NConsts.Count = 0 then
        NConsts.Delete;
      if NFields.Count = 0 then
        NFields.Delete;
      if NMethods.Count = 0 then
        NMethods.Delete;
      if NProperties.Count = 0 then
        NProperties.Delete;
      if NClasses.Count = 0 then
        NClasses.Delete;
      if NStructures.Count = 0 then
        NStructures.Delete;
      if NEnums.Count = 0 then
        NEnums.Delete;
    end;
  end;
end;

procedure TForm1.SetupFuncNode(N: TTreeNode; ID: Integer);
var
  R: TNodeRec;
begin
  with TreeView1.Items do
  begin
    with R do
    begin
      NParams := AddChild(N, 'Parameters');
      NConsts := AddChild(N, 'Constants');
      NFields := AddChild(N, 'Local variables');
      NMethods := AddChild(N, 'Routines');
      NClasses := AddChild(N, 'Classes');
      NStructures := AddChild(N, 'Structures');
      NEnums := AddChild(N, 'Enums');
    end;

    PaxScripter1.EnumMembers(ID, Module, EnumProc, @R);

    with R do
    begin
      if NParams.Count = 0 then
        NParams.Delete;
      if NConsts.Count = 0 then
        NConsts.Delete;
      if NFields.Count = 0 then
        NFields.Delete;
      if NMethods.Count = 0 then
        NMethods.Delete;
      if NClasses.Count = 0 then
        NClasses.Delete;
      if NStructures.Count = 0 then
        NStructures.Delete;
      if NEnums.Count = 0 then
        NEnums.Delete;
    end;
  end;
end;

procedure TForm1.EnumProc(const Name: String;
                          ID: Integer;
                          Kind: TPAXMemberKind;
                          ml: TPAXModifierList;
                          Data: Pointer);
var
  P: PNodeRec;
  TypeName: String;
  PosObject: TPosObject;
begin
  with PaxScripter1 do
    PosObject := TPosObject.Create(GetModule(ID),
                                   GetPosition(ID),
                                   Length(GetName(ID)));
  PosList.Add(PosObject);

  P := PNodeRec(Data);

  with PaxScripter1 do
    TypeName := GetName(GetTypeID(ID));

  with TreeView1.Items do
  case Kind of
    mkParam: AddChildObject(P^.NParams, Name + ': ' + TypeName, PosObject);
    mkField: AddChildObject(P^.NFields, Name + ': ' + TypeName, PosObject);
    mkMethod: SetupFuncNode(AddChildObject(P^.NMethods, Name, PosObject), ID);
    mkConst: AddChildObject(P^.NConsts, Name + ': ' + TypeName, PosObject);
    mkClass: SetupClassNode(AddChildObject(P^.NClasses, Name, PosObject), ID);
    mkStructure: SetupClassNode(AddChildObject(P^.NStructures, Name, PosObject), ID);
    mkEnum: SetupClassNode(AddChildObject(P^.NEnums, Name, PosObject), ID);
    mkProp: AddChildObject(P^.NProperties, Name  + ': ' + TypeName, PosObject);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  with OpenDialog1 do
  begin
    Filter := 'paxPascal (*' + '.pp' + '|*' + '.pp';
    if Execute then
    begin
      if Pos('.', FileName) = 0 then
        FileName := FileName + '.pp';
      Memo1.Lines.LoadFromFile(FileName);
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  PaxScripter1.ResetScripter;
  Module := PaxScripter1.AddModule('Main', 'paxPascal');
  PaxScripter1.AddCode('Main', Memo1.Lines.Text);
  PaxScripter1.Compile;
  with TreeView1.Items do
  begin
    Clear;
    SetupClassNode(Add(nil, 'Noname namespace'), PaxScripter1.GetRootID);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  S: String;
begin
  S := ExtractFileDir(Application.ExeName);
  SetCurrentDir(S);
  OpenDialog1.InitialDir := S;

  PosList := TObjectList.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  PosList.Free;
end;

procedure TForm1.TreeView1DblClick(Sender: TObject);
var
  N: TTreeNode;
  PosObject: TPosObject;
begin
  N := TTreeView(Sender).Selected;

  if N = nil then
    Exit;

  PosObject := TPosObject(N.Data);

  if PosObject <> nil then
    if PosObject.Module = Module then
      if PosObject.Position >= 0 then
    with Memo1 do
    begin
      SetFocus;
      SelStart := PosObject.Position;
      SelLength := PosObject.Length;
    end;
end;

procedure TForm1.TreeView1Click(Sender: TObject);
begin
  TreeView1DblClick(Sender);
end;

end.
