unit uSkills;

interface

uses
  Windows, Classes, SysUtils, BasicObj, DefType, uAnsTick, PaxScripter;

const
  DIVRESULT_NONE = 0;
  DIVRESULT_WHATSELL = 1;
  DIVRESULT_WHATBUY = 2;
  DIVRESULT_WHATBUY_WIN = 6;
  DIVRESULT_WHATSELL_WIN = 7;
  DIVRESULT_SELLITEM = 3;
  DIVRESULT_BUYITEM = 4;
  DIVRESULT_HOWMUCH = 5;

type

  TSpeechData = record
    rSayString: string;
    rSpeechTick: integer;
    rDelayTime: integer;
  end;
  PTSpeechData = ^TSpeechData;

  TDeallerData = record
    rHearString: string;
    rSayString: string;
    rNeedItem: array[0..5 - 1] of TCheckItem;
    rGiveItem: array[0..5 - 1] of TCheckItem;
  end;
  PTDeallerData = ^TDeallerData;

  TGroupSkill = class;

  TLifeObject = class(TBasicObject) // 蜡历绰 力寇....
  private
    OldPos: TPoint;

  protected
    CreatedX, CreatedY, ActionWidth: word; //创建 坐标 和活动范围

    DontAttacked: Boolean; // 厚公厘...
    SoundNormal: TEffectData;
    SoundAttack: TEffectData;
    SoundDie: TEffectData;
    SoundStructed: TEffectData;

    FreezeTick: integer;
    DiedTick: integer; //死亡时间
    HitedTick: integer;
    WalkTick: integer;

    HitFunction: integer; //20091020 增加，修复 必杀技
    HitFunctionSkill: integer;
    WalkSpeed: integer;

    LifeData: TLifeData;
    LifeObjectState: TLifeObjectState;
    CurLife, MaxLife: integer; //当前 血 和最大血

    FBoCopy: Boolean;
    //自己分身 列表
   // CopiedList: TList;                                                      //本类不创建 不销毁
    //自己是分身状态下的BOSS
  //  CopyBoss: pointer;                                                      //本类不创建 不销毁

    Close_Tick: integer; //关闭 时间 （死亡时间）   2009 3 24 增加

    procedure InitialEx;
    procedure Initial(aMonsterName, aViewName: string);
    procedure StartProcess; override;
    procedure EndProcess; override;
    function AllowCommand(CurTick: integer): Boolean;
    function CommandHited(var SenderInfo: TBasicData; aHitData: THitData;
      apercent: integer): integer;
    procedure CommandChangeCharState(aFeatureState: TFeatureState);

    procedure CommandHitHUMAN(CurTick: integer; aMagicDatap: PTMagicData);
    procedure CommandHit(CurTick: integer);
    function ShootMagic(var aMagic: TMagicData; Bo: TBasicObject): Boolean;

    procedure CommandTurn(adir: word);
    procedure CommandSay(astr: string);

    function GotoXyStand(ax, ay: word): integer;
    function GotoXyStandAI(ax, ay: word): Integer;
    function GotoXyStand_SET(ax, ay: word): integer;
    function FieldProc(hfu: Longint; Msg: word; var SenderInfo: TBasicData; var
      aSubData: TSubData): Integer; override;

    //  procedure ShowEffect(aEffectNumber:Word; aEffectKind:TLightEffectKind);
  public
    RegenInterval: integer; //死亡后 复活时间
    boDieDelete: boolean;
    constructor Create;
    destructor Destroy; override;

    function GetLifeObjectState: TLifeObjectState;
    //        procedure CopyDie(aBasicObject: TBasicObject);
    //        procedure CopyBossDie;
    function AddLife(aLife: integer): boolean; //20091015增加血

    procedure SetHideState(aHideState: THiddenState);

    function getMaxLife(): integer;
    function getCurLife(): integer;
  end;

  TBuySellSkill = class
  private
    BasicObject: TBasicObject;

    BuyItemList: TList;

    SellItemList: TList;

    FileName: string;

    procedure Clear;

    function DivHearing(aHearStr: string; var Sayer, aItemName: string; var
      aItemCount: integer): integer;
    function getSellIndex(aindex: integer): PTItemData;
    function getBuyName(aname: string): PTItemData;

  public
    boLogItem: Boolean;
    boEmailstate: boolean;
    boAuctionstate: boolean;
    boBuyItemAllState: boolean; //接受所有物品
    boUPdateItem_UPLevel: boolean;
    boUPdateItem_Setting: boolean;
    boUPdateItem_Setting_del: boolean;

    BUYTITLE: string;
    BUYCAPTION: string;
    // BUYIMAGE:integer;

    SELLTITLE: string;
    SELLCAPTION: string;
    //  SELLIMAGE:integer;

    UPItemLevelTITLE: string;
    UPItemLevelCAPTION: string;

    UPItemSettingTITLE: string;
    UPItemSettingCAPTION: string;

    UPItemSettingDelTITLE: string;
    UPItemSettingDelCAPTION: string;

    constructor Create(aBasicObject: TBasicObject);
    destructor Destroy; override;

    function LoadFromFile(aFileName: string): Boolean;
    function ProcessMessage(aStr: string; SenderInfo: TBasicData): Boolean;
    function ProcessMessageNEW(PCnpc: PTCnpc; SenderInfo: TBasicData): Boolean;
    property CanLogItem: Boolean read boLogItem;
    property CanEmailstate: Boolean read boEmailstate;
    property CanAuctionstate: Boolean read boAuctionstate;
    property CanBuyItemAllState: Boolean read boBuyItemAllState;
  end;

  TSpeechSkill = class
  private
    BasicObject: TBasicObject;

    SpeechList: TList;
    CurSpeechIndex: Integer;
    SpeechTick: Integer;

    procedure Clear;
  public
    constructor Create(aBasicObject: TBasicObject);
    destructor Destroy; override;

    function LoadFromFile(aFileName: string): Boolean;
    procedure ProcessMessage(CurTick: Integer);
  end;

  TDeallerSkill = class
  private
    BasicObject: TBasicObject;

    DataList: TList;

    procedure Clear;
  public
    constructor Create(aBasicObject: TBasicObject);
    destructor Destroy; override;

    function LoadFromFile(aFileName: string): Boolean;
    function ProcessMessage(aStr: string; SenderInfo: TBasicData): Boolean;
  end;

  TAttackSkill = class
  private
    BasicObject: TBasicObject; //自己对象
    GroupBoss: TBasicObject; //自己的主人 BOSS对象

    ObjectBoss: TDynamicObject;

    DeadAttackName: string; //死追杀 人名字。

    SaveID: Integer;
    //预存目标ID。（目前用途：1吃物品；2，5号武功杀死人后拿走人的物品）
    TargetID: Integer; //攻击ID
    EscapeID: Integer; //逃跑ID

    SaveNextState: TLifeObjectState; //预存状态

    TargetPosTick: Integer;

    AttackMagic: TMagicData;

    boGroupSkill: Boolean;
    GroupSkill: TGroupSkill; //主人 的管理类 组成员列表

    BowCount: Integer; //远程攻击数量
    BowAvailTick: Integer;
    BowAvailInterval: Integer; //远程间隔时间
    boBowAvail: Boolean;

    TargetStartTick: Integer; //目标开始时间
    TargetArrivalTick: Integer; //目标到达时间
  public
    TargetX: Integer; //目标 坐标
    TargetY: Integer;

    HateObjectID: Integer; //仇恨大ID
    CurNearViewObjId: Integer; //当前最近人ID
    EscapeLife: Integer; //逃跑 最小活力

    ViewWidth: integer; //视觉范围

    boGroup: Boolean; //编组
    boBoss: Boolean; //设置BOSS
    boVassal: Boolean; //联手攻击 是否接受 FM_GATHERVASSAL 指令
    boAutoAttack: Boolean; //主动攻击
    boAttack: Boolean; //攻击
    boChangeTarget: Boolean; //换攻击目标
    boViewHuman: Boolean; //看见玩家
    VassalCount: integer; //练手数量
    boSelfTarget: Boolean; //自己是否有目标
  public
    constructor Create(aBasicObject: TBasicObject);
    destructor Destroy; override;

    procedure SetObjectBoss(aBoss: TDynamicObject);
    function GetObjectBoss: TDynamicObject;
    procedure SetDeadAttackName(aName: string);

    procedure SetTargetID(aTargetID: Integer; boCaller: Boolean);
    //设置攻击目标（1，本组一起攻击。2，通知BOSS攻击目标。3，通知周围怪物联手攻击）
    procedure SetHelpTargetIDandPos(aTargetID, aX, aY: Integer);
    //进入移动攻击状态
    procedure SetEscapeID(aEscapeID: Integer);
    //说明：以目标ID为 反方向计算出移动目标；进入逃跑状态。
    procedure SetAttackMagic(aAttackMagic: TMagicData); //设置 攻击武功

    //创建组
    procedure GroupCreate; //创建  组
    procedure GroupAdd(aBasicObject: TBasicObject);
    //增加  成员  （文件创建怪物一个地方使用）
    procedure GroupDel(aBasicObject: TBasicObject); //删除  成员
    procedure GroupSetBoss(aBoss: TBasicObject); //BOSS对象
    procedure GroupSelfDie; //自己死亡；但目前只有，自己销毁才调用

    procedure ProcessNone(CurTick: Integer);
    procedure ProcessEscape(CurTick: Integer);
    function ProcessAttack(CurTick: Integer; aBasicObject: TBasicObject):
      Boolean;
    procedure ProcessMoveAttack(CurTick: Integer);
    procedure ProcessDeadAttack(CurTick: Integer);
    procedure ProcessMoveWork(CurTick: Integer);
    function ProcessMove(CurTick: Integer): Boolean;

    procedure HelpMe(aMeID, aTargetID, aX, aY: Integer); //本组 群体攻击
    procedure CancelHelp(aTargetID: Integer); //本组 取消攻击

    //属性
    property GetTargetID: Integer read TargetID;
    property GetSaveID: Integer read SaveID;
    property GetNextState: TLifeObjectState read SaveNextState;
    property GetDeadAttackName: string read DeadAttackName;
    property ArrivalTick: Integer read TargetArrivalTick;
    //没被使用部分
    procedure SetHelpTargetID(aTargetID: Integer); //目前发现没使用
    procedure SetSaveIDandPos(aTargetID: Integer; aTargetX, aTargetY: Word;
      aNextState: TLifeObjectState);
    procedure SetSelfTarget(boFlag: Boolean);
    procedure SetSelf(aSelf: TBasicObject); //设置 自己对象
    procedure ProcessFollow(CurTick: Integer);
  end;

  TGroupSkill = class
  private
    BasicObject: TBasicObject; //自己对象
    MemberList: TList; //成员 列表
  public
    constructor Create(aBasicObject: TBasicObject);
    destructor Destroy; override;

    procedure AddMember(aBasicObject: TBasicObject);
    procedure DeleteMember(aBasicObject: TBasicObject);
    procedure BossDie; //说明：BOSS死亡，清除所有成员 BOSS对象。
    procedure MoveAttack(aTargetID, aX, aY: Integer);
    procedure CancelTarget(aTargetID: Integer);

    //暂时没使用的
    procedure FollowMe;
    procedure FollowEachOther;
    procedure Attack(aTargetID: Integer);
    procedure ChangeBoss(aBasicObject: TBasicObject); //更换BOSS对象
  end;

implementation

uses
  svMain, SubUtil, aUtil32, svClass, uNpc, uMonster, uAIPath, FieldMsg,
  MapUnit, UserSDB, uUser, uItemLog, uProcession;

///////////////////////////////////
//         LifeObject
///////////////////////////////////

constructor TLifeObject.Create;
begin
  inherited Create;
  boDieDelete := false;
  FBoCopy := false;
  //    CopiedList := nil;
   //   CopyBoss := nil;
  HitFunctionSkill := 0;
  HitFunction := 0;
end;

destructor TLifeObject.Destroy;
begin
  FBoCopy := false;
  // CopiedList := nil;
 //  CopyBoss := nil;
  inherited destroy;
end;

function TLifeObject.GetLifeObjectState: TLifeObjectState;
begin
  Result := LifeObjectState;
end;
{
procedure TLifeObject.CopyDie(aBasicObject: TBasicObject);
var
    i: Integer;
begin
    if CopiedList = nil then exit;
    for i := 0 to CopiedList.Count - 1 do
    begin
        if aBasicObject = CopiedList[i] then
        begin
            CopiedList.Delete(i);
            exit;
        end;
    end;
end;
}

function TLifeObject.getMaxLife(): integer;
begin
  result := MaxLife;
end;

function TLifeObject.getCurLife(): integer;
begin
  result := CurLife;
end;

function TLifeObject.AddLife(aLife: integer): boolean; //20091015增加血
begin
  result := false;
  if BasicData.Feature.rfeaturestate = wfs_die then
    exit;
  if CurLife >= MaxLife then
    exit;
  CurLife := CurLife + aLife;
  if CurLife > MaxLife then
    CurLife := MaxLife;
  result := true;
end;

{procedure TLifeObject.CopyBossDie;
begin
    CopyBoss := nil;
    FboAllowDelete := true;
end;
}

procedure TLifeObject.SetHideState(aHideState: THiddenState);
begin
  BasicData.Feature.rHideState := aHideState;
  BocChangeFeature;
end;

procedure TLifeObject.InitialEx;
begin
  fillchar(LifeData, sizeof(LifeData), 0);
  LifeData.damageBody := 55;
  LifeData.damageHead := 0;
  LifeData.damageArm := 0;
  LifeData.damageLeg := 0;
  LifeData.armorBody := 0;
  LifeData.armorHead := 0;
  LifeData.armorArm := 0;
  LifeData.armorLeg := 0;
  LifeData.AttackSpeed := 150;
  LifeData.avoid := 25;
  LifeData.recovery := 70;
  LifeData.accuracy := 0;

  DontAttacked := FALSE;

  LifeObjectState := los_none;
  BasicData.Feature.rfeaturestate := wfs_normal;
  BasicData.LifePercent := 100;
end;

procedure TLifeObject.Initial(aMonsterName, aViewName: string);
begin
  inherited Initial(aMonsterName, aViewName);
  BasicData.BasicObjectType := boLifeObject;

  fillchar(LifeData, sizeof(LifeData), 0);
  LifeData.damageBody := 55;
  LifeData.damageHead := 0;
  LifeData.damageArm := 0;
  LifeData.damageLeg := 0;
  LifeData.armorBody := 0;
  LifeData.armorHead := 0;
  LifeData.armorArm := 0;
  LifeData.armorLeg := 0;
  LifeData.AttackSpeed := 150;
  LifeData.avoid := 25;
  LifeData.recovery := 70;
  LifeData.accuracy := 0;

  HitFunctionSkill := 0;
  HitFunction := 0;
  DontAttacked := FALSE;

  LifeObjectState := los_init;
end;

procedure TLifeObject.StartProcess;
var
  CurTick: integer;
begin
  inherited StartProcess;

  Close_Tick := 0;
  CurTick := mmAnsTick;

  FreezeTick := CurTick;
  DiedTick := CurTick;
  HitedTick := CurTick;
  WalkTick := CurTick;

  LifeObjectState := los_none;
end;

procedure TLifeObject.EndProcess;
var
  i: Integer;
begin
  LifeObjectState := los_exit;

  {    if CopyBoss <> nil then
      begin
          CopyBoss.CopyDie(Self);
          CopyBoss := nil;
      end;
      {
      if CopiedList <> nil then
      begin
          for i := 0 to CopiedList.Count - 1 do
          begin
              TLifeObject(CopiedList[i]).CopyBossDie;
          end;
          CopiedList.Free;
          CopiedList := nil;
      end;
      }
  inherited EndProcess;
end;

function TLifeObject.AllowCommand(CurTick: integer): Boolean;
begin
  Result := TRUE;
  if FreezeTick > CurTick then
    Result := FALSE;
  if BasicData.Feature.rFeatureState = wfs_die then
    Result := FALSE;
end;

function TLifeObject.CommandHited(var SenderInfo: TBasicData; aHitData:
  THitData; apercent: integer): integer;
var
  i, n, lifepercent, declife, exp: integer;
  SubData: TSubData;
  BO: TBasicObject;
  Monster, FirstMonster: TMonster;
  tmpAttackSkill: TAttackSkill;
  aattacker: integer;
begin
  Result := 0;
  case aHitData.HitTargetsType of
    _htt_All: ;
    _htt_Monster: if BasicData.Feature.rrace <> RACE_MONSTER then
        exit;
    _htt_Npc: if BasicData.Feature.rrace <> RACE_NPC then
        exit;
    _htt_nation: if SenderInfo.Feature.rnation = BasicData.Feature.rnation then
        exit;
  end;

  aattacker := SenderInfo.id;
  if DontAttacked then
    exit;

  n := LifeData.avoid + aHitData.ToHit;

  n := Random(n);

  if n < LifeData.avoid then
    exit; // 乔沁澜.

  if apercent = 100 then
  begin //无附带 攻击
    declife := aHitData.damageBody - LifeData.armorBody;
  end
  else
  begin
    declife := (aHitData.damageBody * apercent div 100) *
      aHitData.HitFunctionSkill div 10000 - LifeData.armorBody;
  end;

  // Monster 唱 NPC 狼 磊眉 规绢仿俊 狼茄 厚啦利 眉仿皑家
  //////////////////////////////////////////////
  //       HitArmor 攻击防御  扣攻击力
  /////////////////////////////////////////////
  if LifeData.HitArmor > 0 then
  begin
    declife := declife - ((declife * LifeData.HitArmor) div 100);
  end;

  if declife <= 0 then
    declife := 1;

  CurLife := CurLife - declife; //扣血
  if isUserId(aAttacker) then
  begin
    if tuser(SenderInfo.P).uProcessionclass = nil then
    begin
      if EnmityList.Enmityadd(aAttacker, declife) = false then
      begin
        EnmityList.add(aAttacker, SenderInfo.Name, edyUser, declife);
      end;
    end
    else
    begin
      if
        EnmityList.Enmityadd(TProcessionclass(tuser(SenderInfo.P).uProcessionclass).rid, declife) = false then
      begin
        EnmityList.add(TProcessionclass(tuser(SenderInfo.P).uProcessionclass).rid, '队-'
          +
          TProcessionclass(tuser(SenderInfo.P).uProcessionclass).headmanname.rname, eUserProcession, declife);
      end;

    end;
  end;
  if CurLife <= 0 then
    CurLife := 0;

  FreezeTick := mmAnsTick + LifeData.recovery;

  if MaxLife <= 0 then
  begin
    FboAllowDelete := true;
    exit;
  end;

  if MaxLife <= 0 then
    BasicData.LifePercent := 0
  else
    BasicData.LifePercent := CurLife * 100 div MaxLife;

  SubData.Percent := BasicData.LifePercent;
  SubData.attacker := aAttacker;
  SubData.attackerMasterId := SenderInfo.MasterId;
  SubData.HitData.HitType := aHitData.HitType;
  SubData.HitData.damageBody := aHitData.damageBody;
  SendLocalMessage(NOTARGETPHONE, FM_STRUCTED, BasicData, SubData);

  //  版摹 歹窍扁  //
  n := MaxLife div declife;
  if n > 15 then
    exp := DEFAULTEXP // 10措捞惑 嘎阑父 窍促搁 1000
  else
    exp := DEFAULTEXP * n * n div (15 * 15);
  // 20措 嘎栏搁 磷备档 巢栏搁 10 => 500   n 15 => 750   5=>250
//   else  exp := DEFAULTEXP * n div 15;      // 10措 嘎栏搁 磷备档 巢栏搁 10 => 500   n 15 => 750   5=>250

  SubData.ExpData.Exp := exp;
  SubData.ProcessionClass := nil;
  SubData.ExpData.LevelMax := 9999;
  if BasicData.Feature.rrace = RACE_MONSTER then
  begin
    SubData.ExpData.ExpType := _et_MONSTER;
  end
  else if BasicData.Feature.rrace = RACE_NPC then
    SubData.ExpData.ExpType := _et_NPC
  else
    SubData.ExpData.ExpType := _et_none;

  SubData.attacker := aAttacker;

  if (BasicData.boNotAddExp = false) and (apercent = 100) then
  begin
    if BasicData.BasicObjectType <> botNpc then
    begin
      if SenderInfo.MasterId <> 0 then
      begin
        SubData.ExpData.ExpType := _et_PET;
        SendLocalMessage(SenderInfo.MasterId, FM_ADDATTACKEXP, BasicData,
          SubData); //通知 攻击者获得攻击经验
      end
      else
        SendLocalMessage(aAttacker, FM_ADDATTACKEXP, BasicData, SubData);
      //通知 攻击者获得攻击经验
    end;
  end;
  //////////////////////
  BoSysopMessage(IntToStr(declife) + ' : ' + IntTostr(exp), 10);

  if SoundStructed.rWavNumber <> 0 then
  begin
    //SetWordString(SubData.SayString, IntToStr(SoundStructed.rWavNumber) + '.wav');
    SubData.sound := SoundStructed.rWavNumber;
    SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
  end;

  Result := n;
end;

procedure TLifeObject.CommandHit(CurTick: integer);
var
  SubData: TSubData;
begin
  if not AllowCommand(mmAnsTick) then
    exit;

  if HitedTick + LifeData.AttackSpeed < CurTick then
  begin
    HitedTick := CurTick;
    SubData.HitData.damageBody := LifeData.damageBody;
    SubData.HitData.damageHead := LifeData.damageHead;
    SubData.HitData.damageArm := LifeData.damageArm;
    SubData.HitData.damageLeg := LifeData.damageLeg;

    //      SubData.HitData.ToHit := 100 - LifeData.avoid;
    SubData.HitData.ToHit := 75 + LifeData.accuracy;
    SubData.HitData.HitType := 0;
    SubData.HitData.HitLevel := 7500;
    SubData.HitData.HitTargetsType := BasicData.HitTargetsType;
    SubData.HitData.boHited := FALSE;
    SubData.HitData.HitFunction := HitFunction;
    SubData.HitData.HitFunctionSkill := HitFunctionSkill;

    SendLocalMessage(NOTARGETPHONE, FM_HIT, BasicData, SubData);
    if SoundAttack.rWavNumber <> 0 then
    begin
      //SetWordString(SubData.SayString, IntToStr(SoundAttack.rWavNumber) + '.wav');
      SubData.sound := SoundAttack.rWavNumber;
      SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
    end;

    SubData.motion := BasicData.Feature.rhitmotion;
    SendLocalMessage(NOTARGETPHONE, FM_MOTION, BasicData, SubData);

  end;
end;

procedure TLifeObject.CommandHitHUMAN(CurTick: integer; aMagicDatap:
  PTMagicData);
var
  SubData: TSubData;
  snd: integer;
begin
  if not AllowCommand(mmAnsTick) then
    exit;

  if HitedTick + LifeData.AttackSpeed < CurTick then
  begin
    HitedTick := CurTick;
    SubData.HitData.damageBody := LifeData.damageBody;
    SubData.HitData.damageHead := LifeData.damageHead;
    SubData.HitData.damageArm := LifeData.damageArm;
    SubData.HitData.damageLeg := LifeData.damageLeg;

    //      SubData.HitData.ToHit := 100 - LifeData.avoid;
    SubData.HitData.ToHit := 75 + LifeData.accuracy;
    SubData.HitData.HitType := 0;
    SubData.HitData.HitLevel := 7500;

    SubData.HitData.boHited := FALSE;
    SubData.HitData.HitTargetsType := BasicData.HitTargetsType;
    SubData.HitData.HitFunction := HitFunction;
    SubData.HitData.HitFunctionSkill := HitFunctionSkill;

    //20090908增加
    if aMagicDatap <> nil then
    begin
      //发出攻击
      SubData.HitData.HitFunctionSkill := 0;
      SubData.HitData.HitedCount := 0;
      SubData.HitData.HitLevel := aMagicDatap.rcSkillLevel;
      case aMagicDatap.rFunction of
        MAGICFUNC_5HIT, MAGICFUNC_8HIT:
          begin
            SubData.HitData.HitFunction := aMagicDatap.rFunction;
            SubData.HitData.HitFunctionSkill := aMagicDatap.rcSkillLevel;
          end;
      end;

      SendLocalMessage(NOTARGETPHONE, FM_HIT, BasicData, SubData);
      //声音
      if SubData.HitData.boHited then
      begin
        snd := aMagicDatap.rSoundStrike.rWavNumber;
        if snd <> 0 then
        begin
          case aMagicDatap.rcSkillLevel of
            0..4999: snd := aMagicDatap.rSoundStrike.rWavNumber;
            5000..8999: snd := aMagicDatap.rSoundStrike.rWavNumber + 2;
          else
            snd := aMagicDatap.rSoundStrike.rWavNumber + 4;
          end;
          SubData.sound := snd;
          SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);

        end;
      end
      else
      begin
        snd := aMagicDatap.rSoundSwing.rWavNumber;
        if snd <> 0 then
        begin
          case aMagicDatap.rcSkillLevel of
            0..4999: snd := aMagicDatap.rSoundSwing.rWavNumber;
            5000..8999: snd := aMagicDatap.rSoundSwing.rWavNumber + 2;
          else
            snd := aMagicDatap.rSoundSwing.rWavNumber + 4;
          end;
          SubData.sound := snd;
          SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
        end;
      end;
      //攻击效果

      SubData.motion := BasicData.Feature.rhitmotion;
      case aMagicDatap.rMagicType of
        MAGICTYPE_WRESTLING:
          begin
            if (aMagicDatap.rcSkillLevel > 5000) then
              SubData.motion := 30 + Random(2);
          end;
        MAGICTYPE_FENCING:
          begin
            if (aMagicDatap.rcSkillLevel > 5000) then
            begin
              if Random(2) = 1 then
                SubData.motion := 38;
            end
          end;
        MAGICTYPE_SWORDSHIP:
          begin
            if (aMagicDatap.rcSkillLevel > 5000) then
            begin
              if Random(2) = 1 then
                SubData.motion := 37;
            end
          end;
      end;
      if aMagicDatap.rcSkillLevel = 9999 then
      begin
        SubData.motionMagicType := aMagicDatap.rMagicType + 1;
        SubData.motionMagicColor := aMagicDatap.rEffectColor;

        SendLocalMessage(NOTARGETPHONE, FM_MOTION2, BasicData, SubData);
      end
      else
        SendLocalMessage(NOTARGETPHONE, FM_MOTION, BasicData, SubData);

    end
    else
    begin
      SendLocalMessage(NOTARGETPHONE, FM_HIT, BasicData, SubData);
      if SoundAttack.rWavNumber <> 0 then
      begin
        //SetWordString(SubData.SayString, IntToStr(SoundAttack.rWavNumber) + '.wav');
        SubData.sound := SoundAttack.rWavNumber;
        SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
      end;

      SubData.motion := BasicData.Feature.rhitmotion;
      SendLocalMessage(NOTARGETPHONE, FM_MOTION, BasicData, SubData);
    end;
  end;
end;

procedure TLifeObject.CommandSay(astr: string);
var
  SubData: TSubData;
begin
  SetWordString(SubData.SayString, (BasicData.ViewName) + ': ' + astr);
  SendLocalMessage(NOTARGETPHONE, FM_SAY, BasicData, SubData);
end;

procedure TLifeObject.CommandTurn(adir: word);
var
  SubData: TSubData;
begin
  if not AllowCommand(mmAnsTick) then
    exit;
  BasicData.dir := adir;
  SendLocalMessage(NOTARGETPHONE, FM_TURN, BasicData, SubData);
end;

procedure TLifeObject.CommandChangeCharState(aFeatureState: TFeatureState);
var
  i: Integer;
  SubData: TSubData;
  BO: TLifeObject;
begin
  if aFeatureState = wfs_die then
  begin
    LifeObjectState := los_die;

    if BasicData.Feature.rHideState <> hs_100 then
    begin
      BasicData.Feature.rHideState := hs_100;
      SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
    end;
    if FboCopy = true then
    begin
      ShowEffect(1, lek_none);
    end;
    {        if CopiedList <> nil then
            begin
                for i := 0 to CopiedList.Count - 1 do
                begin
                    BO := CopiedList[i];
                    if BO <> nil then
                    begin
                        BO.CommandChangeCharState(aFeatureState);
                    end;
                end;
            end;}
    DiedTick := mmAnsTick;
    if SoundDie.rWavNumber <> 0 then
    begin
      // SetWordString(SubData.SayString, IntToStr(SoundDie.rWavNumber) + '.wav');
      SubData.sound := SoundDie.rWavNumber;
      SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
    end;
  end;
  BasicData.Feature.rfeaturestate := aFeatureState;
  SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);
end;
{
procedure TLifeObject.ShowEffect(aEffectNumber:Word; aEffectKind:TLightEffectKind);
var
    SubData         :TSubData;
begin
    BasicData.Feature.rEffectNumber := aEffectNumber;
    BasicData.Feature.rEffectKind := aEffectKind;

    SendLocalMessage(NOTARGETPHONE, FM_CHANGEFEATURE, BasicData, SubData);

    BasicData.Feature.rEffectNumber := 0;
    BasicData.Feature.rEffectKind := lek_none;

end;
}

function TLifeObject.ShootMagic(var aMagic: TMagicData; Bo: TBasicObject):
  Boolean;
var
  SubData: TSubData;
  CurTick: Integer;
begin
  Result := false;

  CurTick := mmAnsTick;

  if not AllowCommand(CurTick) then
    exit;

  if HitedTick + LifeData.AttackSpeed >= CurTick then
    exit;

  HitedTick := mmAnsTick;

  if GetViewDirection(BasicData.x, BasicData.y, bo.PosX, bo.posy) <>
    basicData.dir then
    CommandTurn(GetViewDirection(BasicData.x, BasicData.y, bo.posx, bo.posy));

  SubData.motion := BasicData.Feature.rhitmotion;
  SendLocalMessage(NOTARGETPHONE, FM_MOTION, BasicData, SubData);

  SubData.HitData.damageBody := aMagic.rLifeData.damageBody;
  SubData.HitData.damageHead := aMagic.rLifeData.damageHead;
  SubData.HitData.damageArm := aMagic.rLifeData.damageArm;
  SubData.HitData.damageLeg := aMagic.rLifeData.damageLeg;

  SubData.HitData.ToHit := 75 + LifeData.accuracy;
  SubData.HitData.HitType := 1;
  SubData.HitData.HitLevel := 0;
  SubData.HitData.HitLevel := aMagic.rcSkillLevel;

  SubData.TargetId := Bo.BasicData.id;
  SubData.tx := Bo.PosX;
  SubData.ty := Bo.PosY;
  SubData.BowImage := aMagic.rBowImage;
  SubData.BowSpeed := aMagic.rBowSpeed;
  SubData.BowType := aMagic.rBowType;
  SubData.EEffectNumber := aMagic.rEEffectNumber;

  SubData.HitData.HitTargetsType := BasicData.HitTargetsType;
  SubData.HitData.HitFunction := HitFunction;
  SubData.HitData.HitFunctionSkill := HitFunctionSkill;

  SendLocalMessage(NOTARGETPHONE, FM_BOW, BasicData, SubData);

  if aMagic.rSoundStrike.rWavNumber <> 0 then
  begin
    //SetWordString(SubData.SayString, IntTostr(aMagic.rSoundStrike.rWavNumber) + '.wav');
    SubData.sound := (aMagic.rSoundStrike.rWavNumber);
    SendLocalMessage(NOTARGETPHONE, FM_SOUND, BasicData, SubData);
  end;

  Result := true;
end;

function TLifeObject.GotoXyStandAI(ax, ay: word): Integer;
var
  x, y: Integer;
  key: word;
  SubData: TSubData;
begin
  Result := 2;
  x := 0;
  y := 0;
  if (ax = BasicData.x) and (ay = BasicData.y) then
  begin
    Result := 0;
    exit;
  end;

  SearchPathClass.SetMaper(Maper);
  SearchPathClass.GotoPath(BasicData.x, BasicData.y, ax, ay, x, y);
  if (x <> 0) and (y <> 0) then
  begin
    key := GetNextDirection(BasicData.x, BasicData.y, x, y);
    if BasicData.dir <> key then
    begin
      CommandTurn(key);
      Result := 1;
      exit;
    end;
    if Maper.isMoveable(x, y) then
    begin
      BasicData.nx := x;
      BasicData.ny := y;
      Phone.SendMessage(NOTARGETPHONE, FM_MOVE, BasicData, SubData);
      Maper.MapProc(BasicData.Id, MM_MOVE, BasicData.x, BasicData.y, x, y,
        BasicData);
      BasicData.x := x;
      BasicData.y := y;
    end;
  end;
end;
//Result   2默认  1在目标位置不需要移动。  0失败0距离。

function TLifeObject.GotoXyStand(ax, ay: word): integer;
  function _Gap(a1, a2: word): integer;
  begin
    if a1 > a2 then
      Result := a1 - a2
    else
      Result := a2 - a1;
  end;

var
  i: integer;
  SubData: TSubData;
  key, len: word;
  boarr: array[0..8 - 1] of Boolean;
  lenarr: array[0..8 - 1] of word;
  mx, my: word;
begin

  Result := 2;

  ////////////////20091015增加活动范围0不移动//////////////////////////
  if (ActionWidth = 0) or LockNotMoveState then
  begin
    Result := 0;
    exit;
  end;
  len := _Gap(BasicData.x, ax) + _Gap(BasicData.y, ay);
  if (len = 0) then
  begin
    Result := 0;
    exit;
  end;
  //计算出方向
  key := GetNextDirection(BasicData.x, BasicData.y, ax, ay);
  //计算出下1坐标
  mx := BasicData.x;
  my := BasicData.y;
  GetNextPosition(key, mx, my);
  if (mx = ax) and (my = ay) and not Maper.IsMoveable(ax, ay) then
  begin
    if BasicData.dir <> key then
      CommandTurn(key);
    Result := 1;
    exit;
  end;
  ///////////////////////
  //      20091017增加 目标8个方向都无法移动
 { if Maper.GetMoveableXy8(ax, ay) = false then
  begin
      Result := -3;
      exit;
  end;
 }
  ////////////////////////
  for i := 0 to 8 - 1 do
    lenarr[i] := 65535;

  boarr[0] := Maper.isMoveable(BasicData.x, BasicData.y - 1);
  if (OldPos.x = BasicData.x) and (OldPos.y = BasicData.y - 1) then
    boarr[0] := FALSE;
  if boarr[0] then
    lenarr[0] := (BasicData.x - ax) * (BasicData.x - ax) + (BasicData.y - 1 - ay)
      * (BasicData.y - 1 - ay);

  boarr[1] := Maper.isMoveable(BasicData.x + 1, BasicData.y - 1);
  if (OldPos.x = BasicData.x + 1) and (OldPos.y = BasicData.y - 1) then
    boarr[1] := FALSE;
  if boarr[1] then
    lenarr[1] := (BasicData.x + 1 - ax) * (BasicData.x + 1 - ax) + (BasicData.y
      - 1 - ay) * (BasicData.y - 1 - ay);

  boarr[2] := Maper.isMoveable(BasicData.x + 1, BasicData.y);
  if (OldPos.x = BasicData.x + 1) and (OldPos.y = BasicData.y) then
    boarr[2] := FALSE;
  if boarr[2] then
    lenarr[2] := (BasicData.x + 1 - ax) * (BasicData.x + 1 - ax) + (BasicData.y
      - ay) * (BasicData.y - ay);

  boarr[3] := Maper.isMoveable(BasicData.x + 1, BasicData.y + 1);
  if (OldPos.x = BasicData.x + 1) and (OldPos.y = BasicData.y + 1) then
    boarr[3] := FALSE;
  if boarr[3] then
    lenarr[3] := (BasicData.x + 1 - ax) * (BasicData.x + 1 - ax) + (BasicData.y
      + 1 - ay) * (BasicData.y + 1 - ay);

  boarr[4] := Maper.isMoveable(BasicData.x, BasicData.y + 1);
  if (OldPos.x = BasicData.x) and (OldPos.y = BasicData.y + 1) then
    boarr[4] := FALSE;
  if boarr[4] then
    lenarr[4] := (BasicData.x - ax) * (BasicData.x - ax) + (BasicData.y + 1 - ay)
      * (BasicData.y + 1 - ay);

  boarr[5] := Maper.isMoveable(BasicData.x - 1, BasicData.y + 1);
  if (OldPos.x = BasicData.x - 1) and (OldPos.y = BasicData.y + 1) then
    boarr[5] := FALSE;
  if boarr[5] then
    lenarr[5] := (BasicData.x - 1 - ax) * (BasicData.x - 1 - ax) + (BasicData.y
      + 1 - ay) * (BasicData.y + 1 - ay);

  boarr[6] := Maper.isMoveable(BasicData.x - 1, BasicData.y);
  if (OldPos.x = BasicData.x - 1) and (OldPos.y = BasicData.y) then
    boarr[6] := FALSE;
  if boarr[6] then
    lenarr[6] := (BasicData.x - 1 - ax) * (BasicData.x - 1 - ax) + (BasicData.y
      - ay) * (BasicData.y - ay);

  boarr[7] := Maper.isMoveable(BasicData.x - 1, BasicData.y - 1);
  if (OldPos.x = BasicData.x - 1) and (OldPos.y = BasicData.y - 1) then
    boarr[7] := FALSE;
  if boarr[7] then
    lenarr[7] := (BasicData.x - 1 - ax) * (BasicData.x - 1 - ax) + (BasicData.y
      - 1 - ay) * (BasicData.y - 1 - ay);

  len := 65535;
  for i := 0 to 8 - 1 do
  begin
    if len > lenarr[i] then
    begin
      key := i;
      len := lenarr[i];
    end;
  end;

  mx := BasicData.x;
  my := BasicData.y;
  GetNextPosition(key, mx, my);
  if key <> BasicData.dir then
    CommandTurn(key)
  else
  begin
    if Maper.isMoveable(mx, my) then
    begin
      OldPos.x := BasicData.x;
      Oldpos.y := BasicData.y;
      BasicData.dir := key;
      BasicData.nx := mx;
      BasicData.ny := my;
      Phone.SendMessage(NOTARGETPHONE, FM_MOVE, BasicData, SubData);
      Maper.MapProc(BasicData.Id, MM_MOVE, BasicData.x, BasicData.y, mx, my,
        BasicData);
      BasicData.x := mx;
      BasicData.y := my;

    end
    else
    begin
      OldPos.x := 0;
      OldPos.y := 0;
      Result := -1;
    end;
  end;
end;

function TLifeObject.GotoXyStand_SET(ax, ay: word): integer;
  function _Gap(a1, a2: word): integer;
  begin
    if a1 > a2 then
      Result := a1 - a2
    else
      Result := a2 - a1;
  end;

var
  i: integer;
  SubData: TSubData;
  key, len: word;
  mx, my: word;
begin
  Result := 2;
  if LockNotMoveState then
  begin
    Result := 0;
    exit;
  end;
  //范围0
  len := _Gap(BasicData.x, ax) + _Gap(BasicData.y, ay);
  if (len = 0) then
  begin
    Result := 0;
    exit;
  end;
  //计算出方向
  key := GetNextDirection(BasicData.x, BasicData.y, ax, ay);
  //计算出下1坐标
  mx := BasicData.x;
  my := BasicData.y;
  GetNextPosition(key, mx, my);

  if key <> BasicData.dir then
  begin
    CommandTurn(key);
    exit;
  end;

  if Maper.getMoveable(mx, my) then
  begin
    OldPos.x := BasicData.x;
    Oldpos.y := BasicData.y;
    BasicData.dir := key;
    BasicData.nx := mx;
    BasicData.ny := my;
    Phone.SendMessage(NOTARGETPHONE, FM_MOVE, BasicData, SubData);
    Maper.MapProc(BasicData.Id, MM_MOVE, BasicData.x, BasicData.y, mx, my,
      BasicData);
    BasicData.x := mx;
    BasicData.y := my;
  end
  else
  begin
    OldPos.x := 0;
    OldPos.y := 0;
    Result := -1;
  end;

end;

function TLifeObject.FieldProc(hfu: Longint; Msg: word; var SenderInfo:
  TBasicData; var aSubData: TSubData): Integer;
var
  n, percent: integer;
  x1, y1: integer;
begin
  //   Result := PROC_FALSE;
  //   if isRangeMessage ( hfu, Msg, SenderInfo) = FALSE then exit;
  Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
  if Fboice then
    exit;
  if Result = PROC_TRUE then
    exit;
  case Msg of
    FM_MOVE:
      begin
        if SenderInfo.ID = BasicData.ID then
          exit;
        if BasicData.Feature.rfeaturestate = wfs_die then
          exit;
        if SenderInfo.boMoveKill then
        begin
          if GetLargeLength(BasicData.x, BasicData.y, SenderInfo.x, SenderInfo.y)
            <= SenderInfo.boMoveKillView then
          begin
            CurLife := 0;
            BasicData.LifePercent := 0;
            CommandChangeCharState(wfs_die);
            CallScriptFunction('OnDie', [integer(SenderInfo.p), integer(self),
              SenderInfo.Feature.rrace]);
          end;
        end;
      end;
    FM_BOW:
      begin
        if BasicData.boNotHit then
          exit;
        if SenderInfo.id = BasicData.id then
          exit;
        if BasicData.Feature.rfeaturestate = wfs_die then
          exit;
        //                if aSubData.TargetId = Basicdata.id then
        if (aSubData.TargetId = Basicdata.id) or
          ((aSubData.HitData.HitFunction <> 0) and isHitedArea(SenderInfo.dir,
          aSubData.tx, aSubData.ty, aSubData.HitData.HitFunction, percent)) then
        begin
          if aSubData.TargetId = Basicdata.id then
            percent := 100;
          n := CommandHited(SenderInfo, aSubData.HitData, percent);
          if CurLife <= 0 then
          begin // 死亡
            CommandChangeCharState(wfs_die);
            //                    if (SenderInfo.BasicObjectType = botUser)
          //                          and (BasicData.BasicObjectType = botMonster)
        //                            then
            begin

              CallScriptFunction('OnDie', [integer(SenderInfo.p), integer(self),
                SenderInfo.Feature.rrace]);
            end;

          end;
          if n <> 0 then
          begin
            aSubData.HitData.boHited := TRUE;
            aSubData.HitData.HitedCount := aSubData.HitData.HitedCount + 1;
          end;
        end;
      end;
    FM_HIT:
      begin
        if BasicData.boNotHit then
          exit;
        if BasicData.Feature.rfeaturestate = wfs_die then
          exit;
        if SenderInfo.id = BasicData.id then
          exit;
        if isHitedArea(SenderInfo.dir, SenderInfo.x, SenderInfo.y,
          aSubData.HitData.HitFunction, percent) then //percent 攻击率
        begin //测试是否攻击自己
          n := CommandHited(SenderInfo, aSubData.HitData, percent);
          if (CurLife <= 0) then
          begin //怪物 死亡
            CommandChangeCharState(wfs_die);
            //人攻击怪物，死亡后调用，脚本
          //  if (SenderInfo.BasicObjectType = botUser) and (BasicData.BasicObjectType = botMonster) then
            begin
              CallScriptFunction('OnDie', [integer(SenderInfo.p), integer(self),
                SenderInfo.Feature.rrace]);
            end;
          end;
          if n <> 0 then
          begin
            aSubData.HitData.boHited := TRUE;
            aSubData.HitData.HitedCount := aSubData.HitData.HitedCount + 1;
          end;
        end;
        {
                    xx := SenderInfo.x; yy := SenderInfo.y;
                    GetNextPosition (SenderInfo.dir, xx, yy);
                    if (BasicData.x = xx) and (BasicData.y = yy) then begin
                       n := CommandHited (SenderInfo.id, aSubData.HitData);
                       if (CurLife <= 0) then CommandChangeCharState (wfs_die);
                       if n <> 0 then aSubData.HitData.boHited := TRUE;
                    end;
        }
      end;
  end;
end;
{
procedure   TLifeObject.Update (CurTick: integer);
begin
   inherited Update (CurTick);
end;
}

constructor TBuySellSkill.Create(aBasicObject: TBasicObject);
begin
  BasicObject := aBasicObject;

  BuyItemList := TList.Create;
  SellItemList := TList.Create;

  boLogItem := false;
  boEmailstate := false;
  boAuctionstate := false;
  boUPdateItem_UPLevel := false;
  boUPdateItem_Setting := false;
  boUPdateItem_Setting_del := false;
  boBuyItemAllState := false;
  BUYTITLE := '';
  BUYCAPTION := '';
  //    BUYIMAGE := 0;

  SELLTITLE := '';
  SELLCAPTION := '';
  //    SELLIMAGE := 0;

  UPItemLevelTITLE := '';
  UPItemLevelCAPTION := '';
  // UPItemLevelIMAGE := 0;

  UPItemSettingTITLE := '';
  UPItemSettingCAPTION := '';
  //UPItemSettingIMAGE := 0;

  UPItemSettingDelTITLE := '';
  UPItemSettingDelCAPTION := '';
  // UPItemSettingDelIMAGE := 0;
end;

destructor TBuySellSkill.Destroy;
begin
  Clear;
  if BuyItemList <> nil then
    BuyItemList.Free;
  if SellItemList <> nil then
    SellItemList.Free;

  inherited Destroy;
end;

procedure TBuySellSkill.Clear;
var
  i: Integer;
  pItemData: PTItemData;
begin
  if BuyItemList <> nil then
  begin
    for i := 0 to BuyItemList.Count - 1 do
    begin
      pItemData := BuyItemList.Items[i];
      if pItemData <> nil then
        Dispose(pItemData);
    end;
    BuyItemList.Clear;
  end;
  if SellItemList <> nil then
  begin
    for i := 0 to SellItemList.Count - 1 do
    begin
      pItemData := SellItemList.Items[i];
      if pItemData <> nil then
        Dispose(pItemData);
    end;
    SellItemList.Clear;
  end;
end;

function TBuySellSkill.LoadFromFile(aFileName: string): Boolean;
var
  i: Integer;
  mStr, KindStr, ItemName: string;
  StringList: TStringList;
  ItemData: TItemData;
  pItemData: PTItemData;
begin
  Result := false;

  if FileExists(aFileName) then
  begin
    FileName := aFileName;
    Clear;

    StringList := TStringList.Create;
    StringList.LoadFromFile(aFileName);
    for i := 0 to StringList.Count - 1 do
    begin
      mStr := StringList.Strings[i];
      if mStr <> '' then
      begin
        mStr := GetValidStr3(mStr, KindStr, ':');
        mStr := GetValidStr3(mStr, ItemName, ':');

        if UpperCase(KindStr) = 'BUYTITLE' then
          BUYTITLE := (ItemName)
        else if UpperCase(KindStr) = 'BUYCAPTION' then
          BUYCAPTION := (ItemName)
            //                else if UpperCase(KindStr) = 'BUYIMAGE' then BUYIMAGE := _StrToInt(ItemName)
        else if UpperCase(KindStr) = 'SELLTITLE' then
          SELLTITLE := (ItemName)
        else if UpperCase(KindStr) = 'SELLCAPTION' then
          SELLCAPTION := (ItemName)
            //                else if UpperCase(KindStr) = 'SELLIMAGE' then SELLIMAGE := _StrToInt(ItemName)
        else if UpperCase(KindStr) = 'UPITEMLEVELTITLE' then
          UPITEMLEVELTITLE := (ItemName)
        else if UpperCase(KindStr) = 'UPITEMLEVELCAPTION' then
          UPITEMLEVELCAPTION := (ItemName)
            // else if UpperCase(KindStr) = 'UPITEMLEVELIMAGE' then UPITEMLEVELIMAGE := _StrToInt(ItemName)
        else if UpperCase(KindStr) = 'UPITEMSETTINGTITLE' then
          UPItemSettingTITLE := (ItemName)
        else if UpperCase(KindStr) = 'UPITEMSETTINGCAPTION' then
          UPItemSettingCAPTION := (ItemName)
            // else if UpperCase(KindStr) = 'UPITEMSETTINGIMAGE' then UPItemSettingIMAGE := _StrToInt(ItemName)
        else if UpperCase(KindStr) = 'UPITEMSETTINGDELTITLE' then
          UPItemSettingDELTITLE := (ItemName)
        else if UpperCase(KindStr) = 'UPITEMSETTINGDELCAPTION' then
          UPItemSettingDELCAPTION := (ItemName)
            // else if UpperCase(KindStr) = 'UPITEMSETTINGDELIMAGE' then UPItemSettingDELIMAGE := _StrToInt(ItemName)
          ;

        if (KindStr <> '') and (ItemName <> '') then
        begin
          ItemClass.GetItemData(ItemName, ItemData);
          if ItemData.rName <> '' then
          begin
            New(pItemData);
            Move(ItemData, pItemData^, sizeof(TItemData));
            if UpperCase(KindStr) = 'SELLITEM' then
              SellItemList.Add(pItemData)
            else if UpperCase(KindStr) = 'BUYITEM' then
              BuyItemList.Add(pItemData);
          end;
        end
        else if UpperCase(KindStr) = 'LOGITEM' then
        begin
          boLogItem := true;
        end
        else if UpperCase(KindStr) = 'EMAIL' then
        begin
          boEmailstate := true;
        end
        else if UpperCase(KindStr) = 'AUCTION' then
        begin
          boAuctionstate := true;

        end
        else if UpperCase(KindStr) = 'UPLEVEL' then
        begin
          boUPdateItem_UPLevel := true;

        end
        else if UpperCase(KindStr) = 'UPSETTING' then
        begin
          boUPdateItem_Setting := true;

        end
        else if UpperCase(KindStr) = 'UPSETTINGDEL' then
        begin
          boUPdateItem_Setting_del := true;
        end
        else if UpperCase(KindStr) = 'BUYITEMALL' then
        begin
          boBuyItemAllState := true;
        end;

      end;
    end;
    StringList.Free;
    Result := true;
  end;
end;

function TBuySellSkill.DivHearing(aHearStr: string; var Sayer, aItemName:
  string; var aItemCount: integer): integer;
var
  str: string;
  str1, str2, str3: string;
begin
  Result := DIVRESULT_NONE;

  if not ReverseFormat(aHearStr, '%s: %s', str1, str2, str3, 2) then
    exit;
  sayer := str1;

  str := str2;

  if Pos('卖什么', str) = 1 then
    Result := DIVRESULT_WHATSELL;
  if Pos('买什么', str) = 1 then
    Result := DIVRESULT_WHATBUY;
  if Pos('买入', str) = 1 then
    Result := DIVRESULT_WHATSELL;
  if Pos('卖出', str) = 1 then
    Result := DIVRESULT_WHATBUY;
  if Result <> DIVRESULT_NONE then
    exit;

  if ReverseFormat(str, '%s 多少钱', str1, str2, str3, 1) then
  begin
    aItemName := str1;
    Result := DIVRESULT_HOWMUCH;
    exit;
  end;

  if ReverseFormat(str, '买 %s %s个', str1, str2, str3, 2) then
  begin
    aItemName := str1;
    aItemCount := _StrToInt(str2);
    Result := DIVRESULT_BUYITEM;
    exit;
  end;
  if ReverseFormat(str, '买 %s %s个', str1, str2, str3, 2) then
  begin
    aItemName := str1;
    aItemCount := _StrToInt(str2);
    Result := DIVRESULT_BUYITEM;
    exit;
  end;

  if ReverseFormat(str, '卖 %s %s个', str1, str2, str3, 2) then
  begin
    aItemName := str1;
    aItemCount := _StrToInt(str2);
    if aItemCount < 0 then
      aItemCount := 0;
    Result := DIVRESULT_SELLITEM;
    exit;
  end;
  if ReverseFormat(str, '卖 %s %s个', str1, str2, str3, 2) then
  begin
    aItemName := str1;
    aItemCount := _StrToInt(str2);
    if aItemCount < 0 then
      aItemCount := 0;
    Result := DIVRESULT_SELLITEM;
    exit;
  end;

  if ReverseFormat(str, '买入%s', str1, str2, str3, 1) then
  begin
    aItemName := str1;
    aItemCount := 1;
    Result := DIVRESULT_BUYITEM;
    exit;
  end;
  if ReverseFormat(str, '买入%s', str1, str2, str3, 1) then
  begin
    aItemName := str1;
    aItemCount := 1;
    Result := DIVRESULT_BUYITEM;
    exit;
  end;

  if ReverseFormat(str, '卖出%s', str1, str2, str3, 1) then
  begin
    aItemName := str1;
    aItemCount := 1;
    Result := DIVRESULT_SELLITEM;
    exit;
  end;
  if ReverseFormat(str, '卖出%s', str1, str2, str3, 1) then
  begin
    aItemName := str1;
    aItemCount := 1;
    Result := DIVRESULT_SELLITEM;
    exit;
  end;
end;

function TBuySellSkill.getBuyName(aname: string): PTItemData;
var
  i: integer;
  pp: PTItemData;
begin
  result := nil;
  for i := 0 to BuyItemList.Count - 1 do
  begin
    pp := BuyItemList.Items[i];
    if pp.rName = aname then
    begin
      result := pp;
      exit;
    end;
  end;

end;

function TBuySellSkill.getSellIndex(aindex: integer): PTItemData;
begin
  result := nil;
  if (aindex < 0) or (aindex >= SellItemList.Count) then
    exit;
  result := SellItemList.Items[aindex];
end;

function TBuySellSkill.ProcessMessageNEW(PCnpc: PTCnpc; SenderInfo: TBasicData):
  Boolean;
var
  j, I: INTEGER;
  pItemData: PTItemData;

  iprice, icnt, ipos, ret: Integer;
  str, sayer, RetStr: string;
  ItemData, MoneyItemData: TItemData;
  SubData: TSubData;
  User: TUser;
  uNPC: tNPC;
begin
  result := false;
  case PCnpc^.rKEY of
    MenuFT_UPdateItem_UPLevel:
      begin
        if boUPdateItem_UPLevel = FALSE then
          EXIT;
        User := SenderInfo.P;
        if not Assigned(User) then
          exit;

        if user.MenuSTATE <> nsSAY then
          exit;
        if user.IsMenuSAY('@upitemlevel') = false then
          exit;

        unpc := tnpc(BasicObject);
        if unpc = nil then
          exit;
        user.MenuSTATE := nsUPdateitemLevel;
        User.ShowUPdataItemLevelWindow(UPItemLevelTITLE, UPItemLevelCAPTION,
          (uNPC.pSelfData.rShape), (uNPC.pSelfData.rImage));

      end;
    MenuFT_UPdateItem_Setting:
      begin
        if boUPdateItem_Setting = FALSE then
          EXIT;
        User := SenderInfo.P;
        if not Assigned(User) then
          exit;

        if user.MenuSTATE <> nsSAY then
          exit;
        if user.IsMenuSAY('@upitemsetting') = false then
          exit;
        unpc := tnpc(BasicObject);
        if unpc = nil then
          exit;
        user.MenuSTATE := nsUPdateitemSetting;
        User.ShowUPdataItemSettingWindow(UPItemSettingTITLE,
          UPItemSettingCAPTION, (uNPC.pSelfData.rShape),
          (uNPC.pSelfData.rImage));

      end;
    MenuFT_UPdateItem_Setting_del:
      begin
        if boUPdateItem_Setting_del = FALSE then
          EXIT;
        User := SenderInfo.P;
        if not Assigned(User) then
          exit;

        if user.MenuSTATE <> nsSAY then
          exit;
        if user.IsMenuSAY('@upitemsettingdel') = false then
          exit;
        unpc := tnpc(BasicObject);
        if unpc = nil then
          exit;
        user.MenuSTATE := nsUPdateitemSettingdel;
        User.ShowUPdataItemSettingdelWindow(UPItemSettingDelTITLE,
          UPItemSettingDelCAPTION, (uNPC.pSelfData.rShape),
          (uNPC.pSelfData.rImage));

      end;
    MenuFT_email: //邮件
      begin
        if not CanEmailstate then
          exit;

        User := SenderInfo.P;
        if not Assigned(User) then
          exit;

        if user.MenuSTATE <> nsSAY then
          exit;
        if user.IsMenuSAY('@email') = false then
          exit;
        user.MenuSTATE := nsemail;
        RetStr := User.ShowEmailWindow;
        if RetStr <> '' then
        begin
          TLIfeObject(BasicObject).CommandSay(RetStr);
        end;

      end;
    MenuFT_auction: //寄售系统
      begin
        if not CanAuctionstate then
          exit;

        User := SenderInfo.P;
        if not Assigned(User) then
          exit;

        if user.MenuSTATE <> nsSAY then
          exit;
        if user.IsMenuSAY('@auction') = false then
          exit;
        user.MenuSTATE := nsauction;
        RetStr := User.ShowauctionWindow;
        if RetStr <> '' then
        begin
          TLIfeObject(BasicObject).CommandSay(RetStr);
        end;

      end;
    MenuFT_logitem: //仓库
      begin
        if not CanLogItem then
          exit;

        User := SenderInfo.P;
        if not Assigned(User) then
          exit;

        if user.MenuSTATE <> nsSAY then
          exit;
        if user.IsMenuSAY('@logitem') = false then
          exit;

        user.MenuSTATE := nsLOGITEM;
        RetStr := User.ShowItemLogWindow;
        if RetStr <> '' then
        begin
          TLIfeObject(BasicObject).CommandSay(RetStr);
        end;

      end;
    MenuFT_SELLDIR: //
      begin
        User := SenderInfo.P;
        if not Assigned(User) then
          exit;
        if user.MenuSTATE <> nsSAY then
          exit;

        if SellItemList.count <= 0 then
          exit;
        if user.IsMenuSAY('@buy') = false then
          exit;
        user.MenuSTATE := nsSELL;
        unpc := tnpc(BasicObject);
        if unpc = nil then
          exit;
        if not user.ShowItemSellWindow(SELLTITLE, SELLCAPTION,
          (uNPC.pSelfData.rShape), (uNPC.pSelfData.rImage)) then
          exit;

        for i := 0 to SellItemList.count - 1 do
        begin
          pItemData := SellItemList[i];

          user.SendClass.SendNPCItem(I, pItemData^, 0);
        end;

      end;
    MenuFT_BUYDIR:
      begin
        User := SenderInfo.P;
        if not Assigned(User) then
          exit;
        if user.MenuSTATE <> nsSAY then
          exit;

        if BuyItemList.count <= 0 then
          exit;
        if user.IsMenuSAY('@sell') = false then
          exit;

        user.MenuSTATE := nsBUF;
        unpc := tnpc(BasicObject);
        if unpc = nil then
          exit;
        if not user.ShowItemBuyWindow(BUYTITLE, BUYCAPTION,
          (uNPC.pSelfData.rShape), (uNPC.pSelfData.rImage), CanBuyItemAllState)
          then
          exit;

        for i := 0 to BuyItemList.count - 1 do
        begin
          pitemdata := Buyitemlist[i];
          User.SendClass.SendNPCItem(I, pitemdata^, 0);
        end;

      end;
    MenuFT_BUY:
      //NPC 卖出
      begin
        User := SenderInfo.P;
        if not Assigned(User) then
          exit;
        if user.MenuSTATE <> nsSELL then
          exit;
        if user.SpecialWindow <> WINDOW_ITEMTrade_sell then
          exit;

        icnt := PCnpc.rnum;
        if icnt <= 0 then
          exit;
        if icnt > 10000 then
        begin
          TLIfeObject(BasicObject).CommandSay('数量太多。');
          exit;
        end;
        pitemdata := getSellIndex(PCnpc.rItemKey);
        if pitemdata = nil then
        begin
          TLIfeObject(BasicObject).CommandSay('没有此物品');
          exit;
        end;

        ItemClass.GetItemData(INI_GOLD, MoneyItemData);
        ItemClass.GetItemData(pitemdata.rName, ItemData);

        if (ItemData.rboDouble = false) and (icnt > 1) then
        begin
          TLIfeObject(BasicObject).CommandSay(format('%s只卖一个',
            [(ItemData.rViewName)]));
          exit;
        end;
        if TFieldPhone(BasicObject.Manager.Phone).SendMessage(SenderInfo.id,
          FM_ENOUGHSPACE, BasicObject.BasicData, SubData) = PROC_FALSE then
        begin
          TLIfeObject(BasicObject).CommandSay('携带的物品太多了。');
          exit;
        end;
        user.affair(hicaStart);

        MoneyItemData.rCount := ItemData.rPrice * icnt;
        SubData.ItemData := MoneyItemData;
        if TFieldPhone(BasicObject.Manager.Phone).SendMessage(SenderInfo.id,
          FM_DELITEM, BasicObject.BasicData, SubData) = PROC_FALSE then
        begin
          TLIfeObject(BasicObject).CommandSay('所带的钱太少');
          exit;
        end;

        ItemData.rCount := icnt;
        NewItemSet(_nist_Not_property, ItemData); //打编号 等操作
        SubData.ItemData := ItemData;
        SubData.ServerId := BasicObject.Manager.ServerId;
        if TFieldPhone(BasicObject.Manager.Phone).SendMessage(SenderInfo.id,
          FM_ADDITEM, BasicObject.BasicData, SubData) = PROC_FALSE then
        begin
          user.affair(hicaRoll_back);
          exit;
        end;
        TLIfeObject(BasicObject).CommandSay(format('卖掉了%s。',
          [pitemdata.rViewName]));
      end;
    MenuFT_SELL:
      //NPC 购进   PCnpc.rItemKey 是背包位置
      begin
        User := SenderInfo.P;
        if not Assigned(User) then exit;
        if user.MenuSTATE <> nsBUF then exit;
        if user.SpecialWindow <> WINDOW_ITEMTrade_buf then exit;
        icnt := PCnpc.rnum;
        if icnt <= 0 then exit;
        if icnt > 10000 then
        begin
          TLifeObject(BasicObject).CommandSay('数量太多。');
          exit;
        end;
        //背包中查找
        if User.ViewItem(PCnpc.rItemKey, @ItemData) = false then
        begin
          TLIfeObject(BasicObject).CommandSay('没有此物品');
          exit;
        end;

        if CanBuyItemAllState = false then
        begin
          pitemdata := getBuyName(ItemData.rName);
          if pitemdata = nil then
          begin
            TLIfeObject(BasicObject).CommandSay('不买此物品');
            exit;
          end;
        end;
        if ItemData.rName = INI_GOLD then
        begin
          user.SendClass.SendChatMessage('不收购钱币', SAY_COLOR_SYSTEM);
          EXIT;
        end;
        if ItemData.rboNotTrade = TRUE then
        begin
          user.SendClass.SendChatMessage('无法交换的物品', SAY_COLOR_SYSTEM);
          EXIT;
        end;

        //折价
        iprice := ItemData.rprice;
        if iprice <= 0 then
        begin
          user.SendClass.SendChatMessage('不值钱的物品', SAY_COLOR_SYSTEM);
          EXIT;
        end;
        if (ItemData.rKind <> ITEM_KIND_GOLD_D) and (ItemData.rKind <> ITEM_KIND_GOLD) then
        begin
        //非代替钱币物品 ，50%
          iprice := iprice div 2;
        end;
        //有持久
        if (ItemData.rboDurability) then
        begin
          if (ItemData.rCurDurability <= 0) or (ItemData.rDurability <= 0) then
          begin
            user.SendClass.SendChatMessage('不收没耐久的物品', SAY_COLOR_SYSTEM);
            EXIT;
          end;
          iprice := trunc((ItemData.rCurDurability / ItemData.rDurability) * iprice);
        end;

        if User.ViewItemName(INI_GOLD, @MoneyItemData) = false then
        begin
          //身上无钱币，检查空位置
          if TFieldPhone(BasicObject.Manager.Phone)
            .SendMessage(SenderInfo.id, FM_ENOUGHSPACE, BasicObject.BasicData, SubData) = PROC_FALSE then
          begin
            TLIfeObject(BasicObject).CommandSay('携带的物品太多了。');
            exit;
          end;
        end;
        ItemClass.GetItemData(INI_GOLD, MoneyItemData);
        user.affair(hicaStart);
        // SignToItem(ItemData, BasicObject.Manager.ServerID, BasicObject.BasicData, '');
        SubData.ItemData := ItemData;
        SubData.ItemData.rCount := icnt;
        SubData.delItemKey := PCnpc.rItemKey;
        SubData.delItemcount := icnt;
        if TFieldPhone(BasicObject.Manager.Phone)
          .SendMessage(SenderInfo.id, FM_DELITEM_KEY, BasicObject.BasicData, SubData) = PROC_FALSE then
        begin
          TLIfeObject(BasicObject).CommandSay(format('没有携带%s。',
            [ItemData.rViewName]));
          exit;
        end;

        //User.SendClass.SendNPCItem(I, SubData.ItemData, SubData.ItemData.rCount);

        MoneyItemData.rCount := iprice * icnt;
        // SignToItem(MoneyItemData, BasicObject.Manager.ServerID, BasicObject.BasicData, '');
        SubData.ItemData := MoneyItemData;
        SubData.ServerId := BasicObject.Manager.ServerId;
        if TFieldPhone(BasicObject.Manager.Phone)
          .SendMessage(SenderInfo.id, FM_ADDITEM, BasicObject.BasicData, SubData) = PROC_FALSE then
        begin
          user.affair(hicaRoll_back);
          exit;

        end;

        TLIfeObject(BasicObject).CommandSay(format('买入了%s。',
          [ItemData.rViewName]));

      end;
  end;
  result := true;
end;

function TBuySellSkill.ProcessMessage(aStr: string; SenderInfo: TBasicData):
  Boolean;
var
  i, icnt, ipos, ret: Integer;
  str, sayer, iname, RetStr: string;
  pItemData: PTItemData;
  ItemData, MoneyItemData: TItemData;
  SubData: TSubData;
  User: TUser;
begin
  {   Result := true;

     ret := DivHearing(aStr, sayer, iname, icnt);
     case ret of

         DIVRESULT_HOWMUCH:
             begin
                 ipos := -1;
                 for i := 0 to SellItemList.Count - 1 do
                 begin
                     pitemdata := SellItemList[i];
                     if iname = (pitemdata^.rname) then
                     begin
                         ipos := i;
                         break;
                     end;
                 end;
                 if ipos = -1 then
                 begin
                     TLifeObject(BasicObject).CommandSay(format('没有%s。', [iname]));
                 end else
                 begin
                     ItemClass.GetItemData(iname, ItemData);
                     TLifeObject(BasicObject).CommandSay(format('%s的价格是%d个钱币。', [iname, ItemData.rPrice]));
                 end;
             end;
         DIVRESULT_SELLITEM:
             begin
                 if icnt <= 0 then exit;
                 if icnt > 1000 then
                 begin
                     TLifeObject(BasicObject).CommandSay('数量太多。');
                     exit;
                 end;

                 ipos := -1;
                 for i := 0 to BuyItemList.count - 1 do
                 begin
                     pitemdata := Buyitemlist[i];
                     if iname = (pitemdata^.rname) then
                     begin
                         ipos := i;
                         break;
                     end;
                 end;
                 if ipos = -1 then
                 begin
                     TLIfeObject(BasicObject).CommandSay(format('不买%s。', [iname]));
                     exit;
                 end;
                 if TFieldPhone(BasicObject.Manager.Phone).SendMessage(SenderInfo.id, FM_ENOUGHSPACE, BasicObject.BasicData, SubData) = PROC_FALSE then
                 begin
                     TLIfeObject(BasicObject).CommandSay('携带的物品太多了。');
                     exit;
                 end;

                 ItemClass.GetItemData(INI_GOLD, MoneyItemData);
                 ItemClass.GetItemData(iname, ItemData);

                 SignToItem(ItemData, BasicObject.Manager.ServerID, BasicObject.BasicData, '');
                 SubData.ItemData := ItemData;
                 SubData.ItemData.rCount := icnt;
                 if TFieldPhone(BasicObject.Manager.Phone).SendMessage(SenderInfo.id, FM_DELITEM, BasicObject.BasicData, SubData) = PROC_FALSE then
                 begin
                     TLIfeObject(BasicObject).CommandSay(format('没有携带%s。', [iname]));
                     exit;
                 end;
                 MoneyItemData.rCount := ItemData.rprice * icnt;
                 SignToItem(MoneyItemData, BasicObject.Manager.ServerID, BasicObject.BasicData, '');
                 SubData.ItemData := MoneyItemData;
                 SubData.ServerId := BasicObject.Manager.ServerId;
                 TFieldPhone(BasicObject.Manager.Phone).SendMessage(SenderInfo.id, FM_ADDITEM, BasicObject.BasicData, SubData);
                 TLIfeObject(BasicObject).CommandSay(format('买入了%s。', [iname]));
             end;
         DIVRESULT_BUYITEM:
             begin
                 if icnt <= 0 then exit;
                 if icnt > 1000 then
                 begin
                     TLIfeObject(BasicObject).CommandSay('数量太多。');
                     exit;
                 end;
                 ipos := -1;
                 for i := 0 to SellItemList.count - 1 do
                 begin
                     pitemdata := sellitemlist[i];
                     if iname = (pitemdata^.rname) then
                     begin
                         ipos := i;
                         break;
                     end;
                 end;
                 if ipos = -1 then
                 begin
                     TLIfeObject(BasicObject).CommandSay(format('没有%s。', [iname]));
                     exit;
                 end;

                 ItemClass.GetItemData(INI_GOLD, MoneyItemData);
                 ItemClass.GetItemData(iname, ItemData);

                 if (ItemData.rboDouble = false) and (icnt > 1) then
                 begin
                     TLIfeObject(BasicObject).CommandSay(format('%s只卖一个', [(ItemData.rName)]));
                     exit;
                 end;
                 if TFieldPhone(BasicObject.Manager.Phone).SendMessage(SenderInfo.id, FM_ENOUGHSPACE, BasicObject.BasicData, SubData) = PROC_FALSE then
                 begin
                     TLIfeObject(BasicObject).CommandSay('携带的物品太多了。');
                     exit;
                 end;

                 SignToItem(MoneyItemData, BasicObject.Manager.ServerID, BasicObject.BasicData, '');
                 MoneyItemData.rCount := ItemData.rPrice * icnt;
                 SubData.ItemData := MoneyItemData;
                 if TFieldPhone(BasicObject.Manager.Phone).SendMessage(SenderInfo.id, FM_DELITEM, BasicObject.BasicData, SubData) = PROC_FALSE then
                 begin
                     TLIfeObject(BasicObject).CommandSay('所带的钱太少');
                     exit;
                 end;

                 ItemData.rCount := icnt;
                 NEWItemIDClass.ItemNewId(ItemData)
                 SignToItem(ItemData, BasicObject.Manager.ServerID, BasicObject.BasicData, '');
                 SubData.ItemData := ItemData;
                 SubData.ServerId := BasicObject.Manager.ServerId;
                 TFieldPhone(BasicObject.Manager.Phone).SendMessage(SenderInfo.id, FM_ADDITEM, BasicObject.BasicData, SubData);
                 TLIfeObject(BasicObject).CommandSay(format('卖掉了%s。', [iname]));
             end;
         DIVRESULT_WHATSELL:
             begin
                 str := '';
                 for i := 0 to SellItemList.count - 1 do
                 begin
                     pitemdata := sellitemlist[i];
                     if i < SellItemList.count - 1 then
                         str := str + (pitemdata^.rname) + ','
                     else
                         str := str + (pitemdata^.rname);
                 end;
                 if SellItemList.Count <> 0 then
                     TLIfeObject(BasicObject).CommandSay(format('卖出%s。', [str]))
                 else
                     TLIfeObject(BasicObject).CommandSay('我不卖物品');
             end;
         DIVRESULT_WHATBUY:
             begin
                 str := '';
                 for i := 0 to BuyItemList.count - 1 do
                 begin
                     pitemdata := Buyitemlist[i];
                     if i < BuyItemList.count - 1 then
                         str := str + (pitemdata^.rname) + ','
                     else
                         str := str + (pitemdata^.rname);
                 end;
                 if BuyItemList.Count <> 0 then
                     TLIfeObject(BasicObject).CommandSay(format('买入%s。', [str]))
                 else
                     TLIfeObject(BasicObject).CommandSay('我不买物品');
             end;

     else
         begin
             Result := false;
         end;
     end;
     }
end;

// TSpeechSkill

constructor TSpeechSkill.Create(aBasicObject: TBasicObject);
begin
  BasicObject := aBasicObject;

  SpeechList := TList.Create;
  CurSpeechIndex := 0;
  SpeechTick := 0;
end;

destructor TSpeechSkill.Destroy;
begin
  if SpeechList <> nil then
  begin
    Clear();
    SpeechList.Free;
  end;
end;

procedure TSpeechSkill.Clear;
var
  i: Integer;
begin
  for i := 0 to SpeechList.Count - 1 do
    dispose(SpeechList[i]);
  SpeechList.Clear;
  CurSpeechIndex := 0;
  SpeechTick := 0;
end;

function TSpeechSkill.LoadFromFile(aFileName: string): Boolean;
var
  i: integer;
  SpeechDB: TUserStringDB;
  iname: string;
  pd: PTSpeechData;
begin
  Result := false;

  if aFileName = '' then
    exit;
  if FileExists(aFileName) = FALSE then
    exit;

  Clear;

  SpeechDB := TUserStringDb.Create;
  SpeechDB.LoadFromFile(aFileName);

  for i := 0 to SpeechDB.Count - 1 do
  begin
    iname := SpeechDB.GetIndexName(i);
    if SpeechDB.GetFieldValueBoolean(iname, 'boSelfSay') = TRUE then
    begin
      New(pd);
      FillChar(pd^, sizeof(TSpeechData), 0);
      pd^.rSayString := SpeechDB.GetFieldValueString(iname, 'SayString');
      pd^.rDelayTime := SpeechDB.GetFieldValueInteger(iname, 'DelayTime');
      pd^.rSpeechTick := pd^.rDelayTime;
      SpeechList.Add(pd);
    end;
  end;
  SpeechDB.Free;
end;

procedure TSpeechSkill.ProcessMessage(CurTick: Integer);
var
  pd: PTSpeechData;
begin
  if SpeechList.Count > 0 then
  begin
    pd := SpeechList[CurSpeechIndex];
    if SpeechTick + pd^.rDelayTime < CurTick then
    begin
      TLIfeObject(BasicObject).CommandSay(pd^.rSayString);
      SpeechTick := CurTick;
      if CurSpeechIndex < SpeechList.Count - 1 then
        Inc(CurSpeechIndex)
      else
        CurSpeechIndex := 0;
    end;
  end;
end;

constructor TDeallerSkill.Create(aBasicObject: TBasicObject);
begin
  BasicObject := aBasicObject;
  DataList := TList.Create;
end;

destructor TDeallerSkill.Destroy;
begin
  if DataList <> nil then
  begin
    Clear;
    DataList.Free;
  end;
  inherited Destroy;
end;

procedure TDeallerSkill.Clear;
var
  i: Integer;
begin
  for i := 0 to DataList.Count - 1 do
    dispose(DataList[i]);
  DataList.Clear;
end;

function TDeallerSkill.LoadFromFile(aFileName: string): Boolean;
var
  i, j, iCount: integer;
  DeallerDB: TUserStringDB;
  iname: string;
  pd: PTDeallerData;
  str, mName, mCount: string;
begin
  Result := false;

  if aFileName = '' then
    exit;
  if FileExists(aFileName) = FALSE then
    exit;

  Clear;

  DeallerDB := TUserStringDb.Create;
  DeallerDB.LoadFromFile(aFileName);

  for i := 0 to DeallerDB.Count - 1 do
  begin
    iname := DeallerDB.GetIndexName(i);
    if DeallerDB.GetFieldValueBoolean(iname, 'boSelfSay') <> TRUE then
    begin
      new(pd);
      FillChar(pd^, sizeof(TDeallerData), 0);
      pd^.rHearString := DeallerDB.GetFieldValueString(iname, 'HearString');
      pd^.rSayString := DeallerDB.GetFieldValueString(iname, 'SayString');
      str := DeallerDB.GetFieldValueString(iname, 'NeedItem');
      for j := 0 to 5 - 1 do
      begin
        if str = '' then
          break;
        str := GetValidStr3(str, mName, ':');
        if mName = '' then
          break;
        str := GetValidStr3(str, mCount, ':');
        if mCount = '' then
          break;
        iCount := _StrToInt(mCount);
        if iCount <= 0 then
          iCount := 1;
        pd^.rNeedItem[j].rName := mName;
        pd^.rNeedItem[j].rCount := iCount;
      end;
      str := DeallerDB.GetFieldValueString(iname, 'GiveItem');
      for j := 0 to 5 - 1 do
      begin
        if str = '' then
          break;
        str := GetValidStr3(str, mName, ':');
        if mName = '' then
          break;
        str := GetValidStr3(str, mCount, ':');
        if mCount = '' then
          break;
        iCount := _StrToInt(mCount);
        if iCount <= 0 then
          iCount := 1;
        pd^.rGiveItem[j].rName := mName;
        pd^.rGiveItem[j].rCount := iCount;
      end;
      DataList.Add(pd);
    end;
  end;
  DeallerDB.Free;
  Result := true;
end;

function TDeallerSkill.ProcessMessage(aStr: string; SenderInfo: TBasicData):
  Boolean;
var
  i, j, k: Integer;
  sayer, dummy1, dummy2: string;
  pd: PTDeallerData;
  BO: TBasicObject;
  SubData: TSubData;
  ItemData: TItemData;
begin
  Result := false;

  if DataList.Count <= 0 then
    exit;

  for i := 0 to DataList.Count - 1 do
  begin
    pd := DataList[i];
    if ReverseFormat(astr, '%s: ' + pd^.rHearString, sayer, dummy1, dummy2, 1)
      then
    begin
      BO := TLifeObject(BasicObject).GetViewObjectByID(SenderInfo.id);
      if BO = nil then
        exit;
      if SenderInfo.Feature.rRace <> RACE_HUMAN then
        exit;
      for j := 0 to 5 - 1 do
      begin
        if pd^.rNeedItem[j].rName = '' then
          break;
        ItemClass.GetItemData(pd^.rNeedItem[j].rName, ItemData);
        //                if ItemData.rName[0] <> 0 then
        if ItemData.rName <> '' then
        begin
          ItemData.rCount := pd^.rNeedItem[j].rCount;
          if TUser(BO).FindItem(@ItemData) = false then
          begin
            TUser(BO).SendClass.SendChatMessage(format('%s 物品需要 %d个',
              [(ItemData.rName), ItemData.rCount]), SAY_COLOR_SYSTEM);
            exit;
          end;
        end;
      end;

      BasicObject.BasicData.nx := SenderInfo.x;
      BasicObject.BasicData.ny := SenderInfo.y;
      for j := 0 to 5 - 1 do
      begin
        if pd^.rGiveItem[j].rName = '' then
          break;
        ItemClass.GetItemData(pd^.rGiveItem[j].rName, ItemData);
        ItemData.rCount := pd^.rGiveItem[j].rCount;
        //                ItemData.rOwnerName := '';

        SubData.ItemData := ItemData;
        SubData.ServerId := BasicObject.ServerId;
        if TFieldPhone(BasicObject.Manager.Phone).SendMessage(SenderInfo.id,
          FM_ENOUGHSPACE, BasicObject.BasicData, SubData) = PROC_FALSE then
        begin
          for k := 0 to j - 1 do
          begin
            if pd^.rGiveItem[j].rName = '' then
              break;
            ItemClass.GetItemData(pd^.rGiveItem[j].rName, ItemData);
            ItemData.rCount := pd^.rGiveItem[j].rCount;
            //                        ItemData.rOwnerName := '';
            TUser(BO).DeleteItem(@ItemData);
          end;
          TLIfeObject(BasicObject).CommandSay('物品窗的空间不足');
          exit;
          // TFieldPhone (BasicObject.Phone).SendMessage (MANAGERPHONE, FM_ADDITEM, BasicObject.BasicData, SubData);
        end
        else
        begin
          TFieldPhone(BasicObject.Manager.Phone).SendMessage(SenderInfo.id,
            FM_ADDITEM, BasicObject.BasicData, SubData);
        end;
      end;

      for j := 0 to 5 - 1 do
      begin
        if pd^.rNeedItem[j].rName = '' then
          break;
        ItemClass.GetItemData(pd^.rNeedItem[j].rName, ItemData);
        //                if ItemData.rName[0] <> 0 then
        if ItemData.rName <> '' then
        begin
          ItemData.rCount := pd^.rNeedItem[j].rCount;
          TUser(BO).DeleteItem(@ItemData);
        end;
      end;
      TLIfeObject(BasicObject).CommandSay(pd^.rSayString);

      Result := true;
      exit;
    end;
  end;
end;

constructor TAttackSkill.Create(aBasicObject: TBasicObject);
begin
  BasicObject := aBasicObject;

  if Pointer(BasicObject) = Pointer($150) then
  begin
    BasicObject := nil;
  end;

  GroupBoss := nil;
  ObjectBoss := nil;

  DeadAttackName := '';
  TargetID := 0;
  EscapeID := 0;
  EscapeLife := 0;

  boGroup := false;
  boBoss := false;

  TargetPosTick := -99999;
  CurNearViewObjId := 0;
  HateObjectID := 0;

  boGroupSkill := false;
  GroupSkill := nil;

  boSelfTarget := true;

  BowCount := 5;
  boBowAvail := true;
  BowAvailTick := 0;
  BowAvailInterval := 500;
end;

destructor TAttackSkill.Destroy;
begin
  //自己是 成员，通知主人自己死亡
  GroupSelfDie;
  if ObjectBoss <> nil then
  begin
    ObjectBoss.MemberDie(BasicObject);
  end;

  //自己是主人，通知成员自己死亡
  if GroupSkill <> nil then
  begin
    GroupSkill.BossDie;
    GroupSkill.Free;
    GroupSkill := nil;
    boGroupSkill := false;
  end;

  inherited Destroy;
end;
//本组 一起攻击

procedure TAttackSkill.HelpMe(aMeID, aTargetID, aX, aY: Integer);
begin
  if aTargetID <> 0 then
  begin
    if TargetID <> aTargetID then
    begin
      SetHelpTargetIDandPos(aTargetID, aX, aY);
    end;
    if GroupSkill <> nil then
    begin
      GroupSkill.MoveAttack(aTargetID, aX, aY);
    end
    else
    begin
      GroupSkill := nil;
    end;
  end;
end;
//本组 一起取消攻击

procedure TAttackSkill.CancelHelp(aTargetID: Integer);
begin
  if aTargetID <> 0 then
  begin
    if GroupSkill <> nil then
    begin
      GroupSkill.CancelTarget(aTargetID);
    end
    else
    begin
      GroupSkill := nil;
    end;
  end;
end;

procedure TAttackSkill.SetSelf(aSelf: TBasicObject);
begin
  BasicObject := aSelf;
end;

procedure TAttackSkill.GroupSetBoss(aBoss: TBasicObject);
begin
  GroupBoss := aBoss;
end;

procedure TAttackSkill.SetObjectBoss(aBoss: TDynamicObject);
begin
  ObjectBoss := aBoss;
end;

function TAttackSkill.GetObjectBoss: TDynamicObject;
begin
  Result := ObjectBoss;
end;

procedure TAttackSkill.SetDeadAttackName(aName: string);
begin
  if TLifeObject(BAsicObject).LifeObjectState = los_die then
    exit;

  DeadAttackName := aName;
  TLifeObject(BasicObject).LifeObjectState := los_deadattack;

  {if aName <> '' then
  begin
      TLifeObject(BasicObject).LifeObjectState := los_deadattack;
  end;
  }
end;

procedure TAttackSkill.SetSaveIDandPos(aTargetID: Integer; aTargetX, aTargetY:
  Word; aNextState: TLifeObjectState);
begin
  TargetStartTick := mmAnsTick;

  SaveID := aTargetID;
  TargetX := aTargetX;
  TargetY := aTargetY;

  SaveNextState := aNextState;
end;

procedure TAttackSkill.SetTargetID(aTargetID: Integer; boCaller: Boolean);
var
  SubData: TSubData;
  tmpAttackSkill: TAttackSkill;
  tmpTargetID: Integer;
  BO: TBasicObject;
begin
  if (TLifeObject(BasicObject).LifeObjectState = los_die)
    or (TLifeObject(BasicObject).LifeObjectState = los_init) then
    exit; //自己死亡或者没完成初始化结束

  if TLifeObject(BasicObject).LifeObjectState = los_deadattack then
    exit; //死追杀 模式结束

  if aTargetID = BasicObject.BasicData.id then
    exit; //是自己结束
  if (aTargetID = 0) and (TargetID <> 0) then
  begin
    tmpTargetID := TargetID;
    TargetId := aTargetID;
    if (GroupBoss <> nil) and (boSelfTarget = true) then
    begin
      if GroupBoss.BasicData.Feature.rrace = RACE_NPC then
        // tmpAttackSkill := TNpc(Boss).GetAttackSkill;
        tmpAttackSkill := nil
      else
        tmpAttackSkill := TMonster(GroupBoss).GetAttackSkill;
      if tmpAttackSkill <> nil then
      begin
        tmpAttackSkill.CancelHelp(tmpTargetID); //取消 HELP
      end;
    end;
  end;

  if aTargetID = 0 then
  begin //设置 为0 进入空闲状态
    TargetId := aTargetID;
    TLifeObject(BasicObject).LifeObjectState := los_none;
    exit;
  end;

  boSelfTarget := true; //自己目标状态

  TargetId := aTargetID;
  TLifeObject(BasicObject).LifeObjectState := los_attack;
  if GroupSkill <> nil then //呼叫本组成员一起攻击目标
  begin
    BO := TLifeObject(BasicObject).GetViewObjectByID(TargetID);
    if BO <> nil then
    begin
      GroupSkill.MoveAttack(TargetID, BO.BasicData.X, BO.BasicData.Y);
    end;
  end
  else if GroupBoss <> nil then
  begin //通知BOSS发现新目标；帮BOSS发出HELPME（BOSS没目标情况下）
    if GroupBoss.BasicData.Feature.rRace = RACE_NPC then
      tmpAttackSkill := TNpc(GroupBoss).GetAttackSkill
    else
      tmpAttackSkill := TMonster(GroupBoss).GetAttackSkill;

    if tmpAttackSkill <> nil then
    begin
      if tmpAttackSkill.GetTargetID <> TargetID then
      begin
        BO := TLifeObject(BasicObject).GetViewObjectByID(TargetID);
        if BO <> nil then
        begin
          if BO.BasicData.Feature.rFeatureState = wfs_die then
          begin
            BO := nil;
            exit;
          end;
          if tmpAttackSkill.GroupSkill <> nil then
          begin //通知本组成员 发现目标进行攻击。
            tmpAttackSkill.HelpMe(BasicObject.BasicData.id, TargetID,
              BO.BasicData.x, BO.BasicData.y);
          end
          else
          begin
            BO := nil;
          end;
        end;
      end;
    end;
  end
  else
  begin
    if (boCaller = true) and (boVassal = true) then //发邀请周围怪物联手 群攻目标
    begin
      SubData.TargetId := TargetID;
      SubData.VassalCount := VassalCount; //消息 接收1个，递减1个。
      TLifeObject(BasicObject).SendLocalMessage(NOTARGETPHONE, FM_GATHERVASSAL,
        BasicObject.BasicData, SubData);
    end;
  end;
end;

procedure TAttackSkill.SetHelpTargetID(aTargetID: Integer);
var
  tmpAttackSkill: TAttackSkill;
begin
  if (TLifeObject(BasicObject).LifeObjectState = los_die)
    or (TLifeObject(BasicObject).LifeObjectState = los_init) then
    exit;

  if aTargetID = BasicObject.BasicData.id then
    exit;
  if aTargetID = 0 then
  begin
    if GroupBoss <> nil then
    begin
      if GroupBoss.BasicData.Feature.rrace = RACE_NPC then
        // tmpAttackSkill := TNpc(Boss).GetAttackSkill;
        tmpAttackSkill := nil
      else
        tmpAttackSkill := TMonster(GroupBoss).GetAttackSkill;
      if tmpAttackSkill <> nil then
      begin
        if tmpAttackSkill.GetTargetID <> TargetID then
        begin
          tmpAttackSkill.CancelHelp(TargetID);
        end;
      end;
    end;
    TargetId := aTargetID;
    TLifeObject(BasicObject).LifeObjectState := los_none;
    exit;
  end;

  boSelfTarget := false;

  TargetId := aTargetID;
  TLifeObject(BasicObject).LifeObjectState := los_attack;
  if GroupSkill <> nil then
  begin
    GroupSkill.Attack(TargetID);
  end;
end;
////////////////////////////
//          移动攻击
//说明：奇怪坐标没使用

procedure TAttackSkill.SetHelpTargetIDandPos(aTargetID, aX, aY: Integer);
begin
  if (TLifeObject(BasicObject).LifeObjectState = los_die)
    or (TLifeObject(BasicObject).LifeObjectState = los_init) then
    exit;

  if aTargetID = BasicObject.BasicData.id then
    exit;
  if (aTargetID = 0) or (aTargetID = TargetID) then
    exit;

  boSelfTarget := false;
  TargetId := aTargetID;

  if aTargetID = 0 then
  begin
    TLifeObject(BasicObject).LifeObjectState := los_none;
    exit;
  end;
  TLifeObject(BasicObject).LifeObjectState := los_moveattack;
end;
/////////////////////////////
//        逃跑ID
//说明：以目标ID为 反方向计算出移动目标；进入逃跑状态。

procedure TAttackSkill.SetEscapeID(aEscapeID: Integer);
var
  i, xx, yy, mx, my, len: integer;
  bo: TBasicObject;
begin
  if aEscapeID = BasicObject.BasicData.id then
    exit;
  TargetId := aEscapeID;
  TLifeObject(BasicObject).LifeObjectState := los_escape;

  bo := TBasicObject(TLifeObject(BasicObject).GetViewObjectById(TargetId));
  if bo = nil then
  begin
    TLifeObject(BasicObject).LifeObjectState := los_none
  end
  else
  begin
    mx := BasicObject.BasicData.x;
    my := BasicObject.BasicData.y;
    len := 0;

    for i := 0 to 10 - 1 do
    begin
      xx := BasicObject.BasicData.X - 6 + Random(12);
      yy := BasicObject.BasicData.y - 6 + Random(12);

      if (len < GetLargeLength(bo.PosX, bo.PosY, xx, yy))
        and BasicObject.Maper.isMoveable(xx, yy) then
      begin
        Len := GetLargeLength(bo.PosX, bo.PosY, xx, yy);
        mx := xx;
        my := yy;
      end;
    end;

    if (mx <> BasicObject.BasicData.x) or (my <> BasicObject.BasicData.y) then
    begin
      TargetX := mx;
      TargetY := my;
    end;
  end;
end;

procedure TAttackSkill.SetAttackMagic(aAttackMagic: TMagicData);
begin
  AttackMagic := aAttackMagic;

  if AttackMagic.rMagicType = MAGICTYPE_BOWING then
  begin
    BowCount := 5;
    BowAvailInterval := 500;
  end
  else
  begin
    BowCount := 5;
    BowAvailInterval := 300;
  end;
end;

procedure TAttackSkill.SetSelfTarget(boFlag: Boolean);
begin
  boSelfTarget := boFlag;
end;

procedure TAttackSkill.GroupCreate;
begin
  if GroupSkill = nil then
    GroupSkill := TGroupSkill.Create(BasicObject);
  boGroupSkill := true;
end;

procedure TAttackSkill.GroupDel(aBasicObject: TBasicObject);
begin
  if GroupSkill = nil then
    exit;
  GroupSkill.DeleteMember(aBasicObject);
end;

procedure TAttackSkill.GroupAdd(aBasicObject: TBasicObject);
begin
  if GroupSkill = nil then
    exit;
  GroupSkill.AddMember(aBasicObject);
end;
//////////////////////////////////////////
//            空闲
//说明：设置攻击目标、逃跑攻击目标、移动位置、自己移动。

procedure TAttackSkill.ProcessNone(CurTick: Integer);
var
  nDis: Integer;
  SubData: TSubData;
  ax, ay, atime: integer;
begin
  if DeadAttackName <> '' then
  begin
    TLifeObject(BasicObject).LifeObjectState := los_deadattack;
    exit;
  end;
  if BasicObject.BasicData.Feature.rRace = RACE_NPC then
  begin
    if TargetPosTick + 3000 < CurTick then
    begin
      TargetPosTick := CurTick;
      TargetX := BasicObject.CreateX - TLifeObject(BasicObject).ActionWidth div 2
        + Random(TLifeObject(BasicObject).ActionWidth);
      TargetY := BasicObject.CreateY - TLifeObject(BasicObject).ActionWidth div 2
        + Random(TLifeObject(BasicObject).ActionWidth);
      exit;
    end;

    if TLifeObject(BasicObject).WalkTick + 200 < CurTick then
    begin
      TLifeObject(BasicObject).WalkTick := CurTick;
      {
      nDis := GetLargeLength (BasicObject.BasicData.X, BasicObject.BasicData.Y, TargetX, TargetY);
      if nDis > 10 then
         TLifeObject (BasicObject).GotoXyStandAI (TargetX, TargetY)
      else
      }
      TLifeObject(BasicObject).GotoXyStand(TargetX, TargetY);
    end;
  end
  else
  begin
    if boAttack = false then
    begin //不攻击状态下，仇视和接近人清除掉。
      CurNearViewObjId := 0;
      HateObjectID := 0;
    end;
    ////////////////////////////////////////////////////
    //                 安排攻击目标
    if boAutoAttack //主动 攻击
      and (EscapeLife < TLifeObject(BasicObject).CurLife) //符合逃跑活力要求
      and (CurNearViewObjId <> 0) then //最近人ID<>0
    begin //1，主动攻击状态下，最近人为目标
      SetTargetId(CurNearViewObjId, true);
      CurNearViewObjId := 0;
      exit;
    end;

    if (EscapeLife < TLifeObject(BasicObject).CurLife)
      and (HateObjectID <> 0) then //憎恨 人ID
    begin //2，仇视人为目标
      SetTargetId(HateObjectID, true);
      HateObjectID := 0;
      exit;
    end;
    //逃跑状态
    if (EscapeLife >= TLifeObject(BasicObject).CurLife)
      and (CurNearViewObjId <> 0) then //当前最近 人ID
    begin //3，逃跑状态最近人 ID为目标
      SetEscapeId(CurNearViewObjId);
      CurNearViewObjId := 0;
      exit;
    end;

    if (EscapeLife >= TLifeObject(BasicObject).CurLife)
      and (HateObjectID <> 0) then //4，逃跑状态仇视人为目标
    begin
      SetEscapeId(HateObjectID);
      HateObjectID := 0;
      exit;
    end;
    if (BasicObject.MapPath <> nil) and (GroupBoss = nil) then
    begin
      if (BasicObject.MapPathStep < 20) then
      begin

        if TargetPosTick + 200 < CurTick then
        begin
          TargetPosTick := CurTick;
          if (BasicObject.MapPathStep = -1) or
            (GetLargeLength(BasicObject.BasicData.X, BasicObject.BasicData.Y,
            TargetX, TargetY) <= 3) then
          begin
            if BasicObject.MapPathStep = -1 then
              BasicObject.MapPathStep := 0;
            if BasicObject.MapPath.get(BasicObject.MapPathStep, ax, ay, atime) =
              false then
            begin
              inc(BasicObject.MapPathStep);
              exit;
            end;
            inc(BasicObject.MapPathStep);
            TargetX := ax;
            TargetY := ay;
            exit;
          end;

        end;
      end
      else
      begin

      end;
    end
    else
    begin
      /////////////////////////////////////////////
      //            定时换移动目标
      if BasicObject.BasicData.MasterId = 0 then //有主人的 不移动

        if TargetPosTick + 2000 < CurTick then //20秒1次  换目标位置
        begin
          TargetPosTick := CurTick;

          if GroupBoss <> nil then
          begin //有BOSS主人，以主人 坐标 附近
            TargetX := GroupBoss.BasicData.x - 3 + Random(6);
            TargetY := GroupBoss.BasicData.y - 3 + Random(6);
          end
          else
          begin //自己附近
            TargetX := BasicObject.CreateX - 3 + Random(6);
            TargetY := BasicObject.CreateY - 3 + Random(6);
            //  TargetX := BasicObject.CreateX - TLifeObject(BasicObject).ActionWidth div 2 + Random(TLifeObject(BasicObject).ActionWidth);
             // TargetY := BasicObject.CreateY - TLifeObject(BasicObject).ActionWidth div 2 + Random(TLifeObject(BasicObject).ActionWidth);
          end;
          if TLifeObject(BasicObject).SoundNormal.rWavNumber <> 0 then
            //是否有移动声音
          begin
            //SetWordString(SubData.SayString, IntToStr(TLifeObject(BasicObject).SoundNormal.rWavNumber) + '.wav');
            SubData.sound := TLifeObject(BasicObject).SoundNormal.rWavNumber;
            TLifeObject(BasicObject).SendLocalMessage(NOTARGETPHONE, FM_SOUND,
              BasicObject.BasicData, SubData);
          end;
          exit;
        end;
    end;
    /////////////////////////////////////////////
    //            定时移动1次

    if TLifeObject(BasicObject).WalkTick + TLifeObject(BasicObject).WalkSpeed * 2
      < CurTick then //设置移动 速度的2倍时间，移动1次
    begin
      TLifeObject(BasicObject).WalkTick := CurTick;
      {
      nDis := GetLargeLength (BasicObject.BasicData.X, BasicObject.BasicData.Y, TargetX, TargetY);
      if nDis > 10 then
         TLifeObject (BasicObject).GotoXyStandAI (TargetX, TargetY)
      else
      }
      TLifeObject(BasicObject).GotoXyStand(TargetX, TargetY);
    end;

  end;
end;
/////////////////////////
//          逃跑
//说明：逃跑20秒；恢复到空闲状态。

procedure TAttackSkill.ProcessEscape(CurTick: Integer);
begin
  if BasicObject.BasicData.Feature.rrace = RACE_NPC then
  begin
  end
  else
  begin
    ////////////////////////////////
    //          20秒停止逃跑
    if TargetPosTick + 2000 < CurTick then
    begin
      TargetPosTick := CurTick;
      TLifeObject(BasicObject).LifeObjectState := los_none;
      exit;
    end;

    // if TLifeObject (BasicObject).WalkTick + TLifeObject (BasicObject).WalkSpeed div 2 < CurTick then begin

    if TLifeObject(BasicObject).WalkTick + TLifeObject(BasicObject).WalkSpeed <
      CurTick then
    begin
      TLifeObject(BasicObject).WalkTick := CurTick;
      TLifeObject(BasicObject).GotoXyStand(TargetX, TargetY);
      if (BasicObject.BasicData.x = TargetX) and (BasicObject.BasicData.y =
        TargetY) then
        TLifeObject(BasicObject).LifeObjectState := los_none;
    end;
  end;
end;

procedure TAttackSkill.ProcessFollow(CurTick: Integer);
begin

end;
////////////////////////////////
//           攻击状态
//说明：近身、远程攻击目标到死亡或者消失

function TAttackSkill.ProcessAttack(CurTick: Integer; aBasicObject:
  TBasicObject): Boolean;
var
  bo: TBasicObject;
  key: word;
  boFlag: Boolean;
  nDis: Integer;
  tx, ty: Word;
  xx, yy: Integer;
begin
  Result := true;

  boFlag := false;

  try
    bo := TBasicObject(TLifeObject(BasicObject).GetViewObjectById(TargetId));
    //查找 目标
  except
    bo := nil;
  end;
  /////////////////////////////////////////
  //          目标是否放弃
  if bo = nil then
  begin
    boFlag := true;
  end
  else if bo.BasicData.boNotHit then //目标 不接受攻击
  begin
    boFlag := true;
  end
  else if bo.BasicData.Feature.rRace = RACE_HUMAN then
  begin
    if TUser(bo).GetLifeObjectState = los_die then
      boFlag := true;
  end
  else
  begin
    if TLifeObject(bo).LifeObjectState = los_die then
      boFlag := true; //死亡 放弃目标
  end;
  if (boflag = false) and (bo <> nil) then
  begin
    if bo.BasicData.Feature.rHideState = hs_0 then //隐身状态 放弃目标
    begin
      boFlag := true;
    end;
  end;

  //攻击 模式
  if boFlag = false then
    case aBasicObject.BasicData.HitTargetsType of
      _htt_nation:
        begin
          if bo.BasicData.Feature.rnation =
            aBasicObject.BasicData.Feature.rnation then
            boFlag := true;
        end;
      _htt_Monster:
        begin
          if bo.BasicData.Feature.rRace <> RACE_MONSTER then
            boFlag := true;
        end;
      _htt_Npc:
        begin
          if bo.BasicData.Feature.rRace <> RACE_NPC then
            boFlag := true;
        end;
    end;
  if boFlag = true then
  begin
    if TLifeObject(aBasicObject).FboCopy = false then //自己非复制对象，取消目标
    begin
      SetTargetID(0, true);
      Result := false;
    end;
    exit;
  end;

  if aBasicObject.BasicData.Feature.rRace = RACE_NPC then
  begin
    if GetLargeLength(aBasicObject.BasicData.X, aBasicObject.BasicData.Y,
      bo.PosX, bo.PosY) = 1 then
    begin //测试 距离 方向 进行攻击
      key := GetNextDirection(aBasicObject.BasicData.X,
        aBasicObject.BasicData.Y, bo.PosX, bo.PosY);
      if key = DR_DONTMOVE then
        exit; // 困率捞 0 老锭狼 版快牢单 困率捞 1烙..
      if key <> aBasicObject.BasicData.dir then
      begin
        TLifeObject(aBasicObject).CommandTurn(key);
      end;
      TLifeObject(aBasicObject).CommandHit(CurTick);
    end
    else
    begin //NPC 按照 固定时间移动 追杀 目标
      if TLifeObject(aBasicObject).WalkTick + 50 < CurTick then
      begin
        TLifeObject(aBasicObject).Walktick := CurTick;
        TLifeObject(aBasicObject).GotoXyStand(bo.Posx, bo.Posy);
      end;
    end;
  end
  else
  begin
    if EscapeLife >= TLifeObject(aBasicObject).CurLife then
    begin //逃跑状态
      SetEscapeID(TargetID);
      exit;
    end;

    nDis := GetLargeLength(aBasicObject.BasicData.X, aBasicObject.BasicData.Y,
      bo.PosX, bo.PosY);
    if BasicObject.BasicData.Feature.rMonType = 1 then
    begin
      //人 形怪物
      //远程攻击
      if ((AttackMagic.rMagicType = MAGICTYPE_ONLYBOWING) or
        (AttackMagic.rMagicType = MAGICTYPE_BOWING)) then
      begin
        if (nDis <= 5) then
        begin
          if TLifeObject(aBasicObject).ShootMagic(AttackMagic, bo) = true then
          begin

          end;
        end
        else
        begin
          if TLifeObject(aBasicObject).WalkTick +
            TLifeObject(aBasicObject).WalkSpeed < CurTick then
          begin
            TLifeObject(aBasicObject).WalkTick := CurTick;
            TLifeObject(aBasicObject).GotoXyStand(bo.Posx, bo.Posy);
          end;
        end;
      end
      else
      begin
        //近身攻击
        if nDis = 1 then
        begin
          key := GetNextDirection(aBasicObject.BasicData.X,
            aBasicObject.BasicData.Y, bo.PosX, bo.PosY);
          if key = DR_DONTMOVE then
            exit; // 困率捞 0 老锭狼 版快牢单 困率捞 1烙..
          if key <> aBasicObject.BasicData.dir then
          begin
            TLifeObject(aBasicObject).CommandTurn(key);
          end
          else
          begin
            TLifeObject(aBasicObject).CommandHitHUMAN(CurTick, @AttackMagic)
          end;
        end
        else
        begin
          if TLifeObject(aBasicObject).WalkTick +
            TLifeObject(aBasicObject).WalkSpeed < CurTick then
          begin
            TLifeObject(aBasicObject).WalkTick := CurTick;
            TLifeObject(aBasicObject).GotoXyStand(bo.Posx, bo.Posy);
          end;
        end;

      end;
    end
    else
    begin
      if ((AttackMagic.rMagicType = MAGICTYPE_ONLYBOWING) or
        (AttackMagic.rMagicType = MAGICTYPE_BOWING)) and (boBowAvail = true)
        then
      begin
        //距离在3-5距离，能远程攻击就发起攻击
        if ((BowCount < 3) or ((nDis >= 3) and (nDis <= 5))) or
          (TLifeObject(aBasicObject).ActionWidth = 0) then
        begin
          // if (nDis >= 3) and (nDis <= 5) then begin
            {20090910屏蔽  key := GetNextDirection(aBasicObject.BasicData.X, aBasicObject.BasicData.Y, bo.PosX, bo.PosY);
              if key = DR_DONTMOVE then exit;                             // 困率捞 0 老锭狼 版快牢单 困率捞 1烙..
              if key <> aBasicObject.BasicData.dir then
              begin
                  TLifeObject(aBasicObject).CommandTurn(key);
                  exit;
              end;
             }

          if TLifeObject(aBasicObject).ShootMagic(AttackMagic, bo) = true then
          begin
            Dec(BowCount);
            if BowCount <= 0 then
            begin
              boBowAvail := false;
              case AttackMagic.rMagicType of
                MAGICTYPE_BOWING:
                  begin
                    BowCount := 5;
                    BowAvailTick := CurTick;
                  end;
                MAGICTYPE_ONLYBOWING:
                  begin
                    BowCount := 5;
                    BowAvailTick := CurTick;
                  end;
              end;
            end;
          end;
        end
        else if nDis < 3 then
        begin
          {
          key := GetViewDirection (aBasicObject.BasicData.X, aBasicObject.BasicData.Y, BO.PosX, BO.PosY);
          if key = DR_DONTMOVE then exit; // 困率捞 0 老锭狼 版快牢单 困率捞 1烙..
          if key <> aBasicObject.BasicData.dir then begin
             TLifeObject (aBasicObject).CommandTurn (key);
             exit;
          end;
          }

          //3步内 0间隔时间移动

          if TLifeObject(aBasicObject).WalkTick +
            TLifeObject(aBasicObject).WalkSpeed < CurTick then
          begin
            GetOppositeDirection(aBasicObject.BasicData.X,
              aBasicObject.BasicData.Y, bo.PosX, bo.PosY, tx, ty);
            if not aBasicObject.Maper.isMoveable(tx, ty) then
            begin
              xx := tx;
              yy := ty;
              aBasicObject.Maper.GetNearXy(xx, yy);
              tx := xx;
              ty := yy;
            end;
            TLifeObject(aBasicObject).WalkTick := CurTick;
            if TLifeObject(aBasicObject).GotoXyStand(tx, ty) < 0 then
              TLifeObject(aBasicObject).ShootMagic(AttackMagic, bo);
            //20090928修改 移动失败 攻击目标
          end;

        end
        else
        begin
          if TLifeObject(aBasicObject).WalkTick +
            TLifeObject(aBasicObject).WalkSpeed < CurTick then
          begin
            TLifeObject(aBasicObject).WalkTick := CurTick;
            if TLifeObject(aBasicObject).GotoXyStand(bo.PosX, bo.PosY) < 0 then
              TLifeObject(aBasicObject).ShootMagic(AttackMagic, bo);
            //20090928修改 移动失败 攻击目标
          end;

        end;
      end
      else
      begin
        //近身攻击
        if AttackMagic.rMagicType <> MAGICTYPE_ONLYBOWING then
        begin
          if nDis = 1 then
          begin
            key := GetNextDirection(aBasicObject.BasicData.X,
              aBasicObject.BasicData.Y, bo.PosX, bo.PosY);
            if key = DR_DONTMOVE then
              exit; // 困率捞 0 老锭狼 版快牢单 困率捞 1烙..
            if key <> aBasicObject.BasicData.dir then
            begin
              TLifeObject(aBasicObject).CommandTurn(key);
            end
            else
            begin
              TLifeObject(aBasicObject).CommandHit(CurTick);
            end;
          end
          else
          begin
            if TLifeObject(aBasicObject).WalkTick +
              TLifeObject(aBasicObject).WalkSpeed < CurTick then
            begin
              TLifeObject(aBasicObject).WalkTick := CurTick;
              TLifeObject(aBasicObject).GotoXyStand(bo.Posx, bo.Posy);
            end;
          end;
        end;
        if BowAvailTick + BowAvailInterval < CurTick then
        begin
          boBowAvail := true;
        end;
      end;
    end;

  end;
end;
////////////////////////
//       移动攻击
//说明：发现目标在可视范围， 进入攻击状态；

procedure TAttackSkill.ProcessMoveAttack(Curtick: Integer);
var
  BO: TBasicObject;
begin
  bo := TLifeObject(BasicObject).GetViewObjectById(TargetId);
  if bo <> nil then
  begin
    TLifeObject(BasicObject).LifeObjectState := los_attack;
    exit;
  end;
  if BasicObject.BasicData.Feature.rRace = RACE_NPC then
  begin
    if TLifeObject(BasicObject).WalkTick + 200 < CurTick then
    begin
      TLifeObject(BasicObject).WalkTick := CurTick;
      TLifeObject(BasicObject).GotoXyStand(TargetX, TargetY);
    end;
  end
  else
  begin
    if TLifeObject(BasicObject).WalkTick + TLifeObject(BasicObject).WalkSpeed * 2
      < CurTick then
    begin
      TLifeObject(BasicObject).WalkTick := CurTick;
      TLifeObject(BasicObject).GotoXyStand(TargetX, TargetY);
    end;
  end;
end;
/////////////////////////////////
//           死攻击
//说明：全服琐定追杀目标，目标不在同1地图或者死亡。自己销毁。

procedure TAttackSkill.ProcessDeadAttack(CurTick: Integer);
var
  pUser: TUser;
  key: word;
  boFlag: Boolean;
begin
  boFlag := false;

  pUser := UserList.GetUserPointer(DeadAttackName);
  if pUser = nil then
  begin
    boFlag := true;
  end
  else
  begin
    if pUser.GetLifeObjectState = los_die then
      boFlag := true;
    if pUser.ServerID <> BasicObject.ServerID then
      boFlag := true;
  end;

  if boFlag = true then
  begin
    DeadAttackName := '';
    // TLifeObject (BasicObject).LifeObjectState := los_none;
    TLifeObject(BasicObject).FboAllowDelete := true;
    exit;
  end;

  if GetLargeLength(BasicObject.BasicData.X, BasicObject.BasicData.Y,
    pUser.PosX, pUser.PosY) = 1 then
  begin
    key := GetNextDirection(BasicObject.BasicData.X, BasicObject.BasicData.Y,
      pUser.PosX, pUser.PosY);
    if key = DR_DONTMOVE then
      exit;
    if key <> BasicObject.BasicData.dir then
    begin
      TLifeObject(BasicObject).CommandTurn(key);
    end;
    TLifeObject(BasicObject).CommandHit(CurTick);
  end
  else
  begin
    if TLifeObject(BasicObject).WalkTick + 50 < CurTick then
    begin
      TLifeObject(BasicObject).WalkTick := CurTick;
      {
      if TLifeObject(BasicObject).MaxLife >= 5000 then begin
         TLifeObject(BasicObject).GotoXyStandAI (pUser.PosX, pUser.PosY);
      end else begin
      }
      TLifeObject(BasicObject).GotoXyStand(pUser.PosX, pUser.PosY);
      // end;
    end;
  end;
end;
///////////////////////////////////////////
//                 移动工作
//说明：移动到目标位置，转入预工作

procedure TAttackSkill.ProcessMoveWork(CurTick: Integer);
var
  iLen: Integer;
begin
  // 沥犬洒 格利瘤俊 档馒
  //与目标位置等于或者接近转 预存 状态
  if (BasicObject.BasicData.X = TargetX) and (BasicObject.BasicData.Y = TargetY)
    then
  begin
    TargetArrivalTick := CurTick;
    TLifeObject(BasicObject).LifeObjectState := SaveNextState;
    exit;
  end;
  // 茄伎 裹困 捞郴肺 档馒
  iLen := GetLargeLength(BasicObject.BasicData.X, BasicObject.BasicData.Y,
    TargetX, TargetY);
  if iLen <= 1 then
  begin
    TargetArrivalTick := CurTick;
    TLifeObject(BasicObject).LifeObjectState := SaveNextState;
    exit;
  end;

  //15秒后 有目标转攻击，没目标转空闲
  if CurTick >= TargetStartTick + 1500 then
  begin
    TargetArrivalTick := CurTick;
    if TargetID <> 0 then
      TLifeObject(BasicObject).LifeObjectState := los_attack
    else
      TLifeObject(BasicObject).LifeObjectState := los_none;
    exit;
  end;

  if BasicObject.BasicData.Feature.rRace = RACE_NPC then
  begin
    if TLifeObject(BasicObject).WalkTick + 200 < CurTick then
    begin
      TLifeObject(BasicObject).WalkTick := CurTick;
      TLifeObject(BasicObject).GotoXyStand(TargetX, TargetY);
    end;
  end
  else
  begin
    if TLifeObject(BasicObject).WalkTick + TLifeObject(BasicObject).WalkSpeed <
      CurTick then
    begin
      TLifeObject(BasicObject).WalkTick := CurTick;
      TLifeObject(BasicObject).GotoXyStand(TargetX, TargetY);
    end;
  end;
end;
/////////////////////////////////////
//              移动
//说明：到达目标设置到达时间（TargetArrivalTick）

function TAttackSkill.ProcessMove(CurTick: Integer): Boolean;
begin
  Result := false;

  if (BasicObject.BasicData.X = TargetX) and (BasicObject.BasicData.Y = TargetY)
    then
  begin
    TargetArrivalTick := CurTick;
    Result := true;
    exit;
  end;
  if BasicObject.BasicData.Feature.rRace = RACE_NPC then
  begin
    if TLifeObject(BasicObject).WalkTick + 200 < CurTick then
    begin
      TLifeObject(BasicObject).WalkTick := CurTick;
      TLifeObject(BasicObject).GotoXyStand(TargetX, TargetY);
    end;
  end
  else
  begin
    if TLifeObject(BasicObject).WalkTick + TLifeObject(BasicObject).WalkSpeed <
      CurTick then
    begin
      TLifeObject(BasicObject).WalkTick := CurTick;
      TLifeObject(BasicObject).GotoXyStand(TargetX, TargetY);
    end;
  end;
end;

procedure TAttackSkill.GroupSelfDie;
var
  tmpAttackSkill: TAttackSkill;
begin
  if GroupBoss <> nil then
  begin
    if GroupBoss.BasicData.Feature.rRace = RACE_NPC then
      tmpAttackSkill := TNpc(GroupBoss).GetAttackSkill
    else
      tmpAttackSkill := TMonster(GroupBoss).GetAttackSkill;

    if tmpAttackSkill <> nil then
    begin
      tmpAttackSkill.GroupDel(BasicObject);
    end;
  end;
end;

constructor TGroupSkill.Create(aBasicObject: TBasicObject);
begin
  BasicObject := aBasicObject;
  MemberList := TList.Create;
end;

destructor TGroupSkill.Destroy;
begin
  if MemberList <> nil then
    MemberList.Free;
  inherited Destroy;
end;

procedure TGroupSkill.AddMember(aBasicObject: TBasicObject);
begin
  MemberList.Add(aBasicObject);
end;

procedure TGroupSkill.DeleteMember(aBasicObject: TBasicObject);
var
  i: Integer;
begin
  if aBasicObject = nil then
    exit;
  for i := 0 to MemberList.Count - 1 do
  begin
    if aBasicObject = MemberList[i] then
    begin
      MemberList.Delete(i);
      exit;
    end;
  end;
end;

procedure TGroupSkill.ChangeBoss(aBasicObject: TBasicObject);
var
  i: Integer;
  BO: TBasicObject;
  AttackSkill: TAttackSkill;
begin
  for i := 0 to MemberList.Count - 1 do
  begin
    BO := MemberList.Items[i];
    if BO <> nil then
    begin
      if BO.BasicData.Feature.rRace = RACE_MONSTER then
      begin
        AttackSkill := TMonster(BO).GetAttackSkill;
      end
      else if BO.BasicData.Feature.rRace = RACE_NPC then
      begin
        AttackSkill := TNpc(BO).GetAttackSkill;
      end
      else
      begin
        AttackSkill := nil;
      end;
      if AttackSkill <> nil then
      begin
        AttackSkill.GroupSetBoss(aBasicObject);
      end;
    end;
  end;
end;
/////////////////////////
//       BOSS死亡
//说明：BOSS死亡，清除所有成员 BOSS对象。

procedure TGroupSkill.BossDie;
var
  i: Integer;
  BO: TBasicObject;
  AttackSkill: TAttackSkill;
begin
  for i := 0 to MemberList.Count - 1 do
  begin
    BO := MemberList.Items[i];
    if BO <> nil then
    begin
      if BO.BasicData.Feature.rRace = RACE_MONSTER then
        AttackSkill := TMonster(BO).GetAttackSkill
      else
        AttackSkill := TNpc(BO).GetAttackSkill;

      if AttackSkill <> nil then
      begin
        AttackSkill.GroupSetBoss(nil);
      end;
    end;
  end;
end;

procedure TGroupSkill.FollowMe;
var
  i: Integer;
  BO: TBasicObject;
  AttackSkill: TAttackSkill;
begin
  for i := 0 to MemberList.Count - 1 do
  begin
    BO := MemberList.Items[i];
    if BO <> nil then
    begin
      if BO.BasicData.Feature.rRace = RACE_MONSTER then
        AttackSkill := TMonster(BO).GetAttackSkill
      else
        AttackSkill := TNpc(BO).GetAttackSkill;

      if AttackSkill <> nil then
      begin
        AttackSkill.TargetX := BasicObject.BasicData.x;
        AttackSkill.TargetY := BasicObject.BasicData.y;
      end;
    end;
  end;
end;

procedure TGroupSkill.FollowEachOther;
begin

end;

procedure TGroupSkill.Attack(aTargetID: Integer);
var
  i: Integer;
  BO: TBasicObject;
  AttackSkill: TAttackSkill;
begin
  for i := 0 to MemberList.Count - 1 do
  begin
    BO := MemberList.Items[i];
    if BO <> nil then
    begin
      if BO.BasicData.Feature.rRace = RACE_MONSTER then
        AttackSkill := TMonster(BO).GetAttackSkill
      else
        AttackSkill := TNpc(BO).GetAttackSkill;

      if AttackSkill <> nil then
      begin
        AttackSkill.SetHelpTargetID(aTargetID);
      end;
    end;
  end;
end;

procedure TGroupSkill.MoveAttack(aTargetID, aX, aY: Integer);
var
  i: Integer;
  BO: TBasicObject;
  AttackSkill: TAttackSkill;
begin
  for i := 0 to MemberList.Count - 1 do
  begin
    BO := MemberList.Items[i];
    if BO <> nil then
    begin
      if BO.BasicData.Feature.rRace = RACE_MONSTER then
        AttackSkill := TMonster(BO).GetAttackSkill
      else
        AttackSkill := TNpc(BO).GetAttackSkill;

      if AttackSkill <> nil then
      begin
        AttackSkill.SetHelpTargetIDandPos(aTargetID, aX, aY);
      end;
    end;
  end;
end;

procedure TGroupSkill.CancelTarget(aTargetID: Integer);
var
  i: Integer;
  BO: TBasicObject;
  AttackSkill: TAttackSkill;
begin
  for i := 0 to MemberList.Count - 1 do
  begin
    BO := MemberList.Items[i];
    if BO <> nil then
    begin
      if BO.BasicData.Feature.rRace = RACE_MONSTER then
      begin
        AttackSkill := TMonster(BO).GetAttackSkill;
      end
      else if BO.BasicData.Feature.rRace = RACE_NPC then
      begin
        AttackSkill := TNpc(BO).GetAttackSkill;
      end
      else
      begin
        AttackSkill := nil;
      end;

      if AttackSkill <> nil then
      begin
        if AttackSkill.TargetID = aTargetID then
        begin
          AttackSkill.SetTargetID(0, true);
        end;
      end;
    end;
  end;
end;

end.

