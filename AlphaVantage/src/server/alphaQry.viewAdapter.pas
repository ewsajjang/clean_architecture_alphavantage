unit alphaQry.viewAdapter;

interface

uses
  alphaQry.outputPort, portOut.cmd.traderUseCase,

  wp.Forms,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ControlList;

type
  TalphaQryViewAdapter = class(TwpForm)
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
    FAlphaQryOutPort: IAlphaQryOutputPort;
    FCmdTraderUseCase: ICmdTraderUseCase;
  public
  end;

var
  alphaQryViewAdapter: TalphaQryViewAdapter;

implementation

{$R *.dfm}

uses
  Spring.Container
  ;

procedure TalphaQryViewAdapter.ButtonSaveClick(Sender: TObject);
begin
  FCmdTraderUseCase.Save(FAlphaQryOutPort.BodyEntities);
end;

procedure TalphaQryViewAdapter.ButtonSyncClick(Sender: TObject);
begin
  FAlphaQryOutPort.ReqInflation;
  FAlphaQryOutPort.ReqCpi;
  FAlphaQryOutPort.ReqYield10Y;
end;

procedure TalphaQryViewAdapter.FormCreate(Sender: TObject);
begin
  FCmdTraderUseCase := GlobalContainer.Resolve<ICmdTraderUseCase>;

  FAlphaQryOutPort := GlobalContainer.Resolve<IAlphaQryOutputPort>;
  FAlphaQryOutPort.Event.OnInflation.Subscribe(
    Self,
    procedure
    begin
      LabelInflation.Caption := FAlphaQryOutPort.Inflation.ToLabelText;
      ListInflation.ItemCount := FAlphaQryOutPort.Inflation.DataCnt;
    end);
  FAlphaQryOutPort.Event.OnCpi.Subscribe(
    Self,
    procedure
    begin
      LabelCpi.Caption := FAlphaQryOutPort.Cpi.ToLabelText;
      ListCpi.ItemCount := FAlphaQryOutPort.Cpi.DataCnt;
    end);
  FAlphaQryOutPort.Event.OnYield10Y.Subscribe(
    Self,
    procedure
    begin
      LabelYield10Y.Caption := FAlphaQryOutPort.Yield10Y.ToLabelText;
      ListYield10Y.ItemCount := FAlphaQryOutPort.Yield10Y.DataCnt;
    end);
end;

procedure TalphaQryViewAdapter.ListCpiBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect;
  AState: TOwnerDrawState);
begin
  if AIndex < FAlphaQryOutPort.Cpi.DataCnt then
    LabelCpiData.Caption := FAlphaQryOutPort.Cpi[AIndex].ToLabelText;
end;

procedure TalphaQryViewAdapter.ListInflationBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  if AIndex < FAlphaQryOutPort.Inflation.DataCnt then
    LabelInflationData.Caption := FAlphaQryOutPort.Inflation[AIndex].ToLabelText;
end;

procedure TalphaQryViewAdapter.ListYield10YBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect;
  AState: TOwnerDrawState);
begin
  if AIndex < FAlphaQryOutPort.Yield10Y.DataCnt then
    LabelYield10YData.Caption := FAlphaQryOutPort.Yield10Y[AIndex].ToLabelText;
end;

end.
