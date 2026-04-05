program CodeExpl;

uses
  Forms,
  CodeExplorer in 'CodeExplorer.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
