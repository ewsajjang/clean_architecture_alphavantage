unit adapterOut.qry.serverPersistence;

interface

uses
  domain.serverEntities, portOut.qry.serverUseCase,

  m.httpClient, m.httpAdapter, wp.log, wp.Event,

  System.SysUtils, System.Classes,
  System.Generics.Collections, Spring.Collections
  ;

type
  TQryServerAdapter = class(TCustomHttpAdapter, IQryServerUseCase)
  private
    FEvent: TQryServerEventClass;
    FInflationRsp: TAlphaBody;
    FCpiRsp: TAlphaBody;
    FYield10YRsp: TAlphaBody;
    function GetEvent: TQryServerEventClass;
    function GetBodyEntities: TArray<TAlphaBody>;
    function GetInflation: TAlphaBody;
    function GetCpi: TAlphaBody;
    function GetYield10Y: TAlphaBody;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure ReqInflation;
    procedure ReqCpi;
    procedure ReqYield10Y;
  end;

implementation

{ TQryServerAdapter }

constructor TQryServerAdapter.Create;
begin
  inherited Create;

  Log := TwpLoggerFactory.CreateSingle(ClassName);

  FEvent.OnSync := TEvent<TProc>.Create;
  FEvent.OnInflation := TEvent<TProc>.Create;
  FEvent.OnCpi := TEvent<TProc>.Create;
  FEvent.OnYield10Y := TEvent<TProc>.Create;
end;

destructor TQryServerAdapter.Destroy;
begin
  if Assigned(FInflationRsp) then
    FInflationRsp.Free;

  if Assigned(FCpiRsp) then
    FCpiRsp.Free;

  if Assigned(FYield10YRsp) then
    FYield10YRsp.Free;

  inherited;
end;

function TQryServerAdapter.GetBodyEntities: TArray<TAlphaBody>;
begin
  Result := TArray<TAlphaBody>.Create(FInflationRsp, FCpiRsp, FYield10YRsp);
end;

function TQryServerAdapter.GetCpi: TAlphaBody;
begin
  Result := FCpiRsp;
end;

function TQryServerAdapter.GetEvent: TQryServerEventClass;
begin
  Result := FEvent;
end;

function TQryServerAdapter.GetInflation: TAlphaBody;
begin
  Result := FInflationRsp;
end;

function TQryServerAdapter.GetYield10Y: TAlphaBody;
begin
  Result := FYield10YRsp;
end;

procedure TQryServerAdapter.ReqCpi;
begin
  ASync(TAlphaCpiTask.Create(
    procedure(ATask: THttpClientTask)
    var
      LTask: TAlphaCpiTask absolute ATask;
    begin
      if not Log.IfSendWarning(LTask.HTTPSuccess, LTask.ClassName) then
        Log.SendError(LTask.HttpErMsg)
      else
      begin
        LTask.MoveTo(FCpiRsp);
        for var LProc in FEvent.OnCpi.Listeners do
          if Assigned(LProc) then
            LProc();
      end;
    end));
end;

procedure TQryServerAdapter.ReqInflation;
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
        for var LProc in FEvent.OnInflation.Listeners do
          if Assigned(LProc) then
            LProc();
      end;
    end));
end;

procedure TQryServerAdapter.ReqYield10Y;
begin
  ASync(TAlphaYield10YTask.Create(
    procedure(ATask: THttpClientTask)
    var
      LTask: TAlphaYield10YTask absolute ATask;
    begin
      if not Log.IfSendWarning(LTask.HTTPSuccess, LTask.ClassName) then
        Log.SendError(LTask.HttpErMsg)
      else
      begin
        LTask.MoveTo(FYield10YRsp);
        for var LProc in FEvent.OnYield10Y.Listeners do
          if Assigned(LProc) then
            LProc();
      end;
    end));
end;

end.
