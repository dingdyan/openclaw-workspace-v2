{$IFDEF VER140}
  {$DEFINE Delphi6_UP}
{$ENDIF}

{$IFDEF VER150}
  {$DEFINE Delphi6_UP}
{$ENDIF}

unit IMP_classes;
interface
uses
  SysUtils,
  Windows,
  ActiveX,
  classes,
  PaxScripter;
procedure RegisterIMP_classes;
implementation
function TList_GetCapacity:Integer;
begin
  result := TList(_Self).Capacity;
end;
procedure TList_PutCapacity(const Value: Integer);
begin
  TList(_Self).Capacity := Value;
end;
function TList_GetCount:Integer;
begin
  result := TList(_Self).Count;
end;
procedure TList_PutCount(const Value: Integer);
begin
  TList(_Self).Count := Value;
end;
function TList_GetItems(Index: Integer):Pointer;
begin
  result := TList(_Self).Items[Index];
end;
procedure TList_PutItems(Index: Integer;const Value: Pointer);
begin
  TList(_Self).Items[Index] := Value;
end;
function TList_GetList:PPointerList;
begin
  result := TList(_Self).List;
end;
function TThreadList_GetDuplicates:TDuplicates;
begin
  result := TThreadList(_Self).Duplicates;
end;
procedure TThreadList_PutDuplicates(const Value: TDuplicates);
begin
  TThreadList(_Self).Duplicates := Value;
end;
function TInterfaceList_GetCapacity:Integer;
begin
  result := TInterfaceList(_Self).Capacity;
end;
procedure TInterfaceList_PutCapacity(const Value: Integer);
begin
  TInterfaceList(_Self).Capacity := Value;
end;
function TInterfaceList_GetCount:Integer;
begin
  result := TInterfaceList(_Self).Count;
end;
procedure TInterfaceList_PutCount(const Value: Integer);
begin
  TInterfaceList(_Self).Count := Value;
end;
function TInterfaceList_GetItems(Index: Integer):IUnknown;
begin
  result := TInterfaceList(_Self).Items[Index];
end;
procedure TInterfaceList_PutItems(Index: Integer;const Value: IUnknown);
begin
  TInterfaceList(_Self).Items[Index] := Value;
end;
function TBits_GetBits(Index: Integer):Boolean;
begin
  result := TBits(_Self).Bits[Index];
end;
procedure TBits_PutBits(Index: Integer;const Value: Boolean);
begin
  TBits(_Self).Bits[Index] := Value;
end;
function TBits_GetSize:Integer;
begin
  result := TBits(_Self).Size;
end;
procedure TBits_PutSize(const Value: Integer);
begin
  TBits(_Self).Size := Value;
end;
function TCollectionItem_GetCollection:TCollection;
begin
  result := TCollectionItem(_Self).Collection;
end;
procedure TCollectionItem_PutCollection(const Value: TCollection);
begin
  TCollectionItem(_Self).Collection := Value;
end;
function TCollectionItem_GetID:Integer;
begin
  result := TCollectionItem(_Self).ID;
end;
function TCollectionItem_GetIndex:Integer;
begin
  result := TCollectionItem(_Self).Index;
end;
procedure TCollectionItem_PutIndex(const Value: Integer);
begin
  TCollectionItem(_Self).Index := Value;
end;
function TCollectionItem_GetDisplayName:String;
begin
  result := TCollectionItem(_Self).DisplayName;
end;
procedure TCollectionItem_PutDisplayName(const Value: String);
begin
  TCollectionItem(_Self).DisplayName := Value;
end;
function TCollection_GetCount:Integer;
begin
  result := TCollection(_Self).Count;
end;
function TCollection_GetItemClass:TCollectionItemClass;
begin
  result := TCollection(_Self).ItemClass;
end;
function TCollection_GetItems(Index: Integer):TCollectionItem;
begin
  result := TCollection(_Self).Items[Index];
end;
procedure TCollection_PutItems(Index: Integer;const Value: TCollectionItem);
begin
  TCollection(_Self).Items[Index] := Value;
end;

{$IFDEF Delphi6_UP}
function TStrings_ReadDelimiter:Char;
begin
  result := TStrings(_Self).Delimiter;
end;
procedure TStrings_WriteDelimiter(const Value: Char);
begin
  TStrings(_Self).Delimiter := Value;
end;
function TStrings_ReadDelimitedText:String;
begin
  result := TStrings(_Self).DelimitedText;
end;
procedure TStrings_WriteDelimitedText(const Value: String);
begin
  TStrings(_Self).DelimitedText := Value;
end;
function TStrings_ReadQuoteChar:Char;
begin
  result := TStrings(_Self).QuoteChar;
end;
procedure TStrings_WriteQuoteChar(const Value: Char);
begin
  TStrings(_Self).QuoteChar := Value;
end;
{$ENDIF}

function TStrings_GetCapacity:Integer;
begin
  result := TStrings(_Self).Capacity;
end;
procedure TStrings_PutCapacity(const Value: Integer);
begin
  TStrings(_Self).Capacity := Value;
end;
function TStrings_GetCommaText:String;
begin
  result := TStrings(_Self).CommaText;
end;
procedure TStrings_PutCommaText(const Value: String);
begin
  TStrings(_Self).CommaText := Value;
end;
function TStrings_GetCount:Integer;
begin
  result := TStrings(_Self).Count;
end;
function TStrings_GetNames(Index: Integer):String;
begin
  result := TStrings(_Self).Names[Index];
end;
function TStrings_GetObjects(Index: Integer):TObject;
begin
  result := TStrings(_Self).Objects[Index];
end;
procedure TStrings_PutObjects(Index: Integer;const Value: TObject);
begin
  TStrings(_Self).Objects[Index] := Value;
end;
function TStrings_GetValues(const Name: string):String;
begin
  result := TStrings(_Self).Values[Name];
end;
procedure TStrings_PutValues(const Name: string;const Value: String);
begin
  TStrings(_Self).Values[Name] := Value;
end;
function TStrings_GetStrings(Index: Integer):String;
begin
  result := TStrings(_Self).Strings[Index];
end;
procedure TStrings_PutStrings(Index: Integer;const Value: String);
begin
  TStrings(_Self).Strings[Index] := Value;
end;
function TStrings_GetText:String;
begin
  result := TStrings(_Self).Text;
end;
procedure TStrings_PutText(const Value: String);
begin
  TStrings(_Self).Text := Value;
end;
function TStrings_GetStringsAdapter:IStringsAdapter;
begin
  result := TStrings(_Self).StringsAdapter;
end;
procedure TStrings_PutStringsAdapter(const Value: IStringsAdapter);
begin
  TStrings(_Self).StringsAdapter := Value;
end;
function TStringList_GetDuplicates:TDuplicates;
begin
  result := TStringList(_Self).Duplicates;
end;
procedure TStringList_PutDuplicates(const Value: TDuplicates);
begin
  TStringList(_Self).Duplicates := Value;
end;
function TStringList_GetSorted:Boolean;
begin
  result := TStringList(_Self).Sorted;
end;
procedure TStringList_PutSorted(const Value: Boolean);
begin
  TStringList(_Self).Sorted := Value;
end;
function TStream_GetPosition:Longint;
begin
  result := TStream(_Self).Position;
end;
procedure TStream_PutPosition(const Value: Longint);
begin
  TStream(_Self).Position := Value;
end;
function TStream_GetSize:Longint;
begin
  result := TStream(_Self).Size;
end;
procedure TStream_PutSize(const Value: Longint);
begin
  TStream(_Self).Size := Value;
end;
function THandleStream_GetHandle:Integer;
begin
  result := THandleStream(_Self).Handle;
end;
function TCustomMemoryStream_GetMemory:Pointer;
begin
  result := TCustomMemoryStream(_Self).Memory;
end;
function TStringStream_GetDataString:String;
begin
  result := TStringStream(_Self).DataString;
end;
function TStreamAdapter_GetStream:TStream;
begin
  result := TStreamAdapter(_Self).Stream;
end;
function TStreamAdapter_GetStreamOwnership:TStreamOwnership;
begin
  result := TStreamAdapter(_Self).StreamOwnership;
end;
procedure TStreamAdapter_PutStreamOwnership(const Value: TStreamOwnership);
begin
  TStreamAdapter(_Self).StreamOwnership := Value;
end;
function TFiler_GetRoot:TComponent;
begin
  result := TFiler(_Self).Root;
end;
procedure TFiler_PutRoot(const Value: TComponent);
begin
  TFiler(_Self).Root := Value;
end;
function TFiler_GetLookupRoot:TComponent;
begin
  result := TFiler(_Self).LookupRoot;
end;
function TFiler_GetAncestor:TPersistent;
begin
  result := TFiler(_Self).Ancestor;
end;
procedure TFiler_PutAncestor(const Value: TPersistent);
begin
  TFiler(_Self).Ancestor := Value;
end;
function TFiler_GetIgnoreChildren:Boolean;
begin
  result := TFiler(_Self).IgnoreChildren;
end;
procedure TFiler_PutIgnoreChildren(const Value: Boolean);
begin
  TFiler(_Self).IgnoreChildren := Value;
end;
function TReader_GetOwner:TComponent;
begin
  result := TReader(_Self).Owner;
end;
procedure TReader_PutOwner(const Value: TComponent);
begin
  TReader(_Self).Owner := Value;
end;
function TReader_GetParent:TComponent;
begin
  result := TReader(_Self).Parent;
end;
procedure TReader_PutParent(const Value: TComponent);
begin
  TReader(_Self).Parent := Value;
end;
function TReader_GetPosition:Longint;
begin
  result := TReader(_Self).Position;
end;
procedure TReader_PutPosition(const Value: Longint);
begin
  TReader(_Self).Position := Value;
end;
function TWriter_GetPosition:Longint;
begin
  result := TWriter(_Self).Position;
end;
procedure TWriter_PutPosition(const Value: Longint);
begin
  TWriter(_Self).Position := Value;
end;
function TWriter_GetRootAncestor:TComponent;
begin
  result := TWriter(_Self).RootAncestor;
end;
procedure TWriter_PutRootAncestor(const Value: TComponent);
begin
  TWriter(_Self).RootAncestor := Value;
end;
function TParser_GetFloatType:Char;
begin
  result := TParser(_Self).FloatType;
end;
function TParser_GetSourceLine:Integer;
begin
  result := TParser(_Self).SourceLine;
end;
function TParser_GetToken:Char;
begin
  result := TParser(_Self).Token;
end;
function TThread_GetFreeOnTerminate:Boolean;
begin
  result := TThread(_Self).FreeOnTerminate;
end;
procedure TThread_PutFreeOnTerminate(const Value: Boolean);
begin
  TThread(_Self).FreeOnTerminate := Value;
end;
function TThread_GetHandle:THandle;
begin
  result := TThread(_Self).Handle;
end;
function TThread_GetPriority:TThreadPriority;
begin
  result := TThread(_Self).Priority;
end;
procedure TThread_PutPriority(const Value: TThreadPriority);
begin
  TThread(_Self).Priority := Value;
end;
function TThread_GetSuspended:Boolean;
begin
  result := TThread(_Self).Suspended;
end;
procedure TThread_PutSuspended(const Value: Boolean);
begin
  TThread(_Self).Suspended := Value;
end;
function TThread_GetThreadID:THandle;
begin
  result := TThread(_Self).ThreadID;
end;
function TComponent_GetComObject:IUnknown;
begin
  result := TComponent(_Self).ComObject;
end;
function TComponent_GetComponents(Index: Integer):TComponent;
begin
  result := TComponent(_Self).Components[Index];
end;
function TComponent_GetComponentCount:Integer;
begin
  result := TComponent(_Self).ComponentCount;
end;
function TComponent_GetComponentIndex:Integer;
begin
  result := TComponent(_Self).ComponentIndex;
end;
procedure TComponent_PutComponentIndex(const Value: Integer);
begin
  TComponent(_Self).ComponentIndex := Value;
end;
function TComponent_GetComponentState:TComponentState;
begin
  result := TComponent(_Self).ComponentState;
end;
function TComponent_GetComponentStyle:TComponentStyle;
begin
  result := TComponent(_Self).ComponentStyle;
end;
function TComponent_GetDesignInfo:Longint;
begin
  result := TComponent(_Self).DesignInfo;
end;
procedure TComponent_PutDesignInfo(const Value: Longint);
begin
  TComponent(_Self).DesignInfo := Value;
end;
function TComponent_GetOwner:TComponent;
begin
  result := TComponent(_Self).Owner;
end;
function TComponent_GetVCLComObject:Pointer;
begin
  result := TComponent(_Self).VCLComObject;
end;
procedure TComponent_PutVCLComObject(const Value: Pointer);
begin
  TComponent(_Self).VCLComObject := Value;
end;
function TBasicActionLink_GetAction:TBasicAction;
begin
  result := TBasicActionLink(_Self).Action;
end;
procedure TBasicActionLink_PutAction(const Value: TBasicAction);
begin
  TBasicActionLink(_Self).Action := Value;
end;
procedure RegisterIMP_classes;
var H: Integer;
begin
  H := RegisterNamespace('classes', -1);
  RegisterConstant('SoFromBeginning', 0, H);
  RegisterConstant('SoFromCurrent', 1, H);
  RegisterConstant('SoFromEnd', 2, H);
  RegisterConstant('FmCreate', $FFFF, H);
  RegisterConstant('ScShift', $2000, H);
  RegisterConstant('ScCtrl', $4000, H);
  RegisterConstant('ScAlt', $8000, H);
  RegisterConstant('ScNone', 0, H);
  RegisterRTTIType(TypeInfo(TAlignment));
  RegisterRTTIType(TypeInfo(TBiDiMode));
  RegisterRTTIType(TypeInfo(TDuplicates));
  RegisterRTTIType(TypeInfo(TListNotification));
  // Begin of class TList
  RegisterClassType(TList, H);
  RegisterMethod(TList,
       'destructor Destroy; override;',
       @TList.Destroy);
  RegisterMethod(TList,
       'function Add(Item: Pointer): Integer;',
       @TList.Add);
  RegisterMethod(TList,
       'procedure Clear; virtual;',
       @TList.Clear);
  RegisterMethod(TList,
       'procedure Delete(Index: Integer);',
       @TList.Delete);
  RegisterMethod(TList,
       'procedure Error(const Msg: string; Data: Integer); overload; virtual;',
       @TList.Error);
  RegisterMethod(TList,
       'procedure Error(Msg: PResStringRec; Data: Integer); overload;',
       @TList.Error);
  RegisterMethod(TList,
       'procedure Exchange(Index1, Index2: Integer);',
       @TList.Exchange);
  RegisterMethod(TList,
       'function Expand: TList;',
       @TList.Expand);
  RegisterMethod(TList,
       'function Extract(Item: Pointer): Pointer;',
       @TList.Extract);
  RegisterMethod(TList,
       'function First: Pointer;',
       @TList.First);
  RegisterMethod(TList,
       'function IndexOf(Item: Pointer): Integer;',
       @TList.IndexOf);
  RegisterMethod(TList,
       'procedure Insert(Index: Integer; Item: Pointer);',
       @TList.Insert);
  RegisterMethod(TList,
       'function Last: Pointer;',
       @TList.Last);
  RegisterMethod(TList,
       'procedure Move(CurIndex, NewIndex: Integer);',
       @TList.Move);
  RegisterMethod(TList,
       'function Remove(Item: Pointer): Integer;',
       @TList.Remove);
  RegisterMethod(TList,
       'procedure Pack;',
       @TList.Pack);
  RegisterMethod(TList,
       'procedure Sort(Compare: TListSortCompare);',
       @TList.Sort);
  RegisterMethod(TList,
       'function TList_GetCapacity:Integer;',
       @TList_GetCapacity, Fake);
  RegisterMethod(TList,
       'procedure TList_PutCapacity(const Value: Integer);',
       @TList_PutCapacity, Fake);
  RegisterProperty(TList,
       'property Capacity:Integer read TList_GetCapacity write TList_PutCapacity;');
  RegisterMethod(TList,
       'function TList_GetCount:Integer;',
       @TList_GetCount, Fake);
  RegisterMethod(TList,
       'procedure TList_PutCount(const Value: Integer);',
       @TList_PutCount, Fake);
  RegisterProperty(TList,
       'property Count:Integer read TList_GetCount write TList_PutCount;');
  RegisterMethod(TList,
       'function TList_GetItems(Index: Integer):Pointer;',
       @TList_GetItems, Fake);
  RegisterMethod(TList,
       'procedure TList_PutItems(Index: Integer;const Value: Pointer);',
       @TList_PutItems, Fake);
  RegisterProperty(TList,
       'property Items[Index: Integer]:Pointer read TList_GetItems write TList_PutItems;default;');
  RegisterMethod(TList,
       'function TList_GetList:PPointerList;',
       @TList_GetList, Fake);
  RegisterProperty(TList,
       'property List:PPointerList read TList_GetList;');
  RegisterMethod(TList,
       'constructor Create;',
       @TList.Create);
  // End of class TList
  // Begin of class TThreadList
  RegisterClassType(TThreadList, H);
  RegisterMethod(TThreadList,
       'constructor Create;',
       @TThreadList.Create);
  RegisterMethod(TThreadList,
       'destructor Destroy; override;',
       @TThreadList.Destroy);
  RegisterMethod(TThreadList,
       'procedure Add(Item: Pointer);',
       @TThreadList.Add);
  RegisterMethod(TThreadList,
       'procedure Clear;',
       @TThreadList.Clear);
  RegisterMethod(TThreadList,
       'function  LockList: TList;',
       @TThreadList.LockList);
  RegisterMethod(TThreadList,
       'procedure Remove(Item: Pointer);',
       @TThreadList.Remove);
  RegisterMethod(TThreadList,
       'procedure UnlockList;',
       @TThreadList.UnlockList);
  RegisterMethod(TThreadList,
       'function TThreadList_GetDuplicates:TDuplicates;',
       @TThreadList_GetDuplicates, Fake);
  RegisterMethod(TThreadList,
       'procedure TThreadList_PutDuplicates(const Value: TDuplicates);',
       @TThreadList_PutDuplicates, Fake);
  RegisterProperty(TThreadList,
       'property Duplicates:TDuplicates read TThreadList_GetDuplicates write TThreadList_PutDuplicates;');
  // End of class TThreadList
  // Begin of class TInterfaceList
  RegisterClassType(TInterfaceList, H);
  RegisterMethod(TInterfaceList,
       'constructor Create;',
       @TInterfaceList.Create);
  RegisterMethod(TInterfaceList,
       'destructor Destroy; override;',
       @TInterfaceList.Destroy);
  RegisterMethod(TInterfaceList,
       'procedure Clear;',
       @TInterfaceList.Clear);
  RegisterMethod(TInterfaceList,
       'procedure Delete(Index: Integer);',
       @TInterfaceList.Delete);
  RegisterMethod(TInterfaceList,
       'procedure Exchange(Index1, Index2: Integer);',
       @TInterfaceList.Exchange);
  RegisterMethod(TInterfaceList,
       'function Expand: TInterfaceList;',
       @TInterfaceList.Expand);
  RegisterMethod(TInterfaceList,
       'function First: IUnknown;',
       @TInterfaceList.First);
  RegisterMethod(TInterfaceList,
       'function IndexOf(Item: IUnknown): Integer;',
       @TInterfaceList.IndexOf);
  RegisterMethod(TInterfaceList,
       'function Add(Item: IUnknown): Integer;',
       @TInterfaceList.Add);
  RegisterMethod(TInterfaceList,
       'procedure Insert(Index: Integer; Item: IUnknown);',
       @TInterfaceList.Insert);
  RegisterMethod(TInterfaceList,
       'function Last: IUnknown;',
       @TInterfaceList.Last);
  RegisterMethod(TInterfaceList,
       'function Remove(Item: IUnknown): Integer;',
       @TInterfaceList.Remove);
  RegisterMethod(TInterfaceList,
       'procedure Lock;',
       @TInterfaceList.Lock);
  RegisterMethod(TInterfaceList,
       'procedure Unlock;',
       @TInterfaceList.Unlock);
  RegisterMethod(TInterfaceList,
       'function TInterfaceList_GetCapacity:Integer;',
       @TInterfaceList_GetCapacity, Fake);
  RegisterMethod(TInterfaceList,
       'procedure TInterfaceList_PutCapacity(const Value: Integer);',
       @TInterfaceList_PutCapacity, Fake);
  RegisterProperty(TInterfaceList,
       'property Capacity:Integer read TInterfaceList_GetCapacity write TInterfaceList_PutCapacity;');
  RegisterMethod(TInterfaceList,
       'function TInterfaceList_GetCount:Integer;',
       @TInterfaceList_GetCount, Fake);
  RegisterMethod(TInterfaceList,
       'procedure TInterfaceList_PutCount(const Value: Integer);',
       @TInterfaceList_PutCount, Fake);
  RegisterProperty(TInterfaceList,
       'property Count:Integer read TInterfaceList_GetCount write TInterfaceList_PutCount;');
  RegisterMethod(TInterfaceList,
       'function TInterfaceList_GetItems(Index: Integer):IUnknown;',
       @TInterfaceList_GetItems, Fake);
  RegisterMethod(TInterfaceList,
       'procedure TInterfaceList_PutItems(Index: Integer;const Value: IUnknown);',
       @TInterfaceList_PutItems, Fake);
  RegisterProperty(TInterfaceList,
       'property Items[Index: Integer]:IUnknown read TInterfaceList_GetItems write TInterfaceList_PutItems;default;');
  // End of class TInterfaceList
  // Begin of class TBits
  RegisterClassType(TBits, H);
  RegisterMethod(TBits,
       'destructor Destroy; override;',
       @TBits.Destroy);
  RegisterMethod(TBits,
       'function OpenBit: Integer;',
       @TBits.OpenBit);
  RegisterMethod(TBits,
       'function TBits_GetBits(Index: Integer):Boolean;',
       @TBits_GetBits, Fake);
  RegisterMethod(TBits,
       'procedure TBits_PutBits(Index: Integer;const Value: Boolean);',
       @TBits_PutBits, Fake);
  RegisterProperty(TBits,
       'property Bits[Index: Integer]:Boolean read TBits_GetBits write TBits_PutBits;default;');
  RegisterMethod(TBits,
       'function TBits_GetSize:Integer;',
       @TBits_GetSize, Fake);
  RegisterMethod(TBits,
       'procedure TBits_PutSize(const Value: Integer);',
       @TBits_PutSize, Fake);
  RegisterProperty(TBits,
       'property Size:Integer read TBits_GetSize write TBits_PutSize;');
  RegisterMethod(TBits,
       'constructor Create;',
       @TBits.Create);
  // End of class TBits
  // Begin of class TPersistent
  RegisterClassType(TPersistent, H);
  RegisterMethod(TPersistent,
       'destructor Destroy; override;',
       @TPersistent.Destroy);
  RegisterMethod(TPersistent,
       'procedure Assign(Source: TPersistent); virtual;',
       @TPersistent.Assign);
  RegisterMethod(TPersistent,
       'function  GetNamePath: string; dynamic;',
       @TPersistent.GetNamePath);
  RegisterMethod(TPersistent,
       'constructor Create;',
       @TPersistent.Create);
  // End of class TPersistent
  // Begin of class TCollectionItem
  RegisterClassType(TCollectionItem, H);
  RegisterMethod(TCollectionItem,
       'constructor Create(Collection: TCollection); virtual;',
       @TCollectionItem.Create);
  RegisterMethod(TCollectionItem,
       'destructor Destroy; override;',
       @TCollectionItem.Destroy);
  RegisterMethod(TCollectionItem,
       'function GetNamePath: string; override;',
       @TCollectionItem.GetNamePath);
  RegisterMethod(TCollectionItem,
       'function TCollectionItem_GetCollection:TCollection;',
       @TCollectionItem_GetCollection, Fake);
  RegisterMethod(TCollectionItem,
       'procedure TCollectionItem_PutCollection(const Value: TCollection);',
       @TCollectionItem_PutCollection, Fake);
  RegisterProperty(TCollectionItem,
       'property Collection:TCollection read TCollectionItem_GetCollection write TCollectionItem_PutCollection;');
  RegisterMethod(TCollectionItem,
       'function TCollectionItem_GetID:Integer;',
       @TCollectionItem_GetID, Fake);
  RegisterProperty(TCollectionItem,
       'property ID:Integer read TCollectionItem_GetID;');
  RegisterMethod(TCollectionItem,
       'function TCollectionItem_GetIndex:Integer;',
       @TCollectionItem_GetIndex, Fake);
  RegisterMethod(TCollectionItem,
       'procedure TCollectionItem_PutIndex(const Value: Integer);',
       @TCollectionItem_PutIndex, Fake);
  RegisterProperty(TCollectionItem,
       'property Index:Integer read TCollectionItem_GetIndex write TCollectionItem_PutIndex;');
  RegisterMethod(TCollectionItem,
       'function TCollectionItem_GetDisplayName:String;',
       @TCollectionItem_GetDisplayName, Fake);
  RegisterMethod(TCollectionItem,
       'procedure TCollectionItem_PutDisplayName(const Value: String);',
       @TCollectionItem_PutDisplayName, Fake);
  RegisterProperty(TCollectionItem,
       'property DisplayName:String read TCollectionItem_GetDisplayName write TCollectionItem_PutDisplayName;');
  // End of class TCollectionItem
  // Begin of class TCollection
  RegisterClassType(TCollection, H);
  RegisterMethod(TCollection,
       'constructor Create(ItemClass: TCollectionItemClass);',
       @TCollection.Create);
  RegisterMethod(TCollection,
       'destructor Destroy; override;',
       @TCollection.Destroy);
  RegisterMethod(TCollection,
       'function Add: TCollectionItem;',
       @TCollection.Add);
  RegisterMethod(TCollection,
       'procedure Assign(Source: TPersistent); override;',
       @TCollection.Assign);
  RegisterMethod(TCollection,
       'procedure BeginUpdate; virtual;',
       @TCollection.BeginUpdate);
  RegisterMethod(TCollection,
       'procedure Clear;',
       @TCollection.Clear);
  RegisterMethod(TCollection,
       'procedure Delete(Index: Integer);',
       @TCollection.Delete);
  RegisterMethod(TCollection,
       'procedure EndUpdate; virtual;',
       @TCollection.EndUpdate);
  RegisterMethod(TCollection,
       'function FindItemID(ID: Integer): TCollectionItem;',
       @TCollection.FindItemID);
  RegisterMethod(TCollection,
       'function GetNamePath: string; override;',
       @TCollection.GetNamePath);
  RegisterMethod(TCollection,
       'function Insert(Index: Integer): TCollectionItem;',
       @TCollection.Insert);
  RegisterMethod(TCollection,
       'function TCollection_GetCount:Integer;',
       @TCollection_GetCount, Fake);
  RegisterProperty(TCollection,
       'property Count:Integer read TCollection_GetCount;');
  RegisterMethod(TCollection,
       'function TCollection_GetItemClass:TCollectionItemClass;',
       @TCollection_GetItemClass, Fake);
  RegisterProperty(TCollection,
       'property ItemClass:TCollectionItemClass read TCollection_GetItemClass;');
  RegisterMethod(TCollection,
       'function TCollection_GetItems(Index: Integer):TCollectionItem;',
       @TCollection_GetItems, Fake);
  RegisterMethod(TCollection,
       'procedure TCollection_PutItems(Index: Integer;const Value: TCollectionItem);',
       @TCollection_PutItems, Fake);
  RegisterProperty(TCollection,
       'property Items[Index: Integer]:TCollectionItem read TCollection_GetItems write TCollection_PutItems;');
  // End of class TCollection
  // Begin of class TOwnedCollection
  RegisterClassType(TOwnedCollection, H);
  RegisterMethod(TOwnedCollection,
       'constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass);',
       @TOwnedCollection.Create);
  // End of class TOwnedCollection
  // Begin of class TStrings
  RegisterClassType(TStrings, H);
  RegisterMethod(TStrings,
       'destructor Destroy; override;',
       @TStrings.Destroy);
  RegisterMethod(TStrings,
       'function Add(const S: string): Integer; virtual;',
       @TStrings.Add);
  RegisterMethod(TStrings,
       'function AddObject(const S: string; AObject: TObject): Integer; virtual;',
       @TStrings.AddObject);
  RegisterMethod(TStrings,
       'procedure Append(const S: string);',
       @TStrings.Append);
  RegisterMethod(TStrings,
       'procedure AddStrings(Strings: TStrings); virtual;',
       @TStrings.AddStrings);
  RegisterMethod(TStrings,
       'procedure Assign(Source: TPersistent); override;',
       @TStrings.Assign);
  RegisterMethod(TStrings,
       'procedure BeginUpdate;',
       @TStrings.BeginUpdate);
  RegisterMethod(TStrings,
       'procedure EndUpdate;',
       @TStrings.EndUpdate);
  RegisterMethod(TStrings,
       'function Equals(Strings: TStrings): Boolean;',
       @TStrings.Equals);
  RegisterMethod(TStrings,
       'procedure Exchange(Index1, Index2: Integer); virtual;',
       @TStrings.Exchange);
  RegisterMethod(TStrings,
       'function GetText: PChar; virtual;',
       @TStrings.GetText);
  RegisterMethod(TStrings,
       'function IndexOf(const S: string): Integer; virtual;',
       @TStrings.IndexOf);
  RegisterMethod(TStrings,
       'function IndexOfName(const Name: string): Integer;',
       @TStrings.IndexOfName);
  RegisterMethod(TStrings,
       'function IndexOfObject(AObject: TObject): Integer;',
       @TStrings.IndexOfObject);
  RegisterMethod(TStrings,
       'procedure InsertObject(Index: Integer; const S: string;      AObject: TObject);',
       @TStrings.InsertObject);
  RegisterMethod(TStrings,
       'procedure LoadFromFile(const FileName: string); virtual;',
       @TStrings.LoadFromFile);
  RegisterMethod(TStrings,
       'procedure LoadFromStream(Stream: TStream); virtual;',
       @TStrings.LoadFromStream);
  RegisterMethod(TStrings,
       'procedure Move(CurIndex, NewIndex: Integer); virtual;',
       @TStrings.Move);
  RegisterMethod(TStrings,
       'procedure SaveToFile(const FileName: string); virtual;',
       @TStrings.SaveToFile);
  RegisterMethod(TStrings,
       'procedure SaveToStream(Stream: TStream); virtual;',
       @TStrings.SaveToStream);
  RegisterMethod(TStrings,
       'procedure SetText(Text: PChar); virtual;',
       @TStrings.SetText);
  RegisterMethod(TStrings,
       'function TStrings_GetCapacity:Integer;',
       @TStrings_GetCapacity, Fake);
  RegisterMethod(TStrings,
       'procedure TStrings_PutCapacity(const Value: Integer);',
       @TStrings_PutCapacity, Fake);
  RegisterProperty(TStrings,
       'property Capacity:Integer read TStrings_GetCapacity write TStrings_PutCapacity;');
  RegisterMethod(TStrings,
       'function TStrings_GetCommaText:String;',
       @TStrings_GetCommaText, Fake);
  RegisterMethod(TStrings,
       'procedure TStrings_PutCommaText(const Value: String);',
       @TStrings_PutCommaText, Fake);
  RegisterProperty(TStrings,
       'property CommaText:String read TStrings_GetCommaText write TStrings_PutCommaText;');
  RegisterMethod(TStrings,
       'function TStrings_GetCount:Integer;',
       @TStrings_GetCount, Fake);
  RegisterProperty(TStrings,
       'property Count:Integer read TStrings_GetCount;');

  {$IFDEF Delphi6_UP}
  RegisterMethod(TStrings,
       'function TStrings_ReadDelimiter:Char;',
       @TStrings_ReadDelimiter, Fake);
  RegisterMethod(TStrings,
       'procedure TStrings_WriteDelimiter(const Value: Char);',
       @TStrings_WriteDelimiter, Fake);
  RegisterProperty(TStrings,
       'property Delimiter:Char read TStrings_ReadDelimiter write TStrings_WriteDelimiter;');
  RegisterMethod(TStrings,
       'function TStrings_ReadDelimitedText:String;',
       @TStrings_ReadDelimitedText, Fake);
  RegisterMethod(TStrings,
       'procedure TStrings_WriteDelimitedText(const Value: String);',
       @TStrings_WriteDelimitedText, Fake);
  RegisterProperty(TStrings,
       'property DelimitedText:String read TStrings_ReadDelimitedText write TStrings_WriteDelimitedText;');
  RegisterMethod(TStrings,
       'function TStrings_ReadQuoteChar:Char;',
       @TStrings_ReadQuoteChar, Fake);
  RegisterMethod(TStrings,
       'procedure TStrings_WriteQuoteChar(const Value: Char);',
       @TStrings_WriteQuoteChar, Fake);
  RegisterProperty(TStrings,
       'property QuoteChar:Char read TStrings_ReadQuoteChar write TStrings_WriteQuoteChar;');
  {$ENDIF}

  RegisterMethod(TStrings,
       'function TStrings_GetNames(Index: Integer):String;',
       @TStrings_GetNames, Fake);
  RegisterProperty(TStrings,
       'property Names[Index: Integer]:String read TStrings_GetNames;');
  RegisterMethod(TStrings,
       'function TStrings_GetObjects(Index: Integer):TObject;',
       @TStrings_GetObjects, Fake);
  RegisterMethod(TStrings,
       'procedure TStrings_PutObjects(Index: Integer;const Value: TObject);',
       @TStrings_PutObjects, Fake);
  RegisterProperty(TStrings,
       'property Objects[Index: Integer]:TObject read TStrings_GetObjects write TStrings_PutObjects;');
  RegisterMethod(TStrings,
       'function TStrings_GetValues(const Name: string):String;',
       @TStrings_GetValues, Fake);
  RegisterMethod(TStrings,
       'procedure TStrings_PutValues(const Name: string;const Value: String);',
       @TStrings_PutValues, Fake);
  RegisterProperty(TStrings,
       'property Values[const Name: string]:String read TStrings_GetValues write TStrings_PutValues;');
  RegisterMethod(TStrings,
       'function TStrings_GetStrings(Index: Integer):String;',
       @TStrings_GetStrings, Fake);
  RegisterMethod(TStrings,
       'procedure TStrings_PutStrings(Index: Integer;const Value: String);',
       @TStrings_PutStrings, Fake);
  RegisterProperty(TStrings,
       'property Strings[Index: Integer]:String read TStrings_GetStrings write TStrings_PutStrings;default;');
  RegisterMethod(TStrings,
       'function TStrings_GetText:String;',
       @TStrings_GetText, Fake);
  RegisterMethod(TStrings,
       'procedure TStrings_PutText(const Value: String);',
       @TStrings_PutText, Fake);
  RegisterProperty(TStrings,
       'property Text:String read TStrings_GetText write TStrings_PutText;');
  RegisterMethod(TStrings,
       'function TStrings_GetStringsAdapter:IStringsAdapter;',
       @TStrings_GetStringsAdapter, Fake);
  RegisterMethod(TStrings,
       'procedure TStrings_PutStringsAdapter(const Value: IStringsAdapter);',
       @TStrings_PutStringsAdapter, Fake);
  RegisterProperty(TStrings,
       'property StringsAdapter:IStringsAdapter read TStrings_GetStringsAdapter write TStrings_PutStringsAdapter;');
  RegisterMethod(TStrings,
       'constructor Create;',
       @TStrings.Create);
  // End of class TStrings
  // Begin of class TStringList
  RegisterClassType(TStringList, H);
  RegisterMethod(TStringList,
       'destructor Destroy; override;',
       @TStringList.Destroy);
  RegisterMethod(TStringList,
       'function Add(const S: string): Integer; override;',
       @TStringList.Add);
  RegisterMethod(TStringList,
       'procedure Clear; override;',
       @TStringList.Clear);
  RegisterMethod(TStringList,
       'procedure Delete(Index: Integer); override;',
       @TStringList.Delete);
  RegisterMethod(TStringList,
       'procedure Exchange(Index1, Index2: Integer); override;',
       @TStringList.Exchange);
  RegisterMethod(TStringList,
       'function Find(const S: string; var Index: Integer): Boolean; virtual;',
       @TStringList.Find);
  RegisterMethod(TStringList,
       'function IndexOf(const S: string): Integer; override;',
       @TStringList.IndexOf);
  RegisterMethod(TStringList,
       'procedure Insert(Index: Integer; const S: string); override;',
       @TStringList.Insert);
  RegisterMethod(TStringList,
       'procedure Sort; virtual;',
       @TStringList.Sort);
  RegisterMethod(TStringList,
       'procedure CustomSort(Compare: TStringListSortCompare); virtual;',
       @TStringList.CustomSort);
  RegisterMethod(TStringList,
       'function TStringList_GetDuplicates:TDuplicates;',
       @TStringList_GetDuplicates, Fake);
  RegisterMethod(TStringList,
       'procedure TStringList_PutDuplicates(const Value: TDuplicates);',
       @TStringList_PutDuplicates, Fake);
  RegisterProperty(TStringList,
       'property Duplicates:TDuplicates read TStringList_GetDuplicates write TStringList_PutDuplicates;');
  RegisterMethod(TStringList,
       'function TStringList_GetSorted:Boolean;',
       @TStringList_GetSorted, Fake);
  RegisterMethod(TStringList,
       'procedure TStringList_PutSorted(const Value: Boolean);',
       @TStringList_PutSorted, Fake);
  RegisterProperty(TStringList,
       'property Sorted:Boolean read TStringList_GetSorted write TStringList_PutSorted;');
  RegisterMethod(TStringList,
       'constructor Create;',
       @TStringList.Create);
  // End of class TStringList
  // Begin of class TStream
  RegisterClassType(TStream, H);
  RegisterMethod(TStream,
       'procedure ReadBuffer(var Buffer; Count: Longint);',
       @TStream.ReadBuffer);
  RegisterMethod(TStream,
       'procedure WriteBuffer(const Buffer; Count: Longint);',
       @TStream.WriteBuffer);
  RegisterMethod(TStream,
       'function CopyFrom(Source: TStream; Count: Longint): Longint;',
       @TStream.CopyFrom);
  RegisterMethod(TStream,
       'function ReadComponent(Instance: TComponent): TComponent;',
       @TStream.ReadComponent);
  RegisterMethod(TStream,
       'function ReadComponentRes(Instance: TComponent): TComponent;',
       @TStream.ReadComponentRes);
  RegisterMethod(TStream,
       'procedure WriteComponent(Instance: TComponent);',
       @TStream.WriteComponent);
  RegisterMethod(TStream,
       'procedure WriteComponentRes(const ResName: string; Instance: TComponent);',
       @TStream.WriteComponentRes);
  RegisterMethod(TStream,
       'procedure WriteDescendent(Instance, Ancestor: TComponent);',
       @TStream.WriteDescendent);
  RegisterMethod(TStream,
       'procedure WriteDescendentRes(const ResName: string; Instance, Ancestor: TComponent);',
       @TStream.WriteDescendentRes);
  RegisterMethod(TStream,
       'procedure WriteResourceHeader(const ResName: string; out FixupInfo: Integer);',
       @TStream.WriteResourceHeader);
  RegisterMethod(TStream,
       'procedure FixupResourceHeader(FixupInfo: Integer);',
       @TStream.FixupResourceHeader);
  RegisterMethod(TStream,
       'procedure ReadResHeader;',
       @TStream.ReadResHeader);
  RegisterMethod(TStream,
       'function TStream_GetPosition:Longint;',
       @TStream_GetPosition, Fake);
  RegisterMethod(TStream,
       'procedure TStream_PutPosition(const Value: Longint);',
       @TStream_PutPosition, Fake);
  RegisterProperty(TStream,
       'property Position:Longint read TStream_GetPosition write TStream_PutPosition;');
  RegisterMethod(TStream,
       'function TStream_GetSize:Longint;',
       @TStream_GetSize, Fake);
  RegisterMethod(TStream,
       'procedure TStream_PutSize(const Value: Longint);',
       @TStream_PutSize, Fake);
  RegisterProperty(TStream,
       'property Size:Longint read TStream_GetSize write TStream_PutSize;');
  RegisterMethod(TStream,
       'constructor Create;',
       @TStream.Create);
  // End of class TStream
  // Begin of class THandleStream
  RegisterClassType(THandleStream, H);
  RegisterMethod(THandleStream,
       'constructor Create(AHandle: Integer);',
       @THandleStream.Create);
  RegisterMethod(THandleStream,
       'function Read(var Buffer; Count: Longint): Longint; override;',
       @THandleStream.Read);
  RegisterMethod(THandleStream,
       'function Write(const Buffer; Count: Longint): Longint; override;',
       @THandleStream.Write);
  RegisterMethod(THandleStream,
       'function Seek(Offset: Longint; Origin: Word): Longint; override;',
       @THandleStream.Seek);
  RegisterMethod(THandleStream,
       'function THandleStream_GetHandle:Integer;',
       @THandleStream_GetHandle, Fake);
  RegisterProperty(THandleStream,
       'property Handle:Integer read THandleStream_GetHandle;');
  // End of class THandleStream
  // Begin of class TFileStream
  RegisterClassType(TFileStream, H);
  RegisterMethod(TFileStream,
       'constructor Create(const FileName: string; Mode: Word);',
       @TFileStream.Create);
  RegisterMethod(TFileStream,
       'destructor Destroy; override;',
       @TFileStream.Destroy);
  // End of class TFileStream
  // Begin of class TCustomMemoryStream
  RegisterClassType(TCustomMemoryStream, H);
  RegisterMethod(TCustomMemoryStream,
       'function Read(var Buffer; Count: Longint): Longint; override;',
       @TCustomMemoryStream.Read);
  RegisterMethod(TCustomMemoryStream,
       'function Seek(Offset: Longint; Origin: Word): Longint; override;',
       @TCustomMemoryStream.Seek);
  RegisterMethod(TCustomMemoryStream,
       'procedure SaveToStream(Stream: TStream);',
       @TCustomMemoryStream.SaveToStream);
  RegisterMethod(TCustomMemoryStream,
       'procedure SaveToFile(const FileName: string);',
       @TCustomMemoryStream.SaveToFile);
  RegisterMethod(TCustomMemoryStream,
       'function TCustomMemoryStream_GetMemory:Pointer;',
       @TCustomMemoryStream_GetMemory, Fake);
  RegisterProperty(TCustomMemoryStream,
       'property Memory:Pointer read TCustomMemoryStream_GetMemory;');
  RegisterMethod(TCustomMemoryStream,
       'constructor Create;',
       @TCustomMemoryStream.Create);
  // End of class TCustomMemoryStream
  // Begin of class TMemoryStream
  RegisterClassType(TMemoryStream, H);
  RegisterMethod(TMemoryStream,
       'destructor Destroy; override;',
       @TMemoryStream.Destroy);
  RegisterMethod(TMemoryStream,
       'procedure Clear;',
       @TMemoryStream.Clear);
  RegisterMethod(TMemoryStream,
       'procedure LoadFromStream(Stream: TStream);',
       @TMemoryStream.LoadFromStream);
  RegisterMethod(TMemoryStream,
       'procedure LoadFromFile(const FileName: string);',
       @TMemoryStream.LoadFromFile);
  RegisterMethod(TMemoryStream,
       'procedure SetSize(NewSize: Longint); override;',
       @TMemoryStream.SetSize);
  RegisterMethod(TMemoryStream,
       'function Write(const Buffer; Count: Longint): Longint; override;',
       @TMemoryStream.Write);
  RegisterMethod(TMemoryStream,
       'constructor Create;',
       @TMemoryStream.Create);
  // End of class TMemoryStream
  // Begin of class TStringStream
  RegisterClassType(TStringStream, H);
  RegisterMethod(TStringStream,
       'constructor Create(const AString: string);',
       @TStringStream.Create);
  RegisterMethod(TStringStream,
       'function Read(var Buffer; Count: Longint): Longint; override;',
       @TStringStream.Read);
  RegisterMethod(TStringStream,
       'function ReadString(Count: Longint): string;',
       @TStringStream.ReadString);
  RegisterMethod(TStringStream,
       'function Seek(Offset: Longint; Origin: Word): Longint; override;',
       @TStringStream.Seek);
  RegisterMethod(TStringStream,
       'function Write(const Buffer; Count: Longint): Longint; override;',
       @TStringStream.Write);
  RegisterMethod(TStringStream,
       'procedure WriteString(const AString: string);',
       @TStringStream.WriteString);
  RegisterMethod(TStringStream,
       'function TStringStream_GetDataString:String;',
       @TStringStream_GetDataString, Fake);
  RegisterProperty(TStringStream,
       'property DataString:String read TStringStream_GetDataString;');
  // End of class TStringStream
  // Begin of class TResourceStream
  RegisterClassType(TResourceStream, H);
  RegisterMethod(TResourceStream,
       'constructor Create(Instance: THandle; const ResName: string; ResType: PChar);',
       @TResourceStream.Create);
  RegisterMethod(TResourceStream,
       'constructor CreateFromID(Instance: THandle; ResID: Integer; ResType: PChar);',
       @TResourceStream.CreateFromID);
  RegisterMethod(TResourceStream,
       'destructor Destroy; override;',
       @TResourceStream.Destroy);
  RegisterMethod(TResourceStream,
       'function Write(const Buffer; Count: Longint): Longint; override;',
       @TResourceStream.Write);
  // End of class TResourceStream
  RegisterRTTIType(TypeInfo(TStreamOwnership));
  // Begin of class TStreamAdapter
  RegisterClassType(TStreamAdapter, H);
  RegisterMethod(TStreamAdapter,
       'destructor Destroy; override;',
       @TStreamAdapter.Destroy);
  RegisterMethod(TStreamAdapter,
       'function Read(pv: Pointer; cb: Longint;      pcbRead: PLongint): HResult; virtual; stdcall;',
       @TStreamAdapter.Read);
  RegisterMethod(TStreamAdapter,
       'function Write(pv: Pointer; cb: Longint;      pcbWritten: PLongint): HResult; virtual; stdcall;',
       @TStreamAdapter.Write);
  RegisterMethod(TStreamAdapter,
       'function Seek(dlibMove: Largeint; dwOrigin: Longint;      out libNewPosition: Largeint): HResult; virtual; stdcall;',
       @TStreamAdapter.Seek);
  RegisterMethod(TStreamAdapter,
       'function SetSize(libNewSize: Largeint): HResult; virtual; stdcall;',
       @TStreamAdapter.SetSize);
  RegisterMethod(TStreamAdapter,
       'function CopyTo(stm: IStream; cb: Largeint; out cbRead: Largeint;      out cbWritten: Largeint): HResult; virtual; stdcall;',
       @TStreamAdapter.CopyTo);
  RegisterMethod(TStreamAdapter,
       'function Commit(grfCommitFlags: Longint): HResult; virtual; stdcall;',
       @TStreamAdapter.Commit);
  RegisterMethod(TStreamAdapter,
       'function Revert: HResult; virtual; stdcall;',
       @TStreamAdapter.Revert);
  RegisterMethod(TStreamAdapter,
       'function LockRegion(libOffset: Largeint; cb: Largeint;      dwLockType: Longint): HResult; virtual; stdcall;',
       @TStreamAdapter.LockRegion);
  RegisterMethod(TStreamAdapter,
       'function UnlockRegion(libOffset: Largeint; cb: Largeint;      dwLockType: Longint): HResult; virtual; stdcall;',
       @TStreamAdapter.UnlockRegion);
  RegisterMethod(TStreamAdapter,
       'function Stat(out statstg: TStatStg;      grfStatFlag: Longint): HResult; virtual; stdcall;',
       @TStreamAdapter.Stat);
  RegisterMethod(TStreamAdapter,
       'function Clone(out stm: IStream): HResult; virtual; stdcall;',
       @TStreamAdapter.Clone);
  RegisterMethod(TStreamAdapter,
       'function TStreamAdapter_GetStream:TStream;',
       @TStreamAdapter_GetStream, Fake);
  RegisterProperty(TStreamAdapter,
       'property Stream:TStream read TStreamAdapter_GetStream;');
  RegisterMethod(TStreamAdapter,
       'function TStreamAdapter_GetStreamOwnership:TStreamOwnership;',
       @TStreamAdapter_GetStreamOwnership, Fake);
  RegisterMethod(TStreamAdapter,
       'procedure TStreamAdapter_PutStreamOwnership(const Value: TStreamOwnership);',
       @TStreamAdapter_PutStreamOwnership, Fake);
  RegisterProperty(TStreamAdapter,
       'property StreamOwnership:TStreamOwnership read TStreamAdapter_GetStreamOwnership write TStreamAdapter_PutStreamOwnership;');
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TStreamAdapter
  RegisterRTTIType(TypeInfo(TValueType));
  RegisterRTTIType(TypeInfo(TFilerFlag));
  // Begin of class TFiler
  RegisterClassType(TFiler, H);
  RegisterMethod(TFiler,
       'constructor Create(Stream: TStream; BufSize: Integer);',
       @TFiler.Create);
  RegisterMethod(TFiler,
       'destructor Destroy; override;',
       @TFiler.Destroy);
  RegisterMethod(TFiler,
       'function TFiler_GetRoot:TComponent;',
       @TFiler_GetRoot, Fake);
  RegisterMethod(TFiler,
       'procedure TFiler_PutRoot(const Value: TComponent);',
       @TFiler_PutRoot, Fake);
  RegisterProperty(TFiler,
       'property Root:TComponent read TFiler_GetRoot write TFiler_PutRoot;');
  RegisterMethod(TFiler,
       'function TFiler_GetLookupRoot:TComponent;',
       @TFiler_GetLookupRoot, Fake);
  RegisterProperty(TFiler,
       'property LookupRoot:TComponent read TFiler_GetLookupRoot;');
  RegisterMethod(TFiler,
       'function TFiler_GetAncestor:TPersistent;',
       @TFiler_GetAncestor, Fake);
  RegisterMethod(TFiler,
       'procedure TFiler_PutAncestor(const Value: TPersistent);',
       @TFiler_PutAncestor, Fake);
  RegisterProperty(TFiler,
       'property Ancestor:TPersistent read TFiler_GetAncestor write TFiler_PutAncestor;');
  RegisterMethod(TFiler,
       'function TFiler_GetIgnoreChildren:Boolean;',
       @TFiler_GetIgnoreChildren, Fake);
  RegisterMethod(TFiler,
       'procedure TFiler_PutIgnoreChildren(const Value: Boolean);',
       @TFiler_PutIgnoreChildren, Fake);
  RegisterProperty(TFiler,
       'property IgnoreChildren:Boolean read TFiler_GetIgnoreChildren write TFiler_PutIgnoreChildren;');
  // End of class TFiler
  // Begin of class TReader
  RegisterClassType(TReader, H);
  RegisterMethod(TReader,
       'destructor Destroy; override;',
       @TReader.Destroy);
  RegisterMethod(TReader,
       'procedure BeginReferences;',
       @TReader.BeginReferences);
  RegisterMethod(TReader,
       'procedure CheckValue(Value: TValueType);',
       @TReader.CheckValue);
  RegisterMethod(TReader,
       'procedure DefineProperty(const Name: string;      ReadData: TReaderProc; WriteData: TWriterProc;      HasData: Boolean); override;',
       @TReader.DefineProperty);
  RegisterMethod(TReader,
       'procedure DefineBinaryProperty(const Name: string;      ReadData, WriteData: TStreamProc;      HasData: Boolean); override;',
       @TReader.DefineBinaryProperty);
  RegisterMethod(TReader,
       'function EndOfList: Boolean;',
       @TReader.EndOfList);
  RegisterMethod(TReader,
       'procedure EndReferences;',
       @TReader.EndReferences);
  RegisterMethod(TReader,
       'procedure FixupReferences;',
       @TReader.FixupReferences);
  RegisterMethod(TReader,
       'procedure FlushBuffer; override;',
       @TReader.FlushBuffer);
  RegisterMethod(TReader,
       'function NextValue: TValueType;',
       @TReader.NextValue);
  RegisterMethod(TReader,
       'procedure Read(var Buf; Count: Longint);',
       @TReader.Read);
  RegisterMethod(TReader,
       'function ReadBoolean: Boolean;',
       @TReader.ReadBoolean);
  RegisterMethod(TReader,
       'function ReadChar: Char;',
       @TReader.ReadChar);
  RegisterMethod(TReader,
       'procedure ReadCollection(Collection: TCollection);',
       @TReader.ReadCollection);
  RegisterMethod(TReader,
       'function ReadComponent(Component: TComponent): TComponent;',
       @TReader.ReadComponent);
  RegisterMethod(TReader,
       'procedure ReadComponents(AOwner, AParent: TComponent;      Proc: TReadComponentsProc);',
       @TReader.ReadComponents);
  RegisterMethod(TReader,
       'function ReadFloat: Extended;',
       @TReader.ReadFloat);
  RegisterMethod(TReader,
       'function ReadSingle: Single;',
       @TReader.ReadSingle);
  RegisterMethod(TReader,
       'function ReadCurrency: Currency;',
       @TReader.ReadCurrency);
  RegisterMethod(TReader,
       'function ReadDate: TDateTime;',
       @TReader.ReadDate);
  RegisterMethod(TReader,
       'function ReadIdent: string;',
       @TReader.ReadIdent);
  RegisterMethod(TReader,
       'function ReadInteger: Longint;',
       @TReader.ReadInteger);
  RegisterMethod(TReader,
       'function ReadInt64: Int64;',
       @TReader.ReadInt64);
  RegisterMethod(TReader,
       'procedure ReadListBegin;',
       @TReader.ReadListBegin);
  RegisterMethod(TReader,
       'procedure ReadListEnd;',
       @TReader.ReadListEnd);
  RegisterMethod(TReader,
       'procedure ReadPrefix(var Flags: TFilerFlags; var AChildPos: Integer); virtual;',
       @TReader.ReadPrefix);
  RegisterMethod(TReader,
       'function ReadRootComponent(Root: TComponent): TComponent;',
       @TReader.ReadRootComponent);
  RegisterMethod(TReader,
       'procedure ReadSignature;',
       @TReader.ReadSignature);
  RegisterMethod(TReader,
       'function ReadStr: string;',
       @TReader.ReadStr);
  RegisterMethod(TReader,
       'function ReadString: string;',
       @TReader.ReadString);
  RegisterMethod(TReader,
       'function ReadWideString: WideString;',
       @TReader.ReadWideString);
  RegisterMethod(TReader,
       'function ReadValue: TValueType;',
       @TReader.ReadValue);
  RegisterMethod(TReader,
       'procedure CopyValue(Writer: TWriter);',
       @TReader.CopyValue);
  RegisterMethod(TReader,
       'function TReader_GetOwner:TComponent;',
       @TReader_GetOwner, Fake);
  RegisterMethod(TReader,
       'procedure TReader_PutOwner(const Value: TComponent);',
       @TReader_PutOwner, Fake);
  RegisterProperty(TReader,
       'property Owner:TComponent read TReader_GetOwner write TReader_PutOwner;');
  RegisterMethod(TReader,
       'function TReader_GetParent:TComponent;',
       @TReader_GetParent, Fake);
  RegisterMethod(TReader,
       'procedure TReader_PutParent(const Value: TComponent);',
       @TReader_PutParent, Fake);
  RegisterProperty(TReader,
       'property Parent:TComponent read TReader_GetParent write TReader_PutParent;');
  RegisterMethod(TReader,
       'function TReader_GetPosition:Longint;',
       @TReader_GetPosition, Fake);
  RegisterMethod(TReader,
       'procedure TReader_PutPosition(const Value: Longint);',
       @TReader_PutPosition, Fake);
  RegisterProperty(TReader,
       'property Position:Longint read TReader_GetPosition write TReader_PutPosition;');
  RegisterMethod(TReader,
       'constructor Create(Stream: TStream; BufSize: Integer);',
       @TReader.Create);
  // End of class TReader
  // Begin of class TWriter
  RegisterClassType(TWriter, H);
  RegisterMethod(TWriter,
       'destructor Destroy; override;',
       @TWriter.Destroy);
  RegisterMethod(TWriter,
       'procedure DefineProperty(const Name: string;      ReadData: TReaderProc; WriteData: TWriterProc;      HasData: Boolean); override;',
       @TWriter.DefineProperty);
  RegisterMethod(TWriter,
       'procedure DefineBinaryProperty(const Name: string;      ReadData, WriteData: TStreamProc;      HasData: Boolean); override;',
       @TWriter.DefineBinaryProperty);
  RegisterMethod(TWriter,
       'procedure FlushBuffer; override;',
       @TWriter.FlushBuffer);
  RegisterMethod(TWriter,
       'procedure Write(const Buf; Count: Longint);',
       @TWriter.Write);
  RegisterMethod(TWriter,
       'procedure WriteBoolean(Value: Boolean);',
       @TWriter.WriteBoolean);
  RegisterMethod(TWriter,
       'procedure WriteCollection(Value: TCollection);',
       @TWriter.WriteCollection);
  RegisterMethod(TWriter,
       'procedure WriteComponent(Component: TComponent);',
       @TWriter.WriteComponent);
  RegisterMethod(TWriter,
       'procedure WriteChar(Value: Char);',
       @TWriter.WriteChar);
  RegisterMethod(TWriter,
       'procedure WriteDescendent(Root: TComponent; AAncestor: TComponent);',
       @TWriter.WriteDescendent);
  RegisterMethod(TWriter,
       'procedure WriteFloat(const Value: Extended);',
       @TWriter.WriteFloat);
  RegisterMethod(TWriter,
       'procedure WriteSingle(const Value: Single);',
       @TWriter.WriteSingle);
  RegisterMethod(TWriter,
       'procedure WriteCurrency(const Value: Currency);',
       @TWriter.WriteCurrency);
  RegisterMethod(TWriter,
       'procedure WriteDate(const Value: TDateTime);',
       @TWriter.WriteDate);
  RegisterMethod(TWriter,
       'procedure WriteIdent(const Ident: string);',
       @TWriter.WriteIdent);
  RegisterMethod(TWriter,
       'procedure WriteInteger(Value: Longint); overload;',
       @TWriter.WriteInteger);
  RegisterMethod(TWriter,
       'procedure WriteInteger(Value: Int64); overload;',
       @TWriter.WriteInteger);
  RegisterMethod(TWriter,
       'procedure WriteListBegin;',
       @TWriter.WriteListBegin);
  RegisterMethod(TWriter,
       'procedure WriteListEnd;',
       @TWriter.WriteListEnd);
  RegisterMethod(TWriter,
       'procedure WriteRootComponent(Root: TComponent);',
       @TWriter.WriteRootComponent);
  RegisterMethod(TWriter,
       'procedure WriteSignature;',
       @TWriter.WriteSignature);
  RegisterMethod(TWriter,
       'procedure WriteStr(const Value: string);',
       @TWriter.WriteStr);
  RegisterMethod(TWriter,
       'procedure WriteString(const Value: string);',
       @TWriter.WriteString);
  RegisterMethod(TWriter,
       'procedure WriteWideString(const Value: WideString);',
       @TWriter.WriteWideString);
  RegisterMethod(TWriter,
       'function TWriter_GetPosition:Longint;',
       @TWriter_GetPosition, Fake);
  RegisterMethod(TWriter,
       'procedure TWriter_PutPosition(const Value: Longint);',
       @TWriter_PutPosition, Fake);
  RegisterProperty(TWriter,
       'property Position:Longint read TWriter_GetPosition write TWriter_PutPosition;');
  RegisterMethod(TWriter,
       'function TWriter_GetRootAncestor:TComponent;',
       @TWriter_GetRootAncestor, Fake);
  RegisterMethod(TWriter,
       'procedure TWriter_PutRootAncestor(const Value: TComponent);',
       @TWriter_PutRootAncestor, Fake);
  RegisterProperty(TWriter,
       'property RootAncestor:TComponent read TWriter_GetRootAncestor write TWriter_PutRootAncestor;');
  RegisterMethod(TWriter,
       'constructor Create(Stream: TStream; BufSize: Integer);',
       @TWriter.Create);
  // End of class TWriter
  // Begin of class TParser
  RegisterClassType(TParser, H);
  RegisterMethod(TParser,
       'constructor Create(Stream: TStream);',
       @TParser.Create);
  RegisterMethod(TParser,
       'destructor Destroy; override;',
       @TParser.Destroy);
  RegisterMethod(TParser,
       'procedure CheckToken(T: Char);',
       @TParser.CheckToken);
  RegisterMethod(TParser,
       'procedure CheckTokenSymbol(const S: string);',
       @TParser.CheckTokenSymbol);
  RegisterMethod(TParser,
       'procedure Error(const Ident: string);',
       @TParser.Error);
  RegisterMethod(TParser,
       'procedure ErrorFmt(const Ident: string; const Args: array of const);',
       @TParser.ErrorFmt);
  RegisterMethod(TParser,
       'procedure ErrorStr(const Message: string);',
       @TParser.ErrorStr);
  RegisterMethod(TParser,
       'procedure HexToBinary(Stream: TStream);',
       @TParser.HexToBinary);
  RegisterMethod(TParser,
       'function NextToken: Char;',
       @TParser.NextToken);
  RegisterMethod(TParser,
       'function SourcePos: Longint;',
       @TParser.SourcePos);
  RegisterMethod(TParser,
       'function TokenComponentIdent: string;',
       @TParser.TokenComponentIdent);
  RegisterMethod(TParser,
       'function TokenFloat: Extended;',
       @TParser.TokenFloat);
  RegisterMethod(TParser,
       'function TokenInt: Int64;',
       @TParser.TokenInt);
  RegisterMethod(TParser,
       'function TokenString: string;',
       @TParser.TokenString);
  RegisterMethod(TParser,
       'function TokenWideString: WideString;',
       @TParser.TokenWideString);
  RegisterMethod(TParser,
       'function TokenSymbolIs(const S: string): Boolean;',
       @TParser.TokenSymbolIs);
  RegisterMethod(TParser,
       'function TParser_GetFloatType:Char;',
       @TParser_GetFloatType, Fake);
  RegisterProperty(TParser,
       'property FloatType:Char read TParser_GetFloatType;');
  RegisterMethod(TParser,
       'function TParser_GetSourceLine:Integer;',
       @TParser_GetSourceLine, Fake);
  RegisterProperty(TParser,
       'property SourceLine:Integer read TParser_GetSourceLine;');
  RegisterMethod(TParser,
       'function TParser_GetToken:Char;',
       @TParser_GetToken, Fake);
  RegisterProperty(TParser,
       'property Token:Char read TParser_GetToken;');
  // End of class TParser
  RegisterRTTIType(TypeInfo(TThreadPriority));
  // Begin of class TThread
  RegisterClassType(TThread, H);
  RegisterMethod(TThread,
       'constructor Create(CreateSuspended: Boolean);',
       @TThread.Create);
  RegisterMethod(TThread,
       'destructor Destroy; override;',
       @TThread.Destroy);
  RegisterMethod(TThread,
       'procedure Resume;',
       @TThread.Resume);
  RegisterMethod(TThread,
       'procedure Suspend;',
       @TThread.Suspend);
  RegisterMethod(TThread,
       'procedure Terminate;',
       @TThread.Terminate);
  RegisterMethod(TThread,
       'function WaitFor: LongWord;',
       @TThread.WaitFor);
  RegisterMethod(TThread,
       'function TThread_GetFreeOnTerminate:Boolean;',
       @TThread_GetFreeOnTerminate, Fake);
  RegisterMethod(TThread,
       'procedure TThread_PutFreeOnTerminate(const Value: Boolean);',
       @TThread_PutFreeOnTerminate, Fake);
  RegisterProperty(TThread,
       'property FreeOnTerminate:Boolean read TThread_GetFreeOnTerminate write TThread_PutFreeOnTerminate;');
  RegisterMethod(TThread,
       'function TThread_GetHandle:THandle;',
       @TThread_GetHandle, Fake);
  RegisterProperty(TThread,
       'property Handle:THandle read TThread_GetHandle;');
  RegisterMethod(TThread,
       'function TThread_GetPriority:TThreadPriority;',
       @TThread_GetPriority, Fake);
  RegisterMethod(TThread,
       'procedure TThread_PutPriority(const Value: TThreadPriority);',
       @TThread_PutPriority, Fake);
  RegisterProperty(TThread,
       'property Priority:TThreadPriority read TThread_GetPriority write TThread_PutPriority;');
  RegisterMethod(TThread,
       'function TThread_GetSuspended:Boolean;',
       @TThread_GetSuspended, Fake);
  RegisterMethod(TThread,
       'procedure TThread_PutSuspended(const Value: Boolean);',
       @TThread_PutSuspended, Fake);
  RegisterProperty(TThread,
       'property Suspended:Boolean read TThread_GetSuspended write TThread_PutSuspended;');
  RegisterMethod(TThread,
       'function TThread_GetThreadID:THandle;',
       @TThread_GetThreadID, Fake);
  RegisterProperty(TThread,
       'property ThreadID:THandle read TThread_GetThreadID;');
  // End of class TThread
  RegisterRTTIType(TypeInfo(TOperation));
  // Begin of class TComponent
  RegisterClassType(TComponent, H);
  RegisterMethod(TComponent,
       'constructor Create(AOwner: TComponent); virtual;',
       @TComponent.Create);
  RegisterMethod(TComponent,
       'destructor Destroy; override;',
       @TComponent.Destroy);
  RegisterMethod(TComponent,
       'procedure BeforeDestruction; override;',
       @TComponent.BeforeDestruction);
  RegisterMethod(TComponent,
       'procedure DestroyComponents;',
       @TComponent.DestroyComponents);
  RegisterMethod(TComponent,
       'procedure Destroying;',
       @TComponent.Destroying);
  RegisterMethod(TComponent,
       'function ExecuteAction(Action: TBasicAction): Boolean; dynamic;',
       @TComponent.ExecuteAction);
  RegisterMethod(TComponent,
       'function FindComponent(const AName: string): TComponent;',
       @TComponent.FindComponent);
  RegisterMethod(TComponent,
       'procedure FreeNotification(AComponent: TComponent);',
       @TComponent.FreeNotification);
  RegisterMethod(TComponent,
       'procedure RemoveFreeNotification(AComponent: TComponent);',
       @TComponent.RemoveFreeNotification);
  RegisterMethod(TComponent,
       'procedure FreeOnRelease;',
       @TComponent.FreeOnRelease);
  RegisterMethod(TComponent,
       'function GetParentComponent: TComponent; dynamic;',
       @TComponent.GetParentComponent);
  RegisterMethod(TComponent,
       'function GetNamePath: string; override;',
       @TComponent.GetNamePath);
  RegisterMethod(TComponent,
       'function HasParent: Boolean; dynamic;',
       @TComponent.HasParent);
  RegisterMethod(TComponent,
       'procedure InsertComponent(AComponent: TComponent);',
       @TComponent.InsertComponent);
  RegisterMethod(TComponent,
       'procedure RemoveComponent(AComponent: TComponent);',
       @TComponent.RemoveComponent);
  RegisterMethod(TComponent,
       'function SafeCallException(ExceptObject: TObject;      ExceptAddr: Pointer): HResult; override;',
       @TComponent.SafeCallException);
  RegisterMethod(TComponent,
       'function UpdateAction(Action: TBasicAction): Boolean; dynamic;',
       @TComponent.UpdateAction);
  RegisterMethod(TComponent,
       'function TComponent_GetComObject:IUnknown;',
       @TComponent_GetComObject, Fake);
  RegisterProperty(TComponent,
       'property ComObject:IUnknown read TComponent_GetComObject;');
  RegisterMethod(TComponent,
       'function TComponent_GetComponents(Index: Integer):TComponent;',
       @TComponent_GetComponents, Fake);
  RegisterProperty(TComponent,
       'property Components[Index: Integer]:TComponent read TComponent_GetComponents;');
  RegisterMethod(TComponent,
       'function TComponent_GetComponentCount:Integer;',
       @TComponent_GetComponentCount, Fake);
  RegisterProperty(TComponent,
       'property ComponentCount:Integer read TComponent_GetComponentCount;');
  RegisterMethod(TComponent,
       'function TComponent_GetComponentIndex:Integer;',
       @TComponent_GetComponentIndex, Fake);
  RegisterMethod(TComponent,
       'procedure TComponent_PutComponentIndex(const Value: Integer);',
       @TComponent_PutComponentIndex, Fake);
  RegisterProperty(TComponent,
       'property ComponentIndex:Integer read TComponent_GetComponentIndex write TComponent_PutComponentIndex;');
  RegisterMethod(TComponent,
       'function TComponent_GetComponentState:TComponentState;',
       @TComponent_GetComponentState, Fake);
  RegisterProperty(TComponent,
       'property ComponentState:TComponentState read TComponent_GetComponentState;');
  RegisterMethod(TComponent,
       'function TComponent_GetComponentStyle:TComponentStyle;',
       @TComponent_GetComponentStyle, Fake);
  RegisterProperty(TComponent,
       'property ComponentStyle:TComponentStyle read TComponent_GetComponentStyle;');
  RegisterMethod(TComponent,
       'function TComponent_GetDesignInfo:Longint;',
       @TComponent_GetDesignInfo, Fake);
  RegisterMethod(TComponent,
       'procedure TComponent_PutDesignInfo(const Value: Longint);',
       @TComponent_PutDesignInfo, Fake);
  RegisterProperty(TComponent,
       'property DesignInfo:Longint read TComponent_GetDesignInfo write TComponent_PutDesignInfo;');
  RegisterMethod(TComponent,
       'function TComponent_GetOwner:TComponent;',
       @TComponent_GetOwner, Fake);
  RegisterProperty(TComponent,
       'property Owner:TComponent read TComponent_GetOwner;');
  RegisterMethod(TComponent,
       'function TComponent_GetVCLComObject:Pointer;',
       @TComponent_GetVCLComObject, Fake);
  RegisterMethod(TComponent,
       'procedure TComponent_PutVCLComObject(const Value: Pointer);',
       @TComponent_PutVCLComObject, Fake);
  RegisterProperty(TComponent,
       'property VCLComObject:Pointer read TComponent_GetVCLComObject write TComponent_PutVCLComObject;');
  // End of class TComponent
  // Begin of class TBasicActionLink
  RegisterClassType(TBasicActionLink, H);
  RegisterMethod(TBasicActionLink,
       'constructor Create(AClient: TObject); virtual;',
       @TBasicActionLink.Create);
  RegisterMethod(TBasicActionLink,
       'destructor Destroy; override;',
       @TBasicActionLink.Destroy);
  RegisterMethod(TBasicActionLink,
       'function Execute: Boolean; virtual;',
       @TBasicActionLink.Execute);
  RegisterMethod(TBasicActionLink,
       'function Update: Boolean; virtual;',
       @TBasicActionLink.Update);
  RegisterMethod(TBasicActionLink,
       'function TBasicActionLink_GetAction:TBasicAction;',
       @TBasicActionLink_GetAction, Fake);
  RegisterMethod(TBasicActionLink,
       'procedure TBasicActionLink_PutAction(const Value: TBasicAction);',
       @TBasicActionLink_PutAction, Fake);
  RegisterProperty(TBasicActionLink,
       'property Action:TBasicAction read TBasicActionLink_GetAction write TBasicActionLink_PutAction;');
  // End of class TBasicActionLink
  // Begin of class TBasicAction
  RegisterClassType(TBasicAction, H);
  RegisterMethod(TBasicAction,
       'constructor Create(AOwner: TComponent); override;',
       @TBasicAction.Create);
  RegisterMethod(TBasicAction,
       'destructor Destroy; override;',
       @TBasicAction.Destroy);
  RegisterMethod(TBasicAction,
       'function HandlesTarget(Target: TObject): Boolean; virtual;',
       @TBasicAction.HandlesTarget);
  RegisterMethod(TBasicAction,
       'procedure UpdateTarget(Target: TObject); virtual;',
       @TBasicAction.UpdateTarget);
  RegisterMethod(TBasicAction,
       'procedure ExecuteTarget(Target: TObject); virtual;',
       @TBasicAction.ExecuteTarget);
  RegisterMethod(TBasicAction,
       'function Execute: Boolean; dynamic;',
       @TBasicAction.Execute);
  RegisterMethod(TBasicAction,
       'procedure RegisterChanges(Value: TBasicActionLink);',
       @TBasicAction.RegisterChanges);
  RegisterMethod(TBasicAction,
       'procedure UnRegisterChanges(Value: TBasicActionLink);',
       @TBasicAction.UnRegisterChanges);
  RegisterMethod(TBasicAction,
       'function Update: Boolean; virtual;',
       @TBasicAction.Update);
  // End of class TBasicAction
  RegisterRTTIType(TypeInfo(TActiveXRegType));
  RegisterVariable('CurrentGroup', 'INTEGER',@CurrentGroup, H);
  RegisterRoutine('function Point(AX, AY: Integer): TPoint;', @Point, H);
  RegisterRoutine('function SmallPoint(AX, AY: SmallInt): TSmallPoint;', @SmallPoint, H);
  RegisterRoutine('function Rect(ALeft, ATop, ARight, ABottom: Integer): TRect;', @Rect, H);
  RegisterRoutine('function Bounds(ALeft, ATop, AWidth, AHeight: Integer): TRect;', @Bounds, H);
  RegisterRoutine('procedure RegisterClass(AClass: TPersistentClass);', @RegisterClass, H);

  RegisterRoutine('procedure RegisterClasses(AClasses: array of TPersistentClass);', @RegisterClasses, H);
  RegisterRoutine('procedure RegisterClassAlias(AClass: TPersistentClass; const Alias: string);', @RegisterClassAlias, H);
  RegisterRoutine('procedure UnRegisterClass(AClass: TPersistentClass);', @UnRegisterClass, H);
  RegisterRoutine('procedure UnRegisterClasses(AClasses: array of TPersistentClass);', @UnRegisterClasses, H);
  RegisterRoutine('procedure UnRegisterModuleClasses(Module: HMODULE);', @UnRegisterModuleClasses, H);
  RegisterRoutine('function FindClass(const ClassName: string): TPersistentClass;', @FindClass, H);
  RegisterRoutine('function GetClass(const AClassName: string): TPersistentClass;', @GetClass, H);
  RegisterRoutine('procedure RegisterComponents(const Page: string;  ComponentClasses: array of TComponentClass);', @RegisterComponents, H);
  RegisterRoutine('procedure RegisterNoIcon(ComponentClasses: array of TComponentClass);', @RegisterNoIcon, H);
  RegisterRoutine('procedure RegisterNonActiveX(ComponentClasses: array of TComponentClass;  AxRegType: TActiveXRegType);', @RegisterNonActiveX, H);
  RegisterRoutine('procedure RegisterIntegerConsts(IntegerType: Pointer; IdentToInt: TIdentToInt;  IntToIdent: TIntToIdent);', @RegisterIntegerConsts, H);
  RegisterRoutine('function IdentToInt(const Ident: string; var Int: Longint; const Map: array of TIdentMapEntry): Boolean;', @IdentToInt, H);
  RegisterRoutine('function IntToIdent(Int: Longint; var Ident: string; const Map: array of TIdentMapEntry): Boolean;', @IntToIdent, H);
  RegisterRoutine('function FindIntToIdent(AIntegerType: Pointer): TIntToIdent;', @FindIntToIdent, H);
  RegisterRoutine('function FindIdentToInt(AIntegerType: Pointer): TIdentToInt;', @FindIdentToInt, H);
  RegisterRoutine('function InitInheritedComponent(Instance: TComponent; RootAncestor: TClass): Boolean;', @InitInheritedComponent, H);
  RegisterRoutine('function InitComponentRes(const ResName: string; Instance: TComponent): Boolean;', @InitComponentRes, H);
  RegisterRoutine('function ReadComponentRes(const ResName: string; Instance: TComponent): TComponent;', @ReadComponentRes, H);
  RegisterRoutine('function ReadComponentResEx(HInstance: THandle; const ResName: string): TComponent;', @ReadComponentResEx, H);
  RegisterRoutine('function ReadComponentResFile(const FileName: string; Instance: TComponent): TComponent;', @ReadComponentResFile, H);
  RegisterRoutine('procedure WriteComponentResFile(const FileName: string; Instance: TComponent);', @WriteComponentResFile, H);
  RegisterRoutine('procedure GlobalFixupReferences;', @GlobalFixupReferences, H);
  RegisterRoutine('procedure GetFixupReferenceNames(Root: TComponent; Names: TStrings);', @GetFixupReferenceNames, H);
  RegisterRoutine('procedure GetFixupInstanceNames(Root: TComponent;  const ReferenceRootName: string; Names: TStrings);', @GetFixupInstanceNames, H);
  RegisterRoutine('procedure RedirectFixupReferences(Root: TComponent; const OldRootName,  NewRootName: string);', @RedirectFixupReferences, H);
  RegisterRoutine('procedure RemoveFixupReferences(Root: TComponent; const RootName: string);', @RemoveFixupReferences, H);
  RegisterRoutine('procedure RemoveFixups(Instance: TPersistent);', @RemoveFixups, H);
  RegisterRoutine('function FindNestedComponent(Root: TComponent; const NamePath: string): TComponent;', @FindNestedComponent, H);
  RegisterRoutine('procedure BeginGlobalLoading;', @BeginGlobalLoading, H);
  RegisterRoutine('procedure NotifyGlobalLoading;', @NotifyGlobalLoading, H);
  RegisterRoutine('procedure EndGlobalLoading;', @EndGlobalLoading, H);
  RegisterRoutine('function CollectionsEqual(C1, C2: TCollection): Boolean;', @CollectionsEqual, H);
  RegisterRTTIType(TypeInfo(TStreamOriginalFormat));
  RegisterRoutine('procedure ObjectBinaryToText(Input, Output: TStream); overload;', @ObjectBinaryToText, H);
  RegisterRoutine('procedure ObjectBinaryToText(Input, Output: TStream;  var OriginalFormat: TStreamOriginalFormat); overload;', @ObjectBinaryToText, H);
  RegisterRoutine('procedure ObjectTextToBinary(Input, Output: TStream); overload;', @ObjectTextToBinary, H);
  RegisterRoutine('procedure ObjectTextToBinary(Input, Output: TStream;  var OriginalFormat: TStreamOriginalFormat); overload;', @ObjectTextToBinary, H);
  RegisterRoutine('procedure ObjectResourceToText(Input, Output: TStream); overload;', @ObjectResourceToText, H);
  RegisterRoutine('procedure ObjectResourceToText(Input, Output: TStream;  var OriginalFormat: TStreamOriginalFormat); overload;', @ObjectResourceToText, H);
  RegisterRoutine('procedure ObjectTextToResource(Input, Output: TStream); overload;', @ObjectTextToResource, H);
  RegisterRoutine('procedure ObjectTextToResource(Input, Output: TStream;  var OriginalFormat: TStreamOriginalFormat); overload;', @ObjectTextToResource, H);
  RegisterRoutine('function TestStreamFormat(Stream: TStream): TStreamOriginalFormat;', @TestStreamFormat, H);
  RegisterRoutine('function LineStart(Buffer, BufPos: PChar): PChar;', @LineStart, H);
  RegisterRoutine('function ExtractStrings(Separators, WhiteSpace: TSysCharSet; Content: PChar;  Strings: TStrings): Integer;', @ExtractStrings, H);
  RegisterRoutine('procedure BinToHex(Buffer, Text: PChar; BufSize: Integer);', @BinToHex, H);
  RegisterRoutine('function HexToBin(Text, Buffer: PChar; BufSize: Integer): Integer;', @HexToBin, H);
  RegisterRoutine('function FindRootDesigner(Obj: TPersistent): IDesignerNotify;', @FindRootDesigner, H);
end;
initialization
  RegisterIMP_classes;
end.

