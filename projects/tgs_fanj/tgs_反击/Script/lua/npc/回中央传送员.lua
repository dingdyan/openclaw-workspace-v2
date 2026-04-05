package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '回中央传送员';

local MainMenu =
[[
给我1000钱币我送你回中央^
^
<『$00FFFF00| 给予 1000个钱币』/@cq1>^

]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	
  
  if aStr == 'cq1' then
    if P_getitemcount(uSource, '钱币') < 1000 then
      P_MenuSay(uSource, '没有1000个钱币');
     return;
    end;
    P_deleteitem(uSource, '钱币', 1000, '安全传送员');
	P_MapMove(uSource, 1, 499, 499, 0);
    return;
  end;	
	
  if aStr == 'cq2' then
    if P_getitemcount(uSource, '肉') < 500 then
      P_MenuSay(uSource, '没有500个肉');
     return;
    end;
    P_deleteitem(uSource, '交易币', 10, '安全传送员');
	P_MapMove(uSource, 1, 499, 499, 0);
    return;
  end;	
	
  if aStr == 'cq3' then
    if P_getitemcount(uSource, '新手生药') < 50 then
      P_MenuSay(uSource, '没有50个新手生药');
     return;
    end;
    P_deleteitem(uSource, '新手生药', 100, '安全传送员');
	P_MapMove(uSource, 1, 499, 499, 0);
    return;
  end;	
	

 return;
end
