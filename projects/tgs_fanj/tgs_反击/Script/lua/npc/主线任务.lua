package.loaded['Script\\lua\\f'] = nil;
package.loaded['Script\\lua\\任务\\主线任务'] = nil;
package.loaded['Script\\lua\\任务\\日常任务'] = nil;

require ('Script\\lua\\f');
require ('Script\\lua\\任务\\主线任务');
require ('Script\\lua\\任务\\日常任务');

local Npc_Name = '江湖至尊';

local MainMenu =
[[
有何事?^

<『$00FFFF00| 领取 平定任务』/@lqrc>^
<『$00FFFF00| 完成 平定任务』/@wcrc>^
<『$00FFFF00| 快速完成平定任务(20元宝)』/@kswcrc>^
]];

local FQMenu =
[[
需要放弃本次主线任务吗?^
『$0080FF80|注意:放弃需要钱币2000』^
<『$00FFFF00| 确认放弃』/@qrfqrw>^
<『$00FFFF00| 返回』/@fanhui>^
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
  --领取 平定任务
  if aStr == 'lqrc' then
     --获取当前日期
     local CurrentDate = os.date("%Y-%m-%d");
	 --获取玩家日期;次数
	 local aStr = P_GetTempStr(uSource, 11);
	 local QData = lua_Strtotable(aStr, ';');
	 local QDate = QData[1] or '';
	 local QNum = tonumber(QData[2]) or 0;
	 local QState = P_GetTempArr(uSource, 11);
	 --日期不一样重置状态
	 if QDate ~= CurrentDate then
		QState = 0;
		QNum = 0;
     end;
     --检测状态是否为0
     if QState ~= 0 then 
       P_MenuSay(uSource, '领取失败,当前有未完成的任务!');
      return;	
     end;	
     --检测次数是否已经做完	
     local viplevel, viptime = P_GetVipInfo(uSource);
     if QNum >= DayQuest.Qmax[viplevel] then 	
       P_MenuSay(uSource, string.format('领取失败,今日您已完成了%d次任务!', DayQuest.Qmax[viplevel]));
      return;	
     end;	
	 --分配任务
	 local QLevel = 1;
	 --获取玩家基本属性
	 local Attrib = P_GetAttrib(uSource);
	 if Attrib.Age >= 3000 then 
       QLevel = 2;
	 end;
	 --获取任务table
	 local QTable = DayQuest.Qday[QLevel];
     if QTable == nil then 
       P_MenuSay(uSource, '当前无法领取平定任务!');
      return;
     end;
	 local t = QTable[math.random(#QTable)];
     local Qtype = t[1];
     local Qname = t[2];
     local Qcount = math.random(t[3], t[4]);
     --写入数据
	 P_SetTempStr(uSource, 11, CurrentDate .. ';' .. QNum + 1);
	 P_SetTempStr(uSource, 12, Qtype .. ';' .. Qname .. ';' .. Qcount);
	 --返回提示
	 local queststr = '';
	 if Qtype == 1 then 
	   queststr = string.format('%s收集道具 [%d个%s]', queststr, Qcount, Qname);
	 elseif Qtype == 2 then
	   local xy = DayQuest.Monster[Qname];
	   if xy ~= nil then 
	     queststr = string.format('%s击杀 %d个『$FF00ff00|[%s:%d_%d]』', queststr, Qcount, Qname, xy[1], xy[2]);
	   else
	     queststr = string.format('%s击杀 %d个%s', queststr, Qcount, Qname);
	   end;
	 end;	
	 --记录平定任务临时变量
	 P_SetTempArr(uSource, 11, 1); --状态	
	 P_SetTempArr(uSource, 12, 0); --击杀数量
     --返回提示
     P_MenuSay(uSource, string.format('领取到了新的平定任务:^^%s^', queststr));	
     --发送任务提示
     local questInfo = string.format('%s<%s>?<%s>', '平定任务', queststr, '平定任务');
     P_SendQuestInfo(uSource, 3, 0, '平定任务', questInfo, false, true);
	 --重置状态
	 P_SetEventTick(uSource, 15, 100);
    return;
  end;	

  if aStr == 'wcrc' then
	 local QState = P_GetTempArr(uSource, 11);	
     --检测状态是否为1
     if QState ~= 1 then 
       P_MenuSay(uSource, '任务已完成,请重新领取!');
      return;	
     end;
     --获取当前日期
     local CurrentDate = os.date("%Y-%m-%d");
	 --获取玩家日期;次数
	 local aStr = P_GetTempStr(uSource, 11);
	 local QData = lua_Strtotable(aStr, ';');
	 local QDate = QData[1] or '';
	 local QNum = tonumber(QData[2]) or 0;
	 local QState = P_GetTempArr(uSource, 11);
	 --判断日期
	 if QDate ~= CurrentDate then
       P_MenuSay(uSource, '任务已过期,请重新领取!');
	  return;
     end;
     --获取任务信息
     local aStr = P_GetTempStr(uSource, 12); 
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
	   if P_GetTempArr(uSource, 12) < Qcount then
         P_MenuSay(uSource, string.format('你还没有击杀%d个%s!!', Qcount, Qname));
        return;
       end;
	 else
        return;
	 end;
	 --判断背包
     if P_getitemspace(uSource) < 1 then
       P_MenuSay(uSource, '背包已满!!');
      return;
     end; 
     --写数据
     P_SetTempArr(uSource, 11, 0); --状态	
     P_SetTempArr(uSource, 12, 0); --击杀数量	
     P_SetTempStr(uSource, 12, ''); --任务内容	
	 --扣除物品或者清空临时记录
	 if Qtype == 1 then 
	   P_deleteitem(uSource, Qname, Qcount, '平定任务');
	 end;
	 --分配任务
	 local QLevel = 1;
	 --获取玩家基本属性
	 local Attrib = P_GetAttrib(uSource);
	 if Attrib.Age >= 3000 then 
       QLevel = 2;
	 end;
	 --随机给道具
	 local s = '';
	 for k,v in ipairs(DayQuest.Qitem[QLevel]) do
      if type(v) == 'table' then
	    local _num = math.random(v[2], v[3]);
        P_additem(uSource, v[1], _num, '平定任务');
		s = string.format('%s[%s*%d]', s, v[1], _num);
      end
	 end;
	 --返回提示
	 local PlayName = B_GetRealName(uSource);
	 P_MenuSay(uSource, string.format('恭喜,完成平定任务[%d次],获得:%s', QNum, s));
	 --发送全服公告
	 M_worldnoticemsg(string.format('%s 完成平定任务[%d次],获得:%s', PlayName, QNum, s),  16777215, 3815994);
	 --删除标识任务引导
	 P_DelQuestInfo(uSource, 3, 0);
    -- P_SetEventTick(uSource, 14, 100);
    return;
  end;	


  if aStr == 'kswcrc' then
	 local QState = P_GetTempArr(uSource, 11);	
     --检测状态是否为1
     if QState ~= 1 then 
       P_MenuSay(uSource, '任务已完成,请重新领取!');
      return;	
     end;
     --获取当前日期
     local CurrentDate = os.date("%Y-%m-%d");
	 --获取玩家日期;次数
	 local aStr = P_GetTempStr(uSource, 11);
	 local QData = lua_Strtotable(aStr, ';');
	 local QDate = QData[1] or '';
	 local QNum = tonumber(QData[2]) or 0;
	 local QState = P_GetTempArr(uSource, 11);
	 --判断日期
	 if QDate ~= CurrentDate then
       P_MenuSay(uSource, '任务已过期,请重新领取!');
	  return;
     end;
     --获取任务信息
     local aStr = P_GetTempStr(uSource, 12); 
     local QData = lua_Strtotable(aStr, ';');
     if #QData ~= 3 then return end;
     local Qtype = tonumber(QData[1]) or 0;
     local Qname = QData[2] or '';
     local Qcount = tonumber(QData[3]) or 0;
	 --判断条件
	 local DianJuan = P_GetMysqlDianJuan(uSource);
	 if DianJuan < 20 then 
       P_MenuSay(uSource, '没有20元宝');
	  return;
     end;
     local viplevel, viptime = P_GetVipInfo(uSource);
	 local space = 1;
	 if viplevel == 2 and QNum == 10 then 
	   space = space + 1;
	 elseif viplevel == 1 and QNum == 6 then 
	   space = space + 1;
	 end;
	 --判断背包
     if P_getitemspace(uSource) < space then
       P_MenuSay(uSource, '背包已满!!');
      return;
     end; 
     --写数据
     P_SetTempArr(uSource, 11, 0); --状态	
     P_SetTempArr(uSource, 12, 0); --击杀数量	
     P_SetTempStr(uSource, 12, ''); --任务内容	
	 --删除元宝
	 P_SetMysqlDianJuan(uSource, DianJuan - 20);
	 --分配任务
	 local QLevel = 1;
	 --获取玩家基本属性
	 local Attrib = P_GetAttrib(uSource);
	 if Attrib.Age >= 3000 then 
       QLevel = 2;
	 end;
	 --随机给道具
	 local s = '';
	 for k,v in ipairs(DayQuest.Qitem[QLevel]) do
      if type(v) == 'table' then
	    local _num = math.random(v[2], v[3]);
        P_additem(uSource, v[1], _num, '平定任务');
		s = string.format('%s[%s*%d]', s, v[1], _num);
      end
	 end;
	 --返回提示
	 local PlayName = B_GetRealName(uSource);
	 P_MenuSay(uSource, string.format('恭喜,完成平定任务[%d次],获得:%s', QNum, s));
	 --发送全服公告
	 M_worldnoticemsg(string.format('%s 完成平定任务[%d次],获得:%s', PlayName, QNum, s),  16777215, 3815994);
	 --删除标识任务引导
	 P_DelQuestInfo(uSource, 3, 0);
     --P_SetEventTick(uSource, 14, 100);
    return;
  end;	
  
  --放弃任务
  if aStr == 'fqrw' then
    P_MenuSay(uSource, FQMenu);
   return;
  end;
  
  if aStr == 'qrfqrw' then
    --检测状态
    if P_GetTempStr(uSource, 5) == '' then 
      P_MenuSay(uSource, '没有接取任务!');
      return;	
    end;
    --检测道具
    if P_getitemcount(uSource, '钱币') < 2000 then 
      P_MenuSay(uSource, '没有2000个钱币');
      return;
    end;
    P_deleteitem(uSource, '钱币', 2000, '主线任务');
    P_SetTempStr(uSource, 5, ''); --写入数据	
	--删除标识任务引导
	P_DelQuestInfo(uSource, 2, 0);
    --P_SetEventTick(uSource, 14, 100);
	--提示
    P_MenuSay(uSource, '已放弃本次任务');
  end;

  --领取任务
  if aStr == 'lqxk' then
     --检测状态
     if P_GetTempStr(uSource, 5) ~= '' then 
       P_MenuSay(uSource, '领取失败,当前有未完成的任务!');
      return;	
     end;
     --判断境界
	 if P_GetEnergyLevel(uSource) < 7 then
       P_MenuSay(uSource, '神话境可领取主线任务');
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
     --返回提示
     P_MenuSay(uSource, string.format('领取到了新的主线任务:^^%s^', queststr));	
     --发送任务提示
     local questInfo = string.format('%s<%s>?<%s>', '主线任务', queststr, '主线任务');
     P_SendQuestInfo(uSource, 2, 0, string.format('主线任务[%d]', Index), questInfo, false, true);
	 --重置状态
     P_SetEventTick(uSource, 14, 100);
    return;
  end;	

  if aStr == 'wcxk' then
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
	 --给予奖励
     local ItemTab = ZxQuest.Qitem[#ZxQuest.Qitem];
     if ItemTab == nil then 
       P_MenuSay(uSource, '完成失败,请联系管理员');
	   return;		
     end;
     --给予道具	
     local _num = math.random(ItemTab[2], ItemTab[3]);
     P_additem(uSource, ItemTab[1], _num, '主线任务');
	 --返回提示
	 local PlayName = B_GetRealName(uSource);
	 P_MenuSay(uSource, string.format('恭喜,完成主线任务[%d],获得:%s*%d', Index, ItemTab[1], _num));
	 --发送全服公告
	 M_worldnoticemsg(string.format('%s 完成主线任务[%d],获得:%s*%d', PlayName, Index, ItemTab[1], _num),  16777215, 3815994);
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
     --P_SetEventTick(uSource, 14, 100);
    return;
  end;	

 return;
end