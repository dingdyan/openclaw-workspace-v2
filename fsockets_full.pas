unit FSockets;
{
Notice 工作原理
>>>发送部分
//GNM_OUTUSER  用户 下线
//GNM_INUSER   用户 上线
//GNM_ALLCLEAR  清除所有 资料

<<<接收部分
NGM_REQUESTCLOSE:          //踢人下线
NGM_REQUESTALLUSER:        //获取 所有人 列表
}
interface

uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    uanstick, StdCtrls, ExtCtrls, autil32, deftype, WinSock,
    NMUDP, svClass, uBuffer, uPackets, ScktComp;

type
    TFrmSockets = class(TForm)
        TimerProcess: TTimer;
        NMUDPForSend: TNMUDP;
        sckNotice: TClientSocket;
        timerDisplay: TTimer;
        Memo1: TMemo;
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure TimerProcessTimer(Sender: TObject);
        procedure sckNoticeConnect(Sender: TObject; Socket: TCustomWinSocket);
        procedure sckNoticeDisconnect(Sender: TObject;
            Socket: TCustomWinSocket);
        procedure sckNoticeError(Sender: TObject; Socket: TCustomWinSocket;
            ErrorEvent: TErrorEvent; var ErrorCode: Integer);
        procedure sckNoticeRead(Sender: TObject; Socket: TCustomWinSocket);
        procedure sckNoticeWrite(Sender: TObject; Socket: TCustomWinSocket);
        procedure timerDisplayTimer(Sender: TObject);
    private
    public
        function UdpSendMouseInfo(astr: string): Boolean;
        function UdpItemMoveInfoAddData(atype, aSource, adest, aSourceIP, adestIP: string; amapID, ax, ay: integer; aitemname: string; aitemcount: integer): Boolean;
        function UdpMoniterAddData(astr: string): Boolean;
        function UdpConnectAddData(astr: string): Boolean;
        function UdpMonsterdieAddData(ahitname, aname, aitemlist: string; amapid, ax, ay: integer): Boolean;

        function AddDataToNotice(aData: PChar; aSize: Integer): Boolean;

        procedure ReConnectNoticeServer(aAddress: string; aPort: Integer);

        procedure udpsendLog(astr: string; amsg: integer);
    end;

var
    FrmSockets: TFrmSockets;

    NoticeSender: TPacketSender = nil;
    NoticeReceiver: TPacketReceiver = nil;

implementation

uses
    SVMain, uConnect;

{$R *.DFM}

/////////////////////////////////////////////////
//
/////////////////////////////////////////////////

procedure TfrmSockets.ReConnectNoticeServer(aAddress: string; aPort: Integer);
begin
    if sckNotice.Active = true then
    begin
        sckNotice.Socket.Close;
    end;

    sckNotice.Address := aAddress;
    sckNotice.Port := aPort;
end;

procedure TFrmSockets.FormCreate(Sender: TObject);
begin
    sckNotice.Address := NoticeServerIpAddress;
    sckNotice.Port := NoticeServerPort;
    sckNotice.Active := true;

    TimerProcess.Interval := 10;
    TimerProcess.Enabled := true;

    timerDisplay.Interval := 1000;
    timerDisplay.Enabled := true;
end;

procedure TFrmSockets.FormDestroy(Sender: TObject);
begin
    if NoticeSender <> nil then
    begin
        NoticeSender.Free;
        NoticeSender := nil;
    end;
    if NoticeReceiver <> nil then
    begin
        NoticeReceiver.Free;
        NoticeReceiver := nil;
    end;
end;

procedure TFrmSockets.TimerProcessTimer(Sender: TObject);
var
    PacketData: TPacketData;
begin
    if NoticeSender <> nil then NoticeSender.Update;
    if NoticeReceiver <> nil then
    begin
        NoticeReceiver.Update;
        while NoticeReceiver.Count > 0 do
        begin
            if NoticeReceiver.GetPacket(@PacketData) = false then break;
            ConnectorList.ProcessNoticeServerMessage(@PacketData);
        end;
    end;
end;
//记录 用户 鼠标资料  判断 是否 使用外挂

procedure TFrmSockets.udpsendLog(astr: string; amsg: integer);
var
    pComData: PTWordComData;
    Buffer: array[0..deftype_MAX_PACK_SIZE + 4] of char;
begin

    try
        pComData := @Buffer;
        pComData.Size := 0;
        WordComData_ADDdword(pComData^, amsg);
        WordComData_ADDstring(pComData^, astr);

        NMUdpForSend.RemoteHost := Udp_Receiver_IpAddress;
        NMUdpForSend.RemotePort := Udp_Receiver_Port;
        NMUdpForSend.SendBuffer(Buffer, pComData.Size + 2);
    except
        FrmMain.WriteLogInfo('FrmSockets.pas udpsendLog Except');
    end;

end;

function TFrmSockets.UdpSendMouseInfo(astr: string): Boolean;
begin
    udpsendLog(astr, udpReceiverc_MouseInfo);
end;

//记录 物品 流向

function TFrmSockets.UdpItemMoveInfoAddData(atype, aSource, adest, aSourceIP, adestIP: string; amapID, ax, ay: integer; aitemname: string; aitemcount: integer): Boolean;
var
    str: string;
begin
    //类型,提供者,获得者,物品名称,数量,地图ID,X,Y,提供者IP,获得者IP,时间,
    str := atype + ','
        + aSource + ','
        + adest + ','
        + aitemname + ','
        + inttostr(aitemcount) + ','
        + inttostr(amapID) + ','
        + inttostr(ax) + ','
        + inttostr(ay) + ','
        + aSourceIP + ','
        + adestIP + ','
        + datetimetostr(now()) + ','
        ;
    udpsendLog(str, udpReceiverc_ItemMoveInfo);
end;
//记录 在线人数

function TFrmSockets.UdpMoniterAddData(astr: string): Boolean;
begin
    udpsendLog(astr, udpReceiverc_Moniter);
end;
//记录 用户 连线 断线

function TFrmSockets.UdpConnectAddData(astr: string): Boolean;
begin
    udpsendLog(astr, udpReceiverc_Connect);
end;
//怪物 死亡记录

function TFrmSockets.UdpMonsterdieAddData(ahitname, aname, aitemlist: string; amapid, ax, ay: integer): Boolean;
var
    astr: string;
begin
    //攻击者,怪物名字,掉落物品,地图ID,X,Y,
    astr := ahitname + ',' + aname + ',' + aitemlist + ',' + inttostr(amapid) + ',' + inttostr(ax) + ',' + inttostr(ay) + ',';
    udpsendLog(astr, udpReceiverc_Monster_die);
end;
//GNM_OUTUSER  用户 下线
//GNM_INUSER   用户 上线
//GNM_ALLCLEAR  清除所有 资料

function TfrmSockets.AddDataToNotice(aData: PChar; aSize: Integer): Boolean;
begin
    Result := false;

    if NoticeSender <> nil then
    begin
        NoticeSender.PutPacket(0, PACKET_NOTICE, 0, aData, aSize);
        Result := true;
    end;
end;

procedure TFrmSockets.sckNoticeConnect(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    if NoticeSender <> nil then
    begin
        NoticeSender.Free;
        NoticeSender := nil;
    end;
    if NoticeReceiver <> nil then
    begin
        NoticeReceiver.Free;
        NoticeReceiver := nil;
    end;

    NoticeSender := TPacketSender.Create('NoticeSender', BufferSize_NOTICE_SEND, Socket);
    NoticeReceiver := TPacketReceiver.Create('NoticeReceiver', BufferSize_NOTICE_RECE);
end;

procedure TFrmSockets.sckNoticeDisconnect(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    if NoticeSender <> nil then
    begin
        NoticeSender.Free;
        NoticeSender := nil;
    end;
    if NoticeReceiver <> nil then
    begin
        NoticeReceiver.Free;
        NoticeReceiver := nil;
    end;
end;

procedure TFrmSockets.sckNoticeError(Sender: TObject;
    Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
    var ErrorCode: Integer);
begin
    ErrorCode := 0;
end;

procedure TFrmSockets.sckNoticeRead(Sender: TObject;
    Socket: TCustomWinSocket);
var
    nRead: Integer;
    buffer: array[0..deftype_MAX_PACK_SIZE - 1] of Char;
begin
    nRead := Socket.ReceiveBuf(buffer, deftype_MAX_PACK_SIZE);
    if nRead > 0 then
    begin
        if NoticeReceiver <> nil then
        begin
            NoticeReceiver.PutData(@buffer, nRead);
        end;
    end;
end;

procedure TFrmSockets.sckNoticeWrite(Sender: TObject;
    Socket: TCustomWinSocket);
begin
    if NoticeSender <> nil then
    begin
        NoticeSender.WriteAllow := true;
    end;
end;

procedure TFrmSockets.timerDisplayTimer(Sender: TObject);
begin
    if sckNotice.Active = false then
    begin
        sckNotice.Socket.Close;
        sckNotice.Active := true;
    end;
end;

end.


