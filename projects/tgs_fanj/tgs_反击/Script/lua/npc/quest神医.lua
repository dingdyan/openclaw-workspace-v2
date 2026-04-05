package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = 'quest神医';

local MainMenu =
[[
正在研制新药,遇到了些问题.不知您来有何贵干? ^^
<「游标.bmp」『$00FFFF00| 买 物品』/@buy>^
<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>^
<「游标.bmp」『$00FFFF00| 递上 药材商书札』/@quest>^
<「游标.bmp」『$00FFFF00| 递上 雪花』/@snowflower>
]];

local MainMenu_1 =
[[
啊~ 侠客手上的可是神秘箱子! ^
如此稀罕之物是怎样弄到的!? ^
近两年我让我的弟子们找遍了武林也没能弄到,^
竟然在阁下手里. ^
^
<「游标.bmp」『$00FFFF00| 赠送』/@q1_next>
]];

local MainMenu_2 =
[[
此话当真?年轻人果然不错!这10多年来一^
直没能凑足这些药材,没能做出新药.这下可^
好了.这...这可如何是好...有些药材都烂了...^
^
<「游标.bmp」『$00FFFF00| 我帮你找药材』/@q2_next>
]];

local MainMenu_3 =
[[
啊...老朽活了一辈子还没遇到过你这样的年轻人.^
要是能有你这样的孩子就好了!  ^
收好了,这里写着配方呢.凑齐了拿给老朽,不会亏待你的.^
^
<「游标.bmp」『$00FFFF00| 好的，接受委托』/@close_1>
]];

local MainMenu_4 =
[[
这么快...瞧瞧...谁看了都会忍不住感慨的.^
对了,差点儿忘了给你应得的酬劳了,如果下次^
还能弄来,会有更好的,那我就先失陪了,要开工了
]];

local MainMenu_5 =
[[
还没找到?^
^
<「游标.bmp」『$00FFFF00| 继续』/@continue>^
<「游标.bmp」『$00FFFF00| 放弃』/@giveup>
]];

local MainMenu_RW =
[[
还没找到?^
^
<「游标.bmp」『$00FFFF00| 继续』/@continue>^
<「游标.bmp」『$00FFFF00| 放弃』/@giveup>
]];


function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	

  if aStr == 'quest' then
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '药材商书札') < 1 then
      P_MenuSay(uSource, '不是需要药材吗?');
     return;
    end;
    if P_getitemcount(uSource, '老板娘书札') > 0 then
      P_MenuSay(uSource, '不是需要药材吗?');
     return;
    end;
    if P_getitemcount(uSource, '梅花夫人书札') > 0 then
      P_MenuSay(uSource, '不是需要药材吗?');
     return;
    end;
    if P_getitemcount(uSource, '铁匠书札') > 0 then
      P_MenuSay(uSource, '不是需要药材吗?');
     return;
    end;
    if P_getitemcount(uSource, '风兄书札') > 0 then
      P_MenuSay(uSource, '不是需要药材吗?');
     return;
    end;
    P_deleteitem(uSource, '药材商书札', 1, 'quest神医');
    P_MenuSay(uSource, MainMenu_1);
   return;
  end;

  if aStr == 'q1_next' then
    P_MenuSay(uSource, MainMenu_2);
   return;
  end;

  if aStr == 'q2_next' then
    P_MenuSay(uSource, MainMenu_3);
   return;
  end;

  if aStr == 'close_1' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '神医书札') > 0 then
      P_MenuSay(uSource, '不是需要药材吗?');
     return;
    end;
	P_additem(uSource, '神医书札', 1, 'quest药材商');	
   return;
  end;

  if aStr == 'snowflower' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '神医书札') < 1 then
      P_MenuSay(uSource, '不是需要药材吗?');
     return;
    end;
    if P_getitemcount(uSource, '雪花') < 1 then
      P_MenuSay(uSource, MainMenu_5);
     return;
    end;
	
    P_deleteitem(uSource, '雪花', 1, 'quest神医');
    P_deleteitem(uSource, '神医书札', 1, 'quest神医');
	
	P_MenuSay(uSource, MainMenu_4);
	
    math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
    math.random();
    local iRandom = math.random(3, 4);
		
    if iRandom == 0 then
	  local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
	  if #AwardItem ~= 2 then 
	    return;
	  end
	  P_additem(uSource, AwardItem[1], AwardItem[2], 'quest神医');	
     return;
    end;
    if iRandom == 1 then
	  local AwardItem = lua_Strtotable(M_GetQuestItem(6), ':');
	  if #AwardItem ~= 2 then 
	    return;
	  end
	  P_additem(uSource, AwardItem[1], AwardItem[2], 'quest神医');	
     return;
    end;
    if iRandom == 2 then
	  local AwardItem = lua_Strtotable(M_GetQuestItem(7), ':');
	  if #AwardItem ~= 2 then 
	    return;
	  end
	  P_additem(uSource, AwardItem[1], AwardItem[2], 'quest神医');	
     return;
    end;
    if iRandom == 3 then
	  if P_getitemcount(uSource, '招式全集') > 0 then
	    local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
	    if #AwardItem ~= 2 then 
	      return;
	    end
	    P_additem(uSource, AwardItem[1], AwardItem[2], 'quest老侠客');	
		return;
	  end;
      P_additem(uSource, '招式全集', 1, 'quest神医');	
     return;
    end;
    if iRandom == 4 then
	  if P_getitemcount(uSource, '四大神功全集') > 0 then
	    local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
	    if #AwardItem ~= 2 then 
	      return;
	    end
	    P_additem(uSource, AwardItem[1], AwardItem[2], 'quest老侠客');	
		return;
	  end;
      P_additem(uSource, '四大神功全集', 1, 'quest神医');	
     return;
    end;
    return;
  end;

  if aStr == 'continue' then
    return;
  end;
  if aStr == 'giveup' then
    P_deleteitem(uSource, '神医书札', 1, 'quest神医');
    P_deleteitem(uSource, '千年冰玉2', 1, 'quest神医');
    P_deleteitem(uSource, '凋谢的花', 1, 'quest神医');
    return;
  end;
  if aStr == 'close_2' then
    return;
  end;

 return;
end