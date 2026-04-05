local ncount = 0;

--刷新触发
function OnRegen(uSource)
  ncount = 0;
end;

--关闭触发
function OnTurnoff(uSource)
  ncount = 0;
end;

--打击触发
function OnWindHit(uSource, uDest)
  ncount = ncount + 1;
  if ncount > 1 then 
    return;
  end;
  local MapId, AX, AY = B_GetPosition(uDest);
  --召唤怪物
  M_MapAddMonster(MapId, '远距离野神族2', 226, 148, 1, 2, '', 0, 0, true, 0);
  M_MapAddMonster(MapId, '远距离野神族2', 227, 155, 1, 2, '', 0, 0, true, 0);
  M_MapAddMonster(MapId, '远距离野神族2', 232, 154, 1, 2, '', 0, 0, true, 0);
  M_MapAddMonster(MapId, '远距离野神族2', 237, 149, 1, 2, '', 0, 0, true, 0);
end;

--打开触发
function OnTurnOn(uSource, uDest)
  local MapId, AX, AY = B_GetPosition(uDest);
  M_MapSendSound(MapId, 9329);
end;