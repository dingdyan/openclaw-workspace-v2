{******************************************************************************}
{                                                                              }
{               (W) Component Library                                          }
{               Strings functions                                              }
{               Copyright (C) 2000-2002 Yuriy Shcherbakov                      }
{               All rights reserved.                                           }
{******************************************************************************}

unit uWStringFunctions;

interface

Uses SysUtils;

  { Strings }

  function IsReservedWord(aText : String) : boolean;
  function IsStandardDirective(aText : String) : boolean;
  function StrShrink(aText : String; aCount : Integer) : String;
  function FirstCapitalLetter(aText : String) : String;

  { Cuts and returns a first word from aText string using aSeparator char.
    Example:
     A := 'Mama Mia';
     B := CutWord(A, ' ');   //B = 'Mama', A = 'Mia'
   }

  function CutWord(var aText : String; aSeparator : Char; aTrimResult : boolean = True) : String;
  function GetOnlyDigitsAndSymbols(aText : String) : String;
  function CutLastSlash(aPath : String) : String;

  {*$ Returns string representation of boolean value. }
  function BoolToStr(aValue : boolean;
    aTrue : String = 'True'; aFalse : String = 'False') : String;

type
  TAllowedCharacters = Set of Char;
  {*$ Returns a string where all not allowed characters are removed. }
  function GetOnlyAllowedCharacters(aText : String;
    aAllowedCharactes : TAllowedCharacters) : String;

implementation

const
  sReservedWords : array [0..71] of String = (
        'and', 'array', 'as', 'asm', 'begin', 'case', 'class', 'const',
        'constructor', 'destructor', 'dispinterface', 'div', 'do',
        'downto', 'else', 'end', 'except', 'exports', 'file', 'finalization',
        'finally', 'for', 'function', 'goto', 'if', 'implementation', 'in',
        'inherited', 'initialization', 'inline', 'interface', 'is', 'label',
        'library', 'mod', 'nil', 'not', 'object', 'of', 'or', 'out', 'packed',
        'procedure', 'program', 'property', 'raise', 'record', 'repeat',
        'resourcestring', 'set', 'shl', 'shr', 'string', 'then', 'threadvar',
        'to', 'try', 'type', 'unit', 'until', 'uses', 'var', 'while', 'with',
        'xor', 'private', 'protected', 'public', 'published', 'automated',
        'at', 'on');
const
  sStandardDirectives : array [0..5] of String = (
        'DEFINE', 'UNDEF', 'IFDEF', 'ELSE', 'ENDIF', 'IFOPT');

function IsReservedWord(aText : String) : boolean;
var
  i : integer;
begin
  Result := True;
  aText := LowerCase(aText);
  for i := Low(sReservedWords) to High(sReservedWords) do
    if sReservedWords[i] = aText then Exit;
  Result := False;
end;

function IsStandardDirective(aText : String) : boolean;
var
  i : integer;
begin
  Result := True;
  aText := LowerCase(aText);
  for i := Low(sStandardDirectives) to High(sStandardDirectives) do
    if sStandardDirectives[i] = aText then Exit;
  Result := False;
end;

function StrShrink(aText : String; aCount : Integer) : String;
begin
  if aCount < Length(aText) then
    Result := Trim(Copy(aText, 1, Length(aText) - aCount))
  else
    Result := '';
end;

function FirstCapitalLetter(aText : String) : String;
begin
  if aText <> '' then
    Result := UpperCase(aText[1]) + Copy(aText, 2, Length(aText) - 1)
  else
    Result := '';
end;

function CutWord(var aText : String; aSeparator : Char; aTrimResult : boolean) : String;
var
  P : Integer;
begin
  if aTrimResult then aText := Trim(aText);
  P := Pos(aSeparator, aText);
  if P = 0 then P := Length(aText) + 1;
  Result := Copy(aText, 1, P - 1);
  Delete(aText, 1, P);
  if aTrimResult then aText := Trim(aText);
end;

function GetOnlyDigitsAndSymbols(aText : String) : String;
var
  i : Integer;
begin
  Result := '';
  if aText <> '' then
    for i := 1 to Length(aText) do
      if aText[i] in ['a'..'z', 'A'..'Z', '0'..'9'] then
        Result := Result + aText[i];
end;

function CutLastSlash(aPath : String) : String;
begin
  if aPath[Length(aPath)] = '\' then SetLength(aPath, Length(aPath) - 1);
  Result := aPath;
end;

function BoolToStr(aValue : boolean; aTrue : String = 'True'; aFalse : String = 'False') : String;
begin
  if aValue then Result := aTrue else Result := aFalse;
end;

function GetOnlyAllowedCharacters(aText : String; aAllowedCharactes : TAllowedCharacters) : String;
var
  i : Integer;
begin
  Result := '';
  if Length(aText) > 0 then
    for i := 1 to Length(aText) do
      if aText[i] in aAllowedCharactes then
        Result := Result + aText[i];
end;

end.
