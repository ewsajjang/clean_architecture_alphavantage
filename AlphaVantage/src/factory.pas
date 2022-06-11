unit factory;

interface

uses
  wp.log,

  System.SysUtils, System.Classes
  ;

type
  TDataModule = TwpLogDataModule;
  TfactoryMain = class(TDataModule)
  private
    class constructor Create;
  public
  end;

var
  factoryMain: TfactoryMain;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Spring.Container
  ;

{ TfactoryMain }

class constructor TfactoryMain.Create;
begin
  GlobalContainer.Build;
end;

end.
