////////////////////////////////////////////////////////////////////////////
// PAXScript IDE
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2004. All rights reserved.                                  
// Code Version: 2.6
// ========================================================================
// Unit: fmCompiling.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

unit fmCompiling;

interface

uses
  SysUtils, Classes,
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}

{$IFDEF LINUX}
  QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, Controls, StdCtrls, ExtCtrls,
{$ELSE}
  Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
{$ENDIF}
  PaxScripter;

type
  TCompiling = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    PanelProject: TPanel;
    PanelStatus: TPanel;
    PanelCurrLine: TPanel;
    PanelAllLines: TPanel;
    PanelError: TPanel;
    LabelProject: TLabel;
    LabelStatus: TLabel;
    LabelCurrLine: TLabel;
    LabelTotalLines: TLabel;
    LabelError: TLabel;
    LabelCurrLineNumber: TLabel;
    LabelTotalLinesCount: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure BeginCompiling;
    procedure EndCompiling;
{$IFDEF MSWINDOWS}
     procedure CreateParams(var Params: TCreateParams); override;
{$ENDIF}
    { Public declarations }
  end;

var
  Compiling: TCompiling;

implementation

uses fmMain;

{$R *.dfm}

procedure TCompiling.BeginCompiling;
begin
  Button1.Caption := 'Cancel';
end;

procedure TCompiling.EndCompiling;
begin
  Button1.Caption := 'OK';
end;

{$IFDEF MSWINDOWS}
procedure TCompiling.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := WS_CAPTION;
end;
{$ENDIF}

procedure TCompiling.Button1Click(Sender: TObject);
begin
  if FormMain.PaxScripter1.ScripterState = ssCompiling then
  begin
    EndCompiling;
    FormMain.PaxScripter1.CancelCompiling('Compile terminated by user');
  end
  else
    Close;
end;

end.
