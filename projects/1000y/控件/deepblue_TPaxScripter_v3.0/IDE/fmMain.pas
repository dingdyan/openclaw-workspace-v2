////////////////////////////////////////////////////////////////////////////
// PAXScript IDE
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2004. All rights reserved.
// Code Version: 2.6
// ========================================================================
// Unit: fmMain.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

unit fmMain;

interface

uses
  SysUtils, Classes,
  contnrs,
{$IFDEF LINUX}
  Qt,
  Types,
  QTypes,
  QGraphics, QControls, QForms, QDialogs,
  QExtCtrls, QMenus, QStdCtrls, QComCtrls,
  QImgList, QButtons,
{$ELSE}
  Windows,
  Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, StdCtrls, ComCtrls,
  ImgList, Buttons, ShellAPI,
{$ENDIF}
  fmExplorer,

  SynEdit, SynEditHighlighter,

  SynHighlighterPaxC, SynHighlighterPaxBasic,
  SynHighlighterPaxPascal, SynHighlighterPaxJavaScript,

  BASE_SYS, BASE_SCRIPTER, PAX_RTTI,

  IMP_SysUtils, IMP_Contnrs, IMP_Classes, IMP_ActiveX, 
  IMP_Controls,
  IMP_StdCtrls, IMP_ComCtrls, IMP_Buttons, IMP_Forms,
  IMP_Graphics, IMP_ExtCtrls, IMP_Dialogs, IMP_Menus, IMP_ImgList,

{$ifdef Ver150}
  IMP_Variants,
{$endif}

  PaxScripter, PaxJavaScript, PaxC, PaxBasic, PaxPascal, BASE_PARSER;

const
  paxsite = 'http://www.paxscript.com/';
  helpsite = '\Help\index.htm';
  ininame = 'paxide.ini';
  HeightNoProject = 95;

  paxProject_Ext = '.pax';

type
  TLineInfo = (dlTraceLine, dlBreakpointLine, dlExecutableLine, dlBadBreakpointLine,
               dlErrorLine);
  TLineInfos = set of TLineInfo;

  TIDEState = (ideNoProject, ideInit, idePaused);

  TEditor = class (TSynEdit)
  public
    TraceLine: Integer;
    constructor Create(AOwner: TComponent); override;
    procedure RemoveLineInfos(LineInfos: TLineInfos);
  end;

  TLineRecord = class
    ModuleName: String;
    LineNumber: Integer;
    Condition: String;
    PassCount: Integer;
    LineInfos: TLineInfos;
    constructor Create(const ModuleName: String; LineNumber: Integer;
                       const Condition: String; PassCount: Integer;
                       LineInfos: TLineInfos);
  end;

  TFormMain = class;

  TDebugSupportPlugin = class(TSynEditPlugin)
  protected
    fForm: TFormMain;
    procedure AfterPaint(ACanvas: TCanvas; AClip: TRect;
      FirstLine, LastLine: integer); override;
    procedure LinesInserted(FirstLine, Count: integer); override;
    procedure LinesDeleted(FirstLine, Count: integer); override;
  public
    constructor Create(Editor: TEditor);
  end;

  TFormMain = class(TForm)
    PanelTop: TPanel;
    PanelBottom: TPanel;
    MainMenu1: TMainMenu;
    mFile: TMenuItem;
    mOpenProject: TMenuItem;
    N1: TMenuItem;
    mNewProject: TMenuItem;
    N2: TMenuItem;
    mSave: TMenuItem;
    N3: TMenuItem;
    mExit: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    mRun: TMenuItem;
    mAddBreakpoint: TMenuItem;
    N4: TMenuItem;
    RunScript: TMenuItem;
    N5: TMenuItem;
    mStepOver: TMenuItem;
    mTraceInto: TMenuItem;
    mProject: TMenuItem;
    mAddToProject: TMenuItem;
    mRemoveFromProject: TMenuItem;
    PageControl1: TPageControl;
    mHelp: TMenuItem;
    mAbout: TMenuItem;
    PanelBottomLeft: TPanel;
    PanelBottomRight: TPanel;
    PanelBottomCenter: TPanel;
    LabelBottomLeft: TLabel;
    LabelBottomCenter: TLabel;
    LabelBottomRight: TLabel;
    imglGutterGlyphs: TImageList;
    mProgramReset: TMenuItem;
    PageControl2: TPageControl;
    TreeView1: TTreeView;
    TabSheetWatches: TTabSheet;
    ListBoxWatches: TListBox;
    TabSheetBreakpoints: TTabSheet;
    ListBoxBreakpoints: TListBox;
    TabSheetCallStack: TTabSheet;
    ListBoxCallStack: TListBox;
    mRunToCursor: TMenuItem;
    mTraceToNextSourceLine: TMenuItem;
    mClose: TMenuItem;
    N7: TMenuItem;
    SpeedButtonNew: TSpeedButton;
    SpeedButtonOpen: TSpeedButton;
    SpeedButtonSave: TSpeedButton;
    SpeedButtonAdd: TSpeedButton;
    SpeedButtonRemove: TSpeedButton;
    SpeedButtonRun: TSpeedButton;
    SpeedButtonHelp: TSpeedButton;
    SpeedButtonTraceInto: TSpeedButton;
    SpeedButtonStepOver: TSpeedButton;
    mRemoveAllBreakpoints: TMenuItem;
    N6: TMenuItem;
    mCompile: TMenuItem;
    mEdit: TMenuItem;
    mUndo: TMenuItem;
    mRedo: TMenuItem;
    N8: TMenuItem;
    mCut: TMenuItem;
    mCopy: TMenuItem;
    mPaste: TMenuItem;
    mDelete: TMenuItem;
    mSelectAll: TMenuItem;
    OnlineHelp1: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    PaxScriptHomePage1: TMenuItem;
    AddWatch1: TMenuItem;
    View1: TMenuItem;
    mConsole: TMenuItem;
    N11: TMenuItem;
    ViewSource1: TMenuItem;
    PaxScripter1: TPaxScripter;
    Search1: TMenuItem;
    Find1: TMenuItem;
    SearchAgain1: TMenuItem;
    PaxPascal1: TPaxPascal;
    PaxBasic1: TPaxBasic;
    PaxC1: TPaxC;
    PaxJavaScript1: TPaxJavaScript;
    PaintBox1: TPaintBox;
    procedure mExitClick(Sender: TObject);
    procedure mOpenProjectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mAddBreakpointClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mNewProjectClick(Sender: TObject);
    procedure mAddToProjectClick(Sender: TObject);
    procedure mRemoveFromProjectClick(Sender: TObject);
    procedure RunScriptClick(Sender: TObject);
    procedure mCompileClick(Sender: TObject);
    procedure mTraceIntoClick(Sender: TObject);
    procedure mStepOverClick(Sender: TObject);
    procedure mProgramResetClick(Sender: TObject);
    procedure ListBoxWatchesKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mRunToCursorClick(Sender: TObject);
    procedure mTraceToNextSourceLineClick(Sender: TObject);
    procedure ListBoxCallStackDblClick(Sender: TObject);
    procedure mCloseClick(Sender: TObject);
    procedure mSaveClick(Sender: TObject);
    procedure SpeedButtonOpenClick(Sender: TObject);
    procedure SpeedButtonNewClick(Sender: TObject);
    procedure SpeedButtonSaveClick(Sender: TObject);
    procedure SpeedButtonAddClick(Sender: TObject);
    procedure SpeedButtonRemoveClick(Sender: TObject);
    procedure SpeedButtonHelpClick(Sender: TObject);
    procedure mAboutClick(Sender: TObject);
    procedure mRemoveAllBreakpointsClick(Sender: TObject);
    procedure SpeedButtonRunClick(Sender: TObject);
    procedure SpeedButtonTraceIntoClick(Sender: TObject);
    procedure SpeedButtonStepOverClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mUndoClick(Sender: TObject);
    procedure mRedoClick(Sender: TObject);
    procedure mCutClick(Sender: TObject);
    procedure mCopyClick(Sender: TObject);
    procedure mDeleteClick(Sender: TObject);
    procedure mSelectAllClick(Sender: TObject);
    procedure PaxScripter1ShowError(Sender: TPaxScripter);
    procedure PaxScripter1BeforeRunStage(Sender: TPaxScripter);
    procedure PaxScripter1BeforeCompileStage(Sender: TPaxScripter);
    procedure PaxScripter1AssignScript(Sender: TPaxScripter);
    procedure PaxScripter1AfterCompileStage(Sender: TPaxScripter);
    procedure OnlineHelp1Click(Sender: TObject);
    procedure ListBoxBreakpointsDblClick(Sender: TObject);
    procedure PaxScriptHomePage1Click(Sender: TObject);
    procedure PaxScripter1Print(Sender: TPaxScripter; const S: String);
    procedure mPasteClick(Sender: TObject);
    procedure AddWatch1Click(Sender: TObject);
    procedure mConsoleClick(Sender: TObject);
    procedure ViewSource1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PaxScripter1CompilerProgress(Sender: TPaxScripter;
      ModuleNumber: Integer);
    procedure Find1Click(Sender: TObject);
    procedure SearchAgain1Click(Sender: TObject);
  private
//Code explorer
    PosList: TObjectList;
    procedure EnumProc(const Name: String;
                       ID: Integer;
                       Kind: TPAXMemberKind;
                       ml: TPAXModifierList;
                       Data: Pointer);
     procedure SetupClassNode(N: TTreeNode; ID: Integer);
     procedure SetupFuncNode(N: TTreeNode; ID: Integer);
     procedure RebuildCodeExplorerTree;
  private
    SignSyntaxCheck: Boolean;
    IniFile: TPAXIniFile;
    ScriptWasAssigned: Boolean;

    SynPaxPascalSyn1: TSynPaxPascalSyn;
    SynPaxBasicSyn1: TSynPaxBasicSyn;
    SynPaxCSyn1: TSynPaxCSyn;
    SynPaxJavaScriptSyn1: TSynPaxJavaScriptSyn;

    ProjectName: String;
    ScriptAge: Integer;

    HeightOpenProject: Integer;
    PageControl2Height: Integer;

    ideState: TIDEState;

    CompileAndRun: Boolean;

    SearchString: String;
    SearchPos: Integer;

    procedure SetIDEState(IDEState: TIDEState);
    function FindPage(const ModuleName: String): TTabSheet;

    function FindEditor(Page: TTabSheet): TEditor; overload;
    function FindEditor(const ModuleName: String): TEditor; overload;

    procedure ToggleBreakpoint(ALine: Integer);
    function GetLineInfos(ALine: Integer): TLineInfos;
    { Private declarations }

    function IsExecutableLine(ALine: integer): boolean;
    function IsBreakpointLine(ALine: integer): boolean;
    function IsBadBreakpointLine(ALine: integer): boolean;
    function IsErrorLine(ALine: integer): boolean;

    function CurrentEditor: TEditor;
    function CurrentModuleName: String;
    function CurrentModuleID: Integer;
    function CurrentLineNumber: Integer;
    function CurrentPosNumber: Integer;
    function GetLineRecord(LineNumber: Integer): TLineRecord;
    procedure SetLineRecord(LineNumber: Integer; LineRecord: TLineRecord);
    procedure UpdateBottomLeftLabel;
    procedure AddBreakpoints;
    procedure RemoveAllBreakpoints;
    procedure RemoveError;
    function ScriptHasBeenChanged: Boolean;
    procedure SetTraceLine(const ModuleName: String; ALine: integer);
    procedure RemoveTraceLine;
    procedure Trace(RunMode: Integer; const ModuleName: String = ''; ALine: integer = 0);

    procedure PaintGutterGlyphs(ACanvas: TCanvas; AClip: TRect;
                                FirstLine, LastLine: integer);
    procedure EditorSpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    procedure EditorKeyUp(Sender: TObject; var Key: Word;
                             Shift: TShiftState);
    procedure EditorGutterClick(Sender: TObject; X, Y, Line: Integer;
      mark: TSynEditMark);
    procedure EditorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EditorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function GetModName(Index: Integer): String;
    procedure UpdateLineNumbers;
  public
    WatchList: TStringList;
    function ModuleCount: Integer;
    procedure ShowError(Sender: TPaxScripter);
    function LanguageName: String;
    function GotoLine(const ModuleName: String; LineNumber: Integer): TEditor;

    procedure ProcessWatches;
    procedure ProcessCallStack;

    procedure CloseProject;
    procedure OpenNewProject(const FileName: String);
    procedure CreateNewProject(const FileName: String);
    procedure AddToProject(const ModuleName, FileName, LanguageName: String);
    procedure RemoveFromProject(const ModuleName: String);
    procedure SaveProject;

    property ModuleNames[Index: Integer]: String read GetModName;
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses fmNewProject, fmDelete, fmConsole, fmCompiling, fmAbout;

{$R *.dfm}

constructor TEditor.Create(AOwner: TComponent);
begin
  inherited;
  TraceLine := -1;
  WantTabs := true;
end;

procedure TEditor.RemoveLineInfos(LineInfos: TLineInfos);
var
  LineRecord: TLineRecord;
  J: Integer;
begin
  for J:=0 to Lines.Count - 1 do
    if Lines.Objects[J] <> nil then
    begin
      LineRecord := TLineRecord(Lines.Objects[J]);
      LineRecord.LineInfos := LineRecord.LineInfos - LineInfos;
      if LineRecord.LineInfos = [] then
      begin
        LineRecord.Free;
        Lines.Objects[J] := nil;
      end;
    end;
  Invalidate;
end;

constructor TDebugSupportPlugin.Create(Editor: TEditor);
begin
  inherited Create(Editor);
  fForm := FormMain;
end;

procedure TDebugSupportPlugin.AfterPaint(ACanvas: TCanvas; AClip: TRect;
  FirstLine, LastLine: integer);
begin
  FormMain.PaintGutterGlyphs(ACanvas, AClip, FirstLine, LastLine);
end;

procedure TDebugSupportPlugin.LinesInserted(FirstLine, Count: integer);
begin
end;

procedure TDebugSupportPlugin.LinesDeleted(FirstLine, Count: integer);
var
  I: Integer;
  Editor: TEditor;
begin
  Editor := FormMain.CurrentEditor;

  if Editor = nil then
    Exit;

  for I:=FirstLine to FirstLine + Count - 1 do
    if Editor.Lines.Objects[I] <> nil then
    begin
      Editor.Lines.Objects[I].Free;
      Editor.Lines.Objects[I] := nil;
    end;
end;

constructor TLineRecord.Create(const ModuleName: String; LineNumber: Integer;
                               const Condition: String; PassCount: Integer;
                               LineInfos: TLineInfos);
begin
  Self.ModuleName := ModuleName;
  Self.LineNumber := LineNumber;
  Self.Condition := Condition;
  Self.PassCount := PassCount;
  Self.LineInfos := LineInfos;
end;

procedure ErrMessageBox(const S1, S2: String);
begin
  ShowMessage(Format(S1, [S2]));
end;

procedure Foo;
begin
  ShowMessage('Foo');
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  S: String;
begin
  SignSyntaxCheck := false;

  SearchString := '';
  SearchPos := 1;

  PosList := TObjectList.Create;

  IniFile := TPAXIniFile.Create(ininame);
  S := IniFile['top'];
  if S <> '' then
    Top := StrToInt(S);
  S := IniFile['left'];
  if S <> '' then
    Left := StrToInt(S);
  S := IniFile['width'];
  if S <> '' then
    Width := StrToInt(S);
  S := IniFile['height'];
  if S <> '' then
    HeightOpenProject := StrToInt(S)
  else
  begin
    HeightOpenProject := Height;
    IniFile['height'] := IntToStr(Height);
  end;

  ScriptWasAssigned := false;

  SynPaxPascalSyn1 := TSynPaxPascalSyn.Create(Self);
  SynPaxBasicSyn1 := TSynPaxBasicSyn.Create(Self);
  SynPaxCSyn1 := TSynPaxCSyn.Create(Self);
  SynPaxJavaScriptSyn1 := TSynPaxJavaScriptSyn.Create(Self);

  S := ExtractFileDir(Application.ExeName);
  SetCurrentDir(S);

  OpenDialog1.InitialDir := S;
  SaveDialog1.InitialDir := S;

  ScriptAge := 0;

  LabelBottomLeft.Caption := '';
  LabelBottomCenter.Caption := '';
  LabelBottomRight.Caption := '';

  WatchList := TStringList.Create;

  PageControl2Height := PageControl2.Height;

  CloseProject;

  CompileAndRun := true;

  RegisterClassType(TFormMain, -1);
  PaxScripter1.RegisterObject('FormMain', Self);

  PaxScripter1.AssignEventHandlerRunner(@TFormMain.SpeedButtonRunClick, Self);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  PosList.Free;

  WatchList.Free;

  SynPaxPascalSyn1.Free;
  SynPaxBasicSyn1.Free;
  SynPaxCSyn1.Free;
  SynPaxJavaScriptSyn1.Free;
end;

procedure TFormMain.mExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.mOpenProjectClick(Sender: TObject);
begin
  with OpenDialog1 do
  begin
    Filter := 'PaxScript project file (*' + PaxProject_Ext + '|*' + PaxProject_Ext;
    if Execute then
    begin
      if Pos('.', FileName) = 0 then
        FileName := FileName + PaxProject_Ext;
      OpenNewProject(FileName);
    end;
  end;
end;

procedure TFormMain.EditorGutterClick(Sender: TObject; X, Y, Line: Integer;
  mark: TSynEditMark);
begin
  if CurrentEditor = nil then
    Exit;

  ToggleBreakpoint(CurrentEditor.CaretY);
end;

procedure TFormMain.ToggleBreakpoint(ALine: Integer);
begin
  if CurrentEditor = nil then
    Exit;

  if (ALine >= 1) and (ALine <= CurrentEditor.Lines.Count) then
    CurrentEditor.InvalidateLine(ALine)
  else
    CurrentEditor.Invalidate;

  if PaxScripter1.ScripterState in [ssPaused, ssRunning] then
    AddBreakpoints;  
end;

procedure TFormMain.mAddBreakpointClick(Sender: TObject);
var
  LineRecord: TLineRecord;
  S: String;
  I: Integer;
begin
  if CurrentEditor = nil then
    Exit;

  LineRecord := GetLineRecord(CurrentLineNumber);

  S := CurrentModuleName + ':' + IntToStr(CurrentLineNumber);
  I := ListBoxBreakpoints.Items.IndexOf(S);

  if LineRecord = nil then
  begin
    LineRecord := TLineRecord.Create(CurrentModuleName, CurrentLineNumber,
                                     '', 0, []);
    SetLineRecord(CurrentLineNumber, LineRecord);

    if I = -1 then
      I := ListBoxBreakpoints.Items.Add(S);
  end;

  if dlBreakpointLine in LineRecord.LineInfos then
  begin
    LineRecord.LineInfos := LineRecord.LineInfos - [dlBreakpointLine];
    LineRecord.LineInfos := LineRecord.LineInfos - [dlBadBreakpointLine];

    if I >= 0 then
      ListBoxBreakpoints.Items.Delete(I);
  end
  else if dlBadBreakpointLine in LineRecord.LineInfos then
  begin
    LineRecord.LineInfos := LineRecord.LineInfos - [dlBadBreakpointLine];
    LineRecord.LineInfos := LineRecord.LineInfos - [dlBreakpointLine];

    if I >= 0 then
      ListBoxBreakpoints.Items.Delete(I);
  end
  else
  begin
    LineRecord.LineInfos := LineRecord.LineInfos - [dlBadBreakpointLine];
    LineRecord.LineInfos := LineRecord.LineInfos + [dlBreakpointLine];

    if I = -1 then
      ListBoxBreakpoints.Items.Add(S);
  end;

  ToggleBreakpoint(CurrentLineNumber);
end;

function TFormMain.GetLineInfos(ALine: Integer): TLineInfos;
begin
  Result := [];
  if ALine > 0 then
  begin
    if ALine = CurrentEditor.TraceLine then
      Include(Result, dlTraceLine);
    if IsExecutableLine(ALine) then
      Include(Result, dlExecutableLine);
    if IsBreakpointLine(ALine) then
      Include(Result, dlBreakpointLine);
    if IsBadBreakpointLine(ALine) then
      Include(Result, dlBadBreakpointLine);
    if IsErrorLine(ALine) then
      Include(Result, dlErrorLine);
  end;
end;

procedure TFormMain.EditorSpecialLineColors(Sender: TObject; Line: Integer;
  var Special: Boolean; var FG, BG: TColor);
var
  LI: TLineInfos;
begin
  LI := GetLineInfos(Line);
  if dlTraceLine in LI then
  begin
    Special := TRUE;
    FG := clWhite;
    BG := clBlue;
  end
  else if dlErrorLine in LI then
  begin
    Special := TRUE;
    FG := clBlack;
    BG := clYellow;
  end
  else if dlBadBreakpointLine in LI then
  begin
    Special := TRUE;
    FG := clWhite;
    if dlExecutableLine in LI then
      BG := clGreen
    else
      BG := clGray;
  end
  else if dlBreakpointLine in LI then
  begin
    Special := TRUE;
    FG := clWhite;
    if dlExecutableLine in LI then
      BG := clRed
    else
      BG := clGray;
  end;
end;

procedure TFormMain.SetTraceLine(const ModuleName: String; ALine: integer);
var
  Editor: TEditor;
begin
  if IDEState = ideInit then
    if PaxScripter1.ScripterState <> ssTerminated then
      SetIDEState(idePaused);

  if PaxScripter1.ScripterState = ssTerminated then
    SetIDEState(ideInit);

  ProcessWatches;
  ProcessCallStack;

  Editor := FindEditor(ModuleName);
  if Editor = nil then
    Exit;

  Editor.TraceLine := ALine;

  GoToLine(ModuleName, ALine);
end;

function TFormMain.IsExecutableLine(ALine: integer): boolean;
begin
  result := true;
end;

function TFormMain.IsBreakpointLine(ALine: integer): boolean;
var
  LineRecord: TLineRecord;
begin
  LineRecord := GetLineRecord(ALine);
  if LineRecord = nil then
  begin
    result := false;
    Exit;
  end;
  result := dlBreakpointLine in LineRecord.LineInfos;
end;

function TFormMain.IsBadBreakpointLine(ALine: integer): boolean;
var
  LineRecord: TLineRecord;
begin
  LineRecord := GetLineRecord(ALine);
  if LineRecord = nil then
  begin
    result := false;
    Exit;
  end;
  result := dlBadBreakpointLine in LineRecord.LineInfos;
end;

function TFormMain.IsErrorLine(ALine: integer): boolean;
var
  LineRecord: TLineRecord;
begin
  LineRecord := GetLineRecord(ALine);
  if LineRecord = nil then
  begin
    result := false;
    Exit;
  end;
  result := dlErrorLine in LineRecord.LineInfos;
end;

procedure TFormMain.mNewProjectClick(Sender: TObject);
var
  InputString: String;
begin
  InputString:= InputBox('Input project name', '', '');
  if InputString <> '' then
    CreateNewProject(InputString);
end;

procedure TFormMain.mAddToProjectClick(Sender: TObject);
var
  FileName, ModuleName, LanguageName: String;
  P: Integer;
  L: TPaxLanguage;
begin
  if FormNew.ShowAddToProject = mrOK then
  begin
    LanguageName := FormNew.LanguageName;
    FileName := FormNew.Text;

    L := PaxScripter1.FindLanguage(LanguageName);

    P := Pos('.', FileName);
    if P = 0 then
      FileName := FileName + '.' + L.FileExt;

    ModuleName := FileName;
    AddToProject(ModuleName, FileName, LanguageName);
  end;
end;

procedure TFormMain.mRemoveFromProjectClick(Sender: TObject);
begin
  if FormDelete.ShowModal = mrOK then
  begin
  end;
end;

procedure TFormMain.RunScriptClick(Sender: TObject);
begin
  Trace(rmRun);
end;

procedure TFormMain.mTraceIntoClick(Sender: TObject);
begin
  Trace(rmTraceInto);
end;

procedure TFormMain.mStepOverClick(Sender: TObject);
begin
  Trace(rmStepOver);
end;

procedure TFormMain.mTraceToNextSourceLineClick(Sender: TObject);
begin
  Trace(rmTraceToNextSourceLine);
end;

procedure TFormMain.mRunToCursorClick(Sender: TObject);
begin
  Trace(rmRunToCursor, CurrentModuleName, CurrentLineNumber - 1);
end;

procedure TFormMain.mCompileClick(Sender: TObject);
begin
  CompileAndRun := false;
  PaxScripter1.ScripterState := ssInit;
  PaxScripter1.Compile;
  CompileAndRun := true;

  RebuildCodeExplorerTree;
end;

function TFormMain.FindPage(const ModuleName: String): TTabSheet;
var
  I: Integer;
begin
  result := nil;
  with PageControl1 do
  for I:=PageCount - 1 downto 0 do
    if Pages[I].Caption = ModuleName then
    begin
      result := Pages[I];
      Exit;
    end;
end;

function TFormMain.FindEditor(Page: TTabSheet): TEditor;
begin
  if Page = nil then
    result := nil
  else
    result := TEditor(Page.FindComponent('Editor'));
end;

function TFormMain.FindEditor(const ModuleName: String): TEditor;
var
  Page: TTabSheet;
begin
  Page := FindPage(ModuleName);
  if Page = nil then
    result := nil
  else
    result := TEditor(Page.FindComponent('Editor'));
end;

function TFormMain.CurrentEditor: TEditor;
begin
  result := FindEditor(PageControl1.ActivePage);
end;

function TFormMain.CurrentModuleName: String;
begin
  if Assigned(PageControl1.ActivePage) then
    result := PageControl1.ActivePage.Caption
  else
    result := '';
end;

function TFormMain.CurrentModuleID: Integer;
begin
  if Assigned(PageControl1.ActivePage) then
    result := PageControl1.ActivePageIndex
  else
    result := -1;
end;

function TFormMain.CurrentLineNumber: Integer;
begin
  if CurrentEditor = nil then
    result := -1
  else
    result := CurrentEditor.CaretY;
end;

function TFormMain.CurrentPosNumber: Integer;
begin
  if CurrentEditor = nil then
    result := -1
  else
    result := CurrentEditor.CaretX;
end;

function TFormMain.GetLineRecord(LineNumber: Integer): TLineRecord;
begin
  if CurrentEditor = nil then
    result := nil
  else
    result := TLineRecord(CurrentEditor.Lines.Objects[LineNumber - 1]);
end;

procedure TFormMain.SetLineRecord(LineNumber: Integer; LineRecord: TLineRecord);
begin
  if CurrentEditor = nil then
    Exit;
  if LineNumber < CurrentEditor.Lines.Count then
    CurrentEditor.Lines.Objects[LineNumber - 1] := LineRecord;
end;

procedure TFormMain.UpdateBottomLeftLabel;
begin
  if CurrentLineNumber >= 0 then
    LabelBottomLeft.Caption :=Format('%d : %d', [CurrentLineNumber, CurrentPosNumber])
  else
    LabelBottomLeft.Caption := '';
end;

procedure TFormMain.AddBreakpoints;
var
  I, J: Integer;
  Editor: TEditor;
  LineRecord: TLineRecord;
  Success: Boolean;
begin
  PaxScripter1.RemoveAllBreakpoints;

  with PageControl1 do
  for I:=0 to PageCount - 1 do
  begin
    Editor := FindEditor(Pages[I]);
    if Editor <> nil then
      for J:=0 to Editor.Lines.Count - 1 do
        if Editor.Lines.Objects[J] <> nil then
        begin
          LineRecord := TLineRecord(Editor.Lines.Objects[J]);

          Success := true;
          with PaxScripter1, LineRecord do
            if dlBreakpointLine in LineRecord.LineInfos then
              Success := AddBreakpoint(ModuleName, LineNumber - 1);

          if not Success then
          begin
            LineRecord.LineInfos := LineRecord.LineInfos - [dlBreakpointLine];
            LineRecord.LineInfos := LineRecord.LineInfos + [dlBadBreakpointLine];
          end;
        end;
  end;
end;

procedure TFormMain.RemoveAllBreakpoints;
var
  I: Integer;
  Editor: TEditor;
begin
  PaxScripter1.RemoveAllBreakpoints;
  with PageControl1 do
  for I:=0 to PageCount - 1 do
  begin
    Editor := FindEditor(Pages[I]);
    if Editor <> nil then
      Editor.RemoveLineInfos([dlBreakpointLine, dlBadBreakpointLine]);
  end;
end;

procedure TFormMain.RemoveError;
var
  I: Integer;
  Editor: TEditor;
begin
  PaxScripter1.DiscardError;

  with PageControl1 do
  for I:=0 to PageCount - 1 do
  begin
    Editor := FindEditor(Pages[I]);
    if Editor <> nil then
      Editor.RemoveLineInfos([dlErrorLine]);
  end;

  LabelBottomRight.Caption := '';
end;

function TFormMain.ScriptHasBeenChanged: Boolean;
var
  I: Integer;
  Editor: TEditor;
  ModuleName, S1, S2: String;
begin
  result := false;

  if not ScriptWasAssigned then
    Exit;

  with PageControl1 do
  for I:=0 to PageCount - 1 do
  begin
    ModuleName := Pages[I].Caption;
    if PaxScripter1.Modules.IndexOf(ModuleName) = -1 then
    begin
      result := true;
      Exit;
    end;

    Editor := FindEditor(Pages[I]);
    S1 := Editor.Lines.Text;
    S2 := PaxScripter1.SourceCode[ModuleName];
    if S1 <> S2 then
    begin
      result := true;
      Exit;
    end;
  end;

  for I:=0 to PaxScripter1.Modules.Count - 1 do
  begin
    ModuleName := PaxScripter1.Modules[I];
    if FindEditor(ModuleName) = nil then
    begin
      result := true;
      Exit;
    end;
  end;
end;

procedure TFormMain.EditorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  if PaxScripter1.IsError then
//    RemoveError;
  UpdateBottomLeftLabel;
end;

procedure TFormMain.EditorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if PaxScripter1.IsError then
    RemoveError;
  UpdateBottomLeftLabel;
end;

procedure TFormMain.EditorMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if PaxScripter1.IsError then
    RemoveError;
  UpdateBottomLeftLabel;
end;

procedure TFormMain.PaintGutterGlyphs(ACanvas: TCanvas; AClip: TRect;
  FirstLine, LastLine: integer);
var
  LH, X, Y: integer;
  LI: TLineInfos;
  ImgIndex: integer;
  Editor: TEditor;
begin
  if CurrentEditor = nil then
    Exit;

  Editor := CurrentEditor;

  X := 14;
  LH := Editor.LineHeight;
  Y := (LH - imglGutterGlyphs.Height) div 2
    + LH * (FirstLine - Editor.TopLine);
  while FirstLine <= LastLine do begin
    LI := GetLineInfos(FirstLine);
    if dlTraceLine in LI then begin
      if dlBreakpointLine in LI then
        ImgIndex := 2
      else
        ImgIndex := 1;
    end else if dlExecutableLine in LI then begin
      if dlBreakpointLine in LI then
        ImgIndex := 3
      else
      begin
        if Length(Editor.Lines[FirstLine - 1]) > 0 then
          ImgIndex := 0
        else
          ImgIndex := -1;
      end;
    end else begin
      if dlBreakpointLine in LI then
        ImgIndex := 4
      else
        ImgIndex := -1;
    end;
    if ImgIndex >= 0 then
      imglGutterGlyphs.Draw(ACanvas, X, Y, ImgIndex);
    Inc(FirstLine);
    Inc(Y, LH);
  end;
end;

procedure TFormMain.Trace(RunMode: Integer; const ModuleName: String = ''; ALine: integer = 0);
begin
  if ScriptHasBeenChanged then
    PaxScripter1.ResetScripter;

  PaxScripter1.Run(runMode, ModuleName, ALine);

  if not PaxScripter1.IsError then
    SetTraceLine(PaxScripter1.CurrentModuleName, PaxScripter1.CurrentSourceLine + 1);
end;

procedure TFormMain.RemoveTraceLine;
var
  I: Integer;
  Editor: TEditor;
begin
  for I:=0 to PageControl1.PageCount - 1 do
  begin
    Editor := FindEditor(PageControl1.Pages[I]);
    if Editor <> nil then
    begin
      Editor.TraceLine := -1;
      Editor.Invalidate;
    end;
  end;
end;

procedure TFormMain.ProcessWatches;
var
  I: Integer;
  Res: Variant;
begin
  for I:=0 to WatchList.Count - 1 do
    if PaxScripter1.ScripterState = ssPaused then
    begin
      if PaxScripter1.Eval(WatchList[I], LanguageName, Res) then
        ListBoxWatches.Items[I] := WatchList[I] + ':' + PaxScripter1.ToString(Res)
      else
        ListBoxWatches.Items[I] := WatchList[I] + ':[not accessible]';
    end
    else
      ListBoxWatches.Items[I] := WatchList[I] + ':[not accessible]';
end;

procedure TFormMain.ProcessCallStack;
var
  I, J: Integer;
  S: String;
begin
  ListBoxCallStack.Clear;

  for I:=0 to PaxScripter1.CallStack.Count - 1 do
  begin
    with PaxScripter1.CallStack.Records[I] do
    begin
      S := ProcName + '(';
      for J:=0 to Parameters.Count - 1 do
      begin
        S := S + Parameters[J];
        if J < Parameters.Count - 1 then
          S := S + ',';
      end;
      S := S + ')';
    end;
    ListBoxCallStack.Items.Add(S);
  end;
end;

procedure TFormMain.ListBoxCallStackDblClick(Sender: TObject);
var
  I, LineNumber: Integer;
  ModuleName: String;
  Editor: TEditor;
begin
  I := ListBoxCallStack.ItemIndex;
  if I >= 0 then
  begin
    LineNumber := PaxScripter1.CallStack.Records[I].LineNumber;
    ModuleName := PaxScripter1.CallStack.Records[I].ModuleName;
    Editor := GoToLine(ModuleName, LineNumber + 1);
    Editor.SetFocus;
  end;
end;

procedure TFormMain.mProgramResetClick(Sender: TObject);
begin
  BringToFront;
  RemoveTraceLine;
  RemoveError;

  PaxScripter1.ScripterState := ssReadyToCompile;

  SetIDEState(ideInit);
end;

function TFormMain.LanguageName: String;
begin
  result := PaxScripter1.FileExtToLanguageName(CurrentModuleName);
end;

procedure TFormMain.ListBoxWatchesKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  S: String;
  Index: Integer;
begin
{$IFDEF LINUX}
  if Key = Key_Insert then
{$ELSE}
  if Key = vk_Insert then
{$ENDIF}
  begin
    S := InputBox('Input expression', '', '');
    if S <> '' then
    begin
      WatchList.Add(S);
      ListBoxWatches.Items.Add(S);
      ProcessWatches;
    end;
  end
{$IFDEF LINUX}
  else if Key = Key_Delete then
{$ELSE}
  else if Key = vk_Delete then
{$ENDIF}
  begin
    Index := ListBoxWatches.ItemIndex;
    if Index <> - 1 then
    begin
      WatchList.Delete(Index);
      ListBoxWatches.Items.Delete(Index);
    end;
  end;
end;

function TFormMain.GotoLine(const ModuleName: String; LineNumber: Integer): TEditor;
var
  TabSheet: TTabSheet;
begin
  result := nil;

  TabSheet := FindPage(ModuleName);
  if TabSheet = nil then
    Exit;

  PageControl1.ActivePage := TabSheet;

  result := FindEditor(TabSheet);
  if result = nil then
    Exit;

  result.CaretXY := Point(1, LineNumber);
  result.InvalidateLine(LineNumber);
end;

procedure TFormMain.AddToProject(const ModuleName, FileName, LanguageName: String);
var
  TabSheet: TTabSheet;
  Editor: TEditor;
begin
  TabSheet := TTabSheet.Create(PageControl1);
  TabSheet.PageControl := PageControl1;
  TabSheet.Caption := ModuleName;

  Editor := TEditor.Create(TabSheet);
  Editor.Name := 'Editor';
  Editor.Parent := TabSheet;
  Editor.Align := alClient;

  Editor.OnGutterClick := EditorGutterClick;
  Editor.OnSpecialLineColors := EditorSpecialLineColors;
  Editor.OnKeyUp := EditorKeyUp;
  Editor.OnMouseUp := EditorMouseUp;
  Editor.OnMouseDown := EditorMouseDown;

  if LanguageName = 'paxBasic' then
    Editor.Highlighter := SynPaxBasicSyn1
  else if LanguageName = 'paxC' then
    Editor.Highlighter :=  SynPaxCSyn1
  else if LanguageName = 'paxPascal' then
    Editor.Highlighter := SynPaxPascalSyn1
  else
    Editor.Highlighter := SynPaxJavaScriptSyn1;

  FormDelete.ListBox1.Items.Add(ModuleName);

  if FileExists(FileName) then
  begin
    Editor.Lines.LoadFromFile(FileName);
    Editor.Modified := false;
  end;

  TDebugSupportPlugin.Create(Editor);
end;

procedure TFormMain.OpenNewProject(const FileName: String);
var
  L: TStringList;
  I: Integer;
  ModuleName, LanguageName, FullName: String;
begin
  if IDEState <> ideNoProject then
    HeightOpenProject := Height;

  ScriptWasAssigned := false;

  CloseProject;

  ProjectName := FileName;
  if FileExists(FileName) then
  begin
    L := TStringList.Create;
    try
      L.LoadFromFile(FileName);
      for I:=0 to L.Count - 1 do
      if Pos('#', L[I]) = 0 then
      begin
        ModuleName := L[I];
        LanguageName := PaxScripter1.FileExtToLanguageName(L[I]);

        FullName := PaxScripter1.FindFullFileName(L[I]);

        if FileExists(FullName) then
          AddToProject(ModuleName, FullName, LanguageName)
        else
        begin
          ErrMessageBox('File %s not found !', L[I]);
          CloseProject;
          Exit;
        end;
      end;

      SignSyntaxCheck := true;
      PaxScripter1.Compile(true);
      SignSyntaxCheck := false;
      RebuildCodeExplorerTree;

      PaxScripter1.ScripterState := ssInit;
    finally
      L.Free;
    end;
  end;
  SetIDEState(ideInit);
end;

procedure TFormMain.CreateNewProject(const FileName: String);
begin
  ProjectName := FileName;
  if Pos(UpperCase(paxProject_Ext), UpperCase(ProjectName)) = 0 then
    ProjectName := ProjectName + paxProject_Ext;

  if FileExists(ProjectName) then
{$IFDEF LINUX}
    if Application.MessageBox(PChar('Project ' + ProjectName + ' already exists. Recreate?'),
            'Confirm', [smbYES, smbNO]) = smbNO then
{$ELSE}
    if Application.MessageBox(PChar('Project ' + ProjectName + ' already exists. Recreate?'),
            'Confirm', MB_ICONQUESTION or MB_YESNO) = IDNO then
{$ENDIF}
    begin
      OpenNewProject(ProjectName);
      Exit;
    end;

  CloseProject;

  SetIDEState(ideInit);

  with TreeView1.Items do
  begin
    Clear; { remove any existing nodes }
  end;

  FormNew.Edit1.Text := ProjectName;

  mAddToProjectClick(nil);
end;

procedure TFormMain.CloseProject;
var
  I: Integer;
begin
  RemoveError;

  with PageControl1 do
  for I:=PageCount - 1 downto 0 do
  begin
    RemoveComponent(Pages[I]);
    Pages[I].Free;
  end;

  if FormDelete <> nil then
    FormDelete.ListBox1.Items.Clear; 

  PaxScripter1.ResetScripter;
  SetIDEState(ideNoProject);
end;

procedure TFormMain.SetIDEState(IDEState: TIDEState);
var
  Temp: Integer;
begin
  Self.IDEState := IDEState;
  case IDEState of
    ideNoProject:
    begin
      Height := HeightNoProject;

      mFile.Enabled := true;
      mOpenProject.Enabled := true;
      mNewProject.Enabled := true;
      mSave.Enabled := false;

      mEdit.Enabled := false;

      mRun.Enabled := false;
      mProject.Enabled := false;
      mClose.Enabled := false;

      SpeedButtonNew.Enabled := true;
      SpeedButtonOpen.Enabled := true;
      SpeedButtonSave.Enabled := false;
      SpeedButtonAdd.Enabled := false;
      SpeedButtonRemove.Enabled := false;
      SpeedButtonRun.Enabled := false;
      SpeedButtonTraceInto.Enabled := false;
      SpeedButtonStepOver.Enabled := false;
    end;
    ideInit:
    begin
{$IFNDEF LINUX}
      FormConsole.ManualDock(nil);
{$ENDIF}

      Height := HeightOpenProject;
      PageControl2.Height := 0;

      mEdit.Enabled := true;

      mRun.Enabled := true;
      mProject.Enabled := true;
      mClose.Enabled := true;
      mSave.Enabled := true;

      SpeedButtonNew.Enabled := true;
      SpeedButtonOpen.Enabled := true;
      SpeedButtonSave.Enabled := true;
      SpeedButtonAdd.Enabled := true;
      SpeedButtonRemove.Enabled := true;
      SpeedButtonRun.Enabled := true;
      SpeedButtonTraceInto.Enabled := true;
      SpeedButtonStepOver.Enabled := true;
    end;
    idePaused:
    begin
      HeightOpenProject := Height;

      Temp := PanelBottom.Height;
      PanelBottom.Height := 0;
      PageControl2.Align := alNone;
      PageControl2.Height := PageControl2Height;
      PanelBottom.Height := Temp;
      PageControl2.Align := alBottom;

      mOpenProject.Enabled := false;
      mNewProject.Enabled := false;
      mSave.Enabled := false;

      mProject.Enabled := false;

      mRun.Enabled := true;

      SpeedButtonNew.Enabled := false;
      SpeedButtonOpen.Enabled := false;
      SpeedButtonSave.Enabled := false;
      SpeedButtonAdd.Enabled := false;
      SpeedButtonRemove.Enabled := false;
      SpeedButtonRun.Enabled := true;
      SpeedButtonTraceInto.Enabled := true;
      SpeedButtonStepOver.Enabled := true;
    end;
  end;
  Self.IDEState := IDEState;
end;

procedure TFormMain.mCloseClick(Sender: TObject);
begin
  CloseProject;
end;

procedure TFormMain.mSaveClick(Sender: TObject);
begin
  SaveProject;
end;

procedure TFormMain.SpeedButtonNewClick(Sender: TObject);
begin
  mNewProjectClick(Sender);
end;

procedure TFormMain.SpeedButtonOpenClick(Sender: TObject);
begin
  mOpenProjectClick(Sender);
end;

procedure TFormMain.SpeedButtonSaveClick(Sender: TObject);
begin
  mSaveClick(Sender);
end;

procedure TFormMain.SpeedButtonAddClick(Sender: TObject);
begin
  mAddToProjectClick(Sender);
end;

procedure TFormMain.SpeedButtonRemoveClick(Sender: TObject);
begin
  mRemoveFromProjectClick(Sender);
end;

procedure TFormMain.SpeedButtonRunClick(Sender: TObject);
begin
  Trace(rmRun);
end;

procedure TFormMain.SpeedButtonTraceIntoClick(Sender: TObject);
begin
  Trace(rmTraceInto);
end;

procedure TFormMain.SpeedButtonStepOverClick(Sender: TObject);
begin
  Trace(rmStepOver);
end;

procedure TFormMain.SpeedButtonHelpClick(Sender: TObject);
begin
  OnlineHelp1Click(Sender);
end;

procedure TFormMain.mAboutClick(Sender: TObject);
begin
  FormAbout.ShowModal;
end;

procedure TFormMain.mRemoveAllBreakpointsClick(Sender: TObject);
begin
  RemoveAllBreakpoints;
  ListBoxBreakpoints.Clear;
end;

procedure TFormMain.RemoveFromProject(const ModuleName: String);
var
  I: Integer;
  L: TStringList;
begin
  with PageControl1 do
  for I:=0 to PageCount - 1 do
    if Pages[I].Caption = ModuleName then
    begin
      RemoveComponent(Pages[I]);
      Pages[I].Free;
      Break;
    end;

  if FileExists(ProjectName) then
  begin
    L := TStringList.Create;
    try
      L.LoadFromFile(ProjectName);
      for I:=0 to L.Count - 1 do
        if L[I] = ModuleName then
        begin
          L.Delete(I);
          L.SaveToFile(ProjectName);
          Break;
        end;
    finally
      L.Free;
    end;
  end;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ScriptHasBeenChanged then
  begin
{$IFDEF LINUX}
     if Application.MessageBox(PChar('Save changes to ' + ProjectName + '?'),
           'Confirm', [smbYES, smbNO] ) = smbYES then
{$ELSE}
     if Application.MessageBox(PChar('Save changes to ' + ProjectName + '?'),
           'Confirm', MB_ICONQUESTION or MB_YESNO ) = IDYES then
{$ENDIF}
     SaveProject;
  end;
  IniFile['top'] := IntToStr(Top);
  IniFile['left'] := IntToStr(Left);
  IniFile['height'] := IntToStr(HeightOpenProject);
  IniFile['width'] := IntToStr(Width);
  IniFile.Free;
end;

procedure TFormMain.SaveProject;
var
  T: TextFile;
  I: Integer;
  Editor: TEditor;
  S: String;
begin
  S := '';
  if FileExists(ProjectName) then
  begin
    AssignFile(T, ProjectName);
    Reset(T);
    try
      readln(T, S);
      if Pos('#', S) = 0 then
        S := '';
    finally
      CloseFile(T);
    end;
  end;

  AssignFile(T, ProjectName);
  Rewrite(T);
  try
    if S <> '' then
      writeln(T, S);

    for I:=0 to ModuleCount - 1 do
    begin
      writeln(T, ModuleNames[I]);
      Editor := FindEditor(ModuleNames[I]);
      if Editor <> nil then
      begin
        S := ModuleNames[I];
        if Pos(PathDelim, S) > 0 then
          S := PaxScripter1.FindFullFileName(S);
        Editor.Lines.SaveToFile(S);
      end;
    end;
  finally
    CloseFile(T);
  end;
end;

procedure TFormMain.ShowError(Sender: TPaxScripter);
var
  Description, ModuleName: String;
  TextPosition: Integer;
  Editor: TEditor;
  TabSheet: TTabSheet;
  LineRecord: TLineRecord;
begin
  BringToFront;

  Description := Sender.ErrorDescription;
  ModuleName := Sender.ErrorModuleName;
  TextPosition := Sender.ErrorTextPos;

  TabSheet := FindPage(ModuleName);
  if TabSheet <> nil then
  begin
    PageControl1.ActivePage := TabSheet;
    Editor := FindEditor(TabSheet);
    Editor.SelStart := TextPosition;
    Editor.SelEnd := TextPosition;
    Editor.SetFocus;
  end
  else
    Exit;

  LineRecord := GetLineRecord(CurrentLineNumber);

  if LineRecord = nil then
  begin
    LineRecord := TLineRecord.Create(CurrentModuleName, CurrentLineNumber,
                                     '', 0, [dlErrorLine]);
    SetLineRecord(CurrentLineNumber, LineRecord);
    Editor.Invalidate;
  end
  else
    LineRecord.LineInfos := LineRecord.LineInfos + [dlErrorLine];

  LabelBottomRight.Caption := 'Error: ' + Description;
end;

procedure TFormMain.mUndoClick(Sender: TObject);
begin
  CurrentEditor.Undo;
end;

procedure TFormMain.mRedoClick(Sender: TObject);
begin
  CurrentEditor.Redo;
end;

procedure TFormMain.mCutClick(Sender: TObject);
begin
  CurrentEditor.CutToClipboard;
end;

procedure TFormMain.mCopyClick(Sender: TObject);
begin
  CurrentEditor.CopyToClipboard;
end;

procedure TFormMain.mPasteClick(Sender: TObject);
begin
  CurrentEditor.PasteFromClipboard;
end;

procedure TFormMain.mDeleteClick(Sender: TObject);
begin
  CurrentEditor.SelText := '';
end;

procedure TFormMain.mSelectAllClick(Sender: TObject);
begin
  CurrentEditor.SelectAll;
end;

procedure TFormMain.PaxScripter1ShowError(Sender: TPaxScripter);
begin
  ShowError(Sender);
end;

procedure AssignLabel(L: TLabel; const S: String);
begin
  if L.Caption <> S then
    L.Caption := S;
end;

procedure TFormMain.PaxScripter1Print(Sender: TPaxScripter; const S: String);
var
  K: Integer;
begin
  FormConsole.Show;
  K := FormConsole.Memo1.Lines.Count;
  if K = 0 then
    FormConsole.Memo1.Lines.Add(S)
  else
    FormConsole.Memo1.Lines[K-1] := FormConsole.Memo1.Lines[K-1] + S;
end;

procedure TFormMain.PaxScripter1BeforeRunStage(Sender: TPaxScripter);
begin
  if PaxScripter1.IsError then
    RemoveError;

  SaveProject;
  RemoveTraceLine;
  UpdateLineNumbers;
  AddBreakpoints;

  RebuildCodeExplorerTree;
end;

procedure TFormMain.PaxScripter1BeforeCompileStage(Sender: TPaxScripter);
begin
  if SignSyntaxCheck then
    Exit;

  AssignLabel(Compiling.LabelProject, 'Project: ' + ProjectName);
  Compiling.BeginCompiling;
  Compiling.Show;
end;

procedure TFormMain.PaxScripter1AssignScript(Sender: TPaxScripter);
var
  I: Integer;
  ModuleName, LanguageName: String;
begin
  ScriptWasAssigned := true;

  with PageControl1 do
    for I:=0 to PageCount - 1 do
    begin
      ModuleName := Pages[I].Caption;
      LanguageName := PaxScripter1.FileExtToLanguageName(ModuleName);
      PaxScripter1.AddModule(ModuleName, LanguageName);
      PaxScripter1.AddCode(ModuleName, FindEditor(Pages[I]).Text);
    end;
end;

procedure TFormMain.UpdateLineNumbers;
var
  I, J: Integer;
  Editor: TEditor;
  LR: TLineRecord;
begin
  with PageControl1 do
    for I:=0 to PageCount - 1 do
    begin
      Editor := FindEditor(Pages[I]);
      if Editor = nil then
        Continue;
      for J:=0 to Editor.Lines.Count - 1 do
      begin
        LR := TLineRecord(Editor.Lines.Objects[J]);
        if LR <> nil then
          LR.LineNumber := J + 1;
      end;
    end;
end;

procedure TFormMain.PaxScripter1CompilerProgress(Sender: TPaxScripter;
  ModuleNumber: Integer);
begin
  if SignSyntaxCheck then
    Exit;

  Application.ProcessMessages;
  AssignLabel(Compiling.LabelStatus, 'Compiling: ' + PaxScripter1.CurrentModuleName);
  AssignLabel(Compiling.LabelCurrLineNumber, IntToStr(PaxScripter1.CurrentSourceLine));
  AssignLabel(Compiling.LabelTotalLinesCount, IntToStr(PaxScripter1.TotalLineCount));
  AssignLabel(Compiling.LabelError, '');
end;

procedure TFormMain.PaxScripter1AfterCompileStage(Sender: TPaxScripter);
var
  I, K: Integer;
  M: TPaxModule;
begin
  if SignSyntaxCheck then
    Exit;

  K := PaxScripter1.Modules.Count;
  if K > ModuleCount then
  for I:= ModuleCount to K - 1 do
  begin
    M := PaxScripter1.GetPaxModule(I);
    AddToProject(M.Name,
                 M.FileName,
                 M.LanguageName);
  end;

  Compiling.EndCompiling;

  if CompileAndRun and (not PaxScripter1.IsError) then
  begin
    Compiling.Hide;
    Exit;
  end;

  if PaxScripter1.IsError then
  begin
    AssignLabel(Compiling.LabelStatus, 'Done: There are errors');
    AssignLabel(Compiling.LabelError, PaxScripter1.ErrorDescription);
  end
  else
  begin
    AssignLabel(Compiling.LabelStatus, 'Done');
    AssignLabel(Compiling.LabelError, 'Successful');
  end;

  Compiling.Hide;
  Compiling.ShowModal;
end;

procedure TFormMain.OnlineHelp1Click(Sender: TObject);
var
  S: String;
begin
  S := GetCurrentDir + helpsite;
{$IFNDEF LINUX}
  ShellExecute(Handle , 'open', PChar(S), nil, nil, SW_MAXIMIZE);
{$ENDIF}
end;

function TFormMain.ModuleCount: Integer;
begin
  result := PageControl1.PageCount;
end;

function TFormMain.GetModName(Index: Integer): String;
begin
  if (ModuleCount > 0) and (Index < ModuleCount) then
    result := PageControl1.Pages[Index].Caption
  else
    result := '';
end;

procedure TFormMain.ListBoxBreakpointsDblClick(Sender: TObject);
var
  I: Integer;
  S, ModName: String;
begin
  I := ListBoxBreakpoints.ItemIndex;
  if I = -1 then
    Exit;
  S := ListBoxBreakpoints.Items[I];
  ModName := Copy(S, 1, Pos(':', S) - 1);
  I := StrToInt(Copy(S, Pos(':', S) + 1, Length(S)));
  GotoLine(ModName, I);
end;

procedure TFormMain.PaxScriptHomePage1Click(Sender: TObject);
begin
{$IFNDEF LINUX}
  ShellExecute(Handle , 'open', PChar(paxsite), nil, nil, SW_MAXIMIZE);
{$ENDIF}
end;

procedure TFormMain.AddWatch1Click(Sender: TObject);
var
  S: String;
begin
  S := InputBox('Input expression', '', '');
  if S <> '' then
  begin
    WatchList.Add(S);
    ListBoxWatches.Items.Add(S);
    ProcessWatches;
  end;
end;

procedure TFormMain.mConsoleClick(Sender: TObject);
begin
  FormConsole.Show;
end;

procedure TFormMain.ViewSource1Click(Sender: TObject);
var
  F: TForm;
  M: TMemo;
begin
  if not FileExists(ProjectName) then
    raise Exception.Create('Cannot open '+ProjectName);
  F := TForm.Create(Self);
  F.Left := 200;
  F.Top := 100;
  M := TMemo.Create(F);
  M.Parent := F;
  M.Align := alClient;
  M.Lines.LoadFromFile(ProjectName);
  F.ShowModal;
  M.Lines.SaveToFile(ProjectName);
end;

// Code explorer - start

procedure TFormMain.SetupClassNode(N: TTreeNode; ID: Integer);
var
  R: TNodeRec;
begin
  with TreeView1.Items do
  begin
    with R do
    begin
      NConsts := AddChild(N, 'Constants');
      NFields := AddChild(N, 'Fields');
      NMethods := AddChild(N, 'Methods');
      NProperties := AddChild(N, 'Properties');
      NClasses := AddChild(N, 'Classes');
      NStructures := AddChild(N, 'Structures');
      NEnums := AddChild(N, 'Enums');
    end;

    PaxScripter1.EnumMembers(ID, CurrentModuleID, EnumProc, @R);

    with R do
    begin
      if NConsts.Count = 0 then
        NConsts.Delete;
      if NFields.Count = 0 then
        NFields.Delete;
      if NMethods.Count = 0 then
        NMethods.Delete;
      if NProperties.Count = 0 then
        NProperties.Delete;
      if NClasses.Count = 0 then
        NClasses.Delete;
      if NStructures.Count = 0 then
        NStructures.Delete;
      if NEnums.Count = 0 then
        NEnums.Delete;
    end;
  end;
end;

procedure TFormMain.SetupFuncNode(N: TTreeNode; ID: Integer);
var
  R: TNodeRec;
begin
  with TreeView1.Items do
  begin
    with R do
    begin
      NParams := AddChild(N, 'Parameters');
      NConsts := AddChild(N, 'Constants');
      NFields := AddChild(N, 'Local variables');
      NMethods := AddChild(N, 'Methods');
      NClasses := AddChild(N, 'Classes');
      NStructures := AddChild(N, 'Structures');
      NEnums := AddChild(N, 'Enums');
    end;

    PaxScripter1.EnumMembers(ID, CurrentModuleID, EnumProc, @R);

    with R do
    begin
      if NParams.Count = 0 then
        NParams.Delete;
      if NConsts.Count = 0 then
        NConsts.Delete;
      if NFields.Count = 0 then
        NFields.Delete;
      if NMethods.Count = 0 then
        NMethods.Delete;
      if NClasses.Count = 0 then
        NClasses.Delete;
      if NStructures.Count = 0 then
        NStructures.Delete;
      if NEnums.Count = 0 then
        NEnums.Delete;
    end;
  end;
end;

procedure TFormMain.EnumProc(const Name: String;
                          ID: Integer;
                          Kind: TPAXMemberKind;
                          ml: TPAXModifierList;
                          Data: Pointer);
var
  P: PNodeRec;
  TypeName: String;
  PosObject: TPosObject;
begin
  with PaxScripter1 do
    PosObject := TPosObject.Create(GetModule(ID),
                                   GetPosition(ID),
                                   Length(GetName(ID)));
  PosList.Add(PosObject);

  P := PNodeRec(Data);

  with PaxScripter1 do
    TypeName := GetName(GetTypeID(ID));

  with TreeView1.Items do
  case Kind of
    mkParam: AddChildObject(P^.NParams, Name + ': ' + TypeName, PosObject);
    mkField: AddChildObject(P^.NFields, Name + ': ' + TypeName, PosObject);
    mkMethod: SetupFuncNode(AddChildObject(P^.NMethods, Name, PosObject), ID);
    mkConst: AddChildObject(P^.NConsts, Name + ': ' + TypeName, PosObject);
    mkClass: SetupClassNode(AddChildObject(P^.NClasses, Name, PosObject), ID);
    mkStructure: SetupClassNode(AddChildObject(P^.NStructures, Name, PosObject), ID);
    mkEnum: SetupClassNode(AddChildObject(P^.NEnums, Name, PosObject), ID);
    mkProp: AddChildObject(P^.NProperties, Name  + ': ' + TypeName, PosObject);
  end;
end;

procedure TFormMain.RebuildCodeExplorerTree;
begin
  with TreeView1.Items do
  begin
    Clear;
    SetupClassNode(Add(nil, 'NonameNamespace'), PaxScripter1.GetRootID);
  end;
end;

procedure TFormMain.TreeView1DblClick(Sender: TObject);
var
  N: TTreeNode;
  PosObject: TPosObject;
begin
  if CurrentEditor = nil then
    Exit;

  N := TTreeView(Sender).Selected;
  if N = nil then
    Exit;

  PosObject := TPosObject(N.Data);

  if PosObject <> nil then
    if PosObject.Module = CurrentModuleID then
      if PosObject.Position >= 0 then
    with CurrentEditor do
    begin
      SetFocus;
      SelStart := PosObject.Position + 1;
//      SelLength := PosObject.Length;
    end;
end;

procedure TFormMain.TreeView1Click(Sender: TObject);
begin
  TreeView1DblClick(Sender);
end;

procedure TFormMain.PageControl1Change(Sender: TObject);
begin
  RebuildCodeExplorerTree;
end;

// Code explorer - end


procedure TFormMain.Find1Click(Sender: TObject);
var
  S: String;
  L, LS: Integer;
begin
  if CurrentEditor = nil then
    Exit;

  SearchString := InputBox('Text to find', '', SearchString);
  SearchAgain1Click(Sender);
end;

procedure TFormMain.SearchAgain1Click(Sender: TObject);
var
  S, SS: String;
  L, LS: Integer;
begin
  if CurrentEditor = nil then
    Exit;

  L := Length(SearchString);
  S := UpperCase(CurrentEditor.Lines.Text);
  SS := UpperCase(SearchString);
  LS := Length(S);

  while SearchPos < LS do
  begin
    if Copy(S, SearchPos, L) = SS then
    begin
      with CurrentEditor do
      begin
        SetFocus;
        SelStart := SearchPos;
      end;
      Inc(SearchPos);
      Exit;
    end;
    Inc(SearchPos);
  end;
  SearchPos := 1;
  ShowMessage('Search string ' + SearchString + ' not found.');
end;

initialization
  RegisterConstant('PAX_SELF', ParamStr(0), -1);
end.

