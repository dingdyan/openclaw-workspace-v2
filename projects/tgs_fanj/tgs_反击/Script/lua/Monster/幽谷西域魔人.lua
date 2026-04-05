package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local n = 0;

--刷新触发
function OnRegen(uDest)
  n = 0;
  local MapId, AX, AY = B_GetPosition(uDest);
  M_MapIceMonster(MapId, '右下小鬼', true);
  M_MapboNotHItMonster(MapId, '右下小鬼', true);

  M_MapIceMonster(MapId, '右中小鬼', true);
  M_MapboNotHItMonster(MapId, '右中小鬼', true);

  M_MapIceMonster(MapId, '正上小鬼', true);
  M_MapboNotHItMonster(MapId, '正上小鬼', true);

  M_MapIceMonster(MapId, '左上小鬼', true);
  M_MapboNotHItMonster(MapId, '左上小鬼', true);

  M_MapIceMonster(MapId, '左下小鬼', true);
  M_MapboNotHItMonster(MapId, '左下小鬼', true);
end;


--死亡
function OnDie(uSource, uDest, race)
  if race ~= 1 then
   return
  end

  n = n + 1;

  local MapId, AX, AY = B_GetPosition(uDest);

  if n ~= 6 then
	B_SAY(uDest, '好身手...');	
  end

  if n == 1 then
    M_MapIceMonster(MapId, '右下小鬼', false);
    M_MapboNotHItMonster(MapId, '右下小鬼', false);
    M_MapObjSay(MapId, '药王谷:右下方可以进入了', 15);
    return;
  end

  if n == 2 then
    M_MapIceMonster(MapId, '右中小鬼', false);
    M_MapboNotHItMonster(MapId, '右中小鬼', false);
    M_MapObjSay(MapId, '药王谷:右中方可以进入了', 15);
    return;
  end

  if n == 3 then
    M_MapIceMonster(MapId, '正上小鬼', false);
    M_MapboNotHItMonster(MapId, '正上小鬼', false);
    M_MapObjSay(MapId, '药王谷:正上方可以进入了', 15);
    return;
  end

  if n == 4 then
    M_MapIceMonster(MapId, '左上小鬼', false);
    M_MapboNotHItMonster(MapId, '左上小鬼', false);
    M_MapObjSay(MapId, '药王谷:左上方可以进入了', 15);
    return;
  end

  if n == 5 then
    M_MapIceMonster(MapId, '左下小鬼', false);
    M_MapboNotHItMonster(MapId, '左下小鬼', false);
    M_MapObjSay(MapId, '药王谷:左下方可以进入了', 15);
    return;
  end

  if n == 6 then
    P_MapMove(uSource, MapId, 95, 114, 300);
    M_MapObjSay(MapId, '药王谷:药王谷主来了_做好准备', 15);
	
    M_MapSendSound(MapId, 9349);
	M_MapAddMonster(MapId, '幽谷女帝', 94, 114, 4, 4, '', 0, 0, true, 400);
    return;
  end
end;