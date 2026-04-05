package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '比武西域魔人';

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
  B_SayDelayAdd(uDest, '绝没有胜算', 50); 
  B_SayDelayAdd(uDest, '挑战_不是卤莽_是什么', 400); 
  return;
end;


function OnChangeState(uSource, uDest, uState)
  B_SayDelayAdd(uDest, '哎_我这不是又摧残了一个幼苗吗?', 50); 
  B_SayDelayAdd(uDest, '哈哈~', 400); 

  if P_getitemspace(uSource) < 1 then
    B_SayDelayAdd(uDest, '物品栏已满...', 100); 
  else
	P_additem(uSource, '侠客卷轴', 1, '比武北霸王');
  end;

  P_MapMove(uSource, 1, 546, 475, 600);
 return;
end

function OnDie(uSource, uDest, uRace)
  --获取种族
  if B_GetRace(uSource) ~= 1 then
   return;
  end;

  if P_getitemspace(uSource) < 3 then
    B_SayDelayAdd(uDest, '物品栏已满...', 100); 
  else	
    P_additem(uSource, '侠客卷轴', 3, '比武西域魔人');
    P_additem(uSource, '仙人卷轴', 1, '比武西域魔人');
    if P_getsex(uSource) == 1 then 
      P_additem(uSource, '男子帝王头盔', 1, '比武西域魔人');
    else
      P_additem(uSource, '女子帝王头盔', 1, '比武西域魔人');
    end;
  end;
	
  B_SAY(uDest, '下次我绝不手软'); 
  M_MapRegen(67);
  P_MapMove(uSource, 1, 546, 475, 500);

 return;
end
