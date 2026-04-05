
{
继承关系
1,TBasicObject
2,------------TUserObject
3,------------------------TUser

攻击流程
人攻击：
1，CommandHit或者CommandBowing 发起攻击
2，FM_HIT 消息处理

FM_HIT消息受理
      FM_HIT人受理
      1，TUser无处理  TUserObject 处理  TBasicObject无处理
      2，TUserObject.CommandHited完整处理被攻击。
      FM_HIT  NPC 怪物
      1，TNpc无  TLifeObject处理  TBasicObject无
      2，TLifeObject.CommandHited完整处理被攻击。

声音系统改成 数字ID

物品 往来
1，SelectCount
人交易
1，物品 丢到对方身上 CM_DRAGDROP 触发 DragProcess
2，ExChangeStart(aId:Integer); //交易开始
3，

物品丢地
1，FM_ADDITEM                             发送消息
1，TManagerList.FieldProc                 处理
    A门派石头                              A门派特殊处理
    B                                      B
    C，普通物品 TItemList.AddItemObject    C物品属性完整拷贝到ItemObject类
物品杀死怪物掉 ***********新生产物品 打ID
1，TMonster.FieldProc     FM_STRUCTED      处理
2，HaveItemClass.DropItemGround;            处理掉什么东西出来
物品 创建
1,GM制造  OK
2,NPC     卖OK  爆OK
3,怪物    掉OK 爆OK
4,静态物体 掉OK
5,脚本    OK

////////////////////////////////////////////////////////////////////////////////
//                               人物体创建
GATE 连接到 TGS
procedure CreateConnect(aGateNo:Integer; aPacket:PTPacketData);
=>TConnector.Create(GateNo, ConnectID);
=>function TUserList.InitialLayer(aCharName:string; aConnector:TConnector):Boolean;
===>User := TUser.Create;
===>Manager查找
===>User.SetManagerClass(tmpManager);
===>User.InitialLayer(aCharName);
===>User.Initial(aCharName);
=>procedure TUserList.StartChar(aCharname:string);
===>procedure TUser.StartProcess;

1,注册到本地图    Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
2,创建到本地图    Phone.SendMessage(NOTARGETPHONE, FM_CREATE, BasicData, SubData);

}
unit UUser;
interface

uses
  Windows, SysUtils, Classes, ScktComp, WinSock, svclass, deftype,
  aUtil32, basicobj, fieldmsg, mapunit, subutil, uanstick, uSendcls,
  uUserSub, aiunit, uLetter, uManager, uConnect, uBuffer,
  uItemLog, uKeyClass, uGramerID, mmSystem, uLevelExp, uResponsion, DateUtils, UTelemanagement;

const
  InputStringState_None = 0;
    //    InputStringState_AddExchange = 1;
  InputStringState_Search = 2;

  RefusedMailLimit = 5; // 芭何等 率瘤狼 弥措荐 (率瘤扁瓷阑 荤侩且 荐 绝霸凳)
  MailSenderLimit = 5; // 焊辰 荤恩阑 扁撅窍绰 弥措摹

type
  TuserCountWindowCount = record
    rCountid: LongInt;
    rsourkey: word;
    rdestkey: word;
    rCountCur: LongInt;
    rCountMax: LongInt;
  end;
  pTuserCountWindowCount = ^TuserCountWindowCount;
  TMouseEventData = record
    rtick: Integer;
    revent: array[0..10 - 1] of integer;
  end;
  PTMouseEventData = ^TMouseEventData;

    // 概农肺 眉农甫 淬淬窍绰 努贰胶
  TMacroChecker = class
  private
    nSaveCount: Integer; // 付快胶捞亥飘 单捞鸥 焊包 肮荐
    DataList: TList;

    nReceivedCount: Integer; // 眠啊等 付快胶 捞亥飘 单捞鸥狼 墨款飘

    function CheckNone: Boolean; // 沥富肺 酒公老档 窍瘤 臼绰 荤恩
    function CheckCase1: Boolean; // MouseMove父 0 < x < 20 牢 荤恩
    function CheckCase2: Boolean; // 30盒悼救 荐摹啊 +-10%捞郴牢 荤恩
    function CheckCase3: Boolean; // 呈公 磊林 焊郴绰 荤恩

  public
    constructor Create(anSaveCount: Integer);
    destructor Destroy; override;

    procedure Clear;

    procedure SaveMacroCase(aName: string; nCase: Integer);
    procedure AddMouseEvent(pMouseEvent: PTCMouseEvent; anTick: Integer);
    function Check(aName: string): Boolean;
  end;

  TUserObject = class(TBasicObject)
  private
    bosendLifeData: boolean;

    Connector: TConnector;

    boFalseVersion: Boolean;
    boShiftAttack: Boolean;
    TargetId: integer;
    PrevTargetID: Integer;
    LifeObjectState: TLifeObjectState;

    RopeTarget: integer; // 拖尸体
    RopeTick: integer;
    RopeOldX, RopeOldy: word;

    ShootBowCount: integer;

    FreezeTick: integer; //Freeze 冻结

    DiedTick: integer;

    sendDiedTick: integer;
    HitedTick: integer;
        // StructedTick : Integer;
    LifeData: TLifeData;


    ChangeLifeTick: integer;




    function AllowCommand(CurTick: integer): Boolean;


  protected
    LastGainExp: integer;

    DisplayValue: Word;
    DisplayTick: Integer;

    DesignationClass: TDesignationClass;
    AttribClass: TAttribClass;
    WearItemClass: TWearItemClass;
    HaveItemClass: THaveItemClass; //背包 物品 列表
    HaveItemQuestClass: THaveItemQuestClass;
    HaveMagicClass: THaveMagicClass;

    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
    procedure Initial(aName: string);
    procedure StartProcess; override;
    procedure EndProcess; override;
  public

    name, IP: string;
    ConsortName: string; //配偶 名字

    GuildServerID: Integer;
    GuildName: string;
    GuildGrade: string;
    SendClass: TSendClass;
    SayTick: integer;
    SearchTick: integer;

    FCompleteQuestNo: integer; //新 任务 完成ID
    FCurrentQuestNo: integer; //新 任务 当前ID
    FQueststep: integer; //新 任务 步骤ID

    FSubCurrentQuestNo: integer; //新 分支任务 当前ID
    FSubQueststep: integer; //新 分支任务 步骤ID

    uProcessionclass: pointer; //队伍
    uGuildObject: pointer; //自己的帮会
    LifeDataList: TLifeDataList; //附加 属性  吃物品等方面增加

    fCounterAttack_state: boolean; //反击
    fCounterAttack_datetime: integer; //到期时间
    constructor Create;
    destructor Destroy; override;
    procedure Update(CurTick: integer); override;

    procedure SetTargetId(aid: integer);
    procedure CommandChangeCharState(aFeatureState: TFeatureState; boSend: Boolean);

        //攻击 被攻击 远程攻击
    function CommandHited(var SenderInfo: TBasicData; aattacker: integer; aHitData: THitData; apercent: integer): integer;
    function CommandHit(CurTick: integer; boSend: Boolean; rdir: integer): Boolean;
    function CommandDredgeHit(CurTick: integer; boSend: Boolean; rdir: integer): Boolean;
    procedure CommandBowing(CurTick: integer; atid: integer; atx, aty: word; boSend: Boolean);

    procedure CommandTurn(adir: word; boSend: Boolean);

    function isFellowship(aBasicData1, aBasicData2: TBasicData): boolean;
    function isProcession(aBasicData1, aBasicData2: TBasicData): boolean; //测试 队伍相同
    function GetWeaponGuild: boolean;
    function GetLifeObjectState: TLifeObjectState;
    function AddMagic(aMagicData: PTMagicData): Boolean;
    function FindHaveMagicByName(aMagicName: string): Integer;

    function DelKeyItem(akey, acount: integer; aItemData: PTItemData): Boolean;
    function DeleteItem(aItemData: PTItemData): Boolean;

    function AddItem(aItemData: PTItemData): Boolean;

    function FindItem(aItemData: PTItemData): Boolean;
    function FindNameItem(aname: string): integer;
    function ViewItemName(aname: string; aItemData: PTItemData): Boolean;
    function ViewItem(akey: integer; aItemData: PTItemData): Boolean;

    function Add_GOLD_Money(acount: integer): Boolean;
    function DEL_GOLD_Money(acount: integer): Boolean;
    function GET_GOLD_Money(): INTEGER;
    procedure affair(atype: THaveItemClassAffair);
    function GetWearItemName(akey: integer): string;
    function getuserMagic: string;
    function AddMagicExp(aname: string; aexp: integer): integer;
    function getMagicExp(aname: string): integer;
    function getMagicLevel(aname: string): integer;
    function getAttackMagic: TMagicData;

    function LockedPass: boolean;

    procedure PowerLeveladd;
    procedure PowerLeveldec;
    procedure PowerLevelMax;
    procedure SetLifeData;

  public

    function getMaxLife: Integer;
    function GetAge: Integer;
    function getcEnergy: Integer;
  end;

  TUser = class(TUserObject)
  private

    DistributeType: TDistributeType;
    boNewServer: Boolean;
    boNewServerTick: integer;
    boNewServerDelayTick: integer;

    boTv: Boolean;
    boException: Boolean;
    boDeleteState: boolean;

    boCanSay, FboCanMove, boCanAttack: Boolean;
    FboNewEmail: boolean; //邮件 状态

    InputStringState: integer;
        //      CountWindowState:integer;
    CountWindowState: TuserCountWindowCount; //统一  管理 输入 数量 筐  {当前}

    CM_MessageTick: array[0..255] of integer;
    PrisonTick: Integer;
    SaveTick: integer;
    FalseTick: integer;
    PosMoveX, PosMoveY: integer; //需要去的坐标  UPDATE里完成 新坐标设置
    SysopScope: integer;

    MailTick: Integer;
    RefuseReceiver: TStringList; //拒绝 接收你纸条 队列
    MailSender: TStringList;
    boLetterCheck: Boolean;

    UseSkillKind: Integer;
    SkillUsedTick: Integer;
    SkillUsedMaxTick: Integer;

    FSpecialWindow: Byte;
        //   ItemLog.FLogData:TItemLogRecord; //临时的
    ItemLog: TItemLog; //仓库

    MacroChecker: TMacroChecker;



    NetStateID: Integer;
    NetStateTick: Integer;
    NetState_ClientId: integer; //客户端上发的ID
    NetState_mmAnsTick0: integer; // mmAnsTick 起点
    NetState_Client_mmAnsTick0: integer; //客户端 mmAnsTick 起点
    NetState_speed_close: boolean;
//        SaveNetState: TCNetState;
    MOVE_Client_OldTick: integer;

    ADDMsgList: TResponsion; //加人  等待 应答 列表

    MonsterUPdateTick: Integer;
    MagicExpMulUpdateTick: integer;
        // procedure SendData (cnt:integer; pb:pbyte);

    procedure LoadUserData(aName: string);
    procedure SaveUserData(aName: string);


        //事件
    procedure MessageProcess(var code: TWordComData);
    procedure MessageProcessItemLog(var code: TWordComData);

    procedure MessageProcessExChange(var code: TWordComData);
    procedure MessageProcessUPdataItem(var code: TWordComData); //装备 升级
    procedure MessageProcessEmporia(var code: TWordComData); //商城
    //20090904增加 摆摊消息处理
    procedure MessageProcessBooth(var code: TWordComData);

    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer; override;
    procedure UserSay(astr: string);
    procedure DragProcess(var code: TWordComData);
    procedure InputCountProcess(var Code: TWordComData); //输入的 数量

    procedure InputStringProcess(var code: TWordComData);
    procedure InputOkProcess(var code: TWordComData);

    procedure GuildCreateName(var Code: TWordComData);

    procedure HaveItemToItemlog(aHavekey, aItemlogKey, acount: integer);
    procedure ItemlogToHaveItem(aHavekey, aItemlogKey, acount: integer);

    procedure ItemUserDel(akey, acount: integer; var aitem: titemdata); //使用背包物品

        //==========GM 指令
    procedure GM_ADDMONEY(aname: string; acount: integer);
    procedure ClearDElMagic;






  public
    FtempInputString: string; //临时 输入内容
        //        CopyHaveItem:THaveItemClass; //买卖 仓库 用于 回当 数据
    SysopObj, UserObj: TBasicObject; //监视

    MenuSayObjId: integer; //当前NPC
    MenuSTATE: TMenuSTATE; //于NPC  交易状态
    MenuSayText: string; //当前 点NPC  脚本 弹出的菜单 内容

    ExChange: TExChange; //交易 类
    Boothclass: TBoothDataClass;

    ahailfellow: pointer;
    aEmail: pointer;

    booth_name: string; //交易用户 的 名字
//        pMonster: pointer;
    FMonsterList: tlist;
        ////////////////////////////////////////////////////////////////////////
        //开始
        //增加
        //删除
        //确定
        //取消
    procedure ExChangeShow(); //显示 窗口
    procedure ExChangeClose(); //关闭 窗口
    procedure ExChangeUPDATE(); //数据更新
    function getExUser(): Tuser; //获取 对方类地址
    procedure ExChangeClick; //(awin:byte; aclickedid:longInt; akey:word); //确认
    procedure AddExChangeData(aSource, adest: pTBasicData; pex: PTExChangedata); //增加 到背包
    procedure DelExChangeData(aSource: pTBasicData; pex: PTExChangedata); //删除 背包
    procedure ExChangeStart(aId: Integer); //交易 开始
    function ExChangeDataIsCheck: Boolean; //交易 物品 与背包 匹配
    procedure ExChangeItemAdd(ahaveItemKey, acount: integer); //交易列表  ADD
    procedure ExChangeItemDel(aExChangeItemkey: integer); //交易列表  DEL
    procedure ExChangemsg(auserid: integer);
    procedure ExChangemsgOk(ayid: integer);
    procedure ExChangemsgNO(ayid: integer);


        ////////////////////////////////////////////////////////////////////////

    constructor Create;
    destructor Destroy; override;
    procedure Update(CurTick: integer); override;

    function InitialLayer(aCharName: string): Boolean;
    procedure FinalLayer;

    function SETfellowship(id: integer): string;
    procedure Initial(aName: string);
    procedure StartProcess; override;
    procedure EndProcess; override;

    procedure GuildDel();
    procedure MarrySet(sname: string);
    procedure Marrydel();
    procedure GuildSet(aguild: pointer);
    function FieldProc2(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
        //输入数量 窗口  3函数
    function InputCountWindowIs(aCountID, aSourKey, aDestKey, aCount: Integer): boolean; //是否 有效
    procedure InputCountWindowShow(aCountID, aSourKey, aDestKey, aCntMax: Integer; aCaption: string); //弹开 输入数量
    procedure InputCountWindowClose; //关闭 或者清除

    procedure AddRefusedUser(aName: string);
    procedure DelRefusedUser(aName: string);
    procedure AddMailSender(aName: string);
    function CheckSenderList(aName: string): Boolean;

    procedure SetPosition(x, y: Integer);
    procedure SetPositionBS(ex, ey: Integer);
        //移动 3函数
//        procedure MoveToMapName(aName: string; aTargetX, aTargetY: Integer);    //移动到指定 地图
    procedure MoveToMap(aServerID: Integer; aTargetX, aTargetY: Integer; aDelayTick: integer = 0); //移动到指定 地图
//        procedure MoveTo(aTargetX, aTargetY: Integer);                          //移动到指定 位置

    function ShowItemLogWindow: string;
    function ShowItemLogSetPasswordWindow: string;

    function ShowItemLogFreePasswordWindow: string;
    function ShowItemSetPasswordWindow: string;
    function ShowItemUpDatePasswordWindow: string;
    function ShowItemGameexitWindow: string;

    function ShowItemFreePasswordWindow: string;
    function IsMenuSay(asay: string): boolean;

    procedure SendMapObject;
    procedure Setmove(Value: boolean);
    procedure SetNEWEmail(Value: boolean);
    procedure SETSpecialWindow(Value: byte);
    function ShowItemBuyWindow(aCaption: string; aComment: string; aShape, aImage: INTEGER; aBuyItemAllState: boolean): boolean;
    function ShowItemSellWindow(aCaption: string; aComment: string; aShape, aImage: INTEGER): boolean;
    function ShowUPdataItemLevelWindow(aCaption: string; aComment: string; aShape, aImage: INTEGER): boolean;
    function ShowUPdataItemSettingWindow(aCaption: string; aComment: string; aShape, aImage: INTEGER): boolean;
    function ShowUPdataItemSettingdelWindow(aCaption: string; aComment: string; aShape, aImage: INTEGER): boolean;

    procedure closeNPCSAYWindow;
    procedure ShowNPCSAYWindow(SAYTEXT: string);

    procedure CloseEmailWindow;
    function ShowEmailWindow: string;
    procedure CloseAuctionWindow;
    function ShowAuctionWindow: string;

    function MovingStatus: Boolean;
    procedure UdpSendMouseEvent(aInfoStr: string);

    property LetterCheck: Boolean read boLetterCheck;
    property Exception: Boolean read boException write boException;
    function isGm: boolean;
    property CanMove: Boolean read FboCanMove write Setmove;
    property SpecialWindow: BYTE read FSpecialWindow write setSpecialWindow;
    property NewEmailState: Boolean read FboNewEmail write SETNewEmail;
        //Auction
    function ItemAuctionDeleteItem(aitem: ptitemdata): boolean;
    function ItemAuctionADDITEM(aitem: ptitemdata): boolean;
    function ItemAuctionDelKeyItem(akey, acount: integer; aitem: ptitemdata): boolean;

    function ItemEmailDeleteItem(aitem: ptitemdata): boolean;
    function ItemEmailADDITEM(aitem: ptitemdata): boolean;
    function ItemEmailDelKeyItem(akey, acount: integer; aitem: ptitemdata): boolean;

        //Scripter
    function ItemScripterDeleteItem(aitem: ptitemdata): boolean;
    function ItemScripterDeleteItemKey(akey, acount: integer): boolean;
    function ItemScripterADDITEM(aitem: ptitemdata): boolean;
        //交易
    function ItemExChangeDeleteItemKEY(aSource: pTBasicData; akey, acount: integer; aitem: ptitemdata): boolean;
    function ItemExChangeADDITEM(aSource, adest: pTBasicData; aitem: ptitemdata): boolean;

    function QuestTempAdd(aindex, aAddCount, aAddMax: integer): boolean;

    procedure ScriptAuction(aItem: TItemData);
    procedure CloseAllWindow;
///////////////////////////////////////////////////////////////////////////
    //摆摊
    procedure Booth_Edit_Open();
    procedure Booth_Edit_Close();
    procedure Booth_User_Open(aname: string);
    procedure Booth_User_Close();

///////////元神/////////////////
    procedure MonsterAdd(aMonsterName: string);
    procedure MonsterClear;
    procedure MonsterDel(aMop: pointer);
    function MonsterAddLife(aLife: integer): boolean;
    procedure MonsterUPdate(CurTick: integer);
        //数据操作
    function MonsterCheck: boolean;
    function MonsterUserMaxLife: integer;
//////////翻倍经验/////////////////////
    procedure MagicExpMulAdd(aMulCount, aHour: integer);
    procedure MagicExpMulDel;
    procedure MagicExpMulUpdate(CurTick: integer);
    function MagicExpMulGetDay: integer;
    function MagicExpMulGetCurMulMinutes: integer;
  end;

  TUserList = class
  private
    ExceptCount: integer;
    CurProcessPos: integer;
    UserProcessCount: Integer;

        // AnsList : TAnsList;
    NameKey: TStringKeyClass;
    DataList: TList;

        // TvList : TList;

    function GetCount: integer;
    function MapUserCount(aServerID: Integer): integer;


  public
    constructor Create(cnt: integer);
    destructor Destroy; override;
    function InitialLayer(aCharName: string; aConnector: TConnector): Boolean;
    procedure FinalLayer(aConnector: TConnector);
    procedure StartChar(aCharname: string);
    procedure GuildSetLifeData(aGuildName: string);

    function GetUserPointer(aCharName: string): TUser;
    function GetUserPointerById(aId: LongInt): TUser;
    procedure BoothClose();

    procedure GuildSay(aGuildName, astr: string);
    procedure GuildSayNUM(aGuildName: string; astr: integer);
    procedure GuildSendData(aGuildName: string; var ComData: TWordComData);
    procedure GuildSendDelAll(aGuildName: string);
    function GetGuildUserInfo(aGuildName: string): string;

    procedure SayByServerID(aServerID: Integer; aStr: string);
    procedure MoveByServerID(aServerID: Integer; aTargetID, aTargetX, aTargetY: Integer);
    procedure NotMoveServerID(aServerID, atime: integer);

    procedure SendNoticeMessage(aStr: string; aColor: Integer);
    procedure SendNoticeMessage2(aStr: string; aFColor, aBColor: word);
    procedure SendRollMSG(acolor: word; astr: string);
    procedure SendTopMSG(acolor: word; astr: string);
    procedure SendCenterMSG(acolor: word; astr: string; atype: byte);
        // procedure   SendGradeShoutMessage (astr: string; aColor: integer);
    function GetUserList: string;
    procedure SendRaining(aRain: TSRainning);

        // function    FieldProc2 (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;

    procedure Update(CurTick: integer);
    property Count: integer read GetCount;

    procedure SaveUserInfo(aFileName: string);
    procedure SendSoundEffect(aManager: TManager; aSoundEffect: integer);
    procedure SendALLdata(var ComData: TWordComData);

    procedure SendChatMessage_ServerID(aServerID: Integer; asay: string; acolor: integer);
    procedure ClearMagicDelCount;
  end;

var
  UserList: TUserList;
  boCheckSpeed: Boolean = false;
  NetPackLogName: string = '';
  VarMoveSpeedTime: integer = 15;


function callfunc01(str: string; BasicData, SenderInfo: TBasicData): string;
implementation

uses
  uNpc, uMonster, uGuild, SvMain, FSockets, FGate, uGConnect, uDoorGen,
  Math, uhailfellow, TypInfo, uMarriage, uEmail, uAuction, uQuest, uProcession
  , uBillboardcharts, PaxScripter, PaxPascal, uEmporia, uSkills

  , ViewLog, StrUtils;

////////////////////////////////////////////////////
//
//             ===  TMacroChecker  ===
//
////////////////////////////////////////////////////

constructor TMacroChecker.Create(anSaveCount: Integer);
var
  i: Integer;
  pMouseEvent: PTMouseEventData;
begin
  nSaveCount := anSaveCount;
  DataList := TList.Create;

  for i := 0 to nSaveCount - 1 do
  begin
    New(pMouseEvent);
    if pMouseEvent <> nil then
    begin
      FillChar(pMouseEvent^, sizeof(TMouseEventData), 0);
      DataList.Add(pMouseEvent);
    end;
  end;

  nReceivedCount := 0;
end;

destructor TMacroChecker.Destroy;
var
  i: Integer;
  pMouseEvent: PTMouseEventData;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    pMouseEvent := DataList.Items[i];
    if pMouseEvent <> nil then Dispose(pMouseEvent);
  end;
  DataList.Clear;
  DataList.Free;
end;

procedure TMacroChecker.Clear;
begin
  nReceivedCount := 0;
end;

function TMacroChecker.CheckNone: Boolean; // 沥富肺 酒公 老档 救窍绰 荤恩
var
  i, j: integer;
  pMouseEventData: PTMouseEventData;
begin
  Result := false;

  if nReceivedCount = nSaveCount then
  begin
    for i := 0 to nReceivedCount - 1 do
    begin
      pMouseEventData := DataList.Items[i];
      if pMouseEventData = nil then break;
      for j := 0 to 10 - 1 do
      begin
        if pMouseEventData^.revent[j] <> 0 then exit;
      end;
    end;
  end;

  Result := true;
end;

function TMacroChecker.CheckCase1: Boolean; // MouseMove父 0 < x < 20 牢 荤恩
var
  i, j: integer;
  pMouseEventData: PTMouseEventData;
begin
  Result := false;

  for i := 0 to nReceivedCount - 1 do
  begin
    pMouseEventData := DataList.Items[i];
    if pMouseEventData = nil then exit;
    for j := 1 to 10 - 1 do
    begin
      if pMouseEventData^.revent[j] <> 0 then exit;
    end;
    if (pMouseEventData^.revent[0] <= 0) or (pMouseEventData^.revent[0] >= 20) then exit;
  end;

  Result := true;
end;

function TMacroChecker.CheckCase2: Boolean; // 30盒悼救 荐摹啊 +-10%捞郴牢 荤恩
var
  i, j: integer;
  pMouseEventData: PTMouseEventData;
  AverageData, LimitData: TMouseEventData;
begin
  Result := false;

  FillChar(AverageData, sizeof(TMouseEventData), 0);
  for i := 0 to nReceivedCount - 1 do
  begin
    pMouseEventData := DataList.Items[i];
    if pMouseEventData = nil then exit;
    for j := 0 to 10 - 1 do
    begin
      AverageData.revent[j] := AverageData.revent[j] + pMouseEventData^.revent[j];
    end;
  end;
  for i := 0 to 10 - 1 do
  begin
    AverageData.revent[i] := Integer(AverageData.revent[i] div nReceivedCount);
    LimitData.revent[i] := Integer(AverageData.revent[i] div 10);
  end;

  for i := 0 to nReceivedCount - 1 do
  begin
    pMouseEventData := DataList.Items[i];
    if pMouseEventData = nil then exit;
    for j := 0 to 10 - 1 do
    begin
      if pMouseEventData^.revent[j] > AverageData.revent[j] + LimitData.revent[i] then exit;
      if pMouseEventData^.revent[j] < AverageData.revent[j] - LimitData.revent[i] then exit;
    end;
  end;

  Result := true;
end;

function TMacroChecker.CheckCase3: Boolean; // 呈公 磊林 焊郴绰 荤恩
var
  i: integer;
  nTick, nSumTick: Integer;
  pD1, pD2: PTMouseEventData;
begin
  Result := false;

  nSumTick := 0;
  for i := 0 to nReceivedCount - 2 do
  begin
    pD1 := DataList.Items[i];
    pD2 := DataList.Items[i + 1];
    if (pD1 = nil) or (pD2 = nil) then exit;
    nTick := pD1^.rTick - pD2^.rTick;
    nSumTick := nSumTick + nTick;
  end;

  nTick := Integer(nSumTick div (nReceivedCount - 1));
  if nTick >= 6000 then exit; // 1盒

  Result := true;
end;

procedure TMacroChecker.SaveMacroCase(aName: string; nCase: Integer);
  function GetCurDate: string;
  var
    nYear, nMonth, nDay: Word;
    sDate: string;
  begin
    Result := '';
    try
      DecodeDate(Date, nYear, nMonth, nDay);
      sDate := IntToStr(nYear);
      if nMonth < 10 then sDate := sDate + '0';
      sDate := sDate + IntToStr(nMonth);
      if nDay < 10 then sDate := sDate + '0';
      sDate := sDate + IntToStr(nDay);
    except
    end;
    Result := sDate;
  end;
var
  Stream: TFileStream;
  szBuffer: array[0..128] of byte;
  tmpStr, CaseStr, FileName: string;
begin
  case nCase of
    1: CaseStr := '只有MouseMove 的数值是0<x<20的人。';
    2: CaseStr := '30分钟内平均数值在误差10%范围以内的人。';
    3: CaseStr := '比5分间格更快时间传输的人。';
    4: CaseStr := '加速器使用者';
  end;
  try
    FileName := '.\MacroData\MC' + GetCurDate + '.SDB';
    if FileExists(FileName) then
    begin
      Stream := TFileStream.Create(FileName, fmOpenReadWrite);
      Stream.Seek(0, soFromEnd);
    end else
    begin
      Stream := TFileStream.Create(FileName, fmCreate);
      tmpStr := 'DateTime, Name, Case' + #13#10;
      StrPCopy(@szBuffer, tmpStr);
      Stream.WriteBuffer(szBuffer, StrLen(@szBuffer));
    end;

    tmpStr := DateToStr(Date) + ' ' + TimeToStr(Time) + ',' + aName + ',' + CaseStr + ',' + #13#10;
    StrPCopy(@szBuffer, tmpStr);
    Stream.WriteBuffer(szBuffer, StrLen(@szBuffer));
    Stream.Destroy;
  except
  end;
end;

procedure TMacroChecker.AddMouseEvent(pMouseEvent: PTCMouseEvent; anTick: Integer);
var
  pMouseEventData: PTMouseEventData;
begin
  if nSaveCount < DataList.Count then Exit;
  pMouseEventData := DataList.Items[nSaveCount - 1];
  if pMouseEventData = nil then Exit;

  pMouseEventData^.rTick := anTick;
  Move(pMouseEvent^.revent, pMouseEventData^.revent, sizeof(Integer) * 10);
  DataList.Delete(nSaveCount - 1);
  DataList.Insert(0, pMouseEventData);

  if nReceivedCount < nSaveCount then
  begin
    nReceivedCount := nReceivedCount + 1;
  end;
end;

function TMacroChecker.Check(aName: string): Boolean;
var
  bFlag: Boolean;
begin
  Result := true;

  bFlag := CheckNone;
  if bFlag = true then
  begin
    Result := false;
    exit;
  end;

  bFlag := CheckCase1;
  if bFlag = true then
  begin
    SaveMacroCase(aName, 1);
    exit;
  end;
  bFlag := CheckCase2;
  if bFlag = true then
  begin
    SaveMacroCase(aName, 2);
    exit;
  end;
  bFlag := CheckCase3;
  if bFlag = true then
  begin
    SaveMacroCase(aName, 3);
    exit;
  end;

  Result := false;
end;

constructor TUserObject.Create;
begin

  inherited Create;
  LifeDataList := TLifeDataList.Create; //附加 属性  吃物品等方面增加

  SendClass := TSendClass.Create;
  AttribClass := TAttribClass.Create(Self, SendClass);
  DesignationClass := TDesignationClass.Create(Self, sendclass);
  HaveMagicClass := THaveMagicClass.Create(Self, SendClass, AttribClass);
  WearItemClass := TWearItemClass.Create(Self, SendClass, AttribClass);
  HaveItemQuestClass := THaveItemQuestClass.Create(SendClass, AttribClass);
  HaveItemClass := THaveItemClass.Create(SELF, SendClass, AttribClass, HaveItemQuestClass);

  LifeObjectState := los_init;
  ChangeLifeTick := 0;
end;

destructor TUserObject.Destroy;
begin
  LifeDataList.Free;
  HaveItemClass.Free;
  HaveItemQuestClass.Free;
  WearItemClass.Free;
  HaveMagicClass.Free;

  DesignationClass.Free;
  AttribClass.Free;
  SendClass.Free;
  inherited destroy;
end;

function TUserObject.getcEnergy: Integer;
begin
  Result := AttribClass.AQgetEnergy;
end;

function TUserObject.getMaxLife: Integer;
begin
  Result := AttribClass.MaxLife;
end;

function TUserObject.GetAge: Integer;
begin
  Result := AttribClass.GetAge;
end;

function TUserObject.GetLifeObjectState: TLifeObjectState;
begin
  Result := LifeObjectState;
end;

procedure TUserObject.PowerLeveladd;
var
  pp: pTPowerLeveldata;
begin

  pp := PowerLevelClass.get(AttribClass.PowerLevel + 1);
  if pp = nil then exit;
  if AttribClass.AQgetEnergy < pp.PowerValue then exit;
  AttribClass.PowerLevel := AttribClass.PowerLevel + 1;
  AttribClass.PowerLevelPdata := pp;
  WearItemClass.PowerLevelUPDATE;
  if AttribClass.PowerLevel >= 1 then ShowEffect(1999 + AttribClass.PowerLevel, lek_cumulate_follow);
  if pp = nil then
    SendClass.SendPowerLevel(AttribClass.PowerLevel, '')
  else
    SendClass.SendPowerLevel(AttribClass.PowerLevel, pp.ViewName);
end;

procedure TUserObject.PowerLevelMax;
var
  pp: pTPowerLeveldata;
begin
  AttribClass.PowerLevel := PowerLevelClass.getMax(AttribClass.AQgetEnergy);
  pp := PowerLevelClass.get(AttribClass.PowerLevel);
  AttribClass.PowerLevelPdata := pp;
  WearItemClass.PowerLevelUPDATE;
  if pp = nil then
    SendClass.SendPowerLevel(AttribClass.PowerLevel, '')
  else
    SendClass.SendPowerLevel(AttribClass.PowerLevel, pp.ViewName);
end;

procedure TUserObject.PowerLeveldec;
var
  pp: pTPowerLeveldata;
begin

  AttribClass.PowerLevel := AttribClass.PowerLevel - 1;
  if AttribClass.PowerLevel < 0 then AttribClass.PowerLevel := 0;
  pp := PowerLevelClass.get(AttribClass.PowerLevel);
  if pp <> nil then
  begin
    if AttribClass.AQgetEnergy < pp.PowerValue then
    begin
      AttribClass.PowerLevel := 0;
    end;
  end else
  begin
    AttribClass.PowerLevel := 0;
  end;
  AttribClass.PowerLevelPdata := pp;
  WearItemClass.PowerLevelUPDATE;


  if AttribClass.PowerLevel >= 1 then ShowEffect(1999 + AttribClass.PowerLevel, lek_cumulate_follow);
  if pp = nil then
    SendClass.SendPowerLevel(AttribClass.PowerLevel, '')
  else
    SendClass.SendPowerLevel(AttribClass.PowerLevel, pp.ViewName);
end;

procedure TUserObject.SetLifeData;
var
//    per: integer;
   // pp: pTPowerLeveldata;
  tempLifeData: tLifeData;
begin
  FillChar(LifeData, SizeOf(TLifeData), 0);
//称号
  GatherLifeData(LifeData, DesignationClass.LifeData);
    //门派
  if uGuildObject <> nil then
    GatherLifeData(LifeData, TGuildObject(uGuildObject).LifeData);
    //队伍
  if uProcessionclass <> nil then
    GatherLifeData(LifeData, TProcessionclass(uProcessionclass).LifeData);
    //境界  普通值
//    pp := PowerLevelClass.get(PowerLevel);
  if AttribClass.PowerLevelPdata <> nil then
    GatherLifeData(LifeData, AttribClass.PowerLevelPdata.LifeData);
    //本身
  GatherLifeData(LifeData, AttribClass.AttribLifeData);
    //本身 任务属性
  GatherLifeData(LifeData, AttribClass.AttribQuestData.AttribLifeData);
    //装备
  GatherLifeData(LifeData, WearItemClass.WearItemLifeData);
    //背包的
  GatherLifeData(LifeData, HaveItemClass.HaveItemLifeData.rLifedata);
    //武功
  GatherLifeData(LifeData, HaveMagicClass.HaveMagicLifeData);
    //其他附加 列表
  GatherLifeData(LifeData, LifeDataList.LifeData);

    //三魂
  tempLifeData := ItemLifeDataClass.LifeData3f_sky;
  GatMultiplyLifeData(tempLifeData, AttribClass.AQget3f_sky);
  GatherLifeData(LifeData, tempLifeData);

  tempLifeData := ItemLifeDataClass.LifeData3f_terra;
  GatMultiplyLifeData(tempLifeData, AttribClass.AQget3f_terra);
  GatherLifeData(LifeData, tempLifeData);

  tempLifeData := ItemLifeDataClass.LifeData3f_fetch;
  GatMultiplyLifeData(tempLifeData, AttribClass.AQget3f_fetch);
  GatherLifeData(LifeData, tempLifeData);

  CheckLifeData(LifeData);
  BasicData.Feature.AttackSpeed := LifeData.AttackSpeed;
  bosendLifeData := true;

end;


procedure TUserObject.SetTargetId(aid: integer);
var
  bo: TBasicObject;
begin

  if (TargetId <> 0) and (aid = 0) then
  begin
    PrevTargetId := TargetId;
  end;

  if aid = BasicData.id then exit;
  TargetId := aid;
  if TargetId = 0 then exit;

  bo := TBasicObject(GetViewObjectById(TargetId));
  if bo = nil then exit;

  //攻击人 清除附加状态属性表
  if bo.BasicData.Feature.rrace = RACE_HUMAN then
    if LifeDataList.DataList.Count > 0 then LifeDataList.Clear;
  if bo.State = wfs_die then exit;
  if TUser(Self).UseSkillKind <> ITEM_KIND_SHOWSKILL then
  begin
    if bo.BasicData.Feature.rHideState = hs_0 then
    begin
      SetTargetId(0);
      exit;
    end;
  end;

  if Basicdata.Feature.rfeaturestate <> wfs_care then CommandChangeCharState(wfs_care, FALSE);

  LifeObjectState := los_attack;
end;



procedure TUserObject.StartProcess;
var
  str: string;
  I: INTEGER;
begin
  inherited StartProcess;

  RopeTarget := 0;
  RopeTick := 0;
  RopeOldX := 0;
  RopeOldy := 0;

  boShiftAttack := TRUE;
  SearchTick := 0;
  SayTick := 0;
  FreezeTick := 0;
  DiedTick := 0;
  HitedTick := 0;
    // StructedTick := 0;
  TargetId := 0;
  PrevTargetId := 0;
  LifeObjectState := los_none;

  Basicdata.id := GetNewUserId;

  WearItemClass.UPFeature;
  I := WearItemClass.GetWeaponType;
  if I = 7 then
  begin
    I := MAGICTYPE_HAMMERING;
  end;
  HaveMagicClass.SetHaveItemMagicType(I);
  HaveMagicClass.SelectBasicMagic(I, 100, str);

  BasicData.nx := BasicData.x;
  BasicData.ny := BasicData.y;

  SendClass.SendMap(BasicData, Manager.MapName, Manager.ObjName, Manager.RofName, Manager.TilName, Manager.SoundBase, Manager.Title);

end;

procedure TUserObject.EndProcess;
begin
  WearItemClass.SaveToSdb(@Connector.CharData);
  HaveItemClass.SaveToSdb(@Connector.CharData);
  HaveItemQuestClass.SaveToSdb(@Connector.CharData);
  AttribClass.SaveToSdb(@Connector.CharData);
  HaveMagicClass.SaveToSdb(@Connector.CharData);
  DesignationClass.SaveToSdb(@Connector.CharData);

  FreezeTick := 0;
  DiedTick := 0;
  HitedTick := 0;
    // StructedTick := 0;
  TargetId := 0;
  LifeObjectState := los_init;
  Name := '';
  IP := '';

  inherited EndProcess;
end;

function TUserObject.AllowCommand(CurTick: integer): Boolean;
begin
  Result := TRUE;
  if FreezeTick > CurTick then Result := FALSE;
  if BasicData.Feature.rFeatureState = wfs_die then Result := FALSE;
end;

//攻击 aattacker 攻击者ID
// ret := CommandHited(SenderInfo.id, aSubData.HitData, percent);
//被攻击

function TUserObject.CommandHited(var SenderInfo: TBasicData; aattacker: integer; aHitData: THitData; apercent: integer): integer;
var
    // CurTick : Integer;
  snd, n, decbody, dechead, decArm, decLeg, exp: integer;
  SubData: TSubData;
 //   str: string;
begin
  Result := 0;
  //自动反击

  case aHitData.HitTargetsType of
    _htt_All: ;
    _htt_Monster: exit;
    _htt_Npc: exit;
    _htt_nation: if SenderInfo.Feature.rnation = BasicData.Feature.rnation then exit;
  end;

  if (fcounterattack_state) and (TargetId = 0) then SetTargetId(aattacker);

  //计算 躲闪
  n := LifeData.avoid + aHitData.ToHit;
  n := Random(n);
  if n < LifeData.avoid then exit; //自己完全躲闪

    {
    CurTick := mmAnsTick;
    if CurTick <= StructedTick + LifeData.recovery then exit;
    StructedTick := CurTick;
    }
  if AttribClass.PowerLevelPdata <> nil then
  begin
    if (AttribClass.PowerShieldBoState = false)
      and (attribClass.PowerShieldLife > 0) then
    begin
      n := aHitData.damageBody - AttribClass.PowerShieldArmor;
      if n <= 0 then n := 1;
      attribClass.PowerShieldLife := attribClass.PowerShieldLife - n;

      if AttribClass.PowerShieldLife <= 0 then
      begin
      //破坏 了
        AttribClass.PowerShieldLife := 0;
        AttribClass.PowerShieldBoState := true;
        AttribClass.PowerShieldTick := mmAnsTick;
      end else
      begin
      //盾完好，抵消50%的损害。
        aHitData.damagehead := aHitData.damagehead div 2;
        aHitData.damageArm := aHitData.damageArm div 2;
        aHitData.damageLeg := aHitData.damageLeg div 2;
        aHitData.damageBody := aHitData.damageBody div 2;
      end;
      ShowEffect(AttribClass.PowerLevel + 2999, lek_none);
    end;
  end;

    // 贸澜 乔秦 眉仿
  if apercent = 100 then
  begin
    decHead := aHitData.damagehead - LifeData.armorHead;
    decArm := aHitData.damageArm - LifeData.armorArm;
    decLeg := aHitData.damageLeg - LifeData.armorLeg;
    decbody := aHitData.damageBody - LifeData.armorBody;
  end else
  begin
    decHead := (aHitData.damagehead * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorHead;
    decArm := (aHitData.damageArm * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorArm;
    decLeg := (aHitData.damageLeg * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorLeg;
    decbody := (aHitData.damageBody * apercent div 100) * aHitData.HitFunctionSkill div 10000 - LifeData.armorBody;
  end;

  if decHead <= 0 then decHead := 1;
  if decArm <= 0 then decArm := 1;
  if decLeg <= 0 then decLeg := 1;
  if decbody <= 0 then decbody := 1;




    // 郴己俊 狼茄 乔秦 皑家 (个烹俊父 利侩凳)
  n := AttribClass.MaxLife div decBody;
  if n <= 0 then n := 1;
  if n <= 4 then
  begin
    decBody := decBody - decBody * AttribClass.AQgetAdaptive div 20000; // 耐性满后可减少 50% 攻击      Adaptive 耐性
  end;
  if decBody <= 0 then decBody := 1;

    // 眉仿家葛
  AttribClass.CurHeadLife := AttribClass.CurHeadLife - decHead;
  AttribClass.CurArmLife := AttribClass.CurArmLife - decArm;
  AttribClass.CurLegLife := AttribClass.CurLegLife - decLeg;
  AttribClass.CurLife := AttribClass.CurLife - decBody;
    //扣持久
  WearItemClass.DecDurability;
    //  磊技焊沥...
 {
    Case aHitData.HitLevel of
       0..4999 :
          FreezeTick := mmAnsTick;
       5000..5999 :
          FreezeTick := mmAnsTick + (TempData.recovery div 10);
       6000..6999 :
          FreezeTick := mmAnsTick + (TempData.recovery div 8);
       7000..7999 :
          FreezeTick := mmAnsTick + (TempData.recovery div 6);
       8000..8999 :
          FreezeTick := mmAnsTick + (TempData.recovery div 4);
       9000..9499 :
          FreezeTick := mmAnsTick + (TempData.recovery div 2);  50
       9500..9999 :
          FreezeTick := mmAnsTick + TempData.recovery;
    end;
}{
    Case aHitData.HitLevel of
       9500..9999 : sdec := 40;
       9000..9499 : sdec := 35;
       8000..8999 : sdec := 30;
       7000..7999 : sdec := 20;
       6000..6999 : sdec := 10;
       5000..5999 : sdec := 5;
       0..4999 :    sdec := 0;
    end;
    m := AttribClass.MaxLife div decbody;
    case m of
       0..15  : ddec := 10;
       16..20 : ddec := 5;
       else     ddec := 0;
    end;
    m := sdec + ddec + 50;

    FreezeTick := mmAnsTick + TempData.recovery * m div 100;
    }

  FreezeTick := mmAnsTick + LifeData.recovery;

  if AttribClass.MaxLife <= 0 then BasicData.LifePercent := 0
  else BasicData.LifePercent := AttribClass.CurLife * 100 div AttribClass.MaxLife;

  SubData.percent := BasicData.LifePercent;
  SubData.attacker := aattacker;
  SubData.attackerMasterId := BasicData.MasterId;
  SubData.HitData.HitType := aHitData.HitType;

  SendLocalMessage(NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);
  Result := n;

    // 磷阑订 酒公 版摹档 绝澜
  if AttribClass.CurLife = 0 then
  begin
        { SetWordString(SubData.SayString, name);
         if SendLocalMessage(aattacker, FM_KillDead, BasicData, SubData) = PROC_TRUE then
         begin
             str := GetWordString(SubData.SayString);
             if str <> '' then
                 SendClass.SendChatMessage(str, SAY_COLOR_GRADE6lcred);
         end;}
    exit;
  end;

    //赖性： 伤害 是最大活力 的 1/4 + 增加。
  n := AttribClass.MaxLife div decBody;
  if n <= 4 then
    if (SenderInfo.boNotAddExp = false) then
      AttribClass.AddAdaptive(DEFAULTEXP);

    //经验：伤害 是最大活力 的 1/15 +原始。 n^/15^
  n := AttribClass.MaxLife div decbody;
  if n > 15 then exp := DEFAULTEXP // 15 措捞惑 嘎阑父 窍促搁 1000
  else exp := DEFAULTEXP * n * n div (15 * 15); // 15措 嘎栏搁 磷备档 巢栏搁 10 => 500   n 15 => 750   5=>250

  SubData.ExpData.Exp := exp;
  SubData.ExpData.ExpType := _et_HUMAN;
  SubData.ProcessionClass := nil;
  SubData.ExpData.LevelMax := 9999;
  if (apercent = 100) then
  begin
    if not isUserID(aAttacker) then
    begin // 内膏飘啊 酒聪搁 个户 倾侩
            //通知aAttacker攻击者 获得 攻击经验
      SendLocalMessage(aattacker, FM_ADDATTACKEXP, BasicData, SubData);
    end;
  end;

    //护体经验 DEFAULTEXP=10000  攻击目标不是人
  if (isUserID(aAttacker) = false) and (SenderInfo.boNotAddExp = false) then
  begin
        //通知BasicData.Id自己 防御经验
    SubData.ExpData.Exp := DEFAULTEXP - SubData.ExpData.Exp;
     //   SendLocalMessage(BasicData.Id, FM_ADDPROTECTEXP, BasicData, SubData);
    HaveMagicClass.AddProtectExp(SubData.ExpData.ExpType, SubData.ExpData.Exp);
  end;

  snd := Random(100);
  if snd < 40 then
  begin
    case AttribClass.AQgetAge of
      0..5999: snd := 2002;
      6000..11900: snd := 2004;
    else snd := 2000;
    end;
    if not BasicData.Feature.rboman then snd := snd + 200;
        //SetWordString(SubData.SayString, IntToStr(snd) + '.wav');
    SubData.sound := snd;
    SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
        //通知 所有 人 有一个伤害声音
  end;

    //取消攻击人有经验
  BoSysopMessage(IntToStr(decBody) + ' : ' + IntToStr(exp), 10);

  Result := n;
end;

//弓
{流程
1，CommandBowing
2，SendLocalMessage(NOTARGETPHONE, FM_HIT, BasicData, SubData);
3，FM_HIT 使用 CommandHited 计算 攻击操作
4,UPDATE,   los_attack  重新到1}

procedure TUserObject.CommandBowing(CurTick: integer; atid: integer; atx, aty: word; boSend: Boolean);
var
  snd, pos: integer;
  boHitAllow: Boolean;
  SubData: TSubData;
  tmpItemData: TItemData;
begin
  if not AllowCommand(CurTick) then exit;

  if HitedTick + LifeData.AttackSpeed > CurTick then exit;

  if HaveMagicClass.pCurAttackMagic = nil then exit;

  if GuildList.isGuildItem(atid) = true then
  begin //门派石 武器 检察
    CommandChangeCharState(wfs_normal, FALSE);
    ShootBowCount := 0;
    exit;
  end;
  if atid = 0 then exit;
  if BasicData.id = atid then exit;
  if ShootBowCount > (HaveMagicClass.pCurAttackMagic^.rcSkillLevel div 2000) + 1 then
  begin
    SetTargetId(0);
    ShootBowCount := 0;
    exit;
  end;
  inc(ShootBowCount);

  boHitAllow := FALSE;
  case HaveMagicClass.pCurAttackMagic^.rMagicType of
    MAGICTYPE_BOWING, MAGICTYPE_2BOWING: // 泵贱
      begin
        pos := HaveItemClass.FindKindItem(7);
        if pos <> -1 then
        begin
          HaveItemClass.ViewItem(pos, @tmpItemData);
//                    tmpItemData.rOwnerName := '';
          if HaveItemClass.DeleteKeyItem(pos, 1) then boHitAllow := TRUE;
        end;
      end;
    MAGICTYPE_THROWING, MAGICTYPE_2THROWING: // 捧过
      begin
        pos := HaveItemClass.FindKindItem(8);
        if pos <> -1 then
        begin
          HaveItemClass.ViewItem(pos, @tmpItemData);
//                    tmpItemData.rOwnerName := '';
          if HaveItemClass.DeleteKeyItem(pos, 1) then boHitAllow := TRUE;
        end;
      end;
  else
    boHitAllow := TRUE;
  end;

  if boHitAllow = FALSE then exit;

  HitedTick := CurTick;

  if HaveMagicClass.DecEventMagic(HaveMagicClass.pCurAttackMagic) = FALSE then
  begin
        //  SendClass.SendChatMessage('没能攻击', SAY_COLOR_SYSTEM);
    SendClass.SendNUMSAY(numsay_NOHIT, SAY_COLOR_SYSTEM); //  '没能攻击',                //1  numsay_NOHIT

    exit;
  end;

  if GetViewDirection(BasicData.x, BasicData.y, atx, aty) <> basicData.dir then
    CommandTurn(GetViewDirection(BasicData.x, BasicData.y, atx, aty), TRUE);

  SubData.motion := BasicData.Feature.rhitmotion;

  if HaveMagicClass.pCurAttackMagic^.rcSkillLevel = 9999 then
  begin
    SubData.motionMagicType := HaveMagicClass.pCurAttackMagic^.rMagicType + 1;
    SubData.motionMagicColor := HaveMagicClass.pCurAttackMagic^.rEffectColor;

    SendLocalMessage(NOTARGETPHONE, FM_MOTION2, BasicData, SubData);
  end
  else
    SendLocalMessage(NOTARGETPHONE, FM_MOTION, BasicData, SubData); //攻击 动作

  SubData.HitData.damageBody := LifeData.damageBody;
  SubData.HitData.damageHead := LifeData.damageHead;
  SubData.HitData.damageArm := LifeData.damageArm;
  SubData.HitData.damageLeg := LifeData.damageLeg;
    // SubData.HitData.ToHit := 100 - LifeData.avoid;
  SubData.HitData.ToHit := 75 + LifeData.accuracy;
  SubData.HitData.HitType := 1;
  SubData.HitData.HitLevel := 0;
  SubData.HitData.HitFunction := 0;
  SubData.HitData.HitFunctionSkill := 0;
  SubData.HitData.HitedCount := 0;
  SubData.HitData.HitTargetsType := BasicData.HitTargetsType;
  if HaveMagicClass.pCurAttackMagic <> nil then
    SubData.HitData.HitLevel := HaveMagicClass.pCurAttackMagic^.rcSkillLevel;

  AttribClass.CurLife := AttribClass.CurLife - HaveMagicClass.pCurattackmagic^.rEventDecLife;

  SubData.TargetId := atid;
  SubData.tx := atx;
  SubData.ty := aty;
    // SubData.BowImage := HaveMagicClass.pCurAttackMagic^.rBowImage;
  SubData.SubName := tmpItemData.rName; //射动态物体 需要
  SubData.BowImage := tmpItemData.rActionImage;
  SubData.BowSpeed := HaveMagicClass.pCurAttackMagic^.rBowSpeed;
  SubData.BowType := HaveMagicClass.pCurAttackMagic^.rBowType;
  SubData.EEffectNumber := HaveMagicClass.pCurAttackMagic^.rEEffectNumber;

  SubData.HitData.HitFunction := 0;
  SubData.HitData.HitFunctionSkill := 0;
    /////////////////1
    //增加原因远程灵动带攻击
  LastGainExp := 0;
  if HaveMagicClass.pCurEctMagic <> nil then
  begin
    case HaveMagicClass.pCurEctMagic^.rFunction of
      MAGICFUNC_5HIT, MAGICFUNC_8HIT:
        begin
          SubData.HitData.HitFunction := HaveMagicClass.pCurEctMagic^.rFunction;
          SubData.HitData.HitFunctionSkill := HaveMagicClass.pCurEctMagic^.rcSkillLevel;
        end;
    end;
  end;
    /////////////////1
  SendLocalMessage(NOTARGETPHONE, FM_BOW, BasicData, SubData);
    ///////////////////2
    //增加原因远程灵动带攻击
  if (HaveMagicClass.pCurEctMagic <> nil) and (SubData.HitData.HitedCount > 1) then
  begin
    HaveMagicClass.AddEctExp(_et_HUMAN, LastGainExp);
  end;
    ///////////////////2
  snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber;
  if snd <> 0 then
  begin
    case HaveMagicClass.pCurAttackMagic^.rcSkillLevel of
      0..4999: snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber;
      5000..8999: snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber + 1;
    else snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber + 2;
    end;

        // SetWordString(SubData.SayString, InttoStr(snd) + '.wav');
    SubData.sound := snd;
    SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);

  end;

  if boSend then
    if HaveMagicClass.pCurAttackMagic^.rcSkillLevel = 9999 then
      SendClass.SendMotion2(BasicData.id, SubData.motion, SubData.motionMagicType, SubData.motionMagicColor)
    else
      SendClass.SendMotion(BasicData.id, SubData.motion);
end;
//打
{流程
1，CommandHit
2，SendLocalMessage(NOTARGETPHONE, FM_HIT, BasicData, SubData);
3，CommandHited
4,UPDATE,   los_attack  重新到1}

function TUserObject.CommandHit(CurTick: integer; boSend: Boolean; rdir: integer): Boolean;
var
  snd, allowAttackTick: integer;
  per, nskill: integer;
//    xx, yy: word;
  SubData: TSubData;
//    ahitwidth: integer;                                                         //攻击范围
begin
  Result := FALSE;
    //时间 等控制
  if not AllowCommand(CurTick) then exit;
    //当前 武功检查 武器是挖矿结束

  if (WearItemClass.GetWeaponType = 7)
    or (HaveMagicClass.pCurAttackMagic = nil) then
  begin
    CommandChangeCharState(wfs_normal, FALSE);
    EXIT;
  end;

    //门派石 武器 检察
  if ((GetWeaponGuild) <> GuildList.isGuildItem(TargetId)) then
  begin
    CommandChangeCharState(wfs_normal, FALSE);
    exit;
  end;

    //测试 目标是否有物体
   { xx := BasicData.x;
    yy := BasicData.y;
    GetNextPosition(rdir, xx, yy);
    if Maper.getUser(xx, yy) <> TargetId then exit;
    }
    //////////////////////////////////////////////////////
    //             脚防御小到一定比例 减少攻击速度      //
    //////////////////////////////////////////////////////
  per := (AttribClass.CurLegLife * 100 div AttribClass.MaxLife);

  if per > 50 then
    AllowAttackTick := LifeData.AttackSpeed
  else AllowAttackTick := LifeData.AttackSpeed + LifeData.AttackSpeed * (50 - per) div 50; // 100% 沥档 词霸 锭妨柳促.

  if HitedTick + AllowAttackTick > CurTick then exit;
  HitedTick := CurTick;

    //扣 属性值
  if HaveMagicClass.DecEventMagic(HaveMagicClass.pCurAttackMagic) = FALSE then
  begin
        //不够 扣 需要的能量
      //  if FreezeTick < (mmAnsTick + 10) then FreezeTick := mmAnsTick + 10;
       // SendClass.SendChatMessage('攻击失败后10单位时间不能攻击', SAY_COLOR_GRADE6lcred);
    SendClass.SendNUMSAY(numsay_NOHIT, SAY_COLOR_SYSTEM); //  '没能攻击',                //1  numsay_NOHIT
    exit;
  end;
    //扣持久
  WearItemClass.DecDurabilityWeapon;
  per := (AttribClass.CurArmLife * 100 div AttribClass.MaxLife);
    //////////////////////////////////////////////////////
    //             手防御小到一定比例 减少攻击          //
    //////////////////////////////////////////////////////
  SubData.TargetId := TargetId;
  if per > 50 then
  begin
    SubData.HitData.damageBody := LifeData.damageBody; //身体 伤害值 damage 伤害
    SubData.HitData.damageHead := LifeData.damageHead; //头   伤害值
    SubData.HitData.damageArm := LifeData.damageArm; //  武器 伤害值
    SubData.HitData.damageLeg := LifeData.damageLeg; //  腿   伤害值
  end else
  begin
    SubData.HitData.damageBody := LifeData.damageBody - LifeData.damageBody * (50 - per) div 50;
    SubData.HitData.damageHead := LifeData.damageHead - LifeData.damageHead * (50 - per) div 50;
    SubData.HitData.damageArm := LifeData.damageArm - LifeData.damageArm * (50 - per) div 50;
    SubData.HitData.damageLeg := LifeData.damageLeg - LifeData.damageLeg * (50 - per) div 50;
  end;

    // SubData.HitData.ToHit := 100 - tempData.avoid;
  SubData.HitData.ToHit := 75 + LifeData.accuracy;
  SubData.HitData.HitType := 0;
  SubData.HitData.HitLevel := 0;
  SubData.HitData.boHited := FALSE;
  SubData.HitData.HitFunction := 0;
  SubData.HitData.HitFunctionSkill := 0;
  SubData.HitData.HitedCount := 0;
  SubData.HitData.HitTargetsType := BasicData.HitTargetsType;
//    ahitwidth := 0;
  if HaveMagicClass.pCurAttackMagic <> nil then
    SubData.HitData.HitLevel := HaveMagicClass.pCurAttackMagic^.rcSkillLevel;
  if HaveMagicClass.pCurEctMagic <> nil then
  begin
    case HaveMagicClass.pCurEctMagic^.rFunction of
      MAGICFUNC_5HIT, MAGICFUNC_8HIT:
        begin
          SubData.HitData.HitFunction := HaveMagicClass.pCurEctMagic^.rFunction;
          SubData.HitData.HitFunctionSkill := HaveMagicClass.pCurEctMagic^.rcSkillLevel;
//                    ahitwidth := 1;
        end;
    end;
  end;

  LastGainExp := 0;
  if rdir <> BasicData.dir then CommandTurn(rdir, TRUE);
  SendLocalMessage(NOTARGETPHONE, FM_HIT, BasicData, SubData); //NOTARGETPHONE 群攻击 所以发给所有人

    //---------------FM_HIT消息发送出去---------------------------------------------------------------

  if (HaveMagicClass.pCurEctMagic <> nil) and (SubData.HitData.HitedCount > 1) then
  begin
    HaveMagicClass.AddEctExp(_et_HUMAN, LastGainExp);
  end;
  if SubData.HitData.boHited then
  begin
    snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber;
    if snd <> 0 then
    begin
      case HaveMagicClass.pCurAttackMagic^.rcSkillLevel of
        0..4999: snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber;
        5000..8999: snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber + 2;
      else snd := HaveMagicClass.pCurAttackMagic^.rSoundStrike.rWavNumber + 4;
      end;

            //  SetWordString(SubData.SayString, InttoStr(snd) + '.wav');
      SubData.sound := snd;
      SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);

    end;
  end else
  begin
    snd := HaveMagicClass.pCurAttackMagic^.rSoundSwing.rWavNumber;
    if snd <> 0 then
    begin
      case HaveMagicClass.pCurAttackMagic^.rcSkillLevel of
        0..4999: snd := HaveMagicClass.pCurAttackMagic^.rSoundSwing.rWavNumber;
        5000..8999: snd := HaveMagicClass.pCurAttackMagic^.rSoundSwing.rWavNumber + 2;
      else snd := HaveMagicClass.pCurAttackMagic^.rSoundSwing.rWavNumber + 4;
      end;

            // SetWordString(SubData.SayString, InttoStr(snd) + '.wav');
      SubData.sound := snd;
      SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
    end;
  end;

    // 鼻过阑 荤侩窍绰 荤恩篮 荐访摹啊 臭酒瘤搁(50) 30锅捞唱 31锅 葛拣栏肺 傍拜茄促.
  SubData.motion := BasicData.Feature.rhitmotion;

    // 父距 荤侩磊啊 荤侩窍绰 公傍捞 八过捞唱 档过老版快俊绰
    // 荐访摹啊 50.00焊促 臭酒瘤搁 subdata.motion 篮 32锅捞芭唱 37锅栏肺 焊咯霖促.
  case HaveMagicClass.pCurAttackMagic.rMagicType of
    MAGICTYPE_WRESTLING, MAGICTYPE_2WRESTLING:
      begin
        if (HaveMagicClass.pCurAttackMagic^.rcSkillLevel > 5000) then
          SubData.motion := 30 + Random(2);
          //30，31
      end;
    MAGICTYPE_FENCING, MAGICTYPE_2FENCING:
    //剑
      begin
        nskill := HaveMagicClass.pCurAttackMagic^.rcSkillLevel;
        if (nskill > 5000) then
        begin
          if Random(2) = 1 then SubData.motion := 38;
          //（32，38）
        end
      end;
    MAGICTYPE_SWORDSHIP, MAGICTYPE_2SWORDSHIP: //刀
      begin
        nskill := HaveMagicClass.pCurAttackMagic^.rcSkillLevel;
        if (nskill > 5000) then
        begin
          if Random(2) = 1 then SubData.motion := 37;
          //（32，37）
        end
      end;
  end;
  if HaveMagicClass.pCurAttackMagic^.rcSkillLevel = 9999 then
  begin
    SubData.motionMagicType := HaveMagicClass.pCurAttackMagic^.rMagicType + 1;
    SubData.motionMagicColor := HaveMagicClass.pCurAttackMagic^.rEffectColor;

    SendLocalMessage(NOTARGETPHONE, FM_MOTION2, BasicData, SubData);
  end
  else
    SendLocalMessage(NOTARGETPHONE, FM_MOTION, BasicData, SubData); //砍 动作

  if boSend then
    if HaveMagicClass.pCurAttackMagic^.rcSkillLevel = 9999 then
      SendClass.SendMotion2(BasicData.id, SubData.motion, SubData.motionMagicType, SubData.motionMagicColor)
    else
      SendClass.SendMotion(BasicData.id, SubData.motion);
  Result := TRUE;
end;

function TUserObject.CommandDredgeHit(CurTick: integer; boSend: Boolean; rdir: integer): Boolean;
var
  SubData: TSubData;
  str: string;
begin
  Result := FALSE;
    //时间 等控制
  if not AllowCommand(CurTick) then exit;
  if WearItemClass.GetWeaponType <> 7 then EXIT;

  if HitedTick + 120 > CurTick then exit;
  HitedTick := CurTick;


    //扣持久
  if WearItemClass.DecDurabilityWeapon = false then
  begin
    SetTargetId(0);
    exit;
  end;

  SubData.TargetId := TargetId;
  SubData.HitData.HitLevel := AttribClass.PowerLevelMax;
  SubData.SubName := WearItemClass.GetWeaponName;
  SubData.HitData.HitFunction := 0;

  if rdir <> BasicData.dir then CommandTurn(rdir, TRUE);
  if SendLocalMessage(TargetId, FM_Dredge, BasicData, SubData) = PROC_TRUE then
  begin
    str := GetWordString(SubData.SayString);
    if str <> '' then
      SendClass.SendLeftText(str, WinRGB(22, 22, 0), mtLeftText3);
  end;

  SubData.motion := BasicData.Feature.rhitmotion;
   // SendLocalMessage(NOTARGETPHONE, FM_MOTION, BasicData, SubData);             //砍 动作
  SubData.motionMagicType := 301;
  SubData.motionMagicColor := 2;

  SendLocalMessage(NOTARGETPHONE, FM_MOTION2, BasicData, SubData);

  if boSend then
    SendClass.SendMotion2(BasicData.id, SubData.motion, SubData.motionMagicType, SubData.motionMagicColor);
//        SendClass.SendMotion(BasicData.id, SubData.motion);
  Result := TRUE;
end;
//Turn 转动

procedure TUserObject.CommandTurn(adir: word; boSend: Boolean);
var
  SubData: TSubData;
begin
  if not AllowCommand(mmAnsTick) then exit;

  if BasicData.Feature.rFeatureState = wfs_die then exit;
  BasicData.dir := adir;
  SendLocalMessage(NOTARGETPHONE, FM_TURN, BasicData, SubData);
  if boSend then
    SendClass.SendTurn(BasicData);
end;

procedure TUserObject.CommandChangeCharState(aFeatureState: TFeatureState; boSend: Boolean);
var
  snd: integer;
  SubData: TSubData;
begin
  case aFeatureState of
    wfs_die: LifeObjectState := los_die;
  else LifeObjectState := los_none;
  end;
  if aFeatureState = wfs_die then
  begin
        //自己死亡 处理
    if Manager.boPosDie = false then
    begin
      Maper.MapProc(BasicData.Id, MM_HIDE, BasicData.x, BasicData.y, BasicData.x, BasicData.y, BasicData);
    end;
    HaveItemClass.Ondie;

    SetTargetId(0);
    DiedTick := mmAnsTick;

    case AttribClass.AQgetAge of
      0..5999: snd := 2003;
      6000..11900: snd := 2005;
    else snd := 2001;
    end;
    if not BasicData.Feature.rboman then snd := snd + 200;

        // SetWordString(SubData.SayString, IntToStr(snd) + '.wav');
    SubData.sound := snd;
    SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
    SendClass.SendReliveTime(3000); //发送 30秒后复活


  end;

  if aFeatureState = wfs_running then
  begin
    if HaveMagicClass.pCurRunningMagic <> nil then
    begin
      if HaveMagicClass.pCurRunningMagic^.rcSkillLevel > 8500 then aFeatureState := wfs_running2;
    end;
  end;

  WearItemClass.SetFeatureState(aFeatureState);
  WearItemClass.UPFeature;

  BasicData.Feature.rTeamColor := 0;
  case aFeatureState of
    wfs_running,
      wfs_running2:
      begin
        if HaveMagicClass.pCurRunningMagic <> nil then
        begin
          if HaveMagicClass.pCurRunningMagic^.rcSkillLevel > 5000 then
            BasicData.Feature.rTeamColor := 4;
        end;
      end;
    wfs_sitdown:
      begin
        if HaveMagicClass.pCurBreathngMagic <> nil then
          BasicData.Feature.rTeamColor := HaveMagicClass.pCurBreathngMagic^.rcSkillLevel div 1000; //aaa
      end;
  end;

  SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
  AttribClass.FeatureState := BasicData.Feature.rfeaturestate;
end;

function TUserObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  str: string;
  ret, percent, i: integer;
  boothData: TBoothItemDataArr;
    //   xx, yy: word;
  procedure hit_Kill();
  begin
    case SenderInfo.BasicObjectType of
      botNpc: SendClass.SendChatMessage(format('您被NPC【%S】杀死。', [SenderInfo.ViewName]), SAY_COLOR_GRADE6lcred);
      botMonster: SendClass.SendChatMessage(format('您被怪物【%S】杀死。', [SenderInfo.ViewName]), SAY_COLOR_GRADE6lcred);
      botUser:
        begin
          SendClass.SendChatMessage(format('您被玩家【%S】杀死。', [SenderInfo.Name]), SAY_COLOR_GRADE6lcred);
          TUser(SenderInfo.P).SendClass.SendChatMessage(format('您谋杀了【%S】。', [Name]), SAY_COLOR_GRADE6lcred);
        end;
    else
      begin
        SendClass.SendChatMessage(format('您被【%S】杀死。', [SenderInfo.Name]), SAY_COLOR_GRADE6lcred);
      end;
    end;
  end;

begin
  Result := PROC_FALSE;
  if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit;
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
  if Result = PROC_TRUE then exit;

  case Msg of
    FM_MOVE:
      begin
        if SenderInfo.ID = BasicData.ID then exit;
        if BasicData.Feature.rfeaturestate = wfs_die then exit;
        if (TUser(Self).SysopScope = 101) then exit;
        if SenderInfo.boMoveKill then
        begin
          if GetLargeLength(BasicData.x, BasicData.y, SenderInfo.x, SenderInfo.y) <= SenderInfo.boMoveKillView then
          begin

            BasicData.LifePercent := 0;
            AttribClass.CurLife := 0;
            CommandChangeCharState(wfs_die, FALSE);
          end;
        end;
      end;
    FM_HIDE:
      begin
        if TargetId = SenderInfo.id then TargetId := 0;
      end;
    FM_UserWearItem:
      begin
        if hfu = BasicData.id then
        begin

          for i := 0 to 13 do
          begin
            aSubData.ItemData.rName := '';
            WearItemClass.ViewItem(i, @aSubData.ItemData);
            Tuser(SenderInfo.P).SendClass.SendWearItem(i, witWearUser, aSubData.ItemData);
                        //   str := GetItemDataInfo(aSubData.ItemData);
                        //   Tuser(SenderInfo.P).SendClass.sendItemText(ittWearItemTextUser, i, str);
          end;
          for i := 0 to 13 do
          begin
            aSubData.ItemData.rName := '';
            WearItemClass.ViewItemFD(i, @aSubData.ItemData);
            Tuser(SenderInfo.P).SendClass.SendWearItem(i, witWearFDUser, aSubData.ItemData);
                        //   str := GetItemDataInfo(aSubData.ItemData);
                         //  Tuser(SenderInfo.P).SendClass.sendItemText(ittWearItemTextFDUser, i, str);
          end;
        end;
      end;
    FM_CLICK: //单点 人
      begin
        if hfu = BasicData.id then
        begin
          str := '';
          str := str + '名称: ' + Name;
          if AttribClass.PowerLevelPdata <> nil then str := str + ' 境界: ' + AttribClass.PowerLevelPdata.ViewName;
          if LifeDataList.text <> '' then str := str + ' 状态: ' + LifeDataList.text;
          str := str + #13;
          if GuildName <> '' then str := str + '门派名称: ' + GuildName + '  ' + '门派职称:' + GuildGrade + #13;
          str := str + '使用武功:' + HaveMagicClass.GetUsedMagicList + #13;
          if ConsortName <> '' then str := str + '配偶:' + ConsortName;
          SetWordString(aSubData.SayString, str);
          aSubData.TargetId := BasicData.id;
        end;
      end;
    FM_DEADHIT: //GM指令 @爆
      begin
        if SenderInfo.id = BasicData.id then exit;
        if BasicData.Feature.rfeaturestate = wfs_die then
        begin
          Result := PROC_TRUE;
          exit;
        end;
        if aSubData.TargetId <> 0 then
        begin
          Result := PROC_TRUE;
          exit;
        end;
        AttribClass.CurLife := 0;
        CommandChangeCharState(wfs_die, FALSE);
      end;
    FM_STRUCTED:
      begin
            //元神被攻击，主人掉血        改为，元神活力通过主人活力转换给元神
              {  if BasicData.Feature.rFeatureState = wfs_die then exit;
                if SenderInfo.MasterId = BasicData.id then
                begin
                    i := aSubData.HitData.damageBody;
                    i := (i - LifeData.armorBody);// div 2;

                    if i <= 0 then i := 1;
                    AttribClass.CurLife := AttribClass.CurLife - i;
                    if AttribClass.CurLife <= 0 then
                    begin
                        CommandChangeCharState(wfs_die, FALSE);
                    end;
                end;}
      end;
    FM_HIT:
      begin
        if SenderInfo.id = BasicData.id then exit;
        if BasicData.Feature.rfeaturestate = wfs_die then
        begin
          Result := PROC_TRUE;
          exit;
        end;
        if BasicData.boNotHit then exit;
                //自己 测试失败
        if isHitedArea(SenderInfo.dir, SenderInfo.x, SenderInfo.y, aSubData.HitData.HitFunction, percent) then
        begin

          if (TUser(Self).SysopScope = 101) or (BasicData.Feature.rHideState = hs_0) then
          begin

          end
          else if isFellowship(BasicData, SenderInfo) or isProcession(BasicData, SenderInfo) then
          begin
                        //                        SendClass.SendSay(BasicData, '同一团队');
          end else
          begin
            ret := CommandHited(SenderInfo, SenderInfo.id, aSubData.HitData, percent);
            if (ret <> 0) and (AttribClass.CurLife = 0) then
            begin //自己死亡
              hit_Kill;
              CommandChangeCharState(wfs_die, FALSE);

            end;
            if ret <> 0 then
            begin
              aSubData.HitData.boHited := TRUE;
              aSubData.HitData.HitedCount := aSubData.HitData.HitedCount + 1;
            end;
          end;
        end;
                {
                            xx := SenderInfo.x; yy := SenderInfo.y;
                            GetNextPosition (SenderInfo.dir, xx, yy);
                            if (BasicData.x = xx) and (BasicData.y = yy) then begin
                               ret := CommandHited (SenderInfo.id, aSubData.HitData);
                               if (ret <> 0) and (AttribClass.CurLife = 0) then CommandChangeCharState (wfs_die, FALSE);
                               if ret <> 0 then aSubData.HitData.boHited := TRUE;
                            end;
                }
      end;
    FM_BOW:
      begin
        if BasicData.Feature.rfeaturestate = wfs_die then
        begin
          Result := PROC_TRUE;
          exit;
        end;
        if BasicData.boNotHit then exit;
        if (aSubData.TargetId = Basicdata.id)
          or
          ((aSubData.HitData.HitFunction <> 0) and isHitedArea(SenderInfo.dir, aSubData.tx, aSubData.ty, aSubData.HitData.HitFunction, percent))
          then
        begin
          if aSubData.TargetId = Basicdata.id then percent := 100;
          if (TUser(Self).SysopScope = 101) or (BasicData.Feature.rHideState = hs_0) then
          begin
          end
          else if isFellowship(BasicData, SenderInfo) or isProcession(BasicData, SenderInfo) then
          begin
                        //                        SendClass.SendSay(BasicData, '同一团队');
          end else
          begin
            ret := CommandHited(SenderInfo, SenderInfo.id, aSubData.HitData, percent);
            if (ret <> 0) and (AttribClass.CurLife = 0) then
            begin
              hit_Kill;
              CommandChangeCharState(wfs_die, FALSE);
            end;
            if ret <> 0 then
            begin
              aSubData.HitData.HitedCount := aSubData.HitData.HitedCount + 1;
            end;
          end;
        end;
      end;
    FM_CHANGEFEATURE: //装备 改变 会触发 其他地方也会触发
      begin
        if SenderInfo.id = BasicData.id then
        begin
          if State <> wfs_care then SetTargetId(0);
          if State <> wfs_sitdown then HaveMagicClass.SetBreathngMagic(nil);
          if (State <> wfs_running) and (state <> wfs_running2) then HaveMagicClass.SetRunningMagic(nil);
        end;
        if Senderinfo.Feature.rfeaturestate = wfs_die then
        begin
          if Senderinfo.id = TargetId then SetTargetId(0);
        end;
      end;

    FM_CHANGEFEATURE_NameColor:
      begin
        SendClass.SendChangeFeature_NameColor(SenderInfo);
        Result := PROC_TRUE;
      end;
  end;
end;

procedure TUserObject.Update(CurTick: integer);
var
  n, ret: integer;
  key: word;
  Bo: TBasicObject;
  GotoXyRData: TGotoXyRData; // ract, rdir, rlen : word;

  x1, y1, x2, y2: word;
  aServerID: integer;
  nX, nY: Integer;
  SubData: TSubData;
begin
  inherited UpDate(CurTick);




    //地图 活力 改变
  if (BasicData.Feature.rfeaturestate <> wfs_die) and Manager.boChangeLife then
    if CurTick > ChangeLifeTick + Manager.ChangeDelay then
    begin
      ChangeLifeTick := CurTick;
      case Manager.Attribute of
            //1 ，百分比 扣活力； 2 ，无水，扣数量活力； 3 增加活力数量；
        1:
          begin
            if WearItemClass.GetWeaponAttribute <> 1 then
            begin
              n := AttribClass.MaxLife * Manager.ChangePercentage div 100;
              if n < 0 then n := 1;
              AttribClass.CurLife := AttribClass.CurLife - n;
              SendClass.SendLeftText('活力减少', WinRGB(22, 22, 0), mtLeftText);
            end;
          end;
        2:
          begin
            if HaveItemClass.IsDurability_Water = false then
            begin
              AttribClass.CurLife := AttribClass.CurLife - Manager.ChangeSize;
              SendClass.SendLeftText('活力减少', WinRGB(22, 22, 0), mtLeftText);
            end;
          end;
        3:
          begin
            AttribClass.CurLife := AttribClass.CurLife + Manager.ChangeSize;
          end;
      end;
      if AttribClass.CurLife <= 0 then
      begin
        BasicData.LifePercent := 0;
        AttribClass.CurLife := 0;
        CommandChangeCharState(wfs_die, FALSE);
        exit;
      end;
    end;

  if fCounterAttack_state and (CurTick > fCounterAttack_datetime) then fCounterAttack_state := false;
  LifeDataList.Update(curtick);
  if LifeDataList.rboupdate then
  begin
    LifeDataList.rboupdate := false;
    SetLifeData;
  end;

  AttribClass.Update(Curtick);
  DesignationClass.Update(CurTick);

  ret := HaveMagicClass.Update(CurTick);
  case ret of
    RET_CLOSE_NONE: ;
    RET_CLOSE_RUNNING:
      begin
        CommandChangeCharState(wfs_normal, FALSE);
        HaveMagicClass.SetRunningMagic(nil);
      end;
    RET_CLOSE_BREATHNG:
      begin
        CommandChangeCharState(wfs_normal, FALSE);
        HaveMagicClass.SetBreathngMagic(nil);
      end;
    RET_CLOSE_ATTACK:
      begin
      end;
    RET_CLOSE_PROTECTING:
      begin
        HaveMagicClass.SetProtectingMagic(nil);
      end;
  end;

  HaveItemClass.Update(CurTick);
  WearItemClass.Update(CurTick);

  if (BasicData.Feature.rFeatureState = wfs_die) and (CurTick > DiedTick + 3000) then
  begin
    ChangeLifeTick := mmAnsTick;
        //复活
    SendClass.SendReliveTime(0);
    if Manager.boPosDie = true then
    begin
      CommandChangeCharState(wfs_normal, FALSE);

            //TUser(Self).boNewServer := true;

      x1 := BasicData.x;
      y1 := BasicData.y;
      PosByDieClass.GetPosByDieData(Manager.ServerID, aServerID, x1, y1);
           // TUser(Self).SetPosition(x1, y1);
      TUser(Self).MoveToMap(aServerID, x1, y1, 0);
      exit;
    end;
    nX := BasicData.x;
    nY := BasicData.y;

    if Maper.isMoveable(nX, nY) = false then
    begin
      if Maper.GetNearXy(nX, nY) = false then
      begin
        frmMain.WriteLogInfo(format('TUserObject.Update() GetMoveableXY Error (%s, %d, %d, %d)', [Name, ServerID, nX, nY]));
        exit;
      end;
      CommandChangeCharState(wfs_normal, FALSE);
      TUser(Self).SetPosition(nX, nY);
    end else
    begin
      BasicData.X := nX;
      BasicData.Y := nY;
      CommandChangeCharState(wfs_normal, FALSE);
      Maper.MapProc(BasicData.Id, MM_SHOW, BasicData.x, BasicData.y, BasicData.x, BasicData.y, BasicData);
    end;
    exit;
        {
        if Maper.isMoveable (nX, nY) then begin
           Maper.MapProc (BasicData.Id, MM_SHOW, BasicData.x, BasicData.y, BasicData.x, BasicData.y);
           CommandChangeCharState (wfs_normal, FALSE);
        end else begin
           if Maper.GetNearXy (nX, nY) then begin
              CommandChangeCharState (wfs_normal, FALSE);
              Phone.SendMessage (NOTARGETPHONE, FM_DESTROY, BasicData, SubData);
              Phone.UnRegisterUser (BasicData.id, BasicData.x, BasicData.y);
              BasicData.x := nX; BasicData.y := nY;
              SendClass.SendMap (BasicData, Manager.MapName, Manager.ObjName, Manager.RofName, Manager.TilName, Manager.SoundBase);
              Phone.RegisterUser (BasicData.id, FieldProc, BasicData.X, BasicData.Y);
              Phone.SendMessage (NOTARGETPHONE, FM_CREATE, BasicData, SubData);
           end;
        end;
        }
  end;

  if (BasicData.Feature.rFeatureState = wfs_die) and (CurTick < DiedTick + 3000) then
  begin
        // 拖尸体
    if (RopeTarget <> 0) and (RopeTick + 500 > CurTick) then
    begin
      bo := TBasicObject(GetViewObjectById(RopeTarget));
      if bo = nil then exit;
      x1 := BasicData.x;
      y1 := BasicData.y;
      x2 := bo.Posx;
      y2 := bo.Posy;

      if AI0GotoXy(GotoXyRData, BasicData.dir, x1, y1, x2, y2, RopeOldX, RopeOldY, Maper.isMoveable) then
      begin

        case GotoXyRData.ract of
          AI_CLEAROLDPOS:
            begin
              RopeOldX := 0;
              RopeOldY := 0;
            end;
          AI_TURN:
            begin
              BasicData.dir := GotoXyRData.rdir;
              SendLocalMessage(NOTARGETPHONE, FM_TURN, BasicData, SubData);
              SendClass.SendTurn(BasicData);
            end;
          AI_MOVE:
            begin
              x1 := BasicData.x;
              y1 := BasicData.y;
              GetNextPosition(GotoXyRData.rdir, x1, y1);
              if Maper.isMoveable(x1, y1) then
              begin
                RopeOldX := BasicData.x;
                RopeOldy := BasicData.y;
                BasicData.dir := GotoXyRData.rdir;
                BasicData.nx := x1;
                BasicData.ny := y1;
                Phone.SendMessage(NOTARGETPHONE, FM_MOVE, BasicData, SubData);

                SendClass.SendMove(BasicData); // 郴啊 杭荐 乐澜.

                Maper.MapProc(BasicData.Id, MM_MOVE, BasicData.x, BasicData.y, x1, y1, BasicData);
                BasicData.x := x1;
                BasicData.y := y1;
              end;
            end;
        end;
      end;
    end;
  end;

  case LifeObjectState of
    los_none:
      begin
{                if boShiftAttack = FALSE then
                begin
                    boShiftAttack := TRUE;
                    SendClass.SendShiftAttack(boShiftAttack);
                end;
                }
      end;
    los_die:
      begin
{                if boShiftAttack = FALSE then
                begin
                    boShiftAttack := TRUE;
                    SendClass.SendShiftAttack(boShiftAttack);
                end;
                }
      end;
    los_attack:
      begin //攻击 控制
                //增加 1个时间  控制
        bo := TBasicObject(GetViewObjectById(TargetId));
        if bo = nil then
        begin

          SetTargetId(0);
        end
        else
        begin
                    //新 团队

          if isFellowship(bo.BasicData, BasicData)
            or isProcession(bo.BasicData, BasicData) then
          begin
            SetTargetId(0);
                        //SendClass.SendSay(BasicData, '同一团队；结束攻击');
            if BasicData.Feature.rfeaturestate = wfs_normal then
            else CommandChangeCharState(wfs_normal, FALSE);
            exit;
          end;
                    //新 团队
          if bo.BasicData.Feature.rrace = RACE_MineObject then
          begin //挖矿
                      //  if GetLargeLength(BasicData.X, BasicData.Y, bo.PosX, bo.PosY) = 1 then
            if isHit(bo.BasicData) then
            begin
              key := GetNextDirection(BasicData.X, BasicData.Y, bo.PosX, bo.PosY);
              if key = DR_DONTMOVE then exit;
              CommandDredgeHit(CurTick, TRUE, key);
            end;
          end else
          begin

            if HaveMagicClass.pCurAttackMagic = nil then exit;
            case HaveMagicClass.pCurAttackMagic^.rMagicType of
              MAGICTYPE_BOWING, MAGICTYPE_THROWING
                , MAGICTYPE_2BOWING, MAGICTYPE_2THROWING:
                begin
                                    {if boShiftAttack = FALSE then
                                    begin
                                        boShiftAttack := TRUE;
                                        SendClass.SendShiftAttack(boShiftAttack);
                                    end;
                                    }
                  CommandBowing(CurTick, TargetId, bo.Posx, bo.Posy, TRUE);
                end;
            else
              begin


                          //  if GetLargeLength(BasicData.X, BasicData.Y, bo.BasicData.X, bo.BasicData.Y) = 1 then
                if isHit(bo.BasicData) then
                begin
                  key := GetNextDirection(BasicData.X, BasicData.Y, bo.BasicData.X, bo.BasicData.Y);
                  if key <> DR_DONTMOVE then
                  begin

//                                if key <> BasicData.dir then CommandTurn(key, TRUE);
                    if CommandHit(CurTick, TRUE, key) then
                    begin
                                            {if boShiftAttack = TRUE then
                                            begin
                                                boShiftAttack := FALSE;
                                                SendClass.SendShiftAttack(boShiftAttack);
                                            end;
                                            }
                    end;
                  end;
                end else
                begin
                                    {if boShiftAttack = FALSE then
                                    begin
                                        boShiftAttack := TRUE;
                                        SendClass.SendShiftAttack(boShiftAttack);
                                    end;
                                    }
                end;
              end;
            end;
          end;
        end;
      end;
  end;

  if AttribClass.ReQuestPlaySoundNumber <> 0 then
  begin
        // SetWordString(SubData.SayString, IntToStr(AttribClass.RequestPlaySoundNumber) + '.wav');
    SubData.sound := AttribClass.RequestPlaySoundNumber;
    SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
    AttribClass.ReQuestPlaySoundNumber := 0;
  end;
  if HaveMagicClass.ReQuestPlaySoundNumber <> 0 then
  begin
        //SetWordString(SubData.SayString, IntToStr(HaveMagicClass.RequestPlaySoundNumber) + '.wav');
    SubData.sound := HaveMagicClass.RequestPlaySoundNumber;
    SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
    HaveMagicClass.ReQuestPlaySoundNumber := 0;
  end;
  if HaveItemClass.ReQuestPlaySoundNumber <> 0 then
  begin
        // SetWordString(SubData.SayString, IntToStr(HaveItemClass.RequestPlaySoundNumber) + '.wav');
    SubData.sound := HaveItemClass.RequestPlaySoundNumber;
    SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
    HaveItemClass.ReQuestPlaySoundNumber := 0;
  end;
  if WearItemClass.ReQuestPlaySoundNumber <> 0 then
  begin
        // SetWordString(SubData.SayString, IntToStr(WearItemClass.RequestPlaySoundNumber) + '.wav');
    SubData.sound := WearItemClass.RequestPlaySoundNumber;
    SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
    WearItemClass.ReQuestPlaySoundNumber := 0;
  end;
  if bosendLifeData then
  begin
    SendClass.SendLifeData(LifeData);
    bosendLifeData := false;
  end;
end;

procedure TUserObject.Initial(aName: string);

begin
  inherited Initial(aName, aName);
  BasicData.Feature.rnation := 1;
  Name := aName;
  IP := Connector.IpAddr;

  SendClass.SetName(Name);
  SendClass.SetConnector(Connector);

  AttribClass.LoadFromSdb(@Connector.CharData);
  HaveMagicClass.LoadFromSdb(@Connector.CharData);
  HaveItemClass.LoadFromSdb(@Connector.CharData);
  HaveItemQuestClass.LoadFromSdb(@Connector.CharData);
  WearItemClass.LoadFromSdb(@Connector.CharData);
  DesignationClass.LoadFromSdb(@Connector.CharData);


  fcounterattack_state := false;
  SetScript('GameSys', format('.\%s\%s.pas', ['Script', 'GameSys']));
end;

function TUserObject.getAttackMagic(): TMagicData;
begin
  if HaveMagicClass.pCurAttackMagic = nil then
  begin
    fillchar(Result, sizeof(TMagicData), 0);
    exit;
  end;
  Result := HaveMagicClass.pCurAttackMagic^;
end;

function TUserObject.FindHaveMagicByName(aMagicName: string): Integer;
begin
  Result := HaveMagicClass.GetMagicSkillLevel(aMagicName);
end;

function TUserObject.DelKeyItem(akey, acount: integer; aItemData: PTItemData): Boolean;
begin
  result := HaveItemClass.DeletekeyItem(akey, acount);
  if result then
    logItemMoveInfo('背包删除', @BasicData, nil, aItemData^, Manager.ServerId);
end;

function TUserObject.DeleteItem(aItemData: PTItemData): Boolean;
begin
  Result := HaveItemClass.DeleteItem(aItemData);
  if result then
    logItemMoveInfo('背包删除', @BasicData, nil, aItemData^, Manager.ServerId);
end;

procedure TUserObject.affair(atype: THaveItemClassAffair);
begin
  HaveItemClass.affair(atype);
end;

function TUserObject.GetWearItemName(akey: integer): string;
begin
  result := WearItemClass.GetWearItemName(akey);
end;

function TUserObject.AddMagicExp(aname: string; aexp: integer): integer;
begin
  result := HaveMagicClass.AddMagicExp(aname, aexp);
end;

function TUserObject.getMagicExp(aname: string): integer;
var
  p: PTMagicData;
begin
  result := 0;
  p := HaveMagicClass.All_FindName(aname);
  if p = nil then exit;
  result := p.rSkillExp;
end;

function TUserObject.LockedPass: boolean;
begin
  result := HaveItemClass.LockedPass;
end;

function TUserObject.getMagicLevel(aname: string): integer;
var
  p: PTMagicData;
begin
  result := 0;
  p := HaveMagicClass.All_FindName(aname);
  if p = nil then exit;
  result := p.rcSkillLevel;
end;

function TUserObject.getuserMagic: string;
begin
  result := HaveMagicClass.getuserMagic;
end;

function TUserObject.GetWeaponGuild: boolean;
begin
  result := WearItemClass.GetWeaponGuild;
end;

function TUserObject.isProcession(aBasicData1, aBasicData2: TBasicData): boolean; //测试 队伍相同
var
  t1, t2: TUserObject;
  rfellowship1, rfellowship2: integer;
begin
  Result := false;

  if not isUserId(aBasicData1.id) then exit;
  if not isUserId(aBasicData2.id) then exit;

  t1 := aBasicData1.p;
  t2 := aBasicData2.p;
  if t1 = nil then exit;
  if t2 = nil then exit;
  if (t1.uProcessionclass <> nil) and (t2.uProcessionclass <> nil) then
    if t1.uProcessionclass = t2.uProcessionclass then
    begin
      Result := true;
      exit;
    end;
end;

function TUserObject.isFellowship(aBasicData1, aBasicData2: TBasicData): boolean;
var
  t1, t2: TUserObject;
  rfellowship1, rfellowship2: integer;
begin
  Result := false;

  if not isUserId(aBasicData1.id) then exit;
  if not isUserId(aBasicData2.id) then exit;

  t1 := aBasicData1.p;
  t2 := aBasicData2.p;
  if t1 = nil then exit;
  if t2 = nil then exit;
  rfellowship1 := t1.WearItemClass.GETfellowship;
  rfellowship2 := t2.WearItemClass.GETfellowship;

    {rfellowship1 := aBasicData1.Feature.rfellowship;
    rfellowship2 := aBasicData2.Feature.rfellowship;
    }
  if (rfellowship1 >= 100) and (rfellowship1 <= 9999)
    and (rfellowship2 >= 100) and (rfellowship2 <= 9999) then
    if rfellowship2 = rfellowship1 then
    begin
      Result := true;
      exit;
    end;
end;

function TUserObject.FindNameItem(aname: string): integer;
begin
  Result := HaveItemClass.FindNameItem(aname);
end;

function TUserObject.FindItem(aItemData: PTItemData): Boolean;
begin
  Result := HaveItemClass.FindItem(aItemData);
end;

function TUserObject.Add_GOLD_Money(acount: integer): Boolean;
begin
  Result := HaveItemClass.Add_GOLD_Money(acount);
end;

function TUserObject.DEL_GOLD_Money(acount: integer): Boolean;
begin
  Result := HaveItemClass.DEL_GOLD_Money(acount);
end;

function TUserObject.GET_GOLD_Money(): INTEGER;
begin
  Result := HaveItemClass.GOLD_Money;
end;

function TUserObject.ViewItem(akey: integer; aItemData: PTItemData): Boolean;
begin
  Result := HaveItemClass.ViewItem(akey, aItemData);
end;

function TUserObject.ViewItemName(aname: string; aItemData: PTItemData): Boolean;
begin
  Result := HaveItemClass.ViewItemName(aname, aItemData);
end;

function TUserObject.AddItem(aItemData: PTItemData): Boolean;
begin
  Result := HaveItemClass.addItem(aItemData);
  if result then
    logItemMoveInfo('背包增加', nil, @BasicData, aItemData^, Manager.ServerId);
end;

function TUserObject.AddMagic(aMagicData: PTMagicData): Boolean;
begin
  Result := HaveMagicClass.AddMagic(aMagicData);
end;

////////////////////////////////////////////////////
//
//             ===  User  ===
//
////////////////////////////////////////////////////

constructor TUser.Create;
begin
  inherited Create;
  boNewServerDelayTick := 0;
  boNewServerTick := 0;

  FMonsterList := tlist.Create;
  MonsterUPdateTick := 0;

  RefuseReceiver := TStringList.Create;
  MailSender := TStringList.Create;

  MacroChecker := TMacroChecker.Create(6);

  boException := false;
  boDeleteState := false;

  SysopObj := nil;
  UserObj := nil;
  uProcessionclass := nil;

  boCanSay := true;
  FboCanMove := true;
  boCanAttack := true;
  FboNewEmail := false;
  ItemLog := TItemLog.Create(SendClass);
  MenuSayText := '';
  ADDMsgList := TResponsion.Create; //加人  等待 应答 列表

  ExChange := TExChange.Create;
  Boothclass := nil;

end;
/////////////////////////////////////////////
//  fillchar(pMonsterArr, sizeof(pMonsterArr), 0);
//1，创建
//2，UPDATE
//3，释放

function TUser.MonsterUserMaxLife: integer;
begin
  if SysopScope > 99 then result := 10000
  else
    result := AttribClass.MaxLife;

end;

function TUser.MonsterCheck(): boolean;
begin
  result := FMonsterList.Count > 0;
end;


procedure TUser.MonsterUPdate(CurTick: integer);
var
  i: integer;
  Monster: TMonster;
  boSetTargetId, boSetCall: boolean;
begin
  if FMonsterList.Count <= 0 then exit;
  boSetTargetId := false;
  if TargetId <> 0 then boSetTargetId := isMonsterId(TargetId);
  boSetCall := false;
  if MonsterUPdateTick + 300 < CurTick then
  begin
    MonsterUPdateTick := CurTick;
    boSetCall := true;
  end;

  for i := FMonsterList.Count - 1 downto 0 do
  begin
    Monster := FMonsterList.Items[i];
    if Monster.boAllowDelete then
    begin
      MonsterDel(Monster);
      exit;
    end else
    begin
      Monster.Update(CurTick);
      if boSetTargetId then Monster.SetAttackObj(TargetId);
      if boSetCall then
      begin
        if isRange(Monster.BasicData.x, Monster.BasicData.y) = false then
        begin
          Monster.CallMeServerId(ServerID, BasicData.x, BasicData.y);
        end;
      end;
    end;
  end;

end;

procedure TUser.MonsterDel(aMop: pointer);
var
  i: integer;
  Monster: TMonster;
begin
  for i := 0 to FMonsterList.Count - 1 do
  begin
    Monster := FMonsterList.Items[i];
    if Monster = aMop then
    begin
      Monster.pUSER := nil;
      Monster.EndProcess;
      Monster.Free;
      FMonsterList.Delete(i);
      exit;
    end;
  end;

end;


procedure TUser.MonsterAdd(aMonsterName: string);
var
  temp: PTMonsterData;
  Monster: TMonster;
begin
  if isGm = false then
  begin
    if FMonsterList.Count > 0 then
    begin
      SendClass.SendChatMessage('元神已经释放。', SAY_COLOR_SYSTEM);
      exit;
    end;
  end else
  begin

  end;

  if MonsterClass.GetMonsterData(aMonsterName, temp) = false then
  begin
    SendClass.SendChatMessage('错误！元神资料不存在。', SAY_COLOR_SYSTEM);
    exit;
  end;

  Monster := TMonster.Create;
  if Monster <> nil then
  begin
    Monster.pUSER := self;
    Monster.SetManagerClass(Manager);
    Monster.Initial(aMonsterName, BasicData.nx, BasicData.ny, 6, BasicData.Feature.rnation, 0, _htt_All);
       //UPDATE 中复活
    FMonsterList.Add(Monster);
  end;
  if FMonsterList.Count > 0 then
    SendClass.SendChatMessage('元神已经释放:' + inttostr(FMonsterList.Count), SAY_COLOR_SYSTEM);
end;

function TUser.MonsterAddLife(aLife: integer): boolean;
var
  i: integer;
  Monster: TMonster;
begin
  result := false;

  for i := 0 to FMonsterList.Count - 1 do
  begin
    Monster := FMonsterList.Items[i];
    if Monster.AddLife(aLife) then
    begin
      result := true;
      if SysopScope > 99 then Continue;
      exit;
    end;
  end;

end;

procedure TUser.MonsterClear();
var
  i: integer;
  Monster: TMonster;
begin
  for i := 0 to FMonsterList.Count - 1 do
  begin

    Monster := FMonsterList.Items[i];
    Monster.pUSER := nil;
    Monster.EndProcess;
    Monster.Free;
  end;
  FMonsterList.Clear;
end;

destructor TUser.Destroy;
var
  i: Integer;
begin

  MonsterClear;

  ADDMsgList.Free;
  RefuseReceiver.Free;
  MailSender.Free;

  MacroChecker.Free;
  ItemLog.Free;
  ExChange.Free;
  FMonsterList.Free;
  inherited destroy;
end;

procedure TUser.ClearDElMagic();
begin
  Connector.CharData.DelMagicCount := 0;
  Connector.CharData.DelMagicTime := 0;
end;

procedure TUser.LoadUserData(aName: string);
var
  flag: Boolean;
  i, xx, yy: integer;
begin
  Basicdata.Name := aName;

  FCompleteQuestNo := Connector.CharData.CompleteQuestNo; //新 任务 完成ID
  FCurrentQuestNo := Connector.CharData.CurrentQuestNo; //新 任务 当前ID
  FQueststep := Connector.CharData.Queststep; //新 任务 步骤ID

  FSubCurrentQuestNo := Connector.CharData.SubCurrentQuestNo; //新 分支任务 当前ID
  FSubQueststep := Connector.CharData.SubQueststep; //新 分支任务 步骤ID
  ServerID := Connector.CharData.ServerId;
  xx := Connector.CharData.X;
  yy := Connector.CharData.Y;

  if Maper.IsMoveable(xx, yy) = false then Maper.GetMoveableXy(xx, yy, 10);

  if Maper.IsMoveable(xx, yy) = false then
  begin
    xx := Maper.Width div 2;
    yy := Maper.Height div 2;
    Maper.GetMoveableXy(xx, yy, 10);
  end;

  BasicData.x := xx;
  BasicData.y := yy;
  BasicData.dir := DR_4;
  GuildName := (Connector.CharData.Guild);
  GuildGrade := '';

  Connector.CharData.LastDate := (Date);
  boNewServer := FALSE;

end;
//双倍经验控制

procedure TUser.MagicExpMulUpdate(CurTick: integer);
begin

  if Connector.CharData.MagicExpMulCount > 0 then
  begin
    if now() > Connector.CharData.MagicExpMulEndTime then
    begin

      MagicExpMulDel;
    end else
    begin
      if CurTick > MagicExpMulUpdateTick + 6000 then
      begin
        MagicExpMulUpdateTick := CurTick;
        SendClass.SendLeftText('经验翻倍剩余：' + inttostr(MagicExpMulGetCurMulMinutes) + ' 分钟', 992, mtLeftText2);
      end;
    end;
  end;
end;
//当前翻倍时间

function TUser.MagicExpMulGetCurMulMinutes(): integer;
begin
  result := 0;
  if Connector.CharData.MagicExpMulCount > 0 then
  begin

    if now() < Connector.CharData.MagicExpMulEndTime then
    begin
      result := MinutesBetween(now(), Connector.CharData.MagicExpMulEndTime);
    end;
  end;
end;
//结束

procedure TUser.MagicExpMulDel();
begin
  MagicExpMulUpdateTick := 0;
  Connector.CharData.MagicExpMulCount := 0;
  Connector.CharData.MagicExpMulEndTime := now();
  HaveMagicClass.MagicExpMulCount := 0;
  SendClass.SendChatMessage('武功翻倍经验 时间到期', SAY_COLOR_SYSTEM);

end;
//剩余几天


function TUser.MagicExpMulGetDay(): integer;
var
  week1, temp1: tdatetime;
begin
  result := 0;
    //获得领取日期
  temp1 := DateOf(Connector.CharData.MagicExpUseTime);
    //已经领取到今天，不能再领取
  if temp1 >= date then
  begin

    exit;
  end;

    //推算星期1。
  week1 := StartOfTheWeek(now());
  if temp1 < week1 then
  begin
       //本周，未领过
    result := DayOfTheWeek(NOW);
  end else
  begin
    //本周已经另过
    result := DaysBetween(Connector.CharData.MagicExpUseTime, now);
  end;


end;
//领取

procedure TUser.MagicExpMulAdd(aMulCount, aHour: integer);
var
  week1, temp1: tdatetime;
  i: integer;
begin
    //获得领取日期
  temp1 := DateOf(Connector.CharData.MagicExpUseTime);
    //已经领取到今天，不能再领取
  if temp1 >= date then
  begin
    SendClass.SendChatMessage('你已经没有〖翻倍经验〗可领取。', SAY_COLOR_SYSTEM);
    exit;
  end;

    //推算星期1。
  week1 := StartOfTheWeek(now());
  if temp1 < week1 then
  begin
       //从星期1开始领
    Connector.CharData.MagicExpUseTime := DateOf(week1);
  end else
  begin
    //上次时间，增加1天
    Connector.CharData.MagicExpUseTime := IncDay(Connector.CharData.MagicExpUseTime, 1);
  end;

    //正式开始领
  Connector.CharData.MagicExpMulCount := aMulCount;
    //当前是否还有翻倍经验
  if Connector.CharData.MagicExpMulEndTime < now() then
    Connector.CharData.MagicExpMulEndTime := now();
    //当前时间，增加2小时
  Connector.CharData.MagicExpMulEndTime := IncHour(Connector.CharData.MagicExpMulEndTime, aHour);
  HaveMagicClass.MagicExpMulCount := aMulCount;
  i := MagicExpMulGetCurMulMinutes;
  SendClass.SendChatMessage(
    format('武功翻倍经验状态：%d 倍经验 剩余时间：%d 分钟 ', [aMulCount, i])
    , SAY_COLOR_SYSTEM);
  MagicExpMulUpdateTick := 0;

end;

procedure TUser.SaveUserData(aName: string);
begin
    //任务ID
  Connector.CharData.CompleteQuestNo := FCompleteQuestNo; //新 任务 完成ID
  Connector.CharData.CurrentQuestNo := FCurrentQuestNo; //新 任务 当前ID
  Connector.CharData.Queststep := FQueststep; //新 任务 步骤ID

  Connector.CharData.SubCurrentQuestNo := FSubCurrentQuestNo; //新 分支任务 当前ID
  Connector.CharData.SubQueststep := FSubQueststep; //新 分支任务 步骤ID

  Connector.CharData.ServerID := ServerID;
  Connector.CharData.Guild := GuildName;

  Connector.CharData.X := BasicData.x;
  Connector.CharData.Y := BasicData.Y;
    {   if (not boNewServer) and (Connector.BattleState = bcs_none) then
       begin
           Connector.CharData.X := BasicData.x;
           Connector.CharData.Y := BasicData.Y;
       end else
       begin
           Connector.CharData.X := PosMoveX;
           Connector.CharData.Y := PosMoveY;
       end;
       }
end;

function TUser.InitialLayer(aCharName: string): Boolean;
begin
  Result := false;

  PrisonTick := mmAnsTick;
  SaveTick := mmAnsTick;
  FalseTick := 0;
  MailTick := mmAnsTick - 10 * 100;
  Name := aCharName;

  Result := true;
end;

procedure TUser.Initial(aName: string);
begin
  inherited Initial(aName);

  InputStringState := InputStringState_None;

  boTV := false;
  boException := false;
  boLetterCheck := true;

  boCanSay := true;
  FboCanMove := true;
  boCanAttack := true;

  UseSkillKind := -1;
  SkillUsedTick := 0;
  SkillUsedMaxTick := 0;

  LoadUserData(aName);
  FillChar(CM_MessageTick, sizeof(CM_MessageTick), 0);

  SysopScope := Sysopclass.GetSysopScope(aName);

  if SysopScope >= 100 then SysopScope := 101;

  SpecialWindow := 0;
    // CopyHaveItem := nil;

  NetState_ClientId := 0;
  NetStateID := 0;
  NetStateTick := 0;
  MOVE_Client_OldTick := 0;
  NetState_speed_close := false;
//    FillChar(SaveNetState, SizeOf(TCNetState), 0);

    //  FillChar(ItemLog.FLogData, SizeOf(TItemLogRecord) * 4, 0);
//    FillChar(ItemLog.FLogData, SizeOf(TItemLogRecord), 0);

  BasicData.BasicObjectType := botUser;
end;

procedure TUser.GuildSet(aGuild: pointer);
begin
  if aGuild = nil then
  begin
    SendClass.SendNUMSAY(numsay_ExitGuild, SAY_COLOR_NORMAL); //   '你已经脱离门派了。',      //2  numsay_ExitGuild

    GuildDel;
    exit;
  end;

  if not tGuildObject(aGuild).IsGuildUser(Name) then
  begin
    SendClass.SendNUMSAY(numsay_ExitGuild, SAY_COLOR_NORMAL); //   '你已经脱离门派了。',      //2  numsay_ExitGuild
    GuildDel;

    exit;
  end;
  uGuildObject := aGuild;
  GuildName := tGuildObject(uGuildObject).GuildName;
  GuildServerID := tGuildObject(uGuildObject).GetGuildServerID();
  BasicData.Guild := GuildName;
  GuildGrade := tGuildObject(uGuildObject).GetUserGrade(Name); //获取 封号

end;

procedure TUser.GuildDel();
begin
  uGuildObject := nil;
  GuildName := '';
  GuildGrade := '';
  BasicData.Guild := '';

end;

procedure TUser.MarrySet(sname: string);
begin
  ConsortName := sname;
  BasicData.ConsortName := ConsortName;
end;

procedure TUser.Marrydel();
begin
  ConsortName := '';
  BasicData.ConsortName := '';
end;

procedure TUser.StartProcess;
var
  SubData: TSubData;
  tmpGuildName: string;
  tmpManager: TManager;
  rStr: string;
    // timestr, msgstr : String;
begin
  PosMoveX := -1;
  PosMoveY := -1;

  inherited StartProcess;
  boTv := FALSE;

  Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
  Phone.SendMessage(NOTARGETPHONE, FM_CREATE, BasicData, SubData);

    //邮件
  aEmail := EmailList.getname(name);
  if aEmail = nil then
  begin
    EmailList.createEmailclass(name);
    aEmail := EmailList.getname(name);
  end;
  if aEmail <> nil then
    TEmailclass(aEmail).SETONLINE(self);
    //门派
  if GuildName <> '' then GuildSet(GuildList.GetGuildNname(GuildName));
  if uGuildObject <> nil then tGuildObject(uGuildObject).SETonLine(self);
    //任务 列表
  QuestMainList.userGetQuestList(self);
  //20091126取消,任务使用任务物品全部取缔临时变量  SendClass.SendQuestTempArrAll;                                              //临时 列表
  if BasicData.Feature.rboman then
    rstr := '男'
  else rstr := '女';

  if SysopScope < 99 then
  begin
    BillboardchartsEnergy.add(name, AttribClass.getcEnergy, AttribClass.prestige, rstr);
    BillboardchartsPrestige.add(name, AttribClass.getcEnergy, AttribClass.prestige, rstr);
  end else
  begin
    BillboardchartsEnergy.del(name);
    BillboardchartsPrestige.del(name);
  end;
    //配偶
  rstr := marriedlist.GetConsortName(name);
  if rstr <> '' then
  begin
    MarrySet(rstr);
        //夫妻 通知上线
    marriedlist.setOnLine(self);
  end
  else Marrydel;
    //名字改变
  BocChangeProperty;

  if Manager.boPrison = true then
  begin
    rStr := PrisonClass.GetUserStatus(Name);
    if rStr <> '' then
    begin
      SendClass.SendNUMSAY(numsay_captivity, SAY_COLOR_NORMAL); //  '被囚禁于流配地。',        //3  numsay_captivity
      SendClass.SendNUMSAY(numsay_captivityGET, SAY_COLOR_NORMAL); // '可用 @囚禁情报 指令来查询囚禁时间。', //4 numsay_captivityGET
      SendClass.SendChatMessage(rStr, SAY_COLOR_NORMAL);
    end;
  end;

  RefuseReceiver.Clear;
  MailSender.Clear;
    //主动 发送 热键
  SendClass.SendKEYf5f12;

  ahailfellow := HailFellowList.GetName(name);
  if ahailfellow <> nil then
    thailfellow(ahailfellow).SETUPLine(self);

    //商场
  EmporiaClass.GetItemList(self);
    //境界
  PowerLevelMax;
    //系统脚本
  CallScriptFunction('OnCharOnline', [integer(self)]);
    //   rStr := '救崇窍技夸. 玫斥涝聪促.' + #13;
    //   rStr := rStr + '捞锅 滚傈狼 函版荤亲俊 包茄 傍瘤涝聪促' + #13;
    //   rStr := rStr + '' + #13;
    //   rStr := rStr + ' 1. 努腐,歹喉努腐栏肺 酒捞袍 裙垫捞 啊瓷钦聪促' + #13;
    //   rStr := rStr + ' 2. 公傍函版矫 秦寸公扁啊 磊悼栏肺 馒侩邓聪促' + #13;
    //   rStr := rStr + '' + #13;
    //   rStr := rStr + '歹 磊技茄 郴侩篮 权其捞瘤甫 曼绊窍技夸' + #13;
    //   rStr := rStr + '坷疵 窍风档 榴玫窍技夸' + #13;

    //   SendClass.SendShowSpecialWindow (WINDOW_ALERT, '玫斥 傍瘤荤亲', rStr);
end;

procedure TUser.EndProcess;
var
  i: Integer;
  BasicObject: TBasicObject;
  SubData: TSubData;
begin

  if FboRegisted = FALSE then exit;

  if boTV = true then
  begin
    MirrorList.DelViewer(Self);
    boTV := false;
  end;

  if (GuildName <> '') and (uGuildObject <> nil) then
  begin
    tGuildObject(uGuildObject).SETGameExit(self);
        //  UserList.GuildSay(GuildName, format('%s(%s)退出', [Name, GuildGrade]));
  end;
  if aEmail <> nil then
    TEmailclass(aEmail).setGameExit;
    //队伍 下线  通知
  if uProcessionclass <> nil then TProcessionclass(uProcessionclass).setGameExit(SELF);
    //夫妻 通知 下线
  if ConsortName <> '' then marriedlist.setGameExit(self);
    //交易
  if ExChange.isstate then ExChangeClose;

  CallScriptFunction('OnCharExitGame', [integer(self)]);
  Phone.SendMessage(NOTARGETPHONE, FM_DESTROY, BasicData, SubData);
  Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);
  if ahailfellow <> nil then
    thailfellow(ahailfellow).setDownLine;
  HaveItemClass.OnGameExit;
  SaveUserData(Name);


  inherited EndProcess;

end;

function TUser.SETfellowship(id: integer): string;
var
  SubData: TSubData;
  Acolor: word;
  i: integer;
begin
  result := '';
  if (id < 100) or (id > 9999) then
  begin
    result := '设定值的范围是100-9999';
    exit;
  end else
  begin

    if WearItemClass.SETfellowship(id) then
    begin
      WearItemClass.UPFeature;
      if SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE_NameColor, BasicData, SubData) = PROC_TRUE then
      begin
                // result := '团队设置成功';
      end
      else
      begin
                //  result := '团队设置失败';
      end;
    end;
  end;
end;

procedure TUser.FinalLayer;
begin
  if UserObj <> nil then
  begin
    TUser(UserObj).SysopObj := nil;
    UserObj := nil;
  end;
  if SysopObj <> nil then
  begin
    TUser(SysopObj).SendClass.SendNUMSAY(numsay_gameExit, SAY_COLOR_SYSTEM); //   '解除连线',                //5  numsay_gameExit
    TUser(SysopObj).UserObj := nil;
    SysopObj := nil;
  end;

    { if CopyHaveItem <> nil then
     begin
         CopyHaveItem.Free;
         CopyHaveItem := nil;
     end;}
end;

function TUserList.GetGuildUserInfo(aGuildName: string): string;
var
  i, n: integer;
  str: string;
  TempUser: TUser;
begin
  str := '';
  n := 0;
  for i := 0 to DataList.Count - 1 do
  begin
    TempUser := DataList.Items[i];
    if TempUser.GuildName <> aGuildName then continue;
    str := str + TempUser.Name + '  ';
    if (n <> 0) and (n mod 8 = 0) then str := str + #13;
    n := n + 1;
  end;
  Result := '现在使用者:' + IntToStr(n) + #13 + str;
end;

procedure TUser.GM_ADDMONEY(aname: string; acount: integer);
var
  uUser: tuser;
begin
  if (SysopScope <= 99) and (SysopScope <> 20) then
  begin
    SendClass.SendChatMessage('超出权利范围', SAY_COLOR_SYSTEM);
    exit;
  end;
  if (acount <= 0) or (acount > 10000) then
  begin
    SendClass.SendChatMessage('【元宝】数量超出范围', SAY_COLOR_SYSTEM);
    exit;
  end;
  uUser := UserList.GetUserPointer(aname);
  if uuser = nil then
  begin
    SendClass.SendChatMessage(aname + '不在线', SAY_COLOR_SYSTEM);
    exit;
  end;
  if uuser.HaveItemClass.Add_GOLD_Money(acount) = false then
  begin
    SendClass.SendChatMessage(format('发放给 %s 【元宝】 %d，操作失败！', [aname, acount]), SAY_COLOR_SYSTEM);
    exit;
  end;
    //需要纪录  发放【元宝】
  tmlog.add(format('addmoney:%s,%s,%d', [name, aname, acount]));
  SendClass.SendChatMessage(format('成功发放给 %s 【元宝】 %d', [aname, acount]), SAY_COLOR_SYSTEM);
end;

procedure TUser.UserSay(astr: string);
var
  i, j, k, xx, yy, ret, n, scolor: integer;
  nByte: Byte;
  TempUser: TUser;
  Bo: TBasicObject;
  tempdir: word;
  templength: integer;
  ItemData: TItemData;
  RetStr, Str, searchstr, msgstr, timestr: string;
  strs: array[0..15] of string;
  tmpBasicData: TBasicData;
  SubData: TSubData;
  tmpManager: TManager;
  GuildMagicWindow: TSShowGuildMagicWindow;
  GuildObject: TGuildObject;
  LimitStr: string;
begin
  if astr = '' then exit;

  LimitStr := Copy(aStr, 1, 255);
  aStr := LimitStr;

  str := astr;
  for i := 0 to 15 do
  begin
    str := GetValidStr3(str, strs[i], ' ');
    if str = '' then break;
  end;

  case astr[1] of
    '/':
      begin

        if Strs[0] = INI_WHO then
        begin
          if SysopScope > 99 then
          begin
            SetWordString(SubData.SayString, aStr);
            Phone.SendMessage(MANAGERPHONE, FM_CURRENTUSER, BasicData, SubData);
            SendClass.SendChatMessage(GetWordString(SubData.SayString), SAY_COLOR_SYSTEM);
          end;
          if GuildName <> '' then
          begin
            GuildList.GetGuildInfo(GuildName, Self);
            str := UserList.GetGuildUserInfo(GuildName);
            SendClass.SendChatMessage(str, SAY_COLOR_NORMAL);
          end;

        end
        else
          if (UpperCase(strs[0]) = '/WHERE') or (UpperCase(strs[0]) = '/哪里') then
          begin
            nByte := Maper.GetAreaIndex(BasicData.X, BasicData.Y);
            if nByte > 0 then
            begin
              searchstr := AreaClass.GetAreaName(nByte);
              if searchstr = '' then searchstr := Manager.Title;
            end else
            begin
              searchstr := Manager.Title;
            end;
            str := '这里是' + searchstr + '。';
            SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
          end;
      end;
    '#':
      begin
        if Strs[0] = '#' then
        begin
          if (SysopScope > 50) and (Length(astr) > 4) then
          begin
            UserList.SendNoticeMessage('<SYSTEM>: ' + Copy(astr, 2, Length(astr)), SAY_COLOR_NOTICE);
            exit;
          end;
        end;
      end;
    '@':
      begin
        if SysopScope >= 20 then
        begin
          if Strs[0] = '@发放元宝' then
          begin
            if Strs[1] <> '' then
            begin
              GM_ADDMONEY(strs[1], _strtoint(strs[2]));
            end;
            exit;
          end;
        end;
        if SysopScope > 99 then
        begin
                    ///////////////////////////////
                    //        测试指令
                    {if UpperCase(Strs[0]) = '@求婚' then
                    begin
                        marriedlist.MarryInput(self, '输入婚对象名字。');
                        exit;
                    end;
                    }
          if UpperCase(Strs[0]) = '@效果' then
          begin
            for i := 0 to _strtoint(Strs[3]) do
            begin
              case _strtoint(Strs[1]) of
                1: ShowEffect(_strtoint(Strs[2]), lek_none);
                2: ShowEffect(_strtoint(Strs[2]), lek_follow);
                3: ShowEffect(_strtoint(Strs[2]), lek_future);
                4: ShowEffect(_strtoint(Strs[2]), lek_cumulate);
                5: ShowEffect(_strtoint(Strs[2]), lek_cumulate_follow);
              end;

            end;
            exit;
          end;
          if UpperCase(Strs[0]) = '@修改浩然' then
          begin
            AttribClass.SETvirtue(_strtoint(Strs[1]));
            exit;
          end;
          if UpperCase(Strs[0]) = '@修改职业等级' then
          begin
            n := GetLevelExp(_strtoint(Strs[1]));
            HaveMagicClass.JobAddExp(n, n);
            exit;
          end;
          if UpperCase(Strs[0]) = '@修改职业' then
          begin
            HaveMagicClass.jobSetKind(_strtoint(Strs[1]));
            exit;
          end;
          if UpperCase(Strs[0]) = '@修改元气' then
          begin
            AttribClass.SetEnergy(_strtoint(Strs[1]));
            exit;
          end;
          if UpperCase(Strs[0]) = '@修改荣誉' then
          begin
            AttribClass.prestige := _strtoint(Strs[1]);
            exit;
          end;
          if UpperCase(Strs[0]) = '@修改年龄' then
          begin
            Connector.CharData.Light := _strtoint(Strs[1]);
            Connector.CharData.Dark := _strtoint(Strs[1]);
            AttribClass.SaveToSdb(@Connector.CharData);

            exit;
          end;
          if UpperCase(Strs[0]) = '@增加武功经验' then
          begin
            HaveMagicClass.AddMagicExp((Strs[1]), _strtoint(Strs[2]));
            exit;
          end;


                    //////////////////////////////
                    //         废弃指令
                    {if Strs[0] = '@角色信息' then
                    begin
                        if Strs[1] <> '' then
                        begin
                            Str := GuildList.GetCharInformation(Strs[1]);
                            if Str <> '' then
                            begin
                                SendClass.SendChatMessage(Str, SAY_COLOR_SYSTEM);
                            end;
                        end;
                        exit;
                    end;
                     if Strs[0] = '@门派信息' then
                    begin
                        if Strs[1] <> '' then
                        begin
                            Str := GuildList.GetInformation(Strs[1]);
                            if Str <> '' then
                            begin
                                SendClass.SendChatMessage(Str, SAY_COLOR_SYSTEM);
                            end;
                        end;
                        exit;
                    end;
                    if Strs[0] = '@参加对战' then
                    begin
                        SetPositionBS(BasicData.X, BasicData.Y);
                        exit;
                    end;

                    if UpperCase(Strs[0]) = '@荐访悼沥焊' then
                    begin
                        SendClass.SendChatMessage(ObjectChecker.GetCurInfo, SAY_COLOR_SYSTEM);
                        exit;
                    end;
                    }


          if Strs[0] = '@速度确认' then
          begin
            if boCheckSpeed = false then
            begin
              Str := '检查速度';
              boCheckSpeed := true;
            end else
            begin
              Str := '结束检查速度';
              boCheckSpeed := false;
            end;
            SendClass.SendChatMessage(Str, SAY_COLOR_SYSTEM);
            exit;
          end;

          if UpperCase(Strs[0]) = '@REGENMAP' then
          begin
            n := Manager.RegenInterval;
            Manager.RegenInterval := 1;
            Manager.Update(mmAnsTick);
            Manager.RegenInterval := n;
            exit;
          end;
          if UpperCase(Strs[0]) = '@召唤怪兽' then
          begin
            if Strs[1] <> '' then
            begin
              TMonsterList(Manager.MonsterList).ComeOn(Strs[i], BasicData.X, BasicData.Y);
            end;
            exit;
          end;

          if UpperCase(Strs[0]) = '@还生' then
          begin
            SubData.HitData.HitType := 0;
            SendLocalMessage(0, FM_REFILL, BasicData, SubData);
            exit;
          end;
          if UpperCase(Strs[0]) = '@DIE' then
          begin
            AttribClass.CurMagic := 0;
            AttribClass.CurOutPower := 0;
            AttribClass.CurInPower := 0;
            AttribClass.CurLife := 0;
            AttribClass.CurHeadLife := 0;
            AttribClass.CurLegLife := 0;
            AttribClass.CurArmLife := 0;
            exit;
          end;
          if UpperCase(Strs[0]) = '@整理道具' then
          begin
            HaveItemClass.DeleteAllItem;
            exit;
          end;
          if UpperCase(strs[0]) = '@使用者情报' then
          begin
            if Strs[1] = '' then
            begin
              UserList.SaveUserInfo('.\LOG\USERINFO.SDB');
              SendClass.SendNUMSAY(numsay_disposalOK, SAY_COLOR_SYSTEM); //   '处理完毕',                //6  numsay_disposalOK
            end else
            begin
              TempUser := UserList.GetUserPointer(Strs[1]);
              if TempUser <> nil then
              begin
                RetStr := TempUser.Name + ': IP(' + TempUser.Connector.IpAddr + ') Ver(' + IntToStr(TempUser.Connector.VerNo) + ')';
                SendClass.SendChatMessage(RetStr, SAY_COLOR_SYSTEM);
              end else
              begin
                SendClass.SendChatMessage(format('%s目前不在线上。', [Strs[1]]), SAY_COLOR_SYSTEM);
              end;
            end;
            exit;
          end;

          if UpperCase(strs[0]) = '@SHOWME' then
          begin
            for i := 0 to ViewObjectList.Count - 1 do
            begin
              Bo := ViewObjectList.Items[i];
              SendClass.SendChatMessage((Bo.BasicData.Name) + '(' + IntToStr(Bo.BasicData.X) + ',' + IntToStr(Bo.BasicData.Y) + ')', SAY_COLOR_SYSTEM);
            end;
            SendClass.SendChatMessage(format('开启了%d个', [ViewObjectList.Count]), SAY_COLOR_SYSTEM);
            exit;
          end;

          if UpperCase(strs[0]) = '@DAMAGE' then //经验 显示 开关
          begin
            boShowHitedValue := not boShowHitedValue;
            exit;
          end;
          if UpperCase(strs[0]) = '@GUILDDAMAGE' then
          begin
            boShowGuildDuraValue := not boShowGuildDuraValue;
            exit;
          end;

          if UpperCase(strs[0]) = '@呐喊' then
          begin
            UserList.SendCenterMSG(ColorSysToDxColor($00FFFFFF), strs[1], SHOWCENTERMSG_BatMsg);
            exit;
          end;
          if UpperCase(strs[0]) = '@世界TOP' then
          begin
            UserList.SendTopMSG(ColorSysToDxColor($0000FF), strs[1]);
            exit;
          end;
          if UpperCase(strs[0]) = '@世界1TOP' then
          begin
            SendClass.SendTopMSG(ColorSysToDxColor($0000FF), strs[1]);
            exit;
          end;
          if UpperCase(strs[0]) = '@滚动' then
          begin
            UserList.SendRollMSG(ColorSysToDxColor($0080FFFF), strs[1]);
            exit;
          end;
          if UpperCase(strs[0]) = '@设定躲闪' then
          begin
            SysopScope := 101;
            exit;
          end;
          if UpperCase(strs[0]) = '@解除躲闪' then
          begin
            SysopScope := 100;
            exit;
          end;
                    //门派
          if UpperCase(strs[0]) = '@移动门派' then
          begin
            if GuildList.MoveStone(Strs[1], Manager.ServerID, BasicData.x, BasicData.y) = true then
            begin
              SendClass.SendChatMessage('已移动门派石', SAY_COLOR_SYSTEM);
            end;
            exit;
          end;
          if UpperCase(strs[0]) = '@创建门派' then
          begin
            if GuildList.CreateStone(Strs[1], '', Manager.ServerID, BasicData.x, BasicData.y) = true then
            begin
              SendClass.SendChatMessage('已创建门派石', SAY_COLOR_SYSTEM);
            end;
            exit;
          end;
          if UpperCase(strs[0]) = '@删除门派' then
          begin
            GuildList.DeleteStone(Strs[1]);
            exit;
          end;

                    {if UpperCase(strs[0]) = '@READSCRIPTER' then
                    begin
                        ScripterList.ReLoadFromFile;
                        exit;
                    end;   }
          if UpperCase(strs[0]) = '@READ' then
          begin
            ScripterList.Clear;
            SysopClass.ReLoadFromFile;
            ItemClass.ReLoadFromFile;
            MonsterClass.ReLoadFromFile;
            NpcClass.ReLoadFromFile;
            DynamicObjectClass.RELoadFromFile;

            ManagerList.ReLoadFromFile;
            exit;
          end;

                    // 泅犁 付阑狼 漂沥 谅钎肺 捞悼茄促
          if UpperCase(strs[0]) = '@移动' then
          begin
            xx := _StrToInt(Strs[1]);
            yy := _StrToInt(Strs[2]);
            if Maper.isMoveable(xx, yy) then
            begin
              PosMoveX := xx;
              PosMoveY := yy;
            end;
            exit;
          end;

                    // 货肺款 付阑狼 漂沥 谅钎肺 捞悼茄促
          if UpperCase(strs[0]) = '@移动到' then
          begin
            xx := _StrToInt(Strs[2]);
            yy := _StrToInt(Strs[3]);

            tmpManager := ManagerList.GetManagerByTitle(Strs[1]);
            if tmpManager <> nil then MoveToMap(tmpManager.ServerID, xx, yy, 0);

            exit;
          end;

                    // 林函 葛电 阁胶磐客 NPC 甫 力芭窃
          if UpperCase(Strs[0]) = '@爆' then
          begin
            SubData.TargetId := 0;
            if UpperCase(Strs[1]) = 'MOP' then
            begin
              SubData.TargetId := 1;
            end;
            ShowEffect(4, lek_none);
            SendLocalMessage(NOTARGETPHONE, FM_DEADHIT, BasicData, SubData);
            exit;
          end;

                    // NPC 家券
          if UpperCase(Strs[0]) = '@CALLNPC' then
          begin
            Bo := TNpcList(Manager.NpcList).GetNpcByName(Strs[1]);
            if Bo <> nil then
            begin
              for k := 0 to 10 - 1 do
              begin
                xx := BasicData.X - 2 + Random(4);
                yy := BasicData.Y - 2 + Random(4);
                if Maper.isMoveable(xx, yy) then
                begin
                  TNpc(Bo).CallMe(xx, yy);
                  break;
                end;
              end;
            end;
            exit;
          end;
                    // 阁胶磐 家券
          if UpperCase(Strs[0]) = '@CALLMOP' then
          begin
            Bo := TBasicObject(TMonsterList(Manager.MonsterList).GetMonsterByName(Strs[1]));
            if Bo <> nil then
            begin
              for k := 0 to 10 - 1 do
              begin
                xx := BasicData.X - 2 + Random(4);
                yy := BasicData.Y - 2 + Random(4);
                if Maper.isMoveable(xx, yy) then
                begin
                  TMonster(Bo).CallMe(xx, yy);
                  break;
                end;
              end;
            end;
            exit;
          end;
                    // NPC 免滴
          if UpperCase(Strs[0]) = '@APPEARNPC' then
          begin
            Bo := TNpcList(Manager.NpcList).GetNpcByName(Strs[1]);
            if Bo <> nil then
            begin
              PosMoveX := BO.BasicData.x;
              PosMoveY := BO.BasicData.y;
            end;
            exit;
          end;
                    // 阁胶磐 免滴
          if UpperCase(Strs[0]) = '@APPEARMOP' then
          begin
            Bo := TBasicObject(TMonsterList(Manager.MonsterList).GetMonsterByName(Strs[1]));
            if Bo <> nil then
            begin
              PosMoveX := BO.BasicData.x;
              PosMoveY := BO.BasicData.y;
            end;
            exit;
          end;
                    //监视 某个人
          if UpperCase(Strs[0]) = '@SHOW' then
          begin
            if Strs[1] = '' then exit;
                        //查找
            TempUser := UserList.GetUserPointer(Strs[1]);
            if TempUser <> nil then
            begin
              if TempUser.SysopObj = nil then
              begin
                if UserObj <> nil then
                begin
                  TUser(UserObj).SysopObj := nil;
                end;
                                //监视 对象
                UserObj := TempUser;
                                //对方给自己
                TempUser.SysopObj := Self;
                if not boTv then
                begin
                  boTv := TRUE;
                end;
                SendClass.SendMap(TempUser.BasicData, TempUser.Manager.MapName, TempUser.Manager.ObjName, TempUser.Manager.RofName, TempUser.Manager.TilName, Manager.SoundBase, Manager.Title);
                for i := 0 to TempUser.ViewObjectList.Count - 1 do
                  SendClass.SendShow(TBasicObject(TempUser.ViewObjectList[i]).BasicData);
              end;
            end;
            exit;
          end;

                    // 荤侩磊狼 立加阑 秦力 矫挪促
          if (UpperCase(Strs[0]) = '@BAN') or (UpperCase(Strs[0]) = '@BANEX') then
          begin
            if Strs[1] <> '' then
            begin
              msgstr := Copy(astr, Pos(Strs[1], astr) + Length(Strs[1]), Length(astr));
              TempUser := UserList.GetUserPointer(Strs[1]);
              if TempUser = nil then
              begin
                SendClass.SendChatMessage(format('%s目前不在线上。', [Strs[1]]), SAY_COLOR_SYSTEM);
              end else
              begin
                if UpperCase(Strs[0]) = '@BAN' then
                  TempUser.SendClass.SendChatMessage('人物已被管理者强制断线', SAY_COLOR_SYSTEM);
                if msgstr <> '' then
                begin
                  msgstr := '风云OL:' + msgstr;
                  TempUser.SendClass.SendChatMessage(msgstr, SAY_COLOR_NORMAL);
                end;
                boDeleteState := true;
                ConnectorList.CloseConnectByCharName((TempUser.BasicData.Name));

                SendClass.SendChatMessage(format('%s将在10秒后断线。', [Strs[1]]), SAY_COLOR_SYSTEM);
              end;
            end;
          end;


          if UpperCase(strs[0]) = '@禁言' then
          begin
            TempUser := UserList.GetUserPointer(Strs[1]);
            if TempUser = nil then
            begin
              SendClass.SendChatMessage(format('%s不在。', [Strs[1]]), SAY_COLOR_SYSTEM);
            end else
            begin
              TempUser.boCanSay := not TempUser.boCanSay;
            end;
          end;
          if UpperCase(strs[0]) = '@禁止移动' then
          begin
            tempUser := UserList.GetUserPointer(Strs[1]);
            if tempUser <> nil then
            begin
              case tempUser.WearItemClass.GetActionState of
                as_free:
                  begin
                    tempUser.WearItemClass.SetActionState(as_ice);
                  end;
                as_ice:
                  begin
                    tempUser.WearItemClass.SetActionState(as_free);
                  end;
              end;
              SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, tempUser.BasicData, SubData);
            end else
            begin
              SendClass.SendChatMessage(format('%s不在。', [Strs[1]]), SAY_COLOR_SYSTEM);
            end;
          end;
          if UpperCase(strs[0]) = '@剧' then
          begin
            TempUser := UserList.GetUserPointer(Strs[1]);
            if TempUser = nil then
            begin
              SendClass.SendChatMessage(format('%s不在。', [Strs[1]]), SAY_COLOR_SYSTEM);
            end else
            begin
              TempUser.boCanAttack := not TempUser.boCanAttack;
            end;
          end;

          if UpperCase(strs[0]) = '@唤回' then
          begin
            TempUser := UserList.GetUserPointer(Strs[1]);
            if TempUser = nil then
            begin
              SendClass.SendChatMessage(format('%s不在。', [Strs[1]]), SAY_COLOR_SYSTEM);
            end else
            begin
                            {if TempUser.ServerID <> ServerID then
                            begin
                                Tempuser.boNewServer := TRUE;
                                TempUser.ServerID := ServerID;
                            end;
                            TempUser.PosMoveX := BasicData.x;
                            TempUser.PosMoveY := BasicData.y;
                            }
              Tempuser.MoveToMap(ServerID, BasicData.x, BasicData.y, 0);
            end;
          end;
          if (UpperCase(Strs[0]) = '@出兵') or (UpperCase(Strs[0]) = '@APPEAREX') then
          begin
            TempUser := UserList.GetUserPointer(Strs[1]);
            if TempUser = nil then
            begin
              SendClass.SendChatMessage(format('%s不在。', [Strs[1]]), SAY_COLOR_SYSTEM);
            end else
            begin
                            {if TempUser.ServerID <> ServerID then
                            begin
                                boNewServer := TRUE;
                                ServerID := TempUser.ServerID;
                            end;

                            PosMoveX := TempUser.BasicData.x;
                            PosMoveY := TempUser.BasicData.y;

                            if UpperCase(Strs[0]) = '@APPEAREX' then
                            begin
                                PosMoveX := PosMoveX + 10;
                                PosMoveY := PosMoveY + 10;
                            end;
                            }
              MoveToMap(TempUser.ServerID, TempUser.BasicData.x, TempUser.BasicData.y, 0);
            end;
            exit;
          end;
          if UpperCase(Strs[0]) = '@设定隐身' then
          begin
            WearItemClass.SetHiddenState(hs_0);
            SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
            exit;
          end;
          if UpperCase(Strs[0]) = '@解除隐身' then
          begin
            WearItemClass.SetHiddenState(hs_100);
            SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
            exit;
          end;
          if UpperCase(Strs[0]) = '@囚禁' then
          begin
            msgstr := PrisonClass.AddUser(Strs[1], Strs[2], Strs[3]);
            if msgstr = '' then
            begin
              SendClass.SendNUMSAY(numsay_disposalOK, SAY_COLOR_SYSTEM); //   '处理完毕',                //6  numsay_disposalOK
            end else
            begin
              SendClass.SendChatMessage(msgstr, SAY_COLOR_SYSTEM);
            end;
            exit;
          end;
          if UpperCase(Strs[0]) = '@释放' then
          begin
            msgstr := PrisonClass.DelUser(Strs[1]);
            if msgstr = '' then
            begin
              SendClass.SendChatMessage('处理完毕', SAY_COLOR_SYSTEM);
            end else
            begin
              SendClass.SendChatMessage(msgstr, SAY_COLOR_SYSTEM);
            end;
            exit;
          end;
          if UpperCase(Strs[0]) = '@修改囚禁资料' then
          begin
            msgstr := Prisonclass.UpdateUser(Strs[1], Strs[2], Strs[3]);
            if msgstr = '' then
            begin
              SendClass.SendChatMessage('处理完毕', SAY_COLOR_SYSTEM);
            end else
            begin
              SendClass.SendChatMessage(msgstr, SAY_COLOR_SYSTEM);
            end;
            exit;
          end;
          if UpperCase(Strs[0]) = '@追加囚禁资料' then
          begin
            msgstr := PrisonClass.PlusUser(Strs[1], Strs[2], Strs[3]);
            if msgstr = '' then
            begin
              SendClass.SendNUMSAY(numsay_disposalOK, SAY_COLOR_SYSTEM); //   '处理完毕',                //6  numsay_disposalOK
            end else
            begin
              SendClass.SendChatMessage(msgstr, SAY_COLOR_SYSTEM);
            end;
            exit;
          end;
          if UpperCase(Strs[0]) = '@设定囚禁时间' then
          begin
            msgstr := PrisonClass.EditUser(Strs[1], Strs[2], Strs[3]);
            if msgstr = '' then
            begin
              SendClass.SendNUMSAY(numsay_disposalOK, SAY_COLOR_SYSTEM); //   '处理完毕',                //6  numsay_disposalOK
            end else
            begin
              SendClass.SendChatMessage(msgstr, SAY_COLOR_SYSTEM);
            end;
            exit;
          end;
          if UpperCase(Strs[0]) = '@囚禁情报' then
          begin
            if Strs[1] <> '' then
            begin
              msgstr := PrisonClass.GetUserStatus(Strs[1]);
              if msgstr <> '' then
              begin
                SendClass.SendChatMessage(msgstr, SAY_COLOR_SYSTEM);
              end;
            end;
            exit;
          end;

          if Strs[0] = '@武功经验翻倍' then
          begin
            i := _StrToInt(Strs[1]);
            n := _StrToInt(Strs[2]);
            if i <= 0 then exit;
            if n <= 0 then exit;
            MagicExpMulAdd(i, n);
            exit;
          end;
          if Strs[0] = '@item' then
          begin
            ItemClass.GetItemData(strs[1], ItemData);
                        //if ItemData.rName[0] = 0 then
            if ItemData.rName = '' then
            begin
              SendClass.SendChatMessage(format('%s 没有item', [Strs[1]]), SAY_COLOR_SYSTEM);
              exit;
            end;

            if (ItemData.rPrice = 0) or (SysopScope > 99) then
            begin
              if (SysopScope > 99) and (Strs[2] <> '') then
              begin
                ItemData.rCount := _StrToInt(Strs[2]);
                if ItemData.rCount <= 0 then ItemData.rCount := 1;

              end;
              tmpBasicData.Feature.rRace := RACE_NPC;
              tmpBasicData.Name := 'item';
              tmpBasicData.x := BasicData.x;
              tmpBasicData.y := BasicData.y;
//                            SignToItem(ItemData, ServerID, tmpBasicData, '');
              NewItemSet(_nist_all, ItemData); //GM 制造
              if (ItemData.rboDouble = false) and (ItemData.rCount > 1) then
                ItemData.rCount := 1;
              if HaveItemClass.AddItem(@ItemData) then
                logItemMoveInfo('GM背包增加', nil, @BasicData, ItemData, Manager.ServerID);
              tmlog.add(format('additem:%s,(%s,%d)', [name, ItemData.rName, ItemData.rCount]));
              SendClass.SendChatMessage(format('做出%s.', [Strs[1]]), SAY_COLOR_SYSTEM);
            end else
            begin
              SendClass.SendNUMSAY(numsay_12, SAY_COLOR_SYSTEM); //   , '价格为零物品或您的权限受到限制而无法做出.' //12 numsay_12
            end;
          end;
          if UpperCase(Strs[0]) = '@三魂' then
          begin
            SendClass.SendChatMessage(format('天%d,地%d,命%d', [AttribClass.AQget3f_sky, AttribClass.AQget3f_terra, AttribClass.AQget3f_fetch]), SAY_COLOR_SYSTEM);
            exit;
          end;
        end;
                //GM 指令结束--------------------------------------------------------
              {  if UpperCase(Strs[0]) = '@传音' then
                begin
                    strs[1] := trim(strs[1]);
                    if strs[1] = '' then
                    begin
                        SendClass.SendChatMessage('千里传音内容空', SAY_COLOR_SYSTEM);
                        exit;
                    end;
                    if HaveItemClass.ViewItemName('千里传音', @ItemData) = FALSE then
                    begin
                        SendClass.SendChatMessage('没有[千里传音]', SAY_COLOR_SYSTEM);
                        exit;
                    end;
                    ItemData.rCount := 1;
                    if HaveItemClass.DeleteItem(@ItemData) = false then
                    begin
                        SendClass.SendChatMessage('使用[千里传音]失败', SAY_COLOR_SYSTEM);
                        exit;
                    end;
                    UserList.SendNoticeMessage2('「传音」' + name + ':' + strs[1], ColorSysToDxColor($00FFFF00), ColorSysToDxColor($00452428));

                    exit;
                end;
                }
        if UpperCase(Strs[0]) = '@关闭元神' then
        begin
          MonsterClear;
          SendClass.SendChatMessage('元神已经关闭。', SAY_COLOR_SYSTEM);
          exit;
        end;
        if UpperCase(Strs[0]) = '@武功经验翻倍情报' then
        begin
          i := Connector.CharData.MagicExpMulCount;
          if i > 0 then
          begin
            msgstr := format('武功翻倍经验状态：%d 倍经验 剩余时间：%d 分钟 ', [i, MagicExpMulGetCurMulMinutes]);
          end else
          begin
            msgstr := '当前你没有武功翻倍经验';
          end;
          SendClass.SendChatMessage(msgstr, SAY_COLOR_SYSTEM);
          exit;
        end;

        if UpperCase(Strs[0]) = '@反击' then
        begin
          if fCounterAttack_state = false then
            msgstr := '反击状态：关闭'
          else msgstr := '反击状态：开启 剩余时间(分)：' + inttostr((fCounterAttack_datetime - mmAnsTick) div 6000);
          SendClass.SendChatMessage(msgstr, SAY_COLOR_SYSTEM);
          exit;
        end;
        if UpperCase(Strs[0]) = '@囚禁情报' then
        begin
          msgstr := Prisonclass.GetUserStatus(Name);
          if msgstr <> '' then
          begin
            SendClass.SendChatMessage(msgstr, SAY_COLOR_SYSTEM);
          end;
          exit;
        end;

        if (strs[0] = INI_SERCHSKILL) or (strs[0] = '@探查') then
        begin
          strs[1] := trim(strs[1]);
          if strs[1] = '' then
          begin
            SendClass.SendChatMessage('探查内容空', SAY_COLOR_SYSTEM);
            exit;
          end;
          if SearchTick + 1000 > mmAnsTick then
          begin
            SendClass.SendChatMessage('请稍后重来。', SAY_COLOR_SYSTEM);
            exit;
          end;
          if HaveItemClass.ViewItemName('缉捕令', @ItemData) = FALSE then
          begin
            SendClass.SendChatMessage('没有[缉捕令]', SAY_COLOR_SYSTEM);
            exit;
          end;
          ItemData.rCount := 1;
          if HaveItemClass.DeleteItem(@ItemData) = false then
          begin
            SendClass.SendChatMessage('使用[缉捕令]失败', SAY_COLOR_SYSTEM);
            exit;
          end;

          SearchTick := mmAnsTick;
          TempUser := UserList.GetUserPointer(strs[1]);
          if TempUser = nil then
          begin
            SendClass.SendChatMessage(format('%s不在。', [strs[1]]), SAY_COLOR_SYSTEM);
            exit;
          end;
          if SysopScope >= 100 then
          begin
            SendClass.SendChatMessage(format('%s在[%d,%d:%d]。', [strs[1], TempUser.ServerID, TempUser.BasicData.x, TempUser.BasicData.y]), SAY_COLOR_SYSTEM);
          end;
          if TempUser.SysopScope >= 100 then
          begin
                        //  SendClass.SendChatMessage('此人是风云OLGM。无法探查', SAY_COLOR_SYSTEM);
            SendClass.SendChatMessage(format('%s不在。', [strs[1]]), SAY_COLOR_SYSTEM);
            exit;
          end;
          if TempUser.ServerID <> ServerID then
          begin
            SendClass.SendChatMessage(format('%s在 %s。', [strs[1], TempUser.Manager.Title]), SAY_COLOR_SYSTEM);
            exit;
          end;
          searchstr := '';
          TempLength := GetLargeLength(BasicData.x, BasicData.y, TempUser.PosX, TempUser.Posy);
          tempdir := GetViewDirection(BasicData.x, BasicData.y, TempUser.PosX, TempUser.Posy);
          case tempdir of
            0: searchstr := INI_NORTH;
            1: searchstr := INI_NORTHEAST;
            2: searchstr := INI_EAST;
            3: searchstr := INI_EASTSOUTH;
            4: searchstr := INI_SOUTH;
            5: searchstr := INI_SOUTHWEST;
            6: searchstr := INI_WEST;
            7: searchstr := INI_WESTNORTH;
          end;

          if TempLength < 30 then searchstr := format('在 %s里。', [searchstr])
          else searchstr := format('%s在远处。', [searchstr]);
          SendClass.SendChatMessage(searchstr, SAY_COLOR_SYSTEM);

        end;

        if strs[0] = '@武功删除' then
        begin
          if Strs[1] <> '' then
          begin
                        {for i := 0 to NameStringListForDeleteMagic.Count - 1 do
                        begin
                            if Name = NameStringListForDeleteMagic[i] then
                            begin
                                SendClass.SendNUMSAY(numsay_9, SAY_COLOR_SYSTEM); //   '今天已做过删除武功的动作。' //9   numsay_9
                                SendClass.SendNUMSAY(numsay_10, SAY_COLOR_SYSTEM); //  , '一天只可删除一次'       //10   numsay_10
                                exit;
                            end;
                        end;}

            if datetostr(Connector.CharData.DelMagicTime) = datetostr(date) then
            begin
              if Connector.CharData.DelMagicCount > 0 then
              begin
                SendClass.SendNUMSAY(numsay_9, SAY_COLOR_SYSTEM); //   '今天已做过删除武功的动作。' //9   numsay_9
                SendClass.SendNUMSAY(numsay_10, SAY_COLOR_SYSTEM); //  , '一天只可删除一次'       //10   numsay_10
                exit;
              end;
            end else
            begin
              Connector.CharData.DelMagicTime := now();
              Connector.CharData.DelMagicCount := 0;
            end;

            if HaveMagicClass.DeleteMagicName(Strs[1]) then
            begin
              SendClass.SendChatMessage(Strs[1] + '武功已被删除。', SAY_COLOR_SYSTEM);
              i := Connector.CharData.DelMagicCount;
              inc(i);
              if (i < 0) then i := 0;
              if i > 255 then i := 255;
              Connector.CharData.DelMagicCount := i;
                          //  NameStringListForDeleteMagic.Add(Name);
            end else SendClass.SendNUMSAY(numsay_11, SAY_COLOR_SYSTEM); // , '失败了。'               //11   numsay_11

                        {ret := HaveMagicClass.GetMagicIndex(Strs[1]);
                        if ret <> -1 then
                        begin
                            if HaveMagicClass.DeleteMagic(ret) then
                            begin
                                SendClass.SendChatMessage(Strs[1] + '武功已被删除。', SAY_COLOR_SYSTEM);
                                NameStringListForDeleteMagic.Add(Name);
                            end else SendClass.SendNUMSAY(numsay_11, SAY_COLOR_SYSTEM); // , '失败了。'               //11   numsay_11
                        end;
                        }
          end;
          exit;
        end;
        if strs[0] = '@观战' then
        begin
          if boTV = true then
          begin
            MirrorList.DelViewer(Self);
            boTV := false;
          end;
          if MirrorList.AddViewer(Strs[1], Self) = true then
          begin
            boTv := true;
          end;
          exit;
        end;
        if strs[0] = '@结束观战' then
        begin
          if boTV = true then
          begin
            MirrorList.DelViewer(Self);
            boTV := false;
          end;
          exit;
        end;

        if Strs[0] = '@接收纸条' then
        begin
          if Strs[1] = '' then
          begin
            boLetterCheck := true;
            SendClass.SendNUMSAY(numsay_20, SAY_COLOR_NORMAL); //  , '设定接收纸条'           //20  numsay_20
          end else
          begin
            if Strs[1] = (BasicData.Name) then exit;
            TempUser := UserList.GetUserPointer(Strs[1]);
            if TempUser <> nil then
            begin
              TempUser.DelRefusedUser((BasicData.Name));
              SendClass.SendNUMSAY(numsay_21, SAY_COLOR_SYSTEM, Strs[1]); //        , '你已设定接收%s传来的纸条。' //21 numsay_21
            end else
            begin
              SendClass.SendNUMSAY(numsay_22, SAY_COLOR_SYSTEM); // , '对方不在线上。'         //22  numsay_22
            end;
          end;
          exit;
        end;
        if Strs[0] = '@拒绝纸条' then
        begin
          if Strs[1] = '' then
          begin
            boLetterCheck := false;
            SendClass.SendNUMSAY(numsay_23, SAY_COLOR_NORMAL); //        , '设定拒绝纸条。'         //23  numsay_23
          end else
          begin
            if Strs[1] = (BasicData.Name) then exit;
            TempUser := UserList.GetUserPointer(Strs[1]);
            if TempUser <> nil then
            begin
              if CheckSenderList(Strs[1]) then
              begin
                TempUser.AddRefusedUser((BasicData.Name));
                SendClass.SendChatMessage(format('你已设定拒绝%s传来的纸条。', [Strs[1]]), SAY_COLOR_SYSTEM);
              end;
            end else
            begin
              SendClass.SendChatMessage('对方不在线上。', SAY_COLOR_SYSTEM);
            end;
          end;
          exit;
        end;

        if UpperCase(Strs[0]) = '@CREATEGUILD' then
        begin
          if GuildList.CreateStone(Strs[1], (BasicData.Name), Manager.ServerID, BasicData.x, BasicData.y) = true then
          begin
            SendClass.SendChatMessage('已移动门派石', SAY_COLOR_SYSTEM);
          end;
          exit;
        end;

        if (Strs[0] = '@设定团队') then
        begin
          i := _StrToInt(Strs[1]);
          RetStr := SETfellowship(i);
          if RetStr <> '' then
            SendClass.SendChatMessage(RetStr, SAY_COLOR_SYSTEM);
          exit;
        end;
        if (Strs[0] = '@GameExit') then
        begin
          RetStr := ShowItemGameexitWindow;
          SendClass.SendChatMessage(RetStr, SAY_COLOR_SYSTEM);
          exit;
        end;
        if (Strs[0] = '@修改密码') then
        begin
          RetStr := ShowItemUPDATEPasswordWindow;
          SendClass.SendChatMessage(RetStr, SAY_COLOR_SYSTEM);
          exit;
        end;
        if (Strs[0] = '@设定密码') then
        begin
          RetStr := ShowItemSetPasswordWindow;
          SendClass.SendChatMessage(RetStr, SAY_COLOR_SYSTEM);
          exit;
        end;

        if Strs[0] = '@解除密码' then
        begin
          RetStr := ShowItemFreePasswordWindow;
          SendClass.SendChatMessage(RetStr, SAY_COLOR_SYSTEM);
          exit;
        end;
        if (Strs[0] = '@设定福袋密码') then
        begin
          RetStr := ShowItemLogSetPasswordWindow;
          SendClass.SendChatMessage(RetStr, SAY_COLOR_SYSTEM);
          exit;
        end;
        if Strs[0] = '@解除福袋密码' then
        begin
          RetStr := ShowItemLogFreePasswordWindow;
          SendClass.SendChatMessage(RetStr, SAY_COLOR_SYSTEM);
          exit;
        end;
        if Strs[0] = '@攻击模式' then
        begin
          case BasicData.HitTargetsType of
            _htt_All:
              begin
                BasicData.HitTargetsType := _htt_Monster;
                SendClass.SendChatMessage('当前攻击模式：只攻击怪物', SAY_COLOR_SYSTEM);
              end;
            _htt_Monster:
              begin
                BasicData.HitTargetsType := _htt_Npc;
                SendClass.SendChatMessage('当前攻击模式：只攻击NPC', SAY_COLOR_SYSTEM);
              end;
            _htt_Npc:
              begin
                BasicData.HitTargetsType := _htt_nation;
                SendClass.SendChatMessage('当前攻击模式：攻击其它部落', SAY_COLOR_SYSTEM);
              end;
            _htt_nation:
              begin
                BasicData.HitTargetsType := _htt_All;
                SendClass.SendChatMessage('当前攻击模式：攻击全部', SAY_COLOR_SYSTEM);
              end;
          end;

        end;
                // 巩颇公傍 积己
        if Strs[0] = '@申请门派武功' then
        begin
          if GuildName = '' then
          begin
            SendClass.SendChatMessage('只有门主才能申请', SAY_COLOR_SYSTEM);
            exit;
          end;
          if SpecialWindow <> WINDOW_NONE then
          begin
            SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
            exit;
          end;
          GuildObject := GuildList.GetGuildObject(GuildName);
          if GuildObject <> nil then
          begin
            if GuildObject.IsGuildSysop(Name) = false then exit;
            if GuildObject.GetGuildMagicString <> '' then exit;

            ItemClass.GetItemData('金币', ItemData);
                        //if ItemData.rName[0] = 0 then exit;
            if ItemData.rName = '' then exit;
            ItemData.rCount := 40;
            if FindItem(@ItemData) = false then
            begin
              SendClass.SendChatMessage('申请门派武功时需要40个金币', SAY_COLOR_SYSTEM);
              exit;
            end;

            FillChar(GuildMagicWindow, SizeOf(TSShowGuildMagicWindow), 0);
            GuildMagicWindow.rMsg := SM_SHOWSPECIALWINDOW;
            GuildMagicWindow.rWindow := WINDOW_GUILDMAGIC;
            GuildMagicWindow.rSpeed := 50;
            GuildMagicWindow.rDamageBody := 50;
            GuildMagicWindow.rRecovery := 50;
            GuildMagicWindow.rAvoid := 50;
            GuildMagicWindow.rDamageHead := 20;
            GuildMagicWindow.rDamageArm := 20;
            GuildMagicWindow.rDamageLeg := 20;
            GuildMagicWindow.rArmorBody := 48;
            GuildMagicWindow.rArmorHead := 40;
            GuildMagicWindow.rArmorArm := 40;
            GuildMagicWindow.rArmorLeg := 40;
            GuildMagicWindow.rOutPower := 20;
            GuildMagicWindow.rInPower := 20;
            GuildMagicWindow.rMagicPower := 20;
            GuildMagicWindow.rLife := 20;

            SpecialWindow := WINDOW_GUILDMAGIC;
            SendClass.SendShowGuildMagicWindow(@GuildMagicWindow);
          end;
          exit;
        end;
      end;
    '!':
      begin
        if mmanstick < SayTick + 300 then exit;
        SayTick := mmAnsTick;
        if Length(aStr) <= 2 then exit;

        if SysopScope < 100 then
        begin
          if Manager.boBigSay = false then
          begin
            if aStr[2] <> '!' then
            begin
              SendClass.SendChatMessage('禁止大喊的地区。', SAY_COLOR_SYSTEM);
            end else
            begin
              if Length(aStr) <= 3 then exit;
              UserList.SayByServerID(ServerID, '{' + Name + '} : ' + Copy(astr, 3, Length(aStr) - 2));
            end;
            exit;
          end;
        end else
        begin
          if Manager.boBigSay = false then
          begin
            if aStr[2] = '!' then
            begin
              if Length(aStr) <= 3 then exit;
              UserList.SayByServerID(ServerID, '{' + Name + '} : ' + Copy(astr, 3, Length(aStr) - 2));
              exit;
            end;
          end;
        end;

        if (astr[2] = '!') and (GuildName <> '') then
        begin
          if Length(astr) <= 3 then exit;
          UserList.GuildSay(GuildName, '<' + Name + '> : ' + Copy(astr, 3, Length(astr) - 2));
          exit;
        end;

        if Length(astr) - 1 <= 0 then exit;

                //                if (AttribClass.CurLife <= 5000) and (SysopScope < 100) then
        if (AttribClass.CurLife <= 2000) and (SysopScope < 100) then
        begin
          SendClass.SendChatMessage('活力需在20以上。', SAY_COLOR_SYSTEM);
          exit;
        end;

        if SysopScope < 100 then
          AttribClass.CurLife := AttribClass.CurLife - 2000;

        sColor := SAY_COLOR_GRADE0;
             //   with AttribClass.AttribData do n := cMagic + cInPower + cOutPower + cLife; // n := cEnergy + cMagic + cInPower + cOutPower + cLife;
        n := AttribClass.AQgetMagic + AttribClass.AQgetInPower + AttribClass.AQgetOutPower + AttribClass.AQgetLife; // n := cEnergy + cMagic + cInPower + cOutPower + cLife;

        n := (n - 5000) div 4000;
        if n < 0 then n := 0;
        if n > 11 then n := 11;
        case n of
          0..6: sColor := SAY_COLOR_GRADE0;
          7: sColor := SAY_COLOR_GRADE1;
          8: sColor := SAY_COLOR_GRADE2;
          9: sColor := SAY_COLOR_GRADE3;
          10: sColor := SAY_COLOR_GRADE4;
          11: sColor := SAY_COLOR_GRADE5;
        end;

        if SysopScope >= 100 then sColor := SAY_COLOR_GRADE5;

        UserList.SendNoticeMessage('[' + Name + '] : ' + Copy(astr, 2, Length(astr) - 1), sColor);
      end;
  else
    begin
      SetWordString(SubData.SayString, Name + ': ' + astr);
      SendLocalMessage(NOTARGETPHONE, FM_SAY, BasicData, SubData);
    end;
  end;
end;

procedure TUser.ExChangeStart(aId: Integer); //aId对方 ID
var
  ExChangeUser: TUser;
  BObject: TBasicObject;
  SubData: TSubData;
begin
  if aid = BasicData.id then exit;
  if SpecialWindow <> 0 then
  begin
    SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
    exit;
  end;
    //自己 状态非0
  if ExChange.isstate then
  begin
    SendClass.SendChatMessage('请关闭之前交易的窗口', SAY_COLOR_SYSTEM);
    exit;
  end;

  BObject := TBasicObject(SendLocalMessage(aid, FM_GIVEMEADDR, BasicData, SubData)); //FM_GIVEMEADDR 返回这个的 类地址
  if (Integer(BObject) = 0) or (integer(BObject) = -1) then exit; //没找到 结束
  if BObject.BasicData.BasicObjectType <> botUser then exit; //非 人结束

  ExChangeUser := TUser(BObject);
  if ExChangeUser.ExChange.isstate then
  begin
    SendClass.SendChatMessage((ExChangeUser.BasicData.Name) + '对方正与其它玩家进行交易', SAY_COLOR_SYSTEM);
    exit;
  end;
    //清除 双放 交易临时物品
  ExChange.Clear;
  ExChangeUser.ExChange.Clear;
    //我保存 当前 交易人  ID 名字
  ExChange.setExChange(ExchangeUser.BasicData.id, ExchangeUser.BasicData.Name);
    //对方保存 当前 交易人  ID 名字
  ExChangeUser.ExChange.setExChange(BasicData.id, BasicData.Name);
  ExChangeShow;

end;

procedure TUser.InputOkProcess(var code: TWordComData);
var
  sname, searchstr, str: string;
  pCInputString: PTCInputString;
  TempUser: TUser;
  id, amsg, akey, yid: integer;
  astate: boolean;
begin
  id := 0;
  amsg := WordComData_GETbyte(code, id);
  if amsg <> CM_InputOk then exit;
  akey := WordComData_GETbyte(code, id);
  yid := WordComData_GETdword(code, id);
  astate := boolean(WordComData_GETbyte(code, id));
  case akey of
    ShowInputOk_type_marryMsg:
      begin
        if astate then marriedlist.MarryResponsionOk(self, yid)
        else marriedlist.MarryResponsionNo(self, yid);
        exit;
      end;
    ShowInputOk_type_marry_showmarriage:
      begin

        Marriage.showmarriageOk(self, yid, astate);
      end;
    ShowInputOk_type_marry_setofficiator:
      begin
        Marriage.showsetofficiatorInputOk(self, yid, astate);
      end;
    ShowInputOk_type_ummarry:
      begin
        marriedlist.unMarryResponsionOk(self, yid, astate);
      end;
    ShowInputOk_type_ExChange:
      begin
        if astate then
          ExChangemsgOk(yid)
        else
          ExChangemsgNO(yid);
      end;

  end;

end;

procedure TUser.InputStringProcess(var code: TWordComData);
var
  sname, searchstr, str: string;
  pCInputString: PTCInputString;
  TempUser: TUser;
  tempdir, TempLength
    , id, amsg, akey, yid: integer;
  astate: boolean;
  ItemData: titemdata;
begin
  id := 0;
  amsg := WordComData_GETbyte(code, id);
  if amsg = CM_INPUTSTRING2 then
  begin
    akey := WordComData_GETbyte(code, id);
    yid := WordComData_GETdword(code, id);
    astate := boolean(WordComData_GETbyte(code, id));
    if astate then sname := WordComData_GETstring(code, id) else sname := '';

    case akey of
      ShowInputString_type_marryinput:
        begin
          if astate then marriedlist.MarryInputName(self, sname, yid);
        end;
      ShowInputString_type_marrysetofficiator:
        Marriage.showsetofficiatorInput(self, sname, yid, astate);
    end;
    exit;
  end;
  pCInputString := @Code.Data;
    //
  case InputStringState of
    InputStringState_None: ;
        //        InputStringState_AddExchange:;
    InputStringState_Search: // if rSelectedList then ;;
      begin
        InputStringState := InputStringState_None;
        sname := GetWordString(pCInputString^.rInputString);
        sname := trim(sname);
        if sname = '' then
        begin
          SendClass.SendChatMessage('探查内容空', SAY_COLOR_SYSTEM);
          exit;
        end;
        if SearchTick + 1000 > mmAnsTick then
        begin
          SendClass.SendChatMessage('请稍后重来。', SAY_COLOR_SYSTEM);
          exit;
        end;
        if HaveItemClass.ViewItemName('缉捕令', @ItemData) = FALSE then
        begin
          SendClass.SendChatMessage('没有[缉捕令]', SAY_COLOR_SYSTEM);
          exit;
        end;
        ItemData.rCount := 1;
        if HaveItemClass.DeleteItem(@ItemData) = false then
        begin
          SendClass.SendChatMessage('使用[缉捕令]失败', SAY_COLOR_SYSTEM);
          exit;
        end;

        SearchTick := mmAnsTick;
        TempUser := UserList.GetUserPointer(sname);
        if TempUser = nil then
        begin
          SendClass.SendChatMessage(format('%s不在。', [sname]), SAY_COLOR_SYSTEM);
          exit;
        end;
        if TempUser.SysopScope >= 100 then
        begin
                    //  SendClass.SendChatMessage('此人是风云OLGM。无法探查', SAY_COLOR_SYSTEM);
          SendClass.SendChatMessage(format('%s不在。', [sname]), SAY_COLOR_SYSTEM);
          exit;
        end;
        if TempUser.ServerID <> ServerID then
        begin
          SendClass.SendChatMessage(format('%s在 %s。', [sname, TempUser.Manager.Title]), SAY_COLOR_SYSTEM);
          exit;
        end;
        searchstr := '';
        TempLength := GetLargeLength(BasicData.x, BasicData.y, TempUser.PosX, TempUser.Posy);
        tempdir := GetViewDirection(BasicData.x, BasicData.y, TempUser.PosX, TempUser.Posy);
        case tempdir of
          0: searchstr := INI_NORTH;
          1: searchstr := INI_NORTHEAST;
          2: searchstr := INI_EAST;
          3: searchstr := INI_EASTSOUTH;
          4: searchstr := INI_SOUTH;
          5: searchstr := INI_SOUTHWEST;
          6: searchstr := INI_WEST;
          7: searchstr := INI_WESTNORTH;
        end;

        if TempLength < 30 then searchstr := format('在 %s里。', [searchstr])
        else searchstr := format('%s在远处。', [searchstr]);
        SendClass.SendChatMessage(searchstr, SAY_COLOR_SYSTEM);
      end;
  end;
end;

procedure TUser.ExChangeItemAdd(ahaveItemKey, acount: integer);
var
  ItemData: tItemData;
  TempUser: tuser;
begin
  if HaveItemClass.LockedPass then
  begin
    SendClass.SendChatMessage('有密码设定', SAY_COLOR_SYSTEM);
    exit;
  end;
  if not HaveItemClass.ViewItem(ahaveItemKey, @ItemData) then exit;
  if ItemData.rlockState <> 0 then
  begin
    SendClass.SendChatMessage('物品锁定中,无法交换.', SAY_COLOR_SYSTEM);
    exit;
  end;
  if (ItemData.rKind = ITEM_KIND_CANTMOVE)
    or (ItemData.rboNotExchange = true) then
  begin
    SendClass.SendChatMessage('无法交换的物品', SAY_COLOR_SYSTEM);
    exit;
  end;

  if ExChange.getname(itemdata.rName) <> nil then
  begin
    SendClass.SendChatMessage('已经有同样名称的物品。', 3);
    exit;
  end;

  if ExChange.IsSpace = false then
  begin
    SendClass.SendChatMessage('无法继续添加', 3);
    exit;
  end;
    //

  ItemData.rcount := aCount;

  TempUser := getExUser;
  if TempUser = nil then
  begin
    SendClass.SendChatMessage('交换对象不存在', 3);
    ExChangeClose;
    exit;
  end;
    //增加
  if ExChange.add(ahaveItemKey, ItemData) then
  begin

  end else
  begin //失败
    SendClass.SendChatMessage('无法再增加。', 3);
    exit;
  end;

  if ExChangeDataIsCheck then
  begin
    ExChangeUPDATE;
  end else
  begin
    ExChangeClose;
  end;
end;

procedure TUser.ExChangeItemDel(aExChangeItemkey: integer);
begin

end;

//功能：测试 交易物品在背包是否存在

function TUser.ExChangeDataIsCheck: Boolean; //交易 状态测试
var
  j: integer;
  aItemData: TItemData;
begin
  Result := false;

  for j := 0 to high(ExChange.fdata.rItems) do
  begin
    if ExChange.fdata.rItems[j].ritem.rName = '' then Continue;
    if HaveItemClass.ViewItem(ExChange.fdata.rItems[j].rkey, @aItemData) then
    begin
      if (aItemData.rName <> ExChange.fdata.rItems[j].ritem.rName)
        or (aItemData.rcolor <> ExChange.fdata.rItems[j].ritem.rcolor)
        or (aItemData.rCount < ExChange.fdata.rItems[j].ritem.rCount) then
        exit;
    end else
    begin
      exit;
    end;
  end;
  Result := true;
end;

function TUser.InputCountWindowIs(aCountID, aSourKey, aDestKey, aCount: Integer): boolean;
begin
  result := false;
  if (CountWindowState.rCountid <> aCountID)
    or (CountWindowState.rsourkey <> aSourKey)
    or (CountWindowState.rdestkey <> aDestKey) then
  begin
    SendClass.SendChatMessage('警告！数据非法。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if (aCount > CountWindowState.rCountMax) then
  begin
    SendClass.SendChatMessage('数量超过最大。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if (aCount <= 0) then
  begin
    SendClass.SendChatMessage('数量不能为零。', SAY_COLOR_SYSTEM);
    exit;
  end;
  result := true;
end;

procedure TUser.InputCountWindowClose();
begin
  if SpecialWindow <> WINDOW_InputCount then exit;
  SpecialWindow := 0;
  CountWindowState.rCountid := DRAGACTION_NONE;
end;

procedure TUser.InputCountWindowShow(aCountID, aSourKey, aDestKey, aCntMax: Integer; aCaption: string);
begin
  if SpecialWindow <> 0 then
  begin
    SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
    exit;
  end;
  if CountWindowState.rCountid <> DRAGACTION_NONE then
  begin
    SendClass.SendChatMessage('数量输入筐在使用。', SAY_COLOR_SYSTEM);
    exit;
  end;
  SpecialWindow := WINDOW_InputCount;
  CountWindowState.rCountid := aCountID;
  CountWindowState.rsourkey := aSourKey;
  CountWindowState.rdestkey := aDestKey;
  CountWindowState.rCountCur := 0;
  CountWindowState.rCountMax := aCntMax;

  SendClass.SendShowCount(aCountID, aSourKey, aDestKey, aCntMax, aCaption);
  SendClass.SendChatMessage('请选择个数', SAY_COLOR_SYSTEM);
end;

procedure TUser.GuildCreateName(var Code: TWordComData);
var
  ret: integer;
  ItemData: TItemData;
  TempBasicData: TBasicData;
  SubData: TSubData;
  arsourkey: integer;
  id, akey: integer;
  aGuildName: string;
begin
  id := 1;
  akey := WordComData_GETbyte(code, id);
  if akey <> GUILD_Create_name then exit;

  arsourkey := WordComData_GETbyte(code, id);
  aGuildName := WordComData_GETstring(code, id);

  if not HaveItemClass.ViewItem(arsourkey, @ItemData) then
  begin
    SendClass.SendChatMessage('物品名字有误。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if (ItemData.rName) <> INI_GUILD_STONE then
  begin
    SendClass.SendChatMessage('物品不是' + INI_GUILD_STONE, SAY_COLOR_SYSTEM);
    exit;
  end;
  if Itemdata.rCount < 1 then
  begin
    SendClass.SendChatMessage('物品数量有误。', SAY_COLOR_SYSTEM);
    exit;
  end;
  if GuildName <> '' then
  begin
    SendClass.SendNUMSAY(numsay_24, SAY_COLOR_SYSTEM, GuildName); //   , '你已加入 %s,无法成立门派。' //24  numsay_24
    exit;
  end;
  if (not isFullHangul(aGuildName)) or //(not isGrammarID(aGuildName)) or
    (Length(aGuildName) > 12) or (Length(aGuildName) < 2) then
  begin
    SendClass.SendChatMessage('门派名字错误。', SAY_COLOR_SYSTEM);
    SendClass.SendShowCreateGuildName(arsourkey);
    exit;
  end;
  if GuildList.GetGuildNname(aGuildName) <> nil then
  begin
    SendClass.SendChatMessage('已有门派名称,无法成立门派。', SAY_COLOR_SYSTEM);
    SendClass.SendShowCreateGuildName(arsourkey);
    exit;
  end;
  if GuildList.AllowGuildCondition(aGuildName, name) = false then
  begin
    SendClass.SendChatMessage('该人物已是门主或副门主,无法成立门派。', SAY_COLOR_SYSTEM); // BocSay('');
    exit;
  end;
//    SignToItem(ItemData, ServerID, BasicData, IP);
  ItemData.rCount := 1;
  SubData.ItemData := ItemData;
  SubData.ServerId := ServerID;
  SubData.TargetId := arsourkey;
  SubData.GuildName := aGuildName;

  ret := Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
  if ret = PROC_TRUE then
  begin
    TempBasicData.Feature.rrace := RACE_NPC;
    TempBasicData.Name := '地面';
    TempBasicData.x := BasicData.x;
    TempBasicData.y := BasicData.y;
//        SignToItem(ItemData, ServerID, TempBasicData, '');
    HaveItemClass.DeleteKeyItem(arsourkey, ItemData.rCount);
  end else
  begin
    SendClass.SendChatMessage('无法放在这个地方。', SAY_COLOR_SYSTEM);
  end;

end;

procedure TUser.ItemlogToHaveItem(aHavekey, aItemlogKey, acount: integer);
var
  ItemData: tItemData;
begin
    //  SendClass.SendChatMessage('仓库到背包', SAY_COLOR_SYSTEM);

  if not ItemLog.ViewItem(aItemlogKey, @ItemData) then exit;
  if ItemData.rCount < acount then exit;

  ItemLog.affair(ilaStart);
  if ItemLog.del(aItemlogKey, acount) then
  begin
    SendClass.SendChatMessage('仓库扣物品问题', SAY_COLOR_SYSTEM);
    exit;
  end;
  ItemData.rCount := acount;
  if HaveItemClass.AddItem(@ItemData) then
  begin
        // SendClass.SendChatMessage('从仓库成功取出物品', SAY_COLOR_SYSTEM);
  end else
  begin
    ItemLog.affair(ilaRoll_back);
    SendClass.SendChatMessage('失败', SAY_COLOR_SYSTEM);
    exit;
  end;
end;

procedure TUser.HaveItemToItemlog(aHavekey, aItemlogKey, acount: integer);
var
  ItemData: tItemData;
begin
    //    SendClass.SendChatMessage('背包到仓库', SAY_COLOR_SYSTEM);
        //物品 到 仓库
  if not HaveItemClass.ViewItem(aHavekey, @ItemData) then exit;
  if ItemData.rboNotSSamzie = true then
  begin
    SendClass.SendChatMessage('无法放入福袋的物品', SAY_COLOR_SYSTEM);
    exit;
  end;
  if ItemData.rCount < acount then exit;

    //增加
  HaveItemClass.affair(hicaStart);
  ItemData.rCount := acount;
  if ItemLog.add(aItemlogKey, ItemData) = false then
  begin //失败
    SendClass.SendChatMessage('仓库增加失败', SAY_COLOR_SYSTEM);
    exit;
  end;
  if HaveItemClass.DeletekeyItem(aHavekey, acount) = false then
  begin
    HaveItemClass.affair(hicaRoll_back);
    SendClass.SendChatMessage('物品问题', SAY_COLOR_SYSTEM);
  end;
end;

procedure TUser.InputCountProcess(var Code: TWordComData);
var
  i, ret: integer;
  ItemData: TItemData;
  pccount: PTCSelectCount;
  tempUser: TUser;
  TempBasicData: TBasicData;
  SubData: TSubData;
  boFlag: boolean;
begin
  if SpecialWindow <> WINDOW_InputCount then exit;
  pccount := @Code.data;

  if not InputCountWindowIs(pccount.rCountid, pccount.rsourkey, pccount.rdestkey, pccount.rCount) then
  begin
    InputCountWindowclose;
    exit;
  end;
  InputCountWindowclose;

  if pccount^.rboOk = FALSE then exit;

  case pcCount^.rCountid of
    DRAGACTION_DROPITEM:
      begin //丢 下物品
        if not HaveItemClass.ViewItem(pccount^.rsourkey, @ItemData) then exit;
        if pccount^.rCount <= 0 then exit;
        if Itemdata.rCount >= pccount^.rCount then
        begin
//                    SignToItem(ItemData, ServerID, BasicData, IP);
          ItemData.rCount := pccount^.rCount;
          SubData.ItemData := ItemData;
          SubData.ServerId := ServerID;

          ret := Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData);
          if ret = PROC_TRUE then
          begin
            TempBasicData.Feature.rrace := RACE_NPC;
            TempBasicData.Name := '地面';
            TempBasicData.x := BasicData.x;
            TempBasicData.y := BasicData.y;
//                        SignToItem(ItemData, ServerID, TempBasicData, '');
            HaveItemClass.DeleteKeyItem(pccount^.rsourkey, ItemData.rCount);
          end else
          begin
            SendClass.SendChatMessage('无法放在这个地方。', SAY_COLOR_SYSTEM);
          end;
        end;
      end;
    DRAGACTION_ADDEXCHANGEITEM:
      begin //增加 交换 物品

      end;
    DRAGACTION_FROMITEMTOLOG:
      begin //物品 到 仓库

      end;
    DRAGACTION_FROMLOGTOITEM:
      begin //

      end;
  end;
end;

procedure TUser.DragProcess(var code: TWordComData);
var
  i, ret: integer;
  pcDragDrop: PTCDragDrop;
  BObject: TBasicObject;
  tmpBasicData: TBasicData;
  ItemData, tmpItemData: TItemdata;
  SubData: TSubData;
  boFlag: boolean;
  oldHitType: Byte;
  str: string;
  ComData: TWordComData;
  pcSelectCount: PTCSelectCount;
begin
  if ExChange.isstate then
  begin
    SendClass.SendChatMessage('正在交易 操作失败', SAY_COLOR_SYSTEM);
    exit;
  end;
  if SpecialWindow <> 0 then
  begin
    exit;
  end;

  pcDragDrop := @Code.Data;
  with pcdragdrop^ do
  begin
        ////////////////////////////////////////////////////////////////////////
        //                           背包 到 背包
        ////////////////////////////////////////////////////////////////////////
    if (rsourwindow = WINDOW_ITEMS) and (rdestwindow = WINDOW_ITEMS) then
    begin //
      if ExChange.isstate then
      begin
        SendClass.SendChatMessage('正在交易 操作失败', SAY_COLOR_SYSTEM);
        exit;
      end;

      if HaveItemClass.colorItem(rsourkey, rdestkey) = false then
        HaveItemClass.ChangeItem(rsourkey, rdestkey);
    end;
        ////////////////////////////////////////////////////////////////////////
    if (rsourwindow = WINDOW_MAGICS) and (rdestwindow = WINDOW_MAGICS) then
    begin
      HaveMagicClass.ChangeMagic(rsourkey, rdestkey);
    end;
    if (rsourwindow = WINDOW_MAGICS_Rise) and (rdestwindow = WINDOW_MAGICS_Rise) then
    begin
      HaveMagicClass.Rise_ChangeMagic(rsourkey, rdestkey);
    end;
    if (rsourwindow = WINDOW_MAGICS_Mystery) and (rdestwindow = WINDOW_MAGICS_Mystery) then
    begin
      HaveMagicClass.Mystery_ChangeMagic(rsourkey, rdestkey);
    end;
        {
        if (rsourwindow = WINDOW_BASICFIGHT) and (rdestwindow = WINDOW_BASICFIGHT) then begin
           HaveMagicClass.ChangeBasicMagic (rsourkey, rdestkey);
        end;
        }
        ////////////////////////////////////////////////////////////////////////
        //                           背包 到 身上
        ////////////////////////////////////////////////////////////////////////
    if (rsourwindow = WINDOW_ITEMS) and (rdestwindow = WINDOW_WEARS) then
    begin //  没目标位置，直接装备自动识别放什么位置
      if ExChange.isstate then
      begin
        SendClass.SendChatMessage('正在交易 操作失败', SAY_COLOR_SYSTEM);
        exit;
      end;
      if HaveItemClass.ViewItem(rsourkey, @ItemData) = FALSE then exit;

      if ItemData.rKind = 100 then
      begin

                //背包 拷贝1份 装置物品
               // if HaveItemClass.ViewItem(rsourkey, @ItemData) = FALSE then exit;
                //身上
        if WearItemClass.AddItemFD(@ItemData) = FALSE then exit;
//                tmpItemData.rOwnerName := '';
        HaveItemClass.DeleteKeyItem(rsourkey, 1);

      end else
      begin
                //拷贝一份武器 出来出来   不知道为什么
        WearItemClass.ViewItem(ARR_WEAPON, @ItemData);

        oldHitType := ItemData.rHitType;
                //背包 拷贝1份 装置物品
        if HaveItemClass.ViewItem(rsourkey, @ItemData) = FALSE then exit;
                //身上
        if WearItemClass.AddItem(@ItemData) = FALSE then exit;
//                tmpItemData.rOwnerName := '';
        HaveItemClass.DeleteKeyItem(rsourkey, 1);

        WearItemClass.ViewItem(ARR_WEAPON, @ItemData);
        if oldHitType <> ItemData.rHitType then
        begin
          HaveMagicClass.SetHaveItemMagicType(ItemData.rHitType);
          HaveMagicClass.SelectBasicMagic(ItemData.rHitType, 100, str);
          HaveMagicClass.SetEctMagic(nil);
        end;
      end;
      WearItemClass.UPFeature;
      SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
    end;
        ////////////////////////////////////////////////////////////////////////
        //                           身上 到 背包
        ////////////////////////////////////////////////////////////////////////
    if ((rsourwindow = WINDOW_WEARS)) and (rdestwindow = WINDOW_ITEMS) then
    begin
      if ExChange.isstate then
      begin
        SendClass.SendChatMessage('正在交易 操作失败', SAY_COLOR_SYSTEM);
        exit;
      end;
      if rsourkey >= 100 then
      begin
        rsourkey := rsourkey - 100;
        if rsourkey = 5 then rsourkey := 1;
        if WearItemClass.ViewItemFD(rsourkey, @ItemData) = FALSE then exit;
//                ItemData.rOwnerName := '';
        if HaveItemClass.AddItem(@ItemData) = FALSE then exit;
        WearItemClass.DeleteKeyItemFD(rsourkey);
      end else
      begin

        WearItemClass.ViewItem(ARR_WEAPON, @ItemData);

        oldHitType := ItemData.rHitType;

        if rsourkey = 5 then rsourkey := 1;
        if WearItemClass.ViewItem(rsourkey, @ItemData) = FALSE then exit;
//                ItemData.rOwnerName := '';
        if HaveItemClass.AddItem(@ItemData) = FALSE then exit;
        WearItemClass.DeleteKeyItem(rsourkey);

        WearItemClass.ViewItem(ARR_WEAPON, @ItemData);
        if oldHitType <> ItemData.rHitType then
        begin
          HaveMagicClass.SetHaveItemMagicType(ItemData.rHitType);
          HaveMagicClass.SelectBasicMagic(ItemData.rHitType, 100, str);
          HaveMagicClass.SetEctMagic(nil);
        end;
      end;
      WearItemClass.UPFeature;
      SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
    end;
        ////////////////////////////////////////////////////////////////////////
        //                           背包 TO  地上
        ////////////////////////////////////////////////////////////////////////
    if (rsourwindow = WINDOW_ITEMS) and (rdestwindow = WINDOW_SCREEN) then
    begin //
      if HaveItemClass.LockedPass then
      begin
        SendClass.SendChatMessage('有密码设定', SAY_COLOR_SYSTEM);
        exit;
      end;
      if HaveItemClass.ViewItem(rsourkey, @ItemData) = FALSE then exit;
      if ItemData.rlockState <> 0 then
      begin
        SendClass.SendChatMessage('贵重物品已加锁,请不要随便乱扔!', SAY_COLOR_SYSTEM);
        exit;
      end;

      if rdestid = 0 then
        if (ItemData.rKind = ITEM_KIND_CANTMOVE)
          or (ItemData.rboNotDrop = true) then
        begin
          SendClass.SendChatMessage('无法交换的物品', SAY_COLOR_SYSTEM);
          exit;
        end;
      if GetCellLength(BasicData.x, BasicData.y, rdx, rdy) > 3 then
      begin
        SendClass.SendChatMessage('距离太远', SAY_COLOR_SYSTEM);
        exit;
      end;
      BasicData.nx := rdx;
      BasicData.ny := rdy;
      SubData.ServerId := ServerID;
            //--------------------------------------------物品 丢到对象上-------------------------------
      if rdestid <> 0 then
      begin
                // 背券芒 规过 Start
        if rdestid <> BasicData.id then
        begin
          if SpecialWindow <> WINDOW_NONE then exit;
          if ExChange.isstate then
          begin
            SendClass.SendChatMessage('正在交易 操作失败', SAY_COLOR_SYSTEM);
            exit;
          end;
          Bobject := GetViewObjectById(rDestid);
          if (Integer(BObject) = -1) or (Integer(BObject) = 0) then exit;
          case BObject.BasicData.Feature.rrace of
            RACE_HUMAN:
              begin
                if (BObject.BasicData.Feature.rfeaturestate = wfs_die) and ((ItemData.rName) = INI_ROPE) then
                begin
//                                    SignToItem(ItemData, ServerID, BasicData, IP);
                  SubData.ItemData := ItemData;
                  SubData.ItemData.rCount := 1;
                  BasicData.nx := rdx;
                  BasicData.ny := rdy;
                  ret := Phone.SendMessage(rdestid, FM_ADDITEM, BasicData, SubData); //  鸥牢俊霸 林扁...
                  if ret = PROC_TRUE then
                  begin
//                                        tmpItemData.rOwnerName := '';
                    HaveItemClass.DeleteKeyItem(rsourkey, 1);
                  end;
                  exit;
                end;
                if TUser(BObject).SpecialWindow <> WINDOW_NONE then
                begin
                  SendClass.SendChatMessage(TUser(BObject).Name + '此人在无法进行交换物品的状态下。', SAY_COLOR_SYSTEM);
                  exit;
                end;
                if TUser(BObject).ExChange.isstate then
                begin
                  SendClass.SendChatMessage('对方与其他人交易中。', SAY_COLOR_SYSTEM);
                  exit;
                end;

                ExChangemsg(rDestid);
                rdestwindow := WINDOW_EXCHANGE;
              end;
            RACE_MONSTER:
              begin
                            //拖物品 到怪物身上
                SubData.TargetId := rsourkey;
                SendLocalMessage(rdestid, FM_Drag, BasicData, SubData);

              end;
          else
            begin
              ItemData.rCount := 1;
//                            SignToItem(ItemData, ServerID, BasicData, IP);
              SubData.ItemData := ItemData;
              BasicData.nx := rdx;
              BasicData.ny := rdy;
              ret := Phone.SendMessage(rdestid, FM_ADDITEM, BasicData, SubData); //  鸥牢俊霸 林扁...
              if ret = PROC_TRUE then
              begin
                tmpBasicData.Feature.rRace := RACE_NPC;
                tmpBasicData.Name := '染色物品';
                tmpBasicData.x := BasicData.x;
                tmpBasicData.y := BasicData.y;
//                                SignToItem(ItemData, ServerID, tmpBasicData, '');
                HaveItemClass.DeleteKeyItem(rsourkey, 1);
              end;
              exit;
            end;
          end;


        end;

      end else
      begin

        if ExChange.isstate then
        begin
          SendClass.SendChatMessage('正在交易 操作失败', SAY_COLOR_SYSTEM);
          exit;
        end;

        if (ItemData.rName) = INI_GUILD_STONE then
        begin //门派石
          if GuildName <> '' then
          begin
            SendClass.SendNUMSAY(numsay_24, SAY_COLOR_SYSTEM, GuildName); //   , '你已加入 %s,无法成立门派。' //24  numsay_24
            exit;
          end;
          SendClass.SendShowCreateGuildName(rsourkey);
        end else
          InputCountWindowShow(DRAGACTION_DROPITEM, rsourkey, rdestkey, ItemData.rCount, (ItemData.rViewName));

        exit;
      end;
    end;
        ////////////////////////////////////////////////////////////////////////
        //                          地上 TO  背包
        ////////////////////////////////////////////////////////////////////////
    if (rsourwindow = WINDOW_SCREEN) and (rdestwindow = WINDOW_ITEMS) then
    begin // 凛扁
      if rsourid <> 0 then
      begin
        Bobject := GetViewObjectById(rsourid);
        if (Integer(BObject) = -1) or (Integer(BObject) = 0) then exit;
        if GetCellLength(BasicData.x, BasicData.y, BObject.Posx, BObject.Posy) > 3 then
        begin
          SendClass.SendChatMessage('距离太远', SAY_COLOR_SYSTEM);
          exit;
        end;
                // SendClass.SendChatMessage('地上拖到背包' + inttostr(Bobject.BasicData.id), SAY_COLOR_SYSTEM);
        Phone.SendMessage(rsourid, FM_PICKUP, BasicData, SubData);
      end;
    end;
        ////////////////////////////////////////////////////////////////////////
        //
        ////////////////////////////////////////////////////////////////////////
    if (rsourwindow = WINDOW_SCREEN) and (rdestwindow = WINDOW_SCREEN) then
    begin // 凛扁
      if BasicData.id = rdestid then
      begin
        if rsourid <> 0 then
        begin
          Bobject := GetViewObjectById(rsourid);
          if (Integer(BObject) = -1) or (Integer(BObject) = 0) then exit;
          if GetCellLength(BasicData.x, BasicData.y, BObject.Posx, BObject.Posy) > 3 then
          begin
            SendClass.SendChatMessage('距离太远', SAY_COLOR_SYSTEM);
            exit;
          end;
          SendClass.SendChatMessage('WINDOW_SCREEN，WINDOW_SCREEN' + inttostr(Bobject.BasicData.id), SAY_COLOR_SYSTEM);
          Phone.SendMessage(rsourid, FM_PICKUP, BasicData, SubData);
        end;
      end;
    end;
        ////////////////////////////////////////////////////////////////////////
        //                           交易
        ////////////////////////////////////////////////////////////////////////
    if (rsourwindow = WINDOW_ITEMS) and (rdestwindow = WINDOW_EXCHANGE) then
    begin
            //交易                      // 背券芒俊 棵府扁
                // 肮荐甫 拱绢焊扁 傈俊 固府 八荤茄促 start
        {    if HaveItemClass.LockedPass then
            begin
                SendClass.SendChatMessage('有密码设定', SAY_COLOR_SYSTEM);
                exit;
            end;
            if not HaveItemClass.ViewItem(rsourkey, @ItemData) then exit;
            if ItemData.rlockState <> 0 then
            begin
                SendClass.SendChatMessage('物品锁定中,无法交换.', SAY_COLOR_SYSTEM);
                exit;
            end;
            if (ItemData.rKind = ITEM_KIND_CANTMOVE)
                or (ItemData.rboNotExchange = true) then
            begin
                SendClass.SendChatMessage('无法交换的物品', SAY_COLOR_SYSTEM);
                exit;
            end;

            if ExChange.getname(itemdata.rName) <> nil then
            begin
                SendClass.SendChatMessage('已经有同样名称的物品。', 3);
                exit;
            end;

            if ExChange.IsSpace = false then
            begin
                SendClass.SendChatMessage('无法继续添加', 3);
                exit;
            end;
            //输入
            InputCountWindowShow(DRAGACTION_ADDEXCHANGEITEM, rsourkey, rdestkey, ItemData.rCount, (ItemData.rViewName));
            }
    end;
        ////////////////////////////////////////////////////////////////////////
        //                           背包 到仓库
        ////////////////////////////////////////////////////////////////////////
    if (rsourwindow = WINDOW_ITEMS) and (rdestwindow = WINDOW_ITEMLOG) then
    begin //

    end;
        ////////////////////////////////////////////////////////////////////////
        //                           仓库  到 背包
        ////////////////////////////////////////////////////////////////////////
    if (rsourwindow = WINDOW_ITEMLOG) and (rdestwindow = WINDOW_ITEMS) then
    begin //

    end;
  end;
end;

procedure TUser.ExChangemsg(auserid: integer);
var
  tempuser: tuser;
  YID: integer;
begin
  tempuser := tuser(GetViewObjectById(auserid));
  if tempuser = nil then exit;
  if tempuser.BasicData.BasicObjectType <> botUser then exit;
  YID := tempuser.ExChange.MsgList.add(name, tempuser.name);
  tempuser.SendClass.SendShowInputOk(ShowInputOk_type_ExChange, yid, format('%s 邀请开始交易', [name]));
  SendClass.SendChatMessage('交易邀请中...', SAY_COLOR_SYSTEM);
end;

procedure TUser.ExChangemsgOk(ayid: integer);
var
  tempuser: tuser;
  tempmsg: pTResponsiondata;
  tempname: string;
begin
  tempmsg := ExChange.MsgList.GetID(ayid);
  if tempmsg = nil then
  begin
    SendClass.SendChatMessage('消息过期', SAY_COLOR_SYSTEM);
    exit;
  end;
  tempname := tempmsg.rDestName;
  ExChange.MsgList.delId(ayid);
  tempuser := tuser(GetViewObjectByName(tempname, RACE_HUMAN));
  if tempuser = nil then exit;
  if tempuser.BasicData.BasicObjectType <> botUser then exit;

  if GetCellLength(BasicData.x, BasicData.y, tempuser.BasicData.x, tempuser.BasicData.y) > 3 then
  begin
    SendClass.SendChatMessage('失败！目标太远', SAY_COLOR_SYSTEM);
    exit;
  end;
  ExChangeStart(tempuser.BasicData.id);
end;

procedure TUser.ExChangemsgNO(ayid: integer);
var
  tempuser: tuser;
  tempmsg: pTResponsiondata;
  tempname: string;
begin
  tempmsg := ExChange.MsgList.GetID(ayid);
  if tempmsg = nil then
  begin
    SendClass.SendChatMessage('消息过期', SAY_COLOR_SYSTEM);
    exit;
  end;
  tempname := tempmsg.rDestName;
  ExChange.MsgList.delId(ayid);
  tempuser := tuser(GetViewObjectByName(tempname, RACE_HUMAN));
  if tempuser = nil then exit;
  if tempuser.BasicData.BasicObjectType <> botUser then exit;
  tempuser.SendClass.SendChatMessage(format('%s 拒绝交易', [name]), SAY_COLOR_SYSTEM);
end;
//交易 增加到对方

procedure TUser.AddExChangeData(aSource, adest: pTBasicData; pex: PTExChangedata);
var
  i: integer;
    //  ItemData        :TItemData;
begin
  for i := 0 to high(pex.rItems) do
  begin
    if pEx^.rItems[i].rItem.rName <> '' then
    begin

      ItemExChangeADDITEM(aSource, adest, @pex^.rItems[i].rItem);
    end;
  end;

end;

procedure TUser.DelExChangeData(aSource: pTBasicData; pex: PTExChangedata);
var
  j: integer;
begin
  for j := 0 to high(pex.rItems) do
  begin
    if pEx^.rItems[j].rItem.rName <> '' then
    begin
            // HaveItemClass.DeleteKeyItem(pEx^.rItems[j].rKey, pEx^.rItems[j].rItem.rCount);
      ItemExChangeDeleteItemKEY(aSource, pEx^.rItems[j].rKey, pEx^.rItems[j].rItem.rCount, @pEx^.rItems[j]);
    end;
  end;
end;

procedure TUser.ExChangeShow();
var
  TempBasicData: TBasicData;
  SubData: TSubData;
begin
  TempBasicData.id := ExChange.fdata.rExChangeId;
  SendLocalMessage(ExChange.fdata.rExChangeId, FM_SHOWEXCHANGE, BasicData, SubData);
  SendLocalMessage(BasicData.id, FM_SHOWEXCHANGE, TempBasicData, SubData);
end;

procedure TUser.ExChangeUPDATE();
var
  TempBasicData: TBasicData;
  SubData: TSubData;
  tempuser: tuser;
begin
  TempBasicData.id := ExChange.fdata.rExChangeId;
  SendLocalMessage(ExChange.fdata.rExChangeId, FM_EXCHANGE_UPDATE, BasicData, SubData);
  SendLocalMessage(BasicData.id, FM_EXCHANGE_UPDATE, TempBasicData, SubData);
  tempuser := getExUser;
  if tempuser = nil then tempuser.ExChange.SendEnd;
  ExChange.SendEnd;
end;

procedure TUser.ExChangeClose();
var
  TempBasicData: TBasicData;
  SubData: TSubData;
begin
  TempBasicData.id := ExChange.fdata.rExChangeId;
  SendLocalMessage(ExChange.fdata.rExChangeId, FM_CANCELEXCHANGE, BasicData, SubData);
  SendLocalMessage(BasicData.id, FM_CANCELEXCHANGE, TempBasicData, SubData);
end;

function TUser.getExUser(): Tuser;
var
  BObject: TBasicObject;
  SubData: TSubData;
begin
  result := nil;
  BObject := TBasicObject(SendLocalMessage(ExChange.fdata.rExChangeId, FM_GIVEMEADDR, BasicData, SubData));
  if (Integer(BObject) = 0) or (integer(BObject) = -1) then
  begin

    exit;
  end else
  begin
    if not (BObject is TUser) then
    begin
      exit;
    end;
    result := TUser(BObject);
  end;
end;

//交易 确认

procedure TUser.ExChangeClick; //(awin:byte; aclickedid:longInt; akey:word);
var
  ExUser: TUser;
begin

  ExChange.fdata.rboCheck := true; //not ExChange.fdata.rboCheck;
  if ExChange.isCheck then
  begin
    ExUser := getExUser;
    if ExUser = nil then
    begin
      SendClass.SendChatMessage('交易失败', SAY_COLOR_SYSTEM);
      ExChangeClose;
      exit;
    end;

    if ExUser.ExChange.isCheck then
    begin
            //测试 双 物品 是否有
      if (ExChangeDataIsCheck = FALSE)
        or (ExUser.ExChangeDataIsCheck = FALSE) then
      begin
        SendClass.SendChatMessage('交易失败', SAY_COLOR_SYSTEM);
        ExUser.SendClass.SendChatMessage('交易失败', SAY_COLOR_SYSTEM);
        ExChangeClose;
        exit;
      end;
            //ExChangedata 增加到 对方 检查
      if (HaveItemClass.SpaceCount < ExUser.ExChange.count)
        or (ExUser.HaveItemClass.SpaceCount < ExChange.count) then
      begin
        SendClass.SendChatMessage('交易失败', SAY_COLOR_SYSTEM);
        ExUser.SendClass.SendChatMessage('交易失败', SAY_COLOR_SYSTEM);
        ExChangeClose;
        exit;
      end;
            //增加到对方
      AddExChangeData(@ExUser.BasicData, @BasicData, @ExUser.ExChange.fdata);
      ExUser.AddExChangeData(@BasicData, @ExUser.BasicData, @ExChange.fdata);
            //删除
      DelExChangeData(@BasicData, @ExChange.fdata);
      ExUser.DelExChangeData(@ExUser.BasicData, @ExUser.ExChange.fdata);
      SendClass.SendChatMessage('交易成功', SAY_COLOR_SYSTEM);
      ExUser.SendClass.SendChatMessage('交易成功', SAY_COLOR_SYSTEM);
      ExChangeClose;

      exit;
    end;
  end;

  ExChangeUPDATE;

end;

function TUser.IsMenuSay(asay: string): boolean;
var
  NPCSAY: PTSNPCSAY;
  str: string;
begin
  result := false;
  if length(asay) > 20 then exit;

  if pos(asay, MenuSayText) > 0 then
    result := true;
end;

procedure TUser.MessageProcessExChange(var code: TWordComData);
var
  i, n: integer;
  akey, acount: integer;
  ExUser: tuser;
begin

  i := 1;
  n := WordComData_GETbyte(Code, i);

  case n of
    ExChange_CANCEL: //点 交易  取消
      begin
        if SpecialWindow <> WINDOW_EXCHANGE then exit;
        SpecialWindow := 0;
        if ExChange.isstate then
        begin
          SendClass.SendChatMessage('交易取消', SAY_COLOR_SYSTEM);
          ExUser := getExUser;
          if ExUser <> nil then
            ExUser.SendClass.SendChatMessage('交易取消', SAY_COLOR_SYSTEM);
          ExChangeClose;

        end;
      end;
    ExChange_ok:
      begin
        if SpecialWindow <> WINDOW_EXCHANGE then exit;
        ExChangeClick();
      end;
    ExChange_listAdd:
      begin
        if SpecialWindow <> WINDOW_EXCHANGE then exit;
        akey := WordComData_GETdword(Code, i);
        acount := WordComData_GETdword(Code, i);
        ExChangeItemAdd(akey, acount);
      end;
    ExChange_listdel:
      begin
        if SpecialWindow <> WINDOW_EXCHANGE then exit;
        akey := WordComData_GETdword(Code, i);
        ExChangeItemDel(akey);
      end;
    ExChange_msg:
      begin

      end;
    ExChange_msgOk:
      begin
        akey := WordComData_GETdword(Code, i);
        ExChangemsgOk(akey);
      end;
    ExChange_msgNO:
      begin
        akey := WordComData_GETdword(Code, i);
        ExChangemsgNO(akey);
      end;

  end;
end;

function TUser.ShowUPdataItemLevelWindow(aCaption: string; aComment: string; aShape, aImage: INTEGER): boolean;
begin
  Result := false;

  if SpecialWindow <> WINDOW_MENUSAY then
  begin
    SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
    exit;
  end;
  SpecialWindow := WINDOW_UPdateItemLevel;
  SendClass.SendShowSpecialWindow(WINDOW_UPdateItemLevel, aCaption, aComment, aShape, aImage, integer(HaveItemClass.LockedPass));
  Result := true;
end;

function TUser.ShowUPdataItemSettingWindow(aCaption: string; aComment: string; aShape, aImage: INTEGER): boolean;
begin
  Result := false;

  if SpecialWindow <> WINDOW_MENUSAY then
  begin
    SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
    exit;
  end;
  SpecialWindow := WINDOW_UPdateItemSetting;
  SendClass.SendShowSpecialWindow(WINDOW_UPdateItemSetting, aCaption, aComment, aShape, aImage, integer(HaveItemClass.LockedPass));
  Result := true;
end;

function TUser.ShowUPdataItemSettingDelWindow(aCaption: string; aComment: string; aShape, aImage: INTEGER): boolean;
begin
  Result := false;

  if SpecialWindow <> WINDOW_MENUSAY then
  begin
    SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
    exit;
  end;
  SpecialWindow := WINDOW_UPdateItemSetting_del;
  SendClass.SendShowSpecialWindow(WINDOW_UPdateItemSetting_del, aCaption, aComment, aShape, aImage, integer(HaveItemClass.LockedPass));
  Result := true;
end;

procedure TUser.MessageProcessEmporia(var code: TWordComData); //商城
var
  aitemcount, i, n, aitemGold: integer;
  aitemname: string;
  tempitem, tempadditem: TItemData;
  str: string;
  temp: TWordComData;
  pp: pTEmporiadata;
  procedure sendEmporiaaResult(atype, aid: byte);
  begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, SM_Emporia);
    WordComData_ADDbyte(temp, atype);
    WordComData_ADDbyte(temp, aid);

    SendClass.SendData(temp);
  end;
begin

  i := 1;
  n := WordComData_GETbyte(Code, i);
  case n of
    Emporia_Windows_close:
      begin
        if SpecialWindow <> WINDOW_Emporia then exit;
        SpecialWindow := 0;
      end;
    Emporia_showForm:
      begin
        if SpecialWindow <> 0 then
        begin
          SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
          exit;
        end;
        SpecialWindow := WINDOW_Emporia;
        SendClass.SendShowSpecialWindow(WINDOW_Emporia, '', '', 0, 0, integer(HaveItemClass.LockedPass));

      end;
    Emporia_BUY:
      begin
        if SpecialWindow <> WINDOW_Emporia then exit;
        aitemname := WordComData_GETstring(Code, i);
        aitemcount := WordComData_GETdword(Code, i);

        if (aitemcount < 0) or (aitemcount > 1000) then
        begin //数量 超范围
          sendEmporiaaResult(Emporia_BUY, 1);
          exit;
        end;
        if aitemname = '' then
        begin //名字空
          sendEmporiaaResult(Emporia_BUY, 2);
          exit;
        end;
        pp := EmporiaClass.get(aitemname);
        if pp = nil then
        begin //物品 没有
          sendEmporiaaResult(Emporia_BUY, 3);
          exit;
        end;
        aitemGold := pp.price * aitemcount; //【元宝】数量
        aitemcount := aitemcount * pp.num; //物品数量
        if ItemClass.GetItemData(aitemname, tempitem) = false then
        begin //物品 错误
          sendEmporiaaResult(Emporia_BUY, 4);
          exit;
        end;

        if tempitem.rboDouble = false then
        begin //物品 限制购买1个。
          if aitemcount > 1 then
          begin
            sendEmporiaaResult(Emporia_BUY, 5);
            exit;
          end;
        end;

        if HaveItemClass.GET_GOLD_Money < aitemGold then
        begin //【元宝】 不够
          sendEmporiaaResult(Emporia_BUY, 6);
          exit;
        end;
        if HaveItemClass.IsSpace = false then
        begin //背包 没空位
          sendEmporiaaResult(Emporia_BUY, 7);
          exit;
        end;

        HaveItemClass.affair(hicaStart);
                //扣【元宝】
        if HaveItemClass.DEL_GOLD_Money(aitemGold) = false then
        begin
          HaveItemClass.affair(hicaRoll_back);
          sendEmporiaaResult(Emporia_BUY, 8);
          exit;
        end;
                //增加物品
        tempitem.rCount := aitemcount;

                //打编号
        NewItemSet(_nist_Not_property, tempitem);
        if HaveItemClass.AddItem(@tempitem) = false then
        begin //发放物品失败
          HaveItemClass.affair(hicaRoll_back);
          sendEmporiaaResult(Emporia_BUY, 8);
          exit;
        end;
                //购买成功
        sendEmporiaaResult(Emporia_BUY, 100);
      end;
  end;
end;



procedure TUser.Booth_Edit_Close;
var
  aSubData: TSubData;
begin
  if SpecialWindow <> WINDOW_Booth_edit then
  begin
    SendClass.SendChatMessage('不是摊位窗口', SAY_COLOR_SYSTEM);
    exit;
  end;
  SpecialWindow := 0;
  if Boothclass <> nil then Boothclass.Free;
  Boothclass := nil;
  if BasicData.rbooth then
  begin
    BasicData.rbooth := false;
    SendLocalMessage(NOTARGETPHONE, FM_BOOTH, BasicData, aSubData);
  end;
  SendClass.SendBooth_edit_windows_close;
end;

procedure TUser.Booth_Edit_Open;
begin
  if SpecialWindow <> 0 then
  begin
    SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
    exit;
  end;
  SpecialWindow := WINDOW_Booth_edit;
  if Boothclass = nil then
    Boothclass := TBoothDataClass.Create(SendClass, HaveItemClass);
  Boothclass.clear;
  BasicData.rbooth := false;
  SendClass.SendBooth_edit_windows_open;
end;

procedure TUser.Booth_User_Close;
begin
  if SpecialWindow <> WINDOW_Booth_user then
  begin
    SendClass.SendChatMessage('不是摊位窗口', SAY_COLOR_SYSTEM);
    exit;
  end;
  SpecialWindow := 0;
  BasicData.rbooth := false;
  SendClass.SendBooth_user_windows_close;
end;

procedure TUser.Booth_User_Open(aname: string);
var
  tempuser: tuser;
begin
  if SpecialWindow <> 0 then
  begin
    SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
    exit;
  end;
  tempuser := TUser(GetViewObjectByName(aname, RACE_HUMAN));
  if tempuser = nil then
  begin
    SendClass.SendChatMessage('摊主不存在!', SAY_COLOR_SYSTEM);
    exit;
  end;
  if tempuser.Boothclass = nil then
  begin
    SendClass.SendChatMessage('摊主没有摆摊!', SAY_COLOR_SYSTEM);
    exit;
  end;
  if tempuser.Boothclass.state = false then
  begin
    SendClass.SendChatMessage('摊主没有摆摊!', SAY_COLOR_SYSTEM);
    exit;
  end;
  booth_name := aname;
  SpecialWindow := WINDOW_Booth_user;
  SendClass.SendBooth_user_windows_open(tempuser.Boothclass.boothname);
  tempuser.Boothclass.send_userall(SendClass);
end;

procedure TUser.MessageProcessBooth(var code: TWordComData);
var
  i, aUserhavekey, akey, acount, aprice: integer;
  n: integer;
  str: string;
  aBooth: PTBoothData;
  aboothdata: TBoothShopData;
  pbooth: pTBoothShopData;
  tempuser: tuser;
  aitem_booth, aitem_gold, aitem: titemdata;
  aSubData: TSubData;
begin
  i := 1;
  n := WordComData_GETbyte(Code, i);
  if SpecialWindow = 0 then
  begin
    case n of
      Booth_edit_Windows_Open:
        begin
        //改为由脚本调用
//          Booth_Edit_Open;
        end;
      Booth_user_Windows_Open:
        begin
          str := WordComData_GETString(Code, i);
          Booth_User_Open(str);
        end;
    end;
    exit;
  end;
  if SpecialWindow = WINDOW_Booth_edit then
  begin
    case n of
      Booth_edit_Windows_Close:
        begin
          Booth_Edit_Close;
        end;
      Booth_edit_Begin:
        begin
          if Boothclass = nil then
          begin
            SendClass.SendChatMessage('摆摊失败', SAY_COLOR_SYSTEM);
            SendClass.SendBooth_edit_end;
            exit;
          end;
          Boothclass.clear;
          aBooth := @code.Data;

          Boothclass.boothname := aBooth.rBoothName; //摊位名字
          for i := 0 to high(aBooth.BuyArr) do
          begin
            aboothdata.rHaveItemKey := aBooth.BuyArr[i].rKey;
            aboothdata.rPrice := aBooth.BuyArr[i].rPrice;
            aboothdata.rCount := aBooth.BuyArr[i].rCount;
            if aBooth.BuyArr[i].rKey = 255 then aboothdata.rstate := false
            else aboothdata.rstate := true;
            if Boothclass.BuyAdd(i, aboothdata) = false then
            begin
              SendClass.SendChatMessage('摆摊失败_收购出错!', SAY_COLOR_SYSTEM);
              SendClass.SendBooth_edit_end;
              exit;
            end;
          end;

          for i := 0 to high(aBooth.SellArr) do
          begin
            aboothdata.rHaveItemKey := aBooth.SellArr[i].rKey;
            aboothdata.rPrice := aBooth.SellArr[i].rPrice;
            aboothdata.rCount := aBooth.SellArr[i].rCount;
            if aBooth.SellArr[i].rKey = 255 then aboothdata.rstate := false
            else aboothdata.rstate := true;
            if Boothclass.SellAdd(i, aboothdata) = false then
            begin
              SendClass.SendChatMessage('摆摊失败_出售出错!', SAY_COLOR_SYSTEM);
              SendClass.SendBooth_edit_end;
              exit;
            end;
          end;
          if Boothclass.CHECK(str) = false then
          begin
            SendClass.SendChatMessage('摆摊失败!' + str, SAY_COLOR_SYSTEM);
            SendClass.SendBooth_edit_end;
            exit;
          end;
          Boothclass.state := true;
          BasicData.rbooth := true;
          SendLocalMessage(NOTARGETPHONE, FM_BOOTH, BasicData, aSubData);
          SendClass.SendBooth_edit_begin;
          SendClass.SendChatMessage('摆摊成功', SAY_COLOR_SYSTEM);
        end;
      Booth_edit_End:
        begin

          Boothclass.clear;

          SendClass.SendBooth_edit_end;
          BasicData.rbooth := false;
          SendLocalMessage(NOTARGETPHONE, FM_BOOTH, BasicData, aSubData);
        end;
    end;

    exit;
  end;
  if SpecialWindow = WINDOW_Booth_user then
  begin
    case n of

      Booth_user_Windows_Close:
        begin
          Booth_User_Close;
        end;
      Booth_user_Buy_OK:
        begin
          akey := WordComData_GETdword(Code, i);
          acount := WordComData_GETdword(Code, i);

          tempuser := tuser(GetViewObjectByName(booth_name, RACE_HUMAN));
          if tempuser = nil then
          begin
            SendClass.SendChatMessage('摊主不在可视范围!', SAY_COLOR_SYSTEM);
            exit;
          end;

          if tempuser.Boothclass = nil then
          begin
            SendClass.SendChatMessage('摊主没有摆摊!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if tempuser.Boothclass.state = false then
          begin
            SendClass.SendChatMessage('摊主没有摆摊!', SAY_COLOR_SYSTEM);
            exit;
          end;
          pbooth := tempuser.Boothclass.SellGet(akey);
          if pbooth = nil then
          begin
               //没有 对应物品
            SendClass.SendChatMessage('物品不存在!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if acount > pbooth.rCount then
          begin
              //摊位数量不 够
            SendClass.SendChatMessage('购买数量大于出售数量!', SAY_COLOR_SYSTEM);
            exit;
          end;

          if tempuser.HaveItemClass.ViewItem(pbooth.rHaveItemKey, @aitem_booth) = false then
          begin
            SendClass.SendChatMessage('该物品不存在!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if acount > aitem_booth.rCount then
          begin
              //背包数量不 够
            SendClass.SendChatMessage('摊主背包内的该物品数量不足!', SAY_COLOR_SYSTEM);
            exit;
          end;

          aprice := pbooth.rPrice * acount;
          if HaveItemClass.ViewItemName('钱币', @aitem_gold) = false then
          begin
            SendClass.SendChatMessage('没有钱币!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if aitem_gold.rCount < aprice then
          begin
            //钱币 不够
            SendClass.SendChatMessage('钱币不够!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if HaveItemClass.IsSpace = false then
          begin
            SendClass.SendChatMessage('背包空间不足!', SAY_COLOR_SYSTEM);
            exit;
          end;
          ///////////////////////////////
          //          开始交易
          tempuser.HaveItemClass.affair(hicaStart);
          tempuser.Boothclass.affair(hicaStart);
          HaveItemClass.affair(hicaStart);
          //扣除 摊位 物品
          if tempuser.HaveItemClass.DeletekeyItem(pbooth.rHaveItemKey, acount) = false then
          begin
            tempuser.HaveItemClass.affair(hicaRoll_back);
            tempuser.Boothclass.affair(hicaRoll_back);
            HaveItemClass.affair(hicaRoll_back);
            FrmMain.WriteLogInfo('摊位回滚事件记录1:' + tempuser.name + ',' + IntToStr(pbooth.rHaveItemKey) + ',' + aitem.rName + ',' + IntToStr(acount));
            exit;
          end;
          //扣 摊位 人 背包 物品
          if tempuser.Boothclass.SellDel(akey, acount, SendClass) = false then
          begin
            tempuser.HaveItemClass.affair(hicaRoll_back);
            tempuser.Boothclass.affair(hicaRoll_back);
            HaveItemClass.affair(hicaRoll_back);
            FrmMain.WriteLogInfo('摊位回滚事件记录2:' + tempuser.name + ',' + IntToStr(pbooth.rHaveItemKey) + ',' + aitem.rName + ',' + IntToStr(acount));
            exit;
          end;
          //扣除 顾客 钱币
          aitem_gold.rCount := aprice;
          if HaveItemClass.DeleteItem(@aitem_gold) = false then
          begin
            tempuser.HaveItemClass.affair(hicaRoll_back);
            tempuser.Boothclass.affair(hicaRoll_back);
            HaveItemClass.affair(hicaRoll_back);
            FrmMain.WriteLogInfo('摊位回滚事件记录3:' + name + ',' + IntToStr(pbooth.rHaveItemKey) + ',' + aitem_gold.rName + ',' + IntToStr(acount));
            exit;
          end;

          //增加顾客 物品
          aitem_booth.rCount := acount;
          if HaveItemClass.AddItem(@aitem_booth) = false then
          begin
            tempuser.HaveItemClass.affair(hicaRoll_back);
            tempuser.Boothclass.affair(hicaRoll_back);
            HaveItemClass.affair(hicaRoll_back);
            FrmMain.WriteLogInfo('摊位回滚事件记录4:' + name + ',' + IntToStr(pbooth.rHaveItemKey) + ',' + aitem_booth.rName + ',' + IntToStr(acount));
            exit;
          end;
          //增加 摊位 人 钱币
          aitem_gold.rCount := aprice;
          if tempuser.HaveItemClass.AddItem(@aitem_gold) = false then
          begin
            tempuser.HaveItemClass.affair(hicaRoll_back);
            tempuser.Boothclass.affair(hicaRoll_back);
            HaveItemClass.affair(hicaRoll_back);
            FrmMain.WriteLogInfo('摊位回滚事件记录5:' + tempuser.name + ',' + IntToStr(pbooth.rHaveItemKey) + ',' + aitem_gold.rName + ',' + IntToStr(acount));
            exit;
          end;
          //顾客增加物品

          //摊位人增加钱币
          tempuser.HaveItemClass.affair(hicaConfirm);
          tempuser.Boothclass.affair(hicaConfirm);
          HaveItemClass.affair(hicaConfirm);
          logItemMoveInfo('摊位背包增加_玩家购买', @BasicData, @tempuser, aitem_booth, Manager.ServerId);
          SendClass.SendChatMessage('购买成功', SAY_COLOR_SYSTEM);
        end;
      Booth_user_Sell_OK:
        begin
          akey := WordComData_GETdword(Code, i);
          acount := WordComData_GETdword(Code, i);
          aUserhavekey := WordComData_GETdword(Code, i);

          tempuser := tuser(GetViewObjectByName(booth_name, RACE_HUMAN));
          if tempuser = nil then
          begin
            SendClass.SendChatMessage('摊主不在可视范围!', SAY_COLOR_SYSTEM);
            exit;
          end;

          if tempuser.Boothclass = nil then
          begin
            SendClass.SendChatMessage('摊主没有摆摊!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if tempuser.Boothclass.state = false then
          begin
            SendClass.SendChatMessage('摊主没有摆摊!', SAY_COLOR_SYSTEM);
            exit;
          end;
          pbooth := tempuser.Boothclass.BuyGet(akey);
          if pbooth = nil then
          begin
               //摊主没有 对应物品
            SendClass.SendChatMessage('摊主不收购此物品!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if acount > pbooth.rCount then
          begin
              //摊主数量不 够
            SendClass.SendChatMessage('你输入的数量大于摊主收购的数量!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if tempuser.HaveItemClass.ViewItem(pbooth.rHaveItemKey, @aitem_booth) = false then
          begin
            SendClass.SendChatMessage('摊主没有该物品!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if aitem_booth.rCount <= 0 then
          begin
              //摊主背包数量至少要1个
            SendClass.SendChatMessage('摊主没有该物品!', SAY_COLOR_SYSTEM);
            exit;
          end;

          aprice := pbooth.rPrice * acount;
          if tempuser.HaveItemClass.ViewItemName('钱币', @aitem_gold) = false then
          begin
            SendClass.SendChatMessage('摊主没有钱币!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if aitem_gold.rCount < aprice then
          begin
            //摊主钱币 不够
            SendClass.SendChatMessage('摊主钱币不够!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if tempuser.HaveItemClass.IsSpace = false then
          begin
            //摊主 背包 至少要1个空位
            SendClass.SendChatMessage('摊主背包空间不足!', SAY_COLOR_SYSTEM);
            exit;
          end;
          //顾客 物品
          if HaveItemClass.ViewItem(aUserhavekey, @aitem) = false then
          begin
            SendClass.SendChatMessage('没有该物品可以出售!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if aitem_booth.rName <> aitem.rName then
          begin
            SendClass.SendChatMessage('出售物品不匹配!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if aitem.rCount < acount then
          begin
              //顾客 背包 物品  数量不够
            SendClass.SendChatMessage('你没有这么多该物品!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if HaveItemClass.IsSpace = false then
          begin
            //顾客 背包 至少要1个空位
            SendClass.SendChatMessage('你的背包空间不足!', SAY_COLOR_SYSTEM);
            exit;
          end;

          ///////////////////////////////
          //          开始交易
          tempuser.HaveItemClass.affair(hicaStart);
          tempuser.Boothclass.affair(hicaStart);
          HaveItemClass.affair(hicaStart);
          //扣除 顾客 物品
          aitem.rCount := acount;
          if HaveItemClass.DeleteItem(@aitem) = false then
          begin
            tempuser.HaveItemClass.affair(hicaRoll_back);
            tempuser.Boothclass.affair(hicaRoll_back);
            HaveItemClass.affair(hicaRoll_back);
            FrmMain.WriteLogInfo('摊位回滚事件记录6:' + name + ',' + aitem.rName + ',' + IntToStr(pbooth.rHaveItemKey) + ',' + IntToStr(acount));
            exit;
          end;
          //增加 摊主 背包 物品
          aitem.rCount := acount;
          if tempuser.HaveItemClass.AddItem(@aitem) = false then
          begin
            tempuser.HaveItemClass.affair(hicaRoll_back);
            tempuser.Boothclass.affair(hicaRoll_back);
            HaveItemClass.affair(hicaRoll_back);
            FrmMain.WriteLogInfo('摊位回滚事件记录7:' + tempuser.name + ',' + IntToStr(pbooth.rHaveItemKey) + ',' + aitem.rName + ',' + IntToStr(acount));
            exit;
          end;

          //扣 摊位  物品  数量
          if tempuser.Boothclass.BuyDel(akey, acount, SendClass) = false then
          begin
            tempuser.HaveItemClass.affair(hicaRoll_back);
            tempuser.Boothclass.affair(hicaRoll_back);
            HaveItemClass.affair(hicaRoll_back);
            FrmMain.WriteLogInfo('摊位回滚事件记录8:' + tempuser.name + ',' + IntToStr(pbooth.rHaveItemKey) + ',' + aitem.rName + ',' + IntToStr(acount));
            exit;
          end;
          //扣除 摊主 背包 钱币
          aitem_gold.rCount := aprice;
          if tempuser.HaveItemClass.DeleteItem(@aitem_gold) = false then
          begin
            tempuser.HaveItemClass.affair(hicaRoll_back);
            tempuser.Boothclass.affair(hicaRoll_back);
            HaveItemClass.affair(hicaRoll_back);
            FrmMain.WriteLogInfo('摊位回滚事件记录9:' + tempuser.name + ',' + IntToStr(pbooth.rHaveItemKey) + ',' + aitem_gold.rName + ',' + IntToStr(acount));
            exit;
          end;
          //增加 顾客 钱币
          aitem_gold.rCount := aprice;
          if HaveItemClass.AddItem(@aitem_gold) = false then
          begin
            tempuser.HaveItemClass.affair(hicaRoll_back);
            tempuser.Boothclass.affair(hicaRoll_back);
            HaveItemClass.affair(hicaRoll_back);
            FrmMain.WriteLogInfo('摊位回滚事件记录10:' + name + ',' + IntToStr(pbooth.rHaveItemKey) + ',' + aitem_gold.rName + ',' + IntToStr(acount));
            exit;
          end;
           //顾客增加钱币
          logItemMoveInfo('摊位背包增加_玩家出售', @BasicData, @tempuser, aitem_gold, Manager.ServerId);
          //摊位人增加物品
          logItemMoveInfo('摊位背包增加_玩家出售', @tempuser, @BasicData, aitem_booth, Manager.ServerId);
          tempuser.HaveItemClass.affair(hicaConfirm);
          tempuser.Boothclass.affair(hicaConfirm);
          HaveItemClass.affair(hicaConfirm);

          SendClass.SendChatMessage('出售成功', SAY_COLOR_SYSTEM);
        end;
      Booth_user_Message:
        begin
          STR := WordComData_GETString(code, I);
          STR := name + ':' + STR;
          tempuser := tuser(GetViewObjectByName(booth_name, RACE_HUMAN));
          if tempuser = nil then
          begin
            SendClass.SendChatMessage('玩家不在可视范围内!', SAY_COLOR_SYSTEM);
            exit;
          end;

          if tempuser.Boothclass = nil then
          begin
            SendClass.SendChatMessage('玩家没有摆摊!', SAY_COLOR_SYSTEM);
            exit;
          end;
          if tempuser.Boothclass.state = false then
          begin
            SendClass.SendChatMessage('玩家没有摆摊!', SAY_COLOR_SYSTEM);
            exit;
          end;
          tempuser.SendClass.SendBooth_edit_Message(STR);
          SendClass.SendChatMessage('留言成功!', SAY_COLOR_SYSTEM);
        end;
    end;
    exit;
  end;



end;




procedure TUser.MessageProcessUPdataItem(var code: TWordComData); //装备 升级
var
  additemindex, i, n, j, akey, rlevel: integer;
  tempitem, tempadditem: TItemData;
  str: string;
  temp: TWordComData;
  pItemLevel: pItemDataUPdataLevel;
  tempLifeData: TLifeData;
  tempLifeData2: TLifeData;
  aupstate: boolean;
  procedure sendupdataResult(atype: byte; aid: byte);
  begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, SM_UPdataItem);
    WordComData_ADDbyte(temp, atype);
    WordComData_ADDbyte(temp, aid);

    SendClass.SendData(temp);
  end;

begin
 {
    case SpecialWindow of
        WINDOW_UPdateItemLevel:
            begin

                i := 1;
                n := WordComData_GETbyte(Code, i);
                case n of
                    UPdateItem_UPLevelselect:                                   //升级  选择
                        begin
                            if LockedPass then
                            begin
                                sendupdataResult(UPdateItem_UPLevelselect, 51);
                                exit;
                            end;
                            n := WordComData_GETbyte(Code, i);
                            if HaveItemClass.ViewItem(n, @tempitem) = false then
                            begin                                               //物品不存在
                                sendupdataResult(UPdateItem_UPLevelselect, 2);
                                exit;
                            end;

                            if tempitem.boUpgrade = false then
                            begin                                               //不可升级
                                sendupdataResult(UPdateItem_UPLevelselect, 3);
                                exit;
                            end;
                            if tempitem.rlockState <> 0 then
                            begin                                               //锁定状态
                                sendupdataResult(UPdateItem_UPLevelselect, 50);
                                exit;
                            end;
                            if tempitem.rSmithingLevel >= tempitem.MaxUpgrade then
                            begin                                               //已经达到满了
                                sendupdataResult(UPdateItem_UPLevelselect, 4);
                                exit;
                            end;

                            pItemLevel := ItemUPLevelClass.get(tempitem.rSmithingLevel);
                            if pItemLevel = nil then
                            begin
                                //错误
                                sendupdataResult(UPdateItem_UPLevelselect, 200);
                                exit;
                            end;

                            temp.Size := 0;
                            WordComData_ADDbyte(temp, SM_UPdataItem);
                            WordComData_ADDbyte(temp, UPdateItem_UPLevelselect);
                            WordComData_ADDbyte(temp, 1);

                            WordComData_ADDdword(temp, pItemLevel.rmoney);
                            WordComData_ADDdword(temp, pItemLevel.rhuanxian);
                            WordComData_ADDdword(temp, pItemLevel.rPrestige);
                            WordComData_ADDdword(temp, pItemLevel.rBijou);
                            SendClass.SendData(temp);
                        end;

                    UPdateItem_UPLevel:                                         //升级
                        begin
                            if LockedPass then
                            begin
                                sendupdataResult(UPdateItem_UPLevel, 51);
                                exit;
                            end;
                            akey := WordComData_GETbyte(Code, i);
                            if HaveItemClass.ViewItem(akey, @tempitem) = false then
                            begin                                               //物品不存在
                                sendupdataResult(UPdateItem_UPLevel, 2);
                                exit;
                            end;
                            rlevel := tempitem.rSmithingLevel;

                            if tempitem.rlockState <> 0 then
                            begin                                               //锁定状态
                                sendupdataResult(UPdateItem_UPLevel, 50);
                                exit;
                            end;
                            if tempitem.boUpgrade = false then
                            begin                                               //不可升级
                                sendupdataResult(UPdateItem_UPLevel, 3);
                                exit;

                            end;
                            if tempitem.rSmithingLevel >= tempitem.MaxUpgrade then
                            begin                                               //已经达到满了
                                sendupdataResult(UPdateItem_UPLevel, 4);
                                exit;
                            end;

                            pItemLevel := ItemUPLevelClass.get(tempitem.rSmithingLevel);
                            if pItemLevel = nil then
                            begin
                                sendupdataResult(UPdateItem_UPLevelselect, 200);
                                exit;
                            end;
                            ////////////////////////////////////////////////////
                            //               需要物品检查
                            n := HaveItemClass.FindKindItem(ITEM_KIND_Level);
                            if n = -1 then
                            begin                                               //没有需要的幻仙宝石
                                sendupdataResult(UPdateItem_UPLevel, 5);
                                exit;
                            end;

                            if HaveItemClass.HaveItemArr[n].rCount < pItemLevel.rhuanxian then
                            begin                                               //没有需要的幻仙宝石 数量不够
                                sendupdataResult(UPdateItem_UPLevel, 6);
                                exit;
                            end;

                            if AttribClass.prestige < pItemLevel.rPrestige then
                            begin                                               //荣誉不够
                                sendupdataResult(UPdateItem_UPLevel, 21);
                                exit;
                            end;

                            if HaveItemClass.ViewItemName(INI_GOLD, @tempitem) = false then
                            begin                                               //你没有金钱
                                sendupdataResult(UPdateItem_UPLevel, 7);
                                exit;
                            end;
                            if tempitem.rCount < pItemLevel.rmoney then
                            begin                                               //金钱不够
                                sendupdataResult(UPdateItem_UPLevel, 8);
                                exit;
                            end;

                            ////////////////////////////////////////////////////
                            //                 扣东西
                            HaveItemClass.affair(hicaStart);

                            //扣钱
                            tempitem.rCount := pItemLevel.rmoney;
                            if HaveItemClass.DeleteItem(@tempitem) = false then
                            begin
                                HaveItemClass.affair(hicaRoll_back);
                                sendupdataResult(UPdateItem_UPLevel, 9);
                                exit;
                            end;
                            //扣宝石
                            if HaveItemClass.DeletekeyItem(n, pItemLevel.rhuanxian) = false then
                            begin
                                HaveItemClass.affair(hicaRoll_back);
                                sendupdataResult(UPdateItem_UPLevel, 10);
                                exit;
                            end;
                            rlevel := HaveItemClass.HaveItemArr[akey].rSmithingLevel;
                            //////////////////////////////////////////////////////
                            //                 配置增加 属性表
                            fillchar(tempLifeData, sizeof(TLifeData), 0);
                            fillchar(tempLifeData2, sizeof(TLifeData), 0);
                            GatMix_MaxLifeData(tempLifeData, ItemClass.ItemUPdateLevelMin, ItemClass.ItemUPdateLevelMax); //随机 属性
                            if HaveItemClass.HaveItemArr[akey].rWearArr = ARR_WEAPON then //累加 属性
                                GatherLifeDataWEAPON(tempLifeData2, tempLifeData)
                            else GatherLifeDataNOTWEAPON(tempLifeData2, tempLifeData);

                            n := HaveItemClass.FindKindItem(ITEM_KIND_Level100);
                            if n = -1 then
                            begin                                               //一定 几率成功
                                aupstate := Random(2 + rlevel) = 1;
                            end else
                            begin                                               //100%成功
                                //扣 稳定 石头
                                if HaveItemClass.DeletekeyItem(n, pItemLevel.rBijou) = false then
                                begin
                                    HaveItemClass.affair(hicaRoll_back);
                                    sendupdataResult(UPdateItem_UPLevel, 22);
                                    exit;
                                end;
                                aupstate := TRUE;
                            end;

                            if HaveItemClass.UPdateItem_UPLevel(akey, tempLifeData2, aupstate) = false then //修改物品
                            begin
                                HaveItemClass.affair(hicaRoll_back);
                                sendupdataResult(UPdateItem_UPLevel, 11);
                                exit;
                            end;
                            if HaveItemClass.HaveItemArr[akey].rSmithingLevel > rlevel then
                                sendupdataResult(UPdateItem_UPLevel, 100)
                            else
                                sendupdataResult(UPdateItem_UPLevel, 101);
                            HaveItemClass.affair(hicaConfirm);
                        end;

                    UPdateItem_Windows_close:
                        begin
                            SpecialWindow := 0;
                            Npc := nil;

                        end;
                end;
            end;
        WINDOW_UPdateItemSetting:
            begin
                i := 1;
                n := WordComData_GETbyte(Code, i);
                case n of

                    UPdateItem_Settingselect:                                   //镶嵌 宝石   选择
                        begin
                            if LockedPass then
                            begin
                                sendupdataResult(UPdateItem_Settingselect, 51);
                                exit;
                            end;
                            akey := WordComData_GETbyte(Code, i);
                            if HaveItemClass.ViewItem(akey, @tempitem) = false then
                            begin                                               //物品不存在
                                sendupdataResult(UPdateItem_Settingselect, 2);
                                exit;
                            end;
                            if tempitem.rlockState <> 0 then
                            begin                                               //锁定状态
                                sendupdataResult(UPdateItem_Settingselect, 50);
                                exit;
                            end;
                            if tempitem.rSetting.rsettingcount = 0 then
                            begin                                               //没孔
                                sendupdataResult(UPdateItem_Settingselect, 3);
                                exit;
                            end;
                            j := 0;
                            if (tempitem.rSetting.rsettingcount >= 1) and
                                (tempitem.rSetting.rsetting1 = '') then inc(j);
                            if (tempitem.rSetting.rsettingcount >= 2) and
                                (tempitem.rSetting.rsetting2 = '') then inc(j);
                            if (tempitem.rSetting.rsettingcount >= 3) and
                                (tempitem.rSetting.rsetting3 = '') then inc(j);
                            if (tempitem.rSetting.rsettingcount >= 4) and
                                (tempitem.rSetting.rsetting4 = '') then inc(j);
                            if j <= 0 then
                            begin                                               //无孔可镶嵌
                                sendupdataResult(UPdateItem_Settingselect, 4);
                                exit;
                            end;
                            temp.Size := 0;
                            WordComData_ADDbyte(temp, SM_UPdataItem);
                            WordComData_ADDbyte(temp, UPdateItem_Settingselect);
                            WordComData_ADDbyte(temp, 1);
                            WordComData_ADDdword(temp, (tempitem.rGrade + 1) * 10000);
                            SendClass.SendData(temp);
                        end;

                    UPdateItem_Setting:                                         //镶嵌 宝石
                        begin
                            if LockedPass then
                            begin
                                sendupdataResult(UPdateItem_Setting, 51);
                                exit;
                            end;
                            akey := WordComData_GETbyte(Code, i);
                            additemindex := WordComData_GETbyte(Code, i);
                            if HaveItemClass.ViewItem(akey, @tempitem) = false then
                            begin                                               //物品不存在
                                sendupdataResult(UPdateItem_Setting, 2);
                                exit;
                            end;
                            if tempitem.rlockState <> 0 then
                            begin                                               //锁定状态
                                sendupdataResult(UPdateItem_Setting, 50);
                                exit;
                            end;
                            if tempitem.rSetting.rsettingcount = 0 then
                            begin                                               //没孔
                                sendupdataResult(UPdateItem_Setting, 3);
                                exit;
                            end;
                            j := 0;
                            if (tempitem.rSetting.rsettingcount >= 1) and
                                (tempitem.rSetting.rsetting1 = '') then inc(j);
                            if (tempitem.rSetting.rsettingcount >= 2) and
                                (tempitem.rSetting.rsetting2 = '') then inc(j);
                            if (tempitem.rSetting.rsettingcount >= 3) and
                                (tempitem.rSetting.rsetting3 = '') then inc(j);
                            if (tempitem.rSetting.rsettingcount >= 4) and
                                (tempitem.rSetting.rsetting4 = '') then inc(j);
                            if j <= 0 then
                            begin                                               //无孔可镶嵌
                                sendupdataResult(UPdateItem_Setting, 4);
                                exit;
                            end;
                            //////////////////////////////////////////////////////
                            if HaveItemClass.ViewItem(additemindex, @tempadditem) = false then
                            begin                                               //宝石物品不存在
                                sendupdataResult(UPdateItem_Setting, 5);
                                exit;
                            end;
                            if tempadditem.rKind <> 121 then
                            begin                                               //宝石不符合要求
                                sendupdataResult(UPdateItem_Setting, 6);
                                exit;
                            end;
                            if tempadditem.rWearArr <> 100 then
                                if tempitem.rWearArr <> tempadditem.rWearArr then
                                begin                                           //宝石和装备不匹配
                                    sendupdataResult(UPdateItem_Setting, 6);
                                    exit;
                                end;
                            /////////////////////////////////////////////////////////
                            j := (tempitem.rGrade + 1) * 10000;
                            if HaveItemClass.ViewItemName(INI_GOLD, @tempitem) = false then
                            begin                                               //你没有金钱
                                sendupdataResult(UPdateItem_Setting, 7);
                                exit;
                            end;
                            if tempitem.rCount < j then
                            begin                                               //金钱不够
                                sendupdataResult(UPdateItem_Setting, 8);
                                exit;
                            end;
                            HaveItemClass.affair(hicaStart);

                            //扣钱
                            tempitem.rCount := j;
                            if HaveItemClass.DeleteItem(@tempitem) = false then
                            begin
                                HaveItemClass.affair(hicaRoll_back);
                                sendupdataResult(UPdateItem_Setting, 9);
                                exit;
                            end;

                            //修改物品
                            if HaveItemClass.UPdateItem_Setting(akey, additemindex) = false then
                            begin
                                HaveItemClass.affair(hicaRoll_back);
                                sendupdataResult(UPdateItem_Setting, 11);
                                exit;
                            end;
                            sendupdataResult(UPdateItem_Setting, 100);

                        end;

                    UPdateItem_Windows_close:
                        begin
                            SpecialWindow := 0;
                            Npc := nil;

                        end;
                end;
            end;
        WINDOW_UPdateItemSetting_del:
            begin
                i := 1;
                n := WordComData_GETbyte(Code, i);
                case n of

                    UPdateItem_Setting_delselect:                               //清除镶嵌 宝石  选择

                        begin
                            if LockedPass then
                            begin
                                sendupdataResult(UPdateItem_Setting_delselect, 51);
                                exit;
                            end;
                            akey := WordComData_GETbyte(Code, i);
                            if HaveItemClass.ViewItem(akey, @tempitem) = false then
                            begin                                               //物品不存在
                                sendupdataResult(UPdateItem_Setting_delselect, 2);
                                exit;
                            end;
                            if tempitem.rlockState <> 0 then
                            begin                                               //锁定状态
                                sendupdataResult(UPdateItem_Setting_delselect, 50);
                                exit;
                            end;
                            if tempitem.rSetting.rsettingcount = 0 then
                            begin                                               //没孔
                                sendupdataResult(UPdateItem_Setting_delselect, 3);
                                exit;
                            end;
                            if (tempitem.rSetting.rsetting1 = '')
                                and (tempitem.rSetting.rsetting2 = '')
                                and (tempitem.rSetting.rsetting3 = '')
                                and (tempitem.rSetting.rsetting4 = '') then
                            begin                                               //没宝石镶嵌 不需要清除
                                sendupdataResult(UPdateItem_Setting_delselect, 4);
                                exit;
                            end;

                            temp.Size := 0;
                            WordComData_ADDbyte(temp, SM_UPdataItem);
                            WordComData_ADDbyte(temp, UPdateItem_Setting_delselect);
                            WordComData_ADDbyte(temp, 1);
                            WordComData_ADDdword(temp, (tempitem.rGrade + 1) * 10000);
                            SendClass.SendData(temp);
                        end;

                    UPdateItem_Setting_del:                                     //清除镶嵌 宝石
                        begin
                            if LockedPass then
                            begin
                                sendupdataResult(UPdateItem_Setting_del, 51);
                                exit;
                            end;
                            akey := WordComData_GETbyte(Code, i);
                            if HaveItemClass.ViewItem(akey, @tempitem) = false then
                            begin                                               //物品不存在
                                sendupdataResult(UPdateItem_Setting_del, 2);
                                exit;
                            end;
                            if tempitem.rlockState <> 0 then
                            begin                                               //锁定状态
                                sendupdataResult(UPdateItem_Setting_del, 50);
                                exit;
                            end;
                            if tempitem.rSetting.rsettingcount = 0 then
                            begin                                               //没孔
                                sendupdataResult(UPdateItem_Setting_del, 3);
                                exit;
                            end;
                            if (tempitem.rSetting.rsetting1 = '')
                                and (tempitem.rSetting.rsetting2 = '')
                                and (tempitem.rSetting.rsetting3 = '')
                                and (tempitem.rSetting.rsetting4 = '') then
                            begin                                               //没宝石镶嵌 不需要清除
                                sendupdataResult(UPdateItem_Setting_del, 4);
                                exit;
                            end;
                            j := (tempitem.rGrade + 1) * 10000;
                            if HaveItemClass.ViewItemName(INI_GOLD, @tempitem) = false then
                            begin                                               //你没有金钱
                                sendupdataResult(UPdateItem_Setting_del, 7);
                                exit;
                            end;
                            if tempitem.rCount < j then
                            begin                                               //金钱不够
                                sendupdataResult(UPdateItem_Setting_del, 8);
                                exit;
                            end;
                            HaveItemClass.affair(hicaStart);

                            //扣钱
                            tempitem.rCount := j;
                            if HaveItemClass.DeleteItem(@tempitem) = false then
                            begin
                                HaveItemClass.affair(hicaRoll_back);
                                sendupdataResult(UPdateItem_Setting_del, 9);
                                exit;
                            end;

                            //修改物品
                            if HaveItemClass.UPdateItem_Setting_del(akey) = false then
                            begin
                                HaveItemClass.affair(hicaRoll_back);
                                sendupdataResult(UPdateItem_Setting_del, 11);
                                exit;
                            end;
                            sendupdataResult(UPdateItem_Setting_del, 100);
                        end;

                    UPdateItem_Windows_close:
                        begin
                            SpecialWindow := 0;
                            Npc := nil;

                        end;
                end;
            end;

    end;
  }
end;

procedure TUser.MessageProcessItemLog(var code: TWordComData);
var
  i, n: integer;
  aitemlogkey, acount, ahaveitemkey: integer;
begin

  i := 1;
  n := WordComData_GETbyte(Code, i);
  ahaveitemkey := WordComData_GETdword(Code, i);
  aitemlogkey := WordComData_GETdword(Code, i);
  acount := WordComData_GETdword(Code, i);

  case n of
    ITEMLOG_in:
      begin
        if SpecialWindow <> WINDOW_ITEMLOG then exit;
        HaveItemToItemlog(ahaveitemkey, aitemlogkey, acount);
      end;
    ITEMLOG_OUT:
      begin
        if SpecialWindow <> WINDOW_ITEMLOG then exit;
        ItemlogToHaveItem(ahaveitemkey, aitemlogkey, acount);
      end;
  end;
end;

function TUser.ItemExChangeDeleteItemKEY(aSource: pTBasicData; akey, acount: integer; aitem: ptitemdata): boolean;
begin
  result := HaveItemClass.DeletekeyItem(akey, acount);
  if result then
  begin
    aitem.rCount := acount;
    logItemMoveInfo('交易背包删除', aSource, nil, aitem^, Manager.ServerId);

  end;
end;

function TUser.QuestTempAdd(aindex, aAddCount, aAddMax: integer): boolean;
begin
  result := false;
  if (aindex < 0) or (aindex > high(Connector.CharData.QuesttempArr)) then exit;
  Connector.CharData.QuesttempArr[aindex] := Connector.CharData.QuesttempArr[aindex] + aAddCount;
  if Connector.CharData.QuesttempArr[aindex] < 0 then Connector.CharData.QuesttempArr[aindex] := 0;
  if Connector.CharData.QuesttempArr[aindex] > aAddMax then Connector.CharData.QuesttempArr[aindex] := aAddMax;
  SendClass.SendQuestTempArr(aindex);
  result := true;
end;




procedure TUser.ScriptAuction(aItem: TItemData);
begin
  CallScriptFunction('OnAuctionSell', [integer(Self), aItem.rViewName]);
end;

function TUser.ItemExChangeADDITEM(aSource, adest: pTBasicData; aitem: ptitemdata): boolean;
begin
  result := HaveItemClass.AddItem(aitem);
  if result then
    logItemMoveInfo('交易背包增加', aSource, adest, aitem^, Manager.ServerId);
end;

function TUser.ItemScripterDeleteItem(aitem: ptitemdata): boolean;
begin
  result := HaveItemClass.DeleteItem(aitem);
  if result then
    logItemMoveInfo('脚本背包删除', @BasicData, nil, aitem^, Manager.ServerId);
end;

function TUser.ItemScripterDeleteItemKey(akey, acount: integer): boolean;
var
  aitem: ptitemdata;
begin
  result := false;
  aitem := HaveItemClass.getViewItem(akey);
  if aitem = nil then exit;
  result := HaveItemClass.DeletekeyItem(akey, acount);
  if result then
    logItemMoveInfo('脚本背包KEY删除', @BasicData, nil, aitem^, Manager.ServerId);
end;

function TUser.ItemScripterADDITEM(aitem: ptitemdata): boolean;
begin
//    NewItemSet(_nist_all, aitem^);
  result := HaveItemClass.AddItem(aitem);
  if result then
  begin

    logItemMoveInfo('脚本背包增加', nil, @BasicData, aitem^, Manager.ServerId);
  end;
end;

function TUser.ItemAuctionDelKeyItem(akey, acount: integer; aitem: ptitemdata): boolean;
begin
  result := HaveItemClass.DeletekeyItem(akey, acount);
  if result then
    logItemMoveInfo('寄售背包删除', @BasicData, nil, aitem^, Manager.ServerId);
end;

function TUser.ItemAuctionDeleteItem(aitem: ptitemdata): boolean;
begin
  result := HaveItemClass.DeleteItem(aitem);
  if result then
    logItemMoveInfo('寄售背包删除', @BasicData, nil, aitem^, Manager.ServerId);
end;

function TUser.ItemAuctionADDITEM(aitem: ptitemdata): boolean;
begin
  result := HaveItemClass.AddItem(aitem);
  if result then
    logItemMoveInfo('寄售背包增加', nil, @BasicData, aitem^, Manager.ServerId);
end;

function TUser.ItemEmailDelKeyItem(akey, acount: integer; aitem: ptitemdata): boolean;
begin
  result := HaveItemClass.DeletekeyItem(akey, acount);
  if result then
    logItemMoveInfo('邮件背包删除', @BasicData, nil, aitem^, Manager.ServerId);
end;

function TUser.ItemEmailDeleteItem(aitem: ptitemdata): boolean;
begin
  result := HaveItemClass.DeleteItem(aitem);
  if result then
    logItemMoveInfo('邮件背包删除', @BasicData, nil, aitem^, Manager.ServerId);
end;

function TUser.ItemEmailADDITEM(aitem: ptitemdata): boolean;
begin
  result := HaveItemClass.AddItem(aitem);
  if result then
    logItemMoveInfo('邮件背包增加', nil, @BasicData, aitem^, Manager.ServerId);
end;

procedure TUser.ItemUserDel(akey, acount: integer; var aitem: titemdata); //使用背包物品
begin
  if HaveItemClass.DeleteKeyItem(akey, acount) then
  begin
    aitem.rCount := acount;
    logItemMoveInfo('使用背包删除', @BasicData, nil, aitem, Manager.ServerId);
  end;
end;


procedure TUser.MessageProcess(var code: TWordComData);
var
  CurTick, CurNetTick, NetTick: integer;
  i, ret, n, subkey: integer;
  boFlag: Boolean;
  MagicData: TMagicData;
  ItemData, tmpItemData: TItemData;
  xx, yy: word;
  str, iname: string;
  SubData: TSubData;
  pckey: PTCkey;
  pcHit: PTCHit;
  pcsay: PTCSay;
  pcMove: PTCMove;
  pcClick: PTCClick;
  PCdrink: PTCdrink;
  PCnpc: pTCNPC;
  pcWindowConfirm: PTCWindowConfirm;
  pcGuildMagicData: PTCGuildMagicData;
  pcDragDrop: PTCDragDrop;
  pcMouseEvent: PTCMouseEvent;
  pcNetState: PTCNetState;

  tmpBasicData: TBasicData;
  BObject: TBasicObject;
  ExUser: TUser;
  GuildObject: TGuildObject;
  pGuildSelfData: PTCreateGuildData;

  oldHitType: Byte;
  ComData: TWordComData;
  pgetcmd: pTGET_cmd;
  BasicCmd: pTBasicCmd;
  pskey: pTSkey;
  pPassEtc: pTCPassEtc;
  PSHailFellowbasic: PTSHailFellowbasic;
  pCGuild: pTCGuild;
  tempGuildObject: tGuildObject;
  pJobGradeData: pTJobGradeData;
begin
  pckey := @Code.Data;
  if NetPackLogName = name then
  begin
    frmLog.Memo1.Lines.Add('TUser.MessageProcess' + inttostr(pckey^.rmsg) + ':' + inttostr(code.Size));
  end;
  if (BasicData.Feature.rfeaturestate = wfs_die) then
    case pckey^.rmsg of
      CM_SAY, CM_MSay, CM_NETSTATE: ;
    else exit;
    end;


  CurTick := mmAnsTick;

  try
    case pckey^.rmsg of
      CM_Job:
        begin

          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          i := 1;
          n := WordComData_GETbyte(Code, i);
          case n of
            Job_create:
              begin
                if SpecialWindow <> 0 then
                begin
                  SendClass.SendChatMessage('生产的时候不能打开其他窗口。', SAY_COLOR_SYSTEM);
                  exit;
                end;
                str := WordComData_GETString(Code, i);
                if str = '' then
                begin
                  SendClass.SendChatMessage('制造检查错误！物品名字为空。', SAY_COLOR_SYSTEM);
                  exit;
                end;

                if ItemClass.GetItemData(str, ItemData) = false then
                begin
                  SendClass.SendChatMessage('制造检查错误！制造物品无效。', SAY_COLOR_SYSTEM);
                  exit;
                end;
                if ItemData.rName = '' then
                begin
                  SendClass.SendChatMessage('制造检查错误！制造物品名字=空。', SAY_COLOR_SYSTEM);
                  exit;
                end;
                if ItemData.rboJobDown = false then
                begin
                  SendClass.SendChatMessage('制造检查错误！不可制造物品。', SAY_COLOR_SYSTEM);
                  exit;
                end;
                                //是否有能力制造
                pJobGradeData := HaveMagicClass.JobgetJobGrade;
                if (HaveMagicClass.jobGetKind = 0) or (pJobGradeData = nil) then
                begin
                  SendClass.SendChatMessage('制造检查错误！你无职业技术。', SAY_COLOR_SYSTEM);
                  exit;
                end;
                if (ItemData.rjobKind <> HaveMagicClass.jobGetKind)
                  or (ItemData.rGrade > pJobGradeData.MaxItemGrade)
                  then
                begin
                  SendClass.SendChatMessage('制造检查错误！职业技术能力问题。', SAY_COLOR_SYSTEM);
                  exit;
                end;

                n := ItemData.rGrade - 1;
                if (n < 0) or (n > (high(pJobGradeData.GradeArr))) then
                begin
                  SendClass.SendChatMessage('制造检查错误！物品的品级超出范围。', SAY_COLOR_SYSTEM);
                  exit;
                end;
                n := pJobGradeData.GradeArr[n];

                                //背包空位置
                if HaveItemClass.IsSpace = false then
                begin
                  SendClass.SendChatMessage('制造检查错误！背包无空位。', SAY_COLOR_SYSTEM);
                  exit;
                end;
                                //检查材料
                boFlag := false;

                for i := 0 to high(ItemData.rMaterial.NameArr) do
                begin
                  if ItemData.rMaterial.NameArr[i] = '' then Break;
                  if HaveItemClass.ViewItemName(ItemData.rMaterial.NameArr[i], @tmpItemData) = FALSE then
                  begin
                    SendClass.SendChatMessage('制造检查错误！缺材料：' + ItemData.rMaterial.NameArr[i], SAY_COLOR_SYSTEM);
                    exit;
                  end;
                  if tmpItemData.rCount < ItemData.rMaterial.CountArr[i] then
                  begin
                    SendClass.SendChatMessage('制造检查错误！数量不够，材料：' + ItemData.rMaterial.NameArr[i], SAY_COLOR_SYSTEM);
                    exit;
                  end;
                  boFlag := true;
                end;
                if boFlag = false then
                begin
                  SendClass.SendChatMessage('制造检查错误！材料数量=0', SAY_COLOR_SYSTEM);
                  exit;
                end;
                //生产
                HaveItemClass.affair(hicaStart);
                               //扣材料
                for i := 0 to high(ItemData.rMaterial.NameArr) do
                begin
                  if ItemData.rMaterial.NameArr[i] = '' then Break;
                  tmpItemData.rName := ItemData.rMaterial.NameArr[i];
                  tmpItemData.rCount := ItemData.rMaterial.countArr[i];
                  if HaveItemClass.DeleteItem(@tmpItemData) = FALSE then
                  begin
                    HaveItemClass.affair(hicaRoll_back);
                    SendClass.SendChatMessage('制造错误！扣除材料出错误：' + ItemData.rMaterial.NameArr[i], SAY_COLOR_SYSTEM);
                    exit;
                  end;
                end;

                i := Random(100);
                if i > n then
                begin
                  SendClass.SendChatMessage('制造失败！', SAY_COLOR_SYSTEM);
                end else
                begin
                               //发物品
                  ItemData.rboBlueprint := false; //取消 图纸
                  NewItemSet(_nist_all, ItemData); //打编号，附加属性
                  ItemData.rCount := 1;
                  if ItemData.rboDouble = false then ItemData.rcreatename := BasicData.Name;
                  if HaveItemClass.AddItem(@ItemData) = false then
                  begin
                    HaveItemClass.affair(hicaRoll_back);
                    SendClass.SendChatMessage('制造错误！放新物品失败', SAY_COLOR_SYSTEM);
                    exit;
                  end;
                                //增加经验
                                   // n := ItemData.rGrade * ItemData.rGrade * 1000;

                                  //  HaveMagicClass.JobAddExp(n, GetLevelExp(pJobGradeData.EndLevel));
                  if ItemData.rGrade = pJobGradeData.MaxItemGrade then
                  begin
                                    //制造最高等级才增加经验
                    n := HaveMagicClass.jobGetlevel;
                    if n < pJobGradeData.EndLevel then
                    begin
                                        //等级没到最大限制才增加经验
                      n := n + 100;
                      if n > pJobGradeData.EndLevel then n := pJobGradeData.EndLevel;
                      HaveMagicClass.JobSetLevel(n);
                    end;
                  end;
                  SendClass.SendChatMessage('恭喜您！制造成功。', SAY_COLOR_SYSTEM);

                end;
                HaveItemClass.affair(hicaConfirm);
              end;
            Job_blueprint_Menu:
              begin
                HaveMagicClass.JObgetMenu;
              end;
          end;
        end;
      CM_Designation:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          i := 1;
          n := WordComData_GETbyte(Code, i);
          case n of
            Designation_user:
              begin
                str := WordComData_GETString(Code, i);
                DesignationClass.User(str);
              end;
            Designation_Del:
              begin
                str := WordComData_GETString(Code, i);
                DesignationClass.delName(str);
              end;
          end;

        end;
      CM_ItemInputWindows:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          i := 1;
          n := WordComData_GETbyte(Code, i);
          case n of
            ItemInputWindows_key:
              begin
                subkey := WordComData_GETbyte(Code, i);
                n := WordComData_GETDword(Code, i);
                HaveItemClass.setItemInputWindowsKey(subkey, n);
              end;
          end;

        end;
      CM_MSay: //@纸条
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;


          i := 1;
          iname := WordComData_GETString(code, i);
          str := WordComData_GETString(code, i);

          if iname = '' then exit;
          if iname = (BasicData.Name) then exit;

          if Manager.boPrison = true then
          begin
            SendClass.SendNUMSAY(numsay_13, SAY_COLOR_SYSTEM); //numsay_13     '在流放地里无法传送信息'
            exit;
          end;

          ExUser := UserList.GetUserPointer(iname);
          if ExUser = nil then
          begin
            SendClass.SendNUMSAY(numsay_17, SAY_COLOR_SYSTEM, iname); //  , '%s目前不在线上。'       //17  numsay_17
            exit;
          end else
          begin
            if ExUser.LetterCheck = true then
            begin
              ExUser.SendClass.SendMSay(name, str);
                            // SendClass.SendNUMSAY(numsay_25, SAY_COLOR_SYSTEM, iname); //'成功给%s 发送了一个纸条。'
            end else
            begin
              SendClass.SendNUMSAY(numsay_19, SAY_COLOR_SYSTEM, iname); //    , '%s目前为拒绝纸条状态。'                       //19  numsay_19
            end;
          end;
          exit;
        end;

      CM_UserObject:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;


          i := 1;
          n := WordComData_GETbyte(Code, i);
          case n of
            UserObject_WearItem:
              begin
                n := WordComData_GETdword(Code, i);
                SendLocalMessage(n, FM_UserWearItem, BasicData, SubData);
              end;
          end;

        end;
      CM_Emporia:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;


          MessageProcessEmporia(code);
        end;

      CM_PowerLevel:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;


          i := 1;
          n := WordComData_GETbyte(Code, i);
          case n of
            PowerLevel_ADD: PowerLeveladd;
            PowerLevel_DEC: PowerLeveldec;
          end;

        end;
      CM_UPdataItem:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;


          MessageProcessUPdataItem(code);
        end;
      CM_ExChange:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;


          MessageProcessExChange(CODE);
        end;
      CM_Booth:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          MessageProcessBooth(code);
        end;
      CM_ITEMLOG:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          MessageProcessItemLog(code);
        end;

      CM_Billboardcharts:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          i := 1;
          n := WordComData_GETbyte(Code, i);

          case n of
            Billboardcharts_Energy:
              begin
                n := WordComData_GETdword(Code, i);
                BillboardchartsEnergy.getList(n, self);
              end;
            Billboardcharts_Prestige:
              begin
                n := WordComData_GETdword(Code, i);
                BillboardchartsPrestige.getList(n, self);
              end;
          end;

        end;
      CM_Procession:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          i := 1;
          n := WordComData_GETbyte(Code, i);

          if uProcessionclass <> nil then
          begin
            tProcessionclass(uProcessionclass).MessageProcess(code, self);
          end else
          begin
            case n of

              Procession_ADDMsg:
                begin
                  ProcessionclassList.createProcessionclass(self);
                  if uProcessionclass <> nil then
                    tProcessionclass(uProcessionclass).MessageProcess(code, self);
                  exit;
                end;
              Procession_ADDMsgOk:
                begin
                  str := WordComData_GETstring(Code, i);
                  ExUser := UserList.GetUserPointer(STR);
                  if ExUser = nil then
                  begin

                  end else
                    if ExUser.uProcessionclass <> nil then
                      tProcessionclass(ExUser.uProcessionclass).MessageProcess(code, self);
                end;
              Procession_ADDMsgNO:
                begin
                  str := WordComData_GETstring(Code, i);
                  ExUser := UserList.GetUserPointer(STR);
                  if ExUser = nil then
                  begin

                  end else
                    if ExUser.uProcessionclass <> nil then
                      tProcessionclass(ExUser.uProcessionclass).MessageProcess(code, self);
                end;
            end;
          end;
        end;
      CM_Quest:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          i := 1;
          n := WordComData_GETbyte(Code, i);
          case n of
            Quest_GETlist:
              begin
                QuestMainList.userGetQuestList(self);
              end;
            Quest_GET:
              begin

              end;
            Quest_DEL:
              begin
                                { n := WordComData_GETdword(Code, i);
                                 //主线任务 是不可以取消
                                 //2009 5 6 废弃 任务取消指令
                                 if FSubCurrentQuestNo = n then
                                 begin
                                     FSubCurrentQuestNo := 0;
                                     FSubQueststep := 0;
                                 end;
                                 }

              end;
          end;
        end;
      CM_Auction:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          AuctionSystemClass.MessageProcess(code, self);
        end;
      CM_EMAIL:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;


          if aEmail = nil then
          begin
            exit;
          end;
          TEmailclass(aEmail).MessageProcess(code, self);

        end;
      CM_set_ok: //设置 相关
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          i := 1;
          n := WordComData_GETbyte(Code, i);
          case n of
            SET_OK_wearFD: //时装  外观
              begin
                if WearItemClass.Fashionable <> true then
                begin
                  WearItemClass.Fashionable := true;
                  WearItemClass.UPFeature;
                  SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                end;
              end;
            SET_OK_wear: //装备 外观
              begin
                if WearItemClass.Fashionable <> false then
                begin
                  WearItemClass.Fashionable := false;
                  WearItemClass.UPFeature;
                  SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                end;
              end;
            SET_OK_msg: ; //设置接收 白话 可以做更多设置
          end;

        end;

      CM_Guild: //门派 相关
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          pCGuild := @Code.Data;

          case pCGuild.rkey of
            GUILD_del_SubSysop_ic:
              begin
                if uGuildObject <> nil then
                begin
                  str := tGuildObject(uGuildObject).delSubSysop_ic(name);
                  if str <> '' then SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                end;
              end;
            GUILD_del_SubSysop:
              begin
                i := 2;
                str := WordComData_GETString(Code, i);
                if str = '' then exit;
                if uGuildObject <> nil then
                begin
                  str := tGuildObject(uGuildObject).delSubSysop(name, str);
                  if str <> '' then SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                end;
              end;
            GUILD_set_Sysop:
              begin
                i := 2;
                str := WordComData_GETString(Code, i);
                if str = '' then exit;
                if uGuildObject <> nil then
                begin
                  str := tGuildObject(uGuildObject).setSysop(name, str);
                  if str <> '' then SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                end;
              end;

            GUILD_set_SubSysop:
              begin
                i := 2;
                str := WordComData_GETString(Code, i);
                if str = '' then exit;
                if uGuildObject <> nil then
                begin
                  str := tGuildObject(uGuildObject).setSubSysop(name, str);
                  if str <> '' then SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                end;
              end;
            GUILD_noticeUPdate:
              begin
                str := GetWordString(pCGuild.rWordString);
                if uGuildObject <> nil then
                begin
                  str := tGuildObject(uGuildObject).SetGuildnotice(name, str);
                  if str <> '' then SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                end;
              end;
            GUILD_GradeNameUPDATE:
              begin
                i := 2;
                str := WordComData_GETString(Code, i);
                iname := WordComData_GETString(Code, i);
                if uGuildObject <> nil then
                begin
                  str := tGuildObject(uGuildObject).SetGradeName(name, str, iname);
                  if str <> '' then
                    SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                end;
              end;
            GUILD_del_i:
              begin
                if uGuildObject <> nil then
                begin
                  str := tGuildObject(uGuildObject).DelUser(name);
                  if str <> '' then
                    SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                end;
              end;
            GUILD_del:
              begin
                i := 2;
                str := WordComData_GETString(Code, i);
                if str = '' then exit;
                if uGuildObject <> nil then
                begin

                  str := tGuildObject(uGuildObject).DelUser_Force(name, str);
                  if str <> '' then
                    SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                end;
              end;
            GUILD_add: //收人
              begin
                i := 2;
                str := WordComData_GETString(Code, i);
                if uGuildObject <> nil then
                begin
                  str := tGuildObject(uGuildObject).AddUser(name, str);
                  if str <> '' then
                    SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                end;
              end;
            GUILD_list_addMsgOk:
              begin
                i := 2;
                str := WordComData_GETString(Code, i);
                GuildList.adduserMsgOk(str, self);

              end;
            GUILD_list_addMsgno:
              begin
                i := 2;
                str := WordComData_GETString(Code, i);
                GuildList.adduserMsgNo(str, self);
              end;
            GUILD_Create_name:
              begin
                GuildCreateName(Code);
              end;
          end;

        end;
      CM_HailFellow: //好友
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          if ahailfellow = nil then exit;
          PSHailFellowbasic := @Code.Data;
          str := (PSHailFellowbasic.rName);
          case PSHailFellowbasic.rkey of
            HailFellow_ADD: //增加好友
              begin
                str := thailfellow(ahailfellow).ADD(str);
                SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                exit;
              end;
            HailFellow_DEL: //删除
              begin
                str := thailfellow(ahailfellow).del(str);
                SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                exit;
              end;
            HailFellow_Message_ADD_OK: //被人 增加 回答 OK
              begin
                thailfellow(ahailfellow).ADDMsgOK(str);
                exit;
              end;
            HailFellow_Message_ADD_NO: //被人 增加 回答 NO
              begin
                thailfellow(ahailfellow).ADDMsgNo(str);
                exit;
              end;
          end;

        end;
      CM_ShowPassWindows: //设置 密码
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          pPassEtc := @Code.Data;
          str := (pPassEtc.rPass);
          case pPassEtc.rKEY of
            WINDOW_ShowPassWINDOW_Item:
              begin
                str := HaveItemClass.SetPassword(str);
                SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
              end;

            WINDOW_ShowPassWINDOW_ItemUnLock:
              begin
                str := HaveItemClass.FreePassword(str);
                SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
              end;
            WINDOW_ShowPassWINDOW_ItemUPDATE: ;
            WINDOW_ShowPassWINDOW_LogItem:
              begin
                str := ItemLog.SetPassword(str);
                SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
              end;
            WINDOW_ShowPassWINDOW_LogItemUnLock:
              begin
                str := ItemLog.FreePassword(str);
                SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
              end;
            WINDOW_ShowPassWINDOW_LogItemUPDATE: ;
            WINDOW_ShowPassWINDOW_GameExit: ;
            WINDOW_ShowPassWINDOW_Close: ;
          else exit;
                        //保证 不能识别 的窗口 不执行 关闭
          end;
          SpecialWindow := 0;
        end;
      CM_KEYf5f12SAVE: //热键
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          pskey := @Code.Data;
          move(pskey.rkey[0], Connector.CharData.KeyArr[0], 8);
          move(pskey.rkey2[0], Connector.CharData.ShortcutKeyArr[0], 8);

        end;
      CM_itempro: //物品 详细 资料
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          pgetcmd := @Code.Data;
          case pgetcmd.rKEY of
            itemprolock: HaveItemClass.lockkeyItem(pgetcmd^.rKEY2);
            itemproUNlock: HaveItemClass.UNlockkeyItem(pgetcmd^.rKEY2);
                        //  itemproGET:HaveItemClass.SendItemPro(pgetcmd^.rKEY2);
                        //  itemproGET_Magic:HaveMagicClass.GETSendMagic(pgetcmd^.rKEY2);
                       //   itemproGET_MagicBasic:HaveMagicClass.GETSendBasicMagic(pgetcmd^.rKEY2);
          end;
        end;
      CM_ItemText:
        begin
          i := 1;
          iname := WordComData_GETString(Code, i);
          str := ItemClass.getdesc(iname);
          if str <> '' then
            SendClass.sendItemText(iname, str);
        end;
      cm_get:
        begin
                    //获取 各种 信息 包
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          pgetcmd := @Code.Data;
          case pgetcmd.rKEY of
            GET_charattrib: //获取 自己 属性
              begin
                                //  SendClass.Sendcharattrib(AttribClass.AttribData, AttribClass.CurAttribData, LifeData);

              end;
            GET_MapObject:
              begin
                SendMapObject;
              end;
            Get_KEYf5f12: SendClass.SendKEYf5f12;
                        {  Get_ItemText:
                              begin
                                  case ItemTextType(pgetcmd.rKEY2) of
                                      ittWearItemText:
                                          begin
                                              if not WearItemClass.ViewItem(pgetcmd^.rKEY3, @ItemData) then exit;
                                              str := GetItemDataInfo(ItemData);
                                              SendClass.sendItemText(ittWearItemText, pgetcmd^.rKEY3, str);
                                          end;
                                      ittWearItemTextFD:
                                          begin
                                              if not WearItemClass.ViewItemFD(pgetcmd^.rKEY3, @ItemData) then exit;
                                              str := GetItemDataInfo(ItemData);
                                              SendClass.sendItemText(ittWearItemTextFD, pgetcmd^.rKEY3, str);
                                          end;
                                  end;
                              end;}
          else ;
          end;

        end;
      CM_MENUSAY: //npc  通用 菜单 交互 命令
        begin

          if SpecialWindow <> WINDOW_MENUSAY then exit;
          SpecialWindow := 0;
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          if MenuSayObjId = 0 then exit;

          i := 1;
          str := WordComData_GETString(Code, i);
          if str = '' then exit;
          str := copy(str, 1, 20);
          if IsMenuSAY(str) = false then exit;

          SubData.SubName := str;
          SendLocalMessage(MenuSayObjId, FM_MenuSAY, BasicData, SubData);
        end;
      CM_NPCTrade: //NPC  交易
        begin

          if SpecialWindow = 0 then exit;

          if MenuSayObjId = 0 then exit;
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          PCnpc := @Code.Data;
          case PCnpc^.rKEY of

            MenuFT_OK, MenuFT_Cancel, MenuFT_windowsclse:
              begin
                closeNPCSAYWindow;
                exit;
              end;
            MenuFT_BUY, MenuFT_SELL, MenuFT_UPdateItem_UPLevel, MenuFT_UPdateItem_Setting,
              MenuFT_UPdateItem_Setting_del:
              begin
                if HaveItemClass.LockedPass then
                begin
                  SendClass.SendChatMessage('有密码设定', SAY_COLOR_SYSTEM);
                  exit;
                end;
              end;

          end;
          BObject := GetViewObjectById(MenuSayObjId);
          if BObject = nil then
          begin
            closeNPCSAYWindow;
            exit;
          end;
          if BObject.BasicData.Feature.rrace <> RACE_NPC then
          begin
            closeNPCSAYWindow;
            exit;
          end;
          MOVE(Code.Data, SubData, CODE.Size);

          SendLocalMessage(MenuSayObjId, FM_NPC, BasicData, SubData);

        end;

      CM_MOUSEEVENT: // 付快胶 捞亥飘 贸府... 皋农肺...
        begin
          pcMouseEvent := @Code.data;
          str := Name + ',';
          for i := 0 to 10 - 1 do
          begin
            str := str + IntToStr(pcMouseEvent^.rEvent[i]) + ',';
          end;
          UdpSendMouseEvent(Str);

                    // 概农肺牢啊甫 眉农窍咯 蜡历狼 立加阑 辆丰矫挪促
          MacroChecker.AddMouseEvent(pcMouseEvent, CurTick);
          if MacroChecker.Check(Name) then
          begin
            boDeleteState := true;
            ConnectorList.CloseConnectByCharName(Name);
          end;
        end;
      CM_SELECTCOUNT:
        begin //得到 输入  数字
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          InputCountProcess(code);
        end;

      cm_InputOk:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          InputOkProcess(code);
        end;
      CM_INPUTSTRING2:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          InputStringProcess(Code);
        end;
      CM_INPUTSTRING:
        begin

          if CM_MessageTick[CM_INPUTSTRING] + 20 > mmAnsTick then exit;
          CM_MessageTick[CM_INPUTSTRING] := mmAnsTick;
          InputStringProcess(Code);
        end;
      CM_DRAGDROP:
        begin //物品 往来
          if CM_MessageTick[CM_DRAGDROP] + 20 > mmAnsTick then exit;
          CM_MessageTick[CM_DRAGDROP] := mmAnsTick;
          DragProcess(Code);
        end;
      CM_DBLCLICK:
        begin
                   // if IsMessageTick(CM_DBLCLICK, 50) = false then exit;
          pcClick := @Code.Data;
          case pcclick^.rwindow of
                    {
                        WINDOW_SCREEN:
                            begin

                                if SpecialWindow <> WINDOW_NONE then exit;

                                if (pcclick^.rclickedId <> 0) then
                                begin
                                    if IsObjectItemID(pcclick^.rclickedid) then
                                    begin                                       //IsObjectItemID  根据 ID值 来判断
                                        FillChar(ComData, SizeOf(TCDragDrop) + SizeOf(Word), 0);
                                        ComData.Size := SizeOf(TCDragDrop);
                                        pcDragDrop := @ComData.Data;
                                        pcDragDrop^.rmsg := CM_DRAGDROP;
                                        pcDragDrop^.rsourwindow := WINDOW_SCREEN;
                                        pcDragDrop^.rdestwindow := WINDOW_ITEMS;
                                        pcDragDrop^.rsourId := pcclick^.rclickedid;
                                        DragProcess(ComData);
                                        exit;
                                    end;

                                    SendLocalMessage(pcclick^.rclickedid, FM_DBLCLICK, BasicData, SubData);
                                    //SendLocalMessage  FM_DBLCLICK 消息 实际 是没对应 操作
                                    if HaveMagicClass.pCurEctMagic <> nil then
                                    begin
                                        if HaveMagicClass.pCurEctMagic^.rFunction = MAGICFUNC_REFILL then
                                        begin
                                            SendLocalMessage(pcclick^.rclickedid, FM_REFILL, BasicData, SubData);
                                            exit;
                                        end;
                                    end;
                                end;

                                if (BasicData.Feature.rFeatureState = wfs_care) and (pcclick^.rclickedId <> 0) then
                                begin
                                    if pcclick^.rclickedid = TargetID then exit;
                                    if PrevTargetId <> 0 then
                                    begin
                                        if isMonsterID(pcclick^.rclickedID) = true then
                                        begin
                                            if isMonsterId(PrevTargetID) = true then
                                            begin
                                                if boCanAttack = true then SetTargetId(pcclick^.rclickedid);
                                                exit;
                                            end;
                                        end;
                                        if isUserID(pcclick^.rclickedID) = true then
                                        begin
                                            if isUserId(PrevTargetID) = true then
                                            begin
                                                if (Manager.boHit = true) and (boCanAttack = true) then
                                                    SetTargetId(pcclick^.rclickedid);
                                                exit;
                                            end;
                                        end;
                                    end;
                                    if TargetId <> 0 then
                                    begin
                                        if isMonsterId(pcclick^.rclickedId) = true then
                                        begin
                                            if isMonsterId(TargetID) = true then
                                            begin
                                                if boCanAttack = true then SetTargetId(pcclick^.rclickedid);
                                                exit;
                                            end;
                                        end;
                                        if isUserId(pcclick^.rclickedId) = true then
                                        begin
                                            if isUserId(TargetID) = true then
                                            begin
                                                if (Manager.boHit = true) and (boCanAttack = true) then
                                                    SetTargetId(pcclick^.rclickedid);
                                                exit;
                                            end;
                                        end;
                                    end;
                                end;

                                if (ssShift in pcclick^.rShift) and (pcclick^.rclickedId <> 0) then
                                begin
                                    if isMonsterId(pcclick^.rclickedId) = true then
                                    begin
                                        if boCanAttack = true then SetTargetId(pcclick^.rclickedid);
                                    end;
                                    if isDynamicObjectId(pcclick^.rclickedId) = true then
                                    begin
                                        if boCanAttack = true then SetTargetId(pcclick^.rclickedid);
                                    end;
                                    if GuildList.isGuildItem(pcclick^.rclickedId) = true then
                                    begin
                                        if boCanAttack = true then SetTargetId(pcclick^.rclickedid);
                                    end;
                                    exit;
                                end;
                                if (ssCtrl in pcclick^.rShift) and (pcclick^.rclickedId <> 0) then
                                begin
                                    if isUserId(pcclick^.rclickedId) = true then
                                    begin
                                        if (Manager.boHit = true) and (boCanAttack = true) then
                                            SetTargetId(pcclick^.rclickedid);
                                    end;
                                    exit;
                                end;
                            end;
                            }
            WINDOW_ITEMS:
              begin //双点物品
                if SpecialWindow <> WINDOW_NONE then exit;
                                //拷贝 1份 物品属性
                if HaveItemClass.ViewItem(pcclick^.rkey, @ItemData) = FALSE then exit;
                if ItemData.rboBlueprint then exit;
                                //物品分类处理
                case ItemData.rKind of
                  ITEM_KIND_ITEMLOG:
                    begin //扩展仓库 物品
                      if SpecialWindow <> 0 then exit;
                      n := ItemLog.GetCount();
                      if n >= 80 then
                      begin
                        SendClass.SendChatMessage(format('%s的福袋数量已满', [Name]), SAY_COLOR_SYSTEM);
                        exit;
                      end;

                      if ItemLog.CreateRoom() = true then
                      begin
//                                                tmpItemData.rOwnerName := '';
                        HaveItemClass.DeleteKeyItem(pcclick^.rkey, 1);
                        SendClass.SendChatMessage('物品已使用', SAY_COLOR_SYSTEM);
                        SendClass.SendChatMessage(format('%s的福袋一共有 %d格', [Name, ItemLog.GetCount]), SAY_COLOR_SYSTEM);
                      end else
                      begin
                        SendClass.SendChatMessage('为了系统的稳定，所以无法再增加福袋。', SAY_COLOR_SYSTEM);
                      end;
                    end;
                  ITEM_KIND_WEARITEM_FD:
                    begin

                                            //可装备 物品
                      if ExChange.isstate then
                      begin
                        SendClass.SendChatMessage('正在交易 操作失败', SAY_COLOR_SYSTEM);
                        exit;
                      end;
                      if ItemData.rboBlueprint then exit;
                      ItemData.rCount := 1;
                                            //改变 身上 装备
                      if WearItemClass.ChangeItemFD(ItemData, tmpItemDAta) = true then
                      begin
//                                                ItemData.rOwnerName := '';      //成功
                        HaveItemClass.DeleteKeyItem(pcclick^.rkey, 1); //删除背包 物品
                        if tmpItemData.rName <> '' then
                          HaveItemClass.AddItem(@tmpItemData); //身上脱下的 增加到背包
                        WearItemClass.UPFeature;
                        SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                      end;
                    end;

//                                    ITEM_KIND_WEARITEM2                         //24号
                  ITEM_KIND_WEARITEM //6号
                                        //, ITEM_KIND_WEARITEM_29                 //29 有头盔是29
                  , ITEM_KIND_WEARITEM_27
                    , ITEM_KIND_WEARITEM_GUILD: //60号  掉持久
                    begin //可装备 物品
                      if ExChange.isstate then
                      begin
                        SendClass.SendChatMessage('正在交易 操作失败', SAY_COLOR_SYSTEM);
                        exit;
                      end;
                      if ItemData.rboBlueprint then exit;

                                            //拷贝 1份 武器
                      WearItemClass.ViewItem(ARR_WEAPON, @tmpItemData);
                      oldHitType := tmpItemData.rHitType;

                      ItemData.rCount := 1;
                                            //改变 身上 装备
                      if WearItemClass.ChangeItem(ItemData, tmpItemDAta) = true then
                      begin
                                                //成功
//                                                ItemData.rOwnerName := '';
                                                //删除背包 物品
                        HaveItemClass.DeleteKeyItem(pcclick^.rkey, 1);
                        if tmpItemData.rName <> '' then
                        begin
                                                    //身上脱下的 增加到背包
                          HaveItemClass.AddItem(@tmpItemData);
                        end;

                        WearItemClass.ViewItem(ARR_WEAPON, @ItemData);
                        if oldHitType <> ItemData.rHitType then
                        begin
                                                    //武器 类型 改变
                          case ItemData.rHitType of
                            MAGICTYPE_WRESTLING, // 拳
                              MAGICTYPE_FENCING, //剑
                              MAGICTYPE_SWORDSHIP, //刀
                              MAGICTYPE_HAMMERING, //槌
                              MAGICTYPE_SPEARING, //枪
                              MAGICTYPE_BOWING, //弓
                              MAGICTYPE_THROWING: //投
                              begin
                                HaveMagicClass.SetHaveItemMagicType(ItemData.rHitType);
                                HaveMagicClass.SelectBasicMagic(ItemData.rHitType, 100, str);
                              end;
                            7: begin
                                HaveMagicClass.SetHaveItemMagicType(MAGICTYPE_HAMMERING);
                                HaveMagicClass.SelectBasicMagic(MAGICTYPE_HAMMERING, 100, str);
                              end;
                          else
                            begin
                              HaveMagicClass.setAttackMagic(nil);
                              HaveMagicClass.SetBreathngMagic(nil);
                              HaveMagicClass.SetRunningMagic(nil);
                              HaveMagicClass.SetProtectingMagic(nil);
                            end;
                          end;
                          HaveMagicClass.SetEctMagic(nil);
                        end;
                        WearItemClass.UPFeature;
                        SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                      end;
                    end;
                  ITEM_KIND_LifeData_item: //新 可吃附加属性 物品
                    begin

                      if LifeDataList.additem(ItemData) then
                      begin
                       // SetLifeData;
                        ItemUserDel(pcclick^.rkey, 1, ItemData);
                        SendClass.SendChatMessage('物品已使用', SAY_COLOR_SYSTEM);
                      end;
                    end;
                  ITEM_KIND_HIDESKILL:
                    begin
                      if UseSkillKind <> -1 then
                      begin
                        SendClass.SendChatMessage('现在无法使用', SAY_COLOR_SYSTEM);
                        exit;
                      end;
                      if UseSkillKind = ItemData.rKind then
                      begin
                        SendClass.SendChatMessage('无法重复使用。', SAY_COLOR_SYSTEM);
                        exit;
                      end;
                      UseSkillKind := ItemData.rKind;
                      SkillUsedTick := CurTick;
                      SkillUsedMaxTick := INI_HIDEPAPER_DELAY * 100;
                      WearItemClass.SetHiddenState(hs_0);
                      SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);

//                                            tmpItemData.rOwnerName := '';
                      ItemUserDel(pcclick^.rkey, 1, ItemData);
                                            // HaveItemClass.DeleteKeyItem(pcclick^.rkey, 1);

                      SendClass.SendChatMessage('物品已使用', SAY_COLOR_SYSTEM);
                    end;
                  ITEM_KIND_SHOWSKILL: //透视符
                    begin
                      if UseSkillKind <> -1 then
                      begin
                        SendClass.SendChatMessage('现在无法使用', SAY_COLOR_SYSTEM);
                        exit;
                      end;
                      if UseSkillKind = ItemData.rKind then
                      begin
                        SendClass.SendChatMessage('无法重复使用。', SAY_COLOR_SYSTEM);
                        exit;
                      end;

                      UseSkillKind := ItemData.rKind;
                      SkillUsedTick := CurTick;
                      SkillUsedMaxTick := INI_SHOWPAPER_DELAY * 100;

                      for i := 0 to ViewObjectList.Count - 1 do
                      begin
                        BObject := ViewObjectList.Items[i];
                        if BObject.BasicData.Feature.rHideState = hs_0 then
                        begin
                          SendLocalMessage(BasicData.ID, FM_CHANGEFEATURE, BObject.BasicData, SubData);
                        end;
                      end;

//                                            tmpItemData.rOwnerName := '';
                      ItemUserDel(pcclick^.rkey, 1, ItemData);
                                            //  HaveItemClass.DeleteKeyItem(pcclick^.rkey, 1);

                      SendClass.SendChatMessage('物品已使用', SAY_COLOR_SYSTEM);
                    end;
                  ITEM_KIND_TICKET:
                    begin
                                            {if ItemData.rServerId <> ServerID then
                                            begin
                                                boNewServer := TRUE;
                                                ServerID := ItemData.rServerId;
                                                {
                                                                                 case ItemData.rServerId of
                                                                                    0: SendClass.SendChatMessage ('急厚锰俊辑 荤侩且荐 乐嚼聪促.',SAY_COLOR_SYSTEM);
                                                                                    1: SendClass.SendChatMessage ('蛆按锰俊辑 荤侩且荐 乐嚼聪促.',SAY_COLOR_SYSTEM);
                                                                                 end;
                                                                                 exit;
                                                }
                                           { end;
                                            boNewServerDelayTick := 0;
                                            boNewServerTick := 0;
                                            PosMoveX := ItemData.rx;
                                            PosMoveY := ItemData.ry;
                                            }
                      MoveToMap(ItemData.rServerId, ItemData.rx, ItemData.ry, 0);
//                                            tmpItemData.rOwnerName := '';
                      ItemUserDel(pcclick^.rkey, 1, ItemData);
                                            //  HaveItemClass.DeleteKeyItem(pcclick^.rkey, 1);

                      SendClass.SendChatMessage('物品已使用', SAY_COLOR_SYSTEM);
                    end;
                  ITEM_KIND_DRUG:
                    begin
                      if Manager.boUseDrug = false then
                      begin
                        SendClass.SendChatMessage('此地无法服用药物。', SAY_COLOR_SYSTEM);
                        exit;
                      end;
                      iname := (ItemData.rName);
                      if AttribClass.AddItemDrug(iname) then
                      begin
                        if HaveItemClass.ViewItem(pcclick^.rkey, @ItemData) then
                        begin
                          if ItemData.rSoundEvent.rWavNumber <> 0 then
                          begin
                                                        // SetWordString(SubData.SayString, IntToStr(ItemData.rSoundEvent.rWavNumber) + '.wav');
                            SubData.sound := ItemData.rSoundEvent.rWavNumber;
                            SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
                          end;
                        end;
                        tmpBasicData.Feature.rrace := RACE_NPC;
                        tmpBasicData.Name := '使用';
                        tmpBasicData.x := BasicData.x;
                        tmpBasicData.y := BasicData.y;
                        ItemData.rCount := 1;
//                                                SignToItem(ItemData, ServerID, tmpBasicData, '');
                        ItemUserDel(pcclick^.rkey, 1, ItemData);
                                                // HaveItemClass.DeleteKeyItem(pcclick^.rkey, 1);
                        SendClass.SendLeftText(format('服用了%s。', [ItemData.rViewName]), WinRGB(22, 22, 0), mtLeftText);
                      end else
                      begin
                        SendClass.SendLeftText('无法再服用。', WinRGB(22, 22, 0), mtLeftText);
                      end
                    end;
                  ITEM_KIND_ScripterSay:
                    begin
                      if ItemData.rboDurability then
                      begin
                        if ItemData.rCurDurability > 0 then
                        begin
                          SendClass.SendChatMessage('持久为零才能开启！', SAY_COLOR_SYSTEM);
                          exit;
                        end;
                      end;
                      i := sizeof(TCClick);
                      str := WordComData_GETString(code, i);
                      str := trim(str);
                      ItemClass.CallScriptFunction(ItemData.rScripter, 'OnItemDblClick', [integer(self), pcclick^.rkey, str]);
                    end;
                  ITEM_KIND_Scripter:
                    begin
                                            //OnItemDblClick
                      if ItemData.rboDurability then
                      begin
                        if ItemData.rCurDurability > 0 then
                        begin
                          SendClass.SendChatMessage('持久为零才能开启！', SAY_COLOR_SYSTEM);
                          exit;
                        end;
                      end;
                      ItemClass.CallScriptFunction(ItemData.rScripter, 'OnItemDblClick', [integer(self), pcclick^.rkey, '']);
                    end;
                  ITEM_KIND_COLORDRUG:
                    begin

                    end;
                  ITEM_KIND_BOOK:
                    begin
                      str := (ItemData.rname);

                                           // with AttribClass.AttribData do n := cEnergy + cMagic + cInPower + cOutPower + cLife;
                                           { n := AttribClass.AQgetMagic + AttribClass.AQgetInPower + AttribClass.AQgetOutPower + AttribClass.AQgetLife; // n := cEnergy + cMagic + cInPower + cOutPower + cLife;

                                            n := (n - 5000) div 4000;
                                            if n < 0 then n := 0;
                                            if n > 11 then n := 11;


                                            if n < ItemData.rNeedGrade then begin
                                               SendClass.SendChatMessage (format ('泅犁殿鞭:%d 鞘夸殿鞭:%d',[n, ItemData.rNeedGrade]),SAY_COLOR_SYSTEM);
                                               SendClass.SendChatMessage ('修练武功失败。',SAY_COLOR_SYSTEM);
                                               exit;
                                            end;
                                            }

                      if MagicClass.GetMagicData(str, MagicData, 0) then
                      begin
                        if HaveMagicClass.AddMagic(@MagicData) then
                        begin
//                                                    tmpItemData.rOwnerName := '';
                          ItemUserDel(pcclick^.rkey, 1, ItemData);
                                                    //  HaveItemClass.DeleteKeyItem(pcclick^.rkey, 1);
                        end else
                        begin
                          SendClass.SendChatMessage('修练武功失败。', SAY_COLOR_SYSTEM);
                          exit;
                        end;
                      end;
                    end;
                end;
              end;
            WINDOW_WEARS:
              begin

              end;

            WINDOW_MAGICS:
              begin
                if SpecialWindow <> WINDOW_NONE then exit;

                                //1，复制选择武功
                HaveMagicClass.ViewMagic(pcclick^.rkey, @MagicData);
                if MagicData.rName = '' then exit;

                n := (AttribClass.CurHeadLife * 100 div AttribClass.MaxLife);
                                //2，选择前 武功简单判断
                if HaveMagicClass.PreSelectHaveMagic(pcclick^.rkey, n, str) = false then
                begin
                  if str <> '' then
                  begin
                    SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                  end;
                  exit;
                end;

                boFlag := true;
                                //3，测试 是否需要武器的武功
                case MagicData.rMagicType of
                  MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP, MAGICTYPE_HAMMERING,
                    MAGICTYPE_SPEARING, MAGICTYPE_BOWING, MAGICTYPE_THROWING
                    : boFlag := false;
                end;

                if boFlag = false then
                begin
                                //4，换武器，武功武器类型 对比
                  if WearItemClass.GetWeaponType <> (MagicData.rMagicType mod 100) then
                  begin
                                    //拳法 找1个空位或者拳套
                    n := HaveItemClass.FindItemByMagicKind((MagicData.rMagicType mod 100));
                    if n < 0 then
                    begin
                      SendClass.SendChatMessage('没有相应武功对应的武器', SAY_COLOR_SYSTEM);
                      exit;
                    end;
                    HaveItemClass.ViewItem(n, @ItemData);
                    ItemData.rCount := 1;
                    if ItemData.rName <> '' then
                    begin
                                    //交换带回 换下武器
                      WearItemClass.ChangeItem(ItemData, tmpItemData);
                    end else
                    begin
                                    //一定是空位置
                      WearItemClass.ViewItem(ARR_WEAPON, @tmpItemData);
                      WearItemClass.DeleteKeyItem(ARR_WEAPON);
                    end;

                                    //删除背包里的
//                                        ItemData.rOwnerName := '';
                    HaveItemClass.DeleteKeyItem(n, 1);
                    if tmpItemData.rName <> '' then
                    begin
                      HaveItemClass.AddItem(@tmpItemData);
                    end;

                    HaveMagicClass.SetHaveItemMagicType(ItemData.rHitType);
                    WearItemClass.UPFeature;
                    SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                  end;
                end;
                                //5，换武功
                n := (AttribClass.CurHeadLife * 100 div AttribClass.MaxLife);
                ret := HaveMagicClass.SelectHaveMagic(pcclick^.rkey, n, str);
                case ret of
                  SELECTMAGIC_RESULT_FALSE:
                    begin
                      if str <> '' then SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                      exit;
                    end;
                  SELECTMAGIC_RESULT_NONE: ;
                  SELECTMAGIC_RESULT_NORMAL: CommandChangeCharState(wfs_normal, FALSE);
                  SELECTMAGIC_RESULT_SITDOWN: CommandChangeCharState(wfs_sitdown, FALSE);
                  SELECTMAGIC_RESULT_RUNNING: CommandChangeCharState(wfs_running, FALSE);
                end;
                               //不知道为什么 要再次查找。暂时取消
                               // HaveMagicClass.ViewMagic(pcclick^.rkey, @MagicData);
                               // if MagicData.rName <> '' then
                begin
                                //通告 其他玩家 已经换武功
                  SetWordString(SubData.SayString, (MagicData.rName));
                  SendLocalMessage(NOTARGETPHONE, FM_SAYUSEMAGIC, BasicData, SubData);
                end;
              end;
            WINDOW_MAGICS_Rise:
              begin
                if SpecialWindow <> WINDOW_NONE then exit;

                                //1，复制选择武功
                HaveMagicClass.Rise_ViewMagic(pcclick^.rkey, @MagicData);
                if MagicData.rName = '' then exit;

                n := (AttribClass.CurHeadLife * 100 div AttribClass.MaxLife);
                                //2，选择前 武功简单判断
                if HaveMagicClass.Rise_PreSelectHaveMagic(pcclick^.rkey, n, str) = false then
                begin
                  if str <> '' then
                  begin
                    SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                  end;
                  exit;
                end;

                boFlag := true;
                                //3，测试 是否需要武器的武功
                case MagicData.rMagicType of
                  MAGICTYPE_2WRESTLING, MAGICTYPE_2FENCING, MAGICTYPE_2SWORDSHIP, MAGICTYPE_2HAMMERING,
                    MAGICTYPE_2SPEARING, MAGICTYPE_2BOWING, MAGICTYPE_2THROWING
                    : boFlag := false;
                end;

                if boFlag = false then
                begin
                                //4，换武器，武功武器类型 对比
                  if WearItemClass.GetWeaponType <> (MagicData.rMagicType mod 100) then
                  begin
                                    //拳法 找1个空位或者拳套
                    n := HaveItemClass.FindItemByMagicKind((MagicData.rMagicType mod 100));
                    if n < 0 then
                    begin
                      SendClass.SendChatMessage('没有相应武功对应的武器', SAY_COLOR_SYSTEM);
                      exit;
                    end;
                    HaveItemClass.ViewItem(n, @ItemData);
                    ItemData.rCount := 1;
                    if ItemData.rName <> '' then
                    begin
                                    //交换带回 换下武器
                      WearItemClass.ChangeItem(ItemData, tmpItemData);
                    end else
                    begin
                                    //一定是空位置
                      WearItemClass.ViewItem(ARR_WEAPON, @tmpItemData);
                      WearItemClass.DeleteKeyItem(ARR_WEAPON);
                    end;

                                    //删除背包里的
//                                        ItemData.rOwnerName := '';
                    HaveItemClass.DeleteKeyItem(n, 1);
                    if tmpItemData.rName <> '' then
                    begin
                      HaveItemClass.AddItem(@tmpItemData);
                    end;

                    HaveMagicClass.SetHaveItemMagicType(ItemData.rHitType);
                    WearItemClass.UPFeature;
                    SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                  end;
                end;
                                //5，换武功
                n := (AttribClass.CurHeadLife * 100 div AttribClass.MaxLife);
                ret := HaveMagicClass.Rise_SelectHaveMagic(pcclick^.rkey, n, str);
                case ret of
                  SELECTMAGIC_RESULT_FALSE:
                    begin
                      if str <> '' then SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                      exit;
                    end;
                  SELECTMAGIC_RESULT_NONE: ;
                  SELECTMAGIC_RESULT_NORMAL: CommandChangeCharState(wfs_normal, FALSE);
                  SELECTMAGIC_RESULT_SITDOWN: CommandChangeCharState(wfs_sitdown, FALSE);
                  SELECTMAGIC_RESULT_RUNNING: CommandChangeCharState(wfs_running, FALSE);
                end;
                               //不知道为什么 要再次查找。暂时取消
                               // HaveMagicClass.ViewMagic(pcclick^.rkey, @MagicData);
                               // if MagicData.rName <> '' then
                begin
                                //通告 其他玩家 已经换武功
                  SetWordString(SubData.SayString, (MagicData.rName));
                  SendLocalMessage(NOTARGETPHONE, FM_SAYUSEMAGIC, BasicData, SubData);
                end;
              end;
            WINDOW_BASICFIGHT:
              begin
                if SpecialWindow <> WINDOW_NONE then exit;

                HaveMagicClass.ViewBasicMagic(pcclick^.rkey, @MagicData); //补全 武功
                if MagicData.rName = '' then exit;

                n := (AttribClass.CurHeadLife * 100 div AttribClass.MaxLife);
                if HaveMagicClass.PreSelectBasicMagic(pcclick^.rkey, n, str) = false then
                begin
                  if str <> '' then
                  begin
                    SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                  end;
                  exit;
                end;

                boFlag := true;
                case MagicData.rMagicType of
                  MAGICTYPE_WRESTLING, MAGICTYPE_FENCING, MAGICTYPE_SWORDSHIP, MAGICTYPE_HAMMERING,
                    MAGICTYPE_SPEARING, MAGICTYPE_BOWING, MAGICTYPE_THROWING
                    , MAGICTYPE_2WRESTLING, MAGICTYPE_2FENCING, MAGICTYPE_2SWORDSHIP, MAGICTYPE_2HAMMERING,
                    MAGICTYPE_2SPEARING, MAGICTYPE_2BOWING, MAGICTYPE_2THROWING
                    : boFlag := false;
                end;

                if boFlag = false then
                begin
                  if WearItemClass.GetWeaponType <> (MagicData.rMagicType mod 100) then //武器武功不一致
                  begin
                    n := HaveItemClass.FindItemByMagicKind(MagicData.rMagicType mod 100); //找类型 物品
                    if n < 0 then
                    begin
                                            //没有相应武工对应的武器
                      SendClass.SendChatMessage('没有相应武功对应的武器', SAY_COLOR_SYSTEM);
                      exit;
                    end;
                    HaveItemClass.ViewItem(n, @ItemData); //补全 物品
                    ItemData.rCount := 1;

                    if ItemData.rName <> '' then
                    begin
                      WearItemClass.ChangeItem(ItemData, tmpItemData); //交换 物品
                    end else
                    begin
                      WearItemClass.ViewItem(ARR_WEAPON, @tmpItemData);
                      WearItemClass.DeleteKeyItem(ARR_WEAPON);
                    end;

//                                        ItemData.rOwnerName := '';
                    HaveItemClass.DeleteKeyItem(n, 1); //删除 背包物品
                    if tmpItemData.rName <> '' then
                    begin
                      HaveItemClass.AddItem(@tmpItemData); //换下 物品 增加到背包
                    end;
                    HaveMagicClass.SetHaveItemMagicType(ItemData.rHitType);
                    WearItemClass.UPFeature;
                    SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
                  end;
                end;

                n := (AttribClass.CurHeadLife * 100 div AttribClass.MaxLife);
                ret := HaveMagicClass.SelectBasicMagic(pcclick^.rkey, n, str);
                case ret of
                  SELECTMAGIC_RESULT_FALSE:
                    begin
                      if str <> '' then SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                      exit;
                    end;
                  SELECTMAGIC_RESULT_NONE: ;
                  SELECTMAGIC_RESULT_NORMAL: CommandChangeCharState(wfs_normal, FALSE);
                  SELECTMAGIC_RESULT_SITDOWN: CommandChangeCharState(wfs_sitdown, FALSE);
                  SELECTMAGIC_RESULT_RUNNING: CommandChangeCharState(wfs_running, FALSE);
                end;
                                //不知道为什么 要再次查找。暂时取消
                                //MagicData := HaveMagicClass.DefaultMagic[pcclick^.rkey];
                               // if MagicData.rName <> '' then
                begin
                  SetWordString(SubData.SayString, (MagicData.rName));
                  SendLocalMessage(NOTARGETPHONE, FM_SAYUSEMAGIC, BasicData, SubData);
                end;
              end;
          else exit;
          end;
        end;
      CM_drink:
        begin
          PCdrink := @Code.Data;
          if isVirtualObjectID(PCdrink^.rclickedid) then
          begin
            SubData.tx := PCdrink^.rX;
            SubData.tY := PCdrink^.rY;
            SendLocalMessage(PCdrink^.rclickedId, FM_drink, BasicData, SubData);
            str := GetWordString(SubData.SayString);
            if str <> '' then SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
          end;
        end;
      CM_CLICK:
        begin
          if CM_MessageTick[CM_CLICK] + 20 > mmAnsTick then exit;
          CM_MessageTick[CM_CLICK] := mmAnsTick;

          pcClick := @Code.Data;
          case pcclick^.rwindow of

            WINDOW_SCREEN:
              begin //点 屏幕
                if pcclick^.rclickedId <> 0 then
                begin
                  if IsObjectItemID(pcclick^.rclickedid) then
                  begin
                    FillChar(ComData, SizeOf(TCDragDrop) + SizeOf(Word), 0);
                    ComData.Size := SizeOf(TCDragDrop);
                    pcDragDrop := @ComData.Data;
                    pcDragDrop^.rmsg := CM_DRAGDROP;
                    pcDragDrop^.rsourwindow := WINDOW_SCREEN;
                    pcDragDrop^.rdestwindow := WINDOW_ITEMS;
                    pcDragDrop^.rsourId := pcclick^.rclickedid;
                    DragProcess(ComData);
                  end else
                  begin

                                        //  SubData.TargetId := 0;
                    SendLocalMessage(pcclick^.rclickedId, FM_CLICK, BasicData, SubData);
                    str := GetWordString(SubData.SayString);
                    if str <> '' then SendClass.SendChatMessage(str, SAY_COLOR_SYSTEM);
                                        //SendClass.SendSelChar(SubData.TargetId);

                  end;
                end;
              end;
          else exit;
          end;
        end;
      CM_HIT:
        begin
          if SpecialWindow <> WINDOW_NONE then exit;

          if CM_MessageTick[CM_HIT] + 20 > mmAnsTick then exit;
          CM_MessageTick[CM_HIT] := mmAnsTick;
                    //----------------------------------------------------------
                    //                     基本检查
          if boCanAttack = false then exit; //不允许攻击
          if Manager.boHit = false then exit; //地图不允许攻击
          pchit := @Code.Data;
          if pcHit^.rtid = 0 then exit; //无目标

          if pcHit^.rkey <> BasicData.dir then CommandTurn(pcHit^.rkey, TRUE); //纠正方向
                    //----------------------------------------------------------
                    //                     加血类武功
          if HaveMagicClass.pCurEctMagic <> nil then
          begin
            if HaveMagicClass.pCurEctMagic^.rFunction = MAGICFUNC_REFILL then
            begin
              SendLocalMessage(pcHit^.rtid, FM_REFILL, BasicData, SubData);
              exit;
            end;
          end;

                    //----------------------------------------------------------
                    //                     攻击
          if pcHit^.rtid = TargetId then exit; //攻击目标 相同
          if HaveMagicClass.pCurAttackMagic = nil then
          begin
            if isDynamicObjectId(pcHit^.rtid) then SetTargetId(pcHit^.rtid);
            exit; //无攻击武功
          end;
          if isMonsterId(pcHit^.rtid)
            or isUserId(pcHit^.rtid)
            or isDynamicObjectId(pcHit^.rtid)
            or isStaticItemId(pcHit^.rtid) then
          begin
            SetTargetId(pcHit^.rtid);
          end;

        end;

      CM_KEYDOWN:
        begin

          if CM_MessageTick[CM_KEYDOWN] + 50 > mmAnsTick then exit;
          CM_MessageTick[CM_KEYDOWN] := mmAnsTick;

          pckey := @Code.Data;
          case pckey^.rkey of
            VK_F2:
              begin
                if BasicData.Feature.rfeaturestate = wfs_normal then
                  CommandChangeCharState(wfs_care, FALSE)
                else CommandChangeCharState(wfs_normal, FALSE)
              end;
            VK_F3: CommandChangeCharState(wfs_sitdown, FALSE);
            VK_F4:
              begin
                if BasicData.Feature.rFeatureState = wfs_normal then
                begin
                  SubData.motion := AM_HELLO;
                  SendLocalMessage(NOTARGETPHONE, FM_MOTION, BasicData, SubData);
                end;
              end;
            VK_F5: ;
            VK_F6: ;
            VK_F7: ;
            VK_F8: ;
          end;
          if BasicData.Feature.rFeaturestate = wfs_normal then SetTargetId(0);
        end;
      CM_TURN:
        begin

          if SpecialWindow <> WINDOW_NONE then exit;

          pckey := @Code.Data;
          BasicData.dir := pckey^.rkey;
          SendLocalMessage(NOTARGETPHONE, FM_TURN, BasicData, SubData);
        end;
      CM_NETSTATE:
        begin
          pCNetState := @Code.Data;

                    {if CurTick >= pCNetState^.rMadeTick + 100 then
                    begin
                        FillChar(SaveNetState, SizeOf(TCNetState), 0);
                        exit;
                    end;
                    if (SaveNetState.rID = 0) or (pCNetState^.rID - SaveNetState.rID > 1) then
                    begin
                        Move(pCNetState^, SaveNetState, SizeOf(TCNetState));
                        exit;
                    end;
                    if pCNetState^.rCurTick - SaveNetState.rCurTick >= 900 then
                    begin
                        if boCheckSpeed = true then
                        begin
                            MacroChecker.SaveMacroCase(Name, 4);
                            ConnectorList.CloseConnectByCharName(Name);
                        end;
                    end;
                    Move(pCNetState^, SaveNetState, SizeOf(TCNetState));
                    }
          if NetState_speed_close then exit;

          if (pCNetState.rID) <> (NetState_ClientId + 1) then
          begin
            if boCheckSpeed = true then
            begin
              NetState_speed_close := true;
              MacroChecker.SaveMacroCase(Name, 4);
            end;
            SendClass.SendChatMessage('加网络不稳定!', SAY_COLOR_GRADE6lcred);
            exit;
          end;
          NetState_ClientId := pCNetState.rID;
          if NetState_ClientId = 1 then
          begin
            NetState_Client_mmAnsTick0 := pCNetState.rCurTick;
            NetState_mmAnsTick0 := mmAnsTick;
            exit;
          end;
          i := abs((pCNetState.rCurTick - NetState_Client_mmAnsTick0) - (mmAnsTick - NetState_mmAnsTick0));
          if i > 6000 then
          begin
               //超出范围，网络太慢，或者开加速
            if boCheckSpeed = true then
            begin
              NetState_speed_close := true;
              MacroChecker.SaveMacroCase(Name, 4);
            end;
            SendClass.SendChatMessage('网络不稳定!时间问题。', SAY_COLOR_GRADE6lcred);
          end;
          exit;
        end;
      CM_MOVE:
        begin

                    // SendClass.SendChatMessage('移动间隔：' + inttostr(mmAnsTick - CM_MessageTick[cm_move]), SAY_COLOR_GRADE6lcred);
{                    if IsMessageTick(CM_MOVE, VarMoveSpeedTime) = false then
                    begin
                        // SendClass.SendChatMessage('加速使用者：' + name, SAY_COLOR_GRADE6lcred);
                        exit;
                    end;
                    CM_MessageTick[CM_MOVE] := CurTick; }
                   //
          pcMove := @Code.data;

          n := (pcMove.rmmAnsTick - NetState_Client_mmAnsTick0) + NetState_mmAnsTick0; //换算成 服务器 时间
          n := abs(mmAnsTick - n);
          if n > 6000 then
          begin
                        //时间有问题 误差太大
//                        SendClass.SendChatMessage('时间有问题 误差太大：' + inttostr(n), SAY_COLOR_GRADE6lcred);
            SendClass.SendChatMessage('网络不稳定!', SAY_COLOR_GRADE6lcred);
                     //   exit;
          end;
                    //
          i := VarMoveSpeedTime;
         { case BasicData.Feature.rFeaturestate of
            wfs_normal: i := 60;
            wfs_care: i := 60;
            wfs_running: i := 30;
            wfs_running2: i := 24;
          else
            begin

              exit;
            end;
          end;
          }
          if MOVE_Client_OldTick + i > pcMove.rmmAnsTick then
          begin
//                        SendClass.SendChatMessage(',时间差' + inttostr(pcMove.rmmAnsTick - MOVE_Client_OldTick) + ' 正确时间' + inttostr(i), SAY_COLOR_GRADE6lcred);
            SendClass.SendChatMessage('网络不稳定!' + name, SAY_COLOR_GRADE6lcred);
            exit;
          end;
                   // SendClass.SendChatMessage(',时间差' + inttostr(pcMove.rmmAnsTick - MOVE_Client_OldTick), SAY_COLOR_GRADE3);
          MOVE_Client_OldTick := pcMove.rmmAnsTick;


          if SpecialWindow <> WINDOW_NONE then
          begin
            SendLocalMessage(NOTARGETPHONE, FM_SETPOSITION, BasicData, SubData);
            SendClass.SendSetPosition(BasicData);
            exit;
          end;

          if MenuSayObjId <> 0 then
          begin
            MenuSayObjId := 0;
                        {case NPCstate of
                            NPC_SELL, NPC_BUF, NPC_LOGITEM:hideItemNPCTradeWindow;
                            NPC_email:CloseEmailWindow;
                            NPC_auction:CloseauctionWindow;
                        end;}
          end;

                    {if ((mmAnsTick - HitedTick < 10)) then
                    begin
                        SendClass.SendChatMessage('攻击后10单位时间不能移动', SAY_COLOR_GRADE6lcred);
                        SendLocalMessage(NOTARGETPHONE, FM_SETPOSITION, BasicData, SubData);
                        SendClass.SendSetPosition(BasicData);
                        exit;
                    end;
                    }

          if (CanMove = false) or (LockNotMoveState) then
          begin
                        //  SendClass.SendChatMessage('禁止移动', SAY_COLOR_GRADE6lcred);

            SendLocalMessage(NOTARGETPHONE, FM_SETPOSITION, BasicData, SubData);
            SendClass.SendSetPosition(BasicData);
            exit;
          end;
          if pcMove^.rdir <> BasicData.dir then
          begin
                        //  SendClass.SendChatMessage('弹回正常方向', SAY_COLOR_GRADE6lcred);
                         // SendLocalMessage(NOTARGETPHONE, FM_TURN, BasicData, SubData);
                        //  SendClass.SendTurn(BasicData);
                       // SendClass.SendChatMessage('修正方向错误', SAY_COLOR_GRADE6lcred);
                        // SendClass.lockmoveTime(0);
            BasicData.dir := pcMove^.rdir;
                        //  SendClass.SendTurn(BasicData);
                        //  SendLocalMessage(NOTARGETPHONE, FM_TURN, BasicData, SubData);

          end;
          if (GetLargeLength(BasicData.X, BasicData.Y, pcMove^.rx, pcMove^.ry) <> 1) then
          begin
                        // SendClass.SendChatMessage('弹回正常坐标', SAY_COLOR_GRADE6lcred);
            SendClass.lockmoveTime(100);
            SendLocalMessage(NOTARGETPHONE, FM_SETPOSITION, BasicData, SubData);
            SendClass.SendSetPosition(BasicData);
            exit;
          end;

          xx := BasicData.x;
          yy := BasicData.y;
          GetNextPosition(pcMove^.rdir, xx, yy);
          if (pcMove^.rx <> xx) or (pcMove^.ry <> yy) then
          begin
                        // SendClass.SendChatMessage('目标位置不可移动', SAY_COLOR_GRADE6lcred);
            SendClass.lockmoveTime(200);
            SendLocalMessage(NOTARGETPHONE, FM_SETPOSITION, BasicData, SubData);
            SendClass.SendSetPosition(BasicData);
            exit;
          end;
          if Maper.isMoveable(xx, yy) then
          begin
                        {
                        if BasicData.dir <> pcMove^.rdir then begin
                           BasicData.dir := pcMove^.rdir;
                           SendLocalMessage ( NOTARGETPHONE, FM_TURN, BasicData, SubData);
                        end;
                        }
            BasicData.nx := xx;
            BasicData.ny := yy;

            Phone.SendMessage(NOTARGETPHONE, FM_MOVE, BasicData, SubData);
            Maper.MapProc(BasicData.id, MM_MOVE, BasicData.x, basicData.y, xx, yy, BasicData);
            BasicData.dir := pcMove^.rdir;
            BasicData.x := xx;
            BasicData.y := yy;
                        // SendClass.SendMove(BasicData);
            HaveMagicClass.AddWalking;
          end else
          begin

            BasicData.dir := pcMove^.rdir;
            SendLocalMessage(NOTARGETPHONE, FM_SETPOSITION, BasicData, SubData);
            SendClass.SendSetPosition(BasicData);

          end;
        end;

      CM_SAY:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;


          if boCanSay = false then exit;

          pcSay := @Code.Data;
          str := GetWordString(pcSay^.rWordString);
          UserSay(str);
        end;
      CM_WINDOWCONFIRM:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          pcWindowConfirm := @Code.Data;
          if pcWindowConfirm^.rWindow <> SpecialWindow then exit;

          case SpecialWindow of
            WINDOW_AGREE: //退出 游戏
              begin
                if pcWindowConfirm^.rboCheck = true then
                begin
                  SendClass.SendGameExit;
                end else
                begin

                end;
              end;
            WINDOW_ITEMLOG: //仓库
              begin

              end;
            WINDOW_ALERT:
              begin
              end;
          end;
          SpecialWindow := WINDOW_NONE;
        end;
      CM_MAKEGUILDMAGIC:
        begin
          if CM_MessageTick[pckey^.rmsg] + 50 > mmAnsTick then exit;
          CM_MessageTick[pckey^.rmsg] := mmAnsTick;

          SpecialWindow := WINDOW_NONE;
          if GuildName = '' then exit;
          GuildObject := GuildList.GetGuildObject(GuildName);
          if GuildObject = nil then exit;
          if GuildObject.IsGuildSysop(Name) = false then
          begin
            SendClass.SendChatMessage('只有门主才可以申请门派武功', SAY_COLOR_SYSTEM);
            exit;
          end;
          if GuildObject.GetGuildMagicString <> '' then
          begin
            SendClass.SendChatMessage('已经有门派武功', SAY_COLOR_SYSTEM);
            exit;
          end;

          ItemClass.GetItemData('金币', ItemData);
          if ItemData.rName = '' then exit;
          ItemData.rCount := 40;
          if FindItem(@ItemData) = false then
          begin
            SendClass.SendChatMessage('申请门派武功时需要40个金币', SAY_COLOR_SYSTEM);
            exit;
          end;

          pcGuildMagicData := PTCGuildMagicData(@Code.Data);
          if (length(pcGuildMagicData^.rMagicName) > 12)
            or (length(pcGuildMagicData^.rMagicName) < 2) then
          begin
            SendClass.SendChatMessage('武功名字错误', SAY_COLOR_SYSTEM);
            exit;
          end;

          FillChar(MagicData, SizeOf(TMagicData), 0);
          MagicData.rName := pcGuildMagicData^.rMagicName;
          MagicData.rGuildMagicType := 1;
          MagicData.rMagicType := pcGuildMagicData^.rMagicType;

          MagicData.rShape := MagicData.rMagicType + 1;
          MagicData.rSkillExp := 100;
          MagicData.rLifeData.damageBody := pcGuildMagicData^.rDamageBody;
          MagicData.rLifeData.damageHead := pcGuildMagicData^.rDamageHead;
          MagicData.rLifeData.damageArm := pcGuildMagicData^.rDamageArm;
          MagicData.rLifeData.damageLeg := pcGuildMagicData^.rDamageLeg;
          MagicData.rLifeData.ArmorBody := pcGuildMagicData^.rArmorBody;
          MagicData.rLifeData.ArmorHead := pcGuildMagicData^.rArmorHead;
          MagicData.rLifeData.ArmorArm := pcGuildMagicData^.rArmorArm;
          MagicData.rLifeData.ArmorLeg := pcGuildMagicData^.rArmorLeg;
          MagicData.rLifeData.AttackSpeed := pcGuildMagicData^.rSpeed;
          MagicData.rLifeData.Recovery := pcGuildMagicData^.rRecovery;
          MagicData.rLifeData.Avoid := pcGuildMagicData^.rAvoid;
          MagicData.rEventDecInPower := pcGuildMagicData^.rInPower;
          MagicData.rEventDecOutPower := pcGuildMagicData^.rOutPower;
          MagicData.rEventDecMagic := pcGuildMagicData^.rMagicPower;
          MagicData.rEventDecLife := pcGuildMagicData^.rLife;

          if MagicClass.CheckMagicData(MagicData, Str) = false then
          begin
            SendClass.SendChatMessage(Str, SAY_COLOR_SYSTEM);
            exit;
          end;

          if MagicClass.AddGuildMagic(MagicData, GuildName) = false then
          begin
            SendClass.SendChatMessage('不能添加门派武功', SAY_COLOR_SYSTEM);
            exit;
          end;

          GuildObject := GuildList.GetGuildObject(GuildName);
          if GuildObject = nil then
          begin
            SendClass.SendChatMessage('无法搜索到加入的门派', SAY_COLOR_SYSTEM);
            exit;
          end;

          if DeleteItem(@ItemData) = false then exit;
          GuildObject.AddGuildMagic(pcGuildMagicData^.rMagicName);

          SendClass.SendChatMessage(format('%s门的门派武功是%s', [GuildName, pcGuildMagicData^.rMagicName]), SAY_COLOR_SYSTEM);
        end;
    end;
  except
    frmMain.WriteLogInfo(format('TUser(%s).MessageProcess () failed', [Name]));
    frmMain.WriteDumpInfo(@Code, SizeOf(TWordComData));
    frmMain.WriteDumpInfo(@BasicData, SizeOf(TBasicData));
  end;
end;

function TUser.FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
  i, Key: Integer;
  str: string;
  per: integer;
  ItemData: TItemData;
  SubData: TSubData;
  ExChangeUser: TUser;
  SaveHideState: THiddenState;
begin
  Result := PROC_FALSE;
  if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit;
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
  if Result = PROC_TRUE then exit;

  if SysopObj <> nil then
  begin
    TUser(SysopObj).FieldProc2(hfu, Msg, SenderInfo, aSubData);
  end;

  if (botv = true) and (Msg <> FM_SAY) then exit;

  case Msg of
    FM_LIFEPERCENT:
      begin
        SendClass.SendStructed(SenderInfo, aSubData.percent);
      end;
    FM_KILL: //杀死  怪物
      begin
        if BasicData.Feature.rFeatureState <> wfs_die then exit;
        ShowEffect(8, lek_follow);

        BasicData.nX := BasicData.X;
        BasicData.nY := BasicData.Y;
        SubData.ServerId := Manager.ServerID;
        for i := 0 to 10 - 1 do
        begin
          Key := Random(HAVEITEMSIZE);
          HaveItemClass.ViewItem(Key, @SubData.ItemData);
          if SubData.ItemData.rName <> '' then
          begin
            if Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData) = PROC_TRUE then
            begin
              HaveItemClass.DeleteKeyItem(Key, SubData.ItemData.rCount);
              exit;
            end;
          end;
        end;
        for i := 0 to 30 - 1 do
        begin
          HaveItemClass.ViewItem(i, @SubData.ItemData);
          if SubData.ItemData.rName <> '' then
          begin
            if Phone.SendMessage(MANAGERPHONE, FM_ADDITEM, BasicData, SubData) = PROC_TRUE then
            begin
              HaveItemClass.DeleteKeyItem(i, SubData.ItemData.rCount);
              exit;
            end;
          end;
        end;
      end;
    FM_REFILL:
      begin

               // if (hfu = 0) and (aSubData.HitData.HitType = 0) then            //GM发出的
               // begin
                    {AttribClass.CurAttribData.CurEnergy := AttribClass.AQgetEnergy;
                    AttribClass.CurAttribData.CurInPower := AttribClass.AQgetInPower;
                    AttribClass.CurAttribData.CurOutPower := AttribClass.AQgetOutPower;
                    AttribClass.CurAttribData.CurMagic := AttribClass.AQgetMagic;
                    AttribClass.CurAttribData.CurLife := AttribClass.AQgetLife;
                    AttribClass.CurAttribData.CurHeadSeak := AttribClass.AQgetHeadSeak;
                    AttribClass.CurAttribData.CurArmSeak := AttribClass.AQgetArmSeak;
                    AttribClass.CurAttribData.CurLegSeak := AttribClass.AQgetLegSeak;
                    DiedTick := 0;

                    SendClass.SendAttribBase(AttribClass.AttribData, AttribClass.CurAttribData, AttribClass.AttribQuestData);
                    SendClass.SendAttribValues(AttribClass.AttribData, AttribClass.CurAttribData, AttribClass.AttribQuestData);
                    }
              //  AttribClass.REFILL;
              //  DiedTick := 0;

                  //  exit;
                //end;

        case aSubData.HitData.HitType of
          0:
            begin
              AttribClass.REFILL;
              DiedTick := 0;
              SendClass.SendChatMessage('测试消息：GM恢复' + inttostr(mmAnsTick), SAY_COLOR_SYSTEM);
            end;
          1: //加水
            begin
              HaveItemClass.addDurability_Water;
              SendClass.SendChatMessage('测试消息：加水' + inttostr(mmAnsTick), SAY_COLOR_SYSTEM);
            end;
          2: //加活力
            begin

              AttribClass.CurLife := AttribClass.CurLife + aSubData.HitData.ToHit;
              SendClass.SendChatMessage('测试消息：加活力2' + inttostr(mmAnsTick), SAY_COLOR_SYSTEM);
            end;
          3:
            begin
              AttribClass.CurLife := AttribClass.CurLife + aSubData.HitData.ToHit;
              SendClass.SendChatMessage('测试消息：加活力3' + inttostr(mmAnsTick), SAY_COLOR_SYSTEM);
            end;
        end;


      end;
    FM_EXCHANGE_UPDATE:
      begin
        ExChangeUser := getExUser;
        if ExChangeUser = nil then exit;
        SendClass.SendExChangeUPDATE(@ExChange.fdata, @ExchangeUser.ExChange.fdata);
      end;
    FM_SHOWEXCHANGE: // 显示 交易
      begin
        ExChangeUser := getExUser;
        if ExChangeUser = nil then exit;
        SpecialWindow := WINDOW_EXCHANGE;
        SendClass.SendShowExChange(@ExChange.fdata, @ExchangeUser.ExChange.fdata);

      end;
    FM_CANCELEXCHANGE:
      begin
        ExChange.Clear;
        SendClass.SendCancelExChange;
        if SpecialWindow = WINDOW_EXCHANGE then SpecialWindow := 0;
        Result := PROC_TRUE;
      end;

    FM_ENOUGHSPACE:
      begin
        if HaveItemClass.IsSpace then
        begin
          Result := PROC_TRUE;
          exit;
        end;
      end;
    FM_GATE:
      begin
        if hfu <> BasicData.id then exit;

                {PosMoveX := SenderInfo.nx;
                PosMoveY := SenderInfo.ny;
                if ServerID <> aSubData.ServerId then
                begin
                    ServerID := aSubData.ServerId;
                    boNewServer := TRUE;
                end;
                }
        MoveToMap(aSubData.ServerId, SenderInfo.nx, SenderInfo.ny, 0);
      end;
    FM_SOUND:
      begin
                //SendClass.SendSoundEffect(GetWordString(aSubData.SayString), SenderInfo.x, SenderInfo.y);

        SendClass.SendSoundEffect(aSubData.sound, SenderInfo.x, SenderInfo.y);
      end;
    FM_SAYUSEMAGIC: SendClass.SendSayUseMagic(SenderInfo, GetWordString(aSubData.SayString));
    FM_SAY:
      SendClass.SendSay(SenderInfo, GetWordString(aSubData.SayString));
    FM_SHOUT: SendClass.SendChatMessage(GetWordString(aSubData.SayString), SAY_COLOR_SHOUT);
    FM_LeftText: SendClass.SendLeftText(GetWordString(aSubData.SayString), aSubData.ShoutColor, mtLeftText3);
    FM_SHOW:
      begin
        if UseSkillKind = ITEM_KIND_SHOWSKILL then
        begin
          SaveHideState := SenderInfo.Feature.rHideState;
          SenderInfo.Feature.rHideState := hs_100;
        end;
        SendClass.SendShow(SenderInfo);

        if UseSkillKind = ITEM_KIND_SHOWSKILL then
        begin
          SenderInfo.Feature.rHideState := SaveHideState;
        end;

        if SenderInfo.Feature.rrace = RACE_HUMAN then
        begin
          ExChangeUser := SenderInfo.P;
          if ExChangeUser.Boothclass = nil then
          begin
            SendClass.SendBooth(SenderInfo.id, false, '', 0);
            exit;
          end;
          if ExChangeUser.Boothclass.state = false then
          begin
            SendClass.SendBooth(SenderInfo.id, false, '', 0);
            exit;
          end;
          SendClass.SendBooth(SenderInfo.id, ExChangeUser.Boothclass.state, ExChangeUser.Boothclass.boothname, ExChangeUser.Boothclass.boothshape);
        end;
      end;
    FM_HIDE:
      begin
        SendClass.SendHide(SenderInfo);
      end;
    FM_STRUCTED:
      begin
        if SenderInfo.Feature.rRace <> RACE_DYNAMICOBJECT then
        begin
          SendClass.SendMotion(SenderInfo.id, AM_STRUCTED);
        end;
        SendClass.SendStructed(SenderInfo, aSubData.percent);
      end;
    FM_BOOTH:
      begin
        if SenderInfo.id = BasicData.id then BasicData.boNotHit := BasicData.rbooth;

        if SenderInfo.Feature.rrace <> RACE_HUMAN then exit;
        ExChangeUser := SenderInfo.P;
        if ExChangeUser.Boothclass = nil then
        begin
          SendClass.SendBooth(SenderInfo.id, false, '', 0);
          exit;
        end;
        if ExChangeUser.Boothclass.state = false then
        begin
          SendClass.SendBooth(SenderInfo.id, false, '', 0);
          exit;
        end;
        SendClass.SendBooth(SenderInfo.id, ExChangeUser.Boothclass.state, ExChangeUser.Boothclass.boothname, ExChangeUser.Boothclass.boothshape);
      end;
    FM_CHANGEFEATURE: //改变 面貌
      begin
        if SenderInfo.id = BasicData.id then
        begin
          if BasicData.Feature.rfeaturestate = wfs_die then
          begin
            SpecialWindow := 0; //关闭自己窗口
            SendClass.SendShowSpecialWindow(WINDOW_Close_All, '', '');
                        //死亡 取消正在的交易
            if ExChange.isstate then
            begin
              SendClass.SendChatMessage('交易取消', SAY_COLOR_SYSTEM);
              ExChangeUser := getExUser;
              if ExChangeUser <> nil then
                ExChangeUser.SendClass.SendChatMessage('交易取消', SAY_COLOR_SYSTEM);
              ExChangeClose;
            end;
          end;
        end;
        if UseSkillKind = ITEM_KIND_SHOWSKILL then
        begin
          SaveHideState := SenderInfo.Feature.rHideState;
          SenderInfo.Feature.rHideState := hs_100;
        end;

        SendClass.SendChangeFeature(SenderInfo);
        if UseSkillKind = ITEM_KIND_SHOWSKILL then
        begin
          SenderInfo.Feature.rHideState := SaveHideState;
        end;
      end;
    FM_CHANGEPROPERTY: //改变  物品
      begin
        if UseSkillKind = ITEM_KIND_SHOWSKILL then
        begin
          SaveHideState := SenderInfo.Feature.rHideState;
          SenderInfo.Feature.rHideState := hs_100;
        end;
        SendClass.SendChangeProperty(SenderInfo);
        if UseSkillKind = ITEM_KIND_SHOWSKILL then
        begin
          SenderInfo.Feature.rHideState := SaveHideState;
        end;
      end;
    FM_ADDvirtueEXP:
      begin

        AttribClass.addvirtue(aSubData.ExpData.Exp, aSubData.ExpData.LevelMax);
      end;
    FM_ADDATTACKEXP:
      begin
                //自己消息退出，自己死亡退出
        if SenderInfo.id = BasicData.id then exit;
        if BasicData.Feature.rFeatureState = wfs_die then exit;

                //经验类型
        case aSubData.ExpData.ExpType of
          _et_Procession:
            begin
                            //是否接受 队伍经验         同队伍才获得
              if (uProcessionclass = nil) or (aSubData.ProcessionClass = nil) then exit;
              if aSubData.ProcessionClass <> uProcessionclass then exit;
              HaveMagicClass.AddAttackExp(aSubData.ExpData.ExpType, aSubData.ExpData.Exp);
              exit;
            end;
          _et_MONSTER, _et_MONSTER_die, _et_PET, _et_PET_MONSTER_die:
            begin
                            //手活力，降低到50%没经验
              per := AttribClass.CurArmLife * 100 div AttribClass.MaxLife;
              if per <= 50 then
              begin
                SendClass.SendChatMessage('因为攻击力太弱而没能得到经验值。', SAY_COLOR_SYSTEM);
                exit;
              end;
                            //自己增加经验
              LastGainExp := HaveMagicClass.AddAttackExp(aSubData.ExpData.ExpType, aSubData.ExpData.Exp);

              if LastGainExp > 0 then
              begin
                                //经验朱子 成长
                case aSubData.ExpData.ExpType of
                  _et_MONSTER, _et_MONSTER_die:
                    begin
                      WearItemClass.AddAttackExp(aSubData.ExpData.Exp);
                    end;
                end;
                                //分经验给队伍的人 目前是 得到的任何经验都分给队伍
                if (uProcessionclass <> nil) then
                begin
                  SubData.ExpData.Exp := aSubData.ExpData.Exp;
                  SubData.ExpData.ExpType := _et_Procession;
                  SubData.ProcessionClass := uProcessionclass;
                  SubData.ExpData.LevelMax := 9999;
                  SendLocalMessage(NOTARGETPHONE, FM_ADDATTACKEXP, BasicData, SubData);
                end;
              end;
            end;

        end;
                {                    :
                        begin
                            SendClass.SendLeftText('死亡经验' + inttostr(aSubData.ExpData.Exp div 10000), WinRGB(22, 22, 0), mtLeftText3);
                            HaveMagicClass.AddAttackExp(aSubData.ExpData.ExpType, aSubData.ExpData.Exp);
                            exit;
                        end;}

      end;
      {  FM_ADDPROTECTEXP:
            begin
                HaveMagicClass.AddProtectExp(aSubData.ExpData.ExpType, aSubData.ExpData.Exp);

            end;
        {  FM_KillDead:               //杀死  人
              begin
                  SendClass.SendChatMessage(format('您谋杀了玩家【%S】。', [GetWordString(aSubData.SayString)]), SAY_COLOR_GRADE6lcred);
                  SetWordString(aSubData.SayString, format('您被玩家【%S】杀死。', [name]));
                  Result := PROC_TRUE;
              end; }
    FM_MOTION:
      if SenderInfo.id <> BasicData.id then
        SendClass.SendMotion(SenderInfo.id, aSubData.motion);
    FM_MOTION2:
      begin
        if SenderInfo.id <> BasicData.id then
          SendClass.SendMotion2(SenderInfo.id, aSubData.motion, asubdata.motionMagicType, aSubData.motionMagicColor);
      end;
    FM_TURN:
      begin
        if SenderInfo.id = BasicData.id then
        begin

                    //  if FreezeTick < (mmAnsTick + 10) then FreezeTick := mmAnsTick + 10;
                    //  SendClass.SendChatMessage('改变方向后10单位时间不能攻击', SAY_COLOR_GRADE6lcred);
        end else
          SendClass.SendTurn(SenderInfo);
      end;
    FM_MOVE:
      begin
        if SenderInfo.id = BasicData.id then
        begin //冻结
                    //  if FreezeTick < (mmAnsTick + 200) then FreezeTick := mmAnsTick + 200;
                    //  SendClass.SendChatMessage('移动后200单位时间不自动攻击', SAY_COLOR_GRADE6lcred);
        end else

          SendClass.SendMove(SenderInfo);
                // if SenderInfo.REWelkingEffect > 0 then
                 //    SendClass.SendMagicEffect(SenderInfo.id, SenderInfo.REWelkingEffect, lek_follow);
                 // SenderInfo.REWelkingEffect := 0;

      end;
    FM_SETPOSITION:
      begin
        if SenderInfo.id = BasicData.id then
        begin
          MOVE_Client_OldTick := 0;
                    //    if FreezeTick < (mmAnsTick + 10) then FreezeTick := mmAnsTick + 10;
                      //  SendClass.SendChatMessage('弹到指定坐标后10单位时间不能攻击', SAY_COLOR_GRADE6lcred);
        end
        else
          SendClass.SendSetPosition(SenderInfo);
      end;
    FM_MagicEffect:
      begin
        SendClass.SendMagicEffect(SenderInfo.id, SenderInfo.Feature.rEffectNumber, SenderInfo.Feature.rEffectKind);
      end;
    FM_Effect:
      begin
        SendClass.SendEffect(SenderInfo.id, SenderInfo.Feature.rEffectNumber, SenderInfo.Feature.rEffectKind);
      end;
    FM_SYSOPMESSAGE: if SysopScope > aSubData.SysopScope then SendClass.SendChatMessage(GetWordString(aSubData.SayString), SAY_COLOR_SYSTEM);
    FM_ADDQUESTITEM:
      begin
        if SenderInfo.id = BasicData.id then EXIT;
        if (uProcessionclass = nil) or (aSubData.ProcessionClass <> uProcessionclass) then exit;
        HaveItemQuestClass.Add(@aSubData.ItemData);
      end;
    FM_ADDITEM:
      begin

        str := (aSubData.ItemData.rName);
        if str = INI_ROPE then
        begin
          if BasicData.Feature.rFeatureState = wfs_die then
          begin
            RopeTarget := SenderInfo.id;
            RopeTick := mmAnsTick;
            Result := PROC_TRUE;
            exit;
          end;
        end;
        if aSubData.ItemData.rKind = ITEM_KIND_QUEST then
        begin
          if (uProcessionclass <> nil) and (aSubData.ItemData.rboQuestProcession) then
          begin
            SubData.ItemData := aSubData.ItemData;
            SubData.ProcessionClass := uProcessionclass;
            SendLocalMessage(0, FM_ADDQUESTITEM, BasicData, SubData);
          end;
          HaveItemQuestClass.Add(@aSubData.ItemData);
          Result := PROC_TRUE;
        end
        else if HaveItemClass.AddItem(@aSubData.ItemData) then
        begin
          Result := PROC_TRUE;
          logItemMoveInfo('FM_ADDITEM背包增加', @SenderInfo, @BasicData, aSubData.ItemData, Manager.ServerID);

        end;

      end;
    FM_DELITEM_KEY:
      begin
        if HaveItemClass.DeletekeyItem(aSubData.delItemKey, aSubData.delItemcount) then
        begin
          Result := PROC_TRUE;
          logItemMoveInfo('FM_DELITEM_KEY背包删除', @SenderInfo, @BasicData, aSubData.ItemData, Manager.ServerID);
        end;
      end;
    FM_DELITEM:
      begin
        if HaveItemClass.DeleteItem(@aSubData.ItemData) then
        begin
          Result := PROC_TRUE;
          logItemMoveInfo('FM_DELITEM背包删除', @SenderInfo, @BasicData, aSubData.ItemData, Manager.ServerID);
        end;
      end;

    FM_BOW: SendClass.SendShootMagic(SenderInfo, aSubData.TargetId, aSubData.tx, aSubData.ty, aSubData.BowImage, aSubData.BowSpeed, aSubData.BowType, aSubData.EEffectNumber);
  end;
end;

function TUser.FieldProc2(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
begin
  Result := PROC_FALSE;
  case Msg of
    FM_SOUND:
      begin
                //                SendClass.SendSoundEffect(GetWordString(aSubData.SayString), SenderInfo.x, SenderInfo.y);
        SendClass.SendSoundEffect(aSubData.sound, SenderInfo.x, SenderInfo.y);
      end;
    FM_SAYUSEMAGIC: SendClass.SendSayUseMagic(SenderInfo, GetWordString(aSubData.SayString));
    FM_SAY: SendClass.SendSay(SenderInfo, GetWordString(aSubData.SayString));
    FM_SHOUT: SendClass.SendChatMessage(GetWordString(aSubData.SayString), SAY_COLOR_SHOUT);
    FM_SHOW: SendClass.SendShow(SenderInfo);
    FM_HIDE: SendClass.SendHide(SenderInfo);
    FM_STRUCTED:
      begin
        if SenderInfo.Feature.rRace <> RACE_DYNAMICOBJECT then
        begin
          SendClass.SendMotion(SenderInfo.id, AM_STRUCTED);
        end;
        SendClass.SendStructed(SenderInfo, aSubData.percent);
      end;
    FM_CHANGEFEATURE: SendClass.SendChangeFeature(SenderInfo);
    FM_CHANGEPROPERTY: SendClass.SendChangeProperty(SenderInfo);
    FM_MOTION: SendClass.SendMotion(SenderInfo.id, aSubData.motion);
    FM_TURN: SendClass.SendTurn(SenderInfo);
    FM_MOVE: SendClass.SendMove(SenderInfo);
    FM_BOW: SendClass.SendShootMagic(SenderInfo, aSubData.TargetId, aSubData.tx, aSubData.ty, aSubData.BowImage, aSubData.BowSpeed, aSubData.BowType, aSubData.EEffectNumber);
  end;
end;

procedure TUser.SETSpecialWindow(Value: byte);
begin
  FSpecialWindow := Value;
  if FSpecialWindow = 0 then
    CanMove := TRUE
  else
    CanMove := FALSE;
end;

procedure TUser.SetNEWEmail(Value: boolean);
var
  code: TWordComData;
begin
  if FboNewEmail <> Value then
  begin
    FboNewEmail := Value;
    code.Size := 0;
    WordComData_ADDbyte(code, SM_EMAIL);
    WordComData_ADDbyte(code, EMAIL_STATE_NEWEMAIL);
    WordComData_ADDbyte(code, byte(Value));
    SendClass.SendData(code);
  end;
end;

procedure TUser.Setmove(Value: boolean);
var
  code: TWordComData;
begin
  FboCanMove := Value;
  code.Size := 0;
  WordComData_ADDbyte(code, SM_boMOVE);
  WordComData_ADDbyte(code, byte(Value));
  SendClass.SendData(code);
end;

procedure TUser.SendMapObject;
var
  i: Integer;
  tt: tnpclist;
  anpc: tnpc;
  ttgate: TGateObject;
  pd: PTCreateGateData;
begin
  tt := Manager.NpcList;
  if tt = nil then exit;
  for I := 0 to tt.Count - 1 do
  begin
    anpc := tt.GetNpcIndex(i);
    if anpc = nil then Continue;
    if anpc.pSelfData = nil then Continue;
    if anpc.pSelfData.rMinimapShow then
      SendClass.SendMapObject(anpc.PosX, anpc.Posy, anpc.pSelfData.rViewName, MapobjectNpc);
  end;

  for I := 0 to GateList.Count - 1 do
  begin
    ttgate := GateList.GetItemIndex(i);
    if ttgate = nil then exit;
    pd := ttgate.GetSelfData;
    if pd.Show then
      if pd.MapID = Manager.ServerID then
        SendClass.SendMapObject(pd.X, pd.y, pd.ViewName, MapobjectGate);
  end;
    //队伍
  if uProcessionclass = nil then exit;
  TProcessionclass(uProcessionclass).SendMapObject(SELF);

end;

procedure TUser.Update(CurTick: integer);
var
  i, cnt: integer;
  iCnt: Word;
  ComData: TWordComdata;
  GMD: TGMData;
  SubData: TSubData;
  BObject: TBasicObject;
  tmpManager: TManager;
  ItemData: titemdata;
  str: string;
begin

  if boException = true then exit;
  if boDeleteState then
  begin
    if CurTick >= NetStateTick + 500 then
    begin
      NetStateTick := CurTick;
      FrmMain.WriteLogInfo(Name + ' 5秒重新断开。');
      ConnectorList.CloseConnectByCharName(Name);
    end;

    if Connector.ReceiveBuffer.Count > 0 then Connector.ReceiveBuffer.Clear;
    exit;
  end;

  inherited UpDate(CurTick);

  MagicExpMulUpdate(CurTick);
  MonsterUPdate(CurTick);
  ExChange.MsgList.UPDATE(curtick);
  if Connector.ReceiveBuffer.Count > 0 then
  begin
    if NetPackLogName = name then
      frmLog.Memo1.Lines.Add('开始包数量：' + inttostr(Connector.ReceiveBuffer.Count));
    while true do
    begin
      if Connector.ReceiveBuffer.Get(@ComData) = false then break;
      MessageProcess(ComData);
    end;
    if NetPackLogName = name then frmLog.Memo1.Lines.Add('结束包数量：' + inttostr(Connector.ReceiveBuffer.Count));
  end;
    // 胶乔靛 琴 规瘤甫 困秦辑 付访茄 菩哦
  if CurTick >= NetStateTick + 2000 then
  begin
    NetStateTick := CurTick;
    if NetState_speed_close then
    begin
      FrmMain.WriteLogInfo(Name + ' 加速，停止服务。');
      boDeleteState := true;
      ConnectorList.CloseConnectByCharName(Name);
      exit;
    end;
    if abs(NetStateID - NetState_ClientId) > 3 then
    begin
      FrmMain.WriteLogInfo(Name + ' 心跳包ID错误，停止服务。');
      boDeleteState := true;
      ConnectorList.CloseConnectByCharName(Name);
      exit;
    end;

    SendClass.SendNetState(NetStateID, CurTick);
    Inc(NetStateID);

  end;


  if boNewServer and ((boNewServerDelayTick <= 0) or (CurTick > boNewServerTick + boNewServerDelayTick)) then
  begin
    boNewServerTick := CurTick;
    boNewServerDelayTick := 0;
    boNewServer := FALSE;
    HaveItemClass.OnChangeMap;
    if (PosMoveX <> -1) and (PosMoveY <> -1) then
    begin
      Phone.SendMessage(NOTARGETPHONE, FM_DESTROY, BasicData, SubData); //消失
      Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y); //卸载

      if ServerID <> Manager.ServerID then
      begin
        tmpManager := ManagerList.GetManagerByServerID(ServerId);
        if tmpManager <> nil then
        begin
          if tmpManager.boAQClear then
          begin
                ////////////////////////////////////////////////////////////////////////
                //清除 属性
            AttribClass.AQClear;
                //清除道具
            HaveItemClass.QClear;
                //清除装备
            WearItemClass.QClear;
                //武功 换成默认武功。
            WearItemClass.ViewItem(ARR_WEAPON, @ItemData);
            if ItemData.rName = '' then
            begin
              HaveMagicClass.SetHaveItemMagicType(ItemData.rHitType);
              HaveMagicClass.SelectBasicMagic(ItemData.rHitType, 100, str);
            end;
            WearItemClass.UPFeature;
            SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);

                //恢复 元气
            PowerLevelMax;
               //////////////////////////////////////////////////////////////////////////
          end;
          SetManagerClass(tmpManager);
          AttribClass.SetAddExpFlag := tmpManager.boGetExp;
          HaveMagicClass.SetAddExpFlag := tmpManager.boGetExp;
          if tmpManager.RegenInterval > 0 then
          begin
            DisplayValue := 0;
            DisplayTick := -1;
          end;
        end else
        begin
          frmMain.WriteLogInfo(format('Manager = nil (%s, %d, %d, %d)', [Name, ServerID, PosMoveX, PosMoveY]));
        end;
      end;

      if Maper.GetMoveableXy(PosMoveX, PosMoveY, 10) = false then
      begin
        frmMain.WriteLogInfo(format('FM_GATE NewServer Error (%s, %d, %d, %d)', [Name, ServerID, PosMoveX, PosMoveY]));
      end;

      BasicData.x := PosMoveX;
      BasicData.y := PosMoveY;
      PosMoveX := -1;
      PosMoveY := -1;

      SendClass.SendMap(BasicData, Manager.MapName, Manager.ObjName, Manager.RofName, Manager.TilName, Manager.SoundBase, Manager.Title);
      Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
      Phone.SendMessage(NOTARGETPHONE, FM_CREATE, BasicData, SubData);

      if BasicData.Feature.rfeaturestate = wfs_die then
      begin
        Maper.MapProc(BasicData.Id, MM_HIDE, BasicData.x, BasicData.y, BasicData.x, BasicData.y, BasicData);
      end;
    end;
  end else
  begin
    if //(Connector.BattleState <> bcs_gotobattle) and
      (PosMovex <> -1) and (PosMoveY <> -1) then
    begin
      Phone.SendMessage(NOTARGETPHONE, FM_DESTROY, BasicData, SubData);
      Phone.UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

      if Maper.GetMoveableXy(PosMoveX, PosMoveY, 10) = false then
      begin
        frmMain.WriteLogInfo(format('FM_GATE GetMoveableXY Error (%s, %d, %d, %d)', [Name, ServerID, PosMoveX, PosMoveY]));
      end;

      BasicData.x := PosMoveX;
      BasicData.y := PosMoveY;
      PosMoveX := -1;
      PosMoveY := -1;

      SendClass.SendMap(BasicData, Manager.MapName, Manager.ObjName, Manager.RofName, Manager.TilName, Manager.SoundBase, Manager.Title);
      Phone.RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
      Phone.SendMessage(NOTARGETPHONE, FM_CREATE, BasicData, SubData);
    end;
  end;

  if Manager.boPrison = true then
  begin
    if PrisonTick + 6000 <= CurTick then
    begin
      PrisonTick := CurTick;
      if PrisonClass.IncreaseElaspedTime(Name, 1) <= 0 then
      begin
                {ServerID := Manager.TargetServerID;
                PosMoveX := Manager.TargetX;
                PosMoveY := Manager.TargetY;
                boNewServer := true;
                }
        MoveToMap(Manager.TargetServerID, Manager.TargetX, Manager.TargetY, 0);

        SendClass.SendChatMessage('从流配地释放出来了。', SAY_COLOR_NORMAL);
        SendClass.SendChatMessage('请遵守风云OL法规，避免再次被囚禁！', SAY_COLOR_NORMAL);
        exit;
      end;
    end;
  end;

  if CurTick >= SaveTick + 10 * 60 * 100 then
  begin
    SaveTick := CurTick;
    SaveUserData(Name);
    WearItemClass.SaveToSdb(@Connector.CharData);
    HaveItemClass.SaveToSdb(@Connector.CharData);
    AttribClass.SaveToSdb(@Connector.CharData);
    HaveMagicClass.SaveToSdb(@Connector.CharData);
  end;

  if Manager.RegenInterval > 0 then
  begin
    if LifeObjectState <> los_die then
    begin
      if (DisplayTick = -1) or (DisplayTick + 100 < CurTick) then
      begin
        if (Manager.RemainHour = 0) and (Manager.RemainMin = 0) then
        begin
          if Manager.RemainSec <> DisplayValue then
          begin
            DisplayValue := Manager.RemainSec;
            SendClass.SendChatMessage(format('剩下 %d秒。', [DisplayValue]), SAY_COLOR_SYSTEM);
                        {
                        if (DisplayValue = 0) and (SysopScope < 100) then begin
                           CommandChangeCharState (wfs_die, FALSE);
                        end;
                        }
          end;
        end else
        begin
          if Manager.RemainMin <> DisplayValue then
          begin
            DisplayValue := Manager.RemainMin;
            SendClass.SendChatMessage(format('剩下 %d分。', [DisplayValue]), SAY_COLOR_SYSTEM);
          end;
        end;
      end;
    end;
  end;

  if UseSkillKind <> -1 then
  begin
    if SkillUsedTick + SkillUsedMaxTick <= CurTick then
    begin
      cnt := UseSkillKind;
      UseSkillKind := -1;
      SkillUsedTick := 0;
      SkillUsedMaxTick := 0;

      case cnt of
        ITEM_KIND_HIDESKILL:
          begin
            WearItemClass.SetHiddenState(hs_100);
            SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
          end;
        ITEM_KIND_SHOWSKILL:
          begin
            SetTargetID(0);
            for i := 0 to ViewObjectList.Count - 1 do
            begin
              BObject := ViewObjectList.Items[i];
              if BObject.BasicData.Feature.rHideState = hs_0 then
              begin
                SendLocalMessage(BasicData.ID, FM_CHANGEFEATURE, BObject.BasicData, SubData);
              end;
            end;
          end;
      end;
    end;
  end;
end;

procedure TUser.AddRefusedUser(aName: string);
var
  i: Integer;
begin
  if RefuseReceiver.Count >= 5 then
  begin
    SendClass.SendChatMessage('无法传递纸条。', SAY_COLOR_SYSTEM);
    exit;
  end;

  for i := 0 to RefuseReceiver.Count - 1 do
  begin
    if RefuseReceiver.Strings[i] = aName then exit;
  end;

  RefuseReceiver.Add(aName);
end;

procedure TUser.DelRefusedUser(aName: string);
var
  i: Integer;
begin
  for i := 0 to RefuseReceiver.Count - 1 do
  begin
    if RefuseReceiver.Strings[i] = aName then
    begin
      RefuseReceiver.Delete(i);
      exit;
    end;
  end;
end;

procedure TUser.AddMailSender(aName: string);
begin
  if CheckSenderList(aName) = True then exit;
  if MailSender.Count >= MailSenderLimit then
  begin
    MailSender.Delete(MailSender.Count - 1);
    MailSender.Insert(0, aName);
  end else
  begin
    MailSender.Add(aName);
  end;
end;

function TUser.CheckSenderList(aName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to MailSender.Count - 1 do
  begin
    if MailSender.Strings[i] = aName then
    begin
      Result := True;
      Exit;
    end;
  end;
end;
 {
procedure TUser.MoveTo(aTargetX, aTargetY: Integer);                            //移动到
begin
    if Maper.isMoveable(aTargetX, aTargetY) then
    begin
        PosMoveX := aTargetX;
        PosMoveY := aTargetY;
    end;
end;
}

procedure TUser.MoveToMap(aServerID: Integer; aTargetX, aTargetY: Integer; aDelayTick: integer = 0); //移动到指定 地图
begin
  boNewServerDelayTick := aDelayTick;
  boNewServerTick := mmAnsTick;
  if ManagerList.GetManagerByServerID(aServerID) = nil then exit;
  if aServerID <> ServerID then
  begin
    boNewServer := TRUE;
    ServerID := aServerID;
  end;
  PosMoveX := aTargetX;
  PosMoveY := aTargetY;

end;

{procedure TUser.MoveToMapName(aName: string; aTargetX, aTargetY: Integer);      //移动到指定 地图
var
    tmpManager: TManager;
begin
    tmpManager := ManagerList.GetManagerByTitle(aName);
    if tmpManager <> nil then
    begin
        if tmpManager.ServerID <> ServerID then
        begin
            boNewServer := TRUE;
            ServerID := tmpManager.ServerID;
        end;
        PosMoveX := aTargetX;
        PosMoveY := aTargetY;
    end;
end;
 }

procedure TUser.SetPosition(x, y: Integer);
begin
  PosMoveX := x;
  PosMoveY := y;
end;

procedure TUser.SetPositionBS(ex, ey: Integer);
begin
  PosMoveX := ex;
  PosMoveY := ey;
    //  Connector.BattleState := bcs_gotobattle;
end;

function TUser.MovingStatus: Boolean;
begin
  Result := false;
  if (PosMoveX <> -1) or (PosMoveY <> -1) then
  begin
    Result := true;
  end;
end;

function TUser.isGm: boolean;
begin
  result := SysopScope > 99;
end;

procedure TUser.CloseAllWindow();
begin
  SpecialWindow := 0;
  MenuSayObjId := 0;
  MenuSTATE := nsNONE;
  SendClass.SendShowSpecialWindow(WINDOW_Close_All, '', '');
end;

procedure TUser.closeNPCSAYWindow;
begin
  case SpecialWindow of
    WINDOW_MENUSAY: ;
    WINDOW_ITEMTrade_buf: ;
    WINDOW_ITEMTrade_sell: ;
  else exit;
  end;

  SpecialWindow := 0;
  MenuSayObjId := 0;
  MenuSTATE := nsNONE;

end;

procedure TUser.ShowNPCSAYWindow(SAYTEXT: string);
var
  sname: string;
  AShape, AImage: INTEGER;
  bo: TBasicObject;
begin

  if (SpecialWindow <> 0) then
  begin
    SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
    exit;
  end;

  if MenuSayObjId = 0 then
  begin
    SendClass.SendChatMessage('对话过期', SAY_COLOR_SYSTEM);
    exit;
  end;
  bo := GetViewObjectById(MenuSayObjId);
  if bo = nil then
  begin
    MenuSayObjId := 0;
    SendClass.SendChatMessage('对话过期', SAY_COLOR_SYSTEM);
    exit;
  end;

  if MenuSTATE <> nsSelect then
  begin
    SendClass.SendChatMessage('对话过期', SAY_COLOR_SYSTEM);
    exit;
  end;
  AShape := 0;
  AImage := 0;
  MenuSTATE := nsSAY;
  SpecialWindow := WINDOW_MENUSAY;
  sname := (bo.BasicData.ViewName);
  case bo.BasicData.Feature.rrace of
    RACE_NPC:
      begin
        AShape := TNPC(bo).pSelfData.rShape;
        AImage := TNPC(bo).pSelfData.rImage;
      end;
  else
    begin
      AShape := BO.BasicData.Feature.rImageNumber;
    end;

  end;



  SendClass.SendShowSpecialWindow(WINDOW_MENUSAY, sname, SAYTEXT, AShape, AImage, bo.BasicData.Feature.rrace);
  MenuSayText := SAYTEXT;
end;

procedure TUser.closeEmailWindow;
begin

  if SpecialWindow <> WINDOW_Email then exit;
  SpecialWindow := 0;
  MenuSayObjId := 0;
  MenuSTATE := nsNONE;
end;

function TUser.ShowEmailWindow: string;
begin
  Result := '';

  if SpecialWindow <> WINDOW_MENUSAY then
  begin
    Result := '请关闭开启的窗口';
    exit;
  end;
  SpecialWindow := 0;
  if aEmail = nil then
  begin
    Result := '你没有邮箱。';
    exit;
  end;

  SpecialWindow := WINDOW_Email;

  TEmailclass(aEmail).EmailWindowsOpen(self);

end;

procedure TUser.CloseAuctionWindow;
begin
  if SpecialWindow <> WINDOW_Auction then exit;
  SpecialWindow := 0;
  MenuSayObjId := 0;
  MenuSTATE := nsNONE;
end;

function TUser.ShowAuctionWindow: string;
begin
  Result := '';

  if SpecialWindow <> WINDOW_MENUSAY then
  begin
    Result := '请关闭开启的窗口';
    exit;
  end;

  SpecialWindow := WINDOW_Auction;
  AuctionSystemClass.openAucitonWindows(self);

end;

function TUser.ShowItemLogWindow: string;
var
  i, j, n: Integer;
  ItemData: TItemData;
begin
  Result := '';



  if SpecialWindow <> WINDOW_MENUSAY then
  begin
    Result := '请关闭开启的窗口';
    exit;
  end;
  SpecialWindow := 0;
  if HaveItemClass.LockedPass = true then
  begin
    Result := '有密码设定';
    exit;
  end;
  n := ItemLog.GetCount();
  if n <= 0 then
  begin
    Result := format('%s 没有储存的空间,可以在货郎那里购买福袋,使用福袋后可以增加仓库空间!', [Name]);
    exit;
  end;

  if ItemLog.isLocked() = true then
  begin
    Result := format('%s 的保管窗有密码设定', [Name]);
    exit;
  end;

  SpecialWindow := WINDOW_ITEMLOG;
  SendClass.SendShowSpecialWindow(WINDOW_ITEMLOG, '物品保管窗', '把物品移动到DRAG&DROP后，请按【确认】键');

  ItemLog.senditemlogall;

end;

function TUser.ShowItemGameexitWindow: string;
begin
  Result := '';
  if SpecialWindow <> 0 then
  begin
    Result := '请关闭开启的窗口';
    exit;
  end;

  SpecialWindow := WINDOW_AGREE;
  SendClass.SendShowSpecialWindow(WINDOW_AGREE, '终止风云OL游戏', '你要终止风云OL游戏吗？');

end;

function TUser.ShowItemUpDatePasswordWindow: string;
begin
  if HaveItemClass.LockedPass = false then
    if trim(HaveItemClass.Password) = '' then
    begin
      Result := '还没设定密码';
      exit;
    end;
  Result := ShowItemSetPasswordWindow;
end;

function TUser.ShowItemSetPasswordWindow: string;
begin
  Result := '';

    { if HaveItemClass.Locked = true then
     begin
         Result := '无法使用本功能';
         exit;
     end;
     }
  if SpecialWindow <> 0 then
  begin
    Result := '请关闭开启的窗口';
    exit;
  end;

  if HaveItemClass.LockedPass = true then
  begin
    Result := '密码已设定';
    exit;
  end;

  SpecialWindow := WINDOW_ShowPassWINDOW_Item;
  SendClass.SendShowSpecialWindow(WINDOW_ShowPassWINDOW_Item, '', '');

end;

function TUser.ShowItemFreePasswordWindow: string;
begin
  Result := '';

    {    if HaveItemClass.Locked = true then
        begin
            Result := '无法使用本功能';
            exit;
        end;}
  if SpecialWindow <> 0 then
  begin
    Result := '请关闭开启的窗口';
    exit;
  end;

  if HaveItemClass.LockedPass = false then
  begin
    Result := '还没设定密码';
    exit;
  end;

  SpecialWindow := WINDOW_ShowPassWINDOW_ItemUnLock;
  SendClass.SendShowSpecialWindow(WINDOW_ShowPassWINDOW_ItemUnLock, '', '');
end;

function TUser.ShowItemLogSetPasswordWindow: string;
begin
  Result := '';

  if SpecialWindow <> 0 then
  begin
    Result := '请关闭开启的窗口';
    exit;
  end;

  if ItemLog.GetCount() <= 0 then
  begin
    Result := '此人没有福袋';
    exit;
  end;

  if ItemLog.isLocked() = true then
  begin
    Result := '福袋密码已设定';
    exit;
  end;

  SpecialWindow := WINDOW_ShowPassWINDOW_LogItem;
  SendClass.SendShowSpecialWindow(WINDOW_ShowPassWINDOW_LogItem, '', '');

end;

function TUser.ShowItemLogFreePasswordWindow: string;
begin
  Result := '';

  if SpecialWindow <> 0 then
  begin
    Result := '请关闭开启的窗口';
    exit;
  end;

  if ItemLog.GetCount() <= 0 then
  begin
    Result := '此人没有保管空间';
    exit;
  end;

  if ItemLog.isLocked() = false then
  begin
    Result := '还没设定密码';
    exit;
  end;

  SpecialWindow := WINDOW_ShowPassWINDOW_LogItemUnLock;
  SendClass.SendShowSpecialWindow(WINDOW_ShowPassWINDOW_LogItemUnLock, '', '');
end;
////////////////////////////////////////////////////////////////////////////////
//                                  买卖窗口
////////////////////////////////////////////////////////////////////////////////

function TUser.ShowItemBuyWindow(aCaption: string; aComment: string; aShape, aImage: INTEGER; aBuyItemAllState: boolean): boolean;
var
  astate: integer;
begin
  Result := false;

  if (SpecialWindow <> WINDOW_MENUSAY) then
  begin
    SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
    exit;
  end;
  SpecialWindow := WINDOW_ITEMTrade_buf;
  astate := MakeLong(word(aBuyItemAllState), word(HaveItemClass.LockedPass));
  SendClass.SendShowSpecialWindow(WINDOW_ITEMTrade_buf, aCaption, aComment, aShape, aImage, astate);
  Result := true;
end;

function TUser.ShowItemSellWindow(aCaption: string; aComment: string; aShape, aImage: INTEGER): boolean;
begin
  Result := false;

  if (SpecialWindow <> WINDOW_MENUSAY) then
  begin
    SendClass.SendChatMessage('请关闭开启的窗口', SAY_COLOR_SYSTEM);
    exit;
  end;
  SpecialWindow := WINDOW_ITEMTrade_sell;
  SendClass.SendShowSpecialWindow(WINDOW_ITEMTrade_sell, aCaption, aComment, aShape, aImage, integer(HaveItemClass.LockedPass));
  Result := true;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TUser.UdpSendMouseEvent(aInfoStr: string);
begin
  FrmSockets.UdpSendMouseInfo(aInfoStr + ',');
end;

////////////////////////////////////////////////////
//
//             ===  UserList  ===
//
////////////////////////////////////////////////////

constructor TUserList.Create(cnt: integer);
begin
  CurProcessPos := 0;
  UserProcessCount := 0;

  ExceptCount := 0;
    // TvList := TList.Create;
    // AnsList := TAnsList.Create (cnt, AllocFunction, FreeFunction);
  DataList := TList.Create;
  NameKey := TStringKeyClass.Create;
end;

destructor TUserList.Destroy;
var
  i: Integer;
  User: TUser;
begin
    // AnsList.Free;
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    User.Free;
  end;
  DataList.Clear;
  DataList.Free;

  NameKey.Free;
    // TvList.Free;
  inherited destroy;
end;

function TUserList.InitialLayer(aCharName: string; aConnector: TConnector): Boolean;
var
  i: Integer;
  User: TUser;
  tmpManager: TManager;
  ServerID: Integer;
  xx, yy: Word;
  rStr: string;
begin
  Result := false;

  if NameKey.Select(aCharName) <> nil then
  begin
    frmMain.WriteLogInfo('if NameKey.Select(aCharName) <> nil then  failed');
    exit;
  end;

  User := TUser.Create;

  User.Connector := aConnector;
  User.SysopScope := SysopClass.GetSysopScope(aCharName); //GM权限
  User.ItemLog.SETItemLog(@aConnector.CharData.ItemLog); //设置  仓库 地址
  tmpManager := nil;
    ////////////////////////////////////////////////////////////////////////////
    //                   监狱列表中=>分配到 监狱地图
  rStr := PrisonClass.GetUserStatus(aCharName);
  if rStr <> '' then
  begin
    User.ServerID := User.Connector.CharData.ServerID;
    for i := 0 to ManagerList.Count - 1 do
    begin
      tmpManager := ManagerList.GetManagerByIndex(i);
      if tmpManager.boPrison = true then
      begin
        if User.ServerID <> tmpManager.ServerID then
        begin
          ServerID := tmpManager.ServerID;
          User.ServerID := ServerID;
          User.Connector.CharData.ServerID := ServerID;
          User.Connector.CharData.X := 61;
          User.Connector.CharData.Y := 77;
        end;
        break;
      end;
      tmpManager := nil;
    end;
  end;
    ////////////////////////////////////////////////////////////////////////////
    //                   分配到 下线地图
  if tmpManager = nil then
  begin
    ServerID := User.Connector.CharData.ServerID;
    tmpManager := ManagerList.GetManagerByServerID(ServerID);
    if tmpManager <> nil then
    begin
      if (tmpManager.RegenInterval > 0) and (User.SysopScope < 100) then
      begin
        ServerID := tmpManager.TargetServerID;
        User.Connector.CharData.ServerID := ServerID;
        User.Connector.CharData.X := tmpManager.TargetX;
        User.Connector.CharData.Y := tmpManager.TargetY;
        tmpManager := ManagerList.GetManagerByServerID(ServerID);
      end;
    end else
    begin
      ServerID := 1;
      tmpManager := ManagerList.GetManagerByServerID(ServerID);
    end;
  end;

  User.SetManagerClass(tmpManager);
  User.AttribClass.SetAddExpFlag := tmpManager.boGetExp;
  User.HaveMagicClass.SetAddExpFlag := tmpManager.boGetExp;

  Result := User.InitialLayer(aCharName);

  User.Initial(aCharName);

  NameKey.Insert(aCharName, User);
  DataList.Add(User);

  Result := true;
end;

procedure TUserList.StartChar(aCharname: string);
var
  User: TUser;
begin
    //名字 查询 地址
  User := NameKey.Select(aCharName);
  if User <> nil then
  begin
    User.StartProcess;
    exit;
  end;
  frmMain.WriteLogInfo('TUserList.StartChar () failed');
end;

// procedure TUserList.FinalLayer (aCharName: string);

procedure TUserList.FinalLayer(aConnector: TConnector);
var
  i: integer;
  Name: string;
  User: TUser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.Connector = aConnector then
    begin
      Name := User.Name;
      User.FinalLayer;
      User.EndProcess;
      User.Free;
      DataList.Delete(i);
      NameKey.Delete(Name);
      exit;
    end;
  end;
  frmMain.WriteLogInfo('TUserList.FinalLayer () failed');
end;

procedure TUserList.NotMoveServerID(aServerID: Integer; atime: integer);
var
  i: integer;
  User: TUser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.ServerID = aServerID then
    begin
      User.LockNotMove(atime);
      User.SendClass.lockmoveTime(atime);
    end;
  end;
end;

procedure TUserList.SayByServerID(aServerID: Integer; aStr: string);
var
  i: integer;
  User: TUser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.ServerID = aServerID then
    begin
      User.SendClass.SendChatMessage(aStr, SAY_COLOR_NORMAL);
    end;
  end;
end;

function TUserList.MapUserCount(aServerID: Integer): integer;
var
  i: integer;
  User: TUser;
begin
  result := 0;
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.ServerID = aServerID then
    begin
      inc(result);
    end;
  end;
end;

procedure TUserList.ClearMagicDelCount;
var
  i: integer;
  User: TUser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    User.ClearDElMagic;
  end;
end;

procedure TUserList.SendChatMessage_ServerID(aServerID: Integer; asay: string; acolor: integer);
var
  i: integer;
  User: TUser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.ServerID = aServerID then
    begin
      User.SendClass.SendChatMessage(asay, acolor);
    end;
  end;
end;

procedure TUserList.MoveByServerID(aServerID: Integer; aTargetID, aTargetX, aTargetY: Integer);
var
  i: integer;
  User: TUser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.ServerID = aServerID then
    begin
        {
            User.boNewServer := true;
            User.ServerID := aTargetID;
            User.PosMoveX := aTargetX;
            User.PosMoveY := aTargetY;}
      User.MoveToMap(aTargetID, aTargetX, aTargetY, 0);

    end;
  end;
end;

procedure TUserList.BoothClose();
var
  i: integer;
  User: TUser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.SpecialWindow = WINDOW_Booth_edit then User.Booth_Edit_Close;
        //if User.BasicData.boNotHit then User.BasicData.boNotHit := false;
  end;
end;

procedure TUserList.GuildSay(aGuildName, aStr: string);
var
  i: integer;
  User: TUser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.GuildName = aGuildName then
    begin
      User.SendClass.SendChatMessage(aStr, SAY_COLOR_NORMAL);

    end;
  end;
end;

procedure TUserList.GuildSayNUM(aGuildName: string; astr: integer);
var
  i: integer;
  User: TUser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.GuildName = aGuildName then
    begin
            //  User.SendClass.SendChatMessage(aStr, SAY_COLOR_NORMAL);
      User.SendClass.SendNUMSAY(astr, SAY_COLOR_NORMAL);
    end;
  end;
end;

procedure TUserList.GuildSetLifeData(aGuildName: string);
var
  i: integer;
  User: TUser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.GuildName = aGuildName then
    begin
      User.SetLifeData;
    end;
  end;
end;

procedure TUserList.GuildSendData(aGuildName: string; var ComData: TWordComData);
var
  i: integer;
  User: TUser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.GuildName = aGuildName then
    begin
      User.SendClass.SendData(ComData);
    end;
  end;
end;
//灭门 通告

procedure TUserList.GuildSendDelAll(aGuildName: string);
var
  i: integer;
  User: TUser;
  tempsend: TWordComData;
begin
  tempsend.Size := 0;

  WordComData_ADDbyte(tempsend, SM_GUILD);
  WordComData_ADDbyte(tempsend, GUILD_list_ForceDelAll);
  SendTopMSG(WinRGB(31, 31, 31), format('%s %s 门派被灭', [aGuildName, datetimetostr(now)]));
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.GuildName = aGuildName then
    begin
      User.GuildDel;
      User.SendClass.SendData(tempsend);
      User.BocChangeProperty;
    end;

  end;
end;

procedure TUserList.SendALLdata(var ComData: TWordComData);
begin
  GateConnectorList.AddSendDataForAll(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TUserList.SendCenterMSG(acolor: word; astr: string; atype: byte);
var
  ComData: TWordComData;
  cnt: integer;
  PSShowCenterMsg: PTSShowCenterMsg;
begin
  PSShowCenterMsg := @ComData.Data;
  with PSShowCenterMsg^ do
  begin
    rmsg := SM_SHOWCENTERMSG;
    rColor := (acolor);
    rtype := atype;
    SetWordString(rText, astr);
    ComData.Size := sizeof(TSShowCenterMsg) - sizeof(TWordString) + sizeofwordstring(rText);
  end;

  GateConnectorList.AddSendDataForAll(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TUserList.SendRollMSG(acolor: word; astr: string);
begin
  SendCenterMSG(acolor, astr, SHOWCENTERMSG_RollMSG);
end;

procedure TUserList.SendTopMSG(acolor: word; astr: string);
begin
  SendCenterMSG(acolor, astr, SHOWCENTERMSG_BatMsgTOP);
end;

procedure TUserList.SendNoticeMessage2(aStr: string; aFColor, aBColor: word);
var
  ComData: TWordComData;
  cnt: integer;
  psChatMessage: PTSChatMessage;
begin
  psChatMessage := @ComData.Data;
  with psChatMessage^ do
  begin
    rmsg := SM_CHATMESSAGE;
    rFColor := (aFColor);
    rBColor := (aBColor);
    SetWordString(rWordstring, aStr);
    ComData.Size := Sizeof(TSChatMessage) - Sizeof(TWordString) + sizeofwordstring(rWordString);
  end;

  GateConnectorList.AddSendDataForAll(@ComData, ComData.Size + SizeOf(Word));
end;

procedure TUserList.SendNoticeMessage(aStr: string; aColor: Integer);
var
  ComData: TWordComData;
  cnt: integer;
  psChatMessage: PTSChatMessage;
begin
  psChatMessage := @ComData.Data;
  with psChatMessage^ do
  begin
    rmsg := SM_CHATMESSAGE;
    case aColor of
      SAY_COLOR_NORMAL:
        begin
          rFColor := WinRGB(22, 22, 22);
          rBColor := WinRGB(0, 0, 0);
        end;
      SAY_COLOR_SHOUT:
        begin
          rFColor := WinRGB(22, 22, 22);
          rBColor := WinRGB(0, 0, 24);
        end;
      SAY_COLOR_SYSTEM:
        begin
          rFColor := WinRGB(22, 22, 0);
          rBColor := WinRGB(0, 0, 0);
        end;
      SAY_COLOR_NOTICE:
        begin
          rFColor := WinRGB(255 div 8, 255 div 8, 255 div 8);
          rBColor := WinRGB(133 div 8, 133 div 8, 133 div 8);
        end;

      SAY_COLOR_GRADE0:
        begin
          rFColor := WinRGB(18, 16, 14);
          rBColor := WinRGB(2, 4, 5);
        end;
      SAY_COLOR_GRADE1:
        begin
          rFColor := WinRGB(26, 23, 21);
          rBColor := WinRGB(2, 4, 5);
        end;
      SAY_COLOR_GRADE2:
        begin
          rFColor := WinRGB(31, 29, 27);
          rBColor := WinRGB(2, 4, 5);
        end;
      SAY_COLOR_GRADE3:
        begin
          rFColor := WinRGB(22, 18, 8);
          rBColor := WinRGB(1, 4, 11);
        end;
      SAY_COLOR_GRADE4:
        begin
          rFColor := WinRGB(23, 13, 4);
          rBColor := WinRGB(1, 4, 11);
        end;
      SAY_COLOR_GRADE5:
        begin
          rFColor := WinRGB(31, 29, 21);
          rBColor := WinRGB(1, 4, 11);
        end;

    else
      begin
        rFColor := WinRGB(22, 22, 22);
        rBColor := WinRGB(0, 0, 0);
      end;
    end;

    SetWordString(rWordstring, aStr);
    ComData.Size := Sizeof(TSChatMessage) - Sizeof(TWordString) + sizeofwordstring(rWordString);
  end;

  GateConnectorList.AddSendDataForAll(@ComData, ComData.Size + SizeOf(Word));
end;

function TUserList.GetCount: integer;
begin
  Result := DataList.Count;
end;

function TUserList.GetUserList: string;
begin
  Result := format('<线上人数> %d名。', [ConnectorList.Count]) + #13;
end;

function TUserList.GetUserPointer(aCharName: string): TUser;
begin
  Result := NameKey.Select(aCharName);
end;

function TUserList.GetUserPointerById(aId: LongInt): TUser;
var
  i: integer;
  User: TUser;
begin
  Result := nil;
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.BasicData.Id = aId then
    begin
      Result := User;
      exit;
    end;
  end;
end;

procedure TUserList.SendRaining(aRain: TSRainning);
var
  i: integer;
  User: TUser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.Manager.boWeather = true then
    begin
      User.SendClass.SendRainning(aRain);
    end;
  end;
end;

procedure TUserList.Update(CurTick: integer);
var
  cnt: integer;
  pld: PTLeaveData;

  i, m: integer;
  Name: string;
  User: TUser;
  StartPos: integer;
begin
    //   UserProcessCount := (DataList.Count * 4 div 100);
      // if UserProcessCount = 0 then UserProcessCount := DataList.Count;

  UserProcessCount := ProcessListUserCount;

  if DataList.Count > 0 then
  begin
    StartPos := CurProcessPos;
    for i := 0 to UserProcessCount - 1 do
    begin
      if CurProcessPos >= DataList.Count then CurProcessPos := 0;
      User := DataList.Items[CurProcessPos];
      try
        User.Update(CurTick);
      except
        User.Exception := true;
        Name := User.Name;
        frmMain.WriteLogInfo(format('TUser.Update (%s) exception', [Name]));
        ConnectorList.CloseConnectByCharName(Name);
        exit;
      end;

      Inc(CurProcessPos);
      if CurProcessPos = StartPos then break;
    end;
  end;
end;

{
function TUserList.FieldProc2 (hfu: Longint; Msg: word; var SenderInfo: TBasicData; var aSubData: TSubData): Integer;
var
   i: integer;
   User : TUser;
begin
   Result := PROC_FALSE;
   for i := 0 to TvList.Count - 1 do begin
      User := TvList.Items [i];
      User.FieldProc2 (hfu, msg, SenderInfo, aSubdata);
   end;
end;
}

procedure TUserList.SaveUserInfo(aFileName: string);
var
  i: Integer;
  Stream: TFileStream;
  User: TUser;
  Str: string;
  buffer: array[0..1024] of char;
begin
  if FileExists(aFileName) then DeleteFile(aFileName);
  try
    Stream := TFileStream.Create(aFileName, fmCreate);
  except
    exit;
  end;

  Str := 'Name,MasterName,Guild,Map,X,Y,IpAddr,Ver,Pay' + #13#10;
  StrPCopy(@buffer, Str);
  Stream.WriteBuffer(buffer, StrLen(buffer));
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    Str := User.Name + ',' + User.Connector.LoginID + ',' + User.GuildName + ',' + User.Manager.Title + ',' + IntToStr(User.BasicData.X) + ',' + IntToStr(User.BasicData.Y) + ',';
    Str := Str + User.Connector.IpAddr + ',' + IntToStr(User.Connector.VerNo) + ',' + IntToStr(Byte(User.Connector.PaidType)) + #13#10;
    StrPCopy(@buffer, Str);
    Stream.WriteBuffer(buffer, StrLen(buffer));
  end;

  Stream.Free;
end;

procedure TUserList.SendSoundEffect(aManager: TManager; aSoundEffect: integer);
var
  i: Integer;
  Manager: TManager;
  User: TUser;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    User := DataList.Items[i];
    if User.Manager = aManager then
    begin
            //            User.SendClass.SendSoundEffect(aSoundEffect + '.wav', User.BasicData.X, User.BasicData.Y);
      User.SendClass.SendSoundEffect(aSoundEffect, User.BasicData.X, User.BasicData.Y);
    end;
  end;
end;

function callfunc01(str: string; BasicData, SenderInfo: TBasicData): string;
var
  str1, str2, str3: string;
  cnt: integer;
begin
    // if BasicData = nil then exit;
  if not ReverseFormat(str, '%s %s', str1, str2, str3, 2) then exit;
  str := str2;
  if pos('get', str1) = 1 then
  begin
    if str = 'getname' then
    begin
      result := (BasicData.Name);
    end;
  end
  else if str = 'getname' then
  begin

  end;

end;

////////////////////////////////////////////////////////////////////////////////
//                            脚本
////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
//                       2009 4 8   callfunc群脚本指令 独立单一指令

//RACE_NONE = 0; RACE_HUMAN = 1;人(类)RACE_ITEM = 2;//物品RACE_MONSTER = 3;//怪物RACE_NPC = 4;//NPC RACE_DYNAMICOBJECT = 5;//动态 对象RACE_STATICITEM = 6;

function GetObjectType(uObject: integer): integer;
var
  temp: TBasicObject;
begin
  result := -1;
  if not (TObject(uObject) is TBasicObject) then exit;
  temp := TBasicObject(uObject);
  result := temp.BasicData.Feature.rrace;
end;

function getMapID(uObject: integer): integer;
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := User.ServerID;
end;

function getMaxLife(uObject: integer): integer;
var
  aBasicObject: TBasicObject;
begin
  result := 0;
  if not (TObject(uObject) is TBasicObject) then exit;
  aBasicObject := TBasicObject(uObject);
  if aBasicObject.BasicData.Feature.rrace = RACE_HUMAN then
  begin
    result := TUser(uObject).AttribClass.MaxLife;
    exit;
  end;
  if (aBasicObject.BasicData.Feature.rrace = RACE_MONSTER)
    or (aBasicObject.BasicData.Feature.rrace = RACE_NPC) then
  begin
    result := TLifeObject(uObject).getMaxLife;
    exit;
  end;
end;

function getCurLife(uObject: integer): integer;
var
  aBasicObject: TBasicObject;
begin
  result := 0;
  if not (TObject(uObject) is TBasicObject) then exit;
  aBasicObject := TBasicObject(uObject);
  if aBasicObject.BasicData.Feature.rrace = RACE_HUMAN then
  begin
    result := TUser(uObject).AttribClass.CurLife;
    exit;
  end;
  if (aBasicObject.BasicData.Feature.rrace = RACE_MONSTER)
    or (aBasicObject.BasicData.Feature.rrace = RACE_NPC) then
  begin
    result := TLifeObject(uObject).getCurLife;
    exit;
  end;
end;

function addItemLog(uObject: integer): boolean; //增加仓库
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := User.ItemLog.CreateRoom;
end;

function getItemLogCount(uObject: integer): integer;
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := User.ItemLog.GetCount;
end;

function getsex(uObject: integer): integer; //性别 返回：-1  失败   1  男  2 女
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if User.BasicData.Feature.rboman then
    result := 1 else result := 2;
end;


function getage(uObject: integer): integer; //年龄 返回：-1  失败   >=0年龄
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.GetAge;
end;

function getname(uObject: integer): string; //名字 返回：空  失败  非空名字
var
  USER: TUser;
begin
  result := '';
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.name;
end;

function getwearitemviewnamename(uObject: integer; akey: integer): string; //身上装备(显示)名字 参数：akey位置 返回：空  失败  非空名字
var
  USER: TUser;
  aTItemData: TItemData;
begin
  result := '';
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if USER.WearItemClass.ViewItem(akey, @aTItemData) then
    result := aTItemData.rViewName;
end;

function getwearitemname(uObject: integer; akey: integer): string; //身上装备（真实）名字 参数：akey位置 返回：空  失败  非空名字
var
  USER: TUser;
  aTItemData: TItemData;
begin
  result := '';
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if USER.WearItemClass.ViewItem(akey, @aTItemData) then
    result := aTItemData.rName;
end;

procedure LeftText3(uObject: integer; astr: string; acolor: integer);
var
  USER: TUser;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  acolor := ColorSysToDxColor(acolor);
  user.SendClass.SendLeftText(astr, acolor, mtLeftText3);
end;

procedure LeftText2(uObject: integer; astr: string; acolor: integer);
var
  USER: TUser;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  acolor := ColorSysToDxColor(acolor);
  user.SendClass.SendLeftText(astr, acolor, mtLeftText2);
end;

procedure LeftText1(uObject: integer; astr: string; acolor: integer);
var
  USER: TUser;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  acolor := ColorSysToDxColor(acolor);
  user.SendClass.SendLeftText(astr, acolor, mtLeftText);
end;

 //设置物品孔数

function setItemSettingCount(uObject: integer; akey: integer; acount: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.Updatesettingcount(akey, acount);

end;
//增加背包物品孔数量 参数：aitemname物品名字  返回：true成功
//孔数量SettingCount，星级StarLevel，精炼等级SmithingLevel，附加属性Attach，制造者名字createname，染色颜色color，持久rDurability  <0不改变，其他的<=0不改变

function addItemEx(uObject: integer; aitemname, acreatename: string; aStarLevel, aSmithingLevel, aSettingCount, aAttach, aDurability, acolor: integer): boolean;
var
  USER: TUser;
  aTItemData: TItemData;
begin
  result := false;
  aitemname := trim(aitemname);
  if aitemname = '' then exit;

  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if not ItemClass.GetItemData(aitemname, aTItemData) then exit;


  //aTItemData.rCount := acount;
  if (aTItemData.rKind <> ITEM_KIND_WEARITEM)
//        and (aTItemData.rKind <> ITEM_KIND_WEARITEM2)
//        and (aTItemData.rKind <> ITEM_KIND_WEARITEM_29)
  and (aTItemData.rKind <> ITEM_KIND_WEARITEM_GUILD) then exit;

  NewItemSet(_nist_all, aTItemData);
  if aTItemData.rWearArr = ARR_WEAPON then
  begin
    if aSettingCount > 2 then aSettingCount := 2;
  end else
  begin
    if aSettingCount > 4 then aSettingCount := 4;
  end;
  if aSettingCount > 0 then
  begin
    aTItemData.rSetting.rsettingcount := aSettingCount;
    aTItemData.rboident := false;
  end;

  if (aStarLevel > 0) and (aStarLevel <= aTItemData.rStarLevelMax) then aTItemData.rStarLevel := aStarLevel;
  if (aSmithingLevel > 0) and (aSmithingLevel <= aTItemData.MaxUpgrade) then aTItemData.rSmithingLevel := aSmithingLevel;

  if (acolor > 0) then aTItemData.rcolor := acolor;

  if aDurability > aTItemData.rDurability then aDurability := aTItemData.rDurability;
  if aDurability >= 0 then aTItemData.rCurDurability := aDurability;

  if acreatename <> '' then aTItemData.rcreatename := copy(acreatename, 1, 20);
  if (aAttach > 0) then
  begin
    if ItemLifeDataClass.get('X附加' + inttostr(aAttach)) <> nil then
      aTItemData.rAttach := aAttach;
    aTItemData.rboident := false;
  end;
  result := user.ItemScripterADDITEM(@aTItemData);
end;

function additem(uObject: integer; aitemname: string; acount: integer): boolean; //增加背包物品数量 参数：aitemname物品名字 acount 数量 返回：true成功
var
  USER: TUser;
  aTItemData: TItemData;
begin
  result := false;
  aitemname := trim(aitemname);
  if aitemname = '' then exit;
  if acount <= 0 then exit;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if not ItemClass.GetItemData(aitemname, aTItemData) then exit;

  aTItemData.rCount := acount;
  NewItemSet(_nist_all, aTItemData);
  result := user.ItemScripterADDITEM(@aTItemData);
end;

function deleteItemKey(uObject: integer; akey, acount: integer): boolean; //删除背包物品数量 参数：akey位置 acount 数量 返回：true成功
var
  USER: TUser;
begin
  result := false;
  if acount <= 0 then exit;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.ItemScripterDeleteItemKey(akey, acount);
end;

function deleteitem(uObject: integer; aitemname: string; acount: integer): boolean; //删除背包物品数量 参数：aitemname物品名字 acount 数量(<=0 表示有全部删除) 返回：true成功
var
  USER: TUser;
  aTItemData: TItemData;
begin
  result := false;
  aitemname := trim(aitemname);
  if aitemname = '' then exit;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.ViewItemName(aitemname, @aTItemData) = FALSE then exit;
  if acount > 0 then aTItemData.rCount := acount;
  result := user.ItemScripterDeleteItem(@aTItemData);
end;



function getitemcount(uObject: integer; aitemname: string): integer; //背包物品数量 参数：aitemname物品名字 返回：-1  失败   >=0数量
var
  USER: TUser;
  aTItemData: TItemData;
begin

  result := -1;
  aitemname := trim(aitemname);
  if aitemname = '' then exit;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.ViewItemName(aitemname, @aTItemData) then
    result := aTItemData.rCount;
end;



function getmarryinfo(uObject: integer): boolean; //获取 结婚状态    返回：true是
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := marriedlist.IsMarried(user.name);
end;

function getparty(uObject: integer): boolean; //获取 结婚当事人   返回：true是
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := Marriage.IsParty(user.name);
end;

function getmarryclothes(uObject: integer): boolean; //获取过结婚礼物  返回：  TRUE领取
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := marriedlist.IsClothes(user.name);
end;

function getmarriage(uObject: integer): boolean; // 获取 婚礼状态    TRUE结婚
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := marriedlist.ISMarriage(user.name);
end;

function MapMove(uObject: integer; amapid: integer; ax, ay, aDelayTick: integer): boolean; //移动指定目标到指定位置    参数 amapid 地图序号 AX AY 坐标 返回：true命令下达成功（不表示传送成功）
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if ManagerList.GetManagerByServerID(amapid) = nil then exit;
  user.MoveToMap(amapid, ax, ay, aDelayTick);
  result := true;
end;

function Marry(uObject: integer; atext: string): boolean; //结婚    参数 atext 附带消息  返回：TRUE指令成功发出
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  marriedlist.MarryInput(user, atext);
  result := true;
end;

function unmarry(uObject: integer): boolean; //离婚    参数 amarryname 对象  返回：TRUE指令成功发出
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  marriedlist.unMarryInput(user);
  result := true;
end;

function setmarryclothes(uObject: integer): boolean; //设置 已经拿过礼服
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  marriedlist.SetClothes(user.name);
  result := true;
end;

function setauditoria(uObject: integer): boolean; //设置 礼堂进行结婚仪式，设置成功后会被记录 可查询
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  marriedlist.SetAuditoria(user.name);
  result := true;
end;

function showmarriage(uObject: integer; astr: string; atype: integer): boolean; //弹出 输入婚礼问答筐 参数：astr内容 atype 1要求男的回答 2要求女的回答（内容记录在结婚系统） 应答是或者不是后，系统公告 内容和答案
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  Marriage.showmarriage(astr, atype);
  result := true;
end;

function showsetofficiator(uObject: integer; aname: string): boolean; //设置 主婚人 uSource人 弹出输入筐 设置成功系统公告
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  Marriage.showsetofficiator(user, aname);
  result := true;
end;

function MonsterCheck(uObject: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := USER.MonsterCheck;
end;

function MonsterCreate(uObject: integer; aMonsterName: string): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  USER.MonsterAdd(aMonsterName);
  result := true;
end;

function MonsterFree(uObject: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  USER.MonsterClear;
  result := true;
end;

function NewCounterAttack_hit(uObject: integer; astate: boolean; atime: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  USER.fcounterattack_state := astate;
  USER.fCounterAttack_datetime := mmAnsTick + atime * 100 * 60 * 60;
  result := true;
end;
//==公共指令

procedure marriagebulletin(astr: string); //发布 婚礼 公告 参数：astr 消息内容
begin
  UserList.SendTopMSG(WinRGB(28, 28, 28), astr);
end;

function getauditoria(): boolean; //获取 礼堂 状态    TRUE占用
begin
  result := Marriage.IsAuditoria();
end;

function setmarriageend(): boolean; //设置 婚礼完成空出教堂  没返回值
begin
  Marriage.Clear;
end;

function setmarrystep(astep: integer): boolean; //设置 当前第几步骤。  字符行数字
begin
  Marriage.setmarrystep(astep);
end;

function getofficiator(): string; //获取 主婚人
begin
  result := Marriage.getofficiator;
end;

function getmarrystep(): integer; //获取 当前第几步骤。 返回：-1 失败
begin
  result := Marriage.getmarrystep();
end;

function getpartymanname(): string; //获取 新郎名字
begin
  result := Marriage.getManName();
end;

function getpartywomanname(): string; //获取 新娘名字
begin
  result := Marriage.getWomanName();
end;
///////////////////////////////////////////////////////////////////
//        结束段 2009 4 8   callfunc群脚本指令 独立单一指令
///////////////////////////////////////////////////////////////////

procedure MenuSay(uObject: integer; SAYTEXT: string);
var
  USER: TUser;
  sname: string;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  USER.ShowNPCSAYWindow(SAYTEXT);
end;

procedure centermsg(atext: string; acolor: integer);
begin
  UserList.SendCenterMSG(ColorSysToDxColor(acolor), atext, SHOWCENTERMSG_BatMsg);
end;

procedure worldnoticemsg(atext: string; afcolor, abcolor: integer);
begin
  UserList.SendNoticeMessage2(atext, ColorSysToDxColor(afcolor), ColorSysToDxColor(abcolor));
end;

procedure topmsg(atext: string; acolor: integer);
begin
  UserList.SendTopMSG(ColorSysToDxColor(acolor), atext);
end;

procedure topyoumsg(uObject: integer; atext: string; acolor: integer);
var
  USER: TUser;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.SendClass.SendTopMSG(ColorSysToDxColor(acolor), atext);
end;

procedure saysystem(uObject: integer; SAYTEXT: string);
var
  USER: TUser;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  USER.SendClass.SendChatMessage(SAYTEXT, SAY_COLOR_SYSTEM);
end;

procedure SAY(uObject: integer; SAYTEXT: string);
var
  ttBasicObject: TBasicObject;
begin
    //NPC  人都可以
  if not (TObject(uObject) is TBasicObject) then exit;
  ttBasicObject := TBasicObject(uObject);
  ttBasicObject.BocSay(SAYTEXT);

end;

function Random(aScope: integer): integer;
begin
  result := system.Random(aScope);
end;
//获取任务预设定物品 名字aname 数量acount；akey预定位置，aqid任务ID

function getQuestMainItem(aqid, akey: integer; var aname: string; var acount: integer): boolean;
begin
  result := QuestMainList.getQuestMainItem(aqid, akey, aname, acount);
end;

function getQuestSubItem(aqid, aqsubid, akey: integer; var aname: string; var acount: integer): boolean;
begin
  result := QuestMainList.getQuestSubItem(aqid, aqsubid, akey, aname, acount);
end;

function getQuestMainTitle(aqid: integer): string;
begin
  result := QuestMainList.getQuestMainTitle(aqid);
end;

function getQuestMaintext(aqid: integer): string;
begin
  result := QuestMainList.getQuestMaintext(aqid);
end;

function getQuestSubTitle(aqid, aqsubid: integer): string;
begin
  result := QuestMainList.getQuestSubTitle(aqid, aqsubid);
end;

function getQuestSubRequest(aqid, aqsubid: integer): string;
begin
  result := QuestMainList.getQuestSubRequest(aqid, aqsubid);
end;

function getQuestSubtext(aqid, aqsubid: integer): string;
begin
  result := QuestMainList.getQuestSubtext(aqid, aqsubid);
end;

function getQuestNo(uObject: integer): integer; //获取 完成任务ID 返回值
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := USER.FCompleteQuestNo;
end;

procedure setQuestNo(uObject, qid: integer); //设置 完成任务ID
var
  USER: TUser;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  USER.FCompleteQuestNo := qid;

end;

function getQueststep(uObject: integer): integer; //获取 任务步骤ID
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := USER.FQueststep;
end;

procedure setQueststep(uObject, qstep: integer); //设置 任务步骤ID
var
  USER: TUser;
begin

  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  USER.FQueststep := qstep;
  QuestMainList.userGetQuestList(user);
end;

function getQuestCurrentNo(uObject: integer): integer; // 获取 当前任务ID
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := USER.FCurrentQuestNo;
end;

procedure setQuestCurrentNo(uObject, qid: integer); // 设置 当前任务ID
var
  USER: TUser;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  USER.FCurrentQuestNo := qid;

end;

function getQuestTempArr(uObject: integer; aindex: integer): integer; //获取 任务临时变量值
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if (aindex < 0) or (aindex > high(user.Connector.CharData.QuesttempArr)) then exit;
  result := user.Connector.CharData.QuesttempArr[aindex];
end;

function SETQuestTempArr(uObject: integer; aindex, aValue: integer): boolean; //设置任务临时变量值
var
  USER: TUser;
begin
  result := FALSE;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if (aindex < 0) or (aindex > high(user.Connector.CharData.QuesttempArr)) then exit;

  user.Connector.CharData.QuesttempArr[aindex] := aValue;
  user.SendClass.SendQuestTempArr(aindex);

  RESULT := TRUE;
end;

function getRegSubQuestSum(uObject: integer): integer; //获取分支任务 当前完成数量
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);

  result := Questreglist.getSubQuestcount(user.name);
end;

procedure setRegSubQuest(uObject, qID, atime: integer); //注册分支任务 qID任务ID， atime过期小时
var
  USER: TUser;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  Questreglist.setSubQuestReg(user.name, qid, atime);
end;

function getSubQueststep(uObject: integer): integer; //获取分支任务 任务步骤ID
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);

  result := user.FSubQueststep;
end;

procedure setSubQueststep(uObject, qstep: integer); //设置分支任务 任务步骤ID
var
  USER: TUser;
begin

  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);

  user.FSubQueststep := qstep;
  QuestMainList.userGetQuestList(user);
end;

function getSubQuestCurrentNo(uObject: integer): integer; //获取分支任务 当前任务ID
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);

  result := user.FSubCurrentQuestNo;
end;

procedure setSubQuestCurrentNo(uObject, qid: integer); //设置分支任务 当前任务ID
var
  USER: TUser;
begin

  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.FSubCurrentQuestNo := qid;

end;

function getRegSubQuestIdCount(uObject, qid: integer): integer; //获取分支任务 是否做过
var
  USER: TUser;
  p: pTQuestregdata;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := Questreglist.getSubQuest(user.name, qid);
  if p = nil then exit;
  result := p.rCount;
end;

function SubQuestRegAdd(uObject, qid: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  Questreglist.SubQuestRegAddCount(user.name, qid);
  result := true;
end;

procedure setServerTempVar(aqid: integer; anum: integer);
begin
  if (aqid < 0) or (aqid > high(vServerTempVarArr)) then exit;
  vServerTempVarArr[aqid] := anum;
end;

function getServerTempVar(aqid: integer): integer;
begin
  result := -1;
  if (aqid < 0) or (aqid > high(vServerTempVarArr)) then exit;
  result := vServerTempVarArr[aqid];
end;

procedure setQuestdata_Server(aqid: integer; aTEXT: string; anum: integer);
begin
  Questreglist.FQReg_server.setData(aqid, aTEXT, anum);
end;

function getQuestdata_Server(aqid: integer;
  var aTEXT: string; var adate: tdatetime; var anum: integer): boolean;
begin
  result := Questreglist.FQReg_server.getData(aqid, aTEXT, adate, anum);
end;
//获得元气

function getEnergyCalc(uObject: integer): integer; //元气 计算值（玩家看到的值）
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.AttribClass.AQgetEnergy;
end;

function getEnergyLevel(uObject: integer): integer;
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.AttribClass.PowerLevelMax; //PowerLevelClass.getMax(user.AttribClass.getEnergy);
end;

function getEnergy(uObject: integer): integer;
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.AttribClass.getEnergy;
end;
//设置元气

procedure SetEnergy(uObject, qid: integer);
var
  USER: TUser;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if qid <= 0 then exit;
  USER.AttribClass.SetEnergy(qid);
end;

function getprestige(uObject: integer): integer;
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.AttribClass.prestige;
end;

procedure setprestige(uObject, qid: integer);
var
  USER: TUser;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.AttribClass.prestige := qid;
end;

function getuserAttackMagic(uObject: integer): string; //攻击
var
  USER: TUser;
begin
  result := '';
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.HaveMagicClass.pCurAttackMagic <> nil then
    result := user.HaveMagicClass.pCurAttackMagic.rname;
end;

function getuserBreathngMagic(uObject: integer): string; //心法
var
  USER: TUser;
begin
  result := '';
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.HaveMagicClass.pCurBreathngMagic <> nil then
    result := user.HaveMagicClass.pCurBreathngMagic.rname;
end;

function getuserRunningMagic(uObject: integer): string; //步法
var
  USER: TUser;
begin
  result := '';
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.HaveMagicClass.pCurRunningMagic <> nil then
    result := user.HaveMagicClass.pCurRunningMagic.rname;
end;

function getuserProtectingMagic(uObject: integer): string; //防护
var
  USER: TUser;
begin
  result := '';
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.HaveMagicClass.pCurProtectingMagic <> nil then
    result := user.HaveMagicClass.pCurProtectingMagic.rname;
end;

function getMagictype(uObject: integer; aMagicname: string): integer; //获取 武功 类型
var
  USER: TUser;
  temp: PTMagicData;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  temp := user.HaveMagicClass.All_FindName(aMagicname);
  if temp <> nil then
    result := temp.rMagicType;
end;

function AddMagicExp(uObject: integer; aname: string; aexp: integer): integer;
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.AddMagicExp(aname, aexp);
end;

//返回武功所有满级增加的元气和

function getMagic_ALlEnergy(uObject: integer): integer;
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveMagicClass.All_MagicEnerySum;
end;

function getMagicExp(uObject: integer; aname: string): integer;
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.getMagicExp(aname);
end;

function getMagicLevel(uObject: integer; aname: string): integer;
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.getMagicLevel(aname);
end;

function IsMagic(uObject: integer; aname: string): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveMagicClass.All_FindName(aname) <> nil;

end;

function GuildGetName(uObject: integer): string;
var
  USER: TUser;
begin
  result := '';
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject <> nil then
    result := Tguildobject(user.uGuildObject).GuildName;

end;

function GuildLifeDataAdditem(uObject: integer; aitemname: string): boolean; //物品附加属性
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  if Tguildobject(user.uGuildObject).IsGuildSysop(user.name) = false then exit;
  if Tguildobject(user.uGuildObject).LifeDataAdditem(aitemname) = false then exit;
  result := true;
end;

function GuildIsGuildSysop(uObject: integer): boolean; //测试 是否 是门主
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  if Tguildobject(user.uGuildObject).IsGuildSysop(user.name) = false then exit;
  result := true;
end;

function GuildIsGuildSubSysop(uObject: integer): boolean; //测试 是否 是副门主
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  if Tguildobject(user.uGuildObject).IsGuildSubSysop(user.name) = false then exit;
  result := true;
end;

function GuildGetDurabilityMax(uObject: integer): integer; //获得最大血量
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  result := Tguildobject(user.uGuildObject).getLifeMax;
end;

function GuildSetDurabilityMax(uObject: integer; value: integer): boolean; //设置最大血量
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  Tguildobject(user.uGuildObject).setlifeMax(value);
  Result := true;
end;

function GuildSetDurability(uObject: integer; value: integer): boolean; //设置当前血量
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  Tguildobject(user.uGuildObject).setlife(value);
  Result := true;
end;

function GuildGetDurability(uObject: integer): integer; //获得当前血量
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  result := Tguildobject(user.uGuildObject).getLife;
end;

function GuildGetEnegy(uObject: integer): integer; //获得元气
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  result := Tguildobject(user.uGuildObject).Enegy;

end;

function GuildEnegyAdd(uObject: integer; anum: integer): boolean; //增加元气
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  Tguildobject(user.uGuildObject).Enegy := Tguildobject(user.uGuildObject).Enegy + anum;
  result := true;
end;

function GuildEnegyDec(uObject: integer; anum: integer): boolean; //减少元气
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  Tguildobject(user.uGuildObject).Enegy := Tguildobject(user.uGuildObject).Enegy - anum;
  result := true;
end;

function GuildGetLevel(uObject: integer): integer; //获得等级
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  result := Tguildobject(user.uGuildObject).level;

end;

function GuildLevelAdd(uObject: integer; anum: integer): boolean; //增加等级
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  if Tguildobject(user.uGuildObject).IsGuildSysop(user.name) = false then exit;
  Tguildobject(user.uGuildObject).level := Tguildobject(user.uGuildObject).level + anum;

  result := true;
end;

function GuildLevelDec(uObject: integer; anum: integer): boolean; //减少等级
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;
  Tguildobject(user.uGuildObject).level := Tguildobject(user.uGuildObject).level - anum;
  result := true;
end;

function SetTLifeObjectRegenInterval(uObject: integer; aRegenInterval: integer): boolean; //指定 怪物 NPC 复活时间
var
  aObject: TLifeObject;
begin
  result := false;
  if not (TObject(uObject) is TLifeObject) then exit;
  aObject := TLifeObject(uObject);
  aObject.RegenInterval := aRegenInterval;
  result := true;
end;

function addGuildMagic(uObject: integer): boolean; //增加门派武功
var
  USER: TUser;
  aname: string;
  MagicData: tMagicData;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uGuildObject = nil then exit;

  aname := Tguildobject(user.uGuildObject).GetGuildMagicString;

  if MagicClass.GetMagicData(aname, MagicData, 0) = false then exit;
  if user.AddMagic(@MagicData) = false then exit;

  result := true;

end;

function addMagic(uObject: integer; amagicname: string): boolean; //增加武功
var
  USER: TUser;
  MagicData: tMagicData;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);

  if MagicClass.GetMagicData(amagicname, MagicData, 0) = false then exit;
  if user.AddMagic(@MagicData) = false then exit;

  result := true;

end;


function addVirtueExp(uObject: integer; aexp, aMaxLevel: integer): boolean; //增加浩然 经验，（不是等级）  aexp经验, aMaxLevel本次增加不能超过的浩然等级
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.AttribClass.addvirtue(aexp, aMaxLevel);
  result := true;
end;

function WearGETRepairGoldSum(uObject: integer): integer; //身上维修需要共计钱
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.WearItemClass.RepairGoldSum;
end;

function WearRepairAll(uObject: integer): boolean; //维修 身上所有装备    不会检查钱和扣钱
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.WearItemClass.RepairAll;
end;


function GetVirtueLevel(uObject: integer): integer; //获取浩然 等级
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.AttribClass.GetVirtueLevel;

end;

function getJobGradeName(uObject: integer): string;
var
  USER: TUser;
  p: pTJobGradeData;
begin
  result := '';
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveMagicClass.JobgetJobGrade;
  if p = nil then exit;
  result := p.ViewName;
end;

function getJobGrade(uObject: integer): integer;
var
  USER: TUser;
  p: pTJobGradeData;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveMagicClass.JobgetJobGrade;
  if p = nil then exit;

  result := p.Grade;
end;

function getJobLevel(uObject: integer): integer;
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveMagicClass.jobGetlevel;

end;

function SetJobLevel(uObject: integer; alevel: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveMagicClass.JobSetLevel(alevel);
end;

function addJobLevelExp(uObject: integer; aExp, aMaxExp: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveMagicClass.JobAddExp(aExp, aMaxExp);
end;

function setJobKind(uObject: integer; aKind: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.HaveMagicClass.jobSetKind(aKind);
  result := true;
end;

function getJobKind(uObject: integer): integer;
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveMagicClass.jobGetKind;

end;

function getitemspace(uObject: integer): integer; //背包 空位
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.SpaceCount;

end;

function getitemPrice(uObject: integer; akey: integer): integer; //背包 某位置 物品 价格
var
  USER: TUser;
  p: ptitemdata;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rPrice;
end;

function getMagicspace(uObject: integer; atype: string): integer; //武功空位  atype=''全部武功包; Magic武功,MagicRise上层;MagicMystery掌法;
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if atype = '' then
  begin
    result := user.HaveMagicClass.MagicSpaceCount
      + user.HaveMagicClass.Rise_MagicSpaceCount
      + user.HaveMagicClass.Mystery_MagicSpaceCount;
  end
  else if atype = 'Magic' then
  begin
    result := user.HaveMagicClass.MagicSpaceCount;
  end
  else if atype = 'MagicRise' then
  begin
    result := user.HaveMagicClass.Rise_MagicSpaceCount;
  end
  else if atype = 'MagicMystery' then
  begin
    result := user.HaveMagicClass.Mystery_MagicSpaceCount;
  end;


end;

function get3f_sky(uObject: integer): integer;
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.AttribClass.get3f_sky;

end;

function get3f_terra(uObject: integer): integer;
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.AttribClass.get3f_terra;

end;

function get3f_fetch(uObject: integer): integer;
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.AttribClass.get3f_fetch;

end;

function set3f_sky(uObject: integer; acount: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if acount <= 0 then acount := 0;
  user.AttribClass.set3f_sky(acount);
  result := true;
  USER.SetLifeData;
end;

function set3f_terra(uObject: integer; acount: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if acount <= 0 then acount := 0;
  user.AttribClass.set3f_terra(acount);
  result := true;
  USER.SetLifeData;
end;

function set3f_fetch(uObject: integer; acount: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if acount <= 0 then acount := 0;
  user.AttribClass.set3f_fetch(acount);
  result := true;
  USER.SetLifeData;
end;

function DeleteMagicName(uObject: integer; aname: string): boolean;
var
  USER: TUser;
begin
  result := false;
  aname := trim(aname);
  if aname = '' then exit;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveMagicClass.DeleteMagicName(aname);
end;

function deletewearitem(uObject: integer; akey: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.WearItemClass.DeleteKeyItem(akey);
end;

function getItemBoident(uObject: integer; akey: integer): boolean;
var
  USER: TUser;
  p: ptitemdata;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rboident;
end;

function setitemboident(uObject: integer; akey: integer; astate: boolean): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.UpBoIdent(akey, astate);

end;

function getTempArr(uObject: integer; aindex: integer): integer; //获取 临时变量值
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if (aindex < 0) or (aindex > high(user.Connector.CharData.tempArr)) then exit;
  result := user.Connector.CharData.tempArr[aindex];
end;

function DesignationSpaceCount(uObject: integer): integer; //称号 空位置
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  RESULT := USER.DesignationClass.SpaceCount;
end;

function DesignationCheck(uObject: integer; aid: integer): boolean; //称号 是否存在
var
  USER: TUser;
begin
  result := FALSE;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  RESULT := USER.DesignationClass.IsCheck(aid);
end;

function DesignationAdd(uObject: integer; aid: integer): boolean; //增加 称号
var
  USER: TUser;
begin
  result := FALSE;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  RESULT := USER.DesignationClass.add(aid);
end;

function SETTempArr(uObject: integer; aindex, aValue: integer): boolean; //设置临时变量值
var
  USER: TUser;
begin
  result := FALSE;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if (aindex < 0) or (aindex > high(user.Connector.CharData.tempArr)) then exit;

  user.Connector.CharData.tempArr[aindex] := aValue;
  RESULT := TRUE;
end;

function ItemInputWindowsOpen(uObject: integer; aSubKey: integer; aCaption: string; aText: string): boolean;
var
  USER: TUser;
begin
  result := FALSE;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.HaveItemClass.ItemInputWindowsOpen(aSubKey, aCaption, aText);
  RESULT := TRUE;
end;

function ItemInputWindowsClose(uObject: integer): boolean;
var
  USER: TUser;
begin
  result := FALSE;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.HaveItemClass.ItemInputWindowsClose;
  RESULT := TRUE;
end;

function setItemInputWindowsKey(uObject: integer; aSubKey: integer; akey: integer): boolean;
var
  USER: TUser;
begin
  result := FALSE;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  RESULT := user.HaveItemClass.setItemInputWindowsKey(aSubKey, akey);
end;

function getItemInputWindowsKey(uObject: integer; aSubKey: integer): integer;
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.GetItemInputWindowsKey(aSubKey);
end;

function ItemUPdataLevel(uObject: integer; akey: integer; alevel, damageBody, damageHead, damageArm, damageLeg, armorBody, armorHead, armorArm, armorLeg, AttackSpeed, avoid, recovery, accuracy: integer): boolean;
//astate TRUE 成功 FALSE 装备回到0级
//akey 背包中的位置
//damageBody, damageHead, damageArm, damageLeg, armorBody, armorHead, armorArm, armorLeg, AttackSpeed, avoid, recovery,  accuracy 13个属性 增加值
var
  USER: TUser;
  tempLifeData: TLifeData;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);

  tempLifeData.damageBody := damageBody;
  tempLifeData.damageHead := damageHead;
  tempLifeData.damageArm := damageArm;
  tempLifeData.damageLeg := damageLeg;

  tempLifeData.armorBody := armorBody;
  tempLifeData.armorHead := armorHead;
  tempLifeData.armorArm := armorArm;
  tempLifeData.armorLeg := armorLeg;

  tempLifeData.AttackSpeed := AttackSpeed;
  tempLifeData.avoid := avoid;
  tempLifeData.recovery := recovery;
  tempLifeData.accuracy := accuracy;
  result := user.HaveItemClass.UPdateItem_UPLevel(akey, alevel, tempLifeData);
end;

function SetItemUPdataLevelNew(uObject: integer; akey: integer; alevel: integer): boolean; ////akey 背包中的位置 alevel等级
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.UPdateItem_UPLevel_New(akey, alevel);
end;

function getitemSmithingLevel(uObject: integer; akey: integer): integer; //背包 某位置 物品 精炼等级
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rSmithingLevel;
end;

function getitemSmithingLevelMax(uObject: integer; akey: integer): integer; //背包 某位置 物品 精炼等级最高等级
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.MaxUpgrade;
end;

function getitemboUpgrade(uObject: integer; akey: integer): boolean; //背包 某位置 物品 是否用许升级
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.boUpgrade;
end;

function HaveItemaffairStart(uObject: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.HaveItemClass.affair(hicaStart);
  result := TRUE;
end;

function HaveItemaffairRoll_back(uObject: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.HaveItemClass.affair(hicaRoll_back);
  result := TRUE;
end;

function HaveItemaffairConfirm(uObject: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.HaveItemClass.affair(hicaConfirm);
  result := TRUE;
end;

function ItemUPdataSetting_del(uObject: integer; akey: integer): boolean; //镶嵌  清除
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.UPdateItem_Setting_del(akey);
end;

function ItemUPdataSetting(uObject: integer; akey, aaddKey: integer): boolean; //镶嵌  akey 物品 位置， aaddKey宝石位置，成功自动扣宝石数量，
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.UPdateItem_Setting(akey, aaddKey);
end;

//打孔

{function ItemUPdataSetting_Stiletto(uObject: integer; akey: integer): integer; //打孔 akey背包中的位置 SettingCount 孔数量
var
  USER: TUser;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.UpdateItemSetting_Stiletto(akey);
end;
 }

function getitemSettingCount(uObject: integer; akey: integer): integer; //背包某位置物品 孔数量
var
  USER: TUser;
  p: ptitemdata;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rSetting.rsettingcount;
end;

function getitemSettingSpaceCount(uObject: integer; akey: integer): integer; //背包某位置物品 未镶嵌宝石 空闲孔数量
var
  USER: TUser;
  p: ptitemdata;
  i: integer;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;

  if (p.rSetting.rsettingcount >= 1) and (p.rSetting.rsetting1 = '') then inc(result);
  if (p.rSetting.rsettingcount >= 2) and (p.rSetting.rsetting2 = '') then inc(result);
  if (p.rSetting.rsettingcount >= 3) and (p.rSetting.rsetting3 = '') then inc(result);
  if (p.rSetting.rsettingcount >= 4) and (p.rSetting.rsetting4 = '') then inc(result);

end;

function getitemWearArr(uObject: integer; akey: integer): integer; //背包 某位置 物品 rWearArr
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rWearArr;
end;

function getitemHitType(uObject: integer; akey: integer): integer;
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rHitType;
end;

function setitemAttach(uObject: integer; akey, aAttach: integer): boolean; //设置 背包 某位置 物品 Attach
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.UPdateAttach(akey, aAttach);
end;

function getitemAttach(uObject: integer; akey: integer): integer; //背包 某位置 物品 Attach
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rAttach;
end;

function getitemKind(uObject: integer; akey: integer): integer; //背包 某位置 物品 rKind
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rKind;
end;

function FindItemName(uObject: integer; aitemname: string): integer; //背包中查找 某物品 位置 0-29    -1 失败
var
  USER: TUser;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.FindNameItem(aitemname);
end;

function getHaveItemLockedPass(uObject: integer): boolean; //背包 密码 锁
var
  USER: TUser;
begin
  result := true;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.LockedPass;
end;

function getItemMaterialArr(uObject: integer; akey: integer; out aname1, aname2, aname3, aname4: string; out acount1, acount2, acount3, acount4: integer): boolean; //合成材料
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;

  aname1 := p.rMaterial.NameArr[0];
  aname2 := p.rMaterial.NameArr[1];
  aname3 := p.rMaterial.NameArr[2];
  aname4 := p.rMaterial.NameArr[3];

  acount1 := p.rMaterial.countArr[0];
  acount2 := p.rMaterial.countArr[1];
  acount3 := p.rMaterial.countArr[2];
  acount4 := p.rMaterial.countArr[3];
  result := true;
end;

function getitemKeyCount(uObject: integer; akey: integer): integer;
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rCount;
end;

function getitemname(uObject: integer; akey: integer): string; //背包 某位置 物品 name
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := '';
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rName;
end;

function setitemBlueprint(uObject: integer; akey: integer; astate: boolean): boolean; //背包 某位置 物品 Blueprint
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.UpboBlueprint(akey, astate);
end;

function getitemBlueprint(uObject: integer; akey: integer): boolean; //背包 某位置 物品 Blueprint
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rboBlueprint;
end;
{
function getitemPrestige(uObject: integer; akey: integer): boolean;             //背包 某位置 物品 Prestige
var
    USER: TUser;
    p: Ptitemdata;
begin
    result := false;
    if not (TObject(uObject) is TUser) then exit;
    user := TUser(uObject);
    p := user.HaveItemClass.getViewItem(akey);
    if p = nil then exit;
    result := p.rboPrestige;
end;
}

function setitemStarLevel(uObject: integer; akey, alevel: integer): boolean; //背包 某位置 物品 StarLevel
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.UpStarLevel(akey, alevel);
end;

function getitemStarLevel(uObject: integer; akey: integer): integer; //背包 某位置 物品 StarLevel
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rStarLevel;
end;

function getitemSpecialKind(uObject: integer; akey: integer): integer; //背包 物品，特殊KIND
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rSpecialKind;
end;

function getitemMixName(uObject: integer; akey: integer): string; //背包 物品，合成目标名字
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := '';
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rMix;
end;

function getitemSpecialLevel(uObject: integer; akey: integer): integer; //背包 某位置 物品 rSpecialLevel
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rSpecialLevel;
end;

function setitemDurability(uObject: integer; akey, aDurability: integer): boolean;
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.HaveItemClass.setDurability(akey, aDurability);
end;

function getitemDurability(uObject: integer; akey: integer): integer; //背包 某位置 物品 Durability
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rCurDurability;
end;

function getitemGrade(uObject: integer; akey: integer): integer; //背包 某位置 物品 Grade
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemClass.getViewItem(akey);
  if p = nil then exit;
  result := p.rGrade;
end;

function GetItemSpaceCount(uObject: integer): integer;
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  Result := user.HaveItemQuestClass.SpaceCount();
end;

function GetItemQuestCount(uObject: integer; aitemname: string): integer;
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := -1;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  p := user.HaveItemQuestClass.get(aitemname);
  if p = nil then exit;
  result := p.rCount;
end;

function AddItemQuest(uObject: integer; aitemname: string; acount: integer): boolean;
var
  USER: TUser;
  aitemdata: titemdata;
begin
  result := false;
  if acount < 0 then exit;
  if aitemname = '' then exit;
  if not (TObject(uObject) is TUser) then exit;
  if ItemClass.GetItemData(aitemname, aitemdata) = false then exit;
  user := TUser(uObject);
  aitemdata.rCount := acount;
  user.HaveItemQuestClass.Add(@aitemdata);
  result := true;
end;

function DelItemQuestID(uObject: integer; aQuestID: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.HaveItemQuestClass.delQuestId(aQuestID);
  result := true;
end;

function DelItemQuest(uObject: integer; aitemname: string; acount: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if acount < 0 then exit;
  if aitemname = '' then exit;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.HaveItemQuestClass.del(aitemname, acount);
  result := true;
end;

function getitem(uObject: integer; atype: string; afield: string; akey: integer): string;
//atype:类型（背包，装备，时装）; field:（item.sdb里字段）; akey:（位置）
//效率慢 不得以才使用
var
  USER: TUser;
  p: Ptitemdata;
begin
  result := '';
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if atype = '背包' then p := user.HaveItemClass.getViewItem(akey)
  else if atype = '装备' then p := user.WearItemClass.getViewItem(akey)
  else if atype = '时装' then p := user.WearItemClass.getViewItemFD(akey)
  else exit;

  if p = nil then exit;

  if afield = 'rName' then result := p.rName //名字
  else if afield = 'rViewName' then result := (p.rViewName) //rViewName:TNameString;     //显示名字

  else if afield = 'rNameColor' then result := inttostr(p.rNameColor) //rNameColor:integer;
  else if afield = 'rNeedGrade' then result := inttostr(p.rNeedGrade) //rNeedGrade:integer;        //(需要等级) 掌和招式=6 灵动=6 风灵=7
  else if afield = 'rKind' then result := inttostr(p.rKind) //rKind:byte;                //状态很多，其中有限制交易
  else if afield = 'rHitType' then result := inttostr(p.rHitType) //rHitType:byte;             //攻击 类型
  else if afield = 'rId' then result := inttostr(p.rId) //rId:integer;               //新ID 编号 不发到客户端
  else if afield = 'rDecSize' then result := inttostr(p.rDecSize) //rDecSize:integer;          //新 DecSize(损坏大小) 每次磨损几点耐久
  else if afield = 'rSex' then result := inttostr(p.rSex) //rSex:byte;                 //性别要求  (0,1 女,2男)
  else if afield = 'rcolor' then result := inttostr(p.rcolor) //rcolor:byte;               //颜色
  else if afield = 'rPrice' then result := inttostr(p.rPrice) //rPrice:integer;            //价格
  else if afield = 'rCount' then result := inttostr(p.rCount) //rCount:integer;            //数量
  else if afield = 'rlockState' then result := inttostr(p.rlockState) //rlockState:byte;           //新 物品锁状态     0,无锁状态，1,是加锁状态,2,是解锁状态
  else if afield = 'rlocktime' then result := inttostr(p.rlocktime) //rlocktime:word;            //新 解锁状态 时间
  else if afield = 'rDateTimeSec' then result := inttostr(p.rDateTimeSec) //rDateTimeSec:integer;      //特殊时间 秒单位 1，rboTimeMode 时间模式 物品最长有效时间；2，KIND 131 附加物品属性有效时间；
  else if afield = 'rGrade' then result := inttostr(p.rGrade) //rGrade:byte;               //新-品介
  else if afield = 'rWearArr' then result := inttostr(p.rWearArr) //rWearArr:byte;             //(装备部位) 9=武器 8=帽子 7=头发 6=衣服 4=裤裙 3=鞋子 2=上衣 1=护腕
  else if afield = 'MaxUpgrade' then result := inttostr(p.MaxUpgrade) //MaxUpgrade:byte;           //新 (最大升级别)
  else if afield = 'rDurability' then result := inttostr(p.rDurability) //rDurability:integer;       //持久
  else if afield = 'rCurDurability' then result := inttostr(p.rCurDurability) //rCurDurability:integer;    //当前持久
  else if afield = 'rSmithingLevel' then result := inttostr(p.rSmithingLevel) //rSmithingLevel:word;       //精练等级   //新 装备等级

  else if afield = 'rlock' then result := IfThen(p.rlock, 'TRUE', 'FALSE') //false 正常  true锁定（穿戴在身上就不累计属性）
  else if afield = 'rboident' then result := IfThen(p.rboident, 'TRUE', 'FALSE') //'rboident:boolean;          //是否可 鉴定
  else if afield = 'rboDouble' then result := IfThen(p.rboDouble, 'TRUE', 'FALSE') //rboDouble:Boolean;         //重叠
  else if afield = 'rboNotTrade' then result := IfThen(p.rboNotTrade, 'TRUE', 'FALSE') //rboNotTrade:boolean;       //新开关 NPC交易
  else if afield = 'rboNotExchange' then result := IfThen(p.rboNotExchange, 'TRUE', 'FALSE') //rboNotExchange:boolean;    //新开关 玩家交换
  else if afield = 'rboNotDrop' then result := IfThen(p.rboNotDrop, 'TRUE', 'FALSE') //rboNotDrop:boolean;        //新开关 丢弃地上
  else if afield = 'rboNotSSamzie' then result := IfThen(p.rboNotSSamzie, 'TRUE', 'FALSE') //rboNotSSamzie:boolean;     //新开关 存放福袋
  else if afield = 'rboTimeMode' then result := IfThen(p.rboTimeMode, 'TRUE', 'FALSE') //rboTimeMode:boolean;       //新开关 时间模式
  else if afield = 'boUpgrade' then result := IfThen(p.boUpgrade, 'TRUE', 'FALSE') //boUpgrade:boolean;         //新 (允许升级)
  else if afield = 'rboDurability' then result := IfThen(p.rboDurability, 'TRUE', 'FALSE') //rboDurability:boolean;     //新开关 消耗持久
  else if afield = 'rboColoring' then result := IfThen(p.rboColoring, 'TRUE', 'FALSE') //rboColoring:Boolean;       //(允许染色)
  else if afield = 'rboNOTRepair' then result := IfThen(p.rboNOTRepair, 'TRUE', 'FALSE') //rboNOTRepair:boolean;      //新开关 是否可修理
  else if afield = 'rboSetting' then result := IfThen(p.rboSetting, 'TRUE', 'FALSE') //rboSetting:boolean;        //是否 随即产生孔

  else if afield = 'rDateTime' then result := datetimetostr(p.rDateTime) //rDateTime:tdatetime;       //时间
        //未公开 属性
        //rSetting                   //镶嵌资料
        //rActionImage:Word;         //Action图片
        //rSoundEvent:TEffectData;
        //rSoundDrop:TEffectData;
        //rServerId:integer;
        //rx,
        //ry:integer;
        //rLifeDataBasic:TLifeData;  //基本属性  (保存 DB)
        //rLifeDataLevel:TLifeData;  //升级等级 （保存到DB）
        //rLifeDataPro:TLifeData;    //镶嵌宝石、精炼 (固定的)
        //rLifeData:TLifeData;       //物品属性
        //rMaxCount:integer;         //新(最大持有数量)
        //rSpecialKind:integer;      //新 特殊 KIND  物品状态 ID标志
        //rHitMotion:byte;           //攻击 动画
        //rScripter:string[128];     //2009 3 24 增加
        //rNameParam:array[0..2 - 1] of string[20];
        //rboLOG:boolean;            //新开关 记录
        //rWearShape:byte;           //装备后 外观图片
        //rAdditional:word;          //新 附加属性
        //rShape:word;               //外观 图片 ID
    ;
end;

function getitemLifeData(uObject: integer; atype: string; afield: string; akey: integer; var adamageBody, adamageHead, adamageArm, adamageLeg, aarmorBody, aarmorHead, aarmorArm, aarmorLeg, aAttackSpeed, aavoid, arecovery, aaccuracy: integer): boolean;
//一次返回12个属性值atype:类型（背包，装备，时装）; field:（rLifeDataBasic原始,rLifeDataLevel精炼,rLifeDataPro镶嵌,rLifeData合计）; akey:（位置）
var
  USER: TUser;
  p: Ptitemdata;
  pLifeData: pTLifeData;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if atype = '背包' then p := user.HaveItemClass.getViewItem(akey)
  else if atype = '装备' then p := user.WearItemClass.getViewItem(akey)
  else if atype = '时装' then p := user.WearItemClass.getViewItemFD(akey)
  else exit;

  if p = nil then exit;

  if afield = 'rLifeDataBasic' then pLifeData := @p.rLifeDataBasic
  else if afield = 'rLifeDataLevel' then pLifeData := @p.rLifeDataLevel
  else if afield = 'rLifeDataPro' then pLifeData := @p.rLifeDataSetting
  else if afield = 'rLifeDataAttach' then pLifeData := @p.rLifeDataAttach
  else if afield = 'rLifeData' then pLifeData := @p.rLifeData
  else exit;

  with pLifeData^ do
  begin
    adamageBody := damageBody;
    adamageHead := damageHead;
    adamageArm := damageArm;
    adamageLeg := damageLeg;
    aarmorBody := armorBody;
    aarmorHead := armorHead;
    aarmorArm := armorArm;
    aarmorLeg := armorLeg;
    aAttackSpeed := AttackSpeed;
    aavoid := avoid;
    arecovery := recovery;
    aaccuracy := accuracy;
  end;

    //rLifeDataBasic:TLifeData;  //基本属性  (保存 DB)
    //rLifeDataLevel:TLifeData;  //升级等级 （保存到DB）
    //rLifeDataPro:TLifeData;    //镶嵌宝石、精炼 (固定的)
    //rLifeData:TLifeData;       //物品属性

  result := true;
end;

function getitemrSetting(uObject: integer; atype: string; akey: integer; var asettingcount: integer; asetting1, asetting2, asetting3, asetting4: string): boolean;
//返回所有镶嵌资料;atype:类型（背包，装备，时装）;  akey:（位置）
var
  USER: TUser;
  p: Ptitemdata;

begin

  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if atype = '背包' then p := user.HaveItemClass.getViewItem(akey)
  else if atype = '装备' then p := user.WearItemClass.getViewItem(akey)
  else if atype = '时装' then p := user.WearItemClass.getViewItemFD(akey)
  else exit;

  if p = nil then exit;

  asettingcount := p.rSetting.rsettingcount;
  asetting1 := p.rSetting.rsetting1;
  asetting2 := p.rSetting.rsetting2;
  asetting3 := p.rSetting.rsetting3;
  asetting4 := p.rSetting.rsetting4;

  result := true;
end;

function getitemrUpdateLevel(uObject: integer; atype: string; akey: integer; var aitemname: string; var aKind, aSmithingLevel, aWearArr, aGrade, aMaxUpgrade: integer; var aboUpgrade: boolean): boolean;
//返回所有精炼需要资料; atype:类型（背包，装备，时装）; akey:（位置）
var
  USER: TUser;
  p: Ptitemdata;
begin

  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if atype = '背包' then p := user.HaveItemClass.getViewItem(akey)
  else if atype = '装备' then p := user.WearItemClass.getViewItem(akey)
  else if atype = '时装' then p := user.WearItemClass.getViewItemFD(akey)
  else exit;

  if p = nil then exit;
  aitemname := p.rName;
  aKind := p.rKind;
  aSmithingLevel := p.rSmithingLevel;
  aWearArr := p.rWearArr;
  aGrade := p.rGrade;
  aMaxUpgrade := p.MaxUpgrade;

  aboUpgrade := p.boUpgrade;

  result := true;
end;

function MsgBoxTempOpen(uObject: integer; aCaption, astr: string): boolean;
var
  USER: TUser;
begin
  result := FALSE;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.SendClass.SendMsgBoxTemp(aCaption, astr);
  RESULT := TRUE;
end;
//怪物

function ObjectKill(uObject, uKillObject: integer): boolean; //uObject杀死uKillObject对象
var
  aBasicObject, aKillObject: TBasicObject;
  aSubData: tSubData;
begin
  result := false;
  if not (TObject(uObject) is TBasicObject) then exit;
  if not (TObject(uKillObject) is TBasicObject) then exit;
  aBasicObject := TBasicObject(uObject);
  aKillObject := TBasicObject(uKillObject);
  aSubData.TargetId := 0;
  aBasicObject.SendLocalMessage(aKillObject.BasicData.id, FM_DEADHIT, aBasicObject.BasicData, aSubData);
  result := true;
end;

function ObjectboNotHit(uObject: integer; astate: boolean): boolean; //改变对象(玩家,怪物,NPC) 进入无敌模式
var
  aBasicObject: TBasicObject;
begin
  result := false;
  if not (TObject(uObject) is TBasicObject) then exit;
  aBasicObject := TBasicObject(uObject);
  aBasicObject.BasicData.boNotHit := astate;
  result := true;
end;

function ObjectDelaySay(uObject: integer; asay: string; atime: integer): boolean; //NPC 延迟时间 消息
var
  aBasicObject: TBasicObject;
  p: Ptitemdata;
begin
  result := false;
  if not (TObject(uObject) is TBasicObject) then exit;
  aBasicObject := TBasicObject(uObject);
  aBasicObject.SayDelayAdd(asay, atime);
  result := true;
end;


function ObjectNotMove(uObject: integer; atime: integer): boolean; //锁定对象一段时间 不能移动atime 100=1秒
var
  aBasicObject: TBasicObject;
  p: Ptitemdata;
begin
  result := false;
  if not (TObject(uObject) is TBasicObject) then exit;
  TBasicObject(uObject).LockNotMove(atime);
  if (TObject(uObject) is Tuser) then
    Tuser(uObject).SendClass.lockmoveTime(atime);
  result := true;
end;

function MapDelaySayNPC(amapname, aname, asay: string; atime: integer): boolean; //延时 话语；根据 地图和名字    aname=‘’操作全部
var
  ttTManager: TManager;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  if ttTManager.NpcList = nil then exit;
  TNpcList(ttTManager.NpcList).SayDelayAddNpc(aname, asay, atime);
  result := true;
end;

function MapDelaySayMonster(amapname, aname, asay: string; atime: integer): boolean; //延时 话语；根据 地图和名字    aname=‘’操作全部
var
  ttTManager: TManager;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  if ttTManager.MonsterList = nil then exit;
  TMonsterList(ttTManager.MonsterList).SayDelayAddMonster(aname, asay, atime);
  result := true;
end;

function MapboNotHItNpc(amapname, aname: string; astate: boolean): boolean; //是否接受攻击；根据 地图和名字    aname=‘’操作全部
var
  ttTManager: TManager;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  if ttTManager.NpcList = nil then exit;
  TNpcList(ttTManager.NpcList).boNotHitNpc(aname, astate);
  result := true;
end;

function MapboNotHItMonster(amapname, aname: string; astate: boolean): boolean; //是否接受攻击；根据 地图和名字    aname=‘’操作全部
var
  ttTManager: TManager;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  if ttTManager.MonsterList = nil then exit;
  TMonsterList(ttTManager.MonsterList).boNotHitMonster(aname, astate);
  result := true;
end;

function MapNotMoveMonster(amapname, aname: string; atime: integer): boolean; //一定时间不能移动；根据 地图和名字    aname=‘’操作全部
var
  ttTManager: TManager;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;

  TMonsterList(ttTManager.MonsterList).NotMoveMonster(aname, atime);
  result := true;
end;

function MapNotMoveNpc(amapname, aname: string; atime: integer): boolean; //一定时间不能移动；根据 地图和名字    aname=‘’操作全部
var
  ttTManager: TManager;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;

  TNPCList(ttTManager.NpcList).NotMoveNpc(aname, atime);
  result := true;
end;

function MapNotMoveUser(amapname: string; atime: integer): boolean; //一定时间不能移动；根据 地图
var
  ttTManager: TManager;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  userlist.NotMoveServerID(ttTManager.ServerID, atime);
  result := true;
end;

function NotMoveUser(aname: string; atime: integer): boolean; //一定时间不能移动；根据 名字
var
  auser: Tuser;
begin
  result := false;
  auser := UserList.GetUserPointer(aname);
  if auser = nil then exit;
  auser.LockNotMove(atime);
  auser.SendClass.lockmoveTime(atime);
  result := true;
end;

function MapUserCount(amapname: string): integer;
var
  ttTManager: TManager;
begin
  result := 0;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  result := UserList.MapUserCount(ttTManager.ServerID);
end;

function MapRegen(amapname: string): boolean; //复活 地图，和定时重新复活一样处理机制
var
  ttTManager: TManager;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  ttTManager.Regen;
  result := true;
end;



procedure MapSendChatMsg(amapname: string; asay: string; acolor: integer); //    SAY_COLOR_SYSTEM = 2;
var
  ttTManager: TManager;
begin
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  UserList.SendChatMessage_ServerID(ttTManager.ServerID, asay, acolor);
end;

procedure MapObjSay(aManager: integer; asay: string; acolor: integer); //    SAY_COLOR_SYSTEM = 2;
var
  ttTManager: TManager;
begin
  if not (TObject(aManager) is TManager) then exit;
  ttTManager := TManager(aManager);
  if ttTManager = nil then exit;
  UserList.SendChatMessage_ServerID(ttTManager.ServerID, asay, acolor);
end;

function MapObjIceMonster(aManager: integer; aname: string; astate: boolean): boolean; //冻结 Monster   aname='' 冻结全部
var
  ttTManager: TManager;
begin
  result := false;
  if not (TObject(aManager) is TManager) then exit;
  ttTManager := TManager(aManager);
  if ttTManager = nil then exit;
  if ttTManager.MonsterList = nil then exit;
  TMonsterList(ttTManager.MonsterList).iceMonster(aname, astate);

  result := true;
end;


function MapIceMonster(amapname: string; aname: string; astate: boolean): boolean; //冻结 怪物   aname='' 冻结全部怪物
var
  ttTManager: TManager;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  if ttTManager.MonsterList = nil then exit;
  TMonsterList(ttTManager.MonsterList).iceMonster(aname, astate);
  result := true;
end;

function MapRegenMonster(amapname: string; aname: string): boolean; //复活 怪物   aname='' 复活全部怪物
var
  ttTManager: TManager;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  if ttTManager.MonsterList = nil then exit;
  TMonsterList(ttTManager.MonsterList).RegenMonster(aname);
  result := true;
end;


function MapFindMonster(amapname: string; aname, atype: string): integer; //统计数量；die,死亡；live活；all全部
var
  ttTManager: TManager;
begin
  result := 0;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  if atype = 'die' then
  begin
    result := TMonsterList(ttTManager.MonsterList).getDieCount(aname);
  end
  else if atype = 'live' then
  begin
    result := TMonsterList(ttTManager.MonsterList).getliveCount(aname);
  end
  else if atype = 'all' then
  begin
    if aname = '' then result := TMonsterList(ttTManager.MonsterList).Count
    else result := TMonsterList(ttTManager.MonsterList).FindMonster(aname);
  end;
end;

function MapDelmonster(amapname: string; aname: string): boolean; //地图删除怪物
var
  ttTManager: TManager;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  TMonsterList(ttTManager.MonsterList).DeleteMonster(aname);
  result := true;
end;

function MapAddmonster(amapname: string; aname: string; ax, ay, acount, awidth: integer; amember: string; anation, amappathid: integer; aboDieDelete: boolean): boolean; //地图增加  怪物 （参数参考CreateMonster.sdb）
var
  ttTManager: TManager;
  i: integer;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  for i := 0 to acount - 1 do
  begin
    TMonsterList(ttTManager.MonsterList).AddMonster(aname, ax, ay, awidth, amember, anation, amappathid, aboDieDelete);
  end;
  result := true;
end;
//////////////////

function MapRegenNpc(amapname: string; aname: string): boolean; //aname ='' 全部复活
var
  ttTManager: TManager;
  i: integer;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  TNpcList(ttTManager.NpcList).RegenNpc(aname);
  result := true;
end;

function MapFindNPC(amapname: string; aname, atype: string): integer; //统计数量；die,死亡；live活；all全部
var
  ttTManager: TManager;
  i: integer;
begin
  result := 0;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  if atype = 'die' then
  begin
    result := TNpcList(ttTManager.NpcList).getDieCount(aname);
  end
  else if atype = 'live' then
  begin
    result := TNpcList(ttTManager.NpcList).getliveCount(aname);
  end
  else if atype = 'all' then
  begin
    if aname = '' then result := TNpcList(ttTManager.NpcList).Count
    else result := TNpcList(ttTManager.NpcList).FindNpc(aname);
  end;
end;

function MapDelNPC(amapname: string; aname: string): boolean;
var
  ttTManager: TManager;
  i: integer;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  TNpcList(ttTManager.NpcList).DelNpc(aname);
  result := true;
end;

function MapAddNPC(amapname: string; aname: string; ax, ay, acount, awidth: integer; aBookName: string; anation, amappathid: integer; aboDieDelete: boolean): boolean;
var
  ttTManager: TManager;
  i: integer;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  for i := 0 to acount - 1 do
  begin
    TNpcList(ttTManager.NpcList).AddNpc(aname, ax, ay, awidth, aBookName, anation, amappathid);
  end;
  result := true;
end;

function DynamicobjectChange(uObject: integer; astate: string): boolean; //改变 动态物体 状态  astate(dos_Closed, dos_Openning, dos_Openned, dos_Scroll)
var
  DynamicObject: TDynamicObject;
  i: integer;
  aObjectStatus: TDynamicObjectState;
begin
  result := false;
  if not (TObject(uObject) is TDynamicobject) then exit;
  DynamicObject := TDynamicobject(uObject);
  if astate = 'dos_Closed' then aObjectStatus := dos_Closed
  else if astate = 'dos_Openning' then aObjectStatus := dos_Openning
  else if astate = 'dos_Openned' then aObjectStatus := dos_Openned
  else if astate = 'dos_Scroll' then aObjectStatus := dos_Scroll
  else exit;
  if DynamicObject.ObjectStatus = aObjectStatus then exit;
  DynamicObject.setObjectStatus(aObjectStatus);
  result := true;
end;

function MapRegenDynamicObject(amapname: string; aname: string): boolean; //复活 动态物体 aname='' 全部复活
var
  ttTManager: TManager;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  TDynamicObjectList(ttTManager.DynamicObjectList).RegenDynamicObject(aname);
  result := true;
end;

function MapChangeDynamicobject(amapname: string; aname, astate: string): boolean; //改变 动态物体 状态  astate(dos_Closed, dos_Openning, dos_Openned, dos_Scroll)
var
  ttTManager: TManager;
  i: integer;
  aObjectStatus: TDynamicObjectState;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  if astate = 'dos_Closed' then aObjectStatus := dos_Closed
  else if astate = 'dos_Openning' then aObjectStatus := dos_Openning
  else if astate = 'dos_Openned' then aObjectStatus := dos_Openned
  else if astate = 'dos_Scroll' then aObjectStatus := dos_Scroll
  else exit;
  TDynamicObjectList(ttTManager.DynamicObjectList).ChangeObjectStatus(aname, aObjectStatus);
  result := true;
end;

function MapFindDynamicobject(amapname: string; aname, astate: string): integer; //astate(dos_Closed, dos_Openning, dos_Openned, dos_Scroll,all)
var
  ttTManager: TManager;
  i: integer;
begin
  result := -1;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  if astate = 'dos_Closed' then result := TDynamicObjectList(ttTManager.DynamicObjectList).getTypeCount(aname, dos_Closed)
  else if astate = 'dos_Openning' then result := TDynamicObjectList(ttTManager.DynamicObjectList).getTypeCount(aname, dos_Openning)
  else if astate = 'dos_Openned' then result := TDynamicObjectList(ttTManager.DynamicObjectList).getTypeCount(aname, dos_Openned)
  else if astate = 'dos_Scroll' then result := TDynamicObjectList(ttTManager.DynamicObjectList).getTypeCount(aname, dos_Scroll)
  else if astate = 'all' then
  begin
    if aname = '' then result := TDynamicObjectList(ttTManager.DynamicObjectList).Count
    else result := TDynamicObjectList(ttTManager.DynamicObjectList).FindDynamicObject(aname);
  end;
end;

function MapDeldynamicobject(amapname: string; aObjectName: string): boolean;
var
  ttTManager: TManager;
  i: integer;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  TDynamicObjectList(ttTManager.DynamicObjectList).DeleteDynamicObject(aObjectName);
  result := true;
end;

function MapAdddynamicobject(amapname: string; aObjectName, aNeedSkill, aNeedItem, aGiveItem, aDropItem, aDropMop, aCallNpc, axs, ays: string; aNeedAge, aDropX, aDropy: integer): boolean;
var
  ttTManager: TManager;
  i: integer;
  pd: TCreateDynamicObjectData;
begin
  result := false;
  ttTManager := ManagerList.GetManagerByTitle(amapname);
  if ttTManager = nil then exit;
  fillchar(pd, sizeof(pd), 0);
  if DynamicObjectClass.GetDynamicObjectData(aObjectName, pd.rBasicData) = false then exit;
  try
    LoadDynamicObject(aObjectName
      , aNeedSkill
      , aNeedItem
      , aGiveItem
      , aDropItem
      , aDropMop
      , aCallNpc
      , axs
      , ays
      , @pd
      );
  except
    exit;
  end;
  pd.rNeedAge := aNeedAge;
  pd.rDropX := aDropX;
  pd.rDropX := aDropy;
  TDynamicObjectList(ttTManager.DynamicObjectList).AddDynamicObject(@pd);

  result := true;
end;

procedure _dec(var Value: Integer);
begin
  Dec(Value);
end;

procedure _inc(var Value: Integer);
begin
  inc(Value);
end;

function HIT_Screen(uObject: integer; aHit: integer): boolean;
var
  aBasicObject: TBasicObject;
  SubData: tSubData;
begin
  result := false;
  if aHit <= 0 then exit;
  if not (TObject(uObject) is TBasicObject) then exit;
  aBasicObject := TBasicObject(uObject);
  aBasicObject.HIT_Screen(aHit);
  result := true;
end;

function ShowSound(uObject: integer; asound: integer): boolean;
var
  aBasicObject: TBasicObject;
begin
  result := false;
  if not (TObject(uObject) is TBasicObject) then exit;
  aBasicObject := TBasicObject(uObject);
  aBasicObject.ShowSound(asound);
  result := true;
end;

function ShowEffect(uObject: integer; aEffectNum: integer; atype: string): boolean; //atype (lek_none, lek_follow,lek_cumulate,lek_cumulate_follow)
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if atype = 'lek_none' then user.ShowEffect(aEffectNum, lek_none)
  else if atype = 'lek_follow' then user.ShowEffect(aEffectNum, lek_follow)
  else if atype = 'lek_cumulate' then user.ShowEffect(aEffectNum, lek_cumulate)
  else if atype = 'lek_cumulate_follow' then user.ShowEffect(aEffectNum, lek_cumulate_follow)
  else exit;
  result := true;
end;


function MagicExpMulGetCurMulMinutes(uObject: integer): integer; //获取，当前翻倍时间，剩余分钟
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.MagicExpMulGetCurMulMinutes;
end;

function MagicExpMulGetDay(uObject: integer): integer; //获取，未使用的翻倍经验，天数。
var
  USER: TUser;
begin
  result := 0;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  result := user.MagicExpMulGetDay;
end;


procedure MagicExpMulAdd(uObject: integer; aMulCount, aHour: integer); //领取一天，次翻倍经验，aMulCount翻倍数量
var
  USER: TUser;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  user.MagicExpMulAdd(aMulCount, aHour);
end;


function QuestProcessionAdd(uObject: integer; atype: string; aQuestID, aQuestStep, aIndex, aAddCount, aAddMax: integer): boolean; //队伍任务临时变量 aQuestID任务ID, aQuestStep任务步骤, aIndex变量ID, aAddCount增加数量
var
  USER: TUser;
begin
  result := FALSE;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  RESULT := TProcessionclass(user.uProcessionclass).QuestProcessionAdd(user, atype, aQuestID, aQuestStep, aIndex, aAddCount, aAddMax);
end;

function GetProcession(uObject: integer; var u1, u2, u3, u4, u5, u6, u7, u8: integer): boolean;
var
  USER: TUser;
begin
  result := false;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  if user.uProcessionclass = nil then exit;
  result := TProcessionclass(user.uProcessionclass).GetProcession(u1, u2, u3, u4, u5, u6, u7, u8);
end;


//返回位置 大于1存在 否则不存在

function _pos(asubstr: string; astr: string): integer;
begin
  Result := Pos(asubstr, astr);

end;
//返回最后一个字符

function _LastChar(astr: string): string;
var
  i: integer;
begin
  i := length(astr);
  Result := astr[i];
end;

function _DateTimeToStr(DateTime: TDateTime): string;
begin
  Result := DateTimeToStr(DateTime);
end;

procedure Booth_edit_open(uObject: integer);
var
  USER: TUser;
begin
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  USER.Booth_Edit_Open;
end;

function getnation(uObject: integer): integer; //获取 部落 国家   范围0到255
var
  bo: TBasicObject;
begin
  result := -1;
  if not (TObject(uObject) is TBasicObject) then exit;
  bo := TBasicObject(uObject);
  result := bo.BasicData.Feature.rnation;
end;

procedure setnation(uObject: integer; anation: integer); //设置部落 国家   范围0到255
var
  bo: TBasicObject;
begin
  if not (TObject(uObject) is TBasicObject) then exit;
  bo := TBasicObject(uObject);
  bo.BasicData.Feature.rnation := anation;
end;

function getAQData(uObject: integer; atype: string): integer;
var
  USER: TUser;
  c1: char;
begin
  result := 0;
  if atype = '' then exit;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  c1 := atype[1];
  case c1 of
    'l':
      begin
                //附加属性类
                //攻击
        if atype = 'ldamagebody' then result := user.AttribClass.AttribQuestData.AttribLifeData.damageBody //身体
        else if atype = 'ldamagehead' then result := user.AttribClass.AttribQuestData.AttribLifeData.damageHead //头
        else if atype = 'ldamagearm' then result := user.AttribClass.AttribQuestData.AttribLifeData.damageArm //手
        else if atype = 'ldamageleg' then result := user.AttribClass.AttribQuestData.AttribLifeData.damageLeg //脚
                //防御
        else if atype = 'larmorbody' then result := user.AttribClass.AttribQuestData.AttribLifeData.armorBody //身
        else if atype = 'larmorhead' then result := user.AttribClass.AttribQuestData.AttribLifeData.armorHead //头
        else if atype = 'larmorarm' then result := user.AttribClass.AttribQuestData.AttribLifeData.armorArm //手
        else if atype = 'larmorleg' then result := user.AttribClass.AttribQuestData.AttribLifeData.armorLeg //脚
                //其他
        else if atype = 'lattackspeed' then result := user.AttribClass.AttribQuestData.AttribLifeData.AttackSpeed //攻击速度
        else if atype = 'lavoid' then result := user.AttribClass.AttribQuestData.AttribLifeData.avoid //躲闪
        else if atype = 'lrecovery' then result := user.AttribClass.AttribQuestData.AttribLifeData.recovery //恢复
        else if atype = 'laccuracy' then result := user.AttribClass.AttribQuestData.AttribLifeData.accuracy //命中
        else exit;

      end;
    'a':
      begin
        if atype = 'aage' then result := user.AttribClass.AttribQuestData.Age //年龄
        else if atype = 'alight' then result := user.AttribClass.AttribQuestData.Light //阳
        else if atype = 'adark' then result := user.AttribClass.AttribQuestData.Dark //阴
        else if atype = 'avirtue' then result := user.AttribClass.AttribQuestData.virtue //浩然
        else if atype = 'aadaptive' then result := user.AttribClass.AttribQuestData.adaptive //赖性
        else if atype = 'arevival' then result := user.AttribClass.AttribQuestData.Revival //再生
        else exit;
      end;
    'e':
      begin
        if atype = 'eenergy' then result := user.AttribClass.AttribQuestData.Energy //元气
        else if atype = 'einpower' then result := user.AttribClass.AttribQuestData.InPower //内功
        else if atype = 'eoutpower' then result := user.AttribClass.AttribQuestData.OutPower //外功
        else if atype = 'emagic' then result := user.AttribClass.AttribQuestData.Magic //武功
        else if atype = 'elife' then result := user.AttribClass.AttribQuestData.Life //活力
        else exit;
      end;

    'h':
      begin
        if atype = 'hheadseak' then result := user.AttribClass.AttribQuestData.HeadSeak //头
        else if atype = 'harmseak' then result := user.AttribClass.AttribQuestData.ArmSeak //手
        else if atype = 'hlegseak' then result := user.AttribClass.AttribQuestData.LegSeak //脚

        else if atype = 'hhealth' then result := user.AttribClass.AttribQuestData.Health //健康
        else if atype = 'hsatiety' then result := user.AttribClass.AttribQuestData.Satiety //饱和
        else if atype = 'hpoisoning' then result := user.AttribClass.AttribQuestData.Poisoning //中毒
        else if atype = 'htalent' then result := user.AttribClass.AttribQuestData.Talent //才能
        else if atype = 'hgoodchar' then result := user.AttribClass.AttribQuestData.GoodChar //神性
        else if atype = 'hbadchar' then result := user.AttribClass.AttribQuestData.BadChar //魔性
        else if atype = 'hlucky' then result := user.AttribClass.AttribQuestData.lucky //幸运
        else if atype = 'himmunity' then result := user.AttribClass.AttribQuestData.immunity //免疫

             //   else if atype = 'hprestige' then result := user.AttribClass.AttribQuestData.prestige //荣誉

        else if atype = 'hr3f_sky' then result := user.AttribClass.AttribQuestData.r3f_sky //天
        else if atype = 'hr3f_terra' then result := user.AttribClass.AttribQuestData.r3f_terra //地
        else if atype = 'hr3f_fetch' then result := user.AttribClass.AttribQuestData.r3f_fetch //魂 应该是（命）
        else exit;
      end;
  else exit;
  end;
end;

procedure SetAQData(uObject: integer; atype: string; avalue: integer);
var
  USER: TUser;
  c1: char;
begin
  if atype = '' then exit;
  if not (TObject(uObject) is TUser) then exit;
  user := TUser(uObject);
  c1 := atype[1];
  case c1 of
    'l':
      begin
        if atype = 'ldamagebody' then user.AttribClass.AttribQuestData.AttribLifeData.damageBody := avalue
        else if atype = 'ldamagehead' then user.AttribClass.AttribQuestData.AttribLifeData.damagehead := avalue
        else if atype = 'ldamagearm' then user.AttribClass.AttribQuestData.AttribLifeData.damageArm := avalue
        else if atype = 'ldamageleg' then user.AttribClass.AttribQuestData.AttribLifeData.damageLeg := avalue

        else if atype = 'larmorbody' then user.AttribClass.AttribQuestData.AttribLifeData.armorBody := avalue
        else if atype = 'larmorhead' then user.AttribClass.AttribQuestData.AttribLifeData.armorHead := avalue
        else if atype = 'larmorarm' then user.AttribClass.AttribQuestData.AttribLifeData.armorArm := avalue
        else if atype = 'larmorleg' then user.AttribClass.AttribQuestData.AttribLifeData.armorLeg := avalue

        else if atype = 'lattackspeed' then user.AttribClass.AttribQuestData.AttribLifeData.AttackSpeed := avalue
        else if atype = 'lavoid' then user.AttribClass.AttribQuestData.AttribLifeData.avoid := avalue
        else if atype = 'lrecovery' then user.AttribClass.AttribQuestData.AttribLifeData.recovery := avalue
        else if atype = 'laccuracy' then user.AttribClass.AttribQuestData.AttribLifeData.accuracy := avalue
        else exit;
        USER.SetLifeData;
        exit;
      end;
    'a':
      begin
        if atype = 'aage' then user.AttribClass.AttribQuestData.Age := avalue
        else if atype = 'alight' then user.AttribClass.AttribQuestData.Light := avalue
        else if atype = 'adark' then user.AttribClass.AttribQuestData.Dark := avalue
        else if atype = 'avirtue' then user.AttribClass.AttribQuestData.virtue := avalue
        else if atype = 'aadaptive' then user.AttribClass.AttribQuestData.adaptive := avalue
        else if atype = 'arevival' then user.AttribClass.AttribQuestData.Revival := avalue
        else exit;
      end;
    'e':
      begin
        if atype = 'eenergy' then user.AttribClass.AttribQuestData.Energy := avalue
        else if atype = 'einpower' then user.AttribClass.AttribQuestData.InPower := avalue
        else if atype = 'eoutpower' then user.AttribClass.AttribQuestData.OutPower := avalue
        else if atype = 'emagic' then user.AttribClass.AttribQuestData.Magic := avalue
        else if atype = 'elife' then user.AttribClass.AttribQuestData.Life := avalue
        else exit;
      end;

    'h':
      begin
        if atype = 'hheadseak' then user.AttribClass.AttribQuestData.HeadSeak := avalue
        else if atype = 'harmseak' then user.AttribClass.AttribQuestData.ArmSeak := avalue
        else if atype = 'hlegseak' then user.AttribClass.AttribQuestData.LegSeak := avalue
        else if atype = 'hhealth' then user.AttribClass.AttribQuestData.Health := avalue
        else if atype = 'hsatiety' then user.AttribClass.AttribQuestData.Satiety := avalue
        else if atype = 'hpoisoning' then user.AttribClass.AttribQuestData.Poisoning := avalue
        else if atype = 'htalent' then user.AttribClass.AttribQuestData.Talent := avalue
        else if atype = 'hgoodchar' then user.AttribClass.AttribQuestData.GoodChar := avalue
        else if atype = 'hbadchar' then user.AttribClass.AttribQuestData.BadChar := avalue
        else if atype = 'hlucky' then user.AttribClass.AttribQuestData.lucky := avalue
        else if atype = 'himmunity' then user.AttribClass.AttribQuestData.immunity := avalue

//                else if atype = 'hprestige' then user.AttribClass.AttribQuestData.prestige := avalue
        else if atype = 'hr3f_sky' then user.AttribClass.AttribQuestData.r3f_sky := avalue
        else if atype = 'hr3f_terra' then user.AttribClass.AttribQuestData.r3f_terra := avalue
        else if atype = 'hr3f_fetch' then user.AttribClass.AttribQuestData.r3f_fetch := avalue
        else exit;
      end;
  else exit;
  end;
  user.AttribClass.AQDataUPdate;
end;

procedure BoothAllClose;
begin
  UserList.BoothClose;
end;

function getUserListCount(): integer;
begin
  result := UserList.Count;
end;




initialization
  begin
    RegisterRoutine('function MsgBoxTempOpen(uObject:integer; aCaption, astr:string):boolean;', @MsgBoxTempOpen);
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //任务 特殊 属性
    RegisterRoutine('function getAQData(uObject: integer; atype: string): integer;', @getAQData); //获取角色 任务特殊属性
    RegisterRoutine('procedure SetAQData(uObject: integer; atype: string; avalue: integer);', @SetAQData); //设置角色任务特殊属性
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
//效果指令

    RegisterRoutine('function ShowSound(uObject: integer; asound: integer): boolean;', @ShowSound);
    RegisterRoutine('function ShowEffect(uObject: integer; aEffectNum: integer; atype: string): boolean;', @ShowEffect); //atype (lek_none, lek_follow)
    RegisterRoutine('function HIT_Screen(uObject: integer; aHit: integer): boolean;', @HIT_Screen); //全屏幕 攻击
        //物品输入窗口
    RegisterRoutine('function getItemInputWindowsKey(uObject: integer; aSubKey: integer): integer;', @getItemInputWindowsKey);
    RegisterRoutine('function setItemInputWindowsKey(uObject: integer; aSubKey: integer; akey: integer): boolean;', @setItemInputWindowsKey);
    RegisterRoutine('function ItemInputWindowsClose(uObject: integer): boolean;', @ItemInputWindowsClose);
    RegisterRoutine('function ItemInputWindowsOpen(uObject: integer; aSubKey: integer; aCaption: string; aText: string): boolean;', @ItemInputWindowsOpen);

        //提示
    RegisterRoutine('procedure topyoumsg(uObject:integer; atext:string; acolor:integer);', @topyoumsg); //TOP  YOU消息筐
    RegisterRoutine('procedure LeftText1(uObject:integer; astr:string;acolor:integer);', @LeftText1); //左下边 吃药处     acolor 颜色 windows颜色
    RegisterRoutine('procedure LeftText2(uObject:integer; astr:string;acolor:integer);', @LeftText2); //左下边LeftText2   acolor 颜色 windows颜色
    RegisterRoutine('procedure LeftText3(uObject:integer; astr:string;acolor:integer);', @LeftText3); //左下边LeftText3   acolor 颜色 windows颜色

        //三魂 脚本
    RegisterRoutine('function get3f_sky(uObject:integer):integer;', @get3f_sky);
    RegisterRoutine('function get3f_terra(uObject:integer):integer;', @get3f_terra);
    RegisterRoutine('function get3f_fetch(uObject:integer):integer;', @get3f_fetch);
    RegisterRoutine('function set3f_sky(uObject:integer; acount:integer):boolean;', @set3f_sky);
    RegisterRoutine('function set3f_terra(uObject:integer; acount:integer):boolean;', @set3f_terra);
    RegisterRoutine('function set3f_fetch(uObject:integer; acount:integer):boolean;', @set3f_fetch);
        //国家 部落

    RegisterRoutine('procedure setnation(uObject: integer; anation: integer);', @setnation); //设置部落 国家   范围0到255
    RegisterRoutine('function getnation(uObject: integer): integer;', @getnation); //获取 部落 国家   范围0到255]
//对象
    RegisterRoutine('function ObjectDelaySay(uObject: integer; asay: string; atime: integer): boolean;', @ObjectDelaySay); //NPC 延迟时间 消息
    RegisterRoutine('function ObjectNotMove(uObject: integer; atime: integer): boolean;', @ObjectNotMove); //锁定玩家一段时间 不能移动atime 100=1秒
    RegisterRoutine('function ObjectBoNotHit(uObject: integer; astate: boolean): boolean;', @ObjectBoNotHit); //改变对象(玩家,怪物,NPC) 进入无敌模式
    RegisterRoutine('function ObjectKill(uObject, uKillObject: integer): boolean;', @ObjectKill); //uObject杀死uKillObject对象 ,支持杀死人，怪物，NPC
//地图对象

    RegisterRoutine('function MapObjIceMonster(aManager: integer; aname: string; astate: boolean): boolean;', @MapObjIceMonster); //冻结 Monster   aname='' 冻结全部
    RegisterRoutine('procedure MapObjSay(aManager: integer; asay: string; acolor: integer);', @MapObjSay); //    SAY_COLOR_SYSTEM = 2;

//地图相关

    RegisterRoutine('procedure MapSendChatMsg(amapname: string; asay: string; acolor: integer);', @MapSendChatMsg); //    SAY_COLOR_SYSTEM = 2;
        //复活
    RegisterRoutine('function MapRegen(amapname: string): boolean;', @MapRegen); //复活 地图，和定时重新复活一样处理机制
    RegisterRoutine('function MapIceMonster(amapname: string; aname: string; astate: boolean): boolean;', @MapIceMonster); //冻结 怪物   aname='' 冻结全部怪物
    RegisterRoutine('function MapRegenMonster(amapname: string; aname: string): boolean;', @MapRegenMonster); //复活 怪物   aname='' 复活全部怪物
    RegisterRoutine('function MapRegenDynamicObject(amapname: string; aname: string): boolean;', @MapRegenDynamicObject); //复活 动态物体 aname='' 全部复活
    RegisterRoutine('function MapRegenNpc(amapname: string; aname: string): boolean;', @MapRegenNpc); //aname ='' 全部复活
        //延时 话语
    RegisterRoutine('function MapDelaySayNPC(amapname, aname, asay: string; atime: integer): boolean;', @MapDelaySayNPC); //延时 话语；根据 地图和名字    aname=‘’操作全部
    RegisterRoutine('function MapDelaySayMonster(amapname, aname, asay: string; atime: integer): boolean;', @MapDelaySayMonster); //延时 话语；根据 地图和名字    aname=‘’操作全部
        //是否接受攻击
    RegisterRoutine('function MapboNotHItNpc(amapname, aname: string; astate: boolean): boolean;', @MapboNotHItNpc); //是否接受攻击；根据 地图和名字    aname=‘’操作全部
    RegisterRoutine('function MapboNotHItMonster(amapname, aname: string; astate: boolean): boolean;', @MapboNotHItMonster); //是否接受攻击；根据 地图和名字    aname=‘’操作全部
        //一定时间不能移动
    RegisterRoutine('function MapNotMoveMonster(amapname, aname: string; atime: integer): boolean;', @MapNotMoveMonster); //一定时间不能移动；根据 地图和名字    aname=‘’操作全部
    RegisterRoutine('function MapNotMoveNpc(amapname, aname: string; atime: integer): boolean;', @MapNotMoveNpc); //一定时间不能移动；根据 地图和名字    aname=‘’操作全部
    RegisterRoutine('function MapNotMoveUser(amapname: string; atime: integer): boolean;', @MapNotMoveUser); //一定时间不能移动；根据 地图
    RegisterRoutine('function NotMoveUser(aname: string; atime: integer): boolean;', @NotMoveUser); //一定时间不能移动；根据 名字
    RegisterRoutine('function MapUserCount(amapname: string): integer;', @MapUserCount); //地图内 玩家数量


    RegisterRoutine('procedure Booth_edit_open(uObject: integer);', @Booth_edit_open); //打开 摊位 编辑 框

    RegisterRoutine('function MapFindNPC(amapname: string; aname, atype: string): integer;', @MapFindNPC); //统计数量；die,死亡；live活；all全部
    RegisterRoutine('function MapDelNPC(amapname: string; aname: string): boolean;', @MapDelNPC);
    RegisterRoutine('function MapAddNPC(amapname: string; aname: string; ax, ay, acount, awidth: integer; aBookName: string; anation, amappathid: integer;aboDieDelete:boolean): boolean;', @MapAddNPC); //地图增加 参数参考Create%s.sdb）
        //动态物体
    RegisterRoutine('function DynamicobjectChange(uObject: integer; astate: string): boolean;', @DynamicobjectChange); //改变 动态物体 状态  astate(dos_Closed, dos_Openning, dos_Openned, dos_Scroll)
    RegisterRoutine('function MapChangeDynamicobject(amapname: string; aname, astate: string): boolean;', @MapChangeDynamicobject); //改变 动态物体 状态  astate(dos_Closed, dos_Openning, dos_Openned, dos_Scroll)
    RegisterRoutine('function MapFindDynamicobject(amapname: string; aname, astate: string): integer;', @MapFindDynamicobject); ////astate(dos_Closed, dos_Openning, dos_Openned, dos_Scroll,all)
    RegisterRoutine('function MapDeldynamicobject(amapname: string; aObjectName: string): boolean;', @MapDeldynamicobject);
    RegisterRoutine('function MapAdddynamicobject(amapname: string; aObjectName, aNeedSkill, aNeedItem, aGiveItem, aDropItem, aDropMop, aCallNpc, axs, ays: string; aNeedAge, aDropX, aDropy: integer): boolean;', @MapAdddynamicobject);
        //地图增加 参数参考Create%s.sdb）

        //怪物
    RegisterRoutine('function MapFindMonster(amapname: string; aname, atype: string): integer;', @MapFindMonster); //统计数量；die,死亡；live活；all全部
    RegisterRoutine('function MapDelmonster(amapname: string; aname: string): boolean;', @MapDelmonster); //地图删除怪物
    RegisterRoutine('function MapAddmonster(amapname: string; aname: string; ax, ay, acount, awidth: integer; amember: string;anation, amappathid: integer;aboDieDelete:boolean): boolean;', @MapAddmonster); //地图增加  怪物 （参数参考Create%s.sdb）

    RegisterRoutine('function SetTLifeObjectRegenInterval(uObject:integer; aRegenInterval:integer):boolean;', @SetTLifeObjectRegenInterval); //指定 怪物 NPC 复活时间
        //门派相关

    RegisterRoutine('function addGuildMagic(uObject:integer):boolean;', @addGuildMagic); //增加门派武功


    RegisterRoutine('function GuildSetDurabilityMax(uObject:integer;value:integer):boolean;', @GuildSetDurabilityMax); //设置最大血量  value 设置的最大血量值
    RegisterRoutine('function GuildSetDurability(uObject:integer;value:integer):boolean;', @GuildSetDurability); //设置当前血量  value 设置的当前血量值
    RegisterRoutine('function GuildGetDurabilityMax(uObject:integer):integer;', @GuildGetDurabilityMax); //获得最大血量
    RegisterRoutine('function GuildGetDurability(uObject:integer):integer;', @GuildGetDurability); //获得当前血量
    RegisterRoutine('function GuildGetLevel(uObject:integer):integer;', @GuildGetLevel); //获得等级
    RegisterRoutine('function GuildLevelDec(uObject:integer; anum:integer):boolean;', @GuildLevelDec); //减少等级
    RegisterRoutine('function GuildLevelAdd(uObject:integer; anum:integer):boolean;', @GuildLevelAdd); //增加等级
    RegisterRoutine('function GuildGetEnegy(uObject:integer):integer;', @GuildGetEnegy); //获得元气
    RegisterRoutine('function GuildEnegyAdd(uObject:integer; anum:integer):boolean;', @GuildEnegyAdd); //增加元气
    RegisterRoutine('function GuildEnegyDec(uObject:integer; anum:integer):boolean;', @GuildEnegyDec); //减少元气
    RegisterRoutine('function GuildIsGuildSubSysop(uObject:integer):boolean;', @GuildIsGuildSubSysop); //测试 是否 是副门主
    RegisterRoutine('function GuildIsGuildSysop(uObject:integer):boolean;', @GuildIsGuildSysop); //测试 是否 是门主
    RegisterRoutine('function GuildLifeDataAdditem(uObject:integer; aitemname:string):boolean;', @GuildLifeDataAdditem); //开启 门派 辅助属性
    RegisterRoutine('function GuildGetName(uObject:integer):string;', @GuildGetName); //获得 门派名字

//武功

    RegisterRoutine('function DeleteMagicName(uObject:integer; aname:string):boolean;', @DeleteMagicName); //删除一个 非当前使用武功

    RegisterRoutine('function getuserAttackMagic(uObject:integer):string;', @getuserAttackMagic); //          获取 当前攻击 名字
    RegisterRoutine('function getuserBreathngMagic(uObject:integer):string;', @getuserBreathngMagic); //      获取 当前心法 名字
    RegisterRoutine('function getuserRunningMagic(uObject:integer):string;', @getuserRunningMagic); //        获取 当前步法 名字
    RegisterRoutine('function getuserProtectingMagic(uObject:integer):string;', @getuserProtectingMagic); //  获取 当前防护 名字


    RegisterRoutine('function getMagicspace(uObject: integer; atype: string): integer;', @getMagicspace); //武功空位  atype=''全部武功包; Magic武功,MagicRise上层;MagicMystery掌法;
    RegisterRoutine('function addMagic(uObject:integer; amagicname:string):boolean;', @addMagic); //          增加武功   返回true 成功
    RegisterRoutine('function IsMagic(uObject:integer; aname:string):boolean;', @IsMagic); //                 测试 武功是否存在   返回:true存在
    RegisterRoutine('function getMagicLevel(uObject:integer; aname:string):integer;', @getMagicLevel); //     获取 武功 等级
    RegisterRoutine('function getMagictype(uObject:integer; aMagicname:string):integer;', @getMagictype); //  获取 武功 类型
    RegisterRoutine('function getMagicExp(uObject:integer; aname:string):integer;', @getMagicExp); //         获取 武功经验
    RegisterRoutine('function AddMagicExp(uObject:integer; aname:string; aexp:integer):integer;', @AddMagicExp); //给指定 武功 加经验

    RegisterRoutine('function getMagic_ALlEnergy(uObject:integer):integer;', @getMagic_ALlEnergy); //         获取 武功经验

        //任务-临时变量
    RegisterRoutine('function SETQuestTempArr(uObject:integer; aindex, aValue:integer):boolean;', @SETQuestTempArr); // 设置任务临时变量值  aindex 位置  aValue值
    RegisterRoutine('function getQuestTempArr(uObject:integer; aindex:integer):integer;', @getQuestTempArr); //         获取 任务临时变量值
        //分任务-注册系统
    RegisterRoutine('function getRegSubQuestIdCount(uObject, qid: integer): integer;', @getRegSubQuestIdCount); //      获取注册任务 某个任务次数
    RegisterRoutine('function getRegSubQuestSum(uObject:integer):integer; ', @getRegSubQuestSum); //                    获取注册任务 任务共计数量 (在注册系统中的数量)
    RegisterRoutine('procedure setRegSubQuest(uObject,qID,atime:integer);', @setRegSubQuest); //                        设置注册任务 qID任务ID， atime过期小时
    RegisterRoutine('function SubQuestRegAdd(uObject, qid: integer): boolean;', @SubQuestRegAdd); //                     增加注册任务 某个任务次数
        //分任务
    RegisterRoutine('function getSubQueststep(uObject:integer):integer;', @getSubQueststep); //                         获取分支任务 任务步骤ID
    RegisterRoutine('procedure setSubQueststep(uObject,qstep:integer);', @setSubQueststep); //                          设置分支任务 任务步骤ID
    RegisterRoutine('function getSubQuestCurrentNo(uObject:integer):integer;', @getSubQuestCurrentNo); //               获取分支任务 当前任务ID
    RegisterRoutine('procedure setSubQuestCurrentNo(uObject,qid:integer);', @setSubQuestCurrentNo); //                  设置分支任务 当前任务ID
        //主任务
    RegisterRoutine('function getQuestNo(uObject:integer):integer;', @getQuestNo); //                                   主任务 完成 ID 获取
    RegisterRoutine('procedure setQuestNo(uObject, qid:integer);', @setQuestNo); //                                     主任务 完成 ID 设置
    RegisterRoutine('function getQueststep(uObject:integer):integer;', @getQueststep); //                               主任务  步骤 获取
    RegisterRoutine('procedure setQueststep(uObject, qstep:integer);', @setQueststep); //                               主任务  步骤 设置
    RegisterRoutine('function getQuestCurrentNo(uObject:integer):integer;', @getQuestCurrentNo); //                     主任务 ID 获取
    RegisterRoutine('procedure setQuestCurrentNo(uObject, qid:integer);', @setQuestCurrentNo); //                       主任务 ID  设置
//全局
    RegisterRoutine('procedure BoothAllClose;', @BoothAllClose); //关闭所有人地摊
    RegisterRoutine('function getServerTempVar(aqid: integer): integer;', @getServerTempVar); //                        获取临时全局TGS开启0-1000范围 全部为0
    RegisterRoutine('procedure setServerTempVar(aqid: integer; anum: integer);', @setServerTempVar); //                 设置临时全局TGS开启0-1000范围 全部为0
    RegisterRoutine('procedure setQuestdata_Server(aqid: integer; aTEXT: string; anum: integer);', @setQuestdata_Server); //任务全局 会保存到文件
    RegisterRoutine('function getQuestdata_Server(aqid: integer; var aTEXT: string;var adate: tdatetime; var anum: integer):boolean; ', @getQuestdata_Server); //获取 任务全局
        //任务 公告信息获取
    RegisterRoutine('function getQuestMainTitle(aqid:integer):string;', @getQuestMainTitle);
    RegisterRoutine('function getQuestMainItem(aqid, akey: integer; var aname: string; var acount: integer): boolean;', @getQuestMainItem); //获取任务预设定物品 名字aname 数量acount；akey预定位置，aqid任务ID
    RegisterRoutine('function getQuestSubItem(aqid, aqsubid, akey: integer; var aname: string; var acount: integer): boolean;', @getQuestSubItem);
    RegisterRoutine('function getQuestMaintext(aqid:integer):string;', @getQuestMaintext);
    RegisterRoutine('function getQuestSubTitle(aqid, aqsubid:integer):string;', @getQuestSubTitle);
    RegisterRoutine('function getQuestSubRequest(aqid, aqsubid:integer):string;', @getQuestSubRequest);
    RegisterRoutine('function getQuestSubtext(aqid, aqsubid:integer):string;', @getQuestSubtext);
        //队伍任务操作
    RegisterRoutine('function GetProcession(uObject: integer; var u1, u2, u3, u4, u5, u6, u7, u8: integer): boolean;', @GetProcession); //获取 队伍成员  u1-u8 队伍内8个成员，0表示没有
    RegisterRoutine('function QuestProcessionAdd(uObject: integer; atype: string; aQuestID, aQuestStep, aIndex, aAddCount, aAddMax: integer): boolean;', @QuestProcessionAdd); //队伍任务临时变量 atype 类型（1主线任务、2支线任务）aQuestID任务ID, aQuestStep任务步骤, aIndex变量ID, aAddCount增加数量  aAddMax最大不能超过

    RegisterRoutine('procedure MenuSay(uObject:integer; SAYTEXT:string);', @MenuSay); //NPC菜单
    RegisterRoutine('procedure say(uObject:integer; SAYTEXT:string);', @SAY); //说话 白话
    RegisterRoutine('procedure saysystem(uObject:integer; SAYTEXT:string);', @saysystem); //系统提示消息
        //        RegisterRoutine('function callfunc(uObject:integer; funccmd:string):string;', @callfunc); //一个群脚本指令（慢慢取消掉）
                //系统函数
    RegisterRoutine('function IntToStr(Value: Integer): string;', @inttostr);
    RegisterRoutine('function _StrToInt(str:string):Integer;', @_StrToInt);
    RegisterRoutine('function Random(aScope:integer):integer;', @Random);
    RegisterRoutine('function now():tdatetime;', @now);
    RegisterRoutine('procedure dec(var Value: Integer);', @_dec);
    RegisterRoutine('procedure Inc(var Value: Integer);', @_Inc);


    RegisterRoutine('procedure DecodeDateMonthWeek(AValue:TDateTime; var AYear, AMonth, AWeekOfMonth, ADayOfWeek:Word);', @DecodeDateMonthWeek);
        //DecodeDateMonthWeek方法根据TDateTime类型参数Avalue 得到相应的年份、月份、月份中的第几个 星期、星期几
        //AYear年份/AMonth月份1到12/AWeekOfMonth在该月份中的第几个星期/ADayOfWeek星期几。星期一为1。
    RegisterRoutine('procedure DecodeDateTime(Avalue:TDateTime; var AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond:Word);', @DecodeDateTime);
        //DecodeDateTime 方法根据TDateTime类型参数Avalue 得到相应的AYear年份、AMonth月份、ADay日子、AHour小时、AMinute分、ASecond秒、AMilliSecond毫秒。
        /////////////////////////////////////////////
        //             物品 通用 属性
    RegisterRoutine('function getitem(uObject:integer; atype:string; afield:string; akey:integer):string;', @getitem);
        //atype:类型（背包，装备，时装）; field:（item.sdb里字段）; akey:（位置）注意:getitem函数效率比单独查询函数消息低;但比较全面
    RegisterRoutine('function getitemLifeData(uObject:integer; atype:string; afield:string; akey:integer; var adamageBody, adamageHead, adamageArm, adamageLeg, aarmorBody, aarmorHead, aarmorArm, aarmorLeg, aAttackSpeed, aavoid, arecovery, aaccuracy:integer):boolean;', @getitemLifeData);
        //返回12个属性值atype:类型（背包，装备，时装）; field:（rLifeDataBasic原始,rLifeDataLevel精炼,rLifeDataPro镶嵌,rLifeData合计）; akey:（位置）
    RegisterRoutine('function getitemrSetting(uObject:integer; atype:string; akey:integer; var asettingcount:integer; asetting1, asetting2, asetting3, asetting4:string):boolean;', @getitemrSetting);
        //返回所有镶嵌资料;atype:类型（背包，装备，时装）;  akey:（位置）
    RegisterRoutine('function getitemrUpdateLevel(uObject:integer; atype:string; akey:integer; var aitemname:string; var aKind, aSmithingLevel, aWearArr, aGrade, aMaxUpgrade:integer; var aboUpgrade:boolean):boolean;', @getitemrUpdateLevel);
        //返回所有精炼需要资料; atype:类型（背包，装备，时装）; akey:（位置）

//任务背包
    RegisterRoutine('function DelItemQuest(uObject: integer; aitemname: string; acount: integer): boolean;', @DelItemQuest);
    RegisterRoutine('function DelItemQuestID(uObject: integer; aQuestID: integer): boolean;', @DelItemQuestID);
    RegisterRoutine('function AddItemQuest(uObject: integer; aitemname: string; acount: integer): boolean;', @AddItemQuest);
    RegisterRoutine('function GetItemQuestCount(uObject: integer; aitemname: string): integer;', @GetItemQuestCount);
    RegisterRoutine('function GetItemSpaceCount(uObject: integer): integer;', @GetItemSpaceCount); //任务背包 空位置数量
        /////////////////////////////////////////////
//背包 物品
    RegisterRoutine('function getHaveItemLockedPass(uObject:integer):boolean;', @getHaveItemLockedPass); //                  背包 密码 锁
        //背包 属性 优先使用下面函数
    RegisterRoutine('function getitemSpecialKind(uObject: integer; akey: integer): integer;', @getitemSpecialKind); //背包 物品，特殊KIND
    RegisterRoutine('function getitemMixName(uObject: integer; akey: integer): string;', @getitemMixName); //背包 物品，合成目标名字
    RegisterRoutine('function getitemSpecialLevel(uObject: integer; akey: integer): integer;', @getitemSpecialLevel); //背包 某位置 物品 rSpecialLevel
    RegisterRoutine('function getitemDurability(uObject: integer; akey: integer): integer;', @getitemDurability); //背包 某位置 物品 Durability
    RegisterRoutine('function setitemDurability(uObject: integer; akey, aDurability: integer): boolean;', @setitemDurability);
    RegisterRoutine('function getitemGrade(uObject: integer; akey: integer): integer;', @getitemGrade); //背包 某位置 物品 Grade
    RegisterRoutine('function getitemStarLevel(uObject: integer; akey: integer): integer;', @getitemStarLevel); //           背包 某位置 物品 StarLevel
    RegisterRoutine('function setitemStarLevel(uObject: integer; akey, alevel: integer): boolean;', @setitemStarLevel); //背包 某位置 物品 StarLevel
    RegisterRoutine('function setitemBlueprint(uObject: integer; akey: integer; astate: boolean): boolean;', @setitemBlueprint); //背包 某位置 物品 Blueprint
    RegisterRoutine('function getitemBlueprint(uObject: integer; akey: integer): boolean;', @getitemBlueprint); //背包 某位置 物品 Blueprint
//        RegisterRoutine('function getitemPrestige(uObject: integer; akey: integer): boolean;', @getitemPrestige); //背包 某位置 物品 Prestige
    RegisterRoutine('function SetItemUPdataLevelNew(uObject: integer; akey: integer; alevel: integer): boolean;', @SetItemUPdataLevelNew); ////akey 背包中的位置 alevel等级

    RegisterRoutine('function getitemname(uObject:integer; akey:integer):string;', @getitemname); //                         背包 某位置 物品 name'
    RegisterRoutine('function getitemKind(uObject:integer; akey:integer):integer;', @getitemKind); //                        背包 某位置 物品 rKind
    RegisterRoutine('function setitemAttach(uObject: integer; akey, aAttach: integer): boolean;', @setitemAttach); //        设置 背包 某位置 物品 Attach
    RegisterRoutine('function getitemAttach(uObject: integer; akey: integer): integer;', @getitemAttach); //                 背包 某位置 物品 Attach
    RegisterRoutine('function getitemWearArr(uObject:integer; akey:integer):integer;', @getitemWearArr); //                  背包 某位置 物品 rWearArr
    RegisterRoutine('function getitemHitType(uObject: integer; akey: integer): integer;', @getitemHitType);
    RegisterRoutine('function getitemPrice(uObject:integer; akey:integer):integer;', @getitemPrice); //                      背包 某位置 物品 价格
    RegisterRoutine('function getitemboUpgrade(uObject:integer; akey:integer):boolean;', @getitemboUpgrade); //              背包 某位置 物品 是否用许升级
    RegisterRoutine('function getitemSmithingLevel(uObject:integer; akey:integer):integer;', @getitemSmithingLevel); //      背包 某位置 物品 精炼等级
    RegisterRoutine('function getitemSmithingLevelMax(uObject:integer; akey:integer):integer;', @getitemSmithingLevelMax); //背包 某位置 物品 精炼等级最高等级
    RegisterRoutine('function getitemcount(uObject:integer; aitemname:string):integer;', @getitemcount); //                  背包 某位置 物品 数量 参数：aitemname物品名字 返回：-1  失败   >=0数量
    RegisterRoutine('function getitemKeyCount(uObject: integer; akey: integer): integer;', @getitemKeyCount);

    RegisterRoutine('function getitemboident(uObject:integer; akey:integer):boolean;', @getitemboident); //背包 某位置 物品 是否可鉴定
    RegisterRoutine('function setitemboident(uObject:integer; akey:integer;astate:boolean):boolean;', @setitemboident); //设置 背包 某位置 物品 是否可鉴定

    RegisterRoutine('function getitemSettingCount(uObject:integer; akey:integer):integer;', @getitemSettingCount); //        背包 某位置 物品 孔数量
    RegisterRoutine('function getitemSettingSpaceCount(uObject:integer; akey:integer):integer;', @getitemSettingSpaceCount); //背包 某位置 物品 未镶嵌宝石 空闲孔数量

    RegisterRoutine('function getItemMaterialArr(uObject: integer; akey: integer; out aname1, aname2, aname3, aname4: string; out acount1, acount2, acount3, acount4: integer): boolean;', @getItemMaterialArr); //合成材料
     //    RegisterRoutine('function ItemUPdataSetting_Stiletto(uObject:integer; akey:integer):integer;', @ItemUPdataSetting_Stiletto); //    镶嵌  清除
    RegisterRoutine('function ItemUPdataSetting(uObject:integer; akey, aaddKey:integer):boolean;', @ItemUPdataSetting); //   镶嵌  akey 物品 位置， aaddKey宝石位置，成功自动扣宝石数量，
    RegisterRoutine('function ItemUPdataSetting_del(uObject:integer; akey:integer):boolean;', @ItemUPdataSetting_del); //    镶嵌  清除
    RegisterRoutine('function ItemUPdataLevel(uObject:integer; akey:integer;alevel, damageBody, damageHead, damageArm, damageLeg, armorBody, armorHead, armorArm, armorLeg, AttackSpeed, avoid, recovery, accuracy:integer):boolean;', @ItemUPdataLevel);

        //astate true 成功升1级 并且 增加附带的12个属性。 FALSE 把等级恢复到0级，装备精炼属性12个，都为0。
        //akey 背包中的位置

    RegisterRoutine('function HaveItemaffairStart(uObject:integer):boolean;', @HaveItemaffairStart); //        背包事务  开始
    RegisterRoutine('function HaveItemaffairRoll_back(uObject:integer):boolean;', @HaveItemaffairRoll_back); //背包事务  回滚到上次执行 HaveItemaffairStart前状态
    RegisterRoutine('function HaveItemaffairConfirm(uObject:integer):boolean;', @HaveItemaffairConfirm); //    背包事务  确认无误

        //孔数量SettingCount，星级StarLevel，精炼等级SmithingLevel，附加属性Attach，制造者名字createname，染色颜色color，持久rDurability  <0不改变，其他的<=0不改变
    RegisterRoutine('function addItemEx(uObject: integer; aitemname, acreatename: string; aStarLevel, aSmithingLevel, aSettingCount, aAttach, aDurability, acolor: integer): boolean;', @addItemEx);
    RegisterRoutine('function setItemSettingCount(uObject: integer; akey: integer; acount: integer): boolean;', @setItemSettingCount); //      增加背包物品空数量 参数：aitemname物品名字 acount 孔数量 返回：true成功
    RegisterRoutine('function additem(uObject:integer; aitemname:string; acount:integer):boolean;', @additem); //      增加背包物品数量 参数：aitemname物品名字 acount 数量 返回：true成功
    RegisterRoutine('function deleteitem(uObject:integer; aitemname:string; acount:integer):boolean;', @deleteitem); //删除背包物品数量 参数：aitemname物品名字 acount 数量 (<=0 表示有全部删除)返回：true成功
    RegisterRoutine('function deleteItemKey(uObject:integer; akey, acount:integer):boolean;', @deleteItemKey); //      删除背包物品数量 参数：akey位置 acount 数量 返回：true成功
    RegisterRoutine('function FindItemName(uObject:integer; aitemname:string):integer;', @FindItemName); //            背包中查找 某物品 位置 0-29    -1 失败


    RegisterRoutine('function getitemspace(uObject:integer):integer;', @getitemspace); //背包 空位
//技能职业
    RegisterRoutine('function getJobKind(uObject: integer): integer;', @getJobKind); //获取职业类型
    RegisterRoutine('function setJobKind(uObject: integer; aKind: integer): boolean;', @setJobKind); //修改 职业类型（1，2，3，4），修改后等级是1级。
    RegisterRoutine('function addJobLevelExp(uObject: integer; aExp,aMaxExp: integer): boolean;', @addJobLevelExp); //增加等级经验
    RegisterRoutine('function getJobLevel(uObject: integer): integer;', @getJobLevel); //获取职业等级
    RegisterRoutine('function SetJobLevel(uObject: integer; alevel: integer): boolean;', @SetJobLevel); //设置等级
    RegisterRoutine('function getJobGradeName(uObject: integer): string;', @getJobGradeName); //职业  品名
    RegisterRoutine('function getJobGrade(uObject: integer): integer;', @getJobGrade); //职业 品级
//浩然
    RegisterRoutine('function addVirtueExp(uObject: integer; aexp, aMaxLevel: integer): boolean;', @addVirtueExp); //增加浩然 经验，（不是等级）  aexp经验, aMaxLevel本次增加不能超过的浩然等级
    RegisterRoutine('function GetVirtueLevel(uObject: integer): integer;', @GetVirtueLevel); //获取浩然 等级
//身上
    RegisterRoutine('function WearGETRepairGoldSum(uObject: integer): integer;', @WearGETRepairGoldSum); //身上维修需要共计钱
    RegisterRoutine('function WearRepairAll(uObject: integer): boolean;', @WearRepairAll); //维修 身上所有装备    不会检查钱和扣钱
//属性


    RegisterRoutine('function getMapID(uObject: integer): integer;', @getMapID); //     地图ID      返回：-1  失败
    RegisterRoutine('function getMaxLife(uObject: integer): integer;', @getMaxLife); // 最大活力    返回：-1  失败
    RegisterRoutine('function getCurLife(uObject: integer): integer;', @getCurLife); // 当前活力     返回：-1  失败
    RegisterRoutine('function getsex(uObject:integer):integer;', @getsex); //          性别 返回：-1  失败   1  男  2 女
    RegisterRoutine('function getage(uObject:integer):integer;', @getage); //          年龄 返回：-1  失败   >=0年龄
    RegisterRoutine('function getname(uObject:integer):string;', @getname); //          名字 返回：空  失败  非空名字
    RegisterRoutine('function getprestige(uObject:integer):integer;', @getprestige); //获取声望
//翻倍经验
    RegisterRoutine('procedure MagicExpMulAdd(uObject: integer; aMulCount, aHour: integer);', @MagicExpMulAdd);
    RegisterRoutine('function MagicExpMulGetDay(uObject: integer): integer;', @MagicExpMulGetDay);
    RegisterRoutine('function MagicExpMulGetCurMulMinutes(uObject: integer): integer;', @MagicExpMulGetCurMulMinutes); //获取，当前翻倍时间，剩余分钟
//元气
    RegisterRoutine('function getEnergy(uObject:integer):integer;', @getEnergy); //获取元气
    RegisterRoutine('function getEnergyLevel(uObject: integer): integer;', @getEnergyLevel); //真实值 境界等级
    RegisterRoutine('function getEnergyCalc(uObject: integer): integer;', @getEnergyCalc); //元气 计算值（玩家看到的值）
    RegisterRoutine('procedure SetEnergy(uObject, qid: integer);', @SetEnergy); //设置元气
    RegisterRoutine('procedure setprestige(uObject, qid:integer);', @setprestige); //  设置声望

    RegisterRoutine('function SETTempArr(uObject:integer; aindex, aValue:integer):boolean;', @SETTempArr); // 设置临时变量值  aindex 位置  aValue值
    RegisterRoutine('function getTempArr(uObject:integer; aindex:integer):integer;', @getTempArr); //         获取临时变量值

    RegisterRoutine('function DesignationSpaceCount(uObject: integer): integer;', @DesignationSpaceCount); //称号 空位置
    RegisterRoutine('function DesignationCheck(uObject: integer; aid: integer): boolean;', @DesignationCheck); //称号 是否存在
    RegisterRoutine('function DesignationAdd(uObject: integer; aid: integer): boolean;', @DesignationAdd); //增加 称号

        //身上 穿戴

    RegisterRoutine('function deletewearitem(uObject:integer; akey:integer):boolean;', @deletewearitem); //                 当前 身上 某位置 装备 删除掉
    RegisterRoutine('function getwearitemviewnamename(uObject:integer; akey:integer):string;', @getwearitemviewnamename); //身上装备(显示)名字 参数：akey位置 返回：空  失败  非空名字
    RegisterRoutine('function getwearitemname(uObject:integer; akey:integer):string;', @getwearitemname); //                身上装备（真实）名字 参数：akey位置 返回：空  失败  非空名字
        //婚姻
    RegisterRoutine('function getmarryinfo(uObject:integer):boolean;', @getmarryinfo); //                          获取 结婚状态    返回：true是
    RegisterRoutine('function getparty(uObject:integer):boolean;', @getparty); //                                  获取 结婚当事人   返回：true是
    RegisterRoutine('function getmarryclothes(uObject:integer):boolean;', @getmarryclothes); //                    获取过结婚礼物  返回：  TRUE领取
    RegisterRoutine('function getmarriage(uObject:integer):boolean;', @getmarriage); //                            获取 婚礼状态    TRUE结婚
    RegisterRoutine('function Marry(uObject:integer; atext:string):boolean;', @Marry); //                          结婚    参数 atext 附带消息  返回：TRUE指令成功发出
    RegisterRoutine('function unmarry(uObject:integer):boolean;', @unmarry); //                                    离婚    参数 amarryname 对象  返回：TRUE指令成功发出
    RegisterRoutine('function setmarryclothes(uObject:integer):boolean;', @setmarryclothes); //                    设置 已经拿过礼服
    RegisterRoutine('function setauditoria(uObject:integer):boolean;', @setauditoria); //                          设置 礼堂进行结婚仪式，设置成功后会被记录 可查询
    RegisterRoutine('function showmarriage(uObject:integer; astr:string; atype:integer):boolean;', @showmarriage); //弹出 输入婚礼问答筐 参数：astr内容 atype 1要求男的回答 2要求女的回答（内容记录在结婚系统） 应答是或者不是后，系统公告 内容和答案
    RegisterRoutine('function showsetofficiator(uObject:integer; aname:string):boolean;', @showsetofficiator); //  设置 主婚人 uSource人 弹出输入筐 设置成功系统公告
     //反击
    RegisterRoutine('function NewCounterAttack_hit(uObject:integer; astate:boolean;atime:integer):boolean;', @NewCounterAttack_hit); //是否开启反击 astate ture 开启反击 false 关闭反击
        //元神
    RegisterRoutine('function MonsterCheck(uObject: integer): boolean;', @MonsterCheck);
    RegisterRoutine('function MonsterCreate(uObject: integer; aMonsterName: string): boolean;', @MonsterCreate);
    RegisterRoutine('function MonsterFree(uObject: integer): boolean;', @MonsterFree);
        //移动 目标
    RegisterRoutine('function MapMove(uObject: integer; amapid: integer; ax, ay, aDelayTick: integer): boolean;', @MapMove); //移动指定目标到指定位置    参数 amapid 地图序号 AX AY 坐标 返回：true命令下达成功（不表示传送成功）
        //==公共指令
    RegisterRoutine('procedure marriagebulletin(astr:string);', @marriagebulletin); //   发布 婚礼 公告 参数：astr 消息内容
    RegisterRoutine('function getauditoria():boolean;', @getauditoria); //           获取 礼堂 状态    TRUE占用
    RegisterRoutine('function setmarriageend():boolean;', @setmarriageend); //           设置 婚礼完成空出教堂  没返回值
    RegisterRoutine('function setmarrystep(astep:integer):boolean;', @setmarrystep); //  设置 当前第几步骤。  字符行数字
    RegisterRoutine('function getofficiator():string;', @getofficiator); //           获取 主婚人
    RegisterRoutine('function getmarrystep():integer;', @getmarrystep); //           获取 当前第几步骤。 返回：-1 失败
    RegisterRoutine('function getpartymanname():string;', @getpartymanname); //          获取 新郎名字
    RegisterRoutine('function getpartywomanname():string;', @getpartywomanname); //      获取 新娘名字

    RegisterRoutine('procedure centermsg(atext:string; acolor:integer);', @centermsg); //中间 消息筐 acolor字颜色  WIN颜色值
    RegisterRoutine('procedure topmsg(atext:string; acolor:integer);', @topmsg); //      TOP  消息筐  acolor 字颜色  WIN颜色值
    RegisterRoutine('procedure worldnoticemsg(atext:string; afcolor, abcolor:integer);', @worldnoticemsg); //普通世界消息   afcolor字颜色 WIN颜色值  abcolor背景颜色 win颜色值

    RegisterRoutine('function _pos(asubstr: string; astr: string): integer;', @_pos);
    RegisterRoutine('function _LastChar(astr: string): string;', @_LastChar);

    RegisterRoutine('function DateTimeToStr(DateTime: TDateTime): string;', @_DateTimeToStr);

    RegisterRoutine('function getUserListCount(): integer;', @getUserListCount); //获取 在线人数
  end;
  
    {


    ***脚本目录结构
    .\Script
         \GameSys.pas        说明：系统级脚本。
         \Dynamic            说明：动态物体相关。
         \Gate               说明：跳点相关。
         \Item               说明：物品相关。
         \manager            说明：地图相关。
         \Monster            说明：怪物相关。
         \npc                说明：NPC相关。

////////////////////////////////////////////////////////////////////////////
***脚本指令
说明：var、OUT参数部分，是返回变量。

   1，function MsgBoxTempOpen(uObject:integer; aCaption, astr:string):boolean;
      功能：打开临时消息窗口
      参数:
        uObject  ，玩家对象。
        aCaption ，标题。
        astr     ，内容。
   2，function getAQData(uObject: integer; atype: string): integer;
    功能：获取角色 任务特殊属性
    参数:
      uObject 玩家对象
      atype 类型
      'L'
         攻击： ldamagebody 身体攻击  ldamagehead 头攻击 ldamagearm 手攻击 ldamageleg 脚攻击
         防御：larmorbody 身体防御 larmorhead 头防御  larmorarm 手防御  larmorleg 脚防御
         特殊： lattackspeed攻击速度  lavoid躲闪   lrecovery恢复  laccuracy命中
      'a'
          aage 年龄
          alight 阳气
          adark  阴气
          avirtue 浩然
          aadaptive 耐性
          arevival  再生
      'e'
         eenergy 元气
         einpower 内功
         eoutpower 外功
         emagic  武功
         elife   活力
      'h'
       hheadseak    头
       harmseak     手
       hlegseak     脚
       hhealth      健康
       hsatiety     饱和
       hpoisoning    中毒
       htalent       才能
       hgoodchar   神性
       hbadchar    魔性
       hlucky     幸运
       himmunity   免疫
       hr3f_sky   天
       hr3f_terra  地
       hr3f_fetch   命
    3，procedure SetAQData(uObject: integer; atype: string; avalue: integer);
    功能：
      //设置角色任务特殊属性
    参数：
      uObject 玩家对象
      atype 类型 同getAQData 类型相同
      avalue 输入需要设置的值
//效果指令

    4，function ShowSound(uObject: integer; asound: integer): boolean;
      功能：
          //显示声音
      参数:
      uObject 基类对象
      asound 输入需要播放声音的ID
   **function ShowEffect(uObject: integer; aEffectNum: integer; atype: string): boolean;
      功能：
         显示效果
      参数:
       uObject 基类对象
       aEffectNum 要显示效果的ID；对应客户端effect目录文件。ID-1后对应文件名字。
       atype  ，类型
           lek_none,无，
           lek_follow，跟随角色移动。
    **function HIT_Screen(uObject: integer; aHit: integer): boolean;
      功能：
         全屏幕 攻击（无动画效果），可以用ShowEffect配合使用。
      参数:
          uObject 基类对象
          aHit，攻击伤害
    **function getItemInputWindowsKey(uObject: integer; aSubKey: integer): integer;
      功能：
          物品输入窗口；背包物品拖放到NPC菜单窗口下；给脚本提供要操作物品所在背包位置。
          一共有5个物品输入筐。
      参数:
          uObject 玩家对象
          aSubKey  传入窗口的ID值
      返回：背包位置0-29之间。
    **function setItemInputWindowsKey(uObject: integer; aSubKey: integer; akey: integer): boolean;
      功能：
         设置物品输入窗口；同getItemInputWindowsKey。
      参数:
         uObject 玩家对象
         aSubKey  传入窗口的ID值
         akey    背包key值；0-29范围。
    **function ItemInputWindowsClose(uObject: integer): boolean;
      功能：
        关闭物品输入窗口
      参数:
        uObject 玩家对象
    **function ItemInputWindowsOpen(uObject: integer; aSubKey: integer; aCaption: string; aText:string): boolean;
    功能：
        关打开物品输入窗口
    参数:
        uObject 玩家对象
        aSubKey 窗口ID
        aCaption，窗口标题
        aText，默认提示。窗口鼠标移动到上面显示。
    **procedure topyoumsg(uObject:integer; atext:string; acolor:integer);
      功能：
         发送消息  顶部
      参数:
        uObject  玩家对象
        atext    发送的内容
        acolor   颜色值
    **procedure LeftText1(uObject:integer; astr:string;acolor:integer);
      功能：
          左下边 吃药处发送消息
      参数:
        uObject 玩家对象
        astr  发送的内容
        acolor 颜色
    **procedure LeftText2(uObject:integer; astr:string;acolor:integer);
      功能：
          发送左下边 第二个输入框的消息
      参数:
        uObject 玩家对象
        astr  发送的内容
        acolor 颜色
    **procedure LeftText3(uObject:integer; astr:string;acolor:integer);
      功能：
          发送左下边 第三个输入框的消息
      参数:
        uObject 玩家对象
        astr  发送的内容
        acolor 颜色
    **function get3f_sky(uObject:integer):integer;
      功能：
         返回三魂属性中天的值
      参数:
        uObject 玩家对象
    **function get3f_terra(uObject:integer):integer;
      功能：
         返回三魂属性中地的值
      参数:
        uObject 玩家对象
    **function get3f_fetch(uObject:integer):integer;
      功能：
         返回三魂属性中命的值
      参数:
        uObject 玩家对象
    **function set3f_sky(uObject:integer; acount:integer):boolean;
      功能：
         设置三魂属性中天的值
      参数:
        uObject 玩家对象
        acount 需要设置的值
    **function set3f_terra(uObject:integer; acount:integer):boolean;
      功能：
         设置三魂属性中地的值
      参数:
        uObject 玩家对象
        acount 需要设置的值
    **function set3f_fetch(uObject:integer; acount:integer):boolean;
      功能：
         设置三魂属性中命的值
      参数:
        uObject 玩家对象
        acount 需要设置的值
    **procedure setnation(uObject: integer; anation: integer);
      功能：
          //设置部落 国家   范围0到255
      参数:
        uObject 基类对象
        anation  设置改变的值 范围0到255
    **function getnation(uObject: integer): integer;
      功能：
        //获取 部落 国家   范围0到255
      参数:
        uObject 基类对象；怪物、人、元神。
    **function ObjectDelaySay(uObject: integer; asay: string; atime: integer): boolean;
      功能：
        //基类对象 延迟时间 消息  atime 100=1秒
      参数:
        uObject 基类对象
        asay    发送的内容
        atime   延迟的时间
    **function ObjectNotMove(uObject: integer; atime: integer): boolean;
      功能：
        //锁定对象一段时间 不能移动 atime 100=1秒
      参数:
        uObject 玩家对象
        atime 锁定对象的时间
    **function ObjectBoNotHit(uObject: integer; astate: boolean): boolean;
      功能：
        是否接受攻击；改变对象(玩家,怪物,NPC) 进入无敌模式；
      参数:
        uObject 玩家对象
        astate TRUE 无敌模式 FALSE 非无敌模式
    **function ObjectKill(uObject, uKillObject: integer): boolean;
      功能：
        //uObject杀死KillObject对象 ,支持杀死人，怪物，NPC
      参数:
        uObject 基类对象
        uKillObject 基类对象
    **function MapObjIceMonster(aManager: integer; aname: string; astate: boolean): boolean;
      功能：
         //冻结 怪物   aname='' 冻结全部
      参数:
        aManager 地图对象
        aname 怪物名称
        astate  TRUE 冻结怪物 FALSE 解除冻结怪物
    **procedure MapObjSay(aManager: integer; asay: string; acolor: integer);
      功能：
         地图说话
      参数:
        aManager 地图对象
        asay 说话内容
        acolor 颜色值
//地图相关
    **procedure MapSendChatMsg(amapname: string; asay: string; acolor: integer);
      功能：
         地图说话
      参数:
        amapname 地图名称
        asay 说话内容
        acolor 颜色值
//复活
    **function MapRegen(amapname: string): boolean;
      功能：
         复活 地图，和定时重新复活一样处理
      参数:
        amapname 地图名称
机制
    **function MapIceMonster(amapname: string; aname: string; astate: boolean): boolean;
      功能：
         通过地图名称冻结 怪物
      参数:
         amapname 地图名称
         aname  需要冻结怪物的名称    aname='' 冻结全部怪物
         astate  TRUE 冻结怪物 FALSE 解除冻结怪物
    **function MapRegenMonster(amapname: string; aname: string): boolean;
      功能：
        通过怪物名称复活怪物
      参数:
         amapname 地图名称
         aname  需要复活怪物的名称    aname='' 复活全部怪物
    **function MapRegenDynamicObject(amapname: string; aname: string): boolean;
      功能：
        通过地图名称 复活 动态物体
      参数:
         amapname 地图名称
         aname  需要复活的动态物体的名称    aname='' 复活全部动态物体
    **function MapRegenNpc(amapname: string; aname: string): boolean;
      功能：
        通过地图名称 复活 NPC
      参数:
         amapname 地图名称
         aname  需要复活的NPC的名称    aname='' 复活全部NPC
    **function MapDelaySayNPC(amapname, aname, asay: string; atime: integer): boolean;
      功能：
        NPC延时 话语；根据 地图名字和NPC名字
      参数:
        amapname 地图名称
        aname  需要延迟说话的NPC的名称    aname='' 操作全部
        asay 说话的内容
        atime 延迟时间
    **function MapDelaySayMonster(amapname, aname, asay: string; atime: integer): boolean;
      功能：
        怪物延时 话语；地图名字和怪物名字    aname=‘’操作全部
      参数:
        amapname 地图名称
        aname  需要延迟说话的怪物的名称    aname='' 操作全部
        asay 说话的内容
        atime 延迟时间
    **function MapboNotHItNpc(amapname, aname: string; astate: boolean): boolean;
      功能：
        NPC是否接受攻击；根据地图名称和NPC名称    aname=‘’操作全部
      参数:
        amapname 地图名称
        aname NPC的名称
        astate 为TRUE时不接受攻击 FALSE 接受攻击
    **function MapboNotHItMonster(amapname, aname: string; astate: boolean): boolean;
      功能：
        NPC是否接受攻击；根据地图名称和怪物名称
      参数:
        amapname 地图名称
        aname 怪物的名称   aname=‘’操作全部
        astate 为TRUE时不接受攻击 FALSE 接受攻击
    **function MapNotMoveMonster(amapname, aname: string; atime: integer): boolean;
      功能：
        根据地图名称 一定时间内地图限制怪物移动
      参数:
        amapname 地图名称
        aname 怪物的名称  aname=‘’操作全部
        atime 设置怪物不能移动的时间

    **function MapNotMoveNpc(amapname, aname: string; atime: integer): boolean;
      功能：
        根据地图名称 一定时间内地图限制NPC移动
      参数:
        amapname 地图名称
        aname NPC的名称  aname=‘’操作全部
        atime 设置NPC不能移动的时间
    **function MapNotMoveUser(amapname: string; atime: integer): boolean;
      功能：
        根据地图名称  一定时间内地图限制玩家移动
      参数:
        amapname 地图名称
        atime 设置玩家不能移动的时间
    **function NotMoveUser(aname: string; atime: integer): boolean;
      功能：
        根据玩家名字 一定时间内地图限制玩家移动
      参数:
        amapname 地图名称
        atime 设置玩家不能移动的时间
    **function MapUserCount(amapname: string): integer;
      功能：
        根据地图名称 获取地图内玩家的数量
      参数:
        amapname 地图名称
    **procedure Booth_edit_open(uObject: integer);
      功能：
        打开摊位编辑框
      参数:
        uObject 玩家对象
    **function MapFindNPC(amapname: string; aname, atype: string): integer;
      功能：
        根据地图名称 查找NPC的数量
      参数:
        amapname 地图名称
        aname NPC名称
        atype  die,死亡；live活；all全部
    **function MapDelNPC(amapname: string; aname: string): boolean;
      功能：
        根据地图名称 删除NPC
      参数:
        amapname 地图名称
        aname NPC名称
    **function MapAddNPC(amapname: string; aname: string; ax, ay, acount, awidth: integer; aBookName:
                        string; anation, amappathid: integer;aboDieDelete:boolean): boolean;
      功能：
        根据地图名称 增加NPC
      参数:
        amapname 地图名称
        aname NPC名称
        ax 创建NPC的X坐标
        ay 创建NPC的Y坐标
        acount 创建NPC的数量
        awidth 创建NPC的范围
        aBookName  预存的NPC说话的内容
        anation 创建NPC所属的国家
        amappathid 设置路径(预先在mappathid.sdb设置好的路径)
        aboDieDelete 死亡后是否删除
//动态物体
    **function DynamicobjectChange(uObject: integer; astate: string): boolean;
      功能：
        根据动态物体对象 改变动态物体状态
      参数:
        uObject 动态物体对象
        astate  传入需要修改的某一状态
          dos_Closed, 关闭的
          dos_Openning, 打开中的
          dos_Openned,   已经打开的
          dos_Scroll,（没用）
    **function MapChangeDynamicobject(amapname: string; aname, astate: string): boolean;
      功能：
        根据地图名称和动态物体名称 改变动态物体状态
      参数:
        amapname 地图名称
        aname 动态物体名称
        astate  传入需要修改的某一状态
          dos_Closed, 关闭的
          dos_Openning, 打开中的
          dos_Openned,   已经打开的
          dos_Scroll（没用）
    **function MapFindDynamicobject(amapname: string; aname, astate: string): integer;
      功能：
        根据地图名称和动态物体名称 查找动态物体的数量
      参数:
        amapname 地图名称
        aname 动态物体名称
        astate  传入需要查找的某一状态
          dos_Closed, 关闭的
          dos_Openning, 打开中的
          dos_Openned,   已经打开的
          dos_Scroll  （没用）
    **function MapDeldynamicobject(amapname: string; aObjectName: string): boolean;
      功能：
        根据地图名称和动态物体名称 查找动态物体的数量
      参数:
        amapname 地图名称
        aname 动态物体名称
        astate  传入需要查找的某一状态
          dos_Closed, 关闭的
          dos_Openning, 打开中的
          dos_Openned,   已经打开的
          dos_Scroll （没用）
    **function MapAdddynamicobject(amapname: string; aObjectName, aNeedSkill, aNeedItem, aGiveItem,
      aDropItem, aDropMop, aCallNpc, axs, ays: string; aNeedAge, aDropX, aDropy: integer): boolean;
      功能：
        根据地图名称和动态物体名称 增加动态物体
      参数:
        amapname 地图名称
        aObjectName 动态物体名称
        aNeedSkill  需要的技能
        aNeedItem   需要的物品
        aGiveItem
        aDropItem    掉落的物品
        aDropMop     放出的怪物
        aCallNpc     放出的NPC
        axs          X坐标
        ays          Y坐标
        aNeedAge     需要的年龄
        aDropX       掉落物品的X坐标
        aDropy       掉落物品的X坐标

//怪物
    **function MapFindMonster(amapname: string; aname, atype: string): integer;
      功能：
        根据地图名称和怪物名称 查找怪物的数量
      参数:
        amapname 地图名称
        aname 怪物名称
        atype  die,死亡；live活；all全部
    **function MapDelmonster(amapname: string; aname: string): boolean;
      功能：
        根据地图名称和怪物名称 删除怪物
      参数:
        amapname 地图名称
        aname 怪物名称
    **function MapAddmonster(amapname: string; aname: string; ax, ay, acount, awidth: integer;
      amember: string;anation, amappathid: integer;aboDieDelete:boolean): boolean;
      功能：
        根据地图名称和怪物名称 增加怪物
      参数:
        amapname 地图名称
        aname 怪物名称
        ax,  创建怪物的X坐标
        ay,  创建怪物的Y坐标
        acount, 创建怪物的数量
        awidth: 创建怪物的范围
        amember 怪物携带的成员
        anation,怪物所属的国家
        amappathid: 设置预先设置好的路径(mappathid.sdb设置)
        aboDieDelete 死亡后是否删除
    **function SetTLifeObjectRegenInterval(uObject:integer; aRegenInterval:integer):boolean;
      功能：
        指定 怪物 NPC 复活时间
      参数:
        uObject  TLifeObject对象 怪物和NPC
        aRegenInterval   复活间隔
    **function addGuildMagic(uObject:integer):boolean;
      功能：
        增加门派武功
      参数:
        uObject 玩家对象
    **function GuildSetDurabilityMax(uObject:integer;value:integer):boolean;',
      功能：
        设置门派最大血量
      参数:
        uObject 玩家对象
        value 设置门派最大血量的值
    **function GuildSetDurability(uObject:integer;value:integer):boolean;
      功能：
        设置门派当前血量
      参数:
        uObject 玩家对象
        value 设置门派当前血量的值
    **function GuildGetDurabilityMax(uObject:integer):integer;
      功能：
        获取门派最大血量值
      参数:
        uObject 玩家对象
    **function GuildGetDurability(uObject:integer):integer;
      功能：
        获取门派当前血量值
      参数:
        uObject 玩家对象
    **function GuildGetLevel(uObject:integer):integer;
     功能：
        获取门派当前等级
      参数:
        uObject 玩家对象
    **function GuildLevelDec(uObject:integer; anum:integer):boolean;
      功能：
        减少门派等级 减少的等级数根据anum决定
      参数:
        uObject 玩家对象
        anum    减少的等级数
    **function GuildLevelAdd(uObject:integer; anum:integer):boolean;
      功能：
        增加门派等级 增加的等级数根据anum决定
      参数:
          uObject 玩家对象
          anum    增加的等级数
    **function GuildGetEnegy(uObject:integer):integer;
      功能：
           获得门派的元气
      参数:
          uObject 玩家对象
    **function GuildEnegyAdd(uObject:integer; anum:integer):boolean;'
      功能：
          增加门派元气
      参数:
        uObject 玩家对象
        anum 增加的元气值
    **function GuildEnegyDec(uObject:integer; anum:integer):boolean;
      功能：
        减少门派的元气
      参数:
        uObject 玩家对象
    **function GuildIsGuildSubSysop(uObject:integer):boolean;
      功能：
        是否是副门主
      参数:
        uObject 玩家对象
    **function GuildIsGuildSysop(uObject:integer):boolean;
      功能：
        是否是门主
      参数:
        uObject 玩家对象
    **function GuildLifeDataAdditem(uObject:integer; aitemname:string):boolean;
      功能：
        开启门派辅助属性
      参数:
        uObject 玩家对象
        aitemname 物品名字
    **function GuildGetName(uObject:integer):string;
      功能：
            获得门派名字
      参数:
        uObject 玩家对象
      返回:
        门派名称
//武功
    **function DeleteMagicName(uObject:integer; aname:string):boolean;
      功能：
        删除一个非当前使用的武功
      参数:
        uObject 玩家对象
        aname 武功名称
      返回:
        删除是否成功
    **function getuserAttackMagic(uObject:integer):string;
      功能：
          获取当前攻击武功的名字
      参数:
        uObject 玩家对象
      返回:
        返回当前武功的名称
    **function getuserBreathngMagic(uObject:integer):string;
      功能：
         获取当前心法的名字
      参数:
        uObject 玩家对象
      返回:
        返回当前心法武功的名称
    **function getuserRunningMagic(uObject:integer):string;
      功能：
          获取当前步法 名字
      参数:
        uObject 玩家对象
      返回:
        返回当前步法武功的名称
    **function getuserProtectingMagic(uObject:integer):string;
      功能：
          获取当前护体名字
      参数:
        uObject 玩家对象
      返回:
        返回当前护体武功的名称
    **function getMagicspace(uObject: integer; atype: string): integer;
      功能：
          获取武功背包的空位置
      参数:
        uObject 玩家对象
        atype
          atype=''全部武功包;
          Magic武功,
          MagicRise上层;
          MagicMystery掌法;
      返回:
        返回武功背包的空位置
    **function addMagic(uObject:integer; amagicname:string):boolean;
      功能：
          增加武功
      参数:
        uObject 玩家对象
        amagicname 武功名称
      返回:
        返回true 成功
    **function IsMagic(uObject:integer; aname:string):boolean;
      功能：
          测试武功是否存在
      参数:
        uObject 玩家对象
        aname 武功名称
      返回:
        返回:true存在
    **function getMagicLevel(uObject:integer; aname:string):integer;
      功能：
          获取武功等级
      参数:
        uObject 玩家对象
        aname 武功名称
      返回:
        返回武功 等级 最大等级为99.99
    **function getMagictype(uObject:integer; aMagicname:string):integer;
      功能：
         获取武功类型
      参数:
        uObject 玩家对象
        aname 武功名称
      返回:
        返回武功类型，参考Magic.SDB里配制表。
    **function getMagicExp(uObject:integer; aname:string):integer;
      功能：
         获取指定的武功经验
      参数:
        uObject 玩家对象
        aname 武功名称
      返回:
        返回武功经验
    **function AddMagicExp(uObject:integer; aname:string; aexp:integer):integer;
      功能：
         给指定武功增加经验
      参数:
        uObject 玩家对象
        aname 武功名称
        aexp 增加的经验值
      返回:

    **function getMagic_ALlEnergy(uObject:integer):integer;
      功能：
         获取所有武功的元气和
      参数:
        uObject 玩家对象
      返回:
         返回所有武功元气和
//任务-临时变量
    **function SETQuestTempArr(uObject:integer; aindex, aValue:integer):boolean;
      功能：
         设置任务的临时变量
      参数:
        uObject 玩家对象
        aindex  设置的位置
        aValue  设置的值
      返回:
        返回 TRUE 设置成功
// 设置任务临时变量值  aindex 位置  aValue值
    **function getQuestTempArr(uObject:integer; aindex:integer):integer;
      功能：
        获取任务临时变量值
      参数:
        uObject 玩家对象
        aindex  位置
      返回:
        返回任务临时变量值
//分任务-注册系统
    **function getRegSubQuestIdCount(uObject, qid: integer): integer;
      功能：
           获取注册任务 某个任务次数
      参数:
        uObject 玩家对象
        qid  任务ID
      返回:
         某个任务的次数
    **function getRegSubQuestSum(uObject:integer):integer;
      功能：
           获取注册的支线任务 任务共计数量 (在注册系统中的数量)
      参数:
        uObject 玩家对象
      返回:
         返回注册的支线任务数量
    **procedure setRegSubQuest(uObject,qID,atime:integer);
      功能：
        设置注册的支线任务
      参数:
        uObject 玩家对象
        qID   任务ID，
        atime 过期小时 传入的时间是秒
    **function SubQuestRegAdd(uObject, qid: integer): boolean;
      功能：
        增加注册支线任务某个任务次数
      参数:
        uObject 玩家对象
        qID   任务ID，
      返回:
         TRUE 增加成功
    **function getSubQueststep(uObject:integer):integer;
      功能：
         获取分支任务 任务步骤ID
      参数:
        uObject 玩家对象
      返回:
         返回支线任务步骤ID
    **procedure setSubQueststep(uObject,qstep:integer);
      功能：
            设置分支任务 任务步骤ID
      参数:
        uObject 玩家对象
        qstep 设置的步骤
    **function getSubQuestCurrentNo(uObject:integer):integer;
      功能：
            获取分支任务 当前任务ID
      参数:
        uObject 玩家对象
      返回:
        返回当前分支任务的ID
    **procedure setSubQuestCurrentNo(uObject,qid:integer);
      功能：
          设置分支任务ID
      参数:
        uObject 玩家对象
        qid 设置的ID
//主任务
    **function getQuestNo(uObject:integer):integer;
      功能：
          获取已完成的主任务的ID
      参数:
        uObject 玩家对象
      返回:
        返回已完成的任务ID
    **procedure setQuestNo(uObject, qid:integer);
      功能：
         设置主任务已完成的ID
      参数:
        uObject 玩家对象
        qid 设置的ID
      返回:
    **function getQueststep(uObject:integer):integer;
      功能：
         获取当前主线任务的步骤
      参数:
        uObject 玩家对象
      返回:
        返回当前主线任务的步骤
    **procedure setQueststep(uObject, qstep:integer);
      功能：
         设置当前主线任务的步骤
      参数:
        uObject 玩家对象
        qstep 设置步骤
      返回:
    **function getQuestCurrentNo(uObject:integer):integer;
      功能：
         获取当前主线任务的ID号
      参数:
        uObject 玩家对象
      返回:
        返回当前主线任务的ID号
    **procedure setQuestCurrentNo(uObject, qid:integer);
      功能：
         设置当前主线任务的ID号
      参数:
        uObject 玩家对象
        qid 设置的任务的ID

//全局
      procedure BoothAllClose;
          功能：关闭所有人地摊。
      function getServerTempVar(aqid: integer): integer;
          功能：获取临时全局TGS开启0-1000范围 全部为0。
          参数：aqid，任务ID。
      procedure setServerTempVar(aqid: integer; anum: integer);
          功能：设置临时全局TGS开启0-1000范围 全部为0。
          参数：aqid，任务ID。
                anum，数量。
      procedure setQuestdata_Server(aqid: integer; aTEXT: string; anum: integer);
          功能：设置任务全局变量， 会保存到文件。重新开TGS数据还在。
          参数：aqid，任务ID。
                anum，数量。
                aTEXT，文字描述。
      function getQuestdata_Server(aqid: integer; var aTEXT: string;var adate: tdatetime; var anum: integer):boolean;
          功能：获取 任务全局变量。
          参数：aqid，任务ID。
                anum，数量。
                aTEXT，文字描述。
 //任务 公告信息获取
      function getQuestMainTitle(aqid:integer):string;
          功能：获取任务主表，Title字段。
          参数：aqid，任务ID。
      function getQuestMainItem(aqid, akey: integer; var aname: string; var acount: integer): boolean;
          功能：获取任务预设定物品
          参数：aqid，任务ID。
                akey预定位置。
                aname,物品名字，返回值。
                acount，物品数量，返回值。
      function getQuestSubItem(aqid, aqsubid, akey: integer; var aname: string; var acount: integer): boolean;
          功能：获取任务ID，子ID；预物品名字和数量。
          参数：aqid，任务ID。
                aqsubid，任务子ID。
                akey，位置。范围0-9。
                aname，物品名字。返回值。
                acount，物品数量，返回值。
      function getQuestMaintext(aqid:integer):string;
          功能：获取任务主表，text字段。
          参数：aqid，任务ID。
      function getQuestSubTitle(aqid, aqsubid:integer):string;
          功能：获取任务子表，Title字段。
          参数：aqid，任务ID。
                aqsubid，任务子ID。
      function getQuestSubRequest(aqid, aqsubid:integer):string;
          功能：获取任务子表，Request字段。
          参数：aqid，任务ID。
                aqsubid，任务子ID。
      function getQuestSubtext(aqid, aqsubid:integer):string;
          功能：获取任务子表，text字段。
          参数：aqid，任务ID。
                aqsubid，任务子ID。
//队伍任务操作
      function GetProcession(uObject: integer; var u1, u2, u3, u4, u5, u6, u7, u8: integer): boolean;
          功能：获取 队伍成员
          参数：uObject，玩家对象。
                u1-u8 队伍内8个成员，0表示没有。
      function QuestProcessionAdd(uObject: integer; atype: string; aQuestID, aQuestStep, aIndex, aAddCount, aAddMax: integer): boolean;
          功能：队伍任务临时变量。
          参数：uObject，玩家对象。
                atype 类型（1主线任务、2支线任务）
                aQuestID任务ID,
                aQuestStep任务步骤,
                aIndex变量ID,
                aAddCount增加数量
                aAddMax最大不能超过
      procedure MenuSay(uObject:integer; SAYTEXT:string);
          功能：NPC菜单。
          参数：uObject，玩家对象。
                SAYTEXT，预发送字符。包括菜单指令。
      procedure say(uObject:integer; SAYTEXT:string);
          功能：发送白话（普通说话）。
          参数：uObject，玩家对象。
                SAYTEXT，预发送字符。
      procedure saysystem(uObject:integer; SAYTEXT:string);
          功能：发送系统类型提示消息。
          参数：uObject，玩家对象。
                SAYTEXT，预发送字符。
//系统函数
      function IntToStr(Value: Integer): string;
          功能：数字转换成字符。
      function _StrToInt(str:string):Integer;
          功能：字符转换数字。
          参数：str字符。
      function Random(aScope:integer):integer;
          功能：产生1个随机数。
          参数：aScope随机数字范围。
      function now():tdatetime;
          功能：获取系统日期时间。
      procedure dec(var Value: Integer);
          功能：Value减1个返回。
      procedure Inc(var Value: Integer);
          功能：Value增加1个返回。
      procedure DecodeDateMonthWeek(AValue:TDateTime; var AYear, AMonth, AWeekOfMonth, ADayOfWeek:Word);
          功能：分解时间。
          参数：Avalue，TDateTime类型
                AYear年份
                AMonth月份1到12
                AWeekOfMonth在该月份中的第几个星期
                ADayOfWeek星期几。星期一为1。
      procedure DecodeDateTime(Avalue:TDateTime; var AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond:Word);
          功能：分解时间。
          参数：Avalue，TDateTime类型
                AYear年份、
                AMonth月份、
                ADay日子、
                AHour小时、
                AMinute分、
                ASecond秒、
                AMilliSecond毫秒。

//物品 通用 属性
      function getitem(uObject:integer; atype:string; afield:string; akey:integer):string;
          功能：获取背包物品。
          参数：uObject，玩家对象。
                akey:（位置）注意:getitem函数效率比单独查询函数消息低;但比较全面。
                atype:类型（背包，装备，时装）;
                field:（item.sdb里字段）;
                       rName,名字
                       rViewName,显示名字
                       rNameColor,
                       rNeedGrade,(需要等级) 掌和招式=6 灵动=6 风灵=7
                       rKind,状态很多，其中有限制交易
                       rHitType,攻击 类型
                       rId,新ID 编号 不发到客户端
                       rDecSize,新 DecSize(损坏大小) 每次磨损几点耐久
                       rSex,性别要求  (0,1 女,2男)
                       rcolor,颜色
                       rPrice,价格
                       rCount,数量
                       rlockState,新 物品锁状态     0,无锁状态，1,是加锁状态,2,是解锁状态
                       rlocktime,新 解锁状态 时间
                       rDateTimeSec,特殊时间 秒单位 1，rboTimeMode 时间模式 物品最长有效时间；2，KIND 131 附加物品属性有效时间；
                       rGrade,新-品介
                       rWearArr,(装备部位) 9=武器 8=帽子 7=头发 6=衣服 4=裤裙 3=鞋子 2=上衣 1=护腕
                       MaxUpgrade,新 (最大升级别)
                       rDurability,持久
                       rCurDurability,当前持久
                       rSmithingLevel,精练等级   //新 装备等级
                       rlock,false 正常  true锁定（穿戴在身上就不累计属性）
                       rboidentrboident,是否可 鉴定
                       rboDoublerboDouble,重叠
                       rboNotTraderboNotTrade,新开关 NPC交易
                       rboNotExchange,新开关 玩家交换
                       rboNotDrop,新开关 丢弃地上
                       rboNotSSamzie,新开关 存放福袋
                       rboTimeMode,新开关 时间模式
                       boUpgrade,新 (允许升级)
                       rboDurability,新开关 消耗持久
                       rboColoring,(允许染色)
                       rboNOTRepair,新开关 是否可修理
                       rboSetting,是否 随即产生孔
                       rDateTime,时间


      function getitemLifeData(uObject:integer; atype:string; afield:string; akey:integer; var adamageBody, adamageHead, adamageArm, adamageLeg, aarmorBody, aarmorHead, aarmorArm, aarmorLeg, aAttackSpeed, aavoid, arecovery, aaccuracy:integer):boolean;', @getitemLifeData);
        //返回12个属性值atype:类型（背包，装备，时装）; field:（rLifeDataBasic原始,rLifeDataLevel精炼,rLifeDataPro镶嵌,rLifeData合计）; akey:（位置）
      function getitemrSetting(uObject:integer; atype:string; akey:integer; var asettingcount:integer; asetting1, asetting2, asetting3, asetting4:string):boolean;', @getitemrSetting);
        //返回所有镶嵌资料;atype:类型（背包，装备，时装）;  akey:（位置）
      function getitemrUpdateLevel(uObject:integer; atype:string; akey:integer; var aitemname:string; var aKind, aSmithingLevel, aWearArr, aGrade, aMaxUpgrade:integer; var aboUpgrade:boolean):boolean;', @getitemrUpdateLevel);
        //返回所有精炼需要资料; atype:类型（背包，装备，时装）; akey:（位置）

//任务背包
      function DelItemQuest(uObject: integer; aitemname: string; acount: integer): boolean;
          功能：扣除物品一定数量。
          参数：uObject，玩家对象。
                aitemname，物品名字。
                acount，物品数量。
      function DelItemQuestID(uObject: integer; aQuestID: integer): boolean;
          功能：删除某个任务ID的所有物品。
          参数：uObject，玩家对象。
                aQuestID，任务ID。
      function AddItemQuest(uObject: integer; aitemname: string; acount: integer): boolean;
          功能：增加物品。
          参数：uObject，玩家对象。
                aitemname，物品名字。
                acount，物品数量。
      function GetItemQuestCount(uObject: integer; aitemname: string): integer;
          功能：任务背包 某物品数量。
          参数：uObject，玩家对象。
                aitemname，物品真实名字。
      function GetItemSpaceCount(uObject: integer): integer;
          功能：任务背包 空位置数量
          参数：uObject，玩家对象。
//背包 物品
      function getHaveItemLockedPass(uObject:integer):boolean;
          功能：测试背包是否有密码锁。
          参数：uObject，玩家对象。
      function getitemSpecialKind(uObject: integer; akey: integer): integer;
          功能：背包 物品，SpecialKind（特殊KIND）字段。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function getitemMixName(uObject: integer; akey: integer): string;
          功能：获取背包 物品，合成目标名字。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function getitemSpecialLevel(uObject: integer; akey: integer): integer;
          功能：获取背包 某位置 物品 rSpecialLevel（特殊等级）字段。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function getitemDurability(uObject: integer; akey: integer): integer;
          功能：获取背包 某位置 物品 Durability
          参数：uObject，玩家对象。
                akey,物品 位置。
      function setitemDurability(uObject: integer; akey, aDurability: integer): boolean;
          功能：设置背包某位置 物品Durability（当前持久）字段。
          参数：uObject，玩家对象。
                akey,物品 位置。
                aDurability，持久。范围在最大持久允许范围以内。
      function getitemGrade(uObject: integer; akey: integer): integer;
          功能：获取背包 某位置 物品 Grade（品级）字段。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function getitemStarLevel(uObject: integer; akey: integer): integer;
          功能：获取背包 某位置 物品 StarLevel（星级）字段。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function setitemStarLevel(uObject: integer; akey, alevel: integer): boolean;
          功能：设置背包 某位置 物品 StarLevel（星级）字段。
          参数：uObject，玩家对象。
                akey,物品 位置。
                alevel，等级。范围最大星级允许范围。
      function setitemBlueprint(uObject: integer; akey: integer; astate: boolean): boolean;
          功能：设置背包 某位置 物品 Blueprint图纸字段。
          参数：uObject，玩家对象。
                akey,物品 位置。
                astate，状态。TRUE是图纸。
      function getitemBlueprint(uObject: integer; akey: integer): boolean;
          功能：获取背包 某位置 物品 图纸字段值。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function SetItemUPdataLevelNew(uObject: integer; akey: integer; alevel: integer): boolean;
          功能：精炼装备。
          参数：uObject，玩家对象。
                akey,物品 位置。
                alevel，等级。（可降级）
      function getitemname(uObject:integer; akey:integer):string;
          功能：获取背包 某位置 物品 真实名字。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function getitemKind(uObject:integer; akey:integer):integer;
          功能：获取背包 某位置 物品 类型。
          参数：uObject，玩家对象。
                akey,物品 位置。
          返回：类型ID。
              ITEM_KIND_COLORDRUG = 1;
              ITEM_KIND_BOOK = 2;
              ITEM_KIND_GOLD = 3;                                                         //钱币
              ITEM_KIND_WEARITEM = 6;                                                     //是常用装备 可以升级的4段装备的
              ITEM_KIND_ARROW = 7;                                                        //箭
              ITEM_KIND_FLYSWORD = 8;                                                     //飞刀
              ITEM_KIND_GUILDSTONE = 9;
              ITEM_KIND_DUMMY = 10;                                                       //门派 FM_ADDITEM 消息 在使用
              ITEM_KIND_STATICITEM = 11;                                                  //静态物品
              ITEM_KIND_DRUG = 13;
              ITEM_KIND_TICKET = 18;
              ITEM_KIND_HIDESKILL = 19;
              ITEM_KIND_CANTMOVE = 20;
              ITEM_KIND_ITEMLOG = 21;
              ITEM_KIND_CHANGER = 22;
              ITEM_KIND_SHOWSKILL = 23;
              ITEM_KIND_WEARITEM2 = 24;                                                   //是装备    可以升级3段 不能升级4段的
              ITEM_KIND_WEARITEM_27 = 27;                                                 //挖矿工具
              ITEM_KIND_WEARITEM_29 = 29;                                                 //是装备  我没搞懂为什么用29  因为 6和29没区别
              ITEM_KIND_35 = 35;                                                          //水桶
              ITEM_KIND_Scripter = 56;                                                    //脚本物品
              ITEM_KIND_36 = 36;                                                          //加活力的戒指（提高角色的部分能力值）
              ITEM_KIND_59 = 59;                                                          //提高角色的部分能力值
              ITEM_KIND_41 = 41;                                                          //定时间 恢复血等属性
              ITEM_KIND_44 = 44;                                                          //[任务 物品] 拿20个疾风灵符给雨中客
              ITEM_KIND_45 = 45;                                                          //[任务 物品] 拿20个黑马武士给老侠客
              ITEM_KIND_51 = 51;                                                          //开宝箱时要用
              ITEM_KIND_WEARITEM_GUILD = 60;                                              //砸门锤 是装备武器  是有持久限制的武器
              ITEM_KIND_ScripterSay = 61;                                                 //脚本物品
              ITEM_KIND_WEARITEM_FD = 100;                                                //时装
              ITEM_KIND_GuildAddLife = 120;                                               //门派加血石头
              ITEM_KIND_121 = 121;//宝石 镶嵌  rSpecialKind 表示等级
              ITEM_KIND_130 = 130;//精炼 石头
              ITEM_KIND_LifeData_item = 131;                                              //可以吃的附加属性 物品  rSpecialKind 重叠标志
              ITEM_KIND_132 = 132;//精炼 辅助石 rSpecialKind 类型
              ITEM_KIND_QUEST = 133;                                                      //任务 物品20091019
              ITEM_KIND_GOLD_D = 134;
      function setitemAttach(uObject: integer; akey, aAttach: integer): boolean;
          功能：设置 背包 某位置 物品 Attach
          参数：uObject，玩家对象。
                akey,物品 位置。
                Attach，附加属性ID。
      function getitemAttach(uObject: integer; akey: integer): integer;
          功能：获取背包 某位置 物品 附加属性ID。
          参数：uObject，玩家对象。
                akey,物品 位置。
          返回：小于等于0表示无。
      function getitemWearArr(uObject:integer; akey:integer):integer;
          功能：获取背包 某位置 物品的佩带部位。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function getitemHitType(uObject: integer; akey: integer): integer;
          功能：获取物品攻击类型。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function getitemPrice(uObject:integer; akey:integer):integer;
          功能：获取背包 某位置 物品 价格。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function getitemboUpgrade(uObject:integer; akey:integer):boolean;
          功能：获取背包 某位置 物品 是否用许升级。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function getitemSmithingLevel(uObject:integer; akey:integer):integer;
          功能：获取背包 某位置 物品 精炼等级
          参数：uObject，玩家对象。
                akey,物品 位置。
      function getitemSmithingLevelMax(uObject:integer; akey:integer):integer;
          功能：获取背包 某位置 物品 精炼等级最高等级。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function getitemcount(uObject:integer; aitemname:string):integer;
          功能：获取背包指定物品数量
          参数：uObject，玩家对象。
                aitemname，物品真实名字。
          返回：-1  失败   >=0数量。
      function getitemKeyCount(uObject: integer; akey: integer): integer;
          功能：获取物品某位置数量。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function getitemboident(uObject:integer; akey:integer):boolean;
          功能：获取背包 某位置 物品 是否可鉴定。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function setitemboident(uObject:integer; akey:integer;astate:boolean):boolean;
          功能：设置 背包 某位置 物品 是否可鉴定。
          参数：uObject，玩家对象。
                akey,物品 位置。
                astate，TRUE，可坚定，FALSE，不可坚定。
      function getitemSettingCount(uObject:integer; akey:integer):integer;
          功能：获取背包 某位置 物品 孔数量。
      function getitemSettingSpaceCount(uObject:integer; akey:integer):integer;
          功能：获取背包某位置物品的未镶嵌宝石数量，空闲孔数量。
          参数：uObject，玩家对象。
                akey,物品 位置。
      function getItemMaterialArr(uObject: integer; akey: integer; out aname1, aname2, aname3, aname4: string; out acount1, acount2, acount3, acount4: integer): boolean;
          功能：获取本物品合成，需要的材料。
          参数：uObject，玩家对象。
                akey,物品 位置。
                aname1, aname2, aname3, aname4;4件材料名字。名字空表示无。
                acount1, acount2, acount3, acount4；4件材料名字。
      function ItemUPdataSetting(uObject:integer; akey, aaddKey:integer):boolean;
          功能：装备镶嵌宝石。
          参数：uObject，玩家对象。
                akey 物品 位置。
                aaddKey宝石位置，成功自动扣宝石数量。
      function ItemUPdataSetting_del(uObject:integer; akey:integer):boolean;
          功能：清除物品的镶嵌宝石。
          参数：uObject，玩家对象。
                akey,玩家背包位置。
      function ItemUPdataLevel(uObject:integer; akey:integer;alevel, damageBody, damageHead, damageArm, damageLeg, armorBody, armorHead, armorArm, armorLeg, AttackSpeed, avoid, recovery, accuracy:integer):boolean;
          废弃函数。
      function HaveItemaffairStart(uObject:integer):boolean;
          功能：背包事务  开始。
      function HaveItemaffairRoll_back(uObject:integer):boolean;
          功能：背包事务  回滚到上次执行 HaveItemaffairStart前状态。
      function HaveItemaffairConfirm(uObject:integer):boolean;
          功能：事件回滚保护，确认。
      function addItemEx(uObject: integer; aitemname, acreatename: string; aStarLevel, aSmithingLevel, aSettingCount, aAttach, aDurability, acolor: integer): boolean;
          功能：增加物品。
          参数：uObject，玩家对象。
                SettingCount，孔数量。
                StarLevel，星级。
                SmithingLevel，精炼等级。
                Attach，附加属性。
                createname，制造者名字。
                color，染色颜色。
                rDurability，持久  <0不改变，其他的<=0不改变。
      function setItemSettingCount(uObject: integer; akey: integer; acount: integer): boolean;
          功能：增加背包物品空数量
          参数：uObject，玩家对象。
                aitemname，物品名字。
                acount，孔数量。
          返回：true，成功。
      function additem(uObject:integer; aitemname:string; acount:integer):boolean;
          功能：增加背包物品数量
          参数：uObject，玩家对象。
                aitemname物品名字
                acount 数量
          返回：true成功
      function deleteitem(uObject:integer; aitemname:string; acount:integer):boolean;
          功能：删除背包物品数量
          参数：uObject，玩家对象。
                aitemname，物品名字。
                acount，数量 (<=0 表示有全部删除)。
          返回：true，成功。
      function deleteItemKey(uObject:integer; akey, acount:integer):boolean;
          功能：删除背包物品数量
          参数：uObject，玩家对象。
                akey位置
                acount 数量
          返回：true成功
      function FindItemName(uObject:integer; aitemname:string):integer;
          功能：背包中查找 某物品 位置
          参数：uObject，玩家对象。
                aitemname，物品真实名字。
          返回： 0-29  -1 失败。
      function getitemspace(uObject:integer):integer;
          功能：获取背包 空位数量。
          参数：uObject，玩家对象。
          返回：数值。
//技能职业
      function getJobKind(uObject: integer): integer;
          功能：获取职业类型。
          参数：uObject，玩家对象。
      function setJobKind(uObject: integer; aKind: integer): boolean;
          功能：修改职业。
          参数：uObject，玩家对象。
                aKind，职业类型（1，2，3，4），修改后等级是1级。
      function addJobLevelExp(uObject: integer; aExp,aMaxExp: integer): boolean;
          功能：增加职业技能等级经验。
          参数：uObject，玩家对象。
                aExp，经验。
                aMaxExp，最大经验。
      function getJobLevel(uObject: integer): integer;
          功能：获取职业技能等级。
          参数：uObject，玩家对象。
          返回：数值。
      function SetJobLevel(uObject: integer; alevel: integer): boolean;
          功能：设置职业技能等级。
          参数：uObject，玩家对象。
                alevel，等级。
      function getJobGradeName(uObject: integer): string;
          功能：获取职业品名。
          参数：uObject，玩家对象。
      function getJobGrade(uObject: integer): integer;
          功能：获取职业品级。
          参数：uObject，玩家对象。
//浩然
      function addVirtueExp(uObject: integer; aexp, aMaxLevel: integer): boolean;
          功能：增加浩然 经验，（不是等级）
          参数：uObject，玩家对象。
                aexp，经验。
                aMaxLevel，本次增加不能超过的浩然等级。
      function GetVirtueLevel(uObject: integer): integer;
          功能：获取浩然 等级。
          参数：uObject，玩家对象。
//身上
      function WearGETRepairGoldSum(uObject: integer): integer;
          功能：获取身上维修需要共计钱。
          参数：uObject，玩家对象。
      function WearRepairAll(uObject: integer): boolean;
          功能：维修身上所有装备。不会检查钱和扣钱。
          参数：uObject，玩家对象。
//属性
      function getMapID(uObject: integer): integer;
          功能：获取角色地图ID。
          参数：uObject，玩家对象。
          返回：数值。
      function getMaxLife(uObject: integer): integer;
          功能：获取角色最大活力值。
          参数：uObject，玩家对象。
          返回：数值。
      function getCurLife(uObject: integer): integer;
          功能：获取角色获取当前活力值。
          参数：uObject，玩家对象。
          返回：数值。
      function getsex(uObject:integer):integer;
          功能：获取性别。
          参数：uObject，玩家对象。
          返回：-1  失败   1  男  2 女。
      function getage(uObject:integer):integer;
          功能：获取年龄。
          参数：uObject，玩家对象。
          返回：数值。
      function getname(uObject:integer):string;
          功能：获取角色名字。
          参数：uObject，玩家对象。
          返回：字符。
      function getprestige(uObject:integer):integer;
          功能：获取声望。
          参数：uObject，玩家对象。
          返回：数值。
//翻倍经验
      procedure MagicExpMulAdd(uObject: integer; aMulCount, aHour: integer);
          功能：增加1天的翻倍经验。
          参数：uObject，玩家对象。
                aMulCount，翻倍比例。
                aHour，持续时间，小时。
      function MagicExpMulGetDay(uObject: integer): integer;
          功能：获取善于未领取翻倍经验的天数。
          参数：uObject，玩家对象。
          返回：数值。
      function MagicExpMulGetCurMulMinutes(uObject: integer): integer;
          功能：获取，当前翻倍时间，剩余分钟。
          参数：uObject，玩家对象。
          返回：数值。
//元气
      function getEnergy(uObject:integer):integer;
          功能：获取真实元气值。
          参数：uObject，玩家对象。
          返回：数值。
      function getEnergyLevel(uObject: integer): integer;
          功能：真实值的境界等级。
          参数：uObject，玩家对象。
          返回：数值。
      function getEnergyCalc(uObject: integer): integer;
          功能：获取元气 计算值（玩家看到的值）。
          参数：uObject，玩家对象。
          返回：数值。
      procedure SetEnergy(uObject, qid: integer);
          功能：设置元气。
          参数：uObject，玩家对象。
                qid，元气值。
      procedure setprestige(uObject, qid:integer);
          功能：设置声望。
          参数：uObject，玩家对象。
                qid，声望值。
      function SETTempArr(uObject:integer; aindex, aValue:integer):boolean;
          功能：设置临时变量值
          参数：uObject，玩家对象。
                aindex，位置。
                aValue，值。
      function getTempArr(uObject:integer; aindex:integer):integer;
          功能：获取临时变量值。
          参数：uObject，玩家对象。
                aindex，序号，0-99区间。
          返回：内容数值。
      function DesignationSpaceCount(uObject: integer): integer;
          功能：获取称号列表空位置数量。目前最大10个位置。
          参数：uObject，玩家对象。
          返回：空位置数量。
      function DesignationCheck(uObject: integer; aid: integer): boolean;
          功能：测试称号是否存在。
          参数：uObject，玩家对象。
                aid，称号ID。
          返回：TRUE，成功。FALSE，失败。
      function DesignationAdd(uObject: integer; aid: integer): boolean;
          功能：增加 称号。
          参数：uObject，玩家对象。
                aid，称号ID。
//身上 穿戴
      function deletewearitem(uObject:integer; akey:integer):boolean;
          功能：删除身上某位置装备。
          参数：uObject，玩家对象。
                akey，玩家身上位置。
      function getwearitemviewnamename(uObject:integer; akey:integer):string;
          功能：获取身上装备（显示）名字
          参数：uObject，玩家对象。
                akey，玩家身上位置。
          返回：空  失败  非空名字。
      function getwearitemname(uObject:integer; akey:integer):string;
          功能：获取身上装备（真实）名字
          参数：uObject，玩家对象。
                akey，玩家身上位置。
          返回：空  失败  非空名字。
//礼堂函数。
      结婚流程
        1，申请结婚。对方应答后结婚成功。
        2，申请使用礼堂，举行婚礼。（结婚仪式可不举行）
        3，领取礼物。（可免费、收费、不要礼物）
        4，设置主婚人。（新郎、新娘可设置和更换主婚人）
        5，主婚人更换步骤。（策划安排步骤）
        6，步骤更换完婚礼结束。

      procedure marriagebulletin(astr:string);
          功能：发布婚礼公告。
          参数：astr 消息内容
      function getauditoria():boolean;
          功能：获取礼堂状态；TRUE占用。
      function setmarriageend():boolean;
          功能：设置婚礼完成；空出教堂。
      function setmarrystep(astep:integer):boolean;
          功能：设置当前婚礼，第几步骤。
      function getofficiator():string;
          功能：获取当前婚礼，主婚人。
      function getmarrystep():integer;
          功能：获取当前婚礼，举行到第几步骤。 返回：-1 失败。
      function getpartymanname():string;
          功能：获取当前婚礼，新郎名字。
      function getpartywomanname():string;
          功能：获取当前婚礼，新娘名字。

      function getmarryinfo(uObject:integer):boolean;
          功能：获取结婚状态。
          返回：true是
          参数：uObject，玩家对象。
      function getparty(uObject:integer):boolean;
          功能：测试是否是当事人（新娘、新娘）状态。
          返回：true是
          参数：uObject，玩家对象。
      function getmarryclothes(uObject:integer):boolean;
          功能：获取过结婚礼物。
          返回：true是
          参数：uObject，玩家对象。
      function getmarriage(uObject:integer):boolean;
          功能：获取婚礼（礼堂结婚仪式）状态。
          返回：true是
          参数：uObject，玩家对象。
      function Marry(uObject:integer; atext:string):boolean;
          功能：结婚发启指令。发启后需要对方同意。
          参数：atext， 附带消息，邀请对方名字。
                uObject，本人，玩家对象。
          返回：TRUE指令成功发出。
      function unmarry(uObject:integer):boolean;
          功能：离婚发启指令。发启后需要对方同意。
          参数：atext， 附带消息，邀请对方名字。
                uObject，本人，玩家对象。
          返回：TRUE指令成功发出。
      function setmarryclothes(uObject:integer):boolean;
          功能：标记已经拿过礼服。
          参数：uObject，目标对象，玩家。
      function setauditoria(uObject:integer):boolean;
          功能：设置礼堂进行结婚仪式，设置成功后会被记录，可查询。
          参数：uObject，目标对象，玩家。
      function showmarriage(uObject:integer; astr:string; atype:integer):boolean;
          功能：弹出 输入婚礼问答筐。
          参数：uObject，目标对象，玩家。
                astr，内容。
                atype，类型。
                    1要求男的回答
                    2要求女的回答（内容记录在结婚系统） 应答是或者不是后，
                    系统公告 内容和答案
      function showsetofficiator(uObject:integer; aname:string):boolean;
          功能：设置当前婚礼，主婚人。
          参数：uSource，新人，新郎、新娘。
          说明：弹出输入筐设置，成功后系统公告。
//反击
      function NewCounterAttack_hit(uObject:integer; astate:boolean;atime:integer):boolean;
          功能:设置反击状态.
          参数：astate， ture 开启反击 false 关闭反击。
                atime，持续时间，小时。
                uObject，设置对象，玩家。
//元神
      function MonsterCheck(uObject: integer): boolean;
          功能:测试玩家是否开启元神.
          参数：uObject，玩家对象。
      function MonsterCreate(uObject: integer; aMonsterName: string): boolean;
          功能：玩家创建新元神。
          参数：uObject，玩家对象。
                aMonsterName，怪物名字，必须在Monster.sdb里有的.
      function MonsterFree(uObject: integer): boolean;
          功能：释放玩家的元神。
          参数：uObject，玩家对象。
      function MapMove(uObject: integer; amapid: integer; ax, ay, aDelayTick: integer): boolean;
          功能：移动指定目标到指定位置。
          参数：amapid，地图序号。
                AX，AY，坐标。
                aDelayTick，延迟移动。
          返回：true命令下达成功（不表示传送成功）

//公共函数。
      procedure centermsg(atext:string; acolor:integer);
          功能：中间 消息筐。
          参数：acolor，字颜色  WIN颜色值。
              atext，发送文字。
      procedure topmsg(atext:string; acolor:integer);
          功能：TOP  消息筐。
          参数：acolor 字颜色  WIN颜色值。
            atext，发送文字。
      procedure worldnoticemsg(atext:string; afcolor, abcolor:integer);
          功能：普通世界消息
          参数：afcolor，字颜色WIN颜色值
                abcolor，背景颜色win颜色值
                atext，发送文字。
      function _pos(asubstr: string; astr: string): integer;
          功能：原字符中查找子字符位置。
          参数：asubstr，子字符。
                astr，原字符。
      function _LastChar(astr: string): string;
          功能：返回最后1个字符。
      function DateTimeToStr(DateTime: TDateTime): string;
          功能：日期时间转换成文件日期。
          参数：DateTime，时间类型。
      function getUserListCount(): integer;
          功能：获取 在线人数

***脚本事件
    1，procedure OnDie(uSource, uDest:integer;aRACE:integer);
    适应：NPC，怪物。
    功能：死亡后触发。
    参数：uSource，玩家对象。
          uDest，怪物对象。
          aRACE，类型；
              RACE_NONE = 0;无
              RACE_HUMAN = 1;人
              RACE_ITEM = 2;物体
              RACE_MONSTER = 3;怪物
              RACE_NPC = 4;NPC
              RACE_DYNAMICOBJECT = 5;动态 对象
              RACE_STATICITEM = 6;静态物体

    2，procedure OnRegen(uSource:integer);
    适应：NPC、怪物。
    功能：复活触发。
    参数：uSource，怪物对象。
    3，procedure OnDragItem(uUser,uDest,aUserHaveItemKey: integer);
    适应：怪物。
    功能：物品拖到怪物身上触发
    参数：
          uUser，玩家对象
          uDest，怪物对象
          aUserHaveItemKey，触发物品所在玩家背包位置。
    4，procedure OnMenu(uSource, uDest:integer);
    适应：NPC、怪物。
    功能：鼠标点对象后触发菜单。
    参数：uSource，来源对象；玩家。
          uDest，目标对象；怪物或者NPC。
    5，procedure OnItemDblClick(uSource, uItemKey:integer;astr:string);
    适应：背包物品。
    功能：鼠标双点角色背包物品触发。
    参数：uSource，来源对象；玩家。
          uItemKey，玩家背包位置。
          astr，玩家点开物品后输入的文字。
    6，procedure OnGate(uUserOb, uGateOb:integer);
    适应：GATE跳点。
    功能：角色移动到跳点范围内触发。
    参数：uUserOb， 玩家对象。
          uGateOb，GATE对象。
    7，procedure OnGuildImpartMagic(uSource, uUser,uDest:integer);
    适应：门派石。
    功能：传授武功时触发。
    参数：uSource，来源对象，门派门主对象。
          uUser，接受门派武功对象；门派门徒。
          uDest，门派石，静态门派物体。
    8，procedure OnCharOnline(uSource: integer);
    适应：角色。事件在GameSys.pas脚本里。
    功能：玩家上线触发。
    参数：uSource，玩家对象
    9，procedure OnCharExitGame(uSource: integer);
    适应：角色。事件在GameSys.pas脚本里。
    功能：玩家下线触发。
    参数：uSource，玩家对象
    10，procedure OnAuctionSell(uSource: integer; aItemName: string);
    适应：角色。事件在GameSys.pas脚本里。
    功能：寄售后触发。
    参数：uSource，玩家对象
          aItemName，出售物品名字。
    11，procedure OnUpdate(uManager,curTcik:integer);
    适应：地图。
    功能：地图被动刷新触发。1分钟刷新一次，MAP.SDB,BOUPDATETIME字段打开生效.
    参数：uManager，地图对象。
          curTcik，当前内部时间。1=10毫秒。
    12，procedure OnInitial(uManager,curTcik:integer); //初始化
    适应：地图。
    功能：地图初始化触发。
    参数：uManager，地图对象。
          curTcik，当前内部时间。1=10毫秒。
    13，procedure OnRegen(uManager,curTcik:integer);
    适应：地图。
    功能：地图首次复活触发。
    参数：uManager，地图对象。
          curTcik，当前内部时间。1=10毫秒。
    14，procedure OnRegenFront(uManager:integer;RemainHour, RemainMin, RemainSec:integer);
    适应：地图。
    功能：定时间隔复活地图触发。
    参数：uManager，地图对象。
          curTcik，当前内部时间。1=10毫秒。
    15，procedure OnTurnOn(uSource, uDest:integer);
    适应：动态物体。
    功能：物体打开后触发。
    参数：uSource，来源对象；玩家。
          uDest，目标对象；动态物体对象。
    16，procedure OnCallObject(uHit, uSelf:integer);
    适应：动态物体。
    功能：物体召唤时触发。
    参数：uHit攻击者对象；玩家。
          uSelf，本体；动态物体对象。
    17，procedure OnTurnOff(uSource:integer);
    适应：动态物体。
    功能：物体关闭后触发。
    参数：uSource，来源对象；玩家。
    18,procedure OnWearItemOn(uUSER:integer;uWearKey:integer);
    适应：角色。
    功能：穿戴装备触发。
          条件rSpecialKind = WEAR_SPECIAL_KIND_Scripter;
          WEAR_SPECIAL_KIND_Scripter = 8; //脚本    
    参数：uUSER，玩家对象。
          uWearKey,身上所在位置.
    19,procedure OnWearItemOff(uUSER:integer;uWearKey:integer);
    适应：角色。
    功能：卸载装备触发。
          条件rSpecialKind = WEAR_SPECIAL_KIND_Scripter;
          WEAR_SPECIAL_KIND_Scripter = 8; //脚本
    参数：uUSER，玩家对象。
          uWearKey,身上所在位置.   
    }
end.

