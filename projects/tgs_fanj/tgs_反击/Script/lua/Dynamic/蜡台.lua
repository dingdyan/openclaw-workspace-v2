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
  --6个已点燃
  if M_MapFindDynamicobject(31, '蜡台', 3) == 6 then 
    --读取地图怪物数量
    local aStr = M_MapFindMonster(31, '石棺赦龙组', 2);
    local bStr = M_MapFindMonster(31, '石棺青龙刺客', 2);
    if (aStr == 0) and (bStr == 0) then
         M_MapChangeDynamicobject(31, '机关区域门', 2);
         B_ShowSound(uDest, 9171);
         M_MapObjSay(31, '机关区域门已开启', 2);
    end;		
  end

--[[   if n < 6 then 
      n = n + 1;
   end;	

   if n == 6 then 
      local aStr = M_MapFindMonster(31, '石棺赦龙组', 2);
      local bStr = M_MapFindMonster(31, '石棺青龙刺客', 2);
      if (aStr == 0) and (bStr == 0) then
         M_MapChangeDynamicobject(31, '机关区域门', 2);
         B_ShowSound(uDest, 9171);
         M_MapObjSay(31, '机关区域门已开启', 2);
      end;
     return;
   end;
  return--]];
end;

--熄火触发
function OnTurnoff(uSource)
--[[   if n > 0 then 
      n = n - 1;
   end;--]]
  return;
end;