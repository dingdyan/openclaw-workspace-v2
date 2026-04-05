unit DemoRegField1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, BASE_PARSER, PaxScripter, PaxPascal;

type
  TForm1 = class(TForm)
    Button1: TButton;
    PaxScripter1: TPaxScripter;
    PaxPascal1: TPaxPascal;
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

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  PaxScripter1.Run;
end;

procedure TForm1.PaxScripter1AssignScript(Sender: TPaxScripter);
begin
  PaxScripter1.AddModule('1', 'paxPascal');
  PaxScripter1.AddCode('1', 'var X: TMyClass;');
  PaxScripter1.AddCode('1', 'X := TMyClass.Create;');
  PaxScripter1.AddCode('1', 'print X.F1;');
  PaxScripter1.AddCode('1', 'print X.F2;');
  PaxScripter1.AddCode('1', 'X.F1 := 200;');
  PaxScripter1.AddCode('1', 'X.F2 := "pqr";');
  PaxScripter1.AddCode('1', 'print X.F1;');
  PaxScripter1.AddCode('1', 'print X.F2;');
  PaxScripter1.AddCode('1', 'print X.P1;');
  PaxScripter1.AddCode('1', 'X.P1 := 300;');
  PaxScripter1.AddCode('1', 'print X.P1;');
end;

type
  TMyClass = class
  private
    F1: Integer;
    F2: String;
  public
    constructor Create;
  end;

constructor TMyClass.Create;
begin
  F1 := 100;
  F2 := 'abc';
end;

initialization
  RegisterClassType(TMyClass);
  RegisterMethod(TMyClass, 'constructor Create;', @TMyClass.Create);
  RegisterField(TMyClass, 'F1', 'Integer', Integer(@TMyClass(nil).F1));
  RegisterField(TMyClass, 'F2', 'String', Integer(@TMyClass(nil).F2));
  RegisterProperty(TMyClass, 'property P1: Integer read F1 write F1;'); 
end.
