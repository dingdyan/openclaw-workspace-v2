--打开触发
function OnTurnOn(uSource, uDest)
  local t1 = M_MapFindDynamicobject(76, '铜人室火炉1', 3);
  local t2 = M_MapFindDynamicobject(76, '铜人室火炉2', 3);
  local t3 = M_MapFindDynamicobject(76, '铜人室火炉3', 3);
  local t4 = M_MapFindDynamicobject(76, '铜人室火炉4', 3);
  t1 = t1 + t2 + t3 + t4;
  P_saysystem(uSource, '点亮火炉个数：' .. t1, 0);
  if t1 >= 4 then
    M_MapIceMonster(76, '禁地护卫武士', false);
    M_MapboNotHItMonster(76, '禁地护卫武士', false);
    P_saysystem(uSource, '禁地护卫武士：闯王陵者死！', 0);
  end;
end;

--关闭触发
function OnTurnOff(uSource)
  M_MapIceMonster(76, '禁地护卫武士', true);
  M_MapboNotHItMonster(76, '禁地护卫武士', true);
end;

