unit IMP_comctrls;
interface
uses
  Messages,
  Windows,
  SysUtils,
  CommCtrl,
  Classes,
  Controls,
  Forms,
  Menus,
  Graphics,
  StdCtrls,
  RichEdit,
  ToolWin,
  ImgList,
  ExtCtrls,
  comctrls,
  PaxScripter;
procedure RegisterIMP_comctrls;
implementation

type
  TSubItems = class(TStringList);

function TCustomTabControl_GetCanvas:TCanvas;
begin
  result := TCustomTabControl(_Self).Canvas;
end;
function TTabSheet_GetPageControl:TPageControl;
begin
  result := TTabSheet(_Self).PageControl;
end;
procedure TTabSheet_PutPageControl(const Value: TPageControl);
begin
  TTabSheet(_Self).PageControl := Value;
end;
function TTabSheet_GetTabIndex:Integer;
begin
  result := TTabSheet(_Self).TabIndex;
end;
function TPageControl_GetActivePageIndex:Integer;
begin
  result := TPageControl(_Self).ActivePageIndex;
end;
procedure TPageControl_PutActivePageIndex(const Value: Integer);
begin
  TPageControl(_Self).ActivePageIndex := Value;
end;
function TPageControl_GetPageCount:Integer;
begin
  result := TPageControl(_Self).PageCount;
end;
function TPageControl_GetPages(Index: Integer):TTabSheet;
begin
  result := TPageControl(_Self).Pages[Index];
end;
function TStatusPanels_GetItems(Index: Integer):TStatusPanel;
begin
  result := TStatusPanels(_Self).Items[Index];
end;
procedure TStatusPanels_PutItems(Index: Integer;const Value: TStatusPanel);
begin
  TStatusPanels(_Self).Items[Index] := Value;
end;
function TStatusBar_GetCanvas:TCanvas;
begin
  result := TStatusBar(_Self).Canvas;
end;
function THeaderSection_GetLeft:Integer;
begin
  result := THeaderSection(_Self).Left;
end;
function THeaderSection_GetRight:Integer;
begin
  result := THeaderSection(_Self).Right;
end;
function THeaderSections_GetItems(Index: Integer):THeaderSection;
begin
  result := THeaderSections(_Self).Items[Index];
end;
procedure THeaderSections_PutItems(Index: Integer;const Value: THeaderSection);
begin
  THeaderSections(_Self).Items[Index] := Value;
end;
function THeaderControl_GetCanvas:TCanvas;
begin
  result := THeaderControl(_Self).Canvas;
end;
function TTreeNode_GetAbsoluteIndex:Integer;
begin
  result := TTreeNode(_Self).AbsoluteIndex;
end;
function TTreeNode_GetCount:Integer;
begin
  result := TTreeNode(_Self).Count;
end;
function TTreeNode_GetCut:Boolean;
begin
  result := TTreeNode(_Self).Cut;
end;
procedure TTreeNode_PutCut(const Value: Boolean);
begin
  TTreeNode(_Self).Cut := Value;
end;
function TTreeNode_GetData:Pointer;
begin
  result := TTreeNode(_Self).Data;
end;
procedure TTreeNode_PutData(const Value: Pointer);
begin
  TTreeNode(_Self).Data := Value;
end;
function TTreeNode_GetDeleting:Boolean;
begin
  result := TTreeNode(_Self).Deleting;
end;
function TTreeNode_GetFocused:Boolean;
begin
  result := TTreeNode(_Self).Focused;
end;
procedure TTreeNode_PutFocused(const Value: Boolean);
begin
  TTreeNode(_Self).Focused := Value;
end;
function TTreeNode_GetDropTarget:Boolean;
begin
  result := TTreeNode(_Self).DropTarget;
end;
procedure TTreeNode_PutDropTarget(const Value: Boolean);
begin
  TTreeNode(_Self).DropTarget := Value;
end;
function TTreeNode_GetSelected:Boolean;
begin
  result := TTreeNode(_Self).Selected;
end;
procedure TTreeNode_PutSelected(const Value: Boolean);
begin
  TTreeNode(_Self).Selected := Value;
end;
function TTreeNode_GetExpanded:Boolean;
begin
  result := TTreeNode(_Self).Expanded;
end;
procedure TTreeNode_PutExpanded(const Value: Boolean);
begin
  TTreeNode(_Self).Expanded := Value;
end;
function TTreeNode_GetHandle:HWND;
begin
  result := TTreeNode(_Self).Handle;
end;
function TTreeNode_GetHasChildren:Boolean;
begin
  result := TTreeNode(_Self).HasChildren;
end;
procedure TTreeNode_PutHasChildren(const Value: Boolean);
begin
  TTreeNode(_Self).HasChildren := Value;
end;
function TTreeNode_GetImageIndex:TImageIndex;
begin
  result := TTreeNode(_Self).ImageIndex;
end;
procedure TTreeNode_PutImageIndex(const Value: TImageIndex);
begin
  TTreeNode(_Self).ImageIndex := Value;
end;
function TTreeNode_GetIndex:Integer;
begin
  result := TTreeNode(_Self).Index;
end;
function TTreeNode_GetIsVisible:Boolean;
begin
  result := TTreeNode(_Self).IsVisible;
end;
function TTreeNode_GetItem(Index: Integer):TTreeNode;
begin
  result := TTreeNode(_Self).Item[Index];
end;
procedure TTreeNode_PutItem(Index: Integer;const Value: TTreeNode);
begin
  TTreeNode(_Self).Item[Index] := Value;
end;
function TTreeNode_GetItemId:HTreeItem;
begin
  result := TTreeNode(_Self).ItemId;
end;
function TTreeNode_GetLevel:Integer;
begin
  result := TTreeNode(_Self).Level;
end;
function TTreeNode_GetOverlayIndex:Integer;
begin
  result := TTreeNode(_Self).OverlayIndex;
end;
procedure TTreeNode_PutOverlayIndex(const Value: Integer);
begin
  TTreeNode(_Self).OverlayIndex := Value;
end;
function TTreeNode_GetOwner:TTreeNodes;
begin
  result := TTreeNode(_Self).Owner;
end;
function TTreeNode_GetParent:TTreeNode;
begin
  result := TTreeNode(_Self).Parent;
end;
function TTreeNode_GetSelectedIndex:Integer;
begin
  result := TTreeNode(_Self).SelectedIndex;
end;
procedure TTreeNode_PutSelectedIndex(const Value: Integer);
begin
  TTreeNode(_Self).SelectedIndex := Value;
end;
function TTreeNode_GetStateIndex:Integer;
begin
  result := TTreeNode(_Self).StateIndex;
end;
procedure TTreeNode_PutStateIndex(const Value: Integer);
begin
  TTreeNode(_Self).StateIndex := Value;
end;
function TTreeNode_GetText:String;
begin
  result := TTreeNode(_Self).Text;
end;
procedure TTreeNode_PutText(const Value: String);
begin
  TTreeNode(_Self).Text := Value;
end;
function TTreeNode_GetTreeView:TCustomTreeView;
begin
  result := TTreeNode(_Self).TreeView;
end;
function TTreeNodes_GetCount:Integer;
begin
  result := TTreeNodes(_Self).Count;
end;
function TTreeNodes_GetHandle:HWND;
begin
  result := TTreeNodes(_Self).Handle;
end;
function TTreeNodes_GetItem(Index: Integer):TTreeNode;
begin
  result := TTreeNodes(_Self).Item[Index];
end;
function TTreeNodes_GetOwner:TCustomTreeView;
begin
  result := TTreeNodes(_Self).Owner;
end;
function TCustomTreeView_GetCanvas:TCanvas;
begin
  result := TCustomTreeView(_Self).Canvas;
end;
function TCustomTreeView_GetDropTarget:TTreeNode;
begin
  result := TCustomTreeView(_Self).DropTarget;
end;
procedure TCustomTreeView_PutDropTarget(const Value: TTreeNode);
begin
  TCustomTreeView(_Self).DropTarget := Value;
end;
function TCustomTreeView_GetSelected:TTreeNode;
begin
  result := TCustomTreeView(_Self).Selected;
end;
procedure TCustomTreeView_PutSelected(const Value: TTreeNode);
begin
  TCustomTreeView(_Self).Selected := Value;
end;
function TCustomTreeView_GetTopItem:TTreeNode;
begin
  result := TCustomTreeView(_Self).TopItem;
end;
procedure TCustomTreeView_PutTopItem(const Value: TTreeNode);
begin
  TCustomTreeView(_Self).TopItem := Value;
end;
function TTextAttributes_GetCharset:TFontCharset;
begin
  result := TTextAttributes(_Self).Charset;
end;
procedure TTextAttributes_PutCharset(const Value: TFontCharset);
begin
  TTextAttributes(_Self).Charset := Value;
end;
function TTextAttributes_GetColor:TColor;
begin
  result := TTextAttributes(_Self).Color;
end;
procedure TTextAttributes_PutColor(const Value: TColor);
begin
  TTextAttributes(_Self).Color := Value;
end;
function TTextAttributes_GetConsistentAttributes:TConsistentAttributes;
begin
  result := TTextAttributes(_Self).ConsistentAttributes;
end;
function TTextAttributes_GetName:TFontName;
begin
  result := TTextAttributes(_Self).Name;
end;
procedure TTextAttributes_PutName(const Value: TFontName);
begin
  TTextAttributes(_Self).Name := Value;
end;
function TTextAttributes_GetPitch:TFontPitch;
begin
  result := TTextAttributes(_Self).Pitch;
end;
procedure TTextAttributes_PutPitch(const Value: TFontPitch);
begin
  TTextAttributes(_Self).Pitch := Value;
end;
function TTextAttributes_GetProtected:Boolean;
begin
  result := TTextAttributes(_Self).Protected;
end;
procedure TTextAttributes_PutProtected(const Value: Boolean);
begin
  TTextAttributes(_Self).Protected := Value;
end;
function TTextAttributes_GetSize:Integer;
begin
  result := TTextAttributes(_Self).Size;
end;
procedure TTextAttributes_PutSize(const Value: Integer);
begin
  TTextAttributes(_Self).Size := Value;
end;
function TTextAttributes_GetStyle:TFontStyles;
begin
  result := TTextAttributes(_Self).Style;
end;
procedure TTextAttributes_PutStyle(const Value: TFontStyles);
begin
  TTextAttributes(_Self).Style := Value;
end;
function TTextAttributes_GetHeight:Integer;
begin
  result := TTextAttributes(_Self).Height;
end;
procedure TTextAttributes_PutHeight(const Value: Integer);
begin
  TTextAttributes(_Self).Height := Value;
end;
function TParaAttributes_GetAlignment:TAlignment;
begin
  result := TParaAttributes(_Self).Alignment;
end;
procedure TParaAttributes_PutAlignment(const Value: TAlignment);
begin
  TParaAttributes(_Self).Alignment := Value;
end;
function TParaAttributes_GetFirstIndent:Longint;
begin
  result := TParaAttributes(_Self).FirstIndent;
end;
procedure TParaAttributes_PutFirstIndent(const Value: Longint);
begin
  TParaAttributes(_Self).FirstIndent := Value;
end;
function TParaAttributes_GetLeftIndent:Longint;
begin
  result := TParaAttributes(_Self).LeftIndent;
end;
procedure TParaAttributes_PutLeftIndent(const Value: Longint);
begin
  TParaAttributes(_Self).LeftIndent := Value;
end;
function TParaAttributes_GetNumbering:TNumberingStyle;
begin
  result := TParaAttributes(_Self).Numbering;
end;
procedure TParaAttributes_PutNumbering(const Value: TNumberingStyle);
begin
  TParaAttributes(_Self).Numbering := Value;
end;
function TParaAttributes_GetRightIndent:Longint;
begin
  result := TParaAttributes(_Self).RightIndent;
end;
procedure TParaAttributes_PutRightIndent(const Value: Longint);
begin
  TParaAttributes(_Self).RightIndent := Value;
end;
function TParaAttributes_GetTab(Index: Byte):Longint;
begin
  result := TParaAttributes(_Self).Tab[Index];
end;
procedure TParaAttributes_PutTab(Index: Byte;const Value: Longint);
begin
  TParaAttributes(_Self).Tab[Index] := Value;
end;
function TParaAttributes_GetTabCount:Integer;
begin
  result := TParaAttributes(_Self).TabCount;
end;
procedure TParaAttributes_PutTabCount(const Value: Integer);
begin
  TParaAttributes(_Self).TabCount := Value;
end;
function TCustomRichEdit_GetDefaultConverter:TConversionClass;
begin
  result := TCustomRichEdit(_Self).DefaultConverter;
end;
procedure TCustomRichEdit_PutDefaultConverter(const Value: TConversionClass);
begin
  TCustomRichEdit(_Self).DefaultConverter := Value;
end;
function TCustomRichEdit_GetDefAttributes:TTextAttributes;
begin
  result := TCustomRichEdit(_Self).DefAttributes;
end;
procedure TCustomRichEdit_PutDefAttributes(const Value: TTextAttributes);
begin
  TCustomRichEdit(_Self).DefAttributes := Value;
end;
function TCustomRichEdit_GetSelAttributes:TTextAttributes;
begin
  result := TCustomRichEdit(_Self).SelAttributes;
end;
procedure TCustomRichEdit_PutSelAttributes(const Value: TTextAttributes);
begin
  TCustomRichEdit(_Self).SelAttributes := Value;
end;
function TCustomRichEdit_GetPageRect:TRect;
begin
  result := TCustomRichEdit(_Self).PageRect;
end;
procedure TCustomRichEdit_PutPageRect(const Value: TRect);
begin
  TCustomRichEdit(_Self).PageRect := Value;
end;
function TCustomRichEdit_GetParagraph:TParaAttributes;
begin
  result := TCustomRichEdit(_Self).Paragraph;
end;
function TListColumn_GetWidthType:TWidth;
begin
  result := TListColumn(_Self).WidthType;
end;
function TListColumns_GetOwner:TCustomListView;
begin
  result := TListColumns(_Self).Owner;
end;
function TListColumns_GetItems(Index: Integer):TListColumn;
begin
  result := TListColumns(_Self).Items[Index];
end;
procedure TListColumns_PutItems(Index: Integer;const Value: TListColumn);
begin
  TListColumns(_Self).Items[Index] := Value;
end;
function TListItem_GetCaption:String;
begin
  result := TListItem(_Self).Caption;
end;
procedure TListItem_PutCaption(const Value: String);
begin
  TListItem(_Self).Caption := Value;
end;
function TListItem_GetChecked:Boolean;
begin
  result := TListItem(_Self).Checked;
end;
procedure TListItem_PutChecked(const Value: Boolean);
begin
  TListItem(_Self).Checked := Value;
end;
function TListItem_GetCut:Boolean;
begin
  result := TListItem(_Self).Cut;
end;
procedure TListItem_PutCut(const Value: Boolean);
begin
  TListItem(_Self).Cut := Value;
end;
function TListItem_GetData:Pointer;
begin
  result := TListItem(_Self).Data;
end;
procedure TListItem_PutData(const Value: Pointer);
begin
  TListItem(_Self).Data := Value;
end;
function TListItem_GetDropTarget:Boolean;
begin
  result := TListItem(_Self).DropTarget;
end;
procedure TListItem_PutDropTarget(const Value: Boolean);
begin
  TListItem(_Self).DropTarget := Value;
end;
function TListItem_GetFocused:Boolean;
begin
  result := TListItem(_Self).Focused;
end;
procedure TListItem_PutFocused(const Value: Boolean);
begin
  TListItem(_Self).Focused := Value;
end;
function TListItem_GetHandle:HWND;
begin
  result := TListItem(_Self).Handle;
end;
function TListItem_GetImageIndex:TImageIndex;
begin
  result := TListItem(_Self).ImageIndex;
end;
procedure TListItem_PutImageIndex(const Value: TImageIndex);
begin
  TListItem(_Self).ImageIndex := Value;
end;
function TListItem_GetIndent:Integer;
begin
  result := TListItem(_Self).Indent;
end;
procedure TListItem_PutIndent(const Value: Integer);
begin
  TListItem(_Self).Indent := Value;
end;
function TListItem_GetIndex:Integer;
begin
  result := TListItem(_Self).Index;
end;
function TListItem_GetLeft:Integer;
begin
  result := TListItem(_Self).Left;
end;
procedure TListItem_PutLeft(const Value: Integer);
begin
  TListItem(_Self).Left := Value;
end;
function TListItem_GetListView:TCustomListView;
begin
  result := TListItem(_Self).ListView;
end;
function TListItem_GetOwner:TListItems;
begin
  result := TListItem(_Self).Owner;
end;
function TListItem_GetOverlayIndex:TImageIndex;
begin
  result := TListItem(_Self).OverlayIndex;
end;
procedure TListItem_PutOverlayIndex(const Value: TImageIndex);
begin
  TListItem(_Self).OverlayIndex := Value;
end;
function TListItem_GetPosition:TPoint;
begin
  result := TListItem(_Self).Position;
end;
procedure TListItem_PutPosition(const Value: TPoint);
begin
  TListItem(_Self).Position := Value;
end;
function TListItem_GetSelected:Boolean;
begin
  result := TListItem(_Self).Selected;
end;
procedure TListItem_PutSelected(const Value: Boolean);
begin
  TListItem(_Self).Selected := Value;
end;
function TListItem_GetStateIndex:TImageIndex;
begin
  result := TListItem(_Self).StateIndex;
end;
procedure TListItem_PutStateIndex(const Value: TImageIndex);
begin
  TListItem(_Self).StateIndex := Value;
end;
function TListItem_GetSubItems:TStrings;
begin
  result := TListItem(_Self).SubItems;
end;
procedure TListItem_PutSubItems(const Value: TStrings);
begin
  TListItem(_Self).SubItems := Value;
end;
function TListItem_GetSubItemImages(Index: Integer):Integer;
begin
  result := TListItem(_Self).SubItemImages[Index];
end;
procedure TListItem_PutSubItemImages(Index: Integer;const Value: Integer);
begin
  TListItem(_Self).SubItemImages[Index] := Value;
end;
function TListItem_GetTop:Integer;
begin
  result := TListItem(_Self).Top;
end;
procedure TListItem_PutTop(const Value: Integer);
begin
  TListItem(_Self).Top := Value;
end;
function TListItems_GetCount:Integer;
begin
  result := TListItems(_Self).Count;
end;
procedure TListItems_PutCount(const Value: Integer);
begin
  TListItems(_Self).Count := Value;
end;
function TListItems_GetHandle:HWND;
begin
  result := TListItems(_Self).Handle;
end;
function TListItems_GetItem(Index: Integer):TListItem;
begin
  result := TListItems(_Self).Item[Index];
end;
procedure TListItems_PutItem(Index: Integer;const Value: TListItem);
begin
  TListItems(_Self).Item[Index] := Value;
end;
function TListItems_GetOwner:TCustomListView;
begin
  result := TListItems(_Self).Owner;
end;
function TWorkArea_GetRect:TRect;
begin
  result := TWorkArea(_Self).Rect;
end;
procedure TWorkArea_PutRect(const Value: TRect);
begin
  TWorkArea(_Self).Rect := Value;
end;
function TWorkArea_GetColor:TColor;
begin
  result := TWorkArea(_Self).Color;
end;
procedure TWorkArea_PutColor(const Value: TColor);
begin
  TWorkArea(_Self).Color := Value;
end;
function TWorkAreas_GetItems(Index: Integer):TWorkArea;
begin
  result := TWorkAreas(_Self).Items[Index];
end;
procedure TWorkAreas_PutItems(Index: Integer;const Value: TWorkArea);
begin
  TWorkAreas(_Self).Items[Index] := Value;
end;
function TCustomListView_GetCanvas:TCanvas;
begin
  result := TCustomListView(_Self).Canvas;
end;
function TCustomListView_GetCheckboxes:Boolean;
begin
  result := TCustomListView(_Self).Checkboxes;
end;
procedure TCustomListView_PutCheckboxes(const Value: Boolean);
begin
  TCustomListView(_Self).Checkboxes := Value;
end;
function TCustomListView_GetColumn(Index: Integer):TListColumn;
begin
  result := TCustomListView(_Self).Column[Index];
end;
function TCustomListView_GetDropTarget:TListItem;
begin
  result := TCustomListView(_Self).DropTarget;
end;
procedure TCustomListView_PutDropTarget(const Value: TListItem);
begin
  TCustomListView(_Self).DropTarget := Value;
end;
function TCustomListView_GetFlatScrollBars:Boolean;
begin
  result := TCustomListView(_Self).FlatScrollBars;
end;
procedure TCustomListView_PutFlatScrollBars(const Value: Boolean);
begin
  TCustomListView(_Self).FlatScrollBars := Value;
end;
function TCustomListView_GetFullDrag:Boolean;
begin
  result := TCustomListView(_Self).FullDrag;
end;
procedure TCustomListView_PutFullDrag(const Value: Boolean);
begin
  TCustomListView(_Self).FullDrag := Value;
end;
function TCustomListView_GetGridLines:Boolean;
begin
  result := TCustomListView(_Self).GridLines;
end;
procedure TCustomListView_PutGridLines(const Value: Boolean);
begin
  TCustomListView(_Self).GridLines := Value;
end;
function TCustomListView_GetHotTrack:Boolean;
begin
  result := TCustomListView(_Self).HotTrack;
end;
procedure TCustomListView_PutHotTrack(const Value: Boolean);
begin
  TCustomListView(_Self).HotTrack := Value;
end;
function TCustomListView_GetHotTrackStyles:TListHotTrackStyles;
begin
  result := TCustomListView(_Self).HotTrackStyles;
end;
procedure TCustomListView_PutHotTrackStyles(const Value: TListHotTrackStyles);
begin
  TCustomListView(_Self).HotTrackStyles := Value;
end;
function TCustomListView_GetItemFocused:TListItem;
begin
  result := TCustomListView(_Self).ItemFocused;
end;
procedure TCustomListView_PutItemFocused(const Value: TListItem);
begin
  TCustomListView(_Self).ItemFocused := Value;
end;
function TCustomListView_GetRowSelect:Boolean;
begin
  result := TCustomListView(_Self).RowSelect;
end;
procedure TCustomListView_PutRowSelect(const Value: Boolean);
begin
  TCustomListView(_Self).RowSelect := Value;
end;
function TCustomListView_GetSelCount:Integer;
begin
  result := TCustomListView(_Self).SelCount;
end;
function TCustomListView_GetSelected:TListItem;
begin
  result := TCustomListView(_Self).Selected;
end;
procedure TCustomListView_PutSelected(const Value: TListItem);
begin
  TCustomListView(_Self).Selected := Value;
end;
function TCustomListView_GetTopItem:TListItem;
begin
  result := TCustomListView(_Self).TopItem;
end;
function TCustomListView_GetViewOrigin:TPoint;
begin
  result := TCustomListView(_Self).ViewOrigin;
end;
function TCustomListView_GetVisibleRowCount:Integer;
begin
  result := TCustomListView(_Self).VisibleRowCount;
end;
function TCustomListView_GetBoundingRect:TRect;
begin
  result := TCustomListView(_Self).BoundingRect;
end;
function TCustomListView_GetWorkAreas:TWorkAreas;
begin
  result := TCustomListView(_Self).WorkAreas;
end;
function TAnimate_GetFrameCount:Integer;
begin
  result := TAnimate(_Self).FrameCount;
end;
function TAnimate_GetFrameHeight:Integer;
begin
  result := TAnimate(_Self).FrameHeight;
end;
function TAnimate_GetFrameWidth:Integer;
begin
  result := TAnimate(_Self).FrameWidth;
end;
function TAnimate_GetOpen:Boolean;
begin
  result := TAnimate(_Self).Open;
end;
procedure TAnimate_PutOpen(const Value: Boolean);
begin
  TAnimate(_Self).Open := Value;
end;
function TAnimate_GetResHandle:THandle;
begin
  result := TAnimate(_Self).ResHandle;
end;
procedure TAnimate_PutResHandle(const Value: THandle);
begin
  TAnimate(_Self).ResHandle := Value;
end;
function TAnimate_GetResId:Integer;
begin
  result := TAnimate(_Self).ResId;
end;
procedure TAnimate_PutResId(const Value: Integer);
begin
  TAnimate(_Self).ResId := Value;
end;
function TAnimate_GetResName:String;
begin
  result := TAnimate(_Self).ResName;
end;
procedure TAnimate_PutResName(const Value: String);
begin
  TAnimate(_Self).ResName := Value;
end;
function TToolButton_GetIndex:Integer;
begin
  result := TToolButton(_Self).Index;
end;
function TToolBar_GetButtonCount:Integer;
begin
  result := TToolBar(_Self).ButtonCount;
end;
function TToolBar_GetButtons(Index: Integer):TToolButton;
begin
  result := TToolBar(_Self).Buttons[Index];
end;
function TToolBar_GetCanvas:TCanvas;
begin
  result := TToolBar(_Self).Canvas;
end;
function TToolBar_GetRowCount:Integer;
begin
  result := TToolBar(_Self).RowCount;
end;
function TCoolBand_GetHeight:Integer;
begin
  result := TCoolBand(_Self).Height;
end;
function TCoolBands_GetCoolBar:TCoolBar;
begin
  result := TCoolBands(_Self).CoolBar;
end;
function TCoolBands_GetItems(Index: Integer):TCoolBand;
begin
  result := TCoolBands(_Self).Items[Index];
end;
procedure TCoolBands_PutItems(Index: Integer;const Value: TCoolBand);
begin
  TCoolBands(_Self).Items[Index] := Value;
end;
function TDateTimePicker_GetDroppedDown:Boolean;
begin
  result := TDateTimePicker(_Self).DroppedDown;
end;
procedure RegisterIMP_comctrls;
var H: Integer;
begin
  H := RegisterNamespace('comctrls', -1);
  RegisterRTTIType(TypeInfo(THitTest));
  RegisterRTTIType(TypeInfo(TTabPosition));
  RegisterRTTIType(TypeInfo(TTabStyle));
  // Begin of class TCustomTabControl
  RegisterClassType(TCustomTabControl, H);
  RegisterMethod(TCustomTabControl,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomTabControl.Create);
  RegisterMethod(TCustomTabControl,
       'destructor Destroy; override;',
       @TCustomTabControl.Destroy);
  RegisterMethod(TCustomTabControl,
       'function IndexOfTabAt(X, Y: Integer): Integer;',
       @TCustomTabControl.IndexOfTabAt);
  RegisterMethod(TCustomTabControl,
       'function GetHitTestInfoAt(X, Y: Integer): THitTests;',
       @TCustomTabControl.GetHitTestInfoAt);
  RegisterMethod(TCustomTabControl,
       'function TabRect(Index: Integer): TRect;',
       @TCustomTabControl.TabRect);
  RegisterMethod(TCustomTabControl,
       'function RowCount: Integer;',
       @TCustomTabControl.RowCount);
  RegisterMethod(TCustomTabControl,
       'procedure ScrollTabs(Delta: Integer);',
       @TCustomTabControl.ScrollTabs);
  RegisterMethod(TCustomTabControl,
       'function TCustomTabControl_GetCanvas:TCanvas;',
       @TCustomTabControl_GetCanvas, Fake);
  RegisterProperty(TCustomTabControl,
       'property Canvas:TCanvas read TCustomTabControl_GetCanvas;');
  // End of class TCustomTabControl
  // Begin of class TTabControl
  RegisterClassType(TTabControl, H);
  RegisterMethod(TTabControl,
       'constructor Create(AOwner: TComponent); override;',
       @TTabControl.Create);
  // End of class TTabControl
  // Begin of class TTabSheet
  RegisterClassType(TTabSheet, H);
  RegisterMethod(TTabSheet,
       'constructor Create(AOwner: TComponent); override;',
       @TTabSheet.Create);
  RegisterMethod(TTabSheet,
       'destructor Destroy; override;',
       @TTabSheet.Destroy);
  RegisterMethod(TTabSheet,
       'function TTabSheet_GetPageControl:TPageControl;',
       @TTabSheet_GetPageControl, Fake);
  RegisterMethod(TTabSheet,
       'procedure TTabSheet_PutPageControl(const Value: TPageControl);',
       @TTabSheet_PutPageControl, Fake);
  RegisterProperty(TTabSheet,
       'property PageControl:TPageControl read TTabSheet_GetPageControl write TTabSheet_PutPageControl;');
  RegisterMethod(TTabSheet,
       'function TTabSheet_GetTabIndex:Integer;',
       @TTabSheet_GetTabIndex, Fake);
  RegisterProperty(TTabSheet,
       'property TabIndex:Integer read TTabSheet_GetTabIndex;');
  // End of class TTabSheet
  // Begin of class TPageControl
  RegisterClassType(TPageControl, H);
  RegisterMethod(TPageControl,
       'constructor Create(AOwner: TComponent); override;',
       @TPageControl.Create);
  RegisterMethod(TPageControl,
       'destructor Destroy; override;',
       @TPageControl.Destroy);
  RegisterMethod(TPageControl,
       'function FindNextPage(CurPage: TTabSheet;      GoForward, CheckTabVisible: Boolean): TTabSheet;',
       @TPageControl.FindNextPage);
  RegisterMethod(TPageControl,
       'procedure SelectNextPage(GoForward: Boolean);',
       @TPageControl.SelectNextPage);
  RegisterMethod(TPageControl,
       'function TPageControl_GetActivePageIndex:Integer;',
       @TPageControl_GetActivePageIndex, Fake);
  RegisterMethod(TPageControl,
       'procedure TPageControl_PutActivePageIndex(const Value: Integer);',
       @TPageControl_PutActivePageIndex, Fake);
  RegisterProperty(TPageControl,
       'property ActivePageIndex:Integer read TPageControl_GetActivePageIndex write TPageControl_PutActivePageIndex;');
  RegisterMethod(TPageControl,
       'function TPageControl_GetPageCount:Integer;',
       @TPageControl_GetPageCount, Fake);
  RegisterProperty(TPageControl,
       'property PageCount:Integer read TPageControl_GetPageCount;');
  RegisterMethod(TPageControl,
       'function TPageControl_GetPages(Index: Integer):TTabSheet;',
       @TPageControl_GetPages, Fake);
  RegisterProperty(TPageControl,
       'property Pages[Index: Integer]:TTabSheet read TPageControl_GetPages;');
  // End of class TPageControl
  RegisterRTTIType(TypeInfo(TStatusPanelStyle));
  RegisterRTTIType(TypeInfo(TStatusPanelBevel));
  // Begin of class TStatusPanel
  RegisterClassType(TStatusPanel, H);
  RegisterMethod(TStatusPanel,
       'constructor Create(Collection: TCollection); override;',
       @TStatusPanel.Create);
  RegisterMethod(TStatusPanel,
       'procedure Assign(Source: TPersistent); override;',
       @TStatusPanel.Assign);
  RegisterMethod(TStatusPanel,
       'procedure ParentBiDiModeChanged;',
       @TStatusPanel.ParentBiDiModeChanged);
  RegisterMethod(TStatusPanel,
       'function UseRightToLeftAlignment: Boolean;',
       @TStatusPanel.UseRightToLeftAlignment);
  RegisterMethod(TStatusPanel,
       'function UseRightToLeftReading: Boolean;',
       @TStatusPanel.UseRightToLeftReading);
  // End of class TStatusPanel
  // Begin of class TStatusPanels
  RegisterClassType(TStatusPanels, H);
  RegisterMethod(TStatusPanels,
       'constructor Create(StatusBar: TStatusBar);',
       @TStatusPanels.Create);
  RegisterMethod(TStatusPanels,
       'function Add: TStatusPanel;',
       @TStatusPanels.Add);
  RegisterMethod(TStatusPanels,
       'function TStatusPanels_GetItems(Index: Integer):TStatusPanel;',
       @TStatusPanels_GetItems, Fake);
  RegisterMethod(TStatusPanels,
       'procedure TStatusPanels_PutItems(Index: Integer;const Value: TStatusPanel);',
       @TStatusPanels_PutItems, Fake);
  RegisterProperty(TStatusPanels,
       'property Items[Index: Integer]:TStatusPanel read TStatusPanels_GetItems write TStatusPanels_PutItems;default;');
  // End of class TStatusPanels
  // Begin of class TStatusBar
  RegisterClassType(TStatusBar, H);
  RegisterMethod(TStatusBar,
       'constructor Create(AOwner: TComponent); override;',
       @TStatusBar.Create);
  RegisterMethod(TStatusBar,
       'destructor Destroy; override;',
       @TStatusBar.Destroy);
  RegisterMethod(TStatusBar,
       'function ExecuteAction(Action: TBasicAction): Boolean; override;',
       @TStatusBar.ExecuteAction);
  RegisterMethod(TStatusBar,
       'procedure FlipChildren(AllLevels: Boolean); override;',
       @TStatusBar.FlipChildren);
  RegisterMethod(TStatusBar,
       'function TStatusBar_GetCanvas:TCanvas;',
       @TStatusBar_GetCanvas, Fake);
  RegisterProperty(TStatusBar,
       'property Canvas:TCanvas read TStatusBar_GetCanvas;');
  // End of class TStatusBar
  RegisterRTTIType(TypeInfo(TCustomDrawTarget));
  RegisterRTTIType(TypeInfo(TCustomDrawStage));
  RegisterRTTIType(TypeInfo(THeaderSectionStyle));
  // Begin of class THeaderSection
  RegisterClassType(THeaderSection, H);
  RegisterMethod(THeaderSection,
       'constructor Create(Collection: TCollection); override;',
       @THeaderSection.Create);
  RegisterMethod(THeaderSection,
       'procedure Assign(Source: TPersistent); override;',
       @THeaderSection.Assign);
  RegisterMethod(THeaderSection,
       'procedure ParentBiDiModeChanged;',
       @THeaderSection.ParentBiDiModeChanged);
  RegisterMethod(THeaderSection,
       'function UseRightToLeftAlignment: Boolean;',
       @THeaderSection.UseRightToLeftAlignment);
  RegisterMethod(THeaderSection,
       'function UseRightToLeftReading: Boolean;',
       @THeaderSection.UseRightToLeftReading);
  RegisterMethod(THeaderSection,
       'function THeaderSection_GetLeft:Integer;',
       @THeaderSection_GetLeft, Fake);
  RegisterProperty(THeaderSection,
       'property Left:Integer read THeaderSection_GetLeft;');
  RegisterMethod(THeaderSection,
       'function THeaderSection_GetRight:Integer;',
       @THeaderSection_GetRight, Fake);
  RegisterProperty(THeaderSection,
       'property Right:Integer read THeaderSection_GetRight;');
  // End of class THeaderSection
  // Begin of class THeaderSections
  RegisterClassType(THeaderSections, H);
  RegisterMethod(THeaderSections,
       'constructor Create(HeaderControl: THeaderControl);',
       @THeaderSections.Create);
  RegisterMethod(THeaderSections,
       'function Add: THeaderSection;',
       @THeaderSections.Add);
  RegisterMethod(THeaderSections,
       'function THeaderSections_GetItems(Index: Integer):THeaderSection;',
       @THeaderSections_GetItems, Fake);
  RegisterMethod(THeaderSections,
       'procedure THeaderSections_PutItems(Index: Integer;const Value: THeaderSection);',
       @THeaderSections_PutItems, Fake);
  RegisterProperty(THeaderSections,
       'property Items[Index: Integer]:THeaderSection read THeaderSections_GetItems write THeaderSections_PutItems;default;');
  // End of class THeaderSections
  RegisterRTTIType(TypeInfo(TSectionTrackState));
  RegisterRTTIType(TypeInfo(THeaderStyle));
  // Begin of class THeaderControl
  RegisterClassType(THeaderControl, H);
  RegisterMethod(THeaderControl,
       'constructor Create(AOwner: TComponent); override;',
       @THeaderControl.Create);
  RegisterMethod(THeaderControl,
       'destructor Destroy; override;',
       @THeaderControl.Destroy);
  RegisterMethod(THeaderControl,
       'function THeaderControl_GetCanvas:TCanvas;',
       @THeaderControl_GetCanvas, Fake);
  RegisterProperty(THeaderControl,
       'property Canvas:TCanvas read THeaderControl_GetCanvas;');
  RegisterMethod(THeaderControl,
       'procedure FlipChildren(AllLevels: Boolean); override;',
       @THeaderControl.FlipChildren);
  // End of class THeaderControl
  RegisterRTTIType(TypeInfo(TNodeState));
  RegisterRTTIType(TypeInfo(TNodeAttachMode));
  RegisterRTTIType(TypeInfo(TAddMode));
  // Begin of class TTreeNode
  RegisterClassType(TTreeNode, H);
  RegisterMethod(TTreeNode,
       'constructor Create(AOwner: TTreeNodes);',
       @TTreeNode.Create);
  RegisterMethod(TTreeNode,
       'destructor Destroy; override;',
       @TTreeNode.Destroy);
  RegisterMethod(TTreeNode,
       'function AlphaSort: Boolean;',
       @TTreeNode.AlphaSort);
  RegisterMethod(TTreeNode,
       'procedure Assign(Source: TPersistent); override;',
       @TTreeNode.Assign);
  RegisterMethod(TTreeNode,
       'procedure Collapse(Recurse: Boolean);',
       @TTreeNode.Collapse);
  RegisterMethod(TTreeNode,
       'function CustomSort(SortProc: TTVCompare; Data: Longint): Boolean;',
       @TTreeNode.CustomSort);
  RegisterMethod(TTreeNode,
       'procedure Delete;',
       @TTreeNode.Delete);
  RegisterMethod(TTreeNode,
       'procedure DeleteChildren;',
       @TTreeNode.DeleteChildren);
  RegisterMethod(TTreeNode,
       'function DisplayRect(TextOnly: Boolean): TRect;',
       @TTreeNode.DisplayRect);
  RegisterMethod(TTreeNode,
       'function EditText: Boolean;',
       @TTreeNode.EditText);
  RegisterMethod(TTreeNode,
       'procedure EndEdit(Cancel: Boolean);',
       @TTreeNode.EndEdit);
  RegisterMethod(TTreeNode,
       'procedure Expand(Recurse: Boolean);',
       @TTreeNode.Expand);
  RegisterMethod(TTreeNode,
       'function getFirstChild: TTreeNode;',
       @TTreeNode.GetFirstChild);
  RegisterMethod(TTreeNode,
       'function GetHandle: HWND;',
       @TTreeNode.GetHandle);
  RegisterMethod(TTreeNode,
       'function GetLastChild: TTreeNode;',
       @TTreeNode.GetLastChild);
  RegisterMethod(TTreeNode,
       'function GetNext: TTreeNode;',
       @TTreeNode.GetNext);
  RegisterMethod(TTreeNode,
       'function GetNextChild(Value: TTreeNode): TTreeNode;',
       @TTreeNode.GetNextChild);
  RegisterMethod(TTreeNode,
       'function getNextSibling: TTreeNode;',
       @TTreeNode.GetNextSibling);
  RegisterMethod(TTreeNode,
       'function GetNextVisible: TTreeNode;',
       @TTreeNode.GetNextVisible);
  RegisterMethod(TTreeNode,
       'function GetPrev: TTreeNode;',
       @TTreeNode.GetPrev);
  RegisterMethod(TTreeNode,
       'function GetPrevChild(Value: TTreeNode): TTreeNode;',
       @TTreeNode.GetPrevChild);
  RegisterMethod(TTreeNode,
       'function getPrevSibling: TTreeNode;',
       @TTreeNode.GetPrevSibling);
  RegisterMethod(TTreeNode,
       'function GetPrevVisible: TTreeNode;',
       @TTreeNode.GetPrevVisible);
  RegisterMethod(TTreeNode,
       'function HasAsParent(Value: TTreeNode): Boolean;',
       @TTreeNode.HasAsParent);
  RegisterMethod(TTreeNode,
       'function IndexOf(Value: TTreeNode): Integer;',
       @TTreeNode.IndexOf);
  RegisterMethod(TTreeNode,
       'procedure MakeVisible;',
       @TTreeNode.MakeVisible);
  RegisterMethod(TTreeNode,
       'procedure MoveTo(Destination: TTreeNode; Mode: TNodeAttachMode); virtual;',
       @TTreeNode.MoveTo);
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetAbsoluteIndex:Integer;',
       @TTreeNode_GetAbsoluteIndex, Fake);
  RegisterProperty(TTreeNode,
       'property AbsoluteIndex:Integer read TTreeNode_GetAbsoluteIndex;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetCount:Integer;',
       @TTreeNode_GetCount, Fake);
  RegisterProperty(TTreeNode,
       'property Count:Integer read TTreeNode_GetCount;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetCut:Boolean;',
       @TTreeNode_GetCut, Fake);
  RegisterMethod(TTreeNode,
       'procedure TTreeNode_PutCut(const Value: Boolean);',
       @TTreeNode_PutCut, Fake);
  RegisterProperty(TTreeNode,
       'property Cut:Boolean read TTreeNode_GetCut write TTreeNode_PutCut;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetData:Pointer;',
       @TTreeNode_GetData, Fake);
  RegisterMethod(TTreeNode,
       'procedure TTreeNode_PutData(const Value: Pointer);',
       @TTreeNode_PutData, Fake);
  RegisterProperty(TTreeNode,
       'property Data:Pointer read TTreeNode_GetData write TTreeNode_PutData;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetDeleting:Boolean;',
       @TTreeNode_GetDeleting, Fake);
  RegisterProperty(TTreeNode,
       'property Deleting:Boolean read TTreeNode_GetDeleting;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetFocused:Boolean;',
       @TTreeNode_GetFocused, Fake);
  RegisterMethod(TTreeNode,
       'procedure TTreeNode_PutFocused(const Value: Boolean);',
       @TTreeNode_PutFocused, Fake);
  RegisterProperty(TTreeNode,
       'property Focused:Boolean read TTreeNode_GetFocused write TTreeNode_PutFocused;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetDropTarget:Boolean;',
       @TTreeNode_GetDropTarget, Fake);
  RegisterMethod(TTreeNode,
       'procedure TTreeNode_PutDropTarget(const Value: Boolean);',
       @TTreeNode_PutDropTarget, Fake);
  RegisterProperty(TTreeNode,
       'property DropTarget:Boolean read TTreeNode_GetDropTarget write TTreeNode_PutDropTarget;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetSelected:Boolean;',
       @TTreeNode_GetSelected, Fake);
  RegisterMethod(TTreeNode,
       'procedure TTreeNode_PutSelected(const Value: Boolean);',
       @TTreeNode_PutSelected, Fake);
  RegisterProperty(TTreeNode,
       'property Selected:Boolean read TTreeNode_GetSelected write TTreeNode_PutSelected;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetExpanded:Boolean;',
       @TTreeNode_GetExpanded, Fake);
  RegisterMethod(TTreeNode,
       'procedure TTreeNode_PutExpanded(const Value: Boolean);',
       @TTreeNode_PutExpanded, Fake);
  RegisterProperty(TTreeNode,
       'property Expanded:Boolean read TTreeNode_GetExpanded write TTreeNode_PutExpanded;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetHandle:HWND;',
       @TTreeNode_GetHandle, Fake);
  RegisterProperty(TTreeNode,
       'property Handle:HWND read TTreeNode_GetHandle;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetHasChildren:Boolean;',
       @TTreeNode_GetHasChildren, Fake);
  RegisterMethod(TTreeNode,
       'procedure TTreeNode_PutHasChildren(const Value: Boolean);',
       @TTreeNode_PutHasChildren, Fake);
  RegisterProperty(TTreeNode,
       'property HasChildren:Boolean read TTreeNode_GetHasChildren write TTreeNode_PutHasChildren;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetImageIndex:TImageIndex;',
       @TTreeNode_GetImageIndex, Fake);
  RegisterMethod(TTreeNode,
       'procedure TTreeNode_PutImageIndex(const Value: TImageIndex);',
       @TTreeNode_PutImageIndex, Fake);
  RegisterProperty(TTreeNode,
       'property ImageIndex:TImageIndex read TTreeNode_GetImageIndex write TTreeNode_PutImageIndex;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetIndex:Integer;',
       @TTreeNode_GetIndex, Fake);
  RegisterProperty(TTreeNode,
       'property Index:Integer read TTreeNode_GetIndex;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetIsVisible:Boolean;',
       @TTreeNode_GetIsVisible, Fake);
  RegisterProperty(TTreeNode,
       'property IsVisible:Boolean read TTreeNode_GetIsVisible;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetItem(Index: Integer):TTreeNode;',
       @TTreeNode_GetItem, Fake);
  RegisterMethod(TTreeNode,
       'procedure TTreeNode_PutItem(Index: Integer;const Value: TTreeNode);',
       @TTreeNode_PutItem, Fake);
  RegisterProperty(TTreeNode,
       'property Item[Index: Integer]:TTreeNode read TTreeNode_GetItem write TTreeNode_PutItem;default;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetItemId:HTreeItem;',
       @TTreeNode_GetItemId, Fake);
  RegisterProperty(TTreeNode,
       'property ItemId:HTreeItem read TTreeNode_GetItemId;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetLevel:Integer;',
       @TTreeNode_GetLevel, Fake);
  RegisterProperty(TTreeNode,
       'property Level:Integer read TTreeNode_GetLevel;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetOverlayIndex:Integer;',
       @TTreeNode_GetOverlayIndex, Fake);
  RegisterMethod(TTreeNode,
       'procedure TTreeNode_PutOverlayIndex(const Value: Integer);',
       @TTreeNode_PutOverlayIndex, Fake);
  RegisterProperty(TTreeNode,
       'property OverlayIndex:Integer read TTreeNode_GetOverlayIndex write TTreeNode_PutOverlayIndex;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetOwner:TTreeNodes;',
       @TTreeNode_GetOwner, Fake);
  RegisterProperty(TTreeNode,
       'property Owner:TTreeNodes read TTreeNode_GetOwner;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetParent:TTreeNode;',
       @TTreeNode_GetParent, Fake);
  RegisterProperty(TTreeNode,
       'property Parent:TTreeNode read TTreeNode_GetParent;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetSelectedIndex:Integer;',
       @TTreeNode_GetSelectedIndex, Fake);
  RegisterMethod(TTreeNode,
       'procedure TTreeNode_PutSelectedIndex(const Value: Integer);',
       @TTreeNode_PutSelectedIndex, Fake);
  RegisterProperty(TTreeNode,
       'property SelectedIndex:Integer read TTreeNode_GetSelectedIndex write TTreeNode_PutSelectedIndex;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetStateIndex:Integer;',
       @TTreeNode_GetStateIndex, Fake);
  RegisterMethod(TTreeNode,
       'procedure TTreeNode_PutStateIndex(const Value: Integer);',
       @TTreeNode_PutStateIndex, Fake);
  RegisterProperty(TTreeNode,
       'property StateIndex:Integer read TTreeNode_GetStateIndex write TTreeNode_PutStateIndex;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetText:String;',
       @TTreeNode_GetText, Fake);
  RegisterMethod(TTreeNode,
       'procedure TTreeNode_PutText(const Value: String);',
       @TTreeNode_PutText, Fake);
  RegisterProperty(TTreeNode,
       'property Text:String read TTreeNode_GetText write TTreeNode_PutText;');
  RegisterMethod(TTreeNode,
       'function TTreeNode_GetTreeView:TCustomTreeView;',
       @TTreeNode_GetTreeView, Fake);
  RegisterProperty(TTreeNode,
       'property TreeView:TCustomTreeView read TTreeNode_GetTreeView;');
  // End of class TTreeNode
  // Begin of class TTreeNodes
  RegisterClassType(TTreeNodes, H);
  RegisterMethod(TTreeNodes,
       'constructor Create(AOwner: TCustomTreeView);',
       @TTreeNodes.Create);
  RegisterMethod(TTreeNodes,
       'destructor Destroy; override;',
       @TTreeNodes.Destroy);
  RegisterMethod(TTreeNodes,
       'function AddChildFirst(Node: TTreeNode; const S: string): TTreeNode;',
       @TTreeNodes.AddChildFirst);
  RegisterMethod(TTreeNodes,
       'function AddChild(Node: TTreeNode; const S: string): TTreeNode;',
       @TTreeNodes.AddChild);
  RegisterMethod(TTreeNodes,
       'function AddChildObjectFirst(Node: TTreeNode; const S: string;      Ptr: Pointer): TTreeNode;',
       @TTreeNodes.AddChildObjectFirst);
  RegisterMethod(TTreeNodes,
       'function AddChildObject(Node: TTreeNode; const S: string;      Ptr: Pointer): TTreeNode;',
       @TTreeNodes.AddChildObject);
  RegisterMethod(TTreeNodes,
       'function AddFirst(Node: TTreeNode; const S: string): TTreeNode;',
       @TTreeNodes.AddFirst);
  RegisterMethod(TTreeNodes,
       'function Add(Node: TTreeNode; const S: string): TTreeNode;',
       @TTreeNodes.Add);
  RegisterMethod(TTreeNodes,
       'function AddObjectFirst(Node: TTreeNode; const S: string;      Ptr: Pointer): TTreeNode;',
       @TTreeNodes.AddObjectFirst);
  RegisterMethod(TTreeNodes,
       'function AddObject(Node: TTreeNode; const S: string;      Ptr: Pointer): TTreeNode;',
       @TTreeNodes.AddObject);
  RegisterMethod(TTreeNodes,
       'procedure Assign(Source: TPersistent); override;',
       @TTreeNodes.Assign);
  RegisterMethod(TTreeNodes,
       'procedure BeginUpdate;',
       @TTreeNodes.BeginUpdate);
  RegisterMethod(TTreeNodes,
       'procedure Clear;',
       @TTreeNodes.Clear);
  RegisterMethod(TTreeNodes,
       'procedure Delete(Node: TTreeNode);',
       @TTreeNodes.Delete);
  RegisterMethod(TTreeNodes,
       'procedure EndUpdate;',
       @TTreeNodes.EndUpdate);
  RegisterMethod(TTreeNodes,
       'function GetFirstNode: TTreeNode;',
       @TTreeNodes.GetFirstNode);
  RegisterMethod(TTreeNodes,
       'function GetNode(ItemId: HTreeItem): TTreeNode;',
       @TTreeNodes.GetNode);
  RegisterMethod(TTreeNodes,
       'function Insert(Node: TTreeNode; const S: string): TTreeNode;',
       @TTreeNodes.Insert);
  RegisterMethod(TTreeNodes,
       'function InsertObject(Node: TTreeNode; const S: string;      Ptr: Pointer): TTreeNode;',
       @TTreeNodes.InsertObject);
  RegisterMethod(TTreeNodes,
       'function TTreeNodes_GetCount:Integer;',
       @TTreeNodes_GetCount, Fake);
  RegisterProperty(TTreeNodes,
       'property Count:Integer read TTreeNodes_GetCount;');
  RegisterMethod(TTreeNodes,
       'function TTreeNodes_GetHandle:HWND;',
       @TTreeNodes_GetHandle, Fake);
  RegisterProperty(TTreeNodes,
       'property Handle:HWND read TTreeNodes_GetHandle;');
  RegisterMethod(TTreeNodes,
       'function TTreeNodes_GetItem(Index: Integer):TTreeNode;',
       @TTreeNodes_GetItem, Fake);
  RegisterProperty(TTreeNodes,
       'property Item[Index: Integer]:TTreeNode read TTreeNodes_GetItem;default;');
  RegisterMethod(TTreeNodes,
       'function TTreeNodes_GetOwner:TCustomTreeView;',
       @TTreeNodes_GetOwner, Fake);
  RegisterProperty(TTreeNodes,
       'property Owner:TCustomTreeView read TTreeNodes_GetOwner;');
  // End of class TTreeNodes
  RegisterRTTIType(TypeInfo(TSortType));
  // Begin of class TCustomTreeView
  RegisterClassType(TCustomTreeView, H);
  RegisterMethod(TCustomTreeView,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomTreeView.Create);
  RegisterMethod(TCustomTreeView,
       'destructor Destroy; override;',
       @TCustomTreeView.Destroy);
  RegisterMethod(TCustomTreeView,
       'function AlphaSort: Boolean;',
       @TCustomTreeView.AlphaSort);
  RegisterMethod(TCustomTreeView,
       'function CustomSort(SortProc: TTVCompare; Data: Longint): Boolean;',
       @TCustomTreeView.CustomSort);
  RegisterMethod(TCustomTreeView,
       'procedure FullCollapse;',
       @TCustomTreeView.FullCollapse);
  RegisterMethod(TCustomTreeView,
       'procedure FullExpand;',
       @TCustomTreeView.FullExpand);
  RegisterMethod(TCustomTreeView,
       'function GetHitTestInfoAt(X, Y: Integer): THitTests;',
       @TCustomTreeView.GetHitTestInfoAt);
  RegisterMethod(TCustomTreeView,
       'function GetNodeAt(X, Y: Integer): TTreeNode;',
       @TCustomTreeView.GetNodeAt);
  RegisterMethod(TCustomTreeView,
       'function IsEditing: Boolean;',
       @TCustomTreeView.IsEditing);
  RegisterMethod(TCustomTreeView,
       'procedure LoadFromFile(const FileName: string);',
       @TCustomTreeView.LoadFromFile);
  RegisterMethod(TCustomTreeView,
       'procedure LoadFromStream(Stream: TStream);',
       @TCustomTreeView.LoadFromStream);
  RegisterMethod(TCustomTreeView,
       'procedure SaveToFile(const FileName: string);',
       @TCustomTreeView.SaveToFile);
  RegisterMethod(TCustomTreeView,
       'procedure SaveToStream(Stream: TStream);',
       @TCustomTreeView.SaveToStream);
  RegisterMethod(TCustomTreeView,
       'function TCustomTreeView_GetCanvas:TCanvas;',
       @TCustomTreeView_GetCanvas, Fake);
  RegisterProperty(TCustomTreeView,
       'property Canvas:TCanvas read TCustomTreeView_GetCanvas;');
  RegisterMethod(TCustomTreeView,
       'function TCustomTreeView_GetDropTarget:TTreeNode;',
       @TCustomTreeView_GetDropTarget, Fake);
  RegisterMethod(TCustomTreeView,
       'procedure TCustomTreeView_PutDropTarget(const Value: TTreeNode);',
       @TCustomTreeView_PutDropTarget, Fake);
  RegisterProperty(TCustomTreeView,
       'property DropTarget:TTreeNode read TCustomTreeView_GetDropTarget write TCustomTreeView_PutDropTarget;');
  RegisterMethod(TCustomTreeView,
       'function TCustomTreeView_GetSelected:TTreeNode;',
       @TCustomTreeView_GetSelected, Fake);
  RegisterMethod(TCustomTreeView,
       'procedure TCustomTreeView_PutSelected(const Value: TTreeNode);',
       @TCustomTreeView_PutSelected, Fake);
  RegisterProperty(TCustomTreeView,
       'property Selected:TTreeNode read TCustomTreeView_GetSelected write TCustomTreeView_PutSelected;');
  RegisterMethod(TCustomTreeView,
       'function TCustomTreeView_GetTopItem:TTreeNode;',
       @TCustomTreeView_GetTopItem, Fake);
  RegisterMethod(TCustomTreeView,
       'procedure TCustomTreeView_PutTopItem(const Value: TTreeNode);',
       @TCustomTreeView_PutTopItem, Fake);
  RegisterProperty(TCustomTreeView,
       'property TopItem:TTreeNode read TCustomTreeView_GetTopItem write TCustomTreeView_PutTopItem;');
  // End of class TCustomTreeView
  // Begin of class TTreeView
  RegisterClassType(TTreeView, H);
  RegisterMethod(TTreeView,
       'constructor Create(AOwner: TComponent); override;',
       @TTreeView.Create);
  // End of class TTreeView
  RegisterRTTIType(TypeInfo(TTrackBarOrientation));
  RegisterRTTIType(TypeInfo(TTickMark));
  RegisterRTTIType(TypeInfo(TTickStyle));
  // Begin of class TTrackBar
  RegisterClassType(TTrackBar, H);
  RegisterMethod(TTrackBar,
       'constructor Create(AOwner: TComponent); override;',
       @TTrackBar.Create);
  RegisterMethod(TTrackBar,
       'procedure SetTick(Value: Integer);',
       @TTrackBar.SetTick);
  // End of class TTrackBar
  RegisterRTTIType(TypeInfo(TProgressBarOrientation));
  // Begin of class TProgressBar
  RegisterClassType(TProgressBar, H);
  RegisterMethod(TProgressBar,
       'constructor Create(AOwner: TComponent); override;',
       @TProgressBar.Create);
  RegisterMethod(TProgressBar,
       'procedure StepIt;',
       @TProgressBar.StepIt);
  RegisterMethod(TProgressBar,
       'procedure StepBy(Delta: Integer);',
       @TProgressBar.StepBy);
  // End of class TProgressBar
  RegisterRTTIType(TypeInfo(TAttributeType));
  RegisterRTTIType(TypeInfo(TConsistentAttribute));
  // Begin of class TTextAttributes
  RegisterClassType(TTextAttributes, H);
  RegisterMethod(TTextAttributes,
       'constructor Create(AOwner: TCustomRichEdit; AttributeType: TAttributeType);',
       @TTextAttributes.Create);
  RegisterMethod(TTextAttributes,
       'procedure Assign(Source: TPersistent); override;',
       @TTextAttributes.Assign);
  RegisterMethod(TTextAttributes,
       'function TTextAttributes_GetCharset:TFontCharset;',
       @TTextAttributes_GetCharset, Fake);
  RegisterMethod(TTextAttributes,
       'procedure TTextAttributes_PutCharset(const Value: TFontCharset);',
       @TTextAttributes_PutCharset, Fake);
  RegisterProperty(TTextAttributes,
       'property Charset:TFontCharset read TTextAttributes_GetCharset write TTextAttributes_PutCharset;');
  RegisterMethod(TTextAttributes,
       'function TTextAttributes_GetColor:TColor;',
       @TTextAttributes_GetColor, Fake);
  RegisterMethod(TTextAttributes,
       'procedure TTextAttributes_PutColor(const Value: TColor);',
       @TTextAttributes_PutColor, Fake);
  RegisterProperty(TTextAttributes,
       'property Color:TColor read TTextAttributes_GetColor write TTextAttributes_PutColor;');
  RegisterMethod(TTextAttributes,
       'function TTextAttributes_GetConsistentAttributes:TConsistentAttributes;',
       @TTextAttributes_GetConsistentAttributes, Fake);
  RegisterProperty(TTextAttributes,
       'property ConsistentAttributes:TConsistentAttributes read TTextAttributes_GetConsistentAttributes;');
  RegisterMethod(TTextAttributes,
       'function TTextAttributes_GetName:TFontName;',
       @TTextAttributes_GetName, Fake);
  RegisterMethod(TTextAttributes,
       'procedure TTextAttributes_PutName(const Value: TFontName);',
       @TTextAttributes_PutName, Fake);
  RegisterProperty(TTextAttributes,
       'property Name:TFontName read TTextAttributes_GetName write TTextAttributes_PutName;');
  RegisterMethod(TTextAttributes,
       'function TTextAttributes_GetPitch:TFontPitch;',
       @TTextAttributes_GetPitch, Fake);
  RegisterMethod(TTextAttributes,
       'procedure TTextAttributes_PutPitch(const Value: TFontPitch);',
       @TTextAttributes_PutPitch, Fake);
  RegisterProperty(TTextAttributes,
       'property Pitch:TFontPitch read TTextAttributes_GetPitch write TTextAttributes_PutPitch;');
  RegisterMethod(TTextAttributes,
       'function TTextAttributes_GetProtected:Boolean;',
       @TTextAttributes_GetProtected, Fake);
  RegisterMethod(TTextAttributes,
       'procedure TTextAttributes_PutProtected(const Value: Boolean);',
       @TTextAttributes_PutProtected, Fake);
  RegisterProperty(TTextAttributes,
       'property Protected:Boolean read TTextAttributes_GetProtected write TTextAttributes_PutProtected;');
  RegisterMethod(TTextAttributes,
       'function TTextAttributes_GetSize:Integer;',
       @TTextAttributes_GetSize, Fake);
  RegisterMethod(TTextAttributes,
       'procedure TTextAttributes_PutSize(const Value: Integer);',
       @TTextAttributes_PutSize, Fake);
  RegisterProperty(TTextAttributes,
       'property Size:Integer read TTextAttributes_GetSize write TTextAttributes_PutSize;');
  RegisterMethod(TTextAttributes,
       'function TTextAttributes_GetStyle:TFontStyles;',
       @TTextAttributes_GetStyle, Fake);
  RegisterMethod(TTextAttributes,
       'procedure TTextAttributes_PutStyle(const Value: TFontStyles);',
       @TTextAttributes_PutStyle, Fake);
  RegisterProperty(TTextAttributes,
       'property Style:TFontStyles read TTextAttributes_GetStyle write TTextAttributes_PutStyle;');
  RegisterMethod(TTextAttributes,
       'function TTextAttributes_GetHeight:Integer;',
       @TTextAttributes_GetHeight, Fake);
  RegisterMethod(TTextAttributes,
       'procedure TTextAttributes_PutHeight(const Value: Integer);',
       @TTextAttributes_PutHeight, Fake);
  RegisterProperty(TTextAttributes,
       'property Height:Integer read TTextAttributes_GetHeight write TTextAttributes_PutHeight;');
  // End of class TTextAttributes
  RegisterRTTIType(TypeInfo(TNumberingStyle));
  // Begin of class TParaAttributes
  RegisterClassType(TParaAttributes, H);
  RegisterMethod(TParaAttributes,
       'constructor Create(AOwner: TCustomRichEdit);',
       @TParaAttributes.Create);
  RegisterMethod(TParaAttributes,
       'procedure Assign(Source: TPersistent); override;',
       @TParaAttributes.Assign);
  RegisterMethod(TParaAttributes,
       'function TParaAttributes_GetAlignment:TAlignment;',
       @TParaAttributes_GetAlignment, Fake);
  RegisterMethod(TParaAttributes,
       'procedure TParaAttributes_PutAlignment(const Value: TAlignment);',
       @TParaAttributes_PutAlignment, Fake);
  RegisterProperty(TParaAttributes,
       'property Alignment:TAlignment read TParaAttributes_GetAlignment write TParaAttributes_PutAlignment;');
  RegisterMethod(TParaAttributes,
       'function TParaAttributes_GetFirstIndent:Longint;',
       @TParaAttributes_GetFirstIndent, Fake);
  RegisterMethod(TParaAttributes,
       'procedure TParaAttributes_PutFirstIndent(const Value: Longint);',
       @TParaAttributes_PutFirstIndent, Fake);
  RegisterProperty(TParaAttributes,
       'property FirstIndent:Longint read TParaAttributes_GetFirstIndent write TParaAttributes_PutFirstIndent;');
  RegisterMethod(TParaAttributes,
       'function TParaAttributes_GetLeftIndent:Longint;',
       @TParaAttributes_GetLeftIndent, Fake);
  RegisterMethod(TParaAttributes,
       'procedure TParaAttributes_PutLeftIndent(const Value: Longint);',
       @TParaAttributes_PutLeftIndent, Fake);
  RegisterProperty(TParaAttributes,
       'property LeftIndent:Longint read TParaAttributes_GetLeftIndent write TParaAttributes_PutLeftIndent;');
  RegisterMethod(TParaAttributes,
       'function TParaAttributes_GetNumbering:TNumberingStyle;',
       @TParaAttributes_GetNumbering, Fake);
  RegisterMethod(TParaAttributes,
       'procedure TParaAttributes_PutNumbering(const Value: TNumberingStyle);',
       @TParaAttributes_PutNumbering, Fake);
  RegisterProperty(TParaAttributes,
       'property Numbering:TNumberingStyle read TParaAttributes_GetNumbering write TParaAttributes_PutNumbering;');
  RegisterMethod(TParaAttributes,
       'function TParaAttributes_GetRightIndent:Longint;',
       @TParaAttributes_GetRightIndent, Fake);
  RegisterMethod(TParaAttributes,
       'procedure TParaAttributes_PutRightIndent(const Value: Longint);',
       @TParaAttributes_PutRightIndent, Fake);
  RegisterProperty(TParaAttributes,
       'property RightIndent:Longint read TParaAttributes_GetRightIndent write TParaAttributes_PutRightIndent;');
  RegisterMethod(TParaAttributes,
       'function TParaAttributes_GetTab(Index: Byte):Longint;',
       @TParaAttributes_GetTab, Fake);
  RegisterMethod(TParaAttributes,
       'procedure TParaAttributes_PutTab(Index: Byte;const Value: Longint);',
       @TParaAttributes_PutTab, Fake);
  RegisterProperty(TParaAttributes,
       'property Tab[Index: Byte]:Longint read TParaAttributes_GetTab write TParaAttributes_PutTab;');
  RegisterMethod(TParaAttributes,
       'function TParaAttributes_GetTabCount:Integer;',
       @TParaAttributes_GetTabCount, Fake);
  RegisterMethod(TParaAttributes,
       'procedure TParaAttributes_PutTabCount(const Value: Integer);',
       @TParaAttributes_PutTabCount, Fake);
  RegisterProperty(TParaAttributes,
       'property TabCount:Integer read TParaAttributes_GetTabCount write TParaAttributes_PutTabCount;');
  // End of class TParaAttributes
  RegisterRTTIType(TypeInfo(TSearchType));
  // Begin of class TConversion
  RegisterClassType(TConversion, H);
  RegisterMethod(TConversion,
       'function ConvertReadStream(Stream: TStream; Buffer: PChar; BufSize: Integer): Integer; virtual;',
       @TConversion.ConvertReadStream);
  RegisterMethod(TConversion,
       'function ConvertWriteStream(Stream: TStream; Buffer: PChar; BufSize: Integer): Integer; virtual;',
       @TConversion.ConvertWriteStream);
  RegisterMethod(TConversion,
       'constructor Create;',
       @TConversion.Create);
  // End of class TConversion
  // Begin of class TCustomRichEdit
  RegisterClassType(TCustomRichEdit, H);
  RegisterMethod(TCustomRichEdit,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomRichEdit.Create);
  RegisterMethod(TCustomRichEdit,
       'destructor Destroy; override;',
       @TCustomRichEdit.Destroy);
  RegisterMethod(TCustomRichEdit,
       'procedure Clear; override;',
       @TCustomRichEdit.Clear);
  RegisterMethod(TCustomRichEdit,
       'function FindText(const SearchStr: string;      StartPos, Length: Integer; Options: TSearchTypes): Integer;',
       @TCustomRichEdit.FindText);
  RegisterMethod(TCustomRichEdit,
       'function GetSelTextBuf(Buffer: PChar; BufSize: Integer): Integer; override;',
       @TCustomRichEdit.GetSelTextBuf);
  RegisterMethod(TCustomRichEdit,
       'procedure Print(const Caption: string); virtual;',
       @TCustomRichEdit.Print);
  RegisterMethod(TCustomRichEdit,
       'procedure RegisterConversionFormat(const AExtension: string;      AConversionClass: TConversionClass);',
       @TCustomRichEdit.RegisterConversionFormat);
  RegisterMethod(TCustomRichEdit,
       'function TCustomRichEdit_GetDefaultConverter:TConversionClass;',
       @TCustomRichEdit_GetDefaultConverter, Fake);
  RegisterMethod(TCustomRichEdit,
       'procedure TCustomRichEdit_PutDefaultConverter(const Value: TConversionClass);',
       @TCustomRichEdit_PutDefaultConverter, Fake);
  RegisterProperty(TCustomRichEdit,
       'property DefaultConverter:TConversionClass read TCustomRichEdit_GetDefaultConverter write TCustomRichEdit_PutDefaultConverter;');
  RegisterMethod(TCustomRichEdit,
       'function TCustomRichEdit_GetDefAttributes:TTextAttributes;',
       @TCustomRichEdit_GetDefAttributes, Fake);
  RegisterMethod(TCustomRichEdit,
       'procedure TCustomRichEdit_PutDefAttributes(const Value: TTextAttributes);',
       @TCustomRichEdit_PutDefAttributes, Fake);
  RegisterProperty(TCustomRichEdit,
       'property DefAttributes:TTextAttributes read TCustomRichEdit_GetDefAttributes write TCustomRichEdit_PutDefAttributes;');
  RegisterMethod(TCustomRichEdit,
       'function TCustomRichEdit_GetSelAttributes:TTextAttributes;',
       @TCustomRichEdit_GetSelAttributes, Fake);
  RegisterMethod(TCustomRichEdit,
       'procedure TCustomRichEdit_PutSelAttributes(const Value: TTextAttributes);',
       @TCustomRichEdit_PutSelAttributes, Fake);
  RegisterProperty(TCustomRichEdit,
       'property SelAttributes:TTextAttributes read TCustomRichEdit_GetSelAttributes write TCustomRichEdit_PutSelAttributes;');
  RegisterMethod(TCustomRichEdit,
       'function TCustomRichEdit_GetPageRect:TRect;',
       @TCustomRichEdit_GetPageRect, Fake);
  RegisterMethod(TCustomRichEdit,
       'procedure TCustomRichEdit_PutPageRect(const Value: TRect);',
       @TCustomRichEdit_PutPageRect, Fake);
  RegisterProperty(TCustomRichEdit,
       'property PageRect:TRect read TCustomRichEdit_GetPageRect write TCustomRichEdit_PutPageRect;');
  RegisterMethod(TCustomRichEdit,
       'function TCustomRichEdit_GetParagraph:TParaAttributes;',
       @TCustomRichEdit_GetParagraph, Fake);
  RegisterProperty(TCustomRichEdit,
       'property Paragraph:TParaAttributes read TCustomRichEdit_GetParagraph;');
  // End of class TCustomRichEdit
  // Begin of class TRichEdit
  RegisterClassType(TRichEdit, H);
  RegisterMethod(TRichEdit,
       'constructor Create(AOwner: TComponent); override;',
       @TRichEdit.Create);
  // End of class TRichEdit
  RegisterRTTIType(TypeInfo(TUDAlignButton));
  RegisterRTTIType(TypeInfo(TUDOrientation));
  RegisterRTTIType(TypeInfo(TUDBtnType));
  RegisterRTTIType(TypeInfo(TUpDownDirection));
  // Begin of class TCustomUpDown
  RegisterClassType(TCustomUpDown, H);
  RegisterMethod(TCustomUpDown,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomUpDown.Create);
  // End of class TCustomUpDown
  // Begin of class TUpDown
  RegisterClassType(TUpDown, H);
  RegisterMethod(TUpDown,
       'constructor Create(AOwner: TComponent); override;',
       @TUpDown.Create);
  // End of class TUpDown
  RegisterRTTIType(TypeInfo(THKModifier));
  RegisterRTTIType(TypeInfo(THKInvalidKey));
  // Begin of class TCustomHotKey
  RegisterClassType(TCustomHotKey, H);
  RegisterMethod(TCustomHotKey,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomHotKey.Create);
  // End of class TCustomHotKey
  // Begin of class THotKey
  RegisterClassType(THotKey, H);
  RegisterMethod(THotKey,
       'constructor Create(AOwner: TComponent); override;',
       @THotKey.Create);
  // End of class THotKey
  // Begin of class TListColumn
  RegisterClassType(TListColumn, H);
  RegisterMethod(TListColumn,
       'constructor Create(Collection: TCollection); override;',
       @TListColumn.Create);
  RegisterMethod(TListColumn,
       'destructor Destroy; override;',
       @TListColumn.Destroy);
  RegisterMethod(TListColumn,
       'procedure Assign(Source: TPersistent); override;',
       @TListColumn.Assign);
  RegisterMethod(TListColumn,
       'function TListColumn_GetWidthType:TWidth;',
       @TListColumn_GetWidthType, Fake);
  RegisterProperty(TListColumn,
       'property WidthType:TWidth read TListColumn_GetWidthType;');
  // End of class TListColumn
  // Begin of class TListColumns
  RegisterClassType(TListColumns, H);
  RegisterMethod(TListColumns,
       'constructor Create(AOwner: TCustomListView);',
       @TListColumns.Create);
  RegisterMethod(TListColumns,
       'function Add: TListColumn;',
       @TListColumns.Add);
  RegisterMethod(TListColumns,
       'function TListColumns_GetOwner:TCustomListView;',
       @TListColumns_GetOwner, Fake);
  RegisterProperty(TListColumns,
       'property Owner:TCustomListView read TListColumns_GetOwner;');
  RegisterMethod(TListColumns,
       'function TListColumns_GetItems(Index: Integer):TListColumn;',
       @TListColumns_GetItems, Fake);
  RegisterMethod(TListColumns,
       'procedure TListColumns_PutItems(Index: Integer;const Value: TListColumn);',
       @TListColumns_PutItems, Fake);
  RegisterProperty(TListColumns,
       'property Items[Index: Integer]:TListColumn read TListColumns_GetItems write TListColumns_PutItems;default;');
  // End of class TListColumns
  RegisterRTTIType(TypeInfo(TDisplayCode));
  // Begin of class TListItem
  RegisterClassType(TListItem, H);
  RegisterMethod(TListItem,
       'constructor Create(AOwner: TListItems);',
       @TListItem.Create);
  RegisterMethod(TListItem,
       'destructor Destroy; override;',
       @TListItem.Destroy);
  RegisterMethod(TListItem,
       'procedure Assign(Source: TPersistent); override;',
       @TListItem.Assign);
  RegisterMethod(TListItem,
       'procedure CancelEdit;',
       @TListItem.CancelEdit);
  RegisterMethod(TListItem,
       'procedure Delete;',
       @TListItem.Delete);
  RegisterMethod(TListItem,
       'function DisplayRect(Code: TDisplayCode): TRect;',
       @TListItem.DisplayRect);
  RegisterMethod(TListItem,
       'function EditCaption: Boolean;',
       @TListItem.EditCaption);
  RegisterMethod(TListItem,
       'function GetPosition: TPoint;',
       @TListItem.GetPosition);
  RegisterMethod(TListItem,
       'procedure MakeVisible(PartialOK: Boolean);',
       @TListItem.MakeVisible);
  RegisterMethod(TListItem,
       'procedure Update;',
       @TListItem.Update);
  RegisterMethod(TListItem,
       'procedure SetPosition(const Value: TPoint);',
       @TListItem.SetPosition);
  RegisterMethod(TListItem,
       'function WorkArea: Integer;',
       @TListItem.WorkArea);
  RegisterMethod(TListItem,
       'function TListItem_GetCaption:String;',
       @TListItem_GetCaption, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutCaption(const Value: String);',
       @TListItem_PutCaption, Fake);
  RegisterProperty(TListItem,
       'property Caption:String read TListItem_GetCaption write TListItem_PutCaption;');
  RegisterMethod(TListItem,
       'function TListItem_GetChecked:Boolean;',
       @TListItem_GetChecked, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutChecked(const Value: Boolean);',
       @TListItem_PutChecked, Fake);
  RegisterProperty(TListItem,
       'property Checked:Boolean read TListItem_GetChecked write TListItem_PutChecked;');
  RegisterMethod(TListItem,
       'function TListItem_GetCut:Boolean;',
       @TListItem_GetCut, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutCut(const Value: Boolean);',
       @TListItem_PutCut, Fake);
  RegisterProperty(TListItem,
       'property Cut:Boolean read TListItem_GetCut write TListItem_PutCut;');
  RegisterMethod(TListItem,
       'function TListItem_GetData:Pointer;',
       @TListItem_GetData, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutData(const Value: Pointer);',
       @TListItem_PutData, Fake);
  RegisterProperty(TListItem,
       'property Data:Pointer read TListItem_GetData write TListItem_PutData;');
  RegisterMethod(TListItem,
       'function TListItem_GetDropTarget:Boolean;',
       @TListItem_GetDropTarget, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutDropTarget(const Value: Boolean);',
       @TListItem_PutDropTarget, Fake);
  RegisterProperty(TListItem,
       'property DropTarget:Boolean read TListItem_GetDropTarget write TListItem_PutDropTarget;');
  RegisterMethod(TListItem,
       'function TListItem_GetFocused:Boolean;',
       @TListItem_GetFocused, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutFocused(const Value: Boolean);',
       @TListItem_PutFocused, Fake);
  RegisterProperty(TListItem,
       'property Focused:Boolean read TListItem_GetFocused write TListItem_PutFocused;');
  RegisterMethod(TListItem,
       'function TListItem_GetHandle:HWND;',
       @TListItem_GetHandle, Fake);
  RegisterProperty(TListItem,
       'property Handle:HWND read TListItem_GetHandle;');
  RegisterMethod(TListItem,
       'function TListItem_GetImageIndex:TImageIndex;',
       @TListItem_GetImageIndex, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutImageIndex(const Value: TImageIndex);',
       @TListItem_PutImageIndex, Fake);
  RegisterProperty(TListItem,
       'property ImageIndex:TImageIndex read TListItem_GetImageIndex write TListItem_PutImageIndex;');
  RegisterMethod(TListItem,
       'function TListItem_GetIndent:Integer;',
       @TListItem_GetIndent, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutIndent(const Value: Integer);',
       @TListItem_PutIndent, Fake);
  RegisterProperty(TListItem,
       'property Indent:Integer read TListItem_GetIndent write TListItem_PutIndent;');
  RegisterMethod(TListItem,
       'function TListItem_GetIndex:Integer;',
       @TListItem_GetIndex, Fake);
  RegisterProperty(TListItem,
       'property Index:Integer read TListItem_GetIndex;');
  RegisterMethod(TListItem,
       'function TListItem_GetLeft:Integer;',
       @TListItem_GetLeft, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutLeft(const Value: Integer);',
       @TListItem_PutLeft, Fake);
  RegisterProperty(TListItem,
       'property Left:Integer read TListItem_GetLeft write TListItem_PutLeft;');
  RegisterMethod(TListItem,
       'function TListItem_GetListView:TCustomListView;',
       @TListItem_GetListView, Fake);
  RegisterProperty(TListItem,
       'property ListView:TCustomListView read TListItem_GetListView;');
  RegisterMethod(TListItem,
       'function TListItem_GetOwner:TListItems;',
       @TListItem_GetOwner, Fake);
  RegisterProperty(TListItem,
       'property Owner:TListItems read TListItem_GetOwner;');
  RegisterMethod(TListItem,
       'function TListItem_GetOverlayIndex:TImageIndex;',
       @TListItem_GetOverlayIndex, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutOverlayIndex(const Value: TImageIndex);',
       @TListItem_PutOverlayIndex, Fake);
  RegisterProperty(TListItem,
       'property OverlayIndex:TImageIndex read TListItem_GetOverlayIndex write TListItem_PutOverlayIndex;');
  RegisterMethod(TListItem,
       'function TListItem_GetPosition:TPoint;',
       @TListItem_GetPosition, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutPosition(const Value: TPoint);',
       @TListItem_PutPosition, Fake);
  RegisterProperty(TListItem,
       'property Position:TPoint read TListItem_GetPosition write TListItem_PutPosition;');
  RegisterMethod(TListItem,
       'function TListItem_GetSelected:Boolean;',
       @TListItem_GetSelected, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutSelected(const Value: Boolean);',
       @TListItem_PutSelected, Fake);
  RegisterProperty(TListItem,
       'property Selected:Boolean read TListItem_GetSelected write TListItem_PutSelected;');
  RegisterMethod(TListItem,
       'function TListItem_GetStateIndex:TImageIndex;',
       @TListItem_GetStateIndex, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutStateIndex(const Value: TImageIndex);',
       @TListItem_PutStateIndex, Fake);
  RegisterProperty(TListItem,
       'property StateIndex:TImageIndex read TListItem_GetStateIndex write TListItem_PutStateIndex;');
  RegisterMethod(TListItem,
       'function TListItem_GetSubItems:TStrings;',
       @TListItem_GetSubItems, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutSubItems(const Value: TStrings);',
       @TListItem_PutSubItems, Fake);
  RegisterProperty(TListItem,
       'property SubItems:TStrings read TListItem_GetSubItems write TListItem_PutSubItems;');
  RegisterMethod(TListItem,
       'function TListItem_GetSubItemImages(Index: Integer):Integer;',
       @TListItem_GetSubItemImages, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutSubItemImages(Index: Integer;const Value: Integer);',
       @TListItem_PutSubItemImages, Fake);
  RegisterProperty(TListItem,
       'property SubItemImages[Index: Integer]:Integer read TListItem_GetSubItemImages write TListItem_PutSubItemImages;');
  RegisterMethod(TListItem,
       'function TListItem_GetTop:Integer;',

       @TListItem_GetTop, Fake);
  RegisterMethod(TListItem,
       'procedure TListItem_PutTop(const Value: Integer);',
       @TListItem_PutTop, Fake);
  RegisterProperty(TListItem,
       'property Top:Integer read TListItem_GetTop write TListItem_PutTop;');
  // End of class TListItem
  // Begin of class TListItems
  RegisterClassType(TListItems, H);
  RegisterMethod(TListItems,
       'constructor Create(AOwner: TCustomListView);',
       @TListItems.Create);
  RegisterMethod(TListItems,
       'destructor Destroy; override;',
       @TListItems.Destroy);
  RegisterMethod(TListItems,
       'function Add: TListItem;',
       @TListItems.Add);
  RegisterMethod(TListItems,
       'procedure Assign(Source: TPersistent); override;',
       @TListItems.Assign);
  RegisterMethod(TListItems,
       'procedure BeginUpdate;',
       @TListItems.BeginUpdate);
  RegisterMethod(TListItems,
       'procedure Clear;',
       @TListItems.Clear);
  RegisterMethod(TListItems,
       'procedure Delete(Index: Integer);',
       @TListItems.Delete);
  RegisterMethod(TListItems,
       'procedure EndUpdate;',
       @TListItems.EndUpdate);
  RegisterMethod(TListItems,
       'function IndexOf(Value: TListItem): Integer;',
       @TListItems.IndexOf);
  RegisterMethod(TListItems,
       'function Insert(Index: Integer): TListItem;',
       @TListItems.Insert);
  RegisterMethod(TListItems,
       'function TListItems_GetCount:Integer;',
       @TListItems_GetCount, Fake);
  RegisterMethod(TListItems,
       'procedure TListItems_PutCount(const Value: Integer);',
       @TListItems_PutCount, Fake);
  RegisterProperty(TListItems,
       'property Count:Integer read TListItems_GetCount write TListItems_PutCount;');
  RegisterMethod(TListItems,
       'function TListItems_GetHandle:HWND;',
       @TListItems_GetHandle, Fake);
  RegisterProperty(TListItems,
       'property Handle:HWND read TListItems_GetHandle;');
  RegisterMethod(TListItems,
       'function TListItems_GetItem(Index: Integer):TListItem;',
       @TListItems_GetItem, Fake);
  RegisterMethod(TListItems,
       'procedure TListItems_PutItem(Index: Integer;const Value: TListItem);',
       @TListItems_PutItem, Fake);
  RegisterProperty(TListItems,
       'property Item[Index: Integer]:TListItem read TListItems_GetItem write TListItems_PutItem;default;');
  RegisterMethod(TListItems,
       'function TListItems_GetOwner:TCustomListView;',
       @TListItems_GetOwner, Fake);
  RegisterProperty(TListItems,
       'property Owner:TCustomListView read TListItems_GetOwner;');
  // End of class TListItems
  // Begin of class TWorkArea
  RegisterClassType(TWorkArea, H);
  RegisterMethod(TWorkArea,
       'constructor Create(Collection: TCollection); override;',
       @TWorkArea.Create);
  RegisterMethod(TWorkArea,
       'procedure SetDisplayName(const Value: string); override;',
       @TWorkArea.SetDisplayName);
  RegisterMethod(TWorkArea,
       'function  GetDisplayName: string; override;',
       @TWorkArea.GetDisplayName);
  RegisterMethod(TWorkArea,
       'function TWorkArea_GetRect:TRect;',
       @TWorkArea_GetRect, Fake);
  RegisterMethod(TWorkArea,
       'procedure TWorkArea_PutRect(const Value: TRect);',
       @TWorkArea_PutRect, Fake);
  RegisterProperty(TWorkArea,
       'property Rect:TRect read TWorkArea_GetRect write TWorkArea_PutRect;');
  RegisterMethod(TWorkArea,
       'function TWorkArea_GetColor:TColor;',
       @TWorkArea_GetColor, Fake);
  RegisterMethod(TWorkArea,
       'procedure TWorkArea_PutColor(const Value: TColor);',
       @TWorkArea_PutColor, Fake);
  RegisterProperty(TWorkArea,
       'property Color:TColor read TWorkArea_GetColor write TWorkArea_PutColor;');
  // End of class TWorkArea
  // Begin of class TWorkAreas
  RegisterClassType(TWorkAreas, H);
  RegisterMethod(TWorkAreas,
       'function  Add: TWorkArea;',
       @TWorkAreas.Add);
  RegisterMethod(TWorkAreas,
       'procedure Delete(Index: Integer);',
       @TWorkAreas.Delete);
  RegisterMethod(TWorkAreas,
       'function  Insert(Index: Integer): TWorkArea;',
       @TWorkAreas.Insert);
  RegisterMethod(TWorkAreas,
       'function TWorkAreas_GetItems(Index: Integer):TWorkArea;',
       @TWorkAreas_GetItems, Fake);
  RegisterMethod(TWorkAreas,
       'procedure TWorkAreas_PutItems(Index: Integer;const Value: TWorkArea);',
       @TWorkAreas_PutItems, Fake);
  RegisterProperty(TWorkAreas,
       'property Items[Index: Integer]:TWorkArea read TWorkAreas_GetItems write TWorkAreas_PutItems;default;');
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TWorkAreas
  RegisterRTTIType(TypeInfo(TIconArrangement));
  // Begin of class TIconOptions
  RegisterClassType(TIconOptions, H);
  RegisterMethod(TIconOptions,
       'constructor Create(AOwner: TCustomListView);',
       @TIconOptions.Create);
  // End of class TIconOptions
  RegisterRTTIType(TypeInfo(TListArrangement));
  RegisterRTTIType(TypeInfo(TViewStyle));
  RegisterRTTIType(TypeInfo(TItemState));
  RegisterRTTIType(TypeInfo(TItemChange));
  RegisterRTTIType(TypeInfo(TItemFind));
  RegisterRTTIType(TypeInfo(TSearchDirection));
  RegisterRTTIType(TypeInfo(TListHotTrackStyle));
  RegisterRTTIType(TypeInfo(TItemRequests));
  // Begin of class TCustomListView
  RegisterClassType(TCustomListView, H);
  RegisterMethod(TCustomListView,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomListView.Create);
  RegisterMethod(TCustomListView,
       'destructor Destroy; override;',
       @TCustomListView.Destroy);
  RegisterMethod(TCustomListView,
       'function AlphaSort: Boolean;',
       @TCustomListView.AlphaSort);
  RegisterMethod(TCustomListView,
       'procedure Arrange(Code: TListArrangement);',
       @TCustomListView.Arrange);
  RegisterMethod(TCustomListView,
       'function FindCaption(StartIndex: Integer; Value: string;      Partial, Inclusive, Wrap: Boolean): TListItem;',
       @TCustomListView.FindCaption);
  RegisterMethod(TCustomListView,
       'function FindData(StartIndex: Integer; Value: Pointer;      Inclusive, Wrap: Boolean): TListItem;',
       @TCustomListView.FindData);
  RegisterMethod(TCustomListView,
       'function GetHitTestInfoAt(X, Y: Integer): THitTests;',
       @TCustomListView.GetHitTestInfoAt);
  RegisterMethod(TCustomListView,
       'function GetItemAt(X, Y: Integer): TListItem;',
       @TCustomListView.GetItemAt);
  RegisterMethod(TCustomListView,
       'function GetNearestItem(Point: TPoint;      Direction: TSearchDirection): TListItem;',
       @TCustomListView.GetNearestItem);
  RegisterMethod(TCustomListView,
       'function GetNextItem(StartItem: TListItem;      Direction: TSearchDirection; States: TItemStates): TListItem;',
       @TCustomListView.GetNextItem);
  RegisterMethod(TCustomListView,
       'function GetSearchString: string;',
       @TCustomListView.GetSearchString);
  RegisterMethod(TCustomListView,
       'function IsEditing: Boolean;',
       @TCustomListView.IsEditing);
  RegisterMethod(TCustomListView,
       'procedure Scroll(DX, DY: Integer);',
       @TCustomListView.Scroll);
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetCanvas:TCanvas;',
       @TCustomListView_GetCanvas, Fake);
  RegisterProperty(TCustomListView,
       'property Canvas:TCanvas read TCustomListView_GetCanvas;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetCheckboxes:Boolean;',
       @TCustomListView_GetCheckboxes, Fake);
  RegisterMethod(TCustomListView,
       'procedure TCustomListView_PutCheckboxes(const Value: Boolean);',
       @TCustomListView_PutCheckboxes, Fake);
  RegisterProperty(TCustomListView,
       'property Checkboxes:Boolean read TCustomListView_GetCheckboxes write TCustomListView_PutCheckboxes;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetColumn(Index: Integer):TListColumn;',
       @TCustomListView_GetColumn, Fake);
  RegisterProperty(TCustomListView,
       'property Column[Index: Integer]:TListColumn read TCustomListView_GetColumn;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetDropTarget:TListItem;',
       @TCustomListView_GetDropTarget, Fake);
  RegisterMethod(TCustomListView,
       'procedure TCustomListView_PutDropTarget(const Value: TListItem);',
       @TCustomListView_PutDropTarget, Fake);
  RegisterProperty(TCustomListView,
       'property DropTarget:TListItem read TCustomListView_GetDropTarget write TCustomListView_PutDropTarget;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetFlatScrollBars:Boolean;',
       @TCustomListView_GetFlatScrollBars, Fake);
  RegisterMethod(TCustomListView,
       'procedure TCustomListView_PutFlatScrollBars(const Value: Boolean);',
       @TCustomListView_PutFlatScrollBars, Fake);
  RegisterProperty(TCustomListView,
       'property FlatScrollBars:Boolean read TCustomListView_GetFlatScrollBars write TCustomListView_PutFlatScrollBars;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetFullDrag:Boolean;',
       @TCustomListView_GetFullDrag, Fake);
  RegisterMethod(TCustomListView,
       'procedure TCustomListView_PutFullDrag(const Value: Boolean);',
       @TCustomListView_PutFullDrag, Fake);
  RegisterProperty(TCustomListView,
       'property FullDrag:Boolean read TCustomListView_GetFullDrag write TCustomListView_PutFullDrag;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetGridLines:Boolean;',
       @TCustomListView_GetGridLines, Fake);
  RegisterMethod(TCustomListView,
       'procedure TCustomListView_PutGridLines(const Value: Boolean);',
       @TCustomListView_PutGridLines, Fake);
  RegisterProperty(TCustomListView,
       'property GridLines:Boolean read TCustomListView_GetGridLines write TCustomListView_PutGridLines;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetHotTrack:Boolean;',
       @TCustomListView_GetHotTrack, Fake);
  RegisterMethod(TCustomListView,
       'procedure TCustomListView_PutHotTrack(const Value: Boolean);',
       @TCustomListView_PutHotTrack, Fake);
  RegisterProperty(TCustomListView,
       'property HotTrack:Boolean read TCustomListView_GetHotTrack write TCustomListView_PutHotTrack;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetHotTrackStyles:TListHotTrackStyles;',
       @TCustomListView_GetHotTrackStyles, Fake);
  RegisterMethod(TCustomListView,
       'procedure TCustomListView_PutHotTrackStyles(const Value: TListHotTrackStyles);',
       @TCustomListView_PutHotTrackStyles, Fake);
  RegisterProperty(TCustomListView,
       'property HotTrackStyles:TListHotTrackStyles read TCustomListView_GetHotTrackStyles write TCustomListView_PutHotTrackStyles;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetItemFocused:TListItem;',
       @TCustomListView_GetItemFocused, Fake);
  RegisterMethod(TCustomListView,
       'procedure TCustomListView_PutItemFocused(const Value: TListItem);',
       @TCustomListView_PutItemFocused, Fake);
  RegisterProperty(TCustomListView,
       'property ItemFocused:TListItem read TCustomListView_GetItemFocused write TCustomListView_PutItemFocused;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetRowSelect:Boolean;',
       @TCustomListView_GetRowSelect, Fake);
  RegisterMethod(TCustomListView,
       'procedure TCustomListView_PutRowSelect(const Value: Boolean);',
       @TCustomListView_PutRowSelect, Fake);
  RegisterProperty(TCustomListView,
       'property RowSelect:Boolean read TCustomListView_GetRowSelect write TCustomListView_PutRowSelect;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetSelCount:Integer;',
       @TCustomListView_GetSelCount, Fake);
  RegisterProperty(TCustomListView,
       'property SelCount:Integer read TCustomListView_GetSelCount;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetSelected:TListItem;',
       @TCustomListView_GetSelected, Fake);
  RegisterMethod(TCustomListView,
       'procedure TCustomListView_PutSelected(const Value: TListItem);',
       @TCustomListView_PutSelected, Fake);
  RegisterProperty(TCustomListView,
       'property Selected:TListItem read TCustomListView_GetSelected write TCustomListView_PutSelected;');
  RegisterMethod(TCustomListView,
       'function CustomSort(SortProc: TLVCompare; lParam: Longint): Boolean;',
       @TCustomListView.CustomSort);
  RegisterMethod(TCustomListView,
       'function StringWidth(S: string): Integer;',
       @TCustomListView.StringWidth);
  RegisterMethod(TCustomListView,
       'procedure UpdateItems(FirstIndex, LastIndex: Integer);',
       @TCustomListView.UpdateItems);
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetTopItem:TListItem;',
       @TCustomListView_GetTopItem, Fake);
  RegisterProperty(TCustomListView,
       'property TopItem:TListItem read TCustomListView_GetTopItem;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetViewOrigin:TPoint;',
       @TCustomListView_GetViewOrigin, Fake);
  RegisterProperty(TCustomListView,
       'property ViewOrigin:TPoint read TCustomListView_GetViewOrigin;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetVisibleRowCount:Integer;',
       @TCustomListView_GetVisibleRowCount, Fake);
  RegisterProperty(TCustomListView,
       'property VisibleRowCount:Integer read TCustomListView_GetVisibleRowCount;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetBoundingRect:TRect;',
       @TCustomListView_GetBoundingRect, Fake);
  RegisterProperty(TCustomListView,
       'property BoundingRect:TRect read TCustomListView_GetBoundingRect;');
  RegisterMethod(TCustomListView,
       'function TCustomListView_GetWorkAreas:TWorkAreas;',
       @TCustomListView_GetWorkAreas, Fake);
  RegisterProperty(TCustomListView,
       'property WorkAreas:TWorkAreas read TCustomListView_GetWorkAreas;');
  // End of class TCustomListView
  // Begin of class TListView
  RegisterClassType(TListView, H);
  RegisterMethod(TListView,
       'constructor Create(AOwner: TComponent); override;',
       @TListView.Create);
  // End of class TListView
  RegisterRTTIType(TypeInfo(TCommonAVI));
  // Begin of class TAnimate
  RegisterClassType(TAnimate, H);
  RegisterMethod(TAnimate,
       'constructor Create(AOwner: TComponent); override;',
       @TAnimate.Create);
  RegisterMethod(TAnimate,
       'function TAnimate_GetFrameCount:Integer;',
       @TAnimate_GetFrameCount, Fake);
  RegisterProperty(TAnimate,
       'property FrameCount:Integer read TAnimate_GetFrameCount;');
  RegisterMethod(TAnimate,
       'function TAnimate_GetFrameHeight:Integer;',
       @TAnimate_GetFrameHeight, Fake);
  RegisterProperty(TAnimate,
       'property FrameHeight:Integer read TAnimate_GetFrameHeight;');
  RegisterMethod(TAnimate,
       'function TAnimate_GetFrameWidth:Integer;',
       @TAnimate_GetFrameWidth, Fake);
  RegisterProperty(TAnimate,
       'property FrameWidth:Integer read TAnimate_GetFrameWidth;');
  RegisterMethod(TAnimate,
       'function TAnimate_GetOpen:Boolean;',
       @TAnimate_GetOpen, Fake);
  RegisterMethod(TAnimate,
       'procedure TAnimate_PutOpen(const Value: Boolean);',
       @TAnimate_PutOpen, Fake);
  RegisterProperty(TAnimate,
       'property Open:Boolean read TAnimate_GetOpen write TAnimate_PutOpen;');
  RegisterMethod(TAnimate,
       'procedure Play(FromFrame, ToFrame: Word; Count: Integer);',
       @TAnimate.Play);
  RegisterMethod(TAnimate,
       'procedure Reset;',
       @TAnimate.Reset);
  RegisterMethod(TAnimate,
       'procedure Seek(Frame: Smallint);',
       @TAnimate.Seek);
  RegisterMethod(TAnimate,
       'procedure Stop;',
       @TAnimate.Stop);
  RegisterMethod(TAnimate,
       'function TAnimate_GetResHandle:THandle;',
       @TAnimate_GetResHandle, Fake);
  RegisterMethod(TAnimate,
       'procedure TAnimate_PutResHandle(const Value: THandle);',
       @TAnimate_PutResHandle, Fake);
  RegisterProperty(TAnimate,
       'property ResHandle:THandle read TAnimate_GetResHandle write TAnimate_PutResHandle;');
  RegisterMethod(TAnimate,
       'function TAnimate_GetResId:Integer;',
       @TAnimate_GetResId, Fake);
  RegisterMethod(TAnimate,
       'procedure TAnimate_PutResId(const Value: Integer);',
       @TAnimate_PutResId, Fake);
  RegisterProperty(TAnimate,
       'property ResId:Integer read TAnimate_GetResId write TAnimate_PutResId;');
  RegisterMethod(TAnimate,
       'function TAnimate_GetResName:String;',
       @TAnimate_GetResName, Fake);
  RegisterMethod(TAnimate,
       'procedure TAnimate_PutResName(const Value: String);',
       @TAnimate_PutResName, Fake);
  RegisterProperty(TAnimate,
       'property ResName:String read TAnimate_GetResName write TAnimate_PutResName;');
  // End of class TAnimate
  RegisterRTTIType(TypeInfo(TToolButtonStyle));
  RegisterRTTIType(TypeInfo(TToolButtonState));
  // Begin of class TToolButtonActionLink
  RegisterClassType(TToolButtonActionLink, H);
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TToolButtonActionLink
  // Begin of class TToolButton
  RegisterClassType(TToolButton, H);
  RegisterMethod(TToolButton,
       'constructor Create(AOwner: TComponent); override;',
       @TToolButton.Create);
  RegisterMethod(TToolButton,
       'function CheckMenuDropdown: Boolean; dynamic;',
       @TToolButton.CheckMenuDropdown);
  RegisterMethod(TToolButton,
       'procedure Click; override;',
       @TToolButton.Click);
  RegisterMethod(TToolButton,
       'procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;',
       @TToolButton.SetBounds);
  RegisterMethod(TToolButton,
       'function TToolButton_GetIndex:Integer;',
       @TToolButton_GetIndex, Fake);
  RegisterProperty(TToolButton,
       'property Index:Integer read TToolButton_GetIndex;');
  // End of class TToolButton
  // Begin of class TToolBar
  RegisterClassType(TToolBar, H);
  RegisterMethod(TToolBar,
       'constructor Create(AOwner: TComponent); override;',
       @TToolBar.Create);
  RegisterMethod(TToolBar,
       'destructor Destroy; override;',
       @TToolBar.Destroy);
  RegisterMethod(TToolBar,
       'procedure FlipChildren(AllLevels: Boolean); override;',
       @TToolBar.FlipChildren);
  RegisterMethod(TToolBar,
       'function TrackMenu(Button: TToolButton): Boolean; dynamic;',
       @TToolBar.TrackMenu);
  RegisterMethod(TToolBar,
       'function TToolBar_GetButtonCount:Integer;',
       @TToolBar_GetButtonCount, Fake);
  RegisterProperty(TToolBar,
       'property ButtonCount:Integer read TToolBar_GetButtonCount;');
  RegisterMethod(TToolBar,
       'function TToolBar_GetButtons(Index: Integer):TToolButton;',
       @TToolBar_GetButtons, Fake);
  RegisterProperty(TToolBar,
       'property Buttons[Index: Integer]:TToolButton read TToolBar_GetButtons;');
  RegisterMethod(TToolBar,
       'function TToolBar_GetCanvas:TCanvas;',
       @TToolBar_GetCanvas, Fake);
  RegisterProperty(TToolBar,
       'property Canvas:TCanvas read TToolBar_GetCanvas;');
  RegisterMethod(TToolBar,
       'function TToolBar_GetRowCount:Integer;',
       @TToolBar_GetRowCount, Fake);
  RegisterProperty(TToolBar,
       'property RowCount:Integer read TToolBar_GetRowCount;');
  // End of class TToolBar
  // Begin of class TToolBarDockObject
  RegisterClassType(TToolBarDockObject, H);
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TToolBarDockObject
  // Begin of class TCoolBand
  RegisterClassType(TCoolBand, H);
  RegisterMethod(TCoolBand,
       'constructor Create(Collection: TCollection); override;',
       @TCoolBand.Create);
  RegisterMethod(TCoolBand,
       'destructor Destroy; override;',
       @TCoolBand.Destroy);
  RegisterMethod(TCoolBand,
       'procedure Assign(Source: TPersistent); override;',
       @TCoolBand.Assign);
  RegisterMethod(TCoolBand,
       'function TCoolBand_GetHeight:Integer;',
       @TCoolBand_GetHeight, Fake);
  RegisterProperty(TCoolBand,
       'property Height:Integer read TCoolBand_GetHeight;');
  // End of class TCoolBand
  // Begin of class TCoolBands
  RegisterClassType(TCoolBands, H);
  RegisterMethod(TCoolBands,
       'constructor Create(CoolBar: TCoolBar);',
       @TCoolBands.Create);
  RegisterMethod(TCoolBands,
       'function Add: TCoolBand;',
       @TCoolBands.Add);
  RegisterMethod(TCoolBands,
       'function FindBand(AControl: TControl): TCoolBand;',
       @TCoolBands.FindBand);
  RegisterMethod(TCoolBands,
       'function TCoolBands_GetCoolBar:TCoolBar;',
       @TCoolBands_GetCoolBar, Fake);
  RegisterProperty(TCoolBands,
       'property CoolBar:TCoolBar read TCoolBands_GetCoolBar;');
  RegisterMethod(TCoolBands,
       'function TCoolBands_GetItems(Index: Integer):TCoolBand;',
       @TCoolBands_GetItems, Fake);
  RegisterMethod(TCoolBands,
       'procedure TCoolBands_PutItems(Index: Integer;const Value: TCoolBand);',
       @TCoolBands_PutItems, Fake);
  RegisterProperty(TCoolBands,
       'property Items[Index: Integer]:TCoolBand read TCoolBands_GetItems write TCoolBands_PutItems;default;');
  // End of class TCoolBands
  RegisterRTTIType(TypeInfo(TCoolBandMaximize));
  // Begin of class TCoolBar
  RegisterClassType(TCoolBar, H);
  RegisterMethod(TCoolBar,
       'constructor Create(AOwner: TComponent); override;',
       @TCoolBar.Create);
  RegisterMethod(TCoolBar,
       'destructor Destroy; override;',
       @TCoolBar.Destroy);
  RegisterMethod(TCoolBar,
       'procedure FlipChildren(AllLevels: Boolean); override;',
       @TCoolBar.FlipChildren);
  // End of class TCoolBar
  // Begin of class TMonthCalColors
  RegisterClassType(TMonthCalColors, H);
  RegisterMethod(TMonthCalColors,
       'constructor Create(AOwner: TCommonCalendar);',
       @TMonthCalColors.Create);
  RegisterMethod(TMonthCalColors,
       'procedure Assign(Source: TPersistent); override;',
       @TMonthCalColors.Assign);
  // End of class TMonthCalColors
  RegisterRTTIType(TypeInfo(TCalDayOfWeek));
  // Begin of class TCommonCalendar
  RegisterClassType(TCommonCalendar, H);
  RegisterMethod(TCommonCalendar,
       'constructor Create(AOwner: TComponent); override;',
       @TCommonCalendar.Create);
  RegisterMethod(TCommonCalendar,
       'destructor Destroy; override;',
       @TCommonCalendar.Destroy);
  RegisterMethod(TCommonCalendar,
       'procedure BoldDays(Days: array of LongWord; var MonthBoldInfo: LongWord);',
       @TCommonCalendar.BoldDays);
  // End of class TCommonCalendar
  // Begin of class TMonthCalendar
  RegisterClassType(TMonthCalendar, H);
  RegisterMethod(TMonthCalendar,
       'constructor Create(AOwner: TComponent); override;',
       @TMonthCalendar.Create);
  // End of class TMonthCalendar
  RegisterRTTIType(TypeInfo(TDateTimeKind));
  RegisterRTTIType(TypeInfo(TDTDateMode));
  RegisterRTTIType(TypeInfo(TDTDateFormat));
  RegisterRTTIType(TypeInfo(TDTCalAlignment));
  // Begin of class TDateTimePicker
  RegisterClassType(TDateTimePicker, H);
  RegisterMethod(TDateTimePicker,
       'constructor Create(AOwner: TComponent); override;',
       @TDateTimePicker.Create);
  RegisterMethod(TDateTimePicker,
       'function TDateTimePicker_GetDroppedDown:Boolean;',
       @TDateTimePicker_GetDroppedDown, Fake);
  RegisterProperty(TDateTimePicker,
       'property DroppedDown:Boolean read TDateTimePicker_GetDroppedDown;');
  // End of class TDateTimePicker
  RegisterRTTIType(TypeInfo(TPageScrollerOrientation));
  RegisterRTTIType(TypeInfo(TPageScrollerButton));
  RegisterRTTIType(TypeInfo(TPageScrollerButtonState));
  // Begin of class TPageScroller
  RegisterClassType(TPageScroller, H);
  RegisterMethod(TPageScroller,
       'constructor Create(AOwner: TComponent); override;',
       @TPageScroller.Create);
  RegisterMethod(TPageScroller,
       'function GetButtonState(Button: TPageScrollerButton): TPageScrollerButtonState;',
       @TPageScroller.GetButtonState);
  // End of class TPageScroller
  RegisterRoutine('function InitCommonControl(CC: Integer): Boolean;', @InitCommonControl, H);
  RegisterRoutine('procedure CheckCommonControl(CC: Integer);', @CheckCommonControl, H);
  RegisterConstant('ComCtlVersionIE3', $00040046, H);
  RegisterConstant('ComCtlVersionIE4', $00040047, H);
  RegisterConstant('ComCtlVersionIE401', $00040048, H);
  RegisterConstant('ComCtlVersionIE5', $00050050, H);
  RegisterRoutine('function GetComCtlVersion: Integer;', @GetComCtlVersion, H);
  RegisterRoutine('procedure CheckToolMenuDropdown(ToolButton: TToolButton);', @CheckToolMenuDropdown, H);

  RegisterClassType(TSubItems, H);

end;
initialization
  RegisterIMP_comctrls;
end.
