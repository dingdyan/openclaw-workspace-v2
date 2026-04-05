////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: PaxBasic.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit PaxBasic;

interface

uses
  SysUtils,
  TypInfo,
  Classes,
  BASE_PARSER,
  PAX_BASIC,
  IMP_Basic,
  PaxScripter;

type
  TPaxBasic = class(TPaxLanguage)
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
    property VBArrays: Boolean read fVBArrays write fVBArrays;
  end;

implementation

constructor TPaxBasic.Create(AOwner: TComponent);
begin
  CallConvention := ccStdCall;
  fFileExt := 'pb';
  fLanguageName := 'paxBasic';
  inherited;
  JavaScriptOperators := false;
  DeclareVariables := true;
end;

function TPaxBasic.GetFileExt: String;
begin
  result := fFileExt;
end;

procedure TPaxBasic.SetFileExt(const Value: String);
begin
  fFileExt := Value;
  inherited;
end;

function TPaxBasic.GetLanguageName: String;
begin
  result := fLanguageName;
end;

procedure TPaxBasic.SetLanguageName(const Value: String);
begin
  fLanguageName := Value;
  inherited;
end;

function TPaxBasic.GetPAXParserClass: TPAXParserClass;
begin
  result := TPAXBasicParser;
end;

end.
