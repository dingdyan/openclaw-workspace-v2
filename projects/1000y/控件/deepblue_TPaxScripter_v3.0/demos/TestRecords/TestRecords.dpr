program TestRecords;

uses
  Forms,
  TestRecords1 in 'TestRecords1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
