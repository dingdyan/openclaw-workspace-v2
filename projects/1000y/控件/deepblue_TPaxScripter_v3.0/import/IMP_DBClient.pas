{$IFDEF VER140}
  {$DEFINE Delphi6_UP}
{$ENDIF}

{$IFDEF VER150}
  {$DEFINE Delphi6_UP}
{$ENDIF}

{$IFDEF Delphi6_UP}
unit IMP_DBClient;
interface
uses
  Windows,
  SysUtils,
  VarUtils,
  Variants,
  Classes,
  DB,
  DSIntf,
  DBCommon,
  Midas,
  SqlTimSt,
  ActiveX,
  DBClient,
  PaxScripter;
procedure RegisterIMP_DBClient;
implementation
function EDBClient_ReadErrorCode:DBResult;
begin
  result := EDBClient(_Self).ErrorCode;
end;
function EReconcileError_ReadContext:String;
begin
  result := EReconcileError(_Self).Context;
end;
function EReconcileError_ReadPreviousError:DBResult;
begin
  result := EReconcileError(_Self).PreviousError;
end;
function TCustomRemoteServer_ReadAppServer:Variant;
begin
  result := TCustomRemoteServer(_Self).AppServer;
end;
function TAggregate_ReadAggHandle:HDSAggregate;
begin
  result := TAggregate(_Self).AggHandle;
end;
procedure TAggregate_WriteAggHandle(const Value: HDSAggregate);
begin
  TAggregate(_Self).AggHandle := Value;
end;
function TAggregate_ReadInUse:Boolean;
begin
  result := TAggregate(_Self).InUse;
end;
procedure TAggregate_WriteInUse(const Value: Boolean);
begin
  TAggregate(_Self).InUse := Value;
end;
function TAggregate_ReadDataSet:TCustomClientDataSet;
begin
  result := TAggregate(_Self).DataSet;
end;
function TAggregate_ReadDataSize:Integer;
begin
  result := TAggregate(_Self).DataSize;
end;
function TAggregate_ReadDataType:TFieldType;
begin
  result := TAggregate(_Self).DataType;
end;
function TAggregates_ReadItems(Index: Integer):TAggregate;
begin
  result := TAggregates(_Self).Items[Index];
end;
procedure TAggregates_WriteItems(Index: Integer;const Value: TAggregate);
begin
  TAggregates(_Self).Items[Index] := Value;
end;
function TCustomClientDataSet_ReadHasAppServer:Boolean;
begin
  result := TCustomClientDataSet(_Self).HasAppServer;
end;
function TCustomClientDataSet_ReadActiveAggs(Index: Integer):TList;
begin
  result := TCustomClientDataSet(_Self).ActiveAggs[Index];
end;
function TCustomClientDataSet_ReadChangeCount:Integer;
begin
  result := TCustomClientDataSet(_Self).ChangeCount;
end;
function TCustomClientDataSet_ReadCloneSource:TCustomClientDataSet;
begin
  result := TCustomClientDataSet(_Self).CloneSource;
end;
function TCustomClientDataSet_ReadData:OleVariant;
begin
  result := TCustomClientDataSet(_Self).Data;
end;
procedure TCustomClientDataSet_WriteData(const Value: OleVariant);
begin
  TCustomClientDataSet(_Self).Data := Value;
end;
function TCustomClientDataSet_ReadXMLData:String;
begin
  result := TCustomClientDataSet(_Self).XMLData;
end;
procedure TCustomClientDataSet_WriteXMLData(const Value: String);
begin
  TCustomClientDataSet(_Self).XMLData := Value;
end;
function TCustomClientDataSet_ReadAppServer:IAppServer;
begin
  result := TCustomClientDataSet(_Self).AppServer;
end;
procedure TCustomClientDataSet_WriteAppServer(const Value: IAppServer);
begin
  TCustomClientDataSet(_Self).AppServer := Value;
end;
function TCustomClientDataSet_ReadDataSize:Integer;
begin
  result := TCustomClientDataSet(_Self).DataSize;
end;
function TCustomClientDataSet_ReadDelta:OleVariant;
begin
  result := TCustomClientDataSet(_Self).Delta;
end;
function TCustomClientDataSet_ReadGroupingLevel:Integer;
begin
  result := TCustomClientDataSet(_Self).GroupingLevel;
end;
function TCustomClientDataSet_ReadIndexFieldCount:Integer;
begin
  result := TCustomClientDataSet(_Self).IndexFieldCount;
end;
function TCustomClientDataSet_ReadIndexFields(Index: Integer):TField;
begin
  result := TCustomClientDataSet(_Self).IndexFields[Index];
end;
procedure TCustomClientDataSet_WriteIndexFields(Index: Integer;const Value: TField);
begin
  TCustomClientDataSet(_Self).IndexFields[Index] := Value;
end;
function TCustomClientDataSet_ReadKeyExclusive:Boolean;
begin
  result := TCustomClientDataSet(_Self).KeyExclusive;
end;
procedure TCustomClientDataSet_WriteKeyExclusive(const Value: Boolean);
begin
  TCustomClientDataSet(_Self).KeyExclusive := Value;
end;
function TCustomClientDataSet_ReadKeyFieldCount:Integer;
begin
  result := TCustomClientDataSet(_Self).KeyFieldCount;
end;
procedure TCustomClientDataSet_WriteKeyFieldCount(const Value: Integer);
begin
  TCustomClientDataSet(_Self).KeyFieldCount := Value;
end;
function TCustomClientDataSet_ReadKeySize:Word;
begin
  result := TCustomClientDataSet(_Self).KeySize;
end;
function TCustomClientDataSet_ReadLogChanges:Boolean;
begin
  result := TCustomClientDataSet(_Self).LogChanges;
end;
procedure TCustomClientDataSet_WriteLogChanges(const Value: Boolean);
begin
  TCustomClientDataSet(_Self).LogChanges := Value;
end;
function TCustomClientDataSet_ReadSavePoint:Integer;
begin
  result := TCustomClientDataSet(_Self).SavePoint;
end;
procedure TCustomClientDataSet_WriteSavePoint(const Value: Integer);
begin
  TCustomClientDataSet(_Self).SavePoint := Value;
end;
function TCustomClientDataSet_ReadStatusFilter:TUpdateStatusSet;
begin
  result := TCustomClientDataSet(_Self).StatusFilter;
end;
procedure TCustomClientDataSet_WriteStatusFilter(const Value: TUpdateStatusSet);
begin
  TCustomClientDataSet(_Self).StatusFilter := Value;
end;
procedure RegisterIMP_DBClient;
var H: Integer;
begin
  H := RegisterNamespace('DBClient', -1);
  // Begin of class EDBClient
  RegisterClassType(EDBClient, H);
  RegisterMethod(EDBClient,
       'constructor Create(Message: string; ErrorCode: DBResult);',
       @EDBClient.Create);
  RegisterMethod(EDBClient,
       'function EDBClient_ReadErrorCode:DBResult;',
       @EDBClient_ReadErrorCode, Fake);
  RegisterProperty(EDBClient,
       'property ErrorCode:DBResult read EDBClient_ReadErrorCode;');
  // End of class EDBClient
  // Begin of class EReconcileError
  RegisterClassType(EReconcileError, H);
  RegisterMethod(EReconcileError,
       'constructor Create(NativeError, Context: string;      ErrorCode, PreviousError: DBResult);',
       @EReconcileError.Create);
  RegisterMethod(EReconcileError,
       'function EReconcileError_ReadContext:String;',
       @EReconcileError_ReadContext, Fake);
  RegisterProperty(EReconcileError,
       'property Context:String read EReconcileError_ReadContext;');
  RegisterMethod(EReconcileError,
       'function EReconcileError_ReadPreviousError:DBResult;',
       @EReconcileError_ReadPreviousError, Fake);
  RegisterProperty(EReconcileError,
       'property PreviousError:DBResult read EReconcileError_ReadPreviousError;');
  // End of class EReconcileError
  // Begin of class TCustomRemoteServer
  RegisterClassType(TCustomRemoteServer, H);
  RegisterMethod(TCustomRemoteServer,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomRemoteServer.Create);
  RegisterMethod(TCustomRemoteServer,
       'function GetServer: IAppServer; virtual;',
       @TCustomRemoteServer.GetServer);
  RegisterMethod(TCustomRemoteServer,
       'function TCustomRemoteServer_ReadAppServer:Variant;',

       @TCustomRemoteServer_ReadAppServer, Fake);
  RegisterProperty(TCustomRemoteServer,
       'property AppServer:Variant read TCustomRemoteServer_ReadAppServer;');
  // End of class TCustomRemoteServer
  // Begin of class TConnectionBroker
  RegisterClassType(TConnectionBroker, H);
  RegisterMethod(TConnectionBroker,
       'constructor Create(AOwner: TComponent); override;',
       @TConnectionBroker.Create);
  RegisterMethod(TConnectionBroker,
       'function GetServer: IAppServer; override;',
       @TConnectionBroker.GetServer);
  // End of class TConnectionBroker
  // Begin of class TAggregate
  RegisterClassType(TAggregate, H);
  RegisterMethod(TAggregate,
       'constructor Create(Aggregates: TAggregates; ADataSet: TCustomClientDataSet); reintroduce; overload;',
       @TAggregate.Create);
  RegisterMethod(TAggregate,
       'destructor Destroy; override;',
       @TAggregate.Destroy);
  RegisterMethod(TAggregate,
       'procedure Assign(Source: TPersistent); override;',
       @TAggregate.Assign);
  RegisterMethod(TAggregate,
       'function GetDisplayName: string; override;',
       @TAggregate.GetDisplayName);
  RegisterMethod(TAggregate,
       'function Value: Variant;',
       @TAggregate.Value);
  RegisterMethod(TAggregate,
       'function TAggregate_ReadAggHandle:HDSAggregate;',
       @TAggregate_ReadAggHandle, Fake);
  RegisterMethod(TAggregate,
       'procedure TAggregate_WriteAggHandle(const Value: HDSAggregate);',
       @TAggregate_WriteAggHandle, Fake);
  RegisterProperty(TAggregate,
       'property AggHandle:HDSAggregate read TAggregate_ReadAggHandle write TAggregate_WriteAggHandle;');
  RegisterMethod(TAggregate,
       'function TAggregate_ReadInUse:Boolean;',
       @TAggregate_ReadInUse, Fake);
  RegisterMethod(TAggregate,
       'procedure TAggregate_WriteInUse(const Value: Boolean);',
       @TAggregate_WriteInUse, Fake);
  RegisterProperty(TAggregate,
       'property InUse:Boolean read TAggregate_ReadInUse write TAggregate_WriteInUse;');
  RegisterMethod(TAggregate,
       'function TAggregate_ReadDataSet:TCustomClientDataSet;',
       @TAggregate_ReadDataSet, Fake);
  RegisterProperty(TAggregate,
       'property DataSet:TCustomClientDataSet read TAggregate_ReadDataSet;');
  RegisterMethod(TAggregate,
       'function TAggregate_ReadDataSize:Integer;',
       @TAggregate_ReadDataSize, Fake);
  RegisterProperty(TAggregate,
       'property DataSize:Integer read TAggregate_ReadDataSize;');
  RegisterMethod(TAggregate,
       'function TAggregate_ReadDataType:TFieldType;',
       @TAggregate_ReadDataType, Fake);
  RegisterProperty(TAggregate,
       'property DataType:TFieldType read TAggregate_ReadDataType;');
  // End of class TAggregate
  // Begin of class TAggregates
  RegisterClassType(TAggregates, H);
  RegisterMethod(TAggregates,
       'constructor Create(Owner: TPersistent);',
       @TAggregates.Create);
  RegisterMethod(TAggregates,
       'function Add: TAggregate;',
       @TAggregates.Add);
  RegisterMethod(TAggregates,
       'procedure Clear;',
       @TAggregates.Clear);
  RegisterMethod(TAggregates,
       'function Find(const DisplayName: string): TAggregate;',
       @TAggregates.Find);
  RegisterMethod(TAggregates,
       'function IndexOf(const DisplayName: string): Integer;',
       @TAggregates.IndexOf);
  RegisterMethod(TAggregates,
       'function TAggregates_ReadItems(Index: Integer):TAggregate;',
       @TAggregates_ReadItems, Fake);
  RegisterMethod(TAggregates,
       'procedure TAggregates_WriteItems(Index: Integer;const Value: TAggregate);',
       @TAggregates_WriteItems, Fake);
  RegisterProperty(TAggregates,
       'property Items[Index: Integer]:TAggregate read TAggregates_ReadItems write TAggregates_WriteItems;default;');
  // End of class TAggregates
  RegisterRTTIType(TypeInfo(TKeyIndex));
  RegisterRTTIType(TypeInfo(TDataPacketFormat));
  RegisterRTTIType(TypeInfo(TReconcileAction));
  RegisterRTTIType(TypeInfo(TDataSetOption));
  RegisterRTTIType(TypeInfo(TFetchOption));
  // Begin of class TCustomClientDataSet
  RegisterClassType(TCustomClientDataSet, H);
  RegisterMethod(TCustomClientDataSet,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomClientDataSet.Create);
  RegisterMethod(TCustomClientDataSet,
       'destructor Destroy; override;',
       @TCustomClientDataSet.Destroy);
  RegisterMethod(TCustomClientDataSet,
       'procedure AppendData(const Data: OleVariant; HitEOF: Boolean);',
       @TCustomClientDataSet.AppendData);
  RegisterMethod(TCustomClientDataSet,
       'procedure ApplyRange;',
       @TCustomClientDataSet.ApplyRange);
  RegisterMethod(TCustomClientDataSet,
       'function ApplyUpdates(MaxErrors: Integer): Integer; virtual;',
       @TCustomClientDataSet.ApplyUpdates);
  RegisterMethod(TCustomClientDataSet,
       'function BookmarkValid(Bookmark: TBookmark): Boolean; override;',
       @TCustomClientDataSet.BookmarkValid);
  RegisterMethod(TCustomClientDataSet,
       'procedure Cancel; override;',
       @TCustomClientDataSet.Cancel);
  RegisterMethod(TCustomClientDataSet,
       'procedure CancelRange;',
       @TCustomClientDataSet.CancelRange);
  RegisterMethod(TCustomClientDataSet,
       'procedure CancelUpdates;',
       @TCustomClientDataSet.CancelUpdates);
  RegisterMethod(TCustomClientDataSet,
       'function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override;',
       @TCustomClientDataSet.CreateBlobStream);
  RegisterMethod(TCustomClientDataSet,
       'procedure CreateDataSet;',
       @TCustomClientDataSet.CreateDataSet);
  RegisterMethod(TCustomClientDataSet,
       'function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; override;',
       @TCustomClientDataSet.CompareBookmarks);
  RegisterMethod(TCustomClientDataSet,
       'function ConstraintsDisabled: Boolean;',
       @TCustomClientDataSet.ConstraintsDisabled);
  RegisterMethod(TCustomClientDataSet,
       'function DataRequest(Data: OleVariant): OleVariant; virtual;',
       @TCustomClientDataSet.DataRequest);
  RegisterMethod(TCustomClientDataSet,
       'procedure DeleteIndex(const Name: string);',
       @TCustomClientDataSet.DeleteIndex);
  RegisterMethod(TCustomClientDataSet,
       'procedure DisableConstraints;',
       @TCustomClientDataSet.DisableConstraints);
  RegisterMethod(TCustomClientDataSet,
       'procedure EnableConstraints;',
       @TCustomClientDataSet.EnableConstraints);
  RegisterMethod(TCustomClientDataSet,
       'procedure EditKey;',
       @TCustomClientDataSet.EditKey);
  RegisterMethod(TCustomClientDataSet,
       'procedure EditRangeEnd;',
       @TCustomClientDataSet.EditRangeEnd);
  RegisterMethod(TCustomClientDataSet,
       'procedure EditRangeStart;',
       @TCustomClientDataSet.EditRangeStart);
  RegisterMethod(TCustomClientDataSet,
       'procedure EmptyDataSet;',
       @TCustomClientDataSet.EmptyDataSet);
  RegisterMethod(TCustomClientDataSet,
       'procedure Execute; virtual;',
       @TCustomClientDataSet.Execute);
  RegisterMethod(TCustomClientDataSet,
       'procedure FetchBlobs;',
       @TCustomClientDataSet.FetchBlobs);
  RegisterMethod(TCustomClientDataSet,
       'procedure FetchDetails;',
       @TCustomClientDataSet.FetchDetails);
  RegisterMethod(TCustomClientDataSet,
       'procedure RefreshRecord;',
       @TCustomClientDataSet.RefreshRecord);
  RegisterMethod(TCustomClientDataSet,
       'procedure FetchParams;',
       @TCustomClientDataSet.FetchParams);
  RegisterMethod(TCustomClientDataSet,
       'function FindKey(const KeyValues: array of const): Boolean; virtual;',
       @TCustomClientDataSet.FindKey);
  RegisterMethod(TCustomClientDataSet,
       'procedure FindNearest(const KeyValues: array of const);',
       @TCustomClientDataSet.FindNearest);
  RegisterMethod(TCustomClientDataSet,
       'function GetCurrentRecord(Buffer: PChar): Boolean; override;',
       @TCustomClientDataSet.GetCurrentRecord);
  RegisterMethod(TCustomClientDataSet,
       'function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;',
       @TCustomClientDataSet.GetFieldData);
  RegisterMethod(TCustomClientDataSet,
       'function GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean; overload; override;',
       @TCustomClientDataSet.GetFieldData);
  RegisterMethod(TCustomClientDataSet,
       'function GetGroupState(Level: Integer): TGroupPosInds;',
       @TCustomClientDataSet.GetGroupState);
  RegisterMethod(TCustomClientDataSet,
       'procedure GetIndexInfo(IndexName: string);',
       @TCustomClientDataSet.GetIndexInfo);
  RegisterMethod(TCustomClientDataSet,
       'procedure GetIndexNames(List: TStrings);',
       @TCustomClientDataSet.GetIndexNames);
  RegisterMethod(TCustomClientDataSet,
       'function GetNextPacket: Integer;',
       @TCustomClientDataSet.GetNextPacket);
  RegisterMethod(TCustomClientDataSet,
       'function GetOptionalParam(const ParamName: string): OleVariant;',
       @TCustomClientDataSet.GetOptionalParam);
  RegisterMethod(TCustomClientDataSet,
       'procedure GotoCurrent(DataSet: TCustomClientDataSet);',
       @TCustomClientDataSet.GotoCurrent);
  RegisterMethod(TCustomClientDataSet,
       'function GotoKey: Boolean;',
       @TCustomClientDataSet.GotoKey);
  RegisterMethod(TCustomClientDataSet,
       'procedure GotoNearest;',
       @TCustomClientDataSet.GotoNearest);
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadHasAppServer:Boolean;',
       @TCustomClientDataSet_ReadHasAppServer, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property HasAppServer:Boolean read TCustomClientDataSet_ReadHasAppServer;');
  RegisterMethod(TCustomClientDataSet,
       'function Locate(const KeyFields: string; const KeyValues: Variant;      Options: TLocateOptions): Boolean; override;',
       @TCustomClientDataSet.Locate);
  RegisterMethod(TCustomClientDataSet,
       'function Lookup(const KeyFields: string; const KeyValues: Variant;      const ResultFields: string): Variant; override;',
       @TCustomClientDataSet.Lookup);
  RegisterMethod(TCustomClientDataSet,
       'procedure LoadFromStream(Stream: TStream);',
       @TCustomClientDataSet.LoadFromStream);
  RegisterMethod(TCustomClientDataSet,
       'procedure LoadFromFile(const FileName: string);',
       @TCustomClientDataSet.LoadFromFile);
  RegisterMethod(TCustomClientDataSet,
       'procedure MergeChangeLog;',
       @TCustomClientDataSet.MergeChangeLog);
  RegisterMethod(TCustomClientDataSet,
       'procedure Post; override;',
       @TCustomClientDataSet.Post);
  RegisterMethod(TCustomClientDataSet,
       'function Reconcile(const Results: OleVariant): Boolean;',
       @TCustomClientDataSet.Reconcile);
  RegisterMethod(TCustomClientDataSet,
       'procedure RevertRecord;',
       @TCustomClientDataSet.RevertRecord);
  RegisterMethod(TCustomClientDataSet,
       'procedure SetAltRecBuffers(Old, New, Cur: PChar);',
       @TCustomClientDataSet.SetAltRecBuffers);
  RegisterMethod(TCustomClientDataSet,
       'procedure SetKey;',
       @TCustomClientDataSet.SetKey);
  RegisterMethod(TCustomClientDataSet,
       'procedure SetProvider(Provider: TComponent);',
       @TCustomClientDataSet.SetProvider);
  RegisterMethod(TCustomClientDataSet,
       'procedure SetRange(const StartValues, EndValues: array of const);',
       @TCustomClientDataSet.SetRange);
  RegisterMethod(TCustomClientDataSet,
       'procedure SetRangeEnd;',
       @TCustomClientDataSet.SetRangeEnd);
  RegisterMethod(TCustomClientDataSet,
       'procedure SetRangeStart;',
       @TCustomClientDataSet.SetRangeStart);
  RegisterMethod(TCustomClientDataSet,
       'function UndoLastChange(FollowChange: Boolean): Boolean;',
       @TCustomClientDataSet.UndoLastChange);
  RegisterMethod(TCustomClientDataSet,
       'function UpdateStatus: TUpdateStatus; override;',
       @TCustomClientDataSet.UpdateStatus);
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadActiveAggs(Index: Integer):TList;',
       @TCustomClientDataSet_ReadActiveAggs, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property ActiveAggs[Index: Integer]:TList read TCustomClientDataSet_ReadActiveAggs;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadChangeCount:Integer;',
       @TCustomClientDataSet_ReadChangeCount, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property ChangeCount:Integer read TCustomClientDataSet_ReadChangeCount;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadCloneSource:TCustomClientDataSet;',
       @TCustomClientDataSet_ReadCloneSource, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property CloneSource:TCustomClientDataSet read TCustomClientDataSet_ReadCloneSource;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadData:OleVariant;',
       @TCustomClientDataSet_ReadData, Fake);
  RegisterMethod(TCustomClientDataSet,
       'procedure TCustomClientDataSet_WriteData(const Value: OleVariant);',
       @TCustomClientDataSet_WriteData, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property Data:OleVariant read TCustomClientDataSet_ReadData write TCustomClientDataSet_WriteData;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadXMLData:String;',
       @TCustomClientDataSet_ReadXMLData, Fake);
  RegisterMethod(TCustomClientDataSet,
       'procedure TCustomClientDataSet_WriteXMLData(const Value: String);',
       @TCustomClientDataSet_WriteXMLData, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property XMLData:String read TCustomClientDataSet_ReadXMLData write TCustomClientDataSet_WriteXMLData;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadAppServer:IAppServer;',
       @TCustomClientDataSet_ReadAppServer, Fake);
  RegisterMethod(TCustomClientDataSet,
       'procedure TCustomClientDataSet_WriteAppServer(const Value: IAppServer);',
       @TCustomClientDataSet_WriteAppServer, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property AppServer:IAppServer read TCustomClientDataSet_ReadAppServer write TCustomClientDataSet_WriteAppServer;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadDataSize:Integer;',
       @TCustomClientDataSet_ReadDataSize, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property DataSize:Integer read TCustomClientDataSet_ReadDataSize;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadDelta:OleVariant;',
       @TCustomClientDataSet_ReadDelta, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property Delta:OleVariant read TCustomClientDataSet_ReadDelta;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadGroupingLevel:Integer;',
       @TCustomClientDataSet_ReadGroupingLevel, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property GroupingLevel:Integer read TCustomClientDataSet_ReadGroupingLevel;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadIndexFieldCount:Integer;',
       @TCustomClientDataSet_ReadIndexFieldCount, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property IndexFieldCount:Integer read TCustomClientDataSet_ReadIndexFieldCount;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadIndexFields(Index: Integer):TField;',
       @TCustomClientDataSet_ReadIndexFields, Fake);
  RegisterMethod(TCustomClientDataSet,
       'procedure TCustomClientDataSet_WriteIndexFields(Index: Integer;const Value: TField);',
       @TCustomClientDataSet_WriteIndexFields, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property IndexFields[Index: Integer]:TField read TCustomClientDataSet_ReadIndexFields write TCustomClientDataSet_WriteIndexFields;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadKeyExclusive:Boolean;',
       @TCustomClientDataSet_ReadKeyExclusive, Fake);
  RegisterMethod(TCustomClientDataSet,
       'procedure TCustomClientDataSet_WriteKeyExclusive(const Value: Boolean);',
       @TCustomClientDataSet_WriteKeyExclusive, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property KeyExclusive:Boolean read TCustomClientDataSet_ReadKeyExclusive write TCustomClientDataSet_WriteKeyExclusive;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadKeyFieldCount:Integer;',
       @TCustomClientDataSet_ReadKeyFieldCount, Fake);
  RegisterMethod(TCustomClientDataSet,
       'procedure TCustomClientDataSet_WriteKeyFieldCount(const Value: Integer);',
       @TCustomClientDataSet_WriteKeyFieldCount, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property KeyFieldCount:Integer read TCustomClientDataSet_ReadKeyFieldCount write TCustomClientDataSet_WriteKeyFieldCount;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadKeySize:Word;',
       @TCustomClientDataSet_ReadKeySize, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property KeySize:Word read TCustomClientDataSet_ReadKeySize;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadLogChanges:Boolean;',
       @TCustomClientDataSet_ReadLogChanges, Fake);
  RegisterMethod(TCustomClientDataSet,
       'procedure TCustomClientDataSet_WriteLogChanges(const Value: Boolean);',
       @TCustomClientDataSet_WriteLogChanges, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property LogChanges:Boolean read TCustomClientDataSet_ReadLogChanges write TCustomClientDataSet_WriteLogChanges;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadSavePoint:Integer;',
       @TCustomClientDataSet_ReadSavePoint, Fake);
  RegisterMethod(TCustomClientDataSet,
       'procedure TCustomClientDataSet_WriteSavePoint(const Value: Integer);',
       @TCustomClientDataSet_WriteSavePoint, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property SavePoint:Integer read TCustomClientDataSet_ReadSavePoint write TCustomClientDataSet_WriteSavePoint;');
  RegisterMethod(TCustomClientDataSet,
       'function TCustomClientDataSet_ReadStatusFilter:TUpdateStatusSet;',
       @TCustomClientDataSet_ReadStatusFilter, Fake);
  RegisterMethod(TCustomClientDataSet,
       'procedure TCustomClientDataSet_WriteStatusFilter(const Value: TUpdateStatusSet);',
       @TCustomClientDataSet_WriteStatusFilter, Fake);
  RegisterProperty(TCustomClientDataSet,
       'property StatusFilter:TUpdateStatusSet read TCustomClientDataSet_ReadStatusFilter write TCustomClientDataSet_WriteStatusFilter;');
  // End of class TCustomClientDataSet
  // Begin of class TClientDataSet
  RegisterClassType(TClientDataSet, H);
  RegisterMethod(TClientDataSet,
       'constructor Create(AOwner: TComponent); override;',
       @TClientDataSet.Create);
  // End of class TClientDataSet
  // Begin of class TClientBlobStream
  RegisterClassType(TClientBlobStream, H);
  RegisterMethod(TClientBlobStream,
       'constructor Create(Field: TBlobField; Mode: TBlobStreamMode);',
       @TClientBlobStream.Create);
  RegisterMethod(TClientBlobStream,
       'destructor Destroy; override;',
       @TClientBlobStream.Destroy);
  RegisterMethod(TClientBlobStream,
       'function Write(const Buffer; Count: Longint): Longint; override;',
       @TClientBlobStream.Write);
  RegisterMethod(TClientBlobStream,
       'procedure Truncate;',
       @TClientBlobStream.Truncate);
  // End of class TClientBlobStream
  RegisterRoutine('procedure UnpackParams(const Source: OleVariant; Dest: TParams);', @UnpackParams, H);
end;

//******************************************************************
{$ELSE}
//******************************************************************

unit IMP_dbclient;
interface
uses
  Windows,
  SysUtils,
  ActiveX,
  Graphics,
  Classes,
  Controls,
  Forms,
  Db,
  DSIntf,
  DBCommon,
  Midas,
  dbclient,
  PaxScripter;
procedure RegisterIMP_dbclient;
implementation
function EDBClient_GetErrorCode:DBResult;
begin
  result := EDBClient(_Self).ErrorCode;
end;
function EReconcileError_GetContext:String;
begin
  result := EReconcileError(_Self).Context;
end;
function EReconcileError_GetPreviousError:DBResult;
begin
  result := EReconcileError(_Self).PreviousError;
end;
function TAggregate_GetAggHandle:HDSAggregate;
begin
  result := TAggregate(_Self).AggHandle;
end;
procedure TAggregate_PutAggHandle(const Value: HDSAggregate);
begin
  TAggregate(_Self).AggHandle := Value;
end;
function TAggregate_GetInUse:Boolean;
begin
  result := TAggregate(_Self).InUse;
end;
procedure TAggregate_PutInUse(const Value: Boolean);
begin
  TAggregate(_Self).InUse := Value;
end;
function TAggregate_GetDataType:TFieldType;
begin
  result := TAggregate(_Self).DataType;
end;
function TAggregates_GetItems(Index: Integer):TAggregate;
begin
  result := TAggregates(_Self).Items[Index];
end;
procedure TAggregates_PutItems(Index: Integer;const Value: TAggregate);
begin
  TAggregates(_Self).Items[Index] := Value;
end;
function TClientDataSet_GetHasAppServer:Boolean;
begin
  result := TClientDataSet(_Self).HasAppServer;
end;
function TClientDataSet_GetActiveAggs(Index: Integer):TList;
begin
  result := TClientDataSet(_Self).ActiveAggs[Index];
end;
function TClientDataSet_GetChangeCount:Integer;
begin
  result := TClientDataSet(_Self).ChangeCount;
end;
procedure TClientDataSet_PutData(const Value: OleVariant);
begin
  TClientDataSet(_Self).Data := Value;
end;
function TClientDataSet_GetAppServer:IAppServer;
begin
  result := TClientDataSet(_Self).AppServer;
end;
procedure TClientDataSet_PutAppServer(const Value: IAppServer);
begin
  TClientDataSet(_Self).AppServer := Value;
end;
function TClientDataSet_GetDataSize:Integer;
begin
  result := TClientDataSet(_Self).DataSize;
end;
function TClientDataSet_GetDelta:OleVariant;
begin
  result := TClientDataSet(_Self).Delta;
end;
function TClientDataSet_GetGroupingLevel:Integer;
begin
  result := TClientDataSet(_Self).GroupingLevel;
end;
function TClientDataSet_GetIndexFieldCount:Integer;
begin
  result := TClientDataSet(_Self).IndexFieldCount;
end;
function TClientDataSet_GetIndexFields(Index: Integer):TField;
begin
  result := TClientDataSet(_Self).IndexFields[Index];
end;
procedure TClientDataSet_PutIndexFields(Index: Integer;const Value: TField);
begin
  TClientDataSet(_Self).IndexFields[Index] := Value;
end;
function TClientDataSet_GetKeyExclusive:Boolean;
begin
  result := TClientDataSet(_Self).KeyExclusive;
end;
procedure TClientDataSet_PutKeyExclusive(const Value: Boolean);
begin
  TClientDataSet(_Self).KeyExclusive := Value;
end;
function TClientDataSet_GetKeyFieldCount:Integer;
begin
  result := TClientDataSet(_Self).KeyFieldCount;
end;
procedure TClientDataSet_PutKeyFieldCount(const Value: Integer);
begin
  TClientDataSet(_Self).KeyFieldCount := Value;
end;
function TClientDataSet_GetKeySize:Word;
begin
  result := TClientDataSet(_Self).KeySize;
end;
function TClientDataSet_GetLogChanges:Boolean;
begin
  result := TClientDataSet(_Self).LogChanges;
end;
procedure TClientDataSet_PutLogChanges(const Value: Boolean);
begin
  TClientDataSet(_Self).LogChanges := Value;
end;
function TClientDataSet_GetSavePoint:Integer;
begin
  result := TClientDataSet(_Self).SavePoint;
end;
procedure TClientDataSet_PutSavePoint(const Value: Integer);
begin
  TClientDataSet(_Self).SavePoint := Value;
end;
function TClientDataSet_GetStatusFilter:TUpdateStatusSet;
begin
  result := TClientDataSet(_Self).StatusFilter;
end;
procedure TClientDataSet_PutStatusFilter(const Value: TUpdateStatusSet);
begin
  TClientDataSet(_Self).StatusFilter := Value;
end;
procedure RegisterIMP_dbclient;
var H: Integer;
begin
  H := RegisterNamespace('dbclient', -1);
  // Begin of class EDBClient
  RegisterClassType(EDBClient, H);
  RegisterMethod(EDBClient,
       'constructor Create(Message: string; ErrorCode: DBResult);',
       @EDBClient.Create);
  RegisterMethod(EDBClient,
       'function EDBClient_GetErrorCode:DBResult;',
       @EDBClient_GetErrorCode, Fake);
  RegisterProperty(EDBClient,
       'property ErrorCode:DBResult read EDBClient_GetErrorCode;');
  // End of class EDBClient
  // Begin of class EReconcileError
  RegisterClassType(EReconcileError, H);
  RegisterMethod(EReconcileError,
       'constructor Create(NativeError, Context: string;      ErrorCode, PreviousError: DBResult);',
       @EReconcileError.Create);
  RegisterMethod(EReconcileError,
       'function EReconcileError_GetContext:String;',
       @EReconcileError_GetContext, Fake);
  RegisterProperty(EReconcileError,
       'property Context:String read EReconcileError_GetContext;');
  RegisterMethod(EReconcileError,
       'function EReconcileError_GetPreviousError:DBResult;',
       @EReconcileError_GetPreviousError, Fake);
  RegisterProperty(EReconcileError,
       'property PreviousError:DBResult read EReconcileError_GetPreviousError;');
  // End of class EReconcileError
  // Begin of class TCustomRemoteServer
  RegisterClassType(TCustomRemoteServer, H);
  RegisterMethod(TCustomRemoteServer,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomRemoteServer.Create);
  RegisterMethod(TCustomRemoteServer,
       'function GetServer: IAppServer; virtual;',
       @TCustomRemoteServer.GetServer);
  // End of class TCustomRemoteServer
  // Begin of class TAggregate
  RegisterClassType(TAggregate, H);
  RegisterMethod(TAggregate,
       'constructor Create(Aggregates: TAggregates; ADataSet: TClientDataSet); reintroduce; overload;',
       @TAggregate.Create);
  RegisterMethod(TAggregate,
       'destructor Destroy; override;',
       @TAggregate.Destroy);
  RegisterMethod(TAggregate,
       'procedure Assign(Source: TPersistent); override;',
       @TAggregate.Assign);
  RegisterMethod(TAggregate,
       'function GetDisplayName: string; override;',
       @TAggregate.GetDisplayName);
  RegisterMethod(TAggregate,
       'function Value: Variant;',
       @TAggregate.Value);
  RegisterMethod(TAggregate,
       'function TAggregate_GetAggHandle:HDSAggregate;',
       @TAggregate_GetAggHandle, Fake);
  RegisterMethod(TAggregate,
       'procedure TAggregate_PutAggHandle(const Value: HDSAggregate);',
       @TAggregate_PutAggHandle, Fake);
  RegisterProperty(TAggregate,
       'property AggHandle:HDSAggregate read TAggregate_GetAggHandle write TAggregate_PutAggHandle;');
  RegisterMethod(TAggregate,
       'function TAggregate_GetInUse:Boolean;',
       @TAggregate_GetInUse, Fake);
  RegisterMethod(TAggregate,
       'procedure TAggregate_PutInUse(const Value: Boolean);',
       @TAggregate_PutInUse, Fake);
  RegisterProperty(TAggregate,
       'property InUse:Boolean read TAggregate_GetInUse write TAggregate_PutInUse;');
  RegisterMethod(TAggregate,
       'function TAggregate_GetDataType:TFieldType;',
       @TAggregate_GetDataType, Fake);
  RegisterProperty(TAggregate,
       'property DataType:TFieldType read TAggregate_GetDataType;');
  // End of class TAggregate
  // Begin of class TAggregates
  RegisterClassType(TAggregates, H);
  RegisterMethod(TAggregates,
       'constructor Create(Owner: TPersistent);',
       @TAggregates.Create);
  RegisterMethod(TAggregates,
       'function Add: TAggregate;',
       @TAggregates.Add);
  RegisterMethod(TAggregates,
       'procedure Clear;',
       @TAggregates.Clear);
  RegisterMethod(TAggregates,
       'function Find(const DisplayName: string): TAggregate;',
       @TAggregates.Find);
  RegisterMethod(TAggregates,
       'function IndexOf(const DisplayName: string): Integer;',
       @TAggregates.IndexOf);
  RegisterMethod(TAggregates,
       'function TAggregates_GetItems(Index: Integer):TAggregate;',
       @TAggregates_GetItems, Fake);
  RegisterMethod(TAggregates,
       'procedure TAggregates_PutItems(Index: Integer;const Value: TAggregate);',
       @TAggregates_PutItems, Fake);
  RegisterProperty(TAggregates,
       'property Items[Index: Integer]:TAggregate read TAggregates_GetItems write TAggregates_PutItems;default;');
  // End of class TAggregates
  RegisterRTTIType(TypeInfo(TKeyIndex));
  RegisterRTTIType(TypeInfo(TDataPacketFormat));
  RegisterRTTIType(TypeInfo(TReconcileAction));
  RegisterRTTIType(TypeInfo(TDataSetOption));
  RegisterRTTIType(TypeInfo(TFetchOption));
  // Begin of class TClientDataSet
  RegisterClassType(TClientDataSet, H);
  RegisterMethod(TClientDataSet,
       'constructor Create(AOwner: TComponent); override;',
       @TClientDataSet.Create);
  RegisterMethod(TClientDataSet,
       'destructor Destroy; override;',
       @TClientDataSet.Destroy);
  RegisterMethod(TClientDataSet,
       'procedure AppendData(const Data: OleVariant; HitEOF: Boolean);',
       @TClientDataSet.AppendData);
  RegisterMethod(TClientDataSet,
       'procedure ApplyRange;',
       @TClientDataSet.ApplyRange);
  RegisterMethod(TClientDataSet,
       'function ApplyUpdates(MaxErrors: Integer): Integer; virtual;',
       @TClientDataSet.ApplyUpdates);
  RegisterMethod(TClientDataSet,
       'function BookmarkValid(Bookmark: TBookmark): Boolean; override;',
       @TClientDataSet.BookmarkValid);
  RegisterMethod(TClientDataSet,
       'procedure Cancel; override;',
       @TClientDataSet.Cancel);
  RegisterMethod(TClientDataSet,
       'procedure CancelRange;',
       @TClientDataSet.CancelRange);
  RegisterMethod(TClientDataSet,
       'procedure CancelUpdates;',
       @TClientDataSet.CancelUpdates);
  RegisterMethod(TClientDataSet,
       'function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override;',
       @TClientDataSet.CreateBlobStream);
  RegisterMethod(TClientDataSet,
       'procedure CreateDataSet;',
       @TClientDataSet.CreateDataSet);
  RegisterMethod(TClientDataSet,
       'function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; override;',
       @TClientDataSet.CompareBookmarks);
  RegisterMethod(TClientDataSet,
       'function ConstraintsDisabled: Boolean;',
       @TClientDataSet.ConstraintsDisabled);
  RegisterMethod(TClientDataSet,
       'function DataRequest(Data: OleVariant): OleVariant; virtual;',
       @TClientDataSet.DataRequest);
  RegisterMethod(TClientDataSet,
       'procedure DeleteIndex(const Name: string);',
       @TClientDataSet.DeleteIndex);
  RegisterMethod(TClientDataSet,
       'procedure DisableConstraints;',
       @TClientDataSet.DisableConstraints);
  RegisterMethod(TClientDataSet,
       'procedure EnableConstraints;',
       @TClientDataSet.EnableConstraints);
  RegisterMethod(TClientDataSet,
       'procedure EditKey;',
       @TClientDataSet.EditKey);
  RegisterMethod(TClientDataSet,
       'procedure EditRangeEnd;',
       @TClientDataSet.EditRangeEnd);
  RegisterMethod(TClientDataSet,
       'procedure EditRangeStart;',
       @TClientDataSet.EditRangeStart);
  RegisterMethod(TClientDataSet,
       'procedure EmptyDataSet;',
       @TClientDataSet.EmptyDataSet);
  RegisterMethod(TClientDataSet,
       'procedure Execute; virtual;',
       @TClientDataSet.Execute);
  RegisterMethod(TClientDataSet,
       'procedure FetchBlobs;',
       @TClientDataSet.FetchBlobs);
  RegisterMethod(TClientDataSet,
       'procedure FetchDetails;',
       @TClientDataSet.FetchDetails);
  RegisterMethod(TClientDataSet,
       'procedure RefreshRecord;',
       @TClientDataSet.RefreshRecord);
  RegisterMethod(TClientDataSet,
       'procedure FetchParams;',
       @TClientDataSet.FetchParams);
  RegisterMethod(TClientDataSet,
       'function FindKey(const KeyValues: array of const): Boolean; virtual;',
       @TClientDataSet.FindKey);
  RegisterMethod(TClientDataSet,
       'procedure FindNearest(const KeyValues: array of const);',
       @TClientDataSet.FindNearest);
  RegisterMethod(TClientDataSet,
       'function GetCurrentRecord(Buffer: PChar): Boolean; override;',
       @TClientDataSet.GetCurrentRecord);
  RegisterMethod(TClientDataSet,
       'function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;',
       @TClientDataSet.GetFieldData);
  RegisterMethod(TClientDataSet,
       'function GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean; overload; override;',
       @TClientDataSet.GetFieldData);
  RegisterMethod(TClientDataSet,
       'function GetGroupState(Level: Integer): TGroupPosInds;',
       @TClientDataSet.GetGroupState);
  RegisterMethod(TClientDataSet,
       'procedure GetIndexInfo(IndexName: string);',
       @TClientDataSet.GetIndexInfo);
  RegisterMethod(TClientDataSet,
       'procedure GetIndexNames(List: TStrings);',
       @TClientDataSet.GetIndexNames);
  RegisterMethod(TClientDataSet,
       'function GetNextPacket: Integer;',
       @TClientDataSet.GetNextPacket);
  RegisterMethod(TClientDataSet,
       'function GetOptionalParam(const ParamName: string): OleVariant;',
       @TClientDataSet.GetOptionalParam);
  RegisterMethod(TClientDataSet,
       'procedure GotoCurrent(DataSet: TClientDataSet);',
       @TClientDataSet.GotoCurrent);
  RegisterMethod(TClientDataSet,
       'function GotoKey: Boolean;',
       @TClientDataSet.GotoKey);
  RegisterMethod(TClientDataSet,
       'procedure GotoNearest;',
       @TClientDataSet.GotoNearest);
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetHasAppServer:Boolean;',
       @TClientDataSet_GetHasAppServer, Fake);
  RegisterProperty(TClientDataSet,
       'property HasAppServer:Boolean read TClientDataSet_GetHasAppServer;');
  RegisterMethod(TClientDataSet,
       'function Locate(const KeyFields: string; const KeyValues: Variant;      Options: TLocateOptions): Boolean; override;',
       @TClientDataSet.Locate);
  RegisterMethod(TClientDataSet,
       'function Lookup(const KeyFields: string; const KeyValues: Variant;      const ResultFields: string): Variant; override;',
       @TClientDataSet.Lookup);
  RegisterMethod(TClientDataSet,
       'procedure LoadFromStream(Stream: TStream);',
       @TClientDataSet.LoadFromStream);
  RegisterMethod(TClientDataSet,
       'procedure MergeChangeLog;',
       @TClientDataSet.MergeChangeLog);
  RegisterMethod(TClientDataSet,
       'procedure Post; override;',
       @TClientDataSet.Post);
  RegisterMethod(TClientDataSet,
       'function Reconcile(const Results: OleVariant): Boolean;',
       @TClientDataSet.Reconcile);
  RegisterMethod(TClientDataSet,
       'procedure RevertRecord;',
       @TClientDataSet.RevertRecord);
  RegisterMethod(TClientDataSet,
       'procedure SetAltRecBuffers(Old, New, Cur: PChar);',
       @TClientDataSet.SetAltRecBuffers);
  RegisterMethod(TClientDataSet,
       'procedure SetKey;',
       @TClientDataSet.SetKey);
  RegisterMethod(TClientDataSet,
       'procedure SetProvider(Provider: TComponent);',
       @TClientDataSet.SetProvider);
  RegisterMethod(TClientDataSet,
       'procedure SetRange(const StartValues, EndValues: array of const);',
       @TClientDataSet.SetRange);
  RegisterMethod(TClientDataSet,
       'procedure SetRangeEnd;',
       @TClientDataSet.SetRangeEnd);
  RegisterMethod(TClientDataSet,
       'procedure SetRangeStart;',
       @TClientDataSet.SetRangeStart);
  RegisterMethod(TClientDataSet,
       'function UndoLastChange(FollowChange: Boolean): Boolean;',
       @TClientDataSet.UndoLastChange);
  RegisterMethod(TClientDataSet,
       'function UpdateStatus: TUpdateStatus; override;',
       @TClientDataSet.UpdateStatus);
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetActiveAggs(Index: Integer):TList;',
       @TClientDataSet_GetActiveAggs, Fake);
  RegisterProperty(TClientDataSet,
       'property ActiveAggs[Index: Integer]:TList read TClientDataSet_GetActiveAggs;');
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetChangeCount:Integer;',
       @TClientDataSet_GetChangeCount, Fake);
  RegisterProperty(TClientDataSet,
       'property ChangeCount:Integer read TClientDataSet_GetChangeCount;');
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetAppServer:IAppServer;',
       @TClientDataSet_GetAppServer, Fake);
  RegisterMethod(TClientDataSet,
       'procedure TClientDataSet_PutAppServer(const Value: IAppServer);',
       @TClientDataSet_PutAppServer, Fake);
  RegisterProperty(TClientDataSet,
       'property AppServer:IAppServer read TClientDataSet_GetAppServer write TClientDataSet_PutAppServer;');
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetDataSize:Integer;',
       @TClientDataSet_GetDataSize, Fake);
  RegisterProperty(TClientDataSet,
       'property DataSize:Integer read TClientDataSet_GetDataSize;');
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetDelta:OleVariant;',
       @TClientDataSet_GetDelta, Fake);
  RegisterProperty(TClientDataSet,
       'property Delta:OleVariant read TClientDataSet_GetDelta;');
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetGroupingLevel:Integer;',
       @TClientDataSet_GetGroupingLevel, Fake);
  RegisterProperty(TClientDataSet,
       'property GroupingLevel:Integer read TClientDataSet_GetGroupingLevel;');
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetIndexFieldCount:Integer;',
       @TClientDataSet_GetIndexFieldCount, Fake);
  RegisterProperty(TClientDataSet,
       'property IndexFieldCount:Integer read TClientDataSet_GetIndexFieldCount;');
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetIndexFields(Index: Integer):TField;',
       @TClientDataSet_GetIndexFields, Fake);
  RegisterMethod(TClientDataSet,
       'procedure TClientDataSet_PutIndexFields(Index: Integer;const Value: TField);',
       @TClientDataSet_PutIndexFields, Fake);
  RegisterProperty(TClientDataSet,
       'property IndexFields[Index: Integer]:TField read TClientDataSet_GetIndexFields write TClientDataSet_PutIndexFields;');
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetKeyExclusive:Boolean;',
       @TClientDataSet_GetKeyExclusive, Fake);
  RegisterMethod(TClientDataSet,
       'procedure TClientDataSet_PutKeyExclusive(const Value: Boolean);',
       @TClientDataSet_PutKeyExclusive, Fake);
  RegisterProperty(TClientDataSet,
       'property KeyExclusive:Boolean read TClientDataSet_GetKeyExclusive write TClientDataSet_PutKeyExclusive;');
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetKeyFieldCount:Integer;',
       @TClientDataSet_GetKeyFieldCount, Fake);
  RegisterMethod(TClientDataSet,
       'procedure TClientDataSet_PutKeyFieldCount(const Value: Integer);',
       @TClientDataSet_PutKeyFieldCount, Fake);
  RegisterProperty(TClientDataSet,
       'property KeyFieldCount:Integer read TClientDataSet_GetKeyFieldCount write TClientDataSet_PutKeyFieldCount;');
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetKeySize:Word;',
       @TClientDataSet_GetKeySize, Fake);
  RegisterProperty(TClientDataSet,
       'property KeySize:Word read TClientDataSet_GetKeySize;');
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetLogChanges:Boolean;',
       @TClientDataSet_GetLogChanges, Fake);
  RegisterMethod(TClientDataSet,
       'procedure TClientDataSet_PutLogChanges(const Value: Boolean);',
       @TClientDataSet_PutLogChanges, Fake);
  RegisterProperty(TClientDataSet,
       'property LogChanges:Boolean read TClientDataSet_GetLogChanges write TClientDataSet_PutLogChanges;');
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetSavePoint:Integer;',
       @TClientDataSet_GetSavePoint, Fake);
  RegisterMethod(TClientDataSet,
       'procedure TClientDataSet_PutSavePoint(const Value: Integer);',
       @TClientDataSet_PutSavePoint, Fake);
  RegisterProperty(TClientDataSet,
       'property SavePoint:Integer read TClientDataSet_GetSavePoint write TClientDataSet_PutSavePoint;');
  RegisterMethod(TClientDataSet,
       'function TClientDataSet_GetStatusFilter:TUpdateStatusSet;',
       @TClientDataSet_GetStatusFilter, Fake);
  RegisterMethod(TClientDataSet,
       'procedure TClientDataSet_PutStatusFilter(const Value: TUpdateStatusSet);',
       @TClientDataSet_PutStatusFilter, Fake);
  RegisterProperty(TClientDataSet,
       'property StatusFilter:TUpdateStatusSet read TClientDataSet_GetStatusFilter write TClientDataSet_PutStatusFilter;');
  // End of class TClientDataSet
  // Begin of class TClientBlobStream
  RegisterClassType(TClientBlobStream, H);
  RegisterMethod(TClientBlobStream,
       'constructor Create(Field: TBlobField; Mode: TBlobStreamMode);',
       @TClientBlobStream.Create);
  RegisterMethod(TClientBlobStream,
       'destructor Destroy; override;',
       @TClientBlobStream.Destroy);
  RegisterMethod(TClientBlobStream,
       'function Write(const Buffer; Count: Longint): Longint; override;',
       @TClientBlobStream.Write);
  RegisterMethod(TClientBlobStream,
       'procedure Truncate;',
       @TClientBlobStream.Truncate);
  // End of class TClientBlobStream
  RegisterRoutine('procedure UnpackParams(const Source: OleVariant; Dest: TParams);', @UnpackParams, H);
end;

{$ENDIF}
initialization
  RegisterIMP_dbclient;
end.
