object Form1: TForm1
  Left = 212
  Top = 110
  Width = 1065
  Height = 640
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
    Left = 96
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object PaxScripter1: TPaxScripter
    OverrideHandlerMode = Replace
    StackSize = 16000
    Optimization = True
    OnVirtualObjectMethodCallEvent = PaxScripter1VirtualObjectMethodCallEvent
    OnVirtualObjectPutPropertyEvent = PaxScripter1VirtualObjectPutPropertyEvent
    Left = 80
    Top = 200
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
    Left = 136
    Top = 200
  end
end
