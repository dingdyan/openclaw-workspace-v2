object FrmGameToolsNew: TFrmGameToolsNew
  Left = 437
  Top = 217
  BorderStyle = bsNone
  Caption = 'FrmGameToolsNew'
  ClientHeight = 270
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object A2ILabel_bottom: TA2ILabel
    Left = 0
    Top = 236
    Width = 327
    Height = 34
    AutoSize = False
    Color = clSilver
    ParentColor = False
    ADXForm = A2Form
  end
  object A2ILabel_top: TA2ILabel
    Left = 0
    Top = 0
    Width = 327
    Height = 36
    AutoSize = False
    ADXForm = A2Form
  end
  object A2ILabel_button: TA2ILabel
    Left = 0
    Top = 36
    Width = 327
    Height = 20
    AutoSize = False
    ADXForm = A2Form
  end
  object A2Button_Pick: TA2Button
    Left = 54
    Top = 38
    Width = 38
    Height = 15
    AutoSize = False
    Color = clYellow
    ParentColor = False
    OnClick = A2Button_PickClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Shout: TA2Button
    Left = 95
    Top = 38
    Width = 38
    Height = 15
    AutoSize = False
    Color = clYellow
    ParentColor = False
    OnClick = A2Button_ShoutClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Walk: TA2Button
    Left = 136
    Top = 38
    Width = 38
    Height = 15
    AutoSize = False
    Color = clYellow
    ParentColor = False
    OnClick = A2Button_WalkClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Attack: TA2Button
    Left = 177
    Top = 38
    Width = 38
    Height = 15
    AutoSize = False
    Color = clYellow
    ParentColor = False
    OnClick = A2Button_AttackClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Show: TA2Button
    Left = 218
    Top = 38
    Width = 38
    Height = 15
    AutoSize = False
    Color = clYellow
    ParentColor = False
    OnClick = A2Button_ShowClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Eat: TA2Button
    Left = 13
    Top = 38
    Width = 39
    Height = 15
    AutoSize = False
    Color = clYellow
    ParentColor = False
    OnClick = A2Button_EatClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Close: TA2Button
    Left = 294
    Top = 16
    Width = 15
    Height = 15
    AutoSize = False
    Color = clNavy
    ParentColor = False
    OnClick = A2Button_CloseClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Read: TA2Button
    Left = 130
    Top = 240
    Width = 56
    Height = 19
    AutoSize = False
    Color = clNavy
    ParentColor = False
    OnClick = A2Button_ReadClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Button_Save: TA2Button
    Left = 206
    Top = 240
    Width = 56
    Height = 19
    AutoSize = False
    Color = clNavy
    ParentColor = False
    OnClick = A2Button_SaveClick
    ADXForm = A2Form
    FontColor = 0
    FontSelColor = 0
  end
  object A2Panel_shout: TA2Panel
    Left = 336
    Top = 176
    Width = 327
    Height = 181
    Color = clPurple
    TabOrder = 2
    Visible = False
    ADXForm = A2Form
    object A2ILabel_shout: TA2ILabel
      Left = 0
      Top = 0
      Width = 327
      Height = 180
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnMouseMove = A2ILabel_shoutMouseMove
      ADXForm = A2Form
    end
    object A2CheckBox12: TA2CheckBox
      Left = 16
      Top = 149
      Width = 15
      Height = 15
      AutoSize = False
      Color = clGreen
      ParentColor = False
      ADXForm = A2Form
    end
    object A2Button21: TA2Button
      Left = 160
      Top = 147
      Width = 19
      Height = 10
      AutoSize = False
      Color = clGreen
      ParentColor = False
      OnClick = A2Button21Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button22: TA2Button
      Left = 160
      Top = 158
      Width = 19
      Height = 10
      AutoSize = False
      Color = clGreen
      ParentColor = False
      OnClick = A2Button22Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button_AddShout: TA2Button
      Left = 176
      Top = 118
      Width = 21
      Height = 22
      AutoSize = False
      Color = clGreen
      ParentColor = False
      OnClick = A2Button_AddShoutClick
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button_DelShout: TA2Button
      Left = 201
      Top = 118
      Width = 22
      Height = 22
      AutoSize = False
      Color = clGreen
      ParentColor = False
      OnClick = A2Button_DelShoutClick
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2ListBox_ShoutList: TA2ListBox
      Left = 19
      Top = 16
      Width = 195
      Height = 91
      Caption = 'A2ListBox_ShoutList'
      TabOrder = 0
      boListbox = False
      ADXForm = A2Form
      FontColor = 32767
      FontSelColor = 255
      ItemHeight = 12
      ItemMerginX = 3
      ItemMerginY = 3
      FontEmphasis = False
      ScrollBarView = True
    end
    object A2Edit11: TA2Edit
      Left = 105
      Top = 146
      Width = 54
      Height = 21
      TabOrder = 1
      OnChange = A2Edit11Change
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit_AddShout: TA2Edit
      Left = 19
      Top = 121
      Width = 149
      Height = 21
      TabOrder = 2
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
  end
  object A2Panel_walk: TA2Panel
    Left = 384
    Top = -8
    Width = 327
    Height = 181
    Color = clYellow
    TabOrder = 3
    Visible = False
    ADXForm = A2Form
    object A2ILabel_walk: TA2ILabel
      Left = 0
      Top = 0
      Width = 327
      Height = 180
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnMouseMove = A2ILabel_walkMouseMove
      ADXForm = A2Form
    end
    object A2CheckBox_MoveOpenMagic: TA2CheckBox
      Left = 21
      Top = 12
      Width = 15
      Height = 14
      AutoSize = False
      Color = clPurple
      ParentColor = False
      ADXForm = A2Form
    end
    object A2CheckBox11: TA2CheckBox
      Left = 21
      Top = 37
      Width = 15
      Height = 15
      AutoSize = False
      Color = clPurple
      ParentColor = False
      ADXForm = A2Form
    end
    object A2Button15: TA2Button
      Left = 234
      Top = 58
      Width = 19
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button15Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button16: TA2Button
      Left = 234
      Top = 69
      Width = 19
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button16Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button17: TA2Button
      Left = 162
      Top = 86
      Width = 18
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button17Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button18: TA2Button
      Left = 162
      Top = 97
      Width = 18
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button18Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button19: TA2Button
      Left = 234
      Top = 86
      Width = 19
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button19Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button20: TA2Button
      Left = 234
      Top = 97
      Width = 19
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button20Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button13: TA2Button
      Left = 162
      Top = 58
      Width = 17
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button13Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button14: TA2Button
      Left = 162
      Top = 69
      Width = 17
      Height = 10
      AutoSize = False
      Color = clPurple
      ParentColor = False
      OnClick = A2Button14Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Edit7: TA2Edit
      Left = 108
      Top = 62
      Width = 52
      Height = 21
      TabOrder = 0
      Text = 'A2Edit7'
      OnChange = A2Edit7Change
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit8: TA2Edit
      Left = 182
      Top = 62
      Width = 52
      Height = 21
      TabOrder = 1
      Text = 'A2Edit7'
      OnChange = A2Edit8Change
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit9: TA2Edit
      Left = 108
      Top = 90
      Width = 52
      Height = 21
      TabOrder = 2
      Text = 'A2Edit7'
      OnChange = A2Edit9Change
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit10: TA2Edit
      Left = 182
      Top = 90
      Width = 52
      Height = 21
      TabOrder = 3
      Text = 'A2Edit7'
      OnChange = A2Edit10Change
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2ComboBox_ChangeMoveMagic: TA2ComboBox
      Left = 108
      Top = 10
      Width = 117
      Height = 21
      ItemHeight = 13
      TabOrder = 4
      OnDropDown = A2ComboBox_ChangeMoveMagicDropDown
      ADXForm = A2Form
    end
  end
  object A2Panel_ShouName: TA2Panel
    Left = 279
    Top = 570
    Width = 327
    Height = 181
    Color = clLime
    TabOrder = 5
    Visible = False
    ADXForm = A2Form
    object A2ILabel_show: TA2ILabel
      Left = 0
      Top = 0
      Width = 327
      Height = 180
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnMouseMove = A2ILabel_showMouseMove
      ADXForm = A2Form
    end
    object A2CheckBox_ShowAllName: TA2CheckBox
      Left = 34
      Top = 10
      Width = 14
      Height = 15
      AutoSize = False
      Color = clYellow
      ParentColor = False
      OnClick = A2CheckBox_ShowAllNameClick
      ADXForm = A2Form
    end
    object A2CheckBox_ShowMonster: TA2CheckBox
      Left = 34
      Top = 35
      Width = 14
      Height = 15
      AutoSize = False
      Color = clYellow
      ParentColor = False
      ADXForm = A2Form
    end
    object A2CheckBox_ShowNpc: TA2CheckBox
      Left = 34
      Top = 59
      Width = 14
      Height = 15
      AutoSize = False
      Color = clYellow
      ParentColor = False
      ADXForm = A2Form
    end
    object A2CheckBox_ShowPlayer: TA2CheckBox
      Left = 34
      Top = 85
      Width = 14
      Height = 15
      AutoSize = False
      Color = clYellow
      ParentColor = False
      ADXForm = A2Form
    end
    object A2CheckBox_ShowItem: TA2CheckBox
      Left = 34
      Top = 110
      Width = 14
      Height = 15
      AutoSize = False
      Color = clYellow
      ParentColor = False
      ADXForm = A2Form
    end
  end
  object A2Panel_attack: TA2Panel
    Left = 468
    Top = 390
    Width = 327
    Height = 181
    Color = clTeal
    TabOrder = 4
    Visible = False
    ADXForm = A2Form
    object A2ILabel_attack: TA2ILabel
      Left = 0
      Top = 0
      Width = 327
      Height = 180
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnMouseMove = A2ILabel_attackMouseMove
      ADXForm = A2Form
    end
    object A2CheckBox_Hit_not_Shift: TA2CheckBox
      Left = 22
      Top = 17
      Width = 15
      Height = 16
      AutoSize = False
      Color = clBlack
      ParentColor = False
      ADXForm = A2Form
    end
    object A2CheckBox_Hit_not_Ctrl: TA2CheckBox
      Left = 22
      Top = 45
      Width = 15
      Height = 15
      AutoSize = False
      Color = clBlack
      ParentColor = False
      ADXForm = A2Form
    end
    object A2CheckBox_autoHIt: TA2CheckBox
      Left = 22
      Top = 74
      Width = 15
      Height = 15
      AutoSize = False
      Color = clBlack
      ParentColor = False
      ADXForm = A2Form
    end
  end
  object A2Panel_pick: TA2Panel
    Left = 72
    Top = 388
    Width = 327
    Height = 181
    Color = clOlive
    TabOrder = 1
    Visible = False
    ADXForm = A2Form
    object A2ILabel_pick: TA2ILabel
      Left = 0
      Top = 0
      Width = 327
      Height = 180
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnMouseMove = A2ILabel_pickMouseMove
      ADXForm = A2Form
    end
    object A2CheckBox_Pick: TA2CheckBox
      Left = 178
      Top = 24
      Width = 15
      Height = 15
      AutoSize = False
      Color = clNavy
      ParentColor = False
      ADXForm = A2Form
    end
    object A2CheckBox_Opposite: TA2CheckBox
      Left = 178
      Top = 45
      Width = 15
      Height = 15
      AutoSize = False
      Color = clNavy
      ParentColor = False
      ADXForm = A2Form
    end
    object A2Button_Add: TA2Button
      Left = 117
      Top = 143
      Width = 26
      Height = 26
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button_AddClick
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button_Dec: TA2Button
      Left = 147
      Top = 143
      Width = 26
      Height = 26
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button_DecClick
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2ListBox_Itemlist: TA2ListBox
      Left = 27
      Top = 28
      Width = 142
      Height = 113
      TabOrder = 0
      boListbox = False
      ADXForm = A2Form
      FontColor = 32767
      FontSelColor = 255
      ItemHeight = 12
      ItemMerginX = 3
      ItemMerginY = 3
      FontEmphasis = False
      ScrollBarView = True
    end
    object A2Edit6: TA2Edit
      Left = 28
      Top = 147
      Width = 82
      Height = 21
      TabOrder = 1
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
  end
  object A2Panel_eatblood: TA2Panel
    Left = 0
    Top = 56
    Width = 327
    Height = 180
    Color = clGreen
    TabOrder = 0
    ADXForm = A2Form
    object A2ILabel_BackEat: TA2ILabel
      Left = 0
      Top = 0
      Width = 327
      Height = 181
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnMouseMove = A2ILabel_BackEatMouseMove
      ADXForm = A2Form
    end
    object A2CheckBox_inPower: TA2CheckBox
      Left = 25
      Top = 15
      Width = 14
      Height = 15
      AutoSize = False
      Color = clNavy
      ParentColor = False
      ADXForm = A2Form
    end
    object A2CheckBox_outPower: TA2CheckBox
      Left = 25
      Top = 43
      Width = 14
      Height = 15
      AutoSize = False
      Color = clNavy
      ParentColor = False
      ADXForm = A2Form
    end
    object A2CheckBox_Magic: TA2CheckBox
      Left = 25
      Top = 72
      Width = 14
      Height = 15
      AutoSize = False
      Color = clNavy
      ParentColor = False
      ADXForm = A2Form
    end
    object A2CheckBox_Life: TA2CheckBox
      Left = 25
      Top = 101
      Width = 14
      Height = 15
      AutoSize = False
      Color = clNavy
      ParentColor = False
      ADXForm = A2Form
    end
    object A2Button1: TA2Button
      Left = 136
      Top = 12
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button1Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button2: TA2Button
      Left = 136
      Top = 23
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button2Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button3: TA2Button
      Left = 136
      Top = 40
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button3Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button4: TA2Button
      Left = 136
      Top = 51
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button4Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button5: TA2Button
      Left = 136
      Top = 69
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button5Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button6: TA2Button
      Left = 136
      Top = 80
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button6Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button7: TA2Button
      Left = 136
      Top = 97
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button7Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button8: TA2Button
      Left = 136
      Top = 108
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button8Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button9: TA2Button
      Left = 136
      Top = 128
      Width = 19
      Height = 10
      AutoSize = False
      Color = clBlue
      ParentColor = False
      OnClick = A2Button9Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Button10: TA2Button
      Left = 136
      Top = 139
      Width = 19
      Height = 10
      AutoSize = False
      Color = clNavy
      ParentColor = False
      OnClick = A2Button10Click
      ADXForm = A2Form
      FontColor = 0
      FontSelColor = 0
    end
    object A2Edit_inPower: TA2Edit
      Left = 82
      Top = 15
      Width = 54
      Height = 21
      TabOrder = 0
      OnChange = A2Edit_inPowerChange
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit_outPower: TA2Edit
      Left = 82
      Top = 42
      Width = 54
      Height = 21
      TabOrder = 1
      OnChange = A2Edit_outPowerChange
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit_Magic: TA2Edit
      Left = 82
      Top = 71
      Width = 54
      Height = 21
      TabOrder = 2
      OnChange = A2Edit_MagicChange
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit_Life: TA2Edit
      Left = 82
      Top = 99
      Width = 54
      Height = 21
      TabOrder = 3
      OnChange = A2Edit_LifeChange
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2Edit_delayTimeEat: TA2Edit
      Left = 82
      Top = 130
      Width = 54
      Height = 21
      TabOrder = 4
      OnChange = A2Edit_delayTimeEatChange
      OnKeyPress = A2Edit_inPowerKeyPress
      ADXForm = A2Form
      TransParent = False
      FontColor = 16777215
    end
    object A2ComboBox_inPower: TA2ComboBox
      Left = 178
      Top = 12
      Width = 74
      Height = 21
      Color = clWhite
      ItemHeight = 13
      TabOrder = 5
      OnDropDown = A2ComboBox_inPowerDropDown
      ADXForm = A2Form
      Picture.Data = {
        07544269746D617022050000424D220500000000000036000000280000001300
        0000150000000100180000000000EC040000202E0000202E0000000000000000
        00002F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D99
        2F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D990000002F6D
        99060D1404060C070C14060F15060D1405050D05060E050A12050A11060A1306
        0912060D16060D18060B1507091305060E070D162F6D990000002F6D9904060D
        06060E070911060D14060B1306060F060811060C15060C1506081006080F060B
        14060B1606081307061006050D04050D2F6D990000002F6D99050814080B160A
        111D09172509162209121C09111E09152509172509121E09121E091624091727
        0914210A0D180808120508112F6D990000002F6D99040B16070F1B091926081E
        2B081C29081A25081926081A29081C2A081B26081825081A29081D2C08192709
        111F070A160509142F6D990000002F6D9905101907121F091C2B08222E081E2A
        081E2A08212D08212F08212D08222B081D29081C2B081F2D081C2A091522070C
        18060D182F6D990000002F6D9905101807121E091B2A08202C081C2A081D2B08
        1F2D081F2D67CDF2081F2D081F2D081B2A081E2C081C29091320070B16060D17
        2F6D990000002F6D99050B16070E1A091826081E2B081B2A081B2B081F2D67CD
        F267CDF267CDF2081F2D081F2D081F2D081A2809101B070811060B152F6D9900
        00002F6D99050913070C15091822081F2C081E2D081A2A67CDF267CDF267CDF2
        67CDF267CDF2081F2D081F2D081825090E19070812060B152F6D990000002F6D
        99050C17070F1A091926081F2C081E2E67CDF267CDF267CDF267CDF267CDF267
        CDF267CDF2081D29081A26091420070C17060D172F6D990000002F6D99050F1B
        07121F091A29081F2C67CDF267CDF267CDF267CDF267CDF267CDF267CDF267CD
        F267CDF2081C27091723070E19060D182F6D990000002F6D99050E1907111C09
        1A2667CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF2
        67CDF2091420070C17060D182F6D990000002F6D99050A14070D1667CDF267CD
        F267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267
        CDF2070912060B152F6D990000002F6D9905081567CDF267CDF267CDF267CDF2
        67CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CD
        F2060B142F6D990000002F6D99050B17070E1B091826081D2B081B29081B2B08
        1C2B081B29081827081E2B081A29081A29081F2D081D2B091522070C16060D16
        2F6D990000002F6D99040D1507101D09192908212C081F2A081E2C081D2C081B
        2A081828081E2B081E2B081F2C08212E081D2B091523070D18050B142F6D9900
        00002F6D99040C1407101A091A2608202C081E2C081A2B081B28081C28081C29
        081C28081B28081C2B081C2C081929091320070B15050A122F6D990000002F6D
        99040913070C17091221081927081828081322081420081924081B2708152208
        131F0815230816260813230A0E1B0709130407112F6D990000002F6D99050710
        050811060B15070E18070E18070B15070B1307101707131A070E15070C11070D
        15070E18070D15070A1206070F04070F2F6D990000002F6D99080D1405070B06
        0D11070E13070D1106080B06080C06090F060B0F070D12070D10070D11070D12
        070D10050A0E04070C080F162F6D990000002F6D992F6D992F6D992F6D992F6D
        992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F
        6D992F6D992F6D992F6D99000000}
    end
    object A2ComboBox_outPower: TA2ComboBox
      Left = 178
      Top = 40
      Width = 74
      Height = 21
      Color = clWhite
      ItemHeight = 13
      TabOrder = 6
      OnDropDown = A2ComboBox_inPowerDropDown
      ADXForm = A2Form
      Picture.Data = {
        07544269746D617022050000424D220500000000000036000000280000001300
        0000150000000100180000000000EC040000202E0000202E0000000000000000
        00002F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D99
        2F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D990000002F6D
        99060D1404060C070C14060F15060D1405050D05060E050A12050A11060A1306
        0912060D16060D18060B1507091305060E070D162F6D990000002F6D9904060D
        06060E070911060D14060B1306060F060811060C15060C1506081006080F060B
        14060B1606081307061006050D04050D2F6D990000002F6D99050814080B160A
        111D09172509162209121C09111E09152509172509121E09121E091624091727
        0914210A0D180808120508112F6D990000002F6D99040B16070F1B091926081E
        2B081C29081A25081926081A29081C2A081B26081825081A29081D2C08192709
        111F070A160509142F6D990000002F6D9905101907121F091C2B08222E081E2A
        081E2A08212D08212F08212D08222B081D29081C2B081F2D081C2A091522070C
        18060D182F6D990000002F6D9905101807121E091B2A08202C081C2A081D2B08
        1F2D081F2D67CDF2081F2D081F2D081B2A081E2C081C29091320070B16060D17
        2F6D990000002F6D99050B16070E1A091826081E2B081B2A081B2B081F2D67CD
        F267CDF267CDF2081F2D081F2D081F2D081A2809101B070811060B152F6D9900
        00002F6D99050913070C15091822081F2C081E2D081A2A67CDF267CDF267CDF2
        67CDF267CDF2081F2D081F2D081825090E19070812060B152F6D990000002F6D
        99050C17070F1A091926081F2C081E2E67CDF267CDF267CDF267CDF267CDF267
        CDF267CDF2081D29081A26091420070C17060D172F6D990000002F6D99050F1B
        07121F091A29081F2C67CDF267CDF267CDF267CDF267CDF267CDF267CDF267CD
        F267CDF2081C27091723070E19060D182F6D990000002F6D99050E1907111C09
        1A2667CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF2
        67CDF2091420070C17060D182F6D990000002F6D99050A14070D1667CDF267CD
        F267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267
        CDF2070912060B152F6D990000002F6D9905081567CDF267CDF267CDF267CDF2
        67CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CD
        F2060B142F6D990000002F6D99050B17070E1B091826081D2B081B29081B2B08
        1C2B081B29081827081E2B081A29081A29081F2D081D2B091522070C16060D16
        2F6D990000002F6D99040D1507101D09192908212C081F2A081E2C081D2C081B
        2A081828081E2B081E2B081F2C08212E081D2B091523070D18050B142F6D9900
        00002F6D99040C1407101A091A2608202C081E2C081A2B081B28081C28081C29
        081C28081B28081C2B081C2C081929091320070B15050A122F6D990000002F6D
        99040913070C17091221081927081828081322081420081924081B2708152208
        131F0815230816260813230A0E1B0709130407112F6D990000002F6D99050710
        050811060B15070E18070E18070B15070B1307101707131A070E15070C11070D
        15070E18070D15070A1206070F04070F2F6D990000002F6D99080D1405070B06
        0D11070E13070D1106080B06080C06090F060B0F070D12070D10070D11070D12
        070D10050A0E04070C080F162F6D990000002F6D992F6D992F6D992F6D992F6D
        992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F
        6D992F6D992F6D992F6D99000000}
    end
    object A2ComboBox_Magic: TA2ComboBox
      Left = 178
      Top = 69
      Width = 74
      Height = 21
      Color = clWhite
      ItemHeight = 13
      TabOrder = 7
      OnDropDown = A2ComboBox_inPowerDropDown
      ADXForm = A2Form
      Picture.Data = {
        07544269746D617022050000424D220500000000000036000000280000001300
        0000150000000100180000000000EC040000202E0000202E0000000000000000
        00002F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D99
        2F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D990000002F6D
        99060D1404060C070C14060F15060D1405050D05060E050A12050A11060A1306
        0912060D16060D18060B1507091305060E070D162F6D990000002F6D9904060D
        06060E070911060D14060B1306060F060811060C15060C1506081006080F060B
        14060B1606081307061006050D04050D2F6D990000002F6D99050814080B160A
        111D09172509162209121C09111E09152509172509121E09121E091624091727
        0914210A0D180808120508112F6D990000002F6D99040B16070F1B091926081E
        2B081C29081A25081926081A29081C2A081B26081825081A29081D2C08192709
        111F070A160509142F6D990000002F6D9905101907121F091C2B08222E081E2A
        081E2A08212D08212F08212D08222B081D29081C2B081F2D081C2A091522070C
        18060D182F6D990000002F6D9905101807121E091B2A08202C081C2A081D2B08
        1F2D081F2D67CDF2081F2D081F2D081B2A081E2C081C29091320070B16060D17
        2F6D990000002F6D99050B16070E1A091826081E2B081B2A081B2B081F2D67CD
        F267CDF267CDF2081F2D081F2D081F2D081A2809101B070811060B152F6D9900
        00002F6D99050913070C15091822081F2C081E2D081A2A67CDF267CDF267CDF2
        67CDF267CDF2081F2D081F2D081825090E19070812060B152F6D990000002F6D
        99050C17070F1A091926081F2C081E2E67CDF267CDF267CDF267CDF267CDF267
        CDF267CDF2081D29081A26091420070C17060D172F6D990000002F6D99050F1B
        07121F091A29081F2C67CDF267CDF267CDF267CDF267CDF267CDF267CDF267CD
        F267CDF2081C27091723070E19060D182F6D990000002F6D99050E1907111C09
        1A2667CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF2
        67CDF2091420070C17060D182F6D990000002F6D99050A14070D1667CDF267CD
        F267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267
        CDF2070912060B152F6D990000002F6D9905081567CDF267CDF267CDF267CDF2
        67CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CD
        F2060B142F6D990000002F6D99050B17070E1B091826081D2B081B29081B2B08
        1C2B081B29081827081E2B081A29081A29081F2D081D2B091522070C16060D16
        2F6D990000002F6D99040D1507101D09192908212C081F2A081E2C081D2C081B
        2A081828081E2B081E2B081F2C08212E081D2B091523070D18050B142F6D9900
        00002F6D99040C1407101A091A2608202C081E2C081A2B081B28081C28081C29
        081C28081B28081C2B081C2C081929091320070B15050A122F6D990000002F6D
        99040913070C17091221081927081828081322081420081924081B2708152208
        131F0815230816260813230A0E1B0709130407112F6D990000002F6D99050710
        050811060B15070E18070E18070B15070B1307101707131A070E15070C11070D
        15070E18070D15070A1206070F04070F2F6D990000002F6D99080D1405070B06
        0D11070E13070D1106080B06080C06090F060B0F070D12070D10070D11070D12
        070D10050A0E04070C080F162F6D990000002F6D992F6D992F6D992F6D992F6D
        992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F
        6D992F6D992F6D992F6D99000000}
    end
    object A2ComboBox_Life: TA2ComboBox
      Left = 178
      Top = 97
      Width = 74
      Height = 21
      Color = clWhite
      ItemHeight = 13
      TabOrder = 8
      OnDropDown = A2ComboBox_inPowerDropDown
      ADXForm = A2Form
      Picture.Data = {
        07544269746D617022050000424D220500000000000036000000280000001300
        0000150000000100180000000000EC040000202E0000202E0000000000000000
        00002F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D99
        2F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D990000002F6D
        99060D1404060C070C14060F15060D1405050D05060E050A12050A11060A1306
        0912060D16060D18060B1507091305060E070D162F6D990000002F6D9904060D
        06060E070911060D14060B1306060F060811060C15060C1506081006080F060B
        14060B1606081307061006050D04050D2F6D990000002F6D99050814080B160A
        111D09172509162209121C09111E09152509172509121E09121E091624091727
        0914210A0D180808120508112F6D990000002F6D99040B16070F1B091926081E
        2B081C29081A25081926081A29081C2A081B26081825081A29081D2C08192709
        111F070A160509142F6D990000002F6D9905101907121F091C2B08222E081E2A
        081E2A08212D08212F08212D08222B081D29081C2B081F2D081C2A091522070C
        18060D182F6D990000002F6D9905101807121E091B2A08202C081C2A081D2B08
        1F2D081F2D67CDF2081F2D081F2D081B2A081E2C081C29091320070B16060D17
        2F6D990000002F6D99050B16070E1A091826081E2B081B2A081B2B081F2D67CD
        F267CDF267CDF2081F2D081F2D081F2D081A2809101B070811060B152F6D9900
        00002F6D99050913070C15091822081F2C081E2D081A2A67CDF267CDF267CDF2
        67CDF267CDF2081F2D081F2D081825090E19070812060B152F6D990000002F6D
        99050C17070F1A091926081F2C081E2E67CDF267CDF267CDF267CDF267CDF267
        CDF267CDF2081D29081A26091420070C17060D172F6D990000002F6D99050F1B
        07121F091A29081F2C67CDF267CDF267CDF267CDF267CDF267CDF267CDF267CD
        F267CDF2081C27091723070E19060D182F6D990000002F6D99050E1907111C09
        1A2667CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF2
        67CDF2091420070C17060D182F6D990000002F6D99050A14070D1667CDF267CD
        F267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267
        CDF2070912060B152F6D990000002F6D9905081567CDF267CDF267CDF267CDF2
        67CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CDF267CD
        F2060B142F6D990000002F6D99050B17070E1B091826081D2B081B29081B2B08
        1C2B081B29081827081E2B081A29081A29081F2D081D2B091522070C16060D16
        2F6D990000002F6D99040D1507101D09192908212C081F2A081E2C081D2C081B
        2A081828081E2B081E2B081F2C08212E081D2B091523070D18050B142F6D9900
        00002F6D99040C1407101A091A2608202C081E2C081A2B081B28081C28081C29
        081C28081B28081C2B081C2C081929091320070B15050A122F6D990000002F6D
        99040913070C17091221081927081828081322081420081924081B2708152208
        131F0815230816260813230A0E1B0709130407112F6D990000002F6D99050710
        050811060B15070E18070E18070B15070B1307101707131A070E15070C11070D
        15070E18070D15070A1206070F04070F2F6D990000002F6D99080D1405070B06
        0D11070E13070D1106080B06080C06090F060B0F070D12070D10070D11070D12
        070D10050A0E04070C080F162F6D990000002F6D992F6D992F6D992F6D992F6D
        992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F6D992F
        6D992F6D992F6D992F6D99000000}
    end
  end
  object A2Form: TA2Form
    Color = clBlack
    ShowMethod = FSM_NONE
    TransParent = False
    Top = 280
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 96
  end
end
