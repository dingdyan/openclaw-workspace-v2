package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = 'quest梅花夫人';

local MainMenu_1 =
[[
 我是梅花夫人.何事找我?^^
<「游标.bmp」『$00FFFF00| 买 物品』/@buy>^
<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>^
<「游标.bmp」『$00FFFF00| 取出神秘箱子』/@quest>
]];

local MainMenu_2 =
[[
 神秘箱子作为酬劳如何?^^
<「游标.bmp」『$00FFFF00| 好的』/@prize>^
<「游标.bmp」『$00FFFF00| 不了』/@dontprize>^
<「游标.bmp」『$00FFFF00| 关闭』/@close>
]];

local MainMenu_3 =
[[
啊~是神秘箱子.^
都说这箱子在开启之前没人能猜出里面会出什么.^
据说很难求得.真要送给我吗?^
谢谢.你可是想用这个来讨好我.箱子里面的东西还给你^
^
<「游标.bmp」『$00FFFF00| 收下』/@q1_close>
]];

local MainMenu_4 =
[[
我是中央市场的梅花夫人,^
最近我那个住在竹林的妹妹可让我伤透了脑筋.^
她非常喜欢的发簪在路上被山贼给抢了.这可如何是好.^
阁下能否替我找回妹妹的发簪,那就太感谢了.^
^
<「游标.bmp」『$00FFFF00| 答应帮着找玉簪』/@findhairpin>^
<「游标.bmp」『$00FFFF00| 拒绝』/@rejection>
]];

local MainMenu_4_1 =
[[
谢谢.这是记有那些山贼情况的书札.找到玉簪后^
请务必拿给我妹妹^
^
<「游标.bmp」『$00FFFF00| 收下书札』/@q2_1_close>
]];

local MainMenu_4_2 =
[[
既然忙,也没法子..^
听我唠叨半天了. ^
侠士收下这个吧,小小心意,不足挂齿.
]];

local MainMenu_4_3 =
[[
这可如何是好? 是姐姐她让你...? 太感谢了. ^
这是我最喜欢的发簪.竟然帮我找到了. ^
收下吧..这是我的一点心意.^
]];

local MainMenu_4_4 =
[[
最近双花店前面多了不少狗.^
^
<「游标.bmp」『$00FFFF00| 继续』/@continue>^
<「游标.bmp」『$00FFFF00| 放弃』/@giveup>
]];

local MainMenu_5 =
[[
这好像是捕盗厅被盗的箱子.已经到处发了布告,^
这关系到捕盗大将的名誉.赶快拿着书札去找捕盗大将.^
为了长城以南的太平,他已费劲心力了...^
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
      P_MenuSay(uSource, '不如喝杯茶再走');
     return;
    end;
    --获取境界
	local nPower = P_GetEnergyLevel(uSource);

	if nPower < 1 then
      P_MenuSay(uSource, MainMenu_2);
     return;
	end;

	if nPower >= 1 then
      P_deleteitem(uSource, '神秘箱子', 1, 'quest梅花夫人');
	  --随机任务
      math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
      math.random();
      local iRandom = math.random(0, 2);
      if iRandom == 0 then
        P_MenuSay(uSource, MainMenu_3);
       return;
      end;
      if iRandom == 1 then
        P_MenuSay(uSource, MainMenu_4);
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
      P_MenuSay(uSource, '不如喝杯茶再走');
     return;
    end;
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    P_deleteitem(uSource, '神秘箱子', 1, 'quest梅花夫人');
	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(1), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest梅花夫人');		
	P_MenuSay(uSource, '感谢你~这是给你的回报');
  end;

  if aStr == 'dontprize' then
    if P_getitemcount(uSource, '神秘箱子') < 1 then
      P_MenuSay(uSource, '不如喝杯茶再走');
     return;
    end;
    P_deleteitem(uSource, '神秘箱子', 1, 'quest梅花夫人');

	--随机任务
    math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
    math.random();
    local iRandom = math.random(0, 2);
    if iRandom == 0 then
      P_MenuSay(uSource, MainMenu_3);
     return;
    end;
    if iRandom == 1 then
      P_MenuSay(uSource, MainMenu_4);
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
      P_MenuSay(uSource, '不如喝杯茶再走');
     return;
    end;
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    P_deleteitem(uSource, '神秘箱子', 1, 'quest梅花夫人');

	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(2), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest梅花夫人');		
	P_MenuSay(uSource, '感谢你~这是给你的回报');
	return;
  end;

  if aStr == 'findhairpin' then
    P_MenuSay(uSource, MainMenu_4_1);
   return;
  end;

  if aStr == 'rejection' then
    P_MenuSay(uSource, MainMenu_4_2);
   return;
  end;

  if aStr == 'q2_1_close' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    if P_getitemcount(uSource, '梅花夫人材料书札') > 0 then
      P_MenuSay(uSource, '不如喝杯茶再走');
     return;
    end;
    P_additem(uSource, '梅花夫人材料书札', 1, 'quest梅花夫人');
    return;
  end;

  if aStr == 'q2_2_close' then
   return;
  end;

  if aStr == 'q3_close' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    if P_getitemcount(uSource, '梅花夫人书札') > 0 then
      P_MenuSay(uSource, '不如喝杯茶再走');
     return;
    end;
    P_additem(uSource, '梅花夫人书札', 1, 'quest梅花夫人');		
    return;
  end;
 return;
end