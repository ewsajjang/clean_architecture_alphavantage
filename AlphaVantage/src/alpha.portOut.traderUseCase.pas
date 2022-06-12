unit alpha.portOut.traderUseCase;

interface

uses
  alpha.domain.serverEntities, alpha.domain.traderEntities,

  wp.Event,
  System.Classes, System.SysUtils
  ;

type
  TAlphaPortOutTraderEvent = class;
  TAlphaPortOutTraderEventClass = class of TAlphaPortOutTraderEvent;
  IAlphaPortOutTraderUseCase = interface
    ['{E8200665-EF67-4238-A2AC-D54E11894C12}']
    procedure Save;

    function GetPortOutEvent: TAlphaPortOutTraderEventClass;
    property PortOutEvent: TAlphaPortOutTraderEventClass read GetPortOutEvent;
  end;

  TAlphaPortOutTraderEvent = class
  class var
    OnSave: TEvent<TProc>;
  end;

implementation

end.
