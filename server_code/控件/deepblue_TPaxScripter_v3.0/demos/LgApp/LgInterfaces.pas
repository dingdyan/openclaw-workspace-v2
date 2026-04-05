unit LgInterfaces;

interface

type

  ITriInterface               = interface;
  ILgCoreInterface            = interface;
  ILgApplication              = interface;
  ILgUser                     = interface;
  ILgUserList                 = interface;


  ITriInterface = interface
  ['{2543184E-DCD3-431A-889B-D4396A53AF30}']
  end;

  ILgCoreInterface = interface(ITriInterface)
  ['{980DA63E-6A7F-4549-918B-4457F5E3D054}']
    function Instance: TObject; stdcall;
  end;

  ILgUser = interface (ILgCoreInterface)
  ['{B60463BF-7E9B-4C0C-92F2-27D6E7D793D2}']
    function GetName: string;
    function GetAge: integer;

    procedure SetName(const Value: string);
    procedure SetAge(const Value: integer);

    property Name: string read GetName write SetName;
    property Age: integer read GetAge write SetAge;
  end;

  ILgUserList = interface(ILgCoreInterface)
  ['{20819E1D-D453-4E8C-AD23-3D91AE1190E4}']
    procedure Add(Value: ILgUser);
    procedure Clear;
    function Get(Index: Integer): ILgUser; 
    function GetCount: Integer; 
    function IndexOf(Value: ILgUser): Integer; 
    procedure Remove(Value: ILgUser);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: ILgUser read Get; default;
  end;


  ILgApplication = interface(ILgCoreInterface)
  ['{BC20594A-3791-458A-BD92-00A225CCC4CF}']
    function GetVersion: string;
    function GetUserList: ILgUserList;
    procedure SetVersion(const Value: string); 
    procedure SetUserList(const Value: ILgUserList);
    property Version: string read GetVersion write SetVersion;
    property UserList: ILgUserList read GetUserList write SetUserList;
  end;

  implementation


end.
