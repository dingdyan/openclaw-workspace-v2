program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  LgInterfaces in 'LgInterfaces.pas',
  LgUser in 'LgUser.pas',
  LgApplication in 'LgApplication.pas',
  IMP_LgInterfaces in 'IMP_LgInterfaces.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
