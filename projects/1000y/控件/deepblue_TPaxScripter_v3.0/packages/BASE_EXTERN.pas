///////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_EXTERN.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit BASE_EXTERN;
interface

uses
{$IFDEF VARIANTS}
  Variants,
{$ENDIF}

{$ifdef FP}
  dynlibs,
{$ENDIF}

{$IFDEF WIN32}
  Windows,
{$ENDIF}
  Classes, SysUtils, TypInfo,
  BASE_CONSTS,
  BASE_SYNC,
  BASE_SYS, BASE_CONV, BASE_DLL;
type
  TPAXMethodBody = class;
  TPAXDefinition = class;

  TPAXMethodImpl = procedure (MethodBody: TPAXMethodBody);

  TPAXDefKind = (dkClass, dkMethod, dkProperty, dkVariable, dkObject, dkField,
                 dkInterface,
                 dkRecordField,
                 dkConstant, dkRTTIType, dkVirtualObject, dkAny);

  TPAXDefinitionList = class;

  TPAXParameter = class
  private
    Scripter: Pointer;
    function GetAsString: String;
    procedure SetAsString(const Value: String);
    function GetAsInteger: Integer;
    procedure SetAsBoolean(Value: Boolean);
    function GetAsBoolean: Boolean;
    procedure SetAsInteger(Value: Integer);
    function GetAsDouble: Double;
    procedure SetAsDouble(Value: Double);
    function GetAsCardinal: Cardinal;
    procedure SetAsCardinal(Value: Cardinal);
    function GetAsPointer: Pointer;
    procedure SetAsPointer(Value: Pointer);
    function GetAsTObject: TObject;
    procedure SetAsTObject(Value: TObject);
    function GetAsVariant: Variant;
    procedure SetAsVariant(const Value: Variant);
    procedure Clear;
  public
    VType: Integer;
    PValue: PVariant;
    constructor Create(AScripter: Pointer);
    destructor Destroy; override;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsDouble: Double read GetAsDouble write SetAsDouble;
    property AsCardinal: Cardinal read GetAsCardinal write SetAsCardinal;
    property AsPointer: Pointer read GetAsPointer write SetAsPointer;
    property AsString: String read GetAsString write SetAsString;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsTObject: TObject read GetAsTObject write SetAsTObject;
    property AsVariant: Variant read GetAsVariant write SetAsVariant;
  end;

  TPAXParameterList = class(TList)
  public
    Scripter: Pointer;
    constructor Create(AScripter: Pointer);
    procedure Clear; override;
  end;

  PObject = ^TObject;

  TPAXMethodBody = class
  private
    fResult: TPAXParameter;
    fParameterList: TPAXParameterList;
    fParamCount: Integer;
    fFieldCount: Integer;
    function GetParameter(I: Integer): TPAXParameter;
    procedure SetParameter(I: Integer; Value: TPAXParameter);
    function GetField(I: Integer): TPAXParameter;
    procedure SetField(I: Integer; Value: TPAXParameter);
    function GetSelf: TObject;
    procedure SetSelf(Value: TObject);
    procedure AddParameters(K: Integer);
  public
    PSelf: Pointer;
    Scripter: Pointer;
    Name: String;
    constructor Create(Scripter: Pointer);
    destructor Destroy; override;
    procedure Clear;
    function DefaultValue: Variant;
    function FindNestedClass(const NamespaceName, ClassName: String): Pointer;
    property ParamCount: Integer read fParamCount write fParamCount;
    property FieldCount: Integer read fFieldCount write fFieldCount;
    property Params[I: Integer]: TPAXParameter read GetParameter write SetParameter;
    property Fields[I: Integer]: TPAXParameter read GetField write SetField;
    property Result: TPAXParameter read fResult write fResult;
    property Self: TObject read GetSelf write SetSelf;
  end;

  TPAXDefinition = class
  public
    DefValue: Variant;
  protected
    function GetValue: Variant; virtual;
    function PValue: PVariant; virtual;
    procedure SetValue(const AValue: Variant); virtual;
  public
    Name: String;
    DefKind: TPAXDefKind;
    ml: TPAXModifierList;
    Owner: TPAXDefinition;
    DefList: TPAXDefinitionList;
    Index: Integer;
    UserData: Integer;
    Module: Integer;
    ResultType: String;
    constructor Create(DefList: TPAXDefinitionList;
                       const Name: String; Owner: TPAXDefinition; DefKind: TPAXDefKind);
    procedure Dump(var T: TextFile); virtual; abstract;
    procedure AddToScripter(Scripter: Pointer); virtual;
    procedure AddToScripterList;
    function FullName: String;
    property Value: Variant read GetValue write SetValue;
  end;

  TPAXMethodDefinition = class(TPAXDefinition)
  public
    NP: Integer;
    Proc: TPAXMethodImpl;

    PClass: TClass;
    DirectProc: Pointer;
    CallConv: Integer;
    Header: String;
    Types: array of Integer;
    ExtraTypes: array of Integer;
    StrTypes: array of String;
    ParamNames: array of String;
    ByRefs: array of Boolean;
    Consts: array of Boolean;
    TypeSub: TPAXTypeSub;
    Sizes: array of Integer;
    Fake: Boolean;
    NewFake: Boolean;
    IsStatic: Boolean;
    ReturnsDynamicArray: Boolean;

    DefParamList: TPaxVarList;
    IsIntf: Boolean;
    MethodIndex: Integer;
    intf_pti: PTypeInfo;
    Guid: TGuid;

    constructor Create(DefList: TPAXDefinitionList; const Name: String;
                       Proc: TPAXMethodImpl; NP: Integer; Owner: TPAXDefinition;
                       IsStatic: Boolean);
    destructor Destroy; override;
    procedure Dump(var T: TextFile); override;
    function Duplicate: TPAXMethodDefinition;
    procedure AddToScripter(Scripter: Pointer); override;
    function GetScriptType(ParamNumber: Integer): Integer;
    function LoadFromDll(Scripter: Pointer; SubID: Integer): Boolean;
  end;

  TPAXClassDefinition = class(TPAXDefinition)
  public
    Ancestor: TPAXDefinition;
    PClass: TClass;
    GetPropDef, PutPropDef: TPAXMethodDefinition;
    ClassKind: TPAXClassKind;
    ElType, ElSize: Integer; // dynamic array
    ElTypeName: String;
    IsStaticArray: Boolean;

    IsSet: Boolean; // set
    PtiSet: PTypeInfo;

    RecordSize: Integer; // record;
    pti: PTypeInfo;
    guid: TGuid;

    OwnerList: TStringList;

    constructor Create(DefList: TPAXDefinitionList; const Name: String;
                       Owner, Ancestor: TPAXDefinition);
    destructor Destroy; override;
    procedure Dump(var T: TextFile); override;
    procedure AddToScripter(Scripter: Pointer); override;
    procedure CreateOwnerList;
    function FindClassRec(Scripter: Pointer): Pointer;
  end;

  TPAXFieldDefinition = class(TPAXDefinition)
  public
    PClass: TClass;
    FieldType: String;
    Offset: Integer;
    TypeID: Integer;
    constructor Create(DefList: TPAXDefinitionList; PClass: TClass; const FieldName,
                       FieldType: String; Offset: Integer);
    procedure Dump(var T: TextFile); override;
    procedure AddToScripter(Scripter: Pointer); override;
    function GetFieldValue(SO: pointer): Variant;
    procedure SetFieldValue(SO: pointer; const Value: Variant);
    function GetFieldAddress(SO: pointer): Pointer;
  end;

  TPAXRecordFieldDefinition = class(TPAXDefinition)
  public
    FieldType: String;
    Offset: Integer;
    TypeID: Integer;
    constructor Create(DefList: TPAXDefinitionList;
                       Owner: TPaxClassDefinition;
                       const FieldName, FieldType: String;
                       Offset: Integer);
    function GetFieldAddress(Scripter, Address: pointer): Pointer;
    function GetFieldValue(Scripter, Address: pointer): Variant;
    procedure SetFieldValue(Scripter, Address: pointer; const Value: Variant);
    procedure Dump(var T: TextFile); override;
    procedure AddToScripter(Scripter: Pointer); override;
  end;

  TPAXRTTITypeDefinition = class(TPAXDefinition)
  private
    function GetFinalType: Integer;
  public
    pti: PTypeInfo;
    FinalType: Integer;
    constructor Create(DefList: TPAXDefinitionList; pti: PTypeInfo);
    procedure Dump(var T: TextFile); override;
  end;

  TPAXPropertyDefinition = class(TPAXDefinition)
  public
    PClass: TClass;
    ReadDef, WriteDef: TPAXDefinition;
    PropDef: String;
    PropType: String;
    NP: Integer;
    constructor Create(DefList: TPAXDefinitionList;
                       const Name: String; Owner: TPAXDefinition;
                       PClass: TClass; ReadDef, WriteDef: TPAXDefinition);
    procedure Dump(var T: TextFile); override;
    procedure AddToScripter(Scripter: Pointer); override;
  end;

  TPAXVariableDefinition = class(TPAXDefinition)
  public
    TypeID: Integer;
    Address: Pointer;
    TypeName: String;
    constructor Create(DefList: TPAXDefinitionList;
                       const Name, TypeName: String;
                       Address: Pointer;
                       Owner: TPAXDefinition);
    function GetValue(Scripter: Pointer): Variant; reintroduce;
    procedure SetValue(Scripter: Pointer; const AValue: Variant); reintroduce;
    function GetAddress: Pointer;
    procedure Dump(var T: TextFile); override;
    procedure AddToScripter(Scripter: Pointer); override;
  end;

  TPAXObjectDefinition = class(TPAXDefinition)
  public
    Instance: TObject;
    constructor Create(DefList: TPAXDefinitionList;
                       const Name: String;
                       Instance: TObject;
                       Owner: TPAXDefinition);
    procedure Dump(var T: TextFile); override;
    procedure AddToScripter(Scripter: Pointer); override;
  end;

  TPAXVirtualObjectDefinition = class(TPAXDefinition)
  public
    constructor Create(DefList: TPAXDefinitionList;
                       const Name: String;
                       Owner: TPAXDefinition);
    procedure Dump(var T: TextFile); override;
    procedure AddToScripter(Scripter: Pointer); override;
  end;

  TPAXInterfaceVarDefinition = class(TPAXDefinition)
  public
    PIntf: PUnknown;
    guid: TGUID;
    constructor Create(DefList: TPAXDefinitionList;
                       const Name: String;
                       PIntf: PUnknown;
                       const guid: TGUID;
                       Owner: TPAXDefinition);
    procedure Dump(var T: TextFile); override;
    procedure AddToScripter(Scripter: Pointer); override;
  end;

  TPAXConstantDefinition = class(TPAXDefinition)
  public
    TypeID: Integer;
    ck: TPAXClassKind;
    constructor Create(DefList: TPAXDefinitionList;
                       const Name: String;
                       const Value: Variant;
                       Owner: TPAXDefinition);
    function GetAddress: Pointer;
    procedure Dump(var T: TextFile); override;
    procedure AddToScripter(Scripter: Pointer); override;
  end;

  TPAXDefinitionList = class(TList)
  public
    _LastIndex: Integer;
    ClassIdx: TPaxIds;
    ConstIdx: TPaxIds;
    Global: Boolean;
    MethodIdx: TStringList;
    FieldIdx: TStringList;
    RTTITypeDefIdx: TStringList;
    ConstantIdx: TStringList;
    GUIDIdx: TStringList;
  private
    function GetRecord(Index: Integer): TPAXDefinition;
    function NewIndex: Integer;
  public
    constructor Create(Global: Boolean);
    destructor Destroy; override;
    function Lookup(const Name: String;
                    DefKind: TPAXDefKind;
                    Owner: TPAXDefinition;
                    Scripter: Pointer = nil): TPAXDefinition;
    function LookupAll(const Name: String;
                       DefKind: TPAXDefKind;
                       Owner: TPAXDefinition;
                       Scripter: Pointer = nil): TList;
    function LookupFullName(const FullName: String): TPAXDefinition;
    procedure Clear; override;
    function FindClassDef(PClass: TClass): TPAXClassDefinition;
    function FindInterfaceTypeDef(const Guid: TGuid): TPAXClassDefinition;
    function FindClassDefByPTI(pti: PTypeInfo): TPAXClassDefinition;
    function FindClassDefByName(const Name: String): TPAXClassDefinition;
    function FindRTTITypeDef(pti: PTypeInfo): TPAXRTTITypeDefinition;
    function FindRTTITypeDefByName(const Name: String): TPAXRTTITypeDefinition;
    function FindObjectDef(Instance: TObject; Owner: TPaxDefinition): TPAXObjectDefinition;
    function AddField(PClass: TClass; const FieldName, FieldType: String; Offset: Integer): TPaxFieldDefinition;
    function AddRecordField(Owner: TPaxClassDefinition; const FieldName,
                            FieldType: String;
                            Offset: Integer): TPaxRecordFieldDefinition;
    function FindMethod(const ClassName, MethodName: String): TPAXMethodDefinition;
    function FindField(const ClassName, FieldName: String): TPAXFieldDefinition;
    function AddNamespace(const Name: String; Owner: TPAXClassDefinition): TPAXClassDefinition;
    function AddClass1(const Name: String; Owner, Ancestor: TPAXClassDefinition;
                      ReadProp, WriteProp: TPAXMethodImpl): TPAXClassDefinition;
    function AddClass2(PClass: TClass;
                      Owner: TPAXClassDefinition;
                      ReadProp, WriteProp: TPAXMethodImpl;
                      ClassKind: TPAXClassKind = ckClass): TPAXClassDefinition;
    function AddMethod1(const Header: String; Address: Pointer;
                       Owner: TPAXDefinition; Static: Boolean = false): TPAXMethodDefinition;
    function AddMethod2(PClass: TClass; const Header: String; Address: Pointer;
                       Static: Boolean = false): TPAXMethodDefinition;
    function AddMethod3(const Name: String;
                       Proc: TPAXMethodImpl;
                       NP: Integer;
                       Owner: TPAXClassDefinition;
                       Static: Boolean = false): TPAXMethodDefinition;
    function AddMethod4(PClass: TClass;
                       const Name: String;
                       Proc: TPAXMethodImpl;
                       NP: Integer;
                       Static: Boolean = false): TPAXMethodDefinition;
    function AddMethod5(pti: PTypeInfo; const Header: String): TPAXMethodDefinition;
    function AddMethod6(const Guid: TGuid; const Header: String;
                        InitMethodIndex: Integer = -1): TPAXMethodDefinition;
    function AddFakeMethod(PClass: TClass; const Header: String; Address: Pointer;
                       Static: Boolean = false): TPAXMethodDefinition;
    function AddProperty1(PClass: TClass;
                         const Name: String;
                         ProcRead: TPAXMethodImpl;
                         NPRead: Integer;
                         ProcWrite: TPAXMethodImpl;
                         NPWrite: Integer;
                         Default: Boolean = false): TPAXPropertyDefinition; overload;
    function AddProperty2(PClass: TClass; const Name: String;
                         ReadDef, WriteDef: TPAXMethodDefinition;
                         Default: Boolean = false): TPAXPropertyDefinition; overload;
    function AddProperty3(PClass: TClass; const PropDef: String): TPAXPropertyDefinition; overload;
    function AddInterfaceProperty(const guid: TGUID; const PropDef: String): TPAXPropertyDefinition;
    function AddVariable(const Name, TypeName: String;
                         Address: Pointer;
                         Owner: TPAXClassDefinition;
                         Scripter: Pointer = nil): TPAXVariableDefinition;
    function AddObject(const Name: String;
                       Instance: TObject;
                       Owner: TPAXClassDefinition;
                       Scripter: Pointer = nil): TPAXObjectDefinition;
    function AddVirtualObject(const Name: String;
                              Owner: TPAXClassDefinition;
                              Scripter: Pointer = nil): TPAXVirtualObjectDefinition;
    function AddInterfaceVar(const Name: String;
                                            PIntf: PUnknown;
                                            const guid: TGUID;
                                            Owner: TPAXClassDefinition;
                                            Scripter: Pointer = nil): TPAXInterfaceVarDefinition;
    function AddConstant(const Name: String;
                         const Value: Variant;
                         Owner: TPAXClassDefinition;
                         Static: Boolean = true;
                         ck: TPAXClassKind = ckNone;
                         Scripter: Pointer = nil): TPAXConstantDefinition;
    function AddRTTIType(pti: PTypeInfo): TPAXRTTITypeDefinition;
    function AddInterfaceType(const Name: String; Guid: TGuid;
                              const ParentName: String; ParentGuid: TGUID;
                              Owner: TPaxClassDefinition): TPAXClassDefinition;

    function AddEnumTypeByDef(const TypeDef: WideString): TPAXClassDefinition;
    function AddDynamicArrayType(const TypeName, ElementTypeName: String;
                                 Owner: TPaxDefinition):TPAXClassDefinition;
    function AddRecordType(const TypeName: String;
                           Size: Integer;
                           Owner: TPaxDefinition):TPAXClassDefinition;
    procedure Dump(const FileName: String);

    function GetKind(Index: Integer): Integer;
    function GetCount(Index: Integer): Integer;
    function GetName(Index: Integer): String;
    function GetParamTypeName(Index, ParamIndex: Integer): String;
    function GetParamName(Index, ParamIndex: Integer): String;
    function GetTypeName(Index: Integer): String;
    function GetFullName(Index: Integer): String;
    function GetNameIndex(Index: Integer; Scripter: Pointer): Integer;

    function GetAddress(Scripter: Pointer; Index: Integer): Pointer;
    function GetUserData(Scripter: Pointer; Index: Integer): Integer;
    function GetVariant(Scripter: Pointer; Index: Integer): Variant;
    procedure PutVariant(Scripter: Pointer; Index: Integer; const Value: Variant);
    function GetPVariant(Scripter: Pointer; Index: Integer): PVariant;
    function GetRecordByIndex(Index: Integer): TPAXDefinition;
    procedure Unregister(const Name: String;
                         DefKind: TPAXDefKind;
                         Owner: TPAXDefinition;
                         Scripter: Pointer = nil);
    procedure UnregisterAll(DefKind: TPAXDefKind;
                            Scripter: Pointer);
    procedure UnregisterObject(Instance: TObject; Owner: TPaxDefinition);

    function UnregisterNamespace(const Namespacename: String): Boolean;
    property Records[Index: Integer]: TPAXDefinition read GetRecord;
  end;

  TPAXFieldRec = class
  public
    ObjectName: String;
    ObjectType: String;
    FieldName: String;
    FieldType: String;
    Address: Pointer;
  end;

  TPAXFieldList = class
  private
    fList: TList;
    function GetRecord(Index: Integer): TPAXFieldRec;
  public
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    procedure AddRec(const ObjectName: String;
                     ObjectType: String;
                     FieldName: String;
                     FieldType: String;
                     Address: Pointer);
    function FindRecord(const ObjectName: String;
                        ObjectType: String;
                        FieldName: String): TPAXFieldRec;
    procedure Clear;
    property Records[Index: Integer]: TPAXFieldRec read GetRecord;
  end;

  TPAXArray = class(TPersistent)
  private
    N: Integer;
    P: Pointer;
    L: Integer;
    fBounds: array of Integer;
    fIndexes: TPaxIds;
    fOwner: Variant;

    fLastIndex: Integer;
    fInputString: String;
    fIndex: Integer;
    function AddressOfElement: Pointer;
    function GetLength: Integer;
    procedure PutLength(Value: Integer);
  public
    Scripter: Pointer;
    TypeID: Integer;
    _ElSize: Integer;
    constructor Create(Bounds: array of Integer; typeID: Integer = typeVARIANT);
    destructor Destroy; override;
    procedure ReDim(Bounds: array of Integer);
    procedure _ReDim;
    procedure ClearIndexes;
    function AddIndex(I: Integer): Integer;
    procedure InsertIndex(I: Integer);
    function _GetPtr: PVariant;
    function _GetPtrEx: PVariant;
    function _Get: Variant;
    function _GetEx: Variant;
    procedure _Put(const Value: Variant);
    procedure _PutEx(const Value: Variant);
    function Get(const Indexes: array of Integer): Variant;
    procedure Put(const Indexes: array of Integer; const Value: Variant);
    function GetPtr(const Indexes: array of Integer): PVariant;
    function GetEx(const Indexes: array of Integer): Variant;
    procedure PutEx(const Indexes: array of Integer; const Value: Variant);
    function CheckIndexes(const Indexes: array of Integer): Boolean;
    function _CheckIndexes: Boolean;
    function Duplicate: Variant;
    function ToString: String;
    function HighBound(Dim: Integer): Integer;
    function Typed: Boolean;
    property Buffer: Pointer read P;
  published
    property Owner: Variant read fOwner write fOwner;
    property DimCount: Integer read L write L;
    property Length: Integer read GetLength write PutLength;

    property Index: Integer read fIndex write fIndex;
    property LastIndex: Integer read fLastIndex write fLastIndex;
    property InputString: String read fInputString write fInputString;
  end;

function PaxArrayToDynamicArray(const V: Variant; ElTypeID: Integer): Pointer;
function PaxArrayToByteSet(const V: Variant): TByteSet;
function ByteSetToPaxArray(const S: TByteSet; Scripter: Pointer): Variant;
function StringToByteSet(pti: PTypeInfo; const V: String): TByteSet;
function ComparePaxArrays(A1, A2: TPaxArray): Boolean;
function UnaryPlus(const V: Variant): Variant;

function AddSets(const S1, S2: Variant): Variant;
function SubSets(const S1, S2: Variant): Variant;
function IntersectSets(const S1, S2: Variant): Variant;
function InSet(const Value, ASet: Variant): Boolean;
function IsSubSet(const S1, S2: Variant): Boolean;
function IsStrictSubSet(const S1, S2: Variant): Boolean;
function AreEqualSets(const S1, S2: Variant): Boolean;
function EqualVariants(Scripter: Pointer; const V1, V2: Variant;
                       T1: Integer = -1;
                       T2: Integer = -1): TBoolean;

procedure Initialization_BASE_EXTERN;
procedure Finalization_BASE_EXTERN;

procedure AddTypeAlias(const T1, T2: String);
function FindTypeAlias(const TypeName: String; UpCase: Boolean): String;

var
  DefinitionList: TPAXDefinitionList;
  ArrayParamMethods: TStringList;
  TypeAliases: TStringList;
  UnresolvedTypes: TStringList;

  DefListInitialCount: Integer = 0;

  CheckDup: Boolean = false;

implementation

uses
  BASE_CLASS, BASE_SCRIPTER, PASCAL_PARSER, BASE_REGEXP, BASE_SYMBOL, PAX_RTTI;

function StringToByteSet(pti: PTypeInfo; const V: String): TByteSet;
var
  ptd: PTypeData;
  I: Byte;
  S: String;
begin
  result := [];
  if pti = nil then Exit;
  ptd := GetTypeData(pti);
  if ptd = nil then Exit;


  {$ifdef fp}
  pti := ptd^.CompType;
  {$else}
  pti := ptd^.CompType^;
  {$endif}
  if pti = nil then Exit;

  ptd := GetTypeData(pti);
  if ptd = nil then Exit;

  for I:= ptd.MinValue to ptd.MaxValue do
  begin
    S :=GetEnumName(pti, I);
    if Pos(S, V) > 0 then
      result := result + [TByteInt(I)];
  end;
end;

function PaxArrayToByteSet(const V: Variant): TByteSet;
var
  SO: TPAXScriptObject;
  PaxArray: TPAXArray;
  I, L: Integer;
  Val: Byte;
begin
  SO := VariantToScriptObject(V);
  PaxArray := TPAXArray(SO.Instance);
  L := PaxArray.HighBound(1);
  result := [];
  for I:=0 to L - 1 do
  begin
    Val := PaxArray.Get([I]);
    Include(result, TByteInt(Val));
  end;
end;

function ByteSetToPaxArray(const S: TByteSet; Scripter: Pointer): Variant;
var
  I, K, L: Integer;
  PaxArray: TPaxArray;
  SO: TPaxScriptObject;
begin
  L := 0;
  for I:=0 to 255 do
    if TByteInt(I) in S then
      Inc(L);

  PaxArray := TPaxArray.Create([L-1]);
  PaxArray.Scripter := Scripter;

  K := -1;
  for I:=0 to 255 do
    if TByteInt(I) in S then
    begin
      Inc(K);
      PaxArray.Put([K], I);
    end;

  SO := TPAXBaseScripter(Scripter).ArrayClassRec.CreateScriptObject;
  SO.RefCount := 1;
  SO.Instance := PaxArray;
  result := ScriptObjectToVariant(SO);

end;

function _IndexOf(Scripter: Pointer; L: TPaxVarList; const Value: Variant): Integer;
var
  I: Integer;
  P: PVariant;
begin
  result := -1;
  for I:=1 to L.Count do
  begin
    P := L.GetAddress(I);
    if EqualVariants(Scripter, P^, Value) then
    begin
      result := I;
      Exit;
    end;
  end;
end;

function AddSets(const S1, S2: Variant): Variant;
var
  SO, SO1, SO2: TPaxScriptObject;
  A, A1, A2: TPaxArray;
  L: TPaxVarList;
  I, Index: Integer;
  P: PVariant;
  Scripter: Pointer;
begin
  SO1 := VariantToScriptObject(S1);
  SO2 := VariantToScriptObject(S2);
  A1 := TPaxArray(SO1.Instance);
  A2 := TPaxArray(SO2.Instance);

  Scripter := SO1.Scripter;

  L := TPaxVarList.Create;

  if A1.Length > 0 then
  for I:=0 to A1.Length - 1 do
  begin
    P := A1.GetPtr([I]);
    Index := _IndexOf(Scripter, L, P^);
    if Index = -1 then
      L.Add(P^);
  end;

  if A2.Length > 0 then
  for I:=0 to A2.Length - 1 do
  begin
    P := A2.GetPtr([I]);
    Index := _IndexOf(Scripter, L, P^);
    if Index = -1 then
      L.Add(P^);
  end;

  A := TPaxArray.Create([L.Count - 1]);
  A.Scripter := Scripter;
  for I:=1 to L.Count do
    A.Put([I-1], L[I]);

  L.Free;

  SO := TPAXBaseScripter(Scripter).ArrayClassRec.CreateScriptObject;
  SO.RefCount := 1;
  SO.Instance := A;
  result := ScriptObjectToVariant(SO);
end;

function SubSets(const S1, S2: Variant): Variant;
var
  SO, SO1, SO2: TPaxScriptObject;
  A, A1, A2: TPaxArray;
  L: TPaxVarList;
  I, Index: Integer;
  P: PVariant;
  Scripter: Pointer;
begin
  SO1 := VariantToScriptObject(S1);
  SO2 := VariantToScriptObject(S2);
  A1 := TPaxArray(SO1.Instance);
  A2 := TPaxArray(SO2.Instance);

  Scripter := SO1.Scripter;

  L := TPaxVarList.Create;

  if A1.Length > 0 then
  for I:=0 to A1.Length - 1 do
  begin
    P := A1.GetPtr([I]);
    Index := _IndexOf(Scripter, L, P^);
    if Index = -1 then
      L.Add(P^);
  end;

  if A2.Length > 0 then
  for I:=0 to A2.Length - 1 do
  begin
    P := A2.GetPtr([I]);
    Index := _IndexOf(Scripter, L, P^);
    if Index <> -1 then
      L.Delete(Index);
  end;

  A := TPaxArray.Create([L.Count - 1]);
  A.Scripter := Scripter;
  for I:=1 to L.Count do
    A.Put([I-1], L[I]);

  L.Free;

  SO := TPAXBaseScripter(Scripter).ArrayClassRec.CreateScriptObject;
  SO.RefCount := 1;
  SO.Instance := A;
  result := ScriptObjectToVariant(SO);
end;

function IntersectSets(const S1, S2: Variant): Variant;
var
  SO, SO1, SO2: TPaxScriptObject;
  A, A1, A2: TPaxArray;
  L: TPaxVarList;
  I, J, Index: Integer;
  P1, P2: PVariant;
  Scripter: Pointer;
begin
  SO1 := VariantToScriptObject(S1);
  SO2 := VariantToScriptObject(S2);
  A1 := TPaxArray(SO1.Instance);
  A2 := TPaxArray(SO2.Instance);

  Scripter := SO1.Scripter;

  L := TPaxVarList.Create;

  if A1.Length > 0 then
  for I:=0 to A1.Length - 1 do
  begin
    P1 := A1.GetPtr([I]);
    Index := _IndexOf(Scripter, L, P1^);
    if Index = -1 then
    begin
      for J:=0 to A2.Length - 1 do
      begin
        P2 := A2.GetPtr([J]);
        if EqualVariants(Scripter, P1^, P2^) then
        begin
          Index := J;
          Break;
        end;
      end;
      if Index <> -1 then
        L.Add(P1^);
    end;
  end;

  A := TPaxArray.Create([L.Count - 1]);
  A.Scripter := Scripter;
  for I:=1 to L.Count do
    A.Put([I-1], L[I]);

  L.Free;

  SO := TPAXBaseScripter(Scripter).ArrayClassRec.CreateScriptObject;
  SO.RefCount := 1;
  SO.Instance := A;
  result := ScriptObjectToVariant(SO);
end;

function IsSubSet(const S1, S2: Variant): Boolean;
var
  SO1, SO2: TPaxScriptObject;
  A1, A2: TPaxArray;
  I, J: Integer;
  P1, P2: PVariant;
  Scripter: Pointer;
  Found: Boolean;
begin
  SO1 := VariantToScriptObject(S1);
  SO2 := VariantToScriptObject(S2);
  A1 := TPaxArray(SO1.Instance);
  A2 := TPaxArray(SO2.Instance);

  Scripter := SO1.Scripter;

  result := true;

  if A1.Length > 0 then
  for I:=0 to A1.Length - 1 do
  begin
    P1 := A1.GetPtr([I]);
    Found := false;
    for J:=0 to A2.Length - 1 do
    begin
      P2 := A2.GetPtr([J]);
      Found := EqualVariants(Scripter, P1^, P2^);
      if Found then
        Break;
    end;
    if not Found then
    begin
      result := false;
      Exit;
    end;
  end;
end;

function IsStrictSubSet(const S1, S2: Variant): Boolean;
var
  SO1, SO2: TPaxScriptObject;
  A1, A2: TPaxArray;
begin
  SO1 := VariantToScriptObject(S1);
  SO2 := VariantToScriptObject(S2);
  A1 := TPaxArray(SO1.Instance);
  A2 := TPaxArray(SO2.Instance);
  result := IsSubSet(S1, S2) and (A1.Length < A2.Length);
end;

function AreEqualSets(const S1, S2: Variant): Boolean;
var
  SO1, SO2: TPaxScriptObject;
  A1, A2: TPaxArray;
  I, J: Integer;
  P1, P2: PVariant;
  Found: Boolean;
  Scripter: Pointer;
begin
  SO1 := VariantToScriptObject(S1);
  SO2 := VariantToScriptObject(S2);
  A1 := TPaxArray(SO1.Instance);
  A2 := TPaxArray(SO2.Instance);

  Scripter := SO1.Scripter;

  result := true;

  if A1.Length > 0 then
  for I:=0 to A1.Length - 1 do
  begin
    P1 := A1.GetPtr([I]);
    Found := false;
    for J:=0 to A2.Length - 1 do
    begin
      P2 := A2.GetPtr([J]);
      Found := EqualVariants(Scripter, P1^, P2^);
      if Found then
        Break;
    end;
    if not Found then
    begin
      result := false;
      Exit;
    end;
  end;

  if A2.Length > 0 then
  for I:=0 to A2.Length - 1 do
  begin
    P1 := A2.GetPtr([I]);
    Found := false;
    for J:=0 to A1.Length - 1 do
    begin
      P2 := A1.GetPtr([J]);
      Found := EqualVariants(Scripter, P1^, P2^);
      if Found then
        Break;
    end;
    if not Found then
    begin
      result := false;
      Exit;
    end;
  end;

end;

function InSet(const Value, ASet: Variant): Boolean;
var
  SO: TPaxScriptObject;
  A: TPaxArray;
  I: Integer;
  P: PVariant;
  Scripter: Pointer;
begin
  SO := VariantToScriptObject(ASet);
  A := TPaxArray(SO.Instance);
  Scripter := SO.Scripter;

  result := false;

  if IsPaxArray(Value) then
  begin
    result := true;
    SO := VariantToScriptObject(Value);
    A := TPaxArray(SO.Instance);
    for I:=0 to A.Length - 1 do
    begin
      P := A.GetPtr(I);
      result := result and InSet(P^, ASet);
      if not result then
        Break;
    end;
  end
  else
    for I:=0 to A.Length - 1 do
    begin
      P := A.GetPtr(I);
      if EqualVariants(Scripter, P^, Value) then
      begin
        result := true;
        Exit;
      end;
    end;
end;

function EqualVariants(Scripter: Pointer; const V1, V2: Variant;
                       T1: Integer = -1;
                       T2: Integer = -1): TBoolean;
var
  SO1, SO2: TPaxScriptObject;
  IsSet: Boolean;
begin
  IsSet := (T1 = typeSET) or (T2 = typeSET);

  T1 := VarType(V1);
  T2 := VarType(V2);
  if T1 = T2 then
  begin
    if T1 in [varEmpty, varNull] then
    begin
      result := true;
      Exit;
    end;

    if T1 = varScriptObject then
    begin
      SO1 := VariantToScriptObject(V1);
      SO2 := VariantToScriptObject(V2);
      if IsPaxArray(V1) and IsPaxArray(V2) then
      begin
        if IsSet then
          result := AreEqualSets(V1, V2)
        else
          result := ComparePaxArrays(TPaxArray(SO1.Instance),
                                     TPaxArray(SO2.Instance));
        Exit;
      end
      else
      begin
        result := SO1 = SO2;
        Exit;
      end;
    end;
    result := V1 = V2;
  end
  else
  begin
    if T1 in [varEmpty, varNull] then
      result := false
    else if T2 in [varEmpty, varNull] then
      result := false
    else
      result := V1 = V2;
  end;

{

  else if (T1 in [varByte, varInteger, varDouble, varVariant, varCurrency]) and (T2 in [varByte, varInteger, varDouble, varVariant, varCurrency]) then
    result := V1 = V2
  else if ((T1 = varString) or (T1 = varOleStr)) and ((T2 = varString) or (T2 = varOleStr)) then
    result := V1 = V2;
}
end;

function PaxArrayToDynamicArray(const V: Variant; ElTypeID: Integer): Pointer;
var
  L, I, ElSize: Integer;
  P: Pointer;
  SO: TPAXScriptObject;
  PaxArray: TPAXArray;
  Val: Variant;
begin
  if not IsObject(V) then
  begin
    result := AllocMem(2*SizeOf(Integer));
    Integer(result^) := 1;
    P := ShiftPointer(result, SizeOf(Integer));
    Integer(P^) := 0;
    P := ShiftPointer(P, SizeOf(Integer));
    result := P;
    Exit;
  end;

  SO := VariantToScriptObject(V);
  PaxArray := TPAXArray(SO.Instance);

  L := PaxArray.HighBound(1);
  ElSize := PaxTypes.GetSize(ElTypeID);
  result := AllocMem(2*SizeOf(Integer) +  L * ElSize);
  P := ShiftPointer(result, SizeOf(Integer));
  Integer(P^) := L;
  P := ShiftPointer(P, SizeOf(Integer));
  result := P;
  for I:=0 to L - 1 do
  begin
    Val := PaxArray.Get([I]);
    if IsPaxArray(Val) then
      Pointer(P^) := PaxArrayToDynamicArray(Val, ElTypeID)
    else
      PutVariantValue(SO.Scripter, P, Val, ElTypeID);
    P := ShiftPointer(P, ElSize);
  end;
end;

function ComparePaxArrays(A1, A2: TPaxArray): Boolean;
var
  I: Integer;
  P1, P2: PVariant;
  Scripter: Pointer;
begin
  result := false;

  if A1.N <> A2.N then
    Exit;

  if A1.L <> A2.L then
    Exit;

  for I:=0 to A1.L - 1 do
    if A1.fBounds[I] <> A2.fBounds[I] then
      Exit;

  Scripter := A1.Scripter;

  P1 := A1.P;
  P2 := A2.P;
  for I:=0 to A1.N - 1 do
  begin
    if not EqualVariants(Scripter, P1^, P2^) then
      Exit;
    P1 := ShiftPointer(P1, _SizeVariant);
    P2 := ShiftPointer(P2, _SizeVariant);
  end;
  result := true;
end;

function UnaryPlus(const V: Variant): Variant;
var
  SO: TPaxScriptObject;
begin
  if IsObject(V) then
  begin
    SO := VariantToScriptObject(V);
    if IsPaxArray(V) then
    begin
      result := TPaxArray(SO.Instance).Duplicate;
      Exit;
    end;
  end;
  result := V;
end;

constructor TPAXArray.Create(Bounds: array of Integer; typeID: Integer = typeVARIANT);
var
  I: Integer;
begin
  if typeID = 0 then
    typeID := typeVARIANT;
  if TypeID > PaxTypes.Count then
    typeID := typeVARIANT;

  Self.TypeID := typeID;
  _ElSize := _SizeVariant;

  if TypeID < PaxTypes.Count then
    if TypeID <> typeVARIANT then
      _ElSize := PaxTypes.GetSize(typeID);

  L := System.Length(Bounds);
  SetLength(Self.fBounds, L);
  N := 1;
  for I:=0 to L - 1 do
  begin
    Self.fBounds[I] := Bounds[I] + 1;
    N := N * Self.fBounds[I];
  end;
  P := AllocMem(N * _ElSize);

  fIndexes := TPAXIds.Create(true);

  Scripter := nil;
end;

function TPAXArray.Typed: Boolean;
begin
  result := typeID <> typeVARIANT;
end;

function TPAXArray.Duplicate: Variant;
var
  I: Integer;
  Q, R: PVariant;
  PaxArray: TPaxArray;
  SO: TPaxScriptObject;
  B: array of Integer;
  Q1, R1: Pointer;
begin
  SetLength(B, L);
  for I:=0 to L - 1 do
    B[I] := fBounds[I] - 1;

  PaxArray := TPaxArray.Create(B);
  PaxArray.Scripter := Scripter;

  if _ElSize = _SizeVariant then
  begin
    Q := P;
    R := PaxArray.P;
    for I:=0 to N - 1 do
    begin
      if IsPaxArray(Q^) then
      begin
        SO := VariantToScriptObject(Q^);
        R^ := TPaxArray(SO.Instance).Duplicate;
      end
      else
        R^ := Q^;
      Q := ShiftPointer(Q, _ElSize);
      R := ShiftPointer(R, _ElSize);
    end;
  end
  else
  begin
    Q1 := P;
    R1 := PaxArray.P;
    for I:=0 to N - 1 do
    begin
      if typeID = typeSTRING then
        String(R1^) := String(Q1^)
      else
        Move(Q1^, R1^, _ElSize);
      Q1 := ShiftPointer(Q1, _ElSize);
      R1 := ShiftPointer(R1, _ElSize);
    end;
  end;

  result := ScriptObjectToVariant(DelphiInstanceToScriptObject(PaxArray, Scripter));
end;

procedure TPAXArray.ReDim(Bounds: array of Integer);
var
  I, OldN, MinN: Integer;
  Q: Pointer;
begin
  OldN := N;

  L := System.Length(Bounds);
  SetLength(Self.fBounds, L);
  N := 1;
  for I:=0 to L - 1 do
  begin
    Self.fBounds[I] := Bounds[I] + 1;
    N := N * Self.fBounds[I];
  end;
  Q := AllocMem(N * _ElSize);

  MinN := OldN;
  if N < OldN then
    MinN := N;
  Move(P^, Q^, MinN * _ElSize);

  FreeMem(P, OldN);
  P := Q;
end;

function TPAXArray.GetLength: Integer;
begin
  result := fBounds[0];
end;

procedure TPAXArray.PutLength(Value: Integer);
begin
  if GetLength <> Value then
  begin
    fBounds[0] := Value - 1;
    ReDim(fBounds);
  end;
end;

procedure TPAXArray._ReDim;
var
  I, OldN, MinN: Integer;
  Q: Pointer;
begin
  OldN := N;

  L := fIndexes.Count;
  SetLength(Self.fBounds, L);
  N := 1;
  for I:=0 to L - 1 do
  begin
    Self.fBounds[I] := fIndexes[I] + 1;
    N := N * Self.fBounds[I];
  end;
  Q := AllocMem(N * _ElSize);

  MinN := OldN;
  if N < OldN then
    MinN := N;
  Move(P^, Q^, MinN * _ElSize);

  FreeMem(P, OldN);
  P := Q;
end;

destructor TPAXArray.Destroy;
var
  I, VT: Integer;
  Ptr: Pointer;
  SO: TPaxScriptObject;
begin
  Ptr := P;

  if typeID = typeVARIANT then
  begin
    for I:=0 to N - 1 do
    begin
      VT := VarType(Variant(Ptr^));
      if VT = varString then
         Variant(Ptr^) := ''
      else if VT = varScriptObject then
      begin
        SO := VariantToScriptObject(Variant(Ptr^));
        if TPaxBaseScripter(scripter).ScriptObjectList.HasObject(SO) then
          SO.RefCount := 1;
        VarClear(Variant(Ptr^));
      end;

      Inc(Integer(Ptr), _ElSize);
    end;
  end
  else
  begin
    for I:=0 to N - 1 do
    begin
      if typeID = typeSTRING then
         String(Ptr^) := '';
      Inc(Integer(Ptr), _ElSize);
    end;
  end;

  FreeMem(P, N * _ElSize);
  fIndexes.Free;
  inherited;
end;

function TPAXArray.HighBound(Dim: Integer): Integer;
begin
  result := fBounds[Dim - 1];
end;

function TPAXArray.ToString: String;

var
  B: array[0..100] of Integer;

function F(Q: Pointer; I: Integer; var SZ: Integer): String;
var
  K, TempSZ: Integer;
begin
  if I >= L then
  begin
    if Scripter = nil then
      result := VarToStr(GetTerminal(Q)^)
    else
      result := BASE_CLASS._ToStr(Scripter, GetTerminal(Q)^);
    SZ := _ElSize;
    Exit;
  end;

  with TPaxBaseScripter(Scripter).Visited do
  if (IndexOf(Q) = -1) then
    Add(Q)
  else
  begin
    SZ := _ElSize;
    result := '...';
    Exit;
  end;

  result := '[';

  SZ := 0;

  for K:=1 to B[I] do
  begin
    result := result + F(Q, I + 1, TempSZ);
    if K < B[I] then
      result := result + ',';
    Inc(Integer(Q), TempSZ);
    Inc(SZ, TempSZ);
  end;

  result := result + ']';
end;

var
  I, SZ: Integer;
begin
  for I:=0 to L - 1 do
    B[I] := fBounds[L - 1 - I];

  if typeID = typeVARIANT then
    result := F(P, 0, SZ)
  else
    result := 'array';
end;

function TPAXArray.AddressOfElement: Pointer;
var
  I, J, R: Integer;
begin
  if L > fIndexes.Count then
    raise TPAXScriptFailure.Create(errNotEnoughParameters)
  else if L < fIndexes.Count then
    raise TPAXScriptFailure.Create(errTooManyParameters);

  J := fIndexes[0];
  R := 1;
  for I:=1 to L - 1 do
  begin
    R := R * fBounds[I-1];
    Inc(J, R * fIndexes[I]);
  end;
  result := Pointer(Integer(P) + J * _ElSize);
end;

function TPAXArray._Get: Variant;
var
  Q: Pointer;
begin
  Q := AddressOfElement;

  if TypeID = typeVARIANT then
    result := PVariant(Q)^
  else
    result := GetVariantValue(scripter, Q, typeID);
end;

function TPAXArray._GetPtr: PVariant;
begin
  result := AddressOfElement;
end;

function TPAXArray._GetEx: Variant;
begin
  if not _CheckIndexes then
    _ReDim;
  result := _Get;
end;

function TPAXArray._GetPtrEx: PVariant;
begin
  if not _CheckIndexes then
    _ReDim;

  result := AddressOfElement;
end;

procedure TPAXArray._Put(const Value: Variant);
var
  Q: Pointer;
begin
  Q := AddressOfElement;

  if TypeID = typeVARIANT then
    PVariant(Q)^ := Value
  else
    PutVariantValue(scripter, Q, Value, typeID);
end;

procedure TPAXArray._PutEx(const Value: Variant);
begin
  if not _CheckIndexes then
    _ReDim;

  _Put(Value);
end;

procedure TPAXArray.ClearIndexes;
begin
  fIndexes.Clear;
end;

function TPAXArray.AddIndex(I: Integer): Integer;
begin
  result := fIndexes.Add(I);
end;

procedure TPAXArray.InsertIndex(I: Integer);
begin
  fIndexes.Insert(0, Pointer(I));
end;

function TPAXArray.Get(const Indexes: array of Integer): Variant;
var
  I: Integer;
begin
  fIndexes.Clear;
  for I:=0 to System.Length(Indexes) - 1 do
    fIndexes.Add(Indexes[I]);
  result := _Get;
end;

function TPAXArray.GetPtr(const Indexes: array of Integer): PVariant;
var
  I: Integer;
begin
  fIndexes.Clear;
  for I:=0 to System.Length(Indexes) - 1 do
    fIndexes.Add(Indexes[I]);
  result := AddressOfElement;
end;

procedure TPAXArray.Put(const Indexes: array of Integer; const Value: Variant);
var
  I: Integer;
begin
  fIndexes.Clear;
  for I:=0 to System.Length(Indexes) - 1 do
    fIndexes.Add(Indexes[I]);
  _Put(Value);
end;

function TPAXArray._CheckIndexes: Boolean;
var
  I, Idx: Integer;
begin
  for I:=0 to fIndexes.Count - 1 do
  begin
    Idx := fIndexes[I] + 1;
    if Idx > fBounds[I] then
    begin
      result := False;
      Exit;
    end;
  end;
  result := true;
end;

function TPAXArray.CheckIndexes(const Indexes: array of Integer): Boolean;
var
  I, Idx: Integer;
begin
  result := true;
  for I:=0 to L - 1 do
  begin
    Idx := Indexes[I] + 1;
    if Idx > fBounds[I] then
    begin
      result := False;
      Exit;
    end;
  end;
end;

procedure TPAXArray.PutEx(const Indexes: array of Integer; const Value: Variant);
begin
  if not CheckIndexes(Indexes) then
    ReDim(Indexes);
  Put(Indexes, Value);
end;

function TPAXArray.GetEx(const Indexes: array of Integer): Variant;
begin
  if not CheckIndexes(Indexes) then
    ReDim(Indexes);
  result := Get(Indexes);
end;

function IsScripters: Boolean;
begin
  if Assigned(ScripterList) then
    result := ScripterList.Count > 0
  else
    result := false;
end;

procedure _Dump(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    TPAXBaseScripter(Scripter).Dump;
end;

procedure _IOResult(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsInteger := IOResult;
end;

procedure _ScriptObjectListCount(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsInteger := TPAXBaseScripter(Scripter).ScriptObjectList.Count;
end;

procedure _Destroy(MethodBody: TPAXMethodBody);
var
  SO: TPaxScriptObject;
  P: PVariant;
begin
  with MethodBody do
  begin
    P := Params[0].PValue;
    if IsObject(P^) then
    begin
      SO := VariantToScriptObject(P^);
      TPAXBaseScripter(Scripter).ScriptObjectList.RemoveObject(SO);
    end;
    VarClear(P^);
  end;
end;

procedure _PaxArray(MethodBody: TPAXMethodBody);
var
  PaxArray: TPaxArray;
  Bounds: array of Integer;
  I: Integer;
  SO: TPaxScriptObject;
begin
  with MethodBody do
  begin
    SetLength(Bounds, ParamCount);
    for I:=0 to ParamCount - 1 do
      Bounds[I] := Params[I].AsInteger - 1;

    PaxArray := TPaxArray.Create(Bounds);
    PaxArray.Scripter := Scripter;

    SO := DelphiInstanceToScriptObject(PaxArray, Scripter);
    result.AsVariant := ScriptObjectToVariant(SO);
  end;
end;

procedure _GetTickCount(MethodBody: TPAXMethodBody);
begin
{$IFDEF WIN32}
  with MethodBody do
  begin
    result.AsInteger := GetTickCount;
  end;
{$ENDIF}
end;

procedure _GetTotalAllocated(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
{$IFDEF WIN32}
  with MethodBody do
  begin
    D := GetHeapStatus.TotalAllocated;
    result.AsVariant := D;
  end;
{$ELSE}
    result.AsVariant := 0;
{$ENDIF}

end;

procedure _Sleep(MethodBody: TPAXMethodBody);
begin
{$IFDEF WIN32}
  with MethodBody do
    Sleep(Params[0].AsInteger);
{$ENDIF}
end;

procedure _CreateArray(MethodBody: TPAXMethodBody);
var
  HBound: Integer;
begin
  with MethodBody do
  begin
    HBound := Params[0].AsInteger;
    result.AsVariant := varArrayCreate([0, HBound], varVariant);
  end;
end;

procedure _DoNotDestroy(MethodBody: TPAXMethodBody);
var
  V: Variant;
  SO: TPAXScriptObject;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    SO := VariantToScriptObject(V);
    SO.RefCount := 0;
  end;
end;

procedure _Assigned(MethodBody: TPAXMethodBody);
var
  V: Variant;
  SO: TPAXScriptObject;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);
      result.AsBoolean := TPAXBaseScripter(Scripter).ScriptObjectList.HasObject(SO);
    end
    else
      result.AsBoolean := false;
  end;
end;

constructor TPAXParameter.Create(AScripter: Pointer);
begin
  Scripter := AScripter;
  Clear;
end;

destructor TPAXParameter.Destroy;
begin
  inherited;
end;

procedure TPAXParameter.Clear;
begin
  PValue := nil;
  VType := varUndefined;
end;

function TPAXParameter.GetAsString: String;
var
  V: Variant;
begin
  V := Variant(PValue^);
  result := ToStr(Scripter, V);
end;

procedure TPAXParameter.SetAsString(const Value: String);
var
  S: String;
begin
  S := ToStr(Scripter, Value);
  Variant(PValue^) := S;
  VType := varString;
end;

function TPAXParameter.GetAsBoolean: Boolean;
var
  V: Variant;
begin
  V := Variant(PValue^);
  result := ToBoolean(V);
end;

procedure TPAXParameter.SetAsBoolean(Value: Boolean);
begin
  Variant(PValue^) := ToBoolean(Value);
  VType := varBoolean;
end;

function TPAXParameter.GetAsInteger: Integer;
begin
  result := ToInteger(PValue^);
end;

procedure TPAXParameter.SetAsInteger(Value: Integer);
begin
  Variant(PValue^) := Value;
end;

function ToCardinal(const V: Variant): Cardinal;
var
  D: Double;
begin
  case VarType(V) of
    varInteger: result := V;
    varDouble:
    begin
      D := V;
      result := Round(D);
    end;
    else
      raise TPAXScriptFailure.Create(errIncompatibleTypes);
  end;
end;

function TPAXParameter.GetAsCardinal: Cardinal;
begin
  result := toCardinal(PValue^);
end;

procedure TPAXParameter.SetAsCardinal(Value: Cardinal);
var
  Dbl: Double;
begin
  if Value > Cardinal(MaxInt) then
  begin
    Dbl := Value;
    Variant(PValue^) := Dbl;
  end
  else
    Variant(PValue^) := Integer(Value);
end;

function TPAXParameter.GetAsPointer: Pointer;
var
  SO: TPaxScriptObject;
begin
  if IsObject(PValue^) then
  begin
    SO := VariantToScriptObject(PValue^);
    if SO.ClassRec.fClassDef <> nil then
      result := SO.Instance
    else
      result := SO;  
  end
  else
    result := Pointer(Integer(PValue^));
end;

procedure TPAXParameter.SetAsPointer(Value: Pointer);
var
  Instance: TObject;
  AClass: TClass;
begin
  if IsDelphiObject(Value) then
  begin
    Instance := TObject(Value);
    if Instance.ClassType = TPaxScriptObject then
    begin
      Variant(PValue^) := Integer(Instance);
      TVarData(Variant(PValue^)).VType := varScriptObject;
    end
    else
      Variant(PValue^) := ScriptObjectToVariant(DelphiInstanceToScriptObject(Instance, Scripter));
  end
  else if IsDelphiClass(Value) then
  begin
    AClass := TClass(Value);
    Variant(PValue^) := ScriptObjectToVariant(DelphiClassToScriptObject(AClass, Scripter));
  end
  else
    Variant(PValue^) := Integer(Value);
end;

function TPAXParameter.GetAsDouble: Double;
begin
  result := PValue^;
end;

procedure TPAXParameter.SetAsDouble(Value: Double);
begin
  Variant(PValue^) := Value;
end;

function TPAXParameter.GetAsTObject: TObject;
var
  V: Variant;
begin
  V := Variant(PValue^);
  result := TObject(ToInteger(V));
  VType := varScriptObject;
end;

procedure TPAXParameter.SetAsTObject(Value: TObject);
begin
  Variant(PValue^) := Integer(Value);
  VType := varScriptObject;
end;

function TPAXParameter.GetAsVariant: Variant;
begin
  result := Variant(PValue^);
end;

procedure TPAXParameter.SetAsVariant(const Value: Variant);
begin
  Variant(PValue^) := Value;
  VType := VarType(Value);
end;

constructor TPAXParameterList.Create(AScripter: Pointer);
var
  I: Integer;
begin
  inherited Create;
  Scripter := AScripter;
  for I:=0 to MaxParams - 1 do
    Add(TPAXParameter.Create(AScripter));
end;

procedure TPAXParameterList.Clear;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    TPAXParameter(Items[I]).Free;

  inherited;
end;

constructor TPAXMethodBody.Create(Scripter: Pointer);
begin
  Self.Scripter := Scripter;
  fResult := TPAXParameter.Create(Scripter);
  PSelf := nil;
  fParameterList := TPAXParameterList.Create(Scripter);
  fParamCount := 0;
end;

procedure TPAXMethodBody.AddParameters(K: Integer);
begin
  while fParameterList.Count < K do
    fParameterList.Add(TPAXParameter.Create(Scripter));
end;

function TPAXMethodBody.GetSelf: TObject;
begin
  if PSelf = nil then
    result := nil
  else
    result := TObject(PSelf^);
end;

procedure TPAXMethodBody.SetSelf(Value: TObject);
begin
  if PSelf <> nil then
    TObject(PSelf^) := Value;
end;

destructor TPAXMethodBody.Destroy;
begin
  fResult.Free;
  fParameterList.Free;
end;

function TPAXMethodBody.FindNestedClass(const NamespaceName, ClassName: String): Pointer;
var
  OwnerList: TStringList;
begin
  OwnerList := TStringList.Create;
  if NamespaceName <> '' then
    OwnerList.Add(NamespaceName);
  result := TPAXBaseScripter(Scripter).ClassList.FindNestedClass(OwnerList, ClassName);
  OwnerList.Free;
end;

function TPAXMethodBody.DefaultValue: Variant;
begin
  result := Undefined;
  if PSelf = nil then
    Exit;
  if GetSelf().InheritsFrom(TPAXScriptObject) then
   result := TPAXScriptObject(GetSelf()).DefaultValue;
end;

procedure TPAXMethodBody.Clear;
begin
  fResult.Clear;
  PSelf := nil;
end;

function TPAXMethodBody.GetParameter(I: Integer): TPAXParameter;
begin
  if I >= fParameterList.Count then
    AddParameters(I + 10);

  result := fParameterList[I];
end;

procedure TPAXMethodBody.SetParameter(I: Integer; Value: TPAXParameter);
begin
  if I >= fParameterList.Count then
    AddParameters(I + 10);

  fParameterList[I] := Value;
end;

function TPAXMethodBody.GetField(I: Integer): TPAXParameter;
begin
  if I >= fParameterList.Count then
    AddParameters(I + 10);

  result := fParameterList[I];
end;

procedure TPAXMethodBody.SetField(I: Integer; Value: TPAXParameter);
begin
  if I >= fParameterList.Count then
    AddParameters(I + 10);

  fParameterList[I] := Value;
end;

constructor TPAXDefinition.Create(DefList: TPAXDefinitionList;
                               const Name: String; Owner: TPAXDefinition;
                               DefKind: TPAXDefKind);
begin
  Self.DefList := DefList;
  Self.Name := Name;
  Self.Owner := Owner;
  Self.DefKind := DefKind;
  UserData := 0;
  Module := -1;
  ResultType := '';
end;

function TPAXDefinition.FullName: String;
begin
  if Owner <> nil then
    result := Owner.FullName + '.' + Name
  else
    result := Name;
end;

function TPAXDefinition.GetValue: Variant;
begin
  result := DefValue;
end;

function TPAXDefinition.PValue: PVariant;
begin
  result := @ DefValue;
end;

procedure TPAXDefinition.SetValue(const AValue: Variant);
begin
  DefValue := AValue;
end;

procedure TPAXDefinition.AddToScripter(Scripter: Pointer);
begin
end;

procedure TPAXDefinition.AddToScripterList;
var
  I: Integer;
begin
  if Assigned(ScripterList) then
  begin
    for I:=0 to ScripterList.Count - 1 do
      AddToScripter(ScripterList[I]);
  end;
end;

constructor TPaxFieldDefinition.Create(DefList: TPAXDefinitionList; PClass: TClass; const FieldName,
                                       FieldType: String; Offset: Integer);
var
  Owner: TPaxDefinition;
  S: String;
begin
  Owner := DefList.FindClassDef(PClass);
  inherited Create(DefList, FieldName, Owner, dkField);
  Self.PClass := PClass;
  Self.FieldType := FieldType;
  Self.Offset := Offset;
  Self.TypeID := PAXTypes.IndexOf(UpperCase(FieldType));
  if Self.TypeID = -1 then
  begin
    S := FindTypeAlias(FieldType, true);
    Self.TypeID := PAXTypes.IndexOf(UpperCase(S));
  end;
end;

function TPAXFieldDefinition.GetFieldAddress(SO: pointer): Pointer;
var
  Address: Pointer;
begin
  Address := ShiftPointer(TPaxScriptObject(SO).Instance, Offset);
  DefValue := GetVariantValue(TPaxScriptObject(SO).Scripter, Address, TypeID);
  result := @DefValue;
end;

function TPaxFieldDefinition.GetFieldValue(SO: pointer): Variant;
begin
  GetFieldAddress(SO);
  result := DefValue;
end;

procedure TPaxFieldDefinition.SetFieldValue(SO: pointer; const Value: Variant);
var
  Address: Pointer;
begin
  Address := ShiftPointer(TPaxScriptObject(SO).Instance, Offset);
  PutVariantValue(TPaxScriptObject(SO).Scripter, Address, Value, TypeID);
end;

procedure TPaxFieldDefinition.Dump(var T: TextFile);
begin
  writeln(T, 'Field =', Name,  ' Type =', FieldType, ' Class =', PClass.ClassName,
             ' Offset =', Offset,
             ' Index =', Index);
end;

procedure TPaxFieldDefinition.AddToScripter(Scripter: Pointer);
var
  ClassRec: TPAXClassRec;
  ClassList: TPAXClassList;
begin
  ClassList := TPAXBaseScripter(Scripter).ClassList;
  ClassRec := ClassList.FindImportedClass(PClass);

  if (SignLoadOnDemand and (ClassRec = nil)) then
    ClassRec := TPAXBaseScripter(Scripter).ClassList.FindClassByName(Owner.Name);
  
  if ClassRec <> nil then
    ClassRec.AddHostField(Self)
  else
    raise TPAXScriptFailure.Create(Format(errClassIsNotImported, [PClass.ClassName]));
end;

constructor TPAXRecordFieldDefinition.Create(DefList: TPAXDefinitionList;
                                             Owner: TPaxClassDefinition;
                                             const FieldName, FieldType: String;
                                             Offset: Integer);
var
  FieldTypeDef: TPaxClassDefinition;
begin
  FieldTypeDef := DefList.FindClassDefByName(FieldType);

  inherited Create(DefList, FieldName, Owner, dkRecordField);
  Self.FieldType := FieldType;
  Self.Offset := Offset;
  Self.TypeID := PAXTypes.IndexOf(UpperCase(FieldType));

  if FieldTypeDef <> nil then
  begin
    if FieldTypeDef.ClassKind = ckEnum then
      Self.TypeID := typeENUM
    else if FieldTypeDef.ClassKind = ckStructure then
      Self.TypeID := typeRECORD
    else if FieldTypeDef.ClassKind = ckDynamicArray then
      Self.TypeID := typeARRAY;
  end;
end;

function TPAXRecordFieldDefinition.GetFieldAddress(Scripter, Address: pointer): Pointer;
begin
  Address := ShiftPointer(Address, Offset);
  DefValue := GetVariantValue(Scripter, Address, TypeID, FieldType);
  result := @DefValue;
end;

function TPaxRecordFieldDefinition.GetFieldValue(Scripter, Address: pointer): Variant;
begin
  GetFieldAddress(Scripter, Address);
  result := DefValue;
end;

procedure TPaxRecordFieldDefinition.SetFieldValue(Scripter, Address: pointer; const Value: Variant);
begin
  Address := ShiftPointer(Address, Offset);
  PutVariantValue(Scripter, Address, Value, TypeID);
end;

procedure TPaxRecordFieldDefinition.Dump(var T: TextFile);
begin
  writeln(T, 'RecordField =', Name,  ' Type =', FieldType, ' Offset =', Offset,
             ' Index =', Index);
end;

procedure TPaxRecordFieldDefinition.AddToScripter(Scripter: Pointer);
var
  ClassRec: TPAXClassRec;
  ClassList: TPAXClassList;
begin
  ClassList := TPAXBaseScripter(Scripter).ClassList;
  ClassRec := ClassList.FindClassByName(Owner.Name);

  if (SignLoadOnDemand and (ClassRec = nil)) then
    ClassRec := TPAXBaseScripter(Scripter).ClassList.FindClassByName(Owner.Name);
  
  if ClassRec <> nil then
    ClassRec.AddHostRecordField(Self)
  else
    raise TPAXScriptFailure.Create(Format(errClassIsNotImported, [Owner.Name]));
end;

constructor TPAXClassDefinition.Create(DefList: TPAXDefinitionList;
                                       const Name: String; Owner, Ancestor: TPAXDefinition);
begin
  inherited Create(DefList, Name, Owner, dkClass);
  Self.Ancestor := Ancestor;
  Self.GetPropDef := nil;
  Self.PutPropDef := nil;
  Self.ClassKind := ckClass;
  RecordSize := -1;
  Self.pti := nil;
  FillChar(guid, SizeOf(guid), 0);
  IsSet := false;
  PtiSet:= nil;
  IsStaticArray := false;

  OwnerList := nil;
end;

destructor TPAXClassDefinition.Destroy;
begin
  if OwnerList <> nil then
    OwnerList.Free;
end;

procedure TPAXClassDefinition.Dump(var T: TextFile);
var
  StrAncestor: String;
begin
  if Ancestor = nil then
    StrAncestor := 'nil'
  else
    StrAncestor := Ancestor.FullName;
  writeln(T, 'Class =', FullName,  ' Ancestor =', StrAncestor,
          ' Index =', Index);
end;

procedure TPAXClassDefinition.CreateOwnerList;
var
  P: TPAXDefinition;
begin
  OwnerList := TStringList.Create;

  P := Owner;
  while P <> nil do
  begin
    OwnerList.Insert(0, P.Name);
    P := P.Owner;
  end;
end;

function TPAXClassDefinition.FindClassRec(Scripter: Pointer): Pointer;
begin
  if OwnerList = nil then
     CreateOwnerList;

  result := TPAXBaseScripter(Scripter).ClassList.FindNestedClass(OwnerList, Name);
end;

procedure TPAXClassDefinition.AddToScripter(Scripter: Pointer);
var
  ClassRec, OwnerRec: TPAXClassRec;
  ClassList: TPAXClassList;
  ClassID: Integer;
  OwnerName, AncestorName: String;
begin
  ClassList := TPAXBaseScripter(Scripter).ClassList;
  ClassRec := FindClassRec(Scripter);

  if ClassRec <> nil then
    Exit;

  ClassID := - Index;

  if Ancestor <> nil then
    AncestorName := Ancestor.Name
  else
    AncestorName := '';

  if Owner <> nil then
  begin
    OwnerName := Owner.Name;
    OwnerRec := TPAXClassDefinition(Owner).FindClassRec(Scripter);
  end
  else
  begin
    OwnerName := RootNamespaceName;
    OwnerRec := ClassList.Records[0];
  end;

  ClassRec := ClassList.AddClass(ClassID, Name, OwnerName, AncestorName, ml, ClassKind, true);
  ClassRec.fClassDef := Self;
  ClassRec.ck := ClassKind;
  ClassRec.IsStaticArray := IsStaticArray;

  if (GetPropDef <> nil) or (PutPropDef <> nil) then
    ClassRec.fHasRunTimeProperties := true;

  ClassRec.isSet := IsSet;
  ClassRec.PtiSet := PtiSet;

  if OwnerRec <> nil then
    OwnerRec.AddNestedClass(ClassID, ml);

  if StrEql('TPaxArray', Name) then
    TPAXBaseScripter(Scripter).ArrayClassRec := ClassRec;
end;

constructor TPAXRTTITypeDefinition.Create(DefList: TPAXDefinitionList; pti: PTypeInfo);
begin
  inherited Create(DefList, pti^.Name, nil, dkRTTIType);
  Self.pti := pti;
  Self.FinalType := GetFinalType;
end;

procedure TPAXRTTITypeDefinition.Dump(var T: TextFile);
begin
  writeln(T, 'RTTIType =', pti^.Name, ' Index =', Index);
end;

function TPAXRTTITypeDefinition.GetFinalType: Integer;
begin
  result := 0;
  case pti^.Kind of
    tkInteger: result := typeINTEGER;
    tkChar: result := typeCHAR;
    tkEnumeration: result := typeENUM;
    tkFloat: result := typeDOUBLE;
    tkString: result := typeSHORTSTRING;
    tkLString: result := typeSTRING;
    tkWString: result := typeWIDESTRING;
    tkClass: result := typeCLASS;
    tkWChar: result := typeWIDECHAR;
    tkMethod: result := typeMETHOD;
    tkVariant: result := typeVARIANT;
    tkSet: result := typeSET;
    tkInt64: result := typeINT64;
    tkInterface: result := typeINTERFACE;
  end;
  if StrEql(pti^.Name, 'TDateTime') then
    result := typeDOUBLE;
end;

constructor TPAXMethodDefinition.Create(DefList: TPAXDefinitionList;
                                     const Name: String; Proc: TPAXMethodImpl;
                                     NP: Integer; Owner: TPAXDefinition;
                                     IsStatic: Boolean);
begin
  inherited Create(DefList, Name, Owner, dkMethod);
  Self.Proc := Proc;
  Self.NP := NP;
  Self.PClass := nil;
  Self.DirectProc := nil;
  Self.CallConv := _ccRegister;
  Self.Fake := false;
  Self.NewFake := false;
  Self.IsStatic := IsStatic;
  DefParamList := TPaxVarList.Create;
  ReturnsDynamicArray := false;
  Self.IsIntf := false;
  MethodIndex := 0;
  intf_pti := nil;
  FillChar(guid, SizeOf(guid), 0);
end;

destructor TPAXMethodDefinition.Destroy;
begin
  DefParamList.Free;
  inherited;
end;

function TPAXMethodDefinition.Duplicate: TPAXMethodDefinition;
var
  I: Integer;
begin
  result := TPAXMethodDefinition.Create(DefList, Name, Proc, NP, Owner, true);

  result.PClass := PClass;
  result.DirectProc := DirectProc;
  result.CallConv := CallConv;
  result.Header := Header;
  SetLength(result.Types, Length(Types));
  SetLength(result.ExtraTypes, Length(Types));
  SetLength(result.StrTypes, Length(Types));
  SetLength(result.ParamNames, Length(Types));
  SetLength(result.Sizes, Length(Types));
  SetLength(result.ByRefs, Length(Types));
  SetLength(result.Consts, Length(Types));
  result.TypeSub := TypeSub;
  result.Fake := Fake;
  result.NewFake := NewFake;
  result.IsStatic := IsStatic;

  for I:=0 to Length(Types) - 1 do
    result.Types[I] := Types[I];
  for I:=0 to Length(Types) - 1 do
    result.ExtraTypes[I] := ExtraTypes[I];
  for I:=0 to Length(Types) - 1 do
    result.StrTypes[I] := StrTypes[I];
  for I:=0 to Length(Types) - 1 do
    result.ParamNames[I] := ParamNames[I];
  for I:=0 to Length(Types) - 1 do
    result.Sizes[I] := Sizes[I];
  for I:=0 to Length(ByRefs) - 1 do
    result.ByRefs[I] := ByRefs[I];
  for I:=0 to Length(Consts) - 1 do
    result.Consts[I] := Consts[I];
end;


procedure TPAXMethodDefinition.AddToScripter(Scripter: Pointer);
var
  ClassRec: TPAXClassRec;
  ClassList: TPAXClassList;
begin
  ClassList := TPAXBaseScripter(Scripter).ClassList;

  if Owner = nil then
    ClassRec := ClassList[0]
  else
  begin
//    ClassRec := ClassList.FindClassByName(Owner.Name);
    ClassRec := TPAXClassDefinition(Owner).FindClassRec(Scripter);
  end;

  if (SignLoadOnDemand and (ClassRec = nil)) then
    ClassRec := TPAXBaseScripter(Scripter).ClassList.FindClassByName(Owner.Name);

  if ClassRec <> nil then
    ClassRec.AddHostMethod(Self)
  else
    raise TPAXScriptFailure.Create(Format(errClassIsNotImported, [Owner.Name]));
end;

function TPAXMethodDefinition.LoadFromDll(Scripter: Pointer; SubID: Integer): Boolean;

var
  BaseScripter: TPaxBaseScripter;

function GetFinalType(ID: Integer): Integer;
var
  TypeIndex: Integer;
  RTTIDef: TPAXRTTITypeDefinition;
  S: String;
begin
  with BaseScripter do
  begin
    result := SymbolTable.PType[ID];
    TypeIndex := SymbolTable.TypeNameIndex[ID];
    if TypeIndex > 0 then
    begin
      result := typeCLASS;
      S := _GetName(TypeIndex, Scripter);
      RTTIDef := DefinitionList.FindRTTITypeDefByName(S);
      if RTTIDef <> nil then
        result := RTTIDef.FinalType;
    end;
  end;
end;

var
  DllName, DllProcName: String;
  DllID, DllProcID: Integer;
  DllRec: TPaxDllRec;
  I, ParamID, ResultID: Integer;
begin
  BaseScripter := TPaxBaseScripter(Scripter);
  with BaseScripter.SymbolTable do
  begin
    DllID := GetDllID(SubID);
    DllName := Name[DllID];
    DllProcID := GetDllProcID(SubID);
    DllProcName := Name[DllProcID];

    DirectProc := nil;
    if Assigned(TPaxBaseScripter(Scripter).OnLoadDll) then
        TPaxBaseScripter(Scripter).OnLoadDll(TPaxBaseScripter(Scripter).Owner, DllName,
                                             DllProcName, DirectProc);
    if DirectProc = nil then
    begin
      DllRec := DllList.LoadDll(DllName, scripter);
      if DllRec = nil then
        raise TPaxScriptFailure.Create(Format(errCannotLoadDll, [DllName]));

{$IFDEF FP}
     DirectProc := dynlibs.GetProcedureAddress(DllRec.Handle, PChar(DllProcName));
 {$ELSE}
     DirectProc := GetProcAddress(DllRec.Handle, PChar(DllProcName));
 {$ENDIF}

    end;

    if DirectProc = nil then
      raise TPaxScriptFailure.Create(Format(errDllFunctionIsNotFound,
                                            [DllProcName, DllName]));

    NP := Count[SubID];
    SetLength(Types, NP + 1);
    SetLength(ExtraTypes, NP + 1);
    SetLength(StrTypes, NP + 1);
    SetLength(ParamNames, NP + 1);
    SetLength(Sizes, NP + 1);
    SetLength(ByRefs, NP + 1);
    SetLength(Consts, NP + 1);
    for I:=1 to NP do
    begin
      ParamID := GetParamID(SubID, I);
      Types[I - 1] := GetFinalType(ParamID);
      ExtraTypes[I - 1] := 0;
      StrTypes[I - 1] := '';
      ParamNames[I - 1] := '';
      ByRefs[I - 1] := ByRef[ParamID] <> 0;
      Consts[I - 1] := false;
      Sizes[I - 1] := -1;
    end;
    ResultID := GetResultID(SubID);
    Types[NP] := GetFinalType(ResultID);
    ExtraTypes[NP] := 0;
    StrTypes[NP] := '';
    ParamNames[NP] := '';
    ByRefs[NP] := true;
    Consts[NP] := false;
    Sizes[NP] := -1;

    Self.CallConv := CallConv[SubID];

    ml := [modSTATIC];
    result := true;
  end;
end;

function TPAXMethodDefinition.GetScriptType(ParamNumber: Integer): Integer;
begin
  case Types[ParamNumber] of
    typeINTEGER, typeBYTE, typeSMALLINT, typeSHORTINT: result := typeINTEGER;
    typeSTRING, typeCHAR, typePCHAR, typeWIDESTRING: result := typeSTRING;
    typeBOOLEAN, typeWORDBOOL, typeLONGBOOL: result := typeBOOLEAN;
    typeDOUBLE, typeEXTENDED, typeSINGLE, typeCURRENCY: result := typeDOUBLE;
  else
    result := typeVARIANT;
  end;
end;

procedure TPAXMethodDefinition.Dump(var T: TextFile);
begin
  writeln(T, 'Method =', FullName, ' Index =', Index);
end;

constructor TPAXPropertyDefinition.Create(DefList: TPAXDefinitionList;
                                       const Name: String; Owner: TPAXDefinition;
                                       PClass: TClass; ReadDef, WriteDef: TPAXDefinition);
begin
  inherited Create(DefList, Name, Owner, dkMethod);
  Self.PClass := PClass;
  Self.ReadDef := TPAXMethodDefinition(ReadDef);
  Self.WriteDef := TPAXMethodDefinition(WriteDef);
  Self.DefKind := dkProperty;
  Self.PropDef := '';
  Self.PropTYpe := '';
  NP := 0;
end;

procedure TPAXPropertyDefinition.Dump(var T: TextFile);
begin
  writeln(T, 'Property =', FullName, ' Index =', Index);
end;

procedure TPAXPropertyDefinition.AddToScripter(Scripter: Pointer);
var
  ClassRec: TPAXClassRec;
  ClassList: TPAXClassList;
begin
  ClassList := TPAXBaseScripter(Scripter).ClassList;

  if Owner = nil then
    ClassRec := ClassList[0]
  else
    ClassRec := TPAXClassDefinition(Owner).FindClassRec(Scripter);

  if (SignLoadOnDemand and (ClassRec = nil)) then
    ClassRec := TPAXBaseScripter(Scripter).ClassList.FindClassByName(Owner.Name);

  if ClassRec <> nil then
    ClassRec.AddHostProperty(Self)
  else
    raise TPAXScriptFailure.Create(Format(errClassIsNotImported, [Owner.Name]));
end;

constructor TPAXVariableDefinition.Create(DefList: TPAXDefinitionList;
                                       const Name, TypeName: String;
                                       Address: Pointer;
                                       Owner: TPAXDefinition);
begin
  inherited Create(DefList, Name, Owner, dkMethod);
  Self.DefKind := dkVariable;
  Self.Address := Address;
  Self.TypeID := PAXTypes.IndexOf(UpperCase(TypeName));
  Self.TypeName := TypeName;
end;

function TPAXVariableDefinition.GetAddress: Pointer;
begin
  DefValue := GetVariantValue(nil, Address, TypeID);
  result := @DefValue;
end;

procedure TPAXVariableDefinition.Dump(var T: TextFile);
begin
  writeln(T, 'Variable =', FullName, ' Index =', Index);
end;

procedure TPAXVariableDefinition.AddToScripter(Scripter: Pointer);
var
  ClassRec: TPAXClassRec;
  ClassList: TPAXClassList;
begin
  ClassList := TPAXBaseScripter(Scripter).ClassList;

  if Owner = nil then
    ClassRec := ClassList[0]
  else
//  ClassRec := ClassList.FindClassByName(Owner.Name);
    ClassRec := TPAXClassDefinition(Owner).FindClassRec(Scripter);

  if (SignLoadOnDemand and (ClassRec = nil)) then
    ClassRec := TPAXBaseScripter(Scripter).ClassList.FindClassByName(Owner.Name);

  if ClassRec <> nil then
    ClassRec.AddHostVariable(Self)
  else
    raise TPAXScriptFailure.Create(Format(errClassIsNotImported, [Owner.Name]));
end;

function TPAXVariableDefinition.GetValue(Scripter: Pointer): Variant;
begin
  result := GetVariantValue(Scripter, Address, TypeID);
end;

procedure TPAXVariableDefinition.SetValue(Scripter: Pointer; const AValue: Variant);
begin
  if DefList.Global then
  begin
    _BeginWrite;
    try
      PutVariantValue(Scripter, Address, AValue, TypeID);
    finally
      _EndWrite;
    end;
  end
  else
    PutVariantValue(Scripter, Address, AValue, TypeID);
end;

constructor TPAXObjectDefinition.Create(DefList: TPAXDefinitionList;
                                        const Name: String;
                                        Instance: TObject;
                                        Owner: TPAXDefinition);
begin
  inherited Create(DefList, Name, Owner, dkMethod);
  Self.DefKind := dkObject;
  Self.Instance := Instance;
end;

procedure TPAXObjectDefinition.Dump(var T: TextFile);
begin
  writeln(T, 'Object =', FullName, ' Index =', Index);
end;

procedure TPAXObjectDefinition.AddToScripter(Scripter: Pointer);
var
  ClassRec: TPAXClassRec;
  ClassList: TPAXClassList;
begin
  ClassList := TPAXBaseScripter(Scripter).ClassList;

  if Owner = nil then
    ClassRec := ClassList[0]
  else
    ClassRec := TPAXClassDefinition(Owner).FindClassRec(Scripter);

  if (SignLoadOnDemand and (ClassRec = nil)) then
    ClassRec := TPAXBaseScripter(Scripter).ClassList.FindClassByName(Owner.Name);

  if ClassRec <> nil then
    ClassRec.AddHostObject(Self)
  else
    raise TPAXScriptFailure.Create(Format(errClassIsNotImported, [Owner.Name]));
end;

constructor TPAXVirtualObjectDefinition.Create(DefList: TPAXDefinitionList;
                                               const Name: String;
                                               Owner: TPAXDefinition);
begin
  inherited Create(DefList, Name, Owner, dkMethod);
  Self.DefKind := dkVirtualObject;
end;

procedure TPAXVirtualObjectDefinition.Dump(var T: TextFile);
begin
  writeln(T, 'Virtual Object =', FullName, ' Index =', Index);
end;

procedure TPAXVirtualObjectDefinition.AddToScripter(Scripter: Pointer);
var
  ClassRec: TPAXClassRec;
  ClassList: TPAXClassList;
begin
  ClassList := TPAXBaseScripter(Scripter).ClassList;

  if Owner = nil then
    ClassRec := ClassList[0]
  else
    ClassRec := TPAXClassDefinition(Owner).FindClassRec(Scripter);

  if (SignLoadOnDemand and (ClassRec = nil)) then
    ClassRec := TPAXBaseScripter(Scripter).ClassList.FindClassByName(Owner.Name);

  if ClassRec <> nil then
    ClassRec.AddVirtualObject(Self)
  else
    raise TPAXScriptFailure.Create(Format(errClassIsNotImported, [Owner.Name]));
end;

constructor TPAXInterfaceVarDefinition.Create(DefList: TPAXDefinitionList;
                                           const Name: String;
                                           PIntf: PUnknown;
                                           const guid: TGuid;
                                           Owner: TPAXDefinition);
begin
  inherited Create(DefList, Name, Owner, dkVariable);
  Self.DefKind := dkInterface;
  Self.PIntf := PIntf;
  Self.guid := guid;
end;

procedure TPAXInterfaceVarDefinition.Dump(var T: TextFile);
begin
  writeln(T, 'InterfaceVar =', FullName, ' Index =', Index);
end;

procedure TPAXInterfaceVarDefinition.AddToScripter(Scripter: Pointer);
var
  ClassRec: TPAXClassRec;
  ClassList: TPAXClassList;
begin
  ClassList := TPAXBaseScripter(Scripter).ClassList;

  if Owner = nil then
    ClassRec := ClassList[0]
  else
    ClassRec := TPAXClassDefinition(Owner).FindClassRec(Scripter);

  if (SignLoadOnDemand and (ClassRec = nil)) then
    ClassRec := TPAXBaseScripter(Scripter).ClassList.FindClassByName(Owner.Name);

  if ClassRec <> nil then
    ClassRec.AddHostInterfaceVar(Self)
  else
    raise TPAXScriptFailure.Create(Format(errClassIsNotImported, [Owner.Name]));
end;

constructor TPAXConstantDefinition.Create(DefList: TPAXDefinitionList;
                                          const Name: String;
                                          const Value: Variant;
                                          Owner: TPAXDefinition);
begin
  inherited Create(DefList, Name, Owner, dkMethod);
  Self.DefKind := dkConstant;
  Self.DefValue := Value;
  case VarType(Value) of
    varInteger: Self.TypeID := typeINTEGER;
    varByte: Self.TypeID := typeBYTE;
    varDouble: Self.TypeID := typeDOUBLE;
    varSingle: Self.TypeID := typeDOUBLE;
    varCurrency: Self.TypeID := typeDOUBLE;
    varBoolean: Self.TypeID := typeBOOLEAN;
    varString: Self.TypeID := typeSTRING;
  else
    Self.TypeID := 0;
  end;
  if TypeID > 0 then
    resultType := PaxTypes[TypeID];
end;

procedure TPAXConstantDefinition.Dump(var T: TextFile);
var
  S: String;
begin
  if Owner <> nil then
    S := Owner.Name
  else
    S := '';

  if VarType(DefValue) in [varEmpty, varNull] then
    writeln(T, 'Constant =', FullName, ' Index =', Index, ' Value = Undefined')
  else
    writeln(T, 'Constant =', FullName, ' Index =', Index, ' Value =', DefValue, ' Owner =', S);
end;

function TPAXConstantDefinition.GetAddress: Pointer;
begin
  result := @ DefValue;
end;

procedure TPAXConstantDefinition.AddToScripter(Scripter: Pointer);
var
  ClassRec: TPAXClassRec;
  ClassList: TPAXClassList;
begin
  ClassList := TPAXBaseScripter(Scripter).ClassList;

  if Owner = nil then
    ClassRec := ClassList[0]
  else
    ClassRec := TPAXClassDefinition(Owner).FindClassRec(Scripter);
//    ClassRec := ClassList.FindClassByName(Owner.Name);

  if (SignLoadOnDemand and (ClassRec = nil)) then
    ClassRec := TPAXBaseScripter(Scripter).ClassList.FindClassByName(Owner.Name);

  if ClassRec <> nil then
    ClassRec.AddHostConstant(Self)
  else
    raise TPAXScriptFailure.Create(Format(errClassIsNotImported, [Owner.Name]));
end;

constructor TPAXDefinitionList.Create(Global: Boolean);

  //-- jgv
  function doCreateList: TStringList;
  begin
    Result := TStringList.Create;
    With Result do begin
      Sorted := True;
{$IFDEF VARIANTS}
      CaseSensitive := False;
{$ENDIF}
    end;
  end;

begin
  inherited Create;
  _LastIndex := -1;
  ClassIdx := TPaxIds.Create(false);
  ConstIdx := TPaxIds.Create(false);
  self.Global := Global;

  //-- jgv
  MethodIdx := DoCreateList;
  FieldIdx := DoCreateList;
  RTTITypeDefIdx := DoCreateList;
  ConstantIdx := DoCreateList;
  GUIDIdx := DoCreateList;
end;

destructor TPAXDefinitionList.Destroy;
begin
  MethodIdx.Free; // jgv
  FieldIdx.Free; // jgv
  RTTITypeDefIdx.Free; // jgv
  ConstantIdx.Free;
  GUIDIdx.Free;

  ClassIdx.Free;
  ConstIdx.Free;
  inherited;
end;

function TPAXDefinitionList.GetRecord(Index: Integer): TPAXDefinition;
begin
  result := TPAXDefinition(Items[Index]);
end;

function TPAXDefinitionList.FindMethod(const ClassName, MethodName: String): TPAXMethodDefinition;
var
  I: Integer;
  D: TPAXDefinition;
begin
  I := MethodIdx.IndexOf (ClassName + '.' + MethodName);
  If I >= 0 then
    Result := MethodIdx.Objects [i] as TPAXMethodDefinition
  else
    Result := Nil;

  Exit;

  for I:=Count - 1 downto 0 do
  begin
    D := Records[I];
    if D <> nil then
    begin
      if D.DefKind = dkMethod then
      if StrEql(D.Name, MethodName) then
      begin
        if D.Owner <> nil then
          if StrEql(D.Owner.Name, ClassName) then
          begin
            result := TPAXMethodDefinition(D);
            Exit;
          end;
      end;
    end;
  end;
  result := nil;
end;

function TPAXDefinitionList.FindField(const ClassName, FieldName: String): TPAXFieldDefinition;
var
  I: Integer;
begin
  i := FieldIdx.IndexOf (ClassName + '.' + FieldName);
  If i >= 0 then
    Result := FieldIdx.Objects [i] as TPAXFieldDefinition
  else
    Result := Nil;
  Exit;

  for I:=0 to Count - 1 do
  begin
    result := TPaxFieldDefinition(Records[I]);
    if Result <> nil then
    begin
      if result.DefKind = dkField then
        if StrEql(result.Name, FieldName) then
          Exit;
    end;
  end;
  result := nil;
end;

function TPAXDefinitionList.FindClassDef(PClass: TClass): TPAXClassDefinition;
var
  I: Integer;
  D: TPAXDefinition;
begin
  result := nil;

  for I:=ClassIdx.Count - 1 downto 0 do
  begin
    D := Records[ClassIdx[I]];
    if D.DefKind = dkClass then
      if TPAXClassDefinition(D).PClass = PClass then
      begin
        result := TPAXClassDefinition(D);
        Break;
      end;
  end;
end;

function TPAXDefinitionList.FindInterfaceTypeDef(const Guid: TGuid): TPAXClassDefinition;
var
  I: Integer;
  D: TPAXDefinition;
  DC: TPaxClassDefinition;
begin
{$IFDEF VARIANTS}
  i := GUIDIdx.IndexOf (GUIDToString (GUID));
  If i >= 0 then
    Result := GUIDIdx.Objects [i] as TPAXClassDefinition
  else
    Result := Nil;
  Exit;

{$ENDIF}

  result := nil;

  for I:=ClassIdx.Count - 1 downto 0 do
  begin
    D := Records[ClassIdx[I]];
    if D.DefKind = dkClass then
    begin
      DC := TPAXClassDefinition(D);
      if DC.ClassKind = ckInterface then
        if IsEqualGuid(DC.Guid, Guid) then
        begin
          result := DC;
          Break;
        end;
    end;
  end;
end;

function TPAXDefinitionList.FindObjectDef(Instance: TObject; Owner: TPaxDefinition): TPAXObjectDefinition;
var
  I: Integer;
  D: TPAXDefinition;
begin
  for I:=0 to Count - 1 do
  begin
    D := Records[I];
    if D.DefKind = dkObject then
    if D.Owner = Owner then
    begin
      if (D as TPAXObjectDefinition).Instance = Instance then
        begin
          result := D as TPAXObjectDefinition;
          Exit;
        end;
    end;
  end;
  result := nil;
end;

function TPAXDefinitionList.FindClassDefByPTI(pti: PTypeInfo): TPAXClassDefinition;
var
  I: Integer;
  D: TPAXDefinition;
begin
  result := nil;

  for I:=ClassIdx.Count - 1 downto 0 do
  begin
    D := Records[ClassIdx[I]];
    if D.DefKind = dkClass then
      if TPAXClassDefinition(D).pti = pti then
      begin
        result := TPAXClassDefinition(D);
        Break;
      end;
  end;
end;

function TPAXDefinitionList.FindClassDefByName(const Name: String): TPAXClassDefinition;
var
  I: Integer;
  D: TPAXDefinition;
begin
  result := nil;

  for I:=ClassIdx.Count - 1 downto 0 do
  begin
    D := Records[ClassIdx[I]];
    if D.DefKind = dkClass then
      if StrEql(D.Name, Name) then
      begin
        result := TPAXClassDefinition(D);
        Break;
      end;
  end;
end;

function TPAXDefinitionList.FindRTTITypeDef(pti: PTypeInfo): TPAXRTTITypeDefinition;
var
  I: Integer;
  D: TPAXDefinition;
begin
  i := RTTITypeDefIdx.IndexOf (pti^.Name);
  If i >= 0 then
    Result := RTTITypeDefIdx.Objects [i] as TPAXRTTITypeDefinition
  else
    Result := Nil;
  Exit;


  result := nil;

  for I:=ClassIdx.Count - 1 downto 0 do
  begin
    D := Records[ClassIdx[I]];
    if D.DefKind = dkRTTIType then
      if TPAXRTTITypeDefinition(D).pti = pti then
      begin
        result := TPAXRTTITypeDefinition(D);
        Break;
      end;
  end;
end;

function TPAXDefinitionList.FindRTTITypeDefByName(const Name: String): TPAXRTTITypeDefinition;
var
  I: Integer;
  D: TPAXDefinition;
begin
  i := RTTITypeDefIdx.IndexOf (Name);
  If i >= 0 then
    Result := RTTITypeDefIdx.Objects [i] as TPAXRTTITypeDefinition
  else
    Result := Nil;
  Exit;

  result := nil;

  for I:=ClassIdx.Count - 1 downto 0 do
  begin
    D := Records[ClassIdx[I]];
    if D.DefKind = dkRTTIType then
      if StrEql(TPAXRTTITypeDefinition(D).pti^.Name, Name) then
      begin
        result := TPAXRTTITypeDefinition(D);
        Break;
      end;
  end;
end;

function TPAXDefinitionList.AddNamespace(const Name: String;
                                         Owner: TPAXClassDefinition): TPAXClassDefinition;
begin
  result := TPAXClassDefinition(Lookup(Name, dkClass, Owner));
  if result <> nil then
    Exit;

  result := TPAXClassDefinition.Create(Self, Name, Owner, nil);
  TPAXClassDefinition(result).PClass := nil;
  Add(result);
  result.ml := result.ml + [modSTATIC];
  result.Index := NewIndex;

  ClassIdx.Add(Count - 1);
end;

function TPAXDefinitionList.AddClass1(const Name: String;
                                  Owner, Ancestor: TPAXClassDefinition;
                                  ReadProp, WriteProp: TPAXMethodImpl): TPAXClassDefinition;
begin
  result := FindClassDefByName(Name);

  if result = nil then
  begin
    result := TPAXClassDefinition.Create(Self, Name, Owner, Ancestor);
    Add(result);
    result.Index := NewIndex;

    ClassIdx.Add(Count - 1);
  end;

  TPAXClassDefinition(result).PClass := nil;

  if Assigned(ReadProp) then
    TPAXClassDefinition(result).GetPropDef :=
      TPAXMethodDefinition(AddMethod3('', ReadProp, -1, result, true));

  if Assigned(WriteProp) then
    TPAXClassDefinition(result).PutPropDef :=
      TPAXMethodDefinition(AddMethod3('', WriteProp, -1, result, true));
end;

function TPAXDefinitionList.AddClass2(PClass: TClass;
                                      Owner: TPAXClassDefinition;
                                      ReadProp, WriteProp: TPAXMethodImpl;
                                      ClassKind: TPAXClassKind = ckClass): TPAXClassDefinition;
var
  D: TPAXDefinition;
  ParentClass: TClass;
begin
  result := FindClassDef(PClass);
  if result <> nil then
  begin
    if Assigned(ReadProp) then
      TPAXClassDefinition(result).GetPropDef :=
        TPAXMethodDefinition(AddMethod3('', ReadProp, -1, result, true));

    if Assigned(WriteProp) then
      TPAXClassDefinition(result).PutPropDef :=
        TPAXMethodDefinition(AddMethod3('', WriteProp, -1, result, true));
    Exit;
  end;

  ParentClass := PClass.ClassParent;
  if ParentClass = nil then
    D := nil
  else
  begin
    D := FindClassDef(ParentClass);
    if D = nil then
      D := AddClass2(ParentClass, nil, nil, nil);
  end;

  result := AddClass1(PClass.ClassName, Owner, TPAXClassDefinition(D), ReadProp, WriteProp);
  result.PClass := PClass;
  result.ClassKind := ClassKind;
end;

function TPAXDefinitionList.AddMethod1(const Header: String; Address: Pointer;
                                       Owner: TPAXDefinition;
                                       Static: Boolean = false): TPAXMethodDefinition;
var
  P: TPascalParser;
  D: TPaxMethodDefinition;
begin
  result := TPAXMethodDefinition.Create(Self, '', nil, 0, Owner, Static);

  if Pos('__', Header) > 0 then
    result.NewFake := true;

  result.Header := Header;
  P := TPascalParser.Create;
  P.D := result;
  P.Parse_Heading;
  P.Free;

  if CheckDup then begin
    if Pos('OVERLOAD;', UpperCase(Header)) = 0 then begin
      //jgv
      If Owner <> Nil then
        D := FindMethod (Owner.Name, Result.Name)
      else
        D := TPAXMethodDefinition(Lookup(result.Name, dkMethod, Owner));
      if D <> nil then begin
        result.Free;
        result := D;
        result.DirectProc := Address;
        Exit;
      end;
    end;
  end;

  result.DirectProc := Address;
  if Static then
    result.ml := result.ml + [modSTATIC];
  Add(result);
  result.Index := NewIndex;
  result.Owner := Owner;

  If Owner <> Nil then
    MethodIdx.AddObject (Owner.Name + '.' + Result.Name, Result);
end;

function TPAXDefinitionList.AddMethod2(PClass: TClass; const Header: String; Address: Pointer;
              Static: Boolean = false): TPAXMethodDefinition;
begin
  result := AddMethod1(Header, Address, FindClassDef(PClass), false);
  result.PClass := PClass;
end;

function TPAXDefinitionList.AddMethod3(const Name: String;
                                   Proc: TPAXMethodImpl;
                                   NP: Integer;
                                   Owner: TPAXClassDefinition;
                                   Static: Boolean = false): TPAXMethodDefinition;
begin
  if CheckDup then
  begin
    //-- jgv
    If Owner <> Nil then
      Result := FindMethod (Owner.Name, Name)
    else
      result := TPAXMethodDefinition(Lookup(Name, dkMethod, Owner));
    if result <> nil then
    begin
      result.Proc := Proc;
      Exit;
    end;
  end;

  result := TPAXMethodDefinition.Create(Self, Name, Proc, NP, Owner, Static);
  if Static then
    result.ml := result.ml + [modSTATIC];
  Add(result);
  result.Index := NewIndex;

  If Owner <> Nil then
    MethodIdx.AddObject (Owner.Name + '.' + Name, Result);
end;

function TPAXDefinitionList.AddMethod4(PClass: TClass;
                                       const Name: String;
                                       Proc: TPAXMethodImpl;
                                       NP: Integer;
                                       Static: Boolean = false): TPAXMethodDefinition;
begin
  result := AddMethod3(Name, Proc, NP, FindClassDef(PClass), Static);
  result.PClass := PClass;
  if Static then
    result.ml := result.ml + [modSTATIC];
end;

function TPAXDefinitionList.AddMethod5(pti: PTypeInfo; const Header: String): TPAXMethodDefinition;
function CreateMethodIndex: Integer;
var
  D: TPaxMethodDefinition;
  I: Integer;
  curr_pti: PTypeInfo;
  TypeData: PTypeData;
begin
  result := 0;
  curr_pti := pti;
  TypeData := nil;

  repeat

    for I:= 0 to Count - 1 do
      if Records[I].DefKind = dkMethod then
      begin
        D := TPaxMethodDefinition(Records[I]);
        if D.IsIntf then
          if D.intf_pti = curr_pti then
            Inc(result);
      end;

    if (TypeData.IntfParent <> nil) then
    begin
  {$ifndef fp}
     curr_pti := TypeData.IntfParent^;
  {$else}
     curr_pti := TypeData.IntfParent;
  {$endif}
      if curr_pti = nil then
        break;
    end
    else
      Break;

  until false;
end;

var
  RttiDef: TPaxRTTITypeDefinition;
begin
  RttiDef := FindRTTITypeDef(pti);
  result := AddMethod1(Header, nil, RttiDef, false);
  result.PClass := nil;
  result.IsIntf := true;
  result.intf_pti := pti;
  result.MethodIndex := CreateMethodIndex;

{$ifndef fp}
  if pti <> nil then
    result.Guid := GetTypeData(pti).Guid;
 {$endif}
end;

function GUIDToString(const GUID: TGUID): string;
begin
  SetLength(Result, 38);
  StrLFmt(PChar(Result),
38,'{%.8x-%.4x-%.4x-%.2x%.2x-%.2x%.2x%.2x%.2x%.2x%.2x}',
    [GUID.D1, GUID.D2, GUID.D3, GUID.D4[0], GUID.D4[1], GUID.D4[2],
GUID.D4[3],
    GUID.D4[4], GUID.D4[5], GUID.D4[6], GUID.D4[7]]);
end;

function TPAXDefinitionList.AddMethod6(const Guid: TGuid; const Header: String;
                                       InitMethodIndex: Integer = -1): TPAXMethodDefinition;

var
  ClassDef: TPaxClassDefinition;

function CreateMethodIndex: Integer;
var
  D: TPaxMethodDefinition;
  I: Integer;
  curr_class_def: TPaxClassDefinition;
begin
  result := 0;
  curr_class_def := ClassDef;
  if curr_class_def = nil then
    raise TPAXScriptFailure.Create(Format(errInterfaceNotImported, [GuidToString(Guid)]));

  repeat

    for I:= curr_class_def.Index + 1 to Count - 1 do // from the beginning of interface class definition
      if Records[I].DefKind = dkMethod then
      begin
        D := TPaxMethodDefinition(Records[I]);
        if D.IsIntf then
          if IsEqualGuid(D.Guid, curr_class_def.guid) then
            Inc(result);
        if D.DefKind = dkClass then // we have found another class definition
          break;
      end;

    if curr_class_def.Ancestor <> nil then
      curr_class_def := TPaxClassDefinition(curr_class_def.Ancestor)
    else
      Break;

  until false;
end;

begin
  ClassDef := FindInterfaceTypeDef(Guid);
  result := AddMethod1(Header, nil, ClassDef, false);
  result.PClass := nil;
  result.IsIntf := true;
  result.intf_pti := nil;
  result.guid := Guid;

  if InitMethodIndex = -1 then
    result.MethodIndex := CreateMethodIndex
  else
    result.MethodIndex := InitMethodIndex;
end;

function TPAXDefinitionList.AddFakeMethod(PClass: TClass; const Header: String; Address: Pointer;
              Static: Boolean = false): TPAXMethodDefinition;
var
  C_Duplicate, Basic_Duplicate: TPAXMethodDefinition;
begin
  result := AddMethod1(Header, Address, FindClassDef(PClass), false);
  result.PClass := PClass;
  result.Fake := true;

  if result.TypeSub = tsConstructor then
  begin
    C_Duplicate := result.Duplicate;
    C_Duplicate.Name := result.PClass.ClassName;
    Add(C_Duplicate);
    C_Duplicate.Index := NewIndex;

    Basic_Duplicate := result.Duplicate;
    Basic_Duplicate.Name := 'New';
    Add(Basic_Duplicate);
    Basic_Duplicate.Index := NewIndex;
  end;
end;

function TPAXDefinitionList.AddProperty1(PClass: TClass;
                                        const Name: String;
                                        ProcRead: TPAXMethodImpl;
                                        NPRead: Integer;
                                        ProcWrite: TPAXMethodImpl;
                                        NPWrite: Integer;
                                        Default: Boolean = false): TPAXPropertyDefinition;
var
  Owner: TPAXClassDefinition;
  ReadDef, WriteDef: TPAXMethodDefinition;
begin
  Owner := FindClassDef(PClass);

  if CheckDup then
  begin
    result := TPAXPropertyDefinition(Lookup(Name, dkProperty, Owner));
    if result <> nil then
      Exit;
  end;

  if Assigned(ProcRead) then
    ReadDef := AddMethod3('', ProcRead, NPRead, Owner, false)
  else
    ReadDef := nil;

  if Assigned(ProcWrite) then
    WriteDef := AddMethod3('', ProcWrite, NPWrite, Owner, false)
  else
    WriteDef := nil;

  result := TPAXPropertyDefinition.Create(Self, Name, Owner, PClass, ReadDef, WriteDef);
  if Default then
    result.ml := result.ml + [modDEFAULT];
  Add(result);
  result.Index := NewIndex;
end;

function TPAXDefinitionList.AddProperty2(PClass: TClass; const Name: String;
                                     ReadDef, WriteDef: TPAXMethodDefinition;
                                     Default: Boolean = false): TPAXPropertyDefinition;
var
  Owner: TPAXClassDefinition;
begin
  Owner := FindClassDef(PClass);

  if CheckDup then
  begin
    result := TPAXPropertyDefinition(Lookup(Name, dkProperty, Owner));
    if result <> nil then
      Exit;
  end;

  result := TPAXPropertyDefinition.Create(Self, Name, Owner, PClass, ReadDef, WriteDef);
  if Default then
    result.ml := result.ml + [modDEFAULT];
  Add(result);
  result.Index := NewIndex;
end;

function TPAXDefinitionList.AddProperty3(PClass: TClass; const PropDef: String): TPAXPropertyDefinition;
var
  P: TPascalParser;
  ReadName, WriteName: String;
  Def: Boolean;
  Owner: TPAXClassDefinition;
begin
  Owner := FindClassDef(PClass);

  result := TPAXPropertyDefinition.Create(Self, '', Owner, PClass, nil, nil);
  result.PropDef := PropDef;

  P := TPascalParser.Create;
  P.Scanner.SourceCode := PropDef;
  P.Call_SCANNER;
  result.Name := P.Parse_Property(ReadName, WriteName, Def, Self);
  result.ReadDef := FindMethod(PClass.ClassName, ReadName);
  if result.ReadDef = nil then
    result.ReadDef := FindField(PClass.ClassName, ReadName);
  result.WriteDef := FindMethod(PClass.ClassName, WriteName);
  if result.WriteDef = nil then
    result.WriteDef := FindField(PClass.ClassName, WriteName);
  result.NP := P.NP;
  result.PropType := P.ResultType;
  P.Free;

  if result.ReadDef <> nil then
    if result.ReadDef.ResultType <> '' then
{
      if result.ReadDef.ResultType[1] in ['i','I'] then
      begin
        if not StrEql(result.ReadDef.ResultType, 'Integer') then
        begin
          result.Free;
          Exit;
        end;
      end
      else } if StrEql(result.ReadDef.ResultType, 'TWndMethod') then
      begin
        result.Free;
        Exit;
      end;

  if Def then
    result.ml := result.ml + [modDEFAULT];

  Add(result);
  result.Index := NewIndex;
end;

function TPAXDefinitionList.AddInterfaceProperty(const guid: TGUID; const PropDef: String): TPAXPropertyDefinition;
var
  P: TPascalParser;
  ReadName, WriteName: String;
  Def: Boolean;
  Owner: TPAXClassDefinition;
begin
  Owner := FindInterfaceTypeDef(guid);

  result := TPAXPropertyDefinition.Create(Self, '', Owner, nil, nil, nil);
  result.PropDef := PropDef;

  P := TPascalParser.Create;
  P.Scanner.SourceCode := PropDef;
  P.Call_SCANNER;
  result.Name := P.Parse_Property(ReadName, WriteName, Def, Self);
  result.ReadDef := FindMethod(Owner.Name, ReadName);
  if result.ReadDef = nil then
    result.ReadDef := FindField(Owner.Name, ReadName);
  result.WriteDef := FindMethod(Owner.Name, WriteName);
  if result.WriteDef = nil then
    result.WriteDef := FindField(Owner.Name, WriteName);
  result.NP := P.NP;
  result.PropType := P.ResultType;
  P.Free;

  if result.ReadDef <> nil then
    if result.ReadDef.ResultType <> '' then
{
      if result.ReadDef.ResultType[1] in ['i','I'] then
      begin
        if not StrEql(result.ReadDef.ResultType, 'Integer') then
        begin
          result.Free;
          Exit;
        end;
      end
      else } if StrEql(result.ReadDef.ResultType, 'TWndMethod') then
      begin
        result.Free;
        Exit;
      end;

  if Def then
    result.ml := result.ml + [modDEFAULT];

  Add(result);
  result.Index := NewIndex;
end;

function TPAXDefinitionList.AddVariable(const Name, TypeName: String;
                                        Address: Pointer;
                                        Owner: TPAXClassDefinition;
                                        Scripter: Pointer = nil): TPAXVariableDefinition;
var
  I: Integer;
  TypeDef: TPaxRTTITypeDefinition;
begin
  result := TPAXVariableDefinition(Lookup(Name, dkVariable, Owner, Scripter));

  if result = nil then
  begin
    result := TPAXVariableDefinition.Create(Self, Name, TypeName, Address, Owner);

    TypeDef := DefinitionList.FindRTTITypeDefByName(TypeName);
    if TypeDef <> nil then
      if TypeDef.pti^.Kind = tkSet then
        result.TypeID := typeSET;

    I := IndexOf(nil);
    if I = -1 then
      Add(result)
    else
      Items[I] := result;

    result.Index := NewIndex;
    result.ml := result.ml + [modSTATIC];
  end
  else
    result.Address := Address;

  if Scripter <> nil then
    if TPAXBaseScripter(Scripter).fState in
      [_ssPaused, _ssRunning, _ssTerminated] then
        result.AddToScripter(Scripter);
end;

function TPAXDefinitionList.AddObject(const Name: String;
                                     Instance: TObject;
                                     Owner: TPAXClassDefinition;
                                     Scripter: Pointer = nil): TPAXObjectDefinition;
var
  I: Integer;
begin
  result := TPAXObjectDefinition(Lookup(Name, dkObject, Owner, Scripter));

  if result = nil then
  begin
    result := TPAXObjectDefinition.Create(Self, Name, Instance, Owner);

    I := IndexOf(nil);
    if I = -1 then
      Add(result)
    else
      Items[I] := result;

    result.Index := NewIndex;
    result.ml := result.ml + [modSTATIC];
  end
  else
    result.Instance := Instance;

  if Scripter <> nil then
    if TPAXBaseScripter(Scripter).fState in [_ssPaused, _ssRunning, _ssTerminated] then
        result.AddToScripter(Scripter);
end;

function TPAXDefinitionList.AddVirtualObject(const Name: String;
                                             Owner: TPAXClassDefinition;
                                             Scripter: Pointer = nil): TPAXVirtualObjectDefinition;
var
  I: Integer;
begin
  result := TPAXVirtualObjectDefinition(Lookup(Name, dkObject, Owner, Scripter));

  if result = nil then
  begin
    result := TPAXVirtualObjectDefinition.Create(Self, Name, Owner);

    I := IndexOf(nil);
    if I = -1 then
      Add(result)
    else
      Items[I] := result;

    result.Index := NewIndex;
    result.ml := result.ml + [modSTATIC];
  end;

  if Scripter <> nil then
    if TPAXBaseScripter(Scripter).fState in [_ssPaused, _ssRunning, _ssTerminated] then
        result.AddToScripter(Scripter);
end;

function TPAXDefinitionList.AddInterfaceVar(const Name: String;
                                            PIntf: PUnknown;
                                            const guid: TGUID;
                                            Owner: TPAXClassDefinition;
                                            Scripter: Pointer = nil): TPAXInterfaceVarDefinition;
var
  I: Integer;
begin
  result := TPAXInterfaceVarDefinition(Lookup(Name, dkInterface, Owner, Scripter));

  if result = nil then
  begin
    result := TPAXInterfaceVarDefinition.Create(Self, Name, PIntf, guid, Owner);

    I := IndexOf(nil);
    if I = -1 then
      Add(result)
    else
      Items[I] := result;

    result.Index := NewIndex;
    result.ml := result.ml + [modSTATIC];
  end
  else
  begin
    if result.PIntf <> nil then
      result.PIntf^ := nil;
    result.PIntf := PIntf;
  end;

  if Scripter <> nil then
    if TPAXBaseScripter(Scripter).fState in [_ssPaused, _ssRunning, _ssTerminated] then
        result.AddToScripter(Scripter);
end;

function TPAXDefinitionList.AddField(PClass: TClass; const FieldName, FieldType: String;
                                     Offset: Integer): TPaxFieldDefinition;
var
  I: Integer;
begin
  result := TPAXFieldDefinition.Create(Self, PClass, FieldName, FieldType, Offset);
  I := IndexOf(nil);
  if I = -1 then
    Add(result)
  else
    Items[I] := result;

  result.Index := NewIndex;
  result.ml := result.ml;

  FieldIdx.AddObject (PClass.ClassName + '.' + FieldName, Result);
end;

function TPAXDefinitionList.AddRecordField(Owner: TPaxClassDefinition; const FieldName,
                                           FieldType: String;
                                           Offset: Integer): TPaxRecordFieldDefinition;
var
  I: Integer;
begin
  result := TPAXRecordFieldDefinition.Create(Self, Owner, FieldName, FieldType, Offset);
  I := IndexOf(nil);
  if I = -1 then
    Add(result)
  else
    Items[I] := result;
  result.Index := NewIndex;
  result.ml := result.ml;
end;

function TPAXDefinitionList.AddConstant(const Name: String;
                                     const Value: Variant;
                                     Owner: TPAXClassDefinition;
                                     Static: Boolean = true;
                                     ck: TPAXClassKind = ckNone;
                                     Scripter: Pointer = nil): TPAXConstantDefinition;
var
  I: Integer;
begin
  result := TPAXConstantDefinition(Lookup(Name, dkConstant, Owner, Scripter));

  if result = nil then
  begin
    result := TPAXConstantDefinition.Create(Self, Name, Value, Owner);

    I := IndexOf(nil);
    if I = -1 then
      Add(result)
    else
      Items[I] := result;

    result.Index := NewIndex;
    if Static then
      result.ml := result.ml + [modSTATIC];
    result.ck := ck;

    If Owner <> Nil then
      ConstantIdx.AddObject (Owner.Name + '.' + Name, Result)
    else
      ConstantIdx.AddObject (Name, Result)

  end
  else
    result.SetValue(Value);

  ConstIdx.Add(Count - 1);

  if Scripter <> nil then
    if TPAXBaseScripter(Scripter).fState in
      [_ssPaused, _ssRunning, _ssTerminated] then
        result.AddToScripter(Scripter);
end;

procedure DynaGet(M: TPAXMethodBody); forward;
procedure DynaPut(M: TPAXMethodBody); forward;

function TPAXDefinitionList.AddDynamicArrayType(const TypeName, ElementTypeName: String;
                                                Owner: TPaxDefinition)
                                            :TPAXClassDefinition;
var
  ElTypeDef: TPaxClassDefinition;
begin
  ElTypeDef := FindClassDefByName(ElementTypeName);

  result := AddClass1(TypeName, TPaxClassDefinition(Owner), nil, DynaGet, DynaPut);
  result.ClassKind := ckDynamicArray;
  result.ElType := PaxTypes.GetTypeID(ElementTypeName);
  if result.ElType = -1 then
    result.ElType := typeCLASS;
  result.ElSize := PaxTypes.GetSize(result.ElType);
  result.ElTypeName := ElementTypeName;

  if ElTypeDef <> nil then
  begin
    if ElTypeDef.ClassKind = ckStructure then
    begin
      result.ElType := typeRECORD;
      result.ElSize := ElTypeDef.RecordSize;
    end;
  end;
end;

function TPAXDefinitionList.AddRecordType(const TypeName: String; Size: Integer;
                                          Owner: TPaxDefinition):TPAXClassDefinition;
begin
  result := AddClass1(TypeName, TPaxClassDefinition(Owner), nil, nil, nil);
  result.ClassKind := ckStructure;
  result.RecordSize := Size;
end;

function TPAXDefinitionList.AddInterfaceType(const Name: String; Guid: TGuid;
                                             const ParentName: String; ParentGuid: TGUID;
                                             Owner: TPaxClassDefinition): TPAXClassDefinition;
var
  ParentDef: TPaxClassDefinition;
  DummyGuid: TGuid;
begin
//  result := FindInterfaceTypeDef(Guid);
//  result := FindClassDefByName(Name);
//  if result <> nil then
//    Exit;

  if ParentName = '' then
    ParentDef := nil
  else
  begin
    ParentDef := FindInterfaceTypeDef(ParentGuid);
    if ParentDef = nil then
      ParentDef := AddInterfaceType(ParentName, ParentGuid, '', DummyGuid, Owner);
  end;

  result := AddClass1(Name, Owner, ParentDef, nil, nil);
  result.ClassKind := CkInterface;
  result.Guid := Guid;

  GUIDIdx.AddObject (GUIDToString (Guid), Result);
end;

function TPAXDefinitionList.AddRTTIType(pti: PTypeInfo): TPAXRTTITypeDefinition;
var
  C: TPAXClassDefinition;
  TypeData: PTypeData;
  I: Integer;
  parent_pti: PTypeInfo;
  ParentDef: TPaxClassDefinition;
begin
  result := FindRTTITypeDef(pti);
  if result <> nil then
    Exit;

  result := TPAXRTTITypeDefinition.Create(Self, pti);
  Add(result);
  result.Index := NewIndex;

  ClassIdx.Add(Count - 1);

  if result.FinalType = typeENUM then
  begin
    TypeData := GetTypeData(pti);
    C := AddClass1(result.Name, nil, nil, nil, nil);
    C.ClassKind := ckEnum;

    for I:= TypeData.MinValue to TypeData.MaxValue do
      AddConstant(GetEnumName(pti, I), I, nil, true, ckEnum);
    for I:= TypeData.MinValue to TypeData.MaxValue do
      AddConstant(GetEnumName(pti, I), I, C, true, ckEnum);
  end
  else if result.FinalType = typeINTERFACE then
  begin
    TypeData := GetTypeData(pti);
    ParentDef := nil;
    if (TypeData.IntfParent <> nil) then
    begin

  {$ifndef fp}
     parent_pti := TypeData.IntfParent^;
  {$else}
     parent_pti := TypeData.IntfParent;
  {$endif}

      if parent_pti <> nil then
      begin
        ParentDef := FindClassDefByName(parent_pti^.Name);
        if (ParentDef = nil) and StrEql('IInterface', parent_pti^.Name) then
          ParentDef := FindClassDefByName('IUnknown');
      end;
    end;

    C := AddClass1(result.Name, nil, ParentDef, nil, nil);
    C.pti := pti;
    C.ClassKind := ckInterface;
{$ifndef fp}
    C.Guid := TypeData^.Guid;
{$endif}
  end
  else if result.FinalType = typeSET then
  begin
    TypeData := GetTypeData(pti);
    if Assigned(TypeData^.CompType) then
{$ifdef fp}
      AddRTTIType(TypeData^.CompType);
{$else}
      AddRTTIType(TypeData^.CompType^);
{$endif}
    C := AddClass1(result.Name, nil, nil, nil, nil);
    C.IsSet := true;
    C.PtiSet := pti;
  end
  else if result.FinalType = typeINTEGER then
    TypeAliases.AddObject(pti^.Name + '=INTEGER', TObject(typeINTEGER))
  else if result.FinalType = typeCARDINAL then
    TypeAliases.AddObject(pti^.Name + '=CARDINAL', TObject(typeCARDINAL))
  else if result.FinalType = typeWORD then
    TypeAliases.AddObject(pti^.Name + '=WORD', TObject(typeWORD))
  else if result.FinalType = typeWORDBOOL then
    TypeAliases.AddObject(pti^.Name + '=WORDBOOL', TObject(typeWORDBOOL))
  else if result.FinalType = typeLONGBOOL then
    TypeAliases.AddObject(pti^.Name + '=LONGBOOL', TObject(typeLONGBOOL));


  RTTITypeDefIdx.AddObject (pti^.Name, Result);
end;

function TPAXDefinitionList.AddEnumTypeByDef(const TypeDef: WideString): TPaxClassDefinition;
var
  I, P, PE, Value, Code1: Integer;
  S, TypeName, StrValue, ValName: String;
  L: TStringList;
begin
  S := TypeDef;
  P := Pos('=', S);
  TypeName := Trim(Copy(S, 1, P - 1));
  System.Delete(S, 1, P);

  result := AddClass1(TypeName, nil, nil, nil, nil);
  result.ClassKind := ckEnum;

  System.Delete(S, 1, Pos('(', S));

  L := TStringList.Create;

  P := Pos(',', S);
  if P = 0 then
    P := Pos(')', S);

  I := 0;
  while P > 0 do
  begin
    PE := Pos('=', S);

    if (PE > 0) and (PE < P) then
    begin
      ValName := Trim(Copy(S, 1, PE - 1));
      StrValue := Trim(Copy(S, PE + 1, P - PE - 1));
      Val(StrValue, Value, Code1);
      if Code1 <> 0 then
        Value := 0;
      System.Delete(S, 1, P);

      AddConstant(ValName, Value, nil, true, ckEnum);
      AddConstant(ValName, Value, result, true, ckEnum);
    end
    else
    begin
      ValName := Trim(Copy(S, 1, P - 1));
      System.Delete(S, 1, P);
      AddConstant(ValName, I, nil, true, ckEnum);
      AddConstant(ValName, I, result, true, ckEnum);
      Inc(I);
    end;

    P := Pos(',', S);

    if P = 0 then
      P := Pos(')', S);
  end;

  L.Free;
end;

function TPAXDefinitionList.NewIndex: Integer;
begin
  Inc(_LastIndex);
  result := _LastIndex;

  if _LastIndex <> Count - 1 then
    _LastIndex := result;
end;

procedure TPAXDefinitionList.Clear;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    if Items[I] <> nil then
       TPaxDefinition(Items[I]).Free;

  inherited;
end;

function TPAXDefinitionList.LookupFullName(const FullName: String): TPAXDefinition;
var
  I: Integer;
begin
  result := nil;

  for I:=0 to Count - 1 do
    if Records[I] <> nil then
    if StrEql(Records[I].FullName, FullName) then
    begin
      result := Records[I];
      Exit;
    end;
end;

function TPAXDefinitionList.Lookup(const Name: String;
                                   DefKind: TPAXDefKind;
                                   Owner: TPAXDefinition;
                                   Scripter: Pointer = nil): TPAXDefinition;
var
  I: Integer;
  D: TPAXDefinition;
begin
  result := nil;

    if DefKind = dkConstant then
    begin
      If Owner <> Nil then
        i := ConstantIdx.IndexOf (Owner.Name + '.' + Name)
      else
        i := ConstantIdx.IndexOf (Name);

      If i >= 0 then
        Result := ConstantIdx.Objects [i] as TPAXDefinition
      else
        Result := Nil;
      Exit;

      for I:=0 to ConstIdx.Count - 1 do
      begin
        D := Records[ConstIdx[I]];
        if D.Owner = Owner then
            if StrEql(D.Name, Name) then
            begin
              result := D;
              Exit;
            end;
      end;
      Exit;
    end;

    if DefKind = dkClass then
    begin
      for I:=0 to ClassIdx.Count - 1 do
      begin
        D := Records[ClassIdx[I]];
        if D.Owner = Owner then
            if StrEql(D.Name, Name) then
            begin
              result := D;
              Exit;
            end;
      end;
      Exit;
    end;

    for I:=0 to Count - 1 do
    if Records[I] <> nil then
    begin
      D := Records[I];
      if (D.DefKind = DefKind) or (DefKind = dkAny) then
        if D.Owner = Owner then
          if StrEql(D.Name, Name) then
          begin
            result := D;
            Exit;
          end;
    end;
end;

function TPAXDefinitionList.LookupAll(const Name: String;
                                      DefKind: TPAXDefKind;
                                      Owner: TPAXDefinition;
                                      Scripter: Pointer = nil): TList;
var
  I: Integer;
  D: TPAXDefinition;
begin
  result := TList.Create;

    if DefKind = dkConstant then
    begin
      for I:=0 to ConstIdx.Count - 1 do
      begin
        D := Records[ConstIdx[I]];
        if D.Owner = Owner then
            if StrEql(D.Name, Name) then
            begin
              result.Add(D);
              Exit;
            end;
      end;
      Exit;
    end;

    if DefKind = dkClass then
    begin
      for I:=0 to ClassIdx.Count - 1 do
      begin
        D := Records[ClassIdx[I]];
        if D.Owner = Owner then
            if StrEql(D.Name, Name) then
            begin
              result.Add(D);
              Exit;
            end;
      end;
      Exit;
    end;

    for I:=0 to Count - 1 do
    if Records[I] <> nil then
    begin
      D := Records[I];
      if (D.DefKind = DefKind) or (DefKind = dkAny) then
        if D.Owner = Owner then
          if StrEql(D.Name, Name) then
          begin
            result.Add(D);
          end;
    end;
end;

procedure TPAXDefinitionList.UnregisterObject(Instance: TObject; Owner: TPaxDefinition);
var
  I: Integer;
  D: TPaxDefinition;
begin
  for I:=0 to Count - 1 do
  if Records[I] <> nil then
  begin
    D := Records[I];
    if D.DefKind = dkObject then
      if D.Owner = Owner then
        if (D as TPaxObjectDefinition).Instance = Instance then
        begin
          D.Free;
          Items[I] := nil;
          Exit;
        end;
  end;
end;

procedure TPAXDefinitionList.Unregister(const Name: String;
                                        DefKind: TPAXDefKind;
                                        Owner: TPAXDefinition;
                                        Scripter: Pointer = nil);
var
  I, J: Integer;
  D: TPAXDefinition;
begin

  try
    if DefKind = dkConstant then
    begin
      for I:=0 to ConstIdx.Count - 1 do
      begin
        J := ConstIdx[I];
        D := Records[J];
        if D.Owner = Owner then
            if D.Name = Name then
            begin
              D.Free;
              Items[J] := nil;

              If Owner <> Nil then
                J := ConstantIdx.IndexOf (Owner.Name + '.' + Name)
              else
                J := ConstantIdx.IndexOf (Name);
              if J >= 0 then
                ConstantIdx.Delete(J);

              Exit;
            end;
      end;
      Exit;
    end;

    if DefKind = dkClass then
    begin
      for I:=0 to ClassIdx.Count - 1 do
      begin
        J := ClassIdx[I];
        D := Records[J];
        if D.Owner = Owner then
            if D.Name = Name then
            begin
              D.Free;
              Items[J] := nil;
              Exit;
            end;
      end;
      Exit;
    end;

    for I:=0 to Count - 1 do
    if Records[I] <> nil then
    begin
      D := Records[I];
      if D.DefKind = DefKind then
        if D.Owner = Owner then
          if D.Name = Name then
          begin
            D.Free;
            Items[I] := nil;
            Exit;
          end;
    end;

  finally

    ConstIdx.Clear;
    ClassIdx.Clear;

    for I:=0 to Count - 1 do
      if Records[I] <> nil then
      case Records[I].DefKind of
        dkClass, dkRTTIType: ClassIdx.Add(I);
        dkConstant: ConstIdx.Add(I);
      end;
    end;
end;

procedure TPAXDefinitionList.UnregisterAll(DefKind: TPAXDefKind;
                                           Scripter: Pointer);

procedure RemoveFromClassList(O: TPAXDefinition; const Name: String);
var
  ClassRec: TPaxClassRec;
begin
  if O = nil then
     ClassRec := TPaxBaseScripter(Scripter).ClassList[0]
   else
     ClassRec := TPaxBaseScripter(Scripter).ClassList.FindImportedClass(TPaxClassDefinition(O).PClass);
   ClassRec.MemberList.DeleteMember(Name, true);
end;

var
  I, J: Integer;
  D: TPAXDefinition;
begin
  if Scripter = nil then
    Exit;

  if DefKind = dkConstant then
  begin
    for I:=0 to ConstIdx.Count - 1 do
    begin
      J := ConstIdx[I];
      D := Records[J];
      RemoveFromClassList(D.Owner, D.Name);
      D.Free;
      Items[J] := nil;
    end;
    Exit;
  end;

  if DefKind = dkClass then
  begin
    for I:=0 to ClassIdx.Count - 1 do
    begin
      J := ClassIdx[I];
      D := Records[J];
      RemoveFromClassList(D.Owner, D.Name);
      D.Free;
      Items[J] := nil;
    end;
    Exit;
  end;

  for I:=0 to Count - 1 do
  if Records[I] <> nil then
  begin
    D := Records[I];
    if D.DefKind = DefKind then
      if D.Name <> 'ErrorObject' then
      begin
        RemoveFromClassList(D.Owner, D.Name);
        D.Free;
        Items[I] := nil;
      end;
  end;

  ConstIdx.Clear;
  ClassIdx.Clear;

  for I:=0 to Count - 1 do
    if Records[I] <> nil then
    case Records[I].DefKind of
      dkClass, dkRTTIType: ClassIdx.Add(I);
      dkConstant: ConstIdx.Add(I);
    end;
end;

procedure TPAXDefinitionList.Dump(const FileName: String);
var
  I: Integer;
  T: TextFile;
begin
//Exit;
  AssignFile(T, FileName);
  Rewrite(T);
  for I:=0 to Count - 1 do
  if Records[I] <> nil then
  begin
    writeln(T, I);
    Records[I].Dump(T);
  end;
  CloseFile(T);
end;

function TPAXDefinitionList.GetRecordByIndex(Index: Integer): TPAXDefinition;
var
  I: Integer;
begin
  if (Index >= 0) and (Index < Count) then
    if Records[Index] <> nil then
    if Records[Index].Index = Index then
    begin
      result := Records[Index];
      Exit;
    end;
  for I:=0 to Count - 1 do
    if Records[I] <> nil then
    if Records[I].Index = Index then
    begin
      result := Records[I];
      Exit;
    end;

  CurrScripter.Dump();
  raise Exception.Create(errGetRecordByIndex);
end;

function TPAXDefinitionList.GetKind(Index: Integer): Integer;
begin
  result := KindVAR;
  case GetRecordByIndex(Index).DefKind of
    dkMethod: result := KindSUB;
    dkClass, dkRTTIType: result := KindTYPE;
    dkProperty: result := KindPROP;
    dkVariable, dkObject: result := KindVAR;
    dkConstant: result := KindCONST;
  end;
end;

function TPAXDefinitionList.GetCount(Index: Integer): Integer;
var
  D: TPaxDefinition;
begin
  D := GetRecordByIndex(Index);

  case D.DefKind of
    dkMethod:
    begin
      result := TPAXMethodDefinition(D).NP;
    end;
  else
    result := -1;
  end;
end;

function TPAXDefinitionList.GetParamTypeName(Index, ParamIndex: Integer): String;
var
  D: TPaxDefinition;
  MD: TPaxMethodDefinition;
begin
  D := GetRecordByIndex(Index);

  case D.DefKind of
    dkMethod:
    begin
      MD := TPAXMethodDefinition(D);
      Dec(ParamIndex);
      if (ParamIndex < Length(MD.StrTypes)) and (ParamIndex >= 0) then
        result := MD.StrTypes[ParamIndex]
      else
        result := 'Variant';
    end;
  else
    result := '';
  end;
end;

function TPAXDefinitionList.GetParamName(Index, ParamIndex: Integer): String;
var
  D: TPaxDefinition;
  MD: TPaxMethodDefinition;
begin
  D := GetRecordByIndex(Index);

  case D.DefKind of
    dkMethod:
    begin
      MD := TPAXMethodDefinition(D);
      Dec(ParamIndex);
      if (ParamIndex < Length(MD.ParamNames)) and (ParamIndex >= 0) then
        result := MD.ParamNames[ParamIndex]
      else
        result := 'X' + IntToStr(ParamIndex);
    end;
  else
    result := '';
  end;
end;

function TPAXDefinitionList.GetTypeName(Index: Integer): String;
var
  D: TPaxDefinition;
  MD: TPaxMethodDefinition;
  PD: TPaxPropertyDefinition;
  CD: TPaxConstantDefinition;
  FD: TPaxFieldDefinition;
  RD: TPAXRecordFieldDefinition; // krus (1C)
  OD: TPaxObjectDefinition;
  VD: TPAXVariableDefinition;    // krus (1C)
begin
  D := GetRecordByIndex(Index);

  case D.DefKind of
    dkMethod:
    begin
      MD := TPAXMethodDefinition(D);
      result := MD.ResultType;
    end;
    dkProperty:
    begin
      PD := TPAXPropertyDefinition(D);
      result := PD.PropType;
    end;
    dkConstant:
    begin
      CD := TPAXConstantDefinition(D);
      result := CD.ResultType;
    end;
    dkField:
    begin
      FD := TPAXFieldDefinition(D);
      result := FD.FieldType;
    end;
    dkRecordField:                           // krus (1C)
    begin                                    // krus (1C)
      RD := TPAXRecordFieldDefinition(D);    // krus (1C)
      result := RD.FieldType;                // krus (1C)
    end;                                     // krus (1C)
    dkVariable:                              // krus (1C)
    begin                                    // krus (1C)
      VD := TPAXVariableDefinition(D);       // krus (1C)
      result := VD.TypeName;                 // krus (1C)
    end;                                     // krus (1C)
    dkObject:
    begin
      OD := TPAXObjectDefinition(D);
      result := OD.Instance.ClassName;
    end;
  else
    result := '';
  end;
end;

function TPAXDefinitionList.GetNameIndex(Index: Integer; Scripter: Pointer): Integer;
begin
  result := CreateNameIndex(GetRecordByIndex(Index).Name, Scripter);
end;

function TPAXDefinitionList.GetName(Index: Integer): String;
begin
  result := GetRecordByIndex(Index).Name;
end;

function TPAXDefinitionList.GetFullName(Index: Integer): String;
begin
  result := GetRecordByIndex(Index).FullName;
end;

function TPAXDefinitionList.GetAddress(Scripter: Pointer; Index: Integer): Pointer;
var
  D: TPaxDefinition;
begin
  D := GetRecordByIndex(Index);

  if D.DefKind in [dkClass, dkRTTIType] then
    result := TPAXBaseScripter(Scripter).NegVarList.GetAddress(Index)
  else
    result := @ (D.DefValue);
end;

function TPAXDefinitionList.GetUserData(Scripter: Pointer; Index: Integer): Integer;
var
  D: TPaxDefinition;
begin
  D := GetRecordByIndex(Index);
  result := D.UserData;
end;

function TPAXDefinitionList.GetVariant(Scripter: Pointer; Index: Integer): Variant;
var
  D: TPaxDefinition;
  SO: TPaxScriptObject;
begin
  D := GetRecordByIndex(Index);

  if D.DefKind in [dkClass, dkRTTIType] then
    result := TPAXBaseScripter(Scripter).NegVarList.GetAddress(Index)^
  else if D.DefKind = dkVariable then
    result := D.Value
  else if D.DefKind = dkMethod then
  begin
    SO := TPAXScriptObject.Create(TPAXBaseScripter(Scripter).ClassList.DelegateClassRec);
    SO.Instance := TPAXDelegate.Create(Scripter, - Index, TPAXBaseScripter(Scripter).Code.N, TPaxMethodDefinition(D));
    SO.PClass := TPAXDelegate;
    SO.PutProperty(CreateNameIndex('Name', Scripter), D.Name, 0);
    result := ScriptObjectToVariant(SO);
  end
  else
    result := D.Value;
end;

function TPAXDefinitionList.GetPVariant(Scripter: Pointer; Index: Integer): PVariant;
var
  D: TPaxDefinition;
begin
  D := GetRecordByIndex(Index);

  if D.DefKind in [dkClass, dkRTTIType] then
    result := TPAXBaseScripter(Scripter).NegVarList.GetAddress(Index)
  else if D.DefKind = dkVariable then
    result := D.PValue
  else
    result := D.PValue;
end;

procedure TPAXDefinitionList.PutVariant(Scripter: Pointer; Index: Integer; const Value: Variant);
var
  D: TPaxDefinition;
begin
  D := GetRecordByIndex(Index);

  if D.DefKind in [dkClass, dkRTTIType] then
    TPAXBaseScripter(Scripter).NegVarList.GetAddress(Index)^ := Value
  else if D.DefKind = dkVariable then
    D.Value := Value
  else
    D.DefValue := Value;
end;

function TPAXDefinitionList.UnregisterNamespace(const Namespacename: String): Boolean;
var
  D, D1: TPaxDefinition;
  DC: TPaxClassDefinition;
  I: Integer;
  L: TList;
begin
  result := false;
  D := LookupFullName(Namespacename);
  if D = nil then
    Exit;

  L := TList.Create;

  for I:=Count - 1 downto 0 do
  begin
    D1 := Records[i];
    if (D1.Owner = D) or (D1 = D) then
      L.Add(D1);
    if (D1.Owner <> nil) then
      if D1.Owner.Owner = D then
        L.Add(D1);
  end;

  for I:=0 to Count - 1 do
  begin
    D1 := Records[i];
    if L.IndexOf(D1.Owner) >= 0 then
       D1.Owner := nil;
    if D1.DefKind = dkClass then
    begin
      DC := D1 as TPaxClassDefinition;
      if DC.Ancestor <> nil then
        if L.IndexOf(DC.Ancestor) >= 0 then
          DC.Ancestor := nil;
    end;
  end;

  for I:=Count - 1 downto 0 do
  begin
    D1 := Records[i];
    if L.IndexOf(D1) >= 0 then
    begin
      Delete(I);
      D1.Free;
    end;
  end;

  L.Free;

  for I:=0 to Count - 1do
    Records[i].Index := I;

 _LastIndex := Count - 1;

  ConstIdx.Clear;
  ClassIdx.Clear;

  for I:=0 to Count - 1 do
    if Records[I] <> nil then
    case Records[I].DefKind of
      dkClass, dkRTTIType: ClassIdx.Add(I);
      dkConstant: ConstIdx.Add(I);
    end;

  result := true;
end;

constructor TPAXFieldList.Create;
begin
  fList := TList.Create;
end;

procedure TPAXFieldList.Clear;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    Records[I].Free;
  fList.Clear;
end;

destructor TPAXFieldList.Destroy;
begin
  Clear;
  fList.Free;
end;

function TPAXFieldList.Count: Integer;
begin
  result := fList.Count;
end;

function TPAXFieldList.GetRecord(Index: Integer): TPAXFieldRec;
begin
  result := TPAXFieldRec(fList[Index]);
end;

procedure TPAXFieldList.AddRec(const ObjectName: String;
                               ObjectType: String;
                               FieldName: String;
                               FieldType: String;
                               Address: Pointer);
var
  R: TPAXFieldRec;
begin
  R := TPAXFieldRec.Create;
  R.ObjectName := ObjectName;
  R.ObjectType := ObjectType;
  R.FieldName := FieldName;
  R.FieldType := FieldType;
  R.Address := Address;
  fList.Add(R);
end;

function TPAXFieldList.FindRecord(const ObjectName: String;
                                  ObjectType: String;
                                  FieldName: String): TPAXFieldRec;
var
  I: Integer;
  R: TPAXFieldRec;
begin
  result := nil;
  for I:=0 to Count - 1 do
  begin
    R := Records[I];
    if StrEql(R.ObjectName, ObjectName) and
       StrEql(R.ObjectType, ObjectType) and
       StrEql(R.FieldName, FieldName) then
       begin
         result := R;
         Exit;
       end;
  end;
end;

procedure _HasProperty(MethodBody: TPAXMethodBody);
var
  S: String;
  ID: Integer;
  SO: TPAXScriptObject;
begin
  with MethodBody do
  begin
    S := Params[0].AsString;
    with TPAXBaseScripter(Scripter) do
    begin
      ID := ClassList[0].ClassID;
      SO := VariantToScriptObject(SymbolTable.GetVariant(ID));
      result.AsVariant := SO.HasProperty(S);
    end;
  end;
end;

procedure _PropExists(MethodBody: TPAXMethodBody);
var
  SO: TPAXScriptObject;
  S: String;
begin
  with MethodBody do
  begin
    SO := VariantToScriptObject(Params[0].AsVariant);
    S := Params[1].AsString;
    result.AsVariant := SO.HasProperty(S);
  end;
end;

procedure _ToInteger(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := toInteger(Params[0].AsVariant);
end;

procedure _ToNumber(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := toNumber(Params[0].AsVariant);
end;

procedure _ToBoolean(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := toBoolean(Params[0].AsVariant);
end;

procedure _ToString(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := toString(Params[0].AsVariant);
end;

procedure _IsUndefined(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := IsUndefined(Params[0].PValue^);
end;

procedure _IsString(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := IsString(Params[0].PValue^) or
                        IsStringObject(Params[0].PValue^);
end;

procedure _IsBoolean(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := IsBoolean(Params[0].PValue^) or
                        IsBooleanObject(Params[0].PValue^);
end;

procedure _IsNumber(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := IsNumber(Params[0].PValue^) or
                        IsNumberObject(Params[0].PValue^);
end;

procedure _IsObject(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := IsObject(Params[0].PValue^);
end;

procedure _IsPaxArray(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := IsPaxArray(Params[0].PValue^);
end;

procedure _IsVBArray(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := IsVBArray(Params[0].PValue^);
end;

procedure _IsFunction(MethodBody: TPAXMethodBody);
var
  SO: TPaxScriptObject;
begin
  with MethodBody do
    if IsObject(Params[0].PValue^) then
    begin
      SO := VariantToScriptObject(Params[0].PValue^);
      result.AsVariant := (SO.ClassRec.AncestorName = 'Function') or
                          (SO.ClassRec.Name = 'TPAXDelegate');
    end
    else
      result.AsVariant := false;
end;

procedure TPAXArray_GetOwner(MethodBody: TPAXMethodBody);
var
  PaxArray: TPaxArray;
begin
  with MethodBody do
  begin
    PaxArray := TPaxArray(Self);
    result.AsVariant := PaxArray.Owner;
  end;
end;

procedure TPAXArray_PutOwner(MethodBody: TPAXMethodBody);
var
  PaxArray: TPaxArray;
begin
  with MethodBody do
  begin
    PaxArray := TPaxArray(Self);
    PaxArray.Owner := Params[0].PValue^;
  end;
end;

procedure _Prev(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
  begin
    result.AsVariant := Params[0].AsVariant - 1;
  end;
end;

procedure _Succ(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
  begin
    result.AsVariant := Params[0].AsVariant + 1;
  end;
end;

procedure _Low(MethodBody: TPAXMethodBody);
var
  V: Variant;
  SO: TPaxScriptObject;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    if IsPaxArray(V) then
      result.AsVariant := 0
    else if IsDynamicArray(V) then
      result.AsVariant := 0
    else if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);

      if SO.HasProperty('L1') then
        result.AsVariant := SO.GetProperty(CreateNameIndex('L1', Scripter), 0);
    end;
  end;
end;

procedure _High(MethodBody: TPAXMethodBody);
var
  V: Variant;
  SO: TPaxScriptObject;
  P: Pointer;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    if IsPaxArray(V) then
    begin
      SO := VariantToScriptObject(V);
      result.AsVariant := TPaxArray(SO.Instance).fBounds[0];
    end
    else if IsDynamicArray(V) then
    begin
      SO := VariantToScriptObject(V);
      if SO.ExtraPtr = nil then
        raise Exception.Create(errDynamicArrayNotInitialized);
      P := ShiftPointer(SO.ExtraPtr, - 4);
      result.AsVariant := Integer(P^);
    end
    else if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);

      if SO.HasProperty('H1') then
        result.AsVariant := SO.GetProperty(CreateNameIndex('H1', Scripter), 0);
    end;
  end;
end;

procedure _Length(MethodBody: TPAXMethodBody);
var
  V: Variant;
  SO: TPaxScriptObject;
  D: TPaxClassDefinition;
  P: Pointer;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);
      D := SO.ClassRec.GetClassDef;
      if D = nil then
        raise Exception.Create(errIncompatibleTypes);
      if D.ClassKind <> ckDynamicArray then
        raise Exception.Create(errIncompatibleTypes);
      P := SO.ExtraPtr;
      if P = nil then
        result.AsInteger := 0
      else
      begin
        P := ShiftPointer(P, - SizeOf(Integer));
        result.AsInteger := Integer(P^);
      end;
    end
    else if IsUndefined(V) then
    begin
      result.AsInteger := 0;
    end
    else
      result.AsInteger := Length(Params[0].AsString);
  end;
end;

procedure _SetLength(MethodBody: TPAXMethodBody);
var
  I, L, OldL: Integer;
  V: Variant;
  S: String;
  SO: TPaxScriptObject;
  D: TPaxClassDefinition;
  P: Pointer;
  temp: boolean;
  ClassRec: TPaxClassRec;
  buff: Pointer;
  lbuff: Integer;
begin
  buff := nil;
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    L := Params[1].AsInteger;
    OldL := 0;
    lbuff := 0;
    if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);
      SO.Instance := SO;

      D := SO.ClassRec.GetClassDef;
      if D = nil then
        raise Exception.Create(errIncompatibleTypes);
      if D.ClassKind <> ckDynamicArray then
        raise Exception.Create(errIncompatibleTypes);

      if SO.ExtraPtr <> nil then
      begin
        OldL := Integer(ShiftPointer(SO.ExtraPtr, - SizeOf(Pointer))^);
        if (OldL > 0) and (OldL < L) then
        begin
          lbuff := SO.ExtraPtrSize - 8;
          GetMem(buff, lbuff);
          Move(SO.ExtraPtr^, buff^, lbuff);
        end;
      end;

      temp := SO.ExternalExtraPtr;
      SO.ExternalExtraPtr := false;
      SO.FreeExtraPtr();
      SO.ExternalExtraPtr := temp;

      ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(D.ElTypeName);
      if ClassRec <> nil then
      if ClassRec.fClassDef = nil then
      begin
        D.ElSize := _SizeVariant;
        D.ElType := typeVariant;
      end;

      P := AllocMem(2*SizeOf(Integer) +  L * D.ElSize);
      Integer(P^) := 1;
      P := ShiftPointer(P, SizeOf(Integer));
      Integer(P^) := L;
      P := ShiftPointer(P, SizeOf(Integer));
      SO.ExtraPtr := P;

      if lbuff > 0 then
        Move(buff^, P^, lbuff);

      SO.ExtraPtrSize := 2*SizeOf(Integer) +  L * D.ElSize;

      if ClassRec <> nil then
      if ClassRec.fClassDef = nil then
      begin
        for I:= 0 to L - 1 do
        begin
          if I > OldL - 1 then
          begin
            SO := ClassRec.CreateScriptObject;
            V := ScriptObjectToVariant(SO);
            Variant(P^) := V;
          end;
          P := ShiftPointer(P, _SizeVariant);
        end;
      end;

      if lbuff > 0 then
        FreeMem(buff, lbuff);
    end
    else
    begin
      S := ToString(V);
      SetLength(S, L);
      Params[0].AsVariant := S;
    end;
  end;
end;

procedure DynaGet(M: TPAXMethodBody);
var
  SO: TPaxScriptObject;
  D: TPaxClassDefinition;
  I: Integer;
  P: Pointer;
begin
  with M do
  begin
    SO := TPAXScriptObject(Self);
    if SO.ExtraPtr = nil then
      raise Exception.Create(errDynamicArrayNotInitialized);

    D := SO.ClassRec.GetClassDef;
    I := StrToInt(Name);
    P := ShiftPointer(SO.ExtraPtr, I * D.ElSize);
    result.AsVariant := GetVariantValue(SO.Scripter, P, D.ElType, D.ElTypeName);
    PSelf := nil;
  end;
end;

procedure DynaPut(M: TPAXMethodBody);
var
  SO: TPaxScriptObject;
  D: TPaxClassDefinition;
  I: Integer;
  P: Pointer;
  V: Variant;
begin
  with M do
  begin
    SO := TPAXScriptObject(Self);
    if SO.ExtraPtr = nil then
      raise Exception.Create(errDynamicArrayNotInitialized);

    D := SO.ClassRec.GetClassDef;
    I := StrToInt(Name);
    V := Params[0].AsVariant;
    P := ShiftPointer(SO.ExtraPtr, I * D.ElSize);
    PutVariantValue(SO.Scripter, P, V, D.ElType);
    PSelf := nil;
  end;
end;

procedure AddTypeAlias(const T1, T2: String);
var
  S, Dest: String;
begin
  Dest := T2;
  repeat
    S := FindTypeAlias(Dest, true);
    if S <> '' then
      Dest := S;
  until S = '';
  TypeAliases.Add(T1 + '=' + Dest);
end;

function FindTypeAlias(const TypeName: String; UpCase: Boolean): String;
var
  I: Integer;
  S: String;
  b: Boolean;
begin
{$IFDEF VARIANTS}
  If UpCase then begin
    Result := '';
    // locate name
    S := TypeName + TypeAliases.NameValueSeparator;
    if Not TypeAliases.Find (S, I) and
       (I < TypeAliases.Count) and
       (StrEql (Copy(TypeAliases[I], 1, Length(S)), S)) then begin
      //S := TypeAliases [i];
      Result := TypeAliases.ValueFromIndex [i];
    end;

    Exit;
  end;
{$ENDIF}

  for I:=0 to TypeAliases.Count - 1 do
  begin
    S := TypeAliases.Names[I];

    if UpCase then
      b := StrEql(TypeName, S)
    else
      b := TypeName = S;

    if b then
    begin
      result := TypeAliases.Values[S];
      Exit;
    end;
  end;
  result := '';
end;

procedure _Abort;
begin
  Abort;
end;

procedure Initialization_BASE_EXTERN;
var
  C: TPaxClassDefinition;
begin
  DefinitionList := TPAXDefinitionList.Create(true);
  ArrayParamMethods := TStringList.Create;

  //-- jgv, during registration the majority is not case sensitive
  TypeAliases := TStringList.Create;
  TypeAliases.Sorted := True;
{$IFDEF VARIANTS}
  TypeAliases.CaseSensitive := False;
{$ENDIF}
  TypeAliases.duplicates := dupAccept;

  UnresolvedTypes := TStringList.Create;

  AddTypeAlias('Longint', 'Integer');
  AddTypeAlias('LongWord', 'Cardinal');
  AddTypeAlias('DWord', 'LongWord');
  AddTypeAlias('UInt', 'DWord');
  AddTypeAlias('ULong', 'Cardinal');
  AddTypeAlias('THandle', 'Cardinal');
  AddTypeAlias('TDateTime', 'Double');
  AddTypeAlias('Real', 'Double');

 with DefinitionList do
 begin
   AddDynamicArrayType('DynArrayVariant', 'Variant', nil);

   AddRTTIType(TypeInfo(HRESULT));

   C := AddRecordType('TGUID', SizeOf(TGUID), nil);
   AddRecordField(C, 'D1', 'Cardinal', 0);
   AddRecordField(C, 'D2', 'Word', 4);
   AddRecordField(C, 'D3', 'Word', 6);
   AddRecordField(C, 'D40', 'byte', 8);
   AddRecordField(C, 'D41', 'byte', 9);
   AddRecordField(C, 'D42', 'byte', 10);
   AddRecordField(C, 'D43', 'byte', 11);
   AddRecordField(C, 'D44', 'byte', 12);
   AddRecordField(C, 'D45', 'byte', 13);
   AddRecordField(C, 'D46', 'byte', 14);
   AddRecordField(C, 'D47', 'byte', 15);

   AddTypeAlias('TCLSID', 'TGUID');

{
   C := AddRecordType('TPoint', SizeOf(TPoint), nil);
   AddRecordField(C, 'X', 'Integer', 0);
   AddRecordField(C, 'Y', 'Integer', 4);

   C := AddRecordType('TRect', SizeOf(TRect), nil);
   AddRecordField(C, 'Left', 'Integer', 0);
   AddRecordField(C, 'Top', 'Integer', 4);
   AddRecordField(C, 'Right', 'Integer', 8);
   AddRecordField(C, 'Bottom', 'Integer', 12);
}

   AddClass2(TObject, nil, nil, nil, ckClass);
   AddMethod2(TObject, 'constructor Create;', @TObject.Create);
   AddMethod2(TObject, 'class function ClassInfo: Pointer;', @TObject.ClassInfo);
   AddMethod2(TObject, 'class function ClassName: ShortString;', @TObject.ClassName);
   AddMethod2(TObject, 'class function ClassParent: TClass;', @TObject.ClassParent);
   AddMethod2(TObject, 'function ClassType: TClass;', @TObject.ClassType);
   AddMethod2(TObject, 'destructor Destroy; virtual;', @TObject.Destroy);
   AddMethod2(TObject, 'destructor Free;', @TObject.Free);
   AddMethod2(TObject, 'class function InheritsFrom(AClass: TClass): Boolean;', @TObject.InheritsFrom);
   AddMethod2(TObject, 'class function InstanceSize: Longint;', @TObject.InstanceSize);
   AddMethod2(TObject, 'function GetInterface(const IID: TGUID; out Obj): Boolean;', @TObject.GetInterface);

   AddInterfaceType('IUnknown', IUnknown, '', IUnknown, nil);
   AddMethod6(IUnknown, 'function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;');
   AddMethod6(IUnknown, 'function _AddRef: Integer; stdcall;');
   AddMethod6(IUnknown, 'function _Release: Integer; stdcall;');

   AddMethod3('PaxArray', _PaxArray, -1, nil, true);
   AddMethod3('Dump', _Dump, 0, nil, true);
   AddMethod3('IOResult', _IOResult, 0, nil, true);
   AddMethod3('ScriptObjectListCount', _ScriptObjectListCount, 0, nil, true);
   AddMethod3('Destroy', _Destroy, 0, nil, true);
   AddMethod3('GetTickCount', _GetTickCount, 0, nil, true);
   AddMethod3('GetTotalAllocated', _GetTotalAllocated, 0, nil, true);
   AddMethod3('Sleep', _Sleep, 1, nil, true);
   AddMethod3('DoNotDestroy', _DoNotDestroy, 1, nil, true);
   AddMethod3('Assigned', _Assigned, 1, nil, true);
   AddMethod3('Keep', _DoNotDestroy, 1, nil, true);
   AddMethod3('CreateArray', _CreateArray, 1, nil, true);
   AddMethod3('Length', _Length, 1, nil, true);
   AddMethod3('SetLength', _SetLength, 2, nil, true);
   AddMethod3('HasProperty', _HasProperty, 1, nil, true);
   AddMethod3('PropExists', _PropExists, 2, nil, true);
   AddMethod3('toInteger', _toInteger, 1, nil, true);
   AddMethod3('toString', _toString, 1, nil, true);
   AddMethod3('toNumber', _toNumber, 1, nil, true);
   AddMethod3('toBoolean', _toBoolean, 1, nil, true);

   AddMethod3('isUndefined', _IsUndefined, 1, nil, true);
   AddMethod3('isString', _IsString, 1, nil, true);
   AddMethod3('isNumber', _IsNumber, 1, nil, true);
   AddMethod3('isBoolean', _IsBoolean, 1, nil, true);
   AddMethod3('isObject', _IsObject, 1, nil, true);
   AddMethod3('isPaxArray', _IsPaxArray, 1, nil, true);
   AddMethod3('isVBArray', _IsVBArray, 1, nil, true);

   AddMethod3('Prev', _Prev, 1, nil, true);
   AddMethod3('Pred', _Prev, 1, nil, true);
   AddMethod3('Succ', _Succ, 1, nil, true);

   AddMethod3('Low', _Low, 1, nil, true);
   AddMethod3('High', _High, 1, nil, true);

   AddClass2(TPAXDelegate, nil, nil, nil);
   AddClass2(TPAXError, nil, nil, nil);

   AddClass2(TPAXArray, nil, nil, nil, ckArray);
   AddMethod2(TPAXArray, 'constructor Create(Bounds: array of Integer);',
     @TPaxArray.Create);
   AddMethod2(TPAXArray, 'function Get(const Indexes: array of Integer): Variant;',
     @TPaxArray.Get);
   AddMethod2(TPAXArray, 'procedure Put(const Indexes: array of Integer; const Value: Variant);',
     @TPaxArray.Put);
   AddMethod2(TPAXArray, 'procedure ClearIndexes;',
     @TPaxArray.ClearIndexes);
   AddMethod2(TPAXArray, 'function AddIndex(I: Integer): Integer;',
     @TPaxArray.AddIndex);
   AddMethod2(TPAXArray, 'function _Get: Variant;',
     @TPaxArray._Get);
   AddMethod2(TPAXArray, 'procedure _Put(const Value: Variant);',
     @TPaxArray._Put);

   AddConstant('null', Undefined, nil);
   AddConstant('MaxInt', MaxInt, nil);
   AddConstant('DEFAULT_CHARSET', 1, nil);


   AddConstant('S_OK', 0, nil);
   AddConstant('S_FALSE', 1, nil);
   AddConstant('E_NOINTERFACE', Integer($80004002), nil);
   AddConstant('E_UNEXPECTED', Integer($8000FFFF), nil);
   AddConstant('E_NOTIMPL', Integer($80004001), nil);

   AddConstant('varEmpty',    $0000, nil);
   AddConstant('varNull',     $0001, nil);
   AddConstant('varSmallInt', $0002, nil);
   AddConstant('varInteger',  $0003, nil);
   AddConstant('varSingle',   $0004, nil);
   AddConstant('varDouble',   $0005, nil);
   AddConstant('varCurrency', $0006, nil);
   AddConstant('varDate',     $0007, nil);
   AddConstant('varOleStr',   $0008, nil);
   AddConstant('varDispatch', $0009, nil);
   AddConstant('varError',    $000A, nil);
   AddConstant('varBoolean',  $000B, nil);
   AddConstant('varVariant',  $000C, nil);
   AddConstant('varUnknown',  $000D, nil);
   AddConstant('varShortInt', $0010, nil);
   AddConstant('varByte',     $0011, nil);
   AddConstant('varWord',     $0012, nil);
   AddConstant('varLongWord', $0013, nil);
   AddConstant('varInt64',    $0014, nil);

   AddMethod1('function Format(const Format: string; const Args: array of const): string;',
                    @Format, nil, true);
   AddMethod1('function IntfRefCount(const I: IUnknown): Integer;',
                    @IntfRefCount, nil, true);

   AddMethod1('procedure Abort;', @_Abort, nil, true);
//   AddRTTIType(TypeInfo(IInterface));

 end;
 DefListInitialCount := DefinitionList.Count;

end;

procedure Finalization_BASE_EXTERN;
begin
  DefinitionList.Free;
  ArrayParamMethods.Free;
  TypeAliases.Free;
  UnresolvedTypes.Free;
end;


end.


