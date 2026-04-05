local _exp = {
  ['年龄药水'] = 3600 * 24,
  ['年龄药水1'] = 3600 * 24,
}; 


function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --获取KEY道具
   local ItemData = P_GetHaveItemInfoTabs(uSource, uItemKey);
   if ItemData == nil or ItemData.Name == nil or _exp[ItemData.Name] == nil then
     return;
   end;
   --检测道具数量
   if P_getitemcount(uSource, ItemData.Name) < 1 then 
	 P_saysystem(uSource, '你没有这个道具', 2);
     return;
   end
   --增加年龄
   P_UpAgeExp(uSource, _exp[ItemData.Name]);
   --删除道具
   P_deleteitem(uSource, ItemData.Name, 1, '年龄药水');
   --返回消息
   P_saysystem(uSource, '服用成功,显示可能会有延迟,请稍后查看!', 2);
 return;
end