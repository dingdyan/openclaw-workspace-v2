package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = 'quest阴阳师';

local MainMenu =
[[
怎么没有人要弓术武功书?^
请拿潜行术来换透视符^
<「游标.bmp」『$00FFFF00| 买 物品』/@buy>^
<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>^
<「游标.bmp」『$00FFFF00| 用潜行术换透视符』/@make>^
<「游标.bmp」『$00FFFF00| 递上 老板娘书札』/@quest>^
<「游标.bmp」『$00FFFF00| 递上 魂魄.』/@spirit>^
<「游标.bmp」『$00FFFF00| 递上 封符.』/@seal>
]];

local MainMenu_1 =
[[
 "祭奠死者灵魂要将骨灰放入箱子里进行.可现^
 在没有祭奠用的箱子.而那神秘箱子有股魔力正^
 好能用上.这段日子附近很多男鬼出没,我猜想^
 可能是那可恶的九尾狐又现身了.侠士可否愿意^
 到狐狸洞走一趟?以侠士的身手杀死白狐狸和火^
 狐狸应该不在话下,如果它们身上掉落'死者灵魂'^
 那就说明九尾狐已经现身了."^
^
<「游标.bmp」『$00FFFF00| 好的.』/@close_1>
]];

local MainMenu_2 =
[[
果然，九尾狐复活了.那可丝毫延迟不得.^
一定要在它完全恢复之前封印了它.^
我在这儿守住这些魂，确保它们不变成孤魂野鬼.^
就有劳侠士拿着这个封印了九尾狐.^
务必要等它的体力不足1/3时再放进它的体内.切记...切记...
]];

local MainMenu_3 =
[[
在侠士离开的这段日子又无辜死了2个人...^
^
<「游标.bmp」『$00FFFF00| 继续』/@continue>^
<「游标.bmp」『$00FFFF00| 放弃』/@giveup>
]];

local MainMenu_4 =
[[
 这些冤魂总算可以安息了.九尾狐短期内也不会^
 再醒来.侠士这可是你的功劳啊～如不是侠士帮忙^
 这里可又是不得安宁了.收下吧,封印了九尾狐,^
 这是你应得的.^
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	

  if aStr == 'make' then
    if P_getitemcount(uSource, '潜行术') < 1 then
      P_MenuSay(uSource, '你没有潜行术来干甚..');
     return;
    end;
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
	P_deleteitem(uSource, '潜行术', 1, 'quest阴阳师');
	P_additem(uSource, '透视符', 1, 'quest阴阳师');
	P_MenuSay(uSource, '你收好透视符,妥善保管...');
	return;
  end;

  if aStr == 'quest' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '老板娘书札') < 1 then
      P_MenuSay(uSource, '妖魔鬼怪都给我出来~~!!');
     return;
    end;
    if P_getitemcount(uSource, '铁匠书札') > 0 then
      P_MenuSay(uSource, '妖魔鬼怪都给我出来~~!!');
     return;
    end;
    if P_getitemcount(uSource, '梅花夫人书札') > 0 then
      P_MenuSay(uSource, '妖魔鬼怪都给我出来~~!!');
     return;
    end;
    if P_getitemcount(uSource, '药材商书札') > 0 then
      P_MenuSay(uSource, '妖魔鬼怪都给我出来~~!!');
     return;
    end;
    if P_getitemcount(uSource, '风兄书札') > 0 then
      P_MenuSay(uSource, '妖魔鬼怪都给我出来~~!!');
     return;
    end;
	P_deleteitem(uSource, '老板娘书札', 1, 'quest阴阳师');
    P_MenuSay(uSource, MainMenu_1);
   return;
  end;
  if aStr == 'close_1' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '阴阳师书札') > 0 then
      P_MenuSay(uSource, '妖魔鬼怪都给我出来~~!!');
     return;
    end;
	P_additem(uSource, '阴阳师书札', 1, 'quest阴阳师');
	return;
  end;
  if aStr == 'spirit' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '封印符') > 0 then
      P_MenuSay(uSource, '妖魔鬼怪都给我出来~~!!');
     return;
    end;
    if P_getitemcount(uSource, '封符') > 0 then
      P_MenuSay(uSource, '妖魔鬼怪都给我出来~~!!');
     return;
    end;
    if P_getitemcount(uSource, '阴阳师书札') < 1 then
      P_MenuSay(uSource, '妖魔鬼怪都给我出来~~!!');
     return;
    end;
    if P_getitemcount(uSource, '男尸的魂魄') < 20 then
      P_MenuSay(uSource, MainMenu_3);
     return;
    end;
	P_deleteitem(uSource, '男尸的魂魄', 20, 'quest阴阳师');
	P_additem(uSource, '封印符', 1, 'quest阴阳师');
	P_MenuSay(uSource, MainMenu_2);
   return;
  end;

  if aStr == 'close_2' then
   return;
  end;
  if aStr == 'continue' then
   return;
  end;
  if aStr == 'giveup' then
	P_deleteitem(uSource, '阴阳师书札', 1, 'quest阴阳师');
	P_deleteitem(uSource, '封印符', 1, 'quest阴阳师');
	local count = P_getitemcount(uSource, '男尸的魂魄');
	if count > 0 then 
	  P_deleteitem(uSource, '男尸的魂魄', count, 'quest阴阳师');
	end
	return;
  end;

  if aStr == 'seal' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '封印符') > 0 then
      P_MenuSay(uSource, MainMenu_3);
     return;
    end;
    if P_getitemcount(uSource, '封符') < 1 then
      P_MenuSay(uSource, '妖魔鬼怪都给我出来~~!!');
     return;
    end;
    if P_getitemcount(uSource, '阴阳师书札') < 1 then
      P_MenuSay(uSource, '妖魔鬼怪都给我出来~~!!');
     return;
    end;
	P_deleteitem(uSource, '阴阳师书札', 1, 'quest阴阳师');
	P_deleteitem(uSource, '封符', 1, 'quest阴阳师');
	P_MenuSay(uSource, MainMenu_4);

    math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
    math.random();
    local iRandom = math.random(3, 4);
    if iRandom == 0 then
	  --随机给物品
	  local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
	  if #AwardItem ~= 2 then 
        return;
	  end
	  P_additem(uSource, AwardItem[1], AwardItem[2], 'quest阴阳师');	
    end;
    if iRandom == 1 then
	  --随机给物品
	  local AwardItem = lua_Strtotable(M_GetQuestItem(6), ':');
	  if #AwardItem ~= 2 then 
        return;
	  end
	  P_additem(uSource, AwardItem[1], AwardItem[2], 'quest阴阳师');	
    end;
    if iRandom == 2 then
	  --随机给物品
	  local AwardItem = lua_Strtotable(M_GetQuestItem(7), ':');
	  if #AwardItem ~= 2 then 
        return;
	  end
	  P_additem(uSource, AwardItem[1], AwardItem[2], 'quest阴阳师');	
    end;
    if iRandom == 3 then
      if P_getitemcount(uSource, '招式全集') > 0 then
	    --随机给物品
	    local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
	    if #AwardItem ~= 2 then 
          return;
	    end
	    P_additem(uSource, AwardItem[1], AwardItem[2], 'quest阴阳师');	
	  else
		P_additem(uSource, '招式全集', 1, 'quest阴阳师');	
      end;
    end;
    if iRandom == 4 then
      if P_getitemcount(uSource, '四大神功全集') > 0 then
	    --随机给物品
	    local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
	    if #AwardItem ~= 2 then 
          return;
	    end
	    P_additem(uSource, AwardItem[1], AwardItem[2], 'quest阴阳师');	
	  else
		P_additem(uSource, '四大神功全集', 1, 'quest阴阳师');	
      end;
    end;
    return;
  end;
  if aStr == 'close_3' then
    return;
  end;

 return;
end