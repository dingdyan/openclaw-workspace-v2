package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --检测道具数量
   local zq = P_getitemcount(uSource, '真气珠');
   if zq < 1 then 
	 P_saysystem(uSource, '最少1个真气珠才可兑换真气', 2);
     return;
   end
   --增加真气
   P_SetAddableStatePoint(uSource, P_GetAddableStatePoint(uSource) + zq * 1);	
   --删除道具
   P_deleteitem(uSource, '真气珠', zq, '真气珠');
   --返回消息
   P_saysystem(uSource, string.format('兑换了%d个真气珠,增加真气: %d', zq, zq * 1), 2);
 return;
end