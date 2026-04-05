////////////////////////////////////////////////////////////////////////////
// PAXScript IDE
// Author: Alexander Baranovsky (ab@cable.netlux.org)
// ========================================================================
// Copyright (c) Alexander Baranovsky, 2003-2004. All rights reserved.
// Code Version: 2.6
// ========================================================================
// Unit: fmNewProject.pas
// ========================================================================
////////////////////////////////////////////////////////////////////////////

unit fmNewProject;

interface

uses
  SysUtils, Classes,
{$IFDEF LINUX}
  Qt,
  QStdCtrls, QExtCtrls, QControls, QForms, QDialogs,
{$ELSE}
  Windows, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
{$ENDIF}
  PaxScripter;

type
  TFormNew = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    ButtonBrowse: TButton;
    ListBox1: TListBox;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonBrowseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function ShowNewProject: Integer;
    function ShowAddToProject: Integer;
    function LanguageName: String;
    function Text: String;
    { Public declarations }
  end;

var
  FormNew: TFormNew;

implementation

uses fmMain;

{$R *.dfm}

procedure TFormNew.ButtonOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormNew.ButtonCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormNew.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
{$IFDEF LINUX}
  if Key = Key_Return then
    ModalResult := mrOK;
{$ELSE}
  if Key = vk_Return then
    ModalResult := mrOK;
{$ENDIF}
end;

function TFormNew.ShowNewProject: Integer;
begin
  Caption := 'New Project';
  Label1.Caption := 'Project Name';
  Edit1.Text := 'noname';
  ButtonBrowse.Hide;

  result := ShowModal;
end;

function TFormNew.ShowAddToProject: Integer;
begin
  Caption := 'Add to Project';
  Label1.Caption := 'Module Name';
  Edit1.Text := '';
  ButtonBrowse.Show;

  result := ShowModal;
end;

procedure TFormNew.ButtonBrowseClick(Sender: TObject);
var
  L: TPaxLanguage;
begin
  with FormMain.OpenDialog1 do
  begin
    Edit1.Text := '';
    FileName := '';

    L := FormMain.PaxScripter1.FindLanguage(LanguageName);
    if L <> nil then
    begin
      Filter := LanguageName + ' file (*' +
                L.FileExt + ')|*' +
                L.FileExt;

      if Execute then
        Edit1.Text := FileName;
    end;
  end;
end;

function TFormNew.LanguageName: String;
var
  I: Integer;
begin
  result := '';
  for I:=0 to FormMain.PaxScripter1.LanguageCount do
    if ListBox1.Selected[I] then
    begin
      result := ListBox1.Items[I];
      Exit;
    end;
end;

function TFormNew.Text: String;
begin
  result := Edit1.Text;
end;

procedure TFormNew.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I:=0 to FormMain.PaxScripter1.LanguageCount - 1 do
    ListBox1.Items.Add(FormMain.PaxScripter1.Languages[I].LanguageName);
end;

end.
