unit IMP_buttons;
interface
uses
  Windows,
  Messages,
  Classes,
  Controls,
  Forms,
  Graphics,
  StdCtrls,
  ExtCtrls,
  CommCtrl,
  buttons,
  PaxScripter;
procedure RegisterIMP_buttons;
implementation
procedure RegisterIMP_buttons;
var H: Integer;
begin
  H := RegisterNamespace('buttons', -1);
  RegisterRTTIType(TypeInfo(TButtonLayout));
  RegisterRTTIType(TypeInfo(TButtonState));
  RegisterRTTIType(TypeInfo(TButtonStyle));
  // Begin of class TSpeedButton
  RegisterClassType(TSpeedButton, H);
  RegisterMethod(TSpeedButton,
       'constructor Create(AOwner: TComponent); override;',
       @TSpeedButton.Create);
  RegisterMethod(TSpeedButton,
       'destructor Destroy; override;',
       @TSpeedButton.Destroy);
  RegisterMethod(TSpeedButton,
       'procedure Click; override;',
       @TSpeedButton.Click);
  // End of class TSpeedButton
  RegisterRTTIType(TypeInfo(TBitBtnKind));
  // Begin of class TBitBtn
  RegisterClassType(TBitBtn, H);
  RegisterMethod(TBitBtn,
       'constructor Create(AOwner: TComponent); override;',
       @TBitBtn.Create);
  RegisterMethod(TBitBtn,
       'destructor Destroy; override;',
       @TBitBtn.Destroy);
  RegisterMethod(TBitBtn,
       'procedure Click; override;',
       @TBitBtn.Click);
  // End of class TBitBtn
  RegisterRoutine('function DrawButtonFace(Canvas: TCanvas; const Client: TRect;  BevelWidth: Integer; Style: TButtonStyle; IsRounded, IsDown,  IsFocused: Boolean): TRect;', @DrawButtonFace, H);
end;
initialization
  RegisterIMP_buttons;
end.
