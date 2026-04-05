object Form1: TForm1
  Left = 192
  Top = 114
  Width = 576
  Height = 640
  Caption = 'GetClassInfo test'
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
    Left = 24
    Top = 320
    Width = 41
    Height = 13
    Caption = 'Methods'
  end
  object Label2: TLabel
    Left = 168
    Top = 320
    Width = 27
    Height = 13
    Caption = 'Fields'
  end
  object Label3: TLabel
    Left = 304
    Top = 320
    Width = 47
    Height = 13
    Caption = 'Properties'
  end
  object Label4: TLabel
    Left = 440
    Top = 320
    Width = 33
    Height = 13
    Caption = 'Events'
  end
  object Button1: TButton
    Left = 16
    Top = 24
    Width = 145
    Height = 25
    Caption = 'Compile script'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 176
    Top = 24
    Width = 241
    Height = 21
    TabOrder = 1
    Text = 'Demo.TMyForm'
  end
  object MemoScript: TMemo
    Left = 16
    Top = 64
    Width = 537
    Height = 241
    Lines.Strings = (
      'program Demo;'
      'uses'
      '  StdCtrls, Forms;'
      ''
      'type'
      '  TMyForm = class(TForm)'
      '   private'
      '     Memo: TMemo;'
      '   public'
      '     constructor Create(Owner: TComponent);'
      '   end;'
      ''
      'constructor TMyForm.Create(Owner: TComponent);'
      'begin'
      '  inherited;'
      '  Top := 100;'
      '  Left := 200;'
      '  Caption := '#39'MyForm'#39';'
      '    '
      '  Memo := TMemo.Create(Self);'
      '  Memo.Parent := Self;'
      '  Memo.Width := 100;'
      '  Memo.Align := '#39'alClient'#39';'
      'end;'
      ''
      'var'
      '  F: TMyForm;'
      'begin'
      '  F := TMyForm.Create(nil);'
      '  F.Show;'
      'end.')
    TabOrder = 2
  end
  object ListBoxMethods: TListBox
    Left = 16
    Top = 344
    Width = 121
    Height = 249
    ItemHeight = 13
    TabOrder = 3
    OnDblClick = ListBoxMethodsDblClick
  end
  object ListBoxFields: TListBox
    Left = 160
    Top = 344
    Width = 121
    Height = 249
    ItemHeight = 13
    TabOrder = 4
  end
  object ListBoxProperties: TListBox
    Left = 296
    Top = 344
    Width = 121
    Height = 249
    ItemHeight = 13
    TabOrder = 5
  end
  object ListBoxEvents: TListBox
    Left = 432
    Top = 344
    Width = 121
    Height = 249
    ItemHeight = 13
    TabOrder = 6
    OnDblClick = ListBoxEventsDblClick
  end
  object PaxScripter1: TPaxScripter
    OverrideHandlerMode = Replace
    StackSize = 16000
    Optimization = True
    Left = 352
    Top = 184
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
    Left = 312
    Top = 176
  end
end
