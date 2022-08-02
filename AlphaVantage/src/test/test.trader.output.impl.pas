unit test.trader.output.impl;

interface

uses
  trader.output
  ;

type
  {$M+}
  TestITraderOutputCmd = class
  published
    procedure ImplITraderOutputCmd;
  end;
  {$M-}

implementation

uses
  System.Rtti, System.TypInfo, System.SysUtils,
  Delphi.Mocks;

{ TestITraderOutputCmd }

procedure TestITraderOutputCmd.ImplITraderOutputCmd;
var
  LTraderOutputCmd: TMock<ITraderInputCmd>;
begin
  LTraderOutputCmd := TMock<ITraderOutputCmd>.Create;
  LTraderOutputCmd.Setup.WillExecute(
    function(const Args: TArray<TValue>; const ReturnType: TRttiType): TValue
    begin

    end);
end;

end.
