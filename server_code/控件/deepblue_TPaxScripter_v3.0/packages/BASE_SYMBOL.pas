////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_SYMBOL.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////


{$I PaxScript.def}

unit BASE_SYMBOL;

interface

uses
{$IFDEF VARIANTS}
  Variants,
{$ENDIF}
  SysUtils, Classes,

  BASE_CONSTS,
  BASE_SYS, BASE_CLASS;

type
  TPAXSymbolRec = packed record
    Address: Pointer;
    Position: Integer;
    StartPosition: Integer;
    Next: Integer;
    Level: Integer;
    PName: Integer;
    PType: Integer;
    Count: Integer;
    Local: Integer;
    Kind: Integer;
    Module: Integer;
    CallConv: Integer;
    Misc: Integer;
    Owner: Integer;
    TypeNameIndex: Integer;
    Imported: Boolean;
    Rank: ShortInt;
    Global: Boolean;
    JSIndex: Boolean;
    IsVirtual: Boolean;
  end;

  TPAXSymbolTable = class
  private
    Scripter: Pointer;
    Mem: Pointer;
    fCard: Integer;
    StateStack: TPAXStack;
    procedure SetName(I: Integer; const Name: String);
    function GetName(I: Integer): String;
    function GetFullName(I: Integer): String;
    procedure SetNameIndex(I, Value: Integer);
    function GetNameIndex(I: Integer): Integer;
    procedure SetKind(I, AKind: Integer);
    function GetKind(I: Integer): Integer;
    procedure SetCount(I, ACount: Integer);
    function GetCount(I: Integer): Integer;
    procedure SetRank(I, ARank: Integer);
    function GetRank(I: Integer): Integer;
    procedure SetNext(I, Value: Integer);
    function GetNext(I: Integer): Integer;
    procedure SetModule(I, Value: Integer);
    function GetModule(I: Integer): Integer;
    procedure SetPosition(I, Value: Integer);
    function GetStartPosition(I: Integer): Integer;
    procedure SetStartPosition(I, Value: Integer);
    function GetPosition(I: Integer): Integer;
    procedure SetLevel(I: Integer; Value: Integer);
    function GetLevel(I: Integer): Integer;
    procedure SetType(I, AType: Integer);
    function GetType(I: Integer): Integer;
    procedure SetImported(I: Integer; Value: Boolean);
    function GetImported(I: Integer): Boolean;
    procedure SetGlobal(I: Integer; Value: Boolean);
    function GetGlobal(I: Integer): Boolean;
    procedure SetAddr(I: Integer; Address: Pointer);
    function GetAddr(I: Integer): Pointer;
    function GetStrKind(I: Integer): String;
    procedure SetByRef(ParamID: Integer; Value: Integer);
    function GetByRef(ParamID: Integer): Integer;
    function GetStrType(I: Integer): String;
    procedure SetTypeSub(SubID: Integer; Value: TPAXTypeSub);
    function GetTypeSub(SubID: Integer): TPAXTypeSub;
    function GetMemberAccess(RefID: Integer): TPAXMemberAccess;
    procedure SetMemberAccess(RefID: Integer; Value: TPAXMemberAccess);
    procedure SetCallConv(I, Value: Integer);
    function GetCallConv(I: Integer): Integer;
    procedure SetTypeNameIndex(I, Value: Integer);
    function GetTypeNameIndex(I: Integer): Integer;
    procedure SetCard(Value: Integer);
    procedure CheckMem;
    function NameList: TPaxNameList;
    function GetJSIndex(I: Integer): Boolean;
    procedure SetJSIndex(I: Integer; Value: Boolean);
  public
    A: array of TPAXSymbolRec;
    RootNamespaceID: Integer;

    MemBoundVar: Integer;
    MemSize: Integer;
    CreateCard: Integer;
    CreateMemBoundVar: Integer;
    MaxLocalVars: Integer;

    IDfalse: Integer;
    IDtrue: Integer;
    IDundefined: Integer;

    constructor Create(AScripter: Pointer);
    destructor Destroy; override;
    procedure SaveToStream(S: TStream; I1, I2: Integer);
    procedure LoadFromStream(S: TStream;
                             DS: Integer = 0; DP: Integer = 0);
    procedure Reset;
    procedure ResetCompileStage;
    procedure EraseTail(K: Integer);

    procedure InitRunStage;
    procedure ResetRunStage;

    function AllocateVar(I: Integer): Pointer;
    function GetSizeOf(I: Integer): Integer;

    function AppLabel: Integer;

    procedure LinkVariables(SubID: Integer; HasResult: Boolean);
    function GetParamID(SubID: Integer; N: Integer): Integer;
    function GetResultID(SubID: Integer): Integer;
    function GetThisID(SubID: Integer): Integer;
    function GetDllID(SubID: Integer): Integer;
    function GetDllProcID(SubID: Integer): Integer;
    procedure AllocateSub(SubID: Integer);
    function GetSubCount: Integer;
    procedure AllocateSubroutines;
    procedure DeallocateSub(SubID: Integer);
    function IsLocalVar(SubID, ID: Integer): Boolean;
    procedure SetLocal(ID: Integer);
    function IsLocal(ID: Integer): Boolean;
    procedure Erase(I: Integer);
    procedure SaveState;
    procedure RestoreState;
    procedure ReallocateMem(NewSize: Integer);

    function GetStrVal(I: Integer): String;

    function GetAlias(ID: Integer): Variant;
    function GetParamTypeName(SubID, ParamIndex: Integer): String;
    function GetParamName(SubID, ParamIndex: Integer): String;
    function GetTypeName(ID: Integer): String;

    function GetVariant(ID: Integer): Variant;
    procedure ClearVariant(ID: Integer);
    procedure ClearVariantValue(ID: Integer);

    procedure PutVariant(ID: Integer; const Val: Variant);
    function AppVariant(const Val: Variant; HasAddress: Boolean = true): Integer;
    function AppVariantConst(const Val: Variant; Dup: Boolean = false): Integer;
    function GetUserData(ID: Integer): Integer;

    function CodeNumberConst(Val: Variant): Integer;
    function CodeStringConst(const Val: String): Integer;

    function GetMemberRec(RefID: Integer; ma: TPAXMemberAccess): TPAXMemberRec;
    function GetMemberRecEx(RefID: Integer; ma: TPAXMemberAccess;
                            var FoundInBaseClass: Boolean;
                            var SO: TPaxScriptObject): TPAXMemberRec;
    function IsFormalParamID(ID: Integer): Boolean;

    function GetOverloadedSubID(RefID: Integer; ma: TPAXMemberAccess;
                        ParamCount: Integer): Integer;

    procedure SetReference(RefID: Integer; const Base: Variant; ma: TPAXMemberAccess);
    function AppReference(const Base: Variant; ANameIndex: Integer; ma: TPAXMemberAccess): Integer;
    function GetValue(ID: Integer): Variant;
    procedure PutValue(ID: Integer; const Val: Variant);

    function LookUpID(const Name: String; aLevel: Integer; UpCase: Boolean = true): Integer;
    function LookUpSubID(const Name: String; aLevel: Integer; UpCase: Boolean = true): Integer;
    function LookupConstID(const Value: Variant): Integer;

    function IsOutsideMemAddress(A: Pointer): boolean;
    function IsInsideMemAddress(A: Pointer): boolean;
    function IsExternalAddress(A: Pointer): boolean;
    function IsInternalAddress(A: Pointer): boolean;

    procedure IncCard;
    procedure DecCard;
    procedure CheckLength; overload;
    procedure CheckLength(Value: Integer); overload;

    procedure Dump(const FileName: String);
    procedure SetupSubs(StartRecNo: Integer);
    function TypeCast(TypeID: Integer; const Value: Variant): Variant;
    function IsVirtual(SubId: Integer): Boolean;

    function GetAddressEx(ID: Integer): Pointer;
    procedure InitGlobalVars;

    property Name[I: Integer]: String read GetName write SetName;
    property FullName[I: Integer]: String read GetFullName;
    property Kind[I: Integer]: Integer read GetKind write SetKind;
    property Count[I: Integer]: Integer read GetCount write SetCount;
    property Rank[I: Integer]: Integer read GetRank write SetRank;
    property Next[I: Integer]: Integer read GetNext write SetNext;
    property Module[I: Integer]: Integer read GetModule write SetModule;
    property Position[I: Integer]: Integer read GetPosition write SetPosition;
    property StartPosition[I: Integer]: Integer read GetStartPosition write SetStartPosition;
    property Level[I: Integer]: Integer read GetLevel write SetLevel;
    property PType[I: Integer]: Integer read GetType write SetType;
    property Address[I: Integer]: Pointer read GetAddr write SetAddr;
    property ByRef[I: Integer]: Integer read GetByRef write SetByRef;
    property TypeSub[I: Integer]: TPAXTypeSub read GetTypeSub write SetTypeSub;
    property NameIndex[I: Integer]: Integer read GetNameIndex write SetNameIndex;
    property VariantValue[I: Integer]: Variant read GetValue write PutValue;
    property MemberAccess[RefID: Integer]: TPAXMemberAccess read GetMemberAccess write SetMemberAccess;
    property CallConv[SubID: Integer]: Integer read GetCallConv write SetCallConv;
    property TypeNameIndex[ID: Integer]: Integer read GetTypeNameIndex write SetTypeNameIndex;
    property Imported[I: Integer]: Boolean read GetImported write SetImported;
    property Global[I: Integer]: Boolean read GetGlobal write SetGlobal;
    property JSIndex[I: Integer]: Boolean read GetJSIndex write SetJSIndex;
    property Card: Integer read fCard write SetCard;
  end;

function _GetName(NameIndex: Integer; Scripter: Pointer): String;

implementation

uses
  BASE_SCRIPTER, BASE_CODE, BASE_EXTERN;

constructor TPAXSymbolTable.Create(AScripter: Pointer);
var
  I: Integer;
begin
  StateStack := TPAXStack.Create;

  Scripter := AScripter;

  MemSize := FirstMemSize;

  Mem := AllocMem(MemSize);
  MemBoundVar  := 0;

  SetLength(A, FirstSymbolCard);
  for I:=0 to FirstSymbolCard - 1 do
    FillChar(A[I], SizeOf(TPAXSymbolRec), 0);

  fCard := -1;

  for I:=0 to PAXTypes.Count - 1 do
  begin
    AppVariant(Undefined, true);
    SetName(I, PAXTypes[I]);
    SetKind(I, kindTYPE);
  end;

  SetName(AppVariantConst(ord(maAny)), '_maAny_');
  SetName(AppVariantConst(ord(maMyBase)), '_maMyBase_');
  SetName(AppVariantConst(ord(maMyClass)), '_maMyClass_');

  IDtrue := AppVariant(true);
  SetName(IDtrue, 'true');

  IDfalse := AppVariant(false);
  SetName(IDfalse, 'false');

  IDundefined := AppVariant(undefined);

  RootNameSpaceID := AppVariant(Undefined);
  Name[RootNameSpaceID] := RootNamespaceName;
  Kind[RootNameSpaceID] := KindTYPE;

  CreateCard := Card;
  CreateMemBoundVar := MemBoundVar;

  MaxLocalVars := 0;
end;

procedure TPAXSymbolTable.SetCard(Value: Integer);
begin
  fCard := Value;
  CheckLength;
end;

procedure TPAXSymbolTable.IncCard;
begin
  Inc(fCard);
  CheckLength;
end;

procedure TPAXSymbolTable.DecCard;
begin
  Dec(fCard);
end;

procedure TPAXSymbolTable.CheckLength;
var
  L, I: Integer;
begin
  L := Length(A);
  if L < Card + 10 then
  begin
    SetLength(A, Card + DeltaSymbolCard);
    for I:=fCard + 1 to Length(A) - 1 do
      FillChar(A[I], SizeOf(TPAXSymbolRec), 0);
  end;
end;

procedure TPAXSymbolTable.CheckLength(Value: Integer);
var
  L, I: Integer;
begin
  L := Length(A);
  if value >= L then
  begin
    SetLength(A, value + DeltaSymbolCard);
    for I:=fCard + 1 to Length(A) - 1 do
      FillChar(A[I], SizeOf(TPAXSymbolRec), 0);
  end;
end;

procedure TPAXSymbolTable.SaveToStream(S: TStream; I1, I2: Integer);
var
  I, J, K, L: Integer;
  ClassRec: TPAXClassRec;
  ClassList: TPAXClassList;
  MemberRec: TPAXMemberRec;
  SO: TPAXScriptObject;
  FInstance: TPAXDelegate;
  ClassRecList: TPaxIds;
begin
  ClassList := TPAXBaseScripter(Scripter).ClassList;

  ClassRecList := TPaxIds.Create(false);

  SaveInteger(I1, S);
  SaveInteger(I2, S);
  SaveInteger(MaxLocalVars, S);

  for I:=I1 to I2 do
    if Kind[I] = KindTYPE then
    begin
      ClassRec := ClassList.FindClass(I);
      if ClassRec <> nil then
        ClassRecList.Add(I);
    end;

  for I:=I1 to I2 do
  begin
    S.WriteBuffer(A[I], SizeOF(A[I]));
    SaveString(Name[I], S);
  end;

  SaveInteger(ClassRecList.Count, S);
  for J:=0 to ClassRecList.Count - 1 do
  begin
    I := ClassRecList[J];
    L := Level[I];

    ClassRec := ClassList.FindClass(I);
    ClassRec.SaveToStream(S);
    if Kind[L] = KindTYPE then
    begin
      ClassRec := ClassList.FindClass(L);
      MemberRec := ClassRec.GetMember(NameIndex[I]);
      MemberRec.SaveToStream(S);
    end;
  end;

  ClassRecList.Free;

  for I:=I1 to I2 do
  begin
    K := Kind[I];
    L := Level[I];

    if K = KindVAR then
    begin
      if L = RootNamespaceID then
      begin
        ClassRec := ClassList[0];
        MemberRec := ClassRec.GetMember(NameIndex[I]);
        if MemberRec = nil then
          SaveInteger(0, S)
        else
        begin
          if MemberRec.IsSource then
          begin
            SaveInteger(1, S);
            MemberRec.SaveToStream(S);
          end
          else
            SaveInteger(0, S);
        end;
      end;
    end
    else if K = KindCONST then
    begin
      SaveVariant(GetVariant(I), S);
    end
    else if K = KindSUB then
    begin
      SO := VariantToScriptObject(GetVariant(I));
      FInstance := TPAXDelegate(SO.Instance);
      SaveInteger(FInstance.N, S);

      if L = RootNamespaceID then
      begin
        ClassRec := ClassList[0];
        MemberRec := ClassRec.GetMember(NameIndex[I]);
        MemberRec.SaveToStream(S);
      end;
    end;
  end;
end;

procedure TPAXSymbolTable.LoadFromStream(S: TStream;
                                         DS: Integer = 0; DP: Integer = 0);
var
  I1, I2, I, J, K, L, Temp: Integer;
  St: String;
  ClassRec: TPAXClassRec;
  ClassList: TPAXClassList;
  MemberRec: TPAXMemberRec;

  Shift: Boolean;
begin
  Shift := (DS <> 0) or (DP <> 0);

  ClassList := TPAXBaseScripter(Scripter).ClassList;

  I1 := LoadInteger(S);
  I2 := LoadInteger(S);
  MaxLocalVars := LoadInteger(S);

  ReallocateMem((I2 + MaxLocalVars * 2) * _SizeVariant + DeltaMemSize);

  for I:=I1 to I2 do
  begin
    IncCard;
    S.ReadBuffer(A[Card], SizeOf(A[Card]));
    St := LoadString(S);
    Name[Card] := St;

    AllocateVar(Card);

    if Shift then
    begin
      if A[Card].Level > RootNamespaceID then
        Inc(A[Card].Level, DS);
      if A[Card].Next > RootNamespaceID then
        Inc(A[Card].Next, DS);
      if A[Card].PType > RootNamespaceID then
        Inc(A[Card].PType, DS);
    end;
  end;

  K := LoadInteger(S);
  for J:=1 to K do
  begin
    ClassRec := TPAXClassRec.Create(Scripter, ckClass);
    ClassRec.LoadFromStream(S, DS, DP);
    ClassList.AddObject(ClassRec.ClassID, ClassRec);

    I := ClassRec.ClassID;
    L := Level[I];

    if Kind[L] = KindTYPE then
    begin
      ClassRec := ClassList.FindClass(L);
      MemberRec := TPAXMemberRec.Create(I, ClassRec);
      MemberRec.LoadFromStream(S, DS, DP);

      ClassRec.MemberList.AddObject(NameIndex[I], MemberRec);
    end;
  end;

  for I:=I1 + DS to I2 + DS do
  begin
    K := Kind[I];
    L := Level[I];

    if K = KindVAR then
    begin
      if L = RootNamespaceID then
      begin
        Temp := LoadInteger(S);
        if Temp <> 0 then
        begin
          ClassRec := ClassList[0];
          MemberRec := TPAXMemberRec.Create(I, ClassRec);
          MemberRec.LoadFromStream(S, DS, DP);
          ClassRec.MemberList.AddObject(NameIndex[I], MemberRec);
        end;
      end;
    end
    else if K = KindCONST then
    begin
      PutVariant(I, LoadVariant(S));
    end
    else if K = KindSUB then
    begin
      Temp := LoadInteger(S);
      if Temp > 0 then
        Inc(Temp, DP);

      PutVariant(I, Temp);

      if L = RootNamespaceID then
      begin
        ClassRec := ClassList[0];
        MemberRec := TPAXMemberRec.Create(I, ClassRec);
        MemberRec.LoadFromStream(S, DS, DP);
        ClassRec.MemberList.AddObject(NameIndex[I], MemberRec);
      end;
    end;
  end;
end;

procedure TPAXSymbolTable.Reset;
begin
  FillChar(Mem^, MemSize, 0);
  MemBoundVar := CreateMemBoundVar;

  EraseTail(CreateCard);
  StateStack.Clear;
end;

procedure TPAXSymbolTable.EraseTail(K: Integer);
var
  I: Integer;
  P: Pointer;
begin
  for I:=Card downto K + 1 do
  if Level[I] >= 0 then
  begin
    P := A[I].Address;

    if P <> nil then
    begin
      try
        if IsInsideMemAddress(P) then
           ClearVariant(I);
      finally
        FillChar(A[I], SizeOf(TPAXSymbolRec), 0);
      end;
    end;
  end;
  Card := K;
end;

function TPAXSymbolTable.IsFormalParamID(ID: Integer): Boolean;
var
  I, SubID: Integer;
begin
  result := false;
  if ID <= 0 then
    Exit;
  SubID := GetLevel(ID);
  if GetKind(SubID) <> KindSUB then
    Exit;
  for I:=1 to GetCount(SubID) do
    if GetParamID(SubID, I) = ID then
      result := true;
end;

function TPAXSymbolTable.CodeStringConst(const Val: String): Integer;
var
  I: Integer;
begin
  for I:=PAXTypes.Count + 1 to Card do
    if GetType(I) > 0 then
    if GetKind(I) = kindCONST then
      if VarType(Variant(GetAddr(I)^)) = varString then
        if Val = Variant(GetAddr(I)^) then
        begin
          result := I;
          Exit;
        end;

//  result := AppVariantConst(Val);

  IncCard;

  with A[Card] do
  begin
    PName := 0;
    PType := GetPAXtype(Val);
    Kind := kindCONST;

    Address := Pointer(Integer(Mem) + MemBoundVar);
    Inc(MemBoundVar, SizeOf(Variant));
    FillChar(Address^, SizeOf(Variant), 0);
    Variant(Address^) := Val;// StrPas(PChar(Val));

    Module := -1;
    Position := -1;
  end;
  result := Card;
end;

destructor TPAXSymbolTable.Destroy;
begin
  EraseTail(0);

  FreeMem(Mem, MemSize);
  StateStack.Free;

  inherited;
end;

procedure TPAXSymbolTable.SetName(I: Integer; const Name: String);
begin
  A[I].PName := TPaxBaseScripter(Scripter).NameList.Add(Name);
end;


function TPAXSymbolTable.GetName(I: Integer): String;
var
  Index: Integer;
begin
  if I < 0 then
  begin
    result := DefinitionList.GetName(-I);
    Exit;
  end;

  if I > Card then
  begin
    result := '';
    Exit;
  end;

  Index := A[I].PName;
  if Index > 0 then
  begin
    if Index < NameList.Count then
      result := NameList[Index]
    else
      result := '';
  end
  else
    result := '';
end;

function TPAXSymbolTable.GetFullName(I: Integer): String;
var
  L: Integer;
begin
  if I < 0 then
  begin
    result := DefinitionList.GetFullName(-I);
    Exit;
  end;
  result := GetName(I);
  L := GetLevel(I);
  if (L > 0) and (L < Card) and (L <> RootNamespaceID) then
    result := GetName(L) + '.' + result; 
end;


procedure TPAXSymbolTable.SetLocal(ID: Integer);
begin
  A[ID].Local := 1;
end;

function TPAXSymbolTable.IsLocal(ID: Integer): Boolean;
begin
  result := A[ID].Local > 0;
end;

procedure TPAXSymbolTable.SetNameIndex(I, Value: Integer);
begin
  A[I].PName := Value;
end;

function TPAXSymbolTable.GetNameIndex(I: Integer): Integer;
begin
  if I > 0 then
    result := A[I].PName
  else
  begin
    result := DefinitionList.GetNameIndex(-I, Scripter);
  end;
end;

procedure TPAXSymbolTable.SetKind(I, AKind: Integer);
begin
  if I > 0 then
    A[I].Kind := AKind;
end;

function TPAXSymbolTable.GetKind(I: Integer): Integer;
begin
  if I > 0 then
    result := A[I].Kind
  else
    result := DefinitionList.GetKind(-I);
end;

procedure TPAXSymbolTable.SetImported(I: Integer; Value: Boolean);
begin
  if I > 0 then
    A[I].Imported := Value;
end;

function TPAXSymbolTable.GetImported(I: Integer): Boolean;
begin
  if I > 0 then
    result := A[I].Imported
  else
    result := false;
end;

procedure TPAXSymbolTable.SetGlobal(I: Integer; Value: Boolean);
begin
  if I > 0 then
    A[I].Global := Value;
end;

function TPAXSymbolTable.GetGlobal(I: Integer): Boolean;
begin
  if I > 0 then
    result := A[I].Global
  else
    result := false;
end;


function TPAXSymbolTable.GetStrKind(I: Integer): String;
var
  J: Integer;
begin
  J := GetKind(I);
  if (J >= 1) and (J <= PAXKinds.Count - 1) then
    result := PAXKinds[J]
  else
    result := ' ';
end;

procedure TPAXSymbolTable.SetCount(I, ACount: Integer);
begin
  A[I].Count := ACount;
end;

function TPAXSymbolTable.GetCount(I: Integer): Integer;
begin
  if I > 0 then
    result := A[I].Count
  else
    result := DefinitionList.GetCount(-I);
end;

function TPAXSymbolTable.GetParamTypeName(SubID, ParamIndex: Integer): String;
var
  ParamID, TypeID: Integer;
begin
  if SubID > 0 then
  begin
    ParamID := GetParamID(SubID, ParamIndex);
    TypeID := GetType(ParamID);
    result := GetName(TypeID);
  end
  else
  begin
    result := DefinitionList.GetParamTypeName(-SubID, ParamIndex);
  end;
end;

function TPAXSymbolTable.GetParamName(SubID, ParamIndex: Integer): String;
var
  ParamID: Integer;
begin
  if SubID > 0 then
  begin
    ParamID := GetParamID(SubID, ParamIndex);
    result := GetName(ParamID);
  end
  else
  begin
    result := DefinitionList.GetParamName(-SubID, ParamIndex);
  end;
end;

function TPAXSymbolTable.GetTypeName(ID: Integer): String;
var
  TypeID: Integer;
begin
  if ID > 0 then
  begin
    TypeID := GetType(ID);
    result := GetName(TypeID);
  end
  else
  begin
    result := DefinitionList.GetTypeName(-ID);
  end;
end;

procedure TPAXSymbolTable.SetRank(I, ARank: Integer);
begin
  if I > 0 then
    A[I].Rank := ARank;
end;

function TPAXSymbolTable.GetRank(I: Integer): Integer;
begin
  if I > 0 then
    result := A[I].Rank
  else
    result := 0;
end;

procedure TPAXSymbolTable.SetNext(I, Value: Integer);
begin
  A[I].Next := Value;
end;

function TPAXSymbolTable.GetNext(I: Integer): Integer;
begin
  result := A[I].Next;
end;

procedure TPAXSymbolTable.SetModule(I, Value: Integer);
begin
  A[I].Module := Value;
end;

function TPAXSymbolTable.GetModule(I: Integer): Integer;
begin
  result := A[I].Module;
end;

procedure TPAXSymbolTable.SetPosition(I, Value: Integer);
begin
  A[I].Position := Value;
end;

function TPAXSymbolTable.GetPosition(I: Integer): Integer;
begin
  result := A[I].Position;
end;

procedure TPAXSymbolTable.SetStartPosition(I, Value: Integer);
begin
  A[I].StartPosition := Value;
end;

function TPAXSymbolTable.GetStartPosition(I: Integer): Integer;
begin
  result := A[I].StartPosition;
end;

procedure TPAXSymbolTable.SetLevel(I: Integer; Value: Integer);
begin
  if I > 0 then
    A[I].Level := Value;
end;

function TPAXSymbolTable.GetLevel(I: Integer): Integer;
begin
  if I > 0 then
    result := A[I].Level
  else if I < 0 then
    result := -1
  else
    result := 0;
end;

procedure TPAXSymbolTable.SetCallConv(I, Value: Integer);
begin
  A[I].CallConv := Value;
end;

function TPAXSymbolTable.GetCallConv(I: Integer): Integer;
begin
  result := A[I].CallConv;
end;

procedure TPAXSymbolTable.SetTypeNameIndex(I, Value: Integer);
begin
  A[I].TypeNameIndex := Value;
end;

function TPAXSymbolTable.GetTypeNameIndex(I: Integer): Integer;
begin
  result := A[I].TypeNameIndex;
end;

procedure TPAXSymbolTable.SetType(I, AType: Integer);
begin
  if I > 0 then
  A[I].PType := AType;
end;

function TPAXSymbolTable.GetType(I: Integer): Integer;
begin
  if I > 0 then
    result := A[I].PType
  else
    result := typeVARIANT;
end;

procedure TPAXSymbolTable.SetAddr(I: Integer; Address: Pointer);
begin
  A[I].Address := Address;
end;

function TPAXSymbolTable.GetAddr(I: Integer): Pointer;
begin
  if I > 0 then
    result := A[I].Address
  else if I = 0 then
    result := @Undefined
  else
    result := DefinitionList.GetAddress(Scripter, -I);
end;

procedure TPAXSymbolTable.SetByRef(ParamID: Integer; Value: Integer);
begin
  A[ParamID].Misc := Value;
end;

function TPAXSymbolTable.GetByRef(ParamID: Integer): Integer;
begin
  result := A[ParamID].Misc;
end;

procedure TPAXSymbolTable.SetTypeSub(SubID: Integer; Value: TPAXTypeSub);
begin
  A[SubID].Misc := Ord(Value);
end;

function TPAXSymbolTable.GetTypeSub(SubID: Integer): TPAXTypeSub;
var
  D: TPaxDefinition;
begin
  result := tsNone;
  if SubID > 0 then
    result := TPAXTypeSub(A[SubID].Misc)
  else
  begin
    D := DefinitionList[-SubID];
    if D.DefKind = dkMethod then
      result := TPaxMethodDefinition(D).TypeSub;
  end;
end;

function TPAXSymbolTable.GetStrType(I: Integer): String;
var
  J: Integer;
begin
  J := GetType(I);
  if (J >= 1) and (J <= Card) then
    result := GetName(J)
  else if J < 0 then
    result := '-' + DefinitionList.GetName(-J)
  else
    result := ' ';
end;

function TPAXSymbolTable.GetStrVal(I: Integer): String;
begin
  if not IsInsideMemAddress(GetAddr(I)) then
    result := '***'
  else if GetType(I) > 0 then
    result := ToStr(Scripter, GetVariant(I))
  else
    result := '';
end;

function TPAXSymbolTable.GetSizeOf(I: Integer): Integer;
begin
  result := _SizeVariant;
end;

function TPAXSymbolTable.AppLabel: Integer;
begin
  result := AppVariant(Undefined);
  A[result].Kind := KindLABEL;
end;

function TPAXSymbolTable.GetAlias(ID: Integer): Variant;
begin
  result := CreateAlias(GetAddr(ID));
end;

function TPAXSymbolTable.GetVariant(ID: Integer): Variant;
begin
  if ID > 0 then
    result := GetTerminal(GetAddr(ID))^
  else if ID = 0 then
  begin
  end
  else
    result := DefinitionList.GetVariant(Scripter, -ID);
end;

procedure TPAXSymbolTable.ClearVariant(ID: Integer);
begin
  VarClear(Variant(GetAddr(ID)^));
end;

procedure TPAXSymbolTable.ClearVariantValue(ID: Integer);
var
  Base: Variant;
  SO: TPAXScriptObject;
begin
  if GetKind(ID) <> kindREF then
  begin
    VarClear(Variant(GetAddr(ID)^));
    Exit;
  end;

  Base := GetVariant(ID);
  if VarIsNull(Base) or VarIsEmpty(Base) then
    raise TPAXScriptFailure.Create(errIncompatibleTypes);

  SO := VariantToScriptObject(Base);
  SO.ClearProperty(NameIndex[ID]);
end;

procedure TPAXSymbolTable.PutVariant(ID: Integer; const Val: Variant);
begin
  if ID > 0 then
    GetTerminal(GetAddr(ID))^ := Val
  else if ID = 0 then
  begin
  end
  else
    DefinitionList.PutVariant(Scripter, -ID, Val);
end;

function TPAXSymbolTable.AppVariant(const Val: Variant; HasAddress: Boolean = true): Integer;
begin
  CheckMem;

  IncCard;

  with A[Card] do
  begin
    PName := 0;
    PType := GetPAXtype(Val);
    Kind := kindVAR;

    if HasAddress then
    begin
      Address := Pointer(Integer(Mem) + MemBoundVar);
      Inc(MemBoundVar, SizeOf(Variant));
      FillChar(Address^, SizeOf(Variant), 0);
      Variant(Address^) := Val;
    end
    else
      Address := @Undefined;

    Module := -1;
    Position := -1;
  end;
  result := Card;
end;

function TPAXSymbolTable.AppVariantConst(const Val: Variant; Dup: Boolean = false): Integer;
var
  R: Double;
  I: Integer;
begin
  if Dup = false then
  begin
    result := LookupConstID(Val);
    if result > 0 then
      Exit;
  end;

  CheckMem;

  if VarType(Val) = varByte then
  begin
    I := Val;
    result := AppVariant(I);
  end
  else
    result := AppVariant(Val);

  SetKind(result, KindCONST);
  SetName(result, VarToStr(Val));

  if GetType(result) = typeDOUBLE then
  begin
    R := Frac(Val);
    if R = 0 then
      SetType(result, typeInt64);
  end;
end;

function TPAXSymbolTable.AllocateVar(I: Integer): Pointer;
var
  MemCnt: Integer;
begin
  CheckMem;

  result := ShiftPointer(Mem, MemBoundVar);
  A[I].Address := result;
  MemCnt := GetSizeOf(I);
  Inc(MemBoundVar, MemCnt);

  FillChar(result^, MemCnt, 0);
end;

procedure TPAXSymbolTable.CheckMem;
begin
  if MemBoundVar > MemSize - 256 then
    ReallocateMem(MemSize + DeltaMemSize);
end;

procedure TPAXSymbolTable.ReallocateMem(NewSize: Integer);
var
  I: Integer;
  P, Q, Adr: Pointer;
  V: Variant;
  K: Integer;
begin
  if NewSize = MemSize then
    Exit
  else if NewSize < MemSize then
  begin
//    ReallocMem(Mem, NewSize);
//    MemSize := NewSize;
    Exit;
  end;

  P := AllocMem(NewSize);
  Q := P;

  K := 0;
  for I:=1 to Card do
  begin
    Adr := A[I].Address;
    if (Adr <> nil) and (Adr <> @Undefined)
        and (not TPaxBaseScripter(Scripter).ParamList.HasAddress(Adr)) then
    begin
      V := Variant(Adr^);
      VarClear(Variant(Adr^));
      A[I].Address := Q;
      if not IsUndefined(V) then
        Variant(A[I].Address^) := V;

      Inc(Integer(Q), _SizeVariant);

      Inc(K, _SizeVariant);
    end;
  end;

  if K > MemBoundVar then
    MemBoundVar := K;

  FreeMem(Mem, MemSize);
  Mem := P;
  MemSize := NewSize;
end;

function TPAXSymbolTable.CodeNumberConst(Val: Variant): Integer;
var
  I, VT: Integer;
  TempVal: Variant;
begin
  VT := VarType(Val);
  for I:=PAXTypes.Count + 1 to Card do
    if GetType(I) > 0 then
    if GetKind(I) = kindCONST then
    begin
      TempVal := GetVariant(I);
      if VT = VarType(TempVal) then
        if Val = TempVal then
        begin
          result := I;
          Exit;
        end;
    end;

  result := AppVariantConst(Val);
  SetName(result, GetStrVal(result));
end;

function TPAXSymbolTable.LookUpID(const Name: String; aLevel: Integer; UpCase: Boolean = true): Integer;
var
  I, K: Integer;
  S: String;
  B: Boolean;
  SymbolRec: TPAXSymbolRec;
begin
  result := 0;
  for I:=Card downto 1 do
  begin
    SymbolRec := A[I];
    if SymbolRec.PName <> 0 then
    begin
      K := SymbolRec.Kind;
      if (K = KindVAR) or (K = KindSUB) or (K = KindTYPE) or 
         (K = KindLABEL) or
         (K = KindHOSTOBJECT) or (K = KindHOSTVAR) or (K = KindHOSTCONST) or (K = KindHOSTINTERFACEVAR)
         then
        if SymbolRec.Level = aLevel then
        begin
          S := GetName(I);

          if UpCase then
            B := StrEql(Name, S)
          else
            B := Name = S;

          if B then
          begin
            result := I;
            Exit;
          end;
        end;
    end;
  end;
end;

function TPAXSymbolTable.LookUpSubID(const Name: String; aLevel: Integer; UpCase: Boolean = true): Integer;
var
  I, K: Integer;
  S: String;
  B: Boolean;
  SymbolRec: TPAXSymbolRec;
begin
  result := 0;
  for I:=Card downto 1 do
  begin
    SymbolRec := A[I];
    if SymbolRec.PName <> 0 then
    begin
      K := SymbolRec.Kind;
      if K = KindSUB then
        if SymbolRec.Level = aLevel then
        begin
          S := GetName(I);

          if UpCase then
            B := StrEql(Name, S)
          else
            B := Name = S;

          if B then
          begin
            result := I;
            Exit;
          end;
        end;
    end;
  end;
end;

function TPAXSymbolTable.LookupConstID(const Value: Variant): Integer;
var
  I, VT: Integer;
begin
  VT := VarType(Value);
  result := 0;
  for I:=1 to Card do
    if GetKind(I) = KindCONST then
      if VarType(Variant(GetAddr(I)^)) = VT then
        if Variant(GetAddr(I)^) = Value then
        begin
          result := I;
          Exit;
        end;
end;

function TPAXSymbolTable.IsOutsideMemAddress(A: Pointer): boolean;
var
  N, B1, B2: Integer;
begin
  N  := Integer(A);
  B1 := Integer(Mem) + MemBoundVar;
  B2 := Integer(Mem) + MemSize;
  result := (N >= B1) and (N <= B2);
end;

function TPAXSymbolTable.IsInsideMemAddress(A: Pointer): boolean;
var
  N, B1, B2: Integer;
begin
  N  := Integer(A);
  B1 := Integer(Mem);
  B2 := B1 + MemBoundVar;
  result := (N >= B1) and (N < B2);
end;

function TPAXSymbolTable.IsExternalAddress(A: Pointer): boolean;
var
  N, B1, B2: Integer;
begin
  N  := Integer(A);
  B1 := Integer(Mem);
  B2 := Integer(Mem) + MemSize;
  result := (N < B1) or (N > B2);
end;

function TPAXSymbolTable.IsInternalAddress(A: Pointer): boolean;
var
  N, B1, B2: Integer;
begin
  N  := Integer(A);
  B1 := Integer(Mem);
  B2 := Integer(Mem) + MemSize - _SizeVariant;
  result := (N >= B1) and (N <= B2);
end;

procedure TPAXSymbolTable.LinkVariables(SubID: Integer; HasResult: Boolean);
var
  I, J, PrevID, FirstCode, ParamID, K, _SubID: Integer;
  Code: TPAXCode;
  Found: Boolean;
  D: Integer;
  Def: TPaxDefinition;
  DefMethod: TPaxMethodDefinition;
begin
  Found := false;

  Code := TPAXBaseScripter(Scripter).Code;
  FirstCode := GetVariant(SubID);

  for I:=1 to Count[SubID] do
  begin
    ParamID := GetParamID(SubID, I);
    if ByRef[ParamID] = 0 then
    begin
      for J:=FirstCode to Code.Card do
      if Code.Prog[J].Res = ParamID then
      begin
        Found := true;
        Break;
      end;
      if not Found then
        SetByRef(ParamID, 2);
    end
    else if ByRef[ParamID] = 2 then
    begin
      for J:=FirstCode to Code.Card do
        if Code.Prog[J].Res = ParamID then
        begin
          Code.Card := J;
          raise TPAXScriptFailure.Create(errLeftSideCannotBeAssignedTo);
        end
        else if (Code.Prog[J].Arg1 = ParamID) and (Code.Prog[J].OP = OP_PUSH) then
        begin
          _SubID := Code.Prog[J].Res;
          K := Code.Prog[J].Arg2;
          if _SubID > 0 then
          begin
            if Kind[_SubID] = KindSUB then
            begin
              ParamID := GetParamID(_SubID, K);
              if GetByRef(ParamID) = 1 then
              begin
                Code.Card := J;
                raise TPAXScriptFailure.Create(errLeftSideCannotBeAssignedTo);
              end;
            end;
          end
          else if _SubID < 0 then
          begin
            Def := DefinitionList[- _SubID];
            if Def.DefKind = dkMethod then
            begin
              DefMethod := TPaxMethodDefinition(Def);
              if Length(DefMethod.ByRefs) >= K then
                if DefMethod.ByRefs[K-1] = true then
                begin
                  Code.Card := J;
                  raise TPAXScriptFailure.Create(errLeftSideCannotBeAssignedTo);
                end;
            end;
          end;
        end;
    end;
  end;

  if HasResult then
    D := 1
  else
    D := 3;

  K := 0;
  PrevID := SubID;
  for I:=SubID + D to Card do
    if Level[I] = SubID then
    begin
      if Kind[I] = KindVAR then
        if ByRef[I] = 0 then
        begin
          Inc(K);
          Next[PrevID] := I;
          Next[I] := -1;
          PrevID := I;
        end;
   end
//
   else if Level[I] = -1 then
   begin
      if Kind[I] = KindREF then
        if ByRef[I] = 0 then
        begin
          Inc(K);
          Next[PrevID] := I;
          Next[I] := -1;
          PrevID := I;
        end;
   end;
//
  if K = 0 then
    Next[SubID] := 0;

  if K > MaxLocalVars then
    MaxLocalVars := K;
end;

function TPAXSymbolTable.GetResultID(SubID: Integer): Integer;
begin
  result := SubID + 1;
end;

function TPAXSymbolTable.GetThisID(SubID: Integer): Integer;
begin
  result := SubID + 2;
end;

function TPAXSymbolTable.GetParamID(SubID: Integer; N: Integer): Integer;
begin
  result := SubID + 2 + N;
end;

function TPAXSymbolTable.GetDllID(SubID: Integer): Integer;
begin
  result := SubID + 3 + Count[SubID];
end;

function TPAXSymbolTable.GetDllProcID(SubID: Integer): Integer;
begin
  result := GetDllID(SubID) + 1;
end;

procedure TPAXSymbolTable.AllocateSubroutines;
var
  I, LastBound: Integer;
label Start;
begin
  LastBound := MemBoundVar;
  Start:
  for I:=1 to Card do
    if Kind[I] = KindSUB then
    begin
      if MemBoundVar > MemSize - 1024 then
      begin
         ReallocateMem(MemSize + DeltaMemSize);
         MemBoundVar := LastBound;
         goto Start;
      end;
      AllocateSub(I);
    end;
end;

function TPAXSymbolTable.GetSubCount: Integer;
var
  I: Integer;
begin
  result := 0;
  for I:=1 to Card do
    if Kind[I] = KindSUB then
      Inc(Result);
end;

procedure TPAXSymbolTable.AllocateSub(SubID: Integer);
var
  P: Pointer;
  I: Integer;
begin
  I := A[SubID].Next;

  if I = 0 then
    Exit;

   P := Pointer(Integer(Mem) + MemBoundVar);

{
  Pointer(P^) := A[I].Address;
  Inc(Integer(P), SizeOf(Pointer));
}

  FillChar(P^, _SizeVariant, 0);
  Variant(P^) := Integer(A[I].Address);
  Inc(Integer(P), _SizeVariant);

  repeat
    Integer(P^) := 0;
    Integer(Pointer(Integer(P)+4)^) := 0;
    Integer(Pointer(Integer(P)+8)^) := 0;
    Integer(Pointer(Integer(P)+12)^) := 0;

    with A[I] do
    begin
      Address := P;
      I := Next;
    end;
    Inc(Integer(P), _SizeVariant);
  until (I = -1);

  MemBoundVar := Integer(P) - Integer(Mem);
end;

procedure TPAXSymbolTable.DeallocateSub(SubID: Integer);
var
  P: Pointer;
  I: Integer;
begin
  I := A[SubID].Next;

  if I = 0 then
    Exit;

{
  P := Pointer(Integer(A[I].Address) - SizeOf(Pointer));
  P := Pointer(P^);
}

  P := Pointer(Integer(A[I].Address) - _SizeVariant);
  P := Pointer(Integer(Variant(P^)));


  repeat
    with A[I] do
    begin
      with TVarData(Address^) do
        if VType = varString then
        begin
          if (Level = SubID) then
             String(VString) := ''

          else if (Kind = KindVar) and (Level = -1) then
          begin
             String(VString) := '';
          end;

        end;

      Address := P;
      I := Next;
    end;

    Dec(MemBoundVar, _SizeVariant);
    if (I=-1) then
      Break;

    Inc(Integer(P), _SizeVariant);
  until false;

{
  Dec(MemBoundVar, SizeOf(Pointer));
}
  Dec(MemBoundVar, _SizeVariant);
end;

function TPAXSymbolTable.IsLocalVar(SubID, ID: Integer): Boolean;
var
  I: Integer;
begin
  result := false;
  I := Next[SubID];
  repeat
    if I = ID then
    if IsLocal(I) then
    begin
      result := true;
      Exit;
    end;
    I := Next[I];
  until I = -1;
end;

procedure TPAXSymbolTable.Erase(I: Integer);
var
  K: Integer;
begin
  K := GetKind(I);
  if (K = KindVar) or (K = KindConst) or (K = 0) then
      ClearVariant(I);
end;

procedure TPAXSymbolTable.SaveState;
begin
  StateStack.Push(MemBoundVar);
  StateStack.Push(Card);
end;

procedure TPAXSymbolTable.RestoreState;
var
  K, I: Integer;
  V: Variant;
begin
  K := Card;
  Card := StateStack.Pop;
  for I := K downto Card + 1 do
  begin
    if TPAXBaseScripter(Scripter).EvalCount = 0 then
    if Kind[I] <> KindREF then
    begin
      V := GetVariant(I);
      if IsObject(V) then
        TPaxBaseScripter(Scripter).ScriptObjectList.RemoveObject(VariantToScriptObject(V));
    end;
    ClearVariant(I);
    FillChar(A[I], SizeOf(A[I]), 0);
  end;

  MemBoundVar := StateStack.Pop;
end;

procedure TPAXSymbolTable.InitRunStage;
begin
  SaveState;
end;

procedure TPAXSymbolTable.ResetRunStage;
var
  I, K, SubID: Integer;
  P, PType, PSub: Pointer;
begin
  RestoreState;
  StateStack.Clear;
  SubID := 0;
  PSub := nil;

  PType := nil;

  for I:=CreateCard to Card do
  begin
    K := GetKind(I);

    if K = KindType then
      PType := GetAddr(I)
    else if K = KindSub then
    begin
      PSub := GetAddr(I);
      SubID := I;
    end;

    if K = KindREF then
      Kind[I] := KindVAR;

    if Kind[I] = KindVAR then
      if GetLevel(I) >= -1 then
      begin
        P := GetAddr(I);
        if (P <> PType) and (P <> PSub) and (I <> GetThisID(SubID)) and
           (not Imported[I]) then
             if (not Global[I]) then
             begin
{
               if IsObject(PVariant(A[I].Address)^) then
               begin
                 SO := VariantToScriptObject(PVariant(A[I].Address)^);
                 SO.RefCount := 1;
               end;
 }
               ClearVariant(I);
             end;
      end;
  end;
end;

procedure TPAXSymbolTable.ResetCompileStage;
var
  K: Integer;
  SO: TPAXScriptObject;
  V: Variant;
  P: Pointer;
begin
  V := GetVariant(RootNamespaceID);
  if IsObject(V) then
    SO := VariantToScriptObject(V)
  else
    SO := nil;

  while Card > FirstSymbolCard do
  begin
    P := Address[Card];
    if IsInternalAddress(P) then
    begin
      K := GetKind(Card);
      if K = KindREF then
      begin
        Kind[Card] := KindVAR;
      end;
      if GetLevel(Card) >= -1 then
      begin
        ClearVariant(Card);
      end;
    end;

    FillChar(A[Card], SizeOf(A[Card]), 0);
    DecCard;
  end;
  if SO <> nil then
    TPAXBaseScripter(Scripter).ScriptObjectList.RemoveObject(SO);
  ClearVariant(RootNamespaceID);

  MemBoundVar := CreateMemBoundVar;
end;

function TPAXSymbolTable.GetMemberAccess(RefID: Integer): TPAXMemberAccess;
begin
  result := TPAXMemberAccess(A[RefID].Misc);
end;

procedure TPAXSymbolTable.SetMemberAccess(RefID: Integer; Value: TPAXMemberAccess);
begin
  A[RefID].Misc := Ord(Value);
end;

function TPAXSymbolTable.GetMemberRec(RefID: Integer; ma: TPAXMemberAccess): TPAXMemberRec;
var
  SO: TPAXScriptObject;
begin
  SO := VariantToScriptObject(GetVariant(RefID));
  result := SO.ClassRec.FindMember(NameIndex[RefID], ma);

  if result <> nil then
    result.CheckAccess;
end;

function TPAXSymbolTable.GetMemberRecEx(RefID: Integer;
                                        ma: TPAXMemberAccess;
                                        var FoundInBaseClass: Boolean;
                                        var SO: TPaxScriptObject): TPAXMemberRec;
var
  Idx: Integer;
begin
  Idx := NameIndex[RefID];
  if RefID > 0 then
    SO := VariantToScriptObject(PVariant(A[RefID].Address)^)
  else
    SO := VariantToScriptObject(GetVariant(RefID));
  result := SO.ClassRec.FindMemberEx(Idx, ma, FoundInBaseClass);

  if result = nil then
    if (Idx = SO.ClassRec.NameIdx) or (Idx = NameIndex_New) then
       result := SO.ClassRec.FindMemberEx(NameIndex_Create, ma, FoundInBaseClass);

  if result <> nil then
    result.CheckAccess;
end;

function TPAXSymbolTable.GetOverloadedSubID(RefID: Integer; ma: TPAXMemberAccess;
                        ParamCount: Integer): Integer;
var
  SO: TPAXScriptObject;
begin
  SO := VariantToScriptObject(GetVariant(RefID));
  result := SO.ClassRec.FindOverloadedSubID(NameIndex[RefID], ma, ParamCount);
end;

function TPAXSymbolTable.AppReference(const Base: Variant; ANameIndex: Integer; ma: TPAXMemberAccess): Integer;
begin
  result := AppVariant(Base);
  NameIndex[result] := ANameIndex;
  Kind[result] := kindREF;
  MemberAccess[result] := ma;
end;

procedure TPAXSymbolTable.SetReference(RefID: Integer; const Base: Variant; ma: TPAXMemberAccess);
//var
//  P: PVariant;
begin
  PutVariant(RefID, Base);
{
   P := A[RefID].Address;
   TVarData(P^).VType := varScriptObject;
   TVarData(P^).VInteger := TVarData(Base).VInteger;
}

  A[RefID].Kind := kindREF;

//  MemberAccess[RefID] := ma;
  A[RefID].Misc := Ord(ma);
end;

function TPAXSymbolTable.GetUserData(ID: Integer): Integer;
var
  MemberRec: TPaxMemberRec;
  D: TPaxDefinition;
  DV: TPaxVariableDefinition;
  DC: TPaxConstantDefinition;
  DOB: TPaxObjectDefinition;
  DI: TPaxInterfaceVarDefinition;
  I: Integer;
  DefList: TPaxDefinitionList;
begin
  result := 0;
  case Kind[ID] of
    KindRef:
    begin
      MemberRec := GetMemberRec(ID, maAny);
      if MemberRec = nil then
        Exit;
      D := MemberRec.Definition;
      if D <> nil then
        result := D.UserData;
    end;
    KindHostVar:
    begin
      I := GetVariant(ID);
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
      result := DV.UserData;
    end;
    KindHostConst:
    begin
      I := GetVariant(ID);
      if I > 0 then
      begin
        DefList := DefinitionList;
        DC := TPaxConstantDefinition(DefList[I]);
      end
      else
      begin
        DefList := TPaxBaseScripter(Scripter).LocalDefinitions;
        DC := TPaxConstantDefinition(DefList.GetRecordByIndex(- I));
      end;
      result := DC.UserData;
    end;
    KindHostObject:
    begin
      I := GetVariant(ID);
      if I > 0 then
      begin
        DefList := DefinitionList;
        DOB := TPaxObjectDefinition(DefList[I]);
      end
      else
      begin
        DefList := TPaxBaseScripter(Scripter).LocalDefinitions;
        DOB := TPaxObjectDefinition(DefList.GetRecordByIndex(- I));
      end;
      result := DOB.UserData;
    end;
    KindHostInterfaceVar:
    begin
      I := GetVariant(ID);
      if I > 0 then
      begin
        DefList := DefinitionList;
        DI := TPaxInterfaceVarDefinition(DefList[I]);
      end
      else
      begin
        DefList := TPaxBaseScripter(Scripter).LocalDefinitions;
        DI := TPaxInterfaceVarDefinition(DefList.GetRecordByIndex(- I));
      end;
      result := DI.UserData;
    end
    else
      if ID < 0 then
      begin
        D := DefinitionList[-ID];
        result := D.UserData;
      end;
  end;
end;

function TPAXSymbolTable.GetAddressEx(ID: Integer): Pointer;
var
  DV: TPaxVariableDefinition;
  DC: TPaxConstantDefinition;
  DOB: TPaxObjectDefinition;
  DI: TPaxInterfaceVarDefinition;
  I: Integer;
  DefList: TPaxDefinitionList;
begin
  case Kind[ID] of
    KindHostVar:
    begin
      I := GetVariant(ID);

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

      result := DV.GetAddress;
    end;
    KindHostConst:
    begin
      I := GetVariant(ID);

      if I > 0 then
      begin
        DefList := DefinitionList;
        DC := TPaxConstantDefinition(DefList[I]);
      end
      else
      begin
        DefList := TPaxBaseScripter(Scripter).LocalDefinitions;
        DC := TPaxConstantDefinition(DefList.GetRecordByIndex(- I));
      end;

      result := DC.GetAddress;
    end;
    KindHostObject:
    begin
      I := GetVariant(ID);

      if I > 0 then
      begin
        DefList := DefinitionList;
        DOB := TPaxObjectDefinition(DefList[I]);
      end
      else
      begin
        DefList := TPaxBaseScripter(Scripter).LocalDefinitions;
        DOB := TPaxObjectDefinition(DefList.GetRecordByIndex(- I));
      end;

      result := @ DOB.DefValue;
    end;
    KindHostInterfaceVar:
    begin
      I := GetVariant(ID);

      if I > 0 then
      begin
        DefList := DefinitionList;
        DI := TPaxInterfaceVarDefinition(DefList[I]);
      end
      else
      begin
        DefList := TPaxBaseScripter(Scripter).LocalDefinitions;
        DI := TPaxInterfaceVarDefinition(DefList.GetRecordByIndex(- I));
      end;

      result := @ DI.DefValue;
    end
    else
      result := GetAddr(ID);
  end;
end;

function TPAXSymbolTable.GetValue(ID: Integer): Variant;
var
  Base: Variant;
  SO: TPAXScriptObject;
  DV: TPaxVariableDefinition;
  DC: TPaxConstantDefinition;
  DOB: TPaxObjectDefinition;
  DI: TPaxInterfaceVarDefinition;
  I: Integer;
  DefList: TPaxDefinitionList;
begin
  case Kind[ID] of
    KindRef:
    begin
      Base := GetVariant(ID);
      if VarIsNull(Base) or VarIsEmpty(Base) then
      begin
        TPaxBaseScripter(Scripter).Dump();
        raise TPAXScriptFailure.Create(errIncompatibleTypes);
      end;

      SO := VariantToScriptObject(Base);
      result := SO.GetProperty(NameIndex[ID], 0);
    end;
    KindHostVar:
    begin
      I := GetVariant(ID);

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

      result := DV.GetValue(Scripter);
    end;
    KindHostConst:
    begin
      I := GetVariant(ID);

      if I > 0 then
      begin
        DefList := DefinitionList;
        DC := TPaxConstantDefinition(DefList[I]);
      end
      else
      begin
        DefList := TPaxBaseScripter(Scripter).LocalDefinitions;
        DC := TPaxConstantDefinition(DefList.GetRecordByIndex(- I));
      end;

      result := DC.Value;
    end;
    KindHostObject:
    begin
      I := GetVariant(ID);

      if I > 0 then
      begin
        DefList := DefinitionList;
        DOB := TPaxObjectDefinition(DefList[I]);
      end
      else
      begin
        DefList := TPaxBaseScripter(Scripter).LocalDefinitions;
        DOB := TPaxObjectDefinition(DefList.GetRecordByIndex(- I));
      end;

      result := DOB.Value;
    end;
    KindHostInterfaceVar:
    begin
      I := GetVariant(ID);

      if I > 0 then
      begin
        DefList := DefinitionList;
        DI := TPaxInterfaceVarDefinition(DefList[I]);
      end
      else
      begin
        DefList := TPaxBaseScripter(Scripter).LocalDefinitions;
        DI := TPaxInterfaceVarDefinition(DefList.GetRecordByIndex(- I));
      end;

      result := DI.Value;
    end
    else
      result := GetVariant(ID);
    end;
end;

procedure TPAXSymbolTable.PutValue(ID: Integer; const Val: Variant);
var
  Base: Variant;
  SO: TPAXScriptObject;
  DV: TPaxVariableDefinition;
  DOB: TPaxObjectDefinition;
  I: Integer;
  DefList: TPaxDefinitionList;
begin
  case GetKind(ID) of
    KindRef:
    begin
      Base := GetVariant(ID);
      if VarIsNull(Base) or VarIsEmpty(Base) then
        raise TPAXScriptFailure.Create(errIncompatibleTypes);

      SO := VariantToScriptObject(Base);
      SO.PutProperty(NameIndex[ID], Val, 0);
    end;
    KindHostVar:
    begin
      I := GetVariant(ID);

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

      DV.SetValue(Scripter, Val);
    end;
    KindHostConst:
    begin
      raise TPAXScriptFailure.Create(Format(errCannotWriteReadOnlyProperty, [GetName(ID)]));
    end;
    KindHostObject:
    begin
      I := GetVariant(ID);

      if I > 0 then
      begin
        DefList := DefinitionList;
        DOB := TPaxObjectDefinition(DefList[I]);
      end
      else
      begin
        DefList := TPaxBaseScripter(Scripter).LocalDefinitions;
        DOB := TPaxObjectDefinition(DefList.GetRecordByIndex(- I));
      end;

      DOB.Value := Val;
    end;
    KindHostInterfaceVar:
    begin
    end
    else
      PutVariant(ID, Val);
    end;
end;

procedure TPAXSymbolTable.Dump(const FileName: String);
const
  V = '|';
var
  T: Text;
procedure WriteLine(I: Integer);

function StrAddr: String;
begin
  if A[I].Address = nil then
    result := 'nil'
  else
    result := IntToStr(Integer(A[I].Address)-Integer(Mem));
end;

function StrLocal: String;
begin
  if A[I].Local > 0 then
    result := 'L'
  else
    result := ' ';
end;

begin
  writeln( T, '' );

  if I > Card then
  begin
    write(T, I:6);
    Exit;
  end;

  try
  with A[I] do
  begin
    write(T, I:5, V,
            Norm(GetName(I), 12), V,
            Norm(GetStrKind(I), 3), V,
            StrLocal, V,
            Norm(GetStrType(I), 9), ':', PType:4, V,
            Misc:4, V,
            Count:4, V,
            Rank:2, V,
            Next:5, V,
            Level:5, V,
            Module:2, V,
            Position:5, V,
            Norm(StrAddr, 8), V,
            Owner:5, V,
            GetStrVal(I));
  end;
  except
    I := 0;
  end;
end;

procedure Header;
begin
  writeln(T,'____N', V,
            '        Name', V,
            'Knd', V,
            'L', V,
            '          Type', V,
            'Misc', V,
            ' Cnt', V,
            'Rn', V,
            ' Next', V,
            'Level', V,
            'Md', V,
            '  Pos', V,
            '   Addr', V,
            'Owner', V,
            'Value' );
end;

var
  I: Integer;
begin
  AssignFile(T, FileName);
  Rewrite(T);

  try
    Header;

    for I:=0 to Card do
    begin
      WriteLine(I);
    end;

    writeln(T, '');
    writeln(T, '');
    Header;

    writeln(T, '');
    writeln(T, '');
    write(T, 'CreateCard ', CreateCard);
    writeln(T, '');
    write(T, 'MemBoundVar ', MemBoundVar);
    writeln(T, '');

    writeln(T, '');
    writeln(T, '');
    for I:=0 to NameList.Count - 1 do
    begin
      writeln(T, I:5, ' ', NameList[I]);
    end;

  finally
    CloseFile(T);
  end;
end;

function _GetName(NameIndex: Integer; Scripter: Pointer): String;
begin
  result := TPaxBaseScripter(Scripter).NameList[NameIndex];
end;

procedure TPAXSymbolTable.SetupSubs(StartRecNo: Integer);
var
  ClassRec: TPAXClassRec;
  ClassList: TPAXClassList;
  I: Integer;
  V: Variant;
  D: TPAXMethodDefinition;
  J, N: Integer;
  SO: TPAXScriptObject;
begin
  ClassList := TPAXBaseScripter(Scripter).ClassList;

  if ClassList.DelegateClassRec = nil then
    raise TPAXScriptFailure.Create(Format(errClassIsNotImported, ['Delegate']));

  for I:=StartRecNo to Card do
    if Kind[I] = KindSUB then
    begin
      V := GetVariant(I);

      if not IsObject(V) then
      begin
        D := nil;
        N := V;
        if N = 0 then
        begin
          ClassRec := ClassList.FindClass(Level[I]);
          if ClassRec <> nil then
            for J:=0 to ClassRec.MemberList.Count - 1 do
              if ClassRec.MemberList[J].Kind = KindSUB then
              if StrEql(Name[I], _GetName(ClassRec.MemberList.NameID[J], Scripter)) then
              begin

                D := TPaxMethodDefinition.Create(nil, Name[GetDllProcID(I)], nil,
                                                 Count[I], nil, true);
                if D.LoadFromDll(Scripter, I) then
                  ClassRec.MemberList[J].Definition := D;
              end;
        end;
        SO := TPAXScriptObject.Create(ClassList.DelegateClassRec);
        SO.Instance := TPAXDelegate.Create(Scripter, I, N, D);
        SO.PClass := TPAXDelegate;
        SO.PutProperty(CreateNameIndex('Name', Scripter), Name[I], 0);
        PutVariant(I, ScriptObjectToVariant(SO));
      end;
      
    end;
end;

function TPAXSymbolTable.TypeCast(TypeID: Integer; const Value: Variant): Variant;
var
  C: TPaxClassRec;
  SO: TPaxScriptObject;
  S: String;
  I: IUnknown;
begin
  if (TypeID > 0) and (TypeID <= PaxTypes.Count) then
  case TypeID of
    typeINTEGER, typeWORD, typeSHORTINT, typeSMALLINT: result := ToInteger(Value);
    typeBOOLEAN: result := ToBoolean(Value);
    typeSTRING: result := ToString(Value);
    typeDOUBLE, typeCARDINAL, typeINT64: result := ToNumber(Value);
  end
  else
  begin
    result := Value;
    if IsObject(result) then
    begin
      S := GetName(TypeID);
      C := TPaxBaseScripter(Scripter).ClassList.FindClassByName(S);
      if C <> nil then
      begin
        SO := VariantToScriptObject(result);
        SO.ClassRec := C;

        if SO.Intf <> nil then if C.fClassDef <> nil then
        begin
          SO.Intf.QueryInterface(C.fClassDef.guid, I);
          SO.Intf := I;
        end;
      end;
    end;
  end;
end;

function TPAXSymbolTable.IsVirtual(SubId: Integer): Boolean;
var
  L: Integer;
  C: TPaxClassRec;
  M: TPaxMemberRec;
  D: TPaxDefinition;
begin
  result := false;
  if SubId > 0 then
  begin
    if A[SubId].IsVirtual then
    begin
      result := true;
      Exit;
    end;

    L := Level[SubId];
    C := TPaxBaseScripter(Scripter).ClassList.FindClass(L);
    if C <> nil then
    begin
      M := C.MemberList.GetMemberRecByID(SubId);
      if M <> nil then
        result := modVIRTUAL in M.ml;
    end;
  end
  else
  begin
    D := DefinitionList[-SubId];
    result := modVIRTUAL in D.ml;
  end;
end;

function TPAXSymbolTable.NameList: TPaxNameList;
begin
  result := TPaxBaseScripter(Scripter).NameList;
end;

procedure TPAXSymbolTable.InitGlobalVars;
var
  I, T: Integer;
  V: Variant;
begin
  for I:=1 to Card do
    if Kind[I] = KindVAR then
//      if not IsLocal(I) then
        if Pos('$', Name[I]) = 0 then
        begin
          V := GetVariant(I);
          if VarType(V) = varEmpty then
          begin
            T := PType[I];
            if T = typeINTEGER then
              PutVariant(I, 0)
            else if T = typeDOUBLE then
              PutVariant(I, 0.0)
            else if T = typeSTRING then
              PutVariant(I, '')
            else if T = typeBOOLEAN then
              PutVariant(I, false);
          end;
        end;
end;


function TPAXSymbolTable.GetJSIndex(I: Integer): Boolean;
begin
  if (I >= 1) and (I <= Card) then
    result := A[I].JSIndex
  else
    result := false;
end;

procedure TPAXSymbolTable.SetJSIndex(I: Integer; Value: Boolean);
begin
  if (I >= 1) and (I <= Card) then
    A[I].JSIndex := Value;
end;

end.
