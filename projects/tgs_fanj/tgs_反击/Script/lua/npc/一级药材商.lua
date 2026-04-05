package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '一级药材商';

local MainMenu =
[[
低价出售物品!高价回收物品!^^
<「游标.bmp」『$FF00FF00| 买 物品』/@buy>^^
<「游标.bmp」『$FF00FF00| 卖 物品』/@sell>^
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