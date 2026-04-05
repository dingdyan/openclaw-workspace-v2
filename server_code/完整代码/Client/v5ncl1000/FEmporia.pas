unit FEmporia;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, A2Form, StdCtrls, deftype, uKeyClass, ExtCtrls, A2Img;

type
    TEmporiadata = record
        id: integer;
        index: INTEGER;
        rColor
            , rShape: integer;
        name: string[32];
        text: string[255];
        num, price: integer;
    end;
    pTEmporiadata = ^TEmporiadata;

    TfrmEmporia = class(TForm)
        A2Form: TA2Form;
        A2Button1: TA2Button;
        A2Button2: TA2Button;
        A2Button3: TA2Button;
        A2Button4: TA2Button;
        A2Button5: TA2Button;
        Panel_buy_ok: TPanel;
        A2Button_BUY: TA2Button;
        A2Button_BUYclose: TA2Button;
        A2Edit_select_num: TA2Edit;
        A2ILabel_select_item: TA2ILabel;
        A2Label_select_name: TA2Label;
        A2Button_close: TA2Button;
        A2ILabel_buy_kuang: TA2ILabel;
        A2ListBox_itemText: TA2ListBox;
        Panel_itemList: TPanel;
        A2ILabel1: TA2ILabel;
        A2ILabel_BACK: TA2ILabel;
        A2ListBox_result: TA2ListBox;
        A2ILabel_money: TA2Label;
        A2Button6: TA2Button;
        A2ILabel2: TA2ILabel;
        A2ILabel3: TA2ILabel;
        A2ILabel4: TA2ILabel;
        A2ILabel5: TA2ILabel;
        A2ILabel6: TA2ILabel;
        A2ILabel7: TA2ILabel;
        A2ILabel8: TA2ILabel;
        A2ILabel9: TA2ILabel;
        A2ILabel10: TA2ILabel;
        A2ILabel11: TA2ILabel;
        A2ILabel12: TA2ILabel;
        A2Label_price: TA2Label;
        A2ILabel13: TA2ILabel;
        A2ILabel14: TA2ILabel;
        A2ILabel15: TA2ILabel;
        A2ILabel16: TA2ILabel;
        A2ILabel17: TA2ILabel;
        A2ILabel18: TA2ILabel;
        A2ILabel19: TA2ILabel;
        A2ILabel20: TA2ILabel;
        A2ILabel21: TA2ILabel;
        A2ILabel22: TA2ILabel;
        A2ILabel23: TA2ILabel;
        A2ILabel24: TA2ILabel;
        A2ILabel25: TA2ILabel;
        A2ILabel26: TA2ILabel;
        A2ILabel27: TA2ILabel;
        A2ILabel28: TA2ILabel;
        A2ILabel29: TA2ILabel;
        A2ILabel30: TA2ILabel;
        A2ILabel31: TA2ILabel;
        A2ILabel32: TA2ILabel;
        A2ILabel33: TA2ILabel;
        A2ILabel34: TA2ILabel;
        A2ILabel35: TA2ILabel;
        A2ILabel36: TA2ILabel;
        A2ILabel37: TA2ILabel;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure A2ILabel1Click(Sender: TObject);
        procedure A2Button_BUYClick(Sender: TObject);
        procedure A2Button_closeClick(Sender: TObject);
        procedure A2Button1Click(Sender: TObject);
        procedure A2Button_BUYcloseClick(Sender: TObject);
        procedure A2ILabel1MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure A2Edit_select_numChange(Sender: TObject);
        procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
    private
        { Private declarations }
    public
        { Public declarations }
        fbackimg: TA2Image;
        fOKimg: TA2Image;
        Fkuangimg: TA2Image;
        itemArr: array[0..18 - 1] of TA2ILabel;
        FkuangitemArr: array[0..18 - 1] of TA2ILabel;
        select_menu_item: integer;
        fdata: tlist;
        FindexName: TStringKeyClass;
        procedure CLEAR();
        procedure add(var aitem: TEmporiadata);
        function get(aname: string): pTEmporiadata;
        function getid(aid: integer): pTEmporiadata;
        procedure MessageProcess(var code: TWordComData);

        procedure itempaint();
        procedure setitemshpe(Lb: TA2ILabel; var aitem: TEmporiadata);
        procedure sendBuy(aitemname: string; acount: integer);

        procedure sendshowForm();

        procedure addlog(atext: string);

        procedure SetNewVersion;
        procedure SetOldVersion;
    end;

var
    frmEmporia: TfrmEmporia;

implementation

{$R *.dfm}
uses FAttrib, FMain, FLogOn, AUtil32, FBottom, filepgkclass;

procedure TfrmEmporia.setitemshpe(Lb: TA2ILabel; var aitem: TEmporiadata);
var

    idx: integer;
begin

    FrmAttrib.SetItemLabel(lb
        , ''
        , aitem.rColor
        , aitem.rShape
        , 0, 0
        );
end;

procedure TfrmEmporia.itempaint();
var
    i, j: integer;
    pp: pTEmporiadata;
begin

    for i := 0 to 18 - 1 do
    begin
        itemArr[i].A2Image := nil;
        itemArr[i].A2ImageLUP := nil;
        itemArr[i].A2ImageRDown := nil;
        itemArr[i].Caption := '';
    end;
    j := 0;
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];
        if pp.index = select_menu_item then
        begin
            if (j < 18) and (j >= 0) then
            begin
                pp.id := j;
                setitemshpe(itemArr[j], pp^);
            end;
            inc(j);
        end;

    end;
    Panel_buy_ok.Visible := false;
    Panel_itemList.Visible := not Panel_buy_ok.Visible;
    A2ListBox_itemText.Clear;
end;

procedure TfrmEmporia.addlog(atext: string);
begin
    A2ListBox_result.AddItem(inttostr(A2ListBox_result.Count) + atext);
end;

procedure TfrmEmporia.MessageProcess(var code: TWordComData);
var
    i, i1, n, akey: integer;
    PSSShowSpecialWindow: PTSShowSpecialWindow;
    aitem: TEmporiadata;
begin
    i := 0;
    akey := WordComData_GETbyte(Code, i);
    case akey of
        SM_money:
            begin
                n := WordComData_GETdword(Code, i);
                A2ILabel_money.Caption := '您目前拥有的元宝数量:' + inttostr(n);

            end;
        SM_SHOWSPECIALWINDOW:
            begin
                PSSShowSpecialWindow := @code.data;
                case PSSShowSpecialWindow.rWindow of
                    WINDOW_Close_All: Visible := false;

                    WINDOW_Emporia:
                        begin
                            FrmM.move_win_form_Align(Self, mwfCenterLeft);
                            FrmM.SetA2Form(Self, A2form);
                            Panel_buy_ok.Visible := false;
                            select_menu_item := 0;
                            itempaint;
                            A2ListBox_result.Clear;
                            Visible := true;
                        end;
                end;
            end;
        SM_Emporia:
            begin
                n := WordComData_GETbyte(Code, i);
                case n of
                    Emporia_GetItemList:
                        begin
                            CLEAR;
                            n := WordComData_GETword(Code, i);
                            for I1 := 0 to n - 1 do
                            begin
                                aitem.index := WordComData_getbyte(Code, i);
                                aitem.name := WordComData_getString(Code, i);
                                aitem.Text := WordComData_getString(Code, i);
                                aitem.num := WordComData_getdword(Code, i);
                                aitem.price := WordComData_getdword(Code, i);
                                aitem.rColor := WordComData_getword(Code, i);
                                aitem.rShape := WordComData_getword(Code, i);

                                add(aitem);
                            end;
                            select_menu_item := 0;
                            itempaint;
                        end;

                    Emporia_BUY:
                        begin
                            n := WordComData_GETbyte(Code, i);
                            case n of
                                1: addlog('数量超出范围');
                                2: addlog('名字空');
                                3: addlog('商城没有物品');
                                4: addlog('物品不存在');
                                5: addlog('物品数量限制1个');
                                6: addlog('元宝不够');
                                7: addlog('背包没空位置');
                                8: addlog('方法物品失败');
                                100: addlog('购买成功');
                            end;

                        end;
                end;

            end;

    end;

end;

function TfrmEmporia.get(aname: string): pTEmporiadata;
begin
    result := FindexName.Select(aname);
end;

function TfrmEmporia.getid(aid: integer): pTEmporiadata;
var
    i: integer;
    pp: pTEmporiadata;
begin
    result := nil;
    for i := 0 to fdata.Count - 1 do
    begin
        pp := fdata.Items[i];
        if pp.index = select_menu_item then
        begin
            if pp.id = aid then
            begin
                result := pp;
                exit;
            end;
        end;

    end;

end;

procedure TfrmEmporia.add(var aitem: TEmporiadata);
var
    pp: pTEmporiadata;
begin

    pp := get(aitem.name);
    if pp <> nil then exit;
    pp := nil;
    New(pp);
    pp^ := aitem;
    fdata.Add(pp);
    FindexName.Insert(pp.name, pp);
end;

procedure TfrmEmporia.CLEAR();
var
    I: INTEGER;
    PP: pTEmporiadata;
begin
    for I := 0 to Fdata.Count - 1 do
    begin
        PP := Fdata.Items[I];
        dispose(pp);
    end;
    Fdata.Clear;
    FindexName.Clear;

end;

procedure TfrmEmporia.SetNewVersion;
var
    outimg, tempUp, tempDown: TA2Image;
    i: integer;
begin
//    A2Form.TransParent := true;

    Fkuangimg := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('在线商城_道具底框.bmp', Fkuangimg);

    fOKimg := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('在线商城_确认购买.bmp', fOKimg);
    A2ILabel37.A2Image := fOKimg;

    A2ILabel_buy_kuang.A2Image := Fkuangimg;
    fbackimg := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('在线商城窗口.bmp', fbackimg);
    A2ILabel_BACK.A2Image := fbackimg;
    Width := fbackimg.Width;
    Height := fbackimg.Height;

    outimg := TA2Image.Create(32, 32, 0, 0);
    tempUp := TA2Image.Create(32, 32, 0, 0);
    tempDown := TA2Image.Create(32, 32, 0, 0);
    try
        pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
        A2ListBox_itemText.SetScrollTopImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
        A2ListBox_itemText.SetScrollTrackImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
        A2ListBox_itemText.SetScrollBottomImage(tempUp, tempDown);
        pgkBmp.getBmp('在线商城_下拉条底框A.bmp', outimg);
        A2ListBox_itemText.SetScrollBackImage(outimg);
        A2ListBox_itemText.FontColor := ColorSysToDxColor($00FFFF00);
        A2ListBox_itemText.FontSelColor := ColorSysToDxColor($00FFFF00);
        A2ListBox_itemText.Left := 272;
        A2ListBox_itemText.Top := 84;
        A2ListBox_itemText.Width := 138;
        A2ListBox_itemText.Height := 73;

        pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
        A2ListBox_result.SetScrollTopImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
        A2ListBox_result.SetScrollTrackImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
        A2ListBox_result.SetScrollBottomImage(tempUp, tempDown);
        pgkBmp.getBmp('在线商城_下拉条底框B.bmp', outimg);
        A2ListBox_result.SetScrollBackImage(outimg);
        A2ListBox_result.FFontSelBACKColor := ColorSysToDxColor($00FFF000);
        A2ListBox_result.FontColor := ColorSysToDxColor($00FF00FF);
        A2ListBox_result.Left := 272;
        A2ListBox_result.Top := 169;
        A2ListBox_result.Width := 138;
        A2ListBox_result.Height := 74;

        pgkBmp.getBmp('在线商城_道具_弹起.bmp', outimg);
        A2Button1.A2Up := outimg;
        pgkBmp.getBmp('在线商城_道具_按下.bmp', outimg);
        A2Button1.A2Down := outimg;
        pgkBmp.getBmp('在线商城_道具_鼠标.bmp', outimg);
        A2Button1.A2Mouse := outimg;
        pgkBmp.getBmp('在线商城_道具_禁止.bmp', outimg);
        A2Button1.A2NotEnabled := outimg;
        A2Button1.Left := 17;
        A2Button1.Top := 58;

        pgkBmp.getBmp('在线商城_药品_弹起.bmp', outimg);
        A2Button2.A2Up := outimg;
        pgkBmp.getBmp('在线商城_药品_按下.bmp', outimg);
        A2Button2.A2Down := outimg;
        pgkBmp.getBmp('在线商城_药品_鼠标.bmp', outimg);
        A2Button2.A2Mouse := outimg;
        pgkBmp.getBmp('在线商城_药品_禁止.bmp', outimg);
        A2Button2.A2NotEnabled := outimg;
        A2Button2.Left := 73;
        A2Button2.Top := 58;

        pgkBmp.getBmp('在线商城_时装_弹起.bmp', outimg);
        A2Button3.A2Up := outimg;
        pgkBmp.getBmp('在线商城_时装_按下.bmp', outimg);
        A2Button3.A2Down := outimg;
        pgkBmp.getBmp('在线商城_时装_鼠标.bmp', outimg);
        A2Button3.A2Mouse := outimg;
        pgkBmp.getBmp('在线商城_时装_禁止.bmp', outimg);
        A2Button3.A2NotEnabled := outimg;
        A2Button3.Left := 129;
        A2Button3.Top := 58;

        pgkBmp.getBmp('在线商城_辅助_弹起.bmp', outimg);
        A2Button4.A2Up := outimg;
        pgkBmp.getBmp('在线商城_辅助_按下.bmp', outimg);
        A2Button4.A2Down := outimg;
        pgkBmp.getBmp('在线商城_辅助_鼠标.bmp', outimg);
        A2Button4.A2Mouse := outimg;
        pgkBmp.getBmp('在线商城_辅助_禁止.bmp', outimg);
        A2Button4.A2NotEnabled := outimg;
        A2Button4.Left := 185;
        A2Button4.Top := 58;

        pgkBmp.getBmp('在线商城_其他_弹起.bmp', outimg);
        A2Button5.A2Up := outimg;
        pgkBmp.getBmp('在线商城_其他_按下.bmp', outimg);
        A2Button5.A2Down := outimg;
        pgkBmp.getBmp('在线商城_其他_鼠标.bmp', outimg);
        A2Button5.A2Mouse := outimg;
        pgkBmp.getBmp('在线商城_其他_禁止.bmp', outimg);
        A2Button5.A2NotEnabled := outimg;
        A2Button5.Left := 241;
        A2Button5.Top := 58;

        pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', outimg);
        A2Button_close.A2Up := outimg;
        pgkBmp.getBmp('通用X关闭按钮_按下.bmp', outimg);
        A2Button_close.A2Down := outimg;
        pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', outimg);
        A2Button_close.A2Mouse := outimg;
        pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', outimg);
        A2Button_close.A2NotEnabled := outimg;
        A2Button_close.Left := 390;
        A2Button_close.Top := 20;

        A2ILabel37.Left := A2ILabel37.Left + 0;
        A2ILabel37.Top := A2ILabel37.Top + 2;

        pgkBmp.getBmp('通用_取消_弹起.bmp', outimg);
        A2Button_BUYclose.A2Up := outimg;
        pgkBmp.getBmp('通用_取消_按下.bmp', outimg);
        A2Button_BUYclose.A2Down := outimg;
        pgkBmp.getBmp('通用_取消_鼠标.bmp', outimg);
        A2Button_BUYclose.A2Mouse := outimg;
        pgkBmp.getBmp('通用_取消_禁止.bmp', outimg);
        A2Button_BUYclose.A2NotEnabled := outimg;

        pgkBmp.getBmp('通用_确认_弹起.bmp', outimg);
        A2Button_BUY.A2Up := outimg;
        pgkBmp.getBmp('通用_确认_按下.bmp', outimg);
        A2Button_BUY.A2Down := outimg;
        pgkBmp.getBmp('通用_确认_鼠标.bmp', outimg);
        A2Button_BUY.A2Mouse := outimg;
        pgkBmp.getBmp('通用_确认_禁止.bmp', outimg);
        A2Button_BUY.A2NotEnabled := outimg;

        A2Button6.Visible := false;
    finally
        outimg.Free;
        tempUp.Free;
        tempDown.Free;
    end;

end;

procedure TfrmEmporia.SetOldVersion;
var
    outimg: TA2Image;
begin
    A2ListBox_itemText.SetScrollTopImage(getviewImage(7), getviewImage(6));
    A2ListBox_itemText.SetScrollTrackImage(getviewImage(4), getviewImage(5));
    A2ListBox_itemText.SetScrollBottomImage(getviewImage(9), getviewImage(8));
    // A2ListBox_itemText.FFontSelBACKColor := ColorSysToDxColor($9B7781);
    A2ListBox_itemText.FontColor := ColorSysToDxColor($00007CF9);
    A2ListBox_itemText.FontSelColor := ColorSysToDxColor($00007CF9);

    A2ListBox_result.SetScrollTopImage(getviewImage(7), getviewImage(6));
    A2ListBox_result.SetScrollTrackImage(getviewImage(4), getviewImage(5));
    A2ListBox_result.SetScrollBottomImage(getviewImage(9), getviewImage(8));
    A2ListBox_result.FFontSelBACKColor := ColorSysToDxColor($9B7781);
    A2ListBox_result.FontColor := ColorSysToDxColor($00007CF9);

    Fkuangimg := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('框.BMP', Fkuangimg);

    fOKimg := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('确认购买.bmp', fOKimg);
    A2ILabel37.A2Image := fOKimg;

    A2ILabel_buy_kuang.A2Image := Fkuangimg;
    fbackimg := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('在线商城.bmp', fbackimg);
    A2ILabel_BACK.A2Image := fbackimg;
    outimg := TA2Image.Create(32, 32, 0, 0);

    try

        pgkBmp.getBmp('①道具DOWN.bmp', outimg);
        A2Button1.A2Down := outimg;
        pgkBmp.getBmp('①道具UP.bmp', outimg);
        A2Button1.A2Up := outimg;

        pgkBmp.getBmp('②药品DOWN.bmp', outimg);
        A2Button2.A2Down := outimg;
        pgkBmp.getBmp('②药品UP.bmp', outimg);
        A2Button2.A2Up := outimg;

        pgkBmp.getBmp('③时装DOWN.bmp', outimg);
        A2Button3.A2Down := outimg;
        pgkBmp.getBmp('③时装UP.bmp', outimg);
        A2Button3.A2Up := outimg;

        pgkBmp.getBmp('④辅助DOWN.bmp', outimg);
        A2Button4.A2Down := outimg;
        pgkBmp.getBmp('④辅助UP.bmp', outimg);
        A2Button4.A2Up := outimg;

        pgkBmp.getBmp('⑤其他DOWN.bmp', outimg);
        A2Button5.A2Down := outimg;
        pgkBmp.getBmp('⑤其他UP.bmp', outimg);
        A2Button5.A2up := outimg;

        pgkBmp.getBmp('关闭DOWN.bmp', outimg);
        A2Button_close.A2Down := outimg;
        pgkBmp.getBmp('关闭UP.bmp', outimg);
        A2Button_close.A2Up := outimg;

        pgkBmp.getBmp('关闭DOWN.bmp', outimg);
        A2Button_BUYclose.A2Down := outimg;
        pgkBmp.getBmp('关闭UP.bmp', outimg);
        A2Button_BUYclose.A2Up := outimg;

        pgkBmp.getBmp('购买DOWN.bmp', outimg);
        A2Button_BUY.A2Down := outimg;
        pgkBmp.getBmp('购买UP.bmp', outimg);
        A2Button_BUY.A2Up := outimg;

        pgkBmp.getBmp('空按钮DOWN.bmp', outimg);
        A2Button6.A2Down := outimg;
        pgkBmp.getBmp('空按钮UP.bmp', outimg);
        A2Button6.A2Up := outimg;

    finally
        outimg.Free;
    end;
end;

procedure TfrmEmporia.FormCreate(Sender: TObject);
var
    i: integer;
begin
    FrmM.AddA2Form(Self, A2Form);
    fdata := tlist.Create;
    FindexName := TStringKeyClass.Create;

    if WinVerType = wvtNew then
    begin
        SetNewVersion;
    end
    else if WinVerType = wvtOld then
    begin
        SetOldVersion;
    end;

    itemArr[0] := A2ILabel1;
    FkuangitemArr[0] := A2ILabel2;

    itemArr[1] := A2ILabel3;
    FkuangitemArr[1] := A2ILabel4;

    itemArr[2] := A2ILabel5;
    FkuangitemArr[2] := A2ILabel6;

    itemArr[3] := A2ILabel7;
    FkuangitemArr[3] := A2ILabel8;

    itemArr[4] := A2ILabel9;
    FkuangitemArr[4] := A2ILabel10;

    itemArr[5] := A2ILabel11;
    FkuangitemArr[5] := A2ILabel12;

    itemArr[6] := A2ILabel13;
    FkuangitemArr[6] := A2ILabel14;

    itemArr[7] := A2ILabel15;
    FkuangitemArr[7] := A2ILabel16;

    itemArr[8] := A2ILabel17;
    FkuangitemArr[8] := A2ILabel18;

    itemArr[9] := A2ILabel19;
    FkuangitemArr[9] := A2ILabel20;

    itemArr[10] := A2ILabel21;
    FkuangitemArr[10] := A2ILabel22;

    itemArr[11] := A2ILabel23;
    FkuangitemArr[11] := A2ILabel24;

    itemArr[12] := A2ILabel25;
    FkuangitemArr[12] := A2ILabeL26;

    itemArr[13] := A2ILabel27;
    FkuangitemArr[13] := A2ILabeL28;

    itemArr[14] := A2ILabel29;
    FkuangitemArr[14] := A2ILabel30;

    itemArr[15] := A2ILabel31;
    FkuangitemArr[15] := A2ILabel32;

    itemArr[16] := A2ILabel33;
    FkuangitemArr[16] := A2ILabel34;

    itemArr[17] := A2ILabel35;
    FkuangitemArr[17] := A2ILabel36;

    for i := 0 to HIGH(itemArr) do
    begin
        itemArr[i].Tag := i;
        itemArr[i].Transparent:=true;
    end;

    for i := 0 to HIGH(FkuangitemArr) do
    begin
        FkuangitemArr[i].A2Image := Fkuangimg;
    end;
end;

procedure TfrmEmporia.FormDestroy(Sender: TObject);
begin
    fOKimg.Free;
    Fkuangimg.Free;
    fbackimg.Free;
    CLEAR;
    FindexName.Free;
    fdata.Free;
end;

procedure TfrmEmporia.A2ILabel1Click(Sender: TObject);
var
    pp: pTEmporiadata;
begin
    //

    pp := getid(tA2ILabel(sender).Tag);
    if pp = nil then exit;
    setitemshpe(A2ILabel_select_item, pp^);
    A2Label_select_name.Caption := pp.name;
    //A2Label_num.Caption := inttostr(pp.num);
    A2Label_price.Caption := inttostr(pp.price);
    A2Edit_select_num.Text := '1';
    Panel_buy_ok.Left := 19;
    Panel_buy_ok.Top := 82;
    Panel_buy_ok.Visible := true;
    Panel_itemList.Visible := not Panel_buy_ok.Visible;
end;

procedure TfrmEmporia.sendshowForm();
var
    temp: TWordComData;
begin

    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Emporia);
    WordComData_ADDbyte(temp, Emporia_showForm);

    FrmLogon.SocketAddData(temp.Size, @temp.data);

end;

procedure TfrmEmporia.sendBuy(aitemname: string; acount: integer);
var
    temp: TWordComData;
begin

    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Emporia);
    WordComData_ADDbyte(temp, Emporia_BUY);
    WordComData_ADDstring(temp, aitemname);
    WordComData_ADDdword(temp, acount);

    FrmLogon.SocketAddData(temp.Size, @temp.data);

end;

procedure TfrmEmporia.A2Button_BUYClick(Sender: TObject);
var
    pp: pTEmporiadata;
    acount: integer;
begin
    pp := get(A2Label_select_name.Caption);
    if pp = nil then exit;
    acount := _strtoint(A2Edit_select_num.Text);
    if (acount > 0) and (acount <= 1000) then
    begin
        sendBuy(pp.name, acount);
        itempaint;
    end;

end;

procedure TfrmEmporia.A2Button_closeClick(Sender: TObject);
var
    temp: TWordComData;
begin

    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Emporia);
    WordComData_ADDbyte(temp, Emporia_Windows_close);

    if FrmLogon.SocketAddData(temp.Size, @temp.data) then
        Visible := false;
end;

procedure TfrmEmporia.A2Button1Click(Sender: TObject);
begin
    select_menu_item := tA2Button(sender).Tag;
    itempaint;
end;

procedure TfrmEmporia.A2Button_BUYcloseClick(Sender: TObject);
begin
    Panel_buy_ok.Visible := false;
    Panel_itemList.Visible := not Panel_buy_ok.Visible;
end;

procedure TfrmEmporia.A2ILabel1MouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
var
    pp: pTEmporiadata;
    s, str, s2: string;
begin
    //
    A2ListBox_itemText.Clear;
    pp := getid(tA2ILabel(sender).Tag);
    if pp = nil then exit;

    A2ListBox_itemText.AddItem('' + pp.name);
    A2ListBox_itemText.AddItem('一组:' + inttostr(pp.num));
    A2ListBox_itemText.AddItem('价格:' + inttostr(pp.price));
    str := '' + pp.text;
    while str <> '' do
    begin
        S := CutLengthString(str, A2ListBox_itemText.Width);
        A2ListBox_itemText.AddItem(s);
    end;

    { s2 := '';
     s2 := s2 + '<$00007CF9>名字:' + pp.name + #13#10;
     s2 := s2 + '<$00007CF9>一组:' + inttostr(pp.num) + #13#10;
     s2 := s2 + '<$00007CF9>价格:' + inttostr(pp.price) + #13#10;
     s2 := s2 + '<$00007CF9>描述:' + pp.text;
     A2Form.FA2Hint.Ftype := hstTransparent;
     A2Form.FA2Hint.setText(s2);}
end;

procedure TfrmEmporia.A2Edit_select_numChange(Sender: TObject);
var
    str, str2: string;
    i: integer;
begin
    str2 := '';
    str := A2Edit_select_num.Text;
    for i := 1 to length(str) do
    begin
        case str[i] of
            '0'..'9': str2 := str2 + str[i];
        end;

    end;
    A2Edit_select_num.Text := str2;
    A2Edit_select_num.SelStart := length(A2Edit_select_num.Text);

end;

procedure TfrmEmporia.FormMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(Self, x, y);
    FrmM.SetA2Form(Self, A2Form);
end;

end.

