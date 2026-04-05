object FormNew: TFormNew
  Left = 337
  Top = 214
  BorderStyle = bsDialog
  Caption = 'New Project'
  ClientHeight = 240
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 136
    Width = 82
    Height = 16
    Caption = 'Project Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 24
    Top = 160
    Width = 377
    Height = 21
    TabOrder = 0
    OnKeyDown = Edit1KeyDown
  end
  object ButtonOK: TButton
    Left = 232
    Top = 200
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 312
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = ButtonCancelClick
  end
  object ButtonBrowse: TButton
    Left = 408
    Top = 160
    Width = 59
    Height = 25
    Caption = 'Browse ...'
    TabOrder = 3
    OnClick = ButtonBrowseClick
  end
  object ListBox1: TListBox
    Left = 16
    Top = 24
    Width = 121
    Height = 97
    ItemHeight = 13
    TabOrder = 4
  end
end
