unit alphaSvr.view;

interface

uses
  alphaSvr.input, alphaSvr.output, trader.input,

  wp.Forms, Spring.Container.Common,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ControlList;

type
  TalphaSvrView = class(TwpForm)
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
    [Inject] FAlphaSvrInput: IAlphaSvrInput;
    [Inject] FAlphaSvrOutput: IAlphaSvrOutput;
    [Inject] FTraderInput: ITraderInput;
  public
  end;

var
  alphaSvrView: TalphaSvrView;

implementation

{$R *.dfm}

uses
  Spring.Container
  ;

procedure TalphaSvrView.ButtonSaveClick(Sender: TObject);
begin
  FTraderInput.Save(FAlphaSvrOutput.BodyEntities);
end;

procedure TalphaSvrView.ButtonSyncClick(Sender: TObject);
begin
  FAlphaSvrInput.Sync;
end;

procedure TalphaSvrView.FormCreate(Sender: TObject);
begin
  FAlphaSvrInput.Event.OnInflation.Subscribe(
    Self,
    procedure
    begin
      LabelInflation.Caption := FAlphaSvrOutput.Inflation.ToLabelText;
      ListInflation.ItemCount := FAlphaSvrOutput.Inflation.DataCnt;
    end);
  FAlphaSvrInput.Event.OnCpi.Subscribe(
    Self,
    procedure
    begin
      LabelCpi.Caption := FAlphaSvrOutput.Cpi.ToLabelText;
      ListCpi.ItemCount := FAlphaSvrOutput.Cpi.DataCnt;
    end);
  FAlphaSvrInput.Event.OnYield10Y.Subscribe(
    Self,
    procedure
    begin
      LabelYield10Y.Caption := FAlphaSvrOutput.Yield10Y.ToLabelText;
      ListYield10Y.ItemCount := FAlphaSvrOutput.Yield10Y.DataCnt;
    end);
end;

procedure TalphaSvrView.ListCpiBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect;
  AState: TOwnerDrawState);
begin
  if AIndex < FAlphaSvrOutput.Cpi.DataCnt then
    LabelCpiData.Caption := FAlphaSvrOutput.Cpi[AIndex].ToLabelText;
end;

procedure TalphaSvrView.ListInflationBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  if AIndex < FAlphaSvrOutput.Inflation.DataCnt then
    LabelInflationData.Caption := FAlphaSvrOutput.Inflation[AIndex].ToLabelText;
end;

procedure TalphaSvrView.ListYield10YBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect;
  AState: TOwnerDrawState);
begin
  if AIndex < FAlphaSvrOutput.Yield10Y.DataCnt then
    LabelYield10YData.Caption := FAlphaSvrOutput.Yield10Y[AIndex].ToLabelText;
end;

end.
