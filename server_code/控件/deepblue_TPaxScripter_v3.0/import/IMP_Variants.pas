{$IFDEF VER140}
  {$DEFINE Delphi6_UP}
{$ENDIF}

{$IFDEF VER150}
  {$DEFINE Delphi6_UP}
{$ENDIF}

unit IMP_Variants;
interface
uses
  Types,
  SysUtils,
  {$IFDEF Delphi6_UP}
    Variants,
  {$ENDIF}
  PaxScripter;

{$IFDEF Delphi6_UP}
procedure RegisterIMP_Variants;
{$ENDIF}

implementation

{$IFDEF Delphi6_UP}
function TCustomVariantType_ReadVarType:TVarType;
begin
  result := TCustomVariantType(_Self).VarType;
end;
procedure RegisterIMP_Variants;
var H: Integer;
begin
  H := RegisterNamespace('Variants', -1);
  RegisterRoutine('function VarType(const V: Variant): TVarType;', @VarType, H);
  RegisterRoutine('function VarAsType(const V: Variant; AVarType: TVarType): Variant;', @VarAsType, H);
  RegisterRoutine('function VarIsType(const V: Variant; AVarType: TVarType): Boolean; overload;', @VarIsType, H);
  RegisterRoutine('function VarIsType(const V: Variant; const AVarTypes: array of TVarType): Boolean; overload;', @VarIsType, H);
  RegisterRoutine('function VarIsByRef(const V: Variant): Boolean;', @VarIsByRef, H);
  RegisterRoutine('function VarIsEmpty(const V: Variant): Boolean;', @VarIsEmpty, H);
  RegisterRoutine('procedure VarCheckEmpty(const V: Variant);', @VarCheckEmpty, H);
  RegisterRoutine('function VarIsNull(const V: Variant): Boolean;', @VarIsNull, H);
  RegisterRoutine('function VarIsClear(const V: Variant): Boolean;', @VarIsClear, H);
  RegisterRoutine('function VarIsCustom(const V: Variant): Boolean;', @VarIsCustom, H);
  RegisterRoutine('function VarIsOrdinal(const V: Variant): Boolean;', @VarIsOrdinal, H);
  RegisterRoutine('function VarIsFloat(const V: Variant): Boolean;', @VarIsFloat, H);
  RegisterRoutine('function VarIsNumeric(const V: Variant): Boolean;', @VarIsNumeric, H);
  RegisterRoutine('function VarIsStr(const V: Variant): Boolean;', @VarIsStr, H);
  RegisterRoutine('function VarToStr(const V: Variant): string;', @VarToStr, H);
  RegisterRoutine('function VarToStrDef(const V: Variant; const ADefault: string): string;', @VarToStrDef, H);
  RegisterRoutine('function VarToWideStr(const V: Variant): WideString;', @VarToWideStr, H);
  RegisterRoutine('function VarToWideStrDef(const V: Variant; const ADefault: WideString): WideString;', @VarToWideStrDef, H);
  RegisterRoutine('function VarToDateTime(const V: Variant): TDateTime;', @VarToDateTime, H);
  RegisterRoutine('function VarFromDateTime(const DateTime: TDateTime): Variant;', @VarFromDateTime, H);
  RegisterRoutine('function VarInRange(const AValue, AMin, AMax: Variant): Boolean;', @VarInRange, H);
  RegisterRoutine('function VarEnsureRange(const AValue, AMin, AMax: Variant): Variant;', @VarEnsureRange, H);
  RegisterRTTIType(TypeInfo(TVariantRelationship));
  RegisterRoutine('function VarSameValue(const A, B: Variant): Boolean;', @VarSameValue, H);
  RegisterRoutine('function VarCompareValue(const A, B: Variant): TVariantRelationship;', @VarCompareValue, H);
  RegisterRoutine('function VarIsEmptyParam(const V: Variant): Boolean;', @VarIsEmptyParam, H);
  RegisterRoutine('function VarIsError(const V: Variant; out AResult: HRESULT): Boolean; overload;', @VarIsError, H);
  RegisterRoutine('function VarIsError(const V: Variant): Boolean; overload;', @VarIsError, H);
  RegisterRoutine('function VarAsError(AResult: HRESULT): Variant;', @VarAsError, H);
  RegisterRoutine('function VarSupports(const V: Variant; const IID: TGUID; out Intf): Boolean; overload;', @VarSupports, H);
  RegisterRoutine('function VarSupports(const V: Variant; const IID: TGUID): Boolean; overload;', @VarSupports, H);
  RegisterRoutine('procedure VarCopyNoInd(var Dest: Variant; const Source: Variant);', @VarCopyNoInd, H);
  RegisterRoutine('function VarIsArray(const A: Variant): Boolean; overload;', @VarIsArray, H);
  RegisterRoutine('function VarIsArray(const A: Variant; AResolveByRef: Boolean): Boolean; overload;', @VarIsArray, H);
  RegisterRoutine('function VarArrayCreate(const Bounds: array of Integer; AVarType: TVarType): Variant;', @VarArrayCreate, H);
  RegisterRoutine('function VarArrayOf(const Values: array of Variant): Variant;', @VarArrayOf, H);
  RegisterRoutine('function VarArrayRef(const A: Variant): Variant;', @VarArrayRef, H);
  RegisterRoutine('function VarTypeIsValidArrayType(const AVarType: TVarType): Boolean;', @VarTypeIsValidArrayType, H);
  RegisterRoutine('function VarTypeIsValidElementType(const AVarType: TVarType): Boolean;', @VarTypeIsValidElementType, H);
  RegisterRoutine('function VarArrayDimCount(const A: Variant): Integer;', @VarArrayDimCount, H);
  RegisterRoutine('function VarArrayLowBound(const A: Variant; Dim: Integer): Integer;', @VarArrayLowBound, H);
  RegisterRoutine('function VarArrayHighBound(const A: Variant; Dim: Integer): Integer;', @VarArrayHighBound, H);
  RegisterRoutine('function VarArrayLock(const A: Variant): Pointer;', @VarArrayLock, H);
  RegisterRoutine('procedure VarArrayUnlock(const A: Variant);', @VarArrayUnlock, H);
  RegisterRoutine('function VarArrayAsPSafeArray(const A: Variant): PVarArray;', @VarArrayAsPSafeArray, H);
  RegisterRoutine('function VarArrayGet(const A: Variant; const Indices: array of Integer): Variant;', @VarArrayGet, H);
  RegisterRoutine('procedure VarArrayPut(var A: Variant; const Value: Variant; const Indices: array of Integer);', @VarArrayPut, H);
  RegisterRoutine('procedure DynArrayToVariant(var V: Variant; const DynArray: Pointer; TypeInfo: Pointer);', @DynArrayToVariant, H);
  RegisterRoutine('procedure DynArrayFromVariant(var DynArray: Pointer; const V: Variant; TypeInfo: Pointer);', @DynArrayFromVariant, H);
  RegisterRoutine('function Unassigned: Variant;', @Unassigned, H);
  RegisterRoutine('function Null: Variant;', @Null, H);
  RegisterRTTIType(TypeInfo(TVarCompareResult));
  // Begin of class TCustomVariantType
  RegisterClassType(TCustomVariantType, H);
  RegisterMethod(TCustomVariantType,
       'constructor Create; overload;',
       @TCustomVariantType.Create);
  RegisterMethod(TCustomVariantType,
       'constructor Create(RequestedVarType: TVarType); overload;',
       @TCustomVariantType.Create);
  RegisterMethod(TCustomVariantType,
       'destructor Destroy; override;',
       @TCustomVariantType.Destroy);
  RegisterMethod(TCustomVariantType,
       'function TCustomVariantType_ReadVarType:TVarType;',
       @TCustomVariantType_ReadVarType, Fake);
  RegisterProperty(TCustomVariantType,
       'property VarType:TVarType read TCustomVariantType_ReadVarType;');
  RegisterMethod(TCustomVariantType,
       'function IsClear(const V: TVarData): Boolean; virtual;',
       @TCustomVariantType.IsClear);
  RegisterMethod(TCustomVariantType,
       'procedure Cast(var Dest: TVarData; const Source: TVarData); virtual;',
       @TCustomVariantType.Cast);
  RegisterMethod(TCustomVariantType,
       'procedure CastTo(var Dest: TVarData; const Source: TVarData;      const AVarType: TVarType); virtual;',
       @TCustomVariantType.CastTo);
  RegisterMethod(TCustomVariantType,
       'procedure CastToOle(var Dest: TVarData; const Source: TVarData); virtual;',
       @TCustomVariantType.CastToOle);
  RegisterMethod(TCustomVariantType,
       'procedure BinaryOp(var Left: TVarData; const Right: TVarData;      const Operator: TVarOp); virtual;',
       @TCustomVariantType.BinaryOp);
  RegisterMethod(TCustomVariantType,
       'procedure UnaryOp(var Right: TVarData; const Operator: TVarOp); virtual;',
       @TCustomVariantType.UnaryOp);
  RegisterMethod(TCustomVariantType,
       'function CompareOp(const Left, Right: TVarData;      const Operator: TVarOp): Boolean; virtual;',
       @TCustomVariantType.CompareOp);
  RegisterMethod(TCustomVariantType,
       'procedure Compare(const Left, Right: TVarData;      var Relationship: TVarCompareResult); virtual;',
       @TCustomVariantType.Compare);
  // End of class TCustomVariantType
  // Begin of class TInvokeableVariantType
  RegisterClassType(TInvokeableVariantType, H);
  RegisterMethod(TInvokeableVariantType,
       'function DoFunction(var Dest: TVarData; const V: TVarData;      const Name: string; const Arguments: TVarDataArray): Boolean; virtual;',
       @TInvokeableVariantType.DoFunction);
  RegisterMethod(TInvokeableVariantType,
       'function DoProcedure(const V: TVarData; const Name: string;      const Arguments: TVarDataArray): Boolean; virtual;',
       @TInvokeableVariantType.DoProcedure);
  RegisterMethod(TInvokeableVariantType,
       'function GetProperty(var Dest: TVarData; const V: TVarData;      const Name: string): Boolean; virtual;',
       @TInvokeableVariantType.GetProperty);
  RegisterMethod(TInvokeableVariantType,
       'function SetProperty(const V: TVarData; const Name: string;      const Value: TVarData): Boolean; virtual;',
       @TInvokeableVariantType.SetProperty);
  // CONSTRUCTOR NOT FOUND!!!
  // End of class TInvokeableVariantType
  RegisterRoutine('function FindCustomVariantType(const AVarType: TVarType;    out CustomVariantType: TCustomVariantType): Boolean; overload;', @FindCustomVariantType, H);
  RegisterRoutine('function FindCustomVariantType(const TypeName: string;    out CustomVariantType: TCustomVariantType): Boolean; overload;', @FindCustomVariantType, H);
  RegisterRoutine('procedure VarCastError; overload;', @VarCastError, H);
  RegisterRoutine('procedure VarCastError(const ASourceType, ADestType: TVarType); overload;', @VarCastError, H);
  RegisterRoutine('procedure VarInvalidOp;', @VarInvalidOp, H);
  RegisterRoutine('procedure VarInvalidNullOp;', @VarInvalidNullOp, H);
  RegisterRoutine('procedure VarOverflowError(const ASourceType, ADestType: TVarType);', @VarOverflowError, H);
  RegisterRoutine('procedure VarRangeCheckError(const ASourceType, ADestType: TVarType);', @VarRangeCheckError, H);
  RegisterRoutine('procedure VarArrayCreateError;', @VarArrayCreateError, H);
  RegisterRoutine('procedure VarResultCheck(AResult: HRESULT); overload;', @VarResultCheck, H);
  RegisterRoutine('procedure VarResultCheck(AResult: HRESULT; ASourceType, ADestType: TVarType); overload;', @VarResultCheck, H);
  RegisterRoutine('procedure HandleConversionException(const ASourceType, ADestType: TVarType);', @HandleConversionException, H);
  RegisterRoutine('function VarTypeAsText(const AType: TVarType): string;', @VarTypeAsText, H);
  RegisterRoutine('function FindVarData(const V: Variant): PVarData;', @FindVarData, H);
  RegisterRTTIType(TypeInfo(TNullCompareRule));
  RegisterRTTIType(TypeInfo(TBooleanToStringRule));
  RegisterVariable('NullAsStringValue', 'STRING',@NullAsStringValue, H);
end;
{$ENDIF}

initialization
{$IFDEF Delphi6_UP}
  RegisterIMP_Variants;
{$ENDIF}

end.

