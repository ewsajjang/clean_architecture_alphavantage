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
    FEvent: TAlphaSvrInputEventClass;
    function GetEvent: TAlphaSvrInputEventClass;
  private
    [Inject] FOutput: IAlphaSvrOutput;
  public
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
