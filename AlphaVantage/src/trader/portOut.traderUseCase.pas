unit portOut.traderUseCase;

interface

uses
  domain.serverEntities, domain.traderEntities,

  wp.Event,
  System.Classes, System.SysUtils
  ;

type
  TPortOutTraderEvent = class;
  TPortOutTraderEventClass = class of TPortOutTraderEvent;
  IPortOutTraderUseCase = interface
    ['{E8200665-EF67-4238-A2AC-D54E11894C12}']
    procedure Save;

    function GetPortOutEvent: TPortOutTraderEventClass;
    property PortOutEvent: TPortOutTraderEventClass read GetPortOutEvent;
  end;

  TPortOutTraderEvent = class
  class var
    OnSave: TEvent<TProc>;
  end;

implementation

end.
