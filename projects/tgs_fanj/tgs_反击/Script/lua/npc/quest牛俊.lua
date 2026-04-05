package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = 'quest牛俊';

local MainMenu =
[[
 哇啊啊..我的牛..怎么只傻看! 还不快帮忙!^^
<「游标.bmp」『$00FFFF00| 买 物品』/@buy>^
<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>^
<「游标.bmp」『$00FFFF00| 拿给 风兄书札』/@quest>^
<「游标.bmp」『$00FFFF00| 递上 所需物品』/@material>
]];

local MainMenu_1 =
[[
 这...这到底是~!^^
<「游标.bmp」『$00FFFF00| 怎么了?』/@q1_next>
]];

local MainMenu_2 =
[[
最近我的犀牛每天都会死一头.都是被猛兽给吃了.^
这样下去估计我们的牛就都只剩皮了!在下想亲自^
铲除了它们,又怕其它野兽趁我不在过来偷袭.^
^
<「游标.bmp」『$00FFFF00| 我帮你铲除猛兽』/@q2_next>
]];


local MainMenu_3 =
[[
好!长话短说.要按照这书札上写的,赶紧将^
猛兽们都赶走.这下总算可以松口气了!!
]];

local MainMenu_4 =
[[
多谢...将它挂到上面,猛兽就再也不能接近了.^
这段时间死了这么多牛,让洒家实在心痛.^
好了,这是你的酬劳,不成敬意,请阁下笑纳.
]];

local MainMenu_5 =
[[
请侠士抓紧时间!! 犀牛都快死光了!!^
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
    if P_getitemcount(uSource, '风兄书札') < 1 then
      P_MenuSay(uSource, '谁敢打我牛的主意,我可不客气啦!!');
     return;
    end;
    if P_getitemcount(uSource, '老板娘书札') > 0 then
      P_MenuSay(uSource, '谁敢打我牛的主意,我可不客气啦!!');
     return;
    end;
    if P_getitemcount(uSource, '梅花夫人书札') > 0 then
      P_MenuSay(uSource, '谁敢打我牛的主意,我可不客气啦!!');
     return;
    end;
    if P_getitemcount(uSource, '药材商书札') > 0 then
      P_MenuSay(uSource, '谁敢打我牛的主意,我可不客气啦!!');
     return;
    end;
    if P_getitemcount(uSource, '铁匠书札') > 0 then
      P_MenuSay(uSource, '谁敢打我牛的主意,我可不客气啦!!');
     return;
    end;
	
    P_deleteitem(uSource, '风兄书札', 1, 'quest牛俊');
	P_MenuSay(uSource, MainMenu_1);

    if P_getitemcount(uSource, '牛俊书札') < 1 then
      P_additem(uSource, '牛俊书札', 1, 'quest牛俊');
    end;
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
    return;
  end;

  if aStr == 'material' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '牛俊书札') < 1 then
      P_MenuSay(uSource, '谁敢打我牛的主意,我可不客气啦!!');
     return;
    end;
    if P_getitemcount(uSource, '白虎牙') < 5 then
      P_MenuSay(uSource, MainMenu_5);
      return;
    end;
    if P_getitemcount(uSource, '老虎指甲') < 5 then
      P_MenuSay(uSource, MainMenu_5);
      return;
    end;
    if P_getitemcount(uSource, '狼皮') < 5 then
      P_MenuSay(uSource, MainMenu_5);
      return;
    end;
	
    P_deleteitem(uSource, '白虎牙', 5, 'quest牛俊');
    P_deleteitem(uSource, '老虎指甲', 5, 'quest牛俊');
    P_deleteitem(uSource, '狼皮', 5, 'quest牛俊');
    P_deleteitem(uSource, '牛俊书札', 1, 'quest牛俊');

    P_MenuSay(uSource, MainMenu_4);
	
    math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
    math.random();
    local iRandom = math.random(3, 4);
	
    if iRandom == 0 then
	  local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
	  if #AwardItem ~= 2 then 
        return;
	  end
	  P_additem(uSource, AwardItem[1], AwardItem[2], 'quest牛俊');	
      return;
    end;
    if iRandom == 1 then
	  local AwardItem = lua_Strtotable(M_GetQuestItem(6), ':');
	  if #AwardItem ~= 2 then 
        return;
	  end
	  P_additem(uSource, AwardItem[1], AwardItem[2], 'quest牛俊');	
      return;
    end;
    if iRandom == 2 then
	  local AwardItem = lua_Strtotable(M_GetQuestItem(7), ':');
	  if #AwardItem ~= 2 then 
        return;
	  end
	  P_additem(uSource, AwardItem[1], AwardItem[2], 'quest牛俊');	
      return;
    end;
    if iRandom == 3 then
      if P_getitemcount(uSource, '招式全集') > 0 then
        local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
        if #AwardItem ~= 2 then 
	      return;
        end
	    P_additem(uSource, AwardItem[1], AwardItem[2], 'quest牛俊');	
		return;
      end;
      P_additem(uSource, '招式全集', 1, 'quest牛俊');	
     return;
    end;
    if iRandom == 4 then
      if P_getitemcount(uSource, '四大神功全集') > 0 then
        local AwardItem = lua_Strtotable(M_GetQuestItem(3), ':');
        if #AwardItem ~= 2 then 
	      return;
        end
	    P_additem(uSource, AwardItem[1], AwardItem[2], 'quest牛俊');	
		return;
      end;
      P_additem(uSource, '四大神功全集', 1, 'quest牛俊');	
     return;
    end;
  end;
  if aStr == 'close_2' then
    return;
  end;
  if aStr == 'continue' then
    return;
  end;
  if aStr == 'giveup' then
    P_deleteitem(uSource, '牛俊书札', 1, 'quest牛俊');    
    return;
  end;

 return;
end