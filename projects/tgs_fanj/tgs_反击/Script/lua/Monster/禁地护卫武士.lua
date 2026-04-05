--死亡
function OnDie(uSource, uDest, race)
  --判断辅助武功
  if P_GetCurUseMagic(uSource, 4) ~= '' then
    P_saysystem(uSource, '不能使用辅助武功', 2);
    --传送
	P_MapMove(uSource, 1, 699, 689, 100);
   return;
  end;
  --查找地图中怪物是否存在
  if M_MapFindMonster(76, '禁地护卫武士', 2) <= 0 then
    P_saysystem(uSource, '移至王的寝宫', 2);
    P_MapMove(uSource, 77, 26, 46, 0);
   return;
  end
  P_saysystem(uSource, '解决所有怪物才能移至王的寝宫2', 2);
  return;
end;
