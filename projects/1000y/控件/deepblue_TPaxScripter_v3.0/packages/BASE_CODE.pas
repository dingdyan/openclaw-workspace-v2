////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_CODE.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////


{$I PaxScript.def}
{$O-}
unit BASE_CODE;

interface

uses
{$IFDEF VARIANTS}
  Variants,
{$ENDIF}
  SysUtils, Classes, Math, TypInfo,
  BASE_CONSTS,
  BASE_SYNC, BASE_CONV,
  BASE_SYS, BASE_SYMBOL, BASE_CLASS, BASE_EXTERN, BASE_CALL;

const
  MaxTryStack = 100;
type
  TProc = procedure of object;

  TPAXDebugInfo = class(TPAXStack)
    procedure PopProc;
  end;

  TPAXTryStackRec = record
    B1, B2: Integer;
  end;

  TPAXTryStack = class
  public
    A: array[1..MaxTryStack] of TPAXTryStackRec;
    Card: Integer;
    constructor Create;
    procedure Clear;
    procedure Push(N1, N2: Integer);
    procedure Pop;
    function Legal(N: Integer): boolean;
  end;

  TPAXBreakpoint = class
  public
    LineNumber: Integer;
    Condition: String;
    PassCount: Integer;
    CurrPassCount: Integer;
    constructor Create(LineNumber: Integer;
                       const Condition: String;
                       PassCount: Integer);
  end;

 TPAXBreakpointList = class(TPAXIndexedList)
 private
   function GetBreakpoint(I: Integer): TPAXBreakpoint;
 public
   procedure InitCurrPassCounts;
   procedure AddBreakpoint(LineNumber: Integer;
                           const Condition: String;
                           PassCount: Integer);
   function RemoveBreakpoint(LineNumber: Integer): Boolean;
   property Breakpoints[I: Integer]: TPAXBreakpoint read GetBreakpoint; default;
 end;

  TPAXCodeRec = record
    Op, Arg1, Arg2, Res, Vars: Integer;
    PP_Res, PP_Arg1, PP_Arg2: Pointer;
    _Entry, _SubID, SaveOP, AltArg1, LinePos: Integer;
    IsExecutable: Boolean;
  end;

  TPAXCode = class
  private
    Base: Variant;
  public
    Scripter: Pointer;
    SymbolTable: TPAXSymbolTable;
    ClassList: TPAXClassList;
    Stack: TPAXFastStack;

    Prog: array of TPAXCodeRec;
    Card: Integer;

    ArrProc: array[- 350..BOUND_OPER] of TProc;

    N, ErrorN: Integer;
    SubRunCount: Integer;

    UsingList: TPAXUsingList;
    WithStack: TPAXWithStack;
    LevelStack: TPAXFastStack;
    TryStack: TPAXTryStack;

    BreakPointList: TPAXBreakpointList;

    DebugState: Boolean;
    DebugInfo: TPAXDebugInfo;

    StateStack: TPAXStack;
    RefStack: TPAXFastStack;

    SignFOP, fTerminated, DeclareON, SignRETURN, SignInitStage: Boolean;

    ResultValue: Variant;
    _ParamCount: Integer;

    CurrRunMode: Integer;

    _This: Variant;

    InitializationList, FinalizationList: TPaxIds;

    UpcaseOn: Boolean;

    SignVBARRAYS: Boolean;
    SignZERO_BASED_STRINGS: Boolean;

    Undefined2: Variant;

    SignHaltGlobal: Boolean;

    AssignedUndeclaredList: TPAXIds;

    IsAborted: Boolean;

    VV: Variant;

    constructor Create(AScripter: Pointer);
    destructor Destroy; override;
    function  GetUpcase(I: Integer): Boolean;
    procedure SetRef(ID: Integer; const V: Variant; ma: TPAXMemberAccess);
    procedure SaveOP;
    function CurrArg1ID: Integer;
    function CurrArg2ID: Integer;
    function CurrResID: Integer;
    function CurrOP: Integer;
    function IsExecutableSourceLine(const ModuleName: String; L: Integer): Boolean;
    procedure SaveToStream(S: TStream; P1, P2: Integer);
    procedure LoadFromStream(S: TStream;
                             DS: Integer = 0; DP: Integer = 0);
    procedure CheckLength;
    procedure Add(InitOp, InitArg1, InitArg2, InitRes: Integer; IsExecutable: Boolean = false);
    procedure GenAt(P: Integer; InitOp, InitArg1, InitArg2, InitRes: Integer; IsExecutable: Boolean = false);
    procedure SetFOP(FOP: Integer; Ex: Boolean = false);
    procedure SaveState;
    procedure RestoreState;
    function FindCreateObjectStmt(TypeID: Integer): Integer;
    function GetLanguageNamespaceID: Integer;
    function GetModuleID(J: Integer): Integer;
    function ModuleID: Integer;
    function LineID: Integer;
    function NextLineID: Integer;
    function IsExecutableLine(I: Integer): Boolean;
    function IsBreakpoint(L: Integer): Boolean;
    procedure Dump(const FileName: String);
    procedure Run(RunMode: Integer = _rmRun; DestLine: Integer = 0);
    function EvalGetFunction(SubID, NParams: Integer): Integer;
    procedure EvalSetProcedure(SubID, NParams: Integer; AValue: Variant);
    procedure CallSub(SubID, ParamCount: Integer; PThis: PVariant; ResultID: Integer; MakeFOP: Boolean = false);
    procedure CallHostSub(D: TPAXMethodDefinition; PThis, PResult: PVariant; ParamCount: Integer);
    function PopVariant: Variant;
    function PopAddress: Pointer;
    function PopInteger: Integer;
    procedure RaiseException;
    procedure Optimization(StartPos, EndPos: Integer);
    procedure LinkGoTo(StartPos, EndPos: Integer);
    procedure RemoveNops;
    procedure ReplaceID(ID1, ID2: Integer);
    procedure InvokeOnChangedVariable;
    function NextOp(var NewN: Integer): Integer;
    function CurrMethodID: Integer;

    procedure InitRunStage;
    procedure ResetRunStage;

    procedure ResetCompileStage;

    procedure OperBinaryOperator;
    procedure OperUnaryOperator;
    procedure OperPrint;

    procedure OperHalt;
    procedure OperHaltGlobal;
    procedure OperHaltOrNop;
    procedure OperNop;
    procedure OperSkip;

    procedure OperPutProperty;
    procedure OperCall;
    procedure OperTypeCast;
    procedure OperPush;
    procedure OperRet;
    procedure OperExit0;
    procedure OperExit;
    procedure OperReturn;
    procedure OperSetLabel;
    procedure OperGetParamCount;
    procedure OperGetParam;
    procedure OperGetPublishedProperty;
    procedure OperPutPublishedProperty;
    procedure OperRetOperator;

    procedure OperExitOnError;
    procedure OperDiscardError;
    procedure OperFinally;
    procedure OperCatch;
    procedure OperTryOn;
    procedure OperTryOff;
    procedure OperThrow;

    procedure OperCreateArray;
    procedure OperDoNotDestroy;
    procedure OperGetItem;
    procedure OperPutItem;
    procedure OperGetItemEx;
    procedure OperPutItemEx;

    procedure OperCreateShortString;

    procedure OperGetField;

    procedure OperGetStringElement;
    procedure OperPutStringElement;

    procedure OperCreateObject;
    procedure OperDestroyHost;
    procedure OperDestroyObject;
    procedure OperDestroyLocalVar;
    procedure OperDestroyIntf;
    procedure OperRelease;
    procedure OperCreateRef;
    procedure OperUseNamespace;
    procedure OperEndOfNamespace;
    procedure OperBeginWith;
    procedure OperEndWith;
    procedure OperEvalWith;
    procedure OperIn;
    procedure OperInSet;
    procedure OperInstanceOf;
    procedure OperTypeOf;
    procedure OperGetNextProp;
    procedure OperSaveResult;
    procedure OperGetAncestorName;

    procedure OperGo;
    procedure OperGoFalse;
    procedure OperGoFalseEx;
    procedure OperGoTrue;
    procedure OperGoTrueEx;

    procedure OperAssign;
    procedure OperSetOwner;
    procedure OperAssignResult;

    procedure OperAssignAddress;
    procedure OperGetTerminal;

    procedure OperAnd;
    procedure OperOr;
    procedure OperXor;
    procedure OperNot;

    procedure OperLeftShift;
    procedure OperLeftShift_Ex;

    procedure OperRightShift;
    procedure OperRightShift_Ex;

    procedure OperUnsignedRightShift;
    procedure OperUnsignedRightShift_Ex;

    procedure OperPlus;
    procedure OperPlus_Ex;

    procedure OperMinus;
    procedure OperMinus_Ex;

    procedure OperUnaryPlus;

    procedure OperUnaryMinus;
    procedure OperUnaryMinusEx;

    procedure OperMult;
    procedure OperMult_Ex;

    procedure OperDiv;
    procedure OperDiv_Ex;

    procedure OperIntDiv;

    procedure OperMod;
    procedure OperMod_Ex;

    procedure OperPower;

    procedure OperLT;
    procedure OperLT_Ex;

    procedure OperGT;
    procedure OperGT_Ex;

    procedure OperLE;
    procedure OperLE_Ex;

    procedure OperGE;
    procedure OperGE_Ex;

    procedure OperEQ;
    procedure OperEQ_Ex;

    procedure OperNE;
    procedure OperNE_Ex;

    procedure OperID;
    procedure OperID_Ex;

    procedure OperNI;
    procedure OperNI_Ex;

    procedure OperIS;
    procedure OperAS;

    procedure OperToInteger;
    procedure OperToString;
    procedure OperToBoolean;

    procedure OperDefine;

    procedure OperDeclareOn;
    procedure OperDeclareOff;

    procedure OperUpcaseOn;
    procedure OperUpcaseOff;

    procedure OperOptimizationOn;
    procedure OperOptimizationOff;

    procedure OperVBArraysOff;
    procedure OperVBArraysOn;

    procedure OperZeroBasedStringsOn;
    procedure OperZeroBasedStringsOff;

    procedure FindUnaryOperator(const Name: String; const V2: Variant);
    procedure FindBinaryOperator(const Name: String; const V1, V2: Variant);

//------------------------------------------

    procedure FOperGoFalse1;
    procedure FOperGoFalse2;
    procedure FOperGoTrue1;
    procedure FOperGoTrue2;
    procedure FOperAssign;

    procedure FOperINC1;
    procedure FOperINC2;

    procedure FOperPlusInteger1;
    procedure FOperPlusInteger2;
    procedure FOperPlusDouble1;
    procedure FOperPlusDouble2;
    procedure FOperPlusString1;
    procedure FOperPlusString2;

    procedure FOperMinusInteger1;
    procedure FOperMinusInteger2;
    procedure FOperMinusDouble1;
    procedure FOperMinusDouble2;

    procedure FOperMultInteger1;
    procedure FOperMultInteger2;
    procedure FOperMultDouble1;
    procedure FOperMultDouble2;

    procedure FOperDivInteger1;
    procedure FOperDivInteger2;
    procedure FOperDivDouble1;
    procedure FOperDivDouble2;

    procedure FOperMod1;
    procedure FOperMod2;

    procedure FOperLTInteger1;
    procedure FOperLTInteger2;
    procedure FOperLTDouble1;
    procedure FOperLTDouble2;

    procedure FOperLEInteger1;
    procedure FOperLEInteger2;
    procedure FOperLEDouble1;
    procedure FOperLEDouble2;

    procedure FOperGTInteger1;
    procedure FOperGTInteger2;
    procedure FOperGTDouble1;
    procedure FOperGTDouble2;

    procedure FOperGEInteger1;
    procedure FOperGEInteger2;
    procedure FOperGEDouble1;
    procedure FOperGEDouble2;

    procedure FOperEQInteger1;
    procedure FOperEQInteger2;
    procedure FOperEQDouble1;
    procedure FOperEQDouble2;

    procedure FOperNEInteger1;
    procedure FOperNEInteger2;
    procedure FOperNEDouble1;
    procedure FOperNEDouble2;

    procedure FOperBitwiseAND1;
    procedure FOperBitwiseAND2;

    procedure FOperBitwiseOR1;
    procedure FOperBitwiseOR2;

    procedure FOperBitwiseXOR1;
    procedure FOperBitwiseXOR2;

    procedure FOperLogicalAND1;
    procedure FOperLogicalAND2;

    procedure FOperLogicalOR1;
    procedure FOperLogicalOR2;

    procedure FOperLogicalXOR1;
    procedure FOperLogicalXOR2;

    procedure FOperBitwiseNOT1;
    procedure FOperBitwiseNOT2;

    procedure FOperLogicalNOT1;
    procedure FOperLogicalNOT2;

    procedure FOperUnaryMinusInteger1;
    procedure FOperUnaryMinusInteger2;
    procedure FOperUnaryMinusDouble1;
    procedure FOperUnaryMinusDouble2;

    procedure FOperSHL1;
    procedure FOperSHL2;

    procedure FOperSHR1;
    procedure FOperSHR2;

    procedure FOperUSHR1;
    procedure FOperUSHR2;

//======================================================================
    procedure FOperPush;

    procedure FOperPlus1;
    procedure FOperPlus2;

    procedure FOperMinus1;
    procedure FOperMinus2;

    procedure FOperMult1;
    procedure FOperMult2;

    procedure FOperDiv1;
    procedure FOperDiv2;

    procedure FOperGT1;
    procedure FOperGT2;

    procedure FOperGE1;
    procedure FOperGE2;

    procedure FOperLT1;
    procedure FOperLT2;

    procedure FOperLE1;
    procedure FOperLE2;

    procedure FOperEQ1;
    procedure FOperEQ2;

    procedure FOperNE1;
    procedure FOperNE2;

    procedure FOperCall;

    property Terminated: Boolean read fTerminated write fTerminated;
  end;

implementation

uses
  BASE_SCRIPTER, BASE_EVENT, BASE_PARSER, BASE_REGEXP;

procedure TPAXDebugInfo.PopProc;
begin
{ Pop; // SubID
  Pop; // N
  ParamCount := Pop;
  for I:=1 to ParamCount do
    Pop;
}
  Dec(Card, 2);
  Dec(Card, fItems[Card] + 1);
end;

constructor TPAXBreakpoint.Create(LineNumber: Integer;
                               const Condition: String;
                               PassCount: Integer);
begin
  Self.LineNumber := LineNumber;
  Self.Condition := Condition;
  Self.PassCount := PassCount;
  CurrPassCount := -1;
end;

function TPAXBreakpointList.GetBreakpoint(I: Integer): TPAXBreakpoint;
begin
  result := TPAXBreakpoint(Objects[I]);
end;

procedure TPAXBreakpointList.InitCurrPassCounts;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    Breakpoints[I].CurrPassCount := -1;
end;

procedure TPAXBreakpointList.AddBreakpoint(LineNumber: Integer;
                                        const Condition: String;
                                        PassCount: Integer);
begin
  AddObject(LineNumber, TPAXBreakpoint.Create(LineNumber, Condition, PassCount));
end;

function TPAXBreakpointList.RemoveBreakpoint(LineNumber: Integer): Boolean;
var
  I: Integer;
begin
  result := false;
  for I:=0 to Count - 1 do
    if Breakpoints[I].LineNumber = LineNumber then
    begin
      result := true;
      DeleteObject(I);
      Exit;
    end;
end;

constructor TPAXTryStack.Create;
begin
  Clear;
  inherited;
end;

procedure TPAXTryStack.Clear;
begin
  Card := 0;
end;

procedure TPAXTryStack.Push(N1, N2: Integer);
begin
  Inc(Card);
  with A[Card] do
  begin
    B1 := N1;
    B2 := N2;
  end;
end;

procedure TPAXTryStack.Pop;
begin
  Dec(Card);
end;

function TPAXTryStack.Legal(N: Integer): boolean;
begin
  with A[Card] do
    result := (N >= B1 ) and (N <= B2);
end;

constructor TPAXCode.Create(AScripter: Pointer);
begin
  SetLength(Prog, FirstProgCard);

  Scripter := AScripter;
  SymbolTable := TPaxBaseScripter(Scripter).SymbolTable;
  ClassList := TPAXBaseScripter(Scripter).ClassList;
  Stack := TPAXFastStack.Create;

  UsingList := TPAXUsingList.Create;
  WithStack := TPAXWithStack.Create;
  TryStack := TPAXTryStack.Create;
  BreakpointList := TPAXBreakpointList.Create;
  LevelStack := TPAXFastStack.Create;
  LevelStack.Push(0);

  DebugState := true;
  DebugInfo := TPAXDebugInfo.Create;
  StateStack := TPAXStack.Create;
  RefStack := TPAXFastStack.Create;
  FinalizationList := TPaxIds.Create(true);
  InitializationList := TPaxIds.Create(true);
  AssignedUndeclaredList := TPAXIds.Create(true);

  SignVBARRAYS := false;

  Card := 0;
  N := 0;
  SubRunCount := 0;

  fTerminated := false;

  DeclareON := true;
  SignFOP := true;
  SignRETURN := false;
  SignInitStage := false;
  SignHaltGlobal := false;

  ArrProc[OP_DECLARE] := OperNop;

  ArrProc[OP_HALT] := OperHalt;
  ArrProc[OP_HALT_GLOBAL] := OperHaltGlobal;
  ArrProc[OP_HALT_OR_NOP] := OperHaltOrNop;
  ArrProc[OP_NOP] := OperNop;
  ArrProc[OP_SKIP] := OperSkip;
  ArrProc[OP_PRINT] := OperPrint;
  ArrProc[OP_PRINT_HTML] := OperPrint;

  ArrProc[OP_PUT_PROPERTY] := OperPutProperty;
  ArrProc[OP_CALL] := OperCall;
  ArrProc[OP_CALL_CONSTRUCTOR] := OperCall; // will be replaced with OP_CALL or OP_TYPE_CAST
  ArrProc[OP_TYPE_CAST] := OperTypeCast;
  ArrProc[OP_PUSH] := OperPush;
  ArrProc[OP_RET] := OperRet;
  ArrProc[OP_EXIT0] := OperExit0;
  ArrProc[OP_EXIT] := OperExit;
  ArrProc[OP_RETURN] := OperReturn;
  ArrProc[OP_SET_LABEL] := OperSetLabel;
  ArrProc[OP_GET_PARAM_COUNT] := OperGetParamCount;
  ArrProc[OP_GET_PARAM] := OperGetParam;
  ArrProc[OP_GET_PUBLISHED_PROPERTY] := OperGetPublishedProperty;
  ArrProc[OP_PUT_PUBLISHED_PROPERTY] := OperPutPublishedProperty;
  ArrProc[OP_RET_OPERATOR] := OperRetOperator;

  ArrProc[OP_BEGIN_METHOD] := OperNop;
  ArrProc[OP_CREATE_ARRAY] := OperCreateArray;
  ArrProc[OP_CREATE_DYNAMIC_ARRAY_TYPE] := OperNop;
  ArrProc[OP_DO_NOT_DESTROY] := OperDoNotDestroy;
  ArrProc[OP_GET_ITEM] := OperGetItem;
  ArrProc[OP_PUT_ITEM] := OperPutItem;
  ArrProc[OP_GET_ITEM_EX] := OperGetItemEx;
  ArrProc[OP_PUT_ITEM_EX] := OperPutItemEx;

  ArrProc[OP_CREATE_SHORT_STRING] := OperCreateShortString;

  ArrProc[OP_GET_FIELD] := OperGetField;

  ArrProc[OP_GET_STRING_ELEMENT] := OperGetStringElement;
  ArrProc[OP_PUT_STRING_ELEMENT] := OperPutStringElement;

  ArrProc[OP_CREATE_OBJECT] := OperCreateObject;
  ArrProc[OP_CREATE_RESULT] := OperCreateObject;
  ArrProc[OP_CHECK_CLASS] := OperNop;
  ArrProc[OP_SET_TYPE] := OperNop;
  ArrProc[OP_DESTROY_HOST] := OperDestroyHost;
  ArrProc[OP_DESTROY_OBJECT] := OperDestroyObject;
  ArrProc[OP_DESTROY_LOCAL_VAR] := OperDestroyLocalVar;
  ArrProc[OP_DESTROY_INTF] := OperDestroyIntf;
  ArrProc[OP_RELEASE] := OperRelease;
  ArrProc[OP_CREATE_REF] := OperCreateRef;
  ArrProc[OP_USE_NAMESPACE] := OperUseNamespace;
  ArrProc[OP_USE_LANGUAGE_NAMESPACE] := OperNop;
  ArrProc[OP_END_OF_NAMESPACE] := OperEndOfNamespace;
  ArrProc[OP_BEGIN_WITH] := OperBeginWith;
  ArrProc[OP_END_WITH] := OperEndWith;
  ArrProc[OP_EVAL_WITH] := OperEvalWith;
  ArrProc[OP_IN] := OperIn;
  ArrProc[OP_IN_SET] := OperInSet;
  ArrProc[OP_INSTANCEOF] := OperInstanceOf;
  ArrProc[OP_TYPEOF] := OperTypeOf;
  ArrProc[OP_GET_NEXT_PROP] := OperGetNextProp;
  ArrProc[OP_SAVE_RESULT] := OperSaveResult;
  ArrProc[OP_GET_ANCESTOR_NAME] := OperGetAncestorName;

  ArrProc[OP_EXIT_ON_ERROR] := OperExitOnError;
  ArrProc[OP_DISCARD_ERROR] := OperDiscardError;
  ArrProc[OP_FINALLY] := OperFinally;
  ArrProc[OP_CATCH] := OperCatch;
  ArrProc[OP_TRY_ON] := OperTryOn;
  ArrProc[OP_TRY_OFF] := OperTryOff;
  ArrProc[OP_THROW] := OperThrow;

  ArrProc[OP_GO] := OperGo;
  ArrProc[OP_GO_FALSE] := OperGoFalse;
  ArrProc[OP_GO_FALSE_EX] := OperGoFalseEx;
  ArrProc[OP_GO_TRUE] := OperGoTrue;
  ArrProc[OP_GO_TRUE_EX] := OperGoTrueEx;

  ArrProc[OP_ASSIGN] := OperAssign;
  ArrProc[OP_ASSIGN_SIMPLE] := OperAssign;
  ArrProc[OP_ASSIGN_RESULT] := OperAssignResult;

  ArrProc[OP_ASSIGN_ADDRESS] := OperAssignAddress;
  ArrProc[OP_GET_TERMINAL] := OperGetTerminal;

  ArrProc[OP_LEFT_SHIFT] := OperLeftShift;
  ArrProc[OP_LEFT_SHIFT_EX] := OperLeftShift_Ex;

  ArrProc[OP_RIGHT_SHIFT] := OperRightShift;
  ArrProc[OP_RIGHT_SHIFT_EX] := OperRightShift_Ex;

  ArrProc[OP_UNSIGNED_RIGHT_SHIFT] := OperUnsignedRightShift;
  ArrProc[OP_UNSIGNED_RIGHT_SHIFT_EX] := OperUnsignedRightShift_Ex;

  ArrProc[OP_AND] := OperAnd;
  ArrProc[OP_OR] := OperOr;
  ArrProc[OP_XOR] := OperXor;
  ArrProc[OP_NOT] := OperNot;

  ArrProc[OP_PLUS] := OperPlus;
  ArrProc[OP_PLUS_EX] := OperPlus_Ex;

  ArrProc[OP_MINUS] := OperMinus;
  ArrProc[OP_MINUS_EX] := OperMinus_Ex;

  ArrProc[OP_UNARY_MINUS] := OperUnaryMinus;
  ArrProc[OP_UNARY_MINUS_EX] := OperUnaryMinusEx;

  ArrProc[OP_UNARY_PLUS] := OperUnaryPlus;

  ArrProc[OP_MULT] := OperMult;
  ArrProc[OP_MULT_EX] := OperMult_Ex;

  ArrProc[OP_DIV] := OperDiv;
  ArrProc[OP_DIV_EX] := OperDiv_Ex;

  ArrProc[OP_INT_DIV] := OperIntDiv;

  ArrProc[OP_MOD] := OperMod;
  ArrProc[OP_MOD_EX] := OperMod_Ex;

  ArrProc[OP_POWER] := OperPower;

  ArrProc[OP_LT] := OperLT;
  ArrProc[OP_LT_EX] := OperLT_Ex;

  ArrProc[OP_GT] := OperGT;
  ArrProc[OP_GT_EX] := OperGT_Ex;

  ArrProc[OP_LE] := OperLE;
  ArrProc[OP_LE_EX] := OperLE_Ex;

  ArrProc[OP_GE] := OperGE;
  ArrProc[OP_GE_EX] := OperGE_Ex;

  ArrProc[OP_EQ] := OperEQ;
  ArrProc[OP_EQ_EX] := OperEQ_Ex;

  ArrProc[OP_NE] := OperNE;
  ArrProc[OP_NE_EX] := OperNE_Ex;

  ArrProc[OP_ID] := OperID;
  ArrProc[OP_ID_EX] := OperID_Ex;

  ArrProc[OP_NI] := OperNI;
  ArrProc[OP_NI_EX] := OperNI_Ex;

  ArrProc[OP_TO_INTEGER] := OperToInteger;
  ArrProc[OP_TO_STRING] := OperToString;
  ArrProc[OP_TO_BOOLEAN] := OperToBoolean;

  ArrProc[OP_DEFINE] := OperDefine;

  ArrProc[OP_DECLARE_ON] := OperDeclareOn;
  ArrProc[OP_DECLARE_OFF] := OperDeclareOff;

  ArrProc[OP_UPCASE_ON] := OperUpcaseOn;
  ArrProc[OP_UPCASE_OFF] := OperUpcaseOff;

  ArrProc[OP_OPTIMIZATION_ON] := OperOptimizationOn;
  ArrProc[OP_OPTIMIZATION_OFF] := OperOptimizationOff;

  ArrProc[OP_JS_OPERS_ON] := OperNop;
  ArrProc[OP_JS_OPERS_OFF] := OperNop;

  ArrProc[OP_ZERO_BASED_STRINGS_ON] := OperZeroBasedStringsOn;
  ArrProc[OP_ZERO_BASED_STRINGS_OFF] := OperZeroBasedStringsOff;

  ArrProc[OP_VBARRAYS_ON] := OperVBArraysOn;
  ArrProc[OP_VBARRAYS_OFF] := OperVBArraysOff;

  ArrProc[OP_IS] := OperIS;
  ArrProc[OP_AS] := OperAS;


//--------------------------------------------


  ArrProc[FOP_GO_FALSE1] := FOperGoFalse1;
  ArrProc[FOP_GO_FALSE2] := FOperGoFalse2;

  ArrProc[FOP_GO_TRUE1] := FOperGoTrue1;
  ArrProc[FOP_GO_TRUE2] := FOperGoTrue2;

  ArrProc[FOP_ASSIGN] := FOperAssign;

  ArrProc[FOP_INC1] := FOperInc1;
  ArrProc[FOP_INC2] := FOperInc2;

  ArrProc[FOP_PLUS_INTEGER1] := FOperPlusInteger1;
  ArrProc[FOP_PLUS_INTEGER2] := FOperPlusInteger2;
  ArrProc[FOP_PLUS_DOUBLE1] := FOperPlusDouble1;
  ArrProc[FOP_PLUS_DOUBLE2] := FOperPlusDouble2;
  ArrProc[FOP_PLUS_STRING1] := FOperPlusString1;
  ArrProc[FOP_PLUS_STRING2] := FOperPlusString2;

  ArrProc[FOP_MINUS_INTEGER1] := FOperMinusInteger1;
  ArrProc[FOP_MINUS_INTEGER2] := FOperMinusInteger2;
  ArrProc[FOP_MINUS_DOUBLE1] := FOperMinusDouble1;
  ArrProc[FOP_MINUS_DOUBLE2] := FOperMinusDouble2;

  ArrProc[FOP_MULT_INTEGER1] := FOperMultInteger1;
  ArrProc[FOP_MULT_INTEGER2] := FOperMultInteger2;
  ArrProc[FOP_MULT_DOUBLE1] := FOperMultDouble1;
  ArrProc[FOP_MULT_DOUBLE2] := FOperMultDouble2;

  ArrProc[FOP_DIV_INTEGER1] := FOperDivInteger1;
  ArrProc[FOP_DIV_INTEGER2] := FOperDivInteger2;
  ArrProc[FOP_DIV_DOUBLE1] := FOperDivDouble1;
  ArrProc[FOP_DIV_DOUBLE2] := FOperDivDouble2;

  ArrProc[FOP_MOD1] := FOperMod1;
  ArrProc[FOP_MOD2] := FOperMod2;

  ArrProc[FOP_LT_INTEGER1] := FOperLTInteger1;
  ArrProc[FOP_LT_INTEGER2] := FOperLTInteger2;
  ArrProc[FOP_LT_DOUBLE1] := FOperLTDouble1;
  ArrProc[FOP_LT_DOUBLE2] := FOperLTDouble2;

  ArrProc[FOP_LE_INTEGER1] := FOperLEInteger1;
  ArrProc[FOP_LE_INTEGER2] := FOperLEInteger2;
  ArrProc[FOP_LE_DOUBLE1] := FOperLEDouble1;
  ArrProc[FOP_LE_DOUBLE2] := FOperLEDouble2;

  ArrProc[FOP_GT_INTEGER1] := FOperGTInteger1;
  ArrProc[FOP_GT_INTEGER2] := FOperGTInteger2;
  ArrProc[FOP_GT_DOUBLE1] := FOperGTDouble1;
  ArrProc[FOP_GT_DOUBLE2] := FOperGTDouble2;

  ArrProc[FOP_GE_INTEGER1] := FOperGEInteger1;
  ArrProc[FOP_GE_INTEGER2] := FOperGEInteger2;
  ArrProc[FOP_GE_DOUBLE1] := FOperGEDouble1;
  ArrProc[FOP_GE_DOUBLE2] := FOperGEDouble2;

  ArrProc[FOP_EQ_INTEGER1] := FOperEQInteger1;
  ArrProc[FOP_EQ_INTEGER2] := FOperEQInteger2;
  ArrProc[FOP_EQ_DOUBLE1] := FOperEQDouble1;
  ArrProc[FOP_EQ_DOUBLE2] := FOperEQDouble2;

  ArrProc[FOP_NE_INTEGER1] := FOperNEInteger1;
  ArrProc[FOP_NE_INTEGER2] := FOperNEInteger2;
  ArrProc[FOP_NE_DOUBLE1] := FOperNEDouble1;
  ArrProc[FOP_NE_DOUBLE2] := FOperNEDouble2;

  ArrProc[FOP_BITWISE_AND1] := FOperBitwiseAND1;
  ArrProc[FOP_BITWISE_AND2] := FOperBitwiseAND2;

  ArrProc[FOP_BITWISE_OR1] := FOperBitwiseOR1;
  ArrProc[FOP_BITWISE_OR2] := FOperBitwiseOR2;

  ArrProc[FOP_BITWISE_XOR1] := FOperBitwiseXOR1;
  ArrProc[FOP_BITWISE_XOR2] := FOperBitwiseXOR2;

  ArrProc[FOP_LOGICAL_AND1] := FOperLogicalAND1;
  ArrProc[FOP_LOGICAL_AND2] := FOperLogicalAND2;

  ArrProc[FOP_LOGICAL_OR1] := FOperLogicalOR1;
  ArrProc[FOP_LOGICAL_OR2] := FOperLogicalOR2;

  ArrProc[FOP_LOGICAL_XOR1] := FOperLogicalXOR1;
  ArrProc[FOP_LOGICAL_XOR2] := FOperLogicalXOR2;

  ArrProc[FOP_BITWISE_NOT1] := FOperBitwiseNOT1;
  ArrProc[FOP_BITWISE_NOT2] := FOperBitwiseNOT2;

  ArrProc[FOP_LOGICAL_NOT1] := FOperLogicalNOT1;
  ArrProc[FOP_LOGICAL_NOT2] := FOperLogicalNOT2;

  ArrProc[FOP_UNARY_MINUS_INTEGER1] := FOperUnaryMinusInteger1;
  ArrProc[FOP_UNARY_MINUS_INTEGER2] := FOperUnaryMinusInteger2;
  ArrProc[FOP_UNARY_MINUS_DOUBLE1] := FOperUnaryMinusDouble1;
  ArrProc[FOP_UNARY_MINUS_DOUBLE2] := FOperUnaryMinusDouble2;

  ArrProc[FOP_SHL1] := FOperSHL1;
  ArrProc[FOP_SHL2] := FOperSHL2;

  ArrProc[FOP_SHR1] := FOperSHR1;
  ArrProc[FOP_SHR2] := FOperSHR2;

  ArrProc[FOP_USHR1] := FOperUSHR1;
  ArrProc[FOP_USHR2] := FOperUSHR2;

//======================================================================

  ArrProc[FOP_PUSH] := FOperPush;
  ArrProc[FOP_CALL] := FOperCall;

  ArrProc[FOP_PLUS1] := FOperPlus1;
  ArrProc[FOP_PLUS2] := FOperPlus2;

  ArrProc[FOP_MINUS1] := FOperMinus1;
  ArrProc[FOP_MINUS2] := FOperMinus2;

  ArrProc[FOP_MULT1] := FOperMult1;
  ArrProc[FOP_MULT2] := FOperMult2;

  ArrProc[FOP_DIV1] := FOperDiv1;
  ArrProc[FOP_DIV2] := FOperDiv2;

  ArrProc[FOP_LT1] := FOperLT1;
  ArrProc[FOP_LT2] := FOperLT2;

  ArrProc[FOP_LE1] := FOperLE1;
  ArrProc[FOP_LE2] := FOperLE2;

  ArrProc[FOP_GT1] := FOperGT1;
  ArrProc[FOP_GT2] := FOperGT2;

  ArrProc[FOP_GE1] := FOperGE1;
  ArrProc[FOP_GE2] := FOperGE2;

  ArrProc[FOP_EQ1] := FOperEQ1;
  ArrProc[FOP_EQ2] := FOperEQ2;

  ArrProc[FOP_NE1] := FOperNE1;
  ArrProc[FOP_NE2] := FOperNE2;

  ArrProc[OP_ON_USES] := OperNop;
end;

destructor TPAXCode.Destroy;
begin
  UsingList.Free;
  WithStack.Free;
  TryStack.Free;
  BreakPointList.Free;
  LevelStack.Free;
  DebugInfo.Free;
  StateStack.Free;
  RefStack.Free;
  Stack.Free;
  InitializationList.Free;
  FinalizationList.Free;
  AssignedUndeclaredList.Free;

  inherited;
end;

function TPAXCode.NextOp(var NewN: Integer): Integer;
begin
  NewN := N + 1;
  while Prog[NewN].Op = OP_SEPARATOR do
    Inc(NewN);
  result := Prog[NewN].Op;
end;

procedure TPAXCode.SetRef(ID: Integer; const V: Variant; ma: TPAXMemberAccess);
var
  O: Variant;
  ClassRec: TPAXClassRec;
begin
  if VarType(V) = varScriptObject then
  begin
    SymbolTable.SetReference(ID, V, ma);
    ClassRec := VariantToScriptObject(V).ClassRec;
  end
  else
  begin
    O := ToObject(V, Scripter);
    SymbolTable.SetReference(ID, O, ma);
    ClassRec := VariantToScriptObject(O).ClassRec;
  end;

  if ClassRec.ck = ckEnum then
    SymbolTable.PType[ID] := ClassRec.ClassID;
end;

procedure TPAXCode.ResetCompileStage;
var
  I, L: Integer;
begin
  UsingList.Clear;
  WithStack.Clear;
  TryStack.Clear;
  BreakpointList.Clear;
  LevelStack.Clear;
  LevelStack.Push(0);

  DebugInfo.Clear;
  StateStack.Clear;
  RefStack.Clear;
  Stack.Clear;

  DebugState := true;
  Card := 0;
  N := 0;
  SubRunCount := 0;
  SignHaltGlobal := false;

  InitializationList.Clear;
  FinalizationList.Clear;
  AssignedUndeclaredList.Clear;

  L := Length(Prog);
  for I:=0 to L - 1 do
    FillChar(Prog[I], SizeOf(TPaxCodeRec), 0);
end;

function TPAXCode.CurrArg1ID: Integer;
begin
  result := Prog[Card].Arg1;
end;

function TPAXCode.CurrArg2ID: Integer;
begin
  result := Prog[Card].Arg2;
end;

function TPAXCode.CurrResID: Integer;
begin
  result := Prog[Card].Res;
end;

function TPAXCode.CurrOP: Integer;
begin
  result := Prog[Card].OP;
end;

procedure TPAXCode.SaveOP;
var
  I: Integer;
begin
  for I:=1 to Card do
  with Prog[I] do
    SaveOP := OP;
end;

function TPAXCode.GetLanguageNamespaceID: Integer;
var
  I: Integer;
begin
  I := N;
  while Prog[I].Op <> OP_USE_LANGUAGE_NAMESPACE do
    Dec(I);
  result := Prog[I].Arg1;
end;

procedure TPAXCode.SaveToStream(S: TStream; P1, P2: Integer);
var
  I: Integer;
  TypeName, ElTypeName: String;
  FullName, ModuleName, FileName, LanguageName: String;
  TypeNameIndex: Integer;
begin
  SaveInteger(P1, S);
  SaveInteger(P2, S);

  for I:=P1 to P2 do
  with Prog[I] do
  begin
    SaveInteger(SaveOP, S);
    SaveInteger(Arg1, S);
    SaveInteger(Arg2, S);
    SaveInteger(Res, S);
    SaveInteger(Vars, S);
    SaveInteger(AltArg1, S);
    SaveInteger(Integer(IsExecutable), S);

    if AltArg1 < 0 then
    begin
      FullName := DefinitionList.GetFullName(-AltArg1);
      SaveString(FullName, S);
    end;

    if (Op = OP_CREATE_DYNAMIC_ARRAY_TYPE) then
    begin
      TypeName := SymbolTable.Name[Arg1];
      ElTypeName := SymbolTable.Name[Arg2];
      SaveString(TypeName, S);
      SaveString(ElTypeName, S);
    end
    else if (Op = OP_ON_USES) then
    begin
      ModuleName := SymbolTable.Name[Arg1];
      FileName := SymbolTable.Name[Arg2];
      SaveString(ModuleName, S);
      SaveString(FileName, S);
      SaveString(LanguageName, S);
    end
    else if (Op = OP_USE_NAMESPACE) then
    begin
      TypeName := SymbolTable.Name[Arg1];
      SaveString(TypeName, S);
    end
    else if (Op = OP_SET_TYPE) then
    begin
      TypeNameIndex := Arg2;
      TypeName := TPaxBaseScripter(scripter).NameList[TypeNameIndex];
      SaveString(TypeName, S);
    end;

  end;

  InitializationList.SaveToStream(S);
  FinalizationList.SaveToStream(S);
end;

procedure TPAXCode.LoadFromStream(S: TStream;
                                  DS: Integer = 0; DP: Integer = 0);
var
  I, P1, P2, RootID: Integer;
  Shift: Boolean;
  TypeName, ElTypeName: String;
  ClassDef: TPaxClassDefinition;
  Str, ModuleName, FileName, FullName, LanguageName: String;
  D: TPaxDefinition;
  ClassRec: TPaxClassRec;
  TypeNameIndex: Integer;
begin
  Shift := (DS <> 0) or (DP <> 0);

  RootID := SymbolTable.RootNamespaceID;

  P1 := LoadInteger(S);
  P2 := LoadInteger(S);

  Inc(Card, P2 - P1 + 1);

  CheckLength;

  for I:=P1 + DP to P2 + DP do
  with Prog[I] do
  begin
    OP := LoadInteger(S);
    Arg1 := LoadInteger(S);
    Arg2 := LoadInteger(S);
    Res := LoadInteger(S);
    Vars := LoadInteger(S);
    AltArg1 := LoadInteger(S);
    IsExecutable := Boolean(LoadInteger(S));

    if AltArg1 < 0 then
    begin
      FullName := LoadString(S);
      D := DefinitionList.LookupFullName(FullName);
      if D <> nil then
        AltArg1 := -D.Index;
    end;

    SaveOP := OP;

    if Shift then
    begin
      if (Op = OP_GO) or (Op = OP_GO_FALSE) or (Op = OP_GO_FALSE_EX) or (Op = OP_TRY_ON) or
                          (Op = OP_GO_TRUE) or (Op = OP_GO_TRUE_EX) or
         ((Op = OP_EXIT) and (Arg1 > 0)) then
         begin
           Inc(Arg1, DP);
           if Arg2 > RootID then
             Inc(Arg2, DS);
         end
         else if OP <> OP_SEPARATOR then
         begin
           if Arg1 > RootID then
             Inc(Arg1, DS);
           if Arg2 > RootID then
             if (Op <> OP_CALL) and
                (Op <> OP_CREATE_REF) and
                (Op <> OP_PUT_PROPERTY) and
                (Op <> OP_CREATE_ARRAY) then
               Inc(Arg2, DS);
           if Res > RootID then
             Inc(Res, DS);
         end;
    end;

    begin
       if (Op = OP_CREATE_DYNAMIC_ARRAY_TYPE) then
       begin
         TypeName := LoadString(S);
         ElTypeName := LoadString(S);

         try
           _BeginWrite;
           ClassDef := DefinitionList.AddDynamicArrayType(TypeName, ElTypeName, nil);
           ClassDef.AddToScripter(Scripter);
           
         finally
           _EndWrite;
         end;
       end
       else if (Op = OP_ON_USES) then
       begin
         ModuleName := LoadString(S);
         FileName := LoadString(S);
         LanguageName := LoadString(S);

         with TPaxBaseScripter(Scripter) do
         if Assigned(OnUsedModule) then
         begin
           OnUsedModule(scripter, ModuleName, FileName, Str);
           AddExtraModule(ModuleName, Str, true, LanguageName);
         end;
       end
       else if (Op = OP_USE_NAMESPACE) then
       begin
         TypeName := LoadString(S);
         ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(TypeName);
         if ClassRec <> nil then
           Arg1 := ClassRec.ClassId;
       end
       else if (Op = OP_SET_TYPE) then
       begin
         TypeName := LoadString(S);
         ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(TypeName);
         if ClassRec <> nil then
         begin
           TypeNameIndex := TPaxBaseScripter(scripter).NameList.Add(TypeName);
           Arg2 := TypeNameIndex;
           SymbolTable.CheckLength(Arg1);
           SymbolTable.TypeNameIndex[Arg1] := Arg2;
         end;
       end;
    end;
  end;

  P1 := InitializationList.Count;
  InitializationList.LoadFromStream(S);
  P2 := InitializationList.Count;
  for I:=P1 to P2 - 1 do
    InitializationList[I] := InitializationList[I] + DP;

  P1 := FinalizationList.Count;
  FinalizationList.LoadFromStream(S);
  P2 := FinalizationList.Count;
  for I:=P1 to P2 - 1 do
    FinalizationList[I] := FinalizationList[I] + DP;
end;

function TPAXCode.PopVariant: Variant;
begin
//  result := Variant(Stack.PopPointer^);
  result := GetTerminal(Stack.PopPointer)^;
end;

function TPAXCode.PopAddress: Pointer;
begin
  with Stack do
  begin
    result := Pointer(fItems[Card]);
    Dec(Card);
  end;
end;

function TPAXCode.PopInteger: Integer;
begin
//  result := TVarData(Variant(PopAddress^)).VInteger;
  result := TVarData(GetTerminal(PopAddress)^).VInteger;
end;

procedure TPAXCode.SaveState;
begin
  StateStack.Push(N);
  StateStack.Push(Card);
  StateStack.Push(Integer(SignFOP));
  StateStack.Push(Integer(fTerminated));
  StateStack.Push(Integer(DeclareON));
  StateStack.Push(Integer(SignInitStage));
//  StateStack.Push(Stack.Card);
//  StateStack.Push(LevelStack.Card);
end;

procedure TPAXCode.RestoreState;
begin
//  LevelStack.Card := StateStack.Pop;
//  Stack.Card := StateStack.Pop;
  SignInitStage := Boolean(StateStack.Pop);
  DeclareON := Boolean(StateStack.Pop);
  fTerminated := Boolean(StateStack.Pop);
  SignFOP := Boolean(StateStack.Pop);
  Card := StateStack.Pop;
  N := StateStack.Pop;
end;

procedure TPAXCode.CheckLength;
var
  L: Integer;
begin
  L := Length(Prog);
  if L < Card + 10 then
    SetLength(Prog, Card + DeltaProgCard);
end;

procedure TPAXCode.Add(InitOp, InitArg1, InitArg2, InitRes: Integer; IsExecutable: Boolean = false);
begin
  CheckLength;

  Inc(Card);

  with Prog[Card] do
  begin
    Op := InitOp;
    Arg1 := InitArg1;
    Arg2 := InitArg2;
    Res := InitRes;
    SaveOP := InitOP;
    AltArg1 := 0;
  end;
  Prog[Card].IsExecutable := IsExecutable;
end;

procedure TPAXCode.GenAt(P: Integer; InitOp, InitArg1, InitArg2, InitRes: Integer; IsExecutable: Boolean = false);
begin
  with Prog[P] do
  begin
    Op := InitOp;
    Arg1 := InitArg1;
    Arg2 := InitArg2;
    Res := InitRes;
    SaveOP := InitOP;
    AltArg1 := 0;
  end;
  Prog[P].IsExecutable := IsExecutable;
end;

procedure TPAXCode.OperHalt;
begin
  fTerminated := true;
end;

procedure TPAXCode.OperHaltGlobal;
begin
  fTerminated := true;
  SignHaltGlobal := true;
end;

procedure TPAXCode.OperHaltOrNop;
begin
  if SignInitStage then
    fTerminated := true
  else
    Inc(N);
end;

procedure TPAXCode.OperNop;
begin
  Inc(N);
  while Prog[N].Op = OP_NOP do
    Inc(N);
end;

procedure TPAXCode.OperSkip;
begin
  Inc(N);
end;

procedure TPAXCode.OperDefine;
begin
  with TPaxBaseScripter(Scripter) do
    if Assigned(OnDefine) then
        with SymbolTable, Prog[N] do
           OnDefine(Owner, GetVariant(Arg1));
  Inc(N);
end;

function  TPAXCode.GetUpcase(I: Integer): Boolean;
var
  J: Integer;
begin
  result := true;
  for J:=I downto 1 do
    if Prog[J].Op = OP_UPCASE_ON then
      Exit
    else if Prog[J].Op = OP_UPCASE_OFF then
    begin
      result := false;
      Exit;
    end;
end;

procedure TPAXCode.OperDeclareOn;
begin
  DeclareOn := true;
  Inc(N);
end;

procedure TPAXCode.OperDeclareOff;
begin
  DeclareOn := false;
  Inc(N);
end;

procedure TPAXCode.OperUpcaseOn;
begin
  UpcaseOn := true;
  Inc(N);
end;

procedure TPAXCode.OperUpcaseOff;
begin
  UpcaseOn := false;
  Inc(N);
end;

procedure TPAXCode.OperOptimizationOn;
begin
  SignFOP := true;
  Inc(N);
end;

procedure TPAXCode.OperOptimizationOff;
begin
  SignFOP := false;
  Inc(N);
end;

procedure TPAXCode.OperVBArraysOff;
begin
  SignVBARRAYS := false;
  Inc(N);
end;

procedure TPAXCode.OperVBArraysOn;
begin
  SignVBARRAYS := true;
  Inc(N);
end;

procedure TPAXCode.OperZeroBasedStringsOn;
begin
  SignZERO_BASED_STRINGS := true;
  Inc(N);
end;

procedure TPAXCode.OperZeroBasedStringsOff;
begin
  SignZERO_BASED_STRINGS := false;
  Inc(N);
end;

procedure TPAXCode.OperPrint;
var
  S: String;
  V: Variant;
begin
  V := SymbolTable.VariantValue[Prog[N].Arg1];
  S := ToStr(Scripter, V);
  with TPAXBaseScripter(Scripter) do
    if Assigned(OnPrint) then
      OnPrint(Owner, S)
    else
      ErrMessageBox(S);
  Inc(N);
end;

procedure TPAXCode.OperPush;
var
  SO: TPaxScriptObject;
  P: Pointer;
  V: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    case Kind[Arg1] of
      KindRef:
      begin
        SO := VariantToScriptObject(GetVariant(Arg1));
        P := SO.GetAddress(NameIndex[Arg1], 0);
        if P <> nil then
          Stack.Push(P)
        else
        begin
          V := VariantValue[Arg1];
          PutVariant(Arg1, V);
          Kind[Arg1] := KindVAR;
          Stack.Push(Address[Arg1]);
        end;
      end;
      KindHostVar:
        Stack.Push(GetAddressEx(Arg1));
      KindHostConst:
        Stack.Push(GetAddressEx(Arg1));
      KindHostObject:
        Stack.Push(GetAddressEx(Arg1));
      KindHostInterfaceVar:
        Stack.Push(GetAddressEx(Arg1));
      else
      begin
         if (Arg1 > 0) and SignFOP and (not IsAlias(Address[Arg1])) then
          begin
            PP_Arg1 := @A[Arg1].Address;
            OP := FOP_PUSH;
          end;
          Stack.Push(Address[Arg1]);
      end;
    end;
  end;

  Inc(N);
end;

procedure TPAXCode.CallSub(SubID, ParamCount: Integer; PThis: PVariant; ResultID: Integer;
                           MakeFOP: Boolean = false);
var
  I, K, ParamID, NP, BoundID: Integer;
  P: Pointer;
  SO: TPAXScriptObject;
  FInstance: TPAXDelegate;
  Entry, T: Integer;
begin
  K := 0;

  _ParamCount := ParamCount;

  if (Prog[N]._Entry = 0) or (not SignFOP) then
  begin
    if SubID < 0 then
    begin
        if IsObject(PThis^) then
          CallHostSub(DefinitionList[-SubID],
                    PThis,
                    SymbolTable.Address[ResultID], ParamCount)
        else
          CallHostSub(DefinitionList[-SubID],
                    SymbolTable.Address[SymbolTable.RootNamespaceID],
                    SymbolTable.Address[ResultID], ParamCount);
      Exit;
    end;

    SO := VariantToScriptObject(SymbolTable.VariantValue[SubID]);

    if SO.Instance = nil then
      raise TPAXScriptFailure.Create(Format(errFunctionNotFound, [SymbolTable.Name[SubID]]));

    FInstance := TPAXDelegate(SO.Instance);
    SubID := FInstance.SubID;
    Entry := FInstance.N;

    if FInstance.D <> nil then
    begin
      CallHostSub(FInstance.D, PThis, SymbolTable.A[ResultID].Address, ParamCount);
      Exit;
    end;

    if SubID = 0 then
      raise TPAXScriptFailure.Create(Format(errFunctionNotFound, [SymbolTable.Name[SubID]]));

    Prog[N]._Entry := Entry;
    Prog[N]._SubID := SubID;

    if MakeFOP and SignFOP then
      Prog[N].Op := FOP_CALL;
  end
  else
  with Prog[N] do
  begin
    Entry := _Entry;
    SubID := _SubID;
  end;

  with SymbolTable do
  begin
    NP := A[SubID].Count;

    if NP > ParamCount then
    begin
      BoundID := GetParamID(SubID, ParamCount);
      I := TPaxBaseScripter(Scripter).DefaultParameterList.FindFirst(SubID);
      while I <> -1 do
      begin
        if TPaxBaseScripter(Scripter).DefaultParameterList[I].ID > BoundID then
        begin
          Inc(ParamCount);
          Stack.Push(@ TPaxBaseScripter(Scripter).DefaultParameterList[I].Value);
        end;
        I := TPaxBaseScripter(Scripter).DefaultParameterList.FindNext(I, SubID);
      end;
      if NP > ParamCount then
      begin
        if DeclareON then raise TPAXScriptFailure.Create(errNotEnoughParameters);
      end
      else if NP < ParamCount then
      begin
        if DeclareON then raise TPAXScriptFailure.Create(errTooManyParameters);
      end
    end
    else if NP < ParamCount then
    begin
      if DeclareON then raise TPAXScriptFailure.Create(errTooManyParameters);
    end;

    AllocateSub(SubID);
    ParamID := GetParamID(SubID, ParamCount);
    for I:=ParamCount downto 1 do
    begin
      P := Stack.PopPointer;
      T := PType[ParamID];

      if ByRef[ParamID] > 0 then
      begin
        Inc(K);
        RefStack.Push(A[ParamID].Address);
        RefStack.Push(ParamID);

        A[ParamID].Address := P;
        if ByRef[ParamID] = 1 then
        if not TestBit(Prog[N].Vars, I) then
          raise TPAXScriptFailure.Create(errIncorrectUsageOfRefParameter + ' ' + Name[ParamID] +
                ' of method ' + Name[SubID]);

        if T = typeDOUBLE then
          if Rank[ParamID] = 0 then
             Variant(A[ParamID].Address^) := Double(Variant(P^));
      end
      else
      begin
        if (T = typeDOUBLE) and (Rank[ParamID] = 0) then
        begin
           if IsObject(Variant(P^)) then
             Variant(A[ParamID].Address^) := Variant(P^)
           else
             Variant(A[ParamID].Address^) := Double(Variant(P^));
        end
        else
          Variant(A[ParamID].Address^) := Variant(P^);
      end;

      if DebugState then
        DebugInfo.Push(P);
      Dec(ParamID);
    end;

    if DebugState then
    with DebugInfo do
    begin
      Push(ParamCount);
      Push(N);
      Push(SubID);
    end;

//    Address[GetThisID(SubID)] := PThis;

    I := GetThisID(SubID);
    if A[I].Next <> 0 then
      PutVariant(I, PThis^)
    else
      Address[I] := PThis;

    with Stack do
    begin
      Push(N);
      Push(SubID);
      Push(ResultID);
    end;

    N := Entry;
  end;

  LevelStack.Push(SubID);

  RefStack.Push(K);
end;

procedure TPAXCode.CallHostSub(D: TPAXMethodDefinition; PThis, PResult: PVariant; ParamCount: Integer);

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

{$IFNDEF VARIANTS}
function ToInt64(const V: Variant): Int64;
var
  D: Double;
begin
  case VarType(V) of
    varInteger, varDouble:
    begin
      D := V;
      result := Round(D);
    end;
    else
      raise TPAXScriptFailure.Create(errIncompatibleTypes);
  end;
end;
{$ENDIF}

function GetMethodAddress(II: Pointer; MethodNum: Integer): Pointer;
begin
  Result:= Pointer(II);
  Result:= PPointer(Result)^;
  Integer(Result):= Integer(Result) + (MethodNum-1) * 4;
end;

procedure CallHostSubDirect;
var
  P, Params: array of Pointer;
  I, J, T: Integer;
  V: Variant;
  S: String;
  WS: WideString;
  Dbl: Double;

  Variants: array[0..MaxParams] of Variant;
  Integers: array[0..MaxParams] of Integer;
  Int64s: array[0..MaxParams] of Int64;
  Doubles: array[0..MaxParams] of Double;
  Singles: array[0..MaxParams] of Single;

  Reals: array[0..MaxParams] of Real;

  Currences: array[0..MaxParams] of Currency;
  Comps: array[0..MaxParams] of Comp;
  Extendeds: array[0..MaxParams] of Extended;
  Strings: array[0..MaxParams] of String;
  ShortStrings: array[0..MaxParams] of ShortString;
  WideStrings: array[0..MaxParams] of WideString;
  Pointers: array[0..MaxParams] of Pointer;
  Objects: array[0..MaxParams] of TObject;

  SO, tempSO: TPAXScriptObject;
  Instance: TObject;
  AClass: TClass;
  IntVal: Integer;
  W: TPAXScriptObjectList;
  IsLock: Boolean;
  ByteSet: TByteSet;
  ACardinal: TCardinal;
  AInt64: TInt64;
  ScriptObject: TPaxScriptObject;
  ClassRec: TPAXClassRec;
  PP: Pointer;
  Address: Pointer;
  TempClassDef: TPaxClassDefinition;
  Types: array of Integer;
  StrTypes: array of String;
  hr: HRESULT;
  PaxArray: TPaxArray;
  VT: Integer;
const
  E_NOINTERFACE = HRESULT($80004002);
begin
  SetLength(Params, ParamCount + 1);
  SetLength(P, ParamCount + 1);
  SetLength(Types, ParamCount + 1);
  SetLength(StrTypes, ParamCount + 1);

  if IsUndefined(PThis^) then
  begin
    SO := VariantToScriptObject(SymbolTable.VariantValue[SymbolTable.RootNamespaceID]);
  end
  else
    SO := VariantToScriptObject(PThis^);

  // read addresses of script-defined parameters and result
  for I:=0 to ParamCount - 1 do
    P[ParamCount - 1 - I] := GetTerminal(Stack.PopPointer);
  P[ParamCount] := PResult;

  for I:=0 to ParamCount do
  begin
    T := D.Types[I];
    Types[I] := T;

    if D.ExtraTypes[I] = typeDYNAMICARRAY then
    begin
      if I < ParamCount then
        V := Variant(P[I]^);
      Pointers[I] := PaxArrayToDynamicArray(V, D.Types[I]);
      Params[I] := Pointers[I];
    end
    else case T of
      typeVOID:
        begin
          if I < ParamCount then
          begin
            Variants[I] := Variant(P[I]^);

            if IsPaxArray(Variants[I]) then
            begin
              PaxArray := TPaxArray(VariantToScriptObject(Variants[I]).Instance);
              Pointers[I] := PaxArray.Buffer;
              Types[I] := typePOINTER;
              Params[I] := Pointers[I];
              D.ExtraTypes[I] := typeARRAY;
            end
            else if IsHostObject(Variants[I]) then
            begin
              Objects[I] := VariantToScriptObject(Variants[I]).Instance;
              Params[I] := @Objects[I];
            end
            else if VarType(Variants[I]) = varInteger then
            begin
              Types[I] := typeINTEGER;
              Integers[I] := Variants[I];
              Params[I] := @Integers[I];
            end
            else if VarType(Variants[I]) = varString then
            begin
              Types[I] := typeSTRING;
              Strings[I] := Variants[I];
              Params[I] := @Strings[I];
            end
            else if VarType(Variants[I]) = varDouble then
            begin
              Types[I] := typeDOUBLE;
              Doubles[I] := Variants[I];
              Params[I] := @Doubles[I];
            end
            else
              Params[I] := @Variants[I];
          end
          else
            Params[I] := @Variants[I];
        end;

      typeVARIANT:
      begin
        Variants[I] := Variant(P[I]^);
        Params[I] := @Variants[I];
        if I = ParamCount then
          FillChar(Params[I]^, _SizeVariant, 0);
      end;
      typeOLEVARIANT: Params[I] := P[I];
      typeINTEGER,
      typeBYTE,
      typeENUM,
      typeWORD:
      begin
        if TVarData(PVariant(P[I])^).VType = varDouble then
        begin
          PVariant(P[I])^ := Round(PVariant(P[I])^);
        end;

        Params[I] := ShiftPointer(P[I], 8);
      end;
      typeSMALLINT:
      begin
        Params[I] := ShiftPointer(P[I], 8);
        if I < ParamCount then
          SmallInt(Params[I]^) := Variant(P[I]^);
      end;
      typeSHORTINT:
      begin
        Params[I] := ShiftPointer(P[I], 8);
        if I < ParamCount then
          ShortInt(Params[I]^) := Variant(P[I]^);
      end;
      typeSTRING:
      begin
        Params[I] := @Strings[I];
        if I < ParamCount then
          Strings[I] := Variant(P[I]^)
        else
          Strings[I] := '';
      end;
      typeCARDINAL:
      begin
        Params[I] := ShiftPointer(P[I], 8);
        if I < ParamCount then
          TCardinal(Params[I]^) := ToCardinal(Variant(P[I]^));
      end;
      typeINT64:
      begin
        Params[I] := @Int64s[I];
        if I < ParamCount then
          Int64s[I] := ToInt64(Variant(P[I]^));
      end;
      typeDOUBLE:
      begin
        Params[I] := @Doubles[I];
        if I < ParamCount then
          Doubles[I] := Variant(P[I]^);
      end;
      typeSINGLE:
      begin
        Params[I] := @Singles[I];
        if I < ParamCount then
          Singles[I] := Variant(P[I]^);
      end;
      typeCURRENCY:
      begin
        Params[I] := @Currences[I];
        if I < ParamCount then
          Currences[I] := Variant(P[I]^);
      end;
      typeCOMP:
      begin
        Params[I] := @Comps[I];
        if I < ParamCount then
          Comps[I] := Variant(P[I]^);
      end;
      typeREAL48:
      begin
        Params[I] := @Reals[I];
        if I < ParamCount then
          Reals[I] := Variant(P[I]^);
      end;
      typeEXTENDED:
      begin
        Params[I] := @Extendeds[I];
        if I < ParamCount then
          Extendeds[I] := Variant(P[I]^);
      end;
      typeBOOLEAN:
      begin
        Params[I] := ShiftPointer(P[I], 8);
        if Byte(Params[I]^) <> 0 then
          Byte(Params[I]^) := 1;
      end;
      typeWORDBOOL:
      begin
        Params[I] := ShiftPointer(P[I], 8);
        if I < ParamCount then
          TWordBool(Params[I]^) := Variant(P[I]^);
      end;
      typeLONGBOOL:
      begin
        Params[I] := ShiftPointer(P[I], 8);
        if I < ParamCount then
          TLongBool(Params[I]^) := Variant(P[I]^);
      end;
      typeCHAR:
      begin
        Params[I] := @Integers[I];
        if I < ParamCount then
        begin
          S := ToString(Variant(P[I]^));
          TChar(Params[I]^) := S[1];
        end;
      end;
      typeWIDECHAR:
      begin
        Params[I] := ShiftPointer(P[I], 8);
        if I < ParamCount then
        begin
          WS := Variant(P[I]^);
          TWideChar(Params[I]^) := WS[1];
        end;
      end;
      typeINTERFACE:
      begin
        Params[I] := @Integers[I];
        if I < ParamCount then
        begin
          if IsObject(Variant(P[I]^)) then
          begin
            ScriptObject := VariantToScriptObject(Variant(P[I]^));
            if ScriptObject.PIntf <> nil then
              Move(ScriptObject.PIntf^, Integers[I], 4)
            else
              Move(ScriptObject.Intf, Integers[I], 4);
          end
          else
            Integers[I] := 0;
        end;
      end;
      typeCLASS:
        begin
          Params[I] := @Integers[I];
          if I < ParamCount then
          begin
            if IsUndefined(Variant(P[I]^)) then
              Integers[I] := 0 // nil
            else
            begin
              tempSO := VariantToScriptObject(Variant(P[I]^));
              if tempSO.ClassRec.ck = ckDynamicArray then
                Integers[I] := Integer(tempSO.ExtraPtr)
              else if tempSO.ClassRec.ck = ckStructure then
              begin
                Params[I] := tempSO.ExtraPtr;
                Types[I] := typeRECORD;
                if D.Consts[I] then
                  D.ByRefs[I] := true;
              end
              else if tempSO.ClassRec.ck = ckInterface then
              begin
                if tempSO.ClassRec.ClassID < 0 then
                begin
                  TempClassDef := TPaxClassDefinition(DefinitionList[-tempSO.ClassRec.ClassID]);
                  Params[I] := @ TempClassDef.guid;
                  Types[I] := typeRECORD;

                  for J:=0 to ParamCount - 1 do
                    if D.Types[J] = typeINTERFACE then
                      if D.StrTypes[J] = '' then
                        StrTypes[J] := TempClassDef.Name;
                end;
              end
              else
                Integers[I] := Integer(tempSO.Instance);
            end;
          end
          else
          begin
            Integers[I] := 0;
            if D.ReturnsDynamicArray then
              Types[ParamCount] := typeDYNAMICARRAY
            else if D.Sizes[ParamCount] >= 0 then
            begin
              Types[ParamCount] := typeRECORD;
            end;
          end;
        end;
      typeCLASSREF:
        begin
          if I < ParamCount then
            V := Variant(P[I]^);
          Params[I] := @Integers[I];
          if I < ParamCount then
          begin
            if IsUndefined(V) then
              Integers[I] := 0 // nil
            else
            begin
//            S := VariantToScriptObject(V).ClassRec.Name;
              Integers[I] := Integer(VariantToScriptObject(V).ClassRec.fClassDef.PClass);
            end;
          end;
        end;
      typePCHAR:
        Params[I] := ShiftPointer(P[I], 8);
      typeSHORTSTRING:
      begin
         Params[I] := @ShortStrings[I];
         if I < ParamCount then
           ShortStrings[I] := Variant(P[I]^);
      end;
      typeWIDESTRING:
        begin
          if I < ParamCount then
            V := Variant(P[I]^);
          Params[I] := @WideStrings[I];
          if I < ParamCount then
            WideStrings[I] := V;
        end;
      typePWIDECHAR:
        begin
          if I < ParamCount then
            V := Variant(P[I]^);
          Params[I] := @WideStrings[I];
          if I < ParamCount then
            WideStrings[I] := V;
        end;
      typeSET:
        begin
          if I < ParamCount then
            V := Variant(P[I]^);
          Params[I] := @Integers[I];
          if I < ParamCount then
          begin
            Integers[I] := 0;
            if VarType(V) = varString then
            begin
              ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(D.StrTypes[I]);
              if ClassRec <> nil then
              begin
                ByteSet := StringToByteSet(ClassRec.PtiSet, V);
                Move(ByteSet, Integers[I], SizeOf(TByteSet));
              end;
            end
            else
            begin
              ByteSet := PaxArrayToByteSet(V);
              Move(ByteSet, Integers[I], SizeOf(TByteSet));
            end;
          end;
        end;
      typeARRAY:
      begin
//        V := Variant(P[I]^);
//        PaxArray := TPaxArray(VariantToScriptObject(V).Instance);
//        Pointers[I] := PaxArray.LockArray;
//        D.ExtraTypes[I] := typeARRAY;
//        Types[I] := typePOINTER;
//        Params[I] := @Pointers[I];
      end;
      typePOINTER:
        begin
          Params[I] := @Pointers[I];
          if I < ParamCount then
          begin
            V := Variant(P[I]^);
            if IsObject(V) then
            begin
              tempSO := VariantToScriptObject(V);

              if tempSO.ClassRec.fClassDef <> nil then
                 Pointers[I] := tempSO.Instance
              else
                  Pointers[I] := tempSO;

//            Pointers[I] := tempSO.Instance;
            end
            else
              Pointers[I] := Pointer(Integer(V));
          end;
        end;
    end;
  end;

  Instance := nil;
  AClass := nil;

  if modSTATIC in D.ml then
    AClass := D.PClass;

  IsLock := false;
  try
    if D.Fake then
    begin
      if D.NewFake then
      begin
        Instance := SO.Instance;
        __Scripter := TPAXBaseScripter(SO.Scripter).Owner;

        S := Instance.ClassName;
      end
      else
      begin
        _BeginWrite;
        IsLock := true;
        __Self := SO.Instance;
        __Scripter := TPAXBaseScripter(SO.Scripter).Owner;
      end;
    end
    else if SO.ClassRec.GetClassDef <> nil then
    begin
      AClass := SO.ClassRec.GetClassDef.PClass;
      if AClass = TPAXDelegate then
        AClass := nil;
      if not (modSTATIC in D.ml) then
        Instance := SO.Instance;
      if Instance <> nil then
        AClass := nil;
    end;

    if D.DirectProc = @TObject.ClassName then
    begin
      Variant(P[ParamCount]^) := SO.ClassRec.Name;
      Exit;
    end
    else if D.DirectProc = @TObject.ClassType then
    begin
      Variant(P[ParamCount]^) := SymbolTable.GetVariant(SO.ClassRec.ClassID);
      Exit;
    end
    else if Instance <> nil then
      if Instance.InheritsFrom(TStrings) then
        if StrEql(D.Name, 'Clear') then
        begin
          (Instance as TStrings).Clear;
          Exit;
        end;

    if D.TypeSub = tsDestructor then
    begin
      if SO.Instance <> nil then
      begin
        if Assigned(TPaxBaseScripter(Scripter).OnDelphiInstanceDestroy) then
          TPaxBaseScripter(Scripter).OnDelphiInstanceDestroy(TPaxBaseScripter(Scripter).Owner, SO.Instance);

        for I:=0 to TPaxBaseScripter(scripter).EventHandlerList.Count - 1 do
          if TPAXEventHandler(TPaxBaseScripter(scripter).EventHandlerList[I]).DelphiInstance = SO.Instance then
            TPAXEventHandler(TPaxBaseScripter(scripter).EventHandlerList[I]).DelphiInstance := nil;


        SO.Instance.Free;
        SO.Instance := nil;

        W := TPAXBaseScripter(Scripter).ScriptObjectList;
        W.RemoveObject(SO);
      end;

      VarClear(PThis^);
      Exit;
    end;

    Address := D.DirectProc;
    if D.IsIntf then
    begin
      if D.MethodIndex = 1 then
      begin
        IntVal := 0;
        if SO.PIntf <> nil then
          hr := SO.PIntf^.QueryInterface(PGUID(Params[0])^, IntVal)
        else
          hr := SO.Intf.QueryInterface(PGUID(Params[0])^, IntVal);
        if hr <> E_NOINTERFACE then
        begin
          ScriptObject := InterfaceToScriptObject(IUnknown(IntVal), Scripter);
          if ScriptObject = nil then
            hr := E_NOINTERFACE
          else
            Variant(P[1]^) := ScriptObjectToVariant(ScriptObject);
        end;
        Variant(P[2]^) := hr;
        Exit;
      end
      else if D.MethodIndex = 2 then
      begin
        if SO.PIntf <> nil then
          SO.PIntf^._AddRef
        else
          SO.Intf._AddRef;
        Exit;
      end
      else if D.MethodIndex = 3 then
      begin
        if SO.PIntf <> nil then
          SO.PIntf^._Release
        else
          SO.Intf._Release;
        Exit;
      end;

      if SO.PIntf <> nil then
      begin
        Move(SO.PIntf^, Instance, 4);
        Address := GetMethodAddress(Pointer(SO.PIntf^), D.MethodIndex);
      end
      else
      begin
        Move(SO.Intf, Instance, 4);
        Address := GetMethodAddress(Pointer(SO.Intf), D.MethodIndex);
      end;
    end;

    BASE_CALL.Call(Address,
                   AClass,
                   Instance,
                   (D.TypeSub = tsConstructor) and (not D.Fake),
                   D.CallConv,
                   Params,
                   Types,
                   D.ExtraTypes,
                   D.ByRefs,
                   D.Sizes,
                   D.IsIntf);

  finally
    if IsLock then
      _EndWrite;
  end;

  if PResult = nil then
    Dec(ParamCount);

  for I:=0 to ParamCount do
    if D.ExtraTypes[I] = typeDYNAMICARRAY then
    begin
      if D.ByRefs[I] then
        Variant(P[I]^) := DynamicArrayToVariant(Scripter, Pointers[I], D.StrTypes[I], D.Types[I]);

      EraseDynamicArray(Scripter, Pointers[I], D.Types[I]);
    end
    else
    if D.ExtraTypes[I] = typeARRAY then
    begin
//      V := Variant(P[I]^);
//      PaxArray := TPaxArray(VariantToScriptObject(V).Instance);
//      PaxArray.UnLockArray(true);
    end;

  for I:=0 to ParamCount do
  if not (D.ExtraTypes[I] in [typeDYNAMICARRAY, typeARRAY]) then
  begin
    T := Types[I];
    if D.ByRefs[I] then
    begin
      case T of
        typeVARIANT:
        begin
          VT := VarType(Variant(Params[I]^));
          if VT = varUnknown then
          begin
            Move(TVarData(Params[I]^).VUnknown, IntVal, 4);

            ScriptObject := TPaxBaseScripter(Scripter).ScriptObjectList.FindScriptObjectByIntf(PUnknown(@IntVal));
            if ScriptObject = nil then
            begin
              ScriptObject := InterfaceToScriptObject(IUnknown(IntVal), scripter);
  //                ScriptObject.Intf := IUnknown(Integers[I]);
//              Move(Integers[I], ScriptObject.Intf, 4);
              ScriptObject.RefCount := 1;
            end;
            Variant(P[I]^) := ScriptObjectToVariant(ScriptObject);
          end
          else
            Variant(P[I]^) := Variants[I];

          continue;
        end;
        typeOLEVARIANT:
        begin
           continue;
        end;
        typeSTRING:
        begin
          Variant(P[I]^) := Strings[I];
          Strings[I] := '';
        end;
        typeINTEGER,
        typeBYTE,
        typeWORD,
        typeENUM: TVarData(Variant(P[I]^)).VType := varInteger;

        typeSET:
        begin
          ByteSet := [];
          Move(Integers[I], ByteSet, SizeOf(ByteSet));
          Variant(P[I]^) := ByteSetToPaxArray(ByteSet, Scripter);
        end;
        typeDOUBLE:
        begin
          Variant(P[I]^) := Doubles[I];
        end;
        typeSINGLE:
        begin
          Dbl := Singles[I];
          Variant(P[I]^) := Dbl;
        end;
        typeCURRENCY:
        begin
          Dbl := Currences[I];
          Variant(P[I]^) := Dbl;
        end;
        typeCOMP:
        begin
          Dbl := Comps[I];
          Variant(P[I]^) := Dbl;
        end;
        typeSMALLINT:
        begin
          Integer(Params[I]^) := SmallInt(Params[I]^);
          TVarData(Variant(P[I]^)).VType := varInteger;
        end;
        typeSHORTINT:
        begin
          Integer(Params[I]^) := ShortInt(Params[I]^);
          TVarData(Variant(P[I]^)).VType := varInteger;
        end;
        typeREAL48:
        begin
          Dbl := Reals[I];
          Variant(P[I]^) := Dbl;
        end;
        typeEXTENDED:
        begin
          Dbl := Extendeds[I];
          Variant(P[I]^) := Dbl;
        end;
        typeWORDBOOL:
          Variant(P[I]^) := WordBool(Params[I]^);
        typeLONGBOOL:
          Variant(P[I]^) := LongBool(Params[I]^);
        typeBOOLEAN:
        begin
          TVarData(Variant(P[I]^)).VType := varBoolean;
          if Byte(Params[I]^) <> 0 then
            ShortInt(Params[I]^) := -1;
        end;
        typeCHAR:
        begin
          S := TChar(Params[I]^);
          Variant(P[I]^) := S;
        end;
        typeWIDECHAR:
        begin
          WS := TWideChar(Params[I]^);
          Variant(P[I]^) := WS;
        end;
        typeWIDESTRING:
        begin
          Variant(P[I]^) := WideStrings[I];
        end;
        typeRECORD:
        begin
          if I = ParamCount then
          begin
            ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(D.ResultType);
            tempSO := ClassRec.CreateScriptObject;
            Move(Integers[I], tempSO.ExtraPtr^, D.Sizes[I]);
            Variant(P[I]^) := ScriptObjectToVariant(tempSO);
          end;
        end;
        typeDYNAMICARRAY:
        if I = ParamCount then
        begin
          if Integers[I] = 0 then
          begin
//            Variant(P[I]^) := Undefined;
            ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(D.ResultType);
            tempSO := ClassRec.CreateScriptObject;
            tempSO.Instance := tempSO;

            PP := AllocMem(8);

            tempSO.ExtraPtr := ShiftPointer(PP, 8);
            tempSO.ExternalExtraPtr := false;
            tempSO.ExtraPtrSize := - 8;
            PP := ShiftPointer(tempSO.ExtraPtr, -8);
            Inc(Integer(PP^));
            Variant(P[I]^) := ScriptObjectToVariant(tempSO);
          end
          else
          begin
            ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(D.ResultType);
            tempSO := ClassRec.CreateScriptObject;
            tempSO.Instance := tempSO;
            tempSO.ExtraPtr := Pointer(Integers[I]);
            tempSO.ExternalExtraPtr := true;
            PP := ShiftPointer(tempSO.ExtraPtr, -8);
            Inc(Integer(PP^));
            Variant(P[I]^) := ScriptObjectToVariant(tempSO);
          end;
        end;
        typeINTERFACE:
        begin
{
          ScriptObject := InterfaceToScriptObject(IUnknown(Integers[I]), Scripter);
          if ScriptObject <> nil then
              Variant(P[I]^) := ScriptObjectToVariant(ScriptObject);
}

          if I = ParamCount then
            S := D.ResultType
          else
          begin
            S := D.StrTypes[I];
            if S = '' then
              S := StrTypes[I];
          end;

          if (S <> '') and (Integers[I] <> 0) then
          begin
            ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(S);
            if ClassRec = nil then
              raise TPaxScriptFailure.Create(Format(errClassIsNotImported, [S]))
            else
            begin
              ScriptObject := TPaxBaseScripter(Scripter).ScriptObjectList.FindScriptObjectByIntf(PUnknown(@Integers[I]));
              if ScriptObject = nil then
              begin
                ScriptObject := ClassRec.CreateScriptObject;
//                ScriptObject.Intf := IUnknown(Integers[I]);
                Move(Integers[I], ScriptObject.Intf, 4);
                ScriptObject.RefCount := 1;
              end;
              Variant(P[I]^) := ScriptObjectToVariant(ScriptObject);
            end;
          end
          else
              Variant(P[I]^) := Undefined;
        end;
        typeCLASS:
        begin
          if I = ParamCount then
          begin
            if D.ResultType <> '' then
            begin
              if TPaxBaseScripter(Scripter).ClassList.FindClassByName(D.ResultType) = nil then
              begin
                AdjustEnum(Integers[I]);
                TVarData(Variant(P[I]^)).VType := varInteger;
                continue;
              end;
            end;
          end;

          IntVal := Integers[I];
          if (D.TypeSub = tsConstructor) and (I = ParamCount) then
          begin
            Instance := TObject(IntVal);
            SO.Instance := Instance;
            PThis^ := ScriptObjectToVariant(SO);
            SymbolTable.PutVariant(Prog[N].Res, PThis^);

            if not SO.Instance.InheritsFrom(TComponent) then
              SO.RefCount := 1;

            if SO.Instance is RegExp then
            begin
              (SO.Instance as RegExp).SetScripter(scripter);
            end;

            if Assigned(TPaxBaseScripter(Scripter).OnDelphiInstanceCreate) then
              TPaxBaseScripter(Scripter).OnDelphiInstanceCreate(TPaxBaseScripter(Scripter).Owner, Instance);
          end
          else
          begin
            if IsDelphiObject(Pointer(IntVal)) then
            begin
              Instance := TObject(IntVal);
              ScriptObject := DelphiInstanceToScriptObject(Instance, Scripter, false);

              if I = ParamCount then
              begin
                if ScriptObject = nil then
                  Presult^ := Undefined
                else
                  PResult^ := ScriptObjectToVariant(ScriptObject);
              end
              else
              begin
                if ScriptObject = nil then
                  Variant(P[I]^) := Undefined
                else
                  Variant(P[I]^) := ScriptObjectToVariant(ScriptObject);
              end;
            end
            else if IsDelphiClass(Pointer(IntVal)) then
            begin
              AClass := TClass(IntVal);
              PResult^ := ScriptObjectToVariant(DelphiClassToScriptObject(AClass, Scripter));
            end
            else
              PResult^ := Undefined;
          end;
        end;
        typeCARDINAL:
        begin
          ACardinal := TCardinal(Params[I]^);
          if ACardinal > Cardinal(MaxInt) then
          begin
            Dbl := ACardinal;
            Variant(P[I]^) := Dbl;
          end
          else
            Variant(P[I]^) := Integer(ACardinal);
        end;
        typeINT64:
        begin
          AInt64 := Int64s[I];
          if AInt64 > Cardinal(MaxInt) then
          begin
            Dbl := AInt64;
            Variant(P[I]^) := Dbl;
          end
          else
            Variant(P[I]^) := Integer(AInt64);
        end;
        typePCHAR:
          Variant(P[I]^) := StrPas(PChar(Params[I]));
        typeSHORTSTRING: Variant(P[I]^) := ShortStrings[I];
        typePOINTER:
          begin
            if IsDelphiObject(Pointers[I]) then
            begin
              Instance := TObject(Pointers[I]);
              if Instance.ClassType = TPaxScriptObject then
              begin
                Variant(P[I]^) := Integer(Instance);
                TVarData(Variant(P[I]^)).VType := varScriptObject;
              end
              else
                Variant(P[I]^) := ScriptObjectToVariant(DelphiInstanceToScriptObject(Instance, Scripter));
            end
            else if IsDelphiClass(Pointers[I]) then
            begin
              AClass := TClass(Pointers[I]);
              Variant(P[I]^) := ScriptObjectToVariant(DelphiClassToScriptObject(AClass, Scripter));
            end
            else
              Variant(P[I]^) := Integer(Pointers[I]);
          end;
      end; // case
    end;
  end;
{
  if D.TypeSub = tsDestructor then
  begin
    if SO.Instance <> nil then
    begin
      W := TPAXBaseScripter(Scripter).ScriptObjectList;
      I := W.IndexOfDelphiObject(SO.Instance);
      if I <> -1 then
        W.Delete(I);
    end;
    VarClear(PThis^);
  end;
}
end;

var
  I: Integer;
  P: Pointer;
  SO: TPAXScriptObject;
  IsConstructor: Boolean;
  MethodBody: TPAXMethodBody;
//  V: Variant;
begin
  _ParamCount := ParamCount;

  if (PResult = nil) or (PResult = @Undefined) then
    PResult := @Undefined2;

  if D.NP <> -1 then
  begin
    if D.NP > ParamCount then
    begin
      for I:=D.DefParamList.Count - D.NP + ParamCount to D.DefParamList.Count - 1 do
      begin
        Inc(ParamCount);
        Stack.Push(D.DefParamList.GetAddress(I + 1));
      end;
      if D.NP > ParamCount then
        raise TPAXScriptFailure.Create(errNotEnoughParameters)
      else if D.NP < ParamCount then
        raise TPAXScriptFailure.Create(errTooManyParameters);
    end
    else if D.NP < ParamCount then
    begin
      raise TPAXScriptFailure.Create(errTooManyParameters);
    end;
  end;

  if (D.DirectProc <> nil) or (D.IsIntf) then
  begin
    CallHostSubDirect;
    Inc(N);
    Exit;
  end;

  MethodBody := TPAXBaseScripter(Scripter).MethodBody;
  MethodBody.Clear;

  MethodBody.ParamCount := ParamCount;
  for I:=0 to ParamCount - 1 do
  begin
    P := Stack.PopPointer;
    P := GetTerminal(P);
    MethodBody.Params[ParamCount - I - 1].PValue := P;
  end;

  SO := VariantToScriptObject(PThis^);

  MethodBody.PSelf := @SO.Instance;
  IsConstructor := SO.Instance = nil;
  MethodBody.Name := D.Name;
  MethodBody.Result.PValue := PResult;

  D.Proc(MethodBody);

  IsConstructor := IsConstructor and (SO.Instance <> nil);

  if SO.Instance <> nil then
    if SO.Instance.InheritsFrom(TPAXScriptObject) then
    begin
      SO := TPAXScriptObject(SO.Instance);
      SO.Instance := SO;
    end;

  with MethodBody do
  if Result.VType = varScriptObject then
  if PResult <> nil then
  if Self <> nil then
  begin
    if Self.InheritsFrom(TPAXScriptObject) then
      PResult^ := ScriptObjectToVariant(TPAXScriptObject(SO))
    else
      PResult^ := ScriptObjectToVariant(DelphiInstanceToScriptObject(Result.AsTObject, Scripter));
  end;

  if IsConstructor then
  begin
    PThis^ := ScriptObjectToVariant(SO);
    SymbolTable.PutVariant(Prog[N].Res, PThis^);
  end;

  Inc(N);
end;

procedure TPAXCode.OperPutProperty;
var
  I, ID, K, SubID, ParamCount: Integer;
  SO: TPAXScriptObject;
  V, Value: Variant;
  S: String;
  Ch: Char;
  Indexes: array of Integer;
  Prop: TPAXProperty;
  MemberRec: TPAXMemberRec;
  MethodDefinition: TPAXMethodDefinition;
  Definition: TPaxDefinition;
  P: PVariant;

  FoundInBaseClass: Boolean;
  MemberNameIndex: Integer;

  Params: TVarArray;
begin
  ID := Prog[N].Arg1;
  ParamCount := Prog[N].Arg2;

  with SymbolTable do
  begin
    K := Kind[ID];
    if K = KindREF then
    begin
      if A[ID].Owner <> 0 then
      begin
        Value := PopVariant;

        Dec(ParamCount);
        SetLength(Params, ParamCount);
        for I:=0 to ParamCount - 1 do
        begin
          Params[ParamCount - I - 1] := PopVariant;
        end;

        if Assigned(TPaxBaseScripter(Scripter).OnVirtualObjectPutProperty) then
        begin
          TPaxBaseScripter(Scripter).OnVirtualObjectPutProperty(TPaxBaseScripter(Scripter).Owner, Name[A[ID].Owner], Name[ID], Params, Value);
        end
        else
          raise TPAXScriptFailure.Create(errNotAssignedOnVirtualObjectPutPropertyEventHandler);

        Inc(N);
        Exit;
      end;

//      MemberRec := GetMemberRec(ID, ma);
      MemberRec := GetMemberRecEx(ID, maAny, FoundInBaseClass, SO);

      if MemberRec = nil then
      begin
        SO := VariantToScriptObject(GetVariant(ID));
        SO.PutProperty(NameIndex[ID], PopVariant, ParamCount - 1);
        Inc(N);
        Exit;
      end
      else
        SubID := MemberRec.ID;

      if MemberRec.IsPublished then
      begin
        SO := VariantToScriptObject(GetVariant(ID));
        SO.PutPublishedProperty(Name[ID], PopVariant);
        Prog[N].Op := OP_PUT_PUBLISHED_PROPERTY;
        Inc(N);
        Exit;
      end;

      if MemberRec.Definition <> nil then
      begin
        case MemberRec.Definition.DefKind of
          dkProperty:
          begin
            Definition := TPaxPropertyDefinition(MemberRec.Definition).WriteDef;
            if Definition = nil then
            begin
              Definition := TPaxPropertyDefinition(MemberRec.Definition).ReadDef;
              if Definition <> nil then
              begin
                 MethodDefinition := TPAXMethodDefinition(Definition);
                 CallHostSub(MethodDefinition, Address[ID],  @VV, 0);
                 if IsObject(VV) then
                 begin
                   SO := VariantToScriptObject(VV);
                   Prop := SO.PropertyList.GetDefaultProperty;
                    if (Prop <> nil) and Prop.IsImported then
                    begin
                      Definition := TPAXPropertyDefinition(Prop.Definition).WriteDef;
                      MethodDefinition := TPAXMethodDefinition(Definition);
                      CallHostSub(MethodDefinition, @VV, @VV, ParamCount);
                      Dec(N);
                      Exit;
                    end;
                  end;
              end;

              raise TPaxScriptFailure.Create(Format(errCannotWriteReadOnlyProperty, [Name[ID]]));
            end;
            if Definition.DefKind = dkField then
            begin
              Value := PopVariant;
              SO := VariantToScriptObject(GetVariant(ID));
              TPAXFieldDefinition(Definition).SetFieldValue(SO, Value);
              Inc(N);
              Exit;
            end;
            MethodDefinition := TPAXMethodDefinition(Definition);

            if FoundInBaseClass then
            begin
              MemberNameIndex := CreateNameIndex(MethodDefinition.Name, Scripter);
              MemberRec := SO.ClassRec.FindMember(MemberNameIndex, maMyClass);
              if MemberRec <> nil then
              begin
                SubID := MemberRec.ID;
                CallSub(SubID, ParamCount, Address[ID], 0);
                Exit;
              end;
           end;

            CallHostSub(MethodDefinition, Address[ID], @VV, ParamCount);
          end;
          dkVariable:
          begin
            Value := PopVariant;
            if IsVBArray(TPAXVariableDefinition(MemberRec.Definition).GetValue(Scripter)) then
            begin
              Dec(ParamCount);
              SetLength(Indexes, ParamCount);
              for I:=1 to ParamCount do
                Indexes[ParamCount - I] := PopVariant;
              V := TPAXVariableDefinition(MemberRec.Definition).GetValue(Scripter);

              if VarArrayDimCount(V) = 1 then
              begin
                I := Indexes[0];
                V[I] := Value;
              end
              else
                ArrayPut(@V, Indexes, Value);
              TPAXVariableDefinition(MemberRec.Definition).SetValue(Scripter, V);
            end
            else
              TPAXVariableDefinition(MemberRec.Definition).SetValue(Scripter, Value);
            Inc(N);
          end;
          dkField, dkRecordField:
          begin
            Value := PopVariant;
            VariantValue[ID] := Value;
            Inc(N);
          end;
        else
          raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [Name[ID]]));
        end;
        Exit;
      end;

      if SubID = 0 then
        raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [Name[ID]]));
      K := Kind[SubID];
      if K = KindPROP then
      begin
        SO := VariantToScriptObject(GetVariant(ID));
        Prop := SO.Get(NameIndex[ID]);
        if Kind[Prop.WriteID] = KindSUB then
          CallSub(Prop.WriteID, ParamCount, SymbolTable.Address[ID], 0)
        else
        begin
          Value := PopVariant;
          Prop := SO.Get(NameIndex[Prop.WriteID]);
          Prop.Value[0] := Value;
          Inc(N);
        end;
        Exit;
      end
{      else if K = KindVAR then
      begin
        SO := VariantToScriptObject(GetVariant(ID));

        SO.PutProperty(NameIndex[ID], PopVariant, ParamCount - 1);
        Inc(N);
        Exit;
      end }
      else if K in [KindVAR, KindREF] then
      begin
        SO := VariantToScriptObject(GetVariant(ID));

        Prop := SO.PropertyList.FindProperty(NameIndex[ID]);
        if Prop.WriteID = 0 then
          if IsObject(Prop.fValue^) then
          if not IsPaxArray(Prop.fValue^) then
          begin
            P := Prop.fValue;
            Prop := VariantToScriptObject(Prop.fValue^).PropertyList.GetDefaultProperty;
            if Prop <> nil then
            begin
              if Prop.IsImported then
              begin
                Definition := TPAXPropertyDefinition(Prop.Definition).WriteDef;
                if Definition.DefKind = dkField then
                begin
                  Value := PopVariant;
                  TPAXFieldDefinition(Definition).SetFieldValue(SO, Value);
                  Inc(N);
                  Exit;
                end
                else if Definition.DefKind = dkRecordField then
                begin
                  Value := PopVariant;
                  if SO.ExtraPtr = nil then
                    Prop.Value[0] := Value
                  else
                    TPAXRecordFieldDefinition(Definition).SetFieldValue(SO.Scripter, SO.ExtraPtr, Value);
                  Inc(N);
                  Exit;
                end
                else
                begin
                  MethodDefinition := TPAXMethodDefinition(Definition);
                  CallHostSub(MethodDefinition, P, nil, ParamCount);
                end;
              end
              else
                CallSub(Prop.WriteID, ParamCount, P, 0);

              Exit;
            end;
          end;

        SO.PutProperty(NameIndex[ID], DuplicateObject(PopVariant), ParamCount - 1);
        Inc(N);
        Exit;
      end
      else
        raise Exception.Create(errInternalError);
    end
    else if K in [KindVAR, KindHOSTVAR, KindHOSTOBJECT] then
    begin
      if K = KindHostObject then
        V := VariantValue[ID]
      else
        V := GetVariant(ID);

      if IsString(V) then
      begin
        if ParamCount > 2 then
          raise TPAXScriptFailure.Create(errTooManyActualParameters);

        S := PopVariant;
        Ch := S[1];

        I := PopVariant;

        if SignZERO_BASED_STRINGS then
          Inc(I);

        S := V;
        S[I] := Ch;
        PutVariant(ID, S);

        if not IsAlias(Address[ID]) then
          Prog[N].Op := OP_PUT_STRING_ELEMENT;
      end
      else if IsPaxArray(V) then
      begin
        Value := PopVariant;

        Dec(ParamCount);
        SetLength(Indexes, ParamCount);
        for I:=1 to ParamCount do
          Indexes[ParamCount - I] := PopVariant;

        SO := VariantToScriptObject(V);
        TPaxArray(SO.Instance).Put(Indexes, Value);

        Prog[N].Op := OP_PUT_ITEM;
      end
      else if IsVBArray(V) then
      begin
        Value := PopVariant;

        Dec(ParamCount);
        SetLength(Indexes, ParamCount);
        for I:=1 to ParamCount do
          Indexes[ParamCount - I] := PopVariant;

        if VarArrayDimCount(V) = 1 then
        begin
          I := Indexes[0];
          Variant(Address[ID]^)[I] := Value;
        end
        else
          ArrayPut(Address[ID], Indexes, Value);

        Prog[N].Op := OP_PUT_ITEM;
      end
      else if IsObject(V) then
      begin
        SO := VariantToScriptObject(V);
        Prop := SO.PropertyList.GetDefaultProperty;

        if Prop = nil then
        begin
          Value := PopVariant;
          S := ToStr(Scripter, PopVariant);
          SO.PutProperty(CreateNameIndex(S, Scripter), Value, 0);
          Inc(N);
          Exit;
        end;

        if Prop.IsImported then
        begin
          Definition := TPAXPropertyDefinition(Prop.Definition).WriteDef;
          if Definition.DefKind = dkField then
          begin
            Value := PopVariant;
            TPAXFieldDefinition(Definition).SetFieldValue(SO, Value);
            Inc(N);
            Exit;
          end
          else if Definition.DefKind = dkRecordField then
          begin
            Value := PopVariant;
            if SO.ExtraPtr = nil then
              Prop.Value[0] := Value
            else
              TPAXRecordFieldDefinition(Definition).SetFieldValue(SO.Scripter, SO.ExtraPtr, Value);
            Inc(N);
            Exit;
          end
          else
          begin
            MethodDefinition := TPAXMethodDefinition(Definition);
            CallHostSub(MethodDefinition, GetAddressEx(ID), nil, ParamCount);
          end;
        end
        else
          CallSub(Prop.WriteID, ParamCount, GetAddressEx(ID), 0);
        Exit;
      end
      else
      begin
        TPaxBaseScripter(Scripter).Dump();
        raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [Name[ID]]));
      end;
    end
    else
      raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [Name[ID]]));
  end;

  Inc(N);
end;

procedure TPAXCode.OperTypeCast;
var
  V: Variant;
begin
  with Prog[N], SymbolTable do
  begin
    V := TypeCast(Arg1, PopVariant);
    PutVariant(Res, V);
  end;
  Inc(N);
end;

procedure TPAXCode.OperCall;
var
  I, L, ID, K, SubID, ParamCount, ResultID, ReadID: Integer;
  P: Pointer;
  SO, tempSO: TPAXScriptObject;
  V: Variant;
  Indexes: array of Integer;
  S: String;
  ma: TPAXMemberAccess;
  Prop: TPAXProperty;
  MemberRec, TempMemberRec: TPAXMemberRec;
  MethodDefinition: TPAXMethodDefinition;
  VarPtr: PVariant;
  NewN: Integer;
  Definition: TPaxDefinition;
  K1, K2: Integer;

  FoundInBaseClass: Boolean;
  MemberNameIndex: Integer;

  Params: TVarArray;
label
  ElsePart, patch;
begin
  ma := maAny;

  with Prog[N], SymbolTable do
  begin
    if Arg1 = 0 then
    begin
      Inc(N);
      Exit;
    end;

   FoundInBaseClass := false;

    if Kind[Arg1] = KindSUB then
    begin
//      CallSub(Arg1, Arg2, Address[Arg1], Res, true);
      SubID := LevelStack.Top;
      if SubID = 0 then
      begin
        if Prog[N].AltArg1 <> 0 then
        begin
          L := Level[Prog[N].AltArg1];
          CallSub(Prog[N].AltArg1, Arg2, Address[L], Res, true);
        end
        else
        begin
          L := Level[Arg1];
          CallSub(Arg1, Arg2, Address[L], Res, true);
        end;
      end
      else
      begin
        if Level[SubID] = Level[Arg1] then
        begin
          if Prog[N].AltArg1 <> 0 then
            CallSub(Prog[N].AltArg1, Arg2, Address[GetThisID(SubID)], Res, true)
          else
          begin

            V := GetVariant(GetThisID(SubID));
            if IsObject(V) then
            begin
              SO := VariantToScriptObject(V);
              MemberRec := SO.ClassRec.FindMember(NameIndex[Arg1], ma, UpCaseON);
              if MemberRec <> nil then
              begin
                CallSub(MemberRec.Id, Arg2, Address[GetThisID(SubID)], Res, true);
                Exit;
              end;
            end;

            CallSub(Arg1, Arg2, Address[GetThisID(SubID)], Res, true);
          end;
        end
        else
        begin
          if Prog[N].AltArg1 <> 0 then
            CallSub(Prog[N].AltArg1, Arg2, Address[Arg1], Res, true)
          else
            CallSub(Arg1, Arg2, Address[Arg1], Res, true);
        end;
      end;

{
      if LevelStack.Top > 0 then
        CallSub(Arg1, Arg2, Address[GetThisID(LevelStack.Top)], Res, true)
      else
        CallSub(Arg1, Arg2, Address[Arg1], Res, true);
}
      Exit;
    end;

    ID := Arg1;
    ParamCount := Arg2;
    ResultID := Res;
  end;

  with SymbolTable do
  begin
    K := Kind[ID];
    if K = KindREF then
    begin
      if A[ID].Owner <> 0 then
      begin
        SetLength(Params, ParamCount);
        for I:=0 to ParamCount - 1 do
        begin
          Params[ParamCount - I - 1] := PopVariant;
        end;

        if Assigned(TPaxBaseScripter(Scripter).OnVirtualObjectMethodCall) then
        begin
          V := TPaxBaseScripter(Scripter).OnVirtualObjectMethodCall(TPaxBaseScripter(Scripter).Owner, Name[A[ID].Owner], Name[ID], Params);
          if ResultID > 0 then
            PutVariant(ResultID, V);
        end
        else
          raise TPAXScriptFailure.Create(errNotAssignedOnVirtualObjectMethodCallEventHandler);

        SymbolTable.Kind[ResultID] := KindVAR;

        Inc(N);
        Exit;
      end;

      ma := MemberAccess[ID];

      if ma = maMyBase then
      begin
        L := Level[LevelStack.Top];
        SO := VariantToScriptObject(GetVariant(L));
        MemberRec := SO.ClassRec.FindMember(NameIndex[ID], ma, UpCaseON);
        if MemberRec <> nil then
          MemberRec.CheckAccess;
      end
      else
        MemberRec := GetMemberRecEx(ID, maAny, FoundInBaseClass, SO);

      if MemberRec = nil then
      begin
        Kind[ResultID] := KindVAR;
        SO := VariantToScriptObject(GetVariant(ID));
        if SO.Instance <> nil then
        begin
          Prop := SO.SafeGet(NameIndex[ID]);
          if Prop <> nil then
          if Prop.fValue <> nil then
          begin
            V := Prop.PTerminalValue^;
            if IsObject(V) then
            begin
              TempSO := VariantToScriptObject(V);
              if TempSO.ClassRec.AncestorName = 'Function' then
              begin
                SubID := TempSO.ClassRec.GetConstructorID;
                CallSub(SubID, ParamCount, Address[ID], ResultID);
                Exit;
              end
              else if TempSO.ClassRec.Name = 'TPAXDelegate' then
              begin
                SubID := TPAXDelegate(TempSO.Instance).SubID;
                CallSub(SubID, ParamCount, Address[ID], ResultID);
                Exit;
              end;
            end;
          end;

          V := SO.GetProperty(NameIndex[ID], ParamCount);
          if ResultID > 0 then
            PutVariant(ResultID, V);
        end
        else if SO.ClassRec.Name = Name[ID] then // default constructor call in PaxC
        begin
          I := N;
          while not ((Prog[I].Op = OP_CREATE_OBJECT) and (Name[Prog[I].Arg1] = SO.ClassRec.Name)) do
            Dec(I);
          V := GetVariant(Prog[I].Res);
          if ResultID > 0 then
            PutVariant(ResultID, V);
        end;

        Inc(N);
        Exit;
      end
      else
        SubID := MemberRec.ID;

      if Prog[N].AltArg1 <> 0 then
      begin
        SubID := Prog[N].AltArg1;
        if SubID <> MemberRec.ID then
        begin
          TempMemberRec := MemberRec.fClassRec.MemberList.GetMemberRecByID(SubID);
          if TempMemberRec <> nil then
            MemberRec := TempMemberRec;
        end;
      end;

      if MemberRec.IsPublished then
      begin
        SO := VariantToScriptObject(GetVariant(ID));
        K1 := Stack.Card;
        V := SO.GetPublishedProperty(Name[ID], ParamCount);
        K2 := Stack.Card;
        if ResultID > 0 then
        begin
          Kind[ResultID] := KindVAR;
          PutVariant(ResultID, V);
        end;

        if ParamCount = 0 then
        begin
          Prog[N].Op := OP_GET_PUBLISHED_PROPERTY;
          Inc(N);
        end
        else
        begin
          if K1 <> K2 then
          begin
            Prog[N].Op := OP_GET_PUBLISHED_PROPERTY;
            Inc(N);
          end
          else
          begin
            Kind[Prog[N].Arg1] := KindVAR;
            PutVariant(Prog[N].Arg1, V);
          end;
        end;

        Exit;
      end;

      if MemberRec.Definition <> nil then
      begin
        case MemberRec.Definition.DefKind of
          dkMethod:
          begin
            CallHostSub(TPAXMethodDefinition(MemberRec.Definition),
              Address[ID], Address[ResultID], ParamCount);
          end;
          dkProperty:
          begin
            Definition := TPAXPropertyDefinition(MemberRec.Definition).ReadDef;
            if Definition.DefKind = dkField then
            begin
              if ResultID > 0 then
              begin
                SO := VariantToScriptObject(GetVariant(ID));
                PutVariant(ResultID, TPAXFieldDefinition(Definition).GetFieldValue(SO));
              end;
              Kind[ResultId] := KindVAR;
              Inc(N);
              Exit;
            end;

            MethodDefinition := TPAXMethodDefinition(Definition);

            if MethodDefinition.NP = ParamCount then
            begin
              if FoundInBaseClass then
              begin
                MemberNameIndex := CreateNameIndex(MethodDefinition.Name, Scripter);
                MemberRec := SO.ClassRec.FindMember(MemberNameIndex, maMyClass);
                if MemberRec <> nil then
                begin
                  SubID := MemberRec.ID;
                  CallSub(SubID, ParamCount, Address[ID], ResultID);
                  Kind[ResultID] := KindVAR;
                  Exit;
                end;
              end;

              CallHostSub(MethodDefinition, Address[ID], Address[ResultID], ParamCount);
            end
            else
            begin
              CallHostSub(MethodDefinition, Address[ID], Address[ResultID], 0);
              if ResultID > 0 then
              begin
                SO := VariantToScriptObject(GetVariant(ResultID));
                Prop := SO.PropertyList.GetDefaultProperty;

                if (Prop <> nil) and Prop.IsImported then
                begin
                  Definition := TPAXPropertyDefinition(Prop.Definition).ReadDef;
                  if Definition.DefKind = dkField then
                  begin
                    if ResultID > 0 then
                    begin
                      SO := VariantToScriptObject(GetVariant(ID));
                      PutVariant(ResultID, TPAXFieldDefinition(Definition).GetFieldValue(SO));
                    end;
                    Kind[ResultId] := KindVAR;
                    Inc(N);
                    Exit;
                  end;

                  MethodDefinition := TPAXMethodDefinition(Definition);
                  CallHostSub(MethodDefinition, Address[ResultID], Address[ResultID], ParamCount);
                  Dec(N);
                  Exit;
                end;

                if ParamCount > 0 then
                if Prop = nil then
                begin
                  S := ToStr(Scripter, PopVariant);
                  V := SO.GetProperty(CreateNameIndex(S, Scripter), 0);
                  if ResultID > 0 then
                    PutVariant(ResultID, V);
                  Exit;
                end;

              end;
            end;
          end;
          dkVariable:
          begin
            V := TPAXVariableDefinition(MemberRec.Definition).GetValue(Scripter);

            if IsString(V) then
            begin
              if ParamCount > 1 then
                raise TPAXScriptFailure.Create(errTooManyActualParameters);

              I := PopVariant;

              if SignZERO_BASED_STRINGS then
                Inc(I);

              S := V;
              V := S[I];
              if ResultID > 0 then
                PutVariant(ResultID, V);

              Inc(N);
              Exit;
            end
            else if IsVBArray(V) then
            begin
              SetLength(Indexes, ParamCount);
              for I:=1 to ParamCount do
                Indexes[ParamCount - I] := PopVariant;
              if ResultID > 0 then
              begin
                if VarArrayDimCount(V) = 1 then
                begin
                  I := Indexes[0];
                  PutVariant(ResultID, V[I]);
                end
                else
                begin
                  P := ArrayGet(@V, Indexes);
                  PutVariant(ResultID, Variant(P^));
                end;
              end;
              Inc(N);
              Exit;
            end;

            if ResultID > 0 then
              PutVariant(ResultID, V);
            Inc(N);
          end;
          dkConstant:
          begin
            if ResultID > 0 then
              PutVariant(ResultID, TPAXConstantDefinition(MemberRec.Definition).Value);
            Inc(N);
          end;
          dkObject:
          begin
            if ResultID > 0 then
              PutVariant(ResultID, TPAXObjectDefinition(MemberRec.Definition).Value);
            Inc(N);
          end;
          dkInterface:
          begin
            if ResultID > 0 then
              PutVariant(ResultID, TPAXInterfaceVarDefinition(MemberRec.Definition).Value);
            Inc(N);
          end;
          dkField, dkRecordField:
          begin
            if ResultID > 0 then
            begin
              V := VariantValue[ID];
              if ParamCount > 0 then
              begin
                S := ToStr(Scripter, PopVariant);
                SO := VariantToScriptObject(V);
                V := SO.GetProperty(CreateNameIndex(S, Scripter), 0);
              end;
              PutVariant(ResultID, V);
            end;
            Inc(N);
          end;
        else
          raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [Name[ID]]));
        end;
        Kind[ResultID] := KindVAR;
        Exit;
      end;

      if SubID = 0 then
        raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [Name[ID]]));

      case Kind[SubID] of
        KindSUB:
        begin
          CallSub(SubID, ParamCount, Address[ID], ResultID);
          Exit;
{
          if Count[SubID] <> -1 then
          if ParamCount <> Count[SubID] then
          begin
            SubID := GetOverloadedSubID(ID, ma, ParamCount);
            if SubID = 0 then
              raise TPAXScriptFailure.Create(errFunctionIsNotFound);
          end;
}
        end;
        KindPROP:
          begin
            SO := VariantToScriptObject(GetVariant(ID));
            Prop := SO.Get(NameIndex[ID]);

            ReadID := Prop.ReadID;
            if ReadID = 0 then
              raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [Name[ID]]));
            if (Kind[ReadID] = KindVAR) or (Kind[ReadID] = KindREF) then
            begin
              Kind[ReadID] := KindVAR;
              V := Prop.Value[0];
              if ResultID > 0 then
              begin
                PutVariant(ResultID, V);
                Kind[ResultID] := KindVAR;
              end;
              Inc(N);
            end
            else
              CallSub(Prop.ReadID, ParamCount, Address[ID], ResultID);
            Exit;
          end;
        KindTYPE:
        begin
          SO := VariantToScriptObject(GetVariant(SubID));

          if SO.ClassRec.AncestorName <> 'Function' then goto ElsePart;

          MemberRec := SO.ClassRec.GetMember(NameIndex[ID]);
          if MemberRec = nil then
            raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [Name[ID]]));

          SubID := MemberRec.ID;
          CallSub(SubID, ParamCount, Address[ID], ResultID);
          Exit;
        end
        else // not (Kind[SubID] in [KindSUB, KindPROP])
        begin
ElsePart:
          V := VariantValue[ID];
          if (IsPaxArray(V) or IsVBArray(V)) and (ID <> ResultID) then
          begin
            Prog[N].Op := OP_GET_ITEM;
            Exit;
          end;

          SO := VariantToScriptObject(GetVariant(ID));

          Prop := SO.PropertyList.FindProperty(NameIndex[ID]);

          if Prop = nil then
            goto patch;

          if Prop.ReadID = 0 then
            if IsObject(Prop.PTerminalValue^) then
              if not IsPaxArray(Prop.PTerminalValue^) then
              begin
                P := Prop.fValue;
                Prop := VariantToScriptObject(Prop.PTerminalValue^).PropertyList.GetDefaultProperty;
                if Prop <> nil then
                if ParamCount > 0 then
                begin
                  if Prop.IsImported then
                  begin
                    Definition := TPAXPropertyDefinition(Prop.Definition).ReadDef;
                    if Definition.DefKind = dkField then
                    begin
                      if ResultID > 0 then
                      begin
                        SO := VariantToScriptObject(GetVariant(ID));
                        PutVariant(ResultID, TPAXFieldDefinition(Definition).GetFieldValue(SO));
                      end;
                      Kind[ResultId] := KindVAR;
                      Inc(N);
                      Exit;
                    end
                    else if Definition.DefKind = dkRecordField then
                    begin
                      if ResultID > 0 then
                      begin
                        SO := VariantToScriptObject(GetVariant(ID));
                        if SO.ExtraPtr = nil then
                          PutVariant(ResultID, Prop.Value[0])
                        else
                          PutVariant(ResultID, TPAXRecordFieldDefinition(Definition).GetFieldValue(SO.Scripter, SO.ExtraPtr));
                      end;
                      Kind[ResultId] := KindVAR;
                      Inc(N);
                      Exit;
                    end
                    else
                    begin
                      MethodDefinition := TPAXMethodDefinition(Definition);
                      CallHostSub(MethodDefinition, P, Address[ResultID], ParamCount);
                    end;
                  end
                  else
                    CallSub(Prop.ReadID, ParamCount, P, ResultID);

                  Exit;
                end;
              end;

          if NextOp(NewN) = OP_ASSIGN_ADDRESS then
          begin
            N := NewN;
            ResultID := Prog[N].Res;
            V := CreateAlias(SO.GetAddress(NameIndex[ID], ParamCount));
            ClearVariantValue(ResultID);
            VariantValue[ResultID] := V;
            Inc(N);
            Exit;
          end;

          V := SO.GetProperty(NameIndex[ID], ParamCount);

          if IsObject(V) then
          begin
            SO := VariantToScriptObject(V);
            if SO.PClass = TPAXDelegate then
            begin
              CallSub(ID, ParamCount, Address[ID], ResultID);
              Exit;
            end;
          end;

          if ResultID > 0 then
          begin
            PutVariant(ResultID, V);
            Kind[ResultID] := KindVAR;
          end;
          Inc(N);
          Exit;
        end; // else part of case
      end; // case Kind[SubID]
    end
    else if K in [KindVAR, KindHostVar, KindHostObject] then
    begin
      if K = KindHostObject then
        V := VariantValue[ID]
      else
        V := GetVariant(ID);

patch:

      if IsString(V) then
      begin
        if ParamCount > 1 then
          raise TPAXScriptFailure.Create(errTooManyActualParameters);

        I := PopVariant;

        if SignZERO_BASED_STRINGS then
          Inc(I);

        S := V;
        V := S[I];

        if not IsAlias(Address[ID]) then
          Prog[N].Op := OP_GET_STRING_ELEMENT;
      end
      else if IsPaxArray(V) then
      begin
        SetLength(Indexes, ParamCount);
        for I:=1 to ParamCount do
          Indexes[ParamCount - I] := PopVariant;
        if ResultID > 0 then
        begin
          SO := VariantToScriptObject(V);

          if TPAXArray(SO.Instance).Typed then
          begin
            V := TPAXArray(SO.Instance).Get(Indexes);
            PutVariant(ResultID, V);
          end
          else
          begin
            VarPtr := TPAXArray(SO.Instance).GetPtr(Indexes);
            Address[ResultID] := VarPtr;
            Prog[N].Op := OP_GET_ITEM;
          end;
          Level[ResultID] := -1;
        end;

        Inc(N);
        Exit;
      end
      else if IsVBArray(V) then
      begin
        SetLength(Indexes, ParamCount);
        for I:=1 to ParamCount do
          Indexes[ParamCount - I] := PopVariant;
        if ResultID > 0 then
        begin
          if VarArrayDimCount(V) = 1 then
          begin
            I := Indexes[0];
            PutVariant(ResultID, V[I]);
          end
          else
          begin
            P := ArrayGet(Address[ID], Indexes);
            PutVariant(ResultID, Variant(P^));
          end;
        end;

        Prog[N].Op := OP_GET_ITEM;

        Inc(N);
        Exit;
      end
      else if IsObject(V) then
      begin
        SO := VariantToScriptObject(V);
        if SO.PClass = TPAXDelegate then
        begin
          CallSub(ID, ParamCount, Address[ID], ResultID);
        end

        else if (SO.ClassRec.AncestorName = 'Function') and
                (Prog[N].AltArg1 = 0) and (not SymbolTable.JSIndex[ID]) then
        begin
          SubID := SO.ClassRec.GetConstructorID;
          CallSub(SubID, ParamCount, Address[ID], ResultID);
        end

        else
        begin
          Prop := SO.PropertyList.GetDefaultProperty;

          if Prop = nil then
          begin
            S := ToStr(Scripter, PopVariant);
            V := SO.GetProperty(CreateNameIndex(S, Scripter), 0);
            if ResultID > 0 then
              PutVariant(ResultID, V);
            Inc(N);
            Exit;
          end;

          if Prop.IsImported then
          begin
            Definition := TPAXPropertyDefinition(Prop.Definition).ReadDef;
            if Definition.DefKind = dkField then
            begin
              if ResultID > 0 then
              begin
                SO := VariantToScriptObject(GetVariant(ID));
                PutVariant(ResultID, TPAXFieldDefinition(Definition).GetFieldValue(SO));
              end;
              Kind[ResultId] := KindVAR;
              Inc(N);
              Exit;
            end
            else if Definition.DefKind = dkRecordField then
            begin
              if ResultID > 0 then
              begin
                SO := VariantToScriptObject(GetVariant(ID));
                if SO.ExtraPtr = nil then
                  PutVariant(ResultID, Prop.Value[0])
                else
                  PutVariant(ResultID, TPAXRecordFieldDefinition(Definition).GetFieldValue(SO.Scripter, SO.ExtraPtr));
              end;
              Kind[ResultId] := KindVAR;
              Inc(N);
              Exit;
            end;

            MethodDefinition := TPAXMethodDefinition(Definition);
            CallHostSub(MethodDefinition, GetAddressEx(ID), Address[ResultID], ParamCount);
          end
          else
            CallSub(Prop.ReadID, ParamCount, GetAddressEx(ID), ResultID);
        end;
        Kind[ResultID] := KindVAR;
        Exit;
      end
      else if IsUndefined(V) then
      begin
        L := SymbolTable.Level[ID];
        for I := ID - 1 downto 1 do
          if SymbolTable.NameIndex[I] = SymbolTable.NameIndex[ID] then
            if SymbolTable.Level[I] = L then
            begin
              V := VariantValue[I];
              if not IsUndefined(V) then
              begin
                ReplaceId(ID, I);
                goto Patch;
              end;
            end;
        raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [Name[ID]]));
      end
      else
        raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [Name[ID]]));

     if ResultID > 0 then
       VariantValue[ResultID] := V;
     Inc(N);
     Exit;
    end
    else if (K = KindVAR) or (K = KindHostVar) then
    begin
      V := GetVariant(ID);
      if IsString(V) then
      begin
        if ParamCount > 1 then
          raise TPAXScriptFailure.Create(errTooManyActualParameters);

        I := PopVariant;

        if SignZERO_BASED_STRINGS then
          Inc(I);

        S := V;
        V := S[I];

        if not IsAlias(Address[ID]) then
          Prog[N].Op := OP_GET_STRING_ELEMENT;
      end
      else if IsPaxArray(V) then
      begin
        SetLength(Indexes, ParamCount);
        for I:=1 to ParamCount do
          Indexes[ParamCount - I] := PopVariant;
        if ResultID > 0 then
        begin
          SO := VariantToScriptObject(V);

          if TPAXArray(SO.Instance).Typed then
          begin
            V := TPAXArray(SO.Instance).Get(Indexes);
            PutVariant(ResultID, V);
          end
          else
          begin
            VarPtr := TPAXArray(SO.Instance).GetPtr(Indexes);
            Address[ResultID] := VarPtr;
            Prog[N].Op := OP_GET_ITEM;
          end;
          Level[ResultID] := -1;
        end;

        Inc(N);
        Exit;
      end
      else if IsVBArray(V) then
      begin
        SetLength(Indexes, ParamCount);
        for I:=1 to ParamCount do
          Indexes[ParamCount - I] := PopVariant;
        if ResultID > 0 then
        begin
          if VarArrayDimCount(V) = 1 then
          begin
            I := Indexes[0];
            PutVariant(ResultID, V[I]);
          end
          else
          begin
            P := ArrayGet(Address[ID], Indexes);
            PutVariant(ResultID, Variant(P^));
          end;
        end;

        Prog[N].Op := OP_GET_ITEM;

        Inc(N);
        Exit;
      end
      else if IsObject(V) then
      begin
        SO := VariantToScriptObject(GetVariant(ID));
        if SO.PClass = TPAXDelegate then
        begin
          CallSub(ID, ParamCount, Address[ID], ResultID);
        end
        else if (SO.ClassRec.AncestorName = 'Function') and (Prog[N].AltArg1 = 0) and (not SymbolTable.JSIndex[Prog[N].Arg1]) then
        begin
          SubID := SO.ClassRec.GetConstructorID;
          CallSub(SubID, ParamCount, Address[ID], ResultID);
        end
        else
        begin
          Prop := SO.PropertyList.GetDefaultProperty;

          if Prop = nil then
          begin
            S := ToStr(Scripter, PopVariant);
            V := SO.GetProperty(CreateNameIndex(S, Scripter), 0);
            if ResultID > 0 then
              PutVariant(ResultID, V);
            Inc(N);
            Exit;
          end;

          if Prop.IsImported then
          begin
            Definition := TPAXPropertyDefinition(Prop.Definition).ReadDef;
            if Definition.DefKind = dkField then
            begin
              if ResultID > 0 then
              begin
                SO := VariantToScriptObject(GetVariant(ID));
                PutVariant(ResultID, TPAXFieldDefinition(Definition).GetFieldValue(SO));
              end;
              Kind[ResultId] := KindVAR;
              Inc(N);
              Exit;
            end
            else if Definition.DefKind = dkRecordField then
            begin
              if ResultID > 0 then
              begin
                SO := VariantToScriptObject(GetVariant(ID));
                if SO.ExtraPtr = nil then
                  PutVariant(ResultID, Prop.Value[0])
                else
                  PutVariant(ResultID, TPAXRecordFieldDefinition(Definition).GetFieldValue(SO.Scripter, SO.ExtraPtr));
              end;
              Kind[ResultId] := KindVAR;
              Inc(N);
              Exit;
            end;

            MethodDefinition := TPAXMethodDefinition(Definition);
            CallHostSub(MethodDefinition, Address[ID], Address[ResultID], ParamCount);
          end
          else
            CallSub(Prop.ReadID, ParamCount, Address[ID], ResultID);
        end;
        Kind[ResultID] := KindVAR;
        Exit;
      end
      else
        raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [Name[ID]]));

     if ResultID > 0 then
       VariantValue[ResultID] := V;
     Inc(N);
     Exit;
    end
    else if K = KindTYPE then
    begin
      SO := VariantToScriptObject(GetVariant(ID));
      MemberRec := SO.ClassRec.GetMember(NameIndex[ID]);
      if MemberRec = nil then
        raise TPAXScriptFailure.Create(Format(errPropertyIsNotFound, [Name[ID]]));

      SubID := MemberRec.ID;
      CallSub(SubID, ParamCount, SymbolTable.Address[ID], ResultID, true);
      Exit;
    end
    else
      SubID := ID;
  end;

  CallSub(SubID, ParamCount, SymbolTable.Address[ID], ResultID);
end;

procedure TPAXCode.OperRet;
var
  SubID, ResultID, I, ID: Integer;
  V: Variant;
  SO: TPaxScriptObject;
begin
  if DebugState then
    DebugInfo.PopProc;

  Dec(LevelStack.Card);

  with Stack do
  begin
    ResultID := fItems[Card];
    Dec(Card);

    SubID := fItems[Card];
    Dec(Card);

    N := fItems[Card];
    Dec(Card);

{
    Pop(ResultID);
    Pop(_SubID);
    Pop(N);
}
  end;

  with SymbolTable do
  begin
    if ResultID > 0 then
    begin

      if TypeSub[SubID] = tsConstructor then
      begin
        if SignRETURN then
          V := Variant(Address[GetResultID(SubID)]^)
        else
          V := VariantValue[GetThisID(SubID)];
      end
      else
        V := Variant(Address[GetResultID(SubID)]^);
    end;

    DeallocateSub(SubID);

    for I:=1 to RefStack.Pop do
    with RefStack do
    begin
      ID := fItems[Card];
      Dec(Card);

      if IsObject(PVariant(Address[ID])^) then
      begin
        SO := VariantToScriptObject(PVariant(Address[ID])^);
        SO.RefCount := 0;
      end;

      A[ID].Address := Pointer(fItems[Card]);

      Dec(Card);
    end;

    if ResultID > 0 then
    begin
      Kind[ResultID] := kindVAR;
      Variant(Address[ResultID]^) := V;
    end;
  end;

  Inc(N);
  SignRETURN := false;
end;

procedure TPAXCode.OperGetPublishedProperty;
var
  SO: TPaxScriptObject;
begin
  with SymbolTable, Prog[N] do
    if Res > 0 then
    begin
//      SO := VariantToScriptObject(PVariant(Address[Arg1])^);
      SO := TPaxScriptObject(PInteger(ShiftPointer(Address[Arg1], 8))^);

      PutVariant(Res, SO.GetPublishedProperty(Name[Arg1], Arg2));

      Kind[Res] := KindVAR;
    end;
  Inc(N);
end;

procedure TPAXCode.OperPutPublishedProperty;
var
  SO: TPaxScriptObject;
begin
  with SymbolTable, Prog[N] do
  begin
//    SO := VariantToScriptObject(PVariant(Address[Arg1])^);
    SO := TPaxScriptObject(PInteger(ShiftPointer(Address[Arg1], 8))^);
    SO.PutPublishedProperty(Name[Arg1], PVariant(Stack.PopPointer)^);
  end;
  Inc(N);
end;

procedure TPAXCode.OperSetLabel;
begin
  Prog[N].Res := WithStack.Card;
  Inc(N);
end;

procedure TPAXCode.OperGetParamCount;
begin
  with SymbolTable, Prog[N] do
    PutVariant(Arg1, _ParamCount);
  Inc(N);
end;

procedure TPAXCode.OperGetParam;
var
  SubID, I, ParamID: Integer;
begin
  with SymbolTable, Prog[N] do
  begin
    SubID := Arg1;
    I := GetVariant(Arg2);
    ParamID := GetParamID(SubID, I + 1);
    PutVariant(Res, GetVariant(ParamID));
  end;
  Inc(N);
end;

procedure TPAXCode.OperExit0;
var
  Op: Integer;
begin
  if LevelStack.Card <= 1 then
  begin
    fTerminated := true;
    Op := Prog[N].Op;
    while Op <> OP_HALT do
    begin
      Inc(N);
      Op := Prog[N].Op;
    end;
  end
  else
    Inc(N);
end;

procedure TPAXCode.OperExit;

function RetExpected: Boolean;
var
  I, Op: Integer;
begin
  result := false;
  for I:= N+1 to Card do
  begin
    Op := Prog[I].Op;
    if Op = OP_SEPARATOR then
      Exit
    else if Op = OP_RET then
    begin
      result := true;
      Exit;
    end;
  end;
end;

var
  Op, Arg1, K: Integer;
begin
  Arg1 := Prog[N].Arg1;
  if Arg1 > 0 then
  begin
    if N < Arg1 then
      while N < Arg1 do
      begin
        Op := Prog[N].Op;
        if Op = OP_BEGIN_WITH then
          OperBeginWith
        else if Op = OP_END_WITH then
          OperEndWith
        else
          Inc(N);
      end
    else if N > Arg1 then
    begin
      while WithStack.Card > Prog[Arg1].Res do
        WithStack.Pop;
      N := Arg1;
    end;
    Exit;
  end;

  Op := Prog[N].Op;

  if Op = OP_SEPARATOR then
    if RetExpected then
      Exit;

  K := 0;
  while (Op <> OP_RET) and
        (Op <> OP_HALT) do
  begin
    if Op = OP_BEGIN_WITH then
      OperBeginWith
    else if Op = OP_END_WITH then
      OperEndWith
    else
      Inc(N);
    Op := Prog[N].Op;

    if Op = OP_SEPARATOR then
      if RetExpected then
        Exit;

    if OP = OP_TRY_ON then
      Inc(K)
    else if OP = OP_TRY_OFF then
      Dec(K)
    else if OP = OP_FINALLY then
    begin
      if K = 0 then
        Exit;
    end;
  end;
end;

procedure TPAXCode.OperReturn;
begin
  OperExit;
  SignRETURN := true;
end;

procedure TPAXCode.OperExitOnError;
begin
  if not TPAXBaseScripter(Scripter).IsError then
    Inc(N)
  else
    RaiseException;
//    OperExit;
end;

procedure TPAXCode.OperDiscardError;
begin
  TPAXBaseScripter(Scripter).DiscardError;
  Inc(N);
end;

procedure TPAXCode.OperFinally;
begin
  Inc(N);
end;

procedure TPAXCode.OperCatch;
begin
  Inc(N);
end;

procedure TPAXCode.OperTryOn;
begin
  TryStack.Push(N, Prog[N].Arg1);
  Inc(N);
end;

procedure TPAXCode.OperTryOff;
begin
  TryStack.Pop;
  Inc(N);
end;

procedure TPAXCode.OperThrow;
begin
  with SymbolTable, Prog[N] do
    if Arg1 > 0 then
      TPAXBaseScripter(Scripter).Error := VariantValue[Arg1];
//  RaiseException;
  raise Exception.Create(toString(TPAXBaseScripter(Scripter).Error));
end;

procedure TPAXCode.RaiseException;
label
  Again;
var
  Op: Integer;
  N1: Integer;
begin
  if TryStack.Card = 0 then
  begin
    N := Card;
    Exit;
  end;

Again:

  N1 := N;

  Op := Prog[N].Op;

  while (Op <> OP_RET) and
        (Op <> OP_FINALLY) and
        (Op <> OP_CATCH) and
        (Op <> OP_HALT) do
  begin
    if Op = OP_TRY_ON then
      OperTryOn
    else if Op = OP_TRY_OFF then
      OperTryOff
    else
      Inc(N);

    Op := Prog[N].Op;
  end;

  if Op = OP_RET then
  begin
    OperRet;
    goto Again;
  end
  else if Op = OP_CATCH then
  begin
    if TryStack.Legal(N1) then
    begin
      with SymbolTable, Prog[N] do
        if Arg1 > 0 then
           VariantValue[Arg1] := TPAXBaseScripter(Scripter).Error;
      OperDiscardError;
    end
    else
    begin
      Inc(N);
      goto Again;
    end;
  end
  else if OP = OP_FINALLY then
  begin
    if not TryStack.Legal(N1) then
    begin
      Inc(N);
      goto Again;
    end;
  end;
end;

procedure TPAXCode.OperDoNotDestroy;
begin
  TPAXBaseScripter(Scripter).DoNotDestroyList.Add(Prog[N].Arg1);
  Inc(N);
end;

procedure TPAXCode.OperGetField;
var
  ObjectID, FieldID, K, NameIndex: Integer;
  SO: TPaxScriptObject;
  V: Variant;
begin
  ObjectID := Prog[N].Arg1;
  K := Prog[N].Arg2;
  FieldID := Prog[N].Res;
  V := SymbolTable.VariantValue[ObjectID];
  SO := VariantToScriptObject(V);
  if K < SO.PropertyList.Count then
  begin
    NameIndex := SO.PropertyList.NameID[K];
    SymbolTable.NameIndex[FieldID] := NameIndex;
    SymbolTable.Kind[FieldID] := KindREF;
    SymbolTable.PutVariant(FieldID, V);
  end;
  Inc(N);
end;

procedure TPAXCode.OperCreateArray;
var
  I, ID, DimCount: Integer;
  P: array of Integer;
  V: Variant;
  SO: TPAXScriptObject;
  Bounds: array of integer;
begin
  ID := Prog[N].Arg1;
  DimCount := Prog[N].Arg2;
  SetLength(P, DimCount);

  for I:=1 to DimCount do
    P[DimCount - I] := PopVariant;

  if SignVBArrays then
  begin
    SetLength(Bounds, DimCount * 2);
    for I:=0 to DimCount - 1 do
    begin
      Bounds[I*2] := 0;
      Bounds[I*2 + 1] := P[I];
    end;

    V := VarArrayCreate(Bounds, varVARIANT);
  end
  else
  begin
    SO := TPAXBaseScripter(Scripter).ArrayClassRec.CreateScriptObject;
    SO.RefCount := 1;
    SO.Instance := TPAXArray.Create(P, Prog[N].Res);
    TPAXArray(SO.Instance).Scripter := Scripter;
    V := ScriptObjectToVariant(SO);
  end;

  SymbolTable.PutVariant(ID, V);

  Inc(N);
end;

procedure TPAXCode.OperCreateShortString;
var
  ID, I, L: Integer;
  S: String;
begin
  ID := Prog[N].Arg1;
  L := PopVariant;

  S := '';
  for I:=1 to L do S := S + ' ';

  SymbolTable.PutVariant(ID, S);

  Inc(N);
end;

procedure TPAXCode.OperGetItem;
var
  SO: TPAXScriptObject;
  I: Integer;
  PaxArray: TPAxArray;
  V: Variant;
  P: Pointer;
  Indexes: array of Integer;
begin
  with Prog[N], SymbolTable do
  begin
    V := VariantValue[Arg1];
    if IsVBArray(V) then
    begin
      SetLength(Indexes, Arg2);
      for I:=1 to Arg2 do
        Indexes[Arg2 - I] := PopInteger;
      if Res > 0 then
      begin
        if VarArrayDimCount(V) = 1 then
        begin
          I := Indexes[0];
          PutVariant(Res, V[I]);
        end
        else
        begin
          P := ArrayGet(Address[Arg1], Indexes);
          PutVariant(Res, Variant(P^));
        end;
      end;
      Level[Res] := -1;
    end
    else
    begin
      SO := VariantToScriptObject(V);
      PaxArray := TPAXArray(SO.ExtraInstance);
      PaxArray.ClearIndexes;
      for I:=1 to Arg2 do
        PaxArray.InsertIndex(PopInteger);
      if Res > 0 then
      begin
        if PaxArray.Typed then
        begin
          V := PaxArray._Get;
          PutVariant(Res, V);
        end
        else
        begin
          P := PaxArray._GetPtr;
          Address[Res] := P;
        end;
        Level[Res] := -1;
      end;
    end;
  end;
  Inc(N);
end;

procedure TPAXCode.OperGetItemEx;
var
  SO: TPAXScriptObject;
  I: Integer;
  PaxArray: TPAxArray;
  V: Variant;
  P: Pointer;
  Indexes: array of Integer;
begin
  with Prog[N], SymbolTable do
  begin
    V := VariantValue[Arg1];
    if IsVBArray(V) then
    begin
      SetLength(Indexes, Arg2);
      for I:=1 to Arg2 do
        Indexes[Arg2 - I] := PopInteger;
      if Res > 0 then
      begin
        if VarArrayDimCount(V) = 1 then
        begin
          I := Indexes[0];
          PutVariant(Res, V[I]);
        end
        else
        begin
          P := ArrayGet(@V, Indexes);
          PutVariant(Res, Variant(P^));
        end;
        Level[Res] := -1;
      end;
    end
    else
    begin
      SO := VariantToScriptObject(V);
      PaxArray := TPAXArray(SO.ExtraInstance);
      PaxArray.ClearIndexes;
      for I:=1 to Arg2 do
        PaxArray.InsertIndex(PopInteger);
      if Res > 0 then
      begin
        if PaxArray.Typed then
        begin
          V := PaxArray._GetEx;
          PutVariant(Res, V);
        end
        else
        begin
          P := PaxArray._GetPtrEx;
          Address[Res] := P;
        end;
        Level[Res] := -1;
      end;
    end;
  end;
  Inc(N);
end;

procedure TPAXCode.OperPutItem;
var
  SO: TPAXScriptObject;
  I, K: Integer;
  Value: Variant;
  PaxArray: TPAxArray;
  V: Variant;
  Indexes: array of Integer;
begin
  Value := DuplicateObject(PopVariant);

  with Prog[N], SymbolTable do
  begin
    V := VariantValue[Arg1];
    K := Arg2 - 1;

    if IsVBArray(V) then
    begin
      SetLength(Indexes, K);
      for I:=1 to K do
        Indexes[K - I] := PopInteger;

     if VarArrayDimCount(V) = 1 then
     begin
       I := Indexes[0];
       Variant(Address[Arg1]^)[I] := Value;
     end
     else
        ArrayPut(Address[Arg1], Indexes, Value);
    end
    else
    begin
      SO := VariantToScriptObject(V);
      PaxArray := TPAXArray(SO.ExtraInstance);
      PaxArray.ClearIndexes;

      for I:=1 to K do
        PaxArray.InsertIndex(PopInteger);
      PaxArray._Put(Value);
    end;
  end;
  Inc(N);
end;

procedure TPAXCode.OperPutItemEx;
var
  SO: TPAXScriptObject;
  I, K: Integer;
  Value: Variant;
  PaxArray: TPAxArray;

  V: Variant;
  Indexes: array of Integer;
begin
  Value := DuplicateObject(PopVariant);

  with Prog[N], SymbolTable do
  begin
    V := GetVariant(Arg1);
    K := Arg2 - 1;

    if IsVBArray(V) then
    begin
      SetLength(Indexes, K);
      for I:=1 to K do
        Indexes[K - I] := PopInteger;

     if VarArrayDimCount(V) = 1 then
     begin
       I := Indexes[0];
       Variant(Address[Arg1]^)[I] := Value;
     end
     else
        ArrayPut(Address[Arg1], Indexes, Value);
    end
    else
    begin
      SO := VariantToScriptObject(Variant(Address[Arg1]^));
      PaxArray := TPAXArray(SO.ExtraInstance);
      PaxArray.ClearIndexes;
      for I:=1 to K do
        PaxArray.InsertIndex(PopInteger);
      PaxArray._PutEx(Value);
    end;
  end;
  Inc(N);
end;

procedure TPAXCode.OperGetStringElement;
var
  I: Integer;
begin
  with SymbolTable, Prog[N] do
  begin
    I := TVarData(Stack.PopPointer^).VInteger;
    if SignZERO_BASED_STRINGS then
      Inc(I);
    PutVariant(Res, String(TVarData(A[Arg1].Address^).VString)[I]);
  end;
  Inc(N);
end;

procedure TPAXCode.OperPutStringElement;
var
  Ch: Char;
  I: Integer;
begin
  with SymbolTable, Prog[N] do
  begin
    Ch := PChar(TVarData(Stack.PopPointer^).VString)^;
    I := TVarData(Stack.PopPointer^).VInteger;
    if SignZERO_BASED_STRINGS then
      Inc(I);
    String(TVarData(A[Arg1].Address^).VString)[I] := Ch;
  end;
  Inc(N);
end;

procedure TPAXCode.OperCreateObject;
var
  SO, ClassObject: TPAXScriptObject;
  ID: Integer;
  V: Variant;
  ClassRec: TPAXClassRec;
  MemberRec: TPAXMemberRec;
  S: String;
  ClassDef: TPaxClassDefinition;
begin
  with SymbolTable, Prog[N] do
  begin
    if Kind[Arg1] = KindSUB then
      ID := Level[Arg1]
    else
      ID := Arg1;

    V := VariantValue[ID];
    if VarType(V) <> varScriptObject then
    begin
      S := Name[ID];
      ClassDef := DefinitionList.FindClassDefByName(S);
      if ClassDef = nil then
      begin
        if (Arg1 >= 0) and (Arg1 <= PaxTypes.Count) then
        begin
          OP := OP_NOP;
          Exit;
        end;
        raise TPAXScriptFailure.Create(Format(errClassIsNotFound, [S]));
      end;
      Arg1 := - ClassDef.Index;
      ID := Arg1;
      V := VariantValue[ID];
    end;

    ClassObject := VariantToScriptObject(V);
    ClassRec := ClassObject.ClassRec;

    if ClassRec.OwnerClassRec <> nil then
    begin
      MemberRec := ClassRec.OwnerClassRec.GetMember(NameIndex[ClassRec.ClassID]);
      MemberRec.CheckAccess;
    end;

    WithStack.Push(ClassRec.ClassID);

//    if ClassRec = TPAXBaseScripter(Scripter).ClassList.FunctionClassRec then
    if ClassRec.AncestorName = 'Function' then
    begin
      SO := FunctionClass.Create(ClassRec);
    end
    else
      SO := ClassRec.CreateScriptObject(Name[Res]);

    SO.RefCount := 1;
    WithStack.Pop;
    Kind[Res] := KindVar;
    VariantValue[Res] := ScriptObjectToVariant(SO);
  end;

  Inc(N);
end;

procedure TPAXCode.OperDestroyHost;
var
  V: Variant;
  SO: TPAXScriptObject;
begin
  with SymbolTable, Prog[N] do
  begin
    V := VariantValue[Arg1];
    if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);
      if SO.Instance <> nil then
        if (SO.Instance <> SO) {and (SO.Instance.ClassType <> TPaxArray)} then
          SO.Instance.Free;
    end;
  end;
  Inc(N);
end;

procedure TPAXCode.OperDestroyObject;
var
  P: PVariant;
  V: Variant;
  SO: TPAXScriptObject;
begin
  with SymbolTable, Prog[N] do
  begin
    V := VariantValue[Arg1];
    if Kind[Arg1] <> KindREF then
      P := GetTerminal(Address[Arg1])
    else
    begin
      SO := VariantToScriptObject(GetVariant(Arg1));
      P := SO.GetAddress(NameIndex[Arg1], 0);
    end;
    VarClear(P^);

    if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);
      TPAXBaseScripter(Scripter).ScriptObjectList.RemoveObject(SO);
    end;
  end;
  Inc(N);
end;

procedure TPAXCode.OperDestroyLocalVar;
var
  V: Variant;
  SO: TPAXScriptObject;
begin
  with SymbolTable, Prog[N] do
  begin
    V := VariantValue[Arg1];
    if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);
      if TPAXBaseScripter(Scripter).ScriptObjectList.HasObject(SO) then
      begin
        if SO.ClassRec.ck = ckStructure then
          TPAXBaseScripter(Scripter).ScriptObjectList.RemoveObject(SO)
        else if SO.ClassRec.ck = ckInterface then
        begin
          if SO.Intf <> nil then
            SO.Intf._Release;
          TPAXBaseScripter(Scripter).ScriptObjectList.RemoveObject(SO);
        end;
      end;
    end;
  end;
  Inc(N);
end;

procedure TPAXCode.OperDestroyIntf;
var
  V: Variant;
  SO: TPAXScriptObject;
begin
  with SymbolTable, Prog[N] do
  begin
    V := VariantValue[Arg1];
    if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);
      if TPAXBaseScripter(Scripter).ScriptObjectList.HasObject(SO) then
      begin
        if SO.ClassRec.ck = ckInterface then
        begin
          if SO.PIntf <> nil then
            SO.PIntf^ := nil
          else
          begin

          if SO.Intf <> nil then
          begin
            if IntfRefCount(SO.Intf) = 1 then
            begin
              SO.Intf := nil;
//              Pointer (SO.Intf) := Nil //--jgv
            end
            else
              SO.Intf._Release;
          end;

//            SO.Intf := nil;

            if Res = 0 then
            begin
              TPAXBaseScripter(Scripter).ScriptObjectList.RemoveObject(SO);
            end;
          end;
        end;
      end;
    end;
  end;
  Inc(N);
end;

procedure TPAXCode.OperRelease;
var
  P: PVariant;
  SO: TPAXScriptObject;
begin
  with SymbolTable, Prog[N] do
  begin
    if Kind[Arg1] <> KindREF then
      P := Address[Arg1]
    else
    begin
      SO := VariantToScriptObject(GetVariant(Arg1));
      P := SO.GetAddress(NameIndex[Arg1], 0);
    end;
    if IsObject(P^) then
    begin
      SO := VariantToScriptObject(P^);
      TPAXBaseScripter(Scripter).ScriptObjectList.RemoveObject(SO);
    end;
    VarClear(P^);
  end;
  Inc(N);
end;

{
procedure TPAXCode.OperCreateRef;
begin
  with SymbolTable, Prog[N] do
    SetRef(Res, VariantValue[Arg1], TPAXMemberAccess(Arg2));

  Inc(N);
end;
}

procedure TPAXCode.OperCreateRef;
var
  SO: TPAXScriptObject;
  P: Pointer;
  I: Integer;
  DefList: TPAXDefinitionList;
  DV: TPAXVariableDefinition;
  V: Variant;
  L: Integer;
begin
  with SymbolTable, Prog[N] do
  begin
    if Kind[Arg1] = KindHOSTVAR then
    begin
      I := GetVariant(Arg1);

      if I > 0 then
      begin
        DefList := DefinitionList;
        DV := TPaxVariableDefinition(DefList[I]);
      end
      else
      begin
        DefList := TPaxBaseScripter(Scripter).LocalDefinitions;
        DV := TPaxVariableDefinition(DefList.GetRecordByIndex(- I));
      end;

      if DV.TypeID <> typeCLASS then
      begin
        SetRef(Res, VariantValue[Arg1], TPAXMemberAccess(Arg2));
        Inc(N);
        Exit;
      end;

      P := DV.Address;
      SO := DelphiInstanceToScriptObject(TObject(P^), scripter);
      SetRef(Res, ScriptObjectToVariant(SO), TPAXMemberAccess(Arg2));
    end
    else if Kind[Arg1] = KindVIRTUALOBJECT then
    begin
      SymbolTable.SetReference(Res, VariantValue[Arg1], TPAXMemberAccess(Arg2));
    end
    else
    begin
      V := VariantValue[Arg1];
      if IsUndefined(V) then
      begin
        L := SymbolTable.Level[Arg1];
        for I := Arg1 - 1 downto 1 do
          if SymbolTable.NameIndex[I] = SymbolTable.NameIndex[Arg1] then
            if SymbolTable.Level[I] = L then
            begin
              V := VariantValue[I];
              if not IsUndefined(V) then
              begin
                ReplaceId(Arg1, I);
                break;
              end;
            end;
      end;
      SetRef(Res, V, TPAXMemberAccess(Arg2));
    end;
  end;

  Inc(N);
end;


procedure TPAXCode.OperUseNamespace;
begin
  UsingList.PushUnique(Prog[N].Arg1);
  Inc(N);
end;

procedure TPAXCode.OperEndOfNamespace;
begin
  UsingList.Delete(Prog[N].Arg1);
  Inc(N);
end;

procedure TPAXCode.OperBeginWith;
begin
  if N > 1 then if
    Prog[N-1].Op = OP_BEGIN_WITH then
      Dec(N);

  while Prog[N].Op = OP_BEGIN_WITH do
  begin
    WithStack.Push(Prog[N].Arg1);
    Inc(N);
  end;
end;

procedure TPAXCode.OperEndWith;
begin
  while Prog[N].Op = OP_END_WITH do
  begin
    if WithStack.Card > 0 then
      WithStack.Pop;
    Inc(N);
  end;
end;

procedure TPAXCode.OperEvalWith;
label Again1, Again2;
var
  I, ObjectID, ANameIndex, K: Integer;
  SO: TPAXScriptObject;
  MemberRec: TPAXMemberRec;
  V: Variant;
  S: String;
  D, DDest: TPaxDefinition;
  ClassRec: TPaxClassRec;
  SubID: Integer;
begin
  with SymbolTable, Prog[N] do
    ANameIndex := NameIndex[Res];

  MemberRec := nil;

  for I:=WithStack.Card downto 1 do
  begin
    ObjectID := WithStack.fItems[I];

Again1:

    K := SymbolTable.Kind[ObjectID];
    if K = KindTYPE then
    begin
      SO := VariantToScriptObject(ToObject(SymbolTable.VariantValue[ObjectID], Scripter));
      MemberRec := SO.ClassRec.FindMember(ANameIndex, maAny, UpCaseON);

      if MemberRec <> nil then
      begin
        MemberRec.CheckAccess;
        with SymbolTable, Prog[N] do
          if Res <> MemberRec.ID then
          begin
            if Kind[MemberRec.ID] = KindSUB then
              if Count[MemberRec.ID] = 0 then
                if Prog[N+1].Op <> OP_CALL then
                  if Prog[N+1].Op <> OP_ASSIGN_ADDRESS then
                  begin
                    SymbolTable.SaveState;
                    K := EvalGetFunction(MemberRec.ID, 0);
                    PutVariant(Res, VariantValue[K]);
                    Kind[Res] := KindVAR;
                    SymbolTable.RestoreState;

                    Break;
                  end;
            SetRef(Res, VariantValue[ObjectID], maAny);
          end
          else
          begin
//            Prog[N].Op := OP_NOP;

            if MemberRec.IsStatic then
              Prog[N].Op := OP_NOP
            else
              if Kind[Res] = KindVAR then
                 SetRef(Res, VariantValue[ObjectID], maAny);

          end;
        Break;
      end;
    end
    else if K = KindRef then
    begin
      V := SymbolTable.VariantValue[ObjectID];
      SO := VariantToScriptObject(ToObject(V, Scripter));
      if SO.IsClass then
        ObjectID := SO.ClassRec.ClassID
      else
      begin
        SymbolTable.PutVariant(ObjectID, V);
        SymbolTable.Kind[ObjectID] := KindVAR;
      end;
      goto Again1;
    end
    else
    begin
      SO := VariantToScriptObject(ToObject(SymbolTable.VariantValue[ObjectID], Scripter));
      MemberRec := SO.ClassRec.FindMember(ANameIndex, maAny, UpCaseON);
      if MemberRec <> nil then
      begin
        MemberRec.CheckAccess;

        with SymbolTable, Prog[N] do
        begin
          if MemberRec.IsStatic then
          begin
            if Res <> MemberRec.ID then
              SetRef(Res, VariantValue[SO.ClassRec.ClassID], maAny);
          end
          else
          begin
            if Kind[MemberRec.ID] = KindSUB then
              if Count[MemberRec.ID] = 0 then
                if Prog[N+1].Op <> OP_CALL then
                  if Prog[N+1].Op <> OP_ASSIGN_ADDRESS then
                  begin
                    SymbolTable.SaveState;
                    K := EvalGetFunction(MemberRec.ID, 0);
                    PutVariant(Res, VariantValue[K]);
                    Kind[Res] := KindVAR;
                    SymbolTable.RestoreState;

                    Break;
                  end;

            SubID := MemberRec.ReadID;

            if SubId <> 0 then
              if Kind[SubId] = KindSUB then
                if Count[SubId] = 0 then
                  if Prog[N+1].Op <> OP_CALL then
                    if Prog[N+1].Op <> OP_ASSIGN_ADDRESS then
                  begin

                    if (Prog[N+1].Op = OP_ASSIGN) and (Prog[N].Res = Prog[N+1].Arg1) then
                    if MemberRec.WriteID <> 0 then
                    begin
                      SetRef(Res, VariantValue[ObjectID], maAny);
                      break;
                    end;

                    if (Prog[N+2].Op = OP_ASSIGN) and (Prog[N].Res = Prog[N+2].Arg1) then
                    if MemberRec.WriteID <> 0 then
                    begin
                      SetRef(Res, VariantValue[ObjectID], maAny);
                      break;
                    end;

                    SymbolTable.SaveState;
                    K := EvalGetFunction(SubId, 0);
                    PutVariant(Res, VariantValue[K]);
                    Kind[Res] := KindVAR;
                    SymbolTable.RestoreState;

                    Break;
                  end;

            SetRef(Res, VariantValue[ObjectID], maAny);
          end;
        end;
        Break;
      end
      else
      begin
        if SO.HasPublishedProperty(_GetName(ANameIndex, Scripter)) then
        begin
          with SymbolTable, Prog[N] do
            SetRef(Res, VariantValue[ObjectID], maAny);
          Inc(N);
          Exit;
        end;
      end;
    end;
  end;

  if MemberRec = nil then
    for I:=UsingList.Card downto 1 do
    begin
      ObjectID := UsingList.fItems[I];

  Again2:

      K := SymbolTable.Kind[ObjectID];

      if K = KindTYPE then
      begin
        V := SymbolTable.VariantValue[ObjectID];
        if IsUndefined(V) then
          continue;

        SO := VariantToScriptObject(V);
        MemberRec := SO.ClassRec.FindMember(ANameIndex, maAny, UpCaseON);
        if MemberRec <> nil then
        begin
          MemberRec.CheckAccess;

          with SymbolTable, Prog[N] do
            if Res <> MemberRec.ID then
            begin

              if Kind[MemberRec.ID] = KindSUB then
              if Count[MemberRec.ID] = 0 then
                if Prog[N+1].Op <> OP_CALL then
                  if Prog[N+1].Op <> OP_ASSIGN_ADDRESS then
                  begin
                    SymbolTable.SaveState;
                    K := EvalGetFunction(MemberRec.ID, 0);
                    PutVariant(Res, VariantValue[K]);
                    Kind[Res] := KindVAR;
                    SymbolTable.RestoreState;

                    Break;
                  end;

              if MemberRec.IsStatic then
              begin
                if MemberRec.Kind = KindSub then
                begin
                  ReplaceID(Prog[N].Res, MemberRec.ID);
                  Inc(N);
                end
                else
                begin
                  if SymbolTable.Kind[MemberRec.ID] = KindHostObject then
                  begin
                    ReplaceID(Prog[N].Res, MemberRec.ID);
                    Prog[N].Op := OP_NOP;
                    Inc(N);
                  end
                  else
                  begin
                    Prog[N].Op := OP_CREATE_REF;
                    Prog[N].Arg1 := ObjectID;
                    Prog[N].Arg2 := Integer(maAny);
                  end;
                end;
                Exit;
//              SetRef(Res, VariantValue[ObjectID], maAny);
              end
              else if Kind[MemberRec.ID] = KindTYPE then
                SetRef(Res, VariantValue[ObjectID], maAny)
            end;
          Break;
        end;
      end
      else if K = KindRef then
      begin
        ObjectID := VariantToScriptObject(SymbolTable.VariantValue[ObjectID]).ClassRec.ClassID;
        goto Again2;
      end;
    end;

  if MemberRec = nil then
  begin
    S := _GetName(ANameIndex, Scripter);

    if SignLoadOnDemand then
    begin
      for I:=UsingList.Card downto 1 do
      begin
        ObjectID := UsingList[I];
        if ObjectID < 0 then
        begin
          D := DefinitionList.GetRecordByIndex(- ObjectID);
          DDest := DefinitionList.Lookup(S, dkAny, D);
          if DDest <> nil then
          begin
            ClassRec := ClassList.FindClass(ObjectID);
            if ClassRec = nil then
              ClassRec := ClassList.FindClassByName(D.Name);

            if DDest.DefKind = dkConstant then
              MemberRec := ClassRec.AddHostConstant(DDest as TPaxConstantDefinition)
            else if DDest.DefKind = dkVariable then
              MemberRec := ClassRec.AddHostVariable(DDest as TPaxVariableDefinition)
            else if DDest.DefKind = dkObject then
              MemberRec := ClassRec.AddHostObject(DDest as TPaxObjectDefinition)
            else if DDest.DefKind = dkMethod then
              MemberRec := ClassRec.AddHostMethod(DDest as TPaxMethodDefinition);
{
            else if DDest.DefKind = dkClass then
            begin
              DDest.AddToScripter(Scripter);
              MemberRec := ClassRec.MemberList.Records[ClassRec.MemberList.Count - 1];
            end;
}
            break;
          end;
        end;
      end;

      if MemberRec = nil then
      begin
        DDest := DefinitionList.Lookup(S, dkAny, nil);
        if DDest <> nil then
        begin
          ClassRec := ClassList[0];

          if DDest.DefKind = dkConstant then
            MemberRec := ClassRec.AddHostConstant(DDest as TPaxConstantDefinition)
          else if DDest.DefKind = dkVariable then
            MemberRec := ClassRec.AddHostVariable(DDest as TPaxVariableDefinition)
          else if DDest.DefKind = dkObject then
            MemberRec := ClassRec.AddHostObject(DDest as TPaxObjectDefinition)
          else if DDest.DefKind = dkMethod then
            MemberRec := ClassRec.AddHostMethod(DDest as TPaxMethodDefinition)
          else
          begin
            DDest.AddToScripter(Scripter);
            MemberRec := ClassRec.MemberList.Records[ClassRec.MemberList.Count - 1];
          end;
        end;
      end;

      if MemberRec <> nil then
      begin
//      with SymbolTable, Prog[N] do
//        SetRef(Res, VariantValue[ObjectID], maAny);
        Inc(N);
        Exit;
      end;
    end;

    if WithStack.Card > 0 then
    begin

      K := GetLanguageNamespaceID;
      S := SymbolTable.Name[K];

      if StrEql(S, 'paxJavaScriptNamespace') then
      begin
        ObjectID := WithStack.fItems[WithStack.Card];
        if SymbolTable.Kind[ObjectId] in [KindVAR, KindREF, KindHOSTVAR] then
        begin
          SetRef(Prog[N].Res, SymbolTable.VariantValue[ObjectID], maAny);
          Inc(N);
          Exit;
        end;
      end;
    end;

    with TPAXBaseScripter(Scripter) do
      if Assigned(OnUndeclaredIdentifier) then
      begin
        K := SymbolTable.Level[Prog[N].Res];
        if (S = 'arguments') and (SymbolTable.Kind[K] = KindSUB) then
        begin
          for I:=N downto 1 do
            if Prog[I].Op = OP_GET_PARAM_COUNT then // this is a paxJavaScript module
            begin
              Inc(N);
              Exit;
            end;
        end;

{$IFDEF UNDECLARED_EX}
        if AssignedUndeclaredList.IndexOf(Prog[N].Res) = -1 then
        begin
          Mode := 0;
          OnUndeclaredIdentifier(Owner, Prog[N].Res, Mode);
          if Mode = 0 then
            AssignedUndeclaredList.Add(Prog[N].Res)
          else
            AssignedUndeclaredList.Clear;
        end;
{$ELSE}
        if AssignedUndeclaredList.IndexOf(Prog[N].Res) = -1 then
        begin
          OnUndeclaredIdentifier(Owner, Prog[N].Res);
          AssignedUndeclaredList.Add(Prog[N].Res);
        end;
{$ENDIF}

        Inc(N);
        Exit;
      end;


    if DeclareON then
      raise TPAXScriptFailure.Create(Format(errUndeclaredIdentifier, [S]));
  end;

  Inc(N);
end;

procedure TPAXCode.OperIn;
var
  S: String;
  SO: TPaxScriptObject;
begin
  with SymbolTable, Prog[N] do
  begin
    if IsPaxArray(VariantValue[Arg2]) then
    begin
      OperInSet;
      Exit;
    end;

    S := ToString(VariantValue[Arg1]);
    SO := VariantToScriptObject(ToObject(VariantValue[Arg2], Scripter));
    VariantValue[Res] := SO.HasProperty(S);
  end;
  Inc(N);
end;

procedure TPAXCode.OperInSet;
begin
  with SymbolTable, Prog[N] do
    VariantValue[Res] := InSet(VariantValue[Arg1], VariantValue[Arg2]);
  Inc(N);
end;

procedure TPAXCode.OperInstanceOf;
var
  SO1, SO2: TPaxScriptObject;
begin
  with SymbolTable, Prog[N] do
  begin
    SO1 := VariantToScriptObject(ToObject(VariantValue[Arg1], Scripter));
    SO2 := VariantToScriptObject(ToObject(VariantValue[Arg2], Scripter));
    VariantValue[Res] := SO1.ClassRec = SO2.ClassRec;
  end;
  Inc(N);
end;

procedure TPAXCode.OperTypeOf;
var
  SO: TPaxScriptObject;
  V: Variant;
  Result: String;
begin
  with SymbolTable, Prog[N] do
  begin
    V := VariantValue[Arg1];
    Result := 'undefined';
    if IsString(V) or IsStringObject(V) then
      Result := 'string'
    else if IsBoolean(V) or IsBooleanObject(V) then
      Result := 'boolean'
    else if IsNumber(V) or IsNumberObject(V) then
      Result := 'number'
    else if IsObject(V) then
    begin
      Result := 'object';
      SO := VariantToScriptObject(V);
      if SO.ClassRec.AncestorName = 'Function' then
        Result := 'function'
      else if SO.ClassRec.Name = 'TPAXDelegate' then
        Result := 'function'
      else if IsPaxArray(V) then
        Result := 'array';
    end;

    VariantValue[Res] := Result;
  end;
  Inc(N);
end;

procedure TPAXCode.OperSaveResult;
begin
  if SubRunCount > 1 then
  with SymbolTable, Prog[N] do
    ResultValue := GetVariant(Arg1);

  Inc(N);
end;

procedure TPAXCode.OperGetAncestorName;
var
  ClassRec: TPaxClassRec;
begin
  with SymbolTable, Prog[N] do
  begin
    ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClass(Arg1);
    if ClassRec = nil then
      raise TPAXScriptFailure.Create(errClassIsNotFound);
    Name[Res] := ClassRec.AncestorName;
  end;
  Inc(N);
end;

procedure TPAXCode.OperGetNextProp;
var
  SO: TPAXScriptObject;
  Index: Integer;
  S: String;
begin
  with SymbolTable, Prog[N] do
  begin
    SO := VariantToScriptObject(ToObject(VariantValue[Arg2], Scripter));
    Index := VariantValue[Res];
    S := SO.GetPropertyName(Index);
    if S = '' then
      VariantValue[Res] := 0
    else
    begin
      VariantValue[Arg1] := S;
      VariantValue[Res] := Index + 1;
    end;
  end;
  Inc(N);
end;

procedure TPAXCode.OperGo;
begin
  N := Prog[N].Arg1;
end;

procedure TPAXCode.OperGoFalse;
begin
  with SymbolTable, Prog[N] do
  begin
    SetFOP(OP_GO_FALSE);
    if VariantValue[Arg2] <> 0 then
      Inc(N)
    else
      N := Prog[N].Arg1;
  end;
end;

procedure TPAXCode.OperGoFalseEx;
var
  V: Variant;
  b: Boolean;
begin
  with SymbolTable, Prog[N] do
  begin
//    SetFOP(OP_GO_FALSE);
    V := VariantValue[Arg2];
    case VarType(V) of
      varEmpty, varNull:
        b := false;
      varString:
        b := V <> '';
      varDouble:
        if V = NaN then
          b := false
        else
          b := V <> 0;
      else
        b := Integer(V) <> 0;
    end;
    if b then
      Inc(N)
    else
      N := Prog[N].Arg1;
  end;
end;

procedure TPAXCode.OperGoTrue;
begin
  with SymbolTable, Prog[N] do
  begin
    SetFOP(OP_GO_TRUE);
    if VariantValue[Arg2] = 0 then
      Inc(N)
    else
      N := Prog[N].Arg1;
  end;
end;

procedure TPAXCode.OperGoTrueEx;
var
  V: Variant;
  b: Boolean;
begin
  with SymbolTable, Prog[N] do
  begin
    SetFOP(OP_GO_TRUE);
    V := VariantValue[Arg2];
    case VarType(V) of
      varEmpty, varNull:
        b := false;
      varString:
        b := V <> '';
      varDouble:
        if V = NaN then
          b := false
        else
          b := V <> 0;
      else
        b := Integer(V) <> 0;
    end;
    if not b then
      Inc(N)
    else
      N := Prog[N].Arg1;
  end;
end;

procedure TPAXCode.InvokeOnChangedVariable;
var
  S: String;
  ID: Integer;
begin
  with TPAXBaseScripter(Scripter) do
  if Assigned(OnChangedVariable) then
  begin
    ID := Prog[N].Res;
    S := SymbolTable.Name[ID];
    if Pos('$', S) = 0 then
      OnChangedVariable(Owner, ID);
  end;
end;

procedure TPAXCode.OperSetOwner;
var
  V: Variant;
  SO: TPaxScriptObject;
  PaxArray: TPaxArray;
begin
  with SymbolTable, Prog[N] do
  begin
    V := VariantValue[Arg1];
    if IsPaxArray(V) then
    begin
      SO := VariantToScriptObject(V);
      PaxArray := TPaxArray(SO.Instance);
      PaxArray.Owner := VariantValue[Arg2];
    end;
  end;
  Inc(N);
end;

procedure TPAXCode.OperAssign;
var
  V: Variant;
  SO, SOR: TPAXScriptObject;
  Prop: TPAXProperty;
  I: Integer;
  Intf: IUnknown;
begin
  SetFOP(FOP_ASSIGN);

  with SymbolTable, Prog[N] do
  begin
    V := VariantValue[Arg2];

//  VariantValue[Res] := V;

    Base := GetVariant(Res);

    V := DuplicateObject(V);

    if (PType[Arg1] = typeSTRING) and (Count[Arg1] > 0) and (VarType(V) = varString) then
      V := Copy(V, 1, Count[Arg1])
    else if (PType[Arg1] = typeINTEGER) and (VarType(V) in [varDouble, varSingle, varCurrency]) then
    begin
      I := Round(V);
      V := I;
    end;

    if Kind[Res] <> KindREF then
    begin
      if IsObject(V) then
      begin
        SO := VariantToScriptObject(V);
        if SO.ClassRec.ck = ckInterface then
        begin
          if IsObject(VariantValue[Res]) then
          begin
            SOR := VariantToScriptObject(VariantValue[Res]);
            if SOR.ClassRec.ck = ckInterface then
            begin
              if SOR.PIntf <> nil then
              begin
                if SO.PIntf <> nil then
                  SOR.PIntf^ := SO.PIntf^
                else
                  SOR.PIntf^ := SO.Intf;
              end
              else
              begin
                if SO.PIntf <> nil then
                begin
                  SOR.Intf := SO.PIntf^;
//                  SOR.Intf._Release;  //<<THIS CODE WAS INSERTED BY GUSTAVO
                end
                else
                begin

                  if (SOR.ClassRec.fClassDef <> nil) and (SO.ClassRec.fClassDef <> nil) then
                  begin
                    if IsEqualGUID (SOR.ClassRec.fClassDef.guid, SO.ClassRec.fClassDef.guid) then
                      SOR.Intf := SO.Intf
                    else
                    begin
                      SO.Intf.QueryInterface(SOR.ClassRec.fClassDef.guid, Intf);
                      SOR.Intf := Intf;
                    end;

                    if SOR.Intf = Nil then
                      raise TPAXScriptFailure.Create(errIncompatibleTypes)
                    else
                      SOR.Intf._Release;

                  end
                  else
                  begin
                    SOR.Intf := SO.Intf;
                    SOR.Intf._Release;
                  end;

                end;
              end;

              Inc(N);
              Exit;
            end;
          end;
        end
        else
        begin
          if IsObject(VariantValue[Res]) then
          begin
            SOR := VariantToScriptObject(VariantValue[Res]);
            if TPaxBaseScripter(Scripter).ScriptObjectList.HasObject(SOR) then
            begin
              Inc(SOR.RefCount);
              Inc(SO.RefCount);
            end;
          end;
        end;
      end
      else if IsUndefined(V) then
      begin
        if IsObject(VariantValue[Res]) then
        begin
          SOR := VariantToScriptObject(VariantValue[Res]);
          if SOR.ClassRec.ck = ckInterface then
          begin
            if SOR.PIntf <> nil then
              SOR.Intf := nil
            else
              SOR.Intf := nil;
          end;
        end;
      end;

      VariantValue[Res] := V;
      InvokeOnChangedVariable;

      Inc(N);
      Exit;
    end;

    if VarIsNull(Base) or VarIsEmpty(Base) then
      raise TPAXScriptFailure.Create(errIncompatibleTypes);

    SO := VariantToScriptObject(Base);
    Prop := SO.PropertyList.FindProperty(NameIndex[Res]);

    if Prop <> nil then
      if Prop.WriteID > 0 then
      begin
        VV := V;
        if Kind[Prop.WriteID] = KindSUB then
        begin
          Stack.Push(Integer(@VV));
          CallSub(Prop.WriteID, 1, @Base, 0);
          InvokeOnChangedVariable;
        end
        else
        begin
          Prop := SO.Get(NameIndex[Prop.WriteID]);
          Prop.Value[0] := V;
        end;

        Inc(N);
        Exit;
      end;

    VariantValue[Res] := V;
    InvokeOnChangedVariable;
    Inc(N);
  end;
end;

procedure TPAXCode.OperAssignResult;
var
  P: PVariant;
  SO: TPaxScriptObject;
begin
  with SymbolTable, Prog[N] do
  if Kind[Arg2] = KindREF then
  begin
    SO := VariantToScriptObject(GetVariant(Arg2));
    P := SO.GetAddress(NameIndex[Arg2], 0);
  end
  else
    P := Address[Arg2];

  if P <> nil then
  begin
    if IsAlias(P) then
      OperAssignAddress
    else
      OperAssign;
  end
  else
    OperAssign;
end;

procedure TPAXCode.OperAssignAddress;
var
  V: Variant;
  ma: TPAXMemberAccess;
  MemberRec: TPAXMemberRec;
  SO: TPaxScriptObject;
  Prop: TPaxProperty;
begin
  with SymbolTable, Prog[N] do
  begin
    if Kind[Arg2] = KindREF then
    begin
      ma := MemberAccess[Res];
      MemberRec := GetMemberRec(Arg2, ma);
      if MemberRec <> nil then
      begin
        if MemberRec.Kind = KindVAR then
        begin
          ClearVariantValue(Res);

          SO := VariantToScriptObject(GetTerminal(Address[Arg2])^);
          Prop := SO.PropertyList.FindProperty(NameIndex[Arg2]);
          V := CreateAlias(Prop.fValue);
        end
        else
          V := GetVariant(MemberRec.ID);
      end
      else
        raise TPAXScriptFailure.Create(Format(errFunctionNotFound, [SymbolTable.Name[Arg2]]));

      _This := GetVariant(Arg2);
    end
    else
    begin
      if LevelStack.Card > 1 then
        _This := GetVariant(GetThisID(LevelStack[LevelStack.Card]))
      else
        _This := GetVariant(Arg2);
  //      VarClear(_This);

      if Kind[Arg2] = KindVAR then
      begin
        ClearVariantValue(Res);
        V := GetAlias(Arg2);
      end
      else
        V := GetVariant(Arg2);
    end;
    VariantValue[Res] := V;
  end;
  Inc(N);
end;

procedure TPAXCode.OperGetTerminal;
var
  MemberRec: TPAXMemberRec;
  SO: TPaxScriptObject;
  Prop: TPaxProperty;
begin
  with SymbolTable, Prog[N] do
    if Kind[Arg2] = KindREF then
    begin
      MemberRec := GetMemberRec(Arg1, maAny);
      if MemberRec <> nil then
        if MemberRec.Kind = KindVAR then
        begin
          SO := VariantToScriptObject(GetTerminal(Address[Arg1])^);
          Prop := SO.PropertyList.FindProperty(NameIndex[Arg1]);
          Address[Res] := Prop.PTerminalValue;
          Level[Res] := 0;
          Inc(N);
          Exit;
        end;
      raise TPAXScriptFailure.Create(errOperatorNotApplicable);
    end
    else
    begin
      Address[Res] := GetTerminal(Address[Arg1]);
      Level[Res] := 0;
    end;

  Inc(N);
end;


procedure TPAXCode.OperToInteger;
begin
  with SymbolTable, Prog[N] do
    VariantValue[Res] := ToInt32(VariantValue[Arg1]);
  InvokeOnChangedVariable;
  Inc(N);
end;

procedure TPAXCode.OperToString;
begin
  with SymbolTable, Prog[N] do
    VariantValue[Res] := ToString(VariantValue[Arg1]);
  InvokeOnChangedVariable;

  Inc(N);
end;

procedure TPAXCode.OperToBoolean;
begin
  with SymbolTable, Prog[N] do
    VariantValue[Res] := ToBoolean(VariantValue[Arg1]);
  InvokeOnChangedVariable;
  Inc(N);
end;

procedure TPAXCode.OperAnd;
begin
  with SymbolTable, Prog[N] do
    VariantValue[Res] := VariantValue[Arg1] and VariantValue[Arg2];
  InvokeOnChangedVariable;
  SetFOP(OP_AND);
  Inc(N);
end;

procedure TPAXCode.OperOr;
begin
  with SymbolTable, Prog[N] do
    VariantValue[Res] := VariantValue[Arg1] or VariantValue[Arg2];
  InvokeOnChangedVariable;
  SetFOP(OP_OR);
  Inc(N);
end;

procedure TPAXCode.OperXor;
begin
  with SymbolTable, Prog[N] do
    VariantValue[Res] := VariantValue[Arg1] xor VariantValue[Arg2];
  InvokeOnChangedVariable;
  SetFOP(OP_XOR);
  Inc(N);
end;

procedure TPAXCode.OperNot;
begin
  with SymbolTable, Prog[N] do
    VariantValue[Res] := not VariantValue[Arg1];
  InvokeOnChangedVariable;
  SetFOP(OP_NOT);
  Inc(N);
end;

procedure TPAXCode.OperLeftShift;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    VariantValue[Res] := VariantValue[Arg1] shl VariantValue[Arg2];
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_LEFT_SHIFT);
  Inc(N);
end;

procedure TPAXCode.OperLeftShift_Ex;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_LeftShift', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := ToNumber(V1) shl ToNumber(V2);
    end
    else
      VariantValue[Res] := ToNumber(V1) shl ToNumber(V2);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_LEFT_SHIFT);
  Inc(N);
end;

procedure TPAXCode.OperRightShift;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_RightShift', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := ToNumber(V1) shr ToNumber(V2);
    end
    else
      VariantValue[Res] := ToNumber(V1) shr ToNumber(V2);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_RIGHT_SHIFT);
  Inc(N);
end;

procedure TPAXCode.OperRightShift_Ex;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    VariantValue[Res] := ToInt32(ToInt32(VariantValue[Arg1])) shr ToNumber(VariantValue[Arg2]);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_RIGHT_SHIFT);
  Inc(N);
end;

procedure TPAXCode.OperUnsignedRightShift;
begin
  with SymbolTable, Prog[N] do
    VariantValue[Res] := _shr(VariantValue[Arg1], VariantValue[Arg2]);
  InvokeOnChangedVariable;
  SetFOP(OP_UNSIGNED_RIGHT_SHIFT);
  Inc(N);
end;

procedure TPAXCode.OperUnsignedRightShift_Ex;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_UnsignedRightShift', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := _shr(ToNumber(V1), ToNumber(V2));
    end
    else
      VariantValue[Res] := _shr(ToNumber(V1), ToNumber(V2));
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_UNSIGNED_RIGHT_SHIFT);
  Inc(N);
end;

procedure TPAXCode.OperPlus;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;

    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];

    if IsPaxArray(V1) and IsPaxArray(V2) then
    begin
      VariantValue[Res] := AddSets(V1, V2);
      InvokeOnChangedVariable;
      Inc(N);
      Exit;
    end
    else
      VariantValue[Res] := V1 + V2;
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_PLUS);
  Inc(N);
end;

procedure TPAXCode.FindUnaryOperator(const Name: String; const V2: Variant);
var
  SO, SO2: TPaxScriptObject;
  NameIndex: Integer;
  P: TPaxProperty;
  V: Variant;
  MemberRec: TPaxMemberRec;
begin
  SO2 := VariantToScriptObject(V2);
  NameIndex := CreateNameIndex(Name, Scripter);
  P := SO2.PropertyList.FindProperty(NameIndex);
  if P <> nil then
  begin
    V := P.Value[0];
    if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);
      Prog[N].AltArg1 := SO.ClassRec.ClassID;
    end
    else
    begin
      MemberRec := SO2.ClassRec.FindMember(NameIndex, maAny, UpCaseOn);
      if MemberRec <> nil then
        Prog[N].AltArg1 := MemberRec.ID;
    end;
  end;
end;

procedure TPAXCode.FindBinaryOperator(const Name: String; const V1, V2: Variant);
var
  SO, SO1: TPaxScriptObject;
  NameIndex: Integer;
  P: TPaxProperty;
  V: Variant;
  MemberRec: TPaxMemberRec;
begin
  SO1 := VariantToScriptObject(V1);
  NameIndex := CreateNameIndex(Name, Scripter);
  P := SO1.PropertyList.FindProperty(NameIndex);
  if P <> nil then
  begin
    V := P.Value[0];
    if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);
      Prog[N].AltArg1 := SO.ClassRec.ClassID;
    end
    else
    begin
      MemberRec := SO1.ClassRec.FindMember(NameIndex, maAny, UpCaseOn);
      if MemberRec <> nil then
        Prog[N].AltArg1 := MemberRec.ID;
    end;
  end;
end;

procedure TPAXCode.OperPlus_Ex;
var
  V1, V2: Variant;
  SO: TPAXScriptObject;
  Num: Double;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;

    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsString(V1) or IsString(V2) then
      VariantValue[Res] := ToString(V1) + ToString(V2)
    else if IsStringObject(V1) or IsStringObject(V2) then
      VariantValue[Res] := ToString(V1) + ToString(V2)
    else if IsDateObject(V1) and IsDateObject(V2) then
    begin
      Num := VariantToScriptObject(V1).DefaultValue +
             VariantToScriptObject(V2).DefaultValue;
      VariantValue[Res] := Num;
    end
    else if IsDateObject(V1) then
    begin
      Num := ToNumber(V2);
      if IsDateObject(VariantValue[Res]) then
      begin
        SO := VariantToScriptObject(VariantValue[Res]);
        SO.SetDefaultValue(VariantToScriptObject(V1).DefaultValue + Num);
      end
      else
      begin
        SO := ClassList.CreateDateObject(VariantToScriptObject(V1).DefaultValue +
                                         Num);
        VariantValue[Res] := ScriptObjectToVariant(SO);
      end;
    end
    else if IsDateObject(V2) then
    begin
      Num := ToNumber(V1);
      if IsDateObject(VariantValue[Res]) then
      begin
        SO := VariantToScriptObject(VariantValue[Res]);
        SO.SetDefaultValue(VariantToScriptObject(V2).DefaultValue + Num);
      end
      else
      begin
        SO := ClassList.CreateDateObject(VariantToScriptObject(V2).DefaultValue +
                                         Num);
        VariantValue[Res] := ScriptObjectToVariant(SO);
      end;
    end
    else if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_Addition', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := ToNumber(V1) + ToNumber(V2);
    end
    else
      VariantValue[Res] := ToNumber(V1) + ToNumber(V2);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_PLUS, true);
  Inc(N);
end;

procedure TPAXCode.OperMinus;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsPaxArray(V1) and IsPaxArray(V2) then
    begin
      VariantValue[Res] := SubSets(V1, V2);
      InvokeOnChangedVariable;
      Inc(N);
      Exit;
    end
    else
      VariantValue[Res] := V1 - V2;
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_MINUS);
  Inc(N);
end;

procedure TPAXCode.OperMinus_Ex;
var
  V1, V2: Variant;
  SO: TPAXScriptObject;
  Num: Double;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsDateObject(V1) and IsDateObject(V2) then
    begin
      Num := VariantToScriptObject(V1).DefaultValue -
             VariantToScriptObject(V2).DefaultValue;
      VariantValue[Res] := Num;
    end
    else if IsDateObject(V1) then
    begin
      Num := ToNumber(V2);
      if IsDateObject(VariantValue[Res]) then
      begin
        SO := VariantToScriptObject(VariantValue[Res]);
        SO.SetDefaultValue(VariantToScriptObject(V1).DefaultValue - Num);
      end
      else
      begin
        SO := ClassList.CreateDateObject(VariantToScriptObject(V1).DefaultValue -
                                         Num);
        VariantValue[Res] := ScriptObjectToVariant(SO);
      end;
    end
    else if IsDateObject(V2) then
    begin
      Num := ToNumber(V1);
      if IsDateObject(VariantValue[Res]) then
      begin
        SO := VariantToScriptObject(VariantValue[Res]);
        SO.SetDefaultValue(VariantToScriptObject(V2).DefaultValue - Num);
      end
      else
      begin
        SO := ClassList.CreateDateObject(VariantToScriptObject(V2).DefaultValue -
                                         Num);
        VariantValue[Res] := ScriptObjectToVariant(SO);
      end;
    end
    else if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_Subtraction', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := ToNumber(V1) - ToNumber(V2);
    end
    else
      VariantValue[Res] := ToNumber(V1) - ToNumber(V2);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_MINUS, true);
  Inc(N);
end;

procedure TPAXCode.OperUnaryPlus;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperUnaryOperator;
      Exit;
    end;
    VariantValue[Res] := UnaryPlus(VariantValue[Arg1]);
  end;
  InvokeOnChangedVariable;
  Inc(N);
end;

procedure TPAXCode.OperUnaryMinus;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperUnaryOperator;
      Exit;
    end;
    VariantValue[Res] := - VariantValue[Arg1];
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_UNARY_MINUS);
  Inc(N);
end;

procedure TPAXCode.OperUnaryMinusEx;
var
  V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperUnaryOperator;
      Exit;
    end;
    V2 := VariantValue[Arg1];
    if IsObject(V2) then
    begin
      FindUnaryOperator('op_Negation', V2);
      if AltArg1 > 0 then
      begin
        OperUnaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := - ToNumber(V2);
    end
    else
      VariantValue[Res] := - ToNumber(V2);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_UNARY_MINUS, true);
  Inc(N);
end;

procedure TPAXCode.OperMult;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsPaxArray(V1) and IsPaxArray(V2) then
    begin
      VariantValue[Res] := IntersectSets(V1, V2);
      InvokeOnChangedVariable;
      Inc(N);
      Exit;
    end
    else
      VariantValue[Res] := V1 * V2;
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_MULT);
  Inc(N);
end;

procedure TPAXCode.OperMult_Ex;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;

    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];

    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_Multiply', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := ToNumber(V1) * ToNumber(V2);
    end
    else
      VariantValue[Res] := ToNumber(V1) * ToNumber(V2);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_MULT, true);
  Inc(N);
end;

procedure TPAXCode.OperDiv;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;

    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];

    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_Division', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := ToNumber(V1) * ToNumber(V2);
    end
    else
      VariantValue[Res] := V1 / V2;
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_DIV);
  Inc(N);
end;

procedure TPAXCode.OperDiv_Ex;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;

    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];

    if ToNumber(V2) = 0 then
      VariantValue[Res] := NaN
    else if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_Division', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := ToNumber(V1) / ToNumber(V2);
    end
    else
      VariantValue[Res] := ToNumber(V1) / ToNumber(V2);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_DIV, true);
  Inc(N);
end;

procedure TPAXCode.OperIntDiv;
var
  I1, I2: Integer;
begin
  with SymbolTable, Prog[N] do
  begin
    I1 := VariantValue[Arg1];
    I2 := VariantValue[Arg2];
    VariantValue[Res] := I1 div I2;
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_INT_DIV);
  Inc(N);
end;

procedure TPAXCode.OperMod;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    VariantValue[Res] := VariantValue[Arg1] mod VariantValue[Arg2];
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_MOD);
  Inc(N);
end;

procedure TPAXCode.OperMod_Ex;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;

    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];

    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_Modulus', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := ToNumber(V1) mod ToNumber(V2);
    end
    else
      VariantValue[Res] := ToNumber(V1) mod ToNumber(V2);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_MOD, true);
  Inc(N);
end;

procedure TPAXCode.OperPower;
begin
  with SymbolTable, Prog[N] do
    VariantValue[Res] := Power(VariantValue[Arg1], VariantValue[Arg2]);
  InvokeOnChangedVariable;
  Inc(N);
end;

procedure TPAXCode.OperLT;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsPaxArray(V1) and IsPaxArray(V2) then
    begin
      VariantValue[Res] := IsStrictSubSet(V1, V2);
      InvokeOnChangedVariable;
      Inc(N);
      Exit;
    end
    else
      VariantValue[Res] := V1 < V2;
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_LT);
  Inc(N);
end;

procedure TPAXCode.OperLT_Ex;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;

    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];

    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_LessThan', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := RelationalComparison(V1, V2);
    end
    else
      VariantValue[Res] := RelationalComparison(V1, V2);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_LT, true);
  Inc(N);
end;

procedure TPAXCode.OperGT;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsPaxArray(V1) and IsPaxArray(V2) then
    begin
      VariantValue[Res] := IsStrictSubSet(V2, V1);
      InvokeOnChangedVariable;
      Inc(N);
      Exit;
    end
    else
      VariantValue[Res] := V1 > V2;
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_GT);
  Inc(N);
end;

procedure TPAXCode.OperGT_Ex;
var
  R: Variant;
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;

    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_GreaterThan', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        R := RelationalComparison(V2, V1);
    end
    else
      R := RelationalComparison(V2, V1);

    if IsUndefined(R) then
      VariantValue[Res] := false
    else
      VariantValue[Res] := R;
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_GT, true);
  Inc(N);
end;

procedure TPAXCode.OperLE;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsPaxArray(V1) and IsPaxArray(V2) then
    begin
      VariantValue[Res] := IsSubSet(V1, V2);
      InvokeOnChangedVariable;
      Inc(N);
      Exit;
    end
    else
      VariantValue[Res] := V1 <= V2;
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_LE);
  Inc(N);
end;

procedure TPAXCode.OperLE_Ex;
var
  R: Variant;
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;

    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_LessThanOrEqual', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        R := RelationalComparison(V2, V1);
    end
    else
      R := RelationalComparison(V2, V1);

    if IsUndefined(R) then
      VariantValue[Res] := false
    else if IsBoolean(R) then
      VariantValue[Res] := not R
    else
      VariantValue[Res] := true;
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_LE, true);
  Inc(N);
end;

procedure TPAXCode.OperGE;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsPaxArray(V1) and IsPaxArray(V2) then
    begin
      VariantValue[Res] := IsSubSet(V2, V1);
      InvokeOnChangedVariable;
      Inc(N);
      Exit;
    end
    else
      VariantValue[Res] := V1 >= V2;
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_GE);
  Inc(N);
end;

procedure TPAXCode.OperGE_Ex;
var
  R: Variant;
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;

    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_GreaterThanOrEqual', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        R := RelationalComparison(V1, V2);
    end
    else
      R := RelationalComparison(V1, V2);

    if IsUndefined (R) then
      VariantValue[Res] := false
    else if IsBoolean (R) then
      VariantValue[Res] := not R
    else
      VariantValue[Res] := true;
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_GE, true);
  Inc(N);
end;

procedure TPAXCode.OperEQ;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    VariantValue[Res] := EqualVariants(Scripter, VariantValue[Arg1], VariantValue[Arg2],
                                       PType[Arg1], PType[Arg2]);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_EQ);
  Inc(N);
end;

procedure TPAXCode.OperEQ_Ex;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;

    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_Equality', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := EqualityComparison(V1, V2);
    end
    else
      VariantValue[Res] := EqualityComparison(V1, V2);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_EQ, true);
  Inc(N);
end;

procedure TPAXCode.OperNE;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;
    VariantValue[Res] := not EqualVariants(Scripter, VariantValue[Arg1], VariantValue[Arg2],
                                           PType[Arg1], PType[Arg2]);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_NE);
  Inc(N);
end;

procedure TPAXCode.OperNE_Ex;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    if AltArg1 > 0 then
    begin
      OperBinaryOperator;
      Exit;
    end;

    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_Inequality', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := not EqualityComparison(V1, V2);
    end
    else
      VariantValue[Res] := not EqualityComparison(V1, V2);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_NE, true);
  Inc(N);
end;

procedure TPAXCode.OperID;
begin
  with SymbolTable, Prog[N] do
    VariantValue[Res] := EqualVariants(Scripter, VariantValue[Arg1], VariantValue[Arg2]);
  InvokeOnChangedVariable;
  SetFOP(OP_EQ);
  Inc(N);
end;

procedure TPAXCode.OperID_Ex;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_StrictEquality', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := StrictEqualityComparison(V1, V2);
    end
    else
      VariantValue[Res] := StrictEqualityComparison(V1, V2);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_EQ, true);
  Inc(N);
end;

procedure TPAXCode.OperNI;
begin
  with SymbolTable, Prog[N] do
    VariantValue[Res] := not EqualVariants(Scripter, VariantValue[Arg1], VariantValue[Arg2]);
  InvokeOnChangedVariable;
  SetFOP(OP_NE);
  Inc(N);
end;

procedure TPAXCode.OperNI_Ex;
var
  V1, V2: Variant;
begin
  with SymbolTable, Prog[N] do
  begin
    V1 := VariantValue[Arg1];
    V2 := VariantValue[Arg2];
    if IsObject(V1) and IsObject(V2) then
    begin
      FindBinaryOperator('op_StrictInequality', V1, V2);
      if AltArg1 > 0 then
      begin
        OperBinaryOperator;
        Exit;
      end
      else
        VariantValue[Res] := not StrictEqualityComparison(V1, V2);
    end
    else
      VariantValue[Res] := not StrictEqualityComparison(V1, V2);
  end;
  InvokeOnChangedVariable;
  SetFOP(OP_NE, true);
  Inc(N);
end;

procedure TPAXCode.OperIS;
var
  V: Variant;
  S: String;
  ClassRec: TPaxClassRec;
  SO: TPaxScriptObject;
  ok: Boolean;
begin
  with SymbolTable, Prog[N] do
  begin
    V := VariantValue[Arg1];
    if IsObject(V) then
    begin
      S := Name[Arg2];
      ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(S);
      if ClassRec <> nil then
      begin
        SO := VariantToScriptObject(V);
//        ok := (SO.ClassRec = ClassRec) or ClassRec.InheritsFromClass(SO.ClassRec.ClassID);
        ok := (SO.ClassRec = ClassRec) or SO.ClassRec.InheritsFromClass (ClassRec.ClassID);
        PutVariant(Res, ok);
        Inc(N);
        Exit;
      end;
    end;
    PutVariant(Res, false);
  end;
  Inc(N);
end;

procedure TPAXCode.OperAS;
begin
  with SymbolTable, Prog[N] do
  begin
  end;
  Inc(N);
end;

procedure TPAXCode.Run(RunMode: Integer = _rmRun; DestLine: Integer = 0);
label
  Fin;
var
  StackCard, NextLine, TempMode: Integer;
{$IFNDEF ONRUNNING}
  // Handled not used.
  Handled: Boolean;
{$ENDIF}
begin
  IsAborted := false;

  TempMode := CurrRunMode;
  CurrRunMode := RunMode;

  Inc(N);

  NextLine := NextLineID;

  StackCard := Stack.Card;

  Inc(SubRunCount);
  repeat

    while Prog[N].Op = OP_SEPARATOR do
    begin

      if BreakpointList.Count > 0 then
      if IsBreakpoint(N) then
      begin
        Dec(SubRunCount);
        Exit;
      end;

      case CurrRunMode of
        _rmRun: Inc(N);
        _rmRunToCursor:
          if N = DestLine then
            goto Fin
          else
            Inc(N);
        _rmTraceInto:
          if IsExecutableLine(N) then
            goto Fin
          else
            Inc(N);
        _rmStepOver:
          if Stack.Card <= StackCard then
          begin
            if IsExecutableLine(N) then
              goto Fin
            else
              Inc(N);
          end
          else
            Inc(N);
        _rmTraceToNextSourceLine:
          if N = NextLine then
            goto Fin
          else
            Inc(N);
      end;
    end;

    try

      with TPAXBaseScripter(Scripter) do

{$IFDEF ONRUNNING}
      begin
        // OnRunningSync - This method is used as a special callback
        // which allows the user to make the call thread-safe in a
        // multi-threaded application.
        // Event fires when executing a function or property and
        // UserData is non-zero.
        if Assigned(OnRunningSync) then
        with Prog[N] do
          if (((OP = OP_CALL) or (OP = OP_PUT_PROPERTY) or (OP = OP_PUT_PUBLISHED_PROPERTY) or (OP = OP_GET_PUBLISHED_PROPERTY)) and
              (SymbolTable.GetUserData(Arg1) <> 0)) then
            OnRunningSync(Owner) // Assume ArrProc[Prog[N].Op] is called to keep things fast
          else
            ArrProc[Prog[N].Op]
        else
          ArrProc[Prog[N].Op];

        // OnRunningUpdate - When OnRunningUpdateActive is enabled and
        // OnRunningUpdate event is assigned, the event will fire each time an
        // instruction is generated.  It is used for multi-threaded applications
        // and allows the user to process PaxScripter methods or properties in a
        // thread-safe manner.
        // OnRunningUpdateActive and be disabled to improve scripter speed.
        if (OnRunningUpdateActive and Assigned(OnRunningUpdate)) then
          OnRunningUpdate(Owner);
      end
{$ELSE}
      if Assigned(OnRunning) then
      begin
        Handled := false;
        with Prog[N] do
          OnRunning(Owner, N, Handled);
        if not Handled then
          ArrProc[Prog[N].Op];
      end
      else
        ArrProc[Prog[N].Op];
{$ENDIF}

    except
      on E: EAbort do
      begin
        fTerminated := true;
        IsAborted := true;
        Abort;
      end;
      on E: Exception do
      begin
        TPAXBaseScripter(Scripter).CreateErrorObject(E.Message, 0);
        TPAXBaseScripter(Scripter).ErrorInstance.ErrClassType := E.ClassType;
        ErrorN := N;

        if E.InheritsFrom(TPaxScriptFailure) then
          fTerminated := true
        else
          RaiseException;
      end;
    end;
  until fTerminated;
  Fin:

  Dec(SubRunCount);

  if fTerminated then
    TPAXBaseScripter(Scripter).AllowedEvents := true;

  CurrRunMode := TempMode;
end;

procedure TPAXCode.OperBinaryOperator;
begin
  Stack.Push(N + 1);
  Stack.Push(Integer(SignFOP));
  SignFOP := false;
  with SymbolTable, Prog[N] do
  begin
    Add(OP_PUSH, Arg1, 0, 0);
    Add(OP_PUSH, Arg2, 0, 0);
    Add(OP_CALL, AltArg1, 2, Res);
    Add(OP_RET_OPERATOR, 0, 0, 0);
  end;
  N := Card - 3;
end;

procedure TPAXCode.OperUnaryOperator;
begin
  Stack.Push(N + 1);
  Stack.Push(Integer(SignFOP));
  SignFOP := false;
  with SymbolTable, Prog[N] do
  begin
    Add(OP_PUSH, Arg1, 0, 0);
    Add(OP_CALL, AltArg1, 1, Res);
    Add(OP_RET_OPERATOR, 0, 0, 0);
  end;
  N := Card - 2;
end;

procedure TPAXCode.OperRetOperator;
var
  NP: Integer;
begin
  NP := Prog[N-1].Arg2;

  SignFOP := Boolean(Stack.Pop);
  N := Stack.Pop;

  FillChar(Prog[Card],   SizeOf(TPaxCodeRec), 0);
  FillChar(Prog[Card-1], SizeOf(TPaxCodeRec), 0);
  FillChar(Prog[Card-2], SizeOf(TPaxCodeRec), 0);
  if NP = 1 then
  begin
    Card := Card - 3;
  end
  else if NP = 2 then
  begin
    FillChar(Prog[Card-3], SizeOf(TPaxCodeRec), 0);
    Card := Card - 4;
  end;
end;

function TPAXCode.EvalGetFunction(SubID, NParams: Integer): Integer;
begin
  SaveState;

//  result := SymbolTable.AppVariant(Undefined);
  if SubID < 0 then
    result := typeREAL48
  else
    result := SymbolTable.GetResultId(SubID);

  N := Card;

  Add(OP_CALL, SubID, NParams, result);
  Add(OP_HALT, 0, 0, 0);

  SignFOP := false;

  Run;
//  TPaxBaseScripter(Scripter).RunEx(true);

  RestoreState;
end;

procedure TPAXCode.EvalSetProcedure(SubID: Integer; NParams: Integer; AValue: Variant);
begin
  SaveState;

  N := Card;
  Add(OP_PUSH, SymbolTable.AppVariant(AValue), 0, 0);
  Add(OP_CALL, SubID, NParams, 0);
  Add(OP_HALT, 0, 0, 0);

  SignFOP := false;

  Run;
//  TPaxBaseScripter(Scripter).RunEx(true);

  RestoreState;
end;

function TPAXCode.GetModuleID(J: Integer): Integer;
var
  I: Integer;
begin
  if (J < 1) or (J > Card) then
  begin
    result := 0;
    Exit;
  end;

  I := J;
  while Prog[I].Op <> OP_SEPARATOR do
    Dec(I);
  result := Prog[I].Arg1;
end;


function TPAXCode.ModuleID: Integer;
var
  I: Integer;
begin
  if (N < 1) or (N > Card) then
  begin
    result := 0;
    Exit;
  end;

  I := N;
  while Prog[I].Op <> OP_SEPARATOR do
    Dec(I);
  result := Prog[I].Arg1;
end;

function TPAXCode.LineID: Integer;
var
  I: Integer;
begin
  if (N < 1) or (N > Card) then
  begin
    result := -1;
    Exit;
  end;

  I := N;
  while Prog[I].Op <> OP_SEPARATOR do
    Dec(I);
  result := Prog[I].Arg2;
end;

function TPAXCode.CurrMethodID: Integer;
var
  I: Integer;
begin
  if (N < 1) or (N > Card) then
  begin
    result := 0;
    Exit;
  end;

  I := N;
  while Prog[N].Op <> OP_BEGIN_METHOD do
  begin
    Dec(I);

    if I = 0 then
    begin
      result := 0;
      Exit;
    end;
  end;

  result := Prog[I].Arg1;
end;

function TPAXCode.NextLineID: Integer;
var
  I: Integer;
begin
  if (N < 1) or (N > Card) then
  begin
    result := -1;
    Exit;
  end;

  I := N;
  while Prog[I].Op <> OP_SEPARATOR do
  begin
    if I >= Card then
      Break;
    Inc(I);
  end;
  result := I;
end;

procedure TPAXCode.Optimization(StartPos, EndPos: Integer);


function IsNotUsed(Arg, L: Integer): Boolean;
var
  I: Integer;
begin
  result := true;
  for I:=1 to Card do
    if I <> L then
      if Prog[I].Op <> OP_SEPARATOR then
        if (Prog[I].Arg1 = Arg) or
           (Prog[I].Arg2 = Arg) or
           (Prog[I].Res  = Arg) then
           begin
             result := false;
             Exit;
           end;
end;


var
  I, _OP, _NextOP: Integer;
begin
  for I:=StartPos to EndPos - 1 do
  begin
    _OP := Prog[I].Op;
    _NextOP := Prog[I+1].Op;

    if _OP = OP_EVAL_WITH then
    begin
      if SymbolTable.IsLocal(Prog[I].Res) then
        Prog[I].Op := OP_NOP;
    end
    else if _OP = OP_CALL then
    begin
      if IsNotUsed(Prog[I].Res, I) then
        Prog[I].Res := 0;
    end
    else if _NextOP = OP_ASSIGN then
    begin
      if Prog[I].Res = Prog[I + 1].Arg2 then
        if (_OP = OP_PLUS) or (_OP = OP_PLUS_EX) or
           (_OP = OP_MINUS) or (_OP = OP_MINUS_EX) or
           (_OP = OP_MULT) or (_OP = OP_MULT_EX) or
           (_OP = OP_DIV) or (_OP = OP_DIV_EX) or
           (_OP = OP_INT_DIV) or
           (_OP = OP_MOD) or (_OP = OP_MOD_EX) or

           (_OP = OP_AND) or
           (_OP = OP_OR) or
           (_OP = OP_XOR) or
           (_OP = OP_LEFT_SHIFT) or (_OP = OP_LEFT_SHIFT_EX) or
           (_OP = OP_RIGHT_SHIFT) or (_OP = OP_RIGHT_SHIFT_EX) or
           (_OP = OP_UNSIGNED_RIGHT_SHIFT) or (_OP = OP_UNSIGNED_RIGHT_SHIFT_EX) or

           (_OP = OP_NOT) or
           (_OP = OP_UNARY_MINUS) or (_OP = OP_UNARY_MINUS_EX) or

           (_OP = OP_GT) or (_OP = OP_GT_EX) or
           (_OP = OP_GE) or (_OP = OP_GE_EX) or
           (_OP = OP_LT) or (_OP = OP_LT_EX) or
           (_OP = OP_LE) or (_OP = OP_LE_EX) or
           (_OP = OP_EQ) or (_OP = OP_EQ_EX) or
           (_OP = OP_NE) or (_OP = OP_NE_EX) or

           (_OP = OP_ASSIGN_ADDRESS) then

          begin
            Prog[I].Res := Prog[I + 1].Res;

            Prog[I+1].Op := OP_NOP;
            Prog[I+1].Arg1 := 0;
            Prog[I+1].Arg2 := 0;
            Prog[I+1].Res := 0;
          end;
    end;
  end;
end;

function TPAXCode.IsExecutableLine(I: Integer): Boolean;
var
  J: Integer;
begin
  if (I < 1) or (I >= Card) then
  begin
    result := false;
    Exit;
  end;
{
  result := (Prog[I].Op = OP_SEPARATOR) and (Prog[I+1].Op <> OP_SEPARATOR) and
            (Prog[I+1].Op <> OP_SKIP) and
            (Prog[I+1].Op <> OP_HALT);
  Exit;
}
   if Prog[I + 1].Op = OP_SEPARATOR then
   begin
     result := Prog[I + 1].IsExecutable;
     Exit;
   end;
   
   result := Prog[I].IsExecutable;

   if not result then
   begin
     for J := I + 1 to Card do
     begin
       if Prog[J].Op = OP_SEPARATOR then
       begin
         result := false;
         Exit;
       end;

       if Prog[J].IsExecutable then
       begin
         result := true;
         Exit;
       end;
     end;
   end;
end;

function TPaxCode.IsExecutableSourceLine(const ModuleName: String; L: Integer): Boolean;
var
  I, J, Idx: Integer;
  CurrModuleId: Integer;
begin
  result := false;

  Idx := TPAXBaseScripter(Scripter).Modules.IndexOf(ModuleName);
  if Idx = -1 then
    Exit;

  for I := 1 to Card do
    with Prog[I] do
      if Op = OP_SEPARATOR then
        if Arg2 = L then
        begin
          CurrModuleId := GetModuleId(I);
          if CurrModuleId = Idx then
          begin
            if Prog[I + 1].Op = OP_SEPARATOR then
            begin
              result := Prog[I + 1].IsExecutable;
              Exit;
            end;
            result := Prog[I].IsExecutable;

            if not result then
            begin
              for J := I + 1 to Card do
              begin
                if Prog[J].Op = OP_SEPARATOR then
                begin
                  result := false;
                  Exit;
                end;

                if Prog[J].IsExecutable then
                begin
                  result := true;
                  Exit;
                end;
              end;
            end;

            Exit;
          end;
        end;
end;

procedure TPAXCode.Dump(const FileName: String);

function NormRight(const S: String; L: Integer): String;
begin
  result := Copy(S, 1, L);
  while Length(result) < L do
    result := result + ' ';
end;

var
  I: Integer;
  A1, A2, R, AltA1, IsExecutableStr: String;
  M: TPAXModule;
  L: TStringList;
begin
  M := nil;

  L := TStringList.Create;

  I := 0;
  try
    while I < Card do
    begin
      Inc(I);

      with Prog[I], SymbolTable do

      if Op = OP_SEPARATOR then
      begin
        if Arg2 = 0 then
        begin
          M := TPAXBaseScripter(Scripter).Modules.Items[Arg1];
          if M <> nil then
            L.Add('     Module '+ Norm(M.Name, 12)+ ' **********************');
        end;

        if (Arg2 >= 0) and (Arg2 < M.Count) then
          R := M.Strings[Arg2]
        else
          R := '';
          
        if IsExecutable then
          IsExecutableStr := 'true'
        else
          IsExecutableStr := '';

        L.Add(Norm(IntToStr(I),5) + '   Line ' + Norm(IntToStr(Arg2),5) + '  ' + NormRight(R,40) + ' :' +
            Norm(IntToStr(Res),5) + ' ' + IsExecutableStr);
      end
      else
      begin
        AltA1 := '';

        if Arg1 = 0 then
          A1 := Norm('', 17)
        else
        begin
          if (Op = OP_GO) or (Op = OP_GO_FALSE) or (OP = OP_TRY_ON) or (Op = OP_EXIT) or
             (Op = OP_GO_TRUE) or
             (Op = FOP_GO_FALSE1) or (Op = FOP_GO_FALSE2) or (Op = OP_GO_FALSE_EX) or
             (Op = FOP_GO_TRUE1) or (Op = FOP_GO_TRUE2) or (Op = OP_GO_TRUE_EX) then
            A1 := Norm(IntToStr(Arg1) + '^', 17)
          else
          begin
            if Pos('$', Name[Arg1]) = 0 then
            begin
              if Kind[Arg1] = KindCONST then
                A1 := Norm(GetStrVal(Arg1), 17)
              else
                A1 := Norm(Name[Arg1], 10) + '[' + Norm(IntToStr(Arg1),5) + ']';
            end
            else
              A1 := Norm(Name[Arg1], 10) + '[' + Norm(IntToStr(Arg1),5) + ']';
          end;
        end;

        if (Op = OP_CALL) or (Op = OP_PUT_PROPERTY) or (Op = OP_CREATE_ARRAY) or
           (Op = OP_PRINT) then
          A2 := Norm(IntToStr(Arg2), 17)
        else if Op = OP_SET_TYPE then
        begin
          A2 := Norm(TPaxBaseScripter(Scripter).NameList[Arg2], 17);
        end
        else
        begin
          if Arg2 = 0 then
            A2 := Norm('', 17)
          else
          begin
            if Pos('$', Name[Arg2]) = 0 then
            begin
              if Kind[Arg2] = KindCONST then
                A2 := Norm(GetStrVal(Arg2), 17)
              else
                A2 := Norm(Name[Arg2], 10) + '[' + Norm(IntToStr(Arg2),5) + ']';
            end
            else
            begin
              A2 := Norm(Name[Arg2], 10) + '[' + Norm(IntToStr(Arg2),5) + ']';
            end;
          end;
        end;

        if Res = 0 then
          R := Norm('', 10)
        else
        begin
          R := Norm(Name[Res], 10) + '[' + Norm(IntToStr(Res),5) + ']'
        end;

        if Op = OP_CALL then
          AltA1 := ' alt = ' + IntToStr(AltArg1)
        else
          if AltArg1 > 0 then
             AltA1 := ' alt = ' + IntToStr(AltArg1);

        if IsExecutable then
          IsExecutableStr := 'true'
        else
          IsExecutableStr := '';

        L.Add(Norm(IntToStr(I),5) + '   ' + Norm(GetOperName(Op), 12) +
              A1 + ' ' + A2 + ' ' + R + AltA1 + ' ' + IsExecutableStr);
      end;
    end;
  finally
    L.Add('N = ' + IntToStr(N));
    L.Add('Card = ' + IntToStr(Card));
    L.SaveToFile(FileName);
    L.Free;
  end;
end;

procedure TPAXCode.LinkGoTo(StartPos, EndPos: Integer);
var
  I, L, L1: Integer;
  V: Variant;
label
  Again;
begin
  for I:=StartPos to EndPos do
    with Prog[I] do
    if (Op = OP_GO) or (Op = OP_GO_FALSE) or (Op = OP_GO_FALSE_EX) or (Op = OP_TRY_ON) or
       (Op = OP_GO_TRUE) or (Op = OP_GO_TRUE_EX) or
       ((Op = OP_EXIT) and (Arg1 > 0)) then
    begin
      if Arg1 = 0 then
      begin
        Card := I;
        raise TPAXScriptFailure.Create(errLabelIsNotFound);
      end;

      V := SymbolTable.GetVariant(Arg1);
      if IsUndefined(V) then
      begin
        Card := I;
        TPaxBaseScripter(Scripter).Dump;
        raise TPAXScriptFailure.Create(errLabelIsNotFound);
      end;

      L := V;
      if L > 0 then
      begin

        L1 := L;
        while (Prog[L].Op = OP_SEPARATOR) do
          Inc(L);
        if L - L1 < 2 then
          L := L1
        else
          Dec(L);


        while Prog[L].Op = OP_NOP do
          Inc(L);

        Arg1 := L;
        if Prog[Arg1].Op <> OP_SEPARATOR then
          if Prog[Arg1 - 1].Op = OP_SEPARATOR then
            Dec(Arg1);
      end;
    end;


  for I:=StartPos to EndPos do
    with Prog[I] do
    if (Op = OP_GO) or (Op = OP_GO_FALSE) or (Op = OP_GO_FALSE_EX) or (Op = OP_TRY_ON) or
       (Op = OP_GO_TRUE) or (Op = OP_GO_TRUE_EX) or
       ((Op = OP_EXIT) and (Arg1 > 0)) then
    begin
      L := Arg1;
      if Prog[L].Op = OP_GO then
        Arg1 := Prog[L].Arg1;
    end;
end;

procedure TPAXCode.InitRunStage;
begin
  SaveState;
end;

procedure TPAXCode.ResetRunStage;
var
  I: Integer;
begin
  for I:=1 to Card do
    if Prog[I].Op = FOP_CALL then
       Prog[I].Op := OP_CALL;

  N := 0;

  UsingList.Clear;
  WithStack.Clear;
  TryStack.Clear;
//  BreakpointList.Clear;

  RestoreState;
  StateStack.Clear;
  DebugInfo.Clear;
  RefStack.Clear;
  Stack.Clear;
  SubRunCount := 0;
  SignHaltGlobal := false;
end;

function TPAXCode.IsBreakpoint(L: Integer): Boolean;
var
  B: TPaxBreakpoint;
  I: Integer;
  P: TPaxParser;
  V: Variant;
  ID: Integer;
  S: String;
begin
  I := BreakpointList.IndexOf(L);
  result := I <> -1;

  if not result then
    Exit;

  B := BreakpointList[I];

  if (B.Condition = '') and (B.PassCount = 0) then
    Exit;

  if (B.Condition = '') then
  begin
    if B.CurrPassCount = -1 then
      B.CurrPassCount := 0;

    // check pass count
    Inc(B.CurrPassCount);
    result := B.CurrPassCount = B.PassCount;
    Exit;
  end;

  // B.Condition <> '' here

  ID := GetLanguageNamespaceID;
  S := SymbolTable.Name[ID];
  I := Pos('Namespace', S);
  S := Copy(S, 1, I - 1);

  P := TPAXBaseScripter(Scripter).ParserList.FindParser(S);

  if P = nil then
    Exit;

  V := TPaxBaseScripter(scripter).Eval(B.Condition, P);

  if VarType(V) <> varBoolean then Exit;

  result := V;

  if not result then Exit;

  if B.PassCount <> 0 then
  begin
    if B.CurrPassCount = -1 then
      B.CurrPassCount := 0;

    // check pass count
    Inc(B.CurrPassCount);
    result := B.CurrPassCount = B.PassCount;
  end;
end;

procedure TPAXCode.SetFOP(FOP: Integer; Ex: Boolean = false);
var
  VT1, VT2, T1, T2, _Mode: Integer;
begin
  if not SignFOP then
    Exit;

  if Prog[N].Op = OP_INT_DIV then
    Exit;

  if Prog[N-1].Op = OP_GET_ITEM then
    Exit;

  with Prog[N], SymbolTable do
  begin
    if (Arg1 < 0) or (Arg2 < 0) or (Res < 0) then
//       (Kind[Arg1] <> KindVAR) or (Kind[Arg2] <> KindVAR) then
      Exit;

    if LevelStack.Card <= 1 then
      _Mode := 1
    else
      _Mode := 2;

//    S := Name[res];
//    if Pos('$', S) = 0 then
//      Exit;

    if FOP = FOP_ASSIGN then
    begin
      if IsAlias(A[Res].Address) then
        Exit;

      if (not Kind[Arg1] in [KindVAR, KindCONST]) or (not Kind[Arg2] in [KindVAR, KindCONST]) then
         Exit;

      if Kind[Arg1] in [KindHOSTVAR, KindHOSTOBJECT, KindHOSTINTERFACEVAR] then
        Exit;
      if Kind[Arg2] in [KindHOSTVAR, KindHOSTOBJECT, KindHOSTINTERFACEVAR] then
        Exit;

      PP_Arg2 := @A[Arg2].Address;
      PP_Res := @A[Res].Address;
      VT2 := TVarData(Pointer(PP_Arg2^)^).VType;
      if Kind[Res] <> KindREF then
        case VT2 of
          varInteger, varDouble, varBoolean:
          begin
            OP := FOP;
          end;
        end;
      Exit;
    end;

    if FOP = OP_GO_FALSE then
    begin
      if (Kind[Arg2] <> KindVAR) then
         Exit;

      PP_Arg2 := @A[Arg2].Address;
      if TVarData(Pointer(PP_Arg2^)^).VType = varBoolean then
      begin
        if _Mode = 1 then
        begin
          PP_Arg2 := Pointer(Integer(PP_Arg2^) + 8);
          OP := FOP_GO_FALSE1;
        end
        else
          OP := FOP_GO_FALSE2;
      end;
      Exit;
    end;

    if FOP = OP_GO_TRUE then
    begin
      if (Kind[Arg2] <> KindVAR) then
         Exit;

      PP_Arg2 := @A[Arg2].Address;
      if TVarData(Pointer(PP_Arg2^)^).VType = varBoolean then
      begin
        if _Mode = 1 then
        begin
          PP_Arg2 := Pointer(Integer(PP_Arg2^) + 8);
          OP := FOP_GO_TRUE1;
        end
        else
          OP := FOP_GO_TRUE2;
      end;
      Exit;
    end;

    PP_Res := @A[Res].Address;

    if FOP = OP_NOT then
    begin
      if (Kind[Arg1] <> KindVAR) then
         Exit;

      PP_Arg1 := @A[Arg1].Address;
      VT1 := TVarData(Pointer(PP_Arg1^)^).VType;
      case VT1 of
        varInteger:
          if _Mode = 1 then
          begin
            PP_Res := Pointer(PP_Res^);
            PP_Arg1 := Pointer(Integer(PP_Arg1^) + 8);
            OP := FOP_BITWISE_NOT1;
          end
          else
            OP := FOP_BITWISE_NOT2;
        varBoolean:
          if _Mode = 1 then
          begin
            PP_Res := Pointer(PP_Res^);
            PP_Arg1 := Pointer(Integer(PP_Arg1^) + 8);
            OP := FOP_LOGICAL_NOT1;
          end
          else
            OP := FOP_LOGICAL_NOT2;
      end;
      Exit;
    end;

    if FOP = OP_UNARY_MINUS then
    begin
      if (Kind[Arg1] <> KindVAR) then
         Exit;

      PP_Arg1 := @A[Arg1].Address;
      VT1 := TVarData(Pointer(PP_Arg1^)^).VType;
      case VT1 of
        varInteger:
          if _Mode = 1 then
          begin
            PP_Res := Pointer(PP_Res^);
            PP_Arg1 := Pointer(Integer(PP_Arg1^) + 8);
            OP := FOP_UNARY_MINUS_INTEGER1;
          end
          else
            OP := FOP_UNARY_MINUS_INTEGER2;
        varDouble:
          if _Mode = 1 then
          begin
            PP_Res := Pointer(PP_Res^);
            PP_Arg1 := Pointer(Integer(PP_Arg1^) + 8);
            OP := FOP_UNARY_MINUS_DOUBLE1;
          end
          else
            OP := FOP_UNARY_MINUS_DOUBLE2;
      end;
      Exit;
    end;

    if (Kind[Arg1] = KindHostVAR) or (Kind[Arg2] = KindHostVAR) or
       (Kind[Arg1] = KindHostCONST) or (Kind[Arg2] = KindHostCONST) then
       Exit;

    PP_Arg1 := @A[Arg1].Address;
    PP_Arg2 := @A[Arg2].Address;
    VT1 := TVarData(Pointer(PP_Arg1^)^).VType;
    VT2 := TVarData(Pointer(PP_Arg2^)^).VType;

    if VT1 = VT2 then
    begin
      T1 := PType[Arg1];
      if T1 > PAXTypes.Count then
        Exit;
      if not (T1 in SupportedPaxTypes) then
        Exit;

      T2 := PType[Arg2];
      if T2 > PAXTypes.Count then
        Exit;
      if not (T2 in SupportedPaxTypes) then
        Exit;

      if _Mode = 1 then
      begin
        PP_Res := Pointer(PP_Res^);
        PP_Arg1 := Pointer(Integer(PP_Arg1^) + 8);
        PP_Arg2 := Pointer(Integer(PP_Arg2^) + 8);
      end;

      case VT1 of
        varInteger:
        begin
          if _Mode = 1 then
          begin
            if (FOP = OP_PLUS) or (FOP = OP_PLUS_EX) then
            begin
              OP := FOP_PLUS_INTEGER1;
              if Arg1 = Res then
                if Integer(PP_Arg2^) = 1 then
                  if Kind[Arg2] = KindCONST then
                  begin
                    OP := FOP_INC1;
                    PP_Res := ShiftPointer(PP_Res, 8);
                  end;
            end
            else if (FOP = OP_MINUS) or (FOP = OP_MINUS_EX) then
              OP := FOP_MINUS_INTEGER1
            else if (FOP = OP_MULT) or (FOP = OP_MULT_EX) then
              OP := FOP_MULT_INTEGER1
            else if FOP = OP_INT_DIV then
              OP := FOP_DIV_INTEGER1
            else if FOP = OP_DIV then
              OP := FOP_DIV_INTEGER1
            else if (FOP = OP_MOD) or (FOP = OP_MOD_EX) then
              OP := FOP_MOD1
            else if (FOP = OP_LT) or (FOP = OP_LT_EX) then
              OP := FOP_LT_INTEGER1
            else if (FOP = OP_LE) or (FOP = OP_LE_EX) then
              OP := FOP_LE_INTEGER1
            else if (FOP = OP_GT) or (FOP = OP_GT_EX) then
              OP := FOP_GT_INTEGER1
            else if (FOP = OP_GE) or (FOP = OP_GE_EX) then
              OP := FOP_GE_INTEGER1
            else if (FOP = OP_EQ) or (FOP = OP_EQ_EX) then
              OP := FOP_EQ_INTEGER1
            else if (FOP = OP_NE) or (FOP = OP_NE_EX) then
              OP := FOP_NE_INTEGER1
            else if (FOP = OP_AND) then
              OP := FOP_BITWISE_AND1
            else if (FOP = OP_OR)  then
              OP := FOP_BITWISE_OR1
            else if (FOP = OP_XOR) then
              OP := FOP_BITWISE_XOR1
            else if (FOP = OP_LEFT_SHIFT) or (FOP = OP_LEFT_SHIFT_EX) then
              OP := FOP_SHL1
            else if (FOP = OP_RIGHT_SHIFT) or (FOP = OP_RIGHT_SHIFT_EX) then
              OP := FOP_SHR1
            else if (FOP = OP_UNSIGNED_RIGHT_SHIFT) or (FOP = OP_UNSIGNED_RIGHT_SHIFT_EX) then
              OP := FOP_USHR1
          end
          else // _Mod = 2
          begin
            if (FOP = OP_PLUS) or (FOP = OP_PLUS_EX) then
              OP := FOP_PLUS2
            else if (FOP = OP_MINUS) or (FOP = OP_MINUS_EX) then
              OP := FOP_MINUS2
            else if (FOP = OP_MULT) or (FOP = OP_MULT_EX) then
              OP := FOP_MULT2
            else if (FOP = OP_INT_DIV) then
              OP := FOP_DIV2
            else if (FOP = OP_DIV) then
              OP := FOP_DIV2
            else if (FOP = OP_MOD) or (FOP = OP_MOD_EX) then
              OP := FOP_MOD2
            else if (FOP = OP_LT) or (FOP = OP_LT_EX) then
              OP := FOP_LT2
            else if (FOP = OP_LE) or (FOP = OP_LE_EX) then
              OP := FOP_LE2
            else if (FOP = OP_GT) or (FOP = OP_GT_EX) then
              OP := FOP_GT2
            else if (FOP = OP_GE) or (FOP = OP_GE_EX) then
              OP := FOP_GE2
            else if (FOP = OP_EQ) or (FOP = OP_EQ_EX) then
              OP := FOP_EQ2
            else if (FOP = OP_NE) or (FOP = OP_NE_EX) then
              OP := FOP_NE2
            else if (FOP = OP_AND) then
              OP := FOP_BITWISE_AND2
            else if (FOP = OP_OR)  then
              OP := FOP_BITWISE_OR2
            else if FOP = OP_XOR then
              OP := FOP_BITWISE_XOR2
            else if (FOP = OP_LEFT_SHIFT) or (FOP = OP_LEFT_SHIFT_EX) then
              OP := FOP_SHL2
            else if (FOP = OP_RIGHT_SHIFT) or (FOP = OP_RIGHT_SHIFT_EX) then
              OP := FOP_SHR2
            else if (FOP = OP_UNSIGNED_RIGHT_SHIFT) or (FOP = OP_UNSIGNED_RIGHT_SHIFT_EX) then
              OP := FOP_USHR2
          end;
        end;
        varDouble:
        begin
          if _Mode = 1 then
          begin
            if (FOP = OP_PLUS) or (FOP = OP_PLUS_EX) then
              OP := FOP_PLUS_DOUBLE1
            else if (FOP = OP_MINUS) or (FOP = OP_MINUS_EX) then
              OP := FOP_MINUS_DOUBLE1
            else if (FOP = OP_MULT) or (FOP = OP_MULT_EX) then
              OP := FOP_MULT_DOUBLE1
            else if (FOP = OP_DIV) or (FOP = OP_DIV_EX) then
              OP := FOP_DIV_DOUBLE1
            else if (FOP = OP_LT) or (FOP = OP_LT_EX) then
              OP := FOP_LT_DOUBLE1
            else if (FOP = OP_LE) or (FOP = OP_LE_EX) then
              OP := FOP_LE_DOUBLE1
            else if (FOP = OP_GT) or (FOP = OP_GT_EX) then
              OP := FOP_GT_DOUBLE1
            else if (FOP = OP_GE) or (FOP = OP_GE_EX) then
              OP := FOP_GE_DOUBLE1
            else if (FOP = OP_EQ) or (FOP = OP_EQ_EX) then
              OP := FOP_EQ_DOUBLE1
            else if (FOP = OP_NE) or (FOP = OP_NE_EX) then
              OP := FOP_NE_DOUBLE1;
          end
          else // _Mode = 2
          begin
            if (FOP = OP_PLUS) or (FOP = OP_PLUS_EX) then
              OP := FOP_PLUS2
            else if (FOP = OP_MINUS) or (OP = OP_MINUS_EX )then
              OP := FOP_MINUS2
            else if (FOP = OP_MULT) or (FOP = OP_MULT_EX) then
              OP := FOP_MULT2
            else if (FOP = OP_DIV) or (FOP = OP_DIV_EX) then
              OP := FOP_DIV2
            else if (FOP = OP_LT) or (FOP = OP_LT_EX) then
              OP := FOP_LT2
            else if (FOP = OP_LE) or (FOP = OP_LE_EX) then
              OP := FOP_LE2
            else if (FOP = OP_GT) or (FOP = OP_GT_EX) then
              OP := FOP_GT2
            else if (FOP = OP_GE) or (FOP = OP_GE_EX) then
              OP := FOP_GE2
            else if (FOP = OP_EQ) or (FOP = OP_EQ_EX) then
              OP := FOP_EQ2
            else if (FOP = OP_NE) or (FOP = OP_NE_EX) then
              OP := FOP_NE2;
          end;
        end;
        varBoolean:
        begin
          if _Mode = 1 then
          begin
            if (FOP = OP_AND) then
              OP := FOP_LOGICAL_AND1
            else if (FOP = OP_OR) then
              OP := FOP_LOGICAL_OR1
            else if (FOP = OP_XOR) then
              OP := FOP_LOGICAL_XOR1;
          end
          else
          begin
            if FOP = OP_AND then
              OP := FOP_LOGICAL_AND2
            else if FOP = OP_OR then
              OP := FOP_LOGICAL_OR2
            else if FOP = OP_XOR then
              OP := FOP_LOGICAL_XOR2;
          end;
        end;
        varString:
        begin
          if _Mode = 1 then
          begin
            if (FOP = OP_PLUS) or (FOP = OP_PLUS_EX) then
              OP := FOP_PLUS_STRING1;
          end
          else
          begin
            if (FOP = OP_PLUS) or (FOP = OP_PLUS_EX) then
              OP := FOP_PLUS_STRING2;
          end;
        end;
      end;
    end
    else
    begin
      if VT1 in [varScriptObject, varAlias] then
        Exit;
      if VT2 in [varScriptObject, varAlias] then
        Exit;
      if Ex then
        Exit;

      if _Mode = 1 then
      begin
        PP_Res := Pointer(PP_Res^);
        PP_Arg1 := Pointer(PP_Arg1^);
        PP_Arg2 := Pointer(PP_Arg2^);
        if FOP = OP_PLUS then
          OP := FOP_PLUS1
        else if FOP = OP_MINUS then
          OP := FOP_MINUS1
        else if FOP = OP_MULT then
          OP := FOP_MULT1
        else if FOP = OP_DIV then
          OP := FOP_DIV1
        else if FOP = OP_LT then
          OP := FOP_LT1
        else if FOP = OP_LE then
          OP := FOP_LE1
        else if FOP = OP_GT then
          OP := FOP_GT1
        else if FOP = OP_GE then
          OP := FOP_GE1
        else if FOP = OP_EQ then
          OP := FOP_EQ1
        else if FOP = OP_NE then
          OP := FOP_NE1;
      end
      else
      begin
        if FOP = OP_PLUS then
          OP := FOP_PLUS2
        else if FOP = OP_MINUS then
          OP := FOP_MINUS2
        else if FOP = OP_MULT then
          OP := FOP_MULT2
        else if FOP = OP_DIV then
          OP := FOP_DIV2
        else if FOP = OP_LT then
          OP := FOP_LT2
        else if FOP = OP_LE then
          OP := FOP_LE2
        else if FOP = OP_GT then
          OP := FOP_GT2
        else if FOP = OP_GE then
          OP := FOP_GE2
        else if FOP = OP_EQ then
          OP := FOP_EQ2
        else if FOP = OP_NE then
          OP := FOP_NE2;
      end;
    end;
  end;
end;

//--- "INC"

procedure TPAXCode.FOperINC1;
begin
  with Prog[N] do
    Inc(Integer(PP_Res^));
  Inc(N);
end;

procedure TPAXCode.FOperINC2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
      Inc(VInteger);
  Inc(N);
end;

//--- "+"

procedure TPAXCode.FOperPlus1;
begin
  with Prog[N] do
    Variant(PP_Res^) := Variant(PP_Arg1^) + Variant(PP_Arg2^);
  Inc(N);
end;

procedure TPAXCode.FOperPlus2;
begin
  with Prog[N] do
    Variant(Pointer(PP_Res^)^) := Variant(Pointer(PP_Arg1^)^) +
                                   Variant(Pointer(PP_Arg2^)^);
  Inc(N);
end;

procedure TPAXCode.FOperPlusInteger1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varInteger;
      VInteger := Integer(PP_Arg1^) + Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperPlusInteger2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varInteger;
      VInteger := TVarData(Pointer(PP_Arg1^)^).VInteger +
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

procedure TPAXCode.FOperPlusDouble1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varDouble;
      VDouble := Double(PP_Arg1^) + Double(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperPlusDouble2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varDouble;
      VDouble := TVarData(Pointer(PP_Arg1^)^).VDouble +
                 TVarData(Pointer(PP_Arg2^)^).VDouble;
    end;
  Inc(N);
end;

procedure TPAXCode.FOperPlusString1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varString;
      String(VString) := String(PP_Arg1^) + String(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperPlusString2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varString;
      String(VString) := String(TVarData(Pointer(PP_Arg1^)^).VString) +
                         String(TVarData(Pointer(PP_Arg2^)^).VString);
    end;
  Inc(N);
end;

//--- "-"

procedure TPAXCode.FOperMinus1;
begin
  with Prog[N] do
    Variant(PP_Res^) := Variant(PP_Arg1^) - Variant(PP_Arg2^);
  Inc(N);
end;

procedure TPAXCode.FOperMinus2;
begin
  with Prog[N] do
    Variant(Pointer(PP_Res^)^) := Variant(Pointer(PP_Arg1^)^) -
                                   Variant(Pointer(PP_Arg2^)^);
  Inc(N);
end;

procedure TPAXCode.FOperMinusInteger1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varInteger;
      VInteger := Integer(PP_Arg1^) - Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperMinusInteger2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varInteger;
      VInteger := TVarData(Pointer(PP_Arg1^)^).VInteger -
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

procedure TPAXCode.FOperMinusDouble1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varDouble;
      VDouble := Double(PP_Arg1^) - Double(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperMinusDouble2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varDouble;
      VDouble := TVarData(Pointer(PP_Arg1^)^).VDouble -
                  TVarData(Pointer(PP_Arg2^)^).VDouble;
    end;
  Inc(N);
end;

//--- "*"

procedure TPAXCode.FOperMult1;
begin
  with Prog[N] do
    Variant(PP_Res^) := Variant(PP_Arg1^) * Variant(PP_Arg2^);
  Inc(N);
end;

procedure TPAXCode.FOperMult2;
begin
  with Prog[N] do
    Variant(Pointer(PP_Res^)^) := Variant(Pointer(PP_Arg1^)^) *
                                   Variant(Pointer(PP_Arg2^)^);
  Inc(N);
end;

procedure TPAXCode.FOperMultInteger1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varInteger;
      VInteger := Integer(PP_Arg1^) * Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperMultInteger2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varInteger;
      VInteger := TVarData(Pointer(PP_Arg1^)^).VInteger *
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

procedure TPAXCode.FOperMultDouble1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varDouble;
      VDouble := Double(PP_Arg1^) * Double(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperMultDouble2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varDouble;
      VDouble := TVarData(Pointer(PP_Arg1^)^).VDouble *
                  TVarData(Pointer(PP_Arg2^)^).VDouble;
    end;
  Inc(N);
end;

//--- "div"

procedure TPAXCode.FOperDivInteger1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varInteger;
      VInteger := Integer(PP_Arg1^) div Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperDivInteger2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varInteger;
      VInteger := TVarData(Pointer(PP_Arg1^)^).VInteger div
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

//--- "mod"

procedure TPAXCode.FOperMod1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varInteger;
      VInteger := Integer(PP_Arg1^) mod Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperMod2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varInteger;
      VInteger := TVarData(Pointer(PP_Arg1^)^).VInteger mod
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

//--- "/"

procedure TPAXCode.FOperDiv1;
begin
  with Prog[N] do
    Variant(PP_Res^) := Variant(PP_Arg1^) / Variant(PP_Arg2^);
  Inc(N);
end;

procedure TPAXCode.FOperDiv2;
begin
  with Prog[N] do
    Variant(Pointer(PP_Res^)^) := Variant(Pointer(PP_Arg1^)^) /
                                   Variant(Pointer(PP_Arg2^)^);
  Inc(N);
end;

procedure TPAXCode.FOperDivDouble1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varDouble;
      VDouble := Double(PP_Arg1^) / Double(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperDivDouble2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varDouble;
      VDouble := TVarData(Pointer(PP_Arg1^)^).VDouble /
                  TVarData(Pointer(PP_Arg2^)^).VDouble;
    end;
  Inc(N);
end;

//--- "<"

procedure TPAXCode.FOperLT1;
begin
  with Prog[N] do
    Variant(PP_Res^) := Variant(PP_Arg1^) < Variant(PP_Arg2^);
  Inc(N);
end;

procedure TPAXCode.FOperLT2;
begin
  with Prog[N] do
    Variant(Pointer(PP_Res^)^) := Variant(Pointer(PP_Arg1^)^) <
                                   Variant(Pointer(PP_Arg2^)^);
  Inc(N);
end;

procedure TPAXCode.FOperLTInteger1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Integer(PP_Arg1^) < Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperLTInteger2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VInteger <
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

procedure TPAXCode.FOperLTDouble1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Double(PP_Arg1^) < Double(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperLTDouble2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VDouble <
                  TVarData(Pointer(PP_Arg2^)^).VDouble;
    end;
  Inc(N);
end;

//--- "<="

procedure TPAXCode.FOperLE1;
begin
  with Prog[N] do
    Variant(PP_Res^) := Variant(PP_Arg1^) <= Variant(PP_Arg2^);
  Inc(N);
end;

procedure TPAXCode.FOperLE2;
begin
  with Prog[N] do
    Variant(Pointer(PP_Res^)^) := Variant(Pointer(PP_Arg1^)^) <=
                                   Variant(Pointer(PP_Arg2^)^);
  Inc(N);
end;

procedure TPAXCode.FOperLEInteger1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Integer(PP_Arg1^) <= Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperLEInteger2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VInteger <=
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

procedure TPAXCode.FOperLEDouble1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Double(PP_Arg1^) <= Double(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperLEDouble2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VDouble <=
                  TVarData(Pointer(PP_Arg2^)^).VDouble;
    end;
  Inc(N);
end;

//--- ">"

procedure TPAXCode.FOperGT1;
begin
  with Prog[N] do
    Variant(PP_Res^) := Variant(PP_Arg1^) > Variant(PP_Arg2^);
  Inc(N);
end;

procedure TPAXCode.FOperGT2;
begin
  with Prog[N] do
    Variant(Pointer(PP_Res^)^) := Variant(Pointer(PP_Arg1^)^) >
                                   Variant(Pointer(PP_Arg2^)^);
  Inc(N);
end;

procedure TPAXCode.FOperGTInteger1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Integer(PP_Arg1^) > Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperGTInteger2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VInteger >
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

procedure TPAXCode.FOperGTDouble1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Double(PP_Arg1^) > Double(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperGTDouble2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VDouble >
                  TVarData(Pointer(PP_Arg2^)^).VDouble;
    end;
  Inc(N);
end;

//--- ">="

procedure TPAXCode.FOperGE1;
begin
  with Prog[N] do
    Variant(PP_Res^) := Variant(PP_Arg1^) >= Variant(PP_Arg2^);
  Inc(N);
end;

procedure TPAXCode.FOperGE2;
begin
  with Prog[N] do
    Variant(Pointer(PP_Res^)^) := Variant(Pointer(PP_Arg1^)^) >=
                                   Variant(Pointer(PP_Arg2^)^);
  Inc(N);
end;

procedure TPAXCode.FOperGEInteger1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Integer(PP_Arg1^) >= Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperGEInteger2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VInteger >=
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

procedure TPAXCode.FOperGEDouble1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Double(PP_Arg1^) >= Double(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperGEDouble2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VDouble >=
                  TVarData(Pointer(PP_Arg2^)^).VDouble;
    end;
  Inc(N);
end;

//--- "="

procedure TPAXCode.FOperEQ1;
begin
  with Prog[N] do
    Variant(PP_Res^) := Variant(PP_Arg1^) = Variant(PP_Arg2^);
  Inc(N);
end;

procedure TPAXCode.FOperEQ2;
begin
  with Prog[N] do
    Variant(Pointer(PP_Res^)^) := Variant(Pointer(PP_Arg1^)^) =
                                   Variant(Pointer(PP_Arg2^)^);
  Inc(N);
end;

procedure TPAXCode.FOperEQInteger1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Integer(PP_Arg1^) = Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperEQInteger2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VInteger =
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

procedure TPAXCode.FOperEQDouble1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Double(PP_Arg1^) = Double(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperEQDouble2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VDouble =
                  TVarData(Pointer(PP_Arg2^)^).VDouble;
    end;
  Inc(N);
end;

//--- "<>"

procedure TPAXCode.FOperNE1;
begin
  with Prog[N] do
    Variant(PP_Res^) := Variant(PP_Arg1^) <> Variant(PP_Arg2^);
  Inc(N);
end;

procedure TPAXCode.FOperNE2;
begin
  with Prog[N] do
    Variant(Pointer(PP_Res^)^) := Variant(Pointer(PP_Arg1^)^) <>
                                   Variant(Pointer(PP_Arg2^)^);
  Inc(N);
end;

procedure TPAXCode.FOperNEInteger1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Integer(PP_Arg1^) <> Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperNEInteger2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VInteger <>
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

procedure TPAXCode.FOperNEDouble1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Double(PP_Arg1^) <> Double(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperNEDouble2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VDouble <>
                  TVarData(Pointer(PP_Arg2^)^).VDouble;
    end;
  Inc(N);
end;

//--- "BITWISE AND"

procedure TPAXCode.FOperBitwiseAND1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varInteger;
      VInteger := Integer(PP_Arg1^) and Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperBitwiseAND2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varInteger;
      VInteger := TVarData(Pointer(PP_Arg1^)^).VInteger and
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

//--- "BITWISE OR"

procedure TPAXCode.FOperBitwiseOR1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varInteger;
      VInteger := Integer(PP_Arg1^) or Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperBitwiseOR2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varInteger;
      VInteger := TVarData(Pointer(PP_Arg1^)^).VInteger or
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

//--- "BITWISE XOR"

procedure TPAXCode.FOperBitwiseXOR1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varInteger;
      VInteger := Integer(PP_Arg1^) xor Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperBitwiseXOR2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varInteger;
      VInteger := TVarData(Pointer(PP_Arg1^)^).VInteger xor
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

//--- "LOGICAL AND"

procedure TPAXCode.FOperLogicalAND1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Boolean(PP_Arg1^) and Boolean(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperLogicalAND2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VBoolean and
                  TVarData(Pointer(PP_Arg2^)^).VBoolean;
    end;
  Inc(N);
end;

//--- "LOGICAL OR"

procedure TPAXCode.FOperLogicalOR1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Boolean(PP_Arg1^) or Boolean(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperLogicalOR2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VBoolean or
                  TVarData(Pointer(PP_Arg2^)^).VBoolean;
    end;
  Inc(N);
end;

//--- "LOGICAL XOR"

procedure TPAXCode.FOperLogicalXOR1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      VBoolean := Boolean(PP_Arg1^) xor Boolean(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperLogicalXOR2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      VBoolean := TVarData(Pointer(PP_Arg1^)^).VBoolean xor
                  TVarData(Pointer(PP_Arg2^)^).VBoolean;
    end;
  Inc(N);
end;

//--- "BITWISE NOT"

procedure TPAXCode.FOperBitwiseNOT1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varInteger;
      VInteger := not Integer(PP_Arg1^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperBitwiseNOT2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varInteger;
      VInteger := not TVarData(Pointer(PP_Arg1^)^).VInteger;
    end;
  Inc(N);
end;

//--- "LOGICAL NOT"

procedure TPAXCode.FOperLogicalNOT1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varBoolean;
      if Boolean(PP_Arg1^) then
        VBoolean := false
      else
        VBoolean := true;
    end;
  Inc(N);
end;

procedure TPAXCode.FOperLogicalNOT2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varBoolean;
      if TVarData(Pointer(PP_Arg1^)^).VBoolean then
        VBoolean := false
      else
        VBoolean := true;
    end;
  Inc(N);
end;

//--- "UNARY INTEGER MINUS"

procedure TPAXCode.FOperUnaryMinusInteger1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varInteger;
      VInteger := - Integer(PP_Arg1^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperUnaryMinusInteger2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varInteger;
      VInteger := - TVarData(Pointer(PP_Arg1^)^).VInteger;
    end;
  Inc(N);
end;

//--- "UNARY DOUBLE MINUS"

procedure TPAXCode.FOperUnaryMinusDouble1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varDouble;
      VDouble := - Double(PP_Arg1^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperUnaryMinusDouble2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varDouble;
      VDouble := - TVarData(Pointer(PP_Arg1^)^).VDouble;
    end;
  Inc(N);
end;

//--- "SHL"

procedure TPAXCode.FOperSHL1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varInteger;
      VInteger := Integer(PP_Arg1^) shl Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperSHL2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varInteger;
      VInteger := TVarData(Pointer(PP_Arg1^)^).VInteger shl
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

//--- "SHR"

procedure TPAXCode.FOperSHR1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varInteger;
      VInteger := Integer(PP_Arg1^) shr Integer(PP_Arg2^);
    end;
  Inc(N);
end;

procedure TPAXCode.FOperSHR2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varInteger;
      VInteger := TVarData(Pointer(PP_Arg1^)^).VInteger shr
                  TVarData(Pointer(PP_Arg2^)^).VInteger;
    end;
  Inc(N);
end;

//--- "USHR"

procedure TPAXCode.FOperUSHR1;
begin
  with Prog[N] do
    with TVarData(PP_Res^) do
    begin
      VType := varInteger;
      VInteger := _shr(Integer(PP_Arg1^), Integer(PP_Arg2^));
    end;
  Inc(N);
end;

procedure TPAXCode.FOperUSHR2;
begin
  with Prog[N] do
    with TVarData(Pointer(PP_Res^)^) do
    begin
      VType := varInteger;
      VInteger := _shr(TVarData(Pointer(PP_Arg1^)^).VInteger,
                  TVarData(Pointer(PP_Arg2^)^).VInteger);
    end;
  Inc(N);
end;

//--- ":="

procedure TPAXCode.FOperAssign;
begin
  with Prog[N] do
    Move(Pointer(PP_Arg2^)^, Pointer(PP_Res^)^, 16);
  Inc(N);
end;

//--- "GO FALSE"

procedure TPAXCode.FOperGoFalse1;
begin
  with Prog[N] do
    if Boolean(PP_Arg2^) then
      Inc(N)
    else
      N := Arg1;
end;

procedure TPAXCode.FOperGoFalse2;
begin
  with Prog[N] do
    if TVarData(Pointer(PP_Arg2^)^).VBoolean then
      Inc(N)
    else
      N := Arg1;
end;

//--- "GO TRUE"

procedure TPAXCode.FOperGoTrue1;
begin
  with Prog[N] do
    if not Boolean(PP_Arg2^) then
      Inc(N)
    else
      N := Arg1;
end;

procedure TPAXCode.FOperGoTrue2;
begin
  with Prog[N] do
    if not TVarData(Pointer(PP_Arg2^)^).VBoolean then
      Inc(N)
    else
      N := Arg1;
end;


procedure TPAXCode.FOperPush;
begin
  while Prog[N].Op = FOP_PUSH do
  begin
    Stack.Push(Pointer(Prog[N].PP_Arg1^));
    Inc(N);
  end;
end;

procedure TPAXCode.FOperCall;
var
  I, NP, ParamID: Integer;
  P: PVariant;
  K: Integer;
  BoundID: Integer;
begin
  K := 0;
  with SymbolTable, Prog[N] do
  begin
    _ParamCount := Arg2;

    NP := Count[_SubID];
    if NP > _ParamCount then
    begin
      BoundID := GetParamID(_SubID, _ParamCount);
      I := TPaxBaseScripter(Scripter).DefaultParameterList.FindFirst(_SubID);
      while I <> -1 do
      begin
        if TPaxBaseScripter(Scripter).DefaultParameterList[I].ID > BoundID then
        begin
          Inc(_ParamCount);
          Stack.Push(@ TPaxBaseScripter(Scripter).DefaultParameterList[I].Value);
        end;
        I := TPaxBaseScripter(Scripter).DefaultParameterList.FindNext(I, _SubID);
      end;
      if NP > _ParamCount then
        if DeclareON then raise TPAXScriptFailure.Create(errNotEnoughParameters)
      else if NP < _ParamCount then
        if DeclareON then raise TPAXScriptFailure.Create(errTooManyParameters);
    end;

    AllocateSub(_SubID);
//    ParamID := GetParamID(_SubID, Arg2);
    ParamID := _SubID + _ParamCount + 2;
    for I:=_ParamCount downto 1 do
    begin
      P := Stack.PopPointer;
      with A[ParamID] do
      if Misc > 0 then // byRef
      begin
        Inc(K);
        RefStack.Push(Address);
        RefStack.Push(ParamID);
        Address := P;
      end
      else
      begin
        case TVarData(P^).VType of
          varInteger:
          with TVarData(Address^) do
          begin
            VType := varInteger;
            VInteger := TVarData(P^).VInteger;
          end;
          varString:
          with TVarData(Address^) do
          begin
            VType := varString;
            String(VString) := String(TVarData(P^).VString);
          end;
          varDouble:
          with TVarData(Address^) do
          begin
            VType := varDouble;
            VDouble := TVarData(P^).VDouble;
          end;
          else
            Variant(Address^) := P^;
        end;
      end;
      if DebugState then
        DebugInfo.Push(P);
      Dec(ParamID);
    end;
    if DebugState then
    with DebugInfo do
    begin
      Push(Arg2);
      Push(N);
      Push(_SubID);
    end;
    with Stack do
    begin
      Push(N);
      Push(_SubID);
      Push(Res);
    end;

    N := _Entry;
    LevelStack.Push(_SubID);
  end;
  RefStack.Push(K);
end;

function TPAXCode.FindCreateObjectStmt(TypeID: Integer): Integer;
var
  I: Integer;
begin
  for I:=1 to Card do
    if Prog[I].Op = OP_CREATE_OBJECT then
      if Prog[I].Arg1 = TypeID then
      begin
        result := I;
        Exit;
      end;
  result := Card;
end;

procedure TPAXCode.RemoveNops;
begin
  if Card = 0 then
    Exit;
  while Prog[Card].Op = OP_NOP do
  begin
    Dec(Card);
    if Card = 0 then
      Exit;
  end;
end;

procedure TPAXCode.ReplaceID(ID1, ID2: Integer);
var
  I: Integer;
begin
  for I:=1 to Card do
    with Prog[I] do
      if (Op = OP_CALL) or (Op = OP_CREATE_REF) or (Op = OP_BEGIN_WITH) then
      begin
        if Arg1 = ID1 then
          Arg1 := ID2;
      end
      else if OP = OP_EVAL_WITH then
      begin
        if Res = ID1 then
        begin
          Res := 0;
          Op := OP_NOP;
        end;
      end
      else if OP = OP_ASSIGN then
      begin
        if Arg2 = ID1 then
          Arg2 := ID2;
      end;

end;

end.

