unit IMP_imglist;
interface
uses
  Windows,
  Classes,
  Graphics,
  CommCtrl,
  imglist,
  PaxScripter;
procedure RegisterIMP_imglist;
implementation
function TChangeLink_GetSender:TCustomImageList;
begin
  result := TChangeLink(_Self).Sender;
end;
procedure TChangeLink_PutSender(const Value: TCustomImageList);
begin
  TChangeLink(_Self).Sender := Value;
end;
function TCustomImageList_GetCount:Integer;
begin
  result := TCustomImageList(_Self).Count;
end;
function TCustomImageList_GetHandle:HImageList;
begin
  result := TCustomImageList(_Self).Handle;
end;
procedure TCustomImageList_PutHandle(const Value: HImageList);
begin
  TCustomImageList(_Self).Handle := Value;
end;
function TCustomImageList_GetAllocBy:Integer;
begin
  result := TCustomImageList(_Self).AllocBy;
end;
procedure TCustomImageList_PutAllocBy(const Value: Integer);
begin
  TCustomImageList(_Self).AllocBy := Value;
end;
function TCustomImageList_GetBlendColor:TColor;
begin
  result := TCustomImageList(_Self).BlendColor;
end;
procedure TCustomImageList_PutBlendColor(const Value: TColor);
begin
  TCustomImageList(_Self).BlendColor := Value;
end;
function TCustomImageList_GetBkColor:TColor;
begin
  result := TCustomImageList(_Self).BkColor;
end;
procedure TCustomImageList_PutBkColor(const Value: TColor);
begin
  TCustomImageList(_Self).BkColor := Value;
end;
function TCustomImageList_GetDrawingStyle:TDrawingStyle;
begin
  result := TCustomImageList(_Self).DrawingStyle;
end;
procedure TCustomImageList_PutDrawingStyle(const Value: TDrawingStyle);
begin
  TCustomImageList(_Self).DrawingStyle := Value;
end;
function TCustomImageList_GetHeight:Integer;
begin
  result := TCustomImageList(_Self).Height;
end;
procedure TCustomImageList_PutHeight(const Value: Integer);
begin
  TCustomImageList(_Self).Height := Value;
end;
function TCustomImageList_GetImageType:TImageType;
begin
  result := TCustomImageList(_Self).ImageType;
end;
procedure TCustomImageList_PutImageType(const Value: TImageType);
begin
  TCustomImageList(_Self).ImageType := Value;
end;
function TCustomImageList_GetMasked:Boolean;
begin
  result := TCustomImageList(_Self).Masked;
end;
procedure TCustomImageList_PutMasked(const Value: Boolean);
begin
  TCustomImageList(_Self).Masked := Value;
end;
function TCustomImageList_GetShareImages:Boolean;
begin
  result := TCustomImageList(_Self).ShareImages;
end;
procedure TCustomImageList_PutShareImages(const Value: Boolean);
begin
  TCustomImageList(_Self).ShareImages := Value;
end;
function TCustomImageList_GetWidth:Integer;
begin
  result := TCustomImageList(_Self).Width;
end;
procedure TCustomImageList_PutWidth(const Value: Integer);
begin
  TCustomImageList(_Self).Width := Value;
end;
procedure RegisterIMP_imglist;
var H: Integer;
begin
  H := RegisterNamespace('imglist', -1);
  // Begin of class TChangeLink
  RegisterClassType(TChangeLink, H);
  RegisterMethod(TChangeLink,
       'destructor Destroy; override;',
       @TChangeLink.Destroy);
  RegisterMethod(TChangeLink,
       'procedure Change; dynamic;',
       @TChangeLink.Change);
  RegisterMethod(TChangeLink,
       'function TChangeLink_GetSender:TCustomImageList;',
       @TChangeLink_GetSender, Fake);
  RegisterMethod(TChangeLink,
       'procedure TChangeLink_PutSender(const Value: TCustomImageList);',
       @TChangeLink_PutSender, Fake);
  RegisterProperty(TChangeLink,
       'property Sender:TCustomImageList read TChangeLink_GetSender write TChangeLink_PutSender;');
  RegisterMethod(TChangeLink,
       'constructor Create;',
       @TChangeLink.Create);
  // End of class TChangeLink
  RegisterRTTIType(TypeInfo(TDrawingStyle));
  RegisterRTTIType(TypeInfo(TImageType));
  RegisterRTTIType(TypeInfo(TResType));
  RegisterRTTIType(TypeInfo(TLoadResource));
  // Begin of class TCustomImageList
  RegisterClassType(TCustomImageList, H);
  RegisterMethod(TCustomImageList,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomImageList.Create);
  RegisterMethod(TCustomImageList,
       'constructor CreateSize(AWidth, AHeight: Integer);',
       @TCustomImageList.CreateSize);
  RegisterMethod(TCustomImageList,
       'destructor Destroy; override;',
       @TCustomImageList.Destroy);
  RegisterMethod(TCustomImageList,
       'procedure Assign(Source: TPersistent); override;',
       @TCustomImageList.Assign);
  RegisterMethod(TCustomImageList,
       'function Add(Image, Mask: TBitmap): Integer;',
       @TCustomImageList.Add);
  RegisterMethod(TCustomImageList,
       'function AddIcon(Image: TIcon): Integer;',
       @TCustomImageList.AddIcon);
  RegisterMethod(TCustomImageList,
       'procedure AddImages(Value: TCustomImageList);',
       @TCustomImageList.AddImages);
  RegisterMethod(TCustomImageList,
       'function AddMasked(Image: TBitmap; MaskColor: TColor): Integer;',
       @TCustomImageList.AddMasked);
  RegisterMethod(TCustomImageList,
       'procedure Clear;',
       @TCustomImageList.Clear);
  RegisterMethod(TCustomImageList,
       'procedure Delete(Index: Integer);',
       @TCustomImageList.Delete);
  RegisterMethod(TCustomImageList,
       'function FileLoad(ResType: TResType; Name: string;      MaskColor: TColor): Boolean;',
       @TCustomImageList.FileLoad);
  RegisterMethod(TCustomImageList,
       'procedure GetBitmap(Index: Integer; Image: TBitmap);',
       @TCustomImageList.GetBitmap);
  RegisterMethod(TCustomImageList,
       'function GetHotSpot: TPoint; virtual;',
       @TCustomImageList.GetHotSpot);
  RegisterMethod(TCustomImageList,
       'procedure GetIcon(Index: Integer; Image: TIcon);',
       @TCustomImageList.GetIcon);
  RegisterMethod(TCustomImageList,
       'function GetImageBitmap: HBITMAP;',
       @TCustomImageList.GetImageBitmap);
  RegisterMethod(TCustomImageList,
       'function GetMaskBitmap: HBITMAP;',
       @TCustomImageList.GetMaskBitmap);
  RegisterMethod(TCustomImageList,
       'function GetResource(ResType: TResType; Name: string;      Width: Integer; LoadFlags: TLoadResources; MaskColor: TColor): Boolean;',
       @TCustomImageList.GetResource);
  RegisterMethod(TCustomImageList,
       'function GetInstRes(Instance: THandle; ResType: TResType; Name: string;      Width: Integer; LoadFlags: TLoadResources; MaskColor: TColor): Boolean;',
       @TCustomImageList.GetInstRes);
  RegisterMethod(TCustomImageList,
       'function HandleAllocated: Boolean;',
       @TCustomImageList.HandleAllocated);
  RegisterMethod(TCustomImageList,
       'procedure Insert(Index: Integer; Image, Mask: TBitmap);',
       @TCustomImageList.Insert);
  RegisterMethod(TCustomImageList,
       'procedure InsertIcon(Index: Integer; Image: TIcon);',
       @TCustomImageList.InsertIcon);
  RegisterMethod(TCustomImageList,
       'procedure InsertMasked(Index: Integer; Image: TBitmap; MaskColor: TColor);',
       @TCustomImageList.InsertMasked);
  RegisterMethod(TCustomImageList,
       'procedure Move(CurIndex, NewIndex: Integer);',
       @TCustomImageList.Move);
  RegisterMethod(TCustomImageList,
       'function Overlay(ImageIndex: Integer; Overlay: TOverlay): Boolean;',
       @TCustomImageList.Overlay);
  RegisterMethod(TCustomImageList,
       'procedure RegisterChanges(Value: TChangeLink);',
       @TCustomImageList.RegisterChanges);
  RegisterMethod(TCustomImageList,
       'function ResourceLoad(ResType: TResType; Name: string;      MaskColor: TColor): Boolean;',
       @TCustomImageList.ResourceLoad);
  RegisterMethod(TCustomImageList,
       'function ResInstLoad(Instance: THandle; ResType: TResType; Name: string;      MaskColor: TColor): Boolean;',
       @TCustomImageList.ResInstLoad);
  RegisterMethod(TCustomImageList,
       'procedure Replace(Index: Integer; Image, Mask: TBitmap);',
       @TCustomImageList.Replace);
  RegisterMethod(TCustomImageList,
       'procedure ReplaceIcon(Index: Integer; Image: TIcon);',
       @TCustomImageList.ReplaceIcon);
  RegisterMethod(TCustomImageList,
       'procedure ReplaceMasked(Index: Integer; NewImage: TBitmap; MaskColor: TColor);',
       @TCustomImageList.ReplaceMasked);
  RegisterMethod(TCustomImageList,
       'procedure UnRegisterChanges(Value: TChangeLink);',
       @TCustomImageList.UnRegisterChanges);
  RegisterMethod(TCustomImageList,
       'function TCustomImageList_GetCount:Integer;',
       @TCustomImageList_GetCount, Fake);
  RegisterProperty(TCustomImageList,
       'property Count:Integer read TCustomImageList_GetCount;');
  RegisterMethod(TCustomImageList,
       'function TCustomImageList_GetHandle:HImageList;',
       @TCustomImageList_GetHandle, Fake);
  RegisterMethod(TCustomImageList,
       'procedure TCustomImageList_PutHandle(const Value: HImageList);',
       @TCustomImageList_PutHandle, Fake);
  RegisterProperty(TCustomImageList,
       'property Handle:HImageList read TCustomImageList_GetHandle write TCustomImageList_PutHandle;');
  RegisterMethod(TCustomImageList,
       'function TCustomImageList_GetAllocBy:Integer;',
       @TCustomImageList_GetAllocBy, Fake);
  RegisterMethod(TCustomImageList,
       'procedure TCustomImageList_PutAllocBy(const Value: Integer);',
       @TCustomImageList_PutAllocBy, Fake);
  RegisterProperty(TCustomImageList,
       'property AllocBy:Integer read TCustomImageList_GetAllocBy write TCustomImageList_PutAllocBy;');
  RegisterMethod(TCustomImageList,
       'function TCustomImageList_GetBlendColor:TColor;',
       @TCustomImageList_GetBlendColor, Fake);
  RegisterMethod(TCustomImageList,
       'procedure TCustomImageList_PutBlendColor(const Value: TColor);',
       @TCustomImageList_PutBlendColor, Fake);
  RegisterProperty(TCustomImageList,
       'property BlendColor:TColor read TCustomImageList_GetBlendColor write TCustomImageList_PutBlendColor;');
  RegisterMethod(TCustomImageList,
       'function TCustomImageList_GetBkColor:TColor;',
       @TCustomImageList_GetBkColor, Fake);
  RegisterMethod(TCustomImageList,
       'procedure TCustomImageList_PutBkColor(const Value: TColor);',
       @TCustomImageList_PutBkColor, Fake);
  RegisterProperty(TCustomImageList,
       'property BkColor:TColor read TCustomImageList_GetBkColor write TCustomImageList_PutBkColor;');
  RegisterMethod(TCustomImageList,
       'function TCustomImageList_GetDrawingStyle:TDrawingStyle;',
       @TCustomImageList_GetDrawingStyle, Fake);
  RegisterMethod(TCustomImageList,
       'procedure TCustomImageList_PutDrawingStyle(const Value: TDrawingStyle);',
       @TCustomImageList_PutDrawingStyle, Fake);
  RegisterProperty(TCustomImageList,
       'property DrawingStyle:TDrawingStyle read TCustomImageList_GetDrawingStyle write TCustomImageList_PutDrawingStyle;');
  RegisterMethod(TCustomImageList,
       'function TCustomImageList_GetHeight:Integer;',
       @TCustomImageList_GetHeight, Fake);
  RegisterMethod(TCustomImageList,
       'procedure TCustomImageList_PutHeight(const Value: Integer);',
       @TCustomImageList_PutHeight, Fake);
  RegisterProperty(TCustomImageList,
       'property Height:Integer read TCustomImageList_GetHeight write TCustomImageList_PutHeight;');
  RegisterMethod(TCustomImageList,
       'function TCustomImageList_GetImageType:TImageType;',
       @TCustomImageList_GetImageType, Fake);
  RegisterMethod(TCustomImageList,
       'procedure TCustomImageList_PutImageType(const Value: TImageType);',
       @TCustomImageList_PutImageType, Fake);
  RegisterProperty(TCustomImageList,
       'property ImageType:TImageType read TCustomImageList_GetImageType write TCustomImageList_PutImageType;');
  RegisterMethod(TCustomImageList,
       'function TCustomImageList_GetMasked:Boolean;',
       @TCustomImageList_GetMasked, Fake);
  RegisterMethod(TCustomImageList,
       'procedure TCustomImageList_PutMasked(const Value: Boolean);',
       @TCustomImageList_PutMasked, Fake);
  RegisterProperty(TCustomImageList,
       'property Masked:Boolean read TCustomImageList_GetMasked write TCustomImageList_PutMasked;');
  RegisterMethod(TCustomImageList,
       'function TCustomImageList_GetShareImages:Boolean;',
       @TCustomImageList_GetShareImages, Fake);
  RegisterMethod(TCustomImageList,
       'procedure TCustomImageList_PutShareImages(const Value: Boolean);',
       @TCustomImageList_PutShareImages, Fake);
  RegisterProperty(TCustomImageList,
       'property ShareImages:Boolean read TCustomImageList_GetShareImages write TCustomImageList_PutShareImages;');
  RegisterMethod(TCustomImageList,
       'function TCustomImageList_GetWidth:Integer;',
       @TCustomImageList_GetWidth, Fake);
  RegisterMethod(TCustomImageList,
       'procedure TCustomImageList_PutWidth(const Value: Integer);',
       @TCustomImageList_PutWidth, Fake);
  RegisterProperty(TCustomImageList,
       'property Width:Integer read TCustomImageList_GetWidth write TCustomImageList_PutWidth;');
  // End of class TCustomImageList
end;
initialization
  RegisterIMP_imglist;
end.
