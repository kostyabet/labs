object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1041#1077#1090#1077#1085#1103' '#1050'. '#1057'. 351005 '#1083#1072#1073'. 6.2'
  ClientHeight = 445
  ClientWidth = 536
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnHelp = FormHelp
  TextHeight = 15
  object TaskLabel: TLabel
    Left = 8
    Top = 8
    Width = 529
    Height = 80
    Caption = 
      #1044#1072#1085#1072' '#1084#1072#1090#1088#1080#1094#1072' a(m,n). '#1053#1072#1081#1090#1080' '#1074' '#1085#1077#1081' '#1087#1091#1090#1100' '#1086#1090' '#1101#1083#1077#1084#1077#1085#1090#1072' a[i1,j1] '#1076#1086' '#1101#1083 +
      #1077#1084#1077#1085#1090#1072' a[i2,j2] '#1089' '#1084#1072#1082#1089#1080#1084#1072#1083#1100#1085#1086#1081' '#1089#1091#1084#1084#1086#1081'. '#1061#1086#1076#1080#1090#1100' '#1084#1086#1078#1085#1086' '#1087#1086' '#1075#1086#1088#1080#1079#1086#1085#1090#1072 +
      #1083#1103#1084' '#1080' '#1074#1077#1088#1090#1080#1082#1072#1083#1103#1084'. '#1050#1072#1078#1076#1099#1081' '#1101#1083#1077#1084#1077#1085#1090' '#1084#1072#1090#1088#1080#1094#1099' '#1084#1086#1078#1077#1090' '#1074#1093#1086#1076#1080#1090#1100' '#1074' '#1087#1091#1090#1100' '#1085#1077 +
      ' '#1073#1086#1083#1077#1077' '#1086#1076#1085#1086#1075#1086' '#1088#1072#1079#1072'.'
    Constraints.MaxHeight = 80
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
    Left = 48
    Top = 94
    Width = 142
    Height = 15
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1088#1072#1079#1084#1077#1088' '#1084#1072#1090#1088#1080#1094#1099':'
  end
  object StartPointLabel: TLabel
    Left = 48
    Top = 320
    Width = 145
    Height = 15
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1085#1072#1095#1072#1083#1100#1085#1091#1102' '#1090#1086#1095#1082#1091':'
    Visible = False
  end
  object EndPointLabel: TLabel
    Left = 48
    Top = 349
    Width = 139
    Height = 15
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1082#1086#1085#1077#1095#1085#1091#1102' '#1090#1086#1095#1082#1091':'
    Visible = False
  end
  object MRowsLEdit: TLabeledEdit
    Left = 196
    Top = 91
    Width = 145
    Height = 23
    Hint = #1050#1086#1083'-'#1074#1086' '#1089#1090#1088#1086#1082
    EditLabel.Width = 65
    EditLabel.Height = 15
    EditLabel.Caption = 'MRowsLEdit'
    MaxLength = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Text = ''
    TextHint = 'm'
    OnChange = MRowsLEditChange
    OnContextPopup = MRowsLEditContextPopup
    OnKeyDown = MRowsLEditKeyDown
    OnKeyPress = MRowsLEditKeyPress
  end
  object NColsLEdit: TLabeledEdit
    Left = 347
    Top = 91
    Width = 142
    Height = 23
    Hint = #1050#1086#1083'-'#1074#1086' '#1089#1090#1086#1083#1073#1094#1086#1074
    EditLabel.Width = 58
    EditLabel.Height = 15
    EditLabel.Caption = 'NColsLEdit'
    MaxLength = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    Text = ''
    TextHint = 'n'
    OnChange = NColsLEditChange
    OnContextPopup = NColsLEditContextPopup
    OnKeyDown = NColsLEditKeyDown
    OnKeyPress = NColsLEditKeyPress
  end
  object MassiveStGrid: TStringGrid
    Left = 22
    Top = 159
    Width = 493
    Height = 152
    ColCount = 6
    DefaultColWidth = 81
    FixedCols = 0
    RowCount = 6
    FixedRows = 0
    ScrollBars = ssNone
    TabOrder = 3
    Visible = False
    OnKeyDown = MassiveStGridKeyDown
    OnKeyPress = MassiveStGridKeyPress
    OnKeyUp = MassiveStGridKeyUp
  end
  object IStartPointLEdit: TLabeledEdit
    Left = 199
    Top = 317
    Width = 142
    Height = 23
    Hint = #1050#1086#1083'-'#1074#1086' '#1089#1090#1088#1086#1082
    EditLabel.Width = 65
    EditLabel.Height = 15
    EditLabel.Caption = 'MRowsLEdit'
    MaxLength = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Text = ''
    TextHint = 'i1'
    Visible = False
    OnChange = IStartPointLEditChange
    OnContextPopup = IStartPointLEditContextPopup
    OnKeyDown = IStartPointLEditKeyDown
    OnKeyPress = IStartPointLEditKeyPress
  end
  object JStartPointLEdit: TLabeledEdit
    Left = 347
    Top = 317
    Width = 142
    Height = 23
    Hint = #1050#1086#1083'-'#1074#1086' '#1089#1090#1086#1083#1073#1094#1086#1074
    EditLabel.Width = 58
    EditLabel.Height = 15
    EditLabel.Caption = 'NColsLEdit'
    MaxLength = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Text = ''
    TextHint = 'j1'
    Visible = False
    OnChange = JStartPointLEditChange
    OnContextPopup = JStartPointLEditContextPopup
    OnKeyDown = JStartPointLEditKeyDown
    OnKeyPress = JStartPointLEditKeyPress
  end
  object IEndPointLEdit: TLabeledEdit
    Left = 199
    Top = 346
    Width = 142
    Height = 23
    Hint = #1050#1086#1083'-'#1074#1086' '#1089#1090#1088#1086#1082
    EditLabel.Width = 65
    EditLabel.Height = 15
    EditLabel.Caption = 'MRowsLEdit'
    MaxLength = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Text = ''
    TextHint = 'i2'
    Visible = False
    OnChange = IEndPointLEditChange
    OnContextPopup = IEndPointLEditContextPopup
    OnKeyDown = IEndPointLEditKeyDown
    OnKeyPress = IEndPointLEditKeyPress
  end
  object JEndPointLEdit: TLabeledEdit
    Left = 347
    Top = 346
    Width = 142
    Height = 23
    Hint = #1050#1086#1083'-'#1074#1086' '#1089#1090#1086#1083#1073#1094#1086#1074
    EditLabel.Width = 58
    EditLabel.Height = 15
    EditLabel.Caption = 'NColsLEdit'
    MaxLength = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    Text = ''
    TextHint = 'j2'
    Visible = False
    OnChange = JEndPointLEditChange
    OnContextPopup = JEndPointLEditContextPopup
    OnKeyDown = JEndPointLEditKeyDown
    OnKeyPress = JEndPointLEditKeyPress
  end
  object InputElemButton: TButton
    Left = 48
    Top = 120
    Width = 441
    Height = 33
    Caption = #1042#1074#1077#1089#1090#1080' '#1101#1083#1077#1084#1077#1085#1090#1099' '#1084#1072#1089#1089#1080#1074#1072
    Enabled = False
    TabOrder = 2
    OnClick = InputElemButtonClick
  end
  object ResultSpButton: TButton
    Left = 48
    Top = 375
    Width = 441
    Height = 32
    Caption = #1053#1072#1081#1090#1080' '#1089#1072#1084#1099#1081' '#1076#1083#1080#1085#1085#1099#1081' '#1087#1091#1090#1100
    Enabled = False
    TabOrder = 8
    Visible = False
    OnClick = ResultSpButtonClick
  end
  object ViewWayButton: TButton
    Left = 48
    Top = 413
    Width = 441
    Height = 25
    Caption = #1055#1088#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090
    TabOrder = 9
    Visible = False
    OnClick = ViewWayButtonClick
  end
  object MainMenu: TMainMenu
    Left = 24
    Top = 24
    object FileBox: TMenuItem
      Caption = #1060#1072#1081#1083
      object OpenFromFile: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        OnClick = OpenFromFileClick
      end
      object SaveInFile: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        Enabled = False
        OnClick = SaveInFileClick
      end
      object Line: TMenuItem
        Caption = '-'
      end
      object CloseButton: TMenuItem
        Caption = #1042#1099#1081#1090#1080
        OnClick = CloseButtonClick
      end
    end
    object Instraction: TMenuItem
      Caption = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1103
      OnClick = InstractionClick
    end
    object AboutEditor: TMenuItem
      Caption = #1054' '#1088#1072#1079#1088#1072#1073#1086#1090#1095#1080#1082#1077
      OnClick = AboutEditorClick
    end
  end
  object OpenDialog: TOpenDialog
    Filter = '*.txt|*.txt'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 104
    Top = 24
  end
  object SaveDialog: TSaveDialog
    Filter = '*.txt|*.txt'
    Left = 184
    Top = 24
  end
end
