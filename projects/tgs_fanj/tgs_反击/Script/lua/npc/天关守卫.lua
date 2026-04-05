package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

--天关排行记录
TianGuan = {
  --数据保存路径
  File = "Tgsplus\\天关排行.sdb",
  --数据
  data = {
    ['Date'] = '',
    ['Rank'] = {},
  },
  --每日领取道具
  item = {
    [1] = {
      {'新手生药', 200},
      {'新手汤药', 400},
	},
    [2] = {
      {'新手生药', 160},
      {'新手汤药', 320},
	},
    [3] = {
      {'新手生药', 120},
      {'新手汤药', 240},
	},
    [4] = {
      {'新手生药', 100},
      {'新手汤药', 200},
	},
    [5] = {
      {'新手生药', 80},
      {'新手汤药', 160},
	},
    [6] = {
      {'新手生药', 50},
      {'新手汤药', 100},
	},
    [7] = {
      {'新手生药', 50},
      {'新手汤药', 100},
	},
    [8] = {
      {'新手生药', 50},
      {'新手汤药', 100},
	},
    [9] = {
      {'新手生药', 50},
      {'新手汤药', 100},
	},
    [10] = {
      {'新手生药', 50},
      {'新手汤药', 100},
	},
  },
}

--读取数据库
TianGuan.Load = function()
  if file_exists(TianGuan.File) then
    TianGuan.data = table.load(TianGuan.File)
  end
end

--保存数据库
TianGuan.Save = function()
  table.save(TianGuan.data, TianGuan.File)
end

--读取数据
TianGuan.Load();

local Npc_Name = '天关守卫';

--副本配置
local fuben = {
  --副本名
  names = '天关',
  --地图ID
  mapid = 127,
  --副本地图ID范围
  newid = {500, 509},
  --进入年龄
  Age = 3000,
  --进入坐标
  XY = {19, 19},
  --进入道具
  item = {'金元', 20},
  --进入时间变量
  times = 0,
};

local BoNewMap = false;

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
  end;
  BoNewMap = true;
end

local MainMenu =
[[欢迎进入天关挑战自我^^
<「游标.bmp」『$00FFFF00| 进入 天关(20金元)』/@jr>^
<「游标.bmp」『$00FFFF00| 查询 天关说明』/@sm>^
<「游标.bmp」『$00FFFF00| 查询 天关排行榜』/@ph>^
<「游标.bmp」『$00FFFF00| 领取 闯关奖励』/@cgjl> ^
<「游标.bmp」『$00FFFF00| 领取 守护者证明』/@lqzq>
]];

local SMMenu =
[[天关每层怪物属性都会根据关卡级别加强(同时可5人挑战)^
3分钟内杀死怪物为挑战成功^
每次挑战成功都可领取一定白酒^
排名前10玩家可获得道具【守护者证明】^
提示:排行榜每小时更新,同层次玩家按照通关时间排名^^
<「游标.bmp」『$00FFFF00| 返 回』/@fanhui>
]];


function OnUpdate(uDest, CurTick)
  --获取小时:分钟
  local H = os.date('%H');
  --排行处理
  if H ~= TianGuan.data['Date'] then
	--记录当前 排名玩家
	local _old = {};
	for k = 1, #TianGuan.data['Rank'] do
	  table.insert(_old, {TianGuan.data['Rank'][k][1], k});
	end;
    --读取MYSQL数据
    local Data = M_GetMySqlDataSet('SELECT playname,ids FROM wxz_tianguan ORDER BY ids DESC, life DESC LIMIT 0, 10');
    if type(Data) ~= 'table' then return end;
	--循环记录排名
    for k = 1, #Data do
      if type(Data[k]) == 'table' then 
	    TianGuan.data['Rank'][k] = {Data[k]['playname'], Data[k]['ids']};
	  end;
    end;
	TianGuan.data['Date'] = H;
	TianGuan.Save();
	--循环判断之前玩家排名是否变化
    for i, v in pairs(_old) do
      if type(v) == 'table' then
        --判断是否在线
        local uObject, BoFind = M_GetUserIsPointer(v[1]);
        if BoFind then
          --排名变化
		  local n = tonumber(v[2]);
		  if TianGuan.data['Rank'][n] ~= nil and TianGuan.data['Rank'][n][1] ~= v[1] then
	        --判断BUFF
	        if P_GetAddBuff(uObject, 19) > -1 then 
	          P_SetAddBuff(uObject, 19, '君临天下', 0, 0, 0, '', {});
	          P_saysystem(uObject, '天关守卫:天关排名变化,请重新开启天关属性!', 15);
	        end;
		  end;
		end;
      end
    end;
    --M_topmsg('天关守卫:天关排名已更新', 16776960);
  end;
end	

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

  if aStr == 'sm' then
    P_MenuSay(uSource, SMMenu);
    return;
  end;

  --查询排行
  if aStr == 'ph' then
    if #TianGuan.data['Rank'] <= 0 then 
      P_MenuSay(uSource, '请等待排行更新');
     return;
	end;
     local str = '排名每日0点更新,可根据更新后排名领取奖励^^排名,玩家,关卡级别^';
     for k = 1, #TianGuan.data['Rank'] do
       local t = TianGuan.data['Rank'][k];
	   if t ~= nil then 
	     str = string.format('%s%d,%s,%d^', str, k, t[1], t[2]);	
	   end;	
     end;
     str = string.format('%s^<「游标.bmp」『$00FFFF00| 返 回』/@fanhui>', str);	
	 --返回信息
	 P_MenuSay(uSource, str);
    return;
  end;

  --领取 闯关奖励
  if aStr == 'cgjl' then
	--获取天关挑战ID
	local gks = P_GetTempArr(uSource, 1);
	if gks <= 0 then 
       P_MenuSay(uSource, '你还没开始挑战天关,请先挑战天关!');
      return;
    end;
	--获取领取奖励ID
	local jls = P_GetTempArr(uSource, 3);
	if jls + 1 >= gks then 
       P_MenuSay(uSource, string.format('你已领取到了%d层奖励,请继续挑战', jls));
      return;
	end
	--给予奖励
	local num = jls + 1;
	--药品
	P_additem(uSource, '白酒', 5 * num, '天关守卫');
	--记录奖励ID
	P_SetTempArr(uSource, 3, num);
	--返回提示
	local str = string.format('恭喜你,领取了天关%d层奖励^^', num);
	str = string.format('%s<「游标.bmp」『$00FFFF00| 继续领取下一层奖励』/@cgjl>', str);	
	P_MenuSay(uSource, str);
	--全服公告
    M_topmsg(string.format('天关守卫:[%s]领取了天关第%d层奖励', B_GetRealName(uSource), num), 16776960);	
    return;
  end;

  --领取
  if aStr == 'lqzq' then
    if #TianGuan.data['Rank'] <= 0 then 
      P_MenuSay(uSource, '请等待排行更新');
     return;
	end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满');
      return;
	end; 
	--判断物品栏
	if P_getitemcount(uSource, '守护者证明') >= 1 then 
      P_MenuSay(uSource, '你已拥有守护者证明,不能重复领取!');
      return;
	end;
	--获取玩家名称
	local RealName = B_GetRealName(uSource);
	--循环获取排名
	local n = 0;
    for k = 1, #TianGuan.data['Rank'] do
       local t = TianGuan.data['Rank'][k];
	   if t ~= nil and RealName == t[1] then 
	     n = k;
		break;
	   end;	
    end;
	if n <= 0 then 
      P_MenuSay(uSource, '天关排行榜前10名才有资格领取');
     return;
	end
	--给道具
    P_additem(uSource, '守护者证明', 1, '天关守卫');
	--提示
	P_MenuSay(uSource, '成功领取【守护者证明】^双击即可开启天关属性');
    return;
  end;

  --进入单人副本
  if aStr == 'jr' then
	--判断间隔时间
	local tm = os.time();
	if tm < fuben.times then 
       P_MenuSay(uSource, '抱歉,3秒内只允许1个玩家进入天关,请稍后!');
      return;
    end;	
	--判断道具
	if P_getitemcount(uSource, fuben.item[1]) < fuben.item[2] then 
	  P_MenuSay(uSource, string.format('进入天关需要%d个%s！', fuben.item[2], fuben.item[1]));
	 return;
	end	
	--设定地图ID
	local MapID = 0;
    --循环检测地图玩家数量
    for i = fuben.newid[1], fuben.newid[2] do
      --检测地图上次退出时间
	  local IsDupTime = M_MapGetboIsDupTime(i);
      if IsDupTime == nil or strtostamp(IsDupTime) + 60 <= os.time() then 
        --检测地图玩家数
        local iCount = M_MapUserCount(i);
        if iCount == nil or iCount <= 0 then
          MapID = i;
         break;
        end;
      end;			
    end
    --判断是否有可用地图
    if MapID == 0 then 
      P_MenuSay(uSource, '同时进入人数过多,请稍等片刻...');
     return;
    end;
    --创建刷新地图
    if not M_GetNewMap(fuben.mapid, MapID, fuben.names) then 
      --刷新地图
      if not M_MapRegen(MapID) then 
        P_MenuSay(uSource, '稍等片刻...');
       return;
      end
    end;
	--删除道具
	P_deleteitem(uSource, fuben.item[1], fuben.item[2], '天关进入');	
	--6,移动玩家到副本
	P_MapMove(uSource, MapID, fuben.XY[1], fuben.XY[2], 100);
	P_saysystem(uSource, '正在进入...请稍等...', 15);
	--记录时间
	fuben.times = tm + 3; 
	--MYSQL 关卡同步
	local ids = P_GetTempArr(uSource, 1);
	if ids > 0 then 
	  --获取玩家名称
	  local RealName = B_GetRealName(uSource);
	  local Data = M_GetMySqlDataSet('SELECT ids FROM wxz_tianguan WHERE playname="'..RealName..'" LIMIT 1');
	  --判断读取MYSQL状态
	  if Data == -1 or Data == nil or Data[1] == nil or Data[1]['ids'] ~= ids then
	    --写入MYSQL 方便排行
	    local SQL = string.format('INSERT wxz_tianguan (playname, ids, times) values (\'%s\', %d, %d) on DUPLICATE key update ids = %d, times = %d', RealName, ids, os.time(), ids, os.time());
	    M_DoMySql(SQL);
	  end;
	end;
   return;
  end;

 return;
end
