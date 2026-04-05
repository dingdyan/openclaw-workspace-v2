procedure OnNpcMenu(uSource, uDest :integer);
begin
  menusay(uSource, '赶快守城去!还在这里干什么？^^'
    + '<〖获取反击状态〗/@setfanji>');
end;

procedure setfanji(uSource, uDest :integer);
begin
  NewCounterAttack_hit(uSource, true, 24);
end;

procedure OnDie(uSource, uDest :integer; aRACE :integer);
begin
  worldnoticemsg('鄱阳公主：我们已经失败了！', $00FF80FF, $00000000);
  setServerTempVar(0, 4);
end;

