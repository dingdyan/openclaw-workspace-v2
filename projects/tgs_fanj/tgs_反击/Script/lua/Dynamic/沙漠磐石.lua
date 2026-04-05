

--´ò¿ª´¥·¢
function OnTurnOn(uSource, uDest)
  local MapId, AX, AY = B_GetPosition(uDest);
  M_MapSendSound(MapId, 9374);
end;