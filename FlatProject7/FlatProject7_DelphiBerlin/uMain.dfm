object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1050#1074#1072#1088#1090#1080#1088#1099' '#1080' '#1089#1095#1077#1090#1095#1080#1082#1080
  ClientHeight = 346
  ClientWidth = 766
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 766
    Height = 327
    ActivePage = tsFlats
    Align = alClient
    TabOrder = 0
    object tsFlats: TTabSheet
      Caption = #1050#1074#1072#1088#1090#1080#1088#1099
    end
    object tsCounters: TTabSheet
      Caption = #1057#1095#1077#1090#1095#1080#1082#1080
      ImageIndex = 1
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 327
    Width = 766
    Height = 19
    Panels = <
      item
        Width = 200
      end>
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 536
    Top = 88
  end
end
