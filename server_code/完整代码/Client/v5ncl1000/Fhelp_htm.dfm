object frmHelp: TfrmHelp
  Left = 245
  Top = 85
  HorzScrollBar.Color = 10022804
  HorzScrollBar.ParentColor = False
  VertScrollBar.Color = 10022804
  VertScrollBar.ParentColor = False
  Anchors = []
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = #24110#21161#31995#32479
  ClientHeight = 514
  ClientWidth = 744
  Color = 10022804
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TreeView1: TTreeView
    Left = 840
    Top = 728
    Width = 160
    Height = 447
    AutoExpand = True
    Color = 10022804
    Ctl3D = False
    Indent = 19
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 0
    Visible = False
    OnChange = TreeView1Change
  end
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 0
    Width = 744
    Height = 514
    Align = alClient
    TabOrder = 1
    ControlData = {
      4C000000E54C0000203500000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
