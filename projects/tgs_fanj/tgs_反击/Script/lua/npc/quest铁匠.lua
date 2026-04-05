package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = 'quest铁匠';

local delitem = {
  ['八卦牌1'] = 1,
  ['八卦牌2'] = 1,
  ['八卦牌3'] = 1,
  ['八卦牌4'] = 1,
  ['八卦牌5'] = 1,
  ['八卦牌6'] = 1,
  ['八卦牌7'] = 1,
  ['八卦牌8'] = 1,
  ['八卦牌9'] = 1,
  ['八卦牌10'] = 1,
  ['八卦牌11'] = 1,
  ['八卦牌12'] = 1,
  ['八卦牌13'] = 1,
  ['八卦牌14'] = 1,
  ['八卦牌15'] = 1,
  ['不羁浪人手套1'] = 1,
  ['不羁浪人手套2'] = 1,
  ['不羁浪人手套3'] = 1,
  ['不羁浪人剑1'] = 1,
  ['不羁浪人剑2'] = 1,
  ['不羁浪人剑3'] = 1,
  ['不羁浪人刀1'] = 1,
  ['不羁浪人刀2'] = 1,
  ['不羁浪人刀3'] = 1,
  ['不羁浪人枪1'] = 1,
  ['不羁浪人枪2'] = 1,
  ['不羁浪人枪3'] = 1,
  ['不羁浪人槌1'] = 1,
  ['不羁浪人槌2'] = 1,
  ['不羁浪人槌'] = 1,
};


local MainMenu_1 =
[[
 本人乃铁匠是也.很荣幸能为你效劳!^^
<「游标.bmp」『$00FFFF00| 买 物品』/@buy>^
<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>^
<「游标.bmp」『$00FFFF00| 递上 神秘箱子』/@quest>^
<「游标.bmp」『$00FFFF00| 交给 所需材料』/@givematerial>^
<「游标.bmp」『$00FFFF00| 修理 八卦牌与不羁浪人武器』/@fix>
]];

local MainMenu_2 =
[[
将神秘箱子做为补偿,可否?^
^
<「游标.bmp」『$00FFFF00| 可以』/@prize>^
<「游标.bmp」『$00FFFF00| 不可以』/@dontprize>
]];

local MainMenu_3 =
[[
说啥?箱子打不开?我看看...又破又烂还挺结实嘛.^
拿着!这是里面装着的东西.^
^
<「游标.bmp」『$00FFFF00| 好的』/@close_1>
]];

local MainMenu_4_1 =
[[
我可不是自吹自擂,整个长城以南属我造的锄头最好.^
长城以南各处铁匠们卖的青铜,钢铁,象牙锄头都是受^
我传授所制^
^
<「游标.bmp」『$00FFFF00| 下一步』/@q2_next1>
]];

local MainMenu_4_2 =
[[
阁下手中的可是"神秘箱子"如果是...就太好了.^
最近我正研究一种开采药材和矿石的新品种镐头，^
要比象牙锄头好用.^
是否能打开箱子让我瞧瞧.啊～果然不错,里面的^
东西正是我研究镐头要用到的.^
^
<「游标.bmp」『$00FFFF00| 下一步』/@q2_next2>
]];

local MainMenu_4_3 =
[[
手上有这么珍贵的材料.不如给我好了.^
我可用它研制新镐.不过若你不愿在下绝不勉强."^
^
<「游标.bmp」『$00FFFF00| 好. 都需要什么材料?』/@needmaterial>^
<「游标.bmp」『$00FFFF00| 拒绝』/@cancel>
]];

local MainMenu_4_4 =
[[
哈哈,还真是爽快.拿着,这里有做十字镐要用到的材料.^
凑齐了拿给我^
^
<「游标.bmp」『$00FFFF00| 好的』/@q2_1_close>
]];

local MainMenu_4_5 =
[[
你既然不想帮,也没办法.不过,侠士不如将"神秘箱子"^
卖给在下吧.^
]];

local MainMenu_4_6 =
[[
好,一个都不缺.^
我终于能造出性能更好的十字镐了.^
这个你一定要收.别客气!^
]];

local MainMenu_4_7 =
[[
书札上的东西一样儿都不能缺.继续努力吧^
^
<「游标.bmp」『$00FFFF00| 继续』/@continue>^
<「游标.bmp」『$00FFFF00| 放弃』/@giveup>
]];

local MainMenu_5 =
[[
这箱子好眼熟...好像在哪儿见过!!!对了,明明是^
老侠客来我这里定做武器时,用来装东西的.箱子这么^
破?不会是拿来装东西吧.到底要用在哪里.老侠客那儿^
也有些箱子,你不如去那儿问问^
^
<「游标.bmp」『$00FFFF00| 好的』/@q3_close>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu_1);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	

  --修理道具
  if aStr == 'fix' then
    P_MenuSay(uSource, '请放入需要修理的八卦牌或不羁武器^^<「游标.bmp」『$00FFFF00| 确认修理』/@qrfix>', true);
    P_ItemInputWindowsOpen(uSource, 0, '修理道具', '');
    P_setItemInputWindowsKey(uSource, 0, -1);
    return;
  end;

  if aStr == 'qrfix' then
    --判断投入道具
	local aKey = P_getItemInputWindowsKey(uSource, 0);
	if aKey < 0 or aKey > 47 then 
      P_MenuSay(uSource, '请放入需要修理的道具');
      return;
	end;
	local aItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	if aItemData == nil or aItemData.Name == '' or delitem[aItemData.Name] == nil then
      P_MenuSay(uSource, '没有放入道具或道具无法修理!');
      return;
	end;
	--获取修理价格
	local RepairPrice = P_GetItemRepairPrice(uSource, aKey);
	if RepairPrice <= 0 then 
      P_MenuSay(uSource, '道具无需修理');
      return;
	end;		
    if P_getitemcount(uSource, '钱币') < RepairPrice then
      P_MenuSay(uSource, string.format('连%s个钱币都没有吗?', RepairPrice));
     return;
    end;
	--维修道具
	if P_RepairItem(uSource, aKey) ~= 4 then 
      P_MenuSay(uSource, '道具修理失败');
      return;
	end
	--删除钱币
    P_deleteitem(uSource, '钱币', RepairPrice, 'quest铁匠');
	P_MenuSay(uSource, '道具修理成功!');
    return;
  end;

  if aStr == 'quest' then
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '神秘箱子') < 1 then
      P_MenuSay(uSource, '没看见我正忙着吗?!');
     return;
    end;

    --获取境界
	local nPower = P_GetEnergyLevel(uSource);

	if nPower < 1 then
      P_MenuSay(uSource, MainMenu_2);
     return;
	end;

	if nPower >= 1 then
      P_deleteitem(uSource, '神秘箱子', 1, 'quest铁匠');
	  --随机任务
      math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
      math.random();
      local iRandom = math.random(0, 2);
      if iRandom == 0 then
        P_MenuSay(uSource, MainMenu_3);
       return;
      end;
      if iRandom == 1 then
        if P_getitemcount(uSource, '高级象牙十字镐') > 0 then
          P_MenuSay(uSource, MainMenu_3);
          return;
        end;
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
      P_MenuSay(uSource, '没看见我正忙着吗?!');
     return;
    end;
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    P_deleteitem(uSource, '神秘箱子', 1, 'quest铁匠');
	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(1), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest铁匠');		
	P_MenuSay(uSource, '感谢你~这是给你的回报');
	return;
   end;

   if aStr == 'dontprize' then
    if P_getitemcount(uSource, '神秘箱子') < 1 then
      P_MenuSay(uSource, '没看见我正忙着吗?!');
     return;
    end;
    P_deleteitem(uSource, '神秘箱子', 1, 'quest铁匠');

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
      P_MenuSay(uSource, '没看见我正忙着吗?!');
     return;
    end;
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    P_deleteitem(uSource, '神秘箱子', 1, 'quest铁匠');
	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(2), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest铁匠');		
	P_MenuSay(uSource, '感谢你~这是给你的回报');
	return;
  end;

  if aStr == 'q2_next1' then
    P_MenuSay(uSource, MainMenu_4_2);
   return;
  end;
  if aStr == 'q2_next2' then
    P_MenuSay(uSource, MainMenu_4_3);
   return;
  end;
  if aStr == 'needmaterial' then
    P_MenuSay(uSource, MainMenu_4_4);
   return;
  end;
  if aStr == 'cancel' then
    P_MenuSay(uSource, MainMenu_4_5);
   return;
  end;   
  if aStr == 'q2_1_close' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '铁匠材料书札') > 0 then
      P_MenuSay(uSource, '没看见我正忙着吗?!');
     return;
    end;
	P_additem(uSource, '铁匠材料书札', 1, 'quest铁匠');		
   return;
  end;
  if aStr == 'q2_2_close' then
   return;
  end;

  if aStr == 'q2_3_close' then
   return;
  end;

  if aStr == 'givematerial' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '铁匠材料书札') < 1 then
      P_MenuSay(uSource, '没看见我正忙着吗?!');
     return;
    end;
    if P_getitemcount(uSource, '骨头') < 20 then
      P_MenuSay(uSource, MainMenu_4_7);
     return;
    end;
    if P_getitemcount(uSource, '碳酸水石') < 20 then
      P_MenuSay(uSource, MainMenu_4_7);
     return;
    end;
    if P_getitemcount(uSource, '钢铁') < 5 then
      P_MenuSay(uSource, MainMenu_4_7);
     return;
    end;
	
    P_deleteitem(uSource, '骨头', 20, 'quest铁匠');
    P_deleteitem(uSource, '碳酸水石', 20, 'quest铁匠');
    P_deleteitem(uSource, '钢铁', 5, 'quest铁匠');
    P_deleteitem(uSource, '铁匠材料书札', 1, 'quest铁匠');
	
	P_MenuSay(uSource, MainMenu_4_6);

	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(5), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest铁匠');	
	return;
  end;

  if aStr == 'continue' then
    return;
  end;

  if aStr == 'giveup' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '铁匠材料书札') < 1 then
      P_MenuSay(uSource, '没看见我正忙着吗?!');
     return;
    end;
    P_deleteitem(uSource, '铁匠材料书札', 1, 'quest铁匠');
    return;
  end;
  if aStr == 'q3_close' then
    if P_getitemcount(uSource, '铁匠书札') > 0 then
      P_MenuSay(uSource, '没看见我正忙着吗?!');
     return;
    end;
	P_additem(uSource, '铁匠书札', 1, 'quest铁匠');	
	return
  end;   

 return;
end