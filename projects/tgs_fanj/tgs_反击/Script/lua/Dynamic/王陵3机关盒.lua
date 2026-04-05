--打开触发
function OnTurnOn(uSource, uDest)
  local t1 = M_MapFindDynamicobject(70, '王陵3机关盒', 0) - 1;
  P_saysystem(uSource, '剩余机关盒数量: ' .. t1, 14);
  if t1 <= 0 then
    P_saysystem(uSource, '雨中客: 闯王陵者死！', 14);
    M_MapChangeDynamicobject(70, '王陵铁栅栏', 2);
  end;
end;
