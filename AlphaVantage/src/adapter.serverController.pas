unit adapter.serverController;

interface

uses
  portIn.serverUseCase, portOut.traderUseCase,

  wp.Forms,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ControlList;

type
  TAdapterServerController = class(TwpForm)
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
    FServerUseCase: IPortInServerUseCase;
    FTraderUseCase: IPortOutTraderUseCase;
  public
  end;

var
  AdapterServerController: TAdapterServerController;

implementation

{$R *.dfm}

uses
  Spring.Container
  ;

procedure TAdapterServerController.ButtonSaveClick(Sender: TObject);
begin
  FTraderUseCase.Save;
end;

procedure TAdapterServerController.ButtonSyncClick(Sender: TObject);
begin
  FServerUseCase.ReqInflation;
  FServerUseCase.ReqCpi;
  FServerUseCase.ReqYield10Y;
end;

procedure TAdapterServerController.FormCreate(Sender: TObject);
begin
  FTraderUseCase := GlobalContainer.Resolve<IPortOutTraderUseCase>;

  FServerUseCase := GlobalContainer.Resolve<IPortInServerUseCase>;
  FServerUseCase.Event.OnInflation.Subscribe(
    Self,
    procedure
    begin
      LabelInflation.Caption := FServerUseCase.Inflation.ToLabelText;
      ListInflation.ItemCount := FServerUseCase.Inflation.DataCnt;
    end);
  FServerUseCase.Event.OnCpi.Subscribe(
    Self,
    procedure
    begin
      LabelCpi.Caption := FServerUseCase.Cpi.ToLabelText;
      ListCpi.ItemCount := FServerUseCase.Cpi.DataCnt;
    end);
  FServerUseCase.Event.OnYield10Y.Subscribe(
    Self,
    procedure
    begin
      LabelYield10Y.Caption := FServerUseCase.Yield10Y.ToLabelText;
      ListYield10Y.ItemCount := FServerUseCase.Yield10Y.DataCnt;
    end);
end;

procedure TAdapterServerController.ListCpiBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect;
  AState: TOwnerDrawState);
begin
  if AIndex < FServerUseCase.Cpi.DataCnt then
    LabelCpiData.Caption := FServerUseCase.Cpi[AIndex].ToLabelText;
end;

procedure TAdapterServerController.ListInflationBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  if AIndex < FServerUseCase.Inflation.DataCnt then
    LabelInflationData.Caption := FServerUseCase.Inflation[AIndex].ToLabelText;
end;

procedure TAdapterServerController.ListYield10YBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect;
  AState: TOwnerDrawState);
begin
  if AIndex < FServerUseCase.Yield10Y.DataCnt then
    LabelYield10YData.Caption := FServerUseCase.Yield10Y[AIndex].ToLabelText;
end;

end.
