procedure OnTurnOn(uSource, uDest: integer);
begin
  if MapFindDynamicobject('太极密室', '火坛1', 'dos_Openned') < 1 then exit;
  if MapFindDynamicobject('太极密室', '火坛2', 'dos_Openned') < 1 then exit;
  if MapFindDynamicobject('太极密室', '火坛3', 'dos_Openned') < 1 then exit;
  if MapFindDynamicobject('太极密室', '火坛4', 'dos_Openned') < 1 then exit;
  MapboNotHItMonster('太极密室', '太极公子', false);
end;

procedure OnTurnOff(uSource: integer);
begin
  //取消攻击太极公子
  MapboNotHItMonster('太极密室', '太极公子', true);
end;

