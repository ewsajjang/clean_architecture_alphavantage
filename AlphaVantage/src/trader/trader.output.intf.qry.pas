unit trader.output.intf.qry;

interface

uses
  trader.entities,

  wp.Event,

  System.Classes, System.SysUtils
  ;

type
  TTraderOuputQryEvent = class;
  TTraderOuputQryEventClass = class of TTraderOuputQryEvent;
  ITraderOutputQry = interface
    ['{1516F952-0B3A-4E72-B831-93E8C12B80FD}']
    function GetEvent: TTraderOuputQryEventClass;

    procedure LoadIndicator;
    procedure LoadRawData(AIndicator: TIndicator);

    property Event: TTraderOuputQryEventClass read GetEvent;
  end;

  TTraderOuputQryEvent = class
  class var
    OnLoadIndicators: IEvent<TProc<TIndicatorList>>;
    OnLoadRawDatas: IEvent<TProc>;
  end;

implementation

end.
