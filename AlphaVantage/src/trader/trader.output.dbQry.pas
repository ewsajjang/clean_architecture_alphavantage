unit trader.output.dbQry;

interface

uses
  trader.output, trader.entities,

  wp.Aurelius.Engine.ObjectManager,

  wp.log, wp.Event,

  System.Classes, System.SysUtils,
  System.Generics.Collections
  ;

type
  TTraderOuputDBQry = class(TwpLogObject, ITraderOutputQry)
  private
    FObjMng: TAureliusObjMngThread;
    FEvent: TTraderOuputQryEventClass;
    FIndicators: TList<TIndicator>;
    function GetEvent: TTraderOuputQryEventClass;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadIndicator;
    procedure LoadRawData(AIndicator: TIndicator);

    property Event: TTraderOuputQryEventClass read GetEvent;
  end;

implementation

uses
  factory.db,

  Aurelius.Engine.ObjectManager, Aurelius.Criteria.Base, Aurelius.Criteria.Linq
  ;

{ TTraderOuputDBQry }

constructor TTraderOuputDBQry.Create;
begin
  Log := TwpLoggerFactory.CreateSingle(ClassName);

  FObjMng := TAureliusObjMngThread.Create(ClassName + '.MngTh', FactoryDB.Conn);
  FObjMng.Start;

  FEvent.OnLoadIndicators := TEvent<TProc<TIndicatorList>>.Create;
  FEvent.OnLoadRawDatas := TEvent<TProc>.Create;
end;

destructor TTraderOuputDBQry.Destroy;
begin
  FObjMng.Terminate;
  if Assigned(FIndicators) then
    FIndicators.Free;

  inherited;
end;

function TTraderOuputDBQry.GetEvent: TTraderOuputQryEventClass;
begin
  Result := FEvent;
end;

procedure TTraderOuputDBQry.LoadIndicator;
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

procedure TTraderOuputDBQry.LoadRawData(AIndicator: TIndicator);
begin

end;

end.
