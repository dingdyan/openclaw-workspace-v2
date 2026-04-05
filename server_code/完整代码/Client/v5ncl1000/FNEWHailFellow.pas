unit FNEWHailFellow;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, A2Form, ExtCtrls, StdCtrls, A2Img, Deftype, Clipbrd;

type
    TArrHailFellowtype = (ahft_1, ahft_2, ahft_3);
    TFrmHailFellow = class(TForm)
        A2Form:TA2Form;
        A2ILabel1:TA2ILabel;
        A2ILabel3:TA2ILabel;
        A2ILabel2:TA2ILabel;
        A2ILabel_BUTTON:TA2ILabel;
        listContent:TA2ListBox;
        HailFellowbtadd:TA2Button;
        HailFellowbtdel:TA2Button;
        HailFellowUserName:TA2Edit;
        A2ILImg:TA2ILabel;
        A2Button_close:TA2Button;
        listContent2:TA2ListBox;
        listContent3:TA2ListBox;
        procedure FormCreate(Sender:TObject);
        procedure HailFellowbtdelClick(Sender:TObject);
        procedure listContentClick(Sender:TObject);
        procedure listContentAdxDrawItem(ASurface:TA2Image; index:Integer;
            aStr:string; Rect:TRect; State:TDrawItemState; fx, fy:Integer);
        procedure FormDestroy(Sender:TObject);
        procedure HailFellowbtaddClick(Sender:TObject);
        procedure A2ILabel1Click(Sender:TObject);
        procedure A2ILabel2Click(Sender:TObject);
        procedure A2ILabel3Click(Sender:TObject);
        procedure A2Button_closeClick(Sender:TObject);
        procedure A2ILImgMouseDown(Sender:TObject; Button:TMouseButton;
            Shift:TShiftState; X, Y:Integer);
    private
        { Private declarations }
    public
        { Public declarations }
        Farrtype:TArrHailFellowtype;
        win_back_img:TA2Image;
        button_back_img1:TA2Image;
        button_back_img2:TA2Image;
        button_back_img3:TA2Image;
        temping:TA2Image;
        tempup:TA2Image;
        tempdown:TA2Image;
        procedure SETarrtype(Value:TArrHailFellowtype);

        procedure sendHailFellowAdd(aname:string);

        //20090619增加
        procedure SetNewVersion();
        procedure SetOldVersion();

        property arrtype:TArrHailFellowtype read Farrtype write SETarrtype;
    end;
    THailFellowdata = record
        rname:string[32];
        rcolor:word;
    end;
    pTHailFellowdata = ^THailFellowdata;
    THailFellowclass = class
    private
        fdata:tlist;
        // function Fdataonline(Item1, Item2:Pointer):Integer;
        procedure Clear();
    public
        tempListbox:TA2ListBox;
        constructor Create;
        destructor Destroy; override;
        function ISUName(auname:string):boolean;
        function GetIndex(aindex:integer):pTHailFellowdata;

        procedure add(uname:string);

        procedure SETstate(uname:string; astate:integer);
        procedure del(uname:string);
        procedure MessageProcess(var code:TWordComData);
    end;

var
    FrmHailFellow   :TFrmHailFellow;
    HailFellowlist  :THailFellowclass;

implementation

uses FShowPopMsg, FBottom, FMain, FConfirmDialog, FLogOn, filepgkclass,
    FnewMagic, FAttrib;

{$R *.dfm}

procedure THailFellowclass.MessageProcess(var code:TWordComData);
var
    pSHailFellowbasic:ptSHailFellowbasic;
    pSHailFellowChangeProperty:ptSHailFellowChangeProperty;
    sname           :string;
begin
    case Code.Data[0] of
        SM_HailFellow:
            begin
                pSHailFellowbasic := @Code.Data;

                sname := (pSHailFellowbasic.rName);
                case pSHailFellowbasic.rkey of
                    HailFellow_Message_ADD: //有人 要加我
                        begin
                            // frmConfirmDialog.MessageProcess(code);
                            frmPopMsg.MessageProcess(code);
                        end;
                    HailFellowChangeProperty: //好又列表
                        begin
                            pSHailFellowChangeProperty := @Code.Data;
                            sname := (pSHailFellowChangeProperty.rName);
                            if isuname(sname) and chat_outcry then
                                if (pSHailFellowChangeProperty.rstate = HailFellow_state_onlise) then
                                    FrmBottom.AddChat(format('你的好友【%s】上线了', [sname]), WinRGB(22, 22, 0), 0)
                                else
                                    FrmBottom.AddChat(format('你的好友【%s】离线了', [sname]), WinRGB(22, 22, 0), 0);
                            add(sname);
                            SETstate(sname, pSHailFellowChangeProperty.rstate);
                        end;
                    HailFellow_GameExit: //好朋友  下线
                        begin
                            SETstate(sname, HailFellow_state_downlide);
                            if chat_outcry then
                                FrmBottom.AddChat(format('你的好友【%s】离线了', [sname]), WinRGB(22, 22, 0), 0);
                        end;
                    HailFellow_del:
                        begin
                            del(sname);
                        end;
                end;

            end;
    end;
end;

constructor THailFellowclass.Create;
begin
    inherited Create;
    FDATA := Tlist.Create;
end;

procedure THailFellowclass.Clear();
var
    i               :integer;
    p               :pTHailFellowdata;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        dispose(p);
    end;
    fdata.Clear;
    tempListbox.Clear;
end;

destructor THailFellowclass.Destroy;
begin
    Clear;
    FDATA.Free;
    inherited Destroy;
end;

function THailFellowclass.GetIndex(aindex:integer):pTHailFellowdata;
begin
    Result := nil;
    if (aindex < 0) or (aindex >= fdata.Count) then exit;
    Result := fdata.Items[aindex];
end;

function THailFellowclass.ISUName(auname:string):boolean;
var
    i               :integer;
    p               :pTHailFellowdata;
begin
    result := false;
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if auname = p.rname then
        begin
            result := true;
            exit;
        end;
    end;
end;

procedure THailFellowclass.add(uname:string);
var
    p               :pTHailFellowdata;
begin
    if isuname(uname) then exit;
    new(p);
    p.rname := uname;
    p.rcolor := 0;
    fdata.Add(p);
    tempListbox.AddItem(' ');
end;

procedure THailFellowclass.del(uname:string);
var
    i               :integer;
    p               :pTHailFellowdata;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rname = uname then
        begin
            dispose(p);
            fdata.Delete(i);
            tempListbox.DeleteItem(i);
            exit;
        end;
    end;

end;

function Fdataonline(Item1, Item2:Pointer):Integer;
begin
    if pTHailFellowdata(Item1).rcolor > pTHailFellowdata(Item2).rcolor then Result := -1
    else if pTHailFellowdata(Item1).rcolor < pTHailFellowdata(Item2).rcolor then Result := 1
    else Result := 0;
end;

procedure THailFellowclass.SETstate(uname:string; astate:integer);
var
    i               :integer;
    acolor          :word;
    p               :pTHailFellowdata;
begin

    case astate of
        HailFellow_state_onlise:
            begin
                acolor := ColorSysToDxColor($047AFF);

            end;
        HailFellow_state_downlide:
            begin
                acolor := ColorSysToDxColor($005E5E5E);

            end;
    else acolor := ColorSysToDxColor($005E5E5E);
    end;

    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rname = uname then
        begin
            p.rcolor := acolor;
            fdata.Sort(Fdataonline);
            tempListbox.DrawItem;
            exit;
        end;
    end;

end;

procedure TFrmHailFellow.HailFellowbtdelClick(Sender:TObject);
var
    tt              :TSHailFellowbasic;
    cnt             :integer;
    STR             :string;

    P               :pTHailFellowdata;
    frmConfirmDialog:TfrmConfirmDialog;
begin

    case arrtype of
        ahft_1:
            begin
                // if HailFellowUserName.Text = '' then exit;
                p := HailFellowlist.GetIndex(listContent.ItemIndex);
                if p = nil then
                begin
                    SAY_EdChatFrmBottomSetFocus;
                    exit;
                end;
                STR := p.rname;
                if STR = '' then
                begin
                    SAY_EdChatFrmBottomSetFocus;
                    exit;
                end;

                frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
                frmConfirmDialog.ShowFrom(cdtHailFellowDel, str, format('你真的要把好友【%s】删除？', [str]));

            end;
        ahft_2:;
        ahft_3:;
    end;

    SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmHailFellow.listContentClick(Sender:TObject);
var
    str             :string;
    P               :pTHailFellowdata;
begin
    if arrtype = ahft_1 then
    begin
        p := HailFellowlist.GetIndex(listContent.ItemIndex);
        if p = nil then
        begin
            SAY_EdChatFrmBottomSetFocus;
            exit;
        end;
        STR := p.rname;
        Clipboard.AsText := str;
        FrmBottom.AddChat('好友名字已复制', WinRGB(255, 255, 0), 0);
        FrmBottom.Editchannel.Caption := '纸条';
        FrmBottom.EdChat.Text := '@纸条 ' + str + ' ';
    end;
    SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmHailFellow.listContentAdxDrawItem(ASurface:TA2Image;
    index:Integer; aStr:string; Rect:TRect; State:TDrawItemState; fx,
    fy:Integer);
var
    P               :pTHailFellowdata;
begin
    begin
        P := HailFellowlist.GetIndex(index);
        if P = nil then EXIT;
        ATextOut(ASurface, 0, 0, p.rcolor, P.rName);
    end;
end;

procedure TFrmHailFellow.FormCreate(Sender:TObject);
begin
    FrmM.AddA2Form(Self, A2Form);
    top := 50;
    Left := 0;
    HailFellowlist := THailFellowclass.Create;
    HailFellowlist.tempListbox := listContent;
    if WinVerType = wvtnew then
    begin
        SetnewVersion;
    end else if WinVerType = wvtold then
    begin
        SetOldVersion;
    end;
    listContent.FFontSelBACKColor := ColorSysToDxColor($9B7781);
    listContent.FLayout := tlCenter;
    arrtype := ahft_1;

end;

procedure TFrmHailFellow.FormDestroy(Sender:TObject);
begin
    HailFellowlist.Free;
    win_back_img.Free;
    button_back_img1.Free;
    button_back_img2.Free;
    button_back_img3.Free;
    temping.Free;
    tempup.Free;
    tempdown.Free;
end;

procedure TFrmHailFellow.SetNewVersion();

begin

    win_back_img := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('好友列表窗口.bmp', win_back_img);
    A2ILImg.A2Image := win_back_img;
    button_back_img1 := TA2Image.Create(32, 32, 0, 0);

    pgkBmp.getBmp('好友列表_好友_弹起-2.bmp', button_back_img1);

    button_back_img2 := TA2Image.Create(32, 32, 0, 0);

    pgkBmp.getBmp('好友列表_仇人_弹起-2.bmp', button_back_img2);

    button_back_img3 := TA2Image.Create(32, 32, 0, 0);

    pgkBmp.getBmp('好友列表_黑名单_弹起-2.bmp', button_back_img3);

    //重新设置新窗口按钮位置
    A2ILabel_BUTTON.Left := 16;
    A2ILabel_BUTTON.Top := 49;
    A2ILabel1.Left := 18;
    A2ILabel1.Top := 51;

    A2ILabel2.Left := 69;
    A2ILabel2.Top := 51;

    A2ILabel3.Left := 120;
    A2ILabel3.Top := 51;

    temping := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
    A2Button_close.A2Up := temping;
    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
    A2Button_close.A2Down := temping;
    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
    A2Button_close.A2Mouse := temping;
    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
    A2Button_close.A2NotEnabled := temping;

    pgkBmp.getBmp('好友列表_添加_弹起.bmp', temping);
    HailFellowbtadd.A2Up := temping;
    pgkBmp.getBmp('好友列表_添加_按下.bmp', temping);
    HailFellowbtadd.A2Down := temping;
    pgkBmp.getBmp('好友列表_添加_鼠标.bmp', temping);
    HailFellowbtadd.A2Mouse := temping;
    pgkBmp.getBmp('好友列表_添加_禁止.bmp', temping);
    HailFellowbtadd.A2NotEnabled := temping;

    pgkBmp.getBmp('好友列表_删除_弹起.bmp', temping);
    HailFellowbtdel.A2Up := temping;
    pgkBmp.getBmp('好友列表_删除_按下.bmp', temping);
    HailFellowbtdel.A2Down := temping;
    pgkBmp.getBmp('好友列表_删除_鼠标.bmp', temping);
    HailFellowbtdel.A2Mouse := temping;
    pgkBmp.getBmp('好友列表_删除_禁止.bmp', temping);
    HailFellowbtdel.A2NotEnabled := temping;

    tempup := TA2Image.Create(32, 32, 0, 0);
    tempdown := TA2Image.Create(32, 32, 0, 0);
    //
    pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempup);
    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempdown);
    listContent.SetScrollTopImage(tempup, tempdown);

    pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempup);
    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempdown);
    listContent.SetScrollTrackImage(tempup, tempdown);

    pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempup);
    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempdown);
    listContent.SetScrollBottomImage(tempup, tempdown);

    pgkBmp.getBmp('好友列表_下拉条底框.bmp', temping);
    listContent.SetScrollBackImage(temping);

    //
    pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempup);
    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempdown);
    listContent2.SetScrollTopImage(tempup, tempdown);

    pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempup);
    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempdown);
    listContent2.SetScrollTrackImage(tempup, tempdown);

    pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempup);
    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempdown);
    listContent2.SetScrollBottomImage(tempup, tempdown);

    pgkBmp.getBmp('好友列表_下拉条底框.bmp', temping);
    listContent2.SetScrollBackImage(temping);

    //
    pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempup);
    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempdown);
    listContent3.SetScrollTopImage(tempup, tempdown);

    pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempup);
    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempdown);
    listContent3.SetScrollTrackImage(tempup, tempdown);

    pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempup);
    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempdown);
    listContent3.SetScrollBottomImage(tempup, tempdown);

    pgkBmp.getBmp('好友列表_下拉条底框.bmp', temping);
    listContent3.SetScrollBackImage(temping);

    //添加
    HailFellowbtadd.Left := 147;
    HailFellowbtadd.Top := 222;
    HailFellowbtadd.BringToFront;
    //删除
    HailFellowbtdel.Left := 147;
    HailFellowbtdel.Top := 244;
    HailFellowbtdel.BringToFront;

    A2Button_close.Left := 184;
    A2Button_close.Top := 16;

    listContent.Left := 20;
    listContent.Top := 69;
    listContent2.Left := 20;
    listContent2.Top := 69;
    listContent3.Left := 20;
    listContent3.Top := 69;

    listContent.Width := 186;
    listContent.Height := 145;
    listContent2.Width := 186;
    listContent2.Height := 145;
    listContent3.Width := 186;
    listContent3.Height := 145;

    HailFellowUserName.Left := 22 + 2;
    HailFellowUserName.Top := 234 + 4;
    HailFellowUserName.Width := 116;
    HailFellowUserName.Height := 20;
end;

procedure TFrmHailFellow.SetOldVersion();
begin
    win_back_img := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('好友窗.bmp', win_back_img);
    A2ILImg.A2Image := win_back_img;
    button_back_img1 := TA2Image.Create(32, 32, 0, 0);

    pgkBmp.getBmp('好友按钮UP.bmp', button_back_img1);

    button_back_img2 := TA2Image.Create(32, 32, 0, 0);

    pgkBmp.getBmp('仇人按钮UP.bmp', button_back_img2);

    button_back_img3 := TA2Image.Create(32, 32, 0, 0);

    pgkBmp.getBmp('黑名单按钮UP.bmp', button_back_img3);

    A2Button_close.A2Down := frmnewmagic.win_CloseDown_img;
    A2Button_close.A2Up := frmnewmagic.win_CloseUP_img;

    listContent.SetScrollTopImage(getviewImage(7), getviewImage(6));
    listContent.SetScrollTrackImage(getviewImage(4), getviewImage(5));
    listContent.SetScrollBottomImage(getviewImage(9), getviewImage(8));

end;

procedure TFrmHailFellow.SETarrtype(Value:TArrHailFellowtype);
begin
    Farrtype := Value;
    case Farrtype of
        ahft_1:
            begin
                listContent.Visible := true;
                listContent2.Visible := false;
                listContent3.Visible := false;
                A2ILabel_BUTTON.A2Image := button_back_img1;
                listContent.DrawItem;

            end;
        ahft_2:
            begin
                listContent.Visible := false;
                listContent2.Visible := true;
                listContent3.Visible := false;
                A2ILabel_BUTTON.A2Image := button_back_img2;
                listContent.DrawItem;
            end;
        ahft_3:
            begin
                listContent.Visible := false;
                listContent2.Visible := false;
                listContent3.Visible := true;
                A2ILabel_BUTTON.A2Image := button_back_img3;
                listContent3.DrawItem;
            end;
    end;

end;

procedure TFrmHailFellow.sendHailFellowAdd(aname:string);
var
    tt              :TSHailFellowbasic;
    cnt             :integer;
begin
    if aname = '' then exit;
    tt.rmsg := CM_HailFellow;
    tt.rKEY := HailFellow_ADD;
    TT.rName := aname;
    cnt := sizeof(TT);
    FrmLogon.SocketAddData(cnt, @TT);

    SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmHailFellow.HailFellowbtaddClick(Sender:TObject);
begin

    HailFellowUserName.Text := trim(HailFellowUserName.Text);
    if HailFellowUserName.Text = '' then exit;
    case arrtype of
        ahft_1:sendHailFellowAdd(HailFellowUserName.Text);
        ahft_2:;
        ahft_3:;
    end;

    HailFellowUserName.Text := '';
end;

procedure TFrmHailFellow.A2ILabel1Click(Sender:TObject);
begin
    arrtype := ahft_1;
end;

procedure TFrmHailFellow.A2ILabel2Click(Sender:TObject);
begin
    arrtype := ahft_2;
end;

procedure TFrmHailFellow.A2ILabel3Click(Sender:TObject);
begin
    arrtype := ahft_3;
end;

procedure TFrmHailFellow.A2Button_closeClick(Sender:TObject);
begin
    Visible := false;
    SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmHailFellow.A2ILImgMouseDown(Sender:TObject;
    Button:TMouseButton; Shift:TShiftState; X, Y:Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

end.

