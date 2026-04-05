package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

--打开
function OnTurnOn(uSource, uDest)
  if M_MapFindDynamicobject(45, '被捆绑的北霸王', 1) < 1 then 
    return;
  end;
	

  if M_MapFindMonster(45, '北霸王魂1', 0) > 0 then
    return;
  end

  --召唤怪物
  M_MapAddMonster(45, '北霸王魂1', 237, 37, 1, 2, '', 0, 0, true, 200);
  M_MapAddMonster(45, '远距离野神族3', 234, 33, 1, 2, '', 0, 0, true, 200);
  M_MapAddMonster(45, '远距离野神族3', 241, 40, 1, 2, '', 0, 0, true, 200);
  M_MapAddMonster(45, '远距离野神族3', 237, 44, 1, 2, '', 0, 0, true, 200);
  M_MapAddMonster(45, '远距离野神族3', 230, 37, 1, 2, '', 0, 0, true, 200);
  --改变状态
  M_MapChangeDynamicobject(45, '被捆绑的北霸王', 2);
 return;
end;

--关闭
function OnTurnoff(uSource)
  if M_MapFindMonster(45, '北霸王魂1', 0) > 0 then
    M_MapDelMonster(45, '北霸王魂1');
    return;
  end

  if M_MapFindMonster(45, '远距离野神族3', 0) > 0 then
    M_MapDelMonster(45, '远距离野神族3');
    return;
  end
  return;
end;