package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '武学夫人';

local MainMenu =
[[出售一层武功，二层武功^^
<「游标.bmp」『$FF00FF00| 购买 武功秘籍』/@buy>^^
<「游标.bmp」『$FF00FF00| 回收 绝版武功』/@sell>^^
]];
--<「游标.bmp」『$00FFFF00| 回收 绝版武功』/@sell>^^
function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;
  
  if aStr == 'craftsman' then
    if P_GetJobKind(uSource) ~= 0 then 
      P_MenuSay(uSource, '不能重复学习技能');
     return;
    end
    if P_getitemcount(uSource, '钱币') < 30000 then
      P_MenuSay(uSource, '持有的金额不足，需钱币30000.');
     return;
    end;
    P_deleteitem(uSource, '钱币', 30000, '风兄');
    P_SetJobKind(uSource, 1);
    P_MenuSay(uSource, '恭喜！恭喜！开通成功了～ ');
    return;
  end;

 return;
end