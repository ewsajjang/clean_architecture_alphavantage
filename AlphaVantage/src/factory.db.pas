unit factory.db;

interface

uses
  wp.Log,

  System.SysUtils, System.Classes,
  System.SyncObjs, Spring.Collections,
  System.Generics.Collections,

  Aurelius.Engine.DatabaseManager, Aurelius.Engine.ObjectManager, Aurelius.Events.Manager,
  Aurelius.Drivers.Interfaces, Aurelius.Drivers.SQLite, Aurelius.Drivers.FireDac,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.Intf, FireDAC.Phys.SQLiteDef, FireDAC.Comp.UI, FireDAC.Phys.SQLiteWrapper.Stat
  ;

type
  TDataModule = TwpLogDataModule;
  TfactoryDB = class(TDataModule)
    FDConn: TFDConnection;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    const SMemoryDBPath = ':memory:';
    class var FFilePath: string;
    class var FEncrypted: Boolean;
    class var FMemDB: Boolean;
    class var FPassword: string;
    class var FLog: IwpLogger;
    class var FRecovered: Boolean;
    class function GetFileExists: Boolean; static;
    class function GetLog: IwpLogger; static;
    class property Log: IwpLogger read GetLog;
  private
    FMngs: IDictionary<string, TObjectManager>;
    FConn: IDBConnection;
    FLogProc: TProc<TSQLExecutingArgs>;
    FInitialized: Boolean;
    function GetLogEnabled: Boolean;
    procedure SetLogEnabled(const Value: Boolean);
    function GetConn: IDBConnection;
  public
    class constructor Create;

    class function RemovePassword(const AFilePath, APassword: string; out AErMsg: string): Boolean; overload;
    class function RemovePassword(const AFilePath, APassword: string): Boolean; overload;
    class function AssignPassword(const AFilePath, APassword: string; out AErMsg: string): Boolean; overload;
    class function AssignPassword(const AFilePath, APassword: string): Boolean; overload;
    class function ChangePassword(const AFilePath, APassword, AToPassword: string; out AErMsg: string): Boolean;
    class function Encrypted(const AFilePath, APassword: string; out AErMsg: string): Boolean; overload;
    class function Encrypted(const AFilePath, APassword: string): Boolean; overload;
    class function Encrypted: Boolean; overload;
    class function ForceDelete: Boolean;

    class property FilePath: string read FFilePath;
    class property FileExists: Boolean read GetFileExists;
    class property Recovered: Boolean read FRecovered;
  public
    procedure Initialize(const APassword: string; AConn: IDBConnection = nil);
    function CreateSingleMng(const AName: string): TObjectManager;

    property Conn: IDBConnection read GetConn;
    property Initialized: Boolean read FInitialized;
    property LogEnabled: Boolean read GetLogEnabled write SetLogEnabled;
  end;

var
  factoryDB: TfactoryDB;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  Aurelius.Mapping.Explorer,
  System.IOUtils, wp.IOUtils, Generics.Defaults, Windows, StrUtils
  ;

{ TDbFactory }

{$REGION 'TsvcDB.ClassFunctions'}

  class function TfactoryDB.AssignPassword(const AFilePath, APassword: string; out AErMsg: string): Boolean;
  const
    SAES256 = 'aes-256';
  var
    LSecurity: TFDSQLiteSecurity;
  begin
    LSecurity := TFDSQLiteSecurity.Create(nil);
    try
      LSecurity.DriverLink := TFDPhysSQLiteDriverLink.Create(LSecurity);
      LSecurity.Database := AFilePath;
      LSecurity.Password := 'aes-256:'+APassword;
      try
        LSecurity.SetPassword;
      except on E: Exception do
      end;
      Result := Encrypted(AFilePath, APassword, AErMsg);
    finally
      LSecurity.Free;
    end;
  end;

  class function TfactoryDB.AssignPassword(const AFilePath, APassword: string): Boolean;
  begin
    var _ := '';
    Result := AssignPassword(AFilePath, APassword, _);
  end;

class function TfactoryDB.ChangePassword(const AFilePath, APassword, AToPassword: string; out AErMsg: string): Boolean;
  const
    SAES256 = 'aes-256';
  var
    LSecurity: TFDSQLiteSecurity;
  begin
    LSecurity := TFDSQLiteSecurity.Create(nil);
    try
      LSecurity.DriverLink := TFDPhysSQLiteDriverLink.Create(LSecurity);
      LSecurity.Database := AFilePath;
      LSecurity.Password := 'aes-256:'+APassword;
      LSecurity.ToPassword := 'aes-256:'+AToPassword;
      try
        LSecurity.ChangePassword;
      except on E: Exception do
      end;
      Result := Encrypted(AFilePath, APassword, AErMsg);
    finally
      LSecurity.Free;
    end;
  end;

  class function TfactoryDB.Encrypted(const AFilePAth, APassword: string; out AErMsg: string): Boolean;
  var
    LSecurity: TFDSQLiteSecurity;
    LAlgoritm: string;
  begin
    if not AFilePath.Equals(SMemoryDBPath) and not TFile.Exists(AFilePath) then
      Exit(False);

    Result := True;
    LSecurity := TFDSQLiteSecurity.Create(nil);
    try
      LSecurity.DriverLink := TFDPhysSQLiteDriverLink.Create(LSecurity);
      LSecurity.Database := AFilePath;
      LSecurity.Password := 'aes-256:'+APassword;
      try
        LAlgoritm := LSecurity.CheckEncryption;
        Result := LAlgoritm.Equals('aes-256') or LAlgoritm.Equals('<encrypted>');
      except
        on E: Exception do
        begin
          AErMsg := E.Message;
          Log.SendError(E.ClassName, E.Message);
        end;
      end;
    finally
      LSecurity.Free;
    end;
  end;

  class function TfactoryDB.ForceDelete: Boolean;
  begin
    if FileExists then
    try
      TFile.Delete(FilePath);
    except on E: Exception do
      Log.SendError(E.ClassName, E.Message);
    end;
    Result := not FileExists;
    if FileExists then
    begin
      var LErMsg := '';
      if not TFile.DeleteDelayUntilReboot(FilePath, LErMsg) then
        Log.SendError(LErMsg)
      else
      begin
        FRecovered := True;
        Exit(True);
      end;
    end;
  end;

  class function TfactoryDB.RemovePassword(const AFilePath, APassword: string; out AErMsg: string): Boolean;
  const
    SAES256 = 'aes-256';
  var
    LSecurity: TFDSQLiteSecurity;
  begin
    LSecurity := TFDSQLiteSecurity.Create(nil);
    try
      LSecurity.DriverLink := TFDPhysSQLiteDriverLink.Create(LSecurity);
      LSecurity.Database := AFilePath;
      LSecurity.Password := 'aes-256:'+APassword;
      try
        LSecurity.RemovePassword;
      except on E: Exception do
      end;
      Result := not Encrypted(AFilePath, APassword, AErMsg);
    finally
      LSecurity.Free;
    end;
  end;

  class constructor TfactoryDB.Create;
  begin
    {$IFDEF DB_FILE}
      {$IFDEF PREF_BMPC}
        FFilePath := TPath.ChangeExtension(ParamStr(0), '.db');
      {$ELSE}
        FFilePath := TPath.GetCachePath + '\BaeminOrderWin\DB\' + TPath.GetFileNameWithoutExtension(ParamStr(0))+ '.db';
      {$ENDIF}
      var LDir := TDirectory.GetParent(FFilePath);
      if not TDirectory.Exists(LDir) then
        TDirectory.CreateDirectory(LDir);
    {$ELSE IFDEF DB_MEMORY}
      FFilePath := SMemoryDBPath;
    {$ENDIF}

    FRecovered := False;
  end;

  class function TfactoryDB.GetFileExists: Boolean;
  begin
    Result := FFilePath.Equals(SMemoryDBPath) or TFile.Exists(FFilePath);
  end;

  class function TfactoryDB.GetLog: IwpLogger;
  begin
    if not Assigned(FLog) then
      FLog := TwpLoggerFactory.CreateSingle(ClassName);
    Result := FLog;
  end;

  class function TfactoryDB.RemovePassword(const AFilePath, APassword: string): Boolean;
  begin
    var _ := '';
    Result := RemovePassword(AFilePath, APassword, _);
  end;

class function TfactoryDB.Encrypted: Boolean;
begin
  Result := FEncrypted;
end;

class function TfactoryDB.Encrypted(const AFilePath, APassword: string): Boolean;
begin
  var _: string;
  Result := Encrypted(AFilePath, APassword, _);
end;

{$ENDREGION}

function TfactoryDB.CreateSingleMng(const AName: string): TObjectManager;
begin
  if not FMngs.ContainsKey(AName) then
    FMngs.Add(AName, TObjectManager.Create(Conn));
  Result := FMngs[AName];
end;

procedure TfactoryDB.DataModuleDestroy(Sender: TObject);
begin
  if not Initialized then
    Exit;

  FConn := nil;
  FInitialized := False;
end;

procedure TfactoryDB.DataModuleCreate(Sender: TObject);
begin
  {$IFDEF DEBUG} LogEnabled := False; {$ENDIF}

  FMngs := TCollections.CreateDictionary<string, TObjectManager>([doOwnsValues]);
end;

function TfactoryDB.GetConn: IDBConnection;
var
  LConnParams: TStringList;
begin
  if not Assigned(FConn) then
  begin
    LConnParams := TStringList.Create;
    try
      LConnParams.AddPair('Database', FilePath);
      //see - http://docwiki.embarcadero.com/RADStudio/en/Using_SQLite_with_FireDAC
      // The encrypted database format is not compatible with other similar SQLite encryption extensions.
      //               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      // This means that you cannot use an encrypted database, encrypted with non-FireDAC libraries.
      // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      // If you need to do this, then you have to decrypt a database with an original tool and encrypt it with FireDAC.
      if FEncrypted and not FPassword.Equals('<unencrypted>') and not FPassword.IsEmpty then
      begin
        LConnParams.AddPair('Encrypt', 'aes-256');
        LConnParams.AddPair('Password', FPassword);
      end;

      // see - http://docwiki.embarcadero.com/RADStudio/Rio/en/Using_SQLite_with_FireDAC#SQLite_Transactions.2C_Locking.2C_Threads_and_Cursors
      // when multiple threads are updating the same database, set the SharedCache connection parameter to False. This helps you avoid some possible deadlocks.
      //LConnParams.AddPair('SharedCache', 'False');
      {$IFDEF DEBUG}
        LConnParams.AddPair('LockingMode', 'Normal');
        //LConnParams.AddPair('Synchronous', 'Normal');
        LConnParams.AddPair('JournalMode', 'Memory');
      {$ENDIF}
      FDManager.AddConnectionDef('ConnDB', 'SQLite', LConnParams);
      FDManager.UpdateOptions.LockWait := True;
      FDConn.ConnectionDefName := 'ConnDB';
    finally
      LConnParams.Free;
    end;
    FConn := TFireDacConnectionAdapter.Create(FDConn, True);
    FEncrypted := TFactoryDB.Encrypted(FFilePath, FPassword);
  end;
  Result := FConn;
end;

function TfactoryDB.GetLogEnabled: Boolean;
begin
  Result := Assigned(FLogProc);
end;

procedure TfactoryDB.Initialize(const APassword: string; AConn: IDBConnection = nil);
begin
  Log.EnterMethod('Initialize');
  Log.Send('CurrentDir', TDirectory.GetCurrentDirectory);
  Log.Send('DBFilePath', FilePath);
  Log.Send(TFile.Exists(FilePath), 'DBFileExists');

  FMemDB := {$IFDEF DB_MEMORY} True {$ELSE IFDEF DB_FILE} False {$ENDIF};
  FPassword := IfThen(FMemDB, TGUID.NewGuid.ToString, APassword);
  {$IFDEF RELEASE or DBRELASE}
    var LDoEncrypt := False; //pref.FileExists;
  {$ENDIF}
  if not FileExists then
    FEncrypted := {$IFDEF RELEASE or DBRELASE} LDoEncrypt {$ELSE} False {$ENDIF}
  else
  begin
    FEncrypted := TFactoryDB.Encrypted(FFilePath, FPassword);
    {$IFDEF RELEASE or DBRELASE}
      if not FEncrypted and LDoEncrypt then
        FEncrypted := TFactoryDB.AssignPassword(FFilePath, FPassword);
    {$ELSE}
      if FEncrypted and TFactoryDB.RemovePassword(FFilePath, FPassword) then
        FEncrypted := False;
    {$ENDIF}
  end;

  FConn := AConn;
  if not Assigned(FConn) then
    FConn := Conn;
  Assert(Assigned(FConn));
  TDatabaseManager.Update(FConn);
  Log.ExitMethod('Initialize');
end;

procedure TfactoryDB.SetLogEnabled(const Value: Boolean);
begin
  if not Value then
  begin
    TMappingExplorer.Default.Events.OnSQLExecuting.Unsubscribe(FLogProc);
    FLogProc := nil;
  end
{$IFDEF DEBUG}
  else
  begin
    FLogProc := procedure(Args: TSQLExecutingArgs)
    var
      LParam: TDBParam;
    begin
      Log.Send(Args.Manager.ClassName + ':' + Args.SQL);
      if Args.Params <> nil then
        for LParam in Args.Params do
          Log.Send(LParam.ToString);
    end;
    TMappingExplorer.Default.Events.OnSQLExecuting.Subscribe(FLogProc);
  end;
{$ENDIF}
end;

end.
