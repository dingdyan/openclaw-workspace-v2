package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Item_Name = '百炼礼包';

local ItemTab1 = {
      {'男子百炼雨中客道袍', 1},
      {'男子百炼雨中客斗笠', 1},
};

local ItemTab2 = {
      {'男子百炼雨中客道袍', 1},
      {'男子百炼雨中客斗笠', 1},
};



function OnItemDblClick(uSource, uItemKey, astr)

    if not P_BoFreedom(uSource) then 
	  P_saysystem(uSource, '请先关闭其他窗口', 2);
      return;
    end
    --检测道具数量
    if P_getitemcount(uSource, Item_Name) < 1 then 
	  P_saysystem(uSource, '没有'..Item_Name, 2);
      return;
    end

    if P_getitemspace(uSource) < 1 then
	 P_saysystem(uSource, '请保留1个物品栏空位', 2);
     return;
    end; 
 
  --给予道具

   local sex = P_getsex(uSource);
   if sex == 1 then

     for i, v in pairs(ItemTab1) do
       if type(v) == 'table' then
           P_additem(uSource, v[1], v[2], Item_Name);
       end
     end;
      P_deleteitem(uSource, Item_Name, 1, Item_Name);
      P_saysystem(uSource, '成功获得'..Item_Name..'道具!', 2);
      --M_worldnoticemsg(string.format('系统公告: 恭喜'..B_GetRealName(uSource)..'开启'..Item_Name..'获得奖励'), 255);
     return;
   end; 

     for i, v in pairs(ItemTab2) do
       if type(v) == 'table' then
           P_additem(uSource, v[1], v[2], Item_Name);
       end
     end;
      P_deleteitem(uSource, Item_Name, 1, Item_Name);
      P_saysystem(uSource, '成功获得'..Item_Name..'道具!', 2);
      --M_worldnoticemsg(string.format('系统公告: 恭喜'..B_GetRealName(uSource)..'开启'..Item_Name..'获得奖励'), 255);
end