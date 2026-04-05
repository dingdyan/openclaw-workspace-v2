package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

--变量记录
Var = {
  --数据保存路径
  File = "Tgsplus\\变量记录.sdb",
  --数据
  data = {},
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

--设定变量
Var.Set = function(Index, Data)
  Var.data[Index] = Data;	
  Var.Save();
end

--读取数据
Var.Load();

--每日活动公告
local _Notice = {
  --公告时间与内容
  Time = {
    [0] = {	
	},
    [1] = {	
	},
    [2] = {	
	},
    [3] = {	
	},
    [4] = {	
	},
    [5] = {	
	},
    [6] = {	
	},
	--100是不分星期
    [100] = {
	  --['19:55'] = '[盘古峡谷]5分钟后开放,请点击[活动专员]进入',
      --['19:57'] = '[盘古峡谷]3分钟后开放,请点击[活动专员]进入',
      --['19:59'] = '[盘古峡谷]1分钟后开放,请点击[活动专员]进入',	
	},
  },
  --重置公告状态时间
  Regen = '23:59',
  --记录公告状态
  State = {},
}

--刷怪
local TimeBoss = {
  --随机刷新坐标和范围
  ['xy'] = {
    {523, 476, 5},
    {495, 453, 5},
    {530, 411, 5},
    {547, 455, 5},
    {545, 494, 5},	
	{502, 496, 5},
    {521, 512, 5},
    {529, 497, 5},
    {553, 499, 5},
  },
  --刷怪物名称和数量
  ['List'] = {
    {'GM', 1}, 
  },
};

--定时BOSS
local _BOSS = {
  --周几开放 周日=0
  w = {
    [0] = 1,
    [1] = 1,
    [2] = 1,
	[3] = 1,
    [4] = 1,
    [5] = 1,
	[6] = 1,
  },
  --几点开放
  hm = {
    ['10:30'] = 1, 
	['11:30'] = 1, 
	['12:30'] = 1, 
	['13:30'] = 1, 
	['14:30'] = 1, 
	['15:30'] = 1, 
	['16:30'] = 1, 
	['17:30'] = 1, 
	['18:30'] = 1, 
	['19:30'] = 1,
	['20:30'] = 1, 
  },
  --随机刷新坐标和范围
  ['xy'] = {
    {567, 425, 5},
    {568, 515, 5},
    {472, 519, 5},
    {470, 421, 5},
    {586, 405, 5},
  },
  --刷新怪物
  data = {
   {'BOSS九尾狐', 1}, 
  },
};

--地图开放预告
local MapOpen = {
  [1] = {
    ['Id'] = 3,
    ['Name'] = '王陵',
    ['Time'] = 360000,
  },
  --[[[2] = {
    ['Id'] = 112,
    ['Name'] = '狐狸洞',
    ['Time'] = 180000,
  },
  [3] = {
    ['Id'] = 110,
    ['Name'] = '轩辕谷',
    ['Time'] = 180000,
  },
  [4] = {
    ['Id'] = 126,
    ['Name'] = '秦皇宫',
    ['Time'] = 360000,
  },
  [3] = {
    ['Id'] = 120,
    ['Name'] = '日月王城',
    ['Time'] = 1080000,
  },]]
};

--地图更新
function OnUpdate(uManager, ServerID, curTcik)
  --地图开放公告处理
  for n = 1, #MapOpen, 1 do  
    local t = MapOpen[n];
    if t ~= nil then 
      local i =  M_GetMapRemainTickById(t['Id']);
      if i ~= nil and i <= 30600 and i >= 30000 then 
        M_topmsg(string.format('[系统公告]%s开放还剩5分钟', t['Name']), 16777215);
      elseif i ~= nil and i <= 18600 and i > 18000 then 
        M_topmsg(string.format('[系统公告]%s开放还剩3分钟', t['Name']), 16777215);
      elseif i ~= nil and i <= t['Time'] and i > t['Time'] - 600 then 
        M_topmsg(string.format('[系统公告]%s已经开放_欢迎各位侠士进入', t['Name']), 16777215);
      end;
    end;
  end

  --获取小时:分钟
  local HM =  string.format('%s:%s', os.date('%H'), os.date('%M'));
  --获取星期
  local w = tonumber(os.date('%w'));
  --获取小时
  local H = tonumber(os.date('%H'));

  --每日活动公告开始
  --判断公告状态为nil执行公告
  if _Notice.Time[w] ~= nil and _Notice.Time[w][HM] ~= nil and _Notice.State[HM] == nil then 
    --公告
    M_worldnoticemsg(_Notice.Time[w][HM], 16777215 , 16384);
    --记录状态
    _Notice.State[HM] = 1;
  end;
  --判断公告状态为nil执行公告
  if _Notice.Time[100][HM] ~= nil and _Notice.State[HM] == nil then 
    --公告
    M_worldnoticemsg(_Notice.Time[100][HM], 16777215 , 16384);
    --记录状态
    _Notice.State[HM] = 1;
  end;
  --公告记录重置
  if HM == _Notice.Regen then 
    _Notice.State = {};
  end;
  --每日活动公告结束
  
  --定时刷新怪物
  if Var.data['JZGG'] == nil then 
	  Var.data['JZGG'] = 0;
	end;
	--判断分钟 和状态
  if (HM == '19:55') and Var.data['JZGG'] ~= 1 then
	M_topmsg('活动公告:[GM]将会在5分钟后出现', 57472);
	--记录状态
    Var.data['JZGG'] = 1;
    Var.Save();
	--判断分钟 和状态
    elseif (HM == '20:00') and Var.data['JZGG'] ~= 0 then
	--刷新怪物
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local _XY = TimeBoss['xy'][math.random(#(TimeBoss['xy']))];
    for i, v in pairs(TimeBoss['List']) do
      if type(v) == 'table' then
        M_MapAddMonster(1, v[1], _XY[1], _XY[2], v[2], _XY[3], '', 0, 0, true, 0);
      end;
    end;
	--公告
	M_topmsg(string.format('活动公告:[GM]出现在[%d:%d]附近', _XY[1], _XY[2]), 57472);
	--记录状态
    Var.data['JZGG'] = 0;
    Var.Save();
  end;
 end; 
   --[[定时BOSS刷新
  if Var.data['BOSS'] == nil then 
    Var.data['BOSS'] = 0;
  end;
  if _BOSS.w[w] ~=nil and _BOSS.hm[HM] ~= nil and Var.data['BOSS'] ~= _BOSS.hm[HM] then
    --刷新怪物
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local _XY = _BOSS['xy'][math.random(#(_BOSS['xy']))];
    for i, v in pairs(_BOSS.data) do
      if type(v) == 'table' then
        M_MapDelMonster(1, v[1]);
		M_MapAddMonster(1, v[1], _XY[1], _XY[2], v[2], _XY[3], '', 0, 0, true, 0);
      end;
    end;
	M_topmsg(string.format('活动公告:[BOSS九尾狐]出现在[%d:%d]附近', _XY[1], _XY[2]), 57472);
    Var.data['BOSS'] = _BOSS.hm[HM];
    Var.Save();
    elseif Var.data['BOSS'] ~= _BOSS.hm[HM] and Var.data['BOSS'] ~= 0 then
    for i, v in pairs(_BOSS.data) do
      if type(v) == 'table' then
        --M_MapDelMonster(1, v[1]);
      end;
    end;
    Var.data['BOSS'] = 0;
    Var.Save();
  end;]]

  --[[乾坤活动
  if Var.data['XKZC'] == nil then 
    Var.data['XKZC'] = 0;
  end;
  --判断分钟 和状态
  if HM == '20:00' and Var.data['XKZC'] ~= 1 then
    --刷新地图
    M_MapRegen(108);
    --提示
    M_topmsg('[乾坤活动]已经开放,请点击[活动专员]进入!!', 57472);
    --记录状态
    Var.data['XKZC'] = 1;
    Var.Save();
  elseif HM == '21:00' and Var.data['XKZC'] ~= 0 then	
	--刷新
	M_MapRegen(108);
    --提示
    M_topmsg('[乾坤活动]已经关闭,请等待下次开放!!', 57472);
    --记录状态
    Var.data['XKZC'] = 0;
    Var.Save();
  end

  --密境活动
  if Var.data['BYPY'] == nil then 
    Var.data['BYPY'] = 0;
  end;
  --判断分钟 和状态
  if HM == '21:00' and Var.data['BYPY'] ~= 1 then
    --刷新地图
    M_MapRegen(107);
    --提示
    M_topmsg('[密境活动]已经开放,请点击[活动专员]进入!!', 57472);
    --记录状态
    Var.data['BYPY'] = 1;
    Var.Save();
  elseif HM == '22:00' and Var.data['BYPY'] ~= 0 then	
	--刷新
	M_MapRegen(107);
    --提示
    M_topmsg('[密境活动]已经关闭,请等待下次开放!!', 57472);
    --记录状态
    Var.data['BYPY'] = 0;
    Var.Save();
  end
  --白银活动
  if Var.data['XYMJ'] == nil then 
    Var.data['XYMJ'] = 0;
  end;
  --判断分钟 和状态
  if HM == '22:00' and Var.data['XYMJ'] ~= 1 then
    --刷新地图
    M_MapRegen(106);
    --提示
    M_topmsg('【活动通告】【白银活动】已经开放,请点击[活动专员]进入!!', 57472);
    --记录状态
    Var.data['XYMJ'] = 1;
    Var.Save();
  elseif HM == '23:00' and Var.data['XYMJ'] ~= 0 then	
	--刷新
	M_MapRegen(106);
    --提示
    M_topmsg('【活动通告】【白银活动】已经关闭,请等待下次开放!!', 57472);
    --记录状态
    Var.data['XYMJ'] = 0;
    Var.Save();
  end]]
  
  --[[盘古峡谷
  if Var.data['RRWC'] == nil then 
    Var.data['RRWC'] = 0;
  end;
  --判断分钟 和状态
  if HM == '20:00' and Var.data['RRWC'] ~= 1 then
    --刷新地图
    M_MapRegen(128);
	M_MapRegen(129);
	M_MapRegen(130);
    --提示
    M_topmsg('[盘古峡谷]已经开放,请点击[活动专员]进入!!', 57472);
    --记录状态
    Var.data['RRWC'] = 1;
    Var.Save();
  elseif HM == '22:00' and Var.data['RRWC'] ~= 0 then	
	--刷新
	M_MapRegen(128);
	M_MapRegen(129);
	M_MapRegen(130);
    --提示
    M_topmsg('[盘古峡谷]已经关闭,请等待下次开放!!', 57472);
    --记录状态
    Var.data['RRWC'] = 0;
    Var.Save();
  end
 end;]]

  --[[门战控制
  if w == 7 then 
    if Var.data['MPZZ'] == nil then 
	  Var.data['MPZZ'] = 0
	end;
    --判断分钟 和状态
    if HM == '19:30' and Var.data['MPZZ'] ~= 1 then    
      M_topmsg('【系统公告】门派战争30分钟后开启', 57472);
      M_topmsg('【系统公告】门派战争30分钟后开启', 57472);
      M_topmsg('【系统公告】门派战争30分钟后开启', 57472);
      --记录状态
      Var.data['MPZZ'] = 1;
      Var.Save();
    elseif HM == '19:50' and Var.data['MPZZ'] ~= 2 then    
      M_topmsg('【系统公告】门派战争10分钟后开启', 57472);
      M_topmsg('【系统公告】门派战争10分钟后开启', 57472);
      M_topmsg('【系统公告】门派战争10分钟后开启', 57472);
      --记录状态
      Var.data['MPZZ'] = 2;
      Var.Save();
    elseif HM == '19:55' and Var.data['MPZZ'] ~= 3 then    
      M_topmsg('【系统公告】门派战争5分钟后开启', 57472);
      M_topmsg('【系统公告】门派战争5分钟后开启', 57472);
      M_topmsg('【系统公告】门派战争5分钟后开启', 57472);
      --记录状态
      Var.data['MPZZ'] = 3;
      Var.Save();
    elseif HM == '20:00' and Var.data['MPZZ'] ~= 4 then
      --开启门派战争
      M_topmsg('【系统公告】门派战争已开启', 57472);
      M_ScriptOpenGuildWar(true);
      --记录状态
      Var.data['MPZZ'] = 4;
      Var.Save();
    elseif HM == '22:00' and Var.data['MPZZ'] ~= 0 then
      --关闭门派战争
      M_ScriptOpenGuildWar(false);
      M_topmsg('【系统公告】门派战争已关闭', 57472);
      --记录状态
      Var.data['MPZZ'] = 0;
      Var.Save();
    end
  end
end;]]