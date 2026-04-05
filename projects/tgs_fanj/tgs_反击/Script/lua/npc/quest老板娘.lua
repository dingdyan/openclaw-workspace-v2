package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = 'quest老板娘';

local MainMenu_1 =
[[
廉价出售，高价收购.^^
<「游标.bmp」『$00FFFF00| 买 物品』/@buy>^
<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>^
<「游标.bmp」『$00FFFF00| 拿出 神秘箱子』/@quest>^
<「游标.bmp」『$00FFFF00| 递上 帐本』/@paper>
]];

local MainMenu_2 =
[[
 将神秘箱子作为补偿如何?^
^
<「游标.bmp」『$00FFFF00| 好』/@prize>^
<「游标.bmp」『$00FFFF00| 不好』/@dontprize>
]];


local MainMenu_3 =
[[
这是什么箱子? 是给我的吗? 可以打开?^
嘎吱... 天啊...是宝石... 太感谢了.^
这是我的一点心意请一定要收下!^
^
<「游标.bmp」『$00FFFF00| 收下回礼』/@q1_close>
]];

local MainMenu_4 =
[[
气死人了!又来白喝!!!啊哟,客官别误会我可不是说您.^
前些日子不知从什么地方来了一些流氓,白吃白喝.^
刚开始看他们身上别着刀,有些害怕只求吃完快滚蛋.^
后来我得知他们是一些欺软怕硬的白痴.这些无赖,已经让^
我损失了好些钱了.^
^
<「游标.bmp」『$00FFFF00| 帮老板娘要帐』/@getpaper>^
<「游标.bmp」『$00FFFF00| 离开』/@goback>
]];

local MainMenu_4_1 =
[[
是...这话可当真?实在太感谢了~! 我这儿也别费^
力的想送什么了,^
就将收来的钱给你一半好了.
]];

local MainMenu_4_2 =
[[
这些流氓,要遭报应的.幸亏还收回点钱...这是^
给你的,答应将一半作为酬劳...
]];

local MainMenu_4_3 =
[[
还没拿到?继续被这些家伙敲诈我的店也快关门了...^
^
<「游标.bmp」『$00FFFF00| 继续』/@continue>^
<「游标.bmp」『$00FFFF00| 放弃』/@giveup>
]];


local MainMenu_5 =
[[
这箱子...似乎是前几天阴阳师让我帮他留意的啊.^
又破又烂不知道做什么使.最近这儿离不开人,^
可否有劳侠士亲自走一趟.^
^
<「游标.bmp」『$00FFFF00| 同意』/@q3_close>^
<「游标.bmp」『$00FFFF00| 拒绝』/@exit>
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
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    if P_getitemcount(uSource, '神秘箱子') < 1 then
      P_MenuSay(uSource, '我忙着呢!找我做甚?');
     return;
    end;

    --获取境界
	local nPower = P_GetEnergyLevel(uSource);

	if nPower < 1 then
      P_MenuSay(uSource, MainMenu_2);
     return;
	end;

	if nPower >= 1 then
      P_deleteitem(uSource, '神秘箱子', 1, 'quest老板娘');
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
        if P_getitemcount(uSource, '老板娘材料书札') < 1 then
          P_additem(uSource, '老板娘材料书札', 1, 'quest老板娘');	
        end;
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
      P_MenuSay(uSource, '我忙着呢!找我做甚?');
     return;
    end;
    if P_getitemcount(uSource, '神秘箱子') < 1 then
      P_MenuSay(uSource, '我忙着呢!找我做甚?');
     return;
    end;
    --删除神秘箱子
    P_deleteitem(uSource, '神秘箱子', 1, 'quest药材商');
	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(1), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest老板娘');		
	P_MenuSay(uSource, '感谢你~这是给你的回报');
   return;
  end;

  if aStr == 'dontprize' then
    if P_getitemcount(uSource, '神秘箱子') < 1 then
      P_MenuSay(uSource, '我忙着呢!找我做甚?');
     return;
    end;
    P_deleteitem(uSource, '神秘箱子', 1, 'quest老板娘');
	
    math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
    math.random();
    local iRandom = math.random(0, 2);
	
    if iRandom == 0 then
      P_MenuSay(uSource, MainMenu_3);
     return;
    end;
    if iRandom == 1 then
      P_MenuSay(uSource, MainMenu_4);
      if P_getitemcount(uSource, '老板娘材料书札') < 1 then
        P_additem(uSource, '老板娘材料书札', 1, 'quest老板娘');	
      end;
     return;
    end;
    if iRandom == 2 then
      P_MenuSay(uSource, MainMenu_5);
     return;
    end;
  end;

  if aStr == 'q1_close' then
    if P_getitemcount(uSource, '神秘箱子') < 1 then
      P_MenuSay(uSource, '我忙着呢!找我做甚?');
     return;
    end;
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    P_deleteitem(uSource, '神秘箱子', 1, 'quest老板娘');
	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(2), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest老板娘');		
	P_MenuSay(uSource, '感谢你~这是给你的回报');
	return;
  end;

  if aStr == 'getpaper' then
     P_MenuSay(uSource, MainMenu_4_1);
    return;
  end;

  if aStr == 'goback' then
    P_deleteitem(uSource, '老板娘材料书札', 1, 'quest老板娘');
    return;
  end;

  if aStr == 'q2_1_close' then
    return;
  end;

  if aStr == 'q2_2_close' then
    return;
  end;

  if aStr == 'continue' then
    return;
  end;

  if aStr == 'giveup' then
    P_deleteitem(uSource, '老板娘材料书札', 1, 'quest老板娘');
    return;
  end;

  if aStr == 'q3_close' then
    if P_getitemcount(uSource, '老板娘书札') > 0 then
      P_MenuSay(uSource, '我忙着呢!找我做甚?');
     return;
    end;
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
	P_additem(uSource, '老板娘书札', 1, 'quest老板娘');		
	return;
  end;   

  if aStr == 'paper' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    if P_getitemcount(uSource, '老板娘材料书札') < 1 then
      P_MenuSay(uSource, '我忙着呢!找我做甚?');
     return;
    end;
    if P_getitemcount(uSource, '帐本') < 1 then
      P_MenuSay(uSource, MainMenu_4_3);
     return;
    end;
    P_deleteitem(uSource, '老板娘材料书札', 1, 'quest老板娘');
    P_deleteitem(uSource, '帐本', 1, 'quest老板娘');
	
	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(1), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest老板娘');		
	
    P_MenuSay(uSource, MainMenu_4_2);
	
   return;
  end;
 return;
end