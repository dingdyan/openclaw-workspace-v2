package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '打水老人';

local MainMenu =
[[
<「游标.bmp」『$00FFFF00| 免费 竹筒加水』/@js>^
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	
  
  
  --加水
  if aStr == 'js' then
      if P_getitemcount(uSource, '竹筒') < 1 and P_getitemcount(uSource, '大型竹筒') < 1 then
	    P_additem(uSource, '竹筒', 1, '帝王商人');
      end;
    local ids = P_FindItemName(uSource, '竹筒');
    if ids ~= -1 then 
	   P_SetItemDurability(uSource, ids, 5000);
	end;
    local ids = P_FindItemName(uSource, '大型竹筒');
    if ids ~= -1 then 
	   P_SetItemDurability(uSource, ids, 5000);
	end;
    local ids = P_FindItemName(uSource, '超级竹筒');
    if ids ~= -1 then 
	   P_SetItemDurability(uSource, ids, 5000);
	end;
	--说话
	P_MenuSay(uSource, '已为您背包里竹筒加满水了');
    return;
  end;
 return;
end
