object factoryDB: TfactoryDB
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 830
  Width = 1000
  PixelsPerInch = 192
  object FDConn: TFDConnection
    Params.Strings = (
      'JournalMode=Memory'
      'DriverID=SQLite')
    Left = 80
    Top = 48
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrDefault
    Left = 80
    Top = 160
  end
end
