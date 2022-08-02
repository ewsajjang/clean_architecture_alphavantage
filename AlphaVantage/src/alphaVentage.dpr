program alphaVentage;

uses
  Spring.Services,
  Spring.Container,
  System.SysUtils,
  Vcl.Forms,
  v.main in 'v.main.pas' {vMain},
  alphaSvr.view in 'alphaSvr\alphaSvr.view.pas' {alphaSvrView},
  trader.entities in 'trader\trader.entities.pas',
  alphaSvr.output in 'alphaSvr\alphaSvr.output.pas',
  alphaSvr.service in 'alphaSvr\alphaSvr.service.pas' {alphaSvrService: TDataModule},
  m.httpClient in '..\__lib\m.httpClient.pas',
  alphaSvr.entities in 'alphaSvr\alphaSvr.entities.pas',
  factory.db in 'factory.db.pas' {factoryDB: TDataModule},
  wp.Aurelius.Engine.ObjectManager in '..\__lib\wp.Aurelius.Engine.ObjectManager.pas',
  m.httpAdapter in 'm.httpAdapter.pas',
  trader.service in 'trader\trader.service.pas',
  trader.view in 'trader\trader.view.pas' {traderView},
  trader.output.dbQry in 'trader\trader.output.dbQry.pas',
  trader.output in 'trader\trader.output.pas',
  alphaSvr.ouput.restQry in 'alphaSvr\alphaSvr.ouput.restQry.pas',
  alphaSvr.input in 'alphaSvr\alphaSvr.input.pas',
  trader.input in 'trader\trader.input.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook.ToBoolean;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfactoryDB, factoryDB);
  factoryDB.Initialize('');

  GlobalContainer.RegisterType<TAlphaSvrService>.Implements<IAlphaSvrInput>.InjectConstructor([Application]).AsSingleton;
  GlobalContainer.RegisterType<TAlphaSvrOutputRestQry>.Implements<IAlphaSvrOutput>.AsSingleton;

  GlobalContainer.RegisterType<TTraderService>.Implements<ITraderInput>.AsSingleton;
  GlobalContainer.RegisterType<TTraderOuputDBQry>.Implements<ITraderOutputQry>.AsSingleton;

  GlobalContainer.Build;

  Application.CreateForm(TvMain, vMain);
  Application.Run;
end.
