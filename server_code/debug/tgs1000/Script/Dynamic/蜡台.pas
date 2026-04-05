var
  log = false;

procedure OnTurnOn(uSource, uDest: integer);
var
  ncount: integer;
begin
  ncount := 0;
//蜡台被点燃的数量
  if MapFindDynamicobject('石棺洞', '蜡台', 'dos_Openned') >= 6 then inc(ncount);
  //怪物的数量
  if MapFindMonster('石棺洞', '石棺赦龙组', 'live') <= 0 then inc(ncount);
  if MapFindMonster('石棺洞', '石棺青龙刺客', 'live') <= 0 then inc(ncount);

  if ncount < 3 then
  begin
    MapSendChatMsg('石棺洞','歼灭怪物_点着火_门就会自动开启', $00FF80FF);
    exit;
  end;
  if MapChangeDynamicobject('石棺洞', '机关区域门', 'dos_Openning') then
  begin
    MapSendChatMsg('石棺洞','门开启成功', $00FF80FF);
  end;
end;

