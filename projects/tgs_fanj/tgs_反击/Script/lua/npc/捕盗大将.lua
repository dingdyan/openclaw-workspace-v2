package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '捕盗大将';


--三层升级
local _Magic = {
  ['寒阴指'] = 1,
  ['金刚指'] = 1,
};

local _Config = {
  [2] = {
    ['MapID'] = {78, 17, 23},
    ['Get'] = {'金元', 60},
    ['Grade'] = 0,
    ['NPC'] = '晋级2捕盗大将',
  },
  [3] = {
    ['MapID'] = {79, 17, 23},
    ['Get'] = {'金元', 80},
    ['Grade'] = 1,
    ['NPC'] = '晋级3捕盗大将',
  },
};

local MainMenu =
[[出售拳法武功密笈和门派相关物品！^
将门派石放地上,才能建立门派.^^
<「游标.bmp」『$FF00FF00| 买 物品』/@buy>^
]];


local MainMenu2 =
[[阁下应该不是邪恶之徒吧? 我可不希望恶人学习绝世武功.^^
<「游标.bmp」『$00FFFF00| 2级审核』/@up_2>^
<「游标.bmp」『$00FFFF00| 3级审核』/@up_3>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
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
    P_deleteitem(uSource, _tmp['Get'][1], _tmp['Get'][2], '捕盗大将');
    P_MapMove(uSource, _tmp['MapID'][1], _tmp['MapID'][2], _tmp['MapID'][3], 0);
    M_SetMapEnter(_tmp['MapID'][1], false);
    P_REFILL(uSource);
    return;
  end;
 return;
end