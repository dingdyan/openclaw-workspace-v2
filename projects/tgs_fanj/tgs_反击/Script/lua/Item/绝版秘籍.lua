package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local ItemTab = {  
    ['绝版秘籍'] = {
    {'噬魂枪', 1, 1, 0},
    {'金钟罩', 1, 1, 0},
    {'血轮回', 1, 1, 0},
    {'天地人拳', 1, 1, 0},
    {'血手印', 1, 1, 0},
    {'蚀骨掌', 1, 1, 0},
	{'五行拳', 1, 1, 0},
    {'鬼鸣枪', 1, 1, 0},
    {'血滴子', 1, 1, 0},
	{'幻魔身法', 1, 1, 0},
  }, 
};

--兑换 作弊
local dh_zuobi = {
  [531] = {'噬魂枪', 1, 1}, 
  [532] = {'金钟罩', 1, 1}, 
  [533] = {'血轮回', 1, 1}, 
  [534] = {'天地人拳', 1, 1}, 
  [535] = {'血手印', 1, 1}, 
  [536] = {'蚀骨掌', 1, 1}, 
  [537] = {'五行拳', 1, 1}, 
  [538] = {'鬼鸣枪', 1, 1}, 
  [539] = {'血滴子', 1, 1}, 
  [540] = {'罗汉体', 1, 1}, 
  [541] = {'幻魔身法', 1, 1},
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
        if P_getitemcount(uSource, '钱币') < 200000 then
	  P_saysystem (uSource, '需要[钱币:200000]才能开启',2);
         return;
        end;
   --检测背包空位
   if P_getitemspace(uSource) < 1 then
     P_saysystem(uSource, '物品栏已满', 2);
    return;
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
   --给予道具
   P_additem(uSource, _tmp[1], _num, ItemData.Name);
   --删除道具
   P_deleteitem(uSource, ItemData.Name, 1, ItemData.Name);
   P_deleteitem(uSource, '钱币', 200000, '绝版秘籍');
   --返回消息
   --M_topmsg(string.format('%s 开启[%s]获得了[%d个%s]', B_GetRealName(uSource),ItemData.Name, _num, _tmp[1]), 16746496);
   --公告
   --if _tmp[4] ~= 0 then 
     M_topmsg(string.format('%s 开启[%s]获得了[%d个%s]', B_GetRealName(uSource), ItemData.Name, _num, _tmp[1]), 16746496);
   --end;
 return;
end