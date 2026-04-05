////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_CALL.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////


{$I PaxScript.def}
unit BASE_CALL;
interface

uses
{$IFDEF VARIANTS}
  Variants,
  VarUtils,
{$ENDIF}
  SysUtils,
  TypInfo,
  BASE_CONSTS,
  BASE_SYS;

procedure Call(CallAddr: Pointer;
               AClass: TClass;
               Instance: TObject;
               IsConstructor: Boolean;
               CallConv: Integer;
               Params: array of Pointer;
               Types: array of Integer;
               ExtraTypes: array of Integer;
               ByRefs: array of Boolean;
               Sizes: array of Integer;
               IsIntf: Boolean);

implementation

procedure Call(CallAddr: Pointer;
               AClass: TClass;
               Instance: TObject;
               IsConstructor: Boolean;
               CallConv: Integer;
               Params: array of Pointer;
               Types: array of Integer;
               ExtraTypes: array of Integer;
               ByRefs: array of Boolean;
               Sizes: array of Integer;
               IsIntf: Boolean);
const
  MAX_STK = 10240;

var
  StkPtr: Pointer;
  ExtStk: array[0..MAX_STK-1] of Char;
  StkAdr: Pointer;
  StkUsage: Integer;
  ResAdr: Pointer;

  RegCount: Integer;
  EAX_, EDX_, ECX_: Integer;
  LTR: Boolean;

procedure PushInt(Value: Integer);
begin
  case RegCount of
    0:
    begin
      Inc(RegCount);
      EAX_ := Value;
    end;
    1: begin
      Inc(RegCount);
      EDX_ := Value;
    end;
    2:
    begin
      Inc(RegCount);
      ECX_ := Value;
    end;
    else
      if (LTR) then
      begin
        Dec(Integer(StkPtr), SizeOf(Integer));
        Integer(StkPtr^) := Value;
      end
      else
      begin
        Integer(StkPtr^) := Value;
        Inc(Integer(StkPtr), SizeOf(Integer));
      end;
  end;
end;

procedure PushSet(Adr: Pointer);
begin
  PushInt(Integer(Adr^));
end;

procedure PushPtr(Value: Pointer);
begin
  PushInt(Integer(Value));
end;

procedure PushRecord(Adr: Pointer; Size: Integer);
var tmpInt: Integer;
begin
 if (CallConv in [_ccCdecl, _ccStdCall, _ccSafeCall]) then
 begin // always push to stack
   Move(Adr^, StkPtr^, Size);
   if (Size mod 4 <> 0) then
     Inc(Size, 4-(Size mod 4)); // extend to multiple of 4
   Inc(Integer(StkPtr), Size);
 end
 else
   if (Size > 4) then  // push address only
     PushPtr(Adr)
   else
   begin               // push record
     tmpInt := 0;
     Move(Adr^, tmpInt, Size);
     PushInt(tmpInt);
   end
end;

procedure PushExtended(const Value: Extended);
begin
 if LTR then
 begin
   Dec(Integer(StkPtr), 12);
   Extended(StkPtr^) := Value;
 end
 else
 begin
   Extended(StkPtr^) := Value;
   Inc(Integer(StkPtr), 12);
 end;
end;

procedure PushDouble(Value: TDouble);
begin
  if LTR then
  begin
    Dec(Integer(StkPtr), SizeOf(TDouble));
    TDouble(StkPtr^) := Value;
  end
  else
  begin
    TDouble(StkPtr^) := Value;
    Inc(Integer(StkPtr), SizeOf(TDouble));
  end;
end;

procedure PushReal48(Value: TReal48);
begin
  if LTR then
  begin
    Dec(Integer(StkPtr), 8);
    TReal48(StkPtr^) := Value;
  end
  else
  begin
    TReal48(StkPtr^) := Value;
    Inc(Integer(StkPtr), 8);
  end;
end;

procedure PushVariant(var V: Variant);
begin
 if (LTR) then
   PushPtr(@V)
 else
 begin
   FillChar(StkPtr^, SizeOf(Variant), 0);
   Variant(StkPtr^) := V;
   Inc(Integer(StkPtr), SizeOf(Variant));
 end
end;

procedure PushSingle(Value: TSingle);
begin
  if LTR then
  begin
    Dec(Integer(StkPtr), SizeOf(TSingle));
    TSingle(StkPtr^) := Value;
  end
  else
  begin
    TSingle(StkPtr^) := Value;
    Inc(Integer(StkPtr), SizeOf(TSingle));
  end;
end;

procedure PushCurrency(Value: TCurrency);
begin
  if LTR then
  begin
    Dec(Integer(StkPtr), SizeOf(TCurrency));
    TCurrency(StkPtr^) := Value;
  end
  else
  begin
    TCurrency(StkPtr^) := Value;
    Inc(Integer(StkPtr), SizeOf(TCurrency));
  end;
end;

procedure PushInt64(Value: TInt64);
begin
  if LTR then
  begin
    Dec(Integer(StkPtr), SizeOf(TInt64));
    TInt64(StkPtr^) := Value;
  end
  else
  begin
    TInt64(StkPtr^) := Value;
    Inc(Integer(StkPtr), SizeOf(TInt64));
  end;
end;

var
  ResType: Integer;
  ResAddress: Pointer;
  ParamCount: Integer;

function WithExtraParam: Boolean;
var
  S: Integer;
begin
  S := Sizes[ParamCount];
  Result := (ResType in [typeSTRING, typeVARIANT, typeSHORTSTRING, typeDYNAMICARRAY,
                         typeWIDESTRING, typeOLEVARIANT, typeINTERFACE])
             or
             ((ResType in [typeRECORD]) and (S > 4))
             or
            (CallConv = _ccSafeCall);
end;

var
  I: Integer;
  CDecl_Call, Reg_Call, Safe_Call: Boolean;
  NeedsExtraParam,
  PushExtraParam: Boolean;
  ResSize: Integer;
  T, IntValue, IntRes, IntRes1, IntRes2, L: Integer;
  P: Pointer;

  DoubleRes: TDouble;
  ExtendedRes: TExtended;
  CompRes: TComp;
  CurrencyRes: TCurrency;
  SingleRes: TSingle;
type
  TDyn = array of Integer;
begin
  ParamCount := Length(Params) - 1;
  ResType := Types[ParamCount];
  ResAddress := Params[ParamCount];
  ResSize := PAXTypes.GetSize(ResType);

  LTR := CallConv in [_ccRegister, _ccPascal];
  if LTR then
    StkPtr := Pointer(Integer(@ExtStk)+MAX_STK)
  else
    StkPtr := @ExtStk;

  CDecl_Call := CallConv = _ccCDecl;
  Reg_Call := CallConv = _ccRegister;
  Safe_Call := CallConv = _ccSafeCall;
  EAX_:= 0;
  EDX_:= 0;
  ECX_:= 0;

  if Reg_Call then
    RegCount := 0
  else
    RegCount := -1;

  if IsConstructor then
  begin
    PushInt(Integer(AClass));
    PushInt(Ord(true));
  end
  else if Instance <> nil then
    PushInt(Integer(Instance))
  else if AClass <> nil then
    PushInt(Integer(AClass));

  for I:=0 to ParamCount - 1 do
  begin
//    if Types[I] = typeRECORD then if Sizes[I] > 4 then
//      ByRefs[I] := true;

    if ByRefs[I] then
    begin
      P := Params[I];
      if ExtraTypes[I] = typeDYNAMICARRAY then
      begin
        L := Length(TDyn(P));
        PushPtr(P);
        PushInt(L - 1);
      end
      else
        PushPtr(P);
    end
    else
    begin
      T := Types[I];
      P := Params[I];

      if ExtraTypes[I] = typeDYNAMICARRAY then
      begin
        L := Length(TDyn(P));
        PushPtr(P);
        PushInt(L - 1);
      end
      else
        case T of
          typeCHAR, typeBYTE, typeINTEGER, typePOINTER, typePCHAR, typeCARDINAL,
          typeWORD, typeSHORTINT, typeSMALLINT, typeINTERFACE,
          typeBOOLEAN, typeWORDBOOL, typeLONGBOOL, typePWIDECHAR,
          typeENUM, typeSUBRANGE, typeCLASS, typeCLASSREF:
          begin
            IntValue := 0;
            Move(P^, IntValue, PAXTypes.GetSize(Types[I]));
            PushInt(IntValue);
          end;
          typeSET:
            PushSet(P);
          typeRECORD:
            PushRecord(P, Sizes[I]);
          typeDOUBLE:
            PushDouble(TDouble(P^));
          typeREAL48:
            PushReal48(TReal48(P^));
          typeCURRENCY:
            PushCurrency(TCurrency(P^));
          typeSHORTSTRING:
            PushPtr(P);
          typeWIDESTRING:
            PushPtr(Pointer(TWideString(P^)));
          typeVOID:
            PushVariant(Variant(P^));
          typeVARIANT:
            PushVariant(Variant(P^));
          typeOLEVARIANT:
            PushVariant(Variant(P^));
          typeSINGLE:
            PushSingle(TSingle(P^));
          typeINT64:
            PushInt64(TInt64(P^));
          typeSTRING:
            PushPtr(Pointer(P^));
          typeEXTENDED:
            PushExtended(TExtended(P^));
          else
            raise Exception.Create(errTypeMismatch);
         end;
     end;
  end;

  if ResType <> 0 then
  begin
    NeedsExtraParam := WithExtraParam;
    PushExtraParam := NeedsExtraParam;
  end
  else
  begin
    NeedsExtraParam := false;
    PushExtraParam := false;
  end;

  if LTR then
  begin
    StkAdr := Pointer(Integer(@ExtStk)+MAX_STK);
    StkUsage := Integer(StkAdr)-Integer(StkPtr);
  end
  else
  begin
    StkAdr := @ExtStk;
    StkUsage := (Integer(StkPtr)-Integer(@ExtStk));
  end;

  if LTR then
    ResAdr := @ExtStk
  else
    ResAdr := StkPtr;

  Integer(ResAdr^) := 0;

  if NeedsExtraParam then
    if Reg_Call then
      case RegCount of
        0:
        begin
          EAX_ := Integer(ResAdr);
          PushExtraParam := false;
        end;
        1:
        begin
          EDX_ := Integer(ResAdr);
          PushExtraParam := false;
        end;
        2:
        begin
          ECX_ := Integer(ResAdr);
          PushExtraParam := false;
        end;
        else
          PushExtraParam := true;
      end
    else if Safe_Call then
    begin
      Integer(StkPtr^) := Integer(ResAdr);
      Inc(StkUsage, SizeOf(Pointer));
      PushExtraParam := false;
    end;

  if IsIntf then
  asm
    push esi
    push edi

    sub esp, StkUsage
    mov edi, esp
    mov esi, StkAdr
    mov ecx, StkUsage
    shr ecx, 2

    cmp LTR, true
    jnz @@RTL

    @@LTR:
    add edi, StkUsage;
    sub edi,4
    sub esi,4
    std
    rep movsd
    cld
    jmp @@ExtraParam

    @@RTL:
    cld
    rep movsd

    @@ExtraParam:
    cmp PushExtraParam, true;
    jnz @@Go
    push ResAdr

    @@GO:
    cmp Reg_Call, true
    jnz @@EXEC
    mov EAX, EAX_
    mov EDX, EDX_
    mov ECX, ECX_

    @@EXEC:

    mov edi, CallAddr
    call dword ptr [edi]

    cmp CDecl_Call, true
    jnz @@Restore
    add esp, StkUsage

    @@Restore:
    pop edi
    pop esi
  end
  else
  asm
    push esi
    push edi
    sub esp, StkUsage
    mov edi, esp
    mov esi, StkAdr
    mov ecx, StkUsage
    shr ecx, 2

    cmp LTR, true
    jnz @@RTL

    @@LTR:
    add edi, StkUsage;
    sub edi,4
    sub esi,4
    std
    rep movsd
    cld
    jmp @@ExtraParam

    @@RTL:
    cld
    rep movsd

    @@ExtraParam:
    cmp PushExtraParam, true;
    jnz @@Go
    push ResAdr

    @@GO:
    cmp Reg_Call, true
    jnz @@EXEC
    mov EAX, EAX_
    mov EDX, EDX_
    mov ECX, ECX_

    @@EXEC:
    call CallAddr
    cmp CDecl_Call, true
    jnz @@Restore
    add esp, StkUsage

    @@Restore:
    pop edi
    pop esi
  end;

  if ResType <> 0 then
  begin
    asm
      mov dword ptr IntRes2, edx

      mov edx, ResType
      cmp edx, typeDOUBLE
      jnz @@PS1
      fstp qword ptr DoubleRes
      jmp @@Done

      @@PS1:
      mov edx, ResType
      cmp edx, typeCOMP
      jnz @@PS2
      fistp qword ptr CompRes

      @@PS2:
      mov edx, ResType
      cmp edx, typeREAL48
      jnz @@PS3
      fstp qword ptr DoubleRes
      jmp @@Done

      @@PS3:
      mov edx, ResType
      cmp edx, typeCURRENCY
      jnz @@PS4
      fistp qword ptr CurrencyRes
      jmp @@Done

      @@PS4:
      mov edx, ResType
      cmp edx, typeSingle
      jnz @@PS5
      fstp dword ptr SingleRes
      jmp @@Done

      @@PS5:
      mov edx, ResType
      cmp edx, typeExtended
      jnz @@PS6
      fstp tbyte ptr ExtendedRes
      jmp @@Done

      @@PS6:
      mov edx, ResType
      cmp edx, typeInt64
      jnz @@PS7
      mov dword ptr IntRes1, eax
      jmp @@Done

      @@PS7:
      cmp ResSize, 4
      jg @@Done
      cmp Safe_Call, true
      jne @@NoSafeCall
      mov eax, ResAdr
      mov eax, [eax]

      @@NoSafeCall:
      mov dword ptr IntRes, eax

      @@Done:
    end;

    case ResType of
      typeBYTE, typeCHAR, typeBOOLEAN, typeWORDBOOL, typeLONGBOOL,
      typeINTEGER, typeSHORTINT, typeSMALLINT, typeCARDINAL, typeWORD,
      typePOINTER, typePCHAR, typePWIDECHAR, typeSUBRANGE,
      typeCLASS, typeCLASSREF:
      begin
        Integer(ResAddress^) := 0;
        Move(IntRes, ResAddress^, ResSize);
      end;
      typeINTERFACE:
      begin
        Integer(ResAddress^) := 0;
  //      IUnknown(ResAddress^) := IUnknown(ResAdr^);
        Move(ResAdr^, ResAddress^, 4);
      end;
      typeENUM:
      begin
        AdjustEnum(IntRes);
        Move(IntRes, ResAddress^, ResSize);
      end;
      typeSET:
      begin
        AdjustEnum(IntRes);
        Move(IntRes, ResAddress^, 4);
      end;
      typeINT64:
      begin
        Move(IntRes1, ResAddress^, SizeOf(Integer));
        P := ShiftPointer(ResAddress, 4);
        Move(IntRes2, P^, SizeOf(Integer));
      end;
      typeDOUBLE, typeREAL48:
        Move(DoubleRes, ResAddress^, ResSize);
      typeEXTENDED:
        Move(ExtendedRes, ResAddress^, ResSize);
      typeCOMP:
        Move(CompRes, ResAddress^, ResSize);
      typeCURRENCY:
        Move(CurrencyRes, ResAddress^, ResSize);
      typeSINGLE:
        Move(SingleRes, ResAddress^, ResSize);
      typeRECORD:
      begin
        if (Sizes[ParamCount] > 4) or (Safe_Call) then
          Move(ResAdr^ , ResAddress^, Sizes[ParamCount])
        else
          Move(IntRes , ResAddress^, Sizes[ParamCount])
      end;
      typeSTRING:
      begin

        Integer(ResAddress^) := 0;
        PString(ResAddress)^ := PString(ResAdr)^;
        PString(ResAdr)^ := '';

{
        P := GetRefCountPtr(PString(ResAddress)^);
        Dec(Integer(P^));
        Move(ResAdr^, ResAddress^, 4);
}
      end;
      typeWIDESTRING:
      begin
        PWideString(ResAddress)^ := PWideString(ResAdr)^;
        PWideString(ResAdr)^ := '';
      end;
      typeVARIANT:
      begin
        FillChar(ResAddress^, ResSize, 0);
        PVariant(ResAddress)^ := PVariant(ResAdr)^;

        T := VarType(PVariant(ResAdr)^);

        if T = varString then
          PVariant(ResAdr)^ := '';

//        Move(ResAdr^, ResAddress^, ResSize);
      end;
      typeDYNAMICARRAY:
        Move(ResAdr^, ResAddress^, SizeOf(Pointer));
      typeSHORTSTRING:
        Move(ResAdr^, ResAddress^, Length(TShortString(ResAdr^)) + 1);
    end;
  end;
end;

end.
