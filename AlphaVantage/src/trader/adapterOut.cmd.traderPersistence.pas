unit adapterOut.cmd.traderPersistence;

interface

uses
  domain.traderEntities, portOut.cmd.traderUseCase,
  domain.serverEntities,

  wp.Aurelius.Engine.ObjectManager,

  wp.log, wp.Event,

  System.Classes, System.SysUtils,
  System.Generics.Collections
  ;

type
  TCmdTraderAdapter = class(TwpLogObject, ICmdTraderUseCase)
  private
    FObjMng: TAureliusObjMngThread;
    FEvent: TCmdTraderUseCaseEventClass;
    function GetEvent: TCmdTraderUseCaseEventClass;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Save(ABodyEntities: TArray<TAlphaBody>);
    procedure Delete(AEntity: TEntity);
    procedure Update(AEntity: TEntity);

    property Event: TCmdTraderUseCaseEventClass read GetEvent;
  end;

implementation

uses
  factory.db,

  Aurelius.Engine.ObjectManager, Aurelius.Criteria.Base, Aurelius.Criteria.Linq
  ;

{ TCmdTraderAdapter }

constructor TCmdTraderAdapter.Create;
begin
  Log := TwpLoggerFactory.CreateSingle(ClassName);

  FObjMng := TAureliusObjMngThread.Create(ClassName + '.MngTh', FactoryDB.Conn);
  FObjMng.Start;

  FEvent.OnSave := TEvent<TProc>.Create;
  FEvent.OnUpdate := TEvent<TProc<Int64>>.Create;
  FEvent.OnDelete := TEvent<TProc<Int64>>.Create;
end;

procedure TCmdTraderAdapter.Delete(AEntity: TEntity);
begin

end;

destructor TCmdTraderAdapter.Destroy;
begin
  FObjMng.Terminate;

  inherited;
end;

function TCmdTraderAdapter.GetEvent: TCmdTraderUseCaseEventClass;
begin
  Result := FEvent;
end;

procedure TCmdTraderAdapter.Save(ABodyEntities: TArray<TAlphaBody>);
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

procedure TCmdTraderAdapter.Update(AEntity: TEntity);
begin

end;

end.
