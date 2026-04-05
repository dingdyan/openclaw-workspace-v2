package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

--死亡
function OnDie(uSource, uDest, race)
  if race == 1 then
    local aStr = M_MapFindMonster(31, '石棺赦龙组', 2);
    local bStr = M_MapFindMonster(31, '石棺青龙刺客', 2);
    if (aStr == 0) and (bStr == 0) then
	  if M_MapFindDynamicobject(31, '蜡台', 3) == 6 then 
        M_MapChangeDynamicobject(31, '机关区域门', 2);
        B_ShowSound(uDest, 9171);
        M_MapObjSay(31, '机关区域门已开启', 2);
	  else
        P_saysystem(uSource, '点着火_门就被开启', 2);
	  end
      return;
    end;
    P_saysystem(uSource, '歼灭怪物_点着火_门就会自动开启', 2);
  end
end;