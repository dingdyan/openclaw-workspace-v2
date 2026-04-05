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
    procedure Button1Click(Sender: TObject);
    function PaxScripter1VirtualObjectMethodCallEvent(Sender: TPaxScripter;
      const ObjectName, PropName: String;
      const Params: array of Variant): Variant;
    procedure PaxScripter1VirtualObjectPutPropertyEvent(
      Sender: TPaxScripter; const ObjectName, PropName: String;
      const Params: array of Variant; const Value: Variant);
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
  PaxScripter1.ResetScripter;
  PaxScripter1.RegisterVirtualObject('VObject');
  PaxScripter1.AddModule('1', 'paxPascal');
  PaxScripter1.AddCode('1', 'print VObject.Prop;');
  PaxScripter1.AddCode('1', 'VObject.Prop := 123;');
  PaxScripter1.AddCode('1', 'VObject.SomeProc(800, 900);');
  PaxScripter1.Run;
end;

function TForm1.PaxScripter1VirtualObjectMethodCallEvent(
  Sender: TPaxScripter; const ObjectName, PropName: String;
  const Params: array of Variant): Variant;
var
  I: Integer;
begin
  ShowMessage(ObjectName);
  ShowMessage(PropName);
  for I:=0 to Length(Params) - 1 do
    ShowMessage(VarToStr(Params[I]));
  result := 123;
end;

procedure TForm1.PaxScripter1VirtualObjectPutPropertyEvent(
  Sender: TPaxScripter; const ObjectName, PropName: String;
  const Params: array of Variant; const Value: Variant);
var
  I: Integer;
begin
  ShowMessage(ObjectName);
  ShowMessage(PropName);
  for I:=0 to Length(Params) - 1 do
    ShowMessage(VarToStr(Params[I]));
end;

end.
