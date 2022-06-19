program alphaVentage;

uses
  Spring.Services,
  Spring.Container,
  System.SysUtils,
  Vcl.Forms,
  v.main in 'v.main.pas' {vMain},
  adapterOut.qry.serverController in 'server\adapterOut.qry.serverController.pas' {AdapterOutServerController},
  domain.traderEntities in 'trader\domain.traderEntities.pas',
  portOut.qry.serverUseCase in 'server\portOut.qry.serverUseCase.pas',
  service.qry.server in 'server\service.qry.server.pas' {serviceCmdServer: TDataModule},
  m.httpClient in '..\__lib\m.httpClient.pas',
  domain.serverEntities in 'server\domain.serverEntities.pas',
  factory.db in 'factory.db.pas' {factoryDB: TDataModule},
  wp.Aurelius.Engine.ObjectManager in '..\__lib\wp.Aurelius.Engine.ObjectManager.pas',
  m.httpAdapter in 'm.httpAdapter.pas',
  service.cmd.trader in 'trader\service.cmd.trader.pas',
  adapter.trader.indicatorController in 'trader\adapter.trader.indicatorController.pas' {AdapterIndicatorControl},
  portOut.qry.traderUseCase in 'trader\portOut.qry.traderUseCase.pas',
  adapterOut.qry.traderPersistence in 'trader\adapterOut.qry.traderPersistence.pas',
  portOut.cmd.traderUseCase in 'trader\portOut.cmd.traderUseCase.pas',
  adapterOut.cmd.traderPersistence in 'trader\adapterOut.cmd.traderPersistence.pas',
  adapterOut.qry.serverPersistence in 'server\adapterOut.qry.serverPersistence.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfactoryDB, factoryDB);
  factoryDB.Initialize('');

  GlobalContainer.RegisterType<TQryServerAdapter>.Implements<IQryServerUseCase>.AsSingleton;
  GlobalContainer.RegisterType<TQryTraderAdapter>.Implements<IQryTraderUseCase>.AsSingleton;
  GlobalContainer.RegisterType<TCmdTraderAdapter>.Implements<ICmdTraderUseCase>.AsSingleton;
  GlobalContainer.Build;

  Application.CreateForm(TserviceCmdServer, serviceCmdServer);
  Application.CreateForm(TvMain, vMain);
  ReportMemoryLeaksOnShutdown := DebugHook.ToBoolean;

  Application.Run;

//  GlobalContainer.Release(GlobalContainer.Resolve<IPortInTraderUseCase>);
end.
