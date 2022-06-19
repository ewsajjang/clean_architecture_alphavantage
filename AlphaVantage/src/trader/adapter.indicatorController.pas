unit adapter.indicatorController;

interface

uses
  portOut.traderUseCase, portIn.traderUseCase, domain.traderEntities,

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
    FPortOutTraderUseCase: IPortOutTraderUseCase;
    FPortInTraderUseCase: IPortInTraderUseCase;
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

  FPortOutTraderUseCase := GlobalContainer.Resolve<IPortOutTraderUseCase>;
  FPortOutTraderUseCase.PortOutEvent.OnSave.Subscribe(
    Self,
    procedure
    begin
      FPortInTraderUseCase.LoadIndicator;
    end);

  FPortInTraderUseCase := GlobalContainer.Resolve<IPortInTraderUseCase>;
  FPortInTraderUseCase.Event.OnIndicatorList.Subscribe(
    Self,
    procedure(AList: TIndicatorList)
    begin
      FIndicators := AList;
      LoadIndicators(FIndicators);
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
