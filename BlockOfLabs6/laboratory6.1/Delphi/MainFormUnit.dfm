object ClockForm: TClockForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1041#1077#1090#1077#1085#1103' '#1050'. '#1057'. 351005 '#1083#1072#1073'. 6.1'
  ClientHeight = 596
  ClientWidth = 510
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  TextHeight = 15
  object ClockStartSpeedButton: TSpeedButton
    Left = 152
    Top = 520
    Width = 217
    Height = 33
    Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1090#1072#1081#1084#1077#1088
    OnClick = ClockStartSpeedButtonClick
  end
  object PickPlayer: TMediaPlayer
    Left = 8
    Top = 559
    Width = 253
    Height = 29
    DoubleBuffered = True
    FileName = 'tick.wav'
    Visible = False
    ParentDoubleBuffered = False
    TabOrder = 0
  end
  object MainMenu: TMainMenu
    Left = 32
    Top = 504
    object FileList: TMenuItem
      Caption = #1060#1072#1081#1083
      object Exit: TMenuItem
        Caption = #1042#1099#1081#1090#1080
        ShortCut = 16465
        OnClick = ExitClick
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
  object SecondTimer: TTimer
    Enabled = False
    OnTimer = SecondTimerTimer
    Left = 96
    Top = 504
  end
end
