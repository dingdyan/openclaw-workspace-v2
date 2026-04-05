local exp = 55800000;

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --检测道具数量
   if P_getitemcount(uSource, '浩然丹') < 1 then 
	 P_saysystem(uSource, '没有浩然丹', 2);
     return;
   end
   --增加浩然
   P_UpVirtueExp(uSource, exp);
   --删除道具
   P_deleteitem(uSource, '浩然丹', 1, '浩然丹');
   --返回消息
   P_saysystem(uSource, '服用成功,显示可能会有延迟,请稍后查看!', 2);
	--全服公告
	--M_worldnoticesysmsg(string.format('恭喜[%s]服用了[浩然丹],领取微信开区礼包可获得[浩然丹]', B_GetRealName(uSource)), 18);
 return;
end