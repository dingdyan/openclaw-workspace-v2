package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

function OnGate(uSource, uGateOb)
  --检测是否是VIP
  local viplevel, viptime = P_GetVipInfo(uSource);
  if strtostamp(viptime) < os.time() then 
    P_saysystem(uSource, '您还不是VIP或者VIP已过期!', 15);
    P_MapMove(uSource, 1, 165, 775, 0);
   return 'true';	
  end;	
  --传送到王陵一层
  P_MapMove(uSource, 31, 34, 34, 0);
 return 'true';
end