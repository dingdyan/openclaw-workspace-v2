package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '传送员';

local MainMenu =
[[
击杀2层所有怪物后 可进入3层^^
<『$00FFFF00| 传送到3层』/@cs>^
]];

--随机进入地图
local xl_xy = {
  {98, 108},
  {92, 105},
  {94, 103},
  {96, 101},
  {93, 98},
  {90, 99},
  {87, 99},
  {89, 94},
  {83, 95},
  {84, 88},
  {86, 97},
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
	local n = M_MapFindMonster(171, '', 2);
    if n > 0 then
      P_MenuSay(uSource, string.format('剩余%d个怪物', n));
     return;
    end;
	--传送玩家
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = xl_xy[math.random(#xl_xy)];
    P_MapMove(uSource, 172, t[1], t[2], 0);	
    return;
  end;	

 return;
end

