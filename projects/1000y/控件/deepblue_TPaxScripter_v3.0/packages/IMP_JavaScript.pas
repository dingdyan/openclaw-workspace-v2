////////////////////////////////////////////////////////////////////////////
// PAXScript Importing
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: IMP_JAVASCRIPT.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////
{$I PaxScript.def}
unit IMP_JavaScript;
interface
uses
{$IFDEF VARIANTS}
  Variants,
{$ENDIF}
  SysUtils,
  Classes,
  Math,
  RegExpr1,
  BASE_SYS,
  BASE_CLASS,
  BASE_PARSER,
  BASE_EXTERN,
  BASE_REGEXP,
  BASE_SCRIPTER,
  PAX_JAVASCRIPT,
  PaxScripter;

const
  paxJavaScriptNamespace = 'paxJavaScriptNamespace';

type
  TPAXJavaScriptArrayObject = class;

  TPAXJavaScriptObject = class(TPAXScriptObject)
  private
    fDefaultValue: Variant;
    PrototypeNameIndex: Integer;
  public
    constructor Create(ClassRec: TPAXClassRec); override;
    function SafeGet(PropertyNameIndex: Integer): TPAXProperty; override;
    function GetProperty(PropertyNameIndex: Integer): Variant; reintroduce; virtual;
    procedure SetProperty(PropertyNameIndex: Integer;
                          const Value: Variant);
    function DefaultValue: Variant; override;
    procedure SetDefaultValue(const V: Variant); override;
  end;

  TPAXJavaScriptDateObject = class(TPAXJavaScriptObject)
    function DelphiDate: TDateTime;
    function UTCDelphiDate: TDateTime;
    procedure SetDelphiDate(D: TDateTime);
  public
    function ToString: String; override;
  end;

  TPAXJavaScriptFunctionObject = class(TPAXJavaScriptObject)
  end;

  TPAXJavaScriptBooleanObject = class(TPAXJavaScriptObject)
  end;

  TPAXJavaScriptStringObject = class(TPAXJavaScriptObject)
    function Match(R: RegExp): TPaxJavaScriptArrayObject;
    function Replace(R: RegExp; const ReplaceStr: String): String;
  end;

  TPAXJavaScriptNumberObject = class(TPAXJavaScriptObject)
  end;

  TPAXJavaScriptArrayObject = class(TPAXJavaScriptObject)
  private
    PaxArray: TPaxArray;
    procedure PutItem(I: Integer; const Value: Variant);
    function GetItem(I: Integer): Variant;
    function GetLength: Integer;
    procedure SetLength(Value: Integer);
  public
    constructor Create(ClassRec: TPAXClassRec); override;
    destructor Destroy; override;
    function ToString: String; override;
    function DefaultValue: Variant; override;
    function ExtraInstance: TObject; override;
    property Items[I: Integer]: Variant read GetItem write PutItem; default;
    property Length: Integer read GetLength write SetLength;
  end;

function Eval(const SourceCode: String;
              Scripter: TPAXBaseScripter;
              Parser: TPAXParser): Variant;

implementation

constructor TPAXJavaScriptObject.Create(ClassRec: TPAXClassRec);
var
  V: Variant;
begin
  inherited;
  fDefaultValue := Undefined;
  PrototypeNameIndex := TPAXBaseScripter(ClassRec.Scripter).PrototypeNameIndex;
  V := TPAXBaseScripter(ClassRec.Scripter).SymbolTable.GetVariant(ClassRec.ClassId);
  SetProperty(TPAXBaseScripter(ClassRec.Scripter).ConstructorNameIndex, V);
  Instance := Self;
end;

function TPAXJavaScriptObject.DefaultValue: Variant;
begin
  result := fDefaultValue;
end;

procedure TPAXJavaScriptObject.SetDefaultValue(const V: Variant);
begin
  fDefaultValue := V;
end;

function TPAXJavaScriptObject.SafeGet(PropertyNameIndex: Integer): TPAXProperty;
var
  SO: TPAXScriptObject;
  V: Variant;
begin
  SO := Self;
  repeat
    result := SO.PropertyList.FindProperty(PropertyNameIndex);
    if result <> nil then
      Exit;
    result := SO.PropertyList.FindProperty(PrototypeNameIndex);
    if result = nil then
    begin
      with TPaxBaseScripter(SO.Scripter) do
      begin
        V := SymbolTable.GetVariant(SO.ClassRec.ClassID + 2);
        if IsObject(V) then
        begin
          SO := VariantToScriptObject(V);
          result := SO.PropertyList.FindProperty(PropertyNameIndex);
          if result = nil then
            Exit;
        end;
      end;

      Exit;
    end;
    V := result.Value[0];
    if not IsObject(V) then
    begin
      result := nil;
      Exit;
    end;
    SO := VariantToScriptObject(V);
  until false;
end;

function TPAXJavaScriptObject.GetProperty(PropertyNameIndex: Integer): Variant;
var
  P: TPAXProperty;
begin
  P := SafeGet(PropertyNameIndex);
  if P <> nil then
    result := P.Value[0];
end;

procedure TPAXJavaScriptObject.SetProperty(PropertyNameIndex: Integer;
                                           const Value: Variant);
var
  P: TPAXProperty;
begin

  P := SafeGet(PropertyNameIndex);
  if P = nil then
  begin
    P := TPAXProperty.Create(Self, @Value, nil);
    PropertyList.AddObject(PropertyNameIndex, P);
  end
  else
    P.Value[0] := Value;
end;

/////////////// GLOBAL //////////////////////////////////


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
      with TPaxJavaScriptParser(Parser) do
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

var zz: Pointer;

procedure _eval(MethodBody: TPAXMethodBody);
var
  V: Variant;
  P: TPAXParser;
begin
  with MethodBody do
  begin
    zz := PSelf;

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

procedure _parseInt(MethodBody: TPAXMethodBody);
var
  S:string;
 vErrPos: integer;
 vFloat: double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      S := ToString(Params[0].AsVariant);
      if S = 'NaN' then
        result.AsVariant := NaN
      else
       begin                           // s may be 123, 1.23, 1.2MB, or junk
        val(S, vFloat, vErrPos);       // try to convert the string to a number
        if vErrPos = 1 then            // bad from the start
          result.AsVariant := NaN      // set result to Not a Number
        else                           // some numbers at front of string
         begin
          if vErrPos > 1 then          // if we have at least one good number
           begin
            S := copy(S, 1, vErrPos-1); // copy the first numbers
            val(S, vFloat, vErrPos);   // convert the good part to a number
           end;
          S := FloatToStr(int(vFloat)); // convert integer part to a string
          result.AsVariant := StrToInt(S); // set result
         end;
       end;
    end;
end;

procedure _isNan(MethodBody: TPaxMethodBody);
var
 vPrm: double;
begin
 with MethodBody do
  begin
   if ParamCount > 0 then
    begin
     vPrm := ToNumber(Params[0].AsVariant);
      if vPrm = NaN then
        result.AsVariant := true
      else
        result.AsVariant := false;
    end;
  end;
end;

procedure _parseFloat(MethodBody: TPAXMethodBody);
var
  S:string;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      S := ToString(Params[0].AsVariant);
      if S = 'NaN' then
        result.AsVariant := NaN
      else
        result.AsVariant := StrToFloat(S);
   end;
end;

procedure _memberCount(MethodBody: TPAXMethodBody);
var
  SO: TPaxScriptObject;
begin
  with MethodBody do
    begin
      SO := VariantToScriptObject(Params[0].AsVariant);
      result.AsVariant := SO.PropertyList.Count - 1;
   end;
end;

/////////////// OBJECT //////////////////////////////////

procedure _Object_New(MethodBody: TPAXMethodBody);
var
  SO: TPAXJavaScriptObject;
  ClassRec: TPAXClassRec;
begin
  with MethodBody do
  begin
    ClassRec := TPAXBaseScripter(Scripter).ClassList.ObjectClassRec;
    SO := TPAXJavaScriptObject.Create(ClassRec);
    Self := SO;
  end;
end;

procedure _Object_GetProperty(M: TPAXMethodBody);
var
  SO: TPAXJavaScriptObject;
  Index: Integer;
  P: TPaxProperty;
begin
  with M do
  begin
    SO := TPAXJavaScriptObject(Self);
    if SO.HasProperty(Name) then
      result.AsVariant := SO.GetProperty(CreateNameIndex(Name, SO.Scripter))
    else if IsDigits(Name) then
    begin
      Index := StrToInt(Name) + 1;
      P := SO.PropertyList.Properties[Index];
      result.AsVariant := P.Value[0];
    end
    else
      result.AsVariant := Undefined;

    PSelf := nil;
  end;
end;

procedure _Object_PutProperty(M: TPAXMethodBody);
var
  SO: TPAXJavaScriptObject;
begin
  with M do
  begin
    SO := TPAXJavaScriptObject(Self);
    SO.SetProperty(CreateNameIndex(Name, SO.Scripter), Params[0].AsVariant);
  end;
end;

procedure _Object_toString(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := ToString(DefaultValue);
end;

procedure _Object_valueOf(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := DefaultValue;
end;

/////////////// BOOLEAN //////////////////////////////////

procedure _Boolean_New(MethodBody: TPAXMethodBody);
var
  SO: TPAXJavaScriptBooleanObject;
  ClassRec: TPAXClassRec;
begin
  with MethodBody do
  begin
    ClassRec := TPAXBaseScripter(Scripter).ClassList.BooleanClassRec;
    SO := TPAXJavaScriptBooleanObject.Create(ClassRec);
    if ParamCount > 0 then
      SO.fDefaultValue := ToBoolean(Params[0].AsVariant)
    else
      SO.fDefaultValue := false;
    Self := SO;
  end;
end;

/////////////// DATE ////////////////////////////////////

function TPAXJavaScriptDateObject.DelphiDate: TDateTime;
begin
  result := EcmaTimeToDelphiDateTime(fDefaultValue);
end;

function TPAXJavaScriptDateObject.UTCDelphiDate: TDateTime;
var
  Diff: Integer;
begin
  Diff := Floor(GetGMTDifference);
  result := EcmaTimeToDelphiDateTime(fDefaultValue - MSecsPerHour * Diff);
end;

procedure TPAXJavaScriptDateObject.SetDelphiDate(D: TDateTime);
var
  Dbl: Double;
begin
  Dbl := DelphiDateTimeToEcmaTime(D);
  fDefaultValue := Dbl;
end;

function TPAXJavaScriptDateObject.ToString: String;
var
  SO: TPAXJavaScriptDateObject;
begin
  SO := TPAXJavaScriptDateObject(Self);
  result := ToStr(Scripter, SO.DelphiDate);
end;

procedure _Date_New(MethodBody: TPAXMethodBody);
var
  SO: TPAXJavaScriptDateObject;
  ClassRec: TPAXClassRec;
  Y,M,D: Word;
  R: Variant;
begin
  with MethodBody do
  begin
    ClassRec := TPAXBaseScripter(Scripter).ClassList.DateClassRec;
    SO := TPAXJavaScriptDateObject.Create(ClassRec);

    case ParamCount of
      1:
      begin
        R := EcmaTimeToDelphiDateTime(Params[0].AsVariant);
      end;
      3:
      begin
        Y := ToInt32(Params[0].AsVariant);
        M := ToInt32(Params[1].AsVariant)+1;
        D := ToInt32(Params[2].AsVariant);
        R := EncodeDate(Y,M,D);
      end
      else
        R := SysUtils.Now;
    end;

   SO.SetDelphiDate(R);
   Self := SO;

   Result.AsVariant := R;
  end;
end;

procedure _Date_toString(MethodBody: TPAXMethodBody);
var
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    result.AsVariant := ToString(SO.DelphiDate);
  end;
end;

procedure _Date_toGMTString(MethodBody: TPAXMethodBody);
var
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    result.AsVariant := ToString(SO.UTCDelphiDate);
  end;
end;

procedure _Date_getTime(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    Result.AsVariant := ToNumber(DefaultValue);
end;

procedure _Date_getFullYear(MethodBody: TPAXMethodBody);
var
  Year, Month, Day: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeDate(SO.DelphiDate, Year, Month, Day);
    result.AsVariant := Integer(Year);
  end;
end;

procedure _Date_getUTCFullYear(MethodBody: TPAXMethodBody);
var
  Year, Month, Day: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeDate(SO.UTCDelphiDate, Year, Month, Day);
    result.AsVariant := Integer(Year);
  end;
end;

procedure _Date_getMonth(MethodBody: TPAXMethodBody);
var
  Year,Month,Day: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeDate(SO.DelphiDate, Year, Month, Day);
    result.AsVariant := Integer(Month - 1);
  end;
end;

procedure _Date_getUTCMonth(MethodBody: TPAXMethodBody);
var
  Year,Month,Day: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeDate(SO.UTCDelphiDate, Year, Month, Day);
    result.AsVariant := Integer(Month - 1);
  end;
end;

procedure _Date_getDate(MethodBody: TPAXMethodBody);
var
  Year,Month,Day: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeDate(SO.DelphiDate, Year, Month, Day);
    result.AsVariant := Integer(Day);
  end;
end;

procedure _Date_getUTCDate(MethodBody: TPAXMethodBody);
var
  Year,Month,Day: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeDate(SO.UTCDelphiDate, Year, Month, Day);
    result.AsVariant := Day;
  end;
end;

procedure _Date_getDay(MethodBody: TPAXMethodBody);
var
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    result.AsVariant := DayOfWeek(SO.DelphiDate) - 1;
  end;
end;

procedure _Date_getUTCDay(MethodBody: TPAXMethodBody);
var
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    result.AsVariant := DayOfWeek(SO.UTCDelphiDate) - 1;
  end;
end;

procedure _Date_getHours(MethodBody: TPAXMethodBody);
var
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.DelphiDate, Hour, Min, Sec, MSec);
    result.AsVariant := Integer(Hour);
  end;
end;

procedure _Date_getUTCHours(MethodBody: TPAXMethodBody);
var
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.UTCDelphiDate, Hour, Min, Sec, MSec);
    result.AsVariant := Integer(Hour);
  end;
end;

procedure _Date_getMinutes(MethodBody: TPAXMethodBody);
var
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.DelphiDate, Hour, Min, Sec, MSec);
    result.AsVariant := Integer(Min);
  end;
end;

procedure _Date_getUTCMinutes(MethodBody: TPAXMethodBody);
var
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.UTCDelphiDate, Hour, Min, Sec, MSec);
    result.AsVariant := Integer(Min);
  end;
end;

procedure _Date_getSeconds(MethodBody: TPAXMethodBody);
var
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.DelphiDate, Hour, Min, Sec, MSec);
    result.AsVariant := Integer(Sec);
  end;
end;

procedure _Date_getUTCSeconds(MethodBody: TPAXMethodBody);
var
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.UTCDelphiDate, Hour, Min, Sec, MSec);
    result.AsVariant := Integer(Sec);
  end;
end;

procedure _Date_getMilliseconds(MethodBody: TPAXMethodBody);
var
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.DelphiDate, Hour, Min, Sec, MSec);
    result.AsVariant := Integer(MSec);
  end;
end;

procedure _Date_getUTCMilliseconds(MethodBody: TPAXMethodBody);
var
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.UTCDelphiDate, Hour, Min, Sec, MSec);
    result.AsVariant := Integer(MSec);
  end;
end;

procedure _Date_setTime(MethodBody: TPAXMethodBody);
var
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    if ParamCount = 0 then
      SO.SetDelphiDate(Now())
    else
      SO.SetDefaultValue(ToNumber(Params[0].AsVariant));
  end;
end;

procedure _Date_setMilliseconds(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.DelphiDate, Hour, Min, Sec, MSec);
    if ParamCount > 0 then
      MSec := ToInt32(Params[0].AsVariant);
    Date := EncodeTime(Hour, Min, Sec, MSec);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_setUTCMilliseconds(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.UTCDelphiDate, Hour, Min, Sec, MSec);
    if ParamCount > 0 then
      MSec := ToInt32(Params[0].AsVariant);
    Date := EncodeTime(Hour, Min, Sec, MSec);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_setSeconds(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.DelphiDate, Hour, Min, Sec, MSec);
    if ParamCount > 0 then
      Sec := ToInt32(Params[0].AsVariant);
    if ParamCount > 1 then
      MSec := ToInt32(Params[1].AsVariant);
    Date := EncodeTime(Hour, Min, Sec, MSec);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_setUTCSeconds(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.UTCDelphiDate, Hour, Min, Sec, MSec);
    if ParamCount > 0 then
      Sec := ToInt32(Params[0].AsVariant);
    if ParamCount > 1 then
      MSec := ToInt32(Params[1].AsVariant);
    Date := EncodeTime(Hour, Min, Sec, MSec);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_setMinutes(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.DelphiDate, Hour, Min, Sec, MSec);
    if ParamCount > 0 then
      Min := ToInt32(Params[0].AsVariant);
    if ParamCount > 1 then
      Sec := ToInt32(Params[1].AsVariant);
    if ParamCount > 2 then
      MSec := ToInt32(Params[2].AsVariant);
    Date := EncodeTime(Hour, Min, Sec, MSec);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_setUTCMinutes(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.UTCDelphiDate, Hour, Min, Sec, MSec);
    if ParamCount > 0 then
      Min := ToInt32(Params[0].AsVariant);
    if ParamCount > 1 then
      Sec := ToInt32(Params[1].AsVariant);
    if ParamCount > 2 then
      MSec := ToInt32(Params[2].AsVariant);
    Date := EncodeTime(Hour, Min, Sec, MSec);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_setHours(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.DelphiDate, Hour, Min, Sec, MSec);
    if ParamCount > 0 then
      Hour := ToInt32(Params[0].AsVariant);
    Date := EncodeTime(Hour, Min, Sec, MSec);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_setUTCHours(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Hour, Min, Sec, MSec: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeTime(SO.UTCDelphiDate, Hour, Min, Sec, MSec);
    if ParamCount > 0 then
      Hour := ToInt32(Params[0].AsVariant);
    Date := EncodeTime(Hour, Min, Sec, MSec);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_setDate(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Year, Month, Day: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeDate(SO.DelphiDate, Year, Month, Day);

    if ParamCount > 0 then
      Day := ToNumber(Params[0].AsVariant) + 1;

    Date := EncodeDate(Year, Month, Day);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_setUTCDate(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Year, Month, Day: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeDate(SO.UTCDelphiDate, Year, Month, Day);

    if ParamCount > 0 then
      Day := ToNumber(Params[0].AsVariant) + 1;

    Date := EncodeDate(Year, Month, Day);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_setMonth(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Year, Month, Day: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeDate(SO.DelphiDate, Year, Month, Day);

    if ParamCount > 0 then
      Month := ToNumber(Params[0].AsVariant) + 1;
    if ParamCount > 1 then
      Day := ToNumber(Params[1].AsVariant) + 1;

    Date := EncodeDate(Year, Month, Day);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_setUTCMonth(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Year, Month, Day: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeDate(SO.UTCDelphiDate, Year, Month, Day);

    if ParamCount > 0 then
      Month := ToNumber(Params[0].AsVariant) + 1;
    if ParamCount > 1 then
      Day := ToNumber(Params[1].AsVariant) + 1;

    Date := EncodeDate(Year, Month, Day);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_setFullYear(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Year, Month, Day: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeDate(SO.DelphiDate, Year, Month, Day);

    if ParamCount > 0 then
      Year := ToNumber(Params[0].AsVariant);
    if ParamCount > 1 then
      Month := ToNumber(Params[1].AsVariant) + 1;
    if ParamCount > 2 then
      Day := ToNumber(Params[2].AsVariant) + 1;

    Date := EncodeDate(Year, Month, Day);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_setUTCFullYear(MethodBody: TPAXMethodBody);
var
  Date: TDateTime;
  Year, Month, Day: Word;
  SO: TPAXJavaScriptDateObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptDateObject(Self);
    DecodeDate(SO.DelphiDate, Year, Month, Day);

    if ParamCount > 0 then
      Year := ToNumber(Params[0].AsVariant);
    if ParamCount > 1 then
      Month := ToNumber(Params[1].AsVariant) + 1;
    if ParamCount > 2 then
      Day := ToNumber(Params[2].AsVariant) + 1;

    Date := EncodeDate(Year, Month, Day);
    SO.SetDelphiDate(Date);
  end;
end;

procedure _Date_getTimezoneOffset(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
  begin
    result.AsVariant := - (GetGMTDifference * SecsPerHour);
  end;
end;

/////////////// MATH ////////////////////////////////////

procedure _Math_abs(MethodBody: TPAXMethodBody);
var
  V: Variant;
begin
  with MethodBody do
  begin
    if ParamCount > 0 then
    begin
      V := ToNumber(Params[0].AsVariant);
      if V > 0 then
        result.AsVariant := V
      else
        result.AsVariant := - V;
    end;
  end;
end;

procedure _Math_acos(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      D := ToNumber(Params[0].AsVariant);
      if (D >= -1) and (D <= 1) then
        result.AsVariant := Math.ArcCos(D)
      else
        result.AsVariant := NaN;
     end;
end;

procedure _Math_asin(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      D := ToNumber(Params[0].AsVariant);
      if (D >= -1) and (D <= 1) then
        result.AsVariant := Math.ArcSin(D)
      else
        result.AsVariant := NaN;
     end;
end;

procedure _Math_atan(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      D := ToNumber(Params[0].AsVariant);
      if (D >= -1) and (D <= 1) then
        result.AsVariant := ArcTan(D)
      else
        result.AsVariant := NaN;
     end;
end;

procedure _Math_atan2(MethodBody: TPAXMethodBody);
var
  A, B: Double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      A := ToNumber(Params[0].AsVariant);
      B := ToNumber(Params[1].AsVariant);

      if (A = NaN) or (B = NaN) then
        result.AsVariant := NaN
      else
        result.AsVariant := Math.arctan2(A,B);
     end;
end;

procedure _Math_ceil(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      D := ToNumber(Params[0].AsVariant);
      if D = NaN then
        result.AsVariant := NaN
      else
        result.AsVariant := Ceil(D);
     end;
end;

procedure _Math_cos(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      D := ToNumber(Params[0].AsVariant);
      if D = NaN then
        result.AsVariant := NaN
      else
        result.AsVariant := Cos(D);
     end;
end;

procedure _Math_exp(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      D := ToNumber(Params[0].AsVariant);
      if D = NaN then
        result.AsVariant := NaN
      else
        result.AsVariant := Exp(D);
     end;
end;

procedure _Math_floor(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      D := ToNumber(Params[0].AsVariant);
      if D = NaN then
        result.AsVariant := NaN
      else
        result.AsVariant := Floor(D);
     end;
end;

procedure _Math_log(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      D := ToNumber(Params[0].AsVariant);
      if D = NaN then
        result.AsVariant := NaN
      else
        result.AsVariant := Ln(D);
     end;
end;

procedure _Math_max(MethodBody: TPAXMethodBody);
var
  D, M: Double;
  I: Integer;
begin
  with MethodBody do
  begin
    M := NEGATIVE_INFINITY;
    for I:=0 to ParamCount - 1 do
    begin
      D := ToNumber(Params[I].AsVariant);
      if D > M then
        M := D;
    end;
    result.AsVariant := M;
  end;
end;

procedure _Math_min(MethodBody: TPAXMethodBody);
var
  D, M: Double;
  I: Integer;
begin
  with MethodBody do
  begin
    M := POSITIVE_INFINITY;
    for I:=0 to ParamCount - 1 do
    begin
      D := ToNumber(Params[I].AsVariant);
      if D < M then
        M := D;
    end;
    result.AsVariant := M;
  end;
end;

procedure _Math_pow(MethodBody: TPAXMethodBody);
var
  A, B: Double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      A := ToNumber(Params[0].AsVariant);
      B := ToNumber(Params[1].AsVariant);

      if (A = NaN) or (B = NaN) then
        result.AsVariant := NaN
      else
        result.AsVariant := Math.power(A,B);
     end;
end;

procedure _Math_random(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := Random(10000)/10000;
end;

procedure _Math_round(MethodBody: TPAXMethodBody);
var
  D: Double;
  I: Integer;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      D := ToNumber(Params[0].AsVariant);
      if D = NaN then
        result.AsVariant := NaN
      else
      begin
        I := round(D);
        D := I;
        result.AsVariant := D;
      end;
   end;
end;

procedure _Math_sin(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      D := ToNumber(Params[0].AsVariant);
      if D = NaN then
        result.AsVariant := NaN
      else
        result.AsVariant := Sin(D);
     end;
end;

procedure _Math_sqrt(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      D := ToNumber(Params[0].AsVariant);
      if D = NaN then
        result.AsVariant := NaN
      else
        result.AsVariant := Sqrt(D);
     end;
end;

procedure _Math_tan(MethodBody: TPAXMethodBody);
var
  D: Double;
begin
  with MethodBody do
    if ParamCount > 0 then
    begin
      D := ToNumber(Params[0].AsVariant);
      if D = NaN then
        result.AsVariant := NaN
      else
        result.AsVariant := Tan(D);
     end;
end;

/////////////// FUNCTION //////////////////////////////////

procedure _Function_New(MethodBody: TPAXMethodBody);
var
  SO: TPAXJavaScriptObject;
  ClassRec: TPAXClassRec;
  FormalParameters, FunctionBody, FunctionDecl: String;
  I: Integer;
  P: TPAXParser;
  V: Variant;
begin
  with MethodBody do
  begin
    if ParamCount >= 2 then
    begin
      FunctionBody := ToString(Params[ParamCount - 1].AsVariant);
      FormalParameters := '';
      for I:=0 to ParamCount - 2 do
        FormalParameters := FormalParameters + ToString(Params[I].AsVariant);

      FunctionDecl := 'function _Function(' + FormalParameters + ') {'
      + FunctionBody + '}';

      P := TPAXBaseScripter(Scripter).ParserList.FindParser('paxJavaScript');

      if P = nil then
        Exit;

       V := Eval(FunctionDecl, Scripter, P);
       Self := VariantToScriptObject(V);
    end
    else
    begin
      ClassRec := TPAXBaseScripter(Scripter).ClassList.FunctionClassRec;
      SO := TPAXJavaScriptFunctionObject.Create(ClassRec);
      Self := SO;
    end;
  end;
end;

/////////////// STRING ////////////////////////////////////

function TPAXJavaScriptStringObject.Match(R: RegExp): TPaxJavaScriptArrayObject;
var
  S: String;
  PaxArray: TPaxArray;
  I, L: Integer;
begin
  S := ToStr(Scripter, DefaultValue);
  PaxArray := R.Exec(S);

  if PaxArray <> nil then
  begin
    L := PaxArray.HighBound(1);

    result := TPAXJavaScriptArrayObject.Create(ClassRec.GetClassList.ArrayClassRec);
    result.Length := L - 1;

    for I:=0 to L - 1 do
      result[I] := PaxArray.Get([I]);
    PaxArray.Free;

    result.SetProperty(CreateNameIndex('index', Scripter), R.RegExpr.MatchPos[0]);
  end
  else
    result := TPAXJavaScriptArrayObject.Create(ClassRec.GetClassList.ArrayClassRec);
end;

function TPAXJavaScriptStringObject.Replace(R: RegExp; const ReplaceStr: String): String;
var
  S: String;
begin
  S := ToStr(Scripter, DefaultValue);
  result := R.Replace(S, ReplaceStr);
end;

procedure _String_GetProperty(M: TPAXMethodBody);
var
  SO: TPAXJavaScriptObject;
begin
  with M do
  begin
    SO := TPAXJavaScriptObject(Self);

    if Name = 'length' then
      result.AsInteger := Length(ToString(SO.DefaultValue))
    else
      result.AsVariant := SO.GetProperty(CreateNameIndex(Name, Scripter));
  end;
end;

procedure _String_PutProperty(M: TPAXMethodBody);
var
  SO: TPAXJavaScriptObject;
begin
  with M do
  begin
    SO := TPAXJavaScriptObject(Self);
    SO.SetProperty(CreateNameIndex(Name, Scripter), Params[0].AsVariant);
  end;
end;

procedure _String_New(MethodBody: TPAXMethodBody);
var
  SO: TPAXJavaScriptStringObject;
  ClassRec: TPAXClassRec;
  R: Variant;
begin
  with MethodBody do
  begin
    ClassRec := TPAXBaseScripter(Scripter).ClassList.StringClassRec;
    SO := TPAXJavaScriptStringObject.Create(ClassRec);

    case ParamCount of
      1: R := ToString(Params[0].AsVariant);
      else
        R := '';
    end;
    SO.fDefaultValue := R;
    Self := SO;
    Result.AsVariant := R;
  end;
end;

procedure _String_anchor(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
  begin
    if ParamCount > 0 then
      Name := ToString(Params[0].AsVariant)
    else
      Name := 'undefined';
    result.AsVariant := '<A NAME="' + Name + '">' + ToString(DefaultValue) + '</A>';
  end;
end;

procedure _String_big(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := '<BIG>' + ToString(DefaultValue) + '</BIG>';
end;

procedure _String_blink(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := '<BLINK>' + ToString(DefaultValue) + '</BLINK>';
end;

procedure _String_bold(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := '<B>' + ToString(DefaultValue) + '</B>';
end;

procedure _String_charAt(MethodBody: TPAXMethodBody);
var
  S: String;
  I: Integer;
begin
  with MethodBody do
  begin
    S := ToString(DefaultValue);
    if ParamCount > 0 then
      I := ToInt32(Params[0].AsVariant)
    else
    begin
      result.AsVariant := '';
      Exit;
    end;
    if (I >= 0) and (I <= Length(S) - 1) then
      result.AsVariant := S[I + 1]
    else
      result.AsVariant := '';
  end;
end;

procedure _String_charCodeAt(MethodBody: TPAXMethodBody);
var
  S: String;
  I: Integer;
begin
  with MethodBody do
  begin
    S := ToString(DefaultValue);
    if ParamCount > 0 then
      I := ToInt32(Params[0].AsVariant)
    else
    begin
      result.AsVariant := -1;
      Exit;
    end;
    if (I >= 0) and (I <= Length(S) - 1) then
      result.AsVariant := ord(S[I + 1])
    else
      result.AsVariant := -1;
  end;
end;

procedure _String_concat(MethodBody: TPAXMethodBody);
var
  S: String;
  I: Integer;
begin
  with MethodBody do
  begin
    S := ToString(DefaultValue);
    for I:=0 to ParamCount - 1 do
      S := S + ToString(Params[I].AsVariant);
     result.AsVariant := S;
  end;
end;

procedure _String_fixed(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := '<TT>' + ToString(DefaultValue) + '</TT>';
end;

procedure _String_fontcolor(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
  begin
    if ParamCount > 0 then
      Name := ToString(Params[0].AsVariant)
    else
      Name := 'undefined';
    result.AsVariant := '<FONT COLOR="' + Name + '">' + ToString(DefaultValue) + '</FONT>';
  end;
end;

procedure _String_fontsize(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
  begin
    if ParamCount > 0 then
      Name := ToString(Params[0].AsVariant)
    else
      Name := 'undefined';
    result.AsVariant := '<FONT SIZE="' + Name + '">' + ToString(DefaultValue) + '</FONT>';
  end;
end;

procedure _String_fromCharCode(MethodBody: TPAXMethodBody);
var
  S: String;
  I: Integer;
  B: Byte;
begin
  with MethodBody do
  begin
    S := '';
    for I:=0 to ParamCount - 1 do
    begin
      B := ToInt32(Params[I].AsVariant);
      S := S + Chr(B);
    end;
    result.AsVariant := S;
  end;
end;

procedure _String_indexOf(MethodBody: TPAXMethodBody);
var
  S, P: String;
  I, J, L: Integer;
begin
  with MethodBody do
  begin
    result.AsVariant := Integer(-1);
    L := ParamCount;
    if L = 0 then
      Exit;
     S := ToString(DefaultValue);
     P := ToString(Params[0].AsVariant);
     if L > 1 then
       J := ToInt32(Params[1].AsVariant)
     else
       J := 1;
     if J <= 0 then
       J := 1;
     L := Length(P);
     for I:=J to Length(S) - L + 1 do
       if Copy(S, I, L) = P then
       begin
         result.AsVariant := I;

         if TPAXBaseScripter(Scripter).Code.SignZERO_BASED_STRINGS then
           result.AsVariant := result.AsVariant - 1;

         Exit;
       end;
  end;
end;

procedure _String_lastIndexOf(MethodBody: TPAXMethodBody);
var
  S, P: String;
  I, J, L: Integer;
begin
  with MethodBody do
  begin
    result.AsVariant := -1;
    L := ParamCount;
    if L = 0 then
      Exit;
     S := ToString(DefaultValue);
     P := ToString(Params[0].AsVariant);

     if L > 1 then
       J := ToInt32(Params[1].AsVariant)
     else
       J := 1;

     if J <= 0 then
       J := 1;

     L := Length(P);
     for I:=Length(S) - L downto J do
       if Copy(S, I, L) = P then
       begin
         result.AsVariant := I;

         if TPAXBaseScripter(Scripter).Code.SignZERO_BASED_STRINGS then
           result.AsVariant := result.AsVariant - 1;

         Exit;
       end;
  end;
end;

procedure _String_italics(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := '<I>' + ToString(DefaultValue) + '</I>';
end;

procedure _String_link(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
  begin
    if ParamCount > 0 then
      Name := ToString(Params[0].AsVariant)
    else
      Name := 'undefined';
    result.AsVariant := '<A HREF="' + Name + '">' + ToString(DefaultValue) + '</A>';
  end;
end;

procedure _String_slice(M: TPAXMethodBody);
var
  IStart, IEnd, L: Integer;
  S: String;
begin
  with M do
  begin
    S := ToString(DefaultValue);
    L := Length(S);

    if ParamCount = 0 then
    begin
      IStart := 0;
      IEnd := L - 1;
    end
    else if ParamCount = 1 then
    begin
      IStart := ToInt32(Params[0].AsVariant);
      if IStart < 0 then
        IStart := IStart + L;
      IEnd := L - 1;
    end
    else
    begin
      IStart := ToInt32(Params[0].AsVariant);
      IEnd := ToInt32(Params[1].AsVariant);
      if IStart < 0 then
        IStart := IStart + L;
      if IEnd < 0 then
        IEnd := IEnd + L;
    end;

    L := IEnd - IStart + 1;

    if L > 0 then
      result.AsVariant := Copy(S, IStart, L);
  end;
end;

procedure _String_small(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := '<SMALL>' + ToString(DefaultValue) + '</SMALL>';
end;

procedure _String_substr(MethodBody: TPAXMethodBody);
var
  I, L: Integer;
  S: String;
begin
  with MethodBody do
  begin
    S := ToString(DefaultValue);
    I := 1;
    L := Length(S);
    if ParamCount > 0 then
      I := ToInt32(Params[0].AsVariant);
    if ParamCount > 1 then
      L := ToInt32(Params[1].AsVariant);

    if TPAXBaseScripter(Scripter).Code.SignZERO_BASED_STRINGS then
       Inc(I);

    result.AsVariant := Copy(S, I, L);
  end;
end;

procedure _String_substring(MethodBody: TPAXMethodBody);
var
  I, L: Integer;
  S: String;
begin
  with MethodBody do
  begin
    S := ToString(DefaultValue);
    I := 1;
    L := Length(S);
    if ParamCount > 0 then
      I := ToInt32(Params[0].AsVariant);
    if ParamCount > 1 then
      L := ToInt32(Params[1].AsVariant);

    if TPAXBaseScripter(Scripter).Code.SignZERO_BASED_STRINGS then
       Inc(I);

    result.AsVariant := Copy(S, I, L);
  end;
end;

procedure _String_strike(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := '<STRIKE>' + ToString(DefaultValue) + '</STRIKE>';
end;

procedure _String_sub(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := '<SUB>' + ToString(DefaultValue) + '</SUB>';
end;

procedure _String_sup(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := '<SUP>' + ToString(DefaultValue) + '</SUP>';
end;

procedure _String_Split(MethodBody: TPAXMethodBody);
var
  P, S, Q: String;
  L: TStringList;
  Dest: TPAXJavaScriptArrayObject;
  r: TRegExpr;
  I, I1, I2, K: Integer;
  SO: TPaxScriptObject;
  V: Variant;
begin
  with MethodBody do
  begin
    S := ToString(DefaultValue);

    V := Params[0].AsVariant;
    if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);
      if SO.ClassRec.Name = 'RegExp' then
        P := RegExp(SO.Instance).Source
      else
        P := ToString(Params[0].AsString);
    end
    else
      P := ToString(Params[0].AsString);

    L := TStringList.Create;

  	r := TRegExpr.Create;
  	try
{  		r.Expression := P;
      if r.Exec(S) then
			repeat
         I2 := r.MatchPos[0];
         K := r.MatchLen[0];
         Q := Copy(S, I1, I2 - I1);
         L.Add(Q);
         I1 := I2 + K;
			until not r.ExecNext;}

      if Length(P) = 1 then
      begin
        I1 := PosCh(P[1], S);
        while I1 > 0 do
        begin
          Q := Copy(S, 1, I1 - 1);
          L.Add(Q);
          Delete(S, 1, I1);

          I1 := PosCh(P[1], S);
        end;
        L.Add(S);
      end
      else
      begin
        r.Expression := P;
        I1 := 1;
        if r.Exec(S) then
        repeat
          I2 := r.MatchPos[0];
          K := r.MatchLen[0];
          Q := Copy(S, I1, I2 - I1);
          L.Add(Q);
          I1 := I2 + K;
        until not r.ExecNext;
        Q := Copy(S, I1, (Length(S) - I1) + 1);
        L.Add(Q);
      end;


		finally
      Dest := TPAXJavaScriptArrayObject.Create(TPaxBaseScripter(Scripter).ClassList.ArrayClassRec);
      Dest.Length := L.Count;
      for I:=0 to L.Count - 1 do
      begin
        Dest[I] := L[I];
      end;
      r.Free;
      L.Free;
    end;
    result.AsVariant := ScriptObjectToVariant(Dest);
    PSelf := nil;
  end;
end;

procedure _String_toLowerCase(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := LowerCase(ToString(DefaultValue));
end;

procedure _String_toUpperCase(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := UpperCase(ToString(DefaultValue));
end;

procedure _String_valueOf(MethodBody: TPAXMethodBody);
begin
  with MethodBody do
    result.AsVariant := ToString(DefaultValue);
end;

procedure _String_match(MethodBody: TPAXMethodBody);

function StrIsGlobal(const S: String): Boolean;
var
  I, J: Integer;
begin
  result := false;
  for I:=Length(S) downto 1 do
    if S[I] = '\' then
    begin
      for J:=I + 1 to Length(S) do
        if S[I] in ['g','G'] then
        begin
          result := true;
          Exit;
        end;
      Exit;
    end;
end;

var
  P, S, Q: String;
  L: TStringList;
  Dest: TPAXJavaScriptArrayObject;
  r: TRegExpr;
  SO: TPaxScriptObject;
  V: Variant;
  I: Integer;
  IsGlobal: Boolean;
begin
  with MethodBody do
  begin
    S := ToString(DefaultValue);

    V := Params[0].AsVariant;
    if IsObject(V) then
    begin
      SO := VariantToScriptObject(V);
      if SO.ClassRec.Name = 'RegExp' then
      begin
        P := RegExp(SO.Instance).Source;
        IsGlobal := RegExp(SO.Instance).Global;
      end
      else
      begin
        P := ToString(Params[0].AsString);
        IsGlobal := StrIsGlobal(S);
      end;
    end
    else
    begin
      P := ToString(Params[0].AsString);
      IsGlobal := StrIsGlobal(S);
    end;

    L := TStringList.Create;

  	r := TRegExpr.Create;
  	try
  		r.Expression := P;
      if r.Exec(S) then
			repeat
         Q := r.Match[0];
         L.Add(Q);

         if not IsGlobal then
           Break;

			until not r.ExecNext;
		finally
      Dest := TPAXJavaScriptArrayObject.Create(TPaxBaseScripter(Scripter).ClassList.ArrayClassRec);
      Dest.Length := L.Count;
      for I:=0 to L.Count - 1 do
        Dest[I] := L[I];

      Dest.SetProperty(CreateNameIndex('index', Scripter), r.MatchPos[0]);
      Dest.SetProperty(CreateNameIndex('lastIndex', Scripter), r.MatchPos[0] + r.MatchLen[0]);
      Dest.SetProperty(CreateNameIndex('input', Scripter), S);

      r.Free;
      L.Free;
    end;
    result.AsVariant := ScriptObjectToVariant(Dest);
    PSelf := nil;
  end;
end;

procedure _String_replace(MethodBody: TPAXMethodBody);
var
  ReplaceStr: String;
  R: RegExp;
  SO: TPAXJavaScriptStringObject;
  V: Variant;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptStringObject(Self);
    ReplaceStr := ToString(Params[1].AsVariant);

    V := Params[0].AsVariant;
    if IsObject(V) then
    begin
      R := RegExp(VariantToScriptObject(V).Instance);
      result.AsVariant := SO.Replace(R, ReplaceStr);
    end
    else
    begin
      R := RegExp.Create;
      R.Source := ToStr(Scripter, V);
      result.AsVariant := SO.Replace(R, ReplaceStr);
      R.Free;
    end;
  end;
end;

procedure _String_search(MethodBody: TPAXMethodBody);
var
  R: RegExp;
  SO: TPAXJavaScriptStringObject;
  V: Variant;
  A: TPAXJavaScriptArrayObject;
begin
  with MethodBody do
  begin
    SO := TPAXJavaScriptStringObject(Self);

    V := Params[0].AsVariant;
    if IsObject(V) then
    begin
      R := RegExp(VariantToScriptObject(V).Instance);
      A := SO.Match(R);
      result.AsVariant := A.GetProperty(CreateNameIndex('index', Scripter));
    end
    else
    begin
      R := RegExp.Create;
      R.Source := ToStr(Scripter, V);
      A := SO.Match(R);
      result.AsVariant := A.GetProperty(CreateNameIndex('index', Scripter));
      R.Free;
    end;
  end;
end;

/////////////// NUMBER ////////////////////////////////////

procedure _Number_New(MethodBody: TPAXMethodBody);
var
  SO: TPAXJavaScriptNumberObject;
  ClassRec: TPAXClassRec;
  R: Variant;
begin
  with MethodBody do
  begin
    ClassRec := TPAXBaseScripter(Scripter).ClassList.NumberClassRec;
    SO := TPAXJavaScriptNumberObject.Create(ClassRec);

    case ParamCount of
      1: R := ToNumber(Params[0].AsVariant);
      else
        R := '';
    end;
    SO.fDefaultValue := R;
    Self := SO;
    Result.AsVariant := R;
  end;
end;

/////////////// ARRAY ////////////////////////////////////

function IsJavaScriptArrayObject(const V: Variant): Boolean;
var
  SO: TPAXScriptObject;
begin
  result := IsObject(V);
  if result then
  begin
    SO := VariantToScriptObject(V);
    result := SO.ClassRec.Name = 'Array';
  end;
end;

constructor TPAXJavaScriptArrayObject.Create(ClassRec: TPAXClassRec);
begin
  inherited Create(ClassRec);
  PaxArray := TPaxArray.Create([0]);
  Instance := Self;
end;

function TPAXJavaScriptArrayObject.ExtraInstance: TObject;
begin
  result := PaxArray;
end;

function TPAXJavaScriptArrayObject.GetLength: Integer;
begin
  result := PaxArray.HighBound(1);
end;

procedure TPAXJavaScriptArrayObject.SetLength(Value: Integer);
begin
  PaxArray.ReDim([Value - 1]);
end;

procedure TPAXJavaScriptArrayObject.PutItem(I: Integer; const Value: Variant);
begin
  PaxArray.PutEx([I], Value);
end;

function TPAXJavaScriptArrayObject.GetItem(I: Integer): Variant;
begin
  result := PaxArray.GetEx([I]);
end;

function TPAXJavaScriptArrayObject.ToString: String;
var
  V: Variant;
  I: Integer;
  S: String;
begin
  result := '';
  for I:=0 to Length - 1 do
  begin
    V := Items[I];
    if IsUndefined(V) then
      S := ''
    else
      S := ToStr(Scripter, V);
    if I > 0 then
     result := result + ',';
    result := result + S;
  end;
end;

function TPAXJavaScriptArrayObject.DefaultValue: Variant;
begin
  result := ToString;
end;

destructor TPAXJavaScriptArrayObject.Destroy;
begin
  if Assigned(PaxArray) then
    PaxArray.Free;
  inherited;
end;

procedure _Array_New(MethodBody: TPAXMethodBody);
var
  SO: TPAXJavaScriptArrayObject;
  I, L: Integer;
  ClassRec: TPaxClassRec;
  V: Variant;
begin
  with MethodBody do
  begin
    if ParamCount = 0 then
      L := 0
    else if ParamCount = 1 then
    begin
      V := Params[0].AsVariant;

      if not IsNumericString(ToString(V)) then
      begin
        ClassRec := TPAXBaseScripter(Scripter).ClassList.ArrayClassRec;
        SO := TPAXJavaScriptArrayObject.Create(ClassRec);
        SO.Length := 1;
        SO[0] := 1;
        Self := SO;
        Exit;
      end;

      L := ToInt32(V);
    end
    else
      L := ParamCount;

    ClassRec := TPAXBaseScripter(Scripter).ClassList.ArrayClassRec;
    SO := TPAXJavaScriptArrayObject.Create(ClassRec);
    SO.Length := L;

    if ParamCount > 1 then
      for I:=0 to ParamCount - 1 do
        SO[I] := Params[I].AsVariant;

    Self := SO;
  end;
end;

procedure _Array_GetProperty(M: TPAXMethodBody);
var
  SO: TPAXJavaScriptArrayObject;
  I: Integer;
  V: Variant;
begin
  with M do
  begin
    SO := TPAXJavaScriptArrayObject(Self);
    if IsDigits(Name) then
    begin
      I := StrToInt(Name);
      V := SO[I];

      if IsObject(V) then
      begin
        PSelf := nil;
      end;

      result.AsVariant := V;

//      with TPAXBaseScripter(SO.Scripter).Code do
//        Prog[N].Op := OP_GET_ITEM_EX;
    end
    else if Name = 'length' then
      result.AsVariant := SO.Length
    else
      result.AsVariant := SO.GetProperty(CreateNameIndex(Name, Scripter));
  end;
end;

procedure _Array_PutProperty(M: TPAXMethodBody);
var
  SO: TPAXJavaScriptArrayObject;
  I: Integer;
begin
  with M do
  begin
    SO := TPAXJavaScriptArrayObject(Self);
    if IsDigits(Name) then
    begin
      I := StrToInt(Name);
      SO[I] := Params[0].AsVariant;

//      with TPAXBaseScripter(SO.Scripter).Code do
//        Prog[N].Op := OP_PUT_ITEM_EX;
    end
    else
    begin
      SO.SetProperty(CreateNameIndex(Name, Scripter), Params[0].AsVariant);
      if Name = 'length' then
        SO.Length := Params[0].AsVariant;
    end;
  end;
end;

procedure _Array_toString(M: TPAXMethodBody);
begin
  with M do
    result.AsVariant := TPAXJavaScriptArrayObject(Self).ToString;
end;

procedure _Array_concat(M: TPAXMethodBody);
var
  Source, Dest: TPAXJavaScriptArrayObject;
  I, J, K, L: Integer;
  V: Variant;
  PaxArray: TPaxArray;
begin
  with M do
  begin
    Source := TPAXJavaScriptArrayObject(Self);
    L := Source.Length;
    Dest := TPAXJavaScriptArrayObject.Create(Source.ClassRec);
    Dest.Length := L;
    for I:=0 to L - 1 do
      Dest[I] := Source[I];
    K := Dest.Length - 1;
    for I:=0 to ParamCount - 1 do
    begin
      V := Params[I].AsVariant;
      if IsJavaScriptArrayObject(V) then
      begin
        Source := TPAXJavaScriptArrayObject(VariantToScriptObject(V));
        for J:=0 to Source.Length - 1 do
        begin
          Dest[K] := Source[J];
          Inc(K);
        end;
      end
      else if IsPaxArray(V) then
      begin
        PaxArray := TPAXArray(VariantToScriptObject(V).Instance);
        for J:=0 to PaxArray.HighBound(1) - 1 do
        begin
          Dest[K] := PaxArray.Get([J]);
          Inc(K);
        end;
      end
      else
      begin
        Dest[K] := V;
        Inc(K);
      end;
    end;

    result.AsVariant := ScriptObjectToVariant(Dest);

    PSelf := nil;

  end;
end;

procedure _Array_join(M: TPAXMethodBody);
var
  R, S, Separator: String;
  Source: TPAXJavaScriptArrayObject;
  J, L: Integer;
begin
  with M do
  begin
    Separator := ',';
    if ParamCount > 0 then
      Separator := ToString(Params[0].AsVariant);

    Source := TPAXJavaScriptArrayObject(Self);
    L := Source.Length;

    R := '';

    for J:=0 to L - 1 do
    begin
      S := ToString(Source[J]);
      R := R + S;
      if J < L - 1 then
        R := R + Separator;
    end;
    result.AsVariant := R;
  end;
end;

procedure _Array_pop(M: TPAXMethodBody);
var
  Source: TPAXJavaScriptArrayObject;
  L: Integer;
  V: Variant;
begin
  with M do
  begin
    Source := TPAXJavaScriptArrayObject(Self);
    L := Source.Length - 1;

    V := Source[L];
    result.AsVariant := V;
    Source.Length := L;

    if IsObject(V) then
      PSelf := nil;
  end;
end;

procedure _Array_push(M: TPAXMethodBody);
var
  Source: TPAXJavaScriptArrayObject;
  I, K: Integer;
begin
  with M do
  begin
    Source := TPAXJavaScriptArrayObject(Self);
    K := Source.Length;
    for I:=0 to ParamCount - 1 do
    begin
      Source[K] := Params[I].AsVariant;
      Inc(K);
    end;
  end;
end;

procedure _Array_reverse(M: TPAXMethodBody);
var
  Source: TPAXJavaScriptArrayObject;
  I, L: Integer;
  A: array of Variant;
begin
  with M do
  begin
    Source := TPAXJavaScriptArrayObject(Self);
    L := Source.Length;
    SetLength(A, L);
    for I:=0 to L - 1 do
      A[I] := Source[I];
    for I:=0 to L - 1 do
      Source[L - 1 - I] := A[I];
    result.AsVariant := ScriptObjectToVariant(Source);
  end;
end;

procedure _Array_shift(M: TPAXMethodBody);
var
  Source: TPAXJavaScriptArrayObject;
  I, L: Integer;
  A: array of Variant;
begin
  with M do
  begin
    Source := TPAXJavaScriptArrayObject(Self);
    L := Source.Length;
    if L = 0 then
      Exit;

    SetLength(A, L);
    for I:=0 to L - 1 do
      A[I] := Source[I];

    Dec(L);
    Source.Length := L;
    for I:=0 to L - 1 do
      Source[I] := A[I + 1];

    result.AsVariant := A[0];
  end;
end;

procedure _Array_slice(M: TPAXMethodBody);
var
  Source, Dest: TPAXJavaScriptArrayObject;
  I, IStart, IEnd, L, K: Integer;
begin
  with M do
  begin
    Source := TPAXJavaScriptArrayObject(Self);
    L := Source.Length;

    if ParamCount = 0 then
    begin
      IStart := 0;
      IEnd := L - 1;
    end
    else if ParamCount = 1 then
    begin
      IStart := ToInt32(Params[0].AsVariant);
      if IStart < 0 then
        IStart := IStart + L;
      IEnd := L - 1;
    end
    else
    begin
      IStart := ToInt32(Params[0].AsVariant);
      IEnd := ToInt32(Params[1].AsVariant);
      if IStart < 0 then
        IStart := IStart + L;
      if IEnd < 0 then
        IEnd := IEnd + L;
    end;

    L := IEnd - IStart + 1;
    if L > 0 then
    begin
      K := 0;
      Dest := TPAXJavaScriptArrayObject.Create(Source.ClassRec);
      Dest.Length := L;
      for I:=IStart to IEnd do
      begin
        Dest[K] := Source[I];
        Inc(K);
      end;
      result.AsVariant := ScriptObjectToVariant(Dest);
    end;
  end;
end;

procedure _Array_sort(M: TPAXMethodBody);
var
  Source: TPAXJavaScriptArrayObject;
  I, L: Integer;
  A: array of Variant;
begin
  with M do
  begin
    Source := TPAXJavaScriptArrayObject(Self);
    L := Source.Length;
    if L = 0 then
      Exit;

    SetLength(A, L);
    for I:=0 to L - 1 do
      A[I] := Source[I];

    SortVariants(A);

    for I:=0 to L - 1 do
      Source[I] := A[I];

    result.AsVariant := ScriptObjectToVariant(Source);
  end;
end;

procedure _Array_unshift(M: TPAXMethodBody);
var
  Source: TPAXJavaScriptArrayObject;
  I, K, L: Integer;
  A: array of Variant;
begin
  with M do
  begin
    Source := TPAXJavaScriptArrayObject(Self);
    L := Source.Length;
    if L = 0 then
      Exit;

    SetLength(A, L + ParamCount);
    K := -1;

    for I:=0 to ParamCount - 1 do
    begin
      Inc(K);
      A[K] := Params[I].AsVariant;
    end;

    for I:=0 to L - 1 do
    begin
      Inc(K);
      A[K] := Source[I];
    end;

    Source.Length := L + ParamCount;
    for I:=0 to Source.Length - 1 do
      Source[I] := A[I];

    result.AsVariant := ScriptObjectToVariant(Source);
  end;
end;

procedure _alert(MethodBody: TPAXMethodBody);
var
  I: Integer;
begin
  with MethodBody do
    for I:=0 to ParamCount - 1 do
      ErrMessageBox(toString(Params[I].AsVariant));
end;

procedure _isJavaScriptArray(MethodBody: TPAXMethodBody);
var
  SO: TPaxScriptObject;
begin
  with MethodBody do
    if IsObject(Params[0].PValue^) then
    begin
      SO := VariantToScriptObject(Params[0].PValue^);
      result.AsVariant := SO.InheritsFrom(TPaxJavaScriptArrayObject);
    end
    else
      result.AsVariant := false;
end;


var
  C, N: TPaxClassDefinition;
initialization
  BooleanClass := TPAXJavaScriptBooleanObject;
  NumberClass := TPAXJavaScriptNumberObject;
  StringClass := TPAXJavaScriptStringObject;
  DateClass := TPAXJavaScriptDateObject;
  FunctionClass := TPAXJavaScriptFunctionObject;

  with DefinitionList do
  begin
    N := AddNamespace(paxJavaScriptNamespace, nil);

/////////////// GLOBAL //////////////////////////////////
    AddMethod3('alert', _alert, 1, N, true);

    AddMethod3('eval', _eval, 1, N, true);
    AddMethod3('parseInt', _parseInt, -1, N, true);
    AddMethod3('parseFloat', _parseFloat, -1, N, true);
    AddMethod3('isNaN', _isNaN, -1, N, true);
    AddConstant('NaN', NaN, N);
    AddMethod3('memberCount', _memberCount, 1, N, true);

/////////////// OBJECT //////////////////////////////////

    C := AddClass1('Object', N, nil, _Object_GetProperty,
                                     _Object_PutProperty);
    AddMethod3('Object', _Object_New, -1, C);
    AddMethod3('Create', _Object_New, -1, C);
    AddMethod3('New', _Object_New, -1, C);

    AddMethod3('toString', _Object_toString, -1, C);
    AddMethod3('valueOf', _Object_valueOf, -1, C);

/////////////// BOOLEAN //////////////////////////////////

    C := AddClass1('Boolean', N, nil, _Object_GetProperty,
                                      _Object_PutProperty);
    AddMethod3('Boolean', _Boolean_New, -1, C);
    AddMethod3('Create', _Boolean_New, -1, C);
    AddMethod3('New', _Boolean_New, -1, C);

    AddMethod3('toString', _Object_toString, -1, C);
    AddMethod3('valueOf', _Object_valueOf, -1, C);

/////////////// DATE ////////////////////////////////////

    C := AddClass1('Date', N, nil, _Object_GetProperty,
                                   _Object_PutProperty);
    AddMethod3('Date', _Date_New, -1, C);
    AddMethod3('Create', _Date_New, -1, C);
    AddMethod3('New', _Date_New, -1, C);

    AddMethod3('valueOf', _Object_valueOf, -1, C);
    AddMethod3('getTime', _Date_getTime, -1, C);
    AddMethod3('getYear', _Date_getFullYear, -1, C);
    AddMethod3('getFullYear', _Date_getFullYear, -1, C);
    AddMethod3('getUTCFullYear', _Date_getUTCFullYear, -1, C);
    AddMethod3('getMonth', _Date_getMonth, -1, C);
    AddMethod3('getUTCMonth', _Date_getUTCMonth, -1, C);
    AddMethod3('getDate', _Date_getDate, -1, C);
    AddMethod3('getUTCDate', _Date_getUTCDate, -1, C);
//  AddMethod3('toGMTString', _Date_toGMTString, -1, C);
    AddMethod3('getDay', _Date_getDay, -1, C);
    AddMethod3('getUTCDay', _Date_getUTCDay, -1, C);
    AddMethod3('getHours', _Date_getHours, -1, C);
    AddMethod3('getUTCHours', _Date_getUTCHours, -1, C);
    AddMethod3('getMinutes', _Date_getMinutes, -1, C);
    AddMethod3('getUTCMinutes', _Date_getUTCMinutes, -1, C);
    AddMethod3('getSeconds', _Date_getSeconds, -1, C);
    AddMethod3('getUTCSeconds', _Date_getUTCSeconds, -1, C);
    AddMethod3('getMilliseconds', _Date_getMilliseconds, -1, C);
    AddMethod3('getUTCMilliseconds', _Date_getUTCMilliseconds, -1, C);

    AddMethod3('setTime', _Date_setTime, -1, C);
    AddMethod3('setMilliseconds', _Date_setMilliseconds, -1, C);
    AddMethod3('setUTCMilliseconds', _Date_setUTCMilliseconds, -1, C);
    AddMethod3('setSeconds', _Date_setSeconds, -1, C);
    AddMethod3('setUTCSeconds', _Date_setUTCSeconds, -1, C);
    AddMethod3('setMinutes', _Date_setMinutes, -1, C);
    AddMethod3('setUTCMinutes', _Date_setUTCMinutes, -1, C);
    AddMethod3('setHours', _Date_setHours, -1, C);
    AddMethod3('setUTCHours', _Date_setUTCHours, -1, C);
    AddMethod3('setDate', _Date_setDate, -1, C);
    AddMethod3('setUTCDate', _Date_setUTCDate, -1, C);
    AddMethod3('setMonth', _Date_setMonth, -1, C);
    AddMethod3('setUTCMonth', _Date_setUTCMonth, -1, C);
    AddMethod3('setFullYear', _Date_setFullYear, -1, C);
    AddMethod3('setUTCFullYear', _Date_setUTCFullYear, -1, C);

    AddMethod3('toString', _Date_toString, -1, C);
    AddMethod3('toGMTString', _Date_toGMTString, -1, C);
    AddMethod3('getTimezoneOffset', _Date_getTimezoneOffset, -1, C);
    AddMethod3('valueOf', _Object_valueOf, -1, C);

/////////////// MATH ////////////////////////////////////

    C := AddClass1('Math', N, nil, _Object_GetProperty,
                                   _Object_PutProperty);
    AddMethod3('abs', _Math_abs, -1, C, true);
    AddMethod3('acos', _Math_acos, -1, C, true);
    AddMethod3('asin', _Math_asin, -1, C, true);
    AddMethod3('atan', _Math_atan, -1, C, true);
    AddMethod3('atan2', _Math_atan2, -1, C, true);
    AddMethod3('ceil', _Math_ceil, -1, C, true);
    AddMethod3('cos', _Math_cos, -1, C, true);
    AddMethod3('exp', _Math_exp, -1, C, true);
    AddMethod3('floor', _Math_floor, -1, C, true);
    AddMethod3('log', _Math_log, -1, C, true);
    AddMethod3('max', _Math_max, -1, C, true);
    AddMethod3('min', _Math_min, -1, C, true);
    AddMethod3('pow', _Math_pow, -1, C, true);
    AddMethod3('random', _Math_random, -1, C, true);
    AddMethod3('round', _Math_round, -1, C, true);
    AddMethod3('sin', _Math_sin, -1, C, true);
    AddMethod3('sqrt', _Math_sqrt, -1, C, true);
    AddMethod3('tan', _Math_tan, -1, C, true);
    AddConstant('PI', PI, C, true); 
    AddConstant('E', 2.7182818284590452354, C, true);
    AddConstant('LN10', 2.302585092994046, C, true);
    AddConstant('LN2', 0.6931471805599453, C, true);
    AddConstant('LOG2E', 1.4426950408889634, C, true);
    AddConstant('LOG10E', 0.434294819032518, C, true);
    AddConstant('SQRT1_2', 0.7071067811865476, C, true);
    AddConstant('SQRT2', 1.4142135623730951, C, true);

/////////////// FUNCTION //////////////////////////////////

    C := AddClass1('Function', N, nil, _Object_GetProperty,
                                       _Object_PutProperty);
    AddMethod3('Function', _Function_New, -1, C);
    AddMethod3('Create', _Function_New, -1, C);
    AddMethod3('New', _Function_New, -1, C);
    AddMethod3('valueOf', _Object_valueOf, -1, C);

/////////////// STRING //////////////////////////////////

    C := AddClass1('String', N, nil, _String_GetProperty,
                                     _String_PutProperty);
    AddMethod3('String', _String_New, -1, C);
    AddMethod3('Create', _String_New, -1, C);
    AddMethod3('New', _String_New, -1, C);

    AddMethod3('anchor', _String_anchor, -1, C);
    AddMethod3('big', _String_big, -1, C);
    AddMethod3('blink', _String_blink, -1, C);
    AddMethod3('bold', _String_bold, -1, C);
    AddMethod3('charAt', _String_charAt, -1, C);
    AddMethod3('charCodeAt', _String_charCodeAt, -1, C);
    AddMethod3('concat', _String_concat, -1, C);
    AddMethod3('fixed', _String_fixed, -1, C);
    AddMethod3('fontcolor', _String_fontcolor, -1, C);
    AddMethod3('fontsize', _String_fontsize, -1, C);
    AddMethod3('fromCharCode', _String_fromCharCode, -1, C);
    AddMethod3('indexOf', _String_indexOf, -1, C);
    AddMethod3('lastIndexOf', _String_lastIndexOf, -1, C);
    AddMethod3('italics', _String_italics, -1, C);
    AddMethod3('link', _String_link, -1, C);

    AddMethod3('match', _String_match, -1, C);
    AddMethod3('replace', _String_replace, -1, C);
    AddMethod3('search', _String_search, -1, C);

    AddMethod3('slice', _String_slice, -1, C);
    AddMethod3('small', _String_small, -1, C);
    AddMethod3('strike', _String_strike, -1, C);
    AddMethod3('sub', _String_sub, -1, C);
    AddMethod3('sup', _String_sup, -1, C);

    AddMethod3('split', _String_split, -1, C);

    AddMethod3('substr', _String_substr, -1, C);
    AddMethod3('substring', _String_substring, -1, C);
    AddMethod3('toLowerCase', _String_toLowerCase, -1, C);
    AddMethod3('toUpperCase', _String_toUpperCase, -1, C);
    AddMethod3('toString', _Object_toString, -1, C);
    AddMethod3('valueOf', _String_valueOf, -1, C);

/////////////// NUMBER //////////////////////////////////

    C := AddClass1('Number', N, nil, _Object_GetProperty,
                                     _Object_PutProperty);
    AddMethod3('Number', _Number_New, -1, C);
    AddMethod3('Create', _Number_New, -1, C);
    AddMethod3('New', _Number_New, -1, C);

    AddMethod3('toString', _Object_toString, -1, C);
    AddMethod3('valueOf', _Object_valueOf, -1, C);

/////////////// ARRAY //////////////////////////////////

    C := AddClass1('Array', N, nil, _Array_GetProperty,
                                    _Array_PutProperty);

    AddMethod3('Array', _Array_New, -1, C);
    AddMethod3('Create', _Array_New, -1, C);
    AddMethod3('New', _Array_New, -1, C);

    AddMethod3('toString', _Array_toString, -1, C);
    AddMethod3('concat', _Array_concat, -1, C);
    AddMethod3('join', _Array_join, -1, C);
    AddMethod3('pop', _Array_pop, -1, C);
    AddMethod3('push', _Array_push, -1, C);
    AddMethod3('reverse', _Array_reverse, -1, C);
    AddMethod3('shift', _Array_shift, -1, C);
    AddMethod3('slice', _Array_slice, -1, C);
    AddMethod3('sort', _Array_sort, -1, C);
    AddMethod3('unshift', _Array_unshift, -1, C);

    AddMethod3('valueOf', _Object_valueOf, -1, C);
  end;
 DefListInitialCount := DefinitionList.Count;
  
end.
