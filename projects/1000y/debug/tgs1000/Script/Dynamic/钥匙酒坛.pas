var
  log = false;

procedure OnTurnOn(uSource, uDest: integer);
var
  acount: Integer;
begin
  acount := 0;
  if MapFindDynamicobject('石棺洞', '钥匙酒坛', 'dos_Openned') = 5 then
  begin
    if log then worldnoticemsg('钥匙酒坛已全部打开', $00FF80FF, $00000000);
  end;
  if MapChangeDynamicobject('石棺洞', '铁闸门1', 'dos_Openning') = false then
  begin
    if log then worldnoticemsg('改变铁闸门1状态失败', $00FF80FF, $00000000);
    exit;
  end;
  if MapChangeDynamicobject('石棺洞', '铁闸门2', 'dos_Openning') = false then
  begin
    if log then worldnoticemsg('改变铁闸门2状态失败', $00FF80FF, $00000000);
    exit;
  end;
  if MapChangeDynamicobject('石棺洞', '铁闸门3', 'dos_Openning') = false then
  begin
    if log then worldnoticemsg('改变铁闸门3状态失败', $00FF80FF, $00000000);
    exit;
  end;
  if log then worldnoticemsg('改变铁闸门1,2,3状态成功', $00FF80FF, $00000000);

end;

