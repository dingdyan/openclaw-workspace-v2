///////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: PaxScripter.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit PaxScripter;

interface

uses
{$IFDEF VARIANTS}
  Variants,
{$ENDIF}

{$IFDEF WIN32}
  Windows,
{$ENDIF}
  SysUtils,
  TypInfo,
  Classes,
//  ComCtrls,
{$ifdef obsolete}
  Forms,
{$endif}

{$ifdef FP}
  dynlibs,
{$ENDIF}

  BASE_CONSTS,
  BASE_SYS,
  BASE_SYNC,
  BASE_CODE,
  BASE_PARSER,
  BASE_CLASS,
  BASE_SCRIPTER,
  BASE_CALL,
  BASE_EXTERN,
  BASE_EVENT,
  BASE_REGEXP,
  PaxImport;
const
  rmRun = 0;
  rmStepOver = 1;
  rmTraceInto = 2;
  rmRunToCursor = 3;
  rmTraceToNextSourceLine = 4;

  paxVersion: Double = 3.0;
  paxBuild = '';
  paxCompiledModuleVersion: Integer = BASE_SYS._CompiledModuleVersion;
  MaxModuleNumber = 255;
type
  TScripterState =
  (
  ssInit, // scripter is not assigned by a script
  ssReadyToCompile, // scripter is assigned by a script and ready to compile it.
  ssCompiling, // compiles script
  ssCompiled, // all modules were compiled
  ssLinking, // links modules in a script
  ssReadyToRun, // script was linked and it is ready to run now
  ssRunning, // runs script
  ssPaused, // script was paused
  ssTerminated // script was terminated
  );

  TPaxScripter = class;
  TPaxLanguage = class;

  TCallStackRecord = class
  public
    ModuleName: String;
    LineNumber: Integer;
    ProcName: String;
    Parameters: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

  TCallStack = class
  private
    fScripter: TPAXBaseScripter;
    fRecords: TList;
    function GetCount: Integer;
    function GetRecord(Index: Integer): TCallStackRecord;
    procedure Clear;
    constructor Create(PaxScripter: TPaxScripter);
    procedure Add(R: TCallStackRecord);
  public
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Records[I: Integer]: TCallStackRecord read GetRecord;
  end;

  TPaxScripterEvent = procedure (Sender: TPaxScripter) of object;
  TPaxCompilerProgressEvent = procedure(Sender: TPaxScripter; ModuleNumber: Integer) of object;
  TPaxScripterPrintEvent = procedure (Sender: TPaxScripter;
                                      const S: String) of object;
  TPaxScripterDefineEvent = procedure (Sender: TPaxScripter;
                                       const S: String) of object;
  TPaxScripterReadEvent = procedure (Sender: TPaxScripter;
                                     var S: String) of object;

  TPaxScripterVarEvent = procedure (Sender: TPaxScripter; ID: Integer) of object;
  TPaxScripterVarEventEx = procedure (Sender: TPaxScripter; ID: Integer; var Mode: Integer) of object;

  TPaxCodeEvent = procedure(Sender: TPaxScripter;
                            N: Integer;
                            var Handled: Boolean) of object;

  TPaxUsedModuleEvent = procedure(Sender: TPaxScripter; const UsedModuleName, FileName: String;
                                  var SourceCode: String) of object;

  TPaxIncludeEvent = procedure(Sender: TObject; const IncludedFileName: String;
                            var SourceCode: String) of object;

  TPaxLoadSourceCodeEvent = procedure(Sender: TPaxScripter; const UsedModuleName, FileName: String;
                                      var SourceCode: String) of object;

  TPaxScanPropertiesEvent = procedure(Sender: TPaxScripter; const PropName: String;
                                       var Value: Variant) of object;

  TPAXMemberKind = (mkUnknown, mkConst, mkField, mkProp, mkParam, mkResult,
                    mkMethod, mkClass, mkStructure, mkEnum, mkNamespace, mkEvent);

  TPAXCallConv = (ccRegister, ccPascal, ccCDecl, ccStdCall, ccSafeCall);

  TPaxMemberCallback = procedure (const Name: String;
                                  ID: Integer;
                                  Kind: TPAXMemberKind;
                                  ml: TPAXModifierList;
                                  Data: Pointer) of object;

  TPaxInstruction = record
    N, Op, Arg1, Arg2, Res: Integer;
  end;

  PPaxTreeNodeData = ^TPaxTreeNodeData;
  TPaxTreeNodeData = record
    Value: Variant;
    Modified: Boolean;
    ID: Integer;
    Prop: TPaxProperty;
  end;

  TPaxScripterStreamEvent = procedure(Sender: TPaxScripter; Stream: TStream;
                            const ModuleName: String) of object;

  TPaxScripterChangeStateEvent = procedure(Sender: TPaxScripter; OldState, NewState: Integer) of object;

  TPaxScripterInstanceEvent = procedure(Sender: TPaxScripter; Instance: TObject) of object;

  TPaxLoadDllEvent = procedure(Sender: TPaxScripter; const DllName, ProcName: String;
                         var Address: Pointer) of object;

  TPaxVarArray = array of Variant;

  TPaxVirtualObjectMethodCallEvent = function(Sender: TPaxScripter; const ObjectName,
      PropName: String; const Params: TPaxVarArray): Variant of object;

  TPaxVirtualObjectPutPropertyEvent = procedure(Sender: TPaxScripter; const ObjectName,
      PropName: String; const Params: TPaxVarArray; const Value: Variant) of object;

  TPaxOverrideHandlerMode = (Replace, Before, After);

  TPaxScripter = class(TComponent)
  private
    fCallStack: TCallStack;
    fSearchPathes: TStrings;

    fOnAssignScript,
    fOnAfterCompileStage,
    fOnAfterRunStage,
    fOnBeforeCompileStage,
    fOnBeforeRunStage,
    fOnHalt: TPaxScripterEvent;
    fOnScanProperties: TPaxScanPropertiesEvent;

    function GetModules: TStringList;

    function GetScripterState: TScripterState;
    procedure SetScripterState(Value: TScripterState);

    function GetOverrideHandlerMode: TPaxOverrideHandlerMode;
    procedure SetOverrideHandlerMode(Value: TPaxOverrideHandlerMode);

    procedure ExtractCallStack;
    function GetSourceCode(const ModuleName: String): String;
    procedure SetSourceCode(const ModuleName, SourceCode: String);
    function GetOnCompilerProgress: TPaxCompilerProgressEvent;
    procedure SetOnCompilerProgress(Value: TPaxCompilerProgressEvent);
    function GetOnPrint: TPaxScripterPrintEvent;
    procedure SetOnPrint(Value: TPaxScripterPrintEvent);
    function GetOnDefine: TPaxScripterDefineEvent;
    procedure SetOnDefine(Value: TPaxScripterDefineEvent);
    function GetOnChangedVariable: TPaxScripterVarEvent;
    procedure SetOnChangedVariable(Value: TPaxScripterVarEvent);
    function GetOnRunning: TPaxCodeEvent;
    procedure SetOnRunning(Value: TPaxCodeEvent);
    function GetOnInclude: TPaxIncludeEvent;
    procedure SetOnInclude(Value: TPaxIncludeEvent);
    function GetOnHalt: TPaxScripterEvent;
    procedure SetOnHalt(Value: TPaxScripterEvent);

    function GetOnLoadDll: TPaxLoadDllEvent;
    procedure SetOnLoadDll(Value: TPaxLoadDllEvent);

    function GetOnVirtualObjectMethodCallEvent: TPaxVirtualObjectMethodCallEvent;
    procedure SetOnVirtualObjectMethodCallEvent(Value: TPaxVirtualObjectMethodCallEvent);

    function GetOnVirtualObjectPutPropertyEvent: TPaxVirtualObjectPutPropertyEvent;
    procedure SetOnVirtualObjectPutPropertyEvent(Value: TPaxVirtualObjectPutPropertyEvent);

{$IFDEF ONRUNNING}
    // See BASE_SCRIPTER.pas for details.
    function GetOnRunningUpdate: TPaxScripterEvent;
    procedure SetOnRunningUpdate(Value: TPaxScripterEvent);
    function GetOnRunningUpdateActive: Boolean;
    procedure SetOnRunningUpdateActive(Value: Boolean);
    function GetOnRunningSync: TPaxScripterEvent;
    procedure SetOnRunningSync(Value: TPaxScripterEvent);
{$ENDIF}

{$IFDEF UNDECLARED_EX}
    function GetOnUndeclaredIdentifier: TPaxScripterVarEventEx;
    procedure SetOnUndeclaredIdentifier(Value: TPaxScripterVarEventEx);
{$ELSE}
    function GetOnUndeclaredIdentifier: TPaxScripterVarEvent;
    procedure SetOnUndeclaredIdentifier(Value: TPaxScripterVarEvent);
{$ENDIF}

    function GetOnReadExtraData: TPaxScripterStreamEvent;
    procedure SetOnReadExtraData(Value: TPaxScripterStreamEvent);
    function GetOnWriteExtraData: TPaxScripterStreamEvent;
    procedure SetOnWriteExtraData(Value: TPaxScripterStreamEvent);
    function GetOnUsedModule: TPaxUsedModuleEvent;
    procedure SetOnUsedModule(Value: TPaxUsedModuleEvent);
    function GetOnLoadSourceCode: TPaxLoadSourceCodeEvent;
    procedure SetOnLoadSourceCode(Value: TPaxLoadSourceCodeEvent);
    function GetOnChangeState: TPaxScripterChangeStateEvent;
    procedure SetOnChangeState(Value: TPaxScripterChangeStateEvent);

    function GetOnDelphiInstanceCreate: TPaxScripterInstanceEvent;
    procedure SetOnDelphiInstanceCreate(Value: TPaxScripterInstanceEvent);
    function GetOnDelphiInstanceDestroy: TPaxScripterInstanceEvent;
    procedure SetOnDelphiInstanceDestroy(Value: TPaxScripterInstanceEvent);


    function GetTotalLineCount: Integer;
    function GetErrorClassType: TClass;
    function GetErrorDescription: String;
    function GetErrorModuleName: String;
    function GetErrorTextPos: Integer;
    function GetErrorPos: Integer;
    function GetErrorLine: Integer;
    function GetErrorMethodId: Integer;
    procedure InvokeOnAssignScript;
    function GetCurrentSourceLine: Integer;
    function GetCurrentModuleName: String;
    procedure RegisterLanguages;
    procedure UnregisterLanguages;
    procedure SetStackSize(Value: Integer);
    function GetStackSize: Integer;
    procedure SetOptimization(Value: Boolean);
    function GetOptimization: Boolean;
    function GetLanguage(I: Integer): TPaxLanguage;
    procedure SetSearchPathes(const Value: TStrings);
    procedure Unregister(What: TPAXDefKind; const Name: String; Owner: Integer = -1);
  protected
    function GetParam(const ParamName: String): Variant; virtual;
    procedure SetParam(const ParamName: String; const Value: Variant); virtual;
    function GetValue(const Name: String): Variant; virtual;
    procedure SetValue(const Name: String; const Value: Variant); virtual;
    function RegisterParser(ParserClass: TPAXParserClass; const LanguageName, FileExt: String;
                            CallConvention: TPAXCallConv): Integer;
    procedure SetUpSearchPathes; virtual;
  public
    fScripter: TPAXBaseScripter;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FindTempObject(const Key: TVarRec): TObject;
    function AddTempObject(const Key: TVarRec; Obj: TObject): Integer;
    function AddModule(const ModuleName, LanguageName: String): Integer;
    procedure AddCode(const ModuleName, Code: String);
    procedure AddCodeLine(const ModuleName, Code: String);
    procedure AddCodeFromFile(const ModuleName, FileName: String);
    procedure AddDelphiForm(const DfmFileName, UnitFileName: String;
                            const PaxLanguage: String = 'paxPascal'); overload;
    procedure AddDelphiForm(const DfmFileName: String; UsedUnits: TStringList;
                                const PaxLanguage: String = 'paxPascal'); overload;
    procedure AddDelphiForm(const ModuleName: String; Dfm, Source: TStream;
                            const PaxLanguage: String = 'paxPascal'); overload;
    procedure LoadProject(const FileName: String);
    function CompileModule(const ModuleName: String;
                            SyntaxCheckOnly: Boolean = false): Boolean;
    function Compile(SyntaxCheckOnly: Boolean = false): Boolean;
    procedure Run(RunMode: Integer = rmRun; const ModuleName: String = ''; LineNumber: Integer = 0);
    procedure RunInstruction;
    function InstructionCount: Integer;
    function CurrentInstructionNumber: Integer;
    function GetInstruction(N: Integer): TPaxInstruction;
    procedure SetInstruction(N: Integer; I: TPaxInstruction);
    function Eval(const Expression, LanguageName: String; var Res: Variant): Boolean;
    function EvalStatementList(const Expression, LanguageName: String): Boolean;
    function EvalJS(const Expression: String): Boolean;
    function CallFunction(const Name: String; const Params: array of const;
                          AnObjectName: String = ''): Variant;
    function CallFunctionEx(const Name: String;
                            const Params: array of const;
                            const StrTypes: array of String;
                            AnObjectName: String = ''): Variant;
    function CallFunctionByID(SubID: Integer; const Params: array of const;
                              ObjectID: Integer = 0): Variant;
    function CallFunctionByIDEx(SubID: Integer; const Params: array of const;
                                const StrTypes: array of String;
                                ObjectID: Integer = 0): Variant;
    function CallMethod(const Name: String; const Params: array of const; Instance: TObject): Variant; overload;
    function CallMethod(const Name: String; const Params: array of const; const This: Variant): Variant; overload;
    function CallMethodByID(SubID: Integer;
                           const Params: array of const; Instance: TObject): Variant; overload;
    function CallMethodByID(SubID: Integer;
                            const Params: array of const; const This: Variant): Variant; overload;
    function GetLastResult: Variant;
    procedure CancelCompiling(const AMessage: String);
    procedure Dump;
    procedure RemoveAllBreakpoints;
    function AddBreakpoint(const ModuleName: String;
                           LineNumber: Integer; const Condition: String = ''; PassCount: Integer = 0): Boolean;
    function RemoveBreakpoint(const ModuleName: String; LineNumber: Integer): Boolean;
    procedure RegisterConstant(const Name: String; Value: Variant; Owner: Integer = -1);
    procedure RegisterVariable(const Name, TypeName: String; Address: Pointer; Owner: Integer = -1);
    procedure RegisterObject(const Name: String; Instance: TObject; Owner: Integer = -1);
    procedure RegisterVirtualObject(const Name: String; Owner: Integer = -1);
    procedure RegisterObjectSimple(const Name: String; Instance: TObject; Owner: Integer = -1);
    procedure RegisterInterfaceVar(const Name: String; PIntf: PUnknown;
                                   const guid: TGUID;
                                   Owner: Integer = -1);
    procedure UnregisterConstant(const Name: String; Owner: Integer = -1);
    procedure UnregisterVariable(const Name: String; Owner: Integer = -1);
    procedure UnregisterObject(const Name: String; Owner: Integer = -1); overload;
    procedure UnregisterObject(Instance: TObject; Owner: Integer = -1); overload;
    procedure UnregisterAllVariables;
    procedure UnregisterAllObjects;
    procedure UnregisterAllConstants;

    procedure ForbidAllPublishedProperties(AClass: TClass);
    procedure ForbidPublishedProperty(AClass: TClass; const PropName: String);

    procedure RegisterField(const ObjectName: String;
                            ObjectType: String;
                            FieldName: String;
                            FieldType: String;
                            Address: Pointer);
    function ToString(const V: Variant): String;

    procedure ResetScripter;
    procedure ResetScripterEx;
    procedure Terminate;
    procedure DisconnectObjects;

    function IsError: Boolean;
    procedure DiscardError;

    function GetMemberID(const Name: String): Integer;
    function GetParamID(SubID, ParamIndex: Integer): Integer;
    function GetResultID(SubID: Integer): Integer;
    function GetParamCount(SubID: Integer): Integer;
    function GetTypeName(ID: Integer): String;
    function GetParamTypeName(SubID, ParamIndex: Integer): String;
    function GetSignature(SubID: Integer): String;
    function GetParamName(SubID, ParamIndex: Integer): String;
    function GetTypeID(ID: Integer): Integer;
    function GetName(ID: Integer): String;
    function GetFullName(ID: Integer): String;
    function GetPosition(ID: Integer): Integer;
    function GetStartPosition(ID: Integer): Integer;
    function GetModule(ID: Integer): Integer;
    function GetAddress(ID: Integer): Pointer;
    function GetUserData(ID: Integer): Integer;
    function IsLocalVariable(ID: Integer): Boolean;
    function GetOwnerID(ID: Integer): Integer;
    function GetKind(ID: Integer): TPAXMemberKind;
    function GetCurrentProcID: Integer;
    function IsStatic(ID: Integer): Boolean;
    function IsConstructor(ID: Integer): Boolean;
    function IsDestructor(ID: Integer): Boolean;
    function IsVarParameter(ID: Integer): Boolean;
    function IsConstParameter(ID: Integer): Boolean;
    function IDCount: Integer;
    function IsMethod(ID: Integer): Boolean;

    function GetOnShowError: TPaxScripterEvent;
    procedure SetOnShowError(Value: TPaxScripterEvent);

    property ErrorClassType: TClass read GetErrorClassType;
    property ErrorDescription: String read GetErrorDescription;
    property ErrorModuleName: String read GetErrorModuleName;
    property ErrorTextPos: Integer read GetErrorTextPos;
    property ErrorPos: Integer read GetErrorPos;
    property ErrorLine: Integer read GetErrorLine;
    property ErrorMethodId: Integer read GetErrorMethodId;
    function GetSourceLine(const ModuleName: String; LineNumber: Integer): String;
    function IsExecutableSourceLine(const ModuleName: String; L: Integer): Boolean;

    function LanguageCount: Integer;
    function FindLanguage(const LanguageName: String): TPaxLanguage;
    function FileExtToLanguageName(const FileExt: String): String;
    procedure RegisterLanguage(L: TPaxLanguage);
    procedure UnregisterLanguage(const LanguageName: String);

    function GetRootID: Integer;
    procedure EnumMembers(ID: Integer;
                          Module: Integer;
                          CallBack: TPaxMemberCallback;
                          Data: Pointer);

    function GetValueByID(ID: Integer): Variant;
    procedure SetValueByID(ID: Integer; const Value: Variant);

    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream);

    procedure SaveToFile(const FileName: String);
    procedure LoadFromFile(const FileName: String);
    procedure SaveModuleToStream(const ModuleName: String;
                                 S: TStream);
    procedure SaveModuleToFile(const ModuleName, FileName: String);
    procedure LoadModuleFromStream(const ModuleName: String;
                                   S: TStream);
    procedure LoadModuleFromFile(const ModuleName, FileName: String);


    procedure AssignEventHandlerRunner(MethodAddress: Pointer;
                                       Instance: TObject);

    function GetPaxModule(I: Integer): TPaxModule;
    procedure DeleteModule(I: Integer);
    function FindFullFileName(const FileName: String): String;
    function FindNamespaceHandle(const Name: String): Integer;
    function AssignEventHandler(Instance: TObject; EventPropName: String; EventHandlerName: String): Boolean;

    function ToScriptObject(DelphiInstance: TObject): Variant;
    procedure Rename(ID: Integer; const NewName: String);

    procedure GetClassInfo(const FullName: String; mk: TPaxMemberKind; L: TStrings);
    function GetHostClass(const FullName: String): TClass;

{   procedure GetValueAsTreeNode(ID: Integer;
              const Separator: String;
              N: TTreeNode);    // not finished yet
    procedure SetValueAsTreeNode(N: TTreeNode); // not finished yet }
    procedure ScanProperties(const ObjectName: String);

    property ScripterState: TScripterState read GetScripterState write SetScripterState;
    property CallStack: TCallStack read fCallStack;
    property SourceCode[const ModuleName: String]: String read GetSourceCode write SetSourceCode;
    property Modules: TStringList read GetModules;
    property TotalLineCount: Integer read GetTotalLineCount;
    property CurrentSourceLine: Integer read GetCurrentSourceLine;
    property CurrentModuleName: String read GetCurrentModuleName;
    property Params[const ParamName: String]: Variant read GetParam write SetParam;
    property Values[const VarName: String]: Variant read GetValue write SetValue;
    property Languages[I: Integer]: TPaxLanguage read GetLanguage;
  published
    property OverrideHandlerMode: TPaxOverrideHandlerMode read GetOverrideHandlerMode write SetOverrideHandlerMode;
    property SearchPathes: TStrings read fSearchPathes write SetSearchPathes;
    property StackSize: Integer read GetStackSize write SetStackSize;
    property Optimization: Boolean read GetOptimization write SetOptimization;
    property OnAfterCompileStage: TPaxScripterEvent read fOnAfterCompileStage write fOnAfterCompileStage;
    property OnAfterRunStage: TPaxScripterEvent read fOnAfterRunStage write fOnAfterRunStage;
    property OnAssignScript: TPaxScripterEvent read fOnAssignScript write fOnAssignScript;
    property OnBeforeCompileStage: TPaxScripterEvent read fOnBeforeCompileStage write fOnBeforeCompileStage;
    property OnBeforeRunStage: TPaxScripterEvent read fOnBeforeRunStage write fOnBeforeRunStage;
    property OnCompilerProgress: TPaxCompilerProgressEvent read GetOnCompilerProgress write SetOnCompilerProgress;
    property OnPrint: TPaxScripterPrintEvent read GetOnPrint write SetOnPrint;
    property OnDefine: TPaxScripterDefineEvent read GetOnDefine write SetOnDefine;
    property OnRunning: TPaxCodeEvent read GetOnRunning write SetOnRunning;
{$IFDEF ONRUNNING}
    // See BASE_SCRIPTER.pas for details.
    property OnRunningUpdate: TPaxScripterEvent read GetOnRunningUpdate write SetOnRunningUpdate;
    property OnRunningUpdateActive: Boolean read GetOnRunningUpdateActive write SetOnRunningUpdateActive;
    property OnRunningSync: TPaxScripterEvent read GetOnRunningSync write SetOnRunningSync;
{$ENDIF}
    property OnShowError: TPaxScripterEvent read GetOnShowError write SetOnShowError;

{$IFDEF UNDECLARED_EX}
    property OnUndeclaredIdentifier: TPaxScripterVarEventEx read GetOnUndeclaredIdentifier write SetOnUndeclaredIdentifier;
{$ELSE}
    property OnUndeclaredIdentifier: TPaxScripterVarEvent read GetOnUndeclaredIdentifier write SetOnUndeclaredIdentifier;
{$ENDIF}

    property OnChangedVariable: TPaxScripterVarEvent
                read GetOnChangedVariable write SetOnChangedVariable;
    property OnReadExtraData: TPaxScripterStreamEvent read GetOnReadExtraData write SetOnReadExtraData;
    property OnWriteExtraData: TPaxScripterStreamEvent
                read GetOnWriteExtraData write SetOnWriteExtraData;
    property OnUsedModule: TPaxUsedModuleEvent
                read GetOnUsedModule write SetOnUsedModule;
    property OnLoadSourceCode: TPaxLoadSourceCodeEvent
                read GetOnLoadSourceCode write SetOnLoadSourceCode;
    property OnChangeState: TPaxScripterChangeStateEvent
                read GetOnChangeState write SetOnChangeState;
    property OnInclude: TPaxIncludeEvent
                read GetOnInclude write SetOnInclude;
    property OnHalt: TPaxScripterEvent read GetOnHalt write SetOnHalt;
    property OnDelphiInstanceCreate: TPaxScripterInstanceEvent read GetOnDelphiInstanceCreate write SetOnDelphiInstanceCreate;
    property OnDelphiInstanceDestroy: TPaxScripterInstanceEvent read GetOnDelphiInstanceDestroy write SetOnDelphiInstanceDestroy;
    property OnLoadDll: TPaxLoadDllEvent read GetOnLoadDll write SetOnLoadDll;
    property OnVirtualObjectMethodCallEvent: TPaxVirtualObjectMethodCallEvent read GetOnVirtualObjectMethodCallEvent write SetOnVirtualObjectMethodCallEvent;
    property OnVirtualObjectPutPropertyEvent: TPaxVirtualObjectPutPropertyEvent read GetOnVirtualObjectPutPropertyEvent write SetOnVirtualObjectPutPropertyEvent;
    property OnScanProperties: TPaxScanPropertiesEvent read fOnScanProperties write fOnScanProperties;
  end;

  TPaxLanguage = class(TPaxBaseLanguage)
  private
    fContainer: TComponent;
    fInformalName: String;
    fScripters: TList;
    fLongStrLiterals: Boolean;
    fNamespaceAsModule: Boolean;
    fCallConv: TPAXCallConv;
    fCompilerDirectives: TStrings;
    fIncludeFileExt: String;
    fJavaScriptOperators: Boolean;
    fDeclareVariables: Boolean;
    fZeroBasedStrings: Boolean;
    fBackslash: Boolean;
    procedure RegisterScripter(S: TPaxScripter);
    procedure UnRegisterScripter(S: TPaxScripter);
    function GetKeywords: TStringList;
    function GetCaseSensitive: Boolean;
    procedure SetCompilerDirectives(const Value: TStrings);
  protected
    fInitArrays: boolean;
    fVBArrays: Boolean;
    procedure SetFileExt(const Value: String); virtual;
    function GetPaxParserClass: TPaxParserClass; virtual;
    procedure SetLanguageName(const Value: String); virtual;
    function GetLanguageName: String; virtual;
    function GetFileExt: String; virtual;
    function GetLongStrLiterals: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property LanguageName: String read GetLanguageName write SetLanguageName;
    property FileExt: String read GetFileExt write SetFileExt;
    property Keywords: TStringList read GetKeywords;
    property CaseSensitive: Boolean read GetCaseSensitive;
  published
    property CompilerDirectives: TStrings read fCompilerDirectives write SetCompilerDirectives;
    property InformalName: String read fInformalName write fInformalName;
    property Container: TComponent read fContainer write fContainer;
    property LongStrLiterals: Boolean read fLongStrLiterals write fLongStrLiterals;
    property CallConvention: TPAXCallConv read fCallConv write fCallConv;
    property NamespaceAsModule: Boolean read fNamespaceAsModule write fNamespaceAsModule;
    property IncludeFileExt: String read fIncludeFileExt write fIncludeFileExt;
    property JavaScriptOperators: Boolean read fJavaScriptOperators write fJavaScriptOperators;
    property DeclareVariables: Boolean read fDEclareVariables write fDeclareVariables;
    property ZeroBasedStrings: Boolean read fZeroBasedStrings write fZeroBasedStrings;
    property Backslash: Boolean read fBackslash write fBackslash;
  end;

function RegisterNamespace(const Name: String; OwnerIndex: Integer = -1;
                           UserData: Integer = 0): Integer;
function RegisterClassType(PClass: TClass; OwnerIndex: Integer = -1;
                           UserData: Integer = 0): Integer;
function RegisterInterfaceType(const Name: String; const Guid: TGuid;
                               const ParentName: String; const ParentGuid: TGUID;
                               OwnerIndex: Integer = -1;
                               UserData: Integer = 0): Integer;
procedure RegisterTypeAlias(const TypeName1, TypeName2: String);
function RegisterClassTypeEx(PClass: TClass; ReadProp, WriteProp: TPaxMethodImpl;
                             OwnerIndex: Integer = -1;
                             UserData: Integer = 0): Integer;
function RegisterRTTItype(pti: PTypeInfo; UserData: Integer = 0): Integer;
function RegisterEnumTypeByDef(const TypeName: PChar; UserData: Integer = 0): Integer;

procedure RegisterMethod(PClass: TClass; const Header: String; Address: Pointer;
                        Fake: Boolean = false;
                        UserData: Integer = 0);
procedure RegisterInterfaceMethod(pti: PTypeInfo; const Header: String;
                                  MethodIndex: Integer = -1;
                                  UserData: Integer = 0); overload;
procedure RegisterInterfaceMethod(const Guid: TGUID; const Header: String;
                                  MethodIndex: Integer = -1;
                                  UserData: Integer = 0); overload;
procedure RegisterBCBMethod(PClass: TClass; const Header: String; Address: Pointer;
                        Fake: Boolean = false;
                        UserData: Integer = 0);
procedure RegisterStdMethod(PClass: TClass;
                            const Name: String;
                            Proc: TPAXMethodImpl;
                            NP: Integer;
                            UserData: Integer = 0);
procedure RegisterStdMethodEx(PClass: TClass;
                              const Name: String;
                              Proc: TPAXMethodImpl;
                              NP: Integer;
                              const Types: array of Integer;
                              UserData: Integer = 0);
procedure RegisterField(PClass: TClass; const FieldName, FieldType: String;
                        Offset: Integer; UserData: Integer = 0);
procedure RegisterProperty(PClass: TClass; const PropDef: String;
                           UserData: Integer = 0);
procedure RegisterInterfaceProperty(const guid: TGUID; const PropDef: String;
                           UserData: Integer = 0);
procedure RegisterRoutine(const Header: String; Address: Pointer;
                          OwnerIndex: Integer = -1;
                          UserData: Integer = 0);
procedure RegisterStdRoutine(const Name: String;
                             Proc: TPAXMethodImpl;
                             NP: Integer;
                             OwnerIndex: Integer = -1;
                             UserData: Integer = 0);
procedure RegisterStdRoutineEx(const Name: String;
                               Proc: TPAXMethodImpl;
                               NP: Integer;
                               const Types: array of Integer;
                               OwnerIndex: Integer = -1;
                               UserData: Integer = 0);
procedure RegisterStdRoutineEx2(const Name: String;
                                Proc: TPAXMethodImpl;
                                NP: Integer;
                                const Types: array of Integer;
                                const ByRefs: array of boolean;
                                OwnerIndex: Integer = -1;
                                UserData: Integer = 0);

{$IFDEF VARIANTS}
procedure RegisterConstant(const Name: String; const Value: Double;
                           OwnerIndex: Integer = -1;
                           UserData: Integer = 0); overload;
procedure RegisterConstant(const Name: String; const Value: Integer;
                           OwnerIndex: Integer = -1;
                           UserData: Integer = 0); overload;
procedure RegisterConstant(const Name: String; const Value: Extended;
                           OwnerIndex: Integer = -1;
                           UserData: Integer = 0); overload;
{$ENDIF}

procedure RegisterConstant(const Name: String; const Value: Variant;
                           OwnerIndex: Integer = -1;
                           UserData: Integer = 0); overload;
procedure RegisterInt64Constant(const Name: String; const Value: Int64;
                                OwnerIndex: Integer = -1;
                                UserData: Integer = 0);
procedure RegisterVariable(const Name, TypeName: String; Address: Pointer;
                           OwnerIndex: Integer = -1;
                           UserData: Integer = 0);
procedure RegisterDynamicArrayType(const TypeName, ElementTypeName: String;
                                   OwnerIndex: Integer = -1;
                                   UserData: Integer = 0);
procedure RegisterStaticArrayType(const TypeName, ElementTypeName: String;
                                   OwnerIndex: Integer = -1;
                                   UserData: Integer = 0);
function RegisterRecordType(const TypeName: String;
                            Size: Integer;
                            OwnerIndex: Integer = -1;
                            UserData: Integer = 0): Integer;
procedure RegisterRecordField(OwnerIndex: Integer; const FieldName, FieldType: String;
                              Offset: Integer; UserData: Integer = 0);

function _Self: TObject;
function _Scripter: TPAXScripter;

function RunFile(const FileName: String; PaxScripter: TPaxScripter): Boolean;
function RunString(const Script, LanguageName: String; PaxScripter: TPaxScripter): Boolean;

const
  Fake = true;

var
  _OP_CALL,
  _OP_PRINT,
  _OP_GET_PUBLISHED_PROPERTY,
  _OP_PUT_PUBLISHED_PROPERTY,
  _OP_PUT_PROPERTY,
  _OP_NOP,
  _OP_ASSIGN: Integer;

{$ifdef obsolete}
{obsolete routines to provide backward compatibility}
function paxLanguageCount: Integer; // Use TPaxScripter.LanguageCount instead of it
function paxLanguageName(I: Integer): String; // Use TPaxScripter.Languages property

function GetPaxFileExt(const LanguageName: String): String; // Use TPaxScripter.Languages property
function GetPaxLanguageName(const FileName: String): String; // Use TPaxScripter.FileExtToLanguageName
{$endif}

function LoadImportLibrary(const DllName: String): Cardinal;
function FreeImportLibrary(H: Cardinal): LongBool;

function GetExtraDataPos(S: TStream): Integer;
function GetCompiledModuleVersion(S: TStream): Integer;

implementation

uses
  PAX_RTTI, PASCAL_PARSER, BASE_DFM;
var
  _Count: Integer = 3;

function GetCompiledModuleVersion(S: TStream): Integer;
begin
  if not S.Position = 0 then
    raise Exception.Create(errStream_position_must_be_equal_0);
  LoadInteger(S); // modules count
  LoadInteger(S); // module size
  result := LoadInteger(S);
  S.Position := 0;
end;

function GetExtraDataPos(S: TStream): Integer;
var
  Version: Integer;
begin
  if not S.Position = 0 then
    raise Exception.Create(errStream_position_must_be_equal_0);
  LoadInteger(S); // modules count
  LoadInteger(S); // module size
  Version := LoadInteger(S);
  if Version <> _CompiledModuleVersion then
    raise TPaxScriptFailure.Create(Format(errIncorrectCompiledModuleVersion,
        [Version, _CompiledModuleVersion]));

  result := LoadInteger(S); // extra data pos
  S.Position := 0;
end;

{$ifdef obsolete}
function FindPaxLanguages: TList;
var
  I: Integer;
  C: TComponent;
begin
  result := TList.Create;
  for I:=0 to Screen.FormCount - 1 do
  begin
    C := Screen.Forms[I];
    if C.InheritsFrom(TPaxLanguage) then
      result.Add(C);
  end;
  for I:=0 to Screen.DataModuleCount - 1 do
  begin
    C := Screen.DataModules[I];
    if C.InheritsFrom(TPaxLanguage) then
      result.Add(C);
  end;
end;

function paxLanguageCount: Integer;
var
  L: TList;
begin
  L := FindPaxLanguages;
  result := L.Count;
  L.Free;
end;

function paxLanguageName(I: Integer): String;
var
  L: TList;
begin
  L := FindPaxLanguages;
  result := TPaxLanguage(L[I]).GetLanguageName;
  L.Free;
end;

function GetPaxFileExt(const LanguageName: String): String;
var
  L: TList;
  I: Integer;
begin
  result := '';
  L := FindPaxLanguages;
  for I:=0 to L.Count - 1 do
    if StrEql(TPaxLanguage(L[I]).GetLanguageName, LanguageName) then
    begin
      result := TPaxLanguage(L[I]).GetFileExt;
      Break;
    end;
  L.Free;
end;

function GetPaxLanguageName(const FileName: String): String;
var
  L: TList;
  I: Integer;
  S: String;
begin
  S := ExtractFileExt(FileName);
  if Pos('.', S) = 1 then
    Delete(S, 1, 1);

  result := '';
  L := FindPaxLanguages;
  for I:=0 to L.Count - 1 do
    if StrEql(TPaxLanguage(L[I]).GetFileExt, S) then
    begin
      result := TPaxLanguage(L[I]).GetLanguageName;
      Break;
    end;
  L.Free;
end;
{$endif}

procedure AskToRegister;
begin
  Inc(_Count);
  if _Count mod 15 = 0 then
    ErrMessageBox('Trial version!');
end;

{
procedure TPaxScripter.GetValueAsTreeNode(ID: Integer;
                                          const Separator: String;
                                          N: TTreeNode);
var
  NS: TTreeNodes;

procedure CreateNode(const V: Variant; CurrNode: TTreeNode;
                     const NameID: String; _Prop: TPaxProperty);
var
  I: Integer;
  SO: TPaxScriptObject;
  P: TPaxProperty;
  MR: TPaxMemberRec;
  ValID: String;
begin
  ValID := ToStr(fScripter, V);
  if IsObject(V) then
  begin
    SO := VariantToScriptObject(V);

    CurrNode := NS.AddChild(CurrNode, NameID);
    CurrNode.Data := New(PPaxTreeNodeData);
    with PPaxTreeNodeData(CurrNode.Data)^ do
    begin
      Value := V;
      Modified := false;
      Prop := _Prop;
    end;

    for I := 0 to SO.PropertyList.Count - 1 do
    begin
      P := SO.PropertyList.Properties[I];
      MR := P.MemberRec;
      if MR <> nil then
      begin
        if MR.Kind = KindVAR then
        begin
          if SO.ClassRec.AncestorName = 'Function' then
            NS.AddChild(CurrNode, MR.GetName + '()')
          else
          begin
            CreateNode(P.Value[0], CurrNode, MR.GetName, P);
          end;
        end;
      end
      else
      begin
        CreateNode(P.Value[0], CurrNode, fScripter.NameList[SO.PropertyList[I]], P);
      end;
    end;
  end
  else
  begin
    CurrNode := NS.AddChild(CurrNode, NameID + Separator + ValID);
    CurrNode.Data := New(PPaxTreeNodeData);
    with PPaxTreeNodeData(CurrNode.Data)^ do
    begin
      Value := V;
      Modified := false;
      Prop := _Prop;
    end;
  end;
end;

begin
  NS := N.Owner;
  CreateNode(GetValueByID(ID), N, GetName(ID), nil);
end;

procedure TPaxScripter.SetValueAsTreeNode(N: TTreeNode);

procedure Visit(X: TTreeNode);
var
  P: PPaxTreeNodeData;
begin
  P := PPaxTreeNodeData(X.Data);
  if P <> nil then
    if P^.Modified then
    begin
      if P^.Prop <> nil then
        P^.Prop.Value[0] := P^.Value;
    end;
end;

procedure BackTraking(X: TTreeNode);
var
  I: Integer;
begin
  Visit(X);
  for I:= 0 to X.Count - 1 do
    BackTraking(X.Item[I]);
end;

begin
  BackTraking(N);
end;
}

function TPaxScripter.LanguageCount: Integer;
begin
  result := fScripter.ParserList.Count;
end;

function TPaxScripter.GetLanguage(I: Integer): TPaxLanguage;
begin
  result := TPaxLanguage(fScripter.ParserList[I]._Language);
end;

function TPaxScripter.FindLanguage(const LanguageName: String): TPaxLanguage;
var
  I: Integer;
begin
  result := nil;
  for I:=0 to LanguageCount - 1 do
    if StrEql(fScripter.ParserList.Names[I], LanguageName) then
    begin
      result := TPaxLanguage(fScripter.ParserList[I]._Language);
      Exit;
    end;
end;

function TPaxScripter.FileExtToLanguageName(const FileExt: String): String;
begin
  if Pos('.', FileExt) = 0 then
    result :=  fScripter.ParserList.GetLanguageName('xxx.' + FileExt)
  else
    result :=  fScripter.ParserList.GetLanguageName('xxx' + FileExt);
end;

function RegisterNamespace(const Name: String; OwnerIndex: Integer = -1;
                           UserData: Integer = 0): Integer;
var
  D, Owner: TPAXDefinition;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddNamespace(Name, TPAXClassDefinition(Owner));
  result := D.Index;
  D.UserData := UserData;
end;

function RegisterClassType(PClass: TClass; OwnerIndex: Integer = -1;
                           UserData: Integer = 0): Integer;
var
  D, Owner: TPAXDefinition;
  DefMethod: TPaxMethodDefinition;
  I, J: Integer;
  S: String;
begin
  if PClass.InheritsFrom(TPersistent) then
    if GetClass(PClass.ClassName) = nil then
      RegisterClass(TPersistentClass(PClass));

  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddClass2(PClass, TPAXClassDefinition(Owner), nil, nil);
  result := D.Index;
  D.UserData := UserData;

  S := PClass.ClassName;

  if Pos('CLASS', UpperCase(S)) > 0 then
  begin
     for I:=0 to DefinitionList.Count - 1 do
     if DefinitionList.Records[I].DefKind = dkMethod then
     begin
       DefMethod := DefinitionList.Records[I] as TPaxMethodDefinition;
       if DefMethod.StrTypes <> nil then
       for J:= 0 to Length(DefMethod.StrTypes) - 1 do
       if StrEql(DefMethod.StrTypes[J], S) then
         DefMethod.Types[J] := typeCLASS;
     end;
  end;
end;

function RegisterClassTypeEx(PClass: TClass; ReadProp, WriteProp: TPaxMethodImpl;
                             OwnerIndex: Integer = -1;
                             UserData: Integer = 0): Integer;
var
  D, Owner: TPAXDefinition;
begin
  if PClass.InheritsFrom(TPersistent) then
    if GetClass(PClass.ClassName) = nil then
       RegisterClass(TPersistentClass(PClass));

  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddClass2(PClass, TPAXClassDefinition(Owner),
          ReadProp, WriteProp);
  result := D.Index;
  D.UserData := UserData;
end;

procedure RegisterTypeAlias(const TypeName1, TypeName2: String);
var
  D: TPaxClassDefinition;
begin
  D := DefinitionList.FindClassDefByName(TypeName1);
  if D <> nil then
  begin
    DefinitionList.AddClass1(TypeName2, TPaxClassDefinition(D.Owner), TPaxClassDefinition(D.Ancestor), nil, nil);
  end;

  AddTypeAlias(TypeName1, TypeName2);
end;

function RegisterRTTItype(pti: PTypeInfo; UserData: Integer = 0): Integer;
var
  D: TPAXDefinition;
begin
  D := DefinitionList.AddRTTIType(pti);
  result := D.Index;
  D.UserData := UserData;
end;

function RegisterInterfaceType(const Name: String; const Guid: TGuid;
                               const ParentName: String; const ParentGuid: TGUID;
                               OwnerIndex: Integer = -1;
                               UserData: Integer = 0): Integer;
var
  D, Owner: TPAXDefinition;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddInterfaceType(Name, Guid, ParentName, ParentGuid, TPAXClassDefinition(Owner));
  result := D.Index;
  D.UserData := UserData;
end;

function RegisterEnumTypeByDef(const TypeName: PChar; UserData: Integer = 0): Integer;
var
  D: TPAXDefinition;
begin
  D := DefinitionList.AddEnumTypeByDef(TypeName);
  result := D.Index;
  D.UserData := UserData;
end;

procedure RegisterDynamicArrayType(const TypeName, ElementTypeName: String;
                                   OwnerIndex: Integer = -1;
                                   UserData: Integer = 0);
var
  D, Owner: TPAXDefinition;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddDynamicArrayType(TypeName, ElementTypeName, Owner);
  D.UserData := UserData;
end;

procedure RegisterStaticArrayType(const TypeName, ElementTypeName: String;
                                   OwnerIndex: Integer = -1;
                                   UserData: Integer = 0);
var
  Owner: TPAXDefinition;
  D: TPaxClassDefinition;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddDynamicArrayType(TypeName, ElementTypeName, Owner);
  D.UserData := UserData;
  D.IsStaticArray := true;
end;

function RegisterRecordType(const TypeName: String;
                            Size: Integer;
                            OwnerIndex: Integer = -1;
                            UserData: Integer = 0): Integer;
var
  D, Owner: TPAXDefinition;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddRecordType(TypeName, Size, Owner);
  D.UserData := UserData;
  result := D.Index;
end;

procedure RegisterRecordField(OwnerIndex: Integer; const FieldName, FieldType: String;
                              Offset: Integer; UserData: Integer = 0);
var
  D, Owner: TPaxDefinition;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddRecordField(TPaxClassDefinition(Owner), FieldName, FieldType, Offset);
  D.UserData := UserData;
end;

procedure RegisterMethod(PClass: TClass; const Header: String; Address: Pointer;
                        Fake: Boolean = false;
                        UserData: Integer = 0);
var
  D: TPAXMethodDefinition;
begin
  if Fake then
    D := DefinitionList.AddFakeMethod(PClass, Header, Address)
  else
    D := DefinitionList.AddMethod2(PClass, Header, Address);
  D.UserData := UserData;
end;

procedure RegisterInterfaceMethod(pti: PTypeInfo; const Header: String;
                        MethodIndex: Integer = -1;
                        UserData: Integer = 0);
var
  D: TPAXMethodDefinition;
begin
  D := DefinitionList.AddMethod5(pti, Header);
  D.UserData := UserData;

  if MethodIndex > 0 then
    D.MethodIndex := MethodIndex;
end;

procedure RegisterInterfaceMethod(const Guid: TGUID; const Header: String;
                                  MethodIndex: Integer = -1;
                                  UserData: Integer = 0);
var
  D: TPAXMethodDefinition;
begin
  D := DefinitionList.AddMethod6(guid, Header, MethodIndex);
  D.UserData := UserData;

  if MethodIndex > 0 then
    D.MethodIndex := MethodIndex;
end;

procedure RegisterBCBMethod(PClass: TClass; const Header: String; Address: Pointer;
                            Fake: Boolean = false;
                            UserData: Integer = 0);
var
  D: TPAXMethodDefinition;
begin
  if Fake then
    D := DefinitionList.AddFakeMethod(PClass, Header, Address)
  else
    D := DefinitionList.AddMethod2(PClass, Header, Pointer(Address^));
  D.UserData := UserData;
end;

procedure RegisterProperty(PClass: TClass; const PropDef: String;
                           UserData: Integer = 0);
var
  D: TPAXDefinition;
begin
  D := DefinitionList.AddProperty3(PClass, PropDef);
  if D <> nil then
    D.UserData := UserData;
end;

procedure RegisterInterfaceProperty(const guid: TGUID; const PropDef: String;
                                    UserData: Integer = 0);
var
  D: TPAXDefinition;
begin
  D := DefinitionList.AddInterfaceProperty(guid, PropDef);
  if D <> nil then
    D.UserData := UserData;
end;

procedure RegisterRoutine(const Header: String; Address: Pointer;
                          OwnerIndex: Integer = -1;
                          UserData: Integer = 0);
var
  Owner: TPAXClassDefinition;
  D: TPAXDefinition;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddMethod1(Header, Address, Owner, true);
  D.UserData := UserData;
end;

procedure RegisterStdRoutine(const Name: String;
                             Proc: TPAXMethodImpl;
                             NP: Integer;
                             OwnerIndex: Integer = -1;
                             UserData: Integer = 0);
var
  Owner: TPAXClassDefinition;
  D: TPAXDefinition;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddMethod3(Name, Proc, NP, Owner, true);
  D.UserData := UserData;
end;

procedure RegisterStdRoutineEx(const Name: String;
                               Proc: TPAXMethodImpl;
                               NP: Integer;
                               const Types: array of Integer;
                               OwnerIndex: Integer = -1;
                               UserData: Integer = 0);
var
  Owner: TPAXClassDefinition;
  D: TPAXMethodDefinition;
  I: Integer;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddMethod3(Name, Proc, NP, Owner, true);
  D.UserData := UserData;

  if Length(Types) <> NP + 1 then
    raise Exception.Create(errIncorrect_parameters_in_RegisterStdRoutineEx);

  SetLength(D.Types, NP + 1);
  SetLength(D.ByRefs, NP + 1);
  SetLength(D.ExtraTypes, NP + 1);
  SetLength(D.StrTypes, NP + 1);
  SetLength(D.ParamNames, NP + 1);
  for I:=0 to NP do
  begin
    D.Types[I] := Types[I];
    D.ByRefs[I] := false;
    D.ExtraTypes[I] := 0;
    D.StrTypes[I] := '';
    D.ParamNames[I] := '';
  end;
end;

procedure RegisterStdRoutineEx2(const Name: String;
                                Proc: TPAXMethodImpl;
                                NP: Integer;
                                const Types: array of Integer;
                                const ByRefs: array of boolean;
                                OwnerIndex: Integer = -1;
                                UserData: Integer = 0);
var
  Owner: TPAXClassDefinition;
  D: TPAXMethodDefinition;
  I: Integer;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddMethod3(Name, Proc, NP, Owner, true);
  D.UserData := UserData;

  if NP = -1 then
    NP := Length(Types) - 1;

  if Length(Types) <> NP + 1 then
    raise Exception.Create(errIncorrect_parameters_in_RegisterStdRoutineEx);

  SetLength(D.Types, NP + 1);
  SetLength(D.ByRefs, NP + 1);
  SetLength(D.ExtraTypes, NP + 1);
  SetLength(D.StrTypes, NP + 1);
  SetLength(D.ParamNames, NP + 1);
  for I:=0 to NP do
  begin
    D.Types[I] := Types[I];
    D.ByRefs[I] := ByRefs[I];
    D.ExtraTypes[I] := 0;
    D.StrTypes[I] := '';
    D.ParamNames[I] := '';
  end;
end;

procedure RegisterStdMethod(PClass: TClass;
                            const Name: String;
                            Proc: TPAXMethodImpl;
                            NP: Integer;
                            UserData: Integer = 0);
var
  Owner: TPAXClassDefinition;
  D: TPAXDefinition;
begin
  Owner := DefinitionList.FindClassDef(PClass);
  D := DefinitionList.AddMethod3(Name, Proc, NP, Owner);
  D.UserData := UserData;
end;

procedure RegisterStdMethodEx(PClass: TClass;
                              const Name: String;
                              Proc: TPAXMethodImpl;
                              NP: Integer;
                              const Types: array of Integer;
                              UserData: Integer = 0);
var
  Owner: TPAXClassDefinition;
  D: TPAXMethodDefinition;
  I: Integer;
begin
  Owner := DefinitionList.FindClassDef(PClass);
  D := DefinitionList.AddMethod3(Name, Proc, NP, Owner);
  D.UserData := UserData;

  if Length(Types) <> NP + 1 then
    raise Exception.Create(errIncorrect_parameters_in_RegisterStdMethodEx);

  SetLength(D.Types, NP + 1);
  SetLength(D.ByRefs, NP + 1);
  SetLength(D.ExtraTypes, NP + 1);
  SetLength(D.StrTypes, NP + 1);
  SetLength(D.ParamNames, NP + 1);
  for I:=0 to NP do
  begin
    D.Types[I] := Types[I];
    D.ByRefs[I] := false;
    D.ExtraTypes[I] := 0;
    D.StrTypes[I] := '';
    D.ParamNames[I] := '';
  end;
end;

{$IFDEF VARIANTS}
procedure RegisterConstant(const Name: String; const Value: Extended;
                           OwnerIndex: Integer = -1; UserData: Integer = 0);
begin
end;

procedure RegisterConstant(const Name: String; const Value: Double;
                           OwnerIndex: Integer = -1;
                           UserData: Integer = 0);
var
  Owner: TPAXClassDefinition;
  D: TPAXDefinition;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddConstant(Name, Value, Owner, true);
  D.UserData := UserData;
end;

procedure RegisterConstant(const Name: String; const Value: Integer;
                           OwnerIndex: Integer = -1;
                           UserData: Integer = 0);
var
  Owner: TPAXClassDefinition;
  D: TPAXDefinition;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddConstant(Name, Value, Owner, true);
  D.UserData := UserData;
end;
{$ENDIF}

procedure RegisterConstant(const Name: String; const Value: Variant;
                           OwnerIndex: Integer = -1;
                           UserData: Integer = 0);
var
  Owner: TPAXClassDefinition;
  D: TPAXDefinition;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  D := DefinitionList.AddConstant(Name, Value, Owner, true);
  D.UserData := UserData;
end;

procedure RegisterInt64Constant(const Name: String; const Value: Int64;
                                OwnerIndex: Integer = -1;
                                UserData: Integer = 0);
var
  Owner: TPAXClassDefinition;
  Dbl: Double;
  I: Integer;
  D: TPAXDefinition;
begin
  if OwnerIndex = -1 then
    Owner := nil
  else
    Owner := DefinitionList[OwnerIndex];
  if Abs(Value) > MaxInt then
  begin
    Dbl := Value;
    D := DefinitionList.AddConstant(Name, Dbl, Owner, true);
  end
  else
  begin
    I := Value;
    D := DefinitionList.AddConstant(Name, I, Owner, true);
  end;
  D.UserData := UserData;
end;

procedure RegisterVariable(const Name, TypeName: String; Address: Pointer;
                           OwnerIndex: Integer = -1;
                           UserData: Integer = 0);
var
  O: TPAXClassDefinition;
  D: TPAXDefinition;
begin
  if OwnerIndex = -1 then
    O := nil
  else
    O := DefinitionList[OwnerIndex];
  D := DefinitionList.AddVariable(Name, TypeName, Address, O);
  D.UserData := UserData;
end;

procedure RegisterField(PClass: TClass; const FieldName, FieldType: String;
                        Offset: Integer; UserData: Integer = 0);
var
  D: TPAXDefinition;
begin
  D := DefinitionList.AddField(PClass, FieldName, FieldType, Offset);
  D.UserData := UserData;
end;

function _Self: TObject;
begin
  result := BASE_SCRIPTER.__Self;
end;

function _Scripter: TPAXScripter;
begin
  result := TPAXScripter(BASE_SCRIPTER.__Scripter);
end;

constructor TCallStackRecord.Create;
begin
  Parameters := TStringList.Create;
end;

destructor TCallStackRecord.Destroy;
begin
  Parameters.Free;
end;

constructor TCallStack.Create(PaxScripter: TPaxScripter);
begin
  fRecords := TList.Create;
  fScripter := PaxScripter.fScripter;
end;

function TCallStack.GetCount: Integer;
begin
  result := fRecords.Count;
end;

procedure TCallStack.Add(R: TCallStackRecord);
begin
  fRecords.Add(R);
end;

function TCallStack.GetRecord(Index: Integer): TCallStackRecord;
begin
  result := TCallStackRecord(fRecords[Index]);
end;

procedure TCallStack.Clear;
var
  I: Integer;
begin
  for I:=0 to fRecords.Count - 1 do
    TCallStackRecord(fRecords[I]).Free;
   fRecords.Clear;
end;

destructor TCallStack.Destroy;
begin
  Clear;
  fRecords.Free;
end;

constructor TPaxScripter.Create(AOwner: TComponent);
begin
  inherited;
  fScripter := TPAXBaseScripter.Create(Self);
  fCallStack := TCallStack.Create(Self);
  fSearchPathes := TStringList.Create;

  RegisterLanguages;

  Optimization := true;
end;

destructor TPaxScripter.Destroy;
begin
  UnregisterLanguages;

  fScripter.Free;
  fCallStack.Free;
  fSearchPathes.Free;

  inherited;
end;

function TPaxScripter.FindTempObject(const Key: TVarRec): TObject;
begin
  result := fScripter.TempObjectList.FindObject(Key);
end;

function TPaxScripter.AddTempObject(const Key: TVarRec; Obj: TObject): Integer;
begin
  result := fScripter.TempObjectList.Add(Key, Obj);
end;

procedure TPaxScripter.SetSearchPathes(const Value: TStrings);
begin
  fSearchPathes.Assign(Value);
end;

function TPaxScripter.GetCurrentProcID: Integer;
begin
  result := fScripter.Code.LevelStack.Top;
end;

function TPaxScripter.IsConstructor(ID: Integer): Boolean;
begin
   result := fScripter.SymbolTable.TypeSub[ID] = tsConstructor;
end;

function TPaxScripter.IsDestructor(ID: Integer): Boolean;
begin
  result := fScripter.SymbolTable.TypeSub[ID] = tsDestructor;
end;

function TPaxScripter.IsVarParameter(ID: Integer): Boolean;
begin
  result := fScripter.SymbolTable.ByRef[ID] = 1;
end;

function TPaxScripter.IsConstParameter(ID: Integer): Boolean;
begin
  result := fScripter.SymbolTable.ByRef[ID] = 2;
end;

function TPaxScripter.IsStatic(ID: Integer): Boolean;
var
  K: TPaxMemberKind;
  ClassRec: TPaxClassRec;
  I, L: Integer;
  MemberRec: TPaxMemberRec;
  D: TPaxMethodDefinition;
begin
  result := true;
  K := GetKind(ID);
  case K of
    mkClass:
    begin
      ClassRec := fScripter.ClassList.FindClass(ID);
      if ClassRec <> nil then
        result := ClassRec.IsStatic;
    end;
    mkMethod:
    if ID > 0 then
    begin
      L := fScripter.SymbolTable.Level[ID];
      if fScripter.SymbolTable.Kind[ID] = KindType then
      begin
        ClassRec := fScripter.ClassList.FindClass(L);
        if ClassRec <> nil then
        begin
          result := ClassRec.IsStatic;
          if result then
            Exit;

          for I:=0 to ClassRec.MemberList.Count - 1 do
          begin
            MemberRec := ClassRec.MemberList[I];
            if MemberRec.ID = ID then
            begin
              result := MemberRec.IsStatic;
              Exit;
            end;
          end;
        end;
      end
      else // nested function
        result := false;
    end
    else if ID < 0 then
    begin
      D := DefinitionList[-ID];
      result := D.IsStatic;
    end;
  end
end;

procedure TPaxScripter.SetStackSize(Value: Integer);
begin
  fScripter.fStackSize := Value;
end;

function TPaxScripter.GetStackSize: Integer;
begin
  result := fScripter.fStackSize;
end;

procedure TPaxScripter.SetOptimization(Value: Boolean);
begin
  fScripter.Code.SignFOP := Value;
end;

function TPaxScripter.GetOptimization: Boolean;
begin
  result := fScripter.Code.SignFOP;
end;

function TPaxScripter.GetTotalLineCount: Integer;
begin
  result := fScripter.TotalLineCount;
end;

function TPaxScripter.GetOnPrint: TPaxScripterPrintEvent;
begin
  result := TPaxScripterPrintEvent(fScripter.OnPrint);
end;

procedure TPaxScripter.SetOnPrint(Value: TPaxScripterPrintEvent);
begin
  fScripter.OnPrint := TPrintEvent(Value);
end;

function TPaxScripter.GetOnDefine: TPaxScripterDefineEvent;
begin
  result := TPaxScripterDefineEvent(fScripter.OnDefine);
end;

procedure TPaxScripter.SetOnDefine(Value: TPaxScripterDefineEvent);
begin
  fScripter.OnDefine := TOnDefineEvent(Value);
end;

function TPaxScripter.GetOnChangedVariable: TPaxScripterVarEvent;
begin
  result := TPaxScripterVarEvent(fScripter.OnChangedVariable);
end;

procedure TPaxScripter.SetOnChangedVariable(Value: TPaxScripterVarEvent);
begin
  fScripter.OnChangedVariable := TVarEvent(Value);
end;

{$IFDEF UNDECLARED_EX}
procedure TPaxScripter.SetOnUndeclaredIdentifier(Value: TPaxScripterVarEventEx);
begin
  fScripter.OnUndeclaredIdentifier := TVarEventEx(Value);
end;

function TPaxScripter.GetOnUndeclaredIdentifier: TPaxScripterVarEventEx;
begin
  result := TPaxScripterVarEventEx(fScripter.OnUndeclaredIdentifier);
end;

{$ELSE}

function TPaxScripter.GetOnUndeclaredIdentifier: TPaxScripterVarEvent;
begin
  result := TPaxScripterVarEvent(fScripter.OnUndeclaredIdentifier);
end;

procedure TPaxScripter.SetOnUndeclaredIdentifier(Value: TPaxScripterVarEvent);
begin
  fScripter.OnUndeclaredIdentifier := TVarEvent(Value);
end;
{$ENDIF}

function TPaxScripter.GetOnHalt: TPaxScripterEvent;
begin
  result := TPaxScripterEvent(fScripter.OnHalt);
end;

procedure TPaxScripter.SetOnHalt(Value: TPaxScripterEvent);
begin
  fScripter.OnHalt := TScripterEvent(Value);
end;

function TPaxScripter.GetOnLoadDll: TPaxLoadDllEvent;
begin
  result := TPaxLoadDllEvent(fScripter.OnLoadDll);
end;

procedure TPaxScripter.SetOnLoadDll(Value: TPaxLoadDllEvent);
begin
  fScripter.OnLoadDll := TLoadDllEvent(Value);
end;

function TPaxScripter.GetOnVirtualObjectMethodCallEvent: TPaxVirtualObjectMethodCallEvent;
begin
  result := TPaxVirtualObjectMethodCallEvent(fScripter.OnVirtualObjectMethodCall);
end;

procedure TPaxScripter.SetOnVirtualObjectMethodCallEvent(Value: TPaxVirtualObjectMethodCallEvent);
begin
  fScripter.OnVirtualObjectMethodCall := TVirtualObjectMethodCallEvent(Value);
end;

function TPaxScripter.GetOnVirtualObjectPutPropertyEvent: TPaxVirtualObjectPutPropertyEvent;
begin
  result := TPaxVirtualObjectPutPropertyEvent(fScripter.OnVirtualObjectPutProperty);
end;

procedure TPaxScripter.SetOnVirtualObjectPutPropertyEvent(Value: TPaxVirtualObjectPutPropertyEvent);
begin
  fScripter.OnVirtualObjectPutProperty := TVirtualObjectPutPropertyEvent(Value);
end;


function TPaxScripter.GetOnReadExtraData: TPaxScripterStreamEvent;
begin
  result := TPaxScripterStreamEvent(fScripter.OnReadExtraData);
end;

procedure TPaxScripter.SetOnReadExtraData(Value: TPaxScripterStreamEvent);
begin
  fScripter.OnReadExtraData := TStreamEvent(Value);
end;

function TPaxScripter.GetOnWriteExtraData: TPaxScripterStreamEvent;
begin
  result := TPaxScripterStreamEvent(fScripter.OnWriteExtraData);
end;

procedure TPaxScripter.SetOnWriteExtraData(Value: TPaxScripterStreamEvent);
begin
  fScripter.OnWriteExtraData := TStreamEvent(Value);
end;

function TPaxScripter.GetOnShowError: TPaxScripterEvent;
begin
  result := TPaxScripterEvent(fScripter.OnShowError);
end;

procedure TPaxScripter.SetOnShowError(Value: TPaxScripterEvent);
begin
  fScripter.OnShowError := TScripterEvent(Value);
end;

function TPaxScripter.GetOnRunning: TPaxCodeEvent;
begin
  result := TPaxCodeEvent(fScripter.OnRunning);
end;

procedure TPaxScripter.SetOnRunning(Value: TPaxCodeEvent);
begin
  fScripter.OnRunning := TCodeEvent(Value);
end;

{$IFDEF ONRUNNING}

// See BASE_SCRIPTER.pas for details.

function TPaxScripter.GetOnRunningUpdate: TPaxScripterEvent;
begin
  result := TPaxScripterEvent(fScripter.OnRunningUpdate);
end;

procedure TPaxScripter.SetOnRunningUpdate(Value: TPaxScripterEvent);
begin
  fScripter.OnRunningUpdate := TScripterEvent(Value);
end;

function TPaxScripter.GetOnRunningUpdateActive: Boolean;
begin
  result := fScripter.OnRunningUpdateActive;
end;

procedure TPaxScripter.SetOnRunningUpdateActive(Value: Boolean);
begin
  fScripter.OnRunningUpdateActive := Value;
end;

function TPaxScripter.GetOnRunningSync: TPaxScripterEvent;
begin
  result := TPaxScripterEvent(fScripter.OnRunningSync);
end;

procedure TPaxScripter.SetOnRunningSync(Value: TPaxScripterEvent);
begin
  fScripter.OnRunningSync := TScripterEvent(Value);
end;

{$ENDIF}

function TPaxScripter.GetOnUsedModule: TPaxUsedModuleEvent;
begin
  result := TPaxUsedModuleEvent(fScripter.OnUsedModule);
end;

procedure TPaxScripter.SetOnUsedModule(Value: TPaxUsedModuleEvent);
begin
  fScripter.OnUsedModule := TUsedModuleEvent(Value);
end;

function TPaxScripter.GetOnInclude: TPaxIncludeEvent;
begin
  result := TPaxIncludeEvent(fScripter.OnInclude);
end;

procedure TPaxScripter.SetOnInclude(Value: TPaxIncludeEvent);
begin
  fScripter.OnInclude := TIncludeEvent(Value);
end;

function TPaxScripter.GetOnLoadSourceCode: TPaxLoadSourceCodeEvent;
begin
  result := TPaxLoadSourceCodeEvent(fScripter.OnLoadSourceCode);
end;

procedure TPaxScripter.SetOnLoadSourceCode(Value: TPaxLoadSourceCodeEvent);
begin
  fScripter.OnLoadSourceCode := TLoadSourceCodeEvent(Value);
end;

function TPaxScripter.GetOnChangeState: TPaxScripterChangeStateEvent;
begin
  result := TPaxScripterChangeStateEvent(fScripter.OnChangeState);
end;

procedure TPaxScripter.SetOnChangeState(Value: TPaxScripterChangeStateEvent);
begin
  fScripter.OnChangeState := TOnChangeStateEvent(Value);
end;

function TPaxScripter.GetOnDelphiInstanceCreate: TPaxScripterInstanceEvent;
begin
  result := TPaxScripterInstanceEvent(fScripter.OnDelphiInstanceCreate);
end;

procedure TPaxScripter.SetOnDelphiInstanceCreate(Value: TPaxScripterInstanceEvent);
begin
  fScripter.OnDelphiInstanceCreate := TOnInstanceEvent(Value);
end;

function TPaxScripter.GetOnDelphiInstanceDestroy: TPaxScripterInstanceEvent;
begin
  result := TPaxScripterInstanceEvent(fScripter.OnDelphiInstanceDestroy);
end;

procedure TPaxScripter.SetOnDelphiInstanceDestroy(Value: TPaxScripterInstanceEvent);
begin
  fScripter.OnDelphiInstanceDestroy := TOnInstanceEvent(Value);
end;

function TPaxScripter.GetOnCompilerProgress: TPaxCompilerProgressEvent;
begin
  result := TPaxCompilerProgressEvent(fScripter.OnCompilerProgress);
end;

procedure TPaxScripter.SetOnCompilerProgress(Value: TPaxCompilerProgressEvent);
begin
  fScripter.OnCompilerProgress := TCompilerProgressEvent(Value);
end;

function TPaxScripter.GetModules: TStringList;
begin
  result := fScripter.Modules;
end;

function TPaxScripter.GetPaxModule(I: Integer): TPaxModule;
begin
  result := fScripter.Modules.Items[I];
end;

procedure TPaxScripter.DeleteModule(I: Integer);
begin
  fScripter.Modules.Delete(I);
end;

function TPaxScripter.GetAddress(ID: Integer): Pointer;
var
  MemberRec: TPaxMemberRec;
  D: TPaxDefinition;
begin
  result := nil;
  with fScripter.SymbolTable do
  begin
    if Kind[ID] = KindREF then
    begin
      MemberRec := GetMemberRec(ID, maAny);
      if MemberRec = nil then
        Exit;
      D := MemberRec.Definition;
      if D <> nil then
        case D.DefKind of
          dkMethod: result := TPaxMethodDefinition(D).DirectProc;
          dkVariable: result := TPaxVariableDefinition(D).Address;
        end;
    end
    else
      result := Address[ID];
  end;
end;

function TPaxScripter.IsLocalVariable(ID: Integer): Boolean;
begin
  if ID > 0 then
    result := fScripter.SymbolTable.IsLocal(ID)
  else
    result := false;
end;

function TPaxScripter.GetUserData(ID: Integer): Integer;
begin
  result := fScripter.SymbolTable.GetUserData(ID);
end;

function TPaxScripter.GetOwnerID(ID: Integer): Integer;
begin
  if ID > 0 then
    result := fScripter.SymbolTable.Level[ID]
  else
    result := 0
end;

function TPaxScripter.GetKind(ID: Integer): TPAXMemberKind;
var
  K: Integer;
  ClassRec: TPaxClassRec;
begin
  result := mkUnknown;
  with fScripter.SymbolTable do
  begin
    K := Kind[ID];
    case K of
      kindVAR: result := mkField;
      kindCONST: result := mkConst;
      kindPROP: result := mkProp;
      kindSUB: result := mkMethod;
      kindTYPE:
      begin
        result := mkClass;
        ClassRec := fScripter.ClassList.FindClass(ID);
        if ClassRec <> nil then
          if ClassRec.IsStatic then
            result := mkNamespace;
      end;
    end;
  end;
end;

procedure TPaxScripter.AddCode(const ModuleName, Code: String);
begin
  fScripter.AddCode(ModuleName, Code);
  fScripter.State := Ord(ssReadyToCompile);
end;

procedure TPaxScripter.AddCodeLine(const ModuleName, Code: String);
begin
  AddCode(ModuleName, Code + #13#10);
end;

procedure TPaxScripter.AddCodeFromFile(const ModuleName, FileName: String);
begin
  fScripter.AddCodeFromFile(ModuleName, FileName);
end;

procedure TPaxScripter.AddDelphiForm(const DfmFileName, UnitFileName: String;
                                     const PaxLanguage: String = 'paxPascal');
begin
  fScripter.AddDelphiForm(DfmFileName, UnitFileName, PaxLanguage);
end;

procedure TPaxScripter.AddDelphiForm(const DfmFileName: String; UsedUnits: TStringList;
                                     const PaxLanguage: String = 'paxPascal');
var
  S, ModuleName: String;
  P: Integer;
begin
  ModuleName := ExtractFileName(DfmFileName);
  P := Pos('.', ModuleName);
  if P > 0 then
    ModuleName := Copy(ModuleName, 1, P - 1);

  S := fScripter.ConvertDelphiForm2(DfmFileName, UsedUnits, PaxLanguage);
  fScripter.AddModule(ModuleName, PaxLanguage);
  fScripter.AddCode(ModuleName, S);
end;

procedure TPaxScripter.AddDelphiForm(const ModuleName: String; Dfm, Source: TStream;
                                     const PaxLanguage: String = 'paxPascal');
var
  L, Src, UsedUnits, DfmStrings: TStringList;
  I, J: Integer;
  P: TPascalParser;
  S: String;
begin
  L := TStringList.Create;
  Src := TStringList.Create;
  DfmStrings := TStringList.Create;
  UsedUnits := TStringList.Create;
  try
    DfmStrings.LoadFromStream(Dfm);
    Src.LoadFromStream(Source);

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
    for J:= UsedUnits.Count - 1 downto 0 do
    begin
      S := UsedUnits[J];
      if DefinitionList.FindClassDefByName(S) = nil then
        UsedUnits.Delete(J); // not registered
    end;

    ConvDFMStringtoScript(DfmStrings.Text, UsedUnits, L, true, ModuleName, Src, PaxLanguage);

    fScripter.AddModule(ModuleName, PaxLanguage);
    fScripter.AddCode(ModuleName, L.Text);
  finally
    DfmStrings.Free;
    UsedUnits.Free;
    L.Free;
    Src.Free;

    fScripter.State := Ord(ssReadyToCompile);
  end;
end;

function TPaxScripter.AddModule(const ModuleName, LanguageName: String): Integer;
begin
  SetUpSearchPathes;
  result := fScripter.AddModule(ModuleName, LanguageName);
end;

procedure TPaxScripter.SaveModuleToStream(const ModuleName: String;
                                          S: TStream);
var
  M: TPaxModule;
  I: Integer;
begin
  I := fScripter.Modules.IndexOf(ModuleName);
  if I = -1 then
    Exit;
  M := fScripter.Modules.Items[I];

//  SaveInteger(1, S);
  fScripter.SaveCompiledModuleToStream(M, S);
end;

procedure TPaxScripter.SaveModuleToFile(const ModuleName, FileName: String);
var
  S: TFileStream;
begin
  S := TFileStream.Create(FileName, fmCreate);
  try
    SaveModuleToStream(ModuleName, S);
  finally
    S.Free;
  end;
end;

procedure TPaxScripter.LoadModuleFromStream(const ModuleName: String;
                                            S: TStream);
var
  M: TPaxModule;
  I: Integer;
begin
  I := fScripter.Modules.IndexOf(ModuleName);
  if I = -1 then
    I := fScripter.AddModule(ModuleName, 'paxPascal');

  M := fScripter.Modules.Items[I];

  fScripter.LoadCompiledModuleFromStream(M, S);
end;

procedure TPaxScripter.LoadModuleFromFile(const ModuleName, FileName: String);
var
  S: TFileStream;
begin
  S := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadModuleFromStream(ModuleName, S);
  finally
    S.Free;
  end;
end;

function TPaxScripter.CompileModule(const ModuleName: String;
                                    SyntaxCheckOnly: Boolean = false): Boolean;
var
  Parser: TPAXParser;
  M: TPAXModule;
  I: Integer;
  L: TPaxLanguage;
begin
  I := fScripter.Modules.IndexOf(ModuleName);
  if I = -1 then
    raise Exception.Create(Format(errModuleNotFound, [ModuleName]));

  M := fScripter.Modules.Items[I];

  Parser := fScripter.ParserList.FindParser(M.LanguageName);
  if Parser = nil then
    raise Exception.Create(errUnregisteredLanguage + M.LanguageName);

  fScripter.DefList.Clear;

  L := FindLanguage(M.LanguageName);
  if L <> nil then
  begin
    fScripter.DefList.Text := L.fCompilerDirectives.Text;
    Parser.NamespaceAsModule := L.NamespaceAsModule;
    Parser.IncludeFileExt := L.IncludeFileExt;
    Parser.JavaScriptOperators := L.JavaScriptOperators;
    Parser.ZeroBasedStrings := L.ZeroBasedStrings;
    Parser.DeclareVariables := L.DeclareVariables;
    Parser.VBArrays := L.fVBArrays;
    Parser.IsArrayInitialization := L.fInitArrays;
    Parser.Backslash := L.Backslash;
    if Length(Parser.IncludeFileExt) > 0 then
      if Pos('.', Parser.IncludeFileExt) = 0 then
        Parser.IncludeFileExt := '.' + Parser.IncludeFileExt;
  end;

  fScripter.CurrModule := I;
  result := fScripter.CompileModule(ModuleName, Parser, SyntaxCheckOnly);
end;

function TPaxScripter.Eval(const Expression, LanguageName: String; var Res: Variant): Boolean;
var
  Parser: TPAXParser;
begin
  Parser := fScripter.ParserList.FindParser(LanguageName);
  if Parser = nil then
    raise Exception.Create(errUnregisteredLanguage + LanguageName);

  Res := fScripter.Eval(Expression, Parser);
  if fScripter.IsError then
  begin
    result := false;
    fScripter.DiscardError;
  end
  else
    result := true;
end;

function TPaxScripter.EvalStatementList(const Expression, LanguageName: String): Boolean;
var
  Parser: TPAXParser;
begin
  Parser := fScripter.ParserList.FindParser(LanguageName);
  if Parser = nil then
    raise Exception.Create(errUnregisteredLanguage + LanguageName);

  fScripter.EvalStatementList(Expression, Parser);
  if fScripter.IsError then
  begin
    result := false;
    fScripter.DiscardError;
  end
  else
    result := true;
end;

function TPaxScripter.EvalJS(const Expression: String): Boolean;
var
  Parser: TPAXParser;
begin
  Parser := fScripter.ParserList.FindParser('paxJavaScript');
  if Parser = nil then
    raise Exception.Create(errUnregisteredLanguage + 'paxJavaScript');

  _Eval(Expression, fScripter, Parser);
  if fScripter.IsError then
  begin
    result := false;
    fScripter.DiscardError;
  end
  else
    result := true;
end;

function TPaxScripter.GetMemberID(const Name: String): Integer;
var
  P, ID: Integer;
  ClassRec: TPAXClassRec;
  S: String;
begin
  result := -1;

  if StrEql(Name, 'NonameNamespace') then
  begin
    result := fScripter.SymbolTable.RootNamespaceID;
    Exit;
  end;

  S := Name;
  ClassRec := fScripter.ClassList[0];

  P := Pos('.', S);
  while P > 0 do
  begin
    ID := ClassRec.MemberList.GetMemberID(Copy(S, 1, P - 1));
    if ID = 0 then
      Exit;

    ClassRec := fScripter.ClassList.FindClass(ID);

    if ClassRec = nil then
    begin
      result := -1;
      Exit;
    end;

    S := Copy(S, P + 1, Length(S) - P);
    P := Pos('.', S);
  end;

  result := ClassRec.MemberList.GetMemberID(S);
end;

function TPaxScripter.GetValueByID(ID: Integer): Variant;
begin
  with fScripter do
  if ((ID > 0) and (ID <= SymbolTable.Card)) or (ID < 0) then
    result := SymbolTable.VariantValue[ID]
end;

function TPaxScripter.GetParamID(SubID, ParamIndex: Integer): Integer;
begin
  with fScripter do
  if (SubID > 0) and (SubID <= SymbolTable.Card) then
    result := SymbolTable.GetParamID(SubID, ParamIndex)
  else
    result := 0;
end;

function TPaxScripter.IDCount: Integer;
begin
  result := fScripter.SymbolTable.Card;
end;

function TPaxScripter.IsMethod(ID: Integer): Boolean;
begin
  result := fScripter.SymbolTable.Kind[ID] = KindSUB;
end;

function TPaxScripter.GetResultID(SubID: Integer): Integer;
begin
  result := fScripter.SymbolTable.GetResultID(SubID);
end;

function TPaxScripter.GetParamCount(SubID: Integer): Integer;
begin
  result := fScripter.SymbolTable.Count[SubID];
end;

function TPaxScripter.GetTypeName(ID: Integer): String;
begin
  result := fScripter.SymbolTable.GetTypeName(ID);
end;

function TPaxScripter.GetParamTypeName(SubID, ParamIndex: Integer): String;
begin
  result := fScripter.SymbolTable.GetParamTypeName(SubID, ParamIndex);
end;

function TPaxScripter.GetSignature(SubID: Integer): String;
var
  j, np: Integer;
begin
  result := '';
  np := GetParamCount(SubId);

  for j:=1 to np do
  begin
    result := result + GetParamTypeName(SubId, j);
    if j < np then
      result := result + ',';
  end;
end;

function TPaxScripter.GetParamName(SubID, ParamIndex: Integer): String;
begin
  result := fScripter.SymbolTable.GetParamName(SubID, ParamIndex);
end;

function TPaxScripter.GetTypeID(ID: Integer): Integer;
begin
  result := fScripter.GetTypeID(ID);
end;

function TPaxScripter.GetPosition(ID: Integer): Integer;
begin
  with fScripter do
  if (ID > 0) and (ID <= SymbolTable.Card) then
    result := SymbolTable.Position[ID]
  else
    result := 0;
end;

function TPaxScripter.GetStartPosition(ID: Integer): Integer;
begin
  with fScripter do
  if (ID > 0) and (ID <= SymbolTable.Card) then
    result := SymbolTable.StartPosition[ID]
  else
    result := 0;
end;

function TPaxScripter.GetModule(ID: Integer): Integer;
var
  D: TPaxDefinition;
begin
  with fScripter do
  if (ID > 0) and (ID <= SymbolTable.Card) then
    result := SymbolTable.Module[ID]
  else
  if ID < 0 then
  begin
    D := DefinitionList[-ID];
    result := D.Module;
  end
  else
    result := -1;
end;

function TPaxScripter.GetName(ID: Integer): String;
begin
  with fScripter do
    result := SymbolTable.Name[ID];
end;

function TPaxScripter.GetFullName(ID: Integer): String;
begin
  with fScripter do
    result := SymbolTable.FullName[ID];
end;

function TPaxScripter.GetValue(const Name: String): Variant;
begin
  result := GetValueByID(GetMemberID(Name));
end;

procedure TPaxScripter.SetValueByID(ID: Integer; const Value: Variant);
begin
  with fScripter do
  if (ID > 0) and (ID <= SymbolTable.Card) then
    SymbolTable.VariantValue[ID] := Value;
end;

procedure TPaxScripter.SetValue(const Name: String; const Value: Variant);
begin
  SetValueByID(GetMemberID(Name), Value);
end;

function TPaxScripter.CallFunctionByID(SubID: Integer;
                                       const Params: array of const;
                                       ObjectID: Integer = 0): Variant;
var
  This: Variant;
begin
  case ScripterState of
    ssReadyToRun:
    begin
      fScripter.InitRunStage;
      fScripter.ClassList.InitStaticFields(0);
    end;
    ssTerminated:
    begin
      with fScripter.Code do
      begin
        DebugInfo.Clear;

//      UsingList.Clear;
//      WithStack.Clear;
        TryStack.Clear;
        RefStack.Clear;
        Stack.Clear;
        SubRunCount := 0;

      end;
      fScripter.VariantStack.Clear;
    end
  end;

  if ScripterState <> ssRunning then
  if Assigned(fOnBeforeRunStage) then
    fOnBeforeRunStage(Self);

  if ObjectID <> 0 then
    This := fScripter.SymbolTable.VariantValue[ObjectID]
  else
    This := Undefined;

  fScripter.State := Ord(ssRunning);
  result := fScripter.CallMethod(SubID, This, Params);
  ExtractCallStack;
  if IsObject(result) then
    result := Integer(VariantToScriptObject(result).Instance);

  if ScripterState <> ssRunning then
  begin
    if fScripter.Code.SignHaltGlobal then
    if Assigned(fScripter.OnHalt) then
      fScripter.OnHalt(Self);

    if Assigned(fOnAfterRunStage) then
      fOnAfterRunStage(Self);
  end;
end;

function TPaxScripter.CallFunction(const Name: String; const Params: array of const;
                                   AnObjectName: String = ''): Variant;
var
  SubID, ObjectID: Integer;
begin
  if ScripterState in [ssInit, ssReadyToCompile] then
  begin
    Compile;
    if IsError then
      Exit;
    result := CallFunction(Name, Params, AnObjectName);
    Exit;
  end;

  SubID := GetMemberID(Name);
  if SubID <> 0 then
  begin
    ObjectID := GetMemberID(AnObjectName);
    result := CallFunctionByID(SubID, Params, ObjectID);
  end
  else
    raise Exception.Create(Format(errFunctionNotFound, [Name]));
end;

function TPaxScripter.CallFunctionByIDEx(SubID: Integer;
                                         const Params: array of const;
                                         const StrTypes: array of String;
                                         ObjectID: Integer = 0): Variant;
var
  This: Variant;
begin
  case ScripterState of
    ssReadyToRun:
    begin
      fScripter.InitRunStage;
      fScripter.ClassList.InitStaticFields(0);
    end;
    ssTerminated:
    begin
      with fScripter.Code do
      begin
        DebugInfo.Clear;

//      UsingList.Clear;
//      WithStack.Clear;
        TryStack.Clear;
        RefStack.Clear;
        Stack.Clear;
        SubRunCount := 0;

      end;
      fScripter.VariantStack.Clear;
    end
  end;

  if ScripterState <> ssRunning then
  if Assigned(fOnBeforeRunStage) then
    fOnBeforeRunStage(Self);

  if ObjectID <> 0 then
    This := fScripter.SymbolTable.VariantValue[ObjectID]
  else
    This := Undefined;

  fScripter.State := Ord(ssRunning);
  result := fScripter.CallMethodEx(SubID, This, Params, StrTypes);
  ExtractCallStack;
  if IsObject(result) then
    result := Integer(VariantToScriptObject(result).Instance);

  if ScripterState <> ssRunning then
  begin
    if fScripter.Code.SignHaltGlobal then
      if Assigned(fScripter.OnHalt) then
         fScripter.OnHalt(Self);

    if Assigned(fOnAfterRunStage) then
      fOnAfterRunStage(Self);
  end;
end;

function TPaxScripter.CallFunctionEx(const Name: String; const Params: array of const;
                                     const StrTypes: array of String;
                                     AnObjectName: String = ''): Variant;
var
  SubID, ObjectID: Integer;
begin
  if ScripterState in [ssInit, ssReadyToCompile] then
  begin
    Compile;
    if IsError then
      Exit;
    result := CallFunction(Name, Params, AnObjectName);
    Exit;
  end;

  SubID := GetMemberID(Name);
  if SubID <> 0 then
  begin
    ObjectID := GetMemberID(AnObjectName);
    result := CallFunctionByIDEx(SubID, Params, StrTypes, ObjectID);
  end
  else
    raise Exception.Create(Format(errFunctionNotFound, [Name]));
end;

function TPaxScripter.CallMethod(const Name: String; const Params: array of const; Instance: TObject): Variant;
var
  SubID: Integer;
begin
  if ScripterState in [ssInit, ssReadyToCompile] then
  begin
    Compile;
    if IsError then
      Exit;
    result := CallMethod(Name, Params, Instance);
    Exit;
  end;

  SubID := GetMemberID(Name);
  if SubID <> 0 then
  begin
    result := CallMethodByID(SubID, Params, Instance);
  end
  else
    raise Exception.Create(Format(errMethodNotFound, [Name]));
end;

function TPaxScripter.CallMethod(const Name: String; const Params: array of const; const This: Variant): Variant;
var
  SubID: Integer;
begin
  if ScripterState in [ssInit, ssReadyToCompile] then
  begin
    Compile;
    if IsError then
      Exit;
    result := CallMethod(Name, Params, This);
    Exit;
  end;

  SubID := GetMemberID(Name);
  if SubID <> 0 then
  begin
    result := CallMethodByID(SubID, Params, This);
  end
  else
    raise Exception.Create(Format(errMethodNotFound, [Name]));
end;


function TPaxScripter.CallMethodByID(SubID: Integer;
                                     const Params: array of const; Instance: TObject): Variant;
var
  This: Variant;
begin
  case ScripterState of
    ssReadyToRun:
    begin
      fScripter.InitRunStage;
      fScripter.ClassList.InitStaticFields(0);
    end;
    ssTerminated:
    begin
      with fScripter.Code do
      begin
        DebugInfo.Clear;

//      UsingList.Clear;
//      WithStack.Clear;
        TryStack.Clear;
        RefStack.Clear;
        Stack.Clear;
        SubRunCount := 0;

      end;
      fScripter.VariantStack.Clear;
    end
  end;

  This := ScriptObjectToVariant(DelphiInstanceToScriptObject(Instance, fScripter));

  fScripter.State := Ord(ssRunning);
  result := fScripter.CallMethod(SubID, This, Params);
  ExtractCallStack;
  if IsObject(result) then
    result := Integer(VariantToScriptObject(result).Instance);
end;

function TPaxScripter.CallMethodByID(SubID: Integer;
                                     const Params: array of const; const This: Variant): Variant;
begin
  case ScripterState of
    ssReadyToRun:
    begin
      fScripter.InitRunStage;
      fScripter.ClassList.InitStaticFields(0);
    end;
    ssTerminated:
    begin
      with fScripter.Code do
      begin
        DebugInfo.Clear;

//      UsingList.Clear;
//      WithStack.Clear;
        TryStack.Clear;
        RefStack.Clear;
        Stack.Clear;
        SubRunCount := 0;

      end;
      fScripter.VariantStack.Clear;
    end
  end;

  fScripter.State := Ord(ssRunning);
  result := fScripter.CallMethod(SubID, This, Params);
  ExtractCallStack;
  if IsObject(result) then
    result := Integer(VariantToScriptObject(result).Instance);
end;


procedure TPaxScripter.InvokeOnAssignScript;
begin
  if Assigned(fOnAssignScript) then
  begin
    if ScripterState <> ssReadyToCompile then
    begin
      ScripterState := ssInit;
      fOnAssignScript(Self);
      ScripterState := ssReadyToCompile;
    end;
  end;
//  else
//    raise Exception.Create('OnAssignScript property is not assigned !');
end;

function TPaxScripter.Compile(SyntaxCheckOnly: Boolean = false): Boolean;

function HasSourceCodeModules: Boolean;
var
  I: Integer;
  M: TPaxModule;
begin
  for I:=0 to fScripter.Modules.Count - 1 do
  begin
    M := fScripter.Modules.Items[I];
    if M.IsSource then
    begin
      result := true;
      Exit;
    end;
  end;
  result := false;
end;

var
  P, I, J, K: Integer;
  M: TPaxModule;
  S, S1, FileExt: String;
  L: TStringList;
  Stream: TStream;
begin
  DiscardError;
  fScripter.Code.ResetCompileStage;
  fScripter.SymbolTable.ResetCompileStage;

  InvokeOnAssignScript;

  If Modules.Count = 0 then
    raise TPaxScriptFailure.Create(errScripterDosNotContainAnyModule);

  if HasSourceCodeModules then
    if Assigned(fOnBeforeCompileStage) then
       fOnBeforeCompileStage(Self);

  fScripter.State := Ord(ssCompiling);

  fScripter.AddDefs;
  fScripter.AddLocalDefs;

  fScripter.TotalLineCount := 0;
  for I:=0 to fScripter.Modules.Count - 1 do
  begin
    M := fScripter.Modules.Items[I];
    if M.IsSource then
    begin
      CompileModule(M.Name, SyntaxCheckOnly);
      if fScripter.IsError then
        Break;
    end
    else
    begin
      M.BuffStream.Position := 0;
      fScripter.LoadCompiledModuleFromStream(M, M.BuffStream);
    end;
  end;

  while fScripter.ExtraModuleList.Count > 0 do
  begin
    L := TStringList.Create;
    try
      for I:=0 to fScripter.ExtraModuleList.Count - 1 do
      begin
        S := fScripter.ExtraModuleList[I];

        P := Pos('=', S);
        if P > 0 then
        begin
          S1 := Copy(S, 1, P - 1);
          if Modules.IndexOf(S1) >= 0 then
            continue;
        end;

        L.Add(fScripter.ExtraModuleList[I]);
      end;

      fScripter.ExtraModuleList.Clear;

      for I:=0 to L.Count - 1 do
      begin
        S := L[I];

        if fScripter.IsCompiledScript(S) then
        begin
          Stream := TFileStream.Create(fScripter.FindFullName(S), fmOpenRead);
          try
            K := LoadInteger(Stream);
            for J:=0 to K - 1 do
            begin
              M := TPaxModule.Create(fScripter);
              M.FileName := fScripter.FindFullName(S);

              fScripter.LoadCompiledModuleFromStream(M, Stream);
              Modules.AddObject(M.Name, M);
              M.BuffStream.Position := 0;
              fScripter.LoadCompiledModuleFromStream(M, M.BuffStream);
            end;
          finally
            Stream.Free;
          end;
        end
        else
        begin
          M := TPaxModule.Create(fScripter);

          P := Pos('=', S);
          if P > 0 then
          begin
            M.Name := Copy(S, 1, P - 1);
            M.Text := Copy(S, P + 1, Length(S));
          end
          else
          begin
            M.Name := S;
            M.FileName := fScripter.FindFullName(M.Name);
          end;

          M.LanguageName := '';

          FileExt := ExtractFileExt(M.Name);

          if FileExt = '' then
          begin
            if StrEql('unit ', Copy(M.Text, 1, 5)) then
              M.LanguageName := 'paxPascal';
          end;

          for J:=0 to fScripter.ParserList.Count - 1 do
            if FileExt = fScripter.ParserList[J].FileExt then
            begin
              M.LanguageName := fScripter.ParserList[J].LanguageName;
              Break;
            end;

          if M.LanguageName = '' then
          begin
            fScripter.Error := errUnknownLanguage;
            raise TPaxScriptFailure.Create(errUnknownLanguage);
          end
          else
          begin
            fScripter.Modules.AddObject(M.Name, M);
            if M.Text = '' then
              AddCodeFromFile(M.Name, M.FileName);

            CompileModule(M.Name, SyntaxCheckOnly);
            if fScripter.IsError then
              Break;
          end;
        end;
        if fScripter.IsError then
          Break;
      end;
    finally
      L.Free;
    end;
  end;

  SetScripterState(ssCompiled);

  if not IsError then if not SyntaxCheckOnly then
  begin
    fScripter.CheckForUndeclared;
    if IsError then
    begin
      Dump();
      if Assigned(fScripter.OnShowError) then
        fScripter.OnShowError(fScripter.Owner)
      else
        fScripter.ShowError;
    end;
  end;

  if IsError then
    ScripterState := ssReadyToCompile
  else
    fScripter.Link(false);

  if SyntaxCheckOnly then
    ScripterState := ssReadyToCompile;

  if HasSourceCodeModules then
    if Assigned(fOnAfterCompileStage) then
      fOnAfterCompileStage(Self);

  result := not  IsError;
end;

procedure TPaxScripter.RunInstruction;
begin
  with fScripter.Code do
    ArrProc[Prog[N].Op];
end;

function TPaxScripter.InstructionCount: Integer;
begin
  result := fScripter.Code.Card;
end;

function TPaxScripter.CurrentInstructionNumber: Integer;
begin
  result := fScripter.Code.N;
end;

function TPaxScripter.GetInstruction(N: Integer): TPaxInstruction;
begin
  with fScripter.Code.Prog[N] do
  begin
    result.N := N;
    result.Op := Op;
    result.Arg1 := Arg1;
    result.Arg2 := Arg2;
    result.Res := Res;
  end;
end;

procedure TPaxScripter.SetInstruction(N: Integer; I: TPaxInstruction);
begin
  with fScripter.Code.Prog[N] do
  begin
    Op := I.Op;
    Arg1 := I.Arg1;
    Arg2 := I.Arg2;
    Res := I.Res;
  end;
end;

procedure TPaxScripter.Run(RunMode: Integer = rmRun; const ModuleName: String = ''; LineNumber: Integer = 0);
var
  I, PCodeLineNumber: Integer;
  M: TPaxModule;
begin
  if _IsTrial then
    AskToRegister;

  if not (ScripterState in [ssReadyToRun, ssPaused, ssTerminated, ssRunning]) then
  begin
    Compile;
    if IsError then
      Exit;
  end;

  case ScripterState of
    ssReadyToRun:
      fScripter.InitRunStage;
    ssTerminated:
    begin
      fScripter.ResetRunStage;
      fScripter.InitRunStage;
    end;
  end;

  if fScripter.IsError then
    Exit;

  if Assigned(fOnBeforeRunStage) then
    fOnBeforeRunStage(Self);

  PCodeLineNumber := fScripter.SourceLineToPCodeLine(ModuleName, LineNumber);

  if (LineNumber = 0) and (ModuleName <> '') then
    for I:=1 to fScripter.RunList.Card do
      if fScripter.RunList[I] = 0 then
        fScripter.RunList.fItems[I] := PCodeLineNumber;

  if (RunMode in [rmRun, rmStepOver, rmTraceInto]) and (PCodeLineNumber <> -1) then
  begin
    if LineNumber = 0 then
    while fScripter.Code.Prog[PCodeLineNumber].Op <> OP_BEGIN_WITH do
      Dec(PCodeLineNumber);
    fScripter.Code.N := PCodeLineNumber - 1;

    fScripter.Run(RunMode, -1);
  end
  else
  begin
    //run module
    if (ModuleName <> '') and (LineNumber = 0) then
    begin
      I := fScripter.Modules.IndexOf(ModuleName);
      if I <> -1 then
      begin
        M := fScripter.Modules.Items[I];
        fScripter.Code.N := M.P1 - 1;
        fScripter.Run(RunMode, -1);
      end;
    end //run module
    else
      fScripter.Run(RunMode, PCodeLineNumber);
  end;
  ExtractCallStack;

  if fScripter.Code.SignHaltGlobal then
  if Assigned(fScripter.OnHalt) then
    fScripter.OnHalt(Self);

  if Assigned(fOnAfterRunStage) then
    fOnAfterRunStage(Self);
end;

procedure TPaxScripter.Dump;
begin
  fScripter.Dump;
end;

function TPaxScripter.IsError: Boolean;
begin
  result := fScripter.IsError;
end;

procedure TPaxScripter.DiscardError;
begin
  fScripter.DiscardError;
end;

function TPaxScripter.GetOverrideHandlerMode: TPaxOverrideHandlerMode;
begin
  result := TPaxOverrideHandlerMode(fScripter.OverrideHandlerMode);
end;

procedure TPaxScripter.SetOverrideHandlerMode(Value: TPaxOverrideHandlerMode);
begin
  fScripter.OverrideHandlerMode := Integer(Value);
end;

function TPaxScripter.GetScripterState: TScripterState;
begin
  result := TScripterState(fScripter.State);
end;

procedure TPaxScripter.SetScripterState(Value: TScripterState);

procedure SetInit;
begin
  case ScripterState of
    ssInit: begin end;
  else
    begin
      fScripter.Modules.Clear;
      fScripter.ResetCompileStage;
    end;
  end;
  fScripter.State := Ord(ssInit);

  DiscardError;
end;

procedure SetReadyToCompile;
begin
  case ScripterState of
    ssInit: begin end;
    ssReadyToCompile: begin end;
    ssCompiling:
      begin
        fScripter.ResetCompileStage;
      end;
    ssCompiled:
      begin
        fScripter.ResetCompileStage;
      end;
    ssLinking:
      begin
        fScripter.ResetCompileStage;
      end;
    ssReadyToRun:
      begin
        fScripter.ResetCompileStage;
      end;
    ssRunning:
      begin
        fScripter.ResetRunStage;
        fScripter.ResetCompileStage;
      end;
    ssPaused:
      begin
        fScripter.ResetCompileStage;
      end;
    ssTerminated:
      begin
        fScripter.ResetCompileStage;
      end;
  end;

  fScripter.State := Ord(ssReadyToCompile);
end;

procedure SetCompiling;
var
  I: Integer;
begin
  fScripter.State := Ord(ssReadyToCompile);
  fScripter.State := Ord(ssCompiling);

  fScripter.TotalLineCount := 0;
  for I:=0 to fScripter.Modules.Count - 1 do
  begin
    CompileModule(fScripter.Modules.Items[I].Name);
    if fScripter.IsError then
      Break;
  end;

  SetScripterState(ssCompiled);
end;

procedure SetCompiled;
begin
  fScripter.State := Ord(ssCompiled);
end;

procedure SetLinking;
begin
  fScripter.State := Ord(ssLinking);
end;

procedure SetReadyToRun;
begin
  case ScripterState of
    ssReadyToCompile:
      begin
        SetScripterState(ssCompiling);
        if not IsError then
          SetScripterState(ssReadyToRun);
      end;
    ssCompiled:
    begin
      fScripter.Link(true);
      fScripter.State := Ord(ssReadyToRun);
    end;
    ssPaused:
    begin
      fScripter.ResetRunStage;
    end;
    ssTerminated:
    begin
      fScripter.ResetRunStage;
    end;
  end;
  fScripter.State := Ord(ssReadyToRun);
//  fScripter.InitRunStage;
end;

procedure SetRunning;
begin
  fScripter.State := Ord(ssRunning);
  fScripter.Code.Terminated := false;
end;

procedure SetPaused;
begin
  if ScripterState = ssTerminated then
  begin
    fScripter.ResetRunStage;
    fScripter.InitRunStage;
  end;

  fScripter.State := Ord(ssPaused);
  fScripter.Code.CurrRunMode := _rmTraceInto;
end;

procedure SetTerminated;
begin
  fScripter.State := Ord(ssTerminated);
  fScripter.Code.Terminated := true;
  fScripter.Code.N := fScripter.Code.Card;
end;

begin
  case Value of
    ssInit: SetInit;
    ssReadyToCompile: SetReadyToCompile;
    ssCompiling: SetCompiling;
    ssCompiled: SetCompiled;
    ssLinking: SetLinking;
    ssReadyToRun: SetReadyToRun;
    ssRunning: SetRunning;
    ssPaused: SetPaused;
    ssTerminated: SetTerminated;
  end;
end;

procedure TPaxScripter.RemoveAllBreakpoints;
begin
  fScripter.RemoveAllBreakpoints;
end;

function TPaxScripter.AddBreakpoint(const ModuleName: String;
                                    LineNumber: Integer; const Condition: String = ''; PassCount: Integer = 0): Boolean;
begin
  result := fScripter.AddBreakpoint(ModuleName, LineNumber, Condition, PassCount);
end;

function TPaxScripter.RemoveBreakpoint(const ModuleName: String;
                                    LineNumber: Integer): Boolean;
begin
  result := fScripter.RemoveBreakpoint(ModuleName, LineNumber, '', 0);
end;

function TPaxScripter.GetCurrentSourceLine: Integer;
begin
  result := fScripter.Code.LineID;
end;

function TPaxScripter.GetCurrentModuleName: String;
var
  ModuleID: Integer;
begin
  ModuleID := fScripter.Code.ModuleID;
  if ModuleID = -1 then
    result := ''
  else
    result := fScripter.Modules.Items[ModuleID].Name;
end;

function TPaxScripter.ToString(const V: Variant): String;
begin
  result := ToStr(fScripter, V);
end;

procedure TPaxScripter.ExtractCallStack;
var
  I, J, N, SubID, ParamCount: Integer;
  CSR: TCallStackRecord;
  P: Pointer;
begin
  CallStack.Clear;
  I := fScripter.Code.DebugInfo.Card;

  repeat

    if I = 0 then
      Exit;

    CSR := TCallStackRecord.Create;

    SubID := fScripter.Code.DebugInfo[I];
    Dec(I);
    N := fScripter.Code.DebugInfo[I];
    Dec(I);
    ParamCount := fScripter.Code.DebugInfo[I];

    for J:=1 to ParamCount do
    begin
      Dec(I);
      P := Pointer(fScripter.Code.DebugInfo[I]);
      CSR.Parameters.Add(ToStr(fScripter, Variant(P^)));
    end;

    CSR.ProcName := fScripter.SymbolTable.Name[SubID];

    fScripter.Code.SaveState;
    fScripter.Code.N := N;

    CSR.LineNumber := CurrentSourceLine;
    CSR.ModuleName := CurrentModuleName;

    fScripter.Code.RestoreState;

    CallStack.Add(CSR);

    Dec(I);
  until false;
end;

function TPaxScripter.GetSourceCode(const ModuleName: String): String;
var
  I: Integer;
begin
  I := fScripter.Modules.IndexOf(ModuleName);
  if I = -1 then
    raise Exception.Create(Format(errModuleNotFound, [ModuleName]));

  result := fScripter.Modules.Items[I].Text;
end;

procedure TPaxScripter.SetSourceCode(const ModuleName, SourceCode: String);
var
  I: Integer;
begin
  I := fScripter.Modules.IndexOf(ModuleName);
  if I = -1 then
    raise Exception.Create(Format(errModuleNotFound, [ModuleName]));

  fScripter.Modules.Items[I].Text := SourceCode;
end;

procedure TPaxScripter.LoadProject(const FileName: String);
var
  L: TStringList;
  I: Integer;
begin
  if not FileExists(FileName) then
    raise Exception.Create(Format(errFileNotFound, [FileName]));

  fScripter.Modules.Clear;
  L := TStringList.Create;
  try
    L.LoadFromFile(FileName);
    for I:=0 to L.Count - 1 do
    if Pos('#!', L[I]) = 0 then
    begin
      AddModule(L[I], FileExtToLanguageName(L[I]));
      AddCodeFromFile(L[I], L[I]);
    end;
  finally
    L.Free;
  end;
end;

function RunFile(const FileName: String; PaxScripter: TPaxScripter): Boolean;
begin
  PaxScripter.ResetScripter;
  PaxScripter.LoadProject(FileName);
  PaxScripter.Run;
  result := PaxScripter.IsError;
end;

function RunString(const Script, LanguageName: String; PaxScripter: TPaxScripter): Boolean;
const
  ModuleName = 'main';
begin
  PaxScripter.ResetScripter;
  PaxScripter.AddModule(ModuleName, LanguageName);
  PaxScripter.AddCode(ModuleName, Script);
  PaxScripter.Run;
  result := PaxScripter.IsError;
end;

function TPaxScripter.GetErrorClassType: TClass;
begin
  result := fScripter.ErrorInstance.ErrClassType;
end;

function TPaxScripter.GetErrorDescription: String;
begin
  result := fScripter.ErrorInstance.Description;
end;

function TPaxScripter.GetErrorModuleName: String;
begin
  result := fScripter.ErrorInstance.ModuleName;
end;

function TPaxScripter.GetErrorTextPos: Integer;
begin
  result := fScripter.ErrorInstance.TextPosition;
end;

function TPaxScripter.GetErrorPos: Integer;
begin
  result := fScripter.ErrorInstance.Position;
end;

function TPaxScripter.GetErrorLine: Integer;
begin
  result := fScripter.ErrorInstance.LineNumber
end;

function TPaxScripter.GetErrorMethodId: Integer;
begin
  result := fScripter.ErrorInstance.MethodId;
end;

procedure TPaxScripter.RegisterVariable(const Name, TypeName: String; Address: Pointer; Owner: Integer = -1);
var
  O: TPAXClassDefinition;
  D: TPAXVariableDefinition;
begin
  if Owner = -1 then
    O := nil
  else
    O := DefinitionList[Owner];

  D := TPAXVariableDefinition(fScripter.LocalDefinitions.Lookup(Name, dkVariable, O, fScripter));
  if D <> nil then
  begin
    UnregisterVariable(Name, Owner);
    RegisterVariable(Name, TypeName, Address, Owner);
    Exit;
  end;

  fScripter.LocalDefinitions.AddVariable(Name, TypeName, Address, O, fScripter);
end;

procedure TPaxScripter.RegisterConstant(const Name: String; Value: Variant; Owner: Integer = -1);
var
  O: TPAXClassDefinition;
  D: TPAXConstantDefinition;
begin
  if Owner = -1 then
    O := nil
  else
    O := DefinitionList[Owner];

  D := TPAXConstantDefinition(fScripter.LocalDefinitions.Lookup(Name, dkConstant, O, fScripter));
  if D <> nil then
  begin
    UnregisterConstant(Name, Owner);
    RegisterConstant(Name, Value, Owner);
    Exit;
//    D.Value := Value;
    Exit;
  end;

  fScripter.LocalDefinitions.AddConstant(Name, Value, O, true, ckNone, fScripter);
end;

procedure TPaxScripter.RegisterObject(const Name: String; Instance: TObject; Owner: Integer = -1);
var
  O: TPAXClassDefinition;
  C: TComponent;
  I: Integer;
  AClass: TClass;
  D: TPAXObjectDefinition;
begin
  if Owner = -1 then
    O := nil
  else
    O := DefinitionList[Owner];

  D := TPAXObjectDefinition(fScripter.LocalDefinitions.Lookup(Name, dkObject, O, fScripter));
  if D <> nil then
  begin
    UnregisterObject(Name, Owner);
    RegisterObject(Name, Instance, Owner);
    Exit;
  end;

  if Instance.InheritsFrom(TComponent) then
  begin
    C := TComponent(Instance);
    for I:=0 to C.ComponentCount - 1 do
    begin
      AClass := C.Components[I].ClassType;

      if DefinitionList.FindClassDef(AClass) = nil then
        DefinitionList.AddClass2(AClass, nil, nil, nil);
    end;
  end;

  if DefinitionList.FindClassDef(Instance.ClassType) = nil then
     DefinitionList.AddClass2(Instance.ClassType, nil, nil, nil);

  fScripter.LocalDefinitions.AddObject(Name, Instance, O, fScripter);
end;

procedure TPaxScripter.RegisterVirtualObject(const Name: String; Owner: Integer = -1);
var
  O: TPAXClassDefinition;
begin
  if Owner = -1 then
    O := nil
  else
    O := DefinitionList[Owner];

  fScripter.LocalDefinitions.AddVirtualObject(Name, O, fScripter);
end;

procedure TPaxScripter.RegisterObjectSimple(const Name: String; Instance: TObject; Owner: Integer = -1);
var
  O: TPAXClassDefinition;
begin
  if Owner = -1 then
    O := nil
  else
    O := DefinitionList[Owner];
  fScripter.LocalDefinitions.AddObject(Name, Instance, O, fScripter);
end;

procedure TPaxScripter.RegisterInterfaceVar(const Name: String; PIntf: PUnknown;
                                            const guid: TGUID;
                                            Owner: Integer = -1);
var
  O: TPAXClassDefinition;
  D: TPAXInterfaceVarDefinition;
begin
  if Owner = -1 then
    O := nil
  else
    O := DefinitionList[Owner];

  D := TPAXInterfaceVarDefinition(fScripter.LocalDefinitions.Lookup(Name, dkInterface, O, fScripter));
  if D <> nil then
  begin
//    if D.PIntf <> nil then
//      D.PIntf^ := nil;
    D.PIntf := PIntf;
    D.guid := guid;
    Exit;
  end;

  fScripter.LocalDefinitions.AddInterfaceVar(Name, PIntf, guid, O, fScripter);
end;

procedure TPaxScripter.Unregister(What: TPAXDefKind; const Name: String; Owner: Integer = -1);
var
  O: TPAXClassDefinition;
  ClassRec: TPaxClassRec;
begin
  if Owner = -1 then
    O := nil
  else
    O := DefinitionList[Owner];

  fScripter.LocalDefinitions.Unregister(Name, What, O, Self.fScripter);

  if O = nil then
    ClassRec := fScripter.ClassList[0]
  else
    ClassRec := fScripter.ClassList.FindClassByName(O.Name);
  ClassRec.MemberList.DeleteMember(Name, true);
end;

procedure TPaxScripter.UnregisterObject(const Name: String; Owner: Integer = -1);
var
  D: TPaxObjectDefinition;
  O: TPAXClassDefinition;
  I: Integer;
begin
  if Owner = -1 then
    O := nil
  else
    O := DefinitionList[Owner];

  D := TPAXObjectDefinition(fScripter.LocalDefinitions.Lookup(Name, dkObject, O, fScripter));
  if D <> nil then
  begin
    I := fScripter.ScriptObjectList.IndexOfDelphiObject(D.Instance);
    if I >= 0 then
      fScripter.ScriptObjectList.Delete(I);
  end;

  Unregister(dkObject, Name, Owner);
end;

procedure TPaxScripter.UnregisterObject(Instance: TObject; Owner: Integer = -1);
var
  O: TPAXClassDefinition;
  D: TPaxObjectDefinition;
  I: Integer;
  ClassRec: TPaxClassRec;
begin
  if Owner = -1 then
    O := nil
  else
    O := DefinitionList[Owner];

  I := fScripter.ScriptObjectList.IndexOfDelphiObject(Instance);
  if I >= 0 then
    fScripter.ScriptObjectList.Delete(I);

  D := fScripter.LocalDefinitions.FindObjectDef(Instance, O);
  if D <> nil then
  begin
    fScripter.LocalDefinitions.UnregisterObject(Instance, O);
    if O = nil then
      ClassRec := fScripter.ClassList[0]
    else
      ClassRec := fScripter.ClassList.FindClassByName(O.Name);
    ClassRec.MemberList.DeleteMember(D.Name, true);
  end;
end;

procedure TPaxScripter.UnregisterConstant(const Name: String; Owner: Integer = -1);
begin
  Unregister(dkConstant, Name, Owner);
end;

procedure TPaxScripter.UnregisterVariable(const Name: String; Owner: Integer = -1);
begin
  Unregister(dkVariable, Name, Owner);
end;

procedure TPaxScripter.UnregisterAllVariables;
begin
  fScripter.LocalDefinitions.UnregisterAll(dkVariable, Self.fScripter);
end;

procedure TPaxScripter.UnregisterAllObjects;
var
  I, Index: Integer;
  D: TPaxObjectDefinition;
begin
  for I:=0 to fScripter.LocalDefinitions.Count - 1 do
  if Assigned(fScripter.LocalDefinitions.Records[I]) and
     (fScripter.LocalDefinitions.Records[I].DefKind = dkObject) then
  begin
    D := TPaxObjectDefinition(fScripter.LocalDefinitions.Records[I]);
    Index := fScripter.ScriptObjectList.IndexOfDelphiObject(D.Instance);
    if Index >= 0 then
      fScripter.ScriptObjectList.Delete(Index);
  end;
  fScripter.LocalDefinitions.UnregisterAll(dkObject, Self.fScripter);
end;

procedure TPaxScripter.UnregisterAllConstants;
begin
  fScripter.LocalDefinitions.UnregisterAll(dkConstant, Self.fScripter);
end;

procedure TPaxScripter.ForbidAllPublishedProperties(AClass: TClass);
begin
  fScripter.ForbiddenPublishedProperties.Add(AClass);
end;

procedure TPaxScripter.ForbidPublishedProperty(AClass: TClass; const PropName: String);
begin
  fScripter.ForbiddenPublishedPropertiesEx.AddObject(PropName, TObject(AClass));
end;

procedure TPaxScripter.GetClassInfo(const FullName: String; mk: TPaxMemberKind; L: TStrings);
var
  ClassRec: TPaxClassRec;
  MemberRec: TPaxMemberRec;
  I, ID: integer;
  S: String;
  ClassDef: TPaxClassDefinition;
  PClass: TClass;
begin
  ID := GetMemberID(FullName);
  if ID = 0 then
    Exit;

  ClassRec := fScripter.ClassList.FindClass(ID);
  PClass := nil;

  repeat

    if ClassRec = nil then
      break;

    if PClass = nil then
    begin
      ClassDef := ClassRec.GetClassDef;
      if ClassDef <> nil then
        PClass := ClassDef.PClass;
    end;


    for I:= 0 to ClassRec.MemberList.Count - 1 do
    begin
      MemberRec := ClassRec.MemberList.Records[I];
      if MemberRec.ID <> 0 then
      begin
        S := MemberRec.GetName;
        if L.IndexOf(S) >= 0 then
           continue;
        case mk of
          mkMethod:
          begin
            if MemberRec.Kind = KindSUB then
            begin
              if PosCh('_', S) > 0 then
                continue;
              L.AddObject(S, TObject(MemberRec.ID));
            end;
          end;
          mkField:
          begin
            if MemberRec.Kind = KindVAR then
              L.AddObject(S, TObject(MemberRec.ID));
          end;
          mkProp:
          begin
            if MemberRec.Kind = KindPROP then
              L.AddObject(S, TObject(MemberRec.ID));
          end;
        end;
      end;
    end;

    if ClassRec.AncestorClassRec = nil then break;
    ClassRec := ClassRec.AncestorClassRec;

  until false;

  if mk = mkProp then
  if PClass <> nil then
    GetPublishedPropertiesEx2(PClass, L);

  if mk = mkEvent then
  if PClass <> nil then
    GetPublishedEvents(PClass, L);
end;

function TPaxScripter.GetHostClass(const FullName: String): TClass;
var
  ClassRec: TPaxClassRec;
  ID: integer;
  ClassDef: TPaxClassDefinition;
begin
  result := nil;

  ID := GetMemberID(FullName);
  if ID = 0 then
    Exit;
  ClassRec := fScripter.ClassList.FindClass(ID);
  repeat
    if ClassRec = nil then
      break;
    if result = nil then
    begin
      ClassDef := ClassRec.GetClassDef;
      if ClassDef <> nil then
        result := ClassDef.PClass;
    end;
    if ClassRec.AncestorClassRec = nil then break;
    ClassRec := ClassRec.AncestorClassRec;
  until false;
end;


procedure TPaxScripter.SaveToStream(S: TStream);
begin
  fScripter.SaveToStream(S);
end;

procedure TPaxScripter.LoadFromStream(S: TStream);
begin
  SetUpSearchPathes;

  fScripter.LoadFromStream(S);
  fScripter.State := Ord(ssReadyToCompile);
end;

procedure TPaxScripter.SaveToFile(const FileName: String);
var
  S: TStream;
begin
  S := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(S);
  finally
    S.Free;
  end;
end;

procedure TPaxScripter.LoadFromFile(const FileName: String);
var
  S: TStream;
begin
  S := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TPaxScripter.ResetScripter;
begin
  ScripterState := ssInit;
  fScripter._ObjCount := 0;
end;

procedure TPaxScripter.ResetScripterEx;
begin
  UnregisterAllObjects;

  fScripter.Modules.Clear;
  fScripter.ResetScripterEx;

  fScripter.State := Ord(ssInit);
  DiscardError;
  fScripter._ObjCount := 0;
end;


procedure TPaxScripter.Terminate;
begin
  fScripter.Code.Terminated := true;
end;

procedure TPaxScripter.DisconnectObjects;
begin
  fScripter.DisconnectObjects;
end;

function TPaxScripter.GetParam(const ParamName: String): Variant;
begin
  result := fScripter.ParamList.GetParam(ParamName);
end;

procedure TPaxScripter.SetParam(const ParamName: String; const Value: Variant);
begin
  fScripter.ParamList.SetParam(ParamName, Value);
end;

procedure TPaxScripter.RegisterField(const ObjectName: String;
                                     ObjectType: String;
                                     FieldName: String;
                                     FieldType: String;
                                     Address: Pointer);
begin
  fScripter.RegisteredFieldList.AddRec(ObjectName, ObjectType,
                                       FieldName, FieldType, Address);
end;

function TPaxScripter.GetLastResult: Variant;
begin
  with fScripter do
  if LastResultID = 0 then
    result := Undefined
  else
  begin
    if LastResultID > SymbolTable.Card then
      result := fLastResult
    else
      result := SymbolTable.GetVariant(LastResultID)
  end;
end;

function TPaxScripter.GetSourceLine(const ModuleName: String; LineNumber: Integer): String;
var
  L: TStringList;
begin
  L := TStringList.Create;
  L.Text := GetSourceCode(ModuleName);
  if (LineNumber >= 0) and (LineNumber < L.Count - 1) then
    result := L[LineNumber]
  else
    result := '';
  L.Free;
end;

function TPaxScripter.IsExecutableSourceLine(const ModuleName: String; L: Integer): Boolean;
begin
  result := fScripter.Code.IsExecutableSourceLine(ModuleName, L);
end;

procedure TPaxScripter.CancelCompiling(const AMessage: String);
begin
  if ScripterState = ssCompiling then
     fScripter.CancelMessage := AMessage;
end;

function TPaxScripter.GetRootID: Integer;
begin
  result := fScripter.ClassList[0].ClassID;
end;

function TPaxScripter.ToScriptObject(DelphiInstance: TObject): Variant;
begin
  result := ScriptObjectToVariant(DelphiInstanceToScriptObject(DelphiInstance, fScripter));
end;

function TPaxScripter.AssignEventHandler(Instance: TObject; EventPropName: String; EventHandlerName: String): Boolean;
var
  SubID: Integer;
  V, This: Variant;
  SO: TPaxScriptObject;
  pti: PTypeInfo;
  PropInfo: PPropInfo;
  EventHandler: TPaxEventHandler;
  M: TMethod;
begin
  result := false;
  SubID := GetMemberID(EventHandlerName);
  if (SubID = 0) or (SubID = -1) then
    Exit;
  V := fScripter.SymbolTable.GetVariant(SubID);
  SO := VariantToScriptObject(V);

  pti := PTypeInfo(Instance.ClassType.ClassInfo);

  if pti = nil then
    PropInfo := nil
  else
    PropInfo := GetPropInfo(pti, EventPropName);

  if PropInfo = nil then
    Exit;

{$ifdef fp}
  if PropInfo.PropType^.Kind = tkMethod then
{$else}
  if PropInfo.PropType^^.Kind = tkMethod then
{$endif}
  begin
    if SO.ClassRec.AncestorName = 'Function' then
      SubID := SO.ClassRec.GetConstructorID
    else
      SubID := TPAXDelegate(SO.Instance).SubID;

    This := ScriptObjectToVariant(DelphiInstanceToScriptObject(Instance, fScripter));

{$ifdef fp}
    EventHandler := TPAXEventHandler.Create(fScripter, PropInfo.PropType, SubID, This);
{$else}
    EventHandler := TPAXEventHandler.Create(fScripter, PropInfo.PropType^, SubID, This);
{$endif}

    M.Code := @TPAXEventHandler.HandleEvent;
    M.Data := Pointer(EventHandler);
    fScripter.EventHandlerList.Add(EventHandler);

    SetMethodProp(Instance, PropInfo, M);

    EventHandler.DelphiInstance := Instance;
    EventHandler.PropInfo := PropInfo;

    EventHandler.This := Undefined;

    result := true;
  end;
end;

procedure TPaxScripter.EnumMembers(ID: Integer;
                                   Module: Integer;
                                   CallBack: TPaxMemberCallBack;
                                   Data: Pointer);
var
  I, K, N, IDL, ResID, SubID: Integer;
  mk: TPaxMemberKind;
  MemberRec: TPAXMemberRec;
  ClassRec, MemberClassRec: TPAXClassRec;
  L: TStringList;
begin
  if ID = 0 then
    Exit;

  K := fScripter.SymbolTable.Kind[ID];
  if K = KindTYPE then
  begin
    ClassRec := fScripter.ClassList.FindClass(ID);
    if ClassRec = nil then
      Exit;

    if ClassRec.IsImported then
    if ClassRec.fClassDef <> nil then
    if ClassRec.fClassDef.PClass <> nil then
    begin
      L := TStringList.Create;
      GetPublishedPropertiesEx(ClassRec.fClassDef.PClass, L);
      for I:=0 to L.Count - 1 do
      begin
        CallBack(L[I], 0, mkProp, [], Data);
      end;
      L.Free;
    end;

    for I:=0 to ClassRec.MemberList.Count - 1 do
    begin
      MemberRec := ClassRec.MemberList[I];
      mk := mkUnknown;

      case MemberRec.Kind of
        KindVAR: mk := mkField;
        KindCONST: mk := mkConst;
        KindSUB: mk := mkMethod;
        KindPROP:
        begin
          mk := mkProp;
          if MemberRec.ID = 0 then
            if MemberRec.Definition <> nil then
              MemberRec.ID := - MemberRec.Definition.Index;
        end;
        KindTYPE:
        begin
          MemberClassRec := fScripter.ClassList.FindClass(MemberRec.ID);
          if MemberClassRec <> nil then
          case MemberClassRec.ck of
            ckClass:
            begin
              mk := mkClass;
              if MemberClassRec.IsStatic then
                mk := mkNamespace;
            end;
            ckStructure: mk := mkStructure;
            ckEnum: mk := mkEnum;
          end;
        end;
      end;

      if MemberRec.ID > 0 then
      begin
       if (Module = GetModule(MemberRec.ID)) then
          CallBack(MemberRec.GetName(), MemberRec.ID, mk,
                   TPAXModifierList(MemberRec.ml), Data)
        else if (mk = mkClass) and (Module >= 0) then
          CallBack(MemberRec.GetName(), MemberRec.ID, mk,
                   TPAXModifierList(MemberRec.ml), Data)
        else if (mk = mkNamespace) and (Module >= 0) then
          CallBack(MemberRec.GetName(), MemberRec.ID, mk,
                   TPAXModifierList(MemberRec.ml), Data);
      end
      else if MemberRec.ID <> 0 then
      begin
        if (Module < 0) or (Module > MaxModuleNumber) then
        if Module = GetModule(MemberRec.ID) then
          CallBack(MemberRec.GetName(), MemberRec.ID, mk,
                   TPAXModifierList(MemberRec.ml), Data);
      end;
    end;
  end
  else if K = KindSUB then
  begin
     SubID := ID;

     N := fScripter.SymbolTable.Count[SubID];
     IDL := fScripter.SymbolTable.GetParamID(SubID, N);
     ResID := fScripter.SymbolTable.GetResultID(SubID);

     for ID := SubID + 1 to fScripter.SymbolTable.Card do
       if fScripter.SymbolTable.Level[ID] = SubID then
       begin
         K := fScripter.SymbolTable.Kind[ID];
         mk := mkUnknown;
         if ID = ResID then
           mk := mkResult
         else if (ID > ResID + 1) and (ID <= IDL) then
           mk := mkParam
         else
           case K of
             KindVAR:
               if ChPos('$', fScripter.SymbolTable.Name[ID]) = 0 then
                 mk := mkField;
             KindSUB: mk := mkMethod;
             KindTYPE:
             begin
               ClassRec := fScripter.ClassList.FindClass(ID);
               if ClassRec <> nil then
                 case ClassRec.ck of
                   ckClass: mk := mkClass;
                   ckStructure: mk := mkStructure;
                   ckEnum: mk := mkEnum;
                 end;
             end;
           end;

         if fScripter.SymbolTable.Module[ID] = Module then
            if fScripter.SymbolTable.IsLocal(ID) or (mk = mkParam) or
               (ID = fScripter.SymbolTable.GetThisID(SubID))
            then
              CallBack(fScripter.SymbolTable.Name[ID], ID, mk, [], Data);
       end;
  end;
end;

procedure TPaxScripter.Rename(ID: Integer; const NewName: String);
var
  OldName: String;
  L, OldNameIndex, NewNameIndex, I: Integer;
  ClassRec: TPaxClassRec;
  MemberRec: TPaxMemberRec;
begin
  if ID <= 0 then
    Exit;
  OldName := fScripter.SymbolTable.Name[ID];
  fScripter.SymbolTable.Name[ID] := NewName;

  L := fScripter.SymbolTable.Level[ID];
  ClassRec := fScripter.ClassList.FindClass(L);
  if ClassRec = nil then Exit;

  OldNameIndex := CreateNameIndex(OldName, fScripter);
  NewNameIndex := CreateNameIndex(NewName, fScripter);

  MemberRec := ClassRec.GetMember(OldNameIndex);

  if MemberRec = nil then Exit;

  I := ClassRec.MemberList.IndexOf(OldNameIndex);
  if I >= 0 then
    ClassRec.MemberList.NameID[I] := NewNameIndex;
end;

function TPAXScripter.RegisterParser(ParserClass: TPAXParserClass; const LanguageName, FileExt: String;
                                     CallConvention: TPAXCallConv): Integer;
var
  Parser: TPaxParser;
begin
  Parser := ParserClass.Create;

  result := fScripter.ParserList.IndexOf(Parser);
  if result = -1 then
  begin
    result := fScripter.ParserList.Add(Parser);
    Parser.LanguageName := LanguageName;
    Parser.FileExt := FileExt;
    Parser.DefaultCallConv := Ord(CallConvention);
  end;
end;

procedure TPAXScripter.RegisterLanguages;
var
  I: Integer;
  C: TComponent;
  L: TPaxLanguage;
begin
  if Owner = nil then
    Exit;

  for I:=0 to Owner.ComponentCount - 1 do
  begin
    C := TComponent(Owner.Components[I]);
    if C.InheritsFrom(TPaxLanguage) then
    begin
      L := TPaxLanguage(C);
      if FindLanguage(L.GetLanguageName) = nil then
        RegisterLanguage(L);
    end;
  end;
end;

procedure TPAXScripter.UnregisterLanguages;
var
  I: Integer;
  C: TComponent;
  L: TPaxLanguage;
begin
  if Owner = nil then
    Exit;

  for I:=0 to Owner.ComponentCount - 1 do
  begin
    C := TComponent(Owner.Components[I]);
    if C.InheritsFrom(TPaxLanguage) then
    begin
      L := TPaxLanguage(C);
      if FindLanguage(L.LanguageName) <> nil then
        UnRegisterLanguage(L.LanguageName);
    end;
  end;
end;

procedure TPAXScripter.RegisterLanguage(L: TPaxLanguage);
var
  I: Integer;
begin
  I := RegisterParser(L.GetPAXParserClass,
                      L.GetLanguageName, '.' + L.GetFileExt,
                      L.CallConvention);
  fScripter.ParserList[I]._Language := L;
  fScripter.ParserList[I].DefaultCallConv := Ord(L.CallConvention);

  L.RegisterScripter(Self);
end;

procedure TPAXScripter.UnregisterLanguage(const LanguageName: String);
var
  I: Integer;
begin
  for I:=fScripter.ParserList.Count - 1 downto 0 do
    if StrEql(fScripter.ParserList[I].LanguageName, LanguageName) then
    begin
      TPaxLanguage(fScripter.ParserList[I]._Language).UnregisterScripter(Self);
      fScripter.ParserList.RemoveParser(I);
      Break;
    end;
end;

procedure TPaxScripter.AssignEventHandlerRunner(MethodAddress: Pointer;
                                                Instance: TObject);
begin
  fScripter.OwnerEventHandlerMethod.Code := MethodAddress;
  fScripter.OwnerEventHandlerMethod.Data := Instance;
end;

procedure TPaxScripter.SetUpSearchPathes;
var
  I: Integer;
  S: String;
begin
  fScripter.fSearchPathes.Clear;
  for I:=0 to fSearchPathes.Count - 1 do
  begin
    S := fSearchPathes[I];
    if Length(S) > 0 then
    begin
      if S[Length(S)] <> PathDelim then
        S := S + PathDelim;

      fScripter.fSearchPathes.Add(S);
    end;
  end;
end;

function TPaxScripter.FindFullFileName(const FileName: String): String;
begin
  result := fScripter.FindFullName(FileName);
end;

function TPaxScripter.FindNamespaceHandle(const Name: String): Integer;
var
  I: Integer;
begin
  for I:=0 to fScripter.ClassList.Count - 1 do
    if fScripter.ClassList[I].Name = Name then
    begin
      result := fScripter.ClassList[I].ClassID;
      Exit;
    end;
  result := -1;
end;

procedure TPaxScripter.ScanProperties(const ObjectName: String);
var
  L: TStringList;
  A: array[0..10] of Variant;

procedure Push(const S: String; const V: Variant);
begin
  L.Add(S);
  A[L.Count - 1] := V;
end;

procedure Pop;
begin
  L.Delete(L.Count - 1);
end;

function GetFullName(const S: String): String;
var
  I: Integer;
begin
  result := '';
  for I:=0 to L.Count - 1 do
    result := result + L[I] + '.';
  result := result + S;
end;

procedure Backtrak(const V: Variant; const PropName: String);
var
  I, K: Integer;
  temp: Variant;
  S: String;
begin
  if IsPaxObject(V) then
  begin
    Push(PropName, V);
    K := GetPaxObjectPropertyCount(V);
    for I:=0 to K - 1 do
    begin
      temp := GetPaxObjectPropertyByIndex(V, I);
      S := GetPaxObjectPropertyNameByIndex(V, I);
      Backtrak(temp, S);
    end;
    Pop;
  end
  else
  begin // terminal branch
    if Assigned(OnScanProperties) then
    begin
      temp := V;
      OnScanProperties(Self, GetFullName(PropName), temp);

      if VarType(temp) <> VarType(V) then
        PutPaxObjectProperty(A[L.Count - 1], PropName, temp)
      else if V <> temp then
        PutPaxObjectProperty(A[L.Count - 1], PropName, temp);
    end;
  end;
end;

procedure Backtraking(const V: Variant; const PropName: String);
begin
  L := TStringList.Create;
  Backtrak(V, PropName);
  L.Free;
end;

var
  V: Variant;
begin
  V := Values[ObjectName];
  Backtraking(V, ObjectName);
end;

constructor TPaxLanguage.Create(AOwner: TComponent);
var
  I: Integer;
  C: TComponent;
  S: TPaxScripter;
begin
  inherited;

  fScripters := TList.Create;
  fContainer := nil;
  fInformalName := '';
  fLongStrLiterals := true;
  fBackslash := true;
  fNamespaceAsModule := false;
  fJavaScriptOperators := false;
  fZeroBasedStrings := false;
  fDEclareVariables := false;
  fInitArrays := true;
  fCompilerDirectives := TStringList.Create;
  fCompilerDirectives.Add('WIN32');
  fIncludeFileExt := '';
  fVBArrays := false;

  if AOwner = nil then
    Exit;

  for I:=0 to AOwner.ComponentCount - 1 do
  begin
    C := TComponent(AOwner.Components[I]);
    if C.InheritsFrom(TPaxScripter) then
    begin
      S := TPaxScripter(C);
      if S.FindLanguage(GetLanguageName) = nil then
        S.RegisterLanguage(Self);
    end;
  end;
end;

destructor TPaxLanguage.Destroy;
var
  I: Integer;
  C: TComponent;
  S: TPaxScripter;
begin
  if Owner <> nil then
  begin
    for I:=0 to Owner.ComponentCount - 1 do
    begin
      C := TComponent(Owner.Components[I]);
      if C.InheritsFrom(TPaxScripter) then
      begin
        S := TPaxScripter(C);
        if S.FindLanguage(GetLanguageName) <> nil then
          S.UnregisterLanguage(GetLanguageName);
      end;
    end;
  end;

  fScripters.Free;
  fCompilerDirectives.Free;

  inherited;
end;

procedure TPaxLanguage.RegisterScripter(S: TPaxScripter);
begin
  if fScripters.IndexOf(S) = -1 then
    fScripters.Add(S);
end;

procedure TPaxLanguage.UnRegisterScripter(S: TPaxScripter);
var
  I: Integer;
begin
  I := fScripters.IndexOf(S);
  if I <> -1 then
    fScripters.Delete(I);
end;

function TPaxLanguage.GetKeywords: TStringList;
var
  P: TPaxParser;
begin
  result := nil;
  if fScripters.Count > 0 then
  begin
    P := TPaxScripter(fScripters[0]).fScripter.ParserList.FindParser(LanguageName);
    if P <> nil then
      result := P.Keywords;
  end;
end;

function TPaxLanguage.GetCaseSensitive: Boolean;
var
  P: TPaxParser;
begin
  result := false;
  if fScripters.Count > 0 then
  begin
    P := TPaxScripter(fScripters[0]).fScripter.ParserList.FindParser(LanguageName);
    if P <> nil then
      result := not P.UpCase;
  end;
end;

procedure TPaxLanguage.SetFileExt(const Value: String);
var
  I: Integer;
  C: TComponent;
  S: TPaxScripter;
  P: TPaxParser;
begin
  if Owner = nil then
    Exit;
  for I:=0 to Owner.ComponentCount - 1 do
  begin
    C := TComponent(Owner.Components[I]);
    if C.InheritsFrom(TPaxScripter) then
    begin
      S := TPaxScripter(C);
      P := S.fScripter.ParserList.FindParser(GetLanguageName);
      if P <> nil then
        P.FileExt := '.' + Value;
    end;
  end;
end;

procedure TPaxLanguage.SetLanguageName(const Value: String);
var
  I: Integer;
  C: TComponent;
  S: TPaxScripter;
  P: TPaxParser;
begin
  if Owner = nil then
    Exit;
  for I:=0 to Owner.ComponentCount - 1 do
  begin
    C := TComponent(Owner.Components[I]);
    if C.InheritsFrom(TPaxScripter) then
    begin
      S := TPaxScripter(C);
      P := S.fScripter.ParserList.FindParser(GetLanguageName);
      if P <> nil then
        P.LanguageName := Value;
    end;
  end;
end;

procedure TPaxLanguage.SetCompilerDirectives(const Value: TStrings);
begin
  fCompilerDirectives.Assign(Value);
end;

function TPaxLanguage.GetLongStrLiterals: Boolean;
begin
  result := fLongStrLiterals;
end;

function TPaxLanguage.GetPaxParserClass: TPaxParserClass;
begin
  result := nil;
end;

function TPaxLanguage.GetLanguageName: String;
begin
  result := '';
end;

function TPaxLanguage.GetFileExt: String;
begin
  result := '';
end;

function LoadImportLibrary(const DllName: String): Cardinal;
var
  P: TPaxRegisterDllProc;
  R: TPaxRegisterProcs;
  OldCount, I: Integer;
begin
  R.RegisterNamespace := RegisterNamespace;
  R.RegisterClassType := RegisterClassType;
  R.RegisterRTTIType := RegisterRTTIType;
  R.RegisterMethod := RegisterMethod;
  R.RegisterBCBMethod := RegisterBCBMethod;
  R.RegisterProperty := RegisterProperty;
  R.RegisterRoutine := RegisterRoutine;
  R.RegisterVariable := RegisterVariable;
  R.RegisterConstant := RegisterConstant;
  R.RegisterInterfaceType := RegisterInterfaceType;
  R.RegisterInterfaceMethod := RegisterInterfaceMethod;

{$IFDEF FP}
   result := HMODULE(dynlibs.LoadLibrary(DLLName));
{$ELSE}
   result := LoadLibrary(PChar(DllName));
{$ENDIF}
  if result > 0 then
  begin
    OldCount := DefinitionList.Count;

    P := GetProcAddress(result, 'RegisterDllProcs');
    P(R);

    for I:=OldCount - 1 to DefinitionList.Count - 1 do
      DefinitionList.Records[I].Module := result;
  end;
end;

function FreeImportLibrary(H: Cardinal): LongBool;
begin
  result := FreeLibrary(H);
end;

initialization
  _OP_CALL := BASE_SYS.OP_CALL;
  _OP_PRINT := BASE_SYS.OP_PRINT;
  _OP_GET_PUBLISHED_PROPERTY := BASE_SYS.OP_GET_PUBLISHED_PROPERTY;
  _OP_PUT_PUBLISHED_PROPERTY := BASE_SYS.OP_PUT_PUBLISHED_PROPERTY;
  _OP_PUT_PROPERTY := BASE_SYS.OP_PUT_PROPERTY;
  _OP_ASSIGN := BASE_SYS.OP_ASSIGN;
  _OP_NOP := BASE_SYS.OP_NOP;
end.
