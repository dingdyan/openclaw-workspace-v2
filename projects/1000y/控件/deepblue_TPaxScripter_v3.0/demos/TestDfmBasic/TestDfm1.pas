unit TestDfm1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PaxDfm, StdCtrls, BASE_PARSER, PaxScripter, PaxPascal, PaxC, PaxBasic;

type
  TForm1 = class(TForm)
    PaxDfmConverter1: TPaxDfmConverter;
    Button1: TButton;
    PaxScripter1: TPaxScripter;
    Memo1: TMemo;
    Button2: TButton;
    Label1: TLabel;
    PaxBasic1: TPaxBasic;
    procedure Button1Click(Sender: TObject);
    procedure PaxScripter1AssignScript(Sender: TPaxScripter);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  TestDfm2,
  IMP_Controls, IMP_Graphics, IMP_StdCtrls, IMP_Forms;

procedure TForm1.Button1Click(Sender: TObject);
begin
  PaxScripter1.Run;
end;

procedure TForm1.PaxScripter1AssignScript(Sender: TPaxScripter);
var
  L: TStringList;
begin

// Create script from a dfm file

  L := TStringList.Create;
  try
    with PaxDfmConverter1.UsedUnits do
    begin
      Add('Controls');
      Add('StdCtrls');
      Add('Graphics');
      Add('Forms');
    end;

    PaxDfmConverter1.Parse('TestDfm2.dfm', L, 'paxBasic');
    PaxScripter1.AddModule('1', 'paxBasic');
    PaxScripter1.AddCode('1', L.Text);
  finally
    L.Free;
  end;

// Create new script-defined instance and assign event handler

  with PaxScripter1 do
  begin
    AddCode('1', 'Imports TestDfm2'#13#10);
    AddCode('1', 'Form2 = New TForm2(null)'#13#10);
    AddCode('1', 'Form2.Caption = "Generated form"'#13#10);
    AddCode('1', 'Form2.Button1.OnClick = AddressOf Handler'#13#10);
    AddCode('1', 'Form2.Show()'#13#10);

    AddCode('1', 'Sub Handler(Sender)'#13#10);
    AddCode('1', '  print "Hello from paxScript!"'#13#10);
    AddCode('1', 'End Sub');
  end;

// Show generated script

  Memo1.Lines.Text := PaxScripter1.SourceCode['1'];
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Form2.Caption := 'Delphi form';
  Form2.Show;
end;

end.
