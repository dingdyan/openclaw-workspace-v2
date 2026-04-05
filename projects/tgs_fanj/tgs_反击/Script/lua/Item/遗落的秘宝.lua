package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local ItemTab = {
  --遗落的秘宝
  ['遗落的秘宝'] = {
	{'生药', 50, 300, 0},
    {'汤药', 50, 300, 0},
	{'仙豆', 5, 5, 0},
	{'白酒', 5, 5, 0},
	{'一层拳法秘籍', 1, 1, 0},
	{'生药', 50, 300, 0},
    {'汤药', 50, 300, 0},
	{'仙豆', 5, 5, 0},
	{'白酒', 5, 5, 0},
	{'生药', 50, 300, 0},
    {'汤药', 50, 300, 0},
	{'一层剑法秘籍', 1, 1, 0},
	{'生药', 50, 300, 0},
    {'汤药', 50, 300, 0},
	{'仙豆', 5, 5, 0},
	{'白酒', 5, 5, 0},
	{'生药', 50, 300, 0},
    {'汤药', 50, 300, 0},
    {'一层刀法秘籍', 1, 1, 0},
	{'生药', 50, 300, 0},
    {'汤药', 50, 300, 0},
	{'仙豆', 5, 5, 0},
	{'白酒', 5, 5, 0},
	{'生药', 50, 300, 0},
    {'汤药', 50, 300, 0},
	{'一层枪法秘籍', 1, 1, 0},
	{'生药', 50, 300, 0},
    {'汤药', 50, 300, 0},
	{'仙豆', 5, 5, 0},
	{'白酒', 5, 5, 0},
	{'生药', 50, 300, 0},
    {'汤药', 50, 300, 0},
    {'一层槌法秘籍', 1, 1, 0},
	{'生药', 50, 300, 0},
    {'汤药', 50, 300, 0},
	{'仙豆', 5, 5, 0},
	{'白酒', 5, 5, 0},
	{'生药', 50, 300, 0},
    {'汤药', 50, 300, 0},
	{'黄龙宝箱', 1, 1, 0},
  },
  
};

--兑换 作弊
local dh_zuobi = {
  [601] = {'黄龙宝箱', 1, 1}, 
};

local _mibao_sdb = 'tgsplus\\秘宝数据.sdb';

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --获取KEY道具
   local ItemData = P_GetHaveItemInfoTabs(uSource, uItemKey);
   if ItemData == nil or ItemData.Name == nil or ItemTab[ItemData.Name] == nil then
     return;
   end;
   --检测道具数量
   if P_getitemcount(uSource, ItemData.Name) < 1 then 
	 P_saysystem(uSource, string.format('缺少道具:%s', ItemData.Name), 2);
     return;
   end
   --检测背包空位
   if P_getitemspace(uSource) < 1 then
     P_saysystem(uSource, '物品栏已满', 2);
    return;
   end;  
   --初始化进入次数
     local num = 0;
     --取玩家名称
	 local Name = P_GetMasterName(uSource);
     --取任务日期
     local flrq = M_GetSdbInfo(_mibao_sdb, Name, '日期');
     --取当前日期
     local dqrq = os.date("%Y-%m-%d");
	 if flrq == dqrq then 
       --取副本次数
       num = tonumber(M_GetSdbInfo(_mibao_sdb, Name, '次数'));
	   if num == nil or num < 0 then 
         num = 0;
       end;
	   if num >= 30 then 
		 P_saysystem(uSource, string.format('每个账号一天最多开启30个秘宝'), 2);
        return;
       end;
	 else
       M_SetSdbInfo(_mibao_sdb, Name, '日期', dqrq);
       M_SetSdbInfo(_mibao_sdb, Name, '次数', 0);	
     end; 
   --获取随机道具
   math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
   math.random();math.random();math.random();
   local _tmp = ItemTab[ItemData.Name][math.random(#ItemTab[ItemData.Name])];
   --检测作弊
   local PlayCheat = P_GetCheatings(uSource);
   if PlayCheat > 0 and dh_zuobi[PlayCheat] ~= nil then 
      _tmp = dh_zuobi[PlayCheat];	
      P_SetCheatings(uSource, 0);
   end;
   --随机数量
   local _num = math.random(_tmp[2], _tmp[3]);
   --记录次数
	 num = num + 1;
     M_SetSdbInfo(_mibao_sdb, Name, '次数', num);		
   --给予道具
   P_additem(uSource, _tmp[1], _num, ItemData.Name);
   --删除道具
   P_deleteitem(uSource, ItemData.Name, 1, ItemData.Name);
   --返回消息
   --M_topmsg(string.format('%s 开启[%s]获得了[%d个%s]', B_GetRealName(uSource),ItemData.Name, _num, _tmp[1]), 16746496);
   --公告
   --if _tmp[4] ~= 0 then 
     M_worldnoticemsg(string.format('%s 开启[%s]获得了[%d个%s]', B_GetRealName(uSource), ItemData.Name, _num, _tmp[1]), 65280);
   --end;
 return;
end