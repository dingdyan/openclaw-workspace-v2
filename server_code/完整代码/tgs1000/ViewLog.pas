unit ViewLog;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ComCtrls, StdCtrls, deftype;

type
    TfrmLog = class(TForm)
        Memo1: TMemo;
        PageControl1: TPageControl;
        TabSheet1: TTabSheet;
        TabSheet2: TTabSheet;
        TabSheet3: TTabSheet;
        Edit1: TEdit;
        Label1: TLabel;
        Button1: TButton;
        Edit2: TEdit;
        Button2: TButton;
        procedure Edit1Change(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure Button2Click(Sender: TObject);
    private
        { Private declarations }
    public
        { Public declarations }
    end;

var
    frmLog: TfrmLog;

implementation

{$R *.dfm}
uses uGConnect, uuser, UTelemanagement;

procedure TfrmLog.Edit1Change(Sender: TObject);
begin
    NetPackLogName := Edit1.Text;
end;

procedure TfrmLog.Button1Click(Sender: TObject);
begin
    tmlog.gettostringlist(Memo1.Lines);
end;

procedure TfrmLog.Button2Click(Sender: TObject);
begin
    UserList.SendNoticeMessage('<服务器公告>' + Edit2.Text, SAY_COLOR_NOTICE);
end;

end.

