unit alphaSvr.ouput.restQry;

interface

uses
  alphaSvr.entities, alphaSvr.output,

  m.httpClient, m.httpAdapter, wp.log, wp.Event,

  System.SysUtils, System.Classes,
  System.Generics.Collections, Spring.Collections
  ;

type
  TAlphaSvrOutputRestQry = class(TCustomHttpAdapter, IAlphaSvrOutput)
  private
    FEvent: TAlphaSvrOutputEventClass;
    FInflationRsp: TAlphaBody;
    FCpiRsp: TAlphaBody;
    FYield10YRsp: TAlphaBody;
    function GetEvent: TAlphaSvrOutputEventClass;
    function GetBodyEntities: TArray<TAlphaBody>;
    function GetInflation: TAlphaBody;
    function GetCpi: TAlphaBody;
    function GetYield10Y: TAlphaBody;
  public
    constructor Create;
    destructor Destroy; override;

    procedure ReqInflation;
    procedure ReqCpi;
    procedure ReqYield10Y;
  end;

implementation

uses
  wp.HTTP, wp.json
  ;      

type
  TAlphaTask = class(THttpClientGetTask<TAlphaBody>)
  protected
    function DoSerialize(const ARspContent: string; out ARsp: TAlphaBody): Boolean; override;
  public
    procedure MoveTo(out ADst: TAlphaBody);
  end;

  TAlphaInflationTask = class(TAlphaTask)
  public
    constructor Create(ARspProc: TProc<THttpClientTask> = nil); reintroduce;
  end;

  TAlphaCpiTask = class(TAlphaTask)
  public
    constructor Create(ARspProc: TProc<THttpClientTask> = nil); reintroduce;
  end;

  TAlphaYield10YTask = class(TAlphaTask)
  public
    constructor Create(ARspProc: TProc<THttpClientTask> = nil); reintroduce;
  end;

{ TAlphaTask }

function TAlphaTask.DoSerialize(const ARspContent: string; out ARsp: TAlphaBody): Boolean;
begin
  Result := (HTTPStatusCode = Status200_OK) and TJsonSerializer.TryAs<TAlphaBody>(FRspContent, ARsp);
end;

procedure TAlphaTask.MoveTo(out ADst: TAlphaBody);
begin
  if Assigned(ADst) then
    ADst.Free;

  ADst := FRsp;
  FRsp := nil;
end;

{ TAlphaInflationTask }

constructor TAlphaInflationTask.Create(ARspProc: TProc<THttpClientTask>);
begin
  inherited Create('https://www.alphavantage.co/query?function=INFLATION&apikey=demo', ARspProc);
end;

{ TAlphaCpiTask }

constructor TAlphaCpiTask.Create(ARspProc: TProc<THttpClientTask>);
begin
  inherited Create('https://www.alphavantage.co/query?function=CPI&interval=monthly&apikey=demo', ARspProc);
end;

{ TAlphaYield10YTask }

constructor TAlphaYield10YTask.Create(ARspProc: TProc<THttpClientTask>);
begin
  inherited Create('https://www.alphavantage.co/query?function=TREASURY_YIELD&interval=monthly&maturity=10year&apikey=demo', ARspProc);
end;

{ TAlphaSvrOutputRestQry }

constructor TAlphaSvrOutputRestQry.Create;
begin
  inherited Create;

  Log := TwpLoggerFactory.CreateSingle(ClassName);

  FEvent.OnInflation := TEvent<TProc>.Create;
  FEvent.OnCpi := TEvent<TProc>.Create;
  FEvent.OnYield10Y := TEvent<TProc>.Create;
end;

destructor TAlphaSvrOutputRestQry.Destroy;
begin
  if Assigned(FInflationRsp) then
    FInflationRsp.Free;

  if Assigned(FCpiRsp) then
    FCpiRsp.Free;

  if Assigned(FYield10YRsp) then
    FYield10YRsp.Free;

  inherited;
end;

function TAlphaSvrOutputRestQry.GetBodyEntities: TArray<TAlphaBody>;
begin
  Result := TArray<TAlphaBody>.Create(FInflationRsp, FCpiRsp, FYield10YRsp);
end;

function TAlphaSvrOutputRestQry.GetCpi: TAlphaBody;
begin
  Result := FCpiRsp;
end;

function TAlphaSvrOutputRestQry.GetEvent: TAlphaSvrOutputEventClass;
begin
  Result := FEvent;
end;

function TAlphaSvrOutputRestQry.GetInflation: TAlphaBody;
begin
  Result := FInflationRsp;
end;

function TAlphaSvrOutputRestQry.GetYield10Y: TAlphaBody;
begin
  Result := FYield10YRsp;
end;

procedure TAlphaSvrOutputRestQry.ReqCpi;
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

procedure TAlphaSvrOutputRestQry.ReqInflation;
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

procedure TAlphaSvrOutputRestQry.ReqYield10Y;
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
