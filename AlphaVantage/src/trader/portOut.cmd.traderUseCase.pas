unit portOut.cmd.traderUseCase;

interface

uses
  domain.traderEntities, domain.serverEntities,

  wp.Event,

  System.Classes, System.SysUtils
  ;

type
  TCmdTraderUseCaseEvent = class;
  TCmdTraderUseCaseEventClass = class of TCmdTraderUseCaseEvent;
  ICmdTraderUseCase = interface
    ['{1790A980-3413-483B-910D-C304C52B7EA4}']
    function GetEvent: TCmdTraderUseCaseEventClass;

    procedure Save(ABodyEntities: TArray<TAlphaBody>);
    procedure Delete(AEntity: TEntity);
    procedure Update(AEntity: TEntity);

    property Event: TCmdTraderUseCaseEventClass read GetEvent;
  end;

  TCmdTraderUseCaseEvent = class
  class var
    OnSave: IEvent<TProc>;
    OnUpdate: IEvent<TProc<Int64>>;
    OnDelete: IEvent<TProc<Int64>>;
  end;

implementation

end.
