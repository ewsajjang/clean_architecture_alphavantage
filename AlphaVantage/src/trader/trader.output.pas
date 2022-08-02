unit trader.output;

interface

uses
  trader.entities, alphaSvr.entities,

  wp.Event,

  System.Classes, System.SysUtils
  ;

type
  TTraderOuputQryEvent = class
  public class var
    OnLoadIndicators: IEvent<TProc<TIndicatorList>>;
    OnLoadRawDatas: IEvent<TProc>;
  end;
  TTraderOuputQryEventClass = class of TTraderOuputQryEvent;
  ITraderOutputQry = interface
    ['{1516F952-0B3A-4E72-B831-93E8C12B80FD}']
    function GetEvent: TTraderOuputQryEventClass;

    procedure LoadIndicator;
    procedure LoadRawData(AIndicator: TIndicator);

    property Event: TTraderOuputQryEventClass read GetEvent;
  end;

implementation

end.
