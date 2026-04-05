package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

local Npc_Name = '任务管理员';
--任务随机条件
local Qday = {
  --难度2数据
  [2] = {	
	{1, '牛黄', 2, 5},
	{1, '狗宝', 2, 5},
	{1, '马骨', 2, 5},
	{1, '猪皮', 2, 5},
	{1, '鹿茸', 2, 5},
	{1, '鹿角', 2, 5},
	{1, '熊皮', 2, 5},
	{1, '犀牛角', 2, 5},
	{1, '犀牛皮', 2, 5},
	{1, '狼牙', 1, 2},
	{1, '狼皮', 1, 2},
	{1, '木皮', 2, 5},
  },
  --难度3数据
  [3] = {	
	{1, '牛黄', 2, 5},
	{1, '狗宝', 2, 5},
	{1, '马骨', 2, 5},
	{1, '猪皮', 2, 5},
	{1, '鹿茸', 2, 5},
	{1, '鹿角', 2, 5},
	{1, '熊皮', 2, 5},
	{1, '犀牛角', 2, 5},
	{1, '犀牛皮', 2, 5},
	{1, '狼牙', 1, 2},
	{1, '狼皮', 1, 2},
	{1, '木皮', 2, 5},
  },
};

--任务随机奖励
local DayQitem = {
    {'新手汤药', 200},
	{'新手生药', 200},
	{'新手汤药', 300},
	{'新手生药', 300},
	{'新手汤药', 400},
	{'新手生药', 400},
	{'新手汤药', 500},
	{'新手生药', 500},
};

--任务类型
local Qindex = {
  [1] = '黄金任务',
  [2] = '钻石任务',
};

--特殊奖励记录
local _wxjl = {
  --数据保存路径
  File = "Tgsplus\\奖励记录.sdb",
  --数据
  data = {},
};

--读取数据库
_wxjl.Load = function()
  if file_exists(_wxjl.File) then
    _wxjl.data = table.load(_wxjl.File)
  end
end
--保存数据库
_wxjl.Save = function()
  table.save(_wxjl.data, _wxjl.File)
end

--获取随机道具
_wxjl.Get = function(Index)
  --为空随机记录
  if _wxjl.data[Index] == nil or #_wxjl.data[Index] < 1 then 
    local t = table_copy_table(Qitem[Index]);
    for i = 1,#t do                                    --用for循环遍历这个表
	  a = math.random(#t + 1 - i);                 --取这个表的长度加1减i来随机
	  t[a], t[#t + 1 - i] = t[#t + 1 - i], t[a];	--然后再将取出的a的值与 #t+1-i的值交换位置
    end
	_wxjl.data[Index] = t;
  end;
  local t = _wxjl.data[Index][#_wxjl.data[Index]];
  --删除保存
  table.remove(_wxjl.data[Index]);
  _wxjl.Save();
  --返回
 return t;
end

--读取数据
_wxjl.Load();

local MainMenu = [[
『$FF00ff00|提示:只有会员玩家才能领取武侠任务』^
『$FF00ff00|提示:会员玩家每日可领取5次武侠任务』^
『$FF00ff00|提示:完成每次任务可随机获得:药品』^『$FF00ff00|每次固定获得:20点个人贡献和1个门战力积分』^^
<「游标.bmp」『$00FFFF00| 领取 武侠任务』/@lqzs>^
<「游标.bmp」『$00FFFF00| 完成 武侠任务』/@wczs>^
<「游标.bmp」『$00FFFF00| 瞬间完成 武侠任务』/@sjwc>^
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;
  
  --侠客任务
  if aStr == 'xkrw' then
    P_MenuSay(uSource, XKMenu);
    return;
  end

  if aStr == 'lqzs' then
    _lqrw(uSource, 2);
    return;
  end;	

  if aStr == 'lqzz' then
    _lqrw(uSource, 3);
    return;
  end;	

  if aStr == 'wczs' then
    _wcrw(uSource, 2);
    return;
  end;	
  
  if aStr == 'sjwc' then
    _wcrw2(uSource, 2);
    return;
  end;	

  if aStr == 'wczz' then
    _wcrw(uSource, 3);
    return;
  end;

  --返回
  if aStr == 'fanhui' then
    P_MenuSay(uSource, MainMenu);
    return;
  end;
   return;
  end;
  
function _lqrw(uSource, uLevel)
    --检测是否是VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then 
      P_MenuSay(uSource, '您还不是VIP会员，无法领取任务!');
     return;	
    end;
	if uLevel == 1 and viplevel < 0 then 
      P_MenuSay(uSource, '您还不是VIP会员，无法领取任务');
     return;	
	elseif uLevel == 2 and viplevel < 1 then 
      P_MenuSay(uSource, '您还不是VIP会员，无法领取任务');
     return;	
    end;
    --检测背包空位
    if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满');
     return;
    end; 
     --获取玩家名称
     local PlayName = B_GetRealName(uSource);
     --获取当前日期
     local CurrentDate = os.date("%Y-%m-%d");
     --任务状态检查
	 local QDate = CurrentDate;
	 local QState = 0;
	 local QMax = 0;
	 local maxstr = 'max_' .. tostring(uLevel);
     local Data = M_GetMySqlDataSet('SELECT state,dates,' .. maxstr ..' FROM wxz_xkquest WHERE playname="'..PlayName..'"');
	 --判断读取MYSQL状态
	 if Data == -1 then return end;
	 if Data ~= nil and Data[1] ~= nil then
		QDate = Data[1]['dates'];
		QState = tonumber(Data[1]['state']);
		QMax = tonumber(Data[1][maxstr]);
	 else
       --写入数据库
       local SQL = string.format('INSERT wxz_xkquest (playname, dates, type, name, num, state, max, level) values (\'%s\', \'%s\', 0, \'\', 0, 0, 0, 0)', PlayName, CurrentDate);		
       if M_DoMySql(SQL) <= 0 then 
         P_saysystem(uSource, '任务领取失败,请联系管理员!', 2);
         return;		
       end;
     end;
	 --日期不一样重置状态
	 if QDate ~= CurrentDate then
		--更新次数
		local SQL = string.format('UPDATE wxz_xkquest SET max_1 = 0, max_2 = 0, max_3 = 0 WHERE playname = \'%s\'', PlayName);
		if M_DoMySql(SQL) <= 0 then 
		  P_saysystem(uSource, '任务领取失败,请联系管理员!!', 2);
		  return;		
		end;
		QState = 0;
		QMax = 0;
     end;		
     --检测状态是否为0
     if QState ~= 0 then 
       P_MenuSay(uSource, '领取失败,当前有未完成的任务!');
      return;	
     end;	
     --检测次数是否已经做完
     if QMax >= 5 then 
       P_MenuSay(uSource, '领取失败,今日您已完成了5次');
      return;	
     end;	
	 --分配任务
	 local QLevel = uLevel;
	 local QTable = Qday[QLevel];
     if QTable == nil then 
       P_MenuSay(uSource, '当前境界无法领取武侠任务!');
      return;
     end;
     math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
     math.random(); math.random(); math.random();
	 local t = QTable[math.random(#QTable)];
     local Qtype = t[1];
     local Qname = t[2];
     local Qnum = math.random(t[3], t[4]);
     --写入数据库
     local SQL = string.format('UPDATE wxz_xkquest SET dates = \'%s\', type = %d, name = \'%s\', num = %d, state = 1, %s = %d, level = %d WHERE playname = \'%s\'', CurrentDate, Qtype, Qname, Qnum, maxstr, QMax + 1, QLevel, PlayName);
     if M_DoMySql(SQL) <= 0 then 
       P_saysystem(uSource, '任务领取失败,请联系管理员!!', 2);
       return;		
     end;
	 --返回提示
	 local queststr = '';
	 if Qtype == 1 then 
	   queststr = string.format('%s收集道具 [%d个%s]', queststr, Qnum, Qname);
	 elseif Qtype == 2 then
	   queststr = string.format('%s击杀怪物 [%d个%s]', queststr, Qnum, Qname);
	   --杀怪类型写入临时变量
	   P_SetTempStr(uSource, 2, Qname .. ':' .. Qnum);	
	   P_SetTempArr(uSource, 2, 0);	
	 end;
	 --判断是否给任务书札
	 if Qname == '黄金信物' then
	   if P_getitemcount(uSource, '黄金任务书札') < 1 then
	     P_additem(uSource, '黄金任务书札', 1, '一代宗师');
	   end;
	 elseif Qname == '钻石信物' then
	   if P_getitemcount(uSource, '钻石任务书札') < 1 then
	     P_additem(uSource, '钻石任务书札', 1, '一代宗师');
	   end;
	 end;
     --返回提示
     P_MenuSay(uSource, string.format('领取到了新的任务:^^%s^', queststr));	
	 --发送全服公告
	 --M_worldnoticemsg(string.format('一代宗师:%s领取了今日%s', B_GetRealName(uSource), Qindex[QLevel]),  16777215, 3815994);
	 --删除任务提示
	 P_DelQuestInfo(uSource, 2, 0);
	 --增加任务提示
	 local questInfo = string.format('%s<%s>?<%s>', '', queststr, '');
	 P_SendQuestInfo(uSource, 2, 0, Qindex[QLevel], questInfo, false, true);
    return;
end

function _wcrw(uSource, uLevel)
     --获取玩家名称
     local PlayName = B_GetRealName(uSource);
     --获取当前日期
     local CurrentDate = os.date("%Y-%m-%d");
     --任务状态检查
	 local QDate = '';
	 local QState = 0;
	 local Qtype = 0;
	 local Qname = '';
	 local Qnum = 0;
	 local Qlevel = 0;
     local Data = M_GetMySqlDataSet('SELECT state, dates, type, name, num, level FROM wxz_xkquest WHERE playname="'..PlayName..'"');
	 --判断读取MYSQL状态
	 if Data == -1 then return end;
	 if Data ~= nil and Data[1] ~= nil then
		QDate = Data[1]['dates'];
		QState = tonumber(Data[1]['state']);
		Qtype = tonumber(Data[1]['type']);
		Qname = Data[1]['name'];
		Qnum = tonumber(Data[1]['num']);
		Qlevel = tonumber(Data[1]['level']);
	 else
       P_MenuSay(uSource, '请先领取任务!');
	  return;
     end;
	 --判断任务等级
	 if Qlevel ~= uLevel then
       P_MenuSay(uSource, '完成任务级别不对');
	  return;
     end;
	 --判断日期
	 if QDate ~= CurrentDate then
       P_MenuSay(uSource, '任务已过期,请重新领取!');
	  return;
     end;		
     --检测状态是否为1
     if QState ~= 1 then 
       P_MenuSay(uSource, '任务已完成,请重新领取!');
      return;	
     end;	
	 --判断条件
	 if Qtype == 1 then 	
       --检测道具
       if P_getitemcount(uSource, Qname) < Qnum then 
         P_MenuSay(uSource, string.format('你还没有收集到%d个%s!!', Qnum, Qname));
        return;
       end;
	 elseif Qtype == 2 then
	   --检测杀怪数量
	   if P_GetTempArr(uSource, 2) < Qnum then
         P_MenuSay(uSource, string.format('你还没有击杀%d个%s!!', Qnum, Qname));
        return;
       end;
	 end;
	 --判断背包
     if P_getitemspace(uSource) < 1 then
       P_MenuSay(uSource, '背包已满!!');
      return;
     end; 
     --写入数据库
     local SQL = string.format('UPDATE wxz_xkquest SET state = 0 WHERE playname = \'%s\'', PlayName);
     if M_DoMySql(SQL) <= 0 then 
       P_saysystem(uSource, '任务完成失败,请联系管理员!', 2);
       return;		
     end;
	 --扣除物品或者清空临时记录
	 if Qtype == 1 then 
	   P_deleteitem(uSource, Qname, Qnum, '武侠任务');
	   --判断是否给任务书札
	 elseif Qtype == 2 then
	   P_SetTempStr(uSource, 2, '');	
	   P_SetTempArr(uSource, 2, 0);	
	 end;
	 --[[随机奖励
     math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
     math.random();
	 --分配任务
	 local QLevel = uLevel;
	 --随机任务奖励
	 local _ItemTab = {};
	 if QLevel == 1 then
	   _ItemTab = Qitem[1][math.random(#Qitem[1])];
	 elseif QLevel == 2 or QLevel == 3 then
	   _ItemTab = _wxjl.Get(QLevel);
	 end;
	 if _ItemTab == nil then 
	   P_saysystem(uSource, '任务完成失败,请联系管理员!!!', 2);
	   return;		
	 end;
	 --随机数量
	 math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
     local ItemNum = math.random(_ItemTab[2], _ItemTab[3]);]]
	 --随机获取东西table
      local AwardItem = {};
      AwardItem = DayQitem[math.random(#DayQitem)];
      if AwardItem == nil then
       return;
      end;
	 --给予道具
	 P_additem(uSource, AwardItem[1], AwardItem[2], '任务管理员');
	 P_additem(uSource, '门派战力积分', 1, '任务管理员');
	 P_additem(uSource, '个人贡献', 20, '任务管理员');
	 --返回提示
	 P_MenuSay(uSource, '恭喜你,完成了任务');
	 --发送全服公告
	 --M_worldnoticemsg(string.format('恭喜[%s]完成%s获得了%d个%s', B_GetRealName(uSource), Qindex[QLevel], ItemNum, _ItemTab[1]),  16777215, 3815994);
	 --删除任务提示
	 P_DelQuestInfo(uSource, 2, 0);
   return;
end

function _wcrw2(uSource, uLevel)
     --获取玩家名称
     local PlayName = B_GetRealName(uSource);
     --获取当前日期
     local CurrentDate = os.date("%Y-%m-%d");
     --任务状态检查
	 local QDate = '';
	 local QState = 0;
	 local Qtype = 0;
	 local Qname = '';
	 local Qnum = 0;
	 local Qlevel = 0;
     local Data = M_GetMySqlDataSet('SELECT state, dates, type, name, num, level FROM wxz_xkquest WHERE playname="'..PlayName..'"');
	 --判断读取MYSQL状态
	 if Data == -1 then return end;
	 if Data ~= nil and Data[1] ~= nil then
		QDate = Data[1]['dates'];
		QState = tonumber(Data[1]['state']);
		Qtype = tonumber(Data[1]['type']);
		Qname = Data[1]['name'];
		Qnum = tonumber(Data[1]['num']);
		Qlevel = tonumber(Data[1]['level']);
	 else
       P_MenuSay(uSource, '请先领取任务!');
	  return;
     end;
	 --判断任务等级
	 if Qlevel ~= uLevel then
       P_MenuSay(uSource, '完成任务级别不对');
	  return;
     end;
	 --判断日期
	 if QDate ~= CurrentDate then
       P_MenuSay(uSource, '任务已过期,请重新领取!');
	  return;
     end;		
     --检测状态是否为1
     if QState ~= 1 then 
       P_MenuSay(uSource, '任务已完成,请重新领取!');
      return;	
     end;	
	 --判断条件
	 if Qtype == 1 then 	
       --[[检测道具
       if P_getitemcount(uSource, Qname) < Qnum then 
         P_MenuSay(uSource, string.format('你还没有收集到%d个%s!!', Qnum, Qname));
        return;
       end;
	 elseif Qtype == 2 then
	   --检测杀怪数量
	   if P_GetTempArr(uSource, 2) < Qnum then
         P_MenuSay(uSource, string.format('你还没有击杀%d个%s!!', Qnum, Qname));
        return;
       end;
	 end;]]
	 --检测道具
      if P_getitemcount(uSource, '钱币') < 1000 then 
         P_MenuSay(uSource, '缺少钱币1000个?');
        return;
      end; 
	 --判断背包
     if P_getitemspace(uSource) < 1 then
       P_MenuSay(uSource, '背包已满!!');
      return;
     end; 
     --写入数据库
     local SQL = string.format('UPDATE wxz_xkquest SET state = 0 WHERE playname = \'%s\'', PlayName);
     if M_DoMySql(SQL) <= 0 then 
       P_saysystem(uSource, '任务完成失败,请联系管理员!', 2);
       return;		
     end;
	 --扣除物品或者清空临时记录
	 if Qtype == 1 then 
	   --P_deleteitem(uSource, Qname, Qnum, '侠客任务');
	   end;
	   --判断是否给任务书札
	 elseif Qtype == 2 then
	   P_SetTempStr(uSource, 2, '');	
	   P_SetTempArr(uSource, 2, 0);	
	 end;
	 --[[随机奖励
     math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
     math.random();
	 --分配任务
	 local QLevel = uLevel;
	 --随机任务奖励
	 local _ItemTab = {};
	 if QLevel == 1 then
	   _ItemTab = Qitem[1][math.random(#Qitem[1])];
	 elseif QLevel == 2 or QLevel == 3 then
	   _ItemTab = _wxjl.Get(QLevel);
	 end;
	 if _ItemTab == nil then 
	   P_saysystem(uSource, '任务完成失败,请联系管理员!!!', 2);
	   return;		
	 end;
	 --随机数量
	 math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
     local ItemNum = math.random(_ItemTab[2], _ItemTab[3]);]]
	 --随机获取东西table
      local AwardItem = {};
      AwardItem = DayQitem[math.random(#DayQitem)];
      if AwardItem == nil then
       return;
      end;
	 --给予道具
	 P_additem(uSource, AwardItem[1], AwardItem[2], '任务管理员');
	 P_additem(uSource, '门派战力积分', 1, '任务管理员');
	 P_additem(uSource, '个人贡献', 20, '任务管理员');
	 --返回提示
	 P_MenuSay(uSource, '恭喜你,完成了任务');
	 P_deleteitem(uSource, '钱币', 1000, '任务管理员');
	 --发送全服公告
	 --M_worldnoticemsg(string.format('恭喜[%s]完成%s获得了%d个%s', B_GetRealName(uSource), Qindex[QLevel], ItemNum, _ItemTab[1]),  16777215, 3815994);
	 --删除任务提示
	 P_DelQuestInfo(uSource, 2, 0);
end