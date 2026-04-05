package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '晋级2白捕教';


--三层升级
local _Magic = {
  ['狂风刀法'] = 1,
  ['罗汉刀法'] = 1,
};

--检测出现的角色触发
function OnCreate(uDest, uSource, aStr)
  --获取种族
  if B_GetRace(uSource) ~= 1 then
   return;
  end;
  if P_CheckPowerWearItem(uSource) > 0 then 
    B_SayDelayAdd(uDest, '为了公平起见,请脱掉将技能装备', 0);
    P_MapMove(uSource, 1, 305, 371, 100);
    return;
  end;
  if P_GetCurEnergyLevel(uSource) > 0 then 
    B_SayDelayAdd(uDest, '禁止开镜进入', 0);
    P_MapMove(uSource, 1, 305, 371, 100);
    return;
  end;
  --获取当前武功
  local CurMagic = P_GetCurUseMagic(uSource, 0);
  if CurMagic == nil or _Magic[CurMagic] == nil then 
    B_SayDelayAdd(uDest, '请开启需要升级的绝世武功', 0);
    P_MapMove(uSource, 1, 305, 371, 100);
    return;
  end
  local MagicLevel = P_GetMagicLevel(uSource, CurMagic);
  if MagicLevel ~= 9999 then 
    B_SayDelayAdd(uDest, string.format('%s要修炼到99.99', CurMagic), 0);
    P_MapMove(uSource, 1, 305, 371, 100);
    return;
  end
  --获取当前等级
  local GradeUp = P_GetUseMagicGradeUp(uSource, 1);
  if GradeUp ~= 0 then 
    B_SayDelayAdd(uDest, string.format('%s不是1级绝世武功', CurMagic), 0);
    P_MapMove(uSource, 1, 305, 371, 100);
    return;
  end
  B_CommandIce(uSource, 500);
  B_CommandIce(uDest, 500);
  B_ObjectBoNotHit(uDest, false);
  B_SayDelayAdd(uDest, '难道今天要来的人就是你?', 50); 
  B_SayDelayAdd(uDest, '好,你出招吧', 400); 
  return;
end;

function OnChangeState(uSource, uDest, uState)
  B_SayDelayAdd(uDest, '别想蒙混过关,我很严厉的.', 10); 
  B_SayDelayAdd(uDest, '很遗憾.等下次吧..', 300); 
  P_MapMove(uSource, 1, 305, 371, 600);
 return;
end

function OnDie(uSource, uDest, uRace)
  B_SAY(uDest, '腰酸背痛,考官还真不易啊'); 
  --获取当前武功
  local CurMagic = P_GetCurUseMagic(uSource, 0);
  if CurMagic == nil or _Magic[CurMagic] == nil then 
    B_SayDelayAdd(uDest, '请开启需要升级的绝世武功', 0);
    P_MapMove(uSource, 1, 305, 371, 100);
    return;
  end
  P_MapMove(uSource, 1, 305, 371, 500);
  P_SetUseMagicGradeUp(uSource, 1, 1);
  --检测是否第一次 给真气
  if P_GetTempArr(uSource, 16) == 0 then 
    P_SetTempArr(uSource, 16, 1);
    --给予真气
    P_SetAddableStatePoint(uSource, P_GetAddableStatePoint(uSource) + 100);
    P_LeftText(uSource, string.format('真气 获得 %d 个', 100), 55769, 3);
  end 
  --公告
  M_topmsg(string.format('%s 恭喜你,%s升到了2级', B_GetRealName(uSource), CurMagic), 65280);
  M_SetMapEnter(82, true);
 return;
end
