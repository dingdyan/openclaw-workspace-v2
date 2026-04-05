////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_EVENT.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////


{$I PaxScript.def}
{$B-}

unit BASE_EVENT;
interface
uses
   Classes,
   TypInfo,
   SysUtils,
   BASE_SYS,
   BASE_CLASS,
   BASE_EXTERN;

type
  TPAXEventHandler = class
  public
    Scripter: Pointer;
    SubID: Integer;
    This: Variant;
    ParamCount: Integer;
    Parameters: array of TVarRec;
    ParamTypes: TStringList;
    _EAX, _EDX, _ECX: Integer;
    _P: Pointer;
    RetSize: Integer;
    DelphiInstance: TObject;
    PropInfo: PPropInfo;

    HostHandler: TMethod;
    OverrideHandlerMode: Integer;

    constructor Create(Scripter: Pointer;
                       pti: PTypeInfo;
                       SubID: Integer;
                       const This: Variant);
    destructor Destroy; override;
    procedure Invoke;
    procedure HandleEvent;
  end;

 TPAXEventHandlerList = class(TList)
   procedure ClearHandlers;
   destructor Destroy; override;
 end;

implementation

uses
  BASE_SCRIPTER,
  BASE_CALL;

destructor TPAXEventHandlerList.Destroy;
begin
  ClearHandlers;
  inherited;
end;

procedure TPAXEventHandlerList.ClearHandlers;
var
  I: Integer;
  M: TMethod;
  H: TPAXEventHandler;
begin
  M.Code := nil;
  M.Data := nil;
  for I:=0 to Count - 1 do
  begin
    H := TPAXEventHandler(Items[I]);

    if IsDelphiObject(H.DelphiInstance) then
      SetMethodProp(H.DelphiInstance, H.PropInfo, M);

    H.Free;
  end;
  Clear;
end;

constructor TPAXEventHandler.Create(Scripter: Pointer;
                                    pti: PTypeInfo;
                                    SubID: Integer;
                                    const This: Variant);
type
  TParamData = record
    Flags: TParamFlags;
    ParamName, TypeName: ShortString;
  end;
  PParamData = ^TParamData;
var
  ptd: PTypeData;
  PParam: PParamData;
  PTypeString: ^ShortString;
  I: Integer;
begin
  inherited Create;

  OverrideHandlerMode := 0;

  with TPAXBaseScripter(Scripter) do
  begin
    if SymbolTable.Kind[SubID] = KindTYPE then
      while SymbolTable.Kind[SubID] <> KindSUB do
        Inc(SubID);
  end;

  Self.SubID := SubID;
  Self.Scripter := Scripter;
  Self.This := This;

  ptd := GetTypeData(pti);
  ParamCount := ptd^.ParamCount;
  SetLength(Parameters, ParamCount);
  ParamTypes := TStringList.Create;

  PParam := PParamData(@(ptd^.ParamList));
  for I:=0 to ParamCount - 1 do
  begin
    PTypeString := ShiftPointer(PParam, SizeOf(TParamFlags) + Length(PParam^.ParamName) + 1);
    ParamTypes.Add(PTypeString^);
    PParam := ShiftPointer(PTypeString, Length(PTypeString^) + 1);
  end;
end;

destructor TPAXEventHandler.Destroy;
begin
  ParamTypes.Free;
  inherited Destroy;
end;

var
  PThis: PVariant;

procedure TPAXEventHandler.Invoke;

type
  PWord = ^Word;
  PShortInt = ^ShortInt;
  PSmallInt = ^SmallInt;
  PByte = ^Byte;

procedure Adjust(var Val: Integer);
type
  T = array[1..4] of Byte;
begin
  T(Val)[2] := 0;
  T(Val)[3] := 0;
  T(Val)[4] := 0;
end;

var
  I, J, Index: Integer;
  S: String;
  R, V: Variant;
  SO: TPAXScriptObject;
  ClassRec: TPAXClassRec;
  RTTITypeDefinition: TPAXRTTITypeDefinition;
  pti: PTypeInfo;
  ptd: PTypeData;
  SZ: Integer;
  Variants: array[0..30] of Variant;
  IsDelphiObject: Boolean;
  TypeID, ParamID: Integer;
  ByRef: Boolean;

  Ptrs: array[0..30] of Pointer;
  CreatedRecords: TList;

  Pointers: array of Pointer;
  Types, ExtraTypes, Sizes: array of Integer;
  ByRefs: array of Boolean;
  Integers: array[0..30] of Integer;

  InstanceClassRec: TPAXClassRec;
begin
  if not TPAXBaseScripter(Scripter).AllowedEvents then
    Exit;

  CreatedRecords := TList.Create;
  try
    SetLength(Pointers, ParamCount + 1);
    SetLength(Types, ParamCount + 1);
    SetLength(ExtraTypes, ParamCount + 1);
    SetLength(Sizes, ParamCount + 1);
    SetLength(ByRefs, ParamCount + 1);
    for I:=0 to ParamCount do
    begin
      Types[I] := typeCLASS;
      ExtraTypes[I] := 0;
      Sizes[I] := 4;
      Pointers[I] := Self;
    end;
    Types[ParamCount] := 0;

    SZ := 4;
    RetSize := 0;
    _P := ShiftPointer(_P, SZ*(ParamCount - 2));
    SetLength(Parameters, ParamCount);

    if ParamCount > 2 then
    case ParamCount - 2 of
      1: RetSize := 4;
      2: RetSize := 8;
      3: RetSize := 12;
      4: RetSize := 16;
      5: RetSize := 20;
      6: RetSize := 24;
      7: RetSize := 28;
    else
      raise Exception.Create('Too many parameters in event call - scripter limitation');
    end;

    for I:=0 to ParamCount - 1 do
    begin
      with TPAXBaseScripter(Scripter) do
      begin
        ParamID := SymbolTable.GetParamID(SubID, I + 1);
        ByRef := SymbolTable.ByRef[ParamID] = 1;

        ByRefs[I] := ByRef;
      end;

      if ByRef then
        case I of
          0:
          begin
            J := _EDX;
            Ptrs[I + 1] := Pointer(J);
            J := Integer(Ptrs[I + 1]^);
          end;
          1:
          begin
            J := _ECX;
            Ptrs[I + 1] := Pointer(J);
            J := Integer(Ptrs[I + 1]^);
          end;
        else
          begin
            // Set up the variable out of the stack
            J := Integer(_P^);
            Ptrs[I + 1] := Pointer(J);
            J := Integer(Ptrs[I + 1]^);

            // Shift the pointer so we get the right spot next time...
            _P := ShiftPointer(_P, -SZ);
            SZ := 4;
          end;
        end
      else
        case I of
          0: J := _EDX;
          1: J := _ECX;
        else
          begin
            J := Integer(_P^);
            _P := ShiftPointer(_P, -SZ);
            SZ := 4;
          end;
        end;

      S := ParamTypes[I];
      ClassRec := TPAXBaseScripter(Scripter).ClassList.FindClassByName(S);

      IsDelphiObject := ClassRec <> nil;
      if StrEql(S, 'Boolean') or StrEql(S, 'String') then
        IsDelphiObject := false;

      if IsDelphiObject then
        IsDelphiObject := ClassRec.ck in [ckClass];

      if (Assigned(ClassRec)) and (ClassRec.ck = ckStructure)
      then begin
        SO := ClassRec.CreateScriptObject;
        Parameters[I].VType := vtObject;
        Parameters[I].VObject := SO;

        if (ByRef)
        then begin
          SO.ExtraPtr := Ptrs[I + 1];  // We're pointing *right* at the structure, not a reference to it...  J's not.
          SO.ExternalExtraPtr := TRUE; // We don't want to free the memory ourselves...
        end
        else begin
          // OK, we need to create some new memory - otherwise we'll be pointing at the existing one...
          SO.ExtraPtr := AllocMem(SO.ExtraPtrSize);
          Move(Pointer(J)^, SO.ExtraPtr^, SO.ExtraPtrSize);
        end;

        CreatedRecords.Add(SO);

        Types[I] := typeRECORD;
        Pointers[I] := SO.ExtraPtr;
      end
      else if (ClassRec <> nil) and ClassRec.isSet then
      begin
        Integers[I] := J;

//        pti := ClassRec.PtiSet;

        Adjust(J);
//        Variants[I] := SetToVariantArray(J, pti);
        Variants[I] := ByteSetToPaxArray(TByteSet(J), Scripter);

        Parameters[I].VType := vtVariant;
        Parameters[I].VVariant := @Variants[I];

        Types[I] := typeSET;
        Pointers[I] := @ Integers[I];
      end
      else if (ClassRec <> nil) and (ClassRec.ck = ckInterface) then
      begin
        SO := InterfaceToScriptObject(IUnknown(J), Scripter, S);

        Parameters[I].VType := vtObject;
        Parameters[I].VObject := SO;

        Types[I] := typeCLASS;
        Pointers[I] := @ SO.Instance;
      end
      else if (IsDelphiObject)
      then begin
        SO := nil;
        Index := TPAXBaseScripter(Scripter).ScriptObjectList.IndexOfDelphiObject(TObject(J));
        if Index = -1 then
        begin
          if J = 0 then
          begin
            Integers[I] := 0;
            Parameters[I].VType := vtObject;
            Parameters[I].VObject := nil;

            Types[I] := typeCLASS;
            Pointers[I] := @ Integers[I];

            continue;
          end
          else
          begin

            InstanceClassRec :=
              TPaxBaseScripter(Scripter).ClassList.FindClassByName(TObject(J).ClassName);
            if InstanceClassRec = nil then
              InstanceClassRec := ClassRec;
            SO := InstanceClassRec.CreateScriptObject;
            SO.Instance := TObject(j);
{
            SO := ClassRec.CreateScriptObject;
            SO.Instance := TObject(J);
}
          end;
        end
        else begin
          SO := TPAXScriptObject(TPAXBaseScripter(Scripter).ScriptObjectList.PaxObjects[Index]);
        end;

        Parameters[I].VType := vtObject;
        Parameters[I].VObject := SO;

        Types[I] := typeCLASS;
        Pointers[I] := @ SO.Instance;
      end
      else
      begin
        RTTITypeDefinition := DefinitionList.FindRTTITypeDefByName(S);
        if RTTITypeDefinition <> nil then
        begin
          pti := RTTITypeDefinition.pti;
          case pti^.Kind of
            tkEnumeration:
            begin
              Integers[I] := J;

              Adjust(J);
              ptd := GetTypeData(pti);
{$ifndef fp}
              if ptd^.BaseType^ = TypeInfo(Boolean) then
              begin
                Parameters[I].VType := vtBoolean;
                if J = 0 then
                  Parameters[I].VBoolean := false
                else
                  Parameters[I].VBoolean := true;

                Types[I] := typeBOOLEAN;
                Pointers[I] := @ Parameters[I].VBoolean;
              end
              else
{$endif}
              begin
//                Parameters[I].VType := vtAnsiString;
//                Parameters[I].VAnsiString := Pointer(AnsiString(GetEnumName(pti, J)));

                Parameters[I].VType := vtInteger;
                Parameters[I].VInteger := J;

                Types[I] := typeENUM;
                Pointers[I] := @ Integers[I];
              end;
            end;
            tkSet:
            begin
              Integers[I] := J;

              Adjust(J);
              Variants[I] := SetToVariantArray(J, pti);
              Parameters[I].VType := vtVariant;
              Parameters[I].VVariant := @Variants[I];

              Types[I] := typeSET;
              Pointers[I] := @ Integers[I];
            end;

            //--jgv 20061012
            tkChar:
            begin
              Adjust(J);
              Parameters[I].VType := vtInteger;
              Parameters[I].VType := vtChar;
              Parameters[I].VInteger := J;

              Types[I] := typeCHAR;
              Pointers[I] := @ Parameters[I].VInteger;
            end;

            else
            begin
              Parameters[I].VType := vtInteger;
              Parameters[I].VInteger := J;

              Types[I] := typeINTEGER;
              Pointers[I] := @ Parameters[I].VInteger;
            end;
          end;
        end
        else
        begin
          if StrEql(ParamTypes[I], 'String') then
          begin
            Parameters[I].VType := vtAnsiString;
            Parameters[I].VAnsiString := Pointer(J);

            Types[I] := typeSTRING;
            Pointers[I] := Parameters[I].VAnsiString;
          end
          else if StrEql(ParamTypes[I], 'WideString') then
          begin
            Parameters[I].VType := vtWideString;
            Parameters[I].VWideString := Pointer(J);

            Types[I] := typeWIDESTRING;
            Pointers[I] := Parameters[I].VWideString;
          end
          else if StrEql(ParamTypes[I], 'Boolean') then
          begin
            Parameters[I].VType := vtBoolean;
            Parameters[I].VBoolean := Boolean(Byte(J));

            Types[I] := typeBOOLEAN;
            Pointers[I] := @ Parameters[I].VBoolean;
          end
          else if StrEql(ParamTypes[I], 'Word') then
          begin
            Parameters[I].VType := vtInteger;
            Parameters[I].VInteger := J;

            Types[I] := typeWORD;
            Pointers[I] := @ Parameters[I].VInteger;
          end
          else if StrEql(ParamTypes[I], 'Char') then
          begin
            Adjust(J);
            Parameters[I].VType := vtInteger;
            Parameters[I].VInteger := J;

            Types[I] := typeCHAR;
            Pointers[I] := @ Parameters[I].VInteger;
          end
          else if StrEql(ParamTypes[I], 'Variant') then
          begin
            Parameters[I].VType := vtVariant;
            if ByRef then
              PVariant(Parameters[I].VVariant) := PVariant(Ptrs[I + 1])
            else
              PVariant(Parameters[I].VVariant) := PVariant(J);

            Types[I] := typeVARIANT;
            Pointers[I] := Parameters[I].VVariant;
          end
          else
          begin
            Parameters[I].VType := vtInteger;
            Parameters[I].VInteger := J;

            Types[I] := typeINTEGER;
            Pointers[I] := @ Parameters[I].VInteger;
          end;
        end;
      end;
    end;

    if OverrideHandlerMode = 1 then
      if HostHandler.Code <> nil then
        BASE_CALL.Call(HostHandler.Code,
                       nil,
                       HostHandler.Data,
                       false,
                       _ccRegister,
                       Pointers,
                       Types,
                       ExtraTypes,
                       ByRefs,
                       Sizes,
                       false);

    PThis := @ This;

    R := TPAXBaseScripter(Scripter).CallMethod(SubID, This, Parameters, true);

    with TPAXBaseScripter(Scripter) do
    begin
      for I:=1 to SymbolTable.Count[SubID] do
      begin
        ParamID := SymbolTable.GetParamID(SubID, I);
        TypeID := SymbolTable.PType[ParamID];
        if SymbolTable.ByRef[ParamID] = 1 then
        begin
          V := SymbolTable.VariantValue[ParamID];
          if TypeID = typeBOOLEAN then
            PBoolean(Ptrs[I])^ := V
          else if TypeID = typeINTEGER then
          begin
            PInteger(Ptrs[I])^ := V;
          end
          else if TypeID = typeWORD then
            PWord(Ptrs[I])^ := V
          else if TypeID = typeSHORTINT then
            PShortInt(Ptrs[I])^ := V
          else if TypeID = typeSMALLINT then
            PSmallInt(Ptrs[I])^ := V
          else if TypeID = typeBYTE then
            PByte(Ptrs[I])^ := V
          //-- jgv
          else if TypeID = typeCHAR then begin // jgv
            s := v;
            PByte(Ptrs[i])^ := Byte(char(s[1]));
          end
          else if TypeID = typeDOUBLE then
          begin
            PDouble(Ptrs[I])^ := V;
          end
          else if TypeID = typeEXTENDED then
            PExtended(Ptrs[I])^ := V
          else if TypeID = typeSTRING then
          begin
            PString(Ptrs[I])^ := V;
          end
          else if TypeID = typeWIDESTRING then
          begin
            PWideString(Ptrs[I])^ := V;
          end
          else if TypeID = typeVARIANT then
          begin
            PVariant(Ptrs[I])^ := V;
          end
          else if (TypeID < 0) then
          begin
             if isObject(V) then
             begin
               PInteger(Ptrs[I])^ := Integer(VariantToScriptObject(V).Instance);
               VariantToScriptObject(V).RefCount := -1;

               continue;
             end;

            // It's a structure - we're already directly modifying it.  Don't write anything, but we do need to
            // clean up after ourselves..
            ClassRec := ClassList.FindClass(TypeID);
            if ClassRec <> nil then
            begin
              if ClassRec.ck = ckEnum then
                PByte(Ptrs[I])^ := V;
            end;
          end
          else
          begin
            if isObject(V) then
            begin
              PInteger(Ptrs[I])^ := Integer(VariantToScriptObject(V).Instance);
            end
            else
              PByte(Ptrs[I])^ := V;
          end;
        end;
      end;
    end;

    if OverrideHandlerMode = 2 then
      if HostHandler.Code <> nil then
        BASE_CALL.Call(HostHandler.Code,
                       nil,
                       HostHandler.Data,
                       false,
                       _ccRegister,
                       Pointers,
                       Types,
                       ExtraTypes,
                       ByRefs,
                       Sizes,
                       false);

  finally
    for I:=0 to CreatedRecords.Count - 1 do
    begin
      SO := TPaxScriptObject(CreatedRecords[I]);
      TPAXBaseScripter(SO.Scripter).ScriptObjectList.RemoveObject(SO);
    end;
    // We need to clean up after ourselves!!!
    CreatedRecords.Free;
  end;

  if Assigned(TPAXBaseScripter(Scripter).OnHalt) then
  if TPAXBaseScripter(Scripter).Code.SignHaltGlobal then
  begin
    TPAXBaseScripter(Scripter).OnHalt(TPAXBaseScripter(Scripter).Owner);
  end;
end;

procedure TPAXEventHandler.HandleEvent;
const
  LocalFrameSize = 28;
asm
  mov dword ptr Self._EAX, eax
  mov dword ptr Self._EDX, edx
  mov dword ptr Self._ECX, ecx
  mov dword ptr Self._P, esp

  push ebp
  mov ebp, esp

  sub esp, LocalFrameSize

  mov [ebp-12], ecx
  mov [ebp- 8], edx
  mov [ebp- 4], eax

  push eax
  call Invoke
  pop eax

  mov ecx, Self.RetSize

  mov esp, ebp
  pop ebp

  cmp ecx, 0

  jnz @@Ret4
  ret

@@Ret4:
  cmp ecx, 4
  jnz @@Ret8
  ret 4

@@Ret8:
  cmp ecx, 8
  jnz @@Ret12
  ret 8

@@Ret12:
  cmp ecx, $0c
  jnz @@Ret16
  ret $0c

@@Ret16:
  cmp ecx, $10
  jnz @@Ret20
  ret $10

@@Ret20:
  cmp ecx, $14
  jnz @@Ret24
  ret $14

@@Ret24:
  cmp ecx, $18
  jnz @@Ret28
  ret $18

@@Ret28:
  ret $1C
end;

end.
