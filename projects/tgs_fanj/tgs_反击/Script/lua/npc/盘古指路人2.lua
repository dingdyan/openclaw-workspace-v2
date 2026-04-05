package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '地狱指路人';

local MapXy = {
  [128] = {
    ['MapID'] = 129,
    ['XY'] = {
	  {71, 131},
	},	
  },
  [129] = {
    ['MapID'] = 130,
    ['XY'] = {
	  {23, 56},
	},	
  },
}

local MainMenu =
[[击杀所有怪物,即可前往下一层区域^^
<「游标.bmp」『$FF00FF00| 传送进入下一层』/@cs>
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
	local n = M_MapFindMonster(129, '', 2);
    if n > 0 then
      P_MenuSay(uSource, string.format('剩余%d个怪物', n));
     return;
    end;
	 --获取地图ID
	local MapId, X, Y =  B_GetPosition(uDest);
	--获取坐标
	local XY = MapXy[MapId];
	if XY == nil then 
      P_MenuSay(uSource, '此区域不能传送');
     return;
	end 
	--传送
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random();
	local t = XY['XY'][math.random(#XY['XY'])];
    P_MapMove(uSource, XY['MapID'], t[1], t[2], 0);	
    return;
  end;
 return;
end