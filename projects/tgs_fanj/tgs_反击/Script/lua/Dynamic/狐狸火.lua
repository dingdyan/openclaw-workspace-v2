package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local LightCount = 0;

--刷新
function OnRegen(uSource)
	LightCount = 0;
end;

--点火时候触发
function OnTurnOn(uSource, uDest)
  LightCount = LightCount + 1;
  --M_MapObjSay(20, 'OnTurnOn  == '  .. LightCount, 15);
  if LightCount == 2 then 
     --查找地图中怪物是否存在
	if M_MapFindMonster(20, '死狼女实像', 0) <= 0 then
	  M_MapAddMonster(20, '死狼女实像', 24, 34, 1, 4, '', 0, 0, true, 0);
	end
  elseif LightCount == 4 then 
    --查找地图中动态物体是否存在
	--if M_MapFindDynamicobject(20, '妖华', 3) > 0 then
	--	M_MapDelDynamicobject(20, '妖华');
	--end
    --查找地图中动态物体是否存在
	if M_MapFindDynamicobject(20, '妖华', 0) <= 0 then
		M_MapAddDynamicobject(20, '妖华', '', '', '', '', '', '', '37', '50', 0, 0, 0, 0);
	end
  end
end;

--熄火触发
function OnTurnoff(uSource)
  LightCount = LightCount - 1;
  --M_MapObjSay(20, 'OnTurnoff  == '  .. LightCount, 15);
  if LightCount == 3 then 
     --查找地图中动态物体是否存在
	if M_MapFindDynamicobject(20, '妖华', 0) > 0 then
		M_MapDelDynamicobject(20, '妖华');
	end
  elseif LightCount == 1 then 
     --查找地图中怪物是否存在
	if M_MapFindMonster(20, '死狼女实像', 0) > 0 then
		M_MapDelMonster(20, '死狼女实像');
	end
  end
end;