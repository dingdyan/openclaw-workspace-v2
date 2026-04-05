unit IMP_Intf;
interface
uses
  SysUtils,
  Classes,
  Dialogs,
  Intf,
  BASE_SYS,
  BASE_EXTERN,
  PaxScripter;
procedure RegisterIMP_Intf;
implementation
procedure TTest_Proc3(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
TTest(Self).Proc();
end;
procedure TTest_Proc4(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
TTest(Self).Proc(Params[0].AsInteger);
end;
procedure TTest_Proc2(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
TTest(Self).Proc2();
end;
function TTest__GetProp(Self:TTest):String;
begin
  result := Self.Prop;
end;
procedure TTest__PutProp(Self:TTest;const Value: String);
begin
  Self.Prop := Value;
end;
procedure RegisterIMP_Intf;
var H: Integer;
begin
  H := RegisterNamespace('Intf', -1);
  // Begin of interface ITest
  RegisterInterfaceType('ITest',ITest,'IUnknown',IUnknown,H);
  RegisterInterfaceMethod(ITest,
       'function GetProp: String;');
  RegisterInterfaceMethod(ITest,
       'procedure SetProp(Value: String);');
  RegisterInterfaceMethod(ITest,
       'procedure Proc; overload;');
  RegisterInterfaceMethod(ITest,
       'procedure Proc(A: Integer); overload;');
  RegisterInterfaceMethod(ITest,
       'procedure Proc2; cdecl;');
  RegisterInterfaceProperty(ITest,'property Prop: String read GetProp write SetProp;');
  // End of interface ITest
  // Begin of class TTest
  RegisterClassType(TTest, H);
  RegisterMethod(TTest,
       'constructor Create;',
       @TTest.Create);
  RegisterMethod(TTest,
       'destructor Destroy; override;',
       @TTest.Destroy);
  RegisterStdMethodEx(TTest,'Proc',TTest_Proc3,0,[typeVARIANT]);
  RegisterStdMethodEx(TTest,'Proc',TTest_Proc4,1,[typeINTEGER,typeVARIANT]);
  RegisterStdMethodEx(TTest,'Proc2',TTest_Proc2,0,[typeVARIANT]);
  RegisterMethod(TTest,
       'function TTest__GetProp(Self:TTest):String;',
       @TTest__GetProp, true);
  RegisterMethod(TTest,
       'procedure TTest__PutProp(Self:TTest;const Value: String);',
       @TTest__PutProp, true);
  RegisterProperty(TTest,
       'property Prop:String read TTest__GetProp write TTest__PutProp;');
  // End of class TTest
end;
initialization
  RegisterIMP_Intf;
end.
