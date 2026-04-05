////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: IMP_ActiveX.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////


{$I PaxScript.def}
unit IMP_ActiveX;
interface

{$IFDEF LINUX}
implementation
end.
{$ENDIF}

uses
{$IFDEF VARIANTS}
  Variants,
{$ENDIF}
   Windows,
   ComObj,
   ActiveX,
   BASE_SYS,
   BASE_SCRIPTER,
   BASE_CLASS,
   BASE_EXTERN;

implementation

uses
   SysUtils,
   ComConst;

const
{ Maximum number of dispatch arguments }

  MaxDispArgs = 64; {!!!}

{ Special variant type codes }

  varStrArg = $0048;

{ Parameter type masks }

  atVarMask  = $3F;
  atTypeMask = $7F;
  atByRef    = $80;

{ Call GetIDsOfNames method on the given IDispatch interface }

procedure GetIDsOfNames(const Dispatch: IDispatch; Names: PChar;
  NameCount: Integer; DispIDs: PDispIDList);

  procedure RaiseNameException;
  begin
    raise EOleError.CreateFmt(SNoMethod, [Names]);
  end;

type
  PNamesArray = ^TNamesArray;
  TNamesArray = array[0..0] of PWideChar;
var
  N, SrcLen, DestLen: Integer;
  Src: PChar;
  Dest: PWideChar;
  NameRefs: PNamesArray;
  StackTop: Pointer;
  Temp: Integer;
begin
  Src := Names;
  N := 0;
  asm
    MOV  StackTop, ESP
    MOV  EAX, NameCount
    INC  EAX
    SHL  EAX, 2  // sizeof pointer = 4
    SUB  ESP, EAX
    LEA  EAX, NameRefs
    MOV  [EAX], ESP
  end;
  repeat
    SrcLen := SysUtils.StrLen(Src);
    DestLen := MultiByteToWideChar(0, 0, Src, SrcLen, nil, 0) + 1;
    asm
      MOV  EAX, DestLen
      ADD  EAX, EAX
      ADD  EAX, 3      // round up to 4 byte boundary
      AND  EAX, not 3
      SUB  ESP, EAX
      LEA  EAX, Dest
      MOV  [EAX], ESP
    end;
    if N = 0 then NameRefs[0] := Dest else NameRefs[NameCount - N] := Dest;
    MultiByteToWideChar(0, 0, Src, SrcLen, Dest, DestLen);
    Dest[DestLen-1] := #0;
    Inc(Src, SrcLen+1);
    Inc(N);
  until N = NameCount;
  Temp := Dispatch.GetIDsOfNames(GUID_NULL, NameRefs, NameCount,
    GetThreadLocale, DispIDs);
  if Temp = Integer(DISP_E_UNKNOWNNAME) then RaiseNameException else OleCheck(Temp);
  asm
    MOV  ESP, StackTop
  end;
end;

function HasNames(const Dispatch: IDispatch; Names: PChar;
  NameCount: Integer; DispIDs: PDispIDList): Boolean;
type
  PNamesArray = ^TNamesArray;
  TNamesArray = array[0..0] of PWideChar;
var
  N, SrcLen, DestLen: Integer;
  Src: PChar;
  Dest: PWideChar;
  NameRefs: PNamesArray;
  StackTop: Pointer;
  Temp: Integer;
begin
  result := true;

  Src := Names;
  N := 0;
  asm
    MOV  StackTop, ESP
    MOV  EAX, NameCount
    INC  EAX
    SHL  EAX, 2  // sizeof pointer = 4
    SUB  ESP, EAX
    LEA  EAX, NameRefs
    MOV  [EAX], ESP
  end;
  repeat
    SrcLen := SysUtils.StrLen(Src);
    DestLen := MultiByteToWideChar(0, 0, Src, SrcLen, nil, 0) + 1;
    asm
      MOV  EAX, DestLen
      ADD  EAX, EAX
      ADD  EAX, 3      // round up to 4 byte boundary
      AND  EAX, not 3
      SUB  ESP, EAX
      LEA  EAX, Dest
      MOV  [EAX], ESP
    end;
    if N = 0 then NameRefs[0] := Dest else NameRefs[NameCount - N] := Dest;
    MultiByteToWideChar(0, 0, Src, SrcLen, Dest, DestLen);
    Dest[DestLen-1] := #0;
    Inc(Src, SrcLen+1);
    Inc(N);
  until N = NameCount;
  Temp := Dispatch.GetIDsOfNames(GUID_NULL, NameRefs, NameCount,
    GetThreadLocale, DispIDs);

  if Temp = Integer(DISP_E_UNKNOWNNAME) then
    result := false
  else
    OleCheck(Temp);

  asm
    MOV  ESP, StackTop
  end;
end;

function DispHasNames(const Instance: Variant;
  CallDesc: PCallDesc): Boolean;
var
  Dispatch: Pointer;
  DispIDs: array[0..MaxDispArgs - 1] of Integer;
begin
  if TVarData(Instance).VType = varDispatch then
    Dispatch := TVarData(Instance).VDispatch
  else if TVarData(Instance).VType = (varDispatch or varByRef) then
    Dispatch := Pointer(TVarData(Instance).VPointer^)
  else
  begin
    result := false;
    Exit;
  end;

  result := HasNames(IDispatch(Dispatch), @CallDesc^.ArgTypes[CallDesc^.ArgCount],
    CallDesc^.NamedArgCount + 1, @DispIDs);
end;

function DispatchHasNames(ModeCall: Byte; const Instance: Variant; const Name: String;
                          P: Variant; ParamsCount: Integer): Boolean;
var
  CallDesc: TCallDesc;
  S: ShortString;
  I, VCount: Integer;
  VT: Byte;
begin
  FillChar(CallDesc, SizeOf(TCallDesc ), 0);
  S := Name;

  with CallDesc do
  begin
    CallType := ModeCall;
    NamedArgCount := 0;

    ArgCount := 0;
    for I := 1 to ParamsCount do
    begin
      VT := TVarData(P[I]).VType;
      VCount := VarArrayDimCount(P[I]);
      ArgTypes[ArgCount] := VT;

      if VT = VarOleStr then
        ArgTypes[ArgCount] := VarStrArg
      else if (VT = VarVariant) or (VT = VarDispatch) or (VCount > 0) then
        ArgTypes[ArgCount] := VarVariant;

      Inc(ArgCount);
    end;
    Move(S[1], ArgTypes[ArgCount], Length(S));
  end;

  result := DispHasNames(Instance, @CallDesc);
end;


{ Call Invoke method on the given IDispatch interface using the given
  call descriptor, dispatch IDs, parameters, and result }

procedure MyDispatchInvoke(const Dispatch: IDispatch; CallDesc: PCallDesc;
  DispIDs: PDispIDList; Params: Pointer; Result: PVariant);
type
  PVarArg = ^TVarArg;
  TVarArg = array[0..3] of DWORD;
  TStringDesc = record
    BStr: PWideChar;
    PStr: PString;
  end;
var
  I, J, K, ArgType, ArgCount, StrCount, DispID, InvKind, Status: Integer;
  VarFlag: Byte;
  ParamPtr: ^Integer;
  ArgPtr, VarPtr: PVarArg;
  DispParams: TDispParams;
  ExcepInfo: TExcepInfo;
  Strings: array[0..MaxDispArgs - 1] of TStringDesc;
  Args: array[0..MaxDispArgs - 1] of TVarArg;
begin

  StrCount := 0;
  try
    ArgCount := CallDesc^.ArgCount;
    if ArgCount <> 0 then
    begin
      ParamPtr := Params;
      ArgPtr := @Args[ArgCount];
      I := 0;
      repeat
        Dec(Integer(ArgPtr), SizeOf(TVarData));

        ArgType := CallDesc^.ArgTypes[I]; { and atTypeMask;  }
        VarFlag := 0; { CallDesc^.ArgTypes[I] and atByRef;  }

        if ArgType = varError then
        begin
          ArgPtr^[0] := varError;
//          ArgPtr^[2] := DISP_E_PARAMNOTFOUND;
        end else
        begin
          if ArgType = varStrArg then
          begin
            with Strings[StrCount] do
              if VarFlag <> 0 then
              begin
                BStr := StringToOleStr(PString(ParamPtr^)^);
                PStr := PString(ParamPtr^);
                ArgPtr^[0] := varOleStr or varByRef;
                ArgPtr^[2] := Integer(@BStr);
              end else
              begin
                BStr := StringToOleStr(PString(ParamPtr)^);
                PStr := nil;
                ArgPtr^[0] := varOleStr;
                ArgPtr^[2] := Integer(BStr);
              end;
            Inc(StrCount);
          end else
          if VarFlag <> 0 then
          begin
            if (ArgType = varVariant) and
              (PVarData(ParamPtr^)^.VType = varString) then
              VarCast(PVariant(ParamPtr^)^, PVariant(ParamPtr^)^, varOleStr);
            ArgPtr^[0] := ArgType or varByRef;
            ArgPtr^[2] := ParamPtr^;
          end else
          if ArgType = varVariant then
          begin
            if PVarData(ParamPtr)^.VType = varString then
            begin
              with Strings[StrCount] do
              begin
                BStr := StringToOleStr(string(PVarData(ParamPtr^)^.VString));
                PStr := nil;
                ArgPtr^[0] := varOleStr;
                ArgPtr^[2] := Integer(BStr);
              end;
              Inc(StrCount);
            end else
            begin
              VarPtr := PVarArg(ParamPtr);

              ArgPtr^[0] := VarPtr^[0];
              ArgPtr^[1] := VarPtr^[1];
              ArgPtr^[2] := VarPtr^[2];
              ArgPtr^[3] := VarPtr^[3];
              Inc(Integer(ParamPtr), 12);
            end;
          end else
          begin
            ArgPtr^[0] := ArgType;
            ArgPtr^[2] := ParamPtr^;
            if (ArgType >= varDouble) and (ArgType <= varDate) then
            begin
              Inc(Integer(ParamPtr), 4);
              ArgPtr^[3] := ParamPtr^;
            end;
          end;
          Inc(Integer(ParamPtr), 4);
        end;
        Inc(I);
      until I = ArgCount;
    end;
    DispParams.rgvarg := @Args;
    DispParams.rgdispidNamedArgs := @DispIDs[1];
    DispParams.cArgs := ArgCount;
    DispParams.cNamedArgs := CallDesc^.NamedArgCount;
    DispID := DispIDs[0];
    InvKind := CallDesc^.CallType;
    if InvKind = DISPATCH_PROPERTYPUT then
    begin
      if Args[0][0] and varTypeMask = varDispatch then
        InvKind := DISPATCH_PROPERTYPUTREF;
      DispIDs[0] := DISPID_PROPERTYPUT;
      Dec(Integer(DispParams.rgdispidNamedArgs), SizeOf(Integer));
      Inc(DispParams.cNamedArgs);
    end else
    begin

      if (InvKind = DISPATCH_METHOD) and (ArgCount = 0) and (Result <> nil) then
        InvKind := DISPATCH_METHOD or DISPATCH_PROPERTYGET;

    end;
    Status := Dispatch.Invoke(DispID, GUID_NULL, 0, InvKind, DispParams,
      Result, @ExcepInfo, nil);
    if Status <> 0 then DispatchInvokeError(Status, ExcepInfo);
    J := StrCount;
    while J <> 0 do
    begin
      Dec(J);
      with Strings[J] do
        if PStr <> nil then OleStrToStrVar(BStr, PStr^);
    end;
  finally
    K := StrCount;
    while K <> 0 do
    begin
      Dec(K);
      SysFreeString(Strings[K].BStr);
    end;
  end;
end;

{ Call GetIDsOfNames method on the given IDispatch interface }

{ Central call dispatcher }

procedure MyVarDispInvoke(Result: PVariant; const Instance: Variant;
  CallDesc : PCallDesc; Params: Pointer); cdecl;

  procedure RaiseException;
  begin
    raise EOleError.Create(SVarNotObject);
  end;

var
  Dispatch: Pointer;
  DispIDs: array[0..MaxDispArgs - 1] of Integer;
begin

  if TVarData(Instance).VType = varDispatch then
    Dispatch := TVarData(Instance).VDispatch
  else if TVarData(Instance).VType = (varDispatch or varByRef) then
    Dispatch := Pointer(TVarData(Instance).VPointer^)
  else
    RaiseException;

  GetIDsOfNames(IDispatch(Dispatch), @CallDesc^.ArgTypes[CallDesc^.ArgCount],
    CallDesc^.NamedArgCount + 1, @DispIDs);

  if Result <> nil then VarClear(Result^);

  MyDispatchInvoke(IDispatch(Dispatch), CallDesc, @DispIDs, Params, Result);
end;


function DispatchProcedure(ModeCall: Byte; const Instance: Variant; const Name: String;
                           const P: Variant; ParamsCount: Integer): Variant;
var
  CallDesc: TCallDesc;
  Params: array[0..100] of LongInt;
  S: ShortString;
  I, K, VCount: Integer;
  VT: Byte;
  D: Double;
  V: Variant;
  SS: array [0..30] of String;
begin
  FillChar(CallDesc, SizeOf(TCallDesc ), 0);
  FillChar(Params, SizeOf(Params), 0);

  S := Name;

  with CallDesc do
  begin
    CallType := ModeCall;
    NamedArgCount := 0;

    ArgCount := 0;
    K := -1;

    for I := 1 to ParamsCount do
    begin
      VT := TVarData(P[I]).VType;
      VCount := VarArrayDimCount(P[I]);

      ArgTypes[ArgCount] := VT;

      if (VT in [VarInteger,VarSmallInt,VarByte]) and (VCount=0) then
      begin
        Inc(K);
        Params[K] := P[I];
      end
      else if   VT = VarError then
      begin
//      Inc(K);
//      Params[K] := P[I];
      end
      else if VT = VarOleStr then
      begin
        ArgTypes[ArgCount] := VarStrArg;
        SS[I] := P[I];
        Inc(K);
        Params[K] := LongInt(SS[I]);
      end
      else if (VT = VarVariant) or (VT = VarDispatch) or (VCount > 0) then
      begin
        ArgTypes[ArgCount] := VarVariant;
        Inc(K);
        V := P[I];
        Move(V, Params[K], SizeOf(Variant));
        Inc(K);
        Inc(K);
        Inc(K);
      end
      else if (VT = VarDouble) or (VT = VarCurrency) then
      begin
        Inc(K);
        D := P[I];
        Move(D, Params[K], SizeOf(Double));
        Inc(K);
      end;

//    ArgTypes[ ArgCount ] := ArgTypes[ ArgCount ]{ or atByRef };
//    ArgTypes[ ArgCount ] := ArgTypes[ ArgCount ] or atTypeMask;

      Inc(ArgCount);
    end;

    Move(S[1], ArgTypes[ArgCount], Length(S));
  end;

  MyVarDispInvoke(@Result, Instance, @CallDesc, @Params);
end;

procedure ActiveXObject_GetProperty(M: TPAXMethodBody);
var
  ParamCount: Integer;
  I: Integer;
  Params: Variant;
  ModeCall: Byte;
  D, V, Value: Variant;
  X: ActiveXObject;
  S: String;
begin
  ParamCount := M.ParamCount;
  Params := VarArrayCreate([1, ParamCount], varVariant);
  for I:=1 to ParamCount do
  begin
    Value := M.Params[I - 1].AsVariant;

    if VarType(Value) = varBoolean then
    begin
      if Value then
        Params[I] := Integer(1)
      else
        Params[I] := Integer(0);
    end
    else if VarType(Value) = varScriptObject then
    begin
      Params[I] := ActiveXObject(VariantToScriptObject(Value).Instance).D;
    end
    else
      Params[I] := Value;
 end;
  ModeCall := DISPATCH_METHOD + DISPATCH_PROPERTYGET;
  D := ActiveXObject(M.Self).D;
  V := DispatchProcedure(ModeCall, D, M.Name, Params, ParamCount);

  with M do
    if VarType(V) = varDispatch then
    begin
      // Make sure the object is properly cast as an IDispatch
      V := IUnknown(V) as IDispatch;
      if (IDispatch(V) <> NIL)
      then
      begin
        X := ActiveXObject.Create(M.Scripter);
        X.D := V;
        result.AsTObject := X;
      end
      else
        result.AsVariant := NULL;
    end
    else if VarType(V) = varOleStr then
    begin
      S := V;
      result.AsVariant := S;
    end
    else if VarType(V) = varEmpty then
    begin
      result.AsVariant := V;
    end
    else if VarType(V) = varNull then
    begin
      result.AsVariant := V;
    end
    else
      result.AsVariant := V;
end;

procedure ActiveXObject_PutProperty(M: TPAXMethodBody);
var
  ParamCount: Integer;
  I: Integer;
  Params: Variant;
  ModeCall: Byte;
  D, Value: Variant;
begin
  ParamCount := M.ParamCount;
  Params := VarArrayCreate([1, ParamCount], varVariant);
  for I:=1 to ParamCount do
  begin
    Value := M.Params[I - 1].AsVariant;

    if VarType(Value) = varBoolean then
    begin
      if Value then
        Params[I] := Integer(1)
      else
        Params[I] := Integer(0);
    end
    else if VarType(Value) = varScriptObject then
    begin
      Params[I] := ActiveXObject(VariantToScriptObject(Value).Instance).D;
    end
    else
      Params[I] := Value;
 end;
  ModeCall := DISPATCH_PROPERTYPUT;
  D := ActiveXObject(M.Self).D;
  DispatchProcedure(ModeCall, D, M.Name, Params, ParamCount);
end;

procedure Create_ActiveXObject(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
  begin
    Self := ActiveXObject.Create(Scripter); //(TPAXBaseScripter(Scripter).ClassList.ActiveXClassRec);
    ActiveXObject(Self).D := CreateOleObject(Params[0].AsString);
  end;
end;

initialization
  CoInitialize(nil);

  with DefinitionList do
  begin
    AddClass2(ActiveXObject, nil, ActiveXObject_GetProperty,
                   ActiveXObject_PutProperty);
    AddMethod4(ActiveXObject, 'New', Create_ActiveXObject, 1);
    AddMethod4(ActiveXObject, 'Create', Create_ActiveXObject, 1);
    AddMethod4(ActiveXObject, 'ActiveXObject', Create_ActiveXObject, 1);
  end;
end.
