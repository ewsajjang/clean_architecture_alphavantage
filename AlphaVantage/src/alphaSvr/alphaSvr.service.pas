unit alphaSvr.service;

interface

uses
  alphaSvr.entities, alphaSvr.input, alphaSvr.output,

  wp.log, wp.Event, Spring.Container.Common,

  System.SysUtils, System.Classes;

type
  TDataModule = TwpLogDataModule;
  TalphaSvrService = class(TDataModule, IAlphaSvrInput)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    function GetEvent: TAlphaSvrInputEventClass;
  private
    FOutput: IAlphaSvrOutput;
  public
    FEvent: TAlphaSvrInputEventClass;
    procedure Sync;

    property Event: TAlphaSvrInputEventClass read GetEvent;
  end;

var
  alphaSvrService: TalphaSvrService;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Spring.Container
  ;

{ TalphaAdapterServerController }

procedure TalphaSvrService.DataModuleCreate(Sender: TObject);
begin
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

procedure TalphaSvrService.DataModuleDestroy(Sender: TObject);
begin
  GlobalContainer.Release(FOutput);
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
