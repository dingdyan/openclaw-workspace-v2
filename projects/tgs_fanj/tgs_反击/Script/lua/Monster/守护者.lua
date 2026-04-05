package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

--检测出现的角色触发
function OnCreate(uSource, uDest, aStr)
  --获取种族
  if B_GetRace(uDest) ~= 1 then
   return;
  end;
  --获取天关挑战ID
  local ids = P_GetTempArr(uDest, 1);
  if ids == 0 then ids = 1 end;
  --附加BUFF
  --if _Life[ids] ~= nil then 
  local lifetable = {damageBody = 100 * ids, armorBody = 50 * ids, AttackSpeed = -1 * ids, avoid = 2 * ids, recovery = -1 * ids, accuracy = 2 * ids};
    P_SetAddBuff(uSource, 1, '属性强化', 60 * 3, 1107, 0, string.format('天关[%d]层属性强化', ids), lifetable);
  --end;
  --判断BUFF
  if P_GetAddBuff(uDest, 19) > -1 then 
	P_SetAddBuff(uDest, 19, '君临天下', 0, 0, 0, '', {});
  end;
  return;
end;


--死亡
function OnDie(uSource, uDest, race)
  --获取种族
  local Race = B_GetRace(uSource);
  if Race ~= 1 then
    return;
  end;
  --获取天关挑战ID
  local ids = P_GetTempArr(uSource, 1);
  if ids == 0 then ids = 1 end;
  --增加天关ID
  P_SetTempArr(uSource, 1, ids + 1);
  --获取玩家名称
  local RealName = B_GetRealName(uSource);
  --写入MYSQL 方便排行
  local SQL = string.format('INSERT wxz_tianguan (playname, ids, times, life) values (\'%s\', %d, %d, 0) on DUPLICATE key update ids = %d, times = %d, life = 0', RealName, ids + 1, os.time(), ids + 1, os.time());
  M_DoMySql(SQL);
  --全服公告
  M_topmsg(string.format('恭喜[%s]挑战天关第[%d]层成功', RealName, ids), 16776960);
  --3秒后传送玩家
  P_MapMove(uSource, 1, 510, 490, 300);
 return;
end;

--周边玩家改变状态
function OnChangeState(uSource, uDest, aStr)
  if aStr ~= 'die' then
    return;
  end;
  --获取种族
  local Race = B_GetRace(uSource);
  if Race ~= 1 then
    return;
  end;
  --说话
  B_SayDelayAdd(uDest, '武功这么弱。。。自不量力的小子', 0);
  --获取伤害血量
  local DecLife = B_GetMaxLife(uDest) - B_GetCurLife(uDest);
  --提示
  P_saysystem(uSource, string.format('挑战失败,对守护者造成[%d]伤害', DecLife), 2);
  --写入MYSQL 方便排行
  local SQL = string.format('INSERT wxz_tianguan (playname, ids, times, life) values (\'%s\', 0, 0, %d) on DUPLICATE key update life = %d', B_GetRealName(uSource), DecLife, DecLife);
  M_DoMySql(SQL);
  return;
end;