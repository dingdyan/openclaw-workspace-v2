object Form1: TForm1
  Left = 231
  Top = 244
  Width = 490
  Height = 215
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
    Left = 72
    Top = 104
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
    Left = 88
    Top = 56
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
    Left = 152
    Top = 56
  end
end
