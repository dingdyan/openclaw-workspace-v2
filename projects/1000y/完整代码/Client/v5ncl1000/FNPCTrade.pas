unit FNPCTrade;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, A2Form, CharCls, Deftype, A2Img, AUtil32, ExtCtrls, uAnsTick;
type

    TitemInputdata = record
        rkey: integer;
        rcap: string[64];
        rtext: string[255];
    end;
    TfrmNPCTrade = class(TForm)
        imgImage: TA2ILabel;
        A2Form: TA2Form;
        btnCommandClose: TA2Button;
        listContent: TA2ListBox;
        lblTitleUnderBar: TA2ILabel;
        lblTitle: TA2ILabel;
        A2Label: TA2Label;
        A2ILabeItemInput0: TA2ILabel;
        A2ILabeItemInput1: TA2ILabel;
        A2ILabeItemInput2: TA2ILabel;
        A2ILabeItemInput3: TA2ILabel;
        A2ILabeItemInput4: TA2ILabel;
        A2ILabel_itemInuptCap0: TA2ILabel;
        A2ILabel_itemInuptCap1: TA2ILabel;
        A2ILabel_itemInuptCap2: TA2ILabel;
        A2ILabel_itemInuptCap3: TA2ILabel;
        A2ILabel_itemInuptCap4: TA2ILabel;
        procedure FormCreate(Sender: TObject);

        procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure FormDestroy(Sender: TObject);
        procedure listContentAdxScrollDraw(ASurface: TA2Image; Rect: TRect;
            State: TDrawScrollState);
        procedure listContentStartDrag(Sender: TObject;
            var DragObject: TDragObject);
        procedure btnCommandCloseClick(Sender: TObject);
        procedure listContentAdxDrawItem(ASurface: TA2Image; index: Integer;
            aStr: string; Rect: TRect; State: TDrawItemState; fx, fy: Integer);
        procedure listContentDragDrop(Sender, Source: TObject; X, Y: Integer);
        procedure listContentDragOver(Sender, Source: TObject; X, Y: Integer;
            State: TDragState; var Accept: Boolean);
        procedure A2ILabeItemInput0DblClick(Sender: TObject);
        procedure A2ILabeItemInput0DragDrop(Sender, Source: TObject; X, Y: Integer);
        procedure A2ILabeItemInput0DragOver(Sender, Source: TObject; X, Y: Integer;
            State: TDragState; var Accept: Boolean);
        procedure A2ILabeItemInput0MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure listContentDblClick(Sender: TObject);
        procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure A2ILabeItemInput0MouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure A2Label_itemInput4MouseMove(Sender: TObject;
            Shift: TShiftState; X, Y: Integer);
    private

        procedure DblBuy(akey: integer);
        procedure DblSell;

        { Private declarations }
    public
        Visiblestate: integer;
        { Public declarations }
        TA2Labellist: array[0..20] of TA2Label;
        A2ILabelItemInputArr: array[0..4] of TA2ILabel;
        A2LabelItemInputCapArr: array[0..4] of TA2ILabel;
        ItemInputKeyArr: array[0..4] of TitemInputdata;
        A2Image_1: TA2Image;
        A2Image_2: TA2Image;
        A2Image_3: TA2Image;

        ITEMLIST: TLIST;
        itemprice: integer;
        ITEMLIST_index: integer;
        itemnum: integer;

        TA2ButtonLIST: tlist;
        cmdlist: tstringlist;

        bolock: boolean;
        boBuyItemAllState: boolean;

        FItemimg: TA2Image;
        tempup: TA2Image;
        tempdown: TA2Image;

        BuyItemKey: integer;                                                    //NPC 收购 物品 背包位置
        procedure ITMEADD(T: TSNPCItem);
        function ITEMGET(I: INTEGER): PTSNPCItem;
        function ITEMGETname(sname: string): PTSNPCItem;
        function ITEMGETname_rindex(sname: string): integer;
        procedure ITMEClear();

        procedure SetItemLabel(Lb: TA2ILabel; lbt: TA2Label; aname: string; acolor: byte; shape: word);
        function GetImage(tt: TA2ImageLib; idx: integer): TA2Image;

        procedure SETimage(v1, v2, V3: integer);
        procedure showVisible(i: integer);
        procedure showsay(npcTitle: string = ''; npcsay: string = '');
        function itemcon(): integer;
        procedure SendNPCsellDir();
        procedure SendNPCbuf(aname: string; anum: integer);
        procedure SendNPCsell(aitemKey: integer; anum: integer);
        procedure SendNPCbuyDir();
        procedure SendNPCEmail();
        procedure SendNPCAuction();
        procedure SendNPClogitem();                                             //仓库

        procedure SendNPCUPItemLeve();
        procedure SendNPCUPItemSetting();
        procedure SendNPCUPItemSettingDel();

        procedure SendNPCCancel();
        procedure SendNPCWindowsCancel();

        procedure SendNPCOK();
        procedure SETSAYtext(str: string);

        procedure TA2ButtonLIST_add(STR, cmd: string; tLeft, tTop, tWidth, tHeight: integer);
        procedure TA2ButtonLIST_Clear;
        procedure TA2ButtonLIST_Clear_color(c: tcolor);

        procedure MessageProcess(var code: TWordComData);

        procedure sendItemInpuKey(awinsub, akey: integer);
        procedure setitemshpe(Lb: TA2ILabel; aitemid: integer);
        //2009.6.30增加
        procedure SetNewVersion();
        procedure SetOldVersion();

        procedure ItemInputKeyArrClear();
        procedure ItemInputKeyArrDel(asubkey: integer);
        procedure ItemInputKeyArrOpen(asubkey: integer);

        procedure ItemInputKeyArrSetIndex;

    end;

var
    frmNPCTrade: TfrmNPCTrade;

implementation

uses FMain, AtzCls, FAttrib, FLogOn, FQuantity, cltype, FBottom, filepgkclass,
    FWearItem;

{$R *.DFM}

procedure TfrmNPCTrade.TA2ButtonLIST_Clear;
var
    i: integer;
    t: TA2Button;
begin

    cmdlist.Clear;
    if TA2ButtonLIST.Count <= 0 then exit;
    for i := 0 to TA2ButtonLIST.Count - 1 do
    begin
        t := TA2ButtonLIST.Items[i];
        t.Free;
    end;
    TA2ButtonLIST.Clear;
end;

procedure TfrmNPCTrade.TA2ButtonLIST_Clear_color(c: tcolor);
var
    i: integer;
    t: TA2Button;
begin

end;

procedure TfrmNPCTrade.TA2ButtonLIST_add(STR, cmd: string; tLeft, tTop, tWidth, tHeight: integer);
var
    t: TA2Button;
begin
    t := TA2Button.Create(self);
    t.ADXForm := self.A2Form;
    //    t.showImg := false;
    t.Caption := str;
    t.Left := tleft;
    t.Top := ttop;
    t.AutoSize := false;
    t.Width := twidth;
    t.Height := theight;
    //   t.OnMouseMove := btnCommand1MouseMove;
    t.OnClick := btnCommandCloseClick;
    t.Visible := true;
    t.Font := btnCommandClose.Font;
    t.Parent := self;

    t.FontColor := btnCommandClose.FontColor;
    t.FontSelColor := btnCommandClose.FontSelColor;
    t.BringToFront;
    TA2ButtonLIST.Add(t);
    cmdlist.Add(cmd);
end;

function TfrmNPCTrade.itemcon(): integer;
var
    i: integer;
    T1: PTSNPCItem;
begin
    result := 0;
    for i := 0 to ITEMLIST.Count - 1 do
    begin
        t1 := ITEMLIST[i];
        result := result + t1.rCount * t1.rPrice;
    end;

    { if Visiblestate = 2 then
         lblPrice.Caption := format('出售价格:%D钱币', [result])
     else
         if Visiblestate = 3 then
         lblPrice.Caption := format('收购价格:%D钱币%', [result]);
         }
end;

procedure TfrmNPCTrade.ITMEADD(T: TSNPCItem);
var
    T1: PTSNPCItem;
begin
    listContent.FboAutoSelectIndex := false;
    t1 := ITEMGET(t.rkey);
    if t1 = nil then
    begin
        NEW(T1);
        T1^ := T;
        // t1.rCount := 0;
        ITEMLIST.Add(T1);

        listContent.AddItem('           ' + (T1.rName));
    end else
    begin
        t.rCount := t1.rCount + t.rCount;
        T1^ := T;
    end;

    listContent.DrawItem;
end;

function TfrmNPCTrade.ITEMGET(I: INTEGER): PTSNPCItem;
begin
    RESULT := nil;
    if (I >= 0) and (I < ITEMLIST.Count) then
        RESULT := ITEMLIST.Items[I];
end;

function TfrmNPCTrade.ITEMGETname(sname: string): PTSNPCItem;
var
    i: integer;
    tt: PTSNPCItem;
begin
    result := nil;
    for i := 0 to ITEMLIST.Count - 1 do
    begin
        tt := ITEMLIST[i];
        if tt = nil then Continue;
        if (tt.rName) = sname then
        begin
            result := ITEMLIST[i];
            exit;
        end;
    end;

end;

function TfrmNPCTrade.ITEMGETname_rindex(sname: string): integer;
var
    i: integer;
    tt: PTSNPCItem;
begin
    result := -1;
    for i := 0 to ITEMLIST.Count - 1 do
    begin
        tt := ITEMLIST[i];
        if tt = nil then Continue;
        if (tt.rName) = sname then
        begin
            result := i;
            exit;
        end;
    end;

end;

procedure TfrmNPCTrade.ITMEClear();
var
    I: INTEGER;
    T1: PTSNPCItem;
begin

    //  if ITEMLIST.Count <= 0 then EXIT;
    for I := 0 to ITEMLIST.Count - 1 do
    begin
        T1 := ITEMLIST.Items[I];
        Dispose(T1);
    end;
    ITEMLIST.Clear;
    listContent.Clear;
end;

procedure TfrmNPCTrade.SETSAYtext(str: string);
const
    lw = 60;                                                                    //文字 宽度
var
    i, li, cmdboolean: integer;
    cmd, sname: string;

    s: string;
    r, r2: TRect;
begin

    TA2ButtonLIST_Clear;
    cmdboolean := 0;
    s := '';
    cmd := '';
    sname := '';
    li := 0;
    for i := 0 to high(TA2Labellist) do TA2Labellist[i].Caption := '';

    for i := 1 to length(str) do
    begin
        if li > high(TA2Labellist) then exit;
        case str[i] of
            '^':
                begin
                    TA2Labellist[li].Caption := s;
                    inc(li);
                    cmdboolean := 0;
                    s := '';
                end;
            '<':
                begin
                    cmd := '';
                    sname := '';
                    cmdboolean := 1;
                end;
            '/':
                begin
                    if cmdboolean = 1 then cmdboolean := 2;
                end;
            '>':
                begin
                    if cmdboolean = 2 then
                    begin
                        TA2ButtonLIST_add(sname, cmd, TA2Labellist[li].Left + ATextWidth(s), TA2Labellist[li].Top, ATextWidth(sname), TA2Labellist[li].Height);
                        s := s + sname;
                        cmd := '';
                        sname := '';
                    end;
                    cmdboolean := 0;
                end;

        else
            begin
                if cmdboolean = 0 then
                    s := s + str[i]
                else if cmdboolean = 1 then
                    sname := sname + str[i]
                else if cmdboolean = 2 then
                    cmd := cmd + str[i]
                        ;
            end;
        end;

    end;
    TA2Labellist[li].Caption := s;
    inc(li);
    Visible := true;
end;

procedure TfrmNPCTrade.showsay(npcTitle: string = ''; npcsay: string = '');
begin
    lblTitle.Caption := npcTitle;
    //lblTitle.AutoSize := true;
    npcsay := StringReplace(npcsay, '<br>', '^', [rfReplaceAll]);
    SETSAYtext(npcsay);
end;

procedure TfrmNPCTrade.showVisible(i: integer);
const
    clw = 40;
begin
    ITMEClear;
    // Left := 50;
    // top := 50;

//    lblPrice.Visible := false;
    //    btnCommand4_sell.Visible := false;
      //  btnCommand5_buf.Visible := false;

    listContent.Visible := false;

    Visiblestate := i;

    case Visiblestate of
        0:
            begin
                Visible := false;
            end;
        1:                                                                      //说话
            begin
                listContent.Visible := false;

                Visible := true;
                FrmM.move_win_form_Align(Self, mwfCenterLeft);
                FrmM.SetA2Form(Self, A2form);
            end;
        2:                                                                      //买
            begin
                listContent.Visible := true;
                // lblPrice.Visible := true;
                // lblPrice.Caption := '';

                Visible := true;
                FrmM.move_win_form_Align(Self, mwfCenterLeft);
                FrmM.SetA2Form(Self, A2form);
            end;
        3:                                                                      //卖
            begin
                listContent.Visible := true;
                //  lblPrice.Visible := true;
                //  lblPrice.Caption := '';

                Visible := true;
                FrmM.move_win_form_Align(Self, mwfCenterLeft);
                FrmM.SetA2Form(Self, A2form);
            end;
    end;

end;

procedure TfrmNPCTrade.MessageProcess(var code: TWordComData);
var
    pckey: PTckey;
    PSSShowSpecialWindow: PTSShowSpecialWindow;
    i, n, akey: integer;
    str, rdstr: string;

    PNPC: PTSNPCItem;
begin
    pckey := @code.data;
    case pckey^.rmsg of
        SM_ItemInputWindows:
            begin
                i := 1;
                akey := WordComData_GETbyte(code, i);
                n := WordComData_GETbyte(code, i);
                if (n < 0) or (n > high(A2ILabelItemInputArr)) then exit;
                case akey of
                    ItemInputWindows_Open:
                        begin
                            ItemInputKeyArr[n].rcap := copy(WordComData_GETString(code, i), 1, 64);
                            ItemInputKeyArr[n].rtext := copy(WordComData_GETString(code, i), 1, 255);
                            ItemInputKeyArrOpen(n);
                        end;
                    ItemInputWindows_Close:
                        begin
                            A2ILabelItemInputArr[n].Visible := false;
                        end;
                    ItemInputWindows_key:
                        begin
                            akey := WordComData_GETdword(code, i);
                            ItemInputKeyArr[n].rkey := akey;
                            setitemshpe(A2ILabelItemInputArr[n], ItemInputKeyArr[n].rkey);
                        end;
                end;

            end;
        SM_SHOWSPECIALWINDOW:
            begin
                PSSShowSpecialWindow := @Code.data;

                case PSSShowSpecialWindow^.rWindow of
                    WINDOW_Close_All: Visible := false;
                    WINDOW_MENUSAY:
                        begin
                            // if not FrmAttrib.Visible then FrmAttrib.Visible := TRUE;
                           // if FrmWearItem.Visible = false then FrmBottom.BtnItemClick(nil);
                            SETimage(PSSShowSpecialWindow.rkey1, PSSShowSpecialWindow.rkey2, PSSShowSpecialWindow.rkey3);

                            showsay((PSSShowSpecialWindow.rCaption), GetWordString(PSSShowSpecialWindow.rWordString));
                            showVisible(1);
                            ItemInputKeyArrClear;
                        end;
                    WINDOW_ITEMTrade_sell:
                        begin
                            //  if not FrmAttrib.Visible then FrmAttrib.Visible := TRUE;
                           // if FrmWearItem.Visible = false then FrmBottom.BtnItemClick(nil);
                            SETimage(PSSShowSpecialWindow.rkey1, PSSShowSpecialWindow.rkey2, PSSShowSpecialWindow.rkey3);
                            showsay((PSSShowSpecialWindow.rCaption), GetWordString(PSSShowSpecialWindow.rWordString));
                            showVisible(2);
                            bolock := boolean((PSSShowSpecialWindow.rKey3));
                            //  boBuyItemAllState := boolean(LOWORD(PSSShowSpecialWindow.rKey3));
                        end;
                    WINDOW_ITEMTrade_buf:
                        begin
                            //  if not FrmAttrib.Visible then FrmAttrib.Visible := TRUE;
                          //  if FrmWearItem.Visible = false then FrmBottom.BtnItemClick(nil);
                            SETimage(PSSShowSpecialWindow.rkey1, PSSShowSpecialWindow.rkey2, PSSShowSpecialWindow.rkey3);
                            showsay((PSSShowSpecialWindow.rCaption), GetWordString(PSSShowSpecialWindow.rWordString));
                            showVisible(3);
                            bolock := boolean(HIWORD(PSSShowSpecialWindow.rKey3));
                            boBuyItemAllState := boolean(LOWORD(PSSShowSpecialWindow.rKey3));
                        end;
                    WINDOW_ITEMTradehide:
                        begin
                            showVisible(0);
                            if FrmQuantity.Visible then FrmQuantity.Visible := false;
                            //     FrmAttrib.ILabels_renew;
                        end;
                end;

            end;
        SM_NPCITEM:
            begin
                PNPC := @Code.data;
                ITMEADD(PNPC^);
                itemcon;

            end;
    end;
end;

function TfrmNPCTrade.GetImage(tt: TA2ImageLib; idx: integer): TA2Image;
begin
    Result := nil;
    if (idx < 0) or (idx >= tt.Count) then exit;
    Result := tt[idx];
end;

procedure TfrmNPCTrade.SetItemLabel(Lb: TA2ILabel; lbt: TA2Label; aname: string; acolor: byte; shape: word);
var
    gc, ga: integer;
begin
    Lb.Caption := '';
    lbt.Caption := '';
    GetGreenColorAndAdd(acolor, gc, ga);
    lbt.Caption := aname;
    Lb.GreenCol := gc;
    Lb.GreenAdd := ga;

    if shape = 0 then
    begin
        Lb.A2Image := nil;
        Lb.BColor := 0;
        exit;
    end else
        Lb.A2Image := AtzClass.GetItemImage(shape);
end;

function getfileimage(afile: string; idx: integer): TA2Image;
var
    tt: TA2ImageLib;
begin
    Result := nil;
    tt := AtzClass.GetImageLib(afile, mmAnsTick);
    if tt = nil then exit;
    if (idx < 0) or (idx >= tt.Count) then exit;
    Result := tt[idx];
end;

procedure TfrmNPCTrade.SETimage(v1, v2, V3: integer);
var
    fy, fx: integer;
    tt: TA2Image;
begin
    tt := nil;
    case V3 of
        RACE_NPC: tt := getfileimage(format('z%d.atz', [v1]), v2);
        RACE_MONSTER:
            begin
                tt := getfileimage(format('z%d.atz', [v1]), 79);
                if tt = nil then tt := getfileimage(format('z%d.atz', [v1]), v2);
            end;
        RACE_DYNAMICOBJECT: tt := getfileimage(format('x%d.atz', [v1]), v2);
    end;
    if TT = nil then EXIT;


    imgImage.A2Image := nil;
    //NPC
    A2Image_1.Setsize(tt.Width, tt.Height);
    A2Image_1.Clear(0);
    A2Image_1.DrawImage(tt, 0, 0, true);

    A2Image_2.Setsize(A2Image_1.Width, A2Image_1.Height);
    A2Image_1.TransparentColor := 31;
    A2Image_2.TransparentColor := 0;
    A2Image_2.Clear(0);
    A2Image_2.DrawImage(A2Image_1, 0, 0, true);
    A2Image_1.Clear(0);
    A2Image_1.TransparentColor := 0;
    A2Image_1.DrawImage(A2Image_2, 0, 0, true);
    A2Image_1.Optimize;

    //边框
    A2Image_3.Setsize(imgImage.Width, imgImage.Height);

    if WinVerType = wvtNew then
    begin
        pgkBmp.getBmp('通用NPC窗口_边框.bmp', A2Image_3);
    end
    else if WinVerType = wvtOld then
    begin
        pgkBmp.getBmp('NPC边框.bmp', A2Image_3);
    end;
    A2Image_3.TransparentColor := 0;
    //合并 边框
    A2Image_2.Setsize(imgImage.Width, imgImage.Height);
    A2Image_2.Clear(0);
    A2Image_2.DrawImage(A2Image_3, 0, 0, true);
    //合并 NPC
    fx := (A2Image_2.Width - A2Image_1.Width) div 2;
    fy := (A2Image_2.Height - A2Image_1.Height) div 2;
    A2Image_2.DrawImage(A2Image_1, fx, fy, true);
    A2Image_2.TransparentColor := 0;
    //  A2Image_2.Optimize;

    imgImage.A2Image := A2Image_2;

end;

procedure TfrmNPCTrade.FormCreate(Sender: TObject);
var
    i: integer;
begin
    FrmM.AddA2Form(Self, A2form);
//    A2Form.FA2Hint.Ftype := hstTransparent;
    Left := 0;
    Top := 0;
    if WinVerType = wvtOld then
    begin
        SetoldVersion;
    end else if WinVerType = wvtnew then
    begin
        SetnewVersion;
    end;

    ITEMLIST := TLIST.Create;

    A2Image_1 := TA2Image.Create(300, 300, 0, 0);
    A2Image_3 := TA2Image.Create(300, 300, 0, 0);
    A2Image_2 := TA2Image.Create(300, 300, 0, 0);

    TA2ButtonLIST := tlist.Create;
    cmdlist := tstringlist.Create;
    cmdlist.Clear;
    for i := 0 to high(TA2Labellist) do
    begin
        TA2Labellist[i] := TA2Label.Create(self);
        TA2Labellist[i].AutoSize := false;
        TA2Labellist[i].Height := A2Label.Height;
        TA2Labellist[i].Width := A2Label.Width;

        TA2Labellist[i].Left := A2Label.Left;
        TA2Labellist[i].Top := A2Label.top + A2Label.Height * i + 5;
        //  TA2Labellist[i].BringToFront;
        TA2Labellist[i].Color := A2Label.Color;
        TA2Labellist[i].Font := A2Label.Font;
        TA2Labellist[i].FontColor := A2Label.FontColor;

        TA2Labellist[i].Visible := true;
        TA2Labellist[i].Caption := '';
        TA2Labellist[i].Parent := self;
        TA2Labellist[i].ADXForm := A2Form;
        TA2Labellist[i].SendToBack;
        // TA2Labellist[i].AdxPaint;
        TA2Labellist[i].OnMouseMove := FormMouseMove;
    end;

    listContent.FFontSelBACKColor := 15;
    listContent.FLayout := tlCenter;
    //    btnCommand5_buf.Font.Color := WinRGB(31, 31, 31);
      //  btnCommand4_sell.Font.Color := WinRGB(31, 31, 31);

    btnCommandClose.Font.Color := WinRGB(31, 31, 31);
end;

procedure TfrmNPCTrade.SetNewVersion();
var
    outing: TA2Image;

begin
    A2ILabelItemInputArr[0] := A2ILabeItemInput0;
    A2ILabelItemInputArr[1] := A2ILabeItemInput1;
    A2ILabelItemInputArr[2] := A2ILabeItemInput2;
    A2ILabelItemInputArr[3] := A2ILabeItemInput3;
    A2ILabelItemInputArr[4] := A2ILabeItemInput4;

    A2LabelItemInputCapArr[0] := A2ILabel_itemInuptCap0;
    A2LabelItemInputCapArr[1] := A2ILabel_itemInuptCap1;
    A2LabelItemInputCapArr[2] := A2ILabel_itemInuptCap2;
    A2LabelItemInputCapArr[3] := A2ILabel_itemInuptCap3;
    A2LabelItemInputCapArr[4] := A2ILabel_itemInuptCap4;

    FItemimg := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('通用道具底框A.bmp', FItemimg);
    A2ILabeItemInput0.A2Image := FItemimg;
    A2ILabeItemInput1.A2Image := FItemimg;
    A2ILabeItemInput2.A2Image := FItemimg;
    A2ILabeItemInput3.A2Image := FItemimg;
    A2ILabeItemInput4.A2Image := FItemimg;
    ItemInputKeyArrSetIndex;


    pgkBmp.getBmp('通用NPC窗口.bmp', A2form.FImageSurface);
    A2form.boImagesurface := true;

    //关闭
    outing := TA2Image.Create(32, 32, 0, 0);
    try
        pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', outing);
        btnCommandClose.A2Up := outing;
        pgkBmp.getBmp('通用X关闭按钮_按下.bmp', outing);
        btnCommandClose.A2Down := outing;
        pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', outing);
        btnCommandClose.A2Mouse := outing;
        pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', outing);
        btnCommandClose.A2NotEnabled := outing;

        pgkBmp.getBmp('通用NPC窗口_下拉条底框.bmp', outing);
        listContent.SetScrollBackImage(outing);

        pgkBmp.getBmp('通用NPC道具买卖窗口.bmp', outing);
        listContent.SetBackImage(outing);
    finally
        outing.Free;
    end;

    btnCommandClose.Left := 353;
    btnCommandClose.Top := 15;
    btnCommandClose.Width := 20;
    btnCommandClose.Height := 20;
    btnCommandClose.Caption := '';
    btnCommandClose.BringToFront;

    listContent.Left := 115;
    listContent.Top := 107;
    listContent.Width := 238;
    listContent.Height := 100;
    tempup := TA2Image.Create(32, 32, 0, 0);
    tempdown := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
    listContent.SetScrollTopImage(tempUp, tempDown);
    pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
    listContent.SetScrollTrackImage(tempUp, tempDown);
    pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
    listContent.SetScrollBottomImage(tempUp, tempDown);

    lblTitleUnderBar.Visible := false;
end;

procedure TfrmNPCTrade.SetOldVersion();
begin
    FItemimg := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('装备底框.BMP', FItemimg);

    pgkBmp.getBmp('base.bmp', A2form.FImageSurface);
    A2form.boImagesurface := true;

    listContent.SetBackImage(getviewImage(1));
    listContent.SetScrollTopImage(getviewImage(7), getviewImage(6));
    listContent.SetScrollTrackImage(getviewImage(4), getviewImage(5));
    listContent.SetScrollBottomImage(getviewImage(9), getviewImage(8));
    listContent.SetScrollBackImage(getviewImage(3));
end;

procedure TfrmNPCTrade.FormDestroy(Sender: TObject);
var
    i: integer;
begin

    TA2ButtonLIST_Clear;
    TA2ButtonLIST.Free;

    cmdlist.Free;

    ITMEClear;
    ITEMLIST.Free;

    FItemimg.Free;
    A2Image_1.Free;
    A2Image_2.Free;
    A2Image_3.Free;
    for i := 0 to high(TA2Labellist) do TA2Labellist[i].Free;
    tempdown.Free;
    tempup.Free;
end;

procedure TfrmNPCTrade.FormMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmNPCTrade.listContentAdxScrollDraw(ASurface: TA2Image;
    Rect: TRect; State: TDrawScrollState);
begin
    //

end;

procedure TfrmNPCTrade.DblBuy(akey: integer);                                   //akey 背包 的位置  NPC 回收
var
    i: integer;
    tt: PTItemdata;
begin
    //
    if bolock then
    begin
        FrmBottom.AddChat('有密码设定', WinRGB(22, 22, 0), 0);
        exit;
    end;
    if (Visiblestate <> 3) then exit;
    ITEMLIST_index := -1;

    tt := HaveItemclass.getid(akey);
    if tt = nil then
    begin
        FrmBottom.AddChat('无此种物品', WinRGB(22, 22, 0), 0);
        exit;
    end;

    if tt.rCount > 10000 then FrmQuantity.CountMax := 10000
    else FrmQuantity.CountMax := tt.rCount;
    BuyItemKey := akey;
    itemnum := 0;
    FrmQuantity.Visible := true;

    FrmQuantity.ShowType := SH_NPCTrade;
    itemprice := tt.rPrice;
    FrmQuantity.LbCountName.Caption := tt.rViewName;
    FrmQuantity.EdCount.Text := '0';
    FrmQuantity.EdCount.SetFocus;
    FrmQuantity.EdCount.SelectAll;
    ITEMLIST_index := i;

    //
end;

procedure TfrmNPCTrade.listContentDblClick(Sender: TObject);
var
    T: PTSNPCItem;
    akey: integer;
begin
    //
    if Visiblestate = 3 then
    begin
        T := ITEMGET(listContent.ItemIndex);
        if T = nil then exit;
        akey := HaveItemclass.getnameid(t.rName);
        if akey = -1 then exit;
        DblBuy(akey);
        exit;
    end;
    if Visiblestate = 2 then
    begin
        DblSell;
        exit;
    end;
end;

procedure TfrmNPCTrade.DblSell();                                               //akey 背包 的位置
var
    i: integer;
    T: PTSNPCItem;
    tt: PTItemdata;
begin
    //
    if bolock then
    begin
        FrmBottom.AddChat('有密码设定', WinRGB(22, 22, 0), 0);
        exit;
    end;
    if (Visiblestate <> 2) then exit;
    ITEMLIST_index := -1;
    i := listContent.ItemIndex;
    if (I >= 0) and (I < listContent.Count) then
    begin
        T := ITEMGET(I);
        if T <> nil then
        begin
            if (Visiblestate = 2) then
            begin
                FrmQuantity.CountMax := 10000;
                tt := HaveItemclass.getname((t.rName));
                if tt <> nil then
                begin
                    FrmQuantity.CountMax := 10000 - tt.rCount;
                    if FrmQuantity.CountMax < 0 then FrmQuantity.CountMax := 0;
                end;
                tt := HaveItemclass.getname('钱币');
                if tt = nil then FrmQuantity.CountMax := 0
                else
                begin
                    if (t.rPrice * FrmQuantity.CountMax) > tt.rCount then
                    begin
                        //钱不够
                        FrmQuantity.CountMax := tt.rCount div t.rPrice;
                    end;

                end;

            end;

            itemnum := 0;
            FrmQuantity.Visible := true;

            FrmQuantity.ShowType := SH_NPCTrade;
            itemprice := t.rPrice;
            FrmQuantity.LbCountName.Caption := (T.rName);
            FrmQuantity.EdCount.Text := '0';
            FrmQuantity.EdCount.SetFocus;
            FrmQuantity.EdCount.SelectAll;
            ITEMLIST_index := i;
        end;
        //
    end;

end;

procedure TfrmNPCTrade.btnCommandCloseClick(Sender: TObject);
var
    i: integer;

    cnt: INTEGER;
    STR: string;
    temp: TWordComData;
begin
    if FrmLogon.ISMsgCmd(CM_NPCTrade) = false then exit;
    if FrmLogon.ISMsgCmd(CM_MENUsay) = false then exit;

    if FrmQuantity.Visible then FrmQuantity.Visible := false;
    if sender = btnCommandClose then
    begin
        A2ILabeItemInput0.Visible := false;
        A2ILabeItemInput1.Visible := false;
        A2ILabeItemInput2.Visible := false;
        A2ILabeItemInput3.Visible := false;
        A2ILabeItemInput4.Visible := false;
        SendNPCWindowsCancel;
        Visible := false;
        EXIT;
    end;
    i := TA2ButtonLIST.IndexOf(sender);
    if i >= 0 then
    begin
        A2ILabeItemInput0.Visible := false;
        A2ILabeItemInput1.Visible := false;
        A2ILabeItemInput2.Visible := false;
        A2ILabeItemInput3.Visible := false;
        A2ILabeItemInput4.Visible := false;
        STR := cmdlist.Strings[i];
        if LowerCase(str) = '@exit' then
        begin

            SendNPCWindowsCancel;
            Visible := false;
            EXIT;
        end;
        if LowerCase(str) = '@buy' then
        begin
            frmNPCTrade.SendNPCselldir;
            Visible := false;
            EXIT;
        end;
        if LowerCase(str) = '@sell' then
        begin
            frmNPCTrade.SendNPCbuydir;
            Visible := false;
            EXIT;
        end;
        if LowerCase(str) = '@logitem' then
        begin
            frmNPCTrade.SendNPClogitem;
            Visible := false;

            EXIT;
        end;
        if LowerCase(str) = '@email' then
        begin
            frmNPCTrade.SendNPCemail;
            Visible := false;

            EXIT;
        end;
        if LowerCase(str) = '@auction' then
        begin
            frmNPCTrade.SendNPCauction;
            Visible := false;

            EXIT;
        end;
        if LowerCase(str) = '@upitemlevel' then
        begin
            frmNPCTrade.SendNPCUPItemLeve;
            Visible := false;

            EXIT;
        end;
        if LowerCase(str) = '@upitemsetting' then
        begin
            frmNPCTrade.SendNPCUPItemSetting;
            Visible := false;

            EXIT;
        end;
        if LowerCase(str) = '@upitemsettingdel' then
        begin
            frmNPCTrade.SendNPCUPItemSettingDel;
            Visible := false;

            EXIT;
        end;

        temp.Size := 0;
        WordComData_ADDbyte(temp, CM_MENUsay);
        WordComData_ADDstring(temp, STR);
        FrmLogon.SocketAddData(temp.Size, @temp.data);
        Visible := false;
    end;

end;
//    Visible := false;
  //  FrmQuantity.Visible := false;

procedure TfrmNPCTrade.SendNPCOK();
var
    cnpc: TCNPC;
    cnt: integer;
begin
    if FrmQuantity.Visible then FrmQuantity.Visible := false;

    //确认
    cnpc.rmsg := CM_NPCTrade;
    cnpc.rKEY := menuFT_OK;
    cnt := sizeof(cnpc);
    FrmLogon.SocketAddData(cnt, @cnpc);
    Visible := false;
    FrmBottom.SetFocus;
    FrmBottom.EdChat.SetFocus;

end;

procedure TfrmNPCTrade.SendNPCCancel();
var
    cnpc: TCNPC;
    cnt: integer;
begin
    if FrmQuantity.Visible then FrmQuantity.Visible := false;

    //确认
    cnpc.rmsg := CM_NPCTrade;
    cnpc.rKEY := menuFT_Cancel;
    cnt := sizeof(cnpc);
    FrmLogon.SocketAddData(cnt, @cnpc);
    Visible := false;
    SAY_EdChatFrmBottomSetFocus;

end;

procedure TfrmNPCTrade.SendNPCWindowsCancel();
var
    cnpc: TCNPC;
    cnt: integer;
begin
    cnpc.rmsg := CM_NPCTrade;
    cnpc.rKEY := menuFT_windowsclse;
    cnt := sizeof(cnpc);
    FrmLogon.SocketAddData(cnt, @cnpc);
    Visible := false;
    SAY_EdChatFrmBottomSetFocus;
end;

procedure TfrmNPCTrade.SendNPCbuf(aname: string; anum: integer);
var
    cnpc: TCNPC;
    cnt: integer;
    T: PTSNPCItem;
begin
    //NPC  出售 物品
    if Visiblestate <> 2 then exit;
    t := ITEMGETname(aName);
    if t = nil then exit;
    cnpc.rmsg := CM_NPCTrade;
    cnpc.rKEY := menuFT_BUY;
    cnpc.rItemKey := t.rkey;
    cnpc.rnum := anum;
    cnt := sizeof(cnpc);
    if cnpc.rnum > 0 then
    begin
        FrmLogon.SocketAddData(cnt, @cnpc);
    end;
end;

procedure TfrmNPCTrade.SendNPCsell(aitemKey: integer; anum: integer);
var
    cnpc: TCNPC;
    cnt: integer;
    titem: PTItemdata;
begin
    //NPC 收购 物品
    if Visiblestate <> 3 then exit;
    titem := HaveItemclass.getid(aitemKey);
    if titem = nil then exit;

    cnpc.rmsg := CM_NPCTrade;
    cnpc.rKEY := menuFT_sell;
    cnpc.rItemKey := aitemKey;
    cnpc.rnum := anum;
    cnt := sizeof(cnpc);
    if cnpc.rnum > 0 then
    begin
        FrmLogon.SocketAddData(cnt, @cnpc);
    end;
end;

procedure TfrmNPCTrade.SendNPCsellDIR();                                        //购买
var
    cnpc: TCNPC;
    cnt: integer;
begin
    cnpc.rmsg := CM_NPCTrade;
    cnpc.rKEY := menuFT_SELLDIR;
    cnt := sizeof(cnpc);
    FrmLogon.SocketAddData(cnt, @cnpc);
end;

procedure TfrmNPCTrade.SendNPCbuyDIR();                                         //出售
var
    cnpc: TCNPC;
    cnt: integer;
begin
    cnpc.rmsg := CM_NPCTrade;
    cnpc.rKEY := menuFT_BUYDIR;
    cnt := sizeof(cnpc);
    FrmLogon.SocketAddData(cnt, @cnpc);

end;

procedure TfrmNPCTrade.SendNPCauction();
var
    cnpc: TCNPC;
    cnt: integer;
begin
    cnpc.rmsg := CM_NPCTrade;
    cnpc.rKEY := menuFT_auction;
    cnt := sizeof(cnpc);
    FrmLogon.SocketAddData(cnt, @cnpc);
    Visible := false;
end;

procedure TfrmNPCTrade.SendNPCUPItemSetting();
var
    cnpc: TCNPC;
    cnt: integer;
begin
    cnpc.rmsg := CM_NPCTrade;
    cnpc.rKEY := menuFT_UPdateItem_Setting;
    cnt := sizeof(cnpc);
    FrmLogon.SocketAddData(cnt, @cnpc);
    Visible := false;
end;

procedure TfrmNPCTrade.SendNPCUPItemSettingDel();
var
    cnpc: TCNPC;
    cnt: integer;
begin
    cnpc.rmsg := CM_NPCTrade;
    cnpc.rKEY := menuFT_UPdateItem_Setting_del;
    cnt := sizeof(cnpc);
    FrmLogon.SocketAddData(cnt, @cnpc);
    Visible := false;
end;

procedure TfrmNPCTrade.SendNPCUPItemLeve();
var
    cnpc: TCNPC;
    cnt: integer;
begin
    cnpc.rmsg := CM_NPCTrade;
    cnpc.rKEY := menuFT_UPdateItem_UPLevel;
    cnt := sizeof(cnpc);
    FrmLogon.SocketAddData(cnt, @cnpc);
    Visible := false;
end;

procedure TfrmNPCTrade.SendNPCEmail();
var
    cnpc: TCNPC;
    cnt: integer;
begin
    cnpc.rmsg := CM_NPCTrade;
    cnpc.rKEY := menuFT_email;
    cnt := sizeof(cnpc);
    FrmLogon.SocketAddData(cnt, @cnpc);
    Visible := false;
end;

procedure TfrmNPCTrade.SendNPClogitem();                                        //仓库
var
    cnpc: TCNPC;
    cnt: integer;
begin
    cnpc.rmsg := CM_NPCTrade;
    cnpc.rKEY := menuFT_logitem;
    cnt := sizeof(cnpc);
    FrmLogon.SocketAddData(cnt, @cnpc);
    Visible := false;
end;

procedure TfrmNPCTrade.listContentAdxDrawItem(ASurface: TA2Image;
    index: Integer; aStr: string; Rect: TRect; State: TDrawItemState; fx,
    fy: Integer);

var
    tt: TA2Image;
    i1, x, y: integer;
    t1: PTSNPCItem;
    str1, sprice, srCount: string;
    R, r2: TRect;
    fx1, fy1: integer;
    aWidthnum, aWidthprice
        : integer;
    FGreenCol,
        FGreenAdd: integer;
begin
    aWidthnum := 30;
    aWidthprice := 45;
    //   if Visiblestate = 2 then
    begin
        R := listContent.ClientRect;
        OffsetRect(R, left, top);

        t1 := ITEMGET(index);
        if t1 = nil then
        begin
            i1 := 0;
            str1 := '错误物品';
            sprice := '价格';
            srCount := '';
            FGreenCol := 0;
            FGreenAdd := 0;
        end
        else
        begin

            GetGreenColorAndAdd(t1.rColor, FGreenCol, FGreenAdd);

            FGreenAdd := 0;
            i1 := t1.rShape;
            str1 := (t1.rName);
            if t1.rCount > 0 then
                srCount := inttostr(t1.rCount) + '个'
            else srCount := '';

            sprice := inttostr(t1.rPrice);
        end;

        tt := AtzClass.GetItemImage(i1);
        x := (listContent.ItemHeight - tt.Width) div 2;
        y := (listContent.ItemHeight - tt.Height) div 2;

        if FGreenCol = 0 then
            ASurface.DrawImage(tt, x, y, TRUE)
        else ASurface.DrawImageGreenConvert(tt, x, y, FGreenCol, FGreenAdd);
        // ASurface.DrawImageAdd(tt, x, y);

  // if listContent.FontEmphasis then ATextOut(ASurface, fx + 1 + 40, fy + 1, WinRGB(1, 1, 1), str1);
  // ATextOut(ASurface, fx + 40, fy, listContent.FontColor, str1);
        if srCount <> '' then
        begin
            aWidthnum := aWidthnum - ATextWidth(srCount);

            ATextOut(ASurface, fx + 140 + aWidthnum, fy, listContent.FontColor, srCount);
        end;
        aWidthprice := aWidthprice - ATextWidth(sprice);
        ATextOut(ASurface, fx + 170 + aWidthprice, fy, listContent.FontColor, sprice);

    end;

end;

procedure TfrmNPCTrade.listContentDragDrop(Sender, Source: TObject; X,
    Y: Integer);
var
    tp: TDragItem;
begin
    if Source = nil then exit;

    tp := pointer(Source);
    if tp.SourceID <> WINDOW_ITEMS then exit;
    if Visiblestate <> 3 then exit;
    dblBuy(tp.Selected);
end;

procedure TfrmNPCTrade.listContentDragOver(Sender, Source: TObject; X,
    Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := FALSE;
    if Source <> nil then
    begin
        with Source as TDragItem do
        begin
            if SourceID = WINDOW_ITEMS then
            begin
                Accept := TRUE;
            end;
        end;
    end;
end;

procedure TfrmNPCTrade.listContentStartDrag(Sender: TObject;
    var DragObject: TDragObject);
begin
    //
end;

procedure TfrmNPCTrade.A2ILabeItemInput0DblClick(Sender: TObject);
begin
    if (TA2ILabel(Sender).Tag < 0) or (TA2ILabel(Sender).Tag > 4) then exit;
    ItemInputKeyArrDel(TA2ILabel(Sender).Tag);
    sendItemInpuKey(TA2ILabel(Sender).Tag, -1);
end;

procedure TfrmNPCTrade.A2ILabeItemInput0DragDrop(Sender, Source: TObject; X, Y: Integer);
var
    n: integer;
    akey: integer;
begin
    if (TA2ILabel(Sender).Tag < 0) or (TA2ILabel(Sender).Tag > 4) then exit;
    if Source = nil then exit;
    with Source as TDragItem do
    begin
        if SourceID <> WINDOW_ITEMS then exit;
        n := TA2ILabel(Sender).Tag;
        ItemInputKeyArr[TA2ILabel(Sender).Tag].rkey := Selected;
        akey := ItemInputKeyArr[TA2ILabel(Sender).Tag].rkey;
        setitemshpe(TA2ILabel(Sender), akey);

        sendItemInpuKey(n, akey);

    end;
end;

procedure TfrmNPCTrade.A2ILabeItemInput0DragOver(Sender, Source: TObject; X,
    Y: Integer; State: TDragState; var Accept: Boolean);
begin
    if (TA2ILabel(Sender).Tag < 0) or (TA2ILabel(Sender).Tag > 4) then exit;
    Accept := FALSE;
    if Source <> nil then
    begin
        with Source as TDragItem do
        begin
            if SourceID = WINDOW_ITEMS then Accept := TRUE;
        end;
    end;
end;

procedure TfrmNPCTrade.A2ILabeItemInput0MouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
var
    pp: PTItemdata;
begin
    if (TA2ILabel(Sender).Tag < 0) or (TA2ILabel(Sender).Tag > 4) then exit;
    if tA2ILabel(Sender).A2Image = nil then exit;

    pp := HaveItemclass.getid(ItemInputKeyArr[TA2ILabel(Sender).Tag].rkey);
    if pp = nil then
    begin
        GameHint.setText(integer(Sender), ItemInputKeyArr[TA2ILabel(Sender).Tag].rtext);
        exit;
    end;
    if pp.rViewName <> '' then GameHint.setText(integer(Sender), TItemDataToStr(pp^))
    else
        GameHint.Close;
end;

procedure TfrmNPCTrade.sendItemInpuKey(awinsub, akey: integer);
var
    temp: TWordComData;
begin

    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_ItemInputWindows);
    WordComData_ADDbyte(temp, ItemInputWindows_key);
    WordComData_ADDbyte(temp, awinsub);
    WordComData_ADDdword(temp, akey);

    FrmLogon.SocketAddData(temp.Size, @temp.data);

end;

procedure TfrmNPCTrade.setitemshpe(Lb: TA2ILabel; aitemid: integer);
var
    pp: PTItemdata;
    idx: integer;
begin
    pp := HaveItemclass.getid(aitemid);
    if pp = nil then
    begin
        Lb.A2Image := Lb.A2Imageback;
        exit;
    end;

    if pp.rlockState = 1 then idx := 24
    else if pp.rlockState = 2 then idx := 25
    else idx := 0;
    FrmAttrib.SetItemLabel(lb
        , ''
        , pp.rColor
        , pp.rShape
        , idx, 0
        );
    if lb.A2Image = nil then Lb.A2Image := Lb.A2Imageback;
end;

procedure TfrmNPCTrade.FormMouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
begin
    GameHint.Close;
end;

procedure TfrmNPCTrade.A2ILabeItemInput0MouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if (TA2ILabel(Sender).Tag < 0) or (TA2ILabel(Sender).Tag > 4) then exit;
    if Button = mbRight then A2ILabeItemInput0DblClick(Sender);
end;

procedure TfrmNPCTrade.ItemInputKeyArrClear;
var
    i: integer;
begin
    for i := 0 to high(ItemInputKeyArr) do
    begin

        ItemInputKeyArr[i].rkey := -1;
        ItemInputKeyArr[i].rcap := '';
        ItemInputKeyArr[i].rtext := '';
        A2ILabelItemInputArr[i].A2Image := FItemimg;
        A2ILabelItemInputArr[i].A2Imageback := FItemimg;
        A2ILabelItemInputArr[i].A2ImageRDown := nil;
        A2ILabelItemInputArr[i].A2ImageLUP := nil;

        A2LabelItemInputCapArr[i].Caption := '';

        A2ILabelItemInputArr[i].Visible := false;
        A2LabelItemInputCapArr[i].Visible := false;
    end;
    GameHint.Close;
end;

procedure TfrmNPCTrade.ItemInputKeyArrSetIndex;
var
    i: integer;
begin
    for i := 0 to high(ItemInputKeyArr) do
        A2ILabelItemInputArr[i].Tag := i;
end;

procedure TfrmNPCTrade.ItemInputKeyArrDel(asubkey: integer);
begin
    if (asubkey < 0) or (asubkey > high(ItemInputKeyArr)) then exit;
    ItemInputKeyArr[asubkey].rkey := -1;
 //   ItemInputKeyArr[asubkey].rcap := '';
//    ItemInputKeyArr[asubkey].rtext := '';
    A2ILabelItemInputArr[asubkey].A2Image := FItemimg;
    A2ILabelItemInputArr[asubkey].A2Imageback := FItemimg;
    A2ILabelItemInputArr[asubkey].A2ImageRDown := nil;
    A2ILabelItemInputArr[asubkey].A2ImageLUP := nil;

  //  A2LabelItemInputCapArr[asubkey].Caption := '';
    GameHint.Close;
end;

procedure TfrmNPCTrade.A2Label_itemInput4MouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.Close;
end;

procedure TfrmNPCTrade.ItemInputKeyArrOpen(asubkey: integer);
begin
    if (asubkey < 0) or (asubkey > high(ItemInputKeyArr)) then exit;
    A2ILabelItemInputArr[asubkey].Visible := true;
    A2LabelItemInputCapArr[asubkey].Caption := ItemInputKeyArr[asubkey].rcap;
    A2LabelItemInputCapArr[asubkey].Visible := true;
end;

end.

