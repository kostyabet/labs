object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1041#1077#1090#1077#1085#1103' '#1050'.'#1057'. 351005 '#1083#1072#1073'. 4.2'
  ClientHeight = 397
  ClientWidth = 437
  Color = clBtnFace
  Constraints.MaxWidth = 496
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  TextHeight = 15
  object TaskLabel: TLabel
    Left = 8
    Top = 8
    Width = 424
    Height = 75
    Caption = 
      #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1086#1087#1088#1077#1076#1077#1083#1103#1077#1090' '#1087#1086#1076#1084#1085#1086#1078#1077#1089#1090#1074#1086'(I) '#1080#1079' '#1084#1085#1086#1078#1077#1089#1090#1074#1072' {1..N}. '#1043#1076#1077' N ' +
      #8212' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1082#1086#1086#1088#1076#1080#1085#1072#1090' '#1074#1077#1082#1090#1086#1088#1086#1074' B '#1080' C. '#1057#1091#1084#1084#1072' '#1101#1083#1077#1084#1077#1085#1090#1086#1074' '#1074#1077#1082#1090#1086#1088#1072' B' +
      ' '#1089' '#1095#1080#1089#1083#1072#1084#1080' '#1080#1079' '#1087#1086#1076#1084#1085#1086#1078#1077#1089#1090#1074#1072' I '#1103#1074#1083#1103#1077#1090#1089#1103' '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1081' '#1087#1088#1080' '#1091#1089#1083#1086#1074#1080#1080', ' +
      #1095#1090#1086' '#1089#1091#1084#1084#1072' '#1101#1083#1077#1084#1077#1085#1090#1086#1074' '#1080#1079' '#1084#1085#1086#1078#1077#1089#1090#1074#1072' C '#1089' '#1086#1076#1080#1085#1072#1082#1086#1074#1099#1084#1080' '#1085#1086#1084#1077#1088#1072#1084#1080' '#1085#1077' '#1073#1086#1083 +
      #1100#1096#1077', '#1095#1077#1084' '#1094#1077#1083#1086#1077' '#1095#1080#1089#1083#1086' '#1040'.'
    Constraints.MaxHeight = 82
    Constraints.MaxWidth = 425
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object ALabel: TLabel
    Left = 24
    Top = 102
    Width = 57
    Height = 15
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1040':'
  end
  object NLabel: TLabel
    Left = 240
    Top = 102
    Width = 58
    Height = 15
    Caption = #1042#1074#1077#1076#1080#1090#1077' N:'
  end
  object BVectorLabel: TLabel
    Left = 24
    Top = 128
    Width = 96
    Height = 15
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1074#1077#1082#1090#1086#1088' B:'
    Visible = False
  end
  object CVectorLabel: TLabel
    Left = 24
    Top = 226
    Width = 97
    Height = 15
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1074#1077#1082#1090#1086#1088' C:'
    Visible = False
  end
  object ResultLabel: TLabel
    Left = 8
    Top = 355
    Width = 60
    Height = 15
    Caption = 'ResultLabel'
  end
  object ALabeledEdit: TLabeledEdit
    Left = 87
    Top = 99
    Width = 114
    Height = 23
    EditLabel.Width = 69
    EditLabel.Height = 15
    EditLabel.Caption = 'ALabeledEdit'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Text = ''
    TextHint = 'A'
    OnChange = ALabeledEditChange
    OnContextPopup = ALabeledEditContextPopup
    OnKeyDown = ALabeledEditKeyDown
    OnKeyPress = ALabeledEditKeyPress
  end
  object NLabeledEdit: TLabeledEdit
    Left = 303
    Top = 99
    Width = 74
    Height = 23
    EditLabel.Width = 70
    EditLabel.Height = 15
    EditLabel.Caption = 'NLabeledEdit'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Text = ''
    TextHint = 'N'
    OnChange = NLabeledEditChange
    OnContextPopup = NLabeledEditContextPopup
    OnKeyDown = NLabeledEditKeyDown
    OnKeyPress = NLabeledEditKeyPress
  end
  object BVectorStringGrid: TStringGrid
    Left = 24
    Top = 149
    Width = 388
    Height = 71
    ColCount = 10
    DefaultColWidth = 76
    DefaultRowHeight = 25
    RowCount = 2
    ParentShowHint = False
    ScrollBars = ssHorizontal
    ShowHint = True
    TabOrder = 2
    Visible = False
    OnKeyDown = BVectorStringGridKeyDown
    OnKeyPress = BVectorStringGridKeyPress
    ColWidths = (
      76
      76
      76
      76
      76
      76
      76
      76
      76
      76)
  end
  object CVectorStringGrid: TStringGrid
    Left = 24
    Top = 247
    Width = 388
    Height = 71
    ColCount = 10
    DefaultColWidth = 76
    DefaultRowHeight = 25
    RowCount = 2
    ParentShowHint = False
    ScrollBars = ssHorizontal
    ShowHint = True
    TabOrder = 3
    Visible = False
    OnKeyDown = CVectorStringGridKeyDown
    OnKeyPress = CVectorStringGridKeyPress
  end
  object ResultButton: TButton
    Left = 24
    Top = 324
    Width = 129
    Height = 25
    Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100
    Enabled = False
    TabOrder = 4
    Visible = False
    OnClick = ResultButtonClick
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '.txt'
    Filter = '|*.txt'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 304
    Top = 336
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.txt'
    Filter = '|*.txt'
    Left = 240
    Top = 336
  end
  object MainMenu: TMainMenu
    Left = 368
    Top = 336
    object FileButton: TMenuItem
      Caption = #1060#1072#1081#1083
      object OpenButton: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        ShortCut = 16463
        OnClick = OpenButtonClick
      end
      object SaveButton: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        Enabled = False
        ShortCut = 16467
        OnClick = SaveButtonClick
      end
      object DemarcationLine: TMenuItem
        Caption = '-'
      end
      object ExitButton: TMenuItem
        Caption = #1042#1099#1081#1090#1080
      end
    end
    object InstractionButton: TMenuItem
      Caption = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1103
      OnClick = InstractionButtonClick
    end
    object AboutEditorButton: TMenuItem
      Caption = #1054' '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082#1077
      OnClick = AboutEditorButtonClick
    end
  end
end
