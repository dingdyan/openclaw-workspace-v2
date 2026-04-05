{******************************************************************************}
{                                                                              }
{               (W) Component Library                                          }
{               Borland Delphi Interface Section Parser                        }
{               Copyright (C) 2000-2002 Yuriy Shcherbakov                      }
{               All rights reserved.                                           }
{******************************************************************************}

unit uWDelphiParser;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uWStringFunctions, uWParser, Registry;

const
  sVersion : String = '1.0';

const
  sDelphi60DefaultSymbols : array [0..2] of String = ('MSWINDOWS', 'WIN32', 'VER140');
  sDelphi50DefaultSymbols : array [0..1] of String = ('WIN32', 'VER130');
  sDelphi40DefaultSymbols : array [0..1] of String = ('WIN32', 'VER120');
  sDelphi30DefaultSymbols : array [0..1] of String = ('WIN32', 'VER100');
  sDelphi20DefaultSymbols : array [0..1] of String = ('WIN32', 'VER90');
  sDelphi10DefaultSymbols : array [0..1] of String = ('WIN16', 'VER80');

const
  sDelphiKeywords : array [1..90] of String = (
    'abstract','and','array','as','asm','at','automated','begin','case','cdecl',
    'class','const','constructor','default','destructor','dispinterface','div',
    'do','downto','dynamic','else','end','except','exports','file','finalization',
    'finally','for','function','goto','if','implementation','implements','in',
    'inherited','initialization','inline','interface','is','label','library',
    'message','mod','nil','nodefault','not','object','of','on','or','out',
    'overload','override','packed','pascal','private','procedure','program',
    'property','protected','public','published','raise','read','record','register',
    'reintroduce','repeat','resourcestring','safecall','set','shl','shr','stdcall',
    'stored','string','then','threadvar','to','try','type','unit','until','uses',
    'var','virtual','while','with','write','xor');

  sDelphi60Keywords : array [1..2] of String = (
    'platform', 'deprecated');

type
  TCompilerVersion = (verDelphi6, verDelphi5, verDelphi4, verDelphi3, verDelphi2, verDelphi1);
  TWDelphiParserOption = (poAcceptComments, poAcceptCommentLine, poAcceptComment1Block, poAcceptComment2Block);
  TWDelphiParserOptions = set of TWDelphiParserOption;

type
  TVisibilityArea = (vaPrivate, vaProtected, vaPublic, vaPublished);
  TMemberVisibility = set of TVisibilityArea;
  TRoutineDirective = (rdOverride, rdOverload, rdreintroduce, rdVirtual,
                       rdMessageHandler, rdDynamic, rdAbstract,
                       rdRegister, rdPascal, rdCdecl, rdStdcall, rdSafecall);
  TRoutineDirectives = set of TRoutineDirective;
  TStorageSpecifier = (ssDefault, ssNoDefault, ssStored, ssNotStored);
  TStorageSpecifiers = set of TStorageSpecifier;

type
  THintDirective = (hdPlatform, hdDeprecated);
  THintDirectives = set of THintDirective;

type
  { TEntry }
  TEntry = class(TList)
    FWDelphiParser : TComponent;
    Parent : TEntry;
    ID : Integer;
    Name : String;
    Summary, Description : String;
    HintDirectives : THintDirectives;
    constructor Create(aName : String; aParent : TEntry;
      aWDelphiParser : TComponent); virtual;
    destructor Destroy; override;
  end;

  { TSymbolEntry }
  TSymbolEntry = class(TEntry)
    Value : String;
  end;

  { TFileEntry }
  TFileEntry = class(TEntry)
    FFileName : String;
    FFileStream : TFileStream;
    constructor Create(aName : String; aParent : TEntry;
      aWDelphiParser : TComponent); virtual;
    destructor Destroy; override;
  private
    procedure SetFileName(const Value: String); virtual;
  public
    property FileStream : TFileStream read FFileStream write FFileStream;
    property FileName : String read FFileName write SetFileName;
  end;

  { TPackageEntry }
  TPackageEntry = class(TFileEntry)
  end;

  { TUnitEntry }
  TUnitEntry = class(TFileEntry)
    procedure SetFileName(const Value: String); override;
  end;

  { TUsesEntry }
  TUsesEntry = class(TFileEntry)
  end;

  { TPasEntry }
  TPasEntry = class(TEntry)
    Declaration : String;
  end;

  { TProcedureEntry }
  TProcedureEntry = class(TPasEntry)
    RoutineDirectives : TRoutineDirectives;
    MessageHandler : String;
  end;

  { TFunctionEntry }
  TFunctionEntry = class(TProcedureEntry)
    ResultType : String;
  end;

  { TVarEntry }
  TVariableEntry = class(TPasEntry)
    TypeName : String;
    Value : String;
  end;

  { TConstantEntry }
  TConstantEntry = class(TVariableEntry)
  end;

  { TStructuredTypeEntry }
  TStructuredTypeEntry = class(TPasEntry)
    IsPacked : boolean;
  end;

  { TTypeEntry }
  TTypeEntry = class(TStructuredTypeEntry)
    ExistingType : String;
  end;

  { TRecordEntry }
  TRecordEntry = class(TStructuredTypeEntry)
  end;

  { TClassEntry }
  TClassEntry = class(TStructuredTypeEntry)
    Parents : TStringList;
    BriefDeclaration : String;
    IsMetaClass : boolean;
    constructor Create(aName : String; aParent : TEntry;
      aWDelphiParser : TComponent); virtual;
    destructor Destroy; override;
  end;

  { TInterfaceEntry }
  TInterfaceEntry = class(TClassEntry)
    GUID : String;
  end;

  { TDispInterfaceEntry }
  TDispInterfaceEntry = class(TInterfaceEntry)
  end;

  { TClassMemberEntry }
  TClassMemberEntry = class(TPasEntry)
    VisibilityArea : TVisibilityArea;
  end;

  { TClassProcedureEntry }
  TClassProcedureEntry = class(TClassMemberEntry)
    IsClassMethod : boolean;
    RoutineDirectives : TRoutineDirectives;
    MessageHandler : String;
    ParentObjectName : String;
    ParentMethodName : String;
  end;

  { TClassFunctionEntry }
  TClassFunctionEntry = class(TClassProcedureEntry)
    ResultType : String;
  end;

  { TClassVarEntry }
  TClassVarEntry = class(TClassMemberEntry)
    TypeName : String;
  end;

  { TClassPropertyEntry }
  TClassPropertyEntry = class(TClassVarEntry)
    IsEvent : boolean;
    PropertyIndex : String;
    PropertyReadProcName : String;
    PropertyWriteProcName : String;
    PropertyDefValue : String;
    ArrayIsDefaultProperty : boolean;
    StorageSpecifiers : TStorageSpecifiers;
    Implements : String;
  end;

type
  TWDelphiParserOnEntryEvent = procedure (aEntry : TEntry; aAddEntry : boolean) of object;
  TWDelphiParserFileEntryEvent = procedure (aFileName : String) of object;
  TWDelphiParserProgressEvent = procedure (var aStopAnalyze : boolean) of object;

//ab
  TWDelphiParserOnClassEntryEvent = procedure (aEntry : TEntry;
      aAddEntry, IsForward : boolean) of object;
  TWDelphiParserOnInterfaceEntryEvent = procedure (aEntry : TEntry;
      aAddEntry, IsForward : boolean) of object;
  TWDelphiParserOnEnumTypeEvent = procedure (const TypeName: String) of object;

{ TWParserStackItem }

type
  TWParserStackItem = class
    FWParser : TWParser;
    FIndex : Integer;
    FFileName : String;
    constructor Create(aWParser: TWParser; aIndex: Integer; aFileName : String); virtual;
    destructor Destroy; override;
  end;

{ TWParserStack }

type
  TWParserStack = class(TList)
    function GetItem(Index: Integer): TWParserStackItem;
    procedure Push(aWParser : TWParser; aIndex : Integer; aFileName : String);
    procedure Pop(var aWParser : TWParser; var aIndex : Integer; var aFileName : String);
    procedure Clear(var aWParser: TWParser);
    property Items[Index: Integer] : TWParserStackItem read GetItem;
  end;

{ Breakpoint structure to save }
type
  TWParserBreakPoint = record
    Index : Integer;
    Parser : TWParser;
  end;

{ TWDelphiParser }

type
  TWDelphiParser = class(TComponent)
  private
    procedure SetActive(const Value: Boolean);
    function GetVersion: String;
    procedure SetVersion(const Value: String);
    function GetCount: Integer;
    function GetEntry(Index: Integer): TEntry;
    function GetActive: Boolean;
    procedure Initialize;
    procedure LoadDefaultSymbols(aCompilerVersion: TCompilerVersion);
    procedure LoadKeywords(aCompilerVersion: TCompilerVersion; aWParser : TWParser);
    procedure CheckForPlatformDirective(var aIndex: Integer;
      aEntry: TEntry);
    procedure IncludeFile(aFileName: String; var aIndex : Integer);
    procedure InitWParser(aCompilerVersion: TCompilerVersion; aWParser : TWParser);
    function GetToken(Index: Integer): TToken;
    procedure SetCommentDescriptionTags(const Value: TStringList);
    procedure SetCommentSummaryTags(const Value: TStringList);
    procedure SetCommentTags(const Value: TStringList);
    function AcceptComment(var aText: String): boolean;
    function IsCommentTag(var aText: String; aTags: TStringList): boolean;
    procedure AddComment(aText: String; var aComment: String; aAddBefore : boolean);
    procedure SetCommentNewLineTags(const Value: TStringList);
    function IsCommentNewLineTag(var aText: String): boolean;
    { Private declarations }
  protected
    { Protected declarations }
    FFileName : String;
    FWParser : TWParser;              // Points to the current WParser
    FWParserStack : TWParserStack;    // Stack of WParser objects. Used to parse included files.

    FItems : TList;
    FRootEntry : TEntry;
    FStopAnalyze : boolean;
    FErrors : TStringList;
    FCommentTags: TStringList;
    FCommentSummaryTags: TStringList;
    FCommentDescriptionTags: TStringList;
    FCommentNewLineTags: TStringList;

    FCompilerVersion : TCompilerVersion;
    FSearchPath : String;
    FOptions : TWDelphiParserOptions;
    FMemberVisibility : TMemberVisibility;

    FOnPackageEntry : TWDelphiParserOnEntryEvent;
    FOnUnitEntry : TWDelphiParserOnEntryEvent;
    FOnProcedureEntry : TWDelphiParserOnEntryEvent;
    FOnFunctionEntry : TWDelphiParserOnEntryEvent;
    FOnTypeEntry : TWDelphiParserOnEntryEvent;
    FOnRecordEntry : TWDelphiParserOnEntryEvent;
    FOnConstEntry : TWDelphiParserOnEntryEvent;
    FOnVarEntry : TWDelphiParserOnEntryEvent;
    FOnConstantEntry : TWDelphiParserOnEntryEvent;
    FOnUsesEntry : TWDelphiParserOnEntryEvent;
    FOnClassEntry : TWDelphiParserOnClassEntryEvent;
    FOnInterfaceEntry : TWDelphiParserOnInterfaceEntryEvent;
    FOnClassProcedureEntry : TWDelphiParserOnEntryEvent;
    FOnClassFunctionEntry : TWDelphiParserOnEntryEvent;
    FOnClassPropertyEntry : TWDelphiParserOnEntryEvent;
    FOnClassFieldEntry : TWDelphiParserOnEntryEvent;
//    FOnDispinterfaceEntry : TWDelphiParserOnEntryEvent;        //AB
    FOnDispinterfaceEntry : TWDelphiParserOnInterfaceEntryEvent; //AB
    FOnProgress : TWDelphiParserProgressEvent;

    FonEnumType : TWDelphiParserOnEnumTypeEvent; //AB
    FonUsedUnit: TWDelphiParserFileEntryEvent; //AB
    FonEndOfUsesClause: TWDelphiParserProgressEvent; //AB
    FonEndOfClassDef: TWDelphiParserProgressEvent; //AB
    FonEndOfInterfaceDef: TWDelphiParserProgressEvent; //AB

    FAfterUnitEntry : TWDelphiParserFileEntryEvent;
    FAfterPackageEntry : TWDelphiParserFileEntryEvent;
    FBeforeUnitEntry : TWDelphiParserFileEntryEvent;
    FBeforePackageEntry : TWDelphiParserFileEntryEvent;

    FBeforeOpen : TNotifyEvent;
    FBeforeClose : TNotifyEvent;
    FAfterOpen : TNotifyEvent;
    FAfterClose : TNotifyEvent;
    property Token[Index: Integer] : TToken read GetToken; // Array with found token. Translated to FWParser.Token[...]
    procedure AddDefaultDelphiSymbols(aSybmols : array of string);
    function AddSymbolEntry(aName, aValue: String): TSymbolEntry; 
    function FindSymbolEntry(aName: String): TSymbolEntry;
    procedure StepNextToken(var aIndex: Integer);
    procedure ExpectToken(aIndex : Integer; aTokenType : TTokenType; aText : String; aErrorCode : String = '');
    procedure ExpectTokenBooleanValue(aIndex : Integer);
    procedure LookBackwardForDescription(aIndex : Integer;
      var aSummary : String; var aDescription : String);
    procedure LookForwardForDescription(aIndex : Integer;
      var aSummary : String; var aDescription : String);
    procedure WParserTokenReadUnit(Sender: TObject; Token: TToken;
      var AddToList, Stop: Boolean);
    procedure ParseRoutineDirectives(var aIndex: Integer;
      var aRoutineDirectives: TRoutineDirectives; var aMessageHandler : String;
      var aHintDirectives: THintDirectives);
    procedure ParseUsesStatement(aUnitEntry : TEntry; var aIndex : Integer);
    procedure ParseConstStatement(aUnitEntry : TEntry; var aIndex : Integer);
    procedure ParseVarStatement(aUnitEntry : TEntry; var aIndex : Integer);
    procedure ParseTypeStatement(aUnitEntry : TEntry; var aIndex : Integer);
    procedure ParseDispinterface(aDispInterfaceEntry : TDispInterfaceEntry; var aIndex : Integer);
    procedure ParseProcedureEntry(aUnitEntry : TEntry; var aIndex : Integer);
    procedure ParseFunctionEntry(aUnitEntry : TEntry; var aIndex : Integer);
    procedure ParseClassEntry(aClassEntry : TEntry; var aIndex : Integer);
    function LocatePairBracket(aIndex: Integer): Integer;
    function LocateEndOfRecordStatement(aIndex: Integer): Integer;
    function ReadExistingType(var aIndex: Integer) : String;
    function ReadPropertyProcName(var aIndex: Integer): String;
    procedure ParseTStorageSpecifiers(var aIndex: Integer;
                var aStorageSpecifiers: TStorageSpecifiers;
                var aDefaultValue: String);
    function LocateToken(aTokenName: String; aTokenType: TTokenType;
      aStartIndex: integer; aErrorCode: String): Integer;
    procedure ReadProcedureEntry(aProcedureEntry: TProcedureEntry;
      var aIndex: Integer; aIsFunction : boolean);
    { Translated to FWParser }
    function  IsToken(aIndex : Integer; aTokenType : TTokenType; aText : String) : boolean; overload;
    function  IsToken(aToken : TToken; aTokenType : TTokenType; aText : String) : boolean;  overload;
    function  FindToken(aTokenName : String; aTokenType : TTokenType; aStartIndex : integer = 0) : Integer;
    function  GetSourceString(aStartIndex, aEndIndex: Integer) : String; overload;
    function  GetSourceString(aStartBP, aEndBP: TWParserBreakpoint) : String; overload;
    procedure ReadSourceStringIfNotEmpty(var aText : String; aStartBP, aEndBP: TWParserBreakpoint);
    procedure EndOfDeclaration(aEntry : TEntry; aStartBP, aEndBP: TWParserBreakpoint);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function  FindEntry(aName : String; aEntry : TEntry = nil) : TEntry; overload;
    function  FindEntry(aName : String; aEntryClass : TClass; aEntry : TEntry = nil) : TEntry; overload;
    property RootEntry : TEntry read FRootEntry;
    {:$ List of entries. Index should be in range from 0 to Count-1. }
    property Items[Index: Integer]: TEntry read GetEntry;
    {:$ Total count of entries in Items collection. Zero if an error occurred. }
    property Count : Integer read GetCount;
    {:$ List of errors found during parsing process. }
    property Errors : TStringList read FErrors;
  published
    { Published declarations }
    property Active : Boolean read GetActive write SetActive;
    property FileName : String read FFileName write FFileName;
    property Version : String read GetVersion write SetVersion;
    property CompilerVersion : TCompilerVersion read FCompilerVersion write FCompilerVersion;
    property Options : TWDelphiParserOptions read FOptions write FOptions;
    property MemberVisibility : TMemberVisibility read FMemberVisibility write FMemberVisibility;
    property CommentTags: TStringList read FCommentTags write SetCommentTags;
    property CommentSummaryTags: TStringList read FCommentSummaryTags write SetCommentSummaryTags;
    property CommentDescriptionTags: TStringList read FCommentDescriptionTags write SetCommentDescriptionTags;
    property CommentNewLineTags: TStringList read FCommentNewLineTags write SetCommentNewLineTags;

    { Events }
    property OnPackageEntry : TWDelphiParserOnEntryEvent read FOnPackageEntry write FOnPackageEntry;
    property OnUnitEntry : TWDelphiParserOnEntryEvent read FOnUnitEntry write FOnUnitEntry;
    property OnProcedureEntry : TWDelphiParserOnEntryEvent read FOnProcedureEntry write FOnProcedureEntry;
    property OnFunctionEntry : TWDelphiParserOnEntryEvent read FOnFunctionEntry write FOnFunctionEntry;
    property OnTypeEntry : TWDelphiParserOnEntryEvent read FOnTypeEntry write FOnTypeEntry;
    property OnRecordEntry : TWDelphiParserOnEntryEvent read FOnRecordEntry write FOnRecordEntry;
    property OnConstEntry : TWDelphiParserOnEntryEvent read FOnConstEntry write FOnConstEntry;
    property OnVarEntry : TWDelphiParserOnEntryEvent read FOnVarEntry write FOnVarEntry;
    property OnConstantEntry : TWDelphiParserOnEntryEvent read FOnConstantEntry write FOnConstantEntry;
    property OnUsesEntry : TWDelphiParserOnEntryEvent read FOnUsesEntry write FOnUsesEntry;
    property OnClassEntry : TWDelphiParserOnClassEntryEvent read FOnClassEntry write FOnClassEntry;
    property OnInterfaceEntry : TWDelphiParserOnInterfaceEntryEvent read FOnInterfaceEntry write FOnInterfaceEntry;
    property OnClassProcedureEntry : TWDelphiParserOnEntryEvent read FOnClassProcedureEntry write FOnClassProcedureEntry;
    property OnClassFunctionEntry : TWDelphiParserOnEntryEvent read FOnClassFunctionEntry write FOnClassFunctionEntry;
    property OnClassPropertyEntry : TWDelphiParserOnEntryEvent read FOnClassPropertyEntry write FOnClassPropertyEntry;
    property OnClassFieldEntry : TWDelphiParserOnEntryEvent read FOnClassFieldEntry write FOnClassFieldEntry;
//    property OnDispinterfaceEntry : TWDelphiParserOnEntryEvent read FOnDispinterfaceEntry write FOnDispinterfaceEntry; //AB
    property OnDispinterfaceEntry : TWDelphiParserOnInterfaceEntryEvent read FOnDispinterfaceEntry write FOnDispinterfaceEntry; //AB
    property OnProgress : TWDelphiParserProgressEvent read FOnProgress write FOnProgress;

//AB
    property OnEnumType : TWDelphiParserOnEnumTypeEvent read FOnEnumType write FOnEnumType;
    property OnUsedUnit : TWDelphiParserFileEntryEvent read FOnUsedUnit write FOnUsedUnit;
    property OnEndOfUsesClause: TWDelphiParserProgressEvent read FOnEndOfUsesClause write FOnEndOfUsesClause;
    property OnEndOfClassDef: TWDelphiParserProgressEvent read FOnEndOfClassDef write FOnEndOfClassDef;
    property OnEndOfInterfaceDef: TWDelphiParserProgressEvent read FOnEndOfInterfaceDef write FOnEndOfInterfaceDef;

    property AfterUnitEntry : TWDelphiParserFileEntryEvent read FAfterUnitEntry write FAfterUnitEntry;
    property AfterPackageEntry : TWDelphiParserFileEntryEvent read FAfterPackageEntry write FAfterPackageEntry;
    property BeforeUnitEntry : TWDelphiParserFileEntryEvent read FBeforeUnitEntry write FBeforeUnitEntry;
    property BeforePackageEntry : TWDelphiParserFileEntryEvent read FBeforePackageEntry write FBeforePackageEntry;

    property BeforeOpen : TNotifyEvent read FBeforeOpen write FBeforeOpen;
    property BeforeClose : TNotifyEvent read FBeforeClose write FBeforeClose;
    property AfterOpen : TNotifyEvent read FAfterOpen write FAfterOpen;
    property AfterClose : TNotifyEvent read FAfterClose write FAfterClose;

    { Methods }
    procedure Reset;
    function Analyze : boolean;
    procedure ParsePackage;
    procedure ParseUnit(aFileName : String; aPackageEntry : TPackageEntry; aTitle : String; aBriefDescription : String = '');
    procedure SearchForEvents;
  end;

{$R uWDelphiParser.RES}

  {:$ Returns Delphi Source Path and Browse Path taken from the registry for
   :$ particular compiler version. }
  function GetDelphiLibraryPath(aCompilerVersion: TCompilerVersion): String;

  function StrToVisibilityArea(aVisibilityArea : String) : TVisibilityArea; overload;
  function StrToVisibilityArea(aIndex : Integer) : TVisibilityArea; overload;

  function VisibilityAreaToStr(aVisibilityArea : TVisibilityArea) : String;
  function EncodeMemberVisibility(aIsPublished, aIsPublic,
    aIsProtected, aIsPrivate : boolean) : TMemberVisibility;

implementation

function StrToVisibilityArea(aIndex : Integer) : TVisibilityArea;
begin

end;


function GetDelphiLibraryPath(aCompilerVersion : TCompilerVersion) : String;
var
  sVersionNumber, sDelphiPath: String;
  slstValues : TStringList;
  i : Integer;
begin
  Result := '';
  case aCompilerVersion of
    verDelphi6 : sVersionNumber := '6';
    verDelphi5 : sVersionNumber := '5';
    verDelphi4 : sVersionNumber := '4';
    verDelphi3 : sVersionNumber := '3';
    verDelphi2 : sVersionNumber := '2';
    verDelphi1 : sVersionNumber := '1';
  end;
  sDelphiPath := '';
  slstValues := TStringList.Create;
  try
    with TRegistry.Create do
    try
      if OpenKey('Software\Borland\Locales', False) then begin
        GetValueNames(slstValues);
        CloseKey;
      end;
      with slstValues do
        if Count > 0 then
          for i := 0 to Count - 1 do
            if (Pos('Delphi32.exe', Strings[i]) >= 0) and
               (Pos('Delphi' + sVersionNumber, Strings[i]) >= 0)
            then begin
              sDelphiPath := ExtractFilePath(Strings[i]);
              Break;
            end;

      if (sDelphiPath <> '') and
         OpenKey('Software\Borland\Delphi\' + sVersionNumber + '.0\Library', False)
      then begin
        if ValueExists('Browsing Path') then
          Result := Result + ReadString('Browsing Path');
        if ValueExists('Search Path') then begin
          if Result <> '' then Result := Result + ';';
          Result := Result + ReadString('Search Path');
        end;
        CloseKey;
        Result := StringReplace(Result, '$(DELPHI)\', sDelphiPath, [rfReplaceAll]);
      end;
    finally
      Free;
    end;
  finally
    slstValues.Free;
  end;
end;

function WParserBreakpoint(aIndex : Integer; aParser : TWParser) : TWParserBreakpoint;
begin
  Result.Index := aIndex;
  Result.Parser := aParser;
end;

function EncodeMemberVisibility(aIsPublished, aIsPublic,
  aIsProtected, aIsPrivate : boolean) : TMemberVisibility;
begin
  Result := [];
  if aIsPublished then Result := Result + [vaPublished];
  if aIsPublic then Result := Result + [vaPublic];
  if aIsProtected then Result := Result + [vaProtected];
  if aIsPrivate then Result := Result + [vaPrivate];
end;

function StrToVisibilityArea(aVisibilityArea : String) : TVisibilityArea;
begin
  if CompareText(aVisibilityArea, 'Private') = 0 then
    Result := vaPrivate
  else
  if CompareText(aVisibilityArea, 'Protected') = 0 then
    Result := vaProtected
  else
  if CompareText(aVisibilityArea, 'Public') = 0 then
    Result := vaPublic
  else
  if CompareText(aVisibilityArea, 'Published') = 0 then
    Result := vaPublished
  else
    Result := vaPublic;
end;

function VisibilityAreaToStr(aVisibilityArea : TVisibilityArea) : String;
begin
  case aVisibilityArea of
    vaPrivate   : Result := 'Private';
    vaProtected : Result := 'Protected';
    vaPublic    : Result := 'Public';
    vaPublished : Result := 'Published';
  end;
end;

{ TEntry }

constructor TEntry.Create(aName : String; aParent : TEntry;
      aWDelphiParser : TComponent);
begin
  inherited Create;
  Name := FirstCapitalLetter(aName);
  FWDelphiParser := aWDelphiParser;
  Parent := aParent;
  if Assigned(Parent) and (Parent is TEntry) then TEntry(Parent).Add(Self);
  HintDirectives := [];
end;

destructor TEntry.Destroy;
var
  E : TEntry;
begin
  while Count > 0 do begin
    E := Items[0];
    Delete(0);
    if Assigned(E) then E.Free;
  end;
  {Remove itself from the parent list of owned entries}
  if Assigned(Parent) and (Parent is TEntry) then TEntry(Parent).Remove(Self);
  {Remove itself from the parser Items list. }
  if Assigned(FWDelphiParser) then
    with FWDelphiParser as TWDelphiParser do begin
      if Self = FRootEntry then
        FRootEntry := nil;
      FItems.Remove(Self);
    end;
  inherited;
end;

{ TFileEntry }

constructor TFileEntry.Create;
begin
  inherited;
  FFileName := '';
  FFileStream := nil;
end;

destructor TFileEntry.Destroy;
begin
  if Assigned(FFileStream) then FFileStream.Free;
  inherited;
end;

procedure TFileEntry.SetFileName(const Value: String);
begin
  if FFileName <> Value then begin
    if Assigned(FFileStream) then FFileStream.Free;
    FFileName := Value;
    if Value <> '' then
      FFileStream := TFileStream.Create(FFileName, fmOpenRead)
    else
      FFileStream := nil;
  end;
end;

{ TUnitEntry }

procedure TUnitEntry.SetFileName(const Value: String);
var
  S : String;
begin
  S := Value;
  if (ExtractFilePath(S) = '') and Assigned(Parent) and (Parent is TPackageEntry) then
    S := ExtractFilePath((Parent as TPackageEntry).FileName) + S;
  inherited SetFileName(S);
end;

{ TClassEntry }

constructor TClassEntry.Create;
begin
  inherited;
  Parents := TStringList.Create;
end;

destructor TClassEntry.Destroy;
begin
  Parents.Free;
  inherited;
end;

{ TWDelphiParser }

constructor TWDelphiParser.Create(AOwner: TComponent);
var
  i : Integer;
begin
  inherited;
  FFileName := '';
  //FTreeView := nil;
  FRootEntry := nil;
  FStopAnalyze := False;
  //FWParser := TWParser.Create(Self);
  FWParser := nil;
  FErrors := TStringList.Create;
  FItems := TList.Create;
  FCommentTags := TStringList.Create;
  FCommentTags.Add('*');
  FCommentTags.Add(':');
  FCommentSummaryTags := TStringList.Create;
  FCommentSummaryTags.Add('@summary');
  FCommentSummaryTags.Add('$');

  FCommentDescriptionTags := TStringList.Create;
  FCommentDescriptionTags.Add('@desc');
  FCommentDescriptionTags.Add(':');

  FCommentNewLineTags := TStringList.Create;
  FCommentNewLineTags.Add('/n');
  FCommentNewLineTags.Add('<br>');

  FWParserStack := TWParserStack.Create;
  FCompilerVersion := verDelphi6;
  FOptions := [poAcceptComments, poAcceptCommentLine, poAcceptComment1Block, poAcceptComment2Block];
  FMemberVisibility := [vaPrivate, vaProtected, vaPublic, vaPublished];
end;

destructor TWDelphiParser.Destroy;
begin
  FWParserStack.Clear(FWParser);
  FreeAndNil(FWParserStack);
  FreeAndNil(FErrors);
  FreeAndNil(FWParser);
  FreeAndNil(FCommentTags);
  FreeAndNil(FCommentSummaryTags);
  FreeAndNil(FCommentDescriptionTags);
  FreeAndNil(FCommentNewLineTags);
  FreeAndNil(FItems);
  inherited;
end;

procedure TWDelphiParser.InitWParser(aCompilerVersion: TCompilerVersion; aWParser : TWParser);
begin
  with aWParser do begin
    AdditionalChars := '_';
    AllowFigures := True;
    AllowIdentifier := True;
    Comment1Begin := '{';
    Comment1End := '}';
    Comment2Begin := '(*';
    Comment2End := '*)';
    CommentLine := '//';
    SpecialChars := '(),-.:;=[]';
    KeywordsCaseSensitive := False;
    OnTokenRead := WParserTokenReadUnit;
  end;
  LoadKeywords(aCompilerVersion, aWParser);
  FSearchPath := GetDelphiLibraryPath(FCompilerVersion);
end;

procedure TWDelphiParser.LoadKeywords(aCompilerVersion : TCompilerVersion; aWParser : TWParser);
var
  i : Integer;
begin
  with aWParser.Keywords do begin
    Clear;
    for i := Low(sDelphiKeywords) to High(sDelphiKeywords) do
      Add(sDelphiKeywords[i]);
    if aCompilerVersion = verDelphi6 then
      for i := Low(sDelphi60Keywords) to High(sDelphi60Keywords) do
        Add(sDelphi60Keywords[i]);

  end;
end;

procedure TWDelphiParser.LoadDefaultSymbols(aCompilerVersion : TCompilerVersion);
begin
  case CompilerVersion of
    verDelphi1 : AddDefaultDelphiSymbols(sDelphi10DefaultSymbols);
    verDelphi2 : AddDefaultDelphiSymbols(sDelphi20DefaultSymbols);
    verDelphi3 : AddDefaultDelphiSymbols(sDelphi30DefaultSymbols);
    verDelphi4 : AddDefaultDelphiSymbols(sDelphi40DefaultSymbols);
    verDelphi5 : AddDefaultDelphiSymbols(sDelphi50DefaultSymbols);
    verDelphi6 : AddDefaultDelphiSymbols(sDelphi60DefaultSymbols);
  end;
end;

procedure TWDelphiParser.Initialize;
begin
  InitWParser(FCompilerVersion, FWParser);
end;

function TWDelphiParser.GetVersion: String;
begin
  Result := sVersion;
end;

procedure TWDelphiParser.SetActive(const Value: Boolean);
begin
  if Value then begin
    if Assigned(FBeforeOpen) then FBeforeOpen(Self);

    if not Assigned(FRootEntry) then begin
      if (Trim(FileName) <> '') then
        Analyze
      else
        if not (csDesigning in ComponentState) then
          raise Exception.Create('Property ' + Self.ClassName + '.FileName is not assigned.');
    end;
    if Assigned(FAfterOpen) then FAfterOpen(Self);
  end
  else begin
    if Assigned(FBeforeClose) then FBeforeClose(Self);
    if Assigned(FRootEntry) then Reset;
    if Assigned(FAfterClose) then FAfterClose(Self);
  end;
end;

procedure TWDelphiParser.SetVersion(const Value: String);
begin
  {Dummy};
end;

procedure TWDelphiParser.Reset;
begin
  FreeAndNil(FRootEntry);
  FStopAnalyze := False;
  FErrors.Clear;
  FItems.Clear;
end;

function TWDelphiParser.Analyze : boolean;
begin
  Result := False;
  if Trim(FFileName) = '' then Exit;
  try
    try
      FWParser := TWParser.Create(Self);
      Reset;
      Initialize;
      if CompareText(ExtractFileExt(FileName), '.pas') = 0 then
        ParseUnit(FileName, nil, '')
      else
      if CompareText(ExtractFileExt(FileName), '.dpk') = 0 then
        ParsePackage;
      SearchForEvents;
    except
      on E : Exception do begin
        FErrors.Add(E.Message);
        FreeAndNil(FRootEntry);
        FWParserStack.Clear(FWParser);
      end;
    end;
  finally
    Result := FErrors.Count = 0;
    FreeAndNil(FWParser);
  end;
end;

procedure TWDelphiParser.CheckForPlatformDirective(var aIndex : Integer; aEntry : TEntry);
begin
  if not (FCompilerVersion in [verDelphi1, verDelphi2, verDelphi3, verDelphi4, verDelphi5]) then Exit;
  if IsToken(aIndex, ttKeyword, 'platform') then begin
    with aEntry do HintDirectives := HintDirectives + [hdPlatform];
    StepNextToken(aIndex);
  end;
end;

procedure TWDelphiParser.ParsePackage;
var
  FUnitFiles : TStringList;
  i, j  : Integer;
  S, sUnitFileName : String;
  PackageEntry : TPackageEntry;
  bAddEntry, FStopAnalyze : boolean;
begin
  try
    try
      PackageEntry := TPackageEntry.Create('', nil, Self);
      PackageEntry.FileName := Self.FileName;
      if FRootEntry = nil then begin
        FRootEntry := PackageEntry;
        LoadDefaultSymbols(FCompilerVersion);
      end;

      FUnitFiles := TStringList.Create;

      if Assigned(FBeforePackageEntry) then BeforePackageEntry(FileName);
      FFileName := PackageEntry.FileName;
      FWParser.Analyze(PackageEntry.FileStream);
      i := -1;
      StepNextToken(i);
      ExpectToken(i, ttIdentifier, 'package', 'E5260CFD');
      LookBackwardForDescription(i, PackageEntry.Summary, PackageEntry.Description);
      StepNextToken(i);
      PackageEntry.Name := Token[i].Text;
      { package <Name> }
      StepNextToken(i);
      CheckForPlatformDirective(i, PackageEntry);
      ExpectToken(i, ttSpecialChar, ';', '99BDF834');
      StepNextToken(i);
      { package Name; <...>}

      if IsToken(i, ttIdentifier, 'requires') then begin
        i := FindToken(';', ttSpecialChar, i);
        if i < 0 then
          raise Exception.Create('Error 807013F4: Unable to locate the end of REQUIRES section.');
        StepNextToken(i);
      end;

      ExpectToken(i, ttIdentifier, 'contains', 'CF42CC05');

      {i := FindToken('contains', ttIdentifier);
      if i > 0 then}
      {begin}

        LookBackwardForDescription(i, PackageEntry.Summary, PackageEntry.Description);

        bAddEntry := True;
        if Assigned(FOnPackageEntry) then
          OnPackageEntry(PackageEntry, bAddEntry);
        if Assigned(FOnProgress) then
          OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;

        if bAddEntry then begin

          FItems.Add(PackageEntry);

          while Token[i].Token <> ttEof do begin
            if IsToken(i, ttKeyword, 'in') and (Token[i-1].Token = ttIdentifier) and
               (Token[i+1].Token = ttString)
            then begin
              j := FUnitFiles.Add(Token[i-1].Text + '=' + Token[i+1].Text);
              if (i < (FWParser.Count - 3)) and (Token[i+2].Token = ttSpecialChar) and
                 (Token[i+3].Token = ttComment) and (Pos('$', Token[i+3].Text) <> 1)
              then FUnitFiles.Objects[j] := TObject(NewStr(Token[i+3].Text));
            end;
            Inc(i);
          end;

          with FUnitFiles do
            if Count > 0 then begin
              if Assigned(FOnProgress) then
                OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
              for i := 0 to Count - 1 do begin
                if Objects[i] <> nil then begin
                  S := PString(Objects[i])^;
                  DisposeStr(PString(Objects[i]));
                end
                else S := '';
                try
                  sUnitFileName := Values[Names[i]];
                  if Pos(':', sUnitFileName) = 0 then
                    sUnitFileName := ExtractFilePath(PackageEntry.FileName) + sUnitFileName;
                  ParseUnit(sUnitFileName, PackageEntry, Names[i], S);
                except
                  on E : Exception do begin
                    if E is EAbort then Abort;
                    FErrors.Add(E.Message);
                  end;
                end;
                if Assigned(FOnProgress) then
                  OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
                Application.ProcessMessages;
              end;
            end;
        end
        else
          Abort;
    except
      if FRootEntry = PackageEntry then FRootEntry := nil;
      PackageEntry.Free;
      raise;
    end;
  finally
    FUnitFiles.Free;
    if Assigned(FAfterPackageEntry) then AfterPackageEntry(FileName);
  end;
end;

procedure TWDelphiParser.ParseUnit(
  aFileName : String; aPackageEntry : TPackageEntry; aTitle : String;
  aBriefDescription : String = '');
var
  i : Integer;
  UnitEntry : TUnitEntry;
  bAddEntry : boolean;
begin
  //with FWParser do
  try
    try
      UnitEntry := TUnitEntry.Create(aTitle, aPackageEntry, Self);
      UnitEntry.FileName := aFileName;

      if Assigned(FBeforeUnitEntry) then BeforeUnitEntry(aFileName);

      FFileName := UnitEntry.FileName;
      FWParser.Analyze(UnitEntry.FileStream);

      if FRootEntry = nil then begin
        FRootEntry := UnitEntry;
        LoadDefaultSymbols(FCompilerVersion);
      end;

      i := -1;
      StepNextToken(i);
      ExpectToken(i, ttKeyword, 'unit', '196825D1');
      {Read the unit comments above Unit keyword}
      LookBackwardForDescription(i, UnitEntry.Summary, UnitEntry.Description);
      StepNextToken(i);
      if UnitEntry.Name = '' then UnitEntry.Name := Token[i].Text;
      StepNextToken(i);
      CheckForPlatformDirective(i, UnitEntry);

      // ab
      if UpperCase(Token[i].Text) = 'PLATFORM' then
        StepNextToken(i);
  
      ExpectToken(i, ttSpecialChar, ';', 'F13FED4E');
      StepNextToken(i);
      ExpectToken(i, ttKeyword, 'interface', 'EDCF3556');

      {Read the unit comments between Unit and Interface keywords}
      LookBackwardForDescription(i, UnitEntry.Description, UnitEntry.Summary);

      bAddEntry := True;
      if Assigned(FOnUnitEntry) then
        OnUnitEntry(UnitEntry, bAddEntry);
      if Assigned(FOnProgress) then
        OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
      if bAddEntry then begin

        FItems.Add(UnitEntry);

        repeat
          while (i < (FWParser.Count - 2)) do begin
            if IsToken(i, ttKeyword, 'uses') then begin
              StepNextToken(i);
              ParseUsesStatement(UnitEntry, i);
            end
            else
            if IsToken(i, ttKeyword, 'const') then begin
              StepNextToken(i);
              ParseConstStatement(UnitEntry, i);
            end
            else
            if IsToken(i, ttKeyword, 'var') then begin
              StepNextToken(i);
              ParseVarStatement(UnitEntry, i);
            end
            else
            if IsToken(i, ttKeyword, 'type') then begin
              StepNextToken(i);
              ParseTypeStatement(UnitEntry, i);
            end
            else
            if IsToken(i, ttKeyword, 'procedure') then
              ParseProcedureEntry(UnitEntry, i)
            else
            if IsToken(i, ttKeyword, 'function') then
              ParseFunctionEntry(UnitEntry, i)
            else
              StepNextToken(i);
          end;

          { Check if any items in stack. }
          if FWParserStack.Count > 0 then
            FWParserStack.Pop(FWParser, i, FFileName)
          else
            Break;

        until False;

      end
      else begin
        if FRootEntry = UnitEntry then FRootEntry := nil;
        UnitEntry.Free;
      end;
    except
      if FRootEntry = UnitEntry then FRootEntry := nil;
      UnitEntry.Free;
      raise
    end;
  finally
    //FWParser.OnTokenRead := nil;
    if Assigned(FAfterUnitEntry) then AfterUnitEntry(aFileName);
  end;
end;

procedure TWDelphiParser.SearchForEvents;
var
  i, j : Integer;
begin
  if Count > 0 then
    for i := 0 to Count - 1 do
      if Items[i] is TClassPropertyEntry then begin
        TClassPropertyEntry(Items[i]).IsEvent := False;
        for j := 0 to Count - 1 do
          if (Items[j] is TTypeEntry) and
             (CompareText(Items[j].Name, TClassPropertyEntry(Items[i]).TypeName) = 0) and
             ((Pos('function', LowerCase(TTypeEntry(Items[j]).ExistingType)) = 1) or
              (Pos('procedure', LowerCase(TTypeEntry(Items[j]).ExistingType)) = 1))
          then
            TClassPropertyEntry(Items[i]).IsEvent := True;
      end;
end;

function TWDelphiParser.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TWDelphiParser.GetEntry(Index: Integer): TEntry;
begin
  Result := FItems[Index];
end;

procedure TWDelphiParser.AddDefaultDelphiSymbols(
  aSybmols: array of string);
var
  i : Integer;
begin
  for i := Low(aSybmols) to High(aSybmols) do
    AddSymbolEntry(aSybmols[i], '');
end;

function TWDelphiParser.AddSymbolEntry(aName,
  aValue: String): TSymbolEntry;
begin
  Result := FindSymbolEntry(aName);
  if Result = nil then begin
    Result := TSymbolEntry.Create(aName, FRootEntry, Self);
    Result.Value := aValue;
    FItems.Add(Result);
  end;
end;

function TWDelphiParser.FindSymbolEntry(aName: String): TSymbolEntry;
var
  i : Integer;
begin
  Result := nil;
  if Count > 0 then
    for i := 0 to Count - 1 do
      if (Items[i] is TSymbolEntry) then
      if (CompareText(Items[i].Name, aName) = 0) then begin
        Result := TSymbolEntry(Items[i]);
        Break;
      end;
end;

procedure TWDelphiParser.IncludeFile(aFileName : String; var aIndex : Integer);
var
  i : Integer;
  sFileName, sDirList : String;
begin
  sDirList := GetCurrentDir;
  if FSearchPath <> '' then sDirList := ';' + FSearchPath;

  if FItems.Count > 0 then
    for i := 0 to FItems.Count - 1 do
      if TEntry(FItems[i]) is TFileEntry then begin
        if sDirList <> '' then sDirList := sDirList + ';';
        sDirList := sDirList + ExtractFilePath(TFileEntry(FItems[i]).FileName);
      end;
  sFileName := ExpandFileName(FileSearch(aFileName, sDirList));
  if sFileName = '' then begin
    FErrors.Add(Format('- Error DB96D2D1 detected in file %s [%d, %d]',
                       [FFileName, Token[aIndex].Row, Token[aIndex].Column]));
    FErrors.Add('');
    FErrors.Add(Format('Include file %s not found.', [aFileName]));
    FErrors.Add('');
    raise Exception.Create('The rest of the code ignored.');
  end;
  { Save WParser and the current position into stack }
  FWParserStack.Push(FWParser, aIndex + 1, FFileName);
  { Create a new parser and initializate it }
  FWParser := TWParser.Create(Self);
  InitWParser(FCompilerVersion, FWParser);
  FFileName := sFileName;
  FWParser.Analyze(TFileStream.Create(sFileName, fmOpenRead));
  FWParser.OwnSourceStream := True;
  aIndex := -1;
end;

procedure TWDelphiParser.StepNextToken(var aIndex: Integer);
var
  S, N, V : String;
  SymbolEntry : TSymbolEntry;
  bFinish : boolean;

  procedure StepUntilCommentToken(aNames : array of string);
  var
    i, j : Integer;
  begin
    while aIndex < (FWParser.Count - 1) do begin
      if Token[aIndex].Token = ttComment then begin

        for j := Low(aNames) to High(aNames) do
          if Pos(UpperCase(aNames[j]), UpperCase(Token[aIndex].Text)) = 1
          then begin
            aIndex := aIndex + 1;
            { ... aName <...> }
            Exit;
          end;
      end;
      Inc(aIndex);
    end;
    raise Exception.Create('Error: Unable to locate the end of $IFDEF or $IFNDEF directive.');
  end;

  procedure UndefineSymbol(aName : string);
  begin
    SymbolEntry := FindSymbolEntry(aName);
    if Assigned(SymbolEntry) then begin
      FItems.Remove(SymbolEntry);
      SymbolEntry.Free;
    end;
  end;

begin
  repeat
    { Check if end of file }
    Inc(aIndex);

    repeat
      if (Token[aIndex].Token = ttEof) or (aIndex >= (FWParser.Count - 1)) then begin
        if FWParserStack.Count > 0 then
          FWParserStack.Pop(FWParser, aIndex, FFileName);
      end;


      bFinish := True;
      if (Token[aIndex].Token = ttComment) and (Length(Token[aIndex].Text) > 1) and
         (Pos('$', Token[aIndex].Text) = 1)
      then begin
        {Symbol found}
        S := Copy(Token[aIndex].Text, 2, Length(Token[aIndex].Text) - 1);
        N := CutWord(S, ' ');
        V := Trim(S);
        if (UpperCase(N) = 'I') or (UpperCase(N) = 'INCLUDE') then
          IncludeFile(V, aIndex)
        else
        if UpperCase(N) = 'DEFINE' then AddSymbolEntry(V, '') else
        if UpperCase(N) = 'UNDEF' then UndefineSymbol(N) else
        if UpperCase(N) = 'IFDEF' then begin
          if Assigned(FindSymbolEntry(V)) then Break;
          StepUntilCommentToken(['$ELSE', '$ENDIF']);
          bFinish := False;
        end
        else
        if UpperCase(N) = 'IFNDEF' then begin
          if not Assigned(FindSymbolEntry(V)) then Break;
          StepUntilCommentToken(['$ELSE', '$ENDIF']);
          bFinish := False;
        end
        else
        if UpperCase(N) = 'ELSE' then StepUntilCommentToken(['$ENDIF']) else
        if UpperCase(N) = 'IFOPT' then else ;
      end;
    until bFinish;


  until (aIndex >= 0) and
        ( (aIndex >= (FWParser.Count - 1) ) or
          (Token[aIndex].Token <> ttComment) );
end;

procedure TWDelphiParser.ExpectToken(aIndex: Integer;
  aTokenType: TTokenType; aText, aErrorCode: String);
var
  S, sMsg : String;
  i, j, k : Integer;
begin
  if not IsToken(aIndex, aTokenType, aText) then begin
    aErrorCode := '- Error ' + aErrorCode;
    FErrors.Add(Format(aErrorCode + ' detected in file %s [%d, %d]',
                [FFileName, Token[aIndex].Row, Token[aIndex].Column]));
    FErrors.Add('');
    FErrors.Add(Format('Expected ''%s'', but ''%s'' found in the following:',
                [aText, Token[aIndex].Text]));
    S := '';
    i := aIndex;
    j := Token[i].Row;
    while (i > 0) and ((j = Token[i].Row) or (Abs(aIndex - i) < 10)) do begin
      if Token[i].Token <> ttComment then begin
        if S <> '' then S := ' ' + S;
        S := Token[i].Text + S;
      end;
      Dec(i);
    end;
    S := S + '<< Error!';
    FErrors.Add(S);
    FErrors.Add('');
    raise Exception.Create('The rest of the code ignored.');
  end;
end;

procedure TWDelphiParser.ExpectTokenBooleanValue(aIndex: Integer);
var
  S, sMsg : String;
  i, j, k : Integer;
begin
  if not (IsToken(aIndex, ttIdentifier, 'true') or
    IsToken(aIndex, ttIdentifier, 'false'))
  then begin
    (* If the value is not True or False, it can be a boolean constant declared
       somewhere. It's not actually error. So, just ignore it.
    FErrors.Add(Format('- Error 0FC4BCD8 detected in file %s [%d, %d]',
                [FFileName, Token[aIndex].Row, Token[aIndex].Column]));
    FErrors.Add('');
    FErrors.Add(Format('Expected Boolean, but ''%s'' found in the following:',
                [Token[aIndex].Text]));
    S := '';
    i := aIndex;
    j := Token[i].Row;
    while (i > 0) and ((j = Token[i].Row) or (Abs(aIndex - i) < 10)) do begin
      if Token[i].Token <> ttComment then begin
        if S <> '' then S := ' ' + S;
        S := Token[i].Text + S;
      end;
      Dec(i);
    end;
    S := S + '<< Error!';
    FErrors.Add(S);
    FErrors.Add('');
    raise Exception.Create('The rest of the code ignored.'); *)
  end;
end;

function TWDelphiParser.IsCommentTag(var aText : String; aTags : TStringList) : boolean;
var
  i : Integer;
begin
  Result := False;
  with aTags do
    if Count > 0 then
      for i := 0 to Count - 1 do
        if (Trim(Strings[i]) <> '') and
           { If aText begings from one of CommentTags words, accept it }
           (Pos(UpperCase(Strings[i]), UpperCase(aText)) = 1)
        then begin
          Result := True;
          aText := StringReplace(aText, Strings[i], '', []);
          Break;
        end;
end;

function TWDelphiParser.AcceptComment(var aText : String) : boolean;
var
  i : Integer;
begin
  { If CommentTag is empty, accept comment }
  Result := Trim(CommentTags.Text) = '';
  if not Result then
    with CommentTags do
      if Count > 0 then
        for i := 0 to Count - 1 do
          if (Trim(Strings[i]) <> '') and
             { If aText begings from one of CommentTags words, accept it }
             (Pos(UpperCase(Strings[i]), UpperCase(aText)) = 1)
          then begin
            Result := True;
            aText := StringReplace(aText, Strings[i], '', []);
            Break;
          end;
end;

function TWDelphiParser.IsCommentNewLineTag(var aText : String) : boolean;
var
  i : Integer;
begin
  Result := False;
  with CommentNewLineTags do
    if Count > 0 then
      for i := 0 to Count - 1 do
        if (Trim(Strings[i]) <> '') and
           { If aText ends in one of CommentTags words, accept it }
           (CompareText(Strings[i],
                        Copy(aText, Length(aText) - Length(Strings[i]) + 1,
                             Length(Strings[i]))) = 0)
        then begin
          Result := True;
          aText := StringReplace(aText, Strings[i], '', []);
          Break;
        end;
end;

procedure TWDelphiParser.AddComment(aText : String; var aComment : String; aAddBefore : boolean);
var
  i : Integer;
begin
  with TStringList.Create do
  try
    Text := aComment;
    //if Count = 0 then Add('');
    if aAddBefore then begin
      if (Count > 0) and (Strings[Count - 1] <> '') then
        Strings[0] := ' ' + Strings[0];
      if Trim(aText) <> '' then begin
        if Count > 0 then
          Strings[0] := Trim(aText) + Strings[0]
        else
          Add(Trim(aText));
      end
      else
        Insert(0, '');
    end
    else begin
      if (Count > 0) and (Strings[Count - 1] <> '') then
        Strings[Count - 1] := Strings[Count - 1] + ' ';
      if Trim(aText) <> '' then begin
        if Count > 0 then
          Strings[Count - 1] := Strings[Count - 1] + Trim(aText)
        else
          Add(Trim(aText));
      end
      else
        Add('');
    end;
    { Replace CommentNewLineTag if any }
    if CommentNewLineTags.Count > 0 then
      for i := 0 to CommentNewLineTags.Count - 1 do
        if Trim(CommentNewLineTags.Strings[i]) <> '' then
          Text := StringReplace(Text, CommentNewLineTags.Strings[i], #13, [rfReplaceAll]);
    if Count > 0 then
      for i := 0 to Count - 1 do
        Strings[i] := Trim(Strings[i]);
  finally
    aComment := Text;
    Free;
  end;
end;

procedure TWDelphiParser.LookBackwardForDescription(aIndex : Integer;
      var aSummary : String; var aDescription : String);
var
  CurrentSubType : TTokenSubType;
begin
  if not (poAcceptComments in Options) then Exit;
  if (aIndex <= 0) or (aIndex > FWParser.Count) then Exit;
  CurrentSubType := tsNone;
  Dec(aIndex);
  while (aIndex >= 0) and (Token[aIndex].Token = ttComment) do begin
    if (aIndex > 0) and (Token[aIndex - 1].Token <> ttComment) and
       (Token[aIndex].Row = Token[aIndex - 1].Row)
    then Break;
    if (Pos('$', Token[aIndex].Text) <> 1) and
       (((Token[aIndex].SubType = tsCommentLine) and (poAcceptCommentLine in Options)) or
        ((Token[aIndex].SubType = tsComment1Block) and (poAcceptComment1Block in Options)) or
        ((Token[aIndex].SubType = tsComment2Block) and (poAcceptComment2Block in Options))) and
       ((CurrentSubType = tsNone) or (CurrentSubType = Token[aIndex].SubType))
    then begin
      CurrentSubType := Token[aIndex].SubType;
      if AcceptComment(Token[aIndex].Text) then begin
        if IsCommentTag(Token[aIndex].Text, CommentSummaryTags) then
          AddComment(Token[aIndex].Text, aSummary, True)
        else
        if IsCommentTag(Token[aIndex].Text, CommentDescriptionTags) then
          AddComment(Token[aIndex].Text, aDescription, True)
        else
          AddComment(Token[aIndex].Text, aDescription, True);
      end;
    end;
    Dec(aIndex);
  end;
end;

procedure TWDelphiParser.LookForwardForDescription(aIndex: Integer;
  var aSummary : String; var aDescription: String);
var
  iRow, iPrevCommentCol : Integer;
begin
  if not (poAcceptComments in Options) or (aIndex < 0) or
    (aIndex >= (FWParser.Count - 1))
  then Exit;

  iPrevCommentCol := -1;
  iRow := Token[aIndex].Row;
  Inc(aIndex);
  while (aIndex < (FWParser.Count - 1)) and (Token[aIndex].Token = ttComment) do begin
    if (Pos('$', Token[aIndex].Text) <> 1) and
       ((Token[aIndex].Row = iRow) or (Token[aIndex].Column = iPrevCommentCol)) and
       (((Token[aIndex].SubType = tsCommentLine) and (poAcceptCommentLine in Options)) or
        ((Token[aIndex].SubType = tsComment1Block) and (poAcceptComment1Block in Options)) or
        ((Token[aIndex].SubType = tsComment2Block) and (poAcceptComment2Block in Options)))
    then begin
      if AcceptComment(Token[aIndex].Text) then begin
        if IsCommentTag(Token[aIndex].Text, CommentSummaryTags) then
          AddComment(Token[aIndex].Text, aSummary, False)
        else
        if IsCommentTag(Token[aIndex].Text, CommentDescriptionTags) then
          AddComment(Token[aIndex].Text, aDescription, False)
        else
          AddComment(Token[aIndex].Text, aSummary, False);
      end;
      iPrevCommentCol := Token[aIndex].Column;
    end else Break;
    Inc(aIndex);
  end;
end;

procedure TWDelphiParser.WParserTokenReadUnit(Sender: TObject;
  Token: TToken; var AddToList, Stop: Boolean);
begin
  AddToList := True;
  Stop := IsToken(Token, ttKeyword, 'implementation');
  Application.ProcessMessages;
end;

procedure TWDelphiParser.ParseClassEntry(aClassEntry: TEntry;
  var aIndex: Integer);
var
  i : Integer;
  VisibilityArea : TVisibilityArea;
  slName : TStringList;
  sType, S1, S2 : String;
  iDeclarationBeginIndex  : Integer;
  ClassFunctionEntry : TClassFunctionEntry;
  ClassProcedureEntry : TClassProcedureEntry;
  ClassPropertyEntry : TClassPropertyEntry;
  ClassVarEntry : TClassVarEntry;
  bAddEntry, bIsClassMethod : boolean;
  bpDeclarationBegin : TWParserBreakPoint;
begin
  VisibilityArea := vaPublic;
  {type NewType = class(ParenType) <...>}
  try
    slName := TStringList.Create;
    bIsClassMethod := False;
    while not IsToken(aIndex, ttKeyword, 'end') do begin
      slName.Clear;
      if IsToken(aIndex, ttKeyword, 'protected') then begin
       {type NewType = class(ParenType) <protected>}
        VisibilityArea := vaProtected;
        StepNextToken(aIndex);
      end
      else
      if IsToken(aIndex, ttKeyword, 'private') then begin
       {type NewType = class(ParenType) <private>}
        VisibilityArea := vaPrivate;
        StepNextToken(aIndex);
      end
      else
      if IsToken(aIndex, ttKeyword, 'public') then begin
       {type NewType = class(ParenType) <public>}
        VisibilityArea := vaPublic;
        StepNextToken(aIndex);
      end
      else
      if IsToken(aIndex, ttKeyword, 'published') then begin
       {type NewType = class(ParenType) <published>}
        VisibilityArea := vaPublished;
        StepNextToken(aIndex);
      end
      else
      begin
        if IsToken(aIndex, ttKeyword, 'constructor') or
           IsToken(aIndex, ttKeyword, 'destructor') or
           IsToken(aIndex, ttKeyword, 'procedure') or
           IsToken(aIndex, ttKeyword, 'function') or
           IsToken(aIndex, ttKeyword, 'class')
        then begin
          if IsToken(aIndex, ttKeyword, 'class') then begin
            bIsClassMethod := True;
            StepNextToken(aIndex);
          end;
          {type NewType = class(ParenType) protected/private/public/published <...>}
          if IsToken(aIndex, ttKeyword, 'constructor') or
             IsToken(aIndex, ttKeyword, 'destructor') or
             IsToken(aIndex, ttKeyword, 'procedure')
          then
          try
            ClassProcedureEntry := TClassProcedureEntry.Create('', aClassEntry, Self);
            ClassProcedureEntry.VisibilityArea := VisibilityArea;
            ClassProcedureEntry.IsClassMethod := bIsClassMethod;

            iDeclarationBeginIndex := aIndex;
            with bpDeclarationBegin do begin Index := aIndex; Parser := FWParser; end;
            StepNextToken(aIndex);
            {type NewType = class(ParenType) [protected/private/public/published]
                  constructor/destructor/procedure <...>}
            ClassProcedureEntry.Name := FirstCapitalLetter(Token[aIndex].Text);
            StepNextToken(aIndex);

            if IsToken(aIndex, ttSpecialChar, '.') then begin
              StepNextToken(aIndex);
              ClassProcedureEntry.ParentObjectName := ClassProcedureEntry.Name;
              ClassProcedureEntry.ParentMethodName := FirstCapitalLetter(Token[aIndex].Text);
              StepNextToken(aIndex);
              ExpectToken(aIndex, ttSpecialChar, '=', '1F9F6110');
              StepNextToken(aIndex);
              ClassProcedureEntry.Name := FirstCapitalLetter(Token[aIndex].Text);
              StepNextToken(aIndex);
              {type NewType = class(ParenType) [protected/private/public/published]
                  procedure ParentObjectName.ParentMethodName = Name <...>}
            end;

            if IsToken(aIndex, ttSpecialChar, '(') then begin
              {type NewType = class(ParenType) [protected/private/public/published]
                    constructor/destructor/procedure Name <(>}
              aIndex := LocatePairBracket(aIndex);
              {type NewType = class(ParenType) [protected/private/public/published]
                    constructor/destructor/procedure Name (<)>}
              StepNextToken(aIndex);
            end;
            CheckForPlatformDirective(aIndex, ClassProcedureEntry);
            ExpectToken(aIndex, ttSpecialChar, ';', 'BA32ECDE');
            {type NewType = class(ParenType) [protected/private/public/published]
                  constructor/destructor/procedure Name ()<;>}

            ClassProcedureEntry.RoutineDirectives := [];
            ParseRoutineDirectives(aIndex, ClassProcedureEntry.RoutineDirectives,
                                   ClassProcedureEntry.MessageHandler,
                                   ClassProcedureEntry.HintDirectives);

            EndOfDeclaration(ClassProcedureEntry, bpDeclarationBegin,
                           WParserBreakpoint(aIndex, FWParser));
            {ClassProcedureEntry.Declaration := GetSourceString(iDeclarationBeginIndex, aIndex);
            LookBackwardForDescription(iDeclarationBeginIndex,
              ClassProcedureEntry.Summary, ClassProcedureEntry.Description);
            LookForwardForDescription(aIndex, ClassProcedureEntry.Summary,
              ClassProcedureEntry.Description);}

            StepNextToken(aIndex);

            //bAddEntry := True;
            bAddEntry := (VisibilityArea in FMemberVisibility);
            if bAddEntry then begin
              if Assigned(FOnClassProcedureEntry) then
                OnClassProcedureEntry(ClassProcedureEntry, bAddEntry);
              if Assigned(FOnProgress) then
                OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
            end;
            if not bAddEntry then ClassProcedureEntry.Free else FItems.Add(ClassProcedureEntry);
          except
            ClassProcedureEntry.Free;
            raise
          end
          else
          if IsToken(aIndex, ttKeyword, 'function') then
          try
            ClassFunctionEntry := TClassFunctionEntry.Create('', aClassEntry, Self);
            ClassFunctionEntry.VisibilityArea := VisibilityArea;
            ClassFunctionEntry.IsClassMethod := bIsClassMethod;

            iDeclarationBeginIndex := aIndex; { todo }
            with bpDeclarationBegin do begin Index := aIndex; Parser := FWParser; end;

            StepNextToken(aIndex);
            {type NewType = class(ParenType) [protected/private/public/published]
                  function <...>}
            ClassFunctionEntry.Name := FirstCapitalLetter(Token[aIndex].Text);
            StepNextToken(aIndex);

            if IsToken(aIndex, ttSpecialChar, '.') then begin
              StepNextToken(aIndex);
              ClassProcedureEntry.ParentObjectName := ClassProcedureEntry.Name;
              ClassProcedureEntry.ParentMethodName := FirstCapitalLetter(Token[aIndex].Text);
              StepNextToken(aIndex);
              ExpectToken(aIndex, ttSpecialChar, '=', '1F9F6110');
              StepNextToken(aIndex);
              ClassProcedureEntry.Name := FirstCapitalLetter(Token[aIndex].Text);
              StepNextToken(aIndex);
              {type NewType = class(ParenType) [protected/private/public/published]
                  function ParentObjectName.ParentMethodName = Name <...>}
            end
            else begin
              if IsToken(aIndex, ttSpecialChar, '(') then begin
                {type NewType = class(ParenType) [protected/private/public/published]
                      function Name <(>}
                aIndex := LocatePairBracket(aIndex);
                {type NewType = class(ParenType) [protected/private/public/published]
                      function Name (...<)>}
                StepNextToken(aIndex);
              end;
              ExpectToken(aIndex, ttSpecialChar, ':', 'C6708B9E');
              StepNextToken(aIndex);
              ClassFunctionEntry.ResultType := Token[aIndex].Text;
              StepNextToken(aIndex);
            end;

            CheckForPlatformDirective(aIndex, ClassFunctionEntry);
            ExpectToken(aIndex, ttSpecialChar, ';', '84619BF2');

            ClassFunctionEntry.RoutineDirectives := [];
            ParseRoutineDirectives(aIndex, ClassFunctionEntry.RoutineDirectives,
                                   ClassFunctionEntry.MessageHandler,
                                   ClassFunctionEntry.HintDirectives);

            EndOfDeclaration(ClassFunctionEntry, bpDeclarationBegin,
                           WParserBreakpoint(aIndex, FWParser));
            {ClassFunctionEntry.Declaration := GetSourceString(iDeclarationBeginIndex, aIndex);
            LookBackwardForDescription(iDeclarationBeginIndex,
              ClassFunctionEntry.Summary, ClassFunctionEntry.Description);
            LookForwardForDescription(aIndex, ClassFunctionEntry.Summary,
              ClassFunctionEntry.Description);}
            StepNextToken(aIndex);
            //bAddEntry := True;
            bAddEntry := (VisibilityArea in FMemberVisibility);
            if bAddEntry then begin
              if Assigned(FOnClassFunctionEntry) then
                OnClassFunctionEntry(ClassFunctionEntry, bAddEntry);
              if Assigned(FOnProgress) then
                OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
            end;
            if not bAddEntry then ClassFunctionEntry.Free else FItems.Add(ClassFunctionEntry);
          except
            ClassFunctionEntry.Free;
            raise
          end;
        end
        else
        if IsToken(aIndex, ttKeyword, 'property') then
        try
          ClassPropertyEntry := TClassPropertyEntry.Create('', aClassEntry, Self);
          ClassPropertyEntry.VisibilityArea := VisibilityArea;
          ClassPropertyEntry.StorageSpecifiers := [];

          ClassPropertyEntry.ArrayIsDefaultProperty := False;
          iDeclarationBeginIndex := aIndex;
          with bpDeclarationBegin do begin Index := aIndex; Parser := FWParser; end;

          StepNextToken(aIndex);
          ClassPropertyEntry.Name := FirstCapitalLetter(Token[aIndex].Text);

          StepNextToken(aIndex);
          {type NewType = class(ParenType) [protected/private/public/published]
                property Name <...>}
          if IsToken(aIndex, ttSpecialChar, '[') then begin
            {type NewType = class(ParenType) [protected/private/public/published]
                  property Name <[>}
            aIndex := FindToken(']', ttSpecialChar, aIndex);
            if aIndex < 0 then {Error!!!};
            StepNextToken(aIndex);
            {type NewType = class(ParenType) [protected/private/public/published]
                  property Name [...] <...>}
          end;
          if IsToken(aIndex, ttSpecialChar, ';') then begin
            EndOfDeclaration(ClassPropertyEntry, bpDeclarationBegin,
                           WParserBreakpoint(aIndex, FWParser));
            StepNextToken(aIndex);
            {type NewType = class(ParenType) [protected/private/public/published]
                  property Name [...]; <...>}
          end
          else begin

            if IsToken(aIndex, ttSpecialChar, ':') then begin
              StepNextToken(aIndex);
              ClassPropertyEntry.TypeName := FirstCapitalLetter(Token[aIndex].Text);
              StepNextToken(aIndex);
            end;

            {type NewType = class(ParenType) [protected/private/public/published]
                  property Name [...] : PropertyType <...>}

            while IsToken(aIndex, ttKeyword, 'read') or IsToken(aIndex, ttKeyword, 'write') or
                  IsToken(aIndex, ttIdentifier, 'index') or IsToken(aIndex, ttKeyword, 'implements')
            do begin
              if IsToken(aIndex, ttKeyword, 'read') then begin
                StepNextToken(aIndex);
                ClassPropertyEntry.PropertyReadProcName := FirstCapitalLetter(ReadPropertyProcName(aIndex));
                {type NewType = class(ParenType) [protected/private/public/published]
                      property Name [...] : PropertyType read ProcName <...>}
              end
              else
              if IsToken(aIndex, ttKeyword, 'write') then begin
                StepNextToken(aIndex);
                ClassPropertyEntry.PropertyWriteProcName := FirstCapitalLetter(ReadPropertyProcName(aIndex));
                {type NewType = class(ParenType) [protected/private/public/published]
                      property Name [...] : PropertyType write ProcName <...>}
              end
              else
              if IsToken(aIndex, ttIdentifier, 'index') then begin
                StepNextToken(aIndex);
                ClassPropertyEntry.PropertyIndex := Token[aIndex].Text;
                StepNextToken(aIndex);
                i := FindToken('read', ttKeyword, aIndex);
                if i < 0 then
                  i := FindToken('write', ttKeyword, aIndex);
                if i < 0 then
                  raise Exception.Create('Error DC1DD985: Unable to locate the end of Index declaration.');

                ClassPropertyEntry.PropertyIndex := GetSourceString(aIndex, i - 1);
                aIndex := i;
                {type NewType = class(ParenType) [protected/private/public/published]
                      property Name [...] : PropertyType Index IndexValue <...>}
              end
              else
              if IsToken(aIndex, ttKeyword, 'implements') then begin
                repeat
                  StepNextToken(aIndex);
                  ClassPropertyEntry.Implements := Token[aIndex].Text;
                  StepNextToken(aIndex);
                until not IsToken(aIndex, ttSpecialChar, ',');
              end
            end;
            ParseTStorageSpecifiers(aIndex, ClassPropertyEntry.StorageSpecifiers, ClassPropertyEntry.PropertyDefValue);

            CheckForPlatformDirective(aIndex, ClassPropertyEntry);
            ExpectToken(aIndex, ttSpecialChar, ';', 'CE9A35AD');
            EndOfDeclaration(ClassPropertyEntry, bpDeclarationBegin,
                           WParserBreakpoint(aIndex, FWParser));
            StepNextToken(aIndex);
            ClassPropertyEntry.ArrayIsDefaultProperty := IsToken(aIndex, ttKeyword, 'default');
            if ClassPropertyEntry.ArrayIsDefaultProperty then begin
              StepNextToken(aIndex);
              CheckForPlatformDirective(aIndex, ClassPropertyEntry);
              ExpectToken(aIndex, ttSpecialChar, ';', '194B92DE');
              EndOfDeclaration(ClassPropertyEntry, bpDeclarationBegin,
                             WParserBreakpoint(aIndex, FWParser));
              StepNextToken(aIndex);
            end;
          end;
          //ClassPropertyEntry.Declaration := GetSourceString(iDeclarationBeginIndex, aIndex - 1);

          { todo }
          {LookBackwardForDescription(iDeclarationBeginIndex,
            ClassPropertyEntry.Summary, ClassPropertyEntry.Description);
          LookForwardForDescription(aIndex - 1, ClassPropertyEntry.Summary,
            ClassPropertyEntry.Description);}

          if ClassPropertyEntry.TypeName = ''
          then {Unknow type! Check the parent class property type.};

          bAddEntry := (VisibilityArea in FMemberVisibility);
          if bAddEntry then begin
            if Assigned(FOnClassPropertyEntry) then
              OnClassPropertyEntry(ClassPropertyEntry, bAddEntry);
            if Assigned(FOnProgress) then
              OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
          end;

          if not bAddEntry then ClassPropertyEntry.Free else FItems.Add(ClassPropertyEntry);
        except
          ClassPropertyEntry.Free;
          raise
        end
        else
        try
          iDeclarationBeginIndex := aIndex;
          with bpDeclarationBegin do begin Index := aIndex; Parser := FWParser; end;
          {type NewType = class(ParenType) [protected/private/public/published] <Identifier>}
          repeat
            slName.Add(Token[aIndex].Text);
            StepNextToken(aIndex);
            if IsToken(aIndex, ttSpecialChar, ',') then begin
              StepNextToken(aIndex);
              Continue;
            end else Break;
          until False;
          ExpectToken(aIndex, ttSpecialChar, ':', '4F28AA44');
          StepNextToken(aIndex);
          {type NewType = class(ParenType) [protected/private/public/published] Identifier : <...>}

          i := FindToken(';', ttSpecialChar, aIndex);
          if i < 0 then {Error!!!};
          sType := GetSourceString(aIndex, i);
          if Length(sType) > 0 then SetLength(sType, Length(sType) - 1);
          aIndex := i;
          S1 := '';
          S2 := '';
          LookBackwardForDescription(iDeclarationBeginIndex, S1, S2);
          LookForwardForDescription(aIndex, S1, S2);
          StepNextToken(aIndex);
          for i := 0 to slName.Count - 1 do begin
            ClassVarEntry := TClassVarEntry.Create(slName[i], aClassEntry, Self);
            ClassVarEntry.Declaration := slName[i] + ' : ' + sType + ';';
            ClassVarEntry.VisibilityArea := VisibilityArea;
            ClassVarEntry.Summary := S1;
            ClassVarEntry.Description := S2;
            ClassVarEntry.TypeName := FirstCapitalLetter(sType);
            //bAddEntry := True;
            bAddEntry := (VisibilityArea in FMemberVisibility);
            if bAddEntry then begin
              if Assigned(FOnClassFieldEntry) then
                OnClassFieldEntry(ClassVarEntry, bAddEntry);
              if Assigned(FOnProgress) then
                OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
            end;
            if not bAddEntry then ClassVarEntry.Free else FItems.Add(ClassVarEntry);
          end;
        except
          ClassVarEntry.Free;
          raise
        end;
      end;
    end;
    StepNextToken(aIndex);
    CheckForPlatformDirective(aIndex, ClassVarEntry);

    if CompareText(Token[aIndex].Text, 'deprecated') = 0 then //AB
      StepNextToken(aIndex);
    if CompareText(Token[aIndex].Text, 'platform') = 0 then //AB
      StepNextToken(aIndex);

    ExpectToken(aIndex, ttSpecialChar, ';', 'D0682364');
    // StepNextToken(aIndex);
  finally
    slName.Free;
  end;
end;

procedure TWDelphiParser.ParseConstStatement(aUnitEntry: TEntry;
  var aIndex: Integer);
var
  iDeclarationStartIndex, i : Integer;
  ConstantEntry : TConstantEntry;
  bAddEntry : boolean;
begin
  {const ...}
  try
    {const <Name> = ...}
    while Token[aIndex].Token = ttIdentifier do begin
      try
        iDeclarationStartIndex := aIndex;
        ConstantEntry := TConstantEntry.Create('', aUnitEntry, Self);
        ConstantEntry.Name := FirstCapitalLetter(Token[aIndex].Text);
        StepNextToken(aIndex);
        {const Name <???> ...}
        if IsToken(aIndex, ttSpecialChar, ':') then begin
          StepNextToken(aIndex);
          ConstantEntry.TypeName := ReadExistingType(aIndex);
        end;
        {const Name <=> ...}
        ExpectToken(aIndex, ttSpecialChar, '=', '45732CC0');
        StepNextToken(aIndex);
        {const Name = <...>}
        if IsToken(aIndex, ttSpecialChar, '(') then begin
          {const Name = <(>}
          i := LocatePairBracket(aIndex);
          StepNextToken(i);
          i := LocateToken(';', ttSpecialChar, i, '92F6176A');
        end
        else
          i := LocateToken(';', ttSpecialChar, aIndex, 'B4F8DD31');

        ConstantEntry.Value := GetSourceString(aIndex, i);
        if Length(ConstantEntry.Value) > 1 then SetLength(ConstantEntry.Value, Length(ConstantEntry.Value) - 1);
        aIndex := i;

        CheckForPlatformDirective(aIndex, ConstantEntry);
        ExpectToken(aIndex, ttSpecialChar, ';', 'A2CFFA7B');

        { todo }
        ConstantEntry.Declaration := GetSourceString(iDeclarationStartIndex, aIndex);
        LookBackwardForDescription(iDeclarationStartIndex, ConstantEntry.Summary,
          ConstantEntry.Description);
        LookForwardForDescription(aIndex, ConstantEntry.Summary,
          ConstantEntry.Description);

        { Add Entry }
        bAddEntry := True;
        if Assigned(FOnConstEntry) then
          OnConstEntry(ConstantEntry, bAddEntry);
        if Assigned(FOnProgress) then
          OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
        if not bAddEntry then ConstantEntry.Free else FItems.Add(ConstantEntry);

        StepNextToken(aIndex);
        if IsToken(aIndex, ttKeyword, 'type') or IsToken(aIndex, ttKeyword, 'var') or
           IsToken(aIndex, ttKeyword, 'procedure') or IsToken(aIndex, ttKeyword, 'function') or
           IsToken(aIndex, ttKeyword, 'record')
        then Break;
      except
        ConstantEntry.Free;
        raise
      end;
    end;
  except
    raise
  end;
end;

procedure TWDelphiParser.ParseDispinterface(
  aDispInterfaceEntry: TDispInterfaceEntry; var aIndex: Integer);
var
  i : Integer;
begin
  {type NewType = dispinterface <...>}
  try
    if IsToken(aIndex, ttSpecialChar, '[') then begin
      i := aIndex;
      aIndex := LocateToken(']', ttSpecialChar, aIndex, '340090DA');
      aDispInterfaceEntry.GUID := GetSourceString(i, aIndex);
      StepNextToken(aIndex);
      {type NewType = dispinterface [GUID] <...>}
    end;
    aIndex := LocateEndOfRecordStatement(aIndex);
    StepNextToken(aIndex);
    CheckForPlatformDirective(aIndex, aDispInterfaceEntry);
    ExpectToken(aIndex, ttSpecialChar, ';', 'B3AA7FF6');
    StepNextToken(aIndex);
  finally
  end;
end;

procedure TWDelphiParser.ParseFunctionEntry(aUnitEntry: TEntry;
  var aIndex: Integer);
var
  iDeclarationStartIndex, iDeclarationEndIndex : Integer;
  FunctionEntry : TFunctionEntry;
  bAddEntry : Boolean;
begin
  try
    FunctionEntry := TFunctionEntry.Create('', aUnitEntry, Self);
    ReadProcedureEntry(FunctionEntry, aIndex, True);
    bAddEntry := True;
    if Assigned(FOnFunctionEntry) then
      OnFunctionEntry(FunctionEntry, bAddEntry);
    if Assigned(FOnProgress) then
      OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
    if not bAddEntry then FunctionEntry.Free else FItems.Add(FunctionEntry);
  except
    FunctionEntry.Free;
    raise
  end;
end;

procedure TWDelphiParser.ParseProcedureEntry(aUnitEntry: TEntry;
  var aIndex: Integer);
var
  ProcedureEntry : TProcedureEntry;
  bAddEntry : boolean;
begin
  try
    ProcedureEntry := TProcedureEntry.Create('', aUnitEntry, Self);

    ReadProcedureEntry(ProcedureEntry, aIndex, False);
    bAddEntry := True;
    if Assigned(FOnProcedureEntry) then
      OnProcedureEntry(ProcedureEntry, bAddEntry);
    if Assigned(FOnProgress) then
      OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
    if not bAddEntry then ProcedureEntry.Free else FItems.Add(ProcedureEntry);
  except
    ProcedureEntry.Free;
    raise
  end;
end;

procedure TWDelphiParser.ParseRoutineDirectives(var aIndex: Integer;
  var aRoutineDirectives: TRoutineDirectives; var aMessageHandler: String;
  var aHintDirectives: THintDirectives);
var
  iTempIndex : Integer;

  procedure ServeDirective(aRoutineDirective : TRoutineDirective);
  begin
    Include(aRoutineDirectives, aRoutineDirective);
    StepNextToken(iTempIndex);
    if aRoutineDirective = rdMessageHandler then begin
      aMessageHandler := Token[iTempIndex].Text;
      StepNextToken(iTempIndex);
    end;
    ExpectToken(iTempIndex, ttSpecialChar, ';', 'D711C805');
    aIndex := iTempIndex;
  end;

  procedure ServeHintDirective(aHintDirective : THintDirective);
  begin
    {todo}
    Include(aHintDirectives, aHintDirective);
    StepNextToken(iTempIndex);
    ExpectToken(iTempIndex, ttSpecialChar, ';', 'D711C805');
    aIndex := iTempIndex;
  end;

begin
  iTempIndex := aIndex;
  aMessageHandler := '';
  while True do begin
    StepNextToken(iTempIndex);
    if IsToken(iTempIndex, ttKeyword, 'override') then ServeDirective(rdOverride) else
    if IsToken(iTempIndex, ttKeyword, 'overload') then ServeDirective(rdOverload) else
    if IsToken(iTempIndex, ttKeyword, 'reintroduce') then ServeDirective(rdReintroduce) else
    if IsToken(iTempIndex, ttKeyword, 'virtual') then ServeDirective(rdVirtual) else
    if IsToken(iTempIndex, ttKeyword, 'message') then ServeDirective(rdMessageHandler) else
    if IsToken(iTempIndex, ttKeyword, 'dynamic') then ServeDirective(rdDynamic) else
    if IsToken(iTempIndex, ttKeyword, 'abstract') then ServeDirective(rdAbstract) else

    if IsToken(iTempIndex, ttKeyword, 'register') then ServeDirective(rdRegister) else
    if IsToken(iTempIndex, ttKeyword, 'pascal') then ServeDirective(rdPascal) else
    if IsToken(iTempIndex, ttKeyword, 'cdecl') then ServeDirective(rdCdecl) else
    if IsToken(iTempIndex, ttKeyword, 'stdcall') then ServeDirective(rdStdcall) else
    if IsToken(iTempIndex, ttKeyword, 'safecall') then ServeDirective(rdSafecall) else
    {Delphi 6 only}
    if IsToken(iTempIndex, ttKeyword, 'deprecated') then ServeHintDirective(hdDeprecated) else
    Break;
  end;
end;

procedure TWDelphiParser.ParseTypeStatement(aUnitEntry: TEntry;
  var aIndex: Integer);
var
  sName : String;
  iTempIndex, iDeclarationStartIndex, iDeclarationEndIndex : Integer;
  iCommentLineIndex, iParseClassEntryIndex : Integer;
  ClassEntry : TClassEntry;
  InterfaceEntry : TInterfaceEntry;
  RecordEntry : TRecordEntry;
  TypeEntry : TTypeEntry;
  DispinterfaceEntry : TDispinterfaceEntry;
  bAddEntry, bIsPacked : boolean;
  RoutineDirectives : TRoutineDirectives;
  HintDirectives : THintDirectives;
  MessageHandler : String;
  TypeName: String;

  IsForward: Boolean; //AB
begin
  {type ...}
  try
    {type <NewType> = ...}
    while Token[aIndex].Token = ttIdentifier do begin
      bIsPacked := False;

      iDeclarationStartIndex := aIndex;
      sName := FirstCapitalLetter(Token[aIndex].Text);
      TypeName := Token[aIndex].Text;
      StepNextToken(aIndex);
      {type NewType <=> ...}
      ExpectToken(aIndex, ttSpecialChar, '=');
      StepNextToken(aIndex);
      {type NewType = <...>}
      if IsToken(aIndex, ttKeyword, 'packed') then begin
        bIsPacked := True;
        StepNextToken(aIndex);
        {type NewType = packed <...>}
      end;
      if IsToken(aIndex, ttKeyword, 'class') then
      try
        {Search for existing class entry, in case if the forvard declaration of the class was found before}
        ClassEntry := TClassEntry(FindEntry(sName, TClassEntry, aUnitEntry));
        if ClassEntry = nil then
          ClassEntry := TClassEntry.Create(sName, aUnitEntry, Self)
        else
          ClassEntry.Parents.Clear;
        ClassEntry.IsPacked := bIsPacked;
        ClassEntry.IsMetaClass := False;

        {type NewType = <class>}
        iCommentLineIndex := aIndex;
        iParseClassEntryIndex := 0;
        StepNextToken(aIndex);

        if IsToken(aIndex, ttSpecialChar, '(') then begin
          Repeat
            {type NewType = class<(>}
            StepNextToken(aIndex);
            ClassEntry.Parents.Add(FirstCapitalLetter(Token[aIndex].Text));
            StepNextToken(aIndex);
          Until not IsToken(aIndex, ttSpecialChar, ',');

          ExpectToken(aIndex, ttSpecialChar, ')', '1CC8EED0');
          iCommentLineIndex := aIndex;
          StepNextToken(aIndex);
          {type NewType = class(ParenType, ParenType1, ...) <...>}
        end
        else begin
          if IsToken(aIndex, ttKeyWord, 'of') then begin
            ClassEntry.IsMetaClass := True;
            StepNextToken(aIndex);
            {type NewType = class of <ParenType>}
            ClassEntry.Parents.Add(FirstCapitalLetter(Token[aIndex].Text));
            StepNextToken(aIndex);
          end
          else
            ClassEntry.Parents.Add('TObject');
        end;
        { Add class entry }
        bAddEntry := True;
        if Assigned(FOnClassEntry) then
          OnClassEntry(ClassEntry, bAddEntry, Token[aIndex].Text = ';');
        if Assigned(FOnProgress) then
          OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
        if bAddEntry then begin
          { Keep analyzing class declaration }
          FItems.Add(ClassEntry);
          {type NewType = class (...)}
          if IsToken(aIndex, ttSpecialChar, ';') then begin {type NewType = class<;>}
            iDeclarationEndIndex := aIndex;
            iCommentLineIndex := aIndex;
          end
          else begin
            ParseClassEntry(ClassEntry, aIndex);
            //StepNextToken(aIndex);
            ExpectToken(aIndex, ttSpecialChar, ';', '7AF842DB');
            iDeclarationEndIndex := aIndex;
          end;
        end
        else begin
          ClassEntry.Free;
          aIndex := LocateEndOfRecordStatement(aIndex);
          StepNextToken(aIndex);
          ExpectToken(aIndex, ttSpecialChar, ';', '7AF842DB');
        end;

        ClassEntry.BriefDeclaration := GetSourceString(iDeclarationStartIndex, iCommentLineIndex);

        { todo }
        ClassEntry.Declaration := GetSourceString(iDeclarationStartIndex, iDeclarationEndIndex);
        LookBackwardForDescription(iDeclarationStartIndex, ClassEntry.Summary,
          ClassEntry.Description);
        LookForwardForDescription(iCommentLineIndex, ClassEntry.Summary,
          ClassEntry.Description);
        StepNextToken(aIndex);

        if Assigned(fOnEndOfClassDef) then
          fOnEndOfClassDef(fStopAnalyze);

      except
        ClassEntry.Free;
        raise
      end
      else
      if IsToken(aIndex, ttKeyword, 'interface') then
      try
        {Search for existing interface entry, in case if the forvard declaration of the class was found before}
        InterfaceEntry := TInterfaceEntry(FindEntry(sName, TInterfaceEntry, aUnitEntry));
        if InterfaceEntry = nil then
          InterfaceEntry := TInterfaceEntry.Create(sName, aUnitEntry, Self)
        else
          InterfaceEntry.Parents.Clear;
        InterfaceEntry.IsPacked := bIsPacked;
        InterfaceEntry.IsMetaClass := False;

        {type NewType = <interface>}
        iCommentLineIndex := aIndex;
        iParseClassEntryIndex := 0;
        StepNextToken(aIndex);

        IsForward := false;

        if IsToken(aIndex, ttSpecialChar, '(') then begin
          Repeat
            {type NewType = interface<(>}
            StepNextToken(aIndex);
            InterfaceEntry.Parents.Add(FirstCapitalLetter(Token[aIndex].Text));
            StepNextToken(aIndex);
          Until not IsToken(aIndex, ttSpecialChar, ',');

          ExpectToken(aIndex, ttSpecialChar, ')', '05B9444E');
          iCommentLineIndex := aIndex;
          StepNextToken(aIndex);
          {type NewType = interface(ParenType, ParenType1, ...) <...>}
        end
        else if IsToken(aIndex, ttSpecialChar, ';') then //AB
        begin
          IsForward := true;
        end
        else begin
          (*if IsToken(aIndex, ttKeyWord, 'of') then begin
            InterfaceEntry.IsMetaClass := True;
            StepNextToken(aIndex);
            {type NewType = interface of <ParenType>}
            InterfaceEntry.Parents.Add(FirstCapitalLetter(Token[aIndex].Text));
            StepNextToken(aIndex);
          end
          else*)
            InterfaceEntry.Parents.Add('IUnknown');
        end;
        if IsToken(aIndex, ttSpecialChar, ';') then begin {type NewType = interface<;>}
          iDeclarationEndIndex := aIndex;
          iCommentLineIndex := aIndex;
        end
        else begin
          if IsToken(aIndex, ttSpecialChar, '[') then begin
            iTempIndex := aIndex;
            aIndex := LocateToken(']', ttSpecialChar, aIndex, '22D52EFF');
            InterfaceEntry.GUID := GetSourceString(iTempIndex, aIndex);
            StepNextToken(aIndex);
            {type NewType = interface(ParenType, ParenType1, ...) [GUID] <...>}
          end;

          iParseClassEntryIndex := aIndex;
          aIndex := LocateEndOfRecordStatement(aIndex);
          StepNextToken(aIndex);
          CheckForPlatformDirective(aIndex, InterfaceEntry);
          ExpectToken(aIndex, ttSpecialChar, ';', 'C7C09804');
          iDeclarationEndIndex := aIndex;
        end;
        InterfaceEntry.BriefDeclaration := GetSourceString(iDeclarationStartIndex, iCommentLineIndex);
        { todo }
        InterfaceEntry.Declaration := GetSourceString(iDeclarationStartIndex, iDeclarationEndIndex);
        LookBackwardForDescription(iDeclarationStartIndex,
          InterfaceEntry.Summary, InterfaceEntry.Description);
        LookForwardForDescription(iCommentLineIndex, InterfaceEntry.Summary,
          InterfaceEntry.Description);
        StepNextToken(aIndex);
        bAddEntry := True;

        if Assigned(FOnInterfaceEntry) then
          OnInterfaceEntry(InterfaceEntry, bAddEntry, Token[aIndex].Text = ';');

        if Assigned(FOnProgress) then
          OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
        if bAddEntry then begin
          FItems.Add(InterfaceEntry);
          if iParseClassEntryIndex <> 0 then
             ParseClassEntry(InterfaceEntry, iParseClassEntryIndex);
        end
        else InterfaceEntry.Free;

        if Assigned(fOnEndOfInterfaceDef) then
          fOnEndOfInterfaceDef(fStopAnalyze);
      except
        InterfaceEntry.Free;
        raise
      end
      else
      if IsToken(aIndex, ttKeyword, 'record') then
      try
        //RecordEntry := TRecordEntry(CreateEntry(TRecordEntry, sName, aUnitEntry));
        RecordEntry := TRecordEntry.Create(sName, aUnitEntry, Self);
        RecordEntry.IsPacked := bIsPacked;

        {type NewType = record ...}
        StepNextToken(aIndex);
        iDeclarationEndIndex := LocateEndOfRecordStatement(aIndex);
        aIndex := iDeclarationEndIndex;
        StepNextToken(aIndex);
        CheckForPlatformDirective(aIndex, RecordEntry);
        ExpectToken(aIndex, ttSpecialChar, ';', '4143B38D');

        RecordEntry.Declaration := GetSourceString(iDeclarationStartIndex, iDeclarationEndIndex);
        // ... AddRecordEntry
        bAddEntry := True;
        if Assigned(FOnRecordEntry) then
          OnRecordEntry(RecordEntry, bAddEntry);
        if Assigned(FOnProgress) then
          OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
        if not bAddEntry then RecordEntry.Free else FItems.Add(RecordEntry);
        StepNextToken(aIndex);
      except
        RecordEntry.Free;
        raise
      end
      else
      if IsToken(aIndex, ttKeyword, 'dispinterface') then
      try
        DispinterfaceEntry := TDispinterfaceEntry.Create(sName, aUnitEntry, Self);
        StepNextToken(aIndex);

        if Token[aIndex].Text = ';' then //AB (forward declaration)
        begin
           bAddEntry := false;
           StepNextToken(aIndex);
        end
        else
        begin
          ParseDispinterface(DispinterfaceEntry, aIndex);
          bAddEntry := True;
          if Assigned(FOnDispinterfaceEntry) then
            OnDispinterfaceEntry(DispinterfaceEntry, bAddEntry, false);
          if Assigned(FOnProgress) then
            OnProgress(FStopAnalyze);
          if FStopAnalyze then Abort;
        end;

        if bAddEntry then
           FItems.Add(DispinterfaceEntry)
        else
           DispinterfaceEntry.Free;
      except
        DispinterfaceEntry.Free;
        raise
      end
      else
      try
        TypeEntry := TTypeEntry.Create(sName, aUnitEntry, Self);
        TypeEntry.IsPacked := bIsPacked;
        iTempIndex := aIndex;
        {type NewType = <ParentType>}
        if IsToken(aIndex, ttKeyword, 'procedure') or IsToken(aIndex, ttKeyword, 'function')
        then begin
          ReadExistingType(aIndex);
          CheckForPlatformDirective(aIndex, TypeEntry);
          ExpectToken(aIndex, ttSpecialChar, ';', 'F10B6BEC');
          RoutineDirectives := [];
          ParseRoutineDirectives(aIndex, RoutineDirectives, MessageHandler, TypeEntry.HintDirectives);
        end
        else
        if IsToken(aIndex, ttKeyword, 'type') then begin
          StepNextToken(aIndex);
          {type NewType = type <...> }
          iTempIndex := aIndex;
        end;

        if Token[AIndex].Text = '(' then
        begin
          if Assigned(OnEnumType) then
            OnEnumType(TypeName);
        end;

        iDeclarationEndIndex := LocateToken(';', ttSpecialChar, aIndex, 'EF9EDE85');
        if iDeclarationEndIndex >= 0 then aIndex := iDeclarationEndIndex;
        TypeEntry.Declaration := GetSourceString(iDeclarationStartIndex, iDeclarationEndIndex);

        TypeEntry.ExistingType := GetSourceString(iTempIndex, iDeclarationEndIndex);
        if Length(TypeEntry.ExistingType) > 1 then SetLength(TypeEntry.ExistingType, Length(TypeEntry.ExistingType) - 1);

        { todo }
        LookBackwardForDescription(iDeclarationStartIndex, TypeEntry.Summary,
          TypeEntry.Description);
        LookForwardForDescription(aIndex, TypeEntry.Description, TypeEntry.Summary);
        bAddEntry := True;
        if Assigned(FOnTypeEntry) then
          OnTypeEntry(TypeEntry, bAddEntry);
        if Assigned(FOnProgress) then
          OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
        if not bAddEntry then TypeEntry.Free else FItems.Add(TypeEntry);
        StepNextToken(aIndex);
      except
        TypeEntry.Free;
        raise
      end;
      if IsToken(aIndex, ttKeyword, 'const') or IsToken(aIndex, ttKeyword, 'var') or
         IsToken(aIndex, ttKeyword, 'procedure') or IsToken(aIndex, ttKeyword, 'function') or
         IsToken(aIndex, ttKeyword, 'record')
      then Break;
    end;
  except
    raise
  end;
end;

procedure TWDelphiParser.ParseUsesStatement(aUnitEntry: TEntry;
  var aIndex: Integer);
begin
  // todo
  repeat
    if Token[aIndex].Token = ttIdentifier then
    begin
      if Assigned(fOnUsedUnit) then
        fOnUsedUnit(Token[aIndex].Text);
      StepNextToken(aIndex);
    end;
    if Token[aIndex].Text = ',' then
      StepNextToken(aIndex)
    else
      Break;
  until false;

  if Assigned(fOnEndOfUsesClause) then
    fOnEndOfUsesClause(FStopAnalyze);
end;

procedure TWDelphiParser.ParseVarStatement(aUnitEntry: TEntry;
  var aIndex: Integer);
var
  iDeclarationStartIndex, i : Integer;
  VariableEntry, TempVariableEntry : TVariableEntry;
  bAddEntry : boolean;
  VariableNames : TStringList;
begin
  {var ...}
  try
    VariableNames := TStringList.Create;
    try
      {var <Name> = ...}
      while Token[aIndex].Token = ttIdentifier do begin
        try
          iDeclarationStartIndex := aIndex;
          TempVariableEntry := TVariableEntry.Create('', nil, Self);
          TempVariableEntry.Name := FirstCapitalLetter(Token[aIndex].Text); // todo
          repeat
            VariableNames.Add(FirstCapitalLetter(Token[aIndex].Text));
            StepNextToken(aIndex);
            if IsToken(aIndex, ttSpecialChar, ',') then begin
              StepNextToken(aIndex);
              {var Name , <???> ...}
            end
            else
              Break
          until False;
          {var Name [, Name1 ... ] <???> ...}
          ExpectToken(aIndex, ttSpecialChar, ':', 'FA0F8A1F');
          StepNextToken(aIndex);
          TempVariableEntry.TypeName := ReadExistingType(aIndex);
          {var Name : TypeName : ExistingType <=> ...}

          if IsToken(aIndex, ttSpecialChar, '=') then begin

            StepNextToken(aIndex);
            {var Name : ExistingType = <...>}
            if IsToken(aIndex, ttSpecialChar, '(') then begin
              {var Name = <(>}
              i := LocatePairBracket(aIndex);
              StepNextToken(i);
              {var Name = (...) <...>}
              CheckForPlatformDirective(i, TempVariableEntry);
              ExpectToken(i, ttSpecialChar, ';', 'DC108CB4');
            end
            else
              i := LocateToken(';', ttSpecialChar, aIndex, '95BC45A6');

            TempVariableEntry.Value := StrShrink(GetSourceString(aIndex, i), 1);
            aIndex := i;
          end;

          CheckForPlatformDirective(aIndex, TempVariableEntry);
          ExpectToken(aIndex, ttSpecialChar, ';', '805914E1');

            { todo }
          TempVariableEntry.Declaration := GetSourceString(iDeclarationStartIndex, aIndex);

          LookBackwardForDescription(iDeclarationStartIndex,
            TempVariableEntry.Summary, TempVariableEntry.Description);
          LookForwardForDescription(aIndex, TempVariableEntry.Summary,
            TempVariableEntry.Description);

          while VariableNames.Count > 0 do begin
            VariableEntry := TVariableEntry.Create(VariableNames.Strings[0], aUnitEntry, Self);
            VariableEntry.TypeName := TempVariableEntry.TypeName;
            VariableEntry.Value := TempVariableEntry.Value;
            VariableEntry.Declaration := TempVariableEntry.Declaration;
            VariableEntry.Summary := TempVariableEntry.Summary;
            VariableEntry.Description := TempVariableEntry.Description;
            { Add Entry }
            bAddEntry := True;
            if Assigned(FOnVarEntry) then
              OnVarEntry(VariableEntry, bAddEntry);
            if Assigned(FOnProgress) then
              OnProgress(FStopAnalyze);  if FStopAnalyze then Abort;
            if not bAddEntry then VariableEntry.Free
                             else FItems.Add(VariableEntry);

            VariableNames.Delete(0);
          end;
          StepNextToken(aIndex);
          if IsToken(aIndex, ttKeyword, 'type') or IsToken(aIndex, ttKeyword, 'const') or
             IsToken(aIndex, ttKeyword, 'procedure') or IsToken(aIndex, ttKeyword, 'function') or
             IsToken(aIndex, ttKeyword, 'record')
          then Break;
        finally
          TempVariableEntry.Free;
        end;
      end;
    except
      raise
    end;
  finally
    VariableNames.Free;
  end;
end;

function TWDelphiParser.LocateEndOfRecordStatement(
  aIndex: Integer): Integer;
var
  i : Integer;
begin
  i := 0;
  while True do begin
    if aIndex = FWParser.Count - 1 then
      raise Exception.Create('Error A651FCCA: Unable to locate the end of Record Statement.');
    if IsToken(aIndex, ttKeyword, 'end') then begin
      if i = 0 then Break else Dec(i);
    end;
    StepNextToken(aIndex);
    if IsToken(aIndex, ttKeyword, 'record') then begin
      Inc(i);
      StepNextToken(aIndex);
    end;
  end;
  Result := aIndex;
end;

function TWDelphiParser.LocatePairBracket(aIndex: Integer): Integer;
var
  i : Integer;
begin
  i := 0;
  while True do begin
    if aIndex = FWParser.Count - 1 then
      raise Exception.Create('Error A651FCCA: Unable to locate a pair bracket.');
    if IsToken(aIndex, ttSpecialChar, ')') then begin
      if i = 0 then Break else Dec(i);
    end;
    StepNextToken(aIndex);
    if IsToken(aIndex, ttSpecialChar, '(') then begin
      Inc(i);
      StepNextToken(aIndex);
    end;
  end;
  Result := aIndex;
end;

function TWDelphiParser.ReadExistingType(var aIndex: Integer): String;
var
  //iTempIndex : Integer;
  bpDeclarationBegin : TWParserBreakPoint;
  bIsFunction : boolean;
  RoutineDirectives : TRoutineDirectives;
  HintDirectives : THintDirectives;
  MessageHandler : String;
begin
  //iTempIndex := aIndex;
  Result := '';
  with bpDeclarationBegin do begin Index := aIndex; Parser := FWParser; end;
  {<...>}
  if IsToken(aIndex, ttKeyword, 'procedure') or
     IsToken(aIndex, ttKeyword, 'function')
  then begin
    bIsFunction := IsToken(aIndex, ttKeyword, 'function');
    {<procedure/function>}
    StepNextToken(aIndex);
    if IsToken(aIndex, ttSpecialChar, '(') then begin
      {procedure/function <(>...}
      aIndex := LocatePairBracket(aIndex);
      {procedure/function (...<)>}
      StepNextToken(aIndex);
    end;
    if bIsFunction then begin
      ExpectToken(aIndex, ttSpecialChar, ':', '4D737F6F');
      {function (...) <:>}
      StepNextToken(aIndex);
      {function (...) : <TypeName> }
      StepNextToken(aIndex);
    end;
    if IsToken(aIndex, ttKeyword, 'of') then begin
      StepNextToken(aIndex);
      ExpectToken(aIndex, ttKeyword, 'object', '9B3BF4CA');
      StepNextToken(aIndex);
      {procedure/function (...) of object <...>}
    end;
    while
       IsToken(aIndex, ttKeyword, 'register') or IsToken(aIndex, ttKeyword, 'pascal') or
       IsToken(aIndex, ttKeyword, 'cdecl') or IsToken(aIndex, ttKeyword, 'stdcall') or
       IsToken(aIndex, ttKeyword, 'safecall')
    do begin
      StepNextToken(aIndex);
    end;

    RoutineDirectives := [];
    ParseRoutineDirectives(aIndex, RoutineDirectives, MessageHandler, HintDirectives);

  end
  else
  if IsToken(aIndex, ttKeyword, 'array') then begin
    {<array> }
    aIndex := LocateToken('of', ttKeyword, aIndex, '1849F78B');
    StepNextToken(aIndex);
    {array ... of <ExistingType> }
    StepNextToken(aIndex);
    {array ... of ... <...> }
  end
  else
  if IsToken(aIndex, ttKeyword, 'set') then begin
    {<set> }
    StepNextToken(aIndex);
    {set <of>  }
    ExpectToken(aIndex, ttKeyword, 'of', 'E28BCC2E');
    StepNextToken(aIndex);
    {set of <ExistingType> }
    StepNextToken(aIndex);
    {set of ... <...> }
  end
  else
  begin
    {<...> }
    StepNextToken(aIndex);
  end;
  //Result := GetSourceString(iTempIndex, aIndex);
  ReadSourceStringIfNotEmpty(Result, bpDeclarationBegin, WParserBreakpoint(aIndex, FWParser));
  Result := StrShrink(Result, 1);
end;

function TWDelphiParser.ReadPropertyProcName(var aIndex: Integer): String;
begin
  {<...>}
  Result := '';
  repeat
    Result := Result + FirstCapitalLetter(Token[aIndex].Text);
    StepNextToken(aIndex);
    if IsToken(aIndex, ttSpecialChar, '.') then begin
      StepNextToken(aIndex);
      Result := Result + '.';
      Continue;
    end
    else
      Break;
  Until False;
end;

procedure TWDelphiParser.ParseTStorageSpecifiers(var aIndex: Integer;
  var aStorageSpecifiers: TStorageSpecifiers; var aDefaultValue: String);
var
  iTempIndex, i : Integer;
begin
  iTempIndex := aIndex;
  aDefaultValue := '';
  while True do begin
    if IsToken(iTempIndex, ttKeyword, 'default') then begin
      StepNextToken(iTempIndex);
      if IsToken(iTempIndex, ttSpecialChar, '[') then begin
        i := LocateToken(']', ttSpecialChar, iTempIndex, '574B5474');
        aDefaultValue := GetSourceString(iTempIndex, i);
        iTempIndex := i;
      end
      else begin
        aDefaultValue := Token[iTempIndex].Text;
        if (aDefaultValue = '-') or (aDefaultValue = '#') or (aDefaultValue = '$') then begin
          StepNextToken(iTempIndex);
          aDefaultValue := aDefaultValue + Token[iTempIndex].Text;
        end;
      end;
      StepNextToken(iTempIndex);
      aIndex := iTempIndex;
    end
    else
    if IsToken(iTempIndex, ttKeyword, 'nodefault') then begin
      Include(aStorageSpecifiers, ssNoDefault);
      StepNextToken(iTempIndex);
      aIndex := iTempIndex;
    end
    else
    if IsToken(iTempIndex, ttKeyword, 'stored') then begin
      StepNextToken(iTempIndex);
      ExpectTokenBooleanValue(iTempIndex);
      if IsToken(iTempIndex, ttIdentifier, 'true') then Include(aStorageSpecifiers, ssStored) else
      if IsToken(iTempIndex, ttIdentifier, 'false') then Include(aStorageSpecifiers, ssNotStored); // else {Error!!!};
      StepNextToken(iTempIndex);
      aIndex := iTempIndex;
    end
    else
      Break;
  end;
end;

function TWDelphiParser.LocateToken(aTokenName: String;
  aTokenType: TTokenType; aStartIndex: integer;
  aErrorCode: String): Integer;
begin
  Result := FindToken(aTokenName, aTokenType, aStartIndex);
  if Result < 0 then begin
    raise Exception.Create(Format('Error %s: Unable to locate token ''%s''.', [aErrorCode, aTokenName]));
  end;
end;

procedure TWDelphiParser.ReadProcedureEntry(
  aProcedureEntry: TProcedureEntry; var aIndex: Integer;
  aIsFunction: boolean);
var
  iDeclarationStartIndex, iDeclarationEndIndex : Integer;
begin
  {<procedure> }
  iDeclarationStartIndex := aIndex;
  StepNextToken(aIndex);
  {procedure <Name> }
  aProcedureEntry.Name := FirstCapitalLetter(Token[aIndex].Text);
  StepNextToken(aIndex);
  if IsToken(aIndex, ttSpecialChar, '(') then begin
    {procedure Name <(>...}
    aIndex := LocatePairBracket(aIndex);
    {procedure (...<)>}
    StepNextToken(aIndex);
  end;
  if aIsFunction then begin
    ExpectToken(aIndex, ttSpecialChar, ':', '3724C1C3');
    StepNextToken(aIndex);
    (aProcedureEntry as TFunctionEntry).ResultType := Token[aIndex].Text;
    StepNextToken(aIndex);
  end;
  aProcedureEntry.RoutineDirectives := [];

  if IsToken(aIndex, ttKeyword, 'register') or IsToken(aIndex, ttKeyword, 'pascal') or
     IsToken(aIndex, ttKeyword, 'cdecl') or IsToken(aIndex, ttKeyword, 'stdcall') or
     IsToken(aIndex, ttKeyword, 'safecall')
     {Delphi 6 only }
     or IsToken(aIndex, ttKeyword, 'deprecated')
  then
    Dec(aIndex)
  else begin
    CheckForPlatformDirective(aIndex, aProcedureEntry);
    ExpectToken(aIndex, ttSpecialChar, ';', '5F918EE0');
  end;
  ParseRoutineDirectives(aIndex, aProcedureEntry.RoutineDirectives,
                         aProcedureEntry.MessageHandler,
                         aProcedureEntry.HintDirectives);

  { todo }
  aProcedureEntry.Declaration := GetSourceString(iDeclarationStartIndex, aIndex);
  LookBackwardForDescription(iDeclarationStartIndex, aProcedureEntry.Summary,
    aProcedureEntry.Description);
  LookForwardForDescription(aIndex, aProcedureEntry.Summary,
    aProcedureEntry.Description);
  StepNextToken(aIndex);
end;

function TWDelphiParser.FindEntry(aName: String; aEntry: TEntry): TEntry;
var
  i : Integer;
  L : TList;
begin
  Result := nil;
  if Assigned(aEntry) then L := aEntry else L := FItems;
  if Assigned(L) then
    with L do
      if Count > 0 then
        for i := 0 to Count - 1 do
          if (TObject(L[i]) is TEntry) then
            with TEntry(L[i]) do begin
              if CompareText(Name, aName) = 0 then begin
                Result := L[i];
                Break;
              end;
            end;
end;

function TWDelphiParser.FindEntry(aName: String; aEntryClass: TClass;
  aEntry: TEntry): TEntry;
var
  i : Integer;
  L : TList;
begin
  Result := nil;
  if Assigned(aEntry) then L := aEntry else L := FItems;
  if Assigned(L) then
    with L do
      if Count > 0 then
        for i := 0 to Count - 1 do
          if (TObject(L[i]) is aEntryClass) then
            with TEntry(L[i]) do begin
              if CompareText(Name, aName) = 0 then begin
                Result := L[i];
                Break;
              end;
            end;
end;

function TWDelphiParser.GetActive: Boolean;
begin
  Result := Assigned(FRootEntry);
end;

function TWDelphiParser.GetToken(Index: Integer): TToken;
begin
  Result := FWParser.Token[Index];
end;

function TWDelphiParser.IsToken(aIndex: Integer; aTokenType: TTokenType;
  aText: String): boolean;
begin
  Result := FWParser.IsToken(aIndex, aTokenType, aText)
end;

function TWDelphiParser.IsToken(aToken: TToken; aTokenType: TTokenType;
  aText: String): boolean;
begin
  Result := FWParser.IsToken(aToken, aTokenType, aText)
end;

function TWDelphiParser.FindToken(aTokenName: String;
  aTokenType: TTokenType; aStartIndex: integer): Integer;
begin
  Result := FWParser.FindToken(aTokenName, aTokenType, aStartIndex);
end;

function TWDelphiParser.GetSourceString(aStartIndex,
  aEndIndex: Integer): String;
begin
  Result := FWParser.GetSourceString(aStartIndex, aEndIndex);
end;

procedure TWDelphiParser.SetCommentDescriptionTags(
  const Value: TStringList);
begin
  FCommentDescriptionTags.Assign(Value);
end;

procedure TWDelphiParser.SetCommentSummaryTags(const Value: TStringList);
begin
  FCommentSummaryTags.Assign(Value);
end;

procedure TWDelphiParser.SetCommentTags(const Value: TStringList);
begin
  FCommentTags.Assign(Value);
end;

procedure TWDelphiParser.SetCommentNewLineTags(const Value: TStringList);
begin
  FCommentNewLineTags.Assign(Value);
end;


function TWDelphiParser.GetSourceString(aStartBP,
  aEndBP: TWParserBreakpoint): String;
var
  i : Integer;
begin
  Result := '';
  { If both breakpoints in the same file }
  if aStartBP.Parser = aEndBP.Parser then begin
    Result := aStartBP.Parser.GetSourceString(aStartBP.Index, aEndBP.Index);
  end
  else
  if FWParserStack.Count > 0 then begin
    if aStartBP.Parser = FWParser then begin

    end
    else
    if aEndBP.Parser = FWParser then begin
      Result := aEndBP.Parser.GetSourceString(0, aEndBP.Index) + Result;
      for i := 0 to FWParserStack.Count - 1 do
        if FWParserStack.Items[i].FWParser = aStartBP.Parser then begin
          Result := FWParserStack.Items[i].FWParser.GetSourceString(aStartBP.Index, FWParserStack.Items[i].FWParser.Count - 1) + Result;
          Break;
        end
        else
          Result := FWParserStack.Items[i].FWParser.GetSourceString(0, FWParserStack.Items[i].FWParser.Count - 1) + Result;
    end
    else begin

    end;
  end;
end;

procedure TWDelphiParser.ReadSourceStringIfNotEmpty(var aText: String;
  aStartBP, aEndBP: TWParserBreakpoint);
var
  S : String;
begin
  S := GetSourceString(aStartBP, aEndBP);
  if S <> '' then aText := S;
end;

procedure TWDelphiParser.EndOfDeclaration(aEntry: TEntry; aStartBP,
  aEndBP: TWParserBreakpoint);
begin
  if aEntry is TPasEntry then
    ReadSourceStringIfNotEmpty((aEntry as TPasEntry).Declaration,
                               aStartBP, aEndBP);
   LookBackwardForDescription(aStartBP.Index, aEntry.Summary, aEntry.Description);
   LookForwardForDescription(aEndBP.Index, aEntry.Summary, aEntry.Description);
end;

{ TWParserStackItem }

constructor TWParserStackItem.Create(aWParser: TWParser; aIndex: Integer; aFileName : String);
begin
  FWParser := aWParser;
  FIndex := aIndex;
  FFileName := aFileName;
end;

destructor TWParserStackItem.Destroy;
begin
  FreeAndNil(FWParser);
  inherited;
end;

{ TWParserStack }

procedure TWParserStack.Clear(var aWParser: TWParser);
var
  i : Integer;
  S : String;
begin
  while Count > 0 do
    Pop(aWParser, i, S);
end;

function TWParserStack.GetItem(Index: Integer): TWParserStackItem;
begin
  Result := TWParserStackItem(inherited Items[Index]);
end;

procedure TWParserStack.Pop(var aWParser: TWParser; var aIndex: Integer; var aFileName : String);
begin
  if Count > 0 then begin
    FreeAndNil(aWParser);
    with TWParserStackItem(Items[0]) do begin
      aWParser := FWParser;
      aIndex := FIndex;
      aFileName := FFileName;
    end;
    Delete(0);
  end
  else
    raise Exception.Create('WParserStack is empty.');
end;

procedure TWParserStack.Push(aWParser: TWParser; aIndex: Integer; aFileName : String);
begin
  Insert(0, TWParserStackItem.Create(aWParser, aIndex, aFileName));
end;

end.
