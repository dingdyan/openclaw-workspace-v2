package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

--打开
function OnTurnOn(uSource, uDest)
  if M_MapFindDynamicobject(43, '被束缚的东天王', 1) < 1 then 
    return;
  end;
	

  if M_MapFindMonster(43, '东天王魂1', 0) > 0 then
    return;
  end

  --召唤怪物
  M_MapAddMonster(43, '东天王魂1', 458, 59, 1, 2, '', 0, 0, true, 200);
  M_MapAddMonster(43, '远距离野神族3', 456, 59, 1, 2, '', 0, 0, true, 200);
  M_MapAddMonster(43, '远距离野神族3', 458, 55, 1, 2, '', 0, 0, true, 200);
  M_MapAddMonster(43, '远距离野神族3', 458, 62, 1, 2, '', 0, 0, true, 200);
  M_MapAddMonster(43, '远距离野神族3', 463, 60, 1, 2, '', 0, 0, true, 200);
  --改变状态
  M_MapChangeDynamicobject(43, '被束缚的东天王', 2);
 return;
end;

--关闭
function OnTurnoff(uSource)
  if M_MapFindMonster(43, '东天王魂1', 0) > 0 then
    M_MapDelMonster(43, '东天王魂1');
    return;
  end

  if M_MapFindMonster(43, '远距离野神族3', 0) > 0 then
    M_MapDelMonster(43, '远距离野神族3');
    return;
  end
  return;
end;