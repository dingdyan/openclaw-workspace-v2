unit FConfirmDialog;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics,
    Controls, Forms, Dialogs, StdCtrls, A2Form, deftype, ExtCtrls, A2img;
type

    TfrmConfirmDialog = class(TForm)
        BtnOk: TA2Button;
        BtnCancel: TA2Button;
        a2edit: TA2Edit;
        lblText: TA2Label;
        A2Label1: TA2Label;
        Image1: TImage;
        A2Form: TA2Form;
        procedure FormCreate(Sender: TObject);
        procedure BtnOkClick(Sender: TObject);
        procedure BtnCancelClick(Sender: TObject);
        procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);
        procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
            Shift: TShiftState; X, Y: Integer);

    private
        { Private declarations }
    public
        { Public declarations }
        atype: TConfirmDialogtype;
        Fkey: integer;
        ausername: string;
        aid: integer;
        procedure MessageProcess(var code: TWordComData);

        procedure ShowFrom(atemp: TConfirmDialogtype; aCaption, atext: string);
        procedure closeFrom();

        procedure SetNewVersion;
        procedure SetOldVersion;
    end;

implementation

uses FMain, FLogOn, AUTIL32, FBottom, FGuild, filepgkclass, FAttrib,
    FCharAttrib;

{$R *.DFM}

procedure TfrmConfirmDialog.ShowFrom(atemp: TConfirmDialogtype; aCaption, atext: string);
begin
    A2Label1.Caption := aCaption;
    a2edit.Text := '';
    lblText.Caption := atext;
    Caption := atext;
    atype := atemp;
    case atype of
        cdDel_Designation:
            begin
                a2edit.Text := aCaption;
                lblText.Visible := true;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
                //  FrmM.SetA2Form(Self, A2form);
                FrmM.move_win_form_Align(Self, mwfCenter);

            end;
        cdtItemStirng:
            begin
                lblText.Visible := false;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
            end;
        cdtProcession_ADDMsg:
            begin
                lblText.Visible := true;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
                //  FrmM.SetA2Form(Self, A2form);
                FrmM.move_win_form_Align(Self, mwfCenter);
                exit;
            end;
        cdtShowInputOk:
            begin
                lblText.Visible := true;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
                //  FrmM.SetA2Form(Self, A2form);
                FrmM.move_win_form_Align(Self, mwfCenter);
                exit;
            end;
        cdtShowInputString2:
            begin
                lblText.Visible := false;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
                //  FrmM.SetA2Form(Self, A2form);
                FrmM.move_win_form_Align(Self, mwfCenter);
                exit;
            end;
        cdtHailFellowDel:
            begin

                ausername := aCaption;
                lblText.Visible := true;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
            end;
        cdtGuilGradeNameUPdate:
            begin
                ausername := atext;
                lblText.Visible := false;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
            end;
        cdtguildSysdel_SubSysop:
            begin
                a2edit.Text := aCaption;
                lblText.Visible := true;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
            end;
        cdtGuildSetSys:
            begin
                a2edit.Text := aCaption;
                lblText.Visible := true;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
            end;
        cdtGuildelevate:
            begin
                a2edit.Text := aCaption;
                lblText.Visible := true;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
            end;
        cdtGuildDel_Force:
            begin
                a2edit.Text := aCaption;
                lblText.Visible := true;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
            end;
        cdtguildSubSysopdel:
            begin
                lblText.Visible := true;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
            end;
        cdtGuildDel:
            begin

                lblText.Visible := true;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
            end;
        cdtGuilnoticeUPdate:
            begin
                lblText.Visible := false;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
            end;
        cdtguild_createName:
            begin
                lblText.Visible := false;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
            end;
        cdtProcession_ADD:
            begin
                lblText.Visible := false;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
            end;
        cdtGuildAdd:
            begin
                lblText.Visible := false;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
            end;
        cdtguild_addMsg:
            begin
                lblText.Visible := true;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
                //  FrmM.SetA2Form(Self, A2form);
                FrmM.move_win_form_Align(Self, mwfCenter);
                exit;
            end;
        cdtHailFellow:
            begin

                lblText.Visible := true;
                a2edit.Visible := not lblText.Visible;
                A2Label1.Visible := a2edit.Visible;
                //  FrmM.SetA2Form(Self, A2form);
                FrmM.move_win_form_Align(Self, mwfCenter);
                exit;
            end;
    else
        begin
            closeFrom;
            exit;
        end;

    end;
    Visible := true;
    //    FrmM.SetA2Form(Self, A2form);
    FrmM.move_win_form_Align(Self, mwfCenter);
    frmm.SetA2Form(Self, A2Form);
    if a2edit.Visible then
    begin
        SetFocus;
        a2edit.SetFocus;
    end;
end;

procedure TfrmConfirmDialog.closeFrom();
begin
    Visible := false;
    // FrmM.DelA2Form(Self, A2form);
    Close;
    SAY_EdChatFrmBottomSetFocus;
end;

procedure TfrmConfirmDialog.MessageProcess(var code: TWordComData);
var
    pckey: PTCKey;
    pSHailFellowbasic: pTSHailFellowbasic;
    sname, str: string;
    id, akey: integer;
begin
    pckey := @Code.Data;
    case pckey^.rmsg of
        SM_Procession:
            begin
                id := 1;
                akey := WordComData_GETbyte(code, id);
                if akey = Procession_ADDMsg then
                begin

                    ausername := WordComData_GETstring(code, id);
                    ShowFrom(cdtProcession_ADDMsg, '', format('【%s】邀请你入队。', [ausername]));
                end;
            end;
        SM_HailFellow:
            begin
                pSHailFellowbasic := @Code.Data;

                sname := (pSHailFellowbasic.rName);
                case pSHailFellowbasic.rkey of
                    HailFellow_Message_ADD:                                     //有人 要加我
                        begin
                            //  Visible := true;
                            ausername := sname;
                            ShowFrom(cdtHailFellow, '', format('【%s】增加你为好友。', [sname]));
                        end;

                end;

            end;
        SM_GUILD:
            begin

                id := 1;
                akey := WordComData_GETbyte(code, id);
                case akey of
                    GUILD_list_addMsg:                                          //被 人 加 是否同意
                        begin
                            ausername := WordComData_GETstring(code, id);
                            sname := WordComData_GETstring(code, id);
                            ShowFrom(cdtguild_addMsg, '', format('%s 邀请你加入【%s】门派。', [sname, ausername]));
                        end;
                    {  GUILD_Create_name:
                          begin
                              aid := WordComData_GETbyte(code, id);
                              ShowFrom(cdtguild_addMsg, '', '输入创建门派的名字。');

                          end;}
                end;
            end;
        SM_InputOk:
            begin
                id := 1;
                akey := WordComData_GETbyte(code, id);
                aid := WordComData_GETdword(code, id);
                str := WordComData_GETstring(code, id);
                ShowFrom(cdtShowInputOk, '', str);
                Fkey := akey;
            end;
        SM_SHOWINPUTSTRING2:
            begin
                id := 1;
                akey := WordComData_GETbyte(code, id);
                aid := WordComData_GETdword(code, id);
                str := WordComData_GETstring(code, id);
                ShowFrom(cdtShowInputString2, str, '');
                Fkey := akey;
            end;
    end;
end;

procedure TfrmConfirmDialog.SetNewVersion;
var
    temping: TA2Image;
begin
    temping := TA2Image.Create(32, 32, 0, 0);
    try
        pgkBmp.getBmp('添加队友好友窗口.bmp', A2Form.FImageSurface);
        A2Form.boImagesurface := true;

        pgkBmp.getBmp('通用_确认_按下.bmp', temping);
        BtnOk.A2Down := temping;
        pgkBmp.getBmp('通用_确认_弹起.bmp', temping);
        BtnOk.A2Up := temping;
        pgkBmp.getBmp('通用_确认_鼠标.bmp', temping);
        BtnOk.A2Mouse := temping;
        pgkBmp.getBmp('通用_确认_禁止.bmp', temping);
        BtnOk.A2NotEnabled := temping;
        BtnOk.Left := 118;
        BtnOk.Top := 68;
        BtnOk.Width := temping.Width;
        BtnOk.Height := temping.Height;

        pgkBmp.getBmp('通用_取消_按下.bmp', temping);
        BtnCancel.A2Down := temping;
        pgkBmp.getBmp('通用_取消_弹起.bmp', temping);
        BtnCancel.A2Up := temping;
        pgkBmp.getBmp('通用_取消_鼠标.bmp', temping);
        BtnCancel.A2Mouse := temping;
        pgkBmp.getBmp('通用_取消_禁止.bmp', temping);
        BtnCancel.A2NotEnabled := temping;
        BtnCancel.Left := 174;
        BtnCancel.Top := 68;
        BtnCancel.Width := temping.Width;
        BtnCancel.Height := temping.Height;

        a2edit.Left := 22;
        a2edit.Top := 36 + 5 + 4;
        a2edit.Width := 206;
        a2edit.Height := 25;

        lblText.Left := 22;
        lblText.Top := 36 + 5 + 4;
        lblText.Width := 206;
        lblText.Height := 25;

        Image1.Visible := false;
    finally
        temping.Free;
    end;
end;

procedure TfrmConfirmDialog.SetOldVersion;
begin
    A2Form.FImageSurface.LoadFromBitmap(Image1.Picture.Bitmap);
    A2Form.boImagesurface := true;
end;

procedure TfrmConfirmDialog.FormCreate(Sender: TObject);
begin

    //Parent := FrmM;
    FrmM.AddA2Form(Self, A2Form);
    Left := 0;
    Top := 0;

    if WinVerType = wvtNew then
    begin
        SetNewVersion;
    end
    else if WinVerType = wvtOld then
    begin
        SetOldVersion;
    end;
end;

procedure TfrmConfirmDialog.BtnOkClick(Sender: TObject);
var
    tt: TSHailFellowbasic;
    cnt: integer;
    cSay: TCSay;
    CGuild: TCGuild;
    STR: string;
    tempsend: TWordComData;
begin
    a2edit.Text := trim(a2edit.Text);
    case atype of
        cdDel_Designation:
            begin
                str := a2edit.Text;
                frmCharAttrib.send_Del_Designation(STR);
                closeFrom;
            end;
        cdtItemStirng:
            begin
                str := a2edit.Text;
                FrmAttrib.sendDblClickItemString(Fkey, STR);
                closeFrom;
            end;
        cdtProcession_ADD:
            begin
                tempsend.Size := 0;
                WordComData_ADDbyte(tempsend, CM_Procession);
                WordComData_ADDbyte(tempsend, Procession_ADDMsg);
                str := a2edit.Text;
                WordComData_ADDstring(tempsend, str);
                FrmLogon.SocketAddData(tempsend.Size, @tempsend.data);
                closeFrom;
            end;

        cdtProcession_ADDMsg:
            begin
                tempsend.Size := 0;
                WordComData_ADDbyte(tempsend, CM_Procession);
                WordComData_ADDbyte(tempsend, Procession_ADDMsgOk);
                WordComData_ADDstring(tempsend, ausername);
                FrmLogon.SocketAddData(tempsend.Size, @tempsend.data);
                closeFrom;
            end;
        cdtHailFellowDel:
            begin
                tt.rmsg := CM_HailFellow;
                tt.rKEY := HailFellow_DEL;
                str := ausername;
                TT.rName := STR;
                cnt := sizeof(TT);
                FrmLogon.SocketAddData(cnt, @TT);
                closeFrom;
            end;
        cdtguild_createName:
            begin
                {cSay.rmsg := CM_SAY;
                str := a2edit.Text;
                str := format('%s门派创建', [str]);
                SetWordString(cSay.rWordString, str);
                cnt := sizeof(cSay) - sizeof(TWordString) + SizeOfWordString(cSay.rWordString);
                FrmLogon.SocketAddData(cnt, @csay);}
                tempsend.Size := 0;
                WordComData_ADDbyte(tempsend, CM_Guild);
                WordComData_ADDbyte(tempsend, GUILD_Create_name);
                WordComData_ADDbyte(tempsend, byte(aid));
                str := (a2edit.Text);
                WordComData_ADDstring(tempsend, str);
                FrmLogon.SocketAddData(tempsend.Size, @tempsend.data);
                closeFrom;
            end;
        cdtguildSubSysopdel:
            begin
                frmGuild.sendGUILD_del_SubSysop_ic();
                closeFrom;
            end;

        cdtGuilnoticeUPdate:
            begin
                CGuild.rmsg := CM_Guild;
                CGuild.rkey := GUILD_noticeUPdate;
                str := trim(a2edit.Text);
                if str = '' then
                begin
                    closeFrom;
                    exit;
                end;
                SetWordString(CGuild.rWordString, str);
                cnt := sizeof(CGuild) - sizeof(TWordString) + SizeOfWordString(CGuild.rWordString);
                FrmLogon.SocketAddData(cnt, @CGuild);
                closeFrom;
            end;
        cdtGuildDel:
            begin
                frmGuild.sendGuilddel_ic();
                closeFrom;
            end;
        cdtguildSysdel_SubSysop:
            begin
                frmGuild.sendGUILD_del_SubSysop(a2edit.Text);
                closeFrom;
            end;
        cdtGuildSetSys:
            begin
                frmGuild.sendGUILD_set_Sysop(a2edit.Text);
                closeFrom;
            end;
        cdtGuildelevate:
            begin
                frmGuild.sendGUILD_set_SubSysop(a2edit.Text);
                closeFrom;
            end;
        cdtGuildDel_Force:
            begin
                frmGuild.sendGuilddel(a2edit.Text);
                closeFrom;
            end;
        cdtGuilGradeNameUPdate:
            begin
                frmGuild.sendGuilGradeNameUPdate(ausername, a2edit.Text);
                closeFrom;
            end;
        cdtGuildAdd:
            begin

                frmGuild.sendGuildAdd(a2edit.Text);
                closeFrom;
            end;
        cdtguild_addMsg:
            begin
                tempsend.Size := 0;
                WordComData_ADDbyte(tempsend, CM_Guild);
                WordComData_ADDbyte(tempsend, GUILD_list_addMsgOk);
                WordComData_ADDstring(tempsend, ausername);
                FrmLogon.SocketAddData(tempsend.Size, @tempsend.data);
                closeFrom;
            end;
        cdtShowInputOk:
            begin
                tempsend.Size := 0;
                WordComData_ADDbyte(tempsend, cm_InputOk);
                WordComData_ADDbyte(tempsend, byte(fkey));
                WordComData_ADDdword(tempsend, aid);
                WordComData_ADDbyte(tempsend, byte(true));
                FrmLogon.SocketAddData(tempsend.Size, @tempsend.data);
                closeFrom;
            end;
        cdtShowInputString2:
            begin
                str := a2edit.Text;
                if str = '' then exit;
                tempsend.Size := 0;
                WordComData_ADDbyte(tempsend, CM_INPUTSTRING2);
                WordComData_ADDbyte(tempsend, byte(fkey));
                WordComData_ADDdword(tempsend, aid);
                WordComData_ADDbyte(tempsend, byte(true));
                WordComData_ADDstring(tempsend, str);
                FrmLogon.SocketAddData(tempsend.Size, @tempsend.data);
                closeFrom;
            end;
        cdtHailFellow:
            begin
                tt.rmsg := CM_HailFellow;
                tt.rKEY := HailFellow_Message_ADD_OK;
                TT.rName := ausername;
                cnt := sizeof(TT);
                FrmLogon.SocketAddData(cnt, @TT);
                closeFrom;
            end;

        cdtNone: ;
    end;

end;

procedure TfrmConfirmDialog.BtnCancelClick(Sender: TObject);
var
    tt: TSHailFellowbasic;
    cnt: integer;
    tempsend: TWordComData;
begin
    case atype of

        cdtProcession_ADDMsg:
            begin
                tempsend.Size := 0;
                WordComData_ADDbyte(tempsend, CM_Procession);
                WordComData_ADDbyte(tempsend, Procession_ADDMsgNO);
                WordComData_ADDstring(tempsend, ausername);
                FrmLogon.SocketAddData(tempsend.Size, @tempsend.data);
                closeFrom;
            end;
        cdtguild_addMsg:
            begin
                tempsend.Size := 0;
                WordComData_ADDbyte(tempsend, CM_Guild);
                WordComData_ADDbyte(tempsend, GUILD_list_addMsgno);
                WordComData_ADDstring(tempsend, ausername);
                FrmLogon.SocketAddData(tempsend.Size, @tempsend.data);
                closeFrom;
            end;
        cdtShowInputOk:
            begin
                tempsend.Size := 0;
                WordComData_ADDbyte(tempsend, CM_InputOk);
                WordComData_ADDbyte(tempsend, byte(fkey));
                WordComData_ADDdword(tempsend, aid);
                WordComData_ADDbyte(tempsend, byte(false));
                FrmLogon.SocketAddData(tempsend.Size, @tempsend.data);
                closeFrom;
            end;
        cdtShowInputString2:
            begin
                tempsend.Size := 0;
                WordComData_ADDbyte(tempsend, CM_INPUTSTRING2);
                WordComData_ADDbyte(tempsend, byte(fkey));
                WordComData_ADDdword(tempsend, aid);
                WordComData_ADDbyte(tempsend, byte(false));
                FrmLogon.SocketAddData(tempsend.Size, @tempsend.data);
                closeFrom;
            end;
        cdtHailFellow:
            begin
                tt.rmsg := CM_HailFellow;
                tt.rKEY := HailFellow_Message_ADD_NO;
                TT.rName := ausername;
                cnt := sizeof(TT);
                FrmLogon.SocketAddData(cnt, @TT);
                closeFrom;
            end;
        cdtNone: closeFrom;
        cdtGuildAdd: closeFrom;
    else closeFrom;
    end;

end;

procedure TfrmConfirmDialog.Image1MouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    // if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
end;

procedure TfrmConfirmDialog.FormMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then FrmM.move_win_form_set(self, x, y);
    FrmM.SetA2Form(Self, A2form);

    //a2edit.SetFocus;
end;

end.

