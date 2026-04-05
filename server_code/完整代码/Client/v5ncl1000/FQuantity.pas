unit FQuantity;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, A2Form, ExtCtrls, deftype, AUtil32;

type
    TQitemData = record
        itemName:string[16];
        Count:integer;
    end;

    TShowType = (SH_Server, SH_DepositoryIn, SH_DepositoryOut,
        SH_ExChange, SH_FAttrib, SH_NPCTrade, SH_NewEmail, SH_NewAuction);
    TFrmQuantity = class(TForm)
        Image1:TImage;
        BtnOK:TA2Button;
        BtnCancel:TA2Button;
        LbCountName:TLabel;
        EdCount:TA2Edit;
        A2Button1:TA2Button;
        procedure BtnOKClick(Sender:TObject);
        procedure BtnCancelClick(Sender:TObject);
        procedure FormCreate(Sender:TObject);
        procedure FormDestroy(Sender:TObject);

        procedure Clear;
        procedure FormShow(Sender:TObject);
        procedure EdCountKeyDown(Sender:TObject; var Key:Word; Shift:TShiftState);
        procedure SetFormText;
        procedure A2Button1Click(Sender:TObject);
    private
        { Private declarations }
    public
        msg:byte;
        Countid:LongInt;
        sourkey:word;
        destkey:word;
        CountCur:LongInt;
        CountMax:LongInt;
        CountName:string;

        ShowType:TShowType;                                                     // TRUE ServerType
        procedure MYVisible(aVisible:Boolean; aType:TShowType; aItemName, aCount:string);
        procedure MessageProcess(var code:TWordComData);

        procedure showinputCount(aShowType:TShowType; asourkey, adestkey, aCountCur, aCountMax:integer; aCountName:string);

        procedure SetNewVersion;
        procedure SetOldVersion;
    end;

var
    FrmQuantity     :TFrmQuantity;

implementation

uses FMain, FExchange, FLogOn, FBottom, FDepository, FAttrib, FNPCTrade,
    FNewEMAIL, FAuction, AuctionBuy, filepgkclass;

{$R *.DFM}

procedure TFrmQuantity.showinputCount(aShowType:TShowType; asourkey, adestkey, aCountCur, aCountMax:integer; aCountName:string);
begin
    ShowType := aShowType;

    sourkey := asourkey;
    destkey := adestkey;
    CountCur := aCountCur;
    CountMax := aCountMax;
    CountName := aCountName;
    LbCountName.Caption := CountName;
    EdCount.Text := inttostr(CountCur);
    Visible := true;
end;

procedure TfrmQuantity.SetNewVersion;
var
    temping         :TBitmap;
begin
    temping := TBitmap.Create;
    try
        pgkBmp.getBitmap('物品买卖丢弃窗口.bmp', temping);
        Image1.Picture.Bitmap := temping;
        Image1.Width := temping.Width;
        Image1.Height := temping.Height;

        pgkBmp.getBitmap('通用_确认_弹起.bmp', temping);
        BtnOK.UpImage.Bitmap := temping;
        pgkBmp.getBitmap('通用_确认_按下.bmp', temping);
        BtnOK.DownImage.Bitmap := temping;
        pgkBmp.getBitmap('通用_确认_鼠标.bmp', temping);
        BtnOK.ImageMouse.Bitmap := temping;
        pgkBmp.getBitmap('通用_确认_禁止.bmp', temping);
        BtnOK.ImageNotEnabled.Bitmap := temping;
        BtnOK.Left := 46;
        BtnOK.Top := 56;
        BtnOK.Width := 56;
        BtnOK.Height := 22;

        pgkBmp.getBitmap('通用_取消_弹起.bmp', temping);
        BtnCancel.UpImage.Bitmap := temping;
        pgkBmp.getBitmap('通用_取消_按下.bmp', temping);
        BtnCancel.DownImage.Bitmap := temping;
        pgkBmp.getBitmap('通用_取消_鼠标.bmp', temping);
        BtnCancel.ImageMouse.Bitmap := temping;
        pgkBmp.getBitmap('通用_取消_禁止.bmp', temping);
        BtnCancel.ImageNotEnabled.Bitmap := temping;
        BtnCancel.Left := 102;
        BtnCancel.Top := 56;
        BtnCancel.Width := 56;
        BtnCancel.Height := 22;

        LbCountName.Left := 50;
        LbCountName.Top := 15;
        LbCountName.Width := 106;
        LbCountName.Height := 15;

        EdCount.Left := 46;
        EdCount.Top := 26;
        EdCount.Width := 106;
        EdCount.Height := 15;

        A2Button1.Visible := false;
    finally
        temping.Free;
    end;

end;

procedure TfrmQuantity.SetOldVersion;
begin
end;

procedure TFrmQuantity.FormCreate(Sender:TObject);
begin
    Parent := FrmM;
    Left := FrmExchange.Left + 10;
    Top := FrmExchange.Top + FrmExchange.Height - 100;

    if WinVerType = wvtnew then
    begin
        SetNewVersion;
    end
    else
    begin
        SetOldVersion;
    end;

    // FrmQuantity Set Font
    EdCount.Font.Name := mainFont;
    LbCountName.Font.Name := mainFont;
    ShowType := SH_Server;
end;

procedure TFrmQuantity.FormDestroy(Sender:TObject);
begin
    //
end;

procedure TFrmQuantity.Clear;
begin
    msg := 0;
    Countid := 0;
    sourkey := 0;
    destkey := 0;
    CountCur := 0;
    CountMax := 0;
    CountName := '';
    LbCountName.Caption := '';
    EdCount.Text := '';
end;

procedure TFrmQuantity.MessageProcess(var code:TWordComData);
var
    pckey           :PTCKey;
    psCount         :PTSCount;
begin
    pckey := @Code.data;
    case pckey^.rmsg of
        SM_SHOWCOUNT:
            begin
                psCount := @Code.data;
                msg := psCount^.rmsg;
                Countid := psCount^.rCountid;
                CountCur := psCount^.rCountCur;
                CountMax := psCount^.rCountMax;
                sourkey := psCount^.rsourkey;
                destkey := psCount^.rdestkey;
                CountName := GetWordString(psCount^.rCountName);
                MyVisible(TRUE, SH_Server, CountName, IntToStr(0));
            end;
    end;
end;

procedure TFrmQuantity.BtnOKClick(Sender:TObject);
var
    i               :longint;
    CSelectCount    :TCSelectCount;
    tt, ttgod       :pTSHaveItem;
    t2PTSNPCItem    :PTSNPCItem;
begin
    case ShowType of
        SH_Server:                                                              //丢 物品  在上
            begin
                i := _StrToInt(EdCount.Text);
                if (i > 0) and (i <= CountMax) then
                begin
                    CSelectCount.rmsg := CM_SELECTCOUNT;
                    CSelectCount.rboOk := TRUE;
                    CSelectCount.rsourkey := sourkey;
                    CSelectCount.rdestkey := destkey;
                    CSelectCount.rCountid := Countid;
                    CSelectCount.rCount := _StrToInt(EdCount.Text);
                    FrmLogOn.SocketAddData(sizeof(CSelectCount), @CSelectCount);
                    FrmExchange.ExchangeLock := FALSE;

                    Visible := FALSE;
                    SAY_EdChatFrmBottomSetFocus;
                end else
                begin
                    // error
                    CSelectCount.rmsg := CM_SELECTCOUNT;
                    CSelectCount.rboOk := FALSE;
                    CSelectCount.rsourkey := sourkey;
                    CSelectCount.rdestkey := destkey;
                    CSelectCount.rCountid := Countid;
                    CSelectCount.rCount := 0;
                    FrmLogOn.SocketAddData(sizeof(CSelectCount), @CSelectCount);
                    FrmExchange.ExchangeLock := FALSE;
                    Visible := FALSE;
                    FrmBottom.AddChat(('数量已满或没有'), 9, 29);
                    SAY_EdChatFrmBottomSetFocus;
                end;
            end;
        SH_NewAuction:
            begin
                i := _StrToInt(EdCount.Text);
                if (i > 0) and (i <= CountMax) then
                begin
                    frmAuctionBuy.FNEWItemKeyCount := i;
                    frmAuctionBuy.NEWitemDraw;

                    Visible := FALSE;
                    SAY_EdChatFrmBottomSetFocus;
                end;
            end;
        SH_NewEmail:
            begin
                i := _StrToInt(EdCount.Text);
                if (i > 0) and (i <= CountMax) then
                begin
                    FrmNEWEmail.FNewItemKeyCount := i;
                    FrmNEWEmail.DrawOutNewMail;

                    Visible := FALSE;
                    SAY_EdChatFrmBottomSetFocus;
                end;
            end;
        SH_ExChange:
            begin
                i := _StrToInt(EdCount.Text);
                if (i > 0) and (i <= CountMax) then
                begin
                    FrmExchange.senditemadd(sourkey, i);
                    Visible := FALSE;
                    SAY_EdChatFrmBottomSetFocus;
                end;
            end;
        SH_DepositoryIn:
            begin
                i := _StrToInt(EdCount.Text);
                if (i > 0) and (i <= CountMax) then
                begin
                    frmDepository.sendItemLogIn(sourkey, destkey, i);
                    Visible := FALSE;
                    SAY_EdChatFrmBottomSetFocus;
                end;
            end;
        SH_DepositoryOUt:
            begin
                i := _StrToInt(EdCount.Text);
                if (i > 0) and (i <= CountMax) then
                begin
                    frmDepository.sendItemLogOUt(destkey, sourkey, i);
                    Visible := FALSE;
                    SAY_EdChatFrmBottomSetFocus;
                end;
            end;
        SH_FAttrib:
            begin

            end;
        SH_NPCTrade:
            begin
                i := _StrToInt(EdCount.Text);
                if i > 0 then
                begin
                    Visible := FALSE;
                    SAY_EdChatFrmBottomSetFocus;
                    if frmNPCTrade.Visiblestate = 2 then
                    begin
                        frmNPCTrade.SendNPCbuf(LbCountName.Caption, i);
                    end;
                    if frmNPCTrade.Visiblestate = 3 then
                    begin
                        frmNPCTrade.SendNPCsell(frmNPCTrade.BuyItemKey, i);
                    end;

                end;
            end;
    end;
    SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmQuantity.BtnCancelClick(Sender:TObject);
var
    CSelectCount    :TCSelectCount;
begin
    case ShowType of
        SH_Server:
            begin
                CSelectCount.rmsg := CM_SELECTCOUNT;
                CSelectCount.rboOk := FALSE;
                CSelectCount.rsourkey := sourkey;
                CSelectCount.rdestkey := destkey;
                CSelectCount.rCountid := Countid;
                CSelectCount.rCount := 0;

                FrmLogOn.SocketAddData(sizeof(CSelectCount), @CSelectCount);

                FrmExchange.ExchangeLock := FALSE;
                Visible := FALSE;
                Clear;
            end;
        SH_DepositoryOUt:
            begin
                Visible := FALSE;
                SAY_EdChatFrmBottomSetFocus;
            end;
        SH_DepositoryIn:
            begin
                Visible := FALSE;
                SAY_EdChatFrmBottomSetFocus;
            end;
        SH_FAttrib:
            begin
            end;
        SH_NPCTrade:
            begin
                Visible := false;
            end;
        SH_ExChange:
            begin
                Visible := FALSE;
                SAY_EdChatFrmBottomSetFocus;
            end;
    end;
    SAY_EdChatFrmBottomSetFocus;
end;

procedure TFrmQuantity.FormShow(Sender:TObject);
begin
    case ShowType of
        SH_Server:
            begin
                FrmExchange.ExchangeLock := TRUE;
                LbCountName.Caption := CountName;
                EdCount.Text := IntToStr(CountCur);
            end;
        SH_DepositoryIn:
            begin
            end;
        SH_FAttrib:
            begin
            end;
    end;
    if WinVerType = wvtnew then
    begin
        Top := 600 - (117 + Height + 10) - 40;
        Left := 20;
        Width := 171;
        Height := 90;
    end
    else
    begin
        Top := 600 - (117 + Height + 10);
        Left := 20;
    end;

    if Visible then
    begin
        if FrmBottom.Visible then FocusControl(EdCount);
        EdCount.SelectAll;
    end;
end;

procedure TFrmQuantity.EdCountKeyDown(Sender:TObject; var Key:Word;
    Shift:TShiftState);

begin
    if key = 13 then BtnOKClick(Self);
    if key = VK_ESCAPE then BtnCancelClick(Self);
    if key = 38 then
    begin
        A2Button1Click(nil);
    end;
    if KEY = 40 then
    begin
        //下
        TA2Edit(Sender).Text := '0';
        if Visible then
        begin
            EdCount.SetFocus;
        end;
    end;
end;

procedure TFrmQuantity.SetFormText;
begin
    Font.Name := mainFont;

    LbCountName.Font.Name := mainFont;
    EdCount.Font.Name := mainFont;
end;

procedure TFrmQuantity.MYVisible(aVisible:Boolean; aType:TShowType; aItemName, aCount:string);
begin
    Visible := aVisible;
    ShowType := aType;
    LbCountName.Caption := aItemName;
    EdCount.Text := aCount;
end;

procedure TFrmQuantity.A2Button1Click(Sender:TObject);

begin
    //上
    EdCount.Text := inttostr(CountMax);
    if Visible then
    begin
        EdCount.SetFocus;

    end;
end;

end.

