////////////////////////////////////////////////////////////////////////////
// PAXScript IDE
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2004. All rights reserved.                                  
// Code Version: 2.6
// ========================================================================
// Unit: fmAbout.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

unit fmAbout;

interface           

uses
  SysUtils, Classes,
{$IFDEF LINUX}
  QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, Controls, StdCtrls, Graphics, ExtCtrls;
{$ELSE}
  Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;
{$ENDIF}

type
  TFormAbout = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Label5: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.dfm}

end.
