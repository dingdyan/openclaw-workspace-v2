package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '太极老人';

--记录灭火变量
local mie = {
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

--配置目标
local huotan = {
  [1] = '火坛1',
  [2] = '火坛2',
  [3] = '火坛3',
  [4] = '火坛4',
}

--检测出现的角色触发
function OnCreate(uSource, uDest, aStr)
  --获取种族
  if B_GetRace(uDest) ~= 1 then
   return;
  end;
  --取老人地图坐标
  local MapId, AX, AY = B_GetPosition(uSource);
  --7,限制玩家 NPC 太极公子15秒不能移动
  local gzobj = M_MapFindName(MapId, '太极公子', 3); --查找太极公子
  if gzobj >= 0 then 
    B_CommandIce(gzobj, 1500); --冻结太极公子
    B_ObjectBoNotHit(gzobj, true); --设定太极公子不可攻击
  end
  -- 冻结玩家
  B_CommandIce(uDest, 1500);
  -- 说话
  B_SayDelayAdd(uSource, '来这儿不易呀,果然是名副其实的侠客', 200);
  B_SayDelayAdd(uSource, '看样子是来向太极公子挑战的？', 200);
  B_SayDelayAdd(uSource, '那么_比武正式开始_ ', 200);
  B_SayDelayAdd(uSource, '开始', 200);
  return;
end;

function OnPatrol(uSource)
  if uSource == nil or uSource <= 0 then return end;
  --取老人地图坐标
  local MapId, AX, AY = B_GetPosition(uSource);
  if MapId == nil then return end;
   --检测灭火状态
  if mie[MapId] ~= nil and mie[MapId] > 0 then
    --查找目标
    local uObject = M_MapFindName(MapId, huotan[mie[MapId]], 6);
	--没找到目标清除
    if uObject <= 0 then 
		mie[MapId] = 0;	
      return;	
    end;	
	--判断目标是否点燃
	if B_DynamicobjectGet(uObject) ~= 3 then 
		--清除目标ID
		mie[MapId] = 0;
      return;
	end;
	--取目标坐标
	local BX, BY = B_GetNearXy(uObject);	
    --判断与目标坐标距离
	if M_GetLargeLength(AX, AY, BX, BY) <= 1 then 
		--灭火
		M_MapChangeDynamicobject(MapId, huotan[mie[MapId]], 1);
		--清除目标ID
		mie[MapId] = 0;
      return;
	end;
	--移动到目标坐标
	B_GotoXyStand(uSource, BX, BY);	
   return;
  else  --没有目标火炉
	local i, ID = 0, 0;
    --循环判断火炉状态和点火时间
	for key, value in pairs(huotan) do
		--查找火坛
		local uObject = M_MapFindName(MapId, value, 6);
		if uObject > 0 then 
		    --判断火坛已打开，并且开启时间<=i
		    if B_DynamicobjectGet(uObject) == 3 then 
			    local OpenedTick =  B_GetDynamicOpenedTick(uObject);
				if i == 0 or OpenedTick <= i then 
				    i = OpenedTick; -- 记录时间
					ID = key; -- 记录ID
			    end				
		    end				
		end;	
	end;
	--ID>0记录灭火目标
	if ID > 0 then 
		mie[MapId] = ID;
	end
  end;
 return;
end
