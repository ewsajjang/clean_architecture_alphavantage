unit portIn.serverUseCase;

interface

uses
  domain.serverEntities,

  wp.Event,

  System.Classes, System.SysUtils,
  System.Generics.Collections
  ;

type
  TPortInServerEvent = class;
  TPortInServerEventClass = class of TPortInServerEvent;

  IPortInServerUseCase = interface
    ['{17785C85-A114-4CEA-A03D-4D92114E27CB}']
    procedure ReqInflation;
    procedure ReqCpi;
    procedure ReqYield10Y;

    function GetInflation: TAlphaBody;
    function GetCpi: TAlphaBody;
    function GetYield10Y: TAlphaBody;
    function GetEvent: TPortInServerEventClass;

    property Event: TPortInServerEventClass read GetEvent;
    property Inflation: TAlphaBody read GetInflation;
    property Cpi: TAlphaBody read GetCpi;
    property Yield10Y: TAlphaBody read GetYield10Y;
  end;

  TPortInServerEvent = class
    class var OnSync: IEvent<TProc>;
    class var OnInflation: IEvent<TProc>;
    class var OnCpi: IEvent<TProc>;
    class var OnYield10Y: IEvent<TProc>;
  end;

implementation

end.
