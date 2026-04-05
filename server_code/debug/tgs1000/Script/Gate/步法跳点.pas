procedure OnGate(uUserOb, uGateOb:integer); //传送 事件 uUserOb 玩家   uGateOb GATE对象
var
    MagicName       :string;
begin
    MagicName := getuserRunningMagic(uUserOb);
    if getMagicLevel(uUserOb, Magicname) < 9999 then
    begin
        Mapmove(uUserOb, 31, 96, 95, 0);
        saysystem(uUserOb, '继续修炼步法才能通过');
    end;
end;

