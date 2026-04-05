package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '安全传送员';

local MainMenu =
[[
你好，给我10交易币或者50个新手生药可离开安全地^
购买VIP后，可以原地复活哦^
^
<『$00FFFF00| 给予 10个交易币』/@cq1>^
<『$00FFFF00| 给予 500个肉』/@cq2>^
<『$00FFFF00| 给予 50个新手生药』/@cq3>^
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
    if P_getitemcount(uSource, '交易币') < 10 then
      P_MenuSay(uSource, '没有10个交易币');
     return;
    end;
    P_deleteitem(uSource, '交易币', 10, '安全传送员');
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
    P_deleteitem(uSource, '新手生药', 50, '安全传送员');
	P_MapMove(uSource, 1, 499, 499, 0);
    return;
  end;	
	

 return;
end
