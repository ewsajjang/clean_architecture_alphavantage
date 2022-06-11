unit alpha.portIn.serverUseCase;

interface

uses
  alpha.domain.serverEntities,

  System.Classes, System.SysUtils,
  System.Generics.Collections
  ;

type
  IAlphaServerUseCase = interface
    ['{17785C85-A114-4CEA-A03D-4D92114E27CB}']
    procedure ReqInflation;
    procedure ReqCpi;
    procedure ReqYield10Y;

    function GetInflation: TAlphaBody;
    function GetCpi: TAlphaBody;
    function GetYield10Y: TAlphaBody;

    property Inflation: TAlphaBody read GetInflation;
    property Cpis: TAlphaBody read GetCpi;
    property Inflations: TAlphaBody read GetYield10Y;
  end;

implementation

end.
