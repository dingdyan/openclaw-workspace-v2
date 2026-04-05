unit IMP_extctrls;
interface
uses
  Messages,
  Windows,
  SysUtils,
  Classes,
  Controls,
  Forms,
  Menus,
  Graphics,
  StdCtrls,
  extctrls,
  PaxScripter;
procedure RegisterIMP_extctrls;
implementation
function TImage_GetCanvas:TCanvas;
begin
  result := TImage(_Self).Canvas;
end;
function THeader_GetSectionWidth(X: Integer):Integer;
begin
  result := THeader(_Self).SectionWidth[X];
end;
procedure THeader_PutSectionWidth(X: Integer;const Value: Integer);
begin
  THeader(_Self).SectionWidth[X] := Value;
end;
function TCustomControlBar_GetPicture:TPicture;
begin
  result := TCustomControlBar(_Self).Picture;
end;
procedure TCustomControlBar_PutPicture(const Value: TPicture);
begin
  TCustomControlBar(_Self).Picture := Value;
end;
procedure RegisterIMP_extctrls;
var H: Integer;
begin
  H := RegisterNamespace('extctrls', -1);
  RegisterRTTIType(TypeInfo(TShapeType));
  // Begin of class TShape
  RegisterClassType(TShape, H);
  RegisterMethod(TShape,
       'constructor Create(AOwner: TComponent); override;',
       @TShape.Create);
  RegisterMethod(TShape,
       'destructor Destroy; override;',
       @TShape.Destroy);
  // End of class TShape
  // Begin of class TPaintBox
  RegisterClassType(TPaintBox, H);
  RegisterMethod(TPaintBox,
       'constructor Create(AOwner: TComponent); override;',
       @TPaintBox.Create);
  // End of class TPaintBox
  // Begin of class TImage
  RegisterClassType(TImage, H);
  RegisterMethod(TImage,
       'constructor Create(AOwner: TComponent); override;',
       @TImage.Create);
  RegisterMethod(TImage,
       'destructor Destroy; override;',
       @TImage.Destroy);
  RegisterMethod(TImage,
       'function TImage_GetCanvas:TCanvas;',
       @TImage_GetCanvas, Fake);
  RegisterProperty(TImage,
       'property Canvas:TCanvas read TImage_GetCanvas;');
  // End of class TImage
  RegisterRTTIType(TypeInfo(TBevelStyle));
  RegisterRTTIType(TypeInfo(TBevelShape));
  // Begin of class TBevel
  RegisterClassType(TBevel, H);
  RegisterMethod(TBevel,
       'constructor Create(AOwner: TComponent); override;',
       @TBevel.Create);
  // End of class TBevel
  // Begin of class TTimer
  RegisterClassType(TTimer, H);
  RegisterMethod(TTimer,
       'constructor Create(AOwner: TComponent); override;',
       @TTimer.Create);
  RegisterMethod(TTimer,
       'destructor Destroy; override;',
       @TTimer.Destroy);
  // End of class TTimer
  // Begin of class TCustomPanel
  RegisterClassType(TCustomPanel, H);
  RegisterMethod(TCustomPanel,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomPanel.Create);
  RegisterMethod(TCustomPanel,
       'function GetControlsAlignment: TAlignment; override;',
       @TCustomPanel.GetControlsAlignment);
  // End of class TCustomPanel
  // Begin of class TPanel
  RegisterClassType(TPanel, H);
  RegisterMethod(TPanel,
       'constructor Create(AOwner: TComponent); override;',
       @TPanel.Create);
  // End of class TPanel
  // Begin of class TPage
  RegisterClassType(TPage, H);
  RegisterMethod(TPage,
       'constructor Create(AOwner: TComponent); override;',
       @TPage.Create);
  // End of class TPage
  // Begin of class TNotebook
  RegisterClassType(TNotebook, H);
  RegisterMethod(TNotebook,
       'constructor Create(AOwner: TComponent); override;',
       @TNotebook.Create);
  RegisterMethod(TNotebook,
       'destructor Destroy; override;',
       @TNotebook.Destroy);
  // End of class TNotebook
  // Begin of class THeader
  RegisterClassType(THeader, H);
  RegisterMethod(THeader,
       'constructor Create(AOwner: TComponent); override;',
       @THeader.Create);
  RegisterMethod(THeader,
       'destructor Destroy; override;',
       @THeader.Destroy);
  RegisterMethod(THeader,
       'function THeader_GetSectionWidth(X: Integer):Integer;',
       @THeader_GetSectionWidth, Fake);
  RegisterMethod(THeader,
       'procedure THeader_PutSectionWidth(X: Integer;const Value: Integer);',
       @THeader_PutSectionWidth, Fake);
  RegisterProperty(THeader,
       'property SectionWidth[X: Integer]:Integer read THeader_GetSectionWidth write THeader_PutSectionWidth;');
  // End of class THeader
  // Begin of class TCustomRadioGroup
  RegisterClassType(TCustomRadioGroup, H);
  RegisterMethod(TCustomRadioGroup,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomRadioGroup.Create);
  RegisterMethod(TCustomRadioGroup,
       'destructor Destroy; override;',
       @TCustomRadioGroup.Destroy);
  RegisterMethod(TCustomRadioGroup,
       'procedure FlipChildren(AllLevels: Boolean); override;',
       @TCustomRadioGroup.FlipChildren);
  // End of class TCustomRadioGroup
  // Begin of class TRadioGroup
  RegisterClassType(TRadioGroup, H);
  RegisterMethod(TRadioGroup,
       'constructor Create(AOwner: TComponent); override;',
       @TRadioGroup.Create);
  // End of class TRadioGroup
  RegisterRTTIType(TypeInfo(TResizeStyle));
  // Begin of class TSplitter
  RegisterClassType(TSplitter, H);
  RegisterMethod(TSplitter,
       'constructor Create(AOwner: TComponent); override;',
       @TSplitter.Create);
  RegisterMethod(TSplitter,
       'destructor Destroy; override;',
       @TSplitter.Destroy);
  // End of class TSplitter
  RegisterRTTIType(TypeInfo(TBandPaintOption));
  // Begin of class TCustomControlBar
  RegisterClassType(TCustomControlBar, H);
  RegisterMethod(TCustomControlBar,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomControlBar.Create);
  RegisterMethod(TCustomControlBar,
       'destructor Destroy; override;',
       @TCustomControlBar.Destroy);
  RegisterMethod(TCustomControlBar,
       'procedure FlipChildren(AllLevels: Boolean); override;',
       @TCustomControlBar.FlipChildren);
  RegisterMethod(TCustomControlBar,
       'procedure StickControls; virtual;',
       @TCustomControlBar.StickControls);
  RegisterMethod(TCustomControlBar,
       'function TCustomControlBar_GetPicture:TPicture;',
       @TCustomControlBar_GetPicture, Fake);
  RegisterMethod(TCustomControlBar,
       'procedure TCustomControlBar_PutPicture(const Value: TPicture);',
       @TCustomControlBar_PutPicture, Fake);
  RegisterProperty(TCustomControlBar,
       'property Picture:TPicture read TCustomControlBar_GetPicture write TCustomControlBar_PutPicture;');
  // End of class TCustomControlBar
  // Begin of class TControlBar
  RegisterClassType(TControlBar, H);
  RegisterMethod(TControlBar,
       'constructor Create(AOwner: TComponent); override;',
       @TControlBar.Create);
  // End of class TControlBar
  RegisterRoutine('procedure Frame3D(Canvas: TCanvas; var Rect: TRect;  TopColor, BottomColor: TColor; Width: Integer);', @Frame3D, H);
  RegisterRoutine('procedure NotebookHandlesNeeded(Notebook: TNotebook);', @NotebookHandlesNeeded, H);
end;
initialization
  RegisterIMP_extctrls;
end.
