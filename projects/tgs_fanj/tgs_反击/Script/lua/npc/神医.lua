package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '神医';

local MainMenu =
[[
廉价出售，高价收购.^^
<「游标.bmp」『$00FFFF00| 买 物品』/@buy>^
<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>^
<「游标.bmp」『$00FFFF00| 成为炼丹师』/@chemist>^
<「游标.bmp」『$00FFFF00| 要求转职为炼丹师』/@reqchange>^
<「游标.bmp」『$00FFFF00| 请教炼丹术』/@jobhelp>^
<「游标.bmp」『$00FFFF00| 询问有关加工事宜』/@processhelp>^
<「游标.bmp」『$00FFFF00| 迈向神工之任务』/@virtueman>
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
炼丹术是制造多种试剂的技术,^
炼丹师用各种草药与决定其作用的药材 作各种试剂
]];

local MainMenu_4 =
[[
 炼丹师加工处的试剂能将武器,衣服,饰品的潜在力发挥到最大^
 加工不太容易,但是当他的能力值足够制作辅助试剂时,加工将^
 会容易许多
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'chemist' then
    if P_GetJobKind(uSource) ~= 0 then 
      P_MenuSay(uSource, '不能重复学习技能');
     return;
    end
    if P_getitemcount(uSource, '钱币') < 30000 then
      P_MenuSay(uSource, '持有的金额不足，需钱币30000.');
     return;
    end;
    P_deleteitem(uSource, '钱币', 30000, '神医');
    P_SetJobKind(uSource, 2);
    P_MenuSay(uSource, '恭喜！恭喜！你是炼丹师了');
    return;
  end;
   
  if aStr == 'reqchange' then
     P_MenuSay(uSource, MainMenu_2);
   return;
  end;
  if aStr == 'change' then
    if P_GetJobKind(uSource) == 2 then 
      P_MenuSay(uSource, '你已是炼丹师了');
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
    P_deleteitem(uSource, '钱币', 50000, '神医');
    P_SetJobKind(uSource, 2);	
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

  if aStr == 'processhelp' then
     P_MenuSay(uSource, MainMenu_4);
   return;
  end;

 return;
end