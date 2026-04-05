object Form1: TForm1
  Left = 174
  Top = 184
  Width = 553
  Height = 268
  Caption = 'Form1'
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
    Left = 112
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo2: TMemo
    Left = 16
    Top = 32
    Width = 505
    Height = 153
    Font.Charset = GREEK_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object cbShowOk: TCheckBox
    Left = 24
    Top = 8
    Width = 113
    Height = 17
    Caption = 'Show Successes'
    TabOrder = 2
  end
  object cbAuto: TCheckBox
    Left = 160
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Test Automation'
    TabOrder = 3
  end
  object Button2: TButton
    Left = 216
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Test Threads'
    TabOrder = 4
    OnClick = Button2Click
  end
  object cbStop: TCheckBox
    Left = 312
    Top = 200
    Width = 97
    Height = 17
    Caption = 'Stop Threads'
    TabOrder = 5
  end
  object cbExcept: TCheckBox
    Left = 280
    Top = 8
    Width = 113
    Height = 17
    Caption = 'Test Exceptions'
    TabOrder = 6
  end
end
