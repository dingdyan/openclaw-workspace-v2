package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = 'quest风兄';

local MainMenu_1 =
[[
我是风兄,何事找我?^^
<「游标.bmp」『$00FFFF00| 递上 神秘箱子』/@quest>^
<「游标.bmp」『$00FFFF00| 递上 所需材料』/@clothpieces>
]];

local MainMenu_2 =
[[
 是否要找回神秘箱子?^^
<「游标.bmp」『$00FFFF00| 是』/@prize>^
<「游标.bmp」『$00FFFF00| 不是』/@dontprize>^
<「游标.bmp」『$00FFFF00| 关闭』/@close>
]];

local MainMenu_3 =
[[
呵呵~ 这是我寻求已久的'神秘箱子'! ^
我还听说有人打开此箱后发了大财.在下也想试它一试.^
好,这是你的酬劳,不太多,但跟一个破箱子比起来你也不算亏了!^
^
<「游标.bmp」『$00FFFF00| 收下』/@q1_close>
]];

local MainMenu_4_1 =
[[
阁下是否听说过北方魔人的道袍?在下不了解才问的.^
几天前我在千年村里拣到一块布.是我这辈子都没看过的.^
不仅结实,还很轻.做了29年的衣服,这种质地的衣^
服我还头一次看见.后来我才打听到是北方魔人身上道^
袍上撕下的布条.只是听说,又没办法确认,唉~^
^
<「游标.bmp」『$00FFFF00| 下一步』/@q2_next1>
]];

local MainMenu_4_2 =
[[
用这种布料能做非常好的衣服.阁下如果有空儿,^
能否替我走一趟,看看北方魔人身上是不是真出这^
东西,如果真出,请帮我带回20个布条吧.^
^
<「游标.bmp」『$00FFFF00| 答应』/@getcloth>^
<「游标.bmp」『$00FFFF00| 拒绝』/@rejection>
]];

local MainMenu_4_3 =
[[
好,太好了.传闻果真是真的! 都说船到桥头自然直,^
还真有道理! ^
材料都拿到了?你真的没让我失望.多谢!这是你的酬劳.^
]];

local MainMenu_4_4 =
[[
如果可以实现,发财是早晚的事儿.^
]];

local MainMenu_5 =
[[
这不是'神秘箱子'吗?这么珍贵,我今天一天就拿到了2个.^
在阁下来之前有一个持斧之人卖给我一个盒子.他并不是经常^
光顾,只是偶尔会来.不过我想他似乎知道些什么.这箱子有多^
少我要多少,你帮我找那个人打听一下.这里有一些线索,你不^
妨看看,他长得很特别应该不会很难找.^
^
<「游标.bmp」『$00FFFF00| 继续』/@q3_close>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu_1);
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
    if P_getitemcount(uSource, '神秘箱子') < 1 then
      P_MenuSay(uSource, '奇怪?怎么喊了半天又没话了?');
     return;
    end;

    --获取境界
	local nPower = P_GetEnergyLevel(uSource);

	if nPower < 1 then
      P_MenuSay(uSource, MainMenu_2);
     return;
	end;

	if nPower >= 1 then
      P_deleteitem(uSource, '神秘箱子', 1, 'quest风兄');
	  --随机任务
      math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
      math.random();
      local iRandom = math.random(0, 2);
      if iRandom == 0 then
        P_MenuSay(uSource, MainMenu_3);
       return;
      end;
      if iRandom == 1 then
        P_MenuSay(uSource, MainMenu_4_1);
       return;
      end;
      if iRandom == 2 then
        P_MenuSay(uSource, MainMenu_5);
       return;
      end;
      return;
	end;
    return;
  end;

  if aStr == 'prize' then
    if P_getitemcount(uSource, '神秘箱子') < 1 then
      P_MenuSay(uSource, '奇怪?怎么喊了半天又没话了?');
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    P_deleteitem(uSource, '神秘箱子', 1, 'quest风兄');

	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(1), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest风兄');		
	P_MenuSay(uSource, '感谢你~这是给你的回报');
    return;
  end;

  if aStr == 'dontprize' then
    if P_getitemcount(uSource, '神秘箱子') < 1 then
      P_MenuSay(uSource, '奇怪?怎么喊了半天又没话了?');
     return;
    end;
    P_deleteitem(uSource, '神秘箱子', 1, 'quest风兄');

    math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
    math.random();
    local iRandom = math.random(0, 2);
	
    if iRandom == 0 then
      P_MenuSay(uSource, MainMenu_3);
     return;
    end;
    if iRandom == 1 then
      P_MenuSay(uSource, MainMenu_4_1);
     return;
    end;
    if iRandom == 2 then
      P_MenuSay(uSource, MainMenu_5);
     return;
    end;
   return;
  end;

  if aStr == 'q1_close' then
    if P_getitemcount(uSource, '神秘箱子') < 1 then
      P_MenuSay(uSource, '奇怪?怎么喊了半天又没话了?');
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    P_deleteitem(uSource, '神秘箱子', 1, 'quest风兄');

	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(2), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest风兄');		
	P_MenuSay(uSource, '感谢你~这是给你的回报');
   return;
  end;

  if aStr == 'getcloth' then
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '风兄材料书札') > 0 then
      P_MenuSay(uSource, '奇怪?怎么喊了半天又没话了?');
     return;
    end;
	P_additem(uSource, '风兄材料书札', 1, 'quest风兄');		
	P_MenuSay(uSource, '请速去速回');
   return;
  end;

  if aStr == 'rejection' then
   return;
  end;

  if aStr == 'clothpieces' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '风兄材料书札') < 1 then
      P_MenuSay(uSource, '奇怪?怎么喊了半天又没话了?');
     return;
    end;
	local count = P_getitemcount(uSource, '布条');
    if count < 20 then
      P_MenuSay(uSource, MainMenu_4_4);
     return;
    end;
    P_deleteitem(uSource, '风兄材料书札', 1, 'quest风兄');
    P_deleteitem(uSource, '布条', count, 'quest风兄');
	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(1), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest风兄');		
    P_MenuSay(uSource, MainMenu_4_3);
   return;
  end;

  if aStr == 'continue' then
   return;
  end;

  if aStr == 'q2_1_close' then
   return;
  end;

  if aStr == 'q3_close' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '风兄书札') >= 1 then
      P_MenuSay(uSource, '奇怪?怎么喊了半天又没话了?');
     return;
    end;
    P_additem(uSource, '风兄书札', 1, 'quest风兄');		
    return;
  end;

  if aStr == 'q2_next1' then
    P_MenuSay(uSource, MainMenu_4_2);
   return;
  end;  

 return;
end