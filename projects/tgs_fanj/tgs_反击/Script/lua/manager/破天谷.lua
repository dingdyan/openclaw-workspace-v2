package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');
--开放时间
local OpenTime = {
  [19] = 1,
  [20] = 1,
  [21] = 1,
}
--修练场关闭后传送坐标
local MoveXY = {
  {557, 439},
  {495, 445},
  {486, 512},
  {564, 512},
  {524, 474},
}

local notice = false;

--地图更新
function OnUpdate(uManager, ServerID, curTcik)
  --获取当前时间
  local H = tonumber(os.date('%H'));
  --公告处理	
    if OpenTime[H] ~= nil and not notice then 
	  M_topmsg('【破天谷】已开启!!!欢迎各位大侠前往!!!', 65280);	
	  M_topmsg('【破天谷】已开启!!!欢迎各位大侠前往!!!', 65280);	
	  M_topmsg('【破天谷】已开启!!!欢迎各位大侠前往!!!', 65280);	
      notice = true;
    elseif OpenTime[H] == nil and notice then
	  M_topmsg('【破天谷】已关闭!!!欢迎各位大侠下次再来!!!', 65280);	
	  M_topmsg('【破天谷】已关闭!!!欢迎各位大侠下次再来!!!', 65280);
	  M_topmsg('【破天谷】已关闭!!!欢迎各位大侠下次再来!!!', 65280);
      notice = false;
	end;
  if OpenTime[H] ~= nil then return end; 
  --获取地图玩家数量
  if M_MapUserCount(ServerID) > 0 then 
    M_MapObjSay(ServerID, '破天谷开放时间已到!', 15);
	--local XY = MoveXY[ServerID];
	local t = MoveXY[ServerID];
	local XY = nil ;
	if t ~= nil then 
	  XY = t[math.random(#t)];
	end;
	if XY == nil then XY = {499, 499} end;
    M_MapMoveByServerID(ServerID, 1, XY[1], XY[2]);
	--刷新地图
	M_MapRegen(ServerID)
  end;
end;
