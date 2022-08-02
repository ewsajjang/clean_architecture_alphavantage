program TestAlphaVantage;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  test.trader.service in '..\trader\test.trader.service.pas',
  m.httpClient in '..\__lib\m.httpClient.pas',
  wp.Aurelius.Engine.ObjectManager in '..\__lib\wp.Aurelius.Engine.ObjectManager.pas',
  trader.service in '..\trader\trader.service.pas',
  trader.entities in '..\trader\trader.entities.pas',
  trader.input in '..\trader\trader.input.pas',
  trader.output.dbCmd in '..\trader\trader.output.dbCmd.pas',
  trader.output.dbQry in '..\trader\trader.output.dbQry.pas',
  trader.output.intf.qry in '..\trader\trader.output.intf.qry.pas',
  trader.output in '..\trader\trader.output.pas',
  alphaSvr.entities in '..\alphaSvr\alphaSvr.entities.pas',
  alphaSvr.input in '..\alphaSvr\alphaSvr.input.pas',
  alphaSvr.ouput.restQry in '..\alphaSvr\alphaSvr.ouput.restQry.pas',
  alphaSvr.output in '..\alphaSvr\alphaSvr.output.pas',
  alphaSvr.service in '..\alphaSvr\alphaSvr.service.pas' {alphaSvrService: TDataModule},
  factory.db in '..\factory.db.pas' {factoryDB: TDataModule},
  m.httpAdapter in '..\m.httpAdapter.pas';

{$IFNDEF TESTINSIGHT}
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger : ITestLogger;
{$ENDIF}
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //When true, Assertions must be made during tests;
    runner.FailsOnNoAsserts := False;

    //tell the runner how we will log things
    //Log to the console window if desired
    if TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off then
    begin
      logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
      runner.AddLogger(logger);
    end;
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}
end.
