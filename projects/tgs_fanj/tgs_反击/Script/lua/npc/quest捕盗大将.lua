package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = 'quest捕盗大将';

local MainMenu =
[[
忍者脱逃是我捕盗大将生涯中最耻辱的事了. ^^
<「游标.bmp」『$00FFFF00| 递上梅花夫人书札』/@quest>^
<「游标.bmp」『$00FFFF00| 拿出脚镣』/@fetter>
]];

local MainMenu_1 =
[[
你果真是梅花夫人派来的?那太好了.^
前些日子忍者逃狱,我动员了手下的精锐军队也^
没能抓他们归案.我任职这20年来,还未曾遭受^
过这样的奇耻大辱.侠士别看现在没什么动静,^
一旦这些家伙行动起来,长城以南就要不得安宁了.^
所以,要在他们行动之前尽快抓住他们.你可愿^
意出手帮忙?^
^
<「游标.bmp」『$00FFFF00| 可以』/@sure>^
<「游标.bmp」『$00FFFF00| 回绝』/@rejection
]];

local MainMenu_2 =
[[
好吧.那就请尽快解决了忍者,将凭证带回.. ^
那些家伙在潜逃时还带着脚镣,应该不难辨认. ^^
<「游标.bmp」『$00FFFF00| 好的』/@close_1>
]];

local MainMenu_3 =
[[
又是一个胆小怕事之辈.!!带上这个快给我离开!!
]];

local MainMenu_4 =
[[
不错不错.正是那些家伙潜逃时带着的脚镣.^
这是在下的一点儿心意,请收下.
]];

local MainMenu_5 =
[[
要抓紧时间了!!! 长城以南百姓的安危可靠你了!!^
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
    if P_getitemcount(uSource, '梅花夫人书札') < 1 then
      P_MenuSay(uSource, '来者面可不善啊.');
     return;
    end;
    if P_getitemcount(uSource, '老板娘书札') > 0 then
      P_MenuSay(uSource, '来者面可不善啊.');
     return;
    end;
    if P_getitemcount(uSource, '铁匠书札') > 0 then
      P_MenuSay(uSource, '来者面可不善啊.');
     return;
    end;
    if P_getitemcount(uSource, '药材商书札') > 0 then
      P_MenuSay(uSource, '来者面可不善啊.');
     return;
    end;
    if P_getitemcount(uSource, '风兄书札') > 0 then
      P_MenuSay(uSource, '来者面可不善啊.');
     return;
    end;	
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    --
    P_deleteitem(uSource, '梅花夫人书札', 1, 'quest捕盗大将');
    P_MenuSay(uSource, MainMenu_1);
    return;
  end;

  if aStr == 'sure' then
    P_MenuSay(uSource, MainMenu_2);
    return;
  end;   

  if aStr == 'rejection' then
     return;
  end;

  if aStr == 'close_1' then
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '捕盗大将书札') >= 1 then
      P_MenuSay(uSource, '来者面可不善啊.');
     return;
    end;
	P_additem(uSource, '捕盗大将书札', 1, 'quest捕盗大将');	
	return;
  end;

  if aStr == 'fetter' then
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '捕盗大将书札') < 1 then
      P_MenuSay(uSource, '来者面可不善啊.');
     return;
    end;	
    if P_getitemcount(uSource, '脚镣') < 1 then
      P_MenuSay(uSource, MainMenu_5);
      return;
    end;	
    if P_getitemcount(uSource, '男子卒兵娃娃2') < 1 then
      P_MenuSay(uSource, MainMenu_5);
      return;
    end;	
    if P_getitemcount(uSource, '女子卒兵娃娃2') < 1 then
      P_MenuSay(uSource, MainMenu_5);
      return;
    end;

    P_deleteitem(uSource, '脚镣', 1, 'quest捕盗大将');
    P_deleteitem(uSource, '男子卒兵娃娃2', 1, 'quest捕盗大将');
    P_deleteitem(uSource, '女子卒兵娃娃2', 1, 'quest捕盗大将');
    P_deleteitem(uSource, '捕盗大将书札', 1, 'quest捕盗大将');

    math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
    math.random();
    local iRandom = math.random(3, 4);
    if iRandom == 0 then
	  --随机给物品
	  local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
	  if #AwardItem ~= 2 then 
        return;
	  end
	  P_additem(uSource, AwardItem[1], AwardItem[2], 'quest捕盗大将');	
    end;
    if iRandom == 1 then
	  --随机给物品
	  local AwardItem = lua_Strtotable(M_GetQuestItem(6), ':');
	  if #AwardItem ~= 2 then 
        return;
	  end
	  P_additem(uSource, AwardItem[1], AwardItem[2], 'quest捕盗大将');	
    end;
    if iRandom == 2 then
	  --随机给物品
	  local AwardItem = lua_Strtotable(M_GetQuestItem(7), ':');
	  if #AwardItem ~= 2 then 
        return;
	  end
	  P_additem(uSource, AwardItem[1], AwardItem[2], 'quest捕盗大将');	
    end;
    if iRandom == 3 then
      if P_getitemcount(uSource, '招式全集') > 0 then
	    --随机给物品
	    local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
	    if #AwardItem ~= 2 then 
          return;
	    end
	    P_additem(uSource, AwardItem[1], AwardItem[2], 'quest捕盗大将');	
	  else
		P_additem(uSource, '招式全集', 1, 'quest捕盗大将');	
      end;
    end;
    if iRandom == 4 then
      if P_getitemcount(uSource, '四大神功全集') > 0 then
	    --随机给物品
	    local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
	    if #AwardItem ~= 2 then 
          return;
	    end
	    P_additem(uSource, AwardItem[1], AwardItem[2], 'quest捕盗大将');	
	  else
		P_additem(uSource, '四大神功全集', 1, 'quest捕盗大将');	
      end;
    end;
    P_MenuSay(uSource, MainMenu_4);
    return;
  end;
  if aStr == 'close_2' then
    return;
  end;
  if aStr == 'continue' then
    return;
  end;
  if aStr == 'giveup' then
    P_deleteitem(uSource, '捕盗大将书札', 1, 'quest捕盗大将');
    P_deleteitem(uSource, '脚镣', 1, 'quest捕盗大将');
    P_deleteitem(uSource, '男子卒兵娃娃2', 1, 'quest捕盗大将');
    P_deleteitem(uSource, '女子卒兵娃娃2', 1, 'quest捕盗大将');
	return;
  end;
 return;
end