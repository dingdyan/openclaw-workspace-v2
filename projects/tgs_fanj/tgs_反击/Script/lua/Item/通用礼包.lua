local ItemTab = {
  ['一层新武学礼包'] = {
    {'铁线拳法', 1, 0},
    {'华山剑法', 1, 0},
    {'乾坤刀法', 1, 0},
    {'血魔枪法', 1, 0},
    {'刑天槌法', 1, 0},
    {'血轮回', 1, 0},
    {'连环弓术', 1, 0},
  },
  ['二层新武学礼包'] = {
    {'武圣拳法', 1, 0},
    {'独孤剑法', 1, 0},
    {'修罗刀法', 1, 0},
    {'天魔枪法', 1, 0},
    {'盘古槌法', 1, 0},
    {'血滴子', 1, 0},
    {'后羿弓法', 1, 0},
  },
  ['新掌风礼包'] = {
    {'天音掌', 1, 0},
    {'怒雷掌', 1, 0},
    {'封天掌', 1, 0},
    {'生死掌', 1, 0},
    {'残云掌', 1, 0},
    {'烈阳掌', 1, 0},
  },
  ['二层护体礼包'] = {
    {'僵尸功', 1, 0},
    {'黄土大力体', 1, 0},
    {'气甲体', 1, 0},
    {'金结', 1, 0},
    {'回转圆型障', 1, 0},
    {'不灭体', 1, 0},
  },
  ['二层心法礼包'] = {
    {'活人心法', 1, 0},
    {'混元气功', 1, 0},
    {'功力澎胀术', 1, 0},
  },
  ['首充礼包'] = {
    {'半月掌', 1, 0},
    {'韦陀掌', 1, 0},
    {'霹雳掌', 1, 0},
    {'铁砂掌', 1, 0},
    {'火焰掌', 1, 0},
    {'寒冰掌', 1, 0},
    {'小丸丹', 3000, 0},
    {'金元', 300, 0},
    {'男子妖华袍', 1, 4, true},
    {'男子利齿靴', 1, 4, true},
    {'驱魔烈火弓', 1, 4},
    {'四季甲胄', 1, 4},
    {'炎帝火灵斧', 1, 4},
    {'狼牙戟', 1, 4},
    {'月光刀', 1, 4},
    {'龙光剑', 1, 4},
    {'狐狸手套', 1, 4},
  },
    ['一层武功礼包'] = {
    {'无影脚', 1, 0},
    {'旋风脚', 1, 0},
    {'太极拳', 1, 0},
    {'骨架击', 1, 0},
    {'少林长拳', 1, 0},
    {'如来金刚拳', 1, 0},
    {'雷剑式', 1, 0},
    {'太极剑结', 1, 0},
    {'壁射剑法', 1, 0},
    {'圣灵21剑', 1, 0},
    {'北马剑法', 1, 0},
    {'闪光剑破解', 1, 0},
    {'断刀法', 1, 0},
    {'神古土', 1, 0},
    {'半月式', 1, 0},
    {'长枪刀法', 1, 0},
    {'应龙大天神', 1, 0},
    {'花郎徒结', 1, 0},
    {'火龙升天术', 1, 0},
    {'飞月枪法', 1, 0},
    {'达摩枪法', 1, 0},
    {'打狗棒法', 1, 0},
    {'点枪术', 1, 0},
    {'杨家枪法', 1, 0},
    {'回转狂天飞', 1, 0},
    {'地狱大血式', 1, 0},
    {'跃人千墙', 1, 0},
    {'龙王槌法', 1, 0},
    {'闪光槌法', 1, 0},
    {'无击阵', 1, 0},
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
	 P_saysystem(uSource, '你没有这个道具', 2);
     return;
   end
   --获取道具table
   local t = ItemTab[ItemData.Name];
   if t == nil then
     P_saysystem(uSource, '礼包没有可领取道具....', 2);
    return;
   end;		
   --检测背包空位
   if P_getitemspace(uSource) < #t then
     P_saysystem(uSource, string.format('请保留%d个物品栏空位', #t), 2);
    return;
   end;  
   --给予道具
   for i, v in pairs(t) do
     if type(v) == 'table' then
       if v[1] == '天赋经验' then 
         P_SetnewTalentExp(uSource, P_GetnewTalentExp(uSource) + v[2]);
         P_LeftText(uSource, string.format('天赋经验 获得 %d 个', v[2]), 55769, 3);
       elseif v[1] == '钱币1' then 
         P_AddBindMoney(uSource, v[2]);
         P_LeftText(uSource, string.format('绑定钱币 获得 %d 个', v[2]), 55769, 3);
       else
	     local ItemName = v[1];
	     if v[4] ~= nil and P_getsex(uSource) == 2 then 
	       ItemName = string.gsub(ItemName, '男子', '女子');
	     end;
         P_addItemUpgrade(uSource, ItemName, v[2], v[3], ItemData.Name);
       end
     end
   end;
   --删除道具
   P_deleteitem(uSource, ItemData.Name, 1, ItemData.Name);
   --返回消息
   P_saysystem(uSource, '成功获得礼包道具', 14);
 return;
end