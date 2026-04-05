////////////////////////////////////////////////////////////////////////////
// PAXScript Importing
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: IMP_Pascal.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit IMP_Pascal;
interface
uses
{$IFDEF VARIANTS}
  Variants,
{$ENDIF}
  SysUtils,
  Classes,
  Math,
  BASE_SYS,
  BASE_CLASS,
  BASE_EXTERN,
  BASE_SCRIPTER,
  PaxScripter;

implementation

procedure _ArcCos(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := ArcCos(Params[0].PValue^);
end;

procedure _ArcTan(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := ArcTan(Params[0].PValue^);
end;

procedure _ArcTan2(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := ArcTan2(Params[0].PValue^, Params[1].PValue^);
end;

procedure _ArcSin(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := ArcSin(Params[0].PValue^);
end;

procedure _Cos(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := Cos(Params[0].PValue^);
end;

procedure _Tan(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := Tan(Params[0].PValue^);
end;

procedure _Sin(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := Sin(Params[0].PValue^);
end;

procedure _sinh(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := Sinh(Params[0].PValue^);
end;

procedure _tanh(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := Tanh(Params[0].PValue^);
end;

procedure _cosh(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := Cosh(Params[0].PValue^);
end;

function _Round(X: Extended): Int64;
begin
  result := Round(X);
end;

function _Int(X: Extended): Extended;
begin
  result := Int(X);
end;

function _Chr(X: Byte): Char;
begin
  result := Chr(X);
end;

procedure _Ord(MethodBody: TPAXMethodBody);
var
  V: Variant;
  S: String;
begin
  with MethodBody do
  begin
    V := Params[0].PValue^;
    if IsString(V) then
    begin
      S := toString(V);
      result.PValue^ := ord(S[1])
    end
    else
      result.PValue^ := toInteger(V);
  end;
end;

function _Abs(const X: Variant): Variant;
begin
  result := Abs(X);
end;

function _Exp(const X: Variant): Variant;
begin
  result := Exp(X);
end;

function _Ln(const X: Variant): Variant;
begin
  result := Ln(X);
end;

procedure _Sqr(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := sqr(Params[0].PValue^);
end;

function _Random(Range: Integer): Integer;
begin
  result := Random(Range);
end;

function _Trunc(X: Variant): integer;
begin
   result := trunc(X);
end;

procedure _Inc(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
  begin
    if ParamCount = 1 then
      Params[0].AsVariant := Params[0].AsVariant + 1
    else
      Params[0].AsVariant := Params[0].AsVariant + Params[1].AsVariant;
  end;
end;

procedure _Dec(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
  begin
    if ParamCount = 1 then
      Params[0].AsVariant := Params[0].AsVariant - 1
    else
      Params[0].AsVariant := Params[0].AsVariant - Params[1].AsVariant;
  end;
end;

procedure _Pos(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsInteger := Pos(Params[0].AsString, Params[1].AsString);
end;

procedure _Copy(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsString := Copy(Params[0].AsString, Params[1].AsInteger, Params[2].AsInteger);
end;

procedure _Delete(MethodBody: TPAXMethodBody);
var
  S: String;
begin
  with MethodBody do
  begin
    S := Params[0].AsString;
    Delete(S, Params[1].AsInteger, Params[2].AsInteger);
    Params[0].AsString := S;
  end;
end;

procedure _Insert(MethodBody: TPAXMethodBody);
var
  S: String;
begin
  with MethodBody do
  begin
    S := Params[1].AsString;
    Insert(Params[0].AsString, S, Params[2].AsInteger);
    Params[1].AsString := S;
  end;
end;

type
  TFileKind = (fkText, fkFile);

  TFileWrapper = class
    T: TextFile;
    F: File;
    FileKind: TFileKind;
    constructor Create(FileKind: TFileKind);
  end;

  TextFile = class
  end;

function GetFileWrapper(const V: Variant): TFileWrapper;
var
  SO: TPAXScriptObject;
begin
  if not IsObject(V) then
    raise Exception.Create('Incompatible types');
  SO := VariantToScriptObject(V);
  if SO.ClassRec.Name <> 'TFileWrapper' then
    raise Exception.Create('Incompatible types');
  result := TFileWrapper(SO.Instance);
end;

function GetTextFileWrapper(const V: Variant): TFileWrapper;
var
  SO: TPAXScriptObject;
begin
  result := nil;
  if not IsObject(V) then
    Exit;
  SO := VariantToScriptObject(V);
  if SO.ClassRec.Name <> 'TFileWrapper' then
    Exit;
  result := TFileWrapper(SO.Instance);
  if result.FileKind <> fkText then
    result := nil;
end;

constructor TFileWrapper.Create(FileKind: TFileKind);
begin
  inherited Create;
  Self.FileKind := FileKind;
end;

procedure _AssignFile(MethodBody: TPAXMethodBody);
var
  FW: TFileWrapper;
  V: Variant;
  FileKind: TFileKind;
  SO: TPAXScriptObject;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);
      if SO.ClassRec.Name = 'TextFile' then
        FileKind := fkText
      else if SO.ClassRec.Name = 'File' then
        FileKind := fkFile
      else
        raise Exception.Create('Incompatible types');
      TPAXBaseScripter(Scripter).ScriptObjectList.RemoveObject(SO);
    end
    else
      FileKind := fkText;

    FW := TFileWrapper.Create(FileKind);
    Assign(FW.T, Params[1].AsString);
    Params[0].AsVariant := ScriptObjectToVariant(DelphiInstanceToScriptObject(FW, Scripter));
  end;
end;

procedure _Eoln(MethodBody: TPAXMethodBody);
var
  FW: TFileWrapper;
begin
  with MethodBody do
  begin
    FW := GetFileWrapper(Params[0].AsVariant);
    if FW.FileKind = fkText then
      Result.AsVariant := Eoln(FW.T)
    else
      raise Exception.Create('Incompatible types');
  end;
end;

procedure _SeekEoln(MethodBody: TPAXMethodBody);
var
  FW: TFileWrapper;
begin
  with MethodBody do
  begin
    FW := GetFileWrapper(Params[0].AsVariant);
    if FW.FileKind = fkText then
      Result.AsVariant := SeekEoln(FW.T)
    else
      raise Exception.Create('Incompatible types');
  end;
end;

procedure _Eof(MethodBody: TPAXMethodBody);
var
  FW: TFileWrapper;
begin
  with MethodBody do
  begin
    FW := GetFileWrapper(Params[0].AsVariant);
    if FW.FileKind = fkText then
      Result.AsVariant := Eof(FW.T)
    else
      raise Exception.Create('Incompatible types');
  end;
end;

procedure _SeekEof(MethodBody: TPAXMethodBody);
var
  FW: TFileWrapper;
begin
  with MethodBody do
  begin
    FW := GetFileWrapper(Params[0].AsVariant);
    if FW.FileKind = fkText then
      Result.AsVariant := SeekEof(FW.T)
    else
      raise Exception.Create('Incompatible types');
  end;
end;

procedure _Append(MethodBody: TPAXMethodBody);
var
  FW: TFileWrapper;
begin
  with MethodBody do
  begin
    FW := GetFileWrapper(Params[0].AsVariant);
    if FW.FileKind = fkText then
      Append(FW.T)
    else
      raise Exception.Create('Incompatible types');
  end;
end;

procedure _Flush(MethodBody: TPAXMethodBody);
var
  FW: TFileWrapper;
begin
  with MethodBody do
  begin
    FW := GetFileWrapper(Params[0].AsVariant);
    if FW.FileKind = fkText then
      Flush(FW.T)
    else
      raise Exception.Create('Incompatible types');
  end;
end;

procedure _Reset(MethodBody: TPAXMethodBody);
var
  FW: TFileWrapper;
begin
  with MethodBody do
  begin
    FW := GetFileWrapper(Params[0].AsVariant);
    case FW.FileKind of
      fkText: Reset(FW.T);
      fkFile: Reset(FW.F);
    end;
  end;
end;

procedure _Rewrite(MethodBody: TPAXMethodBody);
var
  FW: TFileWrapper;
begin
  with MethodBody do
  begin
    FW := GetFileWrapper(Params[0].AsVariant);
    case FW.FileKind of
      fkText: Rewrite(FW.T);
      fkFile: Rewrite(FW.F);
    end;
  end;
end;

procedure _CloseFile(MethodBody: TPAXMethodBody);
var
  FW: TFileWrapper;
  SO: TPAXScriptObject;
begin
  with MethodBody do
  begin
    FW := GetFileWrapper(Params[0].AsVariant);
    SO := VariantToScriptObject(Params[0].AsVariant);
    case FW.FileKind of
      fkText: CloseFile(FW.T);
      fkFile: CloseFile(FW.F);
    end;
    FW.Free;
    TPAXBaseScripter(Scripter).ScriptObjectList.RemoveObject(SO);

    Params[0].AsVariant := Undefined;
  end;
end;

procedure _Writeln(MethodBody: TPAXMethodBody);
var
  I: Integer;
  S: String;
  L: TStringList;
  FW: TFileWrapper;
begin
  S := '';
  L := TStringList.Create;
  try
    with MethodBody do
    begin
      if ParamCount > 0 then
      begin
        FW := GetTextFileWrapper(Params[0].AsVariant);
        if FW <> nil then
        begin
          for I:=1 to ParamCount - 1 do
            S := S + toString(Params[I].AsVariant);
          Writeln(FW.T, S);
          Exit;
        end;
      end;

      for I:=0 to ParamCount - 1 do
        S := S + toString(Params[I].AsVariant);
      with TPAXBaseScripter(MethodBody.Scripter) do
        if Assigned(OnPrint) then
        begin
          OnPrint(Owner, S);
          OnPrint(Owner, #13#10);
        end
        else
          ErrMessageBox(S);
    end;
  finally
    L.Free;
  end;
end;

procedure _Write(MethodBody: TPAXMethodBody);
var
  I: Integer;
  S: String;
  L: TStringList;
  FW: TFileWrapper;
begin
  S := '';
  L := TStringList.Create;
  try
    with MethodBody do
    begin
      if ParamCount > 0 then
      begin
        FW := GetTextFileWrapper(Params[0].AsVariant);
        if FW <> nil then
        begin
          for I:=1 to ParamCount - 1 do
            S := S + toString(Params[I].AsVariant);
          Write(FW.T, S);
          Exit;
        end;
      end;

      for I:=0 to ParamCount - 1 do
        S := S + toString(Params[I].AsVariant);
      L.Add(S);

      with TPAXBaseScripter(MethodBody.Scripter) do
        if Assigned(OnPrint) then
          OnPrint(Owner, S)
        else
          ErrMessageBox(S);
    end;
  finally
    L.Free;
  end;
end;

procedure _Read(MethodBody: TPAXMethodBody);
var
  I: Integer;
  S: String;
  FW: TFileWrapper;
begin
  with MethodBody do
  begin
    if ParamCount > 0 then
    begin
      FW := GetTextFileWrapper(Params[0].AsVariant);
      if FW <> nil then
      begin
        for I:=1 to ParamCount - 1 do
        begin
          Read(FW.T, S);
          Params[I].AsVariant := StringValueToVariant(S, Params[I].AsVariant);
        end;
        Exit;
      end;
    end;

    for I:=0 to ParamCount - 1 do
    begin
      with TPAXBaseScripter(MethodBody.Scripter) do
        if Assigned(OnPrint) then
          OnRead(Owner, S)
        else
          Read(S);
      Params[I].AsVariant := StringValueToVariant(S, Params[I].AsVariant);
    end;
  end;
end;

procedure _Readln(MethodBody: TPAXMethodBody);
var
  I: Integer;
  S: String;
  FW: TFileWrapper;
begin
  with MethodBody do
  begin
    if ParamCount > 0 then
    begin
      FW := GetTextFileWrapper(Params[0].AsVariant);
      if FW <> nil then
      begin
        for I:=1 to ParamCount - 1 do
        begin
          Readln(FW.T, S);
          Params[I].AsVariant := StringValueToVariant(S, Params[I].AsVariant);
        end;
        Exit;
      end;
    end;

    for I:=0 to ParamCount - 1 do
    begin
      with TPAXBaseScripter(MethodBody.Scripter) do
        if Assigned(OnPrint) then
          OnRead(Owner, S)
        else
          Readln(S);
      Params[I].AsVariant := StringValueToVariant(S, Params[I].AsVariant);
    end;
  end;
end;


var
  H: Integer;

initialization

  Randomize;

  H := RegisterNamespace('paxPascalNamespace', -1);

  RegisterConstant('Null', Null);

  RegisterConstant('varEmpty', varEmpty);
  RegisterConstant('varNull', varNull);
  RegisterConstant('varSmallint', varSmallint);
  RegisterConstant('varInteger', varInteger);
  RegisterConstant('varSingle', varSingle);
  RegisterConstant('varDouble', varDouble);
  RegisterConstant('varCurrency', varCurrency);
  RegisterConstant('varDate', varDate);
  RegisterConstant('varOleStr', varOleStr);
  RegisterConstant('varDispatch', varDispatch);
  RegisterConstant('varError', varError);
  RegisterConstant('varBoolean', varBoolean);
  RegisterConstant('varVariant', varVariant);
  RegisterConstant('varUnknown', varUnknown);
  RegisterConstant('varByte', varByte);
  RegisterConstant('varStrArg', varStrArg);
  RegisterConstant('varString', varString);
  RegisterConstant('varAny', varAny);
  RegisterConstant('varTypeMask', varTypeMask);
  RegisterConstant('varArray', varArray);
  RegisterConstant('varByRef', varByRef);

  RegisterStdRoutine('ArcCos', _ArcCos, 1, H);
  RegisterStdRoutine('ArcTan', _ArcTan, 1, H);
  RegisterStdRoutine('ArcTan2', _ArcTan2, 2, H);
  RegisterStdRoutine('ArcSin', _ArcSin, 1, H);
  RegisterStdRoutine('Cos', _Cos, 1, H);
  RegisterStdRoutine('Tan', _Tan, 1, H);
  RegisterStdRoutine('Sin', _Sin, 1, H);
  RegisterStdRoutine('Cosh', _Cosh, 1, H);
  RegisterStdRoutine('Tanh', _Tanh, 1, H);
  RegisterStdRoutine('Sinh', _Sinh, 1, H);

  RegisterStdRoutineEx2('Inc', _Inc, -1, [typeINTEGER], [true], H);
  RegisterStdRoutineEx2('Dec', _Dec, -1, [typeINTEGER], [true], H);
  RegisterStdRoutine('Pos', _Pos, 2, H);
  RegisterStdRoutine('Copy', _Copy, 3, H);
  RegisterStdRoutine('Delete', _Delete, 3, H);
  RegisterStdRoutine('Insert', _Insert, 3, H);

  RegisterRoutine('function Abs(const X: Variant): Variant;', @_Abs, H);
  RegisterRoutine('function Exp(const X: Variant): Variant;', @_Exp, H);
  RegisterRoutine('function Ln(const X: Variant): Variant;', @_Ln, H);
  RegisterStdRoutine('Sqr', _Sqr, 1, H);

  RegisterRoutine('function Trunc(const X: Variant): Integer;', @_Trunc, H);

  RegisterRoutine('function Random(Range: Integer): Integer;', @_Random, H);

  RegisterRoutine('function Chr(X: Byte): Char;', @_Chr);
  RegisterStdRoutine('Ord', _Ord, 1, H);

  RegisterClassType(TFileWrapper, -1);
  RegisterClassType(TextFile, -1);

  RegisterStdRoutine('AssignFile', _AssignFile, 2, H);
  RegisterStdRoutine('Eoln', _Eoln, 1, H);
  RegisterStdRoutine('SeekEoln', _SeekEoln, 1, H);
  RegisterStdRoutine('Eof', _Eof, 1, H);
  RegisterStdRoutine('SeekEof', _SeekEof, 1, H);
  RegisterStdRoutine('Append', _Append, 1, H);
  RegisterStdRoutine('Flush', _Flush, 1, H);
  RegisterStdRoutine('Reset', _Reset, 1, H);
  RegisterStdRoutine('Rewrite', _Rewrite, 1, H);
  RegisterStdRoutine('CloseFile', _CloseFile, 1, H);
  RegisterStdRoutine('write', _Write, -1, H);
  RegisterStdRoutine('writeln', _Writeln, -1, H);
  RegisterStdRoutine('read', _Read, -1, H);
  RegisterStdRoutine('readln', _Readln, -1, H);

  RegisterRoutine('function VarArrayCreate(const Bounds: array of Integer; VarType: Integer): Variant;',
                  @VarArrayCreate);
  RegisterRoutine('function VarArrayOf(const Values: array of Variant): Variant;',
                  @VarArrayOf);
  RegisterRoutine('function VarArrayDimCount(const A: Variant): Integer;',
                  @VarArrayDimCount);
  RegisterRoutine('function VarArrayLowBound(const A: Variant; Dim: Integer): Integer;',
                  @VarArrayLowBound);
  RegisterRoutine('function VarArrayHighBound(const A: Variant; Dim: Integer): Integer;',
                  @VarArrayHighBound);
  RegisterRoutine('function VarIsArray(const A: Variant): Boolean;',
                  @VarIsArray);

  RegisterRoutine('function Round(X: Extended): Int64;', @_Round);
  RegisterRoutine('function Int(X: Extended): Extended;', @_Int);
end.

