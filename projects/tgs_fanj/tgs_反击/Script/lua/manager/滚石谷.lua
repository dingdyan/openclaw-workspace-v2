package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

--变量记录
Var = {
  --数据保存路径
  File = "Tgsplus\\滚石变量.sdb",
  --数据
  data = {
    ['GUN_0'] = 0,
    ['GUN_1'] = 0,
  },
}

--读取数据库
Var.Load = function()
  if file_exists(Var.File) then
    Var.data = table.load(Var.File)
  end
end

--保存数据库
Var.Save = function()
  table.save(Var.data, Var.File)
end

--读取数据
Var.Load();

--开放时间
local OpenTime = {
  [13] = 1,
  [20] = 1,
}

--关闭刷新时间
local ExitTime = {
  [12] = 1,
  [14] = 1,
  [19] = 1,
  [21] = 1,
}

local open = 0;

local notice = false;

--地图更新
function OnUpdate(uManager, ServerID, curTcik)
  --获取当前时间
  local H = tonumber(os.date('%H'));
  --滚石滚开放
  if OpenTime[H] ~= nil then
	if Var.data['GUN_0'] == 0 then
	  --刷新地图NPC
	  M_MapRegenNPC(ServerID, '滚石赛');
	  M_topmsg('【滚石竞赛】滚石谷已经开放_点击活动专员进入', 57472);
	  Var.data['GUN_0'] = 1;
	  Var.Save();
	end
  elseif Var.data['GUN_0'] == 1 then 
    Var.data['GUN_0'] = 0;
    Var.Save();
  end;
  --滚石滚关闭
  if ExitTime[H] ~= nil then
	if Var.data['GUN_1'] == 0 then
      M_MapObjSay(ServerID, '滚石谷开放时间已到!', 15);
      M_MapMoveByServerID(ServerID, 1, 499, 499, 0);
	  --刷新地图NPC
	  M_MapRegenNPC(ServerID, '滚石赛');
	  Var.data['GUN_1'] = 1;
	  Var.Save();
	end
  elseif Var.data['GUN_1'] == 1 then 
    Var.data['GUN_1'] = 0;
    Var.Save();
  end;
end;
