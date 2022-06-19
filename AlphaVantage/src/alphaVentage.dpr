program alphaVentage;

uses
  Spring.Services,
  Spring.Container,
  System.SysUtils,
  Vcl.Forms,
  v.main in 'v.main.pas' {vMain},
  adapter.serverController in 'server\adapter.serverController.pas' {AdapterServerController},
  domain.traderEntities in 'trader\domain.traderEntities.pas',
  portIn.serverUseCase in 'server\portIn.serverUseCase.pas',
  portIn.traderUseCase in 'trader\portIn.traderUseCase.pas',
  adapter.serverService in 'server\adapter.serverService.pas' {adapterServerService: TDataModule},
  m.httpClient in '..\__lib\m.httpClient.pas',
  domain.serverEntities in 'server\domain.serverEntities.pas',
  factory.db in 'factory.db.pas' {factoryDB: TDataModule},
  m.objMngTh in '..\__lib\m.objMngTh.pas',
  factory in 'factory.pas' {factoryMain: TDataModule},
  m.httpService in 'm.httpService.pas',
  adapter.traderService in 'trader\adapter.traderService.pas',
  portOut.traderUseCase in 'trader\portOut.traderUseCase.pas',
  adapter.indicatorController in 'trader\adapter.indicatorController.pas' {AdapterIndicatorControl};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfactoryDB, factoryDB);
  factoryDB.Initialize('');

  GlobalContainer.RegisterType<TAdapterServerService>
    .Implements<IPortInServerUseCase>
    .Implements<IPortOutTraderUseCase>
    .InjectConstructor([Application])
    .AsSingleton;
  GlobalContainer.RegisterType<TAdapterTraderService>
    .Implements<IPortInTraderUseCase>
    .AsSingleton;
  GlobalContainer.Build;

  Application.CreateForm(TfactoryMain, factoryMain);
  Application.CreateForm(TvMain, vMain);
  ReportMemoryLeaksOnShutdown := DebugHook.ToBoolean;
  Application.Run;

  GlobalContainer.Release(GlobalContainer.Resolve<IPortInTraderUseCase>);
end.
