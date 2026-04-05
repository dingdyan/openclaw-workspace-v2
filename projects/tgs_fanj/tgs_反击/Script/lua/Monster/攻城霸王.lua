local buff_id = {};
local buff_t = {};

--攻击触发
function OnHit(uSource, uDest, declife)
end;

--刷新触发
function OnRegen(uDest)
  buff_id[uDest] = nil;
  buff_t[uDest] = nil;
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
  if buff_t[uDest] % 10 == 0 then 
    --获取血量最大
    local MaxLife = B_GetMaxLife(uDest);
    --获取当前血量
    local CurLife = B_GetCurLife(uDest);
	--获取血量当前百分比
	local per = math.floor(CurLife // MaxLife * 100);
	local pid = math.floor(per // 10);
	--百分低于90 并且 当前buff id不一样 处理
	if per <= 90 and buff_id[uDest] ~= pid then
      --记录BUFFID = buff_id
	  buff_id[uDest] = pid;
	  --写入buff
	  local LifeData = {
	    damageBody = 5 * (10 - buff_id[uDest]), 
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
		accuracy = 5 * (10 - buff_id[uDest]), 
		KeepRecovery =0
	  };
	  P_SetAddMulBuff(uDest, 1, '血之愤怒', 60 * 10, 1067, 11, '血量越低,攻击和命中越高', LifeData);
	  B_SAY(uDest, '品尝绝望的滋味..');	
	end;
  end;
 return;
end