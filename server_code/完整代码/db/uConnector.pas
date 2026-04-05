{
1插入记录
2查找记录
3更新保存
无其他功能
}
unit uConnector;

interface

uses
    Windows, Classes, SysUtils, ScktComp, uBuffer, uPackets, DefType;

type
    TConnectType = (ct_gate, ct_gameserver);

    TConnector = class
    private
        Socket: TCustomWinSocket;
        boWriteAllow: Boolean;

        ConnectType: TConnectType;

        GateSender: TPacketSender;
        GateReceiver: TPacketReceiver;

        procedure WriteLog(aStr: string);
    protected

    public
        constructor Create(aSocket: TCustomWinSocket);
        destructor Destroy; override;

        procedure Update(CurTick: Integer);
        procedure MessageProcess(aPacket: PTPacketData);                        //所有事情 在这里处理
        procedure MessageProcessAuctionData(aPacket: PTPacketData);
        procedure MessageProcessLogin(aPacket: PTPacketData);
        procedure MessageProcessEmail(aPacket: PTPacketData);

        procedure AddReceiveData(aData: PChar; aCount: Integer);
        procedure AddSendData(aID: Integer; aMsg, aRetCode: Byte; aData: PChar; aSize: Integer);

        procedure SetWriteAllow(boFlag: Boolean);
        procedure send();
    end;

    TConnectorList = class
    private
        DataList: TList;

        function GetCount: Integer;
    protected
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        function CreateConnect(aSocket: TCustomWinSocket): Boolean;
        function DeleteConnect(aSocket: TCustomWinSocket): Boolean;

        procedure Update(CurTick: Integer);

        procedure AddReceiveData(aSocket: TCustomWinSocket; aData: PChar; aCount: Integer);

        procedure SetWriteAllow(aSocket: TCustomWinSocket);

        function AddPacketToGameServer(aID: Integer; aMsg, aRetCode: Byte; aData: PChar; aSize: Integer): Boolean;

        property Count: Integer read GetCount;
    end;

var
    ConnectorList: TConnectorList;

implementation

uses
    FMain,  uDBAdapter, uEmaildata;

// TConnector

constructor TConnector.Create(aSocket: TCustomWinSocket);
begin
    Socket := aSocket;
    boWriteAllow := false;

    ConnectType := ct_gate;

    GateSender := TPacketSender.Create('Gate', BufferSizeDataSend, aSocket);
    GateReceiver := TPacketReceiver.Create('Gate', BufferSizeDataReceive);
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
        frmMain.AddEvent(format('DataReceived (%d bytes %s)', [aCount, Socket.RemoteAddress]));
    end;
end;

procedure TConnector.AddSendData(aID: Integer; aMsg, aRetCode: Byte; aData: PChar; aSize: Integer);
begin
    if aSize < SizeOf(TPacketData) then
    begin
        GateSender.PutPacket(aID, aMsg, aRetCode, aData, aSize);
        frmMain.AddEvent(format('DataSend (%d bytes %s)', [aSize, Socket.RemoteAddress]));
    end;
end;

procedure TConnector.Update(CurTick: Integer);
var
    Packet: TPacketData;
begin
    GateReceiver.Update;
    while GateReceiver.Count > 0 do
    begin
        if GateReceiver.GetPacket(@Packet) = false then break;
        MessageProcess(@Packet);
    end;

    GateSender.Update;
end;

procedure TConnector.send();
begin
   // GateSender.Update;

end;

procedure TConnector.MessageProcessLogin(aPacket: PTPacketData);
var
    //  Packet          :TPacketData;
    RecordData: TLGRecord;
    KeyValue: string;
    nCode: Byte;
begin
    case aPacket^.RequestMsg of
        DB_LG_INSERT:
            begin
                Move(aPacket^.Data, RecordData.PrimaryKey, SizeOf(TLGRecord));
                KeyValue := RecordData.PrimaryKey;

                if (Pos(';', KeyValue) > 0) or (Pos('''', KeyValue) > 0) then
                begin
                    nCode := DB_ERR_INVALIDDATA;
                    frmMain.AddLog(format('LG_INSERT 失败 有特殊字符 %s', [KeyValue]));
                end else
                begin
                    //  nCode := SQLDBAdapter.LG_Insert(KeyValue, @RecordData);
                    nCode := LoginDBAdapter.Insert(KeyValue, @RecordData);
                    if nCode = DB_OK then
                    begin
                        frmMain.AddLog(format('LG_INSERT 成功 %s', [KeyValue]));
                    end else
                    begin
                        frmMain.AddLog(format('LG_INSERT 失败 %s', [KeyValue]));
                    end;
                end;
                //只发送 状态
                AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, 0);
            end;
        DB_LG_SELECT:
            begin
                Move(aPacket^.Data, RecordData.PrimaryKey, SizeOf(RecordData.PrimaryKey));
                KeyValue := RecordData.PrimaryKey;

                if (Pos(';', KeyValue) > 0) or (Pos('''', KeyValue) > 0) then
                begin
                    nCode := DB_ERR_INVALIDDATA;
                    frmMain.AddLog(format('LG_SELECT 失败 有特殊字符 %s', [KeyValue]));
                    AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, 0);
                end else
                begin
                    // nCode := SQLDBAdapter.LG_Select(KeyValue, @RecordData);
                    nCode := LoginDBAdapter.Select(KeyValue, @RecordData);
                    if nCode = DB_OK then
                    begin
                        frmMain.AddLog(format('LG_SELECT 成功 %s', [KeyValue]));
                        //成功 发送完整数据
                        AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, SizeOf(TLGRecord));
                    end else
                    begin
                        frmMain.AddLog(format('LG_SELECT 失败 %s', [KeyValue]));
                        AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, 0);
                    end;
                end;
            end;
        DB_LG_DELETE:
            begin

            end;
        DB_LG_UPDATE:
            begin
                Move(aPacket^.Data, RecordData.PrimaryKey, SizeOf(TLGRecord));
                KeyValue := RecordData.PrimaryKey;

                if (Pos(';', KeyValue) > 0) or (Pos('''', KeyValue) > 0) then
                begin
                    nCode := DB_ERR_INVALIDDATA;
                    frmMain.AddLog(format('LG_UPDATE 失败 有特殊字符 %s', [KeyValue]));
                    AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, 0);
                end else
                begin
                    nCode := LoginDBAdapter.Update(KeyValue, @RecordData);
                    if nCode = DB_OK then
                    begin
                        frmMain.AddLog(format('LG_UPDATE 成功 %s', [KeyValue]));
                        //更新 成功 也发完整数据
                        AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, SizeOf(TLGRecord));
                    end else
                    begin
                        frmMain.AddLog(format('LG_UPDATE 失败 %s', [KeyValue]));
                        AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, 0);
                    end;
                end;
            end;
    end;
end;

procedure TConnector.WriteLog(aStr: string);
var
    Stream: TFileStream;
    FileName: string;
begin
    try
        FileName := '.\Log\' + 'TConnector.Log';
        if FileExists(FileName) then
        begin
            Stream := TFileStream.Create(FileName, fmOpenReadWrite);
        end else
        begin
            Stream := TFileStream.Create(FileName, fmCreate);
        end;
        aStr := '[' + datetimetostr(now()) + ']' + aStr + #13 + #10;
        Stream.Seek(0, soFromEnd);
        Stream.WriteBuffer(aStr[1], length(aStr));
        Stream.Free;
    except
    end;
end;

procedure TConnector.MessageProcessAuctionData(aPacket: PTPacketData);
var
    id, i: integer;
    akey: integer;
    Code: TWordComData;
    aAuctionData: TAuctionData;
  //  s: string;
    tempstrList: tstringlist;
begin
    case aPacket^.RequestMsg of

        DB_Auction:
            begin

                id := 0;
                akey := WordComData_GETbyte(aPacket.Data, id);
                case akey of
                    Auction_INSERT:
                        begin

                        end;
                    Auction_SELECT:
                        begin

                        end;
                    Auction_DELETE:
                        begin
                            akey := WordComData_GETdword(aPacket.Data, id);
                            if AuctionDBAdapter.DELETE(inttostr(akey)) = DB_ERR then
                            begin
                                frmMain.AddLog(format('Auction_DELETE 失败 %d', [akey]));
                                WriteLog(format('Auction_DELETE 失败 %d', [akey]));
                                exit;
                            end;
                            frmMain.AddLog(format('Auction_DELETE 成功 %d', [akey]));
                            Code.Size := 0;
                            WordComData_ADDbyte(Code, Auction_DELETE);
                            WordComData_ADDdword(Code, akey);
                            AddSendData(aPacket.RequestID, DB_Auction, 0, @Code, Code.Size + 2);

                        end;
                    Auction_UPDATE:
                        begin

                            copymemory(@aAuctionData, @aPacket.Data.Data[id], sizeof(TAuctionData));
                            akey := aAuctionData.rid;
                            if AuctionDBAdapter.Insert(inttostr(aAuctionData.rid), @aAuctionData) = Db_ok then
                            begin
                                frmMain.AddLog(format('Auction_UPDATE Insert成功 i:%d n:%s', [aAuctionData.rid, aAuctionData.rBargainorName]));
                            end else
                            begin
                                if AuctionDBAdapter.Update(inttostr(aAuctionData.rid), @aAuctionData) <> Db_ok then
                                begin
                                    //写入 失败
                                    frmMain.AddLog(format('Auction_UPDATE 失败 i:%d n:%s', [aAuctionData.rid, aAuctionData.rBargainorName]));
                                    WriteLog(format('Auction_UPDATE 失败 i:%d n:%s', [aAuctionData.rid, aAuctionData.rBargainorName]));
                                    exit;
                                end;
                                frmMain.AddLog(format('Auction_UPDATE 成功 i:%d n:%s', [aAuctionData.rid, aAuctionData.rBargainorName]));
                            end;
                            Code.Size := 0;
                            WordComData_ADDbyte(Code, Auction_UPDATE);
                            WordComData_ADDdword(Code, akey);
                            AddSendData(aPacket.RequestID, DB_Auction, 0, @Code, Code.Size + 2);

                        end;

                    Auction_SELECTLoad:
                        begin
                            ////////////////////////////////////////////////////////////////////////////
                            //                         回复确认信息
                            Code.Size := 0;
                            WordComData_ADDbyte(Code, Auction_SELECTLoad);
                            AddSendData(aPacket.RequestID, DB_Auction, 0, @Code, Code.Size + 2);
                            send;
                            frmMain.AddLog(format('Auction_SELECTLoad 收到', []));
                            tempstrList := tstringlist.Create;
                            try
                                tempstrList.Text := AuctionDBAdapter.SelectAllName;
                                for i := 0 to tempstrList.Count - 1 do
                                begin
                                    if AuctionDBAdapter.Select(tempstrList.Strings[i], @aAuctionData) <> DB_OK then
                                    begin
                                        frmMain.AddLog(format('Auction_SELECTLoad 提取失败 %s', [tempstrList.Strings[i]]));
                                        WriteLog(format('Auction_SELECTLoad 提取失败 %s', [tempstrList.Strings[i]]));
                                        Continue;
                                    end;
                                    ////////////////////////////////////////////////////////////////////////////
                                    //                         完整资料发送
                                    Code.Size := 0;
                                    WordComData_ADDbyte(Code, Auction_SELECT);
                                    copymemory(@code.data[code.size], @aAuctionData, sizeof(TAuctionData));
                                    code.Size := code.Size + sizeof(TAuctionData);
                                    AddSendData(aPacket.RequestID, DB_Auction, 0, @Code, Code.Size + 2);
                                    send;
                                end;
                                frmMain.AddLog(format('Auction_SELECTLoad 提取资料 %d', [tempstrList.Count]));
                            finally
                                tempstrList.Free;
                            end;

                        end;
                end;

            end;

    end;

end;

procedure TConnector.MessageProcessEmail(aPacket: PTPacketData);
var
    id, i: integer;
    akey: integer;
    Code: TWordComData;
    pp: TEmaildataclass;
    tempEmaildata: TEmaildata;
    s: string;
    tempstrList: tstringlist;
begin
    case aPacket^.RequestMsg of

        DB_Email:
            begin
                id := 0;
                akey := WordComData_GETbyte(aPacket.Data, id);
                case akey of
                    Email_RegNameINSERT:
                        begin

                        end;
                    Email_INSERT:
                        begin

                        end;
                    Email_SELECT:
                        begin

                        end;
                    Email_DELETE:
                        begin
                            akey := WordComData_GETdword(aPacket.Data, id);
                            if EmailDBAdapter.Delete(inttostr(akey)) = db_err then
                            begin
                                WriteLog('Email_DELETE ' + inttostr(akey) + '失败');
                                frmMain.AddLog(format('Email_DELETE 失败 %d', [akey]));
                                //删除 失败
                                exit;
                            end;
                            frmMain.AddLog(format('Email_DELETE 成功 %d', [akey]));
                            Code.Size := 0;
                            WordComData_ADDbyte(Code, Email_DELETE);
                            WordComData_ADDdword(Code, akey);
                            AddSendData(aPacket.RequestID, DB_Email, 0, @Code, Code.Size + 2);

                        end;
                    Email_UPDATE:
                        begin
                            pp := TEmaildataclass.Create;
                            try
                                pp.LoadFormWordComData(aPacket.Data, id);
                                akey := pp.FID;
                                pp.SaveToTEmaildata(tempEmaildata);
                            finally
                                pp.Free;
                            end;
                            if EmailDBAdapter.Update(inttostr(akey), @tempEmaildata) = db_ok then
                            begin
                                frmMain.AddLog(format('Email_UPDATE 成功 i:%d n:%s t:%s', [tempEmaildata.FID, tempEmaildata.FDestName, tempEmaildata.FTitle]));
                            end else
                            begin
                                if EmailDBAdapter.Insert(inttostr(akey), @tempEmaildata) <> db_ok then
                                begin
                                    //写 失败
                                    frmMain.AddLog(format('Email_UPDATE Insert失败 i:%d n:%s t:%s', [tempEmaildata.FID, tempEmaildata.FDestName, tempEmaildata.FTitle]));
                                    WriteLog(format('Email_UPDATE Insert失败 i:%d n:%s t:%s', [tempEmaildata.FID, tempEmaildata.FDestName, tempEmaildata.FTitle]));
                                    exit;
                                end;
                                frmMain.AddLog(format('Email_UPDATE Insert成功 i:%d n:%s t:%s', [tempEmaildata.FID, tempEmaildata.FDestName, tempEmaildata.FTitle]));
                            end;


                            Code.Size := 0;
                            WordComData_ADDbyte(Code, Email_UPDATE);
                            WordComData_ADDdword(Code, akey);
                            AddSendData(aPacket.RequestID, DB_Email, 0, @Code, Code.Size + 2);

                        end;
                    Email_SELECTLoad:
                        begin
                            ////////////////////////////////////////////////////////////////////////////
                            //                         回复确认信息
                            Code.Size := 0;
                            WordComData_ADDbyte(Code, Email_SELECTLoad);
                            AddSendData(aPacket.RequestID, DB_Email, 0, @Code, Code.Size + 2);
                            send;
                            frmMain.AddLog(format('Email_SELECTLoad 收到 ', []));
                            tempstrList := tstringlist.Create;
                            try
                                ////////////////////////////////////////////////////////////////////////////
                                //                         获取所有人
                                tempstrList.Text := UserDBAdapter.UserSelectAllName;
                                for i := 0 to tempstrList.Count - 1 do
                                begin
                                    s := tempstrList.Strings[i];
                                    Code.Size := 0;
                                    WordComData_ADDbyte(Code, Email_RegNameSELECT);
                                    WordComData_ADDstring(Code, s);
                                    AddSendData(aPacket.RequestID, DB_Email, 0, @Code, Code.Size + 2);
                                    send;
                                end;
                                frmMain.AddLog(format('Email_SELECTLoad 提取用户名单 %d', [tempstrList.Count]));
                                ////////////////////////////////////////////////////////////////////////////
                                //                         获取所邮件
                                tempstrList.Text := EmailDBAdapter.SelectAllName;
                                pp := TEmaildataclass.Create;
                                try
                                    for i := 0 to tempstrList.Count - 1 do
                                    begin
                                        s := tempstrList.Strings[i];
                                        if EmailDBAdapter.Select(s, @tempEmaildata) <> db_ok then
                                        begin
                                            WriteLog('Email_SELECTLoad ' + s + '失败');
                                            frmMain.AddLog('Email_SELECTLoad ' + s + '失败');
                                            Continue;
                                        end;
                                        pp.LoadFormTEmaildata(tempEmaildata);

                                        Code.Size := 0;
                                        WordComData_ADDbyte(Code, Email_SELECT);
                                        pp.SaveToWordComData(Code);
                                        AddSendData(aPacket.RequestID, DB_Email, 0, @Code, Code.Size + 2);
                                        send;
                                    end;
                                    frmMain.AddLog(format('Email_SELECTLoad 提取邮件数量 %d', [tempstrList.Count]));
                                finally
                                    pp.Free;
                                end;

                            finally
                                tempstrList.Free;
                            end;
                        end;
                end;
            end;

    end;
end;

procedure TConnector.MessageProcess(aPacket: PTPacketData);
var
    RecordData: TDBRecord;
    KeyValue, mStr: string;
    nCode: Byte;
    id: integer;

begin

    case aPacket^.RequestMsg of
{$IFDEF boLogin}
        DB_LG_INSERT,
            DB_LG_SELECT,
            DB_LG_DELETE,
            DB_LG_UPDATE: MessageProcessLogin(aPacket);
{$ENDIF}
{$IFDEF bodb}
        DB_Email: MessageProcessEmail(aPacket);
        DB_Auction: MessageProcessAuctionData(aPacket);
        //--------------------------------------插入记录--------------------------------------------------------
        DB_INSERT:
            begin

                Move(aPacket^.Data, RecordData, SizeOf(TDBRecord));             //    Move(aPacket^.Data, RecordData.PrimaryKey, SizeOf(TDBRecord) - SizeOf(Byte));
                //  RecordData.suser := 1;
                KeyValue := RecordData.PrimaryKey;

                //   nCode := SQLDBAdapter.UserInsert(KeyValue, @RecordData);

                nCode := UserDBAdapter.UserInsert(KeyValue, @RecordData);
                // DBProvider.Insert(KeyValue, @RecordData);

                if nCode = DB_OK then
                begin                                                           //插入 成功
                    frmMain.AddLog(format('DB_INSERT 成功 %s', [KeyValue]));
                end else
                begin                                                           //失败
                    frmMain.AddLog(format('DB_INSERT 失败 %s', [KeyValue]));
                end;
                aPacket.Data.Size := 0;
                WordComData_ADDString(aPacket.Data, RecordData.PrimaryKey);
                //返回 名字以及成功状态
                AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @aPacket.Data, aPacket.Data.Size + 2);
            end;
        //--------------------------------------查找记录--------------------------------------------------------
        DB_SELECT:
            begin
                //                  只使用名字 部分 充当 接收

                id := 0;

                KeyValue := WordComData_GETString(aPacket.Data, id);

                //  nCode := SQLDBAdapter.UserSelect(KeyValue, @RecordData);
                nCode := UserDBAdapter.UserSelect(KeyValue, @RecordData);
                //DBProvider.Select(KeyValue, @RecordData);
                if nCode = DB_OK then
                begin                                                           //成功 //发送 完整 的人物DB
                    frmMain.AddLog(format('DB_SELECT 成功 %s', [KeyValue]));
                    AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, SizeOf(TDBRecord));
                end else
                begin                                                           //失败     只发送 状态
                    frmMain.AddLog(format('DB_SELECT 失败 %s', [KeyValue]));
                    AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @RecordData, 0);
                end;
            end;
        //-----------------------------------------更新保存记录-----------------------------------------------------
        DB_UPDATE:
            begin
                //  RecordData.stateuser := 1;
                  //取得 帐号

                Move(aPacket^.Data, RecordData, SizeOf(TDBRecord));
                // RecordData.suser := 1;
                KeyValue := RecordData.PrimaryKey;

                // nCode := SQLDBAdapter.UserUpdate(KeyValue, @RecordData);
                nCode := UserDBAdapter.UserUpdate(KeyValue, @RecordData);
                //DBProvider.Update(KeyValue, @RecordData);
                if nCode = DB_OK then
                begin                                                           //更新
                    frmMain.AddLog(format('DB_UPDATE 成功 %s', [KeyValue]));
                end else
                begin                                                           //失败
                    frmMain.AddLog(format('DB_UPDATE 失败 %s', [KeyValue]));
                end;
                aPacket.Data.Size := 0;
                WordComData_ADDString(aPacket.Data, RecordData.PrimaryKey);
                AddSendData(aPacket^.RequestID, aPacket^.RequestMsg, nCode, @aPacket.Data, aPacket.Data.Size + 2);
            end;
        //----------------------------------------------------------------------------------------------
            { DB_LOCK:
                 begin
                     KeyValue := StrPas(@aPacket^.Data);
                    // CurrentCharList.Insert(KeyValue, @RecordData);
                 end;
             DB_UNLOCK:
                 begin
                     KeyValue := StrPas(@aPacket^.Data);
     //                CurrentCharList.Delete(KeyValue);
                 end;
                 }
        DB_CONNECTTYPE:
            begin
                KeyValue := StrPas(@aPacket^.Data);
                if UpperCase(KeyValue) = 'GATE' then
                begin
                    ConnectType := ct_gate;
                end else if UpperCase(KeyValue) = 'GAMESERVER' then
                begin
                    ConnectType := ct_gameserver;
                end;
            end;
        {  DB_ITEMSELECT:
              begin
                  KeyValue := StrPas(@aPacket^.Data);
                 // RemoteConnectorList.AddRequestData(aPacket^.RequestMsg, aPacket^.RequestID, aPacket^.ResultCode, KeyValue);
              end; }
        DB_ITEMUPDATE:
            begin

            end;
{$ENDIF}
    else
        begin
            // SQLDBAdapter.MessageSQLProcess(aPacket, self);
             // frmMain.AddLog(format('%d Packet was received', [aPacket^.RequestMsg]));
        end;
    end;
end;

// TConnectorList

constructor TConnectorList.Create;
begin
    DataList := TList.Create;
end;

destructor TConnectorList.Destroy;
begin
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
    Result := true;

    try
        Connector := TConnector.Create(aSocket);
        DataList.Add(Connector);
    except
        frmMain.AddEvent('TConnectorList.CreateConnect failed (' + aSocket.RemoteAddress + ')');
        Result := false;
    end;
end;

function TConnectorList.DeleteConnect(aSocket: TCustomWinSocket): Boolean;
var
    i: Integer;
    Connector: TConnector;
begin
    Result := true;

    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        if Connector.Socket = aSocket then
        begin
            Connector.Free;
            DataList.Delete(i);
            exit;
        end;
    end;

    frmMain.AddEvent('TConnectorList.DeleteConnect failed (' + aSocket.RemoteAddress + ')');
    Result := false;
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

    frmMain.AddEvent('TConnectorList.AddReceiveData failed (' + aSocket.RemoteAddress + ')');
end;

procedure TConnectorList.Update(CurTick: Integer);
var
    i: Integer;
    Connector: TConnector;
begin
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        Connector.Update(CurTick);
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

function TConnectorList.AddPacketToGameServer(aID: Integer; aMsg, aRetCode: Byte; aData: PChar; aSize: Integer): Boolean;
var
    i: Integer;
    Connector: TConnector;
begin
    Result := false;
    for i := 0 to DataList.Count - 1 do
    begin
        Connector := DataList.Items[i];
        if Connector.ConnectType = ct_gameserver then
        begin
            Connector.AddSendData(aID, aMsg, aRetCode, aData, aSize);
            Result := true;
            exit;
        end;
    end;
end;

end.

