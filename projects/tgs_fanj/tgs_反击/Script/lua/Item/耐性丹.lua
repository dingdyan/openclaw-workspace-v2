local exp = 5426000;

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --检测道具数量
   if P_getitemcount(uSource, '耐性丹') < 1 then 
	 P_saysystem(uSource, '没有耐性丹', 2);
     return;
   end
   --增加浩然
   P_UpAdaptiveExp(uSource, exp);
   --删除道具
   P_deleteitem(uSource, '耐性丹', 1, '耐性丹');
   --返回消息
   P_saysystem(uSource, '服用成功,显示可能会有延迟,请稍后查看!', 2);
 return;
end