unit portIn.traderUseCase;

interface

uses
  domain.traderEntities,

  wp.Event,

  System.Classes, System.SysUtils
  ;

type
  TTraderEvent = class;
  TTraderEventClass = class of TTraderEvent;
  ITraderUseCase = interface
    ['{512FBEC2-C535-45BD-86E3-7F15FDFF4C27}']
    function GetEvent: TTraderEventClass;
    procedure ASyncDelete(AEntity: TEntity);
    procedure ASyncUpdate(AEntity: TEntity);
    procedure ASyncSave(AEntity: TEntity); overload;
    procedure ASyncSave(AEntities: TArray<TEntity>); overload;

    property Event: TTraderEventClass read GetEvent;
  end;
  TTraderEvent = class
  class var
    OnSave: TEvent<TProc<TArray<Int64>>>;
    OnUpdate: TEvent<TProc<Int64>>;
    OnDelete: TEvent<TProc<Int64>>;
  end;

implementation

end.
