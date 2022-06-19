unit m.httpAdapter;

interface

uses
  m.httpClient, wp.log,

  System.Classes, System.SysUtils, System.Generics.Collections
  ;

type
  TCustomHttpAdapter = class(TwpLogObject)
  private
    FTaskMng: THttpClientTaskMng<THttpBody, THttpBody>;
    FTaskQueue: TThreadedQueue<THttpClientTask<THttpBody, THttpBody>>;
    FHttpTh: THttpClientTh<THttpBody, THttpBody>;
  protected
    procedure ASync(ATask: THttpClientTask);
    function Sync(ATask: THttpClientTask; out AErMsg: string): Boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

implementation

{ THttpServiceDataModule }

procedure TCustomHttpAdapter.ASync(ATask: THttpClientTask);
var
  LTask: THttpClientTask<THttpBody, THttpBody> absolute ATask;
begin
  FTaskQueue.PushItem(LTask);
end;

constructor TCustomHttpAdapter.Create;
begin
  inherited;

  FTaskMng := THttpClientTaskMng<THttpBody, THttpBody>.Create(TwpLoggerFactory.CreateSingle('TalphaAdapterServerController.TaskMng'));
  FTaskMng.OnSessionHeader := procedure(ATask: THttpClientTask; AHeader: TStringList)
    begin
      Assert(Assigned(FHttpTh));
      FHttpTh.AssignSessionHeader(AHeader);
      {$IFDEF DEBUG}
        Log.WL(AHeader);
      {$ENDIF}
    end;

  FTaskQueue := TThreadedQueue<THttpClientTask<THttpBody, THttpBody>>.Create(64, 1000, 1000);
  FHttpTh := THttpClientTh<THttpBody, THttpBody>.Create(FTaskQueue);
  FHttpTh.OnSessionHeader := procedure(ATask: THttpClientTask; AHeader: TStringList)
    begin
      FTaskMng.AssignSessionHeader(AHeader);
    end;
  FHttpTh.Start;
end;

destructor TCustomHttpAdapter.Destroy;
begin
  FTaskMng.OnSessionHeader := nil;
  FTaskMng.Free;

  if Assigned(FTaskQueue) then
    FTaskQueue.DoShutDown;
  if Assigned(FHttpTh) then
  begin
    FHttpTh.OnSessionHeader := nil;
    FHttpTh.Terminate;
    FHttpTh.WaitFor;
    FHttpTh.Free;
  end;
  if Assigned(FTaskQueue) then
    FTaskQueue.Free;

  inherited;
end;

function TCustomHttpAdapter.Sync(ATask: THttpClientTask; out AErMsg: string): Boolean;
begin
  Result := FTaskMng.Execute(ATask as THttpClientTask<THttpBody, THttpBody>);
end;

end.
