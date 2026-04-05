unit FSound;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    a2img, ComCtrls, MMSystem, USound, StdCtrls, A2Form, ExtCtrls, deftype, AUtil32;

type
    TFrmSound = class(TForm)
        BtnOutcrybak:TA2Button;
        BtnGuildbak:TA2Button;
        BtnNoticebak:TA2Button;
        BtnNormalbak:TA2Button;
        Image1:TImage;
        A2Button1:TA2Button;
        A2Button2:TA2Button;
        A2Form:TA2Form;
        Check_Outcry:TA2CheckBox;
        Check_Notice:TA2CheckBox;
        Check_Guild:TA2CheckBox;
        Check_Normal:TA2CheckBox;
        A2Button3:TA2Button;
        A2Button4:TA2Button;
        A2Button5:TA2Button;
        A2Button6:TA2Button;
        A2Button7:TA2Button;
        Check_Team:TA2CheckBox;
        Check_World:TA2CheckBox;
        procedure FormCreate(Sender:TObject);
        procedure FormDestroy(Sender:TObject);
        procedure BtnNormalbakClick(Sender:TObject);
        procedure A2Button2MouseDown(Sender:TObject; Button:TMouseButton;
            Shift:TShiftState; X, Y:Integer);
        procedure A2Button2MouseUp(Sender:TObject; Button:TMouseButton;
            Shift:TShiftState; X, Y:Integer);
        procedure A2Button2MouseMove(Sender:TObject; Shift:TShiftState; X,
            Y:Integer);
        procedure A2Button1MouseDown(Sender:TObject; Button:TMouseButton;
            Shift:TShiftState; X, Y:Integer);
        procedure A2Button1MouseUp(Sender:TObject; Button:TMouseButton;
            Shift:TShiftState; X, Y:Integer);
        procedure A2Button1MouseMove(Sender:TObject; Shift:TShiftState; X,
            Y:Integer);
        procedure FormShow(Sender:TObject);
        procedure Check_OutcryClick(Sender:TObject);
        procedure Check_GuildClick(Sender:TObject);
        procedure Check_NoticeClick(Sender:TObject);
        procedure Check_NormalClick(Sender:TObject);
        procedure A2Button3Click(Sender:TObject);
        procedure A2Button4Click(Sender:TObject);
        procedure A2Button5Click(Sender:TObject);
        procedure A2Button6Click(Sender:TObject);
        procedure A2Button7Click(Sender:TObject);
        procedure Check_TeamClick(Sender:TObject);
        procedure Check_WorldClick(Sender:TObject);
        procedure FormMouseDown(Sender:TObject; Button:TMouseButton;
            Shift:TShiftState; X, Y:Integer);
    private
        { Private declarations }
    public
        procedure setVolume(av:integer);
        procedure setVolumeEffect(av:integer);

        procedure SetNewVersion;
        procedure SetOldVersion;
    end;

var
    FrmSound        :TFrmSound;

var
    Boolflag        :Boolean;
    Or_X            :integer;
    Max, Min        :integer;
implementation

uses FMain, FBottom, filepgkclass, FLogOn;

{$R *.DFM}

//////////////////// FrmSound //////////////////////////////////////////////////

procedure TFrmSound.SetNewVersion;
var
    temping         :TA2Image;
begin
    temping := TA2Image.Create(32, 32, 0, 0);
    try
        pgkBmp.getBmp('游戏设置窗口.bmp', A2Form.FImageSurface);
        A2form.boImagesurface := true;
        Width := A2Form.FImageSurface.Width;
        Height := A2Form.FImageSurface.Height;

        pgkBmp.getBmp('游戏设置_滑动条A.bmp', temping);
        A2Button1.A2Up := temping;
        pgkBmp.getBmp('游戏设置_滑动条A.bmp', temping);
        A2Button1.A2Down := temping;
        A2Button1.Top := 79;

        pgkBmp.getBmp('游戏设置_滑动条B.bmp', temping);
        A2Button2.A2Up := temping;
        pgkBmp.getBmp('游戏设置_滑动条B.bmp', temping);
        A2Button2.A2Down := temping;
        A2Button2.Top := 117;

        pgkBmp.getBmp('通用减号_弹起.bmp', temping);
        A2Button3.A2Up := temping;
        pgkBmp.getBmp('通用减号_按下.bmp', temping);
        A2Button3.A2Down := temping;
        pgkBmp.getBmp('通用减号_鼠标.bmp', temping);
        A2Button3.A2Mouse := temping;
        pgkBmp.getBmp('通用减号_禁止.bmp', temping);
        A2Button3.A2NotEnabled := temping;
        A2Button3.Left := 13;
        A2Button3.Top := 73;
        A2Button3.Visible := true;

        pgkBmp.getBmp('通用加号_弹起.bmp', temping);
        A2Button4.A2Up := temping;
        pgkBmp.getBmp('通用加号_按下.bmp', temping);
        A2Button4.A2Down := temping;
        pgkBmp.getBmp('通用加号_鼠标.bmp', temping);
        A2Button4.A2Mouse := temping;
        pgkBmp.getBmp('通用加号_禁止.bmp', temping);
        A2Button4.A2NotEnabled := temping;
        A2Button4.Left := 140;
        A2Button4.Top := 73;
        A2Button4.Visible := true;

        pgkBmp.getBmp('通用减号_弹起.bmp', temping);
        A2Button5.A2Up := temping;
        pgkBmp.getBmp('通用减号_按下.bmp', temping);
        A2Button5.A2Down := temping;
        pgkBmp.getBmp('通用减号_鼠标.bmp', temping);
        A2Button5.A2Mouse := temping;
        pgkBmp.getBmp('通用减号_禁止.bmp', temping);
        A2Button5.A2NotEnabled := temping;
        A2Button5.Left := 13;
        A2Button5.Top := 111;
        A2Button5.Visible := true;

        pgkBmp.getBmp('通用加号_弹起.bmp', temping);
        A2Button6.A2Up := temping;
        pgkBmp.getBmp('通用加号_按下.bmp', temping);
        A2Button6.A2Down := temping;
        pgkBmp.getBmp('通用加号_鼠标.bmp', temping);
        A2Button6.A2Mouse := temping;
        pgkBmp.getBmp('通用加号_禁止.bmp', temping);
        A2Button6.A2NotEnabled := temping;
        A2Button6.Left := 140;
        A2Button6.Top := 111;
        A2Button6.Visible := true;

        pgkBmp.getBmp('通用X关闭按钮_弹起.bmp', temping);
        A2Button7.A2Up := temping;
        pgkBmp.getBmp('通用X关闭按钮_按下.bmp', temping);
        A2Button7.A2Down := temping;
        pgkBmp.getBmp('通用X关闭按钮_鼠标.bmp', temping);
        A2Button7.A2Mouse := temping;
        pgkBmp.getBmp('通用X关闭按钮_禁止.bmp', temping);
        A2Button7.A2NotEnabled := temping;
        A2Button7.Left := 133;
        A2Button7.Top := 17;
        A2Button7.Visible := true;

        pgkBmp.getBmp('游戏设置_显示调整_打勾.bmp', temping);
        Check_Outcry.SelectImage := temping;
        pgkBmp.getBmp('游戏设置_显示调整_空白.bmp', temping);
        Check_Outcry.SelectNotImage := temping;
        Check_Outcry.AutoSize := false;

        Check_Outcry.Left := 120;  //57;
        Check_Outcry.Top := 204;   //164;
        Check_Outcry.Width := 17;
        Check_Outcry.Height := 17;

        pgkBmp.getBmp('游戏设置_显示调整_打勾.bmp', temping);
        Check_Guild.SelectImage := temping;
        pgkBmp.getBmp('游戏设置_显示调整_空白.bmp', temping);
        Check_Guild.SelectNotImage := temping;
        Check_Guild.AutoSize := false;

        Check_Guild.Left := 120;
        Check_Guild.Top := 164;
        Check_Guild.Width := 17;
        Check_Guild.Height := 17;

        pgkBmp.getBmp('游戏设置_显示调整_打勾.bmp', temping);
        Check_Notice.SelectImage := temping;
        pgkBmp.getBmp('游戏设置_显示调整_空白.bmp', temping);
        Check_Notice.SelectNotImage := temping;
        Check_Notice.AutoSize := false;

        Check_Notice.Left := 57;
        Check_Notice.Top := 184;
        Check_Notice.Width := 17;
        Check_Notice.Height := 17;

        pgkBmp.getBmp('游戏设置_显示调整_打勾.bmp', temping);
        Check_Normal.SelectImage := temping;
        pgkBmp.getBmp('游戏设置_显示调整_空白.bmp', temping);
        Check_Normal.SelectNotImage := temping;
        Check_Normal.AutoSize := false;

        Check_Normal.Left := 57;
        Check_Normal.Top := 164;
        Check_Normal.Width := 17;
        Check_Normal.Height := 17;

        pgkBmp.getBmp('游戏设置_显示调整_打勾.bmp', temping);
        Check_Team.SelectImage := temping;
        pgkBmp.getBmp('游戏设置_显示调整_空白.bmp', temping);
        Check_Team.SelectNotImage := temping;
        Check_Team.AutoSize := false;

        Check_Team.Left := 57;
        Check_Team.Top := 204;
        Check_Team.Width := 17;
        Check_Team.Height := 17;
        Check_Team.Visible := true;

        pgkBmp.getBmp('游戏设置_显示调整_打勾.bmp', temping);
        Check_World.SelectImage := temping;
        pgkBmp.getBmp('游戏设置_显示调整_空白.bmp', temping);
        Check_World.SelectNotImage := temping;
        Check_World.AutoSize := false;

        Check_World.Left := 120;   //120;
        Check_World.Top := 184;    //204;
        Check_World.Width := 17;
        Check_World.Height := 17;
        Check_World.Visible := true;

        Image1.Visible := false;

        max := 118;
        min := 32;
    finally
        temping.Free;
    end;
end;

procedure TFrmSound.SetOldVersion;
var
    tempimg         :TA2Image;
begin
    tempimg := TA2Image.Create(32, 32, 0, 0);
    try
        A2form.FImageSurface.LoadFromBitmap(Image1.Picture.Bitmap);
        A2form.boImagesurface := true;

        tempimg.LoadFromBitmap(BtnOutcrybak.UpImage.Bitmap);
        Check_Outcry.SelectImage := tempimg;
        tempimg.LoadFromBitmap(BtnOutcrybak.DownImage.Bitmap);
        Check_Outcry.SelectNotImage := tempimg;

        tempimg.LoadFromBitmap(BtnGuildbak.UpImage.Bitmap);
        Check_Guild.SelectImage := tempimg;
        tempimg.LoadFromBitmap(BtnGuildbak.DownImage.Bitmap);
        Check_Guild.SelectNotImage := tempimg;

        tempimg.LoadFromBitmap(BtnNoticebak.UpImage.Bitmap);
        Check_Notice.SelectImage := tempimg;
        tempimg.LoadFromBitmap(BtnNoticebak.DownImage.Bitmap);
        Check_Notice.SelectNotImage := tempimg;

        tempimg.LoadFromBitmap(BtnNormalbak.UpImage.Bitmap);
        Check_Normal.SelectImage := tempimg;
        tempimg.LoadFromBitmap(BtnNormalbak.DownImage.Bitmap);
        Check_Normal.SelectNotImage := tempimg;

        max := 105;
        min := 30;
    finally
        tempimg.Free;
    end;
end;

procedure TFrmSound.FormCreate(Sender:TObject);

begin
    // Parent := FrmM;
    Color := clBlack;
    Left := 0;
    Top := 14;
    FrmM.AddA2Form(Self, A2form);

    Boolflag := FALSE;

    if WinVerType = wvtNew then
    begin
        SetNewVersion;
    end
    else if WinVerType = wvtOld then
    begin
        SetOldVersion;
    end;
    A2Button1.Left := FrmM.SoundManager.Volume;
    A2Button2.Left := FrmM.SoundManager.VolumeEffect;
    if A2Button1.Left >= max then A2Button1.Left := max;
    if A2Button1.Left <= min then A2Button1.Left := min;
    if A2Button2.Left >= max then A2Button2.Left := max;
    if A2Button2.Left <= min then A2Button2.Left := min;

    Check_Outcry.Checked := true;
    Check_Notice.Checked := true;
    Check_Guild.Checked := true;
    Check_Normal.Checked := true;
    Check_Team.Checked := true;
    Check_World.Checked := true;
    Check_World.Enabled := false;
end;

procedure TFrmSound.FormDestroy(Sender:TObject);
begin
end;

/////////////////// OPTION CHAT ////////////////////////////////////////////////

procedure TFrmSound.BtnNormalbakClick(Sender:TObject);
begin
end;

/////////////////// OPTION SOUND ///////////////////////////////////////////////

procedure TFrmSound.A2Button2MouseDown(Sender:TObject;
    Button:TMouseButton; Shift:TShiftState; X, Y:Integer);
begin
    Boolflag := TRUE;
end;

procedure TFrmSound.A2Button2MouseUp(Sender:TObject; Button:TMouseButton;
    Shift:TShiftState; X, Y:Integer);
begin
    Boolflag := false;
    Or_X := x;
end;

procedure TFrmSound.setVolume(av:integer);
var
    v               :single;
begin
    av := -av;
    if (av < 0) or (av > 5000) then
    begin
        av := 1000;
        FrmM.SoundManager.Volume := -av;
    end;
    v := 5000 - av;
    v := (v / 5000);
    v := v * (Max - Min);
    v := 30 + v;
    A2Button1.Left := trunc(v);

end;

procedure TFrmSound.setVolumeEffect(av:integer);
var
    v               :single;
begin
    av := -av;
    if (av < 0) or (av > 5000) then
    begin
        av := 1000;
        FrmM.SoundManager.VolumeEffect := -av;
    end;
    v := 5000 - av;
    v := (v / 5000);
    v := v * (max - min);
    v := 30 + v;
    A2Button2.Left := trunc(v);
end;

procedure TFrmSound.A2Button2MouseMove(Sender:TObject; Shift:TShiftState;
    X, Y:Integer);
var
    v               :integer;
begin
    if Boolflag then
    begin
        x := x + tA2Button(Sender).Left - Or_X;
        tA2Button(Sender).Left := x;
        if tA2Button(Sender).Left > max then tA2Button(Sender).Left := max;
        if tA2Button(Sender).Left < min then tA2Button(Sender).Left := min;
        v := tA2Button(Sender).Left - 30;
        v := trunc((v / (max - min)) * 5000);
        v := 5000 - v;
        FrmM.SoundManager.VolumeEffect := -v;
    end;
end;

procedure TFrmSound.A2Button1MouseDown(Sender:TObject;
    Button:TMouseButton; Shift:TShiftState; X, Y:Integer);
begin
    Boolflag := TRUE;
    Or_X := x;
end;

procedure TFrmSound.A2Button1MouseUp(Sender:TObject; Button:TMouseButton;
    Shift:TShiftState; X, Y:Integer);
begin
    Boolflag := false;
end;

procedure TFrmSound.A2Button1MouseMove(Sender:TObject; Shift:TShiftState;
    X, Y:Integer);
var
    v               :integer;
begin
    if Boolflag then
    begin
        x := x + tA2Button(Sender).Left - Or_X;
        tA2Button(Sender).Left := x;
        if tA2Button(Sender).Left > max then tA2Button(Sender).Left := max;
        if tA2Button(Sender).Left < min then tA2Button(Sender).Left := min;
        v := tA2Button(Sender).Left - 30;
        v := trunc((v / (max - min)) * 5000);
        v := 5000 - v;
        FrmM.SoundManager.Volume := -v;
    end;
end;

procedure TFrmSound.FormShow(Sender:TObject);
begin
    setVolumeEffect(frmm.SoundManager.VolumeEffect);
    setVolume(frmm.SoundManager.Volume);
end;

procedure TFrmSound.Check_OutcryClick(Sender:TObject);
begin
    chat_outcry := Check_Outcry.Checked;
end;

procedure TFrmSound.Check_GuildClick(Sender:TObject);
begin
    chat_Guild := Check_Guild.Checked;
end;

procedure TFrmSound.Check_NoticeClick(Sender:TObject);
var
    cSay            :TCSay;
    cnt             :integer;
begin
    chat_notice := Check_Notice.Checked;

    if chat_notice = false then
    begin
        cSay.rmsg := CM_SAY;
        SetWordString(cSay.rWordString, '@拒绝纸条');
        cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
        FrmLogon.SocketAddData(cnt, @csay);
    end
    else
    begin
        cSay.rmsg := CM_SAY;
        SetWordString(cSay.rWordString, '@接收纸条');
        cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
        FrmLogon.SocketAddData(cnt, @csay);
    end;
end;

procedure TFrmSound.Check_NormalClick(Sender:TObject);
begin
    chat_normal := Check_Normal.Checked;
end;

procedure TFrmSound.A2Button3Click(Sender:TObject);
var
    v               :integer;
begin
    if WinVerType = wvtNew then
    begin
        A2Button1.Left := A2Button1.Left - 5;
        if A2Button1.Left < min then A2Button1.Left := min;
        v := A2Button1.Left - 30;
        v := trunc((v / (max - min)) * 5000);
        v := 5000 - v;
        FrmM.SoundManager.Volume := -v;
    end;
end;

procedure TFrmSound.A2Button4Click(Sender:TObject);
var
    v               :integer;
begin
    if WinVerType = wvtNew then
    begin
        A2Button1.Left := A2Button1.Left + 5;
        if A2Button1.Left > max then A2Button1.Left := max;
        v := A2Button1.Left - 30;
        v := trunc((v / (max - min)) * 5000);
        v := 5000 - v;
        FrmM.SoundManager.Volume := -v;
    end;
end;

procedure TFrmSound.A2Button5Click(Sender:TObject);
var
    v               :integer;
begin
    if WinVerType = wvtNew then
    begin
        A2Button2.Left := A2Button2.Left - 5;
        if A2Button2.Left < min then A2Button2.Left := min;
        v := A2Button2.Left - 30;
        v := trunc((v / (max - min)) * 5000);
        v := 5000 - v;
        FrmM.SoundManager.VolumeEffect := -v;
    end;
end;

procedure TFrmSound.A2Button6Click(Sender:TObject);
var
    v               :integer;
begin
    if WinVerType = wvtNew then
    begin
        A2Button2.Left := A2Button2.Left + 5;
        if A2Button2.Left > max then A2Button2.Left := max;
        v := A2Button2.Left - 30;
        v := trunc((v / (max - min)) * 5000);
        v := 5000 - v;
        FrmM.SoundManager.VolumeEffect := -v;
    end;
end;

procedure TFrmSound.A2Button7Click(Sender:TObject);
begin
    Visible := false;
end;

procedure TFrmSound.Check_TeamClick(Sender:TObject);
begin
    chat_duiwu := Check_Team.Checked;
end;

procedure TFrmSound.Check_WorldClick(Sender:TObject);
begin
    chat_world := Check_World.Checked;
end;

procedure TFrmSound.FormMouseDown(Sender:TObject; Button:TMouseButton;
    Shift:TShiftState; X, Y:Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);
end;

end.

