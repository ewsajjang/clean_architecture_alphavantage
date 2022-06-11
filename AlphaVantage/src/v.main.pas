unit v.main;

interface

uses
  wp.Forms,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TvMain = class(TwpForm)
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  vMain: TvMain;

implementation

{$R *.dfm}

uses
  alpha.adapter.serverController
  ;

procedure TvMain.FormCreate(Sender: TObject);
begin
  AlphaAdapterServerController := PlaceOn<TAlphaAdapterServerController>(Self);
end;

end.
