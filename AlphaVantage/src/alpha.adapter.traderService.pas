unit alpha.adapter.traderService;

interface

uses
  alpha.portIn.traderUseCase, alpha.domain.traderEntities,
  m.objMngTh,

  wp.Log, wp.Event,
  Aurelius.Engine.ObjectManager,

  System.Classes, System.SysUtils
  ;

type
  TAlphaAdapterTraderService = class(TwpLogObject, IAlphaTraderUseCase)
  private
    FMngTh: TObjMngTh;
    FEvent: TAlphaTraderEventClass;
    function GetEvent: TAlphaTraderEventClass;
    procedure ASync(AEntity: TEntity; const AThProc: TProc<TObjectManager>; const ADoneProc: TProc<TArray<Int64>> = nil);
  public
    constructor Create;
    destructor Destroy; override;

    procedure ASyncDelete(AEntity: TEntity);
    procedure ASyncUpdate(AEntity: TEntity);
    procedure ASyncSave(AEntity: TEntity); overload;
    procedure ASyncSave(AEntities: TArray<TEntity>); overload;
  end;

implementation

uses
  factory.db,

  Spring
  ;

{ TAlphaAdapterTraderService }

constructor TAlphaAdapterTraderService.Create;
begin
  Log := TwpLoggerFactory.CreateSingle(ClassName);

  FEvent.OnSave := TEvent<TProc<TArray<Int64>>>.Create;
  FEvent.OnUpdate := TEvent<TProc<Int64>>.Create;
  FEvent.OnDelete := TEvent<TProc<Int64>>.Create;

  FMngTh := TObjMngTh.Create(ClassName + '.MngTh', FactoryDB.CreateSingleMng(ClassName + '.ObjMng'));
  FMngTh.Start;
end;

procedure TAlphaAdapterTraderService.ASync(AEntity: TEntity; const AThProc: TProc<TObjectManager>; const ADoneProc: TProc<TArray<Int64>>);
begin
  FMngTh.ASync(
    function(AMng: TObjectManager): TArray<Int64>
    begin
      AThProc(AMng);
      var LAttached := False;
      try
        LAttached := AMng.IsAttached(AEntity);
        if LAttached then
        begin
          AMng.Flush;
          Result := [AEntity.ID];
        end;
      finally
        if not LAttached then
          AEntity.Free;
      end;
    end,
    procedure(AEntityIDs: TArray<Int64>)
    begin
      if Assigned(ADoneProc) then
        ADoneProc(AEntityIDs);
    end);
end;

procedure TAlphaAdapterTraderService.ASyncDelete(AEntity: TEntity);
begin
  ASync(
    AEntity,
    procedure(AMng: TObjectManager) begin AMng.Remove(AEntity); end,
    procedure(AEntityIDs: TArray<Int64>)
    begin
      for var LProc in FEvent.OnDelete.Listeners do
        if Assigned(LProc) then
          LProc(AEntityIDs[0]);
    end);
end;

procedure TAlphaAdapterTraderService.ASyncSave(AEntity: TEntity);
begin
  ASync(
    AEntity,
    procedure(AMng: TObjectManager) begin AMng.Save(AEntity); end,
    procedure(AEntityIDs: TArray<Int64>)
    begin
      for var LProc in FEvent.OnSave.Listeners do
        if Assigned(LProc) then
          LProc(AEntityIDs);
    end);
end;

destructor TAlphaAdapterTraderService.Destroy;
begin
  FMngTh.Terminate;
  FMngTh := nil;

  inherited;
end;

function TAlphaAdapterTraderService.GetEvent: TAlphaTraderEventClass;
begin
  Result := FEvent;
end;

procedure TAlphaAdapterTraderService.ASyncSave(AEntities: TArray<TEntity>);
begin
  FMngTh.ASync(
    function(AMng: TObjectManager): TArray<Int64>
    begin
      var LTran := AMng.Connection.BeginTransaction;
      try
        try
          var i := 0;
          SetLength(Result, Length(AEntities));
          for var LEntity in AEntities do
          begin
            AMng.Save(LEntity);
            var LAttached := False;
            try
              LAttached := AMng.IsAttached(LEntity);
              if LAttached then
              begin
                AMng.Flush;
                Result[i] := LEntity.ID;
                Inc(i);
              end;
            finally
              if not LAttached then
                LEntity.Free;
            end;
          end;
          SetLength(Result, i +1);
        except
          on E: Exception do
          begin
            LTran.Rollback;
            SetLength(Result, 0);
          end;
        end;
      finally
        LTran.Commit;
      end;
    end,
    procedure(AEntityIDs: TArray<Int64>)
    begin
      for var LProc in FEvent.OnSave.Listeners do
        if Assigned(LProc) then
          LProc(AEntityIDs);
    end);
end;

procedure TAlphaAdapterTraderService.ASyncUpdate(AEntity: TEntity);
begin
  ASync(
    AEntity,
    procedure(AMng: TObjectManager) begin AMng.Update(AEntity); end,
    procedure(AEntityIDs: TArray<Int64>)
    begin
      for var LProc in FEvent.OnUpdate.Listeners do
        if Assigned(LProc) then
          LProc(AEntityIDs[0]);
    end);
end;

end.
