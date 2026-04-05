////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_DLL.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit BASE_DLL;
interface
uses
{$IFDEF WIN32}
  Windows,
{$ENDIF}

{$ifdef FP}
  dynlibs,
{$ENDIF}

  SysUtils,
  Classes;

type
  TPaxDllRec = class
  public
    DllName: String;
    Handle: THandle;
  end;

  TPaxDllList = class
  private
    fDllList: TList;
    function GetRecord(I: Integer): TPaxDllRec;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function FindDllByName(const DllName: String): TPaxDllRec;
    function LoadDll(const DllName: String; scripter: Pointer): TPaxDllRec;
    property Records[I: Integer]: TPaxDllRec read GetRecord; default;
    property Count: Integer read GetCount;
  end;

implementation

uses BASE_SCRIPTER, PaxScripter;

constructor TPaxDllList.Create;
begin
  fDllList := TList.Create;
end;

function TPaxDllList.GetRecord(I: Integer): TPaxDllRec;
begin
  result := TPaxDllRec(fDllList[I]);
end;

function TPaxDllList.GetCount: Integer;
begin
  result := fDllList.Count;
end;

function TPaxDllList.FindDllByName(const DllName: String): TPaxDllRec;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    if CompareText(Records[I].DllName, DllName) = 0 then
    begin
      result := Records[I];
      Exit;
    end;
  result := nil;
end;

function TPaxDllList.LoadDll(const DllName: String; scripter: Pointer): TPaxDllRec;

function _LoadDll(const DllName: String): TPaxDllRec;
var
  Handle: THandle;
begin
  result := FindDllByName(DllName);
  if result <> nil then
    Exit;

{$IFDEF FP}
   Handle := HMODULE(dynlibs.LoadLibrary(DLLName));
{$ELSE}
   Handle := LoadLibrary(PChar(DllName));
 {$ENDIF}

  if Handle > 0 then
  begin
    result := TPaxDllRec.Create;
    result.Handle := Handle;
    result.DllName := DllName;
    fDllList.Add(result);
  end
  else
    result := nil;
end;

var
  S: TPaxScripter;
  I: Integer;
begin
  result := _LoadDll(DllName);
  if result <> nil then
    Exit;

  S := TPaxScripter(TPaxBaseScripter(scripter).Owner);
  if S.SearchPathes.Count = 0 then
    Exit;

  for I:=0 to S.SearchPathes.Count - 1 do
  begin
    result := _LoadDll(S.SearchPathes[I] + DllName);
    if result <> nil then
      Exit;
  end;
end;

destructor TPaxDllList.Destroy;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
  begin
    FreeLibrary(Records[I].Handle);
    Records[I].Free;
  end;
  fDllList.Free;
end;

end.