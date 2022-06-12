unit v.main;

interface

uses
  alpha.portOut.traderUseCase,

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
    FPortOutTraderUseCase: IAlphaPortOutTraderUseCase;
  public
  end;

var
  vMain: TvMain;

implementation

{$R *.dfm}

uses
  alpha.adapter.serverController,

  Spring.Container
  ;

procedure TvMain.FormCreate(Sender: TObject);
begin

  FPortOutTraderUseCase := GlobalContainer.Resolve<IAlphaPortOutTraderUseCase>;
  FPortOutTraderUseCase.PortOutEvent.OnSave.Subscribe(Self, procedure begin PageControl.ActivePage := TabTraderUseCase; end);

  AlphaAdapterServerController := PlaceOn<TAlphaAdapterServerController>(TabServerUseCase);
end;

end.
