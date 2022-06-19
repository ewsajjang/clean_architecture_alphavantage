unit domain.traderEntities;

interface

uses
  Aurelius.Types.Nullable, Aurelius.Types.Blob, Aurelius.Types.Proxy, Aurelius.Mapping.Attributes,
  Classes, SysUtils, Vcl.Graphics,
  Generics.Collections, Generics.Defaults
  ;

type
  TIndicator = class;
  TRawData = class;

  TIndicatorList = TList<TIndicator>;
  TRawDataList = TList<TRawData>;

  {$SCOPEDENUMS ON}
  [AutoMapping]
  TIndicatorKind = (
    Inflation, // Inflation - US Consumer Prices
    CPI, // Consumer Price Index for all Urban Consumers
    Yield10Year // 10-Year Treasury Constant Maturity Rate
  );

  [Entity, AutoMapping, Model('Entity')]
  TEntity = class
  private
    FID: Int64;
  public
    property ID: Int64 read FID write FID;
  end;

  [Entity, AutoMapping]
  TIndicator = class(TEntity)
  private
    FName: string;
    FInterval: string;
    FUnit: string;
  public
    property ID;
    property Name: string read FName write FName;
    property Interval: string read FInterval write FInterval;
    property &Unit: string read FUnit write FUnit;
  end;

  [Entity, AutoMapping]
  TRawData = class(TEntity)
  private
    FIndicatorID: Integer;
    FDate: string;
    FValue: Double;
  public
    property ID;
    property IndicatorID: Integer read FIndicatorID write FIndicatorID;
    property Date: string read FDate write FDate;
    property Value: Double read FValue write FValue;
  end;

implementation

initialization
  RegisterEntity(TIndicator);
  RegisterEntity(TRawData);

end.
