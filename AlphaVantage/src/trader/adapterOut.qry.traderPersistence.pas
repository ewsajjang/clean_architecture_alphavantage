unit adapterOut.qry.traderPersistence;

interface

uses
  portOut.qry.traderUseCase, domain.traderEntities,

  wp.Aurelius.Engine.ObjectManager,

  wp.log, wp.Event,

  System.Classes, System.SysUtils,
  System.Generics.Collections
  ;

type
  TQryTraderAdapter = class(TwpLogObject, IQryTraderUseCase)
  private
    FObjMng: TAureliusObjMngThread;
    FEvent: TQryTraderUseCaseEventClass;
    FIndicators: TList<TIndicator>;
    function GetEvent: TQryTraderUseCaseEventClass;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadIndicator;
    procedure LoadRawData(AIndicator: TIndicator);

    property Event: TQryTraderUseCaseEventClass read GetEvent;
  end;

implementation

uses
  factory.db,

  Aurelius.Engine.ObjectManager, Aurelius.Criteria.Base, Aurelius.Criteria.Linq
  ;

{ TQryTraderAdapter }

constructor TQryTraderAdapter.Create;
begin
  Log := TwpLoggerFactory.CreateSingle(ClassName);

  FObjMng := TAureliusObjMngThread.Create(ClassName + '.MngTh', FactoryDB.Conn);
  FObjMng.Start;

  FEvent.OnLoadIndicators := TEvent<TProc<TIndicatorList>>.Create;
  FEvent.OnLoadRawDatas := TEvent<TProc>.Create;
end;

destructor TQryTraderAdapter.Destroy;
begin
  FObjMng.Terminate;
  if Assigned(FIndicators) then
    FIndicators.Free;

  inherited;
end;

function TQryTraderAdapter.GetEvent: TQryTraderUseCaseEventClass;
begin
  Result := FEvent;
end;

procedure TQryTraderAdapter.LoadIndicator;
begin
  FObjMng.ASync<TIndicator>(
    procedure(AMng: TObjectManager)
    begin
      var LList := AMng.Find<TIndicator>.List;
      TThread.Synchronize(nil,
        procedure
        begin
          if Assigned(FIndicators) then
            FreeAndNil(FIndicators);
          FIndicators := LList;
        end);
      TThread.Queue(nil,
        procedure
        begin
          for var LProc  in FEvent.OnLoadIndicators.Listeners do
            if Assigned(LProc) then
              LProc(FIndicators);
        end)
    end);
end;

procedure TQryTraderAdapter.LoadRawData(AIndicator: TIndicator);
begin

end;

end.
