package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '材料商人';

local MainMenu =
[[
需要技能材料吗？廉价出售！^
^^
<『$00FFFF00| 买 物品』/@buy>^
<『$00FFFF00| 卖 物品』/@sell>
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