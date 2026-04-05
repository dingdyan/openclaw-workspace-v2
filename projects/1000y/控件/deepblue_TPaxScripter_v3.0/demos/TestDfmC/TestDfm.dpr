program TestDfm;

uses
  Forms,
  TestDfm1 in 'TestDfm1.pas' {Form1},
  TestDfm2 in 'TestDfm2.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
