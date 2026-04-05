////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: PaxJavaScript.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit PaxJavaScript;

interface

uses
  SysUtils,
  TypInfo,
  Classes,
  BASE_PARSER,
  PAX_JAVASCRIPT,
  IMP_JavaScript,
  PaxScripter;

type
  TPaxJavaScript = class(TPaxLanguage)
  private
    fFileExt: String;
    fLanguageName: String;
  protected
    function GetFileExt: String; override;
    procedure SetFileExt(const Value: String); override;
    procedure SetLanguageName(const Value: String); override;
    function GetLanguageName: String; override;
    function GetPAXParserClass: TPAXParserClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property FileExt: String read fFileExt write SetFileExt;
    property LanguageName: String read fLanguageName write SetLanguageName;
  end;

implementation

constructor TPaxJavaScript.Create(AOwner: TComponent);
begin
  CallConvention := ccStdCall;
  fFileExt := 'js';
  fLanguageName := 'paxJavaScript';
  inherited;
  JavaScriptOperators := true;
  DeclareVariables := false;
end;

function TPaxJavaScript.GetFileExt: String;
begin
  result := fFileExt;
end;

procedure TPaxJavaScript.SetFileExt(const Value: String);
begin
  fFileExt := Value;
  inherited;
end;

function TPaxJavaScript.GetLanguageName: String;
begin
  result := fLanguageName;
end;

procedure TPaxJavaScript.SetLanguageName(const Value: String);
begin
  fLanguageName := Value;
  inherited;
end;

function TPaxJavaScript.GetPAXParserClass: TPAXParserClass;
begin
  result := TPAXJavaScriptParser;
end;

end.
