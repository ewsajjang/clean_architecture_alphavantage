unit alpha.portIn.traderUseCase;

interface

uses
  alpha.domain.entities,

  System.Classes, System.SysUtils
  ;

type
  IAlphaTraderUseCase = interface
    ['{512FBEC2-C535-45BD-86E3-7F15FDFF4C27}']
    procedure Delete(AEntity: TRawData);
    procedure Update(AEntity: TRawData);
    procedure Save(AEntity: TRawData); overload;
    procedure Save(AEntities: TArray<TRawData>); overload;
  end;

implementation

end.
