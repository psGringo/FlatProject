object CountersFrame: TCountersFrame
  Left = 0
  Top = 0
  Width = 842
  Height = 415
  TabOrder = 0
  object DBGrid: TDBGrid
    Left = 0
    Top = 65
    Width = 842
    Height = 350
    Align = alClient
    DataSource = DSCounters
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'serialNumber'
        Title.Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088
        Width = 92
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'creationDateTime'
        Title.Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103
        Width = 94
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'lastCheckDate'
        Title.Caption = #1044#1072#1090#1072' '#1087#1086#1074#1077#1088#1082#1080
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nextCheckDate'
        Title.Caption = #1057#1083#1077#1076'. '#1076#1072#1090#1072' '#1087#1086#1074#1077#1088#1082#1080
        Width = 120
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'streetName'
        Title.Caption = #1059#1083#1080#1094#1072
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'houseNumberName'
        Title.Caption = #1044#1086#1084
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'flatNumber'
        Title.Caption = #1050#1074#1072#1088#1090#1080#1088#1072
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'value'
        Title.Caption = #1047#1085#1072#1095#1077#1085#1080#1077
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'measureDateTime'
        Title.Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
        Width = 102
        Visible = True
      end>
  end
  object tbit: TPanel
    Left = 0
    Top = 0
    Width = 842
    Height = 33
    Align = alTop
    TabOrder = 1
    object bAdd: TBitBtn
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 75
      Height = 25
      Align = alLeft
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      TabOrder = 0
      OnClick = bAddClick
    end
    object bEdit: TBitBtn
      AlignWithMargins = True
      Left = 85
      Top = 4
      Width = 92
      Height = 25
      Align = alLeft
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      TabOrder = 1
      OnClick = bEditClick
    end
    object bDelete: TBitBtn
      AlignWithMargins = True
      Left = 183
      Top = 4
      Width = 92
      Height = 25
      Align = alLeft
      Caption = #1059#1076#1072#1083#1080#1090#1100
      TabOrder = 2
      OnClick = bDeleteClick
    end
    object bAddNewData: TBitBtn
      AlignWithMargins = True
      Left = 281
      Top = 4
      Width = 163
      Height = 25
      Align = alLeft
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1086#1074#1099#1077' '#1087#1086#1082#1072#1079#1072#1085#1080#1103
      TabOrder = 3
      OnClick = bAddNewDataClick
    end
  end
  object pCountersToCheck: TPanel
    Left = 0
    Top = 33
    Width = 842
    Height = 32
    Align = alTop
    TabOrder = 2
    object lStreets: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 33
      Height = 24
      Align = alLeft
      Caption = #1059#1083#1080#1094#1099
      ExplicitHeight = 13
    end
    object lHouseNumbers: TLabel
      AlignWithMargins = True
      Left = 187
      Top = 4
      Width = 74
      Height = 24
      Align = alLeft
      AutoSize = False
      Caption = #1053#1086#1084#1077#1088#1072' '#1076#1086#1084#1086#1074
      ExplicitLeft = 191
    end
    object cbStreets: TDBLookupComboBox
      AlignWithMargins = True
      Left = 43
      Top = 4
      Width = 138
      Height = 21
      Align = alLeft
      KeyField = 'id'
      ListField = 'name'
      ListSource = DSStreets
      TabOrder = 0
      OnCloseUp = cbStreetsCloseUp
    end
    object cbHouseNumbers: TDBLookupComboBox
      AlignWithMargins = True
      Left = 267
      Top = 4
      Width = 88
      Height = 21
      Align = alLeft
      KeyField = 'id'
      ListField = 'name'
      ListSource = DSHouseNumbers
      TabOrder = 1
      OnCloseUp = cbHouseNumbersCloseUp
    end
    object bFilter: TButton
      AlignWithMargins = True
      Left = 361
      Top = 4
      Width = 180
      Height = 24
      Align = alLeft
      Caption = #1060#1080#1083#1100#1090#1088' '#1089#1095#1077#1090#1095#1080#1082#1086#1074' '#1085#1072' '#1087#1086#1074#1077#1088#1082#1091
      TabOrder = 2
      OnClick = bFilterClick
    end
    object bFlushFilter: TButton
      AlignWithMargins = True
      Left = 547
      Top = 4
      Width = 113
      Height = 24
      Align = alLeft
      Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
      TabOrder = 3
      OnClick = bFlushFilterClick
    end
  end
  object FDConnectionTemp: TFDConnection
    Params.Strings = (
      'Database=flat_db'
      'User_Name=root'
      'Password=masterkey'
      'DriverID=MySQL')
    Connected = True
    Left = 48
    Top = 104
  end
  object qFlatNumbers: TFDQuery
    Connection = FDConnectionTemp
    SQL.Strings = (
      
        'SELECT * FROM flat_db.flats where houseNumbers_id=:houseNumbers_' +
        'id;')
    Left = 352
    Top = 184
    ParamData = <
      item
        Name = 'HOUSENUMBERS_ID'
        DataType = ftWideString
        ParamType = ptInput
        Value = '%%'
      end>
  end
  object qCounters: TFDQuery
    Connection = FDConnectionTemp
    SQL.Strings = (
      'SELECT'
      'c.id,'
      'c.serialNumber,'
      'c.creationDateTime,'
      'c.lastCheckDate,'
      'c.nextCheckDate,'
      '#street'
      '(select name from streets where id=('
      'select streets_id from housenumbers where '
      
        'id=(select houseNumbers_id from flats where counters_id=c.id))) ' +
        'as streetName,'
      '#houseNumber'
      '(select name from housenumbers where '
      
        'id=(select houseNumbers_id from flats where counters_id=c.id)) a' +
        's houseNumberName,'
      '#flatNumber'
      
        '(select flatNumber from flats where counters_id=c.id) as flatNum' +
        'ber,'
      '# value'
      
        '(SELECT value FROM flat_db.counterdata where counters_id=c.id or' +
        'der by id desc limit 1) as value,'
      '/*'
      '(SELECT value FROM flat_db.counterdata where counters_id=c.id'
      
        'and id=( select Max(Id) from counterdata where counters_id=(Sele' +
        'ct counters_id from flats '
      'where id=(select flatNumber from flats where counters_id=c.id)'
      ''
      '))) as value,'
      '*/'
      '# measureDateTime'
      
        '(SELECT measureDateTime FROM flat_db.counterdata where counters_' +
        'id=c.id order by id desc limit 1) as measureDateTime'
      '/*'
      
        '(SELECT measureDateTime FROM flat_db.counterdata where counters_' +
        'id=c.id'
      
        'and id=( select Max(Id) from counterdata where counters_id=(Sele' +
        'ct counters_id from flats '
      'where id=(select flatNumber from flats where counters_id=c.id)'
      '))) as measureDateTime'
      '*/'
      'FROM '
      'counters c'
      'order by id desc')
    Left = 80
    Top = 160
  end
  object qHouseNumbers: TFDQuery
    Connection = FDConnectionTemp
    SQL.Strings = (
      'SELECT * FROM flat_db.housenumbers where streets_id=:streets_id;')
    Left = 256
    Top = 168
    ParamData = <
      item
        Name = 'STREETS_ID'
        DataType = ftWideString
        ParamType = ptInput
        Value = '%%'
      end>
  end
  object qStreets: TFDQuery
    Active = True
    Connection = FDConnectionTemp
    SQL.Strings = (
      'select*from streets')
    Left = 168
    Top = 136
  end
  object DSCounters: TDataSource
    DataSet = qCounters
    Left = 80
    Top = 224
  end
  object DSStreets: TDataSource
    DataSet = qStreets
    Left = 184
    Top = 208
  end
  object DSHouseNumbers: TDataSource
    DataSet = qHouseNumbers
    Left = 272
    Top = 240
  end
  object qCountersFilter: TFDQuery
    Connection = FDConnectionTemp
    SQL.Strings = (
      'SELECT'
      'c.id, '
      'c.serialNumber,'
      'c.creationDateTime,'
      'c.lastCheckDate,'
      'c.nextCheckDate,'
      '#street'
      '(select name from streets where id=('
      'select streets_id from housenumbers where '
      
        'id=(select houseNumbers_id from flats where counters_id=c.id))) ' +
        'as streetName,'
      '#houseNumber'
      '(select name from housenumbers where '
      
        'id=(select houseNumbers_id from flats where counters_id=c.id)) a' +
        's houseNumberName,'
      '#flatNumber'
      
        '(select flatNumber from flats where counters_id=c.id) as flatNum' +
        'ber,'
      '# value'
      '(SELECT value FROM flat_db.counterdata where counters_id=c.id'
      
        'and id=( select Max(Id) from counterdata where counters_id=(Sele' +
        'ct counters_id from flats '
      'where id=(select flatNumber from flats where counters_id=c.id)'
      '))) as value,'
      '# measureDateTime'
      
        '(SELECT measureDateTime FROM flat_db.counterdata where counters_' +
        'id=c.id'
      
        'and id=( select Max(Id) from counterdata where counters_id=(Sele' +
        'ct counters_id from flats '
      'where id=(select flatNumber from flats where counters_id=c.id)'
      '))) as measureDateTime'
      'FROM '
      'counters c'
      'where '
      'date(c.NextCheckDate)<=date(Now())'
      'and'
      '(select id from streets where id=('
      'select streets_id from housenumbers where '
      
        'id=(select houseNumbers_id from flats where counters_id=c.id)))=' +
        ':streetId'
      'and'
      '(select id from housenumbers where '
      
        'id=(select houseNumbers_id from flats where counters_id=c.id)) =' +
        ':houseNumberId'
      'order by id desc'
      ''
      ''
      '')
    Left = 24
    Top = 184
    ParamData = <
      item
        Name = 'STREETID'
        DataType = ftWideString
        ParamType = ptInput
        Value = '%%'
      end
      item
        Name = 'HOUSENUMBERID'
        DataType = ftWideString
        ParamType = ptInput
        Value = '%%'
      end>
  end
end
