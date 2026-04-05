unit FEMAIL;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    A2Img, Dialogs, StdCtrls, A2Form, ExtCtrls, Deftype;

type
    TEMAILlist = record
        FID:integer;
        FTitle:string[64];         //标题
        FsourceName:string[32];    //来源 名字
    end;
    PTEMAILlist = ^TEMAILlist;
    TFrmEmail = class(TForm)
        A2Form:TA2Form;
        A2Button5:TA2Button;
        btnCommand2:TA2Button;
        A2Button1:TA2Button;
        A2Button2:TA2Button;
        A2ListBox1:TA2ListBox;
        A2ILabel1:TA2ILabel;
        procedure FormCreate(Sender:TObject);
        procedure FormMouseDown(Sender:TObject; Button:TMouseButton;
            Shift:TShiftState; X, Y:Integer);
        procedure A2Button5Click(Sender:TObject);
        procedure FormDestroy(Sender:TObject);
        procedure btnCommand2Click(Sender:TObject);
        procedure A2ListBox1AdxDrawItem(ASurface:TA2Image; index:Integer;
            aStr:string; Rect:TRect; State:TDrawItemState; fx, fy:Integer);
        procedure A2Button1Click(Sender:TObject);
        procedure A2ListBox1DblClick(Sender:TObject);
        procedure A2Button2Click(Sender:TObject);
    private
        { Private declarations }
    public
        { Public declarations }
        FNEWSTATEEMAIL:BOOLEAN;
        FNEWSTATEEMAILTick:integer;
        fdata:Tlist;
        temping:TA2Image;
        tempup:TA2Image;
        tempdown:TA2Image;
        procedure fdataClear;
        procedure fdataDel(eid:integer);
        procedure fdataadd(aid:integer; atitle, asourceName:string);
        function fdataget(aid:integer):pointer;
        function fdatagetIndex(aIndex:integer):pointer;
        procedure MessageProcess(var code:TWordComData);
        procedure getEMIAL(eid:integer);
        procedure delEMIAL(eid:integer);
        procedure readEMIAL(eid:integer);
        procedure getlistEMIAL();

        procedure update(CurTick:integer);
        procedure SetNewVersion();
        procedure SetOldVersion();
    end;

var
    FrmEmail        :TFrmEmail;

implementation

uses FMain, FAttrib, FLogOn, AtzCls, uAnsTick, CharCls, FNewEMAIL, FBottom, filepgkclass,
    Femailread, FShowPopMsg, FConfirmDialog;

{$R *.dfm}

function TFrmEmail.fdatagetIndex(aIndex:integer):pointer;
begin
    result := nil;
    if (aIndex < 0) or (aIndex >= fdata.Count) then exit;
    result := fdata.Items[aIndex];
end;

function TFrmEmail.fdataget(aid:integer):pointer;
var
    I               :INTEGER;
    PP              :PTEMAILlist;
begin
    result := nil;
    for I := 0 to fdata.Count - 1 do
    begin
        PP := fdata.Items[I];
        if pp.FID = aid then
        begin
            result := pp;
            exit;
        end;
    end;
end;

procedure TFrmEmail.fdataadd(aid:integer; atitle, asourceName:string);
var

    PP              :PTEMAILlist;
begin
    pp := fdataget(aid);
    if pp <> nil then exit;
    new(pp);
    pp.FID := aid;
    pp.FTitle := atitle;
    pp.FsourceName := asourceName;
    fdata.Add(pp);
    A2ListBox1.AddItem(' ');
end;

procedure TFrmEmail.fdataClear;
var
    I               :INTEGER;
    PP              :PTEMAILlist;
begin
    for I := 0 to fdata.Count - 1 do
    begin
        PP := fdata.Items[I];
        dispose(pp);
    end;
    fdata.Clear;
end;

procedure TFrmEmail.fdataDel(eid:integer);
var
    I               :INTEGER;
    PP              :PTEMAILlist;
begin
    for I := 0 to fdata.Count - 1 do
    begin
        PP := fdata.Items[I];
        if pp.FID = eid then
        begin
            fdata.Delete(i);
            dispose(pp);
            A2ListBox1.DeleteItem(0);
            exit;
        end;
    end;
end;

procedure TFrmEmail.update(CurTick:integer);
begin
    if FNEWSTATEEMAIL then
    begin
        if GetItemLineTimeSec(CurTick - FNEWSTATEEMAILTick) < 60 then exit;
        FNEWSTATEEMAILTick := CurTick;

        if FrmEmail.A2ListBox1.Count > 0 then
        begin
            frmPopMsg.ShowMsg(2, true);
            //FrmBottom.AddChat(format('你有%d封信件,请到信使 潘家舒(523,501)那里领取。', [FrmEmail.A2ListBox1.Count]), WinRGB(22, 22, 0), 0);
        end;
    end;
end;

procedure TFrmEmail.MessageProcess(var code:TWordComData);
var
    pckey           :PTCKey;
    aeid, id, akey, i, alen:integer;
    atitle, aname   :string;
begin
    pckey := @Code.Data;
    case pckey^.rmsg of
        SM_email:
            begin
                frmNEWEmail.MessageProcess(code);
                frmEmailRead.MessageProcess(code);
                id := 1;
                akey := WordComData_GETbyte(code, id);
                case akey of
                    EMAIL_STATE_NEWEMAIL:
                        begin
                            akey := WordComData_GETbyte(code, id);
                            FNEWSTATEEMAIL := boolean(akey);
                            FNEWSTATEEMAILTick := 0;
                            //frmPopMsg.ShowMsg(1, true);
                        end;
                    EMAIL_WindowsOpen:
                        begin
                            Visible := true;
                            FrmM.move_win_form_Align(self, mwfCenter);
                        end;
                    EMAIL_read:    //阅读
                        begin

                        end;
                    EMAIL_list:    //列表
                        begin
                            alen := WordComData_GETbyte(code, id);
                            for i := 0 to alen - 1 do
                            begin
                                aeid := WordComData_getdword(code, id);
                                atitle := WordComData_getstring(code, id);
                                aname := WordComData_getstring(code, id);
                                fdataadd(aeid, atitle, aname);
                            end;
                            if alen <> 0 then
                                FrmBottom.AddChat(format('你有%d封信件。', [alen]), WinRGB(22, 22, 0), 0)
                            else
                                FrmBottom.AddChat(format('我这里没有你的信件。', [alen]), WinRGB(22, 22, 0), 0);
                        end;
                    EMAIL_del:     //删除
                        begin

                        end;
                    EMAIL_get:     //收取
                        begin
                            aeid := WordComData_getdword(code, id);
                            fdataDel(aeid);
                        end;
                end;

            end;
    end;
end;

procedure TFrmEmail.FormCreate(Sender:TObject);
begin
    FrmM.AddA2Form(Self, A2Form);

    //Parent := FrmM;
    if WinVerType = wvtOld then
    begin
        SetoldVersion;
    end else if WinVerType = wvtnew then
    begin
        SetNewVersion;
    end;
    Top := 0;
    Left := 0;
    FNEWSTATEEMAIL := FALSE;

    A2ListBox1.FFontSelBACKColor := ColorSysToDxColor($9B7781);

    fdata := Tlist.Create;
end;

procedure TFrmEmail.SetNewVersion();
begin
    pgkBmp.getBmp('邮箱窗口.bmp', A2form.FImageSurface);
    A2form.boImagesurface := true;
    temping := TA2Image.Create(32, 32, 0, 0);
    //写信
    pgkBmp.getBmp('邮箱_写信_弹起.bmp', temping);
    btnCommand2.A2Up := temping;
    pgkBmp.getBmp('邮箱_写信_按下.bmp', temping);
    btnCommand2.A2Down := temping;
    pgkBmp.getBmp('邮箱_写信_鼠标.bmp', temping);
    btnCommand2.A2Mouse := temping;
    pgkBmp.getBmp('邮箱_写信_禁止.bmp', temping);
    btnCommand2.A2NotEnabled := temping;
    btnCommand2.Left := 113;
    btnCommand2.Top := 263;
    //阅读
    pgkBmp.getBmp('邮箱_阅读_弹起.bmp', temping);
    A2Button1.A2Up := temping;
    pgkBmp.getBmp('邮箱_阅读_按下.bmp', temping);
    A2Button1.A2Down := temping;
    pgkBmp.getBmp('邮箱_阅读_鼠标.bmp', temping);
    A2Button1.A2Mouse := temping;
    pgkBmp.getBmp('邮箱_阅读_禁止.bmp', temping);
    A2Button1.A2NotEnabled := temping;
    A2Button1.Left := 174;
    A2Button1.Top := 263;
    //关闭
    pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
    A2Button5.A2Up := temping;
    pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
    A2Button5.A2Down := temping;
    pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
    A2Button5.A2Mouse := temping;
    pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
    A2Button5.A2NotEnabled := temping;
    A2Button5.Left := 207;
    A2Button5.Top := 9;
    A2Button5.Width := 17;
    A2Button5.Height := 17;

    tempup := TA2Image.Create(32, 32, 0, 0);
    tempdown := TA2Image.Create(32, 32, 0, 0);
    //
    A2ListBox1.Left := 18;
    A2ListBox1.Top := 64;
    A2ListBox1.Width := 212;
    A2ListBox1.Height := 192;
    pgkBmp.getBmp('通用下拉菜单_上_弹起.bmp', tempUp);
    pgkBmp.getBmp('通用下拉菜单_上_按下.bmp', tempDown);
    A2ListBox1.SetScrollTopImage(tempUp, tempDown);
    pgkBmp.getBmp('通用下拉菜单_滑钮_弹起.bmp', tempUp);
    pgkBmp.getBmp('通用下拉菜单_滑钮_按下.bmp', tempDown);
    A2ListBox1.SetScrollTrackImage(tempUp, tempDown);
    pgkBmp.getBmp('通用下拉菜单_下_弹起.bmp', tempUp);
    pgkBmp.getBmp('通用下拉菜单_下_按下.bmp', tempDown);
    A2ListBox1.SetScrollBottomImage(tempUp, tempDown);
    pgkBmp.getBmp('温馨提示_下拉条底框.bmp', temping);
    A2ListBox1.SetScrollBackImage(temping);
    A2ListBox1.FFontSelBACKColor := ColorSysToDxColor($9B7781);
    A2ListBox1.FLayout := tlCenter;
end;

procedure TFrmEmail.SetOldVersion();
begin
    pgkBmp.getBmp('EMAIL.bmp', A2form.FImageSurface);
    A2form.boImagesurface := true;
    A2ListBox1.SetScrollTopImage(getviewImage(7), getviewImage(6));
    A2ListBox1.SetScrollTrackImage(getviewImage(4), getviewImage(5));
    A2ListBox1.SetScrollBottomImage(getviewImage(9), getviewImage(8));
end;

procedure TFrmEmail.FormMouseDown(Sender:TObject; Button:TMouseButton;
    Shift:TShiftState; X, Y:Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

procedure TFrmEmail.getEMIAL(eid:integer);
var
    temp            :TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_EMAIL);
    WordComData_ADDbyte(temp, EMAIL_get);
    WordComData_ADDdword(temp, eid);
    FrmLogon.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmEmail.delEMIAL(eid:integer);
var
    temp            :TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_EMAIL);
    WordComData_ADDbyte(temp, EMAIL_del);
    WordComData_ADDdword(temp, eid);
    FrmLogon.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmEmail.readEMIAL(eid:integer);
var
    temp            :TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_EMAIL);
    WordComData_ADDbyte(temp, EMAIL_read);
    WordComData_ADDdword(temp, eid);
    FrmLogon.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmEmail.getlistEMIAL();
var
    temp            :TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_EMAIL);
    WordComData_ADDbyte(temp, EMAIL_list);
    FrmLogon.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmEmail.A2Button5Click(Sender:TObject);

var
    temp            :TWordComData;
begin
    Visible := false;
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_EMAIL);
    WordComData_ADDbyte(temp, EMAIL_WindowsClose);
    FrmLogon.SocketAddData(temp.Size, @temp.data);

end;

procedure TFrmEmail.FormDestroy(Sender:TObject);
begin
    fdataClear;
    fdata.Free;
    temping.Free;
    tempup.Free;
    tempdown.Free;
end;

procedure TFrmEmail.btnCommand2Click(Sender:TObject);
begin
    FrmNEWEmail.newEmail;
end;

procedure TFrmEmail.A2ListBox1AdxDrawItem(ASurface:TA2Image;
    index:Integer; aStr:string; Rect:TRect; State:TDrawItemState; fx,
    fy:Integer);
var
    pp              :PTEMAILlist;
begin
    pp := fdatagetIndex(index);
    if pp = nil then
    begin
        ATextOut(ASurface, 0, 0, ColorSysToDxColor(clred), '错误');
    end
    else
    begin
        ATextOut(ASurface, 0, 0, A2ListBox1.FontColor, pp.FsourceName);
        ATextOut(ASurface, 100, 0, A2ListBox1.FontColor, pp.FTitle);
    end;
end;

procedure TFrmEmail.A2Button1Click(Sender:TObject);
var
    pp              :PTEMAILlist;
begin
    pp := fdatagetIndex(A2ListBox1.ItemIndex);
    if pp = nil then exit;
    readEMIAL(pp.FID);
end;

procedure TFrmEmail.A2ListBox1DblClick(Sender:TObject);
var
    pp              :PTEMAILlist;
begin
    pp := fdatagetIndex(A2ListBox1.ItemIndex);
    if pp = nil then exit;
    readEMIAL(pp.FID);
end;

procedure TFrmEmail.A2Button2Click(Sender:TObject);
var
    pp              :PTEMAILlist;
begin
    pp := fdatagetIndex(A2ListBox1.ItemIndex);
    if pp = nil then exit;
    getEMIAL(pp.FID);
end;

end.

