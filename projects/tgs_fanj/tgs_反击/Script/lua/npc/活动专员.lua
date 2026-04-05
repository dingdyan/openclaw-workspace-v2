package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

local Npc_Name = '活动专员';

--变量记录
Var = {
  --数据保存路径
  File = "Tgsplus\\变量记录.sdb",
  --数据
  data = {
    ['FB1'] = 0,
    ['FB2'] = 0,
  },
}

--进入盘古峡谷传送坐标
local MoveXYg = {
  {79, 79},
}

--进入周末副本传送坐标
local MoveXY = {
  {148, 163},
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

--福利道具
local VipAward = {
  [1] = {
	{'新手汤药', 500, 1},
    {'新手生药', 500, 1},
  },
  [2] = {
    {'新手汤药', 600, 1},
    {'新手生药', 600, 1},
  },
  [3] = {
    {'新手汤药', 700, 1},
    {'新手生药', 700, 1},
  },
  [4] = {
	{'新手汤药', 800, 1},
    {'新手生药', 800, 1},
  },
  [5] = {
    {'新手汤药', 1000, 1},
    {'新手生药', 1000, 1},
  },
  [6] = {
    {'新手汤药', 1200, 1},
    {'新手生药', 1200, 1},
  },
  [7] = {
	{'新手汤药', 1500, 1},
    {'新手生药', 1500, 1},
  },
  [8] = {
    {'新手汤药', 2000, 1},
    {'新手生药', 2000, 1},
  },
  [9] = {
    {'金毛草(绑定)', 2000, 1},
    {'青盐精(绑定)', 2000, 1},
  },
};

--副本配置
local fuben = {
  --副本ID
  ids = 1,
  --副本名
  names = '单人副本',
  --地图ID
  mapid = 111,
  --副本地图ID范围
  newid = {300, 350},
  --进入年龄
  Age = 2000,
  --进入坐标
  XY = {24, 27},
  --非VIP进入道具
  noviptime = {'钱币', 99999999},
  --普通玩家次数
  maxnum = 1,
  --VIP玩家次数
  vip1maxnum = 1,
  vip2maxnum = 2,
  vip3maxnum = 3,
  vip4maxnum = 4,
  vip5maxnum = 5,
  vip6maxnum = 6,
  vip7maxnum = 7,
  vip8maxnum = 8,
  vip9maxnum = 9,
  --进入时间变量
  times = 0,
};

local MainMenu =
[[
各种详情请注意关注主页^
1，『$0080FF80|@开启炼体属性  可以重新刷新当前炼体属性』^
2，『$0080FF80|@关闭炼体属性  可以关闭当前炼体属性』^^
<「游标.bmp」『$FF00FF00| 领取 推广礼包 (每个角色只能领取1次)』/@srkh>^^
<「游标.bmp」『$FF00FF00| 领取 每日福利 (每天可以领取1次)』/@lingqu>^^
]];
--<「游标.bmp」『$00FFFF00| 进入 乾坤活动』/@jrxkzc>^^
--<「游标.bmp」『$00FFFF00| 进入 密境活动』/@jrbypy>^ 
--<「游标.bmp」『$00FFFF00| 进入 白银活动』/@xymj>^
--<「游标.bmp」『$00FFFF00| 兑换 太极明珠』/@dhtjmz>^
--<「游标.bmp」『$00FFFF00| 进入 日月王城 (每日20点开启-前5分钟进入-门战日不开放)』/@jrrywc>^^
--<「游标.bmp」『$FF00FF00| 挑战 单人副本 (炼体等级越高进入次数越多)』/@drfb>^^
--<「游标.bmp」『$FF00FF00| 进入 盘古峡谷 (每日20点开启-前5分钟进入-门战日不开放)』/@jrpgxg>^^
local XYMenu =
[[
白银活动 每晚22:00-23:00开放^^
<「游标.bmp」『$FF00FF00| 进入 白银活动』/@jrxymj>^
<「游标.bmp」『$FF00FF00| 返回』/@fanhui>
]];

--白银活动 随机进入
local xy_xy = {
  {182, 55},
  {64, 130},
  {26, 86},
  {50, 41},
};

--黄金活动 随机进入
local by_xy = {
  {182, 55},
  {64, 130},
  {26, 86},
  {50, 41},
};

--钻石活动 随机进入
local xk_xy = {
  {182, 55},
  {64, 130},
  {26, 86},
  {50, 41},
};

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;
  
  
  if aStr == 'srkh' then
    --弹出输入框
    P_MsgConfirmDialog(uSource, uDest, 110, '请输入CDK<礼包兑换>')
    return;
  end;

  if aStr == 'fanhui' then
    P_MenuSay(uSource, MainMenu);
   return;
  end;
  
  --每日福利
  if aStr == 'lingqu' then
    --检测是否是VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if viplevel < 1 then 
      P_MenuSay(uSource, '您还没有炼体称号！！');
     return;    
    end;
	if VipAward[viplevel] == nil then 
     return;    
    end;
    --获取玩家名称
    local PlayName = B_GetRealName(uSource);
    --获取当前日期
    local CurrentDate = os.date("%Y-%m-%d");
    --玩家状态检查
    local PlayData = '';
    local Data = M_GetMySqlDataSet('SELECT dates FROM wxz_vipfuli_1 WHERE playname="'..PlayName..'"');
    --判断读取MYSQL状态
    if Data == -1 then return end;
    if Data ~= nil and Data[1] ~= nil then
      PlayData = Data[1]['dates'];
    end;
    --判断是否领取
    if PlayData == CurrentDate then     
      P_MenuSay(uSource, '今日已领取过了!');
     return;    
    end;
    --检测背包空位
	if P_getitemspace(uSource) < 2 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end;  
    --写入数据库    
    local SQL = string.format('INSERT wxz_vipfuli_1 (playname, dates) values (\'%s\', \'%s\') ON DUPLICATE KEY UPDATE dates=\'%s\'', PlayName, CurrentDate, CurrentDate);        
    if M_DoMySql(SQL) <= 0 then 
      P_MenuSay(uSource, '领取失败,请联系管理员!');
     return;    
    end;    
    --给予道具
    for i, v in pairs(VipAward[viplevel]) do
      if type(v) == 'table' then
        if v[1] == '天赋经验' then 
          P_SetnewTalentExp(uSource, P_GetnewTalentExp(uSource) + v[2]);
          P_LeftText(uSource, string.format('天赋经验 获得 %d 个', v[2]), 55769, 3);
        elseif v[1] == '钱币1' then 
          P_AddBindMoney(uSource, v[2]);
          P_LeftText(uSource, string.format('绑定钱币 获得 %d 个', v[2]), 55769, 3);
        else
          P_additem(uSource, v[1], v[2], 'VIP福利员');
        end
      end
    end;
    --提示
    P_MenuSay(uSource, '恭喜,成功领取了当日福利!');
    --gonggao 
    --M_worldnoticemsg(string.format('VIP福利员:玩家[%s]领取了今日VIP福利!!', B_GetRealName(uSource)), 33023 , 2359332);
    return;
  end; 

 --[[进入盘古峡谷
  if aStr == 'jrpgxg' then
    --检查VIP
	local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then 
      P_MenuSay(uSource, '您不是会员,无法为您服务');
     return;	
    end;
	--检测道具
    if P_getitemcount(uSource, '盘古门票') < 1 then
	  P_MenuSay(uSource, '需要[盘古门票:1]才能进入');
     return;
    end;
    --获取星期
	local w = tonumber(os.date('%w'));
    --获取小时:分钟:秒
    local HMS = tonumber(os.date('%H%M%S'));
	if ((w >= 1 and w <= 5) and HMS >= 200005 and HMS <= 200505) then
	  P_deleteitem(uSource, '盘古门票', 1, '活动专员');
	  local XY = MoveXYg[math.random(#MoveXYg)];	
	  if XY == nil then XY = {79, 79} end;
	  P_MapMove(uSource, 128, XY[1], XY[2], 0);
	else
      P_MenuSay(uSource, '周一至周五每晚20点开放^开放后5分钟内进入,已错过时间！');
     return;
    end;
  end;]]
  
  --盘古峡谷
  if aStr == 'jrpgxg' then
     --检查VIP
	local viplevel, viptime = P_GetVipInfo(uSource);
    if viplevel < 3 then 
      P_MenuSay(uSource, '炼体等级达到[结丹期]才能进入');
     return;	
    end;
    --检测道具
    if P_getitemcount(uSource, '盘古门票') < 1 then 
       P_MenuSay(uSource, '进入需要1个盘古门票');
      return;
    end;
	--获取小时:分钟:秒
    local HMS = tonumber(os.date('%H%M%S'));
	if (HMS >= 200005 and HMS <= 200505) then 
	  P_deleteitem(uSource, '盘古门票', 1, '活动专员');
	 local XY = MoveXYg[math.random(#MoveXYg)];	
	  if XY == nil then XY = {79, 79} end;
	  P_MapMove(uSource, 128, XY[1], XY[2], 0);
	else
	 P_MenuSay(uSource, '每日20点开放-开放后5分钟内进入,已错过时间！');
    return;
  end;
end;
  
  --每日日月王城
  if aStr == 'jrrywc' then
    --检测门票
    if P_getitemcount(uSource, '日月门票') < 1 then 
	   P_MenuSay(uSource, '需要1张日月门票');
       return;
    end;
	--获取小时:分钟:秒
    local HMS = tonumber(os.date('%H%M%S'));
	if (HMS >= 200005 and HMS <= 200505) then 
     P_deleteitem(uSource, '日月门票', 1, '活动专员');
	 local XY = MoveXY[math.random(#MoveXY)];	
	  if XY == nil then XY = {148, 168} end;
	  P_MapMove(uSource, 120, XY[1], XY[2], 0);
	else
	 P_MenuSay(uSource, '每日20点开放-开放后5分钟内进入,已错过时间！');
    return;
  end;
end;

  --[[进入日月王城
  if aStr == 'jrrywc' then
    --检查VIP
	local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then 
      P_MenuSay(uSource, '您不是会员,无法为您服务');
     return;	
    end;
	--检测道具
    if P_getitemcount(uSource, '日月门票') < 1 then
	  P_MenuSay(uSource, '需要[日月门票:1]才能进入');
     return;
    end;
    --获取星期
	local w = tonumber(os.date('%w'));
    --获取小时:分钟:秒
    local HMS = tonumber(os.date('%H%M%S'));
	 if (w == 0 or w == 6) and (HMS >= 200005 and HMS <= 200505) then 
	  P_deleteitem(uSource, '日月门票', 1, '活动专员');
	  local XY = MoveXY[math.random(#MoveXY)];	
	  if XY == nil then XY = {148, 168} end;
	  P_MapMove(uSource, 120, XY[1], XY[2], 0);
	else
      P_MenuSay(uSource, '每周六到周日20点开放^开放后5分钟内进入,已错过时间！');
     return;
    end;
  end;]] 
  
  
  
  --乾坤活动 开始
  if aStr == 'xkzc' then
    P_MenuSay(uSource, XKZCMenu);
    return;
  end;
  
  --钻石活动 密境
  if aStr == 'jrxkzc' then
    --获取小时:分钟
    local HM = tonumber(os.date('%H%M'));
	--获取VIP
	local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then 
      P_MenuSay(uSource, '您还不是VIP或者VIP已过期!');
     return;	
    end;
	--获取秒
    local S = tonumber(os.date('%S'));
    if (HM < 2000 or HM >= 2100) or (H == 2000 and S <= 5) then 
      P_MenuSay(uSource, '开放时间20:00-21:00');
     return;
    end;
	--检测门票
    if P_getitemcount(uSource, '乾坤门票') < 1 then 
	   P_MenuSay(uSource, '需要1张乾坤门票');
       return;
    end;
	--获取玩家基本属性
	--local Attrib = P_GetAttrib(uSource);
	--检测元气
	-- if Attrib.Energy < 18000 then 
	  -- P_MenuSay(uSource, '元气到达180.00才可进入');
	  -- return;
	-- end;
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = xy_xy[math.random(#by_xy)];
	P_deleteitem(uSource, '乾坤门票', 1, '活动专员')
    P_MapMove(uSource, 108, t[1], t[2], 0);	
    return;
  end;
  
  --密境活动开始
  if aStr == 'bypy' then
    P_MenuSay(uSource, BYMenu);
    return;
  end;
  
  --黄金活动密境
  if aStr == 'jrbypy' then
    --获取小时:分钟
    local HM = tonumber(os.date('%H%M'));
	--获取VIP
	local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then 
      P_MenuSay(uSource, '您还不是VIP或者VIP已过期!');
     return;	
    end;
	--获取秒
    local S = tonumber(os.date('%S'));
    if (HM < 2100 or HM >= 2200) or (H == 2100 and S <= 5) then 
      P_MenuSay(uSource, '开放时间21:00-22:00');
     return;
    end;
	--检测门票
    if P_getitemcount(uSource, '秘境门票') < 1 then 
	   P_MenuSay(uSource, '需要1张秘境门票');
       return;
    end;
	--获取玩家基本属性
	--local Attrib = P_GetAttrib(uSource);
	--检测元气
	-- if Attrib.Energy < 18000 then 
	  -- P_MenuSay(uSource, '元气到达180.00才可进入');
	  -- return;
	-- end;
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = xy_xy[math.random(#by_xy)];
	P_deleteitem(uSource, '秘境门票', 1, '活动专员')
    P_MapMove(uSource, 107, t[1], t[2], 0);	
    return;
  end; 
  
  --白银活动开始
  if aStr == 'xymj' then
    P_MenuSay(uSource, XYMenu);
    return;
  end;
  
  --进入白银活动
  if aStr == 'jrxymj' then
    --获取小时:分钟
    local HM = tonumber(os.date('%H%M'));
	--获取秒
    local S = tonumber(os.date('%S'));
    if (HM < 2200 or HM >= 2300) or (H == 2200 and S <= 5) then 
      P_MenuSay(uSource, '开放时间22:00-23:00');
     return;
    end;
	--获取玩家基本属性
	--local Attrib = P_GetAttrib(uSource);
	--检测元气
	-- if Attrib.Energy < 18000 then 
	  -- P_MenuSay(uSource, '元气到达180.00才可进入');
	  -- return;
	-- end;
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = xy_xy[math.random(#xy_xy)];
    P_MapMove(uSource, 106, t[1], t[2], 0);	
    return;
  end; 
  
  --单人副本
  if aStr == 'drfb' then
      local str =
[[确认要进入单人副本吗?^炼体等级越高挑战次数越多--以此类推^^
<「游标.bmp」『$FF00FF00| 确认进入单人副本』/@qrfb>^
]];
     P_MenuSay(uSource, str);
    return;
  end;	
  --进入单人副本
  if aStr == 'qrfb' then
    --获取玩家基本属性
    local Attrib = P_GetAttrib(uSource);
    --[[判断年龄是否到达
    if Attrib.Age < fuben.Age then 
      P_MenuSay(uSource, string.format('抱歉,年龄到达%.2f后才可进入!', fuben.Age / 100));
     return;	
    end;]]
	--判断间隔时间
	local tm = os.time();
	if tm < fuben.times then 
       P_MenuSay(uSource, '抱歉,3秒内只允许1个玩家进入副本,请稍后!');
      return;
    end;	
    --获取玩家名称
    local PlayName = B_GetRealName(uSource);
    --获取当前日期
    local CurrentDate = os.date("%Y-%m-%d");
    local PlayDate = '';
    local PlayNum = 0;
	--玩家最大进入次数
    local PlayMax = fuben.maxnum;
	--VIP1最大进入次数
	local PlayMax1 = fuben.vip1maxnum;
	--VIP2最大进入次数
	local PlayMax2 = fuben.vip2maxnum;
	--VIP3最大进入次数
	local PlayMax3 = fuben.vip3maxnum;
	--VIP4最大进入次数
	local PlayMax4 = fuben.vip4maxnum;
	--VIP5最大进入次数
	local PlayMax5 = fuben.vip5maxnum;
	--VIP6最大进入次数
	local PlayMax6 = fuben.vip6maxnum;
	--VIP7最大进入次数
	local PlayMax7 = fuben.vip7maxnum;
	--VIP8最大进入次数
	local PlayMax8 = fuben.vip8maxnum;
	--VIP9最大进入次数
	local PlayMax9 = fuben.vip9maxnum;
    --检测是否是VIP
	local novip = true;
    local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) >= os.time() then 
       novip = false;
    end;	
	--不是VIP判断道具
	if novip then 
       if P_getitemcount(uSource, fuben.noviptime[1]) < fuben.noviptime[2] then 
          P_MenuSay(uSource, string.format('抱歉,您还没有炼体称号'));
         return;
       end	
    end;
    --读取MYSQL数据
    local SQL = string.format('SELECT dates, num FROM wxz_fuben_1 WHERE playname="%s" and ids=%d', PlayName, fuben.ids);
    local Data = M_GetMySqlDataSet(SQL);
	--判断读取MYSQL状态
	if Data == -1 then return end;
    if Data ~= nil and Data[1] ~= nil then
      PlayDate = Data[1]['dates'];
      PlayNum = tonumber(Data[1]['num']);
	else
	  --没有数据写入数据
	  local SQL = string.format('INSERT wxz_fuben_1 (playname, ids, dates, num) values (\'%s\', %d, \'%s\', %d)', PlayName, fuben.ids, CurrentDate, 0);
      if M_DoMySql(SQL) <= 0 then 
        P_saysystem(uSource, '副本进入失败,请联系管理员!', 2);
       return;		
      end;
	  --新写入数据日期设为相同以及次数为0
	  PlayDate = CurrentDate;	
	  PlayNum = 0;
    end;
    --日期不同重置日期和次数
	if PlayDate ~= CurrentDate then 
	  local SQL = string.format('UPDATE wxz_fuben_1 SET dates="%s", num=0 WHERE playname="%s" and ids=%d', CurrentDate, PlayName, fuben.ids);
      if M_DoMySql(SQL) <= 0 then 
        P_saysystem(uSource, '副本进入失败,请联系管理员!', 2);
       return;		
      end;	
	  --重置次数后设定进入次数为0
	  PlayNum = 0;
	end	
    --判断日期相同以及进入次数
	if novip and PlayDate == CurrentDate and PlayNum >= PlayMax then 
       P_MenuSay(uSource, string.format('抱歉,今日你已进入了%d次,无法进入了！', PlayNum));
      return;
	end
	if viplevel == 1 and PlayDate == CurrentDate and PlayNum >= PlayMax1 then 
       P_MenuSay(uSource, string.format('抱歉,练气期每天能进入1次每日副本,你已进入了%d次,无法进入了', PlayNum));
      return;
	end
	if viplevel == 2 and PlayDate == CurrentDate and PlayNum >= PlayMax2 then 
       P_MenuSay(uSource, string.format('抱歉,筑基期每天能进入2次每日副本,你已进入了%d次,无法进入了', PlayNum));
      return;
	end
	 if viplevel == 3 and PlayDate == CurrentDate and PlayNum >= PlayMax3 then 
       P_MenuSay(uSource, string.format('抱歉,结丹期每天能进入3次每日副本,你已进入了%d次,无法进入了', PlayNum));
      return;
	end
	if viplevel == 4 and PlayDate == CurrentDate and PlayNum >= PlayMax4 then 
       P_MenuSay(uSource, string.format('抱歉,元婴期每天能进入4次每日副本,你已进入了%d次,无法进入', PlayNum));
      return;
	end
	if viplevel == 5 and PlayDate == CurrentDate and PlayNum >= PlayMax5 then 
       P_MenuSay(uSource, string.format('抱歉,化神期每天能进入5次每日副本,你已进入了%d次,无法进入了', PlayNum));
      return;
	end
	 if viplevel == 6 and PlayDate == CurrentDate and PlayNum >= PlayMax6 then 
       P_MenuSay(uSource, string.format('抱歉,炼虚期每天能进入6次每日副本,你已进入了%d次,无法进入了', PlayNum));
      return;
	end
	if viplevel == 7 and PlayDate == CurrentDate and PlayNum >= PlayMax7 then 
       P_MenuSay(uSource, string.format('抱歉,合体期每天能进入7次每日副本,你已进入了%d次,无法进入了', PlayNum));
      return;
	end
	if viplevel == 8 and PlayDate == CurrentDate and PlayNum >= PlayMax8 then 
       P_MenuSay(uSource, string.format('抱歉,大乘期每天能进入8次每日副本,你已进入了%d次,无法进入了', PlayNum));
      return;
	end
	 if viplevel == 9 and PlayDate == CurrentDate and PlayNum >= PlayMax9 then 
       P_MenuSay(uSource, string.format('抱歉,渡劫期每天能进入9次每日副本,你已进入了%d次,无法进入了', PlayNum));
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
      P_MenuSay(uSource, '副本房间已满,请稍后进入...');
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
    --更新今日进入次数SQL	
    local SQL =  string.format('UPDATE wxz_fuben_1 SET num = %d WHERE playname="%s" and ids=%d', PlayNum + 1, PlayName, fuben.ids);
    if M_DoMySql(SQL) <= 0 then 
      P_saysystem(uSource, '副本进入失败,请联系管理员!', 2);
     return;		
    end;	
	--不是VIP删除道具
	if novip then 
	   P_deleteitem(uSource, fuben.noviptime[1], fuben.noviptime[2], '单人副本进入');
    end;	
	--6,移动玩家到密室
	P_MapMove(uSource, MapID, fuben.XY[1], fuben.XY[2], 100);
	--记录时间
	fuben.times = tm + 3; 
   return;
  end;
  return;
 end; 
 
function OnConfirmDialog(uSource, uDest, InputId, aStr)
   local key = tonumber(InputId)
   --检测卡号
    if string.len(aStr) ~= 10 then 
      P_MenuSay(uSource, '请输入正确的推广码');
      return;
    end
   if key == 110 then
      local CharName = B_GetRealName(uSource);
      if aStr == '' then
         P_MenuSay(uSource, '请输入有效的 推广礼包 CDK激活码');
	      return
      end;
	 --判断礼包是否存在
    local Data = M_GetMySqlDataSet(string.format('SELECT id, items, name, endtime, state FROM card_read LEFT JOIN card ON card_read.cardid = card.id WHERE cardno = "%s" and torece = 0', aStr));
    --判断读取MYSQL状态
    if Data == -1 or Data == nil or Data[1] == nil then
     P_MenuSay(uSource, '礼包码错误或已领取');
      return
    end;
    local id = tonumber(Data[1]['id']) or 0;
	--获取VIP信息
	local viplevel, viptime = P_GetVipInfo(uSource);
	if id ~= 2 and id ~= 3 and viplevel < 0 then 
      P_MenuSay(uSource, '[会员]才可领取');
     return
    end;
    local items = lua_Strtotable(Data[1]['items'], ';');
    local name = Data[1]['name'];
    if #items < 1 or name == '' then
      return
    end;
    local endtime = tonumber(Data[1]['endtime']) or 0;
    local state = tonumber(Data[1]['money']) or 0;
	if os.time() > endtime or state ~= 0 then
      P_MenuSay(uSource, '礼包已到期');
      return
    end;
	--判断物品栏空位
	if P_getitemspace(uSource) < #items then
      P_MenuSay(uSource, string.format('需要%d个物品栏位置', #items));
      return;
	end;
    --判断是否领取
    local PlayName = B_GetRealName(uSource);
    local Data = M_GetMySqlDataSet(string.format('SELECT torece FROM card_read WHERE playname = "%s" AND cardid = %d', PlayName, id));
    if Data ~= nil and Data[1] ~= nil then
      P_MenuSay(uSource, '不能重复领取同类型礼包');
      return
    end;
	--写入数据
    M_DoMySql(string.format('UPDATE card_read SET torece = 1, playname ="%s" WHERE cardno = "%s"', PlayName, aStr));
	--给予道具
    for i, v in pairs(items) do
      local t = lua_Strtotable(v, ':'); 
      if type(t) == 'table' then
        P_additem(uSource, t[1], t[2], name);
      end
    end;
   P_MenuSay(uSource, string.format('领取了%s', name));
   return
  end;
 end;