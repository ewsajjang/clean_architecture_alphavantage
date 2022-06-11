program alphaVentage;

uses
  Vcl.Forms,
  v.main in 'v.main.pas' {vMain},
  alpha.query.adapter in 'alpha.query.adapter.pas',
  alpha.query.port in 'alpha.query.port.pas',
  alpha.adapter.serverController in 'alpha.adapter.serverController.pas' {AlphaAdapterServerController},
  alpha.domain.entities in 'alpha.domain.entities.pas',
  alpha.portIn.serverUseCase in 'alpha.portIn.serverUseCase.pas',
  alpha.portIn.traderUseCase in 'alpha.portIn.traderUseCase.pas',
  alpha.portOut.serverUseCase in 'alpha.portOut.serverUseCase.pas',
  alpha.portOut.traderUseCase in 'alpha.portOut.traderUseCase.pas',
  alpha.adapter.serverService in 'alpha.adapter.serverService.pas' {alphaAdapterServerService: TDataModule},
  m.httpClient in '..\__lib\m.httpClient.pas',
  alpha.domain.serverEntities in 'alpha.domain.serverEntities.pas',
  factory.db in 'factory.db.pas' {factoryDB: TDataModule},
  m.objMngTh in '..\__lib\m.objMngTh.pas',
  factory in 'factory.pas' {factoryMain: TDataModule},
  m.httpService in 'm.httpService.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfactoryDB, factoryDB);
  Application.CreateForm(TfactoryMain, factoryMain);
  Application.CreateForm(TvMain, vMain);
  Application.Run;
end.
