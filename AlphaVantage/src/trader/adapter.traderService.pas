unit adapter.traderService;

interface

uses
  portIn.traderUseCase, domain.traderEntities,
  m.objMngTh,

  wp.Log, wp.Event,
  Aurelius.Engine.ObjectManager,

  System.Classes, System.SysUtils,
  System.Generics.Collections, Spring.Collections
  ;

type
  TAdapterTraderService = class(TwpLogObject, IPortInTraderUseCase)
  private
    FMngTh: TObjMngTh;
    FEvent: TPortInTraderEventClass;
    FIndicators: TList<TIndicator>;
    function GetEvent: TPortInTraderEventClass;
    procedure ASyncManipulation(AEntity: TEntity; const AThProc: TProc<TObjectManager>; const ADoneProc: TProc = nil);
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadIndicator;
    procedure LoadRawData(AIndicator: TIndicator);

    procedure Delete(AEntity: TEntity);
    procedure Update(AEntity: TEntity);
  end;

implementation

uses
  factory.db,

  Spring, Aurelius.Criteria.Base, Aurelius.Criteria.Linq
  ;

{ TAdapterTraderService }

constructor TAdapterTraderService.Create;
begin
  Log := TwpLoggerFactory.CreateSingle(ClassName);

  FMngTh := TObjMngTh.Create(ClassName + '.MngTh', FactoryDB.Conn);
  FMngTh.Start;

  FEvent.OnUpdate := TEvent<TProc<Int64>>.Create;
  FEvent.OnDelete := TEvent<TProc<Int64>>.Create;
  FEvent.OnIndicatorList := TEvent<TProc<TIndicatorList>>.Create;
  FEvent.OnRawDataList := TEvent<TProc>.Create;
end;

procedure TAdapterTraderService.ASyncManipulation(AEntity: TEntity; const AThProc: TProc<TObjectManager>; const ADoneProc: TProc);
begin
  FMngTh.ASync(
    procedure (AMng: TObjectManager)
    begin
      AThProc(AMng);
      var LAttached := False;
      try
        LAttached := AMng.IsAttached(AEntity);
        if LAttached then
          AMng.Flush;
      finally
        if not LAttached then
          AEntity.Free;
      end;
      if LAttached and Assigned(ADoneProc) then
        TThread.Queue(nil, procedure begin ADoneProc() end);
    end);
end;

procedure TAdapterTraderService.Delete(AEntity: TEntity);
begin
  ASyncManipulation(
    AEntity,
    procedure(AMng: TObjectManager)
    begin
      AMng.Remove(AEntity);
    end,
    procedure
    begin
      for var LProc in FEvent.OnDelete.Listeners do
        if Assigned(LProc) then
          LProc(AEntity.ID);
    end);
end;

destructor TAdapterTraderService.Destroy;
begin
  FMngTh.Terminate;
  FMngTh := nil;

  if Assigned(FIndicators) then
    FreeAndNil(FIndicators);

  inherited;
end;

function TAdapterTraderService.GetEvent: TPortInTraderEventClass;
begin
  Result := FEvent;
end;

procedure TAdapterTraderService.LoadIndicator;
begin
  FMngTh.ASync<TIndicator>(
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
          for var LProc  in FEvent.OnIndicatorList.Listeners do
            if Assigned(LProc) then
              LProc(FIndicators);
        end)
    end);
end;

procedure TAdapterTraderService.LoadRawData(AIndicator: TIndicator);
begin
  FMngTh.ASync<TRawData>(
    procedure(AMng: TObjectManager)
    begin
      var LList := AMng.Find<TIndicator>.Where(Linq['IndicatorID'] = AIndicator.ID).List;
    end);
end;

procedure TAdapterTraderService.Update(AEntity: TEntity);
begin
  ASyncManipulation(
    AEntity,
    procedure(AMng: TObjectManager) begin AMng.Update(AEntity); end,
    procedure
    begin
      for var LProc in FEvent.OnUpdate.Listeners do
        if Assigned(LProc) then
          LProc(AEntity.ID);
    end);
end;

end.
