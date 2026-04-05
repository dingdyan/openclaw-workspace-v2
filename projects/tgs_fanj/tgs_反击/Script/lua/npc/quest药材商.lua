package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '药材商';
local MainMenu_1 =
[[
 我乃长城以南销售药材的药材商.^^
<「游标.bmp」『$00FFFF00| 赠送 神秘箱子』/@quest>^
<「游标.bmp」『$00FFFF00| 材料转送完毕』/@ok>^
<「游标.bmp」『$00FFFF00| 买 物品』/@buy>^
<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>
]];

local MainMenu_2 =
[[
 将神秘箱子作为回报你意下如何?^^
<「游标.bmp」『$00FFFF00| 好的』/@prize>^
<「游标.bmp」『$00FFFF00| 拒绝』/@dontprize>^
<「游标.bmp」『$00FFFF00| 关闭』/@close>
]];

local MainMenu_3 =
[[
这...这不是在下过世的父亲留下的遗物吗?几个月前^
遭到山贼洗劫,连父亲留下的唯一的东西也被抢走了.原^
以为再也找不回来了.没曾想...这个你一定要收下.此恩^
此德在下永生难忘.^
^
<「游标.bmp」『$00FFFF00| 收下』/@q1_close>
]];

local MainMenu_4_1 =
[[
唉~ 小生背上的药材似乎有千斤重~!!! ^
背上它走遍长城以南，就算有10个我这样的也无能为力。^
不知能否拜托侠士?^
^
<「游标.bmp」『$00FFFF00| 继续』/@q2_next1>
]];

local MainMenu_4_2 =
[[
你看看我这体格背着这些东西多不容易。^
我要扛着它到长城以南的3个村子做生意，^
给各地药材商供货.如果不及时送到,^
我这几年良好的信誉就会毁之一旦.^
不知侠士可否愿意帮小生代劳? ^
^
<「游标.bmp」『$00FFFF00| 接受』/@deliver>^
<「游标.bmp」『$00FFFF00| 拒绝』/@rejection>
]];

local MainMenu_4_3 =
[[
这正是我拜托他帮我弄的材料. 呵呵~那药材商果然言而有信...
]];

local MainMenu_4_4 =
[[
这是长城以南药材商让送来的? 嗯...果然不错...
]];

local MainMenu_4_5 =
[[
侠客好面熟? 可是药材商找来帮忙的吗? 
]];

local MainMenu_4_6 =
[[
山贼最可恶了. 无论你多辛苦,攒了多长时间,^
他都会给你洗劫一空..^
^
<「游标.bmp」『$00FFFF00| 继续』/@continue>^
<「游标.bmp」『$00FFFF00| 放弃』/@giveup>
]];

local MainMenu_5 =
[[
不久前,长城以南屈指可数的名医召告世人要找一种箱子.^
几乎所有的药都能亲自配得的名医,这回到底是要做什么呢.^
箱子到底有什么特别的成分呢？拿着，这是有相关神医的线^
索资料.我了解到的内容极为有限,你不如亲自找神医问问吧^
^
<「游标.bmp」『$00FFFF00| 继续』/@q3_close>
]];

local MainMenu_6 =
[[
我向来是廉价出售,高价收购的~^
^
<「游标.bmp」『$00FFFF00| 交给 所需材料』/@sendmaterial>
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
    if P_getitemcount(uSource, '神秘箱子') < 1 then
      P_MenuSay(uSource, '拿来神秘箱子吧');
     return;
    end;
--[[    Str := callfunc ('checksenderattribitem 9');
    if Str = 'true' then begin
      print ('say 给衣服染上色吧..');
      exit;
    end;--]]
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    --获取境界
	local nPower = P_GetEnergyLevel(uSource);

	if nPower < 1 then
      P_MenuSay(uSource, MainMenu_2);
     return;
	end;

	if nPower >= 1 then
      P_deleteitem(uSource, '神秘箱子', 1, 'quest药材商');
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
      P_MenuSay(uSource, '拿来神秘箱子吧');
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    --删除神秘箱子
    P_deleteitem(uSource, '神秘箱子', 1, 'quest药材商');
	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(1), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest药材商');		
	P_MenuSay(uSource, '感谢你~这是给你的回报');
    return;
  end;

  if aStr == 'dontprize' then
    if P_getitemcount(uSource, '神秘箱子') < 1 then
      P_MenuSay(uSource, '拿来神秘箱子吧');
     return;
    end;
    --删除神秘箱子
    P_deleteitem(uSource, '神秘箱子', 1, 'quest药材商');
	
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
      P_MenuSay(uSource, '拿来神秘箱子吧');
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;  
    --删除神秘箱子
    P_deleteitem(uSource, '神秘箱子', 1, 'quest药材商');
	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(2), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest药材商');		
	P_MenuSay(uSource, '感谢你~这是给你的回报');
	return;
  end;

  if aStr == 'deliver' then
	--检测背包空位
	if P_getitemspace(uSource) < 4 then
      P_MenuSay(uSource, '请保留物品栏4个空位...');
      return;
	end;  
    if P_getitemcount(uSource, '药材商材料书札') > 0 then
      P_MenuSay(uSource, '还未送达吗?..');
     return;
    end;
    if P_getitemcount(uSource, '药材商材料1') > 0 then
      P_MenuSay(uSource, '还未送达吗?..');
     return;
    end;
    if P_getitemcount(uSource, '药材商材料2') > 0 then
      P_MenuSay(uSource, '还未送达吗?..');
     return;
    end;
    if P_getitemcount(uSource, '药材商材料3') > 0 then
      P_MenuSay(uSource, '还未送达吗?..');
     return;
    end;

	P_additem(uSource, '药材商材料书札', 1, 'quest药材商');	
	P_additem(uSource, '药材商材料1', 1, 'quest药材商');	
	P_additem(uSource, '药材商材料2', 1, 'quest药材商');	
	P_additem(uSource, '药材商材料3', 1, 'quest药材商');	
	
	P_MenuSay(uSource, '速去速回~');
    return;
   end;

  if aStr == 'rejection' then
     return;
  end;
  if aStr == 'q2_close' then
     return;
  end;

  if aStr == 'q2_next1' then
     P_MenuSay(uSource, MainMenu_4_2);
    return;
  end;

  if aStr == 'q3_close' then
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '药材商材料书札') > 0 then
      P_MenuSay(uSource, '还未送达吗?');
     return;
    end;
	P_additem(uSource, '药材商材料书札', 1, 'quest药材商');	
	P_MenuSay(uSource, '速去速回~');
    return;
  end;

  if aStr == 'ok' then
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '药材商材料书札') < 1 then
      P_MenuSay(uSource, '给衣服染上色吧..');
     return;
    end;
    if P_getitemcount(uSource, '药材商材料1') > 0 then
      P_MenuSay(uSource, MainMenu_4_6);
     return;
    end;
    if P_getitemcount(uSource, '药材商材料2') > 0 then
      P_MenuSay(uSource, MainMenu_4_6);
     return;
    end;
    if P_getitemcount(uSource, '药材商材料3') > 0 then
      P_MenuSay(uSource, MainMenu_4_6);
     return;
    end;
	
	P_deleteitem(uSource, '药材商材料书札', 1, 'quest药材商');
	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(1), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], 'quest风兄');
	
    P_MenuSay(uSource, '在下在这儿谢过了!!多亏侠士相助,才能保住名声.');
   return;
  end;

  if aStr == 'continue' then
    return;
  end;

  if aStr == 'giveup' then
    P_deleteitem(uSource, '药材商材料书札', 1, 'quest药材商');
    P_deleteitem(uSource, '药材商材料1', 1, 'quest药材商');
    P_deleteitem(uSource, '药材商材料2', 1, 'quest药材商');
    P_deleteitem(uSource, '药材商材料3', 1, 'quest药材商');
	return;
  end;

 return;
end