package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

--修练场开放时间
local OpenTime = {
  [20] = 1,
  [21] = 1,
  [22] = 1,
  [23] = 1,
  [0] = 1,
  [1] = 1,
  [2] = 1,
  [3] = 1,
  [4] = 1,
  [5] = 1,
  [6] = 1,
  [7] = 1,
  [8] = 1,
  [9] = 1,
}

--修练场地图ID
local ToMAP = {96, 97, 98}

function OnGate(uSource, uGateOb)
  --获取当前时间
  local H = tonumber(os.date('%H'));
  if OpenTime[H] == nil then 
    P_saysystem(uSource, 'VIP修练场每天[21:00 - 10:00]开放!', 15);
    P_MapMove(uSource, 1, 500, 500, 0);
   return 'true';
  end;	

  --检测是否是VIP
  local viplevel, viptime = P_GetVipInfo(uSource);
  if strtostamp(viptime) < os.time() then 
    P_saysystem(uSource, '您还不是VIP或者VIP已过期!', 15);
    P_MapMove(uSource, 1, 500, 500, 0);
   return 'true';	
  end;	
  --随机传送到修练场
  P_MapMove(uSource, ToMAP[math.random(#ToMAP)], 30, 40, 0);
 return 'true';
end