local ncount = 0;

--刷新触发
function OnRegen(uSource)
  ncount = 0;
end;

function OnTurnoff(uSource)
  ncount = 0;
end;

--打击触发
function OnWindHit(uSource, uDest)
  ncount = ncount + 1;
  if ncount > 1 then 
    return;
  end;
  --召唤怪物
  M_MapAddMonster(43, '远距离野神族2', 81, 136, 1, 2, '', 0, 0, true, 0);
  M_MapAddMonster(43, '远距离野神族2', 83, 138, 1, 2, '', 0, 0, true, 0);
  M_MapAddMonster(43, '远距离野神族2', 85, 140, 1, 2, '', 0, 0, true, 0);
  M_MapAddMonster(43, '远距离野神族2', 87, 140, 1, 2, '', 0, 0, true, 0);
end;
