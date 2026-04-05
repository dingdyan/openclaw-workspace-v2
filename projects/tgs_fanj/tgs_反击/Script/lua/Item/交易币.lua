package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --检测道具数量
   local jyb = P_getitemcount(uSource, '交易币');
   if jyb < 1 then 
	 P_saysystem(uSource, '最少1个交易币才可兑换回元宝', 2);
     return;
   end
   --增加元宝
   P_AddMysqlDianJuan(uSource, jyb * 1);	
   --删除道具
   P_deleteitem(uSource, '交易币', jyb, '交易币');
   --返回消息
   P_saysystem(uSource, string.format('兑换了%d个交易币,增加元宝: %d', jyb, jyb * 1), 2);
   
 return;
end