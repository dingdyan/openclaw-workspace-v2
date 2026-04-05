local n = 0;

--刷新触发
function OnRegen(uSource)
  M_MapIceMonster(34, '地下石巨人', true);
  M_MapboNotHItMonster(34, '地下石巨人', true);
  --M_SboPickbyMapName(34, false);
  n = 0;
end;

--打开触发
function OnTurnOn(uSource, uDest)
  M_MapAddMonster(34, '石大王', 80, 40, 1, 10, '', 0, 0, true, 1);
 -- M_SboPickbyMapName(34, true); --允许开采
end;

--打击触发
function OnWindHit(uSource, uDest)
  if n >= 1 then 
    return;
  end;
  --获取当前血量
  local CurLife = B_GetCurLife(uDest);
  if CurLife <= 5000 then 
    M_MapIceMonster(34, '地下石巨人', false);
    M_MapboNotHItMonster(34, '地下石巨人', false);
    n = 1;
  end;
end;
