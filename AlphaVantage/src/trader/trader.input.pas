unit trader.input;

interface

uses
  alphaSvr.entities,

  wp.Event,

  System.SysUtils, System.Classes
  ;

type
  TTraderInputEvent = class
  public
    class var OnSave: IEvent<TProc>;
  end;
  TTraderInputEventClass = class of TTraderInputEvent;

  ITraderInput = interface
    ['{10DDD9BB-6B6B-49B8-9488-858C05DF8F96}']
    function GetEvent: TTraderInputEventClass;

    procedure Save(ABodyEntities: TArray<TAlphaBody>);

    property Event: TTraderInputEventClass read GetEvent;
  end;

implementation

end.
