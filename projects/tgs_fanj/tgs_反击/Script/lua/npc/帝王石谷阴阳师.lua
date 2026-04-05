package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '药材商';

local MainMenu_1 =
[[
 终于来活儿了，说吧，愿意为您效劳。^
^
<「游标.bmp」『$00FFFF00| 有关召唤符的制法』/@aboutticket>^
<「游标.bmp」『$00FFFF00| 做召唤符』/@maketicket>
]];

local MainMenu_2 =
[[
^
做召唤符要有淋上胎儿血的小佛。^
以前每个村子的村口都会立个石像，^
下面埋上小佛来驱鬼。^
^
<「游标.bmp」『$00FFFF00| 询问小佛石像的位置。』/@wherebaby>
]];

local MainMenu_4 =
[[
 以前东海沼泽小佛像多的是，最近却很罕见。^
 据说一些人在东南角的竹林里见过小佛像。
]];

local MainMenu_5 =
[[^
 看来是高手。到底因何事儿找我？^
^
<「游标.bmp」『$00FFFF00| 询问降魔符的制法』/@aboutprotect>^
<「游标.bmp」『$00FFFF00| 做 降魔符』/@protectticket>
]];

local MainMenu_6 =
[[^
拿白桦树木块儿做降魔符。从这儿往西北角去，^
就能看到巨大的千年巨木的木块儿。
]];

function OnMenu(uSource, uDest)
  --获取任务变量
  local CompleteQuest = P_GetQuestNo(uSource);
  local CurrentQuest = P_GetQuestCurrentNo(uSource);

   if CompleteQuest == 1100 then
     P_MenuSay(uSource, MainMenu_1);
     return;
   end;

   if CurrentQuest == 1450 then
     P_MenuSay(uSource, MainMenu_5);
     return;
   end;

   B_SAY(uDest, '壮士，任务完成了吗?');
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'aboutticket' then
    P_MenuSay(uSource, MainMenu_2);
    return
  end;

  if aStr == 'maketicket' then
    if P_getitemcount(uSource, '小佛') < 1 then
      P_MenuSay(uSource, '拿小佛来~');
     return;
    end;
	
	P_deleteitem(uSource, '小佛', 1, '帝王石谷阴阳师');
	P_additem(uSource, '召唤符', 2, '帝王石谷阴阳师');
	P_MenuSay(uSource, '这就当辛苦费了。。。一路小心');
    return
  end;

  if aStr == 'wherebaby' then
    P_MenuSay(uSource, MainMenu_4);
    return
  end;


  if aStr == 'aboutprotect' then
    P_MenuSay(uSource, MainMenu_6);
    return
  end;

  if aStr == 'protectticket' then
    if P_GetQuestCurrentNo(uSource) ~= 1450 then 
     return;
    end;
    if P_getitemcount(uSource, '白桦树桩') < 1 then
      P_MenuSay(uSource, '材料都没拿_靠边站_忙着呢~');
     return;
    end;
	
	P_deleteitem(uSource, '白桦树桩', 1, '帝王石谷阴阳师');
	P_additem(uSource, '降魔符', 1, '帝王石谷阴阳师');
	P_MenuSay(uSource, '手持降魔符。。。你就大胆地往前走');
	
    if P_getitemcount(uSource, '石谷钥匙') >= 1 then
      P_SetQuestNo(uSource, 1450);
      P_SetQuestCurrentNo(uSource, 1500);	
    end;
    return
  end;
 return;
end