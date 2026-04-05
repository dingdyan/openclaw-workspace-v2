unit Intf;
interface
uses
  SysUtils, Classes, Dialogs;

type
  ITest = interface
  ['{E7AA427A-0F4D-4A96-A914-FAB1CA336337}']
    function GetProp: String;
    procedure SetProp(Value: String);
    procedure Proc; overload;
    procedure Proc(A: Integer); overload;
    procedure Proc2; cdecl;
    property Prop: String read GetProp write SetProp;
  end;

  TTest = class(TInterfacedObject, ITest)
  private
    fStr: String;
    function GetProp: String;
    procedure SetProp(Value: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Proc; overload;
    procedure Proc(A: Integer); overload;
    procedure Proc2; cdecl;
    property Prop: String read GetProp write SetProp;
  end;


implementation

function TTest.GetProp: String;
begin
  result := fStr;
end;

procedure TTest.SetProp(Value: String);
begin
  fStr := Value;
end;

procedure TTest.Proc;
begin
  ShowMessage(fstr);
end;

procedure TTest.Proc(A: Integer);
begin
  ShowMessage(IntToStr(A));
end;

procedure TTest.Proc2;
begin
  ShowMessage('2');
end;

constructor TTest.Create;
begin
  fStr := 'abc';
end;

destructor TTest.Destroy;
begin
  ShowMessage('Done');
  inherited;
end;

end.
