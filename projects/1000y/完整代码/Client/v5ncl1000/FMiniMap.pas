unit FMiniMap;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, A2Form, CharCls, clmap, A2Img, DXDraws, Autil32, ProClass, Deftype,
    ExtCtrls;

type

    TFrmMiniMap = class(TForm)
        A2Form: TA2Form;
        CenterIDLabel: TA2ILabel;
        A2ILabel1: TA2ILabel;
        TimerAutoPathMove: TTimer;
        A2ILabel_b: TA2ILabel;
        TimerMove: TTimer;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure A2ILabel1Click(Sender: TObject);
        procedure TimerAutoPathMoveTimer(Sender: TObject);
        procedure A2ILabel_bMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure A2ILabel_bMouseMove(Sender: TObject; Shift: TShiftState; X,
            Y: Integer);
        procedure TimerMoveTimer(Sender: TObject);

    private
        function OutMapFile(filename: string): boolean;
    public
        ttTA2Image: TA2Image;
        //  pathTA2Image:TA2Image;
        CenterImage: TA2Image;
        fNpc: TTA2ILabelList;
        fGate: TTA2ILabelList;
        fUser: TTA2ILabelList;
        mapw, maph: integer;

        // fONE:TTA2ILabelList;
        AIPathgx, AIPathgy: integer;
        procedure SetCenterID;
        procedure SetFuser;
        procedure SetPostion;

        procedure MessageProcess(var code: TWordComData);
        procedure GETnpcList();
        procedure StopAutoMOVE();
        procedure RunAutoMOVE();
        procedure AIPathcalc(gx, gy: integer);

        function showmap(filename: string): boolean;

    end;

var
    FrmMiniMap: TFrmMiniMap;
    MapImgWidth                                                                 //  = 460;
        , MapImgHeight: integer;                                                //  = 345;

implementation

uses
    FMain, FAttrib, FBottom, FQuantity, FLogOn                                  //, cMAPGDI
   // ,ActiveX,
    , filepgkclass, cAIPath;
{$R *.DFM}

procedure TFrmMiniMap.GETnpcList();
var
    TT: TGET_cmd;
    cnt: integer;
    s: string;
begin
    s := ExtractFileName(Map.GetMapName);
    if pos('.', s) > 0 then
        s := copy(s, 1, pos('.', s) - 1);
    if showmap(format('%s.bmp', [s])) = false then
    begin
        Visible := false;
        exit;
    end;

    fNpc.ItemClear;
    fGate.ItemClear;
    fUser.ItemClear;
    TT.rmsg := CM_GET;
    TT.rKEY := GET_MapObject;
    cnt := sizeof(tt);
    FrmLogon.SocketAddData(cnt, @tt);
end;

procedure TFrmMiniMap.MessageProcess(var code: TWordComData);
var
    pckey: PTckey;
    i, x, y: integer;
    str, rdstr: string;
    pSMapobject: pTSMapObject;
    s: string;
    psNewMap: PTSNewMap;
begin
    pckey := @code.data;
    case pckey^.rmsg of
        SM_NEWMAP:
            begin
                psNewMap := @Code.data;
                A2ILabel1.Caption := (psNewMap.rMapTitle);
                mapw := Map.GetMapWidth;
                maph := Map.GetMapHeight;
            end;
        SM_MapObject:
            begin
                pSMapobject := @Code.data;
                x := trunc(MapImgWidth * (pSMapobject.rx / mapw));
                y := trunc(MapImgHeight * (pSMapobject.ry / maph));
                str := GetwordString(pSMapobject^.rWordstring);
                case pSMapobject.rtype of
                    MapobjectNpc:
                        fNpc.ItemAdd(x, y, pSMapobject.rx, pSMapobject.ry, 4, 4, '', 'NPC：' + str);
                    MapobjectGate:
                        fGate.ItemAdd(x, y, pSMapobject.rx, pSMapobject.ry, 4, 4, '', '传送：' + str);
                    MapobjectUserProcession:
                        fUser.ItemAdd(x, y, pSMapobject.rx, pSMapobject.ry, 4, 4, '', '队友：' + str);
                    //  MapobjectONE:fONE.ItemAdd(pSMapobject.rx, pSMapobject.ry, 4, 4, '', str);
                else exit;
                end;
                CenterIdLabel.A2SendToBack;
            end;
    end;

end;

procedure TFrmMiniMap.FormCreate(Sender: TObject);
begin
    FrmM.AddA2Form(Self, A2Form);
    //Parent := FrmM;
    Top := 0;
    Left := 0;
    CenterImage := TA2Image.Create(4, 4, 0, 0);
    CenterImage.Clear(255);
    CenterIdLabel.A2Image := CenterImage;

    fNpc := TTA2ILabelList.Create(A2Form, self, clred);
    fGate := TTA2ILabelList.Create(A2Form, self, $0AB10A);
    fUser := TTA2ILabelList.Create(A2Form, self, clNavy);
    //fONE := TTA2ILabelList.Create(A2Form, self, clLime);
    //SearchIDLabel.Font.Color := (clOlive);
    //SearchIDLabel.Caption := '';

    A2ILabel1.Font.Color := (clOlive);
    A2ILabel1.Caption := '';

    TimerMove.Enabled := true;
end;

{
function TFrmMiniMap.showmap_file(filename: string): boolean;
var
    tt: TA2Image;
    zoom, fw, fh: integer;
    Mapmini: tmapmini;
    TBitmap1: TBitmap;
    ttStream: TMemoryStream;
begin
    result := false;
    // A2Form.ImageSurface := nil;
    if ttTA2Image <> nil then
    begin
        ttTA2Image.Free;
        ttTA2Image := nil;
    end;

    if not FileExists(filename) then
    begin
        Mapmini := tMapmini.Create;
        try
            Mapmini.MapLoadFilePgk(map.GetMapName);
            case Mapmini.MapWidth * 32 of
                0..5000: zoom := 1;
                5001..10000: zoom := 2;
            else zoom := 4;
            end;

            tt := TA2Image.Create(Mapmini.MapWidth * 32 div zoom, Mapmini.MapHeight * 24 div zoom, 0, 0);
            try
                tt.Clear(winrgb(1, 1, 1));
                Mapmini.miniMAP(0, 0, zoom, tt);
                // tt.SaveToFile(filename + '1.bmp');
                ttStream := TMemoryStream.Create;
                try
                    tt.SaveToStream(ttStream);
                    TBitmap1 := TBitmap.Create;
                    try

                        fh := Mapmini.MapHeight * 24 div zoom;
                        if fh > 470 then
                        begin
                            fh := 470;
                            zoom := Mapmini.MapHeight * 24 div fh;
                        end;

                        fw := Mapmini.MapWidth * 32 div zoom;
                        if fw > 780 then
                        begin
                            fw := 780;
                            zoom := Mapmini.MapWidth * 32 div fw;
                            fh := Mapmini.MapHeight * 24 div zoom;
                        end;
                        // if Mapmini.MapWidth * 32 div zoom > A2ILabel_b.Width then fw := A2ILabel_b.Width;

                        TBitmap1.Width := fw;
                        TBitmap1.Height := fh;
                        TBitmap1.PixelFormat := pf16bit;
                        ToDrawZoomStream(TBitmap1.Canvas.Handle, ttStream, TBitmap1.Width, TBitmap1.Height);
                        TBitmap1.SaveToFile(filename);

                    finally
                        TBitmap1.Free;
                    end;
                finally
                    ttStream.Free;
                end;

            finally
                tt.Free;
            end;

        finally
            Mapmini.Free;
        end;

    end;

    if FileExists(filename) then
    begin
        ttTA2Image := TA2Image.Create(4, 4, 0, 0);
        // pgkmap.getBmp(filename, ttTA2Image);
        ttTA2Image.LoadFromFile(filename);
        A2ILabel_b.A2Image := ttTA2Image;
        A2ILabel_b.Width := ttTA2Image.Width;
        A2ILabel_b.Height := ttTA2Image.Height;
        // A2ILabel_b.Picture.LoadFromFile(filename);
    end else exit;
    MapImgWidth := A2ILabel_b.Width;
    if MapImgWidth = 0 then MapImgWidth := A2ILabel_b.Width;
    MapImgHeight := A2ILabel_b.Height;
    if MapImgHeight = 0 then MapImgHeight := A2ILabel_b.Height;
    self.Width := MapImgWidth;
    self.Height := MapImgHeight;
    //  A2Form.Width := MapImgWidth;
    //  A2Form.Height := MapImgHeight;
    A2ILabel_b.Width := MapImgWidth;
    A2ILabel_b.Height := MapImgHeight;
    //    A2ILabel_path.Width := A2ILabel_b.Width;
      //  A2ILabel_path.Height := A2ILabel_b.Height;
    FrmM.move_win_form_Align(Self, mwfCenter);

    // SearchIdLabel.Left := Self.ClientWidth - SearchIdLabel.Width - 15;
    // SearchIdLabel.Top := self.ClientHeight - SearchIdLabel.Height - 15;
    SetCenterID;
    result := true;
end;
}

function TFrmMiniMap.OutMapFile(filename: string): boolean;
var
    tt: TA2Image;
    zoom, fw, fh: integer;
    Mapmini: tmapmini;
    TBitmap1: TBitmap;
    ttStream: TMemoryStream;
begin
    result := false;
   { if not FileExists(filename) then
    begin
        Mapmini := tMapmini.Create;
        try
            Mapmini.MapLoadFile(map.GetMapName);
            case Mapmini.MapWidth * 32 of
                0..5000: zoom := 1;
                5001..10000: zoom := 2;
            else zoom := 4;
            end;

            tt := TA2Image.Create(Mapmini.MapWidth * 32 div zoom, Mapmini.MapHeight * 24 div zoom, 0, 0);
            try
                tt.Clear(winrgb(1, 1, 1));
                Mapmini.miniMAP(0, 0, zoom, tt);
                // tt.SaveToFile(filename + '1.bmp');
                ttStream := TMemoryStream.Create;
                try
                    tt.SaveToStream(ttStream);
                    TBitmap1 := TBitmap.Create;
                    try

                        fh := Mapmini.MapHeight * 24 div zoom;
                        if fh > 470 then
                        begin
                            fh := 470;
                            zoom := Mapmini.MapHeight * 24 div fh;
                        end;

                        fw := Mapmini.MapWidth * 32 div zoom;
                        if fw > 780 then
                        begin
                            fw := 780;
                            zoom := Mapmini.MapWidth * 32 div fw;
                            fh := Mapmini.MapHeight * 24 div zoom;
                        end;
                        // if Mapmini.MapWidth * 32 div zoom > A2ILabel_b.Width then fw := A2ILabel_b.Width;

                        TBitmap1.Width := fw;
                        TBitmap1.Height := fh;
                        TBitmap1.PixelFormat := pf16bit;
                        ToDrawZoomStream(TBitmap1.Canvas.Handle, ttStream, TBitmap1.Width, TBitmap1.Height);
                        TBitmap1.SaveToFile(filename);

                    finally
                        TBitmap1.Free;
                    end;
                finally
                    ttStream.Free;
                end;

            finally
                tt.Free;
            end;

        finally
            Mapmini.Free;
        end;

    end;
    }
    result := true;
end;

function TFrmMiniMap.showmap(filename: string): boolean;
var
    tt: TA2Image;
    zoom, fw, fh: integer;
    Mapmini: tmapmini;
    TBitmap1: TBitmap;
    ttStream: TMemoryStream;
begin
    result := false;
    if ttTA2Image <> nil then
    begin
        ttTA2Image.Free;
        ttTA2Image := nil;
    end;

    if pgkbmp.isfile(filename) then
    begin
        ttTA2Image := TA2Image.Create(4, 4, 0, 0);
        pgkbmp.getBmp(filename, ttTA2Image);

    end else
    begin
        if not FileExists(filename) then
        begin
            if OutMapFile(filename) = false then exit;
        end;
        if FileExists(filename) then
        begin
            ttTA2Image := TA2Image.Create(4, 4, 0, 0);
            ttTA2Image.LoadFromFile(filename);
        end else exit;

    end;
    MapImgWidth := ttTA2Image.Width;
    if MapImgWidth = 0 then MapImgWidth := 470;
    MapImgHeight := ttTA2Image.Height;
    if MapImgHeight = 0 then MapImgHeight := 780;

    Width := MapImgWidth;
    Height := MapImgHeight;
    A2ILabel_b.Width := MapImgWidth;
    A2ILabel_b.Height := MapImgHeight;
    FrmM.move_win_form_Align(Self, mwfCenter);
    A2ILabel_b.A2Image := ttTA2Image;

    result := true;
end;

procedure TFrmMiniMap.FormDestroy(Sender: TObject);
begin
    fNpc.Free;
    fGate.Free;
    fUser.Free;
    //    fONE.Free;
    CenterImage.Free;
    if ttTA2Image <> nil then ttTA2Image.Free;
end;

procedure TFrmMiniMap.SetFuser;
var
    x, y, i: integer;
    t: TA2ILabel;
begin
    for i := 0 to fUser.data.Count - 1 do
    begin
        t := fUser.ItemGet(i);
        x := trunc(MapImgWidth * (CharPosX / mapw));
        y := trunc(MapImgHeight * (CharPosy / maph));
        CenterIdLabel.Hint := CharCenterName;

        CenterIdLabel.Left := x - (CenterIdLabel.Width div 2);
        CenterIdLabel.Top := y - (CenterIdLabel.Height div 2);
    end;

end;

procedure TFrmMiniMap.SetCenterID;
var
    x, y: integer;
begin

    x := trunc(MapImgWidth * (CharPosX / mapw));
    y := trunc(MapImgHeight * (CharPosy / maph));
    CenterIdLabel.Hint := CharCenterName;

    CenterIdLabel.Left := x - (CenterIdLabel.Width div 2);
    CenterIdLabel.Top := y - (CenterIdLabel.Height div 2);
end;

procedure TFrmMiniMap.SetPostion;
begin

    if FrmAttrib.Visible then
    begin
        Top := ((600 - FrmBottom.Height) div 2) - (Height div 2);
        Left := ((800 - FrmAttrib.Width) div 2) - (Width div 2);
    end else
    begin
        Top := ((600 - FrmBottom.Height) div 2) - (Height div 2);
        Left := (800 div 2) - (Width div 2);
    end;
end;

procedure TFrmMiniMap.A2ILabel1Click(Sender: TObject);
begin
    CenterIdLabel.A2SendToBack;
end;

procedure TFrmMiniMap.AIPathcalc(gx, gy: integer);
var
    i, cx, cy, fx, fy: integer;
    j: dword;
begin
    pathlist.Clear;
    AIPathgx := gx;
    AIPathgy := gy;
    i := 2;
    while not cMaper.isMoveable(gx, gy) do
    begin
        inc(i);
        gx := gx + random(i);
        gy := gy + random(i);
        if i > 7 then Break;
    end;
    if not cMaper.isMoveable(gx, gy) then
    begin
        FrmBottom.AddChat(format('目标[%D,%D]不可到达,重新定位。', [gx, gy]), ColorSysToDxColor(clred), 0);
        exit;
    end;
    //   pathTA2Image.Clear(0);
   //    temppathtest := pathTA2Image;
    cx := CharPosX;
    cy := CharPosy;
    cSearchPathClass.GotoPath(cx, cy, gx, gy, fx, fy);
    j := abs(gy - fy) + abs(gx - fx);
    if j = 0 then
    begin
        RunAutoMOVE;
        FrmBottom.AddChat(format('目标[%D,%D]开始自动走路。', [gx, gy]), ColorSysToDxColor(clLime), 0);
    end else
    begin
        FrmBottom.AddChat(format('目标[%D,%D]太远不能到达。', [gx, gy]), ColorSysToDxColor(clred), 0);
    end;
end;

procedure TFrmMiniMap.StopAutoMOVE();
begin
    if not TimerAutoPathMove.Enabled then exit;
    FrmBottom.AddChat('自动走路已经结束。', ColorSysToDxColor(clred), 0);
    pathlist.Clear;
    TimerAutoPathMove.Enabled := false;
end;

procedure TFrmMiniMap.RunAutoMOVE();
begin
    TimerAutoPathMove.Enabled := true;
end;

procedure TFrmMiniMap.TimerAutoPathMoveTimer(Sender: TObject);
var
    P: pTpathxy;
    j: integer;
begin
    //    if sm_moveOk = false then exit;
    if MapAutoPath then
    begin
        if ((CharPosX = MapAutoPathx) and (MapAutoPathy = CharPosy)) then
            MapAutoPath := false;
    end;
    if MapAutoPath then exit;
    if pathlist.Fdatalist.Count <= 0 then
    begin
        StopAutoMOVE;
        exit;
    end;
    p := pathlist.getEnd;
    if p = nil then
    begin
        StopAutoMOVE;
        exit;
    end;

    if ((CharPosX = p.rx) and (p.ry = CharPosy)) then
    begin
        pathlist.delEnd;
    end else
    begin
        FrmM.map_move(p.rx, p.ry);
    end;
end;

procedure TFrmMiniMap.A2ILabel_bMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    gx, gy: integer;
begin
    FrmM.SetA2Form(Self, A2form);
    //
    if Button = mbLeft then
    begin
        gx := trunc((x / A2ILabel_b.Width) * Map.Width);
        gy := trunc((y / A2ILabel_b.Height) * Map.Height);

        AIPathgx := gx;
        AIPathgy := gy;
        AIPathcalc(gx, gy);
    end;

end;

procedure TFrmMiniMap.A2ILabel_bMouseMove(Sender: TObject;
    Shift: TShiftState; X, Y: Integer);
var
    gx, gy: integer;
begin
    gx := trunc((x / A2ILabel_b.Width) * Map.Width);
    gy := trunc((y / A2ILabel_b.Height) * Map.Height);
    GameHint.setText(integer(Sender), format('坐标[%D,%D]', [gx, gy]));
    //  SearchIDLabel.Caption := format('坐标[%D,%D]', [gx, gy]);
end;

procedure TFrmMiniMap.TimerMoveTimer(Sender: TObject);
begin
    //CenterIdLabel.A2Image := CenterImage;
end;

end.

