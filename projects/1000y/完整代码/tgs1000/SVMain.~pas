unit SVMain;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, inifiles, ExtCtrls,
    uAnsTick, uUser, uconnect, mapunit, fieldmsg, ulevelexp, deftype,
    svClass, basicobj, uMonster, uNpc, aUtil32, Spin, uGuild, Menus, ComCtrls,
    uLetter, uManager, uDoorGen, uhailfellow;

type

    TFrmMain = class(TForm)
        TimerProcess: TTimer;
        TimerDisplay: TTimer;
        TimerSave: TTimer;
        TimerClose: TTimer;
        SEProcessListCount: TSpinEdit;
        MainMenu1: TMainMenu;
        Files1: TMenuItem;
        Save1: TMenuItem;
        Exit1: TMenuItem;
        Env1: TMenuItem;
        LoadBadIpAndNotice1: TMenuItem;
        StatusBar1: TStatusBar;
        TimerRain: TTimer;
        MRain: TMenuItem;
        TimerRainning: TTimer;
        MConnection: TMenuItem;
        MDrop100: TMenuItem;
        MView: TMenuItem;
        MGate: TMenuItem;
        chkSaveUserData: TCheckBox;
        chkWeather: TCheckBox;
        MDelGuild: TMenuItem;
        Label1: TLabel;
        GroupBox_MAP: TGroupBox;
        SESelServer: TSpinEdit;
        Label2: TLabel;
        LbMonster: TLabel;
        GroupBox2: TGroupBox;
        LbConnection: TLabel;
        LbUser: TLabel;
        LbNpc: TLabel;
        LbItem: TLabel;
        LbProcess: TLabel;
        Label3: TLabel;
        Label4: TLabel;
        Label5: TLabel;
        Label6: TLabel;
        Log1: TMenuItem;
        SpinEditMoveTime: TSpinEdit;
        Label7: TLabel;
        ListBoxEvent: TListBox;
        SpinEditMaxExp: TSpinEdit;
        SpinEditAttackMagic: TSpinEdit;
        SpinEditBreathngMagic: TSpinEdit;
        Label8: TLabel;
        Label9: TLabel;
        Label10: TLabel;
        SpinEditRunningMagic: TSpinEdit;
        SpinEditProtectingMagic: TSpinEdit;
        SpinEditEctMagic: TSpinEdit;
        Label11: TLabel;
        Label12: TLabel;
        Label13: TLabel;
        SEProcessListUserCount: TSpinEdit;
        N1: TMenuItem;
        N2: TMenuItem;
        N3: TMenuItem;
        log2: TMenuItem;
        CheckBox_speed: TCheckBox;
        N4: TMenuItem;
        N5: TMenuItem;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure TimerProcessTimer(Sender: TObject);
        procedure TimerDisplayTimer(Sender: TObject);
        procedure TimerSaveTimer(Sender: TObject);
        procedure TimerCloseTimer(Sender: TObject);
        procedure Exit1Click(Sender: TObject);
        procedure LoadBadIpAndNotice1Click(Sender: TObject);
        procedure SEProcessListCountChange(Sender: TObject);
        procedure TimerRainTimer(Sender: TObject);
        procedure MRainClick(Sender: TObject);
        procedure TimerRainningTimer(Sender: TObject);
        procedure MDrop100Click(Sender: TObject);
        procedure MGateClick(Sender: TObject);
        procedure MDelGuildClick(Sender: TObject);
        procedure FormActivate(Sender: TObject);
        procedure Save1Click(Sender: TObject);

        procedure Log1Click(Sender: TObject);
        procedure SpinEditMoveTimeChange(Sender: TObject);
        procedure SpinEditMaxExpChange(Sender: TObject);
        procedure SpinEditAttackMagicChange(Sender: TObject);
        procedure SpinEditBreathngMagicChange(Sender: TObject);
        procedure SpinEditRunningMagicChange(Sender: TObject);
        procedure SpinEditProtectingMagicChange(Sender: TObject);
        procedure SpinEditEctMagicChange(Sender: TObject);
        procedure SEProcessListUserCountChange(Sender: TObject);
        procedure N1Click(Sender: TObject);
        procedure N2Click(Sender: TObject);
        procedure log2Click(Sender: TObject);
        procedure CheckBox_speedClick(Sender: TObject);
        procedure N4Click(Sender: TObject);
        procedure N5Click(Sender: TObject);
    private
        BadIpStringList: TStringList;
        NoticeStringList: TStringList;
        RollMSGStringList: TStringList;
        CurNoticePosition: integer;
        RollMSGNOticePosition: integer;

        Rain: TSRainning;
    public
        ServerIni: TIniFile;
        boConnectRemote: Boolean;

        boCloseFlag: Boolean;
        boCloseCount: integer;
        boCloseState: integer;
        boCloseETime: integer;


        ProcessCount: integer;

        IniDate: string;
        IniHour: integer;
        EventStringList: TStringList;

        procedure AddEvent(aevent: string);

        procedure WriteLogInfo(aStr: string);
        procedure WriteDumpInfo(aData: PChar; aSize: Integer);
    end;

var
    FrmMain: TFrmMain;

    BufferSize_GATE_RECE: Integer = 1048576;
    BufferSize_GATE_SEND: Integer = 1048576;

    BufferSize_USER_RECE: Integer = 65535;

    BufferSize_NOTICE_RECE: Integer = 65535;
    BufferSize_NOTICE_SEND: Integer = 65535;

    BufferSize_DB_RECE: Integer = 65535;
    BufferSize_DB_SEND: Integer = 65535;


    CurrentDate: TDateTime;
    OldDate: string = '';
    RainTick: integer = 0;

function logItemMoveInfo(atype: string; aSource, adest: pTBasicData; var aitem: titemdata; amapID: integer): Boolean;
function logMonsterdie(ahitname, aname, aitemlist: string; amapid, ax, ay: integer): Boolean;
implementation

uses
    UTelemanagement, uUserSub, FSockets, FGate, uGConnect, uItemLog, uMarriage, uQuest, uEmail, uAuction, uProcession, uBillboardcharts, uEmporia,
    ViewLog, frmEmail, frmAuction, Unit_console;

{$R *.DFM}

function logMonsterdie(ahitname, aname, aitemlist: string; amapid, ax, ay: integer): Boolean;
begin
    FrmSockets.UdpMonsterdieAddData(ahitname, aname, aitemlist, amapid, ax, ay);
end;

function logItemMoveInfo(atype: string; aSource, adest: pTBasicData; var aitem: titemdata; amapID: integer): Boolean;
var
    aSourceIP, adestIP, aSourcestr, adeststr: string;
    ax, ay: integer;
begin
    if aitem.rboLOG = false then exit;
    aSourceIP := '';
    adestIP := '';
    ax := 0;
    ay := 0;
    if aSource = nil then
    begin
        aSourcestr := '';
    end else
    begin
        ax := aSource.x;
        ay := aSource.y;
        case aSource.BasicObjectType of
            botNone: aSourcestr := '@NONE:' + aSource.Name;
            botNpc: aSourcestr := '@NPC:' + aSource.Name;
            botMonster: aSourcestr := '@怪物:' + aSource.Name;
            botUser:
                begin
                    aSourcestr := '' + aSource.Name;
                    aSourceIP := tuser(aSource.p).IP;
                end;
            botItemObject: aSourcestr := '@地上物品:' + aSource.Name;
            boDynamicObject: aSourcestr := '@动态物品:' + aSource.Name;
            boStaticItem: aSourcestr := '@禁态物品:' + aSource.Name;
            boMirrorObject: aSourcestr := '@boMirrorObject:' + aSource.Name;
            boGateObject: aSourcestr := '@boGateObject:' + aSource.Name;

            boDoorObject: aSourcestr := '@boDoorObject:' + aSource.Name;
            boSoundObj: aSourcestr := '@boSoundObj:' + aSource.Name;
            boItemGen: aSourcestr := '@boItemGen:' + aSource.Name;
            boObjectChecker: aSourcestr := '@boObjectChecker:' + aSource.Name;
            boGuildObject: aSourcestr := '@boGuildObject:' + aSource.Name;
            boLifeObject: aSourcestr := '@boLifeObject:' + aSource.Name;
            boGuildNpc: aSourcestr := '@boGuildNpc:' + aSource.Name;
        else aSourcestr := '@错误类:' + aSource.Name;
        end;
    end;
    if adest = nil then
    begin
        adeststr := '';
    end else
    begin
        if aSource = nil then
        begin
            ax := adest.x;
            ay := adest.y;
        end;
        case adest.BasicObjectType of
            botNone: adeststr := '@NONE:' + adest.Name;
            botNpc: adeststr := '@NPC:' + adest.Name;
            botMonster: adeststr := '@怪物:' + adest.Name;
            botUser:
                begin
                    adeststr := '' + adest.Name;
                    adestIP := tuser(adest.p).IP;
                end;
            botItemObject: adeststr := '@地上物品:' + adest.Name;
            boDynamicObject: adeststr := '@动态物品:' + adest.Name;
            boStaticItem: adeststr := '@禁态物品:' + adest.Name;
            boMirrorObject: adeststr := '@boMirrorObject:' + adest.Name;
            boGateObject: adeststr := '@boGateObject:' + adest.Name;
            boDoorObject: aSourcestr := '@boDoorObject:' + adest.Name;
            boSoundObj: aSourcestr := '@boSoundObj:' + adest.Name;
            boItemGen: aSourcestr := '@boItemGen:' + adest.Name;
            boObjectChecker: aSourcestr := '@boObjectChecker:' + adest.Name;
            boGuildObject: aSourcestr := '@boGuildObject:' + adest.Name;
            boLifeObject: aSourcestr := '@boLifeObject:' + adest.Name;
            boGuildNpc: aSourcestr := '@boGuildNpc:' + adest.Name;
        else aSourcestr := '@错误类:' + adest.Name;
        end;
    end;

    FrmSockets.UdpItemMoveInfoAddData(atype, aSourcestr, adeststr, aSourceIP, adestIP, amapID, ax, ay, aitem.rName, aitem.rCount);

end;

procedure TFrmMain.WriteLogInfo(aStr: string);
var
    Stream: TFileStream;
    tmpFileName: string;
    szBuf: array[0..1024] of Byte;
begin
    try
        StrPCopy(@szBuf, '[' + DateToStr(Date) + ' ' + TimeToStr(Time) + '] ' + aStr + #13#10);
        tmpFileName := 'TGS1000.LOG';
        if FileExists(tmpFileName) then
            Stream := TFileStream.Create(tmpFileName, fmOpenReadWrite)
        else
            Stream := TFileStream.Create(tmpFileName, fmCreate);

        Stream.Seek(0, soFromEnd);
        Stream.WriteBuffer(szBuf, StrLen(@szBuf));
        Stream.Destroy;
    except
    end;
end;

procedure TFrmMain.WriteDumpInfo(aData: PChar; aSize: Integer);
var
    Stream: TFileStream;
    tmpFileName: string;
    iCount: Integer;
begin
    try
        iCount := 0;
        while true do
        begin
            tmpFileName := 'DUMP' + IntToStr(iCount) + '.BIN';
            if not FileExists(tmpFileName) then break;
            iCount := iCount + 1;
        end;

        Stream := TFileStream.Create(tmpFileName, fmCreate);
        Stream.Seek(0, soFromEnd);
        Stream.WriteBuffer(aData^, aSize);
        Stream.Destroy;
    except
    end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
    cnt: integer;
    Manager: TManager;
begin
    WriteLogInfo('GameServer Started');
    tmlog := TsTMLogClass.Create('tmlog.dat');
    tmmoneylist := TsTMMoneyLogListClass.Create('tmlist.dat');

    CurrentDate := Date;

    SEProcessListCount.Value := ProcessListCount;
    EventStringList := TStringList.Create;

    boConnectRemote := FALSE;
    boCloseFlag := FALSE;

    Randomize;

    BadIpStringList := TStringList.Create;
    NoticeStringList := TStringList.Create;
    RollMSGStringList := tstringlist.Create;
    if not FileExists('.\sv1000.INI') then
    begin
        ServerINI := TIniFile.Create('.\sv1000.INI');

        try

            ServerINI.WriteInteger('SERVER', 'BufferSize_RECE', 4194304);
            ServerINI.WriteInteger('SERVER', 'BufferSize_SEND', 4194304);
            ServerINI.WriteInteger('SERVER', 'BufferSize_USER_RECE', 65535);
            ServerINI.WriteInteger('SERVER', 'ServerGateProt', 3052);

            ServerIni.WriteString('DB_SERVER', 'IPADDRESS', '127.0.0.1');
            ServerIni.WriteInteger('DB_SERVER', 'PORT', 3051);
            ServerINI.WriteInteger('DB_SERVER', 'BufferSize_RECE', 4194304);
            ServerINI.WriteInteger('DB_SERVER', 'BufferSize_SEND', 4194304);

            ServerIni.WriteString('NOTICE_SERVER', 'IPADDRESS', '127.1.0.1');
            ServerIni.WriteInteger('NOTICE_SERVER', 'PORT', 3090);
            ServerINI.WriteInteger('NOTICE_SERVER', 'BufferSize_RECE', 65535);
            ServerINI.WriteInteger('NOTICE_SERVER', 'BufferSize_SEND', 65535);

            ServerIni.WriteString('UDP_Receiver', 'IPADDRESS', '127.0.0.1');
            ServerIni.WriteInteger('UDP_Receiver', 'PORT', 6001);

            ServerIni.WriteString('BATTLE_SERVER', 'IPADDRESS', '127.0.0.1');
            ServerIni.WriteInteger('BATTLE_SERVER', 'PORT', 3040);
            ServerINI.WriteInteger('BATTLE_SERVER', 'BufferSize_RECE', 65535);
            ServerINI.WriteInteger('BATTLE_SERVER', 'BufferSize_SEND', 65535);
        finally

            ServerINI.Free;
        end;



    end;

    ServerINI := TIniFile.Create('.\sv1000.Ini');


    GameStartDateStr := DateToStr(EncodeDate(GameStartYear, GameStartMonth, GameStartDay));

    GameStartDateStr := ServerIni.ReadString('SERVER', 'GAMESTARTDATE', GameStartDateStr);
    GameCurrentDate := Round(Date - StrToDate(GameStartDateStr));


    BufferSize_GATE_RECE := ServerINI.ReadInteger('SERVER', 'BufferSize_RECE', 1048576);
    BufferSize_GATE_SEND := ServerINI.ReadInteger('SERVER', 'BufferSize_SEND', 1048576);

    BufferSize_USER_RECE := ServerINI.ReadInteger('SERVER', 'BufferSize_USER_RECE', 65535);


    ServerGateProt := ServerINI.ReadInteger('SERVER', 'ServerGateProt', 3052);

    cnt := ServerINI.ReadInteger('DATABASE', 'COUNT', 0);
    Inc(cnt);
    ServerINI.WriteInteger('DATABASE', 'COUNT', cnt);

    IniDate := ServerINI.ReadString('DATABASE', 'DATE', '');
    IniHour := ServerINI.ReadInteger('DATABASE', 'HOUR', 0);

    Udp_Receiver_IpAddress := ServerIni.ReadString('UDP_Receiver', 'IPADDRESS', '127.0.0.1');
    Udp_Receiver_Port := ServerIni.ReadInteger('UDP_Receiver', 'PORT', 6001);

    {Udp_Item_IpAddress := ServerIni.ReadString('UDP_ITEM', 'IPADDRESS', '127.0.0.1');
    Udp_Item_Port := ServerIni.ReadInteger('UDP_ITEM', 'PORT', 6001);

    Udp_MouseEvent_IpAddress := ServerIni.ReadString('UDP_MOUSEEVENT', 'IPADDRESS', '127.0.0.1');
    Udp_MouseEvent_Port := ServerIni.ReadInteger('UDP_MOUSEEVENT', 'PORT', 6 001);

    Udp_Moniter_IpAddress := ServerIni.ReadString('UDP_MONITER', 'IPADDRESS', '127.0.0.1');
    Udp_Moniter_Port := ServerIni.ReadInteger('UDP_MONITER', 'PORT', 6000);

    Udp_Connect_IpAddress := ServerIni.ReadString('UDP_CONNECT', 'IPADDRESS', '127.0.0.1');
    Udp_Connect_Port := ServerIni.ReadInteger('UDP_CONNECT', 'PORT', 6022);
    }
    DBServerIPAddress := ServerIni.ReadString('DB_SERVER', 'IPADDRESS', '127.0.0.1');
    DBServerPort := ServerIni.ReadInteger('DB_SERVER', 'PORT', 3051);
    BufferSize_DB_RECE := ServerINI.ReadInteger('DB_SERVER', 'BufferSize_RECE', 65535);
    BufferSize_DB_SEND := ServerINI.ReadInteger('DB_SERVER', 'BufferSize_SEND', 65535);



    NoticeServerIpAddress := ServerIni.ReadString('NOTICE_SERVER', 'IPADDRESS', '127.1.0.1');
    NoticeServerPort := ServerIni.ReadInteger('NOTICE_SERVER', 'PORT', 3090);
    BufferSize_NOTICE_RECE := ServerINI.ReadInteger('NOTICE_SERVER', 'BufferSize_RECE', 65535);
    BufferSize_NOTICE_SEND := ServerINI.ReadInteger('NOTICE_SERVER', 'BufferSize_SEND', 65535);

    BattleServerIPAddress := ServerIni.ReadString('BATTLE_SERVER', 'IPADDRESS', '127.0.0.1');
    BattleServerPort := ServerIni.ReadInteger('BATTLE_SERVER', 'PORT', 3040);

    ManagerList := TManagerList.Create;
    ManagerList.LoadFromFile('.\Init\MAP.SDB');

    SESelServer.MaxValue := ManagerList.Count - 1;

    GateConnectorList := TGateConnectorList.Create;

    ConnectorList := TConnectorList.Create;
    UserList := TUserList.Create(100);

    GuildList := TGuildList.Create;
    HailFellowList := tHailFellowList.Create;
    ProcessionclassList := TProcessionclassList.Create;
    GateList := TGateList.Create;
    GroupMoveLIST := TGroupMoveList.Create;
    MirrorList := TMirrorList.Create;
    EmporiaClass := TEmporiaClass.Create;
    //排行
    BillboardchartsEnergy := TBillboardcharts.Create('.\Billboardcharts\Energy.sdb', bctEnergy);
    BillboardchartsPrestige := TBillboardcharts.Create('.\Billboardcharts\Prestige.sdb', bctPrestige);
    SoundObjList := TSoundObjList.Create;

    Manager := ManagerList.GetManagerByTitle('狐狸洞');

    ItemGen := TItemGen.Create;
    ItemGen.SetManagerClass(Manager);
    ItemGen.Initial('ItemGen', '生肉', 100, 84);
    ItemGen.StartProcess;

  {  Manager := ManagerList.GetManagerByTitle('修炼洞');

{    ObjectChecker := TObjectChecker.Create;
    ObjectChecker.SetManagerClass(Manager);
    ObjectChecker.Initial('ObjectChecker', 26, 28);
    ObjectChecker.StartProcess;
 }
    // LetterManager := TLetterManager.Create(7, 1000, 'UserLetter.TXT');

    TimerProcess.Interval := 10;
    TimerProcess.Enabled := TRUE;

    SpinEditMaxExp.Value := ServerIni.ReadInteger('FORM', 'SpinEditMaxExp', 1);
    SpinEditAttackMagic.Value := ServerIni.ReadInteger('FORM', 'SpinEditAttackMagic', 1);
    SpinEditBreathngMagic.Value := ServerIni.ReadInteger('FORM', 'SpinEditBreathngMagic', 1);
    SpinEditRunningMagic.Value := ServerIni.ReadInteger('FORM', 'SpinEditRunningMagic', 1);
    SpinEditProtectingMagic.Value := ServerIni.ReadInteger('FORM', 'SpinEditProtectingMagic', 1);
    SpinEditEctMagic.Value := ServerIni.ReadInteger('FORM', 'SpinEditEctMagic', 1);

    SEProcessListCount.Value := ServerIni.ReadInteger('FORM', 'SEProcessListCount', 40);
    SEProcessListUserCount.Value := ServerIni.ReadInteger('FORM', 'SEProcessListUserCount', 40);
    SpinEditMoveTime.Value := ServerIni.ReadInteger('FORM', 'SpinEditMoveTime', 15);

end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
    ServerIni.WriteInteger('FORM', 'SpinEditMaxExp', SpinEditMaxExp.Value);
    ServerIni.WriteInteger('FORM', 'SpinEditAttackMagic', SpinEditAttackMagic.Value);
    ServerIni.WriteInteger('FORM', 'SpinEditBreathngMagic', SpinEditBreathngMagic.Value);
    ServerIni.WriteInteger('FORM', 'SpinEditRunningMagic', SpinEditRunningMagic.Value);
    ServerIni.WriteInteger('FORM', 'SpinEditProtectingMagic', SpinEditProtectingMagic.Value);
    ServerIni.WriteInteger('FORM', 'SpinEditEctMagic', SpinEditEctMagic.Value);

    ServerIni.WriteInteger('FORM', 'SEProcessListCount', SEProcessListCount.Value);
    ServerIni.WriteInteger('FORM', 'SEProcessListUserCount', SEProcessListUserCount.Value);
    ServerIni.WriteInteger('FORM', 'SpinEditMoveTime', SpinEditMoveTime.Value);



    TimerProcess.Enabled := false;
    TimerSave.Enabled := false;
    TimerDisplay.Enabled := false;

    tmmoneylist.Free;
    tmlog.Free;

    SoundObjList.Free;

//    ObjectChecker.EndProcess;
  //  ObjectChecker.Free;

    ItemGen.EndProcess;
    ItemGen.Free;

    //LetterManager.Free;

    MirrorList.Free;
    GateList.Free;
    GroupMoveLIST.Free;
    GuildList.Free;
    HailFellowList.Free;

    UserList.free;
    ConnectorList.free;
    GateConnectorList.Free;
    ManagerList.Free;
    ProcessionclassList.Free;

    ServerINI.Free;
    NoticeStringList.Free;
    RollMSGStringList.Free;
    BadIpStringList.Free;
    EventStringList.Free;
    BillboardchartsEnergy.Free;
    BillboardchartsPrestige.Free;
    EmporiaClass.Free;
    WriteLogInfo('GameServer Exit');
end;

procedure TFrmMain.AddEvent(aevent: string);
begin
    EventStringList.Add(aevent);
end;

procedure TFrmMain.TimerSaveTimer(Sender: TObject);

var
    i, n: integer;
    Str: string;
    usd: TStringData;
    Manager: TManager;
    nYear, nMonth, nDay: Word;
begin
    if TimerClose.Enabled = true then exit;

    str := TimeToStr(Time);
    if OldDate <> DateToStr(Date) then
    begin
        OldDate := DateToStr(Date);
        GameCurrentDate := Round(Date - StrToDate(GameStartDateStr));
//        NameStringListForDeleteMagic.Clear;

    end;

    { if Date <> CurrentDate then
     begin
         DecodeDate(CurrentDate, nYear, nMonth, nDay);
         Str := '.\ItemLog\Backup\ItemLog';
         Str := Str + IntToStr(nYear) + '-';
         if nMonth < 10 then Str := Str + '0';
         Str := Str + IntToStr(nMonth) + '-';
         if nDay < 10 then Str := Str + '0';
         Str := Str + IntToStr(nDay) + '.SDB';
         ItemLog.SaveToSDB(Str);

         CurrentDate := Date;
     end;
     }
    if Pos('AM', str) > 0 then GrobalLightDark := gld_dark
    else GrobalLightDark := gld_light;

    if NoticeStringList.Count > 0 then
    begin
        if CurNoticePosition >= NoticeStringList.Count then CurNoticePosition := 0;
        UserList.SendNoticeMessage(NoticeStringList[CurNoticePosition], SAY_COLOR_NOTICE);
        inc(CurNoticePosition);
    end;
    if RollMSGStringList.Count > 0 then
    begin
        if RollMSGNOticePosition >= RollMSGStringList.Count then RollMSGNOticePosition := 0;
        UserList.SendRollMSG(ColorSysToDxColor($0000FF), RollMSGStringList[RollMSGNOticePosition]);
        inc(RollMSGNOticePosition);
    end;

    n := GetCPUStartHour;
    if n <> IniHour then
    begin
        IniHour := n;
        ServerIni.WriteInteger('DATABASE', 'HOUR', n);
        // GuildList.CompactGuild;
        GuildList.SaveToFile('.\Guild\CreateGuild.SDB');
        HailFellowList.SaveToFile('.\HailFellow\HailFellow.SDB');
    end;

    //  usd.rmsg := 1;
     // SetWordString(usd.rWordString, IntToStr(UserList.Count));
     // n := sizeof(TStringData) - sizeof(TWordString) + sizeofwordstring(usd.rwordstring);
    FrmSockets.UdpMoniterAddData(IntToStr(UserList.Count) + ',');
end;

procedure TFrmMain.TimerCloseTimer(Sender: TObject);
var
    i: integer;
begin
    case boCloseState of
        0:
            begin
                boCloseCount := 0;
                boCloseState := 10;
                //1分钟后关闭

                boCloseETime := GetTickCount + 60000;
            end;
        10:
            begin
          //通告
                i := boCloseETime - GetTickCount;
                if i <= 0 then
                begin
                    boCloseFlag := true;
                    UserList.SendNoticeMessage(format('<服务器停机公告>正常停机。', []), SAY_COLOR_NOTICE);
                    boCloseState := 20;
                    exit;
                end;
                i := i div 1000;
                UserList.SendNoticeMessage(format('<服务器停机公告>%d秒后停机，避免数据丢失，请玩家下线。', [i]), SAY_COLOR_NOTICE);
            end;
        20:
            begin
                UserList.SendNoticeMessage(format('<服务器停机公告>停机中...', []), SAY_COLOR_NOTICE);
                ConnectorList.CloseConnect(10);
                if UserList.Count = 0 then
                begin
                    boCloseState := 30;
                end;
            end;
        30:
            begin
                if (UserList.Count = 0) and (ConnectorList.Count = 0) and (ConnectorList.GetSaveListCount = 0) then
                begin
                    TimerClose.Interval := 5000;
                    boCloseState := 40;
                end;
            end;
        40:
            begin
                boCloseState := 50;
                Close;
            end;
    else
        begin

        end;
    end;
     {
    if (UserList.Count = 0) and (ConnectorList.Count = 0) and (ConnectorList.GetSaveListCount = 0) then
    begin
        if TimerClose.Interval = 1000 then
        begin
            TimerClose.Interval := 5000;
            exit;
        end;

    end else
    begin
        ConnectorList.CloseAllConnect;
    end;
    }
end;

procedure TFrmMain.Exit1Click(Sender: TObject);
begin

    boCloseState := 0;

    TimerClose.Interval := 1000;
    TimerClose.Enabled := TRUE;

end;

procedure TFrmMain.LoadBadIpAndNotice1Click(Sender: TObject);
begin
    if FileExists('BadIpAddr.txt') then BadIpStringList.LoadFromFile('BadIpAddr.txt');
    if FileExists('Notice.txt') then NoticeStringList.LoadFromFile('Notice.txt');
    if FileExists('RollMSG.txt') then RollMSGStringList.LoadFromFile('RollMSG.txt');

    Udp_Item_IpAddress := ServerIni.ReadString('UDP_ITEM', 'IPADDRESS', '127.0.0.1');
    Udp_Item_Port := ServerIni.ReadInteger('UDP_ITEM', 'PORT', 6001);

    Udp_MouseEvent_IpAddress := ServerIni.ReadString('UDP_MOUSEEVENT', 'IPADDRESS', '127.0.0.1');
    Udp_MouseEvent_Port := ServerIni.ReadInteger('UDP_MOUSEEVENT', 'PORT', 6001);

    Udp_Moniter_IpAddress := ServerIni.ReadString('UDP_MONITER', 'IPADDRESS', '127.0.0.1');
    Udp_Moniter_Port := ServerIni.ReadInteger('UDP_MONITER', 'PORT', 6000);

    Udp_Connect_IpAddress := ServerIni.ReadString('UDP_CONNECT', 'IPADDRESS', '127.0.0.1');
    Udp_Connect_Port := ServerIni.ReadInteger('UDP_CONNECT', 'PORT', 6022);

    NoticeServerIpAddress := ServerIni.ReadString('NOTICE_SERVER', 'IPADDRESS', '127.0.0.1');
    NoticeServerPort := ServerIni.ReadInteger('NOTICE_SERVER', 'PORT', 5999);

    frmSockets.ReConnectNoticeServer(NoticeServerIPAddress, NoticeServerPort);

    CurNoticePosition := 0;

    LoadGameIni('.\game.ini');
end;

procedure TFrmMain.SEProcessListCountChange(Sender: TObject);
begin
    ProcessListCount := SEProcessListCount.Value;
end;

procedure TFrmMain.TimerDisplayTimer(Sender: TObject);
var
    str: string;
    Manager: TManager;
begin
    while TRUE do
    begin
        if EventStringList.Count = 0 then break;
        str := EventStringList[0];
        EventStringList.Delete(0);
        if ListBoxEvent.Items.Count > 5 then ListboxEvent.Items.Delete(0);
        ListBoxEvent.Items.add(str);
    end;

    LbProcess.Caption := 'P:' + IntToStr(processcount);
    ProcessCount := 0;

    if ConnectorList <> nil then
        LbConnection.Caption := '连接:' + IntToStr(ConnectorList.Count);
    if UserList <> nil then
        LbUser.Caption := '用户:' + IntToStr(UserList.Count);

    if ManagerList <> nil then
    begin
        Manager := ManagerList.GetManagerByIndex(SeSelServer.Value);
        if Manager <> nil then
        begin
            GroupBox_MAP.Caption := Manager.Title;
            LbItem.Caption := IntToStr(TItemList(Manager.ItemList).Count);

            if Manager.MonsterList <> nil then LbMonster.Caption := IntToStr(TMonsterList(Manager.MonsterList).Count);
            LbNpc.Caption := IntToStr(TNpcList(Manager.NpcList).Count);
        end;
    end;
end;

procedure TFrmMain.TimerProcessTimer(Sender: TObject);
var
    CurTick: integer;
begin
    CurTick := mmAnsTick;

    GateConnectorList.Update(CurTick);

    PrisonClass.Update(CurTick);

    ConnectorList.Update(CurTick);
    UserList.Update(CurTick);

    if boCloseFlag = false then
    begin
        ManagerList.Update(CurTick);
    end;
    //配套系统-----------------------------------
    GuildList.Update(CurTick);                                                  //门派       1秒
    HailFellowList.Update(CurTick);                                             //好友      1秒
    marriedlist.Update(curtick);                                                //婚姻系统   1 秒
    Marriage.Update(curtick);                                                   //结婚仪式   1 秒
    Questreglist.Update(CurTick);                                               //任务注册系统  60秒
    EmailList.Update(curtick);                                                  //邮件    60秒
    NEWEmailIDClass.Update(curtick);
    NEWAuctionidClass.Update(curtick);
//    NEWItemIDClass.Update(curtick);
    AuctionSystemClass.Update(curtick);
    ProcessionclassList.Update(curtick);
    //-------------------------------------------
    GateList.Update(CurTick);
    GroupMoveLIST.Update(CurTick);
    MirrorList.Update(CurTick);

    ItemGen.Update(CurTick);
//    ObjectChecker.Update(CurTick);

    SoundObjList.Update(CurTick);

    inc(ProcessCount);
end;

procedure TFrmMain.TimerRainTimer(Sender: TObject);
var
    nYear, nMonth, nDay: Word;
    nHour, nMin, nSec, nMSec: Word;
    boSnow: boolean;
begin
    if chkWeather.Checked = false then exit;

    try
        DecodeDate(Date, nYear, nMonth, nDay);
        DecodeTime(Time, nHour, nMin, nSec, nMSec);
    except
        exit;
    end;

    boSnow := true;
    if (nMonth > 3) and (nMonth < 11) then
    begin
        boSnow := false;
    end else if (nMonth = 3) or (nMonth = 11) then
    begin
        if Random(10) > 2 then
        begin
            boSnow := false;
        end;
    end;

    if boSnow = false then
    begin
        Rain.rmsg := SM_RAINNING;
        Rain.rspeed := 10;
        Rain.rCount := 200;
        Rain.rOverray := 50;
        Rain.rTick := 600;
        Rain.rRainType := RAINTYPE_RAIN;
    end else
    begin
        Rain.rmsg := SM_RAINNING;
        Rain.rspeed := 1;
        Rain.rCount := 200;
        Rain.rOverray := 20;
        Rain.rTick := 600;
        Rain.rRainType := RAINTYPE_SNOW;
    end;

    TimerRainning.Enabled := TRUE;
end;

procedure TFrmMain.MRainClick(Sender: TObject);
begin
    TimerRainTimer(Self);
end;

procedure TFrmMain.TimerRainningTimer(Sender: TObject);

var
    SendCount: Integer;
begin
    if chkWeather.Checked = false then exit;

    // Speed, Count, Overray, Tick
    UserList.SendRaining(Rain);

    SendCount := 20;
    if Rain.rRainType = RAINTYPE_SNOW then SendCount := 60;
    RainTick := RainTick + 1;
    if RainTick > SendCount then
    begin
        RainTick := 0;
        TimerRainning.Enabled := FALSE;
    end;
end;

procedure TFrmMain.MDrop100Click(Sender: TObject);
begin
    //
end;

procedure TFrmMain.MGateClick(Sender: TObject);
begin
    frmGate.Show;
end;

procedure TFrmMain.MDelGuildClick(Sender: TObject);
begin
    //
    GuildList.CompactGuild;
end;

procedure TFrmMain.FormActivate(Sender: TObject);
begin
    LoadBadIpAndNotice1Click(Self);
end;

procedure TFrmMain.Save1Click(Sender: TObject);
begin
//    EmailList.DBsave;                                                           //保存 所有 邮件
 //   AuctionSystemClass.DBsave;
end;


{                    背包锁     物品琐    禁止交易（和人交易）    禁止丢弃（丢地上）   禁止出售（NPC交易）  禁止寄存（仓库）
0，NPC购买           |NO        |NO       |YES                    |YES                  |YES                |YES
1，NPC出售           |NO        |NO       |NO                     |YES                  |NO                 |YES
2，邮寄              |NO        |NO       |NO                     |YES                  |YES                |YES
3，丢弃              |NO        |NO       |YES                    |NO                   |YES                |YES
4，寄售              |NO        |NO       |NO                     |YES                  |YES                |YES
5，精炼              |NO        |NO       |YES                    |YES                  |YES                |YES
6，镶嵌              |NO        |NO       |YES                    |YES                  |YES                |YES
7，取消镶嵌宝石      |NO        |NO       |YES                    |YES                  |YES                |YES
8，仓库              |NO        |NO       |YES                    |YES                  |YES                |NO
9，玩家交易          |NO        |NO       |NO                     |YES                  |YES                |YES
}

procedure TFrmMain.Log1Click(Sender: TObject);
begin
    frmLog.Show;
end;

procedure TFrmMain.SpinEditMoveTimeChange(Sender: TObject);
begin
    VarMoveSpeedTime := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SpinEditMaxExpChange(Sender: TObject);
begin
    vAddMagicExp_MaxExp := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SpinEditAttackMagicChange(Sender: TObject);
begin
    vAddMagicExp_AttackMagic := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SpinEditBreathngMagicChange(Sender: TObject);
begin
    vAddMagicExp_BreathngMagic := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SpinEditRunningMagicChange(Sender: TObject);
begin
    vAddMagicExp_RunningMagic := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SpinEditProtectingMagicChange(Sender: TObject);
begin
    vAddMagicExp_ProtectingMagic := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SpinEditEctMagicChange(Sender: TObject);
begin
    vAddMagicExp_EctMagic := TSpinEdit(Sender).Value;
end;

procedure TFrmMain.SEProcessListUserCountChange(Sender: TObject);
begin
    ProcessListUserCount := SEProcessListUserCount.Value;
end;

procedure TFrmMain.N1Click(Sender: TObject);
var
    FormEmail: TFormEmail;
begin
    FormEmail := TFormEmail.Create(Self);
    try
        FormEmail.ShowModal;
    finally
        FormEmail.Free;
    end;

end;

procedure TFrmMain.N2Click(Sender: TObject);
var
    FormAuction: TFormAuction;
begin
    FormAuction := TFormAuction.Create(Self);
    try
        FormAuction.ShowModal;
    finally
        FormAuction.Free;
    end;

end;

procedure TFrmMain.log2Click(Sender: TObject);
begin
    FrmConsole.Show;
end;

procedure TFrmMain.CheckBox_speedClick(Sender: TObject);
begin
    boCheckSpeed := CheckBox_speed.Checked;
end;

procedure TFrmMain.N4Click(Sender: TObject);
begin
//
    ManagerList.SaveFileCsv;

end;

procedure TFrmMain.N5Click(Sender: TObject);
begin
    UserList.ClearMagicDelCount;
end;

end.

