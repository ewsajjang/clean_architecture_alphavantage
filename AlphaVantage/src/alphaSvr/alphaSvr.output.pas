unit alphaSvr.output;

interface

uses
  alphaSvr.entities,

  wp.Event,

  System.Classes, System.SysUtils,
  System.Generics.Collections
  ;

type
  TAlphaSvrOutputEvent = class
  public class var
    class var OnInflation: IEvent<TProc>;
    class var OnCpi: IEvent<TProc>;
    class var OnYield10Y: IEvent<TProc>;
  end;
  TAlphaSvrOutputEventClass = class of TAlphaSvrOutputEvent;
  IAlphaSvrOutput = interface
    ['{35CCAD14-84F7-4547-8321-055D1648BF8C}']
    function GetEvent: TAlphaSvrOutputEventClass;
    function GetBodyEntities: TArray<TAlphaBody>;
    function GetInflation: TAlphaBody;
    function GetCpi: TAlphaBody;
    function GetYield10Y: TAlphaBody;

    procedure ReqInflation;
    procedure ReqCpi;
    procedure ReqYield10Y;

    property Event: TAlphaSvrOutputEventClass read GetEvent;
    property BodyEntities: TArray<TAlphaBody> read GetBodyEntities;
    property Inflation: TAlphaBody read GetInflation;
    property Cpi: TAlphaBody read GetCpi;
    property Yield10Y: TAlphaBody read GetYield10Y;
  end;

implementation

end.
