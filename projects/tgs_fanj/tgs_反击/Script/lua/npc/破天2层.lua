package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '破天2层';

local MainMenu =
[[
击杀所有怪物后可进入下一层^^
<『$00FFFF00| 进入 下一层』/@jr>
]];

--破天 随机进入地图
local pt_xy = {
  {285, 270},
  {288, 240},
  {268, 268},
  {267, 253},
};

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  --单人副本
  if aStr == 'jr' then
    --获取玩家基本属性
    local Attrib = P_GetAttrib(uSource);
    --判断年龄是否到达
    if Attrib.Age < 4000 then 
      P_MenuSay(uSource, '年龄尚未到达40岁!');
      return;
    end;
    --检测怪物数量
    local n = M_MapFindMonster(119, '', 2);
    if n > 0 then 
      P_MenuSay(uSource, string.format('歼灭怪物才能通过,怪物(%d)生存', n))
     return 'true';
    end;
    --传送到下一层
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = pt_xy[math.random(#pt_xy)];
	local X = t[1] - math.random(-4, 4);
	local Y = t[2] - math.random(-4, 4);
    P_MapMove(uSource, 120, X, Y, 0);	
    return;
  end;	
 return;
end