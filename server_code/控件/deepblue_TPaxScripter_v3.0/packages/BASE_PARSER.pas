////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.                                  
// Code Version: 3.0
// ========================================================================
// Unit: BASE_PARSER.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////


{$I PaxScript.def}
unit BASE_PARSER;

interface

uses
{$IFDEF VARIANTS}
  Variants,
{$ENDIF}
  SysUtils,
  Classes,
  BASE_CONSTS,
  BASE_SYS,
  BASE_SCANNER,
  BASE_SYMBOL,
  BASE_CLASS,
  BASE_CODE;

type
  TPAXParser = class;
  TPAXParserClass = class of TPAXParser;

  TPAXLevelStack = class(TPAXStack)
  private
    Parser: TPAXParser;
    ClassList: TPAXClassList;
    SymbolTable: TPAXSymbolTable;
    StateStack: TPAXStack;
  public
    constructor Create(Parser: TPAXParser);
    destructor Destroy; override;
    procedure SetScripter(AScripter: Pointer);
    function PushSub(SubID, ClassID: Integer; ml: TPAXModifierList): TPaxMemberRec;
    procedure PushClass(ClassID, AncestorClassID: Integer; ml: TPAXModifierList;
                        ck: TPAXClassKind; UpCase: Boolean);
    function PushTempClass: Integer;
    function KindTop: Integer;
    procedure Save;
    procedure Restore;
  end;

  TKeywordList = class(TStringList)
    function IndexOf(const S: string): Integer; override;
  end;

  TPaxBaseLanguage = class(TComponent)
  protected
    function GetLongStrLiterals: Boolean; virtual; abstract;
  end;

  TPAXParser = class
  private
    function GetName(ID: Integer): String;
    procedure SetName(ID: Integer; const Value: String);
    function GetKind(ID: Integer): Integer;
    procedure SetKind(ID: Integer; Value: Integer);
    function GetNameIndex(ID: Integer): Integer;
    procedure SetNameIndex(ID: Integer; Value: Integer);
    function GetVariant(ID: Integer): Variant;
    procedure SetVariant(ID: Integer; const Value: Variant);
    function GetAddress(ID: Integer): Pointer;
    procedure SetAddress(ID: Integer; Value: Pointer);
    procedure SetTypeID(ID: Integer; Value: Integer);
    function GetTypeID(ID: Integer): Integer;
    procedure SetCount(ID: Integer; Value: Integer);
    function GetCount(ID: Integer): Integer;
    procedure SetNext(ID: Integer; Value: Integer);
    function GetNext(ID: Integer): Integer;
    procedure SetTypeSub(SubID: Integer; Value: TPAXTypeSub);
    function GetTypeSub(SubID: Integer): TPAXTypeSub;
  public
    Scripter: Pointer;
    ModuleID: Integer;

    SymbolTable: TPAXSymbolTable;
    Scanner: TPAXScanner;
    ClassList: TPAXClassList;
    Code: TPAXCode;

    CurrToken: TPAXToken;
    UpCase: boolean;
    Keywords: TKeywordList;

    LevelStack: TPAXLevelStack;
    WithStack: TPAXWithStack;
    EntryStack: TPAXEntryStack;
    UsingList: TPAXUsingList;
    TempObjectList: TPAXIds;
    ArrayArgumentList: TPAXIds;
    LocalVars: TPAXIds;

    StatementLabel: String;

    TempCount: Integer;

    DeclareSwitch: boolean;
    FieldSwitch: boolean;
    DirectiveSwitch: boolean;
    OptionExplicit: Boolean;
    ShortEvalSwitch: Boolean;

    NewID: boolean;

    ArgumentListSwitch: Boolean;

    LanguageName, FileExt, IncludeFileExt: String;
    _Language: TPaxBaseLanguage;
    DefaultCallConv: Integer;
    NamespaceAsModule: Boolean;
    SyntaxCheckOnly: Boolean;
    JavaScriptOperators: Boolean;
    DeclareVariables: Boolean;
    IsArrayInitialization: Boolean;
    VBArrays: Boolean;
    ZeroBasedStrings: Boolean;
    Backslash: Boolean;

    BlockCount: Integer;

    IsImplementationSection: Boolean;
    IsExecutable: Boolean;

    DuplicateVars: Boolean;

    WithCount: Integer;

    constructor Create; virtual;
    destructor Destroy; override;
    procedure BeginBlock;
    procedure EndBlock;

    procedure SetScripter(AScripter: Pointer);
    procedure Reset; virtual;
    procedure AddExtraCode(const Key, StrCode: String);

    function NewLabel: Integer;
    function NewField(const FieldName: String): Integer;
    function NewVar: Integer; overload;
    function NewVar(const V: Variant): Integer; overload;
    function NewConst(const Value: Variant): Integer;
    function NewRef: Integer;
    function IsCurrText(const S: String): boolean;
    function IsNextText(const S: String): boolean;
    function IsNext2Text(const S: String): boolean;
    function NextToken: TPAXToken;
    function Next2Text: String;
    procedure Match(const S: String); virtual;
    procedure Call_SCANNER; virtual;

    function Gen(Op, Arg1, Arg2, Res: Integer): Integer; virtual;
    procedure GenAt(N: Integer; Op, Arg1, Arg2, Res: Integer);
    procedure LinkVariables(SubID: Integer; HasResult: Boolean);

    procedure GenRef(Arg1: Integer; ma: TPAXMemberAccess; Res: Integer);
    function GenEvalWith(ID: Integer): Integer;
    function InUsing(const MemberName: String): Integer;
    function GenBeginWith(ID: Integer): Integer;
    procedure GenEndWith(WithCount: Integer);
    procedure GenHtml;

    procedure SetLabelHere(L: Integer);
    function IsConstant: boolean; virtual;
    function IsKeyword(const S: String): boolean;
    function CurrLevel: Integer;
    function IsNestedSub(SubID: Integer): Boolean;
    function GetOuterSubID(SubID: Integer): Integer;
    function LookUpID(const Name: String): Integer;
    function LookUpLocalID(const Name: String): Integer;
    function IsLabelId: boolean;
    function LA(I: Integer): Char;
    function CurrClassID: Integer;
    function CurrMethodID: Integer;
    function CurrThisID: Integer;
    function CurrResultID: Integer;
    function CurrSubID: Integer;
    function CurrClassRec: TPAXClassRec;
    function ToInteger(ID: Integer): Integer;
    function ToBoolean(ID: Integer): Integer;
    function ToString(ID: Integer): Integer;
    function IsCallOperator(var Arg1, Arg2, Res: Integer): boolean; overload;
    function IsCallOperator: boolean; overload;
    function UndefinedID: Integer;
    procedure RemoveLastOperator;
    function LastCodeLine: Integer;
    procedure InsertCode(L1, L2: Integer);
    procedure SetVars(Vars: Integer);
//    function strIncompatibleTypes(T1, T2: Integer): String;
//    function MatchAssignment(ID1, ID2, ResID: Integer;
//                             RaiseException: Boolean = true;
//                             InitT1: Integer = 0;
//                             InitT2: Integer = 0): Integer;
//    procedure MatchTypes; virtual;
//    procedure MatchTheseTypes(S: TIntegerSet); virtual;
//    procedure CompareTypes; virtual;
    function Parse_ArgumentList(SubID: Integer; var Vars: Integer;
                                       CheckCall: Boolean = true;
                                       Erase: Boolean = true): Integer; virtual;
    function Parse_ArrayLiteral: Integer; virtual;
    procedure Parse_ObjectInitializer(ObjectID: Integer);
    procedure GenDestroyTempObjects;
    procedure GenDestroyArrayArgumentList;
    procedure GenDestroyLocalVars; virtual;
    function OpResultType(T1, T2: Integer): Integer;

    procedure Parse_Program; virtual; abstract;

    procedure Parse_ImportsStmt;
    function Parse_Rank: Integer;
    function Parse_ByRef: Integer;
    function Parse_SetLabel: Integer;
    function Parse_UseLabel: Integer;
    function Parse_Constant: Integer;
    function Parse_Ident: Integer;
    function Parse_OverloadableOperator: Integer; virtual;
    procedure Parse_GoToStmt;
    procedure Parse_PrintList;
    procedure Parse_PrintlnList;
    function Parse_StringLiteral: Integer;
    function Parse_CallConv: Integer;
    procedure Parse_ReducedAssignment(LeftID: Integer);
    function Parse_ShortEvalAND(ID: Integer;
                                Method0: TIntegerMethodNoParam;
                                Method1: TIntegerMethodOneParam): Integer;
    function Parse_ShortEvalOR(ID: Integer;
                               Method0: TIntegerMethodNoParam;
                               Method1: TIntegerMethodOneParam): Integer;

    function BinOp(OP, Arg1, Arg2: Integer): Integer;
    function IsOperator(OperList: TPAXIds; var OP: Integer): Boolean;
    procedure MoveUpSourceLine;
    function IsBaseType(const S: String): Boolean; virtual;
    procedure TestDupLocalVars(NewVarID: Integer);

    function Parse_RegExpr(const ConstructorName: String): Integer;
    function Parse_EvalExpression: Integer; virtual; abstract;
    function Parse_ArgumentExpression: Integer; virtual; abstract;
    procedure Parse_StmtList; virtual; abstract;
    property Name[ID: Integer]: String read GetName write SetName;
    property NameIndex[ID: Integer]: Integer read GetNameIndex write SetNameIndex;
    property Kind[ID: Integer]: Integer read GetKind write SetKind;
    property Value[ID: Integer]: Variant read GetVariant write SetVariant;
    property Address[ID: Integer]: Pointer read GetAddress write SetAddress;
    property TypeID[ID: Integer]: Integer read GetTypeID write SetTypeID;
    property Count[ID: Integer]: Integer read GetCount write SetCount;
    property Next[ID: Integer]: Integer read GetNext write SetNext;
    property TypeSub[ID: Integer]: TPAXTypeSub read GetTypeSub write SetTypeSub;
  end;

  TPAXParserList = class
  private
    fList: TList;
    function GetParser(I: Integer): TPAXParser;
    function GetName(I: Integer): String;
  public
    constructor Create;
    destructor Destroy; override;
    function Count: Integer;
    function IndexOf(P: TPAXParser): Integer;
    function Add(P: TPAXParser): Integer;
    function IndexOfLanguage(const LanguageName: String): Integer;
    function GetFileExt(const LanguageName: String): String;
    function GetLanguageName(const FileName: String): String;
    function FindParser(const LanguageName: String): TPAXParser;
    procedure RemoveParser(I: Integer);
    property Parsers[I: Integer]: TPAXParser read GetParser; default;
    property Names[I: Integer]: String read GetName;
  end;

implementation

uses
  BASE_SCRIPTER, BASE_EXTERN;

function TKeywordList.IndexOf(const S: string): Integer;
var
  I: Integer;
begin
  result := -1;
  for I:=0 to Count - 1 do
    if Strings[I] = S then
    begin
      result := I;
      Exit;
    end;
end;

constructor TPAXParserList.Create;
begin
  fList := TList.Create;
end;

destructor TPAXParserList.Destroy;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    Parsers[I].Free;

  fList.Free;
end;

function TPAXParserList.GetParser(I: Integer): TPAXParser;
begin
  result := fList[I];
end;

function TPAXParserList.IndexOf(P: TPAXParser): Integer;
begin
  result := fList.IndexOf(P);
end;

function TPAXParserList.Add(P: TPAXParser): Integer;
begin
  result := fList.Add(P);
end;

function TPAXParserList.Count: Integer;
begin
  result := fList.Count;
end;

function TPAXParserList.IndexOfLanguage(const LanguageName: String): Integer;
var
  I: Integer;
  P: TPAXParser;
begin
  result := -1;
  for I:=0 to fList.Count - 1 do
  begin
    P := Parsers[I];
    if StrEql(P.LanguageName, LanguageName) then
    begin
      result := I;
      Exit;
    end;
  end;
end;

function TPAXParserList.GetFileExt(const LanguageName: String): String;
var
  I: Integer;
  P: TPAXParser;
begin
  result := '';
  for I:=0 to fList.Count - 1 do
  begin
    P := Parsers[I];
    if StrEql(P.LanguageName, LanguageName) then
    begin
      result := P.FileExt;
      Exit;
    end;
  end;

  raise Exception.Create(errUnknownLanguage + LanguageName);
end;

function TPAXParserList.GetLanguageName(const FileName: String): String;
var
  I: Integer;
  P: TPAXParser;
  FileExt: String;
begin
  FileExt := UpperCase(ExtractFileExt(FileName));

  result := '';
  for I:=0 to fList.Count - 1 do
  begin
    P := Parsers[I];
    if StrEql(P.FileExt, FileExt) then
    begin
      result := P.LanguageName;
      Exit;
    end;
  end;

  raise Exception.Create(errIncorrectFileExtension + FileExt);
end;

function TPAXParserList.FindParser(const LanguageName: String): TPAXParser;
var
  I: Integer;
begin
  result := nil;
  I := IndexOfLanguage(LanguageName);
  if I = -1 then
    Exit;
  result := Parsers[I];
end;

procedure TPAXParserList.RemoveParser(I: Integer);
begin
  Parsers[I].Free;
  fList.Delete(I);
end;

function TPAXParserList.GetName(I: Integer): String;
begin
  result := Parsers[I].LanguageName;
end;

constructor TPAXLevelStack.Create(Parser: TPAXParser);
begin
  inherited Create;
  Self.Parser := Parser;
  StateStack := TPAXStack.Create;
end;

destructor TPAXLevelStack.Destroy;
begin
  StateStack.Free;
  inherited;
end;

procedure TPAXLevelStack.SetScripter(AScripter: Pointer);
begin
  ClassList := TPAXBaseScripter(AScripter).ClassList;
  SymbolTable := TPAXBaseScripter(AScripter).SymbolTable;
end;

function TPAXLevelStack.KindTop: Integer;
begin
  result := SymbolTable.Kind[Top];
end;

function TPAXLevelStack.PushSub(SubID, ClassID: Integer; ml: TPAXModifierList): TPaxMemberRec;
var
  IsNestedSub: Boolean;
  MemberRec: TPAXMemberRec;
  b: Boolean;
begin
  IsNestedSub := KindTop = KindSUB;

  Push(SubID);

  result := nil;

  if ClassID <> 0 then
    if not IsNestedSub then
    with Parser do
    begin
      if modSTATIC in CurrClassRec.ml then
        ml := ml + [modSTATIC];

      MemberRec := CurrClassRec.AddMethod(SubID, ml);

      result := MemberRec;

      if UpCase then
        b := StrEql(Name[SubID], 'Initialize')
      else
        b := Name[SubID] = 'Initialize';

      if b then
        MemberRec.InitN := 1;
    end;
end;

procedure TPAXLevelStack.PushClass(ClassID, AncestorClassID: Integer; ml: TPAXModifierList;
                                ck: TPAXClassKind; UpCase: Boolean);
var
  OwnerID: Integer;
begin
  OwnerID := 0;
  if Top <> 0 then
  begin
    Parser.CurrClassRec.AddNestedClass(ClassID, ml);
    OwnerID := Parser.CurrClassRec.ClassID;
  end;

  Push(ClassID);

  with SymbolTable do
    ClassList.AddClass(ClassID, Name[ClassID], Name[OwnerID], Name[AncestorClassID], ml, ck, UpCase);
end;

function TPAXLevelStack.PushTempClass: Integer;
begin
  result := Parser.NewVar;
  SymbolTable.Kind[result] := KindTYPE;
  PushClass(result, 0, [modSTATIC], ckClass, false);
end;

procedure TPAXLevelStack.Save;
begin
  StateStack.Push(Card);
end;

procedure TPAXLevelStack.Restore;
begin
  Card := StateStack.Pop;
end;

constructor TPAXParser.Create;
begin
  Scripter := nil;

  SymbolTable := nil;
  ClassList := nil;
  Code := nil;
  Scanner := nil;

  _Language := nil;

  ArgumentListSwitch := false;

  Keywords := TKeywordList.Create;
  LevelStack := TPAXLevelStack.Create(Self);
  WithStack := TPAXWithStack.Create;
  EntryStack := TPAXEntryStack.Create;
  UsingList := TPAXUsingList.Create;
  TempObjectList := TPAXIds.Create(false);
  ArrayArgumentList := TPAXIds.Create(false);
  LocalVars := TPAXIds.Create(false);

  ShortEvalSwitch := true;
  SyntaxCheckOnly := false;
  JavaScriptOperators := false;
  ZeroBasedStrings := false;
  IsArrayInitialization := true;
  DeclareVariables := false;
  VBArrays := false;
  Backslash := true;
  DuplicateVars := false;

  Reset;
end;

destructor TPAXParser.Destroy;
begin
  Keywords.Free;
  LevelStack.Free;
  WithStack.Free;
  EntryStack.Free;
  UsingList.Free;
  Scanner.Free;
  TempObjectList.Free;
  ArrayArgumentList.Free;
  LocalVars.Free;

  inherited;
end;

procedure TPAXParser.Reset;
begin
  WithCount := 0;
  StatementLabel := '';
  DeclareSwitch := false;
  FieldSwitch := false;
  DirectiveSwitch := false;
  OptionExplicit := true;
  TempCount := 0;
  LevelStack.Clear;
  WithStack.Clear;
  EntryStack.Clear;
  UsingList.Clear;
  TempObjectList.Clear;
  ArrayArgumentList.Clear;
  LocalVars.Clear;
  BlockCount := 0;

  IsImplementationSection := false;
  IsExecutable := false;
  DuplicateVars := false;
end;

procedure TPAXParser.BeginBlock;
begin
  Inc(BlockCount);
end;

procedure TPAXParser.EndBlock;
begin
  Dec(BlockCount);
end;

procedure TPAXParser.SetScripter(AScripter: Pointer);
begin
  Reset;

  Scripter := AScripter;

  TPAXBaseScripter(Scripter).fLongStrLiterals := _Language.GetLongStrLiterals;

  SymbolTable := TPAXBaseScripter(Scripter).SymbolTable;
  ClassList := TPAXBaseScripter(Scripter).ClassList;
  Code := TPAXBaseScripter(Scripter).Code;

  Scanner.SetScripter(Scripter);
  Scanner.Reset;

  LevelStack.Clear;
  LevelStack.SetScripter(Scripter);
  LevelStack.Push(0);
  LevelStack.PushClass(SymbolTable.RootNamespaceID, 0, [modSTATIC], ckClass, true);

  UsingList.Clear;
end;

procedure TPAXParser.SetName(ID: Integer; const Value: String);
begin
  SymbolTable.Name[ID] := Value;
end;

function TPAXParser.GetName(ID: Integer): String;
begin
  result := SymbolTable.Name[ID];
end;

procedure TPAXParser.SetKind(ID: Integer; Value: Integer);
begin
  SymbolTable.Kind[ID] := Value;
end;

function TPAXParser.GetKind(ID: Integer): Integer;
begin
  result := SymbolTable.Kind[ID];
end;

procedure TPAXParser.SetAddress(ID: Integer; Value: Pointer);
begin
  SymbolTable.Address[ID] := Value;
end;

function TPAXParser.GetAddress(ID: Integer): Pointer;
begin
  result := SymbolTable.Address[ID];
end;

procedure TPAXParser.SetTypeID(ID: Integer; Value: Integer);
begin
  SymbolTable.PType[ID] := Value;
end;

function TPAXParser.GetTypeID(ID: Integer): Integer;
begin
  result := SymbolTable.PType[ID];
end;

procedure TPAXParser.SetCount(ID: Integer; Value: Integer);
begin
  SymbolTable.Count[ID] := Value;
end;

function TPAXParser.GetCount(ID: Integer): Integer;
begin
  result := SymbolTable.Count[ID];
end;

procedure TPAXParser.SetNext(ID: Integer; Value: Integer);
begin
  SymbolTable.Next[ID] := Value;
end;

function TPAXParser.GetNext(ID: Integer): Integer;
begin
  result := SymbolTable.Next[ID];
end;

procedure TPAXParser.SetTypeSub(SubID: Integer; Value: TPAXTypeSub);
begin
  SymbolTable.TypeSub[SubID] := Value;
end;

function TPAXParser.GetTypeSub(SubID: Integer): TPAXTypeSub;
begin
  result := SymbolTable.TypeSub[SubID];
end;

function TPAXParser.GetNameIndex(ID: Integer): Integer;
begin
  result := SymbolTable.NameIndex[ID];
end;

procedure TPAXParser.SetNameIndex(ID: Integer; Value: Integer);
begin
  SymbolTable.NameIndex[ID] := Value;
end;

procedure TPAXParser.SetVariant(ID: Integer; const Value: Variant);
begin
  SymbolTable.PutVariant(ID, Value);
end;

function TPAXParser.GetVariant(ID: Integer): Variant;
begin
  result := SymbolTable.GetVariant(ID);
end;

function TPAXParser.NewLabel: Integer;
begin
  with SymbolTable do
  begin
    result := AppLabel;
    Level[result] := CurrLevel;
    Module[result] := ModuleID;
  end;
end;

function TPAXParser.NewRef: Integer;
begin
  with SymbolTable do
  begin
    result := AppVariant(Undefined);
    Level[result] := CurrLevel;

    Inc(TempCount);
    Name[result] := '$$' + IntToStr(TempCount);
    Kind[result] := KindREF;
    Module[result] := ModuleID;
  end;
end;

function TPAXParser.NewVar: Integer;
begin
  with SymbolTable do
  begin
    result := AppVariant(Undefined);
    Level[result] := CurrLevel;
    Module[result] := ModuleID;

    Inc(TempCount);
    Name[result] := '$$' + IntToStr(TempCount);
  end;
end;

function TPAXParser.NewField(const FieldName: String): Integer;
begin
  with SymbolTable do
  begin
    result := AppVariant(Undefined);
    Level[result] := -1;
    Name[result] := FieldName;
    Module[result] := ModuleID;
  end;
end;

function TPAXParser.NewVar(const V: Variant): Integer;
begin
  with SymbolTable do
  begin
    result := AppVariant(V);
    Level[result] := CurrLevel;
    Module[result] := ModuleID;

    Inc(TempCount);
    Name[result] := '$$' + IntToStr(result);
  end;
end;

function TPAXParser.NewConst(const Value: Variant): Integer;
var
  I: Integer;
begin
  if VarType(Value) = varByte then
  begin
    I := Value;
    result := SymbolTable.AppVariantConst(I);
  end
  else
    result := SymbolTable.AppVariantConst(Value);
end;

function TPAXParser.Gen(Op, Arg1, Arg2, Res: Integer): Integer;
var
  _OP: Integer;
  b: boolean;
begin
  if JavaScriptOperators then
  begin
    if Op = OP_PLUS then
      Op := Op_PLUS_EX
    else if Op = OP_MINUS then
      Op := Op_MINUS_EX
    else if Op = OP_UNARY_MINUS then
      Op := Op_UNARY_MINUS_EX
    else if Op = OP_MULT then
      Op := Op_MULT_EX
    else if Op = OP_DIV then
      Op := Op_DIV_EX
    else if Op = OP_MOD then
      Op := Op_MOD_EX
    else if Op = OP_LEFT_SHIFT then
      Op := Op_LEFT_SHIFT_EX
    else if Op = OP_RIGHT_SHIFT then
      Op := Op_RIGHT_SHIFT_EX
    else if Op = OP_UNSIGNED_RIGHT_SHIFT then
      Op := Op_UNSIGNED_RIGHT_SHIFT_EX
    else if Op = OP_EQ then
      Op := Op_EQ_EX
    else if Op = OP_NE then
      Op := Op_NE_EX
    else if Op = OP_ID then
      Op := Op_ID_EX
    else if Op = OP_NI then
      Op := Op_NI_EX
    else if Op = OP_LT then
      Op := Op_LT_EX
    else if Op = OP_LE then
      Op := Op_LE_EX
    else if Op = OP_GT then
      Op := Op_GT_EX
    else if Op = OP_GE then
      Op := Op_GE_EX
    else if Op = OP_GO_FALSE then
      Op := Op_GO_FALSE_EX
    else if Op = OP_GO_TRUE then
      Op := Op_GO_TRUE_EX;
  end;

  if Op = OP_SET_TYPE then
    if IsBaseType(_GetName(Arg2, Scripter)) or (Arg2 = 0) then
    begin
      result := Code.Card;
      Exit;
    end;


  if
     (OP = OP_GO) or
//   (Op = OP_ASSIGN) or
     (OP = OP_PLUS) or (OP = OP_PLUS_EX) or
     (OP = OP_MINUS) or (OP = OP_MINUS_EX) or
     (OP = OP_MULT) or (OP = OP_MULT_EX) or
     (OP = OP_DIV) or (OP = OP_DIV_EX) or
     (OP = OP_INT_DIV) or
     (OP = OP_MOD) or (OP = OP_MOD_EX) or
     (OP = OP_AND) or
     (OP = OP_OR) or
     (OP = OP_XOR) or
     (OP = OP_LEFT_SHIFT) or (OP = OP_LEFT_SHIFT_EX) or
     (OP = OP_RIGHT_SHIFT) or (OP = OP_RIGHT_SHIFT_EX) or
     (OP = OP_UNSIGNED_RIGHT_SHIFT) or (OP = OP_UNSIGNED_RIGHT_SHIFT_EX) or
     (OP = OP_NOT) or
     (OP = OP_UNARY_MINUS) or (OP = OP_UNARY_MINUS_EX) or
     (OP = OP_GT) or (OP = OP_GT_EX) or
     (OP = OP_GE) or (OP = OP_GE_EX) or
     (OP = OP_LT) or (OP = OP_LT_EX) or
     (OP = OP_LE) or (OP = OP_LE_EX) or
     (OP = OP_EQ) or (OP = OP_EQ_EX) or
     (OP = OP_NE) or (OP = OP_NE_EX)
//     (OP = OP_ASSIGN_ADDRESS)
    then
    Code.RemoveNops;

  if OP = OP_ASSIGN then
  with Code do
  begin
    _OP := Prog[Card].Op;
    if Prog[Card].Res = Arg2 then
    begin
      b := false;
      b := b or (_OP = OP_PLUS) or (_OP = OP_PLUS_EX);
      b := b or (_OP = OP_MINUS) or (_OP = OP_MINUS_EX);
      b := b or (_OP = OP_MULT) or (_OP = OP_MULT_EX);
      b := b or (_OP = OP_DIV) or (_OP = OP_DIV_EX);
      b := b or (_OP = OP_INT_DIV);
      b := b or (_OP = OP_MOD) or (_OP = OP_MOD_EX);
      b := b or (_OP = OP_AND) or (_OP = OP_OR);
      b := b or    (_OP = OP_XOR);
      b := b or    (_OP = OP_LEFT_SHIFT) or (_OP = OP_LEFT_SHIFT_EX);
      b := b or    (_OP = OP_RIGHT_SHIFT) or (_OP = OP_RIGHT_SHIFT_EX);
      b := b or    (_OP = OP_UNSIGNED_RIGHT_SHIFT) or (_OP = OP_UNSIGNED_RIGHT_SHIFT_EX);

      b := b or    (_OP = OP_NOT);
      b := b or    (_OP = OP_UNARY_MINUS) or (_OP = OP_UNARY_MINUS_EX);

{     b := b or          (_OP = OP_GT) or (_OP = OP_GT_EX);
      b := b or          (_OP = OP_GE) or (_OP = OP_GE_EX);
      b := b or          (_OP = OP_LT) or (_OP = OP_LT_EX);
      b := b or          (_OP = OP_LE) or (_OP = OP_LE_EX);
      b := b or          (_OP = OP_EQ) or (_OP = OP_EQ_EX);
      b := b or          (_OP = OP_NE) or (_OP = OP_NE_EX); }

      b := b or (_OP = OP_ASSIGN_ADDRESS);

      if b then

        begin
          Prog[Card].Res := Arg1;
          result := Code.Card;
          Exit;
        end;
    end;
  end;

  Code.Add(Op, Arg1, Arg2, Res, IsExecutable);
  result := Code.Card;

  if Scanner.PosNumber = 0 then
    Code.Prog[result].LinePos := Scanner.PosNumber
  else
    Code.Prog[result].LinePos := Scanner.PosNumber - 1;

  if Op = OP_CALL then
  begin
    if Res <> 0 then
      if Kind[Arg1] = KindSUB then
        TypeID[Res] := TypeID[Arg1];
  end
  else if OP = OP_CREATE_OBJECT then
    TypeID[Res] := Arg1;
end;

procedure TPAXParser.GenAt(N: Integer; Op, Arg1, Arg2, Res: Integer);
begin
  Code.GenAt(N, Op, Arg1, Arg2, Res);
end;

procedure TPAXParser.GenRef(Arg1: Integer; ma: TPAXMemberAccess; Res: Integer);
begin
  while Code.Prog[Code.Card].Op = OP_NOP do
    Dec(Code.Card);
  Gen(OP_CREATE_REF, Arg1, Ord(ma), Res);
  SymbolTable.Kind[Res] := KindREF;
end;

function TPAXParser.IsCurrText(const S: String): boolean;
begin
  if UpCase then
    result := StrEql(CurrToken.Text, S)
  else
    result := CurrToken.Text = S;

  result := result and (CurrToken.TokenClass <> tcStringConst);
end;

function TPAXParser.IsNextText(const S: String): boolean;
begin
  if UpCase then
    result := StrEql(Scanner.NextToken.Text, S)
  else
    result := Scanner.NextToken.Text = S;
end;

function TPAXParser.IsNext2Text(const S: String): boolean;
begin
  if UpCase then
    result := StrEql(Scanner.Next2Token.Text, S)
  else
    result := Scanner.Next2Token.Text = S;
end;

function TPAXParser.Next2Text: String;
begin
  result := Scanner.Next2Token.Text;
end;

function TPAXParser.NextToken: TPAXToken;
begin
  result := Scanner.NextToken;
  if IsKeyword(result.Text) then
    result.TokenClass := tcKeyword;
end;

procedure TPAXParser.Match(const S: String);
begin
  if not IsCurrText(S) then
    raise TPAXScriptFailure.Create(Format(err_X_expected_but_Y_fond, [S, CurrToken.Text]));
end;

procedure TPAXParser.SetLabelHere(L: Integer);
begin
  if Code.Prog[Code.Card].Op = OP_PRINT_HTML then
    SymbolTable.PutVariant(L, Code.Prog[Code.Card].Res)
  else
    SymbolTable.PutVariant(L, Code.Card + 1);
end;

procedure TPAXParser.Call_SCANNER;
begin
  NewID := false;

  Scanner.ReadToken;
  CurrToken := Scanner.Token;

  if CurrToken.TokenClass = tcHtmlStringConst then
  begin
    GenHtml;
    Call_SCANNER;
    Exit;
  end;

  if CurrToken.TokenClass = tcId then
  begin
    if IsKeyword(CurrToken.Text) then
    begin
      CurrToken.TokenClass := tcKeyword;
      CurrToken.ID := 0;
    end;
  end;

  if CurrToken.TokenClass = tcSeparator then
    if CurrToken.ID <> SP_EOF then
    begin
      Gen(OP_SEPARATOR, ModuleID, CurrToken.ID, CurrLevel);
      Call_SCANNER;
      Exit;
    end;

  if FieldSwitch then
  begin
    CurrToken.ID := NewField(CurrToken.Text);
    CurrToken.TokenClass := tcID;
    SymbolTable.Position[CurrToken.ID] := CurrToken.Position - 1;

    FieldSwitch := false;
    Exit;
  end;

  if DirectiveSwitch then
  begin
    CurrToken.ID := SymbolTable.CodeStringConst(CurrToken.Text);
    DirectiveSwitch := false;
    Exit;
  end;

  case CurrToken.TokenClass of
    tcIntegerConst, tcFloatConst:
    begin
      CurrToken.ID := SymbolTable.CodeNumberConst(CurrToken.Value);
      if CurrToken.TokenClass = tcFloatConst then
        TypeID[CurrToken.ID] := typeDOUBLE;

      if JavaScriptOperators then
        TypeID[CurrToken.ID] := typeVARIANT;
      Exit;
    end;
    tcStringConst:
    begin
      CurrToken.ID := SymbolTable.CodeStringConst(CurrToken.Text);

      if JavaScriptOperators then
        TypeID[CurrToken.ID] := typeVARIANT;
      Exit;
    end;
    tcId:
    if DeclareSwitch then
    begin
      if DuplicateVars then
      begin
        CurrToken.ID := LookUpID(CurrToken.Text);
      end
      else
        CurrToken.ID := 0;

      if CurrToken.ID = 0 then
      with SymbolTable do
      begin
        CurrToken.ID := AppVariant(Undefined);
        Name[CurrToken.ID] := CurrToken.Text;
        Level[CurrToken.ID] := CurrLevel;
        Module[CurrToken.ID] := ModuleID;
        Position[CurrToken.ID] := CurrToken.Position - 1;

        NewID := true;
      end;

    end
    else
    begin
      CurrToken.ID := LookUpID(CurrToken.Text);

      if CurrToken.ID = 0 then
      begin
        with SymbolTable do
        begin
          CurrToken.ID := AppVariant(Undefined);
          Name[CurrToken.ID] := CurrToken.Text;
          Level[CurrToken.ID] := CurrLevel;
          Module[CurrToken.ID] := ModuleID;
          Position[CurrToken.ID] := CurrToken.Position - 1;

          NewID := true;
        end;
      end;
    end;
  end;
end;

function TPAXParser.IsKeyword(const S: String): boolean;
begin
  if UpCase then
    result := Keywords.IndexOf(UpperCase(S)) <> - 1
  else
    result := Keywords.IndexOf(S) <> - 1;
end;

function TPAXParser.IsConstant: boolean;
begin
  result := (CurrToken.TokenClass in [tcIntegerConst, tcFloatConst, tcStringConst]);
end;

function TPAXParser.CurrLevel: Integer;
begin
  result := LevelStack.Top;
end;

function TPAXParser.LookUpID(const Name: String): Integer;
var
  L: Integer;
begin
  L := LevelStack.Card;
  while L > 1 do
  begin
    result := SymbolTable.LookUpID(Name, LevelStack[L], UpCase);
    if result <> 0 then
      Exit;
    Dec(L);
  end;

  result := InUsing(Name);
  if result <> 0 then
    Exit;
  result := SymbolTable.LookUpID(Name, 0, UpCase);
end;

function TPAXParser.LookUpLocalID(const Name: String): Integer;
begin
  result := SymbolTable.LookUpID(Name, CurrLevel, UpCase);
end;

function TPAXParser.Parse_Rank: Integer;
begin
  result := 1;
  Match('[');
  Call_SCANNER;
  repeat
    if IsCurrText(',') then
    begin
      Inc(result);
      Call_SCANNER;
    end
    else if IsCurrText(']') then
      break
    else
      Match(']');
  until false;
  Call_SCANNER;
end;

function TPAXParser.Parse_Ident: Integer;
begin
  if CurrToken.TokenClass <> tcId then
    raise TPAXScriptFailure.Create(errIdentifierExpected);

  result := CurrToken.ID;
  Call_SCANNER;
end;

function TPAXParser.Parse_OverloadableOperator: Integer;
begin
  if OverloadableOperators.IndexOf(CurrToken.Text) = -1 then
    raise TPaxScriptFailure.Create(errOverloadableOperatorExpected);

  result := NewVar();
  Name[result] := CurrToken.Text;
  Call_SCANNER;
end;

procedure TPAXParser.Parse_GoToStmt;
begin
  Call_SCANNER;
  Gen(OP_EXIT, Parse_UseLabel, 0, 0);
end;

function TPAXParser.IsLabelId: boolean;
begin
  result := (CurrToken.TokenClass = tcId) and IsNextText(':');
end;

function TPAXParser.Parse_SetLabel: Integer;
begin
  result := Parse_Ident;

  Gen(OP_SET_LABEL, 0, 0, 0);

  with SymbolTable do
  begin
    if not IsUndefined(GetVariant(result)) then
      raise TPAXScriptFailure.Create(errLabelAlreadyDefined);

    Kind[result] := KindLABEL;
    PutVariant(result, LastCodeLine);
  end;
end;

function TPAXParser.Parse_UseLabel: Integer;
begin
  result := Parse_Ident;
  SymbolTable.Kind[result] := KindLABEL;
end;

function TPAXParser.Parse_Constant: Integer;
begin
  result := CurrToken.ID;
  Call_SCANNER;
end;

function TPAXParser.LA(I: Integer): Char;
begin
  result := Scanner.LA(I);
end;

function TPAXParser.CurrClassID: Integer;
var
  I: Integer;
begin
  result := 0;

  for I:= LevelStack.Card downto 1 do
  if I > 1 then
    if Kind[LevelStack[I]] = kindTYPE then
    begin
      result := LevelStack[I];
      Exit;
    end;
end;

function TPAXParser.CurrMethodID: Integer;
var
  I, ID: Integer;
begin
  result := 0;

  for I:= LevelStack.Card downto 1 do
  if I > 1 then
    if SymbolTable.Kind[LevelStack[I]] = kindTYPE then
    if I <> LevelStack.Card then
    begin
      ID := LevelStack[I + 1];
      if SymbolTable.Kind[ID] = kindSUB then
        result := ID;
      Exit;
    end;
end;

function TPAXParser.CurrThisID: Integer;
var
  MemberRec: TPAXMemberRec;
  ID: Integer;
begin
  result := CurrMethodID;
  if result <> 0 then
  begin
    ID := CurrClassID;
    MemberRec := ClassList.FindMember(ID, SymbolTable.NameIndex[result], maMyClass);

    if MemberRec = nil then
      raise TPaxScriptFailure.Create(errPropertyIsNotFound);

    if MemberRec.IsStatic then
      result := 0
    else
      result := SymbolTable.GetThisID(result);
  end;
end;

function TPAXParser.GetOuterSubID(SubID: Integer): Integer;
var
  I, J, ID: Integer;
begin
  result := -1;
  for I:=2 to LevelStack.Card do
    if LevelStack[I] = SubID then
    begin
      J := I - 1;
      while J > 0 do
      begin
        ID := LevelStack[J];
        if ID <= 0 then
          Exit;
        if SymbolTable.Kind[ID] = KindSUB then
        begin
          result := ID;
          Exit;
        end;
        Dec(J);
      end;
    end;
end;

function TPAXParser.IsNestedSub(SubID: Integer): Boolean;
begin
  result := GetOuterSubID(SubID) > 0;
end;

function TPAXParser.CurrResultID: Integer;
var
  MemberRec: TPAXMemberRec;
  ID: Integer;
begin
  result := CurrSubID;
  if IsNestedSub(result) then
  begin
    result := SymbolTable.GetResultID(result);
    Exit;
  end;

  if result > 0 then
  begin
    ID := CurrClassID;
    MemberRec := ClassList.FindMember(ID, SymbolTable.NameIndex[result], maMyClass);
    if MemberRec = nil then
      result := 0
    else if MemberRec.ID = 0 then
      result := 0
    else
      result := SymbolTable.GetResultID(MemberRec.ID);
  end;
end;

function TPAXParser.CurrClassRec: TPAXClassRec;
begin
  result := ClassList.FindClass(CurrClassID);
end;

function TPAXParser.CurrSubID: Integer;
var
  I: Integer;
begin
  result := 0;

  for I:= LevelStack.Card downto 1 do
  if I > 1 then
    if SymbolTable.Kind[LevelStack[I]] = kindSUB then
    begin
      result := LevelStack[I];
      Exit;
    end;
end;

function TPAXParser.ToInteger(ID: Integer): Integer;
begin
  result := NewVar;
  Gen(OP_TO_INTEGER, ID, 0, result);
end;

function TPAXParser.ToBoolean(ID: Integer): Integer;
begin
  result := NewVar;
  Gen(OP_TO_BOOLEAN, ID, 0, result);
end;

function TPAXParser.ToString(ID: Integer): Integer;
begin
  result := NewVar;
  Gen(OP_TO_STRING, ID, 0, result);
end;

function TPAXParser.IsCallOperator(var Arg1, Arg2, Res: Integer): boolean;
var
  I: Integer;
begin
  I := LastCodeLine;
  if I <= 0 then
  begin
    result := false;
    Exit;
  end;
  with Code do
  begin
    result := (Prog[I].Op = OP_CALL);
    Arg1 := Prog[I].Arg1;
    Arg2 := Prog[I].Arg2;
    Res := Prog[I].Res;
  end;
end;

function TPAXParser.IsCallOperator: boolean;
var
  I: Integer;
begin
  I := LastCodeLine;
  if I <= 0 then
  begin
    result := false;
    Exit;
  end;
  with Code do
    result := Prog[I].Op = OP_CALL;
end;

procedure TPAXParser.RemoveLastOperator;
var
  I: Integer;
begin
  I := LastCodeLine;
  if I <= 0 then
    Exit;
  Code.Card := I - 1;
end;

function TPAXParser.LastCodeLine: Integer;
var
  I: Integer;
begin
  with Code do
  begin
    I := Card;
    while I > 1 do
      if Prog[I].Op = OP_SEPARATOR then
        Dec(I)
      else
      begin
        result := I;
        Exit;
      end;
    result := 0;
  end;
end;

procedure TPAXParser.InsertCode(L1, L2: Integer);
var
  I: Integer;
begin
  with Code do
    for I:=L1 to L2 do
      if Prog[I].Op <> OP_SEPARATOR then
      begin
        Inc(Card);
        Prog[Card] := Prog[I];
      end;
end;

function TPAXParser.Parse_ByRef: Integer;
begin
  Call_SCANNER;
  result := Parse_Ident;
  SymbolTable.ByRef[result] := 1;
end;

function ExtractModuleName(const S: String): String;
var
  P: Integer;
begin
  P := Pos('.', S);
  if P = 0 then
    result := S
  else
    result := Copy(S, 1, P - 1);
end;

procedure TPAXParser.Parse_ImportsStmt;
var
  I, ID, RefID: Integer;
  S, FullName, ModuleName: String;
  L: TStringList;
begin
  CurrClassRec.UsingInitList.Add(LastCodeLine);

  L := TStringList.Create;
  try

  // match "imports"
  repeat
    S := '';

    Gen(OP_SKIP, 0, 0, 0);
    if not UpCase then
      Gen(OP_UPCASE_ON, 0, 0, 0);

    Call_SCANNER;
    ModuleName := CurrToken.Text + FileExt;
    I := L.IndexOf(ModuleName);
    if I >= 0 then
      raise Exception.Create(Format(errIdentifierIsRedeclared, [ModuleName]));

    L.Add(ModuleName);
    ID := Parse_Ident;
    ID := GenEvalWith(ID);

    while IsCurrText('.') do
    begin
      FieldSwitch := true;
      Call_SCANNER;
      RefID := Parse_Ident;
      GenRef(ID, maAny, RefID);
      ID := RefID;
    end;

    Gen(OP_USE_NAMESPACE, UsingList.Push(ID), 0, 0);

    if IsCurrText('in') then
    begin
      Call_SCANNER;
      ModuleName := CurrToken.Text;
      FullName := TPaxBaseScripter(Scripter).FindFullName(ModuleName);
      if FullName = '' then
         FullName := ModuleName;

      Gen(OP_ON_USES, NewVar(ModuleName), NewVar(FullName), 0);

      with TPaxBaseScripter(Scripter) do
        if Assigned(OnUsedModule) then
        begin
          I := Modules.IndexOf(ModuleName);
          if I <> -1 then
            S := Modules.Items[I].Text;

          OnUsedModule(TPaxBaseScripter(scripter).Owner, ExtractModuleName(ModuleName), FullName, S);
        end
        else
          ModuleName := CurrToken.Text;

      Parse_Constant;

      TPaxBaseScripter(Scripter).AddExtraModule(ModuleName, S, SyntaxCheckOnly, LanguageName);
    end
    else if NamespaceAsModule then
    begin
      with TPaxBaseScripter(Scripter) do
        if Assigned(OnUsedModule) then
        begin
          I := Modules.IndexOf(ModuleName);
          if I <> -1 then
            S := Modules.Items[I].Text;

          OnUsedModule(TPaxBaseScripter(scripter).Owner, ExtractModuleName(ModuleName), FullName, S);
        end
        else
        begin
        end;

      TPaxBaseScripter(Scripter).AddExtraModule(ModuleName, S, SyntaxCheckOnly, LanguageName);
    end;

    if not IsCurrText(',') then
      Break;
  until false;

  if not UpCase then
    Gen(OP_UPCASE_OFF, 0, 0, 0);
  Gen(OP_HALT_OR_NOP, 0, 0, 0);

  finally
    L.Free;
  end;
end;

function TPAXParser.InUsing(const MemberName: String): Integer;
var
  I, ClassID: Integer;
  ClassRec: TPAXClassRec;
  MemberRec: TPAXMemberRec;
begin
  result := 0;

  ClassRec := CurrClassRec;
  MemberRec := ClassRec.MemberList.GetMemberRec(MemberName, UpCase);
  if MemberRec <> nil then
    if MemberRec.IsStatic then
    begin
      result := MemberRec.ID;
      Exit;
    end;

  for I:=UsingList.Card downto 1 do
  begin
    ClassID := UsingList[I];
    ClassRec := ClassList.FindClass(ClassID);
    if ClassRec <> nil then
    begin
      result := ClassRec.MemberList.GetMemberID(MemberName, UpCase);
      if result <> 0 then
        Exit;
    end;
  end;
end;

function TPAXParser.GenEvalWith(ID: Integer): Integer;

function IsScriptDefinedSubID(ID: Integer): Boolean;
var
  K: Integer;
begin
  result := false;
  if ID <= 0 then
    Exit;

  K := Kind[ID];
  if K = KindSUB then
    result := true;
end;

function IsParameterID(ID: Integer): Boolean;
var
  I, SubID, ParamID: Integer;
  Success: Boolean;
label Again;
begin
  result := false;
  SubID := LevelStack.Top;

Again:

  if SymbolTable.Kind[SubID] <> KindSUB then
    Exit;

  Success := false;
  with SymbolTable do
    for I:=1 to Count[SubID] do
    begin
      ParamID := GetParamID(SubID, I);

      if UpCase then
        Success := StrEql(Name[ParamID], Name[ID])
      else
        Success := Name[ParamID] = Name[ID];

      if Success then
      begin
        result := true;
        Exit;
      end;
   end;

  if not Success then
  begin
    SubID := GetOuterSubID(SubID);
    if SubID <= 0 then
      Exit;
    goto Again;
  end;
end;

function IsLocalVar(ID: Integer): Boolean;
var
  SubID: Integer;
begin
  result := false;
  SubID := CurrSubID;

  repeat
    if SubID <= 0 then
      Exit;
    result := (SymbolTable.Level[ID] = SubID) and SymbolTable.IsLocal(ID);

    if not result then
      SubID := GetOuterSubID(SubID)
    else
      Exit;
  until false;
end;

var
  K, MemberID: Integer;
  C: TPaxClassRec;
  nonstat: Boolean;
  neg: Boolean;
begin
  result := ID;

  K := Kind[ID];

  neg := ID < 0;

  if WithCount > 0 then
    neg := false;

  if not neg then
  if SymbolTable.Level[ID] <> 0 then
//  if (K <> KindCONST) and (K <> KindSUB) then
    if not IsParameterID(ID) then
    if not IsScriptDefinedSubID(ID) then
     if not IsLocalVar(ID) then
       if CurrThisID <> ID then
         if CurrResultID <> ID then
         begin
           MemberID := InUsing(Name[ID]);

           if MemberID <> 0 then
           begin
             if Kind[MemberID] = KindSUB then
               if Count[MemberID] = 0 then
               if not IsCurrText('(') then
               begin
                 result := NewVar;
                 Gen(OP_CALL, MemberID, 0, result);
                 Exit;
               end;
             if MemberID > 0 then
               Exit
             else
             begin
               result := NewVar;
               with SymbolTable do
               begin
                 Name[result] := Name[ID];
                 Level[result] := -1;
                 Module[result] := -1;
               end;
               Gen(OP_EVAL_WITH, 0, 0, result);
               Exit;
             end;
           end;

           Gen(OP_EVAL_WITH, 0, 0, ID);
           Exit;
         end;

  if K = KindSUB then
  if Count[ID] = 0 then if not IsCurrText('(') then if not IsCurrText(':=') then
  begin
    nonstat := false;
    for K:=2 to LevelStack.Card do
      if SymbolTable.Kind[LevelStack[K]] = KindTYPE then
      begin
        C := ClassList.FindClass(LevelStack[K]);
        if C <> nil then
          if not (modSTATIC in C.ml) then
            nonstat := true;
      end;

    if (SymbolTable.Kind[LevelStack.Top] = KindSUB) and nonstat then
    begin
      K := NewVar;
      with SymbolTable do
      begin
        Name[K] := Name[ID];
        Level[K] := -1;
        Module[K] := -1;
      end;
      Gen(OP_CREATE_REF, CurrThisId, 0, K);
      result := NewVar;
      Gen(OP_CALL, K, 0, result);
    end
    else
    begin
      result := NewVar;
      Gen(OP_CALL, ID, 0, result);
    end;
  end;
end;

function TPAXParser.GenBeginWith(ID: Integer): Integer;
var
  I, TempID: Integer;
begin
  result := 0;
  for I:=2 to LevelStack.Card do
  begin
    TempID := LevelStack[I];
    if TempID <> ID then
    if SymbolTable.Kind[TempID] = KindTYPE then
    begin
      Inc(result);
      Gen(OP_BEGIN_WITH, WithStack.Push(TempID), 0, 0);
    end;
  end;

  Gen(OP_BEGIN_WITH, WithStack.Push(ID), 0, 0);
  Inc(result);
end;

procedure TPAXParser.GenEndWith(WithCount: Integer);
var
  I: Integer;
begin
  for I:=1 to WithCount do
  begin
    Gen(OP_END_WITH, 0, 0, 0);
    WithStack.Pop;
  end;
end;

procedure TPAXParser.SetVars(Vars: Integer);
begin
  Code.Prog[Code.Card].Vars := Vars;
end;

procedure TPAXParser.AddExtraCode(const Key, StrCode: String);
begin
  if Scripter <> nil then
    TPAXBaseScripter(Scripter).ExtraCodeList.AddCode(Key, LanguageName, StrCode)
  else
    raise Exception.Create(errInternalError);
end;

procedure TPAXParser.LinkVariables(SubID: Integer; HasResult: Boolean);
begin
  SymbolTable.LinkVariables(SubID, HasResult);
end;

{
procedure TPAXParser.MatchTypes;
var
  T1, T2, ResType: Integer;
label
  Fin;
begin
  ResType := typeVARIANT;
  T1 := TypeID[Code.CurrArg1ID];
  T2 := TypeID[Code.CurrArg2ID];
  if T1 = T2 then
  begin
    ResType := T1;
    goto Fin;
  end;
  if T1 = typeVARIANT then
    goto Fin;
  if T2 = typeVARIANT then
    goto Fin;

  if OpResultType(T1, T2) > 0 then
  begin
    ResType := OpResultType(T1, T2);
    goto Fin;
  end;

  raise TPAXScriptFailure.Create(strIncompatibleTypes(T1, T2));
Fin:
  TypeID[Code.CurrResID] := ResType;
end;

procedure TPAXParser.CompareTypes;
var
  T1, T2: Integer;
begin
  TypeID[Code.CurrResID] := typeBOOLEAN;
  T1 := TypeID[Code.CurrArg1ID];
  T2 := TypeID[Code.CurrArg2ID];
  if T1 = T2 then
    Exit;
  if T1 = typeVARIANT then
    Exit;
  if T2 = typeVARIANT then
    Exit;
  if Abs(T1) > PaxTypes.Count then
    Exit;
  if Abs(T2) > PaxTypes.Count then
    Exit;
  if OpResultType(T1, T2) > 0 then
    Exit;
  raise TPAXScriptFailure.Create(strIncompatibleTypes(T1, T2));
end;

function TPAXParser.MatchAssignment(ID1, ID2, ResID: Integer;
                                    RaiseException: Boolean = true;
                                    InitT1: Integer = 0;
                                    InitT2: Integer = 0): Integer;
var
  T1, T2, ResType: Integer;
label
  Fin;
begin
  ResType := typeVARIANT;
  result := ID2;

  if InitT1 = 0 then
    T1 := TypeID[ID1]
  else
    T1 := InitT1;

  if InitT2 = 0 then
    T2 := TypeID[ID2]
  else
    T2 := InitT2;

  if T1 = T2 then
  begin
    ResType := T1;
    goto Fin;
  end;

  if T1 = typeVARIANT then
  begin
    ResType := T2;
    goto Fin;
  end;

  if T2 = typeVARIANT then
    goto Fin;

  if T1 > PAXTypes.Count then
    goto Fin;

  if T2 > PAXTypes.Count then
    goto Fin;

  if T1 < 0 then
    goto Fin;

  if T2 < 0 then
    goto Fin;

  if AssResultTypes[T1, T2] then
  begin
    ResType := T1;
    goto Fin;
  end;

  TPaxBaseScripter(Scripter).Dump;

  if RaiseException then
    raise TPAXScriptFailure.Create(strIncompatibleTypes(T1, T2))
  else
  begin
    result := 0;
    Exit;
  end;
Fin:
  if ResID > 0 then
    if ResTYPE <> typeVARIANT then
      TypeID[ResID] := ResType;
end;


procedure TPAXParser.MatchTheseTypes(S: TIntegerSet);
var
  T1: Integer;
begin
  T1 := TypeID[Code.CurrArg1ID];
  if T1 <= PAXTypes.Count then
    if T1 in (S + [typeVARIANT]) then
    begin
      TypeID[Code.CurrResID] := T1;
      Exit;
    end;
  raise TPAXScriptFailure.Create(errOperatorNotApplicable);
end;

function TPAXParser.strIncompatibleTypes(T1, T2: Integer): String;
begin
  result := Format(errIncompatibleTypesExt, [Name[T1], Name[T2]]);
end;
}

function TPAXParser.Parse_ArgumentList(SubID: Integer; var Vars: Integer;
                                       CheckCall: Boolean = true;
                                       Erase: Boolean = true): Integer;
var
  CallRec: TPaxCallRec;

procedure _ParseExpr;
var
  ID, ExprID: Integer;
begin
  Inc(result);

  ExprID := Parse_ArgumentExpression;

  if Kind[ExprID] = KindCONST then
  begin
    ID := NewVar;
    Gen(OP_ASSIGN, ID, ExprID, ID);
    TypeID[ID] := TypeID[ExprID];
  end
  else
  begin
    ID := ExprID;
    SetBit(Vars, result);
  end;

  Gen(OP_PUSH, ID, result, SubID);

  if CheckCall then
  begin
    CallRec.ArgsN.Add(Code.Card);
    CallRec.ArgsP.Add(Scanner.PosNumber);
  end;
end;

var
  I: Integer;
  S: String;
begin
  Vars := 0;
  result := 0;

  ArgumentListSwitch := true;

  if CheckCall then
  begin
    CallRec := TPaxCallRec.Create;
    CallRec.CallP := Scanner.PosNumber;
  end;

  _ParseExpr;
  while IsCurrText(',') do
  begin
    Call_SCANNER;
    _ParseExpr;
  end;

  if CheckCall then
  begin
    CallRec.CallN := Code.Card + 1;
    TPaxBaseScripter(Scripter).CallRecList.AddObject(CallRec.CallN, CallRec);
  end;

  ArgumentListSwitch := false;
  if Erase then
  begin
    S := Name[SubId];
    I := ArrayParamMethods.IndexOf(S);
    if I = -1 then
      ArrayArgumentList.Clear;
  end;
end;

procedure TPAXParser.GenDestroyTempObjects;
var
  I, ID: Integer;
begin
  for I := TempObjectList.Count - 1 downto 0 do
  begin
    ID := TempObjectList[I];
    Gen(OP_DESTROY_OBJECT, ID, 0, 0);
  end;
  TempObjectList.Clear;
end;

procedure TPAXParser.GenDestroyArrayArgumentList;
var
  I, ID: Integer;
begin
  for I := ArrayArgumentList.Count - 1 downto 0 do
  begin
    ID := ArrayArgumentList[I];
    Gen(OP_DESTROY_OBJECT, ID, 0, 0);
  end;
  ArrayArgumentList.Clear;
end;

procedure TPAXParser.GenDestroyLocalVars;
var
  I, ID, SubID: Integer;
begin
  SubID := LevelStack.Top;
  for I := LocalVars.Count - 1 downto 0 do
  begin
    ID := LocalVars[I];
    if SymbolTable.Level[ID] = SubID then
    begin
      Gen(OP_DESTROY_LOCAL_VAR, ID, 0, 0);
      LocalVars.Delete(I);
    end;
  end;
end;

function TPAXParser.OpResultType(T1, T2: Integer): Integer;
begin
  result := 0;
  if T1 > PAXTypes.Count then
    Exit;
  if T2 > PAXTypes.Count then
    Exit;
  result := OpResultTypes[T1, T2];
  if result = 0 then
    result := OpResultTypes[T2, T1];
end;

function TPAXParser.Parse_RegExpr(const ConstructorName: String): Integer;
var
  S: String;
  I, RegExpID, CreateID, SourceID, ExprID, ID: Integer;
begin
  S := Scanner.GetRegExpr;

  RegExpID := NewVar;
  Name[RegExpID] := 'RegExp';

  CreateID := NewVar;
  Name[CreateID] := ConstructorName;

  SourceID := NewVar;
  Name[SourceID] := 'source';

  ExprID := NewConst(S);

  result := NewVar;

  Gen(OP_EVAL_WITH, 0, 0, RegExpID);
  Gen(OP_CREATE_OBJECT, RegExpID, Integer(maAny), result);
  GenRef(result,  maAny, CreateID);
  Gen(OP_CALL, CreateID, 0, result);

  GenRef(result, MaAny, SourceID);
  Gen(OP_PUSH, ExprID, 0, 0);
  Gen(OP_PUT_PROPERTY, SourceID, 1, 0);

  Call_SCANNER;
  Match('/');

  if LA(1) in ['i', 'I', 'g', 'G', 'm', 'M'] then
  begin
    Call_SCANNER;
    for I:=1 to Length(CurrToken.Text) do
      case CurrToken.Text[I] of
        'g','G':
        begin
          ID := NewVar;
          Name[ID] := 'global';
          GenRef(result, MaAny, ID);
          Gen(OP_PUSH, NewConst('true'), 0, 0);
          Gen(OP_PUT_PROPERTY, ID, 1, 0);
        end;
        'i','I':
        begin
          ID := NewVar;
          Name[ID] := 'ignoreCase';
          GenRef(result, MaAny, ID);
          Gen(OP_PUSH, NewConst('true'), 0, 0);
          Gen(OP_PUT_PROPERTY, ID, 1, 0);
        end;
        'm','M':
        begin
          ID := NewVar;
          Name[ID] := 'multiline';
          GenRef(result, MaAny, ID);
          Gen(OP_PUSH, NewConst('true'), 0, 0);
          Gen(OP_PUT_PROPERTY, ID, 1, 0);
        end;
      end;
  end;

  Call_SCANNER;
end;

procedure TPAXParser.Parse_PrintList;
begin
  // print
  Call_SCANNER;

  repeat
    Gen(OP_PRINT, Parse_ArgumentExpression, 0, 0);
    if IsCurrText(',') then
      Call_SCANNER
    else
      Break;
  until false;
end;

procedure TPAXParser.Parse_PrintlnList;
begin
  // print
  Call_SCANNER;

  repeat
    Gen(OP_PRINT, Parse_ArgumentExpression, 0, 0);
    if IsCurrText(',') then
      Call_SCANNER
    else
      Break;
  until false;
  Gen(OP_PRINT, NewConst('\r\n'), 0, 0);
end;

function TPAXParser.BinOp(OP, Arg1, Arg2: Integer): Integer;
begin
  result := NewVar;
  Gen(OP, Arg1, Arg2, result);
end;

function TPAXParser.IsOperator(OperList: TPAXIds; var OP: Integer): Boolean;
var
  I: Integer;
begin
  if CurrToken.TokenClass <> tcSpecial then
  begin
    result := false;
    Exit;
  end;

  I := OperList.IndexOf(CurrToken.ID);
  if I >= 0 then
  begin
    result := true;
    OP := OperList[I];
    Call_SCANNER;
  end
  else
    result := false;
end;

function TPAXParser.Parse_StringLiteral: Integer;
var
  K, ID, Count, FormatID, ArrayID, SubID: Integer;
  S: String;
begin
  Count := Scanner.VarNameList.Count;
  if Count = 0 then
    result := CurrToken.ID
  else
  begin
    FormatID := LookupID('Format');
    ArrayID := NewVar;
    Result := NewVar;

    Gen(OP_PUSH, NewConst(Count - 1), 0, 0);
    Gen(OP_CREATE_ARRAY, ArrayID, 1, 0);

    for K:=0 to Count - 1 do
    begin
      Gen(OP_PUSH, NewConst(K), 0, 0);

      S := Scanner.VarNameList[K];
      ID := NewVar;
      Name[ID] := S;
      Gen(OP_EVAL_WITH, 0, 0, ID);
      Gen(OP_PUSH, ID, 0, 0);

      Gen(OP_PUT_PROPERTY, ArrayID, 2, 0);
    end;

    Gen(OP_PUSH, CurrToken.ID, 0, 0);
    Gen(OP_PUSH, ArrayID, 0, 0);
    Gen(OP_CALL, FormatID, 2, Result);
    Gen(OP_DESTROY_OBJECT, ArrayID, 0, 0);
  end;

  Scanner.VarNameList.Clear;

  Call_SCANNER;
  if IsCurrText('with') then
  begin
    Call_SCANNER;
    Gen(OP_PUSH, result, 0, 0);
    Gen(OP_PUSH, Parse_ArrayLiteral, 0, 0);
    SubID := LookUpID('Format');
    result := NewVar;
    Gen(OP_CALL, SubID, 2, result);
  end;
end;

procedure TPAXParser.GenHtml;
var
  K, ID, Count, FormatID, ArrayID, ResultID, N: Integer;
  S: String;
begin
  CurrToken.ID := SymbolTable.CodeStringConst(CurrToken.Text);

  N := Code.Card + 1;

  Count := Scanner.VarNameList.Count;
  if Count = 0 then
    Gen(OP_PRINT_HTML, CurrToken.ID, 0, N)
  else
  begin
    FormatID := LookupID('Format');
    ArrayID := NewVar;
    ResultID := NewVar;

    Gen(OP_PUSH, NewConst(Count - 1), 0, 0);
    Gen(OP_CREATE_ARRAY, ArrayID, 1, 0);

    for K:=0 to Count - 1 do
    begin
      Gen(OP_PUSH, NewConst(K), 0, 0);

      S := Scanner.VarNameList[K];
      ID := NewVar;
      Name[ID] := S;
      Gen(OP_EVAL_WITH, 0, 0, ID);
      Gen(OP_PUSH, ID, 0, 0);

      Gen(OP_PUT_PROPERTY, ArrayID, 2, 0);
    end;

    Gen(OP_PUSH, CurrToken.ID, 0, 0);
    Gen(OP_PUSH, ArrayID, 0, 0);
    Gen(OP_CALL, FormatID, 2, ResultID);
    Gen(OP_DESTROY_OBJECT, ArrayID, 0, 0);
    Gen(OP_PRINT_HTML, ResultID, 0, N);
  end;

  Scanner.VarNameList.Clear;
end;

function TPAXParser.Parse_ArrayLiteral: Integer;
var
  L, K, ArgID: Integer;

procedure Parse_Element;
var
  S: String;
  c, c1, c2: Char;
  I, I1, I2: Integer;
begin
  if IsNextText('..') then
  begin
    S := CurrToken.Text;
    if CurrToken.TokenClass = tcIntegerConst then
    begin
      I1 := StrToInt(S);
      Call_SCANNER;
      Call_SCANNER;
      S := CurrToken.Text;
      I2 := StrToInt(S);
      Call_SCANNER;
      for I := I1 to I2 do
      begin
        ArgID := NewConst(I);

        Inc(K);
        Gen(OP_PUSH, NewConst(K), 0, 0);
        Gen(OP_PUSH, ArgID, 0, 0);
        Gen(OP_PUT_PROPERTY, result, 2, 0);
      end;
    end
    else if CurrToken.TokenClass = tcStringConst then
    begin
      c1 := S[1];
      Call_SCANNER;
      Call_SCANNER;
      S := CurrToken.Text;
      Call_SCANNER;
      c2 := S[1];
      for c := c1 to c2 do
      begin
        S := c;
        ArgID := NewConst(S);

        Inc(K);
        Gen(OP_PUSH, NewConst(K), 0, 0);
        Gen(OP_PUSH, ArgID, 0, 0);
        Gen(OP_PUT_PROPERTY, result, 2, 0);
      end;
    end
    else
      raise TPaxScriptFailure.Create(errConstantExpected);
  end
  else
  begin
    Inc(K);
    Gen(OP_PUSH, NewConst(K), 0, 0);
    ArgID := Parse_ArgumentExpression;
    Gen(OP_PUSH, ArgID, 0, 0);
    Gen(OP_PUT_PROPERTY, result, 2, 0);
  end;
end;

begin
  Match('[');
  Call_SCANNER;

  K := -1;
  result := NewVar;

  if ArgumentListSwitch then
    ArrayArgumentList.Add(result);

//  TempObjectList.Add(result);
  Gen(OP_PUSH, 0, 0, 0);
  L := LastCodeLine;

  Gen(OP_CREATE_ARRAY, result, 1, 0);

  if not IsCurrText(']') then
  begin
    Parse_Element;
    while IsCurrText(',') do
    begin
      Call_SCANNER;
      Parse_Element;
    end;
  end
  else
    K := -1;

  with Code do
    Prog[L].Arg1 := NewConst(K);

  Match(']');
  Call_SCANNER;
end;

procedure TPAXParser.Parse_ObjectInitializer(ObjectID: Integer);
var
  FieldID, K: Integer;
begin
  K := -1;
  // match "("
  Call_SCANNER;
  if IsCurrText(')') then
    Call_SCANNER
  else
  repeat
    FieldID := NewVar;
    Inc(K);
    Gen(OP_GET_FIELD, ObjectID, K, FieldID);
    if IsCurrText('(') then
    begin
      Parse_ObjectInitializer(FieldID);
    end
    else
    begin
      Gen(OP_ASSIGN, FieldID, Parse_ArgumentExpression(), FieldID);
    end;
    if IsCurrText(',') then
      Call_SCANNER
    else
      break;
  until false;
  Match(')');
  Call_SCANNER;
end;

function TPAXParser.Parse_CallConv: Integer;
var
  S: String;
  Temp: Integer;
begin
  S := NextToken.Text;

  result := -1;
  if StrEql(S, 'register') then
    result := _ccRegister
  else if StrEql(S, 'stdcall') then
    result := _ccStdCall
  else if StrEql(S, 'safecall') then
    result := _ccSafeCall
  else if StrEql(S, 'cdecl') then
    result := _ccCDecl
  else if StrEql(S, 'pascal') then
    result := _ccPascal;

  if result >= 0 then
  begin
    Temp := SymbolTable.Card;
    Call_SCANNER; // call conv
    Call_SCANNER;
    SymbolTable.Card := Temp;
  end;
end;

procedure TPAXParser.Parse_ReducedAssignment(LeftID: Integer);
var
  Card1, Card2, NP, RightID, TempVar, I: Integer;
  SaveProg: TPAXCodeRec;
  IsCall: Boolean;
begin
  Card1 := Code.Card;
  RightID := Parse_EvalExpression;
  Card2 := Code.Card;

  IsCall := IsCallOperator;

  if Code.Prog[Card2].OP = OP_SEPARATOR then
  with Code do
  begin
    SaveProg := Prog[Card];

    Dec(Card);
    Dec(Card2);
  end
  else
    SaveProg.Op := OP_NOP;

  NP := Code.Prog[Card2].Arg2;

  TempVar := 0;
  if IsCall then
  begin
    TempVar := NewVar;
    Gen(OP_ASSIGN, TempVar, Code.Prog[Card2].Res, TempVar);
  end;

  with Code do
  if IsCall then
  for I:=Card1 to Card2 - 1 do
  begin
    Inc(Card);

    if Prog[I].Op = OP_SEPARATOR then
    begin
      SaveProg := Prog[I];

      Prog[Card].Op := OP_NOP;
      Prog[Card].Arg1 := 0;
      Prog[Card].Arg2 := 0;
      Prog[Card].Res := 0;
    end
    else
    begin
      Prog[Card].Op := Prog[I].Op;
      Prog[Card].Arg1 := Prog[I].Arg1;
      Prog[Card].Arg2 := Prog[I].Arg2;
      Prog[Card].Res := Prog[I].Res;
    end;
  end;

  if IsCall then
  begin
    Gen(OP_PUSH, SymbolTable.IDundefined, 0, 0);
    Gen(OP_PUT_PROPERTY, LeftID, NP + 1, 0);
    Gen(OP_DESTROY_OBJECT, LeftID, 0, 0);
    Gen(OP_ASSIGN, LeftID, TempVar, LeftID);
//    Gen(OP_ASSIGN, TempVar, SymbolTable.IDundefined, TempVar);
  end
  else
  begin
    Gen(OP_DESTROY_OBJECT, LeftID, 0, 0);
    Gen(OP_ASSIGN, LeftID, RightID, LeftID);
  end;

  if SaveProg.Op <> OP_NOP then
  with Code do
  begin
    Inc(Card);
    Prog[Card].Op := SaveProg.Op;
    Prog[Card].Arg1 := SaveProg.Arg1;
    Prog[Card].Arg2 := SaveProg.Arg2;
    Prog[Card].Res := SaveProg.Res;
  end;
end;

procedure TPaxParser.MoveUpSourceLine;
var
  I: Integer;
begin
  with Code do
  begin
    I := Card;
    while Prog[I].Op <> OP_SEPARATOR do
      Dec(I);

    Inc(Card);
    Prog[Card] := Prog[I];
    Prog[I].Op := OP_NOP;
  end;
end;

function TPaxParser.Parse_ShortEvalAND(ID: Integer;
                                       Method0: TIntegerMethodNoParam;
                                       Method1: TIntegerMethodOneParam): Integer;
var
  LF: Integer;
begin
  if Assigned(Method0) and Assigned (Method1) then
    raise Exception.Create(errInternalError);
  if (not Assigned(Method0)) and (not Assigned (Method1)) then
    raise Exception.Create(errInternalError);

  LF := NewLabel;
  result := NewVar;
  Gen(OP_ASSIGN, result, ID, result);
  Gen(OP_GO_FALSE, LF, result, 0);
  if Assigned(Method0) then
    Gen(OP_ASSIGN, result, Method0(), result)
  else
    Gen(OP_ASSIGN, result, Method1(0), result);
  SetLabelHere(LF);
end;


function TPaxParser.Parse_ShortEvalOR(ID: Integer;
                                      Method0: TIntegerMethodNoParam;
                                      Method1: TIntegerMethodOneParam): Integer;
var
  LT: Integer;
begin
  if Assigned(Method0) and Assigned (Method1) then
    raise Exception.Create(errInternalError);
  if (not Assigned(Method0)) and (not Assigned (Method1)) then
    raise Exception.Create(errInternalError);

  LT := NewLabel;
  result := NewVar;
  Gen(OP_ASSIGN, result, ID, result);
  Gen(OP_GO_TRUE, LT, result, 0);
  if Assigned(Method0) then
    Gen(OP_ASSIGN, result, Method0(), result)
  else
    Gen(OP_ASSIGN, result, Method1(0), result);
  SetLabelHere(LT);
end;

function TPaxParser.IsBaseType(const S: String): Boolean;
var
  I: Integer;
begin
  result := false;
  for I:=0 to PaxTypes.Count - 1 do
    if StrEql(PaxTypes[I], S) then
    begin
      result := true;
      Exit;
    end;
end;

function TPaxParser.UndefinedID: Integer;
begin
  result := SymbolTable.IDundefined;
end;

procedure TPaxParser.TestDupLocalVars(NewVarID: Integer);
var
  S: String;
  I, tempID, L, tempL: Integer;
  b: Boolean;
begin
  S := Name[NewVarID];
  L := SymbolTable.Level[NewVarID];
  for I:=0 to LocalVars.Count - 1 do
  begin
    tempID := LocalVars[I];
    if UpCase then
      b := StrEql(Name[tempID], S)
    else
      b := Name[tempID] = S;
    if b then
    begin
      TempL := SymbolTable.Level[tempID];
      if tempL = L then
        raise TPAXScriptFailure.Create(Format(errIdentifierIsRedeclared, [Name[tempID]]));
    end;
  end;
end;

end.
