unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PaxScripter, StdCtrls, PaxBasic;

type
  TForm1 = class(TForm)
    Button1: TButton;
    PaxBasic1: TPaxBasic;
    PaxScripter1: TPaxScripter;
    procedure Button1Click(Sender: TObject);
    procedure PaxScripter1AssignScript(Sender: TPaxScripter);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  PaxScripter1.Run;
end;

procedure TForm1.PaxScripter1AssignScript(Sender: TPaxScripter);
begin
  Sender.RegisterObject('Form1', Self);
  Sender.AddModule('main', 'paxBasic');
  Sender.AddCode('main', 'print Form1.Button1.Caption');
end;

end.
