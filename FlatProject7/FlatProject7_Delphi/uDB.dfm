object DB: TDB
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 274
  Width = 423
  object FDConnection: TFDConnection
    Params.Strings = (
      'DriverID=MySQL')
    Left = 32
    Top = 32
  end
  object FDPhysMySQLDriverLink: TFDPhysMySQLDriverLink
    Left = 80
    Top = 96
  end
end
