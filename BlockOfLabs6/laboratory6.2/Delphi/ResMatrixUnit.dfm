object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'WayForm'
  ClientHeight = 533
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object ResultLabel: TLabel
    Left = 16
    Top = 16
    Width = 56
    Height = 15
    Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090':'
  end
  object ResWayPBox: TPaintBox
    Left = 0
    Top = 0
    Width = 554
    Height = 533
    Align = alClient
    OnPaint = ResWayPBoxPaint
    ExplicitLeft = -8
    ExplicitTop = 8
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
end
