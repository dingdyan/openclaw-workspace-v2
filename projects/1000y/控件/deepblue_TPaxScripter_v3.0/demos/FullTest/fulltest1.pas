{$O-}
unit fulltest1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PaxScripter,paxPascal
{$IFDEF VER150}
  ,variants,varutils
  {$ENDIF};

type

{$M+}
  tnewobj=class
  private
   fname:string;
  published
   property name:string read fname write fname;
  end;
{$M-}

  TForm1 = class(TForm)
    Button1: TButton;
    Memo2: TMemo;
    cbShowOk: TCheckBox;
    cbAuto: TCheckBox;
    Button2: TButton;
    cbStop: TCheckBox;
    cbExcept: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    fvar,v,r: Variant;
    p:TPaxScripter;
    failcount:integer;
    Fobj1:tnewobj;
    FThreadCount:integer;
    procedure doOnPrint(Sender: TPaxScripter; const L: string);
    procedure doOnError(Sender: TPaxScripter);
    procedure say(a: variant);
    procedure testglobals;
    procedure simpleparam;
    procedure check(cond: boolean; msg: String);
    procedure arrayParam;
    procedure hostAccess;
    function myfunc(a:string):string;
    function myfunc2(a:variant):variant;
    function myfunc3(a:variant):variant;
    procedure myException;
    function _test(script: string; const params: array of const): variant;
    function  test(script:string;
                   const params:array of const):variant;
    procedure exceptions;
  public
    procedure automation;
  published
    property var1: variant read fvar write fvar;
    property obj1:TnewObj read Fobj1;
  end;

var
  Form1: TForm1;

implementation

uses
  ComObj,
  ActiveX,
  IMP_ActiveX;

{$R *.DFM}

type

TMythread=class(TThread)
 private
 protected
   p:TPaxScripter;
   lang:tPaxLanguage;
  procedure execute; override;
 public
  constructor create;
  destructor destroy; override;
end;


{ TMythread }

constructor TMythread.create;
begin
 inherited create(true);
 FreeOnTerminate:=true;
 interlockedIncrement(form1.FThreadCount);
 resume;
end;

destructor TMythread.destroy;
begin
 interlockedDecrement(form1.FThreadCount);
 inherited;
end;

procedure TMythread.execute;
begin
 while not form1.cbStop.Checked do
  try
   p:=tPaxScripter.Create(nil);
   lang:=tpaxPascal.create(nil);
   try
    p.RegisterLanguage(lang);
    p.AddModule('1',lang.LanguageName);
    p.AddCode('1','function f; begin {sleep(random(10));} result:=form1.myfunc("pa"); end;');
//    p.AddCode('1','function f; begin {sleep(random(10));} result:=form1.myfunc2(100); end;');
    P.RegisterObject('Form1', form1);
    p.run;
    if p.IsError then raise exception.create(p.ErrorDescription);
    p.CallFunction('f',[]);
    if p.IsError then raise exception.create(p.ErrorDescription);
   finally
    p.UnregisterLanguage(lang.LanguageName);
    freeAndNil(lang);
    freeandnil(p);
   end;
  except
   Application.HandleException(self);
   terminate;
   break;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 registerclasstype(tnewobj,-1);
 registerclassType(tform1,-1);
 registerMethod(tform1,'function myfunc(a:string):string;',@tform1.myfunc);
 registerMethod(tform1,'function myfunc2(a: variant): variant;',@tform1.myfunc2);
 registerMethod(tform1,'function myfunc3(a: variant): variant;',@tform1.myfunc3);
 registerMethod(tform1,'procedure MyException;',@tform1.myException);
 registerRoutine('procedure sleep(ms:integer); stdcall;',@sleep);
 fobj1:=tnewobj.create;
end;

procedure TForm1.doOnPrint(Sender: TPaxScripter; const L: string);
begin
 memo2.lines.Add(L);
end;

procedure tform1.say(a:variant);
begin
 memo2.lines.add(string(a));
end;

procedure tform1.check(cond:boolean; msg:String);
begin
 if cond then if cbshowok.checked then say(msg+' ok') else
 else
  begin
   say(msg+' failed');
   inc(failCount)
  end;
end;

function TForm1._test(script: string; const params: array of const): variant;
begin
 p.ResetScripter;
 P.AddModule('1', 'paxPascal');
 P.AddCode('1',script);
 p.run;
 result:=p.CallFunction('f',params);
end;

function TForm1.test(script: string;
  const params: array of const): variant;
begin
 try
  result:=_test(script,params);
 except
  say(exception(exceptObject).Message);
  result:=unassigned;
 end;
end;

procedure tform1.testglobals;
begin
 test('var a; function f; begin a:="global"; end;',[]);
 v:=p.Values['a'];
 check(v='global','read global');
 p.Values['a']:='global changed';
 check(p.Values['a']='global changed','write global');
end;

procedure tform1.simpleparam;
 var t:dword;


 procedure test1(msg:string; v1:variant);
 begin
  r:=test('function f(a); begin print(a); result:=a; end;',
          [v1]);
  check(r=v1,msg);
 end;

 function getParam(fname:string; index:integer):variant;
  var subid,paramid:integer;
 begin
  SubID := p.GetMemberID(fname);
  if SubID = 0 then raise Exception.Create('Function not found');
  ParamID := p.GetParamID(SubID, index);
  result := p.GetValueByID(ParamID);
 end;

begin
 test1('integer',1000);
 test1('string','mike');
 test1('Date',now());
 test1('byte',1);
 test1('boolean',true);
 test1('double',1.23);
 v:=100;

 r:=test('function f(a); begin result:=a.caption; end;',[self]);
 check(r=caption,'Delphi Object parameter');
 t:=getTickCount;
 test('function f(a); begin sleep(a); end;',[1000]);
 t:=getTickcount-t;
// check((t>950) and (t<1050),'sleep called ok');
end;

procedure tform1.arrayParam;
begin
 v:=varArrayof([1,2,3]);
 r:=test('function f(a); begin result:=a; end;',
         [v]);
 check(r[1]=2,'array invariance');
 r:=test('function f(a); begin result:=a[1]; end;',
         [v]);
 check(r=2,'array access');

 v:=vararrayof([VarArrayof([1,2,3]),4,5]);
 r:=test('function f(a); var a1; begin a1:=a[0]; result:=a1[1]; end;',
         [v]);
 check(r=2,'nested array access');
 r:=test('function f(a); begin  result:=a[0][1]; end;',
         [v]);
 check(r=2,'nested array access2');

 r:=test('function f(a); begin result:=toInteger(a[0])+toInteger(a[1]); end;',
         [varArrayOf(['1','2'])]);
 check(r=3,'conversion of string parameters');

end;

procedure tform1.hostAccess;
begin
 fvar := VarArrayOf([1, 2, 3]);
 r:=test('function f; begin print(form1.var1); result:=form1.var1; end;',
         []);
 check(r[1]=2,'host access 1');
 r:=test('function f; begin print(form1.var1[1]); result:=form1.var1[1]; end;',
         []);
 check(r=2,'host access 2');

 fobj1.name:='mike';
 r:=test('function f; begin result:=form1.obj1.name; end;',[]);
 check(r='mike','class property');

 r:=test('function f; begin result:=form1.myfunc("pa"); end;',[]);
 check(r='papa','host function call');

 r:=test('function f; begin result:=form1.myfunc2(10); end;',[]);
 check(r=20,'host function call2');

 r:=test('function f(a); begin result:=form1.myfunc2(a[1]); end;',
  [vararrayof([1000,2000])]);
 check(r=2010,'host function call3');

 r:=test(
 'function f; var a = VarArrayCreate([0,1], varVariant); begin a[0]:=1; a[1]:=2;'#13#10+
 'result:=form1.myfunc3(a); end;',[]);
 check(r=3,'array parameter to host');

end;

procedure tform1.automation;
var fword:olevariant;
begin
 fword:=createoleobject('word.application');
 r:=test('function f(a); begin result:=a.path; end;',
         [fword]);
 fword.quit;
 check(pos('\',r)>0,'automation parameter');
end;

procedure tform1.exceptions;
 var ok:boolean;
begin
r:=test(
' function f;'#13#10+
'  begin'#13#10+
'   try'#13#10+
'    raise 100;'#13#10+
'    result:=1;'#13#10+
'   except'#13#10+
'    result:=2;'#13#10+
'   end;'#13#10+
'  end;',[]);
check(r=2,'simple exception handling');

try
 r:=_test(
 ' function f; begin raise 100; end;',[]);
 if p.IsError then
   raise Exception.Create(p.ErrorDescription);
 ok:=false;
except
 ok:=true;
end;
check(ok,'exception in script propagates to host');

r:=test(
' function f;'#13#10+
'  begin'#13#10+
'   try'#13#10+
'    form1.myException;'#13#10+
'    result:=1;'#13#10+
'   except'#13#10+
'    result:=2;'#13#10+
'   end;'#13#10+
'  end;',[]);
check(r=2, 'Exception from host is caught');

try
 r:=_test(
 ' function f; begin form1.myException; end;',[]);
  if p.IsError then
    raise Exception.Create(p.ErrorDescription);
 ok:=false;
except
 ok:=true;
end;
check(ok,'exception from host callback propagates to host');

try
 r:=_test(
 ' function f; begin form1.noSuchVariable; end;',[]);
  if p.IsError then
    raise Exception.Create(p.ErrorDescription);
 ok:=false;
except
 ok:=true;
end;
check(ok,'undefined identifier raises exception');

r:=test(
'function f; begin try result:=1; raise 100; finally result:=2; end; end;',
[]);
check(r=2,'finally works');

end;

procedure TForm1.Button1Click(Sender: TObject);
var lang:tPaxLanguage;
begin
  p:=tPaxScripter.Create(nil);
  lang:=tpaxPascal.create(nil);
  p.RegisterLanguage(lang);
  try
   failcount:=0;
   p.OnPrint:=DoOnPrint;
   p.OnShowError:=doOnError;
   P.RegisterObject('Form1', self);
   memo2.clear;

   testglobals;
   simpleparam;
   ArrayParam;
   hostAccess;

   if cbauto.checked then automation;
   if cbexcept.checked then exceptions;
  finally
   p.UnregisterLanguage(lang.LanguageName);
   freeAndNil(lang);
   freeandnil(p);
   if failcount>0 then say(format('%d failures!',[failcount]))
   else say('congatulations');
  end;
end;

function TForm1.myfunc(a: string): string;
begin
 result:=a+a;
end;

function TForm1.myfunc2(a: variant): variant;
begin
 result:=integer(a)+10;
end;

procedure TForm1.myException;
begin
 raise exception.create('exception from host');
end;

procedure TForm1.doOnError(Sender: TPaxScripter);
begin
 say('error from script');
end;

function TForm1.myfunc3(a: variant): variant;
begin
 result:=a[0]+a[1];
end;

procedure TForm1.Button2Click(Sender: TObject);
var i:integer;
begin
 say('Threads started');
 cbstop.Checked:=false;
 for i:=1 to 100 do tmythread.create;
 while fthreadcount>0 do application.processMessages;
 say('Threads finished');
end;

end.

