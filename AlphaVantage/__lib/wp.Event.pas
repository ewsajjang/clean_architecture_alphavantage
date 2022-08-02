unit wp.Event;

interface

uses
  Classes, SysUtils, RTTI,
  Generics.Collections
  ;

type
  TNotifyDestroy = procedure(AObject: TObject) of object;

  IEvent = interface
    ['{B782DAFD-48A3-4EDC-B89F-BDF63162DE20}']
    procedure Unsubscribe(AOwner: TObject);
  end;

  IEvent<T> = interface(IEvent)
    ['{5E7BCFA4-6B6D-428F-A790-6E02521842E4}']
    procedure Subscribe(AOwner: TObject; AListener: T);
    function Listeners: TArray<T>;
  end;

  TEvent<T> = class(TInterfacedObject, IEvent<T>)
  private type
    TItem = record
      Owner: TObject;
      Listener: T;
    end;
  strict private
    FList: TArray<TItem>;
    FListeners: TArray<T>;
    function GetCount: Integer;
    procedure OnListnerDestory(Sender: TObject);
    procedure Unsubscribe(AOwner: TObject);
  public
    procedure Subscribe(AOwner: TObject; AListener: T); overload;
    procedure UnsubscribeAll;

    function Listeners: TArray<T>;
    property Count: Integer read GetCount;
  end;

  IEventListener = interface
    ['{0BE861E0-64D6-457E-9861-06F438EC10B7}']
    function GetListnerName: string;
    function GetOnListenerDestroy: TNotifyDestroy;
    procedure SetOnListenerDestroy(AValue: TNotifyDestroy);
    function GetEvents: TList<IEVent>;

    property Events: TList<IEvent> read GetEvents;
    property ListnerName: string read GetListnerName;
    property OnListenerDestroy: TNotifyDestroy read GetOnListenerDestroy write SetOnListenerDestroy;
  end;

implementation

uses
  wp.Forms, wp.Classes,

  Generics.Defaults, Types
  ;

{ TEvent<T> }

function TEvent<T>.GetCount: Integer;
begin
  Result := Length(FList);
end;

procedure TEvent<T>.Subscribe(AOwner: TObject; AListener: T);
var
  LOwner: TComponent absolute AOwner;
  LItem: TItem;
  LListener: IEventListener;
  LEvent: IEvent<T>;
begin
  Assert(Supports(AOwner, IEventListener, LListener));
  LItem.Owner := AOwner;
  LItem.Listener := AListener;
  LListener.OnListenerDestroy := OnListnerDestory;

  Assert(Supports(Self, IEvent<T>, LEvent));
  LListener.Events.Add(LEvent);

  FList := FList + [LItem];
  FListeners := FListeners + [AListener];
end;

function TEvent<T>.Listeners: TArray<T>;
begin
  Result := FListeners
end;

procedure TEvent<T>.OnListnerDestory(Sender: TObject);
var
  LListener: IEventListener;
begin
  Assert(Supports(Sender, IEventListener, LListener));
  for var LEvent in LListener.Events do
    LEvent.Unsubscribe(Sender);
end;

procedure TEvent<T>.Unsubscribe(AOwner: TObject);
begin
  Assert(Assigned(AOwner));
  var LOwner: IEventListener;
  if Supports(AOwner, IEventListener, LOwner) then
    for var i := Count -1 downto 0 do
    begin
      var LListener: IEventListener;
      if Supports(FList[i].Owner, IEventListener, LListener) then
        if Assigned(LListener) and (LListener.ListnerName = LOwner.ListnerName) then
        begin
          for var j := i to Count -2 do
          begin
            FList[j] := FList[j +1];
            FListeners[j] := FListeners[j +1];
          end;
          var LCnt := Count;
          SetLength(FList, LCnt -1);
          SetLength(FListeners, LCnt -1);
        end;
    end;
end;

procedure TEvent<T>.UnsubscribeAll;
begin
  SetLength(FList, 0);
  SetLength(FListeners, 0);
end;

end.