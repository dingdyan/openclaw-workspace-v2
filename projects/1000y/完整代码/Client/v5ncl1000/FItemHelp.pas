unit FItemHelp;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics,
    Controls, Forms, Dialogs, StdCtrls, Deftype, A2Img, AUtil32,
    A2Form, ExtCtrls;
type
    TfrmItemHelp = class(TForm)
        A2Form:TA2Form;
        btnClose:TA2Button;
        imgItem:TA2ILabel;
        listContent:TA2ListBox;
        lbItemName:TA2Label;
        lbGrade:TA2Label;
        btnReserved:TA2Button;
        A2Label1:TA2Label;
        btnLock:TA2Button;
        procedure FormCreate(Sender:TObject);
        procedure btnCloseClick(Sender:TObject);
        procedure FormDestroy(Sender:TObject);
        procedure btnLockClick(Sender:TObject);
        procedure btnReservedClick(Sender:TObject);
        procedure FormMouseDown(Sender:TObject; Button:TMouseButton;
            Shift:TShiftState; X, Y:Integer);

    private
        { Private declarations }
    public
        { Public declarations }

        procedure MessageProcess(var code:TWordComData);
        procedure showSAY(str:string);
        procedure ShowProItem(aitemkey:integer);

        procedure SetNewVersion;
        procedure SetOldVersion;
    end;

var
    frmItemHelp     :TfrmItemHelp;
    frmItemHelpitemPro:TSitemPro;
    frmItemHelpitemPro_KEY:INTEGER;
    //AtzClass.GetItemImage
implementation

uses FNPCTrade, FMain, AtzCls, FAttrib, FQuantity, FLogOn, FDepository, filepgkclass,
    FBottom;

{$R *.DFM}

function GetItemDataInfo(var aItemData:TItemData):string;
var
    str             :string;
begin
    Result := '';
    // if aItemData.rName = '' then exit;
     //名字
    Result := Result + (aItemData.rViewName) + #13;
    //描述
   // str := ItemClass.getdesc(aItemData.rName);
    if str <> '' then Result := Result + str + #13;
    //持久
    if aItemData.rDurability <> 0 then
        Result := Result + format('耐力: %d/%d', [aItemData.rCurDurability, aItemData.rDurability]) + #13;
    //属性

    with aItemData.rLifeData do
    begin
        if (AttackSpeed <> 0) or (Recovery <> 0) or (Avoid <> 0) then
            Result := Result + format('攻击速度: %d   恢复: %d   躲闪: %d', [-AttackSpeed, -Recovery, Avoid]) + #13;
        if (DamageBody <> 0) or (DamageHead <> 0) or (DamageArm <> 0) or (DamageLeg <> 0) then
            Result := Result + format('破坏力: %d / %d / %d / %d', [DamageBody, DamageHead, DamageArm, DamageLeg]) + #13;
        if (ArmorBody <> 0) or (ArmorHead <> 0) or (ArmorArm <> 0) or (ArmorLeg <> 0) then
            Result := Result + format('防御力:  %d / %d / %d / %d', [ArmorBody, ArmorHead, ArmorArm, ArmorLeg]) + #13;
    end;
    if aItemData.rSmithingLevel > 0 then
        Result := Result + format('精炼等级+%d', [aItemData.rSmithingLevel]) + #13;
    //镶嵌宝石
    with aItemData.rSetting do
    begin
        if rsettingcount > 0 then
        begin
            Result := Result + format('(%d孔可镶嵌宝石)', [rsettingcount]) + #13;
            if rsettingcount >= 1 then
                if rsetting1 <> '' then Result := Result + ' +' + rsetting1 + #13;
            if rsettingcount >= 2 then
                if rsetting2 <> '' then Result := Result + ' +' + rsetting2 + #13;
            if rsettingcount >= 3 then
                if rsetting3 <> '' then Result := Result + ' +' + rsetting3 + #13;
            if rsettingcount >= 4 then
                if rsetting4 <> '' then Result := Result + ' +' + rsetting4 + #13;
        end;
    end;
    //价格
    Result := Result + format('价格: %d', [aItemData.rPrice]) + #13;
end;

procedure TfrmItemHelp.ShowProItem(aitemkey:integer);
var
    aitem           :PTitemdata;
begin
    frmItemHelpitemPro_KEY := aitemkey;
    aitem := HaveItemclass.getid(aitemkey);
    if aitem = nil then exit;
    if aitem.rViewName = '' then exit;

    with aitem^ do
    begin
        if rGrade > 0 then
            lbGrade.Caption := format('[%d品]', [rGrade])
        else lbGrade.Caption := '';
        if rlockState = 1 then
        begin
            //rlockUPtime
            //锁
            btnReserved.Visible := true;
            A2Label1.Visible := false;

            btnLock.Visible := false;
        end
        else if rlockState = 2 then
        begin                      //解锁 中
            btnReserved.Visible := false;
            A2Label1.Visible := true;
            btnLock.Visible := true;
            A2Label1.Caption := format('解锁时间已过:%.2f小时', [(rlocktime / 60)]);
        end
        else if rlockState = 0 then
        begin                      //非锁
            btnReserved.Visible := false;
            A2Label1.Visible := false;
            btnLock.Visible := true;
        end;

        if rSmithingLevel > 0 then
            lbItemName.Caption := format('%s %d级', [(rname), rSmithingLevel])
        else
            lbItemName.Caption := (rViewName);

        showSAY(GetItemDataInfo(aitem^));
        FrmAttrib.SetItemLabel(imgItem, '', rcolor, rshape, 0, 0);

        Visible := true;
        FrmM.move_win_form_Align(Self, mwfCenter);
        FrmM.SetA2Form(Self, A2form);

    end;
end;

procedure TfrmItemHelp.showSAY(str:string);
var
    i               :integer;
    s               :string;
begin
    listContent.Clear;
    s := '';
    for i := 1 to length(str) do
    begin
        if str[i] = #13 then
        begin
            listContent.AddItem(s);
            s := '';
        end else
        begin
            S := S + STR[I];
        end;
    end;
    if S <> '' then listContent.AddItem(s);
    //    listContent.AddItem(t.Strings[i]);

end;

procedure TfrmItemHelp.MessageProcess(var code:TWordComData);
var
    pckey           :PTCKey;
    itemPro         :pTSitemPro;

begin
    pckey := @Code.Data;
    case pckey^.rmsg of

        SM_itempro:
            begin
                itemPro := @Code.Data;
                if itemPro.rkey = itemproGET then
                begin
                    frmItemHelpitemPro := itemPro^;
                    with itemPro^ do
                    begin
                        if rGrade > 0 then
                            lbGrade.Caption := format('[%d品]', [rGrade])
                        else lbGrade.Caption := '';
                        if rlockState = 1 then
                        begin
                            //rlockUPtime
                            //锁
                            btnReserved.Visible := true;
                            A2Label1.Visible := false;
                            btnLock.Visible := false;
                        end
                        else if rlockState = 2 then
                        begin      //解锁 中
                            btnReserved.Visible := false;
                            A2Label1.Visible := true;
                            btnLock.Visible := true;
                            A2Label1.Caption := format('解锁时间已过:%.2f小时', [(rlocktime / 60)]);
                        end
                        else if rlockState = 0 then
                        begin      //非锁
                            btnReserved.Visible := false;
                            A2Label1.Visible := false;
                            btnLock.Visible := true;
                        end;

                        if rSmithingLevel > 0 then
                            lbItemName.Caption := format('%s %d级', [(rname), rSmithingLevel])
                        else
                            lbItemName.Caption := (rname);

                        showSAY(GetWordString(rWordString));
                        FrmAttrib.SetItemLabel(imgItem, '', rcolor, rshape, 0, 0);
                    end;

                    Visible := true;
                    FrmM.move_win_form_Align(Self, mwfCenter);
                    FrmM.SetA2Form(Self, A2form);

                end;
                {
                else if itemPro.rkey = itemproGET_MagicBasic then
                begin
                    with itemPro^ do
                    begin
                        lbGrade.Caption := '';

                        btnReserved.Visible := false;
                        A2Label1.Visible := false;
                        btnLock.Visible := false;
                        A2Label1.Caption := '';

                        lbItemName.Caption := (rname);

                        showSAY(GetWordString(rWordString));
                        FrmAttrib.SetItemLabel(imgItem, '', 0, rshape, 0, 0);
                    end;

                    Visible := true;
                    FrmM.move_win_form_Align(Self, mwfCenter);
                    FrmM.SetA2Form(Self, A2form);
                end;}
            end;
    end;
end;

procedure TfrmItemHelp.SetNewVersion;
var
    temping, tempUp, tempDown:TA2Image;
begin
//    A2Form.TransParent := true;
    temping := TA2Image.Create(32, 32, 0, 0);
    tempUp := TA2Image.Create(32, 32, 0, 0);
    tempDown := TA2Image.Create(32, 32, 0, 0);
    try
        pgkBmp.getBmp('道具属性窗口.BMP', A2form.FImageSurface);
        A2form.boImagesurface := true;
        Width := A2Form.FImageSurface.Width;
        Height := A2Form.FImageSurface.Height;

        pgkBmp.getBmp('道具属性_加锁_弹起.bmp', temping);
        btnLock.A2Up := temping;
        pgkBmp.getBmp('道具属性_加锁_按下.bmp', temping);
        btnLock.A2Down := temping;
        pgkBmp.getBmp('道具属性_加锁_鼠标.bmp', temping);
        btnLock.A2Mouse := temping;
        pgkBmp.getBmp('道具属性_加锁_禁止.bmp', temping);
        btnLock.A2NotEnabled := temping;
        btnLock.Caption := '';
        btnLock.Left := 155;
        btnLock.Top := 152;

        pgkBmp.getBmp('道具属性_解锁_弹起.bmp', temping);
        btnReserved.A2Up := temping;
        pgkBmp.getBmp('道具属性_解锁_按下.bmp', temping);
        btnReserved.A2Down := temping;
        pgkBmp.getBmp('道具属性_解锁_鼠标.bmp', temping);
        btnReserved.A2Mouse := temping;
        pgkBmp.getBmp('道具属性_解锁_禁止.bmp', temping);
        btnReserved.A2NotEnabled := temping;
        btnReserved.Caption := '';
        btnReserved.Left := 155;
        btnReserved.Top := 152;

        pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
        btnClose.A2Up := temping;
        pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
        btnClose.A2Down := temping;
        pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
        btnClose.A2Mouse := temping;
        pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
        btnClose.A2NotEnabled := temping;
        btnClose.Caption := '';
        btnClose.Left := 210;
        btnClose.Top := 14;

        pgkBmp.getBmp('道具属性_道具底框.bmp', temping);
        imgItem.A2Imageback := temping;
        imgItem.Left := 22;
        imgItem.Top := 37;
        imgItem.Width := 40;
        imgItem.Height := 40;

        listContent.Left := 21;
        listContent.Top := 77;
        listContent.Width := 206;
        listContent.Height := 71;
        pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
        listContent.SetScrollTopImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
        listContent.SetScrollTrackImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
        listContent.SetScrollBottomImage(tempUp, tempDown);
        pgkBmp.getBmp('道具属性_下拉条底框.bmp', temping);
        listContent.SetScrollBackImage(temping);

        lbGrade.Left := 22;
        lbGrade.Top := 17;
        lbItemName.Left := 64;
        lbItemName.Top := 17;

        A2Label1.Left := 18;
        A2Label1.Top := 152;
    finally
        tempUp.Free;
        tempDown.Free;
        temping.Free;
    end;

end;

procedure TfrmItemHelp.SetOldVersion;
begin
    pgkBmp.getBmp('itembase2.bmp', A2form.FImageSurface);
    A2form.boImagesurface := true;
    //   listContent.SetBackImage(getviewImage(10));
    listContent.SetScrollTopImage(getviewImage(20), getviewImage(21));
    listContent.SetScrollTrackImage(getviewImage(22), getviewImage(23));
    listContent.SetScrollBottomImage(getviewImage(18), getviewImage(19));
    //  listContent.SetScrollBackImage(getviewImage(2));
     //listContent.FFontSelBACKColor := 31;
end;

procedure TfrmItemHelp.FormCreate(Sender:TObject);
begin
    FrmM.AddA2Form(Self, A2form);
    Left := 0;
    Top := 0;

    if WinVerType = wvtNew then
    begin
        SetNewVersion;
    end
    else if WinVerType = wvtOld then
    begin
        SetOldVersion;
    end;

    listContent.FLayout := tlCenter;

end;

procedure TfrmItemHelp.btnCloseClick(Sender:TObject);
begin
    Visible := false;
    FrmBottom.SetFocus;
    FrmBottom.EdChat.SetFocus;
end;

procedure TfrmItemHelp.FormDestroy(Sender:TObject);
begin
    //
end;

procedure TfrmItemHelp.btnLockClick(Sender:TObject);
//

var
    tt              :TGET_cmd;
    cnt             :integer;

begin

    tt.rmsg := CM_itempro;
    tt.rKEY := itemprolock;
    tt.rKEY2 := frmItemHelpitemPro_KEY;
    cnt := sizeof(TT);
    FrmLogon.SocketAddData(cnt, @TT);
    Visible := FALSE;
end;

procedure TfrmItemHelp.btnReservedClick(Sender:TObject);
var
    tt              :TGET_cmd;
    cnt             :integer;

begin

    tt.rmsg := CM_itempro;
    tt.rKEY := itemproUNlock;
    tt.rKEY2 := frmItemHelpitemPro_KEY;
    cnt := sizeof(TT);
    FrmLogon.SocketAddData(cnt, @TT);
    Visible := FALSE;
end;

procedure TfrmItemHelp.FormMouseDown(Sender:TObject; Button:TMouseButton;
    Shift:TShiftState; X, Y:Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

end.

