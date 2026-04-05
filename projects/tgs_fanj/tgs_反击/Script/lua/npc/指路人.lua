package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '指路人';

local _cs = {
  [137] = {138, 20, 55},
  [138] = {139, 18, 32},
  [139] = {140, 20, 19},
}

local MainMenu =
[[
给我圣火令,即可进入下一层^^
<『$00FFFF00| 进入下一层』/@cs>
]];


function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'cs' then
    if P_getitemcount(uSource, '圣火令') < 1 then
	  P_MenuSay(uSource, '拥有[圣火令]才可进入');
     return;
    end;
    --删除道具
    P_deleteitem(uSource, '圣火令', 1, '指路人');
	local MapId, X, Y =  B_GetPosition(uSource);	
	local t = _cs[MapId];
	if t == nil then 
      P_MapMove(uSource, 1, 499, 499, 0);
      return;
	end;
    --传送到下一层
    P_MapMove(uSource, t[1], t[2], t[3], 0);
    return;
  end;
  
 return;
end