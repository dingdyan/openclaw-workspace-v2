unit StripeEvent;

interface

uses Windows, SysUtils, Classes;

type
  TEventCallback = procedure(EventType: string; Data: string) of object;

  TStripeHook = class(TObject)
  private
    FOnEvent: TEventCallback;
  public
    procedure RegisterEventHook(EventType: string; Callback: TEventCallback);
    procedure TriggerEvent(EventType: string; Data: string);
  end;

implementation

procedure TStripeHook.RegisterEventHook(EventType: string; Callback: TEventCallback);
begin
  FOnEvent := Callback;
end;

procedure TStripeHook.TriggerEvent(EventType: string; Data: string);
begin
  if Assigned(FOnEvent) then FOnEvent(EventType, Data);
end;

end.
