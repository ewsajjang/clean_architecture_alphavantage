unit portIn.traderUseCase;

interface

uses
  domain.traderEntities,

  wp.Event,

  System.Classes, System.SysUtils, System.Generics.Collections
  ;

type
  TPortInTraderEvent = class;
  TPortInTraderEventClass = class of TPortInTraderEvent;
  IPortInTraderUseCase = interface
    ['{512FBEC2-C535-45BD-86E3-7F15FDFF4C27}']
    function GetEvent: TPortInTraderEventClass;

    procedure LoadIndicator;
    procedure LoadRawData(AIndicator: TIndicator);
    procedure Delete(AEntity: TEntity);
    procedure Update(AEntity: TEntity);

    property Event: TPortInTraderEventClass read GetEvent;
  end;
  TPortInTraderEvent = class
  class var
    OnIndicatorList: IEvent<TProc<TIndicatorList>>;
    OnRawDataList: IEvent<TProc>;
    OnUpdate: IEvent<TProc<Int64>>;
    OnDelete: IEvent<TProc<Int64>>;
  end;

implementation

end.
