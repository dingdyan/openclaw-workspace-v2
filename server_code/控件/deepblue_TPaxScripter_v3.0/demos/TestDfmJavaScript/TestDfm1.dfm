object Form1: TForm1
  Left = 192
  Top = 114
  Width = 696
  Height = 426
  Caption = 'Test DFM convertor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 104
    Width = 102
    Height = 16
    Caption = 'Generated script:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Button1: TButton
    Left = 8
    Top = 56
    Width = 193
    Height = 25
    Caption = 'Generate script from dfm file and run it'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 128
    Width = 688
    Height = 265
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Button2: TButton
    Left = 8
    Top = 16
    Width = 193
    Height = 25
    Caption = 'Show Delphi form'
    TabOrder = 2
    OnClick = Button2Click
  end
  object PaxDfmConverter1: TPaxDfmConverter
    Left = 368
    Top = 24
  end
  object PaxScripter1: TPaxScripter
    StackSize = 16000
    Optimization = True
    OnAssignScript = PaxScripter1AssignScript
    OnRunningUpdateActive = False
    Left = 440
    Top = 24
  end
  object PaxJavaScript1: TPaxJavaScript
    CompilerDirectives.Strings = (
      'WIN32')
    LongStrLiterals = True
    CallConvention = ccStdCall
    NamespaceAsModule = False
    JavaScriptOperators = True
    DeclareVariables = False
    FileExt = 'js'
    LanguageName = 'paxJavaScript'
    Left = 536
    Top = 56
  end
end
