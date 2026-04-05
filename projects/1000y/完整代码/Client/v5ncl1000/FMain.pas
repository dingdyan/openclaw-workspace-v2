unit FMain;

interface
uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    DXDraws, DXClass, DirectX, DXSounds, uSound, Cltype, A2Form, A2Img, uAnsTick,
    ExtCtrls, StdCtrls, BackScrn, CharCls, ClMap, AtzCls, Deftype, subutil,
    PaintLabel, objcls, tilecls, AUtil32, IniFiles, CTable, mmsystem,
    uPersonBat, DXSprite, jpeg, ImgList, DIB;                                   //Log,
//uActiveMusic;
var
    NameChangeColor: integer;

    boMove: boolean = false;

    OldCharPos: TPoint;
    boAttack: boolean = true;
    CurMagicType: integer = 0;
type
    //TShowName = (tsnNone, tsnNpc, tsnPeople, tsnMonster, tsnItem);
    TWinVerType = (wvtNew, wvtOld);
    Tmove_win_form = (mwfLeft, mwfTop, mwfRight, mwfBottom, mwfCenter, mwfCenterLeft);
    TFormData = record
        rForm: TForm;
        rOldParent: integer;
        rA2Form: TA2Form;
    end;
    PTFormData = ^TFormData;

    TFrmM = class(TForm)
        PaintLabel: TPaintLabel;
        Timer1MouseEvent: TTimer;
        DXDraw: TDXDraw;
        DXWaveList1: TDXWaveList;
        DXSound1: TDXSound;
        Timer2_dx: TTimer;

        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure DXDrawInitialize(Sender: TObject);
        procedure PaintLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure PaintLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
        procedure PaintLabelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure PaintLabelClick(Sender: TObject);
        procedure PaintLabelDblClick(Sender: TObject);
        procedure PaintLabelDragDrop(Sender, Source: TObject; X, Y: Integer);
        procedure PaintLabelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
        procedure PaintLabelStartDrag(Sender: TObject; var DragObject: TDragObject);
        procedure Time1TimerTimer(Sender: TObject);
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
        procedure Timer2_dx1Timer(Sender: TObject; LagCount: Integer);
        procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
        procedure Timer2_dxTimer(Sender: TObject);
    private
        { Private declarations }
        FormList: TList;
        function GetMouseDirection: word;
        procedure DrawChatList;
        function send_Booth_Click: boolean;


    protected
        procedure WndProc(var Message: TMessage); override;
    public
        dxTick: integer;
        dxTicknum, dxSPEEDtick: integer;                                        //当前 刷了几张



        EventTick_Attrib: integer;
        EventTick_Tick: integer;
        EventTick_Magic: integer;
        Event_Magic_text: string;

        DragItem: TDragItem;

        BottomUpImage: TA2Image;
        AttribLeftImage: TA2Image;
        SoundManager: TSoundManager;

        //    BaseAudio : TBaseAudio;
        //    BaseAudioVolume : integer;
        ChatList: TStringList;
        AutoHit_updatetick: integer;
        AutoHit_ID: integer;
        AutoHit_SendCMD: boolean;
        procedure Eventstringdisplay(aTick: integer);
        procedure EventstringSet(s: string; key: byte);
        procedure AddChat(astr: string; fcolor, bcolor: integer);
        procedure AddA2Form(aform: TForm; aA2Form: TA2Form);
        procedure DelA2Form(aform: TForm; aA2Form: TA2Form);
        procedure SaveAndDeleteAllA2Form;
        procedure RestoreAndAddAllA2Form;

        procedure SetA2Form(aForm: TForm; aA2Form: TA2Form);
        procedure MoveProcess;
        procedure map_move(mx, my: integer);
        procedure CheckAndSendClick;
        procedure MessageProcess(var code: TWordComData);

        procedure OnAppMessage(var Msg: TMsg; var Handled: Boolean);
        procedure CheckSome(var code: TWordComData);
        procedure move_win_form_Paint(aTick: integer);
        procedure move_win_form_set(sender: TForm; x, y: integer);
        procedure move_win_form_Align(sender: TForm; Align: Tmove_win_form);

        function send_hit_Selectid(): boolean;
        function send_get_WearItemUser(aid: integer): boolean;
        function send_drink: boolean;
        //自动移动打怪 2009.7.15新增
        function AutoPathAI(cx, cy: word): integer;
        procedure AutoMove_begin(cx, cy: word);
        procedure AutoMove_stop;

        function AutoHit_begin(aid: integer): boolean;
        procedure AutoHit_stop;
        procedure AutoHit_update(curtick: integer);

    end;

    TGameHint = class
    private
        A2Hint: TA2Hint;
        A2Hint_id: integer;
        A2Hint_text: string;
        A2Hint_state: integer;
        A2Hint_time: integer;
        A2Hint_X: integer;
        A2Hint_Y: integer;

    public
        constructor Create;
        destructor Destroy; override;

        procedure settext(aid: integer; astr: string);
        procedure update(curtick: integer);
        //        procedure pos(ax, ay:Integer);
        procedure Close();

    end;

var
    FrmM: TFrmM;
    GameHint: TGameHint;
    Keyshift: TShiftState;
var
    GrobalClick: TCClick;
    ClickTick: integer = 0;
    HitTick: integer = 0;
    boShiftAttack: Boolean = TRUE;

    mousecheck: boolean = FALSE;
    RightButtonDown: Boolean = FALSE;
    MapAutoPath: boolean = false;
    MapAutoPath2: boolean = false;

    MapAutoPathx, MapAutoPathy: integer;
    MapAutoPathx2, MapAutoPathy2: integer;
    mouseX, mousey: integer;
    MouseCellX, MouseCelly: integer;

    boShowChat: Boolean = FALSE;

    ClientIni: TIniFile;

    move_win_form: TForm;
    move_win_Or_baseX: integer;
    move_win_Or_baseY: integer;
    move_win_X: integer;

    move_win_Y: integer;
    move_winClickTick: integer;
    Hitrace: integer;

    FullScreen_time: integer = 0;


    MoveAutoOpenMagictime: integer = 0;
    WinVerType: TWinVerType = wvtNew;
    boACTIVATEAPP: boolean = true;
    MagicWindow: integer;

implementation

uses
    FLogOn, FSelChar, FBottom, FAttrib, FQuantity, FSearch, FExchange, FSound, FDepository,
    FbatList, FMuMagicOffer, FcMessageBox, FNPCTrade,
    FCharAttrib, FItemHelp, FPassEtc, FHistory, FMiniMap, cAIPath,
    FShowPopMsg, FGuild, FEMAIL, FAuction, FWearItemUser, FQuest,
    FProcession, FBillboardcharts, filepgkclass, energy, FUPdateItemLevel,
    FEmporia, FGameToolsNew, FWearItem, FNEWHailFellow, FEnergy                 //, uMinMap
{$IFDEF gm}
//    , cTm
{$ENDIF}
    , Fhelp_htm, fmsgboxtemp, FLittleMap, FBooth, FnewMagic, Unit_console,
    FSkill;

{$R *.DFM}
{$O+}
var

    first: Boolean = TRUE;
    oldMouseInfo: string = '';
    eventbuffer: array[0..10 - 1] of integer;
    //                        Twhoop

//

procedure TFrmM.WndProc(var Message: TMessage);
begin
    inherited;
    case Message.Msg of
        WM_ACTIVATE:
            begin
                if TWMActivate(Message).Active = WA_INACTIVE then
                begin
                    boACTIVATEAPP := false;

                    // Caption := 'false';
                end else
                begin
                    boACTIVATEAPP := true;
                    // Caption := 'true';
                end;
                SoundManager.activateapp(boACTIVATEAPP);
            end;

    end;
end;

procedure TFrmM.OnAppMessage(var Msg: TMsg; var Handled: Boolean);
var
    fframe, fcaption: integer;
begin
    frmHelp.ApplicationEvents1Message(Msg, Handled);
    case Msg.message of

        WM_LBUTTONUP: move_win_form := nil;
        WM_MOUSEMOVE:
            begin
                fframe := (Width - ClientWidth) div 2;
                fcaption := (Height - ClientHeight - fframe);

                move_win_X := msg.pt.X - self.Left;
                move_win_Y := msg.pt.Y - self.top;

                move_win_X := move_win_X - Fframe;
                move_win_Y := move_win_Y - fcaption;
            end;
    end;

    if GetAsyncKeyState(VK_SNAPSHOT) <> 0 then
        if boACTIVATEAPP then FrmBottom.ClientCapture;

    if (Msg.message >= WM_MOUSEMOVE) and (Msg.message <= WM_MBUTTONDBLCLK) then
    begin
        //鼠标  事件
        inc(eventbuffer[Msg.message - WM_MOUSEMOVE]);
    end;
end;

procedure TFrmM.CheckSome(var code: TWordComData);
var
    PsSCheck: PTSCheck;
    CCheck: TCCheck;
begin
    PsSCheck := @Code.data;
    case PsSCheck^.rCheck of
        1:
            begin
                CCheck.rMsg := CM_CHECK;
                CCheck.rCheck := PsSCheck^.rCheck;
                CCheck.rTick := 1;
                {    if not FileExists('.\South.map') then CCheck.rTick := 0;
                    if not FileExists('.\Southobj.obj') then CCheck.rTick := 0;
                    if not FileExists('.\Southrof.Obj') then CCheck.rTick := 0;
                    if not FileExists('.\Southtil.til') then CCheck.rTick := 0;}
                if not pgkmap.isfile('South.map') then CCheck.rTick := 0;
                if not pgkmap.isfile('Southobj.obj') then CCheck.rTick := 0;
                if not pgkmap.isfile('Southrof.Obj') then CCheck.rTick := 0;
                if not pgkmap.isfile('Southtil.til') then CCheck.rTick := 0;
            end;
        2:
            begin
                CCheck.rMsg := CM_CHECK;
                CCheck.rCheck := PsSCheck^.rCheck;
                CCheck.rTick := TimeGetTime;
            end;
    end;
    FrmLogOn.SocketAddData(sizeof(CCheck), @CCheck);
end;

procedure TFrmM.FormCreate(Sender: TObject);
begin
    netPingSendTick := 0;
    netPingId := 0;
    GameHint := TGameHint.Create;
{$IFDEF gm}
  //  frmTM := nil;
{$ENDIF}
    NameChangeColor := ColorSysToDxColor($00FF00);

    DoubleBuffered := true;

    dxTick := 0;
    move_winClickTick := 0;
    if doFullScreen in DxDraw.Options then BorderStyle := bsNone
    else BorderStyle := bsDialog;

    //  LeftTextScroll := TTextScroll.Create;
    Chdir(ExtractFilePath(Application.ExeName));

    ClientIni := TIniFile.Create('.\ClientIni.ini');
    mainFont := ClientIni.ReadString('FONT', 'FontName', 'Arial');              // font read
    // FrmM Font Set
    mainFont := 'Arial';
    FrmM.Font.Name := mainFont;
    A2FontClass.SetFont(mainFont);
    // A2FontClass.SetFont(Font.Name);

    FormList := TList.Create;

    SoundManager := TSoundManager.Create(DxSound1, '.\wav\wav1000y.atw', '.\wav\effect.atw', DXWaveList1);
    SoundManager.Volume := ClientIni.ReadInteger('SOUND', 'BASEVOLUME', -1000);

    //BaseAudio := TBaseAudio.Create;
    //BaseAudio.SetVolume (SoundManager.Volume);

  {  if ClientIni.ReadString('CLIENT', 'SOUND', 'ON') <> 'ON' then
    boUseSound := FALSE
    else boUseSound := TRUE; }

    FrmM.SoundManager.VolumeEffect := ClientIni.ReadInteger('SOUND', 'EFFECTVOLUME', -2000);

    //   ActiveBaseAudioList := TActiveBaseAudioList.Create;

   // SoundManager.PlayBaseAudio('logon.wav', 5);
    SoundManager.PlayBaseAudioMp3('1003.mp3', 5);
    //  SoundManager.PlayBaseAudio('1003.wav', 5);

    BottomUpImage := TA2Image.Create(4, 4, 0, 0);
    //  BottomUpImage.LoadFromFile('upbottom.bmp'); //'bottomup.bmp');
    if WinVerType = wvtOld then
    begin
        pgkBmp.getbmp('upbottom.bmp', BottomUpImage);
    end
    else if WinVerType = wvtNew then
    begin
        pgkBmp.getbmp('操作界面_底框上半部分.BMP', BottomUpImage);
    end;
    BottomUpImage.TransparentColor := 0;
    AttribLeftImage := TA2Image.Create(4, 4, 0, 0);
    //AttribLeftImage.LoadFromFile('attribleft.bmp');

    pgkBmp.getbmp('attribleft.bmp', AttribLeftImage);
    AttribLeftImage.TransparentColor := 0;
    BackScreen := TBackScreen.Create;
    DragItem := TDragItem.Create;
    TileDataList := TTileDataList.Create;
    ObjectDataList := TObjectDataList.Create;
    RoofDataList := TObjectDataList.Create;

    Map := TMap.Create;
    EffectPositionClass := TEffectPositionClass.Create;
    Animater := TAnimater.Create;
    AtzClass := TAtzClass.Create();
    EtcAtzClass := TEtcAtzClass.Create;

    CharList := TCharList.Create(AtzClass);
    ChatList := TStringList.Create;

    PersonBat := TPersonBat.Create;
    Application.OnMessage := OnAppMessage;

    //MinMap := TMinMap.Create;
end;

procedure TFrmM.FormDestroy(Sender: TObject);
begin
    //    LeftTextScroll.Free;
    ClientIni.WriteString('FONT', 'FontName', mainFont);
    GameHint.Free;
    ChatList.free;
    CharList.Free;
    AtzClass.Free;
    Animater.Free;
    EtcAtzClass.Free;
    Map.Free;

    TileDataList.Free;
    ObjectDataList.Free;
    RoofDataList.Free;

    DragItem.Free;
    BackScreen.Free;

    AttribLeftImage.Free;
    BottomUpImage.Free;
    SoundManager.Free;

    //   ActiveBaseAudioList.Free;
    PersonBat.Free;

    DXSound1.Finalize;
    FormList.Free;
    ClientIni.Free;
    EffectPositionClass.Free;

    //MinMap.Free;
end;

procedure TFrmM.DrawChatList;
var
    i: integer;
begin
    //   A2SetFontColor (RGB (12, 12, 12)); // back
    for i := 0 to ChatList.Count - 1 do
    begin
        ATextOut(BackScreen.Back, 20 + 1, i * 16 + 20 + 1, WinRGB(1, 1, 1), ChatList[i]);
        //      A2TextOut (BackScreen.Back, 20+1, i*16+20+1, ChatList[i]);
    end;

    //   A2SetFontColor (clsilver);         // front
    for i := 0 to ChatList.Count - 1 do
    begin
        ATextOut(BackScreen.Back, 20, i * 16 + 20, WinRGB(24, 24, 24), ChatList[i]);
        //      A2TextOut (BackScreen.Back, 20, i*16+20, ChatList[i]);
    end;
end;

procedure TFrmM.AddChat(astr: string; fcolor, bcolor: integer);
var
    str, rdstr: string;
    col: Integer;
    addflag: Boolean;
begin
    addflag := FALSE;
    str := astr;
    while TRUE do
    begin
        str := GetValidStr3(str, rdstr, #13);
        if rdstr = '' then break;

        if chat_outcry then
        begin                                                                   // 寇摹扁
            if rdstr[1] = '[' then addflag := TRUE;
        end;

        if chat_Guild then
        begin                                                                   // 辨靛
            if rdstr[1] = '<' then addflag := TRUE;
        end;

        if chat_notice then
        begin                                                                   // 傍瘤荤亲
            if bcolor = 16912 then addflag := TRUE;
        end;

        if chat_normal then
        begin                                                                   // 老馆蜡历
            if not (bcolor = 16912) and not (rdstr[1] = '<') and not (rdstr[1] = '[') then
            begin
                addflag := TRUE;
            end;
        end;

        if Addflag then
        begin
            if ChatList.Count >= 20 then ChatList.delete(0);
            col := MakeLong(fcolor, bcolor);
            ChatList.addObject(rdstr, TObject(col));
            if SaveChatList.Count > 500 then SaveChatList.Delete(0);
            SaveChatList.Add(rdstr);
        end;
    end;
end;

procedure TFrmM.SetA2Form(aForm: TForm; aA2Form: TA2Form);
var
    flag: Boolean;
    i: integer;
    pf: PTFormData;
begin
    if (Formlist.Count > 0) and (PTFormData(FormList[0])^.rForm = aForm) then exit;

    for i := 0 to FormList.Count - 1 do
    begin
        pf := FormList[i];
        if pf^.rForm = aForm then
        begin
            FormList.Delete(i);
            FormList.Insert(0, pf);
            break;
        end;
    end;

    for i := 0 to FormList.count - 1 do
    begin
        pf := FormList[i];
        flag := pf^.rForm.Visible;
        pf^.rForm.visible := FALSE;
        pf^.rForm.parentwindow := 0;
        pf^.rForm.parentwindow := handle;
        pf^.rForm.visible := flag;
    end;
end;

procedure TFrmM.SaveAndDeleteAllA2Form;
var
    i: integer;
    pf: PTFormData;
begin
    for i := 0 to FormList.Count - 1 do
    begin
        pf := FormList[i];
        pf^.rForm.ParentWindow := pf^.roldParent;
    end;
end;

procedure TFrmM.RestoreAndAddAllA2Form;
var
    i: integer;
    pf: PTFormData;
begin
    for i := 0 to FormList.Count - 1 do
    begin
        pf := FormList[i];
        pf^.rForm.ParentWindow := Handle;
    end;
end;

procedure TFrmM.DelA2Form(aform: TForm; aA2Form: TA2Form);
var
    i: integer;
    pf: PTFormData;
begin
    for i := 0 to FormList.Count - 1 do
    begin
        pf := FormList[i];
        if pf^.rForm = aform then
        begin
            aForm.ParentWindow := pf^.roldParent;
            dispose(pf);
            FormList.Delete(i);
            exit;
        end;
    end;
end;

procedure TFrmM.AddA2Form(aform: TForm; aA2Form: TA2Form);
var
    pf: PTFormData;
begin
    new(pf);
    pf^.rOldParent := aForm.parentWindow;
    aForm.ParentWindow := Handle;
    pf^.rForm := aForm;
    pf^.rA2Form := aA2Form;
    FormList.Add(pf);
end;

procedure TFrmM.DXDrawInitialize(Sender: TObject);
begin
    if first then
    begin
        first := FALSE;
        Timer2_dx.Enabled := TRUE;
        FrmLogon.visible := TRUE;
        FrmLogon.FormActivate(Self);
    end;


end;

function TFrmM.GetMouseDirection: word;
var
    xx, yy: integer;
    MCellX, MCellY: integer;
    Cl, Sl: TCharClass;
begin
    Result := DR_DONTMOVE;
    Cl := CharList.CharGet(CharCenterId);
    if cl = nil then exit;
    //XX YY  图象坐标
    xx := BackScreen.Cx + (Mousex - BackScreen.SWidth div 2);
    yy := BackScreen.Cy + (Mousey - BackScreen.SHeight div 2);

    //换算 到 地图 坐标
    MCellX := xx div UNITX;
    MCellY := yy div UNITY;

    if SelectedChar <> 0 then
    begin
        SL := CharList.CharGet(SelectedChar);
        if SL <> nil then
        begin
            MCellX := Sl.X;
            MCellY := SL.Y;
        end;
    end;
    //计算 方向
    Result := GetViewDirection(cl.x, cl.y, mcellx, mcelly);
end;

var
    SelScreenId: integer = 0;
    SelScreenX: integer = 0;
    SelScreenY: integer = 0;

function TFrmM.send_hit_Selectid(): boolean;
var
    cHit: TCHit;
    CL: TCharClass;
    CLAtt: TCharClass;
    BOatt: TDynamicObject;
    it: TItemClass;
    procedure _sendHit(aid: integer);
    begin
        Hitrace := 0;
        HitTick := mmAnsTick;
        cHit.rmsg := CM_HIT;
        cHit.rkey := GetMouseDirection;
        cHit.rtid := aid;
        Frmlogon.SocketAddData(sizeof(cHit), @cHit);
        // FrmBottom.AddChat('测试消息：攻击指令', WinRGB(22, 22, 0), 0);
    end;

    function _hitChar(): boolean;
    begin
        result := false;

        //人 怪物 等活动物体
        if SelectedChar <> 0 then
        begin
            if SelectedChar = CharCenterId then exit;                           //自己 ID 结束
            CLAtt := CharList.CharGet(SelectedChar);                            //查找目标
            if clatt = nil then exit;                                           //目标无效

            //boAttack := true;

            if (ssCtrl in KeyShift)                                             //按了 CTRL
                or (Hitrace = RACE_HUMAN)                                       //历史 攻击 是人
                or frmGameToolsNew.A2CheckBox_Hit_not_Ctrl.Checked then
                //or frmGameTools.RzCheckBox_Hit_not_Ctrl.Checked//外挂 开免 按CTRL
            begin
                if (CLAtt.Feature.rrace = RACE_HUMAN) then
                begin
                    _sendHit(SelectedChar);
                    Hitrace := RACE_HUMAN;
                    result := true;
                    exit;
                end;
            end;
            if (Cl.Feature.rfeaturestate = wfs_care) then
            begin
                if (CLAtt.Feature.rrace = RACE_MONSTER) then
                begin
                    _sendHit(SelectedChar);
                    result := true;
                    exit;
                end;
            end;
            if (ssShift in KeyShift)
                or (FrmGameToolsNew.A2CheckBox_Hit_not_Shift.Checked and (CLAtt.Feature.rrace = RACE_MONSTER)) then
            begin
                if (CLAtt.Feature.rrace = RACE_MONSTER)
                    or (CLAtt.Feature.rrace = RACE_NPC)
                    or (CLAtt.Feature.rrace = RACE_STATICITEM) then
                begin
                    _sendHit(SelectedChar);
                    result := true;
                    exit;
                end;
            end;
        end;
    end;
    function _hititem(): boolean;
    begin
        result := false;
        //动态 物体
        if SelectedDynamicItem <> 0 then
        begin
            if SelectedDynamicItem = CharCenterId then exit;                    //自己 ID 结束
            BOatt := CharList.GeTDynamicObjItem(SelectedDynamicItem);           //查找目标
            if BOatt = nil then exit;                                           //目标无效

            if FrmGameToolsNew.A2CheckBox_Hit_not_Shift.Checked
                or (ssShift in KeyShift) or (Cl.Feature.rfeaturestate = wfs_care)
                then
            begin
                _sendHit(SelectedDynamicItem);
                result := true;
                exit;
            end;
        end;
        if Selecteditem <> 0 then
        begin
            if Selecteditem = CharCenterId then exit;                           //自己 ID 结束
            it := CharList.GetItem(Selecteditem);                               //查找目标
            if it = nil then exit;                                              //目标无效
            if it.Race <> RACE_STATICITEM then exit;
            if (ssShift in KeyShift) then
            begin
                _sendHit(Selecteditem);
                result := true;
                exit;
            end;
        end;
    end;

begin
    result := false;
    Cl := CharList.CharGet(CharCenterId);
    if Cl = nil then exit;

    if Cl.Feature.rfeaturestate = wfs_die then exit;                            //自己状态 不能 攻击
    if Cl.Feature.rfeaturestate <> wfs_care then Hitrace := 0;

    if mmAnsTick < HitTick + 200 then exit;                                     //攻击 间隔

    if _hitChar then
    begin
        result := true;
    end else
    begin
        if _hititem then
            result := true;
    end;
end;

function TFrmM.send_Booth_Click(): boolean;
var
    CL: TCharClass;
begin
    result := false;
    Cl := CharList.CharGet(CharCenterId);
    if Cl = nil then exit;
    if SelectedChar = 0 then exit;

    Cl := CharList.CharGet(SelectedChar);
    if Cl = nil then exit;
    if Cl.rbooth = false then exit;

    FrmBooth.SendOpenWindowUser(cl.rName);
    result := true;
end;

function TFrmM.send_drink(): boolean;
var
    cl: TCharClass;
    bo: TVirtualObjectClass;
    Cdrink: TCdrink;
    ax, ay: integer;
begin

    result := false;
    if SelectedVirtualObject = 0 then exit;
    cl := CharList.CharGet(CharCenterId);
    if cl = nil then exit;

    bo := CharList.VirtualObjectList.get(SelectedVirtualObject);
    if bo = nil then exit;
    ax := BackScreen.Cx + (Mousex - BackScreen.SWidth div 2);                   //- 32 div 2;
    ay := BackScreen.Cy + (Mousey - BackScreen.SHeight div 2);                  // - 24 div 2;
    ax := ax div 32;
    ay := ay div 24;
    Cdrink.rmsg := CM_drink;
    Cdrink.rclickedId := SelectedVirtualObject;
    Cdrink.rX := ax;
    Cdrink.rY := ay;
    Frmlogon.SocketAddData(sizeof(Cdrink), @Cdrink);

    result := true;

end;

function TFrmM.send_get_WearItemUser(aid: integer): boolean;
var
    CLAtt: TCharClass;
    tt: TGET_cmd;
    temp: TWordComData;
begin
    result := false;
    if aid = 0 then exit;
    Clatt := CharList.CharGet(aid);
    if Clatt = nil then exit;
    if CLAtt.Feature.rrace <> RACE_HUMAN then exit;
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_UserObject);
    WordComData_ADDbyte(temp, UserObject_WearItem);
    WordComData_ADDdword(temp, aid);
    FrmLogon.SocketAddData(temp.Size, @temp.data);
    frmWearItemUser.FUSERID := aid;
    result := true;
end;

procedure TFrmM.PaintLabelClick(Sender: TObject);
var
    key, iId: integer;

begin
    if send_Booth_Click then exit;
    if FrmGameToolsNew.A2CheckBox_autoHIt.Checked then
    begin
        AutoHit_begin(SelectedChar);
    end else
    begin
        send_hit_Selectid;
    end;
//        if AutoHit_begin(SelectedChar) then exit;
 //   if send_hit_Selectid then exit;


    iID := 0;
    ClickTick := mmAnsTick;
    FillChar(GrobalClick, sizeof(GrobalClick), 0);
    key := GetMouseDirection;

    if SelectedChar <> 0 then iID := SelectedChar;
    if SelectedItem <> 0 then iID := SelectedItem;
    if SelectedDynamicItem <> 0 then iID := SelectedDynamicItem;

    if iID = 0 then exit;
    GrobalClick.rmsg := CM_CLICK;
    GrobalClick.rwindow := WINDOW_SCREEN;
    GrobalClick.rclickedId := iID;
    GrobalClick.rShift := KeyShift;
    GrobalClick.rkey := key;
end;

procedure TFrmM.PaintLabelDblClick(Sender: TObject);
begin
    send_drink;
    if send_hit_Selectid then exit;
end;

procedure TFrmM.PaintLabelDragDrop(Sender, Source: TObject; X, Y: Integer);
var
    cDragDrop: TCDragDrop;
begin
    if Source = nil then exit;

    with Source as TDragItem do
    begin
        case SourceID of
            WINDOW_ITEMS: ;
            WINDOW_SCREEN: ;
            WINDOW_ShortcutItem: ;
        else exit;
        end;
        cDragDrop.rmsg := CM_DRAGDROP;
        cDragDrop.rsourId := DragedId;

        cDragDrop.rdestId := 0;
        if SelectedDynamicItem <> 0 then cDragDrop.rdestId := SelectedDynamicItem;
        if Selecteditem <> 0 then cDragDrop.rdestId := SelectedItem;
        if SelectedChar <> 0 then cDragDrop.rdestId := SelectedChar;
        cdragdrop.rsx := sx;
        cdragdrop.rsy := sy;
        cdragdrop.rdx := mouseCellx;
        cdragdrop.rdy := mouseCelly;

        cDragDrop.rsourwindow := SourceId;
        cDragDrop.rdestwindow := WINDOW_SCREEN;
        case SourceId of
            WINDOW_ITEMS:
                begin
                    cDragDrop.rsourkey := Selected;
                    if cDragDrop.rdestId = 0 then
                        if HaveItemclass.IS_Drop(Selected) = false then
                        begin
                            FrmBottom.AddChat('无法丢弃的物品', WinRGB(22, 22, 0), 0);
                            exit;
                        end;
                end;
            WINDOW_WEARS: cDragDrop.rsourkey := Selected;
            WINDOW_ShortcutItem:
                begin
                    //清除
                    cDragDrop.rsourkey := Selected;
                    cKeyClass.del(Selected);
         // FrmBottom.ShortcutKeySET(Selected, -1);
                    exit;
                end;
        end;
        cDragDrop.rdestkey := TA2ILabel(Sender).tag;
        FrmLogOn.SocketAddData(sizeof(cDragDrop), @cDragDrop);
    end;
end;

procedure TFrmM.PaintLabelDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
    Cl: TCharClass;
    IT: TItemClass;
    AIT: TDynamicObject;
begin
    mouseX := x;
    mousey := y;

    MouseCellX := (BackScreen.Cx - BackScreen.SWidth div 2 + Mousex) div UNITX;
    MouseCellY := (BackScreen.Cy - BackScreen.SHeight div 2 + Mousey) div UNITY;

    CharList.MouseMove(BackScreen.Cx + (Mousex - BackScreen.SWidth div 2), BackScreen.Cy + (Mousey - BackScreen.SHeight div 2));
    if (SelectedChar = 0) and (SelectedItem = 0) then MouseInfoStr := '';
    if SelectedChar <> 0 then
    begin
        Cl := CharList.CharGet(SelectedChar);
        if Cl <> nil then MouseInfoStr := Cl.rName;
    end;
    if SelectedItem <> 0 then
    begin
        IT := CharList.GetItem(SelectedItem);
        MouseInfoStr := IT.ItemName;
    end;
    if SelectedDynamicItem <> 0 then
    begin                                                                       // aniItem add by 001217
        AIT := CharList.GetDynamicObjItem(SelectedDynamicItem);
        MouseInfoStr := AIT.DynamicObjName;
    end;

    Accept := FALSE;
    if Source <> nil then
    begin
        with Source as TDragItem do
        begin
            if SourceID = WINDOW_ITEMS then Accept := TRUE;
            if SourceID = WINDOW_SCREEN then Accept := TRUE;
            if SourceID = WINDOW_ShortcutItem then Accept := TRUE;

        end;
    end;
end;

procedure TFrmM.PaintLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

begin
    //
    if PersonBat.MouseDown(Sender, Button, Shift, X, Y) then
    begin
        exit;
    end;

    mousex := x;
    mousey := y;

    if mbRight = Button then
    begin
        AutoHit_stop;
        FrmMiniMap.StopAutoMOVE;
        if ssCtrl in Shift then
        begin
            if send_get_WearItemUser(SelectedChar) then exit;
        end;
        mousecheck := TRUE;
        RightButtonDown := TRUE;

        exit;
    end;

    SelScreenId := 0;
    if SelectedChar <> 0 then SelScreenId := SelectedChar;

    if SelectedItem <> 0 then SelScreenId := SelectedItem;

    if SelScreenId <> 0 then
    begin
        SelScreenX := x;
        SelScreenY := y;
    end else
    begin
        SelScreenX := 0;
        SelScreenY := 0;
    end;

end;

procedure TFrmM.PaintLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
    Cl: TCharClass;
    IT: TItemClass;
    AIT: TDynamicObject;
begin
    GameHint.Close;
    FrmAttrib.FITEMA2Hint.FVisible := false;
    if PersonBat.MouseMove(Sender, Shift, X, Y) then exit;
    mouseX := x;
    mousey := y;

    if RightButtonDown then mousecheck := TRUE;

    CharList.MouseMove
        (BackScreen.Cx + (Mousex - BackScreen.SWidth div 2)
        , BackScreen.Cy + (Mousey - BackScreen.SHeight div 2));
    if (SelectedChar = 0) and (SelectedItem = 0) and (SelectedDynamicItem = 0) then MouseInfoStr := '';

    if SelectedChar <> 0 then
    begin
        Cl := CharList.CharGet(SelectedChar);
        if Cl <> nil then
            if Cl.Feature.rHideState = hs_100 then MouseInfoStr := Cl.rName;
    end;

    if SelectedItem <> 0 then
    begin
        IT := CharList.GetItem(SelectedItem);
        MouseInfoStr := IT.ItemName;
    end;

    if SelectedDynamicItem <> 0 then
    begin                                                                       // aniItem add by 001217
        AIT := CharList.GetDynamicObjItem(SelectedDynamicItem);
        MouseInfoStr := AIT.DynamicObjName;
    end;
    if (SelScreenId <> 0) and (abs(SelScreenX - x) + abs(SelScreenY - y) > 10) then PaintLabel.BeginDrag(TRUE);
end;

procedure TFrmM.PaintLabelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //    FrmMiniMap.StopAutoMOVE;
    if PersonBat.MouseUp(Sender, Button, Shift, X, Y) then
    begin
        RightButtonDown := FALSE;
        exit;
    end;

    mouseX := x;
    mousey := y;
    RightButtonDown := FALSE;

    if abs(SelScreenX - x) + abs(SelScreenY - y) < 10 then
    begin
        SelScreenX := 0;
        SelScreenY := 0;
        SelScreenId := 0;
    end;
end;

procedure TFrmM.PaintLabelStartDrag(Sender: TObject; var DragObject: TDragObject);
begin
    DragItem.Dragedid := SelScreenId;
    DragItem.SourceId := WINDOW_SCREEN;
    DragItem.sx := mouseCellX;
    DragItem.sy := mouseCellY;
    DragObject := DragItem;
    SelScreenId := 0;
end;

procedure TFrmM.map_move(mx, my: integer);
begin
    MapAutoPath := true;
    MapAutoPathx := mx;
    MapAutoPathy := my;
end;

function TFrmM.AutoPathAI(cx, cy: word): integer;
    function _GetDistance(a, b: word): integer;
    begin
        if a > b then Result := a - b
        else Result := b - a;
    end;
    function _isMovable(ax, ay: word): boolean;
    begin
        Result := false;
        if map.isMovable(ax, ay) and CharList.isMovable(ax, ay) then Result := true;
    end;
var
    i: integer;
    len: dword;
    adir: word;                                                                 //距离 方向
    mx, my: word;
    lenArr: array[0..7] of dword;
    boArr: array[0..7] of boolean;
    ckey: TCKey;
    cMove: TCMove;
    cl: TCharClass;
begin
    Result := 2;
    cl := CharList.CharGet(CharCenterId);
    if cl = nil then exit;
    if Cl.AllowAddAction = FALSE then exit;

    len := _GetDistance(cl.x, cx) + _GetDistance(cl.y, cy);
    if len = 0 then
    begin
        Result := 0;
        exit;
    end;

    //计算方向
    adir := GetNextDirection(cl.x, cl.y, cx, cy);
    //计算下一个坐标
    mx := cl.x;
    my := cl.y;
    GetNextPosition(adir, mx, my);
    if (mx = cx) and (my = cy) and not Map.isMovable(mx, my) then
    begin
        if cl.dir <> adir then
        begin
            //转方向
            ckey.rmsg := CM_TURN;
            ckey.rkey := adir;
            if FrmLogon.ISMsgCmd(CM_TURN) = false then exit;
            FrmLogon.SocketAddData(sizeof(ckey), @ckey);
            CL.ProcessMessage(SM_TURN, adir, cl.x, cl.y, cl.feature, 0);
        end;

        Result := 1;
        exit;
    end;

    for i := 0 to 7 do lenArr[i] := $FFFFFFFF;

    //上
    boArr[0] := _isMovable(cl.x, cl.y - 1);
    if (OldCharPos.X = cl.x) and (OldCharPos.y = cl.y - 1) then boArr[0] := false;
    if boArr[0] then
        lenArr[0] := (cl.x - cx) * (cl.x - cx) + (cl.y - 1 - cy) * (cl.y - 1 - cy);

    //右上
    boArr[1] := _isMovable(cl.x + 1, cl.y - 1);
    if (OldCharPos.X = cl.x + 1) and (OldCharPos.Y = cl.y - 1) then boArr[1] := false;
    if boArr[1] then
        lenArr[1] := (cl.x + 1 - cx) * (cl.x + 1 - cx) + (cl.y - 1 - cy) * (cl.y - 1 - cy);

    //右
    boArr[2] := _isMovable(cl.x + 1, cl.y);
    if (OldCharPos.X = cl.x + 1) and (OldCharPos.Y = cl.y) then boArr[2] := false;
    if boArr[2] then
        lenArr[2] := (cl.x + 1 - cx) * (cl.x + 1 - cx) + (cl.y - cy) * (cl.y - cy);

    //右下
    boArr[3] := _isMovable(cl.x + 1, cl.y + 1);
    if (OldCharPos.X = cl.x + 1) and (OldCharPos.Y = cl.y + 1) then boArr[3] := false;
    if boArr[3] then
        lenArr[3] := (cl.x + 1 - cx) * (cl.x + 1 - cx) + (cl.y + 1 - cy) * (cl.y + 1 - cy);
    //下
    boArr[4] := _isMovable(cl.x, cl.y + 1);
    if (OldCharPos.X = cl.x) and (OldCharPos.Y = cl.y + 1) then boArr[4] := false;
    if boArr[4] then
        lenArr[4] := (cl.x - cx) * (cl.x - cx) + (cl.y + 1 - cy) * (cl.y + 1 - cy);

    //左下
    boArr[5] := _isMovable(cl.x - 1, cl.y + 1);
    if (OldCharPos.X = cl.x - 1) and (OldCharPos.Y = cl.y + 1) then boArr[5] := false;
    if boArr[5] then
        lenArr[5] := (cl.x - 1 - cx) * (cl.x - 1 - cx) + (cl.y + 1 - cy) * (cl.y + 1 - cy);

    //左
    boArr[6] := _isMovable(cl.x - 1, cl.y);
    if (OldCharPos.X = cl.x - 1) and (OldCharPos.Y = cl.y) then boArr[6] := false;
    if boArr[6] then
        lenArr[6] := (cl.x - 1 - cx) * (cl.x - 1 - cx) + (cl.y - cy) * (cl.y - cy);

    //左上
    boArr[7] := _isMovable(cl.x - 1, cl.y - 1);
    if (OldCharPos.X = cl.x - 1) and (OldCharPos.Y = cl.y - 1) then boArr[7] := false;
    if boArr[7] then
        lenArr[7] := (cl.x - 1 - cx) * (cl.x - 1 - cx) + (cl.y - 1 - cy) * (cl.y - 1 - cy);

    len := $FFFFFFFF;

    for i := 0 to 7 do
    begin
        if (len > lenArr[i]) then
        begin
            adir := i;
            len := lenArr[i];
        end;
    end;

    mx := cl.x;
    my := cl.y;

    if (cl.dir <> adir) then
    begin
        //转方向
        ckey.rmsg := CM_TURN;
        ckey.rkey := adir;
        if FrmLogon.ISMsgCmd(CM_TURN) = false then exit;
        FrmLogon.SocketAddData(sizeof(ckey), @ckey);
        CL.ProcessMessage(SM_TURN, adir, cl.x, cl.y, cl.feature, 0);
    end
    else
    begin
        GetNextPosition(adir, mx, my);
        //移动
        if _isMovable(mx, my) then
        begin
            OldCharPos.X := cl.x;
            OldCharPos.y := cl.y;

            cmove.rmsg := CM_MOVE;
            cmove.rdir := adir;
            cmove.rx := mx;
            cmove.ry := my;
            cmove.rmmAnsTick := mmAnsTick;
            if FrmLogon.ISMsgCmd(CM_MOVE) = false then exit;
            FrmLogon.SocketAddData(sizeof(cmove), @cmove);
            CL.ProcessMessage(SM_MOVE, adir, cl.x, cl.y, cl.feature, 0);
        end
        else
        begin
            OldCharPos.X := 0;
            oldcharpos.Y := 0;
        end;
    end;
end;

procedure TFrmM.AutoMove_begin(cx, cy: word);
begin
    AutoHit_SendCMD := false;
    MapAutoPath2 := true;
    MapAutoPathy2 := cy;
    MapAutoPathx2 := cx;
    FrmConsole.cprint(lt_gametools, format('---移动开始，目标%d,%d', [MapAutoPathx2, MapAutoPathy2]));
end;

procedure TFrmM.AutoMove_stop;
begin
    FrmConsole.cprint(lt_gametools, format('---移动停止，目标%d,%d', [MapAutoPathx2, MapAutoPathy2]));
    MapAutoPath2 := false;
    AutoHit_SendCMD := false;
end;

function TFrmM.AutoHit_begin(aid: integer): boolean;
var
    target: TCharClass;
    cl: TCharClass;
begin
    result := false;
    Cl := CharList.CharGet(CharCenterId);
    if Cl = nil then exit;
    if cl.Feature.rfeaturestate = wfs_die then exit;
    target := CharList.CharGet(aid);
    if target = nil then exit;
    if target.Feature.rrace <> RACE_MONSTER then exit;
    if target.Feature.rfeaturestate = wfs_die then exit;
    AutoHit_ID := aid;
    result := true;
    AutoHit_SendCMD := false;
    FrmConsole.cprint(lt_gametools, format('---攻击开始，目标%s,ID%d', [target.rName, aid]));
end;

procedure TFrmM.AutoHit_stop();
begin
    FrmConsole.cprint(lt_gametools, format('---攻击停止，ID%d', [AutoHit_ID]));
    AutoHit_ID := 0;
    MapAutoPath2 := false;
    AutoHit_SendCMD := false;
end;

procedure TFrmM.AutoHit_update(curtick: integer);
var
    target: TCharClass;
    cl: TCharClass;
    aMagicType: integer;
    aitem: PTMagicData;
    procedure _SendHit(aid: integer);
    var
        cHit: TCHit;
        adir: integer;
    begin
        if curtick < HitTick + 100 then
        begin
            //FrmBottom.AddChat('---攻击，等待时间-------', WinRGB(255, 255, 0), 0);
            exit;                                                               //攻击 间隔
        end;
        HitTick := curtick;
        adir := GetViewDirection(cl.x, cl.y, target.x, target.y);
        cHit.rmsg := CM_HIT;
        cHit.rkey := adir;
        cHit.rtid := aid;
        if FrmLogon.ISMsgCmd(CM_HIT) = false then exit;
        FrmLogOn.SocketAddData(sizeof(cHit), @cHit);
        AutoHit_SendCMD := true;
        //FrmBottom.AddChat('---攻击指令-------', WinRGB(255, 255, 0), 0);
    end;

begin
    if AutoHit_ID = 0 then exit;
    if AutoHit_updatetick + 20 > mmAnsTick then exit;
    AutoHit_updatetick := mmAnsTick;

    target := CharList.CharGet(AutoHit_ID);
    if target = nil then
    begin
        AutoHit_stop;
        exit;
    end;
    if target.Feature.rfeaturestate = wfs_die then
    begin
        AutoHit_stop;
        exit;
    end;
    if target.Feature.rHideState <> hs_100 then
    begin
        AutoHit_stop;
        exit;
    end;

    if MapAutoPath2 then
    begin
        MapAutoPathy2 := target.y;
        MapAutoPathx2 := target.x;
        exit;
    end;

    Cl := CharList.CharGet(CharCenterId);
    if Cl = nil then exit;
    if cl.Feature.rfeaturestate = wfs_die then exit;

    aitem := HaveMagicClass.DefaultMagic.getname(FrmBottom.UseMagic1.Caption);
    if aitem = nil then
        aitem := HaveMagicClass.HaveMagic.getname(FrmBottom.UseMagic1.Caption);
    if aitem = nil then
        aitem := HaveMagicClass.HaveRiseMagic.getname(FrmBottom.UseMagic1.Caption);
    if aitem = nil then
        aitem := HaveMagicClass.HaveMysteryMagic.getname(FrmBottom.UseMagic1.Caption);

    if aitem = nil then exit;
    case aitem.rMagicType of
        // MAGICTYPE_WRESTLING = 0;       // 拳
        //  MAGICTYPE_FENCING = 1;         //剑
        // MAGICTYPE_SWORDSHIP = 2;       //刀
        // MAGICTYPE_HAMMERING = 3;       //槌
        // MAGICTYPE_SPEARING = 4;        //枪
        MAGICTYPE_BOWING,                                                       //弓
            MAGICTYPE_THROWING
            , MAGICTYPE_2BOWING,                                                //弓
            MAGICTYPE_2THROWING
            , MAGICTYPE_3BOWING,                                                //弓
            MAGICTYPE_3THROWING
            , MAGIC_Mystery_TYPE: ;                                             //投
        //  MAGICTYPE_RUNNING = 7;         //步法
        //  MAGICTYPE_BREATHNG = 8;        //心法
        // MAGICTYPE_PROTECTING = 9;      //护体
    else
        begin
            if GetLargeLength(cl.x, cl.y, target.x, target.y) > 1 then
            begin
                AutoMove_begin(target.x, target.y);
                exit;
            end;
        end;
    end;
    if AutoHit_SendCMD = false then _SendHit(AutoHit_ID);
end;

procedure TFrmM.MoveProcess;
var
    dir, xx, yy: word;
    ckey: TCKey;
    cmove: TCMove;
    Cl: TCharClass;
    procedure _automoveopenmagic();
    var
        magicKey, aMoveMagicKey, aMoveMagicWindow: integer;
        tmpGrobalClick: TCClick;
        str: string;
    begin
        if FrmGameToolsNew.A2CheckBox_MoveOpenMagic.Checked = false then exit;
        if Cl = nil then exit;
        if (cl.Feature.rfeaturestate <> wfs_running)
            and (cl.Feature.rfeaturestate <> wfs_running2) then
        begin
            if MoveAutoOpenMagictime + 20 > mmAnsTick then exit;
            str := FrmGameToolsNew.A2ComboBox_ChangeMoveMagic.Text;
            if (str = '无名步法') or (str = '') then
            begin
                aMoveMagicKey := HaveMagicClass.DefaultMagic.getMagicTypeIndex(MAGICTYPE_RUNNING);
                aMoveMagicWindow := WINDOW_BASICFIGHT;
            end
            else
            begin
                aMoveMagicKey := FrmNewMagic.GetMagicTag(str);
                if aMoveMagicKey = -1 then exit;
                aMoveMagicWindow := WINDOW_MAGICS;
            end;

            MoveAutoOpenMagictime := mmAnsTick;
            magicKey := aMoveMagicKey;
            MagicWindow := aMoveMagicWindow;
            //magicKey := HaveMagicClass.DefaultMagic.getMagicTypeIndex(MAGICTYPE_RUNNING);
            if magicKey = -1 then exit;

            tmpGrobalClick.rmsg := CM_DBLCLICK;
            tmpGrobalClick.rwindow := MagicWindow;
            tmpGrobalClick.rclickedId := 0;
            tmpGrobalClick.rShift := [];
            tmpGrobalClick.rkey := magicKey;
            Frmlogon.SocketAddData(sizeof(tmpGrobalClick), @tmpGrobalClick);
        end;
    end;
begin
    //自动 移动 攻击

    if MapAutoPath2 then
    begin
        FrmMiniMap.StopAutoMOVE;
        Cl := CharList.CharGet(CharCenterId);
        if Cl = nil then exit;
        if Cl.AllowAddAction = FALSE then exit;
        if GetLargeLength(cl.x, cl.y, MapAutoPathx2, MapAutoPathy2) <= 1 then
        begin
            AutoMove_stop;
            exit;
        end;
        _automoveopenmagic;
        AutoPathAI(MapAutoPathx2, MapAutoPathy2);
        exit;
    end;

    //自动 移动
    if MapAutoPath then
    begin
        Cl := CharList.CharGet(CharCenterId);
        if Cl = nil then exit;
        if Cl.AllowAddAction = FALSE then exit;
        //if AutoMove = false then
        _automoveopenmagic;
        if (cl.x = MapAutoPathx) and (cl.y = MapAutoPathy) then
        begin
            FrmBottom.AddChat(format('相同坐标[目标%D,%D]', [MapAutoPathx, MapAutoPathy]), ColorSysToDxColor(clred), 0);
            //直接 提下个坐标
            MapAutoPath := false;
            if FrmMiniMap.TimerAutoPathMove.Enabled then
                FrmMiniMap.TimerAutoPathMoveTimer(nil);
            if not MapAutoPath then exit;
        end;
        dir := GetViewDirection(cl.x, cl.y, MapAutoPathx, MapAutoPathy);
        if dir <> DR_DONTMOVE then
        begin
            if dir <> Cl.dir then
            begin
                //转向
                ckey.rmsg := CM_TURN;
                ckey.rkey := dir;
                if FrmLogon.ISMsgCmd(CM_TURN) = false then exit;
                FrmLogon.SocketAddData(sizeof(ckey), @ckey);
                begin
                    CL.ProcessMessage(SM_TURN, dir, cl.x, cl.y, cl.feature, 0);
                    MapAutoPath := false;
                end;
            end else

            begin
                //移动
                xx := Cl.x;
                yy := Cl.y;
                GetNextPosition(dir, xx, yy);
                //地图 障碍 测试
                if Map.isMovable(xx, yy) = FALSE then
                begin
                    FrmBottom.AddChat(format('坐标问题Map[目标%D,%D][移动%D,%D]', [MapAutoPathx, MapAutoPathy, xx, yy]), ColorSysToDxColor(clred), 0);
                    MapAutoPath := false;
                    exit;
                end;
                //物体 障碍 测试
                if CharList.isMovable(xx, yy) = FALSE then
                begin
                    FrmBottom.AddChat(format('障碍[目标%D,%D][移动%D,%D]', [MapAutoPathx, MapAutoPathy, xx, yy]), ColorSysToDxColor(clred), 0);
                    //需要重新 计算 路线
                    FrmMiniMap.AIPathcalc(FrmMiniMap.AIPathgx, FrmMiniMap.AIPathgy);
                    MapAutoPath := false;
                    exit;
                end;

                cmove.rmsg := CM_MOVE;
                cmove.rdir := dir;
                cmove.rx := xx;
                cmove.ry := yy;
                cmove.rmmAnsTick := mmAnsTick;
                if FrmLogon.ISMsgCmd(CM_MOVE) = false then exit;
                FrmLogon.SocketAddData(sizeof(cmove), @cmove);
                begin
                    CL.ProcessMessage(SM_MOVE, dir, cl.x, cl.y, cl.feature, 0);
                    MapAutoPath := false;
                end;
            end;
        end;
        exit;
    end;
    //普通 移动
    if RightButtonDown = FALSE then exit;
    //查找 自己
    Cl := CharList.CharGet(CharCenterId);
    if Cl = nil then exit;
    if Cl.AllowAddAction = FALSE then exit;
    _automoveopenmagic;

    dir := GetMouseDirection;
    if dir <> DR_DONTMOVE then
    begin

        if dir <> Cl.dir then
        begin
            //转向
            ckey.rmsg := CM_TURN;
            ckey.rkey := dir;
            if FrmLogon.ISMsgCmd(CM_TURN) = false then exit;
            FrmLogon.SocketAddData(sizeof(ckey), @ckey);
            begin
                CL.ProcessMessage(SM_TURN, dir, cl.x, cl.y, cl.feature, 0);
                // FrmBottom.AddChat('主动改变方向' + inttostr(dir), WinRGB(22, 22, 0), 0);
            end;
        end else
        begin
            //移动
            xx := Cl.x;
            yy := Cl.y;
            GetNextPosition(dir, xx, yy);
            //地图 障碍 测试
            if Map.isMovable(xx, yy) = FALSE then exit;
            //物体 障碍 测试
            if CharList.isMovable(xx, yy) = FALSE then
            begin
                exit;
            end;

            cmove.rmsg := CM_MOVE;
            cmove.rdir := dir;
            cmove.rx := xx;
            cmove.ry := yy;
            cmove.rmmAnsTick := mmAnsTick;
            if FrmLogon.ISMsgCmd(CM_MOVE) = false then exit;
            FrmLogon.SocketAddData(sizeof(cmove), @cmove);
            begin
                CL.ProcessMessage(SM_MOVE, dir, cl.x, cl.y, cl.feature, 0);
                //  FrmBottom.AddChat('主动移动，方向' + inttostr(dir), WinRGB(22, 22, 0), 0);
            end;
            //    if Cl <> nil then Cl.ProcessMessage(SM_MOVE, rdir, rx, ry, Cl.feature, 0);
        end;
    end;
end;

procedure TFrmM.CheckAndSendClick;
begin
    if mmAnsTick < ClickTick + 10 then exit;
    if GrobalClick.rwindow = 0 then exit;
    Frmlogon.SocketAddData(sizeof(GrobalClick), @GrobalClick);
    FillChar(GrobalClick, sizeof(GrobalClick), 0);
end;

procedure TFrmM.MessageProcess(var code: TWordComData);
var
    TagetX, TagetY, len: Word;
    i, n, deg, xx, yy: integer;
    pan, volume, volume2: integer;
    str, rdstr: string;
    cstr: string[1];
    DynamicGuard: TDynamicGuard;

    ItemClass: TItemClass;
    Cl, TL: TCharClass;
    Dt: TDynamicObject;
    pckey: PTCKey;
    psSay: PTSSay;
    psNewMap: PTSNewMap;
    psShow: PTSShow;
    pSShow_Npc_MONSTER: pTSShow_Npc_MONSTER;
    AFeature: TFeature;
    psShowItem: PTSShowItem;
    psHide: PTSHide;
    pssVirtualObject: pTssVirtualObject;
    psTurn: PTSTurn;
    psMove: PTSMove;
    pSMagicEffect: pTSMagicEffect;
    pSEffect: pTSEffect;
    pSCHANGEMagic: pTSCHANGEMagic;
    pSdie_Npc_MONSTER: pTSdie_Npc_MONSTER;
    pSNameColor: pTSNameColor;
    psSetPosition: PTSSetPosition;
    psChatMessage: PTSChatMessage;
    psChangeFeature: PTSChangeFeature;
    PSChangeFeature_Npc_MONSTER: PTSChangeFeature_Npc_MONSTER;
    psChangeProperty: PTSChangeProperty;
    psMotion: PTSMotion;
    psMotion2: PTSMotion2;
    psStructed: PTSStructed;
    psHaveMagic: PTSHaveMagic;
    psHaveItem: PTSHaveItem;
    //   psWearItem : PTSWearItem;
    psAttribBase: PTSAttribBase;
    psAttriblife: PTSAttribLife;
    psAttribValues: PTSAttribValues;
    psAttribFightBasic: PTSAttribFightBasic;
    psEventString: PTSEventString;
    psMovingMagic: PTSMovingMagic;
    psSoundString: PTSSoundString;
    psSoundBaseString: PTSSoundBaseString;
    psRainning: PTSRainning;
    psShowInputString: PTSShowInputString;

    PSShowDynamicObject: PTSShowDynamicObject;                                  // DynamicItem Add 010102 ankudo
    PSChangeState: PTSChangeState;                                              // Dynamic Item state Change 010105 ankudo
    PSSShowSpecialWindow: PTSShowSpecialWindow;
    PSTSHideSpecialWindow: PTSHideSpecialWindow;
    PSTSNetState: PTSNetState;
    cCNetState: TCNetState;
    PTTSShowCenterMsg: PTSShowCenterMsg;
begin

    pckey := @Code.data;
    case pckey^.rmsg of
        SM_Job: frmSkill.MessageProcess(code);
        SM_Booth: FrmBooth.MessageProcess(code);
        SM_TM:
            begin
{$IFDEF gm}
//                if frmTM <> nil then frmTM.MessageProcess(code);
{$ENDIF}
            end;
        SM_ItemInputWindows:
            begin
                frmNPCTrade.MessageProcess(Code);
                // FrmItemInput.MessageProcess(code);
            end;
        SM_money: frmEmporia.MessageProcess(code);
        SM_MsgBoxTemp: frmMsgBoxTemp.MessageProcess(code);
        SM_Emporia: frmEmporia.MessageProcess(code);
        //2009.07.03修改
        SM_PowerLevel:
            //FrmEnergy.MessageProcess(code);
            energyGraphicsclass.MessageProcess(code);
        SM_UPDATAITEM:
            begin
                FrmUPdateItemLevel.MessageProcess(code);
            end;
        SM_Billboardcharts: frmBillboardcharts.MessageProcess(code);
        SM_Procession: frmProcession.MessageProcess(code);
        SM_Quest: frmQuest.MessageProcess(code);
        SM_Auction: frmAuction.MessageProcess(Code);
        SM_EMAIL: FrmEmail.MessageProcess(Code);

        SM_GUILD:
            begin
                frmGuild.MessageProcess(Code);
            end;

        SM_GameExit:
            begin
                bodirectclose := true;
                Close;
            end;
        SM_ITEMPRO:
            begin
                frmItemHelp.MessageProcess(Code);
            end;

        SM_NETSTATE:
            begin
                PSTSNetState := @Code.data;
                with cCNetState do
                begin
                    rMsg := CM_NETSTATE;
                    rID := PSTSNetState^.rID + 1;
                    rMadeTick := PSTSNetState^.rMadeTick;
                    rCurTick := mmAnsTick;
                end;
                FrmLogon.SocketAddData(sizeof(cCNetState), @cCNetState);

            end;
        SM_HIDESPECIALWINDOW:
            begin
                PSTSHideSpecialWindow := @Code.data;
                case PSTSHideSpecialWindow^.rWindow of
                    WINDOW_GROUPWINDOW: FrmbatList.Visible := FALSE;
                    WINDOW_ROOMWINDOW: FrmbatList.Visible := FALSE;
                    WINDOW_GRADEWINDOW: FrmbatList.Visible := FALSE;
                    WINDOW_ITEMLOG: FrmDepository.Visible := FALSE;
                    WINDOW_ALERT: FrmDepository.Visible := FALSE;
                    WINDOW_AGREE: FrmcMessageBox.Visible := FALSE;
                    WINDOW_GUILDMAGIC: FrmMuMagicOffer.Visible := FALSE;
                end;
            end;
        SM_SHOWBATTLEBAR:
            begin
                PersonBat.MessageProcess(Code);
            end;
        SM_SHOWCENTERMSG:
            begin
                PTTSShowCenterMsg := @Code.data;
                if PTTSShowCenterMsg.rtype <> SHOWCENTERMSG_RollMSG then
                begin

                    str := GetwordString(PTTSShowCenterMsg.rText);
                    AddChat('【系统】' + str, PTTSShowCenterMsg.rColor, 0);
                end;
                PersonBat.MessageProcess(Code);
            end;
        SM_CHECK:
            begin
                CheckSome(Code);
            end;
        SM_LOGITEM:
            begin
                FrmDepository.MessageProcess(Code);
            end;
        SM_NPCITEM:
            begin
                frmNPCTrade.MessageProcess(Code);
            end;
        SM_SHOWSPECIALWINDOW:
            begin
                FrmPassEtc.MessageProcess(Code);
                frmNPCTrade.MessageProcess(Code);
                FrmDepository.MessageProcess(Code);
                FrmbatList.MessageProcess(Code);
                FrmcMessageBox.MessageProcess(Code);
                FrmMuMagicOffer.MessageProcess(Code);
                FrmUPdateItemLevel.MessageProcess(code);
                frmEmporia.MessageProcess(code);
                {
                FrmMunpaCreate.MessageProcess(Code);
                FrmMunpaimpo.MessageProcess(Code);
                FrmcMessageBox.MessageProcess(Code);
                FrmMunpaWarOffer.MessageProcess(Code);
                }
            end;
        SM_CHARMOVEFRONTDIEFLAG:
            begin                                                               // 烙矫荤侩 纳腐磐啊 磷篮荤恩困肺 瘤唱哎荐 乐绰 版快甫 TRUE肺 汲沥
                CharMoveFrontdieFlag := TRUE;
            end;
        SM_SHOWEXCHANGE:                                                        // 背券芒
            begin
                FrmExChange.MessageProcess(Code);
            end;
        SM_HIDEEXCHANGE:
            begin
                FrmExchange.Visible := FALSE;
                if FrmQuantity.Visible then FrmQuantity.Visible := FALSE;
            end;
        SM_SHOWCOUNT:                                                           // 荐樊芒
            begin
                FrmQuantity.MessageProcess(Code);
            end;

        // CM_SELECTCOUNT;
        SM_SHOWINPUTSTRING2: frmPopMsg.MessageProcess(code);

        SM_InputOk: frmPopMsg.MessageProcess(code);

        SM_SHOWINPUTSTRING:                                                     // 沤祸芒
            begin
                psShowInputString := @Code.Data;
                FrmSearch.QuantityID := psShowInputString.rInputStringid;
                FrmSearch.QuantityData := GetWordString(psShowInputString.rWordString);
                FrmSearch.SearchItem;
                FrmSearch.Visible := TRUE;
            end;
        SM_RAINNING:                                                            // 厚
            begin
                psRainning := @Code.Data;
                with psRainning^ do
                begin
                    BackScreen.SetRainState(TRUE, rspeed, rCount, rOverray, rTick, rRainType);
                end;
            end;
        SM_ReliveTime, SM_SelChar:
            begin
                PersonBat.MessageProcess(code);
                //pckey := @Code.data;
                //  LeftTextScroll.DiedTick := mmAnsTick; //GetItemLineTimeSec

                //  LeftTextScroll.ReliveTime := pckey.rkey;
            end;

        SM_BOSHIFTATTACK:
            begin
                pckey := @Code.data;
                if pckey^.rkey = 0 then
                begin
                    boShiftAttack := TRUE;

                end
                else
                begin
                    boShiftAttack := FALSE;
                end;
            end;
        SM_SOUNDEFFECT:                                                         //声音 应该 和动作捆绑
            begin
                // if not boUseSound then exit;
                psSoundString := @Code.Data;
                str := InttoStr(psSoundString.rsound) + '.wav';                 //(psSoundString^.rSoundName);
                TagetX := psSoundString.rX;
                TagetY := psSoundString.rY;

                //            if volume < -2000 then Volume := -2000;
                //            volume2 := FrmM.SoundManager.RangeVolume(CharPosX, CharPosY,TagetX,TagetY,volume);
                //            LogObj.WriteLog (5, 'SM_SoundE.. :'+ str);
                pan := FrmM.SoundManager.RangeCompute(CharPosX, TagetX);
                FrmM.SoundManager.NewPlayEffect(str, pan);
                //    FrmBottom.AddChat(format('SM_SOUNDEFFECT声音(%s)坐标[%d,%d]', [str, TagetX, Tagety]), ColorSysToDxColor(clred), 0);
            end;

        SM_SOUNDBASESTRING:                                                     // 硅版澜厩.... 1盒沥档焊促 变巴甸
            begin
                //                if not boUseSound then exit;
                psSoundBaseString := @Code.Data;
                str := GetWordString(psSoundBaseString^.rWordString);

                //                FrmM.SoundManager.PlayBaseAudio(str, psSoundBaseString^.rRoopCount);
                FrmM.SoundManager.PlayBaseAudioMp3(str, psSoundBaseString^.rRoopCount);
            end;

        SM_MOVINGMAGIC:
            begin
                psMovingMagic := @Code.Data;
                with psMovingMagic^ do
                begin
                    Cl := CharList.CharGet(rsid);
                    TL := CharList.CharGet(reid);
                    if Cl = nil then exit;
                    if Tl <> nil then
                    begin
                        xx := Tl.x;
                        yy := Tl.y;
                    end
                    else
                    begin
                        xx := rtx;
                        yy := rty;
                    end;
                    deg := GetDeg(Cl.x, Cl.y, xx, yy);
                    CharList.AddMagic(Cl.Id, reid, deg, rspeed, Cl.x, Cl.y, xx, yy, rmf, ref, mmAnstick, rType)
                end;
            end;
        SM_EVENTSTRING:
            begin
                psEventString := @Code.data;
                EventstringSet(GetwordString(psEventString^.rWordstring), psEventString.rKEY);

            end;
        SM_boMOVE:
            begin
                i := 1;
                n := WordComData_GETbyte(code, i);
                Cl := CharList.CharGet(CharCenterId);
                if Cl <> nil then
                begin
                    Cl.FboMOVE := boolean(n);
                end;
            end;
        SM_LockMoveTime:
            begin
                i := 1;
                n := WordComData_GETdword(code, i);
                CharCenterLockMoveTick := mmAnsTick + n;

                //Cl := CharList.CharGet(CharCenterId);
               // if Cl <> nil then
                //begin


                    // FrmBottom.AddChat(format('%s被锁定%d的时间不能移动', [cl.rName, n]), WinRGB(22, 22, 0), 0);
               // end;

            end;
        SM_MOTION:
            begin

                psMotion := @Code.Data;
                Cl := CharList.CharGet(psMotion^.rid);
                if Cl <> nil then
                begin
                    Cl.ProcessMessage(SM_MOTION, cl.dir, cl.x, cl.y, Cl.feature, psMotion^.rmotion);

                    // if CharCenterId = cl.id then
                   //  FrmBottom.AddChat(format('%D动作样式', [psMotion^.rmotion]), WinRGB(22, 22, 0), 0);
                end;
            end;
        SM_MOTION2:
            begin
                psMotion2 := @Code.Data;
                Cl := CharList.CharGet(psMotion2^.rid);
                if Cl <> nil then
                begin
                    Cl.ProcessMessage(SM_MOTION, cl.dir, cl.x, cl.y, Cl.feature, psMotion2^.rmotion);
                    Cl.rspecialMagicType := psMotion2.rEffectimg;
                    cl.rspecialEffectColor := psMotion2.rEffectColor;
                    cl.rspecialShowState := true;

                    // if CharCenterId = cl.id then
                   //  FrmBottom.AddChat(format('%D动作样式', [psMotion^.rmotion]), WinRGB(22, 22, 0), 0);
                end;
            end;
        SM_STRUCTED:
            begin
                psStructed := @Code.Data;
                case psStructed^.rRace of
                    RACE_HUMAN:
                        begin

                            Cl := CharList.CharGet(psStructed^.rid);
                            if Cl <> nil then
                            begin
                            //      if CharCenterId = cl.id then
                            //          FrmBottom.AddChat('血条', WinRGB(22, 22, 0), 0);
                                Cl.ProcessMessage(SM_STRUCTED, cl.dir, cl.x, cl.y, Cl.feature, psStructed^.rpercent);
                            //                                PersonBat.SelChar.UPStructedPercent(CL.id, CL.Structed);
                            end;
                        end;
                    RACE_DYNAMICOBJECT:
                        begin
                            Dt := CharList.GetDynamicObjItem(psStructed^.rid);
                            if Dt <> nil then Dt.ProcessMessage(SM_STRUCTED, psStructed^.rpercent);
                        end;
                end;
            end;
        SM_CHATMESSAGE:
            begin
                psChatMessage := @Code.data;

                str := GetwordString(psChatMessage^.rWordstring);
                cstr := str;
                if (cstr = '[') or (cstr = '<') then
                begin
                    if pos(':', str) > 1 then
                    begin
                        str := GetValidStr3(str, rdstr, ':');
                        str := ChangeDontSay(str);
                        rdstr := rdstr + ':' + str
                    end else rdstr := str;
                end else
                begin
                    str := ChangeDontSay(str);
                    rdstr := str;
                end;
                AddChat(rdstr, psChatMessage^.rFColor, psChatMessage^.rBColor);
                str := '';
                rdstr := '';
            end;
        SM_SAY:
            begin
                psSay := @Code.data;
                str := GetwordString(pssay^.rWordstring);
                str := GetValidStr3(str, rdstr, ':');
                str := ChangeDontSay(str);
                rdstr := rdstr + ' :' + str;
                AddChat(rdstr, WinRGB(28, 28, 28), 0);
                Cl := CharList.CharGet(psSay^.rid);
                if Cl <> nil then Cl.Say(rdstr);
                str := '';
                rdstr := '';
            end;
        SM_SAYUSEMAGIC:
            begin
                psSay := @Code.data;
                Cl := CharList.CharGet(psSay^.rid);
                if Cl <> nil then Cl.Say(GetwordString(pssay^.rWordstring));
            end;
        SM_MapObject: FrmMiniMap.MessageProcess(code);
        SM_HailFellow: HailFellowlist.MessageProcess(code);
        SM_NEWMAP:
            begin
                FrmMiniMap.StopAutoMOVE;
                CharList.Clear;
                psNewMap := @Code.data;
                CharCenterId := psNewMap^.rId;
                CharCenterName := (psNewMap^.rCharName);

                //  ObjectDataList.LoadFromFile((psNewMap^.rObjName));
                ObjectDataList.LoadFrom((psNewMap^.rObjName));
                TileDataList.LoadFrom((psNewMap^.rTilName));
                RoofDataList.LoadFrom((psNewMap^.rRofName));
                Map.LoadFrom((psNewMap^.rmapname), psNewMap^.rx, psNewMap^.ry);
                cMaper.cLoadMapFrom((psNewMap^.rmapname));
                cSearchPathClass.SetMaper(cMaper);
                {
                            ObjectDataList.LoadFromFile ('foxobj.Obj');
                            TileDataList.LoadFromFile ('foxtil.til');
                            RoofDataList.LoadFromFile ('');
                            Map.LoadFromFile ('fox.map', psNewMap^.rx, psNewMap^.ry);
                }
                //            MapName := StrPas (@psNewMap^.rmapname);
                Map.SetCenter(psNewMap^.rx, psNewMap^.ry);                      //设置 自己 位置
                BackScreen.SetCenter(psNewMap^.rx * UNITX, psNewMap^.ry * UNITY);
                BackScreen.Back.Clear(0);

                FrmBottom.Visible := TRUE;
                FrmBottom.EdChat.SetFocus;
                // FrmBottom.BtnItemClick(nil);
                FrmAttrib.Visible := false;
                FrmMiniMap.MessageProcess(code);
                //  FrmBottom.AddChat(format('新地图%s', [psNewMap.rMapName]), WinRGB(22, 22, 0), 0);
                FrmProcession.FCharList.Clear;
            end;
        SM_SHOWDYNAMICOBJECT:                                                   // DynamicItem 010102 ankudo 空釜酒捞袍 Add
            begin
                PSShowDynamicObject := @Code.Data;
                with PSShowDynamicObject^ do
                begin
                    Fillchar(DynamicGuard, sizeof(DynamicGuard), 0);
                    DynamicGuard.aCount := 0;
                    for i := 0 to 10 - 1 do
                    begin
                        if (rGuardX[i] = 0) and (rGuardY[i] = 0) then break;
                        DynamicGuard.aGuardX[i] := rGuardX[i];
                        DynamicGuard.aGuardY[i] := rGuardY[i];
                        inc(DynamicGuard.aCount);
                    end;
                    CharList.AddDynamicObjItem((rNameString), rid, rx, ry, rshape, rFrameStart, rFrameEnd, rstate, DynamicGuard);
                end;
            end;
        SM_CHANGESTATE:                                                         // DynamicItem 010106 ankudo 空釜酒捞袍狼 惑怕函版
            begin
                PSChangeState := @Code.Data;

                with PSChangeState^ do
                begin
                    CharList.SetDynamicObjItem(rid, rState, rFrameStart, rFrameEnd);
                end;
            end;
        SM_HIDEDYNAMICOBJECT:                                                   // DynamicItem 010106 ankudo 空釜酒捞袍 昏力
            begin
                PSHide := @Code.Data;
                with PSHide^ do
                begin
                    CharList.DeleteDynamicObjItem(rid);
                end;
            end;
        SM_SHOWITEM:
            begin
                psShowItem := @Code.Data;
                with psshowItem^ do
                begin
                    CharList.AddItem((rNameString), rRace, rid, rx, ry, rshape, rcolor);
                    fwItemList.add2((rNameString), rRace, rid, rx, ry, rshape, rcolor);
                end;
            end;
        SM_HIDEITEM:
            begin
                psHide := @Code.Data;
                with pshide^ do
                begin
                    CharList.DelItem(rid);
                    fwItemList.del(rid);
                end;
            end;
        SM_ShowVirtualObject:
            begin
                pssVirtualObject := @Code.Data;
                //aName: string; aRace: byte; aId, ax, ay, aw, ah
                CharList.VirtualObjectList.add(pssVirtualObject^.rNameString,
                    pssVirtualObject^.rRace, pssVirtualObject^.rId,
                    pssVirtualObject^.rx, pssVirtualObject^.ry,
                    pssVirtualObject^.Width, pssVirtualObject^.Height
                    );
            end;
        SM_HIDEVirtualObject:
            begin
                psHide := @Code.Data;
                CharList.VirtualObjectList.del(psHide^.rId);
            end;
        SM_SHOW_Npc_MONSTER:
            begin
                pSShow_Npc_MONSTER := @Code.Data;
                with pSShow_Npc_MONSTER^ do
                begin

                    FILLCHAR(AFeature, SIZEOF(AFeature), 0);

                    AFeature.rrace := rFeature_npc_MONSTER.rrace;
                    AFeature.rMonType := rFeature_npc_MONSTER.rMonType;
                    AFeature.rTeamColor := rFeature_npc_MONSTER.rTeamColor;
                    AFeature.rImageNumber := rFeature_npc_MONSTER.rImageNumber;
                    AFeature.raninumber := rFeature_npc_MONSTER.raninumber;
                    AFeature.rHideState := rFeature_npc_MONSTER.rHideState;
                    AFeature.AttackSpeed := rFeature_npc_MONSTER.AttackSpeed;
                    AFeature.WalkSpeed := rFeature_npc_MONSTER.WalkSpeed;
                    AFeature.rfeaturestate := rFeature_npc_MONSTER.rfeaturestate;
                    str := GetWordString(rWordString);
                    CharList.CharAdd(str, rid, rdir, rx, ry, AFeature);

                end;
            end;
        SM_SHOW:                                                                //显示
            begin
                psShow := @Code.Data;
                with psshow^ do
                begin
                    //                    cMaper.UserMove(rid, rx, ry);
                    str := GetWordString(rWordString);
                    CharList.CharAdd(str, rid, rdir, rx, ry, rFeature);
                    if rFeature.rrace = RACE_HUMAN then
                        FrmProcession.FCharList.ADD(rid, STR, '');
{$IFDEF showTestLog}
                    //      FrmBottom.AddChat(format('%D显示%s', [rid, str]), WinRGB(22, 22, 0), 0);
{$ENDIF}
                    // FrmBottom.AddChat(format('%D显示%s', [rid, str]), WinRGB(22, 22, 0), 0);
                end;
            end;
        SM_HIDE:                                                                //消失
            begin
                psHide := @Code.Data;
                with pshide^ do
                begin
{$IFDEF showTestLog}
                    // Cl := CharList.CharGet(rid);
                     //  if Cl <> nil then cMaper.UserMove(0, cl.x, cl.y);
                   //  if cl <> nil then
                     //    FrmBottom.AddChat(format('%s,%D隐藏', [cl.rName, rid]), WinRGB(22, 22, 0), 0)
                    // else FrmBottom.AddChat(format('%s,%D隐藏', ['错误', rid]), WinRGB(22, 22, 0), 0);
{$ENDIF}

                    { Cl := CharList.CharGet(rid);
                     if cl = nil then
                         FrmBottom.AddChat(format('%s,%D隐藏', ['NIL', rid]), WinRGB(22, 22, 0), 0)
                     else
                         FrmBottom.AddChat(format('%s,%D隐藏', [cl.rName, rid]), WinRGB(22, 22, 0), 0);
                         }
                    CharList.CharDelete(rid);
                    FrmProcession.FCharList.DEL(rid);
                end;
            end;
        SM_SETPOSITION:                                                         //？？
            begin
                psSetPosition := @Code.Data;
                with psSetPosition^ do
                begin
                    //  cMaper.UserMove(rid, rx, ry);
                    Cl := CharList.CharGet(rid);
                    if Cl <> nil then
                    begin
                        Cl.ProcessMessage(SM_SETPOSITION, rdir, rx, ry, Cl.feature, 0);
{$IFDEF showTestLog}
                        // if CharCenterId = cl.id then
                            // FrmBottom.AddChat('设置位置', WinRGB(22, 22, 0), 0);
{$ENDIF}

                    end;
                end;
            end;
        SM_TURN:                                                                //方向
            begin
                psTurn := @Code.Data;
                with psTurn^ do
                begin
                    // cMaper.UserMove(rid, rx, ry);
                    Cl := CharList.CharGet(rid);

                    if Cl <> nil then
                    begin
                        Cl.ProcessMessage(SM_TURN, rdir, rx, ry, Cl.feature, 0);

                    end;
                end;
            end;
        SM_Effect:
            begin
                pSEffect := @Code.Data;
                Cl := CharList.CharGet(pSEffect^.rid);
                if Cl <> nil then
                begin
                    if pSEffect.reffectNum > 255 then
                        cl.AddBgEffect(Cl.x, Cl.y, pSEffect.reffectNum - 1, pSEffect.reffecttype, FALSE)
                    else
                        cl.AddBgEffect(Cl.x, Cl.y, pSEffect.reffectNum - 1, pSEffect.reffecttype, true);
                    //FrmBottom.AddChat('普通效果', WinRGB(22, 22, 0), 0);
                end;
            end;

        SM_MagicEffect:                                                         //步法
            begin
                pSMagicEffect := @Code.Data;
                Cl := CharList.CharGet(pSMagicEffect^.rid);
                if Cl <> nil then
                begin
                    // cl.Effectmove := true;
                    if pSMagicEffect.reffectNum = 5001 then
                    begin
                        cl.AddMagicEffect(Cl.x, Cl.y, pSMagicEffect.reffectNum - 1, pSMagicEffect.reffecttype, cl.dir * 5, cl.dir * 5 + 5, FALSE);
                    end
                    else
                        cl.AddMagicEffect(Cl.x, Cl.y, pSMagicEffect.reffectNum - 1, pSMagicEffect.reffecttype, 0, -1, FALSE);
                    //FrmBottom.AddChat('技能效果', WinRGB(22, 22, 0), 0);
                    //FrmBottom.AddChat(format('%D武功效果 方向%d', [pSMagicEffect.reffectNum, cl.dir]), WinRGB(22, 22, 0), 0);
                end;
            end;
        SM_CHANGEMagic:
            begin
                pSCHANGEMagic := @Code.Data;
                Cl := CharList.CharGet(pSCHANGEMagic^.rid);
                if Cl <> nil then
                begin
                    cl.rspecialMagicType := pSCHANGEMagic.rMagictype;
                    cl.rspecialEffectColor := pSCHANGEMagic.rMagicColorIndex;
                    //FrmBottom.AddChat(format('武功效果 改变(%d,%d)攻击速度%d', [pSCHANGEMagic.rMagictype, pSCHANGEMagic.rMagicColorIndex, pSCHANGEMagic.rAttackSpeed]), WinRGB(22, 22, 0), 0);
                end;
            end;
        SM_MOVE:                                                                //移动
            begin
                psMove := @Code.Data;
                with psMove^ do
                begin
                    // cMaper.UserMove(rid, rx, ry);
                    Cl := CharList.CharGet(psMove^.rid);
                    if Cl <> nil then
                    begin
                        Cl.ProcessMessage(SM_MOVE, rdir, rx, ry, Cl.feature, 0);
                        if CharCenterId = cl.id then
                            FrmBottom.AddChat('移动', WinRGB(22, 22, 0), 0);

                    end;
                end;
            end;
        SM_CHANGEFEATURE_NameColor:                                             //改变 名字颜色
            begin
                pSNameColor := @Code.Data;
                Cl := CharList.CharGet(pSNameColor^.rid);
                if Cl <> nil then
                    cl.Feature.rNameColor := pSNameColor.rNameColor;
            end;
        SM_die_Npc_MONSTER:
            begin
                pSdie_Npc_MONSTER := @Code.data;
                with pSdie_Npc_MONSTER^ do
                begin
                    Cl := CharList.CharGet(rid);
                    if Cl <> nil then
                    begin
                        afeature := Cl.feature;
                        afeature.rfeaturestate := rfeaturestate;
                        Cl.ProcessMessage(SM_CHANGEFEATURE, cl.dir, cl.x, cl.y, afeature, 0);
                        exit;
                    end;
                end;
            end;
        SM_CHANGE_Npc_MONSTER:                                                  //改变 状态
            begin
                PSChangeFeature_Npc_MONSTER := @Code.data;
                with PSChangeFeature_Npc_MONSTER^ do
                begin

                    FILLCHAR(AFeature, SIZEOF(AFeature), 0);
                    AFeature.rrace := rFeature_npc_MONSTER.rrace;
                    AFeature.rMonType := rFeature_npc_MONSTER.rMonType;
                    AFeature.rTeamColor := rFeature_npc_MONSTER.rTeamColor;
                    AFeature.rImageNumber := rFeature_npc_MONSTER.rImageNumber;
                    AFeature.raninumber := rFeature_npc_MONSTER.raninumber;
                    AFeature.rHideState := rFeature_npc_MONSTER.rHideState;
                    AFeature.AttackSpeed := rFeature_npc_MONSTER.AttackSpeed;
                    AFeature.WalkSpeed := rFeature_npc_MONSTER.WalkSpeed;
                    AFeature.rfeaturestate := rFeature_npc_MONSTER.rfeaturestate;

                    Cl := CharList.CharGet(rid);
                    if Cl <> nil then
                    begin
                        Cl.ProcessMessage(SM_CHANGEFEATURE, cl.dir, cl.x, cl.y, Afeature, 0);
                        exit;
                    end;
                end;
            end;
        SM_CHANGEFEATURE:                                                       //改变 状态
            begin
                psChangeFeature := @Code.data;

                if psChangeFeature.rId = CharCenterId then
                begin
                    if frmCharAttrib.Visible then frmCharAttrib.update;

                end;
                Cl := CharList.CharGet(psChangeFeature^.rid);
                if Cl <> nil then
                begin
                    // if CharCenterId = cl.id then
                   // FrmBottom.AddChat('外观基本数据大改变,攻击速度' + inttostr(psChangeFeature.rFeature.AttackSpeed), WinRGB(22, 22, 0), 0);

                    Cl.ProcessMessage(SM_CHANGEFEATURE, cl.dir, cl.x, cl.y, psChangeFeature.rfeature, 0);
                    //                    PersonBat.SelChar.UPCHANGEFEATURE(psChangeFeature^.rid);
                    if cl.id = CharCenterId then
                    begin
                        case cl.Feature.rfeaturestate of
                            wfs_normal: MsgCmdarr[cm_move] := 60;
                            wfs_care: MsgCmdarr[cm_move] := 60;
                            wfs_sitdown: MsgCmdarr[cm_move] := 60;
                            wfs_die: MsgCmdarr[cm_move] := 60;
                            wfs_running: MsgCmdarr[cm_move] := 30;
                            wfs_running2: MsgCmdarr[cm_move] := 24;
                        else MsgCmdarr[cm_move] := 60;
                        end;

                    end;
                    exit;
                end;
                { // 盔夯
                Cl := CharList.GetChar (psChangeFeature^.rid);
                if Cl <> nil then begin
                   Cl.ProcessMessage (SM_CHANGEFEATURE, cl.dir, cl.x, cl.y, psChangeFeature.rfeature, 0);
                   exit;
                end;
                }
                ItemClass := CharList.GetItem(psChangeFeature^.rid);
                if ItemClass <> nil then
                begin
                    ItemClass.SetItemAndColor(psChangeFeature^.rFeature.rImageNumber, psChangeFeature^.rFeature.rImageColorIndex);
                    exit;
                end;
            end;
        SM_CHANGEPROPERTY:                                                      //改变 名字样
            begin
                //            LogObj.WriteLog(5, 'SM_CHANGEPROPERTY');
                psChangeProperty := @Code.data;
                Cl := CharList.CharGet(psChangeProperty^.rid);
                if Cl <> nil then
                begin
                    str := GetWordString(psChangeProperty.rWordString);
                    Cl.ChangeProperty(str);
                    exit;
                end;
                ItemClass := CharList.GetItem(psChangeProperty^.rid);
                if ItemClass <> nil then
                begin
                    ItemClass.ChangeProperty(psChangeProperty);
                    exit;
                end;
            end;
    end;
end;

procedure TFrmM.Time1TimerTimer(Sender: TObject);
var
    CMouseEvent: TCMouseEvent;
begin
    //目前 废弃 的
    {CMouseEvent.rmsg := CM_MOUSEEVENT;
    move(eventBuffer, CMouseEvent.revent, sizeof(eventBuffer));
    FrmLogon.SocketAddData(sizeof(CMouseEvent), @CMouseEvent);
    Fillchar(eventBuffer, sizeof(eventBuffer), 0);
    }
end;

procedure TFrmM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Timer2_dx.Enabled := FALSE;
    if FrmBottom.Visible then
    begin
        if FrmLogon.PacketSender = nil then exit;
        if FrmLogon.sckConnect.Socket.Connected = false then exit;
        FrmBottom.saveAllKey;
    end;
end;

procedure TFrmM.move_win_form_set(sender: TForm; x, y: integer);
begin
    move_win_form := sender;
    move_win_Or_baseX := x;
    move_win_Or_baseY := y;

end;

procedure TFrmM.move_win_form_Align(sender: TForm; Align: Tmove_win_form);
var
    MAXx2, MAXy2,
        x, y,
        maxWidth,
        maxHeight: integer;
begin
    maxWidth := FrmM.Width;
    if FrmAttrib.Visible then
        maxWidth := maxWidth - FrmAttrib.Width;
    maxHeight := FrmM.Height;
    if FrmBottom.Visible then
        maxHeight := maxHeight - FrmBottom.ClientHeight - 30;
    case Align of
        mwfLeft:
            begin
                sender.Left := 0;
                sender.Top := (maxHeight - sender.Height) div 2;
            end;
        mwfTop:
            begin
                sender.Left := (maxWidth - sender.Width) div 2;
                sender.Top := 0;
            end;
        mwfRight:
            begin
                sender.Left := maxWidth - sender.Width;
                sender.Top := (maxHeight - sender.Height) div 2;
            end;
        mwfBottom:
            begin
                sender.Left := (maxWidth - sender.Width) div 2;
                sender.Top := (maxHeight - sender.Height);
            end;
        mwfCenterLeft:
            begin
                maxWidth := FrmM.ClientWidth;
                maxWidth := maxWidth - FrmAttrib.Width;
                maxHeight := FrmM.ClientHeight;

                maxHeight := maxHeight - FrmBottom.Height;
                sender.Left := (maxWidth - sender.Width) div 2;
                sender.Top := (maxHeight - sender.Height) div 2;
            end;
        mwfCenter:
            begin
                sender.Left := (maxWidth - sender.Width) div 2;
                sender.Top := (maxHeight - sender.Height) div 2;
            end;

    end;

end;

procedure TFrmM.move_win_form_Paint(aTick: integer);
var
    MAXx2, MAXy2,
        x, y,
        maxWidth,
        maxHeight
        , alenft, atop
        : integer;

begin
    if (aTick - move_winClickTick) < 5 then exit;
    move_winClickTick := atick;
    x := move_win_X;
    y := move_win_y;
    //self.Caption := inttostr(x) + ':' + inttostr(y);
    if move_win_form <> nil then
    begin
        alenft := (X - move_win_Or_baseX);
        atop := (y - move_win_Or_baseY);

        if alenft < 0 then alenft := 0;
        if atop < 0 then atop := 0;
        MAXx2 := alenft + move_win_form.Width;
        MAXy2 := atop + move_win_form.Height;
        maxWidth := FrmM.ClientWidth;
        if FrmAttrib.Visible then
            maxWidth := maxWidth - FrmAttrib.Width;
        maxHeight := FrmM.ClientHeight;
        if FrmBottom.Visible then
            maxHeight := maxHeight - FrmBottom.Height;
        if MAXx2 > maxWidth then alenft := maxWidth - move_win_form.Width;
        if MAXy2 > maxHeight then atop := maxHeight - move_win_form.Height;

        move_win_form.Left := alenft;
        move_win_form.Top := atop;
        UpdateWindow(move_win_form.Handle);
        Application.ProcessMessages;
    end;                                                                        // else self.Caption := self.Caption + '[nil]';

end;

const
    NetStateDelayTick = 500;
var
    iMoving: byte = 3;
    DrawTick: integer = 0;

procedure TFrmM.EventstringSet(s: string; key: byte);
begin
    case key of
        EventString_Attrib:
            begin
                FrmAttrib.LbEvent.Caption := s;
                FrmBottom.LbEvent.Caption := s;
                EventTick_Attrib := mmAnsTick;
            end;
        EventString_Magic:
            begin
                Event_Magic_text := s;
                EventTick_Magic := mmAnsTick;
            end;
    end;
end;

procedure TFrmM.Eventstringdisplay(aTick: integer);
var
    i: integer;
begin
    if EventTick_Attrib <> 0 then
    begin
        if EventTick_Attrib + 150 < aTick then
        begin
            EventTick_Attrib := 0;

            FrmAttrib.LbEvent.Caption := '^^';
            FrmAttrib.LbEvent.Font.Color := (clWhite);

            FrmBottom.LbEvent.Caption := '^^';
            FrmBottom.LbEvent.FontColor := ColorSysToDxColor(clWhite);

        end else
        begin
            if EventTick_Tick + 2 < aTick then
            begin

                FrmAttrib.LbEvent.Font.Color := (Random(clWhite));
                FrmBottom.LbEvent.FontColor := ColorSysToDxColor(Random(clWhite));
            end;
        end;

    end;
    if EventTick_Magic <> 0 then
    begin
        if EventTick_Magic + 150 < aTick then                                   //变化 的最大时间
        begin
            EventTick_Magic := 0;

            FrmBottom.UseMagic1.FontColor := ColorSysToDxColor(clWhite);
            FrmBottom.UseMagic2.FontColor := ColorSysToDxColor(clWhite);
            FrmBottom.UseMagic3.FontColor := ColorSysToDxColor(clWhite);
            FrmBottom.UseMagic4.FontColor := ColorSysToDxColor(clWhite);

        end else
        begin
            // FrmAttrib.LbEvent.FontColor := ColorSysToDxColor( Random(clWhite));
            for i := 0 to high(FrmBottom.UseMagicarr) do
            begin
                if EventTick_Tick + 2 < aTick then                              //变化 的最短时间
                begin
                    if FrmBottom.UseMagicarr[i].Caption = Event_Magic_text then
                    begin
                        FrmBottom.UseMagicarr[i].FontColor := ColorSysToDxColor(Random(clWhite));
                    end else
                        FrmBottom.UseMagicarr[i].FontColor := ColorSysToDxColor(clWhite);
                end;
            end;
        end;
    end;
    if EventTick_Tick + 2 < aTick then                                          //变化 的最短时间
    begin
        EventTick_Tick := aTick;
    end;
end;

procedure TFrmM.Timer2_dx1Timer(Sender: TObject; LagCount: Integer);

var
    i: integer;
    Cl: TCharClass;
begin
    {
    if FrmBottom.Visible = TRUE then begin
       if mmAnsTick > NetStateDelayTick + DrawTick then begin
          cCKey.rmsg := CM_NETSTATE;
          cCKey.rkey := 0;
          FrmLogon.SocketAddData (sizeof(TCKey), @cCKey);
          DrawTick := mmAnsTick;
       end;
    end;

    }
  //  if not DXDraw.FACTIVATE then exit;

    FrmEmail.update(mmAnsTick);
    // Caption := format(Conv('风云OL :%s:%d:%d:%d'), [CharCenterName, CharPosX, CharPosY, 0]);
    FrmBottom.LbPos.Caption := format('%d:%d', [CharPosX, CharPosY]);
    if boDirectClose then Close;

    if not DXDraw.CanDraw then exit;

    if oldMouseInfo <> mouseinfostr then                                        //mouseinfostr  鼠标 当前 提示 文字
    begin
        oldmouseinfo := mouseinfostr;
        FrmAttrib.LbWindowName.Caption := mouseinfostr;
    end;

    SoundManager.UpDate(mmAnsTick);

    CharList.Update(mmAnsTick);
    Map.DrawMap(mmAnstick);
    CharList.Paint(mmAnstick);
    CharList.UpDataBgEffect(mmAnstick);
    Cl := CharList.CharGet(CharCenterId);
    if Cl <> nil then
        if not Map.IsInArea(CL.x, CL.y) then
            Map.DrawRoof(mmAnsTick);

    CharList.PaintText(nil);
    PersonBat.AdxPaint(mmAnsTick);
   // CharList.VirtualObjectList.Paint;//测试使用
    //if FrmBottom.Visible then
    //    MinMap.DrawMinMap(mmAnsTick);

    if boShowChat then DrawChatList;

    if FrmMiniMap.Visible then FrmMiniMap.SetCenterID;

    if FrmAttrib.Visible then FrmAttrib.DrawWearItem;

    if not FrmBottom.Visible then BackScreen.Clear;

    BackScreen.UpdateRain;                                                      //天气 效果

    move_win_form_Paint(mmAnstick);                                             //移动 窗口  处理

    //FrmWearItem.update(mmAnsTick);

    if FrmBottom.Visible then
    begin
        BackScreen.Back.DrawImage(BottomUpImage, 0, 600 - FrmBottom.ClientHeight - BottomUpImage.Height, TRUE);
        FrmBottom.A2Form.AdxPaint(BackScreen.Back);
        energyGraphicsclass.AdxPaint(BackScreen.Back);
        FrmLittleMap.A2Form.AdxPaint(BackScreen.Back);
        FrmGameToolsNew.A2Form.AdxPaint(BackScreen.Back);
    end;

    for i := FormList.Count - 1 downto 0 do
    begin
        if PTFormData(formList[i])^.rForm.Visible then
            if (PTFormData(formList[i])^.rForm <> FrmBottom)
                and (PTFormData(formList[i])^.rForm <> FrmLittleMap)
                and (PTFormData(formList[i])^.rForm <> FrmGameToolsNew) then
                PTFormData(FormList[i])^.rA2Form.AdxPaint(BackScreen.Back);
    end;

    GameHint.update(mmAnsTick);

    if FrmAttrib.FITEMA2Hint.FVisible then
        FrmAttrib.FITEMA2Hint.DrawBack(BackScreen.Back, 0, 0);
    //if FrmMiniMap.Visible then FrmMiniMap.SetCenterID;

    if FrmAttrib.Visible then BackScreen.Back.DrawImage(AttribLeftImage, ClientWidth - AttribLeftImage.Width - FrmAttrib.Width, 0, TRUE);

    //ObjectDataList.UsedTickUpdate(mmAnsTick);
    //TileDataList.UsedTickUpdate(mmAnsTick);
    AtzClass.UpDate(mmAnsTick);

    EventStringdisplay(mmAnsTick);


    if not BackScreen.Draw_Surface(DxDraw.Surface) then
    begin
        BackScreen.DrawCanvas(DxDraw.Surface.Canvas, 0, 0);
        DxDraw.Surface.Canvas.Release;
    end;

    DxDraw.Flip;
    AutoHit_update(mmAnsTick);
    if Cl <> nil then
    begin
        case Cl.Feature.rActionState of                                         //rActionState服务器 控制
            as_Free:
                MoveProcess;
            as_ice: ;
            as_slow:
                begin
                    if iMoving > 1 then
                    begin
                        MoveProcess;
                        iMoving := 3;
                    end;
                    Dec(iMoving);
                end;
        end;

    end;
    CheckAndSendClick;                                                          //发送
end;

procedure TFrmM.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
    Y: Integer);
begin
    //
end;

procedure TFrmM.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    {  CanClose := bodirectclose;
      if not CanClose then
      begin

          FrmBottom.BtnExitClick(nil);
      end;
      }
end;

procedure TFrmM.Timer2_dxTimer(Sender: TObject);
begin
    mmAnsTick := (timeGetTime - mmAnsTick0) div 10;
    if (mmAnsTick - dxTick) >= 100 then
    begin
        if Timer2_dx.Interval <> 32 then Timer2_dx.Interval := 32;
        dxTick := mmAnsTick;
        Caption := format('风云OL:%s:%s(%d)(%dms)', [CharCenterName, datetimetostr(now()), dxTicknum, netPing]);
        dxTicknum := 0;
    end;

    begin
        //2009.0703修改
        //FrmEnergy.update(mmAnsTick);

        energyGraphicsclass.update(mmAnsTick);
        inc(dxTicknum);
        // dxSPEEDtick := mmAnsTick;
        frmPopMsg.update(mmAnsTick);
        PersonBat.update(mmAnsTick);
        Timer2_dx1Timer(sender, 0);
    end;
end;

{ TGameHint }

{procedure TGameHint.pos(ax, ay:Integer);
begin
    A2Hint_X := ax;
    A2Hint_Y := ay;
end;
 }

procedure TGameHint.settext(aid: integer; astr: string);
begin
    if A2Hint_id = aid then
    begin
        if A2Hint_state = 1 then
        begin
            A2Hint_text := astr;
            exit;
        end;
        if A2Hint_state = 2 then
        begin
            if A2Hint_text = astr then
            begin
                A2Hint.setVisible;
                exit;
            end;
        end;
    end else
    begin
        Close;
    end;
    A2Hint_id := aid;
    A2Hint_text := astr;
    A2Hint_state := 1;
    A2Hint_time := mmAnsTick + 20;
end;

procedure TGameHint.update(curtick: integer);
begin
    case A2Hint_state of
        1:
            begin
                if curtick > A2Hint_time then
                begin
                    A2Hint_time := curtick;
                    A2Hint.setText(A2Hint_text);
                    A2Hint.FVisible := true;
                    inc(A2Hint_state);
                end;
            end;
        2:
            begin
//                A2Hint.DrawBack(BackScreen.Back, move_win_X, move_win_y);
                A2Hint.DrawBack(BackScreen.Back, move_win_X, move_win_y);
            end;
        10:                                                                     //重复打开
            begin

            end;
    else ;
    end;

end;

constructor TGameHint.Create;
begin
    A2Hint := TA2Hint.Create;
    A2Hint.Ftype := hstTransparent;
 //   A2Hint.Ftype := hstImageOveray;
 //   A2Hint.FImageOveray := 10;
    A2Hint_id := 0;
    A2Hint_text := '';
    A2Hint_state := 0;
    A2Hint_time := 0;
    A2Hint_X := 0;
    A2Hint_Y := 0;
end;

destructor TGameHint.Destroy;
begin
    A2Hint.Free;
    inherited;
end;

procedure TGameHint.Close;
begin
    A2Hint.setText('');
    A2Hint_text := '';
    A2Hint_state := -1;
    A2Hint_time := 0;
end;

end.

