procedure OnCallObject(uHit, uSelf: integer);
begin
  if MapFindMonster('黄金沙漠', '远距离野神族2', 'all') > 0 then exit;
  MapAddmonster('黄金沙漠', '远距离野神族2', 360, 388, 1, 0, '', 0, 0,TRUE);
  MapAddmonster('黄金沙漠', '远距离野神族2', 365, 392, 1, 0, '', 0, 0,TRUE);
  MapAddmonster('黄金沙漠', '远距离野神族2', 370, 388, 1, 0, '', 0, 0,TRUE);
  MapAddmonster('黄金沙漠', '远距离野神族2', 364, 383, 1, 0, '', 0, 0,TRUE);
end;

