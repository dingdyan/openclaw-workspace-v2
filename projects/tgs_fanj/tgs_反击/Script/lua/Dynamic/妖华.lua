package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

--打开触发
function OnTurnOn(uSource, uDest)
  M_worldnoticemsg('【九尾狐变身】是谁杀了我的妖华？', 15644416, 4849713);
 -- M_MapDelNPC(1, '九尾狐酒母'); --直接删除九尾狐酒母
  --查找地图中怪物是否存在
  if M_MapFindMonster(1, '九尾狐变身', 0) <= 0 then
	M_MapAddMonster(1,'九尾狐变身', 130, 272, 1, 4, '', 0, 0, true, 0);
  end
end;