unit alpha.domain.entities;

interface

uses
  Aurelius.Types.Nullable, Aurelius.Types.Blob, Aurelius.Types.Proxy, Aurelius.Mapping.Attributes,
  Classes, SysUtils, Vcl.Graphics,
  Generics.Collections, Generics.Defaults
  ;

type
  TIndicator = class;
  TRawData = class;

  {$SCOPEDENUMS ON}
  [AutoMapping]
  TIndicatorKind = (
    Inflation, // Inflation - US Consumer Prices
    CPI, // Consumer Price Index for all Urban Consumers
    Yield10Year // 10-Year Treasury Constant Maturity Rate
  );

  [Entity, AutoMapping]
  TIndicator = class
  private
    FID: Integer;
    FName: string;
    FInterval: string;
    FUnit: string;
  public
    property ID: Integer read FID write FID;
    property Name: string read FName write FName;
    property Interval: string read FInterval write FInterval;
    property &Unit: string read FUnit write FUnit;
  end;

  TRawData = class
  private
    FID: Integer;
    FIndicatorID: Integer;
    FDate: string;
    FValue: Double;
  public
    property ID: Integer read FID write FID;
    property IndicatorID: Integer read FIndicatorID write FIndicatorID;
    property Date: string read FDate write FDate;
    property Value: Double read FValue write FValue;
  end;

implementation

initialization
  RegisterEntity(TIndicator);
  RegisterEntity(TRawData);

end.
