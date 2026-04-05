object Form1: TForm1
  Left = 195
  Top = 142
  Width = 460
  Height = 334
  Caption = 'AddDelphiUnit test'
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
    Top = 72
    Width = 116
    Height = 16
    Caption = 'Generated script'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 16
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Run '
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 96
    Width = 452
    Height = 204
    Align = alBottom
    TabOrder = 1
  end
  object PaxScripter1: TPaxScripter
    StackSize = 16000
    Optimization = True
    Left = 128
    Top = 24
  end
  object PaxPascal1: TPaxPascal
    CompilerDirectives.Strings = (
      'WIN32')
    LongStrLiterals = True
    CallConvention = ccRegister
    NamespaceAsModule = True
    JavaScriptOperators = False
    DeclareVariables = True
    FileExt = 'pp'
    LanguageName = 'paxPascal'
    InitArrays = True
    Left = 184
    Top = 24
  end
end
