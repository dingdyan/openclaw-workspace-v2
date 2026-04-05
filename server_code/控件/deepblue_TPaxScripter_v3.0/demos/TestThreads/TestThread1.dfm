object Form1: TForm1
  Left = 192
  Top = 114
  Width = 279
  Height = 480
  Caption = 'Test Threads'
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
  object Button1: TButton
    Left = 24
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Run'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 112
    Width = 241
    Height = 313
    Lines.Strings = (
      '')
    TabOrder = 1
  end
  object cbStop: TCheckBox
    Left = 32
    Top = 72
    Width = 97
    Height = 17
    Caption = 'Stop'
    TabOrder = 2
  end
end
