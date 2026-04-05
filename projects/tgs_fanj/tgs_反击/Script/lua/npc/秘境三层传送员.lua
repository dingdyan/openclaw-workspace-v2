package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '传送员';

local MainMenu =
[[
击杀3层所有怪物后 可进入佛天秘境密室^^
<『$00FFFF00| 传送到佛天秘境密室』/@cs>^
]];

--随机进入地图
local xl_xy = {
  {39, 47},
  {39, 54},
  {33, 55},
  {45, 54},
  {46, 62},
  {33, 63},
  {29, 58},
};

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'cs' then
	local n = M_MapFindMonster(172, '', 2);
    if n > 0 then
      P_MenuSay(uSource, string.format('剩余%d个怪物', n));
     return;
    end;
	--传送玩家
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = xl_xy[math.random(#xl_xy)];
    P_MapMove(uSource, 173, t[1], t[2], 0);	
    return;
  end;	

 return;
end

