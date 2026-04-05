package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '梅花夫人';

--三层升级
local _Magic = {
  ['凤凰雷电戟'] = 1,
  ['昭巫枪法'] = 1,
  ['乌龙索命枪'] = 1,
};

local _Config = {
  [2] = {
    ['MapID'] = {84, 17, 23},
    ['Get'] = {'金元', 60},
    ['Grade'] = 0,
    ['NPC'] = '晋级2梅花夫人',
  },
  [3] = {
    ['MapID'] = {85, 17, 23},
    ['Get'] = {'金元', 80},
    ['Grade'] = 1,
    ['NPC'] = '晋级3梅花夫人',
  },
};

local MainMenu =
[[
  出售枪法武功密笈^
  高手起码应该有个二层枪法武功密笈^^
<「游标.bmp」『$FF00FF00| 买 物品』/@buy>^
]];


local MainMenu2 =
[[
很有胆识嘛. 侠士想接受哪种审核?^^
<「游标.bmp」『$00FFFF00| 2级审核』/@up_2>^
<「游标.bmp」『$00FFFF00| 3级审核』/@up_3>
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


function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'givehairpin' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '梅花夫人材料书札') < 1 then
      P_MenuSay(uSource, '不如喝杯茶再走');
     return;
    end;
    if P_getitemcount(uSource, '玉簪') < 1 then
      P_MenuSay(uSource, MainMenu_4_4);
     return;
    end;

    P_deleteitem(uSource, '梅花夫人材料书札', 1, '梅花夫人');
    P_deleteitem(uSource, '玉簪', 1, '梅花夫人');
    P_MenuSay(uSource, MainMenu_4_3);
    return;
  end;

  if aStr == 'giveup' then
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
    if P_getitemcount(uSource, '梅花夫人材料书札') < 1 then
      P_MenuSay(uSource, '不如喝杯茶再走');
     return;
    end;
	
    P_deleteitem(uSource, '梅花夫人材料书札', 1, '梅花夫人');
	P_MenuSay(uSource, '不如喝杯茶再走');
	
	--随机给物品
	local AwardItem = lua_Strtotable(M_GetQuestItem(2), ':');
	if #AwardItem ~= 2 then 
      return;
	end
	P_additem(uSource, AwardItem[1], AwardItem[2], '梅花夫人');		
   return;
  end;

  if aStr == 'getquest' then
    P_MenuSay(uSource, MainMenu2);
    return;
  end;

  local Left, Right = lua_GetToken(aStr, '_');
  if Left == 'up' then
    local Index = tonumber(Right);
    if Index == nil then return end;
    local _tmp = _Config[Index];
    if _tmp == nil then return end;
    if P_CheckPowerWearItem(uSource) > 0 then 
      P_MenuSay(uSource, '为了公平起见,请脱掉将技能装备');
      return;
    end;
    if P_GetCurEnergyLevel(uSource) > 0 then 
      P_MenuSay(uSource, '禁止开镜进入');
      return;
    end;
    --获取当前武功
    local CurMagic = P_GetCurUseMagic(uSource, 0);
    if CurMagic == nil or _Magic[CurMagic] == nil then 
      P_MenuSay(uSource, string.format('%s无法在我这里升级', CurMagic));
     return;
    end
    local MagicLevel = P_GetMagicLevel(uSource, CurMagic);
    if MagicLevel ~= 9999 then 
      P_MenuSay(uSource, string.format('%s要修炼到99.99', CurMagic));
     return;
    end
    --获取当前等级
    local GradeUp = P_GetUseMagicGradeUp(uSource, 1);
    if GradeUp ~= _tmp['Grade'] then 
      P_MenuSay(uSource, string.format('%s不是%d级绝世武功', CurMagic, _tmp['Grade'] + 1));
     return;
    end
    --检测地图玩家数
    local iCount = M_MapUserCount(_tmp['MapID'][1]);
    if iCount > 0 then
      P_MenuSay(uSource, '考官忙_请稍后.');
     return;
    end;
    if M_MapFindNPC(_tmp['MapID'][1], _tmp['NPC'], 0) <= 0 then
      P_MenuSay(uSource, '考官忙_请稍后..');
     return;
    end
    if not M_GetMapEnter(_tmp['MapID'][1]) then 
      P_MenuSay(uSource, '考官忙_请稍后...');
     return;
    end
    if P_getitemcount(uSource, _tmp['Get'][1]) < _tmp['Get'][2] then
       P_MenuSay(uSource, string.format('考费,%d个%s', _tmp['Get'][2], _tmp['Get'][1]));
      return;
    end;
    if not M_MapRegen(_tmp['MapID'][1]) then 
      P_MenuSay(uSource, '考官忙_请稍后....');
     return;
    end
    P_deleteitem(uSource, _tmp['Get'][1], _tmp['Get'][2], '白捕校');
    P_MapMove(uSource, _tmp['MapID'][1], _tmp['MapID'][2], _tmp['MapID'][3], 0);
    M_SetMapEnter(_tmp['MapID'][1], false);
    P_REFILL(uSource);
    return;
  end;

 return;
end