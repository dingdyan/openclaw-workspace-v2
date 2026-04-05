package.loaded['Script\\lua\\f'] = nil;
package.loaded['Script\\lua\\任务\\新手任务'] = nil;

require ('Script\\lua\\f');
require ('Script\\lua\\任务\\新手任务');


local Npc_Name = '一级船夫';

local MainMenu =
[[^^
<「游标.bmp」『$FF00FF00| 新手任务出村』/@xsrw>^
]];
--[[随机物品(物品名,数量)
local Randomitem = {
  {'黄金手套', 1, '黄金手套'},
  {'三叉剑', 1, '三叉剑'},
  {'三叉戟', 1, '三叉戟'},
  {'桂林竹枪', 1, '桂林竹枪'},
  {'磐龙斧', 1, '磐龙斧'},	
};]]

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;
  
  if aStr == 'xsrw' then
	--获取玩家新手任务ID
	local Value = P_GetTempArr(uSource, NewTask.QuestArr);
	if Value == 14 then 
	  --判断年龄
	  if P_GetAttrib(uSource).Age < 10 then 
	    P_MenuSay(uSource, '10岁才可出村');
	    return;
	  end; 
	  --检测背包空位
	  if P_getitemspace(uSource) < #NewTask.Award[Value + 1] then
        P_MenuSay(uSource, string.format('请保留%d个物品栏空位', #NewTask.Award[Value + 1]));
	   return;
	  end; 
	  --任务流程==14,分配任务ID 15,结束新手任务
	  P_SetTempArr(uSource, NewTask.QuestArr, Value + 1);
	  P_SetTempArr(uSource, NewTask.DieArr, 0);
	  --给予奖励
	  for i, v in pairs(NewTask.Award[Value + 1]) do
	    if type(v) == 'table' then
	      P_additem(uSource, v[1], v[2], '新手任务');
	    end
	  end;		
	  --删除任务提示
	  P_DelQuestInfo(uSource, NewTask.QuestArr, 0);
	  --传送
	  P_MapMove(uSource, 1, 500, 500, 25);
	  P_additem(uSource, '无击阵', 1, '船夫');
	  --公告
	  M_topmsg(string.format('%s 完成新手村任务 开始闯荡江湖', B_GetRealName(uSource)), 33023);
     return;	
	end		
	P_MenuSay(uSource, '请先完成新手任务');
    return;
  end;
 return;
end