package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '帝王老人';

local MainMenu =
[[
完成戒指任务后可购买 竹筒,石谷钥匙,降魔符^
给我300个交易币可以直接完成任务,给予牌王(活力+30)^
^
<『$00FFFF00| 给予 300个交易币』/@rw>^
<『$00FFFF00| 买 物品』/@buy2>^
]];

local BUYMenu =
[[
你已完成任务 可购买道具^
^
<『$00FFFF00| 买 石谷钥匙 降魔符』/@buy>^
<『$00FFFF00| 买 超级竹筒』/@mzt>^
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	
  
  if aStr == 'mzt' then
    -- if P_GetQuestCurrentNo(uSource) < 1550 then 
      -- P_MenuSay(uSource, '完成任务后才可购买道具');
     -- return;
    -- end;
    if P_getitemcount(uSource, '超级竹筒') > 0 then
      P_MenuSay(uSource, '不用重复购买');
     return;
    end;
    if P_getitemcount(uSource, '交易币') < 100 then
      P_MenuSay(uSource, '没有100个交易币');
     return;
    end;
    P_deleteitem(uSource, '交易币', 100, '帝王老人');
    P_deleteitem(uSource, '竹筒', 1, '帝王老人');
    P_deleteitem(uSource, '大型竹筒', 1, '帝王老人');

    P_additem(uSource, '超级竹筒', 1, '帝王老人');
	
    P_MenuSay(uSource, '拿好你的 超级竹筒');
    return;
  end;	
	
  if aStr == 'buy2' then
    -- if P_GetQuestCurrentNo(uSource) < 1550 then 
      -- P_MenuSay(uSource, '完成任务后才可购买道具');
     -- return;
    -- end;
    P_MenuSay(uSource, BUYMenu);
    return;
  end;	
  
  if aStr == 'rw' then
    if P_getitemcount(uSource, '交易币') < 300 then
      P_MenuSay(uSource, '没有300个交易币');
     return;
    end;
	
    if P_GetQuestCurrentNo(uSource) >= 1550 then 
      P_MenuSay(uSource, '不能重复完成任务');
     return;
    end;
	
    P_SetQuestNo(uSource, 1500);
    P_SetQuestCurrentNo(uSource, 1550);	
	
    P_deleteitem(uSource, '交易币', 300, '帝王老人');
    P_deleteitem(uSource, '小佛', 1, '帝王老人');
    P_deleteitem(uSource, '白桦树桩', 1, '帝王老人');
    P_deleteitem(uSource, '抽屉钥匙', 1, '帝王老人');
    P_deleteitem(uSource, '侠客指环', 1, '帝王老人');
    P_deleteitem(uSource, '书函', 1, '帝王老人');
    P_deleteitem(uSource, '戒指', 1, '帝王老人');
    P_deleteitem(uSource, '降魔符', 1, '帝王老人');
    P_deleteitem(uSource, '帝王守护灵', 1, '帝王老人');

    if P_getitemcount(uSource, '牌王') < 1 then
	  P_additem(uSource, '牌王', 1, '帝王老人');
    end;
	
	M_topmsg(string.format('%s 祝贺您,南帝王 任务结束', B_GetRealName(uSource)), 16754943);
	
    P_MenuSay(uSource, '南帝王任务结束了');
    return;
  end;		

 return;
end
