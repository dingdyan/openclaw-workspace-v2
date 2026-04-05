unit TestRecords1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BASE_PARSER, PaxScripter, PaxPascal, StdCtrls;

type

  TMyPoint = record
    X, Y: Integer;
  end;

  TForm1 = class(TForm)
    Button1: TButton;
    PaxScripter1: TPaxScripter;
    PaxPascal1: TPaxPascal;
    procedure PaxScripter1AssignScript(Sender: TPaxScripter);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    R: TMyPoint;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TestRecord(P: TMyPoint): TMyPoint;
begin
  Inc(P.X);
  Inc(P.Y);
  result := P;
end;

procedure TForm1.PaxScripter1AssignScript(Sender: TPaxScripter);
begin
  PaxScripter1.AddModule('1', 'paxPascal');
  PaxScripter1.AddCode('1', 'var P, Q: TMyPoint;');
  PaxScripter1.AddCode('1', 'print R.X;');
  PaxScripter1.AddCode('1', 'print R.Y;');
  PaxScripter1.AddCode('1', 'R.Y := 500;');
  PaxScripter1.AddCode('1', 'Q := R;');
  PaxScripter1.AddCode('1', 'print Q.Y;');
  PaxScripter1.AddCode('1', 'Q.Y := 400;');
  PaxScripter1.AddCode('1', 'Q := TestRecord(R);');
  PaxScripter1.AddCode('1', 'print Q.X;');
  PaxScripter1.AddCode('1', 'print Q.Y;');
  PaxScripter1.AddCode('1', 'P := TestRecord(Q);');
  PaxScripter1.AddCode('1', 'print P.X;');
  PaxScripter1.AddCode('1', 'print P.Y;');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  H: Integer;
begin
  R.X := 10;
  R.Y := 20;
  H := RegisterRecordType('TMyPoint', SizeOf(TMyPoint));
  RegisterRecordField(H, 'X', 'Integer', 0);
  RegisterRecordField(H, 'Y', 'Integer', 4);
  RegisterRoutine('function TestRecord(P: TMyPoint): TMyPoint;', @TestRecord);
  RegisterVariable('R', 'TMyPoint', @R);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  PaxScripter1.Run;
  ShowMessage('R.Y=' + IntToStr(R.Y));
end;

end.
