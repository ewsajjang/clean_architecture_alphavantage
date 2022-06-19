unit v.main;

interface

uses
  portOut.cmd.traderUseCase,

  wp.Forms,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls;

type
  TvMain = class(TwpForm)
    PageControl: TPageControl;
    TabServerUseCase: TTabSheet;
    TabTraderUseCase: TTabSheet;
    procedure FormCreate(Sender: TObject);
  private
    FCmdTraderUseCase: ICmdTraderUseCase;
  public
  end;

var
  vMain: TvMain;

implementation

{$R *.dfm}

uses
  adapterOut.qry.serverController, adapter.trader.indicatorController,

  Spring.Container
  ;

procedure TvMain.FormCreate(Sender: TObject);
begin
  FCmdTraderUseCase := GlobalContainer.Resolve<ICmdTraderUseCase>;
  FCmdTraderUseCase.Event.OnSave.Subscribe(Self, procedure begin
    PageControl.ActivePage := TabTraderUseCase;
  end);

  AdapterOutServerController := PlaceOn<TAdapterOutServerController>(TabServerUseCase);
  AdapterIndicatorControl := PlaceOn<TAdapterIndicatorControl>(TabTraderUseCase);
end;

end.
