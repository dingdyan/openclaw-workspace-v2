object Form1: TForm1
  Left = 192
  Top = 114
  Width = 506
  Height = 550
  Caption = 'Form1'
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
    Left = 32
    Top = 232
    Width = 78
    Height = 13
    Caption = 'Generated script'
  end
  object Button1: TButton
    Left = 16
    Top = 24
    Width = 113
    Height = 25
    Caption = 'Compile & Run '
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 72
    Width = 449
    Height = 425
    Lines.Strings = (
      '')
    TabOrder = 1
  end
  object PaxScripter1: TPaxScripter
    StackSize = 16000
    Optimization = True
    OnDefine = PaxScripter1Define
    OnUsedModule = PaxScripter1UsedModule
    Left = 184
    Top = 16
  end
  object PaxPascal1: TPaxPascal
    CompilerDirectives.Strings = (
      'WIN32')
    LongStrLiterals = True
    CallConvention = ccRegister
    NamespaceAsModule = True
    JavaScriptOperators = False
    FileExt = 'pp'
    LanguageName = 'paxPascal'
    InitArrays = True
    Left = 232
    Top = 16
  end
  object PaxDfmConverter1: TPaxDfmConverter
    Left = 280
    Top = 24
  end
end
