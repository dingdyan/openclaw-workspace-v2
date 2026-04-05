////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_CLASS.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////


{$I PaxScript.def}
unit BASE_CLASS;
interface

uses
{$IFDEF WIN32}
  Windows,
{$ENDIF}
{$IFDEF VARIANTS}
  Variants,
{$ENDIF}
  SysUtils,
  Classes,
  TypInfo,
  BASE_CONSTS,
  BASE_SYS,
  BASE_EXTERN;

type
  TPAXScriptObject = class;

  TPAXScriptObjectClass = class of TPAXScriptObject;

  TPAXMemberRec = class;
  TPAXClassRec = class;
  TPAXClassList = class;

  TPAXProperty = class
  private
    SO: TPAXScriptObject;
    fUpCaseIndex: Integer;
    ExtraDef: TPAXDefinition;
    Scripter: Pointer;
    Val: Variant;
    function GetValue(NParams: Integer): Variant;
    procedure PutValue(NParams: Integer; const AValue: Variant);
    function GetReadID: Integer;
    function GetWriteID: Integer;
  public
    MemberRec: TPAXMemberRec;
    fValue: PVariant;
    constructor Create(SO: TPAXScriptObject; PValue: PVariant;
                       MemberRec: TPAXMemberRec);
    function IsImported: Boolean;
    function IsStatic: Boolean;
    function Definition: TPAXDefinition;
    function PTerminalValue: PVariant;
    function GetAddress(NParams: Integer): PVariant;
    function GetKind: Integer;
    property ReadID: Integer read GetReadID;
    property WriteID: Integer read GetWriteID;
    property Value[NParams: Integer]: Variant read GetValue write PutValue;
    property UpCaseIndex: Integer read fUpCaseIndex;
  end;

  TPAXPropertyList = class(TPAXIndexedList)
  private
    Scripter: Pointer;
    function GetProperty(I: Integer): TPAXProperty;
    function GetName(I: Integer): String;
  public
    constructor Create(Scripter: Pointer);
    function FindProperty(PropertyNameIndex: Integer): TPAXProperty;
    function GetDefaultProperty: TPAXProperty;
    property Names[I: Integer]: String read GetName;
    property Properties[I: Integer]: TPAXProperty read GetProperty;
  end;

  TPAXScriptObject = class(TPersistent)
  public
    PropertyList: TPAXPropertyList;
    ClassRec: TPAXClassRec;

    HasFordiddenProperties: Boolean;

    function GetClassDef: TPAXClassDefinition;
  public
    Instance: TObject;
    PClass: TClass;
    RefCount: Integer;
    IsClass: Boolean;
    Intf: IUnknown;
    PIntf: PUnknown;

    ExtraPtr: Pointer;
    ExtraPtrSize: Integer;
    ExternalExtraPtr: Boolean;

    ThreadID: Cardinal;

    _ObjCount: Int64;

    constructor Create(ClassRec: TPAXClassRec); virtual;
    destructor Destroy; override;
    function HasProperty(const PropertyName: String): Boolean; virtual;
    function Get(PropertyNameIndex: Integer): TPAXProperty;
    function SafeGet(PropertyNameIndex: Integer): TPAXProperty; virtual;
    function Put(PropertyNameIndex: Integer;
                 const Value: Variant; NParams: Integer): TPAXProperty;
    function GetAddress(PropertyNameIndex: Integer;
                        NParams: Integer): PVariant;
    procedure ClearProperty(PropertyNameIndex: Integer);
    function GetProperty(PropertyNameIndex: Integer;
                         NParams: Integer): Variant; virtual;
    procedure PutProperty(PropertyNameIndex: Integer;
                          const Value: Variant; NParams: Integer); virtual;
    function GetDefaultProperty(NParams: Integer): Variant;
    procedure PutDefaultProperty(const Value: Variant; NParams: Integer);
    function CreateProperty(PropertyNameIndex: Integer;
                            PValue: PVariant;
                            MemberRec: TPAXMemberRec): TPAXProperty;
    procedure PutPublishedProperty(const PropertyName: String; const Value: Variant);
    function GetPublishedProperty(const PropertyName: String; NParams: Integer): Variant;
    function HasPublishedProperty(const PropertyName: String): Boolean;

    function Duplicate: TPAXScriptObject;
    function ToString: String; virtual;
    function Scripter: Pointer;
    function IsImported: Boolean;
    function DefaultValue: Variant; virtual;
    function GetPropertyName(Index: Integer): String; virtual;
    function ExtraInstance: TObject; virtual;
    procedure CallAutoDestructor;
    procedure SetDefaultValue(const V: Variant); virtual;
    procedure FreeExtraPtr;
    property ClassDef: TPAXClassDefinition read GetClassDef;
  end;

  TPAXMemberRec = class
  public
    ID, ReadID, WriteID, InitN: Integer;
    ml: TPAXModifierList;
    Kind: Integer;
    Definition: TPAXDefinition;
    UpCaseIndex: Integer;
    fClassRec: TPAXClassRec;
    IsSource: Boolean;
    IsPublished: Boolean;
    NParams: Integer;
    IsImplementationSection: Boolean;
    constructor Create(ID: Integer; ClassRec: TPAXClassRec);
    destructor Destroy; override;
    function Scripter: Pointer;
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream;
                             DS: Integer = 0; DP: Integer = 0);
    function IsStatic: boolean;
    function IsDefault: Boolean;
    function IsImported: Boolean;
    function IsImportedObject: Boolean;
    procedure CheckAccess;
    function GetName: String;
    function GetNameIndex: Integer;
  end;

  TPAXMemberList = class(TPAXIndexedList)
  private
    Owner: TPAXClassRec;
    function GetRecord(Index: Integer): TPAXMemberRec;
    function Scripter: Pointer;
  public
    constructor Create(Owner: TPAXClassRec);
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream;
                             DS: Integer = 0; DP: Integer = 0);
    function GetMemberID(const Name: String; UpCase: Boolean = true): Integer;
    function IndexOfMember(const Name: String; UpCase: Boolean = true): Integer;
    function GetMemberRec(const Name: String; UpCase: Boolean = true): TPAXMemberRec;
    function GetMemberRecByID(MemberID: Integer): TPAXMemberRec;
    function UpperCaseIndexOf(UpCaseIndex: Integer): Integer;
    procedure DeleteMember(const Name: String; UpCase: Boolean = true);
    property Records[Index: Integer]: TPAXMemberRec read GetRecord; default;
  end;

  TPAXHeapItem = class(TPersistent)
  public
    constructor Create(H: TPaxObjectList);
  end;

  TPAXCompileTimeHeap = class(TPaxObjectList)
  public
    procedure ResetCompileStage;
  end;

  TPAXClassRec = class
  public
    NameIdx: Integer;
    UpCaseIndex: Integer;
    AncestorClassRec: TPAXClassRec;
    ClassObject: TPAXScriptObject;
    Name: String;
    OwnerName, AncestorName: String;
    Scripter: Pointer;
    ClassID: Integer;
    ModuleID: Integer;
    ml: TPAXModifierList;
    MemberList: TPAXMemberList;
    ck: TPAXClassKind;
    IsStaticArray: Boolean;
    OwnerClassRec: TPAXClassRec;
    fClassDef: TPAXClassDefinition;

    UsingInitList: TPaxIds;
    AutoDestructorID: Integer;

    isSet: Boolean;
    PtiSet: PTypeInfo;

    fHasRunTimeProperties: Boolean;

    constructor Create(AScripter: Pointer; kc: TPAXClassKind);
    destructor Destroy; override;
    procedure ResetCompileStage;
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream;
                             DS: Integer = 0; DP: Integer = 0);
    function GetClassDef: TPAXClassDefinition;
    function AddField(ID: Integer; ml: TPAXModifierList): TPAXMemberRec;
    function AddMethod(ID: Integer; ml: TPAXModifierList): TPAXMemberRec;
    function AddProperty(ID: Integer; ml: TPAXModifierList): TPAXMemberRec;
    function AddNestedClass(ID: Integer; ml: TPAXModifierList): TPAXMemberRec;
    function CreateScriptObject(const ObjectName: String = ''): TPAXScriptObject;
    procedure CreateClassObject;
    function GetMember(MemberNameIndex: Integer; UpCaseOn: Boolean = true): TPAXMemberRec;
    function FindMember(MemberNameIndex: Integer; ma: TPAXMemberAccess; UpCaseOn: Boolean = true): TPAXMemberRec;
    function FindMemberEx(MemberNameIndex: Integer;
                         ma: TPAXMemberAccess;
                         var FoundInBaseClass: Boolean;
                         UpCaseON: Boolean = true): TPAXMemberRec;
    function IsNestedClass(ClassID: Integer): Boolean;
    function FindNestedClassID(ClassNameIndex: Integer): Integer;
    function AddHostMethod(D: TPAXMethodDefinition): TPAXMemberRec;
    function AddHostProperty(D: TPAXPropertyDefinition): TPAXMemberRec;
    function AddHostConstant(D: TPAXConstantDefinition): TPAXMemberRec;
    function AddHostVariable(D: TPAXVariableDefinition): TPAXMemberRec;
    function AddHostObject(D: TPAXObjectDefinition): TPAXMemberRec;
    function AddVirtualObject(D: TPAXVirtualObjectDefinition): TPAXMemberRec;
    function AddHostInterfaceVar(D: TPAXInterfaceVarDefinition): TPAXMemberRec;
    function AddHostField(D: TPAXFieldDefinition): TPAXMemberRec;
    function AddHostRecordField(D: TPAXRecordFieldDefinition): TPAXMemberRec;
    function FindOverloadedSubID(NameIndex: Integer; ma: TPAXMemberAccess; NP: Integer): Integer;
    procedure FindOverloadedSubList(NameIndex: Integer;
                                    ma: TPAXMemberAccess;
                                    Ids: TPaxIds);
    function IsImported: Boolean;
    function InheritsFromClass(AClassID: Integer): Boolean;
    procedure DeleteMember(ID: Integer);
    function GetConstructorID: Integer;
    function GetConstructorIDEx: Integer; overload;
    function GetConstructorIDEx(const Params: array of const): Integer; overload;
    function GetClassList: TPAXClassList;
    procedure InitStaticFields;
    function ModuleName: String;
    function IsStatic: Boolean;
    function DelphiClass: TClass;
    function DelphiClassEx: TClass;
    function HasPublishedProperty(const PropertyName: String): Boolean;
    function HasPublishedPropertyEx(const PropertyName: String; var AClassName: String): Boolean;
    function FindBinaryOperatorID(const OperName: String; T1, T2: Integer): Integer;
    function FindUnaryOperatorID(const OperName: String; T: Integer): Integer;
    function HasRunTimeProperties: Boolean;
  end;

  TPAXClassList = class(TPAXIndexedList)
  private
    Scripter: Pointer;
    SaveCount: Integer;

    function GetRecord(Index: Integer): TPAXClassRec;
    function GetSourceClassList: TList;
  public
    DelegateClassRec,
    ObjectClassRec, BooleanClassRec, StringClassRec, NumberClassRec,
    DateClassRec, FunctionClassRec, ArrayClassRec,
    ActiveXClassRec: TPAXClassRec;

    constructor Create(AScripter: Pointer);
    destructor Destroy; override;
    procedure SaveToStream(S: TStream; I1, I2: Integer);
    procedure LoadFromStream(S: TStream);
    procedure Reset;
    procedure ResetCompileStage;

    procedure InitRunStage;
    procedure ResetRunStage;

    function AddClass(ClassID: Integer;
                      const AClassName, OwnerName, AncestorName: String;
                      ml: TPAXModifierList; ck: TPAXClassKind; UpCase: boolean): TPAXClassRec;
    function FindClass(ClassID: Integer): TPAXClassRec;
    function FindClassByGuid(const guid: TGUID): TPAXClassRec;
    function FindImportedClass(PClass: TClass): TPAXClassRec;
    function ExistsClassByName(const Name: String): boolean;
    function FindClassByName(const Name: String): TPAXClassRec;
    function FindClassByInstance(Instance: TObject): TPAXClassRec;
    function FindNestedClass(OwnerList: TStringList; const Name: String): TPAXClassRec;
    function CreateScriptObject(ClassID: Integer): TPAXScriptObject;
    function FindMember(ClassID, MemberNameIndex: Integer; ma: TPAXMemberAccess): TPAXMemberRec;
    procedure CreateClassObjects(StartRecNo: Integer);
    procedure InitStaticFields(StartRecNo: Integer);
    procedure AddDefinitionList(L: TPAXDefinitionList; N: Integer);

    function CreateBooleanObject(const AValue: Variant): TPaxScriptObject;
    function CreateNumberObject(const AValue: Variant): TPaxScriptObject;
    function CreateStringObject(const AValue: Variant): TPaxScriptObject;
    function CreateDateObject(const AValue: Variant): TPaxScriptObject;
    function CreateFunctionObject(const AValue: Variant): TPaxScriptObject;

    procedure Dump(const FileName: String);
    property Records[Index: Integer]: TPAXClassRec read GetRecord; default;
  end;

  TPAXScriptObjectList = class
  private
    fPaxObjects: TList;
    _Scripter: Pointer;
     function GetCount: Integer;
     function GetItem(I: Integer): TPaxScriptObject;
  public
    constructor Create(_Scripter: Pointer);
    destructor Destroy; override;
    procedure Clear;
    procedure Add(SO: TPaxScriptObject);
    procedure Delete(I: Integer);

    function IndexOfDelphiObject(DelphiInstance: TObject): Integer;
    function FindScriptObject(DelphiInstance: TObject): TPAXScriptObject;
    function FindScriptObjectByIntf(PIntf: PUnknown): TPAXScriptObject;
    procedure ResetCompileStage(FreeHost: boolean = false);
    procedure RemoveObject(SO: TPAXScriptObject);
    procedure RemoveStructure(const V: Variant);
    procedure ResetRunStage(FreeHost: Boolean = false);
    procedure RemoveTail(K: Integer; ThreadID: Cardinal = 0);
    function HasObject(SO: TPAXScriptObject): Boolean;
    property PaxObjects: TList read fPaxObjects;
    property Count: Integer read GetCount;
    property Items[I: Integer]: TPaxScriptObject read GetItem; default;
  end;

  TPAXDelegate = class(TPAXHeapItem)
  public
    SubID, N: Integer;
    D: TPAXMethodDefinition;
    fName: String;
    constructor Create(Scripter: Pointer;
                       SubID, N: Integer; D: TPAXMethodDefinition);
    destructor Destroy; override;
  published
    property Name: String read fName write fName;
  end;

  TPAXError = class(TPersistent)
  private
    fScriptTime: String;
    fDescription: String;
    fModuleName: String;
    fFileName: String;
    fLine: String;
    fLineNumber: Integer;
    fPosition: Integer;
    fTextPosition: Integer;
    fMethodId: Integer;
    fErrClassType: TClass;
  public
    constructor Create;
  published
    property ScriptTime: String read fScriptTime write fScriptTime;
    property Description: String read fDescription write fDescription;
    property Message: String read fDescription write fDescription;
    property ModuleName: String read fModuleName write fModuleName;
    property FileName: String read fFileName write fFileName;
    property Line: String read fLine write fLine;
    property LineNumber: Integer read fLineNumber write fLineNumber;
    property Position: Integer read fPosition write fPosition;
    property TextPosition: Integer read fTextPosition write fTextPosition;
    property MethodId: Integer read fMethodId write fMethodId;
    property ErrClassType: TClass read fErrClassType write ferrClassType;
  end;

  ActiveXObject = class
  public
    D: Variant;
    constructor Create(Scripter: Pointer);
  end;

function ScriptObjectToVariant(const Value: TPAXScriptObject): Variant;
function VariantToScriptObject(const Value: Variant): TPAXScriptObject;
function ToStr(Scripter: Pointer; const V: Variant): String;
function _ToStr(Scripter: Pointer; const V: Variant): String;
function ToInteger(const V: Variant): Integer;
function CreateNameIndex(const Name: String; Scripter: Pointer): Integer;
function NameIndexToUpperCaseIndex(NameIndex: Integer; Scripter: Pointer): Integer;
function DuplicateObject(const V: Variant): Variant;
function IsPaxArray(const V: Variant): Boolean;
function IsDynamicArray(const V: Variant): Boolean;

function ToObject(const Value: Variant; Scripter: Pointer): Variant;
function ToPrimitive(const V: Variant): Variant;
function ToString(const Value: Variant): String;
function ToNumber(const V: Variant): Variant;
function ToDate(const V: Variant): Variant;
function ToInt32(const V: Variant): Variant;
function ToInt64(const V: Variant): Variant;
function ToBoolean(const V: Variant): Variant;
function IsNaN(const V: Variant): boolean;
function RelationalComparison(const V1, V2: Variant): Variant;
function EqualityComparison(const V1, V2: Variant): TBoolean;
function StrictEqualityComparison(const V1, V2: Variant): TBoolean;
procedure SortVariants(var A: array of Variant);
function StringValueToVariant(const S: String; const Dest: Variant): Variant;
function UntypedValueToVariant(P: Pointer; Count: Integer; const Dest: Variant): Variant;
procedure VariantToUntypedValue(const V: Variant; P: Pointer; Count: Integer);
function TVarRecToVariant(const P: TVarRec; Scripter: Pointer): Variant;

function IsDateObject(const V: Variant): Boolean;
function IsStringObject(const V: Variant): Boolean;
function IsNumberObject(const V: Variant): Boolean;
function IsBooleanObject(const V: Variant): Boolean;
function IsFunctionObject(const V: Variant): Boolean;

function IsHostObject(const V: Variant): Boolean;

function DelphiInstanceToScriptObject(Instance: TObject; Scripter: Pointer;
                                      RaiseException: boolean = true): TPAXScriptObject;
function DelphiClassToScriptObject(AClass: TClass; Scripter: Pointer): TPAXScriptObject;
function InterfaceToScriptObject(const I: IUnknown; Scripter: Pointer;
                                 const InterfaceClassName: String = ''): TPaxScriptObject;

var
  BooleanClass: TPAXScriptObjectClass = nil;
  NumberClass: TPAXScriptObjectClass = nil;
  StringClass: TPAXScriptObjectClass = nil;
  DateClass: TPAXScriptObjectClass = nil;
  FunctionClass: TPAXScriptObjectClass = nil;

implementation

uses
  BASE_SCRIPTER, BASE_SYMBOL, BASE_CODE, BASE_EVENT, BASE_REGEXP, BASE_CONV;

function DelphiInstanceToScriptObject(Instance: TObject; Scripter: Pointer;
                                      RaiseException: boolean = true): TPAXScriptObject;
var
  S: String;
  ClassRec: TPAXClassRec;
  W: TPAXScriptObjectList;
begin
  W := TPAXBaseScripter(Scripter).ScriptObjectList;
  result := W.FindScriptObject(Instance);
  if result <> nil then
    Exit;

  ClassRec := TPAXBaseScripter(Scripter).ClassList.FindClassByInstance(Instance);

  if ClassRec = nil then
  if not RaiseException then
    Exit;

  if ClassRec = nil then
  begin
    S := Instance.ClassName;
    raise TPAXScriptFailure.Create(Format(errClassIsNotImported, [S]));
  end;
  result := ClassRec.CreateScriptObject;
  result.Instance := Instance;

//  if Instance.ClassType = TPAXArray then
    result.RefCount := 1;
end;

function DelphiClassToScriptObject(AClass: TClass; Scripter: Pointer): TPAXScriptObject;
var
  S: String;
  ClassRec: TPAXClassRec;
begin
  S := AClass.ClassName;
  ClassRec := TPAXBaseScripter(Scripter).ClassList.FindClassByName(S);
  if ClassRec = nil then
    raise TPAXScriptFailure.Create(Format(errClassIsNotImported, [S]));
  result := ClassRec.CreateScriptObject;
  result.PClass := AClass;
end;

function InterfaceToScriptObject(const I: IUnknown; Scripter: Pointer;
                                 const InterfaceClassName: String = ''): TPaxScriptObject;
var
  Instance: TObject;
  S: String;
  ClassRec: TPaxClassRec;
begin
  result := nil;
  Instance := GetImplementorOfInterface(I);
  if Instance = nil then
    Exit
  else
  begin
    if InterfaceClassName <> '' then
      S := InterfaceClassName
    else
    begin
      S := Instance.ClassName;
      S[1] := 'I';
    end;

    ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(S);
    if ClassRec <> nil then
    begin
      result := ClassRec.CreateScriptObject;
      Move(I, result.Intf, 4);
      result.RefCount := 1;
    end
    else
    begin
      ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName('IUnknown');
      if ClassRec <> nil then
      begin
        result := ClassRec.CreateScriptObject;
        Move(I, result.Intf, 4);
        result.RefCount := 1;
      end;
    end;
  end;
end;

function IsHostObject(const V: Variant): Boolean;
var
  SO: TPAXScriptObject;
begin
  if IsObject(V) then
  begin
    SO := VariantToScriptObject(V);
    result := SO.Instance <> nil;
  end
  else
    result := false;
end;

function IsPaxArray(const V: Variant): Boolean;
var
  SO: TPAXScriptObject;
begin
  if IsObject(V) then
  begin
    SO := VariantToScriptObject(V);
    result := SO.ClassRec.ck = ckArray;
  end
  else
    result := false;
end;

function IsDynamicArray(const V: Variant): Boolean;
var
  SO: TPAXScriptObject;
begin
  if IsObject(V) then
  begin
    SO := VariantToScriptObject(V);
    result := SO.ClassRec.ck = ckDynamicArray;
  end
  else
    result := false;
end;

function IsDateObject(const V: Variant): Boolean;
var
  SO: TPAXScriptObject;
  ClassList: TPAXClassList;
begin
  if IsObject(V) then
  begin
    SO := VariantToScriptObject(V);
    ClassList := TPAXBaseScripter(SO.Scripter).ClassList;
    result := SO.ClassRec = ClassList.DateClassRec;
  end
  else
    result := false;
end;

function IsFunctionObject(const V: Variant): Boolean;
var
  SO: TPAXScriptObject;
  ClassList: TPAXClassList;
begin
  if IsObject(V) then
  begin
    SO := VariantToScriptObject(V);
    ClassList := TPAXBaseScripter(SO.Scripter).ClassList;
    result := SO.ClassRec = ClassList.FunctionClassRec;
  end
  else
    result := false;
end;

function IsStringObject(const V: Variant): Boolean;
var
  SO: TPAXScriptObject;
  ClassList: TPAXClassList;
begin
  if IsObject(V) then
  begin
    SO := VariantToScriptObject(V);
    ClassList := TPAXBaseScripter(SO.Scripter).ClassList;
    result := SO.ClassRec = ClassList.StringClassRec;
  end
  else
    result := false;
end;

function IsBooleanObject(const V: Variant): Boolean;
var
  SO: TPAXScriptObject;
  ClassList: TPAXClassList;
begin
  if IsObject(V) then
  begin
    SO := VariantToScriptObject(V);
    ClassList := TPAXBaseScripter(SO.Scripter).ClassList;
    result := SO.ClassRec = ClassList.BooleanClassRec;
  end
  else
    result := false;
end;

function IsNumberObject(const V: Variant): Boolean;
var
  SO: TPAXScriptObject;
  ClassList: TPAXClassList;
begin
  if IsObject(V) then
  begin
    SO := VariantToScriptObject(V);
    ClassList := TPAXBaseScripter(SO.Scripter).ClassList;
    result := SO.ClassRec = ClassList.NumberClassRec;
  end
  else
    result := false;
end;

constructor TPAXError.Create;
begin
  inherited;

  fScriptTime := '';
  fDescription := '';
  fModuleName := '';
  fFileName := '';
  fLine := '';
  fLineNumber := 0;
  fPosition := 0;
  fTextPosition := 0;
  fErrClassType := nil;
end;

function CreateNameIndex(const Name: String; Scripter: Pointer): Integer;
begin
  result := TPaxBaseScripter(Scripter).NameList.Add(Name);
end;

function NameIndexToUpperCaseIndex(NameIndex: Integer; Scripter: Pointer): Integer;
var
  S: String;
  I: Integer;
begin
  I := Integer(TPaxBaseScripter(Scripter).NameList.Objects[NameIndex]);
  if I = 0 then
  begin
    S := UpperCase(TPaxBaseScripter(Scripter).NameList[NameIndex]);
    result := TPaxBaseScripter(Scripter).NameList.Add(S);
    TPaxBaseScripter(Scripter).NameList.Objects[NameIndex] := TObject(result);
  end
  else
    result := I;
end;

constructor TPAXMemberList.Create(Owner: TPAXClassRec);
begin
  Self.Owner := Owner;
  inherited Create;
end;

function TPAXMemberList.Scripter: Pointer;
begin
  result :=Owner.Scripter;
end;

procedure TPAXMemberList.SaveToStream(S: TStream);
var
  I: Integer;
begin
  SaveInteger(Count, S);
  for I:=0 to Count - 1 do
    Records[I].SaveToStream(S);
end;

procedure TPAXMemberList.LoadFromStream(S: TStream;
                                        DS: Integer = 0; DP: Integer = 0);
var
  I, Index, K: Integer;
  MemberRec: TPAXMemberRec;
begin
  K := LoadInteger(S);
  for I:=0 to K - 1 do
  begin
    MemberRec := TPAXMemberRec.Create(0, Owner);
    MemberRec.LoadFromStream(S, DS, DP);

    Index := CreateNameIndex(MemberRec.GetName, Scripter);
    AddObject(Index, MemberRec);
  end;
end;

function TPAXMemberList.GetRecord(Index: Integer): TPAXMemberRec;
begin
  result := TPAXMemberRec(Objects[Index]);
end;

function TPAXMemberList.UpperCaseIndexOf(UpCaseIndex: Integer): Integer;
var
  I: Integer;
  R: TPAXMemberRec;
begin
  result := -1;
  if UpCaseIndex <= 0 then
    Exit;
  for I:=0 to Count - 1 do
  begin
    R := GetRecord(I);
    if R.UpCaseIndex = UpCaseIndex then
    begin
      result := I;
      Exit;
    end;
  end;
end;

function TPAXMemberList.GetMemberID(const Name: String; UpCase: Boolean = true): Integer;
var
  NameIndex, UpCaseIndex, Index: Integer;
  P: TPAXClassRec;
begin
  result := 0;
  NameIndex := CreateNameIndex(Name, Scripter);

  if UpCase then
     UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter)
  else
     UpCaseIndex := -1;

  P := Owner;

  while P <> nil do
  begin
    Index := P.MemberList.IndexOf(NameIndex);
    if Index >= 0 then
    begin
      result := P.MemberList[Index].ID;
      Exit;
    end
    else
    begin
      Index := P.MemberList.UpperCaseIndexOf(UpCaseIndex);
      if Index >= 0 then
      begin
        result := P.MemberList[Index].ID;
        Exit;
      end;
    end;
    P := P.AncestorClassRec;
  end;
end;

function TPAXMemberList.IndexOfMember(const Name: String; UpCase: Boolean = true): Integer;
var
  NameIndex, UpCaseIndex, Index: Integer;
  P: TPAXClassRec;
begin
  result := -1;
  NameIndex := CreateNameIndex(Name, Scripter);

  if UpCase then
     UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter)
  else
     UpCaseIndex := -1;

  P := Owner;

  while P <> nil do
  begin
    Index := P.MemberList.IndexOf(NameIndex);
    if Index >= 0 then
    begin
      result := Index;
      Exit;
    end
    else
    begin
      Index := P.MemberList.UpperCaseIndexOf(UpCaseIndex);
      if Index >= 0 then
      begin
        result := Index;
        Exit;
      end;
    end;
    P := P.AncestorClassRec;
  end;
end;

function TPAXMemberList.GetMemberRec(const Name: String; UpCase: Boolean = true): TPAXMemberRec;
var
  NameIndex, UpCaseIndex, Index: Integer;
  P: TPAXClassRec;
begin
  result := nil;
  NameIndex := CreateNameIndex(Name, Scripter);

  if UpCase then
     UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter)
  else
     UpCaseIndex := -1;

  P := Owner;

  while P <> nil do
  begin
    Index := P.MemberList.IndexOf(NameIndex);
    if Index >= 0 then
    begin
      result := P.MemberList[Index];
      Exit;
    end
    else
    begin
      Index := P.MemberList.UpperCaseIndexOf(UpCaseIndex);
      if Index >= 0 then
      begin
        result := P.MemberList[Index];
        Exit;
      end;
    end;
    P := TPaxBaseScripter(P.Scripter).ClassList.FindClassByName(P.AncestorName);
  end;
end;

procedure TPAXMemberList.DeleteMember(const Name: String; UpCase: Boolean = true);
var
  NameIndex, UpCaseIndex, Index: Integer;
  P: TPAXClassRec;
begin
  NameIndex := CreateNameIndex(Name, Scripter);

  if UpCase then
     UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter)
  else
     UpCaseIndex := -1;

  P := Owner;

  while P <> nil do
  begin
    Index := P.MemberList.IndexOf(NameIndex);
    if Index >= 0 then
    begin
      P.MemberList.DeleteObject(Index);
      Exit;
    end
    else
    begin
      Index := P.MemberList.UpperCaseIndexOf(UpCaseIndex);
      if Index >= 0 then
      begin
        P.MemberList.Delete(Index);
        Exit;
      end;
    end;
    P := TPaxBaseScripter(P.Scripter).ClassList.FindClassByName(P.AncestorName);
  end;
end;

function TPAXMemberList.GetMemberRecByID(MemberID: Integer): TPAXMemberRec;
var
  I: Integer;
  P: TPAXClassRec;
begin
  P := Owner;
  while P <> nil do
  begin
    for I:=0 to P.MemberList.Count - 1 do
    begin
      result := P.MemberList[I];
      if result.ID = MemberID then
        Exit;
    end;
    P := P.AncestorClassRec;
  end;
  result := nil;
end;

constructor TPAXHeapItem.Create(H: TPaxObjectList);
begin
  inherited Create;
  H.Add(Self);
end;

constructor TPAXProperty.Create(SO: TPAXScriptObject; PValue: PVariant;
                                MemberRec: TPAXMemberRec);
begin
  inherited Create;

  Self.SO := SO;
  Self.MemberRec := MemberRec;
  Self.Scripter := SO.Scripter;

  if MemberRec = nil then
  begin
    Val := PValue^;
    fValue := @ Val;
    fUpCaseIndex := 0;
  end
  else
  begin
    if MemberRec.IsStatic then
    begin
      fValue := PValue
    end
    else if IsUndefined(PValue^) then
      fValue := @ Val
    else
    begin
      Val := PValue^;
      fValue := @ Val;
    end;

    fUpCaseIndex := MemberRec.UpCaseIndex;
  end;

  ExtraDef := nil;
end;

function TPAXProperty.GetKind: Integer;
begin
  if MemberRec <> nil then
    result := MemberRec.Kind
  else
    result := KindPROP;
end;

function TPAXProperty.PTerminalValue: PVariant;
begin
  result := GetTerminal(fValue);
end;

function TPAXProperty.GetValue(NParams: Integer): Variant;
var
  P: TPAXProperty;
  SubID, ResID: Integer;
  V: Variant;
  MethodDef: TPAXMethodDefinition;
  S: String;
  I: Integer;
  Indexes: array of Integer;
  SO1: TPaxScriptObject;
  Prop1: TPaxProperty;
  temp: boolean;
begin
  if ReadID = 0 then
  begin
    if IsImported then
    begin
      case Definition.DefKind of
        dkConstant:
          result := TPAXConstantDefinition(Definition).Value;
        dkField:
          result := TPAXFieldDefinition(Definition).GetFieldValue(SO);
        dkRecordField:
          if SO.ExtraPtr = nil then
            result := PTerminalValue^
          else
            result := TPAXRecordFieldDefinition(Definition).GetFieldValue(SO.Scripter, SO.ExtraPtr);
        dkVariable:
          result := TPAXVariableDefinition(Definition).GetValue(Scripter);
        dkObject:
          result := fValue^;
        dkInterface:
          result := fValue^;
        dkProperty:
        begin
          if TPAXPropertyDefinition(Definition).ReadDef.DefKind = dkField then
          begin
            result := TPAXFieldDefinition(TPAXPropertyDefinition(Definition).ReadDef).GetFieldValue(SO);
            Exit;
          end;

          MethodDef := TPaxMethodDefinition(TPAXPropertyDefinition(Definition).ReadDef);
          if MethodDef <> nil then
          begin
            V := ScriptObjectToVariant(SO);
            with TPAXBaseScripter(SO.ClassRec.Scripter) do
            begin
              Code.SaveState;
              Code.CallHostSub(MethodDef, @V, @result, MethodDef.NP);
              Code.RestoreState;
            end;
          end;
        end;
      dkMethod:
      begin
        SO1 := TPAXScriptObject.Create(TPAXBaseScripter(Scripter).ClassList.DelegateClassRec);
        SO1.Instance := TPAXDelegate.Create(Scripter, - Definition.Index,
                        TPAXBaseScripter(Scripter).Code.N, TPaxMethodDefinition(Definition));
        SO1.PClass := TPAXDelegate;
        SO1.PutProperty(CreateNameIndex('Name', Scripter), Definition.Name, 0);
        result := ScriptObjectToVariant(SO1);
      end;
      else
        raise TPAXScriptFailure.Create(Format(ErrPropertyIsNotFound,
          [Definition.Name]));
      end; // case
      Exit;
    end;

    if NParams = 0 then
      result := PTerminalValue^
    else
    begin
      if IsString(fValue^) then
      begin
        if ParamCount > 1 then
          raise TPAXScriptFailure.Create(errTooManyActualParameters);

        I := TPAXBaseScripter(SO.ClassRec.Scripter).Code.PopVariant;
        if TPAXBaseScripter(SO.ClassRec.Scripter).Code.SignZERO_BASED_STRINGS then
           Inc(I);

        S := fValue^;
        result := S[I];
      end
      else if IsPaxArray(PTerminalValue^) then
      begin
        SetLength(Indexes, NParams);
        for I:=1 to NParams do
          Indexes[NParams - I] := TPAXBaseScripter(SO.ClassRec.Scripter).Code.PopVariant;
        result := TPaxArray(VariantToScriptObject(PTerminalValue^).Instance).Get(Indexes);
      end
      else if IsVBArray(fValue^) then
      begin
        SetLength(Indexes, NParams);
        for I:=1 to NParams do
          Indexes[NParams - I] := TPAXBaseScripter(SO.ClassRec.Scripter).Code.PopVariant;

       if VarArrayDimCount(fValue^) = 1 then
       begin
         I := Indexes[0];
         result := Variant(fValue^)[I];
       end
       else
         result := Variant(ArrayGet(fValue, Indexes)^);
      end
      else if IsObject(fValue^) then
      begin
        SO1 := VariantToScriptObject(fValue^);
        Prop1 := SO1.PropertyList.GetDefaultProperty;
        if Prop1 = nil then
        begin
          S := ToStr(SO1.ClassRec.Scripter, TPAXBaseScripter(SO.ClassRec.Scripter).Code.PopVariant);
          result := SO1.GetProperty(CreateNameIndex(S, Scripter), NParams - 1);
          Exit;
        end;
      end;
    end;

    Exit;
  end;

  with TPAXBaseScripter(SO.ClassRec.Scripter) do
  begin
    if SymbolTable.Kind[ReadID] = KindSUB then
    begin
      temp := Code.Terminated;
      Code.Terminated := false;

      V := ScriptObjectToVariant(SO);
      SymbolTable.SaveState;
      SubID := SymbolTable.AppReference(V, SymbolTable.NameIndex[ReadID], maAny);
      ResID := Code.EvalGetFunction(SubID, NParams);
      result := SymbolTable.GetValue(ResID);
      SymbolTable.RestoreState;

      Code.Terminated := temp;
      Exit;
    end;

    P := SO.PropertyList.FindProperty(SymbolTable.NameIndex[ReadID]);
    if P = nil then
      raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [SymbolTable.Name[ReadID]]));

    result := P.fValue^;
  end;
end;

function TPAXProperty.GetAddress(NParams: Integer): PVariant;
var
  P: TPAXProperty;
  SubID, ResID: Integer;
  V: Variant;
  I: Integer;
  Indexes: array of Integer;
begin
  result := nil;
  if ReadID = 0 then
  begin
    if IsImported then
    begin
      case Definition.DefKind of
        dkConstant:
//        raise TPAXScriptFailure.Create(errOperatorNotApplicable);
          result := @ TPAXConstantDefinition(Definition).DefValue;
        dkField:
          result := TPAXFieldDefinition(Definition).GetFieldAddress(SO);
        dkRecordField:
          if SO.ExtraPtr = nil then
            result := PTerminalValue
          else
            result := TPAXRecordFieldDefinition(Definition).GetFieldAddress(SO.Scripter, SO.ExtraPtr);
        dkVariable:
          result := TPAXVariableDefinition(Definition).GetAddress;
        dkObject:
          result := fValue;
        dkInterface:
          result := fValue;
        dkProperty:
        begin
          if TPAXPropertyDefinition(Definition).ReadDef.DefKind = dkField then
          begin
            result := TPAXFieldDefinition(TPAXPropertyDefinition(Definition).ReadDef).GetFieldAddress(SO);
            Exit;
          end;

          result := nil;
{
          MethodDef := TPaxMethodDefinition(TPAXPropertyDefinition(Definition).ReadDef);
          if MethodDef <> nil then
          begin
            V := ScriptObjectToVariant(SO);
            with TPAXBaseScripter(SO.ClassRec.Scripter) do
            begin
              Code.SaveState;
              Code.CallHostSub(MethodDef, @V, @result, MethodDef.NP);
              Code.RestoreState;
            end;
          end;
}
        end;
      else
        raise TPAXScriptFailure.Create(Format(ErrPropertyIsNotFound,
          [Definition.Name]));
      end; // case
      Exit;
    end;

    if NParams = 0 then
      result := PTerminalValue
    else
    begin
      if IsString(fValue^) then
      begin
        raise TPAXScriptFailure.Create(errOperatorNotApplicable);
      end
      else if IsPaxArray(PTerminalValue^) then
      begin
        SetLength(Indexes, NParams);
        for I:=1 to NParams do
          Indexes[NParams - I] := TPAXBaseScripter(SO.ClassRec.Scripter).Code.PopVariant;
        result := TPaxArray(VariantToScriptObject(PTerminalValue^).Instance).GetPtr(Indexes);
      end
      else if IsVBArray(fValue^) then
      begin
        SetLength(Indexes, NParams);
        for I:=1 to NParams do
          Indexes[NParams - I] := TPAXBaseScripter(SO.ClassRec.Scripter).Code.PopVariant;

        result := ArrayGet(fValue, Indexes);
     end;
    end;

    Exit;
  end;

  with TPAXBaseScripter(SO.ClassRec.Scripter) do
  begin
    if SymbolTable.Kind[ReadID] = KindSUB then
    begin
      V := ScriptObjectToVariant(SO);
      SymbolTable.SaveState;
      SubID := SymbolTable.AppReference(V, SymbolTable.NameIndex[ReadID], maAny);
      ResID := Code.EvalGetFunction(SubID, NParams);
      result := SymbolTable.Address[ResID];
      SymbolTable.RestoreState;
      Exit;
    end;

    P := SO.PropertyList.FindProperty(SymbolTable.NameIndex[ReadID]);
    if P = nil then
      raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [SymbolTable.Name[ReadID]]));

    result := P.fValue;
  end;
end;

procedure TPAXProperty.PutValue(NParams: Integer; const AValue: Variant);
var
  P: TPAXProperty;
  SubID: Integer;
  V: Variant;
  MethodDef: TPAXMethodDefinition;
  S: String;
  ch: Char;
  I: Integer;
  Indexes: array of Integer;

  SO1: TPaxScriptObject;
  Prop1: TPaxProperty;
begin
  if WriteID = 0 then
  begin
    if IsImported then
    begin
      case Definition.DefKind of
        dkConstant:
          raise TPAXScriptFailure.Create(Format(errCannotWriteReadOnlyProperty, [Definition.Name]));
        dkProperty:
        begin
          if TPAXPropertyDefinition(Definition).WriteDef.DefKind = dkField then
          begin
            TPAXFieldDefinition(TPAXPropertyDefinition(Definition).WriteDef).SetFieldValue(SO, AValue);
            Exit;
          end;

          MethodDef := TPaxMethodDefinition(TPAXPropertyDefinition(Definition).WriteDef);
          if MethodDef <> nil then
          begin
            V := ScriptObjectToVariant(SO);
            with TPAXBaseScripter(SO.ClassRec.Scripter) do
            begin
              Code.Stack.Push(@AValue);
              Code.SaveState;
              Code.CallHostSub(MethodDef, @V, nil, NParams + 1);
              Code.RestoreState;
            end;
          end;
        end;
      dkField:
        TPAXFieldDefinition(Definition).SetFieldValue(SO, AValue);
      dkRecordField:
        if SO.ExtraPtr = nil then
          PTerminalValue^ := AValue
        else
          TPAXRecordFieldDefinition(Definition).SetFieldValue(SO.Scripter, SO.ExtraPtr, AValue);
      dkVariable:
        TPAXVariableDefinition(Definition).SetValue(Scripter, AValue);
      dkObject:
        fValue^ := AValue;
      dkInterface:
        fValue^ := AValue;
      else
        raise TPAXScriptFailure.Create(Format(ErrPropertyIsNotFound,
          [Definition.Name]));
      end; // case
      Exit;
    end;

    if NParams = 0 then
    begin
      if MemberRec <> nil then
      if MemberRec.ID > 0 then
        if VarType(AValue) = varString then if TPaxBaseScripter(SO.Scripter).SymbolTable.Count[MemberRec.ID] > 0 then
        begin
          PTerminalValue^ := Copy(AValue, 1, TPaxBaseScripter(SO.Scripter).SymbolTable.Count[MemberRec.ID]);
          Exit;
        end;

      PTerminalValue^ := AValue;
    end
    else
    begin
      if IsString(fValue^) then
      begin
        if NParams > 1 then
          raise TPAXScriptFailure.Create(errTooManyActualParameters);

        S := AValue;
        Ch := S[1];

        I := TPAXBaseScripter(SO.ClassRec.Scripter).Code.PopVariant;
        if TPAXBaseScripter(SO.ClassRec.Scripter).Code.SignZERO_BASED_STRINGS then
           Inc(I);

        S := fValue^;
        S[I] := Ch;
        fValue^ := S;
      end
      else if IsPaxArray(PTerminalValue^) then
      begin
        SetLength(Indexes, NParams);
        for I:=1 to NParams do
          Indexes[NParams - I] := TPAXBaseScripter(SO.ClassRec.Scripter).Code.PopVariant;
        TPaxArray(VariantToScriptObject(PTerminalValue^).Instance).Put(Indexes, AValue);
      end
      else if IsVBArray(fValue^) then
      begin
        SetLength(Indexes, NParams);
        for I:=1 to NParams do
          Indexes[NParams - I] := TPAXBaseScripter(SO.ClassRec.Scripter).Code.PopVariant;

       if VarArrayDimCount(fValue^) = 1 then
       begin
         I := Indexes[0];
         Variant(fValue^)[I] := AValue;
       end
       else
         ArrayPut(fValue, Indexes, AValue);
      end
      else if IsObject(fValue^) then
      begin
        SO1 := VariantToScriptObject(fValue^);
        Prop1 := SO1.PropertyList.GetDefaultProperty;
        if Prop1 = nil then
        begin
          S := ToStr(SO1.ClassRec.Scripter, TPAXBaseScripter(SO1.ClassRec.Scripter).Code.PopVariant);
          SO1.PutProperty(CreateNameIndex(S, Scripter), AValue, NParams - 1);
          Exit;
        end;
      end;
    end;

    Exit;
  end;

  with TPAXBaseScripter(SO.ClassRec.Scripter) do
  begin
    if SymbolTable.Kind[WriteID] = KindSUB then
    begin
      V := ScriptObjectToVariant(SO);
      SymbolTable.SaveState;
      SubID := SymbolTable.AppReference(V, SymbolTable.NameIndex[WriteID], maAny);
      Code.EvalSetProcedure(SubID, NParams, AValue);
      SymbolTable.RestoreState;
      Exit;
    end;

    P := SO.PropertyList.FindProperty(SymbolTable.NameIndex[WriteID]);
    if P = nil then
      raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [SymbolTable.Name[WriteID]]));

    P.fValue^ := AValue;
  end;
end;

function TPAXProperty.IsImported: Boolean;
begin
  result := Definition <> nil;
end;

function TPAXProperty.IsStatic: Boolean;
begin
  result := false;
  if MemberRec <> nil then
    result := modStatic in MemberRec.ml;
end;

function TPAXProperty.Definition: TPAXDefinition;
begin
  if MemberRec = nil then
  begin
    result := nil;
    Exit;
  end;

  result := MemberRec.Definition;

  if ExtraDef <> nil then
    result := ExtraDef;
end;

function TPAXProperty.GetReadID: Integer;
begin
  if MemberRec = nil then
  begin
    result := 0;
    Exit;
  end;

  result := MemberRec.ReadID;
end;

function TPAXProperty.GetWriteID: Integer;
begin
  if MemberRec = nil then
  begin
    result := 0;
    Exit;
  end;

  result := MemberRec.WriteID;
end;

constructor TPAXPropertyList.Create(Scripter: Pointer);
begin
  Self.Scripter := Scripter;
  inherited Create;
end;

function TPAXPropertyList.GetProperty(I: Integer): TPAXProperty;
begin
  result := TPAXProperty(Objects[I]);
end;

function TPAXPropertyList.GetName(I: Integer): String;
var
  NameIndex: Integer;
begin
  NameIndex := NameID[I];
  result := _GetName(NameIndex, Scripter);
end;

function TPAXPropertyList.FindProperty(PropertyNameIndex: Integer): TPAXProperty;
var
  I, UpCaseIndex: Integer;
  P: TPAXProperty;
begin
  result := TPAXProperty(GetObject(PropertyNameIndex));

  if result = nil then
  begin
    UpCaseIndex := NameIndexToUpperCaseIndex(PropertyNameIndex, Scripter);
    for I:=0 to Count - 1 do
    begin
      P := Properties[I];
      if P.UpCaseIndex = UpCaseIndex then
      begin
        result := P;
        Exit;
      end;
    end;
  end;
end;

function TPAXPropertyList.GetDefaultProperty: TPAXProperty;
var
  I: Integer;
begin
  result := nil;
  for I:=0 to Count - 1 do
    with TPAXProperty(Objects[I]) do
      if MemberRec <> nil then
        if modDEFAULT in MemberRec.ml then
        begin
          result := Properties[I];
          Exit;
        end;
end;

constructor TPAXScriptObject.Create(ClassRec: TPAXClassRec);
begin
  inherited Create;

  Inc(TPAXBaseScripter(ClassRec.Scripter)._ObjCount);
  _ObjCount := TPAXBaseScripter(ClassRec.Scripter)._ObjCount;

  Self.ClassRec := ClassRec;

  PropertyList := TPAXPropertyList.Create(ClassRec.Scripter);

  Instance := nil;
  PClass := nil;
  RefCount := 0;
  IsClass := false;
  ExtraPtr := nil;
  ExtraPtrSize := 0;
  ExternalExtraPtr := false;
  Intf := nil;
  PIntf := nil;

{$IFDEF WIN32}
  ThreadID := GetCurrentThreadID();
{$ELSE}
  ThreadID := 0;
{$ENDIF}

  TPAXBaseScripter(ClassRec.Scripter).ScriptObjectList.Add(Self);
  HasFordiddenProperties := (TPaxBaseScripter(Scripter).ForbiddenPublishedProperties.Count > 0) or
                            (TPaxBaseScripter(Scripter).ForbiddenPublishedPropertiesEx.Count > 0); 
end;

procedure TPAXScriptObject.CallAutoDestructor;
begin
  Pointer(Intf) := nil;

  if ClassRec = nil then
    Exit;
  if ClassRec.AutoDestructorID = 0 then
    Exit;

//  TPAXBaseScripter(Scripter).CallMethod(ClassRec.AutoDestructorID,
//    ScriptObjectToVariant(Self), []);
end;

function TPAXScriptObject.ExtraInstance: TObject;
begin
  result := Instance;
end;

function TPAXScriptObject.GetPropertyName(Index: Integer): String;
var
  NameIndex: Integer;
begin
  with PropertyList do
    if (Index >= 0) and (Index < Count) then
    begin
      NameIndex := NameID[Index];
      result := _GetName(NameIndex, Scripter)
    end
    else
      result := '';
end;

procedure TPAXScriptObject.SetDefaultValue(const V: Variant);
begin
end;

function TPAXScriptObject.DefaultValue: Variant;
begin
  result := Undefined;
end;

procedure TPAXScriptObject.FreeExtraPtr;
var
  D: TPaxClassDefinition;
  P: Pointer;
begin
  if ExtraPtr = nil then
    Exit;
  if ExternalExtraPtr then
    Exit;

  if ExtraPtrSize > 0 then
  begin
    if ClassRec.ck = ckDynamicArray then
      ExtraPtr := ShiftPointer(ExtraPtr, - SizeOf(Pointer) - SizeOf(Pointer));
    FreeMem(ExtraPtr, ExtraPtrSize);
    Exit;
  end
  else if ExtraPtrSize < 0 then
  begin
    P := ShiftPointer(ExtraPtr, ExtraPtrSize);
    FreeMem(P, - ExtraPtrSize);
  end;

  D := GetClassDef;
  if D = nil then
    Exit;

  if D.ClassKind <> ckDynamicArray then
     Exit;
end;

destructor TPAXScriptObject.Destroy;
begin
  PropertyList.Free;

  if (Assigned(Instance) and (ClassRec.ck = ckArray)) then
  begin
    Instance.Free;
    Instance := nil;
  end;

  FreeExtraPtr;

  inherited;
end;

function TPAXScriptObject.Scripter: Pointer;
begin
  result := ClassRec.Scripter;
end;

function TPAXScriptObject.IsImported: Boolean;
begin
  if ClassRec = nil then
    result := false
  else
    result := ClassRec.IsImported;
end;

function TPAXScriptObject.GetClassDef: TPAXClassDefinition;
begin
  if not IsImported then
  begin
    result := nil;
    Exit;
  end;
  result := ClassRec.GetClassDef;
end;


procedure TPAXScriptObject.PutPublishedProperty(const PropertyName: String; const Value: Variant);
var
  PropInfo: PPropInfo;
  I: Integer;
  M: TMethod;
  pti, pti1: PTypeInfo;
  ptd: PTypeData;
  EnumName, S: String;
  SO: TPAXScriptObject;
  EventHandler: TPAXEventHandler;
  SubID: Integer;
  This: Variant;
  ByteSet: TByteSet;
begin
  if HasFordiddenProperties then
    if TPaxBaseScripter(Scripter).HasForbiddenPublishedProperty(Instance.ClassType, PropertyName) then
      raise TPAXScriptFailure.Create(Format(errPropertyNotFoundInClass, [PropertyName, Instance.ClassName]));

  pti := PTypeInfo(Instance.ClassType.ClassInfo);

  if pti = nil then
    PropInfo := nil
  else
    PropInfo := GetPropInfo(pti, PropertyName);

  if PropInfo <> nil then
  begin
{$ifdef fp}
    pti1 := PropInfo.PropType;
{$else}
    pti1 := PropInfo.PropType^;
{$endif}
    case pti1^.Kind of
      tkInteger, tkChar, tkWChar:
        SetOrdProp(Instance, PropInfo, TVarData(Value).VInteger);
      tkClass:
        SetOrdProp(Instance, PropInfo, Integer(VariantToScriptObject(Value).Instance));
      tkEnumeration:
      begin
        case VarType(Value) of
          varString:
          begin
{$ifdef fp}
            pti := PropInfo.PropType;
{$else}
            pti := PropInfo.PropType^;
{$endif}
            ptd := GetTypeData(pti);
            S := ToStr(Scripter, Value);
            with ptd^ do
              for I:= MinValue to MaxValue do
              begin
                EnumName := GetEnumName(pti, I);
                if StrEql(S, EnumName) then
                begin
                  SetOrdProp(Instance, PropInfo, I);
                  Break;
                end;
              end;
          end;
          varBoolean:
          begin
            if TVarData(Value).VInteger <> 0 then
              SetOrdProp(Instance, PropInfo, Ord(True))
            else
              SetOrdProp(Instance, PropInfo, 0);
          end;
        else
          SetOrdProp(Instance, PropInfo, TVarData(Value).VInteger);
        end;
      end;
      tkFloat:
        SetFloatProp(Instance, PropInfo, Value);
      tkString, tkLString, tkWString:
        case TVarData(Value).VType of
          varInteger: SetStrProp(Instance, PropInfo, Chr(TVarData(Value).VInteger));
          varString: SetStrProp(Instance, PropInfo, String(TVarData(Value).VString));
        else
          SetStrProp(Instance, PropInfo, ToStr(Scripter, Value));
        end;
      tkVariant:
        SetVariantProp(Instance, PropInfo, GetTerminal(@Value)^);
      tkSet:
      begin
        ByteSet := PaxArrayToByteSet(Value);
        I := 0;
        Move(ByteSet, I, SizeOf(ByteSet));
        SetOrdProp(Instance, PropInfo, I);
      end;
      tkMethod:
      begin
        M := GetMethodProp(Instance, PropInfo);

        if IsUndefined(Value) then
        begin
          M.Code := nil;
          M.Data := nil;
          SetMethodProp(Instance, PropInfo, M);
          Exit;
        end;

        SO := VariantToScriptObject(Value);

        if SO.ClassRec.AncestorName = 'Function' then
          SubID := SO.ClassRec.GetConstructorID
        else
          SubID := TPAXDelegate(SO.Instance).SubID;
        This := ScriptObjectToVariant(Self);
{$ifdef fp}
        EventHandler := TPAXEventHandler.Create(Scripter, @PropInfo.PropType, SubID, This);
{$else}
        EventHandler := TPAXEventHandler.Create(Scripter, PropInfo.PropType^, SubID, This);
{$endif}
        EventHandler.HostHandler := M;
        EventHandler.OverrideHandlerMode := TPaxBaseScripter(Scripter).OverrideHandlerMode;

        M.Code := @TPAXEventHandler.HandleEvent;
        M.Data := Pointer(EventHandler);
        TPAXBaseScripter(Scripter).EventHandlerList.Add(EventHandler);
        SetMethodProp(Instance, PropInfo, M);

        EventHandler.DelphiInstance := Instance;
        EventHandler.PropInfo := PropInfo;

        EventHandler.This := TPAXBaseScripter(Scripter).Code._This;

        if IsUndefined(EventHandler.This) then
        begin
          SubID := TPAXBaseScripter(Scripter).Code.LevelStack.Top;
          with TPAXBaseScripter(Scripter).SymbolTable do
            EventHandler.This := GetVariant(GetThisID(SubID));
        end;
      end;
    end
  end
  else
  begin
    raise TPAXScriptFailure.Create(Format(errPropertyIsNotFoundInClass, [PropertyName, Instance.ClassName]));
  end;
end;

function TPAXScriptObject.GetPublishedProperty(const PropertyName: String; NParams: Integer): Variant;
var
  PropInfo: PPropInfo;
  S: String;
  I: Integer;
  TypeData: PTypeData;
  pti, pti1: PTypeInfo;
  C: TComponent;
  X: ActiveXObject;
  Indexes: array of Integer;
  V: Variant;
  P: Pointer;
  This: Variant;
  Def: TPAXMethodDefinition;
  ByteSet: TByteSet;
{$IFNDEF VARIANTS}
  D: Double;
{$ENDIF}
begin
  if HasFordiddenProperties then
    if TPaxBaseScripter(Scripter).HasForbiddenPublishedProperty(Instance.ClassType, PropertyName) then
      raise TPAXScriptFailure.Create(Format(errPropertyIsNotFoundInClass, [PropertyName, Instance.ClassName]));

  pti := PTypeInfo(Instance.ClassType.ClassInfo);
  if pti = nil then
    PropInfo := nil
  else
    PropInfo := GetPropInfo(pti, PropertyName);

  if PropInfo <> nil then
  begin
{$ifdef fp}

    TypeData := GetTypeData(PropInfo^.PropType);
    pti1 := PropInfo.PropType;
{$else}
    TypeData := GetTypeData(PropInfo^.PropType^);
    pti1 := PropInfo.PropType^;
{$endif}

    // return the right type

    case pti1^.Kind of
      tkInteger: result := GetOrdProp(Instance, PropInfo);
      tkInt64:
      begin
        {$IFDEF VARIANTS}
        result := GetInt64Prop(Instance, PropInfo);
        {$ELSE}
        D := GetInt64Prop(Instance, PropInfo);
        result := D;
        {$ENDIF}
      end;
      tkFloat: result := GetFloatProp(Instance, PropInfo);
      tkEnumeration:
{$ifdef fp}
        if TypeData^.BaseType = TypeInfo(Boolean) then
{$else}
        if TypeData^.BaseType^ = TypeInfo(Boolean) then
{$Endif}
          result := Boolean(GetOrdProp(Instance, PropInfo))
        else
        begin
          result := GetOrdProp(Instance, PropInfo);
{
          I := GetOrdProp(Instance, PropInfo);
          result := GetEnumName(PropInfo^.PropType^, I); }
        end;
      tkSet:
      begin
        I := GetOrdProp(Instance, PropInfo);
        ByteSet := [];
        Move(I, ByteSet, SizeOf(ByteSet));
        result := ByteSetToPaxArray(ByteSet, Scripter);
      end;
      tkClass:
      begin
        I := GetOrdProp(Instance, PropInfo);
        if I <> 0 then
        begin
          result := ScriptObjectToVariant(DelphiInstanceToScriptObject(TObject(I), Scripter));
        end;
      end;
      tkChar:
      begin
        S := Chr(GetOrdProp(Instance, PropInfo));
        result := S;
      end;
      tkString, tkLString, tkWString:
      begin
        S := GetStrProp(Instance, PropInfo);
        result := S;
      end;
      tkVariant:
      begin
        result := GetVariantProp(Instance, PropInfo);

        if VarType(result) = varDispatch then
        begin
          X := ActiveXObject.Create(Scripter);
          X.D := result;
          result := ScriptObjectToVariant(DelphiInstanceToScriptObject(X, Scripter));
        end
        else
        if (VarType(result) >= varArray) and (Nparams > 0) then
        begin
          SetLength(Indexes, NParams);
          for I:=1 to NParams do
            Indexes[NParams - I] := TPAXBaseScripter(Scripter).Code.PopVariant;
          V := Variant(ArrayGet(@result, Indexes)^);
          result := V;
        end;
      end;
    end;
  end
  else
  begin
    if Instance.InheritsFrom(TComponent) then
    begin
      C := TComponent(Instance);
      for I:=0 to C.ComponentCount - 1 do
        if StrEql(C.Components[I].Name, PropertyName) then
        begin
          result := ScriptObjectToVariant(DelphiInstanceToScriptObject(C.Components[I], Scripter));
          Exit;
        end;
    end;

    P := Instance.MethodAddress(PropertyName);
    if P <> nil then
    begin
      Def := TPaxMethodDefinition.Create(DefinitionList, '', nil, -1, nil, true);

      try
        with Def do
        begin
          DirectProc := P;
          SetLength(Types, NParams + 1);
          SetLength(ExtraTypes, NParams + 1);
          SetLength(ByRefs, NParams + 1);
          for I:=0 to NParams do
          begin
            Types[I] := typeVOID;
            ByRefs[I] := false;
          end;
        end;

        This := ScriptObjectToVariant(DelphiInstanceToScriptObject(Instance, Scripter));
        TPAXBaseScripter(Scripter).Code.CallHostSub(Def, @This, @Result, NParams);
      finally
        Def.Free;
      end;
      Exit;
    end;

    raise TPAXScriptFailure.Create(Format(errPropertyIsNotFoundInClass, [PropertyName, Instance.ClassName]));
  end;
end;

function TPAXScriptObject.HasProperty(const PropertyName: String): Boolean;
var
  P: TPAXProperty;
begin
  P := PropertyList.FindProperty(CreateNameIndex(PropertyName, Scripter));
  if P = nil then
    result := HasPublishedProperty(PropertyName)
  else
    result := true;
end;

function TPAXScriptObject.HasPublishedProperty(const PropertyName: String): Boolean;
var
  PropInfo: PPropInfo;
  pti: PTypeInfo;
  C: TComponent;
  I: Integer;
begin
  result := false;

  if Instance = nil then
    Exit;

  if HasFordiddenProperties then
    if TPaxBaseScripter(Scripter).HasForbiddenPublishedProperty(Instance.ClassType, PropertyName) then
       Exit;

  if Instance.MethodAddress(PropertyName) <> nil then
  begin
    result := true;
    Exit;
  end;

  pti := PTypeInfo(Instance.ClassType.ClassInfo);
  if pti = nil then
    Exit;
  PropInfo := GetPropInfo(pti, PropertyName);
  if PropInfo <> nil then
  begin
    result := true;
    Exit;
  end;
  if Instance.InheritsFrom(TComponent) then
  begin
    C := TComponent(Instance);
    for I:=0 to C.ComponentCount - 1 do
      if StrEql(C.Components[I].Name, PropertyName) then
      begin
        result := true;
        Exit;
      end;
  end;
end;

function TPAXScriptObject.Get(PropertyNameIndex: Integer): TPAXProperty;
begin
  result := PropertyList.FindProperty(PropertyNameIndex);
  if result = nil then
  begin
    TPaxBaseScripter(Scripter).Dump;
    raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound,
        [_GetName(PropertyNameIndex, Scripter)]));
  end;
end;

function TPAXScriptObject.SafeGet(PropertyNameIndex: Integer): TPAXProperty;
begin
  result := PropertyList.FindProperty(PropertyNameIndex);
end;

function TPAXScriptObject.Put(PropertyNameIndex: Integer;
                           const Value: Variant; NParams: Integer): TPAXProperty;
var
  S: String;
  V: Variant;
  D: TPAXMethodDefinition;
  MemberRec: TPaxMemberRec;
begin
  result := PropertyList.FindProperty(PropertyNameIndex);
  if result <> nil then
  begin
    if result.MemberRec <> nil then
      if result.MemberRec.IsPublished then
      begin
        S := _GetName(PropertyNameIndex, Scripter);
        PutPublishedProperty(S, Value);
        Exit;
      end;

    result.PutValue(NParams, Value);
    Exit;
  end;
  if IsImported then
  begin
    S := _GetName(PropertyNameIndex, Scripter);
    if HasPublishedProperty(S) then
      PutPublishedProperty(S, Value)
    else if ClassDef.PutPropDef <> nil then
    begin
      D := ClassDef.PutPropDef;
      D.Name := S;
      with TPAXBaseScripter(ClassRec.Scripter) do
      begin
//        if ClassRec.AncestorName = 'Function' then
//          Instance := Self;

        V := ScriptObjectToVariant(Self);
        Code.SaveState;
        Code.Stack.Push(Integer(@Value));
        Code.CallHostSub(D, @V, nil, NParams + 1);
        Code.RestoreState;
      end;
      D.Name := '';
    end
    else
      Get(PropertyNameIndex); // exception
  end
  else
  begin
    MemberRec := ClassRec.FindMember(PropertyNameIndex, maAny, true);
    if MemberRec = nil then
      Get(PropertyNameIndex) // exception
    else
    begin
      result := CreateProperty(PropertyNameIndex,
                               TPAXBaseScripter(ClassRec.Scripter).SymbolTable.Address[MemberRec.Id],
                               MemberRec);
      while (NParams > 0) do
      begin
        TPAXBaseScripter(ClassRec.Scripter).Code.PopVariant;
        Dec(NParams);      
      end;
    end;
  end;
end;

function TPAXScriptObject.GetProperty(PropertyNameIndex: Integer;
                                      NParams: Integer): Variant;
var
  P: TPAXProperty;
  S: String;
  D: TPAXMethodDefinition;
  V: Variant;
  MemberRec: TPaxMemberRec;
begin
  P := PropertyList.FindProperty(PropertyNameIndex);
  if P <> nil then
  begin
    if P.MemberRec <> nil then
      if P.MemberRec.IsPublished then
      begin
        S := _GetName(PropertyNameIndex, Scripter);
        result := GetPublishedProperty(S, NParams);
        Exit;
      end;

    result := P.GetValue(NParams);
    Exit;
  end;
  if IsImported then
  begin
    S := _GetName(PropertyNameIndex, Scripter);
    if HasPublishedProperty(S) then
      result := GetPublishedProperty(S, NParams)
    else if ClassDef.GetPropDef <> nil then
    begin
//      if ClassRec.AncestorName = 'Function' then
//        Instance := Self;

      D := ClassDef.GetPropDef;
      D.Name := S;
      with TPAXBaseScripter(ClassRec.Scripter) do
      begin
        V := ScriptObjectToVariant(Self);
        Code.SaveState;
        Code.CallHostSub(D, @V, @result, NParams);
        Code.RestoreState;
      end;
      D.Name := '';
    end
    else
      Get(PropertyNameIndex); // exception
  end
  else
  begin
    if SignLoadOnDemand then
    begin
      MemberRec := ClassRec.GetMember(PropertyNameIndex);
      if MemberRec <> nil then
      begin
        result := TPAXBaseScripter(ClassRec.Scripter).SymbolTable.GetVariant(MemberRec.Id);
        Exit;
      end;
    end;

    Get(PropertyNameIndex); // exception
  end;
end;

procedure TPAXScriptObject.ClearProperty(PropertyNameIndex: Integer);
var
  P: TPAXProperty;
begin
  P := PropertyList.FindProperty(PropertyNameIndex);
  if P <> nil then
    VarClear(P.fValue^);
end;

function TPAXScriptObject.GetAddress(PropertyNameIndex: Integer;
                                     NParams: Integer): PVariant;
var
  P: TPAXProperty;
  S: String;
  D: TPAXMethodDefinition;
  V: Variant;
  MemberRec: TPaxMemberRec;
begin
  result := nil;
  P := PropertyList.FindProperty(PropertyNameIndex);
  if P <> nil then
  begin
    if P.MemberRec <> nil then
      if P.MemberRec.IsPublished then
      begin
        result := nil;
//        raise TPaxScriptFailure.Create(errOperatorNotApplicable);
        Exit;
      end;

    result := P.GetAddress(NParams);
    Exit;
  end;
  if IsImported then
  begin
    S := _GetName(PropertyNameIndex, Scripter);
    if HasPublishedProperty(S) then
      result := nil
    else if ClassDef.GetPropDef <> nil then
    begin
      D := ClassDef.GetPropDef;
      D.Name := S;
      with TPAXBaseScripter(ClassRec.Scripter) do
      begin
        V := ScriptObjectToVariant(Self);
        Code.SaveState;
        Code.CallHostSub(D, @V, @TempVariant, NParams);
        Code.RestoreState;

        result := @TempVariant;
      end;
      D.Name := '';
    end
    else
      Get(PropertyNameIndex); // exception
  end
  else
  begin
    if SignLoadOnDemand then
    begin
      MemberRec := ClassRec.GetMember(PropertyNameIndex);
      if MemberRec <> nil then
      begin
        result := TPAXBaseScripter(ClassRec.Scripter).SymbolTable.Address[MemberRec.Id];
        Exit;
      end;
    end;

    Get(PropertyNameIndex); // exception
  end;
end;

procedure TPAXScriptObject.PutProperty(PropertyNameIndex: Integer;
                                    const Value: Variant; NParams: Integer);
begin
  Put(PropertyNameIndex, Value, NParams);
end;

function TPAXScriptObject.GetDefaultProperty(NParams: Integer): Variant;
var
  P: TPAXProperty;
begin
  P := PropertyList.GetDefaultProperty;
  if P = nil then
  begin
    raise TPAXScriptFailure.Create(errDefaultPropertyIsNotFound);
   end;
  result := P.GetValue(NParams);
end;

procedure TPAXScriptObject.PutDefaultProperty(const Value: Variant; NParams: Integer);
var
  P: TPAXProperty;
begin
  P := PropertyList.GetDefaultProperty;
  if P = nil then
    raise TPAXScriptFailure.Create(errDefaultPropertyIsNotFound);
  P.PutValue(NParams, Value);
end;

function TPAXScriptObject.CreateProperty(PropertyNameIndex: Integer;
                                         PValue: PVariant;
                                         MemberRec: TPAXMemberRec): TPAXProperty;
var
  I: Integer;
begin
  I := PropertyList.IndexOf(PropertyNameIndex);
  if I <> -1 then
  begin
    result := PropertyList.Properties[I];
    Exit;
  end;

  result := TPAXProperty.Create(Self, PValue, MemberRec);
  PropertyList.AddObject(PropertyNameIndex, result);
end;

function TPAXScriptObject.Duplicate: TPAXScriptObject;
var
  I, PropertyNameIndex: Integer;
  SourceProperty, DestProperty: TPAXProperty;
  P: PVariant;
  SO: TPAXScriptObject;
  V: Variant;
begin
  result := TPAXScriptObject.Create(ClassRec);
  result.RefCount := 1;

  if Instance = nil then
    result.Instance := Instance;

  result.PClass := PClass;

  if ExtraPtrSize > 0 then
  begin
    result.ExtraPtrSize := ExtraPtrSize;
    result.ExtraPtr := AllocMem(ExtraPtrSize);
    Move(ExtraPtr^, result.ExtraPtr^, ExtraPtrSize);
  end;

  for I:=0 to PropertyList.Count - 1 do
  begin
    PropertyNameIndex := Integer(PropertyList[I]);

    SourceProperty := TPAXProperty(PropertyList.Objects[I]);

    if not SourceProperty.IsStatic then
    begin
      P := SourceProperty.fValue;

      if P <> nil then
        if IsPaxArray(P^) then
        begin
          SO := VariantToScriptObject(P^);
          V := (SO.Instance as TPaxArray).Duplicate;
          P := @V;
        end
        else if IsObject(P^) then
        begin
          SO := VariantToScriptObject(P^);
          SO := SO.Duplicate;
          V := ScriptObjectToVariant(SO);
          P := @V;
        end;
      DestProperty := TPAXProperty.Create(result, P, SourceProperty.MemberRec);
      result.PropertyList.AddObject(PropertyNameIndex, DestProperty);
    end;
  end;
end;

function TPAXScriptObject.ToString: String;
var
  I, K, T, L: Integer;
  P: TPAXProperty;
  LPtr, CurrPtr: Pointer;
  V: Variant;
  D: TPaxClassDefinition;
begin
  if ClassRec <> nil then
    if ClassRec.ck = ckArray then
    begin
       if Instance <> nil then
       begin
         result := TPAXArray(Instance).ToString;
         Exit;
       end;
    end
    else if ClassRec.ck = ckDynamicArray then
    begin
      LPtr := ExtraPtr;
      if LPtr = nil then
      begin
        result := '()';
        Exit;
      end
      else
      begin
        LPtr := ShiftPointer(LPtr, - SizeOf(Integer));
        L := Integer(LPtr^);
        if L = 0 then
        begin
          result := '()';
          Exit;
        end;
        D := ClassRec.GetClassDef;
        if D = nil then
        begin
          result := '()';
          Exit;
        end;
        if D.ElSize = _SizeVariant then
        begin
          result := '(';
          CurrPtr := ExtraPtr;
          for I := 0 to L - 1 do
          begin
            result := result + ToStr(Scripter, Variant(CurrPtr^));
            if I <> L - 1 then
              result := result + ',';
            Inc(Integer(CurrPtr), _SizeVariant);
          end;
          result := result + ')';
        end
        else
        begin
          result := '(';
          for I := 0 to L - 1 do
          begin
            CurrPtr := ShiftPointer(ExtraPtr, I * D.ElSize);
            result := result + ToStr(Scripter, GetVariantValue(Scripter,
                CurrPtr, D.ElType, D.ElTypeName));
            if I <> L - 1 then
              result := result + ',';
          end;
          result := result + ')';
        end;
      end;

      Exit;
    end;

  if (Instance = nil) and (PClass <> nil) then
    result := 'Class of ' + ClassRec.Name + ' = {'
  else
    result := 'Object of ' + ClassRec.Name + ' = {';

  if Instance <> nil then
  begin
    if Instance.InheritsFrom(TPAXScriptObject) then
    begin
      V := TPAXScriptObject(Instance).DefaultValue;
      if VarType(V) <> varUndefined then
      begin
        result := ToStr(Scripter, V);
        Exit;
      end;
    end;

    if Instance.InheritsFrom(RegExp) then
    begin
      result := RegExp(Instance).toString;
      Exit;
    end;
  end;

  K := 0;
  for I:=0 to PropertyList.Count - 1 do
  begin
    P := TPAXProperty(PropertyList.Objects[I]);
    if P.MemberRec <> nil then
      if P.MemberRec.Kind in [KindVAR] then
      begin
        Inc(K);

        if P.MemberRec.ID > 0 then
        with TPaxBaseScripter(Scripter).SymbolTable do
        begin
          T := PType[P.MemberRec.ID];
          if StrEql(Name[T], ClassRec.Name) then
          begin
            result := result + 'Object of ' + ClassRec.Name;
            continue;
          end;
        end;

        result := result + ToStr(Scripter, P.Value[0]) + ',';
      end;
  end;

  if K = 0 then
    result := result + '}'
  else
    result := Copy(result, 1, Length(result) - 1) + ')';
end;

constructor TPAXMemberRec.Create(ID: Integer; ClassRec: TPAXClassRec);
begin
  Self.ID := ID;
  Self.fClassrec := ClassRec;
  ReadID := 0;
  WriteID := 0;
  InitN := 0;
  ml := [];
  Kind := 0;
  Definition := nil;
  UpCaseIndex := 0;
  IsPublished := false;
  IsSource := ID >= FirstSymbolCard;
  NParams := 0;
  IsImplementationSection := false;
end;

destructor TPAXMemberRec.Destroy;
begin
  inherited;
end;

function TPAXMemberRec.Scripter: Pointer;
begin
  result := fClassRec.Scripter;
end;

procedure TPAXMemberRec.SaveToStream(S: TStream);
begin
  SaveInteger(ID, S);
  SaveInteger(ReadID, S);
  SaveInteger(WriteID, S);
  SaveInteger(InitN, S);
  S.WriteBuffer(ml, SizeOf(ml));
  SaveInteger(Kind, S);
  SaveInteger(NParams, S);
end;

procedure TPAXMemberRec.LoadFromStream(S: TStream;
                                       DS: Integer = 0; DP: Integer = 0);
begin
  ID := LoadInteger(S);
  if ID > 0 then
    Inc(ID, DS);
  ReadID := LoadInteger(S);
  if ReadID > 0 then
    Inc(ReadID, DS);
  WriteID := LoadInteger(S);
  if WriteID > 0 then
    Inc(WriteID, DS);
  InitN := LoadInteger(S);
  if InitN > 0 then
    Inc(InitN, DP);
  S.ReadBuffer(ml, SizeOf(ml));
  Kind := LoadInteger(S);
  NParams := LoadInteger(S);

  UpCaseIndex := NameIndexToUpperCaseIndex(GetNameIndex, Scripter);
end;

procedure TPAXMemberRec.CheckAccess;
var
  _ClassID, _SubID, L, I, T: Integer;
  Found: Boolean;
  TempClassRec: TPAXClassRec;
begin
  if ID = 0 then
    Exit;
  if fClassRec = nil then
    Exit;
  if not (modPRIVATE in ml) then
    Exit;
  Found := false;
  with TPAXBaseScripter(fClassRec.Scripter) do
  begin
    if fClassRec.ClassID = SymbolTable.RootNamespaceID then
      Exit;

    if State = _ssRunning then
    begin
      _ClassID := fClassRec.ClassID;
      with Code do
        for I:=1 to LevelStack.Card do
        if LevelStack[I] <> 0 then
        begin
          _SubID := LevelStack.fItems[I];
          L := SymbolTable.Level[_SubID];
          if L = 0 then
            Continue;
          if L = _ClassID then
          begin
            Found := true;
            Break;
          end;
          TempClassRec := TPAXBaseScripter(fClassRec.Scripter).ClassList.FindClass(L);
          if TempClassRec.InheritsFromClass(_ClassID) then
          begin
            Found := true;
            Break;
          end;
        end;
    end;
  end;
  if not Found then
  begin
    with TPAXBaseScripter(fClassRec.Scripter).SymbolTable do
    begin
      T := PType[ID];
      if T > PAXTypes.Count then
        if Kind[T] <> KindType then
        begin
          with TPAXBaseScripter(fClassRec.Scripter).Code do
          begin
            N := FindCreateObjectStmt(T);
          end;
          raise TPAXScriptFailure.Create(Format(errUndeclaredIdentifier, [Name[T]]));
        end;
    end;
//  raise TPAXScriptFailure.Create(Format(errNotAccessToPrivateMember, [GetName, fClassRec.Name]));
  end;
end;

function TPAXMemberRec.GetName: String;
begin
  if fClassRec = nil then
    result := ''
  else
    result := TPAXBaseScripter(fClassRec.Scripter).SymbolTable.Name[ID];
end;

function TPAXMemberRec.GetNameIndex: Integer;
begin
  if fClassRec = nil then
    result := 0
  else
    result := TPAXBaseScripter(fClassRec.Scripter).SymbolTable.NameIndex[ID];
end;

function TPAXMemberRec.IsStatic: Boolean;
begin
  result := modSTATIC in ml;
end;

function TPAXMemberRec.IsDefault: Boolean;
begin
  result := modDEFAULT in ml;
end;

function TPAXMemberRec.IsImported: Boolean;
begin
  result := (Definition <> nil);
end;

function TPAXMemberRec.IsImportedObject: Boolean;
begin
  result := IsImported;
  if result then
    result := Definition.DefKind = dkObject;
end;

constructor TPAXClassRec.Create(AScripter: Pointer; kc: TPAXClassKind);
begin
  inherited Create;
  Scripter := AScripter;
  Self.ck := ck;
  MemberList := TPAXMemberList.Create(Self);
  fClassDef := nil;
  OwnerClassRec := nil;
  AncestorClassRec := nil;
  NameIdx := 0;
  UpCaseIndex := 0;
  UsingInitList := TPaxIDs.Create(false);
  AutoDestructorID := 0;
  IsSet := false;
  PtiSet := nil;
  fHasRunTimeProperties := false;
end;

function TPaxClassRec.HasRunTimeProperties: Boolean;
var
  C: TPaxClassRec;
begin
  result := fHasRunTimeProperties;
  if not result then
    if AncestorName <> '' then
    begin
      C := TPaxBaseScripter(Scripter).ClassList.FindClassByName(AncestorName);
      if C <> nil then
        result := C.HasRunTimeProperties;
    end;
end;

destructor TPAXClassRec.Destroy;
begin
  MemberList.Free;
  UsingInitList.Free;

  inherited;
end;

function TPAXClassRec.FindBinaryOperatorID(const OperName: String; T1, T2: Integer): Integer;
var
  I, SubID, ParamID1, ParamID2, TypeID1, TypeID2: Integer;
  SymbolTable: TPAXSymbolTable;
  NameIndex: Integer;
  TempID: Integer;
begin
  NameIndex := CreateNameIndex(OperName, Scripter);
  TempID := 0;
  SymbolTable := TPAXBaseScripter(Scripter).SymbolTable;

  for I:=MemberList.Count - 1 downto 0 do
  if MemberList[I].Kind = KindSUB then
  if MemberList.NameID[I] = NameIndex then
  begin
    SubID := MemberList[I].ID;
    if SubID > 0 then
      if SymbolTable.Count[SubID] = 2 then
      begin
        ParamID1 := SymbolTable.GetParamID(SubID, 1);
        ParamID2 := SymbolTable.GetParamID(SubID, 2);
        TypeID1 := SymbolTable.PType[ParamID1];
        TypeID2 := SymbolTable.PType[ParamID2];

        with TPAXBaseScripter(Scripter) do
        if MatchAssignmentStrict(TypeID1, T1) and MatchAssignmentStrict(TypeID2, T2) then
        begin
          TempID := SubID;
          if (TypeID1 = T1) and (TypeID2 = T2) then
            break;
        end;
      end;
  end;
  result := TempID;
end;

function TPAXClassRec.FindUnaryOperatorID(const OperName: String; T: Integer): Integer;
var
  I, SubID, ID: Integer;
  SymbolTable: TPAXSymbolTable;
  NameIndex: Integer;
begin
  NameIndex := CreateNameIndex(OperName, Scripter);
  result := 0;
  SymbolTable := TPAXBaseScripter(Scripter).SymbolTable;

  for I:=MemberList.Count - 1 downto 0 do
  if MemberList[I].Kind = KindSUB then
  if MemberList.NameID[I] = NameIndex then
  begin
    SubID := MemberList[I].ID;
    if SubID > 0 then
      if SymbolTable.Count[SubID] = 1 then
      begin
        ID := SymbolTable.GetParamID(SubID, 1);
        if (SymbolTable.PType[ID] = T) then
        begin
          result := SubID;
          Exit;
        end;
      end;
  end;
end;

function TPAXClassRec.IsStatic: Boolean;
begin
  result := modSTATIC in ml;
end;

function TPAXClassRec.ModuleName: String;
begin
  with TPAXBaseScripter(Scripter) do
    if (ModuleID >= 0) and (ModuleID < Modules.Count - 1) then
      result := Modules[ModuleID];
end;

function TPAXClassRec.GetClassList: TPAXClassList;
begin
  result := TPAXBaseScripter(Scripter).ClassList;
end;

procedure TPAXClassRec.ResetCompileStage;
var
  I: Integer;
begin
  for I:=MemberList.Count - 1 downto 0 do
    if MemberList[I].IsSource or (MemberList[I].ID > FirstSymbolCard) then
      MemberList.DeleteObject(I);
  UsingInitList.Clear;
end;

procedure TPAXClassRec.SaveToStream(S: TStream);
begin
  SaveString(Name, S);
  SaveString(OwnerName, S);
  SaveString(AncestorName, S);

  SaveInteger(ClassID, S);
  SaveInteger(ModuleID, S);
  SaveInteger(AutoDestructorID, S);

  S.WriteBuffer(ck, SizeOf(ck));

  MemberList.SaveToStream(S);
  UsingInitList.SaveToStream(S);
end;

procedure TPAXClassRec.LoadFromStream(S: TStream;
                                      DS: Integer = 0; DP: Integer = 0);
var
  I: Integer;
begin
  Name := LoadString(S);
  OwnerName := LoadString(S);
  AncestorName := LoadString(S);

  ClassID := LoadInteger(S);
  if ClassID > 0 then
    Inc(ClassID, DS);

  ModuleID := LoadInteger(S);

  AutoDestructorID := LoadInteger(S);
  if AutoDestructorID > 0 then
    Inc(AutoDestructorID, DS);

  S.ReadBuffer(ck, SizeOf(ck));

  MemberList.LoadFromStream(S, DS, DP);
  UsingInitList.LoadFromStream(S);
  if DP <> 0 then
    for I:=0 to UsingInitList.Count - 1 do
      if UsingInitList[I] > 0 then
        UsingInitList[I] := UsingInitList[I] + DP;

  NameIdx := CreateNameIndex(Name, Scripter);
  UpCaseIndex :=NameIndexToUpperCaseIndex(NameIdx, Scripter);
end;

function TPAXClassRec.InheritsFromClass(AClassID: Integer): Boolean;
var
  P: TPAXClassRec;
begin
  if ClassID = AClassID then
  begin
    result := true;
    Exit;
  end;
  result := false;
  P := AncestorClassRec;
  while P <> nil do
  begin
    if P.ClassID = AClassID then
    begin
      result := true;
      Exit;
    end;
    P := P.AncestorClassRec;
  end;
end;

function TPAXClassRec.IsImported: Boolean;
begin
  result := GetClassDef <> nil;
end;

function TPaxClassRec.DelphiClass: TClass;
var
  D: TPaxClassDefinition;
begin
  result := nil;
  D := GetClassDef;
  if D = nil then
    Exit;
  result := D.PClass;
end;

function TPaxClassRec.DelphiClassEx: TClass;
var
  ClassRec: TPaxClassRec;
begin
  result := DelphiClass;
  if result = nil then if AncestorName <> '' then
  begin
    ClassRec := TPaxBaseScripter(scripter).ClassList.FindClassByName(AncestorName);
    if ClassRec = nil then
      Exit;
    result := ClassRec.DelphiClassEx;
  end;
end;

function TPaxClassRec.HasPublishedProperty(const PropertyName: String): Boolean;
var
  C: TClass;
  CR: TPaxClassRec;
begin
  result := false;
  C := DelphiClass;
  if C = nil then
  begin
    if AncestorName <> '' then
    begin
      CR := TPaxBaseScripter(Scripter).ClassList.FindClassByName(AncestorName);
      if CR <> nil then
        result := CR.HasPublishedProperty(PropertyName);
    end;
    Exit;
  end;
  result := BASE_SYS.HasPublishedProperty(C, PropertyName, Scripter);
end;

function TPaxClassRec.HasPublishedPropertyEx(const PropertyName: String; var AClassName: String): Boolean;
var
  C: TClass;
  CR: TPaxClassRec;
begin
  result := false;
  C := DelphiClass;
  if C = nil then
  begin
    if AncestorName <> '' then
    begin
      CR := TPaxBaseScripter(Scripter).ClassList.FindClassByName(AncestorName);
      if CR <> nil then
        result := CR.HasPublishedPropertyEx(PropertyName, AClassName);
    end;
    Exit;
  end;
  result := BASE_SYS.HasPublishedPropertyEx(C, PropertyName, AClassName, Scripter);
end;

function TPAXClassRec.GetClassDef: TPAXClassDefinition;
begin
  result := fClassDef;
  if result = nil then
    if AncestorClassRec <> nil then
      result := AncestorClassRec.GetClassDef;
end;

function TPAXClassRec.GetMember(MemberNameIndex: Integer; UpCaseON: Boolean = true): TPAXMemberRec;
var
  U, I: Integer;
begin
  result := TPAXMemberRec(MemberList.GetObject(MemberNameIndex));

  if result = nil then
    if UpCaseON then
    begin
      U := NameIndexToUpperCaseIndex(MemberNameIndex, Scripter);
      I := MemberList.UpperCaseIndexOf(U);
      if I >= 0 then
        result := MemberList[I];
    end;
end;

function TPAXClassRec.FindMember(MemberNameIndex: Integer;
                                 ma: TPAXMemberAccess;
                                 UpCaseON: Boolean = true): TPAXMemberRec;
begin
  result := nil;
  case ma of
    maAny:
    begin
      result := GetMember(MemberNameIndex, UpCaseON);
      if result = nil then
        if AncestorClassRec <> nil then
          result := AncestorClassRec.FindMember(MemberNameIndex, maAny, UpCaseON);
    end;
    maMyClass:
      result := GetMember(MemberNameIndex, UpCaseON);
    maMyBase:
    begin
      if AncestorClassRec <> nil then
        result := AncestorClassRec.FindMember(MemberNameIndex, maAny, UpCaseON);
    end;
  end;
end;

function TPAXClassRec.FindMemberEx(MemberNameIndex: Integer;
                                   ma: TPAXMemberAccess;
                                   var FoundInBaseClass: Boolean;
                                   UpCaseON: Boolean = true): TPAXMemberRec;
begin
  FoundInBaseClass := false;

  result := nil;
  case ma of
    maAny:
    begin
      result := GetMember(MemberNameIndex,UpCaseON);
      if result = nil then
        if AncestorClassRec <> nil then
        begin
          result := AncestorClassRec.FindMember(MemberNameIndex, maAny, UpCaseON);
          FoundInBaseClass := true;
        end;
    end;
    maMyClass:
      result := GetMember(MemberNameIndex, UpCaseON);
    maMyBase:
    begin
      if AncestorClassRec <> nil then
        result := AncestorClassRec.FindMember(MemberNameIndex, maAny, UpCaseON);
    end;
  end;
end;

procedure TPAXClassRec.DeleteMember(ID: Integer);
var
  I: Integer;
begin
  for I:=0 to MemberList.Count - 1 do
   if MemberList.Records[I].ID = ID then
   begin
     MemberList.DeleteObject(I);
     Exit;
   end;
end;

function TPAXClassRec.AddField(ID: Integer; ml: TPAXModifierList): TPAXMemberRec;
var
  NameIndex: Integer;
begin
  NameIndex := TPAXBaseScripter(Scripter).SymbolTable.NameIndex[ID];

  result := TPAXMemberRec.Create(ID, Self);
  result.ml := ml;
  result.Kind := KindVAR;

  if UpCaseIndex > 0 then
    result.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);

  MemberList.AddObject(NameIndex, result);
end;

function TPAXClassRec.AddMethod(ID: Integer; ml: TPAXModifierList): TPAXMemberRec;
var
  NameIndex: Integer;
begin
  NameIndex := TPAXBaseScripter(Scripter).SymbolTable.NameIndex[ID];

  result := TPAXMemberRec.Create(ID, Self);
  result.ml := ml;
  result.Kind := KindSUB;

  if UpCaseIndex > 0 then
    result.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);

  MemberList.AddObject(NameIndex, result);
end;

function TPAXClassRec.AddHostMethod(D: TPAXMethodDefinition): TPAXMemberRec;
var
  SubID, NameIndex: Integer;
begin
  NameIndex := CreateNameIndex(D.Name, Scripter);

  SubID := - D.Index;

  result := TPAXMemberRec.Create(SubID, Self);
  result.ml := D.ml;
  result.Kind := KindSUB;
  result.Definition := D;
  result.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);
  MemberList.AddObject(NameIndex, result);
end;

function TPAXClassRec.AddHostConstant(D: TPAXConstantDefinition): TPAXMemberRec;
var
  ID, I, NameIndex: Integer;
begin
  NameIndex := CreateNameIndex(D.Name, Scripter);

  I := MemberList.IndexOf(NameIndex);
  if I <> -1 then
    result := MemberList[I]
  else
  begin
// NWR

//  ID := - D.Index;

{    if D.DefList = DefinitionList then
      ID := TPaxBaseScripter(Scripter).SymbolTable.AppVariant(D.Index)
    else
      ID := TPaxBaseScripter(Scripter).SymbolTable.AppVariant(-D.Index);

    TPaxBaseScripter(Scripter).SymbolTable.NameIndex[ID] := NameIndex;
    TPaxBaseScripter(Scripter).SymbolTable.Kind[ID] := KindHostConst; }

    if D.DefList = DefinitionList then
      ID := - D.Index
    else
    begin
      ID := TPaxBaseScripter(Scripter).SymbolTable.LookUpId(D.Name, ClassID);
      if ID = 0 then
        ID := TPaxBaseScripter(Scripter).SymbolTable.AppVariant(-D.Index)
      else
        TPaxBaseScripter(Scripter).SymbolTable.PutVariant(ID, -D.Index);

      TPaxBaseScripter(Scripter).SymbolTable.NameIndex[ID] := NameIndex;
      TPaxBaseScripter(Scripter).SymbolTable.Kind[ID] := KindHostConst;
      TPaxBaseScripter(Scripter).SymbolTable.Imported[ID] := true;
      TPaxBaseScripter(Scripter).SymbolTable.Level[ID] := ClassID;
      TPaxBaseScripter(Scripter).SymbolTable.PType[ID] := D.TypeID;
    end;

// NWR

    result := TPAXMemberRec.Create(ID, Self);
    MemberList.AddObject(NameIndex, result);
    result.ml := D.ml;
    result.Kind := KindCONST;
    result.Definition := D;
    result.IsSource := false;
    result.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);
  end;
end;

function TPAXClassRec.AddHostVariable(D: TPAXVariableDefinition): TPAXMemberRec;
var
  ID, I, TypeId, NameIndex: Integer;
  C: TPAXClassRec;
  SO: TPaxScriptObject;
  V: Variant;
begin
  NameIndex := CreateNameIndex(D.Name, Scripter);

  I := MemberList.IndexOf(NameIndex);
  if I <> -1 then
    result := MemberList[I]
  else
  begin
// NWR
//  ID := - D.Index;

{    if D.DefList = DefinitionList then
      ID := TPaxBaseScripter(Scripter).SymbolTable.AppVariant(D.Index)
    else
      ID := TPaxBaseScripter(Scripter).SymbolTable.AppVariant(-D.Index);

    TPaxBaseScripter(Scripter).SymbolTable.NameIndex[ID] := NameIndex;
    TPaxBaseScripter(Scripter).SymbolTable.Kind[ID] := KindHostVar; }

    if D.DefList = DefinitionList then
      ID := - D.Index
    else
    begin
      ID := TPaxBaseScripter(Scripter).SymbolTable.LookUpId(D.Name, ClassID);
      if ID = 0 then
        ID := TPaxBaseScripter(Scripter).SymbolTable.AppVariant(-D.Index)
      else
        TPaxBaseScripter(Scripter).SymbolTable.PutVariant(ID, -D.Index);

      TypeID := D.TypeID;
      if TypeID = -1 then
      begin
        C := TPAXBaseScripter(Scripter).ClassList.FindClassByName(D.TypeName);
        if C <> nil then
        begin
          TypeID := C.ClassID;
          D.TypeID := typeCLASS;
        end;
      end;

      TPaxBaseScripter(Scripter).SymbolTable.NameIndex[ID] := NameIndex;
      TPaxBaseScripter(Scripter).SymbolTable.Kind[ID] := KindHostVar;
      TPaxBaseScripter(Scripter).SymbolTable.PType[ID] := TypeID;
      TPaxBaseScripter(Scripter).SymbolTable.Imported[ID] := true;
      TPaxBaseScripter(Scripter).SymbolTable.Level[ID] := ClassID;
    end;

// NWR

    result := TPAXMemberRec.Create(ID, Self);
    MemberList.AddObject(NameIndex, result);
    result.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);

    if D.TypeID = -1 then
    begin
      C := TPAXBaseScripter(Scripter).ClassList.FindClassByName(D.TypeName);
      if C <> nil then
      begin
        if C.ck = ckDynamicArray then
        begin
          SO := C.CreateScriptObject;
          SO.Instance := SO;

          if C.IsStaticArray then
            SO.ExtraPtr := Pointer(D.Address)
          else
            SO.ExtraPtr := Pointer(D.Address^);
          SO.ExternalExtraPtr := true;
          V := ScriptObjectToVariant(SO);
          result.ID := TPAXBaseScripter(Scripter).SymbolTable.AppVariant(V);
          TPAXBaseScripter(Scripter).SymbolTable.Imported[result.ID] := true;

          if D.DefList <> DefinitionList then
            TPaxBaseScripter(Scripter).SymbolTable.Name[ID] := '';

          Exit;
        end
        else if C.ck = ckStructure then
        begin
          SO := C.CreateScriptObject;
          SO.FreeExtraPtr;

          SO.Instance := SO;
          SO.ExtraPtr := D.Address;
          SO.ExternalExtraPtr := true;
          V := ScriptObjectToVariant(SO);
          result.ID := TPAXBaseScripter(Scripter).SymbolTable.AppVariant(V);
          TPAXBaseScripter(Scripter).SymbolTable.Imported[result.ID] := true;
          Exit;
        end;
      end;
    end;

    result.ml := D.ml;
    result.Kind := KindVAR;
    result.Definition := D;
    result.IsSource := false;
  end;
end;

function TPAXClassRec.AddHostObject(D: TPAXObjectDefinition): TPAXMemberRec;
var
  ID, NameIndex, I: Integer;
  SO: TPAXScriptObject;
  ClassRec: TPaxClassRec;
begin
  NameIndex := CreateNameIndex(D.Name, Scripter);

  I := MemberList.IndexOf(NameIndex);
  if I <> -1 then
    result := MemberList[I]
  else
  begin
// NWR
//  ID := - D.Index;

{    if D.DefList = DefinitionList then
      ID := TPaxBaseScripter(Scripter).SymbolTable.AppVariant(D.Index)
    else
      ID := TPaxBaseScripter(Scripter).SymbolTable.AppVariant(-D.Index);

    TPaxBaseScripter(Scripter).SymbolTable.NameIndex[ID] := NameIndex;
    TPaxBaseScripter(Scripter).SymbolTable.Kind[ID] := KindHostObject;  }

    if D.DefList = DefinitionList then
      ID := - D.Index
    else
    begin
      ID := TPaxBaseScripter(Scripter).SymbolTable.LookUpId(D.Name, ClassID);
      if ID = 0 then
        ID := TPaxBaseScripter(Scripter).SymbolTable.AppVariant(-D.Index)
      else
        TPaxBaseScripter(Scripter).SymbolTable.PutVariant(ID, -D.Index);

      TPaxBaseScripter(Scripter).SymbolTable.NameIndex[ID] := NameIndex;
      TPaxBaseScripter(Scripter).SymbolTable.Kind[ID] := KindHostObject;
      TPaxBaseScripter(Scripter).SymbolTable.PType[ID] := typeCLASS;
      TPaxBaseScripter(Scripter).SymbolTable.Imported[ID] := true;
      TPaxBaseScripter(Scripter).SymbolTable.Level[ID] := ClassID;

      ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(D.Instance.ClassName);
      if ClassRec <> nil then
        TPaxBaseScripter(Scripter).SymbolTable.PType[ID] := ClassRec.ClassID;
    end;

// NWR

    result := TPAXMemberRec.Create(ID, Self);
    MemberList.AddObject(NameIndex, result);
    result.ml := D.ml;
    result.Kind := KindVAR;
    result.Definition := D;
    result.IsSource := false;
    result.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);
  end;

  SO := DelphiInstanceToScriptObject(D.Instance, Scripter);
  SO.RefCount := 0;
  D.Value := ScriptObjectToVariant(SO);
end;

function TPAXClassRec.AddVirtualObject(D: TPAXVirtualObjectDefinition): TPAXMemberRec;
var
  ID, NameIndex, I: Integer;
begin
  NameIndex := CreateNameIndex(D.Name, Scripter);

  I := MemberList.IndexOf(NameIndex);
  if I <> -1 then
    result := MemberList[I]
  else
  begin
    ID := TPaxBaseScripter(Scripter).SymbolTable.LookUpId(D.Name, ClassID);
    if ID = 0 then
      ID := TPaxBaseScripter(Scripter).SymbolTable.AppVariant(-D.Index)
    else
      TPaxBaseScripter(Scripter).SymbolTable.PutVariant(ID, -D.Index);

    TPaxBaseScripter(Scripter).SymbolTable.NameIndex[ID] := NameIndex;
    TPaxBaseScripter(Scripter).SymbolTable.Kind[ID] := KindVirtualObject;
    TPaxBaseScripter(Scripter).SymbolTable.PType[ID] := typeVARIANT;
    TPaxBaseScripter(Scripter).SymbolTable.Imported[ID] := true;
    TPaxBaseScripter(Scripter).SymbolTable.Level[ID] := ClassID;

    result := TPAXMemberRec.Create(ID, Self);
    MemberList.AddObject(NameIndex, result);
    result.ml := D.ml;
    result.Kind := KindVAR;
    result.Definition := D;
    result.IsSource := false;
    result.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);
  end;
end;

function TPAXClassRec.AddHostInterfaceVar(D: TPAXInterfaceVarDefinition): TPAXMemberRec;
var
  ID, NameIndex, I: Integer;
  SO: TPAXScriptObject;
  ClassRec: TPaxClassRec;
  ClassDef: TPaxClassDefinition;
begin
  NameIndex := CreateNameIndex(D.Name, Scripter);

  ClassRec := nil;

  I := MemberList.IndexOf(NameIndex);
  if I <> -1 then
    result := MemberList[I]
  else
  begin
    if D.DefList = DefinitionList then
      ID := - D.Index
    else
    begin
      ID := TPaxBaseScripter(Scripter).SymbolTable.LookUpId(D.Name, ClassID);
      if ID = 0 then
        ID := TPaxBaseScripter(Scripter).SymbolTable.AppVariant(-D.Index)
      else
        TPaxBaseScripter(Scripter).SymbolTable.PutVariant(ID, -D.Index);

      TPaxBaseScripter(Scripter).SymbolTable.NameIndex[ID] := NameIndex;
      TPaxBaseScripter(Scripter).SymbolTable.Kind[ID] := KindHostInterfaceVar;
      TPaxBaseScripter(Scripter).SymbolTable.PType[ID] := typeCLASS;
      TPaxBaseScripter(Scripter).SymbolTable.Imported[ID] := true;
      TPaxBaseScripter(Scripter).SymbolTable.Level[ID] := ClassID;

      ClassDef := DefinitionList.FindInterfaceTypeDef(D.guid);

      ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(ClassDef.Name);
      if ClassRec <> nil then
        TPaxBaseScripter(Scripter).SymbolTable.PType[ID] := ClassRec.ClassID;
    end;

// NWR

    result := TPAXMemberRec.Create(ID, Self);
    MemberList.AddObject(NameIndex, result);
    result.ml := D.ml;
    result.Kind := KindVAR;
    result.Definition := D;
    result.IsSource := false;
    result.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);

    if ClassRec <> nil then
    begin
      SO := TPAXBaseScripter(Scripter).ScriptObjectList.FindScriptObjectByIntf(D.PIntf);
      if SO = nil then
      begin
        SO := ClassRec.CreateScriptObject();
        SO.PIntf := D.PIntf;
        SO.RefCount := 0;
      end;
      D.Value := ScriptObjectToVariant(SO);
    end;
  end;
end;

function TPAXClassRec.AddHostField(D: TPAXFieldDefinition): TPAXMemberRec;
var
  ID, NameIndex, I: Integer;
begin
  NameIndex := CreateNameIndex(D.Name, Scripter);

  I := MemberList.IndexOf(NameIndex);
  if I <> -1 then
    result := MemberList[I]
  else
  begin
    ID := - D.Index;
    result := TPAXMemberRec.Create(ID, Self);
    MemberList.AddObject(NameIndex, result);
    result.ml := D.ml;
    result.Kind := KindVAR;
    result.Definition := D;
    result.IsSource := false;
    result.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);
  end;
end;

function TPAXClassRec.AddHostRecordField(D: TPAXRecordFieldDefinition): TPAXMemberRec;
var
  ID, NameIndex, I: Integer;
begin
  NameIndex := CreateNameIndex(D.Name, Scripter);

  I := MemberList.IndexOf(NameIndex);
  if I <> -1 then
    result := MemberList[I]
  else
  begin
    ID := - D.Index;
    result := TPAXMemberRec.Create(ID, Self);
    MemberList.AddObject(NameIndex, result);
    result.ml := D.ml;
    result.Kind := KindVAR;
    result.Definition := D;
    result.IsSource := false;
    result.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);
  end;
end;

function TPAXClassRec.AddHostProperty(D: TPAXPropertyDefinition): TPAXMemberRec;
var
  NameIndex: Integer;
begin
  NameIndex := CreateNameIndex(D.Name, Scripter);
{
  I := MemberList.IndexOf(NameIndex);
  if I <> -1 then
  begin
    result := MemberList[I];
    Exit;
  end;
}
  result := TPAXMemberRec.Create(0, Self);
  result.ml := D.ml;
  result.Kind := KindPROP;
  result.Definition := D;
  result.NParams := D.NP;

  result.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);

  MemberList.AddObject(NameIndex, result);
end;

function TPAXClassRec.AddProperty(ID: Integer; ml: TPAXModifierList): TPAXMemberRec;
var
  I, NameIndex: Integer;
begin
  NameIndex := TPAXBaseScripter(Scripter).SymbolTable.NameIndex[ID];

  I := MemberList.IndexOf(NameIndex);

  if I = -1 then
  begin
    result := TPAXMemberRec.Create(ID, Self);
    result.ml := ml;
    result.Kind := KindPROP;

    if UpCaseIndex > 0 then
      result.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);

    MemberList.AddObject(NameIndex, result);
  end
  else
    result := MemberList.Objects[I];
end;

function TPAXClassRec.AddNestedClass(ID: Integer; ml: TPAXModifierList): TPAXMemberRec;
var
  NameIndex, I: Integer;
begin
  NameIndex := TPAXBaseScripter(Scripter).SymbolTable.NameIndex[ID];

  I := MemberList.IndexOf(NameIndex);
  if (I = -1) or ((I >= 0) and (MemberList[I].Kind <> KindTYPE)) then
  begin
    result := TPAXMemberRec.Create(ID, Self);
    result.ml := ml;
    result.Kind := KindTYPE;

    if UpCaseIndex > 0 then
      result.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);

    MemberList.AddObject(NameIndex, result);
  end
  else
    result := MemberList[I];
end;

procedure TPAXClassRec.FindOverloadedSubList(NameIndex: Integer;
                                             ma: TPAXMemberAccess;
                                             Ids: TPaxIds);
var
  I: Integer;
begin
  case ma of
    maAny:
    begin
      FindOverloadedSubList(NameIndex, maMyClass, Ids);
      if Ids.Count > 0 then
        Exit;
      FindOverloadedSubList(NameIndex, maMyBase, Ids);
    end;
    maMyClass:
    begin
      for I:=0 to MemberList.Count - 1 do
        if MemberList[I].Kind = KindSUB then
        begin
          if MemberList.NameID[I] = NameIndex then
            Ids.Add(MemberList[I].ID);
        end;
    end;
    maMyBase:
    begin
      if AncestorName <> '' then
         AncestorClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(AncestorName);
      if AncestorClassRec <> nil then
        AncestorClassRec.FindOverloadedSubList(NameIndex, maAny, Ids);
    end;
  end;
end;

function TPAXClassRec.FindOverloadedSubID(NameIndex: Integer; ma: TPAXMemberAccess; NP: Integer): Integer;
var
  I, ID: Integer;
begin
  result := 0;
  case ma of
    maAny:
    begin
      result := FindOverloadedSubID(NameIndex, maMyClass, NP);
      if result = 0 then
        result := FindOverloadedSubID(NameIndex, maMyBase, NP);
    end;
    maMyClass:
    begin
      for I:=0 to MemberList.Count - 1 do
        if MemberList[I].Kind = KindSUB then
          if MemberList.NameID[I] = NameIndex then
          begin
            ID := MemberList[I].ID;
            if TPAXBaseScripter(Scripter).SymbolTable.Count[ID] = NP then
            begin
              result := ID;
              Exit;
            end;
          end;
    end;
    maMyBase:
      if AncestorClassRec <> nil then
        result := AncestorClassRec.FindOverloadedSubID(NameIndex, maAny, NP);
  end;
end;

function TPAXClassRec.CreateScriptObject(const ObjectName: String = ''): TPAXScriptObject;
var
  MemberRec: TPAXMemberRec;
  I, RefID: Integer;
  CR: TPAXClassRec;
  R: TPAXFieldRec;
  P: TPAXProperty;
begin
  result := TPAXScriptObject.Create(Self);
  if fClassDef <> nil then
    if fClassDef.RecordSize > 0 then
    begin
      result.ExtraPtrSize := fClassDef.RecordSize;
      result.ExtraPtr := AllocMem(result.ExtraPtrSize);
    end;

  CR := Self;

  while CR <> nil do
  with CR do
  begin
    for I:=0 to MemberList.Count - 1 do
    if MemberList[I].Kind = KindVAR then
    begin
      MemberRec := MemberList[I];
      if MemberRec.IsStatic then
        with TPAXBaseScripter(Scripter).SymbolTable do
          result.CreateProperty(MemberList.NameID[I], Address[MemberRec.ID], MemberRec)
      else
      begin
        R := nil;
        with TPAXBaseScripter(Scripter) do
          if RegisteredFieldList.Count > 0 then
            R := RegisteredFieldList.FindRecord(ObjectName, Self.Name,
                     NameList[MemberList.NameID[I]]);

        P := result.CreateProperty(MemberList.NameID[I], @Undefined, MemberRec);

        if R <> nil then
          P.ExtraDef := TPAXVariableDefinition.Create(nil, '', R.FieldType, R.Address, nil);
      end;
    end;

    for I:=0 to MemberList.Count - 1 do
    if MemberList[I].Kind = KindPROP then
    begin
      MemberRec := MemberList[I];
      if not MemberRec.IsPublished then
      begin
        P := result.PropertyList.FindProperty(MemberList.NameID[I]);
        if P = nil then
          result.CreateProperty(MemberList.NameID[I], @Undefined, MemberRec);
      end
      else
        result.CreateProperty(MemberList.NameID[I], @Undefined, MemberRec);
    end;

    for I:=0 to MemberList.Count - 1 do
    if MemberList[I].Kind = KindSUB then
    begin
      MemberRec := MemberList[I];
      if not MemberRec.IsStatic then
      with TPAXBaseScripter(Scripter).SymbolTable do
        result.CreateProperty(MemberList.NameID[I], @Undefined {Address[MemberRec.ID]}, MemberRec);
    end;

    for I:=0 to MemberList.Count - 1 do
    if MemberList[I].Kind = KindVAR then
    begin
      MemberRec := MemberList[I];
      if not MemberRec.IsStatic then
        if MemberRec.InitN > 0 then
          with TPAXBaseScripter(Scripter).Code do
          begin
            SaveState;

            N := MemberRec.InitN;

            SignFOP := false;
            Run;

            if TPAXBaseScripter(Scripter).IsError then
            begin
              N := ErrorN;
              raise  TPAXScriptFailure.Create(TPAXBaseScripter(Scripter).ErrorInstance.Description);
            end;

            RestoreState;
            result.PutProperty(MemberList.NameID[I], SymbolTable.GetVariant(MemberRec.ID), 0);
          end;
    end;

    if IsImported and (AncestorClassRec = nil) then
      CR := TPAXBaseScripter(Scripter).ClassList.FindClassByName(AncestorName)
    else
      CR := AncestorClassRec;
  end;

  CR := Self;

  while CR <> nil do
  with CR do
  begin
    for I:=0 to MemberList.Count - 1 do
    if MemberList[I].Kind = KindSUB then
    begin
      MemberRec := MemberList[I];
      if not MemberRec.IsStatic then
        if MemberRec.InitN > 0 then
        with TPAXBaseScripter(Scripter).Code do
        begin
          SymbolTable.SaveState;
          SaveState;

          RefID := SymbolTable.AppReference(ScriptObjectToVariant(result),
                                            MemberList.NameID[I],
                                            maAny);

          N := Card;
          Add(OP_CALL, RefID, 0, 0);
          Add(OP_HALT, 0, 0, 0);

          SignFOP := false;
          fTerminated := false;
          Run;

          if TPAXBaseScripter(Scripter).IsError then
          begin
            N := ErrorN;
            raise TPAXScriptFailure.Create(TPAXBaseScripter(Scripter).ErrorInstance.Description);
          end;

          RestoreState;
          SymbolTable.RestoreState;

          Exit;
        end;
    end;
    CR := AncestorClassRec;
  end;
end;

procedure TPAXClassRec.InitStaticFields;
var
  MemberRec: TPAXMemberRec;
  I: Integer;
begin
  for I:=0 to UsingInitList.Count - 1 do
    with TPAXBaseScripter(Scripter) do
    begin
      Code.SaveState;
      Code.N := UsingInitList[I];
      Code.WithStack.Push(SymbolTable.RootNamespaceID);
      Code.SignFOP := false;
      Code.fTerminated := false;
      Code.SignInitStage := true;

      with Code do
      while (Prog[N].Op = OP_JS_OPERS_ON) or
            (Prog[N].Op = OP_JS_OPERS_OFF) or
            (Prog[N].Op = OP_UPCASE_ON) or
            (Prog[N].Op = OP_UPCASE_OFF) or
            (Prog[N].Op = OP_VBARRAYS_ON) or
            (Prog[N].Op = OP_VBARRAYS_OFF) or
            (Prog[N].Op = OP_DECLARE_ON) or
            (Prog[N].Op = OP_DECLARE_OFF) or
            (Prog[N].Op = OP_TRY_ON) or
            (Prog[N].Op = OP_ZERO_BASED_STRINGS_ON) or
            (Prog[N].Op = OP_ZERO_BASED_STRINGS_OFF) do
            Dec(N);

      Code.Run;

      Code.WithStack.Pop;
      Code.RestoreState;

      if IsError then
        Exit;
    end;

  for I:=0 to MemberList.Count - 1 do
  if MemberList[I].Kind = KindVAR then
  begin
    MemberRec := MemberList[I];
    if MemberRec.IsStatic and (MemberRec.InitN > 0) then
    with TPAXBaseScripter(Scripter).Code do
    begin
      SaveState;
      N := MemberRec.InitN;

      WithStack.Push(GetLanguageNamespaceID);
      WithStack.Push(SymbolTable.RootNamespaceID);

      SignFOP := false;
      fTerminated := false;

      Run;

      WithStack.Pop;
      WithStack.Pop;

      RestoreState;

      if TPAXBaseScripter(Scripter).IsError then
         Exit;

      if ClassObject <> nil then
        ClassObject.PutProperty(MemberList.NameID[I], SymbolTable.GetVariant(MemberRec.ID), 0);
    end;
  end;
end;

procedure TPAXClassRec.CreateClassObject;
var
  MemberRec: TPAXMemberRec;
  I: Integer;
  CR: TPAXClassRec;

  V: Variant;
  NameIndex: Integer;
  PropList: TPaxPropertyList;
begin
  with TPAXBaseScripter(Scripter).SymbolTable do
    V := GetVariant(ClassID);

  if IsObject(V) then
    ClassObject := VariantToScriptObject(V)
  else
  begin
    ClassObject := TPAXScriptObject.Create(Self);
    ClassObject.IsClass := true;
  end;

  PropList := ClassObject.PropertyList;

  CR := Self;

  while CR <> nil do
  begin
    for I:=0 to CR.MemberList.Count - 1 do
    if CR.MemberList[I].Kind in [KindVAR, KindCONST] then
    begin

     NameIndex := CR.MemberList.NameID[I];
     if PropList.FindProperty(NameIndex) <> nil then
        Continue;
      MemberRec := CR.MemberList[I];

      if MemberRec.IsStatic then
        with TPAXBaseScripter(Scripter) do
        begin
          ClassObject.CreateProperty(NameIndex, SymbolTable.Address[MemberRec.ID], MemberRec);
          DoNotDestroyList.Add(MemberRec.ID);
        end;
    end;

    for I:=0 to CR.MemberList.Count - 1 do
    if CR.MemberList[I].Kind = KindPROP then
    begin
      NameIndex := CR.MemberList.NameID[I];
      if PropList.FindProperty(NameIndex) <> nil then
        Continue;

      MemberRec := CR.MemberList[I];
      if MemberRec.IsStatic then
        ClassObject.CreateProperty(NameIndex, @Undefined, MemberRec);
    end;

    for I:=0 to CR.MemberList.Count - 1 do
    if CR.MemberList[I].Kind = KindSUB then
    begin
      NameIndex := CR.MemberList.NameID[I];
      if PropList.FindProperty(NameIndex) <> nil then
        Continue;

      MemberRec := CR.MemberList[I];
      if MemberRec.IsStatic then
      begin
        if MemberRec.ID = 0 then
          ClassObject.CreateProperty(NameIndex, @Undefined, MemberRec)
        else
          ClassObject.CreateProperty(NameIndex,
           TPAXBaseScripter(Scripter).SymbolTable.Address[MemberRec.ID], MemberRec);
      end;
    end;

    for I:=0 to CR.MemberList.Count - 1 do
    if CR.MemberList[I].Kind = KindTYPE then
    begin
      NameIndex := CR.MemberList.NameID[I];
      if PropList.FindProperty(NameIndex) <> nil then
        Continue;

      MemberRec := CR.MemberList[I];
      MemberRec.ml := MemberRec.ml + [modSTATIC];
      ClassObject.CreateProperty(NameIndex,
           TPAXBaseScripter(Scripter).SymbolTable.Address[MemberRec.ID], MemberRec);
    end;

    CR := CR.AncestorClassRec;
  end;

  with TPAXBaseScripter(Scripter).SymbolTable do
  begin
    Kind[ClassID] := kindTYPE;
    PutVariant(ClassID, ScriptObjectToVariant(ClassObject));
  end;
end;

function TPAXClassRec.GetConstructorID: Integer;
begin
  result := ClassID;
  with TPAXBaseScripter(Scripter).SymbolTable do
    while (Kind[result] <> KindSUB) do
      Inc(result);
end;

function TPAXClassRec.GetConstructorIDEx: Integer;
var
  C: TPaxClassRec;
begin
  result := ClassID;
  with TPAXBaseScripter(Scripter).SymbolTable do
  begin
    repeat
       if Kind[result] = KindSUB then
         if TypeSub[result] = tsConstructor then
           Exit;
       Inc(result);
     until result = Card;
  end;
  if AncestorName = '' then
    result := 0
  else
  begin
    C := TPAXBaseScripter(Scripter).ClassList.FindClassByName(AncestorName);
    if C = nil then
      result := 0
    else
      result := C.GetConstructorIDEx;
  end;
end;

function TPAXClassRec.GetConstructorIDEx(const Params: array of const): Integer;
var
  C: TPaxClassRec;
  I, T, ParamId, L: Integer;
  ok: Boolean;
  D: TPaxMethodDefinition;

label
  Ancestor;

begin
  result := ClassID;
  L := Length(Params);
  with TPAXBaseScripter(Scripter).SymbolTable do
  begin
    repeat
       if Kind[result] = KindSUB then
         if (TypeSub[result] = tsConstructor) and (Count[result] = L) then
         begin
            if result < 0 then
            begin
              D := DefinitionList[-result];
              if (D.PClass <> nil) and (DelphiClass <> nil) then
                if D.PClass <> DelphiClass then
                   goto Ancestor;
            end;

           ok := true;

           for I:=0 to L - 1 do
           begin
             ParamID := GetParamId(result, I + 1);

             T := PType[ParamId];

             case Params[I].VType of
               vtBoolean:
               begin
                  if not (T in [typeBOOLEAN, typeVARIANT]) then
                    ok := false;
               end;
               vtInteger:
               begin
                  if not (T in [typeINTEGER, typeBYTE, typeWORD, typeCARDINAL, typeINT64, typeSHORTINT, typeSMALLINT, typeVARIANT]) then
                    ok := false;
               end;
               vtAnsiString, vtString, vtChar:
               begin
                  if not (T in [typeSTRING, typeVARIANT]) then
                    ok := false;
               end;
               vtExtended, vtCurrency:
               begin
                  if not (T in [typeDOUBLE, typeVARIANT]) then
                    ok := false;
               end;
             end;
           end;

           if ok then
           begin
             Exit;
           end;
         end;
       if result > 0 then
         Inc(result)
       else
         Dec(result);

       if result < 0 then
         if (-result) >= DefinitionList.Count then
           goto Ancestor;

     until result = Card;
  end;

Ancestor:

  if AncestorName = '' then
    result := 0
  else
  begin
    C := TPAXBaseScripter(Scripter).ClassList.FindClassByName(AncestorName);
    if C = nil then
      result := 0
    else
      result := C.GetConstructorIDEx(Params);
  end;
end;

function TPAXClassRec.IsNestedClass(ClassID: Integer): Boolean;
var
  I: Integer;
  MemberRec: TPAXMemberRec;
begin
  result := false;
  for I:=0 to MemberList.Count - 1 do
  if MemberList[I].Kind = KindTYPE then
  begin
    MemberRec := MemberList[I];
    if MemberRec.ID = ClassID then
    begin
      result := true;
      Exit;
    end;
  end;
end;

function TPAXClassRec.FindNestedClassID(ClassNameIndex: Integer): Integer;
var
  I, U: Integer;
  MemberRec: TPAXMemberRec;
begin
  result := 0;
  for I:=0 to MemberList.Count - 1 do
  begin
    MemberRec := MemberList[I];
    if MemberRec.Kind = KindTYPE then
      if MemberList.NameID[I] = ClassNameIndex then
      begin
        result := MemberRec.ID;
        Exit;
      end;
  end;

  U := NameIndexToUpperCaseIndex(ClassNameIndex, Scripter);
  for I:=0 to MemberList.Count - 1 do
  begin
    MemberRec := MemberList[I];
    if MemberRec.Kind = KindTYPE then
      if MemberRec.UpCaseIndex = U then
      begin
        result := MemberRec.ID;
        Exit;
      end;
  end;
end;

constructor TPAXClassList.Create(AScripter: Pointer);
begin
  inherited Create;
  Scripter := AScripter;

  ObjectClassRec := nil;
  BooleanClassRec := nil;
  StringClassRec := nil;
  NumberClassRec := nil;
  DateClassRec := nil;
  FunctionClassRec := nil;
  FunctionClassRec := nil;
  ArrayClassRec := nil;
  ActiveXClassRec := nil;

  DelegateClassRec := nil;
end;

destructor TPAXClassList.Destroy;
begin
  inherited;
end;

function TPAXClassList.GetSourceClassList: TList;

procedure AddClasses(R: TPAXClassRec);
var
  MemberRec: TPAXMemberRec;
  I: Integer;
  P: Pointer;
begin
  for I:=0 to R.MemberList.Count - 1 do
  begin
    MemberRec := R.MemberList[I];
    if MemberRec.IsSource then
      if MemberRec.Kind = KindTYPE then
      begin
        P := Pointer(MemberRec.ID);
        if result.IndexOf(P) = -1 then
          result.Add(P);
        AddClasses(FindClass(MemberRec.ID));
      end;
  end;
end;

begin
  result := TList.Create;
  AddClasses(Records[0]);
end;

procedure TPAXClassList.ResetCompileStage;
var
  L: TList;
  I, ClassID, Index: Integer;
begin
  L := GetSourceClassList;
  Records[0].ResetCompileStage;
  for I:=0 to L.Count - 1 do
  begin
    ClassID := Integer(L[I]);
    Index := IndexOf(ClassID);
    DeleteObject(Index);
  end;
  L.Free;
end;

procedure TPAXClassList.SaveToStream(S: TStream; I1, I2: Integer);
var
  I: Integer;
begin
  SaveInteger(I1, S);
  SaveInteger(I2, S);
  for I:=I1 to I2 do
    Records[I].SaveToStream(S);
end;

procedure TPAXClassList.LoadFromStream(S: TStream);
var
  I, I1, I2: Integer;
  ClassRec: TPAXClassRec;
begin
  I1 := LoadInteger(S);
  I2 := LoadInteger(S);
  for I:=I1 to I2 do
  begin
    ClassRec := TPAXClassRec.Create(Scripter, ckClass);
    ClassRec.LoadFromStream(S);
    AddObject(ClassRec.ClassID, ClassRec);
  end;
end;

function TPAXClassList.GetRecord(Index: Integer): TPAXClassRec;
begin
  result := TPAXClassRec(Objects[Index]);
end;

procedure TPAXClassList.InitRunStage;
begin
  SaveCount := Count;
end;

procedure TPAXClassList.ResetRunStage;
var
  I: Integer;
begin
  for I:= Count - 1 downto SaveCount do
  begin
    TPAXBaseScripter(Scripter).SymbolTable.NameIndex[Records[I].ClassID];
    DeleteObject(I);
  end;
end;

procedure TPAXClassList.CreateClassObjects(StartRecNo: Integer);
var
  I: Integer;
  ClassRec: TPAXClassRec;
  V: Variant;
begin
  for I:=StartRecNo to Count - 1 do
  begin
    ClassRec := Records[I];

    V := TPAXBaseScripter(Scripter).SymbolTable.GetVariant(ClassRec.ClassID);

    if not IsObject(V) then
    begin
      ClassRec.CreateClassObject;
      ClassRec.AncestorClassRec := FindClassByName(ClassRec.AncestorName);

{     if (ClassRec.AncestorClassRec = nil) and (ClassRec.AncestorName <> '') then
      begin
        ErrMessageBox('Class ' + ClassRec.AncestorName + ' is not found!');
        ClassRec.AncestorName := '';
      end;
}
      ClassRec.OwnerClassRec := FindClassByName(ClassRec.OwnerName);

      if StartRecNo > 0 then
        if ClassRec.OwnerClassRec <> nil then
          ClassRec.OwnerClassRec.CreateClassObject;
    end;

    if ClassRec.Name = 'Object' then
      ObjectClassRec := ClassRec
    else if ClassRec.Name = 'Number' then
      NumberClassRec := ClassRec
    else if ClassRec.Name = 'Date' then
      DateClassRec := ClassRec
    else if ClassRec.Name = 'Function' then
      FunctionClassRec := ClassRec
    else if ClassRec.Name = 'String' then
      StringClassRec := ClassRec
    else if ClassRec.Name = 'Boolean' then
      BooleanClassRec := ClassRec
    else if ClassRec.Name = 'Function' then
      FunctionClassRec := ClassRec
    else if ClassRec.Name = 'TPAXDelegate' then
      DelegateClassRec := ClassRec
    else if ClassRec.Name = 'Array' then
      ArrayClassRec := ClassRec
    else if ClassRec.Name = 'ActiveXObject' then
      ActiveXClassRec := ClassRec;
  end;
end;

procedure TPAXClassList.InitStaticFields(StartRecNo: Integer);
var
  I: Integer;
begin
  for I:=StartRecNo to Count - 1 do
    Records[I].InitStaticFields;
end;

function TPAXClassList.AddClass(ClassID: Integer;
                                const AClassName, OwnerName, AncestorName: String;
                                ml: TPAXModifierList; ck: TPAXClassKind;
                                UpCase: Boolean): TPAXClassRec;
var
  ClassRec: TPAXClassRec;
begin
//  ClassRec := FindClass(TPAXBaseScripter(Scripter).SymbolTable.RootNamespaceID);

  if Count = 0 then
    ClassRec := nil
  else
    ClassRec := Records[0];

  if ClassRec <> nil then
  begin
    if ClassRec.ClassID = ClassID then
    begin
      result := ClassRec;
      Exit;
    end;

    if (modSTATIC in ml) and ClassRec.IsNestedClass(ClassID) then
    begin
      result := FindClass(ClassID);
      if result <> nil then
        Exit;
    end;
  end;

  result := TPAXClassRec.Create(Scripter, ck);
  result.Name := AClassName;
  result.OwnerName := OwnerName;
  result.AncestorName := AncestorName;
  result.ModuleID := TPAXBaseScripter(Scripter).Code.ModuleID;
  result.ClassID := ClassID;
  result.ml := ml;
  result.ck := ck;

  result.NameIdx := CreateNameIndex(result.Name, Scripter);
  if UpCase then
    result.UpCaseIndex := NameIndexToUpperCaseIndex(result.NameIdx, Scripter);

  AddObject(ClassID, result);
end;

function TPAXClassList.FindClass(ClassID: Integer): TPAXClassRec;
begin
  result := TPAXClassRec(GetObject(ClassID));
end;

function TPAXClassList.FindImportedClass(PClass: TClass): TPAXClassRec;
var
  I: Integer;
  R: TPaxClassRec;
begin
  for I:=0 to Count - 1 do
  begin
    R := Records[I];
    if R.IsImported then
      if R.fClassDef.PClass = PClass then
      begin
        result := R;
        Exit;
      end;
  end;
  result := nil;
end;

function TPAXClassList.ExistsClassByName(const Name: String): boolean;
var
  I: Integer;
begin
  for I:=Count - 1 downto 0 do
  if StrEql(Records[I].Name, Name) then
  begin
    result := true;
    Exit;
  end;
  result := false;
end;

function TPAXClassList.FindClassByName(const Name: String): TPAXClassRec;
var
  I: Integer;
  D: TPaxClassDefinition;
  C: TPaxClassRec;
  Lst: TStringList;
  M: TPaxMemberRec;
  NameIndex: Integer;
  S: String;
begin
  result := nil;
  if Name = '' then
    Exit;

  for I:=Count - 1 downto 0 do
  if StrEql(Records[I].Name, Name) then
  begin
    result := Records[I];
    Exit;
  end;

  if not SignLoadOnDemand then
    Exit;

  D := DefinitionList.FindClassDefByName(Name);
  if D <> nil then
  begin
    if D.Owner <> nil then
    begin
      if not ExistsClassByName(D.Owner.Name) then
        D.Owner.AddToScripter(scripter);
    end;

    C := nil;
    if D.PClass <> nil then
      if D.PClass.ClassParent <> nil then
          C := FindClassByName(D.PClass.ClassParent.ClassName);

    D.AddToScripter(scripter);

    result := Records[Count - 1];
    result.AncestorClassRec := C;

    if D.PClass <> nil then
    begin
      Lst := TStringList.Create;
      GetPublishedProperties(D.PClass, Lst);
      for I:=0 to Lst.Count - 1 do
      begin
        M := TPaxMemberRec.Create(0, result);
        M.IsPublished := true;
        M.Kind := KindPROP;
        NameIndex := CreateNameIndex(Lst[I], Scripter);
        M.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);
        result.MemberList.AddObject(NameIndex, M);
      end;
      Lst.Free;
    end;

    for I:=0 to DefinitionList.Count - 1 do
    begin
      if DefinitionList.Records[I].Owner = D then
      begin
        if DefinitionList.Records[I].DefKind <> dkClass then
           DefinitionList.Records[I].AddToScripter(scripter)
      end;
    end;
  end;

  if result = nil then
  begin
    S := FindTypeAlias(Name, true);
    if S = '' then
      Exit;
    result := FindClassByName(S);
  end;
end;

function TPAXClassList.FindClassByInstance(Instance: TObject): TPAXClassRec;
var
  C: TClass;
begin
  result := FindClassByName(Instance.ClassName);
  if result = nil then
  begin
    C := Instance.ClassType;

    repeat

      C := C.ClassParent;
      if C = TObject then
        Exit;
      result := FindClassByName(C.ClassName);
      if result <> nil then
        Exit;

    until false;
  end;
end;

function TPAXClassList.FindClassByGuid(const guid: TGUID): TPAXClassRec;
var
  I: Integer;
begin
  result := nil;
  for I:=Count - 1 downto 0 do
    if Records[I].fClassDef <> nil then
      if Records[I].fClassDef.ClassKind = ckInterface then
        if IsEqualGuid(Records[I].fClassDef.guid, guid) then
        begin
          result := Records[I];
          Exit;
        end;
end;


function TPAXClassList.FindNestedClass(OwnerList: TStringList; const Name: String): TPAXClassRec;
var
  I, ID, TempIndex, NameIndex: Integer;
  ClassRec: TPAXClassRec;
  S: String;
begin
  result := nil;

  if Name = RootNamespaceName then
    Exit;

  NameIndex := CreateNameIndex(Name, Scripter);

  ClassRec := Records[0];
  if OwnerList = nil then
  begin
    ID := ClassRec.FindNestedClassID(NameIndex);
    if ID = 0 then
      Exit;

    result := FindClass(ID);
    Exit;
  end;

  if OwnerList.Count = 0 then
  begin
    ID := ClassRec.FindNestedClassID(NameIndex);
    if ID = 0 then
      Exit;

    result := FindClass(ID);
    Exit;
  end;

  if OwnerList[0] = RootNamespaceName then
  begin
    ID := ClassRec.FindNestedClassID(NameIndex);
    if ID = 0 then
      Exit;

    result := FindClass(ID);
    Exit;
  end;

  for I:=0 to OwnerList.Count - 1 do
  begin
    S := OwnerList[I];
    TempIndex := CreateNameIndex(S, Scripter);
    ID := ClassRec.FindNestedClassID(TempIndex);
    if ID = 0 then
      Exit;
    ClassRec := FindClass(ID);
    if ClassRec = nil then
      Exit;
  end;

  ID := ClassRec.FindNestedClassID(NameIndex);
  if ID = 0 then
    Exit;

  result := FindClass(ID);
end;

function TPAXClassList.FindMember(ClassID, MemberNameIndex: Integer; ma: TPAXMemberAccess): TPAXMemberRec;
var
  ClassRec: TPAXClassRec;
begin
  ClassRec := FindClass(ClassID);
  if ClassRec = nil then
    result := nil
  else
    result := ClassRec.FindMember(MemberNameIndex, ma);
end;

function TPAXClassList.CreateScriptObject(ClassID: Integer): TPAXScriptObject;
var
  ClassRec: TPAXClassRec;
begin
  ClassRec := FindClass(ClassID);
  if ClassRec = nil then
    result := nil
  else
    result := ClassRec.CreateScriptObject;
end;

procedure TPAXClassList.Reset;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    Records[I].Free;
  Objects.Clear;
  Clear;
end;

procedure GetPublishedPropertiesEx(AClass: TClass;
                                   result: TStrings;
                                   ClassList: TPaxClassList);
var
  pti: PTypeInfo;
  ptd: PTypeData;
  Loop, nProps: Integer;
  pProps: PPropList;
  ppi: PPropInfo;
  S, T: String;
begin
  pti := AClass.ClassInfo;
  if pti = nil then Exit;
  ptd := GetTypeData(pti);
  nProps := ptd^.PropCount;
  if nProps > 0 then begin
    GetMem(pProps, SizeOf(PPropInfo) * nProps);
    GetPropInfos(pti, pProps);
  end
  else pProps := nil;
  for Loop:=0 to nProps - 1 do begin
    ppi := pProps[Loop];
    S := ppi^.Name;
    T := ppi^.PropType^.Name;

    if PaxTypes.IndexOf(UpperCase(T)) >= 0 then
      result.Add(UpperCase(S))
    else if ClassList.FindClassByName(T) <> nil then
      result.Add(UpperCase(S));
  end;
  if pProps <> nil then
    FreeMem(pProps, SizeOf(PPropInfo) * nProps);
end;

{
procedure TPAXClassList.AddDefinitionList(L: TPAXDefinitionList);
var
  I, J, NameIndex: Integer;
  D: TPAXDefinition;
  Lst: TStringList;
  R: TPaxClassRec;
  M: TPaxMemberRec;
begin
  for I:=0 to L.Count - 1 do
  begin
    D := L[I];
    if D <> nil then
      D.AddToScripter(Scripter);
  end;
  Lst := TStringList.Create;
  for I:=0 to Count - 1 do
  begin
    R := Records[I];
    if R.fClassDef <> nil then
      if R.fClassDef.PClass <> nil then
      begin
        GetPublishedProperties(R.fClassDef.PClass, Lst);
        for J:=0 to Lst.Count - 1 do
        begin
          M := TPaxMemberRec.Create(0, R);
          M.IsPublished := true;
          M.Kind := KindPROP;
          NameIndex := CreateNameIndex(Lst[J], Scripter);
          M.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);
          R.MemberList.AddObject(NameIndex, M);
        end;
        Lst.Clear;
      end;
  end;
  Lst.Free;
end;
}

procedure TPAXClassList.AddDefinitionList(L: TPAXDefinitionList; N: Integer);
var
  I, J, NameIndex: Integer;
  D: TPAXDefinition;
  Lst: TStringList;
  R: TPaxClassRec;
  M: TPaxMemberRec;
begin
  for I:=0 to N - 1 do
  begin
    D := L[I];
    if D <> nil then
      D.AddToScripter(Scripter);
  end;
  Lst := TStringList.Create;
  for I:=0 to Count - 1 do
  begin
    R := Records[I];
    if R.fClassDef <> nil then
      if R.fClassDef.PClass <> nil then
      begin
        GetPublishedProperties(R.fClassDef.PClass, Lst);
        for J:=0 to Lst.Count - 1 do
        begin
          M := TPaxMemberRec.Create(0, R);
          M.IsPublished := true;
          M.Kind := KindPROP;
          NameIndex := CreateNameIndex(Lst[J], Scripter);
          M.UpCaseIndex := NameIndexToUpperCaseIndex(NameIndex, Scripter);
          R.MemberList.AddObject(NameIndex, M);
        end;
        Lst.Clear;
      end;
  end;
  Lst.Free;
end;


function TPAXClassList.CreateBooleanObject(const AValue: Variant): TPaxScriptObject;
begin
  if (BooleanClass = nil) or (BooleanClassRec = nil) then
  begin
    BooleanClassRec := FindClassByName('Boolean');
    if (BooleanClass = nil) or (BooleanClassRec = nil) then
    raise TPAXScriptFailure.Create(Format(errClassIsNotFound, ['Boolean']));
  end;
  result := BooleanClass.Create(BooleanClassRec);

  result.SetDefaultValue(toBoolean(AValue));
  result.RefCount := 1;
end;

function TPAXClassList.CreateNumberObject(const AValue: Variant): TPaxScriptObject;
begin
  if (NumberClass = nil) or (NumberClassRec = nil) then
  begin
    NumberClassRec := FindClassByName('Number');
    if (NumberClass = nil) or (NumberClassRec = nil) then
    raise TPAXScriptFailure.Create(Format(errClassIsNotFound, ['Number']));
  end;
  result := NumberClass.Create(NumberClassRec);

  result.SetDefaultValue(toNumber(AValue));
  result.RefCount := 1;
end;

function TPAXClassList.CreateStringObject(const AValue: Variant): TPaxScriptObject;
begin
  if (StringClass = nil) or (StringClassRec = nil) then
  begin
    StringClassRec := FindClassByName('String');
    if (StringClass = nil) or (StringClassRec = nil) then
    raise TPAXScriptFailure.Create(Format(errClassIsNotFound, ['String']));
  end;
  result := StringClass.Create(StringClassRec);

  result.SetDefaultValue(toString(AValue));
  result.RefCount := 1;
end;

function TPAXClassList.CreateDateObject(const AValue: Variant): TPaxScriptObject;
begin
  if (DateClass = nil) or (DateClassRec = nil) then
  begin
    DateClassRec := FindClassByName('Date');
    if (DateClass = nil) or (DateClassRec = nil) then
    raise TPAXScriptFailure.Create(Format(errClassIsNotFound, ['Date']));
  end;
  result := DateClass.Create(DateClassRec);

  result.SetDefaultValue(toDate(AValue));
  result.RefCount := 1;
end;

function TPAXClassList.CreateFunctionObject(const AValue: Variant): TPaxScriptObject;
begin
  if (FunctionClass = nil) or (FunctionClassRec = nil) then
  begin
    FunctionClassRec := FindClassByName('Function');
    if (FunctionClass = nil) or (FunctionClassRec = nil) then
    raise TPAXScriptFailure.Create(Format(errClassIsNotFound, ['Function']));
  end;
  result := FunctionClass.Create(FunctionClassRec);

  result.SetDefaultValue(AValue);
  result.RefCount := 1;
end;

procedure TPAXClassList.Dump(const FileName: String);
var
  I, J: Integer;
  T: TextFile;
  ClassRec, OwnerRec, AncestorRec: TPAXClassRec;

  MemberRec: TPAXMemberRec;
  S, S1, S2: String;
begin
  AssignFile(T, FileName);
  Rewrite(T);
  try
    for I:=0 to Count - 1 do
    begin
      ClassRec := Records[I];
      writeln(T, '');
      writeln(T, ClassRec.Name +
                 '[', ClassRec.ClassID:4, ']');
      writeln(T, '***********************************');
      AncestorRec := ClassRec.AncestorClassRec;
      if AncestorRec <> nil then
      begin
        writeln(T, 'Ancestor: ', AncestorRec.Name +
                   '[', AncestorRec.ClassID:4, ']');
      end;
      OwnerRec := ClassRec.OwnerClassRec;
      if OwnerRec <> nil then
      begin
        writeln(T, 'Owner: ', OwnerRec.Name +
                   '[', OwnerRec.ClassID:4, ']');
      end;

      writeln(T, 'Fields:');
      with ClassRec do
      begin
        for J:=0 to MemberList.Count - 1 do
        if (MemberList[J].Kind = KindVAR) or (MemberList[J].Kind = KindCONST) then
        begin
          MemberRec := MemberList[J];
          if MemberRec.IsStatic then
            S := ' static'
          else
            S := '';
          if MemberRec.IsSource then
            S2 := ' [SOURCE]'
          else
            S2 := '';
          with MemberRec do
            writeln(T, '[', ID:4, ']', TPAXBaseScripter(Scripter).GetName(MemberList.NameID[J]),
                       ' Init: ', MemberRec.InitN, S, S2);
        end;
      end;

      writeln(T, 'Methods:');
      with ClassRec do
      begin
        for J:=0 to MemberList.Count - 1 do
        if MemberList[J].Kind = KindSUB then
        begin
          MemberRec := MemberList[J];
          if MemberRec.IsStatic then
            S := ' static'
          else
            S := '';
          if MemberRec.IsSource then
            S2 := ' [SOURCE]'
          else
            S2 := '';
          with MemberRec do
            writeln(T, '[', ID:4, ']', TPAXBaseScripter(Scripter).GetName(MemberList.NameID[J]), S, S2);
        end;
      end;
      writeln(T, 'Properties:');
      with ClassRec, TPAXBaseScripter(Scripter).SymbolTable do
      begin
        for J:=0 to MemberList.Count - 1 do
        if MemberList[J].Kind = KindPROP then
        begin
          MemberRec := MemberList[J];
          if MemberRec.IsStatic then
            S := ' static'
          else
            S := '';

          if MemberRec.IsSource then
            S2 := ' [SOURCE]'
          else
            S2 := '';

          if MemberRec.IsImported then
          begin
            S := S + ' imported';
            S1 := Norm(MemberRec.Definition.Name, 10);
          end
          else
          begin
            S1 := Norm(Name[MemberRec.ID], 10);
          end;

          with MemberRec do
            writeln(T, '[', ID:4, ']', S1,
                       ' ReadID = [', ReadID:4, ']', Norm(Name[ReadID], 10),
                       ' WriteID = [', WriteID:4, ']', Norm(Name[WriteID], 10), S, S2);
        end;
      end;
      writeln(T, 'Nested classes:');
      with ClassRec do
      begin
        for J:=0 to MemberList.Count - 1 do
        if MemberList[J].Kind = KindTYPE then
        begin
          MemberRec := MemberList[J];
          if MemberRec.IsStatic then
            S := ' static'
          else
            S := '';
          with MemberRec do
            writeln(T, '[', ID:4, ']', TPAXBaseScripter(Scripter).GetName(MemberList.NameID[J]), S);
        end;
      end;
    end;
  finally
    Close(T);
  end;
end;

function ScriptObjectToVariant(const Value: TPAXScriptObject): Variant;
begin
  result := Integer(Value);
  TVarData(result).VType := varScriptObject;
end;

function VariantToScriptObject(const Value: Variant): TPAXScriptObject;
begin
  if not IsObject(Value) then
  begin
    if VarType(Value) <> varUndefined then
      raise TPAXScriptFailure.Create(errIncompatibleTypes)
    else
    begin
      raise TPAXScriptFailure.Create(errVariantToScriptObjectConversion);
    end;
  end;
  result := TPAXScriptObject(TVarData(Value).VInteger);
end;

function ArrayToStr(const V: Variant): String; forward;

function VariantToString(const Value: Variant): String;
var
  T: Integer;
begin
  T := VarType(Value);
  if      T = varEmpty then
     result := 'null'
  else if T = varNull then
     result := 'null'
  else if T = varError then
     result := 'Error:' + IntToStr(TVarData(Value).VError)
  else if T = varDispatch then
     result := 'Dispatch:' + Format('%p', [TVarData(Value).VDispatch])
  else if IsObject(Value) then
    result := VariantToScriptObject(Value).ToString()
  else if T > varArray then
     result := ArrayToStr(Value)
  else if T = varBoolean then
  begin
    if Value then
      result := 'true'
    else
      result := 'false';
  end
  else
    result := VarToStr(Value);
end;

function ArrayToStr(const V: Variant): String;
var
  L: Integer;
  B1, B2: array[1..100] of Integer;

function F(P: Pointer; I: Integer; var SZ: Integer): String;
var
  K, TempSZ: Integer;
begin
  if I > L then
  begin
    result := VariantToString(Variant(P^));
    SZ := SizeOf(Variant);
    Exit;
  end;

  result := '[';

  SZ := 0;

  for K:=B1[I] to B2[I] do
  begin
    result := result + F(P, I + 1, TempSZ);
    if K < B2[I] then
      result := result + ',';
    Inc(Integer(P), TempSZ);
    Inc(SZ, TempSZ);
  end;

  result := result + ']';
end;

var
  I, SZ: Integer;
  P: Pointer;
begin
  L := VarArrayDimCount(V);
  for I:=1 to L do
  begin
    B1[I] := VarArrayLowBound(V, L - I + 1);
    B2[I] := VarArrayHighBound(V, L - I + 1);
  end;
  P := VarArrayLock(V);
  try
    result := F(P, 1, SZ);
  finally
    VarArrayUnlock(V);
  end;
end;

function ToStr(Scripter: Pointer; const V: Variant): String;
begin
  TPaxBaseScripter(Scripter).Visited.Clear;
  result := _ToStr(Scripter, V);
  TPaxBaseScripter(Scripter).Visited.Clear;
end;

function _ToStr(Scripter: Pointer; const V: Variant): String;
var
  SO: TPAXScriptObject;
begin
  if IsObject(V) then
  begin
    SO := VariantToScriptObject(V);
    if TPAXBaseScripter(Scripter).AssignedObject(SO) then
      result := SO.ToString()
    else
      result := 'nil'
  end
  else
    result := VariantToString(V);

  if result = '\r\n' then
    result := #13#10;
end;

function ToInteger(const V: Variant): Integer;
begin
  result := ToInt32(V);
end;

constructor TPAXScriptObjectList.Create(_Scripter: Pointer);
begin
  Self._Scripter := _Scripter;
  fPaxObjects := TList.Create;
end;

destructor TPAXScriptObjectList.Destroy;
begin
  Clear;

  fPaxObjects.Free;
  inherited;
end;

function TPAXScriptObjectList.GetItem(I: Integer): TPaxScriptObject;
begin
  result := TPAXScriptObject(fPaxObjects[I]);
end;

procedure TPAXScriptObjectList.Add(SO: TPaxScriptObject);
begin
  fPaxObjects.Add(SO);
end;

procedure TPAXScriptObjectList.Delete(I: Integer);
var
  SO: TPaxScriptObject;
begin
  SO := TPAXScriptObject(fPaxObjects[I]);
  Pointer(SO.Intf) := nil;

  if SO.Instance <> nil then
    if SO.ClassRec.Name = 'RegExp' then
      SO.Instance.Free;

  SO.Free;
  fPaxObjects.Delete(I);
end;

function TPAXScriptObjectList.GetCount: Integer;
begin
  result := fPaxObjects.Count;
end;

procedure TPAXScriptObjectList.Clear;
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
    Delete(I);
end;

function TPAXScriptObjectList.IndexOfDelphiObject(DelphiInstance: TObject): Integer;
var
  SO: TPAXScriptObject;
  I: Integer;
  S: String;
begin
  result := -1;
  If DelphiInstance = Nil then
    exit;

  if not IsDelphiObject(DelphiInstance) then
    Exit;

  S := DelphiInstance.ClassName;
  for I:=Count - 1 downto 0 do
  begin
    SO := TPAXScriptObject(fPaxObjects[I]);
    if SO.Instance = DelphiInstance then
    if SO.ClassRec.Name = S then
    begin
      result := I;
      Exit;
    end;
  end;
end;

function TPAXScriptObjectList.FindScriptObject(DelphiInstance: TObject): TPAXScriptObject;
var
  I: Integer;
begin
  I := IndexOfDelphiObject(DelphiInstance);
  if I = -1 then
    result := nil
  else
    result := TPAXScriptObject(fPaxObjects[I]);
end;

function TPAXScriptObjectList.FindScriptObjectByIntf(PIntf: PUnknown): TPAXScriptObject;
var
  I: Integer;
  SO: TPAXScriptObject;
begin
  for I:=0 to Count - 1 do
  begin
    SO := TPAXScriptObject(fPaxObjects[I]);
    if SO.PIntf <> nil then
      if SO.PIntf = PIntf then
      begin
        result := SO;
        Exit;
      end;
  end;
  result := nil;
end;

constructor TPAXDelegate.Create(Scripter: Pointer;
                                SubID, N: Integer; D: TPAXMethodDefinition);
begin
  if Scripter <> nil then
    inherited Create(TPAXBaseScripter(Scripter).CompileTimeHeap);

  Self.N := N;
  Self.SubID := SubID;
  Self.D := D;
  fName := '';
end;

destructor TPAXDelegate.Destroy;
begin
  if D <> nil then
    if D.DefList = nil then
      D.Free;
  inherited;
end;

procedure TPAXCompileTimeHeap.ResetCompileStage;
var
  D: TPAXDelegate;
  I: Integer;
begin
  for I:=Count - 1 downto 0 do
  begin
    D :=  TPAXDelegate(Items[I]);
    if D.SubID >= FirstSymbolCard then
      Delete(I);
  end;
end;

procedure TPAXScriptObjectList.ResetCompileStage(FreeHost: Boolean = false);
var
  SO: TPAXScriptObject;
  D: TPAXDelegate;
  I, J: Integer;
  S: TPaxBaseScripter;
  ClassList: TPaxClassList;
  ClassRec: TPaxClassRec;
begin
  S := _Scripter;
  ClassList := S.ClassList;

  for J := 1 to 2 do
  for I:=Count - 1 downto 0 do
  begin
    SO := TPAXScriptObject(fPaxObjects[I]);
    ClassRec := SO.ClassRec;

    if FreeHost then
      if ClassRec <> ClassList.FunctionClassRec then
      if ClassRec <> ClassList.DelegateClassRec then
      if ClassRec <> ClassList.ObjectClassRec then
      if ClassRec <> ClassList.BooleanClassRec then
      if ClassRec <> ClassList.StringClassRec then
      if ClassRec <> ClassList.NumberClassRec then
      if ClassRec <> ClassList.DateClassRec then
      if ClassRec <> ClassList.ArrayClassRec then
      if ClassRec <> ClassList.ActiveXClassRec then
      if (SO.Instance <> nil) and (SO.RefCount <> -1) then
      if not StrEql(ClassRec.Name, 'TPAXError') then
      begin

        If IsDelphiObject(SO.Instance) then 
          SO.Instance.Free;

        SO.Instance := nil;
      end;

    if SO.PClass = TPAXDelegate then
    begin
      D := TPAXDelegate(SO.Instance);
      if D.SubID >= FirstSymbolCard then
        Delete(I);
    end
    else if SO.ClassRec.ClassID <> FirstSymbolCard then
    begin
{
      if SO.RefCount >= 1 then
      begin
        if SO.Intf <> nil then
        begin
          try
            if IntfRefCount(SO.Intf) > 1 then
              SO.Intf._Release;
          except
            Integer(SO.Intf) := 0;
          end;
        end;
        {
          if IntfRefCount(SO.Intf) > 1 then
            SO.Intf._Release;
        }
//        Delete(I);
//     end;

    end;
  end;
end;

procedure TPAXScriptObjectList.ResetRunStage(FreeHost: Boolean = false);
var
  SO: TPAXScriptObject;
  I, J: Integer;
  S: TPaxBaseScripter;
  ClassList: TPaxClassList;
  ClassRec: TPaxClassRec;
begin
  S := _Scripter;
  ClassList := S.ClassList;

  for J:=1 to 2 do begin
  for I:=Count - 1 downto 0 do
  begin
    SO := TPAXScriptObject(fPaxObjects[I]);
    ClassRec := SO.ClassRec;

    if FreeHost then
    if ClassRec <> ClassList.FunctionClassRec then
    if ClassRec <> ClassList.DelegateClassRec then
    if ClassRec <> ClassList.ObjectClassRec then
    if ClassRec <> ClassList.BooleanClassRec then
    if ClassRec <> ClassList.StringClassRec then
    if ClassRec <> ClassList.NumberClassRec then
    if ClassRec <> ClassList.DateClassRec then
    if ClassRec <> ClassList.ArrayClassRec then
    if ClassRec <> ClassList.ActiveXClassRec then
    if (SO.Instance <> nil) and (SO.RefCount <> -1) then
    if not StrEql(ClassRec.Name, 'TPAXError') then
    begin
      SO.Instance.Free;
      SO.Instance := nil;
    end;

    if SO.RefCount >= 1 then
    begin
//      if SO.ClassRec.ck = ckArray then
//        SO.Instance.Free;
      if (SO.ClassRec.ck = ckInterface) and (SO.Intf <> nil) then
      begin
{
        try
          if IntfRefCount(SO.Intf) = 1 then
          begin
            //SO.Intf := nil;
            Pointer (SO.Intf) := Nil //--jgv
          end
          else
            SO.Intf._Release;
        except
          Pointer(SO.Intf) := nil;
        end;
}
      end;

      SO.CallAutoDestructor;
      Delete(I);
    end;
  end;
  end;
end;

procedure TPAXScriptObjectList.RemoveObject(SO: TPAXScriptObject);
var
  I: Integer;
  tempSO: TPaxScriptObject;
begin
  for I:=Count - 1 downto 0 do
  begin
    tempSO := TPAXScriptObject(fPaxObjects[I]);
    if tempSO._ObjCount = SO._ObjCount then
    begin
      SO.CallAutoDestructor;
      Delete(I);
      Exit;
    end;
  end;
end;

function IsGlobalObject(SO: TPaxScriptObject): Boolean;
var
  SymbolTable: TPaxSymbolTable;
  I: Integer;
  tempSO: TPaxScriptObject;
begin
  SymbolTable := TPaxBaseScripter(SO.Scripter).SymbolTable;
  with SymbolTable do
    for I:= RootNamespaceID to Card do
      if not IsLocal(I) then
        if IsObject(PVariant(Address[I])^) then
        begin
          tempSO := VariantToScriptObject(PVariant(Address[I])^);
          if SO = tempSO then
          begin
            result := true;
            Exit;
          end;
       end;

  if (SO.Instance <> nil) and IsDelphiObject(SO.Instance) then
    if SO.Instance.InheritsFrom(TComponent) then
    begin
      if (SO.Instance as TComponent).Owner <> nil then
        result := true
      else
        result := false;

      Exit;
    end;

  result := false;
end;

procedure TPAXScriptObjectList.RemoveTail(K: Integer; ThreadID: Cardinal = 0);
var
  SO: TPaxScriptObject;
  I: Integer;
begin
  for I := Count - 1 downto K do
  begin
    SO := TPAXScriptObject(fPaxObjects[I]);
    if SO.RefCount = 1 then
    if SO.ThreadID = ThreadID then
    if not IsGlobalObject(SO) then
    begin
      SO.CallAutoDestructor;
      Delete(I);
    end;
  end;
end;

function TPAXScriptObjectList.HasObject(SO: TPAXScriptObject): Boolean;
var
  I: Integer;
  tempSO: TPaxScriptObject;
  ok: Boolean;
begin
  if SO = nil then
  begin
    result := false;
    Exit;
  end;

  ok := false;
  for I:=Count - 1 downto 0 do
  begin
    if TPAXScriptObject(fPaxObjects[I]) = SO then
    begin
      ok := true;
      break;
    end;
  end;

  if not ok then
  begin
    result := false;
    Exit;
  end;

  if not IsDelphiObject(SO) then
  begin
    result := false;
    Exit;
  end;

  for I:=Count - 1 downto 0 do
  begin
    tempSO := TPAXScriptObject(fPaxObjects[I]);
    if tempSO._ObjCount = SO._ObjCount then
    begin
      result := true;
      Exit;
    end;
  end;
  result := false;
end;

procedure TPAXScriptObjectList.RemoveStructure(const V: Variant);
var
  SO: TPAXScriptObject;
begin
  if IsObject(V) then
  begin
    SO := VariantToscriptObject(V);
    if SO.ClassRec.ck = ckStructure then
      RemoveObject(SO);
  end;
end;

function DuplicateObject(const V: Variant): Variant;
var
  SO: TPAXScriptObject;
begin
  if IsObject(V) then
  begin
    SO := VariantToScriptObject(V);
    if SO.ClassRec.ck = ckStructure then
      result := ScriptObjectToVariant(SO.Duplicate)
    else
      result := V;
  end
  else
    result := V;
end;

/////////////// CONVERSIONS ///////////////////////////////

function ToPrimitive(const V: Variant): Variant;
begin
  if IsObject(V) then
    Result := VariantToScriptObject(V).DefaultValue
  else
    result := V;
end;

function ToString(const Value: Variant): String;
var
  P: Integer;
  D: Double;
  SO: TPaxScriptObject;
begin
  if IsObject(Value) then
  begin
    SO := VariantToScriptObject(Value);
    TPaxBaseScripter(SO.Scripter).Visited.Clear;
    Result := SO.ToString;
  end
  else
  begin
    case VarType(Value) of
      varDouble:
      begin
        D := Value;
        if D = NaN then
        begin
          result := 'NaN';
          Exit;
        end
        else if D = Infinity then
        begin
          result := 'infinity';
          Exit;
        end
        else if D = - Infinity then
        begin
          result := '-infinity';
          Exit;
        end;
      end;
{$IFDEF VARIANTS}
     varInt64:
     begin
       result := VarToStr(Value);
       Exit;
     end;
{$ENDIF}
    end;

    result := VarToStr(Value);
    if VarType(Value) = varDouble then
    begin
      P := Pos(',', result);
      if P > 0 then
        result[P] := '.';
    end;
  end;
end;

function ToNumber(const V: Variant): Variant;
var
  S: String;
begin
  case VarType(V) of
    varEmpty: result := NaN;
    varNull: result := 0;
    varInteger, varDouble, varDate: result := V;
{$IFDEF VARIANTS}
     varInt64: result := V;
{$ENDIF}
    varBoolean:
      if V then
        result := 1
      else
        result := 0;
    varString, varOleStr:
       if IsNumericString(V) then
       begin
         S := StringReplace(V, '.', DecimalSeparator, []);
         result := SysUtils.StrToFloat(S);
       end
       else
         result := NaN;
    else
      if IsObject(V) then
        result := ToNumber(VariantToScriptObject(V).DefaultValue)
      else
        result := V;
  end;
end;

function ToDate(const V: Variant): Variant;
var
  D: Double;
begin
  D := DelphiDateTimeToEcmaTime(Now);
  case VarType(V) of
    varDouble: result := V;
    varDate:
    begin
      D := DelphiDateTimeToEcmaTime(V);
      result := D;
    end;
    else
      if IsObject(V) then
        result := ToDate(VariantToScriptObject(V).DefaultValue)
      else
        result := D;
  end;
end;

function ToInt32(const V: Variant): Variant;
var
  N: Variant;
  D: Double;
  I: Integer;
begin
  N := ToNumber(V);
  case VarType(N) of
    varDouble: begin
      D := N;
      if (D = NaN) or (D = NEGATIVE_INFINITY) or (D = POSITIVE_INFINITY) then
        result := 0
      else
      begin
{$IFDEF VARIANTS}
        result := Round(N);
{$ELSE}
        I := Round(N);
        result := I;
{$ENDIF}
      end;
    end;
    varInteger, varByte: Result := N;
{$IFDEF VARIANTS}
    varInt64:
    begin
      I := Round(N);
      result := I;
    end;
{$ENDIF}
  end;
end;

function ToInt64(const V: Variant): Variant;
var
  N: Variant;
  D: Double;
{$IFNDEF VARIANTS}
  I: Integer;
{$ENDIF}
begin
  N := ToNumber(V);
  case VarType(N) of
    varDouble: begin
      D := N;
      if (D = NaN) or (D = NEGATIVE_INFINITY) or (D = POSITIVE_INFINITY) then
        result := 0
      else
      begin
{$IFDEF VARIANTS}
        result := Round(N);
{$ELSE}
        I := Round(N);
        result := I;
{$ENDIF}
      end;
    end;
    varInteger: Result := N;
{$IFDEF VARIANTS}
    varInt64:
      result := N;
{$ENDIF}
  end;
end;

function ToBoolean(const V: Variant): Variant;
begin
  result := true;
  case VarType(V) of
    varEmpty, varNull: result := false;
    varBoolean: result := V;
{$IFDEF VARIANTS}
    varInt64,
{$ENDIF}
    varDouble,varInteger: Result := V<> 0;
    varString, VarOleStr: result := V <> '';
    else if IsObject(V) then
      result := ToBoolean(VariantToScriptObject(V).DefaultValue)
    else
      result := V <> 0;
  end;
end;

function IsNaN(const V: Variant): boolean;
var
  D: Double;
begin
  D := ToNumber(V);
  result := (D = NEGATIVE_INFINITY) or
            (D = POSITIVE_INFINITY) or
            (D = NaN);
end;

function RelationalComparison(const V1, V2: Variant): Variant;
                              //performs x < y comparison
var
  I, L: Integer;
  S1, S2: String;
  P1, P2, N1, N2: Variant;
begin
  P1 := ToPrimitive(V1);
  P2 := ToPrimitive(V2);
  if IsString(P1) and IsString(P2) then
  begin
    S1 := P1;
    S2 := P2;
    if Pos(S1, S2) > 0 then
      result := true
    else if Pos(S2, S1) > 0 then
      result := false
    else
    begin
      L := Length(S1);
      if Length(S2) < L then
        L := Length(S2);
      for I:=1 to L do
       if S1[I] <> S2[I] then
       begin
         if Ord(S1[I]) < Ord(S2[I]) then
           result := true
         else
           result := false;
         Exit;
       end;
      result := false;
    end;
  end
  else
  begin
    N1 := ToNumber(P1);
    N2 := ToNumber(P2);
    if N1 = NaN then
      Exit;
    if N2 = NaN then
      Exit;
    result := N1 < N2;
  end;
end;

function EqualityComparison(const V1, V2: Variant): TBoolean;
var
  T1, T2: Integer;
  SO1, SO2: TPaxScriptObject;
begin
  T1 := VarType(V1);
  T2 := VarType(V2);
  if T1 = T2 then begin
    if T1 = varUndefined then
    begin
      result := true;
      Exit;
    end;
    if T1 = varNull then
    begin
      result := true;
      Exit;
    end;
    if T1 = varScriptObject then
    begin
      SO1 := VariantToScriptObject(V1);
      SO2 := VariantToScriptObject(V2);
      result := SO1.ClassRec = SO2.ClassRec;
      Exit;
    end;
    if IsNumber(V1) then
    begin
      if IsNaN(V1) or IsNan(V2) then
      begin
        result := false;
        Exit;
      end;
      result := V1 = V2;
      Exit;
    end;

    result := V1 = V2;
  end
  else
  begin
    if (T1 = varNull) and (T2 = varUndefined) then
      result := true
    else if (T2 = varNull) and (T1 = varUndefined) then
     result := true
    else if IsNumber(V1) and IsString(V2) then
      result := EqualityComparison(V1, ToNumber(V2))
    else if IsNumber(V2) and IsString(V1) then
      result := EqualityComparison(V2, ToNumber(V1))
    else if IsNumber(V1) and IsBoolean(V2) then
      result := EqualityComparison(V1, ToNumber(V2))
    else if IsNumber(V2) and IsBoolean(V1) then
      result := EqualityComparison(V2, ToNumber(V1))
    else if IsObject(V1) and (IsNumber(V2) or IsBoolean(V2) or IsString(V2)) then
      result := EqualityComparison(ToPrimitive(V1), V2)
    else if IsObject(V2) and (IsNumber(V1) or IsBoolean(V1) or IsString(V1)) then
      result := EqualityComparison(ToPrimitive(V2), V1)
    else if IsNumber(V1) and IsNumber(V2) then
      result := V1 = V2
    else
      result := false;
  end;
end;

function ToObject(const Value: Variant; Scripter: Pointer): Variant;
var
  SO: TPAXScriptObject;
  X: ActiveXObject;
begin
  case VarType(Value) of
    varBoolean:
    begin
      SO := TPAXBaseScripter(Scripter).ClassList.CreateBooleanObject(Value);
      result := ScriptObjectToVariant(SO);
    end;
{$IFDEF VARIANTS}
    varInt64,
{$ENDIF}
    varDouble, varInteger:
    begin
      SO := TPAXBaseScripter(Scripter).ClassList.CreateNumberObject(Value);
      result := ScriptObjectToVariant(SO);
    end;
    varString, varOleStr:
    begin
      SO := TPAXBaseScripter(Scripter).ClassList.CreateStringObject(Value);
      result := ScriptObjectToVariant(SO);
    end;
    varDate:
    begin
      SO := TPAXBaseScripter(Scripter).ClassList.CreateDateObject(Value);
      result := ScriptObjectToVariant(SO);
    end;
    varEmpty: begin end;
    varNull: begin end;
    varDispatch:
    begin
      X := ActiveXObject.Create(Scripter);
      X.D := Value;
      result := ScriptObjectToVariant(DelphiInstanceToScriptObject(X, Scripter));
    end;
    varUnknown:
    begin
    end
    else
    begin
      if IsObject(Value) then
        result := Value
      else
        raise TPAXScriptFailure.Create(errIncompatibleTypes);
    end;
   end;
end;

function StrictEqualityComparison(const V1, V2: Variant): TBoolean;
begin
  if VarType(V1) <> VarType(V2) then
    result := false
  else
    result:= EqualityComparison(V1, V2);
end;

procedure SortVariants(var A: array of Variant);
var
  I, J, N: Integer;
  X: Variant;
begin
  N := Length(A) - 1;
  for I:=1 to N do
    for J:=N downto I do
      if RelationalComparison(A[J], A[J-1]) then
      begin
        X := A[J-1];
        A[J-1] := A[J];
        A[J] := X;
      end;
end;

function StringValueToVariant(const S: String; const Dest: Variant): Variant;
begin
  case VarType(Dest) of
    varString, varOleStr: result := S;
    varInteger: result := toInteger(S);
{$IFDEF VARIANTS}
    varInt64: result := toInt64(S);
{$ENDIF}
    varDouble: result := toNumber(S);
    varEmpty, varNull: result := S;
  else
    raise TPaxScriptFailure.Create(errIncompatibleTypes);
  end;
end;

function UntypedValueToVariant(P: Pointer; Count: Integer; const Dest: Variant): Variant;
var
  PC: PChar;
begin
  case VarType(Dest) of
    varString:
    begin
      PC := StrAlloc(Count + 1);
      Move(P^, PC^, Count);
      result := String(P);
    end;
    varInteger, varDouble:
    case Count of
      1: result := Byte(P^);
      2: result := Word(P^);
      4: result := Integer(P^);
      SizeOf(Double): result := Double(P^);
    end;
{$IFDEF VARIANTS}
    varInt64: result := Int64(P^);
{$ENDIF}
    else
      raise TPaxScriptFailure.Create(errIncompatibleTypes);
  end;
end;

procedure VariantToUntypedValue(const V: Variant; P: Pointer; Count: Integer);
var
  S: String;
begin
  case VarType(V) of
    varInteger:
      Move(TVarData(V).VInteger, P^, Count);
    varDouble:
      Move(TVarData(V).VDouble, P^, Count);
    varBoolean:
      Move(TVarData(V).VBoolean, P^, Count);
    varString:
    begin
      S := V;
      Move(Pointer(S)^, P^, Count);
    end;
{$IFDEF VARIANTS}
    varInt64: Move(TVarData(V).VInt64, P^, Count);
{$ENDIF}
    else
      raise TPaxScriptFailure.Create(errIncompatibleTypes);
  end;
end;

function TVarRecToVariant(const P: TVarRec; Scripter: Pointer): Variant;
var
  Self: TPAXBaseScripter;
begin
  Self := TPAXBaseScripter(Scripter);

  case P.vType of
    vtInteger: result := P.VInteger;
    vtBoolean: result := P.VBoolean;
    vtChar: result := P.VChar + '';
    vtExtended: result := P.VExtended^;
    vtString: result := P.VString^;
    vtPointer: result := Integer(P.VPointer);
    vtPChar: result := String(P.VPChar);
    vtClass: result := ScriptObjectToVariant(DelphiClassToScriptObject(P.VClass, Self));
    vtWideChar: result := P.VWideChar;
    vtPWideChar: result := WideString(P.VPWideChar);
    vtAnsiString: result := String(P.VAnsiString);
    vtCurrency: result := P.VCurrency^;
    vtVariant: result := P.VVariant^;
    vtObject:
      if P.VObject = nil then
        result := Undefined
      else if P.VObject.ClassType = TPAXScriptObject then
        result := ScriptObjectToVariant(TPAXScriptObject(P.VObject))
      else
        result := ScriptObjectToVariant(DelphiInstanceToScriptObject(P.VObject, Self));
    vtInterface: begin end;
    vtWideString: result := WideString(P.VWideString);
{$IFDEF VARIANTS}
    vtInt64: result := P.VInt64^;
{$ELSE}
    vtInt64: result := Integer(P.VInt64^);
{$ENDIF}
  end;
end;

constructor ActiveXObject.Create(Scripter: Pointer);
begin
  TPaxBaseScripter(Scripter).ActiveXObjectList.Add(Self);
end;

end.

