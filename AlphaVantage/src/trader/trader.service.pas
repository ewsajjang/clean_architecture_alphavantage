unit trader.service;

interface

uses
  alphaSvr.entities, trader.entities, trader.output, trader.input,

  wp.Log, wp.Aurelius.Engine.ObjectManager, wp.Event,

  System.Classes, System.SysUtils,
  System.Generics.Collections, Spring.Collections, Spring.Container.Common
  ;

type
  TTraderService = class(TwpLogObject, ITraderInput)
  private
    FEvent: TTraderInputEventClass;
    function GetEvent: TTraderInputEventClass;
  private
    FTraderOutputQry: ITraderOutputQry;
    FObjMng: TAureliusObjMngThread;
  public

    constructor Create;
    destructor Destroy; override;

    procedure Save(ABodyEntities: TArray<TAlphaBody>);

    property Event: TTraderInputEventClass read GetEvent;
  end;

implementation

uses
  factory.db,

  Spring.Container,
  Aurelius.Engine.ObjectManager, Aurelius.Criteria.Base, Aurelius.Criteria.Linq
  ;

{ TTraderService }

constructor TTraderService.Create;
begin
  inherited Create;

  Log := TwpLoggerFactory.CreateSingle(ClassName);

  FEvent.OnSave := TEvent<TProc>.Create;

  FObjMng := TAureliusObjMngThread.Create(ClassName + '.MngTh', FactoryDB.Conn);
  FObjMng.Start;

  FTraderOutputQry := GlobalContainer.Resolve<ITraderOutputQry>;
end;

destructor TTraderService.Destroy;
begin
  GlobalContainer.Release(FTraderOutputQry);

  FObjMng.Terminate;

  inherited;
end;

function TTraderService.GetEvent: TTraderInputEventClass;
begin
  Result := FEvent;
end;

procedure TTraderService.Save(ABodyEntities: TArray<TAlphaBody>);
begin
  FObjMng.ASync(
    procedure(AMng: TObjectManager)
    begin
      var LTrans := AMng.Connection.BeginTransaction;
      try
        try
          for var LAlphaBody in ABodyEntities do
          begin
            var LIndicator := TIndicator.Create;
            try
              LIndicator.Name := LAlphaBody.Name;
              LIndicator.Interval := LAlphaBody.Interval;
              LIndicator.&Unit := LAlphaBody.&Unit;
              AMng.Save(LIndicator);
              for var LSrc in LAlphaBody.Datas do
              begin
                var LRaw := TRawData.Create;
                try
                  LRaw.IndicatorID := LIndicator.ID;
                  LRaw.Date := LSrc.Date;
                  LRaw.Value := LSrc.Value.ToDouble;
                  AMng.Save(LRaw);
                finally
                  if not AMng.IsAttached(LRaw) then
                    LRaw.Free;
                end;
              end;
            finally
              if not AMng.IsAttached(LIndicator) then
                LIndicator.Free;
            end;
          end;
          AMng.Flush;
        except on E: Exception do
          LTrans.Rollback;
        end;
      finally
        LTrans.Commit;
      end;
      TThread.Queue(nil,
        procedure
        begin
          for var LProc in FEvent.OnSave.Listeners do
            if Assigned(LProc) then
              LProc();
        end);
    end);
end;

end.
