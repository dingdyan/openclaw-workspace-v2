object FormDelete: TFormDelete
  Left = 232
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Remove from Project'
  ClientHeight = 278
  ClientWidth = 376
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 237
    Width = 376
    Height = 41
    Align = alBottom
    TabOrder = 0
    object ButtonOK: TButton
      Left = 200
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = ButtonOKClick
    end
    object ButtonCancel: TButton
      Left = 288
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = ButtonCancelClick
    end
  end
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 376
    Height = 237
    Align = alClient
    ItemHeight = 13
    TabOrder = 1
  end
end
