unit service.cmd.trader;

interface

uses
  domain.traderEntities, portOut.qry.TraderUseCase, portOut.cmd.traderUseCase,

  wp.Log,

  System.Classes, System.SysUtils,
  System.Generics.Collections, Spring.Collections, Spring.Container.Common
  ;

type
  TAdapterTraderService = class(TwpLogObject)
  private
    [Inject]
    FQryTraderPort: IQryTraderUseCase;
    [Inject]
    FCmdTraderPort: ICmdTraderUseCase;
  public
    class constructor Create;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  Spring.Container
  ;

{ TAdapterTraderService }

constructor TAdapterTraderService.Create;
begin
  Log := TwpLoggerFactory.CreateSingle(ClassName);
end;

class constructor TAdapterTraderService.Create;
begin
  GlobalContainer.RegisterType<TAdapterTraderService>.AsSingleton;
end;

destructor TAdapterTraderService.Destroy;
begin
  GlobalContainer.Release(FQryTraderPort);
  GlobalContainer.Release(FCmdTraderPort);

  inherited;
end;

end.
