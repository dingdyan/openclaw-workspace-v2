function OnItemDblClick(uSource, uItemKey, astr)
  if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
  end
  --检测道具数量
  if P_getitemcount(uSource, '戒指任务卷轴') < 1 then 
	 P_saysystem(uSource, '没有 戒指任务卷轴', 2);
     return;
  end
  --获取任务变量
  local CompleteQuest = P_GetQuestNo(uSource);
  local CurrentQuest = P_GetQuestCurrentNo(uSource);
  if CompleteQuest > 100 or CurrentQuest > 100 then
	 P_saysystem(uSource, '你已进行了任务 请先去玉仙初始化', 2);
     return;
  end
  --检测背包空位
  if P_getitemspace(uSource) < 1 then
	 P_saysystem(uSource, '物品栏已满', 2);
     return;
  end; 

  P_deleteitem(uSource, '戒指任务卷轴', 1, '戒指任务卷轴');
	
  P_SetQuestNo(uSource, 1600);
  P_SetQuestCurrentNo(uSource, 1600);	
  P_additem(uSource, '不灭', 1, '戒指任务卷轴');

  --返回消息
  P_saysystem(uSource, '戒指任务卷轴 使用成功', 2);
  M_topmsg(string.format('恭喜[%s]使用[戒指任务卷轴],快速完成了[戒指任务]', B_GetRealName(uSource)), 16754943);
 return;
end