local ItemTab = {
  ['VIP点数1'] = 1,
  ['VIP点数5'] = 5,
  ['VIP点数10'] = 10,
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
   --增加打出的VIP点数
   local num = P_GetTempArr(uSource, 15);
   num = num + ItemTab[ItemData.Name];
   P_SetTempArr(uSource, 15, num);
   local Money = P_GetTempArr(uSource, 18);
   --删除道具
   P_deleteitem(uSource, ItemData.Name, 1, 'VIP点数');
   P_saysystem(uSource, string.format('%s 使用成功,增加VIP点数:%d,当前VIP点数:%d', ItemData.ViewName, ItemTab[ItemData.Name], num + Money), 2);
 return;
end