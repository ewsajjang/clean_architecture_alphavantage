unit alphaSvr.service;

interface

uses
  alphaSvr.entities, alphaSvr.input, alphaSvr.output,

  wp.log, wp.Event, Spring.Container.Common,

  System.SysUtils, System.Classes
  ;

type
  TalphaSvrService = class(TwpLogObject, IAlphaSvrInput)
  private
    FOutput: IAlphaSvrOutput;
    FEvent: TAlphaSvrInputEventClass;
    function GetEvent: TAlphaSvrInputEventClass;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Sync;
  end;

implementation

uses
  Spring.Container
  ;

{ TalphaSvrService }

constructor TalphaSvrService.Create;
begin
  inherited Create;

  Log := TwpLoggerFactory.CreateSingle(ClassName);

  FEvent.OnInflation := TEvent<TProc>.Create;
  FEvent.OnCpi := TEvent<TProc>.Create;
  FEvent.OnYield10Y := TEvent<TProc>.Create;

  FOutput := GlobalContainer.Resolve<IAlphaSvrOutput>;
  FOutput.Event.OnInflation.Subscribe(Self,
    procedure
    begin
      for var LProc in FEvent.OnInflation.Listeners do
        if Assigned(LProc) then
          LProc();
    end);
  FOutput.Event.OnCpi.Subscribe(Self,
    procedure
    begin
      for var LProc in FEvent.OnCpi.Listeners do
        if Assigned(LProc) then
          LProc();
    end);
  FOutput.Event.OnYield10Y.Subscribe(Self,
    procedure
    begin
      for var LProc in FEvent.OnYield10Y.Listeners do
        if Assigned(LProc) then
          LProc();
    end);
end;

destructor TalphaSvrService.Destroy;
begin
  GlobalContainer.Release(FOutput);

  inherited;
end;

function TalphaSvrService.GetEvent: TAlphaSvrInputEventClass;
begin
  Result := FEvent;
end;

procedure TalphaSvrService.Sync;
begin
  FOutput.ReqCpi;
  FOutput.ReqInflation;
  FOutput.ReqYield10Y;
end;

end.
