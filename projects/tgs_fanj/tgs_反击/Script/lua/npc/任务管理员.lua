package.loaded['Script\\lua\\f'] = nil;
package.loaded['Script\\lua\\任务\\主线任务'] = nil;

require ('Script\\lua\\f');
require ('Script\\lua\\任务\\主线任务');

local Npc_Name = '江湖至尊';

local _vip_sdb = 'tgsplus\\任务次数.sdb';

--任务随机奖励
local Qitem = {
  {'白酒', 100, 200},
  {'小丸丹', 50, 100},
};

--全部完成随机物品(物品名,数量)
Randomitem = {
  {'溶华素', 1},
  {'逐龙丹', 1}, 
  {'太极液', 1},
  {'金铜弥勒菩萨', 1},
  {'圣灵卷轴', 1}, 
  {'天神灵符', 1},
  {'流星箭', 30},
  {'狂风镖', 30},
  {'白酒', 10},
  {'白酒', 15},
  {'白酒', 20},
  {'白酒', 25},
  {'白酒', 30},
  {'银钞', 2},
  {'小丸丹', 5},
  {'小丸丹', 10},
  {'小丸丹', 15},
  {'小丸丹', 20},
  {'金钞', 1},
  {'桂圆丹', 1},
  {'草芥丹', 1},
  {'生死梦幻丹', 1},
  {'配饰碎片', 1},
  {'配饰碎片', 2},
  {'配饰碎片', 3},
  {'戒指碎片', 1},
  {'戒指碎片', 2},
  {'戒指碎片', 3},
  {'鉴定碎片', 1},
  {'鉴定碎片', 2},
  {'鉴定碎片', 3},
  {'鉴定碎片', 4},
  {'鉴定碎片', 5},
  {'鉴定碎片', 6},
  {'鉴定碎片', 7},
  {'鉴定碎片', 8},
  {'鉴定碎片', 9},
  {'鉴定碎片', 10},
}

--任务随机奖励
local DayQitem = {
    {'新手汤药', 100, 150},
	{'新手生药', 100, 150},
};

--配置
local renwu = {
  --次数
  num = {
    [1] = 5,
    [2] = 5,
    [3] = 5,
	[4] = 5,
    [5] = 5,
    [6] = 5,
	[7] = 5,
    [8] = 5,
    [9] = 5,
  },
};

local MainMenu =
[[
1，每日最多领取5次，完成任务可获取大量药品^^
2，全部完成5次任务，额外随机给予丰厚的奖励^^
3，直接完成任务需要3000钱币^^
4，使用Alt+Q查看任务状态^^
<「游标.bmp」『$FF00FF00| 开始领取 主线任务』/@lqxk>^^
<「游标.bmp」『$FF00FF00| 开始提交 主线任务』/@wcxk>^^
<「游标.bmp」『$FF00FF00| 直接完成 主线任务』/@fqrw>^^
]];

local FQMenu =
[[
需要直接完成本次主线任务吗?^^
『$0080FF80|注意:直接完成需要钱币3000』^^
<「游标.bmp」『$FF00FF00| 确认』/@qrfqrw>^^
<「游标.bmp」『$FF00FF00| 返回』/@fanhui>^
]];


function OnMenu(uSource, uDest)
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
  --放弃任务
  if aStr == 'fqrw' then
    P_MenuSay(uSource, FQMenu);
   return;
  end;
  
  if aStr == 'qrfqrw' then
     --取玩家名称
    local Name = B_GetRealName(uSource);
    --检测状态
    if P_GetTempStr(uSource, 5) == '' then 
      P_MenuSay(uSource, '没有接取任务!');
      return;	
    end;
    --检测道具
    if P_getitemcount(uSource, '钱币') < 3000 then 
      P_MenuSay(uSource, '没有3000个钱币');
      return;
    end;
	--判断背包
     if P_getitemspace(uSource) < 2 then
       P_MenuSay(uSource, '背包已满!!');
      return;
     end; 	
	--判断主线任务状态
    local Index = P_GetTempArr(uSource, 4);
    if Index < 1 or Index > ZxQuest.Qmax then return end;
	 local space = 1;
	 if ZxQuest.QIndexItem[Index] ~= nil then 
	   space = space + 1;
	 end;
	 --随机获取东西table
      local AwardItem = {};
      AwardItem = DayQitem[math.random(#(DayQitem))];
      if AwardItem == nil then
       return;
      end;
     --给予道具	
     local _num = math.random(AwardItem[2], AwardItem[3]);
	 --随机奖励
	 P_additem(uSource, AwardItem[1], _num, '主线任务');
	 --删除钱币
     P_deleteitem(uSource, '钱币', 3000, '主线任务');
     --写数据	
    P_SetTempStr(uSource, 5, ''); --任务内容		
	--删除标识任务引导
	P_DelQuestInfo(uSource, 2, 0);
    P_SetEventTick(uSource, 14, 100);
    --删除任务状态
	ZxQuest.Deltempa(uSource);
	--提示
    P_MenuSay(uSource, '已快速完成了本次任务');
       --取副本次数
       local cishu = tonumber(M_GetSdbInfo(_vip_sdb, Name, '任务次数'));
	   --随机获取东西table
      local AwardItemb = {};
      AwardItemb = Randomitem[math.random(#Randomitem)];
      if AwardItemb == nil then
       return;
      end;
	  if cishu >= 5 then
      --给予物品
       P_additem(uSource, AwardItemb[1], AwardItemb[2], '主线任务');
	   P_additem(uSource, '新手汤药', 500, '主线任务');
	   P_additem(uSource, '新手生药', 500, '主线任务');
      end;
	   return;
    end;

  --领取任务
  if aStr == 'lqxk' then
	--检测是否是VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then 
      P_MenuSay(uSource, '您还不是VIP或者VIP已过期!');
     return;
    end;
	 --初始化次数
     local num = 0;
	 --取玩家名称
     local Name = B_GetRealName(uSource);
     --取任务日期
     local flrq = M_GetSdbInfo(_vip_sdb, Name, '任务日期');
     --取当前日期
     local dqrq = os.date("%Y-%m-%d");
	 if flrq == dqrq then 
       --取副本次数
       num = tonumber(M_GetSdbInfo(_vip_sdb, Name, '任务次数'));
	   if num == nil or num < 0 then 
         num = 0;
       end;
	   if num >= renwu.num[viplevel] then 
         P_MenuSay(uSource, '今日任务领取次数已用完!');
        return;
       end;
	 else
       M_SetSdbInfo(_vip_sdb, Name, '任务日期', dqrq);
       M_SetSdbInfo(_vip_sdb, Name, '任务次数', 0);	
     end; 
     --检测状态
     if P_GetTempStr(uSource, 5) ~= '' then 
       P_MenuSay(uSource, '领取失败,当前有未完成的任务!');
      return;	
     end;
	 --分配任务
	 local t = ZxQuest.Qday[math.random(#ZxQuest.Qday)];
     local Qtype = t[1];
     local Qname = t[2];
     local Qcount = math.random(t[3], t[4]);
     --写入数据
	 P_SetTempStr(uSource, 5, Qtype .. ';' .. Qname .. ';' .. Qcount);
	 --返回提示
	 local queststr = '';
	 if Qtype == 1 then 
	   queststr = string.format('%s收集道具 [%d个%s]', queststr, Qcount, Qname);
	 elseif Qtype == 2 then
	   local xy = ZxQuest.Monster[Qname];
	   if xy ~= nil then 
	     queststr = string.format('%s击杀 %d个『$FF00ff00|[%s:%d_%d]』', queststr, Qcount, Qname, xy[1], xy[2]);
	   else
	     queststr = string.format('%s击杀 %d个%s', queststr, Qcount, Qname);
	   end;
	 end;	
	 --记录任务临时变量
	 local Index = P_GetTempArr(uSource, 4) + 1;
	 P_SetTempArr(uSource, 4, Index); --任务ID	
	 P_SetTempArr(uSource, 5, 0); --击杀数量
	 --记录次数
	 num = num + 1;
     M_SetSdbInfo(_vip_sdb, Name, '任务次数', num);		
     --返回提示
     P_MenuSay(uSource, string.format('领取到了新的主线任务:^^%s^', queststr));	
	 --触发任务提示
	 ZxQuest.Start(uSource);
    -- local queststr = '';
    -- if Qtype == 1 then 
      -- queststr = string.format('%s收集道具 [%d个%s]', queststr, Qcount, Qname);
    -- elseif Qtype == 2 then
      -- local xy = ZxQuest.Monster[Qname];
	  -- if xy ~= nil then 
        -- queststr = string.format('%s击杀 %d个『$FF00ff00|[%s:%d_%d]』 已击杀[%d]只', queststr, Qcount, Qname, xy[1], xy[2], P_GetTempArr(uSource, 5));
	  -- else
        -- queststr = string.format('%s击杀 %d个%s 已击杀[%d]只', queststr, Qcount, Qname, P_GetTempArr(uSource, 5));
	  -- end;
    -- end;
    -- --发送任务提示
    -- local questInfo = string.format('%s<%s>?<%s>', '主线任务', queststr, '主线任务');
    -- P_SendQuestInfo(uSource, 2, 0, string.format('主线任务[%d]', Index), questInfo, false, true);
    return;
  end;	

  if aStr == 'wcxk' then
     --取玩家名称
     local Name = B_GetRealName(uSource);
     --检测状态
     if P_GetTempStr(uSource, 5) == '' then 
       P_MenuSay(uSource, '没有接取任务!');
      return;	
     end;
     --获取任务信息
     local aStr = P_GetTempStr(uSource, 5); 
     local QData = lua_Strtotable(aStr, ';');
     if #QData ~= 3 then return end;
     local Qtype = tonumber(QData[1]) or 0;
     local Qname = QData[2] or '';
     local Qcount = tonumber(QData[3]) or 0;
	 --判断条件
	 if Qtype == 1 then
       --检测道具
       if P_getitemcount(uSource, Qname) < Qcount then 
         P_MenuSay(uSource, string.format('你还没有收集到%d个%s!!', Qcount, Qname));
        return;
       end;
	 elseif Qtype == 2 then
	   --检测杀怪数量
	   if P_GetTempArr(uSource, 5) < Qcount then
         P_MenuSay(uSource, string.format('你还没有击杀%d个%s!!', Qcount, Qname));
        return;
       end;
	 else
        return;
	 end;
    --判断主线任务状态
    local Index = P_GetTempArr(uSource, 4);
    if Index < 1 or Index > ZxQuest.Qmax then return end;
	 local space = 1;
	 if ZxQuest.QIndexItem[Index] ~= nil then 
	   space = space + 1;
	 end;
	 --判断背包
     if P_getitemspace(uSource) < space then
       P_MenuSay(uSource, '背包已满!!');
      return;
     end; 
     --写数据
     P_SetTempArr(uSource, 5, 0); --击杀数量	
     P_SetTempStr(uSource, 5, ''); --任务内容	
	 --扣除物品或者清空临时记录
	 if Qtype == 1 then 
	   P_deleteitem(uSource, Qname, Qcount, '主线任务');
	 end;
	 --[[给予奖励
     local ItemTab = ZxQuest.Qitem[#ZxQuest.Qitem];
     if ItemTab == nil then 
       P_MenuSay(uSource, '完成失败,请联系管理员');
	   return;		
     end;]]
	 --随机获取东西table
      local AwardItem = {};
      AwardItem = DayQitem[math.random(#(DayQitem))];
      if AwardItem == nil then
       return;
      end;
     --给予道具	
     local _num = math.random(AwardItem[2], AwardItem[3]);
     --P_additem(uSource, ItemTab[1], _num, '主线任务');
	 P_additem(uSource, AwardItem[1], _num, '主线任务');
	 --返回提示
	 local PlayName = B_GetRealName(uSource);
	 --P_MenuSay(uSource, string.format('恭喜,完成主线任务[%d],获得:%s*%d', Index, ItemTab[1], _num));
	 P_MenuSay(uSource, '恭喜你,完成了任务');
	 --发送全服公告
	 --M_worldnoticemsg(string.format('%s 完成主线任务,获得:%s*%d', PlayName, AwardItem[1], _num),  16777215, 3815994);
	 --M_worldnoticemsg(string.format('玩家['..B_GetRealName(uSource)..']完成主线获得:'..AwardItem[1]..':'..AwardItem[2]..'个'), 16365858);
	 --固定次数道具
	 if ZxQuest.QIndexItem[Index] ~= nil then 
       P_additem(uSource, ZxQuest.QIndexItem[Index][1], ZxQuest.QIndexItem[Index][2], '主线任务');
	   M_worldnoticemsg(string.format('%s 获取主线任务次数额外奖励:%d*%d', PlayName, ZxQuest.QIndexItem[Index][2], ZxQuest.QIndexItem[Index][1]),  16777215, 3815994);
	 end;
	 --判断是否全部完成
	 if Index >= ZxQuest.Qmax then 
       P_SetTempArr(uSource, 4, 0); --击杀数量	
       P_MenuSay(uSource, '恭喜,完成本轮全部任务');
	   return;		
     end;
	 --删除标识任务引导
	 P_DelQuestInfo(uSource, 2, 0);
     P_SetEventTick(uSource, 14, 100);
	 --删除任务状态
	 ZxQuest.Deltempa(uSource);
	 --取副本次数
       local cishu = tonumber(M_GetSdbInfo(_vip_sdb, Name, '任务次数'));
	   --随机获取东西table
      local AwardItemb = {};
      AwardItemb = Randomitem[math.random(#Randomitem)];
      if AwardItemb == nil then
       return;
      end;
	  if cishu >= 5 then
      --给予物品
       P_additem(uSource, AwardItemb[1], AwardItemb[2], '主线任务');
	   P_additem(uSource, '新手汤药', 500, '主线任务');
	   P_additem(uSource, '新手生药', 500, '主线任务');
      end;
    return;
  end;	

 return;
end