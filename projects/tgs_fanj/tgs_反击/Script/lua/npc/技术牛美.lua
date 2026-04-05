package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '技术牛美';

local MainMenu =
[[
 专业铸造师 牛美^
 需要帮助吗?^^
<「游标.bmp」『$00FFFF00| 买 物品』/@buy>^
<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>^
<「游标.bmp」『$00FFFF00| 成为铸造师』/@alchemist>^
<「游标.bmp」『$00FFFF00| 要求转职为铸造师』/@reqchange>^
<「游标.bmp」『$00FFFF00| 请教铸造术』/@jobhelp>^
<「游标.bmp」『$00FFFF00| 选神工之路』/@virtueman>
]];


local MainMenu_2 =
[[
 真要转职吗?^
^
<「游标.bmp」『$00FFFF00| 转职』/@change>^
<「游标.bmp」『$00FFFF00| 稍加考虑』/@close>
]];

local MainMenu_3 =
[[
制炼武器的技术,透过铸造术可以制造出多样武器,^
这需要有决定基本强度的铁矿与皮革与决定其特性的^
宝石/金属/岩石,最后还需要将此类材料融合的水石.
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'alchemist' then
    if P_GetJobKind(uSource) ~= 0 then 
      P_MenuSay(uSource, '不能重复学习技能');
     return;
    end
    if P_getitemcount(uSource, '钱币') < 30000 then
      P_MenuSay(uSource, '持有的金额不足，需钱币30000.');
     return;
    end;
    P_deleteitem(uSource, '钱币', 30000, '技术牛美');
    P_SetJobKind(uSource, 1);
    P_MenuSay(uSource, '恭喜！恭喜！您是铸造师了～ ');
    return;
  end;
   
  if aStr == 'reqchange' then
     P_MenuSay(uSource, MainMenu_2);
   return;
  end;

  if aStr == 'change' then
    if P_GetJobKind(uSource) == 1 then 
      P_MenuSay(uSource, '你已是铸造师了');
     return;
    end
	local talent = P_Getsendertalent(uSource);
	if talent < 2000 or talent > 4000 then
      P_MenuSay(uSource, '想转职技能值要在20。00～40。00');
     return;
    end
    if P_getitemcount(uSource, '钱币') < 50000 then
      P_MenuSay(uSource, '转职费用为钱币50000');
     return;
    end;
    P_deleteitem(uSource, '钱币', 50000, '技术牛美');
    P_SetJobKind(uSource, 1);
    P_MenuSay(uSource, '恭喜你有了新的职业');
    return;
  end;

  if aStr == 'virtueman' then 
    local grade = P_Getjobgrade(uSource);
    if grade == 6 then 
      P_MenuSay(uSource, '你已经是神工了');
     return;
    end
    if grade ~= 5 then 
      P_MenuSay(uSource, '还不具备资格~');
     return;
    end
    P_MenuSay(uSource, '去找龙师傅问问 得到顶级技能书^也许知晓升为神工的秘诀');
    return;
  end;

  if aStr == 'jobhelp' then
     P_MenuSay(uSource, MainMenu_3);
   return;
  end;

 return;
end