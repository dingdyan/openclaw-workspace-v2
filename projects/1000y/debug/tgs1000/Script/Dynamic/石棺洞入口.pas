var
  log = false;
 //入口关闭时熄灭所有火

procedure OnTurnOff(uSource: integer);
begin
  if log then worldnoticemsg('执行石棺洞脚本', $00FF80FF, $00000000);
  MapChangeDynamicobject('长城以南', '火炉2', 'dos_Closed');
  MapChangeDynamicobject('长城以南', '火炉2', 'dos_Closed');
  MapChangeDynamicobject('长城以南', '火炉2', 'dos_Closed');
end;

