package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

--刷新
function OnRegen(uSource)
  --查找地图中怪物是否存在
  if M_MapFindMonster(1, '九尾狐变身', 0) > 0 then
	M_worldnoticemsg('<九尾狐变身>：这次就放过你们!', 15644416, 4849713);
	M_MapDelMonster(1, '九尾狐变身'); --直接删除九尾狐变身
  end
  --查找地图中NPC是否存在
  if M_MapFindNPC(1, '九尾狐酒母', 0) <= 0 then
	M_MapAddNPC(1, '九尾狐酒母', 205, 366, 1, 4, '', 1, 0, 0);
  end
end;
