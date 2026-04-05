unit IMP_Forms;
interface
uses
  Messages,
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Menus,
  Controls,
  Imm,
  ActnList,
  MultiMon,
  forms,
  PaxScripter;
procedure RegisterIMP_Forms;
implementation
function TControlScrollBar_GetKind:TScrollBarKind;
begin
  result := TControlScrollBar(_Self).Kind;
end;
function TControlScrollBar_GetScrollPos:Integer;
begin
  result := TControlScrollBar(_Self).ScrollPos;
end;
function TCustomForm_GetActive:Boolean;
begin
  result := TCustomForm(_Self).Active;
end;
function TCustomForm_GetActiveControl:TWinControl;
begin
  result := TCustomForm(_Self).ActiveControl;
end;
procedure TCustomForm_PutActiveControl(const Value: TWinControl);
begin
  TCustomForm(_Self).ActiveControl := Value;
end;
function TCustomForm_GetActiveOleControl:TWinControl;
begin
  result := TCustomForm(_Self).ActiveOleControl;
end;
procedure TCustomForm_PutActiveOleControl(const Value: TWinControl);
begin
  TCustomForm(_Self).ActiveOleControl := Value;
end;
function TCustomForm_GetBorderStyle:TFormBorderStyle;
begin
  result := TCustomForm(_Self).BorderStyle;
end;
procedure TCustomForm_PutBorderStyle(const Value: TFormBorderStyle);
begin
  TCustomForm(_Self).BorderStyle := Value;
end;
function TCustomForm_GetCanvas:TCanvas;
begin
  result := TCustomForm(_Self).Canvas;
end;
function TCustomForm_GetDropTarget:Boolean;
begin
  result := TCustomForm(_Self).DropTarget;
end;
procedure TCustomForm_PutDropTarget(const Value: Boolean);
begin
  TCustomForm(_Self).DropTarget := Value;
end;
function TCustomForm_GetFormState:TFormState;
begin
  result := TCustomForm(_Self).FormState;
end;
function TCustomForm_GetHelpFile:String;
begin
  result := TCustomForm(_Self).HelpFile;
end;
procedure TCustomForm_PutHelpFile(const Value: String);
begin
  TCustomForm(_Self).HelpFile := Value;
end;
function TCustomForm_GetKeyPreview:Boolean;
begin
  result := TCustomForm(_Self).KeyPreview;
end;
procedure TCustomForm_PutKeyPreview(const Value: Boolean);
begin
  TCustomForm(_Self).KeyPreview := Value;
end;
function TCustomForm_GetMenu:TMainMenu;
begin
  result := TCustomForm(_Self).Menu;
end;
procedure TCustomForm_PutMenu(const Value: TMainMenu);
begin
  TCustomForm(_Self).Menu := Value;
end;
function TCustomForm_GetModalResult:TModalResult;
begin
  result := TCustomForm(_Self).ModalResult;
end;
procedure TCustomForm_PutModalResult(const Value: TModalResult);
begin
  TCustomForm(_Self).ModalResult := Value;
end;
function TCustomForm_GetMonitor:TMonitor;
begin
  result := TCustomForm(_Self).Monitor;
end;
function TCustomForm_GetOleFormObject:IOleForm;
begin
  result := TCustomForm(_Self).OleFormObject;
end;
procedure TCustomForm_PutOleFormObject(const Value: IOleForm);
begin
  TCustomForm(_Self).OleFormObject := Value;
end;
function TCustomForm_GetWindowState:TWindowState;
begin
  result := TCustomForm(_Self).WindowState;
end;
procedure TCustomForm_PutWindowState(const Value: TWindowState);
begin
  TCustomForm(_Self).WindowState := Value;
end;
function TDataModule_GetDesignOffset:TPoint;
begin
  result := TDataModule(_Self).DesignOffset;
end;
procedure TDataModule_PutDesignOffset(const Value: TPoint);
begin
  TDataModule(_Self).DesignOffset := Value;
end;
function TDataModule_GetDesignSize:TPoint;
begin
  result := TDataModule(_Self).DesignSize;
end;
procedure TDataModule_PutDesignSize(const Value: TPoint);
begin
  TDataModule(_Self).DesignSize := Value;
end;
function TMonitor_GetHandle:HMONITOR;
begin
  result := TMonitor(_Self).Handle;
end;
function TMonitor_GetMonitorNum:Integer;
begin
  result := TMonitor(_Self).MonitorNum;
end;
function TMonitor_GetLeft:Integer;
begin
  result := TMonitor(_Self).Left;
end;
function TMonitor_GetHeight:Integer;
begin
  result := TMonitor(_Self).Height;
end;
function TMonitor_GetTop:Integer;
begin
  result := TMonitor(_Self).Top;
end;
function TMonitor_GetWidth:Integer;
begin
  result := TMonitor(_Self).Width;
end;
function TScreen_GetActiveControl:TWinControl;
begin
  result := TScreen(_Self).ActiveControl;
end;
function TScreen_GetActiveCustomForm:TCustomForm;
begin
  result := TScreen(_Self).ActiveCustomForm;
end;
function TScreen_GetActiveForm:TForm;
begin
  result := TScreen(_Self).ActiveForm;
end;
function TScreen_GetCustomFormCount:Integer;
begin
  result := TScreen(_Self).CustomFormCount;
end;
function TScreen_GetCustomForms(Index: Integer):TCustomForm;
begin
  result := TScreen(_Self).CustomForms[Index];
end;
function TScreen_GetCursor:TCursor;
begin
  result := TScreen(_Self).Cursor;
end;
procedure TScreen_PutCursor(const Value: TCursor);
begin
  TScreen(_Self).Cursor := Value;
end;
function TScreen_GetCursors(Index: Integer):HCURSOR;
begin
  result := TScreen(_Self).Cursors[Index];
end;
procedure TScreen_PutCursors(Index: Integer;const Value: HCURSOR);
begin
  TScreen(_Self).Cursors[Index] := Value;
end;
function TScreen_GetDataModules(Index: Integer):TDataModule;
begin
  result := TScreen(_Self).DataModules[Index];
end;
function TScreen_GetDataModuleCount:Integer;
begin
  result := TScreen(_Self).DataModuleCount;
end;
function TScreen_GetMonitorCount:Integer;
begin
  result := TScreen(_Self).MonitorCount;
end;
function TScreen_GetMonitors(Index: Integer):TMonitor;
begin
  result := TScreen(_Self).Monitors[Index];
end;
function TScreen_GetDesktopHeight:Integer;
begin
  result := TScreen(_Self).DesktopHeight;
end;
function TScreen_GetDesktopLeft:Integer;
begin
  result := TScreen(_Self).DesktopLeft;
end;
function TScreen_GetDesktopTop:Integer;
begin
  result := TScreen(_Self).DesktopTop;
end;
function TScreen_GetDesktopWidth:Integer;
begin
  result := TScreen(_Self).DesktopWidth;
end;
function TScreen_GetHintFont:TFont;
begin
  result := TScreen(_Self).HintFont;
end;
procedure TScreen_PutHintFont(const Value: TFont);
begin
  TScreen(_Self).HintFont := Value;
end;
function TScreen_GetIconFont:TFont;
begin
  result := TScreen(_Self).IconFont;
end;
procedure TScreen_PutIconFont(const Value: TFont);
begin
  TScreen(_Self).IconFont := Value;
end;
function TScreen_GetMenuFont:TFont;
begin
  result := TScreen(_Self).MenuFont;
end;
procedure TScreen_PutMenuFont(const Value: TFont);
begin
  TScreen(_Self).MenuFont := Value;
end;
function TScreen_GetFonts:TStrings;
begin
  result := TScreen(_Self).Fonts;
end;
function TScreen_GetFormCount:Integer;
begin
  result := TScreen(_Self).FormCount;
end;
function TScreen_GetForms(Index: Integer):TForm;
begin
  result := TScreen(_Self).Forms[Index];
end;
function TScreen_GetImes:TStrings;
begin
  result := TScreen(_Self).Imes;
end;
function TScreen_GetDefaultIme:String;
begin
  result := TScreen(_Self).DefaultIme;
end;
function TScreen_GetDefaultKbLayout:HKL;
begin
  result := TScreen(_Self).DefaultKbLayout;
end;
function TScreen_GetHeight:Integer;
begin
  result := TScreen(_Self).Height;
end;
function TScreen_GetPixelsPerInch:Integer;
begin
  result := TScreen(_Self).PixelsPerInch;
end;
function TScreen_GetWidth:Integer;
begin
  result := TScreen(_Self).Width;
end;
function TApplication_GetActive:Boolean;
begin
  result := TApplication(_Self).Active;
end;
function TApplication_GetAllowTesting:Boolean;
begin
  result := TApplication(_Self).AllowTesting;
end;
procedure TApplication_PutAllowTesting(const Value: Boolean);
begin
  TApplication(_Self).AllowTesting := Value;
end;
function TApplication_GetCurrentHelpFile:String;
begin
  result := TApplication(_Self).CurrentHelpFile;
end;
function TApplication_GetDialogHandle:HWnd;
begin
  result := TApplication(_Self).DialogHandle;
end;
procedure TApplication_PutDialogHandle(const Value: HWnd);
begin
  TApplication(_Self).DialogHandle := Value;
end;
function TApplication_GetExeName:String;
begin
  result := TApplication(_Self).ExeName;
end;
function TApplication_GetHandle:HWnd;
begin
  result := TApplication(_Self).Handle;
end;
procedure TApplication_PutHandle(const Value: HWnd);
begin
  TApplication(_Self).Handle := Value;
end;
function TApplication_GetHelpFile:String;
begin
  result := TApplication(_Self).HelpFile;
end;
procedure TApplication_PutHelpFile(const Value: String);
begin
  TApplication(_Self).HelpFile := Value;
end;
function TApplication_GetHint:String;
begin
  result := TApplication(_Self).Hint;
end;
procedure TApplication_PutHint(const Value: String);
begin
  TApplication(_Self).Hint := Value;
end;
function TApplication_GetHintColor:TColor;
begin
  result := TApplication(_Self).HintColor;
end;
procedure TApplication_PutHintColor(const Value: TColor);
begin
  TApplication(_Self).HintColor := Value;
end;
function TApplication_GetHintHidePause:Integer;
begin
  result := TApplication(_Self).HintHidePause;
end;
procedure TApplication_PutHintHidePause(const Value: Integer);
begin
  TApplication(_Self).HintHidePause := Value;
end;
function TApplication_GetHintPause:Integer;
begin
  result := TApplication(_Self).HintPause;
end;
procedure TApplication_PutHintPause(const Value: Integer);
begin
  TApplication(_Self).HintPause := Value;
end;
function TApplication_GetHintShortCuts:Boolean;
begin
  result := TApplication(_Self).HintShortCuts;
end;
procedure TApplication_PutHintShortCuts(const Value: Boolean);
begin
  TApplication(_Self).HintShortCuts := Value;
end;
function TApplication_GetHintShortPause:Integer;
begin
  result := TApplication(_Self).HintShortPause;
end;
procedure TApplication_PutHintShortPause(const Value: Integer);
begin
  TApplication(_Self).HintShortPause := Value;
end;
function TApplication_GetIcon:TIcon;
begin
  result := TApplication(_Self).Icon;
end;
procedure TApplication_PutIcon(const Value: TIcon);
begin
  TApplication(_Self).Icon := Value;
end;
function TApplication_GetMainForm:TForm;
begin
  result := TApplication(_Self).MainForm;
end;
function TApplication_GetBiDiMode:TBiDiMode;
begin
  result := TApplication(_Self).BiDiMode;
end;
procedure TApplication_PutBiDiMode(const Value: TBiDiMode);
begin
  TApplication(_Self).BiDiMode := Value;
end;
function TApplication_GetBiDiKeyboard:String;
begin
  result := TApplication(_Self).BiDiKeyboard;
end;
procedure TApplication_PutBiDiKeyboard(const Value: String);
begin
  TApplication(_Self).BiDiKeyboard := Value;
end;
function TApplication_GetNonBiDiKeyboard:String;
begin
  result := TApplication(_Self).NonBiDiKeyboard;
end;
procedure TApplication_PutNonBiDiKeyboard(const Value: String);
begin
  TApplication(_Self).NonBiDiKeyboard := Value;
end;
function TApplication_GetShowHint:Boolean;
begin
  result := TApplication(_Self).ShowHint;
end;
procedure TApplication_PutShowHint(const Value: Boolean);
begin
  TApplication(_Self).ShowHint := Value;
end;
function TApplication_GetShowMainForm:Boolean;
begin
  result := TApplication(_Self).ShowMainForm;
end;
procedure TApplication_PutShowMainForm(const Value: Boolean);
begin
  TApplication(_Self).ShowMainForm := Value;
end;
function TApplication_GetTerminated:Boolean;
begin
  result := TApplication(_Self).Terminated;
end;
function TApplication_GetTitle:String;
begin
  result := TApplication(_Self).Title;
end;
procedure TApplication_PutTitle(const Value: String);
begin
  TApplication(_Self).Title := Value;
end;
function TApplication_GetUpdateFormatSettings:Boolean;
begin
  result := TApplication(_Self).UpdateFormatSettings;
end;
procedure TApplication_PutUpdateFormatSettings(const Value: Boolean);
begin
  TApplication(_Self).UpdateFormatSettings := Value;
end;
function TApplication_GetUpdateMetricSettings:Boolean;
begin
  result := TApplication(_Self).UpdateMetricSettings;
end;
procedure TApplication_PutUpdateMetricSettings(const Value: Boolean);
begin
  TApplication(_Self).UpdateMetricSettings := Value;
end;
procedure RegisterIMP_Forms;
var H: Integer;
begin
  H := RegisterNamespace('Forms', -1);
  RegisterRTTIType(TypeInfo(TScrollBarKind));
  RegisterRTTIType(TypeInfo(TScrollBarStyle));
  // Begin of class TControlScrollBar
  RegisterClassType(TControlScrollBar, H);
  RegisterMethod(TControlScrollBar,
       'procedure Assign(Source: TPersistent); override;',
       @TControlScrollBar.Assign);
  RegisterMethod(TControlScrollBar,
       'procedure ChangeBiDiPosition;',
       @TControlScrollBar.ChangeBiDiPosition);
  RegisterMethod(TControlScrollBar,
       'function TControlScrollBar_GetKind:TScrollBarKind;',
       @TControlScrollBar_GetKind, Fake);
  RegisterProperty(TControlScrollBar,
       'property Kind:TScrollBarKind read TControlScrollBar_GetKind;');
  RegisterMethod(TControlScrollBar,
       'function IsScrollBarVisible: Boolean;',
       @TControlScrollBar.IsScrollBarVisible);
  RegisterMethod(TControlScrollBar,
       'function TControlScrollBar_GetScrollPos:Integer;',
       @TControlScrollBar_GetScrollPos, Fake);
  RegisterProperty(TControlScrollBar,
       'property ScrollPos:Integer read TControlScrollBar_GetScrollPos;');
  RegisterMethod(TControlScrollBar,
       'constructor Create;',
       @TControlScrollBar.Create);
  // End of class TControlScrollBar
  RegisterRTTIType(TypeInfo(TWindowState));
  // Begin of class TScrollingWinControl
  RegisterClassType(TScrollingWinControl, H);
  RegisterMethod(TScrollingWinControl,
       'constructor Create(AOwner: TComponent); override;',
       @TScrollingWinControl.Create);
  RegisterMethod(TScrollingWinControl,
       'destructor Destroy; override;',
       @TScrollingWinControl.Destroy);
  RegisterMethod(TScrollingWinControl,
       'procedure DisableAutoRange;',
       @TScrollingWinControl.DisableAutoRange);
  RegisterMethod(TScrollingWinControl,
       'procedure EnableAutoRange;',
       @TScrollingWinControl.EnableAutoRange);
  RegisterMethod(TScrollingWinControl,
       'procedure ScrollInView(AControl: TControl);',
       @TScrollingWinControl.ScrollInView);
  // End of class TScrollingWinControl
  RegisterRTTIType(TypeInfo(TFormBorderStyle));
  // Begin of class TScrollBox
  RegisterClassType(TScrollBox, H);
  RegisterMethod(TScrollBox,
       'constructor Create(AOwner: TComponent); override;',
       @TScrollBox.Create);
  // End of class TScrollBox
  // Begin of class TCustomFrame
  RegisterClassType(TCustomFrame, H);
  RegisterMethod(TCustomFrame,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomFrame.Create);
  // End of class TCustomFrame
  // Begin of class TFrame
  RegisterClassType(TFrame, H);
  RegisterMethod(TFrame,
       'constructor Create(AOwner: TComponent); override;',
       @TFrame.Create);
  // End of class TFrame
  RegisterRTTIType(TypeInfo(TFormStyle));
  RegisterRTTIType(TypeInfo(TBorderIcon));
  RegisterRTTIType(TypeInfo(TPosition));
  RegisterRTTIType(TypeInfo(TDefaultMonitor));
  RegisterRTTIType(TypeInfo(TPrintScale));
  RegisterRTTIType(TypeInfo(TShowAction));
  RegisterRTTIType(TypeInfo(TTileMode));
  RegisterRTTIType(TypeInfo(TCloseAction));
  // Begin of class TCustomForm
  RegisterClassType(TCustomForm, H);
  RegisterMethod(TCustomForm,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomForm.Create);
  RegisterMethod(TCustomForm,
       'constructor CreateNew(AOwner: TComponent; Dummy: Integer);',
       @TCustomForm.CreateNew);
  RegisterMethod(TCustomForm,
       'destructor Destroy; override;',
       @TCustomForm.Destroy);
  RegisterMethod(TCustomForm,
       'procedure AfterConstruction; override;',
       @TCustomForm.AfterConstruction);
  RegisterMethod(TCustomForm,
       'procedure BeforeDestruction; override;',
       @TCustomForm.BeforeDestruction);
  RegisterMethod(TCustomForm,
       'procedure Close;',
       @TCustomForm.Close);
  RegisterMethod(TCustomForm,
       'function CloseQuery: Boolean; virtual;',
       @TCustomForm.CloseQuery);
  RegisterMethod(TCustomForm,
       'procedure DefaultHandler(var Message); override;',
       @TCustomForm.DefaultHandler);
  RegisterMethod(TCustomForm,
       'procedure DefocusControl(Control: TWinControl; Removing: Boolean);',
       @TCustomForm.DefocusControl);
  RegisterMethod(TCustomForm,
       'procedure Dock(NewDockSite: TWinControl; ARect: TRect); override;',
       @TCustomForm.Dock);
  RegisterMethod(TCustomForm,
       'procedure FocusControl(Control: TWinControl);',
       @TCustomForm.FocusControl);
  RegisterMethod(TCustomForm,
       'function GetFormImage: TBitmap;',
       @TCustomForm.GetFormImage);
  RegisterMethod(TCustomForm,
       'procedure Hide;',
       @TCustomForm.Hide);
  RegisterMethod(TCustomForm,
       'function IsShortCut(var Message: TWMKey): Boolean; dynamic;',
       @TCustomForm.IsShortCut);
  RegisterMethod(TCustomForm,
       'procedure MouseWheelHandler(var Message: TMessage); override;',
       @TCustomForm.MouseWheelHandler);
  RegisterMethod(TCustomForm,
       'procedure Print;',
       @TCustomForm.Print);
  RegisterMethod(TCustomForm,
       'procedure Release;',
       @TCustomForm.Release);
  RegisterMethod(TCustomForm,
       'procedure SendCancelMode(Sender: TControl);',
       @TCustomForm.SendCancelMode);
  RegisterMethod(TCustomForm,
       'procedure SetFocus; override;',
       @TCustomForm.SetFocus);
  RegisterMethod(TCustomForm,
       'function SetFocusedControl(Control: TWinControl): Boolean; virtual;',
       @TCustomForm.SetFocusedControl);
  RegisterMethod(TCustomForm,
       'procedure Show;',
       @TCustomForm.Show);
  RegisterMethod(TCustomForm,
       'function ShowModal: Integer; virtual;',
       @TCustomForm.ShowModal);
  RegisterMethod(TCustomForm,
       'function WantChildKey(Child: TControl; var Message: TMessage): Boolean; virtual;',
       @TCustomForm.WantChildKey);
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetActive:Boolean;',
       @TCustomForm_GetActive, Fake);
  RegisterProperty(TCustomForm,
       'property Active:Boolean read TCustomForm_GetActive;');
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetActiveControl:TWinControl;',
       @TCustomForm_GetActiveControl, Fake);
  RegisterMethod(TCustomForm,
       'procedure TCustomForm_PutActiveControl(const Value: TWinControl);',
       @TCustomForm_PutActiveControl, Fake);
  RegisterProperty(TCustomForm,
       'property ActiveControl:TWinControl read TCustomForm_GetActiveControl write TCustomForm_PutActiveControl;');
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetActiveOleControl:TWinControl;',
       @TCustomForm_GetActiveOleControl, Fake);
  RegisterMethod(TCustomForm,
       'procedure TCustomForm_PutActiveOleControl(const Value: TWinControl);',
       @TCustomForm_PutActiveOleControl, Fake);
  RegisterProperty(TCustomForm,
       'property ActiveOleControl:TWinControl read TCustomForm_GetActiveOleControl write TCustomForm_PutActiveOleControl;');
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetBorderStyle:TFormBorderStyle;',
       @TCustomForm_GetBorderStyle, Fake);
  RegisterMethod(TCustomForm,
       'procedure TCustomForm_PutBorderStyle(const Value: TFormBorderStyle);',
       @TCustomForm_PutBorderStyle, Fake);
  RegisterProperty(TCustomForm,
       'property BorderStyle:TFormBorderStyle read TCustomForm_GetBorderStyle write TCustomForm_PutBorderStyle;');
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetCanvas:TCanvas;',
       @TCustomForm_GetCanvas, Fake);
  RegisterProperty(TCustomForm,
       'property Canvas:TCanvas read TCustomForm_GetCanvas;');
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetDropTarget:Boolean;',
       @TCustomForm_GetDropTarget, Fake);
  RegisterMethod(TCustomForm,
       'procedure TCustomForm_PutDropTarget(const Value: Boolean);',
       @TCustomForm_PutDropTarget, Fake);
  RegisterProperty(TCustomForm,
       'property DropTarget:Boolean read TCustomForm_GetDropTarget write TCustomForm_PutDropTarget;');
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetFormState:TFormState;',
       @TCustomForm_GetFormState, Fake);
  RegisterProperty(TCustomForm,
       'property FormState:TFormState read TCustomForm_GetFormState;');
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetHelpFile:String;',
       @TCustomForm_GetHelpFile, Fake);
  RegisterMethod(TCustomForm,
       'procedure TCustomForm_PutHelpFile(const Value: String);',
       @TCustomForm_PutHelpFile, Fake);
  RegisterProperty(TCustomForm,
       'property HelpFile:String read TCustomForm_GetHelpFile write TCustomForm_PutHelpFile;');
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetKeyPreview:Boolean;',
       @TCustomForm_GetKeyPreview, Fake);
  RegisterMethod(TCustomForm,
       'procedure TCustomForm_PutKeyPreview(const Value: Boolean);',
       @TCustomForm_PutKeyPreview, Fake);
  RegisterProperty(TCustomForm,
       'property KeyPreview:Boolean read TCustomForm_GetKeyPreview write TCustomForm_PutKeyPreview;');
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetMenu:TMainMenu;',
       @TCustomForm_GetMenu, Fake);
  RegisterMethod(TCustomForm,
       'procedure TCustomForm_PutMenu(const Value: TMainMenu);',
       @TCustomForm_PutMenu, Fake);
  RegisterProperty(TCustomForm,
       'property Menu:TMainMenu read TCustomForm_GetMenu write TCustomForm_PutMenu;');
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetModalResult:TModalResult;',
       @TCustomForm_GetModalResult, Fake);
  RegisterMethod(TCustomForm,
       'procedure TCustomForm_PutModalResult(const Value: TModalResult);',
       @TCustomForm_PutModalResult, Fake);
  RegisterProperty(TCustomForm,
       'property ModalResult:TModalResult read TCustomForm_GetModalResult write TCustomForm_PutModalResult;');
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetMonitor:TMonitor;',
       @TCustomForm_GetMonitor, Fake);
  RegisterProperty(TCustomForm,
       'property Monitor:TMonitor read TCustomForm_GetMonitor;');
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetOleFormObject:IOleForm;',
       @TCustomForm_GetOleFormObject, Fake);
  RegisterMethod(TCustomForm,
       'procedure TCustomForm_PutOleFormObject(const Value: IOleForm);',
       @TCustomForm_PutOleFormObject, Fake);
  RegisterProperty(TCustomForm,
       'property OleFormObject:IOleForm read TCustomForm_GetOleFormObject write TCustomForm_PutOleFormObject;');
  RegisterMethod(TCustomForm,
       'function TCustomForm_GetWindowState:TWindowState;',
       @TCustomForm_GetWindowState, Fake);
  RegisterMethod(TCustomForm,
       'procedure TCustomForm_PutWindowState(const Value: TWindowState);',
       @TCustomForm_PutWindowState, Fake);
  RegisterProperty(TCustomForm,
       'property WindowState:TWindowState read TCustomForm_GetWindowState write TCustomForm_PutWindowState;');
  // End of class TCustomForm
  RegisterRTTIType(TypeInfo(TActiveFormBorderStyle));
  // Begin of class TCustomActiveForm
  RegisterClassType(TCustomActiveForm, H);
  RegisterMethod(TCustomActiveForm,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomActiveForm.Create);
  RegisterMethod(TCustomActiveForm,
       'function WantChildKey(Child: TControl; var Message: TMessage): Boolean; override;',
       @TCustomActiveForm.WantChildKey);
  // End of class TCustomActiveForm
  // Begin of class TForm
  RegisterClassType(TForm, H);
  RegisterMethod(TForm,
       'procedure ArrangeIcons;',
       @TForm.ArrangeIcons);
  RegisterMethod(TForm,
       'procedure Cascade;',
       @TForm.Cascade);
  RegisterMethod(TForm,
       'procedure Next;',
       @TForm.Next);
  RegisterMethod(TForm,
       'procedure Previous;',
       @TForm.Previous);
  RegisterMethod(TForm,
       'procedure Tile;',
       @TForm.Tile);
  RegisterMethod(TForm,
       'constructor Create(AOwner: TComponent); override;',
       @TForm.Create);
  // End of class TForm
  // Begin of class TCustomDockForm
  RegisterClassType(TCustomDockForm, H);
  RegisterMethod(TCustomDockForm,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomDockForm.Create);
  // End of class TCustomDockForm
  // Begin of class TDataModule
  RegisterClassType(TDataModule, H);
  RegisterMethod(TDataModule,
       'constructor Create(AOwner: TComponent); override;',
       @TDataModule.Create);
  RegisterMethod(TDataModule,
       'destructor Destroy; override;',
       @TDataModule.Destroy);
  RegisterMethod(TDataModule,
       'procedure AfterConstruction; override;',
       @TDataModule.AfterConstruction);
  RegisterMethod(TDataModule,
       'procedure BeforeDestruction; override;',
       @TDataModule.BeforeDestruction);
  RegisterMethod(TDataModule,
       'function TDataModule_GetDesignOffset:TPoint;',
       @TDataModule_GetDesignOffset, Fake);
  RegisterMethod(TDataModule,
       'procedure TDataModule_PutDesignOffset(const Value: TPoint);',
       @TDataModule_PutDesignOffset, Fake);
  RegisterProperty(TDataModule,
       'property DesignOffset:TPoint read TDataModule_GetDesignOffset write TDataModule_PutDesignOffset;');
  RegisterMethod(TDataModule,
       'function TDataModule_GetDesignSize:TPoint;',
       @TDataModule_GetDesignSize, Fake);
  RegisterMethod(TDataModule,
       'procedure TDataModule_PutDesignSize(const Value: TPoint);',
       @TDataModule_PutDesignSize, Fake);
  RegisterProperty(TDataModule,
       'property DesignSize:TPoint read TDataModule_GetDesignSize write TDataModule_PutDesignSize;');
  // End of class TDataModule
  // Begin of class TMonitor
  RegisterClassType(TMonitor, H);
  RegisterMethod(TMonitor,
       'function TMonitor_GetHandle:HMONITOR;',
       @TMonitor_GetHandle, Fake);
  RegisterProperty(TMonitor,
       'property Handle:HMONITOR read TMonitor_GetHandle;');
  RegisterMethod(TMonitor,
       'function TMonitor_GetMonitorNum:Integer;',
       @TMonitor_GetMonitorNum, Fake);
  RegisterProperty(TMonitor,
       'property MonitorNum:Integer read TMonitor_GetMonitorNum;');
  RegisterMethod(TMonitor,
       'function TMonitor_GetLeft:Integer;',
       @TMonitor_GetLeft, Fake);
  RegisterProperty(TMonitor,
       'property Left:Integer read TMonitor_GetLeft;');
  RegisterMethod(TMonitor,
       'function TMonitor_GetHeight:Integer;',
       @TMonitor_GetHeight, Fake);
  RegisterProperty(TMonitor,
       'property Height:Integer read TMonitor_GetHeight;');
  RegisterMethod(TMonitor,
       'function TMonitor_GetTop:Integer;',
       @TMonitor_GetTop, Fake);
  RegisterProperty(TMonitor,
       'property Top:Integer read TMonitor_GetTop;');
  RegisterMethod(TMonitor,
       'function TMonitor_GetWidth:Integer;',
       @TMonitor_GetWidth, Fake);
  RegisterProperty(TMonitor,
       'property Width:Integer read TMonitor_GetWidth;');
  RegisterMethod(TMonitor,
       'constructor Create;',
       @TMonitor.Create);
  // End of class TMonitor
  // Begin of class TScreen
  RegisterClassType(TScreen, H);
  RegisterMethod(TScreen,
       'constructor Create(AOwner: TComponent); override;',
       @TScreen.Create);
  RegisterMethod(TScreen,
       'destructor Destroy; override;',
       @TScreen.Destroy);
  RegisterMethod(TScreen,
       'procedure DisableAlign;',
       @TScreen.DisableAlign);
  RegisterMethod(TScreen,
       'procedure EnableAlign;',
       @TScreen.EnableAlign);
  RegisterMethod(TScreen,
       'procedure Realign;',
       @TScreen.Realign);
  RegisterMethod(TScreen,
       'procedure ResetFonts;',
       @TScreen.ResetFonts);
  RegisterMethod(TScreen,
       'function TScreen_GetActiveControl:TWinControl;',
       @TScreen_GetActiveControl, Fake);
  RegisterProperty(TScreen,
       'property ActiveControl:TWinControl read TScreen_GetActiveControl;');
  RegisterMethod(TScreen,
       'function TScreen_GetActiveCustomForm:TCustomForm;',
       @TScreen_GetActiveCustomForm, Fake);
  RegisterProperty(TScreen,
       'property ActiveCustomForm:TCustomForm read TScreen_GetActiveCustomForm;');
  RegisterMethod(TScreen,
       'function TScreen_GetActiveForm:TForm;',
       @TScreen_GetActiveForm, Fake);
  RegisterProperty(TScreen,
       'property ActiveForm:TForm read TScreen_GetActiveForm;');
  RegisterMethod(TScreen,
       'function TScreen_GetCustomFormCount:Integer;',
       @TScreen_GetCustomFormCount, Fake);
  RegisterProperty(TScreen,
       'property CustomFormCount:Integer read TScreen_GetCustomFormCount;');
  RegisterMethod(TScreen,
       'function TScreen_GetCustomForms(Index: Integer):TCustomForm;',
       @TScreen_GetCustomForms, Fake);
  RegisterProperty(TScreen,
       'property CustomForms[Index: Integer]:TCustomForm read TScreen_GetCustomForms;');
  RegisterMethod(TScreen,
       'function TScreen_GetCursor:TCursor;',
       @TScreen_GetCursor, Fake);
  RegisterMethod(TScreen,
       'procedure TScreen_PutCursor(const Value: TCursor);',
       @TScreen_PutCursor, Fake);
  RegisterProperty(TScreen,
       'property Cursor:TCursor read TScreen_GetCursor write TScreen_PutCursor;');
  RegisterMethod(TScreen,
       'function TScreen_GetCursors(Index: Integer):HCURSOR;',
       @TScreen_GetCursors, Fake);
  RegisterMethod(TScreen,
       'procedure TScreen_PutCursors(Index: Integer;const Value: HCURSOR);',
       @TScreen_PutCursors, Fake);
  RegisterProperty(TScreen,
       'property Cursors[Index: Integer]:HCURSOR read TScreen_GetCursors write TScreen_PutCursors;');
  RegisterMethod(TScreen,
       'function TScreen_GetDataModules(Index: Integer):TDataModule;',
       @TScreen_GetDataModules, Fake);
  RegisterProperty(TScreen,
       'property DataModules[Index: Integer]:TDataModule read TScreen_GetDataModules;');
  RegisterMethod(TScreen,
       'function TScreen_GetDataModuleCount:Integer;',
       @TScreen_GetDataModuleCount, Fake);
  RegisterProperty(TScreen,
       'property DataModuleCount:Integer read TScreen_GetDataModuleCount;');
  RegisterMethod(TScreen,
       'function TScreen_GetMonitorCount:Integer;',
       @TScreen_GetMonitorCount, Fake);
  RegisterProperty(TScreen,
       'property MonitorCount:Integer read TScreen_GetMonitorCount;');
  RegisterMethod(TScreen,
       'function TScreen_GetMonitors(Index: Integer):TMonitor;',
       @TScreen_GetMonitors, Fake);
  RegisterProperty(TScreen,
       'property Monitors[Index: Integer]:TMonitor read TScreen_GetMonitors;');
  RegisterMethod(TScreen,
       'function TScreen_GetDesktopHeight:Integer;',
       @TScreen_GetDesktopHeight, Fake);
  RegisterProperty(TScreen,
       'property DesktopHeight:Integer read TScreen_GetDesktopHeight;');
  RegisterMethod(TScreen,
       'function TScreen_GetDesktopLeft:Integer;',
       @TScreen_GetDesktopLeft, Fake);
  RegisterProperty(TScreen,
       'property DesktopLeft:Integer read TScreen_GetDesktopLeft;');
  RegisterMethod(TScreen,
       'function TScreen_GetDesktopTop:Integer;',
       @TScreen_GetDesktopTop, Fake);
  RegisterProperty(TScreen,
       'property DesktopTop:Integer read TScreen_GetDesktopTop;');
  RegisterMethod(TScreen,
       'function TScreen_GetDesktopWidth:Integer;',
       @TScreen_GetDesktopWidth, Fake);
  RegisterProperty(TScreen,
       'property DesktopWidth:Integer read TScreen_GetDesktopWidth;');
  RegisterMethod(TScreen,
       'function TScreen_GetHintFont:TFont;',
       @TScreen_GetHintFont, Fake);
  RegisterMethod(TScreen,
       'procedure TScreen_PutHintFont(const Value: TFont);',
       @TScreen_PutHintFont, Fake);
  RegisterProperty(TScreen,
       'property HintFont:TFont read TScreen_GetHintFont write TScreen_PutHintFont;');
  RegisterMethod(TScreen,
       'function TScreen_GetIconFont:TFont;',
       @TScreen_GetIconFont, Fake);
  RegisterMethod(TScreen,
       'procedure TScreen_PutIconFont(const Value: TFont);',
       @TScreen_PutIconFont, Fake);
  RegisterProperty(TScreen,
       'property IconFont:TFont read TScreen_GetIconFont write TScreen_PutIconFont;');
  RegisterMethod(TScreen,
       'function TScreen_GetMenuFont:TFont;',
       @TScreen_GetMenuFont, Fake);
  RegisterMethod(TScreen,
       'procedure TScreen_PutMenuFont(const Value: TFont);',
       @TScreen_PutMenuFont, Fake);
  RegisterProperty(TScreen,
       'property MenuFont:TFont read TScreen_GetMenuFont write TScreen_PutMenuFont;');
  RegisterMethod(TScreen,
       'function TScreen_GetFonts:TStrings;',
       @TScreen_GetFonts, Fake);
  RegisterProperty(TScreen,
       'property Fonts:TStrings read TScreen_GetFonts;');
  RegisterMethod(TScreen,
       'function TScreen_GetFormCount:Integer;',
       @TScreen_GetFormCount, Fake);
  RegisterProperty(TScreen,
       'property FormCount:Integer read TScreen_GetFormCount;');
  RegisterMethod(TScreen,
       'function TScreen_GetForms(Index: Integer):TForm;',
       @TScreen_GetForms, Fake);
  RegisterProperty(TScreen,
       'property Forms[Index: Integer]:TForm read TScreen_GetForms;');
  RegisterMethod(TScreen,
       'function TScreen_GetImes:TStrings;',
       @TScreen_GetImes, Fake);
  RegisterProperty(TScreen,
       'property Imes:TStrings read TScreen_GetImes;');
  RegisterMethod(TScreen,
       'function TScreen_GetDefaultIme:String;',
       @TScreen_GetDefaultIme, Fake);
  RegisterProperty(TScreen,
       'property DefaultIme:String read TScreen_GetDefaultIme;');
  RegisterMethod(TScreen,
       'function TScreen_GetDefaultKbLayout:HKL;',
       @TScreen_GetDefaultKbLayout, Fake);
  RegisterProperty(TScreen,
       'property DefaultKbLayout:HKL read TScreen_GetDefaultKbLayout;');
  RegisterMethod(TScreen,
       'function TScreen_GetHeight:Integer;',
       @TScreen_GetHeight, Fake);
  RegisterProperty(TScreen,
       'property Height:Integer read TScreen_GetHeight;');
  RegisterMethod(TScreen,
       'function TScreen_GetPixelsPerInch:Integer;',
       @TScreen_GetPixelsPerInch, Fake);
  RegisterProperty(TScreen,
       'property PixelsPerInch:Integer read TScreen_GetPixelsPerInch;');
  RegisterMethod(TScreen,
       'function TScreen_GetWidth:Integer;',
       @TScreen_GetWidth, Fake);
  RegisterProperty(TScreen,
       'property Width:Integer read TScreen_GetWidth;');
  // End of class TScreen
  RegisterRTTIType(TypeInfo(TTimerMode));
  // Begin of class TApplication
  RegisterClassType(TApplication, H);
  RegisterMethod(TApplication,
       'constructor Create(AOwner: TComponent); override;',
       @TApplication.Create);
  RegisterMethod(TApplication,
       'destructor Destroy; override;',
       @TApplication.Destroy);
  RegisterMethod(TApplication,
       'procedure ActivateHint(CursorPos: TPoint);',
       @TApplication.ActivateHint);
  RegisterMethod(TApplication,
       'procedure BringToFront;',
       @TApplication.BringToFront);
  RegisterMethod(TApplication,
       'procedure ControlDestroyed(Control: TControl);',
       @TApplication.ControlDestroyed);
  RegisterMethod(TApplication,
       'procedure CancelHint;',
       @TApplication.CancelHint);
  RegisterMethod(TApplication,
       'procedure CreateForm(InstanceClass: TComponentClass; var Reference);',
       @TApplication.CreateForm);
  RegisterMethod(TApplication,
       'procedure CreateHandle;',
       @TApplication.CreateHandle);
  RegisterMethod(TApplication,
       'function ExecuteAction(Action: TBasicAction): Boolean; reintroduce;',
       @TApplication.ExecuteAction);
  RegisterMethod(TApplication,
       'procedure HandleException(Sender: TObject);',
       @TApplication.HandleException);
  RegisterMethod(TApplication,
       'procedure HandleMessage;',
       @TApplication.HandleMessage);
  RegisterMethod(TApplication,
       'function HelpCommand(Command: Integer; Data: Longint): Boolean;',
       @TApplication.HelpCommand);
  RegisterMethod(TApplication,
       'function HelpContext(Context: THelpContext): Boolean;',
       @TApplication.HelpContext);
  RegisterMethod(TApplication,
       'function HelpJump(const JumpID: string): Boolean;',
       @TApplication.HelpJump);
  RegisterMethod(TApplication,
       'procedure HideHint;',
       @TApplication.HideHint);
  RegisterMethod(TApplication,
       'procedure HintMouseMessage(Control: TControl; var Message: TMessage);',
       @TApplication.HintMouseMessage);
  RegisterMethod(TApplication,
       'procedure HookMainWindow(Hook: TWindowHook);',
       @TApplication.HookMainWindow);
  RegisterMethod(TApplication,
       'procedure Initialize;',
       @TApplication.Initialize);
  RegisterMethod(TApplication,
       'function IsRightToLeft: Boolean;',
       @TApplication.IsRightToLeft);
  RegisterMethod(TApplication,
       'function MessageBox(const Text, Caption: PChar; Flags: Longint): Integer;',
       @TApplication.MessageBox);
  RegisterMethod(TApplication,
       'procedure Minimize;',
       @TApplication.Minimize);
  RegisterMethod(TApplication,
       'procedure NormalizeAllTopMosts;',
       @TApplication.NormalizeAllTopMosts);
  RegisterMethod(TApplication,
       'procedure NormalizeTopMosts;',
       @TApplication.NormalizeTopMosts);
  RegisterMethod(TApplication,
       'procedure ProcessMessages;',
       @TApplication.ProcessMessages);
  RegisterMethod(TApplication,
       'procedure Restore;',
       @TApplication.Restore);
  RegisterMethod(TApplication,
       'procedure RestoreTopMosts;',
       @TApplication.RestoreTopMosts);
  RegisterMethod(TApplication,
       'procedure Run;',
       @TApplication.Run);
  RegisterMethod(TApplication,
       'procedure ShowException(E: Exception);',
       @TApplication.ShowException);
  RegisterMethod(TApplication,
       'procedure Terminate;',
       @TApplication.Terminate);
  RegisterMethod(TApplication,
       'procedure UnhookMainWindow(Hook: TWindowHook);',
       @TApplication.UnhookMainWindow);
  RegisterMethod(TApplication,
       'function UpdateAction(Action: TBasicAction): Boolean; reintroduce;',
       @TApplication.UpdateAction);
  RegisterMethod(TApplication,
       'function UseRightToLeftAlignment: Boolean;',
       @TApplication.UseRightToLeftAlignment);
  RegisterMethod(TApplication,
       'function UseRightToLeftReading: Boolean;',
       @TApplication.UseRightToLeftReading);
  RegisterMethod(TApplication,
       'function UseRightToLeftScrollBar: Boolean;',
       @TApplication.UseRightToLeftScrollBar);
  RegisterMethod(TApplication,
       'function TApplication_GetActive:Boolean;',
       @TApplication_GetActive, Fake);
  RegisterProperty(TApplication,
       'property Active:Boolean read TApplication_GetActive;');
  RegisterMethod(TApplication,
       'function TApplication_GetAllowTesting:Boolean;',
       @TApplication_GetAllowTesting, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutAllowTesting(const Value: Boolean);',
       @TApplication_PutAllowTesting, Fake);
  RegisterProperty(TApplication,
       'property AllowTesting:Boolean read TApplication_GetAllowTesting write TApplication_PutAllowTesting;');
  RegisterMethod(TApplication,
       'function TApplication_GetCurrentHelpFile:String;',
       @TApplication_GetCurrentHelpFile, Fake);
  RegisterProperty(TApplication,
       'property CurrentHelpFile:String read TApplication_GetCurrentHelpFile;');
  RegisterMethod(TApplication,
       'function TApplication_GetDialogHandle:HWnd;',
       @TApplication_GetDialogHandle, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutDialogHandle(const Value: HWnd);',
       @TApplication_PutDialogHandle, Fake);
  RegisterProperty(TApplication,
       'property DialogHandle:HWnd read TApplication_GetDialogHandle write TApplication_PutDialogHandle;');
  RegisterMethod(TApplication,
       'function TApplication_GetExeName:String;',
       @TApplication_GetExeName, Fake);
  RegisterProperty(TApplication,
       'property ExeName:String read TApplication_GetExeName;');
  RegisterMethod(TApplication,
       'function TApplication_GetHandle:HWnd;',
       @TApplication_GetHandle, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutHandle(const Value: HWnd);',
       @TApplication_PutHandle, Fake);
  RegisterProperty(TApplication,
       'property Handle:HWnd read TApplication_GetHandle write TApplication_PutHandle;');
  RegisterMethod(TApplication,
       'function TApplication_GetHelpFile:String;',
       @TApplication_GetHelpFile, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutHelpFile(const Value: String);',
       @TApplication_PutHelpFile, Fake);
  RegisterProperty(TApplication,
       'property HelpFile:String read TApplication_GetHelpFile write TApplication_PutHelpFile;');
  RegisterMethod(TApplication,
       'function TApplication_GetHint:String;',
       @TApplication_GetHint, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutHint(const Value: String);',
       @TApplication_PutHint, Fake);
  RegisterProperty(TApplication,
       'property Hint:String read TApplication_GetHint write TApplication_PutHint;');
  RegisterMethod(TApplication,
       'function TApplication_GetHintColor:TColor;',
       @TApplication_GetHintColor, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutHintColor(const Value: TColor);',
       @TApplication_PutHintColor, Fake);
  RegisterProperty(TApplication,
       'property HintColor:TColor read TApplication_GetHintColor write TApplication_PutHintColor;');
  RegisterMethod(TApplication,
       'function TApplication_GetHintHidePause:Integer;',
       @TApplication_GetHintHidePause, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutHintHidePause(const Value: Integer);',
       @TApplication_PutHintHidePause, Fake);
  RegisterProperty(TApplication,
       'property HintHidePause:Integer read TApplication_GetHintHidePause write TApplication_PutHintHidePause;');
  RegisterMethod(TApplication,
       'function TApplication_GetHintPause:Integer;',
       @TApplication_GetHintPause, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutHintPause(const Value: Integer);',
       @TApplication_PutHintPause, Fake);
  RegisterProperty(TApplication,
       'property HintPause:Integer read TApplication_GetHintPause write TApplication_PutHintPause;');
  RegisterMethod(TApplication,
       'function TApplication_GetHintShortCuts:Boolean;',
       @TApplication_GetHintShortCuts, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutHintShortCuts(const Value: Boolean);',
       @TApplication_PutHintShortCuts, Fake);
  RegisterProperty(TApplication,
       'property HintShortCuts:Boolean read TApplication_GetHintShortCuts write TApplication_PutHintShortCuts;');
  RegisterMethod(TApplication,
       'function TApplication_GetHintShortPause:Integer;',
       @TApplication_GetHintShortPause, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutHintShortPause(const Value: Integer);',
       @TApplication_PutHintShortPause, Fake);
  RegisterProperty(TApplication,
       'property HintShortPause:Integer read TApplication_GetHintShortPause write TApplication_PutHintShortPause;');
  RegisterMethod(TApplication,
       'function TApplication_GetIcon:TIcon;',
       @TApplication_GetIcon, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutIcon(const Value: TIcon);',
       @TApplication_PutIcon, Fake);
  RegisterProperty(TApplication,
       'property Icon:TIcon read TApplication_GetIcon write TApplication_PutIcon;');
  RegisterMethod(TApplication,
       'function TApplication_GetMainForm:TForm;',
       @TApplication_GetMainForm, Fake);
  RegisterProperty(TApplication,
       'property MainForm:TForm read TApplication_GetMainForm;');
  RegisterMethod(TApplication,
       'function TApplication_GetBiDiMode:TBiDiMode;',
       @TApplication_GetBiDiMode, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutBiDiMode(const Value: TBiDiMode);',
       @TApplication_PutBiDiMode, Fake);
  RegisterProperty(TApplication,
       'property BiDiMode:TBiDiMode read TApplication_GetBiDiMode write TApplication_PutBiDiMode;');
  RegisterMethod(TApplication,
       'function TApplication_GetBiDiKeyboard:String;',
       @TApplication_GetBiDiKeyboard, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutBiDiKeyboard(const Value: String);',
       @TApplication_PutBiDiKeyboard, Fake);
  RegisterProperty(TApplication,
       'property BiDiKeyboard:String read TApplication_GetBiDiKeyboard write TApplication_PutBiDiKeyboard;');
  RegisterMethod(TApplication,
       'function TApplication_GetNonBiDiKeyboard:String;',
       @TApplication_GetNonBiDiKeyboard, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutNonBiDiKeyboard(const Value: String);',
       @TApplication_PutNonBiDiKeyboard, Fake);
  RegisterProperty(TApplication,
       'property NonBiDiKeyboard:String read TApplication_GetNonBiDiKeyboard write TApplication_PutNonBiDiKeyboard;');
  RegisterMethod(TApplication,
       'function TApplication_GetShowHint:Boolean;',
       @TApplication_GetShowHint, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutShowHint(const Value: Boolean);',
       @TApplication_PutShowHint, Fake);
  RegisterProperty(TApplication,
       'property ShowHint:Boolean read TApplication_GetShowHint write TApplication_PutShowHint;');
  RegisterMethod(TApplication,
       'function TApplication_GetShowMainForm:Boolean;',
       @TApplication_GetShowMainForm, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutShowMainForm(const Value: Boolean);',
       @TApplication_PutShowMainForm, Fake);
  RegisterProperty(TApplication,
       'property ShowMainForm:Boolean read TApplication_GetShowMainForm write TApplication_PutShowMainForm;');
  RegisterMethod(TApplication,
       'function TApplication_GetTerminated:Boolean;',
       @TApplication_GetTerminated, Fake);
  RegisterProperty(TApplication,
       'property Terminated:Boolean read TApplication_GetTerminated;');
  RegisterMethod(TApplication,
       'function TApplication_GetTitle:String;',
       @TApplication_GetTitle, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutTitle(const Value: String);',
       @TApplication_PutTitle, Fake);
  RegisterProperty(TApplication,
       'property Title:String read TApplication_GetTitle write TApplication_PutTitle;');
  RegisterMethod(TApplication,
       'function TApplication_GetUpdateFormatSettings:Boolean;',
       @TApplication_GetUpdateFormatSettings, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutUpdateFormatSettings(const Value: Boolean);',
       @TApplication_PutUpdateFormatSettings, Fake);
  RegisterProperty(TApplication,
       'property UpdateFormatSettings:Boolean read TApplication_GetUpdateFormatSettings write TApplication_PutUpdateFormatSettings;');
  RegisterMethod(TApplication,
       'function TApplication_GetUpdateMetricSettings:Boolean;',
       @TApplication_GetUpdateMetricSettings, Fake);
  RegisterMethod(TApplication,
       'procedure TApplication_PutUpdateMetricSettings(const Value: Boolean);',
       @TApplication_PutUpdateMetricSettings, Fake);
  RegisterProperty(TApplication,
       'property UpdateMetricSettings:Boolean read TApplication_GetUpdateMetricSettings write TApplication_PutUpdateMetricSettings;');
  // End of class TApplication
  RegisterRoutine('function GetParentForm(Control: TControl): TCustomForm;', @GetParentForm, H);
  RegisterRoutine('function ValidParentForm(Control: TControl): TCustomForm;', @ValidParentForm, H);
  RegisterRoutine('function DisableTaskWindows(ActiveWindow: HWnd): Pointer;', @DisableTaskWindows, H);

  RegisterRoutine('procedure EnableTaskWindows(WindowList: Pointer);', @EnableTaskWindows, H);
  RegisterRoutine('function MakeObjectInstance(Method: TWndMethod): Pointer;', @MakeObjectInstance, H);
  RegisterRoutine('procedure FreeObjectInstance(ObjectInstance: Pointer);', @FreeObjectInstance, H);
  RegisterRoutine('function IsAccel(VK: Word; const Str: string): Boolean;', @IsAccel, H);
  RegisterRoutine('function  Subclass3DWnd(Wnd: HWnd): Boolean;', @Subclass3DWnd, H);
  RegisterRoutine('procedure Subclass3DDlg(Wnd: HWnd; Flags: Word);', @Subclass3DDlg, H);
  RegisterRoutine('procedure SetAutoSubClass(Enable: Boolean);', @SetAutoSubClass, H);
  RegisterRoutine('function AllocateHWnd(Method: TWndMethod): HWND;', @AllocateHWnd, H);
  RegisterRoutine('procedure DeallocateHWnd(Wnd: HWND);', @DeallocateHWnd, H);
  RegisterRoutine('procedure DoneCtl3D;', @DoneCtl3D, H);
  RegisterRoutine('procedure InitCtl3D;', @InitCtl3D, H);
  RegisterRoutine('function KeysToShiftState(Keys: Word): TShiftState;', @KeysToShiftState, H);
  RegisterRoutine('function KeyDataToShiftState(KeyData: Longint): TShiftState;', @KeyDataToShiftState, H);
  RegisterRoutine('function KeyboardStateToShiftState(const KeyboardState: TKeyboardState): TShiftState;', @KeyboardStateToShiftState, H);
  RegisterRoutine('function ForegroundTask: Boolean;', @ForegroundTask, H);
end;
initialization
  RegisterIMP_forms;
end.
