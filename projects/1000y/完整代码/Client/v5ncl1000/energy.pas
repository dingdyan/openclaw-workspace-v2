unit energy;
//境界 管理类
interface
uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls,
    A2Img, Deftype, A2Form, DXDraws, Grids, PaintLabel;
type
    TenergyGraphicsclass = class
    private
        boStart: boolean;
        FDelayTick: integer;
        level: integer;
        FImgIndex: integer;
        FImgIndexStart: integer;
        PaintLabelmain: TPaintLabel;
        PaintLabelbottom: TPaintLabel;
        Ftext: string;
        a2image: TA2Image;
        procedure setVisible(v: boolean);
    public
        constructor Create(AOwnermain, AOwnerbottom: TComponent);
        destructor Destroy; override;
        procedure SETImage(aindex: integer);
        procedure SETlevel(alevel: integer);
        procedure update(atick: integer);
        property Visible: Boolean write setVisible;
        property text: string read ftext write ftext;
        procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
        procedure Panel1MouseLeave(Sender: TObject);
        procedure sendAdd();
        procedure senddec();
        procedure MessageProcess(var code: TWordComData);
        procedure AdxPaint(aimage: TA2Image);
        procedure BringToFront;
    end;

    Tenergyclass = class
    private

    public
        constructor Create;
        destructor Destroy; override;
    end;
var
    energyGraphicsclass: TenergyGraphicsclass;
    energyclass: Tenergyclass;

implementation
uses FAttrib, FLogOn, FMain, FBottom;                                           //GETenergyImage
///////////////////////////////////////////////////////////
//                TenergyGraphicsclass
///////////////////////////////////////////////////////////
//境界 动画管理

procedure TenergyGraphicsclass.MessageProcess(var code: TWordComData);
var
    i, n: integer;
    str: string;
begin
    i := 1;
    n := WordComData_GETbyte(code, i);
    case n of
        PowerLevel_level:
            begin
                n := WordComData_GETbyte(code, i);
                str := WordComData_GETString(code, i);
                text := str;
                if n > 0 then
                begin
                    boStart := true;
                    FrmBottom.AddChat('当前境界名称:' + text, WinRGB(88, 88, 28), 0);
                    if n >= 13 then
                        FrmBottom.AddChat('已达最高境界:' + text, WinRGB(88, 88, 28), 0);
                    GameHint.setText(integer(self), text);
                end
                else
                begin
                    boStart := false;
                    FrmBottom.AddChat('境界已关闭', WinRGB(88, 88, 28), 0);
                    GameHint.setText(integer(self), '单击开启或关闭境界');
                end;
                SETlevel(n);
            end;
    end;
end;

procedure TenergyGraphicsclass.Panel1MouseLeave(Sender: TObject);
begin
    GameHint.Close;
end;

procedure TenergyGraphicsclass.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
    if boStart then
        GameHint.setText(integer(self), text)
    else
        GameHint.setText(integer(self), '单击开启或关闭境界');

//    GameHint.pos(x + PaintLabelmain.Left, y + PaintLabelmain.Top);

end;

procedure TenergyGraphicsclass.Panel1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    case Button of
        mbLeft:
            begin
                sendAdd;
            end;
        mbRight:
            begin
                senddec;
            end;
    end;
end;

procedure TenergyGraphicsclass.sendAdd();
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_PowerLevel);
    WordComData_ADDbyte(temp, PowerLevel_ADD);
    FrmLogon.SocketAddData(temp.Size, @temp.data);
end;

procedure TenergyGraphicsclass.senddec();
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_PowerLevel);
    WordComData_ADDbyte(temp, PowerLevel_DEC);
    FrmLogon.SocketAddData(temp.Size, @temp.data);
end;

procedure TenergyGraphicsclass.BringToFront;
begin
    PaintLabelmain.BringToFront;
    PaintLabelbottom.BringToFront;
end;

constructor TenergyGraphicsclass.Create(AOwnermain, AOwnerbottom: TComponent);
begin
    PaintLabelmain := TPaintLabel.Create(AOwnermain);
    PaintLabelmain.BringToFront;
    PaintLabelmain.AutoSize := false;
    PaintLabelmain.Caption := '';
    PaintLabelmain.Width := 36;
    PaintLabelmain.Height := 36;
    PaintLabelmain.Parent := TForm(AOwnermain);
    PaintLabelmain.Top := 600 - 117 - (36 div 2);
    PaintLabelmain.Left := ((800 - 36) div 2);
    PaintLabelmain.OnMouseDown := Panel1MouseDown;
    PaintLabelmain.OnMouseMove := Panel1MouseMove;
    PaintLabelmain.OnMouseLeave := Panel1MouseLeave;

    PaintLabelbottom := TPaintLabel.Create(AOwnerbottom);
    PaintLabelbottom.BringToFront;
    PaintLabelbottom.AutoSize := false;
    PaintLabelbottom.Caption := '';
    PaintLabelbottom.Width := 36;
    PaintLabelbottom.Height := 36;
    PaintLabelbottom.Parent := TForm(AOwnerbottom);
    //PaintLabel.Top := 600 - 117 - (36 div 2);
    PaintLabelbottom.Top := -(36 div 2);
    PaintLabelbottom.Left := (800 - 36) div 2;
    PaintLabelbottom.OnMouseDown := Panel1MouseDown;
    PaintLabelbottom.OnMouseMove := Panel1MouseMove;
    PaintLabelbottom.OnMouseLeave := Panel1MouseLeave;

    a2image := nil;
    { Panel1 := TPanel.Create(AOwner);
     Panel1.Width := 36;
     Panel1.Height := 36;
     Panel1.Parent := TForm(AOwner);
     Panel1.Top := 600 - 117 - (36 div 2);
     Panel1.Left := (800 - 36) div 2;
     Panel1.OnMouseDown := Panel1MouseDown;
     }
    SETlevel(0);

    boStart := false;
end;

procedure TenergyGraphicsclass.setVisible(v: boolean);
begin
    //    Panel1.Visible := v;
end;

procedure TenergyGraphicsclass.update(atick: integer);
begin
    if (aTick - FDelayTick) > 15 then
    begin
        FDelayTick := aTick;
        if level > 0 then
        begin
            inc(FImgIndex);
            case level of
                12: if FImgIndex >= (FImgIndexStart + 10) then FImgIndex := FImgIndexStart;
                13: if FImgIndex >= (FImgIndexStart + 10) then FImgIndex := FImgIndexStart;
            else
                if FImgIndex >= (FImgIndexStart + 5) then FImgIndex := FImgIndexStart;
            end;
            SETImage(FImgIndex);
        end;
    end;
    if a2image = nil then exit;
end;

procedure TenergyGraphicsclass.AdxPaint(aimage: TA2Image);
begin
    if a2image = nil then exit;
    aimage.DrawImage(a2image,
        (800 - 36) div 2 + 3,
        600 - 117 - (36 div 2) + 2, false);
end;

procedure TenergyGraphicsclass.SETlevel(alevel: integer);
begin
    level := alevel;
    case level of
        1..11: FImgIndexStart := (level - 1) * 5;
        12:
            begin
                FImgIndexStart := 55;
                FImgIndex := FImgIndexStart;
            end;
        13:
            begin
                FImgIndexStart := 65;
                FImgIndex := FImgIndexStart;
            end;
    else
        FImgIndexStart := 75;
        FImgIndex := FImgIndexStart;
    end;
    SETImage(FImgIndex);
end;

procedure TenergyGraphicsclass.SETImage(aindex: integer);
begin
    a2image := GETenergyImage(aindex);
end;

destructor TenergyGraphicsclass.Destroy;
begin
    PaintLabelbottom.Free;
    PaintLabelmain.free;
    inherited Destroy;
end;
///////////////////////////////////////////////////////////
//                Tenergyclass
///////////////////////////////////////////////////////////
//境界 管理

constructor Tenergyclass.Create;
begin

end;

destructor Tenergyclass.Destroy;
begin

    inherited Destroy;
end;

end.

