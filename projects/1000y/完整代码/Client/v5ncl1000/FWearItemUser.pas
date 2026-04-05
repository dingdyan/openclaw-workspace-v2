unit FWearItemUser;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    A2Img, Dialogs, StdCtrls, A2Form, ExtCtrls, Deftype;

type
    TfrmWearItemUser = class(TForm)
        A2Form: TA2Form;
        LbChar: TA2ILabel;
        A2LabeluserName: TA2Label;
        A2ILabel9: TA2ILabel;
        A2ILabel8: TA2ILabel;
        A2ILabel7: TA2ILabel;
        A2ILabel6: TA2ILabel;
        A2ILabel5: TA2ILabel;
        A2ILabel4: TA2ILabel;
        A2ILabel3: TA2ILabel;
        A2ILabel2: TA2ILabel;
        A2ILabel13: TA2ILabel;
        A2ILabel12: TA2ILabel;
        A2ILabel11: TA2ILabel;
        A2ILabel10: TA2ILabel;
        A2ILabel1: TA2ILabel;
        A2ILabel0: TA2ILabel;
        A2Button6: TA2Button;
        LbCharFD: TA2ILabel;
        A2ILabelFD9: TA2ILabel;
        A2ILabelFD8: TA2ILabel;
        A2ILabelFD7: TA2ILabel;
        A2ILabelFD6: TA2ILabel;
        A2ILabelFD5: TA2ILabel;
        A2ILabelFD4: TA2ILabel;
        A2ILabelFD3: TA2ILabel;
        A2ILabelFD2: TA2ILabel;
        A2ILabelFD13: TA2ILabel;
        A2ILabelFD12: TA2ILabel;
        A2ILabelFD11: TA2ILabel;
        A2ILabelFD10: TA2ILabel;
        A2ILabelFD1: TA2ILabel;
        A2ILabelFD0: TA2ILabel;
        A2LabelGuildName: TA2Label;
        A2ILabel14: TA2ILabel;
        procedure FormCreate(Sender: TObject);
        procedure A2Button6Click(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure A2ILabel0MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure A2ILabelFD0MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure LbCharMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure LbCharFDMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
    private
        { Private declarations }
    public
        { Public declarations }
        SendTick: integer;
        FUSERID: INTEGER;

        Feature: TFeature;
        FeatureFD: TFeature;
        CharCenterImage: TA2Image;
        //  wearimg:TA2Image;
        //  wearimgFD:TA2Image;
        CharCenterImageFD: TA2Image;
        FItemArr: array[0..13] of TA2ILabel;
        FItemFDArr: array[0..13] of TA2ILabel;

        procedure SetFeature();
        procedure DrawWearItem;

        procedure ItemFDPaint(akey: integer; aitem: titemdata);
        procedure ItemPaint(akey: integer; aitem: titemdata);

        procedure SetNewVersion;
        procedure SetOldVersion;
    end;

var
    frmWearItemUser: TfrmWearItemUser;

implementation

uses FMain, FAttrib, FWearItem, CharCls, uAnsTick, filepgkclass;

{$R *.dfm}

procedure TfrmWearItemUser.FormDestroy(Sender: TObject);
begin

    CharCenterImage.free;

    CharCenterImageFD.free;
end;

procedure TfrmWearItemUser.SetNewVersion;
var
    temping: TA2Image;
begin

    pgkBmp.getBmp('查看装备窗口.bmp', A2Form.FImageSurface);
    A2Form.boImagesurface := true;
    Width := A2Form.FImageSurface.Width;
    Height := A2Form.FImageSurface.Height;

    CharCenterImage := TA2Image.Create(56, 72, 0, 0);
    LbChar.A2Image := CharCenterImage;
    LbChar.Left := 60;
    LbChar.Top := 64;
    LbChar.Width := 85;
    LbChar.Height := 113;
    CharCenterImageFD := TA2Image.Create(56, 72, 0, 0);
    LbCharFD.A2Image := CharCenterImageFD;
    LbCharFD.Left := 266;
    LbCharFD.Top := 64;
    LbCharFD.Width := 85;
    LbCharFD.Height := 113;
//    A2Form.FA2Hint.Ftype := hstTransparent;

    A2ILabel8.Left := 13;
    A2ILabel8.Top := 36 + 2;
    A2ILabel7.Left := 13;
    A2ILabel7.Top := 80 + 2;
    A2ILabel1.Left := 13;
    A2ILabel1.Top := 124 + 2;
    A2ILabel3.Left := 13;
    A2ILabel3.Top := 168 + 2;

    A2ILabel9.Left := 157 + 2;
    A2ILabel9.Top := 36 + 2;
    A2ILabel2.Left := 157 + 2;
    A2ILabel2.Top := 80 + 2;
    A2ILabel6.Left := 157 + 2;
    A2ILabel6.Top := 124 + 2;
    A2ILabel4.Left := 157 + 2;
    A2ILabel4.Top := 168 + 2;

    A2ILabelFD8.Left := 217 + 2;
    A2ILabelfd8.Top := 36 + 2;
    A2ILabelfd7.Left := 217 + 2;
    A2ILabelfd7.Top := 80 + 2;
    A2ILabelfd1.Left := 217 + 2;
    A2ILabelfd1.Top := 124 + 2;
    A2ILabelfd3.Left := 217 + 2;
    A2ILabelfd3.Top := 168 + 2;

    A2ILabelfd9.Left := 363 + 2;
    A2ILabelfd9.Top := 36 + 2;
    A2ILabelfd2.Left := 363 + 2;
    A2ILabelfd2.Top := 80 + 2;
    A2ILabelfd6.Left := 363 + 2;
    A2ILabelfd6.Top := 124 + 2;
    A2ILabelfd4.Left := 363 + 2;
    A2ILabelfd4.Top := 168 + 2;

    temping := TA2Image.Create(32, 32, 0, 0);
    try
        pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
        A2Button6.A2Up := temping;
        pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
        A2Button6.A2Down := temping;
        pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
        A2Button6.A2Mouse := temping;
        pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
        A2Button6.A2NotEnabled := temping;
        A2Button6.Left := 378;
        A2Button6.Top := 16;
        A2Button6.Width := 17;
        A2Button6.Height := 17;

        pgkBmp.getBmp('角色物品_装备底框.bmp', temping);
        A2ILabel14.A2Imageback := temping;
    finally
        temping.Free;
    end;

    A2LabeluserName.Left := 290;
    A2LabeluserName.Top := 214;
    A2LabeluserName.Width := 95;
    A2LabeluserName.Height := 15;
    A2LabelGuildName.Left := 290;
    A2LabelGuildName.Top := 239;
    A2LabelGuildName.Width := 95;
    A2LabelGuildName.Height := 15;
end;

procedure TfrmWearItemUser.SetOldVersion;
begin
    //
    pgkBmp.getBmp('Userwear.bmp', A2Form.FImageSurface);
    A2form.boImagesurface := true;
    //Width := 325;
    //Height := 500;
    // LbChar.A2Image := FrmAttrib.CharCenterImage;
 //  wearimg := TA2Image.Create(ClientWidth, ClientHeight, 0, 0);
 //  wearimgFD := TA2Image.Create(ClientWidth, ClientHeight, 0, 0);
 //  wearimg.LoadFromFile('wear.bmp');
 //  wearimgFD.LoadFromFile('wearFD.bmp');

//   A2ILImg.A2Image := wearimg;
  //A2ILImgFD.A2Image := wearimgFD;
   //Parent := FrmM;
    CharCenterImage := TA2Image.Create(56, 72, 0, 0);
    LbChar.A2Image := CharCenterImage;
    CharCenterImageFD := TA2Image.Create(56, 72, 0, 0);
    LbCharFD.A2Image := CharCenterImageFD;
//    A2Form.FA2Hint.Ftype := hstTransparent;
end;

procedure TfrmWearItemUser.FormCreate(Sender: TObject);
var
    i: integer;
begin
    FrmM.AddA2Form(Self, A2Form);

    if WinVerType = wvtnew then
    begin
        SetNewVersion;
    end
    else
    begin
        SetOldVersion;
    end;

    Top := 0;
    Left := 0;
    FItemArr[0] := A2ILabel0;
    FItemArr[1] := A2ILabel1;
    FItemArr[2] := A2ILabel2;
    FItemArr[3] := A2ILabel3;
    FItemArr[4] := A2ILabel4;
    FItemArr[5] := A2ILabel5;
    FItemArr[6] := A2ILabel6;
    FItemArr[7] := A2ILabel7;
    FItemArr[8] := A2ILabel8;
    FItemArr[9] := A2ILabel9;
    FItemArr[10] := A2ILabel10;
    FItemArr[11] := A2ILabel11;
    FItemArr[12] := A2ILabel12;
    FItemArr[13] := A2ILabel13;

    FItemFDArr[0] := A2ILabelFD0;
    FItemFDArr[1] := A2ILabelFD1;
    FItemFDArr[2] := A2ILabelFD2;
    FItemFDArr[3] := A2ILabelFD3;
    FItemFDArr[4] := A2ILabelFD4;
    FItemFDArr[5] := A2ILabelFD5;
    FItemFDArr[6] := A2ILabelFD6;
    FItemFDArr[7] := A2ILabelFD7;
    FItemFDArr[8] := A2ILabelFD8;
    FItemFDArr[9] := A2ILabelFD9;
    FItemFDArr[10] := A2ILabelFD10;
    FItemFDArr[11] := A2ILabelFD11;
    FItemFDArr[12] := A2ILabelFD12;
    FItemFDArr[13] := A2ILabelFD13;

    for i := 0 to high(FItemArr) do
    begin
        FItemArr[i].Tag := i;
    end;
    for i := 0 to high(FItemFDArr) do
    begin
        FItemFDArr[i].Tag := i;
    end;

end;

procedure TfrmWearItemUser.SetFeature();
var
    i: integer;
begin
    for i := ARR_GLOVES to ARR_WEAPON do
    begin
        Feature.rArr[i * 2] := WearUseritemClass.Wear.get(i).rWearShape;
        Feature.rArr[i * 2 + 1] := WearUseritemClass.Wear.get(i).rColor;
    end;

    for i := ARR_GLOVES to ARR_WEAPON do
    begin
        FeatureFD.rArr[i * 2] := WearUseritemClass.WearFD.get(i).rWearShape;
        FeatureFD.rArr[i * 2 + 1] := WearUseritemClass.WearFD.get(i).rColor;
    end;
    FeatureFD.rArr[ARR_WEAPON * 2] := WearUseritemClass.Wear.get(ARR_WEAPON).rWearShape;
    FeatureFD.rArr[ARR_WEAPON * 2 + 1] := WearUseritemClass.Wear.get(ARR_WEAPON).rColor;
end;

procedure TfrmWearItemUser.DrawWearItem;
var
    i, gc, ga: integer;

    Cl: TCharClass;
    ImageLib: TA2ImageLib;
begin
    Cl := CharList.CharGet(FUSERID);
    A2LabeluserName.Caption := '';
    A2LabelGuildName.Caption := '';
    if Cl = nil then exit;
    A2LabeluserName.Caption := Cl.rName;
    A2LabelGuildName.Caption := cl.GuildName;
    Feature.rboman := CL.Feature.rboMan;
    FeatureFD.rboman := CL.Feature.rboMan;
    CharCenterImage.Clear(0);

    for i := 0 to 10 - 1 do
    begin
        ImageLib := FrmWearItem.GetArrImageLib(i, mmAnsTick, Feature);
        if ImageLib <> nil then
        begin
            GetGreenColorAndAdd(Feature.rArr[i * 2 + 1], gc, ga);
            if Feature.rArr[i * 2 + 1] = 0 then
                CharCenterImage.DrawImage(ImageLib.Images[57], ImageLib.Images[57].px + 28, ImageLib.Images[57].py + 36, TRUE)
            else
                CharCenterImage.DrawImageGreenConvert(ImageLib.Images[57], ImageLib.Images[57].px + 28, ImageLib.Images[57].py + 36, gc, ga);
        end;
    end;
    LbChar.A2Image := CharCenterImage;
    CharCenterImageFD.Clear(0);

    for i := 0 to 10 - 1 do
    begin
        ImageLib := FrmWearItem.GetArrImageLib(i, mmAnsTick, FeatureFD);
        if ImageLib <> nil then
        begin
            GetGreenColorAndAdd(FeatureFD.rArr[i * 2 + 1], gc, ga);
            if FeatureFD.rArr[i * 2 + 1] = 0 then
                CharCenterImageFD.DrawImage(ImageLib.Images[57], ImageLib.Images[57].px + 28, ImageLib.Images[57].py + 36, TRUE)
            else
                CharCenterImageFD.DrawImageGreenConvert(ImageLib.Images[57], ImageLib.Images[57].px + 28, ImageLib.Images[57].py + 36, gc, ga);
        end;
    end;
    LbCharFD.A2Image := CharCenterImageFD;
end;

procedure TfrmWearItemUser.ItemFDPaint(akey: integer; aitem: titemdata);
var
    idx: integer;
    str: string;
begin
    if Visible = false then Visible := true;

    FrmM.SetA2Form(Self, A2Form);
    FrmM.move_win_form_Align(self, mwfCenter);

    begin
        str := (aitem.rViewName);
        if str = '' then
        begin
            FItemFDArr[akey].Visible := false;
        end else
        begin
            if aitem.rlockState = 1 then idx := 24
            else if aitem.rlockState = 2 then idx := 25
            else idx := 0;
            FrmAttrib.SetItemLabel(FItemFDArr[akey]
                , ''
                , aitem.rColor
                , aitem.rShape
                , idx, 0

                );
            FItemFDArr[akey].A2Imageback := A2ILabel14.A2Imageback;
            FItemFDArr[akey].Visible := true;
        end;
    end;
    SetFeature;
    DrawWearItem;
end;

procedure TfrmWearItemUser.ItemPaint(akey: integer; aitem: titemdata);
var
    idx: integer;
    str: string;
begin
    if Visible = false then Visible := true;

    FrmM.SetA2Form(Self, A2Form);
    FrmM.move_win_form_Align(self, mwfCenter);

    begin
        str := (aitem.rViewName);
        if str = '' then
        begin
            FItemArr[akey].Visible := false;
        end else
        begin
            if aitem.rlockState = 1 then idx := 24
            else if aitem.rlockState = 2 then idx := 25
            else idx := 0;
            FrmAttrib.SetItemLabel(FItemArr[akey]
                , ''
                , aitem.rColor
                , aitem.rShape
                , idx, 0

                );
            FItemArr[akey].A2Imageback := A2ILabel14.A2Imageback;
            FItemArr[akey].Visible := true;
        end;
    end;

    SetFeature;
    DrawWearItem;
end;

procedure TfrmWearItemUser.A2Button6Click(Sender: TObject);
begin
    Visible := false;
end;

procedure TfrmWearItemUser.A2ILabel0MouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.setText(integer(Sender), TItemDataToStr(WearUseritemClass.Wear.get(TA2ILabel(sender).tag)));
end;

procedure TfrmWearItemUser.A2ILabelFD0MouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.setText(integer(Sender), TItemDataToStr(WearUseritemClass.Wearfd.get(TA2ILabel(sender).tag)));
end;

procedure TfrmWearItemUser.FormMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmWearItemUser.LbCharMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.Close;
end;

procedure TfrmWearItemUser.LbCharFDMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.Close;
end;

procedure TfrmWearItemUser.FormMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    GameHint.Close;
end;

end.

