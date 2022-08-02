unit v.main;

interface

uses
  trader.input,

  wp.Forms, Spring.Container.Common,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls;

type
  TvMain = class(TwpForm)
    PageControl: TPageControl;
    TabAlphaSvrView: TTabSheet;
    TabTraderView: TTabSheet;
    procedure FormCreate(Sender: TObject);
  private
    FTraderInput: ITraderInput;
  public
  end;

var
  vMain: TvMain;

implementation

{$R *.dfm}

uses
  alphaSvr.input, alphaSvr.view, trader.view,

  Spring.Container
  ;

procedure TvMain.FormCreate(Sender: TObject);
begin
  FTraderInput := GlobalContainer.Resolve<ITraderInput>;
  FTraderInput.Event.OnSave.Subscribe(Self, procedure begin
    PageControl.ActivePage := TabTraderView;
  end);

  alphaSvrView := PlaceOn<TalphaSvrView>(TabAlphaSvrView);
  traderView := PlaceOn<TtraderView>(TabTraderView);
end;

end.
