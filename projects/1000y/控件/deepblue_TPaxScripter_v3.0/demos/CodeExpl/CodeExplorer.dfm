object Form1: TForm1
  Left = 192
  Top = 114
  Width = 696
  Height = 480
  Caption = 'Code Explorer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 405
    Width = 688
    Height = 41
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      Left = 32
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Open'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 136
      Top = 8
      Width = 89
      Height = 25
      Caption = 'Explore Script'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 409
    Height = 405
    Align = alLeft
    Lines.Strings = (
      '')
    TabOrder = 1
  end
  object TreeView1: TTreeView
    Left = 409
    Top = 0
    Width = 279
    Height = 405
    Align = alClient
    Indent = 19
    TabOrder = 2
    OnClick = TreeView1Click
    OnDblClick = TreeView1DblClick
  end
  object OpenDialog1: TOpenDialog
    Left = 464
    Top = 232
  end
  object PaxScripter1: TPaxScripter
    StackSize = 16000
    Optimization = True
    Left = 464
    Top = 168
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
    Left = 536
    Top = 208
  end
end
