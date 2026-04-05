package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

--跳点记录
_XY = {
  --数据保存路径
  File = "Tgsplus\\迷宫跳点.sdb",
  --数据
  data = {
    ['time'] = 0,
    ['gata'] = {},
  },
  --迷宫地图ID
  mapid = {
    [1] = {100, 40, 40},
    [2] = {101, 40, 40},
    [3] = {102, 40, 40},
    [4] = {103, 40, 40},
    [5] = {104, 40, 40},
    [6] = {105, 40, 40},
    [7] = {106, 40, 40},
  },
  --密室ID
  endid = {107, 50, 38},
}

--读取数据库
_XY.Load = function()
  if file_exists(_XY.File) then
    _XY.data = table.load(_XY.File)
  end
end

--保存数据库
_XY.Save = function()
  table.save(_XY.data, _XY.File)
end

--生成走法
_XY.Gata = function()
  --循环1-7层地图
  local Name;
  for i = 1, 7, 1 do
	--生成随机地图ID
    local t = deep_copy(_XY.mapid);
    for n = 1,#t do                                    --用for循环遍历这个表
	  a = math.random(#t + 1 - n);                 --取这个表的长度加1减i来随机
	  t[a], t[#t + 1 - n] = t[#t + 1 - n], t[a];	--然后再将取出的a的值与 #t+1-i的值交换位置
    end
    --循环6个门
	for n = 1, 6, 1 do
	  --设置跳点数据
	  Name = string.format('武魂密室%d-%d', i, n);
	  _XY.data['gata'][Name] = t[n];	
	end
  end
  --随机选5-7 3个地图 其中1个做为最终跳点
  math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
  math.random();math.random();math.random();
  Name = string.format('武魂密室%d-%d', math.random(5, 7), math.random(1, 6));
  _XY.data['gata'][Name] = _XY.endid;
  --更新时间
  _XY.data['time'] = os.time();
  --保存数据
  _XY.Save();
end

--读取数据
_XY.Load();


function OnGate(uSource, uGateOb)
  --生成走法
  if _XY.data['time'] + 1800 <= os.time() then 
    --P_saysystem(uSource, B_GetRealName(uGateOb), 2);
    --P_saysystem(uSource, '生成迷宫走法', 2);
	_XY.Gata();
  end;
  local GataName = B_GetRealName(uGateOb);
  local Go = _XY.data['gata'][GataName];
  if Go ~= nil then 
    P_MapMove(uSource, Go[1], Go[2], Go[3], 0);
  else  
    P_MapMove(uSource, 1, 499, 499, 0);
  end;
 return 'true';
end

--- Deep copies a table into a new table.
-- Tables used as keys are also deep copied, as are metatables
-- @param orig The table to copy
-- @return Returns a copy of the input table
function deep_copy(orig)
  local copy
  if type(orig) == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[deep_copy(orig_key)] = deep_copy(orig_value)
    end
    setmetatable(copy, deep_copy(getmetatable(orig)))
  else
    copy = orig
  end
  return copy
end