////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: PaxC.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit PaxC;

interface

uses
  SysUtils,
  TypInfo,
  Classes,
  BASE_PARSER,
  PAX_C,
  IMP_C,
  PaxScripter;
type
  TPaxC = class(TPaxLanguage)
  private
    fFileExt: String;
    fLanguageName: String;
  protected
    function GetFileExt: String; override;
    procedure SetFileExt(const Value: String); override;
    function GetLanguageName: String; override;
    procedure SetLanguageName(const Value: String); override;
    function GetPAXParserClass: TPAXParserClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property FileExt: String read fFileExt write SetFileExt;
    property LanguageName: String read fLanguageName write SetLanguageName;
  end;

implementation

constructor TPaxC.Create(AOwner: TComponent);
begin
  CallConvention := ccCDecl;
  fFileExt := 'pc';
  fLanguageName := 'paxC';
  inherited;
  JavaScriptOperators := false;
  DeclareVariables := true;
end;

function TPaxC.GetFileExt: String;
begin
  result := fFileExt;
end;

procedure TPaxC.SetFileExt(const Value: String);
begin
  fFileExt := Value;
  inherited;
end;

function TPaxC.GetLanguageName: String;
begin
  result := fLanguageName;
end;

procedure TPaxC.SetLanguageName(const Value: String);
begin
  fLanguageName := Value;
  inherited;
end;

function TPaxC.GetPAXParserClass: TPAXParserClass;
begin
  result := TPAXCParser;
end;

end.
