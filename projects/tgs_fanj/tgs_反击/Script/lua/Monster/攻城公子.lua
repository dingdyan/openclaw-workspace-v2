local n = 0;
local dec_num = {};

--刷新触发
function OnRegen(uSource)
  dec_num = {};
end;

--攻击触发
function OnHit(uSource, uDest, declife)
  --记录玩家次数
  if dec_num[uDest] == nil then 
    dec_num[uDest] = {};
  end;
  if dec_num[uDest][uSource] == nil then 
    dec_num[uDest][uSource] = 0;
  end;
  dec_num[uDest][uSource] = dec_num[uDest][uSource] + 1;
  --判断次数
  if dec_num[uDest][uSource] >= 10 then 
     --判断buff状态
	 if P_GetAddMulBuff(uSource, 11) > -1 then 
	  return;
	 end;
     --消弱攻击BUFF
     local LifeData = {
	    damageBody = -20, 
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
     P_SetAddMulBuff(uSource, 11, '攻击消弱', 15, 1027, 7002, '攻击力降低中', LifeData);
	 B_SAY(uDest, string.format('%s,求轻虐...', B_GetRealName(uSource)));	
	 --重置次数
	 dec_num[uDest][uSource] = 0;
	 P_SetHaveMagic(uDest, '分身术');
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
end