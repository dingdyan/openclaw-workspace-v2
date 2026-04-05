unit uGuildSub;

interface

uses
    Windows, Sysutils, Classes,  Deftype, BasicObj, SvClass,
    SubUtil, uSkills, uLevelExp, uUser, aUtil32, uGramerid, uKeyClass, //AnsUnit,
    FieldMsg, MapUnit;

type

    TGuildsysdata = record
        rlevel, rMaxEnegy, rMaxLife, rMaxNum:integer;
    end;
    pTGuildsysdata = ^TGuildsysdata;
    TGuildsys = class
    private
        DataList:TList;
    public
        function get(alevel:integer):pTGuildsysdata;
        function add(var aitem:TGuildsysdata):boolean;
        procedure Clear();
        constructor Create;
        destructor Destroy; override;
        procedure loadfromFile(afilename:string);
    end;

    TGuildUserList = class
    private
        boChanged:boolean;
        IndexClass:TStringKeyClass;
        DataList:TList;
        autoid:integer;            //人物ID每次进入重新编码, 2009 4 18 日新增加AUOTID 取代原ID
    public
        constructor Create;
        destructor Destroy; override;
        procedure LoadFromFile(aFileName:string);
        procedure SaveToFile(aFileName:string);
        procedure Clear;
        procedure AddUser(id:integer; aUserName:string);
        function DelUser(aUserName:string):Boolean;
        function GetGradeName(aUserName:string):string;
        function Getindex(aindex:integer):PTGuildUserData;
        function GetName(aUserName:string):PTGuildUserData;
        procedure SetGradeName(aUserName, aGradeName:string);
        function IsGuildUser(aUserName:string):Boolean;
        function count():integer;

        property Changed:boolean read boChanged;
    end;

    TGuildNpc = class(TLifeObject)
    private
        pGuildNpcData:PTNpcData;
        TargetPosTick:integer;
        TargetX, TargetY:integer;
        TargetId:integer;
        ParentGuildObject:TBasicObject;

        function IsSysopName(aname:string):boolean;
        procedure SetTargetId(aid:integer);
    protected
        procedure SetNpcAttrib;
    public
        GuildNpcName:string;
        Sex:Byte;
        boMagicNpc:Boolean;
        StartX, StartY:integer;
        RestX, RestY:integer;
        GuildMagicData:TMagicData;

        constructor Create;
        destructor Destroy; override;
        procedure StartProcess; override;
        procedure EndProcess; override;
        function FieldProc(hfu:Longint; Msg:word; var SenderInfo:TBasicData; var aSubData:TSubData):Integer; override;
        procedure Initial(go:TBasicObject; aNpcName:string; ax, ay:integer; aSex:Byte);
        // procedure  SetSysop (aSysop, aSubSysop0, aSubSysop1, aSubSysop2: string);
        procedure Update(CurTick:integer); override;

        procedure MoveGuildNpc(aServerID, ax, ay:integer);
        procedure MoveDieGuildNpc(aServerID, ax, ay:integer);
    end;

implementation

uses
    uGuild, uManager, UserSdb;

/////////////////////////////////
//      Guild User List
/////////////////////////////////

constructor TGuildUserList.Create;
begin

    boChanged := false;
    IndexClass := TStringKeyClass.Create; //('user', 20, TRUE);
    DataList := TList.Create;
end;

destructor TGuildUserList.Destroy;
begin
    Clear;
    DataList.Free;
    IndexClass.Free;
    inherited destroy;
end;

procedure TGuildUserList.Clear;
var
    i               :integer;
begin

    for i := 0 to DataList.Count - 1 do dispose(DataList[i]);
    DataList.Clear;
    IndexClass.Clear;
    autoid := 1;
end;

procedure TGuildUserList.LoadFromFile(aFileName:string);
var
    i               :integer;
    str, rdstr      :string;
    StringList      :TStringList;
    p               :PTGuildUserData;
begin
    Clear;
    if not FileExists(aFileName) then exit;

    StringList := TStringList.Create;
    StringList.LoadFromFile(aFileName);
    for i := 1 to StringList.Count - 1 do
    begin                          // 1何磐绰 霉临捞 鞘靛捞扁锭巩俊..
        str := StringList[i];
        new(p);
        p.rage := 0;
        p.ronline := false;
        p.rjob := 0;
        str := GetValidStr3(str, rdstr, ',');
        p^.rID := autoid;          //_strtoint(rdstr);
        inc(autoid);
        if p^.rId = 0 then p^.rID := 1000 + i;
        str := GetValidStr3(str, rdstr, ',');
        p^.rName := rdstr;
        str := GetValidStr3(str, rdstr, ',');
        p^.rGradeName := rdstr;
        str := GetValidStr3(str, rdstr, ',');
        p^.rLastDay := _StrToInt(rdstr);
        if p^.rLastDay = 0 then p^.rLastDay := GameCurrentDate;

        IndexClass.Insert(p^.rName, p);
        DataList.Add(p);
    end;

    StringList.Free;
end;

procedure TGuildUserList.SaveToFile(aFileName:string);
var
    i               :integer;
    str             :string;
    StringList      :TStringList;
    p               :PTGuildUserData;
begin
    if boChanged = true then
    begin
        StringList := TStringList.Create;
        str := 'id,Name,GradeName,LastDay,';
        StringList.add(str);
        for i := 0 to DataList.Count - 1 do
        begin
            p := DataList[i];
            str := inttostr(p.rid) + ',' + p^.rName + ',' + p^.rGradeName + ',' + IntToStr(p^.rLastDay);
            StringList.Add(str);
        end;
        StringList.SaveToFile(aFileName);
        StringList.Free;
        boChanged := false;
    end;
end;

function TGuildUserList.GetGradeName(aUserName:string):string;
var
    n               :pointer;
begin
    Result := '';
    n := IndexClass.Select(aUserName);
    //   if (n <> 0) and (n <> -1) then
    if n <> nil then
    begin
        PTGuildUserData(n)^.rLastDay := GameCurrentDate;
        Result := PTGuildUserData(n)^.rGradeName;
    end;
end;

function TGuildUserList.Getindex(aindex:integer):PTGuildUserData;
begin
    result := nil;
    if (aindex < 0) or (aindex >= DataList.Count) then exit;
    result := DataList.Items[aindex];
end;

function TGuildUserList.GetName(aUserName:string):PTGuildUserData;
var
    n               :pointer;
begin
    result := nil;
    n := IndexClass.Select(aUserName);
    //if (n <> 0) and (n <> -1) then
    if n <> nil then
    begin
        result := PTGuildUserData(n);
    end;
end;

procedure TGuildUserList.SetGradeName(aUserName, aGradeName:string);
var
    n               :pointer;
begin
    n := IndexClass.Select(aUserName);
    //  if (n <> 0) and (n <> -1) then
    if n <> nil then
    begin
        PTGuildUserData(n)^.rGradeName := aGradeName;
        boChanged := true;
    end;
end;

procedure TGuildUserList.AddUser(id:integer; aUserName:string);
var
    n               :pointer;
    p               :PTGuildUserData;
begin
    n := IndexClass.Select(aUserName);
    //if (n <> 0) and (n <> -1) then
    if n <> nil then
        exit
    else
    begin
        new(p);
        p^.rage := 0;
        p^.ronline := true;
        p^.rjob := 0;
        p^.rid := autoid;
        inc(autoid);
        p^.rName := aUserName;
        p^.rGradeName := '';
        p^.rLastDay := GameCurrentDate;

        DataList.Add(p);
        IndexClass.Insert(aUserName, p);

        boChanged := true;
    end;
end;

function TGuildUserList.count():integer;
begin
    result := DataList.Count;
end;

function TGuildUserList.IsGuildUser(aUserName:string):Boolean;
var
    n               :pointer;
begin
    n := IndexClass.Select(aUserName);
    //if (n <> 0) and (n <> -1) then
    if n <> nil then
        Result := TRUE
    else Result := FALSE;
end;

function TGuildUserList.DelUser(aUserName:string):Boolean;
var
    i               :integer;
    n               :pointer;
begin
    n := IndexClass.Select(aUserName);
    //   if (n <> 0) and (n <> -1) then
    if n <> nil then
    begin
        for i := 0 to DataList.Count - 1 do
        begin
            if aUserName = PTGuildUserData(DataList[i])^.rname then
            begin
                dispose(DataList[i]);
                DataList.Delete(i);
                IndexClass.Delete(aUserName);
                boChanged := true;
                break;
            end;
        end;
        Result := TRUE;
    end else Result := FALSE;
end;

///////////////////////////////////////////

/////////////////////////////////////
//       Npc
////////////////////////////////////

constructor TGuildNpc.Create;
begin
    inherited Create;
    pGuildNpcData := nil;
    Sex := 1;
end;

destructor TGuildNpc.Destroy;
begin
    pGuildNpcData := nil;
    inherited destroy;
end;

procedure TGuildNpc.SetTargetId(aid:integer);
begin
    if aid = BasicData.id then exit;
    TargetId := aid;

    if TargetID <> 0 then LifeObjectState := los_attack
    else LifeObjectState := los_none;
end;

procedure TGuildNpc.SetNpcAttrib;
begin
    if pGuildNpcData = nil then exit;

    LifeData.damagebody := LifeData.damagebody + pGuildNpcData^.rDamage;
    LifeData.damagehead := LifeData.damagehead + 0;
    LifeData.damagearm := LifeData.damagearm + 0;
    LifeData.damageleg := LifeData.damageleg + 0;
    LifeData.AttackSpeed := LifeData.AttackSpeed + pGuildNpcData^.rAttackSpeed;
    LifeData.avoid := LifeData.avoid + pGuildNpcData^.ravoid;
    LifeData.recovery := LifeData.recovery + pGuildNpcData^.rrecovery;
    LifeData.armorbody := LifeData.armorbody + pGuildNpcData^.rarmor;
    LifeData.armorhead := LifeData.armorhead + pGuildNpcData^.rarmor;
    LifeData.armorarm := LifeData.armorarm + pGuildNpcData^.rarmor;
    LifeData.armorleg := LifeData.armorleg + pGuildNpcData^.rarmor;

    BasicData.Feature.raninumber := pGuildNpcData^.rAnimate;
    BasicData.Feature.rImageNumber := pGuildNpcData^.rShape;

    MaxLife := pGuildNpcData^.rLife;

    SoundNormal := pGuildNpcData^.rSoundNormal;
    SoundAttack := pGuildNpcData^.rSoundAttack;
    SoundDie := pGuildNpcData^.rSoundDie;
    SoundStructed := pGuildNpcData^.rSoundStructed;
end;

{
procedure  TGuildNpc.SetSysop (aSysop, aSubSysop0, aSubSysop1, aSubSysop2: string);
begin
   SysopName := aSysop;
   SubSysopName0 := aSubSysop0;
   SubSysopName1 := aSubSysop1;
   SubSysopName2 := aSubSysop2;
end;
}

function TGuildNpc.IsSysopName(aname:string):boolean;
var
    i               :Integer;
    pd              :PTCreateGuildData;
begin
    Result := TRUE;
    if ParentGuildObject <> nil then
    begin
        pd := TGuildObject(ParentGuildObject).GetSelfData;
        if pd^.Sysop = aname then exit;
        for i := 0 to MAX_SUBSYSOP_COUNT - 1 do
        begin
            if pd^.SubSysop[i] = aname then exit;
        end;
    end;

    Result := FALSE;
end;

procedure TGuildNpc.Initial(go:TBasicObject; aNpcName:string; ax, ay:integer; aSex:Byte);
begin
    inherited Initial(aNpcName, aNpcName);

    GuildNpcName := aNpcName;
    Sex := aSex;

    boMagicNpc := FALSE;
    FillChar(GuildMagicData, sizeof(TMagicData), 0);

    ParentGuildObject := go;

    if Sex = 2 then
    begin
        NpcClass.GetNpcData(INI_GUILD_NPCWOMAN_NAME, pGuildNpcData);
    end else
    begin
        NpcClass.GetNpcData(INI_GUILD_NPCMAN_NAME, pGuildNpcData);
    end;

    Basicdata.id := GetNewMonsterId;
    BasicData.x := ax;
    BasicData.y := ay;
    BasicData.dir := DR_4;
    BasicData.ClassKind := CLASS_GUILDNPC;
    BasicData.Feature.rrace := RACE_NPC;
    BasicData.Name := aNpcName;
    BasicData.ViewName := aNpcName;
    BasicData.BasicObjectType := boGuildNpc;
    SetNpcAttrib;

    TargetId := 0;
    TargetPosTick := 0;

    // 2000.09.16 TargetX, TargetY 啊 瘤沥登瘤 臼酒 辑滚啊 矫累等 饶 NPC甸狼
    // 悼累捞 裙老利栏肺 合辑率阑 氢茄促. 檬扁 困摹甫 持绢霖促 by Lee.S.G
    TargetX := aX;
    TargetY := aY;
    RestX := aX;
    RestY := aY;
    StartX := aX;
    StartY := aY;

    SetScript(pGuildNpcData.rScripter, format('.\%s\%s\%s.pas', ['Script', 'Npc', pGuildNpcData.rScripter]));
end;

procedure TGuildNpc.StartProcess;
var
    SubData         :TSubData;
begin
    inherited StartProcess;

    CurLife := MaxLife;

    BasicData.Feature.rhitmotion := AM_HIT1;
    TFieldPhone(Manager.Phone).RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
    TFieldPhone(Manager.Phone).SendMessage(0, FM_CREATE, BasicData, SubData);
end;

procedure TGuildNpc.EndProcess;
var
    SubData         :TSubData;
begin
    if FboRegisted = FALSE then exit;

    TFieldPhone(Manager.Phone).SendMessage(0, FM_DESTROY, BasicData, SubData);
    TFieldPhone(Manager.Phone).UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);
    inherited EndProcess;
end;

procedure TGuildNpc.MoveGuildNpc(aServerID, ax, ay:integer);
var
    tmpManager      :TManager;
    SubData         :TSubData;
    nX, nY          :Integer;
begin
    tmpManager := ManagerList.GetManagerByServerID(aServerID);

    TFieldPhone(Manager.Phone).SendMessage(NOTARGETPHONE, FM_DESTROY, BasicData, SubData);
    TFieldPhone(Manager.Phone).UnRegisterUser(BasicData.id, BasicData.x, BasicData.y);

    nX := aX;
    nY := aY;
    TMaper(tmpManager.Maper).GetNearXY(nX, nY);
    StartX := nX;
    StartY := nY;
    TargetX := nX;
    TargetY := nY;
    RestX := nX;
    RestY := nY;
    BasicData.x := nX;
    BasicData.y := nY;

    SetManagerClass(tmpManager);

    TFieldPhone(Manager.Phone).RegisterUser(BasicData.id, FieldProc, BasicData.X, BasicData.Y);
    TFieldPhone(Manager.Phone).SendMessage(NOTARGETPHONE, FM_CREATE, BasicData, SubData);
end;

procedure TGuildNpc.MoveDieGuildNpc(aServerID, ax, ay:integer);
var
    tmpManager      :TManager;
    nX, nY          :Integer;
begin
    tmpManager := ManagerList.GetManagerByServerID(aServerID);

    nX := aX;
    nY := aY;
    TMaper(tmpManager.Maper).GetNearXY(nX, nY);
    StartX := nX;
    StartY := nY;
    TargetX := nX;
    TargetY := nY;
    RestX := nX;
    RestY := nY;
    BasicData.x := nX;
    BasicData.y := nY;

    SetManagerClass(tmpManager);
end;

function AddPermitExp(var aLevel, aExp:integer; addvalue:integer):integer;
var
    n               :integer;
begin
    n := GetLevelMaxExp(aLevel) * 3;
    if n > addvalue then n := addvalue;
    inc(aExp, n);
    aLevel := GetLevel(aExp);
    Result := n;
end;

function TGuildNpc.FieldProc(hfu:Longint; Msg:word; var SenderInfo:TBasicData; var aSubData:TSubData):Integer;
var
    i               :integer;
    str, boname     :string;
    sayer, objectname, gradename:string;
    Bo              :TBasicObject;
    MagicData       :TMagicData;
    OldSkillLevel   :Integer;
begin
    Result := PROC_FALSE;
    if isRangeMessage(hfu, Msg, SenderInfo) = FALSE then exit;
    Result := inherited FieldProc(hfu, Msg, Senderinfo, aSubData);
    if Result = PROC_TRUE then exit;
    case Msg of
        FM_ADDITEM:
            begin
                exit;
                {
                Bo := GetViewObjectByid (SenderInfo.id);
                if Bo = nil then exit;
                if not (Bo is TUSER) then exit;
                boname := TUser (Bo).Name;
                IsSysopName(boname);
                }
            end;
        FM_ADDATTACKEXP:
            begin
                if boMagicNpc then
                begin
                    OldSkillLevel := GuildMagicData.rcSkillLevel;
                    AddPermitExp(GuildMagicData.rcSkillLevel, GuildMagicData.rSkillExp, aSubData.ExpData.Exp);
                    if OldSkillLevel <> GuildMagicData.rcSkillLevel then
                    begin
                        if (GuildMagicData.rcSkillLevel mod 10) = 0 then
                        begin
                            {
                            if GuildMagicData.rcSkillLevel >= 5000 then begin
                               BocSay ( Get10000To100 (GuildMagicData.rcSkillLevel) );
                            end else begin
                               BocSay ( Get10000To100 (GuildMagicData.rcSkillLevel) );
                            end;
                            }
                            BocSay(Get10000To100(GuildMagicData.rcSkillLevel));
                        end;
                    end;
                end;
            end;
        FM_SHOW:
            begin
            end;
        FM_CHANGEFEATURE:
            begin
                if (SenderInfo.id = TargetId) and (SenderInfo.Feature.rFeatureState = wfs_die) then SetTargetId(0);
            end;
        FM_GUILDATTACK:
            begin
                if CurLife <= 0 then exit;

                if aSubData.TargetID = 0 then
                begin
                    SetTargetID(aSubData.TargetID);
                    exit;
                end;

                if LifeObjectState = los_attack then exit;

                Result := PROC_FALSE;
                if aSubData.TargetId <> 0 then
                begin
                    // 2000.10.04 巩林唱 何巩林绰 傍拜窍瘤 臼档废 荐沥 by Lee.S.G
                    Bo := GetViewObjectByID(aSubData.TargetId);
                    if Bo = nil then exit;
                    if Bo is TGuildNpc then
                    begin
                        if TGuildObject(ParentGuildObject).GuildName <> TGuildObject(TGuildNpc(Bo).ParentGuildObject).GuildName then
                        begin
                            SetTargetId(aSubData.TargetId);
                        end;
                    end
                    else
                    begin
                        if Bo is TUser then
                        begin
                            boname := TUser(Bo).Name;
                            if IsSysopName(boname) = FALSE then
                            begin
                                SetTargetId(aSubData.TargetId);
                            end;
                        end else
                        begin
                            SetTargetId(aSubData.TargetId);
                        end;
                    end;
                    Result := PROC_TRUE;
                end;
            end;
        FM_STRUCTED:
            begin
                if (SenderInfo.id = BasicData.id) then
                begin
                    if CurLife <= 0 then
                    begin
                        SetTargetId(0);
                        // CommandChangeCharState (wfs_die);
                        exit;
                    end;
                    if pGuildNpcData^.rboProtecter then
                    begin
                        // 2000.10.04 巩林唱 何巩林绰 傍拜窍瘤 臼档废 荐沥 by Lee.S.G
                        Bo := GetViewObjectByID(aSubData.Attacker);
                        if Bo = nil then exit;
                        if Bo is TGuildNpc then
                        begin
                            if TGuildObject(ParentGuildObject).GuildName <> TGuildObject(TGuildNpc(Bo).ParentGuildObject).GuildName then
                            begin
                                SetTargetId(aSubData.attacker);
                            end;
                        end
                        else
                        begin
                            if Bo is TUser then
                            begin
                                {
                                boname := TUser (Bo).Name;
                                if IsSysopName(boname) = TRUE then begin
                                   // 巩颇包府磊俊霸 嘎疽阑锭俊绰 泪矫 巩林狼 馆措规氢栏肺 雀乔
                                   if (BasicData.X < TUser(Bo).BasicData.X) and (BasicData.Y < TUser(Bo).BasicData.Y) then begin
                                      TargetX := BasicData.X - 6; TargetY := BasicData.Y - 6;
                                   end else if (BasicData.X = TUser(Bo).BasicData.X) and (BasicData.Y < TUser(Bo).BasicData.Y) then begin
                                      TargetX := BasicData.X + 0; TargetY := BasicData.Y - 6;
                                   end else if (BasicData.X > TUser(Bo).BasicData.X) and (BasicData.Y < TUser(Bo).BasicData.Y) then begin
                                      TargetX := BasicData.X + 6; TargetY := BasicData.Y - 6;
                                   end else if (BasicData.X > TUser(Bo).BasicData.X) and (BasicData.Y = TUser(Bo).BasicData.Y) then begin
                                      TargetX := BasicData.X + 6; TargetY := BasicData.Y + 0;
                                   end else if (BasicData.X > TUser(Bo).BasicData.X) and (BasicData.Y > TUser(Bo).BasicData.Y) then begin
                                      TargetX := BasicData.X + 6; TargetY := BasicData.Y + 6;
                                   end else if (BasicData.X = TUser(Bo).BasicData.X) and (BasicData.Y > TUser(Bo).BasicData.Y) then begin
                                      TargetX := BasicData.X + 0; TargetY := BasicData.Y + 6;
                                   end else if (BasicData.X < TUser(Bo).BasicData.X) and (BasicData.Y > TUser(Bo).BasicData.Y) then begin
                                      TargetX := BasicData.X - 6; TargetY := BasicData.Y + 6;
                                   end else if (BasicData.X < TUser(Bo).BasicData.X) and (BasicData.Y = TUser(Bo).BasicData.Y) then begin
                                      TargetX := BasicData.X - 6; TargetY := BasicData.Y + 0;
                                   end;
                                   LifeObjectState := los_rest;
                                end else begin
                                   SetTargetId (aSubData.attacker);
                                end;
                                }
                                SetTargetId(aSubData.attacker);
                            end else
                            begin
                                SetTargetId(aSubData.attacker);
                            end;
                        end;
                    end;
                end;
            end;
        FM_DEADHIT:                //GM指令 @爆
            begin
                CurLife := 0;
                CommandChangeCharState(wfs_die);
            end;
        FM_SAY:
            begin
                if FboAllowDelete then exit;
                if SenderInfo.id = BasicData.id then exit;
                if TargetId <> 0 then
                begin
                    if (TargetID <> TGuildObject(ParentGuildObject).BasicData.ID) and
                        (LifeObjectState = los_attack) then exit;
                end;

                if LifeObjectState = los_escape then exit;

                str := GetWordString(aSubData.SayString);
                if ReverseFormat(str, '%s: ', sayer, objectname, gradename, 1) then
                begin
                    if (IsSysopName(sayer) = FALSE) and (SysopClass.GetSysopScope(sayer) < 100) then
                    begin
                        exit;
                    end;
                end;

                if ReverseFormat(str, '%s: 将门派武功传授给%s', sayer, objectname, gradename, 2) then
                begin
                    if boMagicNpc then
                    begin
                        Bo := GetViewObjectByName(objectname, RACE_HUMAN);
                        if Bo = nil then
                        begin
                            BocSay(format('%s不在。', [objectname]));
                            exit;
                        end;
                        if not (Bo is TUser) then
                        begin
                            BocSay(format('%s不是使用者。', [objectname]));
                            exit;
                        end;
                        if TUser(Bo).GuildName = '' then
                        begin
                            BocSay('不是门派成员');
                            exit;
                        end;
                        if TUser(Bo).GuildName <> TGuildObject(ParentGuildObject).GuildName then
                        begin
                            BocSay(format('%s是别的门派。', [objectname]));
                            exit;
                        end;
                        if (GuildMagicData.rName) = '' then
                        begin
                            BocSay('没有门派武功。');
                            exit;
                        end;
                        CallScriptFunction('OnGuildImpartMagic', [integer(SenderInfo.p), integer(Bo), integer(self)])
                        {
                            // 2000.09.18 NPC狼 捞抚苞 User狼 捞抚捞 鞍阑锭 八祸坷幅滚弊 荐沥 by Lee.S.G
                            // 巩颇公傍 傈荐绰 RACE_HUMAN俊辑父 蜡瓤窍促

                            if GuildMagicData.rcSkillLevel < 5000 then
                            begin
                                BocSay('门派武功修练度不足。');
                                exit;
                            end;
                            MagicClass.GetMagicData((GuildMagicData.rName), MagicData, 0);
                            if TUser(Bo).AddMagic(@MagicData) then
                            begin
                                BocSay('将门派武功传授了。');
                                GuildMagicData.rSkillExp := 0;
                                GuildMagicData.rcSkillLevel := GetLevel(GuildMagicData.rSkillExp);
                            end else BocSay('门派武功传授失败。');
                            }
                    end;
                    exit;
                end;

                if ReverseFormat(str, '%s: %s的名字是%s', sayer, objectname, gradename, 3) then
                begin
                    // objectname := copy (objectname, 1, Length(objectname)-2);
                    if objectname = GuildNpcName then
                    begin
                        for i := 0 to MAX_GUILDNPC_COUNT - 1 do
                        begin
                            if TGuildObject(ParentGuildObject).IsGuildNpc(gradename) then
                            begin
                                BocSay('同样的名字已存在。');
                                exit;
                            end;
                        end;

                        if (not isFullHangul(gradename)) then//or (not isGrammarID(gradename)) then
                        begin
                            BocSay('名字错误。');
                            exit;
                        end;
                        if (Length(gradename) <= 1) or (Length(gradename) > 10) then
                        begin
                            BocSay('名字错误。');
                            exit;
                        end;

                        TGuildObject(ParentGuildObject).ChangeGuildNpcName(GuildNpcName, GradeName);

                        BasicData.Name := gradename;
                        BasicData.ViewName := gradename;
                        GuildNpcName := GradeName;
                        BocChangeProperty;
                        BocSay(format('我的名字成了 %s。', [GuildNpcName]));
                        exit;
                    end;
                    exit;
                end;

                if ReverseFormat(str, '%s: %s的位置是这里', sayer, objectname, gradename, 2) then
                begin
                    // objectname := copy (objectname, 1, Length(objectname)-2);
                    if objectname = GuildNpcName then
                    begin
                        if not TMaper(Manager.Maper).isObjectArea(BasicData.x, BasicData.y) then
                        begin
                            StartX := BasicData.x;
                            StartY := BasicData.y;
                            BocSay('我从这里开始。');
                        end else
                        begin
                            BocSay('无法将位置指定于此');
                        end;
                    end;
                    exit;
                end;
                if ReverseFormat(str, '%s: %s跟着来', sayer, objectname, gradename, 2) or
                    ReverseFormat(str, '%s: %s跟着来', sayer, objectname, gradename, 2) then
                begin
                    // objectname := copy (objectname, 1, Length(objectname)-2);
                    if objectname = GuildNpcName then
                    begin
                        if BasicData.Feature.rfeaturestate = wfs_sitdown then
                        begin
                            BasicData.Feature.rfeaturestate := wfs_normal;
                            BocChangeFeature;
                        end;

                        TargetId := SenderInfo.id;
                        LifeObjectState := los_follow;
                    end;
                    exit;
                end;
                if ReverseFormat(str, '%s: %s停止了', sayer, objectname, gradename, 2) or
                    ReverseFormat(str, '%s: %s停止了', sayer, objectname, gradename, 2) then
                begin
                    // objectname := copy (objectname, 1, Length(objectname)-2);
                    if objectname = GuildNpcName then LifeObjectState := los_stop;
                    exit;
                end;
                // 2000.09.16 巩颇器凉俊 措茄 老绢急促,旧绰促狼 悼累 昏力 by Lee.S.G
                {
                // if ReverseFormat (str, '%s: %s 老绢急促', sayer, objectname, gradename, 2) then begin
                   objectname := copy (objectname, 1, Length(objectname)-2);
                   if objectname = GuildNpcName then begin
                      if BasicData.Feature.rfeaturestate = wfs_sitdown then begin
                         BasicData.Feature.rfeaturestate := wfs_normal;
                         BocChangeFeature;
                      end;
                   end;
                end;
                // if ReverseFormat (str, '%s: %s 旧绰促', sayer, objectname, gradename, 2) then begin
                   objectname := copy (objectname, 1, Length(objectname)-2);
                   if objectname = GuildNpcName then begin
                      if BasicData.Feature.rfeaturestate = wfs_normal then begin
                         BasicData.Feature.rfeaturestate := wfs_sitdown;
                         BocChangeFeature;
                         LifeObjectState := los_stop;
                      end;
                   end;
                end;
                }
                if ReverseFormat(str, '%s: %s休息', sayer, objectname, gradename, 2) or
                    ReverseFormat(str, '%s: %s休息', sayer, objectname, gradename, 2) then
                begin
                    // objectname := copy (objectname, 1, Length(objectname)-2);
                    if objectname = GuildNpcName then
                    begin
                        if BasicData.Feature.rfeaturestate = wfs_sitdown then
                        begin
                            BasicData.Feature.rfeaturestate := wfs_normal;
                            BocChangeFeature;
                        end;

                        RestX := BasicData.x;
                        RestY := BasicData.y;
                        LifeObjectState := los_rest;
                        BocSay('我在这里休息。');
                    end;
                    exit;
                end;
            end;
    end;
end;

procedure TGuildNpc.Update(CurTick:integer);
var
    key             :word;
    Bo              :TBasicObject;
    //    i               :integer;
begin
    inherited UpDate(CurTick);

    if (BasicData.Feature.rFeatureState = wfs_die) and (CurTick > DiedTick + 1600) then
    begin
        FboAllowDelete := TRUE;
        exit;
    end;

    case LifeObjectState of
        los_none:
            begin
                if TargetPosTick + 3000 < CurTick then
                begin
                    TargetPosTick := Curtick;
                    TargetX := RestX - pGuildNpcData^.rActionWidth div 2 + Random(pGuildNpcData^.rActionWidth);
                    TargetY := RestY - pGuildNpcData^.rActionWidth div 2 + Random(pGuildNpcData^.rActionWidth);
                    exit;
                end;

                if WalkTick + 200 < CurTick then
                begin
                    Walktick := CurTick;
                    GotoXyStand(TargetX, TargetY);
                end;
            end;
        los_die:;
        los_follow:
            begin
                bo := TBasicObject(GetViewObjectById(TargetId));
                if bo = nil then LifeObjectState := los_none
                else
                begin
                    if GetLargeLength(BasicData.X, BasicData.Y, bo.PosX, bo.PosY) <= 2 then exit;

                    if WalkTick + 60 < CurTick then
                    begin
                        Walktick := CurTick;
                        GotoXyStand(bo.Posx, bo.Posy);
                    end;
                end;
            end;
        los_stop:
            begin
            end;
        los_rest:
            begin
                if TargetPosTick + 3000 < CurTick then
                begin
                    TargetPosTick := Curtick;
                    TargetX := RestX - pGuildNpcData^.rActionWidth div 2 + Random(pGuildNpcData^.rActionWidth);
                    TargetY := RestY - pGuildNpcData^.rActionWidth div 2 + Random(pGuildNpcData^.rActionWidth);
                    exit;
                end;

                if WalkTick + 200 < CurTick then
                begin
                    Walktick := CurTick;
                    GotoXyStand(TargetX, TargetY);
                end;
            end;
        los_attack:
            begin
                bo := TBasicObject(GetViewObjectById(TargetId));
                if bo = nil then LifeObjectState := los_none
                else
                begin
                    if GetLargeLength(BasicData.X, BasicData.Y, bo.PosX, bo.PosY) = 1 then
                    begin
                        key := GetNextDirection(BasicData.X, BasicData.Y, bo.PosX, bo.PosY);
                        if key = DR_DONTMOVE then exit; // 困率捞 0 老锭狼 版快牢单 困率捞 1烙..
                        if key <> BasicData.dir then CommandTurn(key);
                        CommandHit(CurTick);
                    end else
                    begin
                        if WalkTick + 35 < CurTick then
                        begin
                            Walktick := CurTick;

                            GotoXyStand(bo.Posx, bo.Posy);
                        end;
                    end;
                end;
            end;
    end;
end;
/////////////////////////////////////////////////
//                TGuildsys
////////////////////////////////////////////////

constructor TGuildsys.Create;
begin
    DataList := TList.Create;
    loadfromFile('.\guild\guildsys.sdb');
end;

procedure TGuildsys.loadfromFile(afilename:string);
var
    DB              :TUserStringDb;
    i               :integer;
    iName           :string;
    aitem           :TGuildsysdata;
begin
    if not FileExists(aFileName) then exit;
    DB := TUserStringDb.Create;

    try
        DB.LoadFromFile(aFileName);
        for i := 0 to Db.Count - 1 do
        begin
            iName := Db.GetIndexName(i);
            if iName = '' then continue;
            aitem.rlevel := db.GetFieldValueInteger(iName, 'level');
            aitem.rMaxEnegy := db.GetFieldValueInteger(iName, 'MaxEnegy');
            aitem.rMaxLife := db.GetFieldValueInteger(iName, 'MaxLife');
            aitem.rMaxNum := db.GetFieldValueInteger(iName, 'MaxNum');
            add(aitem);
        end;
    finally
        db.Free;
    end;

end;

function TGuildsys.get(alevel:integer):pTGuildsysdata;
var
    i               :integer;
    pp              :pTGuildsysdata;
begin
    result := nil;
    for i := 0 to DataList.Count - 1 do
    begin
        pp := DataList.Items[i];
        if pp.rlevel = alevel then
        begin
            result := pp;
            exit;
        end;
    end;

end;

function TGuildsys.add(var aitem:TGuildsysdata):boolean;
var
    pp              :pTGuildsysdata;
begin
    result := false;
    if get(aitem.rlevel) <> nil then exit;
    new(pp);
    pp^ := aitem;
    DataList.Add(pp);
    result := true;
end;

procedure TGuildsys.Clear();
var
    i               :integer;
    pp              :pTGuildsysdata;
begin
    for i := 0 to DataList.Count - 1 do
    begin
        pp := DataList.Items[i];
        dispose(pp);
    end;
    DataList.Clear;
end;

destructor TGuildsys.Destroy;
begin
    Clear;
    DataList.Free;
    inherited destroy;
end;

end.

