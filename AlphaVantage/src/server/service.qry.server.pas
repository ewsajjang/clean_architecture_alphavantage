unit service.qry.server;

interface

uses
  portOut.qry.serverUseCase,

  wp.log,

  System.SysUtils, System.Classes;

type
  TDataModule = TwpLogDataModule;
  TserviceCmdServer = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FQryServerUserCase: IQryServerUseCase;
  public
  end;

var
  serviceCmdServer: TserviceCmdServer;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Spring.Container
  ;

{ TalphaAdapterServerController }

procedure TserviceCmdServer.DataModuleCreate(Sender: TObject);
begin
  Log := TwpLoggerFactory.CreateSingle(ClassName);

  FQryServerUserCase := GlobalContainer.Resolve<IQryServerUseCase>;
end;

procedure TserviceCmdServer.DataModuleDestroy(Sender: TObject);
begin
  GlobalContainer.Release(FQryServerUserCase);
end;

end.
