package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --检测道具数量
   local jf = P_getitemcount(uSource, '门派战力');
   if jf < 1 then 
	 P_saysystem(uSource, '最少1个门派战力积分才可兑换积分', 2);
     return;
   end
    --检测是否加入门派
     local GuildName = P_GuildGetName(uSource);
     if GuildName == '' then 
       P_saysystem(uSource, '你还没有门派，无法使用', 2);
      return;
     end
   --增加门派积分
   M_SetGuildEnegy(GuildName, M_GetGuildEnegy(GuildName) + jf);	
   --删除道具
   P_deleteitem(uSource, '门派战力', jf, '门派战力');
   --返回消息
   M_GuildSay(GuildName, string.format('门派公告:[%s]给门派战力增加了%s点', B_GetRealName(uSource),jf), 16);	
 return;
end