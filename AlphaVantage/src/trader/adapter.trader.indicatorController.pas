unit adapter.trader.indicatorController;

interface

uses
  domain.traderEntities, portOut.qry.traderUseCase, portOut.cmd.traderUseCase,

  wp.log,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Data.DB, Aurelius.Bind.BaseDataset, Aurelius.Bind.Dataset, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid, DBAdvGrid,
  System.Generics.Collections
  ;

type
  TAdapterIndicatorControl = class(TwpLogForm)
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
    FCmdTraderUseCase: ICmdTraderUseCase;
    FQryTraderUseCase: IQryTraderUseCase;
    procedure LoadIndicators(AList: TIndicatorList);
  public
  end;

var
  AdapterIndicatorControl: TAdapterIndicatorControl;

implementation

{$R *.dfm}

uses
  Spring.Container
  ;

procedure TAdapterIndicatorControl.FormCreate(Sender: TObject);
begin
  Log := TwpLoggerFactory.CreateSingle(ClassName);

  FQryTraderUseCase := GlobalContainer.Resolve<IQryTraderUseCase>;
  FQryTraderUseCase.Event.OnLoadIndicators.Subscribe(
    Self,
    procedure(AList: TIndicatorList)
    begin
      FIndicators := AList;
      LoadIndicators(FIndicators);
    end);

  FCmdTraderUseCase := GlobalContainer.Resolve<ICmdTraderUseCase>;
  FCmdTraderUseCase.Event.OnSave.Subscribe(
    Self,
    procedure
    begin
      FQryTraderUseCase.LoadIndicator;
    end);
end;

procedure TAdapterIndicatorControl.LoadIndicators(AList: TIndicatorList);
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
