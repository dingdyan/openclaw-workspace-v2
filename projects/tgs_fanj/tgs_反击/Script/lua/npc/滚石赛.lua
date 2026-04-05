package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local ncount = 0;

local _item = {
  [1] = {'魔人内丹', 1},
  [2] = {'太极明珠', 1},
  [3] = {'狐狸内丹', 1},
  [4] = {'金元', 20},
  [5] = {'金元', 20},
  [6] = {'金元', 20},
  [7] = {'金元', 10},
  [8] = {'金元', 10},
  [9] = {'金元', 5},
  [10] = {'金元', 5},
};

--刷新触发
function OnRegen(uSource)
  ncount = 0;
end;

function OnMenu(uSource, uDest)
  --检测背包空位
  if P_getitemspace(uSource) < 1 then
    P_MenuSay(uSource, '物品栏已满!');
   return;
  end; 
  --增加排名
  ncount = ncount + 1;
  --检测是否有道具
  if _item[ncount] ~= nil then 
    --给予道具
	P_additem(uSource, _item[ncount][1], _item[ncount][2], '滚石竞赛');
    --全服公告
	M_worldnoticemsg(string.format('恭喜[%s]获得了滚石竞赛第%d名,给予奖励[%d个%s]', B_GetRealName(uSource), ncount, _item[ncount][2], _item[ncount][1]),  16777215, 3815994);
    --提示自己
	P_saysystem(uSource, string.format('恭喜你获得了滚石竞赛第%d名,给予奖励[%d个%s]', ncount, _item[ncount][2], _item[ncount][1]), 2);
  else
	P_saysystem(uSource, string.format('恭喜你获得了滚石竞赛第%d名,请再接再厉!', ncount), 2);
  end;
  --传送玩家
  P_MapMove(uSource, 1, 499, 499, 0);	
 return;
end
