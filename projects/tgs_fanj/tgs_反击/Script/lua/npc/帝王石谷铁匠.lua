package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '帝王石谷僧侣';

local MainMenu_1 =
[[
 亲自为你打造各类物品，当然不是免费的啦~~^
^
<「游标.bmp」『$00FFFF00| 有关石谷钥匙的制法』/@about>^
<「游标.bmp」『$00FFFF00| 做 石谷钥匙』/@make>
]];

local MainMenu_2 =
[[
 只要有 [金毛狮甲]和[蝎子尾巴]就能制得石谷钥匙。^
^
 <『$00FFFF00|[返回]』/@before>
]];


function OnMenu(uSource, uDest)
  --获取任务变量
  local CompleteQuest = P_GetQuestNo(uSource);
  local CurrentQuest = P_GetQuestCurrentNo(uSource);

  if CurrentQuest < 1450 then
    B_SAY(uDest, '我正忙着做石谷钥匙呢。。。没事儿别打扰我');
   return;
  end;

  if CurrentQuest == 1450 then
    P_MenuSay(uSource, MainMenu_1);
   return;
  end;

  if CurrentQuest == 1500 then
    B_SAY(uDest, '事情进行得还顺利吗?');
   return;
  end;

  if CurrentQuest == 1550 then
    B_SAY(uDest, '抱歉_小人有眼无珠没认清大人?');
   return;
  end;

 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'about' then
    P_MenuSay(uSource, MainMenu_2);
   return;
  end;

  if aStr == 'before' then
    P_MenuSay(uSource, MainMenu_1);
   return;
  end;

  if aStr == 'make' then
    if P_GetQuestCurrentNo(uSource) ~= 1450 then 
     return;
    end;
	
    if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '行囊满了');
     return;
    end; 
    if P_getitemcount(uSource, '石谷钥匙') >= 1 then
      P_MenuSay(uSource, '身上不是有石谷钥匙吗_别太贪心啦');
     return;
    end;
    if P_getitemcount(uSource, '金毛狮甲') < 1 then
      P_MenuSay(uSource, '巧妇难为无米之炊_什么都不拿让我拿什么做呀');
     return;
    end;
    if P_getitemcount(uSource, '蝎子尾巴') < 1 then
      P_MenuSay(uSource, '巧妇难为无米之炊_什么都不拿让我拿什么做呀');
     return;
    end;
	
    if P_getitemcount(uSource, '降魔符') >= 1 then
      P_SetQuestNo(uSource, 1450);
      P_SetQuestCurrentNo(uSource, 1500);	
    end;
	
    P_deleteitem(uSource, '蝎子尾巴', 1, '帝王石谷铁匠');
    P_deleteitem(uSource, '金毛狮甲', 1, '帝王石谷铁匠');
	P_additem(uSource, '石谷钥匙', 1, '帝王石谷铁匠');
	
    P_MenuSay(uSource, '请妥善保管');
   return;
  end;

 return;
end