unit FHistory;

interface

uses
    Windows, Messages, SysUtils, Classes, Graphics,
    Controls, Forms, Dialogs, StdCtrls, A2Form, A2Img, ExtCtrls, Clipbrd;
type
    TfrmHistory = class(TForm)
        A2Form:TA2Form;
        listHistory:TA2ListBox;
        procedure FormCreate(Sender:TObject);
        procedure listHistoryAdxDrawItem(ASurface:TA2Image; index:Integer;
            aStr:string; Rect:TRect; State:TDrawItemState; fx, fy:Integer);
        procedure listHistoryClick(Sender:TObject);
    private
        { Private declarations }
    public
        { Public declarations }

    end;

var
    frmHistory      :TfrmHistory;

implementation

uses FMain, FAttrib, FBottom, AUtil32, filepgkclass;

{$R *.DFM}

procedure TfrmHistory.FormCreate(Sender:TObject);
begin
    FrmM.AddA2Form(Self, A2form);
    Left := 0;
    Top := 0;
    pgkBmp.getBmp('History.bmp', A2form.FImageSurface);
    A2form.boImagesurface := true;
    {  lblTop.A2Image := getviewImage(13);
      lblBottom.A2Image := getviewImage(16);
      lblLeft.A2Image := getviewImage(14);
      lblRight.A2Image := getviewImage(15);
     }
      //   listContent.SetBackImage(getviewImage(10));
    listHistory.SetScrollTopImage(getviewImage(7), getviewImage(6));
    listHistory.SetScrollTrackImage(getviewImage(4), getviewImage(5));
    listHistory.SetScrollBottomImage(getviewImage(9), getviewImage(8));
    // listHistory.SetScrollBackImage(getviewImage(17));
     //listContent.FFontSelBACKColor := 31;
    listHistory.FLayout := tlCenter;
    listHistory.FItemIndexViewState := false;
    listHistory.FMouseViewState := true;
end;

procedure TfrmHistory.listHistoryAdxDrawItem(ASurface:TA2Image;
    index:Integer; aStr:string; Rect:TRect; State:TDrawItemState; fx,
    fy:Integer);
var
    col             :integer;
    fcol, bcol, r, g, b:word;
begin

    {  col := Integer(listHistory.StringList.Objects[Index]);

      fcol := LOWORD(Col);
      bcol := HIWORD(col);
      ASurface.Clear(bcol);
      ATextOut(ASurface, fx, fy, fcol, listHistory.Items[Index]);
      if (State = TIS_MouseSelect)
          or (state = TIS_Select_and_MouseSelect) then
          ATextOut(ASurface, fx + 1, fy, fcol, listHistory.Items[Index]);
    }
end;

procedure TfrmHistory.listHistoryClick(Sender:TObject);
var
    s, sname, s1, s2, s3:string;
begin
    FrmBottom.SetFocus;
    FrmBottom.EdChat.SetFocus;
    sname := '';
    s := listHistory.GetItem(listHistory.ItemIndex);
    if ReverseFormat(s, '[%s] :%s', s1, s2, s3, 2) then //世界
        sname := s1
    else if ReverseFormat(s, '<%s> :%s', s1, s2, s3, 2) then //门派
        sname := s1
    else if ReverseFormat(s, '%s :%s', s1, s2, s3, 2) then //当前
        sname := s1
    else if ReverseFormat(s, '%s" %s', s1, s2, s3, 2) then //纸条
        sname := s1
    else if ReverseFormat(s, '[队伍]%s:%s', s1, s2, s3, 2) then //队伍
        sname := s1;

    if sname <> '' then
    begin
        Clipboard.AsText := sname;
        FrmBottom.AddChat('该玩家名字已复制', WinRGB(255, 255, 0), 0);
        FrmBottom.Editchannel.Caption := '纸条';
        FrmBottom.EdChat.Text := '@纸条 ' + sname + ' ';
    end;

    FrmBottom.EdChat.SelStart := length(FrmBottom.EdChat.Text);
    // FrmBottom.EdChat.SelLength := 1;
end;

end.

