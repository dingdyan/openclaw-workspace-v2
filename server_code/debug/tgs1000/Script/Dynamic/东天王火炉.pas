{******************************************************************************
创建人:杨李
创建时间:2009.10.21
修改时间:
实现功能:
地图东海沼泽点火（拖动召唤符到火炉上）
   点火后 刷出怪物'东天王魂1'+3个‘远距离野神族3’
地图东海沼泽熄火
   熄火后 删除怪物'东天王魂1'+3个‘远距离野神族3’

******************************************************************************}

var
    LightIsOn       :boolean;      //火炉状态

procedure OnRegen(uSource:integer);
begin
   // LightIsOn := false;
end;

//点火时候触发

procedure OnTurnOn(uSource, uDest:integer);
begin
    if MapFindMonster('东海沼泽', '东天王魂1', 'all') > 0 then
    begin
        MapDelmonster('东海沼泽', '东天王魂1');
    end;
    if MapFindMonster('东海沼泽', '远距离野神族3', 'all') > 0 then
    begin
        MapDelmonster('东海沼泽', '远距离野神族3');
    end;
    MapAddmonster('东海沼泽', '东天王魂1', 458, 59, 1, 4, '', 0, 0,TRUE); //增加怪物

    MapAddmonster('东海沼泽', '远距离野神族3', 456, 59, 1, 0, '', 0, 0,TRUE); //增加怪物
    MapAddmonster('东海沼泽', '远距离野神族3', 458, 55, 1, 0, '', 0, 0,TRUE); //增加怪物
    MapAddmonster('东海沼泽', '远距离野神族3', 458, 62, 1, 0, '', 0, 0,TRUE); //增加怪物
    MapAddmonster('东海沼泽', '远距离野神族3', 463, 60, 1, 0, '', 0, 0,TRUE); //增加怪物
end;
//熄火时候触发

procedure OnTurnOff(uSource:integer);
begin
    if MapFindMonster('东海沼泽', '东天王魂1', 'all') > 0 then
    begin
        MapDelmonster('东海沼泽', '东天王魂1');
    end;
    if MapFindMonster('东海沼泽', '远距离野神族3', 'all') > 0 then
    begin
        MapDelmonster('东海沼泽', '远距离野神族3'); //删除怪物
    end;
end;

