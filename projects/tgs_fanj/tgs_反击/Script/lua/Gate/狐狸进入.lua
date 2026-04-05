package.loaded['Script\\lua\\f'] = nil;
package.loaded['Script\\lua\\plug\\传送装备检测'] = nil;

require ('Script\\lua\\f');
require ('Script\\lua\\plug\\传送装备检测');

local Zb = {1, 3, '穿戴3件以上王陵系列装备才可进入', 128, 274};

function OnGate(uSource, uGateOb)
  --判断装备
  if CheckWear.Get(uSource, Zb[1], Zb[2]) ~= true then 
    P_saysystem(uSource, Zb[3], 15);
    P_MapMove(uSource, 1, Zb[4], Zb[5], 0);
    return 'true';
  end;  
 return 'false';
end