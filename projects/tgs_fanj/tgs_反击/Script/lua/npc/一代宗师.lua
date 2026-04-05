package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

local _zy = {
  --数据保存路径
  File = "Tgsplus\\角色转移.sdb",
  --数据
  data = {},
  --数据
  temp = {},
};

--读取数据库
_zy.Load = function()
  if file_exists(_zy.File) then
    _zy.data = table.load(_zy.File)
  end
end

--保存数据库
_zy.Save = function()
  table.save(_zy.data, _zy.File)
end

_zy.Load();

local Npc_Name = '一代宗师';

--VIP 福利道具
local VipAward = {
  [1] = {
    {'新手生药', 500},
    {'新手汤药', 500},
  },
  [2] = {
    {'新手生药', 700},
    {'新手汤药', 700},
  },
  [3] = {
    {'新手生药', 1000},
    {'新手汤药', 1000},
  },
  [4] = {
    {'新手生药', 1200},
    {'新手汤药', 1200},
  },
};

--修炼场时间限制
local XLmax = {
  [0] = 60 * 60 * 4, 
  [1] = 60 * 60 * 8, 
  [2] = 60 * 60 * 10, 
  [3] = 60 * 60 * 40, 
  [4] = 60 * 60 * 18, 
};

--副本配置
local fuben = {
  --副本名
  names = '单人副本1层',
  --地图ID
  mapid = 100,
  --副本地图ID范围
  newid = {300, 314},
  --进入坐标
  XY = {14, 84},
  --进入时间变量
  times = 0,
  --进入次数
  vipfree = {
    [1] = {300, 0},
    [2] = {800, 0},
    [3] = {100, 5},
    [4] = {150, 5},
  },
};

--副本2配置
local fuben2 = {
  --副本名
  names = '单人副本2层',
  --地图ID
  mapid = 101,
  --副本地图ID范围
  newid = {400, 414},
  --进入NPC
  npc = {'单人副本使者', 85, 13},
};

--排队表格
local line = {
  --数据保存路径
  File = "Tgsplus\\单人排队.sdb",
  --数据
  data = {},
};

--读取数据库
line.Load = function()
  if file_exists(line.File) then
    line.data = table.load(line.File)
  end
end

--保存数据库
line.Save = function()
  table.save(line.data, line.File)
end

--查询是否在队列
line.Get = function(PlayName)
  for k,v in ipairs(line.data) do
    if v == PlayName then
      return true, k;
    end
  end
 return false, -1;
end

--删除队列
line.Del = function(PlayName)
  for k,v in ipairs(line.data) do
    if v == PlayName then
      table.remove(line.data, k)
      line.Save();
	  return;
    end
  end
end

--添加队列
line.Add = function(PlayName)
  table.insert(line.data, PlayName);
  line.Save();
end

--读取数据
line.Load();

function GetNewMap()
  if not BoNewMap then 
    --循环检测创建地图
    for i = fuben.newid[1], fuben.newid[2] do
      --检测地图玩家数
      local iCount = M_MapUserCount(i);
      if iCount == nil or iCount <= 0 then
        --创建刷新地图
        M_GetNewMap(fuben.mapid, i, fuben.names);
      end;			
    end	
    --循环检测创建地图2
    for i = fuben2.newid[1], fuben2.newid[2] do
      --检测地图玩家数
      local iCount = M_MapUserCount(i);
      if iCount == nil or iCount <= 0 then
        --创建刷新地图
        M_GetNewMap(fuben2.mapid, i, fuben2.names);
      end;			
    end	
  end;
  BoNewMap = true;
end

--单人排队处理
function OnDRUpdate(uDest, CurTick)
  --获取第一个排名玩家
  local PlayName = line.data[1];	
  if PlayName == nil then return end;
  local uObject, BoFind = B_FindObjectByName(uDest, PlayName, 1);
  if not BoFind then
    line.Del(PlayName);
    return
  end;
  --设定地图ID
  local MapID = 0;
  --循环检测地图玩家数量
  for i = fuben.newid[1], fuben.newid[2] do
    --检测地图上次退出时间
    local IsDupTime = M_MapGetboIsDupTime(i);
    if IsDupTime == nil or strtostamp(IsDupTime) + 60 <= os.time() then 
      --检测地图玩家数
      if M_MapUserCount(i) <= 0 and M_MapUserCount(i + 100) <= 0 then
        MapID = i;
       break;
      end;
    end;			
  end
  --判断是否有可用地图
  if MapID == 0 then 
   return;
  end;
  --刷新地图
  if not M_MapRegen(MapID) or not M_MapRegen(MapID + 100) then 
   return;
  end
  --获取VIP
  local viplevel, viptime = P_GetVipInfo(uObject);
  if viplevel < 1 then 
    line.Del(PlayName);
   return;
  end;
  --进入次数
  local freenum = 0;
  local _max = fuben.vipfree[viplevel][1];
  if _max == nil then 
   return;
  end;
  --获取领取时间戳
  local aNow = P_GetTempArr(uObject, 7);
  --判断日期相同,读取今日次数	
  if os.date("%Y-%m-%d", aNow) == os.date("%Y-%m-%d", os.time()) then 
    freenum = P_GetTempArr(uObject, 6);
  end;
  --判断进入次数
  if freenum >= _max then 
    P_saysystem(uObject, string.format('【单人副本】今日已进入%d次,无法在进入了', freenum), 15);
	line.Del(PlayName);
   return;
  end;
  --vip记录时间和进入次数
  P_SetTempArr(uObject, 7, os.time());	
  P_SetTempArr(uObject, 6, freenum + 1);	
  --添加NPC
  M_MapAddNPC(MapID, fuben2.npc[1], fuben2.npc[2], fuben2.npc[3], 1, 3, '', 1, 0, 0);	
  --6,移动玩家到副本
  P_MapMove(uObject, MapID, fuben.XY[1], fuben.XY[2], 0);
  --提示进入
  P_saysystem(uObject, string.format('[单人副本]今日可挑战单人副本%d/%d次', freenum + 1, _max), 20);
  --队列里删除
  line.Del(PlayName);
end

function OnUpdate(uDest, CurTick)
  OnDRUpdate(uDest, CurTick);
 return;
end

local MainMenu =
[[
欢迎~欢迎~~^^
<「游标.bmp」『$00FFFF00| 进入 武功修炼场一』/@vipwgjr>^
<「游标.bmp」『$00FFFF00| 领取 修炼场时间』/@vipwglq>^
<「游标.bmp」『$00FFFF00| 查询 修炼场时间』/@vipwgcx>^
<「游标.bmp」『$00FFFF00| 进入 单人副本』/@jrdrxz>^
<「游标.bmp」『$00FFFF00| 进入 角色转移』/@jszy>^


]];

local JRDRMenu =
[[
欢迎进入单人副本^^
<『$00FFFF00| 钱币进入』/@jrdr1>^
<『$00FFFF00| 交易币进入』/@jrdr2>
]];

local JSZYMenu =
[[绑定账号密保后可进行角色转移服务,每次转移收取500个交易币^
说明:角色转移可将当前角色转移至其他帐号下^^
<『$00FFFF00| 开始申请转移』/@ksjszy>^
<『$00FFFF00| 审核转移信息』/@shjszy>
]];

--修练场 随机进入地图
local xl_xy = {
  {99, 92},
  {99, 86},
};

--药王谷 随机进入地图
local mryg_xy = {
  {106, 98},
  {102, 104},
  {104, 108},
  {109, 111},
  {110, 104},
  {106, 97},
  {100, 93},
  {96, 97},
  {102, 112},
  {96, 108},
  {101, 115},
  {103, 106},
};

--血皇塔 随机进入地图
local jrxht_xy = {
  {41, 139},
  {44, 142},
  {48, 146},
  {55, 135},
  {58, 138},
  {29, 126},
  {37, 117},
  {38, 142},
  {58, 132},
  {60, 128},
  {40, 114},
  {42, 110},
  {25, 123},
  {30, 126},
  {47, 145},
  {51, 148},
};

--修罗帝宫 随机进入地图
local jrxlc_xy = {
  {19, 84},
  {21, 89},
  {27, 87},
  {29, 88},
  {32, 83},
  {25, 79},
  {28, 92},
  {30, 80},
  {26, 93},
  {30, 88},
  {23, 82},
  {38, 87},
  {36, 91},
  {31, 91},
  {39, 82},
  {36, 86},
  {42, 81},
  {43, 84},
  {44, 89},
  {41, 94},
  {39, 88},
  {35, 95},
};

--佛天秘境 随机进入地图
local ftmj_xy = {
  {71, 142},
  {68, 134},
  {61, 135},
  {60, 127},
  {52, 126},
  {52, 121},
};
--伏魔洞 随机进入地图
local fmd_xy = {
  {46, 159},
  {51, 154},
};
--上古战场 随机进入地图
local sgzc_xy = {
  {62, 244},
  {65, 234},
  {74, 229},
  {80, 214},
};


function OnMenu(uSource, uDest)
  if not BoNewMap then
    GetNewMap()
  end;
  P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'fanhui' then
    P_MenuSay(uSource, MainMenu);
   return;
  end;
  

  if aStr == 'hqln' then
    --获取VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if viplevel < 1 then 
     P_MenuSay(uSource, 'VIP才可领取');
     return;
    end;
    --获取玩家基本属性
    local Attrib = P_GetAttrib(uSource);
    --判断年龄是否到达
    if Attrib.Age > 4899 then 
      P_MenuSay(uSource, '年龄已不能领取!');
      return;
    end;
	P_SetAgeExp(uSource, 6876774);
    P_MenuSay(uSource, '已给予您年龄经验');
   return;
  end;
  
  --mryg 进入
  if aStr == 'mryg' then
    --判断地图剩余时间
    local i =  M_GetMapRemainTickById(113);
    if i >= 360000 - 500 then
      P_MenuSay(uSource, '地图正在刷新,请稍后.');
      return;
    elseif i <= 360000 - 60000 then 
      P_MenuSay(uSource, string.format('地图剩余[%s]可进入', timestostring(i // 100)));
      return;
    end;
    --判断道具
    if P_getitemcount(uSource, '钱币') < 5000 then 
      P_MenuSay(uSource, '进入需要钱币5000个');
     return;
    end
    --删除道具
    P_deleteitem(uSource, '钱币', 5000, '一代宗师');    
    --移动玩家到副本
    --P_MapMove(uSource, 113, 106, 104, 0);
	--传送玩家
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = mryg_xy[math.random(#mryg_xy)];
    P_MapMove(uSource, 113, t[1], t[2], 0);	
    return;
  end; 

  --修罗帝宫 进入
  if aStr == 'jrxlc' then
    --获取境界
	local nPower = P_GetEnergyLevel(uSource);
	if nPower < 1 then
      P_MenuSay(uSource, '一念通天可进入');
     return;
	end;
    --获取小时:分钟:秒
    local HMS = tonumber(os.date('%H%M%S'));
    if (HMS >= 150005 and HMS <= 155900) or (HMS >= 210005 and HMS <= 215900) then 
      --判断道具
      if P_getitemcount(uSource, '钱币') < 50000 then 
        P_MenuSay(uSource, '进入需要钱币50000个');
       return;
      end
      --删除道具
      P_deleteitem(uSource, '钱币', 50000, '一代宗师');  
	 -- P_MapMove(uSource, 126, 18, 83, 0);	
	  --传送玩家
	  math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	  math.random();
	  local t = jrxlc_xy[math.random(#jrxlc_xy)];
      P_MapMove(uSource, 126, t[1], t[2], 0);	
	else
      P_MenuSay(uSource, '开放时间: 每日[15点][21点]');
     return;
    end;
    return;
  end; 

  --新手村
  if aStr == 'xinshou' then
    --获取VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
	if viplevel < 3 then 
      --判断道具
      if P_getitemcount(uSource, '钱币') < 1 then 
        P_MenuSay(uSource, '进入需要钱币1个');
       return;
      end
      --删除道具
      P_deleteitem(uSource, '钱币', 1, '一代宗师');  
	end;  
    --移动玩家到副本
    P_MapMove(uSource, 0, 165, 227, 0);
    return;
  end;
    

  if aStr == 'jrdrxz' then
    P_MenuSay(uSource, JRDRMenu);
   return;
  end;
  
  --进入单人副本
  if aStr == 'jrdr1' then
    --获取玩家名称
    local PlayName = B_GetRealName(uSource);
	--检测是否在排队中
	local b, k = line.Get(PlayName);
    if b then 
	  P_MenuSay(uSource, string.format('你已在队列中,请稍后,前面排队人数:%d', k));
     return;
    end
    --获取VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if viplevel < 1 then 
     P_MenuSay(uSource, 'VIP才可进入');
     return;
    end;
    --进入次数
    local freenum = 0;
    local _max = fuben.vipfree[viplevel][1];
    if _max == nil then 
     return;
    end;
    --获取领取时间戳
    local aNow = P_GetTempArr(uSource, 7);
    --判断日期相同,读取今日次数	
    if os.date("%Y-%m-%d", aNow) == os.date("%Y-%m-%d", os.time()) then 
      freenum = P_GetTempArr(uSource, 6);
    end;
    --判断进入次数
    if freenum >= fuben.vipfree[viplevel][1] then 
      P_MenuSay(uSource, string.format('【单人副本】今日已进入%d次,无法在进入了', freenum));
     return;
    end;
    --检测玩家道具
    if freenum + 1 > fuben.vipfree[viplevel][2] then 
	  if P_getitemcount(uSource, '钱币') < 2000 then 
        P_MenuSay(uSource, '你没有2000个钱币');
       return;
	  end;
    end;
	--删除钱币
    if freenum + 1 > fuben.vipfree[viplevel][2] then 
	  P_deleteitem(uSource, '钱币', 2000, '武林至尊');
    end;
	--加入队列
	line.Add(PlayName);
	P_MenuSay(uSource, string.format('加入成功,请稍后,前面排队人数:%d', #line.data));
   return;	
  end;
    
  --进入单人副本
  if aStr == 'jrdr2' then
    --获取玩家名称
    local PlayName = B_GetRealName(uSource);
	--检测是否在排队中
	local b, k = line.Get(PlayName);
    if b then 
	  P_MenuSay(uSource, string.format('你已在队列中,请稍后,前面排队人数:%d', k));
     return;
    end
    --获取VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if viplevel < 1 then 
     P_MenuSay(uSource, 'VIP才可进入');
     return;
    end;
    --进入次数
    local freenum = 0;
    local _max = fuben.vipfree[viplevel][1];
    if _max == nil then 
     return;
    end;
    --获取领取时间戳
    local aNow = P_GetTempArr(uSource, 7);
    --判断日期相同,读取今日次数	
    if os.date("%Y-%m-%d", aNow) == os.date("%Y-%m-%d", os.time()) then 
      freenum = P_GetTempArr(uSource, 6);
    end;
    --判断进入次数
    if freenum >= fuben.vipfree[viplevel][1] then 
      P_MenuSay(uSource, string.format('【单人副本】今日已进入%d次,无法在进入了', freenum));
     return;
    end;
    --检测玩家道具
    if freenum + 1 > fuben.vipfree[viplevel][2] then 
	  if P_getitemcount(uSource, '交易币') < 50 then 
        P_MenuSay(uSource, '你没有50个交易币');
       return;
	  end;
    end;
	--删除钱币
    if freenum + 1 > fuben.vipfree[viplevel][2] then 
	  P_deleteitem(uSource, '交易币', 50, '武林至尊');
    end;
	--加入队列
	line.Add(PlayName);
	P_MenuSay(uSource, string.format('加入成功,请稍后,前面排队人数:%d', #line.data));
   return;	
  end;
  
  --黄龙峡谷
  if aStr == 'jrhlxg' then
    --获取境界
	local nPower = P_GetEnergyLevel(uSource);
	if nPower < 4 then
      P_MenuSay(uSource, '生死境可进入');
     return;
	end;
    --判断地图剩余时间
    local i =  M_GetMapRemainTickById(120);
    if i >= 720000 - 500 then
      P_MenuSay(uSource, '地图正在刷新,请稍后.');
      return;
    elseif i <= 720000 - 60000 then 
      P_MenuSay(uSource, string.format('地图剩余[%s]可进入', timestostring(i // 100)));
      return;
    end;
    --判断道具
    if P_getitemcount(uSource, '钱币') < 10000 then 
      P_MenuSay(uSource, '进入需要钱币10000个');
     return;
    end
    --删除道具
    P_deleteitem(uSource, '钱币', 10000, '一代宗师');    
    --移动玩家到副本
    P_MapMove(uSource, 120, 300, 300, 0);
    return;
  end;
  
  --血皇塔
  if aStr == 'jrxht' then
    --获取境界
	local nPower = P_GetEnergyLevel(uSource);
	if nPower < 4 then
      P_MenuSay(uSource, '生死境可进入');
     return;
	end;
    --判断地图剩余时间
    local i =  M_GetMapRemainTickById(121);
    if i >= 1080000 - 500 then
      P_MenuSay(uSource, '地图正在刷新,请稍后.');
      return;
    elseif i <= 1080000 - 120000 then 
      P_MenuSay(uSource, string.format('地图剩余[%s]可进入', timestostring(i // 100)));
      return;
    end;
    --判断道具
    if P_getitemcount(uSource, '钱币') < 50000 then 
      P_MenuSay(uSource, '进入需要钱币50000个');
     return;
    end
    --删除道具
    P_deleteitem(uSource, '钱币', 50000, '一代宗师');    
    --移动玩家到副本
    --P_MapMove(uSource, 121, 38, 59, 0);
	--传送玩家
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = jrxht_xy[math.random(#jrxht_xy)];
    P_MapMove(uSource, 121, t[1], t[2], 0);	
    return;
  end;

  --佛天秘境
  if aStr == 'ftmj' then
    --获取境界
	local nPower = P_GetEnergyLevel(uSource);
	if nPower < 11 then
      P_MenuSay(uSource, '一念通天可进入');
     return;
	end;
    --判断地图剩余时间
    local i =  M_GetMapRemainTickById(170);
    if i >= 1440000 - 500 then
      P_MenuSay(uSource, '地图正在刷新,请稍后.');
      return;
    elseif i <= 1440000 - 180000 then 
      P_MenuSay(uSource, string.format('地图剩余[%s]可进入', timestostring(i // 100)));
      return;
    end;
    --判断道具
    if P_getitemcount(uSource, '钱币') < 50000 then 
      P_MenuSay(uSource, '进入需要钱币50000个');
     return;
    end
    --删除道具
    P_deleteitem(uSource, '钱币', 50000, '一代宗师');    
    --移动玩家到副本
    --P_MapMove(uSource, 170, 66, 135, 0);
	--传送玩家
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = ftmj_xy[math.random(#ftmj_xy)];
    P_MapMove(uSource, 170, t[1], t[2], 0);	
    return;
  end;

  --伏魔洞
  if aStr == 'fmd' then
    --获取境界
	local nPower = P_GetEnergyLevel(uSource);
	if nPower < 1 then
      P_MenuSay(uSource, '生死境可进入');
     return;
	end;
    --判断地图剩余时间
    local i =  M_GetMapRemainTickById(166);
    if i >= 360000 - 500 then
      P_MenuSay(uSource, '地图正在刷新,请稍后.');
      return;
    elseif i <= 360000 - 120000 then 
      P_MenuSay(uSource, string.format('地图剩余[%s]可进入', timestostring(i // 100)));
      return;
    end;
    --判断道具
    if P_getitemcount(uSource, '钱币') < 50000 then 
      P_MenuSay(uSource, '进入需要钱币50000个');
     return;
    end
    --删除道具
    P_deleteitem(uSource, '钱币', 50000, '一代宗师');    
    --移动玩家到副本
    --P_MapMove(uSource, 166, 46, 159, 0);
	--传送玩家
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = fmd_xy[math.random(#fmd_xy)];
    P_MapMove(uSource, 166, t[1], t[2], 0);	
    return;
  end;

  --sgzc 进入
  if aStr == 'sgzc' then
    --判断地图剩余时间
    local i =  M_GetMapRemainTickById(185);
    if i >= 360000 - 500 then
      P_MenuSay(uSource, '地图正在刷新,请稍后.');
      return;
    elseif i <= 360000 - 60000 then 
      P_MenuSay(uSource, string.format('地图剩余[%s]可进入', timestostring(i // 100)));
      return;
    end;
    --判断道具
    if P_getitemcount(uSource, '钱币') < 5000 then 
      P_MenuSay(uSource, '进入需要钱币5000个');
     return;
    end
    --删除道具
    P_deleteitem(uSource, '钱币', 5000, '一代宗师');    
    --移动玩家到副本
    --P_MapMove(uSource, 185 62, 245, 0);
	--传送玩家
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = sgzc_xy[math.random(#sgzc_xy)];
    P_MapMove(uSource, 185, t[1], t[2], 0);	
    return;
  end; 


  --VIP福利
  if aStr == 'vipfl' then
    --检测是否是VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if viplevel < 1 then 
      P_MenuSay(uSource, '您还不是VIP!');
     return;	
    end;
	--获取领取时间戳
	local aNow = P_GetTempArr(uSource, 15);
	--判断日期	
    if os.date("%Y-%m-%d", aNow) == os.date("%Y-%m-%d", os.time()) then 
      P_MenuSay(uSource, '今日已领取过!');
     return;
    end;
	--获取道具table
	local ItemTable = VipAward[viplevel];
    --检测背包空位	
    if P_getitemspace(uSource) < #ItemTable then
      P_MenuSay(uSource, string.format('请保留%d个物品栏空位', #ItemTable));
     return;
    end; 
	--修改领取时间戳
	P_SetTempArr(uSource, 15, os.time());	
    --给予道具
    for i, v in pairs(ItemTable) do
      if type(v) == 'table' then
        P_additem(uSource, v[1], v[2], 'VIP福利');
      end
    end;
    --提示
	P_MenuSay(uSource, '恭喜你领取了今日福利!');
    return;
  end;

  --VIP 修炼场
  if aStr == 'xlc' then
    P_MenuSay(uSource, WGMenu);
   return;
  end;

  --进入VIP 修炼场
  if aStr == 'vipwgjr' then
    -- --判断时间
    -- local H = tonumber(os.date('%H'));
	-- if H > 13 and H < 22 then 
      -- P_MenuSay(uSource, '每日22点到14点期间开放修炼场');
     -- return;
    -- end;
    --获取当前时间
	local aTime = P_GetTempArr(uSource, 10);
    if aTime <= 0 then 
      P_MenuSay(uSource, '你没有修炼场时间!');
     return;
    end;
	--传送玩家
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = xl_xy[math.random(#xl_xy)];
    P_MapMove(uSource, 91, t[1], t[2], 0);	
	--提示时间
    P_saysystem(uSource, string.format('修炼场时间剩余 %s', timestostring(aTime)), 15);	
    return;
  end;	

  --进入VIP 修炼场2
  if aStr == 'vipwgjr2' then
    -- --判断时间
    -- local H = tonumber(os.date('%H'));
	-- if H > 13 and H < 22 then 
      -- P_MenuSay(uSource, '每日22点到14点期间开放修炼场');
     -- return;
    -- end;
    --获取当前时间
	local aTime = P_GetTempArr(uSource, 10);
    if aTime <= 0 then 
      P_MenuSay(uSource, '你没有修炼场时间!');
     return;
    end;
	--传送玩家
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = xl_xy[math.random(#xl_xy)];
    P_MapMove(uSource, 92, t[1], t[2], 0);	
	--提示时间
    P_saysystem(uSource, string.format('修炼场时间剩余 %s', timestostring(aTime)), 15);	
    return;
  end;	

  --领取VIP 修炼场 时间
  if aStr == 'vipwglq' then
    --获取VIP信息
    local viplevel, viptime = P_GetVipInfo(uSource);
    -- if strtostamp(viptime) < os.time() then 
      -- P_MenuSay(uSource, 'VIP才可领取!');
      -- return 'true';
    -- end;
	--获取领取时间戳
	local aNow = P_GetTempArr(uSource, 9);
	--判断日期	
    if os.date("%Y-%m-%d", aNow) == os.date("%Y-%m-%d", os.time()) then 
      P_MenuSay(uSource, '今日已领取过!');
     return;
    end;
	local aTime = P_GetTempArr(uSource, 10);
	--判断VIP等级
	if viplevel == 2 then 
	  aTime = aTime + 60 * 60 * 12;
	elseif viplevel == 1 then 
	  aTime = aTime + 60 * 60 * 10;
	else
	  aTime = aTime + 60 * 60 * 6;
	end
	if aTime > XLmax[viplevel] then 
      aTime = XLmax[viplevel];
	end	
	--修改修炼场时间
	P_SetTempArr(uSource, 10, aTime);
	--修改领取时间戳
	P_SetTempArr(uSource, 9, os.time());	
    --随机传送到修炼场
    P_MenuSay(uSource, '恭喜你领取了修炼场时间!^当前修炼场时间: ' .. timestostring(aTime));
    return;
  end;	

  --查询VIP 修炼场 时间
  if aStr == 'vipwgcx' then
	local aTime = P_GetTempArr(uSource, 10);
    P_MenuSay(uSource, string.format('当前修炼场时间: %s', timestostring(aTime)));
    return;
  end;	
  
  --角色转移
  if aStr == 'jszy' then
    P_MenuSay(uSource, JSZYMenu);
    return;
  end;

  --开始角色转移
  if aStr == 'ksjszy' then
    --检测背包锁
    if P_GetItemPassBo(uSource) then 
	  P_MenuSay(uSource, '请先取消物品栏密码');
      return;
    end
	--弹出输入框
    P_MsgConfirmDialog(uSource, uDest, 101, '请输入角色新的登陆账号');
    return;
  end;

  if aStr == 'shjszy' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
      P_MenuSay(uSource, '无权审核');
	  return ; 
	end;	
	--展示数据列表
	local str = '尊敬的管理员,请仔细审核数据!^^';
	for k,v in pairs(_zy.data) do
	  str = string.format('%s<『$00FFFF00| 角色:%s 转移帐号:%s 密保:%s』/@xzzyjs_%s>^^', str, v['name'], v['acc'], v['mb'], k);	
	end
	str = string.format('%s<『$00FFFF00| 返 回』/@fanhui>', str);	
	--返回信息
	P_MenuSay(uSource, str);
    return;
  end;	
  

  local Left, Right = lua_GetToken(aStr, "_");
  if Left == 'xzzyjs' then
    local t = _zy.data[Right]
	if t == nil then return end;	
	--组成输出字符
	local Str = string.format('注意：确定审核【%s】申请的角色转移?^', t['name']);
	Str = string.format('%s转移目标帐号:%s^', Str, t['acc']);
	Str = string.format('%s提交密保资料:%s^^', Str, t['mb']);
	Str = string.format('%s<『$00FFFF00| 确认审核』/@qrjszt_%s>^', Str, Right);
	Str = string.format('%s<『$00FFFF00| 取消审核』/@exit>', Str);
    P_MenuSay(uSource, Str);
  end;
  if Left == 'qrjszt' then
    local t = _zy.data[Right];
	if t == nil then return end;	
    --检测玩家是否在线
	local uObject, BoFind = M_GetUserIsPointer(Right);
    if not BoFind then 
       P_MenuSay(uSource, string.format('玩家[%s]不在线', Right));	
      return;
    end;
	-- --扣除道具
    -- if not P_deleteitem(uObject, '交易币', 500, '角色转移') then 
       -- P_MenuSay(uSource, string.format('删除玩家[%s]500个交易币失败', Right));	
      -- return;
    -- end;	
    --获取当前帐号
    local PlayMaster = P_GetMasterName(uObject);
	--改变帐号
	P_SetMasterName(uObject, t['acc']);	
	--改变MYSQL数据库角色帐号
    local sql = string.format('UPDATE mqn_values set c_account = "%s" WHERE c_account = "%s" and c_CharName = "%s"', t['acc'], PlayMaster, Right);
 	M_DoMySql(sql);	
	--全服公告
	-----M_worldnoticesysmsg(string.format('【系统公告】玩家[%s]已转移到了新的帐号', Right), 18);
	--踢玩家下线
	P_BanPlay(uObject);
	--清空数据
	_zy.data[Right] = nil;
	_zy.Save();
	--提示
	P_MenuSay(uSource, '审核成功  角色已转移');
  end;
 return;
end

function _GetTableStr(t)
  if type(t) ~= 'table' then return '' end;
  local Str = '';
  for i, v in pairs(t) do
    if type(v) == 'table' then
      Str = string.format('%s%d个%s  ', Str, v[2], v[1]);
    end
  end;
  return Str;
end


function OnConfirmDialog(uSource, uDest, key, aStr)
  --判断KEY
  if key == 101 then 
	--检测账号
	if aStr == '' then 
      P_MenuSay(uSource, '没有输入转移的账号');
      return;
	end
	--记录账号
	local PlayName = B_GetRealName(uSource);
	_zy.temp[PlayName] = {};
	_zy.temp[PlayName]['acc'] = aStr;
    P_MsgConfirmDialog(uSource, uDest, 102, '请再次输入角色新的登陆账号');
  elseif key == 102 then 
    local PlayName = B_GetRealName(uSource);
	if _zy.temp[PlayName] == nil then 
      return;
	end
    if aStr ~= _zy.temp[PlayName]['acc'] then 
      P_MenuSay(uSource, '2次输入账号不一致');
      return;
	end
	--判断是否自己账号
	if P_GetMasterName(uSource) == aStr then 
      P_MenuSay(uSource, '不能转移给自己');
      return;
	end
	--判断账号下角色数量
    local sql = string.format('SELECT Count(c_Id) AS Count FROM mqn_values WHERE c_account="%s"', aStr);
    local Data = M_GetMySqlDataSet(sql);
    if Data ~= nil and Data[1] ~= nil and tonumber(Data[1]['Count']) >= 5 then
      P_MenuSay(uSource, string.format('账号[%s]角色数量已满', aStr));
      return;
    end;
    P_MsgConfirmDialog(uSource, uDest, 103, '请输入当前账号密保邮箱或者密保手机');
    return;
  elseif key == 103 then 
	--检测输入
	if aStr == '' then 
      P_MenuSay(uSource, '没有输入当前账号密保邮箱或者密保手机');
      return;
	end
    local PlayName = B_GetRealName(uSource);
	if _zy.temp[PlayName] == nil then 
      return;
	end 
    --检测玩家道具
    if P_getitemcount(uSource, '交易币') < 500 then 
      P_MenuSay(uSource, '转移需要500个交易币');
     return;
    end;
    --删除物品
    P_deleteitem(uSource, '交易币', 500, '角色转移');
	--记录数据
	_zy.data[PlayName] = {};
	_zy.data[PlayName]['name'] = PlayName;
	_zy.data[PlayName]['acc'] = _zy.temp[PlayName]['acc'];
	_zy.data[PlayName]['mb'] = aStr;
	_zy.Save();
	--清空临时数据
	_zy.temp[PlayName] = nil;
	--返回提示
    P_MenuSay(uSource, string.format('已申请转移当前角色到新的登录帐号:%s^^请联系客服人员进行审核后转移', _zy.data[PlayName]['acc']));
    return;
  end;
 return;
end
