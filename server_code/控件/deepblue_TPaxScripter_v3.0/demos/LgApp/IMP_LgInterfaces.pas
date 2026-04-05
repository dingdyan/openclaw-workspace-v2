unit IMP_LgInterfaces;
interface
uses
  LgInterfaces,
  BASE_SYS,
  BASE_EXTERN,
  PaxScripter;
procedure RegisterIMP_LgInterfaces;
implementation
procedure RegisterIMP_LgInterfaces;
var H: Integer;
begin
  H := RegisterNamespace('LgInterfaces', -1);

  // forward declaration
  RegisterInterfaceType('ITriInterface',ITriInterface,'IUnknown',IUnknown,H);
  RegisterInterfaceType('ILgCoreInterface',ILgCoreInterface,'ITriInterface',ITriInterface,H);
  RegisterInterfaceType('ILgUser',ILgUser,'ILgCoreInterface',ILgCoreInterface,H);
  RegisterInterfaceType('ILgUserList',ILgUserList,'ILgCoreInterface',ILgCoreInterface,H);
  RegisterInterfaceType('ILgApplication',ILgApplication,'ILgCoreInterface',ILgCoreInterface,H);

  // Begin of interface ILgCoreInterface
  RegisterInterfaceMethod(ILgCoreInterface,
       'function Instance: TObject; stdcall;');

  // Begin of interface ILgUser
  RegisterInterfaceMethod(ILgUser,
       'function GetName: string;');
  RegisterInterfaceMethod(ILgUser,
       'function GetAge: integer;');
  RegisterInterfaceMethod(ILgUser,
       'procedure SetName(const Value: string);');
  RegisterInterfaceMethod(ILgUser,
       'procedure SetAge(const Value: integer);');
  RegisterInterfaceProperty(ILgUser,'property Name: string read GetName write SetName;');
  RegisterInterfaceProperty(ILgUser,'property Age: integer read GetAge write SetAge;');

  // Begin of interface ILgUserList
  RegisterInterfaceMethod(ILgUserList,
       'procedure Add(Value: ILgUser);');
  RegisterInterfaceMethod(ILgUserList,
       'procedure Clear;');
  RegisterInterfaceMethod(ILgUserList,
       'function Get(Index: Integer): ILgUser;');
  RegisterInterfaceMethod(ILgUserList,
       'function GetCount: Integer;');
  RegisterInterfaceMethod(ILgUserList,
       'function IndexOf(Value: ILgUser): Integer;');
  RegisterInterfaceMethod(ILgUserList,
       'procedure Remove(Value: ILgUser);');
  RegisterInterfaceProperty(ILgUserList,'property Count: Integer read GetCount;');
  RegisterInterfaceProperty(ILgUserList,'property Items[Index: Integer]: ILgUser read Get; default;');

  // Begin of interface ILgApplication
  RegisterInterfaceMethod(ILgApplication,
       'function GetVersion: string;');
  RegisterInterfaceMethod(ILgApplication,
       'function GetUserList: ILgUserList;');
  RegisterInterfaceMethod(ILgApplication,
       'procedure SetVersion(const Value: string);');
  RegisterInterfaceMethod(ILgApplication,
       'procedure SetUserList(const Value: ILgUserList);');
  RegisterInterfaceProperty(ILgApplication,'property Version: string read GetVersion write SetVersion;');
  RegisterInterfaceProperty(ILgApplication,'property UserList: ILgUserList read GetUserList write SetUserList;');
end;
end.
