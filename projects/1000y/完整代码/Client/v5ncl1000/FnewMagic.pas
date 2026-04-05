unit FnewMagic;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    deftype, Dialogs, A2Form, StdCtrls, ExtCtrls, A2Img;

type

    TFrmNewMagic = class(TForm)
        A2Form: TA2Form;
        A2Button_close: TA2Button;
        PanelMagic: TA2Panel;
        MLabel8: TA2ILabel;
        MLabel7: TA2ILabel;
        MLabel6: TA2ILabel;
        MLabel5: TA2ILabel;
        MLabel4: TA2ILabel;
        MLabel3: TA2ILabel;
        MLabel29: TA2ILabel;
        MLabel2: TA2ILabel;
        MLabel28: TA2ILabel;
        MLabel27: TA2ILabel;
        MLabel26: TA2ILabel;
        MLabel25: TA2ILabel;
        MLabel24: TA2ILabel;
        MLabel23: TA2ILabel;
        MLabel22: TA2ILabel;
        MLabel21: TA2ILabel;
        MLabel20: TA2ILabel;
        MLabel19: TA2ILabel;
        MLabel1: TA2ILabel;
        MLabel18: TA2ILabel;
        MLabel17: TA2ILabel;
        MLabel16: TA2ILabel;
        MLabel15: TA2ILabel;
        MLabel14: TA2ILabel;
        MLabel13: TA2ILabel;
        MLabel12: TA2ILabel;
        MLabel11: TA2ILabel;
        MLabel10: TA2ILabel;
        MLabel9: TA2ILabel;
        MLabel0: TA2ILabel;
        PanelBasic: TA2Panel;
        BLabel8: TA2ILabel;
        BLabel7: TA2ILabel;
        BLabel6: TA2ILabel;
        BLabel5: TA2ILabel;
        BLabel4: TA2ILabel;
        BLabel3: TA2ILabel;
        BLabel29: TA2ILabel;
        BLabel2: TA2ILabel;
        BLabel28: TA2ILabel;
        BLabel27: TA2ILabel;
        BLabel26: TA2ILabel;
        BLabel25: TA2ILabel;
        BLabel24: TA2ILabel;
        BLabel23: TA2ILabel;
        BLabel22: TA2ILabel;
        BLabel21: TA2ILabel;
        BLabel20: TA2ILabel;
        BLabel19: TA2ILabel;
        BLabel1: TA2ILabel;
        BLabel18: TA2ILabel;
        BLabel17: TA2ILabel;
        BLabel16: TA2ILabel;
        BLabel15: TA2ILabel;
        BLabel14: TA2ILabel;
        BLabel13: TA2ILabel;
        BLabel12: TA2ILabel;
        BLabel11: TA2ILabel;
        BLabel10: TA2ILabel;
        BLabel9: TA2ILabel;
        BLabel0: TA2ILabel;
        PanelRiseMagic: TA2Panel;
        eILabel8: TA2ILabel;
        eILabel7: TA2ILabel;
        eILabel6: TA2ILabel;
        eILabel5: TA2ILabel;
        eILabel4: TA2ILabel;
        eILabel3: TA2ILabel;
        eILabel29: TA2ILabel;
        eILabel2: TA2ILabel;
        eILabel28: TA2ILabel;
        eILabel27: TA2ILabel;
        eILabel26: TA2ILabel;
        eILabel25: TA2ILabel;
        eILabel24: TA2ILabel;
        eILabel23: TA2ILabel;
        eILabel22: TA2ILabel;
        eILabel21: TA2ILabel;
        eILabel20: TA2ILabel;
        eILabel19: TA2ILabel;
        eILabel1: TA2ILabel;
        eILabel18: TA2ILabel;
        eILabel17: TA2ILabel;
        eILabel16: TA2ILabel;
        eILabel15: TA2ILabel;
        eILabel14: TA2ILabel;
        eILabel13: TA2ILabel;
        eILabel12: TA2ILabel;
        eILabel11: TA2ILabel;
        eILabel10: TA2ILabel;
        eILabel9: TA2ILabel;
        eILabel0: TA2ILabel;
        A2ILImg: TA2ILabel;
        A2ILabel1: TA2ILabel;
        A2ILabel3: TA2ILabel;
        A2ILabel2: TA2ILabel;
        A2ILabel_BUTTON: TA2ILabel;
        PanelMysteryMagic: TA2Panel;
        MILabel8: TA2ILabel;
        MILabel7: TA2ILabel;
        MILabel6: TA2ILabel;
        MILabel5: TA2ILabel;
        MILabel4: TA2ILabel;
        MILabel3: TA2ILabel;
        MILabel29: TA2ILabel;
        MILabel2: TA2ILabel;
        MILabel28: TA2ILabel;
        MILabel27: TA2ILabel;
        MILabel26: TA2ILabel;
        MILabel25: TA2ILabel;
        MILabel24: TA2ILabel;
        MILabel23: TA2ILabel;
        MILabel22: TA2ILabel;
        MILabel21: TA2ILabel;
        MILabel20: TA2ILabel;
        MILabel19: TA2ILabel;
        MILabel1: TA2ILabel;
        MILabel18: TA2ILabel;
        MILabel17: TA2ILabel;
        MILabel16: TA2ILabel;
        MILabel15: TA2ILabel;
        MILabel14: TA2ILabel;
        MILabel13: TA2ILabel;
        MILabel12: TA2ILabel;
        MILabel11: TA2ILabel;
        MILabel10: TA2ILabel;
        MILabel9: TA2ILabel;
        MILabel0: TA2ILabel;
        A2ILabel4: TA2ILabel;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure A2ILabel1Click(Sender: TObject);
        procedure A2ILabel2Click(Sender: TObject);
        procedure A2ILabel3Click(Sender: TObject);
        procedure BLabel0DblClick(Sender: TObject);
        procedure BLabel0MouseEnter(Sender: TObject);
        procedure BLabel0MouseLeave(Sender: TObject);
        procedure BLabel0MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure BLabel0StartDrag(Sender: TObject;
            var DragObject: TDragObject);
        procedure MLabel0DblClick(Sender: TObject);
        procedure MLabel0DragDrop(Sender, Source: TObject; X, Y: Integer);
        procedure MLabel0DragOver(Sender, Source: TObject; X, Y: Integer;
            State: TDragState; var Accept: Boolean);
        procedure MLabel0MouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure MLabel0MouseEnter(Sender: TObject);
        procedure MLabel0MouseLeave(Sender: TObject);
        procedure MLabel0MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure MLabel0StartDrag(Sender: TObject;
            var DragObject: TDragObject);
        procedure A2Button_closeClick(Sender: TObject);
        procedure A2ILImgMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure A2ILImgMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure eILabel9DblClick(Sender: TObject);
        procedure eILabel9DragDrop(Sender, Source: TObject; X, Y: Integer);
        procedure eILabel9DragOver(Sender, Source: TObject; X, Y: Integer;
            State: TDragState; var Accept: Boolean);
        procedure eILabel9MouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure eILabel9MouseEnter(Sender: TObject);
        procedure eILabel9MouseLeave(Sender: TObject);
        procedure eILabel9MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure eILabel9StartDrag(Sender: TObject;
            var DragObject: TDragObject);
        procedure MILabel9DblClick(Sender: TObject);
        procedure MILabel9DragDrop(Sender, Source: TObject; X, Y: Integer);
        procedure MILabel9DragOver(Sender, Source: TObject; X, Y: Integer;
            State: TDragState; var Accept: Boolean);
        procedure MILabel9MouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure MILabel9MouseEnter(Sender: TObject);
        procedure MILabel9MouseLeave(Sender: TObject);
        procedure MILabel9MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure MILabel9StartDrag(Sender: TObject;
            var DragObject: TDragObject);
        procedure A2ILabel4Click(Sender: TObject);
    private
        { Private declarations }
    public
        win_CloseDown_img: TA2Image;
        win_CloseUP_img: TA2Image;
        win_back_img: TA2Image;
        BUTTON_img1: TA2Image;
        BUTTON_img2: TA2Image;
        BUTTON_img3: TA2Image;
        BUTTON_img4: TA2Image;
        temping: TA2Image;
        MLabels: array[0..30 - 1] of TA2ILabel;
        BLabels: array[0..30 - 1] of TA2ILabel;
        RiseLabels: array[0..30 - 1] of TA2ILabel;
        MysteryLabels: array[0..30 - 1] of TA2ILabel;
        { Public declarations }
        procedure PaneClose(aname: string);
        procedure onHaveMagicUp(akey: integer; aitem: TMagicData);
        procedure onHaveRiseMagicUp(akey: integer; aitem: TMagicData);
        procedure onHaveMysteryMagicUp(akey: integer; aitem: TMagicData);

        procedure onDefaultMagicUp(akey: integer; aitem: TMagicData);
        procedure SetMagicLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape: word);
//        procedure onKEYF5_f8HaveMagic(akey: integer; aitem: TA2Image);
 //       procedure onKEYF5_f8HaveRiseMagic(akey: integer; aitem: TA2Image);
  //      procedure onKEYF5_f8HaveMysteryMagic(akey: integer; aitem: TA2Image);


    //    procedure onKEYF5_f8Default(akey: integer; aitem: TA2Image);


        //2009 6 22 增加
        procedure SetNewVersion();
        procedure SetOldVersion();

        function GetMagicTag(aname: string): integer;
    end;

var
    FrmNewMagic: TFrmNewMagic;

implementation
uses filepgkclass, FAttrib, AtzCls, CharCls, cltype, FMain, uAnsTick, FBottom,
    FLogOn;
{$R *.dfm}
var
    SelectedMagicLabel: TA2ILabel = nil;




function TFrmNewMagic.GetMagicTag(aname: string): integer;
var
    i: integer;
    temp: TA2ILabel;
    str: string;
    strlist: TStringList;
begin
    Result := -1;
    strlist := TStringList.Create;
    try
        for i := 0 to high(MLabels) do
        begin
            str := '';
            temp := MLabels[i];
            str := temp.Hint;
            if str = '' then exit;
            strlist.Clear;
            ExtractStrings([':'], [#10, #13], pchar(str), strlist);
            if strlist.Count < 0 then exit;
            if strlist.Count > 2 then exit;

            if strlist.Strings[0] = aname then
                Result := temp.Tag;
        end;
    finally
        strlist.Free;
    end;

end;

procedure TFrmNewMagic.SetMagicLabel(Lb: TA2ILabel; aname: string; acolor: byte; shape: word);
var
    gc, ga: integer;
begin
    Lb.Caption := '';
    Lb.Hint := aname;

    GetGreenColorAndAdd(acolor, gc, ga);

    Lb.GreenCol := gc;
    Lb.GreenAdd := ga;

    { if shape = 0 then
     begin
         Lb.A2Image := nil;
         Lb.BColor := 0;
         exit;
     end else}
   // Lb.A2Imageback := AtzClass.GetMagicImage(0);
    Lb.A2Image := AtzClass.GetMagicImage(shape);

    KeySelmagicIndex := -1;                                                     // 公傍父 困摹函版啊瓷
    if Lb.Hint <> '' then
    begin
        KeySelmagicIndex := Lb.Tag + 30;
        savekeyBool := TRUE;
    end;

end;

procedure TFrmNewMagic.onHaveMagicUp(akey: integer; aitem: TMagicData);
begin
    if aitem.rname <> '' then
    begin
        if FrmBottom.UseMagic1.Caption = (aitem.rName) then FrmBottom.PGSkillLevelSET(aitem.rcSkillLevel);
        SetMagicLabel(MLabels[akey], (aitem.rName) + ':' + Get10000To100(aitem.rcSkillLevel), 0, aitem.rShape);
        cKeyClass.UpdateType(kcdk_HaveMagic, akey);
    end
    else
    begin
        MLabels[akey].A2Image := nil;
        MLabels[akey].Hint := '';
        cKeyClass.delType(kcdk_HaveMagic, akey);
    end;

end;

procedure TFrmNewMagic.onDefaultMagicUp(akey: integer; aitem: TMagicData);
begin
    if aitem.rname <> '' then
    begin
        if FrmBottom.UseMagic1.Caption = (aitem.rName) then FrmBottom.PGSkillLevelSET(aitem.rcSkillLevel);
        SetMagicLabel(BLabels[akey], (aitem.rName) + ':' + Get10000To100(aitem.rcSkillLevel), 0, aitem.rShape);
        cKeyClass.UpdateType(kcdk_BasicMagic, akey);
    end
    else
    begin
        BLabels[akey].A2Image := nil;
        BLabels[akey].Hint := '';
        cKeyClass.delType(kcdk_BasicMagic, akey);
    end;
end;

procedure TFrmNewMagic.FormCreate(Sender: TObject);
var
    i: integer;
begin
    FrmM.AddA2Form(Self, A2Form);
    top := 200;
    Left := 540;
//    A2Form.FA2Hint.Ftype := hstTransparent;

    if WinVerType = wvtNew then
    begin
        SetNewVersion;
    end else if WinVerType = wvtOld then
    begin
        SetoldVersion;
    end;

    MLabels[0] := MLabel0;
    MLabels[1] := MLabel1;
    MLabels[2] := MLabel2;
    MLabels[3] := MLabel3;
    MLabels[4] := MLabel4;
    MLabels[5] := MLabel5;
    MLabels[6] := MLabel6;
    MLabels[7] := MLabel7;
    MLabels[8] := MLabel8;
    MLabels[9] := MLabel9;
    MLabels[10] := MLabel10;
    MLabels[11] := MLabel11;
    MLabels[12] := MLabel12;
    MLabels[13] := MLabel13;
    MLabels[14] := MLabel14;
    MLabels[15] := MLabel15;
    MLabels[16] := MLabel16;
    MLabels[17] := MLabel17;
    MLabels[18] := MLabel18;
    MLabels[19] := MLabel19;
    MLabels[20] := MLabel20;
    MLabels[21] := MLabel21;
    MLabels[22] := MLabel22;
    MLabels[23] := MLabel23;
    MLabels[24] := MLabel24;
    MLabels[25] := MLabel25;
    MLabels[26] := MLabel26;
    MLabels[27] := MLabel27;
    MLabels[28] := MLabel28;
    MLabels[29] := MLabel29;

    BLabels[0] := BLabel0;
    BLabels[1] := BLabel1;
    BLabels[2] := BLabel2;
    BLabels[3] := BLabel3;
    BLabels[4] := BLabel4;
    BLabels[5] := BLabel5;
    BLabels[6] := BLabel6;
    BLabels[7] := BLabel7;
    BLabels[8] := BLabel8;
    BLabels[9] := BLabel9;
    BLabels[10] := BLabel10;
    BLabels[11] := BLabel11;
    BLabels[12] := BLabel12;
    BLabels[13] := BLabel13;
    BLabels[14] := BLabel14;
    BLabels[15] := BLabel15;
    BLabels[16] := BLabel16;
    BLabels[17] := BLabel17;
    BLabels[18] := BLabel18;
    BLabels[19] := BLabel19;
    BLabels[20] := BLabel20;
    BLabels[21] := BLabel21;
    BLabels[22] := BLabel22;
    BLabels[23] := BLabel23;
    BLabels[24] := BLabel24;
    BLabels[25] := BLabel25;
    BLabels[26] := BLabel26;
    BLabels[27] := BLabel27;
    BLabels[28] := BLabel28;
    BLabels[29] := BLabel29;

    RiseLabels[0] := eiLabel0;
    RiseLabels[1] := eiLabel1;
    RiseLabels[2] := eiLabel2;
    RiseLabels[3] := eiLabel3;
    RiseLabels[4] := eiLabel4;
    RiseLabels[5] := eiLabel5;
    RiseLabels[6] := eiLabel6;
    RiseLabels[7] := eiLabel7;
    RiseLabels[8] := eiLabel8;
    RiseLabels[9] := eiLabel9;
    RiseLabels[10] := eiLabel10;
    RiseLabels[11] := eiLabel11;
    RiseLabels[12] := eiLabel12;
    RiseLabels[13] := eiLabel13;
    RiseLabels[14] := eiLabel14;
    RiseLabels[15] := eiLabel15;
    RiseLabels[16] := eiLabel16;
    RiseLabels[17] := eiLabel17;
    RiseLabels[18] := eiLabel18;
    RiseLabels[19] := eiLabel19;
    RiseLabels[20] := eiLabel20;
    RiseLabels[21] := eiLabel21;
    RiseLabels[22] := eiLabel22;
    RiseLabels[23] := eiLabel23;
    RiseLabels[24] := eiLabel24;
    RiseLabels[25] := eiLabel25;
    RiseLabels[26] := eiLabel26;
    RiseLabels[27] := eiLabel27;
    RiseLabels[28] := eiLabel28;
    RiseLabels[29] := eiLabel29;

    MysteryLabels[0] := MILabel0;
    MysteryLabels[1] := MILabel1;
    MysteryLabels[2] := MILabel2;
    MysteryLabels[3] := MILabel3;
    MysteryLabels[4] := MILabel4;
    MysteryLabels[5] := MILabel5;
    MysteryLabels[6] := MILabel6;
    MysteryLabels[7] := MILabel7;
    MysteryLabels[8] := MILabel8;
    MysteryLabels[9] := MILabel9;
    MysteryLabels[10] := MILabel10;
    MysteryLabels[11] := MILabel11;
    MysteryLabels[12] := MILabel12;
    MysteryLabels[13] := MILabel13;
    MysteryLabels[14] := MILabel14;
    MysteryLabels[15] := MILabel15;
    MysteryLabels[16] := MILabel16;
    MysteryLabels[17] := MILabel17;
    MysteryLabels[18] := MILabel18;
    MysteryLabels[19] := MILabel19;
    MysteryLabels[20] := MILabel20;
    MysteryLabels[21] := MILabel21;
    MysteryLabels[22] := MILabel22;
    MysteryLabels[23] := MILabel23;
    MysteryLabels[24] := MILabel24;
    MysteryLabels[25] := MILabel25;
    MysteryLabels[26] := MILabel26;
    MysteryLabels[27] := MILabel27;
    MysteryLabels[28] := MILabel28;
    MysteryLabels[29] := MILabel29;

    for i := 0 to high(MLabels) do
    begin
        MLabels[i].Tag := i;
        MLabels[i].Transparent := true;
    end;
    for i := 0 to high(bLabels) do
    begin
        bLabels[i].Tag := i;
        bLabels[i].Transparent := true;
    end;
    for i := 0 to high(RiseLabels) do
    begin
        RiseLabels[i].Tag := i;
        RiseLabels[i].Transparent := true;
    end;
    for i := 0 to high(MysteryLabels) do
    begin
        MysteryLabels[i].Tag := i;
        MysteryLabels[i].Transparent := true;
    end;
    A2ILabel2Click(nil);
end;

procedure TFrmNewMagic.SetNewVersion();
begin
    win_back_img := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('武功窗口.bmp', win_back_img);

    A2ILImg.A2Image := win_back_img;

    temping := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
    A2Button_close.A2Up := temping;
    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
    A2Button_close.A2Down := temping;
    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
    A2Button_close.A2Mouse := temping;
    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
    A2Button_close.A2NotEnabled := temping;
    A2Button_close.Left := 219;
    A2Button_close.Top := 17;

    A2ILabel_BUTTON.Left := 12;
    A2ILabel_BUTTON.Top := 54;

    A2ILabel1.Left := 13;
    A2ILabel1.Top := 56;

    A2ILabel2.Left := 64;
    A2ILabel2.Top := 56;

    A2ILabel3.Left := 115;
    A2ILabel3.Top := 56;

    A2ILabel4.Left := 166;
    A2ILabel4.Top := 56;
    //基本武功
    BLabel0.Left := 6;
    BLabel0.Top := 8;
    BLabel1.Left := 41;
    BLabel1.Top := 8;

    BLabel2.Left := 76;
    BLabel2.Top := 8;
    BLabel3.Left := 111;
    BLabel3.Top := 8;

    BLabel4.Left := 146;
    BLabel4.Top := 8;
    BLabel5.Left := 181;
    BLabel5.Top := 8;

    BLabel6.Left := 6;
    BLabel6.Top := 43;
    BLabel7.Left := 41;
    BLabel7.Top := 43;

    BLabel8.Left := 76;
    BLabel8.Top := 43;
    BLabel9.Left := 111;
    BLabel9.Top := 43;

    BLabel10.Left := 146;
    BLabel10.Top := 43;
    BLabel11.Left := 181;
    BLabel11.Top := 43;

    BLabel12.Left := 6;
    BLabel12.Top := 78;
    BLabel13.Left := 41;
    BLabel13.Top := 78;

    BLabel14.Left := 76;
    BLabel14.Top := 78;
    BLabel15.Left := 111;
    BLabel15.Top := 78;

    BLabel16.Left := 146;
    BLabel16.Top := 78;
    BLabel17.Left := 181;
    BLabel17.Top := 78;

    BLabel18.Left := 6;
    BLabel18.Top := 113;
    BLabel19.Left := 41;
    BLabel19.Top := 113;

    BLabel20.Left := 76;
    BLabel20.Top := 113;
    BLabel21.Left := 111;
    BLabel21.Top := 113;

    BLabel22.Left := 146;
    BLabel22.Top := 113;
    BLabel23.Left := 181;
    BLabel23.Top := 113;

    BLabel24.Left := 6;
    BLabel24.Top := 148;
    BLabel25.Left := 41;
    BLabel25.Top := 148;

    BLabel26.Left := 76;
    BLabel26.Top := 148;
    BLabel27.Left := 111;
    BLabel27.Top := 148;

    BLabel28.Left := 146;
    BLabel28.Top := 148;
    BLabel29.Left := 181;
    BLabel29.Top := 148;
    //武功
    MLabel0.Left := 6;
    MLabel0.Top := 8;
    MLabel1.Left := 41;
    MLabel1.Top := 8;

    MLabel2.Left := 76;
    MLabel2.Top := 8;
    MLabel3.Left := 111;
    MLabel3.Top := 8;

    MLabel4.Left := 146;
    MLabel4.Top := 8;
    MLabel5.Left := 181;
    MLabel5.Top := 8;

    MLabel6.Left := 6;
    MLabel6.Top := 43;
    MLabel7.Left := 41;
    MLabel7.Top := 43;

    MLabel8.Left := 76;
    MLabel8.Top := 43;
    MLabel9.Left := 111;
    MLabel9.Top := 43;

    MLabel10.Left := 146;
    MLabel10.Top := 43;
    MLabel11.Left := 181;
    MLabel11.Top := 43;

    MLabel12.Left := 6;
    MLabel12.Top := 78;
    MLabel13.Left := 41;
    MLabel13.Top := 78;

    MLabel14.Left := 76;
    MLabel14.Top := 78;
    MLabel15.Left := 111;
    MLabel15.Top := 78;

    MLabel16.Left := 146;
    MLabel16.Top := 78;
    MLabel17.Left := 181;
    MLabel17.Top := 78;

    MLabel18.Left := 6;
    MLabel18.Top := 113;
    MLabel19.Left := 41;
    MLabel19.Top := 113;

    MLabel20.Left := 76;
    MLabel20.Top := 113;
    MLabel21.Left := 111;
    MLabel21.Top := 113;

    MLabel22.Left := 146;
    MLabel22.Top := 113;
    MLabel23.Left := 181;
    MLabel23.Top := 113;

    MLabel24.Left := 6;
    MLabel24.Top := 148;
    MLabel25.Left := 41;
    MLabel25.Top := 148;

    MLabel26.Left := 76;
    MLabel26.Top := 148;
    MLabel27.Left := 111;
    MLabel27.Top := 148;

    MLabel28.Left := 146;
    MLabel28.Top := 148;
    MLabel29.Left := 181;
    MLabel29.Top := 148;
    //辅助
    eILabel0.Left := 6;
    eILabel0.Top := 8;
    eILabel1.Left := 41;
    eILabel1.Top := 8;

    eILabel2.Left := 76;
    eILabel2.Top := 8;
    eILabel3.Left := 111;
    eILabel3.Top := 8;

    eILabel4.Left := 146;
    eILabel4.Top := 8;
    eILabel5.Left := 181;
    eILabel5.Top := 8;

    eILabel6.Left := 6;
    eILabel6.Top := 43;
    eILabel7.Left := 41;
    eILabel7.Top := 43;

    eILabel8.Left := 76;
    eILabel8.Top := 43;
    eILabel9.Left := 111;
    eILabel9.Top := 43;

    eILabel10.Left := 146;
    eILabel10.Top := 43;
    eILabel11.Left := 181;
    eILabel11.Top := 43;

    eILabel12.Left := 6;
    eILabel12.Top := 78;
    eILabel13.Left := 41;
    eILabel13.Top := 78;

    eILabel14.Left := 76;
    eILabel14.Top := 78;
    eILabel15.Left := 111;
    eILabel15.Top := 78;

    eILabel16.Left := 146;
    eILabel16.Top := 78;
    eILabel17.Left := 181;
    eILabel17.Top := 78;

    eILabel18.Left := 6;
    eILabel18.Top := 113;
    eILabel19.Left := 41;
    eILabel19.Top := 113;

    eILabel20.Left := 76;
    eILabel20.Top := 113;
    eILabel21.Left := 111;
    eILabel21.Top := 113;

    eILabel22.Left := 146;
    eILabel22.Top := 113;
    eILabel23.Left := 181;
    eILabel23.Top := 113;

    eILabel24.Left := 6;
    eILabel24.Top := 148;
    eILabel25.Left := 41;
    eILabel25.Top := 148;

    eILabel26.Left := 76;
    eILabel26.Top := 148;
    eILabel27.Left := 111;
    eILabel27.Top := 148;

    eILabel28.Left := 146;
    eILabel28.Top := 148;
    eILabel29.Left := 181;
    eILabel29.Top := 148;

     //
    MILabel0.Left := 6;
    MILabel0.Top := 8;
    MILabel1.Left := 41;
    MILabel1.Top := 8;

    MILabel2.Left := 76;
    MILabel2.Top := 8;
    MILabel3.Left := 111;
    MILabel3.Top := 8;

    MILabel4.Left := 146;
    MILabel4.Top := 8;
    MILabel5.Left := 181;
    MILabel5.Top := 8;

    MILabel6.Left := 6;
    MILabel6.Top := 43;
    MILabel7.Left := 41;
    MILabel7.Top := 43;

    MILabel8.Left := 76;
    MILabel8.Top := 43;
    MILabel9.Left := 111;
    MILabel9.Top := 43;

    MILabel10.Left := 146;
    MILabel10.Top := 43;
    MILabel11.Left := 181;
    MILabel11.Top := 43;

    MILabel12.Left := 6;
    MILabel12.Top := 78;
    MILabel13.Left := 41;
    MILabel13.Top := 78;

    MILabel14.Left := 76;
    MILabel14.Top := 78;
    MILabel15.Left := 111;
    MILabel15.Top := 78;

    MILabel16.Left := 146;
    MILabel16.Top := 78;
    MILabel17.Left := 181;
    MILabel17.Top := 78;

    MILabel18.Left := 6;
    MILabel18.Top := 113;
    MILabel19.Left := 41;
    MILabel19.Top := 113;

    MILabel20.Left := 76;
    MILabel20.Top := 113;
    MILabel21.Left := 111;
    MILabel21.Top := 113;

    MILabel22.Left := 146;
    MILabel22.Top := 113;
    MILabel23.Left := 181;
    MILabel23.Top := 113;

    MILabel24.Left := 6;
    MILabel24.Top := 148;
    MILabel25.Left := 41;
    MILabel25.Top := 148;

    MILabel26.Left := 76;
    MILabel26.Top := 148;
    MILabel27.Left := 111;
    MILabel27.Top := 148;

    MILabel28.Left := 146;
    MILabel28.Top := 148;
    MILabel29.Left := 181;
    MILabel29.Top := 148;

    BUTTON_img1 := TA2Image.Create(32, 32, 0, 0);
    BUTTON_img2 := TA2Image.Create(32, 32, 0, 0);
    BUTTON_img3 := TA2Image.Create(32, 32, 0, 0);
    BUTTON_img4 := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('武功窗口_基本.bmp', BUTTON_img2);
    pgkBmp.getBmp('武功窗口_武功.bmp', BUTTON_img1);
    pgkBmp.getBmp('武功窗口_上层.bmp', BUTTON_img3);
    pgkBmp.getBmp('武功窗口_掌法.bmp', BUTTON_img4);
    A2ILabel_BUTTON.Width := BUTTON_img1.Width;
    A2ILabel_BUTTON.Height := BUTTON_img1.Height;
end;

procedure TFrmNewMagic.SetOldVersion();
begin
    win_back_img := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('武功窗.bmp', win_back_img);

    A2ILImg.A2Image := win_back_img;
    win_CloseUP_img := TA2Image.Create(32, 32, 0, 0);
    win_CloseDown_img := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('X 关闭UP.bmp', win_CloseUP_img);
    pgkBmp.getBmp('X 关闭DOWN.bmp', win_CloseDown_img);
    A2Button_close.A2Down := win_CloseDown_img;
    A2Button_close.A2Up := win_CloseUP_img;

    BUTTON_img1 := TA2Image.Create(32, 32, 0, 0);
    BUTTON_img2 := TA2Image.Create(32, 32, 0, 0);
    BUTTON_img3 := TA2Image.Create(32, 32, 0, 0);
    pgkBmp.getBmp('基本按钮UP.bmp', BUTTON_img2);
    pgkBmp.getBmp('武功按钮UP.bmp', BUTTON_img1);
    pgkBmp.getBmp('辅助按钮UP.bmp', BUTTON_img3);
end;

procedure TFrmNewMagic.FormDestroy(Sender: TObject);
begin
    win_CloseUP_img.free;

    win_CloseDown_img.free;

    BUTTON_img1.free;
    BUTTON_img2.free;
    BUTTON_img3.free;
    BUTTON_img4.Free;
    win_back_img.Free;
    temping.Free;
end;

procedure TFrmNewMagic.A2ILabel1Click(Sender: TObject);
begin

    A2ILabel_BUTTON.A2Image := BUTTON_img1;
    PaneClose('PanelMagic');
end;

procedure TFrmNewMagic.A2ILabel2Click(Sender: TObject);
begin
    A2ILabel_BUTTON.A2Image := BUTTON_img2;
    PaneClose('PanelBasic');
end;

procedure TFrmNewMagic.A2ILabel3Click(Sender: TObject);
begin
    A2ILabel_BUTTON.A2Image := BUTTON_img3;
    PaneClose('PanelRiseMagic');
end;

procedure TFrmNewMagic.PaneClose(aname: string);
begin
    aname := UpperCase(aname);

    PanelMagic.Visible := aname = UpperCase('PanelMagic');
    PanelBasic.Visible := aname = UpperCase('PanelBasic');
    PanelRiseMagic.Visible := aname = UpperCase('PanelRiseMagic');
    PanelMysteryMagic.Visible := aname = UpperCase('PanelMysteryMagic');
//    SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmNewMagic.BLabel0DblClick(Sender: TObject);
begin
    ClickTick := mmAnsTick;
    FillChar(GrobalClick, sizeof(GrobalClick), 0);

    GrobalClick.rmsg := CM_DBLCLICK;
    GrobalClick.rwindow := WINDOW_BASICFIGHT;
    GrobalClick.rclickedId := 0;
    GrobalClick.rShift := KeyShift;
    GrobalClick.rkey := TA2ILabel(Sender).Tag;
end;

procedure TFrmNewMagic.BLabel0MouseEnter(Sender: TObject);
begin
    keyselmagicindexadd := TA2ILabel(Sender).Tag;
    GameHint.Close;
end;

procedure TFrmNewMagic.BLabel0MouseLeave(Sender: TObject);
begin
    GameHint.Close;
    keyselmagicindexadd := -1;
end;

procedure TFrmNewMagic.BLabel0MouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
var
    Temp: TA2ILabel;
    aitem: TMagicData;
begin
    keyselmagicindexadd := TA2ILabel(Sender).Tag;
    SelectedMagicLabel := TA2ILabel(Sender);
    Temp := TA2ILabel(Sender);
    if (x < 0) or (y < 0) or (x > Temp.Width) or (y > Temp.Height) then
    begin
        if temp.A2Image <> nil then Temp.BeginDrag(TRUE);
    end;
    // MouseInfoStr := TA2ILabel(Sender).Hint;

    KeySelmagicIndex := -1;
    if temp.Hint <> '' then
    begin
        KeySelmagicIndex := TA2ILabel(Sender).Tag;
        savekeyBool := TRUE;
    end;
    aitem := (HaveMagicClass.DefaultMagic.get(TA2ILabel(Sender).Tag));
    if aitem.rname <> '' then
        GameHint.setText(integer(Sender), TMagicDataToStr(aitem));
end;

procedure TFrmNewMagic.BLabel0StartDrag(Sender: TObject;
    var DragObject: TDragObject);
begin
    if Sender is TA2ILabel then
    begin
        DragItem.Selected := TA2ILabel(Sender).Tag;
        DragItem.SourceId := WINDOW_BASICFIGHT;
        DragItem.Dragedid := 0;
        DragItem.sx := 0;
        DragItem.sy := 0;
        DragObject := DragItem;
    end;
end;

procedure TFrmNewMagic.MLabel0DblClick(Sender: TObject);
begin
    ClickTick := mmAnsTick;
    FillChar(GrobalClick, sizeof(GrobalClick), 0);

    GrobalClick.rmsg := CM_DBLCLICK;
    GrobalClick.rwindow := WINDOW_MAGICS;
    GrobalClick.rclickedId := 0;
    GrobalClick.rShift := KeyShift;
    GrobalClick.rkey := TA2ILabel(Sender).tag;
end;

procedure TFrmNewMagic.MLabel0DragDrop(Sender, Source: TObject; X,
    Y: Integer);
var
    cDragDrop: TCDragDrop;
begin
    if Source = nil then exit;

    with Source as TDragItem do
    begin
        case SourceID of
            WINDOW_MAGICS: ;
        else exit;
        end;
        cDragDrop.rmsg := CM_DRAGDROP;
        cDragDrop.rsourId := Dragedid;
        cDragDrop.rdestId := 0;
        cDragDrop.rsx := sx;
        cDragDrop.rsy := sy;
        cDragDrop.rdx := 0;
        cDragDrop.rdy := 0;
        cDragDrop.rsourwindow := SourceId;
        cDragDrop.rdestwindow := WINDOW_MAGICS;
        case SourceId of
            WINDOW_MAGICS: cDragDrop.rsourkey := Selected;
        end;
        cDragDrop.rdestkey := TA2ILabel(Sender).tag;
        FrmLogOn.SocketAddData(sizeof(cDragDrop), @cDragDrop);
    end;
end;

procedure TFrmNewMagic.MLabel0DragOver(Sender, Source: TObject; X,
    Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := FALSE;
    if Source <> nil then
    begin
        with Source as TDragItem do
        begin
            if SourceID = WINDOW_MAGICS then Accept := TRUE;
        end;
    end;
end;

procedure TFrmNewMagic.MLabel0MouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    per: integer;

    tt: TGET_cmd;
    cnt: integer;

begin
    if x < 31 then exit;
    if y > 35 then y := 35;
    per := (35 - y) div 3;

    ClickTick := mmAnsTick;
    FillChar(GrobalClick, sizeof(GrobalClick), 0);

    GrobalClick.rmsg := CM_CLICKPERCENT;
    GrobalClick.rwindow := WINDOW_MAGICS;
    GrobalClick.rclickedId := per;
    GrobalClick.rShift := KeyShift;
    GrobalClick.rkey := TA2ILabel(Sender).Tag;
end;

procedure TFrmNewMagic.MLabel0MouseEnter(Sender: TObject);
begin
    keyselmagicindexadd := TA2ILabel(Sender).Tag + 30;
    GameHint.Close;
end;

procedure TFrmNewMagic.MLabel0MouseLeave(Sender: TObject);
begin
    keyselmagicindexadd := -1;
    GameHint.Close;
end;

procedure TFrmNewMagic.MLabel0MouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
var
    Temp: TA2ILabel;
    aitem: TMagicData;
begin
    keyselmagicindexadd := TA2ILabel(Sender).Tag + 30;
    SelectedMagicLabel := TA2ILabel(Sender);
    Temp := TA2ILabel(Sender);
    if (x < 0) or (y < 0) or (x > Temp.Width) or (y > Temp.Height) then
    begin
        if temp.A2Image <> nil then Temp.BeginDrag(TRUE);
    end;
    MouseInfoStr := TA2ILabel(Sender).Hint;

    KeySelmagicIndex := -1;
    if temp.Hint <> '' then
    begin
        KeySelmagicIndex := TA2ILabel(Sender).Tag + 30;
        savekeyBool := TRUE;
    end;

    aitem := (HaveMagicClass.HaveMagic.get(TA2ILabel(Sender).Tag));
    if aitem.rname <> '' then
        GameHint.setText(integer(Sender), TMagicDataToStr(aitem));
end;

procedure TFrmNewMagic.MLabel0StartDrag(Sender: TObject;
    var DragObject: TDragObject);
begin
    if Sender is TA2ILabel then
    begin
        DragItem.Selected := TA2ILabel(Sender).Tag;
        DragItem.SourceId := WINDOW_MAGICS;
        DragItem.Dragedid := 0;
        DragItem.sx := 0;
        DragItem.sy := 0;
        DragObject := DragItem;
    end;
end;

procedure TFrmNewMagic.A2Button_closeClick(Sender: TObject);
begin
    Visible := false;
//    SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmNewMagic.A2ILImgMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

procedure TFrmNewMagic.A2ILImgMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    keyselmagicindexadd := -1;
    GameHint.Close;
end;


procedure TFrmNewMagic.eILabel9DblClick(Sender: TObject);
begin
    ClickTick := mmAnsTick;
    FillChar(GrobalClick, sizeof(GrobalClick), 0);

    GrobalClick.rmsg := CM_DBLCLICK;
    GrobalClick.rwindow := WINDOW_MAGICS_Rise;
    GrobalClick.rclickedId := 0;
    GrobalClick.rShift := KeyShift;
    GrobalClick.rkey := TA2ILabel(Sender).tag;
end;

procedure TFrmNewMagic.eILabel9DragDrop(Sender, Source: TObject; X,
    Y: Integer);
var
    cDragDrop: TCDragDrop;
begin
    if Source = nil then exit;

    with Source as TDragItem do
    begin
        case SourceID of
            WINDOW_MAGICS_Rise: ;
        else exit;
        end;
        cDragDrop.rmsg := CM_DRAGDROP;
        cDragDrop.rsourId := Dragedid;
        cDragDrop.rdestId := 0;
        cDragDrop.rsx := sx;
        cDragDrop.rsy := sy;
        cDragDrop.rdx := 0;
        cDragDrop.rdy := 0;
        cDragDrop.rsourwindow := SourceId;
        cDragDrop.rdestwindow := WINDOW_MAGICS_Rise;
        case SourceId of
            WINDOW_MAGICS_Rise: cDragDrop.rsourkey := Selected;
        end;
        cDragDrop.rdestkey := TA2ILabel(Sender).tag;
        FrmLogOn.SocketAddData(sizeof(cDragDrop), @cDragDrop);
    end;
end;

procedure TFrmNewMagic.eILabel9DragOver(Sender, Source: TObject; X,
    Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := FALSE;
    if Source <> nil then
    begin
        with Source as TDragItem do
        begin
            if SourceID = WINDOW_MAGICS_Rise then Accept := TRUE;
        end;
    end;
end;

procedure TFrmNewMagic.eILabel9MouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    per: integer;

    tt: TGET_cmd;
    cnt: integer;

begin
    if x < 31 then exit;
    if y > 35 then y := 35;
    per := (35 - y) div 3;

    ClickTick := mmAnsTick;
    FillChar(GrobalClick, sizeof(GrobalClick), 0);

    GrobalClick.rmsg := CM_CLICKPERCENT;
    GrobalClick.rwindow := WINDOW_MAGICS_Rise;
    GrobalClick.rclickedId := per;
    GrobalClick.rShift := KeyShift;
    GrobalClick.rkey := TA2ILabel(Sender).Tag;
end;


procedure TFrmNewMagic.eILabel9MouseEnter(Sender: TObject);
begin
    keyselmagicindexadd := TA2ILabel(Sender).Tag + 90;
    GameHint.Close;
end;

procedure TFrmNewMagic.eILabel9MouseLeave(Sender: TObject);
begin
    keyselmagicindexadd := -1;
    GameHint.Close;
end;

procedure TFrmNewMagic.eILabel9MouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
var
    Temp: TA2ILabel;
    aitem: TMagicData;
begin
    keyselmagicindexadd := TA2ILabel(Sender).Tag + 90;
    SelectedMagicLabel := TA2ILabel(Sender);
    Temp := TA2ILabel(Sender);
    if (x < 0) or (y < 0) or (x > Temp.Width) or (y > Temp.Height) then
    begin
        if temp.A2Image <> nil then Temp.BeginDrag(TRUE);
    end;
    MouseInfoStr := TA2ILabel(Sender).Hint;

    KeySelmagicIndex := -1;
    if temp.Hint <> '' then
    begin
        KeySelmagicIndex := TA2ILabel(Sender).Tag + 90;
        savekeyBool := TRUE;
    end;

    aitem := (HaveMagicClass.HaveRiseMagic.get(TA2ILabel(Sender).Tag));
    if aitem.rname <> '' then
        GameHint.setText(integer(Sender), TMagicDataToStr(aitem));
end;

procedure TFrmNewMagic.eILabel9StartDrag(Sender: TObject;
    var DragObject: TDragObject);
begin
    if Sender is TA2ILabel then
    begin
        DragItem.Selected := TA2ILabel(Sender).Tag;
        DragItem.SourceId := WINDOW_MAGICS_Rise;
        DragItem.Dragedid := 0;
        DragItem.sx := 0;
        DragItem.sy := 0;
        DragObject := DragItem;
    end;
end;

procedure TFrmNewMagic.MILabel9DblClick(Sender: TObject);
begin
    ClickTick := mmAnsTick;
    FillChar(GrobalClick, sizeof(GrobalClick), 0);

    GrobalClick.rmsg := CM_DBLCLICK;
    GrobalClick.rwindow := WINDOW_MAGICS_Mystery;
    GrobalClick.rclickedId := 0;
    GrobalClick.rShift := KeyShift;
    GrobalClick.rkey := TA2ILabel(Sender).tag;
end;

procedure TFrmNewMagic.MILabel9DragDrop(Sender, Source: TObject; X,
    Y: Integer);
var
    cDragDrop: TCDragDrop;
begin
    if Source = nil then exit;

    with Source as TDragItem do
    begin
        case SourceID of
            WINDOW_MAGICS_Mystery: ;
        else exit;
        end;
        cDragDrop.rmsg := CM_DRAGDROP;
        cDragDrop.rsourId := Dragedid;
        cDragDrop.rdestId := 0;
        cDragDrop.rsx := sx;
        cDragDrop.rsy := sy;
        cDragDrop.rdx := 0;
        cDragDrop.rdy := 0;
        cDragDrop.rsourwindow := SourceId;
        cDragDrop.rdestwindow := WINDOW_MAGICS_Mystery;
        case SourceId of
            WINDOW_MAGICS_Mystery: cDragDrop.rsourkey := Selected;
        end;
        cDragDrop.rdestkey := TA2ILabel(Sender).tag;
        FrmLogOn.SocketAddData(sizeof(cDragDrop), @cDragDrop);
    end;
end;

procedure TFrmNewMagic.MILabel9DragOver(Sender, Source: TObject; X,
    Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := FALSE;
    if Source <> nil then
    begin
        with Source as TDragItem do
        begin
            if SourceID = WINDOW_MAGICS_Mystery then Accept := TRUE;
        end;
    end;
end;

procedure TFrmNewMagic.MILabel9MouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    per: integer;

    tt: TGET_cmd;
    cnt: integer;

begin
    if x < 31 then exit;
    if y > 35 then y := 35;
    per := (35 - y) div 3;

    ClickTick := mmAnsTick;
    FillChar(GrobalClick, sizeof(GrobalClick), 0);

    GrobalClick.rmsg := CM_CLICKPERCENT;
    GrobalClick.rwindow := WINDOW_MAGICS_Mystery;
    GrobalClick.rclickedId := per;
    GrobalClick.rShift := KeyShift;
    GrobalClick.rkey := TA2ILabel(Sender).Tag;
end;

procedure TFrmNewMagic.MILabel9MouseEnter(Sender: TObject);
begin
    keyselmagicindexadd := TA2ILabel(Sender).Tag + 120;
    GameHint.Close;
end;

procedure TFrmNewMagic.MILabel9MouseLeave(Sender: TObject);
begin
    keyselmagicindexadd := -1;
    GameHint.Close;
end;

procedure TFrmNewMagic.MILabel9MouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
var
    Temp: TA2ILabel;
    aitem: TMagicData;
begin
    keyselmagicindexadd := TA2ILabel(Sender).Tag + 120;
    SelectedMagicLabel := TA2ILabel(Sender);
    Temp := TA2ILabel(Sender);
    if (x < 0) or (y < 0) or (x > Temp.Width) or (y > Temp.Height) then
    begin
        if temp.A2Image <> nil then Temp.BeginDrag(TRUE);
    end;
    MouseInfoStr := TA2ILabel(Sender).Hint;

    KeySelmagicIndex := -1;
    if temp.Hint <> '' then
    begin
        KeySelmagicIndex := TA2ILabel(Sender).Tag + 120;
        savekeyBool := TRUE;
    end;

    aitem := (HaveMagicClass.HaveMysteryMagic.get(TA2ILabel(Sender).Tag));
    if aitem.rname <> '' then
        GameHint.setText(integer(Sender), TMagicDataToStr(aitem));
end;

procedure TFrmNewMagic.MILabel9StartDrag(Sender: TObject;
    var DragObject: TDragObject);
begin
    if Sender is TA2ILabel then
    begin
        DragItem.Selected := TA2ILabel(Sender).Tag;
        DragItem.SourceId := WINDOW_MAGICS_Mystery;
        DragItem.Dragedid := 0;
        DragItem.sx := 0;
        DragItem.sy := 0;
        DragObject := DragItem;
    end;
end;

{procedure TFrmNewMagic.onKEYF5_f8HaveMysteryMagic(akey: integer;
    aitem: TA2Image);
begin
    MysteryLabels[akey].A2ImageLUP := aitem;
end;

procedure TFrmNewMagic.onKEYF5_f8HaveRiseMagic(akey: integer;
    aitem: TA2Image);
begin
    RiseLabels[akey].A2ImageLUP := aitem;
end;

procedure TFrmNewMagic.onKEYF5_f8HaveMagic(akey: integer; aitem: TA2Image);
begin
    MLabels[akey].A2ImageLUP := aitem;
end;

procedure TFrmNewMagic.onKEYF5_f8Default(akey: integer; aitem: TA2Image);
begin
    bLabels[akey].A2ImageLUP := aitem;
end;
 }

procedure TFrmNewMagic.onHaveMysteryMagicUp(akey: integer;
    aitem: TMagicData);
begin
    if aitem.rname <> '' then
    begin
        if FrmBottom.UseMagic1.Caption = (aitem.rName) then FrmBottom.PGSkillLevelSET(aitem.rcSkillLevel);
        SetMagicLabel(MysteryLabels[akey], (aitem.rName) + ':' + Get10000To100(aitem.rcSkillLevel), 0, aitem.rShape);
        cKeyClass.UpdateType(kcdk_HaveMysteryMagic, akey);
    end
    else
    begin
        MysteryLabels[akey].A2Image := nil;
        MysteryLabels[akey].Hint := '';
        cKeyClass.delType(kcdk_HaveMysteryMagic, akey);
    end;

end;

procedure TFrmNewMagic.onHaveRiseMagicUp(akey: integer; aitem: TMagicData);
begin
    if aitem.rname <> '' then
    begin
        if FrmBottom.UseMagic1.Caption = (aitem.rName) then FrmBottom.PGSkillLevelSET(aitem.rcSkillLevel);
        SetMagicLabel(RiseLabels[akey], (aitem.rName) + ':' + Get10000To100(aitem.rcSkillLevel), 0, aitem.rShape);
        cKeyClass.UpdateType(kcdk_HaveRiseMagic, akey);
    end
    else
    begin
        RiseLabels[akey].A2Image := nil;
        RiseLabels[akey].Hint := '';
        cKeyClass.delType(kcdk_HaveRiseMagic, akey);
    end;

end;

procedure TFrmNewMagic.A2ILabel4Click(Sender: TObject);
begin
    A2ILabel_BUTTON.A2Image := BUTTON_img4;
    PaneClose('PanelMysteryMagic');
end;

end.

