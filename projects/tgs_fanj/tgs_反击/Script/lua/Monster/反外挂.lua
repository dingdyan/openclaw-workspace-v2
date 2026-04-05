local n = 0;
local m = {};
local t = {};

--刷新触发
function OnRegen(uSource)
  n = 0;
end;

--攻击触发
function OnHit(uSource, uDest, declife)
  --获取种族
  if B_GetRace(uSource) ~= 1 then
   return;
  end;
  n = n + 1;
  if n >= 50 then 
	local Max = B_GetMaxLife(uDest);
	B_ChangeLife(uDest, 0 - Max + 1);
    B_ReToturnDamage(uSource, uDest, 100, 100);
   return;
  end;
  --计算玩家攻击次数
  local RealName = B_GetRealName(uSource);
  --距离上次计算超过5分钟重新计算
  if t[RealName] ~= nil and t[RealName] < os.time() then 
    m[RealName] = 1;
    t[RealName] = os.time() + 300;
  end;
  --没打过计次1
  if m[RealName] == nil then 
    m[RealName] = 1;
    t[RealName] = os.time() + 300;
  else
    m[RealName] = m[RealName] + 1;
  end;
  if m[RealName] >= 10 then 
    m[RealName] = nil;
	t[RealName] = nil;
    P_BanPlay(uSource); 
   return;
  end;
end;
