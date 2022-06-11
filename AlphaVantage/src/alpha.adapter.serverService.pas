unit alpha.adapter.serverService;

interface

uses
  alpha.portIn.serverUseCase, alpha.domain.serverEntities,

  m.httpService, m.objMngTh, wp.log, wp.Event,
  System.Generics.Collections, Spring.Collections,

  System.SysUtils, System.Classes;

type
  TDataModule = THttpServiceDataModule;
  TalphaAdapterServerService = class(TDataModule, IAlphaServerUseCase)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  public type
    TEvent = class
      class var OnSync: IEvent<TProc>;
      class var OnInflation: IEvent<TProc>;
      class var OnCpi: IEvent<TProc>;
      class var OnYield10Y: IEvent<TProc>;
    end;
    TEventClass = class of TEvent;
  private
    FInflationRsp: TAlphaBody;
    FCpiRsp: TAlphaBody;
    FYield10YRsp: TAlphaBody;
    FObjMng: TObjMngTh;
    function GetInflation: TAlphaBody;
    function GetCpi: TAlphaBody;
    function GetYield10Y: TAlphaBody;
  public
    Event: TEventClass;

    procedure ReqInflation;
    procedure ReqCpi;
    procedure ReqYield10Y;

    property Inflation: TAlphaBody read GetInflation;
    property Cpis: TAlphaBody read GetCpi;
    property Inflations: TAlphaBody read GetYield10Y;
  end;

//var
//  alphaAdapterServerService: TalphaAdapterServerService;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  factory.DB,
  m.httpClient,

  Spring.Services, Spring.Container
  ;

{ TalphaAdapterServerController }

procedure TalphaAdapterServerService.DataModuleCreate(Sender: TObject);
begin
  Log := TwpLoggerFactory.CreateSingle(ClassName);

  Event.OnSync := TEvent<TProc>.Create;
  Event.OnInflation := TEvent<TProc>.Create;
  Event.OnCpi := TEvent<TProc>.Create;
  Event.OnYield10Y := TEvent<TProc>.Create;

  FObjMng := TObjMngTh.Create(ClassName + '.MngTh', FactoryDB.CreateSingleMng(ClassName + '.ObjMng'));
//  FObjMng.ASync(
//    procedure(AMng: TObjectManager)
//    begin
//
//    end);
end;

procedure TalphaAdapterServerService.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(FInflationRsp) then
    FreeAndNil(FInflationRsp);

  if Assigned(FCpiRsp) then
    FreeAndNil(FCpiRsp);

  if Assigned(FYield10YRsp) then
    FreeAndNil(FYield10YRsp);
end;

function TalphaAdapterServerService.GetCpi: TAlphaBody;
begin
  Result := FCpiRsp;
end;

function TalphaAdapterServerService.GetInflation: TAlphaBody;
begin
  Result := FInflationRsp;
end;

function TalphaAdapterServerService.GetYield10Y: TAlphaBody;
begin
  Result := FYield10YRsp;
end;

procedure TalphaAdapterServerService.ReqCpi;
begin
  ASync(TAlphaCpiTask.Create(
    procedure(ATask: THttpClientTask)
    var
      LTask: TAlphaCpiTask absolute ATask;
    begin
      if not Log.IfSendWarning(LTask.HTTPSuccess, LTask.ClassName) then
        Log.SendError(LTask.HttpErMsg)
      else
        for var LProc in Event.OnCpi.Listeners do
          if Assigned(LProc) then
            LProc();
    end));
end;

procedure TalphaAdapterServerService.ReqInflation;
begin
  ASync(TAlphaInflationTask.Create(
    procedure(ATask: THttpClientTask)
    var
      LTask: TAlphaInflationTask absolute ATask;
    begin
      if not Log.IfSendWarning(LTask.HTTPSuccess, LTask.ClassName) then
        Log.SendError(LTask.HttpErMsg)
      else
      begin
        LTask.MoveTo(FInflationRsp);
        for var LProc in Event.OnInflation.Listeners do
          if Assigned(LProc) then
            LProc();
      end;
    end));
end;

procedure TalphaAdapterServerService.ReqYield10Y;
begin
  ASync(TAlphaYield10YTask.Create(
    procedure(ATask: THttpClientTask)
    var
      LTask: TAlphaYield10YTask absolute ATask;
    begin
      if not Log.IfSendWarning(LTask.HTTPSuccess, LTask.ClassName) then
        Log.SendError(LTask.HttpErMsg)
      else
        for var LProc in Event.OnYield10Y.Listeners do
          if Assigned(LProc) then
            LProc();
    end));
end;

initialization
  GlobalContainer.RegisterType<TalphaAdapterServerService>.Implements<IAlphaServerUseCase>;

end.
