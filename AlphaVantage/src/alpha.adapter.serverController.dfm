object AlphaAdapterServerController: TAlphaAdapterServerController
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'AlphaAdapterServerController'
  ClientHeight = 942
  ClientWidth = 1626
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -24
  Font.Name = 'Segoe UI'
  Font.Style = []
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 192
  TextHeight = 32
  object GridPanel1: TGridPanel
    Left = 0
    Top = 82
    Width = 1626
    Height = 860
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alClient
    ColumnCollection = <
      item
        Value = 33.333333333333340000
      end
      item
        Value = 33.333333333333340000
      end
      item
        Value = 33.333333333333340000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = ListInflation
        Row = 0
      end>
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    ExplicitLeft = 768
    ExplicitTop = 256
    ExplicitWidth = 370
    ExplicitHeight = 82
    object ListInflation: TControlList
      Left = 1
      Top = 1
      Width = 541
      Height = 858
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alClient
      ItemHeight = 34
      ItemMargins.Left = 0
      ItemMargins.Top = 0
      ItemMargins.Right = 0
      ItemMargins.Bottom = 0
      ParentColor = False
      TabOrder = 0
      OnBeforeDrawItem = ListInflationBeforeDrawItem
      ExplicitLeft = -30
      ExplicitTop = -318
      ExplicitWidth = 400
      ExplicitHeight = 400
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 537
        Height = 32
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alTop
        Caption = 'Label1'
        ExplicitWidth = 69
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1626
    Height = 82
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 1
    ExplicitLeft = 832
    ExplicitTop = 688
    ExplicitWidth = 370
    object ButtonSync: TButton
      Left = 27
      Top = 17
      Width = 150
      Height = 50
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'Syncronize'
      TabOrder = 0
      OnClick = ButtonSyncClick
    end
  end
end
