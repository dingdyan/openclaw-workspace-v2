unit FEnergy;
//境界 管理类
//2009.7.3增加
interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls,
    A2Img, Deftype, A2Form, DXDraws, Grids, PaintLabel, StdCtrls;

type
    TFrmEnergy = class(TForm)
        A2Form: TA2Form;
        A2ILabel1: TA2ILabel;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure A2ILabel1MouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure A2ILabel1MouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
    private
        { Private declarations }

        FDelayTick: integer;
        level: integer;
        FImgIndex: integer;
        FImgIndexStart: integer;
        Ftext: string;
        a2image: TA2Image;
        boStart: Boolean;
    public
        { Public declarations }
        procedure SETImage(aindex: integer);
        procedure SETlevel(alevel: integer);
        procedure update(atick: integer);
        property text: string read ftext write ftext;
        procedure sendAdd();
        procedure senddec();
        procedure MessageProcess(var code: TWordComData);
    end;

var
    FrmEnergy: TFrmEnergy;

implementation
uses FMain, FAttrib, FLogOn, Fbottom;
{$R *.dfm}

procedure TFrmEnergy.FormCreate(Sender: TObject);
begin
    //
    FrmM.AddA2Form(Self, A2form);
//    A2Form.FA2Hint.Ftype := hstTransparent;
    left := 385;
    top := 467;
    Width := 36;
    Height := 36;
    A2ILabel1.Width := 36;
    A2ILabel1.Height := 36;
    A2ILabel1.Top := 0;
    A2ILabel1.Left := 0;
    SETlevel(0);
    boStart := false;
end;

procedure TFrmEnergy.FormDestroy(Sender: TObject);
begin
    //
    //inherited Destroy;
end;

procedure TFrmEnergy.MessageProcess(var code: TWordComData);
var
    i, n: integer;
    str: string;
    temp1, temp2: integer;
begin
    i := 1;
    n := WordComData_GETbyte(code, i);
    case n of
        PowerLevel_level:
            begin
                n := WordComData_GETbyte(code, i);
                //temp1 := WordComData_GETword(code, i);
                //temp2 := WordComData_GETword(code, i);
                str := WordComData_GETString(code, i);
                text := str;
                if n > 0 then
                begin
                    boStart := true;
                    FrmBottom.AddChat('当前境界名称:' + text, WinRGB(88, 88, 28), 0);
                    if n >= 13 then
                        FrmBottom.AddChat('已达最高境界:' + text, WinRGB(88, 88, 28), 0);
                end
                else
                begin
                    boStart := false;
                    FrmBottom.AddChat('境界已关闭', WinRGB(88, 88, 28), 0);
                end;
                SETlevel(n);
            end;
    end;

end;

procedure TFrmEnergy.sendAdd;
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_PowerLevel);
    WordComData_ADDbyte(temp, PowerLevel_ADD);
    FrmLogon.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmEnergy.senddec;
var
    temp: TWordComData;
begin
    temp.Size := 0;
    WordComData_ADDbyte(temp, CM_PowerLevel);
    WordComData_ADDbyte(temp, PowerLevel_DEC);
    FrmLogon.SocketAddData(temp.Size, @temp.data);
end;

procedure TFrmEnergy.SETlevel(alevel: integer);
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

procedure TFrmEnergy.SETImage(aindex: integer);
begin
    a2image := GETenergyImage(aindex);
end;

procedure TFrmEnergy.update(atick: integer);
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
    A2ILabel1.A2Image := a2image;
end;

procedure TFrmEnergy.A2ILabel1MouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
begin
    FrmM.SetA2Form(Self, A2Form);
    if boStart then
        GameHint.setText(integer(Sender), text)
    else
        GameHint.setText(integer(Sender), '单击开启或关闭境界');
//    A2Form.FA2Hint.FVisible := true;

end;

procedure TFrmEnergy.A2ILabel1MouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

end.

