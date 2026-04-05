package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '书札僧';

local MainMenu =
[[
低价出售书札!高价收购好的物品!^^
<「游标.bmp」『$FF00FF00| 买 书札』/@buy>^^
<「游标.bmp」『$FF00FF00| 卖 陶器瓷器』/@sell>^
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;
end