--打开触发
function OnTurnOn(uSource, uDest)
  local t1 = M_MapFindDynamicobject(118, '深渊神殿火炉1', 3);
  local t2 = M_MapFindDynamicobject(118, '深渊神殿火炉2', 3);
  local t3 = M_MapFindDynamicobject(118, '深渊神殿火炉3', 3);
  local t4 = M_MapFindDynamicobject(118, '深渊神殿火炉4', 3);
  local t5 = M_MapFindDynamicobject(118, '深渊神殿火炉5', 3);
  local t6 = M_MapFindDynamicobject(118, '深渊神殿火炉6', 3);
  local t7 = M_MapFindDynamicobject(118, '深渊神殿火炉7', 3);
  local t8 = M_MapFindDynamicobject(118, '深渊神殿火炉8', 3);
  t1 = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8;
  P_saysystem(uSource, '点亮火炉个数：' .. t1, 14);
  if t1 >= 8 then
    M_MapIceMonster(118, '铁轮战士', false);
    M_MapboNotHItMonster(118, '铁轮战士', false);
    M_MapIceMonster(118, '地狱之王', false);
    M_MapboNotHItMonster(118, '地狱之王', false);
    P_saysystem(uSource, '地狱之王：闯入者死！', 14);
  end;
end;

--关闭触发
function OnTurnOff(uSource)
  M_MapIceMonster(118, '铁轮战士', true);
  M_MapboNotHItMonster(118, '铁轮战士', true);
  M_MapIceMonster(118, '地狱之王', true);
  M_MapboNotHItMonster(118, '地狱之王', true);
end;

