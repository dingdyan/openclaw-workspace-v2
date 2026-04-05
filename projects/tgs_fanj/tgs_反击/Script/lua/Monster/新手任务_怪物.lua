package.loaded['Script\\lua\\f'] = nil;
package.loaded['Script\\lua\\任务\\新手任务'] = nil;

require ('Script\\lua\\f');
require ("Script\\lua\\任务\\新手任务");

--刷新
function OnRegen(uSource)
end;


--死亡
function OnDie(uSource, uDest, race)
  if race == 1 then
    NewTask.MonsterDie(uSource, B_GetRealName(uDest));
  end
end;