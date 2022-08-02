unit alphaSvr.input;

interface

uses
  alphaSvr.entities,

  wp.Event,

  System.SysUtils
  ;

type
  TAlphaSvrInputEvent = class;
  TAlphaSvrInputEventClass = class of TAlphaSvrInputEvent;

  IAlphaSvrInput = interface
    ['{74F353A0-AF40-4805-B27E-51DEC858C9FC}']
    function GetEvent: TAlphaSvrInputEventClass;

    procedure Sync;

    property Event: TAlphaSvrInputEventClass read GetEvent;
  end;

  TAlphaSvrInputEvent = class
    class var OnInflation: IEvent<TProc>;
    class var OnCpi: IEvent<TProc>;
    class var OnYield10Y: IEvent<TProc>;
  end;

implementation

end.
