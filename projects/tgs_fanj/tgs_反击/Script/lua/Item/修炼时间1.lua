package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --检测道具数量
   if P_getitemcount(uSource, '6小时修炼时间1') < 1 then 
	 P_saysystem(uSource, '没有6小时修炼时间1', 2);
     return;
   end
   local aTime = P_GetTempArr(uSource, 9) + 60 * 60 * 6 * 1;
   --增加修炼时间
   P_SetTempArr(uSource, 9, aTime);
   --删除道具
   P_deleteitem(uSource, '6小时修炼时间1', 1, '6小时修炼时间');
   --返回消息
   P_saysystem(uSource, '恭喜你,增加6小时修炼场时间!', 2);
 return;
end