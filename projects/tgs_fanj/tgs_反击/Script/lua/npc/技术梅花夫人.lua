package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '技术梅花夫人';

local MainMenu =
[[
 专业裁缝 梅花夫人^
 需要帮助吗？^^
<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>^
<「游标.bmp」『$00FFFF00| 成为裁缝』/@designer>^
<「游标.bmp」『$00FFFF00| 转职为裁缝』/@reqchange>^
<「游标.bmp」『$00FFFF00| 请教裁剪术』/@jobhelp>^
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
裁剪术是制造衣物的技术。^
裁缝用皮和决定硬度的石灰质和^
决定其特性的金属/宝石/岩石，^
还有将它们融合到一块儿的水石。
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'designer' then
    if P_GetJobKind(uSource) ~= 0 then 
      P_MenuSay(uSource, '不能重复学习技能');
     return;
    end
    if P_getitemcount(uSource, '钱币') < 30000 then
      P_MenuSay(uSource, '持有的金额不足，需钱币30000.');
     return;
    end;
    P_deleteitem(uSource, '钱币', 30000, '技术梅花夫人');
    P_SetJobKind(uSource, 3);
    P_MenuSay(uSource, '恭喜！恭喜！您是裁缝了～ ');
    return;
  end;
   
  if aStr == 'reqchange' then
     P_MenuSay(uSource, MainMenu_2);
   return;
  end;
  if aStr == 'change' then
    if P_GetJobKind(uSource) == 3 then 
      P_MenuSay(uSource, '你已是裁缝了');
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
    P_deleteitem(uSource, '钱币', 50000, '技术梅花夫人');
    P_SetJobKind(uSource, 3);	
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