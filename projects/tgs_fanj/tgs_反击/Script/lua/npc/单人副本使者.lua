package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '单人副本使者';

local _data = {
  [1] = '单人天赋怪',
  [2] = '单人活力怪',
  [3] = '单人龍魂怪',
  [4] = '单人战魂怪',
  [5] = '单人金元怪',
}
-- 选怪间隔时间
local _time = {};

local MainMenu =
[[
欢迎进入单人房间^
您可以自由选择房间内刷出的怪物种类^^
<「游标.bmp」『$00FFFF00| 刷 天赋怪』/@shua_1>^
<「游标.bmp」『$00FFFF00| 刷 活力怪』/@shua_2>^
<「游标.bmp」『$00FFFF00| 刷 龍魂怪』/@shua_3>^
<「游标.bmp」『$00FFFF00| 刷 战魂怪』/@shua_4>^
<「游标.bmp」『$00FFFF00| 刷 金元怪』/@shua_5>^^
<「游标.bmp」『$00FFFF00| 返回长城以南』/@cs>
]];

--检测出现的角色触发
function OnCreate(uSource, uDest, aStr)
  --获取种族
  if B_GetRace(uDest) ~= 1 then
   return;
  end;
  B_SayDelayAdd(uSource, '欢迎来到单人房间,请点击我选择房间内刷出的怪物', 0);
  return;
end;

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'cs' then
    P_MapMove(uSource, 1, 525, 474, 0);
    return;
  end;

  local Left, Right = lua_GetToken(aStr, '_');
  --选择分类
  if Left == 'shua' then
    local Index = tonumber(Right);
	if Index == nil then return end;
	if _data[Index] == nil then return end;
	
	--判断间隔时间
	if _time[uSource] == nil then 
      _time[uSource] = 0;
    end;	
	local tm = os.time();
	if _time[uSource] >= tm then 
       P_MenuSay(uSource, '抱歉,30秒内只能选1次');
      return;
    end;
	_time[uSource] = tm + 30;
	--获取地图ID
	local MapId, X, Y =  B_GetPosition(uSource);
	--循环删除地图内其他怪物
    for k = 1, #_data do
      M_MapDelMonster(MapId, _data[k]);
	end
	--添加地图怪物
	M_MapAddMonster(MapId, _data[Index], 40, 47, 10, 5, '', 0, 0, false, 0);
  end;

 return;
end