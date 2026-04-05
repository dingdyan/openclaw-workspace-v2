unit uConnector;
//被 用户连接
interface

uses
  Windows, Classes, SysUtils, ScktComp, uBuffer, uNewPackets, uAnsTick, DefType, uExequatur, AUtil32, uKeyClass;

type
  TconnUserLogdata = record
    rid: integer;
    rloginid: string[32];
    rpassword: string[32];
    ripadd: string[20];
    rconnTime: tdatetime;
    rcount: integer;
    rcurcount: integer;
  end;
  pTconnUserLogdata = ^TconnUserLogdata;

  TconnUserLog = class
  private

    FCurTick: Integer;
    Fdata: tlist;
    findexLoginid: TStringKeyClass;

  public
    fdectime: integer;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure add(temp: pTconnUserLogdata);
    procedure del(aloginid: string);
    function get(aloginid: string): pTconnUserLogdata;
    procedure Update(CurTick: Integer);

    function getmenu(): string;
  end;

  TConnector = class
  private
    FCreateTime: integer;
    Socket: TCustomWinSocket;

    GateSender: TNEWPacketSender;
    GateReceiver: TNEWPacketReceiver;
    FboDEL: boolean;
    function AddSendPING(aid: integer): Boolean;
  public
    constructor Create(aSocket: TCustomWinSocket);
    destructor Destroy; override;

    procedure Update(CurTick: Integer);

    function MessageProcess(aComData: PTWordComData): Boolean; //处理 用户发来的包

    procedure AddReceiveData(aData: PChar; aCount: Integer);
    procedure AddSendData(aData: PChar; aCount: Integer);

    procedure SetWriteAllow(boFlag: Boolean);
    procedure SendStatusMessage(aKey: Byte; aStr: string);
    procedure sendExequatur(aip: string; aprot, ayid: integer);
    procedure sendvererror();
  end;

  TConnectorList = class
  private

    DataList: TList;

    function GetCount: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    procedure Update(CurTick: Integer);

    function CreateConnect(aSocket: TCustomWinSocket): Boolean;
    function DeleteConnect(aSocket: TCustomWinSocket): Boolean;

    procedure AddReceiveData(aSocket: TCustomWinSocket; aData: PChar; aCount: Integer);

    procedure SetWriteAllow(aSocket: TCustomWinSocket);

    property Count: Integer read GetCount;
  end;

var
  ConnectorList: TConnectorList;
  Exequatur: TExequatur;
  connUserLog: TconnUserLog;
  connIPLog: TconnUserLog;

implementation

uses
  FMain, uGATEConnector, DateUtils;

// TConnector

constructor TConnector.Create(aSocket: TCustomWinSocket);
begin
  FboDEL := false;
  FCreateTime := mmAnsTick;
  Socket := aSocket;

  GateSender := TNEWPacketSender.Create('BA', 1048576, aSocket);
  GateReceiver := TNEWPacketReceiver.Create('BA', 1048576);
end;

destructor TConnector.Destroy;
begin
  GateSender.Free;
  GateReceiver.Free;

  inherited Destroy;
end;

procedure TConnector.SetWriteAllow(boFlag: Boolean);
begin
  GateSender.WriteAllow := boFlag;
end;

procedure TConnector.AddReceiveData(aData: PChar; aCount: Integer);
begin
  if aCount > 0 then
  begin
    GateReceiver.PutData(aData, aCount);
    frmMain.AddInfo(format('DataReceived (%d bytes %s)', [aCount, Socket.RemoteAddress]));
  end;
end;

procedure TConnector.AddSendData(aData: PChar; aCount: Integer);
var
  ComData: TWordComData;
begin
  ComData.Size := aCount;
  Move(aData^, ComData.Data, aCount);
    // PacketSender.PutPacket(0, 0, 0, @ComData, ComData.Size + SizeOf(Word));
  GateSender.PutPacket(0, GM_BA, 0, @ComData, ComData.Size + SizeOf(Word))
end;

function TConnector.AddSendPING(aid: integer): Boolean;
begin
  result := false;
  if GateSender.PutPacket(aID, GM_PING, 0, nil, 0) then
  begin
    result := true;
    exit;
  end;

end;

procedure TConnector.Update(CurTick: Integer);
var
  i: Integer;
   // ComData: TWordComData;
  PacketData: TPacketData;
begin
  GateReceiver.Update;
  while GateReceiver.Count > 0 do
  begin
    if GateReceiver.GetPacket(@PacketData) = false then break;
    case PacketData.RequestMsg of
      GM_PING: AddSendPING(PacketData.RequestID);
    else MessageProcess(@PacketData.Data);
    end;


  end;
  GateSender.Update;
end;

procedure TConnector.sendvererror();
var
  cnt: Integer;
  sMessage: TCKey;
begin
  sMessage.rmsg := SM_CLOSE;
  sMessage.rkey := 2;
  cnt := Sizeof(TCKey);

  AddSendData(@sMessage, cnt);
end;

procedure TConnector.SendStatusMessage(aKey: Byte; aStr: string);
var
  cnt: Integer;
  sMessage: TSMessage;
begin
  sMessage.rmsg := SM_MESSAGE;
  sMessage.rkey := aKey;
  SetWordString(sMessage.rWordString, aStr);
  cnt := Sizeof(sMessage) - Sizeof(TWordString) + sizeofwordstring(sMessage.rWordString);

  AddSendData(@sMessage, cnt);
end;

procedure TConnector.sendExequatur(aip: string; aprot, ayid: integer);
var
  cnt: Integer;
  SConnectThru: TSConnectThru;
begin
  SConnectThru.rmsg := SM_CONNECTTHRU;
  SConnectThru.rIpAddr := aip;
  SConnectThru.rPort := aprot;
  SConnectThru.ryid := ayid;
  cnt := Sizeof(TSConnectThru);

  AddSendData(@SConnectThru, cnt);
end;



function TConnector.MessageProcess(aComData: PTWordComData): Boolean; //处理 用户发来的包
var
  I, N: INTEGER;
  str1, str2: string;
  pp: TExequaturdata;
  gateconn: TgConnector;
  pplog: pTconnUserLogdata;
  templog: TconnUserLogdata;
begin
  I := 0;
  N := WordComData_GETbyte(aComData^, I);
  case N of
    CM_Balance:
      begin
        str1 := WordComData_GETstring(aComData^, I);
        str2 := WordComData_GETstring(aComData^, I);
        n := WordComData_GETdword(aComData^, I);
        str1 := trim(str1);
        str2 := trim(str2);
        frmMain.AddInfo(format('%s,%s,(%d)', [str1, str2, n]));
        if (n <> verini) and (frmMain.CheckBox_ver.Checked) then
        begin
          SendStatusMessage(MESSAGE_LOGIN, '版本错误。');
          sendvererror;
          exit;
        end;

        if (str1 = '') or (str2 = '') then
        begin
          SendStatusMessage(MESSAGE_LOGIN, '资料不全。');
          exit;
        end;

                //
        pplog := connUserLog.get(str1);
        if pplog <> nil then
        begin
          pplog.rcount := pplog.rcount + 1;
          pplog.rcurcount := pplog.rcurcount + 1;
          if SecondsBetween(now(), pplog.rconnTime) < frmMain.SpinEdit_logintime.Value then
          begin
            SendStatusMessage(MESSAGE_LOGIN, '警告！登陆过频繁。');
            exit;
          end;
          pplog.rconnTime := now();
          if pplog.rcurcount > frmMain.SpinEdit_logincount.Value then
          begin
            SendStatusMessage(MESSAGE_LOGIN, '警告！登陆过次数。');
            exit;
          end;

        end;
        if pplog = nil then
        begin
          templog.rloginid := str1;
          templog.rpassword := str2;
          templog.ripadd := Socket.RemoteAddress;
          templog.rconnTime := now();
          templog.rcount := 1;

          connUserLog.add(@templog);
        end;
        pp := Exequatur.addnone(str1, str2);

                //完成 验证码生成
        gateconn := gConnectorList.getUserCountMin;
        if gateconn = nil then
        begin
          SendStatusMessage(MESSAGE_LOGIN, '申请连接失败！');
          exit;
        end;
        SendStatusMessage(MESSAGE_LOGIN, '申请验证码成功！');

        gateconn.sendExequatur(@pp); //发GATE
        sendExequatur(gateconn.Fdata.RemoteIP, gateconn.Fdata.RemotePort, pp.rid); //发用

      end;
  else
    begin
      FboDEL := true;
    end;

  end;

end;

// TConnectorList

constructor TConnectorList.Create;
begin
  DataList := TList.Create;
  Exequatur := TExequatur.Create;
  connUserLog := TconnUserLog.Create;
  connUserLog.fdectime := frmMain.SpinEdit_logindectime.Value;
  connIPLog := TconnUserLog.Create;
  connIPLog.fdectime := frmMain.SpinEdit_conndectime.Value;
end;

destructor TConnectorList.Destroy;
begin
  connIPLog.Free;
  connUserLog.Free;
  Exequatur.Free;
  Clear;
  DataList.Free;
  inherited Destroy;
end;

procedure TConnectorList.Clear;
var
  i: Integer;
  Connector: TConnector;
begin
  for i := 0 to DataList.Count - 1 do
  begin
    Connector := DataList.Items[i];
    Connector.Free;
  end;
  DataList.Clear;
end;

function TConnectorList.GetCount: Integer;
begin
  Result := DataList.Count;
end;

function TConnectorList.CreateConnect(aSocket: TCustomWinSocket): Boolean;
var
  Connector: TConnector;
begin
  Result := false;

  Connector := TConnector.Create(aSocket);
  DataList.Add(Connector);

  Result := true;
end;

function TConnectorList.DeleteConnect(aSocket: TCustomWinSocket): Boolean;
var
  i: Integer;
  Connector: TConnector;
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

procedure TConnectorList.AddReceiveData(aSocket: TCustomWinSocket; aData: PChar; aCount: Integer);
var
  i: Integer;
  Connector: TConnector;
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

  frmMain.AddInfo('TConnectorList.AddReceiveData failed (' + aSocket.LocalAddress + ')');
end;

procedure TConnectorList.Update(CurTick: Integer);
var
  i: Integer;
  Connector: TConnector;
begin
  connUserLog.Update(CurTick);
  connIPLog.Update(CurTick);
  for i := DataList.Count - 1 downto 0 do
  begin
    Connector := DataList.Items[i];
    if (Connector.FboDEL) then
    begin
      frmMain.AddInfo('主动断开 (' + Connector.Socket.LocalAddress + ')');
      Connector.Socket.Close;

    end
    else if (GetItemLineTimeSec(CurTick - Connector.FCreateTime) > 30) then
    begin

      frmMain.AddInfo('超过30秒强行断开 (' + Connector.Socket.LocalAddress + ')');
      Connector.Socket.Close;
            //  Connector.Free;
             // DataList.Delete(i);
    end else
    begin
      Connector.Update(CurTick);
    end;
  end;
end;

procedure TConnectorList.SetWriteAllow(aSocket: TCustomWinSocket);
var
  i: Integer;
  Connector: TConnector;
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
////////////////////////////////////////////////////////////////////////////////

function TconnUserLog.getmenu(): string;
var
  i: integer;
  pp: pTconnUserLogdata;
begin
  result := '';
  for i := 0 to Fdata.Count - 1 do
  begin
    pp := Fdata.Items[i];
    result := result + pp.rloginid + ',' + pp.ripadd + ',' + INTTOSTR(PP.rcount) + '->' + INTTOSTR(PP.rcurcount) + #13#10;
  end;

end;

procedure TconnUserLog.Update(CurTick: Integer);
var
  i: integer;
  pp: pTconnUserLogdata;
begin
  if abs(CurTick - FCurTick) < fdectime * 100 then exit;
  FCurTick := CurTick;
  for i := Fdata.Count - 1 downto 0 do
  begin
    pp := Fdata.Items[i];
    if pp.rcurcount > 0 then
      pp.rcurcount := pp.rcurcount - 1;

  end;

end;

function TconnUserLog.get(aloginid: string): pTconnUserLogdata;
begin
  result := findexLoginid.Select(aloginid);
end;

procedure TconnUserLog.add(temp: pTconnUserLogdata);
var
  pp: pTconnUserLogdata;
begin
  pp := get(temp.rloginid);
  if pp <> nil then exit;

  new(pp);
  pp^ := temp^;
  pp.rconnTime := now();
  pp.rcount := 1;
  pp.rcurcount := 1;
  fdata.Add(pp);
  findexLoginid.Insert(pp.rloginid, pp);
end;

procedure TconnUserLog.del(aloginid: string);
var
  i: integer;
  pp: pTconnUserLogdata;
begin
  for i := 0 to Fdata.Count - 1 do
  begin
    pp := Fdata.Items[i];
    if pp.rloginid = aloginid then
    begin
      findexLoginid.Delete(pp.rloginid);
      Dispose(pp);
      Fdata.Delete(i);
      exit;
    end;
  end;

end;

procedure TconnUserLog.Clear;
var
  i: integer;
  pp: pTconnUserLogdata;
begin
  for i := 0 to Fdata.Count - 1 do
  begin
    pp := Fdata.Items[i];
    Dispose(pp);
  end;
  findexLoginid.Clear;
  Fdata.Clear;

end;

constructor TconnUserLog.Create;
begin
  FCurTick := 0;
  Fdata := tlist.Create;
  findexLoginid := TStringKeyClass.Create;
end;

destructor TconnUserLog.Destroy;
begin
  Clear;
  Fdata.Free;
  findexLoginid.Free;
  inherited Destroy;
end;

end.

