unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PaxScripter, PaxBasic, BASE_PARSER;

type
  TForm2 = class(TForm)
    Button1: TButton;
    PaxScripter1: TPaxScripter;
    Button2: TButton;
    PaxScripter2: TPaxScripter;
    PaxBasic1: TPaxBasic;
    procedure Button1Click(Sender: TObject);
    procedure PaxScripter1AssignScript(Sender: TPaxScripter);
    procedure PaxScripter2AssignScript(Sender: TPaxScripter);
    procedure Button2Click(Sender: TObject);
    procedure PaxScripter1Running(Sender: TPaxScripter; N: Integer;
      var Handled: Boolean);
    procedure PaxScripter2Running(Sender: TPaxScripter; N: Integer;
      var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TMyThread = class(TThread)
    S: TPAXScripter;
    constructor Create(S: TPAXScripter);
    procedure Execute; override;
  end;

var
  Form2: TForm2;

implementation

uses
  IMP_Pascal, IMP_Basic, IMP_SysUtils, IMP_ExtCtrls, IMP_Controls, IMP_Graphics, IMP_Forms;

{$R *.DFM}

constructor TMyThread.Create(S: TPAXScripter);
begin
  Self.S := S;
  inherited Create(false);
end;

procedure TMyThread.Execute;
begin
  S.Run;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  if PaxScripter2.ScripterState in [ssRunning, ssPaused] then
    Exit;

  PaxScripter1.ResetScripter;
  TMyThread.Create(PaxScripter1);
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  if PaxScripter2.ScripterState in [ssRunning, ssPaused] then
    Exit;

  PaxScripter2.ResetScripter;
  TMyThread.Create(PaxScripter2);
end;

procedure TForm2.PaxScripter1AssignScript(Sender: TPaxScripter);
begin
  Sender.AddModule('main', 'paxBasic');
  Sender.AddCodeFromFile('main', 'script.txt');
end;

procedure TForm2.PaxScripter2AssignScript(Sender: TPaxScripter);
begin
  Sender.AddModule('main', 'paxBasic');
  Sender.AddCodeFromFile('main', 'script.txt');
end;

procedure TForm2.PaxScripter1Running(Sender: TPaxScripter; N: Integer;
  var Handled: Boolean);
begin
  Application.ProcessMessages;
end;

procedure TForm2.PaxScripter2Running(Sender: TPaxScripter; N: Integer;
  var Handled: Boolean);
begin
  Application.ProcessMessages;
end;

end.
