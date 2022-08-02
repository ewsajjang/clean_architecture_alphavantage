object vMain: TvMain
  Left = 0
  Top = 0
  Caption = 'Hexagonal Clean Architecture - Demo project: AlphaVantage'
  ClientHeight = 409
  ClientWidth = 947
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 947
    Height = 409
    ActivePage = TabAlphaSvrView
    Align = alClient
    TabOrder = 0
    object TabAlphaSvrView: TTabSheet
      Caption = 'Server UseCase'
    end
    object TabTraderView: TTabSheet
      Caption = 'Trader UseCase'
      ImageIndex = 1
    end
  end
end
