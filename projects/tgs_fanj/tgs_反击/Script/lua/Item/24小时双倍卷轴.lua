function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --检测道具数量
   if P_getitemcount(uSource, '24小时双倍卷轴') < 1 then 
	 P_saysystem(uSource, '没有 24小时双倍卷轴', 2);
     return;
   end
   --增加翻倍经验
   if not P_AddMagicExpMul(uSource, 2, 60*60*24) then 
	 P_saysystem(uSource, '道具使用失败,请联系管理员！', 2);
     return;
   end
   --删除道具
   P_deleteitem(uSource, '24小时双倍卷轴', 1, '双倍卷轴');
   P_saysystem(uSource, '增加24小时双倍经验,使用口令[@双倍经验情报]可查询剩余时间.', 2);
 return;
end