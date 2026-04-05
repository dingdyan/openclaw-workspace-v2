--打开触发
function OnTurnOn(uSource, uDest)
    --检测背包空位
    if P_getitemspace(uSource) < 1 then
      P_saysystem(uSource, '物品栏已满', 2);
     return;
    end; 

	P_deleteitem(uSource, '书函', 1, '抽屉');
	
	if P_getitemcount(uSource, '侠客指环') < 1 then
	  P_additem(uSource, '侠客指环', 1, '抽屉');
	end;	
	
	P_SetQuestCurrentNo(uSource, 1250);	
	P_SetQuestNo(uSource, 1200);
   
	P_SetQuestStep(uSource, 2);
	
	M_topmsg(string.format('%s 祝贺您,西域魔人阴谋 任务结束', B_GetRealName(uSource)), 16754943);

	P_saysystem(uSource, '完成了西域魔人任务', 2);

end;

