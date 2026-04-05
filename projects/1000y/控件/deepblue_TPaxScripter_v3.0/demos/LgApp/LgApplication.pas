unit LgApplication;

interface
uses LgInterfaces, ComObj;

type
  TLgApplication = class (TInterfacedObject, ILgApplication)
  private
    FVersion: string;
    FUserList : ILgUserList;
  public
    constructor Create; overload;
    destructor Destroy; override;
    function GetVersion: string;
    function GetUserList: ILgUserList;
    procedure SetVersion(const Value: string);
    procedure SetUserList(const Value: ILgUserList);
    function Instance: TObject; stdcall;
    property Version: string read GetVersion write SetVersion;
    property UserList: ILgUserList read GetUserList write SetUserList;
published

  end;

  implementation

  uses LgUser;

{ TLgApplication }

constructor TLgApplication.Create;
begin
  //inherited;
  FUserList := TLgUserList.Create;
  FVersion := '0.1';
end;

destructor TLgApplication.Destroy;
begin
  inherited;
end;

function TLgApplication.GetUserList: ILgUserList;
begin
   Result := FUserList;
end;

function TLgApplication.GetVersion: string;
begin
    Result := FVersion;
end;

function TLgApplication.Instance: TObject;
begin
  Result := self;
end;

procedure TLgApplication.SetUserList(const Value: ILgUserList);
begin
   FUserList := Value;
end;

procedure TLgApplication.SetVersion(const Value: string);
begin
   FVersion := Value;
end;

end.
