program DemoRegField;

uses
  Forms,
  DemoRegField1 in 'DemoRegField1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
