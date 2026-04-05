package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '药材商';

local MainMenu =
[[
需要物品就到我这来吧!我也收购一些物品!^^
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