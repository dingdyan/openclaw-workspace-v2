unit IMP_controls;
interface
uses
  Messages,
  Windows,
  MultiMon,
  Classes,
  Sysutils,
  Graphics,
  Menus,
  CommCtrl,
  Imm,
  ImgList,
  ActnList,
  controls,
  PaxScripter;
procedure RegisterIMP_controls;
implementation
function TDragObject_GetCancelling:Boolean;
begin
  result := TDragObject(_Self).Cancelling;
end;
procedure TDragObject_PutCancelling(const Value: Boolean);
begin
  TDragObject(_Self).Cancelling := Value;
end;
function TDragObject_GetDragHandle:HWND;
begin
  result := TDragObject(_Self).DragHandle;
end;
procedure TDragObject_PutDragHandle(const Value: HWND);
begin
  TDragObject(_Self).DragHandle := Value;
end;
function TDragObject_GetDragPos:TPoint;
begin
  result := TDragObject(_Self).DragPos;
end;
procedure TDragObject_PutDragPos(const Value: TPoint);
begin
  TDragObject(_Self).DragPos := Value;
end;
function TDragObject_GetDragTargetPos:TPoint;
begin
  result := TDragObject(_Self).DragTargetPos;
end;
procedure TDragObject_PutDragTargetPos(const Value: TPoint);
begin
  TDragObject(_Self).DragTargetPos := Value;
end;
function TDragObject_GetDragTarget:Pointer;
begin
  result := TDragObject(_Self).DragTarget;
end;
procedure TDragObject_PutDragTarget(const Value: Pointer);
begin
  TDragObject(_Self).DragTarget := Value;
end;
function TDragObject_GetMouseDeltaX:Double;
begin
  result := TDragObject(_Self).MouseDeltaX;
end;
function TDragObject_GetMouseDeltaY:Double;
begin
  result := TDragObject(_Self).MouseDeltaY;
end;
function TBaseDragControlObject_GetControl:TControl;
begin
  result := TBaseDragControlObject(_Self).Control;
end;
procedure TBaseDragControlObject_PutControl(const Value: TControl);
begin
  TBaseDragControlObject(_Self).Control := Value;
end;
function TDragDockObject_GetBrush:TBrush;
begin
  result := TDragDockObject(_Self).Brush;
end;
procedure TDragDockObject_PutBrush(const Value: TBrush);
begin
  TDragDockObject(_Self).Brush := Value;
end;
function TDragDockObject_GetDockRect:TRect;
begin
  result := TDragDockObject(_Self).DockRect;
end;
procedure TDragDockObject_PutDockRect(const Value: TRect);
begin
  TDragDockObject(_Self).DockRect := Value;
end;
function TDragDockObject_GetDropAlign:TAlign;
begin
  result := TDragDockObject(_Self).DropAlign;
end;
function TDragDockObject_GetDropOnControl:TControl;
begin
  result := TDragDockObject(_Self).DropOnControl;
end;
function TDragDockObject_GetFloating:Boolean;
begin
  result := TDragDockObject(_Self).Floating;
end;
procedure TDragDockObject_PutFloating(const Value: Boolean);
begin
  TDragDockObject(_Self).Floating := Value;
end;
function TDragDockObject_GetFrameWidth:Integer;
begin
  result := TDragDockObject(_Self).FrameWidth;
end;
function TControlCanvas_GetControl:TControl;
begin
  result := TControlCanvas(_Self).Control;
end;
procedure TControlCanvas_PutControl(const Value: TControl);
begin
  TControlCanvas(_Self).Control := Value;
end;
function TControl_GetEnabled:Boolean;
begin
  result := TControl(_Self).Enabled;
end;
procedure TControl_PutEnabled(const Value: Boolean);
begin
  TControl(_Self).Enabled := Value;
end;
function TControl_GetAction:TBasicAction;
begin
  result := TControl(_Self).Action;
end;
procedure TControl_PutAction(const Value: TBasicAction);
begin
  TControl(_Self).Action := Value;
end;
function TControl_GetAlign:TAlign;
begin
  result := TControl(_Self).Align;
end;
procedure TControl_PutAlign(const Value: TAlign);
begin
  TControl(_Self).Align := Value;
end;
function TControl_GetBiDiMode:TBiDiMode;
begin
  result := TControl(_Self).BiDiMode;
end;
procedure TControl_PutBiDiMode(const Value: TBiDiMode);
begin
  TControl(_Self).BiDiMode := Value;
end;
function TControl_GetBoundsRect:TRect;
begin
  result := TControl(_Self).BoundsRect;
end;
procedure TControl_PutBoundsRect(const Value: TRect);
begin
  TControl(_Self).BoundsRect := Value;
end;
function TControl_GetClientHeight:Integer;
begin
  result := TControl(_Self).ClientHeight;
end;
procedure TControl_PutClientHeight(const Value: Integer);
begin
  TControl(_Self).ClientHeight := Value;
end;
function TControl_GetClientOrigin:TPoint;
begin
  result := TControl(_Self).ClientOrigin;
end;
function TControl_GetClientRect:TRect;
begin
  result := TControl(_Self).ClientRect;
end;
function TControl_GetClientWidth:Integer;
begin
  result := TControl(_Self).ClientWidth;
end;
procedure TControl_PutClientWidth(const Value: Integer);
begin
  TControl(_Self).ClientWidth := Value;
end;
function TControl_GetConstraints:TSizeConstraints;
begin
  result := TControl(_Self).Constraints;
end;
procedure TControl_PutConstraints(const Value: TSizeConstraints);
begin
  TControl(_Self).Constraints := Value;
end;
function TControl_GetControlState:TControlState;
begin
  result := TControl(_Self).ControlState;
end;
procedure TControl_PutControlState(const Value: TControlState);
begin
  TControl(_Self).ControlState := Value;
end;
function TControl_GetControlStyle:TControlStyle;
begin
  result := TControl(_Self).ControlStyle;
end;
procedure TControl_PutControlStyle(const Value: TControlStyle);
begin
  TControl(_Self).ControlStyle := Value;
end;
function TControl_GetDockOrientation:TDockOrientation;
begin
  result := TControl(_Self).DockOrientation;
end;
procedure TControl_PutDockOrientation(const Value: TDockOrientation);
begin
  TControl(_Self).DockOrientation := Value;
end;
function TControl_GetFloating:Boolean;
begin
  result := TControl(_Self).Floating;
end;
function TControl_GetFloatingDockSiteClass:TWinControlClass;
begin
  result := TControl(_Self).FloatingDockSiteClass;
end;
procedure TControl_PutFloatingDockSiteClass(const Value: TWinControlClass);
begin
  TControl(_Self).FloatingDockSiteClass := Value;
end;
function TControl_GetHostDockSite:TWinControl;
begin
  result := TControl(_Self).HostDockSite;
end;
procedure TControl_PutHostDockSite(const Value: TWinControl);
begin
  TControl(_Self).HostDockSite := Value;
end;
function TControl_GetLRDockWidth:Integer;
begin
  result := TControl(_Self).LRDockWidth;
end;
procedure TControl_PutLRDockWidth(const Value: Integer);
begin
  TControl(_Self).LRDockWidth := Value;
end;
function TControl_GetParent:TWinControl;
begin
  result := TControl(_Self).Parent;
end;
procedure TControl_PutParent(const Value: TWinControl);
begin
  TControl(_Self).Parent := Value;
end;
function TControl_GetShowHint:Boolean;
begin
  result := TControl(_Self).ShowHint;
end;
procedure TControl_PutShowHint(const Value: Boolean);
begin
  TControl(_Self).ShowHint := Value;
end;
function TControl_GetTBDockHeight:Integer;
begin
  result := TControl(_Self).TBDockHeight;
end;
procedure TControl_PutTBDockHeight(const Value: Integer);
begin
  TControl(_Self).TBDockHeight := Value;
end;
function TControl_GetUndockHeight:Integer;
begin
  result := TControl(_Self).UndockHeight;
end;
procedure TControl_PutUndockHeight(const Value: Integer);
begin
  TControl(_Self).UndockHeight := Value;
end;
function TControl_GetUndockWidth:Integer;
begin
  result := TControl(_Self).UndockWidth;
end;
procedure TControl_PutUndockWidth(const Value: Integer);
begin
  TControl(_Self).UndockWidth := Value;
end;
function TControl_GetVisible:Boolean;
begin
  result := TControl(_Self).Visible;
end;
procedure TControl_PutVisible(const Value: Boolean);
begin
  TControl(_Self).Visible := Value;
end;
function TControl_GetWindowProc:TWndMethod;
begin
  result := TControl(_Self).WindowProc;
end;
procedure TControl_PutWindowProc(const Value: TWndMethod);
begin
  TControl(_Self).WindowProc := Value;
end;
function TWinControl_GetDockClientCount:Integer;
begin
  result := TWinControl(_Self).DockClientCount;
end;
function TWinControl_GetDockClients(Index: Integer):TControl;
begin
  result := TWinControl(_Self).DockClients[Index];
end;
function TWinControl_GetDoubleBuffered:Boolean;
begin
  result := TWinControl(_Self).DoubleBuffered;
end;
procedure TWinControl_PutDoubleBuffered(const Value: Boolean);
begin
  TWinControl(_Self).DoubleBuffered := Value;
end;
function TWinControl_GetVisibleDockClientCount:Integer;
begin
  result := TWinControl(_Self).VisibleDockClientCount;
end;
function TWinControl_GetBrush:TBrush;
begin
  result := TWinControl(_Self).Brush;
end;
function TWinControl_GetControls(Index: Integer):TControl;
begin
  result := TWinControl(_Self).Controls[Index];
end;
function TWinControl_GetControlCount:Integer;
begin
  result := TWinControl(_Self).ControlCount;
end;
function TWinControl_GetHandle:HWnd;
begin
  result := TWinControl(_Self).Handle;
end;
function TWinControl_GetParentWindow:HWnd;
begin
  result := TWinControl(_Self).ParentWindow;
end;
procedure TWinControl_PutParentWindow(const Value: HWnd);
begin
  TWinControl(_Self).ParentWindow := Value;
end;
function TWinControl_GetShowing:Boolean;
begin
  result := TWinControl(_Self).Showing;
end;
function TWinControl_GetTabOrder:TTabOrder;
begin
  result := TWinControl(_Self).TabOrder;
end;
procedure TWinControl_PutTabOrder(const Value: TTabOrder);
begin
  TWinControl(_Self).TabOrder := Value;
end;
function TWinControl_GetTabStop:Boolean;
begin
  result := TWinControl(_Self).TabStop;
end;
procedure TWinControl_PutTabStop(const Value: Boolean);
begin
  TWinControl(_Self).TabStop := Value;
end;
function TDragImageList_GetDragCursor:TCursor;
begin
  result := TDragImageList(_Self).DragCursor;
end;
procedure TDragImageList_PutDragCursor(const Value: TCursor);
begin
  TDragImageList(_Self).DragCursor := Value;
end;
function TDragImageList_GetDragging:Boolean;
begin
  result := TDragImageList(_Self).Dragging;
end;
function TDockZone_GetChildCount:Integer;
begin
  result := TDockZone(_Self).ChildCount;
end;
function TDockZone_GetHeight:Integer;
begin
  result := TDockZone(_Self).Height;
end;
function TDockZone_GetLeft:Integer;
begin
  result := TDockZone(_Self).Left;
end;
function TDockZone_GetLimitBegin:Integer;
begin
  result := TDockZone(_Self).LimitBegin;
end;
function TDockZone_GetLimitSize:Integer;
begin
  result := TDockZone(_Self).LimitSize;
end;
function TDockZone_GetTop:Integer;
begin
  result := TDockZone(_Self).Top;
end;
function TDockZone_GetWidth:Integer;
begin
  result := TDockZone(_Self).Width;
end;
function TMouse_GetCapture:HWND;
begin
  result := TMouse(_Self).Capture;
end;
procedure TMouse_PutCapture(const Value: HWND);
begin
  TMouse(_Self).Capture := Value;
end;
function TMouse_GetCursorPos:TPoint;
begin
  result := TMouse(_Self).CursorPos;
end;
procedure TMouse_PutCursorPos(const Value: TPoint);
begin
  TMouse(_Self).CursorPos := Value;
end;
function TMouse_GetDragImmediate:Boolean;
begin
  result := TMouse(_Self).DragImmediate;
end;
procedure TMouse_PutDragImmediate(const Value: Boolean);
begin
  TMouse(_Self).DragImmediate := Value;
end;
function TMouse_GetDragThreshold:Integer;
begin
  result := TMouse(_Self).DragThreshold;
end;
procedure TMouse_PutDragThreshold(const Value: Integer);
begin
  TMouse(_Self).DragThreshold := Value;
end;
function TMouse_GetMousePresent:Boolean;
begin
  result := TMouse(_Self).MousePresent;
end;
function TMouse_GetRegWheelMessage:UINT;
begin
  result := TMouse(_Self).RegWheelMessage;
end;
function TMouse_GetWheelPresent:Boolean;
begin
  result := TMouse(_Self).WheelPresent;
end;
function TMouse_GetWheelScrollLines:Integer;
begin
  result := TMouse(_Self).WheelScrollLines;
end;
procedure RegisterIMP_controls;
var H: Integer;
begin
  H := RegisterNamespace('controls', -1);
  RegisterConstant('CM_BASE', $B000, H);
  RegisterConstant('CN_BASE', $BC00, H);
  RegisterConstant('MrNone', 0, H);
  RegisterConstant('mrOk', mrOK);
  RegisterConstant('mrCancel', mrCancel);
  RegisterConstant('mrAbort', mrAbort); 
  RegisterConstant('mrRetry', mrRetry);
  RegisterConstant('mrIgnore', mrIgnore);
  RegisterConstant('mrYes', mrYes);
  RegisterConstant('mrNo', mrNo);
  RegisterConstant('mrAll', mrAll);
  RegisterConstant('mrNoToAll', mrNoToAll);
  RegisterConstant('mrYesToAll', mrYesToAll);
 

  RegisterRTTIType(TypeInfo(TDragMessage));
  RegisterRTTIType(TypeInfo(TAlign));
  // Begin of class TDragObject
  RegisterClassType(TDragObject, H);
  RegisterMethod(TDragObject,
       'procedure Assign(Source: TDragObject); virtual;',
       @TDragObject.Assign);
  RegisterMethod(TDragObject,
       'function GetName: string; virtual;',
       @TDragObject.GetName);
  RegisterMethod(TDragObject,
       'procedure HideDragImage; virtual;',
       @TDragObject.HideDragImage);
  RegisterMethod(TDragObject,
       'function Instance: THandle; virtual;',
       @TDragObject.Instance);
  RegisterMethod(TDragObject,
       'procedure ShowDragImage; virtual;',
       @TDragObject.ShowDragImage);
  RegisterMethod(TDragObject,
       'function TDragObject_GetCancelling:Boolean;',
       @TDragObject_GetCancelling, Fake);
  RegisterMethod(TDragObject,
       'procedure TDragObject_PutCancelling(const Value: Boolean);',
       @TDragObject_PutCancelling, Fake);
  RegisterProperty(TDragObject,
       'property Cancelling:Boolean read TDragObject_GetCancelling write TDragObject_PutCancelling;');
  RegisterMethod(TDragObject,
       'function TDragObject_GetDragHandle:HWND;',
       @TDragObject_GetDragHandle, Fake);
  RegisterMethod(TDragObject,
       'procedure TDragObject_PutDragHandle(const Value: HWND);',
       @TDragObject_PutDragHandle, Fake);
  RegisterProperty(TDragObject,
       'property DragHandle:HWND read TDragObject_GetDragHandle write TDragObject_PutDragHandle;');
  RegisterMethod(TDragObject,
       'function TDragObject_GetDragPos:TPoint;',
       @TDragObject_GetDragPos, Fake);
  RegisterMethod(TDragObject,
       'procedure TDragObject_PutDragPos(const Value: TPoint);',
       @TDragObject_PutDragPos, Fake);
  RegisterProperty(TDragObject,
       'property DragPos:TPoint read TDragObject_GetDragPos write TDragObject_PutDragPos;');
  RegisterMethod(TDragObject,
       'function TDragObject_GetDragTargetPos:TPoint;',
       @TDragObject_GetDragTargetPos, Fake);
  RegisterMethod(TDragObject,
       'procedure TDragObject_PutDragTargetPos(const Value: TPoint);',
       @TDragObject_PutDragTargetPos, Fake);
  RegisterProperty(TDragObject,
       'property DragTargetPos:TPoint read TDragObject_GetDragTargetPos write TDragObject_PutDragTargetPos;');
  RegisterMethod(TDragObject,
       'function TDragObject_GetDragTarget:Pointer;',
       @TDragObject_GetDragTarget, Fake);
  RegisterMethod(TDragObject,
       'procedure TDragObject_PutDragTarget(const Value: Pointer);',
       @TDragObject_PutDragTarget, Fake);
  RegisterProperty(TDragObject,
       'property DragTarget:Pointer read TDragObject_GetDragTarget write TDragObject_PutDragTarget;');
  RegisterMethod(TDragObject,
       'function TDragObject_GetMouseDeltaX:Double;',
       @TDragObject_GetMouseDeltaX, Fake);
  RegisterProperty(TDragObject,
       'property MouseDeltaX:Double read TDragObject_GetMouseDeltaX;');
  RegisterMethod(TDragObject,
       'function TDragObject_GetMouseDeltaY:Double;',
       @TDragObject_GetMouseDeltaY, Fake);
  RegisterProperty(TDragObject,
       'property MouseDeltaY:Double read TDragObject_GetMouseDeltaY;');
  RegisterMethod(TDragObject,
       'constructor Create;',
       @TDragObject.Create);
  // End of class TDragObject
  // Begin of class TBaseDragControlObject
  RegisterClassType(TBaseDragControlObject, H);
  RegisterMethod(TBaseDragControlObject,
       'constructor Create(AControl: TControl); virtual;',
       @TBaseDragControlObject.Create);
  RegisterMethod(TBaseDragControlObject,
       'procedure Assign(Source: TDragObject); override;',
       @TBaseDragControlObject.Assign);
  RegisterMethod(TBaseDragControlObject,
       'function TBaseDragControlObject_GetControl:TControl;',
       @TBaseDragControlObject_GetControl, Fake);
  RegisterMethod(TBaseDragControlObject,
       'procedure TBaseDragControlObject_PutControl(const Value: TControl);',
       @TBaseDragControlObject_PutControl, Fake);
  RegisterProperty(TBaseDragControlObject,
       'property Control:TControl read TBaseDragControlObject_GetControl write TBaseDragControlObject_PutControl;');
  // End of class TBaseDragControlObject
  // Begin of class TDragControlObject
  RegisterClassType(TDragControlObject, H);
  RegisterMethod(TDragControlObject,
       'procedure HideDragImage; override;',
       @TDragControlObject.HideDragImage);
  RegisterMethod(TDragControlObject,
       'procedure ShowDragImage; override;',
       @TDragControlObject.ShowDragImage);
  RegisterMethod(TDragControlObject,
       'constructor Create(AControl: TControl); virtual;',
       @TDragControlObject.Create);
  // End of class TDragControlObject
  // Begin of class TDragDockObject
  RegisterClassType(TDragDockObject, H);
  RegisterMethod(TDragDockObject,
       'constructor Create(AControl: TControl); override;',
       @TDragDockObject.Create);
  RegisterMethod(TDragDockObject,
       'destructor Destroy; override;',
       @TDragDockObject.Destroy);
  RegisterMethod(TDragDockObject,
       'procedure Assign(Source: TDragObject); override;',
       @TDragDockObject.Assign);
  RegisterMethod(TDragDockObject,
       'function TDragDockObject_GetBrush:TBrush;',
       @TDragDockObject_GetBrush, Fake);
  RegisterMethod(TDragDockObject,
       'procedure TDragDockObject_PutBrush(const Value: TBrush);',
       @TDragDockObject_PutBrush, Fake);
  RegisterProperty(TDragDockObject,
       'property Brush:TBrush read TDragDockObject_GetBrush write TDragDockObject_PutBrush;');
  RegisterMethod(TDragDockObject,
       'function TDragDockObject_GetDockRect:TRect;',
       @TDragDockObject_GetDockRect, Fake);
  RegisterMethod(TDragDockObject,
       'procedure TDragDockObject_PutDockRect(const Value: TRect);',
       @TDragDockObject_PutDockRect, Fake);
  RegisterProperty(TDragDockObject,
       'property DockRect:TRect read TDragDockObject_GetDockRect write TDragDockObject_PutDockRect;');
  RegisterMethod(TDragDockObject,
       'function TDragDockObject_GetDropAlign:TAlign;',
       @TDragDockObject_GetDropAlign, Fake);
  RegisterProperty(TDragDockObject,
       'property DropAlign:TAlign read TDragDockObject_GetDropAlign;');
  RegisterMethod(TDragDockObject,
       'function TDragDockObject_GetDropOnControl:TControl;',
       @TDragDockObject_GetDropOnControl, Fake);
  RegisterProperty(TDragDockObject,
       'property DropOnControl:TControl read TDragDockObject_GetDropOnControl;');
  RegisterMethod(TDragDockObject,
       'function TDragDockObject_GetFloating:Boolean;',
       @TDragDockObject_GetFloating, Fake);
  RegisterMethod(TDragDockObject,
       'procedure TDragDockObject_PutFloating(const Value: Boolean);',
       @TDragDockObject_PutFloating, Fake);
  RegisterProperty(TDragDockObject,
       'property Floating:Boolean read TDragDockObject_GetFloating write TDragDockObject_PutFloating;');
  RegisterMethod(TDragDockObject,
       'function TDragDockObject_GetFrameWidth:Integer;',
       @TDragDockObject_GetFrameWidth, Fake);
  RegisterProperty(TDragDockObject,
       'property FrameWidth:Integer read TDragDockObject_GetFrameWidth;');
  // End of class TDragDockObject
  // Begin of class TControlCanvas
  RegisterClassType(TControlCanvas, H);
  RegisterMethod(TControlCanvas,
       'destructor Destroy; override;',
       @TControlCanvas.Destroy);
  RegisterMethod(TControlCanvas,
       'procedure FreeHandle;',
       @TControlCanvas.FreeHandle);
  RegisterMethod(TControlCanvas,
       'procedure UpdateTextFlags;',
       @TControlCanvas.UpdateTextFlags);
  RegisterMethod(TControlCanvas,
       'function TControlCanvas_GetControl:TControl;',
       @TControlCanvas_GetControl, Fake);
  RegisterMethod(TControlCanvas,
       'procedure TControlCanvas_PutControl(const Value: TControl);',
       @TControlCanvas_PutControl, Fake);
  RegisterProperty(TControlCanvas,
       'property Control:TControl read TControlCanvas_GetControl write TControlCanvas_PutControl;');
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TControlCanvas
  // Begin of class TControlActionLink
  RegisterClassType(TControlActionLink, H);
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TControlActionLink
  RegisterRTTIType(TypeInfo(TMouseButton));
  RegisterRTTIType(TypeInfo(TDragMode));
  RegisterRTTIType(TypeInfo(TDragState));
  RegisterRTTIType(TypeInfo(TDragKind));
  RegisterRTTIType(TypeInfo(TAnchorKind));
  // Begin of class TSizeConstraints
  RegisterClassType(TSizeConstraints, H);
  RegisterMethod(TSizeConstraints,
       'constructor Create(Control: TControl); virtual;',
       @TSizeConstraints.Create);
  // End of class TSizeConstraints
  RegisterRTTIType(TypeInfo(TDockOrientation));
  // Begin of class TControl
  RegisterClassType(TControl, H);
  RegisterMethod(TControl,
       'constructor Create(AOwner: TComponent); override;',
       @TControl.Create);
  RegisterMethod(TControl,
       'destructor Destroy; override;',
       @TControl.Destroy);
  RegisterMethod(TControl,
       'procedure BringToFront;',
       @TControl.BringToFront);
  RegisterMethod(TControl,
       'function ClientToScreen(const Point: TPoint): TPoint;',
       @TControl.ClientToScreen);
  RegisterMethod(TControl,
       'procedure Dock(NewDockSite: TWinControl; ARect: TRect); dynamic;',
       @TControl.Dock);
  RegisterMethod(TControl,
       'procedure DefaultHandler(var Message); override;',
       @TControl.DefaultHandler);
  RegisterMethod(TControl,
       'function Dragging: Boolean;',
       @TControl.Dragging);
  RegisterMethod(TControl,
       'procedure DragDrop(Source: TObject; X, Y: Integer); dynamic;',
       @TControl.DragDrop);
  RegisterMethod(TControl,
       'function DrawTextBiDiModeFlags(Flags: Longint): Longint;',
       @TControl.DrawTextBiDiModeFlags);
  RegisterMethod(TControl,
       'function DrawTextBiDiModeFlagsReadingOnly: Longint;',
       @TControl.DrawTextBiDiModeFlagsReadingOnly);
  RegisterMethod(TControl,
       'function TControl_GetEnabled:Boolean;',
       @TControl_GetEnabled, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutEnabled(const Value: Boolean);',
       @TControl_PutEnabled, Fake);
  RegisterProperty(TControl,
       'property Enabled:Boolean read TControl_GetEnabled write TControl_PutEnabled;');
  RegisterMethod(TControl,
       'procedure EndDrag(Drop: Boolean);',
       @TControl.EndDrag);
  RegisterMethod(TControl,
       'function GetControlsAlignment: TAlignment; dynamic;',
       @TControl.GetControlsAlignment);
  RegisterMethod(TControl,
       'function GetParentComponent: TComponent; override;',
       @TControl.GetParentComponent);
  RegisterMethod(TControl,
       'function GetTextBuf(Buffer: PChar; BufSize: Integer): Integer;',
       @TControl.GetTextBuf);
  RegisterMethod(TControl,
       'function GetTextLen: Integer;',
       @TControl.GetTextLen);
  RegisterMethod(TControl,
       'function HasParent: Boolean; override;',
       @TControl.HasParent);
  RegisterMethod(TControl,
       'procedure Hide;',
       @TControl.Hide);
  RegisterMethod(TControl,
       'procedure InitiateAction; virtual;',
       @TControl.InitiateAction);
  RegisterMethod(TControl,
       'procedure Invalidate; virtual;',
       @TControl.Invalidate);
  RegisterMethod(TControl,
       'function IsRightToLeft: Boolean;',
       @TControl.IsRightToLeft);
  RegisterMethod(TControl,
       'function ManualFloat(ScreenPos: TRect): Boolean;',
       @TControl.ManualFloat);
  RegisterMethod(TControl,
       'function Perform(Msg: Cardinal; WParam, LParam: Longint): Longint;',
       @TControl.Perform);
  RegisterMethod(TControl,
       'procedure Refresh;',
       @TControl.Refresh);
  RegisterMethod(TControl,
       'procedure Repaint; virtual;',
       @TControl.Repaint);
  RegisterMethod(TControl,
       'function ReplaceDockedControl(Control: TControl; NewDockSite: TWinControl;      DropControl: TControl; ControlSide: TAlign): Boolean;',
       @TControl.ReplaceDockedControl);
  RegisterMethod(TControl,
       'function ScreenToClient(const Point: TPoint): TPoint;',
       @TControl.ScreenToClient);
  RegisterMethod(TControl,
       'procedure SendToBack;',
       @TControl.SendToBack);
  RegisterMethod(TControl,
       'procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); virtual;',
       @TControl.SetBounds);
  RegisterMethod(TControl,
       'procedure SetTextBuf(Buffer: PChar);',
       @TControl.SetTextBuf);
  RegisterMethod(TControl,
       'procedure Show;',
       @TControl.Show);
  RegisterMethod(TControl,
       'procedure Update; virtual;',
       @TControl.Update);
  RegisterMethod(TControl,
       'function UseRightToLeftAlignment: Boolean; dynamic;',
       @TControl.UseRightToLeftAlignment);
  RegisterMethod(TControl,
       'function UseRightToLeftReading: Boolean;',
       @TControl.UseRightToLeftReading);
  RegisterMethod(TControl,
       'function UseRightToLeftScrollBar: Boolean;',
       @TControl.UseRightToLeftScrollBar);
  RegisterMethod(TControl,
       'function TControl_GetAction:TBasicAction;',
       @TControl_GetAction, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutAction(const Value: TBasicAction);',
       @TControl_PutAction, Fake);
  RegisterProperty(TControl,
       'property Action:TBasicAction read TControl_GetAction write TControl_PutAction;');
  RegisterMethod(TControl,
       'function TControl_GetAlign:TAlign;',
       @TControl_GetAlign, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutAlign(const Value: TAlign);',
       @TControl_PutAlign, Fake);
  RegisterProperty(TControl,
       'property Align:TAlign read TControl_GetAlign write TControl_PutAlign;');
  RegisterMethod(TControl,
       'function TControl_GetBiDiMode:TBiDiMode;',
       @TControl_GetBiDiMode, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutBiDiMode(const Value: TBiDiMode);',
       @TControl_PutBiDiMode, Fake);
  RegisterProperty(TControl,
       'property BiDiMode:TBiDiMode read TControl_GetBiDiMode write TControl_PutBiDiMode;');
  RegisterMethod(TControl,
       'function TControl_GetBoundsRect:TRect;',
       @TControl_GetBoundsRect, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutBoundsRect(const Value: TRect);',
       @TControl_PutBoundsRect, Fake);
  RegisterProperty(TControl,
       'property BoundsRect:TRect read TControl_GetBoundsRect write TControl_PutBoundsRect;');
  RegisterMethod(TControl,
       'function TControl_GetClientHeight:Integer;',
       @TControl_GetClientHeight, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutClientHeight(const Value: Integer);',
       @TControl_PutClientHeight, Fake);
  RegisterProperty(TControl,
       'property ClientHeight:Integer read TControl_GetClientHeight write TControl_PutClientHeight;');
  RegisterMethod(TControl,
       'function TControl_GetClientOrigin:TPoint;',
       @TControl_GetClientOrigin, Fake);
  RegisterProperty(TControl,
       'property ClientOrigin:TPoint read TControl_GetClientOrigin;');
  RegisterMethod(TControl,
       'function TControl_GetClientRect:TRect;',
       @TControl_GetClientRect, Fake);
  RegisterProperty(TControl,
       'property ClientRect:TRect read TControl_GetClientRect;');
  RegisterMethod(TControl,
       'function TControl_GetClientWidth:Integer;',
       @TControl_GetClientWidth, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutClientWidth(const Value: Integer);',
       @TControl_PutClientWidth, Fake);
  RegisterProperty(TControl,
       'property ClientWidth:Integer read TControl_GetClientWidth write TControl_PutClientWidth;');
  RegisterMethod(TControl,
       'function TControl_GetConstraints:TSizeConstraints;',
       @TControl_GetConstraints, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutConstraints(const Value: TSizeConstraints);',
       @TControl_PutConstraints, Fake);
  RegisterProperty(TControl,
       'property Constraints:TSizeConstraints read TControl_GetConstraints write TControl_PutConstraints;');
  RegisterMethod(TControl,
       'function TControl_GetControlState:TControlState;',
       @TControl_GetControlState, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutControlState(const Value: TControlState);',
       @TControl_PutControlState, Fake);
  RegisterProperty(TControl,
       'property ControlState:TControlState read TControl_GetControlState write TControl_PutControlState;');
  RegisterMethod(TControl,
       'function TControl_GetControlStyle:TControlStyle;',
       @TControl_GetControlStyle, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutControlStyle(const Value: TControlStyle);',
       @TControl_PutControlStyle, Fake);
  RegisterProperty(TControl,
       'property ControlStyle:TControlStyle read TControl_GetControlStyle write TControl_PutControlStyle;');
  RegisterMethod(TControl,
       'function TControl_GetDockOrientation:TDockOrientation;',
       @TControl_GetDockOrientation, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutDockOrientation(const Value: TDockOrientation);',
       @TControl_PutDockOrientation, Fake);
  RegisterProperty(TControl,
       'property DockOrientation:TDockOrientation read TControl_GetDockOrientation write TControl_PutDockOrientation;');
  RegisterMethod(TControl,
       'function TControl_GetFloating:Boolean;',
       @TControl_GetFloating, Fake);
  RegisterProperty(TControl,
       'property Floating:Boolean read TControl_GetFloating;');
  RegisterMethod(TControl,
       'function TControl_GetFloatingDockSiteClass:TWinControlClass;',
       @TControl_GetFloatingDockSiteClass, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutFloatingDockSiteClass(const Value: TWinControlClass);',
       @TControl_PutFloatingDockSiteClass, Fake);
  RegisterProperty(TControl,
       'property FloatingDockSiteClass:TWinControlClass read TControl_GetFloatingDockSiteClass write TControl_PutFloatingDockSiteClass;');
  RegisterMethod(TControl,
       'function TControl_GetHostDockSite:TWinControl;',
       @TControl_GetHostDockSite, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutHostDockSite(const Value: TWinControl);',
       @TControl_PutHostDockSite, Fake);
  RegisterProperty(TControl,
       'property HostDockSite:TWinControl read TControl_GetHostDockSite write TControl_PutHostDockSite;');
  RegisterMethod(TControl,
       'function TControl_GetLRDockWidth:Integer;',
       @TControl_GetLRDockWidth, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutLRDockWidth(const Value: Integer);',
       @TControl_PutLRDockWidth, Fake);
  RegisterProperty(TControl,
       'property LRDockWidth:Integer read TControl_GetLRDockWidth write TControl_PutLRDockWidth;');
  RegisterMethod(TControl,
       'function TControl_GetParent:TWinControl;',
       @TControl_GetParent, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutParent(const Value: TWinControl);',
       @TControl_PutParent, Fake);
  RegisterProperty(TControl,
       'property Parent:TWinControl read TControl_GetParent write TControl_PutParent;');
  RegisterMethod(TControl,
       'function TControl_GetShowHint:Boolean;',
       @TControl_GetShowHint, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutShowHint(const Value: Boolean);',
       @TControl_PutShowHint, Fake);
  RegisterProperty(TControl,
       'property ShowHint:Boolean read TControl_GetShowHint write TControl_PutShowHint;');
  RegisterMethod(TControl,
       'function TControl_GetTBDockHeight:Integer;',
       @TControl_GetTBDockHeight, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutTBDockHeight(const Value: Integer);',
       @TControl_PutTBDockHeight, Fake);
  RegisterProperty(TControl,
       'property TBDockHeight:Integer read TControl_GetTBDockHeight write TControl_PutTBDockHeight;');
  RegisterMethod(TControl,
       'function TControl_GetUndockHeight:Integer;',
       @TControl_GetUndockHeight, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutUndockHeight(const Value: Integer);',
       @TControl_PutUndockHeight, Fake);
  RegisterProperty(TControl,
       'property UndockHeight:Integer read TControl_GetUndockHeight write TControl_PutUndockHeight;');
  RegisterMethod(TControl,
       'function TControl_GetUndockWidth:Integer;',
       @TControl_GetUndockWidth, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutUndockWidth(const Value: Integer);',
       @TControl_PutUndockWidth, Fake);
  RegisterProperty(TControl,
       'property UndockWidth:Integer read TControl_GetUndockWidth write TControl_PutUndockWidth;');
  RegisterMethod(TControl,
       'function TControl_GetVisible:Boolean;',
       @TControl_GetVisible, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutVisible(const Value: Boolean);',
       @TControl_PutVisible, Fake);
  RegisterProperty(TControl,
       'property Visible:Boolean read TControl_GetVisible write TControl_PutVisible;');
  RegisterMethod(TControl,
       'function TControl_GetWindowProc:TWndMethod;',
       @TControl_GetWindowProc, Fake);
  RegisterMethod(TControl,
       'procedure TControl_PutWindowProc(const Value: TWndMethod);',
       @TControl_PutWindowProc, Fake);
  RegisterProperty(TControl,
       'property WindowProc:TWndMethod read TControl_GetWindowProc write TControl_PutWindowProc;');
  // End of class TControl
  // Begin of class TWinControlActionLink
  RegisterClassType(TWinControlActionLink, H);
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TWinControlActionLink
  RegisterRTTIType(TypeInfo(TImeMode));
  RegisterRTTIType(TypeInfo(TBevelCut));
  RegisterRTTIType(TypeInfo(TBevelEdge));
  RegisterRTTIType(TypeInfo(TBevelKind));
  // Begin of class TWinControl
  RegisterClassType(TWinControl, H);
  RegisterMethod(TWinControl,
       'constructor Create(AOwner: TComponent); override;',
       @TWinControl.Create);
  RegisterMethod(TWinControl,
       'constructor CreateParented(ParentWindow: HWnd);',
       @TWinControl.CreateParented);
  RegisterMethod(TWinControl,
       'function CreateParentedControl(ParentWindow: HWnd): TWinControl;',
       @TWinControl.CreateParentedControl);
  RegisterMethod(TWinControl,
       'destructor Destroy; override;',
       @TWinControl.Destroy);
  RegisterMethod(TWinControl,
       'procedure Broadcast(var Message);',
       @TWinControl.Broadcast);
  RegisterMethod(TWinControl,
       'function CanFocus: Boolean; dynamic;',
       @TWinControl.CanFocus);
  RegisterMethod(TWinControl,
       'function ContainsControl(Control: TControl): Boolean;',
       @TWinControl.ContainsControl);
  RegisterMethod(TWinControl,
       'procedure DefaultHandler(var Message); override;',
       @TWinControl.DefaultHandler);
  RegisterMethod(TWinControl,
       'procedure DisableAlign;',
       @TWinControl.DisableAlign);
  RegisterMethod(TWinControl,
       'function TWinControl_GetDockClientCount:Integer;',
       @TWinControl_GetDockClientCount, Fake);
  RegisterProperty(TWinControl,
       'property DockClientCount:Integer read TWinControl_GetDockClientCount;');
  RegisterMethod(TWinControl,
       'function TWinControl_GetDockClients(Index: Integer):TControl;',
       @TWinControl_GetDockClients, Fake);
  RegisterProperty(TWinControl,
       'property DockClients[Index: Integer]:TControl read TWinControl_GetDockClients;');
  RegisterMethod(TWinControl,
       'procedure DockDrop(Source: TDragDockObject; X, Y: Integer); dynamic;',
       @TWinControl.DockDrop);
  RegisterMethod(TWinControl,
       'function TWinControl_GetDoubleBuffered:Boolean;',
       @TWinControl_GetDoubleBuffered, Fake);
  RegisterMethod(TWinControl,
       'procedure TWinControl_PutDoubleBuffered(const Value: Boolean);',
       @TWinControl_PutDoubleBuffered, Fake);
  RegisterProperty(TWinControl,
       'property DoubleBuffered:Boolean read TWinControl_GetDoubleBuffered write TWinControl_PutDoubleBuffered;');
  RegisterMethod(TWinControl,
       'procedure EnableAlign;',
       @TWinControl.EnableAlign);
  RegisterMethod(TWinControl,
       'function FindChildControl(const ControlName: string): TControl;',
       @TWinControl.FindChildControl);
  RegisterMethod(TWinControl,
       'procedure FlipChildren(AllLevels: Boolean); dynamic;',
       @TWinControl.FlipChildren);
  RegisterMethod(TWinControl,
       'function Focused: Boolean; dynamic;',
       @TWinControl.Focused);
  RegisterMethod(TWinControl,
       'procedure GetTabOrderList(List: TList); dynamic;',
       @TWinControl.GetTabOrderList);
  RegisterMethod(TWinControl,
       'function HandleAllocated: Boolean;',
       @TWinControl.HandleAllocated);
  RegisterMethod(TWinControl,
       'procedure HandleNeeded;',
       @TWinControl.HandleNeeded);
  RegisterMethod(TWinControl,
       'procedure InsertControl(AControl: TControl);',
       @TWinControl.InsertControl);
  RegisterMethod(TWinControl,
       'procedure Invalidate; override;',
       @TWinControl.Invalidate);
  RegisterMethod(TWinControl,
       'procedure MouseWheelHandler(var Message: TMessage); dynamic;',
       @TWinControl.MouseWheelHandler);
  RegisterMethod(TWinControl,
       'procedure PaintTo(DC: HDC; X, Y: Integer);',
       @TWinControl.PaintTo);
  RegisterMethod(TWinControl,
       'procedure RemoveControl(AControl: TControl);',
       @TWinControl.RemoveControl);
  RegisterMethod(TWinControl,
       'procedure Realign;',
       @TWinControl.Realign);
  RegisterMethod(TWinControl,
       'procedure Repaint; override;',
       @TWinControl.Repaint);
  RegisterMethod(TWinControl,
       'procedure ScaleBy(M, D: Integer);',
       @TWinControl.ScaleBy);
  RegisterMethod(TWinControl,
       'procedure ScrollBy(DeltaX, DeltaY: Integer);',
       @TWinControl.ScrollBy);
  RegisterMethod(TWinControl,
       'procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;',
       @TWinControl.SetBounds);
  RegisterMethod(TWinControl,
       'procedure SetFocus; virtual;',
       @TWinControl.SetFocus);
  RegisterMethod(TWinControl,
       'procedure Update; override;',
       @TWinControl.Update);
  RegisterMethod(TWinControl,
       'procedure UpdateControlState;',
       @TWinControl.UpdateControlState);
  RegisterMethod(TWinControl,
       'function TWinControl_GetVisibleDockClientCount:Integer;',
       @TWinControl_GetVisibleDockClientCount, Fake);
  RegisterProperty(TWinControl,
       'property VisibleDockClientCount:Integer read TWinControl_GetVisibleDockClientCount;');
  RegisterMethod(TWinControl,
       'function TWinControl_GetBrush:TBrush;',
       @TWinControl_GetBrush, Fake);
  RegisterProperty(TWinControl,
       'property Brush:TBrush read TWinControl_GetBrush;');
  RegisterMethod(TWinControl,
       'function TWinControl_GetControls(Index: Integer):TControl;',
       @TWinControl_GetControls, Fake);
  RegisterProperty(TWinControl,
       'property Controls[Index: Integer]:TControl read TWinControl_GetControls;');
  RegisterMethod(TWinControl,
       'function TWinControl_GetControlCount:Integer;',
       @TWinControl_GetControlCount, Fake);
  RegisterProperty(TWinControl,
       'property ControlCount:Integer read TWinControl_GetControlCount;');
  RegisterMethod(TWinControl,
       'function TWinControl_GetHandle:HWnd;',
       @TWinControl_GetHandle, Fake);
  RegisterProperty(TWinControl,
       'property Handle:HWnd read TWinControl_GetHandle;');
  RegisterMethod(TWinControl,
       'function TWinControl_GetParentWindow:HWnd;',
       @TWinControl_GetParentWindow, Fake);
  RegisterMethod(TWinControl,
       'procedure TWinControl_PutParentWindow(const Value: HWnd);',
       @TWinControl_PutParentWindow, Fake);
  RegisterProperty(TWinControl,
       'property ParentWindow:HWnd read TWinControl_GetParentWindow write TWinControl_PutParentWindow;');
  RegisterMethod(TWinControl,
       'function TWinControl_GetShowing:Boolean;',
       @TWinControl_GetShowing, Fake);
  RegisterProperty(TWinControl,
       'property Showing:Boolean read TWinControl_GetShowing;');
  RegisterMethod(TWinControl,
       'function TWinControl_GetTabOrder:TTabOrder;',
       @TWinControl_GetTabOrder, Fake);
  RegisterMethod(TWinControl,
       'procedure TWinControl_PutTabOrder(const Value: TTabOrder);',
       @TWinControl_PutTabOrder, Fake);
  RegisterProperty(TWinControl,
       'property TabOrder:TTabOrder read TWinControl_GetTabOrder write TWinControl_PutTabOrder;');
  RegisterMethod(TWinControl,
       'function TWinControl_GetTabStop:Boolean;',
       @TWinControl_GetTabStop, Fake);
  RegisterMethod(TWinControl,
       'procedure TWinControl_PutTabStop(const Value: Boolean);',
       @TWinControl_PutTabStop, Fake);
  RegisterProperty(TWinControl,
       'property TabStop:Boolean read TWinControl_GetTabStop write TWinControl_PutTabStop;');
  // End of class TWinControl
  // Begin of class TGraphicControl
  RegisterClassType(TGraphicControl, H);
  RegisterMethod(TGraphicControl,
       'constructor Create(AOwner: TComponent); override;',
       @TGraphicControl.Create);
  RegisterMethod(TGraphicControl,
       'destructor Destroy; override;',
       @TGraphicControl.Destroy);
  // End of class TGraphicControl
  // Begin of class TCustomControl
  RegisterClassType(TCustomControl, H);
  RegisterMethod(TCustomControl,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomControl.Create);
  RegisterMethod(TCustomControl,
       'destructor Destroy; override;',
       @TCustomControl.Destroy);
  // End of class TCustomControl
  // Begin of class THintWindow
  RegisterClassType(THintWindow, H);
  RegisterMethod(THintWindow,
       'constructor Create(AOwner: TComponent); override;',
       @THintWindow.Create);
  RegisterMethod(THintWindow,
       'procedure ActivateHint(Rect: TRect; const AHint: string); virtual;',
       @THintWindow.ActivateHint);
  RegisterMethod(THintWindow,
       'procedure ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer); virtual;',
       @THintWindow.ActivateHintData);
  RegisterMethod(THintWindow,
       'function CalcHintRect(MaxWidth: Integer; const AHint: string;      AData: Pointer): TRect; virtual;',
       @THintWindow.CalcHintRect);
  RegisterMethod(THintWindow,
       'function IsHintMsg(var Msg: TMsg): Boolean; virtual;',
       @THintWindow.IsHintMsg);
  RegisterMethod(THintWindow,
       'procedure ReleaseHandle;',
       @THintWindow.ReleaseHandle);
  // End of class THintWindow
  // Begin of class TDragImageList
  RegisterClassType(TDragImageList, H);
  RegisterMethod(TDragImageList,
       'function BeginDrag(Window: HWND; X, Y: Integer): Boolean;',
       @TDragImageList.BeginDrag);
  RegisterMethod(TDragImageList,
       'function DragLock(Window: HWND; XPos, YPos: Integer): Boolean;',
       @TDragImageList.DragLock);
  RegisterMethod(TDragImageList,
       'function DragMove(X, Y: Integer): Boolean;',
       @TDragImageList.DragMove);
  RegisterMethod(TDragImageList,
       'procedure DragUnlock;',
       @TDragImageList.DragUnlock);
  RegisterMethod(TDragImageList,
       'function EndDrag: Boolean;',
       @TDragImageList.EndDrag);
  RegisterMethod(TDragImageList,
       'function GetHotSpot: TPoint; override;',
       @TDragImageList.GetHotSpot);
  RegisterMethod(TDragImageList,
       'procedure HideDragImage;',
       @TDragImageList.HideDragImage);
  RegisterMethod(TDragImageList,
       'function SetDragImage(Index, HotSpotX, HotSpotY: Integer): Boolean;',
       @TDragImageList.SetDragImage);
  RegisterMethod(TDragImageList,
       'procedure ShowDragImage;',
       @TDragImageList.ShowDragImage);
  RegisterMethod(TDragImageList,
       'function TDragImageList_GetDragCursor:TCursor;',
       @TDragImageList_GetDragCursor, Fake);
  RegisterMethod(TDragImageList,
       'procedure TDragImageList_PutDragCursor(const Value: TCursor);',
       @TDragImageList_PutDragCursor, Fake);
  RegisterProperty(TDragImageList,
       'property DragCursor:TCursor read TDragImageList_GetDragCursor write TDragImageList_PutDragCursor;');
  RegisterMethod(TDragImageList,
       'function TDragImageList_GetDragging:Boolean;',
       @TDragImageList_GetDragging, Fake);
  RegisterProperty(TDragImageList,
       'property Dragging:Boolean read TDragImageList_GetDragging;');
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TDragImageList
  // Begin of class TImageList
  RegisterClassType(TImageList, H);
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TImageList
  // Begin of class TDockZone
  RegisterClassType(TDockZone, H);
  RegisterMethod(TDockZone,
       'constructor Create(Tree: TDockTree);',
       @TDockZone.Create);
  RegisterMethod(TDockZone,
       'procedure ResetChildren;',
       @TDockZone.ResetChildren);
  RegisterMethod(TDockZone,
       'procedure Update;',
       @TDockZone.Update);
  RegisterMethod(TDockZone,
       'function TDockZone_GetChildCount:Integer;',
       @TDockZone_GetChildCount, Fake);
  RegisterProperty(TDockZone,
       'property ChildCount:Integer read TDockZone_GetChildCount;');
  RegisterMethod(TDockZone,
       'function TDockZone_GetHeight:Integer;',
       @TDockZone_GetHeight, Fake);
  RegisterProperty(TDockZone,
       'property Height:Integer read TDockZone_GetHeight;');
  RegisterMethod(TDockZone,
       'function TDockZone_GetLeft:Integer;',
       @TDockZone_GetLeft, Fake);
  RegisterProperty(TDockZone,
       'property Left:Integer read TDockZone_GetLeft;');
  RegisterMethod(TDockZone,
       'function TDockZone_GetLimitBegin:Integer;',
       @TDockZone_GetLimitBegin, Fake);
  RegisterProperty(TDockZone,
       'property LimitBegin:Integer read TDockZone_GetLimitBegin;');
  RegisterMethod(TDockZone,
       'function TDockZone_GetLimitSize:Integer;',
       @TDockZone_GetLimitSize, Fake);
  RegisterProperty(TDockZone,
       'property LimitSize:Integer read TDockZone_GetLimitSize;');
  RegisterMethod(TDockZone,
       'function TDockZone_GetTop:Integer;',
       @TDockZone_GetTop, Fake);
  RegisterProperty(TDockZone,
       'property Top:Integer read TDockZone_GetTop;');
  RegisterMethod(TDockZone,
       'function TDockZone_GetWidth:Integer;',
       @TDockZone_GetWidth, Fake);
  RegisterProperty(TDockZone,
       'property Width:Integer read TDockZone_GetWidth;');
  // End of class TDockZone
  // Begin of class TDockTree
  RegisterClassType(TDockTree, H);
  RegisterMethod(TDockTree,
       'constructor Create(DockSite: TWinControl); virtual;',
       @TDockTree.Create);
  RegisterMethod(TDockTree,
       'destructor Destroy; override;',
       @TDockTree.Destroy);
  RegisterMethod(TDockTree,
       'procedure PaintSite(DC: HDC); virtual;',
       @TDockTree.PaintSite);
  // End of class TDockTree
  // Begin of class TMouse
  RegisterClassType(TMouse, H);
  RegisterMethod(TMouse,
       'constructor Create;',
       @TMouse.Create);
  RegisterMethod(TMouse,
       'destructor Destroy; override;',
       @TMouse.Destroy);
  RegisterMethod(TMouse,
       'procedure SettingChanged(Setting: Integer);',
       @TMouse.SettingChanged);
  RegisterMethod(TMouse,
       'function TMouse_GetCapture:HWND;',
       @TMouse_GetCapture, Fake);
  RegisterMethod(TMouse,
       'procedure TMouse_PutCapture(const Value: HWND);',
       @TMouse_PutCapture, Fake);
  RegisterProperty(TMouse,
       'property Capture:HWND read TMouse_GetCapture write TMouse_PutCapture;');
  RegisterMethod(TMouse,
       'function TMouse_GetCursorPos:TPoint;',
       @TMouse_GetCursorPos, Fake);
  RegisterMethod(TMouse,
       'procedure TMouse_PutCursorPos(const Value: TPoint);',
       @TMouse_PutCursorPos, Fake);
  RegisterProperty(TMouse,
       'property CursorPos:TPoint read TMouse_GetCursorPos write TMouse_PutCursorPos;');
  RegisterMethod(TMouse,
       'function TMouse_GetDragImmediate:Boolean;',
       @TMouse_GetDragImmediate, Fake);
  RegisterMethod(TMouse,
       'procedure TMouse_PutDragImmediate(const Value: Boolean);',
       @TMouse_PutDragImmediate, Fake);
  RegisterProperty(TMouse,
       'property DragImmediate:Boolean read TMouse_GetDragImmediate write TMouse_PutDragImmediate;');
  RegisterMethod(TMouse,
       'function TMouse_GetDragThreshold:Integer;',
       @TMouse_GetDragThreshold, Fake);
  RegisterMethod(TMouse,
       'procedure TMouse_PutDragThreshold(const Value: Integer);',
       @TMouse_PutDragThreshold, Fake);
  RegisterProperty(TMouse,
       'property DragThreshold:Integer read TMouse_GetDragThreshold write TMouse_PutDragThreshold;');
  RegisterMethod(TMouse,
       'function TMouse_GetMousePresent:Boolean;',
       @TMouse_GetMousePresent, Fake);
  RegisterProperty(TMouse,
       'property MousePresent:Boolean read TMouse_GetMousePresent;');
  RegisterMethod(TMouse,
       'function TMouse_GetRegWheelMessage:UINT;',
       @TMouse_GetRegWheelMessage, Fake);
  RegisterProperty(TMouse,
       'property RegWheelMessage:UINT read TMouse_GetRegWheelMessage;');
  RegisterMethod(TMouse,
       'function TMouse_GetWheelPresent:Boolean;',
       @TMouse_GetWheelPresent, Fake);
  RegisterProperty(TMouse,
       'property WheelPresent:Boolean read TMouse_GetWheelPresent;');
  RegisterMethod(TMouse,
       'function TMouse_GetWheelScrollLines:Integer;',
       @TMouse_GetWheelScrollLines, Fake);
  RegisterProperty(TMouse,
       'property WheelScrollLines:Integer read TMouse_GetWheelScrollLines;');
  // End of class TMouse
  RegisterRoutine('function IsDragObject(Sender: TObject): Boolean;', @IsDragObject, H);
  RegisterRoutine('function FindControl(Handle: HWnd): TWinControl;', @FindControl, H);
  RegisterRoutine('function FindVCLWindow(const Pos: TPoint): TWinControl;', @FindVCLWindow, H);
  RegisterRoutine('function FindDragTarget(const Pos: TPoint; AllowDisabled: Boolean): TControl;', @FindDragTarget, H);
  RegisterRoutine('function GetCaptureControl: TControl;', @GetCaptureControl, H);
  RegisterRoutine('procedure SetCaptureControl(Control: TControl);', @SetCaptureControl, H);
  RegisterRoutine('procedure CancelDrag;', @CancelDrag, H);
  RegisterRoutine('function CursorToString(Cursor: TCursor): string;', @CursorToString, H);
  RegisterRoutine('function StringToCursor(const S: string): TCursor;', @StringToCursor, H);
  RegisterRoutine('procedure GetCursorValues(Proc: TGetStrProc);', @GetCursorValues, H);
  RegisterRoutine('function CursorToIdent(Cursor: Longint; var Ident: string): Boolean;', @CursorToIdent, H);
  RegisterRoutine('function IdentToCursor(const Ident: string; var Cursor: Longint): Boolean;', @IdentToCursor, H);
  RegisterRoutine('function GetShortHint(const Hint: string): string;', @GetShortHint, H);
  RegisterRoutine('function GetLongHint(const Hint: string): string;', @GetLongHint, H);
  RegisterRoutine('function InitWndProc(HWindow: HWnd; Message, WParam: Longint;  LParam: Longint): Longint; stdcall;', @InitWndProc, H);
  RegisterConstant('CTL3D_ALL', $FFFF, H);
  RegisterRoutine('procedure ChangeBiDiModeAlignment(var Alignment: TAlignment);', @ChangeBiDiModeAlignment, H);
  RegisterRoutine('function SendAppMessage(Msg: Cardinal; WParam, LParam: Longint): Longint;', @SendAppMessage, H);
  RegisterRoutine('procedure MoveWindowOrg(DC: HDC; DX, DY: Integer);', @MoveWindowOrg, H);
  RegisterRoutine('procedure SetImeMode(hWnd: HWND; Mode: TImeMode);', @SetImeMode, H);
  RegisterRoutine('procedure SetImeName(Name: TImeName);', @SetImeName, H);
  RegisterRoutine('function Win32NLSEnableIME(hWnd: HWND; Enable: Boolean): Boolean;', @Win32NLSEnableIME, H);
  RegisterRoutine('function Imm32GetContext(hWnd: HWND): HIMC;', @Imm32GetContext, H);
  RegisterRoutine('function Imm32ReleaseContext(hWnd: HWND; hImc: HIMC): Boolean;', @Imm32ReleaseContext, H);
  RegisterRoutine('function Imm32GetConversionStatus(hImc: HIMC; var Conversion, Sentence: DWORD): Boolean;', @Imm32GetConversionStatus, H);
  RegisterRoutine('function Imm32SetConversionStatus(hImc: HIMC; Conversion, Sentence: DWORD): Boolean;', @Imm32SetConversionStatus, H);
  RegisterRoutine('function Imm32SetOpenStatus(hImc: HIMC; fOpen: Boolean): Boolean;', @Imm32SetOpenStatus, H);
  RegisterRoutine('function Imm32SetCompositionWindow(hImc: HIMC; lpCompForm: PCOMPOSITIONFORM): Boolean;', @Imm32SetCompositionWindow, H);
  RegisterRoutine('function Imm32SetCompositionFont(hImc: HIMC; lpLogfont: PLOGFONTA): Boolean;', @Imm32SetCompositionFont, H);
  RegisterRoutine('function Imm32GetCompositionString(hImc: HIMC; dWord1: DWORD; lpBuf: pointer; dwBufLen: DWORD): Longint;', @Imm32GetCompositionString, H);
  RegisterRoutine('function Imm32IsIME(hKl: HKL): Boolean;', @Imm32IsIME, H);
  RegisterRoutine('function Imm32NotifyIME(hImc: HIMC; dwAction, dwIndex, dwValue: DWORD): Boolean;', @Imm32NotifyIME, H);
end;
initialization
  RegisterIMP_controls;
end.
