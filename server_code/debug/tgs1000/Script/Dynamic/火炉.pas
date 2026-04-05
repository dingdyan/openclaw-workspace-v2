{******************************************************************************
石棺洞入口使用
******************************************************************************}

var
  log = false;

procedure OnTurnOn(uSource, uDest: integer);
begin
  if log then worldnoticemsg('=============================================================================', $00FF80FF, $00000000);
  if log then worldnoticemsg('打开中:' + inttostr(MapFindDynamicobject('长城以南', '火炉2', 'dos_Openning')), $00FF80FF, $00000000);
  if log then worldnoticemsg('完全打开' + inttostr(MapFindDynamicobject('长城以南', '火炉2', 'dos_Openned')), $00FF80FF, $00000000);
  if MapChangeDynamicobject('长城以南', '石棺洞入口', 'dos_Openning') = false then
  begin
    if log then worldnoticemsg('changedynobjstate打开 石棺洞入口 false', $00FF80FF, $00000000);
    exit;
  end else
  begin
    if log then worldnoticemsg('changedynobjstate打开 石棺洞入口 true', $00FF80FF, $00000000);
  end;
  if log then worldnoticemsg('=============================================================================', $00FF80FF, $00000000);

end;

