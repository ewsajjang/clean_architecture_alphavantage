object alphaSvrView: TalphaSvrView
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'AdapterOutQryServerController'
  ClientHeight = 471
  ClientWidth = 813
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Visible = True
  OnCreate = FormCreate
  TextHeight = 15
  object GridPanel1: TGridPanel
    Left = 0
    Top = 81
    Width = 813
    Height = 390
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
      Width = 270
      Height = 388
      Align = alClient
      ItemHeight = 17
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
        Width = 52
        Height = 15
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alTop
        Caption = 'LabelData'
      end
    end
    object ListCpi: TControlList
      Left = 271
      Top = 1
      Width = 271
      Height = 388
      Align = alClient
      ItemHeight = 17
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
        Width = 52
        Height = 15
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alTop
        Caption = 'LabelData'
      end
    end
    object ListYield10Y: TControlList
      Left = 542
      Top = 1
      Width = 270
      Height = 388
      Align = alClient
      ItemHeight = 17
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
        Width = 52
        Height = 15
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alTop
        Caption = 'LabelData'
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 813
    Height = 41
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 1
    object ButtonSync: TButton
      Left = 14
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Syncronize'
      TabOrder = 0
      OnClick = ButtonSyncClick
    end
    object ButtonSave: TButton
      Left = 95
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Save'
      TabOrder = 1
      OnClick = ButtonSaveClick
    end
  end
  object GridPanel2: TGridPanel
    Left = 0
    Top = 41
    Width = 813
    Height = 40
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
      Left = 3
      Top = 3
      Width = 76
      Height = 15
      Align = alClient
      Caption = 'LabelInflation'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabelCpi: TLabel
      AlignWithMargins = True
      Left = 274
      Top = 3
      Width = 46
      Height = 15
      Align = alClient
      Caption = 'LabelCpi'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LabelYield10Y: TLabel
      AlignWithMargins = True
      Left = 545
      Top = 3
      Width = 77
      Height = 15
      Align = alClient
      Caption = 'LabelYield10Y'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
end
