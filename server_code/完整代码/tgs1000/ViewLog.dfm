object frmLog: TfrmLog
  Left = 208
  Top = 105
  Width = 592
  Height = 624
  Caption = 'Log'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 584
    Height = 404
    Align = alClient
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 404
    Width = 584
    Height = 193
    ActivePage = TabSheet2
    Align = alBottom
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #20154#29289#30417#35270
      object Label1: TLabel
        Left = 16
        Top = 24
        Width = 60
        Height = 13
        Caption = #30417#35270#20154#21517#23383
      end
      object Edit1: TEdit
        Left = 88
        Top = 16
        Width = 169
        Height = 21
        TabOrder = 0
        OnChange = Edit1Change
      end
      object Button1: TButton
        Left = 288
        Top = 16
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = #20844#21578
      ImageIndex = 1
      object Edit2: TEdit
        Left = 8
        Top = 16
        Width = 313
        Height = 21
        TabOrder = 0
      end
      object Button2: TButton
        Left = 336
        Top = 16
        Width = 75
        Height = 25
        Caption = #21457#36865
        TabOrder = 1
        OnClick = Button2Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
    end
  end
end
