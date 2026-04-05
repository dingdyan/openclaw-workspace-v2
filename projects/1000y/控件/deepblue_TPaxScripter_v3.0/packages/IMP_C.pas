////////////////////////////////////////////////////////////////////////////
// PAXScript Importing
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: IMP_C.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////


unit IMP_C;
interface
uses
  BASE_EXTERN,
  Math,
  SysUtils,
  PaxScripter;

implementation

{ math function }

function _random(B1, B2: Integer): Integer;
begin
  result := B1 + Random(B2 - B1);
end;

function _abs(const I: Integer): Integer;
begin
  result := Abs(I);
end;

{ exponential functions }

procedure _sqrt(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
     result.PValue^  := sqr(Params[0].AsDouble);
end;

procedure _log(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := Ln(Params[0].PValue^);
end;

procedure _exp(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := exp(Params[0].PValue^);
end;

{trigonometric functions}

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

procedure _sinh(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := Sinh(Params[0].PValue^);
end;

procedure _atan2(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := ArcTan2(Params[0].PValue^, Params[1].PValue^);
end;

procedure _atan(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := ArcTan(Params[0].PValue^);
end;

procedure _acos(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := ArcCos(Params[0].PValue^);
end;

procedure _asin(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := ArcSin(Params[0].PValue^);
end;

procedure _tan(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := Tan(Params[0].PValue^);
end;

procedure _cos(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := Cos(Params[0].PValue^);
end;

procedure _sin(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.PValue^ := Sin(Params[0].PValue^);
end;

{ char functions }

{function _toupper(C: Char): Char;
begin
  result := UpCase(C);
end;}

function _isspace(C: Char): Boolean;
begin
  result := C in [#32,#8,#13,#10];
end;

function _islower(C: Char): Boolean;
begin
  result := C in ['a'..'z'];
end;

function _isupper(C: Char): Boolean;
begin
  result := C in ['A'..'Z'];
end;

{function _tolower(C: Char): Char;
begin
  if (C >= 'A') and (C <= 'Z') then Inc(C, 32);
  result := C;
end;}

function _isalnum(C: Char): Boolean;
begin
  result := C in ['0'..'9','a'..'z','A'..'Z'];
end;

function _isalpha(C: Char): Boolean;
begin
  result := C in ['a'..'z','A'..'Z'];
end;

function _isnum(C: Char): Boolean;
begin
  result := C in ['0'..'9'];
end;

{ string functions }

function _atof(const S: String): Variant;
begin
  result := StrToFloat(S);
end;

function _atoi(const S: String): Variant;
begin
  result := StrToInt(S);
end;

function _atol(const S: String): Int64;
begin
  result := StrToInt64(S);
end;

function _strlen(S: String): Integer;
begin
  result := Length(S);
end;

function _strncpy(S1: PChar; const S2: PChar; I: Integer): PChar;
begin
  result := StrLCopy(S1, S2, I);
end;

function _toupper(S: String): String;
begin
  result := UpperCase(S);
end;

function _tolower(S: String): String;
begin
  result := LowerCase(S);
end;

{ directory functions}

function _getdir: string;
var
  s: string;
begin
  GetDir(0, S);
  result := s;
end;

procedure _rmdir(S: String);
begin
  RmDir(S);
end;

procedure _mkdir(S: String);
begin
  MkDir(S);
end;

procedure _chdir(S: String);
begin
  ChDir(S);
end;

{ file functions }

function _remove(S: String): Boolean;
begin
  result := DeleteFile(S);
end;

function _rename(S1, S2: String): Boolean;
begin
  result := RenameFile(S1, S2);
end;

function _fexists(S1: String): Boolean;
begin
  result := FileExists(S1);
end;

var
  H: Integer;
  NULL: Variant;


initialization

  Randomize;

  H := RegisterNamespace('paxCNamespace', -1);
  RegisterConstant('PI', PI, H);
  RegisterConstant('NULL', NULL, H);

  {math functions}
  RegisterRoutine('function abs(I: Integer): Integer;', @_abs, H);
  RegisterRoutine('function random(B1, B2: Integer): Integer;', @_random, H);

  {exponential functions}
  RegisterStdRoutine('sqrt', _sqrt, 1, H);
  RegisterStdRoutine('log', _log, 1, H);
  RegisterStdRoutine('exp', _exp, 1, H);

  {trigonometic functions}
  RegisterStdRoutine('tanh', _tanh, 1, H);
  RegisterStdRoutine('cosh', _cosh, 1, H);
  RegisterStdRoutine('sinh', _sinh, 1, H);
  RegisterStdRoutine('atan', _atan, 1, H);
  RegisterStdRoutine('acos', _acos, 1, H);
  RegisterStdRoutine('asin', _asin, 1, H);
  RegisterStdRoutine('atan2', _atan2, 2, H);
  RegisterStdRoutine('tan', _tan, 1, H);
  RegisterStdRoutine('cos', _cos, 1, H);
  RegisterStdRoutine('sin', _sin, 1, H);

  {char functions}
  RegisterRoutine('function isspace(C: Char): Boolean;', @_isspace, H);
  RegisterRoutine('function isupper(C: Char): Boolean;', @_isupper, H);
  RegisterRoutine('function islower(C: Char): Boolean;', @_islower, H);
//  RegisterRoutine('function toupper(C: Char): Char;', @_toupper, H);
//  RegisterRoutine('function tolower(C: Char): Char;', @_tolower, H);
  RegisterRoutine('function isalnum(C: Char): Boolean;', @_isalnum, H);
  RegisterRoutine('function isalpha(C: Char): Boolean;', @_isalpha, H);
  RegisterRoutine('function isnum(C: Char): Boolean;', @_isnum, H);

  {string functions}
  RegisterRoutine('function atof(S: String): Variant;', @_atof, H);
  RegisterRoutine('function atoi(S: String): Variant;', @_atoi, H);
  RegisterRoutine('function atol(S: String): Int64;', @_atol, H);
  RegisterRoutine('function strlen(S: String): Integer;', @_strlen, H);
  RegisterRoutine('function strncpy(S1: PChar; const S2: PChar; I: Integer): PChar;', @_strncpy, H);
  RegisterRoutine('function toupper(S: String): String;', @_toupper, H);
  RegisterRoutine('function tolower(S: String): String;', @_tolower, H);

  {directory functions}
  RegisterRoutine('function getdir: String;', @_getdir, H);
  RegisterRoutine('procedure rmdir(S: String);', @_rmdir, H);
  RegisterRoutine('function rndir(S1, S2: String): Boolean;', @_rename, H); // rename dir or file is still the same ;-)
  RegisterRoutine('procedure chdir(S: String);', @_chdir, H);
  RegisterRoutine('procedure mkdir(S: String);', @_mkdir, H);

  {file routines}
  RegisterRoutine('function remove(S: String): Boolean;', @_remove, H);
  RegisterRoutine('function rename(S1, S2: String): Boolean;', @_rename, H);
  RegisterRoutine('function fexists(S1: String): Boolean;', @_fexists, H);

  {misc}
end.
