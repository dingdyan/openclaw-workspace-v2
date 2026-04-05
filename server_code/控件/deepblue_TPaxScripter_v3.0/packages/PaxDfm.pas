////////////////////////////////////////////////////////////////////////////
// PAXScript Interpreter
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2005. All rights reserved.
// Code Version: 3.0
// ========================================================================
// Unit: PaxDfm.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

{$I PaxScript.def}
unit PaxDfm;

interface

uses
  SysUtils,
  TypInfo,
  Classes,
{$IFDEF LINUX}
  QGraphics,
{$ELSE}
{$IFNDEF BCB}
  Graphics,
{$ENDIF}
{$ENDIF}
  BASE_DFM,
  PASCAL_PARSER,
  PaxScripter;

type
  TPaxDfmConverter = class(TComponent)
  private
    fUsedUnits: TStrings;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Parse(const DfmFileName: String; Output: TStrings; AsUnit: Boolean = true); overload;
    procedure Parse(const DfmFileName: String; Output: TStrings; const PaxLanguage: String;
                    AsUnit: Boolean = true); overload;
    procedure ParseText(const Text: String; Output: TStrings;
                        const UnitName: String = ''; const PaxLanguage: String = 'paxPascal');
    property UsedUnits: TStrings read fUsedUnits write fUsedUnits;
  end;

implementation

constructor TPaxDfmConverter.Create(AOwner: TComponent);
begin
  inherited;
  fUsedUnits := TStringList.Create;
end;

destructor TPaxDfmConverter.Destroy;
begin
  fUsedUnits.Free;
  inherited;
end;

procedure TPaxDfmConverter.Parse(const DfmFileName: String; Output: TStrings; AsUnit: Boolean = true);
begin
  ConvertDfmFile(DfmFileName, UsedUnits, Output, AsUnit);
end;

procedure TPaxDfmConverter.Parse(const DfmFileName: String; Output: TStrings; const PaxLanguage: String; AsUnit: Boolean = true);
begin
  ConvertDfmFile(DfmFileName, UsedUnits, Output, AsUnit, nil, PaxLanguage);
end;

procedure TPaxDfmConverter.ParseText(const Text: String; Output: TStrings;
                                     const UnitName: String = ''; const PaxLanguage: String = 'paxPascal');
begin
  ConvDFMStringtoScript(Text, UsedUnits, Output, UnitName <> '', UnitName, nil, PaxLanguage);
end;

procedure _AssignBmp(X: TObject; S: String);
begin
{$IFNDEF BCB}
  SaveStr(S, 'temp.bmp');
  if X.InheritsFrom(TGraphic) then
    TGraphic(X).LoadFromFile('temp.bmp');
{$ENDIF}
end;

initialization

RegisterRoutine('procedure _AssignBmp(X: TObject; S: String);', @_AssignBmp);

end.
