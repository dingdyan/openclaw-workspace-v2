var
  log = false;

procedure OnTurnOn(uSource, uDest: integer);
begin
  if HIT_Screen(uDest, 3000) then
  begin
    if log then worldnoticemsg('È«ÆÁ¹¥»÷³É¹¦', $00FF80FF, $00000000);
    exit;
  end else
  begin
    if log then worldnoticemsg('È«ÆÁ¹¥»÷Ê§°Ü', $00FF80FF, $00000000);
  end;
end;

