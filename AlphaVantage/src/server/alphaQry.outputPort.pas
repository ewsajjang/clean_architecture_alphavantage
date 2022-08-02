unit alphaQry.outputPort;

interface

uses
  alphaQry.entities,

  wp.Event,

  System.Classes, System.SysUtils,
  System.Generics.Collections
  ;

type
  TAlphaQryOutputPortEvent = class;
  TAlphaQryOutputPortEventClass = class of TAlphaQryOutputPortEvent;

  IAlphaQryOutputPort = interface
    ['{17785C85-A114-4CEA-A03D-4D92114E27CB}']
    function GetEvent: TAlphaQryOutputPortEventClass;
    function GetBodyEntities: TArray<TAlphaBody>;
    function GetInflation: TAlphaBody;
    function GetCpi: TAlphaBody;
    function GetYield10Y: TAlphaBody;

    procedure ReqInflation;
    procedure ReqCpi;
    procedure ReqYield10Y;

    property Event: TAlphaQryOutputPortEventClass read GetEvent;
    property BodyEntities: TArray<TAlphaBody> read GetBodyEntities;
    property Inflation: TAlphaBody read GetInflation;
    property Cpi: TAlphaBody read GetCpi;
    property Yield10Y: TAlphaBody read GetYield10Y;
  end;

  TAlphaQryOutputPortEvent = class
    class var OnSync: IEvent<TProc>;
    class var OnInflation: IEvent<TProc>;
    class var OnCpi: IEvent<TProc>;
    class var OnYield10Y: IEvent<TProc>;
  end;

implementation

end.
