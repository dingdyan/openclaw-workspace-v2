////////////////////////////////////////////////////////////////////////////
// PAXScript Importing
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003. All rights reserved.                                  
// Code Version: 1.5
// ========================================================================
// Unit: IMP_Graphics.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

// Imports classes:
//   TBitmap,
//   TBrush,
//   TCanvas,
//   TFont,
//   TGraphic,
//   TGraphicsObject,
//   TIcon,
//   TMetafile
//   TMetafileCanvas
//   TPen,
//   TPicture

unit IMP_Graphics;
interface
uses
  SysUtils,
{$IFDEF WIN32}
  Windows,
{$ENDIF}
{$IFDEF LINUX}
  Types,
  QGraphics,
  QControls,
{$ELSE}
  Graphics,
  Controls,
{$ENDIF}
  PaxScripter;

implementation

type
  TByteArray = class
  private
    P: Pointer;
    procedure Put(I: Integer; Value: Integer);
    function Get(I: Integer): Integer;
  public
    property Items[I: Integer]: Integer read Get write Put; default;
  end;

procedure TByteArray.Put(I: Integer; Value: Integer);
begin
  PByteArray(P)^[I] := Value;
end;

function TByteArray.Get(I: Integer): Integer;
begin
  result := PByteArray(P)^[I];
end;

//-------TBrush-----------------------------------------------------------------

function TBrush_GetBitmap: TBitmap;
begin
 result := TBrush(_Self).Bitmap;
end;

procedure TBrush_SetBitmap(Value: TBitmap);
begin
 TBrush(_Self).Bitmap := Value;
end;

//-------TCanvas----------------------------------------------------------------

function TCanvas_GetClipRect: TRect;
begin
 result := TCanvas(_Self).ClipRect;
end;

function TCanvas_GetLockCount: Integer;
begin
 result := TCanvas(_Self).LockCount;
end;

function TCanvas_GetPenPos: TPoint;
begin
 result := TCanvas(_Self).PenPos;
end;

procedure TCanvas_SetPenPos(Value: TPoint);
begin
 TCanvas(_Self).PenPos := Value;
end;

function TCanvas_GetPixel(X, Y: Integer): TColor;
begin
 result := TCanvas(_Self).Pixels[X,Y];
end;

procedure TCanvas_SetPixel(X, Y: Integer; Value: TColor);
begin
 TCanvas(_Self).Pixels[X,Y] := Value;
end;

//-------TGraphic---------------------------------------------------------------

function TGraphic_GetEmpty: Boolean;
begin
 result := TGraphic(_Self).Empty;
end;

function TGraphic_GetHeight: Integer;
begin
 result := TGraphic(_Self).Height;
end;

procedure TGraphic_SetHeight(Value: Integer);
begin
 TGraphic(_Self).Height := Value;
end;

function TGraphic_GetModified: Boolean;
begin
 result := TGraphic(_Self).Modified;
end;

procedure TGraphic_SetModified(Value: Boolean);
begin
 TGraphic(_Self).Modified := Value;
end;

function TGraphic_GetTransparent: Boolean;
begin
 result := TGraphic(_Self).Transparent;
end;

procedure TGraphic_SetTransparent(Value: Boolean);
begin
 TGraphic(_Self).Transparent := Value;
end;

function TGraphic_GetWidth: Integer;
begin
 result := TGraphic(_Self).Width;
end;

procedure TGraphic_SetWidth(Value: Integer);
begin
 TGraphic(_Self).Width := Value;
end;

{$IFDEF WIN32}
//-------TMetafile--------------------------------------------------------------

function TMetafile_GetAuthor: String;
begin
 result := TMetafile(_Self).CreatedBy;
end;

function TMetafile_GetDesc: String;
begin
 result := TMetafile(_Self).Description;
end;

function TMetafile_GetEnhanced: Boolean;
begin
 result := TMetafile(_Self).Enhanced;
end;

procedure TMetafile_SetEnhanced(Value: Boolean);
begin
 TMetafile(_Self).Enhanced := Value;
end;

function TMetafile_GetHandle: HENHMETAFILE;
begin
 result := TMetafile(_Self).Handle;
end;

procedure TMetafile_SetHandle(Value: HENHMETAFILE);
begin
 TMetafile(_Self).Handle := Value;
end;

function TMetafile_GetMMWidth: Integer;
begin
 result := TMetafile(_Self).MMWidth;
end;

procedure TMetafile_SetMMWidth(Value: Integer);
begin
 TMetafile(_Self).MMWidth := Value;
end;

function TMetafile_GetMMHeight: Integer;
begin
 result := TMetafile(_Self).MMHeight;
end;

procedure TMetafile_SetMMHeight(Value: Integer);
begin
 TMetafile(_Self).MMHeight := Value;
end;

function TMetafile_GetInch: Word;
begin
 result := TMetafile(_Self).Inch;
end;

procedure TMetafile_SetInch(Value: Word);
begin
 TMetafile(_Self).Inch := Value;
end;

{$ENDIF}

//-------TPicture---------------------------------------------------------------

function TPicture_GetBitmap: TBitmap;
begin
 result := TPicture(_Self).Bitmap;
end;

procedure TPicture_SetBitmap(Value: TBitmap);
begin
 TPicture(_Self).Bitmap := Value;
end;

function TPicture_GetGraphic: TGraphic;
begin
 result := TPicture(_Self).Graphic;
end;

procedure TPicture_SetGraphic(Value: TGraphic);
begin
 TPicture(_Self).Graphic := Value;
end;

function TPicture_GetHeight: Integer;
begin
 result := TPicture(_Self).Height;
end;

function TPicture_GetIcon: TIcon;
begin
 result := TPicture(_Self).Icon;
end;

procedure TPicture_SetIcon(Value: TIcon);
begin
 TPicture(_Self).Icon := Value;
end;

function TPicture_GetWidth: Integer;
begin
 result := TPicture(_Self).Width;
end;

//-------TBitmap----------------------------------------------------------------

function TBitmap_GetCanvas: TCanvas;
begin
 result := TBitmap(_Self).Canvas;
end;

function TBitmap_GetMonochrome: Boolean;
begin
 result := TBitmap(_Self).Monochrome;
end;

procedure TBitmap_SetMonochrome(Value: Boolean);
begin
 TBitmap(_Self).Monochrome := Value;
end;

function TBitmap_GetPixelFormat: TPixelFormat;
begin
 result := TBitmap(_Self).PixelFormat;
end;

procedure TBitmap_SetPixelFormat(Value: TPixelFormat);
begin
 TBitmap(_Self).PixelFormat := Value;
end;

function TBitmap_GetScanline(Row: Integer): TByteArray;
var
  P: Pointer;
  Key: TVarRec;
begin
  P := TBitmap(_Self).ScanLine[Row];

  Key.VPointer := P;
  result := TByteArray(_Scripter.FindTempObject(Key));
  if result <> nil then
    Exit;

  result := TByteArray.Create;
  result.P := P;

  _Scripter.AddTempObject(Key, result);
end;

function TBitmap_GetTransparentColor: TColor;
begin
 result := TBitmap(_Self).TransparentColor;
end;

procedure TBitmap_SetTransparentColor(Value: TColor);
begin
 TBitmap(_Self).TransparentColor := Value;
end;

function TBitmap_GetTransparentMode: TTransparentMode;
begin
 result := TBitmap(_Self).TransparentMode;
end;

procedure TBitmap_SetTransparentMode(Value: TTransparentMode);
begin
 TBitmap(_Self).TransparentMode := Value;
end;

type
  TRegClass = class
    procedure  RegColor(const S: string);
  end;

procedure TRegClass.RegColor(const S: string);
var
  C: Integer;
begin
  if IdentToColor(S, C) then
    RegisterConstant(S, C, -1);
end;

procedure RegisterColorValues;
var
  X: TRegClass;
begin
  X := TRegClass.Create;
  GetColorValues(X.RegColor);
  X.Free;
end;

var
  H: Integer;

initialization


  H := RegisterRecordType('TPoint', SizeOf(TPoint));
  RegisterRecordField(H, 'X', 'Integer', 0);
  RegisterRecordField(H, 'Y', 'Integer', 4);

  H := RegisterRecordType('TRect', SizeOf(TRect));
  RegisterRecordField(H, 'Left', 'Integer', 0);
  RegisterRecordField(H, 'Top', 'Integer', 4);
  RegisterRecordField(H, 'Right', 'Integer', 8);
  RegisterRecordField(H, 'Bottom', 'Integer', 12);

  RegisterClassType(TByteArray, -1);
  RegisterMethod(TByteArray, 'procedure Put(I: Integer; Value: Integer);', @TByteArray.Put);
  RegisterMethod(TByteArray, 'function Get(I: Integer): Integer;', @TByteArray.Get);
  RegisterProperty(TByteArray, 'property Items[I: Integer]: Integer read Get write Put; default;');


  H := RegisterNamespace('Graphics');

  RegisterColorValues;

  RegisterRoutine('function IdentToColor(const Ident: string; var Color: Longint): Boolean;',
                  @IdentToColor, H);

//---- TGraphicsObject ---------------------------------------------------------

  RegisterClassType(TGraphicsObject, H);
  RegisterMethod(TGraphicsObject, 'constructor Create;',
                 @TGraphicsObject.Create);

//---- TFont -------------------------------------------------------------------

  RegisterClassType(TFont, H);
  RegisterMethod(TFont, 'constructor Create;',
                 @TFont.Create);
  RegisterMethod(TFont, 'procedure Assign(Source: TPersistent); override;',
                 @TFont.Assign);

//---- TPen --------------------------------------------------------------------

  RegisterClassType(TPen, H);
  RegisterMethod(TPen, 'constructor Create;',
                 @TPen.Create);
  RegisterMethod(TPen, 'procedure Assign(Source: TPersistent); override;',
                 @TPen.Assign);

//---- TBrush ------------------------------------------------------------------

  RegisterClassType(TBrush, H);
  RegisterMethod(TBrush, 'constructor Create;',
                 @TBrush.Create);
  RegisterMethod(TBrush, 'procedure Assign(Source: TPersistent); override;',
                 @TBrush.Assign);
  RegisterMethod(TBrush, 'function GetBitmap: TBitmap;',
                 @TBrush_GetBitmap, Fake);
  RegisterMethod(TBrush, 'procedure SetBitmap(Value: TBitmap);',
                 @TBrush_SetBitmap, Fake);
  RegisterProperty(TBrush, 'property Bitmap: TBitmap read GetBitmap write SetBitmap;');

//---- TCanvas -----------------------------------------------------------------

  RegisterClassType(TCanvas, H);
  RegisterMethod(TCanvas, 'constructor Create;',
                @TCanvas.Create);
  RegisterMethod(TCanvas, 'procedure Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);',
                @TCanvas.Arc);
  RegisterMethod(TCanvas, 'procedure Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);',
                @TCanvas.Chord);
  RegisterMethod(TCanvas, 'procedure CopyRect(const Dest: TRect; Canvas: TCanvas;'
                +' const Source: TRect);',
                @TCanvas.CopyRect);
  RegisterMethod(TCanvas, 'procedure Draw(X, Y: Integer; Graphic: TGraphic);',
                @TCanvas.Draw);
  RegisterMethod(TCanvas, 'procedure DrawFocusRect(const Rect: TRect);',
                @TCanvas.DrawFocusRect);
  RegisterMethod(TCanvas, 'procedure Ellipse(X1, Y1, X2, Y2: Integer); overload;',
                @TCanvas.Ellipse);
  RegisterMethod(TCanvas, 'procedure Ellipse(const Rect: TRect); overload;',
                @TCanvas.Ellipse);
  RegisterMethod(TCanvas, 'procedure FillRect(const Rect: TRect);',
                @TCanvas.FillRect);
  RegisterMethod(TCanvas, 'procedure LineTo(X, Y: Integer);',
                @TCanvas.LineTo);
  RegisterMethod(TCanvas, 'procedure Lock;',
                @TCanvas.Lock);
  RegisterMethod(TCanvas, 'procedure MoveTo(X, Y: Integer);',
                @TCanvas.MoveTo);
  RegisterMethod(TCanvas, 'procedure Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);',
                @TCanvas.Pie);
  RegisterMethod(TCanvas, 'procedure Rectangle(X1, Y1, X2, Y2: Integer); overload;',
                @TCanvas.Rectangle);
//  RegisterMethod(TCanvas, 'procedure Rectangle(const Rect: TRect); overload;',
//                @TCanvas.Rectangle);
  RegisterMethod(TCanvas, 'procedure Refresh;',
                @TCanvas.Refresh);
  RegisterMethod(TCanvas, 'procedure RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer);',
                @TCanvas.RoundRect);
  RegisterMethod(TCanvas, 'procedure StretchDraw(const Rect: TRect; Graphic: TGraphic);',
                @TCanvas.StretchDraw);
  RegisterMethod(TCanvas, 'function TextExtent(const Text: string): TSize;',
                @TCanvas.TextExtent);
  RegisterMethod(TCanvas, 'function TextHeight(const Text: string): Integer;',
                @TCanvas.TextHeight);
{$IFDEF LINUX}
  RegisterMethod(TCanvas, 'procedure TextOut(X, Y: Integer; const Text: WideString);',
                @TCanvas.TextOut);
{$ELSE}
  RegisterMethod(TCanvas, 'procedure TextOut(X, Y: Integer; const Text: string);',
                @TCanvas.TextOut);
{$ENDIF}
  RegisterMethod(TCanvas, 'procedure TextRect(Rect: TRect; X, Y: Integer; const Text: string);',
                @TCanvas.TextRect);
  RegisterMethod(TCanvas, 'function TextWidth(const Text: string): Integer;',
                @TCanvas.TextWidth);
  RegisterMethod(TCanvas, 'function TryLock: Boolean;',
                @TCanvas.TryLock);
  RegisterMethod(TCanvas, 'procedure Unlock;',
                @TCanvas.Unlock);
  RegisterMethod(TCanvas, 'function GetClipRect: TRect;',
                @TCanvas_GetClipRect, Fake);
  RegisterProperty(TCanvas, 'property ClipRect: TRect read GetClipRect;');
  RegisterMethod(TCanvas, 'function GetLockCount: Integer;',
                @TCanvas_GetLockCount, Fake);
  RegisterProperty(TCanvas, 'property LockCount: Integer read GetLockCount;');
  RegisterMethod(TCanvas, 'function GetPenPos: TPoint;',
                @TCanvas_GetPenPos, Fake);
  RegisterMethod(TCanvas, 'procedure SetPenPos(Value: TPoint);',
                @TCanvas_SetPenPos, Fake);
  RegisterProperty(TCanvas, 'property PenPos: TPoint read GetPenPos write SetPenPos;');
  RegisterMethod(TCanvas, 'function GetPixel(X, Y: Integer): TColor;',
                @TCanvas_GetPixel, Fake);
  RegisterMethod(TCanvas, 'procedure SetPixel(X, Y: Integer; Value: TColor);',
                @TCanvas_SetPixel, Fake);
  RegisterProperty(TCanvas, 'property Pixels[X, Y: Integer]: TColor read GetPixel'
                +' write SetPixel;');

//---- TGraphic ----------------------------------------------------------------

  RegisterClassType(TGraphic, H);
  RegisterMethod(TGraphic, 'constructor Create;',
                @TGraphic.Create);
  RegisterMethod(TGraphic, 'procedure LoadFromFile(const Filename: string); virtual;',
                @TGraphic.LoadFromFile);
  RegisterMethod(TGraphic, 'procedure SaveToFile(const Filename: string); virtual;',
                @TGraphic.SaveToFile);
  RegisterMethod(TGraphic, 'function GetEmpty: Boolean;',
                @TGraphic_GetEmpty, Fake);
  RegisterProperty(TGraphic, 'property Empty: Boolean read GetEmpty;');
  RegisterMethod(TGraphic, 'function GetHeight: Integer;',
                @TGraphic_GetHeight, Fake);
  RegisterMethod(TGraphic, 'procedure SetHeight(Value: Integer);',
                @TGraphic_SetHeight, Fake);
  RegisterProperty(TGraphic, 'property Height: Integer read GetHeight write SetHeight;');
  RegisterMethod(TGraphic, 'function GetModified: Boolean;',
                @TGraphic_GetModified, Fake);
  RegisterMethod(TGraphic, 'procedure SetModified(Value: Boolean);',
                @TGraphic_SetModified, Fake);
  RegisterProperty(TGraphic, 'property Modified: Boolean read GetModified'
                +' write SetModified;');
  RegisterMethod(TGraphic, 'function GetTransparent: Boolean;',
                @TGraphic_GetTransparent, Fake);
  RegisterMethod(TGraphic, 'procedure SetTransparent(Value: Boolean);',
                @TGraphic_SetTransparent, Fake);
  RegisterProperty(TGraphic, 'property Transparent: Boolean read GetTransparent'
                +' write SetTransparent;');
  RegisterMethod(TGraphic, 'function GetWidth: Integer;',
                @TGraphic_GetWidth, Fake);
  RegisterMethod(TGraphic, 'procedure SetWidth(Value: Integer);',
                @TGraphic_SetWidth, Fake);
  RegisterProperty(TGraphic, 'property Width: Integer read GetWidth write SetWidth;');

//---- TIcon -------------------------------------------------------------------

  RegisterClassType(TIcon, H);
  RegisterMethod(TIcon, 'constructor Create; override;',
                @TIcon.Create);
  RegisterMethod(TIcon, 'procedure Assign(Source: TPersistent); override;',
                @TIcon.Assign);
  RegisterMethod(TIcon, 'procedure LoadFromStream(Stream: TStream); override;',
                @TIcon.LoadFromStream);
  RegisterMethod(TIcon, 'procedure SaveToStream(Stream: TStream); override;',
                @TIcon.SaveToStream);

{$IFDEF MASWINDOWS}
//---- TMetafile ---------------------------------------------------------------

  RegisterClassType(TMetafile, H);
  RegisterMethod(TMetafile, 'constructor Create; override;',
                @TMetafile.Create);
  RegisterMethod(TMetafile, 'procedure Clear;',
                @TMetafile.Clear);
  RegisterMethod(TMetafile, 'procedure LoadFromStream(Stream: TStream); override;',
                @TMetafile.LoadFromStream);
  RegisterMethod(TMetafile, 'procedure SaveToFile(const Filename: String); override;',
                @TMetafile.SaveToFile);
  RegisterMethod(TMetafile, 'procedure SaveToStream(Stream: TStream); override;',
                @TMetafile.SaveToStream);
  RegisterMethod(TMetafile, 'procedure LoadFromClipboardFormat(AFormat: Word;'
                +' AData: THandle; APalette: HPALETTE); override;',
                @TMetafile.LoadFromClipboardFormat);
  RegisterMethod(TMetafile, 'procedure SaveToClipboardFormat(var AFormat: Word;'
                +' var AData: THandle; var APalette: HPALETTE); override;',
                @TMetafile.SaveToClipboardFormat);
  RegisterMethod(TMetafile, 'procedure Assign(Source: TPersistent); override;',
                @TMetafile.Assign);
  RegisterMethod(TMetafile, 'function ReleaseHandle: HENHMETAFILE;',
                @TMetafile.ReleaseHandle);
  RegisterMethod(TMetafile, 'function GetAuthor: String;',
                @TMetafile_GetAuthor, Fake);
  RegisterProperty(TMetafile, 'property CreatedBy: String read GetAuthor;');
  RegisterMethod(TMetafile, 'function GetDesc: String;',
                @TMetafile_GetDesc, Fake);
  RegisterProperty(TMetafile, 'property Description: String read GetDesc;');
  RegisterMethod(TMetafile, 'function GetEnhanced: Boolean;',
                @TMetafile_GetEnhanced, Fake);
  RegisterMethod(TMetafile, 'procedure SetEnhanced(Value: Boolean);',
                @TMetafile_SetEnhanced, Fake);
  RegisterProperty(TMetafile, 'property Enhanced: Boolean read GetEnhanced write'
                +' SetEnhanced;');
  RegisterMethod(TMetafile, 'function GetHandle: HENHMETAFILE;',
                @TMetafile_GetHandle, Fake);
  RegisterMethod(TMetafile, 'procedure SetHandle(Value: HENHMETAFILE);',
                @TMetafile_SetHandle, Fake);
  RegisterProperty(TMetafile, 'property Handle: HENHMETAFILE read GetHandle'
                +' write SetHandle;');
  RegisterMethod(TMetafile, 'function GetMMWidth: Integer;',
                @TMetafile_GetMMWidth, Fake);
  RegisterMethod(TMetafile, 'procedure SetMMWidth(Value: Integer);',
                @TMetafile_SetMMWidth, Fake);
  RegisterProperty(TMetafile, 'property MMWidth: Integer read GetMMWidth'
                +' write SetMMWidth;');
  RegisterMethod(TMetafile, 'function GetMMHeight: Integer;',
                @TMetafile_GetMMHeight, Fake);
  RegisterMethod(TMetafile, 'procedure SetMMHeight(Value: Integer);',
                @TMetafile_SetMMHeight, Fake);
  RegisterProperty(TMetafile, 'property MMHeight: Integer read GetMMHeight'
                +' write SetMMHeight;');
  RegisterMethod(TMetafile, 'function GetInch: Word;',
                @TMetafile_GetInch, Fake);
  RegisterMethod(TMetafile, 'procedure SetInch(Value: Word);',
                @TMetafile_SetInch, Fake);
  RegisterProperty(TMetafile, 'property Inch: Word read GetInch write SetInch;');

//---- TMetafileCanvas ---------------------------------------------------------

  RegisterClassType(TMetafileCanvas, H);
  RegisterMethod(TMetafileCanvas, 'constructor Create(AMetafile: TMetafile;'
                +' ReferenceDevice: HDC);',
                @TMetafileCanvas.Create);
  RegisterMethod(TMetafileCanvas, 'constructor CreateWithComment(AMetafile:'
                +' TMetafile; ReferenceDevice: HDC; const CreatedBy,'
                +' Description: String);',
                @TMetafileCanvas.CreateWithComment);
{$ENDIF}                

//---- TPicture-----------------------------------------------------------------

  RegisterClassType(TPicture, H);
  RegisterMethod(TPicture, 'constructor Create;',
                @TPicture.Create);
  RegisterMethod(TPicture, 'procedure LoadFromFile(const Filename: string);',
                @TPicture.LoadFromFile);
  RegisterMethod(TPicture, 'procedure SaveToFile(const Filename: string);',
                @TPicture.SaveToFile);
  RegisterMethod(TPicture, 'class procedure RegisterFileFormat(const AExtension,'
                + 'ADescription: string; AGraphicClass: TGraphicClass);',
                @TPicture.RegisterFileFormat);
  RegisterMethod(TPicture, 'procedure Assign(Source: TPersistent); override;',
                @TPicture.Assign);
  RegisterMethod(TPicture, 'class procedure RegisterFileFormatRes(const AExtension:'
                +' String; ADescriptionResID: Integer; AGraphicClass: TGraphicClass);',
                @TPicture.RegisterFileFormatRes);
  RegisterMethod(TPicture, 'class procedure UnregisterGraphicClass(AClass: TGraphicClass);',
                @TPicture.UnregisterGraphicClass);
  RegisterMethod(TPicture, 'function GetBitmap: TBitmap;',
                @TPicture_GetBitmap, Fake);
  RegisterMethod(TPicture, 'procedure SetBitmap(Value: TBitmap);',
                @TPicture_SetBitmap, Fake);
  RegisterProperty(TPicture, 'property Bitmap: TBitmap read GetBitmap write SetBitmap;');
  RegisterMethod(TPicture, 'function GetGraphic: TGraphic;',
                @TPicture_GetGraphic, Fake);
  RegisterMethod(TPicture, 'procedure SetGraphic(Value: TGraphic);',
                @TPicture_SetGraphic, Fake);
  RegisterProperty(TPicture, 'property Graphic: TGraphic read GetGraphic write SetGraphic;');
  RegisterMethod(TPicture, 'function GetHeight: Integer;',
                @TPicture_GetHeight, Fake);
  RegisterProperty(TPicture, 'property Height: Integer read GetHeight;');
  RegisterMethod(TPicture, 'function GetIcon: TIcon;',
                @TPicture_GetIcon, Fake);
  RegisterMethod(TPicture, 'procedure SetIcon(Value: TIcon);',
                @TPicture_SetIcon, Fake);
  RegisterProperty(TPicture, 'property Icon: TIcon read GetIcon write SetIcon;');
  RegisterMethod(TPicture, 'function GetWidth: Integer;',
                @TPicture_GetWidth, Fake);
  RegisterProperty(TPicture, 'property Width: Integer read GetWidth;');

//---- TBitmap -----------------------------------------------------------------
  REgisterRTTIType(TypeInfo(TPixelFormat));

  RegisterClassType(TBitmap, H);
  RegisterMethod(TBitmap, 'constructor Create; override;',
                @TBitmap.Create);
  RegisterMethod(TBitmap, 'procedure Assign(Source: TPersistent); override;',
                @TBitmap.Assign);
  RegisterMethod(TBitmap, 'procedure Dormant;',
                @TBitmap.Dormant);
  RegisterMethod(TBitmap, 'procedure FreeImage;',
                @TBitmap.FreeImage);
  RegisterMethod(TBitmap, 'procedure LoadFromStream(Stream: TStream); override;',
                @TBitmap.LoadFromStream);
  RegisterMethod(TBitmap, 'procedure LoadFromResourceName(Instance: THandle;'
                +' const ResName: String);',
                @TBitmap.LoadFromResourceName);
  RegisterMethod(TBitmap, 'procedure LoadFromResourceID(Instance: THandle;'
                +' ResID: Integer);',
                @TBitmap.LoadFromResourceID);
  RegisterMethod(TBitmap, 'procedure Mask(TransparentColor: TColor);',
                @TBitmap.Mask);
  RegisterMethod(TBitmap, 'procedure SaveToStream(Stream: TStream); override;',
                @TBitmap.SaveToStream);
  RegisterMethod(TBitmap, 'function GetCanvas: TCanvas;',
                @TBitmap_GetCanvas, Fake);
  RegisterProperty(TBitmap, 'property Canvas: TCanvas read GetCanvas;');
  RegisterMethod(TBitmap, 'function GetMonochrome: Boolean;',
                @TBitmap_GetMonochrome, Fake);
  RegisterMethod(TBitmap, 'procedure SetMonochrome(Value: Boolean);',
                @TBitmap_SetMonochrome, Fake);
  RegisterProperty(TBitmap, 'property Monochrome: Boolean read GetMonochrome'
                +' write SetMonochrome;');
  RegisterMethod(TBitmap, 'function GetPixelFormat: TPixelFormat;',
                @TBitmap_GetPixelFormat, Fake);
  RegisterMethod(TBitmap, 'procedure SetPixelFormat(Value: TPixelFormat);',
                @TBitmap_SetPixelFormat, Fake);
  RegisterProperty(TBitmap, 'property PixelFormat: TPixelFormat read'
                +' GetPixelFormat write SetPixelFormat;');
  RegisterMethod(TBitmap, 'function GetScanline(Row: Integer): TByteArray;',
                @TBitmap_GetScanline, Fake);
  RegisterProperty(TBitmap, 'property ScanLine[Row: Integer]: TByteArray read'
                +' GetScanLine;');
  RegisterMethod(TBitmap, 'function GetTransparentColor: TColor;',
                @TBitmap_GetTransparentColor, Fake);
  RegisterMethod(TBitmap, 'procedure SetTransparentColor(Value: TColor);',
                @TBitmap_SetTransparentColor, Fake);
  RegisterProperty(TBitmap, 'property TransparentColor: TColor read'
                +' GetTransparentColor write SetTransparentColor;');
  RegisterMethod(TBitmap, 'function GetTransparentMode: TTransparentMode;',
                @TBitmap_GetTransparentMode, Fake);
  RegisterMethod(TBitmap, 'procedure SetTransparentMode(Value: TTransparentMode);',
                @TBitmap_SetTransparentMode, Fake);
  RegisterProperty(TBitmap, 'property TransparentMode: TTransparentMode read'
                +' GetTransparentMode write SetTransparentMode;');
end.
