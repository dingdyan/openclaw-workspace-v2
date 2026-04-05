local n = 0;
local dec_data = {};

--刷新触发
function OnRegen(uDest)
  dec_data[uDest] = nil;
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
  if dec_data[uDest][uSource] >= 10000 then 
     --获取血量最大
     local MaxLife = B_GetMaxLife(uSource);
     P_ReturnDamage(uSource, math.floor(MaxLife * 0.5));	
	 B_ShowEffect(uSource, 12, 0);	
	 B_SAY(uDest, string.format('%s,来啊,互相伤害...', B_GetRealName(uSource)));	
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
end