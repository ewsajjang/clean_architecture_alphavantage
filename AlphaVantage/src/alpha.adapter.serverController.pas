unit alpha.adapter.serverController;

interface

uses
  alpha.portIn.serverUseCase,

  wp.Forms,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ControlList;

type
  TAlphaAdapterServerController = class(TwpForm)
    ButtonSync: TButton;
    ListInflation: TControlList;
    GridPanel1: TGridPanel;
    Panel1: TPanel;
    Label1: TLabel;
    procedure ButtonSyncClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListInflationBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
  private
    FUseCase: IAlphaServerUseCase;
  public
  end;

var
  AlphaAdapterServerController: TAlphaAdapterServerController;

implementation

{$R *.dfm}

uses
  Spring.Container
  ;

procedure TAlphaAdapterServerController.ButtonSyncClick(Sender: TObject);
begin
  FUseCase.ReqInflation;
end;

procedure TAlphaAdapterServerController.FormCreate(Sender: TObject);
begin
  FUseCase := GlobalContainer.Resolve<IAlphaServerUseCase>;
end;

procedure TAlphaAdapterServerController.ListInflationBeforeDrawItem(AIndex: Integer; ACanvas: TCanvas; ARect: TRect;
  AState: TOwnerDrawState);
begin
  if AIndex < FUseCase.Inflation.DataCnt then
  
  
end;

end.
