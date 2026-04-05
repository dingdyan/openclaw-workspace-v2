package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local ItemTab = {
  ['推广礼包'] = {
    {'黄金VIP', 1},
  },
  ['小推广礼包'] = {
    {'新手生药', 500},
    {'新手汤药', 500},
    {'新手丸药', 500},
    {'新手丹药', 500},
  },
  ['大推广礼包'] = {
    {'新手生药', 1000},
    {'新手汤药', 1000},
    {'新手丸药', 1000},
    {'新手丹药', 1000},
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
   local t = ItemTab[ItemData.Name];
   --检测背包空位
   if P_getitemspace(uSource) < #t then
     P_saysystem(uSource, string.format('请保留%d个物品栏空位', #t), 2);
    return;
   end;  
   --给予道具
   for i, v in pairs(t) do
     if type(v) == 'table' then
       P_additem(uSource, v[1], v[2], ItemData.Name);
     end
   end;
   --删除道具
   P_deleteitem(uSource, ItemData.Name, 1, ItemData.Name);
   --返回消息
   P_saysystem(uSource, string.format('开启了【%s】', ItemData.Name), 2);
 return;
end