////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: PAX_RTTI.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}

unit PAX_RTTI;
interface

uses
{$IFDEF VARIANTS}
  Variants,
{$ENDIF}

  SysUtils,
  Classes,
  BASE_CONSTS,
  BASE_SYS, BASE_CLASS, BASE_EXTERN, PaxScripter;

type
  TPaxPropKind = (pkAll, pkPublished, pkIndexed, pkStatic, pkImported);
  TPaxPropKindSet = set of TPaxPropKind;

procedure PutPaxObjectProperty(const O: Variant; const PropName: String;
                               const Value: Variant);
function GetPaxObjectProperty(const O: Variant; const PropName: String): Variant;
function GetPaxObjectPropertyAsString(const O: Variant; const PropName: String): String;

function GetPaxObjectPropertyCount(const O: Variant): Integer;
function GetPaxObjectPropertyNameByIndex(const O: Variant; Index: Integer): String;
function GetPaxObjectPropertyByIndex(const O: Variant; Index: Integer): Variant;
procedure PutPaxObjectPropertyByIndex(const O: Variant; Index: Integer;
                                      const Value: Variant);
function IsPaxObject(const V: Variant): boolean;
function GetPaxObjectClassName(const O: Variant): String;
function GetArrayValue(const A: Variant; Indexes: array of Integer): Variant;
procedure PutArrayValue(const A: Variant; const Indexes: array of Integer;
                        const Value: Variant);
function  GetArrayHighBound(const A: Variant; Dim:Integer): Integer;
function  GetArrayLowBound(const A: Variant; Dim:Integer): Integer;
procedure GetPaxPropNames(const O: Variant; L: TStringList;
                          PropKinds: TPaxPropKindSet = [pkAll]);
function CreateScriptObject(Scripter: TPaxScripter; const ClassName: String; DelphiInstance: TObject = nil): Variant;
function CreateScriptObjectEx(Scripter: TPaxScripter; const ClassName: String;
                              const Params: array of const): Variant;
function FindScriptObject(Scripter: TPaxScripter; DelphiInstance: TObject): Variant;

implementation

function IsPaxObject(const V: Variant): boolean;
begin
  result := IsObject(V);
end;

procedure PutPaxObjectProperty(const O: Variant; const PropName: String;
                               const Value: Variant);
var
  SO: TPAXScriptObject;
  NameIndex: Integer;
begin
  SO := VariantToScriptObject(O);
  NameIndex := CreateNameIndex(PropName, SO.Scripter);
  SO.PutProperty(NameIndex, Value, 0);
end;

function GetPaxObjectProperty(const O: Variant; const PropName: String): Variant;
var
  SO: TPAXScriptObject;
  NameIndex: Integer;
begin
  SO := VariantToScriptObject(O);
  NameIndex := CreateNameIndex(PropName, SO.Scripter);
  result := SO.GetProperty(NameIndex, 0);
end;

procedure PutPaxObjectPropertyByIndex(const O: Variant; Index: Integer;
                                      const Value: Variant);
var
  SO: TPAXScriptObject;
  P: TPAXProperty;
begin
  SO := VariantToScriptObject(O);
  P := SO.PropertyList.Properties[Index];
  P.Value[0] := Value;
end;

function GetPaxObjectPropertyByIndex(const O: Variant; Index: Integer): Variant;
var
  SO: TPAXScriptObject;
  P: TPAXProperty;
begin
  SO := VariantToScriptObject(O);
  P := SO.PropertyList.Properties[Index];
  result := P.Value[0];
end;

function GetPaxObjectPropertyNameByIndex(const O: Variant; Index: Integer): String;
var
  SO: TPAXScriptObject;
begin
  SO := VariantToScriptObject(O);
  result := SO.PropertyList.Names[Index];
end;

function GetPaxObjectPropertyCount(const O: Variant): Integer;
var
  SO: TPAXScriptObject;
begin
  SO := VariantToScriptObject(O);
  result := SO.PropertyList.Count;
end;

function GetPaxObjectClassName(const O: Variant): String;
var
  SO: TPAXScriptObject;
begin
  SO := VariantToScriptObject(O);
  result := SO.ClassRec.Name;
end;

function GetArrayValue(const A: Variant; Indexes: array of Integer): Variant;
var
  P: Pointer;
  SO: TPAXScriptObject;
  PaxArray: TPaxArray;
begin
  if IsVBArray(A) then
  begin
    P := ArrayGet(@A, Indexes);
    result := Variant(P^);
  end
  else
  begin
    SO := VariantToScriptObject(A);
    PaxArray := TPAXArray(SO.ExtraInstance);
    result := PaxArray.Get(Indexes);
  end;
end;

procedure PutArrayValue(const A: Variant; const Indexes: array of Integer;
                        const Value: Variant);
var
  SO: TPAXScriptObject;
  PaxArray: TPaxArray;
begin
  if IsVBArray(A) then
    ArrayPut(@A, Indexes, Value)
  else
  begin
    SO := VariantToScriptObject(A);
    PaxArray := TPAXArray(SO.ExtraInstance);
    PaxArray.Put(Indexes, Value);
  end;
end;

function  GetArrayHighBound(const A: Variant; Dim:Integer): Integer;
var
  SO: TPAXScriptObject;
  PaxArray: TPaxArray;
begin
  if IsVBArray(A) then
    result := GetArrayHighBound(A, Dim)
  else
  begin
    SO := VariantToScriptObject(A);
    PaxArray := TPAXArray(SO.ExtraInstance);
    result:=PaxArray.HighBound(dim);
  end;
end;

function  GetArrayLowBound(const A: Variant; Dim:Integer): Integer;
begin
  if IsVBArray(A) then
    result := GetArrayLowBound(A, Dim)
  else
    result := 0;
end;

procedure GetPaxPropNames(const O: Variant; L: TStringList;
                          PropKinds: TPaxPropKindSet = [pkAll]);
var
  SO: TPaxScriptObject;
  I, K, Kind: Integer;
  S: String;
  MemberRec: TPaxMemberRec;
  ok: boolean;
begin
  SO := VariantToScriptObject(O);
  K := SO.PropertyList.Count;
  for I:=0 to K - 1 do
  begin
    Kind := SO.PropertyList.Properties[I].GetKind;
    if Kind in [KindProp] then
    begin
      S := SO.PropertyList.Names[I];
      MemberRec := SO.PropertyList.Properties[I].MemberRec;
      ok := Pos('ON', UpperCase(S)) <> 1;

      if ok then
      begin
        if pkIndexed in PropKinds then
          ok := MemberRec.NParams > 0
        else
          ok := MemberRec.NParams = 0;
      end;

      if ok then
      begin
        if pkImported in PropKinds then
          ok := MemberRec.IsImported
        else
          ok := not MemberRec.IsImported;
      end;

      if ok then
      begin
        if pkPublished in PropKinds then
          ok := MemberRec.IsPublished
        else
          ok := not MemberRec.IsPublished;
      end;

      if ok then
      begin
        if pkStatic in PropKinds then
          ok := MemberRec.IsStatic
        else
          ok := not MemberRec.IsStatic;
      end;

      if pkAll in PropKinds then
        ok := true;

      if ok then
        L.Add(S);
    end;
  end;
end;

function GetPaxObjectPropertyAsString(const O: Variant; const PropName: String): String;
var
  SO: TPaxScriptObject;
  V: Variant;
begin
  SO := VariantToScriptObject(O);
  V := GetPaxObjectProperty(O, PropName);
  result := ToStr(SO.Scripter, V);
end;

function FindScriptObject(Scripter: TPaxScripter; DelphiInstance: TObject): Variant;
var
  SO: TPaxScriptObject;
begin
  SO := Scripter.fScripter.ScriptObjectList.FindScriptObject(DelphiInstance);
  if SO <> nil then
    result := ScriptObjectToVariant(SO)
  else
    result := Undefined;
end;

function CreateScriptObject(Scripter: TPaxScripter; const ClassName: String; DelphiInstance: TObject = nil): Variant;
var
  ClassRec: TPaxClassRec;
  SO: TPaxScriptObject;
  ID: Integer;
begin
  if Pos('.', ClassName) <= 0 then
    ClassRec := Scripter.fScripter.ClassList.FindClassByName(ClassName)
  else
  begin
    ID := scripter.GetMemberID(ClassName);
    ClassRec := Scripter.fScripter.ClassList.FindClass(ID);
  end;

  if ClassRec <> nil then
  begin
    SO := ClassRec.CreateScriptObject();
    SO.Instance := DelphiInstance;
    result := ScriptObjectToVariant(SO);
  end
  else
    raise TPaxScriptFailure.Create(Format(errClassIsNotFound, [ClassName]));
end;

function CreateScriptObjectEx(Scripter: TPaxScripter; const ClassName: String;
                              const Params: array of const): Variant;
var
  ClassRec: TPaxClassRec;
  SubID, ID: Integer;
begin
  result := CreateScriptObject(Scripter, ClassName);

  if Pos('.', ClassName) <= 0 then
    ClassRec := Scripter.fScripter.ClassList.FindClassByName(ClassName)
  else
  begin
    ID := scripter.GetMemberID(ClassName);
    ClassRec := Scripter.fScripter.ClassList.FindClass(ID);
  end;

  if ClassRec <> nil then
  begin
    SubID := ClassRec.GetConstructorIDEx(Params);
    if SubID <> 0 then
      Scripter.fScripter.CallMethod(SubID, result, Params, false)
    else
      raise TPaxScriptFailure.Create(Format(errConstructorIsNotFound, [ClassName]));
  end
  else
    raise TPaxScriptFailure.Create(Format(errClassIsNotFound, [ClassName]));
end;

end.
