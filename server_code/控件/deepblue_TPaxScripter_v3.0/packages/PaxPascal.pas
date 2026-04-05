////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: PaxPascal.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit PaxPascal;

interface

uses
  SysUtils,
  TypInfo,
  Classes,
  BASE_PARSER,
  PAX_PASCAL,
  IMP_Pascal,
  PaxScripter;

type
  TPaxPascal = class(TPaxLanguage)
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
    property InitArrays: Boolean read fInitArrays write fInitArrays;
  end;

implementation

constructor TPaxPascal.Create(AOwner: TComponent);
begin
  fFileExt := 'pp';
  fLanguageName := 'paxPascal';
  CallConvention := ccRegister;

  inherited;

  NamespaceAsModule := true;
  JavaScriptOperators := false;
  DeclareVariables := true;
  fInitArrays := true;
end;

function TPaxPascal.GetFileExt: String;
begin
  result := fFileExt;
end;

procedure TPaxPascal.SetFileExt(const Value: String);
begin
  fFileExt := Value;
  inherited;
end;

function TPaxPascal.GetLanguageName: String;
begin
  result := fLanguageName;
end;

procedure TPaxPascal.SetLanguageName(const Value: String);
begin
  fLanguageName := Value;
  inherited;
end;

function TPaxPascal.GetPAXParserClass: TPAXParserClass;
begin
  result := TPAXPascalParser;
end;

end.
