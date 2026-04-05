package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '一级风兄';

local MainMenu =
[[
您想买点什么？^^
<「游标.bmp」『$FF00FF00| 买 物品』/@buy>
]];


function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;


 return;
end