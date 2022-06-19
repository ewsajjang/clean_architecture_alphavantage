unit v.main;

interface

uses
  portOut.traderUseCase,

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
    FPortOutTraderUseCase: IPortOutTraderUseCase;
  public
  end;

var
  vMain: TvMain;

implementation

{$R *.dfm}

uses
  adapter.serverController, adapter.indicatorController,

  Spring.Container
  ;

procedure TvMain.FormCreate(Sender: TObject);
begin
  FPortOutTraderUseCase := GlobalContainer.Resolve<IPortOutTraderUseCase>;
  FPortOutTraderUseCase.PortOutEvent.OnSave.Subscribe(Self, procedure begin
    PageControl.ActivePage := TabTraderUseCase;
  end);

  AdapterServerController := PlaceOn<TAdapterServerController>(TabServerUseCase);
  AdapterIndicatorControl := PlaceOn<TAdapterIndicatorControl>(TabTraderUseCase);
end;

end.
