--攻击触发
function OnHit(uSource, uDest, declife)
  --获取种族
  if B_GetRace(uSource) ~= 1 then
   return;
  end;
  --推开攻击对象
  B_RePosition(uDest, uSource);
  --反弹伤害
  B_ReToturnDamage(uDest, uSource, declife, 20);
end;

--死亡
function OnDie(uSource, uDest, race)
  M_MapRegenDynamicObject(34, '霸王石');
  M_MapRegenMonster(34, '地下石巨人');
end;