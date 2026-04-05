package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '比武捕盗大将';

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
  B_SayDelayAdd(uDest, '你还太嫩!', 50); 
  B_SayDelayAdd(uDest, '留神啦_我可不会手下留情', 400); 
  return;
end;


function OnChangeState(uSource, uDest, uState)
  B_SayDelayAdd(uDest, '回去再修炼个10年吧', 50); 
  B_SayDelayAdd(uDest, '到那时我再用双手跟你打', 400); 
  P_MapMove(uSource, 1, 546, 475, 600);
  M_SetMapEnter(55, true);
 return;
end

function OnDie(uSource, uDest, uRace)
  --获取种族
  if B_GetRace(uSource) ~= 1 then
   return;
  end;
  B_SAY(uDest, '老天爷,_我怎么会输...'); 
  M_MapRegen(56);
  P_MapMove(uSource, 56, 20, 18, 500);

 return;
end
