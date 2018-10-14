object AddNewCounterData: TAddNewCounterData
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1085#1086#1074#1099#1093' '#1087#1086#1082#1072#1079#1072#1085#1080#1081' '#1076#1083#1103' '#1089#1095#1077#1090#1095#1080#1082#1072
  ClientHeight = 325
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lInt: TLabel
    Left = 40
    Top = 21
    Width = 96
    Height = 13
    Caption = #1062#1077#1083#1072#1103' '#1095#1072#1089#1090#1100' '#1095#1080#1089#1083#1072
  end
  object Label1: TLabel
    Left = 176
    Top = 21
    Width = 108
    Height = 13
    Caption = #1044#1088#1086#1073#1085#1072#1103' '#1095#1072#1089#1090#1100' '#1095#1080#1089#1083#1072
  end
  object Label2: TLabel
    Left = 40
    Top = 80
    Width = 124
    Height = 13
    Caption = #1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' '#1087#1086#1082#1072#1079#1072#1085#1080#1103
  end
  object seInt: TSpinEdit
    Left = 40
    Top = 40
    Width = 96
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 0
  end
  object seFrac: TSpinEdit
    Left = 176
    Top = 40
    Width = 108
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object pBottom: TPanel
    Left = 0
    Top = 284
    Width = 334
    Height = 41
    Align = alBottom
    Caption = 'pBottom'
    ShowCaption = False
    TabOrder = 2
    object bOk: TBitBtn
      Left = 176
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Ok'
      TabOrder = 0
      OnClick = bOkClick
    end
    object bCancel: TBitBtn
      Left = 61
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      OnClick = bCancelClick
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 112
    Width = 334
    Height = 172
    Align = alBottom
    DataSource = DSCounterData
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'measureDateTime'
        Title.Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'value'
        Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077
        Visible = True
      end>
  end
  object FDConnectionTemp: TFDConnection
    Params.Strings = (
      'Database=flat_db'
      'User_Name=root'
      'Password=masterkey'
      'DriverID=MySQL')
    Connected = True
    Left = 56
    Top = 144
  end
  object qCounterData: TFDQuery
    Connection = FDConnectionTemp
    SQL.Strings = (
      
        'SELECT * FROM flat_db.counterdata where counters_id=:counters_id' +
        ' order by id desc;')
    Left = 128
    Top = 168
    ParamData = <
      item
        Name = 'COUNTERS_ID'
        ParamType = ptInput
      end>
  end
  object DSCounterData: TDataSource
    DataSet = qCounterData
    Left = 184
    Top = 208
  end
end
