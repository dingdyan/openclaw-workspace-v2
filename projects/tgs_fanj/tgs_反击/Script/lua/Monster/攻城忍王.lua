local n = 0;
local dec_data = {};
local buff_t = {};

--刷新触发
function OnRegen(uSource)
  dec_data = {};
  buff_t = {};
end;

--攻击触发
function OnHit(uSource, uDest, declife)
  --记录玩家伤害
  if dec_data[uDest] == nil then 
    dec_data[uDest] = {};
  end;
  if dec_data[uDest][uSource] == nil then 
    dec_data[uDest][uSource] = 0;
  end;
  dec_data[uDest][uSource] = dec_data[uDest][uSource] + declife;
  --判断伤害
  if dec_data[uDest][uSource] >= 7000 then 
     --判断buff状态
	 if P_GetAddMulBuff(uSource, 12) > -1 then 
	  return;
	 end;
	 --冻结
	 B_CommandIce(uSource, 800);
	 B_SAY(uDest, string.format('%s,定...', B_GetRealName(uSource)));	
     --冻结BUFF
     local LifeData = {
	    damageBody = 0, 
		damageHead = 0, 
		damageArm = 0, 
		damageLeg = 0, 
		armorBody = 0, 
		armorHead = 0, 
		armorArm = 0, 
		armorLeg = 0, 		
		AttackSpeed = 0,  
		avoid = 0, 
		recovery = 0, 
		accuracy = 0, 
		KeepRecovery =0
     };
     P_SetAddMulBuff(uSource, 12, '冻结', 8, 583, 7072, '冻结中.', LifeData);
	 --重置伤害
	 dec_data[uDest][uSource] = 0;
  end;
end;


--BUFF开始触发
function OnBuffStart(uDest, BuffId, BuffName)
 return;
end

--BUFF到期触发
function OnBuffEnd(uDest, BuffId, BuffName)
 return;
end

--定时触发
function OnUpdate(uDest, CurTick)
  if buff_t[uDest] == nil then 
    buff_t[uDest] = 0;
  end;
  buff_t[uDest] = buff_t[uDest] + 1;
  if buff_t[uDest] % 20 == 0 then 
    --判断buff状态
	if P_GetAddMulBuff(uDest, 1) == -1 then 
	  --增加怪物血量BUFF
	  local LifeData = {damageBody = 10, damageHead = 0, damageArm = 0, damageLeg = 0, armorBody = 10, armorHead = 0, armorArm=0, armorLeg= 0, AttackSpeed= -10,  avoid= 10, recovery= -10, accuracy= 10, KeepRecovery=0};
	  P_SetAddMulBuff(uDest, 1, '属性增幅', 15, 1357, 41, '提升各项属性10%', LifeData);		
	end	
  end;
end