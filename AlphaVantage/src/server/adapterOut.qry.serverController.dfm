object AdapterOutServerController: TAdapterOutServerController
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'AdapterOutQryServerController'
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
    Top = 162
    Width = 1626
    Height = 780
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
        Value = 33.333333333333310000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = ListInflation
        Row = 0
      end
      item
        Column = 1
        Control = ListCpi
        Row = 0
      end
      item
        Column = 2
        Control = ListYield10Y
        Row = 0
      end>
    Locked = True
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    object ListInflation: TControlList
      Left = 1
      Top = 1
      Width = 541
      Height = 778
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
      object LabelInflationData: TLabel
        Left = 0
        Top = 0
        Width = 537
        Height = 32
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alTop
        Caption = 'LabelData'
        ExplicitWidth = 105
      end
    end
    object ListCpi: TControlList
      Left = 542
      Top = 1
      Width = 542
      Height = 778
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
      TabOrder = 1
      OnBeforeDrawItem = ListCpiBeforeDrawItem
      object LabelCpiData: TLabel
        Left = 0
        Top = 0
        Width = 538
        Height = 32
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alTop
        Caption = 'LabelData'
        ExplicitWidth = 105
      end
    end
    object ListYield10Y: TControlList
      Left = 1084
      Top = 1
      Width = 541
      Height = 778
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
      TabOrder = 2
      OnBeforeDrawItem = ListYield10YBeforeDrawItem
      object LabelYield10YData: TLabel
        Left = 0
        Top = 0
        Width = 537
        Height = 32
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alTop
        Caption = 'LabelData'
        ExplicitWidth = 105
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
    object ButtonSave: TButton
      Left = 189
      Top = 17
      Width = 150
      Height = 50
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'Save'
      TabOrder = 1
      OnClick = ButtonSaveClick
    end
  end
  object GridPanel2: TGridPanel
    Left = 0
    Top = 82
    Width = 1626
    Height = 80
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Align = alTop
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 33.333333333333340000
      end
      item
        Value = 33.333333333333340000
      end
      item
        Value = 33.333333333333310000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = LabelInflation
        Row = 0
      end
      item
        Column = 1
        Control = LabelCpi
        Row = 0
      end
      item
        Column = 2
        Control = LabelYield10Y
        Row = 0
      end>
    Locked = True
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 2
    object LabelInflation: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 6
      Width = 530
      Height = 68
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alClient
      Caption = 'LabelInflation'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 158
      ExplicitHeight = 32
    end
    object LabelCpi: TLabel
      AlignWithMargins = True
      Left = 548
      Top = 6
      Width = 530
      Height = 68
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alClient
      Caption = 'LabelCpi'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 97
      ExplicitHeight = 32
    end
    object LabelYield10Y: TLabel
      AlignWithMargins = True
      Left = 1090
      Top = 6
      Width = 530
      Height = 68
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alClient
      Caption = 'LabelYield10Y'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 160
      ExplicitHeight = 32
    end
  end
end
