package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '帝王石谷酒母';

local MainMenu =
[[
廉价出售物品.高价收购物品 ^
^
<「游标.bmp」『$FF00FF00| 卖 物品』/@sell>^^
<「游标.bmp」『$FF00FF00| 买 物品』/@buy>^
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