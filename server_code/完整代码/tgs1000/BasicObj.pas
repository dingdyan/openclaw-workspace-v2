unit BasicObj;
{
TItemObject = class(TBasicObject)
TGateObject = class(TBasicObject) //传送
TMirrorObject = class(TBasicObject)
TStaticItem = class(TBasicObject)
TDynamicObject = class(TBasicObject)
}
interface

uses
  Windows, Classes, SysUtils, svClass, SubUtil, uAnsTick, //AnsUnit,
  FieldMsg, MapUnit, DefType, Autil32, uManager,
  uObjectEvent, PaxScripter;

type
  TEnmityclass = class;
  TBasicObject = class
  private
    FScriptClass: TPaxScripter; //=>procedure SetScript(aScript, afilename:string);
    FCreateTick: integer;
    FCreateX, FCreateY: integer;

    SayDelayTick: integer;
    SayDelayList: tstringlist;

    function GetPosx: integer;
    function GetPosy: integer;
    function GetFeatureState: TFeatureState;
  protected
    Fboice: boolean;
    FboRegisted: Boolean;
    FboAllowDelete: Boolean;
    FboHaveGuardPos: Boolean;

    FAlarmTick: Integer;

    function isRangeMessage(hfu: Longint; Msg: word; var SenderInfo: TBasicData): Boolean;
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; dynamic;
    function GetViewObjectById(aid: integer): TBasicObject;

    function GetViewObjectByName(aName: string; aRace: integer): TBasicObject;
    procedure Initial(aName, aViewName: string);
    procedure StartProcess; dynamic;
    procedure EndProcess; dynamic;

    procedure BocChangeFeature;

    procedure BoSysopMessage(astr: string; aSysopScope: integer);
  public
    function isHitedArea(adir, ax, ay: integer; afunc: byte; var apercent: integer): Boolean;

    function isHit(var aBasicData: TBasicData): Boolean;
    function isRange(xx, yy: word): Boolean;
    function isRangeWidth(xx, yy: word; awidth: word): Boolean;
    function isRangeWidthHeight(xx, yy: word; awidth, aHeight: word): Boolean;
    procedure SetManagerClass(aManager: TManager);
    function SendLocalMessage(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;

    procedure BocSay(astr: string);
    procedure LeftTextSay(hfu: integer; astr: string; acolor: integer);

    procedure ShowSound(asound: integer);
    procedure ShowMagicEffect(aEffectNumber: Word; aEffectKind: TLightEffectKind);
    procedure ShowEffect(aEffectNumber: Word; aEffectKind: TLightEffectKind);
    procedure SetScript(aScript, afilename: string);
    function CallScriptFunction(const Name: string; const Params: array of const): integer;

    procedure HIT_Screen(aHit: integer);
  public
    Manager: TManager; //=>ManagerList.Manager
    Maper: TMaper; //=>Manager.Maper
    Phone: TFieldPhone; //=>Manager.Phone
    ServerID: Integer; //=>Manager.ServerID

    BasicData: TBasicData; //基本 属性 资料
    ViewObjectList: TList; //可视 物体 列表

    EnmityList: TEnmityclass; //仇恨 列表

    MapPath: TMapPath;
    MapPathStep: integer; //计数



        //锁定一段时间 不能移动
    LockNotMoveTick: integer;
    LockNotMoveTime: integer;
    LockNotMoveState: boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Update(CurTick: integer); dynamic;
    procedure BocChangeProperty;

    function FindViewObject(aBasicObject: TBasicObject): Boolean;

    property PosX: integer read GetPosX;
    property PosY: integer read GetPosY;
    property CreateX: integer read FCreateX;
    property CreateY: integer read FCreateY;
    property CreateTick: integer read FCreateTick;
    property boAllowDelete: Boolean read FboAllowDelete write FboAllowDelete;
    property boRegisted: Boolean read FboRegisted;
    property State: TFeatureState read GetFeatureState;

    procedure LockNotMove(atime: integer);
    procedure SayDelayAdd(astr: string; atime: integer);
    procedure SayDelayClear;
  end;

    //仇恨管理
  TEnmityclass = class
  private

    FDCurTick: integer;
    fdata: tlist;
    procedure Clear();

    procedure del(aid: integer);
    function get(aid: integer): pTEnmitydata;
  public
    constructor Create;
    destructor Destroy; override;
    function add(aAttacker: integer; aname: string; atype: TEnmitydatatype; aEnmity: integer): pTEnmitydata;
    function Enmityadd(aid: integer; aEnmity: integer): boolean;
        //  procedure Enmitydec(aid:integer; aEnmity:integer);
        //  procedure EnmityClear(aid:integer);
    function getMaxEnmityAttacker(): TEnmitydata; //获取 仇恨最大的攻击者 ID
    function getListString(): string;
    procedure Update(CurTick: integer);
  end;
    //地上 物品
  TItemObject = class(TBasicObject)
  private
    SelfItemData: TItemData; //物品 完整属性
    OwnerId: Integer;
    boAllowPickup: Boolean;
  protected
    procedure Initial(aItemData: TItemData; aOwnerId, ax, ay: integer);
    procedure StartProcess; override;
    procedure EndProcess; override;
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update(CurTick: integer); override;

    property AllowPickUp: Boolean read boAllowPickup;
        //  function isItemOwner(aid, x, y :integer) :boolean;
  end;

  TItemList = class
  private
    Manager: TManager;
    CurProcessPos: integer;
    FDCurTick: integer;
    DataList: TList;
        // function  AllocFunction: pointer;
        // procedure FreeFunction (item: pointer);
    function GetCount: integer;
  public
    constructor Create(aManager: TManager);
    destructor Destroy; override;

    procedure AllClear;
    procedure AddItemObject(aItemData: TItemData; aOwnerId, ax, ay: integer);
    procedure Update(CurTick: integer);
    property Count: integer read GetCount;
  end;

  TGateObject = class(TBasicObject) //传送
  private
    SelfData: TCreateGateData;

    boActive: Boolean;
    RegenedTick: Integer;
    RemainHour, RemainMin, RemainSec: Word;
  protected
    procedure Initial;
    procedure StartProcess; override;
    procedure EndProcess; override;
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Update(CurTick: Integer); override;

    function GetSelfData: PTCreateGateData;
  end;

  TGateList = class
  private
    DataList: TList;

    function GetCount: integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure LoadFromFile(aFileName: string);

    procedure Update(CurTick: integer);

    procedure SetBSGateActive(boFlag: Boolean);
    function GetItemIndex(id: integer): pointer;

    property Count: integer read GetCount;
  end;


    //镜子类
    //功能：放在某处 监视周围物体
  TMirrorObject = class(TBasicObject)
  private
    SelfData: TCreateMirrorData;

    ViewerList: TList;

    boActive: Boolean;
  protected
    procedure Initial;
    procedure StartProcess; override;
    procedure EndProcess; override;
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddViewer(aUser: Pointer);
    function DelViewer(aUser: Pointer): Boolean;

    procedure Update(CurTick: Integer); override;

    function GetSelfData: PTCreateMirrorData;
  end;

  TMirrorList = class
  private
    DataList: TList;

    function GetCount: integer;
  public
    constructor Create;
    destructor Destroy; override;

    function AddViewer(aStr: string; aUser: Pointer): Boolean;
    function DelViewer(aUser: Pointer): Boolean;

    procedure Clear;
    procedure LoadFromFile(aFileName: string);

    procedure Update(CurTick: integer);

    property Count: integer read GetCount;
  end;

    //虚拟 物品 加水 加血
  TVirtualObject = class(TBasicObject)
  private
    SelfData: TCreateVirtualObject;
  protected
    procedure Initial(var aCreateVirtualObject: TCreateVirtualObject);
    procedure StartProcess; override;
    procedure EndProcess; override;
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update(CurTick: Integer); override;
  end;

  TVirtualObjectList = class
  private
    Manager: TManager;
    DataList: TList;
    function GetCount: integer;
  public
    constructor Create(aManager: TManager);
    destructor Destroy; override;

    procedure Clear;
    procedure LoadFile();

    procedure Update(CurTick: integer);

    procedure addCreate(var aCreateVirtualObject: TCreateVirtualObject);

    property Count: integer read GetCount;
  end;

       //机关CreateGroupMove.sdb
  TGroupMoveObject = class(TBasicObject) //传送
  private
    SelfData: TCreateGroupMoveData;
    itemCount: integer;
    UserNameList: tstringlist; //存放的ID
  protected
    procedure Initial(var aCreateGroupMoveData: TCreateGroupMoveData);
    procedure StartProcess; override;
    procedure EndProcess; override;
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
  public
    constructor Create;
    destructor Destroy; override;


  end;

  TGroupMoveList = class
  private
    DataList: TList;

    function GetCount: integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure LoadFromFile();
    procedure addCreate(var aCreateGroupMoveData: TCreateGroupMoveData);
    procedure Update(CurTick: integer);
    property Count: integer read GetCount;
  end;

  TMineObject = class(TBasicObject)
  private
    //创建资料
    SelfData: TCreateMineObject;
        //基本属性
    MineData: TMineData;
        //组
    MineAvailData: TMineAvailData;
        //外观
    MineShapeData: TMineShapeData;
    pToolRateClass: TToolRateClass;
    Deposits: integer;
    RegenIntervals: integer;
    DepositsTick: integer;


    procedure Regen;
  protected
    function Initial(var aCreateMineObject: TCreateMineObject): boolean;
    procedure StartProcess; override;
    procedure EndProcess; override;
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update(CurTick: Integer); override;
  end;

  TMineObjectList = class
  private
    Manager: TManager;
    DataList: TList;
    CurProcessPos: integer;
    function GetCount: integer;
  public
    constructor Create(aManager: TManager);
    destructor Destroy; override;

    procedure Clear;
    procedure LoadFile();

    procedure Update(CurTick: integer);

    procedure addCreate(var aTCreateMineObject: TCreateMineObject);

    property Count: integer read GetCount;
  end;
    //物品 在地下  管理类
  TStaticItem = class(TBasicObject)
  private
    CurDurability: integer;
    SelfItemData: TItemData;
    OwnerId: Integer;
  protected
    procedure Initial(aItemData: TItemData; aOwnerId, ax, ay: integer);
    procedure StartProcess; override;
    procedure EndProcess; override;
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Update(CurTick: integer); override;
  end;

  TStaticItemList = class
  private
    Manager: TManager;
    CurProcessPos: integer;
    DataList: TList;
        // function  AllocFunction: pointer;
        // procedure FreeFunction (item: pointer);
    function GetCount: integer;
  public
    constructor Create(aManager: TManager);
    destructor Destroy; override;

    procedure Clear;

    function AddStaticItemObject(aItemData: TItemData; aOwnerId, ax, ay: integer): integer;
    procedure Update(CurTick: integer);
    property Count: integer read GetCount;
  end;

  TDynamicObject = class(TBasicObject)
  private
    SelfData: TCreateDynamicObjectData;

    CurLife: Integer;
    EventItemCount: Integer;
    StepCount: Integer;
    DragDropEvent: TDragDropEvent; //物品拖动 事件

    MemberList: TList;
                                                    //召唤怪物NPC列表
    function getSStep(aState, astep: integer): integer;
    function getEStep(aState, astep: integer): integer;
    procedure Regen;



  protected
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
  public
    OpenedTick: Integer; //打开的时间
    ShowHideTick: Integer;
    OpenedPosX, OpenedPosY: Word; //被打开的时候坐标
    ObjectStatus: TDynamicObjectState; //当前状态
  public
    constructor Create;
    destructor Destroy; override;

    procedure Initial(pObjectData: PTCreateDynamicObjectData);
    procedure StartProcess; override;
    procedure EndProcess; override;

    procedure Update(CurTick: integer); override;
    procedure MemberDie(aBasicObject: TBasicObject);
    procedure setObjectStatus(aObjectStatus: TDynamicObjectState);
    function GetCsvStr: string;
    property Status: TDynamicObjectState read ObjectStatus;

    procedure DropMop(outList: tlist);
  end;

  TDynamicObjectList = class
  private
    Manager: TManager;
    CurProcessPos: integer;
    DataList: TList;

    function GetCount: integer;



  public
    constructor Create(aManager: TManager);
    destructor Destroy; override;

    procedure Regen;
    procedure Clear;
    procedure ReLoad;
    function getTypeCount(aname: string; aObjectStatus: TDynamicObjectState): integer;
    function AddDynamicObject(pObjectData: PTCreateDynamicObjectData): integer;
    function DeleteDynamicObject(aName: string): Boolean;
    function FindDynamicObject(aName: string): Integer;
    procedure RegenDynamicObject(aName: string);

    function GetDynamicObjects(aName: string; aList: TList): Integer;
    procedure ChangeObjectStatus(aName: string; aObjectStatus: TDynamicObjectState);
    procedure Update(CurTick: integer);
    procedure SaveFileCsv;
    property Count: integer read GetCount;

    procedure DropMop(outList: tlist);
  end;


    //CreateMineObject1.sdb

//procedure SignToItem(var aItemData: TItemData; aServerID: Integer; var aBasicData: TBasicData; aIP: string);

var
  boShowHitedValue: Boolean = FALSE;
  boShowGuildDuraValue: Boolean = FALSE;

  GateList: TGateList = nil;
  MirrorList: TMirrorList = nil;
  GroupMoveLIST: TGroupMoveList = nil;
implementation

uses
  SvMain, uUser, uNpc, uMonster, uSkills, uLevelExp, UserSDB, StrUtils, uProcession;

///////////////////////////////
//        TBasicObject
///////////////////////////////

constructor TBasicObject.Create;
begin
  Fboice := false;
  LockNotMoveTick := 0;
  LockNotMoveState := false;
  SayDelayList := nil;
  MapPath := nil;
  FScriptClass := nil;
  FillChar(BasicData, sizeof(BasicData), 0);
  BasicData.Feature.rNameColor := WinRGB(31, 31, 31);
  BasicData.P := Self;
  BasicData.BasicObjectType := botNone;
  ViewObjectList := TList.Create;
    // ViewObjectNameList := TStringList.Create;
  EnmityList := TEnmityclass.Create; //仇恨 列表
end;

destructor TBasicObject.Destroy;
var
  i: Integer;
begin
  ViewObjectList.Free;
  EnmityList.Free;
    // ViewObjectNameList.Free;
  inherited Destroy;
end;

procedure TBasicObject.SayDelayAdd(astr: string; atime: integer);
begin
  if SayDelayList = nil then SayDelayList := TStringList.Create;
  SayDelayList.AddObject(astr, TObject(atime))
end;

procedure TBasicObject.SayDelayClear;
begin
  if SayDelayList = nil then exit;
  SayDelayList.Free;
  SayDelayList := nil;
end;

function TBasicObject.FindViewObject(aBasicObject: TBasicObject): Boolean;
var
  i: Integer;
  BasicObject: TBasicObject;
begin
  Result := false;
  for i := 0 to ViewObjectList.Count - 1 do
  begin
    BasicObject := ViewObjectList.Items[i];
    if BasicObject = aBasicObject then
    begin
      Result := true;
      exit;
    end;
  end;
end;


function _Check8Hit(adir, ax, ay, myx, myy: integer): integer;
var
  tempdir: byte;
  xx, yy: word;
begin
  Result := 0;

  tempdir := adir;
  xx := ax;
  yy := ay;
  GetNextPosition(tempdir, xx, yy);
  if (myx = xx) and (myy = yy) then
  begin
    Result := 100;
    exit;
  end; //100

  tempdir := GetRightDirection(tempdir);
  xx := ax;
  yy := ay;
  GetNextPosition(tempdir, xx, yy);
  if (myx = xx) and (myy = yy) then
  begin
    Result := 99;
    exit;
  end; //70

  tempdir := GetRightDirection(tempdir);
  xx := ax;
  yy := ay;
  GetNextPosition(tempdir, xx, yy);
  if (myx = xx) and (myy = yy) then
  begin
    Result := 99;
    exit;
  end; //70

  tempdir := GetRightDirection(tempdir);
  xx := ax;
  yy := ay;
  GetNextPosition(tempdir, xx, yy);
  if (myx = xx) and (myy = yy) then
  begin
    Result := 99;
    exit;
  end; //85

  tempdir := GetRightDirection(tempdir);
  xx := ax;
  yy := ay;
  GetNextPosition(tempdir, xx, yy);
  if (myx = xx) and (myy = yy) then
  begin
    Result := 99;
    exit;
  end; //85

  tempdir := GetRightDirection(tempdir);
  xx := ax;
  yy := ay;
  GetNextPosition(tempdir, xx, yy);
  if (myx = xx) and (myy = yy) then
  begin
    Result := 99;
    exit;
  end; //85

  tempdir := GetRightDirection(tempdir);
  xx := ax;
  yy := ay;
  GetNextPosition(tempdir, xx, yy);
  if (myx = xx) and (myy = yy) then
  begin
    Result := 99;
    exit;
  end; //85

  tempdir := GetRightDirection(tempdir);
  xx := ax;
  yy := ay;
  GetNextPosition(tempdir, xx, yy);
  if (myx = xx) and (myy = yy) then
  begin
    Result := 99;
    exit;
  end; //85
end;

function _Check5Hit(adir, ax, ay, myx, myy: integer): integer;
var
  tempdir: byte;
  xx, yy: word;
begin
  Result := 0;

  tempdir := adir;
  xx := ax;
  yy := ay;
  GetNextPosition(tempdir, xx, yy);
  if (myx = xx) and (myy = yy) then
  begin
    Result := 100;
    exit;
  end; //99

  tempdir := adir;
  tempdir := GetRightDirection(tempdir);
  xx := ax;
  yy := ay;
  GetNextPosition(tempdir, xx, yy);
  if (myx = xx) and (myy = yy) then
  begin
    Result := 99;
    exit;
  end; //90

  tempdir := adir;
  tempdir := GetLeftDirection(tempdir);
  xx := ax;
  yy := ay;
  GetNextPosition(tempdir, xx, yy);
  if (myx = xx) and (myy = yy) then
  begin
    Result := 99;
    exit;
  end; //90

  tempdir := adir;
  tempdir := GetRightDirection(tempdir);
  tempdir := GetRightDirection(tempdir);
  xx := ax;
  yy := ay;
  GetNextPosition(tempdir, xx, yy);
  if (myx = xx) and (myy = yy) then
  begin
    Result := 99;
    exit;
  end; //80

  tempdir := adir;
  tempdir := GetLeftDirection(tempdir);
  tempdir := GetLeftDirection(tempdir);
  xx := ax;
  yy := ay;
  GetNextPosition(tempdir, xx, yy);
  if (myx = xx) and (myy = yy) then
  begin
    Result := 99;
    exit;
  end; //80
end;

///////////////////////////////////////////////////////
//                 isHitedArea
///////////////////////////////////////////////////////
//功能：攻击自己返回TRUE，不是FALSE；
//apercent

function TBasicObject.isHitedArea(adir, ax, ay: integer; afunc: byte; var apercent: integer): Boolean;
var
  xx, yy: word;
  i: integer;
  boState: boolean;
begin
  apercent := 0;
  Result := FALSE;
  case afunc of
    MAGICFUNC_NONE:
      begin
        xx := ax;
        yy := ay;
        GetNextPosition(adir, xx, yy);
        if (BasicData.x = xx) and (BasicData.y = yy) then
        begin
          apercent := 100;
          Result := TRUE;
        end else
        begin
          for i := 0 to 9 do
          begin
            if (BasicData.GuardX[i] = 0) and (BasicData.GuardY[i] = 0) then Break;
            if (BasicData.x + BasicData.GuardX[i] = xx) and ((BasicData.y + BasicData.GuardY[i]) = yy) then
            begin
              apercent := 100;
              Result := TRUE;
              Break;
            end;
          end;
        end;

      end;
    MAGICFUNC_8HIT:
      begin
        if GetLargeLength(ax, ay, BasicData.x, BasicData.y) <= 1 then
        begin
          apercent := _Check8Hit(adir, ax, ay, BasicData.x, BasicData.y);
          if apercent = 0 then exit;
          Result := TRUE;
          exit;
        end;

        for i := 0 to 9 do
        begin
          xx := BasicData.x + BasicData.GuardX[i];
          yy := BasicData.y + BasicData.GuardY[i];
          if (BasicData.GuardX[i] = 0) and (BasicData.GuardY[i] = 0) then exit;
          if GetLargeLength(ax, ay, xx, yy) <= 1 then
          begin
            apercent := _Check8Hit(adir, ax, ay, xx, yy);
            if apercent <> 0 then
            begin
              Result := TRUE;
              exit;
            end;
          end;
        end;


      end;
    MAGICFUNC_5HIT:
      begin
        if GetLargeLength(ax, ay, BasicData.x, BasicData.y) <= 1 then
        begin
          apercent := _Check5Hit(adir, ax, ay, BasicData.x, BasicData.y);
          if apercent = 0 then exit;
          Result := TRUE;
        end;
        for i := 0 to 9 do
        begin
          xx := BasicData.x + BasicData.GuardX[i];
          yy := BasicData.y + BasicData.GuardY[i];
          if (BasicData.GuardX[i] = 0) and (BasicData.GuardY[i] = 0) then exit;
          if GetLargeLength(ax, ay, xx, yy) <= 1 then
          begin
            apercent := _Check5Hit(adir, ax, ay, xx, yy);
            if apercent <> 0 then
            begin
              Result := TRUE;
              exit;
            end;
          end;
        end;
      end;
    MAGICFUNC_Screen_HIT:
      begin
        apercent := 100;
        Result := TRUE;
      end;
  end;
end;

function TBasicObject.isHit(var aBasicData: TBasicData): Boolean;
var
  xx, yy: word;
  i, adir: integer;
begin
  Result := FALSE;

  adir := GetNextDirection(BasicData.X, BasicData.Y, aBasicData.X, aBasicData.Y);
  if adir = DR_DONTMOVE then exit;
  xx := BasicData.x;
  yy := BasicData.y;
  GetNextPosition(adir, xx, yy);
  if (aBasicData.x = xx) and (aBasicData.y = yy) then
  begin
    Result := TRUE;
    exit;
  end;

  for i := 0 to 9 do
  begin
    if (aBasicData.GuardX[i] = 0) and (aBasicData.GuardY[i] = 0) then exit;
    if (aBasicData.x + aBasicData.GuardX[i] = xx) and ((aBasicData.y + aBasicData.GuardY[i]) = yy) then
    begin
      Result := TRUE;
      exit;
    end;
  end;


end;

procedure TBasicObject.SetManagerClass(aManager: TManager);
begin
  Manager := aManager;
  ServerID := Manager.ServerID;
  Maper := TMaper(Manager.Maper);
  Phone := TFieldPhone(Manager.Phone);
end;

function TBasicObject.GetPosX: integer;
begin
  Result := BasicData.x;
end;

function TBasicObject.GetPosY: integer;
begin
  Result := BasicData.y;
end;

function TBasicObject.GetFeatureState: TFeatureState;
begin
  Result := BasicData.Feature.rfeaturestate;
end;

procedure TBasicObject.Initial(aName, aViewName: string);
begin
  FillChar(BasicData, sizeof(BasicData), 0);
  BasicData.P := Self;
  BasicData.Name := aName;
  BasicData.ViewName := aViewName;

  BasicData.LifePercent := 100;

  FboAllowDelete := FALSE;
  FboRegisted := FALSE;
  FboHaveGuardPos := FALSE;

  FCreateX := 0;
  FCreateY := 0;
end;

procedure TBasicObject.StartProcess;
begin


  FboRegisted := TRUE;
  FboAllowDelete := FALSE;

  BasicData.dir := DR_4;
  BasicData.Feature.rfeaturestate := wfs_normal;
  MapPathStep := -1;
  FCreateX := BasicData.x;
  FCreateY := BasicData.y;
  FCreateTick := mmAnsTick;
  FAlarmTick := 0;

  EnmityList.Clear;
  ViewObjectList.Clear;

end;

procedure TBasicObject.EndProcess;
begin
  ViewObjectList.Clear;

  FboRegisted := FALSE;
  SayDelayClear;
end;

function TBasicObject.GetViewObjectById(aid: integer): TBasicObject;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ViewObjectList.Count - 1 do
  begin
    if TBasicObject(ViewobjectList[i]).BasicData.id = aid then
    begin
      Result := ViewObjectList[i];
      exit;
    end;
  end;
end;

// function    TBasicObject.GetViewObjectByName (aName: string; aRace: integer): TBasicObject;
// 2000.09.18 鞍篮 捞抚狼 按眉啊 乐阑锭 惯积登绰 滚弊荐沥阑 困秦 牢磊眠啊
// 茫栏妨绰 按眉狼 捞抚苞 辆幅肺 八祸茄促 by Lee.S.G

function TBasicObject.GetViewObjectByName(aName: string; aRace: integer): TBasicObject;
var
  i: integer;
  BObject: TBasicObject;
begin
  Result := nil;
  for i := 0 to ViewObjectList.Count - 1 do
  begin
    BObject := ViewObjectList[i];
    if (BObject.BasicData.Feature.rRace = aRace) and ((BObject.BasicData.Name) = aName) then
    begin
      Result := BObject;
      exit;
    end;
  end;
end;

function TBasicObject.CallScriptFunction(const Name: string; const Params: array of const): integer;
begin
  result := -1;
  if FScriptClass <> nil then
  begin
    if FScriptClass.GetMemberID(Name) <> 0 then
      result := FScriptClass.CallFunction(Name, Params);
  end;
end;

procedure TBasicObject.SetScript(aScript, afilename: string);
begin
  if aScript = '' then
  begin
    FScriptClass := nil;
    exit;
  end;

  if ScripterList.IsScripter(aScript) = false then
    ScripterList.LoadFile(aScript, afilename);

  if ScripterList.GetScripter(aScript, FScriptClass) = false then
  begin
    FScriptClass := nil;
  end;
end;

procedure TBasicObject.ShowSound(asound: integer);
var
  SubData: TSubData;
begin
  SubData.sound := asound;
  SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
end;

procedure TBasicObject.ShowEffect(aEffectNumber: Word; aEffectKind: TLightEffectKind);
var
  SubData: TSubData;
begin
    //原始 使用 修改面貌 大包处理；
    {
        BasicData.Feature.rEffectNumber := aEffectNumber;
        BasicData.Feature.rEffectKind := aEffectKind;

        SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);

        BasicData.Feature.rEffectNumber := 0;
        BasicData.Feature.rEffectKind := lek_none;
        }
  BasicData.Feature.rEffectNumber := aEffectNumber;
  BasicData.Feature.rEffectKind := aEffectKind;
  SendLocalMessage(NOTARGETPHONE, FM_Effect, BasicData, SubData);
  BasicData.Feature.rEffectNumber := 0;
  BasicData.Feature.rEffectKind := lek_none;
end;

procedure TBasicObject.HIT_Screen(aHit: integer);
var
  SubData: TSubData;
begin
  fillchar(SubData, sizeof(SubData), 0);
  SubData.HitData.damageBody := aHit;
  SubData.HitData.ToHit := 65535;
  SubData.HitData.HitLevel := 7500;
  SubData.HitData.HitTargetsType := _htt_All;
  SubData.HitData.boHited := FALSE;
  SubData.HitData.HitFunction := MAGICFUNC_Screen_HIT;
  SendLocalMessage(NOTARGETPHONE, FM_HIT, BasicData, SubData);
end;

procedure TBasicObject.ShowMagicEffect(aEffectNumber: Word; aEffectKind: TLightEffectKind);
var
  SubData: TSubData;
begin

  BasicData.Feature.rEffectNumber := aEffectNumber;
  BasicData.Feature.rEffectKind := aEffectKind;
  SendLocalMessage(NOTARGETPHONE, FM_MagicEffect, BasicData, SubData);
  BasicData.Feature.rEffectNumber := 0;
  BasicData.Feature.rEffectKind := lek_none;
end;

procedure TBasicObject.BocSay(astr: string);
var
  SubData: TSubData;
begin
  SetWordString(SubData.SayString, (BasicData.ViewName) + ': ' + astr);
  SendLocalMessage(NOTARGETPHONE, FM_SAY, BasicData, SubData);
end;

procedure TBasicObject.LeftTextSay(hfu: integer; astr: string; acolor: integer);
var
  SubData: TSubData;
begin
  SetWordString(SubData.SayString, astr);
  SubData.ShoutColor := acolor;
  SendLocalMessage(hfu, FM_LeftText, BasicData, SubData);
end;

procedure TBasicObject.BocChangeFeature;
var
  SubData: TSubData;
begin
  SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
end;

procedure TBasicObject.BocChangeProperty;
var
  SubData: TSubData;
begin
  SendLocalMessage(NOTARGETPHONE, FM_CHANGEPROPERTY, BasicData, SubData);
end;

procedure TBasicObject.BoSysopMessage(astr: string; aSysopScope: integer);
var
  SubData: TSubData;
begin
  if not boShowHitedValue then exit;

  SetWordString(SubData.SayString, (BasicData.ViewName) + ': ' + astr);
  SubData.SysopScope := aSysopScope;
  SendLocalMessage(NOTARGETPHONE, FM_SYSOPMESSAGE, BasicData, SubData);
end;

function TBasicObject.SendLocalMessage(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  i: integer;
  Bo: TBasicObject;
begin
  Result := PROC_FALSE;
    ////////////////////////////////////////////////////////////////////////////
    //                         指定 范围 发送   2009 3 24日 增加
   { if aplacewidth <> 0 then
    begin

        Result := FieldProc(hfu, Msg, SenderInfo, aSubData);
        i := 0;
        while i < ViewObjectList.Count do
        begin
            Bo := ViewObjectList[i];
            try
                if Bo <> Self then
                begin
                    if isRangeWidth(bo.BasicData.x, bo.BasicData.y, aplacewidth) then
                        Bo.FieldProc(hfu, Msg, SenderInfo, aSubData)
                end;
                Inc(i);
            except
                ViewObjectList.Delete(i);
                frmMain.WriteLogInfo(format('TBasicObject.SendLocalMessage (%s) failed', [(BasicData.Name)]));
            end;
        end;
        exit;
    end;}
    ////////////////////////////////////////////////////////////////////////////
    //                            发送到目标
  if hfu = 0 then
  begin
    Result := FieldProc(hfu, Msg, SenderInfo, aSubData);
        {
        for i := 0 to ViewObjectList.Count -1 do begin
           Bo := ViewObjectList[i];
           if Bo <> Self then begin
              Bo.FieldProc (hfu, Msg, SenderInfo, aSubData)
           end;
        end;
        }
    i := 0;
    while i < ViewObjectList.Count do
    begin
      Bo := ViewObjectList[i];
      try
        if Bo <> Self then
        begin
          Bo.FieldProc(hfu, Msg, SenderInfo, aSubData)
        end;
        Inc(i);
      except
                {
                frmMain.WriteLogInfo (format ('TBasicObject.SendLocalMessage (%s) failed', [ViewObjectNameList[i]]));
                ViewObjectNameList.Delete (i);
                }
        ViewObjectList.Delete(i);
        frmMain.WriteLogInfo(format('TBasicObject.SendLocalMessage (%s) failed', [(BasicData.Name)]));
      end;
    end;

  end else
  begin
        ////////////////////////////////////////////////////////////////////////////
        //                            广播 消息
    for i := 0 to ViewObjectList.Count - 1 do
    begin
      Bo := ViewObjectList[i];
      try
        if Bo.BasicData.id = hfu then
        begin
          result := Bo.FieldProc(hfu, Msg, SenderInfo, aSubData);
          exit;
        end;
      except
                {
                frmMain.WriteLogInfo (format ('TBasicObject.SendLocalMessage (%s) failed', [ViewObjectNameList[i]]));
                ViewObjectNameList.Delete (i);
                }
        ViewObjectList.Delete(i);
        frmMain.WriteLogInfo(format('TBasicObject.SendLocalMessage (%s) failed', [(BasicData.Name)]));
        exit;
      end;
    end;
  end;
end;

function TBasicObject.isRangeWidthHeight(xx, yy: word; awidth, aHeight: word): Boolean;
var
  x1, x2, y1, y2: integer;
begin
  Result := TRUE;
  x1 := BasicData.x;
  y1 := BasicData.y;
  x2 := xx;
  y2 := yy;
  if (x2 < x1 - awidth) then
  begin
    Result := FALSE;
    exit;
  end;
  if (x2 > x1 + awidth) then
  begin
    Result := FALSE;
    exit;
  end;
  if (y2 < y1 - aHeight) then
  begin
    Result := FALSE;
    exit;
  end;
  if (y2 > y1 + aHeight) then
  begin
    Result := FALSE;
    exit;
  end;
end;

function TBasicObject.isRangeWidth(xx, yy: word; awidth: word): Boolean;
var
  x1, x2, y1, y2: integer;
begin
  Result := TRUE;
  x1 := BasicData.x;
  y1 := BasicData.y;
  x2 := xx;
  y2 := yy;
  if (x2 < x1 - awidth) then
  begin
    Result := FALSE;
    exit;
  end;
  if (x2 > x1 + awidth) then
  begin
    Result := FALSE;
    exit;
  end;
  if (y2 < y1 - awidth) then
  begin
    Result := FALSE;
    exit;
  end;
  if (y2 > y1 + awidth) then
  begin
    Result := FALSE;
    exit;
  end;
end;
//测试 可视范围 距离

function TBasicObject.isRange(xx, yy: word): Boolean;
var
  x1, x2, y1, y2: integer;
begin
  Result := TRUE;
  x1 := BasicData.x;
  y1 := BasicData.y;
  x2 := xx;
  y2 := yy;
  if (x2 < x1 - VIEWRANGEWIDTH) then
  begin
    Result := FALSE;
    exit;
  end;
  if (x2 > x1 + VIEWRANGEWIDTH) then
  begin
    Result := FALSE;
    exit;
  end;
  if (y2 < y1 - VIEWRANGEHEIGHT) then
  begin
    Result := FALSE;
    exit;
  end;
  if (y2 > y1 + VIEWRANGEHEIGHT) then
  begin
    Result := FALSE;
    exit;
  end;
end;

function TBasicObject.isRangeMessage(hfu: Longint; Msg: word; var SenderInfo: TBasicData): Boolean;
begin
  Result := FALSE;
  if (hfu = BasicData.id) then
  begin
    Result := TRUE;
    exit;
  end;
  if hfu = NOTARGETPHONE then
  begin
    if isRange(SenderInfo.x, SenderInfo.y) then
    begin
      Result := TRUE;
      exit;
    end;
    if (msg = FM_MOVE) and isRange(SenderInfo.nx, SenderInfo.ny) then
    begin
      Result := TRUE;
      exit;
    end;
  end;
  if Msg = FM_SHOUT then Result := TRUE;
end;

function TBasicObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  i: integer;
  BasicObject: TBasicObject;
  SubData: TSubData;
  bo1, bo2: boolean;
  User: Tuser;
  str: string;
begin
  Result := PROC_FALSE;

  if not FboRegisted then
  begin
    frmMain.WriteLogInfo('UnRegisted BasicObject.FieldProc was called');
    exit;
  end;

  case Msg of
    FM_GIVEMEADDR: if hfu = BasicData.id then Result := Integer(Self);

//        FM_CLICK: if hfu = BasicData.id then SetWordString(aSubData.SayString, (BasicData.viewName));
        //可视范围 管理---------------------------------------------------------
    FM_SHOW: //可视觉范围 出现 1个目标
      begin
        if SenderInfo.id = Basicdata.id then
        begin
          ViewObjectList.Clear;
                    // ViewObjectNameList.Clear;
        end;

        if FindViewObject(SenderInfo.P) = true then
        begin
          frmMain.WriteLogInfo('ViewObjectList Duplicate');
          exit;
        end;

        if SenderInfo.Feature.rrace = RACE_HUMAN then
        begin
          ViewObjectList.Insert(0, SenderInfo.p);

        end else
        begin
          ViewObjectList.Add(SenderInfo.p);

        end;
      end;
    FM_HIDE: //HIDE 可视觉范围 消失 1个目标
      begin
        for i := 0 to ViewObjectList.Count - 1 do
        begin
          if ViewObjectList[i] = SenderInfo.P then
          begin
            ViewObjectList.Delete(i);
                        // ViewObjectNameList.Delete (i);
            break;
          end;
        end;
      end;
        //----------------------------------------------------------------------
    FM_CREATE: //CREATE 创建
      begin
        Phone.SendMessage(BasicData.Id, FM_SHOW, SenderInfo, aSubData); //FM_CREATE 消息
        if SenderInfo.Id = BasicData.id then
        begin
                    //是自己 创建
          BasicData := SenderInfo;
          if (BasicData.Feature.rRace = RACE_HUMAN) and (BasicData.Feature.rfeaturestate = wfs_die) then exit;
          Maper.MapProc(BasicData.Id, MM_SHOW, BasicData.x, BasicData.y, BasicData.x, BasicData.y, BasicData);
        end else
        begin
                    //非自己 可视范围内 有1个物体创建新生，
          Result := PROC_TRUE;
          Phone.SendMessage(SenderInfo.Id, FM_SHOW, BasicData, SubData); //FM_CREATE 消息
        end;
      end;
    FM_DESTROY: //DESTROY 死亡
      begin
        if SenderInfo.Id = BasicData.id then
          Maper.MapProc(BasicData.Id, MM_HIDE, BasicData.x, BasicData.y, BasicData.x, BasicData.y, BasicData);
        Phone.SendMessage(BasicData.Id, FM_HIDE, SenderInfo, aSubData);
      end;
    FM_MOVE: //显身 隐身 处理
      begin
        bo1 := isRange(SenderInfo.x, SenderInfo.y);
        bo2 := isRange(SenderInfo.nx, SenderInfo.ny);
        if (bo1 = TRUE) and (bo2 = FALSE) then
        begin
          Phone.SendMessage(SenderInfo.Id, FM_HIDE, BasicData, SubData);
          Phone.SendMessage(BasicData.id, FM_HIDE, SenderInfo, aSubData);
          exit;
        end;
        if (bo1 = FALSE) and (bo2 = TRUE) then
        begin
          Phone.SendMessage(SenderInfo.Id, FM_SHOW, BasicData, SubData); //FM_MOVE
          Phone.SendMessage(BasicData.ID, FM_SHOW, SenderInfo, aSubData); //FM_MOVE
          exit;
        end;
      end;
    FM_CLICK:
        //菜单，1
      begin
        if hfu = BasicData.id then

        begin
          SetWordString(aSubData.SayString, (BasicData.viewName));

                   { if Fboice then
                        SetWordString(aSubData.SayString, (BasicData.Name + '冻结，测试消息'))
                    else
                        SetWordString(aSubData.SayString, (BasicData.Name + '没冻结，测试消息'));}
        end;
        if SenderInfo.id = BasicData.id then exit;
        if SenderInfo.Feature.rrace <> RACE_HUMAN then exit;
        User := Tuser(SenderInfo.p);
        if User <> nil then
        begin
          if (USER.SpecialWindow <> 0) then
          begin
            USER.SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
            exit;
          end;
          USER.MenuSayText := '';
          USER.MenuSTATE := nsSelect;
          User.MenuSayObjId := BasicData.id;
          CallScriptFunction('OnMenu', [integer(SenderInfo.p), integer(self)]);
        end;
      end;
    FM_MenuSAY: //NPC通用 菜单 交互
      begin
        if SenderInfo.id = BasicData.id then exit;
        if SenderInfo.Feature.rrace <> RACE_HUMAN then exit;
        if SenderInfo.Feature.rfeaturestate = wfs_die then exit;
        User := Tuser(SenderInfo.p);
        USER.MenuSayText := '';
        STR := aSubData.SubName;

        USER.MenuSTATE := nsSelect;
        User.MenuSayObjId := BasicData.id;

        if STR = '' then exit;
        if STR[1] <> '@' then exit;
        STR := copy(STR, 2, length(STR));
        CallScriptFunction(str, [integer(SenderInfo.p), integer(self)]);
      end;

  end;
end;

procedure TBasicObject.LockNotMove(atime: integer);
begin
  LockNotMoveTick := mmAnsTick;
  LockNotMoveTime := atime;
  LockNotMoveState := true;
end;

procedure TBasicObject.Update(CurTick: integer);
var
  atiem: integer;
begin
  if Fboice then exit;
  if SayDelayList <> nil then
    if SayDelayList.Count > 0 then
    begin
      atiem := integer(SayDelayList.Objects[0]);
      if CurTick >= SayDelayTick + atiem then
      begin
        SayDelayTick := CurTick;
        BocSay(SayDelayList.Strings[0]);
        SayDelayList.Delete(0);
        if SayDelayList.Count <= 0 then SayDelayClear;
      end;
    end;
  EnmityList.Update(CurTick);
  if LockNotMoveState then
  begin
    if CurTick >= LockNotMoveTick + LockNotMoveTime then
    begin
      LockNotMoveTick := CurTick;
      LockNotMoveState := false;
    end;
  end;
end;

////////////////////////////////////////////////////
//
//             ===  ItemObject  ===
//
////////////////////////////////////////////////////

constructor TItemObject.Create;
begin
  inherited Create;
  boAllowPickup := true;
  BasicData.BasicObjectType := botItemObject;
end;

destructor TItemObject.Destroy;
begin
  inherited destroy;
end;
{
function TItemObject.isItemOwner(aid, x, y :integer) :boolean;
begin

  result := false;
  if (SelfItemData.rTempOwnerId = 0) then
  begin
    result := true;
    exit;
  end;

  if (SelfItemData.rTempOwnerId <> aid) then exit;
  if isRange(x, y) = false then exit;
  result := true;

end;
}

function TItemObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  SubData: TSubData;
  aOwnerId: integer;
begin
  Result := PROC_FALSE;
  if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit;
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
  if Result = PROC_TRUE then exit;

  case Msg of
    FM_ADDITEM:
      begin
        if aSubData.ItemData.rCount <> 1 then exit;
        if SelfItemData.rKind = ITEM_KIND_COLORDRUG then exit;
        if SelfItemData.rKind = ITEM_KIND_CHANGER then exit;

        if aSubData.ItemData.rKind = ITEM_KIND_COLORDRUG then
        begin
          if SelfItemData.rboColoring = FALSE then
          begin
            Result := PROC_FALSE;
            exit;
          end;
          if INI_WHITEDRUG <> (aSubData.ItemData.rName) then
          begin
            SelfItemData.rColor := aSubData.ItemData.rColor;
            BasicData.Feature.rImageColorIndex := aSubData.ItemData.rColor;
            Phone.SendMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
          end else
          begin
            SelfItemdata.rColor := SelfItemdata.rColor + aSubData.ItemData.rColor;
            BasicData.Feature.rImageColorIndex := SelfItemdata.rColor;
            Phone.SendMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
          end;
          Result := PROC_TRUE;
          exit;
        end;
        if aSubData.ItemData.rKind = ITEM_KIND_CHANGER then
        begin
          if (BasicData.Name) <> aSubData.ItemData.rNameParam[0] then exit;
          FboAllowDelete := true;

          ItemClass.GetItemData(aSubData.ItemData.rNameParam[1], SubData.ItemData);
          if SubData.ItemData.rName <> '' then
          begin
            BasicData.nX := BasicData.X;
            BasicData.nY := BasicData.Y;
            SubData.ServerId := Manager.ServerId;
            Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
            Result := PROC_TRUE;
          end;
          exit;
        end;
      end;
    FM_PICKUP:
      begin
        if FboAllowDelete then exit;
                {
                if boAllowPickup = false then begin
                   if (SenderInfo.x <> BasicData.x) or (SenderInfo.y <> BasicData.y) then begin
                      exit;
                   end;
                end;
                }
        if SenderInfo.BasicObjectType = botUser then
        begin
          if (SelfItemData.rTempOwner.rAttacker <> 0) then
            if (SelfItemData.rTempOwner.rtype = eUserProcession) then
            begin
              aOwnerId := SenderInfo.id;
              if TUSER(SenderInfo.P).uProcessionclass = nil then
              begin
                LeftTextSay(SenderInfo.id, '不能拾取', WinRGB(22, 22, 0));
                exit;
              end;

              if tProcessionclass(TUSER(SenderInfo.P).uProcessionclass).rid <> SelfItemData.rTempOwner.rAttacker then
              begin
                LeftTextSay(SenderInfo.id, '不能拾取', WinRGB(22, 22, 0));
                exit;
              end;

              if tProcessionclass(TUSER(SenderInfo.P).uProcessionclass).Ftype = pdtRandom then
                aOwnerId := tProcessionclass(TUSER(SenderInfo.P).uProcessionclass).ItemRandom(self);
              SubData.ItemData := SelfItemData;
              SubData.ServerId := ServerId;
              if Phone.SendMessage(aOwnerId, FM_ADDITEM, BasicData, SubData) = PROC_TRUE then
              begin
                FboAllowDelete := TRUE;
                tProcessionclass(TUSER(SenderInfo.P).uProcessionclass)._OnAddItem(@SelfItemData, aOwnerId);
                            //   LeftTextSay(aOwnerId, format('%s 获取 %d个', [(SubData.ItemData.rViewName), SubData.ItemData.rCount]), SAY_COLOR_SYSTEM);
              end;
              exit;
            end else
            begin

              if SenderInfo.id <> SelfItemData.rTempOwner.rAttacker then
              begin
                LeftTextSay(SenderInfo.id, '不能拾取', WinRGB(22, 22, 0));
                exit;
              end;

            end;
        end;
        SubData.ItemData := SelfItemData;
        SubData.ServerId := ServerId;
        if Phone.SendMessage(SenderInfo.id, FM_ADDITEM, BasicData, SubData) = PROC_TRUE then
        begin
          FboAllowDelete := TRUE;
                    // LeftTextSay(SenderInfo.id, format('%s 获取 %d个', [(SubData.ItemData.rViewName), SubData.ItemData.rCount]), SAY_COLOR_SYSTEM);
        end;
        exit;
      end;
    FM_SAY:
      begin
      end;
  end;
end;

procedure TItemObject.Initial(aItemData: TItemData; aOwnerId, ax, ay: integer);
var
  iName, iViewName: string;
begin
  iName := (aItemData.rName);
  if aItemData.rCount > 1 then iName := iName + ':' + IntToStr(aItemData.rCount);
  iViewName := (aItemData.rViewName);
  if aItemData.rCount > 1 then iViewName := iViewName + ':' + IntToStr(aItemData.rCount);

  inherited Initial(iName, iViewName);

  OwnerId := aOwnerId;
  SelfItemdata := aItemData;
  BasicData.id := GetNewItemId;
  BasicData.x := ax;
  BasicData.y := ay;
  BasicData.ClassKind := CLASS_ITEM;
  BasicData.Feature.rrace := RACE_ITEM;
  BasicData.Feature.rImageNumber := aItemData.rShape;
  BasicData.Feature.rImageColorIndex := aItemData.rcolor;
  BasicData.BasicObjectType := botItemObject;
    {
    boAllowPickup := true;
    if not Maper.isMoveable (ax, ay) then begin
       boAllowPickup := false;
    end;
    }
  SetScript(SelfItemData.rScripter, format('.\%s\%s\%s.pas', ['Script', 'Item', SelfItemData.rScripter]));
end;

procedure TItemObject.StartProcess;
var
  SubData: TSubData;
begin
  inherited StartProcess;

  Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  Phone.SendMessage(0, FM_CREATE, BasicData, SubData);

  if SelfItemData.rSoundDrop.rWavNumber <> 0 then
  begin
        // SetWordString(SubData.SayString, IntToStr(SelfItemData.rSoundDrop.rWavNumber) + '.wav');
    SubData.sound := SelfItemData.rSoundDrop.rWavNumber;
    SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
  end;
  CallScriptFunction('OnRegen', [integer(self)]);
end;

procedure TItemObject.EndProcess;
var
  SubData: TSubData;
begin
  if FboRegisted = FALSE then exit;

  Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
  Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);
  inherited EndProcess;
end;

procedure TItemObject.Update(CurTick: integer);
var
  SubData: TSubData;
begin
  if (FboAllowDelete = false) and (CurTick > CreateTick + 18000) then
  begin
    FboAllowDelete := TRUE;
    logItemMoveInfo('地上消失物品', @BasicData, nil, SelfItemData, Manager.ServerID);
  end;
  if CurTick >= FAlarmTick + 300 then
  begin
    FAlarmTick := CurTick;
    SendLocalMessage(NOTARGETPHONE, FM_IAMHERE, BasicData, SubData);
  end;

  if (SelfItemData.rTempOwner.rAttacker <> 0) and (FboAllowDelete = false) then
    if CurTick >= CreateTick + 1000 then
    begin
        //10秒物品 无保护
      SelfItemData.rTempOwner.rAttacker := 0;
    end;

    {
    if boAllowPickup = false then begin
       if CreateTick + 5*100 < CurTick then begin
          boAllowPickup := true;
       end;
    end;
    }
end;

////////////////////////////////////////////////////
//
//             ===  ItemList  ===
//
////////////////////////////////////////////////////

constructor TItemList.Create(aManager: TManager);
begin
  Manager := aManager;
  DataList := TList.Create;
end;

destructor TItemList.Destroy;
begin
  AllClear;
  DataList.Free;
  inherited destroy;
end;

procedure TItemList.AllClear;
var
  i: Integer;
  ItemObject: TItemObject;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    ItemObject := DataList.Items[i];
    ItemObject.EndProcess;
    ItemObject.Free;
  end;
  DataList.Clear;
end;

function TItemList.GetCount: integer;
begin
  Result := DataList.Count;
end;

procedure TItemList.AddItemObject(aItemData: TItemData; aOwnerId, ax, ay: integer);
var
  ItemObject: TItemObject;
begin
   // if DataList.Count > 3000 then exit;

  ItemObject := TItemObject.Create;

  ItemObject.SetManagerClass(Manager);
  ItemObject.Initial(aItemData, aOwnerId, ax, ay);
  ItemObject.StartProcess;

  DataList.Add(ItemObject);
end;

procedure TItemList.Update(CurTick: integer);
var
  i, iCount: integer;
  ItemObject: TItemObject;
begin
    // 2009 4 5日 增加 时间控制  1秒刷1次
    {if GetItemLineTimeSec(CurTick - FDCurTick) < 1 then exit;
    FDCurTick := CurTick;

    for i := DataList.Count - 1 downto 0 do
    begin
        ItemObject := DataList.Items[i];
        if ItemObject.boAllowDelete then
        begin
            ItemObject.EndProcess;
            ItemObject.Free;
            DataList.delete(i);
        end;
    end;

    for i := 0 to DataList.Count - 1 do
    begin
        ItemObject := DataList.Items[i];
        ItemObject.Update(CurTick);
    end;
    }
//    if CurTick - FDCurTick < 30 then exit;
  //  FDCurTick := CurTick;
  //太多 删除前面的物品
  while DataList.Count > 3000 do
  begin
    ItemObject := DataList.Items[0];
    ItemObject.EndProcess;
    ItemObject.Free;
    DataList.delete(0);
  end;

  iCount := ProcessListCount;
  if DataList.Count < iCount then
  begin
    iCount := DataList.Count;
    CurProcessPos := 0;
  end;

  for i := 0 to iCount - 1 do
  begin
    if DataList.Count = 0 then break;

    if CurProcessPos >= DataList.Count then CurProcessPos := 0;

    ItemObject := DataList.Items[CurProcessPos];
    if ItemObject.boAllowDelete then
    begin
      ItemObject.EndProcess;
      ItemObject.Free;
      DataList.delete(CurProcessPos);
    end
    else
    begin
      try
        ItemObject.Update(CurTick);
        Inc(CurProcessPos);
      except
        ItemObject.FBoAllowDelete := true;
        frmMain.WriteLogInfo(format('TItemList.Update (%s) failed', [ItemObject.SelfItemData.rName]));
      end;
    end;
  end;
end;


////////////////////////////////////////////////////
//
//             ===  GateObject  ===
//
////////////////////////////////////////////////////

constructor TGateObject.Create;
begin
  inherited Create;

  boActive := false;
  RegenedTick := mmAnsTick;

  FillChar(SelfData, SizeOf(TCreateGateData), 0);
  BasicData.BasicObjectType := boGateObject;
end;

destructor TGateObject.Destroy;
begin
  inherited destroy;
end;

function TGateObject.GetSelfData: PTCreateGateData;
begin
  Result := @SelfData;
end;

function TGateObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  i: Integer;
  SubData: TSubData;
  ItemData: TItemData;
  pUser: TUser;
  boFlag: Boolean;
  BO: TBasicObject;
  RetStr: string;
begin
  Result := PROC_FALSE;
  if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit;
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
  if Result = PROC_TRUE then exit;

  case Msg of
    FM_MOVE:
      begin
        if (SelfData.Kind = GATE_KIND_NORMAL) and (BasicData.nx = 0) and (BasicData.ny = 0) then exit;

        if CheckInArea(SenderInfo.nx, SenderInfo.ny, BasicData.x, BasicData.y, SelfData.Width) then
        begin
          BO := TBasicObject(SenderInfo.P);
          if BO = nil then exit;
          if not (BO is TUser) then exit;
          pUser := TUser(BO);

          if pUser.MovingStatus = true then
          begin
            exit;
          end;

          if boActive = false then
          begin
            pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
            case SelfData.Kind of
              GATE_KIND_NORMAL: pUser.SendClass.SendChatMessage(format('现在无法进入， %d分%d秒后才会开启', [RemainHour * 60 + RemainMin, RemainSec]), SAY_COLOR_SYSTEM);
            //  GATe_KIND_BS: pUser.SendClass.SendChatMessage(format('现在无法进入', [RemainHour * 60 + RemainMin, RemainSec]), SAY_COLOR_SYSTEM);
            end;
            exit;
          end;


          //1，脚本取代
          if FScriptClass <> nil then
          begin
            CallScriptFunction('OnGate', [integer(SenderInfo.p), integer(self)]);
            exit;
          end;
          boFlag := true;
          //2,检查元气，
          if SelfData.OverEnergy > 0 then
          begin
            if pUser.getcEnergy < SelfData.OverEnergy then
            begin
              boFlag := false;
            end;
          end;
          if boFlag then
          begin
            if SelfData.NeedAge > 0 then
            begin
              if SelfData.NeedAge <= pUser.GetAge then
              begin

              end else
              begin
                //年龄不够那物品抵消
                if SelfData.AgeNeedItem > 0 then
                begin
                  if SelfData.AgeNeedItem <= pUser.GetAge then
                  begin
                    //>=物品年龄
                    for i := 0 to 5 - 1 do
                    begin
                    //测试背包物品
                      if SelfData.NeedItem[i].rName = '' then break;
                      ItemClass.GetItemData(SelfData.NeedItem[i].rName, ItemData);
                      if ItemData.rName <> '' then
                      begin
                        ItemData.rCount := SelfData.NeedItem[i].rCount;
                        boFlag := TUser(BO).FindItem(@ItemData);
                        if boFlag = false then break;
                      end;
                    end;

                    if boFlag = true then
                    begin
                    //背包有物品，扣除物品，查找和扣除分开写，支持多个物品扣除
                      for i := 0 to 5 - 1 do
                      begin
                        if SelfData.NeedItem[i].rName = '' then break;
                        ItemClass.GetItemData(SelfData.NeedItem[i].rName, ItemData);
                        if ItemData.rName <> '' then
                        begin
                          ItemData.rCount := SelfData.NeedItem[i].rCount;
                          TUser(BO).DeleteItem(@ItemData);
                        end;
                      end;
                    end;
                  end else
                  begin
                  //使用物品年龄不够
                    boFlag := false;
                  end;
                end else
                begin
                //无使用物品年龄
                  boFlag := false;
                end;
              end;
            end;
          end;
          //3，其他要求；比如：杀死本地图怪物。
          if boFlag = true then
          begin
            if SelfData.Quest <> 0 then
            begin
              if QuestClass.CheckQuestComplete(SelfData.Quest, ServerID, RetStr) = false then
              begin
                pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
                pUser.SendClass.SendChatMessage(SelfData.QuestNotice, SAY_COLOR_SYSTEM);
                pUser.SendClass.SendChatMessage(RetStr, SAY_COLOR_SYSTEM);
                exit;
              end;
            end;
          end;

          if boFlag = true then
          begin
            case SelfData.Kind of
              GATE_KIND_NORMAL:
                begin
                //传送
                  SubData.ServerId := SelfData.TargetServerId;
                  Phone.SendMessage(SenderInfo.id, FM_GATE, BasicData, SubData);
                end;
              GATE_KIND_BS:
                begin
                                 //   pUser.SetPositionBS(SelfData.EjectX, SelfData.EjectY);
                end;
            end;
          end else
          begin
            if (SelfData.EjectX > 0) and (SelfData.EjectY > 0) then
            begin
              pUser.SetPosition(SelfData.EjectX, SelfData.EjectY);
            end;
            if SelfData.EjectNotice = '' then
            begin
              pUser.SendClass.SendChatMessage('此处为限制出入的地方，无法进入。', SAY_COLOR_SYSTEM);
            end else
            begin
              pUser.SendClass.SendChatMessage(SelfData.EjectNotice, SAY_COLOR_SYSTEM);
            end;
          end;
        end;

      end;
  end;
end;

procedure TGateObject.Initial;
var
  iNo: Integer;
begin
  inherited Initial(SelfData.Name, SelfData.ViewName);

  BasicData.id := GetNewItemId;

  if (SelfData.X <> 0) or (SelfData.Y <> 0) then
  begin
    BasicData.x := SelfData.x;
    BasicData.y := SelfData.y;
  end else
  begin
    iNo := Random(SelfData.RandomPosCount);
    BasicData.X := SelfData.RandomX[iNo];
    BasicData.Y := SelfData.RandomY[iNo];
  end;

  BasicData.nx := SelfData.targetx;
  BasicData.ny := SelfData.targety;
  BasicData.ClassKind := CLASS_GATE;
  BasicData.Feature.rrace := RACE_ITEM;
  BasicData.Feature.rImageNumber := SelfData.Shape;
  BasicData.Feature.rImageColorIndex := 0;
  BasicData.BasicObjectType := boGateObject;
  boActive := true;
  RegenedTick := mmAnsTick;

  SetScript(SelfData.Scripter, format('.\%s\%s\%s.pas', ['Script', 'Gate', SelfData.Scripter]));
end;

procedure TGateObject.StartProcess;
var
  SubData: TSubData;
begin
  inherited StartProcess;

  Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  Phone.SendMessage(0, FM_CREATE, BasicData, SubData);

  CallScriptFunction('OnRegen', [integer(self)]);
end;

procedure TGateObject.EndProcess;
var
  SubData: TSubData;
begin
  Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
  Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

  inherited EndProcess;
end;

procedure TGateObject.Update(CurTick: Integer);
begin

  if (SelfData.RegenInterval > 0) and (RegenedTick + 100 <= CurTick) then
  begin
    Manager.CalcTime(RegenedTick + SelfData.RegenInterval - CurTick, RemainHour, RemainMin, RemainSec);
  end;
  if (SelfData.RegenInterval > 0) and (RegenedTick + SelfData.RegenInterval <= CurTick) then
  begin
    RegenedTick := CurTick;
    boActive := true;
  end else
  begin
    if (SelfData.X = 0) and (SelfData.Y = 0) then
    begin
      if CurTick >= RegenedTick + SelfData.ActiveInterval then
      begin
        EndProcess;
        Initial;
        StartProcess;
      end;
      exit;
    end;
    if boActive = true then
    begin
      if (SelfData.RegenInterval > 0) and (RegenedTick + SelfData.ActiveInterval <= CurTick) then
      begin
        boActive := false;
      end;
    end;
  end;

end;

////////////////////////////////////////////////////
//
//             ===  GateList  ===
//
////////////////////////////////////////////////////

constructor TGateList.Create;
begin
  DataList := TList.Create;

  LoadFromFile('.\Setting\CreateGate.SDB');
end;

destructor TGateList.Destroy;
begin
  Clear;
  DataList.Free;

  inherited Destroy;
end;

procedure TGateList.Clear;
var
  i: Integer;
  GateObject: TGateObject;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    GateObject := DataList.Items[i];
    if GateObject.boRegisted then
    begin
      GateObject.EndProcess;
    end;
    GateObject.Free;
  end;
  DataList.Clear;
end;

function TGateList.GetCount: integer;
begin
  Result := DataList.Count;
end;

procedure TGateList.LoadFromFile(aFileName: string);
var
  i, j, xx, yy: integer;
  iName, srcstr, tokenstr: string;
  ItemData: TItemData;
  GateObject: TGateObject;
  pd: PTCreateGateData;
  DB: TUserStringDB;
  Manager: TManager;
begin
  if not FileExists(aFileName) then exit;

  DB := TUserStringDb.Create;
  DB.LoadFromFile(aFileName);

  for i := 0 to DB.Count - 1 do
  begin
    iName := DB.GetIndexName(i);

    GateObject := TGateObject.Create;
    pd := GateObject.GetSelfData;
    pd^.Show := db.GetFieldValueBoolean(iName, 'boShow');
    pd^.Name := DB.GetFieldValueString(iName, 'GateName');
    pd^.Scripter := DB.GetFieldValueString(iName, 'Scripter');

    pd^.ViewName := DB.GetFieldValueString(iName, 'ViewName');
    pd^.Kind := DB.GetFieldValueInteger(iname, 'Kind');
    pd^.MapID := DB.GetFieldValueInteger(iname, 'MapID');
    pd^.x := DB.GetFieldValueInteger(iName, 'X');
    pd^.y := DB.GetFieldValueInteger(iName, 'Y');
    pd^.targetx := DB.GetFieldValueInteger(iName, 'TX');
    pd^.targety := DB.GetFieldValueInteger(iName, 'TY');
    pd^.ejectx := DB.GetFieldValueInteger(iName, 'EX');
    pd^.ejecty := DB.GetFieldValueInteger(iName, 'EY');
    pd^.targetserverid := DB.GetFieldValueInteger(iName, 'ServerId');
    pd^.shape := DB.GetFieldValueInteger(iName, 'Shape');
    pd^.Width := DB.GetFieldValueInteger(iName, 'Width');



    pd^.OverEnergy := DB.GetFieldValueInteger(iName, 'OverEnergy');
    pd^.NeedAge := DB.GetFieldValueInteger(iName, 'NeedAge');
    pd^.AgeNeedItem := DB.GetFieldValueInteger(iName, 'AgeNeedItem');

    srcstr := DB.GetFieldValueString(iName, 'NeedItem');
    if srcstr <> '' then
    begin
      for j := 0 to 5 - 1 do
      begin
        srcstr := GetValidStr3(srcstr, tokenstr, ':');
        if tokenstr = '' then break;
        ItemClass.GetItemData(tokenstr, ItemData);
        if ItemData.rName <> '' then
        begin
          srcstr := GetValidStr3(srcstr, tokenstr, ':');
          ItemData.rCount := _StrToInt(tokenstr);
          pd^.NeedItem[j].rName := (ItemData.rName);
          pd^.NeedItem[j].rCount := ItemData.rCount;
        end;
      end;
    end;
    pd^.Quest := DB.GetFieldValueInteger(iname, 'Quest');
    pd^.QuestNotice := DB.GetFieldValueString(iname, 'QuestNotice');
    pd^.RegenInterval := DB.GetFieldValueInteger(iName, 'RegenInterval');
    pd^.ActiveInterval := DB.GetFieldValueInteger(iName, 'ActiveInterval');
    pd^.EjectNotice := DB.GetFieldValueString(iname, 'EjectNotice');

    if (pd^.X = 0) and (pd^.Y = 0) then
    begin
      pd^.RandomPosCount := 0;
      srcstr := DB.GetFieldValueString(iName, 'RandomPos');
      for j := 0 to 10 - 1 do
      begin
        srcstr := GetValidStr3(srcstr, tokenstr, ':');
        xx := _StrToInt(tokenstr);
        srcstr := GetValidStr3(srcstr, tokenstr, ':');
        yy := _StrToInt(tokenstr);
        if (xx = 0) or (yy = 0) then break;
        pd^.RandomX[j] := xx;
        pd^.RandomY[j] := yy;
        Inc(pd^.RandomPosCount);
      end;
    end;

    Manager := ManagerList.GetManagerByServerID(pd^.MapID);
    if Manager <> nil then
    begin

      GateObject.SetManagerClass(Manager);
      GateObject.Initial;
      GateObject.StartProcess;
      DataList.Add(GateObject);
    end else
    begin
      GateObject.Free;
    end;
  end;
  DB.Free;
end;

procedure TGateList.Update(CurTick: integer);
var
  i: integer;
  GateObject: TGateObject;
begin
  for i := DataList.Count - 1 downto 0 do
  begin
    GateObject := DataList.Items[i];
    if GateObject.boAllowDelete then
    begin
      GateObject.EndProcess;
      GateObject.Free;
      DataList.Delete(i);
    end;
  end;

  for i := 0 to DataList.Count - 1 do
  begin
    GateObject := DataList.Items[i];
    GateObject.Update(CurTick);
  end;
end;

function TGateList.GetItemIndex(id: integer): pointer;
begin
  result := nil;
  if (id < 0) or (id >= DataList.Count) then exit;
  result := datalist.Items[id];
end;

procedure TGateList.SetBSGateActive(boFlag: Boolean);
var
  i: integer;
  GateObject: TGateObject;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    GateObject := DataList.Items[i];
    if GateObject.SelfData.Kind = GATE_KIND_BS then
    begin
      GateObject.boActive := boFlag;
    end;
  end;
end;

////////////////////////////////////////////////////
//
//             ===  MirrorObject  ===
//
////////////////////////////////////////////////////

constructor TMirrorObject.Create;
begin
  inherited Create;

  ViewerList := TList.Create;

  FillChar(SelfData, SizeOf(TCreateMirrorData), 0);
  boActive := false;
  BasicData.BasicObjectType := boMirrorObject;
end;

destructor TMirrorObject.Destroy;
begin
  ViewerList.Free;

  inherited Destroy;
end;

procedure TMirrorObject.AddViewer(aUser: Pointer);
var
  i: Integer;
begin
  if ViewerList.IndexOf(aUser) >= 0 then exit;
  ViewerList.Add(aUser);

  TUser(aUser).SendClass.SendMap(BasicData, Manager.MapName, Manager.ObjName, Manager.RofName, Manager.TilName, Manager.SoundBase, Manager.Title);
  for i := 0 to ViewObjectList.Count - 1 do
  begin
    TUser(aUser).SendClass.SendShow(TBasicObject(ViewObjectList[i]).BasicData);
  end;
end;

function TMirrorObject.DelViewer(aUser: Pointer): Boolean;
var
  i, iNo: Integer;
  tmpManager: TManager;
  tmpViewObjectList: TList;
begin
  Result := false;

  iNo := ViewerList.IndexOf(aUser);
  if iNo < 0 then exit;

  tmpManager := TUser(aUser).Manager;
  tmpViewObjectList := TUser(aUser).ViewObjectList;

  TUser(aUser).SendClass.SendMap(TUser(aUser).BasicData, tmpManager.MapName, tmpManager.ObjName, tmpManager.RofName, tmpManager.TilName, tmpManager.SoundBase, Manager.Title);
  for i := 0 to tmpViewObjectList.Count - 1 do
  begin
    TUser(aUser).SendClass.SendShow(TBasicObject(tmpViewObjectList[i]).BasicData);
  end;

  ViewerList.Delete(iNo);

  Result := true;
end;

procedure TMirrorObject.Initial;
begin
  inherited Initial(SelfData.Name, SelfData.Name);

  BasicData.id := GetNewItemId;
  BasicData.x := SelfData.X;
  BasicData.y := SelfData.Y;
  BasicData.ClassKind := CLASS_SERVEROBJ;
  BasicData.Feature.rrace := RACE_ITEM;
  BasicData.Feature.rImageNumber := 0;
  BasicData.Feature.rImageColorIndex := 0;
  BasicData.BasicObjectType := boMirrorObject;
  boActive := SelfData.boActive;
end;

procedure TMirrorObject.StartProcess;
var
  SubData: TSubData;
begin
  inherited StartProcess;

  Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  Phone.SendMessage(0, FM_CREATE, BasicData, SubData);
end;

procedure TMirrorObject.EndProcess;
var
  SubData: TSubData;
begin
  Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
  Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

  inherited EndProcess;
end;

function TMirrorObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  i: Integer;
  User: TUser;
begin
  Result := PROC_FALSE;

  if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit;
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);

  for i := 0 to ViewerList.Count - 1 do
  begin
    User := ViewerList.Items[i];
    User.FieldProc2(hfu, Msg, SenderInfo, aSubData);
  end;
end;

procedure TMirrorObject.Update(CurTick: Integer);
begin

end;

function TMirrorObject.GetSelfData: PTCreateMirrorData;
begin
  Result := @SelfData;
end;

////////////////////////////////////////////////////
//
//             ===  MirrorList  ===
//
////////////////////////////////////////////////////

constructor TMirrorList.Create;
begin
  DataList := TList.Create;
  LoadFromFile('.\Setting\CreateMirror.SDB');
end;

destructor TMirrorList.Destroy;
begin
  Clear;
  DataList.Free;

  inherited Destroy;
end;

function TMirrorList.GetCount: integer;
begin
  Result := DataList.Count;
end;

procedure TMirrorList.Clear;
var
  i: Integer;
  MirrorObj: TMirrorObject;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    MirrorObj := DataList.Items[i];
    MirrorObj.EndProcess;
    MirrorObj.Free;
  end;
  DataList.Clear;
end;

function TMirrorList.AddViewer(aStr: string; aUser: Pointer): Boolean;
var
  i: Integer;
  MirrorObj: TMirrorObject;
begin
  Result := false;

  for i := 0 to DataList.Count - 1 do
  begin
    MirrorObj := DataList.Items[i];
    if (MirrorObj.BasicData.Name) = aStr then
    begin
      MirrorObj.AddViewer(aUser);
      Result := true;
      exit;
    end;
  end;
end;

function TMirrorList.DelViewer(aUser: Pointer): Boolean;
var
  i: Integer;
  MirrorObj: TMirrorObject;
begin
  Result := false;

  for i := 0 to DataList.Count - 1 do
  begin
    MirrorObj := DataList.Items[i];
    if MirrorObj.DelViewer(aUser) = true then
    begin
      Result := true;
      exit;
    end;
  end;
end;

procedure TMirrorList.LoadFromFile(aFileName: string);
var
  i: Integer;
  iName: string;
  DB: TUserStringDB;
  MirrorObj: TMirrorObject;
  pd: PTCreateMirrorData;
  Manager: TManager;
begin
  if not FileExists(aFileName) then exit;

  DB := TUserStringDB.Create;
  DB.LoadFromFile(aFileName);

  for i := 0 to DB.Count - 1 do
  begin
    iName := DB.GetIndexName(i);
    if iName = '' then continue;

    MirrorObj := TMirrorObject.Create;
    pd := MirrorObj.GetSelfData;

    pd^.Name := DB.GetFieldValueString(iName, 'Name');
    pd^.X := DB.GetFieldValueInteger(iName, 'X');
    pd^.Y := DB.GetFieldValueInteger(iName, 'Y');
    pd^.MapID := DB.GetFieldValueInteger(iName, 'MapID');
    pd^.boActive := DB.GetFieldValueBoolean(iName, 'boActive');

    Manager := ManagerList.GetManagerByServerID(pd^.MapID);
    if Manager <> nil then
    begin
      MirrorObj.SetManagerClass(Manager);
      MirrorObj.Initial;
      MirrorObj.StartProcess;
      DataList.Add(MirrorObj);
    end else
    begin
      MirrorObj.Free;
    end;
  end;

  DB.Free;
end;

procedure TMirrorList.Update(CurTick: integer);
var
  i: Integer;
  MirrorObj: TMirrorObject;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    MirrorObj := DataList.Items[i];
    MirrorObj.Update(CurTick);
  end;
end;

////////////////////////////////////////////////////
//
//             ===  StaticItemObject  ===
//
////////////////////////////////////////////////////

constructor TStaticItem.Create;
begin
  inherited Create;
  BasicData.BasicObjectType := boStaticItem;
end;

destructor TStaticItem.Destroy;
begin
  inherited destroy;
end;

function TStaticItem.FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  percent: integer;
begin
  Result := PROC_FALSE;
  if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit;
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
  if Result = PROC_TRUE then exit;

  case Msg of
    FM_HIT:
      begin
        if SenderInfo.id = BasicData.id then exit;
        if isHitedArea(SenderInfo.dir, SenderInfo.x, SenderInfo.y, aSubData.HitData.HitFunction, percent) then
        begin
          Dec(CurDurability, 5 * 100);
        end;
      end;
  end;
end;

procedure TStaticItem.Initial(aItemData: TItemData; aOwnerId, ax, ay: integer);
var
  str: string;
begin
  str := (aItemData.rName);
  if aItemData.rCount > 1 then str := str + ':' + IntToStr(aItemData.rCount);

  inherited Initial(str, str);
  CurDurability := 10 * 60 * 100; // 10盒悼救 绝绢瘤瘤 救澜.  10分钟

  OwnerId := aOwnerId;
  SelfItemdata := aItemData;
  BasicData.id := GetNewStaticItemId;
  BasicData.x := ax;
  BasicData.y := ay;
  BasicData.ClassKind := CLASS_STATICITEM;
  BasicData.Feature.rrace := RACE_STATICITEM;
  BasicData.Feature.rImageNumber := aItemData.rShape;
  BasicData.Feature.rImageColorIndex := aItemData.rcolor;
  BasicData.BasicObjectType := boStaticItem;
end;

procedure TStaticItem.StartProcess;
var
  SubData: TSubData;
begin
  inherited StartProcess;
  Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  Phone.SendMessage(0, FM_CREATE, BasicData, SubData);

  if SelfItemData.rSoundDrop.rWavNumber <> 0 then
  begin
        //SetWordString(SubData.SayString, IntToStr(SelfItemData.rSoundDrop.rWavNumber) + '.wav');
    SubData.sound := SelfItemData.rSoundDrop.rWavNumber;
    SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
  end;
  CallScriptFunction('OnRegen', [integer(self)]);
end;

procedure TStaticItem.EndProcess;
var
  SubData: TSubData;
begin
  if FboRegisted = FALSE then exit;

  Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
  Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);
  inherited EndProcess;
end;

procedure TStaticItem.Update(CurTick: integer);
begin
    //10分钟后 物品 消失
  if (FboAllowDelete = false) and (CreateTick + CurDurability < CurTick) then
  begin
    FboAllowDelete := TRUE;
    logItemMoveInfo('地上消失静态物品', @BasicData, nil, SelfItemData, Manager.ServerID);
  end;

end;

////////////////////////////////////////////////////
//
//             ===  StaticItemList  ===
//
////////////////////////////////////////////////////

constructor TStaticItemList.Create(aManager: TManager);
begin
  Manager := aManager;
  DataList := TList.Create;
end;

destructor TStaticItemList.Destroy;
begin
  Clear;
  DataList.Free;
  inherited destroy;
end;

procedure TStaticItemList.Clear;
var
  i: Integer;
  ItemObject: TStaticItem;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    ItemObject := DataList.Items[i];
    ItemObject.EndProcess;
    ItemObject.Free;
  end;
  DataList.Clear;
end;

function TStaticItemList.GetCount: integer;
begin
  Result := DataList.Count;
end;

{
function TStaticItemList.AllocFunction: pointer;
begin
   Result := TStaticItem.Create;
end;

procedure TStaticItemList.FreeFunction (item: pointer);
begin
   TStaticItem (item).Free;
end;
}

function TStaticItemList.AddStaticItemObject(aItemData: TItemData; aOwnerId, ax, ay: integer): integer;
var
  ItemObject: TStaticItem;
begin
  Result := PROC_FALSE;
  if DataList.count > 3000 then exit;

  if aItemData.rCount <> 1 then exit;
  if not TMaper(Manager.Maper).isMoveable(ax, ay) then exit;

  ItemObject := TStaticItem.Create;
  ItemObject.SetManagerClass(Manager);
  ItemObject.Initial(aItemData, aOwnerId, ax, ay);
  ItemObject.StartProcess;

  DataList.Add(ItemObject);
  Result := PROC_TRUE;
end;

procedure TStaticItemList.Update(CurTick: integer);
var
  i, iCount: integer;
  StaticItem: TStaticItem;
begin
{    for i := DataList.Count - 1 downto 0 do
    begin
        StaticItem := DataList.Items[i];
        if StaticItem.boAllowDelete then
        begin
            StaticItem.EndProcess;
            StaticItem.Free;
            DataList.Delete(i);
        end;
    end;

    for i := 0 to DataList.Count - 1 do
    begin
        StaticItem := DataList.Items[i];
        StaticItem.UpDate(CurTick);
    end;}
  iCount := ProcessListCount;
  if DataList.Count < iCount then
  begin
    iCount := DataList.Count;
    CurProcessPos := 0;
  end;
  for i := 0 to iCount - 1 do
  begin
    if DataList.Count = 0 then break;

    if CurProcessPos >= DataList.Count then CurProcessPos := 0;
    StaticItem := DataList[CurProcessPos];
    if StaticItem.FboAllowDelete = true then
    begin
      StaticItem.EndProcess;
      StaticItem.Free;
      DataList.Delete(CurProcessPos);
    end else
    begin
      try
        StaticItem.Update(CurTick);
        Inc(CurProcessPos);
      except
        StaticItem.FBoAllowDelete := true;
        frmMain.WriteLogInfo(format('TStaticItemList.Update (%s) failed', [StaticItem.SelfItemData.rName]));
      end;
    end;
  end;
end;

////////////////////////////////////////////////////
//
//             ===  DynamicItemObject  ===
//
////////////////////////////////////////////////////

constructor TDynamicObject.Create;
begin
  inherited Create;
  BasicData.BasicObjectType := boDynamicObject;
  ShowHideTick := 0;
  OpenedTick := 0;
  EventItemCount := 0;
  StepCount := 0;
  ObjectStatus := dos_Closed;
  MemberList := nil;
  DragDropEvent := nil;
end;

destructor TDynamicObject.Destroy;
var
  i: Integer;
  AttackSkill: TAttackSkill;
  BO: TBasicObject;
begin
  if DragDropEvent <> nil then DragDropEvent.Free;
  if MemberList <> nil then
  begin
    for i := MemberList.Count - 1 downto 0 do
    begin
      BO := MemberList[i];
      if BO <> nil then
      begin
        AttackSkill := nil;
        if BO.BasicData.Feature.rRace = RACE_MONSTER then
        begin
          AttackSkill := TMonster(BO).GetAttackSkill;
        end else if BO.BasicData.Feature.rRace = RACE_NPC then
        begin
          AttackSkill := TNpc(BO).GetAttackSkill;
        end;
        if AttackSkill <> nil then
        begin
          AttackSkill.SetObjectBoss(nil);
        end;
      end;
    end;
    MemberList.Clear;
    MemberList.Free;
  end;
  inherited destroy;
end;

procedure TDynamicObject.MemberDie(aBasicObject: TBasicObject);
var
  i, j: Integer;
begin
  if MemberList = nil then exit;
  for i := 0 to MemberList.Count - 1 do
  begin
    if aBasicObject = MemberList[i] then
    begin
      if aBasicObject.BasicData.Feature.rfeaturestate <> wfs_die then
      begin
        CurLife := SelfData.rBasicData.rLife;
      end else
      begin
        for j := 0 to 5 - 1 do
        begin //召唤出的 死1个，删除1个配置表
          if (aBasicObject.BasicData.Name) = SelfData.rDropMop[j].rName then
          begin
            SelfData.rDropMop[j].rName := '';
            break;
          end;
          if (aBasicObject.BasicData.Name) = SelfData.rCallNpc[j].rName then
          begin
            SelfData.rCallNpc[j].rName := '';
            break;
          end;
        end;
      end;
      MemberList.Delete(i);
      break;
    end;
  end;
end;

function TDynamicObject.getEStep(aState, astep: integer): integer;
begin
  RESULT := 0;
  if (aState < 0) or (aState >= 3) then exit;
  if (astep <= 0) or (astep >= 5) then exit;

  RESULT := SelfData.rBasicData.rEStep[aState, astep - 1];
end;

function TDynamicObject.getSStep(aState, astep: integer): integer;
begin
  RESULT := 0;
  if (aState < 0) or (aState >= 3) then exit;
  if (astep <= 0) or (astep >= 5) then exit;
  RESULT := SelfData.rBasicData.rsStep[aState, astep - 1];
end;

procedure TDynamicObject.SetObjectStatus(aObjectStatus: TDynamicObjectState);
var
  SubData: TSubData;
begin
   // if ObjectStatus = aObjectStatus then exit;

  case aObjectStatus of
    dos_Closed: //逐步 关闭
      begin
        dec(StepCount);
        if StepCount <= 0 then
        begin
          StepCount := 1;
          ObjectStatus := dos_Closed;
        end;
        BasicData.Feature.rHitMotion := 1;

        BasicData.nx := getSStep(byte(dos_Closed), StepCount);
        BasicData.ny := getEStep(byte(dos_Closed), StepCount);

//                BasicData.nx := SelfData.rBasicData.rSStep[byte(dos_Closed), 1];
 //               BasicData.ny := SelfData.rBasicData.rEStep[byte(dos_Closed), 1];
        SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);

      end;
    dos_Openning: //逐步 打开
      begin
        if ObjectStatus = dos_Openned then exit;
        INC(StepCount);
        ObjectStatus := dos_Openning;
        if StepCount >= SelfData.rBasicData.rStepCount then
        begin
          StepCount := SelfData.rBasicData.rStepCount;
          ObjectStatus := dos_Openning;
        end;

        BasicData.Feature.rHitMotion := 1;
        BasicData.nx := getSStep(byte(dos_Openning), StepCount);
        BasicData.ny := getEStep(byte(dos_Openning), StepCount);
//                BasicData.nx := SelfData.rBasicData.rSStep[byte(dos_Openning), 1];
//                BasicData.ny := SelfData.rBasicData.rEStep[byte(dos_Openning), 1];
        SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
             //   OpenedTick := mmAnsTick;

        OpenedPosX := BasicData.X;
        OpenedPosY := BasicData.Y;
        if StepCount >= SelfData.rBasicData.rStepCount then SetObjectStatus(dos_Openned);
      end;
    dos_Openned: //直接 打开
      begin
        if ObjectStatus = dos_Openned then exit;
        StepCount := SelfData.rBasicData.rStepCount;
        ObjectStatus := dos_Openned;


        BasicData.Feature.rHitMotion := 1;
        BasicData.nx := getSStep(byte(dos_Openned), StepCount);
        BasicData.ny := getEStep(byte(dos_Openned), StepCount);

        SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
        OpenedTick := mmAnsTick;

        OpenedPosX := BasicData.X;
        OpenedPosY := BasicData.Y;

      end;


    dos_Scroll:
      begin

      end;
  end;


end;

function TDynamicObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  i, j: Integer;
  Sayer, SayStr, Str, dummy1, dummy2: string;
  percent: Integer;
  SubData: TSubData;
  ItemData: TItemData;
  CurTick, SkillLevel: Integer;
  BO, BO2: TBasicObject;
  Monster: TMonster;
  Npc: TNpc;
  boFlag: boolean;
  AttackSkill: TAttackSkill;
  xx, yy: Integer;
  procedure _dropitem();
  var
    n: integer;
  begin
    xx := BasicData.nx;
    yy := BasicData.ny;
    BasicData.nx := SenderInfo.x;
    BasicData.ny := SenderInfo.y;
        //给的
    for n := low(SelfData.rGiveItem) to high(SelfData.rGiveItem) do
    begin
      if SelfData.rGiveItem[n].rName = '' then break;
      ItemClass.GetChanceItemData((BasicData.Name), SelfData.rGiveItem[n].rName, ItemData);
      NewItemSet(_nist_all, ItemData); //打编号
      ItemData.rCount := SelfData.rGiveItem[n].rCount;
//            ItemData.rOwnerName := '';

      SubData.ItemData := ItemData;
      SubData.ServerId := ServerId;
      if ItemData.rKind = ITEM_KIND_QUEST then
        TFieldPhone(Manager.Phone).SendMessage(SenderInfo.id, FM_ADDITEM, BasicData, SubData)
      else Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
    end;
        //掉落
    if SelfData.rBasicData.rboRemove = true then
    begin
      for n := low(SelfData.rDropItem) to high(SelfData.rDropItem) do
      begin
        if SelfData.rDropItem[n].rName = '' then break;
        if ItemClass.GetCheckItemData((BasicData.Name), SelfData.rDropItem[n], ItemData) = true then
        begin
          NewItemSet(_nist_all, ItemData);
//                    ItemData.rOwnerName := '';
          SubData.ItemData := ItemData;
          SubData.ServerId := ServerId;

          if ItemData.rKind = ITEM_KIND_QUEST then
            TFieldPhone(Manager.Phone).SendMessage(SenderInfo.id, FM_ADDITEM, BasicData, SubData)
          else Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
        end;
      end;
    end;
    BasicData.nx := xx;
    BasicData.ny := yy;
  end;

begin
  Result := PROC_FALSE;
  if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit;
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
  if Result = PROC_TRUE then exit;

  CurTick := mmAnsTick;
  case Msg of
    FM_HEAL: //治疗
      begin
        if ObjectStatus = dos_Openned then exit;

        CurLife := CurLife + aSubData.HitData.ToHit;
        if CurLife > SelfData.rBasicData.rLife then CurLife := SelfData.rBasicData.rLife;
        if CurLife > 0 then
        begin
          SubData.Percent := CurLife * 100 div SelfData.rBasicData.rLife;
          SendLocalMessage(NOTARGETPHONE, FM_LIFEPERCENT, BasicData, SubData);
        end;
      end;
    FM_SAY:
      begin
        if ObjectStatus = dos_Openned then exit;
        if (SelfData.rBasicData.rKind and DYNOBJ_EVENT_SAY) = DYNOBJ_EVENT_SAY then
        begin
          if SelfData.rBasicData.rEventSay = '' then exit;
          Str := GetWordString(aSubData.SayString);
          if ReverseFormat(Str, '%s: ' + SelfData.rBasicData.rEventSay, Sayer, dummy1, dummy2, 1) then
          begin
            if SelfData.rBasicData.rSoundSpecial.rWavNumber > 0 then
            begin
                            //SetWordString(SubData.SayString, IntToStr(SelfData.rBasicData.rSoundSpecial.rWavNumber) + '.wav');
              SubData.sound := SelfData.rBasicData.rSoundSpecial.rWavNumber;
              SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
            end;

            SetWordString(SubData.SayString, (BasicData.ViewName) + ': ' + SelfData.rBasicData.rEventAnswer);
            SendLocalMessage(NOTARGETPHONE, FM_SAY, BasicData, SubData);
          end;
          exit;
        end;
      end;
    FM_ADDITEM:
      begin
        if ObjectStatus = dos_Openned then exit;
        if (SelfData.rBasicData.rKind and DYNOBJ_EVENT_ADDITEM) = DYNOBJ_EVENT_ADDITEM then
        begin
          if DragDropEvent.EventAddItem((aSubData.ItemData.rName), SenderInfo) = true then exit;

          if (aSubData.ItemData.rName) <> SelfData.rBasicData.rEventItem.rName then exit; //启动 物品
          Inc(EventItemCount);

          if EventItemCount >= SelfData.rBasicData.rEventItem.rCount then
          begin
                        {if SelfData.rBasicData.rEventDropItem.rName = '' then
                        begin}
            if SelfData.rBasicData.rSoundEvent.rWavNumber > 0 then
            begin
                                //SetWordString(SubData.SayString, IntToStr(SelfData.rBasicData.rSoundSpecial.rWavNumber) + '.wav');
              SubData.sound := SelfData.rBasicData.rSoundSpecial.rWavNumber;
              SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
            end;
                         {   ObjectStatus := dos_Openning;
                            BasicData.Feature.rHitMotion := 0;
                           // BasicData.nx := SelfData.rBasicData.rSStep[byte(dos_Openning), 1];
                           // BasicData.ny := SelfData.rBasicData.rEStep[byte(dos_Openning), 1];
                            SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);

                            ObjectStatus := dos_Openned;
                            BasicData.Feature.rHitMotion := 1;
                           // BasicData.nx := SelfData.rBasicData.rSStep[byte(dos_Openned), 1];
                           // BasicData.ny := SelfData.rBasicData.rEStep[byte(dos_Openned), 1];
                            SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                          }

            SetObjectStatus(dos_Openning);
            if ObjectStatus <> dos_Openned then SetObjectStatus(dos_Openned);
            _dropitem;
            CallScriptFunction('OnTurnOn', [integer(SenderInfo.P), integer(self)]);

            OpenedPosX := SenderInfo.X;
            OpenedPosY := SenderInfo.Y;

                       { end else
                        begin                                                   //人丢件东西给动态物体。动态物体掉1件东西出来。
                            BasicData.nX := BasicData.X;
                            BasicData.nY := BasicData.Y;

                            if SelfData.rBasicData.rSoundSpecial.rWavNumber > 0 then
                            begin
                                //SetWordString(SubData.SayString, IntToStr(SelfData.rBasicData.rSoundSpecial.rWavNumber) + '.wav');
                                SubData.sound := SelfData.rBasicData.rSoundSpecial.rWavNumber;
                                SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
                            end;
                            if ItemClass.GetCheckItemData((BasicData.Name), SelfData.rBasicData.rEventDropItem, ItemData) = true then
                            begin
                                CurLife := CurLife + 1000;
                                ItemData.rCount := SelfData.rBasicData.rEventDropItem.rCount;
                                ItemData.rOwnerName := '';
                                SubData.ItemData := ItemData;
                                SubData.ServerId := ServerId;
                                Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
                            end;
                        end;
                        }
            EventItemCount := 0;

          end;
          Move(aSubData.ItemData, SubData.ItemData, SizeOf(TItemData));
          SendLocalMessage(SenderInfo.ID, FM_DELITEM, BasicData, SubData);
        end;
      end;
    FM_BOW:
      begin
        if SenderInfo.id = BasicData.id then exit;
        if SenderInfo.Feature.rRace <> RACE_HUMAN then exit;
        if ObjectStatus = dos_Openned then exit;
        if (SelfData.rBasicData.rKind and DYNOBJ_EVENT_BOW) = DYNOBJ_EVENT_BOW then
        begin

          if (aSubData.TargetId <> Basicdata.id) then exit;
          if aSubData.SubName = '火箭' then setObjectStatus(dos_Openning);
          if ObjectStatus = dos_Openned then
          begin
            _dropitem;
            CallScriptFunction('OnTurnOn', [integer(SenderInfo.P), integer(self)]);

          end;
                  //  CallScriptFunction('OnDanger', [integer(SenderInfo.p), integer(self), aSubData.SubName]);
        end;

      end;
    FM_HIT:
      begin
        if SenderInfo.id = BasicData.id then exit;
        if SenderInfo.Feature.rRace <> RACE_HUMAN then exit;

        if ObjectStatus = dos_Openned then exit;
        if (SelfData.rBasicData.rKind and DYNOBJ_EVENT_HIT) = DYNOBJ_EVENT_HIT then
        begin
          if isHitedArea(SenderInfo.dir, SenderInfo.x, SenderInfo.y, aSubData.HitData.HitFunction, percent) then
          begin
            BO := GetViewObjectByID(SenderInfo.ID);
            if BO = nil then exit;
            if BO.BasicData.Feature.rRace <> RACE_HUMAN then exit;

            if SelfData.rBasicData.rLife = CurLife then
            begin
                        ////////////////////////////////
                        //           满血召唤怪物
              CallScriptFunction('OnCallObject', [integer(SenderInfo.P), integer(self)]);
              for i := 0 to 5 - 1 do
              begin
                if SelfData.rDropMop[i].rName = '' then continue;
                for j := 0 to SelfData.rDropMop[i].rCount - 1 do
                begin
                  xx := BasicData.x;
                  yy := BasicData.y;
                  if (SelfData.rDropX <> 0) and (SelfData.rDropY <> 0) then
                  begin
                    xx := SelfData.rDropX;
                    yy := SelfData.rDropY;
                  end;
                  Monster := TMonsterList(Manager.MonsterList).CallMonster(SelfData.rDropMop[i].rName, xx, yy, 4, (SenderInfo.Name));
                  if Monster <> nil then
                  begin
                    Monster.boDieDelete := true;
                    AttackSkill := Monster.GetAttackSkill;
                    if AttackSkill <> nil then
                    begin
                      AttackSkill.SetTargetID(SenderInfo.id, true);
                    end;
                  end;
                                    {
                                    end else
                                    begin
                                        Maper.GetMoveableXY(xx, yy, 10);
                                    end;

                                    if Maper.isMoveable(xx, yy) then
                                    begin                                       //召唤 就是创建 （怪物致死追杀 当前人；完成任务后自己销毁）
                                        Monster := TMonsterList(Manager.MonsterList).CallMonster(SelfData.rDropMop[i].rName, xx, yy, 4, (SenderInfo.Name));
                                        if Monster <> nil then
                                        begin
                                            Monster.boDieDelete := true;

                                            AttackSkill := Monster.GetAttackSkill;
                                            if AttackSkill <> nil then
                                            begin
                                                AttackSkill.SetObjectBoss(Self);
                                            end;
                                            if MemberList = nil then
                                            begin
                                                MemberList := TList.Create;
                                            end;
                                            MemberList.Add(Monster);
                                        end;
                                    end;
                                    }
                end;
              end;
              for i := 0 to 5 - 1 do //召唤NPC
              begin
                if SelfData.rCallNpc[i].rName = '' then continue;
                for j := 0 to SelfData.rCallNpc[i].rCount - 1 do
                begin
                  xx := BasicData.x;
                  yy := BasicData.y;
                  if (SelfData.rDropX <> 0) and (SelfData.rDropY <> 0) then
                  begin
                    xx := SelfData.rDropX;
                    yy := SelfData.rDropY;
                  end;
                  Npc := TNpcList(Manager.NpcList).CallNpc(SelfData.rCallNpc[i].rName, xx, yy, 4, (SenderInfo.Name), BasicData.Feature.rnation, BasicData.MapPathID);
                  if Npc <> nil then
                  begin
                    Npc.boDieDelete := true;
                    AttackSkill := Npc.GetAttackSkill;
                    if AttackSkill <> nil then
                    begin
                      AttackSkill.SetTargetID(SenderInfo.id, true);
                    end;
                  end;
                                        {
                                    end else
                                    begin
                                        Maper.GetMoveableXY(xx, yy, 10);
                                    end;
                                    if Maper.isMoveable(xx, yy) then
                                    begin                                       //召唤 就是创建 （致死追杀 当前人；完成任务后自己销毁）
                                        Npc := TNpcList(Manager.NpcList).CallNpc(SelfData.rCallNpc[i].rName, xx, yy, 4, (SenderInfo.Name), BasicData.Feature.rnation, BasicData.MapPathID);
                                        if Npc <> nil then
                                        begin
                                            Npc.boDieDelete := true;
                                            AttackSkill := Npc.GetAttackSkill;
                                            if AttackSkill <> nil then
                                            begin
                                                AttackSkill.SetObjectBoss(Self);
                                            end;
                                            if MemberList = nil then
                                            begin
                                                MemberList := TList.Create;
                                            end;
                                            MemberList.Add(Npc);
                                        end;
                                    end;
                                    }
                end;
              end;
            end else
            begin
                        ////////////////////////////////
                        //           非满血
              if MemberList <> nil then
              begin
                for i := 0 to MemberList.Count - 1 do
                begin //（改变 成员攻击目标）
                  BO2 := MemberList[i];
                  if BO2 <> nil then
                  begin
                    if BO2.BasicData.Feature.rRace = RACE_NPC then
                    begin
                      AttackSkill := TNpc(BO2).GetAttackSkill;
                    end else
                    begin
                      AttackSkill := TMonster(BO2).GetAttackSkill;
                    end;
                    AttackSkill.SetDeadAttackName((SenderInfo.Name)); //死追杀 攻击者
                  end;
                end;
              end;
            end;
                        //正常被攻击处理
            i := aSubData.HitData.damageBody;
            i := i - SelfData.rBasicData.rArmor;
            if i < 0 then i := 1;
            CurLife := CurLife - i;
            if CurLife < 0 then CurLife := 0;
            if CurLife > 0 then
            begin
              SubData.Percent := CurLife * 100 div SelfData.rBasicData.rLife;
              SendLocalMessage(NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
            end;

            if SelfData.rBasicData.rSoundSpecial.rWavNumber > 0 then
            begin
                            //SetWordString(SubData.SayString, IntToStr(SelfData.rBasicData.rSoundSpecial.rWavNumber) + '.wav');
              SubData.sound := SelfData.rBasicData.rSoundSpecial.rWavNumber;
              SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
            end;

            if CurLife > 0 then exit; //没死 直接推出
                       ///////////////////////////////
                       //         自己死亡
                      //  CallScriptFunction('OnDestroy', [integer(SenderInfo.p), integer(self)]);
                       //年龄要求
            if SelfData.rNeedAge <> 0 then
            begin
              if TUser(BO).GetAge < SelfData.rNeedAge then
              begin
                TUser(BO).SendClass.SendChatMessage(format('%d岁以上方可开启', [SelfData.rNeedAge]), SAY_COLOR_SYSTEM);
                exit;
              end;
            end;
                        //武功要求
            for i := 0 to 5 - 1 do
            begin
              if SelfData.rNeedSkill[i].rName = '' then break;
              SkillLevel := TUser(BO).FindHaveMagicByName(SelfData.rNeedSkill[i].rName);
              if SelfData.rNeedSkill[i].rLevel > SkillLevel then
              begin
                TUser(BO).SendClass.SendChatMessage(format('%s修练值 %s 以上的人方可开启', [SelfData.rNeedSkill[i].rName, Get10000To100(SelfData.rNeedSkill[i].rLevel)]), SAY_COLOR_SYSTEM);
                exit;
              end;
            end;
                        //检查 开启 必须物品 扣用户
            for i := 0 to 5 - 1 do
            begin
              if SelfData.rNeedItem[i].rName = '' then break;
              ItemClass.GetItemData(SelfData.rNeedItem[i].rName, ItemData);
              if ItemData.rName <> '' then
              begin
                ItemData.rCount := SelfData.rNeedItem[i].rCount;
                boFlag := TUser(BO).FindItem(@ItemData);
                if boFlag = false then
                begin
                  TUser(BO).SendClass.SendChatMessage(format('%s 物品需要 %d个', [(ItemData.rName), ItemData.rCount]), SAY_COLOR_SYSTEM);
                  exit;
                end;
              end;
            end;
                        //扣除 开启 必须物品 扣用户
            for i := 0 to 5 - 1 do
            begin
              if SelfData.rNeedItem[i].rName = '' then break;
              ItemClass.GetItemData(SelfData.rNeedItem[i].rName, ItemData);
              if ItemData.rName <> '' then
              begin
                ItemData.rCount := SelfData.rNeedItem[i].rCount;
                TUser(BO).DeleteItem(@ItemData);
              end;
            end;
                        /////////////////////////////////////////////
                        //                打开

            SetObjectStatus(dos_Openning);
            if ObjectStatus <> dos_Openned then SetObjectStatus(dos_Openned);

                     {                           ObjectStatus := dos_Openned;
                        BasicData.Feature.rHitMotion := 0;
                       // BasicData.nx := SelfData.rBasicData.rSStep[byte(dos_Openning), 1];
                      //  BasicData.ny := SelfData.rBasicData.rEStep[byte(dos_Openning), 1];
                        SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);


                     //   if (SelfData.rBasicData.rSStep[byte(dos_Openned), 1] <> 0) and
                     //   (SelfData.rBasicData.rEStep[byte(dos_Openned), 1] <> 0) then
                        begin
                            ObjectStatus := dos_Openned;
                            BasicData.Feature.rHitMotion := 1;
                        //    BasicData.nx := SelfData.rBasicData.rSStep[byte(dos_Openned), 1];
                       //     BasicData.ny := SelfData.rBasicData.rEStep[byte(dos_Openned), 1];
                            SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                        end;
                        }
            _dropitem;
            CallScriptFunction('OnTurnOn', [integer(SenderInfo.P), integer(self)]);
                      //  OpenedTick := CurTick;
            OpenedPosX := SenderInfo.X;
            OpenedPosY := SenderInfo.Y;
                       /////////////////////////////////

              {          xx := BasicData.nx;
                        yy := BasicData.ny;
                        BasicData.nx := SenderInfo.x;
                        BasicData.ny := SenderInfo.y;


                        //破坏后出物品
                        for i := 0 to 5 - 1 do
                        begin
                            if SelfData.rGiveItem[i].rName = '' then break;
                            ItemClass.GetChanceItemData((BasicData.Name), SelfData.rGiveItem[i].rName, ItemData);
                            NewItemSet(_nist_all, ItemData);                    //打编号
                            ItemData.rCount := SelfData.rGiveItem[i].rCount;
                            ItemData.rOwnerName := '';

                            SubData.ItemData := ItemData;
                            SubData.ServerId := ServerId;
                            if ItemData.rKind = ITEM_KIND_QUEST then
                            begin
                                TFieldPhone(Manager.Phone).SendMessage(SenderInfo.id, FM_ADDITEM, BasicData, SubData);
                            end
                            else
                            begin
                                if TFieldPhone(Manager.Phone).SendMessage(SenderInfo.id, FM_ENOUGHSPACE, BasicData, SubData) = PROC_FALSE then
                                begin
                                    Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
                                end else
                                begin
                                    TFieldPhone(Manager.Phone).SendMessage(SenderInfo.id, FM_ADDITEM, BasicData, SubData);
                                end;
                            end;
                        end;
                        BasicData.nx := xx;
                        BasicData.ny := yy;
                        }
          end;
        end;
      end;
  end;
end;

procedure TDynamicObject.Initial(pObjectData: PTCreateDynamicObjectData);
var
  i: Integer;
begin
  if pObjectData = nil then
  begin
    frmMain.WriteLogInfo('TDynamicObject.Initial() pObjectData=NIL Error ()');
    exit;
  end;
  inherited Initial(pObjectData^.rBasicData.rName, pObjectData^.rBasicData.rViewName);

  Move(pObjectData^, SelfData, sizeof(TCreateDynamicObjectData));


  BasicData.id := GetNewDynamicObjectId;
  BasicData.x := pObjectData^.rx[0];
  BasicData.y := pObjectData^.ry[0];
  BasicData.ClassKind := CLASS_DYNOBJECT;
  BasicData.Feature.rrace := RACE_DYNAMICOBJECT;
  BasicData.Feature.rImageNumber := pObjectData^.rBasicData.rShape;
  BasicData.BasicObjectType := boDynamicObject;

  ObjectStatus := dos_Closed;
  StepCount := 1;
  BasicData.Feature.rHitMotion := 1;
  BasicData.nx := getSStep(byte(dos_Closed), StepCount);
  BasicData.ny := getEStep(byte(dos_Closed), StepCount);
//    BasicData.nx := pObjectData^.rBasicData.rSStep[byte(dos_Closed), 1];
 //   BasicData.ny := pObjectData^.rBasicData.rEStep[byte(dos_Closed), 1];



  FboHaveGuardPos := TRUE;
  for i := 0 to 10 - 1 do
  begin
    BasicData.GuardX[i] := pObjectData^.rBasicData.rGuardX[i];
    BasicData.GuardY[i] := pObjectData^.rBasicData.rGuardY[i];
  end;

  CurLife := pObjectData^.rBasicData.rLife;

  if DragDropEvent = nil then
  begin
    DragDropEvent := TDragDropEvent.Create(Self);
  end;
  ShowHideTick := 0;
  SetScript(SelfData.rBasicData.rScripter, format('.\%s\%s\%s.pas', ['Script', 'Dynamic', SelfData.rBasicData.rScripter]));
end;

procedure TDynamicObject.StartProcess;
var
  SubData: TSubData;
  i, x, y, c, cmax: Integer;
begin
  StepCount := 0;
  cmax := 0;
  for i := 0 to 5 - 1 do
  begin
    if (SelfData.rX[i] = 0) and (SelfData.rY[i] = 0) then
    begin
      break;
    end;
    inc(cmax);
  end;

  c := Random(cmax);
  x := SelfData.rX[c];
  y := SelfData.rY[c];
    // if not TMaper(Manager.Maper).isMoveable (x, y) then exit;
  if SelfData.rWidth > 0 then
  begin
    x := x - SelfData.rWidth + Random(SelfData.rWidth * 2);
    y := y - SelfData.rWidth + Random(SelfData.rWidth * 2);
  end;

  BasicData.X := x;
  BasicData.Y := y;

  inherited StartProcess;

  Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  Phone.SendMessage(0, FM_CREATE, BasicData, SubData);

  if SelfData.rBasicData.rSoundSpecial.rWavNumber <> 0 then
  begin
        //SetWordString(SubData.SayString, IntToStr(SelfData.rBasicData.rSoundSpecial.rWavNumber) + '.wav');
    SubData.sound := SelfData.rBasicData.rSoundSpecial.rWavNumber;
    SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
  end;

end;

procedure TDynamicObject.EndProcess;
var
  SubData: TSubData;
begin
  if FboRegisted = FALSE then exit;

  Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
  Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

  inherited EndProcess;
end;

function TDynamicObject.GetCsvStr: string;
var
  itemdata: titemdata;
  n: integer;
  str: string;
begin
  if SelfData.rBasicData.rViewName <> '' then
    result := SelfData.rBasicData.rViewName + ','
  else result := SelfData.rBasicData.rName + ',';
  result := result + inttostr(SelfData.rX[0]) + ';' + inttostr(SelfData.rX[0]) + ',';
  str := '';
  for n := low(SelfData.rGiveItem) to high(SelfData.rGiveItem) do
  begin
    if SelfData.rGiveItem[n].rName = '' then break;
    if ItemClass.GetItemData(SelfData.rGiveItem[n].rName, ItemData) then
    begin
      str := str + ItemData.rViewName + '、';
    end;
  end;
  result := result + str + ',';
  str := '';
  for n := low(SelfData.rDropItem) to high(SelfData.rDropItem) do
  begin
    if SelfData.rDropItem[n].rName = '' then break;
    if ItemClass.GetItemData(SelfData.rDropItem[n].rName, ItemData) then
    begin
      str := str + ItemData.rViewName + '、';
    end;
  end;
  result := result + str + ',';
end;

//生产帮助 需要 召唤出所有怪物

procedure TDynamicObject.DropMop(outList: tlist);
var
  i, j, xx, yy: integer;
  Monster: tMonster;
  npc: tnpc;
begin
  for i := 0 to 5 - 1 do
  begin
    if SelfData.rDropMop[i].rName = '' then continue;
    for j := 0 to SelfData.rDropMop[i].rCount - 1 do
    begin
      xx := BasicData.x;
      yy := BasicData.y;
      if (SelfData.rDropX <> 0) and (SelfData.rDropY <> 0) then
      begin
        xx := SelfData.rDropX;
        yy := SelfData.rDropY;
      end;
      Monster := TMonsterList(Manager.MonsterList).CallMonster(SelfData.rDropMop[i].rName, xx, yy, 4, '');
      if Monster <> nil then outList.add(Monster);
    end;
  end;

end;

procedure TDynamicObject.Regen();
begin
  EndProcess;
  CurLife := SelfData.rBasicData.rLife;

  ObjectStatus := dos_Closed;
  BasicData.Feature.rHitMotion := 1;
  StepCount := 1;

  BasicData.nx := getSStep(byte(dos_Closed), StepCount);
  BasicData.ny := getEStep(byte(dos_Closed), StepCount);

  if (SelfData.rboDelay) and (ShowHideTick = 0) then
  begin
    ShowHideTick := mmAnsTick
  end
  else
  begin
    StartProcess;
  end;

  CallScriptFunction('OnRegen', [integer(self)]);
end;

procedure TDynamicObject.Update(CurTick: integer);
var
  i, xx, yy: Integer;
  ItemData: TItemData;
  SubData: TSubData;
begin
  if (SelfData.rBasicData.rShowInterval > 0) and (SelfData.rBasicData.rHideInterval > 0) then
  begin
        //延时差开关物体
    if FboRegisted = true then
    begin
      if CurTick >= FCreateTick + SelfData.rBasicData.rShowInterval then
      begin
        EndProcess;
        ShowHideTick := CurTick;
      end;
    end else
    begin
      if CurTick >= ShowHideTick + SelfData.rBasicData.rHideInterval then
      begin
        CurLife := SelfData.rBasicData.rLife;
        ObjectStatus := dos_Closed;
        BasicData.Feature.rHitMotion := 1;
        StepCount := 1;
        BasicData.nx := getSStep(byte(dos_Closed), StepCount);
        BasicData.ny := getEStep(byte(dos_Closed), StepCount);
        StartProcess;
      end;
    end;
    exit;
  end;

  if FboRegisted = true then
  begin

    if ObjectStatus <> dos_Openned then
    begin
           //关闭的
      if DragDropEvent <> nil then
      begin
        DragDropEvent.EventSay(CurTick);
      end;
      exit;
    end;

        //打开的
    if SelfData.rBasicData.rboRemove = true then
    begin
            //打开，时间到后自己销毁
      if OpenedTick + SelfData.rBasicData.rOpennedInterval <= CurTick then
      begin
                {xx := BasicData.nx;
                yy := BasicData.ny;
                BasicData.nx := OpenedPosX;
                BasicData.ny := OpenedPosY;
                for i := 0 to 5 - 1 do
                begin
                    if SelfData.rDropItem[i].rName = '' then break;
                    if ItemClass.GetCheckItemData((BasicData.Name), SelfData.rDropItem[i], ItemData) = true then
                    begin
                        ItemData.rOwnerName := '';
                        SubData.ItemData := ItemData;
                        SubData.ServerId := ServerId;

                        Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
                    end;
                end;
                BasicData.nx := xx;
                BasicData.ny := yy;
                }
        if SelfData.rBasicData.rRegenInterval = 0 then
        begin
                //一次性，打开后删除
          FboAllowDelete := true;
        end else
        begin
                //销毁，等待复活
          EndProcess;
        end;
      end;
    end else
    begin
            //复活
      if OpenedTick + SelfData.rBasicData.rOpennedInterval <= CurTick then
      begin
        OpenedTick := CurTick;
                    {
                    ObjectStatus := dos_Closed;
                    BasicData.Feature.rHitMotion := 1;
                    //BasicData.nx := SelfData.rBasicData.rSStep[byte(dos_Closed), 1];
                   // BasicData.ny := SelfData.rBasicData.rEStep[byte(dos_Closed), 1];
                    SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                     }
                //逐步关闭
        SetObjectStatus(dos_Closed);
        if ObjectStatus = dos_Closed then
        begin
          CurLife := SelfData.rBasicData.rLife;
          CallScriptFunction('OnTurnoff', [integer(self)]);
        end;
      end;
    end;

  end else
  begin

    if (ObjectStatus <> dos_Closed) and (SelfData.rBasicData.rRegenInterval > 0) then
    begin
      if OpenedTick + SelfData.rBasicData.rRegenInterval <= CurTick then
      begin
            //一步关闭，复活

        CurLife := SelfData.rBasicData.rLife;

        ObjectStatus := dos_Closed;
        BasicData.Feature.rHitMotion := 1;
        StepCount := 1;
        BasicData.nx := getSStep(byte(dos_Closed), StepCount);
        BasicData.ny := getEStep(byte(dos_Closed), StepCount);
        StartProcess;
        CallScriptFunction('OnTurnoff', [integer(self)]);

      end;
    end;
  end;


end;

////////////////////////////////////////////////////
//
//             ===  DynamicObjectList  ===
//
////////////////////////////////////////////////////

constructor TDynamicObjectList.Create(aManager: TManager);
begin
  Manager := aManager;
  DataList := TList.Create;

   // LoadFromFile;
end;

destructor TDynamicObjectList.Destroy;
begin
  Clear;
  DataList.Free;
  inherited destroy;
end;




procedure TDynamicObjectList.Clear;
var
  i: Integer;
  DynamicObject: TDynamicObject;
begin
  for i := DataList.Count - 1 downto 0 do
  begin
    DynamicObject := DataList.Items[i];
    DynamicObject.EndProcess;
    DynamicObject.Free;
    DataList.Delete(i);
  end;
  DataList.Clear;
end;

procedure TDynamicObjectList.DropMop(outList: tlist);
var
  i: Integer;
  DynamicObject: TDynamicObject;
begin
  for i := DataList.Count - 1 downto 0 do
  begin
    DynamicObject := DataList.Items[i];
    DynamicObject.DropMop(outList);
  end;

end;

procedure TDynamicObjectList.Regen;
var
  i: Integer;
  DynamicObject: TDynamicObject;
begin
  for i := DataList.Count - 1 downto 0 do
  begin
    DynamicObject := DataList.Items[i];
    DynamicObject.Regen;
  end;

end;

procedure TDynamicObjectList.ReLoad;
var
  i, n: integer;
  DynamicObject: TDynamicObject;
  pd: PTCreateDynamicObjectData;
begin
  Clear;
  if Manager.DynamicCreateClass_p = nil then exit;
  n := Manager.DynamicCreateClass_p.getCount;
  for i := 0 to n - 1 do
  begin
    pd := Manager.DynamicCreateClass_p.get(i);
    if pd <> nil then
    begin
      DynamicObject := TDynamicObject.Create;
      DynamicObject.SetManagerClass(Manager);
      DynamicObject.Initial(pd);
      DynamicObject.Regen;
      DataList.Add(DynamicObject);
    end;
  end;

end;

{
var
    i: integer;
    FileName: string;
    DynamicObject: TDynamicObject;
    CreateDynamicObjectList: TList;
    pd: PTCreateDynamicObjectData;
begin
    Clear;

    FileName := format('.\Setting\CreateDynamicObject%d.SDB', [Manager.ServerID]);
    if not FileExists(FileName) then exit;

    CreateDynamicObjectList := TList.Create;
    LoadCreateDynamicObject(FileName, CreateDynamicObjectList);

    for i := 0 to CreateDynamicObjectList.Count - 1 do
    begin
        pd := CreateDynamicObjectList[i];

        DynamicObject := TDynamicObject.Create;
        DynamicObject.SetManagerClass(Manager);
        DynamicObject.Initial(pd);
       { if pd.rboDelay then
        begin
            DynamicObject.OpenedTick := mmAnsTick;
        end else
            DynamicObject.StartProcess;
                  }{
DynamicObject.Regen;
DataList.Add(DynamicObject);
end;

for i := 0 to CreateDynamicObjectList.Count - 1 do
begin
    pd := CreateDynamicObjectList.Items[i];
    Dispose(pd);
end;
CreateDynamicObjectList.Clear;
CreateDynamicObjectList.free;
end;
}

function TDynamicObjectList.GetCount: integer;
begin
  Result := DataList.Count;
end;

{
function TDynamicObjectList.AllocFunction: pointer;
begin
   Result := TDynamicObject.Create;
end;

procedure TDynamicObjectList.FreeFunction (item: pointer);
begin
   TDynamicObject (item).Free;
end;
}

function TDynamicObjectList.AddDynamicObject(pObjectData: PTCreateDynamicObjectData): integer;
var
  DynamicObject: TDynamicObject;
begin
  Result := PROC_FALSE;

  DynamicObject := TDynamicObject.Create;
  DynamicObject.SetManagerClass(Manager);
  DynamicObject.Initial(pObjectData);
  DynamicObject.StartProcess;
  DataList.Add(DynamicObject);

  Result := PROC_TRUE;
end;

function TDynamicObjectList.DeleteDynamicObject(aName: string): Boolean;
var
  i: Integer;
  DynamicObject: TDynamicObject;
begin
  Result := false;
  for i := 0 to DataList.Count - 1 do
  begin
    DynamicObject := DataList.Items[i];
    if DynamicObject.SelfData.rBasicData.rName = aName then
    begin
      DynamicObject.FboAllowDelete := true;
           // Result := true;
      exit;
    end;
  end;
  Result := true;
end;

function TDynamicObjectList.getTypeCount(aname: string; aObjectStatus: TDynamicObjectState): integer;
var
  i: Integer;
  bo: TDynamicObject;
begin
  Result := 0;
  for i := 0 to DataList.Count - 1 do
  begin
    BO := DataList.Items[i];
    if BO = nil then Continue;
    if aname <> '' then if bo.SelfData.rBasicData.rName <> aname then Continue;
    if BO.ObjectStatus = aObjectStatus then inc(Result);

  end;
end;

procedure TDynamicObjectList.RegenDynamicObject(aName: string);
var
  i: Integer;
  DynamicObject: TDynamicObject;
begin

  for i := 0 to DataList.Count - 1 do
  begin
    DynamicObject := DataList.Items[i];
    if (aName = '') or (DynamicObject.SelfData.rBasicData.rName = aName) then
    begin
      DynamicObject.Regen;
    end;
  end;
end;

function TDynamicObjectList.FindDynamicObject(aName: string): Integer;
var
  i, iCount: Integer;
  DynamicObject: TDynamicObject;
begin
  Result := 0;

  iCount := 0;
  for i := 0 to DataList.Count - 1 do
  begin
    DynamicObject := DataList.Items[i];
    if DynamicObject.SelfData.rBasicData.rName = aName then
    begin
      Inc(iCount);
    end;
  end;

  Result := iCount;
end;

procedure TDynamicObjectList.ChangeObjectStatus(aName: string; aObjectStatus: TDynamicObjectState);
var
  i: Integer;
  DynamicObject: TDynamicObject;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    DynamicObject := DataList.Items[i];
    if DynamicObject.SelfData.rBasicData.rName = aName then
    begin
      DynamicObject.setObjectStatus(aObjectStatus);
    end;
  end;
end;


function TDynamicObjectList.GetDynamicObjects(aName: string; aList: TList): Integer;
var
  i, iCount: Integer;
  DynamicObject: TDynamicObject;
begin
  Result := 0;

  iCount := 0;
  for i := 0 to DataList.Count - 1 do
  begin
    DynamicObject := DataList.Items[i];
    if DynamicObject.SelfData.rBasicData.rName = aName then
    begin
      aList.Add(DynamicObject);
      Inc(iCount);
    end;
  end;

  Result := iCount;
end;

procedure TDynamicObjectList.SaveFileCsv;
var
  i: Integer;
  DynamicObject: TDynamicObject;
  templs: tstringlist;
  str: string;
begin
  templs := tstringlist.Create;
  try
    templs.Add('名字,坐标,给于物品,掉落物品,');
    for i := 0 to DataList.Count - 1 do
    begin
      DynamicObject := DataList.Items[i];

      templs.Add(DynamicObject.GetCsvStr);
    end;
    templs.SaveToFile('.\help\DY' + Manager.Title + '.csv');
  finally
    templs.Free;
  end;
end;
{var
    i: Integer;
    DynamicObject: TDynamicObject;
    templs: tstringlist;
    str: string;
begin
    templs := tstringlist.Create;
    try
        templs.Add('名字,坐标,给于物品,掉落物品,');
        for i := 0 to DataList.Count - 1 do
        begin
            DynamicObject := DataList.Items[i];

            templs.Add(DynamicObject.GetCsvStr);
        end;
        templs.SaveToFile('.\help\DY' + Manager.Title + '.csv');
    finally
        templs.Free;
    end;
end;}

procedure TDynamicObjectList.Update(CurTick: integer);
var
  i, iCount: integer;
  DynamicObject: TDynamicObject;
begin
{
    for i := DataList.Count - 1 downto 0 do
    begin
        DynamicObject := DataList.Items[i];
        if DynamicObject.boAllowDelete then
        begin
            DynamicObject.EndProcess;
            DynamicObject.Free;
            DataList.Delete(i);
        end;
    end;

    for i := 0 to DataList.Count - 1 do
    begin
        DynamicObject := DataList.Items[i];
        DynamicObject.UpDate(CurTick);
    end;
    }
  iCount := ProcessListCount;
  if DataList.Count < iCount then
  begin
    iCount := DataList.Count;
    CurProcessPos := 0;
  end;
  for i := 0 to iCount - 1 do
  begin
    if DataList.Count = 0 then break;

    if CurProcessPos >= DataList.Count then CurProcessPos := 0;
    DynamicObject := DataList[CurProcessPos];
    if DynamicObject.FboAllowDelete = true then
    begin
      DynamicObject.EndProcess;
      DynamicObject.Free;
      DataList.Delete(CurProcessPos);
    end else
    begin
      try
        DynamicObject.Update(CurTick);
        Inc(CurProcessPos);
      except
        DynamicObject.FBoAllowDelete := true;
        frmMain.WriteLogInfo(format('TDynamicObjectList.Update (%s) failed', [DynamicObject.SelfData.rBasicData.rName]));
      end;
    end;
  end;
end;
{
procedure SignToItem(var aItemData: TItemData; aServerID: Integer; var aBasicData: TBasicData; aIP: string);
begin
    //    if aItemData.rName[0] > 0 then
    if aItemData.rName <> '' then
    begin
        aItemData.rOwnerRace := aBasicData.Feature.rrace;
        aItemData.rOwnerServerID := aServerID;
        if aBasicData.Feature.rRace <> RACE_HUMAN then
        begin
            aItemData.rOwnerName := '@' + aBasicData.Name;
            aItemData.rOwnerIP := '';
        end else
        begin
            aItemData.rOwnerName := aBasicData.Name;
            aItemData.rOwnerIP := aIP;
        end;
        aItemData.rOwnerX := aBasicData.x;
        aItemData.rOwnerY := aBasicData.y;
        aItemData.rOwnerIP := aIP;
    end;
end;
}
///////////////////////////////////////////////////////////////
//                  TEnmityclass(仇恨管理)
///////////////////////////////////////////////////////////////

constructor TEnmityclass.Create;
begin
  inherited Create;
  fdata := TList.Create;

  Clear;
end;

destructor TEnmityclass.Destroy;
begin
  Clear;
  fdata.Free;
  inherited destroy;
end;

procedure TEnmityclass.Update(CurTick: integer);
var
  i: integer;
  p: pTEnmitydata;
begin
  if GetItemLineTimeSec(CurTick - FDCurTick) <= 2 then exit; //2秒 操作1次
  FDCurTick := CurTick;
    //30秒 没攻击  DEL
    //对象不存在   DEL
  for i := fdata.Count - 1 downto 0 do
  begin
    p := fdata.Items[i];
    if (GetItemLineTimeSec(CurTick - p.rRunTime) > 30) then
    begin
      Dispose(p);
      fdata.Delete(i);
    end;
  end;
end;

function TEnmityclass.get(aid: integer): pTEnmitydata;
var
  i: integer;
  p: pTEnmitydata;
begin
  result := nil;
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];

    if p.rAttacker = aid then
    begin
      result := p;
      exit;
    end;

  end;

end;

function TEnmityclass.getListString(): string;
var
  i: integer;
  p: pTEnmitydata;
begin
  result := '';
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    result := result + format('ID%D仇恨值%D', [p.rAttacker, p.rEnmity]) + #13 + #10;

  end;

end;

procedure TEnmityclass.del(aid: integer);
var
  i: integer;
  p: pTEnmitydata;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];

    if p.rAttacker = aid then
    begin
      Dispose(p);
      fdata.Delete(i);
      exit;
    end;

  end;

end;
{
procedure TEnmityclass.Enmitydec(aid:integer; aEnmity:integer);
var
   p               :pTEnmitydata;
begin
   if aEnmity <= 0 then exit;
   p := get(aid);
   if p = nil then
   begin
       p := add(aid, '');
       exit;
   end;
   p.rRunTime := mmAnsTick;
   p.rEnmity := p.rEnmity - aEnmity;
   if p.rEnmity < 0 then p.rEnmity := 0;
end;
 }
 {
procedure TEnmityclass.EnmityClear(aid:integer);
var
   p               :pTEnmitydata;
begin
   p := get(aid);
   if p = nil then
   begin
       p := add(aid, '');
       exit;
   end;
   p.rRunTime := mmAnsTick;
   p.rEnmity := 0;

end;
 }

function TEnmityclass.Enmityadd(aid: integer; aEnmity: integer): boolean;
var
  p: pTEnmitydata;
begin
  result := false;
  if aEnmity <= 0 then exit;
  p := get(aid);
  if p = nil then
  begin

    exit;
  end;
  p.rRunTime := mmAnsTick;
  p.rEnmity := p.rEnmity + aEnmity;
  result := true;
end;

function TEnmityclass.getMaxEnmityAttacker(): TEnmitydata;
var
  i, maxEnmity: integer;
  p: pTEnmitydata;
begin

  fillchar(result, sizeof(TEnmitydata), 0);
  maxEnmity := 0;
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    if p.rEnmity > maxEnmity then
    begin
      maxEnmity := p.rEnmity;
      result := p^;

    end;
  end;

end;

function TEnmityclass.add(aAttacker: integer; aname: string; atype: TEnmitydatatype; aEnmity: integer): pTEnmitydata;
var
  p: pTEnmitydata;
begin
  result := nil;
  new(p);
  p.rname := copy(aname, 1, 32);
  p.rAttacker := aAttacker;
  p.rRunTime := mmAnsTick;
  p.rEnmity := aEnmity;
  p.rtype := atype;
  fdata.Add(p);
  result := p;
end;

procedure TEnmityclass.Clear();
var
  i: integer;
  p: pTEnmitydata;
begin
  for i := 0 to fdata.Count - 1 do
  begin
    p := fdata.Items[i];
    Dispose(p);
  end;
  fdata.Clear;

  FDCurTick := 0;

end;






{ TVirtualObjectList }

procedure TVirtualObjectList.addCreate(var aCreateVirtualObject: TCreateVirtualObject);
var
  bo: TVirtualObject;
begin
  bo := TVirtualObject.Create;
  bo.SetManagerClass(Manager);
  bo.Initial(aCreateVirtualObject);
  bo.StartProcess;
  DataList.Add(bo);
end;

procedure TVirtualObjectList.Clear;
var
  i: integer;
  bo: TVirtualObject;
begin
  for i := DataList.Count - 1 downto 0 do
  begin
    bo := DataList.Items[i];
    bo.EndProcess;
    bo.Free;
    DataList.Delete(i);
  end;
  DataList.Clear;
end;

constructor TVirtualObjectList.Create(aManager: TManager);
begin
  Manager := aManager;
  DataList := TList.Create;
  //  LoadFromFile;
end;

destructor TVirtualObjectList.Destroy;
begin
  Clear;
  DataList.Free;
  inherited Destroy;
end;

function TVirtualObjectList.GetCount: integer;
begin
  result := DataList.Count;
end;


procedure TVirtualObjectList.LoadFile();
var
  FileName: string;
  filesdb: TUserStringDb;
  i: integer;
  iName: string;
  pd: TCreateVirtualObject;
begin
  FileName := format('.\Setting\CreateVirtualObject%d.SDB', [Manager.ServerID]);
  if not FileExists(FileName) then exit;
  Clear;
  filesdb := TUserStringDb.Create;
  try
    filesdb.LoadFromFile(FileName);
    for i := 0 to filesdb.Count - 1 do
    begin
      iName := filesdb.GetIndexName(i);
      FillChar(pd, sizeof(pd), 0);
      pd.Name := filesdb.GetFieldValueString(iName, 'Name');
      pd.X := filesdb.GetFieldValueInteger(iName, 'x');
      pd.Y := filesdb.GetFieldValueInteger(iName, 'y');
      pd.Width := filesdb.GetFieldValueInteger(iName, 'Width');
      pd.Height := filesdb.GetFieldValueInteger(iName, 'Height');
      pd.Kind := filesdb.GetFieldValueInteger(iName, 'Kind');
      pd.Life := filesdb.GetFieldValueInteger(iName, 'Life');
      addCreate(pd);
    end;

  finally
    filesdb.Free;
  end;


end;

procedure TVirtualObjectList.Update(CurTick: integer);
var
  i: integer;
  bo: TVirtualObject;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    bo := DataList.Items[i];
    bo.Update(CurTick);
  end;
end;

{ TVirtualObject }

constructor TVirtualObject.Create;
begin

  inherited Create;
  fillchar(SelfData, sizeof(SelfData), 0);
  BasicData.BasicObjectType := boVirtualObject;
end;

destructor TVirtualObject.Destroy;
begin

  inherited Destroy;
end;

procedure TVirtualObject.EndProcess;
var
  SubData: TSubData;
begin
  if FboRegisted = FALSE then exit;

  Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
  Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

  inherited EndProcess;
end;

function TVirtualObject.FieldProc(hfu: Integer; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  SubData: TSubData;
  AX, AY: INTEGER;
begin
  Result := PROC_FALSE;
  if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit;
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
  if Result = PROC_TRUE then exit;

  case Msg of
    FM_drink:
      begin
        if isRangeWidthHeight(aSubData.tx, aSubData.ty, SelfData.Width div 2, SelfData.Height div 2) = false then
        begin
                   // BocSay('测试提示:不在区域' + inttostr(mmAnsTick));
          exit;
        end;
        SubData.HitData.ToHit := SelfData.Life;
        SubData.HitData.HitType := SelfData.Kind;
        SendLocalMessage(SenderInfo.id, FM_REFILL, BasicData, SubData);

      end;
  end;
end;

procedure TVirtualObject.Initial(var aCreateVirtualObject: TCreateVirtualObject);
begin
  SelfData := aCreateVirtualObject;
  inherited Initial(SelfData.Name, '');

  BasicData.id := GetNewVirtualObjectID;
  BasicData.x := SelfData.X;
  BasicData.y := SelfData.y;
  BasicData.ClassKind := CLASS_VirtualObject;
  BasicData.Feature.rrace := RACE_VirtualObject;
  BasicData.nx := SelfData.Width;
  BasicData.ny := SelfData.Height;

end;

procedure TVirtualObject.StartProcess;
var
  SubData: TSubData;
begin
  BasicData.x := SelfData.X;
  BasicData.y := SelfData.y;
  BasicData.nx := SelfData.Width;
  BasicData.ny := SelfData.Height;
  inherited StartProcess;

  Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  Phone.SendMessage(0, FM_CREATE, BasicData, SubData);


end;

procedure TVirtualObject.Update(CurTick: Integer);
begin
  inherited Update(CurTick);

end;

{ TMineObjectList }

procedure TMineObjectList.addCreate(var aTCreateMineObject: TCreateMineObject);
var
  bo: TMineObject;
begin
  bo := TMineObject.Create;
  bo.SetManagerClass(Manager);
  if bo.Initial(aTCreateMineObject) then
  begin
    bo.StartProcess;
    bo.Regen;
    DataList.Add(bo);
  end else
  begin
    bo.Free;
  end;
end;

procedure TMineObjectList.Clear;
var
  i: integer;
  bo: TMineObject;
begin
  for i := DataList.Count - 1 downto 0 do
  begin
    bo := DataList.Items[i];
    bo.EndProcess;
    bo.Free;
    DataList.Delete(i);
  end;
  DataList.Clear;
end;


constructor TMineObjectList.Create(aManager: TManager);
begin
  CurProcessPos := 0;
  Manager := aManager;
  DataList := TList.Create;
  //  LoadFromFile;
end;

destructor TMineObjectList.Destroy;
begin
  Clear;
  DataList.Free;
  inherited Destroy;
end;

function TMineObjectList.GetCount: integer;
begin
  result := DataList.Count;
end;

procedure TMineObjectList.LoadFile;
var
  FileName: string;
  filesdb: TUserStringDb;
  i: integer;
  iName: string;
  pd: TCreateMineObject;
begin
  FileName := format('.\Setting\CreateMineObject%d.SDB', [Manager.ServerID]);
  if not FileExists(FileName) then exit;
  Clear;
  filesdb := TUserStringDb.Create;
  try
    filesdb.LoadFromFile(FileName);
    for i := 0 to filesdb.Count - 1 do
    begin

      iName := filesdb.GetIndexName(i);
      FillChar(pd, sizeof(pd), 0);
      pd.Name := filesdb.GetFieldValueString(iName, 'Name');
      pd.X := filesdb.GetFieldValueInteger(iName, 'x');
      pd.Y := filesdb.GetFieldValueInteger(iName, 'y');
      pd.GroupName := filesdb.GetFieldValueString(iName, 'GroupName');
      pd.Shape := filesdb.GetFieldValueInteger(iName, 'Shape');
      addCreate(pd);
    end;

  finally
    filesdb.Free;
  end;


end;

procedure TMineObjectList.Update(CurTick: integer);
var
  i, iCount: integer;
  bo: TMineObject;
begin
  iCount := ProcessListCount;
  if DataList.Count < iCount then
  begin
    iCount := DataList.Count;
    CurProcessPos := 0;
  end;
  for i := 0 to iCount - 1 do
  begin
    if DataList.Count = 0 then break;
    if CurProcessPos >= DataList.Count then CurProcessPos := 0;
    bo := DataList.Items[CurProcessPos];
    bo.Update(CurTick);
    inc(CurProcessPos);
  end;
end;

{ TMineObject }

constructor TMineObject.Create;
begin
  Deposits := 0;
  RegenIntervals := 0;
  DepositsTick := 0;
  inherited Create;
  pToolRateClass := nil;
  fillchar(SelfData, sizeof(SelfData), 0);
  BasicData.BasicObjectType := boMineObject;
end;

destructor TMineObject.Destroy;
begin

  inherited;
end;

procedure TMineObject.EndProcess;
var
  SubData: TSubData;
begin
  if FboRegisted = FALSE then exit;

  Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
  Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

  inherited EndProcess;
end;

function TMineObject.FieldProc(hfu: Integer; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  SubData: TSubData;
  ItemData: titemdata;
  percent: integer;
  itemName: string;
  pToolRateData: pTToolRateData;
  i, n: integer;
begin
  Result := PROC_FALSE;
  if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit;
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
  if Result = PROC_TRUE then exit;

  case Msg of
    FM_Dredge:
      begin

        if aSubData.TargetId <> BasicData.id then exit;
        if SenderInfo.Feature.rrace <> RACE_HUMAN then exit;
        if isHitedArea(SenderInfo.dir, SenderInfo.x, SenderInfo.y, aSubData.HitData.HitFunction, percent) then
        begin

          if Deposits <= 0 then
          begin
            Result := PROC_TRUE;
            SetWordString(aSubData.SayString, '无法挖掘');
            exit;
          end;
          if pToolRateClass = nil then
          begin
            BocSay('错误：挖掘工具无配制');
            exit;
          end;
                    //1确定 挖掘工具
          pToolRateData := pToolRateClass.get(aSubData.SubName);
          if pToolRateData = nil then
          begin
            BocSay('错误：无效的挖掘工具');
            exit;
          end;
                    //2计算是否给矿石
          if Random(5) <> 1 then
          begin
//                        BocSay('测试提示：没有获得材料');
            exit;
          end;

          n := Random(10000);
          itemName := '';
          for i := 0 to high(pToolRateData.SFreqArr) do
          begin
            if (n >= pToolRateData.SFreqArr[i]) and (n < pToolRateData.EFreqArr[i]) then
            begin
              if i > high(MineData.ItemArr) then Break;
              itemName := MineData.ItemArr[i];
              break;
            end;
          end;
          if itemName = '' then
          begin
            BocSay('错误：正常范围内无材料');
            exit;
          end;
                //3发放矿石
          if MineData.Sound > 0 then
          begin
            SubData.sound := MineData.Sound;
            SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
          end;
                    //获得 基本数据
          if ItemClass.GetItemData(itemName, ItemData) = false then
          begin
            BocSay('错误：' + itemName + ' 材料物品无效');
            exit;
          end;
          if ItemData.rNeedEnergyLevel > 0 then
          begin
            if aSubData.HitData.HitLevel < ItemData.rNeedEnergyLevel then
            begin
                        //元气等级检查
              Result := PROC_TRUE;
              SetWordString(aSubData.SayString, '境界不够未能得到' + ItemData.rViewName);
              exit;
            end;
          end;

          NewItemSet(_nist_all, ItemData); //打编号
          ItemData.rCount := 1;
//                    ItemData.rOwnerName := '';

          SubData.ItemData := ItemData;
          SubData.ServerId := ServerId;
                    //背包没位置，掉落在地上。
          if TFieldPhone(Manager.Phone).SendMessage(SenderInfo.id, FM_ENOUGHSPACE, BasicData, SubData) = PROC_FALSE then
          begin
            Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
          end else
          begin
            TFieldPhone(Manager.Phone).SendMessage(SenderInfo.id, FM_ADDITEM, BasicData, SubData);
          end;
          dec(Deposits);
          if Deposits <= 0 then
          begin
            DepositsTick := mmAnsTick;
//                        BocSay('测试提示：资源枯竭,等待生长,复活时间(秒)' + inttostr(RegenIntervals div 100));
            SetWordString(aSubData.SayString, '资源枯竭');
          end;
        end;
      end;

  end;
end;

function TMineObject.Initial(var aCreateMineObject: TCreateMineObject): boolean;
var
  i, n: Integer;
  aname: string;
  pMineData: pTMineData; //组
  pMineAvailData: pTMineAvailData; //外观
  pMineShapeData: pTMineShapeData;
begin
  result := false;
  SelfData := aCreateMineObject;
    //查询组
  pMineAvailData := MineAvailClass.get(SelfData.GroupName);
  if pMineAvailData = nil then
  begin
    frmMain.WriteLogInfo('TMineObject.Initial() pMineAvailData=NIL Error ()');
    exit;
  end;
  n := Random(100);
    //随即选择 矿石
  aname := '';
  for i := 0 to high(pMineAvailData.MineArr) do
  begin
    if (n >= pMineAvailData.MineSArr[i]) and (n < pMineAvailData.MineEArr[i]) then
    begin
      aname := pMineAvailData.MineArr[i];
      n := i;
      break;
    end;
  end;
  if aname = '' then
  begin
    frmMain.WriteLogInfo('TMineObject.Initial() aname='' Error ()');
    exit;
  end;
    //查询矿石
  pMineData := MineClass.get(aname);
  if pMineData = nil then
  begin
    frmMain.WriteLogInfo('TMineObject.Initial() pMineData=NIL Error ()');
    exit;
  end;
    //查询 外观动画
  pMineShapeData := MineShapeClass.get(SelfData.Shape);
  if pMineShapeData = nil then
  begin

    frmMain.WriteLogInfo('TMineObject.Initial() pMineShapeData=NIL Error ()');
    exit;
  end;
  pToolRateClass := ToolRateClass.get(pMineData.Name);
  if pToolRateClass = nil then
  begin
    frmMain.WriteLogInfo('TMineObject.Initial() pToolRateClass=NIL Error ()');
    exit;
  end;
  MineData := pMineData^;
  MineAvailData := pMineAvailData^;
  MineShapeData := pMineShapeData^;
  inherited Initial(MineData.Name, MineData.ViewName);

  BasicData.id := GetNewDynamicObjectId;
  BasicData.x := SelfData.X;
  BasicData.y := SelfData.Y;
  BasicData.ClassKind := CLASS_MineObject;
  BasicData.Feature.rrace := RACE_MineObject;

  BasicData.Feature.rImageNumber := MineShapeData.Shape;
  BasicData.BasicObjectType := boMineObject;

  BasicData.Feature.rHitMotion := 1;
  BasicData.nx := MineShapeData.SStep;
  BasicData.ny := MineShapeData.EStep;

  FboHaveGuardPos := TRUE;
  for i := 0 to 10 - 1 do
  begin
    BasicData.GuardX[i] := MineShapeData.GuardXArr[I];
    BasicData.GuardY[i] := MineShapeData.GuardyArr[I]
  end;

  result := true;
end;

procedure TMineObject.Regen;
var
  i, n: integer;
  pMineData: pTMineData;
  aname: string;
begin
  if FboRegisted = FALSE then exit;
  Deposits := 20;
//1，矿石来源

  n := Random(100);
    //随即选择 矿石
  aname := '';
  for i := 0 to high(MineAvailData.MineArr) do
  begin
    if (n >= MineAvailData.MineSArr[i]) and (n < MineAvailData.MineEArr[i]) then
    begin
      aname := MineAvailData.MineArr[i];
      n := i;
      break;
    end;
  end;
  if aname = '' then exit;
    //查询矿石
  pMineData := MineClass.get(aname);
  if pMineData = nil then exit;

  MineData := pMineData^;
    //2，堆积数量
  if (n > 0) and (n < high(MineData.DepositsArr)) then
    Deposits := MineData.DepositsArr[n];
  if Deposits <= 0 then Deposits := 20;
  n := Random(3);
  if (n > 0) and (n < high(MineData.RegenIntervalsArr)) then
    RegenIntervals := MineData.RegenIntervalsArr[n];

  if RegenIntervals <= 0 then RegenIntervals := 6000;

  BasicData.ViewName := MineData.ViewName;
end;

procedure TMineObject.StartProcess;
var
  SubData: TSubData;
begin
  inherited StartProcess;


  Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  Phone.SendMessage(0, FM_CREATE, BasicData, SubData);

end;

procedure TMineObject.Update(CurTick: Integer);
begin
  inherited Update(CurTick);
  if Deposits <= 0 then
  begin
    if CurTick > DepositsTick + RegenIntervals then
    begin
      Regen;
            //BocSay('测试提示：矿石复活');
    end;
  end;
end;

{ TGroupMoveList }

procedure TGroupMoveList.addCreate(var aCreateGroupMoveData: TCreateGroupMoveData);
var
  bo: TGroupMoveObject;
  Manager: TManager;
begin
  Manager := ManagerList.GetManagerByServerID(aCreateGroupMoveData.MapID);
  if Manager = nil then exit;
  bo := TGroupMoveObject.Create;
  bo.SetManagerClass(Manager);
  bo.Initial(aCreateGroupMoveData);
  bo.StartProcess;
  DataList.Add(bo);
end;


procedure TGroupMoveList.Clear;
var
  i: integer;
  bo: TGateObject;
begin
  for i := DataList.Count - 1 downto 0 do
  begin
    bo := DataList.Items[i];
    bo.EndProcess;
    bo.Free;
    DataList.Delete(i);
  end;
  DataList.Clear;
end;

constructor TGroupMoveList.Create;
begin
  DataList := TList.Create;
  LoadFromFile;
end;

destructor TGroupMoveList.Destroy;
begin
  Clear;
  DataList.Free;
  inherited;
end;

function TGroupMoveList.GetCount: integer;
begin
  result := DataList.Count;
end;

procedure TGroupMoveList.LoadFromFile();
var
  FileName: string;
  filesdb: TUserStringDb;
  i: integer;
  iName: string;
  pd: TCreateGroupMoveData;
begin
  FileName := '.\Setting\CreateGroupMove.SDB';
  if not FileExists(FileName) then exit;
  Clear;
  filesdb := TUserStringDb.Create;
  try
    filesdb.LoadFromFile(FileName);
    for i := 0 to filesdb.Count - 1 do
    begin
      iName := filesdb.GetIndexName(i);
      FillChar(pd, sizeof(pd), 0);
      pd.Name := filesdb.GetFieldValueString(iName, 'Name');
      pd.GateName := filesdb.GetFieldValueString(iName, 'GateName');
      pd.ViewName := filesdb.GetFieldValueString(iName, 'ViewName');
      pd.Shape := filesdb.GetFieldValueInteger(iName, 'Shape');
      pd.SStep := filesdb.GetFieldValueInteger(iName, 'SStep');
      pd.EStep := filesdb.GetFieldValueInteger(iName, 'EStep');
      pd.Width := filesdb.GetFieldValueInteger(iName, 'Width');
      pd.X := filesdb.GetFieldValueInteger(iName, 'x');
      pd.Y := filesdb.GetFieldValueInteger(iName, 'y');
      pd.TargetX := filesdb.GetFieldValueInteger(iName, 'TargetX');
      pd.TargetY := filesdb.GetFieldValueInteger(iName, 'TargetY');
      pd.AddWidth := filesdb.GetFieldValueInteger(iName, 'AddWidth');
      pd.MapID := filesdb.GetFieldValueInteger(iName, 'MapID');
      pd.TargetMapID := filesdb.GetFieldValueInteger(iName, 'TargetMapID');
      pd.MoveNum := filesdb.GetFieldValueInteger(iName, 'MoveNum');
      pd.AddItem := filesdb.GetFieldValueString(iName, 'AddItem');


      addCreate(pd);
    end;

  finally
    filesdb.Free;
  end;


end;


procedure TGroupMoveList.Update(CurTick: integer);
begin


end;

{ TGroupMoveObject }

constructor TGroupMoveObject.Create;
begin
  UserNameList := tstringlist.Create;
  inherited Create;

  fillchar(SelfData, sizeof(SelfData), 0);
  BasicData.BasicObjectType := boGroupMoveObject;
end;

destructor TGroupMoveObject.Destroy;
begin
  UserNameList.Free;
  inherited;
end;

procedure TGroupMoveObject.EndProcess;
var
  SubData: TSubData;
begin
  if FboRegisted = FALSE then exit;

  Phone.SendMessage(0, FM_DESTROY, BasicData, SubData);
  Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

  inherited EndProcess;
end;


function TGroupMoveObject.FieldProc(hfu: Integer; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  SubData: TSubData;
  bo: TBasicObject;
  i: integer;
  str: string;
begin
  Result := PROC_FALSE;
  if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit;
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
  if Result = PROC_TRUE then exit;
  case Msg of
    FM_ADDITEM:
      begin
        if SenderInfo.Feature.rrace <> RACE_HUMAN then exit;

        if aSubData.ItemData.rName <> SelfData.AddItem then
        begin
                   // BocSay('测试提示:物品不匹配');
          exit;
        end;
        if aSubData.ItemData.rCount < 1 then
        begin
                   // BocSay('测试提示:物品数量太少');
          exit;
        end;
        UserNameList.Add(SenderInfo.Name);
        Move(aSubData.ItemData, SubData.ItemData, SizeOf(TItemData));
        SendLocalMessage(SenderInfo.ID, FM_DELITEM, BasicData, SubData);
        LeftTextSay(0, '丢入' + aSubData.ItemData.rName + ',共剩余:' + inttostr(SelfData.MoveNum - UserNameList.Count), WinRGB(22, 22, 0));
        if UserNameList.Count >= SelfData.MoveNum then
        begin
          for i := 0 to UserNameList.Count - 1 do
          begin
            str := UserNameList.Strings[i];
            bo := GetViewObjectByName(str, RACE_HUMAN);
            if bo = nil then Continue;
            if bo.BasicData.Feature.rrace <> RACE_HUMAN then Continue;
            Tuser(bo).MoveToMap(SelfData.TargetMapID, SelfData.TargetX, SelfData.TargetY);
          end;
          UserNameList.Clear;
        end;
      end;

  end;
end;

procedure TGroupMoveObject.Initial(var aCreateGroupMoveData: TCreateGroupMoveData);
begin

  SelfData := aCreateGroupMoveData;

  inherited Initial(SelfData.Name, SelfData.ViewName);

  BasicData.id := GetNewDynamicObjectId;
  BasicData.x := SelfData.X;
  BasicData.y := SelfData.Y;
  BasicData.ClassKind := CLASS_GroupMoveObject;
  BasicData.Feature.rrace := RACE_GroupMoveObject;

  BasicData.Feature.rImageNumber := SelfData.Shape;
  BasicData.BasicObjectType := boGroupMoveObject;

  BasicData.Feature.rHitMotion := 1;
  BasicData.nx := SelfData.SStep;
  BasicData.ny := SelfData.EStep;

end;

procedure TGroupMoveObject.StartProcess;
var
  SubData: TSubData;
begin
  inherited StartProcess;


  Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  Phone.SendMessage(0, FM_CREATE, BasicData, SubData);

end;

end.

