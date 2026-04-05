package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local ItemTab = {
  ['一层拳法秘籍'] = {
    {'无影脚', 1},
    {'旋风脚', 1},
    {'太极拳', 1},
    {'骨架击', 1},
    {'少林长拳', 1},
    {'如来金刚拳', 1},
  },
  ['一层剑法秘籍'] = {
    {'雷剑式', 1},
    {'太极剑结', 1},
    {'壁射剑法', 1},
    {'圣灵21剑', 1},
	{'北马剑法', 1},
    {'闪光剑破解', 1},
  },
  ['一层刀法秘籍'] = {
    {'断刀法', 1},
    {'神古土', 1},
    {'半月式', 1},
    {'长枪刀法', 1},
    {'应龙大天神', 1},
    {'花郎徒结', 1},
  },
  ['一层枪法秘籍'] = {
    {'火龙升天术', 1},
    {'飞月枪法', 1},
    {'达摩枪法', 1},
    {'打狗棒法', 1},
    {'点枪术', 1},
    {'杨家枪法', 1},
  },
  ['一层槌法秘籍'] = {
    {'回转狂天飞', 1},
    {'地狱大血式', 1},
    {'跃人千墙', 1},
    {'龙王槌法', 1},
    {'闪光槌法', 1},
	{'无击阵', 1},
  },
  ['心法秘籍'] = {
    {'伏式气功', 1},
    {'爆发呼吸', 1},
    {'易筋经', 1},
    {'太极气功', 1},
    {'雷电气功', 1},
    {'吐纳法', 1},
  },
  ['步法秘籍'] = {
    {'弓身', 1},
    {'归归步法', 1},
    {'灵空虚徒', 1},
    {'徒步飞', 1},
    {'草上飞', 1},
    {'陆地飞行术', 1},
  },
  ['护体秘籍'] = {
    {'铁头功', 1},
    {'龟甲体', 1},
    {'金刚不坏', 1},
    {'大铁人', 1},
    {'雾水掌', 1},
    {'黑沙刚体', 1},
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
        if P_getitemcount(uSource, '钱币') < 10000 then
	  P_saysystem (uSource, '需要[钱币:10000]才能开启',2);
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
   P_deleteitem(uSource, '钱币', 10000, '一层秘籍');
   --返回消息
   P_saysystem(uSource, string.format('开启【%s】获得了【%s】', ItemData.Name, _tmp[1]), 2);
   M_topmsg(string.format('[%s]开启[%s]获得了[%s]', B_GetRealName(uSource), ItemData.Name, _tmp[1]), 16746496);
 return;
end