unit alphaQry.useCase;

interface

uses
  alphaQry.outputPort,

  wp.log,

  System.SysUtils, System.Classes;

type
  TDataModule = TwpLogDataModule;
  TalphaQryUserCase = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FOutputPort: IAlphaQryOutputPort;
  public
  end;

var
  alphaQryUserCase: TalphaQryUserCase;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Spring.Container
  ;

{ TalphaAdapterServerController }

procedure TalphaQryUserCase.DataModuleCreate(Sender: TObject);
begin
  Log := TwpLoggerFactory.CreateSingle(ClassName);

  FOutputPort := GlobalContainer.Resolve<IAlphaQryOutputPort>;
end;

procedure TalphaQryUserCase.DataModuleDestroy(Sender: TObject);
begin
  GlobalContainer.Release(FOutputPort);
end;

end.
