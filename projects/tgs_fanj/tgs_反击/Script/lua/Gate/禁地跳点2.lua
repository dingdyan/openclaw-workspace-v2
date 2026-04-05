package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

function OnGate(uSource, uGateOb)
  --获取当前时间
  local aStr = M_MapFindMonster(96, '八卦武僧', 2);
  local bStr = M_MapFindMonster(96, '八卦妖僧', 2);
  if (aStr ~= 0) or (bStr ~= 0) then
    M_MapObjSay(96, string.format('【八卦岛】:剩余%d个八卦武僧和%d个八卦妖僧没死!', aStr, bStr), 1);
    P_MapMove(uSource, 96, 81, 91, 0);
   return 'true';	
  end;
 return 'false';
end