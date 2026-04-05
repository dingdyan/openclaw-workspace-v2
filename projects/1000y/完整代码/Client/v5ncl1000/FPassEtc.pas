unit FPassEtc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, A2Form, Deftype;
type
  TFrmPassEtc = class(TForm)
    A2Form: TA2Form;
    EdPass: TA2Edit;
    EdConfirm: TA2Edit;
    LbPass: TA2ILabel;
    LbConfirm: TA2ILabel;
    A2ButtonOK: TA2Button;
    A2ButtonCancel: TA2Button;
    A2Label1: TA2Label;
    A2ILabel1: TA2ILabel;
    procedure FormCreate(Sender: TObject);
    procedure A2ButtonOKClick(Sender: TObject);
    procedure A2ButtonCancelClick(Sender: TObject);
    procedure EdPassKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdConfirmKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
        { Private declarations }
  public
        { Public declarations }
    aType: integer;
    procedure MessageProcess(var code: TWordComData);
  end;

var
  FrmPassEtc: TFrmPassEtc;

implementation

uses FMain, AtzCls, FLogOn, FBottom, filepgkclass;

{$R *.DFM}

procedure TFrmPassEtc.MessageProcess(var code: TWordComData);
var
  PSSShowSpecialWindow: PTSShowSpecialWindow;
begin
  PSSShowSpecialWindow := @code.data;
  case PSSShowSpecialWindow^.rmsg of
    SM_SHOWSPECIALWINDOW:
      begin
        aType := 0;
        case PSSShowSpecialWindow^.rWindow of
          WINDOW_Close_All:
            begin
              Visible := false;
              exit;
            end;
          WINDOW_ShowPassWINDOW_Item: ;
          WINDOW_ShowPassWINDOW_ItemUnLock: ;
          WINDOW_ShowPassWINDOW_ItemUPDATE: ;
          WINDOW_ShowPassWINDOW_LogItem: ;
          WINDOW_ShowPassWINDOW_LogItemUnLock: ;
          WINDOW_ShowPassWINDOW_LogItemUPDATE: ;
        else exit;
        end;
        aType := PSSShowSpecialWindow^.rWindow;
        A2Label1.Caption := '';
        Visible := true;
        EdPass.Text := '';
        EdConfirm.Text := '';
        Self.SetFocus;
        EdPass.SetFocus;
        FrmM.move_win_form_Align(Self, mwfCenter);
      end;
  end;

end;

procedure TFrmPassEtc.FormCreate(Sender: TObject);
begin
  FrmM.AddA2Form(Self, A2form);

  pgkBmp.getBmp('mess.bmp', A2form.FImageSurface);
  A2form.boImagesurface := true;
  Left := 0;
  Top := 0;
  FrmM.SetA2Form(Self, A2form);
  A2ButtonOK.A2Up := (EtcAtzClass.GetEtcAtz(39));
  A2ButtonOK.A2Down := (EtcAtzClass.GetEtcAtz(40));

  A2ButtonCancel.A2Up := (EtcAtzClass.GetEtcAtz(41));
  A2ButtonCancel.A2Down := (EtcAtzClass.GetEtcAtz(42));

end;
//munetc

procedure TFrmPassEtc.A2ButtonOKClick(Sender: TObject);
var
  tt: TCPassEtc;
  cnt: integer;
begin

  case aType of
    WINDOW_ShowPassWINDOW_Item: ;
    WINDOW_ShowPassWINDOW_ItemUnLock: ;
    WINDOW_ShowPassWINDOW_ItemUPDATE: ;
    WINDOW_ShowPassWINDOW_LogItem: ;
    WINDOW_ShowPassWINDOW_LogItemUnLock: ;
    WINDOW_ShowPassWINDOW_LogItemUPDATE: ;
    WINDOW_ShowPassWINDOW_GameExit:
      begin
        FrmM.Close;
        exit;
      end;
  else exit;
  end;                                  //
  if EdPass.Text <> EdConfirm.Text then
  begin
    A2Label1.Caption := 'ÃÜÂë²»Ò»ÖÂ';
    exit;
  end;
  begin
    tt.rmsg := CM_ShowPassWindows;
    tt.rKEY := aType;
    tt.rPass := EdPass.Text;
    cnt := sizeof(tt);
    FrmLogon.SocketAddData(cnt, @tt);
    Visible := false;
    FrmBottom.SetFocus;
    FrmBottom.EdChat.SetFocus;
  end;

end;

procedure TFrmPassEtc.A2ButtonCancelClick(Sender: TObject);
var
  tt: TCPassEtc;
  cnt: integer;
begin

  case aType of
    WINDOW_ShowPassWINDOW_Item: ;
    WINDOW_ShowPassWINDOW_ItemUnLock: ;
    WINDOW_ShowPassWINDOW_ItemUPDATE: ;
    WINDOW_ShowPassWINDOW_LogItem: ;
    WINDOW_ShowPassWINDOW_LogItemUnLock: ;
    WINDOW_ShowPassWINDOW_LogItemUPDATE: ;
    WINDOW_ShowPassWINDOW_GameExit:
      begin
        FrmM.Close;
        exit;
      end;
  else exit;
  end;                                  //

  begin
    tt.rmsg := CM_ShowPassWindows;
    tt.rKEY := WINDOW_ShowPassWINDOW_Close;
    tt.rPass := EdPass.Text;
    cnt := sizeof(tt);
    FrmLogon.SocketAddData(cnt, @tt);
    Visible := false;
  end;

end;

procedure TFrmPassEtc.EdPassKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
    EdConfirm.SetFocus;
end;

procedure TFrmPassEtc.EdConfirmKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
    A2ButtonOKClick(nil);
end;

end.

