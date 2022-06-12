program alphaVentage;

uses
  Spring.Services,
  Spring.Container,
  System.SysUtils,
  Vcl.Forms,
  v.main in 'v.main.pas' {vMain},
  alpha.adapter.serverController in 'alpha.adapter.serverController.pas' {AlphaAdapterServerController},
  alpha.domain.traderEntities in 'alpha.domain.traderEntities.pas',
  alpha.portIn.serverUseCase in 'alpha.portIn.serverUseCase.pas',
  alpha.portIn.traderUseCase in 'alpha.portIn.traderUseCase.pas',
  alpha.adapter.serverService in 'alpha.adapter.serverService.pas' {alphaAdapterServerService: TDataModule},
  m.httpClient in '..\__lib\m.httpClient.pas',
  alpha.domain.serverEntities in 'alpha.domain.serverEntities.pas',
  factory.db in 'factory.db.pas' {factoryDB: TDataModule},
  m.objMngTh in '..\__lib\m.objMngTh.pas',
  factory in 'factory.pas' {factoryMain: TDataModule},
  m.httpService in 'm.httpService.pas',
  alpha.adapter.traderService in 'alpha.adapter.traderService.pas',
  alpha.portOut.traderUseCase in 'alpha.portOut.traderUseCase.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  GlobalContainer.RegisterType<TalphaAdapterServerService>
    .Implements<IAlphaPortInServerUseCase>
    .Implements<IAlphaPortOutTraderUseCase>
    .InjectConstructor([Application]).AsSingleton;
  GlobalContainer.Build;
  Application.CreateForm(TfactoryDB, factoryDB);
  factoryDB.Initialize('');
  Application.CreateForm(TfactoryMain, factoryMain);
  Application.CreateForm(TvMain, vMain);
  ReportMemoryLeaksOnShutdown := DebugHook.ToBoolean;
  Application.Run;
end.
