////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_REGEXP.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////


unit BASE_REGEXP;
interface
uses
  Classes,
  SysUtils,
  BASE_SYS,
  BASE_EXTERN,
  RegExpr1;

type
  RegExp = class(TPersistent)
  private
    fLastIndex: Integer;
    fRegExpr: TRegExpr;
    scripter: Pointer;
    fZERO_BASED_STRINGS: Boolean;
    function GetSource: Variant;
    procedure SetSource(const Value: Variant);
    function GetInput: Variant;
    procedure SetInput(const Value: Variant);
    function GetGlobal: Boolean;
    procedure SetGlobal(const Value: Boolean);
    function GetIgnoreCase: Boolean;
    procedure SetIgnoreCase(const Value: Boolean);
    function GetMultiLine: Boolean;
    procedure SetMultiLine(const Value: Boolean);
  public
    constructor Create(const Source: String = ''; const Modifiers: String = '');
    destructor Destroy; override;
    function Test(const InputString: Variant): Boolean;
    procedure Compile;
    function Exec(const InputString: Variant): TPaxArray;
    function Execute(const InputString: Variant): TPaxArray;
    function MatchCount: Integer;
    function Replace(const Expression, ReplaceStr: Variant): String;
    function toString: String;
    function RegExpr: TRegExpr;
    procedure SetScripter(s: Pointer);
  published
    property Global: Boolean read GetGlobal write SetGlobal;
    property IgnoreCase: Boolean read GetIgnoreCase write SetIgnoreCase;
    property MultiLine: Boolean read GetMultiLine write SetMultiLine;
    property LastIndex: Integer read fLastIndex write fLastIndex;
    property Source: Variant read GetSource write SetSource;
    property Input: Variant read GetInput write SetInput;
  end;

procedure Initialization_BASE_REGEXP;

implementation

uses
  BASE_CLASS, BASE_SCRIPTER;

constructor RegExp.Create(const Source: String = ''; const Modifiers: String = '');
begin
  inherited Create;
  fRegExpr := TRegExpr.Create;
  SetSource(Source);
  fLastIndex := 1;

  if Length(Modifiers) = 0 then
  begin
    Global := false;
    IgnoreCase := false;
    MultiLine := false;
  end
  else
  begin
    Global := PosCh('g', UpperCase(Modifiers)) > 0;
    IgnoreCase := PosCh('i', UpperCase(Modifiers)) > 0;
    MultiLine := PosCh('m', UpperCase(Modifiers)) > 0;
  end;
end;

destructor RegExp.Destroy;
begin
  fRegExpr.Free;
  inherited;
end;

procedure RegExp.SetScripter(s: Pointer);
begin
  scripter := s;
  if TPaxBaseScripter(s).Code.SignZERO_BASED_STRINGS then
    fZERO_BASED_STRINGS := true
  else
    fZERO_BASED_STRINGS := false;
end;

function RegExp.RegExpr: TRegExpr;
begin
  result := fRegExpr;
end;

function RegExp.MatchCount: Integer;
begin
  result := fRegExpr.SubExprMatchCount;
end;

function RegExp.GetSource: Variant;
begin
  result := fRegExpr.Expression;
end;

procedure RegExp.SetSource(const Value: Variant);
begin
  fRegExpr.Expression := Value;
end;

function RegExp.GetInput: Variant;
begin
  result := fRegExpr.InputString;
end;

procedure RegExp.SetInput(const Value: Variant);
begin
  fRegExpr.InputString := Value;
end;

function RegExp.GetGlobal: Boolean;
begin
  result := fRegExpr.ModifierG;
end;

procedure RegExp.SetGlobal(const Value: Boolean);
begin
  fRegExpr.ModifierG := Value;
end;

function RegExp.GetIgnoreCase: Boolean;
begin
  result := fRegExpr.ModifierI;
end;

procedure RegExp.SetIgnoreCase(const Value: Boolean);
begin
  fRegExpr.ModifierI := Value;
end;

function RegExp.GetMultiLine: Boolean;
begin
  result := fRegExpr.ModifierM;
end;

procedure RegExp.SetMultiLine(const Value: Boolean);
begin
  fRegExpr.ModifierM := Value;
end;

function RegExp.Test(const InputString: Variant): Boolean;
begin
  result := fRegExpr.Exec(InputString);
end;

function RegExp.Exec(const InputString: Variant): TPaxArray;
var
  I, L: Integer;
  _InputString: String;
begin
  _InputString := InputString;

  fRegExpr.InputString := _InputString;
  L := Length(_InputString);
  if LastIndex >= L then
  begin
    LastIndex := 1;
    result := TPAXArray.Create([0]);
    result.length := 0;

    result.LastIndex := LastIndex;
    result.InputString := InputString;
    Exit;
  end;

  if fRegExpr.ExecPos(LastIndex) then
  begin
    result := TPAXArray.Create([fRegExpr.SubExprMatchCount]);

    for I:=0 to fRegExpr.SubExprMatchCount do
       result.Put([I], fRegExpr.Match[I]);

    if fZERO_BASED_STRINGS then
    begin
      with fRegExpr do
      if MatchLen[0] = 0 then
        LastIndex := MatchPos[0]
      else
        LastIndex := MatchPos[0] + MatchLen[0];
      result.Index := fRegExpr.MatchPos[0] - 1;
      result.LastIndex := LastIndex - 1;
    end
    else
    begin
      with fRegExpr do
      if MatchLen[0] = 0 then
        LastIndex := MatchPos[0] + 1
      else
        LastIndex := MatchPos[0] + MatchLen[0] + 1;
      result.Index := fRegExpr.MatchPos[0];
      result.LastIndex := LastIndex;
    end;

    result.InputString := InputString;
  end
  else
  begin
    result := TPAXArray.Create([0]);
    result.length := 0;
    result.LastIndex := LastIndex;
    result.InputString := InputString;
  end;
end;

procedure RegExp.Compile;
begin
  fRegExpr.Compile;
end;

function RegExp.toString: String;
begin
  result := '/' + Source + '/';
  if Global then
    result := result + 'g';
  if IgnoreCase then
    result := result + 'i';
  if MultiLine then
    result := result + 'm';
end;

function RegExp.Execute(const InputString: Variant): TPaxArray;
var
  I: Integer;
  P: TPaxIds;
begin
  fRegExpr.InputString := InputString;
  P := TPaxIds.Create(true);
  try
    if fRegExpr.Exec(InputString) then
    begin
      repeat
        P.Add(fRegExpr.MatchPos[0]);
      until not fRegExpr.ExecNext;
    end;
    result := TPAXArray.Create([P.Count - 1]);
    for I:=0 to P.Count - 1 do
      result.Put([I], P[I]);
  finally
    P.Free;
  end;
end;

function RegExp.Replace(const Expression, ReplaceStr: Variant): String;
begin
  result := fRegExpr.Replace(Expression, ReplaceStr);
end;

function RegExp_GetMatch(I: Integer): String;
begin
  result := RegExp(__Self).fRegExpr.Match[I];
end;

function RegExp_GetMatchLen(I: Integer): Integer;
begin
  result := RegExp(__Self).fRegExpr.MatchLen[I];
end;

function RegExp_GetMatchPos(I: Integer): Integer;
begin
  if RegExp(__Self).fZERO_BASED_STRINGS then
    result := RegExp(__Self).fRegExpr.MatchPos[I] - 1
  else
    result := RegExp(__Self).fRegExpr.MatchPos[I];
end;

procedure Initialization_BASE_REGEXP;
begin
  with DefinitionList do
  begin
    AddClass2(RegExp, nil, nil, nil);

    AddMethod2(RegExp,  'constructor Create(const Source: String = ''''; const Modifiers: String = '''');', @RegExp.Create);

//    AddMethod2(RegExp, 'procedure RegExp;', @RegExp.Create);

    AddMethod2(RegExp, 'destructor Destroy;', @RegExp.Destroy);

    AddMethod2(RegExp, 'procedure compile;', @RegExp.Compile);
    AddMethod2(RegExp, 'function test(const InputString: Variant): Boolean;', @RegExp.Test);
    AddMethod2(RegExp, 'function execute(const InputString: Variant): TPaxArray;', @RegExp.Execute);
    AddMethod2(RegExp, 'function exec(const InputString: Variant): TPaxArray;', @RegExp.Exec);
    AddMethod2(RegExp, 'function toString: String', @RegExp.ToString);
    AddMethod2(RegExp, 'function replace(const Expression, ReplaceStr: Variant): String;',
                        @RegExp.Replace);

    AddFakeMethod(RegExp, 'function GetMatch(I: Integer): String;', @RegExp_GetMatch, false);

    AddProperty3(RegExp, 'property match[I: Integer]: Variant read GetMatch; default;');

    AddFakeMethod(RegExp, 'function GetMatchPos(I: Integer): Integer;', @RegExp_GetMatchPos);
    AddProperty3(RegExp, 'property matchPos[I: Integer]: Variant read GetMatchPos;');

    AddFakeMethod(RegExp, 'function GetMatchLen(I: Integer): Integer;', @RegExp_GetMatchLen);
    AddProperty3(RegExp, 'property matchLen[I: Integer]: Variant read GetMatchLen;');

  end;
end;

end.
