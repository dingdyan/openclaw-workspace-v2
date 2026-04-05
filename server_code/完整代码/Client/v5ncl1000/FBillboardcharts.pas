unit FBillboardcharts;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, A2Form, StdCtrls, ExtCtrls, Deftype, A2Img;

type
    //TBillboardchartsdata
    TfrmBillboardcharts = class(TForm)
        A2Form:TA2Form;
    A2ButtonEnergy: TA2Button;
        A2ButtonPrestige:TA2Button;
        A2Button2:TA2Button;
        A2ListBox1:TA2ListBox;
        A2ButtonNEXT:TA2Button;
        ComboBox:TA2ComboBox;
        A2Button3:TA2Button;
        A2ILabelTitle:TA2ILabel;
        A2ILabelfield:TA2ILabel;
        procedure FormCreate(Sender:TObject);
        procedure FormDestroy(Sender:TObject);
        procedure A2ButtonEnergyClick(Sender:TObject);
        procedure A2ButtonPrestigeClick(Sender:TObject);
        procedure A2ButtonNEXTClick(Sender:TObject);
        procedure FormShow(Sender:TObject);
        procedure A2ListBox1AdxDrawItem(ASurface:TA2Image; index:Integer;
            aStr:string; Rect:TRect; State:TDrawItemState; fx, fy:Integer);
        procedure A2Button2Click(Sender:TObject);
        procedure A2Button3Click(Sender:TObject);
        procedure ComboBoxChange(Sender:TObject);
        procedure FormMouseDown(Sender:TObject; Button:TMouseButton;
            Shift:TShiftState; X, Y:Integer);
    private
        { Private declarations }
    public
        { Public declarations }
        Findex:integer;
        fdata:tlist;
        ftype:TBillboardchartstype;

        temptitle1:TA2Image;
        temptitle2:TA2Image;
        procedure FDATAClear();

        procedure fdataadd(aid:integer; aname:string; aEnergy, aprestige:integer; aboman:string);
        function GETIndex(aid:integer):pTBillboardchartsdata;
        function GETname(aname:string):pTBillboardchartsdata;

        procedure MessageProcess(var code:TWordComData);

        procedure SetNewVersion;
        procedure SetOldVersion;
    end;

var
    frmBillboardcharts:TfrmBillboardcharts;

implementation

uses FBottom, FLogOn, FMain, filepgkclass, CharCls;

{$R *.dfm}

procedure TfrmBillboardcharts.MessageProcess(var code:TWordComData);
var
    pckey           :PTCKey;
    id, akey, i, alen:integer;
    pp              :TBillboardchartsdata;
begin
    pckey := @Code.Data;
    case pckey^.rmsg of
        SM_Billboardcharts:
            begin
                id := 1;
                akey := WordComData_GETbyte(code, id);

                case akey of
                    Billboardcharts_Energy:
                        begin
                            A2ILabelTitle.A2Image := temptitle2;
                        end;
                    Billboardcharts_Prestige:
                        begin
                            A2ILabelTitle.A2Image := temptitle1;
                        end;
                end;
                alen := WordComData_GETdword(code, id);
                Findex := WordComData_GETdword(code, id);
                for i := 0 to alen - 1 do
                begin
                    pp.rid := WordComData_getdword(code, id);
                    pp.rname := WordComData_getstring(code, id);
                    pp.rEnergy := WordComData_getdword(code, id);
                    pp.rPrestige := WordComData_getdword(code, id);
                    pp.rboman := WordComData_getstring(code, id);
                    fdataadd(pp.rid, pp.rname, pp.rEnergy, pp.rPrestige, pp.rboman);
                end;

            end;
    end;
end;

procedure TfrmBillboardcharts.fdataadd(aid:integer; aname:string; aEnergy, aprestige:integer; aboman:string);
var
    p               :pTBillboardchartsdata;
begin
    if GETname(aname) <> nil then exit;
    new(p);
    p.rid := aid;
    p.rname := aname;
    p.rEnergy := aEnergy;
    p.rPrestige := aprestige;
    p.rboman := aboman;

    fdata.Add(p);
    A2ListBox1.AddItem(' ');
    A2ListBox1.DrawItem;
end;

function TfrmBillboardcharts.GETIndex(aid:integer):pTBillboardchartsdata;
begin
    result := nil;
    if (aid < 0) or (aid > FDATA.Count - 1) then exit;
    result := fdata.Items[aid];
end;

function TfrmBillboardcharts.GETname(aname:string):pTBillboardchartsdata;
var
    i               :integer;
    p               :pTBillboardchartsdata;
begin
    result := nil;
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        if p.rname = aname then
        begin
            result := p;
            exit;
        end;
    end;

end;

procedure TfrmBillboardcharts.FDATAClear();
var
    i               :integer;
    p               :pTBillboardchartsdata;
begin
    for i := 0 to fdata.Count - 1 do
    begin
        p := fdata.Items[i];
        dispose(p);
    end;
    fdata.Clear;
    A2ListBox1.Clear;
    A2ListBox1.DrawItem;
end;

procedure TfrmBillboardcharts.SetNewVersion;
var
    temping         :TA2Image;
begin
    temping := TA2Image.Create(32, 32, 0, 0);
    try
        pgkBmp.getBmp('排行榜窗口.bmp', A2Form.FImageSurface);
        A2Form.boImagesurface := true;
        Width := A2Form.FImageSurface.Width;
        Height := a2form.FImageSurface.Height;

        pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
        A2Button2.A2Up := temping;
        pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
        A2Button2.A2Down := temping;
        pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
        A2Button2.A2Mouse := temping;
        pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
        A2Button2.A2NotEnabled := temping;
        A2Button2.Left := 358;
        A2Button2.Top := 25;

        pgkBmp.getBmp('排行榜_元气榜_弹起.bmp', temping);
        A2ButtonEnergy.A2Up := temping;
        pgkBmp.getBmp('排行榜_元气榜_按下.bmp', temping);
        A2ButtonEnergy.A2Down := temping;
        pgkBmp.getBmp('排行榜_元气榜_鼠标.bmp', temping);
        A2ButtonEnergy.A2Mouse := temping;
        pgkBmp.getBmp('排行榜_元气榜_禁止.bmp', temping);
        A2ButtonEnergy.A2NotEnabled := temping;
        A2ButtonEnergy.Left := 24;
        A2ButtonEnergy.Top := 59;
        A2ButtonEnergy.Caption := '';
        A2ButtonEnergy.ADXForm := A2Form;
        A2ButtonEnergy.Visible := true;

        pgkBmp.getBmp('排行榜_荣誉榜_弹起.bmp', temping);
        A2ButtonPrestige.A2Up := temping;
        pgkBmp.getBmp('排行榜_荣誉榜_按下.bmp', temping);
        A2ButtonPrestige.A2Down := temping;
        pgkBmp.getBmp('排行榜_荣誉榜_鼠标.bmp', temping);
        A2ButtonPrestige.A2Mouse := temping;
        pgkBmp.getBmp('排行榜_荣誉榜_禁止.bmp', temping);
        A2ButtonPrestige.A2NotEnabled := temping;
        A2ButtonPrestige.Left := 80;
        A2ButtonPrestige.Top := 59;
        A2ButtonPrestige.Caption := '';
        A2ButtonPrestige.ADXForm := A2Form;
        A2ButtonPrestige.Visible := true;

        //353 219 353 201
        A2ListBox1.Left := 25;
        A2ListBox1.Top := 110;     //140
        A2ListBox1.Width := 360;
        A2ListBox1.Height := 201;

        A2ILabelfield.Left := 28;
        A2ILabelfield.Top := 87;

        ComboBox.Visible := false;

        A2ListBox1.FFontSelBACKColor := ColorSysToDxColor($887766);
        //A2ListBox1.FLayout := tlCenter;

    finally
        temping.Free;
    end;

end;

procedure TfrmBillboardcharts.SetOldVersion;
begin
    temptitle1 := TA2Image.Create(32, 32, 0, 0);

    pgkBmp.getBmp('Billboardcharts.bmp', A2form.FImageSurface);
    A2form.boImagesurface := true;
    // temptitle1.LoadFromFile('.\BillboardchartsPrestige.bmp');
    pgkBmp.getBmp('BillboardchartsPrestige.bmp', temptitle1);
    temptitle2 := TA2Image.Create(32, 32, 0, 0);
    //temptitle2.LoadFromFile('.\Billboardchartsage.bmp');
    pgkBmp.getBmp('Billboardchartsage.bmp', temptitle2);
    A2ILabelTitle.A2Image := temptitle1;
end;

procedure TfrmBillboardcharts.FormCreate(Sender:TObject);
var
    temp            :TA2Image;
begin
    Findex := -1;
    fdata := tlist.Create;
    FrmM.AddA2Form(Self, A2Form);
    //Parent := FrmM;
    Top := 30;
    Left := 0;

    if WinVerType = wvtNew then
    begin
        SetNewVersion;
    end
    else if WinVerType = wvtOld then
    begin
        SetOldVersion;
    end;

    temp := TA2Image.Create(A2ILabelfield.Width, A2ILabelfield.Height, 0, 0);
    try
        ATextOut(temp, 0 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), '排名');
        ATextOut(temp, 70 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), '角色名字');
        ATextOut(temp, 170 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), '性别');
        ATextOut(temp, 230 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), '元气');
        ATextOut(temp, 300 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), '荣誉');

        ATextOut(temp, 0, 0, ColorSysToDxColor($003C9DFF), '排名');
        ATextOut(temp, 70, 0, ColorSysToDxColor($003C9DFF), '角色名字');
        ATextOut(temp, 170, 0, ColorSysToDxColor($003C9DFF), '性别');
        ATextOut(temp, 230, 0, ColorSysToDxColor($003C9DFF), '元气');
        ATextOut(temp, 300, 0, ColorSysToDxColor($003C9DFF), '荣誉');

        A2ILabelfield.A2Image := temp;
    finally
        temp.Free;
    end;

end;

procedure TfrmBillboardcharts.FormDestroy(Sender:TObject);
begin
    FDATAClear;
    fdata.Free;

    temptitle1.Free;
    temptitle2.Free;
end;

procedure TfrmBillboardcharts.A2ButtonEnergyClick(Sender:TObject);
begin
    ftype := bctEnergy;
    Findex := -1;
    A2ButtonNEXTClick(nil);
end;

procedure TfrmBillboardcharts.A2ButtonPrestigeClick(Sender:TObject);
begin
    ftype := bctPrestige;
    Findex := -1;
    A2ButtonNEXTClick(nil);
end;

procedure TfrmBillboardcharts.A2ButtonNEXTClick(Sender:TObject);
var
    tempsend        :TWordComData;
begin

    inc(Findex);
    if Findex < 0 then Findex := 0;
    FDATAClear;
    tempsend.Size := 0;
    WordComData_ADDbyte(tempsend, CM_Billboardcharts);
    case ftype of
        bctEnergy:WordComData_ADDbyte(tempsend, Billboardcharts_Energy);
        bctPrestige:WordComData_ADDbyte(tempsend, Billboardcharts_Prestige);
    end;
    WordComData_ADDdword(tempsend, Findex);
    FrmLogon.SocketAddData(tempsend.Size, @tempsend.data);
end;

procedure TfrmBillboardcharts.FormShow(Sender:TObject);
begin
    FDATAClear;
    ComboBoxChange(nil);
end;

procedure TfrmBillboardcharts.A2ListBox1AdxDrawItem(ASurface:TA2Image;
    index:Integer; aStr:string; Rect:TRect; State:TDrawItemState; fx,
    fy:Integer);
var
    P               :pTBillboardchartsdata;
    acolor          :tcolor;
begin
    P := GETIndex(index);
    if P = nil then EXIT;
    fx := 340 - ATextWidth(inttostr(p.rPrestige));
    {ATextOut(ASurface, 0 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), inttostr(p.rid));
    ATextOut(ASurface, 70 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), p.rname);
    ATextOut(ASurface, 180 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), p.rboman);
    ATextOut(ASurface, 230 + 1, 0 + 1, ColorSysToDxColor($000A0A0A), Get10000To100(p.rage));
    ATextOut(ASurface, fx + 1, 0 + 1, ColorSysToDxColor($000A0A0A), inttostr(p.rPrestige));
   }

    if WinVerType = wvtnew then
    begin
        acolor := $000FFFFF;
    end else if WinVerType = wvtold then
    begin
        acolor := $000A0A0A;
    end;
    if p.rname = CharCenterName then acolor := $00FFFF00;

    ATextOut(ASurface, 0, 0, ColorSysToDxColor(acolor), inttostr(p.rid));
    ATextOut(ASurface, 70, 0, ColorSysToDxColor(acolor), p.rname);
    ATextOut(ASurface, 180, 0, ColorSysToDxColor(acolor), p.rboman);
    ATextOut(ASurface, 230, 0, ColorSysToDxColor(acolor), Get10000To100(p.rEnergy));

    ATextOut(ASurface, fx, 0, ColorSysToDxColor(acolor), inttostr(p.rPrestige));

end;

procedure TfrmBillboardcharts.A2Button2Click(Sender:TObject);
begin
    Visible := false;
end;

procedure TfrmBillboardcharts.A2Button3Click(Sender:TObject);
var
    tempsend        :TWordComData;
begin

    if Findex = 0 then exit;
    dec(Findex);
    if Findex < 0 then Findex := 0;
    FDATAClear;
    tempsend.Size := 0;
    WordComData_ADDbyte(tempsend, CM_Billboardcharts);
    case ftype of
        bctEnergy:WordComData_ADDbyte(tempsend, Billboardcharts_Energy);
        bctPrestige:WordComData_ADDbyte(tempsend, Billboardcharts_Prestige);
    end;

    WordComData_ADDdword(tempsend, Findex);
    FrmLogon.SocketAddData(tempsend.Size, @tempsend.data);
end;

procedure TfrmBillboardcharts.ComboBoxChange(Sender:TObject);
begin
    if ComboBox.Text = '荣誉榜' then
    begin
        A2ButtonPrestigeClick(nil);
    end
    else if ComboBox.Text = '元气榜' then
    begin
        A2ButtonEnergyClick(nil);
    end;
end;

procedure TfrmBillboardcharts.FormMouseDown(Sender:TObject;
    Button:TMouseButton; Shift:TShiftState; X, Y:Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

end.

