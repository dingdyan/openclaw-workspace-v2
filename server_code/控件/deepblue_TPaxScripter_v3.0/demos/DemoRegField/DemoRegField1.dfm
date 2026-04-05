object Form1: TForm1
  Left = 192
  Top = 114
  Width = 696
  Height = 480
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
  object Button1: TButton
    Left = 120
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object PaxScripter1: TPaxScripter
    StackSize = 16000
    Optimization = True
    OnAssignScript = PaxScripter1AssignScript
    Left = 272
    Top = 88
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
    Left = 336
    Top = 88
  end
end
