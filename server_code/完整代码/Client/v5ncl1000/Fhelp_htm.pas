unit Fhelp_htm;

interface

uses
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, ComCtrls, OleCtrls, SHDocVw;

type
    TfrmHelp = class(TForm)
        TreeView1: TTreeView;
        WebBrowser1: TWebBrowser;
        procedure FormCreate(Sender: TObject);
        procedure TreeView1Change(Sender: TObject; Node: TTreeNode);

    private
        { Private declarations }
    public
        { Public declarations }
        procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    end;
var
    frmHelp: TfrmHelp;
implementation

{$R *.dfm}
uses activex, MSHTML, FMain, filepgkclass, Math;

procedure LoadStream(WebBrowser: TWebBrowser; Stream: TStream);
var
    PersistStreamInit: IPersistStreamInit;
    StreamAdapter: IStream;
    MemoryStream: TMemoryStream;
begin
    WebBrowser.Navigate('about:blank');
    repeat
        Application.ProcessMessages;
        Sleep(0);
    until
        WebBrowser.ReadyState = READYSTATE_COMPLETE;
    if WebBrowser.Document.QueryInterface(IPersistStreamInit, PersistStreamInit) = S_OK then
    begin
        if PersistStreamInit.InitNew = S_OK then
        begin
            MemoryStream := TMemoryStream.Create;
            try
                MemoryStream.CopyFrom(Stream, 0);
                MemoryStream.Position := 0;
            except
                MemoryStream.Free;
                raise;
            end;
            StreamAdapter := TStreamAdapter.Create(MemoryStream, soOwned);
            PersistStreamInit.Load(StreamAdapter);
        end;
    end;

end;

procedure TfrmHelp.FormCreate(Sender: TObject);
var
    MemoryStream: TMemoryStream;
begin
    self.Align := alcustom;
    top := 0;
    Left := (800 - Width) div 2;
    Parent := FrmM;
    WebBrowser1.Navigate('about:blank');
    WebBrowser1.Navigate('http://www.onlinejw.com/help/help.htm');

  {  if FileExists('helpList.txt') then
    begin

        TreeView1.LoadFromFile('helpList.txt');
        exit;
    end;
    if pgksys.isfile('helpList.txt') then
    begin
        MemoryStream := TMemoryStream.Create;
        try
            pgksys.get('helpList.txt', MemoryStream);
            MemoryStream.Position := 0;
            TreeView1.LoadFromStream(MemoryStream);
        finally
            MemoryStream.Free;
        end;
    end;

    TreeView1.Selected := TreeView1.Items.GetFirstNode;
   }
end;

procedure TfrmHelp.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
const
    _KeyPressMask = $80000000;
begin

    //½ûÓÃÓÒ¼ü
    with Msg do
    begin
        if not IsChild(WebBrowser1.Handle, hWnd) then Exit;
        Handled := (message = WM_RBUTTONDOWN) or (message = WM_RBUTTONUP) or (message = WM_CONTEXTMENU);
    end;
    //½ûÖ¹Ctrl + N
    //½ûÖ¹Ctrl + F
    //½ûÖ¹Ctrl + A
    if Msg.message = WM_KEYDOWN then
    begin
        if ((Msg.lParam and _KeyPressMask) = 0) and
            (GetKeyState(VK_Control) < 0) and ((Msg.wParam = Ord('N'))
            or (Msg.wParam = Ord('F')) or (Msg.wParam = Ord('A'))) then
        begin
            Handled := True;
        end;
    end;

end;

procedure TfrmHelp.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
    str: string;
    tempNode: TTreeNode;
    MemoryStream: TMemoryStream;
begin
{
    tempNode := Node;
    str := tempNode.Text;
    while tempNode.Parent <> nil do
    begin
        tempNode := tempNode.Parent;
        str := tempNode.Text + '_' + str;
    end;
    Caption := str;
    if FileExists(str + '.html') then
    begin
        MemoryStream := TMemoryStream.Create;
        try
            MemoryStream.LoadFromFile(str + '.html');
            MemoryStream.Position := 0;
            LoadStream(WebBrowser1, MemoryStream);
        finally
            MemoryStream.Free;
        end;
        exit;
    end;
    if pgksys.isfile(str + '.html') then
    begin
        MemoryStream := TMemoryStream.Create;
        try
            pgksys.get(str + '.html', MemoryStream);
            MemoryStream.Position := 0;
            LoadStream(WebBrowser1, MemoryStream);
        finally
            MemoryStream.Free;
        end;
    end;
    }
end;


end.

