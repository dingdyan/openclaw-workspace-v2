unit FCharAttrib;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics,
    Controls, Forms, Dialogs, StdCtrls, A2Form, A2Img, deftype, ExtCtrls;
type
    TfrmCharAttrib = class(TForm)

        lbname: TA2Label;
        lblAttackSpeed: TA2Label;
        lblAvoid: TA2Label;
        lblAccuracy: TA2Label;
        lblRecovery: TA2Label;
        lblDamageBody: TA2Label;
        lblDamageHead: TA2Label;
        lblDamageArm: TA2Label;
        lblDamageLeg: TA2Label;
        lblArmorBody: TA2Label;
        lblArmorHead: TA2Label;
        lblArmorArm: TA2Label;
        lblArmorLeg: TA2Label;
        lblInPower: TA2Label;
        lblOutPower: TA2Label;
        lblMagic: TA2Label;
        lblLife: TA2Label;
        lblDefaultValue: TA2Label;
        lblAttribTotal: TA2Label;
        lblShoutLevel: TA2Label;
        lblLover: TA2Label;
        A2Form: TA2Form;
        A2Button14: TA2Button;
        LbAdaptive: TA2Label;
        LbRevival: TA2Label;
        Lbguildname: TA2Label;
        lblAge: TA2Label;
        lbPrestige: TA2Label;
        lbEnergy: TA2Label;
        lbVirtue: TA2Label;
        Timer1: TTimer;
        A2Button_Designation: TA2Button;
        A2LabelDesignation: TA2Label;
        listDesignation: TA2ListBox;
        A2Label_Designation_back: TA2ILabel;
        A2Button_showJOb: TA2Button;
        procedure FormCreate(Sender: TObject);
        procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure A2Button14Click(Sender: TObject);
        procedure Timer1Timer(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure A2Button_DesignationClick(Sender: TObject);
        procedure listDesignationMouseUp(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure A2Button_showJObClick(Sender: TObject);

    private

        { Private declarations }
    public
        { Public declarations }
        procedure send_user_Designation(astr: string);
        procedure send_Del_Designation(astr: string);
        procedure onupdate();
        procedure SetNewVersion;
        procedure SetOldVersion;
    end;

var
    frmCharAttrib: TfrmCharAttrib;

implementation

uses FMain, FBottom, FAttrib, FLogOn, fguild, filepgkclass, energy, CharCls, FConfirmDialog,
    FSkill;

{$R *.DFM}

procedure TfrmCharAttrib.onupdate();
var
    CL: TCharClass;
    n, rDefaultValue: integer;
begin

    Cl := CharList.CharGet(CharCenterId);
    if Cl = nil then exit;
    lblLover.Caption := cl.ConsortName;
    Lbguildname.Caption := frmGuild.guildname;
    lbname.Caption := cl.rName;
    LbAdaptive.Caption := Get10000To100(cAttribClass.AttribData.cAdaptive);
    LbRevival.Caption := Get10000To100(cAttribClass.AttribData.cRevival);

    lblAttackSpeed.Caption := inttostr(cAttribClass.LifeData.AttackSpeed);
    lblAvoid.Caption := inttostr(cAttribClass.LifeData.avoid);
    lblAccuracy.Caption := inttostr(cAttribClass.LifeData.accuracy);
    lblRecovery.Caption := inttostr(cAttribClass.LifeData.recovery);
    lblDamageBody.Caption := inttostr(cAttribClass.LifeData.damageBody);
    lblDamageHead.Caption := inttostr(cAttribClass.LifeData.damageHead);
    lblDamageArm.Caption := inttostr(cAttribClass.LifeData.damageArm);
    lblDamageLeg.Caption := inttostr(cAttribClass.LifeData.damageLeg);
    lblArmorBody.Caption := inttostr(cAttribClass.LifeData.armorBody);
    lblArmorHead.Caption := inttostr(cAttribClass.LifeData.armorHead);
    lblArmorArm.Caption := inttostr(cAttribClass.LifeData.armorArm);
    lblArmorLeg.Caption := inttostr(cAttribClass.LifeData.armorLeg);
    lblAge.Caption := Get10000To100(cAttribClass.AttribData.cAge);
    lbPrestige.Caption := IntToStr(cAttribClass.AttribData.prestige);
    lbEnergy.Caption := Get10000To100(cAttribClass.AttribData.cEnergy);
    lbVirtue.Caption := Get10000To100(cAttribClass.AttribData.cvirtue);
    with cAttribClass.AttribData do
    begin
        rDefaultValue := ((cAge + 1200) div 2);

        lblInPower.Caption := Get10000To100(cInPower);
        lblOutPower.Caption := Get10000To100(cOutPower);
        lblMagic.Caption := Get10000To100(cMagic);
        lblLife.Caption := Get10000To100(cLife);
        lblDefaultValue.Caption := Get10000To100(rDefaultValue);
        n := cMagic + cInPower + cOutPower + cLife;
        n := (n - 5000) div 4000;
        n := n - 5;
        if n <= 0 then n := 1;
        if n > 6 then n := 6;
        lblShoutLevel.Caption := inttostr(n) + '境界';
        lblAttribTotal.Caption := Get10000To100(rDefaultValue + cLife + cMagic + cOutPower + cInPower);
    end;
end;

procedure TfrmCharAttrib.SetNewVersion;
var
    temping, tempup, tempdown: TA2Image;
begin
    temping := TA2Image.Create(32, 32, 0, 0);
    tempup := TA2Image.Create(32, 32, 0, 0);
    tempdown := TA2Image.Create(32, 32, 0, 0);
    try
        pgkBmp.getBmp('角色信息窗口.bmp', A2form.FImageSurface);
        A2form.boImagesurface := true;

        pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
        A2Button14.A2Up := temping;
        pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
        A2Button14.A2Down := temping;
        pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
        A2Button14.A2Mouse := temping;
        pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
        A2Button14.A2NotEnabled := temping;

        pgkBmp.getBmp('角色信息_技术_弹起.bmp', temping);
        A2Button_showJOb.A2Up := temping;
        pgkBmp.getBmp('角色信息_技术_按下.bmp', temping);
        A2Button_showJOb.A2Down := temping;
        pgkBmp.getBmp('角色信息_技术_鼠标.bmp', temping);
        A2Button_showJOb.A2Mouse := temping;
        pgkBmp.getBmp('角色信息_技术_禁止.bmp', temping);
        A2Button_showJOb.A2NotEnabled := temping;


        pgkBmp.getBmp('角色信息_江湖称号_弹起.bmp', temping);
        A2Button_Designation.A2Up := temping;
        pgkBmp.getBmp('角色信息_江湖称号_按下.bmp', temping);
        A2Button_Designation.A2Down := temping;
        pgkBmp.getBmp('角色信息_江湖称号_鼠标.bmp', temping);
        A2Button_Designation.A2Mouse := temping;
        pgkBmp.getBmp('角色信息_江湖称号_禁止.bmp', temping);
        A2Button_Designation.A2NotEnabled := temping;


        pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
        listDesignation.SetScrollTopImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
        listDesignation.SetScrollTrackImage(tempUp, tempDown);
        pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
        pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
        listDesignation.SetScrollBottomImage(tempUp, tempDown);
        pgkBmp.getBmp('任务信息_下拉条底框A.bmp', temping);
        listDesignation.SetScrollBackImage(temping);

        pgkBmp.getBmp('角色信息_选择称号底框.bmp', temping);
        A2Label_Designation_back.A2Image := temping;


        A2Button14.Left := 211;
        A2Button14.Top := 9;

        //左边布局
        lbname.Left := 46;
        lbname.Top := 38;
        lbname.Width := 74;
        lbname.Height := 13;
        lblLover.Left := 46;
        lbllover.Top := 55;
        lblLover.Width := 74;
        lblLover.Height := 13;

        lblAttackSpeed.Left := 65;
        lblAttackSpeed.Top := 76;
        lblAttackSpeed.Width := 55;
        lblAttackSpeed.Height := 13;
        lblAccuracy.Left := 65;
        lblAccuracy.Top := 93;
        lblAccuracy.Width := 55;
        lblAccuracy.Height := 13;
        LbAdaptive.Left := 65;
        LbAdaptive.Top := 110;
        LbAdaptive.Width := 55;
        LbAdaptive.Height := 13;

        lblDamageBody.Left := 65;
        lblDamageBody.Top := 131;
        lblDamageBody.Width := 55;
        lblDamageBody.Height := 13;
        lblDamageHead.Left := 65;
        lblDamageHead.Top := 148;
        lblDamageHead.Width := 55;
        lblDamageHead.Height := 13;
        lblDamageArm.Left := 65;
        lblDamageArm.Top := 165;
        lblDamageArm.Width := 55;
        lblDamageArm.Height := 13;
        lblDamageLeg.Left := 65;
        lblDamageLeg.Top := 182;
        lblDamageLeg.Width := 55;
        lblDamageLeg.Height := 13;

        lblInPower.Left := 65;
        lblInPower.Top := 203;
        lblInPower.Width := 55;
        lblInPower.Height := 13;
        lblOutPower.Left := 65;
        lblOutPower.Top := 220;
        lblOutPower.Width := 55;
        lblOutPower.Height := 13;
        lblMagic.Left := 65;
        lblMagic.Top := 237;
        lblMagic.Width := 55;
        lblMagic.Height := 13;
        lblLife.Left := 65;
        lblLife.Top := 254;
        lblLife.Width := 55;
        lblLife.Height := 13;
        lblDefaultValue.Left := 65;
        lblDefaultValue.Top := 271;
        lblDefaultValue.Width := 55;
        lblDefaultValue.Height := 13;

        //右边布局
        lblAge.Left := 162;
        lblAge.Top := 38;
        lblAge.Width := 74;
        lblAge.Height := 13;
        Lbguildname.Left := 162;
        Lbguildname.Top := 55;
        Lbguildname.Width := 74;
        Lbguildname.Height := 13;

        lblRecovery.Left := 181;
        lblRecovery.Top := 76;
        lblRecovery.Width := 55;
        lblRecovery.Height := 13;
        lblAvoid.Left := 181;
        lblAvoid.Top := 93;
        lblAvoid.Width := 55;
        lblAvoid.Height := 13;
        LbRevival.Left := 181;
        LbRevival.Top := 110;
        LbRevival.Width := 55;
        LbRevival.Height := 13;

        lblArmorBody.Left := 181;
        lblArmorBody.Top := 131;
        lblArmorBody.Width := 55;
        lblArmorBody.Height := 13;
        lblArmorHead.Left := 181;
        lblArmorHead.Top := 148;
        lblArmorHead.Width := 55;
        lblArmorHead.Height := 13;
        lblArmorArm.Left := 181;
        lblArmorArm.Top := 165;
        lblArmorArm.Width := 55;
        lblArmorArm.Height := 13;
        lblArmorLeg.Left := 181;
        lblArmorLeg.Top := 182;
        lblArmorLeg.Width := 55;
        lblArmorLeg.Height := 13;

        lblAttribTotal.Left := 162;
        lblAttribTotal.Top := 237;
        lblAttribTotal.Width := 74;
        lblAttribTotal.Height := 13;
        lblShoutLevel.Left := 162;
        lblShoutLevel.Top := 254;
        lblShoutLevel.Width := 74;
        lblShoutLevel.Height := 13;

        lbPrestige.Left := 162;
        lbPrestige.Top := 271;
        lbPrestige.Width := 74;
        lbPrestige.Height := 13;
        lbPrestige.Visible := true;

        lbEnergy.Left := 162;
        lbEnergy.Top := 220;
        lbEnergy.Width := 74;
        lbEnergy.Height := 13;
        lbEnergy.Visible := true;

        lbVirtue.Left := 181;
        lbVirtue.Top := 203;
        lbVirtue.Width := 55;
        lbVirtue.Height := 13;
        lbVirtue.Visible := true;

    finally
        temping.Free;
        tempup.Free;
        tempdown.Free;
    end;

end;

procedure TfrmCharAttrib.SetOldVersion;
begin
    pgkBmp.getBmp('角色信息窗.bmp', A2form.FImageSurface);
    A2form.boImagesurface := true;
end;

procedure TfrmCharAttrib.FormCreate(Sender: TObject);
begin
    //
    FrmM.AddA2Form(Self, A2form);

    if WinVerType = wvtNew then
    begin
        SetNewVersion;
    end
    else if WinVerType = wvtOld then
    begin
        SetOldVersion;
    end;

    Left := 20;
    Top := 20;
end;

procedure TfrmCharAttrib.FormMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

procedure TfrmCharAttrib.A2Button14Click(Sender: TObject);
begin
    Visible := false;
end;

procedure TfrmCharAttrib.Timer1Timer(Sender: TObject);
begin
    if Visible = false then exit;
    onupdate;
end;

procedure TfrmCharAttrib.FormShow(Sender: TObject);
begin
    onupdate;
end;

procedure TfrmCharAttrib.A2Button_DesignationClick(Sender: TObject);
begin
    listDesignation.Visible := not listDesignation.Visible;
    A2Label_Designation_back.Visible := listDesignation.Visible;
end;

procedure TfrmCharAttrib.send_Del_Designation(astr: string);
var
    temp: TWordComData;
begin

    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Designation);
    WordComData_ADDbyte(temp, Designation_Del);
    WordComData_ADDString(temp, astr);

    FrmLogon.SocketAddData(temp.Size, @temp.data);

end;

procedure TfrmCharAttrib.send_user_Designation(astr: string);
var
    temp: TWordComData;
begin

    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_Designation);
    WordComData_ADDbyte(temp, Designation_user);
    WordComData_ADDString(temp, astr);

    FrmLogon.SocketAddData(temp.Size, @temp.data);

end;

procedure TfrmCharAttrib.listDesignationMouseUp(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    frmConfirmDialog: TfrmConfirmDialog;
    astr: string;
begin
    if Button = mbRight then
    begin
        if (listDesignation.ItemIndex < 0) or (listDesignation.ItemIndex > listDesignation.Count - 1) then
        else
        begin
            astr := listDesignation.Items[listDesignation.ItemIndex];
         //创建 输入 窗口
            frmConfirmDialog := TfrmConfirmDialog.Create(FrmM);
            frmConfirmDialog.ShowFrom(cdDel_Designation, astr, '你确认删除称号：' + astr);
        end;
        listDesignation.Visible := false;
        A2Label_Designation_back.Visible := listDesignation.Visible;
    end;
    if Button = mbLeft then
    begin
        if (listDesignation.ItemIndex < 0) or (listDesignation.ItemIndex > listDesignation.Count - 1) then
        else
        begin
            astr := listDesignation.Items[listDesignation.ItemIndex];
            send_user_Designation(astr);
        end;
        listDesignation.Visible := false;
        A2Label_Designation_back.Visible := listDesignation.Visible;
    end;
end;

procedure TfrmCharAttrib.A2Button_showJObClick(Sender: TObject);
begin
//
    frmSkill.Visible := true;
    frmSkill.send_Get_Job_blueprint_Menu;
    FrmM.SetA2Form(frmSkill, frmSkill.A2form);
end;

end.

