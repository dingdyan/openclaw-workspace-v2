////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_CONV.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit BASE_CONV;
interface

uses
{$IFDEF VARIANTS}
  Variants,
{$ENDIF}
  SysUtils,
  BASE_CONSTS,
  BASE_SYS;

function GetVariantValue(Scripter, Address: Pointer; TypeID: Integer;
                         const TypeName: String = ''): Variant;
procedure PutVariantValue(Scripter, Address: Pointer; const AValue: Variant; typeID: Integer);
function DynamicArrayToVariant(Scripter, P: Pointer; const ArrayTypeName: string; ElTypeID: Integer): Variant;
function VariantToDynamicArray(Scripter: Pointer; const V: Variant; ElTypeID: Integer): Pointer;
procedure EraseDynamicArray(Scripter, P: Pointer; ElTypeID: Integer);
function ToCurrency(const V: Variant): Currency;

implementation

uses
  BASE_CLASS, BASE_EXTERN, BASE_SCRIPTER;

function GetVariantValue(Scripter, Address: Pointer; TypeID: Integer;
                         const TypeName: String = ''): Variant;
var
  Instance: TObject;
  SO: TPaxScriptObject;
  S: TByteSet;
  ClassRec: TPaxClassRec;
  Dbl: Double;
begin
  case TypeID of
    typeVARIANT: result := Variant(Address^);
    typeENUM:
      result := Byte(Address^);
    typeOLEVARIANT: result := Variant(Address^);
    typeBYTE: result := Integer(Byte(Address^));
    typeCHAR: result := Char(Address^);
    typeBOOLEAN: result := Boolean(Address^);
    typeWORDBOOL: result := WordBool(Address^);
    typeLONGBOOL: result := LongBool(Address^);
    typeINTEGER: result := Integer(Address^);
    typeCARDINAL: result := Integer(Cardinal(Address^));
    typePOINTER: result := Integer(Address^);
    typeDOUBLE: result := Double(Address^);
    typeSTRING: result := String(Address^);
    typePCHAR: result := String(Address^);
    typeWORD: result := Integer(Word(Address^));
    typeSHORTINT: result := Integer(ShortInt(Address^));
    typeSMALLINT: result := Integer(SmallInt(Address^));
    typeINT64: result := Integer(Int64(Address^));
    typeSINGLE:  begin Dbl := Single(Address^); result := Dbl; end;
    typeCURRENCY: result := Double(Currency(Address^));
    typeCOMP: result := Double(Comp(Address^));
//  typeREAL48: result := Real48(Address^);
    typeEXTENDED: begin Dbl := Extended(Address^); result := Dbl; end;
    typeSHORTSTRING: result := ShortString(Address^);
    typeWIDECHAR: result := WideChar(Address^);
    typePWIDECHAR: result := WideChar(PWideChar(Address^)^);
    typeWIDESTRING: result := WideString(Address^);

    typeSET: if Assigned(Scripter) then
    begin
      S := TByteSet(Address^);
      result := ByteSetToPaxArray(S, Scripter);
    end;

    typeRECORD:
    begin
      ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(TypeName);
      if ClassRec = nil then
        raise TPaxScriptFailure(Format(errClassNotRegistered, [TypeName]));
      SO := ClassRec.CreateScriptObject;
      SO.ExtraPtr := Address;
      SO.ExternalExtraPtr := true;
      result := ScriptObjectToVariant(SO);
    end;

    typeARRAY:
    begin
      ClassRec := TPaxBaseScripter(Scripter).ClassList.FindClassByName(TypeName);
      if ClassRec = nil then
        raise TPaxScriptFailure(Format(errClassNotRegistered, [TypeName]));

      SO := ClassRec.CreateScriptObject;
      SO.Instance := SO;
      SO.ExtraPtr := Pointer(Address^);
      SO.ExternalExtraPtr := true;
      result := ScriptObjectToVariant(SO);
    end;

    typeCLASS:
    begin
      if not Assigned(Scripter) then
        Exit;
      Instance := TObject(Address^);

      if Assigned(Instance) then
      begin
        SO := DelphiInstanceToScriptObject(Instance, Scripter);
        result := ScriptObjectToVariant(SO);
      end
      else
        result := Variant(Address^);
    end;
  else
  begin
    Instance := TObject(Address^);

    if Assigned(Instance) then
    begin
      SO := DelphiInstanceToScriptObject(Instance, Scripter);
      result := ScriptObjectToVariant(SO);
    end
    else
      result := Variant(Address^);
  end
  end;
end;

procedure PutVariantValue(Scripter, Address: Pointer; const AValue: Variant; typeID: Integer);
var
  S: String;
  WS: WideString;
  VT, L: Integer;
  SS: ShortString;
  SO: TPaxScriptObject;
begin
  case TypeID of
    typeVARIANT: Variant(Address^) := AValue;
    typeOLEVARIANT: Variant(Address^) := AValue;
    typeBYTE: Byte(Address^) := AValue;
    typeENUM: Byte(Address^) := AValue;
    typeCHAR:
      begin
        S := AValue;
        Char(Address^) := S[1];
      end;
    typeBOOLEAN: Boolean(Address^) := AValue;
    typeWORDBOOL: WordBool(Address^) := AValue;
    typeLONGBOOL: LongBool(Address^) := AValue;
    typeINTEGER: Integer(Address^) := AValue;
    typeCARDINAL: Cardinal(Address^) := AValue;
    typePOINTER: Integer(Address^) := AValue;
    typeDOUBLE: Double(Address^) := AValue;
    typeSTRING: String(Address^) := AValue;
    typePCHAR: String(Address^) := AValue;
    typeWORD: Word(Address^) := AValue;
    typeSHORTINT: ShortInt(Address^) := AValue;
    typeSMALLINT: SmallInt(Address^) := AValue;
{$IFDEF VARIANTS}
    typeINT64: Int64(Address^) := varAsType(aValue, varInt64);
{$ELSE}
    typeINT64: Int64(Address^) := Integer(aValue);
{$ENDIF}
    typeSINGLE: Single(Address^) := AValue;
    typeCURRENCY: Currency(Address^) := AValue;
    typeCOMP: Comp(Address^) := AValue;
//    typeREAL48: Real48(Address^) := AValue;
    typeEXTENDED: Extended(Address^) := AValue;
    typeSHORTSTRING: ShortString(Address^) := AValue;
    typeWIDECHAR:
      begin
        WS := AValue;
        WideChar(Address^) := WS[1];
      end;
    typePWIDECHAR:
      begin
        WS := AValue;
        WideChar(PWideChar(Address^)^) := WS[1];
      end;
    typeWIDESTRING: WideString(Address^) := AValue;
    typeTVarRec:
    begin
      VT := VarType(AValue);
      case VT of
        varInteger:
          begin
            TVarRec(Address^).VType := vtInteger;
            TVarRec(Address^).VInteger := AValue;
          end;
        varDouble, varSingle:
          begin
            TVarRec(Address^).VType := vtExtended;
            GetMem(TVarRec(Address^).VExtended, SizeOf(Extended));
            TVarRec(Address^).VExtended^ := AValue;
          end;
        varString, VarOleStr:
          begin
           SS := AValue;
           L := Length(SS);
           TVarRec(Address^).VType := vtString;
           GetMem(TVarRec(Address^).VString, L + 1);
           Move(SS[1], TVarRec(Address^).VString^[1], L);
           TVarRec(Address^).VString^[0] := Chr(L);
          end;
        varBoolean:
          begin
           TVarRec(Address^).VType := vtBoolean;
           TVarRec(Address^).VBoolean := AValue;
          end;
      end;
    end;

    typeSET: if Assigned(Scripter) then
    begin
      TByteSet(Address^) := PaxArrayToByteSet(AValue);
    end;

    typeCLASS:
    begin
      if not Assigned(Scripter) then
        Exit;

      SO := VariantToScriptObject(AValue);
      TObject(Address^) := SO.Instance;
    end;
  else
  begin
    SO := VariantToScriptObject(AValue);
    TObject(Address^) := SO.Instance;
  end
  end;
end;

function DynamicArrayToVariant(Scripter, P: Pointer; const ArrayTypeName: string; ElTypeID: Integer): Variant;
var
  Q: Pointer;
  I, L, ElSize: Integer;
  SO: TPaxScriptObject;
  ClassRec: TPaxClassRec;
begin
  if P = nil then
    Exit;

  Q := ShiftPointer(P, - SizeOf(Integer));
  L := Integer(Q^);
  ElSize := PaxTypes.GetSize(ElTypeID);

  ClassRec := TPaxBaseScripter(scripter).ClassList.FindClassByName(ArrayTypeName);

  SO := ClassRec.CreateScriptObject();
  SO.Instance := SO;

  Q := AllocMem(2*SizeOf(Integer) +  L * ElSize);
  Integer(Q^) := 1;
  Q := ShiftPointer(Q, SizeOf(Integer));
  Integer(Q^) := L;
  Q := ShiftPointer(Q, SizeOf(Integer));
  SO.ExtraPtr := Q;
  SO.ExtraPtrSize := 2*SizeOf(Integer) +  L * ElSize;

  for I:=0 to L - 1 do
  begin
    case ElTypeId of
      typeCLASS, typeCLASSREF, typePOINTER, typeINTEGER, typeCARDINAL:
      begin
        Integer(Q^) := Integer(P^);
      end;
      typeDOUBLE:
      begin
        Double(Q^) := Double(P^);
      end;
      typeSINGLE:
      begin
        Single(Q^) := Single(P^);
      end;
      typeEXTENDED:
      begin
        Extended(Q^) := Extended(P^);
      end;
      typeBYTE, typeCHAR, typeBOOLEAN:
      begin
        Byte(Q^) := Byte(P^);
      end;
      typeSTRING:
      begin
        String(Q^) := String(P^);
      end;
      typeINT64:
      begin
        Int64(Q^) := Int64(P^);
      end;
      typeCurrency:
      begin
        Currency(Q^) := Currency(P^);
      end;
      typeVARIANT:
      begin
        Variant(Q^) := Variant(P^);
      end;
    end;
    Q := ShiftPointer(Q, ElSize);
    P := ShiftPointer(P, ElSize);
  end;

  result := ScriptObjectToVariant(SO);
end;

function VariantToDynamicArray(Scripter: Pointer; const V: Variant; ElTypeID: Integer): Pointer;
var
  L, I, ElSize: Integer;
  P: Pointer;
begin
  L := VarArrayHighBound(V, 1) + 1;
  ElSize := PaxTypes.GetSize(ElTypeID);
  result := AllocMem(2*SizeOf(Integer) +  L * ElSize);
  P := ShiftPointer(result, SizeOf(Integer));
  Integer(P^) := L;
  P := ShiftPointer(P, SizeOf(Integer));
  result := P;
  for I:=0 to L - 1 do
  begin
    PutVariantValue(Scripter, P, V[I], ElTypeID);
    P := ShiftPointer(P, ElSize);
  end;
end;

procedure EraseDynamicArray(Scripter, P: Pointer; ElTypeID: Integer);
var
  Q: Pointer;
  I, L, ElSize: Integer;
begin
  if P = nil then
    Exit;

  Q := ShiftPointer(P, - SizeOf(Integer));
  L := Integer(Q^);
  ElSize := PaxTypes.GetSize(ElTypeID);
  case ElTypeID of
    typeSTRING, typeWIDESTRING:
      for I:=0 to L - 1 do
      begin
        PutVariantValue(Scripter, P, '', ElTypeID);
        P := ShiftPointer(P, ElSize);
      end;
    typeVARIANT:
      for I:=0 to L - 1 do
      begin
        VarClear(Variant(P^));
        P := ShiftPointer(P, ElSize);
      end;
    typeOLEVARIANT:
      for I:=0 to L - 1 do
      begin
        VarClear(Variant(P^));
        P := ShiftPointer(P, ElSize);
      end;
    typeTVarRec:
      for I:=0 to L - 1 do
      begin
        case TVarRec(P^).VType of
          vtExtended: FreeMem(TVarRec(P^).VExtended, SizeOf(Extended));
          vtString: FreeMem(TVarRec(P^).VString, Length(TVarRec(P^).VString^) + 1);
        end;
        P := ShiftPointer(P, ElSize);
      end;
  end;
  Q := ShiftPointer(Q, - SizeOf(Integer));
  FreeMem(Q, 2*SizeOf(Integer) +  L * ElSize);
end;

function ToCurrency(const V: Variant): Currency;
begin
  result := V;
end;

end.
