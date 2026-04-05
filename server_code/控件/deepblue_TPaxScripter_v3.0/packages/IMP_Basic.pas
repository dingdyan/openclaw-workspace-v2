////////////////////////////////////////////////////////////////////////////
// PAXScript Importing
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: IMP_Basic.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////


{$I PaxScript.def}

unit IMP_Basic;
interface
uses
{$IFDEF LINUX}
  QForms,
{$ENDIF}
{$IFDEF WIN32}
  Windows,
  {$IFNDEF FP}
  ComObj,
  {$ENDIF}
{$ENDIF}

{$ifdef VARIANTS}
  Variants,
{$endif}

  SysUtils,
  Classes,
  Math,
  BASE_SYS,
  BASE_CLASS,
  BASE_PARSER,
  BASE_EXTERN,
  BASE_SCRIPTER,
  PAX_BASIC,
  PaxScripter;

implementation

uses IMP_ActiveX;

const
  vbEmpty = 0;
  vbNull = 1;
  vbInteger = 2;
  vbLong = 3;
  vbSingle = 4;
  vbDouble = 5;
  vbCurrency = 6;
  vbDate = 7;
  vbString = 8;
  vbObject = 9;
  vbError = 10;
  vbBoolean = 11;
  vbVariant = 12;
  vbDataObject = 13;
  vbByte = 17;
  vbArray = 8192;

  vbGeneralDate = 0;
  vbLongDate = 1;
  vbShortDate = 2;
  vbLongTime = 3;
  vbShortTime = 4;

const
  MonthNames: array [1..12] of string =
  (
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
  );

  WeekDayNames: array [1..7] of string =
  (
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday'
  );

procedure _Abs(MethodBody: TPAXMethodBody);
var
  V: Variant;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    if V > 0 then
      result.AsVariant := V
    else
      result.AsVariant := -V;
  end;
end;

procedure _Sin(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Sin(Params[0].AsVariant);
end;

procedure _Tan(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Tan(Params[0].AsVariant);
end;

procedure _Sqr(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Sqr(Params[0].AsDouble);
end;


procedure _Atn(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Arctan(Params[0].AsVariant);
end;

procedure _CBool(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := ToBoolean(Params[0].AsVariant);
end;

procedure _CByte(MethodBody: TPAXMethodBody);
var
  I: Integer;
begin
  with MethodBody do
  begin
    I := ToInt32(Params[0].AsVariant);
    result.AsVariant := I mod 256;
  end;
end;

procedure _CCurr(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := ToNumber(Params[0].AsVariant);
end;

procedure _CDate(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := ToNumber(Params[0].AsVariant);
end;

procedure _CDbl(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := ToNumber(Params[0].AsVariant);
end;

procedure _Chr(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsString := Chr(Params[0].AsInteger);
end;

procedure _Cos(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Cos(Params[0].AsVariant);
end;

procedure _CreateObject(MethodBody: TPAXMethodBody);
begin
{$ifndef fp}
  with MethodBody do
  begin
    Self := ActiveXObject.Create(Scripter);
    ActiveXObject(Self).D := CreateOleObject(Params[0].AsString);
  end;
  {$endif}
end;

procedure _GetObject(MethodBody: TPAXMethodBody);
var
  ClassRec: TPaxClassRec;
  SO: TPaxScriptObject;
begin
{$ifndef fp}
  with MethodBody do
  begin
    ClassRec := TPAXBaseScripter(Scripter).ClassList.FindClassByName('ActiveXObject');
    if ClassRec <> nil then
    begin
      SO := TPAXScriptObject.Create(ClassRec);
      SO.Instance := ActiveXObject.Create(Scripter);
{$IFDEF WIN32}
      ActiveXObject(SO.Instance).D := GetActiveOleObject(Params[0].AsString);
{$ENDIF}
      result.AsVariant := ScriptObjectToVariant(SO);
    end;
  end;
{$endif}
end;

procedure _GetRef(MethodBody: TPAXMethodBody);
var
  S: String;
  I: Integer;
begin
  with MethodBody do
  begin
    S := ToString(Params[0].AsVariant);
    with TPaxBaseScripter(Scripter).SymbolTable do
      for I:=1 to Card do
        if Kind[I] = KindSUB then
        if StrEql(Name[I], S) then
        begin
          result.AsInteger := I;
          Exit;
        end;
  end;
end;

procedure _CSng(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := ToNumber(Params[0].AsVariant);
end;

procedure _Asc(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsInteger := Ord(Params[0].AsString[1]);
end;

procedure _CInt(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := ToInt32(Params[0].AsVariant);
end;

procedure _CLng(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := ToInt32(Params[0].AsVariant);
end;

procedure _Date(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Date;
end;

procedure _DateAdd(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Date;
end;

procedure _DateDiff(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Date;
end;

procedure _DatePart(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Date;
end;

procedure _DateSerial(MethodBody: TPAXMethodBody);
var
  Y, M, D: Word;
begin
  with MethodBody do
  begin
    Y := ToInt32(Params[0].AsVariant);
    M := ToInt32(Params[1].AsVariant);
    D := ToInt32(Params[2].AsVariant);
    result.AsVariant := EncodeDate(Y,M,D);
  end;
end;

procedure _DateValue(MethodBody: TPAXMethodBody);
var
  S: String;
begin
  with MethodBody do
  begin
    S := ToString(Params[0].AsVariant);
    result.AsVariant := StrToDate(S);
  end;
end;

procedure _Day(MethodBody: TPAXMethodBody);
var
  V: Variant;
  D: TDateTime;
  Y, M, Day: Word;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    if VarType(V) = varString then
      D := StrToDate(V)
    else
      D := ToNumber(V);
    DecodeDate(D, Y, M, Day);
    result.AsVariant := Day;
  end;
end;

procedure _Hour(MethodBody: TPAXMethodBody);
var
  V: Variant;
  D: TDateTime;
  Hour, Min, Sec, MSec: Word;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    if VarType(V) = varString then
      D := StrToTime(V)
    else
      D := ToNumber(V);
    DecodeTime(D, Hour, Min, Sec, MSec);
    result.AsVariant := Hour;
  end;
end;

procedure _TimeSerial(MethodBody: TPAXMethodBody);
var
  Hour, Min, Sec: Word;
begin
  with MethodBody do
  begin
    Hour := Params[0].AsInteger;
    Min := Params[0].AsInteger;
    Sec := Params[0].AsInteger;
    result.AsVariant := EncodeTime(Hour, Min, Sec, 0);
  end;
end;

procedure _TimeValue(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
  begin
    result.AsVariant := TimeToStr(Params[0].AsVariant);
  end;
end;

procedure _Minute(MethodBody: TPAXMethodBody);
var
  V: Variant;
  D: TDateTime;
  Hour, Min, Sec, MSec: Word;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    if VarType(V) = varString then
      D := StrToTime(V)
    else
      D := ToNumber(V);
    DecodeTime(D, Hour, Min, Sec, MSec);
    result.AsVariant := Min;
  end;
end;

procedure _Second(MethodBody: TPAXMethodBody);
var
  V: Variant;
  D: TDateTime;
  Hour, Min, Sec, MSec: Word;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    if VarType(V) = varString then
      D := StrToTime(V)
    else
      D := ToNumber(V);
    DecodeTime(D, Hour, Min, Sec, MSec);
    result.AsVariant := Sec;
  end;
end;

procedure _Month(MethodBody: TPAXMethodBody);
var
  V: Variant;
  D: TDateTime;
  Y, M, Day: Word;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    if VarType(V) = varString then
      D := StrToDate(V)
    else
      D := ToNumber(V);
    DecodeDate(D, Y, M, Day);
    result.AsVariant := M;
  end;
end;

procedure _MonthName(MethodBody: TPAXMethodBody);
var
  I: Integer;
  S: String;
  Short: Boolean;
begin
  with MethodBody do
  begin
    I := Params[0].AsInteger;
    S := MonthNames[I];
    Short := false;
    if ParamCount = 2 then
      Short := Params[1].AsBoolean;
    if Short then
      S := Copy(S, 1, 3);

    result.AsVariant := S;
  end;
end;

procedure _WeekDayName(MethodBody: TPAXMethodBody);
var
  I: Integer;
  S: String;
  Short: Boolean;
begin
  with MethodBody do
  begin
    I := Params[0].AsInteger;
    S := WeekDayNames[I];
    Short := false;
    if ParamCount = 2 then
      Short := Params[1].AsBoolean;
    if Short then
      S := Copy(S, 1, 3);

    result.AsVariant := S;
  end;
end;

procedure _Now(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Now;
end;

procedure _Time(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Time;
end;

procedure _Timer(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := GetTickCount;
end;

procedure _Weekday(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := DayOfWeek(Params[0].AsVariant);
end;

procedure _Substr(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsString := Copy(Params[0].AsString,
                            Params[1].AsInteger,
                            Params[2].AsInteger);
end;

procedure _StrComp(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsInteger := CompareText(Params[0].AsString, Params[1].AsString);
end;

procedure _String(MethodBody: TPAXMethodBody);
var
  ch: Char;
  I: Integer;
  S: String;
begin
  with MethodBody do
  begin
    S := '';
    ch := Params[0].AsString[1];
    for I:=1 to Params[0].AsInteger do
      S := S + ch;
    result.AsString := S;
  end;
end;

procedure _StrReverse(MethodBody: TPAXMethodBody);
var
  S1, S2: String;
  I: Integer;
begin
  with MethodBody do
  begin
    S1 := Params[0].AsString;
    S2 := '';
    for I := 1 to Length(S1) do
      S2 := S1[I] + S2;
    result.AsString := S2;
  end;
end;

procedure _Year(MethodBody: TPAXMethodBody);
var
  V: Variant;
  D: TDateTime;
  Y, M, Day: Word;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    if VarType(V) = varString then
      D := StrToDate(V)
    else
      D := ToNumber(V);
    DecodeDate(D, Y, M, Day);
    result.AsVariant := Y;
  end;
end;

procedure _Exp(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Exp(ToNumber(Params[0].AsVariant));
end;

procedure _Array(MethodBody: TPAXMethodBody);
var
  Values: array of Variant;
  I: Integer;
  PA: TPaxArray;
  SO: TPaxScriptObject;
begin
  with MethodBody do
  begin
    if TPaxBaseScripter(Scripter).Code.SignVBARRAYS then
    begin
      SetLength(Values, ParamCount);
      for I:=0 to ParamCount - 1 do
        Values[I] := Params[I].AsVariant;
      result.AsVariant := VarArrayOf(Values);
    end
    else
    begin
      PA := TPaxArray.Create([ParamCount - 1]);
      PA.Scripter := Scripter;
      for I:=0 to ParamCount - 1 do
        PA.Put([I], Params[I].AsVariant);

      SO := TPAXBaseScripter(Scripter).ArrayClassRec.CreateScriptObject;
      SO.RefCount := 1;
      SO.Instance := PA;
      result.AsVariant := ScriptObjectToVariant(SO);
    end;
  end;
end;

procedure _Filter(MethodBody: TPAXMethodBody);
var
  L: TStringList;
  V: Variant;
  S: String;
  Bounds: array of integer;
  I: Integer;
  InputStrings, Value: Variant;
  Include: Boolean;
  PA: TPaxArray;
  SO: TPaxScriptObject;
begin
  Include := false;
  with MethodBody do
  begin
    L := TStringList.Create;

    Value := ToString(Params[1].AsVariant);

    case ParamCount of
      2:
      begin
        Include := true;
      end;
      3:
      begin
        Include := ToBoolean(Params[2].AsVariant);
      end;
      4:
      begin
        Include := ToBoolean(Params[2].AsVariant);
      end;
    end;

    InputStrings := Params[0].AsVariant;
    if IsVBArray(InputStrings) then
    begin
      for I:=0 to VarArrayHighBound(V, 1) do
      begin
        S := ToString(InputStrings[I]);
        if Pos(String(Value), S) > 0 then
          if Include then
             L.Add(S);
      end;

      SetLength(Bounds, 2);
      Bounds[0] := 0;
      Bounds[1] := L.Count - 1;

      V := VarArrayCreate(Bounds, varVariant);
      for I:=0 to L.Count - 1 do
        V[I] := L[I];

      result.AsVariant := V;
    end
    else if IsPaxArray(InputStrings) then
    begin
      PA := VariantToScriptObject(InputStrings).Instance as TPaxArray;
      for I:=0 to PA.Length - 1 do
      begin
        S := ToString(PA.Get([I]));
        if Pos(String(Value), S) > 0 then
          if Include then
             L.Add(S);
      end;

      PA := TPaxArray.Create([L.Count - 1]);
      PA.Scripter := Scripter;
      for I:=0 to L.Count - 1 do
        PA.Put([I], L[I]);

      SO := TPAXBaseScripter(Scripter).ArrayClassRec.CreateScriptObject;
      SO.RefCount := 1;
      SO.Instance := PA;
      result.AsVariant := ScriptObjectToVariant(SO);
    end;
    L.Free;
  end;
end;

procedure _Join(MethodBody: TPAXMethodBody);
var
  V: Variant;
  S, Delim: String;
  I, K: Integer;
  PA: TPaxArray;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    S := '';
    Delim := ' ';
    if ParamCount = 2 then
      Delim := Params[1].AsString;

    if IsVBArray(V) then
    begin
      K := VarArrayHighBound(V, 1);
      for I:=0 to K do
      begin
        S := S + ToString(V[I]);
        if I < K then
          S := S + Delim;
      end;
    end
    else if IsPaxArray(V) then
    begin
      PA := VariantToScriptObject(V).Instance as TPaxArray;
      K := PA.Length - 1;
      for I:=0 to K do
      begin
        S := S + ToString(PA.Get([I]));
        if I < K then
          S := S + Delim;
      end;
    end;

    result.AsVariant := S;
  end;
end;

procedure _Split(MethodBody: TPAXMethodBody);
var
  V: Variant;
  S, R: String;
  Delim: Char;
  I: Integer;
  L: TStringList;
  PA: TPaxArray;
  SO: TPaxScriptObject;
begin
  with MethodBody do
  begin
    S := Params[0].AsString;
    Delim := ' ';
    if ParamCount >= 2 then
      Delim := Params[1].AsString[1];

    L := TStringList.Create;
    try
      R := '';
      I := 1;
      repeat
        if I > Length(S) then
        begin
          L.Add(S);
          break;
        end;
        if S[I] = Delim then
        begin
          R := Copy(S, 1, I - 1);
          L.Add(R);
          Delete(S, 1, I);
          R := '';
          I := 1;
          if S = '' then
            Break;
        end
        else
          Inc(I);
      until false;

      if TPaxBaseScripter(Scripter).Code.SignVBARRAYS then
      begin
        V := VarArrayCreate([0, L.Count - 1], varVariant);
        for I := 0 to L.Count - 1 do
          V[I] := L[I];
      end
      else
      begin
        PA := TPaxArray.Create([L.Count - 1]);
        PA.Scripter := Scripter;
        for I:=0 to L.Count - 1 do
          PA.Put([I], L[I]);

        SO := TPAXBaseScripter(Scripter).ArrayClassRec.CreateScriptObject;
        SO.RefCount := 1;
        SO.Instance := PA;
        V := ScriptObjectToVariant(SO);
      end;

    finally
      L.Free;
      result.AsVariant := V;
    end;
  end;
end;

procedure _LBound(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := 0;
end;

procedure _UBound(MethodBody: TPAXMethodBody);
var
  V: Variant;
  D: Integer;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    D := Params[1].AsInteger;
    if IsVBArray(V) then
      result.AsInteger := VarArrayHighBound(V, D)
    else if IsPaxArray(V) then
      result.AsInteger := (VariantToScriptObject(V).Instance as TPaxArray).Length - 1;
  end;
end;

procedure _LCase(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := LowerCase(Params[0].AsString);
end;

procedure _UCase(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := UpperCase(Params[0].AsString);
end;

procedure _Left(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Copy(Params[0].AsString, 1, Params[1].AsInteger);
end;

procedure _Right(MethodBody: TPAXMethodBody);
var
  R, S: String;
  I, L: Integer;
begin
  with MethodBody do
  begin
    S := Params[0].AsString;
    L := Params[1].AsInteger;

    if L > Length(S) then
      L := Length(S);

    R := '';
    for I:=Length(S) downto Length(S) - L + 1 do
      R := S[I] + R;

    result.AsVariant := R;
  end;
end;

procedure _RND(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
  begin
    if ParamCount = 2 then
      result.AsVariant := Random(Params[1].AsInteger - Params[0].AsInteger) + Params[0].AsInteger
    else
      result.AsVariant := Random(Params[0].AsInteger);
  end;
end;

procedure _Sgn(MethodBody: TPAXMethodBody);
var
  V: Variant;
begin
  with MethodBody do
  begin
    V := Params[0].AsInteger;
    if V > 0 then
      result.AsInteger := 1
    else if V < 0 then
      result.AsInteger := -1
    else
      result.AsInteger := 0;
  end;
end;

procedure _Round(MethodBody: TPAXMethodBody);
var
  D: Double;
  L, P: Integer;
  S: String;

begin
  with MethodBody do
  begin
    if ParamCount = 1 then
      result.AsInteger := Round(Params[0].AsDouble)
    else
    begin
      L := Params[1].AsInteger;
      D := Params[0].AsDouble;
      S := FloatToStr(D);
      P := Pos(DecimalSeparator, S);
      if P > 0 then
      begin
        S := Copy(S, 1, P + L);
        D := StrToFloat(S);
        result.AsDouble := D;
      end
      else
      begin
        result.AsInteger := Round(Params[0].AsDouble);
      end;
    end;
  end;
end;

procedure _Len(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Length(Params[0].AsString);
end;

procedure _Log(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Ln(Params[0].AsVariant);
end;

procedure _LTrim(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := TrimLeft(Params[0].AsString);
end;

procedure _RTrim(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := TrimRight(Params[0].AsString);
end;

procedure _Trim(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Trim(Params[0].AsString);
end;

procedure _Space(MethodBody: TPAXMethodBody);
var
  I: Integer;
  S: String;
begin
  with MethodBody do
  begin
    S := '';
    for I:=1 to Params[0].AsInteger do
      S := S + ' ';
    result.AsString := S;
  end;
end;

procedure _Replace(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := StringReplace(Params[0].AsString,
                                      Params[1].AsString,
                                      Params[2].AsString,
                                      [rfReplaceAll, rfIgnoreCase]);
end;

procedure _RGB(MethodBody: TPAXMethodBody);
var
  red, green, blue: INteger;
begin
  with MethodBody do
  begin
    red := Params[0].AsInteger;
    green := Params[1].AsInteger;
    blue := Params[2].AsInteger;
    result.AsVariant := red + (green * 256) + (blue * 65536);
  end;
end;

procedure _Mid(MethodBody: TPAXMethodBody);
var
  L: Integer;
begin
  with MethodBody do
  begin
    if ParamCount = 3 then
      L := Params[2].AsInteger
    else
      L := Length(Params[0].AsString);
    result.AsVariant := Copy(Params[0].AsString, Params[1].AsInteger, L);
  end;
end;

procedure _FormatCurrency(MethodBody: TPAXMethodBody);
var
  V: Currency;
begin
  with MethodBody do
  begin
    V := ToNumber(Params[0].AsVariant);
    result.AsVariant := CurrToStr(V);
  end;
end;

procedure _FormatDateTime(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
  begin
    result.AsVariant := DateTimeToStr(Params[0].AsVariant);
  end;
end;

procedure _FormatNumber(MethodBody: TPAXMethodBody);
var
  D: Double;
  Fmt: String;
  NumDigitsAfterDecimal: Integer;
begin
  with MethodBody do
  begin
    case ParamCount of
      1: result.AsVariant := ToString(Params[0].AsVariant);
      2, 3:
      begin
        D := ToNumber(Params[0].AsVariant);
        NumDigitsAfterDecimal := ToInt32(Params[1].AsVariant);
        Fmt := '%*.' + IntToStr(NumDigitsAfterDecimal) + 'f';
        result.AsVariant := Format(Fmt, [D]);
      end;
    end;
  end;
end;

procedure _FormatPercent(MethodBody: TPAXMethodBody);
var
  D: Double;
  Fmt: String;
  NumDigitsAfterDecimal: Integer;
begin
  with MethodBody do
  begin
    case ParamCount of
      1: result.AsVariant := ToString(Params[0].AsVariant * 100.0) + '%';
      2, 3:
      begin
        D := ToNumber(Params[0].AsVariant * 100.0);
        NumDigitsAfterDecimal := ToInt32(Params[1].AsVariant);
        Fmt := '%*.' + IntToStr(NumDigitsAfterDecimal) + 'f';
        result.AsVariant := Format(Fmt, [D]) + '%';
      end;
    end;
  end;
end;

procedure _GetLocale(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsString := '';
end;

procedure _Hex(MethodBody: TPAXMethodBody);
var
  I: Integer;
begin
  with MethodBody do
  begin
    I := ToInt32(Params[0].AsVariant);
    result.AsString := Format('%x', [I]);
  end;
end;

procedure _InputBox(MethodBody: TPAXMethodBody);
var
  Caption, Prompt: String;
begin
  with MethodBody do
  begin
    Caption := '';
    Prompt := '';

    if ParamCount = 1 then
      Caption := ToString(Params[0].AsVariant)
    else if ParamCount >= 2 then
    begin
      Caption := ToString(Params[0].AsVariant);
      Prompt := ToString(Params[1].AsVariant);
    end;

//    result.AsString := InputBox(Caption, Prompt, '');
  end;
end;

procedure _InStr(MethodBody: TPAXMethodBody);
var
  V1, V2: Variant;
  S1, S2: String;
  start: Integer;
begin
  start := 0;
  with MethodBody do
  begin
    case ParamCount of
      2:
      begin
        start := 1;
        V1 := Params[0].AsVariant;
        V2 := Params[1].AsVariant;
      end;
      3:
      begin
        V1 := Params[0].AsVariant;
        if VarType(V1) = varString then
        begin
          start := 1;
          V1 := Params[0].AsVariant;
          V2 := Params[1].AsVariant;
        end
        else
        begin
          start := Params[0].AsInteger;
          V1 := Params[1].AsVariant;
          V2 := Params[2].AsVariant;
        end;
      end;
      4:
      begin
        start := Params[0].AsInteger;
        V1 := Params[1].AsVariant;
        V2 := Params[2].AsVariant;
      end;
    end;

    if IsUndefined(V1) or IsUndefined(V2) then
    begin
      result.AsVariant := Undefined;
      Exit;
    end;
    S1 := ToString(V1);
    S2 := ToString(V2);

    if Length(S1) = 0 then
      result.AsInteger := 0
    else if Length(S2) = 0 then
      result.AsInteger := start
    else if start > Length(S1) then
      result.AsInteger := 0
    else
      result.AsInteger := Pos(S2, Copy(S1, start, Length(S1)));
  end;
end;

procedure _InStrRev(MethodBody: TPAXMethodBody);
var
  V1, V2: Variant;
  S1, S2: String;
  start, I: Integer;
begin
  start := 0;
  with MethodBody do
  begin
    case ParamCount of
      2:
      begin
        start := 0;
        V1 := Params[0].AsVariant;
        V2 := Params[1].AsVariant;
      end;
      3:
      begin
        V1 := Params[0].AsVariant;
        V2 := Params[1].AsVariant;
        start := Params[2].AsInteger;
      end;
      4:
      begin
        V1 := Params[0].AsVariant;
        V2 := Params[1].AsVariant;
        start := Params[2].AsInteger;
      end;
    end;

    if IsUndefined(V1) or IsUndefined(V2) then
    begin
      result.AsVariant := Undefined;
      Exit;
    end;

    S1 := ToString(V1);
    S2 := ToString(V2);

    if Length(S1) = 0 then
      result.AsInteger := 0
    else if Length(S2) = 0 then
      result.AsInteger := start
    else if start > Length(S1) then
      result.AsInteger := 0
    else if Length(S2) > Length(S1) then
      result.AsInteger := 0
    else if Length(S2) = Length(S1) then
    begin
      if S1 = S2 then
        result.AsInteger := 1
      else
        result.AsInteger := 0;
    end
    else
    begin
      if Start > 0 then
        S1 := Copy(S1, 1, Start);
      for I:= Length(S1) - Length(S2) + 1 downto 1 do
        if S2 = Copy(S1, I, Length(S2)) then
        begin
          result.AsInteger := I;
          Exit;
        end;
      result.AsInteger := 0;
    end;
  end;
end;

function vbInt(D: Double): Integer;
begin
  if D >= 0 then
    result := Trunc(D)
  else
  begin
    if Frac(D) <> 0.0 then
      result := Trunc(D) - 1
    else
      result := Trunc(D);
  end;
end;

procedure _Int(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
  with MethodBody do
  begin
    D := ToNumber(Params[0].AsVariant);
    result.AsInteger := vbInt(D);
  end;
end;

procedure _Fix(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
  with MethodBody do
  begin
    D := ToNumber(Params[0].AsVariant);
    if D >= 0 then
      result.AsInteger := vbInt(D)
    else
      result.AsInteger := -1 * vbInt(Abs(D));
  end;
end;

procedure _MsgBox(MethodBody: TPAXMethodBody);
var
  S: String;
begin
  with MethodBody do
  begin
    S := Params[0].AsString;
  end;

{$IFDEF CONSOLE}
  writeln(S);
  Exit;
{$ENDIF}

{$IFDEF WIN32}
  MessageBox(GetActiveWindow(), PChar(S), PChar('paxScript'), MB_OK);
{$ENDIF}

{$IFDEF LINUX}
  Application.MessageBox(PChar(S), 'paxScript', [smbOK]);
{$ENDIF}
end;

procedure _IsNull(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsBoolean := IsUndefined(Params[0].AsVariant);
end;

procedure _IsArray(MethodBody: TPAXMethodBody);
var
  V: Variant;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    result.AsBoolean := IsVBArray(V) or IsPaxArray(V);
  end;
end;

procedure _IsObject(MethodBody: TPAXMethodBody);
var
  V: Variant;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    result.AsBoolean := IsObject(V);
  end;
end;

procedure _IsDate(MethodBody: TPAXMethodBody);
var
  V: Variant;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    result.AsBoolean := VarType(V) = varDouble;
  end;
end;

procedure _VarType(MethodBody: TPAXMethodBody);
var
  V: Variant;
  I: Integer;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    I := 0;
    case VarType(V) of
      varEmpty: I := vbEmpty;
      varNull: I := vbNull;
      varSmallInt: I := vbInteger;
      varInteger: I := vbLong;
      varSingle: I := vbSingle;
      varDouble: I := vbDouble;
      varCurrency: I := vbCurrency;
      varDate: I := vbDate;
      varString: I := vbString;
      varScriptObject: I := vbObject;
      varError: I := vbError;
      varBoolean: I := vbBoolean;
      varVariant: I := vbVariant;
      varDispatch: I := vbObject;
      varByte: I := vbByte;
    end;

    if VarType(V) >= varArray then
      I := vbArray;

    result.AsInteger := I;
  end;
end;

procedure _TypeName(MethodBody: TPAXMethodBody);
var
  V: Variant;
  S: String;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;
    S := '';
    case VarType(V) of
      varEmpty: S := 'Empty';
      varNull: S := 'Null';
      varSmallInt: S := 'Integer';
      varInteger: S := 'Long';
      varSingle: S := 'Single';
      varDouble: S := 'Double';
      varCurrency: S := 'Currency';
      varDate: S := 'Date';
      varString: S := 'String';
      varScriptObject: S := 'Object';
      varBoolean: S := 'Boolean';
      varVariant: S := 'Variant';
      varDispatch: S := 'Dispatch';
      varByte: S := 'Byte';
    end;

    if VarType(V) >= varArray then
      S := 'Array';

    result.AsString := S;
  end;
end;

procedure _IsNumeric(MethodBody: TPAXMethodBody);
var
  V: Variant;
  b: Boolean;
begin
  with MethodBody do
  begin
    b := false;
    V := Params[0].AsVariant;

    case VarType(V) of
      varInteger, varByte, varDouble: b := true;
      varString: b := IsNumericString(V);
    end;

    result.AsBoolean := b;
  end;
end;

function Eval(const SourceCode: String;
              Scripter: TPAXBaseScripter;
              Parser: TPAXParser): Variant;

procedure CopyLevelStack;
var
  I, ID, L: Integer;
begin
  Parser.LevelStack.Clear;
  Parser.LevelStack.Push(0);

  with Scripter do
  for I:= 1 to Code.LevelStack.Card do
  begin
    ID := Code.LevelStack[I];
    if ID > 0 then
    begin
      L := SymbolTable.Level[ID];
      if SymbolTable.Kind[L] = KindTYPE then
        Parser.LevelStack.Push(L);
      Parser.LevelStack.Push(ID);
    end;
  end;

  if Parser.LevelStack.Card = 1 then
    Parser.LevelStack.Push(Scripter.SymbolTable.RootNamespaceID);
end;

var
  StartPos, TempCodeCard, TempSymbolCard, TempClassCount: Integer;
  Success: Boolean;
begin
  with Scripter do
  begin
    TempCodeCard := Code.Card;
    TempSymbolCard := SymbolTable.Card;
    TempClassCount := ClassList.Count;

    Code.SaveState;

    Inc(EvalCount);
    StartPos := Code.Card;

    Success := true;
    Parser.Scanner.SourceCode := SourceCode + ';';

    CopyLevelStack;

    Parser.UsingList.CopyFrom(Code.UsingList);
    Parser.WithStack.CopyFrom(Code.WithStack);
    try
      with TPaxBasicParser(Parser) do
      begin
        Call_SCANNER;
        Gen(OP_DECLARE_OFF, 0, 0, 0);
        Parse_SourceElements;
        Gen(OP_DECLARE_ON, 0, 0, 0);
        Gen(OP_HALT, 0, 0, 0);
      end;
    except
      Success := false;
    end;

    if Success then
    begin
      Code.LinkGoTo(TempCodeCard + 1, Code.Card);
      ClassList.CreateClassObjects(TempClassCount);
      ClassList.InitStaticFields(TempClassCount);
      SymbolTable.SetupSubs(TempSymbolCard + 1);

      Code.N := StartPos;
      Code.Terminated := false;
      Code.Run;

      result := Code.ResultValue;
    end;

    Dec(EvalCount);

    Code.RestoreState;
  end;
end;

procedure _eval(MethodBody: TPAXMethodBody);
var
  V: Variant;
  P: TPAXParser;
begin
  with MethodBody do
  begin
    V := Params[0].AsVariant;

    if VarType(V) <> varString then
    begin
      result.AsVariant := V;
      Exit;
    end;

    P := TPAXBaseScripter(Scripter).ParserList.FindParser('paxJavaScript');

    if P = nil then
      Exit;

    V := Eval(V, Scripter, P);

    result.AsVariant := V;
  end;
end;

var
  H: Integer;
initialization
  Randomize;

  H := RegisterNamespace('paxBasicNamespace', -1);

  RegisterConstant('vbEmpty', 0, H);
  RegisterConstant('vbNull', 1, H);
  RegisterConstant('vbInteger', 2, H);
  RegisterConstant('vbLong', 3, H);
  RegisterConstant('vbSingle', 4, H);
  RegisterConstant('vbDouble', 5, H);
  RegisterConstant('vbCurrency', 6, H);
  RegisterConstant('vbDate', 7, H);
  RegisterConstant('vbString', 8, H);
  RegisterConstant('vbObject', 9, H);
  RegisterConstant('vbError', 10, H);
  RegisterConstant('vbBoolean', 11, H);
  RegisterConstant('vbVariant', 12, H);
  RegisterConstant('vbDataObject', 13, H);
  RegisterConstant('vbByte', 17, H);
  RegisterConstant('vbArray', 8192, H);;

  RegisterStdRoutine('Abs', _Abs, 1, H);
  RegisterStdRoutine('Array', _Array, -1, H);
  RegisterStdRoutine('Asc', _Asc, 1, H);
  RegisterStdRoutine('Atn', _Atn, 1, H);

  RegisterStdRoutine('CBool', _CBool, 1, H);
  RegisterStdRoutine('CByte', _CByte, 1, H);
  RegisterStdRoutine('CCurr', _CCurr, 1, H);
  RegisterStdRoutine('CDate', _CDate, 1, H);

  RegisterStdRoutine('CDbl', _CDbl, 1, H);
  RegisterStdRoutine('Chr', _Chr, 1, H);
  RegisterStdRoutine('CInt', _CInt, 1, H);
  RegisterStdRoutine('CLng', _CLng, 1, H);

  RegisterStdRoutine('Cos', _Cos, 1, H);
  RegisterStdRoutine('CreateObject', _CreateObject, 1, H);
  RegisterStdRoutine('CLng', _CSng, 1, H);

  RegisterStdRoutine('Date', _Date, 1, H);
  RegisterStdRoutine('DateAdd', _DateAdd, 1, H); // not implemented yet
  RegisterStdRoutine('DateDiff', _DateDiff, 1, H); // not implemented yet
  RegisterStdRoutine('DatePart', _DatePart, 1, H); // not implemented yet

  RegisterStdRoutine('DateSerial', _DateSerial, 3, H);
  RegisterStdRoutine('DateValue', _DateValue, 1, H);
  RegisterStdRoutine('Day', _Day, 1, H);

  RegisterStdRoutine('Eval', _Eval, 1, H);
  RegisterStdRoutine('Exp', _Exp, 1, H);
  RegisterStdRoutine('Filter', _Filter, -1, H);
  RegisterStdRoutine('FormatCurrency', _FormatCurrency, -1, H);

  RegisterStdRoutine('FormatDateTime', _FormatDateTime, -1, H);
  RegisterStdRoutine('FormatNumber', _FormatNumber, -1, H);
  RegisterStdRoutine('FormatPercent', _FormatPercent, -1, H);
  RegisterStdRoutine('GetLocale', _GetLocale, 0, H); // not implemented yet

  RegisterStdRoutine('GetObject', _GetObject, 1, H);
  RegisterStdRoutine('GetRef', _GetRef, 1, H);
  RegisterStdRoutine('Hex', _Hex, 1, H);
  RegisterStdRoutine('Hour', _Hour, 1, H);

  RegisterStdRoutine('InputBox', _InputBox, -1, H);
  RegisterStdRoutine('InStr', _InStr, -1, H);
  RegisterStdRoutine('InStrRev', _InStrRev, -1, H);
  RegisterStdRoutine('Int', _Int, 1, H);
  RegisterStdRoutine('Fix', _Fix, 1, H);

  RegisterStdRoutine('IsArray', _IsArray, 1, H);
  RegisterStdRoutine('IsDate', _IsDate, 1, H);
  RegisterStdRoutine('IsEmpty', _IsNull, 1, H);
  RegisterStdRoutine('IsNull', _IsNull, 1, H);

  RegisterStdRoutine('IsNumeric', _IsNumeric, 1, H);
  RegisterStdRoutine('IsObject', _IsObject, 1, H);
  RegisterStdRoutine('Join', _Join, -1, H);
  RegisterStdRoutine('LBound', _LBound, -1, H);

  RegisterStdRoutine('LCase', _LCase, 1, H);
  RegisterStdRoutine('Left', _Left, 2, H);
  RegisterStdRoutine('Len', _Len, 1, H);

  RegisterStdRoutine('Log', _Log, 1, H);
  RegisterStdRoutine('LTrim', _LTrim, 1, H);
  RegisterStdRoutine('RTrim', _RTrim, 1, H);
  RegisterStdRoutine('Trim', _Trim, 1, H);

  RegisterStdRoutine('Mid', _Mid, -1, H);
  RegisterStdRoutine('Minute', _Minute, 1, H);
  RegisterStdRoutine('Month', _Month, 1, H);
  RegisterStdRoutine('MonthName', _MonthName, -1, H);

  RegisterStdRoutine('MsgBox', _MsgBox, 1, H);
  RegisterStdRoutine('Now', _Now, 0, H);
//  RegisterStdRoutine('Oct', _Oct, 1, H);
  RegisterStdRoutine('Replace', _Replace, 3, H);
  RegisterStdRoutine('RGB', _RGB, 3, H);

  RegisterStdRoutine('Right', _Right, 2, H);
  RegisterStdRoutine('Rnd', _Rnd, -1, H);
  RegisterStdRoutine('Round', _Round, -1, H);

  RegisterStdRoutine('Second', _Second, 1, H);
  RegisterStdRoutine('Sgn', _Sgn, 1, H);
  RegisterStdRoutine('Sin', _Sin, 1, H);
  RegisterStdRoutine('Space', _Space, 1, H);

  RegisterStdRoutine('Split', _Split, -1, H);
  RegisterStdRoutine('Sqr', _Sqr, 1, H);
  RegisterStdRoutine('StrComp', _StrComp, 2, H);
//  RegisterStdRoutine('String', _String, 2, H);
  RegisterStdRoutine('StrReverse', _StrReverse, 1, H);

  RegisterStdRoutine('Tan', _Tan, 1, H);
  RegisterStdRoutine('Time', _Time, 0, H);
  RegisterStdRoutine('Timer', _Timer, 0, H);
  RegisterStdRoutine('TimeSerial', _TimeSerial, 3, H);

  RegisterStdRoutine('TimeValue', _TimeValue, 1, H);
  RegisterStdRoutine('TypeName', _TypeName, 1, H);
  RegisterStdRoutine('UBound', _UBound, 2, H);
  RegisterStdRoutine('UCase', _UCase, 1, H);

  RegisterStdRoutine('VarType', _VarType, 1, H);
  RegisterStdRoutine('Weekday', _Weekday, 1, H);
  RegisterStdRoutine('Year', _Year, 1, H);

  RegisterStdRoutine('Substr', _Substr, 3, H);

end.
