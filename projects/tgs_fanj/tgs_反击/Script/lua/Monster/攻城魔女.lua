local n = 0;
local buff_t = {};

--刷新触发
function OnRegen(uDest)
  buff_t[uDest] = nil;
end;

--攻击触发
function OnHit(uSource, uDest, declife)
end;


--BUFF开始触发
function OnBuffStart(uDest, BuffId, BuffName)
 return;
end

--BUFF到期触发
function OnBuffEnd(uDest, BuffId, BuffName)
  --血量恢复
  if BuffId == 1 then 
    --恢复10000 血
    B_ChangeLife(uDest, 10000)
	B_SAY(uDest, '舒畅...');		
  end;
 return;
end

--定时触发
function OnUpdate(uDest, CurTick)
  if buff_t[uDest] == nil then 
    buff_t[uDest] = 0;
  end;
  buff_t[uDest] = buff_t[uDest] + 1;
  if buff_t[uDest] % 60 == 0 then 
    --判断buff状态
	if P_GetAddMulBuff(uDest, 1) == -1 then 
      --判断血量百分比
	  if B_GetCurLife(uDest) // B_GetMaxLife(uDest) * 100 < 90 then
        --增加怪物血量BUFF
        local LifeData = {damageBody = 0, damageHead = 0, damageArm = 0, damageLeg = 0, armorBody = 0, armorHead = 0, armorArm=0, armorLeg= 0, AttackSpeed= 0,  avoid= 0, recovery= 0, accuracy= 0, KeepRecovery=0};
        P_SetAddMulBuff(uDest, 1, '血量恢复', 3, 73, 6, '3秒后血量进行恢复', LifeData);		
	    B_SAY(uDest, '哎哟,来个技能补补血...');	
	  end	
	end	
  end;
 return;
end