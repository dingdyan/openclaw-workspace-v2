unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BASE_PARSER, PaxScripter, PaxPascal, StdCtrls;

type
  TForm1 = class(TForm)
    PaxScripter1: TPaxScripter;
    PaxPascal1: TPaxPascal;
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  IMP_Classes, IMP_Controls, IMP_StdCtrls, IMP_Graphics, IMP_Forms;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  PaxScripter1.ResetScripter;
  PaxScripter1.AddModule('1', 'paxPascal');
  PaxScripter1.AddCode('1', 'uses Unit2;');
  PaxScripter1.AddCode('1', 'Form2 := TForm2.Create(nil);');
  PaxScripter1.AddCode('1', 'Form2.ShowModal();');
  PaxScripter1.Run();

  Memo1.Lines.Text := PaxScripter1.SourceCode['Unit2']; // show generated script
end;

end.
