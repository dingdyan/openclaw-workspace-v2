unit FGameTools;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, RzButton, RzRadChk, StdCtrls, RzLabel, Mask, RzEdit, RzSpnEdt,
    ComCtrls, RzCmboBx, RzLstBox, RzTabs, RzPanel, RzStatus, ExtCtrls, DateUtils;

type
    Twgitemdata = record
        aItemName:string[64];
        aRace:byte;
        aId, ax, ay, aItemShape, aItemColor:integer;
        runtime:tdatetime;
    end;
    pTwgitemdata = ^Twgitemdata;

    Twg_ItemList = class
    private

    public
        data:tlist;
        constructor Create;
        destructor Destroy; override;
        procedure add(aitem:Twgitemdata);
        procedure Clear;
        procedure del(aid:integer);
        procedure add2(aItemName:string; aRace:byte; aId, ax, ay, aItemShape, aItemColor:integer);

    end;

    TfrmGameTools = class(TForm)
        RzPageControl1:TRzPageControl;
        TabSheet3:TRzTabSheet;
        TabSheet4:TRzTabSheet;
        RzCheckBox_itemlist_f:TRzCheckBox;
        RzCheckBox_shiqu:TRzCheckBox;
        RzSpinEdit_OutPower:TRzSpinEdit;
        RzCheckBox2:TRzCheckBox;
        RzSpinEdit_Magic:TRzSpinEdit;
        RzCheckBox3:TRzCheckBox;
        RzSpinEdit_Life:TRzSpinEdit;
        RzCheckBox4:TRzCheckBox;
        RzSpinEdit_inPower:TRzSpinEdit;
        RzSpinEdit_itemtime:TRzSpinEdit;
        RzLabel1:TRzLabel;
        RzCheckBox1:TRzCheckBox;
        RzComboBox2:TRzComboBox;
        RzStatusBar1:TRzStatusBar;
        RzGroupBox1:TRzGroupBox;
        RzBitBtn1:TRzBitBtn;
        RzBitBtn2:TRzBitBtn;
        RzEdit1:TRzEdit;
        RzPanel1:TRzPanel;
        RzBitBtn5:TRzBitBtn;
        RzLabel2:TRzLabel;
        RzPanel2:TRzPanel;
        RzBitBtn4:TRzBitBtn;
        RzListBox1:TRzListBox;
        RzLabel3:TRzLabel;
        RzLabel4:TRzLabel;
        RzLabel5:TRzLabel;
        RzLabel6:TRzLabel;
        RzLabel7:TRzLabel;
        RzBitBtn3:TRzBitBtn;
        RzComboBox1:TRzComboBox;
        RzComboBox3:TRzComboBox;
        RzComboBox4:TRzComboBox;
        Timer1:TTimer;
        TabSheet1:TRzTabSheet;
        RzLabel8:TRzLabel;
        RzSpinEdit_auto_say_time:TRzSpinEdit;
        RzLabel9:TRzLabel;
        RzMemo_auto_say_text:TRzMemo;
        RzLabel10:TRzLabel;
        RzCheckBox_auto_say_check:TRzCheckBox;
        TabSheet2:TRzTabSheet;
        RzCheckBox_MOVE_moveOpenMagic:TRzCheckBox;
        RzCheckBox_move_autoMove:TRzCheckBox;
        RzSpinEdit_move_1_x:TRzSpinEdit;
        RzSpinEdit_move_1_y:TRzSpinEdit;
        RzSpinEdit_move_2_x:TRzSpinEdit;
        RzSpinEdit_move_2_y:TRzSpinEdit;
        RzLabel11:TRzLabel;
        RzLabel12:TRzLabel;
        TabSheet5:TRzTabSheet;
        RzCheckBox_Hit_not_Shift:TRzCheckBox;
        RzCheckBox_Hit_not_Ctrl:TRzCheckBox;
        RzCheckBox_hit_autoMove:TRzCheckBox;
        TabSheet6:TRzTabSheet;
        RzCheckBox5:TRzCheckBox;
        RzCheckBox6:TRzCheckBox;
        RzCheckBox7:TRzCheckBox;
        RzCheckBox8:TRzCheckBox;
        RzCheckBox9:TRzCheckBox;
        RzComboBox5:TRzComboBox;
        procedure FormCreate(Sender:TObject);
        procedure RzBitBtn5Click(Sender:TObject);
        procedure FormShow(Sender:TObject);
        procedure RzBitBtn1Click(Sender:TObject);
        procedure RzBitBtn4Click(Sender:TObject);
        procedure Timer1Timer(Sender:TObject);
        procedure FormDestroy(Sender:TObject);
        procedure RzBitBtn3Click(Sender:TObject);
        procedure RzBitBtn2Click(Sender:TObject);
        procedure RzSpinEdit_auto_say_timeChange(Sender:TObject);
        procedure RzCheckBox5Click(Sender:TObject);
        procedure RzCheckBox6Click(Sender:TObject);
        procedure RzCheckBox7Click(Sender:TObject);
        procedure RzCheckBox8Click(Sender:TObject);
        procedure RzCheckBox9Click(Sender:TObject);
        procedure RzCheckBox_hit_autoMoveClick(Sender:TObject);
    private
        { Private declarations }
    public
        { Public declarations }
        ItemT1:tdatetime;
        ItemT2:tdatetime;
        ItemT3:tdatetime;
        ItemT4:tdatetime;
        Itemshiqu:tdatetime;
        auto_say_T:tdatetime;
        auto_Move_T:tdatetime;

        auto_say_id:integer;
        procedure ItemDBlick(akey:integer);
        procedure Item_Click(aid:integer);
        function isItemList(astr:string):boolean;
        procedure savetofile(afilenam:string);
        procedure loadFromfile(afilenam:string);
    end;

var
    ffrmGameTools   :TfrmGameTools;
    awItemList       :Twg_ItemList;
    MoveMagicKey    :integer;
    MoveMagicWindow :integer;
implementation

uses FMain, fattrib, AUtil32, FLogOn, CharCls, Deftype, FBottom, uPersonBat,
    FMiniMap, FnewMagic;

{$R *.dfm}

constructor Twg_ItemList.Create();
begin
    data := tlist.Create;
end;

destructor Twg_ItemList.Destroy;
begin
    Clear;
    data.Free;
    inherited destroy;
end;

procedure Twg_ItemList.add2(aItemName:string; aRace:byte; aId, ax, ay, aItemShape, aItemColor:integer);
var
    aitem           :Twgitemdata;
begin
    aitem.aItemName := aItemName;
    aitem.aRace := aRace;
    aitem.aId := aId;
    aitem.ax := ax;
    aitem.ay := ay;
    aitem.aItemShape := aItemShape;
    aitem.aItemColor := aItemColor;
    add(aitem);
end;

procedure Twg_ItemList.add(aitem:Twgitemdata);
var
    pp              :pTwgitemdata;
begin
    new(pp);
    pp^ := aitem;
    pp.runtime := 0;
    data.Add(pp);
end;

procedure Twg_ItemList.del(aid:integer);
var
    i               :integer;
    pp              :pTwgitemdata;
begin
    for i := 0 to data.Count - 1 do
    begin
        pp := data.Items[i];
        if pp.aId = aid then
        begin
            dispose(pp);
            data.Delete(i);

            exit;
        end;
    end;

end;

procedure Twg_ItemList.Clear;
var
    i               :integer;
    pp              :pTwgitemdata;
begin
    for i := 0 to data.Count - 1 do
    begin
        pp := data.Items[i];
        dispose(pp);

    end;
    data.Clear;
end;
////////////////////////////////////////////////////////////////////////////////

procedure TfrmGameTools.loadFromfile(afilenam:string);
var
    temp            :TWordComData;
    afile           :TMemoryStream;
    i               :integer;
    str             :string;
begin
    if FileExists('.\userdata\' + afilenam) = false then exit;
    afile := TMemoryStream.Create;

    try

        afile.LoadFromFile('.\userdata\' + afilenam);
        afile.ReadBuffer(temp, afile.Size);
    finally
        afile.Free;
    end;
    i := 0;
    RzCheckBox1.Checked := boolean(WordComData_getbyte(temp, i));
    RzCheckBox2.Checked := boolean(WordComData_getbyte(temp, i));
    RzCheckBox3.Checked := boolean(WordComData_getbyte(temp, i));
    RzCheckBox4.Checked := boolean(WordComData_getbyte(temp, i));
    RzCheckBox_shiqu.Checked := boolean(WordComData_getbyte(temp, i));
    RzCheckBox_itemlist_f.Checked := boolean(WordComData_getbyte(temp, i));

    RzSpinEdit_inPower.IntValue := WordComData_getbyte(temp, i);
    RzSpinEdit_OutPower.IntValue := WordComData_getbyte(temp, i);
    RzSpinEdit_Magic.IntValue := WordComData_getbyte(temp, i);
    RzSpinEdit_Life.IntValue := WordComData_getbyte(temp, i);

    RzSpinEdit_itemtime.IntValue := (WordComData_getdword(temp, i));
    str := WordComData_getstring(temp, i);
    RzComboBox1.text := str;
    str := WordComData_getstring(temp, i);
    RzComboBox2.text := str;
    str := WordComData_getstring(temp, i);
    RzComboBox3.text := str;
    str := WordComData_getstring(temp, i);
    RzComboBox4.text := str;

    str := WordComData_getstring(temp, i);
    RzListBox1.Items.Text := str;

    str := WordComData_getstring(temp, i);
    RzMemo_auto_say_text.Lines.Text := str;

    RzCheckBox_auto_say_check.Checked := boolean(WordComData_getbyte(temp, i));
    RzSpinEdit_auto_say_time.IntValue := WordComData_getdword(temp, i);

    RzCheckBox_MOVE_moveOpenMagic.Checked := boolean(WordComData_getbyte(temp, i));
    RzCheckBox_move_autoMove.Checked := boolean(WordComData_getbyte(temp, i));
    RzSpinEdit_move_1_x.IntValue := WordComData_getdword(temp, i);
    RzSpinEdit_move_1_y.IntValue := WordComData_getdword(temp, i);
    RzSpinEdit_move_2_x.IntValue := WordComData_getdword(temp, i);
    RzSpinEdit_move_2_y.IntValue := WordComData_getdword(temp, i);

    RzCheckBox_Hit_not_Shift.Checked := boolean(WordComData_getbyte(temp, i));
    RzCheckBox_Hit_not_Ctrl.Checked := boolean(WordComData_getbyte(temp, i));
    RzCheckBox_hit_autoMove.Checked := boolean(WordComData_getbyte(temp, i));

    RzCheckBox5.Checked := boolean(WordComData_GETbyte(temp, i));
    RzCheckBox6.Checked := boolean(WordComData_GETbyte(temp, i));
    RzCheckBox7.Checked := boolean(WordComData_GETbyte(temp, i));
    RzCheckBox8.Checked := boolean(WordComData_GETbyte(temp, i));
    RzCheckBox9.Checked := boolean(WordComData_GETbyte(temp, i));
end;

procedure TfrmGameTools.savetofile(afilenam:string);
var
    temp            :TWordComData;
    afile           :TMemoryStream;
    str             :string;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, byte(RzCheckBox1.Checked));
    WordComData_ADDbyte(temp, byte(RzCheckBox2.Checked));
    WordComData_ADDbyte(temp, byte(RzCheckBox3.Checked));
    WordComData_ADDbyte(temp, byte(RzCheckBox4.Checked));
    WordComData_ADDbyte(temp, byte(RzCheckBox_shiqu.Checked));
    WordComData_ADDbyte(temp, byte(RzCheckBox_itemlist_f.Checked));

    WordComData_ADDbyte(temp, (RzSpinEdit_inPower.IntValue));
    WordComData_ADDbyte(temp, (RzSpinEdit_OutPower.IntValue));
    WordComData_ADDbyte(temp, (RzSpinEdit_Magic.IntValue));
    WordComData_ADDbyte(temp, (RzSpinEdit_Life.IntValue));

    WordComData_ADDdword(temp, (RzSpinEdit_itemtime.IntValue));

    str := RzComboBox1.text;
    WordComData_ADDstring(temp, str);
    str := RzComboBox2.text;
    WordComData_ADDstring(temp, str);
    str := RzComboBox3.text;
    WordComData_ADDstring(temp, str);
    str := RzComboBox4.text;
    WordComData_ADDstring(temp, str);
    str := RzListBox1.Items.Text;
    WordComData_ADDstring(temp, str);

    str := RzMemo_auto_say_text.Lines.Text;
    WordComData_ADDstring(temp, str);
    WordComData_ADDbyte(temp, byte(RzCheckBox_auto_say_check.Checked));
    WordComData_ADDdword(temp, (RzSpinEdit_auto_say_time.IntValue));

    WordComData_ADDbyte(temp, byte(RzCheckBox_MOVE_moveOpenMagic.Checked));
    WordComData_ADDbyte(temp, byte(RzCheckBox_move_autoMove.Checked));
    WordComData_ADDdword(temp, (RzSpinEdit_move_1_x.IntValue));
    WordComData_ADDdword(temp, (RzSpinEdit_move_1_y.IntValue));
    WordComData_ADDdword(temp, (RzSpinEdit_move_2_x.IntValue));
    WordComData_ADDdword(temp, (RzSpinEdit_move_2_y.IntValue));

    WordComData_ADDbyte(temp, byte(RzCheckBox_Hit_not_Shift.Checked));
    WordComData_ADDbyte(temp, byte(RzCheckBox_Hit_not_Ctrl.Checked));
    WordComData_ADDbyte(temp, byte(RzCheckBox_hit_autoMove.Checked));

    WordComData_ADDbyte(temp, byte(RzCheckBox5.Checked));
    WordComData_ADDbyte(temp, byte(RzCheckBox6.Checked));
    WordComData_ADDbyte(temp, byte(RzCheckBox7.Checked));
    WordComData_ADDbyte(temp, byte(RzCheckBox8.Checked));
    WordComData_ADDbyte(temp, byte(RzCheckBox9.Checked));

    afile := TMemoryStream.Create;
    if not DirectoryExists('.\userdata') then
        CreateDir('.\userdata');
    try
        afile.WriteBuffer(temp, temp.Size + 2);
        afile.SaveToFile('.\userdata\' + afilenam);
    finally
        afile.Free;
    end;

end;

procedure TfrmGameTools.ItemDBlick(akey:integer);
var
    cClick          :TCClick;

begin
    cClick.rmsg := CM_DBLCLICK;
    cClick.rwindow := WINDOW_ITEMS;
    cClick.rclickedId := 0;
    cClick.rkey := akey;
    Frmlogon.SocketAddData(sizeof(cClick), @cClick);
end;

procedure TfrmGameTools.Item_Click(aid:integer);
var
    cClick          :TCClick;

begin
    cClick.rmsg := CM_CLICK;
    cClick.rwindow := WINDOW_SCREEN;
    cClick.rclickedId := aid;
    Frmlogon.SocketAddData(sizeof(cClick), @cClick);
end;

procedure TfrmGameTools.FormCreate(Sender:TObject);
begin
    Parent := FrmM;
    awItemList := Twg_ItemList.Create;
end;

procedure TfrmGameTools.RzBitBtn5Click(Sender:TObject);
begin
    ItemT1 := now;
    ItemT2 := now;
    ItemT3 := now;
    ItemT4 := now;
    Itemshiqu := now;
    auto_say_T := now;
    auto_Move_T := now;
    Visible := false;
    SAY_EdChatFrmBottomSetFocus;
end;

procedure TfrmGameTools.FormShow(Sender:TObject);
begin
    Top := 0;
    Left := 0;
    RzComboBox1.Items.Text := HaveItemclass.getitemNameList;
    RzComboBox2.Items.Text := HaveItemclass.getitemNameList;
    RzComboBox3.Items.Text := HaveItemclass.getitemNameList;
    RzComboBox4.Items.Text := HaveItemclass.getitemNameList;
    RzComboBox5.Items.Text := '无名步法' + #13#10 + HaveMagicClass.HaveMagic.getMoveMagicNameList;
end;

procedure TfrmGameTools.RzBitBtn1Click(Sender:TObject);
begin
    RzEdit1.Text := trim(RzEdit1.Text);
    if RzEdit1.Text = '' then exit;
    RzListBox1.Add(trim(RzEdit1.Text));
    RzEdit1.Text := '';
end;

function GetCellLength(sx, sy, dx, dy:word):word;
var
    xx, yy, n       :integer;
begin
    Result := 1000;

    if sx > dx then xx := sx - dx
    else xx := dx - sx;
    if sy > dy then yy := sy - dy
    else yy := dy - sy;

    if xx > 255 then exit;
    if yy > 255 then exit;

    n := xx * xx + yy * yy;
    Result := Round(SQRT(n));
end;

procedure TfrmGameTools.RzBitBtn4Click(Sender:TObject);
begin
    loadFromfile(CharCenterName);
end;

procedure TfrmGameTools.Timer1Timer(Sender:TObject);
var
    i               :integer;
    procedure _item(astr:string);
    var
        akey        :integer;
        CLAtt       :TCharClass;
    begin
        CLAtt := CharList.CharGet(CharCenterId);
        if CLAtt = nil then exit;
        if CLAtt.Feature.rfeaturestate = wfs_die then exit; //死亡
        //  if CLAtt.Feature.rfeaturestate = wfs_sitdown then exit; //打坐

        if astr = '' then exit;
        akey := HaveItemclass.getnameid(astr);
        if akey = -1 then exit;
        ItemDBlick(akey);
        // FrmBottom.AddChat('自动吃药：' + astr + datetimetostr(now()), WinRGB(Random(22), 22, 0), 0);
    end;
    procedure _shiquitem();
    var
        aid, i      :integer;
        pp          :pTwgitemdata;
        CLAtt       :TCharClass;
    begin
        CLAtt := CharList.CharGet(CharCenterId);
        if CLAtt = nil then exit;
        if CLAtt.Feature.rfeaturestate = wfs_die then exit; //死亡
        // if CLAtt.Feature.rfeaturestate = wfs_sitdown then exit; //打坐

        for i := awItemList.data.Count - 1 downto 0 do
        begin
            pp := awItemList.data.Items[i];
            if pp.aRace <> RACE_ITEM then Continue;
            if RzCheckBox_itemlist_f.Checked then
            begin
                if (isItemList(pp.aItemName) = true) then Continue;
            end
            else
            begin
                if (isItemList(pp.aItemName) = false) then Continue;
            end;
            if (MilliSecondsBetween(now(), pp.runtime) > 3000) and
                (GetCellLength(CLAtt.x, CLAtt.y, pp.ax, pp.ay) <= 3) then
            begin
                pp.runtime := now();
                Item_Click(pp.aId);
                //  PersonBat.LeftMsgListadd3(datetimetostr(now()) + format('辅助拾取(%s)%d,%d,', [pp.aItemName, pp.ax, pp.ay]), ColorSysToDxColor(clLime));
                exit;
            end;
        end;

    end;
    procedure _autosay(astr:string);
    var
        tempKey     :word;
        ai          :integer;
        _str        :string;
    begin
        astr := trim(astr);
        astr := copy(astr, 1, 100);
        if astr = '' then exit;
        tempKey := VK_RETURN;
        FrmBottom.sendsay(astr, tempKey);
    end;
    procedure _autoMove();
    begin
        if FrmMiniMap.TimerAutoPathMove.Enabled then exit;

        if (CharPosX = RzSpinEdit_move_1_x.IntValue)
            and (CharPosY = RzSpinEdit_move_1_y.IntValue) then
        begin
            FrmMiniMap.AIPathcalc(RzSpinEdit_move_2_x.IntValue, RzSpinEdit_move_2_y.IntValue);
            exit;
        end;
        if (CharPosX = RzSpinEdit_move_2_x.IntValue)
            and (CharPosY = RzSpinEdit_move_2_y.IntValue) then
        begin
            FrmMiniMap.AIPathcalc(RzSpinEdit_move_1_x.IntValue, RzSpinEdit_move_1_y.IntValue);
            exit;
        end;

        if random(8) > 5 then
        begin
            FrmMiniMap.AIPathcalc(RzSpinEdit_move_2_x.IntValue, RzSpinEdit_move_2_y.IntValue);
            exit;
        end;
        FrmMiniMap.AIPathcalc(RzSpinEdit_move_1_x.IntValue, RzSpinEdit_move_1_y.IntValue);
    end;

begin
    MoveAutoOpenMagic := RzCheckBox_MOVE_moveOpenMagic.Checked;
    if RzCheckBox_MOVE_moveOpenMagic.Checked = true then
    begin
        if (RzComboBox5.Text = '无名步法') or (RzComboBox5.Text = '') then
        begin
            MoveMagicKey := HaveMagicClass.DefaultMagic.getMagicTypeIndex(MAGICTYPE_RUNNING);
            MoveMagicWindow := WINDOW_BASICFIGHT;
        end
        else
        begin
            MoveMagicKey := FrmNewMagic.GetMagicTag(RzComboBox5.Text);
            if MoveMagicKey = -1 then exit;
            MoveMagicWindow := WINDOW_MAGICS;
        end;
    end;
    if RzCheckBox_move_autoMove.Checked and (MilliSecondsBetween(now(), auto_move_T) > (5000)) then
    begin
        auto_Move_T := now();
        _autoMove;
    end;
    if RzCheckBox_auto_say_check.Checked and (MilliSecondsBetween(now(), auto_say_T) > (RzSpinEdit_auto_say_time.Value * 1000)) then
    begin
        auto_say_T := now();
        if (auto_say_id < 0) or (auto_say_id >= RzMemo_auto_say_text.Lines.Count) then auto_say_id := 0;
        if (auto_say_id < 0) or (auto_say_id >= RzMemo_auto_say_text.Lines.Count) then
        else
        begin
            _autosay(RzMemo_auto_say_text.Lines.Strings[auto_say_id]);
            inc(auto_say_id);
        end;
    end;

    if RzCheckBox1.Checked and (cAttribClass.CurAttribData.CurInPower / cAttribClass.AttribData.cInPower * 100 < RzSpinEdit_inPower.Value)
        and (MilliSecondsBetween(now(), ItemT1) > RzSpinEdit_itemtime.Value) then
    begin
        ItemT1 := now();
        _item(RzComboBox1.Text);
    end;
    if RzCheckBox2.Checked and (cAttribClass.CurAttribData.CurOutPower / cAttribClass.AttribData.cOutPower * 100 < RzSpinEdit_OutPower.Value)
        and (MilliSecondsBetween(now(), ItemT2) > RzSpinEdit_itemtime.Value) then
    begin
        ItemT2 := now();
        _item(RzComboBox2.Text);
    end;
    if RzCheckBox3.Checked and (cAttribClass.CurAttribData.CurMagic / cAttribClass.AttribData.cMagic * 100 < RzSpinEdit_Magic.Value)
        and (MilliSecondsBetween(now(), ItemT3) > RzSpinEdit_itemtime.Value) then
    begin
        ItemT3 := now();
        _item(RzComboBox3.Text);
    end;
    if RzCheckBox4.Checked and (cAttribClass.CurAttribData.CurLife / cAttribClass.AttribData.cLife * 100 < RzSpinEdit_Life.Value)
        and (MilliSecondsBetween(now(), ItemT4) > RzSpinEdit_itemtime.Value) then
    begin
        ItemT4 := now();
        _item(RzComboBox4.Text);
    end;
    if RzCheckBox_shiqu.Checked
        and (MilliSecondsBetween(now(), Itemshiqu) > 500) then
    begin
        Itemshiqu := now();
        _shiquitem;

    end;

end;

procedure TfrmGameTools.FormDestroy(Sender:TObject);
begin
    awItemList.Free;
end;

function TfrmGameTools.isItemList(astr:string):boolean;
var
    i               :integer;
    str, str2       :string;
begin
    astr := GetValidStr3(astr, str2, ':');
    str2 := trim(str2);
    result := false;
    for i := 0 to RzListBox1.Count - 1 do
    begin
        str := (RzListBox1.Items.Strings[i]);

        if trim(str) = (str2) then
        begin
            result := true;
            exit;
        end;
    end;

end;

procedure TfrmGameTools.RzBitBtn3Click(Sender:TObject);
begin
    savetofile(CharCenterName);
end;

procedure TfrmGameTools.RzBitBtn2Click(Sender:TObject);
var
    i               :integer;
begin
    i := RzListBox1.ItemIndex;
    if (i >= 0) and (i < RzListBox1.Count) then
    begin
        RzListBox1.Delete(i);
    end;
end;

procedure TfrmGameTools.RzSpinEdit_auto_say_timeChange(Sender:TObject);
begin
    if RzSpinEdit_auto_say_time.Value < RzSpinEdit_auto_say_time.Min then
        RzSpinEdit_auto_say_time.Value := RzSpinEdit_auto_say_time.Min;

end;

procedure TfrmGameTools.RzCheckBox5Click(Sender:TObject);
begin
    boShowNpcName := RzCheckBox5.Checked;
    boShowPeopleName := RzCheckBox5.Checked;
    boShowMonsterName := RzCheckBox5.Checked;
    boShowItemName := RzCheckBox5.Checked;
end;

procedure TfrmGameTools.RzCheckBox6Click(Sender:TObject);
begin
    boShowMonsterName := RzCheckBox6.Checked;
end;

procedure TfrmGameTools.RzCheckBox7Click(Sender:TObject);
begin
    boShowNpcName := RzCheckBox7.Checked;
end;

procedure TfrmGameTools.RzCheckBox8Click(Sender:TObject);
begin
    boShowPeopleName := RzCheckBox8.Checked;
end;

procedure TfrmGameTools.RzCheckBox9Click(Sender:TObject);
begin
    boShowItemName := RzCheckBox9.Checked;
end;

procedure TfrmGameTools.RzCheckBox_hit_autoMoveClick(Sender:TObject);
begin
    autoMove := RzCheckBox_hit_autoMove.Checked;
end;

end.

