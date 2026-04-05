object Form1: TForm1
  Left = 437
  Top = 215
  Width = 521
  Height = 408
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
  object Memo1: TMemo
    Left = 32
    Top = 16
    Width = 417
    Height = 217
    Lines.Strings = (
      'uses Classes, Dialogs, LgInterfaces;'
      ''
      'var '
      '  i: integer;'
      '  user : ILgUser;'
      ''
      'begin'
      ''
      '  showmessage(app.Version);'
      ''
      '  for i:=0 to app.UserList.count-1 do'
      '  begin'
      '     user := app.UserList[i];'
      '     showmessage(user.name);'
      '  end;'
      ''
      ''
      'end.')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 24
    Top = 248
    Width = 113
    Height = 25
    Caption = 'Execute paxScript'
    TabOrder = 1
    OnClick = Button1Click
  end
  object PaxScripter: TPaxScripter
    StackSize = 16000
    Optimization = True
    Left = 24
    Top = 288
  end
  object PaxPascal: TPaxPascal
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
    Left = 64
    Top = 288
  end
end
