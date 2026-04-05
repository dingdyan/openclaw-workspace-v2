package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '牢头';

local MainMenu =
[[
防挂问题回答错误进来，想离开?^
^
<『$00FFFF00| 贿赂牢头立马出去 100个交易币』/@cq>^
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	
  
  if aStr == 'cq' then
    if P_getitemcount(uSource, '交易币') < 100 then
      P_MenuSay(uSource, '快拿来100个交易币');
     return;
    end;
    P_deleteitem(uSource, '交易币', 100, '牢头');
	P_MapMove(uSource, 1, 499, 499, 0);
    return;
  end;	
	

 return;
end
