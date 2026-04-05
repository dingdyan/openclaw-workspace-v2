unit uGATEConnector;
//被 GATE
interface

uses
    Windows, Classes, SysUtils, StrUtils, ScktComp, uBuffer, uPackets, uAnsTick, DefType;

type

    TgConnector = class
    private
        Socket:TCustomWinSocket;

        GateSender:TPacketSender;
        GateReceiver:TPacketReceiver;

    public

        Fdata:TGateInfo;
        constructor Create(aSocket:TCustomWinSocket);
        destructor Destroy; override;

        procedure Update(CurTick:Integer);

        function MessageProcess(aPacket:pTPacketData):Boolean;

        procedure AddReceiveData(aData:PChar; aCount:Integer);
        procedure AddSendData(aID:Integer; aMsg, aRetCode:Byte; aData:PChar; aSize:Integer);

        procedure SetWriteAllow(boFlag:Boolean);
        procedure sendExequatur(temp:pTExequaturdata);
    end;

    TgConnectorList = class
    private
        DataList:TList;

        function GetCount:Integer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure Update(CurTick:Integer);

        function CreateConnect(aSocket:TCustomWinSocket):Boolean;
        function DeleteConnect(aSocket:TCustomWinSocket):Boolean;

        procedure AddReceiveData(aSocket:TCustomWinSocket; aData:PChar; aCount:Integer);

        procedure SetWriteAllow(aSocket:TCustomWinSocket);

        property Count:Integer read GetCount;
        function getUserCountMin():TgConnector; //返回 连接数量 最少的
        function getmenu:string;

    end;

var
    GConnectorList  :TGConnectorList;

implementation

uses
    FMain, Math;

// TgConnector

constructor TgConnector.Create(aSocket:TCustomWinSocket);
begin
    Socket := aSocket;

    GateSender := TPacketSender.Create('Gate', 1048576, aSocket);
    GateReceiver := TPacketReceiver.Create('Gate', 1048576);
end;

destructor TgConnector.Destroy;
begin
    GateSender.Free;
    GateReceiver.Free;

    inherited Destroy;
end;

procedure TgConnector.sendExequatur(temp:pTExequaturdata);
begin
    AddSendData(0, BM_Exequatur, 0, pointer(temp), sizeof(TExequaturdata));
end;

procedure TgConnector.SetWriteAllow(boFlag:Boolean);
begin
    GateSender.WriteAllow := boFlag;
end;

procedure TgConnector.AddReceiveData(aData:PChar; aCount:Integer);
begin
    if aCount > 0 then
    begin
        GateReceiver.PutData(aData, aCount);
        frmMain.AddInfo(format('DataReceived (%d bytes %s)', [aCount, Socket.RemoteAddress]));
    end;
end;

procedure TgConnector.AddSendData(aID:Integer; aMsg, aRetCode:Byte; aData:PChar; aSize:Integer);
begin
    if aSize < SizeOf(TPacketData) then
    begin
        GateSender.PutPacket(aID, aMsg, aRetCode, aData, aSize);
        frmMain.AddInfo(format('DataSend (%d bytes %s)', [aSize, Socket.RemoteAddress]));
    end;
end;

procedure TgConnector.Update(CurTick:Integer);
var
    i               :Integer;
    aPacket         :TPacketData;
begin
    GateReceiver.Update;
    while GateReceiver.Count > 0 do
    begin
        if GateReceiver.GetPacket(@aPacket) = false then break;
        MessageProcess(@aPacket);
    end;
    GateSender.Update;
end;

function TgConnector.MessageProcess(aPacket:pTPacketData):Boolean;
var
    I, N            :INTEGER;
    str1, str2      :string;
    temp            :pTGateInfo;
begin
    case aPacket.RequestMsg of
        BM_GATEINFO:
            begin
                temp := @aPacket.data;
                Fdata := temp^;
                frmMain.AddInfo('BM_GATEINFO ' + datetimetostr(now));
            end;

    end;

end;

// TgConnectorList

constructor TgConnectorList.Create;
begin
    DataList := TList.Create;

end;

destructor TgConnectorList.Destroy;
begin

    Clear;
    DataList.Free;
    inherited Destroy;
end;

procedure TgConnectorList.Clear;
var
    i               :Integer;
    Connector       :TgConnector;
begin
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        Connector.Free;
    end;
    DataList.Clear;
end;

function TgConnectorList.GetCount:Integer;
begin
    Result := DataList.Count;
end;

function TgConnectorList.CreateConnect(aSocket:TCustomWinSocket):Boolean;
var
    Connector       :TgConnector;
begin
    Result := false;

    Connector := TgConnector.Create(aSocket);
    DataList.Add(Connector);

    Result := true;
end;

function TgConnectorList.DeleteConnect(aSocket:TCustomWinSocket):Boolean;
var
    i               :Integer;
    Connector       :TgConnector;
begin
    Result := false;
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        if Connector.Socket = aSocket then
        begin
            Connector.Free;
            DataList.Delete(i);
            Result := true;
            exit;
        end;
    end;
end;

procedure TgConnectorList.AddReceiveData(aSocket:TCustomWinSocket; aData:PChar; aCount:Integer);
var
    i               :Integer;
    Connector       :TgConnector;
begin
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        if Connector.Socket = aSocket then
        begin
            Connector.AddReceiveData(aData, aCount);
            exit;
        end;
    end;

    frmMain.AddInfo('TgConnectorList.AddReceiveData failed (' + aSocket.LocalAddress + ')');
end;

procedure TgConnectorList.Update(CurTick:Integer);
var
    i               :Integer;
    Connector       :TgConnector;
begin

    for i := DataList.Count - 1 downto 0 do
    begin
        Connector := DataList.Items[i];

        Connector.Update(CurTick);

    end;
end;

function TgConnectorList.getmenu:string;
var
    i               :Integer;
    Connector       :TgConnector;
begin
    result := '';
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];

        result := result + format('%d:IP%s(%d)连接数%d %s%s', [i,
            Connector.Fdata.RemoteIP
                , Connector.Fdata.RemotePort
                , Connector.Fdata.UserCount
                , IfThen(Connector.Fdata.boChecked, '', '[关闭]')
                , IfThen(Connector.Fdata.bofull, '[满员]', '')
                ])
            + #13#10;

    end;
end;

function TgConnectorList.getUserCountMin():TgConnector; //返回 连接数量 最少的
var
    i, mintemp      :Integer;
    Connector       :TgConnector;
begin
    result := nil;
    mintemp := 0;
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        if Connector.Fdata.boChecked then
            if (Connector.Fdata.UserCount < mintemp) or (result = nil) then
            begin
                result := Connector;
                mintemp := Connector.Fdata.UserCount;
            end;
    end;
end;

procedure TgConnectorList.SetWriteAllow(aSocket:TCustomWinSocket);
var
    i               :Integer;
    Connector       :TgConnector;
begin
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        if Connector.Socket = aSocket then
        begin
            Connector.SetWriteAllow(true);
            exit;
        end;
    end;
end;

end.

