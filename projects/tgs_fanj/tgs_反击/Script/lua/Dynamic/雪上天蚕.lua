function OnDropItem(uSource, uDest)
  B_DynamicobjectChange(uDest, 2);
end;

--´ò¿ª´¥·¢
function OnTurnOn(uSource, uDest)
  local MapId, AX, AY = B_GetPosition(uDest);
  M_MapSendSound(MapId, 9372);
end;
