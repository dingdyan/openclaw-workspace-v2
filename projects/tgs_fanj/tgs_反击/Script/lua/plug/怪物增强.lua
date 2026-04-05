--怪物公告
local NoMonster = {

};

--击杀怪物公告触发
function CheckNoMonster(uSource, MonsterName)	
  if NoMonster[MonsterName] ~= nil then 
    M_topmsg(string.format('玩家[%s]击杀了[%s]', B_GetRealName(uSource), MonsterName), 15527148);
  end;
end
