object Form1: TForm1
  Left = 192
  Top = 114
  Width = 470
  Height = 278
  Caption = 'Test OnInclude Event'
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
    Left = 120
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Run'
    TabOrder = 0
    OnClick = Button1Click
  end
  object PaxScripter1: TPaxScripter
    StackSize = 16000
    Optimization = True
    OnInclude = PaxScripter1Include
    Left = 112
    Top = 160
  end
  object PaxPascal1: TPaxPascal
    CompilerDirectives.Strings = (
      'WIN32')
    LongStrLiterals = True
    CallConvention = ccRegister
    NamespaceAsModule = True
    JavaScriptOperators = False
    DeclareVariables = True
    ZeroBasedStrings = False
    Backslash = True
    FileExt = 'pp'
    LanguageName = 'paxPascal'
    InitArrays = True
    Left = 168
    Top = 160
  end
end
