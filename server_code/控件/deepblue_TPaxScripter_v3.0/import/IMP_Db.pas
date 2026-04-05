{$IFDEF VER140}
  {$DEFINE Delphi6_UP}
{$ENDIF}

{$IFDEF VER150}
  {$DEFINE Delphi6_UP}
{$ENDIF}

{$IFDEF Delphi6_UP}
unit IMP_DB;
interface
uses
  Windows,
  SysUtils,
  Classes,
  Variants,
  MaskUtils,
  SqlTimSt,
  FMTBcd,
  DB,
  PaxScripter;
procedure RegisterIMP_DB;
implementation
function EUpdateError_ReadContext:String;
begin
  result := EUpdateError(_Self).Context;
end;
function EUpdateError_ReadErrorCode:Integer;
begin
  result := EUpdateError(_Self).ErrorCode;
end;
function EUpdateError_ReadPreviousError:Integer;
begin
  result := EUpdateError(_Self).PreviousError;
end;
function EUpdateError_ReadOriginalException:Exception;
begin
  result := EUpdateError(_Self).OriginalException;
end;
function TCustomConnection_ReadConnected:Boolean;
begin
  result := TCustomConnection(_Self).Connected;
end;
procedure TCustomConnection_WriteConnected(const Value: Boolean);
begin
  TCustomConnection(_Self).Connected := Value;
end;
function TCustomConnection_ReadDataSets(Index: Integer):TDataSet;
begin
  result := TCustomConnection(_Self).DataSets[Index];
end;
function TCustomConnection_ReadDataSetCount:Integer;
begin
  result := TCustomConnection(_Self).DataSetCount;
end;
function TCustomConnection_ReadLoginPrompt:Boolean;
begin
  result := TCustomConnection(_Self).LoginPrompt;
end;
procedure TCustomConnection_WriteLoginPrompt(const Value: Boolean);
begin
  TCustomConnection(_Self).LoginPrompt := Value;
end;
function TCustomConnection_ReadAfterConnect:TNotifyEvent;
begin
  result := TCustomConnection(_Self).AfterConnect;
end;
procedure TCustomConnection_WriteAfterConnect(const Value: TNotifyEvent);
begin
  TCustomConnection(_Self).AfterConnect := Value;
end;
function TCustomConnection_ReadBeforeConnect:TNotifyEvent;
begin
  result := TCustomConnection(_Self).BeforeConnect;
end;
procedure TCustomConnection_WriteBeforeConnect(const Value: TNotifyEvent);
begin
  TCustomConnection(_Self).BeforeConnect := Value;
end;
function TCustomConnection_ReadAfterDisconnect:TNotifyEvent;
begin
  result := TCustomConnection(_Self).AfterDisconnect;
end;
procedure TCustomConnection_WriteAfterDisconnect(const Value: TNotifyEvent);
begin
  TCustomConnection(_Self).AfterDisconnect := Value;
end;
function TCustomConnection_ReadBeforeDisconnect:TNotifyEvent;
begin
  result := TCustomConnection(_Self).BeforeDisconnect;
end;
procedure TCustomConnection_WriteBeforeDisconnect(const Value: TNotifyEvent);
begin
  TCustomConnection(_Self).BeforeDisconnect := Value;
end;
function TDefCollection_ReadDataSet:TDataSet;
begin
  result := TDefCollection(_Self).DataSet;
end;
function TDefCollection_ReadUpdated:Boolean;
begin
  result := TDefCollection(_Self).Updated;
end;
procedure TDefCollection_WriteUpdated(const Value: Boolean);
begin
  TDefCollection(_Self).Updated := Value;
end;
function TFieldDef_ReadFieldClass:TFieldClass;
begin
  result := TFieldDef(_Self).FieldClass;
end;
function TFieldDef_ReadFieldNo:Integer;
begin
  result := TFieldDef(_Self).FieldNo;
end;
procedure TFieldDef_WriteFieldNo(const Value: Integer);
begin
  TFieldDef(_Self).FieldNo := Value;
end;
function TFieldDef_ReadInternalCalcField:Boolean;
begin
  result := TFieldDef(_Self).InternalCalcField;
end;
procedure TFieldDef_WriteInternalCalcField(const Value: Boolean);
begin
  TFieldDef(_Self).InternalCalcField := Value;
end;
function TFieldDef_ReadParentDef:TFieldDef;
begin
  result := TFieldDef(_Self).ParentDef;
end;
function TFieldDef_ReadRequired:Boolean;
begin
  result := TFieldDef(_Self).Required;
end;
procedure TFieldDef_WriteRequired(const Value: Boolean);
begin
  TFieldDef(_Self).Required := Value;
end;
function TFieldDefs_ReadHiddenFields:Boolean;
begin
  result := TFieldDefs(_Self).HiddenFields;
end;
procedure TFieldDefs_WriteHiddenFields(const Value: Boolean);
begin
  TFieldDefs(_Self).HiddenFields := Value;
end;
function TFieldDefs_ReadItems(Index: Integer):TFieldDef;
begin
  result := TFieldDefs(_Self).Items[Index];
end;
procedure TFieldDefs_WriteItems(Index: Integer;const Value: TFieldDef);
begin
  TFieldDefs(_Self).Items[Index] := Value;
end;
function TFieldDefs_ReadParentDef:TFieldDef;
begin
  result := TFieldDefs(_Self).ParentDef;
end;
function TIndexDef_ReadFieldExpression:String;
begin
  result := TIndexDef(_Self).FieldExpression;
end;
function TIndexDefs_ReadItems(Index: Integer):TIndexDef;
begin
  result := TIndexDefs(_Self).Items[Index];
end;
procedure TIndexDefs_WriteItems(Index: Integer;const Value: TIndexDef);
begin
  TIndexDefs(_Self).Items[Index] := Value;
end;
function TFlatList_ReadDataSet:TDataSet;
begin
  result := TFlatList(_Self).DataSet;
end;
function TFieldDefList_ReadFieldDefs(Index: Integer):TFieldDef;
begin
  result := TFieldDefList(_Self).FieldDefs[Index];
end;
function TFieldList_ReadFields(Index: Integer):TField;
begin
  result := TFieldList(_Self).Fields[Index];
end;
function TFields_ReadCount:Integer;
begin
  result := TFields(_Self).Count;
end;
function TFields_ReadDataSet:TDataSet;
begin
  result := TFields(_Self).DataSet;
end;
function TFields_ReadFields(Index: Integer):TField;
begin
  result := TFields(_Self).Fields[Index];
end;
procedure TFields_WriteFields(Index: Integer;const Value: TField);
begin
  TFields(_Self).Fields[Index] := Value;
end;
function TField_ReadAsBCD:TBcd;
begin
  result := TField(_Self).AsBCD;
end;
procedure TField_WriteAsBCD(const Value: TBcd);
begin
  TField(_Self).AsBCD := Value;
end;
function TField_ReadAsBoolean:Boolean;
begin
  result := TField(_Self).AsBoolean;
end;
procedure TField_WriteAsBoolean(const Value: Boolean);
begin
  TField(_Self).AsBoolean := Value;
end;
function TField_ReadAsCurrency:Currency;
begin
  result := TField(_Self).AsCurrency;
end;
procedure TField_WriteAsCurrency(const Value: Currency);
begin
  TField(_Self).AsCurrency := Value;
end;
function TField_ReadAsDateTime:TDateTime;
begin
  result := TField(_Self).AsDateTime;
end;
procedure TField_WriteAsDateTime(const Value: TDateTime);
begin
  TField(_Self).AsDateTime := Value;
end;
function TField_ReadAsSQLTimeStamp:TSQLTimeStamp;
begin
  result := TField(_Self).AsSQLTimeStamp;
end;
procedure TField_WriteAsSQLTimeStamp(const Value: TSQLTimeStamp);
begin
  TField(_Self).AsSQLTimeStamp := Value;
end;
function TField_ReadAsFloat:Double;
begin
  result := TField(_Self).AsFloat;
end;
procedure TField_WriteAsFloat(const Value: Double);
begin
  TField(_Self).AsFloat := Value;
end;
function TField_ReadAsInteger:Longint;
begin
  result := TField(_Self).AsInteger;
end;
procedure TField_WriteAsInteger(const Value: Longint);
begin
  TField(_Self).AsInteger := Value;
end;
function TField_ReadAsString:String;
begin
  result := TField(_Self).AsString;
end;
procedure TField_WriteAsString(const Value: String);
begin
  TField(_Self).AsString := Value;
end;
function TField_ReadAsVariant:Variant;
begin
  result := TField(_Self).AsVariant;
end;
procedure TField_WriteAsVariant(const Value: Variant);
begin
  TField(_Self).AsVariant := Value;
end;
function TField_ReadAttributeSet:String;
begin
  result := TField(_Self).AttributeSet;
end;
procedure TField_WriteAttributeSet(const Value: String);
begin
  TField(_Self).AttributeSet := Value;
end;
function TField_ReadCalculated:Boolean;
begin
  result := TField(_Self).Calculated;
end;
procedure TField_WriteCalculated(const Value: Boolean);
begin
  TField(_Self).Calculated := Value;
end;
function TField_ReadCanModify:Boolean;
begin
  result := TField(_Self).CanModify;
end;
function TField_ReadCurValue:Variant;
begin
  result := TField(_Self).CurValue;
end;
function TField_ReadDataSet:TDataSet;
begin
  result := TField(_Self).DataSet;
end;
procedure TField_WriteDataSet(const Value: TDataSet);
begin
  TField(_Self).DataSet := Value;
end;
function TField_ReadDataSize:Integer;
begin
  result := TField(_Self).DataSize;
end;
function TField_ReadDataType:TFieldType;
begin
  result := TField(_Self).DataType;
end;
function TField_ReadDisplayName:String;
begin
  result := TField(_Self).DisplayName;
end;
function TField_ReadDisplayText:String;
begin
  result := TField(_Self).DisplayText;
end;
function TField_ReadEditMask:TEditMask;
begin
  result := TField(_Self).EditMask;
end;
procedure TField_WriteEditMask(const Value: TEditMask);
begin
  TField(_Self).EditMask := Value;
end;
function TField_ReadEditMaskPtr:TEditMask;
begin
  result := TField(_Self).EditMaskPtr;
end;
function TField_ReadFieldNo:Integer;
begin
  result := TField(_Self).FieldNo;
end;
function TField_ReadFullName:String;
begin
  result := TField(_Self).FullName;
end;
function TField_ReadIsIndexField:Boolean;
begin
  result := TField(_Self).IsIndexField;
end;
function TField_ReadIsNull:Boolean;
begin
  result := TField(_Self).IsNull;
end;
function TField_ReadLookup:Boolean;
begin
  result := TField(_Self).Lookup;
end;
procedure TField_WriteLookup(const Value: Boolean);
begin
  TField(_Self).Lookup := Value;
end;
function TField_ReadLookupList:TLookupList;
begin
  result := TField(_Self).LookupList;
end;
function TField_ReadNewValue:Variant;
begin
  result := TField(_Self).NewValue;
end;
procedure TField_WriteNewValue(const Value: Variant);
begin
  TField(_Self).NewValue := Value;
end;
function TField_ReadOffset:Integer;
begin
  result := TField(_Self).Offset;
end;
function TField_ReadOldValue:Variant;
begin
  result := TField(_Self).OldValue;
end;
function TField_ReadParentField:TObjectField;
begin
  result := TField(_Self).ParentField;
end;
procedure TField_WriteParentField(const Value: TObjectField);
begin
  TField(_Self).ParentField := Value;
end;
function TField_ReadSize:Integer;
begin
  result := TField(_Self).Size;
end;
procedure TField_WriteSize(const Value: Integer);
begin
  TField(_Self).Size := Value;
end;
function TField_ReadText:String;
begin
  result := TField(_Self).Text;
end;
procedure TField_WriteText(const Value: String);
begin
  TField(_Self).Text := Value;
end;
function TField_ReadValidChars:TFieldChars;
begin
  result := TField(_Self).ValidChars;
end;
procedure TField_WriteValidChars(const Value: TFieldChars);
begin
  TField(_Self).ValidChars := Value;
end;
function TField_ReadValue:Variant;
begin
  result := TField(_Self).Value;
end;
procedure TField_WriteValue(const Value: Variant);
begin
  TField(_Self).Value := Value;
end;
function TStringField_ReadValue:String;
begin
  result := TStringField(_Self).Value;
end;
procedure TStringField_WriteValue(const Value: String);
begin
  TStringField(_Self).Value := Value;
end;
function TWideStringField_ReadValue:WideString;
begin
  result := TWideStringField(_Self).Value;
end;
procedure TWideStringField_WriteValue(const Value: WideString);
begin
  TWideStringField(_Self).Value := Value;
end;
function TIntegerField_ReadValue:Longint;
begin
  result := TIntegerField(_Self).Value;
end;
procedure TIntegerField_WriteValue(const Value: Longint);
begin
  TIntegerField(_Self).Value := Value;
end;
function TLargeintField_ReadAsLargeInt:LargeInt;
begin
  result := TLargeintField(_Self).AsLargeInt;
end;
procedure TLargeintField_WriteAsLargeInt(const Value: LargeInt);
begin
  TLargeintField(_Self).AsLargeInt := Value;
end;
function TLargeintField_ReadValue:Largeint;
begin
  result := TLargeintField(_Self).Value;
end;
procedure TLargeintField_WriteValue(const Value: Largeint);
begin
  TLargeintField(_Self).Value := Value;
end;
function TFloatField_ReadValue:Double;
begin
  result := TFloatField(_Self).Value;
end;
procedure TFloatField_WriteValue(const Value: Double);
begin
  TFloatField(_Self).Value := Value;
end;
function TBooleanField_ReadValue:Boolean;
begin
  result := TBooleanField(_Self).Value;
end;
procedure TBooleanField_WriteValue(const Value: Boolean);
begin
  TBooleanField(_Self).Value := Value;
end;
function TDateTimeField_ReadValue:TDateTime;
begin
  result := TDateTimeField(_Self).Value;
end;
procedure TDateTimeField_WriteValue(const Value: TDateTime);
begin
  TDateTimeField(_Self).Value := Value;
end;
function TSQLTimeStampField_ReadValue:TSQLTimeStamp;
begin
  result := TSQLTimeStampField(_Self).Value;
end;
procedure TSQLTimeStampField_WriteValue(const Value: TSQLTimeStamp);
begin
  TSQLTimeStampField(_Self).Value := Value;
end;
function TBCDField_ReadValue:Currency;
begin
  result := TBCDField(_Self).Value;
end;
procedure TBCDField_WriteValue(const Value: Currency);
begin
  TBCDField(_Self).Value := Value;
end;
function TFMTBCDField_ReadValue:TBcd;
begin
  result := TFMTBCDField(_Self).Value;
end;
procedure TFMTBCDField_WriteValue(const Value: TBcd);
begin
  TFMTBCDField(_Self).Value := Value;
end;
function TBlobField_ReadBlobSize:Integer;
begin
  result := TBlobField(_Self).BlobSize;
end;
function TBlobField_ReadModified:Boolean;
begin
  result := TBlobField(_Self).Modified;
end;
procedure TBlobField_WriteModified(const Value: Boolean);
begin
  TBlobField(_Self).Modified := Value;
end;
function TBlobField_ReadValue:String;
begin
  result := TBlobField(_Self).Value;
end;
procedure TBlobField_WriteValue(const Value: String);
begin
  TBlobField(_Self).Value := Value;
end;
function TBlobField_ReadTransliterate:Boolean;
begin
  result := TBlobField(_Self).Transliterate;
end;
procedure TBlobField_WriteTransliterate(const Value: Boolean);
begin
  TBlobField(_Self).Transliterate := Value;
end;
function TObjectField_ReadFieldCount:Integer;
begin
  result := TObjectField(_Self).FieldCount;
end;
function TObjectField_ReadFields:TFields;
begin
  result := TObjectField(_Self).Fields;
end;
function TObjectField_ReadFieldValues(Index: Integer):Variant;
begin
  result := TObjectField(_Self).FieldValues[Index];
end;
procedure TObjectField_WriteFieldValues(Index: Integer;const Value: Variant);
begin
  TObjectField(_Self).FieldValues[Index] := Value;
end;
function TObjectField_ReadUnNamed:Boolean;
begin
  result := TObjectField(_Self).UnNamed;
end;
function TDataSetField_ReadNestedDataSet:TDataSet;
begin
  result := TDataSetField(_Self).NestedDataSet;
end;
function TInterfaceField_ReadValue:IUnknown;
begin
  result := TInterfaceField(_Self).Value;
end;
procedure TInterfaceField_WriteValue(const Value: IUnknown);
begin
  TInterfaceField(_Self).Value := Value;
end;
function TIDispatchField_ReadValue:IDispatch;
begin
  result := TIDispatchField(_Self).Value;
end;
procedure TIDispatchField_WriteValue(const Value: IDispatch);
begin
  TIDispatchField(_Self).Value := Value;
end;
function TGuidField_ReadAsGuid:TGUID;
begin
  result := TGuidField(_Self).AsGuid;
end;
procedure TGuidField_WriteAsGuid(const Value: TGUID);
begin
  TGuidField(_Self).AsGuid := Value;
end;
function TAggregateField_ReadHandle:Pointer;
begin
  result := TAggregateField(_Self).Handle;
end;
procedure TAggregateField_WriteHandle(const Value: Pointer);
begin
  TAggregateField(_Self).Handle := Value;
end;
function TAggregateField_ReadResultType:TFieldType;
begin
  result := TAggregateField(_Self).ResultType;
end;
procedure TAggregateField_WriteResultType(const Value: TFieldType);
begin
  TAggregateField(_Self).ResultType := Value;
end;
function TDataLink_ReadActive:Boolean;
begin
  result := TDataLink(_Self).Active;
end;
function TDataLink_ReadActiveRecord:Integer;
begin
  result := TDataLink(_Self).ActiveRecord;
end;
procedure TDataLink_WriteActiveRecord(const Value: Integer);
begin
  TDataLink(_Self).ActiveRecord := Value;
end;
function TDataLink_ReadBOF:Boolean;
begin
  result := TDataLink(_Self).BOF;
end;
function TDataLink_ReadBufferCount:Integer;
begin
  result := TDataLink(_Self).BufferCount;
end;
procedure TDataLink_WriteBufferCount(const Value: Integer);
begin
  TDataLink(_Self).BufferCount := Value;
end;
function TDataLink_ReadDataSet:TDataSet;
begin
  result := TDataLink(_Self).DataSet;
end;
function TDataLink_ReadDataSource:TDataSource;
begin
  result := TDataLink(_Self).DataSource;
end;
procedure TDataLink_WriteDataSource(const Value: TDataSource);
begin
  TDataLink(_Self).DataSource := Value;
end;
function TDataLink_ReadDataSourceFixed:Boolean;
begin
  result := TDataLink(_Self).DataSourceFixed;
end;

procedure TDataLink_WriteDataSourceFixed(const Value: Boolean);
begin
  TDataLink(_Self).DataSourceFixed := Value;
end;
function TDataLink_ReadEditing:Boolean;
begin
  result := TDataLink(_Self).Editing;
end;
function TDataLink_ReadEof:Boolean;
begin
  result := TDataLink(_Self).Eof;
end;
function TDataLink_ReadReadOnly:Boolean;
begin
  result := TDataLink(_Self).ReadOnly;
end;
procedure TDataLink_WriteReadOnly(const Value: Boolean);
begin
  TDataLink(_Self).ReadOnly := Value;
end;
function TDataLink_ReadRecordCount:Integer;
begin
  result := TDataLink(_Self).RecordCount;
end;
function TDetailDataLink_ReadDetailDataSet:TDataSet;
begin
  result := TDetailDataLink(_Self).DetailDataSet;
end;
function TMasterDataLink_ReadFieldNames:String;
begin
  result := TMasterDataLink(_Self).FieldNames;
end;
procedure TMasterDataLink_WriteFieldNames(const Value: String);
begin
  TMasterDataLink(_Self).FieldNames := Value;
end;
function TMasterDataLink_ReadFields:TList;
begin
  result := TMasterDataLink(_Self).Fields;
end;
function TDataSource_ReadState:TDataSetState;
begin
  result := TDataSource(_Self).State;
end;
function TDataSetDesigner_ReadDataSet:TDataSet;
begin
  result := TDataSetDesigner(_Self).DataSet;
end;
function TCheckConstraints_ReadItems(Index: Integer):TCheckConstraint;
begin
  result := TCheckConstraints(_Self).Items[Index];
end;
procedure TCheckConstraints_WriteItems(Index: Integer;const Value: TCheckConstraint);
begin
  TCheckConstraints(_Self).Items[Index] := Value;
end;
function TParam_ReadAsBCD:Currency;
begin
  result := TParam(_Self).AsBCD;
end;
procedure TParam_WriteAsBCD(const Value: Currency);
begin
  TParam(_Self).AsBCD := Value;
end;
function TParam_ReadAsFMTBCD:TBcd;
begin
  result := TParam(_Self).AsFMTBCD;
end;
procedure TParam_WriteAsFMTBCD(const Value: TBcd);
begin
  TParam(_Self).AsFMTBCD := Value;
end;
function TParam_ReadAsBlob:TBlobData;
begin
  result := TParam(_Self).AsBlob;
end;
procedure TParam_WriteAsBlob(const Value: TBlobData);
begin
  TParam(_Self).AsBlob := Value;
end;
function TParam_ReadAsBoolean:Boolean;
begin
  result := TParam(_Self).AsBoolean;
end;
procedure TParam_WriteAsBoolean(const Value: Boolean);
begin
  TParam(_Self).AsBoolean := Value;
end;
function TParam_ReadAsCurrency:Currency;
begin
  result := TParam(_Self).AsCurrency;
end;
procedure TParam_WriteAsCurrency(const Value: Currency);
begin
  TParam(_Self).AsCurrency := Value;
end;
function TParam_ReadAsDate:TDateTime;
begin
  result := TParam(_Self).AsDate;
end;
procedure TParam_WriteAsDate(const Value: TDateTime);
begin
  TParam(_Self).AsDate := Value;
end;
function TParam_ReadAsDateTime:TDateTime;
begin
  result := TParam(_Self).AsDateTime;
end;
procedure TParam_WriteAsDateTime(const Value: TDateTime);
begin
  TParam(_Self).AsDateTime := Value;
end;
function TParam_ReadAsFloat:Double;
begin
  result := TParam(_Self).AsFloat;
end;
procedure TParam_WriteAsFloat(const Value: Double);
begin
  TParam(_Self).AsFloat := Value;
end;
function TParam_ReadAsInteger:LongInt;
begin
  result := TParam(_Self).AsInteger;
end;
procedure TParam_WriteAsInteger(const Value: LongInt);
begin
  TParam(_Self).AsInteger := Value;
end;
function TParam_ReadAsSmallInt:LongInt;
begin
  result := TParam(_Self).AsSmallInt;
end;
procedure TParam_WriteAsSmallInt(const Value: LongInt);
begin
  TParam(_Self).AsSmallInt := Value;
end;
function TParam_ReadAsSQLTimeStamp:TSQLTimeStamp;
begin
  result := TParam(_Self).AsSQLTimeStamp;
end;
procedure TParam_WriteAsSQLTimeStamp(const Value: TSQLTimeStamp);
begin
  TParam(_Self).AsSQLTimeStamp := Value;
end;
function TParam_ReadAsMemo:String;
begin
  result := TParam(_Self).AsMemo;
end;
procedure TParam_WriteAsMemo(const Value: String);
begin
  TParam(_Self).AsMemo := Value;
end;
function TParam_ReadAsString:String;
begin
  result := TParam(_Self).AsString;
end;
procedure TParam_WriteAsString(const Value: String);
begin
  TParam(_Self).AsString := Value;
end;
function TParam_ReadAsTime:TDateTime;
begin
  result := TParam(_Self).AsTime;
end;
procedure TParam_WriteAsTime(const Value: TDateTime);
begin
  TParam(_Self).AsTime := Value;
end;
function TParam_ReadAsWord:LongInt;
begin
  result := TParam(_Self).AsWord;
end;
procedure TParam_WriteAsWord(const Value: LongInt);
begin
  TParam(_Self).AsWord := Value;
end;
function TParam_ReadBound:Boolean;
begin
  result := TParam(_Self).Bound;
end;
procedure TParam_WriteBound(const Value: Boolean);
begin
  TParam(_Self).Bound := Value;
end;
function TParam_ReadIsNull:Boolean;
begin
  result := TParam(_Self).IsNull;
end;
function TParam_ReadNativeStr:String;
begin
  result := TParam(_Self).NativeStr;
end;
procedure TParam_WriteNativeStr(const Value: String);
begin
  TParam(_Self).NativeStr := Value;
end;
function TParam_ReadText:String;
begin
  result := TParam(_Self).Text;
end;
procedure TParam_WriteText(const Value: String);
begin
  TParam(_Self).Text := Value;
end;
function TParams_ReadItems(Index: Integer):TParam;
begin
  result := TParams(_Self).Items[Index];
end;
procedure TParams_WriteItems(Index: Integer;const Value: TParam);
begin
  TParams(_Self).Items[Index] := Value;
end;
function TParams_ReadParamValues(const ParamName: string):Variant;
begin
  result := TParams(_Self).ParamValues[ParamName];
end;
procedure TParams_WriteParamValues(const ParamName: string;const Value: Variant);
begin
  TParams(_Self).ParamValues[ParamName] := Value;
end;
function TDataSet_ReadAggFields:TFields;
begin
  result := TDataSet(_Self).AggFields;
end;
function TDataSet_ReadBof:Boolean;
begin
  result := TDataSet(_Self).Bof;
end;
function TDataSet_ReadBookmark:TBookmarkStr;
begin
  result := TDataSet(_Self).Bookmark;
end;
procedure TDataSet_WriteBookmark(const Value: TBookmarkStr);
begin
  TDataSet(_Self).Bookmark := Value;
end;
function TDataSet_ReadCanModify:Boolean;
begin
  result := TDataSet(_Self).CanModify;
end;
function TDataSet_ReadDataSetField:TDataSetField;
begin
  result := TDataSet(_Self).DataSetField;
end;
procedure TDataSet_WriteDataSetField(const Value: TDataSetField);
begin
  TDataSet(_Self).DataSetField := Value;
end;
function TDataSet_ReadDataSource:TDataSource;
begin
  result := TDataSet(_Self).DataSource;
end;
function TDataSet_ReadDefaultFields:Boolean;
begin
  result := TDataSet(_Self).DefaultFields;
end;
function TDataSet_ReadDesigner:TDataSetDesigner;
begin
  result := TDataSet(_Self).Designer;
end;
function TDataSet_ReadEof:Boolean;
begin
  result := TDataSet(_Self).Eof;
end;
function TDataSet_ReadBlockReadSize:Integer;
begin
  result := TDataSet(_Self).BlockReadSize;
end;
procedure TDataSet_WriteBlockReadSize(const Value: Integer);
begin
  TDataSet(_Self).BlockReadSize := Value;
end;
function TDataSet_ReadFieldCount:Integer;
begin
  result := TDataSet(_Self).FieldCount;
end;
function TDataSet_ReadFieldDefs:TFieldDefs;
begin
  result := TDataSet(_Self).FieldDefs;
end;
procedure TDataSet_WriteFieldDefs(const Value: TFieldDefs);
begin
  TDataSet(_Self).FieldDefs := Value;
end;
function TDataSet_ReadFieldDefList:TFieldDefList;
begin
  result := TDataSet(_Self).FieldDefList;
end;
function TDataSet_ReadFields:TFields;
begin
  result := TDataSet(_Self).Fields;
end;
function TDataSet_ReadFieldList:TFieldList;
begin
  result := TDataSet(_Self).FieldList;
end;
function TDataSet_ReadFieldValues(const FieldName: string):Variant;
begin
  result := TDataSet(_Self).FieldValues[FieldName];
end;
procedure TDataSet_WriteFieldValues(const FieldName: string;const Value: Variant);
begin
  TDataSet(_Self).FieldValues[FieldName] := Value;
end;
function TDataSet_ReadFound:Boolean;
begin
  result := TDataSet(_Self).Found;
end;
function TDataSet_ReadIsUniDirectional:Boolean;
begin
  result := TDataSet(_Self).IsUniDirectional;
end;
function TDataSet_ReadModified:Boolean;
begin
  result := TDataSet(_Self).Modified;
end;
function TDataSet_ReadObjectView:Boolean;
begin
  result := TDataSet(_Self).ObjectView;
end;
procedure TDataSet_WriteObjectView(const Value: Boolean);
begin
  TDataSet(_Self).ObjectView := Value;
end;
function TDataSet_ReadRecordCount:Integer;
begin
  result := TDataSet(_Self).RecordCount;
end;
function TDataSet_ReadRecNo:Integer;
begin
  result := TDataSet(_Self).RecNo;
end;
procedure TDataSet_WriteRecNo(const Value: Integer);
begin
  TDataSet(_Self).RecNo := Value;
end;
function TDataSet_ReadRecordSize:Word;
begin
  result := TDataSet(_Self).RecordSize;
end;
function TDataSet_ReadSparseArrays:Boolean;
begin
  result := TDataSet(_Self).SparseArrays;
end;
procedure TDataSet_WriteSparseArrays(const Value: Boolean);
begin
  TDataSet(_Self).SparseArrays := Value;
end;
function TDataSet_ReadState:TDataSetState;
begin
  result := TDataSet(_Self).State;
end;
function TDataSet_ReadFilter:String;
begin
  result := TDataSet(_Self).Filter;
end;
procedure TDataSet_WriteFilter(const Value: String);
begin
  TDataSet(_Self).Filter := Value;
end;
function TDataSet_ReadFiltered:Boolean;
begin
  result := TDataSet(_Self).Filtered;
end;
procedure TDataSet_WriteFiltered(const Value: Boolean);
begin
  TDataSet(_Self).Filtered := Value;
end;
function TDataSet_ReadFilterOptions:TFilterOptions;
begin
  result := TDataSet(_Self).FilterOptions;
end;
procedure TDataSet_WriteFilterOptions(const Value: TFilterOptions);
begin
  TDataSet(_Self).FilterOptions := Value;
end;
function TDataSet_ReadActive:Boolean;
begin
  result := TDataSet(_Self).Active;
end;
procedure TDataSet_WriteActive(const Value: Boolean);
begin
  TDataSet(_Self).Active := Value;
end;
function TDataSet_ReadAutoCalcFields:Boolean;
begin
  result := TDataSet(_Self).AutoCalcFields;
end;
procedure TDataSet_WriteAutoCalcFields(const Value: Boolean);
begin
  TDataSet(_Self).AutoCalcFields := Value;
end;
function TDataSet_ReadBeforeOpen:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeOpen;
end;
procedure TDataSet_WriteBeforeOpen(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeOpen := Value;
end;
function TDataSet_ReadAfterOpen:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterOpen;
end;
procedure TDataSet_WriteAfterOpen(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterOpen := Value;
end;
function TDataSet_ReadBeforeClose:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeClose;
end;
procedure TDataSet_WriteBeforeClose(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeClose := Value;
end;
function TDataSet_ReadAfterClose:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterClose;
end;
procedure TDataSet_WriteAfterClose(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterClose := Value;
end;
function TDataSet_ReadBeforeInsert:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeInsert;
end;
procedure TDataSet_WriteBeforeInsert(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeInsert := Value;
end;
function TDataSet_ReadAfterInsert:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterInsert;
end;
procedure TDataSet_WriteAfterInsert(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterInsert := Value;
end;
function TDataSet_ReadBeforeEdit:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeEdit;
end;
procedure TDataSet_WriteBeforeEdit(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeEdit := Value;
end;
function TDataSet_ReadAfterEdit:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterEdit;
end;
procedure TDataSet_WriteAfterEdit(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterEdit := Value;
end;
function TDataSet_ReadBeforePost:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforePost;
end;
procedure TDataSet_WriteBeforePost(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforePost := Value;
end;
function TDataSet_ReadAfterPost:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterPost;
end;
procedure TDataSet_WriteAfterPost(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterPost := Value;
end;
function TDataSet_ReadBeforeCancel:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeCancel;
end;
procedure TDataSet_WriteBeforeCancel(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeCancel := Value;
end;
function TDataSet_ReadAfterCancel:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterCancel;
end;
procedure TDataSet_WriteAfterCancel(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterCancel := Value;
end;
function TDataSet_ReadBeforeDelete:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeDelete;
end;
procedure TDataSet_WriteBeforeDelete(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeDelete := Value;
end;
function TDataSet_ReadAfterDelete:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterDelete;
end;
procedure TDataSet_WriteAfterDelete(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterDelete := Value;
end;
function TDataSet_ReadBeforeScroll:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeScroll;
end;
procedure TDataSet_WriteBeforeScroll(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeScroll := Value;
end;
function TDataSet_ReadAfterScroll:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterScroll;
end;
procedure TDataSet_WriteAfterScroll(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterScroll := Value;
end;
function TDataSet_ReadBeforeRefresh:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeRefresh;
end;
procedure TDataSet_WriteBeforeRefresh(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeRefresh := Value;
end;
function TDataSet_ReadAfterRefresh:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterRefresh;
end;
procedure TDataSet_WriteAfterRefresh(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterRefresh := Value;
end;
procedure RegisterIMP_DB;
var H: Integer;
begin
  H := RegisterNamespace('DB', -1);
  // Begin of class EUpdateError
  RegisterClassType(EUpdateError, H);
  RegisterMethod(EUpdateError,
       'constructor Create(NativeError, Context: string;      ErrCode, PrevError: Integer; E: Exception);',
       @EUpdateError.Create);
  RegisterMethod(EUpdateError,
       'destructor Destroy; override;',
       @EUpdateError.Destroy);
  RegisterMethod(EUpdateError,
       'function EUpdateError_ReadContext:String;',
       @EUpdateError_ReadContext, Fake);
  RegisterProperty(EUpdateError,
       'property Context:String read EUpdateError_ReadContext;');
  RegisterMethod(EUpdateError,
       'function EUpdateError_ReadErrorCode:Integer;',
       @EUpdateError_ReadErrorCode, Fake);
  RegisterProperty(EUpdateError,
       'property ErrorCode:Integer read EUpdateError_ReadErrorCode;');
  RegisterMethod(EUpdateError,
       'function EUpdateError_ReadPreviousError:Integer;',
       @EUpdateError_ReadPreviousError, Fake);
  RegisterProperty(EUpdateError,
       'property PreviousError:Integer read EUpdateError_ReadPreviousError;');
  RegisterMethod(EUpdateError,
       'function EUpdateError_ReadOriginalException:Exception;',
       @EUpdateError_ReadOriginalException, Fake);
  RegisterProperty(EUpdateError,
       'property OriginalException:Exception read EUpdateError_ReadOriginalException;');
  // End of class EUpdateError
  RegisterRTTIType(TypeInfo(TFieldType));
  RegisterRTTIType(TypeInfo(TDataSetState));
  RegisterRTTIType(TypeInfo(TDataEvent));
  RegisterRTTIType(TypeInfo(TUpdateStatus));
  RegisterRTTIType(TypeInfo(TUpdateAction));
  RegisterRTTIType(TypeInfo(TUpdateMode));
  RegisterRTTIType(TypeInfo(TUpdateKind));
  // Begin of class TCustomConnection
  RegisterClassType(TCustomConnection, H);
  RegisterMethod(TCustomConnection,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomConnection.Create);
  RegisterMethod(TCustomConnection,
       'destructor Destroy; override;',
       @TCustomConnection.Destroy);
  RegisterMethod(TCustomConnection,
       'procedure Open; overload;',
       @TCustomConnection.Open);
  RegisterMethod(TCustomConnection,
       'procedure Close;',
       @TCustomConnection.Close);
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_ReadConnected:Boolean;',
       @TCustomConnection_ReadConnected, Fake);
  RegisterMethod(TCustomConnection,
       'procedure TCustomConnection_WriteConnected(const Value: Boolean);',
       @TCustomConnection_WriteConnected, Fake);
  RegisterProperty(TCustomConnection,
       'property Connected:Boolean read TCustomConnection_ReadConnected write TCustomConnection_WriteConnected;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_ReadDataSets(Index: Integer):TDataSet;',
       @TCustomConnection_ReadDataSets, Fake);
  RegisterProperty(TCustomConnection,
       'property DataSets[Index: Integer]:TDataSet read TCustomConnection_ReadDataSets;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_ReadDataSetCount:Integer;',
       @TCustomConnection_ReadDataSetCount, Fake);
  RegisterProperty(TCustomConnection,
       'property DataSetCount:Integer read TCustomConnection_ReadDataSetCount;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_ReadLoginPrompt:Boolean;',
       @TCustomConnection_ReadLoginPrompt, Fake);
  RegisterMethod(TCustomConnection,
       'procedure TCustomConnection_WriteLoginPrompt(const Value: Boolean);',
       @TCustomConnection_WriteLoginPrompt, Fake);
  RegisterProperty(TCustomConnection,
       'property LoginPrompt:Boolean read TCustomConnection_ReadLoginPrompt write TCustomConnection_WriteLoginPrompt;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_ReadAfterConnect:TNotifyEvent;',
       @TCustomConnection_ReadAfterConnect, Fake);
  RegisterMethod(TCustomConnection,
       'procedure TCustomConnection_WriteAfterConnect(const Value: TNotifyEvent);',
       @TCustomConnection_WriteAfterConnect, Fake);
  RegisterProperty(TCustomConnection,
       'property AfterConnect:TNotifyEvent read TCustomConnection_ReadAfterConnect write TCustomConnection_WriteAfterConnect;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_ReadBeforeConnect:TNotifyEvent;',
       @TCustomConnection_ReadBeforeConnect, Fake);
  RegisterMethod(TCustomConnection,
       'procedure TCustomConnection_WriteBeforeConnect(const Value: TNotifyEvent);',
       @TCustomConnection_WriteBeforeConnect, Fake);
  RegisterProperty(TCustomConnection,
       'property BeforeConnect:TNotifyEvent read TCustomConnection_ReadBeforeConnect write TCustomConnection_WriteBeforeConnect;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_ReadAfterDisconnect:TNotifyEvent;',
       @TCustomConnection_ReadAfterDisconnect, Fake);
  RegisterMethod(TCustomConnection,
       'procedure TCustomConnection_WriteAfterDisconnect(const Value: TNotifyEvent);',
       @TCustomConnection_WriteAfterDisconnect, Fake);
  RegisterProperty(TCustomConnection,
       'property AfterDisconnect:TNotifyEvent read TCustomConnection_ReadAfterDisconnect write TCustomConnection_WriteAfterDisconnect;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_ReadBeforeDisconnect:TNotifyEvent;',
       @TCustomConnection_ReadBeforeDisconnect, Fake);
  RegisterMethod(TCustomConnection,
       'procedure TCustomConnection_WriteBeforeDisconnect(const Value: TNotifyEvent);',
       @TCustomConnection_WriteBeforeDisconnect, Fake);
  RegisterProperty(TCustomConnection,
       'property BeforeDisconnect:TNotifyEvent read TCustomConnection_ReadBeforeDisconnect write TCustomConnection_WriteBeforeDisconnect;');
  // End of class TCustomConnection
  // Begin of class TNamedItem
  RegisterClassType(TNamedItem, H);
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TNamedItem
  // Begin of class TDefCollection
  RegisterClassType(TDefCollection, H);
  RegisterMethod(TDefCollection,
       'constructor Create(ADataSet: TDataSet; AOwner: TPersistent;      AClass: TCollectionItemClass);',
       @TDefCollection.Create);
  RegisterMethod(TDefCollection,
       'function Find(const AName: string): TNamedItem;',
       @TDefCollection.Find);
  RegisterMethod(TDefCollection,
       'procedure GetItemNames(List: TStrings);',
       @TDefCollection.GetItemNames);
  RegisterMethod(TDefCollection,
       'function IndexOf(const AName: string): Integer;',
       @TDefCollection.IndexOf);
  RegisterMethod(TDefCollection,
       'function TDefCollection_ReadDataSet:TDataSet;',
       @TDefCollection_ReadDataSet, Fake);
  RegisterProperty(TDefCollection,
       'property DataSet:TDataSet read TDefCollection_ReadDataSet;');
  RegisterMethod(TDefCollection,
       'function TDefCollection_ReadUpdated:Boolean;',
       @TDefCollection_ReadUpdated, Fake);
  RegisterMethod(TDefCollection,
       'procedure TDefCollection_WriteUpdated(const Value: Boolean);',
       @TDefCollection_WriteUpdated, Fake);
  RegisterProperty(TDefCollection,
       'property Updated:Boolean read TDefCollection_ReadUpdated write TDefCollection_WriteUpdated;');
  // End of class TDefCollection
  RegisterRTTIType(TypeInfo(TFieldAttribute));
  // Begin of class TFieldDef
  RegisterClassType(TFieldDef, H);
  RegisterMethod(TFieldDef,
       'constructor Create(Owner: TFieldDefs; const Name: string;      DataType: TFieldType; Size: Integer; Required: Boolean; FieldNo: Integer); reintroduce; overload;',
       @TFieldDef.Create);
  RegisterMethod(TFieldDef,
       'destructor Destroy; override;',
       @TFieldDef.Destroy);
  RegisterMethod(TFieldDef,
       'function AddChild: TFieldDef;',
       @TFieldDef.AddChild);
  RegisterMethod(TFieldDef,
       'procedure Assign(Source: TPersistent); override;',
       @TFieldDef.Assign);
  RegisterMethod(TFieldDef,
       'function HasChildDefs: Boolean;',
       @TFieldDef.HasChildDefs);
  RegisterMethod(TFieldDef,
       'function TFieldDef_ReadFieldClass:TFieldClass;',
       @TFieldDef_ReadFieldClass, Fake);
  RegisterProperty(TFieldDef,
       'property FieldClass:TFieldClass read TFieldDef_ReadFieldClass;');
  RegisterMethod(TFieldDef,
       'function TFieldDef_ReadFieldNo:Integer;',
       @TFieldDef_ReadFieldNo, Fake);
  RegisterMethod(TFieldDef,
       'procedure TFieldDef_WriteFieldNo(const Value: Integer);',
       @TFieldDef_WriteFieldNo, Fake);
  RegisterProperty(TFieldDef,
       'property FieldNo:Integer read TFieldDef_ReadFieldNo write TFieldDef_WriteFieldNo;');
  RegisterMethod(TFieldDef,
       'function TFieldDef_ReadInternalCalcField:Boolean;',
       @TFieldDef_ReadInternalCalcField, Fake);
  RegisterMethod(TFieldDef,
       'procedure TFieldDef_WriteInternalCalcField(const Value: Boolean);',
       @TFieldDef_WriteInternalCalcField, Fake);
  RegisterProperty(TFieldDef,
       'property InternalCalcField:Boolean read TFieldDef_ReadInternalCalcField write TFieldDef_WriteInternalCalcField;');
  RegisterMethod(TFieldDef,
       'function TFieldDef_ReadParentDef:TFieldDef;',
       @TFieldDef_ReadParentDef, Fake);
  RegisterProperty(TFieldDef,
       'property ParentDef:TFieldDef read TFieldDef_ReadParentDef;');
  RegisterMethod(TFieldDef,
       'function TFieldDef_ReadRequired:Boolean;',
       @TFieldDef_ReadRequired, Fake);
  RegisterMethod(TFieldDef,
       'procedure TFieldDef_WriteRequired(const Value: Boolean);',
       @TFieldDef_WriteRequired, Fake);
  RegisterProperty(TFieldDef,
       'property Required:Boolean read TFieldDef_ReadRequired write TFieldDef_WriteRequired;');
  // End of class TFieldDef
  // Begin of class TFieldDefs
  RegisterClassType(TFieldDefs, H);
  RegisterMethod(TFieldDefs,
       'constructor Create(AOwner: TPersistent);',
       @TFieldDefs.Create);
  RegisterMethod(TFieldDefs,
       'function AddFieldDef: TFieldDef;',
       @TFieldDefs.AddFieldDef);
  RegisterMethod(TFieldDefs,
       'function Find(const Name: string): TFieldDef;',
       @TFieldDefs.Find);
  RegisterMethod(TFieldDefs,
       'procedure Update; reintroduce;',
       @TFieldDefs.Update);
  RegisterMethod(TFieldDefs,
       'function TFieldDefs_ReadHiddenFields:Boolean;',
       @TFieldDefs_ReadHiddenFields, Fake);
  RegisterMethod(TFieldDefs,
       'procedure TFieldDefs_WriteHiddenFields(const Value: Boolean);',
       @TFieldDefs_WriteHiddenFields, Fake);
  RegisterProperty(TFieldDefs,
       'property HiddenFields:Boolean read TFieldDefs_ReadHiddenFields write TFieldDefs_WriteHiddenFields;');
  RegisterMethod(TFieldDefs,
       'function TFieldDefs_ReadItems(Index: Integer):TFieldDef;',
       @TFieldDefs_ReadItems, Fake);
  RegisterMethod(TFieldDefs,
       'procedure TFieldDefs_WriteItems(Index: Integer;const Value: TFieldDef);',
       @TFieldDefs_WriteItems, Fake);
  RegisterProperty(TFieldDefs,
       'property Items[Index: Integer]:TFieldDef read TFieldDefs_ReadItems write TFieldDefs_WriteItems;default;');
  RegisterMethod(TFieldDefs,
       'function TFieldDefs_ReadParentDef:TFieldDef;',
       @TFieldDefs_ReadParentDef, Fake);
  RegisterProperty(TFieldDefs,
       'property ParentDef:TFieldDef read TFieldDefs_ReadParentDef;');
  // End of class TFieldDefs
  RegisterRTTIType(TypeInfo(TIndexOption));
  // Begin of class TIndexDef
  RegisterClassType(TIndexDef, H);
  RegisterMethod(TIndexDef,
       'constructor Create(Owner: TIndexDefs; const Name, Fields: string;      Options: TIndexOptions); reintroduce; overload;',
       @TIndexDef.Create);
  RegisterMethod(TIndexDef,
       'procedure Assign(ASource: TPersistent); override;',
       @TIndexDef.Assign);
  RegisterMethod(TIndexDef,
       'function TIndexDef_ReadFieldExpression:String;',
       @TIndexDef_ReadFieldExpression, Fake);
  RegisterProperty(TIndexDef,
       'property FieldExpression:String read TIndexDef_ReadFieldExpression;');
  // End of class TIndexDef
  // Begin of class TIndexDefs
  RegisterClassType(TIndexDefs, H);
  RegisterMethod(TIndexDefs,
       'constructor Create(ADataSet: TDataSet);',
       @TIndexDefs.Create);
  RegisterMethod(TIndexDefs,
       'function AddIndexDef: TIndexDef;',
       @TIndexDefs.AddIndexDef);
  RegisterMethod(TIndexDefs,
       'function Find(const Name: string): TIndexDef;',
       @TIndexDefs.Find);
  RegisterMethod(TIndexDefs,
       'procedure Update; reintroduce;',
       @TIndexDefs.Update);
  RegisterMethod(TIndexDefs,
       'function FindIndexForFields(const Fields: string): TIndexDef;',
       @TIndexDefs.FindIndexForFields);
  RegisterMethod(TIndexDefs,
       'function GetIndexForFields(const Fields: string;      CaseInsensitive: Boolean): TIndexDef;',
       @TIndexDefs.GetIndexForFields);
  RegisterMethod(TIndexDefs,
       'procedure Add(const Name, Fields: string; Options: TIndexOptions);',
       @TIndexDefs.Add);
  RegisterMethod(TIndexDefs,
       'function TIndexDefs_ReadItems(Index: Integer):TIndexDef;',
       @TIndexDefs_ReadItems, Fake);
  RegisterMethod(TIndexDefs,
       'procedure TIndexDefs_WriteItems(Index: Integer;const Value: TIndexDef);',
       @TIndexDefs_WriteItems, Fake);
  RegisterProperty(TIndexDefs,
       'property Items[Index: Integer]:TIndexDef read TIndexDefs_ReadItems write TIndexDefs_WriteItems;default;');
  // End of class TIndexDefs
  // Begin of class TFlatList
  RegisterClassType(TFlatList, H);
  RegisterMethod(TFlatList,
       'constructor Create(ADataSet: TDataSet);',
       @TFlatList.Create);
  RegisterMethod(TFlatList,
       'procedure Update;',
       @TFlatList.Update);
  RegisterMethod(TFlatList,
       'function TFlatList_ReadDataSet:TDataSet;',
       @TFlatList_ReadDataSet, Fake);
  RegisterProperty(TFlatList,
       'property DataSet:TDataSet read TFlatList_ReadDataSet;');
  // End of class TFlatList
  // Begin of class TFieldDefList
  RegisterClassType(TFieldDefList, H);
  RegisterMethod(TFieldDefList,
       'function FieldByName(const Name: string): TFieldDef;',
       @TFieldDefList.FieldByName);
  RegisterMethod(TFieldDefList,
       'function Find(const Name: string): TFieldDef; reintroduce;',
       @TFieldDefList.Find);
  RegisterMethod(TFieldDefList,
       'function TFieldDefList_ReadFieldDefs(Index: Integer):TFieldDef;',
       @TFieldDefList_ReadFieldDefs, Fake);
  RegisterProperty(TFieldDefList,
       'property FieldDefs[Index: Integer]:TFieldDef read TFieldDefList_ReadFieldDefs;default;');
  RegisterMethod(TFieldDefList,
       'constructor Create(ADataSet: TDataSet);',
       @TFieldDefList.Create);
  // End of class TFieldDefList
  // Begin of class TFieldList
  RegisterClassType(TFieldList, H);
  RegisterMethod(TFieldList,
       'function FieldByName(const Name: string): TField;',
       @TFieldList.FieldByName);
  RegisterMethod(TFieldList,
       'function Find(const Name: string): TField; reintroduce;',
       @TFieldList.Find);
  RegisterMethod(TFieldList,
       'function TFieldList_ReadFields(Index: Integer):TField;',
       @TFieldList_ReadFields, Fake);
  RegisterProperty(TFieldList,
       'property Fields[Index: Integer]:TField read TFieldList_ReadFields;default;');
  RegisterMethod(TFieldList,
       'constructor Create(ADataSet: TDataSet);',
       @TFieldList.Create);
  // End of class TFieldList
  RegisterRTTIType(TypeInfo(TFieldKind));
  // Begin of class TFields
  RegisterClassType(TFields, H);
  RegisterMethod(TFields,
       'constructor Create(ADataSet: TDataSet);',
       @TFields.Create);
  RegisterMethod(TFields,
       'destructor Destroy; override;',
       @TFields.Destroy);
  RegisterMethod(TFields,
       'procedure Add(Field: TField);',
       @TFields.Add);
  RegisterMethod(TFields,
       'procedure CheckFieldName(const FieldName: string);',
       @TFields.CheckFieldName);
  RegisterMethod(TFields,
       'procedure CheckFieldNames(const FieldNames: string);',
       @TFields.CheckFieldNames);
  RegisterMethod(TFields,
       'procedure Clear;',
       @TFields.Clear);
  RegisterMethod(TFields,
       'function FindField(const FieldName: string): TField;',
       @TFields.FindField);
  RegisterMethod(TFields,
       'function FieldByName(const FieldName: string): TField;',
       @TFields.FieldByName);
  RegisterMethod(TFields,
       'function FieldByNumber(FieldNo: Integer): TField;',
       @TFields.FieldByNumber);
  RegisterMethod(TFields,
       'procedure GetFieldNames(List: TStrings);',
       @TFields.GetFieldNames);
  RegisterMethod(TFields,
       'function IndexOf(Field: TField): Integer;',
       @TFields.IndexOf);
  RegisterMethod(TFields,
       'procedure Remove(Field: TField);',
       @TFields.Remove);
  RegisterMethod(TFields,
       'function TFields_ReadCount:Integer;',
       @TFields_ReadCount, Fake);
  RegisterProperty(TFields,
       'property Count:Integer read TFields_ReadCount;');
  RegisterMethod(TFields,
       'function TFields_ReadDataSet:TDataSet;',
       @TFields_ReadDataSet, Fake);
  RegisterProperty(TFields,
       'property DataSet:TDataSet read TFields_ReadDataSet;');
  RegisterMethod(TFields,
       'function TFields_ReadFields(Index: Integer):TField;',
       @TFields_ReadFields, Fake);
  RegisterMethod(TFields,
       'procedure TFields_WriteFields(Index: Integer;const Value: TField);',
       @TFields_WriteFields, Fake);
  RegisterProperty(TFields,
       'property Fields[Index: Integer]:TField read TFields_ReadFields write TFields_WriteFields;default;');
  // End of class TFields
  RegisterRTTIType(TypeInfo(TProviderFlag));
  RegisterRTTIType(TypeInfo(TAutoRefreshFlag));
  // Begin of class TLookupList
  RegisterClassType(TLookupList, H);
  RegisterMethod(TLookupList,
       'constructor Create;',
       @TLookupList.Create);
  RegisterMethod(TLookupList,
       'destructor Destroy; override;',
       @TLookupList.Destroy);
  RegisterMethod(TLookupList,
       'procedure Add(const AKey, AValue: Variant);',
       @TLookupList.Add);
  RegisterMethod(TLookupList,
       'procedure Clear;',
       @TLookupList.Clear);
  RegisterMethod(TLookupList,
       'function ValueOfKey(const AKey: Variant): Variant;',
       @TLookupList.ValueOfKey);
  // End of class TLookupList
  // Begin of class TField
  RegisterClassType(TField, H);
  RegisterMethod(TField,
       'constructor Create(AOwner: TComponent); override;',
       @TField.Create);
  RegisterMethod(TField,
       'destructor Destroy; override;',
       @TField.Destroy);
  RegisterMethod(TField,
       'procedure Assign(Source: TPersistent); override;',
       @TField.Assign);
  RegisterMethod(TField,
       'procedure AssignValue(const Value: TVarRec);',
       @TField.AssignValue);
  RegisterMethod(TField,
       'procedure Clear; virtual;',
       @TField.Clear);
  RegisterMethod(TField,
       'procedure FocusControl;',
       @TField.FocusControl);
  RegisterMethod(TField,
       'function GetParentComponent: TComponent; override;',
       @TField.GetParentComponent);
  RegisterMethod(TField,
       'function HasParent: Boolean; override;',
       @TField.HasParent);
  RegisterMethod(TField,
       'function IsBlob: Boolean; virtual;',
       @TField.IsBlob);
  RegisterMethod(TField,
       'function IsValidChar(InputChar: Char): Boolean; virtual;',
       @TField.IsValidChar);
  RegisterMethod(TField,
       'procedure RefreshLookupList;',
       @TField.RefreshLookupList);
  RegisterMethod(TField,
       'procedure SetFieldType(Value: TFieldType); virtual;',
       @TField.SetFieldType);
  RegisterMethod(TField,
       'procedure Validate(Buffer: Pointer);',
       @TField.Validate);
  RegisterMethod(TField,
       'function TField_ReadAsBCD:TBcd;',
       @TField_ReadAsBCD, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteAsBCD(const Value: TBcd);',
       @TField_WriteAsBCD, Fake);
  RegisterProperty(TField,
       'property AsBCD:TBcd read TField_ReadAsBCD write TField_WriteAsBCD;');
  RegisterMethod(TField,
       'function TField_ReadAsBoolean:Boolean;',
       @TField_ReadAsBoolean, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteAsBoolean(const Value: Boolean);',
       @TField_WriteAsBoolean, Fake);
  RegisterProperty(TField,
       'property AsBoolean:Boolean read TField_ReadAsBoolean write TField_WriteAsBoolean;');
  RegisterMethod(TField,
       'function TField_ReadAsCurrency:Currency;',
       @TField_ReadAsCurrency, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteAsCurrency(const Value: Currency);',
       @TField_WriteAsCurrency, Fake);
  RegisterProperty(TField,
       'property AsCurrency:Currency read TField_ReadAsCurrency write TField_WriteAsCurrency;');
  RegisterMethod(TField,
       'function TField_ReadAsDateTime:TDateTime;',
       @TField_ReadAsDateTime, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteAsDateTime(const Value: TDateTime);',
       @TField_WriteAsDateTime, Fake);
  RegisterProperty(TField,
       'property AsDateTime:TDateTime read TField_ReadAsDateTime write TField_WriteAsDateTime;');
  RegisterMethod(TField,
       'function TField_ReadAsSQLTimeStamp:TSQLTimeStamp;',
       @TField_ReadAsSQLTimeStamp, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteAsSQLTimeStamp(const Value: TSQLTimeStamp);',
       @TField_WriteAsSQLTimeStamp, Fake);
  RegisterProperty(TField,
       'property AsSQLTimeStamp:TSQLTimeStamp read TField_ReadAsSQLTimeStamp write TField_WriteAsSQLTimeStamp;');
  RegisterMethod(TField,
       'function TField_ReadAsFloat:Double;',
       @TField_ReadAsFloat, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteAsFloat(const Value: Double);',
       @TField_WriteAsFloat, Fake);
  RegisterProperty(TField,
       'property AsFloat:Double read TField_ReadAsFloat write TField_WriteAsFloat;');
  RegisterMethod(TField,
       'function TField_ReadAsInteger:Longint;',
       @TField_ReadAsInteger, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteAsInteger(const Value: Longint);',
       @TField_WriteAsInteger, Fake);
  RegisterProperty(TField,
       'property AsInteger:Longint read TField_ReadAsInteger write TField_WriteAsInteger;');
  RegisterMethod(TField,
       'function TField_ReadAsString:String;',
       @TField_ReadAsString, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteAsString(const Value: String);',
       @TField_WriteAsString, Fake);
  RegisterProperty(TField,
       'property AsString:String read TField_ReadAsString write TField_WriteAsString;');
  RegisterMethod(TField,
       'function TField_ReadAsVariant:Variant;',
       @TField_ReadAsVariant, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteAsVariant(const Value: Variant);',
       @TField_WriteAsVariant, Fake);
  RegisterProperty(TField,
       'property AsVariant:Variant read TField_ReadAsVariant write TField_WriteAsVariant;');
  RegisterMethod(TField,
       'function TField_ReadAttributeSet:String;',
       @TField_ReadAttributeSet, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteAttributeSet(const Value: String);',
       @TField_WriteAttributeSet, Fake);
  RegisterProperty(TField,
       'property AttributeSet:String read TField_ReadAttributeSet write TField_WriteAttributeSet;');
  RegisterMethod(TField,
       'function TField_ReadCalculated:Boolean;',
       @TField_ReadCalculated, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteCalculated(const Value: Boolean);',
       @TField_WriteCalculated, Fake);
  RegisterProperty(TField,
       'property Calculated:Boolean read TField_ReadCalculated write TField_WriteCalculated;');
  RegisterMethod(TField,
       'function TField_ReadCanModify:Boolean;',
       @TField_ReadCanModify, Fake);
  RegisterProperty(TField,
       'property CanModify:Boolean read TField_ReadCanModify;');
  RegisterMethod(TField,
       'function TField_ReadCurValue:Variant;',
       @TField_ReadCurValue, Fake);
  RegisterProperty(TField,
       'property CurValue:Variant read TField_ReadCurValue;');
  RegisterMethod(TField,
       'function TField_ReadDataSet:TDataSet;',
       @TField_ReadDataSet, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteDataSet(const Value: TDataSet);',
       @TField_WriteDataSet, Fake);
  RegisterProperty(TField,
       'property DataSet:TDataSet read TField_ReadDataSet write TField_WriteDataSet;');
  RegisterMethod(TField,
       'function TField_ReadDataSize:Integer;',
       @TField_ReadDataSize, Fake);
  RegisterProperty(TField,
       'property DataSize:Integer read TField_ReadDataSize;');
  RegisterMethod(TField,
       'function TField_ReadDataType:TFieldType;',
       @TField_ReadDataType, Fake);
  RegisterProperty(TField,
       'property DataType:TFieldType read TField_ReadDataType;');
  RegisterMethod(TField,
       'function TField_ReadDisplayName:String;',
       @TField_ReadDisplayName, Fake);
  RegisterProperty(TField,
       'property DisplayName:String read TField_ReadDisplayName;');
  RegisterMethod(TField,
       'function TField_ReadDisplayText:String;',
       @TField_ReadDisplayText, Fake);
  RegisterProperty(TField,
       'property DisplayText:String read TField_ReadDisplayText;');
  RegisterMethod(TField,
       'function TField_ReadEditMask:TEditMask;',
       @TField_ReadEditMask, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteEditMask(const Value: TEditMask);',
       @TField_WriteEditMask, Fake);
  RegisterProperty(TField,
       'property EditMask:TEditMask read TField_ReadEditMask write TField_WriteEditMask;');
  RegisterMethod(TField,
       'function TField_ReadEditMaskPtr:TEditMask;',
       @TField_ReadEditMaskPtr, Fake);
  RegisterProperty(TField,
       'property EditMaskPtr:TEditMask read TField_ReadEditMaskPtr;');
  RegisterMethod(TField,
       'function TField_ReadFieldNo:Integer;',
       @TField_ReadFieldNo, Fake);
  RegisterProperty(TField,
       'property FieldNo:Integer read TField_ReadFieldNo;');
  RegisterMethod(TField,
       'function TField_ReadFullName:String;',
       @TField_ReadFullName, Fake);
  RegisterProperty(TField,
       'property FullName:String read TField_ReadFullName;');
  RegisterMethod(TField,
       'function TField_ReadIsIndexField:Boolean;',
       @TField_ReadIsIndexField, Fake);
  RegisterProperty(TField,
       'property IsIndexField:Boolean read TField_ReadIsIndexField;');
  RegisterMethod(TField,
       'function TField_ReadIsNull:Boolean;',
       @TField_ReadIsNull, Fake);
  RegisterProperty(TField,
       'property IsNull:Boolean read TField_ReadIsNull;');
  RegisterMethod(TField,
       'function TField_ReadLookup:Boolean;',
       @TField_ReadLookup, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteLookup(const Value: Boolean);',
       @TField_WriteLookup, Fake);
  RegisterProperty(TField,
       'property Lookup:Boolean read TField_ReadLookup write TField_WriteLookup;');
  RegisterMethod(TField,
       'function TField_ReadLookupList:TLookupList;',
       @TField_ReadLookupList, Fake);
  RegisterProperty(TField,
       'property LookupList:TLookupList read TField_ReadLookupList;');
  RegisterMethod(TField,
       'function TField_ReadNewValue:Variant;',
       @TField_ReadNewValue, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteNewValue(const Value: Variant);',
       @TField_WriteNewValue, Fake);
  RegisterProperty(TField,
       'property NewValue:Variant read TField_ReadNewValue write TField_WriteNewValue;');
  RegisterMethod(TField,
       'function TField_ReadOffset:Integer;',
       @TField_ReadOffset, Fake);
  RegisterProperty(TField,
       'property Offset:Integer read TField_ReadOffset;');
  RegisterMethod(TField,
       'function TField_ReadOldValue:Variant;',
       @TField_ReadOldValue, Fake);
  RegisterProperty(TField,
       'property OldValue:Variant read TField_ReadOldValue;');
  RegisterMethod(TField,
       'function TField_ReadParentField:TObjectField;',
       @TField_ReadParentField, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteParentField(const Value: TObjectField);',
       @TField_WriteParentField, Fake);
  RegisterProperty(TField,
       'property ParentField:TObjectField read TField_ReadParentField write TField_WriteParentField;');
  RegisterMethod(TField,
       'function TField_ReadSize:Integer;',
       @TField_ReadSize, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteSize(const Value: Integer);',
       @TField_WriteSize, Fake);
  RegisterProperty(TField,
       'property Size:Integer read TField_ReadSize write TField_WriteSize;');
  RegisterMethod(TField,
       'function TField_ReadText:String;',
       @TField_ReadText, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteText(const Value: String);',
       @TField_WriteText, Fake);
  RegisterProperty(TField,
       'property Text:String read TField_ReadText write TField_WriteText;');
  RegisterMethod(TField,
       'function TField_ReadValidChars:TFieldChars;',
       @TField_ReadValidChars, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteValidChars(const Value: TFieldChars);',
       @TField_WriteValidChars, Fake);
  RegisterProperty(TField,
       'property ValidChars:TFieldChars read TField_ReadValidChars write TField_WriteValidChars;');
  RegisterMethod(TField,
       'function TField_ReadValue:Variant;',
       @TField_ReadValue, Fake);
  RegisterMethod(TField,
       'procedure TField_WriteValue(const Value: Variant);',
       @TField_WriteValue, Fake);
  RegisterProperty(TField,
       'property Value:Variant read TField_ReadValue write TField_WriteValue;');
  // End of class TField
  // Begin of class TStringField
  RegisterClassType(TStringField, H);
  RegisterMethod(TStringField,
       'constructor Create(AOwner: TComponent); override;',
       @TStringField.Create);
  RegisterMethod(TStringField,
       'function TStringField_ReadValue:String;',
       @TStringField_ReadValue, Fake);
  RegisterMethod(TStringField,
       'procedure TStringField_WriteValue(const Value: String);',
       @TStringField_WriteValue, Fake);
  RegisterProperty(TStringField,
       'property Value:String read TStringField_ReadValue write TStringField_WriteValue;');
  // End of class TStringField
  // Begin of class TWideStringField
  RegisterClassType(TWideStringField, H);
  RegisterMethod(TWideStringField,
       'constructor Create(AOwner: TComponent); override;',
       @TWideStringField.Create);
  RegisterMethod(TWideStringField,
       'function TWideStringField_ReadValue:WideString;',
       @TWideStringField_ReadValue, Fake);
  RegisterMethod(TWideStringField,
       'procedure TWideStringField_WriteValue(const Value: WideString);',
       @TWideStringField_WriteValue, Fake);
  RegisterProperty(TWideStringField,
       'property Value:WideString read TWideStringField_ReadValue write TWideStringField_WriteValue;');
  // End of class TWideStringField
  // Begin of class TNumericField
  RegisterClassType(TNumericField, H);
  RegisterMethod(TNumericField,
       'constructor Create(AOwner: TComponent); override;',
       @TNumericField.Create);
  // End of class TNumericField
  // Begin of class TIntegerField
  RegisterClassType(TIntegerField, H);
  RegisterMethod(TIntegerField,
       'constructor Create(AOwner: TComponent); override;',
       @TIntegerField.Create);
  RegisterMethod(TIntegerField,
       'function TIntegerField_ReadValue:Longint;',
       @TIntegerField_ReadValue, Fake);
  RegisterMethod(TIntegerField,
       'procedure TIntegerField_WriteValue(const Value: Longint);',
       @TIntegerField_WriteValue, Fake);
  RegisterProperty(TIntegerField,
       'property Value:Longint read TIntegerField_ReadValue write TIntegerField_WriteValue;');
  // End of class TIntegerField
  // Begin of class TSmallintField
  RegisterClassType(TSmallintField, H);
  RegisterMethod(TSmallintField,
       'constructor Create(AOwner: TComponent); override;',
       @TSmallintField.Create);
  // End of class TSmallintField
  // Begin of class TLargeintField
  RegisterClassType(TLargeintField, H);
  RegisterMethod(TLargeintField,
       'constructor Create(AOwner: TComponent); override;',
       @TLargeintField.Create);
  RegisterMethod(TLargeintField,
       'function TLargeintField_ReadAsLargeInt:LargeInt;',
       @TLargeintField_ReadAsLargeInt, Fake);
  RegisterMethod(TLargeintField,
       'procedure TLargeintField_WriteAsLargeInt(const Value: LargeInt);',
       @TLargeintField_WriteAsLargeInt, Fake);
  RegisterProperty(TLargeintField,
       'property AsLargeInt:LargeInt read TLargeintField_ReadAsLargeInt write TLargeintField_WriteAsLargeInt;');
  RegisterMethod(TLargeintField,
       'function TLargeintField_ReadValue:Largeint;',
       @TLargeintField_ReadValue, Fake);
  RegisterMethod(TLargeintField,
       'procedure TLargeintField_WriteValue(const Value: Largeint);',
       @TLargeintField_WriteValue, Fake);
  RegisterProperty(TLargeintField,
       'property Value:Largeint read TLargeintField_ReadValue write TLargeintField_WriteValue;');
  // End of class TLargeintField
  // Begin of class TWordField
  RegisterClassType(TWordField, H);
  RegisterMethod(TWordField,
       'constructor Create(AOwner: TComponent); override;',
       @TWordField.Create);
  // End of class TWordField
  // Begin of class TAutoIncField
  RegisterClassType(TAutoIncField, H);
  RegisterMethod(TAutoIncField,
       'constructor Create(AOwner: TComponent); override;',
       @TAutoIncField.Create);
  // End of class TAutoIncField
  // Begin of class TFloatField
  RegisterClassType(TFloatField, H);
  RegisterMethod(TFloatField,
       'constructor Create(AOwner: TComponent); override;',
       @TFloatField.Create);
  RegisterMethod(TFloatField,
       'function TFloatField_ReadValue:Double;',
       @TFloatField_ReadValue, Fake);
  RegisterMethod(TFloatField,
       'procedure TFloatField_WriteValue(const Value: Double);',
       @TFloatField_WriteValue, Fake);
  RegisterProperty(TFloatField,
       'property Value:Double read TFloatField_ReadValue write TFloatField_WriteValue;');
  // End of class TFloatField
  // Begin of class TCurrencyField
  RegisterClassType(TCurrencyField, H);
  RegisterMethod(TCurrencyField,
       'constructor Create(AOwner: TComponent); override;',
       @TCurrencyField.Create);
  // End of class TCurrencyField
  // Begin of class TBooleanField
  RegisterClassType(TBooleanField, H);
  RegisterMethod(TBooleanField,
       'constructor Create(AOwner: TComponent); override;',
       @TBooleanField.Create);
  RegisterMethod(TBooleanField,
       'function TBooleanField_ReadValue:Boolean;',
       @TBooleanField_ReadValue, Fake);
  RegisterMethod(TBooleanField,
       'procedure TBooleanField_WriteValue(const Value: Boolean);',
       @TBooleanField_WriteValue, Fake);
  RegisterProperty(TBooleanField,
       'property Value:Boolean read TBooleanField_ReadValue write TBooleanField_WriteValue;');
  // End of class TBooleanField
  // Begin of class TDateTimeField
  RegisterClassType(TDateTimeField, H);
  RegisterMethod(TDateTimeField,
       'constructor Create(AOwner: TComponent); override;',
       @TDateTimeField.Create);
  RegisterMethod(TDateTimeField,
       'function TDateTimeField_ReadValue:TDateTime;',
       @TDateTimeField_ReadValue, Fake);
  RegisterMethod(TDateTimeField,
       'procedure TDateTimeField_WriteValue(const Value: TDateTime);',
       @TDateTimeField_WriteValue, Fake);
  RegisterProperty(TDateTimeField,
       'property Value:TDateTime read TDateTimeField_ReadValue write TDateTimeField_WriteValue;');
  // End of class TDateTimeField
  // Begin of class TSQLTimeStampField
  RegisterClassType(TSQLTimeStampField, H);
  RegisterMethod(TSQLTimeStampField,
       'constructor Create(AOwner: TComponent); override;',
       @TSQLTimeStampField.Create);
  RegisterMethod(TSQLTimeStampField,
       'function TSQLTimeStampField_ReadValue:TSQLTimeStamp;',
       @TSQLTimeStampField_ReadValue, Fake);
  RegisterMethod(TSQLTimeStampField,
       'procedure TSQLTimeStampField_WriteValue(const Value: TSQLTimeStamp);',
       @TSQLTimeStampField_WriteValue, Fake);
  RegisterProperty(TSQLTimeStampField,
       'property Value:TSQLTimeStamp read TSQLTimeStampField_ReadValue write TSQLTimeStampField_WriteValue;');
  // End of class TSQLTimeStampField
  // Begin of class TDateField
  RegisterClassType(TDateField, H);
  RegisterMethod(TDateField,
       'constructor Create(AOwner: TComponent); override;',
       @TDateField.Create);
  // End of class TDateField
  // Begin of class TTimeField
  RegisterClassType(TTimeField, H);
  RegisterMethod(TTimeField,
       'constructor Create(AOwner: TComponent); override;',
       @TTimeField.Create);
  // End of class TTimeField
  // Begin of class TBinaryField
  RegisterClassType(TBinaryField, H);
  RegisterMethod(TBinaryField,
       'constructor Create(AOwner: TComponent); override;',
       @TBinaryField.Create);
  // End of class TBinaryField
  // Begin of class TBytesField
  RegisterClassType(TBytesField, H);
  RegisterMethod(TBytesField,
       'constructor Create(AOwner: TComponent); override;',
       @TBytesField.Create);
  // End of class TBytesField
  // Begin of class TVarBytesField
  RegisterClassType(TVarBytesField, H);
  RegisterMethod(TVarBytesField,
       'constructor Create(AOwner: TComponent); override;',
       @TVarBytesField.Create);
  // End of class TVarBytesField
  // Begin of class TBCDField
  RegisterClassType(TBCDField, H);
  RegisterMethod(TBCDField,
       'constructor Create(AOwner: TComponent); override;',
       @TBCDField.Create);
  RegisterMethod(TBCDField,
       'function TBCDField_ReadValue:Currency;',
       @TBCDField_ReadValue, Fake);
  RegisterMethod(TBCDField,
       'procedure TBCDField_WriteValue(const Value: Currency);',
       @TBCDField_WriteValue, Fake);
  RegisterProperty(TBCDField,
       'property Value:Currency read TBCDField_ReadValue write TBCDField_WriteValue;');
  // End of class TBCDField
  // Begin of class TFMTBCDField
  RegisterClassType(TFMTBCDField, H);
  RegisterMethod(TFMTBCDField,
       'constructor Create(AOwner: TComponent); override;',

       @TFMTBCDField.Create);
  RegisterMethod(TFMTBCDField,
       'function TFMTBCDField_ReadValue:TBcd;',
       @TFMTBCDField_ReadValue, Fake);
  RegisterMethod(TFMTBCDField,
       'procedure TFMTBCDField_WriteValue(const Value: TBcd);',
       @TFMTBCDField_WriteValue, Fake);
  RegisterProperty(TFMTBCDField,
       'property Value:TBcd read TFMTBCDField_ReadValue write TFMTBCDField_WriteValue;');
  // End of class TFMTBCDField
  // Begin of class TBlobField
  RegisterClassType(TBlobField, H);
  RegisterMethod(TBlobField,
       'constructor Create(AOwner: TComponent); override;',
       @TBlobField.Create);
  RegisterMethod(TBlobField,
       'procedure Assign(Source: TPersistent); override;',
       @TBlobField.Assign);
  RegisterMethod(TBlobField,
       'procedure Clear; override;',
       @TBlobField.Clear);
  RegisterMethod(TBlobField,
       'function IsBlob: Boolean; override;',
       @TBlobField.IsBlob);
  RegisterMethod(TBlobField,
       'procedure LoadFromFile(const FileName: string);',
       @TBlobField.LoadFromFile);
  RegisterMethod(TBlobField,
       'procedure LoadFromStream(Stream: TStream);',
       @TBlobField.LoadFromStream);
  RegisterMethod(TBlobField,
       'procedure SaveToFile(const FileName: string);',
       @TBlobField.SaveToFile);
  RegisterMethod(TBlobField,
       'procedure SaveToStream(Stream: TStream);',
       @TBlobField.SaveToStream);
  RegisterMethod(TBlobField,
       'procedure SetFieldType(Value: TFieldType); override;',
       @TBlobField.SetFieldType);
  RegisterMethod(TBlobField,
       'function TBlobField_ReadBlobSize:Integer;',
       @TBlobField_ReadBlobSize, Fake);
  RegisterProperty(TBlobField,
       'property BlobSize:Integer read TBlobField_ReadBlobSize;');
  RegisterMethod(TBlobField,
       'function TBlobField_ReadModified:Boolean;',
       @TBlobField_ReadModified, Fake);
  RegisterMethod(TBlobField,
       'procedure TBlobField_WriteModified(const Value: Boolean);',
       @TBlobField_WriteModified, Fake);
  RegisterProperty(TBlobField,
       'property Modified:Boolean read TBlobField_ReadModified write TBlobField_WriteModified;');
  RegisterMethod(TBlobField,
       'function TBlobField_ReadValue:String;',
       @TBlobField_ReadValue, Fake);
  RegisterMethod(TBlobField,
       'procedure TBlobField_WriteValue(const Value: String);',
       @TBlobField_WriteValue, Fake);
  RegisterProperty(TBlobField,
       'property Value:String read TBlobField_ReadValue write TBlobField_WriteValue;');
  RegisterMethod(TBlobField,
       'function TBlobField_ReadTransliterate:Boolean;',
       @TBlobField_ReadTransliterate, Fake);
  RegisterMethod(TBlobField,
       'procedure TBlobField_WriteTransliterate(const Value: Boolean);',
       @TBlobField_WriteTransliterate, Fake);
  RegisterProperty(TBlobField,
       'property Transliterate:Boolean read TBlobField_ReadTransliterate write TBlobField_WriteTransliterate;');
  // End of class TBlobField
  // Begin of class TMemoField
  RegisterClassType(TMemoField, H);
  RegisterMethod(TMemoField,
       'constructor Create(AOwner: TComponent); override;',
       @TMemoField.Create);
  // End of class TMemoField
  // Begin of class TGraphicField
  RegisterClassType(TGraphicField, H);
  RegisterMethod(TGraphicField,
       'constructor Create(AOwner: TComponent); override;',
       @TGraphicField.Create);
  // End of class TGraphicField
  // Begin of class TObjectField
  RegisterClassType(TObjectField, H);
  RegisterMethod(TObjectField,
       'constructor Create(AOwner: TComponent); override;',
       @TObjectField.Create);
  RegisterMethod(TObjectField,
       'destructor Destroy; override;',
       @TObjectField.Destroy);
  RegisterMethod(TObjectField,
       'function TObjectField_ReadFieldCount:Integer;',
       @TObjectField_ReadFieldCount, Fake);
  RegisterProperty(TObjectField,
       'property FieldCount:Integer read TObjectField_ReadFieldCount;');
  RegisterMethod(TObjectField,
       'function TObjectField_ReadFields:TFields;',
       @TObjectField_ReadFields, Fake);
  RegisterProperty(TObjectField,
       'property Fields:TFields read TObjectField_ReadFields;');
  RegisterMethod(TObjectField,
       'function TObjectField_ReadFieldValues(Index: Integer):Variant;',
       @TObjectField_ReadFieldValues, Fake);
  RegisterMethod(TObjectField,
       'procedure TObjectField_WriteFieldValues(Index: Integer;const Value: Variant);',
       @TObjectField_WriteFieldValues, Fake);
  RegisterProperty(TObjectField,
       'property FieldValues[Index: Integer]:Variant read TObjectField_ReadFieldValues write TObjectField_WriteFieldValues;default;');
  RegisterMethod(TObjectField,
       'function TObjectField_ReadUnNamed:Boolean;',
       @TObjectField_ReadUnNamed, Fake);
  RegisterProperty(TObjectField,
       'property UnNamed:Boolean read TObjectField_ReadUnNamed;');
  // End of class TObjectField
  // Begin of class TADTField
  RegisterClassType(TADTField, H);
  RegisterMethod(TADTField,
       'constructor Create(AOwner: TComponent); override;',
       @TADTField.Create);
  // End of class TADTField
  // Begin of class TArrayField
  RegisterClassType(TArrayField, H);
  RegisterMethod(TArrayField,
       'constructor Create(AOwner: TComponent); override;',
       @TArrayField.Create);
  // End of class TArrayField
  // Begin of class TDataSetField
  RegisterClassType(TDataSetField, H);
  RegisterMethod(TDataSetField,
       'constructor Create(AOwner: TComponent); override;',
       @TDataSetField.Create);
  RegisterMethod(TDataSetField,
       'destructor Destroy; override;',
       @TDataSetField.Destroy);
  RegisterMethod(TDataSetField,
       'function TDataSetField_ReadNestedDataSet:TDataSet;',
       @TDataSetField_ReadNestedDataSet, Fake);
  RegisterProperty(TDataSetField,
       'property NestedDataSet:TDataSet read TDataSetField_ReadNestedDataSet;');
  // End of class TDataSetField
  // Begin of class TReferenceField
  RegisterClassType(TReferenceField, H);
  RegisterMethod(TReferenceField,
       'constructor Create(AOwner: TComponent); override;',
       @TReferenceField.Create);
  RegisterMethod(TReferenceField,
       'procedure Assign(Source: TPersistent); override;',
       @TReferenceField.Assign);
  // End of class TReferenceField
  // Begin of class TVariantField
  RegisterClassType(TVariantField, H);
  RegisterMethod(TVariantField,
       'constructor Create(AOwner: TComponent); override;',
       @TVariantField.Create);
  // End of class TVariantField
  // Begin of class TInterfaceField
  RegisterClassType(TInterfaceField, H);
  RegisterMethod(TInterfaceField,
       'constructor Create(AOwner: TComponent); override;',
       @TInterfaceField.Create);
  RegisterMethod(TInterfaceField,
       'function TInterfaceField_ReadValue:IUnknown;',
       @TInterfaceField_ReadValue, Fake);
  RegisterMethod(TInterfaceField,
       'procedure TInterfaceField_WriteValue(const Value: IUnknown);',
       @TInterfaceField_WriteValue, Fake);
  RegisterProperty(TInterfaceField,
       'property Value:IUnknown read TInterfaceField_ReadValue write TInterfaceField_WriteValue;');
  // End of class TInterfaceField
  // Begin of class TIDispatchField
  RegisterClassType(TIDispatchField, H);
  RegisterMethod(TIDispatchField,
       'constructor Create(AOwner: TComponent); override;',
       @TIDispatchField.Create);
  RegisterMethod(TIDispatchField,
       'function TIDispatchField_ReadValue:IDispatch;',
       @TIDispatchField_ReadValue, Fake);
  RegisterMethod(TIDispatchField,
       'procedure TIDispatchField_WriteValue(const Value: IDispatch);',
       @TIDispatchField_WriteValue, Fake);
  RegisterProperty(TIDispatchField,
       'property Value:IDispatch read TIDispatchField_ReadValue write TIDispatchField_WriteValue;');
  // End of class TIDispatchField
  // Begin of class TGuidField
  RegisterClassType(TGuidField, H);
  RegisterMethod(TGuidField,
       'constructor Create(AOwner: TComponent); override;',
       @TGuidField.Create);
  RegisterMethod(TGuidField,
       'function TGuidField_ReadAsGuid:TGUID;',
       @TGuidField_ReadAsGuid, Fake);
  RegisterMethod(TGuidField,
       'procedure TGuidField_WriteAsGuid(const Value: TGUID);',
       @TGuidField_WriteAsGuid, Fake);
  RegisterProperty(TGuidField,
       'property AsGuid:TGUID read TGuidField_ReadAsGuid write TGuidField_WriteAsGuid;');
  // End of class TGuidField
  // Begin of class TAggregateField
  RegisterClassType(TAggregateField, H);
  RegisterMethod(TAggregateField,
       'constructor Create(AOwner: TComponent); override;',
       @TAggregateField.Create);
  RegisterMethod(TAggregateField,
       'function TAggregateField_ReadHandle:Pointer;',
       @TAggregateField_ReadHandle, Fake);
  RegisterMethod(TAggregateField,
       'procedure TAggregateField_WriteHandle(const Value: Pointer);',
       @TAggregateField_WriteHandle, Fake);
  RegisterProperty(TAggregateField,
       'property Handle:Pointer read TAggregateField_ReadHandle write TAggregateField_WriteHandle;');
  RegisterMethod(TAggregateField,
       'function TAggregateField_ReadResultType:TFieldType;',
       @TAggregateField_ReadResultType, Fake);
  RegisterMethod(TAggregateField,
       'procedure TAggregateField_WriteResultType(const Value: TFieldType);',
       @TAggregateField_WriteResultType, Fake);
  RegisterProperty(TAggregateField,
       'property ResultType:TFieldType read TAggregateField_ReadResultType write TAggregateField_WriteResultType;');
  // End of class TAggregateField
  // Begin of class TDataLink
  RegisterClassType(TDataLink, H);
  RegisterMethod(TDataLink,
       'constructor Create;',
       @TDataLink.Create);
  RegisterMethod(TDataLink,
       'destructor Destroy; override;',
       @TDataLink.Destroy);
  RegisterMethod(TDataLink,
       'function Edit: Boolean;',
       @TDataLink.Edit);
  RegisterMethod(TDataLink,
       'function ExecuteAction(Action: TBasicAction): Boolean; dynamic;',
       @TDataLink.ExecuteAction);
  RegisterMethod(TDataLink,
       'function UpdateAction(Action: TBasicAction): Boolean; dynamic;',
       @TDataLink.UpdateAction);
  RegisterMethod(TDataLink,
       'procedure UpdateRecord;',
       @TDataLink.UpdateRecord);
  RegisterMethod(TDataLink,
       'function TDataLink_ReadActive:Boolean;',
       @TDataLink_ReadActive, Fake);
  RegisterProperty(TDataLink,
       'property Active:Boolean read TDataLink_ReadActive;');
  RegisterMethod(TDataLink,
       'function TDataLink_ReadActiveRecord:Integer;',
       @TDataLink_ReadActiveRecord, Fake);
  RegisterMethod(TDataLink,
       'procedure TDataLink_WriteActiveRecord(const Value: Integer);',
       @TDataLink_WriteActiveRecord, Fake);
  RegisterProperty(TDataLink,
       'property ActiveRecord:Integer read TDataLink_ReadActiveRecord write TDataLink_WriteActiveRecord;');
  RegisterMethod(TDataLink,
       'function TDataLink_ReadBOF:Boolean;',
       @TDataLink_ReadBOF, Fake);
  RegisterProperty(TDataLink,
       'property BOF:Boolean read TDataLink_ReadBOF;');
  RegisterMethod(TDataLink,
       'function TDataLink_ReadBufferCount:Integer;',
       @TDataLink_ReadBufferCount, Fake);
  RegisterMethod(TDataLink,
       'procedure TDataLink_WriteBufferCount(const Value: Integer);',
       @TDataLink_WriteBufferCount, Fake);
  RegisterProperty(TDataLink,
       'property BufferCount:Integer read TDataLink_ReadBufferCount write TDataLink_WriteBufferCount;');
  RegisterMethod(TDataLink,
       'function TDataLink_ReadDataSet:TDataSet;',
       @TDataLink_ReadDataSet, Fake);
  RegisterProperty(TDataLink,
       'property DataSet:TDataSet read TDataLink_ReadDataSet;');
  RegisterMethod(TDataLink,
       'function TDataLink_ReadDataSource:TDataSource;',
       @TDataLink_ReadDataSource, Fake);
  RegisterMethod(TDataLink,
       'procedure TDataLink_WriteDataSource(const Value: TDataSource);',
       @TDataLink_WriteDataSource, Fake);
  RegisterProperty(TDataLink,
       'property DataSource:TDataSource read TDataLink_ReadDataSource write TDataLink_WriteDataSource;');
  RegisterMethod(TDataLink,
       'function TDataLink_ReadDataSourceFixed:Boolean;',
       @TDataLink_ReadDataSourceFixed, Fake);
  RegisterMethod(TDataLink,
       'procedure TDataLink_WriteDataSourceFixed(const Value: Boolean);',
       @TDataLink_WriteDataSourceFixed, Fake);
  RegisterProperty(TDataLink,
       'property DataSourceFixed:Boolean read TDataLink_ReadDataSourceFixed write TDataLink_WriteDataSourceFixed;');
  RegisterMethod(TDataLink,
       'function TDataLink_ReadEditing:Boolean;',
       @TDataLink_ReadEditing, Fake);
  RegisterProperty(TDataLink,
       'property Editing:Boolean read TDataLink_ReadEditing;');
  RegisterMethod(TDataLink,
       'function TDataLink_ReadEof:Boolean;',
       @TDataLink_ReadEof, Fake);
  RegisterProperty(TDataLink,
       'property Eof:Boolean read TDataLink_ReadEof;');
  RegisterMethod(TDataLink,
       'function TDataLink_ReadReadOnly:Boolean;',
       @TDataLink_ReadReadOnly, Fake);
  RegisterMethod(TDataLink,
       'procedure TDataLink_WriteReadOnly(const Value: Boolean);',
       @TDataLink_WriteReadOnly, Fake);
  RegisterProperty(TDataLink,
       'property ReadOnly:Boolean read TDataLink_ReadReadOnly write TDataLink_WriteReadOnly;');
  RegisterMethod(TDataLink,
       'function TDataLink_ReadRecordCount:Integer;',
       @TDataLink_ReadRecordCount, Fake);
  RegisterProperty(TDataLink,
       'property RecordCount:Integer read TDataLink_ReadRecordCount;');
  // End of class TDataLink
  // Begin of class TDetailDataLink
  RegisterClassType(TDetailDataLink, H);
  RegisterMethod(TDetailDataLink,
       'function TDetailDataLink_ReadDetailDataSet:TDataSet;',
       @TDetailDataLink_ReadDetailDataSet, Fake);
  RegisterProperty(TDetailDataLink,
       'property DetailDataSet:TDataSet read TDetailDataLink_ReadDetailDataSet;');
  RegisterMethod(TDetailDataLink,
       'constructor Create;',
       @TDetailDataLink.Create);
  // End of class TDetailDataLink
  // Begin of class TMasterDataLink
  RegisterClassType(TMasterDataLink, H);
  RegisterMethod(TMasterDataLink,
       'constructor Create(DataSet: TDataSet);',
       @TMasterDataLink.Create);
  RegisterMethod(TMasterDataLink,
       'destructor Destroy; override;',
       @TMasterDataLink.Destroy);
  RegisterMethod(TMasterDataLink,
       'function TMasterDataLink_ReadFieldNames:String;',
       @TMasterDataLink_ReadFieldNames, Fake);
  RegisterMethod(TMasterDataLink,
       'procedure TMasterDataLink_WriteFieldNames(const Value: String);',
       @TMasterDataLink_WriteFieldNames, Fake);
  RegisterProperty(TMasterDataLink,
       'property FieldNames:String read TMasterDataLink_ReadFieldNames write TMasterDataLink_WriteFieldNames;');
  RegisterMethod(TMasterDataLink,
       'function TMasterDataLink_ReadFields:TList;',
       @TMasterDataLink_ReadFields, Fake);
  RegisterProperty(TMasterDataLink,
       'property Fields:TList read TMasterDataLink_ReadFields;');
  // End of class TMasterDataLink
  // Begin of class TDataSource
  RegisterClassType(TDataSource, H);
  RegisterMethod(TDataSource,
       'constructor Create(AOwner: TComponent); override;',
       @TDataSource.Create);
  RegisterMethod(TDataSource,
       'destructor Destroy; override;',
       @TDataSource.Destroy);
  RegisterMethod(TDataSource,
       'procedure Edit;',
       @TDataSource.Edit);
  RegisterMethod(TDataSource,
       'function IsLinkedTo(DataSet: TDataSet): Boolean;',
       @TDataSource.IsLinkedTo);
  RegisterMethod(TDataSource,
       'function TDataSource_ReadState:TDataSetState;',
       @TDataSource_ReadState, Fake);
  RegisterProperty(TDataSource,
       'property State:TDataSetState read TDataSource_ReadState;');
  // End of class TDataSource
  // Begin of class TDataSetDesigner
  RegisterClassType(TDataSetDesigner, H);
  RegisterMethod(TDataSetDesigner,
       'constructor Create(DataSet: TDataSet);',
       @TDataSetDesigner.Create);
  RegisterMethod(TDataSetDesigner,
       'destructor Destroy; override;',
       @TDataSetDesigner.Destroy);
  RegisterMethod(TDataSetDesigner,
       'procedure BeginDesign;',
       @TDataSetDesigner.BeginDesign);
  RegisterMethod(TDataSetDesigner,
       'procedure DataEvent(Event: TDataEvent; Info: Longint); virtual;',
       @TDataSetDesigner.DataEvent);
  RegisterMethod(TDataSetDesigner,
       'procedure EndDesign;',
       @TDataSetDesigner.EndDesign);
  RegisterMethod(TDataSetDesigner,
       'function TDataSetDesigner_ReadDataSet:TDataSet;',
       @TDataSetDesigner_ReadDataSet, Fake);
  RegisterProperty(TDataSetDesigner,
       'property DataSet:TDataSet read TDataSetDesigner_ReadDataSet;');
  // End of class TDataSetDesigner
  // Begin of class TCheckConstraint
  RegisterClassType(TCheckConstraint, H);
  RegisterMethod(TCheckConstraint,
       'procedure Assign(Source: TPersistent); override;',
       @TCheckConstraint.Assign);
  RegisterMethod(TCheckConstraint,
       'function GetDisplayName: string; override;',
       @TCheckConstraint.GetDisplayName);
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TCheckConstraint
  // Begin of class TCheckConstraints
  RegisterClassType(TCheckConstraints, H);
  RegisterMethod(TCheckConstraints,
       'constructor Create(Owner: TPersistent);',
       @TCheckConstraints.Create);
  RegisterMethod(TCheckConstraints,
       'function Add: TCheckConstraint;',
       @TCheckConstraints.Add);
  RegisterMethod(TCheckConstraints,
       'function TCheckConstraints_ReadItems(Index: Integer):TCheckConstraint;',
       @TCheckConstraints_ReadItems, Fake);
  RegisterMethod(TCheckConstraints,
       'procedure TCheckConstraints_WriteItems(Index: Integer;const Value: TCheckConstraint);',
       @TCheckConstraints_WriteItems, Fake);
  RegisterProperty(TCheckConstraints,
       'property Items[Index: Integer]:TCheckConstraint read TCheckConstraints_ReadItems write TCheckConstraints_WriteItems;default;');
  // End of class TCheckConstraints
  RegisterRTTIType(TypeInfo(TParamType));
  // Begin of class TParam
  RegisterClassType(TParam, H);
  RegisterMethod(TParam,
       'constructor Create(Collection: TCollection); overload; override;',
       @TParam.Create);
  RegisterMethod(TParam,
       'constructor Create(AParams: TParams; AParamType: TParamType); reintroduce; overload;',
       @TParam.Create);
  RegisterMethod(TParam,
       'procedure Assign(Source: TPersistent); override;',
       @TParam.Assign);
  RegisterMethod(TParam,
       'procedure AssignField(Field: TField);',
       @TParam.AssignField);
  RegisterMethod(TParam,
       'procedure AssignFieldValue(Field: TField; const Value: Variant);',
       @TParam.AssignFieldValue);
  RegisterMethod(TParam,
       'procedure Clear;',
       @TParam.Clear);
  RegisterMethod(TParam,
       'procedure GetData(Buffer: Pointer);',
       @TParam.GetData);
  RegisterMethod(TParam,
       'function GetDataSize: Integer;',
       @TParam.GetDataSize);
  RegisterMethod(TParam,
       'procedure LoadFromFile(const FileName: string; BlobType: TBlobType);',
       @TParam.LoadFromFile);
  RegisterMethod(TParam,
       'procedure LoadFromStream(Stream: TStream; BlobType: TBlobType);',
       @TParam.LoadFromStream);
  RegisterMethod(TParam,
       'procedure SetBlobData(Buffer: Pointer; Size: Integer);',
       @TParam.SetBlobData);
  RegisterMethod(TParam,
       'procedure SetData(Buffer: Pointer);',
       @TParam.SetData);
  RegisterMethod(TParam,
       'function TParam_ReadAsBCD:Currency;',
       @TParam_ReadAsBCD, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsBCD(const Value: Currency);',
       @TParam_WriteAsBCD, Fake);
  RegisterProperty(TParam,
       'property AsBCD:Currency read TParam_ReadAsBCD write TParam_WriteAsBCD;');
  RegisterMethod(TParam,
       'function TParam_ReadAsFMTBCD:TBcd;',
       @TParam_ReadAsFMTBCD, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsFMTBCD(const Value: TBcd);',
       @TParam_WriteAsFMTBCD, Fake);
  RegisterProperty(TParam,
       'property AsFMTBCD:TBcd read TParam_ReadAsFMTBCD write TParam_WriteAsFMTBCD;');
  RegisterMethod(TParam,
       'function TParam_ReadAsBlob:TBlobData;',
       @TParam_ReadAsBlob, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsBlob(const Value: TBlobData);',
       @TParam_WriteAsBlob, Fake);
  RegisterProperty(TParam,
       'property AsBlob:TBlobData read TParam_ReadAsBlob write TParam_WriteAsBlob;');
  RegisterMethod(TParam,
       'function TParam_ReadAsBoolean:Boolean;',
       @TParam_ReadAsBoolean, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsBoolean(const Value: Boolean);',
       @TParam_WriteAsBoolean, Fake);
  RegisterProperty(TParam,
       'property AsBoolean:Boolean read TParam_ReadAsBoolean write TParam_WriteAsBoolean;');
  RegisterMethod(TParam,
       'function TParam_ReadAsCurrency:Currency;',
       @TParam_ReadAsCurrency, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsCurrency(const Value: Currency);',
       @TParam_WriteAsCurrency, Fake);
  RegisterProperty(TParam,
       'property AsCurrency:Currency read TParam_ReadAsCurrency write TParam_WriteAsCurrency;');
  RegisterMethod(TParam,
       'function TParam_ReadAsDate:TDateTime;',
       @TParam_ReadAsDate, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsDate(const Value: TDateTime);',
       @TParam_WriteAsDate, Fake);
  RegisterProperty(TParam,
       'property AsDate:TDateTime read TParam_ReadAsDate write TParam_WriteAsDate;');
  RegisterMethod(TParam,
       'function TParam_ReadAsDateTime:TDateTime;',
       @TParam_ReadAsDateTime, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsDateTime(const Value: TDateTime);',
       @TParam_WriteAsDateTime, Fake);
  RegisterProperty(TParam,
       'property AsDateTime:TDateTime read TParam_ReadAsDateTime write TParam_WriteAsDateTime;');
  RegisterMethod(TParam,
       'function TParam_ReadAsFloat:Double;',
       @TParam_ReadAsFloat, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsFloat(const Value: Double);',
       @TParam_WriteAsFloat, Fake);
  RegisterProperty(TParam,
       'property AsFloat:Double read TParam_ReadAsFloat write TParam_WriteAsFloat;');
  RegisterMethod(TParam,
       'function TParam_ReadAsInteger:LongInt;',
       @TParam_ReadAsInteger, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsInteger(const Value: LongInt);',
       @TParam_WriteAsInteger, Fake);
  RegisterProperty(TParam,
       'property AsInteger:LongInt read TParam_ReadAsInteger write TParam_WriteAsInteger;');
  RegisterMethod(TParam,
       'function TParam_ReadAsSmallInt:LongInt;',
       @TParam_ReadAsSmallInt, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsSmallInt(const Value: LongInt);',
       @TParam_WriteAsSmallInt, Fake);
  RegisterProperty(TParam,
       'property AsSmallInt:LongInt read TParam_ReadAsSmallInt write TParam_WriteAsSmallInt;');
  RegisterMethod(TParam,
       'function TParam_ReadAsSQLTimeStamp:TSQLTimeStamp;',
       @TParam_ReadAsSQLTimeStamp, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsSQLTimeStamp(const Value: TSQLTimeStamp);',
       @TParam_WriteAsSQLTimeStamp, Fake);
  RegisterProperty(TParam,
       'property AsSQLTimeStamp:TSQLTimeStamp read TParam_ReadAsSQLTimeStamp write TParam_WriteAsSQLTimeStamp;');
  RegisterMethod(TParam,
       'function TParam_ReadAsMemo:String;',
       @TParam_ReadAsMemo, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsMemo(const Value: String);',
       @TParam_WriteAsMemo, Fake);
  RegisterProperty(TParam,
       'property AsMemo:String read TParam_ReadAsMemo write TParam_WriteAsMemo;');
  RegisterMethod(TParam,
       'function TParam_ReadAsString:String;',
       @TParam_ReadAsString, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsString(const Value: String);',
       @TParam_WriteAsString, Fake);
  RegisterProperty(TParam,
       'property AsString:String read TParam_ReadAsString write TParam_WriteAsString;');
  RegisterMethod(TParam,
       'function TParam_ReadAsTime:TDateTime;',
       @TParam_ReadAsTime, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsTime(const Value: TDateTime);',
       @TParam_WriteAsTime, Fake);
  RegisterProperty(TParam,
       'property AsTime:TDateTime read TParam_ReadAsTime write TParam_WriteAsTime;');
  RegisterMethod(TParam,
       'function TParam_ReadAsWord:LongInt;',
       @TParam_ReadAsWord, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteAsWord(const Value: LongInt);',
       @TParam_WriteAsWord, Fake);
  RegisterProperty(TParam,
       'property AsWord:LongInt read TParam_ReadAsWord write TParam_WriteAsWord;');
  RegisterMethod(TParam,
       'function TParam_ReadBound:Boolean;',
       @TParam_ReadBound, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteBound(const Value: Boolean);',
       @TParam_WriteBound, Fake);
  RegisterProperty(TParam,
       'property Bound:Boolean read TParam_ReadBound write TParam_WriteBound;');
  RegisterMethod(TParam,
       'function TParam_ReadIsNull:Boolean;',
       @TParam_ReadIsNull, Fake);
  RegisterProperty(TParam,
       'property IsNull:Boolean read TParam_ReadIsNull;');
  RegisterMethod(TParam,
       'function TParam_ReadNativeStr:String;',
       @TParam_ReadNativeStr, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteNativeStr(const Value: String);',
       @TParam_WriteNativeStr, Fake);
  RegisterProperty(TParam,
       'property NativeStr:String read TParam_ReadNativeStr write TParam_WriteNativeStr;');
  RegisterMethod(TParam,
       'function TParam_ReadText:String;',
       @TParam_ReadText, Fake);
  RegisterMethod(TParam,
       'procedure TParam_WriteText(const Value: String);',
       @TParam_WriteText, Fake);
  RegisterProperty(TParam,
       'property Text:String read TParam_ReadText write TParam_WriteText;');
  // End of class TParam
  // Begin of class TParams
  RegisterClassType(TParams, H);
  RegisterMethod(TParams,
       'constructor Create(Owner: TPersistent); overload;',
       @TParams.Create);
  RegisterMethod(TParams,
       'procedure AssignValues(Value: TParams);',
       @TParams.AssignValues);
  RegisterMethod(TParams,
       'constructor Create; overload;',
       @TParams.Create);
  RegisterMethod(TParams,
       'procedure AddParam(Value: TParam);',
       @TParams.AddParam);
  RegisterMethod(TParams,
       'procedure RemoveParam(Value: TParam);',
       @TParams.RemoveParam);
  RegisterMethod(TParams,
       'function CreateParam(FldType: TFieldType; const ParamName: string;      ParamType: TParamType): TParam;',
       @TParams.CreateParam);
  RegisterMethod(TParams,
       'procedure GetParamList(List: TList; const ParamNames: string);',
       @TParams.GetParamList);
  RegisterMethod(TParams,
       'function IsEqual(Value: TParams): Boolean;',
       @TParams.IsEqual);
  RegisterMethod(TParams,
       'function ParseSQL(SQL: String; DoCreate: Boolean): String;',
       @TParams.ParseSQL);
  RegisterMethod(TParams,
       'function ParamByName(const Value: string): TParam;',
       @TParams.ParamByName);
  RegisterMethod(TParams,
       'function FindParam(const Value: string): TParam;',
       @TParams.FindParam);
  RegisterMethod(TParams,
       'function TParams_ReadItems(Index: Integer):TParam;',
       @TParams_ReadItems, Fake);
  RegisterMethod(TParams,
       'procedure TParams_WriteItems(Index: Integer;const Value: TParam);',
       @TParams_WriteItems, Fake);
  RegisterProperty(TParams,
       'property Items[Index: Integer]:TParam read TParams_ReadItems write TParams_WriteItems;default;');
  RegisterMethod(TParams,
       'function TParams_ReadParamValues(const ParamName: string):Variant;',
       @TParams_ReadParamValues, Fake);
  RegisterMethod(TParams,
       'procedure TParams_WriteParamValues(const ParamName: string;const Value: Variant);',
       @TParams_WriteParamValues, Fake);
  RegisterProperty(TParams,
       'property ParamValues[const ParamName: string]:Variant read TParams_ReadParamValues write TParams_WriteParamValues;');
  // End of class TParams
  RegisterRTTIType(TypeInfo(TBookmarkFlag));
  RegisterRTTIType(TypeInfo(TGetMode));
  RegisterRTTIType(TypeInfo(TGetResult));
  RegisterRTTIType(TypeInfo(TDataAction));
  RegisterRTTIType(TypeInfo(TBlobStreamMode));
  RegisterRTTIType(TypeInfo(TLocateOption));
  RegisterRTTIType(TypeInfo(TFilterOption));
  RegisterRTTIType(TypeInfo(TGroupPosInd));
  // Begin of class TDataSet
  RegisterClassType(TDataSet, H);
  RegisterMethod(TDataSet,
       'constructor Create(AOwner: TComponent); override;',
       @TDataSet.Create);
  RegisterMethod(TDataSet,
       'destructor Destroy; override;',
       @TDataSet.Destroy);
  RegisterMethod(TDataSet,
       'function ActiveBuffer: PChar;',
       @TDataSet.ActiveBuffer);
  RegisterMethod(TDataSet,
       'procedure Append;',
       @TDataSet.Append);
  RegisterMethod(TDataSet,
       'procedure AppendRecord(const Values: array of const);',
       @TDataSet.AppendRecord);
  RegisterMethod(TDataSet,
       'function BookmarkValid(Bookmark: TBookmark): Boolean; virtual;',
       @TDataSet.BookmarkValid);
  RegisterMethod(TDataSet,
       'procedure Cancel; virtual;',
       @TDataSet.Cancel);
  RegisterMethod(TDataSet,
       'procedure CheckBrowseMode;',
       @TDataSet.CheckBrowseMode);
  RegisterMethod(TDataSet,
       'procedure ClearFields;',
       @TDataSet.ClearFields);
  RegisterMethod(TDataSet,
       'procedure Close;',
       @TDataSet.Close);
  RegisterMethod(TDataSet,
       'function  ControlsDisabled: Boolean;',
       @TDataSet.ControlsDisabled);
  RegisterMethod(TDataSet,
       'function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; virtual;',
       @TDataSet.CompareBookmarks);
  RegisterMethod(TDataSet,
       'function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; virtual;',
       @TDataSet.CreateBlobStream);
  RegisterMethod(TDataSet,
       'procedure CursorPosChanged;',

       @TDataSet.CursorPosChanged);
  RegisterMethod(TDataSet,
       'procedure Delete;',
       @TDataSet.Delete);
  RegisterMethod(TDataSet,
       'procedure DisableControls;',
       @TDataSet.DisableControls);
  RegisterMethod(TDataSet,
       'procedure Edit;',
       @TDataSet.Edit);
  RegisterMethod(TDataSet,
       'procedure EnableControls;',
       @TDataSet.EnableControls);
  RegisterMethod(TDataSet,
       'function FieldByName(const FieldName: string): TField;',
       @TDataSet.FieldByName);
  RegisterMethod(TDataSet,
       'function FindField(const FieldName: string): TField;',
       @TDataSet.FindField);
  RegisterMethod(TDataSet,
       'function FindFirst: Boolean;',
       @TDataSet.FindFirst);
  RegisterMethod(TDataSet,
       'function FindLast: Boolean;',
       @TDataSet.FindLast);
  RegisterMethod(TDataSet,
       'function FindNext: Boolean;',
       @TDataSet.FindNext);
  RegisterMethod(TDataSet,
       'function FindPrior: Boolean;',
       @TDataSet.FindPrior);
  RegisterMethod(TDataSet,
       'procedure First;',
       @TDataSet.First);
  RegisterMethod(TDataSet,
       'procedure FreeBookmark(Bookmark: TBookmark); virtual;',
       @TDataSet.FreeBookmark);
  RegisterMethod(TDataSet,
       'function GetBookmark: TBookmark; virtual;',
       @TDataSet.GetBookmark);
  RegisterMethod(TDataSet,
       'function GetCurrentRecord(Buffer: PChar): Boolean; virtual;',
       @TDataSet.GetCurrentRecord);
  RegisterMethod(TDataSet,
       'procedure GetDetailDataSets(List: TList); virtual;',
       @TDataSet.GetDetailDataSets);
  RegisterMethod(TDataSet,
       'procedure GetDetailLinkFields(MasterFields, DetailFields: TList); virtual;',
       @TDataSet.GetDetailLinkFields);
  RegisterMethod(TDataSet,
       'function GetBlobFieldData(FieldNo: Integer; var Buffer: TBlobByteData): Integer; virtual;',
       @TDataSet.GetBlobFieldData);
  RegisterMethod(TDataSet,
       'function GetFieldData(Field: TField; Buffer: Pointer): Boolean; overload; virtual;',
       @TDataSet.GetFieldData);
  RegisterMethod(TDataSet,
       'function GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean; overload; virtual;',
       @TDataSet.GetFieldData);
  RegisterMethod(TDataSet,
       'function GetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean): Boolean; overload; virtual;',
       @TDataSet.GetFieldData);
  RegisterMethod(TDataSet,
       'procedure GetFieldList(List: TList; const FieldNames: string);',
       @TDataSet.GetFieldList);
  RegisterMethod(TDataSet,
       'procedure GetFieldNames(List: TStrings); virtual;',
       @TDataSet.GetFieldNames);
  RegisterMethod(TDataSet,
       'procedure GotoBookmark(Bookmark: TBookmark);',
       @TDataSet.GotoBookmark);
  RegisterMethod(TDataSet,
       'procedure Insert;',
       @TDataSet.Insert);
  RegisterMethod(TDataSet,
       'procedure InsertRecord(const Values: array of const);',
       @TDataSet.InsertRecord);
  RegisterMethod(TDataSet,
       'function IsEmpty: Boolean;',
       @TDataSet.IsEmpty);
  RegisterMethod(TDataSet,
       'function IsLinkedTo(DataSource: TDataSource): Boolean;',
       @TDataSet.IsLinkedTo);
  RegisterMethod(TDataSet,
       'function IsSequenced: Boolean; virtual;',
       @TDataSet.IsSequenced);
  RegisterMethod(TDataSet,
       'procedure Last;',
       @TDataSet.Last);
  RegisterMethod(TDataSet,
       'function Locate(const KeyFields: string; const KeyValues: Variant;      Options: TLocateOptions): Boolean; virtual;',
       @TDataSet.Locate);
  RegisterMethod(TDataSet,
       'function Lookup(const KeyFields: string; const KeyValues: Variant;      const ResultFields: string): Variant; virtual;',
       @TDataSet.Lookup);
  RegisterMethod(TDataSet,
       'function MoveBy(Distance: Integer): Integer;',
       @TDataSet.MoveBy);
  RegisterMethod(TDataSet,
       'procedure Next;',
       @TDataSet.Next);
  RegisterMethod(TDataSet,
       'procedure Open;',
       @TDataSet.Open);
  RegisterMethod(TDataSet,
       'procedure Post; virtual;',
       @TDataSet.Post);
  RegisterMethod(TDataSet,
       'procedure Prior;',
       @TDataSet.Prior);
  RegisterMethod(TDataSet,
       'procedure Refresh;',
       @TDataSet.Refresh);
  RegisterMethod(TDataSet,
       'procedure Resync(Mode: TResyncMode); virtual;',
       @TDataSet.Resync);
  RegisterMethod(TDataSet,
       'procedure SetFields(const Values: array of const);',
       @TDataSet.SetFields);
  RegisterMethod(TDataSet,
       'function Translate(Src, Dest: PChar; ToOem: Boolean): Integer; virtual;',
       @TDataSet.Translate);
  RegisterMethod(TDataSet,
       'procedure UpdateCursorPos;',
       @TDataSet.UpdateCursorPos);
  RegisterMethod(TDataSet,
       'procedure UpdateRecord;',
       @TDataSet.UpdateRecord);
  RegisterMethod(TDataSet,
       'function UpdateStatus: TUpdateStatus; virtual;',
       @TDataSet.UpdateStatus);
  RegisterMethod(TDataSet,
       'function TDataSet_ReadAggFields:TFields;',
       @TDataSet_ReadAggFields, Fake);
  RegisterProperty(TDataSet,
       'property AggFields:TFields read TDataSet_ReadAggFields;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadBof:Boolean;',
       @TDataSet_ReadBof, Fake);
  RegisterProperty(TDataSet,
       'property Bof:Boolean read TDataSet_ReadBof;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadBookmark:TBookmarkStr;',
       @TDataSet_ReadBookmark, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteBookmark(const Value: TBookmarkStr);',
       @TDataSet_WriteBookmark, Fake);
  RegisterProperty(TDataSet,
       'property Bookmark:TBookmarkStr read TDataSet_ReadBookmark write TDataSet_WriteBookmark;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadCanModify:Boolean;',
       @TDataSet_ReadCanModify, Fake);

  RegisterProperty(TDataSet,
       'property CanModify:Boolean read TDataSet_ReadCanModify;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadDataSetField:TDataSetField;',
       @TDataSet_ReadDataSetField, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteDataSetField(const Value: TDataSetField);',
       @TDataSet_WriteDataSetField, Fake);
  RegisterProperty(TDataSet,
       'property DataSetField:TDataSetField read TDataSet_ReadDataSetField write TDataSet_WriteDataSetField;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadDataSource:TDataSource;',
       @TDataSet_ReadDataSource, Fake);
  RegisterProperty(TDataSet,
       'property DataSource:TDataSource read TDataSet_ReadDataSource;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadDefaultFields:Boolean;',
       @TDataSet_ReadDefaultFields, Fake);
  RegisterProperty(TDataSet,
       'property DefaultFields:Boolean read TDataSet_ReadDefaultFields;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadDesigner:TDataSetDesigner;',
       @TDataSet_ReadDesigner, Fake);
  RegisterProperty(TDataSet,
       'property Designer:TDataSetDesigner read TDataSet_ReadDesigner;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadEof:Boolean;',
       @TDataSet_ReadEof, Fake);
  RegisterProperty(TDataSet,
       'property Eof:Boolean read TDataSet_ReadEof;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadBlockReadSize:Integer;',
       @TDataSet_ReadBlockReadSize, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteBlockReadSize(const Value: Integer);',
       @TDataSet_WriteBlockReadSize, Fake);
  RegisterProperty(TDataSet,
       'property BlockReadSize:Integer read TDataSet_ReadBlockReadSize write TDataSet_WriteBlockReadSize;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadFieldCount:Integer;',
       @TDataSet_ReadFieldCount, Fake);
  RegisterProperty(TDataSet,
       'property FieldCount:Integer read TDataSet_ReadFieldCount;');

  RegisterMethod(TDataSet,
       'function TDataSet_ReadFieldDefs:TFieldDefs;',
       @TDataSet_ReadFieldDefs, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteFieldDefs(const Value: TFieldDefs);',
       @TDataSet_WriteFieldDefs, Fake);
  RegisterProperty(TDataSet,
       'property FieldDefs:TFieldDefs read TDataSet_ReadFieldDefs write TDataSet_WriteFieldDefs;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadFieldDefList:TFieldDefList;',
       @TDataSet_ReadFieldDefList, Fake);
  RegisterProperty(TDataSet,
       'property FieldDefList:TFieldDefList read TDataSet_ReadFieldDefList;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadFields:TFields;',
       @TDataSet_ReadFields, Fake);
  RegisterProperty(TDataSet,
       'property Fields:TFields read TDataSet_ReadFields;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadFieldList:TFieldList;',
       @TDataSet_ReadFieldList, Fake);
  RegisterProperty(TDataSet,
       'property FieldList:TFieldList read TDataSet_ReadFieldList;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadFieldValues(const FieldName: string):Variant;',
       @TDataSet_ReadFieldValues, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteFieldValues(const FieldName: string;const Value: Variant);',
       @TDataSet_WriteFieldValues, Fake);
  RegisterProperty(TDataSet,
       'property FieldValues[const FieldName: string]:Variant read TDataSet_ReadFieldValues write TDataSet_WriteFieldValues;default;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadFound:Boolean;',
       @TDataSet_ReadFound, Fake);
  RegisterProperty(TDataSet,
       'property Found:Boolean read TDataSet_ReadFound;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadIsUniDirectional:Boolean;',
       @TDataSet_ReadIsUniDirectional, Fake);
  RegisterProperty(TDataSet,
       'property IsUniDirectional:Boolean read TDataSet_ReadIsUniDirectional;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadModified:Boolean;',
       @TDataSet_ReadModified, Fake);
  RegisterProperty(TDataSet,
       'property Modified:Boolean read TDataSet_ReadModified;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadObjectView:Boolean;',
       @TDataSet_ReadObjectView, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteObjectView(const Value: Boolean);',
       @TDataSet_WriteObjectView, Fake);
  RegisterProperty(TDataSet,
       'property ObjectView:Boolean read TDataSet_ReadObjectView write TDataSet_WriteObjectView;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadRecordCount:Integer;',
       @TDataSet_ReadRecordCount, Fake);
  RegisterProperty(TDataSet,
       'property RecordCount:Integer read TDataSet_ReadRecordCount;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadRecNo:Integer;',
       @TDataSet_ReadRecNo, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteRecNo(const Value: Integer);',
       @TDataSet_WriteRecNo, Fake);
  RegisterProperty(TDataSet,
       'property RecNo:Integer read TDataSet_ReadRecNo write TDataSet_WriteRecNo;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadRecordSize:Word;',
       @TDataSet_ReadRecordSize, Fake);
  RegisterProperty(TDataSet,
       'property RecordSize:Word read TDataSet_ReadRecordSize;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadSparseArrays:Boolean;',
       @TDataSet_ReadSparseArrays, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteSparseArrays(const Value: Boolean);',
       @TDataSet_WriteSparseArrays, Fake);
  RegisterProperty(TDataSet,
       'property SparseArrays:Boolean read TDataSet_ReadSparseArrays write TDataSet_WriteSparseArrays;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadState:TDataSetState;',
       @TDataSet_ReadState, Fake);
  RegisterProperty(TDataSet,
       'property State:TDataSetState read TDataSet_ReadState;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadFilter:String;',
       @TDataSet_ReadFilter, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteFilter(const Value: String);',
       @TDataSet_WriteFilter, Fake);
  RegisterProperty(TDataSet,
       'property Filter:String read TDataSet_ReadFilter write TDataSet_WriteFilter;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadFiltered:Boolean;',
       @TDataSet_ReadFiltered, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteFiltered(const Value: Boolean);',
       @TDataSet_WriteFiltered, Fake);
  RegisterProperty(TDataSet,
       'property Filtered:Boolean read TDataSet_ReadFiltered write TDataSet_WriteFiltered;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadFilterOptions:TFilterOptions;',
       @TDataSet_ReadFilterOptions, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteFilterOptions(const Value: TFilterOptions);',
       @TDataSet_WriteFilterOptions, Fake);
  RegisterProperty(TDataSet,
       'property FilterOptions:TFilterOptions read TDataSet_ReadFilterOptions write TDataSet_WriteFilterOptions;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadActive:Boolean;',
       @TDataSet_ReadActive, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteActive(const Value: Boolean);',
       @TDataSet_WriteActive, Fake);
  RegisterProperty(TDataSet,
       'property Active:Boolean read TDataSet_ReadActive write TDataSet_WriteActive;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadAutoCalcFields:Boolean;',
       @TDataSet_ReadAutoCalcFields, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteAutoCalcFields(const Value: Boolean);',
       @TDataSet_WriteAutoCalcFields, Fake);
  RegisterProperty(TDataSet,
       'property AutoCalcFields:Boolean read TDataSet_ReadAutoCalcFields write TDataSet_WriteAutoCalcFields;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadBeforeOpen:TDataSetNotifyEvent;',
       @TDataSet_ReadBeforeOpen, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteBeforeOpen(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteBeforeOpen, Fake);
  RegisterProperty(TDataSet,
       'property BeforeOpen:TDataSetNotifyEvent read TDataSet_ReadBeforeOpen write TDataSet_WriteBeforeOpen;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadAfterOpen:TDataSetNotifyEvent;',
       @TDataSet_ReadAfterOpen, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteAfterOpen(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteAfterOpen, Fake);
  RegisterProperty(TDataSet,
       'property AfterOpen:TDataSetNotifyEvent read TDataSet_ReadAfterOpen write TDataSet_WriteAfterOpen;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadBeforeClose:TDataSetNotifyEvent;',
       @TDataSet_ReadBeforeClose, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteBeforeClose(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteBeforeClose, Fake);
  RegisterProperty(TDataSet,
       'property BeforeClose:TDataSetNotifyEvent read TDataSet_ReadBeforeClose write TDataSet_WriteBeforeClose;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadAfterClose:TDataSetNotifyEvent;',
       @TDataSet_ReadAfterClose, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteAfterClose(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteAfterClose, Fake);
  RegisterProperty(TDataSet,
       'property AfterClose:TDataSetNotifyEvent read TDataSet_ReadAfterClose write TDataSet_WriteAfterClose;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadBeforeInsert:TDataSetNotifyEvent;',
       @TDataSet_ReadBeforeInsert, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteBeforeInsert(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteBeforeInsert, Fake);
  RegisterProperty(TDataSet,
       'property BeforeInsert:TDataSetNotifyEvent read TDataSet_ReadBeforeInsert write TDataSet_WriteBeforeInsert;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadAfterInsert:TDataSetNotifyEvent;',
       @TDataSet_ReadAfterInsert, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteAfterInsert(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteAfterInsert, Fake);
  RegisterProperty(TDataSet,
       'property AfterInsert:TDataSetNotifyEvent read TDataSet_ReadAfterInsert write TDataSet_WriteAfterInsert;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadBeforeEdit:TDataSetNotifyEvent;',
       @TDataSet_ReadBeforeEdit, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteBeforeEdit(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteBeforeEdit, Fake);
  RegisterProperty(TDataSet,
       'property BeforeEdit:TDataSetNotifyEvent read TDataSet_ReadBeforeEdit write TDataSet_WriteBeforeEdit;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadAfterEdit:TDataSetNotifyEvent;',
       @TDataSet_ReadAfterEdit, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteAfterEdit(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteAfterEdit, Fake);
  RegisterProperty(TDataSet,
       'property AfterEdit:TDataSetNotifyEvent read TDataSet_ReadAfterEdit write TDataSet_WriteAfterEdit;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadBeforePost:TDataSetNotifyEvent;',
       @TDataSet_ReadBeforePost, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteBeforePost(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteBeforePost, Fake);
  RegisterProperty(TDataSet,
       'property BeforePost:TDataSetNotifyEvent read TDataSet_ReadBeforePost write TDataSet_WriteBeforePost;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadAfterPost:TDataSetNotifyEvent;',
       @TDataSet_ReadAfterPost, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteAfterPost(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteAfterPost, Fake);
  RegisterProperty(TDataSet,
       'property AfterPost:TDataSetNotifyEvent read TDataSet_ReadAfterPost write TDataSet_WriteAfterPost;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadBeforeCancel:TDataSetNotifyEvent;',
       @TDataSet_ReadBeforeCancel, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteBeforeCancel(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteBeforeCancel, Fake);
  RegisterProperty(TDataSet,
       'property BeforeCancel:TDataSetNotifyEvent read TDataSet_ReadBeforeCancel write TDataSet_WriteBeforeCancel;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadAfterCancel:TDataSetNotifyEvent;',
       @TDataSet_ReadAfterCancel, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteAfterCancel(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteAfterCancel, Fake);
  RegisterProperty(TDataSet,
       'property AfterCancel:TDataSetNotifyEvent read TDataSet_ReadAfterCancel write TDataSet_WriteAfterCancel;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadBeforeDelete:TDataSetNotifyEvent;',
       @TDataSet_ReadBeforeDelete, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteBeforeDelete(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteBeforeDelete, Fake);
  RegisterProperty(TDataSet,
       'property BeforeDelete:TDataSetNotifyEvent read TDataSet_ReadBeforeDelete write TDataSet_WriteBeforeDelete;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadAfterDelete:TDataSetNotifyEvent;',
       @TDataSet_ReadAfterDelete, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteAfterDelete(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteAfterDelete, Fake);
  RegisterProperty(TDataSet,
       'property AfterDelete:TDataSetNotifyEvent read TDataSet_ReadAfterDelete write TDataSet_WriteAfterDelete;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadBeforeScroll:TDataSetNotifyEvent;',
       @TDataSet_ReadBeforeScroll, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteBeforeScroll(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteBeforeScroll, Fake);
  RegisterProperty(TDataSet,
       'property BeforeScroll:TDataSetNotifyEvent read TDataSet_ReadBeforeScroll write TDataSet_WriteBeforeScroll;');
  RegisterMethod(TDataSet,

       'function TDataSet_ReadAfterScroll:TDataSetNotifyEvent;',
       @TDataSet_ReadAfterScroll, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteAfterScroll(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteAfterScroll, Fake);
  RegisterProperty(TDataSet,
       'property AfterScroll:TDataSetNotifyEvent read TDataSet_ReadAfterScroll write TDataSet_WriteAfterScroll;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadBeforeRefresh:TDataSetNotifyEvent;',
       @TDataSet_ReadBeforeRefresh, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteBeforeRefresh(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteBeforeRefresh, Fake);
  RegisterProperty(TDataSet,
       'property BeforeRefresh:TDataSetNotifyEvent read TDataSet_ReadBeforeRefresh write TDataSet_WriteBeforeRefresh;');
  RegisterMethod(TDataSet,
       'function TDataSet_ReadAfterRefresh:TDataSetNotifyEvent;',
       @TDataSet_ReadAfterRefresh, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_WriteAfterRefresh(const Value: TDataSetNotifyEvent);',
       @TDataSet_WriteAfterRefresh, Fake);
  RegisterProperty(TDataSet,
       'property AfterRefresh:TDataSetNotifyEvent read TDataSet_ReadAfterRefresh write TDataSet_WriteAfterRefresh;');
  // End of class TDataSet
  RegisterConstant('DsMaxStringSize', 8192, H);
  RegisterRTTIType(TypeInfo(TDBScreenCursor));
  RegisterRoutine('function ExtractFieldName(const Fields: string; var Pos: Integer): string;', @ExtractFieldName, H);
  RegisterRoutine('procedure RegisterFields(const FieldClasses: array of TFieldClass);', @RegisterFields, H);
  RegisterRoutine('procedure DisposeMem(var Buffer; Size: Integer);', @DisposeMem, H);
  RegisterRoutine('function BuffersEqual(Buf1, Buf2: Pointer; Size: Integer): Boolean;', @BuffersEqual, H);
  RegisterRoutine('function GetFieldProperty(DataSet: TDataSet; Control: TComponent;  const FieldName: string): TField;', @GetFieldProperty, H);
  RegisterRoutine('function VarTypeToDataType(VarType: Integer): TFieldType;', @VarTypeToDataType, H);
end;
//****************************************************************
{$ELSE}
//****************************************************************
unit IMP_db;
interface
uses
  Windows,
  SysUtils,
  Classes,
  Graphics,
  db,
  PaxScripter;
procedure RegisterIMP_db;
implementation
function EUpdateError_GetContext:String;
begin
  result := EUpdateError(_Self).Context;
end;
function EUpdateError_GetErrorCode:Integer;
begin
  result := EUpdateError(_Self).ErrorCode;
end;
function EUpdateError_GetPreviousError:Integer;
begin
  result := EUpdateError(_Self).PreviousError;
end;
function EUpdateError_GetOriginalException:Exception;
begin
  result := EUpdateError(_Self).OriginalException;
end;
function TCustomConnection_GetConnected:Boolean;
begin
  result := TCustomConnection(_Self).Connected;
end;
procedure TCustomConnection_PutConnected(const Value: Boolean);
begin
  TCustomConnection(_Self).Connected := Value;
end;
function TCustomConnection_GetDataSets(Index: Integer):TDataSet;
begin
  result := TCustomConnection(_Self).DataSets[Index];
end;
function TCustomConnection_GetDataSetCount:Integer;
begin
  result := TCustomConnection(_Self).DataSetCount;
end;
function TCustomConnection_GetLoginPrompt:Boolean;
begin
  result := TCustomConnection(_Self).LoginPrompt;
end;
procedure TCustomConnection_PutLoginPrompt(const Value: Boolean);
begin
  TCustomConnection(_Self).LoginPrompt := Value;
end;
function TCustomConnection_GetAfterConnect:TNotifyEvent;
begin
  result := TCustomConnection(_Self).AfterConnect;
end;
procedure TCustomConnection_PutAfterConnect(const Value: TNotifyEvent);
begin
  TCustomConnection(_Self).AfterConnect := Value;
end;
function TCustomConnection_GetBeforeConnect:TNotifyEvent;
begin
  result := TCustomConnection(_Self).BeforeConnect;
end;
procedure TCustomConnection_PutBeforeConnect(const Value: TNotifyEvent);
begin
  TCustomConnection(_Self).BeforeConnect := Value;
end;
function TCustomConnection_GetAfterDisconnect:TNotifyEvent;
begin
  result := TCustomConnection(_Self).AfterDisconnect;
end;
procedure TCustomConnection_PutAfterDisconnect(const Value: TNotifyEvent);
begin
  TCustomConnection(_Self).AfterDisconnect := Value;
end;
function TCustomConnection_GetBeforeDisconnect:TNotifyEvent;
begin
  result := TCustomConnection(_Self).BeforeDisconnect;
end;
procedure TCustomConnection_PutBeforeDisconnect(const Value: TNotifyEvent);
begin
  TCustomConnection(_Self).BeforeDisconnect := Value;
end;
function TDefCollection_GetDataSet:TDataSet;
begin
  result := TDefCollection(_Self).DataSet;
end;
function TDefCollection_GetUpdated:Boolean;
begin
  result := TDefCollection(_Self).Updated;
end;
procedure TDefCollection_PutUpdated(const Value: Boolean);
begin
  TDefCollection(_Self).Updated := Value;
end;
function TFieldDef_GetFieldClass:TFieldClass;
begin
  result := TFieldDef(_Self).FieldClass;
end;
function TFieldDef_GetFieldNo:Integer;
begin
  result := TFieldDef(_Self).FieldNo;
end;
procedure TFieldDef_PutFieldNo(const Value: Integer);
begin
  TFieldDef(_Self).FieldNo := Value;
end;
function TFieldDef_GetInternalCalcField:Boolean;
begin
  result := TFieldDef(_Self).InternalCalcField;
end;
procedure TFieldDef_PutInternalCalcField(const Value: Boolean);
begin
  TFieldDef(_Self).InternalCalcField := Value;
end;
function TFieldDef_GetParentDef:TFieldDef;
begin
  result := TFieldDef(_Self).ParentDef;
end;
function TFieldDef_GetRequired:Boolean;
begin
  result := TFieldDef(_Self).Required;
end;
procedure TFieldDef_PutRequired(const Value: Boolean);
begin
  TFieldDef(_Self).Required := Value;
end;
function TFieldDefs_GetHiddenFields:Boolean;
begin
  result := TFieldDefs(_Self).HiddenFields;
end;
procedure TFieldDefs_PutHiddenFields(const Value: Boolean);
begin
  TFieldDefs(_Self).HiddenFields := Value;
end;
function TFieldDefs_GetItems(Index: Integer):TFieldDef;
begin
  result := TFieldDefs(_Self).Items[Index];
end;
procedure TFieldDefs_PutItems(Index: Integer;const Value: TFieldDef);
begin
  TFieldDefs(_Self).Items[Index] := Value;
end;
function TFieldDefs_GetParentDef:TFieldDef;
begin
  result := TFieldDefs(_Self).ParentDef;
end;
function TIndexDef_GetFieldExpression:String;
begin
  result := TIndexDef(_Self).FieldExpression;
end;
function TIndexDefs_GetItems(Index: Integer):TIndexDef;
begin
  result := TIndexDefs(_Self).Items[Index];
end;
procedure TIndexDefs_PutItems(Index: Integer;const Value: TIndexDef);
begin
  TIndexDefs(_Self).Items[Index] := Value;
end;
function TFlatList_GetDataSet:TDataSet;
begin
  result := TFlatList(_Self).DataSet;
end;
function TFieldDefList_GetFieldDefs(Index: Integer):TFieldDef;
begin
  result := TFieldDefList(_Self).FieldDefs[Index];
end;
function TFieldList_GetFields(Index: Integer):TField;
begin
  result := TFieldList(_Self).Fields[Index];
end;
function TFields_GetCount:Integer;
begin
  result := TFields(_Self).Count;
end;
function TFields_GetDataSet:TDataSet;
begin
  result := TFields(_Self).DataSet;
end;
function TFields_GetFields(Index: Integer):TField;
begin
  result := TFields(_Self).Fields[Index];
end;
procedure TFields_PutFields(Index: Integer;const Value: TField);
begin
  TFields(_Self).Fields[Index] := Value;
end;
function TField_GetAsBoolean:Boolean;
begin
  result := TField(_Self).AsBoolean;
end;
procedure TField_PutAsBoolean(const Value: Boolean);
begin
  TField(_Self).AsBoolean := Value;
end;
function TField_GetAsCurrency:Currency;
begin
  result := TField(_Self).AsCurrency;
end;
procedure TField_PutAsCurrency(const Value: Currency);
begin
  TField(_Self).AsCurrency := Value;
end;
function TField_GetAsDateTime:TDateTime;
begin
  result := TField(_Self).AsDateTime;
end;
procedure TField_PutAsDateTime(const Value: TDateTime);
begin
  TField(_Self).AsDateTime := Value;
end;
function TField_GetAsFloat:Double;
begin
  result := TField(_Self).AsFloat;
end;
procedure TField_PutAsFloat(const Value: Double);
begin
  TField(_Self).AsFloat := Value;
end;
function TField_GetAsInteger:Longint;
begin
  result := TField(_Self).AsInteger;
end;
procedure TField_PutAsInteger(const Value: Longint);
begin
  TField(_Self).AsInteger := Value;
end;
function TField_GetAsString:String;
begin
  result := TField(_Self).AsString;
end;
procedure TField_PutAsString(const Value: String);
begin
  TField(_Self).AsString := Value;
end;
function TField_GetAsVariant:Variant;
begin
  result := TField(_Self).AsVariant;
end;
procedure TField_PutAsVariant(const Value: Variant);
begin
  TField(_Self).AsVariant := Value;
end;
function TField_GetAttributeSet:String;
begin
  result := TField(_Self).AttributeSet;
end;
procedure TField_PutAttributeSet(const Value: String);
begin
  TField(_Self).AttributeSet := Value;
end;
function TField_GetCalculated:Boolean;
begin
  result := TField(_Self).Calculated;
end;
procedure TField_PutCalculated(const Value: Boolean);
begin
  TField(_Self).Calculated := Value;
end;
function TField_GetCanModify:Boolean;
begin
  result := TField(_Self).CanModify;
end;
function TField_GetCurValue:Variant;
begin
  result := TField(_Self).CurValue;
end;
function TField_GetDataSet:TDataSet;
begin
  result := TField(_Self).DataSet;
end;
procedure TField_PutDataSet(const Value: TDataSet);
begin
  TField(_Self).DataSet := Value;
end;
function TField_GetDataSize:Integer;
begin
  result := TField(_Self).DataSize;
end;
function TField_GetDataType:TFieldType;
begin
  result := TField(_Self).DataType;
end;
function TField_GetDisplayName:String;
begin
  result := TField(_Self).DisplayName;
end;
function TField_GetDisplayText:String;
begin
  result := TField(_Self).DisplayText;
end;
function TField_GetEditMask:String;
begin
  result := TField(_Self).EditMask;
end;
procedure TField_PutEditMask(const Value: String);
begin
  TField(_Self).EditMask := Value;
end;
function TField_GetEditMaskPtr:String;
begin
  result := TField(_Self).EditMaskPtr;
end;
function TField_GetFieldNo:Integer;
begin
  result := TField(_Self).FieldNo;
end;
function TField_GetFullName:String;
begin
  result := TField(_Self).FullName;
end;
function TField_GetIsIndexField:Boolean;
begin
  result := TField(_Self).IsIndexField;
end;
function TField_GetIsNull:Boolean;
begin
  result := TField(_Self).IsNull;
end;
function TField_GetLookup:Boolean;
begin
  result := TField(_Self).Lookup;
end;
procedure TField_PutLookup(const Value: Boolean);
begin
  TField(_Self).Lookup := Value;
end;
function TField_GetLookupList:TLookupList;
begin
  result := TField(_Self).LookupList;
end;
function TField_GetNewValue:Variant;
begin
  result := TField(_Self).NewValue;
end;
procedure TField_PutNewValue(const Value: Variant);
begin
  TField(_Self).NewValue := Value;
end;
function TField_GetOffset:Integer;
begin
  result := TField(_Self).Offset;
end;
function TField_GetOldValue:Variant;
begin
  result := TField(_Self).OldValue;
end;
function TField_GetParentField:TObjectField;
begin
  result := TField(_Self).ParentField;
end;
procedure TField_PutParentField(const Value: TObjectField);
begin
  TField(_Self).ParentField := Value;
end;
function TField_GetSize:Integer;
begin
  result := TField(_Self).Size;
end;
procedure TField_PutSize(const Value: Integer);
begin
  TField(_Self).Size := Value;
end;
function TField_GetText:String;
begin
  result := TField(_Self).Text;
end;
procedure TField_PutText(const Value: String);
begin
  TField(_Self).Text := Value;
end;
function TField_GetValidChars:TFieldChars;
begin
  result := TField(_Self).ValidChars;
end;
procedure TField_PutValidChars(const Value: TFieldChars);
begin
  TField(_Self).ValidChars := Value;
end;
function TField_GetValue:Variant;
begin
  result := TField(_Self).Value;
end;
procedure TField_PutValue(const Value: Variant);
begin
  TField(_Self).Value := Value;
end;
function TStringField_GetValue:String;
begin
  result := TStringField(_Self).Value;
end;
procedure TStringField_PutValue(const Value: String);
begin
  TStringField(_Self).Value := Value;
end;
function TWideStringField_GetValue:WideString;
begin
  result := TWideStringField(_Self).Value;
end;
procedure TWideStringField_PutValue(const Value: WideString);
begin
  TWideStringField(_Self).Value := Value;
end;
function TIntegerField_GetValue:Longint;
begin
  result := TIntegerField(_Self).Value;
end;
procedure TIntegerField_PutValue(const Value: Longint);
begin
  TIntegerField(_Self).Value := Value;
end;
function TLargeintField_GetAsLargeInt:LargeInt;
begin
  result := TLargeintField(_Self).AsLargeInt;
end;
procedure TLargeintField_PutAsLargeInt(const Value: LargeInt);
begin
  TLargeintField(_Self).AsLargeInt := Value;
end;
function TLargeintField_GetValue:Largeint;
begin
  result := TLargeintField(_Self).Value;
end;
procedure TLargeintField_PutValue(const Value: Largeint);
begin
  TLargeintField(_Self).Value := Value;
end;
function TFloatField_GetValue:Double;
begin
  result := TFloatField(_Self).Value;
end;
procedure TFloatField_PutValue(const Value: Double);
begin
  TFloatField(_Self).Value := Value;
end;
function TBooleanField_GetValue:Boolean;
begin
  result := TBooleanField(_Self).Value;
end;
procedure TBooleanField_PutValue(const Value: Boolean);
begin
  TBooleanField(_Self).Value := Value;
end;
function TDateTimeField_GetValue:TDateTime;
begin
  result := TDateTimeField(_Self).Value;
end;
procedure TDateTimeField_PutValue(const Value: TDateTime);
begin
  TDateTimeField(_Self).Value := Value;
end;
function TBCDField_GetValue:Currency;
begin
  result := TBCDField(_Self).Value;
end;
procedure TBCDField_PutValue(const Value: Currency);
begin
  TBCDField(_Self).Value := Value;
end;
function TBlobField_GetBlobSize:Integer;
begin
  result := TBlobField(_Self).BlobSize;
end;
function TBlobField_GetModified:Boolean;
begin
  result := TBlobField(_Self).Modified;
end;
procedure TBlobField_PutModified(const Value: Boolean);
begin
  TBlobField(_Self).Modified := Value;
end;
function TBlobField_GetValue:String;
begin
  result := TBlobField(_Self).Value;
end;
procedure TBlobField_PutValue(const Value: String);
begin
  TBlobField(_Self).Value := Value;
end;
function TBlobField_GetTransliterate:Boolean;
begin
  result := TBlobField(_Self).Transliterate;
end;
procedure TBlobField_PutTransliterate(const Value: Boolean);
begin
  TBlobField(_Self).Transliterate := Value;
end;
function TObjectField_GetFieldCount:Integer;
begin
  result := TObjectField(_Self).FieldCount;
end;
function TObjectField_GetFields:TFields;
begin
  result := TObjectField(_Self).Fields;
end;
function TObjectField_GetFieldValues(Index: Integer):Variant;
begin
  result := TObjectField(_Self).FieldValues[Index];
end;
procedure TObjectField_PutFieldValues(Index: Integer;const Value: Variant);
begin
  TObjectField(_Self).FieldValues[Index] := Value;
end;
function TObjectField_GetUnNamed:Boolean;
begin
  result := TObjectField(_Self).UnNamed;
end;
function TDataSetField_GetNestedDataSet:TDataSet;
begin
  result := TDataSetField(_Self).NestedDataSet;
end;
function TInterfaceField_GetValue:IUnknown;
begin
  result := TInterfaceField(_Self).Value;
end;
procedure TInterfaceField_PutValue(const Value: IUnknown);
begin
  TInterfaceField(_Self).Value := Value;
end;
function TIDispatchField_GetValue:IDispatch;
begin
  result := TIDispatchField(_Self).Value;
end;
procedure TIDispatchField_PutValue(const Value: IDispatch);
begin
  TIDispatchField(_Self).Value := Value;
end;
function TGuidField_GetAsGuid:TGUID;
begin
  result := TGuidField(_Self).AsGuid;
end;
procedure TGuidField_PutAsGuid(const Value: TGUID);
begin
  TGuidField(_Self).AsGuid := Value;
end;
function TAggregateField_GetHandle:Pointer;
begin
  result := TAggregateField(_Self).Handle;
end;
procedure TAggregateField_PutHandle(const Value: Pointer);
begin
  TAggregateField(_Self).Handle := Value;
end;
function TAggregateField_GetResultType:TFieldType;
begin
  result := TAggregateField(_Self).ResultType;
end;
procedure TAggregateField_PutResultType(const Value: TFieldType);
begin
  TAggregateField(_Self).ResultType := Value;
end;
function TDataLink_GetActive:Boolean;
begin
  result := TDataLink(_Self).Active;
end;
function TDataLink_GetActiveRecord:Integer;
begin
  result := TDataLink(_Self).ActiveRecord;
end;
procedure TDataLink_PutActiveRecord(const Value: Integer);
begin
  TDataLink(_Self).ActiveRecord := Value;
end;
function TDataLink_GetBOF:Boolean;
begin
  result := TDataLink(_Self).BOF;
end;
function TDataLink_GetBufferCount:Integer;
begin
  result := TDataLink(_Self).BufferCount;
end;
procedure TDataLink_PutBufferCount(const Value: Integer);
begin
  TDataLink(_Self).BufferCount := Value;
end;
function TDataLink_GetDataSet:TDataSet;
begin
  result := TDataLink(_Self).DataSet;
end;
function TDataLink_GetDataSource:TDataSource;
begin
  result := TDataLink(_Self).DataSource;
end;
procedure TDataLink_PutDataSource(const Value: TDataSource);
begin
  TDataLink(_Self).DataSource := Value;
end;
function TDataLink_GetDataSourceFixed:Boolean;
begin
  result := TDataLink(_Self).DataSourceFixed;
end;
procedure TDataLink_PutDataSourceFixed(const Value: Boolean);
begin
  TDataLink(_Self).DataSourceFixed := Value;
end;
function TDataLink_GetEditing:Boolean;
begin
  result := TDataLink(_Self).Editing;
end;
function TDataLink_GetEof:Boolean;
begin
  result := TDataLink(_Self).Eof;
end;
function TDataLink_GetReadOnly:Boolean;
begin
  result := TDataLink(_Self).ReadOnly;
end;
procedure TDataLink_PutReadOnly(const Value: Boolean);
begin
  TDataLink(_Self).ReadOnly := Value;
end;
function TDataLink_GetRecordCount:Integer;
begin
  result := TDataLink(_Self).RecordCount;
end;
function TDetailDataLink_GetDetailDataSet:TDataSet;
begin
  result := TDetailDataLink(_Self).DetailDataSet;
end;
function TMasterDataLink_GetFieldNames:String;
begin
  result := TMasterDataLink(_Self).FieldNames;
end;
procedure TMasterDataLink_PutFieldNames(const Value: String);
begin
  TMasterDataLink(_Self).FieldNames := Value;
end;
function TMasterDataLink_GetFields:TList;
begin
  result := TMasterDataLink(_Self).Fields;
end;
function TDataSource_GetState:TDataSetState;
begin
  result := TDataSource(_Self).State;
end;
function TDataSetDesigner_GetDataSet:TDataSet;
begin
  result := TDataSetDesigner(_Self).DataSet;
end;
function TCheckConstraints_GetItems(Index: Integer):TCheckConstraint;
begin
  result := TCheckConstraints(_Self).Items[Index];
end;
procedure TCheckConstraints_PutItems(Index: Integer;const Value: TCheckConstraint);
begin
  TCheckConstraints(_Self).Items[Index] := Value;
end;
function TParam_GetAsBCD:Currency;
begin
  result := TParam(_Self).AsBCD;
end;
procedure TParam_PutAsBCD(const Value: Currency);
begin
  TParam(_Self).AsBCD := Value;
end;
function TParam_GetAsBlob:TBlobData;
begin
  result := TParam(_Self).AsBlob;
end;
procedure TParam_PutAsBlob(const Value: TBlobData);
begin
  TParam(_Self).AsBlob := Value;
end;
function TParam_GetAsBoolean:Boolean;
begin
  result := TParam(_Self).AsBoolean;
end;
procedure TParam_PutAsBoolean(const Value: Boolean);
begin
  TParam(_Self).AsBoolean := Value;
end;
function TParam_GetAsCurrency:Currency;
begin
  result := TParam(_Self).AsCurrency;
end;
procedure TParam_PutAsCurrency(const Value: Currency);
begin
  TParam(_Self).AsCurrency := Value;
end;
function TParam_GetAsDate:TDateTime;
begin
  result := TParam(_Self).AsDate;
end;
procedure TParam_PutAsDate(const Value: TDateTime);
begin
  TParam(_Self).AsDate := Value;
end;
function TParam_GetAsDateTime:TDateTime;
begin
  result := TParam(_Self).AsDateTime;
end;
procedure TParam_PutAsDateTime(const Value: TDateTime);
begin
  TParam(_Self).AsDateTime := Value;
end;
function TParam_GetAsFloat:Double;
begin
  result := TParam(_Self).AsFloat;
end;
procedure TParam_PutAsFloat(const Value: Double);
begin
  TParam(_Self).AsFloat := Value;
end;
function TParam_GetAsInteger:LongInt;
begin
  result := TParam(_Self).AsInteger;
end;
procedure TParam_PutAsInteger(const Value: LongInt);
begin
  TParam(_Self).AsInteger := Value;
end;
function TParam_GetAsSmallInt:LongInt;
begin
  result := TParam(_Self).AsSmallInt;
end;
procedure TParam_PutAsSmallInt(const Value: LongInt);
begin
  TParam(_Self).AsSmallInt := Value;
end;
function TParam_GetAsMemo:String;
begin
  result := TParam(_Self).AsMemo;
end;
procedure TParam_PutAsMemo(const Value: String);
begin
  TParam(_Self).AsMemo := Value;
end;
function TParam_GetAsString:String;
begin
  result := TParam(_Self).AsString;
end;
procedure TParam_PutAsString(const Value: String);
begin
  TParam(_Self).AsString := Value;
end;
function TParam_GetAsTime:TDateTime;
begin
  result := TParam(_Self).AsTime;
end;
procedure TParam_PutAsTime(const Value: TDateTime);
begin
  TParam(_Self).AsTime := Value;
end;
function TParam_GetAsWord:LongInt;
begin
  result := TParam(_Self).AsWord;
end;
procedure TParam_PutAsWord(const Value: LongInt);
begin
  TParam(_Self).AsWord := Value;
end;
function TParam_GetBound:Boolean;
begin
  result := TParam(_Self).Bound;
end;
procedure TParam_PutBound(const Value: Boolean);
begin
  TParam(_Self).Bound := Value;
end;
function TParam_GetIsNull:Boolean;
begin
  result := TParam(_Self).IsNull;
end;
function TParam_GetNativeStr:String;
begin
  result := TParam(_Self).NativeStr;
end;
procedure TParam_PutNativeStr(const Value: String);
begin
  TParam(_Self).NativeStr := Value;
end;
function TParam_GetText:String;
begin
  result := TParam(_Self).Text;
end;
procedure TParam_PutText(const Value: String);
begin
  TParam(_Self).Text := Value;
end;
function TParams_GetItems(Index: Integer):TParam;
begin
  result := TParams(_Self).Items[Index];
end;
procedure TParams_PutItems(Index: Integer;const Value: TParam);
begin
  TParams(_Self).Items[Index] := Value;
end;
function TParams_GetParamValues(const ParamName: string):Variant;
begin
  result := TParams(_Self).ParamValues[ParamName];
end;
procedure TParams_PutParamValues(const ParamName: string;const Value: Variant);
begin
  TParams(_Self).ParamValues[ParamName] := Value;
end;
function TDataSet_GetAggFields:TFields;
begin
  result := TDataSet(_Self).AggFields;
end;
function TDataSet_GetBof:Boolean;
begin
  result := TDataSet(_Self).Bof;
end;
function TDataSet_GetBookmark:TBookmarkStr;
begin
  result := TDataSet(_Self).Bookmark;
end;
procedure TDataSet_PutBookmark(const Value: TBookmarkStr);
begin
  TDataSet(_Self).Bookmark := Value;
end;
function TDataSet_GetCanModify:Boolean;
begin
  result := TDataSet(_Self).CanModify;
end;
function TDataSet_GetDataSetField:TDataSetField;
begin
  result := TDataSet(_Self).DataSetField;
end;
procedure TDataSet_PutDataSetField(const Value: TDataSetField);
begin
  TDataSet(_Self).DataSetField := Value;
end;
function TDataSet_GetDataSource:TDataSource;
begin
  result := TDataSet(_Self).DataSource;
end;
function TDataSet_GetDefaultFields:Boolean;
begin
  result := TDataSet(_Self).DefaultFields;
end;
function TDataSet_GetDesigner:TDataSetDesigner;
begin
  result := TDataSet(_Self).Designer;
end;
function TDataSet_GetEof:Boolean;
begin
  result := TDataSet(_Self).Eof;
end;
function TDataSet_GetBlockReadSize:Integer;
begin
  result := TDataSet(_Self).BlockReadSize;
end;
procedure TDataSet_PutBlockReadSize(const Value: Integer);
begin
  TDataSet(_Self).BlockReadSize := Value;
end;
function TDataSet_GetFieldCount:Integer;
begin
  result := TDataSet(_Self).FieldCount;
end;
function TDataSet_GetFieldDefs:TFieldDefs;
begin
  result := TDataSet(_Self).FieldDefs;
end;
procedure TDataSet_PutFieldDefs(const Value: TFieldDefs);
begin
  TDataSet(_Self).FieldDefs := Value;
end;
function TDataSet_GetFieldDefList:TFieldDefList;
begin
  result := TDataSet(_Self).FieldDefList;
end;
function TDataSet_GetFields:TFields;
begin
  result := TDataSet(_Self).Fields;
end;
function TDataSet_GetFieldList:TFieldList;
begin
  result := TDataSet(_Self).FieldList;
end;
function TDataSet_GetFieldValues(const FieldName: string):Variant;
begin
  result := TDataSet(_Self).FieldValues[FieldName];
end;
procedure TDataSet_PutFieldValues(const FieldName: string;const Value: Variant);
begin
  TDataSet(_Self).FieldValues[FieldName] := Value;
end;
function TDataSet_GetFound:Boolean;
begin
  result := TDataSet(_Self).Found;
end;
function TDataSet_GetModified:Boolean;
begin
  result := TDataSet(_Self).Modified;
end;
function TDataSet_GetObjectView:Boolean;
begin
  result := TDataSet(_Self).ObjectView;
end;
procedure TDataSet_PutObjectView(const Value: Boolean);
begin
  TDataSet(_Self).ObjectView := Value;
end;
function TDataSet_GetRecordCount:Integer;
begin
  result := TDataSet(_Self).RecordCount;
end;
function TDataSet_GetRecNo:Integer;
begin
  result := TDataSet(_Self).RecNo;
end;
procedure TDataSet_PutRecNo(const Value: Integer);
begin
  TDataSet(_Self).RecNo := Value;
end;
function TDataSet_GetRecordSize:Word;
begin
  result := TDataSet(_Self).RecordSize;
end;
function TDataSet_GetSparseArrays:Boolean;
begin
  result := TDataSet(_Self).SparseArrays;
end;
procedure TDataSet_PutSparseArrays(const Value: Boolean);
begin
  TDataSet(_Self).SparseArrays := Value;
end;
function TDataSet_GetState:TDataSetState;
begin
  result := TDataSet(_Self).State;
end;
function TDataSet_GetFilter:String;
begin
  result := TDataSet(_Self).Filter;
end;
procedure TDataSet_PutFilter(const Value: String);
begin
  TDataSet(_Self).Filter := Value;
end;
function TDataSet_GetFiltered:Boolean;
begin
  result := TDataSet(_Self).Filtered;
end;
procedure TDataSet_PutFiltered(const Value: Boolean);
begin
  TDataSet(_Self).Filtered := Value;
end;
function TDataSet_GetFilterOptions:TFilterOptions;
begin
  result := TDataSet(_Self).FilterOptions;
end;
procedure TDataSet_PutFilterOptions(const Value: TFilterOptions);
begin
  TDataSet(_Self).FilterOptions := Value;
end;
function TDataSet_GetActive:Boolean;
begin
  result := TDataSet(_Self).Active;
end;
procedure TDataSet_PutActive(const Value: Boolean);
begin
  TDataSet(_Self).Active := Value;
end;
function TDataSet_GetAutoCalcFields:Boolean;
begin
  result := TDataSet(_Self).AutoCalcFields;
end;
procedure TDataSet_PutAutoCalcFields(const Value: Boolean);
begin
  TDataSet(_Self).AutoCalcFields := Value;
end;
function TDataSet_GetBeforeOpen:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeOpen;
end;
procedure TDataSet_PutBeforeOpen(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeOpen := Value;
end;
function TDataSet_GetAfterOpen:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterOpen;
end;
procedure TDataSet_PutAfterOpen(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterOpen := Value;
end;
function TDataSet_GetBeforeClose:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeClose;
end;
procedure TDataSet_PutBeforeClose(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeClose := Value;
end;
function TDataSet_GetAfterClose:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterClose;
end;
procedure TDataSet_PutAfterClose(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterClose := Value;
end;
function TDataSet_GetBeforeInsert:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeInsert;
end;
procedure TDataSet_PutBeforeInsert(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeInsert := Value;
end;
function TDataSet_GetAfterInsert:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterInsert;
end;
procedure TDataSet_PutAfterInsert(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterInsert := Value;
end;
function TDataSet_GetBeforeEdit:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeEdit;
end;
procedure TDataSet_PutBeforeEdit(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeEdit := Value;
end;
function TDataSet_GetAfterEdit:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterEdit;
end;
procedure TDataSet_PutAfterEdit(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterEdit := Value;
end;
function TDataSet_GetBeforePost:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforePost;
end;
procedure TDataSet_PutBeforePost(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforePost := Value;
end;
function TDataSet_GetAfterPost:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterPost;
end;
procedure TDataSet_PutAfterPost(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterPost := Value;
end;
function TDataSet_GetBeforeCancel:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeCancel;
end;
procedure TDataSet_PutBeforeCancel(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeCancel := Value;
end;
function TDataSet_GetAfterCancel:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterCancel;
end;
procedure TDataSet_PutAfterCancel(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterCancel := Value;
end;
function TDataSet_GetBeforeDelete:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeDelete;
end;
procedure TDataSet_PutBeforeDelete(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeDelete := Value;
end;
function TDataSet_GetAfterDelete:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterDelete;
end;
procedure TDataSet_PutAfterDelete(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterDelete := Value;
end;
function TDataSet_GetBeforeScroll:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeScroll;
end;
procedure TDataSet_PutBeforeScroll(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeScroll := Value;
end;
function TDataSet_GetAfterScroll:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterScroll;
end;
procedure TDataSet_PutAfterScroll(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterScroll := Value;
end;
function TDataSet_GetBeforeRefresh:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).BeforeRefresh;
end;
procedure TDataSet_PutBeforeRefresh(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).BeforeRefresh := Value;
end;
function TDataSet_GetAfterRefresh:TDataSetNotifyEvent;
begin
  result := TDataSet(_Self).AfterRefresh;
end;
procedure TDataSet_PutAfterRefresh(const Value: TDataSetNotifyEvent);
begin
  TDataSet(_Self).AfterRefresh := Value;
end;
procedure RegisterIMP_db;
var H: Integer;
begin
  H := RegisterNamespace('db', -1);
  // Begin of class EUpdateError
  RegisterClassType(EUpdateError, H);
  RegisterMethod(EUpdateError,
       'constructor Create(NativeError, Context: string;      ErrCode, PrevError: Integer; E: Exception);',
       @EUpdateError.Create);
  RegisterMethod(EUpdateError,
       'destructor Destroy; override;',
       @EUpdateError.Destroy);
  RegisterMethod(EUpdateError,
       'function EUpdateError_GetContext:String;',
       @EUpdateError_GetContext, Fake);
  RegisterProperty(EUpdateError,
       'property Context:String read EUpdateError_GetContext;');
  RegisterMethod(EUpdateError,
       'function EUpdateError_GetErrorCode:Integer;',
       @EUpdateError_GetErrorCode, Fake);
  RegisterProperty(EUpdateError,
       'property ErrorCode:Integer read EUpdateError_GetErrorCode;');
  RegisterMethod(EUpdateError,
       'function EUpdateError_GetPreviousError:Integer;',
       @EUpdateError_GetPreviousError, Fake);
  RegisterProperty(EUpdateError,
       'property PreviousError:Integer read EUpdateError_GetPreviousError;');
  RegisterMethod(EUpdateError,
       'function EUpdateError_GetOriginalException:Exception;',
       @EUpdateError_GetOriginalException, Fake);
  RegisterProperty(EUpdateError,
       'property OriginalException:Exception read EUpdateError_GetOriginalException;');
  // End of class EUpdateError
  RegisterRTTIType(TypeInfo(TFieldType));
  RegisterRTTIType(TypeInfo(TDataSetState));
  RegisterRTTIType(TypeInfo(TDataEvent));
  RegisterRTTIType(TypeInfo(TUpdateStatus));
  RegisterRTTIType(TypeInfo(TUpdateAction));
  RegisterRTTIType(TypeInfo(TUpdateMode));
  RegisterRTTIType(TypeInfo(TUpdateKind));
  // Begin of class TCustomConnection
  RegisterClassType(TCustomConnection, H);
  RegisterMethod(TCustomConnection,
       'constructor Create(AOwner: TComponent); override;',
       @TCustomConnection.Create);
  RegisterMethod(TCustomConnection,
       'destructor Destroy; override;',
       @TCustomConnection.Destroy);
  RegisterMethod(TCustomConnection,
       'procedure Open; overload;',
       @TCustomConnection.Open);
  RegisterMethod(TCustomConnection,
       'procedure Close;',
       @TCustomConnection.Close);
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_GetConnected:Boolean;',
       @TCustomConnection_GetConnected, Fake);
  RegisterMethod(TCustomConnection,
       'procedure TCustomConnection_PutConnected(const Value: Boolean);',
       @TCustomConnection_PutConnected, Fake);
  RegisterProperty(TCustomConnection,
       'property Connected:Boolean read TCustomConnection_GetConnected write TCustomConnection_PutConnected;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_GetDataSets(Index: Integer):TDataSet;',
       @TCustomConnection_GetDataSets, Fake);
  RegisterProperty(TCustomConnection,
       'property DataSets[Index: Integer]:TDataSet read TCustomConnection_GetDataSets;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_GetDataSetCount:Integer;',
       @TCustomConnection_GetDataSetCount, Fake);
  RegisterProperty(TCustomConnection,
       'property DataSetCount:Integer read TCustomConnection_GetDataSetCount;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_GetLoginPrompt:Boolean;',
       @TCustomConnection_GetLoginPrompt, Fake);
  RegisterMethod(TCustomConnection,
       'procedure TCustomConnection_PutLoginPrompt(const Value: Boolean);',
       @TCustomConnection_PutLoginPrompt, Fake);
  RegisterProperty(TCustomConnection,
       'property LoginPrompt:Boolean read TCustomConnection_GetLoginPrompt write TCustomConnection_PutLoginPrompt;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_GetAfterConnect:TNotifyEvent;',
       @TCustomConnection_GetAfterConnect, Fake);

  RegisterMethod(TCustomConnection,
       'procedure TCustomConnection_PutAfterConnect(const Value: TNotifyEvent);',
       @TCustomConnection_PutAfterConnect, Fake);
  RegisterProperty(TCustomConnection,
       'property AfterConnect:TNotifyEvent read TCustomConnection_GetAfterConnect write TCustomConnection_PutAfterConnect;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_GetBeforeConnect:TNotifyEvent;',
       @TCustomConnection_GetBeforeConnect, Fake);
  RegisterMethod(TCustomConnection,
       'procedure TCustomConnection_PutBeforeConnect(const Value: TNotifyEvent);',
       @TCustomConnection_PutBeforeConnect, Fake);
  RegisterProperty(TCustomConnection,
       'property BeforeConnect:TNotifyEvent read TCustomConnection_GetBeforeConnect write TCustomConnection_PutBeforeConnect;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_GetAfterDisconnect:TNotifyEvent;',
       @TCustomConnection_GetAfterDisconnect, Fake);
  RegisterMethod(TCustomConnection,
       'procedure TCustomConnection_PutAfterDisconnect(const Value: TNotifyEvent);',
       @TCustomConnection_PutAfterDisconnect, Fake);
  RegisterProperty(TCustomConnection,
       'property AfterDisconnect:TNotifyEvent read TCustomConnection_GetAfterDisconnect write TCustomConnection_PutAfterDisconnect;');
  RegisterMethod(TCustomConnection,
       'function TCustomConnection_GetBeforeDisconnect:TNotifyEvent;',
       @TCustomConnection_GetBeforeDisconnect, Fake);
  RegisterMethod(TCustomConnection,
       'procedure TCustomConnection_PutBeforeDisconnect(const Value: TNotifyEvent);',
       @TCustomConnection_PutBeforeDisconnect, Fake);
  RegisterProperty(TCustomConnection,
       'property BeforeDisconnect:TNotifyEvent read TCustomConnection_GetBeforeDisconnect write TCustomConnection_PutBeforeDisconnect;');
  // End of class TCustomConnection
  // Begin of class TNamedItem
  RegisterClassType(TNamedItem, H);
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TNamedItem
  // Begin of class TDefCollection
  RegisterClassType(TDefCollection, H);
  RegisterMethod(TDefCollection,
       'constructor Create(ADataSet: TDataSet; AOwner: TPersistent;      AClass: TCollectionItemClass);',
       @TDefCollection.Create);
  RegisterMethod(TDefCollection,
       'function Find(const AName: string): TNamedItem;',
       @TDefCollection.Find);
  RegisterMethod(TDefCollection,
       'procedure GetItemNames(List: TStrings);',
       @TDefCollection.GetItemNames);
  RegisterMethod(TDefCollection,
       'function IndexOf(const AName: string): Integer;',
       @TDefCollection.IndexOf);
  RegisterMethod(TDefCollection,
       'function TDefCollection_GetDataSet:TDataSet;',
       @TDefCollection_GetDataSet, Fake);
  RegisterProperty(TDefCollection,
       'property DataSet:TDataSet read TDefCollection_GetDataSet;');
  RegisterMethod(TDefCollection,
       'function TDefCollection_GetUpdated:Boolean;',
       @TDefCollection_GetUpdated, Fake);
  RegisterMethod(TDefCollection,
       'procedure TDefCollection_PutUpdated(const Value: Boolean);',
       @TDefCollection_PutUpdated, Fake);
  RegisterProperty(TDefCollection,
       'property Updated:Boolean read TDefCollection_GetUpdated write TDefCollection_PutUpdated;');
  // End of class TDefCollection
  RegisterRTTIType(TypeInfo(TFieldAttribute));
  // Begin of class TFieldDef
  RegisterClassType(TFieldDef, H);
  RegisterMethod(TFieldDef,
       'constructor Create(Owner: TFieldDefs; const Name: string;      DataType: TFieldType; Size: Integer; Required: Boolean; FieldNo: Integer); reintroduce; overload;',
       @TFieldDef.Create);
  RegisterMethod(TFieldDef,
       'destructor Destroy; override;',
       @TFieldDef.Destroy);
  RegisterMethod(TFieldDef,
       'function AddChild: TFieldDef;',
       @TFieldDef.AddChild);
  RegisterMethod(TFieldDef,
       'procedure Assign(Source: TPersistent); override;',
       @TFieldDef.Assign);
  RegisterMethod(TFieldDef,
       'function HasChildDefs: Boolean;',
       @TFieldDef.HasChildDefs);
  RegisterMethod(TFieldDef,
       'function TFieldDef_GetFieldClass:TFieldClass;',
       @TFieldDef_GetFieldClass, Fake);
  RegisterProperty(TFieldDef,
       'property FieldClass:TFieldClass read TFieldDef_GetFieldClass;');
  RegisterMethod(TFieldDef,
       'function TFieldDef_GetFieldNo:Integer;',
       @TFieldDef_GetFieldNo, Fake);
  RegisterMethod(TFieldDef,
       'procedure TFieldDef_PutFieldNo(const Value: Integer);',
       @TFieldDef_PutFieldNo, Fake);
  RegisterProperty(TFieldDef,
       'property FieldNo:Integer read TFieldDef_GetFieldNo write TFieldDef_PutFieldNo;');
  RegisterMethod(TFieldDef,
       'function TFieldDef_GetInternalCalcField:Boolean;',
       @TFieldDef_GetInternalCalcField, Fake);
  RegisterMethod(TFieldDef,
       'procedure TFieldDef_PutInternalCalcField(const Value: Boolean);',
       @TFieldDef_PutInternalCalcField, Fake);
  RegisterProperty(TFieldDef,
       'property InternalCalcField:Boolean read TFieldDef_GetInternalCalcField write TFieldDef_PutInternalCalcField;');
  RegisterMethod(TFieldDef,
       'function TFieldDef_GetParentDef:TFieldDef;',
       @TFieldDef_GetParentDef, Fake);
  RegisterProperty(TFieldDef,
       'property ParentDef:TFieldDef read TFieldDef_GetParentDef;');
  RegisterMethod(TFieldDef,
       'function TFieldDef_GetRequired:Boolean;',
       @TFieldDef_GetRequired, Fake);
  RegisterMethod(TFieldDef,
       'procedure TFieldDef_PutRequired(const Value: Boolean);',
       @TFieldDef_PutRequired, Fake);
  RegisterProperty(TFieldDef,
       'property Required:Boolean read TFieldDef_GetRequired write TFieldDef_PutRequired;');
  // End of class TFieldDef
  // Begin of class TFieldDefs
  RegisterClassType(TFieldDefs, H);
  RegisterMethod(TFieldDefs,
       'constructor Create(AOwner: TPersistent);',
       @TFieldDefs.Create);
  RegisterMethod(TFieldDefs,
       'function AddFieldDef: TFieldDef;',
       @TFieldDefs.AddFieldDef);
  RegisterMethod(TFieldDefs,
       'function Find(const Name: string): TFieldDef;',
       @TFieldDefs.Find);
  RegisterMethod(TFieldDefs,
       'procedure Update; reintroduce;',
       @TFieldDefs.Update);
  RegisterMethod(TFieldDefs,
       'function TFieldDefs_GetHiddenFields:Boolean;',
       @TFieldDefs_GetHiddenFields, Fake);
  RegisterMethod(TFieldDefs,
       'procedure TFieldDefs_PutHiddenFields(const Value: Boolean);',
       @TFieldDefs_PutHiddenFields, Fake);
  RegisterProperty(TFieldDefs,
       'property HiddenFields:Boolean read TFieldDefs_GetHiddenFields write TFieldDefs_PutHiddenFields;');
  RegisterMethod(TFieldDefs,
       'function TFieldDefs_GetItems(Index: Integer):TFieldDef;',
       @TFieldDefs_GetItems, Fake);
  RegisterMethod(TFieldDefs,
       'procedure TFieldDefs_PutItems(Index: Integer;const Value: TFieldDef);',
       @TFieldDefs_PutItems, Fake);
  RegisterProperty(TFieldDefs,
       'property Items[Index: Integer]:TFieldDef read TFieldDefs_GetItems write TFieldDefs_PutItems;default;');
  RegisterMethod(TFieldDefs,
       'function TFieldDefs_GetParentDef:TFieldDef;',
       @TFieldDefs_GetParentDef, Fake);
  RegisterProperty(TFieldDefs,
       'property ParentDef:TFieldDef read TFieldDefs_GetParentDef;');
  // End of class TFieldDefs
  RegisterRTTIType(TypeInfo(TIndexOption));
  // Begin of class TIndexDef
  RegisterClassType(TIndexDef, H);
  RegisterMethod(TIndexDef,
       'constructor Create(Owner: TIndexDefs; const Name, Fields: string;      Options: TIndexOptions); reintroduce; overload;',
       @TIndexDef.Create);
  RegisterMethod(TIndexDef,
       'procedure Assign(ASource: TPersistent); override;',
       @TIndexDef.Assign);
  RegisterMethod(TIndexDef,
       'function TIndexDef_GetFieldExpression:String;',
       @TIndexDef_GetFieldExpression, Fake);
  RegisterProperty(TIndexDef,
       'property FieldExpression:String read TIndexDef_GetFieldExpression;');
  // End of class TIndexDef
  // Begin of class TIndexDefs
  RegisterClassType(TIndexDefs, H);
  RegisterMethod(TIndexDefs,
       'constructor Create(ADataSet: TDataSet);',
       @TIndexDefs.Create);
  RegisterMethod(TIndexDefs,
       'function AddIndexDef: TIndexDef;',
       @TIndexDefs.AddIndexDef);
  RegisterMethod(TIndexDefs,
       'function Find(const Name: string): TIndexDef;',
       @TIndexDefs.Find);
  RegisterMethod(TIndexDefs,
       'procedure Update; reintroduce;',
       @TIndexDefs.Update);
  RegisterMethod(TIndexDefs,
       'function FindIndexForFields(const Fields: string): TIndexDef;',
       @TIndexDefs.FindIndexForFields);
  RegisterMethod(TIndexDefs,
       'function GetIndexForFields(const Fields: string;      CaseInsensitive: Boolean): TIndexDef;',
       @TIndexDefs.GetIndexForFields);
  RegisterMethod(TIndexDefs,
       'procedure Add(const Name, Fields: string; Options: TIndexOptions);',
       @TIndexDefs.Add);
  RegisterMethod(TIndexDefs,
       'function TIndexDefs_GetItems(Index: Integer):TIndexDef;',
       @TIndexDefs_GetItems, Fake);
  RegisterMethod(TIndexDefs,
       'procedure TIndexDefs_PutItems(Index: Integer;const Value: TIndexDef);',
       @TIndexDefs_PutItems, Fake);
  RegisterProperty(TIndexDefs,
       'property Items[Index: Integer]:TIndexDef read TIndexDefs_GetItems write TIndexDefs_PutItems;default;');
  // End of class TIndexDefs
  // Begin of class TFlatList
  RegisterClassType(TFlatList, H);
  RegisterMethod(TFlatList,
       'constructor Create(ADataSet: TDataSet);',
       @TFlatList.Create);
  RegisterMethod(TFlatList,
       'procedure Update;',
       @TFlatList.Update);
  RegisterMethod(TFlatList,
       'function TFlatList_GetDataSet:TDataSet;',
       @TFlatList_GetDataSet, Fake);
  RegisterProperty(TFlatList,
       'property DataSet:TDataSet read TFlatList_GetDataSet;');
  // End of class TFlatList
  // Begin of class TFieldDefList
  RegisterClassType(TFieldDefList, H);
  RegisterMethod(TFieldDefList,
       'function FieldByName(const Name: string): TFieldDef;',
       @TFieldDefList.FieldByName);
  RegisterMethod(TFieldDefList,
       'function Find(const Name: string): TFieldDef; reintroduce;',
       @TFieldDefList.Find);
  RegisterMethod(TFieldDefList,
       'function TFieldDefList_GetFieldDefs(Index: Integer):TFieldDef;',
       @TFieldDefList_GetFieldDefs, Fake);
  RegisterProperty(TFieldDefList,
       'property FieldDefs[Index: Integer]:TFieldDef read TFieldDefList_GetFieldDefs;default;');
  RegisterMethod(TFieldDefList,
       'constructor Create(ADataSet: TDataSet);',
       @TFieldDefList.Create);
  // End of class TFieldDefList
  // Begin of class TFieldList
  RegisterClassType(TFieldList, H);
  RegisterMethod(TFieldList,
       'function FieldByName(const Name: string): TField;',
       @TFieldList.FieldByName);
  RegisterMethod(TFieldList,
       'function Find(const Name: string): TField; reintroduce;',
       @TFieldList.Find);
  RegisterMethod(TFieldList,
       'function TFieldList_GetFields(Index: Integer):TField;',
       @TFieldList_GetFields, Fake);
  RegisterProperty(TFieldList,
       'property Fields[Index: Integer]:TField read TFieldList_GetFields;default;');
  RegisterMethod(TFieldList,
       'constructor Create(ADataSet: TDataSet);',
       @TFieldList.Create);
  // End of class TFieldList
  RegisterRTTIType(TypeInfo(TFieldKind));
  // Begin of class TFields
  RegisterClassType(TFields, H);
  RegisterMethod(TFields,
       'constructor Create(ADataSet: TDataSet);',
       @TFields.Create);
  RegisterMethod(TFields,
       'destructor Destroy; override;',
       @TFields.Destroy);
  RegisterMethod(TFields,
       'procedure Add(Field: TField);',
       @TFields.Add);
  RegisterMethod(TFields,
       'procedure CheckFieldName(const FieldName: string);',
       @TFields.CheckFieldName);
  RegisterMethod(TFields,
       'procedure CheckFieldNames(const FieldNames: string);',
       @TFields.CheckFieldNames);
  RegisterMethod(TFields,
       'procedure Clear;',
       @TFields.Clear);
  RegisterMethod(TFields,
       'function FindField(const FieldName: string): TField;',
       @TFields.FindField);
  RegisterMethod(TFields,
       'function FieldByName(const FieldName: string): TField;',
       @TFields.FieldByName);
  RegisterMethod(TFields,
       'function FieldByNumber(FieldNo: Integer): TField;',
       @TFields.FieldByNumber);
  RegisterMethod(TFields,
       'procedure GetFieldNames(List: TStrings);',
       @TFields.GetFieldNames);
  RegisterMethod(TFields,
       'function IndexOf(Field: TField): Integer;',
       @TFields.IndexOf);
  RegisterMethod(TFields,
       'procedure Remove(Field: TField);',
       @TFields.Remove);
  RegisterMethod(TFields,
       'function TFields_GetCount:Integer;',
       @TFields_GetCount, Fake);
  RegisterProperty(TFields,
       'property Count:Integer read TFields_GetCount;');
  RegisterMethod(TFields,
       'function TFields_GetDataSet:TDataSet;',
       @TFields_GetDataSet, Fake);
  RegisterProperty(TFields,
       'property DataSet:TDataSet read TFields_GetDataSet;');
  RegisterMethod(TFields,
       'function TFields_GetFields(Index: Integer):TField;',
       @TFields_GetFields, Fake);
  RegisterMethod(TFields,
       'procedure TFields_PutFields(Index: Integer;const Value: TField);',
       @TFields_PutFields, Fake);
  RegisterProperty(TFields,
       'property Fields[Index: Integer]:TField read TFields_GetFields write TFields_PutFields;default;');
  // End of class TFields
  RegisterRTTIType(TypeInfo(TProviderFlag));
  RegisterRTTIType(TypeInfo(TAutoRefreshFlag));
  // Begin of class TLookupList
  RegisterClassType(TLookupList, H);
  RegisterMethod(TLookupList,
       'constructor Create;',
       @TLookupList.Create);
  RegisterMethod(TLookupList,
       'destructor Destroy; override;',
       @TLookupList.Destroy);
  RegisterMethod(TLookupList,
       'procedure Add(const AKey, AValue: Variant);',
       @TLookupList.Add);
  RegisterMethod(TLookupList,
       'procedure Clear;',
       @TLookupList.Clear);
  RegisterMethod(TLookupList,
       'function ValueOfKey(const AKey: Variant): Variant;',
       @TLookupList.ValueOfKey);
  // End of class TLookupList
  // Begin of class TField
  RegisterClassType(TField, H);
  RegisterMethod(TField,
       'constructor Create(AOwner: TComponent); override;',
       @TField.Create);
  RegisterMethod(TField,
       'destructor Destroy; override;',
       @TField.Destroy);
  RegisterMethod(TField,
       'procedure Assign(Source: TPersistent); override;',
       @TField.Assign);
  RegisterMethod(TField,
       'procedure AssignValue(const Value: TVarRec);',
       @TField.AssignValue);
  RegisterMethod(TField,
       'procedure Clear; virtual;',
       @TField.Clear);
  RegisterMethod(TField,
       'procedure FocusControl;',
       @TField.FocusControl);
  RegisterMethod(TField,
       'function GetParentComponent: TComponent; override;',
       @TField.GetParentComponent);
  RegisterMethod(TField,
       'function HasParent: Boolean; override;',
       @TField.HasParent);
  RegisterMethod(TField,
       'function IsBlob: Boolean; virtual;',
       @TField.IsBlob);
  RegisterMethod(TField,
       'function IsValidChar(InputChar: Char): Boolean; virtual;',
       @TField.IsValidChar);
  RegisterMethod(TField,
       'procedure RefreshLookupList;',
       @TField.RefreshLookupList);
  RegisterMethod(TField,
       'procedure SetFieldType(Value: TFieldType); virtual;',
       @TField.SetFieldType);
  RegisterMethod(TField,
       'procedure Validate(Buffer: Pointer);',
       @TField.Validate);
  RegisterMethod(TField,
       'function TField_GetAsBoolean:Boolean;',
       @TField_GetAsBoolean, Fake);
  RegisterMethod(TField,
       'procedure TField_PutAsBoolean(const Value: Boolean);',
       @TField_PutAsBoolean, Fake);
  RegisterProperty(TField,
       'property AsBoolean:Boolean read TField_GetAsBoolean write TField_PutAsBoolean;');
  RegisterMethod(TField,
       'function TField_GetAsCurrency:Currency;',
       @TField_GetAsCurrency, Fake);
  RegisterMethod(TField,
       'procedure TField_PutAsCurrency(const Value: Currency);',
       @TField_PutAsCurrency, Fake);
  RegisterProperty(TField,
       'property AsCurrency:Currency read TField_GetAsCurrency write TField_PutAsCurrency;');
  RegisterMethod(TField,
       'function TField_GetAsDateTime:TDateTime;',
       @TField_GetAsDateTime, Fake);
  RegisterMethod(TField,
       'procedure TField_PutAsDateTime(const Value: TDateTime);',
       @TField_PutAsDateTime, Fake);
  RegisterProperty(TField,
       'property AsDateTime:TDateTime read TField_GetAsDateTime write TField_PutAsDateTime;');
  RegisterMethod(TField,
       'function TField_GetAsFloat:Double;',
       @TField_GetAsFloat, Fake);
  RegisterMethod(TField,
       'procedure TField_PutAsFloat(const Value: Double);',
       @TField_PutAsFloat, Fake);
  RegisterProperty(TField,
       'property AsFloat:Double read TField_GetAsFloat write TField_PutAsFloat;');
  RegisterMethod(TField,
       'function TField_GetAsInteger:Longint;',
       @TField_GetAsInteger, Fake);
  RegisterMethod(TField,
       'procedure TField_PutAsInteger(const Value: Longint);',
       @TField_PutAsInteger, Fake);
  RegisterProperty(TField,
       'property AsInteger:Longint read TField_GetAsInteger write TField_PutAsInteger;');
  RegisterMethod(TField,
       'function TField_GetAsString:String;',
       @TField_GetAsString, Fake);
  RegisterMethod(TField,
       'procedure TField_PutAsString(const Value: String);',
       @TField_PutAsString, Fake);
  RegisterProperty(TField,
       'property AsString:String read TField_GetAsString write TField_PutAsString;');
  RegisterMethod(TField,
       'function TField_GetAsVariant:Variant;',
       @TField_GetAsVariant, Fake);
  RegisterMethod(TField,
       'procedure TField_PutAsVariant(const Value: Variant);',
       @TField_PutAsVariant, Fake);
  RegisterProperty(TField,
       'property AsVariant:Variant read TField_GetAsVariant write TField_PutAsVariant;');
  RegisterMethod(TField,
       'function TField_GetAttributeSet:String;',
       @TField_GetAttributeSet, Fake);
  RegisterMethod(TField,
       'procedure TField_PutAttributeSet(const Value: String);',
       @TField_PutAttributeSet, Fake);
  RegisterProperty(TField,
       'property AttributeSet:String read TField_GetAttributeSet write TField_PutAttributeSet;');
  RegisterMethod(TField,
       'function TField_GetCalculated:Boolean;',
       @TField_GetCalculated, Fake);
  RegisterMethod(TField,
       'procedure TField_PutCalculated(const Value: Boolean);',
       @TField_PutCalculated, Fake);
  RegisterProperty(TField,
       'property Calculated:Boolean read TField_GetCalculated write TField_PutCalculated;');
  RegisterMethod(TField,
       'function TField_GetCanModify:Boolean;',
       @TField_GetCanModify, Fake);
  RegisterProperty(TField,
       'property CanModify:Boolean read TField_GetCanModify;');
  RegisterMethod(TField,
       'function TField_GetCurValue:Variant;',
       @TField_GetCurValue, Fake);
  RegisterProperty(TField,
       'property CurValue:Variant read TField_GetCurValue;');
  RegisterMethod(TField,
       'function TField_GetDataSet:TDataSet;',
       @TField_GetDataSet, Fake);
  RegisterMethod(TField,
       'procedure TField_PutDataSet(const Value: TDataSet);',
       @TField_PutDataSet, Fake);
  RegisterProperty(TField,
       'property DataSet:TDataSet read TField_GetDataSet write TField_PutDataSet;');
  RegisterMethod(TField,
       'function TField_GetDataSize:Integer;',
       @TField_GetDataSize, Fake);
  RegisterProperty(TField,
       'property DataSize:Integer read TField_GetDataSize;');
  RegisterMethod(TField,
       'function TField_GetDataType:TFieldType;',
       @TField_GetDataType, Fake);
  RegisterProperty(TField,
       'property DataType:TFieldType read TField_GetDataType;');
  RegisterMethod(TField,
       'function TField_GetDisplayName:String;',
       @TField_GetDisplayName, Fake);
  RegisterProperty(TField,
       'property DisplayName:String read TField_GetDisplayName;');
  RegisterMethod(TField,
       'function TField_GetDisplayText:String;',
       @TField_GetDisplayText, Fake);
  RegisterProperty(TField,
       'property DisplayText:String read TField_GetDisplayText;');
  RegisterMethod(TField,
       'function TField_GetEditMask:String;',
       @TField_GetEditMask, Fake);
  RegisterMethod(TField,
       'procedure TField_PutEditMask(const Value: String);',
       @TField_PutEditMask, Fake);
  RegisterProperty(TField,
       'property EditMask:String read TField_GetEditMask write TField_PutEditMask;');
  RegisterMethod(TField,
       'function TField_GetEditMaskPtr:String;',
       @TField_GetEditMaskPtr, Fake);
  RegisterProperty(TField,
       'property EditMaskPtr:String read TField_GetEditMaskPtr;');
  RegisterMethod(TField,
       'function TField_GetFieldNo:Integer;',
       @TField_GetFieldNo, Fake);
  RegisterProperty(TField,
       'property FieldNo:Integer read TField_GetFieldNo;');
  RegisterMethod(TField,
       'function TField_GetFullName:String;',
       @TField_GetFullName, Fake);
  RegisterProperty(TField,
       'property FullName:String read TField_GetFullName;');
  RegisterMethod(TField,
       'function TField_GetIsIndexField:Boolean;',
       @TField_GetIsIndexField, Fake);
  RegisterProperty(TField,
       'property IsIndexField:Boolean read TField_GetIsIndexField;');
  RegisterMethod(TField,
       'function TField_GetIsNull:Boolean;',
       @TField_GetIsNull, Fake);
  RegisterProperty(TField,
       'property IsNull:Boolean read TField_GetIsNull;');
  RegisterMethod(TField,
       'function TField_GetLookup:Boolean;',
       @TField_GetLookup, Fake);
  RegisterMethod(TField,
       'procedure TField_PutLookup(const Value: Boolean);',
       @TField_PutLookup, Fake);
  RegisterProperty(TField,
       'property Lookup:Boolean read TField_GetLookup write TField_PutLookup;');
  RegisterMethod(TField,
       'function TField_GetLookupList:TLookupList;',
       @TField_GetLookupList, Fake);
  RegisterProperty(TField,
       'property LookupList:TLookupList read TField_GetLookupList;');
  RegisterMethod(TField,
       'function TField_GetNewValue:Variant;',
       @TField_GetNewValue, Fake);
  RegisterMethod(TField,
       'procedure TField_PutNewValue(const Value: Variant);',
       @TField_PutNewValue, Fake);
  RegisterProperty(TField,
       'property NewValue:Variant read TField_GetNewValue write TField_PutNewValue;');
  RegisterMethod(TField,
       'function TField_GetOffset:Integer;',
       @TField_GetOffset, Fake);
  RegisterProperty(TField,
       'property Offset:Integer read TField_GetOffset;');
  RegisterMethod(TField,
       'function TField_GetOldValue:Variant;',
       @TField_GetOldValue, Fake);
  RegisterProperty(TField,
       'property OldValue:Variant read TField_GetOldValue;');
  RegisterMethod(TField,
       'function TField_GetParentField:TObjectField;',
       @TField_GetParentField, Fake);
  RegisterMethod(TField,
       'procedure TField_PutParentField(const Value: TObjectField);',
       @TField_PutParentField, Fake);
  RegisterProperty(TField,
       'property ParentField:TObjectField read TField_GetParentField write TField_PutParentField;');
  RegisterMethod(TField,
       'function TField_GetSize:Integer;',
       @TField_GetSize, Fake);
  RegisterMethod(TField,
       'procedure TField_PutSize(const Value: Integer);',
       @TField_PutSize, Fake);
  RegisterProperty(TField,
       'property Size:Integer read TField_GetSize write TField_PutSize;');
  RegisterMethod(TField,
       'function TField_GetText:String;',
       @TField_GetText, Fake);
  RegisterMethod(TField,
       'procedure TField_PutText(const Value: String);',
       @TField_PutText, Fake);
  RegisterProperty(TField,
       'property Text:String read TField_GetText write TField_PutText;');
  RegisterMethod(TField,
       'function TField_GetValidChars:TFieldChars;',
       @TField_GetValidChars, Fake);
  RegisterMethod(TField,
       'procedure TField_PutValidChars(const Value: TFieldChars);',
       @TField_PutValidChars, Fake);
  RegisterProperty(TField,
       'property ValidChars:TFieldChars read TField_GetValidChars write TField_PutValidChars;');
  RegisterMethod(TField,
       'function TField_GetValue:Variant;',
       @TField_GetValue, Fake);
  RegisterMethod(TField,
       'procedure TField_PutValue(const Value: Variant);',
       @TField_PutValue, Fake);
  RegisterProperty(TField,
       'property Value:Variant read TField_GetValue write TField_PutValue;');
  // End of class TField
  // Begin of class TStringField
  RegisterClassType(TStringField, H);
  RegisterMethod(TStringField,
       'constructor Create(AOwner: TComponent); override;',
       @TStringField.Create);
  RegisterMethod(TStringField,
       'function TStringField_GetValue:String;',
       @TStringField_GetValue, Fake);
  RegisterMethod(TStringField,
       'procedure TStringField_PutValue(const Value: String);',
       @TStringField_PutValue, Fake);
  RegisterProperty(TStringField,
       'property Value:String read TStringField_GetValue write TStringField_PutValue;');
  // End of class TStringField
  // Begin of class TWideStringField
  RegisterClassType(TWideStringField, H);
  RegisterMethod(TWideStringField,
       'constructor Create(AOwner: TComponent); override;',
       @TWideStringField.Create);
  RegisterMethod(TWideStringField,
       'function TWideStringField_GetValue:WideString;',
       @TWideStringField_GetValue, Fake);
  RegisterMethod(TWideStringField,
       'procedure TWideStringField_PutValue(const Value: WideString);',
       @TWideStringField_PutValue, Fake);
  RegisterProperty(TWideStringField,
       'property Value:WideString read TWideStringField_GetValue write TWideStringField_PutValue;');
  // End of class TWideStringField
  // Begin of class TNumericField
  RegisterClassType(TNumericField, H);
  RegisterMethod(TNumericField,
       'constructor Create(AOwner: TComponent); override;',
       @TNumericField.Create);
  // End of class TNumericField
  // Begin of class TIntegerField
  RegisterClassType(TIntegerField, H);
  RegisterMethod(TIntegerField,
       'constructor Create(AOwner: TComponent); override;',
       @TIntegerField.Create);
  RegisterMethod(TIntegerField,
       'function TIntegerField_GetValue:Longint;',
       @TIntegerField_GetValue, Fake);
  RegisterMethod(TIntegerField,
       'procedure TIntegerField_PutValue(const Value: Longint);',
       @TIntegerField_PutValue, Fake);
  RegisterProperty(TIntegerField,
       'property Value:Longint read TIntegerField_GetValue write TIntegerField_PutValue;');
  // End of class TIntegerField
  // Begin of class TSmallintField
  RegisterClassType(TSmallintField, H);
  RegisterMethod(TSmallintField,
       'constructor Create(AOwner: TComponent); override;',
       @TSmallintField.Create);
  // End of class TSmallintField
  // Begin of class TLargeintField
  RegisterClassType(TLargeintField, H);
  RegisterMethod(TLargeintField,
       'constructor Create(AOwner: TComponent); override;',
       @TLargeintField.Create);
  RegisterMethod(TLargeintField,
       'function TLargeintField_GetAsLargeInt:LargeInt;',
       @TLargeintField_GetAsLargeInt, Fake);
  RegisterMethod(TLargeintField,
       'procedure TLargeintField_PutAsLargeInt(const Value: LargeInt);',
       @TLargeintField_PutAsLargeInt, Fake);
  RegisterProperty(TLargeintField,
       'property AsLargeInt:LargeInt read TLargeintField_GetAsLargeInt write TLargeintField_PutAsLargeInt;');
  RegisterMethod(TLargeintField,
       'function TLargeintField_GetValue:Largeint;',
       @TLargeintField_GetValue, Fake);
  RegisterMethod(TLargeintField,
       'procedure TLargeintField_PutValue(const Value: Largeint);',
       @TLargeintField_PutValue, Fake);
  RegisterProperty(TLargeintField,
       'property Value:Largeint read TLargeintField_GetValue write TLargeintField_PutValue;');
  // End of class TLargeintField
  // Begin of class TWordField
  RegisterClassType(TWordField, H);
  RegisterMethod(TWordField,
       'constructor Create(AOwner: TComponent); override;',
       @TWordField.Create);
  // End of class TWordField
  // Begin of class TAutoIncField
  RegisterClassType(TAutoIncField, H);
  RegisterMethod(TAutoIncField,
       'constructor Create(AOwner: TComponent); override;',
       @TAutoIncField.Create);
  // End of class TAutoIncField
  // Begin of class TFloatField
  RegisterClassType(TFloatField, H);
  RegisterMethod(TFloatField,
       'constructor Create(AOwner: TComponent); override;',
       @TFloatField.Create);
  RegisterMethod(TFloatField,
       'function TFloatField_GetValue:Double;',
       @TFloatField_GetValue, Fake);
  RegisterMethod(TFloatField,
       'procedure TFloatField_PutValue(const Value: Double);',
       @TFloatField_PutValue, Fake);
  RegisterProperty(TFloatField,
       'property Value:Double read TFloatField_GetValue write TFloatField_PutValue;');
  // End of class TFloatField
  // Begin of class TCurrencyField
  RegisterClassType(TCurrencyField, H);
  RegisterMethod(TCurrencyField,
       'constructor Create(AOwner: TComponent); override;',
       @TCurrencyField.Create);
  // End of class TCurrencyField
  // Begin of class TBooleanField
  RegisterClassType(TBooleanField, H);
  RegisterMethod(TBooleanField,
       'constructor Create(AOwner: TComponent); override;',
       @TBooleanField.Create);
  RegisterMethod(TBooleanField,
       'function TBooleanField_GetValue:Boolean;',
       @TBooleanField_GetValue, Fake);
  RegisterMethod(TBooleanField,
       'procedure TBooleanField_PutValue(const Value: Boolean);',
       @TBooleanField_PutValue, Fake);
  RegisterProperty(TBooleanField,
       'property Value:Boolean read TBooleanField_GetValue write TBooleanField_PutValue;');
  // End of class TBooleanField
  // Begin of class TDateTimeField
  RegisterClassType(TDateTimeField, H);
  RegisterMethod(TDateTimeField,
       'constructor Create(AOwner: TComponent); override;',
       @TDateTimeField.Create);
  RegisterMethod(TDateTimeField,
       'function TDateTimeField_GetValue:TDateTime;',
       @TDateTimeField_GetValue, Fake);
  RegisterMethod(TDateTimeField,
       'procedure TDateTimeField_PutValue(const Value: TDateTime);',
       @TDateTimeField_PutValue, Fake);
  RegisterProperty(TDateTimeField,
       'property Value:TDateTime read TDateTimeField_GetValue write TDateTimeField_PutValue;');
  // End of class TDateTimeField
  // Begin of class TDateField
  RegisterClassType(TDateField, H);
  RegisterMethod(TDateField,
       'constructor Create(AOwner: TComponent); override;',
       @TDateField.Create);
  // End of class TDateField
  // Begin of class TTimeField
  RegisterClassType(TTimeField, H);
  RegisterMethod(TTimeField,
       'constructor Create(AOwner: TComponent); override;',
       @TTimeField.Create);
  // End of class TTimeField
  // Begin of class TBinaryField
  RegisterClassType(TBinaryField, H);
  RegisterMethod(TBinaryField,
       'constructor Create(AOwner: TComponent); override;',
       @TBinaryField.Create);
  // End of class TBinaryField
  // Begin of class TBytesField
  RegisterClassType(TBytesField, H);
  RegisterMethod(TBytesField,
       'constructor Create(AOwner: TComponent); override;',
       @TBytesField.Create);
  // End of class TBytesField
  // Begin of class TVarBytesField
  RegisterClassType(TVarBytesField, H);
  RegisterMethod(TVarBytesField,
       'constructor Create(AOwner: TComponent); override;',
       @TVarBytesField.Create);
  // End of class TVarBytesField
  // Begin of class TBCDField
  RegisterClassType(TBCDField, H);
  RegisterMethod(TBCDField,
       'constructor Create(AOwner: TComponent); override;',
       @TBCDField.Create);
  RegisterMethod(TBCDField,
       'function TBCDField_GetValue:Currency;',
       @TBCDField_GetValue, Fake);
  RegisterMethod(TBCDField,
       'procedure TBCDField_PutValue(const Value: Currency);',
       @TBCDField_PutValue, Fake);
  RegisterProperty(TBCDField,
       'property Value:Currency read TBCDField_GetValue write TBCDField_PutValue;');
  // End of class TBCDField
  // Begin of class TBlobField
  RegisterClassType(TBlobField, H);
  RegisterMethod(TBlobField,
       'constructor Create(AOwner: TComponent); override;',
       @TBlobField.Create);
  RegisterMethod(TBlobField,
       'procedure Assign(Source: TPersistent); override;',
       @TBlobField.Assign);
  RegisterMethod(TBlobField,
       'procedure Clear; override;',
       @TBlobField.Clear);
  RegisterMethod(TBlobField,
       'function IsBlob: Boolean; override;',
       @TBlobField.IsBlob);
  RegisterMethod(TBlobField,
       'procedure LoadFromFile(const FileName: string);',
       @TBlobField.LoadFromFile);
  RegisterMethod(TBlobField,
       'procedure LoadFromStream(Stream: TStream);',
       @TBlobField.LoadFromStream);
  RegisterMethod(TBlobField,
       'procedure SaveToFile(const FileName: string);',
       @TBlobField.SaveToFile);
  RegisterMethod(TBlobField,
       'procedure SaveToStream(Stream: TStream);',
       @TBlobField.SaveToStream);
  RegisterMethod(TBlobField,
       'procedure SetFieldType(Value: TFieldType); override;',
       @TBlobField.SetFieldType);
  RegisterMethod(TBlobField,
       'function TBlobField_GetBlobSize:Integer;',
       @TBlobField_GetBlobSize, Fake);
  RegisterProperty(TBlobField,
       'property BlobSize:Integer read TBlobField_GetBlobSize;');
  RegisterMethod(TBlobField,
       'function TBlobField_GetModified:Boolean;',
       @TBlobField_GetModified, Fake);
  RegisterMethod(TBlobField,
       'procedure TBlobField_PutModified(const Value: Boolean);',
       @TBlobField_PutModified, Fake);
  RegisterProperty(TBlobField,
       'property Modified:Boolean read TBlobField_GetModified write TBlobField_PutModified;');
  RegisterMethod(TBlobField,
       'function TBlobField_GetValue:String;',
       @TBlobField_GetValue, Fake);
  RegisterMethod(TBlobField,
       'procedure TBlobField_PutValue(const Value: String);',
       @TBlobField_PutValue, Fake);
  RegisterProperty(TBlobField,
       'property Value:String read TBlobField_GetValue write TBlobField_PutValue;');
  RegisterMethod(TBlobField,
       'function TBlobField_GetTransliterate:Boolean;',
       @TBlobField_GetTransliterate, Fake);
  RegisterMethod(TBlobField,
       'procedure TBlobField_PutTransliterate(const Value: Boolean);',
       @TBlobField_PutTransliterate, Fake);
  RegisterProperty(TBlobField,
       'property Transliterate:Boolean read TBlobField_GetTransliterate write TBlobField_PutTransliterate;');
  // End of class TBlobField
  // Begin of class TMemoField
  RegisterClassType(TMemoField, H);
  RegisterMethod(TMemoField,
       'constructor Create(AOwner: TComponent); override;',
       @TMemoField.Create);
  // End of class TMemoField
  // Begin of class TGraphicField
  RegisterClassType(TGraphicField, H);
  RegisterMethod(TGraphicField,
       'constructor Create(AOwner: TComponent); override;',
       @TGraphicField.Create);
  // End of class TGraphicField
  // Begin of class TObjectField
  RegisterClassType(TObjectField, H);
  RegisterMethod(TObjectField,
       'constructor Create(AOwner: TComponent); override;',
       @TObjectField.Create);
  RegisterMethod(TObjectField,
       'destructor Destroy; override;',
       @TObjectField.Destroy);
  RegisterMethod(TObjectField,
       'function TObjectField_GetFieldCount:Integer;',
       @TObjectField_GetFieldCount, Fake);
  RegisterProperty(TObjectField,
       'property FieldCount:Integer read TObjectField_GetFieldCount;');
  RegisterMethod(TObjectField,
       'function TObjectField_GetFields:TFields;',
       @TObjectField_GetFields, Fake);
  RegisterProperty(TObjectField,
       'property Fields:TFields read TObjectField_GetFields;');
  RegisterMethod(TObjectField,
       'function TObjectField_GetFieldValues(Index: Integer):Variant;',
       @TObjectField_GetFieldValues, Fake);
  RegisterMethod(TObjectField,
       'procedure TObjectField_PutFieldValues(Index: Integer;const Value: Variant);',
       @TObjectField_PutFieldValues, Fake);
  RegisterProperty(TObjectField,
       'property FieldValues[Index: Integer]:Variant read TObjectField_GetFieldValues write TObjectField_PutFieldValues;default;');
  RegisterMethod(TObjectField,
       'function TObjectField_GetUnNamed:Boolean;',
       @TObjectField_GetUnNamed, Fake);
  RegisterProperty(TObjectField,
       'property UnNamed:Boolean read TObjectField_GetUnNamed;');
  // End of class TObjectField
  // Begin of class TADTField
  RegisterClassType(TADTField, H);
  RegisterMethod(TADTField,
       'constructor Create(AOwner: TComponent); override;',
       @TADTField.Create);
  // End of class TADTField
  // Begin of class TArrayField
  RegisterClassType(TArrayField, H);
  RegisterMethod(TArrayField,
       'constructor Create(AOwner: TComponent); override;',
       @TArrayField.Create);
  // End of class TArrayField
  // Begin of class TDataSetField
  RegisterClassType(TDataSetField, H);
  RegisterMethod(TDataSetField,
       'constructor Create(AOwner: TComponent); override;',
       @TDataSetField.Create);
  RegisterMethod(TDataSetField,
       'destructor Destroy; override;',
       @TDataSetField.Destroy);
  RegisterMethod(TDataSetField,
       'function TDataSetField_GetNestedDataSet:TDataSet;',
       @TDataSetField_GetNestedDataSet, Fake);
  RegisterProperty(TDataSetField,
       'property NestedDataSet:TDataSet read TDataSetField_GetNestedDataSet;');
  // End of class TDataSetField
  // Begin of class TReferenceField
  RegisterClassType(TReferenceField, H);
  RegisterMethod(TReferenceField,
       'constructor Create(AOwner: TComponent); override;',
       @TReferenceField.Create);
  RegisterMethod(TReferenceField,
       'procedure Assign(Source: TPersistent); override;',
       @TReferenceField.Assign);
  // End of class TReferenceField
  // Begin of class TVariantField
  RegisterClassType(TVariantField, H);
  RegisterMethod(TVariantField,
       'constructor Create(AOwner: TComponent); override;',
       @TVariantField.Create);
  // End of class TVariantField
  // Begin of class TInterfaceField
  RegisterClassType(TInterfaceField, H);
  RegisterMethod(TInterfaceField,
       'constructor Create(AOwner: TComponent); override;',
       @TInterfaceField.Create);
  RegisterMethod(TInterfaceField,
       'function TInterfaceField_GetValue:IUnknown;',
       @TInterfaceField_GetValue, Fake);
  RegisterMethod(TInterfaceField,
       'procedure TInterfaceField_PutValue(const Value: IUnknown);',
       @TInterfaceField_PutValue, Fake);
  RegisterProperty(TInterfaceField,
       'property Value:IUnknown read TInterfaceField_GetValue write TInterfaceField_PutValue;');
  // End of class TInterfaceField
  // Begin of class TIDispatchField
  RegisterClassType(TIDispatchField, H);
  RegisterMethod(TIDispatchField,
       'constructor Create(AOwner: TComponent); override;',
       @TIDispatchField.Create);
  RegisterMethod(TIDispatchField,
       'function TIDispatchField_GetValue:IDispatch;',
       @TIDispatchField_GetValue, Fake);
  RegisterMethod(TIDispatchField,
       'procedure TIDispatchField_PutValue(const Value: IDispatch);',
       @TIDispatchField_PutValue, Fake);
  RegisterProperty(TIDispatchField,
       'property Value:IDispatch read TIDispatchField_GetValue write TIDispatchField_PutValue;');
  // End of class TIDispatchField
  // Begin of class TGuidField
  RegisterClassType(TGuidField, H);
  RegisterMethod(TGuidField,
       'constructor Create(AOwner: TComponent); override;',
       @TGuidField.Create);
  RegisterMethod(TGuidField,
       'function TGuidField_GetAsGuid:TGUID;',
       @TGuidField_GetAsGuid, Fake);
  RegisterMethod(TGuidField,
       'procedure TGuidField_PutAsGuid(const Value: TGUID);',
       @TGuidField_PutAsGuid, Fake);
  RegisterProperty(TGuidField,
       'property AsGuid:TGUID read TGuidField_GetAsGuid write TGuidField_PutAsGuid;');
  // End of class TGuidField
  // Begin of class TAggregateField
  RegisterClassType(TAggregateField, H);
  RegisterMethod(TAggregateField,
       'constructor Create(AOwner: TComponent); override;',
       @TAggregateField.Create);
  RegisterMethod(TAggregateField,
       'function TAggregateField_GetHandle:Pointer;',
       @TAggregateField_GetHandle, Fake);
  RegisterMethod(TAggregateField,
       'procedure TAggregateField_PutHandle(const Value: Pointer);',
       @TAggregateField_PutHandle, Fake);
  RegisterProperty(TAggregateField,
       'property Handle:Pointer read TAggregateField_GetHandle write TAggregateField_PutHandle;');
  RegisterMethod(TAggregateField,
       'function TAggregateField_GetResultType:TFieldType;',
       @TAggregateField_GetResultType, Fake);
  RegisterMethod(TAggregateField,
       'procedure TAggregateField_PutResultType(const Value: TFieldType);',
       @TAggregateField_PutResultType, Fake);
  RegisterProperty(TAggregateField,
       'property ResultType:TFieldType read TAggregateField_GetResultType write TAggregateField_PutResultType;');
  // End of class TAggregateField
  // Begin of class TDataLink
  RegisterClassType(TDataLink, H);
  RegisterMethod(TDataLink,
       'constructor Create;',
       @TDataLink.Create);
  RegisterMethod(TDataLink,
       'destructor Destroy; override;',
       @TDataLink.Destroy);
  RegisterMethod(TDataLink,
       'function Edit: Boolean;',
       @TDataLink.Edit);
  RegisterMethod(TDataLink,
       'function ExecuteAction(Action: TBasicAction): Boolean; dynamic;',
       @TDataLink.ExecuteAction);
  RegisterMethod(TDataLink,
       'function UpdateAction(Action: TBasicAction): Boolean; dynamic;',
       @TDataLink.UpdateAction);
  RegisterMethod(TDataLink,
       'procedure UpdateRecord;',
       @TDataLink.UpdateRecord);
  RegisterMethod(TDataLink,
       'function TDataLink_GetActive:Boolean;',
       @TDataLink_GetActive, Fake);
  RegisterProperty(TDataLink,
       'property Active:Boolean read TDataLink_GetActive;');
  RegisterMethod(TDataLink,
       'function TDataLink_GetActiveRecord:Integer;',
       @TDataLink_GetActiveRecord, Fake);
  RegisterMethod(TDataLink,
       'procedure TDataLink_PutActiveRecord(const Value: Integer);',
       @TDataLink_PutActiveRecord, Fake);
  RegisterProperty(TDataLink,
       'property ActiveRecord:Integer read TDataLink_GetActiveRecord write TDataLink_PutActiveRecord;');
  RegisterMethod(TDataLink,
       'function TDataLink_GetBOF:Boolean;',
       @TDataLink_GetBOF, Fake);
  RegisterProperty(TDataLink,
       'property BOF:Boolean read TDataLink_GetBOF;');
  RegisterMethod(TDataLink,
       'function TDataLink_GetBufferCount:Integer;',
       @TDataLink_GetBufferCount, Fake);
  RegisterMethod(TDataLink,
       'procedure TDataLink_PutBufferCount(const Value: Integer);',
       @TDataLink_PutBufferCount, Fake);
  RegisterProperty(TDataLink,
       'property BufferCount:Integer read TDataLink_GetBufferCount write TDataLink_PutBufferCount;');
  RegisterMethod(TDataLink,
       'function TDataLink_GetDataSet:TDataSet;',
       @TDataLink_GetDataSet, Fake);
  RegisterProperty(TDataLink,
       'property DataSet:TDataSet read TDataLink_GetDataSet;');
  RegisterMethod(TDataLink,
       'function TDataLink_GetDataSource:TDataSource;',
       @TDataLink_GetDataSource, Fake);
  RegisterMethod(TDataLink,
       'procedure TDataLink_PutDataSource(const Value: TDataSource);',
       @TDataLink_PutDataSource, Fake);
  RegisterProperty(TDataLink,
       'property DataSource:TDataSource read TDataLink_GetDataSource write TDataLink_PutDataSource;');
  RegisterMethod(TDataLink,
       'function TDataLink_GetDataSourceFixed:Boolean;',
       @TDataLink_GetDataSourceFixed, Fake);
  RegisterMethod(TDataLink,
       'procedure TDataLink_PutDataSourceFixed(const Value: Boolean);',
       @TDataLink_PutDataSourceFixed, Fake);
  RegisterProperty(TDataLink,
       'property DataSourceFixed:Boolean read TDataLink_GetDataSourceFixed write TDataLink_PutDataSourceFixed;');
  RegisterMethod(TDataLink,
       'function TDataLink_GetEditing:Boolean;',
       @TDataLink_GetEditing, Fake);
  RegisterProperty(TDataLink,
       'property Editing:Boolean read TDataLink_GetEditing;');
  RegisterMethod(TDataLink,
       'function TDataLink_GetEof:Boolean;',
       @TDataLink_GetEof, Fake);
  RegisterProperty(TDataLink,
       'property Eof:Boolean read TDataLink_GetEof;');
  RegisterMethod(TDataLink,
       'function TDataLink_GetReadOnly:Boolean;',
       @TDataLink_GetReadOnly, Fake);
  RegisterMethod(TDataLink,
       'procedure TDataLink_PutReadOnly(const Value: Boolean);',
       @TDataLink_PutReadOnly, Fake);
  RegisterProperty(TDataLink,
       'property ReadOnly:Boolean read TDataLink_GetReadOnly write TDataLink_PutReadOnly;');
  RegisterMethod(TDataLink,
       'function TDataLink_GetRecordCount:Integer;',
       @TDataLink_GetRecordCount, Fake);
  RegisterProperty(TDataLink,
       'property RecordCount:Integer read TDataLink_GetRecordCount;');
  // End of class TDataLink
  // Begin of class TDetailDataLink
  RegisterClassType(TDetailDataLink, H);
  RegisterMethod(TDetailDataLink,
       'function TDetailDataLink_GetDetailDataSet:TDataSet;',
       @TDetailDataLink_GetDetailDataSet, Fake);
  RegisterProperty(TDetailDataLink,
       'property DetailDataSet:TDataSet read TDetailDataLink_GetDetailDataSet;');
  RegisterMethod(TDetailDataLink,
       'constructor Create;',
       @TDetailDataLink.Create);
  // End of class TDetailDataLink
  // Begin of class TMasterDataLink
  RegisterClassType(TMasterDataLink, H);
  RegisterMethod(TMasterDataLink,
       'constructor Create(DataSet: TDataSet);',
       @TMasterDataLink.Create);
  RegisterMethod(TMasterDataLink,
       'destructor Destroy; override;',
       @TMasterDataLink.Destroy);
  RegisterMethod(TMasterDataLink,
       'function TMasterDataLink_GetFieldNames:String;',
       @TMasterDataLink_GetFieldNames, Fake);
  RegisterMethod(TMasterDataLink,
       'procedure TMasterDataLink_PutFieldNames(const Value: String);',
       @TMasterDataLink_PutFieldNames, Fake);
  RegisterProperty(TMasterDataLink,
       'property FieldNames:String read TMasterDataLink_GetFieldNames write TMasterDataLink_PutFieldNames;');
  RegisterMethod(TMasterDataLink,
       'function TMasterDataLink_GetFields:TList;',
       @TMasterDataLink_GetFields, Fake);
  RegisterProperty(TMasterDataLink,
       'property Fields:TList read TMasterDataLink_GetFields;');
  // End of class TMasterDataLink
  // Begin of class TDataSource
  RegisterClassType(TDataSource, H);
  RegisterMethod(TDataSource,
       'constructor Create(AOwner: TComponent); override;',
       @TDataSource.Create);
  RegisterMethod(TDataSource,
       'destructor Destroy; override;',
       @TDataSource.Destroy);
  RegisterMethod(TDataSource,
       'procedure Edit;',
       @TDataSource.Edit);
  RegisterMethod(TDataSource,
       'function IsLinkedTo(DataSet: TDataSet): Boolean;',
       @TDataSource.IsLinkedTo);
  RegisterMethod(TDataSource,
       'function TDataSource_GetState:TDataSetState;',
       @TDataSource_GetState, Fake);
  RegisterProperty(TDataSource,
       'property State:TDataSetState read TDataSource_GetState;');
  // End of class TDataSource
  // Begin of class TDataSetDesigner
  RegisterClassType(TDataSetDesigner, H);
  RegisterMethod(TDataSetDesigner,
       'constructor Create(DataSet: TDataSet);',
       @TDataSetDesigner.Create);
  RegisterMethod(TDataSetDesigner,
       'destructor Destroy; override;',
       @TDataSetDesigner.Destroy);
  RegisterMethod(TDataSetDesigner,
       'procedure BeginDesign;',
       @TDataSetDesigner.BeginDesign);
  RegisterMethod(TDataSetDesigner,
       'procedure DataEvent(Event: TDataEvent; Info: Longint); virtual;',
       @TDataSetDesigner.DataEvent);
  RegisterMethod(TDataSetDesigner,
       'procedure EndDesign;',
       @TDataSetDesigner.EndDesign);
  RegisterMethod(TDataSetDesigner,
       'function TDataSetDesigner_GetDataSet:TDataSet;',
       @TDataSetDesigner_GetDataSet, Fake);
  RegisterProperty(TDataSetDesigner,
       'property DataSet:TDataSet read TDataSetDesigner_GetDataSet;');
  // End of class TDataSetDesigner
  // Begin of class TCheckConstraint
  RegisterClassType(TCheckConstraint, H);
  RegisterMethod(TCheckConstraint,
       'procedure Assign(Source: TPersistent); override;',
       @TCheckConstraint.Assign);
  RegisterMethod(TCheckConstraint,
       'function GetDisplayName: string; override;',
       @TCheckConstraint.GetDisplayName);
  // CONSTRUCTOR IS NOT FOUND!!!
  // End of class TCheckConstraint
  // Begin of class TCheckConstraints
  RegisterClassType(TCheckConstraints, H);
  RegisterMethod(TCheckConstraints,
       'constructor Create(Owner: TPersistent);',
       @TCheckConstraints.Create);
  RegisterMethod(TCheckConstraints,
       'function Add: TCheckConstraint;',
       @TCheckConstraints.Add);
  RegisterMethod(TCheckConstraints,
       'function TCheckConstraints_GetItems(Index: Integer):TCheckConstraint;',
       @TCheckConstraints_GetItems, Fake);
  RegisterMethod(TCheckConstraints,
       'procedure TCheckConstraints_PutItems(Index: Integer;const Value: TCheckConstraint);',
       @TCheckConstraints_PutItems, Fake);
  RegisterProperty(TCheckConstraints,
       'property Items[Index: Integer]:TCheckConstraint read TCheckConstraints_GetItems write TCheckConstraints_PutItems;default;');
  // End of class TCheckConstraints
  RegisterRTTIType(TypeInfo(TParamType));
  // Begin of class TParam
  RegisterClassType(TParam, H);
  RegisterMethod(TParam,
       'constructor Create(Collection: TCollection); overload; override;',
       @TParam.Create);
  RegisterMethod(TParam,
       'constructor Create(AParams: TParams; AParamType: TParamType); reintroduce; overload;',
       @TParam.Create);
  RegisterMethod(TParam,
       'procedure Assign(Source: TPersistent); override;',
       @TParam.Assign);
  RegisterMethod(TParam,
       'procedure AssignField(Field: TField);',
       @TParam.AssignField);
  RegisterMethod(TParam,
       'procedure AssignFieldValue(Field: TField; const Value: Variant);',
       @TParam.AssignFieldValue);
  RegisterMethod(TParam,
       'procedure Clear;',
       @TParam.Clear);
  RegisterMethod(TParam,
       'procedure GetData(Buffer: Pointer);',
       @TParam.GetData);
  RegisterMethod(TParam,
       'function GetDataSize: Integer;',
       @TParam.GetDataSize);
  RegisterMethod(TParam,
       'procedure LoadFromFile(const FileName: string; BlobType: TBlobType);',
       @TParam.LoadFromFile);
  RegisterMethod(TParam,
       'procedure LoadFromStream(Stream: TStream; BlobType: TBlobType);',
       @TParam.LoadFromStream);
  RegisterMethod(TParam,
       'procedure SetBlobData(Buffer: Pointer; Size: Integer);',
       @TParam.SetBlobData);
  RegisterMethod(TParam,
       'procedure SetData(Buffer: Pointer);',
       @TParam.SetData);
  RegisterMethod(TParam,
       'function TParam_GetAsBCD:Currency;',
       @TParam_GetAsBCD, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutAsBCD(const Value: Currency);',
       @TParam_PutAsBCD, Fake);
  RegisterProperty(TParam,
       'property AsBCD:Currency read TParam_GetAsBCD write TParam_PutAsBCD;');
  RegisterMethod(TParam,
       'function TParam_GetAsBlob:TBlobData;',
       @TParam_GetAsBlob, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutAsBlob(const Value: TBlobData);',
       @TParam_PutAsBlob, Fake);
  RegisterProperty(TParam,
       'property AsBlob:TBlobData read TParam_GetAsBlob write TParam_PutAsBlob;');
  RegisterMethod(TParam,
       'function TParam_GetAsBoolean:Boolean;',
       @TParam_GetAsBoolean, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutAsBoolean(const Value: Boolean);',
       @TParam_PutAsBoolean, Fake);
  RegisterProperty(TParam,
       'property AsBoolean:Boolean read TParam_GetAsBoolean write TParam_PutAsBoolean;');
  RegisterMethod(TParam,
       'function TParam_GetAsCurrency:Currency;',
       @TParam_GetAsCurrency, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutAsCurrency(const Value: Currency);',
       @TParam_PutAsCurrency, Fake);
  RegisterProperty(TParam,
       'property AsCurrency:Currency read TParam_GetAsCurrency write TParam_PutAsCurrency;');
  RegisterMethod(TParam,
       'function TParam_GetAsDate:TDateTime;',
       @TParam_GetAsDate, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutAsDate(const Value: TDateTime);',
       @TParam_PutAsDate, Fake);
  RegisterProperty(TParam,
       'property AsDate:TDateTime read TParam_GetAsDate write TParam_PutAsDate;');
  RegisterMethod(TParam,
       'function TParam_GetAsDateTime:TDateTime;',
       @TParam_GetAsDateTime, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutAsDateTime(const Value: TDateTime);',
       @TParam_PutAsDateTime, Fake);
  RegisterProperty(TParam,
       'property AsDateTime:TDateTime read TParam_GetAsDateTime write TParam_PutAsDateTime;');
  RegisterMethod(TParam,
       'function TParam_GetAsFloat:Double;',
       @TParam_GetAsFloat, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutAsFloat(const Value: Double);',
       @TParam_PutAsFloat, Fake);
  RegisterProperty(TParam,
       'property AsFloat:Double read TParam_GetAsFloat write TParam_PutAsFloat;');
  RegisterMethod(TParam,
       'function TParam_GetAsInteger:LongInt;',
       @TParam_GetAsInteger, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutAsInteger(const Value: LongInt);',
       @TParam_PutAsInteger, Fake);
  RegisterProperty(TParam,
       'property AsInteger:LongInt read TParam_GetAsInteger write TParam_PutAsInteger;');
  RegisterMethod(TParam,
       'function TParam_GetAsSmallInt:LongInt;',
       @TParam_GetAsSmallInt, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutAsSmallInt(const Value: LongInt);',
       @TParam_PutAsSmallInt, Fake);
  RegisterProperty(TParam,
       'property AsSmallInt:LongInt read TParam_GetAsSmallInt write TParam_PutAsSmallInt;');
  RegisterMethod(TParam,
       'function TParam_GetAsMemo:String;',
       @TParam_GetAsMemo, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutAsMemo(const Value: String);',
       @TParam_PutAsMemo, Fake);
  RegisterProperty(TParam,
       'property AsMemo:String read TParam_GetAsMemo write TParam_PutAsMemo;');
  RegisterMethod(TParam,
       'function TParam_GetAsString:String;',
       @TParam_GetAsString, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutAsString(const Value: String);',
       @TParam_PutAsString, Fake);
  RegisterProperty(TParam,
       'property AsString:String read TParam_GetAsString write TParam_PutAsString;');
  RegisterMethod(TParam,
       'function TParam_GetAsTime:TDateTime;',
       @TParam_GetAsTime, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutAsTime(const Value: TDateTime);',
       @TParam_PutAsTime, Fake);
  RegisterProperty(TParam,
       'property AsTime:TDateTime read TParam_GetAsTime write TParam_PutAsTime;');
  RegisterMethod(TParam,
       'function TParam_GetAsWord:LongInt;',
       @TParam_GetAsWord, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutAsWord(const Value: LongInt);',
       @TParam_PutAsWord, Fake);
  RegisterProperty(TParam,
       'property AsWord:LongInt read TParam_GetAsWord write TParam_PutAsWord;');
  RegisterMethod(TParam,
       'function TParam_GetBound:Boolean;',
       @TParam_GetBound, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutBound(const Value: Boolean);',
       @TParam_PutBound, Fake);
  RegisterProperty(TParam,
       'property Bound:Boolean read TParam_GetBound write TParam_PutBound;');
  RegisterMethod(TParam,
       'function TParam_GetIsNull:Boolean;',
       @TParam_GetIsNull, Fake);
  RegisterProperty(TParam,
       'property IsNull:Boolean read TParam_GetIsNull;');
  RegisterMethod(TParam,
       'function TParam_GetNativeStr:String;',
       @TParam_GetNativeStr, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutNativeStr(const Value: String);',
       @TParam_PutNativeStr, Fake);
  RegisterProperty(TParam,
       'property NativeStr:String read TParam_GetNativeStr write TParam_PutNativeStr;');
  RegisterMethod(TParam,
       'function TParam_GetText:String;',
       @TParam_GetText, Fake);
  RegisterMethod(TParam,
       'procedure TParam_PutText(const Value: String);',
       @TParam_PutText, Fake);
  RegisterProperty(TParam,
       'property Text:String read TParam_GetText write TParam_PutText;');
  // End of class TParam
  // Begin of class TParams
  RegisterClassType(TParams, H);
  RegisterMethod(TParams,
       'constructor Create(Owner: TPersistent); overload;',
       @TParams.Create);
  RegisterMethod(TParams,
       'procedure AssignValues(Value: TParams);',
       @TParams.AssignValues);
  RegisterMethod(TParams,
       'constructor Create; overload;',
       @TParams.Create);
  RegisterMethod(TParams,
       'procedure AddParam(Value: TParam);',
       @TParams.AddParam);
  RegisterMethod(TParams,
       'procedure RemoveParam(Value: TParam);',
       @TParams.RemoveParam);
  RegisterMethod(TParams,
       'function CreateParam(FldType: TFieldType; const ParamName: string;      ParamType: TParamType): TParam;',
       @TParams.CreateParam);
  RegisterMethod(TParams,
       'procedure GetParamList(List: TList; const ParamNames: string);',
       @TParams.GetParamList);
  RegisterMethod(TParams,
       'function IsEqual(Value: TParams): Boolean;',
       @TParams.IsEqual);
  RegisterMethod(TParams,
       'function ParseSQL(SQL: String; DoCreate: Boolean): String;',
       @TParams.ParseSQL);
  RegisterMethod(TParams,
       'function ParamByName(const Value: string): TParam;',
       @TParams.ParamByName);
  RegisterMethod(TParams,
       'function FindParam(const Value: string): TParam;',
       @TParams.FindParam);
  RegisterMethod(TParams,
       'function TParams_GetItems(Index: Integer):TParam;',
       @TParams_GetItems, Fake);
  RegisterMethod(TParams,
       'procedure TParams_PutItems(Index: Integer;const Value: TParam);',
       @TParams_PutItems, Fake);
  RegisterProperty(TParams,
       'property Items[Index: Integer]:TParam read TParams_GetItems write TParams_PutItems;default;');
  RegisterMethod(TParams,
       'function TParams_GetParamValues(const ParamName: string):Variant;',
       @TParams_GetParamValues, Fake);
  RegisterMethod(TParams,
       'procedure TParams_PutParamValues(const ParamName: string;const Value: Variant);',
       @TParams_PutParamValues, Fake);
  RegisterProperty(TParams,
       'property ParamValues[const ParamName: string]:Variant read TParams_GetParamValues write TParams_PutParamValues;');
  // End of class TParams
  RegisterRTTIType(TypeInfo(TBookmarkFlag));
  RegisterRTTIType(TypeInfo(TGetMode));
  RegisterRTTIType(TypeInfo(TGetResult));
  RegisterRTTIType(TypeInfo(TDataAction));
  RegisterRTTIType(TypeInfo(TBlobStreamMode));
  RegisterRTTIType(TypeInfo(TLocateOption));
  RegisterRTTIType(TypeInfo(TFilterOption));
  RegisterRTTIType(TypeInfo(TGroupPosInd));
  // Begin of class TDataSet
  RegisterClassType(TDataSet, H);
  RegisterMethod(TDataSet,
       'constructor Create(AOwner: TComponent); override;',
       @TDataSet.Create);
  RegisterMethod(TDataSet,
       'destructor Destroy; override;',
       @TDataSet.Destroy);
  RegisterMethod(TDataSet,
       'function ActiveBuffer: PChar;',
       @TDataSet.ActiveBuffer);
  RegisterMethod(TDataSet,
       'procedure Append;',
       @TDataSet.Append);
  RegisterMethod(TDataSet,
       'procedure AppendRecord(const Values: array of const);',
       @TDataSet.AppendRecord);
  RegisterMethod(TDataSet,
       'function BookmarkValid(Bookmark: TBookmark): Boolean; virtual;',
       @TDataSet.BookmarkValid);
  RegisterMethod(TDataSet,
       'procedure Cancel; virtual;',
       @TDataSet.Cancel);
  RegisterMethod(TDataSet,
       'procedure CheckBrowseMode;',
       @TDataSet.CheckBrowseMode);
  RegisterMethod(TDataSet,
       'procedure ClearFields;',
       @TDataSet.ClearFields);
  RegisterMethod(TDataSet,
       'procedure Close;',
       @TDataSet.Close);
  RegisterMethod(TDataSet,
       'function  ControlsDisabled: Boolean;',
       @TDataSet.ControlsDisabled);
  RegisterMethod(TDataSet,
       'function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; virtual;',
       @TDataSet.CompareBookmarks);
  RegisterMethod(TDataSet,
       'function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; virtual;',
       @TDataSet.CreateBlobStream);
  RegisterMethod(TDataSet,
       'procedure CursorPosChanged;',
       @TDataSet.CursorPosChanged);
  RegisterMethod(TDataSet,
       'procedure Delete;',
       @TDataSet.Delete);
  RegisterMethod(TDataSet,
       'procedure DisableControls;',
       @TDataSet.DisableControls);
  RegisterMethod(TDataSet,
       'procedure Edit;',
       @TDataSet.Edit);
  RegisterMethod(TDataSet,
       'procedure EnableControls;',
       @TDataSet.EnableControls);
  RegisterMethod(TDataSet,
       'function FieldByName(const FieldName: string): TField;',
       @TDataSet.FieldByName);
  RegisterMethod(TDataSet,
       'function FindField(const FieldName: string): TField;',
       @TDataSet.FindField);
  RegisterMethod(TDataSet,
       'function FindFirst: Boolean;',
       @TDataSet.FindFirst);
  RegisterMethod(TDataSet,
       'function FindLast: Boolean;',
       @TDataSet.FindLast);
  RegisterMethod(TDataSet,
       'function FindNext: Boolean;',
       @TDataSet.FindNext);
  RegisterMethod(TDataSet,
       'function FindPrior: Boolean;',
       @TDataSet.FindPrior);
  RegisterMethod(TDataSet,
       'procedure First;',
       @TDataSet.First);
  RegisterMethod(TDataSet,
       'procedure FreeBookmark(Bookmark: TBookmark); virtual;',
       @TDataSet.FreeBookmark);
  RegisterMethod(TDataSet,
       'function GetBookmark: TBookmark; virtual;',
       @TDataSet.GetBookmark);
  RegisterMethod(TDataSet,
       'function GetCurrentRecord(Buffer: PChar): Boolean; virtual;',
       @TDataSet.GetCurrentRecord);
  RegisterMethod(TDataSet,
       'procedure GetDetailDataSets(List: TList);',
       @TDataSet.GetDetailDataSets);
  RegisterMethod(TDataSet,
       'procedure GetDetailLinkFields(MasterFields, DetailFields: TList); virtual;',
       @TDataSet.GetDetailLinkFields);
  RegisterMethod(TDataSet,
       'function GetBlobFieldData(FieldNo: Integer; var Buffer: TBlobByteData): Integer; virtual;',
       @TDataSet.GetBlobFieldData);
  RegisterMethod(TDataSet,
       'function GetFieldData(Field: TField; Buffer: Pointer): Boolean; overload; virtual;',
       @TDataSet.GetFieldData);
  RegisterMethod(TDataSet,
       'function GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean; overload; virtual;',
       @TDataSet.GetFieldData);
  RegisterMethod(TDataSet,
       'function GetFieldData(Field: TField; Buffer: Pointer; NativeFormat: Boolean): Boolean; overload; virtual;',
       @TDataSet.GetFieldData);
  RegisterMethod(TDataSet,
       'procedure GetFieldList(List: TList; const FieldNames: string);',
       @TDataSet.GetFieldList);
  RegisterMethod(TDataSet,
       'procedure GetFieldNames(List: TStrings);',
       @TDataSet.GetFieldNames);
  RegisterMethod(TDataSet,
       'procedure GotoBookmark(Bookmark: TBookmark);',
       @TDataSet.GotoBookmark);
  RegisterMethod(TDataSet,
       'procedure Insert;',
       @TDataSet.Insert);
  RegisterMethod(TDataSet,
       'procedure InsertRecord(const Values: array of const);',
       @TDataSet.InsertRecord);
  RegisterMethod(TDataSet,
       'function IsEmpty: Boolean;',
       @TDataSet.IsEmpty);
  RegisterMethod(TDataSet,
       'function IsLinkedTo(DataSource: TDataSource): Boolean;',
       @TDataSet.IsLinkedTo);
  RegisterMethod(TDataSet,
       'function IsSequenced: Boolean; virtual;',
       @TDataSet.IsSequenced);
  RegisterMethod(TDataSet,
       'procedure Last;',
       @TDataSet.Last);
  RegisterMethod(TDataSet,
       'function Locate(const KeyFields: string; const KeyValues: Variant;      Options: TLocateOptions): Boolean; virtual;',
       @TDataSet.Locate);
  RegisterMethod(TDataSet,
       'function Lookup(const KeyFields: string; const KeyValues: Variant;      const ResultFields: string): Variant; virtual;',
       @TDataSet.Lookup);
  RegisterMethod(TDataSet,
       'function MoveBy(Distance: Integer): Integer;',
       @TDataSet.MoveBy);
  RegisterMethod(TDataSet,
       'procedure Next;',
       @TDataSet.Next);
  RegisterMethod(TDataSet,
       'procedure Open;',
       @TDataSet.Open);
  RegisterMethod(TDataSet,
       'procedure Post; virtual;',
       @TDataSet.Post);
  RegisterMethod(TDataSet,
       'procedure Prior;',
       @TDataSet.Prior);
  RegisterMethod(TDataSet,
       'procedure Refresh;',
       @TDataSet.Refresh);
  RegisterMethod(TDataSet,
       'procedure Resync(Mode: TResyncMode); virtual;',
       @TDataSet.Resync);
  RegisterMethod(TDataSet,
       'procedure SetFields(const Values: array of const);',
       @TDataSet.SetFields);
  RegisterMethod(TDataSet,
       'function Translate(Src, Dest: PChar; ToOem: Boolean): Integer; virtual;',
       @TDataSet.Translate);
  RegisterMethod(TDataSet,
       'procedure UpdateCursorPos;',
       @TDataSet.UpdateCursorPos);
  RegisterMethod(TDataSet,
       'procedure UpdateRecord;',
       @TDataSet.UpdateRecord);
  RegisterMethod(TDataSet,
       'function UpdateStatus: TUpdateStatus; virtual;',
       @TDataSet.UpdateStatus);
  RegisterMethod(TDataSet,
       'function TDataSet_GetAggFields:TFields;',
       @TDataSet_GetAggFields, Fake);
  RegisterProperty(TDataSet,
       'property AggFields:TFields read TDataSet_GetAggFields;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetBof:Boolean;',
       @TDataSet_GetBof, Fake);
  RegisterProperty(TDataSet,
       'property Bof:Boolean read TDataSet_GetBof;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetBookmark:TBookmarkStr;',
       @TDataSet_GetBookmark, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutBookmark(const Value: TBookmarkStr);',
       @TDataSet_PutBookmark, Fake);
  RegisterProperty(TDataSet,
       'property Bookmark:TBookmarkStr read TDataSet_GetBookmark write TDataSet_PutBookmark;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetCanModify:Boolean;',
       @TDataSet_GetCanModify, Fake);
  RegisterProperty(TDataSet,
       'property CanModify:Boolean read TDataSet_GetCanModify;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetDataSetField:TDataSetField;',
       @TDataSet_GetDataSetField, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutDataSetField(const Value: TDataSetField);',
       @TDataSet_PutDataSetField, Fake);
  RegisterProperty(TDataSet,
       'property DataSetField:TDataSetField read TDataSet_GetDataSetField write TDataSet_PutDataSetField;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetDataSource:TDataSource;',
       @TDataSet_GetDataSource, Fake);
  RegisterProperty(TDataSet,
       'property DataSource:TDataSource read TDataSet_GetDataSource;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetDefaultFields:Boolean;',
       @TDataSet_GetDefaultFields, Fake);
  RegisterProperty(TDataSet,
       'property DefaultFields:Boolean read TDataSet_GetDefaultFields;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetDesigner:TDataSetDesigner;',
       @TDataSet_GetDesigner, Fake);
  RegisterProperty(TDataSet,
       'property Designer:TDataSetDesigner read TDataSet_GetDesigner;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetEof:Boolean;',
       @TDataSet_GetEof, Fake);
  RegisterProperty(TDataSet,
       'property Eof:Boolean read TDataSet_GetEof;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetBlockReadSize:Integer;',
       @TDataSet_GetBlockReadSize, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutBlockReadSize(const Value: Integer);',
       @TDataSet_PutBlockReadSize, Fake);
  RegisterProperty(TDataSet,
       'property BlockReadSize:Integer read TDataSet_GetBlockReadSize write TDataSet_PutBlockReadSize;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetFieldCount:Integer;',
       @TDataSet_GetFieldCount, Fake);
  RegisterProperty(TDataSet,
       'property FieldCount:Integer read TDataSet_GetFieldCount;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetFieldDefs:TFieldDefs;',
       @TDataSet_GetFieldDefs, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutFieldDefs(const Value: TFieldDefs);',
       @TDataSet_PutFieldDefs, Fake);
  RegisterProperty(TDataSet,
       'property FieldDefs:TFieldDefs read TDataSet_GetFieldDefs write TDataSet_PutFieldDefs;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetFieldDefList:TFieldDefList;',
       @TDataSet_GetFieldDefList, Fake);
  RegisterProperty(TDataSet,
       'property FieldDefList:TFieldDefList read TDataSet_GetFieldDefList;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetFields:TFields;',
       @TDataSet_GetFields, Fake);
  RegisterProperty(TDataSet,
       'property Fields:TFields read TDataSet_GetFields;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetFieldList:TFieldList;',
       @TDataSet_GetFieldList, Fake);
  RegisterProperty(TDataSet,
       'property FieldList:TFieldList read TDataSet_GetFieldList;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetFieldValues(const FieldName: string):Variant;',
       @TDataSet_GetFieldValues, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutFieldValues(const FieldName: string;const Value: Variant);',
       @TDataSet_PutFieldValues, Fake);
  RegisterProperty(TDataSet,
       'property FieldValues[const FieldName: string]:Variant read TDataSet_GetFieldValues write TDataSet_PutFieldValues;default;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetFound:Boolean;',
       @TDataSet_GetFound, Fake);
  RegisterProperty(TDataSet,
       'property Found:Boolean read TDataSet_GetFound;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetModified:Boolean;',
       @TDataSet_GetModified, Fake);
  RegisterProperty(TDataSet,
       'property Modified:Boolean read TDataSet_GetModified;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetObjectView:Boolean;',
       @TDataSet_GetObjectView, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutObjectView(const Value: Boolean);',
       @TDataSet_PutObjectView, Fake);
  RegisterProperty(TDataSet,
       'property ObjectView:Boolean read TDataSet_GetObjectView write TDataSet_PutObjectView;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetRecordCount:Integer;',
       @TDataSet_GetRecordCount, Fake);
  RegisterProperty(TDataSet,
       'property RecordCount:Integer read TDataSet_GetRecordCount;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetRecNo:Integer;',
       @TDataSet_GetRecNo, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutRecNo(const Value: Integer);',
       @TDataSet_PutRecNo, Fake);
  RegisterProperty(TDataSet,
       'property RecNo:Integer read TDataSet_GetRecNo write TDataSet_PutRecNo;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetRecordSize:Word;',
       @TDataSet_GetRecordSize, Fake);
  RegisterProperty(TDataSet,
       'property RecordSize:Word read TDataSet_GetRecordSize;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetSparseArrays:Boolean;',
       @TDataSet_GetSparseArrays, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutSparseArrays(const Value: Boolean);',
       @TDataSet_PutSparseArrays, Fake);
  RegisterProperty(TDataSet,
       'property SparseArrays:Boolean read TDataSet_GetSparseArrays write TDataSet_PutSparseArrays;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetState:TDataSetState;',
       @TDataSet_GetState, Fake);
  RegisterProperty(TDataSet,
       'property State:TDataSetState read TDataSet_GetState;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetFilter:String;',
       @TDataSet_GetFilter, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutFilter(const Value: String);',
       @TDataSet_PutFilter, Fake);
  RegisterProperty(TDataSet,
       'property Filter:String read TDataSet_GetFilter write TDataSet_PutFilter;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetFiltered:Boolean;',
       @TDataSet_GetFiltered, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutFiltered(const Value: Boolean);',
       @TDataSet_PutFiltered, Fake);
  RegisterProperty(TDataSet,
       'property Filtered:Boolean read TDataSet_GetFiltered write TDataSet_PutFiltered;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetFilterOptions:TFilterOptions;',
       @TDataSet_GetFilterOptions, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutFilterOptions(const Value: TFilterOptions);',
       @TDataSet_PutFilterOptions, Fake);
  RegisterProperty(TDataSet,
       'property FilterOptions:TFilterOptions read TDataSet_GetFilterOptions write TDataSet_PutFilterOptions;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetActive:Boolean;',
       @TDataSet_GetActive, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutActive(const Value: Boolean);',
       @TDataSet_PutActive, Fake);
  RegisterProperty(TDataSet,
       'property Active:Boolean read TDataSet_GetActive write TDataSet_PutActive;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetAutoCalcFields:Boolean;',
       @TDataSet_GetAutoCalcFields, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutAutoCalcFields(const Value: Boolean);',
       @TDataSet_PutAutoCalcFields, Fake);
  RegisterProperty(TDataSet,
       'property AutoCalcFields:Boolean read TDataSet_GetAutoCalcFields write TDataSet_PutAutoCalcFields;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetBeforeOpen:TDataSetNotifyEvent;',
       @TDataSet_GetBeforeOpen, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutBeforeOpen(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutBeforeOpen, Fake);
  RegisterProperty(TDataSet,
       'property BeforeOpen:TDataSetNotifyEvent read TDataSet_GetBeforeOpen write TDataSet_PutBeforeOpen;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetAfterOpen:TDataSetNotifyEvent;',
       @TDataSet_GetAfterOpen, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutAfterOpen(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutAfterOpen, Fake);
  RegisterProperty(TDataSet,
       'property AfterOpen:TDataSetNotifyEvent read TDataSet_GetAfterOpen write TDataSet_PutAfterOpen;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetBeforeClose:TDataSetNotifyEvent;',
       @TDataSet_GetBeforeClose, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutBeforeClose(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutBeforeClose, Fake);
  RegisterProperty(TDataSet,
       'property BeforeClose:TDataSetNotifyEvent read TDataSet_GetBeforeClose write TDataSet_PutBeforeClose;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetAfterClose:TDataSetNotifyEvent;',
       @TDataSet_GetAfterClose, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutAfterClose(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutAfterClose, Fake);
  RegisterProperty(TDataSet,
       'property AfterClose:TDataSetNotifyEvent read TDataSet_GetAfterClose write TDataSet_PutAfterClose;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetBeforeInsert:TDataSetNotifyEvent;',
       @TDataSet_GetBeforeInsert, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutBeforeInsert(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutBeforeInsert, Fake);
  RegisterProperty(TDataSet,
       'property BeforeInsert:TDataSetNotifyEvent read TDataSet_GetBeforeInsert write TDataSet_PutBeforeInsert;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetAfterInsert:TDataSetNotifyEvent;',
       @TDataSet_GetAfterInsert, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutAfterInsert(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutAfterInsert, Fake);
  RegisterProperty(TDataSet,
       'property AfterInsert:TDataSetNotifyEvent read TDataSet_GetAfterInsert write TDataSet_PutAfterInsert;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetBeforeEdit:TDataSetNotifyEvent;',
       @TDataSet_GetBeforeEdit, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutBeforeEdit(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutBeforeEdit, Fake);
  RegisterProperty(TDataSet,
       'property BeforeEdit:TDataSetNotifyEvent read TDataSet_GetBeforeEdit write TDataSet_PutBeforeEdit;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetAfterEdit:TDataSetNotifyEvent;',
       @TDataSet_GetAfterEdit, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutAfterEdit(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutAfterEdit, Fake);
  RegisterProperty(TDataSet,
       'property AfterEdit:TDataSetNotifyEvent read TDataSet_GetAfterEdit write TDataSet_PutAfterEdit;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetBeforePost:TDataSetNotifyEvent;',
       @TDataSet_GetBeforePost, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutBeforePost(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutBeforePost, Fake);
  RegisterProperty(TDataSet,
       'property BeforePost:TDataSetNotifyEvent read TDataSet_GetBeforePost write TDataSet_PutBeforePost;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetAfterPost:TDataSetNotifyEvent;',
       @TDataSet_GetAfterPost, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutAfterPost(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutAfterPost, Fake);
  RegisterProperty(TDataSet,
       'property AfterPost:TDataSetNotifyEvent read TDataSet_GetAfterPost write TDataSet_PutAfterPost;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetBeforeCancel:TDataSetNotifyEvent;',
       @TDataSet_GetBeforeCancel, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutBeforeCancel(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutBeforeCancel, Fake);
  RegisterProperty(TDataSet,
       'property BeforeCancel:TDataSetNotifyEvent read TDataSet_GetBeforeCancel write TDataSet_PutBeforeCancel;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetAfterCancel:TDataSetNotifyEvent;',
       @TDataSet_GetAfterCancel, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutAfterCancel(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutAfterCancel, Fake);
  RegisterProperty(TDataSet,
       'property AfterCancel:TDataSetNotifyEvent read TDataSet_GetAfterCancel write TDataSet_PutAfterCancel;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetBeforeDelete:TDataSetNotifyEvent;',
       @TDataSet_GetBeforeDelete, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutBeforeDelete(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutBeforeDelete, Fake);
  RegisterProperty(TDataSet,
       'property BeforeDelete:TDataSetNotifyEvent read TDataSet_GetBeforeDelete write TDataSet_PutBeforeDelete;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetAfterDelete:TDataSetNotifyEvent;',
       @TDataSet_GetAfterDelete, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutAfterDelete(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutAfterDelete, Fake);
  RegisterProperty(TDataSet,
       'property AfterDelete:TDataSetNotifyEvent read TDataSet_GetAfterDelete write TDataSet_PutAfterDelete;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetBeforeScroll:TDataSetNotifyEvent;',
       @TDataSet_GetBeforeScroll, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutBeforeScroll(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutBeforeScroll, Fake);
  RegisterProperty(TDataSet,
       'property BeforeScroll:TDataSetNotifyEvent read TDataSet_GetBeforeScroll write TDataSet_PutBeforeScroll;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetAfterScroll:TDataSetNotifyEvent;',
       @TDataSet_GetAfterScroll, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutAfterScroll(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutAfterScroll, Fake);
  RegisterProperty(TDataSet,
       'property AfterScroll:TDataSetNotifyEvent read TDataSet_GetAfterScroll write TDataSet_PutAfterScroll;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetBeforeRefresh:TDataSetNotifyEvent;',
       @TDataSet_GetBeforeRefresh, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutBeforeRefresh(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutBeforeRefresh, Fake);
  RegisterProperty(TDataSet,
       'property BeforeRefresh:TDataSetNotifyEvent read TDataSet_GetBeforeRefresh write TDataSet_PutBeforeRefresh;');
  RegisterMethod(TDataSet,
       'function TDataSet_GetAfterRefresh:TDataSetNotifyEvent;',
       @TDataSet_GetAfterRefresh, Fake);
  RegisterMethod(TDataSet,
       'procedure TDataSet_PutAfterRefresh(const Value: TDataSetNotifyEvent);',
       @TDataSet_PutAfterRefresh, Fake);
  RegisterProperty(TDataSet,
       'property AfterRefresh:TDataSetNotifyEvent read TDataSet_GetAfterRefresh write TDataSet_PutAfterRefresh;');
  // End of class TDataSet
  RegisterConstant('DsMaxStringSize', 8192, H);
  RegisterRoutine('function ExtractFieldName(const Fields: string; var Pos: Integer): string;', @ExtractFieldName, H);
  RegisterRoutine('procedure RegisterFields(const FieldClasses: array of TFieldClass);', @RegisterFields, H);
  RegisterRoutine('procedure DisposeMem(var Buffer; Size: Integer);', @DisposeMem, H);
  RegisterRoutine('function BuffersEqual(Buf1, Buf2: Pointer; Size: Integer): Boolean;', @BuffersEqual, H);
  RegisterRoutine('function GetFieldProperty(DataSet: TDataSet; Control: TComponent;  const FieldName: string): TField;', @GetFieldProperty, H);
  RegisterRoutine('function VarTypeToDataType(VarType: Integer): TFieldType;', @VarTypeToDataType, H);
end;
{$ENDIF}

initialization
  RegisterIMP_db;
end.
