{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: SynHighlighterVBScript.pas, released 2000-04-18.
The Original Code is based on the lbVBSSyn.pas file from the
mwEdit component suite by Martin Waldenburg and other developers, the Initial
Author of this file is Luiz C. Vaz de Brito.
All Rights Reserved.

Contributors to the SynEdit and mwEdit projects are listed in the
Contributors.txt file.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

$Id: SynHighlighterVBScript.pas,v 1.10 2001/12/12 19:41:36 harmeister Exp $

You may retrieve the latest version of this file at the SynEdit home page,
located at http://SynEdit.SourceForge.net

Known Issues:
-------------------------------------------------------------------------------}
{
@abstract(Provides a VBScript highlighter for SynEdit)
@author(Luiz C. Vaz de Brito, converted to SynEdit by David Muir <david@loanhead45.freeserve.co.uk>)
@created(20 January 1999, converted to SynEdit April 18, 2000)
@lastmod(2000-06-23)
The SynHighlighterVBScript unit provides SynEdit with a VisualBasic Script (.vbs) highlighter.
Thanks to Primoz Gabrijelcic and Martin Waldenburg.
}
unit SynHighlighterPaxBasic;

{$I SynEdit.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF SYN_CLX}
  Qt, QControls, QGraphics,
  {$ELSE}
  Windows, Messages, Controls, Graphics, Registry,
  {$ENDIF}
  SynEditHighlighter, SynEditTypes;

type
  TtkTokenKind = (tkComment, tkIdentifier, tkKey, tkNull, tkNumber, tkSpace,
    tkString, tkSymbol, tkUnknown);

  TProcTableProc = procedure of object;

  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  TIdentFuncTableFunc = function: TtkTokenKind of object;

type
  TSynPaxBasicSyn = class(TSynCustomHighLighter)
  private
    fLine: PChar;
    fLineNumber: Integer;
    fProcTable: array[#0..#255] of TProcTableProc;
    Run: LongInt;
    fStringLen: Integer;
    fToIdent: PChar;
    fTokenPos: Integer;
    FTokenID: TtkTokenKind;
    fCommentAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fStringAttri: TSynHighlighterAttributes;
    fSymbolAttri: TSynHighlighterAttributes;
    fIdentFuncTable: array[0..133] of TIdentFuncTableFunc;
    function KeyHash(ToHash: PChar): Integer;
    function KeyComp(const aKey: String): Boolean;
    function Func15: TtkTokenKind;
    procedure ApostropheProc;
    procedure CRProc;
    procedure DateProc;
    procedure GreaterProc;
    procedure IdentProc;
    procedure LFProc;
    procedure LowerProc;
    procedure NullProc;
    procedure NumberProc;
    procedure SpaceProc;
    procedure StringProc;
    procedure SymbolProc;
    procedure UnknownProc;
    function AltFunc: TtkTokenKind;
    procedure InitIdent;
    function IdentKind(MayBe: PChar): TtkTokenKind;
    procedure MakeMethodTables;
  protected
    function GetIdentChars: TSynIdentChars; override;
    function GetSampleSource: string; override;
  public
    {$IFNDEF SYN_CPPB_1} class {$ENDIF}
    function GetLanguageName: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes;
      override;
    function GetEol: Boolean; override;
    function GetTokenID: TtkTokenKind;
    procedure SetLine(NewValue: String; LineNumber:Integer); override;
    function GetToken: String; override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: integer; override;
    function GetTokenPos: Integer; override;
    procedure Next; override;
  published
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri
      write fCommentAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri
      write fIdentifierAttri;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri
      write fNumberAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri
      write fSpaceAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri
      write fStringAttri;
    property SymbolAttri: TSynHighlighterAttributes read fSymbolAttri
      write fSymbolAttri;
  end;

implementation

uses
  SynEditStrConst;

var
  Identifiers: array[#0..#255] of ByteBool;
  mHashTable: array[#0..#255] of Integer;

  PaxBasicKeywords: TStringList;

procedure MakeIdentTable;
var
  I, J: Char;
begin
  for I := #0 to #255 do
  begin
    Case I of
      '_', '0'..'9', 'a'..'z', 'A'..'Z': Identifiers[I] := True;
    else Identifiers[I] := False;
    end;
    J := UpCase(I);
    Case I in['_', 'a'..'z', 'A'..'Z'] of
      True: mHashTable[I] := Ord(J) - 64
    else mHashTable[I] := 0;
    end;
  end;
end;

procedure TSynPaxBasicSyn.InitIdent;
var
  I: Integer;
  pF: PIdentFuncTableFunc;
begin
  pF := PIdentFuncTableFunc(@fIdentFuncTable);
  for I := Low(fIdentFuncTable) to High(fIdentFuncTable) do begin
    pF^ := AltFunc;
    Inc(pF);
  end;
  fIdentFuncTable[15] := Func15;
end;

function TSynPaxBasicSyn.KeyHash(ToHash: PChar): Integer;
begin
  while ToHash^ in ['_', '0'..'9', 'a'..'z', 'A'..'Z'] do
    inc(ToHash);
  fStringLen := ToHash - fToIdent;

  result := 15;
end; { KeyHash }

function TSynPaxBasicSyn.KeyComp(const aKey: String): Boolean;
var
  I: Integer;
  Temp: PChar;
begin
  Temp := fToIdent;
  if Length(aKey) = fStringLen then
  begin
    Result := True;
    for i := 1 to fStringLen do
    begin
      if mHashTable[Temp^] <> mHashTable[aKey[i]] then
      begin
        Result := False;
        break;
      end;
      inc(Temp);
    end;
  end else Result := False;
end; { KeyComp }

function TSynPaxBasicSyn.Func15: TtkTokenKind;
var
  I: Integer;
begin
  result := tkIdentifier;
  for I:=0 to PaxBasicKeywords.Count - 1 do
    if KeyComp(PaxBasicKeywords[I]) then
    begin
      Result := tkKey;
      Exit;
    end;
end;

function TSynPaxBasicSyn.AltFunc: TtkTokenKind;
begin
  Result := tkIdentifier;
end;

function TSynPaxBasicSyn.IdentKind(MayBe: PChar): TtkTokenKind;
var
  HashKey: Integer;
begin
  fToIdent := MayBe;
  HashKey := KeyHash(MayBe);
  if HashKey < 134 then
    Result := fIdentFuncTable[HashKey]
  else
    Result := tkIdentifier;
end;

procedure TSynPaxBasicSyn.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
      #39: fProcTable[I] := ApostropheProc;
      #13: fProcTable[I] := CRProc;
      '#': fProcTable[I] := DateProc;
      '>': fProcTable[I] := GreaterProc;
      'A'..'Z', 'a'..'z', '_': fProcTable[I] := IdentProc;
      #10: fProcTable[I] := LFProc;
      '<': fProcTable[I] := LowerProc;
      #0: fProcTable[I] := NullProc;
      '0'..'9': fProcTable[I] := NumberProc;
      #1..#9, #11, #12, #14..#32: fProcTable[I] := SpaceProc;
      #34: fProcTable[I] := StringProc;
      '&', '{', '}', ':', ',', '=', '^', '-',
      '+', '.', '(', ')', ';', '/', '*': fProcTable[I] := SymbolProc;
    else
      fProcTable[I] := UnknownProc;
    end;
end;

constructor TSynPaxBasicSyn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrComment);
  fCommentAttri.Style := [fsItalic];
  AddAttribute(fCommentAttri);
  fIdentifierAttri := TSynHighlighterAttributes.Create(SYNS_AttrIdentifier);
  AddAttribute(fIdentifierAttri);
  fKeyAttri := TSynHighlighterAttributes.Create(SYNS_AttrReservedWord);
  fKeyAttri.Style := [fsBold];
  AddAttribute(fKeyAttri);
  fNumberAttri := TSynHighlighterAttributes.Create(SYNS_AttrNumber);
  AddAttribute(fNumberAttri);
  fSpaceAttri := TSynHighlighterAttributes.Create(SYNS_AttrSpace);
  AddAttribute(fSpaceAttri);
  fStringAttri := TSynHighlighterAttributes.Create(SYNS_AttrString);
  AddAttribute(fStringAttri);
  fSymbolAttri := TSynHighlighterAttributes.Create(SYNS_AttrSymbol);
  AddAttribute(fSymbolAttri);
  SetAttributesOnChange(DefHighlightChange);
  fDefaultFilter      := SYNS_FilterVBScript;
  InitIdent;
  MakeMethodTables;
end;

procedure TSynPaxBasicSyn.SetLine(NewValue: String; LineNumber:Integer);
begin
  fLine := PChar(NewValue);
  Run := 0;
  fLineNumber := LineNumber;
  Next;
end;

procedure TSynPaxBasicSyn.ApostropheProc;
begin
  fTokenID := tkComment;
  repeat
    inc(Run);
  until fLine[Run] in [#0, #10, #13];
end;

procedure TSynPaxBasicSyn.CRProc;
begin
  fTokenID := tkSpace;
  inc(Run);
  if fLine[Run] = #10 then inc(Run);
end;

procedure TSynPaxBasicSyn.DateProc;
begin
  fTokenID := tkString;
  repeat
    case FLine[Run] of
      #0, #10, #13: break;
    end;
    inc(Run);
  until FLine[Run] = '#';
  if FLine[Run] <> #0 then inc(Run);
end;

procedure TSynPaxBasicSyn.GreaterProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if fLine[Run] = '=' then Inc(Run);
end;

procedure TSynPaxBasicSyn.IdentProc;
begin
  fTokenID := IdentKind((fLine + Run));
  inc(Run, fStringLen);
  while Identifiers[fLine[Run]] do inc(Run);
end;

procedure TSynPaxBasicSyn.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end;

procedure TSynPaxBasicSyn.LowerProc;
begin
  fTokenID := tkSymbol;
  Inc(Run);
  if fLine[Run] in ['=', '>'] then Inc(Run);
end;

procedure TSynPaxBasicSyn.NullProc;
begin
  fTokenID := tkNull;
end;

procedure TSynPaxBasicSyn.NumberProc;
begin
  inc(Run);
  fTokenID := tkNumber;
  while FLine[Run] in ['0'..'9', '.', 'e', 'E'] do inc(Run);
end;

procedure TSynPaxBasicSyn.SpaceProc;
begin
  inc(Run);
  fTokenID := tkSpace;
  while FLine[Run] in [#1..#9, #11, #12, #14..#32] do inc(Run);
end;

procedure TSynPaxBasicSyn.StringProc;
begin
  fTokenID := tkString;
  if (FLine[Run + 1] = #34) and (FLine[Run + 2] = #34) then inc(Run, 2);
  repeat
    case FLine[Run] of
      #0, #10, #13: break;
    end;
    inc(Run);
  until FLine[Run] = #34;
  if FLine[Run] <> #0 then inc(Run);
end;

procedure TSynPaxBasicSyn.SymbolProc;
begin
  inc(Run);
  fTokenID := tkSymbol;
end;

procedure TSynPaxBasicSyn.UnknownProc;
begin
{$IFDEF SYN_MBCSSUPPORT}
  if FLine[Run] in LeadBytes then
    Inc(Run,2)
  else
{$ENDIF}
  inc(Run);
  fTokenID := tkIdentifier;
end;

procedure TSynPaxBasicSyn.Next;
begin
  fTokenPos := Run;
  fProcTable[fLine[Run]];
end;

function TSynPaxBasicSyn.GetDefaultAttribute(Index: integer):
  TSynHighlighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT: Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER: Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD: Result := fKeyAttri;
    SYN_ATTR_STRING: Result := fStringAttri;
    SYN_ATTR_WHITESPACE: Result := fSpaceAttri;
    SYN_ATTR_SYMBOL: Result := fSymbolAttri;
  else
    Result := nil;
  end;
end;

function TSynPaxBasicSyn.GetEol: Boolean;
begin
  Result := fTokenId = tkNull;
end;

function TSynPaxBasicSyn.GetToken: String;
var
  Len: LongInt;
begin
  Len := Run - fTokenPos;
  SetString(Result, (FLine + fTokenPos), Len);
end;

function TSynPaxBasicSyn.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TSynPaxBasicSyn.GetTokenAttribute: TSynHighlighterAttributes;
begin
  case fTokenID of
    tkComment: Result := fCommentAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkNumber: Result := fNumberAttri;
    tkSpace: Result := fSpaceAttri;
    tkString: Result := fStringAttri;
    tkSymbol: Result := fSymbolAttri;
    tkUnknown: Result := fIdentifierAttri;
    else Result := nil;
  end;
end;

function TSynPaxBasicSyn.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

function TSynPaxBasicSyn.GetTokenPos: Integer;
begin
 Result := fTokenPos;
end;

function TSynPaxBasicSyn.GetIdentChars: TSynIdentChars;
begin
  Result := TSynValidStringChars;
end;

{$IFNDEF SYN_CPPB_1} class {$ENDIF}
function TSynPaxBasicSyn.GetLanguageName: string;
begin
  Result := SYNS_LangVBSScript;
end;

function TSynPaxBasicSyn.GetSampleSource: string;
begin
  Result := ''' Syntax highlighting'#13#10 +
            'function printNumber()'#13#10 +
            '  number = 12345'#13#10 +
            '  document.write("The number is " + number)'#13#10 +
            '  for i = 0 to 10'#13#10 +
            '    x = x + 1.0'#13#10 +
            '  next'#13#10 +
            'end function';
end;


initialization
  MakeIdentTable;
{$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TSynPaxBasicSyn);
{$ENDIF}

  PaxBasicKeywords := TStringList.Create;
  with PaxBasicKeywords do
  begin
    Add('alias');
    Add('addressof');
    Add('and');
    Add('as');
    Add('byte');
    Add('byval');
    Add('byref');
    Add('case');
    Add('catch');
    Add('cdecl');
    Add('class');
    Add('declare');
    Add('default');
    Add('delete');
    Add('dim');
    Add('do');
    Add('else');
    Add('elseif');
    Add('end');
    Add('enum');
    Add('exit');
    Add('finally');
    Add('for');
    Add('function');
    Add('inherits');
    Add('get');
    Add('goto');
    Add('if');
    Add('imports');
    Add('in');
    Add('lib');
    Add('long');
    Add('loop');
    Add('me');
    Add('mybase');
    Add('myclass');
    Add('namespace');
    Add('next');
    Add('new');
    Add('not');
    Add('null');
    Add('or');
    Add('pascal');
    Add('private');
    Add('public');
    Add('property');
    Add('protected');
    Add('reduced');
    Add('register');
    Add('return');
    Add('safecall');
    Add('sbyte');
    Add('set');
    Add('select');
    Add('shared');
    Add('short');
    Add('stdcall');
    Add('step');
    Add('structure');
    Add('sub');
    Add('terminalof');
    Add('then');
    Add('throw');
    Add('to');
    Add('try');
    Add('until');
    Add('ushort');
    Add('while');
    Add('with');
    Add('xor');

    Add('currency');
    Add('single');

    Add('print');
    Add('println');
    Add('virtual');
    Add('override');
  end;

finalization
  PaxBasicKeywords.Free;
end.




