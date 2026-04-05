unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BASE_PARSER, PaxScripter, PaxPascal, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    PaxScripter1: TPaxScripter;
    PaxPascal1: TPaxPascal;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure PaxScripter1AssignScript(Sender: TPaxScripter);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    I1, I2: Integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  K: Integer = 0;
procedure TForm1.Button1Click(Sender: TObject);
begin
  Inc(K);
  if K mod 2 = 1 then
  begin
    PaxScripter1.RegisterObject('B', Button1);
    PaxScripter1.RegisterVariable('I', 'Integer', @I1);
    PaxScripter1.RegisterConstant('C', 'abc');
  end
  else
  begin
    PaxScripter1.RegisterObject('B', Button2);
    PaxScripter1.RegisterVariable('I', 'Integer', @I2);
    PaxScripter1.RegisterConstant('C', 'pqr');
  end;
  PaxScripter1.Run();
end;

procedure TForm1.PaxScripter1AssignScript(Sender: TPaxScripter);
begin
  PaxScripter1.AddModule('1', 'paxPascal');
  PaxScripter1.AddCode('1', 'print B.Caption, I, C;');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  I1 := 1;
  I2 := 2;
end;

end.
 