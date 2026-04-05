package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '比武太极公子';

--检测出现的角色触发
function OnCreate(uDest, uSource, aStr)
  --获取种族
  if B_GetRace(uSource) ~= 1 then
   return;
  end;
  if P_CheckPowerWearItem(uSource) > 0 then 
    B_SayDelayAdd(uDest, '请先脱掉带属性值的装备!', 0);
    P_MapMove(uSource, 1, 546, 475, 100);
    return;
  end;
  if P_CheckCurUseRMagic(uSource, 0) == true then 
    B_SayDelayAdd(uDest, '你选错武功了!', 0);
    P_MapMove(uSource, 1, 546, 475, 100);
    return;
  end;
  if P_CheckCurUseRMagic(uSource, 1) == true then 
    B_SayDelayAdd(uDest, '你选错武功了!', 0);
    P_MapMove(uSource, 1, 546, 475, 100);
    return;
  end;
  if P_CheckCurUseRMagic(uSource, 3) == true then 
    B_SayDelayAdd(uDest, '你选错武功了!', 0);
    P_MapMove(uSource, 1, 546, 475, 100);
    return;
  end;
  if P_CheckCurUseRMagic(uSource, 4) == true then 
    B_SayDelayAdd(uDest, '你选错武功了!', 0);
    P_MapMove(uSource, 1, 546, 475, 100);
    return;
  end;
  if P_CheckCurUseRMagic(uSource, 5) == true then 
    B_SayDelayAdd(uDest, '你选错武功了!', 0);
    P_MapMove(uSource, 1, 546, 475, 100);
    return;
  end;
  if P_CheckCurUseRMagic(uSource, 6) == true then 
    B_SayDelayAdd(uDest, '你选错武功了!', 0);
    P_MapMove(uSource, 1, 546, 475, 100);
    return;
  end;
  if P_GetCurEnergyLevel(uSource) > 0 then 
    B_SayDelayAdd(uDest, '禁止开镜进入!', 0);
    P_MapMove(uSource, 1, 546, 475, 100);
    return;
  end;
  B_CommandIce(uSource, 500);
  B_CommandIce(uDest, 500);
  P_REFILL(uSource);	
  B_ObjectBoNotHit(uDest, false);
  B_SayDelayAdd(uDest, '只想一决高下', 50); 
  return;
end;


function OnChangeState(uSource, uDest, uState)
  B_SayDelayAdd(uDest, '天外有天_人上有人_', 50); 
  B_SayDelayAdd(uDest, '切记', 400); 

  if P_getitemspace(uSource) < 1 then
    B_SayDelayAdd(uDest, '物品栏已满...', 100); 
  else
	P_additem(uSource, '罗刹卷轴', 15, '比武上古雨中客4');
  end;

  P_MapMove(uSource, 1, 546, 475, 600);
 return;
end

function OnDie(uSource, uDest, uRace)
  --获取种族
  if B_GetRace(uSource) ~= 1 then
   return;
  end;
  B_SAY(uDest, '阁下的招式_刚强有力'); 
  M_MapRegen(67);
  P_MapMove(uSource, 67, 20, 18, 500);

 return;
end
