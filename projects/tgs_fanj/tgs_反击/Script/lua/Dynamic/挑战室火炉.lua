--打开触发
function OnTurnOn(uSource, uDest)
  local t1 = M_MapFindDynamicobject(110, '挑战室火炉1', 3);
  local t2 = M_MapFindDynamicobject(110, '挑战室火炉2', 3);
  local t3 = M_MapFindDynamicobject(110, '挑战室火炉3', 3);
  local t4 = M_MapFindDynamicobject(110, '挑战室火炉4', 3);
  t1 = t1 + t2 + t3 + t4;
  P_saysystem(uSource, '点亮火炉个数：' .. t1, 0);
  if t1 >= 4 then
    M_MapIceMonster(110, '云霄大帝', false);
    M_MapboNotHItMonster(110, '云霄大帝', false);
  end;
end;

--关闭触发
function OnTurnoff(uSource)
  M_MapIceMonster(110, '云霄大帝', true);
  M_MapboNotHItMonster(110, '云霄大帝', true);
end;