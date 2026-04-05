////////////////////////////////////////////////////////////////////////////
// PAXScript IDE
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2004. All rights reserved.                                  
// Code Version: 2.6
// ========================================================================
// Unit: fmConsole.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

unit fmConsole;

interface

uses
  SysUtils, Classes,
{$IFDEF LINUX}
  QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, Controls, StdCtrls;
{$ELSE}
  Graphics, Controls, Forms, Dialogs,
  StdCtrls;
{$ENDIF}

type
  TFormConsole = class(TForm)
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormConsole: TFormConsole;

implementation

{$R *.dfm}

end.
