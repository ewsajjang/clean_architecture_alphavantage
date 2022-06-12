unit alpha.portIn.traderUseCase;

interface

uses
  alpha.domain.traderEntities,

  wp.Event,

  System.Classes, System.SysUtils
  ;

type
  TAlphaTraderEvent = class;
  TAlphaTraderEventClass = class of TAlphaTraderEvent;
  IAlphaTraderUseCase = interface
    ['{512FBEC2-C535-45BD-86E3-7F15FDFF4C27}']
    function GetEvent: TAlphaTraderEventClass;
    procedure ASyncDelete(AEntity: TEntity);
    procedure ASyncUpdate(AEntity: TEntity);
    procedure ASyncSave(AEntity: TEntity); overload;
    procedure ASyncSave(AEntities: TArray<TEntity>); overload;

    property Event: TAlphaTraderEventClass read GetEvent;
  end;
  TAlphaTraderEvent = class
  class var
    OnSave: TEvent<TProc<TArray<Int64>>>;
    OnUpdate: TEvent<TProc<Int64>>;
    OnDelete: TEvent<TProc<Int64>>;
  end;

implementation

end.
