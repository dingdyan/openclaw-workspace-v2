package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local n = 0;

local ntable = {
  [200] = 0,
  [201] = 0,
  [202] = 0,
  [203] = 0,
  [204] = 0,
  [205] = 0,
  [206] = 0,
  [207] = 0,
  [208] = 0,
  [209] = 0,
};

local huotan = {
  [1] = '火坛1',
  [2] = '火坛2',
  [3] = '火坛3',
  [4] = '火坛4',
}

--危险时触发
function OnDanger(uSource, uDest, SubName)
  if SubName == '火箭' then 
   return 'true';
  end
 return 'false';
end;

--点火时候触发
function OnTurnOn(uSource, uDest)
  local i = 0;
  --取火坛地图坐标
  local MapId, AX, AY = B_GetPosition(uDest);
  --循环处理地图火坛
  for key, value in pairs(huotan) do
    --查找目标
    local uObject = M_MapFindName(MapId, value, 6);
	--找到目标判断目标状态
    if uObject > 0 then 
	  --判断目标是否点燃
	  if B_DynamicobjectGet(uObject) == 3 then 
		i = i + 1;
	  end;	
    end;	
  end;
  --判断火坛是否4个有点着的
  if i >= 4 then 
      local gzobj = M_MapFindName(MapId, '太极公子', 3); --查找太极公子
	  if gzobj >= 0 then 
		B_ObjectBoNotHit(gzobj, false); --设定太极公子可攻击
	  end
   end;

  return;
end;

--熄火触发
function OnTurnoff(uSource)
  --取火坛地图坐标
  local MapId, AX, AY = B_GetPosition(uSource);
  --循环处理地图火坛
  for key, value in pairs(huotan) do
    --查找目标
    local uObject = M_MapFindName(MapId, value, 6);
	--找到目标判断目标状态
    if uObject > 0 then 
	  --判断目标是否未点燃
	  if B_DynamicobjectGet(uObject) ~= 3 then 
	    --查找太极公子
	    local gzobj = M_MapFindName(MapId, '太极公子', 3);
	    if gzobj >= 0 then 
		  B_ObjectBoNotHit(gzobj, true); --设定太极公子不可攻击
	    end
		break;
	  end;	
    end;	
  end;
  return;
end;