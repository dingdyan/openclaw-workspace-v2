package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

--随机物品(物品名,数量)
local RandomItem = {
  {'雕火龙套', 1}, 
  {'银狼破皇剑', 1}, 
  {'黄龙斧', 1}, 
  {'烈爪', 1}, 
  {'龙恨', 1}, 
  {'男子黄龙鞋', 1}, 
  {'女子黄龙鞋', 1}, 
  {'男子黄龙手套', 1}, 
  {'女子黄龙手套', 1}, 
  {'雕火龙套', 1}, 
  {'银狼破皇剑', 1}, 
  {'黄龙斧', 1}, 
  {'烈爪', 1}, 
  {'龙恨', 1}, 
  {'男子黄龙鞋', 1}, 
  {'女子黄龙鞋', 1}, 
  {'男子黄龙手套', 1}, 
  {'女子黄龙手套', 1}, 
  {'黄龙弓', 1}, 
  {'黄龙斗甲', 1}, 
  {'男子黄龙弓服', 1}, 
  {'女子黄龙弓服', 1}, 
};

local Npc_Name = '一级僧侣';

local MainMenu =
[[
还望施主慈悲为怀，施舍些饭团给贫僧。^
佛祖保佑，阿弥陀佛。^
路见不平、拔剑相助，行侠仗义、除恶扬善。^^
阿弥陀佛,贫僧已吃饱饭团了,有多的饭团可在贫僧处换回钱币^^

<「游标.bmp」『$FF00FF00| 饭团兑换回钱币』/@geuyu>
]];


function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'geuyu' then
    --检测是否有饭团
	local num = P_getitemcount(uSource, '饭团');
	if num  < 1 then 
      P_MenuSay(uSource, '没有饭团还说什么！！');
      return;
    end;
    --删除物品
	P_deleteitem(uSource, '饭团', num, '一级僧侣');
    --给予钱币
	P_additem(uSource, '钱币', num * 40, '一级僧侣');
    --说话
	P_MenuSay(uSource, '给你兑换为钱币了.');
	
--[[    if P_getitemcount(uSource, '饭团') < 1 then 
      P_MenuSay(uSource, '没有饭团还说什么！！');
      return;
    end;
    --检测空位
    if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满');
      return;
    end;
    --删除物品
	P_deleteitem(uSource, '饭团', 1, '一级僧侣');
	B_SAY(uDest, '佛祖保佑..._南无阿弥陀佛....');
    --判断随机数
	if math.random(500) > 1 then 
	   return;
	end;
	--随机给东西
	local Item = RandomItem[math.random(#RandomItem)];
	if Item == nil then return end;
	P_additem(uSource, Item[1], Item[2], '一级僧侣');
	--说话
	B_SAY(uDest, '这不正是昨天在路上捡到的那件东西吗....');--]]
    return;
  end;
  
 return;
end