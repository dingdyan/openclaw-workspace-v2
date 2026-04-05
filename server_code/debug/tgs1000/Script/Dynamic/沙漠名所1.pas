procedure OnCallObject(uHit, uSelf: integer);
begin
   if MapFindMonster('黄金沙漠', '远距离野神族2', 'all') > 0 then exit;
  MapAddmonster('黄金沙漠', '远距离野神族2', 396, 129, 1, 0, '', 0, 0,TRUE);
  MapAddmonster('黄金沙漠', '远距离野神族2', 384, 129, 1, 0, '', 0, 0,TRUE);
  MapAddmonster('黄金沙漠', '远距离野神族2', 390, 125, 1, 0, '', 0, 0,TRUE);
  MapAddmonster('黄金沙漠', '远距离野神族2', 390, 133, 1, 0, '', 0, 0,TRUE);
end;
