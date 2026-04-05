package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local n = 0;

--危险时触发
function OnDanger(uSource, uDest, SubName)
  if SubName == '火箭' then 
   return 'true';
  end
 return 'false';
end;

--点火时候触发
function OnTurnOn(uSource, uDest)
   n = n + 1;
   M_MapChangeDynamicobject(1, '石棺洞入口', 2);
  return;
end;

--熄火触发
function OnTurnoff(uDest)
   n = n - 1;
   M_MapChangeDynamicobject(1, '石棺洞入口', 1);
  return;
end;