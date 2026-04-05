package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local ItemTab = {
  ['二层拳法秘籍'] = {
    {'无影疾风脚', 1},
    {'暴风连环拳', 1},
    {'太极八卦拳', 1},
    {'狂破拳', 1},
    {'百步神拳', 1},
    {'如来天王拳', 1},
  },
  ['二层剑法秘籍'] = {
    {'日光剑法', 1},
    {'擎剑术', 1},
    {'霸王剑式', 1},
    {'昊天风云剑法', 1},
    {'天马行云剑法', 1},
    {'飞龙剑法', 1},
  },	
  ['二层刀法秘籍'] = {
    {'天王刀诀', 1},
    {'十字闪光刀诀', 1},
    {'苍狼破月刀法', 1},
    {'风云式', 1},
    {'九龙刀法', 1},
    {'花郎斩', 1},
  },
  ['二层枪法秘籍'] = {
    {'卧龙式', 1},
    {'潜龙大飞式', 1},
    {'雷电枪法', 1},
    {'五虎风魔棍', 1},
    {'玉女枪法', 1},
    {'岳家枪法', 1},
  },
  ['二层槌法秘籍'] = {
    {'五轮槌法', 1},
    {'牛俊槌法', 1},
    {'乾坤无敌槌', 1},
    {'风林火山槌法', 1},
    {'北冥槌法', 1},
    {'帝王槌法', 1},
  },
};

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
   --检测道具
        if P_getitemcount(uSource, '钱币') < 100000 then
	  P_saysystem (uSource, '需要[钱币:100000]才能开启',2);
         return;
        end;
   --检测背包空位
   if P_getitemspace(uSource) < #ItemTab[ItemData.Name] then
      P_saysystem(uSource, string.format('请保留%d个物品栏空位', #ItemTab[ItemData.Name]), 2);
    return;
   end;  
    --获取随机道具
   math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
   math.random();math.random();math.random();
   local _tmp = ItemTab[ItemData.Name][math.random(#ItemTab[ItemData.Name])];
    --给予道具
   P_additem(uSource, _tmp[1], _tmp[2], ItemData.Name);
   --删除道具
   P_deleteitem(uSource, ItemData.Name, 1, ItemData.Name);
   P_deleteitem(uSource, '钱币', 100000, '二层秘籍');
   --返回消息
   P_saysystem(uSource, string.format('开启【%s】获得了【%s】', ItemData.Name, _tmp[1]), 2);
   M_topmsg(string.format('[%s]开启[%s]获得了[%s]', B_GetRealName(uSource), ItemData.Name, _tmp[1]), 16746496);
 return;
end