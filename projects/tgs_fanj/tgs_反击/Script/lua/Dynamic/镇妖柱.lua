--刷新触发
function OnRegen(uSource)
  --查找地图中怪物是否存在
  if M_MapFindMonster(1, '天魔兽', 0) > 0 then
	M_MapDelMonster(1, '天魔兽'); --直接删除九尾狐变身
  end
end;

--打开触发
function OnTurnOn(uSource, uDest)
  --查找地图中怪物是否存在
  if M_MapFindMonster(1, '天魔兽', 0) < 1 then
	M_MapAddMonster(1, '天魔兽', 525, 474, 1, 8, '', 0, 0, true, 0);
  end
end;

