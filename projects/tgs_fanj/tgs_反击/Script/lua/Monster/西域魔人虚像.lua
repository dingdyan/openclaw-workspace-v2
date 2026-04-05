local Npc_Name = '上古雨中客';

local MainMenu_1 =
[[
噢?你是怎么认识本人的?啊...你手上的戒指.^
原来如此.你就是收了两大魔头的大英雄.我替众人感谢你.^
但是你有所不知,除了东天和北霸还有个南帝.^
这魔头一日不除,百姓就一日不得安宁.^
拜托英雄,杀了南帝.^
^
<「游标.bmp」『$00FFFF00| 我发誓不杀南帝，誓不为人。』/@killok>
]];

local MainMenu_2 =
[[
感激不尽.这西域牌代表本人,见牌如见人.^
遇到困境就掏出来,都会给本人一点薄面,放你一马.^
 (任务进行中,双击书函就能确认您目前完成任务的状况.)^
]];

function OnMenu(uSource, uDest)
  --获取玩家基本属性
  local Attrib = P_GetAttrib(uSource);
  --检测浩然
  if Attrib.Virtue < 4000 then 
      P_MenuSay(uSource, '浩然不足，完成不了任务!');
	 return;
  end;	

  --获取任务变量
  local CompleteQuest = P_GetQuestNo(uSource);
  local CurrentQuest = P_GetQuestCurrentNo(uSource);

  if CurrentQuest < 1250 then 
    B_SAY(uDest, '每天都有好心情');
   return;
  end;
   
  if CurrentQuest == 1250 then
	--判断物品栏
    if P_getitemcount(uSource, '侠客指环') < 1 then
      --判断身上
      local ItemData = P_GetWearItemInfoTabs(uSource, 10);
      if ItemData.Name ~= '侠客指环' then 
        P_SetQuestNo(uSource, 1000);
        P_SetQuestCurrentNo(uSource, 1000);	
        CompleteQuest = 1000;
        CurrentQuest = 1000;
      end; 
    end;
    if P_getitemcount(uSource, '牌王') >= 1 then
      B_SAY(uDest, '胆敢在我面前卖弄武功，不服就来吧。。。');
     return;
    end;	
    local ItemData = P_GetWearItemInfoTabs(uSource, 10);
    if ItemData.Name == '牌王' then 
      B_SAY(uDest, '胆敢在我面前卖弄武功，不服就来吧。。。');
     return;
    end; 
    P_MenuSay(uSource, MainMenu_1);
	return;
  end;

  if CurrentQuest > 1250 and CurrentQuest < 1550 then
	B_SAY(uDest, '还没擒住？加把劲儿啦');
	return;
  end
   
  if CurrentQuest == 1550 then
	--判断物品栏
    if P_getitemcount(uSource, '牌王') < 1 then
      --判断身上
      local ItemData = P_GetWearItemInfoTabs(uSource, 10);
      if ItemData.Name ~= '牌王' then 
        P_SetQuestNo(uSource, 1200);
        P_SetQuestCurrentNo(uSource, 1250);	
        CompleteQuest = 1200;
        CurrentQuest = 1250;
      end; 
    end;	
	--判断物品栏 
    if P_getitemcount(uSource, '侠客指环') < 1 then
      --判断身上
      local ItemData = P_GetWearItemInfoTabs(uSource, 10);
      if ItemData.Name ~= '侠客指环' then 
        P_SetQuestNo(uSource, 1000);
        P_SetQuestCurrentNo(uSource, 1000);	
        CurrentQuest = 1000;
        CompleteQuest = 1000;
      end; 
    end;

	B_SAY(uDest, '胆敢在我面前卖弄武功，不服就来吧。。。');
	return;
  end;
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'killok' then
    --检测背包空位
    if P_getitemspace(uSource) < 2 then
      P_MenuSay(uSource, '请保留2个物品栏空格');
     return;
    end; 
	
    if P_getitemcount(uSource, '书函') < 1 then
	  P_additem(uSource, '书函', 1, '西域魔人虚像');
    end;
    if P_getitemcount(uSource, '西域牌') < 1 then
	  P_additem(uSource, '西域牌', 1, '西域魔人虚像');
    end;
    P_SetQuestNo(uSource, 1250);
    P_SetQuestCurrentNo(uSource, 1300);	
    P_MenuSay(uSource, MainMenu_2);	
    return;
  end;
   
 return;
end