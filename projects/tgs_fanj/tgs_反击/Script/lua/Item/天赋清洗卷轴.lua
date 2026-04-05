function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --检测道具数量
   if P_getitemcount(uSource, '天赋清洗卷轴') < 1 then 
	 P_saysystem(uSource, '没有天赋清洗卷轴', 2);
     return;
   end
   --获取天赋属性
   local gengu, shenfa, wuxing, wuxue = P_GetTalentAttrib(uSource);
   --计算天赋属性总点数
   local m = gengu + shenfa + wuxing + wuxue;
   if m < 1 then 
	 P_saysystem(uSource, '你没有已分配天赋属性可清洗', 2);
     return;
   end
   --删除道具
   P_deleteitem(uSource, '天赋清洗卷轴', 1, '天赋清洗');
   --修改天赋属性
   P_SetTalentAttrib(uSource, 0, 0, 0, 0);
   --修改天赋分配点
   P_SetnewTalent(uSource, P_GetnewTalent(uSource) + m);
   P_saysystem(uSource, '成功重置已分配天赋点数.', 2);
   
 return;
end