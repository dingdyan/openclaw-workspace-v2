object Form2: TForm2
  Left = 192
  Top = 114
  Width = 696
  Height = 480
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 88
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 240
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
    OnClick = Button2Click
  end
  object PaxScripter1: TPaxScripter
    StackSize = 16000
    OnAssignScript = PaxScripter1AssignScript
    OnRunning = PaxScripter1Running
    Left = 128
    Top = 72
  end
  object PaxScripter2: TPaxScripter
    StackSize = 16000
    OnAssignScript = PaxScripter2AssignScript
    OnRunning = PaxScripter2Running
    Left = 296
    Top = 112
  end
  object PaxBasic1: TPaxBasic
    LongStrLiterals = True
    CallConvention = ccStdCall
    FileExt = 'pb'
    LanguageName = 'paxBasic'
    Left = 192
    Top = 144
  end
end
