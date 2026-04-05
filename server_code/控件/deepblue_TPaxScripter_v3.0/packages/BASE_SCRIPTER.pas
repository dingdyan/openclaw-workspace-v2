////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_SCRIPTER.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////


{$I PaxScript.def}
unit BASE_SCRIPTER;

interface

uses
{$IFDEF WIN32}
  Windows,
{$ENDIF}

{$IFDEF VARIANTS}
  Variants,
{$ENDIF}
  SysUtils, Classes,

  {$ifndef FP}
  SyncObjs,
  {$endif}

  BASE_CONSTS,
  BASE_SYNC,
  BASE_SYS, BASE_SCANNER, BASE_PARSER, BASE_SYMBOL, BASE_CODE, BASE_CLASS,
  BASE_EXTERN, BASE_EVENT, BASE_REGEXP, BASE_DLL, BASE_DFM;

type
  TPAXBaseScripter = class;

  TPAXModule = class(TStringList)
  public
    Name: String;
    FileName: String;
    LanguageName: String;
    Namespaces: TPAXIds;
    S1, P1, C1, S2, P2, C2: Integer;
    IsSource: Boolean;
    BuffStream: TStream;
    Scripter: TPaxBaseScripter;
    constructor Create(Scripter: TPaxBaseScripter);
    destructor Destroy; override;
    procedure AddNamespace(ID: Integer);
    function GetTextPos(LineNumber, Position: Integer): Integer;
    procedure _SaveToStream(S: TStream);
    procedure _LoadFromStream(S: TStream);
  end;

  TPAXModules = class(TStringList)
  private
    Scripter: TPaxBaseScripter;
    function GetModule(Index: Integer): TPAXModule;
    function GetSourceCode: String;
  public
    constructor Create(Scripter: TPaxBaseScripter);
    procedure Clear; reintroduce;
    function IndexOf(const Name: String): Integer; override;
    function Add(const Name, LanguageName: String): Integer; reintroduce;
    procedure Delete(Index: Integer); reintroduce;
    procedure _SaveToStream(S: TStream);
    procedure _LoadFromStream(S: TStream);
    destructor Destroy; override;
    procedure Dump(const FileName: String);
    property Items[Index: Integer]: TPAXModule read GetModule;
    property SourceCode: String read GetSourceCode;
  end;

  TScripterEvent = procedure(Sender: TObject) of object;
  TCompilerProgressEvent = procedure(Sender: TObject; ModuleNumber: Integer) of object;
  TPrintEvent = procedure(Sender: TObject; const S: String) of object;
  TReadEvent = procedure(Sender: TObject; var S: String) of object;

  TVarEvent = procedure (Sender: TObject; ID: Integer) of object;

  TVarEventEx = procedure (Sender: TObject; ID: Integer; var Mode: Integer) of object;


  TCodeEvent = procedure(Sender: TObject;
                         N: Integer;
                         var Handled: Boolean) of object;

  TUsedModuleEvent = procedure(Sender: TObject; const UsedModuleName, FileName: String;
                               var SourceCode: String) of object;

  TLoadSourceCodeEvent = procedure(Sender: TObject; const UsedModuleName, FileName: String;
                                   var SourceCode: String) of object;

  TIncludeEvent = procedure(Sender: TObject; const IncludedFileName: String;
                            var SourceCode: String) of object;

  TStreamEvent = procedure(Sender: TObject; Stream: TStream;
                           const ModuleName: String) of object;

  TOnDefineEvent = procedure(Sender: TObject; const DirectiveName: String) of object;

  TOnChangeStateEvent = procedure(Sender: TObject; OldState, NewState: TPaxScripterState) of object;

  TOnInstanceEvent = procedure(Sender: TObject; Instance: TObject) of object;

  TLoadDllEvent = procedure(Sender: TObject; const DllName, ProcName: String; var Address: Pointer) of object;

  TVarArray = array of Variant;

  TVirtualObjectMethodCallEvent = function(Sender: TObject; const ObjectName,
     PropName: String; const Params: TVarArray): Variant of object;

  TVirtualObjectPutPropertyEvent = procedure(Sender: TObject; const ObjectName,
     PropName: String; const Params: TVarArray; const Value: Variant) of object;

  TPAXBaseScripter = class
  private
    fOnHalt: TScripterEvent;
    fOnShowError: TScripterEvent;
    fOnCompilerProgress: TCompilerProgressEvent;
    fOnRunning: TCodeEvent;
    fOnPrint: TPrintEvent;
    fOnRead: TReadEvent;
{$IFDEF UNDECLARED_EX}
    fOnUndeclaredIdentifier: TVarEventEx;
{$ELSE}
    fOnUndeclaredIdentifier: TVarEvent;
{$ENDIF}
    fOnChangedVariable: TVarEvent;
    fOnReadExtraData, fOnWriteExtraData: TStreamEvent;
    fOnUsedModule: TUsedModuleEvent;
    fOnInclude: TIncludeEvent;
    fOnLoadSourceCode: TLoadSourceCodeEvent;
    fOnDefine: TOnDefineEvent;
    fOnChangeState: TOnChangeStateEvent;
    fOnDelphiInstanceCreate: TOnInstanceEvent;
    fOnDelphiInstanceDestroy: TOnInstanceEvent;
    fOnLoadDll: TLoadDllEvent;
    fOnVirtualObjectMethodCall: TVirtualObjectMethodCallEvent;
    fOnVirtualObjectPutProperty: TVirtualObjectPutPropertyEvent;

    SignDefs: Boolean;

    fOverrideHandlerMode: Integer;
{$IFDEF ONRUNNING}
    // Event to replace OnRunning event.  Event will be executed when
    // fOnRunningUpdateActive is enabled and the event is assigned.
    fOnRunningUpdate: TScripterEvent;

    // Flag used to fire the OnRunningUpdate event.  This allows scripter
    // to run quickly when flag is disabled (False).  Flag can be
    // enabled/disabled during script run-time.
    fOnRunningUpdateActive: Boolean;

    // Event fires when executing a function or property and UserData is non-zero.
    // Used for multi-thread applications.
    fOnRunningSync: TScripterEvent;
{$ENDIF}
    procedure SetState(Value: TPAXScripterState);
    procedure CopyLevelStack(Parser: TPAXParser);
  public
    EvalCount: Integer;
    Owner: TObject;
    Modules: TPAXModules;
    SymbolTable: TPAXSymbolTable;
    Code: TPAXCode;
    ClassList: TPAXClassList;
    EventHandlerList: TPAXEventHandlerList;
    MethodBody: TPAXMethodBody;
    VariantStack: TPaxVariantStack;
    NegVarList: TPaxVarList;

    ScriptObjectList: TPAXScriptObjectList;
    ActiveXObjectList: TPaxObjectList;
    CompileTimeHeap: TPAXCompileTimeHeap;

    fState: TPAXScripterState;
    Error: Variant;

    ErrorInstance: TPAXError;
    RegisteredFieldList: TPAXFieldList;
    ParserList: TPAXParserList;

    ExtraCodeList: TPAXCodeList;

    fTotalLineCount: Integer;

    ParamList: TPAXParamList;

    ArrayClassRec: TPAXClassRec;

    LastResultID: Integer;
    fLastResult: Variant;

    DoNotDestroyList: TPAXIds;
    TempObjectList: TPAXAssocList;

    ForbiddenPublishedProperties: TList;
    ForbiddenPublishedPropertiesEx: TStringList;

    PrototypeNameIndex: Integer;
    ConstructorNameIndex: Integer;

    fStackSize: Integer;
    fLongStrLiterals: Boolean;

    CurrModule: Integer;

    OwnerEventHandlerMethod: TMethod;

    AllowedEvents: Boolean;
    Visited: TList;
    ExtraModuleList: TStringList;
    DefList: TStringList;

    RunList: TPaxStack;
    fSearchPathes: TStringList;
    DefaultParameterList: TDefaultParameterList;

    UnknownTypes: TPaxIDRecList;
    CallRecList: TPaxCallRecList;
    TypeAliasList: TPaxAssociativeList;
    NameList: TPAXNameList;
    LocalDefinitions: TPAXDefinitionList;

    TempVariant: Variant;
    CancelMessage: String;

    _ObjCount: Int64;
    LastDefinitionListCount: Integer;

    IgnoreBreakpoints: Boolean;

    constructor Create(Owner: TObject);
    destructor Destroy; override;
    procedure AddDefs;
    procedure AddLocalDefs;
    function AddModule(const ModuleName, LanguageName: String): Integer;
    procedure AddCode(const ModuleName, Code: String);
    procedure AddCodeFromFile(const ModuleName, FileName: String);
    function CompileModule(const Name: String; Parser: TPAXParser;
                           SyntaxCheckOnly: Boolean = false): Boolean;
    procedure CompileExtraCode;
    procedure Link(reallocate: boolean);
    procedure Run(RunMode: Integer = _rmRun; DestLine: Integer = 0);
    procedure ResetCompileStage;
    procedure ResetScripterEx;
    procedure InitRunStage;
    procedure ResetRunStage;
    procedure DiscardError;
    function IsError: boolean;
    function AddBreakpoint(const ModuleName: String; SourceLineNumber: Integer;
                           const Condition: String; PassCount: Integer): Boolean;
    function RemoveBreakpoint(const ModuleName: String; SourceLineNumber: Integer;
                           const Condition: String; PassCount: Integer): Boolean;
    procedure RemoveAllBreakpoints;
    function SourceLineToPCodeLine(const ModuleName: String; SourceLineNumber: Integer): Integer;
    procedure CreateErrorObject(const Message: String; PosNumber: Integer);
    procedure ShowError;
    function CallMethod(SubID: Integer;
                        const This: Variant;
                        const P: array of const;
                        IsEventHandler: Boolean = false): Variant;
    function CallMethodEx(SubID: Integer;
                          const This: Variant;
                          const P: array of const;
                          const StrTypes: array of String;
                          IsEventHandler: Boolean = false): Variant;
    function AssignedObject(SO: TPAXScriptObject): Boolean;
    procedure DisconnectObjects;
    procedure Dump;
    function GetProperty(const ScriptObject: Variant; PropertyName: String): Variant;
    function Eval(const SourceCode: String; Parser: TPAXParser): Variant;
    procedure EvalStatementList(const SourceCode: String; Parser: TPAXParser);
    function GetName(NameIndex: Integer): String;
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream);

    procedure SaveCompiledModuleToStream(M: TPaxModule; S: TStream);
    procedure LoadCompiledModuleFromStream(M: TPaxModule; S: TStream);

    property State: TPAXScripterState read fState write SetState;
    property TotalLineCount: Integer read fTotalLineCount write fTotalLineCount;
    procedure AddExtraModule(const ModuleName, SourceCode: String;
                                          SyntaxCheckOnly: Boolean; const PaxLanguage: String);
    procedure RunEx(ExtendedRun: Boolean);
    function FindFullName(const FileName: String): String;
    function IsCompiledScript(const FileName: String): Boolean;
    procedure CreateRunList;
    procedure CheckForUndeclared;
    procedure CheckCalls;
    function GetTypeID(ID: Integer): Integer;

    function MatchAssignment(T1, T2: Integer): Boolean;
    function MatchAssignmentStrict(T1, T2: Integer): Boolean;
    function OpResultType(T1, T2: Integer): Integer;
    function MatchTypes(T1, T2: Integer): Integer;
    function strIncompatibleTypes(T1, T2: Integer): String;

    function ConvertDelphiForm1(const DfmFileName, UnitFileName, PaxLanguage: String): String;
    function ConvertDelphiForm2(const DfmFileName: String; UsedUnits: TStringList; const PaxLanguage: String): String;
    procedure AddDelphiForm(const DfmFileName, UnitFileName, PaxLanguage: String);
    function HasForbiddenPublishedProperty(C: TClass; const PropName: String): Boolean;

    property OverrideHandlerMode: Integer read fOverrideHandlerMode write fOverrideHandlerMode;

    property OnHalt: TScripterEvent read fOnHalt write fOnHalt;
    property OnShowError: TScripterEvent read fOnShowError write fOnShowError;
    property OnCompilerProgress: TCompilerProgressEvent read fOnCompilerProgress write fOnCompilerProgress;
    property OnPrint: TPrintEvent read fOnPrint write fOnPrint;
    property OnRead: TReadEvent read fOnRead write fOnRead;
{$IFDEF UNDECLARED_EX}
    property OnUndeclaredIdentifier: TVarEventEx read fOnUndeclaredIdentifier write fOnUndeclaredIdentifier;
{$ELSE}
    property OnUndeclaredIdentifier: TVarEvent read fOnUndeclaredIdentifier write fOnUndeclaredIdentifier;
{$ENDIF}
    property OnChangedVariable: TVarEvent
               read fOnChangedVariable write fOnChangedVariable;
    property OnRunning: TCodeEvent read fOnRunning write fOnRunning;
{$IFDEF ONRUNNING}
    // See variable definitions above for details.
    property OnRunningUpdate: TScripterEvent read fOnRunningUpdate write fOnRunningUpdate;
    property OnRunningUpdateActive: Boolean read fOnRunningUpdateActive write fOnRunningUpdateActive;
    property OnRunningSync: TScripterEvent read fOnRunningSync write fOnRunningSync;
{$ENDIF}
    property OnReadExtraData: TStreamEvent read fOnReadExtraData write fOnReadExtraData;
    property OnWriteExtraData: TStreamEvent read fOnWriteExtraData write fOnWriteExtraData;
    property OnUsedModule: TUsedModuleEvent read fOnUsedModule write fOnUsedModule;
    property OnInclude: TIncludeEvent read fOnInclude write fOnInclude;
    property OnLoadSourceCode: TLoadSourceCodeEvent read fOnLoadSourceCode write fOnLoadSourceCode;
    property OnDefine: TOnDefineEvent read fOnDefine write fOnDefine;
    property OnChangeState: TOnChangeStateEvent read fOnChangeState write fOnChangeState;
    property OnDelphiInstanceCreate: TOnInstanceEvent read fOnDelphiInstanceCreate write fOnDelphiInstanceCreate;
    property OnDelphiInstanceDestroy: TOnInstanceEvent read fOnDelphiInstanceDestroy write fOnDelphiInstanceDestroy;
    property OnLoadDll: TLoadDllEvent read fOnLoadDll write fOnLoadDll;
    property OnVirtualObjectMethodCall: TVirtualObjectMethodCallEvent read fOnVirtualObjectMethodCall write fOnVirtualObjectMethodCall;
    property OnVirtualObjectPutProperty: TVirtualObjectPutPropertyEvent read fOnVirtualObjectPutProperty write fOnVirtualObjectPutProperty;
  end;

var
  __Self: TObject;
  __Scripter: TObject;
  ScripterList: TList;
  DllList: TPaxDllList;

  CurrScripter: TPAXBaseScripter;

function _Eval(const SourceCode: String;
              Scripter: TPAXBaseScripter;
              Parser: TPAXParser): Variant;

implementation

uses
  PASCAL_PARSER, PAX_JAVASCRIPT;

constructor TPAXModule.Create(Scripter: TPaxBaseScripter);
begin
  inherited Create;
  Self.Scripter := Scripter;
  Namespaces := TPAXIds.Create(false);
  IsSource := true;
  BuffStream := TMemoryStream.Create;
end;

destructor TPAXModule.Destroy;
begin
  Namespaces.Free;
  BuffStream.Free;
  inherited;
end;

procedure TPAXModule.AddNamespace(ID: Integer);
begin
  if Namespaces.IndexOf(ID) = -1 then
    Namespaces.Add(ID);
end;

function TPAXModule.GetTextPos(LineNumber, Position: Integer): Integer;
var
  S: String;
  P, LineCount: Integer;
begin
  result := 0;
  P := 1;
  LineCount := 1;

  S := Text + #255;

  while S[P] <> #255 do
  begin
    if S[P] in [#10,#13] then
    begin
      Inc(LineCount);
      if S[P] = #13 then
        Inc(P);
    end;

    if LineCount = LineNumber then
    begin
      while S[P] in [#10,#13] do
        Inc(P);

      result := P + Position;
      Exit;
    end;

    Inc(P);
  end;
end;

procedure TPAXModule._SaveToStream(S: TStream);
begin
  SaveString(Name, S);
  SaveString(FileName, S);
  SaveString(LanguageName, S);
  SaveInteger(Count, S);
  Namespaces.SaveToStream(S);

  SaveInteger(S1, S);
  SaveInteger(S2, S);

  SaveInteger(P1, S);
  SaveInteger(P2, S);

  SaveInteger(C1, S);
  SaveInteger(C2, S);
end;

procedure TPAXModule._LoadFromStream(S: TStream);
var
  I, K: Integer;
  St: String;
begin
  Name := LoadString(S);
  FileName := LoadString(S);
  LanguageName := LoadString(S);
  K := LoadInteger(S);
  Namespaces.LoadFromStream(S);

  S1 := LoadInteger(S);
  S2 := LoadInteger(S);

  P1 := LoadInteger(S);
  P2 := LoadInteger(S);

  C1 := LoadInteger(S);
  C2 := LoadInteger(S);

  if Assigned(Scripter.fOnLoadSourceCode) then
  begin
    Scripter.fOnLoadSourceCode(Scripter.Owner, Name, FileName, St);
    Text := St;
  end
  else
  begin
    if FileExists(FileName) then
      LoadFromFile(FileName)
    else
      for I:=0 to K - 1 do
        Add('##' + IntToStr(I) + '##');
  end;

  IsSource := false;
end;

constructor TPAXModules.Create(Scripter: TPaxBaseScripter);
begin
  inherited Create;
  Self.Scripter := Scripter;
end;

destructor TPAXModules.Destroy;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    Items[I].Free;
  inherited;
end;

procedure TPAXModules._SaveToStream(S: TStream);
var
  I: Integer;
begin
  SaveInteger(Count, S);
  for I:=0 to Count - 1 do
    Items[I]._SaveToStream(S);
end;

procedure TPAXModules._LoadFromStream(S: TStream);
var
  I, K: Integer;
  M: TPAXModule;
begin
  Clear;
  K := LoadInteger(S);
  for I:=1 to K do
  begin
    M := TPAXModule.Create(Scripter);
    M._LoadFromStream(S);
    AddObject(M.Name, M);
  end;
end;

function TPAXModules.GetModule(Index: Integer): TPAXModule;
begin
  if (Index < 0) or (Index >= Count) then
    result := nil
  else
    result := TPAXModule(Objects[Index]);
end;

procedure TPAXModules.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= Count) then
    Exit;
  Items[Index].Free;
  inherited;
end;

procedure TPAXModules.Clear;
var
  I: Integer;
begin
  for I:= Count - 1 downto 0 do
    Delete(I);
  inherited;
end;

function TPAXModules.GetSourceCode: String;
var
  I: Integer;
begin
  result := '';
  for I:=0 to Count - 1 do
    result := result + GetModule(I).Text;
end;

function TPAXModules.IndexOf(const Name: String): Integer;
var
  Module: TPAXModule;
  I: Integer;
begin
  result := -1;
  for I:=0 to Count - 1 do
  begin
    Module := Items[I];
    if StrEql(Name, Module.Name) then
    begin
      result := I;
      Exit;
    end;
  end;
end;

function TPAXModules.Add(const Name, LanguageName: String): Integer;
var
  Module: TPAXModule;
begin
  result := IndexOf(Name);
  if result >= 0 then
    Exit;
  Module := TPAXModule.Create(Scripter);
  Module.Name := Name;
  Module.FileName := '';
  Module.LanguageName := LanguageName;
  result := AddObject(Name, Module);
end;

procedure TPAXModules.Dump(const FileName: String);
var
  T: TextFile;
  I: Integer;
  M: TPAXModule;
begin
  if not _IsDump then
    Exit;
  AssignFile(T, FileName);
  Rewrite(T);
  try
    for I:=0 to Count - 1 do
    begin
      M := GetModule(I);
      writeln(T, M.Name);
      writeln(T, 'S1 =', M.S1);
      writeln(T, 'S2 =', M.S2);
      writeln(T, 'P1 =', M.P1);
      writeln(T, 'P2 =', M.P2);
      writeln(T, 'C1 =', M.C1);
      writeln(T, 'C2 =', M.C2);
      writeln(T, '**************************************');
      writeln(T, M.Text);
      writeln(T, '**************************************');
    end;
  finally
    CloseFile(T);
  end;
end;

constructor TPAXBaseScripter.Create(Owner: TObject);
begin
  CurrScripter := Self;

  _ObjCount := 0;

  IgnoreBreakpoints := false;
  try
    _BeginWrite;
    ScripterList.Add(Self);
  finally
    _EndWrite;
  end;
  NameList := TPAXNameList.Create;
  LocalDefinitions := TPaxDefinitionList.Create(false);

  Visited := TList.Create;
  ExtraModuleList := TStringList.Create;
  DefList := TStringList.Create;
  RunList := TPaxStack.Create;
  fSearchPathes := TStringList.Create;
  DefaultParameterList := TDefaultParameterList.Create;
  UnknownTypes := TPaxIDRecList.Create;
  CallRecList := TPaxCallRecList.Create;
  TypeAliasList := TPaxAssociativeList.Create(false);

  CancelMessage := '';

  AllowedEvents := true;

  ArrayClassRec := nil;

  LastResultID := 0;

  Self.Owner := Owner;

  Modules := TPAXModules.Create(Self);

  VariantStack := TPAXVariantStack.Create;
  NegVarList := TPAXVarList.Create;

  ParamList := TPAXParamList.Create;

  PrototypeNameIndex := NameList.Add('prototype');
  ConstructorNameIndex := NameList.Add('constructor');

  fStackSize := DefaultStackSize;

  SymbolTable := TPAXSymbolTable.Create(Self);

  ClassList := TPAXClassList.Create(Self);
  Code := TPAXCode.Create(Self);
  ClassList.AddClass(SymbolTable.RootNamespaceID, RootNamespaceName, '', '', [modSTATIC], ckClass, true);

  SignDefs := false;
  fLongStrLiterals := true;

  MethodBody := TPAXMethodBody.Create(Self);
  EventHandlerList := TPAXEventHandlerList.Create;
  ScriptObjectList := TPAXScriptObjectList.Create(Self);
  ActiveXObjectList:= TPaxObjectList.Create;

  CompileTimeHeap := TPAXCompileTimeHeap.Create;

  ErrorInstance := TPAXError.Create;

  LocalDefinitions.AddObject('ErrorObject', ErrorInstance, nil, Self);

  RegisteredFieldList := TPAXFieldList.Create;
  ParserList := TPaxParserList.Create;

  DiscardError;

  ExtraCodeList := TPAXCodeList.Create;
  DoNotDestroyList := TPAXIds.Create(false);
  TempObjectList := TPAXAssocList.Create;
  ForbiddenPublishedProperties := TList.Create;
  ForbiddenPublishedPropertiesEx := TStringList.Create;

  EvalCount := 0;

  fTotalLineCount := 0;

  State := _ssInit;

end;

destructor TPAXBaseScripter.Destroy;
var
  I: Integer;
begin
  _BeginWrite;
  try
    I := ScripterList.IndexOf(Self);
    if I <> -1 then
      ScripterList.Delete(I);
  finally
    _EndWrite;
  end;

  ScriptObjectList.Free;
  CompileTimeHeap.Free;
  ActiveXObjectList.Free;

  SymbolTable.Free;
  Code.Free;
  VariantStack.Free;
  NegVarList.Free;
  ClassList.Free;
  MethodBody.Free;
  EventHandlerList.Free;

  RegisteredFieldList.Free;
  ParserList.Free;

  ExtraCodeList.Free;
  DoNotDestroyList.Free;
  TempObjectList.Free;
  ForbiddenPublishedProperties.Free;
  ForbiddenPublishedPropertiesEx.Free;

  Modules.Free;

  ParamList.Free;
  Visited.Free;
  ExtraModuleList.Free;
  DefList.Free;
  RunList.Free;
  fSearchPathes.Free;
  DefaultParameterList.Free;
  UnknownTypes.Free;
  CallRecList.Free;
  TypeAliasList.Free;

  NameList.Free;
  LocalDefinitions.Free;

  ErrorInstance.Free;
  
  inherited;
end;

procedure TPAXBaseScripter.SetState(Value: TPAXScripterState);
begin
  if Assigned(OnChangeState) then
    if fState <> Value then
      OnChangeState(Owner, fState, Value);

  fState := Value;
  case fState of
    _ssReadyToCompile:
    begin
      SymbolTable.Card := FirstSymbolCard;
      SymbolTable.MemBoundVar := SymbolTable.CreateMemBoundVar;
    end;
  end;
end;

procedure TPAXBaseScripter.ResetCompileStage;
begin
  CancelMessage := '';

  EventHandlerList.ClearHandlers;

  ScriptObjectList.ResetCompileStage;
  CompileTimeHeap.ResetCompileStage;
  ActiveXObjectList.Clear;

  SymbolTable.ResetCompileStage;
  ClassList.ResetCompileStage;
  VariantStack.Clear;
  Code.ResetCompileStage;
  State := _ssReadyToCompile;

  ExtraCodeList.Clear;
  DoNotDestroyList.Clear;
  TempObjectList.Clear;
  ExtraModuleList.Clear;

  LastResultID := 0;

  AllowedEvents := true;

  DefList.Clear;
  DefaultParameterList.Clear;
  UnknownTypes.Clear;
  CallRecList.Clear;
  TypeAliasList.Clear;

  ScriptObjectList.ResetRunStage;

  Dump();
end;


procedure TPAXBaseScripter.ResetScripterEx;
begin
  CancelMessage := '';

  EventHandlerList.ClearHandlers;

  ScriptObjectList.ResetCompileStage(true);
  CompileTimeHeap.ResetCompileStage;
  ActiveXObjectList.Clear;

  SymbolTable.ResetCompileStage;
  ClassList.ResetCompileStage;
  VariantStack.Clear;
  Code.ResetCompileStage;
  State := _ssReadyToCompile;

  ExtraCodeList.Clear;
  DoNotDestroyList.Clear;
  TempObjectList.Clear;
  ExtraModuleList.Clear;

  LastResultID := 0;

  AllowedEvents := true;

  DefList.Clear;
  DefaultParameterList.Clear;
  UnknownTypes.Clear;
  CallRecList.Clear;
  TypeAliasList.Clear;

  ScriptObjectList.ResetRunStage(true);

  Dump();
end;


procedure TPAXBaseScripter.InitRunStage;
begin
  ClassList.InitRunStage;
  SymbolTable.InitRunStage;
  Code.InitRunStage;

  CreateRunList;
end;

procedure TPAXBaseScripter.ResetRunStage;
begin
  CancelMessage := '';

  ClassList.ResetRunStage;
  SymbolTable.ResetRunStage;
  Code.ResetRunStage;
  ScriptObjectList.ResetRunStage;
  ActiveXObjectList.Clear;
  TempObjectList.Clear;

  VariantStack.Clear;

  AllowedEvents := true;

  RunList.Clear;
end;

procedure TPAXBaseScripter.AddLocalDefs;
var
  I: Integer;
  SO: TPaxScriptObject;
  ID: Integer;
  ClassRec: TPaxClassRec;
begin
  for I:=0 to LocalDefinitions.Count - 1 do
    if LocalDefinitions.Records[I] is TPaxObjectDefinition then
    with LocalDefinitions.Records[I] as TPaxObjectDefinition do
    begin
      SO := DelphiInstanceToScriptObject(Instance, Self);
      Value := ScriptObjectToVariant(SO);

      if Owner <> nil then
        ClassRec := ClassList.FindClassByName(Owner.Name)
      else
        ClassRec := ClassList[0];

      ID := ClassRec.MemberList.GetMemberID(Name);
      if ID > 0 then
         ClassRec.DeleteMember(ID);

      AddToScripter(Self);
    end
    else if LocalDefinitions.Records[I] is TPaxVirtualObjectDefinition then
    with LocalDefinitions.Records[I] as TPaxVirtualObjectDefinition do
    begin
      if Owner <> nil then
        ClassRec := ClassList.FindClassByName(Owner.Name)
      else
        ClassRec := ClassList[0];

      ID := ClassRec.MemberList.GetMemberID(Name);
      if ID > 0 then
         ClassRec.DeleteMember(ID);

      AddToScripter(Self);
    end
    else if LocalDefinitions.Records[I] is TPaxInterfaceVarDefinition then
    with LocalDefinitions.Records[I] as TPaxInterfaceVarDefinition do
    begin
      if Owner <> nil then
        ClassRec := ClassList.FindClassByName(Owner.Name)
      else
        ClassRec := ClassList[0];

      ID := ClassRec.MemberList.GetMemberID(Name);
      if ID > 0 then
         ClassRec.DeleteMember(ID);

      AddToScripter(Self);
    end
    else if LocalDefinitions.Records[I] is TPAXConstantDefinition then
    with LocalDefinitions.Records[I] as TPaxConstantDefinition do
    begin
      if Owner <> nil then
        ClassRec := ClassList.FindClassByName(Owner.Name)
      else
        ClassRec := ClassList[0];

      ID := ClassRec.MemberList.GetMemberID(Name);
      if ID > 0 then
          ClassRec.DeleteMember(ID);
      AddToScripter(Self);
    end
    else if LocalDefinitions.Records[I] is TPAXVariableDefinition then
    with LocalDefinitions.Records[I] as TPaxVariableDefinition do
    begin
      if Owner <> nil then
        ClassRec := ClassList.FindClassByName(Owner.Name)
      else
        ClassRec := ClassList[0];

      ID := ClassRec.MemberList.GetMemberID(Name);
      if ID > 0 then
          ClassRec.DeleteMember(ID);
      AddToScripter(Self);
    end;
end;

procedure TPAXBaseScripter.AddDefs;
var
  I, N: Integer;
  SO: TPaxScriptObject;
  ID: Integer;
  DOB: TPaxObjectDefinition;
  D: TPaxDefinition;
begin
  if SignLoadOnDemand then
    N := DefListInitialCount
  else
    N := DefinitionList.Count;

  try
    _BeginRead;
    if not SignDefs then
    begin
      ClassList.AddDefinitionList(DefinitionList, N);
      SignDefs := true;
    end
    else
    begin
      for I:=0 to N - 1 do
      begin
        if I >= LastDefinitionListCount then
        begin
          D := DefinitionList.Records[I];
          D.AddToScripter(Self);
          continue;
        end;

        if DefinitionList.Records[I] is TPaxObjectDefinition then
        begin
          DOB := TPaxObjectDefinition(DefinitionList.Records[I]);
          with DOB do
          if IsObject(Value) then
          begin
            SO := VariantToScriptObject(Value);
            if SO.Instance <> Instance then
            begin
              SO := DelphiInstanceToScriptObject(Instance, Self);
              Value := ScriptObjectToVariant(SO);
            end;
          end
          else
          begin
            SO := DelphiInstanceToScriptObject(Instance, Self);
            Value := ScriptObjectToVariant(SO);

            ID := ClassList[0].MemberList.GetMemberID(Name);
            if ID = 0 then
              AddToScripter(Self);
          end;
        end
        else if DefinitionList.Records[I] is TPAXConstantDefinition then
        with DefinitionList.Records[I] as TPaxConstantDefinition do
        begin
          ID := ClassList[0].MemberList.GetMemberID(Name);
          if ID = 0 then
            AddToScripter(Self);
        end
        else if DefinitionList.Records[I] is TPAXVariableDefinition then
        with DefinitionList.Records[I] as TPaxVariableDefinition do
        begin
          ID := ClassList[0].MemberList.GetMemberID(Name);
          if ID = 0 then
            AddToScripter(Self);
        end;
      end;
    end;
  finally
    LastDefinitionListCount := DefinitionList.Count;
    _EndRead;
  end;
end;

function TPAXBaseScripter.AddModule(const ModuleName, LanguageName: String): Integer;
begin
  result := Modules.IndexOf(ModuleName);
  if result = -1 then
    result := Modules.Add(ModuleName, LanguageName);
end;

procedure TPAXBaseScripter.AddCode(const ModuleName, Code: String);
var
  I: Integer;
  Module: TPAXModule;
begin
  I := Modules.IndexOf(ModuleName);
  if I = -1 then
    raise TPAXScriptFailure.Create(Format(errModuleNotFound, [ModuleName]));
  Module := Modules.Items[I];
  Module.Text := Module.Text + Code;
end;

procedure TPAXBaseScripter.AddCodeFromFile(const ModuleName, FileName: String);
var
  L: TStringList;
  I: Integer;
  Module: TPAXModule;
begin
  if not FileExists(FileName) then
    Exit;
  L := TStringList.Create;
  try
    L.LoadFromFile(FileName);
    AddCode(ModuleName, L.Text);
    I := Modules.IndexOf(ModuleName);
    Module := Modules.Items[I];
    Module.FileName := FileName;
  finally
    L.Free;
  end;
end;

procedure TPAXBaseScripter.CopyLevelStack(Parser: TPAXParser);
var
  I, ID, L: Integer;
begin
  Parser.LevelStack.Clear;
  Parser.LevelStack.Push(0);

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
    Parser.LevelStack.Push(SymbolTable.RootNamespaceID);
end;

function TPAXBaseScripter.Eval(const SourceCode: String; Parser: TPAXParser): Variant;
var
  StartPos, ID, TempCount: Integer;
  Success: Boolean;
  CodeStackCard: Integer;
begin
  Parser.SetScripter(Self);

  Inc(EvalCount);
  StartPos := Code.Card;

  Code.SaveState;
  SymbolTable.SaveState;

  Success := true;
  Parser.Scanner.SourceCode := SourceCode;

  CopyLevelStack(Parser);

  TempCount := Parser.TempCount;
  Parser.UsingList.CopyFrom(Code.UsingList);
  Parser.WithStack.CopyFrom(Code.WithStack);
  ID := Parser.NewVar;
  try
    Parser.Call_SCANNER;
    Parser.Gen(OP_ASSIGN, ID, Parser.Parse_EvalExpression, ID);
  except
    Success := false;
  end;
  Parser.TempCount := TempCount;

  CodeStackCard := Code.Stack.Card;
  if Success then
  begin
    Parser.Gen(OP_HALT, 0, 0, 0);

    Code.DeclareOn := false;

    Code.N := StartPos;
    Code.SignFOP := false;
    Code.Terminated := false;
    Code.Run;

    result := SymbolTable.VariantValue[ID];
  end;

  SymbolTable.RestoreState;
  Code.RestoreState;
  Code.Stack.Card := CodeStackCard;

  Dec(EvalCount);
end;

procedure TPAXBaseScripter.EvalStatementList(const SourceCode: String; Parser: TPAXParser);
var
  StartPos, TempCount: Integer;
  Success: Boolean;
  CodeStackCard,
  TempCodeCard,
  TempSymbolCard,
  TempClassCount: Integer;
begin
  Parser.SetScripter(Self);

  Inc(EvalCount);
  StartPos := Code.Card;

  TempCodeCard := Code.Card;
  TempSymbolCard := SymbolTable.Card;
  TempClassCount := ClassList.Count;

  Code.SaveState;
  SymbolTable.SaveState;

  Success := true;
  Parser.Scanner.SourceCode := SourceCode;

  CopyLevelStack(Parser);

  TempCount := Parser.TempCount;
  Parser.UsingList.CopyFrom(Code.UsingList);
  Parser.WithStack.CopyFrom(Code.WithStack);
  try
    Parser.Call_SCANNER;
    Parser.Parse_StmtList;
  except
    Success := false;
  end;
  Parser.TempCount := TempCount;

  Dump();

  CodeStackCard := Code.Stack.Card;
  if Success then
  begin
    Parser.Gen(OP_HALT, 0, 0, 0);

    Code.DeclareOn := false;

    Code.LinkGoTo(TempCodeCard + 1, Code.Card);
    ClassList.CreateClassObjects(TempClassCount);
    ClassList.InitStaticFields(TempClassCount);
    SymbolTable.SetupSubs(TempSymbolCard + 1);

    Code.N := StartPos;
    Code.SignFOP := false;
    Code.Terminated := false;
    Code.Run;
  end;

  SymbolTable.RestoreState;
  Code.RestoreState;
  Code.Stack.Card := CodeStackCard;

  Dec(EvalCount);
end;

function TPAXBaseScripter.CompileModule(const Name: String;
                                        Parser: TPAXParser;
                                        SyntaxCheckOnly: Boolean = false): Boolean;
var
  I, ID: Integer;
  Module: TPAXModule;
begin
  result := true;
  Parser.SetScripter(Self);

  AddDefs;

  I := Modules.IndexOf(Name);
  if I = -1 then
    Exit;

  Module := Modules.Items[I];

  Module.S1 := SymbolTable.Card + 1;
  Module.P1 := Code.Card + 1;
  Module.C1 := ClassList.Count + 1;

  Parser.ModuleID := I;
  Parser.Scanner.SourceCode := Module.Text;
  Parser.SyntaxCheckOnly := SyntaxCheckOnly;

  with Parser do
  begin
    Gen(OP_BEGIN_WITH, WithStack.Push(SymbolTable.RootNamespaceID), 0, 0);

    UsingList.Push(SymbolTable.RootNamespaceID);

    if SignLoadOnDemand then
      ID := ClassList.FindClassByName(LanguageName + 'Namespace').ClassId
    else
      ID := LookUpID(LanguageName + 'Namespace');

    if ID <> 0 then
    begin
      Gen(OP_USE_NAMESPACE, UsingList.Push(ID), 0, 0);
      Gen(OP_USE_LANGUAGE_NAMESPACE, ID, 0, 0);
    end;
    Gen(OP_SEPARATOR, I, 0, 0);
  end;

  try
    Parser.Call_SCANNER;
    Parser.Parse_Program;

    if Parser.Scanner.DefStack.Count > 0 then
      raise TPaxScriptFailure.Create(errMissingENDIFdirective);

    Dump();
  except
    on E: Exception do
    begin
      result := false;
      Code.N := Code.Card;
      CreateErrorObject(E.Message, Parser.Scanner.PosNumber);

      Dump;
      if not SyntaxCheckOnly then
      begin
        if Assigned(fOnShowError) then
          fOnShowError(Owner)
        else
          ShowError;
      end;
    end;
  end;
{
  ClassRec := ClassList[0];
  for I:=0 to ClassRec.MemberList.Count - 1 do
  begin
    MemberRec := ClassRec.MemberList[I];
    if MemberRec.Kind = KindVAR then
      if (MemberRec.ID >= Module.S1) and (MemberRec.ID <= SymbolTable.Card) then
         Parser.Gen(OP_DESTROY_LOCAL_VAR, MemberRec.ID, 0, 0);
  end;
}
//  for I:=1 to Parser.UsingList.Card do
//    Parser.Gen(OP_END_OF_NAMESPACE, Parser.UsingList[I], 0, 0);
  Parser.Gen(OP_HALT, 0, 0, 0);

  Module.S2 := SymbolTable.Card;
  Module.P2 := Code.Card;
  Module.C2 := ClassList.Count;

  if not IsError then
  begin
    Code.LinkGoTo(Module.P1, Module.P2);
    Code.Optimization(Module.P1, Module.P2);
  end;
end;

procedure TPAXBaseScripter.CheckForUndeclared;
var
  I, ID, N, P: Integer;
  S: String;
begin
  for I:=0 to UnknownTypes.Count - 1 do
  begin
    ID := UnknownTypes[I].ID;
    ID := TypeAliasList.Convert(ID);

    N := UnknownTypes[I].N;
    P := UnknownTypes[I].Pos;
    S := SymbolTable.Name[ID];

    if (ID >= 0) and (ID < PaxTypes.Count) then
      Continue;

    if ClassList.FindClassByName(S) = nil then
    begin
      S := Format(errUndeclaredIdentifier, [S]);
      Code.N := N;
      CreateErrorObject(S, P);
      Exit;
    end;
  end;

  CheckCalls;
end;

function TPAXBaseScripter.MatchAssignment(T1, T2: Integer): Boolean;
begin
  result := true;

  if T1 = T2 then
    Exit;

  if T1 = typeVARIANT then
    Exit;

  if T2 = typeVARIANT then
    Exit;

  if T1 > PAXTypes.Count then
    Exit;

  if T2 > PAXTypes.Count then
    Exit;

  if T1 <= 0 then
    Exit;

  if T2 <= 0 then
    Exit;

  if AssResultTypes[T1, T2] then
    Exit;

  result := false;
end;

function TPAXBaseScripter.OpResultType(T1, T2: Integer): Integer;
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

function TPAXBaseScripter.MatchTypes(T1, T2: Integer): Integer;
begin
  if T1 = T2 then
    result := T1
  else if T1 = typeVARIANT then
    result := T1
  else if T2 = typeVARIANT then
    result := T2
  else
    result := OpResultType(T1, T2);
end;

function TPAXBaseScripter.MatchAssignmentStrict(T1, T2: Integer): Boolean;
begin
  if T1 = T2 then
    result := true
  else if T1 > PAXTypes.Count then
    result := false
  else if T2 > PAXTypes.Count then
    result := false
  else
    result := AssResultTypes[T1, T2];
end;

function TPAXBaseScripter.strIncompatibleTypes(T1, T2: Integer): String;
begin
  result := Format(errIncompatibleTypesExt, [SymbolTable.Name[T1], SymbolTable.Name[T2]]);
end;

procedure TPAXBaseScripter.CheckCalls;
var
  Assoc1, Assoc2, Assoc3, Assoc4: TPaxIds;
  Members: TList;
  UsingList: TPaxUsingList;
  WithStack: TPaxWithStack;

  JSOpers: Boolean;

function A1A2(ID: Integer): Integer;
var
  I: Integer;
begin
  ID := TypeAliasList.Convert(ID);

  I := Assoc1.IndexOf(ID);
  if I <> - 1 then
    result := Assoc2[I]
  else
    result := ID;
end;

function A2A1(ID: Integer): Integer;
var
  I: Integer;
begin
  ID := TypeAliasList.Convert(ID);

  I := Assoc2.IndexOf(ID);
  if I <> - 1 then
    result := Assoc1[I]
  else
    result := ID;
end;

function A3A4(ID: Integer): Integer;
var
  I: Integer;
begin
  ID := TypeAliasList.Convert(ID);

  I := Assoc3.IndexOf(ID);
  if I <> - 1 then
    result := Assoc4[I]
  else
    result := ID;
end;

function GetMemberRec(SubID: Integer; L: TList): TPaxMemberRec;
var
  MemberRec: TPaxMemberRec;
  I: Integer;
begin
  result := nil;
  for I:=0 to L.Count - 1 do
  begin
    MemberRec := TPaxMemberRec(L[I]);
    if MemberRec.ID = SubID then
    begin
      result := MemberRec;
      Exit;
    end;
  end;
end;

function HasComponent(Instance: TObject; const S: String; var ClsType: String): Boolean;
var
  C: TComponent;
  I: Integer;
begin
  result := false;
  if Instance = nil then
    Exit;
  if not Instance.InheritsFrom(TComponent) then
    Exit;

  C := TComponent(Instance);

  for I:=0 to C.ComponentCount - 1 do
    if StrEql(C.Components[I].Name, S) then
    begin
      clsType := C.Components[I].ClassName;
      result := true;
      Exit;
    end;
end;

function EvalID(ID: Integer; UpCaseOn: Boolean;
                var IsPublished: Boolean;
                var IsVariant: Boolean): TPaxMemberRec;
var
  I, J, K, ObjectID, ClassID: Integer;
  ClassRec: TPaxClassRec;
  D, DDest: TPaxDefinition;
  Instance: TObject;
  clsType: String;

  DefList: TPaxDEfinitionList;
  DOB: TPaxObjectDefinition;
  DI: TPaxInterfaceVarDefinition;
  CR: TPaxClassRec;

  S: String;
  L: TList;
begin
  result := nil;
  IsPublished := false;
  IsVariant := false;

  for I:=WithStack.Card downto 1 do
  begin
    ObjectID := WithStack[I];
    K := SymbolTable.Kind[ObjectID];
    if K = KindTYPE then
    begin
      ClassRec := ClassList.FindClass(ObjectID);
      if ClassRec <> nil then
      begin
        result := ClassRec.MemberList.GetMemberRec(SymbolTable.Name[ID], UpCaseON);
        if result <> nil then
          Exit;
        if ClassRec.HasPublishedProperty(SymbolTable.Name[ID]) then
        begin
          IsPublished := true;
          Exit;
        end;
        if (ObjectId = SymbolTable.RootNamespaceID) and SignLoadOnDemand then
        begin
          CR := ClassList.FindClassByName(SymbolTable.Name[ID]);
          if CR <> nil then
          begin
            result := ClassRec.MemberList.GetMemberRecByID(CR.ClassID);
            if result <> nil then
              Exit;
          end;
        end;
      end;
    end
    else if K = KindHOSTOBJECT then
    begin
      J := SymbolTable.GetVariant(ObjectID);

      if J > 0 then
      begin
        DefList := DefinitionList;
        DOB := TPaxObjectDefinition(DefList[J]);
      end
      else
      begin
        DefList := LocalDefinitions;
        DOB := TPaxObjectDefinition(DefList.GetRecordByIndex(- J));
      end;

      Instance := DOB.Instance;

      if HasComponent(Instance, SymbolTable.Name[ID], clsType) then
      begin
        IsPublished := true;
        Exit;
      end;
      ClassRec := ClassList.FindClassByName(Instance.ClassName);
      if ClassRec <> nil then
      begin
        result := ClassRec.MemberList.GetMemberRec(SymbolTable.Name[ID], UpCaseON);
        if result <> nil then
          Exit;
        if ClassRec.HasPublishedProperty(SymbolTable.Name[ID]) then
        begin
          IsPublished := true;
          Exit;
        end;
      end;

    end
    else if K = KindVIRTUALOBJECT then
    begin
      SymbolTable.GetVariant(ObjectID);
    end
    else if K = KindHOSTINTERFACEVAR then
    begin
      J := SymbolTable.GetVariant(ObjectID);

      if J > 0 then
      begin
        DefList := DefinitionList;
        DI := TPaxInterfaceVarDefinition(DefList[J]);
      end
      else
      begin
        DefList := LocalDefinitions;
        DI := TPaxInterfaceVarDefinition(DefList.GetRecordByIndex(- J));
      end;

      ClassRec := ClassList.FindClassByGuid(DI.Guid);
      if ClassRec <> nil then
      begin
        result := ClassRec.MemberList.GetMemberRec(SymbolTable.Name[ID], UpCaseON);
        if result <> nil then
          Exit;
      end;
    end
    else if K = KindVAR then
    begin
      if ObjectID < 0 then
      begin
        _BeginRead;
        try
          D := DefinitionList.GetRecordByIndex(- ObjectID);
        finally
          _EndRead;
        end;
        if D.DefKind = dkObject then
        begin
          Instance := TPaxObjectDefinition(D).Instance;
          if HasComponent(Instance, SymbolTable.Name[ID], clsType) then
          begin
            IsPublished := true;
            Exit;
          end;
          ClassRec := ClassList.FindClassByName(Instance.ClassName);
          if ClassRec <> nil then
          begin
            result := ClassRec.MemberList.GetMemberRec(SymbolTable.Name[ID], UpCaseON);
            if result <> nil then
              Exit;
          end;
        end;
      end;

      ClassID := SymbolTable.PType[ObjectID];
      ClassID := A1A2(ClassID);
      ClassRec := ClassList.FindClass(ClassID);

      if ClassID = typeVARIANT then
        IsVariant := true;

      if ClassRec <> nil then
      begin
        if ClassRec.HasRunTimeProperties then
          IsVariant := true;

        result := ClassRec.MemberList.GetMemberRec(SymbolTable.Name[ID], UpCaseON);
        if result <> nil then
          Exit;
        if ClassRec.HasPublishedProperty(SymbolTable.Name[ID]) then
        begin
          IsPublished := true;
          Exit;
        end;
      end;
    end;
  end;

  for I:=UsingList.Card downto 1 do
  begin
    ObjectID := UsingList[I];
    ClassRec := ClassList.FindClass(ObjectID);
    if ClassRec <> nil then
    begin
      result := ClassRec.MemberList.GetMemberRec(SymbolTable.Name[ID], UpCaseON);
      if result <> nil then
        Exit;
      if ClassRec.HasPublishedProperty(SymbolTable.Name[ID]) then
      begin
        IsPublished := true;
        Exit;
      end;
    end;
  end;

  if result = nil then if SignLoadOnDemand then
  begin
    S := SymbolTable.Name[ID];
    for I:=UsingList.Card downto 1 do
    begin
      ObjectID := UsingList[I];
      if ObjectID < 0 then
      begin
        D := DefinitionList.GetRecordByIndex(- ObjectID);
        L := DefinitionList.LookupAll(S, dkAny, D);
        for J:=0 to L.Count - 1 do
        begin
          DDest := TPaxDefinition(L[J]);
          ClassRec := ClassList.FindClass(ObjectID);

          if DDest.DefKind = dkConstant then
            result := ClassRec.AddHostConstant(DDest as TPaxConstantDefinition)
          else if DDest.DefKind = dkVariable then
            result := ClassRec.AddHostVariable(DDest as TPaxVariableDefinition)
          else if DDest.DefKind = dkObject then
            result := ClassRec.AddHostObject(DDest as TPaxObjectDefinition)
          else if DDest.DefKind = dkVirtualObject then
            result := ClassRec.AddVirtualObject(DDest as TPaxVirtualObjectDefinition)
          else if DDest.DefKind = dkMethod then
            result := ClassRec.AddHostMethod(DDest as TPaxMethodDefinition);

          break;
        end;
        L.Free;
      end;
    end;

    if result = nil then
    begin
      L := DefinitionList.LookupAll(S, dkAny, nil);
      for I:=0 to L.Count - 1 do
      begin
        DDest := TPaxDefinition(L[I]);

        ClassRec := ClassList[0];

        if DDest.DefKind = dkConstant then
          result := ClassRec.AddHostConstant(DDest as TPaxConstantDefinition)
        else if DDest.DefKind = dkVariable then
          result := ClassRec.AddHostVariable(DDest as TPaxVariableDefinition)
        else if DDest.DefKind = dkObject then
          result := ClassRec.AddHostObject(DDest as TPaxObjectDefinition)
        else if DDest.DefKind = dkVirtualObject then
          result := ClassRec.AddVirtualObject(DDest as TPaxVirtualObjectDefinition)
        else if DDest.DefKind = dkMethod then
          result := ClassRec.AddHostMethod(DDest as TPaxMethodDefinition);
      end;
      L.Free;
    end;
  end;
end;

procedure AssignBinaryOperator(const OperName: String; I: Integer);
var
  T1, T2, ResType, SubID, ResID: Integer;
  ClassRec: TPaxClassRec;
begin
  T1 := A1A2(SymbolTable.PType[Code.Prog[I].Arg1]);
  T2 := A1A2(SymbolTable.PType[Code.Prog[I].Arg2]);
  if T1 > PaxTypes.Count then
  begin
    ClassRec := ClassList.FindClass(T1);
    if ClassRec <> nil then
      Code.Prog[I].AltArg1 := ClassRec.FindBinaryOperatorID(OperName, T1, T2);
  end
  else
  if T2 > PaxTypes.Count then
  begin
    ClassRec := ClassList.FindClass(T2);
    if ClassRec <> nil then
      Code.Prog[I].AltArg1 := ClassRec.FindBinaryOperatorID(OperName, T1, T2);
  end;

  if Code.Prog[I].AltArg1 = 0 then
  begin
    if JSOpers then
      Exit;

    ResType := MatchTypes(T1, T2);
    if ResType > 0 then
    begin
      if RelationalOperators.IndexOf(OperName) <> -1 then
        SymbolTable.PType[Code.Prog[I].Res] := typeBOOLEAN
      else
        SymbolTable.PType[Code.Prog[I].Res] := ResType;
    end
    else
    begin
      Dump();
      Code.N := I;
      CreateErrorObject(strIncompatibleTypes(T1, T2), Code.Prog[I].LinePos);
    end;
  end
  else
  begin
    SubID := Code.Prog[I].AltArg1;
    ResID := SymbolTable.GetResultID(SubID);
    ResType := SymbolTable.PType[ResID];
    SymbolTable.PType[Code.Prog[I].Res] := ResType;
  end;
end;

procedure AssignUnaryOperator(const OperName: String; I: Integer);
var
  T1, ResType, SubID, ResID: Integer;
  ClassRec: TPaxClassRec;
begin
  T1 := A1A2(SymbolTable.PType[Code.Prog[I].Arg1]);
  if T1 > PaxTypes.Count then
  begin
    ClassRec := ClassList.FindClass(T1);
    if ClassRec <> nil then
      Code.Prog[I].AltArg1 := ClassRec.FindUnaryOperatorID(OperName, T1);
  end;
  if Code.Prog[I].AltArg1 = 0 then
  begin
    if JSOpers then
      Exit;
    SymbolTable.PType[Code.Prog[I].Res] := SymbolTable.PType[Code.Prog[I].Arg1];
  end
  else
  begin
    SubID := Code.Prog[I].AltArg1;
    ResID := SymbolTable.GetResultID(SubID);
    ResType := SymbolTable.PType[ResID];
    SymbolTable.PType[Code.Prog[I].Res] := ResType;
  end;
end;

var
  Index, I, J, K, ID, NP, NP1, SubID, ClassID, ExprID, ParamID, T1, T2: Integer;
  ClassRec: TPaxClassRec;
  Ids: TPaxIds;
  S: String;
  D: TPaxDefinition;
  MemberRec: TPaxMemberRec;
  SubCount, BoundID: Integer;
  DeclareON: Boolean;
  UpCaseON: Boolean;
  ma: TPaxMemberAccess;
  IsPublished: Boolean;
  IsVariant: Boolean;
  Instance: TObject;
  OP: Integer;
  DM: TPaxMethodDefinition;
  I1: Integer;
  DP: TPaxPropertyDefinition;
  S1, S2, clsType: String;
  C1, C2: TPaxClassRec;
  DC1, DC2, DelphiClassEx: TClass;
  K1: Integer;
  DOB: TPaxObjectDefinition;
  IsOverloaded: Boolean;
  Module1, Module2: Integer;
  declared: Boolean;
  ResId: Integer;
label
  Del, patch_label;
begin
  Dump();

  JSOpers := false;
  UsingList := TPaxUsingList.Create;
  WithStack := TPaxWithStack.Create;
  Ids := TPaxIds.Create(false);
  Assoc1 := TPaxIds.Create(true);
  Assoc2 := TPaxIds.Create(true);
  Assoc3 := TPaxIds.Create(true);
  Assoc4 := TPaxIds.Create(true);
  Members := TList.Create;

  DeclareON := true;
  UpCaseON := true;
  IsPublished := false;

  try

    for I:=1 to Code.Card do
    begin
      Index := -1;

      OP := Code.Prog[I].Op;

      if (OP = OP_CALL) or (OP = OP_CALL_CONSTRUCTOR) then
        Index := CallRecList.IndexOf(I)
      else if OP = OP_SET_TYPE then
      begin
        S := _GetName(Code.Prog[I].Arg2, Self);
        ClassRec := ClassList.FindClassByName(S);
        if ClassRec = nil then
        begin
          if DeclareON then
          begin
            Dump();
            S := Format(errUndeclaredIdentifier, [S]);
            Code.N := I;
            CreateErrorObject(S, Code.Prog[I].LinePos);
            Exit;
          end;
        end
        else
        begin
          ID := Code.Prog[I].Arg1;
          SymbolTable.PType[ID] := ClassRec.ClassID;
        end;
      end
      else if (OP = OP_PLUS) or (OP = OP_PLUS_EX) then
      begin
        AssignBinaryOperator('+', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_UNARY_PLUS) then
      begin
        AssignUnaryOperator('+', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_MINUS) or (OP = OP_MINUS_EX) then
      begin
        AssignBinaryOperator('-', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_UNARY_MINUS) or (OP = OP_UNARY_MINUS_EX) then
      begin
        AssignUnaryOperator('-', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_MULT) or (OP = OP_MULT_EX) then
      begin
        AssignBinaryOperator('*', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_DIV) or (OP = OP_DIV_EX) then
      begin
        AssignBinaryOperator('/', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_MOD) or (OP = OP_MOD_EX) then
      begin
        AssignBinaryOperator('%', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_LEFT_SHIFT) or (OP = OP_LEFT_SHIFT_EX) then
      begin
        AssignBinaryOperator('<<', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_RIGHT_SHIFT) or (OP = OP_RIGHT_SHIFT_EX) then
      begin
        AssignBinaryOperator('>>', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_EQ) or (OP = OP_EQ_EX) then
      begin
        AssignBinaryOperator('==', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_NE) or (OP = OP_NE_EX) then
      begin
        AssignBinaryOperator('!=', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_LT) or (OP = OP_LT_EX) then
      begin
        AssignBinaryOperator('<', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_GT) or (OP = OP_GT_EX) then
      begin
        AssignBinaryOperator('>', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_LE) or (OP = OP_LE_EX) then
      begin
        AssignBinaryOperator('<=', I);
        if IsError then
          Exit;
      end
      else if (OP = OP_GE) or (OP = OP_GE_EX) then
      begin
        AssignBinaryOperator('>=', I);
        if IsError then
          Exit;
      end
      else if OP = OP_JS_OPERS_ON then
        JSOpers := true
      else if OP = OP_JS_OPERS_OFF then
        JSOpers := false
      else if OP = OP_DECLARE_ON then
        DeclareON := true
      else if OP = OP_DECLARE_OFF then
        DeclareON := false
      else if OP = OP_UPCASE_ON then
        UpcaseON := true
      else if OP = OP_UPCASE_OFF then
        UpcaseON := false
      else if OP = OP_BEGIN_WITH then
      begin
        ID := Code.Prog[I].Arg1;
        ID := A1A2(ID);
        ID := A3A4(ID);
        WithStack.Push(ID);
      end
      else if OP = OP_END_WITH then
        WithStack.Pop
      else if OP = OP_USE_NAMESPACE then
      begin
        ID := Code.Prog[I].Arg1;
        ID := A1A2(ID);
        UsingList.PushUnique(ID);
      end
      else if OP = OP_END_OF_NAMESPACE then
      begin
        ID := Code.Prog[I].Arg1;
        ID := A2A1(ID);
        UsingList.Delete(ID);
      end
      else if OP = OP_CHECK_CLASS then
      begin
        if Code.Prog[I+1].Op = OP_CREATE_OBJECT then
        begin
          ID := Code.Prog[I+1].Arg1;
          ClassID := A1A2(ID);
          Code.Prog[I].Op  := OP_NOP;
          ClassRec := ClassList.FindClass(ClassID);
          if ClassRec <> nil then
            if ClassRec.ck = ckClass then
            begin
              Code.Prog[I+1].Op  := OP_NOP;
              Code.Prog[I+1].Arg1 := 0;
              Code.Prog[I+1].Res := 0;
            end;
        end;
      end
      else if OP = OP_CREATE_RESULT then
      begin
        ID := Code.Prog[I].Arg1;
        ID := A1A2(ID);
        if (ID >= 0) and (ID < PaxTypes.Count - 1) then
        begin
          Code.Prog[I].Op  := OP_NOP;
          Code.Prog[I].Arg1 := 0;
          Code.Prog[I].Res := 0;
        end
        else
          Code.Prog[I].Arg1 := ID;
      end
      else if OP = OP_CREATE_OBJECT then
      begin
        ID := Code.Prog[I].Arg1;
        ID := A1A2(ID);
        if (ID >= 0) and (ID < PaxTypes.Count - 1) then
        begin
          Code.Prog[I].Op  := OP_NOP;
          Code.Prog[I].Arg1 := 0;
          Code.Prog[I].Res := 0;
        end
        else
          Code.Prog[I].Arg1 := ID;
      end
      else if OP = OP_ASSIGN_SIMPLE then
      begin
//        Code.Prog[I].Op := OP_ASSIGN;
      end
      else if OP = OP_ASSIGN then
      with Code.Prog[I], SymbolTable do
      begin
        if (Kind[Arg1] = KindHostConst) then
        begin
          Self.Dump();
          Code.N := I;
          S := errLeftSideCannotBeAssignedTo;
          CreateErrorObject(S, Code.Prog[I].LinePos);
          Exit;
        end;

        ClassID := PType[Arg2];
        ClassID := A1A2(ClassID);

        if not MatchAssignment(A1A2(PType[Arg1]), ClassID) then
        begin
          Self.Dump();
          Code.N := I;
          S := errIncompatibleTypes;
          CreateErrorObject(S, Code.Prog[I].LinePos);
          Exit;
        end;

        if ClassID <> typeVARIANT then
        begin
          if (PType[Arg1] = typeVARIANT) or (PType[Arg1] = typeVOID) then
            if not SymbolTable.IsFormalParamID(Arg1) then
            begin
               declared := false;
               for J:=1 to I do
                 if (Code.Prog[J].Op = OP_DECLARE) and (Code.Prog[J].Arg1 = Arg1) then
                 begin
                   declared := true;
                   break;
                 end;

              if not declared then
                PType[Arg1] := ClassID;
            end;
        end;
      end
      else if OP = OP_CREATE_REF then
      begin
        ID := Code.Prog[I].Arg1;
        ID := A1A2(ID);
        ID := A3A4(ID);

        Instance := nil;

        if ID < 0 then
        begin
          D := DefinitionList.GetRecordByIndex(-ID);
          if D.DefKind = dkObject then
          begin
            Instance := TPaxObjectDefinition(D).Instance;

            S := Instance.ClassName;
            ClassRec := ClassList.FindClassByName(S);
          end
          else if D.DefKind = dkInterface then
          begin
            ClassRec := ClassList.FindClassByGuid(TPaxInterfaceVarDefinition(D).guid);
          end
          else if D.DefKind = dkClass then
          begin
            ClassRec := ClassList.FindClassByName(D.Name);
          end
          else if D.DefKind = dkMethod then
          begin
            ClassRec := ClassList.FindClassByName(TPaxMethodDefinition(D).StrTypes[0]);
          end
          else
            ClassRec := nil;
        end
        else
        begin
          if SymbolTable.Kind[ID] = KindTYPE then
            ClassID := ID
          else
          begin
            ClassID := SymbolTable.PType[ID];
            ClassID := A1A2(ClassID);
          end;
          ClassRec := ClassList.FindClass(ClassID);

          if SymbolTable.Kind[ID] = KindHOSTOBJECT then
          with SymbolTable do
          begin
            J := GetVariant(ID);
            if J > 0 then
              DOB := TPaxObjectDefinition(DefinitionList[J])
            else
              DOB := TPaxObjectDefinition(LocalDefinitions.GetRecordByIndex(-J));
            Instance := DOB.Instance;
          end
          else if SymbolTable.Kind[ID] = KindVIRTUALOBJECT then
          with SymbolTable do
          begin
            A[Code.Prog[I].Res].Owner := ID;
          end;
        end;

        ma := TPaxMemberAccess(Code.Prog[I].Arg2);
        if ma = maMyBase then
          if ClassRec <> nil then
             ClassRec := ClassList.FindClassByName(ClassRec.AncestorName);

        if ClassRec <> nil then
        begin
          ID := Code.Prog[I].Res;
          MemberRec := ClassRec.MemberList.GetMemberRec(SymbolTable.Name[ID], UpCaseON);

          if MemberRec <> nil then
          begin
            if MemberRec.ID > 0 then
            begin
              Module1 := Code.GetModuleID(I);
              Module2 := SymbolTable.Module[MemberRec.ID];
              if Module1 <> Module2 then
                if MemberRec.IsImplementationSection then
                begin
                  S := SymbolTable.Name[MemberRec.ID];
                  S := Format(errMemberIsNotAccessible, [S]);
                  Code.N := I;
                  CreateErrorObject(S, Code.Prog[I].LinePos);
                  break;
                end;
            end;

            if (MemberRec.Kind = KindPROP) and (MemberRec.Definition <> nil) then
            begin
              DP := TPaxPropertyDefinition(MemberRec.Definition);
              ClassRec := ClassList.FindClassByName(DP.PropType);
              if ClassRec <> nil then
              begin
                Assoc3.Add(ID);
                Assoc4.Add(ClassRec.ClassID);
              end;
            end
            else
            begin
              S := SymbolTable.Name[ID];

              DelphiClassEx := ClassRec.DelphiClassEx;
              if DelphiClassEx <> nil then
              begin
                if HasPublishedProperty(DelphiClassEx, S, Self, false) then
                if HasForbiddenPublishedProperty(DelphiClassEx, S) then
                begin
                  S := Format(errMemberIsNotAccessible, [S]);
                  Code.N := I;
                  CreateErrorObject(S, Code.Prog[I].LinePos);
                  break;
                end;
              end;

              if ClassRec.HasPublishedPropertyEx(S, clsType) then
              begin
                ClassRec := ClassList.FindClassByName(clsType);
                if ClassRec <> nil then
                begin
                  Assoc3.Add(ID);
                  Assoc4.Add(ClassRec.ClassID);
                  SymbolTable.PType[ID] := ClassRec.ClassID;
                end;
              end
              else
              begin
                Assoc1.Add(ID);
                Assoc2.Add(MemberRec.ID);
                Members.Add(MemberRec);
              end;

              S := SymbolTable.Name[ID];
              if StrEql(S, 'Create') then
                SymbolTable.PType[ID] := ClassRec.ClassID;

            end;
          end
          else
          begin
            S := SymbolTable.Name[ID];
            if StrEql(S, 'NEW') or StrEql(S, ClassRec.Name) or
              StrEql(ClassRec.Name, 'ACTIVEXOBJECT') or
              StrEql(ClassRec.Name, 'OBJECT') or
              StrEql(ClassRec.Name, 'STRING') or
              StrEql(ClassRec.Name, 'ARRAY') or
              ClassRec.HasRunTimeProperties then
            begin
              SymbolTable.PType[ID] := ClassRec.ClassID
            end
            else if Pos('$$', S) > 0 then
            begin
            end
            else if ClassRec.HasPublishedPropertyEx(S, clsType) then
            begin
              ClassRec := ClassList.FindClassByName(clsType);
              if ClassRec <> nil then
              begin
                Assoc3.Add(Code.Prog[I].Res);
                Assoc4.Add(ClassRec.ClassID);
              end;
            end
            else if HasComponent(Instance, S, clsType) then
            begin
              ClassRec := ClassList.FindClassByName(clsType);
              if ClassRec <> nil then
              begin
                Assoc3.Add(Code.Prog[I].Res);
                Assoc4.Add(ClassRec.ClassID);
              end;
            end
            else if DeclareON and (not ClassRec.HasRunTimeProperties) then
            begin
              Dump();
              S := Format(errPropertyIsNotFound, [S]);
              Code.N := I;
              CreateErrorObject(S, Code.Prog[I].LinePos);
              Exit;
            end;
          end;
        end;
      end
      else if OP = OP_EVAL_WITH then
      begin
        if SymbolTable.Name[Code.Prog[I].Res] = '' then
        begin
          Code.Prog[I].Op  := OP_NOP;
          Code.Prog[I].Res := 0;
          Continue;
        end;

        ClassID := TypeAliasList.Convert(Code.Prog[I].Res);

        if (ClassID >= 0) and (ClassID < PaxTypes.Count - 1) then
        begin
          Code.Prog[I].Op  := OP_NOP;
          Code.Prog[I].Res := 0;
          Continue;
        end;

        ID := ClassID;
        Code.Prog[I].Res := ID;

        MemberRec := EvalID(ID, UpCaseOn, IsPublished, IsVariant);

        if MemberRec = nil then
        if not IsPublished then
        if DeclareON then
        begin
          if IsVariant then
            continue;

          S := SymbolTable.Name[ID];

          if MemberRec = nil then
          begin
            Dump();
            S := Format(errPropertyIsNotFound, [S]);
            Code.N := I;
            CreateErrorObject(S, Code.Prog[I].LinePos);
            break;
          end;
        end;

        if MemberRec <> nil then
        if ID <> MemberRec.ID then
        begin
          if MemberRec.ID > 0 then
            if SymbolTable.Kind[MemberRec.ID] = KindHOSTOBJECT then
            begin
              Code.Prog[I].Op := OP_NOP;
              Code.ReplaceID(Code.Prog[I].Res, MemberRec.ID);
              Dump();

              continue;
            end;

          if MemberRec.ID > 0 then
          begin
            Module1 := Code.GetModuleID(I);
            Module2 := SymbolTable.Module[MemberRec.ID];
            if Module1 <> Module2 then
              if MemberRec.IsImplementationSection then
              begin
                S := SymbolTable.Name[MemberRec.ID];
                S := Format(errMemberIsNotAccessible, [S]);
                Code.N := I;
                CreateErrorObject(S, Code.Prog[I].LinePos);
                break;
              end;
          end;

          Assoc1.Add(ID);
          Assoc2.Add(MemberRec.ID);
          Members.Add(MemberRec);
        end;
      end;

      if Index <> -1 then
      with CallRecList[Index] do
      begin
        if (Code.Prog[CallN].Op <> OP_CALL) and (Code.Prog[CallN].Op <> OP_CALL_CONSTRUCTOR) then
          Continue;

        SubID := Code.Prog[CallN].Arg1;

        if SymbolTable.Kind[SubID] <> KindSUB then
        begin
          SubID := A1A2(SubID);
        end;

        patch_label:

        if SymbolTable.Kind[SubID] <> KindSUB then
        begin
          if SymbolTable.Kind[SubID] = KindPROP then
          begin
            ClassRec := ClassList.FindClass(SymbolTable.Level[SubID]);
            if ClassRec <> nil then
            begin
              MemberRec := ClassRec.MemberList.GetMemberRec(SymbolTable.Name[SubID]);
              if MemberRec <> nil then
              if MemberRec.ReadID <> 0 then
              begin
                SubId := MemberRec.ReadID;
                ResId := Code.Prog[I].Res;
                SymbolTable.Ptype[ResId] := SymbolTable.PType[SubId];
                goto patch_label;
              end;
            end;
          end;

          S := SymbolTable.Name[SubID];
          if StrEql(S, 'New') then
          begin
            with SymbolTable, Code.Prog[CallN] do
              if PType[Res] = typeVARIANT then
                 PType[Res] := PType[Arg1]
          end
          else
          begin
            ClassRec := ClassList.FindClassByName(S);
            if ClassRec <> nil then
              with SymbolTable, Code.Prog[CallN] do
              begin
                if PType[Res] = typeVARIANT then
                   PType[Res] := PType[Arg1];
                if ClassRec.IsStatic then
                   Code.Prog[CallN].Op := OP_CALL
                else if Code.Prog[CallN].Op = OP_CALL_CONSTRUCTOR then
                   Code.Prog[CallN].Op := OP_CALL
                else
                   Code.Prog[CallN].Op := OP_TYPE_CAST;
              end
            else if (SubId > 0) and (SubId <= PaxTypes.Count) then
            begin
              with SymbolTable, Code.Prog[CallN] do
              begin
                if PType[Res] = typeVARIANT then
                   PType[Res] := PType[Arg1];
                Code.Prog[CallN].Op := OP_TYPE_CAST;
              end;
            end;
          end;

          Continue;
//          S := Format(errPropertyIsNotFound, [SymbolTable.Name[SubID]]);
//          Code.N := CallN;
//          CreateErrorObject(S, CallP);
//          Exit;
        end;

        MemberRec := GetMemberRec(SubID, Members);

        NP := Code.Prog[CallN].Arg2;

        if SubID > 0 then
        begin
          ClassID := SymbolTable.Level[SubID];
          ClassRec := ClassList.FindClass(ClassID);
        end
        else
        begin
          D := DefinitionList.GetRecordByIndex(-SubID);
          if D.Owner = nil then
            ClassRec := ClassList[0]
          else
            ClassRec := ClassList.FindClassByName(D.Owner.Name);
        end;

        if ClassRec = nil then
        begin
          ClassID := SymbolTable.Level[SubID];
          if SymbolTable.Kind[ClassID] = KindSUB then
            continue; // nested subroutine

          Dump();
          Code.N := CallN;
          S := Format(errPropertyIsNotFound, [SymbolTable.Name[SubID]]);
          CreateErrorObject(S, CallP);
          Exit;
        end;

        Ids.Clear;
        ClassRec.FindOverloadedSubList(SymbolTable.NameIndex[SubID], maAny, Ids);

        SubCount := Ids.Count;

        IsOverloaded := Ids.Count > 1;


        for J:=Ids.Count - 1 downto 0 do
        begin
          ID := Ids[J];

          if SymbolTable.Count[ID] = -1 then
            Continue;

          if SymbolTable.Count[ID] > NP then
          begin
            if ID > 0 then
            begin
              NP1 := NP;

              BoundID := SymbolTable.GetParamID(ID, NP1);
              K := DefaultParameterList.FindFirst(ID);
              while K <> -1 do
              begin
                if DefaultParameterList[K].ID > BoundID then
                  Inc(NP1);
                K := DefaultParameterList.FindNext(K, ID);
              end;
              if NP1 <> SymbolTable.Count[ID] then
                goto Del;
            end
            else
            begin
              DM := TPaxMethodDefinition(DefinitionList.GetRecordByIndex(-ID));
              if SymbolTable.Count[ID] - DM.DefParamList.Count > NP then
                goto Del;
            end;
          end
          else if SymbolTable.Count[ID] < NP then
            goto Del;

          for K:=0 to ArgsN.Count - 1 do
          begin
            ExprID := Code.Prog[ArgsN[K]].Arg1;
            T2 := SymbolTable.PType[ExprID];

            S1 := '';
            S2 := SymbolTable.Name[T2];

            if T2 < 0 then
            begin
              if Copy(S2, 1, 1) = 'I' then
                T2 := typeINTERFACE
              else
                T2 := typeCLASS;
            end;

            D := nil;

            if ID > 0 then
            begin
              ParamID := SymbolTable.GetParamID(ID, K + 1);
              T1 := SymbolTable.PType[ParamID];
            end
            else
            begin
              D := DefinitionList.GetRecordByIndex(-ID);
              if TPaxMethodDefinition(D).NP < 0 then
                T1 := typeVARIANT
              else
              begin
                if K < Length(TPaxMethodDefinition(D).Types) then
                begin
                  T1 := TPaxMethodDefinition(D).Types[K];
                  S1 := TPaxMethodDefinition(D).StrTypes[K];
                end
                else
                  T1 := typeVARIANT;
              end;
            end;

            if StrEql(S1, S2) then
              continue;

            if not MatchAssignment(T1, T2) then
              goto Del;

            if (T1 = typeVARIANT) and (T2 = typeCLASS) and (ID < 0) and (Ids.Count > 1) then
              goto Del;


            if SymbolTable.Kind[T2] <> KindTYPE then
            begin
              ClassRec := ClassList.FindClassByName(SymbolTable.Name[T2]);
              if ClassRec <> nil then
              begin
                if (T1 = TypeINTERFACE) and (ClassRec.ck = ckInterface) then
                  continue;

                if (T1 > 0) and (T1 < PaxTypes.Count) then
                  if not (T1 in [typeCLASS, typeVARIANT]) then
                     goto Del;

                if SymbolTable.Kind[T1] <> KindTYPE then
                begin
                  ClassRec := ClassList.FindClassByName(SymbolTable.Name[T1]);
                  if ClassRec = nil then
                    goto Del;
                end;
              end;
            end;


            if Copy(S2, 1, 2) = '__' then // script-defined array
            begin
              if D <> nil then // host proc
              begin
                if K < Length(TPaxMethodDefinition(D).Types) then
                begin
                  if TPaxMethodDefinition(D).ExtraTypes[K] = typeDYNAMICARRAY then
                    continue
                  else
                    goto Del;
                end;
              end;
            end;

            if (T1 = typeCLASS) and (T2 = typeCLASS) and (S1 <> '') and (S2 <> '') and (S1 <> S2) then
            begin
              C1 := ClassList.FindClassByName(S1);
              C2 := ClassList.FindClassByName(S2);
              if (C1 <> nil) and (C2 <> nil) then
              begin
                DC1 := C1.DelphiClass;
                DC2 := C2.DelphiClass;
                if (DC1 <> nil) and (DC2 <> nil) then
                  if not DC2.InheritsFrom(DC1) then
                    goto Del;
              end;
            end;

            // choose the best method
          end;

          Continue;
     Del:
          Ids.Delete(J);
          Continue;
        end;

        if IDs.Count = 0 then
        begin
          Code.N := CallN;

          if SubCount = 0 then
            S := Format(errPropertyIsNotFound, [SymbolTable.Name[SubID]])
          else if SubCount = 1 then
          begin
            K := SymbolTable.Count[SubID];

            if NP < K then
            begin
              Dump();
              S := errNotEnoughParameters;
            end
            else if NP > K then
              S := errTooManyParameters
            else
              S := errIncompatibleTypes;
          end
          else
            S := Format(errOverloadedMethodNotFound, [SymbolTable.Name[SubID]]);

          CreateErrorObject(S, CallP);
          Exit;
        end
        else if IDs.Count >= 1 then
        begin
          SubID := Ids[0];

          if Ids.Count > 1 then
          begin
            for K := 1 to Ids.Count - 1 do
              if SymbolTable.Count[SubId] = SymbolTable.Count[Ids[K]] then
                IsOverloaded := true;
          end;

{          if MemberRec = nil then
            Code.Prog[CallN].Arg1 := SubID
          else if SymbolTable.Kind[Code.Prog[CallN].Arg1] = KindREF then
            Code.Prog[CallN].AltArg1 := SubID
          else if MemberRec.IsStatic then
            Code.Prog[CallN].Arg1 := SubID
          else }
          if SymbolTable.IsVirtual(SubId) and (not IsOverloaded) then
            Code.Prog[CallN].AltArg1 := 0
          else
          begin
            Code.Prog[CallN].AltArg1 := SubID;
          end;

          if MemberRec <> nil then
            with SymbolTable, Code.Prog[CallN] do
              if PType[Res] = typeVARIANT then
              begin
                PType[Res] := GetTypeID(SubId);
//                 PType[Res] := PType[Arg1];

                 if StrEql(SymbolTable.Name[SubID], 'Create') then
                   if Code.Prog[CallN + 1].Op = OP_ASSIGN then
                     if Code.Prog[CallN + 1].Arg2 = Res then
                     begin
                       declared := false;
                       for J:=1 to I do
                         if (Code.Prog[J].Op = OP_DECLARE) and (Code.Prog[J].Arg1 = Code.Prog[CallN + 1].Arg1) then
                         begin
                           declared := true;
                           break;
                         end;

//                       if not declared then
                         PType[Code.Prog[CallN + 1].Arg1] := PType[Arg1];
                     end;
              end
          else
          begin
            S := SymbolTable.Name[SubID];
            if StrEql(S, 'New') then
              with SymbolTable, Code.Prog[CallN] do
                if PType[Res] = typeVARIANT then
                begin
                   PType[Res] := PType[Arg1];
                end;
          end;
        end
        else
        begin
          Code.N := CallN;
          S := Format(errIdentifierIsRedeclared, [SymbolTable.Name[SubID]]);
          CreateErrorObject(S, CallP);
          Exit;
        end
      end;
    end;

  finally
    UsingList.Free;
    WithStack.Free;
    Ids.Free;
    Assoc1.Free;
    Assoc2.Free;
    Assoc3.Free;
    Assoc4.Free;
    Members.Free;
    Dump();
  end;
end;

procedure TPAXBaseScripter.CompileExtraCode;
var
  Parser: TPAXParser;
  S: String;
  ModuleName, LanguageName: String;
  I: Integer;
begin
  for I:=0 to ParserList.Count - 1 do
  begin
    LanguageName := ParserList[I].LanguageName;
    S := ExtraCodeList.GetCode(LanguageName);
    if S <> '' then
    begin
      Parser := ParserList.FindParser(LanguageName);
      Parser.SetScripter(Self);

      ModuleName := '###' + LanguageName;
      AddModule(ModuleName, LanguageName);
      AddCode(ModuleName, S);

      CompileModule(ModuleName, Parser);
    end;
  end;
end;

procedure TPAXBaseScripter.Link(reallocate: boolean);
begin
  if ExtraCodeList.Count > 0 then
    CompileExtraCode;

  SymbolTable.ReallocateMem(SymbolTable.MemBoundVar + fStackSize +
                           SymbolTable.GetSubCount * SymbolTable.MaxLocalVars *
                           _SizeVariant);

  Code.SaveOP;

  ClassList.CreateClassObjects(0);
  SymbolTable.AllocateSubroutines;
  SymbolTable.SetupSubs(1);

  State := _ssReadyToRun;
end;

procedure TPAXBaseScripter.Run(RunMode: Integer = _rmRun; DestLine: Integer = 0);
label
  Again;
begin

Again:

  if IsError then
    Exit;

  State := _ssRunning;

  if (Code.N = 0) and (RunList.Top = -1) then
  begin
    RunList.Pop;
    ClassList.InitStaticFields(0);
    Code.UsingList.Push(SymbolTable.RootNamespaceID);
    Code.N := RunList.Pop;

    Code.BreakPointList.InitCurrPassCounts;
  end;

  if not IsError then
  begin
    if (RunMode = _rmRun) and ((Code.BreakpointList.Count = 0) or IgnoreBreakpoints) then
      Code.DebugState := false;
    Code.Terminated := false;
    Code.Run(RunMode, DestLine);
    Code.DebugState := true;
  end;

  if IsError then
  begin
    if Assigned(fOnShowError) then
      fOnShowError(Owner)
    else
      ShowError;
  end;

  if Code.fTerminated then
  begin
    if not IsError then
    if RunList.Card > 0 then
    if RunList.Top <> -1 then
    begin
      Code.N := RunList.Pop;
      goto Again;
    end;

    State := _ssTerminated;
    Code.N := 0;
  end
  else
    State := _ssPaused;
end;

procedure TPAXBaseScripter.ShowError;
begin
  with ErrorInstance do
  ErrMessageBox(Format(errScript, [Description, ModuleName, LineNumber, Line]));
end;

function TPAXBaseScripter.GetProperty(const ScriptObject: Variant; PropertyName: String): Variant;
var
  SO: TPAXScriptObject;
begin
  SO := VariantToScriptObject(ScriptObject);
  result := SO.GetProperty(CreateNameIndex(PropertyName, Self), 0);
end;

procedure TPAXBaseScripter.Dump;
begin
  if not _IsDump then
    Exit;
  SymbolTable.Dump('SymbolTable.dmp');
  Code.Dump('Code.dmp');
  ClassList.Dump('ClassList.dmp');
  Modules.Dump('modules.dmp');
  DefinitionList.Dump('DefinitionList.dmp');
  UnresolvedTypes.SaveToFile('unresolved.dmp');
end;

procedure TPAXBaseScripter.DiscardError;
begin
  VarClear(Error);
end;

function TPAXBaseScripter.IsError: boolean;
begin
  result := not (VarType(Error) = varEmpty);
end;

function TPAXBaseScripter.AddBreakpoint(const ModuleName: String; SourceLineNumber: Integer;
                                        const Condition: String; PassCount: Integer): Boolean;
var
  PCodeLineNumber: Integer;
begin
  result := false;

  PCodeLineNumber := SourceLineToPCodeLine(ModuleName, SourceLineNumber);
  if PCodeLineNumber = -1 then
    Exit;

  if not Code.IsExecutableLine(PCodeLineNumber) then
    Exit;

  result := true;

  Code.BreakpointList.AddBreakpoint(PCodeLineNumber, Condition, PassCount);
end;

function TPAXBaseScripter.RemoveBreakpoint(const ModuleName: String; SourceLineNumber: Integer;
                                           const Condition: String; PassCount: Integer): Boolean;
var
  PCodeLineNumber: Integer;
begin
  result := false;

  PCodeLineNumber := SourceLineToPCodeLine(ModuleName, SourceLineNumber);
  if PCodeLineNumber = -1 then
    Exit;

  if not Code.IsExecutableLine(PCodeLineNumber) then
    Exit;

  result := Code.BreakpointList.RemoveBreakpoint(PCodeLineNumber);
end;

procedure TPAXBaseScripter.RemoveAllBreakpoints;
begin
  Code.BreakpointList.Clear;
end;

function TPAXBaseScripter.SourceLineToPCodeLine(const ModuleName: String; SourceLineNumber: Integer): Integer;
var
  I, ModuleID: Integer;
begin
  result := -1;

  ModuleID := Modules.IndexOf(ModuleName);
  if (ModuleID = -1) or (SourceLineNumber = 0) then
    Exit;

  for I:=1 to Code.Card do
    with Code.Prog[I] do
    if Op = OP_SEPARATOR then
      if ModuleID = Arg1 then
        if SourceLineNumber = Arg2 then
        begin
          result := I;
          Exit;
        end;
end;

function TPAXBaseScripter.GetName(NameIndex: Integer): String;
begin
  result := NameList[NameIndex];
end;

procedure TPAXBaseScripter.CreateErrorObject(const Message: String; PosNumber: Integer);
var
  ModuleID, LineID: Integer;
  Module: TPAXModule;
begin
  case fState of
    _ssCompiling:
      ErrorInstance.ScriptTime := 'Compile-time';
    _ssRunning:
      ErrorInstance.ScriptTime := 'Run-time';
  end;

  ModuleID := Code.ModuleID;
  LineID := Code.LineID;
  Module := Modules.Items[ModuleID];

  ErrorInstance.Description := Message;
  ErrorInstance.MethodId := Code.CurrMethodID;

  if Module <> nil then if EvalCount = 0 then
  begin
    ErrorInstance.ModuleName := Module.Name;
    if Module.FileName <> '' then
      ErrorInstance.FileName := Module.FileName;
    if LineID >= 0 then
    begin
      if LineID < Module.Count then
        ErrorInstance.Line := Module.Strings[LineID];
      ErrorInstance.LineNumber := LineID + 1;
      ErrorInstance.Position := PosNumber;
      ErrorInstance.TextPosition := Module.GetTextPos(LineID + 1, PosNumber);
    end;
  end;

  with SymbolTable do
    Error := LocalDefinitions.Records[0].DefValue;
end;

procedure TPaxBaseScripter.RunEx(ExtendedRun: Boolean);
var
  M: TMethod;
begin
  State := _ssRunning;
  M := OwnerEventHandlerMethod;
  if Assigned(M.Code) and ExtendedRun then
  begin
    State := _ssPaused;
    AllowedEvents := false;
    asm
      MOV  EAX,DWORD PTR M.Data;
      CALL M.Code;
    end;
  end
  else
    Code.Run;

  if IsError then
  begin
    if Assigned(fOnShowError) then
      fOnShowError(Owner)
    else
      ShowError;
  end;
end;

{$define THREADS}

function TPAXBaseScripter.CallMethod(SubID: Integer;
                                     const This: Variant;
                                     const P: array of const;
                                     IsEventHandler: Boolean = false): Variant;
var
  StartPos, I, ResultID, ParamID, TypeID, NP, Temp, K1, K2: Integer;
  PV: PVariant;
  S: String;
  ClassRec: TPaxClassRec;
  SO: TPaxScriptObject;
  V: Variant;
  _Upcase: Boolean;
begin
  if SubID > 0 then
    if SymbolTable.Kind[SubID] = KindTYPE then
      while SymbolTable.Kind[SubID] <> KindSUB do
        Inc(SubID);

  StartPos := Code.Card;
  NP := Length(P);

  Code.SaveState;
  SymbolTable.SaveState;

  ResultID := SymbolTable.GetResultID(SubID);
  if SubId < 0 then
    ResultId := SymbolTable.IDundefined;

  LastResultID := ResultID;

  for I:=0 to NP - 1 do
  begin
    PV := VariantStack.Push(Undefined);
    if P[I].VType = vtVariant then
    begin
      Code.Stack.Push(P[I].VVariant);
    end
    else if P[I].VType = vtInterface then
    begin
      Code.Stack.Push(InterfaceToScriptObject(IUnknown(P[I].VInterface), Self));
    end
    else if P[I].VType = vtPointer then
    begin
      ParamID := SymbolTable.GetParamID(SubID, I + 1);
      TypeID := SymbolTable.PType[ParamID];
      S := SymbolTable.Name[TypeID];
      ClassRec := ClassList.FindClassByName(S);
      if ClassRec <> nil then
      begin
        if ClassRec.ck = ckDynamicArray then
        begin
          SO := ClassRec.CreateScriptObject;
          SO.Instance := SO;
          SO.ExtraPtr := Pointer(P[I].VPointer);
          SO.ExternalExtraPtr := true;
          PV^ := ScriptObjectToVariant(SO);
          Code.Stack.Push(PV);
          SymbolTable.ByRef[ResultID] := 1;
        end
        else if ClassRec.ck = ckStructure then
        begin
          SO := ClassRec.CreateScriptObject;
          SO.FreeExtraPtr;
          SO.Instance := SO;
          SO.ExtraPtr := P[I].VPointer;
          SO.ExternalExtraPtr := true;
          PV^ := ScriptObjectToVariant(SO);
          Code.Stack.Push(PV);
          SymbolTable.ByRef[ResultID] := 1;
        end;
      end
      else
      begin
        Code.Stack.Push(P[I].VPointer);
        SymbolTable.ByRef[ResultID] := 1;
      end;
    end
    else
    begin
      PV^ := TVarRecToVariant(P[I], Self);
      Code.Stack.Push(PV);
    end;
  end;

  Code.N := StartPos;

  Temp := Code.Prog[StartPos].Vars;
  Code.Prog[StartPos].Vars := $FFFFFFF;

  Code.SignFOP := false;
  Code.Terminated := false;
  Code.CallSub(SubID, NP, @This, ResultID);
  Code.Add(OP_HALT, 0, 0, 0);
  Dec(Code.N);

  K1 := ScriptObjectList.Count;

  _Upcase := Code.Upcaseon;
  if not _Upcase then
    Code.UpcaseOn := Code.GetUpcase(Code.Card);

  Code.UsingList.Push(Code.GetLanguageNamespaceID);
  RunEx((Code.BreakpointList.Count > 0) and (IgnoreBreakpoints = false));
  Code.UsingList.Pop;

  Code.Upcaseon := _Upcase;

  K2 := ScriptObjectList.Count;

  result := SymbolTable.VariantValue[ResultID];

  {$IFDEF WIN32}
  {$IFDEF THREADS}
  if K1 <> K2 then
    ScriptObjectList.RemoveTail(K1, GetCurrentThreadID());
  {$ELSE}
  if K1 <> K2 then
    ScriptObjectList.RemoveTail(K1);
  {$ENDIF}
  {$ENDIF}

  fLastResult := result;
  Code.Prog[StartPos].Vars := Temp;

  if IsEventHandler then
  begin
    State := _ssRunning;
    if Code.N <> Code.Card then
      State := _ssPaused;
    Code.fTerminated := false;

    if Code.IsAborted then
      Code.fTerminated := true;
  end
  else if (Code.Prog[Code.N].Op = OP_HALT) and (Code.SubRunCount = 0) then
    State := _ssTerminated
  else if (Code.Prog[Code.N].Op = OP_HALT) and (Code.SubRunCount > 0) then
  begin
    SymbolTable.ClearVariant(ResultID);
    State := _ssRunning;
    for I := NP - 1 downto 0 do
      VariantStack.Pop;
    SymbolTable.RestoreState;
    Code.RestoreState;

    Exit;
  end
  else
    State := _ssPaused;

  if (Code.N = Code.Card) then
  if (State = _ssTerminated) or IsEventHandler then
  begin
    for I := NP - 1 downto 0 do
    begin
      if SubId > 0 then
      begin
        ParamID := SymbolTable.GetParamID(SubID, I + 1);
        if SymbolTable.ByRef[ParamID] > 0 then
        begin
          V := VariantStack.Top;

          if P[I].VType = vtVariant then
            V := P[I].VVariant^;
            
          SymbolTable.PutVariant(ParamID, V);
        end;
      end;
      VariantStack.Pop;
    end;
    SymbolTable.RestoreState;
    Code.RestoreState;
  end;

  if SubId < 0 then
    SymbolTable.ClearVariant(SymbolTable.IDundefined);
end;

function TPAXBaseScripter.CallMethodEx(SubID: Integer;
                                       const This: Variant;
                                       const P: array of const;
                                       const StrTypes: array of String;
                                       IsEventHandler: Boolean = false): Variant;
var
  StartPos, I, ResultID, ParamID, TypeID, NP, Temp, K1, K2: Integer;
  PV: PVariant;
  S: String;
  ClassRec: TPaxClassRec;
  SO: TPaxScriptObject;
begin
  if SubID > 0 then
    if SymbolTable.Kind[SubID] = KindTYPE then
      while SymbolTable.Kind[SubID] <> KindSUB do
        Inc(SubID);

  StartPos := Code.Card;
  NP := Length(P);

  Code.SaveState;
  SymbolTable.SaveState;

  ResultID := SymbolTable.GetResultID(SubID);
  LastResultID := ResultID;

  for I:=0 to NP - 1 do
  begin
    PV := VariantStack.Push(Undefined);
    if P[I].VType = vtVariant then
    begin
      Code.Stack.Push(P[I].VVariant);
    end
    else if P[I].VType = vtInterface then
    begin
      SO := InterfaceToScriptObject(IUnknown(P[I].VInterface), Self, StrTypes[I]);
      PV^ := ScriptObjectToVariant(SO);
      Code.Stack.Push(PV);
    end
    else if P[I].VType = vtPointer then
    begin
      ParamID := SymbolTable.GetParamID(SubID, I + 1);
      TypeID := SymbolTable.PType[ParamID];
      S := SymbolTable.Name[TypeID];
      ClassRec := ClassList.FindClassByName(S);
      if ClassRec <> nil then
      begin
        if ClassRec.ck = ckDynamicArray then
        begin
          SO := ClassRec.CreateScriptObject;
          SO.Instance := SO;
          SO.ExtraPtr := Pointer(P[I].VPointer);
          SO.ExternalExtraPtr := true;
          PV^ := ScriptObjectToVariant(SO);
          Code.Stack.Push(PV);
          SymbolTable.ByRef[ResultID] := 1;
        end
        else if ClassRec.ck = ckStructure then
        begin
          SO := ClassRec.CreateScriptObject;
          SO.FreeExtraPtr;
          SO.Instance := SO;
          SO.ExtraPtr := P[I].VPointer;
          SO.ExternalExtraPtr := true;
          PV^ := ScriptObjectToVariant(SO);
          Code.Stack.Push(PV);
          SymbolTable.ByRef[ResultID] := 1;
        end;
      end
      else
      begin
        Code.Stack.Push(P[I].VPointer);
        SymbolTable.ByRef[ResultID] := 1;
      end;
    end
    else
    begin
      PV^ := TVarRecToVariant(P[I], Self);
      Code.Stack.Push(PV);
    end;
  end;

  Code.N := StartPos;

  Temp := Code.Prog[StartPos].Vars;
  Code.Prog[StartPos].Vars := $FFFFFFF;

  Code.SignFOP := false;
  Code.Terminated := false;
  Code.CallSub(SubID, NP, @This, ResultID);
  Code.Add(OP_HALT, 0, 0, 0);
  Dec(Code.N);

  K1 := ScriptObjectList.Count;

  Code.UsingList.Push(Code.GetLanguageNamespaceID);
  RunEx(Code.BreakpointList.Count > 0);
  Code.UsingList.Pop;

  K2 := ScriptObjectList.Count;

  result := SymbolTable.VariantValue[ResultID];

  {$IFDEF WIN32}
  if K1 <> K2 then
    ScriptObjectList.RemoveTail(K1, GetCurrentThreadID());
  {$ELSE}
  if K1 <> K2 then
    ScriptObjectList.RemoveTail(K1);
  {$ENDIF}

  fLastResult := result;
  Code.Prog[StartPos].Vars := Temp;

  if IsEventHandler then
  begin
    State := _ssRunning;
    if Code.N <> Code.Card then
      State := _ssPaused;
    Code.fTerminated := false;
  end
  else if (Code.Prog[Code.N].Op = OP_HALT) and (Code.SubRunCount = 0) then
    State := _ssTerminated
  else if (Code.Prog[Code.N].Op = OP_HALT) and (Code.SubRunCount > 0) then
  begin
    SymbolTable.ClearVariant(ResultID);
    State := _ssRunning;
    for I := NP - 1 downto 0 do
      VariantStack.Pop;
    SymbolTable.RestoreState;
    Code.RestoreState;

    Exit;
  end
  else
    State := _ssPaused;

  if (Code.N = Code.Card) then
  if (State = _ssTerminated) or IsEventHandler then
  begin
    for I := NP - 1 downto 0 do
    begin
      ParamID := SymbolTable.GetParamID(SubID, I + 1);
      if SymbolTable.ByRef[ParamID] > 0 then
        SymbolTable.PutVariant(ParamID, VariantStack.Top);
      VariantStack.Pop;
    end;
    SymbolTable.RestoreState;
    Code.RestoreState;
  end;
end;

function TPAXBaseScripter.AssignedObject(SO: TPAXScriptObject): Boolean;
begin
  result := ScriptObjectList.HasObject(SO);
end;

procedure TPAXBaseScripter.SaveCompiledModuleToStream(M: TPaxModule; S: TStream);
var
  I, N, Temp, PosExtra, ToWrite: Integer;
  InitList: TPaxIds;

  ModuleSizePos, ModuleSize: Integer;
begin
  ModuleSizePos := S.Position;
  SaveInteger(0, S); // module size
  SaveInteger(_CompiledModuleVersion, S);
  Temp := S.Position;
  SaveInteger(0, S);  // position of extra data
  M._SaveToStream(S);

  PosExtra := S.Position;

  S.Position := Temp;
  if Assigned(OnWriteExtraData) then
    ToWrite := PosExtra
  else
    ToWrite := 0;
  SaveInteger(ToWrite, S); // position of extra data
  S.Position := PosExtra;

  if Assigned(OnWriteExtraData) then
    OnWriteExtraData(Owner, S, M.Name);

  Code.SaveToStream(S, M.P1, M.P2);
  SymbolTable.SaveToStream(S, M.S1, M.S2);

  InitList := TPaxIds.Create(false);
  for I:=0 to ClassList[0].UsingInitList.Count - 1 do
  begin
    N := ClassList[0].UsingInitList[I];
    if (N >= M.P1) and (N <= M.P2) then
      InitList.Add(N);
  end;
  InitList.SaveToStream(S);
  DefaultParameterList.SaveToStream(S);

  Temp := S.Position;
  ModuleSize := S.Position - ModuleSizePos;
  S.Position := ModuleSizePos;
  SaveInteger(ModuleSize, S);
  S.Position := Temp;

  InitList.Free;
end;

procedure TPAXBaseScripter.LoadCompiledModuleFromStream(M: TPaxModule; S: TStream);
var
  DS, DP, I, N, TempPos, Version: Integer;
  InitList: TPaxIds;
  ModuleSize, ModuleSizePos: Integer;
begin
  if M.BuffStream <> S then
  begin
    ModuleSizePos := S.Position;

    M.BuffStream.Position := 0;
    TempPos := S.Position;
    M.BuffStream.CopyFrom(S, S.Size - S.Position);
    S.Position := TempPos;
    ModuleSize := LoadInteger(S);
    LoadInteger(S); // compiled module version
    LoadInteger(S); // position of extra data
    M._LoadFromStream(S);

    S.Position := ModuleSizePos + ModuleSize;
    Exit;
  end;

  LoadInteger(S); // module size
  Version := LoadInteger(S); // version
  if Version <> _CompiledModuleVersion then
    raise TPaxScriptFailure.Create(Format(errIncorrectCompiledModuleVersion,
        [Version, _CompiledModuleVersion]));

  LoadInteger(S); // position of extra data
  M.Clear();
  M._LoadFromStream(S);

  if Assigned(OnReadExtraData) then
  begin
    OnReadExtraData(Owner, S, M.Name);
  end;

  DS := SymbolTable.Card - M.S1 + 1;
  DP := Code.Card - M.P1 + 1;

  Code.LoadFromStream(S, DS, DP);
  SymbolTable.LoadFromStream(S, DS, DP);

  if DS <> 0 then
    with M do
    for I:=0 to Namespaces.Count - 1 do
      Namespaces[I] := Namespaces[I] + DS;

  InitList := TPaxIds.Create(false);
  InitList.LoadFromStream(S);
  for I:=0 to InitList.Count - 1 do
  begin
    N := InitList[I] + DP;
    ClassList[0].UsingInitList.Add(N);
  end;

  InitList.Free;

  DefaultParameterList.LoadFromStream(S);
  for I:=0 to DefaultParameterList.Count - 1 do
    Inc(DefaultParameterList[I].ID, DS);

  Inc(M.S1, DS);
  Inc(M.S2, DS);
  Inc(M.P1, DP);
  Inc(M.P2, DP);
end;

procedure TPAXBaseScripter.SaveToStream(S: TStream);
var
  I: Integer;
  M: TPaxModule;
begin
  SaveInteger(Modules.Count, S);
  for I:=0 to Modules.Count - 1 do
  begin
    M := Modules.Items[I];
    SaveCompiledModuleToStream(M, S);
  end;
//  ClassList[0].UsingInitList.SaveToStream(S);
end;

procedure TPAXBaseScripter.LoadFromStream(S: TStream);
var
  I, K: Integer;
  M: TPaxModule;
begin
  K := LoadInteger(S);
  for I:=0 to K - 1 do
  begin
    M := TPaxModule.Create(Self);
    LoadCompiledModuleFromStream(M, S);
    Modules.AddObject(M.Name, M);
  end;
end;

procedure TPAXBaseScripter.DisconnectObjects;
begin
  EventHandlerList.ClearHandlers;
  RegisteredFieldList.Clear;
end;

procedure TPAXBaseScripter.AddExtraModule(const ModuleName, SourceCode: String;
                                          SyntaxCheckOnly: Boolean; const PaxLanguage: String);
var
  I, P: Integer;
  Found: Boolean;
  M: TPaxModule;
  S, FileName: String;
  ClassRec: TPaxClassRec;

  DelphiUnitName, DelphiDfmName, Script: String;
begin
  if SourceCode <> '' then
  begin
    for I:=0 to ExtraModuleList.Count - 1 do
    begin
      S := ExtraModuleList[I];
      P := Pos('=', S);
      if P > 0 then
        S := Copy(S, 1, P - 1);
      if StrEql(ModuleName, S) then
        Exit;
    end;

    for I:=0 to Modules.Count - 1 do
    begin
      M := Modules.Items[I];
      if StrEql(M.Name, ModuleName) then
      begin
        M.Text := SourceCode;
        Exit;
      end;
    end;

    ExtraModuleList.Add(ModuleName + '=' + SourceCode);

    Exit;
  end;

  FileName := FindFullName(ModuleName);

  if FileName <> '' then
  begin
    Found := false;

    for I:=0 to ExtraModuleList.Count - 1 do
      if StrEql(ModuleName, ExtraModuleList[I]) then
      begin
        Found := true;
        Break;
      end;

    for I:=0 to Modules.Count - 1 do
    begin
      M := Modules.Items[I];
      if StrEql(M.Name, ModuleName) then
      begin
        Found := true;
        Break;
      end;
    end;

    if not Found then
      ExtraModuleList.Add(ModuleName);
  end
  else
  begin
    S := ModuleName;
    if Pos('.', S) > 0 then
      S := Copy(S, 1, Pos('.', S) - 1);

    DelphiUnitName := FindFullName(S + '.pas');
    DelphiDfmName := FindFullName(S + '.dfm');

    if DelphiDfmName <> '' then
    begin
      if DelphiUnitName <> '' then
      begin
        Script := ConvertDelphiForm1(DelphiDfmName, DelphiUnitName, PaxLanguage);
        ExtraModuleList.Add(S + '=' + Script);
        Exit;
      end;
    end;

    ClassRec := ClassList.FindClassByName(S);
    if ClassRec = nil then
      if not SyntaxCheckOnly then
        raise TPaxScriptFailure.Create(Format(errFileNotFound, [ModuleName]));
  end;
end;

function TPaxBaseScripter.FindFullName(const FileName: String): String;

function FindFullNameBase(const FileName: String; UsePathes: Boolean): String;

function RemoveLastDelimeter(const S: String): String;
var
  I: Integer;
begin
  result := S;
  for I:=Length(S) downto 1 do
    if S[I] = PathDelim then
    begin
      result := Copy(S, 1, I - 1);
      Exit;
    end;
end;

var
  I: Integer;
  S, FName: String;
begin
  result := '';

  if Pos(PathDelim, FileName) = 1 then
  begin
    S := GetCurrentDir + FileName;
    if FileExists(S) then
    begin
      result := S;
      Exit;
    end;
    Exit;
  end;

  if Pos('..' + PathDelim, FileName) = 1 then
  begin
    S := GetCurrentDir;
    FName := FileName;

    while Pos('..' + PathDelim, FName) = 1 do
    begin
      S := RemoveLastDelimeter(S);
      FName := Copy(FName, 3, Length(FName) - 2);
    end;

    S := S + FName;

    if FileExists(S) then
    begin
      result := S;
      Exit;
    end;
    Exit;
  end;

  if FileExists(FileName) then
  begin
    result := FileName;
    Exit;
  end;

  if not UsePathes then Exit;

  for I:=0 to fSearchPathes.Count - 1 do
  begin
    S := fSearchPathes[I] + FileName;
    result := FindFullNameBase(S, false);
    if result <> '' then
      Exit;
  end;
end;

begin
  result := FindFullNameBase(FileName, true);
end;

function TPaxBaseScripter.IsCompiledScript(const FileName: String): Boolean;
var
  S: TFileStream;
  I: Integer;
  FullName: String;
begin
  FullName := FindFullName(FileName);

  if FullName = '' then
  begin
    result := false;
    Exit;
  end;

  S := TFileStream.Create(FullName, fmOpenRead);
  try
    I := LoadInteger(S);
    result := I < 32;
  finally
    S.Free;
  end;
end;

procedure TPaxBaseScripter.CreateRunList;
var
  I: Integer;
begin
  RunList.Clear;
  for I:=0 to Code.FinalizationList.Count - 1 do
    RunList.Push(Code.FinalizationList[I]);
  RunList.Push(0);
  for I:=0 to Code.InitializationList.Count - 1 do
    RunList.Push(Code.InitializationList[I]);
  RunList.Push(-1);
end;

function TPaxBaseScripter.ConvertDelphiForm1(const DfmFileName, UnitFileName, PaxLanguage: String): String;
var
  L, Src, UsedUnits: TStringList;
  I, J: Integer;
  S: String;
  P: TPascalParser;
begin
  L := TStringList.Create;
  Src := TStringList.Create;
  UsedUnits := TStringList.Create;

  try
    if UnitFileName <> '' then
      Src.LoadFromFile(UnitFileName);

    for I:=0 to Src.Count - 1 do
      if Pos('USES', UpperCase(Src[I])) = 1 then
      begin
        S := '';
        for J := I to Src.Count - 1 do
          S := S + Src[J];
        P := TPascalParser.Create;
        P. Scanner.SourceCode := S;
        P.Call_SCANNER;
        P.ParseUsesClause(UsedUnits);

        break;
      end;
    for J:=UsedUnits.Count - 1 downto 0 do
    begin
      S := UsedUnits[J];
      if DefinitionList.FindClassDefByName(S) = nil then
        UsedUnits.Delete(J); // not registered
    end;

    if UnitFileName <> '' then
      ConvertDfmFile(DfmFileName, UsedUnits, L, true, Src, PaxLanguage)
    else
      ConvertDfmFile(DfmFileName, UsedUnits, L, true, nil, PaxLanguage);
    result := L.Text;
  finally
    L.Free;
    Src.Free;
    UsedUnits.Free;
  end;
end;

function TPaxBaseScripter.ConvertDelphiForm2(const DfmFileName: String; UsedUnits: TStringList;
                                             const PaxLanguage: String): String;
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    ConvertDfmFile(DfmFileName, UsedUnits, L, true, nil, PaxLanguage);
    result := L.Text;
  finally
    L.Free;
  end;
end;

procedure TPaxBaseScripter.AddDelphiForm(const DfmFileName, UnitFileName, PaxLanguage: String);
var
  ModuleName: String;
  I: Integer;
begin
  ModuleName := ExtractFileName(DfmFileName);
  I := Pos('.', ModuleName);
  if I > 0 then
    ModuleName := Copy(ModuleName, 1, I - 1);

  AddModule(ModuleName, PaxLanguage);
  AddCode(ModuleName, ConvertDelphiForm1(DfmFileName, UnitFileName, PaxLanguage));

  State := _ssReadyToCompile;
end;

function TPaxBaseScripter.GetTypeID(ID: Integer): Integer;
var
  D: TPaxDefinition;
  S: String;
  C: TPaxClassRec;
begin
  if (ID > 0) and (ID <= SymbolTable.Card) then
  begin
    if ID <= PaxTypes.Count then
      result := ID
    else
      result := SymbolTable.PType[ID];
  end
  else
  begin
    D := DefinitionList[-ID];
    case D.DefKind of
      dkVariable: result := TPaxVariableDefinition(D).TypeID;
      dkConstant: result := TPaxConstantDefinition(D).TypeID;
      dkMethod:
      begin
        S := TPaxMethodDefinition(D).ResultType;
        result := PaxTypes.GetTypeID(S);
        if result = - 1 then
        begin
          C := ClassList.FindClassByName(S);
          if C <> nil then
            result := C.ClassID
          else
            result := typeVARIANT;
        end;
      end;
    else
      result := 0;
    end;
  end;
end;

function TPaxBaseScripter.HasForbiddenPublishedProperty(C: TClass; const PropName: String): Boolean;
var
  I: Integer;
  AClass: TClass;
begin
  result := ForbiddenPublishedProperties.IndexOf(C) >= 0;

  if not result then
  begin
    for I:=0 to ForbiddenPublishedPropertiesEx.Count - 1 do
    begin
      AClass := TClass(ForbiddenPublishedPropertiesEx.Objects[I]);
      if AClass = C then
        if StrEql(PropName, ForbiddenPublishedPropertiesEx[I]) then
        begin
          result := true;
          Exit;
        end;
    end;
  end;
end;

function _Eval(const SourceCode: String;
              Scripter: TPAXBaseScripter;
              Parser: TPAXParser): Variant;

procedure _CopyLevelStack;
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

    _CopyLevelStack;

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

initialization
  DllList := TPaxDllList.Create;
  ScripterList := TList.Create;

  Initialization_BASE_SYS;
  Initialization_BASE_EXTERN;
  Initialization_BASE_REGEXP;

finalization
  Finalization_BASE_EXTERN;
  Finalization_BASE_SYS;

  ScripterList.Free;
  DllList.Free;
end.
