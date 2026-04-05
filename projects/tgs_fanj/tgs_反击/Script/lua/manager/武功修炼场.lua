package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');
--修练场开放时间
local OpenTime = {
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
  [10] = 1,
  [11] = 1,
  [12] = 1,
  [13] = 1,
}
--修练场关闭后传送坐标
local MoveXY = {
  [91] = {
	{557, 439},
	{495, 445},
	{486, 512},
	{564, 512},
	{524, 474},
  },
  [92] = {
	{557, 439},
	{495, 445},
	{486, 512},
	{564, 512},
	{524, 474},
  },
}

--地图更新
function OnUpdate(uManager, ServerID, curTcik)
  --获取当前时间
  local H = tonumber(os.date('%H'));
  if OpenTime[H] ~= nil then return end; 
  --获取地图玩家数量
  if M_MapUserCount(ServerID) > 0 then 
    M_MapObjSay(ServerID, '修炼场开放时间已到!', 15);
	local t = MoveXY[ServerID];
	local XY = nil ;
	if t ~= nil then 
	  XY = t[math.random(#t)];
	end;
	if XY == nil then XY = {499, 499} end;
    M_MapMoveByServerID(ServerID, 1, XY[1], XY[2]);
	--刷新地图
	M_MapRegen(ServerID);	
  end;
end;
