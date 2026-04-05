package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '上古指路人';

local MapXy = {
  [185] = {
    ['MapID'] = 186,
    ['XY'] = {
	  {165, 126},
	},	
  },
  [186] = {
    ['MapID'] = 187,
    ['XY'] = {
	  {58, 98},
	  {62, 22},
	},	
  },
}

local MainMenu =
[[清完怪物,即可前往下一层区域^^
<「游标.bmp」『$00FFFF00| 传送进入下一层』/@cs>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	

  --传送
  if aStr == 'cs' then
    --获取地图ID
	local MapId, X, Y =  B_GetPosition(uDest);
    --检测怪物数量
    local n = M_MapFindMonster(MapId, '', 2);
    if n > 0 then 
      P_MenuSay(uSource, string.format('歼灭怪物才能通过,怪物(%d)生存', n));
      return;
    end;
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

