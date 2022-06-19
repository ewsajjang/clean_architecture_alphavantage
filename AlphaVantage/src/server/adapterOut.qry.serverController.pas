unit adapterOut.qry.serverController;

interface

uses
  portOut.qry.serverUseCase, portOut.cmd.traderUseCase,

  wp.Forms,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ControlList;

type
  TAdapterOutServerController = class(TwpForm)
    ButtonSync: TButton;
    ListInflation: TControlList;
    GridPanel1: TGridPanel;
    Panel1: TPanel;
    LabelInflationData: TLabel;
    ListCpi: TControlList;
    LabelCpiData: TLabel;
    ListYield10Y: TControlList;
    LabelYield10YData: TLabel;
    GridPanel2: TGridPanel;
    LabelInflation: TLabel;
    LabelCpi: TLabel;
    LabelYield10Y: TLabel;
    ButtonSave: TButton;
    procedure FormCreate(Sender: TObject);

    procedure ButtonSyncClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ListInflationBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure ListCpiBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
    procedure ListYield10YBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
  private
    FQryServerUseCase: IQryServerUseCase;
    FCmdTraderUseCase: ICmdTraderUseCase;
  public
  end;

var
  AdapterOutServerController: TAdapterOutServerController;

implementation

{$R *.dfm}

uses
  Spring.Container
  ;

procedure TAdapterOutServerController.ButtonSaveClick(Sender: TObject);
begin
  FCmdTraderUseCase.Save(FQryServerUseCase.BodyEntities);
end;

procedure TAdapterOutServerController.ButtonSyncClick(Sender: TObject);
begin
  FQryServerUseCase.ReqInflation;
  FQryServerUseCase.ReqCpi;
  FQryServerUseCase.ReqYield10Y;
end;

procedure TAdapterOutServerController.FormCreate(Sender: TObject);
begin
  FCmdTraderUseCase := GlobalContainer.Resolve<ICmdTraderUseCase>;

  FQryServerUseCase := GlobalContainer.Resolve<IQryServerUseCase>;
  FQryServerUseCase.Event.OnInflation.Subscribe(
    Self,
    procedure
    begin
      LabelInflation.Caption := FQryServerUseCase.Inflation.ToLabelText;
      ListInflation.ItemCount := FQryServerUseCase.Inflation.DataCnt;
    end);
  FQryServerUseCase.Event.OnCpi.Subscribe(
    Self,
    procedure
    begin
      LabelCpi.Caption := FQryServerUseCase.Cpi.ToLabelText;
      ListCpi.ItemCount := FQryServerUseCase.Cpi.DataCnt;
    end);
  FQryServerUseCase.Event.OnYield10Y.Subscribe(
    Self,
    procedure
    begin
      LabelYield10Y.Caption := FQryServerUseCase.Yield10Y.ToLabelText;
      ListYield10Y.ItemCount := FQryServerUseCase.Yield10Y.DataCnt;
    end);
end;

procedure TAdapterOutServerController.ListCpiBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect;
  AState: TOwnerDrawState);
begin
  if AIndex < FQryServerUseCase.Cpi.DataCnt then
    LabelCpiData.Caption := FQryServerUseCase.Cpi[AIndex].ToLabelText;
end;

procedure TAdapterOutServerController.ListInflationBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  if AIndex < FQryServerUseCase.Inflation.DataCnt then
    LabelInflationData.Caption := FQryServerUseCase.Inflation[AIndex].ToLabelText;
end;

procedure TAdapterOutServerController.ListYield10YBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect;
  AState: TOwnerDrawState);
begin
  if AIndex < FQryServerUseCase.Yield10Y.DataCnt then
    LabelYield10YData.Caption := FQryServerUseCase.Yield10Y[AIndex].ToLabelText;
end;

end.
