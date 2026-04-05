package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local ItemTab = {
  ['招式礼包'] = {
    {'乾坤大挪移', 1, 1},
    {'混天气功', 1, 1},
    {'会心一击', 1, 1},
    {'兰花拂穴手', 1, 1},
    {'威震八方', 1, 1},
    {'雷镇四方', 1, 1},
    {'风扫落叶', 1, 1},
    {'吸星大法', 1, 1},
    {'吸魂夺魄', 1, 1},
    {'风满长空', 1, 1},
  },
  ['掌风礼包'] = {
    {'半月掌', 1, 1},
    {'韦陀掌', 1, 1},
    {'霹雳掌', 1, 1},
    {'铁砂掌', 1, 1},
    {'寒冰掌', 1, 1},
    {'火焰掌', 1, 1},
	
    {'天音掌', 1, 1},
    {'怒雷掌', 1, 1},
    {'生死掌', 1, 1},
    {'残云掌', 1, 1},
    {'封天掌', 1, 1},
    {'烈阳掌', 1, 1},
	
    {'半月掌', 1, 1},
    {'韦陀掌', 1, 1},
    {'霹雳掌', 1, 1},
    {'铁砂掌', 1, 1},
    {'寒冰掌', 1, 1},
    {'火焰掌', 1, 1},
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
   --检测背包空位
   if P_getitemspace(uSource) < 1 then
     P_saysystem(uSource, '物品栏已满', 2);
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
   --返回消息
   P_saysystem(uSource, string.format('开启【%s】获得了【%s】', ItemData.Name, _tmp[1]), 2);
   M_topmsg(string.format('%s 开启[%s]获得了[%s]', B_GetRealName(uSource), ItemData.Name, _tmp[1]), 16746496);
 return;
end