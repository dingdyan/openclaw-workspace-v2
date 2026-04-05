unit IMP_dialogs;
interface
uses
  Windows,
  Messages,
  SysUtils,
  CommDlg,
  Classes,
  Graphics,
  Controls,
  Forms,
  StdCtrls,
  dialogs,
  PaxScripter;
procedure RegisterIMP_dialogs;
implementation
function TCommonDialog_GetHandle:HWnd;
begin
  result := TCommonDialog(_Self).Handle;
end;
function TOpenDialog_GetFileEditStyle:TFileEditStyle;
begin
  result := TOpenDialog(_Self).FileEditStyle;
end;
procedure TOpenDialog_PutFileEditStyle(const Value: TFileEditStyle);
begin
  TOpenDialog(_Self).FileEditStyle := Value;
end;
function TOpenDialog_GetFiles:TStrings;
begin
  result := TOpenDialog(_Self).Files;
end;
function TOpenDialog_GetHistoryList:TStrings;
begin
  result := TOpenDialog(_Self).HistoryList;
end;
procedure TOpenDialog_PutHistoryList(const Value: TStrings);
begin
  TOpenDialog(_Self).HistoryList := Value;
end;
function TFindDialog_GetLeft:Integer;
begin
  result := TFindDialog(_Self).Left;
end;
procedure TFindDialog_PutLeft(const Value: Integer);
begin
  TFindDialog(_Self).Left := Value;
end;
function TFindDialog_GetPosition:TPoint;
begin
  result := TFindDialog(_Self).Position;
end;
procedure TFindDialog_PutPosition(const Value: TPoint);
begin
  TFindDialog(_Self).Position := Value;
end;
function TFindDialog_GetTop:Integer;
begin
  result := TFindDialog(_Self).Top;
end;
procedure TFindDialog_PutTop(const Value: Integer);
begin
  TFindDialog(_Self).Top := Value;
end;
procedure RegisterIMP_dialogs;
var H: Integer;
begin
  H := RegisterNamespace('dialogs', -1);
  RegisterConstant('MaxCustomColors', 16, H);
  // Begin of class TCommonDialog
  RegisterClassType(TCommonDialog, H);
  RegisterMethod(TCommonDialog,
       'constructor Create(AOwner: TComponent); override;',
       @TCommonDialog.Create);
  RegisterMethod(TCommonDialog,
       'destructor Destroy; override;',
       @TCommonDialog.Destroy);
  RegisterMethod(TCommonDialog,
       'procedure DefaultHandler(var Message); override;',
       @TCommonDialog.DefaultHandler);
  RegisterMethod(TCommonDialog,
       'function TCommonDialog_GetHandle:HWnd;',
       @TCommonDialog_GetHandle, Fake);
  RegisterProperty(TCommonDialog,
       'property Handle:HWnd read TCommonDialog_GetHandle;');
  // End of class TCommonDialog
  RegisterRTTIType(TypeInfo(TOpenOption));
  RegisterRTTIType(TypeInfo(TFileEditStyle));
  RegisterRTTIType(TypeInfo(TMsgDlgBtn));
  RegisterRTTIType(TypeInfo(TMsgDlgButtons));

  //***********************************************************************************
  RegisterConstant('mtWarning', mtWarning, H);
  RegisterConstant('mtError', mtError, H);
  RegisterConstant('mtInformation', mtInformation, H);
  RegisterConstant('mtConfirmation', mtConfirmation, H);
  RegisterConstant('mbYes', mbYes, H);
  RegisterConstant('mbNo', mbNo, H);
  //***********************************************************************************

  // Begin of class TOpenDialog
  RegisterClassType(TOpenDialog, H);
  RegisterMethod(TOpenDialog,
       'constructor Create(AOwner: TComponent); override;',
       @TOpenDialog.Create);
  RegisterMethod(TOpenDialog,
       'destructor Destroy; override;',
       @TOpenDialog.Destroy);
  RegisterMethod(TOpenDialog,
       'function Execute: Boolean; override;',
       @TOpenDialog.Execute);
  RegisterMethod(TOpenDialog,
       'function TOpenDialog_GetFileEditStyle:TFileEditStyle;',
       @TOpenDialog_GetFileEditStyle, Fake);
  RegisterMethod(TOpenDialog,
       'procedure TOpenDialog_PutFileEditStyle(const Value: TFileEditStyle);',
       @TOpenDialog_PutFileEditStyle, Fake);
  RegisterProperty(TOpenDialog,
       'property FileEditStyle:TFileEditStyle read TOpenDialog_GetFileEditStyle write TOpenDialog_PutFileEditStyle;');
  RegisterMethod(TOpenDialog,
       'function TOpenDialog_GetFiles:TStrings;',
       @TOpenDialog_GetFiles, Fake);
  RegisterProperty(TOpenDialog,
       'property Files:TStrings read TOpenDialog_GetFiles;');
  RegisterMethod(TOpenDialog,
       'function TOpenDialog_GetHistoryList:TStrings;',
       @TOpenDialog_GetHistoryList, Fake);
  RegisterMethod(TOpenDialog,
       'procedure TOpenDialog_PutHistoryList(const Value: TStrings);',
       @TOpenDialog_PutHistoryList, Fake);
  RegisterProperty(TOpenDialog,
       'property HistoryList:TStrings read TOpenDialog_GetHistoryList write TOpenDialog_PutHistoryList;');
  // End of class TOpenDialog
  // Begin of class TSaveDialog
  RegisterClassType(TSaveDialog, H);
  RegisterMethod(TSaveDialog,
       'function Execute: Boolean; override;',
       @TSaveDialog.Execute);
  RegisterMethod(TSaveDialog,
       'constructor Create(AOwner: TComponent); override;',
       @TSaveDialog.Create);
  // End of class TSaveDialog
  RegisterRTTIType(TypeInfo(TColorDialogOption));
  // Begin of class TColorDialog
  RegisterClassType(TColorDialog, H);
  RegisterMethod(TColorDialog,
       'constructor Create(AOwner: TComponent); override;',
       @TColorDialog.Create);
  RegisterMethod(TColorDialog,
       'destructor Destroy; override;',
       @TColorDialog.Destroy);
  RegisterMethod(TColorDialog,
       'function Execute: Boolean; override;',
       @TColorDialog.Execute);
  // End of class TColorDialog
  RegisterRTTIType(TypeInfo(TFontDialogOption));
  RegisterRTTIType(TypeInfo(TFontDialogDevice));
  // Begin of class TFontDialog
  RegisterClassType(TFontDialog, H);
  RegisterMethod(TFontDialog,
       'constructor Create(AOwner: TComponent); override;',
       @TFontDialog.Create);
  RegisterMethod(TFontDialog,
       'destructor Destroy; override;',
       @TFontDialog.Destroy);
  RegisterMethod(TFontDialog,
       'function Execute: Boolean; override;',
       @TFontDialog.Execute);
  // End of class TFontDialog
  // Begin of class TPrinterSetupDialog
  RegisterClassType(TPrinterSetupDialog, H);
  RegisterMethod(TPrinterSetupDialog,
       'function Execute: Boolean; override;',
       @TPrinterSetupDialog.Execute);
  RegisterMethod(TPrinterSetupDialog,
       'constructor Create(AOwner: TComponent); override;',
       @TPrinterSetupDialog.Create);
  // End of class TPrinterSetupDialog
  RegisterRTTIType(TypeInfo(TPrintRange));
  RegisterRTTIType(TypeInfo(TPrintDialogOption));
  // Begin of class TPrintDialog
  RegisterClassType(TPrintDialog, H);
  RegisterMethod(TPrintDialog,
       'function Execute: Boolean; override;',
       @TPrintDialog.Execute);
  RegisterMethod(TPrintDialog,
       'constructor Create(AOwner: TComponent); override;',
       @TPrintDialog.Create);
  // End of class TPrintDialog
  RegisterRTTIType(TypeInfo(TFindOption));
  // Begin of class TFindDialog
  RegisterClassType(TFindDialog, H);
  RegisterMethod(TFindDialog,
       'constructor Create(AOwner: TComponent); override;',
       @TFindDialog.Create);
  RegisterMethod(TFindDialog,
       'destructor Destroy; override;',
       @TFindDialog.Destroy);
  RegisterMethod(TFindDialog,
       'procedure CloseDialog;',
       @TFindDialog.CloseDialog);
  RegisterMethod(TFindDialog,
       'function Execute: Boolean; override;',
       @TFindDialog.Execute);
  RegisterMethod(TFindDialog,
       'function TFindDialog_GetLeft:Integer;',
       @TFindDialog_GetLeft, Fake);
  RegisterMethod(TFindDialog,
       'procedure TFindDialog_PutLeft(const Value: Integer);',
       @TFindDialog_PutLeft, Fake);
  RegisterProperty(TFindDialog,
       'property Left:Integer read TFindDialog_GetLeft write TFindDialog_PutLeft;');
  RegisterMethod(TFindDialog,
       'function TFindDialog_GetPosition:TPoint;',
       @TFindDialog_GetPosition, Fake);
  RegisterMethod(TFindDialog,
       'procedure TFindDialog_PutPosition(const Value: TPoint);',
       @TFindDialog_PutPosition, Fake);
  RegisterProperty(TFindDialog,
       'property Position:TPoint read TFindDialog_GetPosition write TFindDialog_PutPosition;');
  RegisterMethod(TFindDialog,
       'function TFindDialog_GetTop:Integer;',
       @TFindDialog_GetTop, Fake);
  RegisterMethod(TFindDialog,
       'procedure TFindDialog_PutTop(const Value: Integer);',
       @TFindDialog_PutTop, Fake);
  RegisterProperty(TFindDialog,
       'property Top:Integer read TFindDialog_GetTop write TFindDialog_PutTop;');
  // End of class TFindDialog
  // Begin of class TReplaceDialog
  RegisterClassType(TReplaceDialog, H);
  RegisterMethod(TReplaceDialog,
       'constructor Create(AOwner: TComponent); override;',
       @TReplaceDialog.Create);
  // End of class TReplaceDialog
  RegisterRTTIType(TypeInfo(TMsgDlgType));
  RegisterRTTIType(TypeInfo(TMsgDlgBtn));
  RegisterRoutine('function CreateMessageDialog(const Msg: string; DlgType: TMsgDlgType;  Buttons: TMsgDlgButtons): TForm;', @CreateMessageDialog, H);
  RegisterRoutine('function MessageDlg(const Msg: string; DlgType: TMsgDlgType;  Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;', @MessageDlg, H);
  RegisterRoutine('function MessageDlgPos(const Msg: string; DlgType: TMsgDlgType;  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;', @MessageDlgPos, H);
  RegisterRoutine('function MessageDlgPosHelp(const Msg: string; DlgType: TMsgDlgType;  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer;  const HelpFileName: string): Integer;', @MessageDlgPosHelp, H);
  RegisterRoutine('procedure ShowMessage(const Msg: string);', @ShowMessage, H);
  RegisterRoutine('procedure ShowMessageFmt(const Msg: string; Params: array of const);', @ShowMessageFmt, H);
  RegisterRoutine('procedure ShowMessagePos(const Msg: string; X, Y: Integer);', @ShowMessagePos, H);
  RegisterRoutine('function InputBox(const ACaption, APrompt, ADefault: string): string;', @InputBox, H);
  RegisterRoutine('function InputQuery(const ACaption, APrompt: string;  var Value: string): Boolean;', @InputQuery, H);
end;
initialization
  RegisterIMP_dialogs;
end.

