package.loaded['Script\\lua\\f'] = nil;
package.loaded['Script\\lua\\任务\\新手任务'] = nil;

require ('Script\\lua\\f');
require ('Script\\lua\\任务\\新手任务');

local Npc_Name = '捕盗大将';

local MainMenu =
[[ 有什么可以帮助你?^^
使用Alt+Q查看任务状态^^
<「游标.bmp」『$FF00FF00| 新手任务』/@xsrw>
]];


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
	if Value == 2 then 
	  --任务流程==2,分配任务ID 3,提示让去杀怪物
	  P_SetTempArr(uSource, NewTask.QuestArr, 3);
	  P_SetTempArr(uSource, NewTask.DieArr, 0);
	  --任务提示
	  P_MenuSay(uSource, '领取到一个新的任务,' .. NewTask.Info[3]);
	  NewTask.Start(uSource);
     return;	
	end	
	--任务流程==3,检测任务是否完成
	if Value == 3 then 
      --检测击杀怪物
      --获取玩家当前所杀怪物
      local PlayDie = P_GetTempArr(uSource, NewTask.DieArr);
	  if PlayDie < NewTask.Kill[Value] then 
        P_MenuSay(uSource, '需要击杀1只牛,任务尚未完成,请继续努力');
       return;	
	  end	
	  --给予奖励
	  for i, v in pairs(NewTask.Award[Value]) do
	    if type(v) == 'table' then
	      P_additem(uSource, v[1], v[2], '新手任务');
	    end
	  end;
	  --改变任务ID
	  P_SetTempArr(uSource, NewTask.QuestArr, Value + 1);
	  P_SetTempArr(uSource, NewTask.DieArr, 0);
	  --提示
      P_MenuSay(uSource, '任务完成,' .. NewTask.Info[Value + 1]);
	  NewTask.Start(uSource);
     return;	
	end	
	--任务流程 > 3, 返回流程提示
	if Value > 3 then 
      P_MenuSay(uSource, NewTask.Info[Value]);
     return;	
	end	
    P_MenuSay(uSource, '有何贵干');
    return;
  end;

 return;
end