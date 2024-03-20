object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1041#1077#1090#1077#1085#1103' '#1050'. '#1057'. 351005 '#1083#1072#1073'. 6.2'
  ClientHeight = 436
  ClientWidth = 606
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  TextHeight = 15
  object TaskLabel: TLabel
    Left = 14
    Top = 8
    Width = 584
    Height = 60
    Caption = 
      #1044#1072#1085#1072' '#1084#1072#1090#1088#1080#1094#1072' a(m,n). '#1053#1072#1081#1090#1080' '#1074' '#1085#1077#1081' '#1087#1091#1090#1100' '#1086#1090' '#1101#1083#1077#1084#1077#1085#1090#1072' a[i1,j1] '#1076#1086' '#1101#1083 +
      #1077#1084#1077#1085#1090#1072' a[i2,j2] '#1089' '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1081' '#1089#1091#1084#1084#1086#1081'. '#1061#1086#1076#1080#1090#1100' '#1084#1086#1078#1085#1086' '#1087#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1072 +
      #1083#1103#1084' '#1080' '#1074#1077#1088#1090#1080#1082#1072#1083#1103#1084'. '#1050#1072#1078#1076#1099#1081' '#1101#1083#1077#1084#1077#1085#1090' '#1084#1072#1090#1088#1080#1094#1099' '#1084#1086#1078#1077#1090' '#1074#1093#1086#1076#1080#1090#1100' '#1074' '#1087#1091#1090#1100' '#1085#1077 +
      ' '#1073#1086#1083#1077#1077' '#1086#1076#1085#1086#1075#1086' '#1088#1072#1079#1072'.'
    Constraints.MaxHeight = 60
    Constraints.MaxWidth = 584
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object MatrixSizeLabel: TLabel
    Left = 88
    Top = 85
    Width = 142
    Height = 15
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1088#1072#1079#1084#1077#1088' '#1084#1072#1090#1088#1080#1094#1099':'
  end
  object SpeedButton1: TSpeedButton
    Left = 88
    Top = 117
    Width = 441
    Height = 22
    Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1084#1072#1090#1088#1080#1094#1091
  end
  object MRowsLEdit: TLabeledEdit
    Left = 260
    Top = 82
    Width = 121
    Height = 23
    Hint = #1050#1086#1083'-'#1074#1086' '#1089#1090#1088#1086#1082
    EditLabel.Width = 65
    EditLabel.Height = 15
    EditLabel.Caption = 'MRowsLEdit'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Text = ''
    TextHint = 'm'
  end
  object NColsLEdit: TLabeledEdit
    Left = 408
    Top = 82
    Width = 121
    Height = 23
    Hint = #1050#1086#1083'-'#1074#1086' '#1089#1090#1086#1083#1073#1094#1086#1074
    EditLabel.Width = 58
    EditLabel.Height = 15
    EditLabel.Caption = 'NColsLEdit'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Text = ''
    TextHint = 'n'
  end
  object MainMenu: TMainMenu
    Left = 24
    Top = 24
    object FileBox: TMenuItem
      Caption = #1060#1072#1081#1083
      object OpenFromFile: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
      end
      object SaveInFile: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      end
      object Line: TMenuItem
        Caption = '-'
      end
      object CloseButton: TMenuItem
        Caption = #1042#1099#1081#1090#1080
      end
    end
    object Instraction: TMenuItem
      Caption = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1103
    end
    object AboutEditor: TMenuItem
      Caption = #1054' '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082#1077
    end
  end
end
