unit alpha.portIn.serverUseCase;

interface

uses
  alpha.domain.serverEntities,

  wp.Event,

  System.Classes, System.SysUtils,
  System.Generics.Collections
  ;

type
  TAlphaPortInServerEvent = class;
  TAlphaPortInServerEventClass = class of TAlphaPortInServerEvent;

  IAlphaPortInServerUseCase = interface
    ['{17785C85-A114-4CEA-A03D-4D92114E27CB}']
    procedure ReqInflation;
    procedure ReqCpi;
    procedure ReqYield10Y;

    function GetInflation: TAlphaBody;
    function GetCpi: TAlphaBody;
    function GetYield10Y: TAlphaBody;
    function GetEvent: TAlphaPortInServerEventClass;

    property Event: TAlphaPortInServerEventClass read GetEvent;
    property Inflation: TAlphaBody read GetInflation;
    property Cpi: TAlphaBody read GetCpi;
    property Yield10Y: TAlphaBody read GetYield10Y;
  end;

  TAlphaPortInServerEvent = class
    class var OnSync: IEvent<TProc>;
    class var OnInflation: IEvent<TProc>;
    class var OnCpi: IEvent<TProc>;
    class var OnYield10Y: IEvent<TProc>;
  end;

implementation

end.
