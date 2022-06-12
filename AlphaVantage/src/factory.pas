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

end.
