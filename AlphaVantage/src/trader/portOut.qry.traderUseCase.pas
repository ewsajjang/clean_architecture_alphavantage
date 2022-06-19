unit portOut.qry.traderUseCase;

interface

uses
  domain.traderEntities,

  wp.Event,

  System.Classes, System.SysUtils
  ;

type
  TQryTraderUseCaseEvent = class;
  TQryTraderUseCaseEventClass = class of TQryTraderUseCaseEvent;

  IQryTraderUseCase = interface
    ['{1516F952-0B3A-4E72-B831-93E8C12B80FD}']
    function GetEvent: TQryTraderUseCaseEventClass;

    procedure LoadIndicator;
    procedure LoadRawData(AIndicator: TIndicator);

    property Event: TQryTraderUseCaseEventClass read GetEvent;
  end;

  TQryTraderUseCaseEvent = class
  class var
    OnLoadIndicators: IEvent<TProc<TIndicatorList>>;
    OnLoadRawDatas: IEvent<TProc>;
  end;

implementation

end.
