unit alpha.domain.serverEntities;

interface

uses
  m.httpClient,

  wp.JSON,

  System.Classes, System.SysUtils, Spring,
  System.Generics.Collections, Spring.Collections
  ;

type
  TAlphaInflationTask = class;
  TAlphaCpiTask = class;
  TAlphaYield10YTask = class;
  TAlphaData = class;

  [FieldInPrivate]
  TAlphaBody<T: class> = class(TJsonBody)
  private
    Fname: TNullableString; //"Inflation - US Consumer Prices",
    Finterval: TNullableString; //"annual",
    Funit: TNullableString; //"percent",
    Fdata: TObjectList<T>;
    function GetString(const Index: Integer): string;
    function GetEnumerable: TEnumerable<T>;
    function GetDataCnt: Integer;
    function GetDataItems(Index: Integer): T;
  public
    destructor Destroy; override;

    function ToLabelText: string;

    property Name: string index 0 read GetString;
    property Interval: string index 1 read GetString;
    property &Unit: string index 2 read GetString;
    property Datas: TEnumerable<T> read GetEnumerable;
    property DataCnt: Integer read GetDataCnt;
    property DataItems[Index: Integer]: T read GetDataItems; default;
  end;
  [FieldInPrivate]
  TAlphaData = class(TJsonBody)
  private
    Fdate: TNullableString;
    Fvalue: TNullableString;
    function GetString(const Index: Integer): string;
  public
    function ToLabelText: string;
    property Date: string index 0 read GetString;
    property Value: string index 1 read GetString;
  end;

  TAlphaBody = TAlphaBody<TAlphaData>;
  TAlphaTask = class(THttpClientGetTask<TAlphaBody>)
  protected
    function DoSerialize(const ARspContent: string; out ARsp: TAlphaBody): Boolean; override;
  public
    procedure MoveTo(out ADst: TAlphaBody);
  end;

  TAlphaInflationTask = class(TAlphaTask)
  public
    constructor Create(ARspProc: TProc<THttpClientTask> = nil); reintroduce;
  end;

  TAlphaCpiTask = class(TAlphaTask)
  public
    constructor Create(ARspProc: TProc<THttpClientTask> = nil); reintroduce;
  end;

  TAlphaYield10YTask = class(TAlphaTask)
  public
    constructor Create(ARspProc: TProc<THttpClientTask> = nil); reintroduce;
  end;

implementation

uses
  wp.HTTP
  ;

{ TAlphaBody<T> }

destructor TAlphaBody<T>.Destroy;
begin
  if Assigned(Fdata) then
    Fdata.Free;
end;

function TAlphaBody<T>.GetDataCnt: Integer;
begin
  Result := Fdata.Count
end;

function TAlphaBody<T>.GetDataItems(Index: Integer): T;
begin
  Result := Fdata[Index];
end;

function TAlphaBody<T>.GetEnumerable: TEnumerable<T>;
begin
  Result := Fdata
end;

function TAlphaBody<T>.GetString(const Index: Integer): string;
begin
  Result := '';
  case Index of
    0: if Fname.HasValue then Result := Fname.Value;
    1: if Finterval.HasValue then Result := Finterval.Value;
    2: if FUnit.HasValue then Result := FUnit.Value;
  end;
end;

function TAlphaBody<T>.ToLabelText: string;
begin
  Result := Format('%s'#13#10'%s(%s)', [Name, &Unit, Interval]);
end;

{ TAlphaData }

function TAlphaData.GetString(const Index: Integer): string;
begin
  Result := '';
  case Index of
    0: if Fdate.HasValue then Result := Fdate.Value;
    1: if Fvalue.HasValue then Result := Fvalue.Value;
  end;
end;

function TAlphaData.ToLabelText: string;
begin
  Result := Format('%.11s: %s', [Date, Value.Substring(0, 3)]);
end;

{ TAlphaTask }

function TAlphaTask.DoSerialize(const ARspContent: string; out ARsp: TAlphaBody): Boolean;
begin
  Result := (HTTPStatusCode = Status200_OK) and TJsonSerializer.TryAs<TAlphaBody>(FRspContent, ARsp);
end;

procedure TAlphaTask.MoveTo(out ADst: TAlphaBody);
begin
  if Assigned(ADst) then
    ADst.Free;

  ADst := FRsp;
  FRsp := nil;
end;

{ TAlphaInflationTask }

constructor TAlphaInflationTask.Create(ARspProc: TProc<THttpClientTask>);
begin
  inherited Create('https://www.alphavantage.co/query?function=INFLATION&apikey=demo', ARspProc);
end;

{ TAlphaCpiTask }

constructor TAlphaCpiTask.Create(ARspProc: TProc<THttpClientTask>);
begin
  inherited Create('https://www.alphavantage.co/query?function=CPI&interval=monthly&apikey=demo', ARspProc);
end;

{ TAlphaYield10YTask }

constructor TAlphaYield10YTask.Create(ARspProc: TProc<THttpClientTask>);
begin
  inherited Create('https://www.alphavantage.co/query?function=TREASURY_YIELD&interval=monthly&maturity=10year&apikey=demo', ARspProc);
end;

end.
