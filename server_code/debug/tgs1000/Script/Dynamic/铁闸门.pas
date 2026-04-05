var
  log = false;

procedure OnTurnoff(uSource: integer);
begin
  MapRegenDynamicObject('Ê¯¹×¶´', 'Ô¿³×¾ÆÌ³');
  MapRegenDynamicObject('Ê¯¹×¶´', 'µç¾ÆÌ³');
  MapRegenDynamicObject('Ê¯¹×¶´', '±¬ÆÆ¾ÆÌ³');
  if log then worldnoticemsg('ËùÓÐ¾ÆÌ³¸Ä±ä×´Ì¬³É¹¦', $00FF80FF, $00000000);
end;

