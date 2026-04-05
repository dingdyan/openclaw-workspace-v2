////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: BASE_SYS.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit BASE_SYS;

interface

uses
{$IFDEF VARIANTS}
  Variants,
{$ENDIF}
{$IFDEF WIN32}
  Windows,

{$ifndef FP}
  syncobjs,
{$ENDIF}

{$ENDIF}
{$IFDEF LINUX}
{$IFDEF CONSOLE}
  SyncObjs,
{$ELSE}
  QForms,
  SyncObjs,
{$ENDIF}
{$ENDIF}

  TypInfo,
  SysUtils,
  Classes,
  BASE_CONSTS,
  BASE_SYNC;
const
{$IFDEF TRIAL}
  _IsTrial = true;
{$ELSE}
  _IsTrial = false;
{$ENDIF}

{$IFDEF DUMP}
  _IsDump: Boolean = true;
{$ELSE}
  _IsDump: Boolean = false;
{$ENDIF}

  RootNamespaceName = 'NonameNamespace';

  SignLoadOnDemand = true;

  PathDelim  = {$IFDEF WIN32} '\'; {$endif}{$IFDEF LINUX} '/';{$ENDIF}
  DriveDelim = {$IFDEF WIN32} ':'; {$endif}{$IFDEF LINUX} '';{$ENDIF}
  PathSep    = {$IFDEF WIN32} ';'; {$endif}{$IFDEF LINUX} ':';{$ENDIF}

  _rmRun = 0;
  _rmStepOver = 1;
  _rmTraceInto = 2;
  _rmRunToCursor = 3;
  _rmTraceToNextSourceLine = 4;

  _ccRegister = 0;
  _ccPascal = 1;
  _ccCDecl = 2;
  _ccStdCall = 3;
  _ccSafeCall = 4;

  _CompiledModuleVersion = 2;

  MaxParams = 20; // max number of parameters of imported routine
  MaxHash = 97;

  _ssInit = 0; // component was created, no modules and code
  _ssReadyToCompile = 1; // modules and code were added
  _ssCompiling = 2; // compiles script
  _ssCompiled = 3; // all modules were compiled
  _ssLinking = 4;  // links modules in a script
  _ssReadyToRun = 5; // script was linked and it is ready to run now
  _ssRunning = 6; // runs script
  _ssPaused = 7; // script was paused
  _ssTerminated = 8; // script was terminated

{$IFDEF LINUX}
  varScriptObject = varError;
  varAlias        = $15;
{$ELSE}
  varScriptObject = $0E;
  varAlias        = $15;
{$ENDIF}
  varUndefined = varEmpty;

  FirstSymbolCard = 46;
  DeltaSymbolCard = 64;

  DefaultStackSize = 16000;
  FirstMemSize =  3200;
  DeltaMemSize = 32000;

  FirstProgCard = 64;
  DeltaProgCard = 256;

  FirstStackSize = 128;
  DeltaStackSize = 1024;

//  BOUND_OPER  = -100;
  BOUND_OPER  = 0;
  BOUND_LINES = -30000;
  BOUND_FILES = -50000;

  SP_ROUND_BRACKET_L = -901;
  SP_ROUND_BRACKET_R = -902;

  SP_BRACKET_L = -903;
  SP_BRACKET_R = -904;

  SP_BRACE_L = -905;
  SP_BRACE_R = -906;

  SP_SEMICOLON = -907;
  SP_POINT     = -908;
  SP_COLON     = -909;
  SP_COMMA     = -910;
  SP_EOF       = -911;
  SP_BACKSLASH = -912;

  MAX_VALUE:double=1.7E307;
  MIN_VALUE:double=4.0E-324;
  NEGATIVE_INFINITY:double=-1.7E308;
  POSITIVE_INFINITY:double=1.7E308;
  NaN:double=1.71E308;
  INFINITY:double=1.7E308;

  BR = #13#10;

  typeVOID = 0;
  typeVARIANT = 1;
  typeOLEVARIANT = 2;
  typeBYTE = 3;
  typeCHAR = 4;
  typeBOOLEAN = 5;
  typeWORDBOOL = 6;
  typeLONGBOOL = 7;
  typeINTEGER = 8;
  typeCARDINAL = 9;
  typePOINTER = 10;
  typeDOUBLE = 11;
  typeSTRING = 12;
  typeENUM = 13;
  typeRECORD = 14;
  typeARRAY = 15;
  typeSHORTSTRING = 16;
  typeTEXT = 17;
  typeSUBRANGE = 18;
  typeSET = 19;
  typeCLASS = 20;
  typeCLASSREF = 21;
  typeDYNAMICARRAY = 22;
  typePCHAR = 23;
  typeWORD = 24;
  typeSHORTINT = 25;
  typeSMALLINT = 26;
  typeINT64 = 27;
  typeSINGLE = 28;
  typeCURRENCY = 29;
  typeCOMP = 30;
  typeREAL48 = 31;
  typeEXTENDED = 32;
  typeINTERFACE = 33;
  typeMETHOD = 34;
  typeFILE = 35;
  typeWIDECHAR = 36;
  typeWIDESTRING = 37;
  typePWIDECHAR = 38;
  typeTVarRec = 39;

  IntegerPaxTypes: TIntegerSet = [typeINTEGER,
                                  typeINT64, typeCARDINAL,
                                  typeBYTE, typeWORD, typeSMALLINT,
                                  typeSHORTINT];

  BooleanPaxTypes: TIntegerSet = [typeBOOLEAN];

  StringPaxTypes: TIntegerSet = [typeSTRING];

  RealPaxTypes: TIntegerSet = [typeDOUBLE, typeSINGLE, typeCURRENCY];

  VariantPaxTypes: TIntegerSet = [typeVARIANT];

  KindNONE = 0;
  KindVAR = 1;
  KindTYPE = 2;
  KindCONST = 3;
  KindSUB = 4;
  KindREF = 5;
  KindPROP = 6;
  KindLABEL = 7;
  KindHOSTVAR = 8;
  KindHOSTCONST = 9;
  KindHOSTOBJECT = 10;
  KindHOSTINTERFACEVAR = 11;
  KindVIRTUALOBJECT = 12;
const
  SecsPerHour   = 60 * 60;
  SecsPerDay    = SecsPerHour * 24;
  MSecsPerDay   = SecsPerDay * 1000;
  MSecsPerHour  = SecsPerHour * 1000;
type
  TIntegerMethodNoParam = function(): Integer of Object;
  TIntegerMethodOneParam = function(I: Integer): Integer of Object;

  TPAXClassKind = (ckNone, ckClass, ckStructure, ckEnum, ckInterface, ckArray,
                   ckDynamicArray);

  TPAXMemberAccess = (maAny, maMyBase, maMyClass);

  TPAXModifier = (modDEFAULT, modPUBLIC, modPRIVATE, modSTATIC, modPROTECTED, modVIRTUAL);
  TPAXModifierList = set of TPAXModifier;

  PVariant = ^Variant;
  PInteger = ^TInteger;

  PUnknown = ^IUnknown;
  PPointer = ^Pointer;

  TByteInt = (bb00,bb01,bb02,bb03,bb04,bb05,bb06,bb07,bb08,bb09,
              bb10,bb11,bb12,bb13,bb14,bb15,bb16,bb17,bb18,bb19,
              bb20,bb21,bb22,bb23,bb24,bb25,bb26,bb27,bb28,bb29);

  TByteSet = set of TByteInt;

  TFile = file;
  TTextFile = TextFile;
  TInteger = Integer;
  TReal = Double;
  TSingle  = Single;
  TCurrency = Currency;
  TDouble = Double;
  TReal48 = Double;
  TComp = Double;
  TExtended = Extended;
  TString  = String;
  TShortString = ShortString;
  TByte = Byte;
  TChar = Char;
  TWideChar = WideChar;
  TWideString = WideString;
  TBoolean = Boolean;
  TWordBool = WordBool;
  TLongBool = LongBool;
  TPointer = Pointer;
  TCardinal = Cardinal;
  TWord = Word;
  TShortInt = ShortInt;
  TSmallInt = SmallInt;
  TInt64 = Int64;
  PInt64 = ^TInt64;
  TOleVariant = OleVariant;

  PBoolean = ^TBoolean;
  PDouble = ^TDouble;

  TPAXTypeSub = (tsNone, tsMethod, tsConstructor, tsDestructor, tsGlobal, tsFunction, tsProcedure);

  TPAXScripterState = Integer;

  TPAXTokenClass = (tcNone, tcKeyword, tcId, tcSpecial, tcSeparator, tcIntegerConst,
                    tcFloatConst, tcStringConst, tcHtmlStringConst);

  TCharSet = set of Char;

  TPAXToken = record
    Text: String;
    ID: Integer;
    TokenClass: TPAXTokenClass;
    Value: Variant;
    Position: Integer;
  end;

  TPAXKinds = TStringList;
  TPAXOperators = TStringList;

  TPAXTypes = class(TStringList)
    function AddType(const TypeName: String; TypeSize: Integer): Integer;
    function GetSize(TypeID: Integer): Integer;
    function GetTypeID(const TypeName: String): Integer;
  end;

  TPAXScriptFailure = class(Exception);

  TPAXStack = class
  private
    L: Integer;
    function GetItem(I: Integer): Integer;
  public
    Card: Integer;
    fItems: array of Integer;
    constructor Create;
    function Push(I: Integer): Integer; overload;
    procedure Push(P: Pointer); overload;
    function Pop: Integer;
    function PopPointer: Pointer;
    function Top: Integer;
    procedure SaveToStream(f: TStream);
    procedure LoadFromStream(f: TStream);
    procedure Clear;
    function StackPtr: Pointer;
    procedure CopyFrom(S: TPAXStack);

    function IndexOf(I: Integer): Integer;
    function PushUnique(I: Integer): Integer;
    procedure Delete(I: Integer);

    property Items[I: Integer]: Integer read GetItem; default;
  end;

  TPAXFastStack = class
  private
    function GetItem(I: Integer): Integer;
  public
    Card: Integer;
    fItems: array [0..1024] of Integer;
    constructor Create;
    function Push(I: Integer): Integer; overload;
    procedure Push(P: Pointer); overload;
    procedure Clear;
    function Pop: Integer;
    function PopPointer: Pointer;
    function Top: Integer;

    function IndexOf(I: Integer): Integer;
    function PushUnique(I: Integer): Integer;
    procedure Delete(I: Integer);

    property Items[I: Integer]: Integer read GetItem; default;
  end;

  TPAXCallStack = TPAXStack;
  TPAXUsingList = TPAXStack;
  TPAXWithStack = TPAXStack;

  TPAXIndexedList = class
  private
    fItems: TList;
    function GetNameID(I: Integer): Integer;
    procedure SetNameID(I: Integer; Value: Integer);
  public
    Objects: TList;
    constructor Create;
    procedure Clear;
    destructor Destroy; override;
    function Count: Integer;
    procedure Delete(I: Integer);
    function AddObject(ID: Integer; AnObject: TObject): Integer;
    function GetObject(ID: Integer): TObject;
    function IndexOf(I: Integer): Integer;
    procedure DeleteObject(Index: Integer);
    property NameID[I: Integer]: Integer read GetNameID write SetNameID; default;
  end;

  TPAXHashArray = class
  public
    A: array[0..MaxHash] of TList;
    constructor Create;
    destructor Destroy; override;
    procedure AddName(const Name: String; NameIndex, _HashNumber: Integer);
    procedure Clear;
  end;

  TPAXHashTable = class
  private
    Keys: array[0..MaxHash] of TList;
    Values: array[0..MaxHash] of TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Key: Integer; Value: Integer);
    function FindValue(Key: Integer; var found: Boolean): Integer;
    procedure DeleteValue(Value: Integer);
    procedure Clear;
  end;

  TPAXHashedIndexedList = class(TPAXIndexedList)
    HashTable: TPAXHashTable;
    constructor Create;
    destructor Destroy; override;
    function IndexOf(ID: Integer): Integer;
    function AddObject(ID: Integer; AnObject: TObject): Integer;
    function GetObject(ID: Integer): TObject;
    procedure DeleteObject(Index: Integer);
    procedure Clear;
  end;

  TPAXEntryRec = class
  public
    BreakLabel, ContinueLabel: Integer;
    StringLabel: String;
  end;

  TPAXEntryStack = class(TList)
    procedure Push(ABreakLabel, AContinueLabel: Integer;
                  var AStringLabel: String);
    procedure Pop;
    function TopBreakLabel(const AStringLabel: String = ''): Integer;
    function TopContinueLabel(const AStringLabel: String = ''): Integer;
  end;

  TPAXIniFile = class
  private
    L: TStringList;
    FileName: String;
    function IndexOf(const Key: String): Integer;
    function GetValue(const Key: String): String;
    procedure SetValue(const Key, Value: String);
  public
    constructor Create(const FileName: String);
    destructor Destroy; override;
    property Values[const Key: String]: String read GetValue write SetValue; default;
  end;

  TPAXNameList = class(TStringList)
  public
    HashArray: TPAXHashArray;
    constructor Create;
    destructor Destroy; override;
    function Add(const S: string): Integer; override;
    function GetSize: Integer;
  end;

  TPAXCodeRec = class
  public
    Key: String;
    LanguageName: String;
    Code: String;
  end;

  TPAXCodeList = class(TList)
  private
    function GetRecord(Index: Integer): TPAXCodeRec;
  public
    procedure Clear; override;
    function IndexOfKey(const Key: String): Integer;
    function AddCode(const Key, LanguageName, Code: String): TPAXCodeRec;
    function GetCode(LanguageName: String): String;
    property Records[Index: Integer]: TPAXCodeRec read GetRecord; default;
  end;

  TPAXParamList = class
  private
    L: TStringList;
  public
    function GetParam(const ParamName: String): Variant;
    procedure SetParam(const ParamName: String; const Value: Variant);
    function GetAddress(const ParamName: String): Pointer;
    function HasAddress(P: Pointer): Boolean;
    constructor Create;
    destructor Destroy; override;
  end;

  TPAXIds = class(TList)
  private
    function GetID(Index: Integer): Integer;
    procedure PutID(Index: Integer; Value: Integer);
  public
    DupYes: Boolean;
    constructor Create(DupYes: Boolean);
    function Add(ID: Integer): Integer;
    function IndexOf(ID: Integer): Integer;
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream);
    property Ids[Index: Integer]: Integer read GetID write PutID; default;
  end;

  TPAXVariantStack = class
  private
    L: Integer;
    A: array of Variant;
  public
    Card: Integer;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Push(const V: Variant): PVariant;
    procedure Pop;
    function Top: Variant;
  end;

  TPAXVarList = class
  private
    fItems: TList;
    function GetCount: Integer;
    function Get(Index: Integer): Variant;
  public
    constructor Create;
    destructor Destroy; override;
    function GetAddress(Index: Integer): PVariant;
    function Add(const Value: Variant): Integer;
    function IndexOf(const Value: Variant): Integer;
    procedure Delete(Index: Integer);
    property Count: Integer read GetCount;
    property Items[I: Integer]: Variant read Get; default;
  end;

  TPAXAssocRec = class
  public
    Data: TVarRec;
    Obj: TObject;
  end;

  TPAXAssocList = class
  private
    fItems: TList;
    function GetItem(I: Integer): TPAXAssocRec;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(const Data: TVarRec; Obj: TObject): Integer;
    function FindObject(const Data: TVarRec): TObject;
    property Items[I: Integer]: TPAXAssocRec read GetItem;
  end;

  TDefaultParameterRec = class
  public
    SubID: Integer;
    ID: Integer;
    Value: Variant;
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream);
  end;

  TDefaultParameterList = class(TList)
  private
    function GetRecord(I: Integer): TDefaultParameterRec;
  public
    destructor Destroy; override;
    procedure AddParameter(SubID, ID: Integer; const Value: Variant);
    function FindFirst(SubID: Integer): Integer;
    function FindNext(I, SubID: Integer): Integer;
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream);
    property Records[I: Integer]: TDefaultParameterRec read GetRecord; default;
  end;

  TPaxIDRec = class
  public
    ID, N, Pos: Integer;
    constructor Create(ID, N, Pos: Integer);
  end;

  TPaxIDRecList = class(TPaxIndexedList)
  private
    function GetRecord(I: Integer): TPaxIDRec;
  public
    property Records[I: Integer]: TPaxIDRec read GetRecord; default;
  end;

  TPaxCallRec = class
  public
    CallN, CallP: Integer;
    ArgsN, ArgsP: TPaxIds;
    constructor Create;
    destructor Destroy; override;
  end;

  TPaxCallRecList = class(TPaxIndexedList)
  private
    function GetRecord(I: Integer): TPaxCallRec;
  public
    procedure AddObject(N: Integer; X: TPaxCallRec);
    function Top: TPaxCallRec;
    property Records[I: Integer]: TPaxCallRec read GetRecord; default;
  end;

  TPaxAssociativeList = class
  private
    L1, L2: TPaxIds;
    function GetFirst(I: Integer): Integer;
    function GetSecond(I: Integer): Integer;
  public
    constructor Create(DupYes: Boolean);
    destructor Destroy; override;
    function Add(I1, I2: Integer): Integer;
    function Count: Integer;
    procedure Clear;
    function Convert(ID: Integer): Integer;
    property First[I: Integer]: Integer read GetFirst;
    property Second[I: Integer]: Integer read GetSecond;
  end;

  TOperatorList = class
  public
     fItems: TStringList;
     constructor Create;
     destructor Destroy; override;
     procedure Add(const Name: String; Op: Integer);
     function GetName(Op: Integer): String;
     function IndexOf(const Name: String): Integer;
   end;

  TPaxObjectList = class
  private
    fItems: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(X: TObject);
    procedure Clear;
    procedure Delete(I: Integer);
    function Count: Integer;
    property Items: TList read fItems;
  end;

const
  _SizeVariant = SizeOf(Variant);

var
  OP_SEPARATOR,
  OP_NOP,
  OP_SKIP,
  OP_HALT,
  OP_HALT_GLOBAL,
  OP_HALT_OR_NOP,
  OP_PRINT,
  OP_PRINT_HTML,
  OP_GO,
  OP_GO_FALSE,
  OP_GO_FALSE_EX,
  OP_GO_TRUE,
  OP_GO_TRUE_EX,
  OP_SET_LABEL,

  OP_BEGIN_METHOD,
  OP_CREATE_ARRAY,
  OP_CREATE_DYNAMIC_ARRAY_TYPE,
  OP_GET_FIELD,

  OP_CREATE_SHORT_STRING,

  OP_DO_NOT_DESTROY,

  OP_CREATE_OBJECT,
  OP_CREATE_RESULT,
  OP_CHECK_CLASS,
  OP_SET_TYPE,
  OP_DESTROY_HOST,
  OP_DESTROY_OBJECT,
  OP_DESTROY_LOCAL_VAR,
  OP_DESTROY_INTF,
  OP_RELEASE,
  OP_CREATE_REF,
  OP_USE_NAMESPACE,
  OP_END_OF_NAMESPACE,
  OP_BEGIN_WITH,
  OP_END_WITH,
  OP_EVAL_WITH,
  OP_IN,
  OP_IN_SET,
  OP_INSTANCEOF,
  OP_TYPEOF,
  OP_GET_NEXT_PROP,
  OP_SAVE_RESULT,
  OP_GET_ANCESTOR_NAME,

  OP_ON_USES,

  OP_PUSH,
  OP_PUT_PROPERTY,
  OP_CALL,
  OP_CALL_CONSTRUCTOR,
  OP_TYPE_CAST,
  OP_RET,
  OP_EXIT0,
  OP_EXIT,
  OP_RETURN,
  OP_GET_PARAM_COUNT,
  OP_GET_PARAM,
  OP_GET_PUBLISHED_PROPERTY,
  OP_PUT_PUBLISHED_PROPERTY,
  OP_RET_OPERATOR,

  OP_GET_ITEM,
  OP_PUT_ITEM,
  OP_GET_ITEM_EX,
  OP_PUT_ITEM_EX,

  OP_GET_STRING_ELEMENT,
  OP_PUT_STRING_ELEMENT,

  OP_FINALLY,
  OP_CATCH,
  OP_TRY_ON,
  OP_TRY_OFF,
  OP_THROW,
  OP_DISCARD_ERROR,
  OP_EXIT_ON_ERROR,

  OP_ASSIGN,
  OP_ASSIGN_SIMPLE,
  OP_ASSIGN_ADDRESS,
  OP_GET_TERMINAL,
  OP_ASSIGN_RESULT,

  OP_AND,
  OP_OR,
  OP_XOR,
  OP_NOT,

  OP_LEFT_SHIFT, OP_LEFT_SHIFT_EX,
  OP_RIGHT_SHIFT, OP_RIGHT_SHIFT_EX,

  OP_UNSIGNED_RIGHT_SHIFT, OP_UNSIGNED_RIGHT_SHIFT_EX,

  OP_PLUS, OP_PLUS_EX,
  OP_MINUS, OP_MINUS_EX,
  OP_UNARY_PLUS,
  OP_UNARY_MINUS, OP_UNARY_MINUS_EX,
  OP_MULT, OP_MULT_EX,
  OP_DIV, OP_DIV_EX,
  OP_INT_DIV,
  OP_MOD, OP_MOD_EX,
  OP_POWER,

  OP_LT, OP_LT_EX,
  OP_GT, OP_GT_EX,
  OP_GE, OP_GE_EX,
  OP_LE, OP_LE_EX,

  OP_EQ, OP_EQ_EX,
  OP_NE, OP_NE_EX,

  OP_ID, OP_ID_EX,
  OP_NI, OP_NI_EX,

  OP_IS,
  OP_AS,

  OP_TO_INTEGER,
  OP_TO_STRING,
  OP_TO_BOOLEAN,

  OP_DEFINE,

  OP_DECLARE_ON,
  OP_DECLARE_OFF,

  OP_UPCASE_ON,
  OP_UPCASE_OFF,

  OP_OPTIMIZATION_ON,
  OP_OPTIMIZATION_OFF,

  OP_JS_OPERS_ON,
  OP_JS_OPERS_OFF,

  OP_ZERO_BASED_STRINGS_ON,
  OP_ZERO_BASED_STRINGS_OFF,

  OP_VBARRAYS_ON,
  OP_VBARRAYS_OFF,

  OP_USE_LANGUAGE_NAMESPACE,

//------------------------------------------------------------------------
  FOP_INC1,
  FOP_INC2,

  FOP_PLUS_INTEGER1,
  FOP_PLUS_INTEGER2,
  FOP_PLUS_DOUBLE1,
  FOP_PLUS_DOUBLE2,
  FOP_PLUS_STRING1,
  FOP_PLUS_STRING2,

  FOP_MINUS_INTEGER1,
  FOP_MINUS_INTEGER2,
  FOP_MINUS_DOUBLE1,
  FOP_MINUS_DOUBLE2,

  FOP_MULT_INTEGER1,
  FOP_MULT_INTEGER2,
  FOP_MULT_DOUBLE1,
  FOP_MULT_DOUBLE2,

  FOP_DIV_INTEGER1,
  FOP_DIV_INTEGER2,
  FOP_DIV_DOUBLE1,
  FOP_DIV_DOUBLE2,

  FOP_MOD1,
  FOP_MOD2,

  FOP_LT_INTEGER1,
  FOP_LT_INTEGER2,
  FOP_LT_DOUBLE1,
  FOP_LT_DOUBLE2,

  FOP_LE_INTEGER1,
  FOP_LE_INTEGER2,
  FOP_LE_DOUBLE1,
  FOP_LE_DOUBLE2,

  FOP_GT_INTEGER1,
  FOP_GT_INTEGER2,
  FOP_GT_DOUBLE1,
  FOP_GT_DOUBLE2,

  FOP_GE_INTEGER1,
  FOP_GE_INTEGER2,
  FOP_GE_DOUBLE1,
  FOP_GE_DOUBLE2,

  FOP_EQ_INTEGER1,
  FOP_EQ_INTEGER2,
  FOP_EQ_DOUBLE1,
  FOP_EQ_DOUBLE2,

  FOP_NE_INTEGER1,
  FOP_NE_INTEGER2,
  FOP_NE_DOUBLE1,
  FOP_NE_DOUBLE2,

  FOP_BITWISE_AND1,
  FOP_BITWISE_AND2,

  FOP_BITWISE_OR1,
  FOP_BITWISE_OR2,

  FOP_BITWISE_XOR1,
  FOP_BITWISE_XOR2,

  FOP_LOGICAL_AND1,
  FOP_LOGICAL_AND2,

  FOP_LOGICAL_OR1,
  FOP_LOGICAL_OR2,

  FOP_LOGICAL_XOR1,
  FOP_LOGICAL_XOR2,

  FOP_BITWISE_NOT1,
  FOP_BITWISE_NOT2,

  FOP_LOGICAL_NOT1,
  FOP_LOGICAL_NOT2,

  FOP_UNARY_MINUS_INTEGER1,
  FOP_UNARY_MINUS_INTEGER2,

  FOP_UNARY_MINUS_DOUBLE1,
  FOP_UNARY_MINUS_DOUBLE2,

  FOP_SHL1,
  FOP_SHL2,

  FOP_SHR1,
  FOP_SHR2,

  FOP_USHR1,
  FOP_USHR2,

  FOP_ASSIGN,
  FOP_GO_FALSE1,
  FOP_GO_FALSE2,
  FOP_GO_TRUE1,
  FOP_GO_TRUE2,

//=========================================

  FOP_PUSH,
  FOP_CALL,

  FOP_PLUS1,
  FOP_PLUS2,

  FOP_MINUS1,
  FOP_MINUS2,

  FOP_MULT1,
  FOP_MULT2,

  FOP_DIV1,
  FOP_DIV2,

  FOP_LT1,
  FOP_LT2,

  FOP_LE1,
  FOP_LE2,

  FOP_GT1,
  FOP_GT2,

  FOP_GE1,
  FOP_GE2,

  FOP_EQ1,
  FOP_EQ2,

  FOP_NE1,
  FOP_NE2,

  OP_DECLARE

  : Integer;

  Undefined: Variant;

  NameIndex_Create: Integer;
  NameIndex_New: Integer;

  OPResultTypes: array[1..40, 1..40] of Integer;
  AssResultTypes: array[1..40, 1..40] of Boolean;
  PAXKinds: TPAXKinds;
  PAXTypes: TPAXTypes;
  PAXOperators: TPAXOperators;
  SupportedPaxTypes: TIntegerSet;
  OverloadableOperators: TOperatorList;
  RelationalOperators: TOperatorList;

function StrEql(Const S1, S2: String): Boolean;
function ShiftPointer(P: Pointer; D: Integer): Pointer;
function Norm(const S: String; L: Integer): String;
function GetOperName(OP: Integer): String;
function IsString(const V: Variant): boolean;
function IsBoolean(const V: Variant): boolean;
function IsObject(const V: Variant): boolean;
function IsVBArray(const V: Variant): boolean;
function IsUndefined(const V: Variant): boolean;
function ArrayCreate(const P: array of Integer): Variant;
procedure ArrayPut(V: PVariant; const Indexes: array of Integer; const Val: Variant);
function ArrayGet(V: PVariant; const Indexes: array of Integer): PVariant;
procedure ErrMessageBox(const S:  String);
function IsDelphiClass(Address: Pointer): Boolean;
function IsDelphiObject(Address: Pointer): Boolean;
procedure BackUpTextFile(const FileName: String);
function IsNumber(const V: Variant): boolean;
function _Shr(X, Y: Integer): Variant;
function StringToBinary(const S: String): Integer;
function StringToOctal(const S: String): Integer;
function ChPos(ch: Char; const S: String): Integer;
function SetToVariantArray(Val: Integer; pti: PTypeInfo): Variant;
function HashNumber(const S: String): Integer;

procedure SetBit(var Value: Integer; const Bit: Integer);
function TestBit(const Value: Integer; const Bit: Integer): Boolean;
procedure ClearBit(var Value: Integer; const Bit: Integer);

procedure SaveInteger(Value: Integer; S: TStream);
function LoadInteger(S: TStream): Integer;
procedure SaveString(const Value: String; S: TStream);
function LoadString(S: TStream): String;

procedure SaveVariant(const Value: Variant; S: TStream);
function LoadVariant(S: TStream): Variant;
function GetGMTDifference: Double;
procedure AdjustEnum(var Val: Integer);

type
  TCompareItems = function (P1, P2: Pointer): Integer;
function CompareIntegers(P1, P2: Pointer): Integer;
procedure SortList(L: TList; CompareItems: TCompareItems; I1, I2: Integer);
function GetPAXType(const V: Variant): Integer;
function IsDigits(const S: String): Boolean;
function IsNumericString(const S: String): Boolean;
function DelphiDateTimeToEcmaTime(const AValue: TDateTime): Int64;
function EcmaTimeToDelphiDateTime(const AValue: Variant): TDateTime;
procedure GetMethodList(FromClass: TClass; MethodList: TStrings);
procedure GetPublishedProperties(AClass: TClass; result: TStrings);
procedure GetPublishedPropertiesEx2(AClass: TClass; result: TStrings);
procedure GetPublishedEvents(AClass: TClass; result: TStrings);
procedure GetPublishedPropertiesEx(AClass: TClass; result: TStrings); // including type name
function HasPublishedProperty(C: TClass; const PropName: String; Scripter: Pointer; NeedCheckForForbidden: Boolean = true): boolean;
function HasPublishedPropertyEx(C: TClass; const PropName: String; var ClassType: String; Scripter: Pointer): boolean;
function GetRefCountPtr(const S: String): Pointer;
function GetRefCount(const S: String): Integer;
function GetSizePtr(const S: String): Pointer;

function GetTerminal(P: PVariant): PVariant;
function CreateAlias(P: PVariant): Variant;
function IsAlias(P: PVariant): Boolean;

procedure Initialization_BASE_SYS;
procedure Finalization_BASE_SYS;

procedure SaveStringToTextFile(const S, FileName: String);
procedure ClearVar(V: PVariant);

function IsEqualBytes(P1, P2: Pointer; L: Integer): Boolean;
function IsZeroBytes(P: Pointer; L: Integer): Boolean;
function IntfRefCount(const I: IUnknown): Integer;

function IsEqualGUID(const guid1, guid2: TGUID): Boolean;
function GetImplementorOfInterface(const I: IUnknown): TObject;
function PosCh(ch: Char; const S: String): Integer;

implementation

uses
  BASE_SCRIPTER;


constructor TPaxObjectList.Create;
begin
  fItems := TList.Create;
end;


procedure TPaxObjectList.Add(X: TObject);
begin
  fItems.Add(X);
end;

procedure TPaxObjectList.Clear;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    TObject(fItems[I]).Free;
  fItems.Clear;
end;

destructor TPaxObjectList.Destroy;
begin
  Clear;
  fItems.Free;
  inherited;
end;

procedure TPaxObjectList.Delete(I: Integer);
begin
  TObject(fItems[I]).Free;
  fItems.Delete(I);
end;

function TPaxObjectList.Count: Integer;
begin
  result := fItems.Count;
end;

type
  IntegerArray  = array[0..$effffff] of Integer;
  PIntegerArray = ^IntegerArray;

function IsEqualGUID(const guid1, guid2: TGUID): Boolean;
var
  a, b: PIntegerArray;
begin
  a := PIntegerArray(@guid1);
  b := PIntegerArray(@guid2);
  Result := (a^[0] = b^[0]) and (a^[1] = b^[1]) and (a^[2] = b^[2]) and (a^[3] = b^[3]);
end;


function IntfRefCount(const I: IUnknown): Integer;
begin
  result := I._AddRef - 1;
  I._Release;
end;

function IsEqualBytes(P1, P2: Pointer; L: Integer): Boolean;
var
  I: Integer;
begin
  result := true;
  for I := 0 to L - 1 do
    if Byte(ShiftPointer(P1, I)^) <> Byte(ShiftPointer(P2, I)^) then
    begin
      result := false;
      Exit;
    end;
end;

function IsZeroBytes(P: Pointer; L: Integer): Boolean;
var
  I: Integer;
begin
  result := true;
  for I := 0 to L - 1 do
    if Byte(ShiftPointer(P, I)^) <> 0 then
    begin
      result := false;
      Exit;
    end;
end;

procedure ClearVar(V: PVariant);
begin
  if TVarData(V^).VType = varString then
    VarClear(V^)
  else if (TVarData(V^).VType and varArray) <> 0 then
    VarClear(V^)
  else
    FillChar(V^, SizeOf(TVarData), 0);
  TVarData(V^).VType := varEmpty;
end;

procedure SaveStringToTextFile(const S, FileName: String);
var
  T: TextFile;
begin
  AssignFile(T, FileName);
  Rewrite(T);
  writeln(T, S);
  CloseFile(T);
end;

constructor TOperatorList.Create;
begin
  inherited;
  fItems := TStringList.Create;
end;

destructor TOperatorList.Destroy;
begin
  fItems.Free;
  inherited;
end;

procedure TOperatorList.Add(const Name: String; Op: Integer);
begin
  fItems.AddObject(Name, TObject(Op));
end;

function TOperatorList.GetName(Op: Integer): String;
var
  I: Integer;
begin
  for I:=0 to fItems.Count - 1 do
    if Integer(fItems.Objects[I]) = Op then
    begin
      result := fItems[I];
      Exit;
    end;
  result := '';
end;

function TOperatorList.IndexOf(const Name: String): Integer;
begin
  result := fItems.IndexOf(Name);
end;

constructor TPaxAssociativeList.Create(DupYes: Boolean);
begin
  L1 := TPaxIds.Create(DupYes);
  L2 := TPaxIds.Create(DupYes);
end;

destructor TPaxAssociativeList.Destroy;
begin
  L1.Free;
  L2.Free;
  inherited;
end;

procedure TPaxAssociativeList.Clear;
begin
  L1.Clear;
  L2.Clear;
end;

function TPaxAssociativeList.Convert(ID: Integer): Integer;
var
  I: Integer;
begin
  result := ID;
  for I:=0 to Count - 1 do
    if L1[I] = ID then
      result := L2[I];
end;

function TPaxAssociativeList.Count: Integer;
begin
  result := L1.Count;
end;

function TPaxAssociativeList.Add(I1, I2: Integer): Integer;
begin
  result := L1.Add(I1);
  L2.Add(I2);
end;

function TPaxAssociativeList.GetFirst(I: Integer): Integer;
begin
  result := L1[I];
end;

function TPaxAssociativeList.GetSecond(I: Integer): Integer;
begin
  result := L2[I];
end;

constructor TPaxCallRec.Create;
begin
  CallN := 0;
  CallP := 0;
  ArgsN := TPaxIds.Create(false);
  ArgsP := TPaxIds.Create(false);
end;

destructor TPaxCallRec.Destroy;
begin
  ArgsN.Free;
  ArgsP.Free;
  inherited;
end;

function TPaxCallRecList.GetRecord(I: Integer): TPaxCallRec;
begin
  result := TPaxCallRec(Objects[I]);
end;

procedure TPaxCallRecList.AddObject(N: Integer; X: TPaxCallRec);
var
  I: Integer;
begin
  I := IndexOf(N);
  if I = -1 then
    inherited AddObject(N, X)
  else
    X.Free;
end;

function TPaxCallRecList.Top: TPaxCallRec;
begin
  result := TPaxCallRec(Objects[Count - 1]);
end;

constructor TPaxIDRec.Create(ID, N, Pos: Integer);
begin
  Self.ID := ID;
  Self.N := N;
  Self.Pos := Pos;
end;

function TPaxIDRecList.GetRecord(I: Integer): TPaxIDRec;
begin
  result := TPaxIDRec(Objects[I]);
end;

procedure TDefaultParameterRec.SaveToStream(S: TStream);
begin
  SaveInteger(SubID, S);
  SaveInteger(ID, S);
  SaveVariant(Value, S);
end;

procedure TDefaultParameterRec.LoadFromStream(S: TStream);
begin
  SubID := LoadInteger(S);
  ID := LoadInteger(S);
  Value := LoadVariant(S);
end;

destructor TDefaultParameterList.Destroy;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    Records[I].Free;
  inherited;
end;

function TDefaultParameterList.GetRecord(I: Integer): TDefaultParameterRec;
begin
  result := TDefaultParameterRec(Items[I]);
end;

procedure TDefaultParameterList.AddParameter(SubID, ID: Integer; const Value: Variant);
var
  R: TDefaultParameterRec;
begin
  R := TDefaultParameterRec.Create;
  R.SubID := SubID;
  R.ID := ID;
  R.Value := Value;
  Add(R);
end;

function TDefaultParameterList.FindFirst(SubID: Integer): Integer;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    if Records[I].SubID = SubID then
    begin
      result := I;
      Exit;
    end;
  result := -1;
end;

function TDefaultParameterList.FindNext(I, SubID: Integer): Integer;
begin
  result := -1;
  if I < Count - 1 then
  begin
    Inc(I);
    if Records[I].SubID = SubID then
      result := I;
  end;
end;

procedure TDefaultParameterList.SaveToStream(S: TStream);
var
  R: TDefaultParameterRec;
  I: Integer;
begin
  SaveInteger(Count, S);
  for I:=0 to Count - 1 do
  begin
    R := GetRecord(I);
    R.SaveToStream(S);
  end;
end;

procedure TDefaultParameterList.LoadFromStream(S: TStream);
var
  I, K: Integer;
  R: TDefaultParameterRec;
begin
  for I:=0 to Count - 1 do
    Records[I].Free;
  Clear;
  K := LoadInteger(S);
  for I:=0 to K - 1 do
  begin
    R := TDefaultParameterRec.Create;
    R.LoadFromStream(S);
    Add(R);
  end;
end;

function IsDigits(const S: String): Boolean;
var
  I: Integer;
begin
  result := true;
  for I:=1 to Length(S) do
    if not (S[I] in ['0'..'9']) then
    begin
      result := False;
      Exit;
    end;
end;

function CreateAlias(P: PVariant): Variant;
begin
  TVarData(result).VType := varAlias;
  TVarData(result).VInteger := Integer(P);
end;

function IsAlias(P: PVariant): Boolean;
begin
  result := VarType(P^) = varAlias;
end;

function GetTerminal(P: PVariant): PVariant;
begin
  result := P;
  while VarType(result^) = varAlias do
    result := PVariant(TVarData(result^).VInteger);
end;

constructor TPAXVariantStack.Create;
begin
  SetLength(A, FirstStackSize);
  L := Length(A) - 1;

  Card := 0;
end;

destructor TPAXVariantStack.Destroy;
begin
  Clear;
  inherited;
end;

procedure TPAXVariantStack.Clear;
begin
  while Card > 0 do
    Pop;
end;

function TPAXVariantStack.Push(const V: Variant): PVariant;
begin
  if Card = L then
  begin
    SetLength(A, Card + DeltaStackSize);
    L := Length(A) - 1;
  end;

  Inc(Card);
  A[Card] := V;
  result := @A[Card];
end;

function TPAXVariantStack.Top: Variant;
begin
  result := A[Card];
end;

procedure TPAXVariantStack.Pop;
begin
  VarClear(A[Card]);
  Dec(Card);
end;

function GetPAXType(const V: Variant): Integer;
begin
  case VarType(V) of
    varInteger: result := typeINTEGER;
    varDouble: result := typeDOUBLE;
    varString: result := typeSTRING;
    varBoolean: result := typeBOOLEAN;
  else
    result := typeVARIANT;
  end;
end;

function CompareIntegers(P1, P2: Pointer): Integer;
begin
  if Integer(P1) > Integer(P2) then
    result := 1
  else if Integer(P1) = Integer(P2) then
    result := 0
  else
    result := -1;
end;

procedure SortList(L: TList; CompareItems: TCompareItems; I1, I2: Integer);
var
  P: Pointer;
  I, J: Integer;
  Done: Boolean;
begin
  for I:=I1 to I2 - 1 do
  begin
    Done := true;
    for J:=I2 downto I + 1 do
      if CompareItems(L[J], L[J-1]) < 0 then
      begin
        P := L[J];
        L[J] := L[J-1];
        L[J-1] := P;
        Done := false;
      end;
    if Done then
      Exit;
  end;
end;

procedure SaveVariant(const Value: Variant; S: TStream);
var
  VType: Integer;
begin
  VType := VarType(Value);
  SaveInteger(VType, S);
  case VType of
    varString:
      SaveString(Value, S);
    else
      S.WriteBuffer(Value, SizeOf(Variant));
  end;
end;

function LoadVariant(S: TStream): Variant;
var
  VType: Integer;
begin
  VType := LoadInteger(S);
  case VType of
    varString:
      result := LoadString(S);
    else
      S.ReadBuffer(result, SizeOf(Variant));
  end;
end;

procedure SaveInteger(Value: Integer; S: TStream);
begin
  S.WriteBuffer(Value, SizeOf(Integer));
end;

function LoadInteger(S: TStream): Integer;
begin
  S.ReadBuffer(result, SizeOf(Integer));
end;

procedure SaveString(const Value: String; S: TStream);
var
  W: TWriter;
begin
  W := TWriter.Create(S, 1024);
  W.WriteString(Value);
  W.Free;
end;

function LoadString(S: TStream): String;
var
  R: TReader;
begin
  R := TReader.Create(S, 1024);
  result := R.ReadString;
  R.Free;
end;

constructor TPAXVarList.Create;
begin
  fItems := TList.Create;
end;

destructor TPAXVarList.Destroy;
var
  I: Integer;
begin
  for I:=0 to fItems.Count - 1 do
    FreeMem(fItems[I], _SizeVariant);
  fItems.Free;

  inherited;
end;

procedure TPAXVarList.Delete(Index: Integer);
var
  P: PVariant;
begin
  P := GetAddress(Index);
  FreeMem(P, _SizeVariant);
  fItems.Delete(Index - 1);
end;

function TPAXVarList.Add(const Value: Variant): Integer;
var
  P: Pointer;
begin
  P := AllocMem(_SizeVariant);
  result := fItems.Add(P);
  Variant(P^) := Value;
end;

function TPAXVarList.Get(Index: Integer): Variant;
begin
  result := GetAddress(Index)^;
end;

function TPAXVarList.IndexOf(const Value: Variant): Integer;
var
  I: Integer;
  P: PVariant;
begin
  for I:=1 to fItems.Count do
  begin
    P := GetAddress(I);
    if P^ = Value then
    begin
      result := I;
      Exit;
    end;
  end;
  result := -1;
end;

function TPAXVarList.GetAddress(Index: Integer): PVariant;
var
  P: Pointer;
begin
  while fItems.Count < Index do
  begin
    P := AllocMem(_SizeVariant);
    fItems.Add(P);
  end;
  result := fItems[Index - 1];
end;

function TPAXVarList.GetCount: Integer;
begin
  result := fItems.Count;
end;

function TPAXParamList.HasAddress(P: Pointer): Boolean;
var
  I: Integer;
begin
  for I:=0 to L.Count - 1 do
    if L.Objects[I] = P then
    begin
      result := true;
      Exit;
    end;
  result := false;
end;

constructor TPAXParamList.Create;
begin
  inherited;
  L := TStringList.Create;
end;

destructor TPAXParamList.Destroy;
var
  I: Integer;
  P: Pointer;
begin
  for I:=0 to L.Count - 1 do
  begin
    P := L.Objects[I];
    FreeMem(P, SizeOf(Variant));
  end;
  L.Free;
  inherited;
end;

function TPAXParamList.GetAddress(const ParamName: String): Pointer;
var
  I: Integer;
begin
  I := L.IndexOf(ParamName);
  if I = -1 then
    result := nil
  else
    result := L.Objects[I];
end;

function TPAXParamList.GetParam(const ParamName: String): Variant;
var
  P: Pointer;
begin
  P := GetAddress(ParamName);
  if P = nil then
    result := Undefined
  else
    result := Variant(P^);
end;

procedure TPAXParamList.SetParam(const ParamName: String; const Value: Variant);
var
  P: Pointer;
begin
  P := GetAddress(ParamName);
  if P = nil then
  begin
    P := AllocMem(SizeOf(Variant));
    L.AddObject(ParamName, P);
  end;
  Variant(P^) := Value;
end;

function HashNumber(const S: String): Integer;
var
  I, J: Integer;
  UpS: String;
begin
  if Length(S) = 0 then
  begin
    result := -1;
    Exit;
  end;

  UpS := UpperCase(S);

  I := 0;
  for J:=1 to Length(UpS) do
  begin
    I := I shl 1;
    I := I xor ord(UpS[J]);
  end;
  if I < 0 then I := - I;
  result := I mod MaxHash;
end;

constructor TPAXHashArray.Create;
var
  I: Integer;
begin
  for I:=0 to MaxHash do
    A[I] := TList.Create;
end;

procedure TPAXHashArray.Clear;
var
  I: Integer;
begin
  for I:=0 to MaxHash do
    A[I].Clear;
end;

destructor TPAXHashArray.Destroy;
var
  I: Integer;
begin
  for I:=0 to MaxHash do
    A[I].Free;
end;

procedure TPAXHashArray.AddName(const Name: String; NameIndex, _HashNumber: Integer);
begin
  with A[_HashNumber] do
    if IndexOf(Pointer(NameIndex)) = -1 then
       Add(Pointer(NameIndex));
end;

constructor TPAXHashTable.Create;
var
  I: Integer;
begin
  for I:=0 to MaxHash do
  begin
    Keys[I] := TList.Create;
    Values[I] := TList.Create;
  end;
end;

procedure TPAXHashTable.Clear;
var
  I: Integer;
begin
  for I:=0 to MaxHash do
  begin
    Keys[I].Clear;
    Values[I].Clear;
  end;
end;

destructor TPAXHashTable.Destroy;
var
  I: Integer;
begin
  for I:=0 to MaxHash do
  begin
    Keys[I].Free;
    Values[I].Free;
  end;
end;

procedure TPAXHashTable.Add(Key: Integer; Value: Integer);
var
  H: Integer;
begin
  H := Abs(Key) mod MaxHash;
  Keys[H].Add(Pointer(Key));
  Values[H].Add(Pointer(Value));
end;

function TPAXHashTable.FindValue(Key: Integer; var found: Boolean): Integer;
var
  H: Integer;
begin
  H := Abs(Key) mod MaxHash;
  result := Keys[H].IndexOf(Pointer(Key));
  if result >= 0 then
  begin
    found := true;
    result := Integer(Values[H][result]);
  end
  else
    found := false;
end;

procedure TPAXHashTable.DeleteValue(Value: Integer);
var
  I, Idx: Integer;
begin
  for I:=0 to MaxHash do
  begin
    Idx := Values[I].IndexOf(Pointer(Value));
    if Idx >= 0 then
    begin
      Keys[I].Delete(Idx);
      Values[I].Delete(Idx);
    end;
  end;
end;


function SetToVariantArray(Val: Integer; pti: PTypeInfo): Variant;
var
  S: TIntegerSet;
  TypeInfo: PTypeInfo;
  I: Integer;
  L: TStringList;
begin
  L := TStringList.Create;
  try
    Integer(S) := Val;
{$ifdef fp}
    TypeInfo := GetTypeData(pti)^.CompType;
{$else}
    TypeInfo := GetTypeData(pti)^.CompType^;
{$endif}
    for I := 0 to SizeOf(Integer) * 8 - 1 do
      if I in S then
        L.Add(GetEnumName(TypeInfo, I));
    result := VarArrayCreate([0, L.Count - 1], varVariant);
    for I:=0 to L.Count - 1 do
      result[I] := L[I];
  finally
    L.Free;
  end;
end;

constructor TPAXIniFile.Create(const FileName: String);
begin
  Self.FileName := FileName;
  L := TStringList.Create;
  if FileExists(FileName) then
    L.LoadFromFile(FileName)
  else
    L.SaveToFile(FileName);
end;

destructor TPAXIniFile.Destroy;
var
  A: Integer;
begin
{$IFDEF LINUX}
  L.SaveToFile(FileName);
{$ELSE}
  A := FileGetAttr(FileName);
  if A and faReadOnly = 0 then
    L.SaveToFile(FileName);
{$ENDIF}
  L.Free;
end;

function TPAXIniFile.IndexOf(const Key: String): Integer;
var
  I, P: Integer;
  S: String;
begin
  result := -1;
  for I:=0 to L.Count - 1 do
  begin
    P := Pos('=', L[I]);
    if P >= 0 then
    begin
      S := Copy(L[I], 1, P - 1);
      if S = Key then
      begin
        result := I;
        Exit;
      end;
    end;
  end;
end;

function TPAXIniFile.GetValue(const Key: String): String;
var
  I: Integer;
begin
  result := '';
  I := IndexOf(Key);
  if I >= 0 then
    result := Trim(Copy(L[I], Pos('=', L[I]) + 1, Length(L[I])));
end;

procedure TPAXIniFile.SetValue(const Key, Value: String);
var
  I: Integer;
begin
  I := IndexOf(Key);
  if I >= 0 then
    L[I] := Key + '=' + Value
  else
    L.Add(Key + '=' + Value);
end;

procedure SetBit(var Value: Integer; const Bit: Integer);
begin
  Value := Value or (1 shl Bit);
end;

function TestBit(const Value: Integer; const Bit: Integer): Boolean;
begin
  Result := (Value and (1 shl Bit)) <> 0;
end;

procedure ClearBit(var Value: Integer; const Bit: Integer);
begin
  Value := Value and not (1 shl Bit);
end;

const
  BitsPerInteger  = SizeOf(Integer) * 8;

function BinaryToString(const Value: Integer): string;
var
  I, J: Integer;
  P: PChar;
begin
  SetLength(Result, BitsPerInteger);
  P := PChar(Result) + ((BitsPerInteger - 1) * SizeOf(Char));
  J := Value;
  for I := 0 to BitsPerInteger - 1 do
  begin
    P^ := Chr(48 + (J and $00000001));
    Dec(P);
    J := J shr 1;
  end;
end;

function StringToBinary(const S: String): Integer;
var
  K, I, P: Integer;
  c: Char;
begin
  K := Length(S);
  if K > BitsPerInteger then
    raise Exception.Create(err_Incorrect_string_in_StringToBinary);
  I := K;
  result := 0;
  P := 1;
  while I > 0 do
  begin
    c := S[I];
    case c of
      '1': result := result + P;
      '0': begin end;
     else
       raise Exception.Create(err_Incorrect_string_in_StringToBinary);
     end;
    Dec(I);
    P := P * 2;
  end;
end;

function StringToOctal(const S: String): Integer;
var
  K, I, P: Integer;
  c: Char;
begin
  K := Length(S);
  I := K;
  result := 0;
  P := 1;
  while I > 0 do
  begin
    c := S[I];
    case c of
      '0'..'7': result := result + (ord(S[I]) - ord('0')) * P;
     else
       raise Exception.Create(err_Incorrect_string_in_StringToOctal);
     end;
    Dec(I);
    P := P * 8;
  end;
end;

function ChPos(ch: Char; const S: String): Integer;
var
  I: Integer;
begin
  for I:=1 to Length(S) do
    if S[I] = ch then
    begin
      result := I;
      Exit;
    end;
  result := 0;
end;

function _Shr(X, Y: Integer): Variant;
var
  I, J: Integer;
begin
  J := X shr Y;
  if X >= 0 then
  begin
    result := J;
    Exit;
  end;

  if Y < 0 then
  begin
    result := NaN;
    Exit;
  end;

  for I:=31 downto 32 - Y do
    SetBit(J, I);

  result := J;
end;

procedure AdjustEnum(var Val: Integer);
type
  T = array[1..4] of Byte;
begin
  T(Val)[2] := 0;
  T(Val)[3] := 0;
  T(Val)[4] := 0;
end;

function IsCorrectAddress(Address: Pointer): Boolean;
var
  R: record
       W1, W2: Word;
     end;
begin
  Move(Address, R, SizeOf(Pointer));
  result := (R.W2 <> 0);
end;


{$ifdef fp}
function _IsDelphiClass(Address: Pointer): Boolean;
begin
  result := true;
end;
{$else}
function _IsDelphiClass(Address: Pointer): Boolean; assembler;
asm
        CMP     Address, Address.vmtSelfPtr
        JNZ     @False
        MOV     Result, True
        JMP     @Exit
@False:
        MOV     Result, False
@Exit:
end;
{$endif}

function IsDelphiClass(Address: Pointer): Boolean;
begin
  if IsCorrectAddress(Address) then
    result := _IsDelphiClass(Address)
  else
    result := false;
end;


{$ifdef fp}
function _IsDelphiObject(Address: Pointer): Boolean;
begin
  result := true;
end;
{$else}
function _IsDelphiObject(Address: Pointer): Boolean; assembler;
asm
// or IsDelphiClass(Pointer(Address^));
        MOV     EAX, [Address]
        CMP     EAX, EAX.vmtSelfPtr
        JNZ     @False
        MOV     Result, True
        JMP     @Exit
@False:
        MOV     Result, False
@Exit:
end;

{$endif}

function IsDelphiObject(Address: Pointer): Boolean;
var
  VMT, SelfP : pointer;
begin
  Result := FALSE;
  if IsCorrectAddress(Address) then
    try
      VMT := PPointer(Address)^;
      if IsCorrectAddress(VMT) then
      begin
        SelfP := Pointer(DWORD(VMT) + vmtSelfPtr);
        if IsCorrectAddress(SelfP) then
        begin
          SelfP := PPointer(SelfP)^;
          if IsCorrectAddress(SelfP) then
            Result := VMT = SelfP;
        end;
      end;
    except
    end;
end;

{
function IsDelphiObject(Address: Pointer): Boolean;
begin
  if IsCorrectAddress(Address) then
  begin
    try
      result := _IsDelphiObject(Address);
    except
      asm
        MOV     EAX, [Address]
      end;
      result := false;
    end;
  end
  else
    result := false;
end;
}

procedure ErrMessageBox(const S:  String);
begin
{$IFDEF CONSOLE}
  writeln(S);
  Exit;
{$ENDIF}

{$IFDEF WIN32}
  MessageBox(GetActiveWindow(), PChar(S), PChar('PAXScript'), MB_ICONEXCLAMATION or MB_OK);
{$ENDIF}

{$IFDEF LINUX}
{$IFDEF CONSOLE}
  writeln(S);
{$ELSE}
  Application.MessageBox(PChar(S), 'PAXScript', [smbOK]);
{$ENDIF}
{$ENDIF}
end;

function IsVBArray(const V: Variant): boolean;
begin
  result := VarType(V) > varArray;
end;

function IsUndefined(const V: Variant): boolean;
var
  VT: Integer;
begin
  VT := VarType(V);
  result := (VT = varUndefined) or (VT = varNull);
end;

function IsString(const V: Variant): boolean;
begin
  result := VarType(V) = varString;
end;

function IsNumber(const V: Variant): boolean;
var
  VT: Integer;
begin
  VT := VarType(V);
  result := (VT = varInteger) or (VT = varDouble);
end;

function IsBoolean(const V: Variant): boolean;
begin
  result := VarType(V) = varBoolean;
end;

function IsObject(const V: Variant): boolean;
begin
  result := VarType(V) = varScriptObject;
end;

function GetOperName(OP: Integer): String;
begin
  if OP = 0 then
    result := 'UNKNOWN'
  else
    result := PAXOperators[BOUND_OPER - OP];
end;

function ShiftPointer(P: Pointer; D: Integer): Pointer;
begin
  result := Pointer(Integer(P) + D);
end;

function StrEql(Const S1, S2: String): Boolean;
begin
  Result := CompareText(S1, S2) = 0;
end;

function Norm(const S: String; L: Integer): String;
begin
  result := Copy(S, 1, L);
  while Length(result) < L do
    result := ' ' + result;
end;

procedure TPAXEntryStack.Push(ABreakLabel, AContinueLabel: Integer;
                           var AStringLabel: String);
var
  EntryRec: TPAXEntryRec;
begin
  EntryRec := TPAXEntryRec.Create;
  with EntryRec do
  begin
    BreakLabel := ABreakLabel;
    ContinueLabel := AContinueLabel;
    StringLabel := AStringLabel;
  end;
  Add(EntryRec);

  AStringLabel := '';
end;

procedure TPAXEntryStack.Pop;
begin
  TPAXEntryRec(Items[Count - 1]).Free;
  Delete(Count - 1);
end;

function TPAXEntryStack.TopBreakLabel(const AStringLabel: String = ''): Integer;
var
  I: Integer;
  R: TPAXEntryRec;
begin
  if AStringLabel <> '' then
  begin
    for I:=Count - 1 downto 0 do
    begin
      R := TPAXEntryRec(Items[I]);
      with R do
        if StringLabel = AStringLabel then
        begin
          result := BreakLabel;
          Exit;
        end;
    end;
    raise TPAXScriptFailure.Create(errLabelIsNotFound);
  end
  else
    with TPAXEntryRec(Items[Count - 1]) do
      result := BreakLabel;
end;

function TPAXEntryStack.TopContinueLabel(const AStringLabel: String = ''): Integer;
var
  I: Integer;
begin
  if AStringLabel <> '' then
  begin
    for I:=Count - 1 downto 0 do
    with TPAXEntryRec(Items[I]) do
      if StringLabel = AStringLabel then
      begin
        result := ContinueLabel;
        Exit;
      end;
    raise TPAXScriptFailure.Create(errLabelIsNotFound);
  end
  else
    with TPAXEntryRec(Items[Count - 1]) do
      result := ContinueLabel;
end;

constructor TPAXIndexedList.Create;
begin
  inherited;
  fItems := TList.Create;
  Objects := TList.Create;
end;

function TPaxIndexedList.Count: Integer;
begin
  result := fItems.Count;
end;

procedure TPAXIndexedList.Clear;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    if Objects[I] <> nil then
    begin
      TObject(Objects[I]).Free;
      Objects[I] := nil;
    end;

  fItems.Clear;
  Objects.Clear;
end;

procedure TPAXIndexedList.Delete(I: Integer);
begin
  if Objects[I] <> nil then
    TObject(Objects[I]).Free;
  fItems.Delete(I);
  Objects.Delete(I);
end;

destructor TPAXIndexedList.Destroy;
begin
  Clear;
  fItems.Free;
  Objects.Free;
  inherited;
end;

function TPAXIndexedList.IndexOf(I: Integer): Integer;
var
  J: Integer;
begin
  result := -1;
  for J:=Count - 1 downto 0 do
    if Integer(fItems[J]) = I then
    begin
      result := J;
      Exit;
    end;
end;

function TPAXIndexedList.GetNameID(I: Integer): Integer;
begin
  result := Integer(fItems[I]);
end;

procedure TPAXIndexedList.SetNameID(I: Integer; Value: Integer);
begin
  fItems[I] := Pointer(Value);
end;

function TPAXIndexedList.AddObject(ID: Integer; AnObject: TObject): Integer;
begin
  result := fItems.Add(Pointer(ID));
  Objects.Add(AnObject);
end;

procedure TPAXIndexedList.DeleteObject(Index: Integer);
begin
  TObject(Objects[Index]).Free;

  Objects.Delete(Index);
  fItems.Delete(Index);
end;

function TPAXIndexedList.GetObject(ID: Integer): TObject;
var
  I: Integer;
begin
  I := IndexOf(ID);
  if I = - 1 then
    result := nil
  else
    result := Objects[I];
end;

constructor TPAXHashedIndexedList.Create;
begin
  inherited;
  HashTable := TPaxHashTable.Create;
end;

destructor TPAXHashedIndexedList.Destroy;
begin
  HashTable.Free;
  inherited;
end;

function TPAXHashedIndexedList.IndexOf(ID: Integer): Integer;
var
  found: boolean;
begin
  result := HashTable.FindValue(ID, found);
end;

function TPAXHashedIndexedList.AddObject(ID: Integer; AnObject: TObject): Integer;
begin
  result := fItems.Add(Pointer(ID));
  Objects.Add(AnObject);

  HashTable.Add(ID, result);
end;

function TPAXHashedIndexedList.GetObject(ID: Integer): TObject;
var
  I: Integer;
begin
  I := IndexOf(ID);
  if I = - 1 then
    result := nil
  else
    result := Objects[I];
end;

procedure TPAXHashedIndexedList.DeleteObject(Index: Integer);
var
  I: Integer;
begin
  TObject(Objects[Index]).Free;
  Objects.Delete(Index);
  fItems.Delete(Index);

  HashTable.Clear;
  for I := 0 to Count - 1 do
    HashTable.Add(Integer(fItems[I]), I);
end;

procedure TPAXHashedIndexedList.Clear;
begin
  inherited;
  HashTable.Clear;
end;

function TPAXTypes.AddType(const TypeName: String; TypeSize: Integer): Integer;
begin
  result := AddObject(TypeName, TObject(TypeSize));
end;

function TPAXTypes.GetSize(TypeID: Integer): Integer;
begin
  result := Integer(Objects[TypeID]);
end;

function TPAXTypes.GetTypeID(const TypeName: String): Integer;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    if StrEql(Strings[I], TypeName) then
    begin
      result := I;
      Exit;
    end;
  result := -1;


end;

constructor TPAXStack.Create;
begin
  SetLength(fItems, FirstStackSize);
  L := Length(fItems) - 1;
  Card := 0;
end;

procedure TPAXStack.Clear;
begin
  Card := 0;
end;

function TPAXStack.GetItem(I: Integer): Integer;
begin
  result := fItems[I];
end;

function TPAXStack.Push(I: Integer): Integer;
begin
  if Card = L then
  begin
    SetLength(fItems, Card + DeltaStackSize);
    L := Length(fItems) - 1;
  end;

  Inc(Card);
  fItems[Card] := I;
  result := I;
end;

function TPAXStack.IndexOf(I: Integer): Integer;
var
  J: Integer;
begin
  for J:=1 to Card do
    if fItems[J] = I then
    begin
      result := J;
      Exit;
    end;
  result := -1;
end;

function TPAXStack.PushUnique(I: Integer): Integer;
begin
  result := I;
  if IndexOf(I) = -1 then
    Push(I);
end;

procedure TPAXStack.Delete(I: Integer);
var
  Index, J: Integer;
begin
  Index := IndexOf(I);
  if Index = -1 then
    Exit;
  for J := Index to Card - 1 do
    fItems[J] := fItems[J+1];
  Dec(Card);
end;

procedure TPAXStack.Push(P: Pointer);
begin
  if Card = L then
  begin
    SetLength(fItems, Card + DeltaStackSize);
    L := Length(fItems) - 1;
  end;

  Inc(Card);
  fItems[Card] := Integer(P);
end;

function TPAXStack.Pop: Integer;
begin
  result := fItems[Card];
  Dec(Card);
end;

function TPAXStack.PopPointer: Pointer;
begin
  result := Pointer(fItems[Card]);
  Dec(Card);
end;

function TPAXStack.Top: Integer;
begin
  result := fItems[Card];
end;

procedure TPAXStack.SaveToStream(f: TStream);
begin
  f.Write(Card, SizeOf(Card));
  f.Write(fItems[1], Card*SizeOf(Integer));
end;

procedure TPAXStack.LoadFromStream(f: TStream);
begin
  f.Read(Card, SizeOf(Card));

  SetLength(fItems, Card + DeltaStackSize);
  L := Length(fItems) - 1;

  f.Read(fItems[1], Card*SizeOf(Integer));
end;

function TPAXStack.StackPtr: Pointer;
begin
  if Card > 0 then
    result := @fItems[Card]
  else
    result := nil;
end;

procedure TPAXStack.CopyFrom(S: TPAXStack);
var
  I: Integer;
begin
  SetLength(fItems, S.Card + DeltaStackSize);
  L := Length(fItems) - 1;

  for I:=1 to S.Card do
    fItems[I] := S.fItems[I];
  Card := S.Card;
end;

constructor TPAXFastStack.Create;
begin
  Card := 0;
end;

procedure TPAXFastStack.Clear;
begin
  Card := 0;
end;

function TPAXFastStack.GetItem(I: Integer): Integer;
begin
  result := fItems[I];
end;

function TPAXFastStack.Push(I: Integer): Integer;
begin
  Inc(Card);
  fItems[Card] := I;
  result := I;
end;

procedure TPAXFastStack.Push(P: Pointer);
begin
  Inc(Card);
  fItems[Card] := Integer(P);
end;

function TPAXFastStack.Pop: Integer;
begin
  result := fItems[Card];
  Dec(Card);
end;

function TPAXFastStack.PopPointer: Pointer;
begin
  result := Pointer(fItems[Card]);
  Dec(Card);
end;

function TPAXFastStack.Top: Integer;
begin
  result := fItems[Card];
end;

function TPAXFastStack.IndexOf(I: Integer): Integer;
var
  J: Integer;
begin
  for J:=1 to Card do
    if fItems[J] = I then
    begin
      result := J;
      Exit;
    end;
  result := -1;
end;

function TPAXFastStack.PushUnique(I: Integer): Integer;
begin
  result := I;
  if IndexOf(I) = -1 then
    Push(I);
end;

procedure TPAXFastStack.Delete(I: Integer);
var
  Index, J: Integer;
begin
  Index := IndexOf(I);
  if Index = -1 then
    Exit;
  for J := Index to Card - 1 do
    fItems[J] := fItems[J+1];
  Dec(Card);
end;

constructor TPAXNameList.Create;
begin
  inherited Create;
  HashArray := TPAXHashArray.Create;
  inherited Add('');
  NameIndex_Create := Add('Create');
  NameIndex_New := Add('New');
end;

destructor TPAXNameList.Destroy;
begin
  HashArray.Free;
  inherited;
end;

function TPAXNameList.GetSize: Integer;
var
  I: Integer;
begin
  result := 0;
  for I:=0 to Count - 1 do
    result := result + Length(Strings[I]) + 8;
  for I:=0 to MaxHash do
    result := result + HashArray.A[I].Count * 4;
end;

function TPAXNameList.Add(const S: string): Integer;
var
  _HashNumber: Integer;

function IndexOfName: Integer;
var
  I, NameIndex: Integer;
begin
  result := -1;
  for I:=0 to HashArray.A[_HashNumber].Count - 1 do
  begin
    NameIndex := Integer(HashArray.A[_HashNumber].Items[I]);
    if NameIndex >= 0 then
    if NameIndex < Count then
    if S = Strings[NameIndex] then
    begin
      result := NameIndex;
      Exit;
    end;
  end;
end;

begin
  if S = '' then
  begin
    result := 0;
    Exit;
  end;

  _HashNumber := HashNumber(S);

  result := IndexOfName;
  if result = -1 then
  begin
    result := inherited Add(S);
    HashArray.AddName(S, result, _HashNumber);
  end;
end;

function ArrayCreate(const P: array of Integer): Variant;
var
  Bounds: array of Integer;
  I, J, L: Integer;
begin
  L := Length(P);
  SetLength(Bounds, L + L);
  J := 0;
  for I:=0 to L - 1 do
  begin
    Bounds[J] := 0;
    Bounds[J+1] := P[I];
    Inc(J, 2);
  end;
  result := VarArrayCreate(Bounds, varVariant);
end;

procedure ArrayPut(V: PVariant; const Indexes: array of Integer; const Val: Variant);
var
  I, J, L, K1, K2: Integer;
  P: PVariant;
  R: array[1..100] of Integer;
begin
  L := VarArrayDimCount(V^);

{ if L = 1 then
  begin
    I := Indexes[0];
    V^[I] := Val;
    Exit;
  end; }

  R[1] := 1;
  for I:=1 to L do
  begin
    K1 := VarArrayLowBound(V^, I);
    K2 := VarArrayHighBound(V^, I);

    R[I + 1] := R[I] * (K2 - K1 + 1);
  end;

  J := 0;
  for I:=1 to L do
    J := J + R[I] * Indexes[I-1];

  P := VarArrayLock(V^);
  try
    P := ShiftPointer(P, J * _SizeVariant);
    P^ := Val;
  finally
    VarArrayUnlock(V^);
  end;
end;

function ArrayGet(V: PVariant; const Indexes: array of Integer): PVariant;
var
  I, J, L, K1, K2: Integer;
  P: PVariant;
  R: array[1..100] of Integer;
begin
  L := VarArrayDimCount(V^);

  R[1] := 1;
  for I:=1 to L do
  begin
    K1 := VarArrayLowBound(V^, I);
    K2 := VarArrayHighBound(V^, I);

    R[I + 1] := R[I] * (K2 - K1 + 1);
  end;

  J := 0;
  for I:=1 to L do
    J := J + R[I] * Indexes[I-1];

  P := VarArrayLock(V^);
  try
    P := ShiftPointer(P, J * _SizeVariant);
    result := P;
  finally
    VarArrayUnlock(V^);
  end;
end;

procedure BackUpTextFile(const FileName: String);
var
  S: String;
  T1, T2: TextFile;
  P: Integer;
begin
  P := Pos('.', FileName);
  if P > 0 then
    S := Copy(FileName, 1, P) + '~' + Copy(FileName, P + 1, 3)
  else
    S := FileName + '.~';

  AssignFile(T1, FileName);
  AssignFile(T2, S);
  Reset(T1);
  Rewrite(T2);

  try
    while not EOF(T1) do
    begin
      Readln(T1, S);
      Writeln(T2, S);
    end;
  finally
    Close(T1);
    Close(T2);
  end;
end;

function HasPublishedProperty(C: TClass; const PropName: String; Scripter: Pointer; NeedCheckForForbidden: Boolean = true): boolean;
var
  pti: PTypeInfo;
  ptd: PTypeData;
  pProps: PPropList;
  I, nProps: Integer;
  ppi: PPropInfo;
begin
  result := false;

  if NeedCheckForForbidden then
  if Scripter <> nil then
  if TPaxBaseScripter(Scripter).ForbiddenPublishedProperties.IndexOf(C) >= 0 then
    Exit;

  pti := C.ClassInfo;

  if not Assigned(pti) then
    Exit;

  ptd := GetTypeData(pti);
  nProps := ptd^.PropCount;

  if nProps > 0 then
  begin
    GetMem(pProps, SizeOf(PPropInfo) * nProps);
    GetPropInfos(pti, pProps);
  end
  else
    pProps := nil;

  for I:=0 to nProps - 1 do
  begin
    ppi := pProps[I];
    if StrEql(ppi^.Name, PropName) then
    begin
      result := true;
      Break;
    end;
  end;

  if nProps > 0 then
   FreeMem(pProps, SizeOf(PPropInfo) * nProps);
end;

function HasPublishedPropertyEx(C: TClass; const PropName: String; var ClassType: String; Scripter: Pointer): boolean;
var
  pti: PTypeInfo;
  ptd: PTypeData;
  pProps: PPropList;
  I, nProps: Integer;
  ppi: PPropInfo;
begin
  result := false;

  if Scripter <> nil then
  if TPaxBaseScripter(Scripter).ForbiddenPublishedProperties.IndexOf(C) >= 0 then
    Exit;

  ClassType := '';

  pti := C.ClassInfo;

  if not Assigned(pti) then
    Exit;

  ptd := GetTypeData(pti);
  nProps := ptd^.PropCount;

  if nProps > 0 then
  begin
    GetMem(pProps, SizeOf(PPropInfo) * nProps);
    GetPropInfos(pti, pProps);
  end
  else
    pProps := nil;

  for I:=0 to nProps - 1 do
  begin
    ppi := pProps[I];
    if StrEql(ppi^.Name, PropName) then
    begin
{$ifdef fp}
      if ppi^.PropType^.Kind = tkClass then
        ClassType := ppi^.PropType^.Name;
{$else}
      if ppi^.PropType^^.Kind = tkClass then
        ClassType := ppi^.PropType^^.Name;
{$endif}

      result := true;
      Break;
    end;
  end;

  if nProps > 0 then
   FreeMem(pProps, SizeOf(PPropInfo) * nProps);
end;

procedure GetPublishedPropertiesEx(AClass: TClass; result: TStrings);
var
  pti: PTypeInfo;
  ptd: PTypeData;
  Loop, nProps: Integer;
  pProps: PPropList;
  ppi: PPropInfo;
  S: String;
begin
  pti := AClass.ClassInfo;
  if pti = nil then Exit;
  ptd := GetTypeData(pti);
  nProps := ptd^.PropCount;
  if nProps > 0 then begin
    GetMem(pProps, SizeOf(PPropInfo) * nProps);
    GetPropInfos(pti, pProps);
  end
  else pProps := nil;
  for Loop:=0 to nProps - 1 do begin
    ppi := pProps[Loop];
    S := ppi^.Name;
    result.Add(S + ':' + ppi^.PropType^.Name);
  end;
  if pProps <> nil then
    FreeMem(pProps, SizeOf(PPropInfo) * nProps);
end;

procedure GetPublishedProperties(AClass: TClass; result: TStrings);
var
  pti: PTypeInfo;
  ptd: PTypeData;
  Loop, nProps: Integer;
  pProps: PPropList;
  ppi: PPropInfo;
  S: String;
begin
  pti := AClass.ClassInfo;
  if pti = nil then Exit;
  ptd := GetTypeData(pti);
  nProps := ptd^.PropCount;
  if nProps > 0 then begin
    GetMem(pProps, SizeOf(PPropInfo) * nProps);
    GetPropInfos(pti, pProps);
  end
  else pProps := nil;
  for Loop:=0 to nProps - 1 do begin
    ppi := pProps[Loop];
    S := ppi^.Name;
    result.Add(UpperCase(S));
  end;
  if pProps <> nil then
    FreeMem(pProps, SizeOf(PPropInfo) * nProps);
end;

function IsPublishedEventName(const S: String): boolean;
begin
  if Length(S) > 2 then
     result := (S[1] = 'O') and (S[2] = 'n') and (S[3] in ['A'..'Z', '0'..'9'])
  else
    result := false;
end;

procedure GetPublishedPropertiesEx2(AClass: TClass; result: TStrings);
var
  pti: PTypeInfo;
  ptd: PTypeData;
  Loop, nProps: Integer;
  pProps: PPropList;
  ppi: PPropInfo;
  S: String;
begin
  pti := AClass.ClassInfo;
  if pti = nil then Exit;
  ptd := GetTypeData(pti);
  nProps := ptd^.PropCount;
  if nProps > 0 then begin
    GetMem(pProps, SizeOf(PPropInfo) * nProps);
    GetPropInfos(pti, pProps);
  end
  else pProps := nil;
  for Loop:=0 to nProps - 1 do begin
    ppi := pProps[Loop];
    S := ppi^.Name;
    if not IsPublishedEventName(S) then
      result.Add(S);
  end;
  if pProps <> nil then
    FreeMem(pProps, SizeOf(PPropInfo) * nProps);
end;

procedure GetPublishedEvents(AClass: TClass; result: TStrings);
var
  pti: PTypeInfo;
  ptd: PTypeData;
  Loop, nProps: Integer;
  pProps: PPropList;
  ppi: PPropInfo;
  S: String;
begin
  pti := AClass.ClassInfo;
  if pti = nil then Exit;
  ptd := GetTypeData(pti);
  nProps := ptd^.PropCount;
  if nProps > 0 then begin
    GetMem(pProps, SizeOf(PPropInfo) * nProps);
    GetPropInfos(pti, pProps);
  end
  else pProps := nil;
  for Loop:=0 to nProps - 1 do begin
    ppi := pProps[Loop];
    S := ppi^.Name;
    if IsPublishedEventName(S) then
      result.Add(S);
  end;
  if pProps <> nil then
    FreeMem(pProps, SizeOf(PPropInfo) * nProps);
end;

procedure GetMethodList(FromClass: TClass; MethodList: TStrings);
type
  PPointer = ^Pointer;
  PMethodRec = ^TMethodRec;
  TMethodRec = packed record
    wSize: Word;
    pCode: Pointer;
    sName: ShortString;
  end;
var
  MethodTable: PChar;
  AClass: TClass;
  MethodRec: PMethodRec;
  wCount: Word;
  nMethod: integer;
begin
  MethodList.Clear;
  AClass := FromClass;
  while (AClass <> nil) do begin
    // Get a pointer to the class's published method table
    MethodTable := PChar( Pointer( PChar( AClass ) + vmtMethodTable )^ );
    if (MethodTable <> nil) then begin
      // Get the count of the methods in the table
      Move(MethodTable^, wCount, 2);
      // Position the MethodRec pointer at the first method in the table
      // (skip over the 2-byte method count)
      MethodRec := PMethodRec(MethodTable + 2);
      // Iterate through all the published methods of this class
      for nMethod := 0 to wCount - 1 do  begin
        // Add the method name and address to the MethodList TStrings
        MethodList.AddObject(MethodRec.sName, MethodRec.pCode);
        // Skip to the next method
        MethodRec := PMethodRec(PChar(MethodRec) + MethodRec.wSize);
      end;
    end;
    // Get the ancestor (parent) class
    AClass := AClass.ClassParent;
  end;
end;

function TPAXCodeList.IndexOfKey(const Key: String): Integer;
var
  I: Integer;
begin
  result := -1;
  for I:=0 to Count - 1 do
    if Records[I].Key = Key then
    begin
      result := I;
      Exit;
    end;
end;

function TPAXCodeList.AddCode(const Key, LanguageName, Code: String): TPAXCodeRec;
var
  Index: Integer;
  R: TPAXCodeRec;
begin
  Index := IndexOfKey(Key);
  if Index = -1 then
  begin
    R := TPAXCodeRec.Create;
    R.Key := Key;
    R.LanguageName := LanguageName;
    R.Code := Code;
    Index := Add(R);
  end;
  result := Records[Index];
end;

function TPAXCodeList.GetRecord(Index: Integer): TPAXCodeRec;
begin
  result := TPAXCodeRec(Items[Index]);
end;

procedure TPAXCodeList.Clear;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    Records[I].Free;

  inherited;
end;

function TPAXCodeList.GetCode(LanguageName: String): String;
var
  I: Integer;
begin
  result := '';
  for I:=0 to Count - 1 do
    if Records[I].LanguageName = LanguageName then
      result := result + Records[I].Code;
end;

constructor TPAXIds.Create(DupYes: Boolean);
begin
  inherited Create;
  Self.DupYes := DupYes;
end;

procedure TPAXIds.SaveToStream(S: TStream);
var
  I: Integer;
begin
  SaveInteger(Count, S);
  for I:=0 to Count - 1 do
    SaveInteger(Integer(Items[I]), S);
end;

procedure TPAXIds.LoadFromStream(S: TStream);
var
  I, K: Integer;
begin
  Clear;
  K := LoadInteger(S);
  for I:=0 to K - 1 do
    Add(LoadInteger(S));
end;

function TPAXIds.GetID(Index: Integer): Integer;
begin
  result := Integer(Items[Index]);
end;

procedure TPAXIds.PutID(Index: Integer; Value: Integer);
begin
  Items[Index] := Pointer(Value);
end;

function TPAXIds.Add(ID: Integer): Integer;
begin
  if DupYes then
  begin
    result := inherited Add(Pointer(ID));
    Exit;
  end;

  result := IndexOf(ID);
  if result = -1 then
    result := inherited Add(Pointer(ID));
end;

function TPAXIds.IndexOf(ID: Integer): Integer;
begin
  result := inherited IndexOf(Pointer(ID));
end;

procedure AddOPResultType(T1, T2, R: Integer);
begin
  OpResultTypes[T1, T2] := R;
  OPResultTypes[T2, T1] := R;
end;

procedure AddAssResultType(T1, T2: Integer);
begin
  AssResultTypes[T1, T2] := true;
end;

function IsNumericString(const S: String): Boolean;
var
  I: Integer;
begin
  if S = '' then
  begin
    result := false;
    Exit;
  end;

  result := true;
  for I:=1 to Length(S) do
    if not (S[I] in ['0'..'9','.','+','-','e','E']) then
    begin
      result := false;
      Exit;
    end;
end;

function _Floor(X: Extended): Int64;
begin
  result := Trunc(X);
  if Frac(X) < 0 then
    Dec(result);
end;

function DelphiDateTimeToEcmaTime(const AValue: TDateTime): Int64;
var
  T: TTimeStamp;
  D1970: TDateTime;
begin
  D1970 := EncodeDate(1970,1,1);

  T := DateTimeToTimeStamp(AValue);
  Result := (_Floor(AValue) - _Floor(D1970)) * MSecsPerDay + T.Time;
end;

function EcmaTimeToDelphiDateTime(const AValue: Variant): TDateTime;
var
  TimeStamp: TTimeStamp;
  D1970: TDateTime;
begin
  D1970 := EncodeDate(1970,1,1);

  TimeStamp := DateTimeToTimeStamp(D1970);

  TimeStamp.Time := _Floor(AValue) mod MSecsPerDay;
  TimeStamp.Date := TimeStamp.Date + _Floor(AValue) div MSecsPerDay;

  result := TimeStampToDateTime(TimeStamp);
end;

{$IFDEF LINUX}
function GetGMTDifference: Double;
begin
  result := 0;
end;
{$ELSE}
function GetGMTDifference: Double;
var
  TZ: TTimeZoneInformation;
begin
  GetTimeZoneInformation(TZ);
  if TZ.Bias = 0 then
    Result := 0
  else if TZ.Bias < 0 then
  begin
    if TZ.Bias mod 60 = 0 then
      Result := Abs(TZ.Bias) div 60
    else
      Result := Abs(TZ.Bias) / 60;
  end
  else
  begin
    if TZ.Bias mod 60 = 0 then
      Result := - TZ.Bias div 60
    else
      Result := - TZ.Bias / 60;
  end;
end;
{$ENDIF}

function GetRefCountPtr(const S: String): Pointer;
begin
  if Pointer(S) <> nil then
    result := Pointer(Integer(Pointer(S)) - 8)
  else
    result := nil;
end;

function GetRefCount(const S: String): Integer;
begin
  result := Integer(GetRefCountPtr(S)^);
end;

function GetSizePtr(const S: String): Pointer;
begin
  if Pointer(S) <> nil then
    result := Pointer(Integer(Pointer(S)) - 4)
  else
    result := nil;
end;

constructor TPAXAssocList.Create;
begin
  fItems := TList.Create;
end;

destructor TPAXAssocList.Destroy;
begin
  Clear;
  fItems.Free;
end;

function TPAXAssocList.GetItem(I: Integer): TPAXAssocRec;
begin
  result := TPAXAssocRec(fItems[I]);
end;

function CompareTVarRecs(const R1, R2: TVarRec): Boolean;
begin
  result := false;
  if R1.VType <> R2.VType then
    Exit;
  case R1.VType of
    vtInteger: result := R1.VInteger = R2.VInteger;
    vtBoolean: result := R1.VBoolean = R2.VBoolean;
    vtChar: result := R1.VChar = R2.VChar;
    vtExtended: result := R1.VExtended = R2.VExtended;
    vtString: result := R1.VString = R2.VString;
    vtPointer: result := R1.VPointer = R2.VPointer;
    vtPChar: result := R1.VPChar = R2.VPChar;
    vtObject: result := R1.VObject = R2.VObject;
    vtClass: result := R1.VClass = R2.VClass;
    vtWideChar: result := R1.VWideChar = R2.VWideChar;
    vtPWideChar: result := R1.VPWideChar = R2.VPWideChar;
    vtAnsiString: result := R1.VAnsiString = R2.VAnsiString;
    vtCurrency: result := R1.VCurrency = R2.VCurrency;
    vtVariant: result := R1.VVariant = R2.VVariant;
    vtInterface: result := R1.VInterface = R2.VInterface;
    vtWideString: result := R1.VWideString = R2.VWideString;
    vtInt64: result := R1.VInt64 = R2.VInt64;
  end;
end;

function TPAXAssocList.FindObject(const Data: TVarRec): TObject;
var
  I: Integer;
  R: TPAXAssocRec;
begin
  for I:=0 to fItems.Count - 1 do
  begin
    R := Items[I];
    if CompareTVarRecs(R.Data, Data) then
    begin
      result := R.Obj;
      Exit;
    end;
  end;
  result := nil;
end;

function TPAXAssocList.Add(const Data: TVarRec; Obj: TObject): Integer;
var
  R: TPAXAssocRec;
begin
  R := TPAXAssocRec.Create;
  R.Data := Data;
  R.Obj := Obj;
  result := fItems.Add(R);
end;

procedure TPAXAssocList.Clear;
var
  I: Integer;
  R: TPAXAssocRec;
begin
  for I:=0 to fItems.Count - 1 do
  begin
    R := Items[I];
    R.Obj.Free;
    R.Free;
  end;
  fItems.Clear;
end;

function GetImplementorOfInterface(const I: IUnknown): TObject;
{ TODO -cDOC : Original code by Hallvard Vassbotn }
{ TODO -cTesting : Check the implemetation for any further version of compiler }
const
  AddByte = $04244483; // opcode for ADD DWORD PTR [ESP+4], Shortint
  AddLong = $04244481; // opcode for ADD DWORD PTR [ESP+4], Longint
type
  PAdjustSelfThunk = ^TAdjustSelfThunk;
  TAdjustSelfThunk = packed record
    case AddInstruction: Longint of
      AddByte: (AdjustmentByte: ShortInt);
      AddLong: (AdjustmentLong: Longint);
  end;
  PInterfaceMT = ^TInterfaceMT;
  TInterfaceMT = packed record
    QueryInterfaceThunk: PAdjustSelfThunk;
  end;
  TInterfaceRef = ^PInterfaceMT;
var
  QueryInterfaceThunk: PAdjustSelfThunk;
begin
  try
    Result := Pointer(I);
    if Assigned(Result) then
    begin
      QueryInterfaceThunk := TInterfaceRef(I)^.QueryInterfaceThunk;
      case QueryInterfaceThunk.AddInstruction of
        AddByte:
          Inc(PChar(Result), QueryInterfaceThunk.AdjustmentByte);
        AddLong:
          Inc(PChar(Result), QueryInterfaceThunk.AdjustmentLong);
      else
        Result := nil;
      end;
    end;
  except
    Result := nil;
  end;
end;

function PosCh(ch: Char; const S: String): Integer;
var
  I: integer;
begin
  for I:=1 to Length(S) do
    if ch = S[I] then
    begin
      result := I;
      Exit;
    end;
  result := 0;
end;


procedure Initialization_BASE_SYS;
begin
  Initialization_BASE_SYNC;

  PAXTypes := TPAXTypes.Create;
  with PAXTypes do
  begin
    AddType('VOID', 0);
    AddType('VARIANT', SizeOf(Variant));
    AddType('OLEVARIANT', SizeOf(TOleVariant));
    AddType('BYTE', SizeOf(TByte));
    AddType('CHAR', SizeOf(TChar));
    AddType('BOOLEAN', SizeOf(TBoolean));
    AddType('WORDBOOL', SizeOf(TWordBool));
    AddType('LONGBOOL', SizeOf(TLongBool));
    AddType('INTEGER', SizeOf(TInteger));
    AddType('CARDINAL', SizeOf(TCardinal));
    AddType('POINTER', SizeOf(TPointer));
    AddType('DOUBLE',    SizeOf(TDouble));
    AddType('STRING',  SizeOf(TString));
    AddType('#ENUMERATION', SizeOf(TInteger));
    AddType('RECORD',  -1);
    AddType('ARRAY', -1);
    AddType('SHORTSTRING',-1);
    AddType('TEXTFILE',SizeOf(TTextFile));
    AddType('#SUBRANGE', SizeOf(TInteger));
    AddType('SET', -1);
    AddType('CLASS',  SizeOf(TPointer));
    AddType('#CLASSREF',  SizeOf(TPointer));
    AddType('#DYNAMICARRAY', SizeOf(TPointer));
    AddType('PCHAR', SizeOf(Pointer));
    AddType('WORD',  SizeOf(TWord));
    AddType('SHORTINT', SizeOf(TShortInt));
    AddType('SMALLINT', SizeOf(TSmallInt));
    AddType('INT64',  SizeOf(TInt64));
    AddType('SINGLE', SizeOf(TSingle));
    AddType('CURRENCY', SizeOf(TCurrency));
    AddType('COMP', SizeOf(TComp));
    AddType('REAL48', SizeOf(TReal48));
    AddType('EXTENDED', SizeOf(TExtended));
    AddType('INTERFACE', SizeOf(Integer));
    AddType('#METHOD', SizeOf(TMethod));
    AddType('FILE', SizeOf(TFile));
    AddType('WIDECHAR',  SizeOf(TWideChar));
    AddType('WIDESTRING',  SizeOf(TWideString));
    AddType('PWIDECHAR', SizeOf(PWideChar));
    AddType('TVarRec', SizeOf(TVarRec));
  end;

  PAXKinds := TStringList.Create;
  with PAXKinds do
  begin
    Add('NONE');
    Add('VAR');
    Add('TYPE');
    Add('CONST');
    Add('SUB');
    Add('REF');
    Add('PROP');
    Add('LABEL');
    Add('HVAR');
    Add('HCONST');
    Add('HOBJECT');
    Add('HINTF');
    Add('VOBJECT');
  end;

  PAXOperators := TPAXOperators.Create;
  with PAXOperators do
  begin
    OP_SEPARATOR := BOUND_OPER - Add('SEPARATOR');
    OP_NOP := BOUND_OPER - Add('NOP');
    OP_SKIP := BOUND_OPER - Add('SKIP');
    OP_HALT := BOUND_OPER - Add('HALT');
    OP_HALT_GLOBAL := BOUND_OPER - Add('HALT GLOBAL');
    OP_HALT_OR_NOP := BOUND_OPER - Add('HALT OR NOP');
    OP_PRINT := BOUND_OPER - Add('PRINT');
    OP_PRINT_HTML := BOUND_OPER - Add('PRINT HTML');

    OP_GO := BOUND_OPER - Add('GO');
    OP_GO_FALSE := BOUND_OPER - Add('GO_FALSE');
    OP_GO_FALSE_EX := BOUND_OPER - Add('GO_FALSE(EX)');
    OP_GO_TRUE := BOUND_OPER - Add('GO_TRUE');
    OP_GO_TRUE_EX := BOUND_OPER - Add('GO_TRUE(EX)');

    OP_SET_LABEL := BOUND_OPER - Add('SET LABEL');

    OP_BEGIN_METHOD := BOUND_OPER - Add('BEGIN METHOD');
    OP_CREATE_ARRAY := BOUND_OPER - Add('CREATE ARRAY');
    OP_CREATE_DYNAMIC_ARRAY_TYPE := BOUND_OPER - Add('CREATE DYNAMIC ARRAY TYPE');
    OP_GET_FIELD := BOUND_OPER - Add('GET FIELD');

    OP_CREATE_SHORT_STRING := BOUND_OPER - Add('CREATE SHORT STRING');

    OP_DO_NOT_DESTROY := BOUND_OPER - Add('DO NOT DESTROY');

    OP_CREATE_OBJECT := BOUND_OPER - Add('CREATE OBJECT');
    OP_CREATE_RESULT := BOUND_OPER - Add('CREATE RESULT');
    OP_CHECK_CLASS := BOUND_OPER - Add('CHECK_CLASS');
    OP_SET_TYPE := BOUND_OPER - Add('SET_TYPE');
    OP_DESTROY_HOST := BOUND_OPER - Add('DESTROY HOST');
    OP_DESTROY_OBJECT := BOUND_OPER - Add('DESTROY OBJECT');
    OP_DESTROY_LOCAL_VAR := BOUND_OPER - Add('DESTROY LOCAL VAR');
    OP_DESTROY_INTF := BOUND_OPER - Add('DESTROY INTF');
    OP_RELEASE := BOUND_OPER - Add('RELEASE');
    OP_CREATE_REF := BOUND_OPER - Add('CREATE REF');
    OP_USE_NAMESPACE := BOUND_OPER - Add('USE NAMESPACE');
    OP_END_OF_NAMESPACE := BOUND_OPER - Add('END OF NAMESPACE');
    OP_BEGIN_WITH := BOUND_OPER - Add('BEGIN WITH');
    OP_END_WITH := BOUND_OPER - Add('END WITH');
    OP_EVAL_WITH := BOUND_OPER - Add('EVAL WITH');
    OP_IN := BOUND_OPER - Add('IN');
    OP_IN_SET := BOUND_OPER - Add('IN SET');
    OP_INSTANCEOF := BOUND_OPER - Add('INSTANCEOF');
    OP_TYPEOF := BOUND_OPER - Add('TYPEOF');
    OP_GET_NEXT_PROP := BOUND_OPER - Add('GET NEXT PROP');
    OP_SAVE_RESULT := BOUND_OPER - Add('SAVE RESULT');
    OP_GET_ANCESTOR_NAME := BOUND_OPER - Add('GET ANCESTOR NAME');

    OP_PUSH := BOUND_OPER - Add('PUSH');
    OP_PUT_PROPERTY := BOUND_OPER - Add('PUT PROPERTY');
    OP_CALL := BOUND_OPER - Add('CALL');
    OP_CALL_CONSTRUCTOR := BOUND_OPER - Add('CALL CONSTRUCTOR');
    OP_TYPE_CAST := BOUND_OPER - Add('TYPE CAST');
    OP_RET := BOUND_OPER - Add('RET');
    OP_EXIT0 := BOUND_OPER - Add('EXIT0');
    OP_EXIT := BOUND_OPER - Add('EXIT');
    OP_RETURN := BOUND_OPER - Add('RETURN');
    OP_GET_PARAM_COUNT := BOUND_OPER - Add('GET PARAM COUNT');
    OP_GET_PARAM := BOUND_OPER - Add('GET PARAM');
    OP_GET_PUBLISHED_PROPERTY := BOUND_OPER - Add('GET PUBLISHED PROPERTY');
    OP_PUT_PUBLISHED_PROPERTY := BOUND_OPER - Add('PUT PUBLISHED PROPERTY');
    OP_RET_OPERATOR := BOUND_OPER - Add('RET OPERATOR');

    OP_GET_ITEM := BOUND_OPER - Add('GET ITEM');
    OP_PUT_ITEM := BOUND_OPER - Add('PUT ITEM');
    OP_GET_ITEM_EX := BOUND_OPER - Add('GET ITEM(ex)');
    OP_PUT_ITEM_EX := BOUND_OPER - Add('PUT ITEM(ex)');

    OP_GET_STRING_ELEMENT := BOUND_OPER - Add('GET STRING ELEMENT');
    OP_PUT_STRING_ELEMENT := BOUND_OPER - Add('PUT STRING ELEMENT');

    OP_FINALLY := BOUND_OPER - Add('FINALLY');
    OP_CATCH := BOUND_OPER - Add('CATCH');
    OP_TRY_ON := BOUND_OPER - Add('TRY_ON');
    OP_TRY_OFF := BOUND_OPER - Add('TRY_OFF');
    OP_THROW := BOUND_OPER - Add('THROW');
    OP_DISCARD_ERROR := BOUND_OPER - Add('DISCARD ERROR');
    OP_EXIT_ON_ERROR := BOUND_OPER - Add('EXIT ON ERROR');

    OP_ASSIGN := BOUND_OPER - Add(':=');
    OP_ASSIGN_ADDRESS := BOUND_OPER - Add('ASSIGN ADDRESS');
    OP_GET_TERMINAL := BOUND_OPER - Add('GET TERMINAL');
    OP_ASSIGN_RESULT := BOUND_OPER - Add(':=(RES)');

    OP_AND := BOUND_OPER - Add('AND');
    OP_OR := BOUND_OPER - Add('OR');
    OP_XOR := BOUND_OPER - Add('XOR');
    OP_NOT := BOUND_OPER - Add('NOT');

    OP_LEFT_SHIFT := BOUND_OPER - Add('LEFT SHIFT');
    OP_LEFT_SHIFT_EX := BOUND_OPER - Add('LEFT SHIFT(ex)');

    OP_RIGHT_SHIFT := BOUND_OPER - Add('RIGHT SHIFT');
    OP_RIGHT_SHIFT_EX := BOUND_OPER - Add('RIGHT SHIFT(ex)');

    OP_UNSIGNED_RIGHT_SHIFT := BOUND_OPER - Add('UNSIGNED RIGHT SHIFT');
    OP_UNSIGNED_RIGHT_SHIFT_EX := BOUND_OPER - Add('UNSIGNED RIGHT SHIFT(ex)');

    OP_PLUS := BOUND_OPER - Add('+');
    OP_PLUS_EX := BOUND_OPER - Add('+(ex)');

    OP_MINUS := BOUND_OPER - Add('-');
    OP_MINUS_EX := BOUND_OPER - Add('-(ex)');

    OP_UNARY_PLUS := BOUND_OPER - Add('+(unary)');

    OP_UNARY_MINUS := BOUND_OPER - Add('-(unary)');
    OP_UNARY_MINUS_EX := BOUND_OPER - Add('-(unary ex)');

    OP_MULT := BOUND_OPER - Add('*');
    OP_MULT_EX := BOUND_OPER - Add('*(ex)');

    OP_DIV := BOUND_OPER - Add('/');
    OP_DIV_EX := BOUND_OPER - Add('/(ex)');

    OP_INT_DIV := BOUND_OPER - Add('DIV');

    OP_MOD := BOUND_OPER - Add('MOD');
    OP_MOD_EX := BOUND_OPER - Add('MOD(ex)');

    OP_POWER := BOUND_OPER - Add('POWER');

    OP_LT := BOUND_OPER - Add('<');
    OP_LT_EX := BOUND_OPER - Add('<(ex)');

    OP_GT := BOUND_OPER - Add('>');
    OP_GT_EX := BOUND_OPER - Add('>(ex)');

    OP_EQ := BOUND_OPER - Add('=');
    OP_EQ_EX := BOUND_OPER - Add('=(ex)');

    OP_NE := BOUND_OPER - Add('<>');
    OP_NE_EX := BOUND_OPER - Add('<>(ex)');

    OP_ID := BOUND_OPER - Add('===');
    OP_ID_EX := BOUND_OPER - Add('===(ex)');

    OP_NI := BOUND_OPER - Add('!==');
    OP_NI_EX := BOUND_OPER - Add('!==(ex)');

    OP_GE := BOUND_OPER - Add('>=');
    OP_GE_EX := BOUND_OPER - Add('>=(ex)');

    OP_LE := BOUND_OPER - Add('<=');
    OP_LE_EX := BOUND_OPER - Add('<=(ex)');

    OP_IS := BOUND_OPER - Add('IS');
    OP_AS := BOUND_OPER - Add('AS');


    OP_TO_INTEGER := BOUND_OPER - Add('TO INTEGER');
    OP_TO_STRING := BOUND_OPER - Add('TO STRING');
    OP_TO_BOOLEAN := BOUND_OPER - Add('TO BOOLEAN');

    OP_DEFINE := BOUND_OPER - Add('DEFINE');

    OP_DECLARE_ON := BOUND_OPER - Add('DECLARE ON');
    OP_DECLARE_OFF := BOUND_OPER - Add('DECLARE OFF');

    OP_UPCASE_ON := BOUND_OPER - Add('UPCASE ON');
    OP_UPCASE_OFF := BOUND_OPER - Add('UPCASE OFF');

    OP_OPTIMIZATION_ON := BOUND_OPER - Add('OPTIM ON');
    OP_OPTIMIZATION_OFF := BOUND_OPER - Add('OPTIM OFF');

    OP_JS_OPERS_ON := BOUND_OPER - Add('JS OPERS ON');
    OP_JS_OPERS_OFF := BOUND_OPER - Add('JS OPERS OFF');

    OP_ZERO_BASED_STRINGS_ON := BOUND_OPER - Add('ZERO ON');
    OP_ZERO_BASED_STRINGS_OFF := BOUND_OPER - Add('ZERO OFF');

    OP_VBARRAYS_ON := BOUND_OPER - Add('VBARRAYS ON');
    OP_VBARRAYS_OFF := BOUND_OPER - Add('VBARRAYS OFF');

    OP_USE_LANGUAGE_NAMESPACE := BOUND_OPER - Add('USE LANG');

//-------------------------------------------------------
    FOP_INC1 := BOUND_OPER - Add('INC(FOP 1)');
    FOP_INC2 := BOUND_OPER - Add('INC(FOP 2)');

    FOP_PLUS_INTEGER1 := BOUND_OPER - Add('+(FOP INTEGER 1)');
    FOP_PLUS_INTEGER2 := BOUND_OPER - Add('+(FOP INTEGER 2)');
    FOP_PLUS_DOUBLE1 := BOUND_OPER - Add('+(FOP DOUBLE 1)');
    FOP_PLUS_DOUBLE2 := BOUND_OPER - Add('+(FOP DOUBLE 2)');
    FOP_PLUS_STRING1 := BOUND_OPER - Add('+(FOP STRING 1)');
    FOP_PLUS_STRING2 := BOUND_OPER - Add('+(FOP STRING 2)');

    FOP_MINUS_INTEGER1 := BOUND_OPER - Add('-(FOP INTEGER 1)');
    FOP_MINUS_INTEGER2 := BOUND_OPER - Add('-(FOP INTEGER 2)');
    FOP_MINUS_DOUBLE1 := BOUND_OPER - Add('-(FOP DOUBLE 1)');
    FOP_MINUS_DOUBLE2 := BOUND_OPER - Add('-(FOP DOUBLE 2)');

    FOP_MULT_INTEGER1 := BOUND_OPER - Add('*(FOP INTEGER 1)');
    FOP_MULT_INTEGER2 := BOUND_OPER - Add('*(FOP INTEGER 2)');
    FOP_MULT_DOUBLE1 := BOUND_OPER - Add('*(FOP DOUBLE 1)');
    FOP_MULT_DOUBLE2 := BOUND_OPER - Add('*(FOP DOUBLE 2)');

    FOP_DIV_INTEGER1 := BOUND_OPER - Add('/(FOP INTEGER 1)');
    FOP_DIV_INTEGER2 := BOUND_OPER - Add('/(FOP INTEGER 2)');
    FOP_DIV_DOUBLE1 := BOUND_OPER - Add('/(FOP DOUBLE 1)');
    FOP_DIV_DOUBLE2 := BOUND_OPER - Add('/(FOP DOUBLE 2)');

    FOP_MOD1 := BOUND_OPER - Add('MOD(FOP 1)');
    FOP_MOD2 := BOUND_OPER - Add('MOD(FOP 2)');

    FOP_LT_INTEGER1 := BOUND_OPER - Add('<(FOP INTEGER 1)');
    FOP_LT_INTEGER2 := BOUND_OPER - Add('<(FOP INTEGER 2)');
    FOP_LT_DOUBLE1 := BOUND_OPER - Add('<(FOP DOUBLE 1)');
    FOP_LT_DOUBLE2 := BOUND_OPER - Add('<(FOP DOUBLE 2)');

    FOP_LE_INTEGER1 := BOUND_OPER - Add('<=(FOP INTEGER 1)');
    FOP_LE_INTEGER2 := BOUND_OPER - Add('<=(FOP INTEGER 2)');
    FOP_LE_DOUBLE1 := BOUND_OPER - Add('<=(FOP DOUBLE 1)');
    FOP_LE_DOUBLE2 := BOUND_OPER - Add('<=(FOP DOUBLE 2)');

    FOP_GT_INTEGER1 := BOUND_OPER - Add('>(FOP INTEGER 1)');
    FOP_GT_INTEGER2 := BOUND_OPER - Add('>(FOP INTEGER 2)');
    FOP_GT_DOUBLE1 := BOUND_OPER - Add('>(FOP DOUBLE 1)');
    FOP_GT_DOUBLE2 := BOUND_OPER - Add('>(FOP DOUBLE 2)');

    FOP_GE_INTEGER1 := BOUND_OPER - Add('>=(FOP INTEGER 1)');
    FOP_GE_INTEGER2 := BOUND_OPER - Add('>=(FOP INTEGER 2)');
    FOP_GE_DOUBLE1 := BOUND_OPER - Add('>=(FOP DOUBLE 1)');
    FOP_GE_DOUBLE2 := BOUND_OPER - Add('>=(FOP DOUBLE 2)');

    FOP_EQ_INTEGER1 := BOUND_OPER - Add('=(FOP INTEGER 1)');
    FOP_EQ_INTEGER2 := BOUND_OPER - Add('=(FOP INTEGER 2)');
    FOP_EQ_DOUBLE1 := BOUND_OPER - Add('=(FOP DOUBLE 1)');
    FOP_EQ_DOUBLE2 := BOUND_OPER - Add('=(FOP DOUBLE 2)');

    FOP_NE_INTEGER1 := BOUND_OPER - Add('<>(FOP INTEGER 1)');
    FOP_NE_INTEGER2 := BOUND_OPER - Add('<>(FOP INTEGER 2)');
    FOP_NE_DOUBLE1 := BOUND_OPER - Add('<>(FOP DOUBLE 1)');
    FOP_NE_DOUBLE2 := BOUND_OPER - Add('<>(FOP DOUBLE 2)');

    FOP_BITWISE_AND1 := BOUND_OPER - Add('AND_BITWISE(FOP 1)');
    FOP_BITWISE_AND2 := BOUND_OPER - Add('AND_BITWISE(FOP 2)');

    FOP_BITWISE_OR1 := BOUND_OPER - Add('OR_BITWISE(FOP 1)');
    FOP_BITWISE_OR2 := BOUND_OPER - Add('OR_BITWISE(FOP 2)');

    FOP_BITWISE_XOR1 := BOUND_OPER - Add('XOR_BITWISE(FOP 1)');
    FOP_BITWISE_XOR2 := BOUND_OPER - Add('XOR_BITWISE(FOP 2)');

    FOP_LOGICAL_AND1 := BOUND_OPER - Add('AND_LOGICAL(FOP 1)');
    FOP_LOGICAL_AND2 := BOUND_OPER - Add('AND_LOGICAL(FOP 2)');

    FOP_LOGICAL_OR1 := BOUND_OPER - Add('OR_LOGICAL(FOP 1)');
    FOP_LOGICAL_OR2 := BOUND_OPER - Add('OR_LOGICAL(FOP 2)');

    FOP_LOGICAL_XOR1 := BOUND_OPER - Add('XOR_LOGICAL(FOP 1)');
    FOP_LOGICAL_XOR2 := BOUND_OPER - Add('XOR_LOGICAL(FOP 2)');

    FOP_BITWISE_NOT1 := BOUND_OPER - Add('NOT_BITWISE(FOP 1)');
    FOP_BITWISE_NOT2 := BOUND_OPER - Add('NOT_BITWISE(FOP 2)');

    FOP_LOGICAL_NOT1 := BOUND_OPER - Add('NOT_LOGICAL(FOP 1)');
    FOP_LOGICAL_NOT2 := BOUND_OPER - Add('NOT_LOGICAL(FOP 2)');

    FOP_UNARY_MINUS_INTEGER1 := BOUND_OPER - Add('-(unary FOP INTEGER 1)');
    FOP_UNARY_MINUS_INTEGER2 := BOUND_OPER - Add('-(unary FOP INTEGER 2)');

    FOP_UNARY_MINUS_DOUBLE1 := BOUND_OPER - Add('-(unary FOP DOUBLE 1)');
    FOP_UNARY_MINUS_DOUBLE2 := BOUND_OPER - Add('-(unary FOP DOUBLE 2)');

    FOP_SHL1 := BOUND_OPER - Add('SHL(FOP 1)');
    FOP_SHL2 := BOUND_OPER - Add('SHL(FOP 2)');

    FOP_SHR1 := BOUND_OPER - Add('SHR(FOP 1)');
    FOP_SHR2 := BOUND_OPER - Add('SHR(FOP 2)');

    FOP_USHR1 := BOUND_OPER - Add('USHR(FOP 1)');
    FOP_USHR2 := BOUND_OPER - Add('USHR(FOP 2)');

    FOP_ASSIGN := BOUND_OPER - Add(':=(FOP)');
    FOP_GO_FALSE1 := BOUND_OPER - Add('GO_FALSE(FOP 1)');
    FOP_GO_FALSE2 := BOUND_OPER - Add('GO_FALSE(FOP 2)');
    FOP_GO_TRUE1 := BOUND_OPER - Add('GO_TRUE(FOP 1)');
    FOP_GO_TRUE2 := BOUND_OPER - Add('GO_TRUE(FOP 2)');

//=========================================
    FOP_PUSH := BOUND_OPER - Add('PUSH(FOP)');
    FOP_CALL := BOUND_OPER - Add('CALL(FOP)');

    FOP_PLUS1 := BOUND_OPER - Add('+(FOP 1)');
    FOP_PLUS2 := BOUND_OPER - Add('+(FOP 2)');

    FOP_MINUS1 := BOUND_OPER - Add('-(FOP 1)');
    FOP_MINUS2 := BOUND_OPER - Add('-(FOP 2)');

    FOP_MULT1 := BOUND_OPER - Add('*(FOP 1)');
    FOP_MULT2 := BOUND_OPER - Add('*(FOP 2)');

    FOP_DIV1 := BOUND_OPER - Add('/(FOP 1)');
    FOP_DIV2 := BOUND_OPER - Add('/(FOP 2)');

    FOP_LT1 := BOUND_OPER - Add('<(FOP 1)');
    FOP_LT2 := BOUND_OPER - Add('<(FOP 2)');

    FOP_LE1 := BOUND_OPER - Add('<=(FOP 1)');
    FOP_LE2 := BOUND_OPER - Add('<=(FOP 2)');

    FOP_GT1 := BOUND_OPER - Add('>(FOP 1)');
    FOP_GT2 := BOUND_OPER - Add('>(FOP 2)');

    FOP_GE1 := BOUND_OPER - Add('>=(FOP 1)');
    FOP_GE2 := BOUND_OPER - Add('>=(FOP 2)');

    FOP_EQ1 := BOUND_OPER - Add('=(FOP 1)');
    FOP_EQ2 := BOUND_OPER - Add('=(FOP 2)');

    FOP_NE1 := BOUND_OPER - Add('<>(FOP 1)');
    FOP_NE2 := BOUND_OPER - Add('<>(FOP 2)');

    OP_ON_USES := BOUND_OPER - Add('ON USES');
    OP_DECLARE := BOUND_OPER - Add('DECLARE');

    OP_ASSIGN_SIMPLE := BOUND_OPER - Add('ASSIGN_SIMPLE');

    FillChar(OpResultTypes, SizeOf(OpResultTypes), 0);
    AddOpResultType(typeINTEGER, typeCARDINAL, typeINTEGER);
    AddOpResultType(typeINTEGER, typeINT64, typeINT64);
    AddOpResultType(typeINTEGER, typeDOUBLE, typeDOUBLE);
    AddOpResultType(typeINTEGER, typeCURRENCY, typeCURRENCY);
    AddOpResultType(typeINTEGER, typeEXTENDED, typeEXTENDED);
    AddOpResultType(typeINTEGER, typeSINGLE, typeSINGLE);
    AddOpResultType(typeINTEGER, typeBYTE, typeINTEGER);
    AddOpResultType(typeINTEGER, typeWORD, typeINTEGER);
    AddOpResultType(typeINTEGER, typeSHORTINT, typeINTEGER);
    AddOpResultType(typeINTEGER, typeSMALLINT, typeINTEGER);

    AddOpResultType(typeCARDINAL, typeINT64, typeINT64);
    AddOpResultType(typeCARDINAL, typeDOUBLE, typeDOUBLE);
    AddOpResultType(typeCARDINAL, typeCURRENCY, typeCURRENCY);
    AddOpResultType(typeCARDINAL, typeSINGLE, typeSINGLE);
    AddOpResultType(typeCARDINAL, typeBYTE, typeINTEGER);
    AddOpResultType(typeCARDINAL, typeWORD, typeINTEGER);
    AddOpResultType(typeCARDINAL, typeSHORTINT, typeINTEGER);
    AddOpResultType(typeCARDINAL, typeSMALLINT, typeINTEGER);

    AddOpResultType(typeINT64, typeDOUBLE, typeDOUBLE);
    AddOpResultType(typeINT64, typeCURRENCY, typeCURRENCY);
    AddOpResultType(typeINT64, typeSINGLE, typeSINGLE);
    AddOpResultType(typeINT64, typeBYTE, typeINT64);
    AddOpResultType(typeINT64, typeWORD, typeINT64);
    AddOpResultType(typeINT64, typeSHORTINT, typeINT64);
    AddOpResultType(typeINT64, typeSMALLINT, typeINT64);

    AddOpResultType(typeBYTE, typeDOUBLE, typeDOUBLE);
    AddOpResultType(typeBYTE, typeCURRENCY, typeCURRENCY);
    AddOpResultType(typeBYTE, typeSINGLE, typeSINGLE);
    AddOpResultType(typeBYTE, typeWORD, typeINTEGER);
    AddOpResultType(typeBYTE, typeSHORTINT, typeINTEGER);
    AddOpResultType(typeBYTE, typeSMALLINT, typeINTEGER);

    AddOpResultType(typeWORD, typeDOUBLE, typeDOUBLE);
    AddOpResultType(typeWORD, typeCURRENCY, typeCURRENCY);
    AddOpResultType(typeWORD, typeSINGLE, typeSINGLE);
    AddOpResultType(typeWORD, typeSHORTINT, typeINTEGER);
    AddOpResultType(typeWORD, typeSMALLINT, typeINTEGER);

    AddOpResultType(typeSHORTINT, typeDOUBLE, typeDOUBLE);
    AddOpResultType(typeSHORTINT, typeCURRENCY, typeCURRENCY);
    AddOpResultType(typeSHORTINT, typeSINGLE, typeSINGLE);
    AddOpResultType(typeSHORTINT, typeSMALLINT, typeINTEGER);

    AddOpResultType(typeSMALLINT, typeDOUBLE, typeDOUBLE);
    AddOpResultType(typeSMALLINT, typeCURRENCY, typeCURRENCY);
    AddOpResultType(typeSMALLINT, typeSINGLE, typeSINGLE);

    AddOpResultType(typeDOUBLE, typeSINGLE, typeDOUBLE);
    AddOpResultType(typeDOUBLE, typeCURRENCY, typeCURRENCY);
    AddOpResultType(typeDOUBLE, typeEXTENDED, typeEXTENDED);

    AddOPResultType(typeWIDESTRING, typeSTRING, typeSTRING);

    AddOpResultType(typeSINGLE, typeCURRENCY, typeCURRENCY);

    AddOpResultType(typeCHAR, typeSTRING, typeSTRING);

    FillChar(AssResultTypes, SizeOf(AssResultTypes), 0);

    AddAssResultType(typeINTEGER, typeCARDINAL);
    AddAssResultType(typeINTEGER, typeINT64);
    AddAssResultType(typeINTEGER, typeBYTE);
    AddAssResultType(typeINTEGER, typeWORD);
    AddAssResultType(typeINTEGER, typeSHORTINT);
    AddAssResultType(typeINTEGER, typeSMALLINT);

    AddAssResultType(typeCARDINAL, typeINTEGER);
    AddAssResultType(typeCARDINAL, typeINT64);
    AddAssResultType(typeCARDINAL, typeBYTE);
    AddAssResultType(typeCARDINAL, typeWORD);
    AddAssResultType(typeCARDINAL, typeSHORTINT);
    AddAssResultType(typeCARDINAL, typeSMALLINT);

    AddAssResultType(typeINT64, typeINTEGER);
    AddAssResultType(typeINT64, typeCARDINAL);
    AddAssResultType(typeINT64, typeBYTE);
    AddAssResultType(typeINT64, typeWORD);
    AddAssResultType(typeINT64, typeSHORTINT);
    AddAssResultType(typeINT64, typeSMALLINT);

    AddAssResultType(typeBYTE, typeINTEGER);
    AddAssResultType(typeBYTE, typeINT64);
    AddAssResultType(typeBYTE, typeCARDINAL);
    AddAssResultType(typeBYTE, typeWORD);
    AddAssResultType(typeBYTE, typeSHORTINT);
    AddAssResultType(typeBYTE, typeSMALLINT);

    AddAssResultType(typeWORD, typeINTEGER);
    AddAssResultType(typeWORD, typeINT64);
    AddAssResultType(typeWORD, typeCARDINAL);
    AddAssResultType(typeWORD, typeBYTE);
    AddAssResultType(typeWORD, typeSHORTINT);
    AddAssResultType(typeWORD, typeSMALLINT);

    AddAssResultType(typeSHORTINT, typeINTEGER);
    AddAssResultType(typeSHORTINT, typeINT64);
    AddAssResultType(typeSHORTINT, typeCARDINAL);
    AddAssResultType(typeSHORTINT, typeBYTE);
    AddAssResultType(typeSHORTINT, typeWORD);
    AddAssResultType(typeSHORTINT, typeSMALLINT);

    AddAssResultType(typeSMALLINT, typeINTEGER);
    AddAssResultType(typeSMALLINT, typeINT64);
    AddAssResultType(typeSMALLINT, typeCARDINAL);
    AddAssResultType(typeSMALLINT, typeBYTE);
    AddAssResultType(typeSMALLINT, typeWORD);
    AddAssResultType(typeSMALLINT, typeSHORTINT);

    AddAssResultType(typeDOUBLE, typeINTEGER);
    AddAssResultType(typeDOUBLE, typeCARDINAL);
    AddAssResultType(typeDOUBLE, typeINT64);
    AddAssResultType(typeDOUBLE, typeBYTE);
    AddAssResultType(typeDOUBLE, typeWORD);
    AddAssResultType(typeDOUBLE, typeSHORTINT);
    AddAssResultType(typeDOUBLE, typeEXTENDED);
    AddAssResultType(typeDOUBLE, typeSINGLE);
    AddAssResultType(typeDOUBLE, typeCURRENCY);

    AddAssResultType(typeEXTENDED, typeINTEGER);
    AddAssResultType(typeEXTENDED, typeCARDINAL);
    AddAssResultType(typeEXTENDED, typeINT64);
    AddAssResultType(typeEXTENDED, typeBYTE);
    AddAssResultType(typeEXTENDED, typeWORD);
    AddAssResultType(typeEXTENDED, typeSHORTINT);
    AddAssResultType(typeEXTENDED, typeDOUBLE);
    AddAssResultType(typeEXTENDED, typeSINGLE);
    AddAssResultType(typeEXTENDED, typeCURRENCY);

    AddAssResultType(typeSINGLE, typeINTEGER);
    AddAssResultType(typeSINGLE, typeCARDINAL);
    AddAssResultType(typeSINGLE, typeINT64);
    AddAssResultType(typeSINGLE, typeBYTE);
    AddAssResultType(typeSINGLE, typeWORD);
    AddAssResultType(typeSINGLE, typeSHORTINT);
    AddAssResultType(typeSINGLE, typeDOUBLE);
    AddAssResultType(typeSINGLE, typeEXTENDED);
    AddAssResultType(typeSINGLE, typeCURRENCY);

    AddAssResultType(typeCURRENCY, typeINTEGER);
    AddAssResultType(typeCURRENCY, typeCARDINAL);
    AddAssResultType(typeCURRENCY, typeINT64);
    AddAssResultType(typeCURRENCY, typeBYTE);
    AddAssResultType(typeCURRENCY, typeWORD);
    AddAssResultType(typeCURRENCY, typeSHORTINT);
    AddAssResultType(typeCURRENCY, typeDOUBLE);
    AddAssResultType(typeCURRENCY, typeEXTENDED);
    AddAssResultType(typeCURRENCY, typeSINGLE);

    AddAssResultType(typePOINTER, typeINTEGER);
    AddAssResultType(typePOINTER, typeCLASS);
    AddAssResultType(typePOINTER, typePCHAR);
    AddAssResultType(typePOINTER, typeVARIANT);

    AddAssResultType(typePCHAR, typeSTRING);
    AddAssResultType(typeSHORTSTRING, typeSTRING);
    AddAssResultType(typeWIDESTRING, typeSTRING);
    AddAssResultType(typePWIDECHAR, typeSTRING);

    AddAssResultType(typeCHAR, typeSTRING);
    AddAssResultType(typeSTRING, typeCHAR);

    SupportedPaxTypes := IntegerPaxTypes +
                         BooleanPaxTypes +
                         StringPaxTypes +
                         RealPaxTypes +
                         VariantPaxTypes +
                         [typeSET] +
                         [typeSHORTSTRING];

    OverloadableOperators := TOperatorList.Create;
    with OverloadableOperators do
    begin
      Add('+', OP_PLUS);
      Add('+', OP_UNARY_PLUS);
      Add('-', OP_MINUS);
      Add('-', OP_UNARY_MINUS);
      Add('*', OP_MULT);
      Add('/', OP_DIV);
      Add('%', OP_MOD);
      Add('>>', OP_RIGHT_SHIFT);
      Add('<<', OP_LEFT_SHIFT);
      Add('==', OP_EQ);
      Add('!=', OP_NE);
      Add('<', OP_LT);
      Add('>', OP_GT);
      Add('<=', OP_LE);
      Add('>=', OP_GE);
    end;

    RelationalOperators := TOperatorList.Create;
    with RelationalOperators do
    begin
      Add('==', OP_EQ);
      Add('!=', OP_NE);
      Add('<', OP_LT);
      Add('>', OP_GT);
      Add('<=', OP_LE);
      Add('>=', OP_GE);
      Add('===', OP_ID);
      Add('!==', OP_NI);
    end;
  end;
end;

procedure Finalization_BASE_SYS;
begin
  PAXOperators.Free;
  PAXKinds.Free;
  PAXTypes.Free;
  OverloadableOperators.Free;
  RelationalOperators.Free;

  Finalization_BASE_SYNC;
end;

end.


