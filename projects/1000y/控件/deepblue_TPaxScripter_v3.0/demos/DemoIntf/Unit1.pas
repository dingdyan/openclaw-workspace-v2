unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, BASE_SYS, BASE_PARSER, PaxScripter, PaxPascal, StdCtrls,

  Intf, IMP_Intf;

type
  TForm1 = class(TForm)
    Button1: TButton;
    PaxScripter1: TPaxScripter;
    PaxPascal1: TPaxPascal;
    procedure Button1Click(Sender: TObject);
    procedure PaxScripter1AssignScript(Sender: TPaxScripter);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    hostobj: ITest;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  IMP_SysUtils;

procedure GetIntf(out Obj: ITest);
begin
  obj := TTest.Create;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  hostobj := TTest.Create;
  PaxScripter1.Run;
end;

procedure TForm1.PaxScripter1AssignScript(Sender: TPaxScripter);
begin
  Sender.AddModule('1', 'paxPascal');
  Sender.AddCode('1', 'uses SysUtils, Intf;');
  Sender.AddCode('1', 'var I: ITest;');
  Sender.AddCode('1', 'var X: TTest;');

  Sender.AddCode('1', 'procedure P;');
  Sender.AddCode('1', 'var L: ITest;');
  Sender.AddCode('1', 'begin');
  Sender.AddCode('1', '  hostobj.QueryInterface(IUnknown, L);');
  Sender.AddCode('1', '  print "RefCount = " + IntToStr(IntfRefCount(hostobj));');
  Sender.AddCode('1', '  print "RefCount = " + IntToStr(IntfRefCount(L));');
  Sender.AddCode('1', '  hostobj.Proc();'); // call Proc via imported interface variable
  Sender.AddCode('1', '  hostobj := nil;');
  Sender.AddCode('1', '  print "RefCount = " + IntToStr(IntfRefCount(L));');
  Sender.AddCode('1', 'end;');
  Sender.AddCode('1', 'P();');

  Sender.AddCode('1', 'X := TTest.Create;');
  Sender.AddCode('1', 'if X.GetInterface(ITest, I) then'); // get interface via guid
  Sender.AddCode('1', 'begin');
  Sender.AddCode('1', '  print "RefCount = " + IntToStr(IntfRefCount(I));');
  Sender.AddCode('1', '  I.Proc();');
  Sender.AddCode('1', '  I.Proc(10);');
  Sender.AddCode('1', '  I.Proc2();');
  Sender.AddCode('1', '  I.Prop := "pqr";'); // put property
  Sender.AddCode('1', '  print I.Prop;'); // get property
  Sender.AddCode('1', 'end;');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PaxScripter1.RegisterInterfaceVar('hostobj', @ hostobj, ITest);
end;

initialization

RegisterRoutine('procedure GetIntf(out obj: ITest);', @GetIntf);

end.
