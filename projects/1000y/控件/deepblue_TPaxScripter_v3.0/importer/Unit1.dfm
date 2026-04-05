object Form1: TForm1
  Left = -4
  Top = -4
  Width = 1032
  Height = 746
  Caption = 'paxScript Importer'
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
    Top = 0
    Width = 1024
    Height = 41
    Align = alTop
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 16
      Top = 8
      Width = 23
      Height = 22
      Hint = 'Open file'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 56
      Top = 8
      Width = 23
      Height = 22
      Hint = 'Import'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Left = 96
      Top = 8
      Width = 23
      Height = 22
      Hint = 'Save result'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
        7700333333337777777733333333008088003333333377F73377333333330088
        88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
        000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
        FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
        99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
        99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
        99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
        93337FFFF7737777733300000033333333337777773333333333}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton3Click
    end
    object RadioButton1: TRadioButton
      Left = 360
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Delphi unit'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 464
      Top = 16
      Width = 113
      Height = 17
      Caption = 'DLL'
      TabOrder = 1
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 41
    Width = 1024
    Height = 671
    Align = alClient
    TabOrder = 1
    object Memo1: TRichEdit
      Left = 1
      Top = 1
      Width = 280
      Height = 538
      Align = alLeft
      PlainText = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object Memo2: TRichEdit
      Left = 281
      Top = 1
      Width = 742
      Height = 538
      Align = alClient
      PlainText = True
      ScrollBars = ssBoth
      TabOrder = 1
    end
    object Panel2: TPanel
      Left = 1
      Top = 539
      Width = 1022
      Height = 131
      Align = alBottom
      TabOrder = 2
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 48
        Height = 13
        Caption = 'Warnings:'
      end
      object Label2: TLabel
        Left = 56
        Top = 8
        Width = 3
        Height = 13
      end
      object ListBox1: TListBox
        Left = 1
        Top = 32
        Width = 1020
        Height = 98
        Align = alBottom
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = ListBox1DblClick
        OnKeyDown = ListBox1KeyDown
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 536
    Top = 193
  end
  object SaveDialog1: TSaveDialog
    Left = 616
    Top = 241
  end
end
