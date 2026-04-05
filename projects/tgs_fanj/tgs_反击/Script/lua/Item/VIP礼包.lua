--[[
     VIP金额设计
 　 【vip1】30元
　　【vip2】100元
　　【vip3】300元
　　【vip4】800元
　　【vip5】1500元
　　【vip6】3000元
　　【vip7】5000元
　　【vip8】8000元
　　【vip9】12000元
]]

local ItemTab = {
  ['1级VIP礼包'] = {
    {'金元', 100},
    {'年龄药水', 1},
    {'小丸丹1', 100},
  },
  ['2级VIP礼包'] = {
    {'金元', 200},
    {'年龄药水', 2},
    {'小丸丹1', 200},
    {'大丸丹(绑定)', 1},
    {'龍魂碎片', 10},
    {'战魂碎片', 10},
    {'武魂功勋', 10},
  },
  ['3级VIP礼包'] = {
    {'金元', 400},
    {'年龄药水', 4},
    {'小丸丹1', 400},
    {'大丸丹(绑定)', 2},
    {'龍魂碎片', 20},
    {'战魂碎片', 20},
    {'武魂功勋', 20},
  },
  ['4级VIP礼包'] = {
    {'金元', 800},
    {'年龄药水', 6},
    {'小丸丹1', 600},
    {'大丸丹(绑定)', 3},
    {'龍魂碎片', 40},
    {'战魂碎片', 40},
    {'武魂功勋', 40},
  },
  ['5级VIP礼包'] = {
    {'金元', 1400},
    {'年龄药水', 8},
    {'小丸丹1', 800},
    {'大丸丹(绑定)', 4},
    {'龍魂碎片', 80},
    {'战魂碎片', 80},
    {'武魂功勋', 80},
  },
  ['6级VIP礼包'] = {
    {'金元', 2200},
    {'年龄药水', 10},
    {'小丸丹1', 1000},
    {'千年山参(绑定)', 1},
    {'龍魂碎片', 140},
    {'战魂碎片', 140},
    {'武魂功勋', 140},
  },
  ['7级VIP礼包'] = {
    {'金元', 3200},
    {'年龄药水', 12},
    {'小丸丹1', 1200},
    {'千年山参(绑定)', 2},
    {'龍魂碎片', 220},
    {'战魂碎片', 220},
    {'武魂功勋', 220},
  },
  ['8级VIP礼包'] = {
    {'金元', 4400},
    {'年龄药水', 14},
    {'小丸丹1', 1400},
    {'千年山参(绑定)', 3},
    {'龍魂碎片', 320},
    {'战魂碎片', 320},
    {'武魂功勋', 320},
  },
  ['9级VIP礼包'] = {
    {'金元', 6000},
    {'年龄药水', 16},
    {'小丸丹1', 1600},
    {'千年山参(绑定)', 4},
    {'龍魂碎片', 440},
    {'战魂碎片', 440},
    {'武魂功勋', 440},
  },
  ['10级VIP礼包'] = {
    {'金元', 8000},
    {'年龄药水', 20},
    {'小丸丹1', 2000},
    {'千年山参(绑定)', 6},
    {'龍魂碎片', 600},
    {'战魂碎片', 600},
    {'武魂功勋', 600},
  },
};

--获取任务奖励字符
function GetTableStr(aTable)
  local Str = '';
  local n = 0;
  for i, v in pairs(aTable) do
    if type(v) == 'table' then
      Str = string.format('%s[%s:%d] ', Str, v[1], v[2]);
      n = n + 1;
      if n % 4 == 0 then 
        Str = string.format('%s^', Str);
      end
    end
  end;
  return Str;
end;

function OnItemDblClick(uSource, uItemKey, astr)
  --获取KEY道具
  local ItemData = P_GetHaveItemInfoTabs(uSource, uItemKey);
  if ItemData == nil or ItemData.Name == nil or ItemTab[ItemData.Name] == nil then
   return;
  end;
  local str = string.format('开启%s可获得以下道具:^%s^^', ItemData.Name, GetTableStr(ItemTab[ItemData.Name]));
  str = string.format('%s<『$00FFFF00| ————【开启礼包】————』/@kq>', str);    
  P_MenuSayItem(uSource, str, Item_Name, uItemKey);
 return;
end

function OnGetResult(uSource, uItemKey, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'kq' then
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 17);
     return;
   end
   --获取KEY道具
   local ItemData = P_GetHaveItemInfoTabs(uSource, uItemKey);
   if ItemData == nil or ItemData.Name == nil or ItemTab[ItemData.Name] == nil then
     return;
   end;
   --检测道具数量
   if P_getitemcount(uSource, ItemData.Name) < 1 then 
	 P_saysystem(uSource, '你没有这个道具', 17);
     return;
   end
   --获取道具table
   local t = ItemTab[ItemData.Name];
   if t == nil then
     P_saysystem(uSource, '礼包没有可领取道具....', 17);
    return;
   end;
   --检测背包空位
   if P_getitemspace(uSource) < #t then
     P_saysystem(uSource, string.format('请保留%d个物品栏空位', #t), 17);
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
         P_additem(uSource, v[1], v[2], 'VIP礼包');
       end
     end
   end;
   --删除道具
   P_deleteitem(uSource, ItemData.Name, 1, 'VIP礼包');
   --返回消息
   P_saysystem(uSource, string.format('开启了 %s', ItemData.Name), 17);
   return;
  end;
 return;
end