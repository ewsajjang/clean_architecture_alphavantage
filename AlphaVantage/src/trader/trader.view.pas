unit trader.view;

interface

uses
  trader.entities, trader.input, trader.output,

  wp.log, Spring.Container.Common,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Data.DB, Aurelius.Bind.BaseDataset, Aurelius.Bind.Dataset, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, DBAdvGrid,
  System.Generics.Collections
  ;

type
  TtraderView = class(TwpLogForm)
    Grid: TDBAdvGrid;
    Dataset: TAureliusDataset;
    DataSource: TDataSource;
    DatasetSelf: TAureliusEntityField;
    DatasetID: TLargeintField;
    DatasetName: TStringField;
    DatasetInterval: TStringField;
    DatasetUnit: TStringField;
    procedure FormCreate(Sender: TObject);
  private
    FIndicators: TList<TIndicator>;
    FTraderInput: ITraderInput;
    FTraderOutputQry: ITraderOutputQry;
    procedure LoadIndicators(AList: TIndicatorList);
  public
  end;

var
  traderView: TtraderView;

implementation

{$R *.dfm}

uses
  Spring.Container
  ;

procedure TtraderView.FormCreate(Sender: TObject);
begin
  Log := TwpLoggerFactory.CreateSingle(ClassName);

  FTraderOutputQry := GlobalContainer.Resolve<ITraderOutputQry>;
  FTraderOutputQry.Event.OnLoadIndicators.Subscribe(
    Self,
    procedure(AList: TIndicatorList)
    begin
      FIndicators := AList;
      LoadIndicators(FIndicators);
    end);

  FTraderInput := GlobalContainer.Resolve<ITraderInput>;
  FTraderInput.Event.OnSave.Subscribe(
    Self,
    procedure
    begin
      FTraderOutputQry.LoadIndicator;
    end);
end;

procedure TtraderView.LoadIndicators(AList: TIndicatorList);
begin
  DataSet.DisableControls;
  try
    if DataSet.Active then
      DataSet.Close;
    DataSet.SetSourceList(AList);
    DataSet.Open;
  finally
    DataSet.EnableControls;
  end;
end;

end.
