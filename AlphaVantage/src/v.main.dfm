object vMain: TvMain
  Left = 0
  Top = 0
  Caption = 'Hexagonal Clean Architecture - Demo project: AlphaVantage'
  ClientHeight = 818
  ClientWidth = 1894
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -24
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 192
  TextHeight = 32
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 1894
    Height = 818
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ActivePage = TabServerUseCase
    Align = alClient
    TabOrder = 0
    object TabServerUseCase: TTabSheet
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'Server UseCase'
    end
    object TabTraderUseCase: TTabSheet
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'Trader UseCase'
      ImageIndex = 1
    end
  end
end
