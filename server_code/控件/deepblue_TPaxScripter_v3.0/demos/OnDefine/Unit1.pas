unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, BASE_PARSER, PaxScripter, PaxPascal, PaxDfm,
  IMP_Classes, IMP_Controls, IMP_Graphics, IMP_StdCtrls, IMP_Forms;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    PaxScripter1: TPaxScripter;
    PaxPascal1: TPaxPascal;
    PaxDfmConverter1: TPaxDfmConverter;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure PaxScripter1Define(Sender: TPaxScripter; const S: String);
    procedure PaxScripter1UsedModule(const UsedModuleName,
      FileName: String; var SourceCode: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  PaxScripter1.ResetScripter;
  PaxScripter1.AddModule('1', 'paxPascal');

  PaxScripter1.AddCode('1', '{$define Unit2.dfm}');
  PaxScripter1.AddCode('1', 'program Test;');
  PaxScripter1.AddCode('1', 'uses');
  PaxScripter1.AddCode('1', '  Unit2;');
  PaxScripter1.AddCode('1', 'begin');
  PaxScripter1.AddCode('1', '  Form2 := TForm2.Create(nil);');
  PaxScripter1.AddCode('1', '  Form2.Show;');
  PaxScripter1.AddCode('1', 'end.');

  PaxScripter1.Run();
end;

procedure TForm1.PaxScripter1Define(Sender: TPaxScripter; const S: String);
begin
  if Sender.ScripterState = ssCompiling then
  begin
     with PaxDfmConverter1.UsedUnits do
     begin
       Add('Controls');
       Add('StdCtrls');
       Add('Graphics');
       Add('Forms');
     end;
    Memo1.Lines.Clear;
    PaxDfmConverter1.Parse(S, Memo1.Lines, true);
  end
  else if Sender.ScripterState = ssRunning then
  begin
    // nothing
  end;
end;

procedure TForm1.PaxScripter1UsedModule(const UsedModuleName,
  FileName: String; var SourceCode: String);
begin
  if UsedModuleName = 'Unit2' then
    SourceCode := Memo1.Lines.Text;
end;

end.
