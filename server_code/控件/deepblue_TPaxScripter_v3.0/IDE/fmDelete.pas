////////////////////////////////////////////////////////////////////////////
// PAXScript IDE
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2004. All rights reserved.                                  
// Code Version: 2.6
// ========================================================================
// Unit: fmDelete.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

unit fmDelete;

interface

uses
  SysUtils, Classes,

{$IFDEF WIN32}
  Windows,
{$ENDIF}

{$IFDEF LINUX}
  QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, StdCtrls, Controls, ExtCtrls;
{$ELSE}
  Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;
{$ENDIF}

type
  TFormDelete = class(TForm)
    Panel1: TPanel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    ListBox1: TListBox;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDelete: TFormDelete;

implementation

uses fmMain;

{$R *.dfm}

procedure TFormDelete.ButtonOKClick(Sender: TObject);
begin
  with ListBox1 do
    if ItemIndex >= 0 then
    begin
{$IFDEF LINUX}
      if Application.MessageBox('Do you want to remove ' +
           Items[ItemIndex] + ' from project?',
            'Confirm', [smbYES, smbNO]) = smbYES then
{$ELSE}
      if Application.MessageBox(PChar('Do you want to remove ' +
           Items[ItemIndex] + ' from project?'),
            'Confirm', MB_ICONQUESTION or MB_YESNO ) = IDYES then
{$ENDIF}

      FormMain.RemoveFromProject(Items[ItemIndex]);

      Items.Delete(ItemIndex);
    end;
  ModalResult := mrOK;
end;

procedure TFormDelete.ButtonCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
