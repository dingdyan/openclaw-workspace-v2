unit LgUser;

interface

uses LgInterfaces, classes, ComObj;

type
  TLgUser = class(TInterfacedObject, ILgUser)
  private
    FName: string;
    FAge: integer;
    function GetName: string;
    function GetAge: integer;
    procedure SetName(const Value: string);
    procedure SetAge(const Value: integer);
    function Instance: TObject; stdcall;
  public
    constructor Create; overload;
    destructor Destroy; override;
    property Name: string read GetName write SetName;
    property Age: integer read GetAge write SetAge;
  end;

  TLgUserList = class(TInterfacedObject, ILgUserList)
  private
    FList: IInterfaceList;

  public
  constructor Create; overload;
    destructor Destroy; override;
    procedure Add(Value: ILgUser);
    procedure Clear; 
    function Get(Index: Integer): ILgUser;
    function GetCount: Integer;
    function IndexOf(Value: ILgUser): Integer;
    function Instance: TObject; stdcall;
    procedure Remove(Value: ILgUser);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: ILgUser read Get; default;
  end;

implementation

{ TLgUser }

constructor TLgUser.Create;
begin
   //inherited;
end;

destructor TLgUser.Destroy;
begin
  //inherited;
end;

function TLgUser.GetAge: integer;
begin
   Result := FAge;
end;

function TLgUser.GetName: string;
begin
   Result := FName;
end;

function TLgUser.Instance: TObject;
begin
  Result := self;
end;

procedure TLgUser.SetAge(const Value: integer);
begin
   FAge := Value;
end;

procedure TLgUser.SetName(const Value: string);
begin
   FName := Value;
end;

{ TLgUserList }

procedure TLgUserList.Add(Value: ILgUser);
begin
   FList.Add(Value);
end;

procedure TLgUserList.Clear;
begin
  FList.Clear;
end;

constructor TLgUserList.Create;
begin
  FList := TInterfaceList.Create;
end;

destructor TLgUserList.Destroy;
begin
  inherited;
end;

function TLgUserList.Get(Index: Integer): ILgUser;
begin
  Result := ILgUser(FList.Items[index]);
end;

function TLgUserList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TLgUserList.IndexOf(Value: ILgUser): Integer;
begin
  Result := FList.IndexOf(Value);
end;

function TLgUserList.Instance: TObject;
begin
  Result := self;
end;

procedure TLgUserList.Remove(Value: ILgUser);
begin
  FList.Remove(Value);
end;

end.
 