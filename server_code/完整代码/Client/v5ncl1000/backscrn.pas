unit BackScrn;

interface

uses
    Windows, Classes, SysUtils, Graphics, uAnsTick,
    Bmputil, AUtil32, A2Img, DefType, cltype, DXDraws, DXClass, DIB, DXTexImg, DirectX;

type
    TRainData = record
        rsx, rsy: integer;
        rx, ry: integer;
        rimage: integer;
        rOverray: integer;
        rspeed: integer;
        rXpos: integer;
    end;
    PTRainData = ^TRainData;

    TBackScreen = class
    private
        FRainning: Boolean;
        RainImageLib: TA2ImageLib;
        SnowImageLib: TA2ImageLib;

        RainList: TList;
        RainSpeed, RainCount, RainOverray: integer;
        RainTick: integer;
        Raintype: byte;



    public
        Cx, Cy: Integer;                                                        //地图 图象坐标 中心点  *32 和 *24
        // BackScreen.SetCenter(psNewMap^.rx * UNITX, psNewMap^.ry * UNITY);
        SWidth, SHeight: integer;                                               //屏幕
        Back: TA2Image;                                                         //背景 缓冲区
        constructor Create;
        destructor Destroy; override;
        procedure Clear;
        procedure SetCenter(x, y: integer);

        procedure DrawImage(AnsImage: TA2Image; x, y: Integer; aTrans: Boolean);
        procedure DrawImageGreenConvert(AnsImage: TA2Image; x, y: Integer; acol, defaultadd: word);
        procedure DrawImageKeyColor(AnsImage: TA2Image; x, y: Integer);
        procedure DrawImageOveray(AnsImage: TA2Image; x, y: Integer; Weight: integer);

        procedure DrawRefractive(AnsImage: TA2Image; x, y, Refracrange, overValue: Integer); // ankudo 010118

        procedure DrawImageAdd(AnsImage: TA2Image; x, y: Integer);

        procedure DrawStructed(x, y, ImgHeight, aper: integer);
        procedure DrawName(Canvas: TCanvas; x, y: integer; abubble: string; aColor: Integer);
        procedure DrawCanvas(Canvas: TCanvas; X, Y: Integer);

        function GetBubble(var BubbleList: TStringList; SayString: string): Boolean;
        procedure DrawBubble(Canvas: TCanvas; x, y: integer; abubbleList: TStringList);
        procedure DrawRollMsg(x, y, fx: integer; acolor: word; atext: string);

        procedure UpdateRain;
        //   procedure  SetRainState (aRainning: Boolean; aspeed, aCount, aover, aTick: integer);
        procedure CenterchangeIDPos(x, y: integer);
        procedure SetRainState(aRainning: Boolean; aspeed, aCount, aover, aTick: integer; araintype: byte);
        procedure ConvertDark;
        procedure Resize(aw, ah: integer);
        property Rainning: Boolean read FRainning;
        function Draw_Surface(aSurface: TDirectDrawSurface): boolean;
        procedure DrawImage_(aDrawType: TDrawType; at1, at2, at3: single; col: word; ptable: pword; AnsImage: TA2Image; x, y: Integer);
    end;

var
    BackScreen: TBackScreen;                                                    //背景 缓冲区

    snowxPosTable: array[0..40 - 1] of integer = (
        0, 0, 0, 0, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4,
        0, 0, -0, -0, -1, -1, -1, -1, -2, -2, -3, -3, -3, -4, -4, -4, -4, -4, -4, -4
        {
         0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
         0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, -1, -1, -1, -1, -1, 0
         }
        );
    snowidx: byte;

implementation

uses filepgkclass, clmap, Charcls;

{$O+}

/////////////////////////////////
//          TBackScreen
/////////////////////////////////

constructor TBackScreen.Create;
begin
    RainImageLib := TA2ImageLib.Create;
    //  RainImageLib.LoadFromFile('.\ect\rain.atz');
    pgkect.getImageLib('rain.atz', RainImageLib);

    SnowImageLib := TA2ImageLib.Create;
    //  SnowImageLib.LoadFromFile('.\ect\snow.atz');
    pgkect.getImageLib('snow.atz', SnowImageLib);

    snowidx := 0;
    RainList := TList.Create;
    Raintype := RAINTYPE_RAIN;

    Back := TA2Image.Create(800, 600, 0, 0);

    SWidth := 800;                                                              //800 - 192;
    // SHeight := 363;
    SHeight := 600 - 117;
    Cx := SWidth div 2;
    Cy := SHeight div 2;

    FRainning := FALSE;
    RainSpeed := 15;
    RainCount := 200;
    RainOverray := 50;
end;

destructor TBackScreen.Destroy;
var
    i: integer;
begin
    for i := 0 to RainList.Count - 1 do dispose(RainList[i]);
    RainList.Free;
    RainImageLib.Free;
    SnowImageLib.Free;

    Back.free;
    inherited destroy;
end;

procedure TBackScreen.Resize(aw, ah: integer);
var
    tempBack: TA2Image;
begin
    tempBack := TA2Image.Create(Back.Width, Back.Height, 0, 0);
    try
        tempBack.DrawImage(Back, 0, 0, false);
        tempBack.Resize(aw, ah);
        Back.DrawImage(tempBack, 0, 0, false);
    finally
        tempBack.Free;
    end;

end;

                {for i := 0 to Back.Height * Back.Width - 1 do
                begin

                    sb := spb^ and $1F;
                    sg := spb^ and $3E0;
                    sr := spb^ and $7C00;

                    ddpd^ := (sb shl 3) or (sg shl 6) or (sr shl 9);
                    Inc(spb);
                    inc(ddpd);

                end;  }
                {
                for i := 0 to Back.Height * Back.Width - 1 do
                begin
                    ddpw^ := (spb^ and $1F) or ((spb^ and $7FE0) shl 1);
                    Inc(spb);
                    inc(ddpw);
                end;
               // move(spb^, ddpd^, Back.Height * Back.Width * 2);
                }

function TBackScreen.Draw_Surface(aSurface: TDirectDrawSurface): boolean;
var
    spb: PTAns2Color;
    ddpd: pdword;
    ddpw: pword;
    i, j: integer;
    aSurfaceDesc: TDDSurfaceDesc;
const
    C_R15: int64 = $7C007C007C007C00;
    C_G15: int64 = $03E003E003E003E0;
    C_B15: int64 = $001F001F001F001F;
    C_RG15: int64 = $7FE07FE07FE07FE0;
begin
    result := false;
    if Back = nil then exit;
    aSurface.Lock(PRect(nil)^, aSurfaceDesc);
    spb := Back.Bits;
    case aSurfaceDesc.ddpfPixelFormat.dwRGBBitCount of
        32:
            begin
                ddpd := aSurfaceDesc.lpSurface;
                i := aSurfaceDesc.lPitch;
                asm
//装载

push edi
push esi
push eax
push ebx

mov ebx,600
mov esi,spb

@Height_:
  mov eax,ddpd
  mov edi,eax
  add eax,i
  mov ddpd,eax

  mov eax,200
  @Width_:

  movq mm0,[esi]
  movq mm1,mm0
  movq mm2,mm0

//B  5转8
  pand mm0,C_B15
  psllw mm0,3
//G
  pand mm1,C_G15
  psllw mm1,6
//R   在本位
  pand mm2,C_R15
  psrlw mm2,7

//合并BG
  por mm0,mm1

//COPY  1
  movq mm1,mm0
  punpckhwd mm1,mm2
  punpcklwd mm0,mm2

 	movq [edi],mm0
 	movq [edi+8],mm1
  add edi,16
  add esi,8

  dec eax
  jnz @Width_     //知道数量

dec ebx
jnz @Height_

emms
pop ebx
pop eax
pop esi
pop edi
                end;
            end;
        16:
            begin
                ddpw := aSurfaceDesc.lpSurface;
                i := aSurfaceDesc.lPitch;
                asm
//装载
push edi
push esi
push eax
push ebx

mov esi,spb

mov ebx,600

@Height_:
  mov eax,ddpw
  mov edi,eax
  add eax,i
  mov ddpw,eax

  mov eax,200
  @Width_:
  movq mm0,[esi]
  movq mm1,mm0
  movq mm2,mm0

//B  rgb555转 RGB565
  pand mm0,C_B15
//RG
  pand mm1,C_RG15
  psllw mm1,1

//合并BG
  por mm0,mm1
 	movq [edi],mm0
  add edi,8
  add esi,8
  dec eax
  jnz @Width_     //知道数量

dec ebx
jnz @Height_
emms

pop ebx
pop eax
pop esi
pop edi
                end;

            end;
    else
        begin
            aSurface.UnLock;
            exit;
        end;
    end;
    aSurface.UnLock;
    result := true;
end;

procedure TBackScreen.DrawCanvas(Canvas: TCanvas; X, Y: Integer);
begin
    if Back = nil then exit;
    A2DrawImage(Canvas, 0, 0, Back);
end;
// BackScreen.SetCenter(psNewMap^.rx * UNITX, psNewMap^.ry * UNITY);

procedure TBackScreen.SetCenter(x, y: integer);
begin
    Cx := x;
    Cy := y;
end;
//画血条

procedure TBackScreen.DrawStructed(x, y, ImgHeight, aper: integer);
var
    xx, yy: integer;
begin
    xx := SWidth div 2 + x - Cx - 10;
    //   yy := SHeight div 2 + y-Cy - 36;
    yy := SHeight div 2 + y - Cy - ImgHeight;

    Back.hLine(xx, yy, 20, WinRGB(5, 5, 5));
    Back.hLine(xx, yy + 1, 20, WinRGB(5, 5, 5));
    Back.hLine(xx, yy + 1, 20, WinRGB(5, 5, 5));

    Back.hLine(xx, yy, aper div 5, WinRGB(22, 5, 5));
    Back.hLine(xx, yy + 1, aper div 5, WinRGB(22, 5, 5));
    Back.hLine(xx, yy + 1, aper div 5, WinRGB(22, 5, 5));
end;

procedure TBackScreen.DrawImageGreenConvert(AnsImage: TA2Image; x, y: Integer; acol, defaultadd: word);
var
    maxX, maxY: integer;
begin
    {
       if Ansimage <> nil then
          Back.DrawImageGreenConvert (AnsImage, SWidth div 2 + x-Cx+AnsImage.px, SHeight div 2 + y-Cy+AnsImage.py, acol, defaultadd);
    }
    if Ansimage <> nil then
    begin
        maxX := SWidth div 2 + x - Cx + AnsImage.px;
        maxY := SHeight div 2 + y - Cy + AnsImage.py;
        if (maxX > SWidth) and (maxY > SHeight) then exit;
        if (maxX < -AnsImage.Width) and (maxY < -AnsImage.Height) then exit;
        Back.DrawImageGreenConvert(AnsImage, maxX, maxY, acol, defaultadd);
    end;
end;

procedure TBackScreen.DrawImage_(aDrawType: TDrawType; at1, at2, at3: single; col: word; ptable: pword; AnsImage: TA2Image; x, y: Integer);
begin
    if Ansimage <> nil then
        Back.DrawImage_(aDrawType, at1, at2, at3, col, ptable, AnsImage, SWidth div 2 + x - Cx + AnsImage.px, SHeight div 2 + y - Cy + AnsImage.py);

end;

//透明 色替换成阴影

procedure TBackScreen.DrawImageKeyColor(AnsImage: TA2Image; x, y: Integer);
//var
  //  maxX, maxY: integer;
begin

    if Ansimage <> nil then
        Back.DrawImageKeyColor(AnsImage, SWidth div 2 + x - Cx + AnsImage.px, SHeight div 2 + y - Cy + AnsImage.py, 31, @Darkentbl);

   { if Ansimage <> nil then
    begin
        maxX := SWidth div 2 + x - Cx + Ansimage.px;
        maxY := SHeight div 2 + y - Cy + Ansimage.py;
        if (maxX > SWidth) and (maxY > SHeight) then exit;
        if (maxX < -Ansimage.Width) and (maxY < -Ansimage.Height) then exit;
        Back.DrawImageKeyColor(Ansimage, maxX, maxY, 31, @Darkentbl);
    end; }
end;
//折射率

procedure TBackScreen.DrawRefractive(AnsImage: TA2Image; x, y, Refracrange, overValue: Integer); // ankudo 010118
//var
  //  maxX, maxY: integer;
begin

    if Ansimage <> nil then
        Back.DrawRefractive(AnsImage, SWidth div 2 + x - Cx + AnsImage.px, SHeight div 2 + y - Cy + AnsImage.py, Refracrange, overValue);

   { if Ansimage <> nil then
    begin
        //转换 到屏幕坐标
        maxX := SWidth div 2 + x - Cx + Ansimage.px;
        maxY := SHeight div 2 + y - Cy + Ansimage.py;
        if (maxX > SWidth) and (maxY > SHeight) then exit;
        if (maxX < -Ansimage.Width) and (maxY < -Ansimage.Height) then exit;
        Back.DrawRefractive(Ansimage, maxX, maxY, Refracrange, overValue);
    end;}
end;

procedure TBackScreen.DrawImage(AnsImage: TA2Image; x, y: Integer; aTrans: Boolean);
//var
   // maxX, maxY: integer;
begin

    if Ansimage <> nil then
        Back.DrawImage(AnsImage, SWidth div 2 + x - Cx + AnsImage.px, SHeight div 2 + y - Cy + AnsImage.py, aTrans);

    //X，Y 目标地图图像 中心点
    //SWidth div 2 屏幕中心点
    //CX 地图图像中心点
    //x - Cx= 屏幕坐标
   { if Ansimage <> nil then
    begin
        maxX := SWidth div 2 + x - Cx + Ansimage.px;
        maxY := SHeight div 2 + y - Cy + Ansimage.py;
        if (maxX > SWidth) and (maxY > SHeight) then exit;
        if (maxX < -Ansimage.Width) and (maxY < -Ansimage.Height) then exit;
        Back.DrawImage(Ansimage, maxX, maxY, aTrans);
    end;}
end;

procedure TBackScreen.DrawImageOveray(AnsImage: TA2Image; x, y: Integer; Weight: integer);
//var
  //  maxX, maxY: integer;
begin

    if Ansimage <> nil then
        Back.DrawImageOveray(AnsImage, SWidth div 2 + x - Cx + AnsImage.px, SHeight div 2 + y - Cy + AnsImage.py, weight);

    {if Ansimage <> nil then
    begin
        //转换 坐标
        maxX := SWidth div 2 + x - Cx + Ansimage.px;
        maxY := SHeight div 2 + y - Cy + Ansimage.py;
        if (maxX > SWidth) and (maxY > SHeight) then exit;
        if (maxX < -Ansimage.Width) and (maxY < -Ansimage.Height) then exit;
        Back.DrawImageOveray(Ansimage, maxX, maxY, weight);
    end;}
end;

procedure TBackScreen.DrawImageAdd(AnsImage: TA2Image; x, y: Integer);
begin
    if Ansimage <> nil then
        Back.DrawImageAdd(AnsImage, SWidth div 2 + x - Cx + AnsImage.px, SHeight div 2 + y - Cy + AnsImage.py);
end;

procedure TBackScreen.Clear;
begin
    Back.Clear(0);
end;

procedure TBackScreen.DrawName(Canvas: TCanvas; x, y: integer; abubble: string; aColor: Integer);
var
    str, aname: string;
    xx, yy, len: integer;
begin
    str := abubble;
    str := GetValidStr3(str, aname, ',');

    len := ATextWidth(aname);
    xx := SWidth div 2 + x - Cx - len div 2;
    yy := SHeight div 2 + y - Cy - 16;

    ATextOut(Back, xx + 1, yy + 1, WinRGB(3, 3, 3), aname);
    ATextOut(Back, xx, yy, aColor, aname);

    str := GetValidStr3(str, aname, ',');

    if aname <> '' then
    begin
        len := ATextWidth(aname);
        xx := SWidth div 2 + x - Cx - len div 2;
        yy := SHeight div 2 + y - Cy - 16 - 16;

        ATextOut(Back, xx + 1, yy + 1, WinRGB(2, 2, 2), aname);

        ATextOut(Back, xx, yy, WinRGB(31, 31, 31), aname);
    end;
end;

function TBackScreen.GetBubble(var BubbleList: TStringList; SayString: string): Boolean;
    function GetHanString(var str: string; n: integer): string;
    var
        i: integer;
        hanflag: Boolean;
    begin
        hanflag := FALSE;
        Result := '';
        for i := 1 to n do
        begin
            if hanflag then
            begin
                Result := Result + str[i];
                hanflag := FALSE;
            end else
            begin
                if byte(str[i]) > 127 then hanflag := TRUE;
                Result := Result + str[i];
            end;
        end;
        if hanflag then Result := Result + str[n + 1];
        str := Copy(str, Length(Result) + 1, Length(str) - Length(Result));
    end;
var
    i: integer;
    // Can             :TCanvas;
    str, rdstr: string;
begin
    BubbleList.Clear;
    //  Can := A2GetCanvas;

    for i := 0 to 10 do
    begin
        str := '';
        while TRUE do
        begin
            SayString := GetValidStr3(SayString, rdstr, ' ');
            str := str + rdstr;
            str := str + ' ';

            if ATextWidth(str) > 36 * 8 then
            begin
                rdstr := str;
                //str := GetHanString(rdstr, 20);
                str := GetHanString(rdstr, 36);
                SayString := rdstr + SayString;
                break;
            end;
            if SayString = '' then break;

            if ATextWidth(str) > 80 then break;
        end;
        BubbleList.Add(str);
        if BubbleList.Count = 3 then break;
        if sayString = '' then break;
    end;
    Result := TRUE;
end;

const
    XDrawBubbleMargin = 8;
    YDrawBubbleMargin = 6;

procedure TBackScreen.DrawRollMsg(x, y, fx: integer; acolor: word; atext: string);
var
    i, imgX, imgY, yy: integer;
    FontBackImg: TA2Image;
begin
    imgY := ATextHeight(atext);
    imgX := SWidth - x * 2;

    FontBackImg := TA2Image.Create(imgX + 2, imgY + 2, 0, 0);
    FontBackimg.Clear(31);
    // xx := 2 div 2 + 3;
    yy := 2 div 2;
    begin
        ATextOut(FontBackimg, fx + 1, yy + 1, WinRGB(3, 3, 3), atext);
    end;

    begin
        ATextOut(FontBackimg, fx, yy, acolor, atext);
    end;
    back.DrawImageKeyColor(FontBackimg, x, y, 31, @bubbletbl);
    FontBackImg.Free;
end;

procedure TBackScreen.DrawBubble(Canvas: TCanvas; x, y: integer; abubbleList: TStringList);
var
    i, imgX, imgY, xx, yy: integer;
    FontBackImg: TA2Image;
begin
    GetMaxTextWH(imgX, imgY, abubbleList);
    imgY := (imgY * abubbleList.Count) + (abubbleList.Count - 1);

    FontBackImg := TA2Image.Create(imgX + XDrawBubbleMargin, imgY + YDrawBubbleMargin, 0, 0);
    FontBackimg.Clear(31);
    xx := XDrawBubbleMargin div 2 + 3;
    yy := YDrawBubbleMargin div 2;
    for i := 0 to aBubbleList.Count - 1 do
    begin
        ATextOut(FontBackimg, xx + 1, yy + 1, WinRGB(3, 3, 3), abubblelist[i]);
        inc(yy, imgY div aBubbleList.Count + 1);
    end;
    xx := XDrawBubbleMargin div 2 + 3;
    yy := YDrawBubbleMargin div 2;
    for i := 0 to aBubbleList.Count - 1 do
    begin
        ATextOut(FontBackimg, xx, yy, WinRGB(31, 31, 31), abubblelist[i]);
        inc(yy, imgY div aBubbleList.Count + 1);
    end;
    xx := (SWidth div 2 + x - Cx) - ((imgX + XDrawBubbleMargin) div 2);
    yy := (SHeight div 2) + y - Cy - 36 - (imgY + YDrawBubbleMargin);

    back.DrawImageKeyColor(FontBackimg, xx, yy, 31, @bubbletbl);
    FontBackImg.Free;
end;
{ 官帕绝绰巴 抗傈芭
procedure  TBackScreen.DrawBubble (Canvas:TCanvas;  x, y: integer; abubbleList: TStringList);
var
   i, len, xx, yy, n : integer;
begin
   len := 0;
   for i := 0 to aBubbleList.Count -1 do begin
      n := ATextHeight (aBubbleList[i]);
      if n > len then len := n;
   end;
   if len = 0 then exit;
   len := len + 2;

   for i := 0 to aBubbleList.Count -1 do begin
      xx := SWidth div 2 + x-Cx - 40 + 1;
      yy := SHeight div 2 + y-Cy - aBubbleList.Count * len + i *len-36+1;
      ATextOut (Back, xx, yy, WinRGB (3, 3, 3), abubblelist[i]);
   end;

   for i := 0 to aBubbleList.Count -1 do begin
      xx := SWidth div 2 + x-Cx - 40;
      yy := SHeight div 2 + y-Cy - aBubbleList.Count * len + i *len - 36;
      ATextOut (Back, xx, yy, WinRGB (31, 31, 31), abubblelist[i]);
   end;
end;
}

procedure TBackScreen.SetRainState(aRainning: Boolean; aspeed, aCount, aover, aTick: integer; araintype: byte);
begin
    FRainning := aRainning;
    RainSpeed := aspeed;
    RainCount := acount;
    RainOverray := aover;
    RainTick := mmAnsTick + aTick;
    Raintype := araintype;
end;

procedure TBackScreen.CenterchangeIDPos(x, y: integer);
begin
    {
       RainchagX := x;
       RainchagY := y;
    }
end;

procedure TBackScreen.UpdateRain;
var
    i, n, xx, yy: integer;
    pr: PTRainData;
    itemp: byte;
begin
    if not FRainning then exit;
    if RainTick < mmAnsTick then FRainning := FALSE;
    {
       Raintype :=RAINTYPE_SNOW;
       RainSpeed := 1;
       RainCount := 200;
       RainOverray := 50;
    }
    case Raintype of
        RAINTYPE_RAIN:
            begin
                if RainList.Count < RainCount then
                begin
                    n := Random(RainCount div 20);
                    for i := 0 to n - 1 do
                    begin
                        new(pr);
                        pr^.rx := Random(900) - 30;
                        pr^.ry := Random(600) - 200;
                        pr^.rsx := pr^.rx;
                        pr^.rsy := pr^.ry;
                        pr^.rSpeed := RainSpeed + Random(RainSpeed);            // 狼固绝绰蔼
                        pr^.rOverray := Random(50);                             // 狼固绝绰蔼
                        pr^.rXpos := random(20);                                // 狼固绝绰蔼
                        pr^.rimage := 0;
                        RainList.Add(pr);
                    end;
                end;
                for i := 0 to RainList.Count - 1 do
                begin
                    pr := RainList[i];
                    Back.DrawImageOveray(RainImageLib.Images[pr^.rImage], pr^.rx, pr^.ry, RainOverray);
                    if (pr^.ry - pr^.rsy) > 150 then
                    begin
                        xx := (Cx - SWidth div 2 + pr^.rx) div UNITX;
                        yy := (Cy - SHeight div 2 + pr^.ry) div UNITY;
                        if Map.IsInArea(xx, yy) then pr^.rimage := RainImageLib.Count
                        else inc(pr^.rimage);
                    end else
                    begin
                        pr^.ry := pr^.ry + RainSpeed;
                    end;
                end;
            end;
        RAINTYPE_SNOW:
            begin
                if RainList.Count < RainCount then
                begin
                    n := Random(RainCount div 20);
                    for i := 0 to n - 1 do
                    begin
                        new(pr);
                        pr^.rx := Random(900) - 30;
                        pr^.ry := Random(600) - 200;
                        pr^.rsx := pr^.rx;
                        pr^.rsy := pr^.ry;
                        pr^.rSpeed := RainSpeed + Random(RainSpeed);
                        pr^.rOverray := Random(50);                             // ==>
                        pr^.rXpos := random(20);
                        pr^.rimage := 0;
                        RainList.Add(pr);
                    end;
                end;
                itemp := 0;
                for i := 0 to RainList.Count - 1 do
                begin
                    pr := RainList[i];
                    Back.DrawImageOveray(SnowImageLib.Images[pr^.rImage], pr^.rx, pr^.ry, pr^.rOverray);
                    if (pr^.ry - pr^.rsy) > 150 then
                    begin
                        xx := (Cx - SWidth div 2 + pr^.rx) div UNITX;
                        yy := (Cy - SHeight div 2 + pr^.ry) div UNITY;
                        if Map.IsInArea(xx, yy) then pr^.rimage := RainImageLib.Count
                        else inc(pr^.rimage);
                    end else
                    begin
                        if itemp = random(4) then
                        begin
                            pr^.rx := pr^.rsx + snowXPosTable[pr^.rXpos];       // + snowidx];
                            pr^.rXpos := pr^.rXpos + 1;
                            if pr^.rXpos > 40 then pr^.rXpos := 0;
                        end;
                        inc(itemp);
                        if itemp > 4 then itemp := 0;
                        pr^.ry := pr^.ry + pr^.rSpeed;
                    end;
                end;
            end;
    end;
    for i := RainList.Count - 1 downto 0 do
    begin
        pr := RainList[i];
        if pr^.rimage >= RainImageLib.Count then
        begin
            dispose(RainList[i]);
            RainList.Delete(i);
        end;
    end;
end;

////////////////////////////// ConvertDark /////////////////////////////////////

procedure TBackScreen.ConvertDark;
var
    i, j: integer;
    pw: PWORD;
begin
    pw := PWORD(Back.Bits);
    for j := 0 to 600 - 1 do
    begin
        for i := 0 to 800 - 1 do
        begin
            pw^ := darkentbl[pw^];
            inc(pw);
        end;
    end;
end;

end.

