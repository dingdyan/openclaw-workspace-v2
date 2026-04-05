--门派系统
GuildSys = {
  Level = {
    [1] = {damageBody = 20, damageHead = 0, damageArm = 0, damageLeg = 0, armorBody = 20, armorHead = 0, armorArm= 0, armorLeg= 0, AttackSpeed= 0, avoid= 2, recovery= 0, accuracy= 1, HitArmor=0}, 
    [2] = {damageBody = 30, damageHead = 0, damageArm = 0, damageLeg = 0, armorBody = 30, armorHead = 0, armorArm= 0, armorLeg= 0, AttackSpeed= 0, avoid= 4, recovery= 0, accuracy= 2, HitArmor=0}, 
    [3] = {damageBody = 60, damageHead = 0, damageArm = 0, damageLeg = 0, armorBody = 60, armorHead = 0, armorArm= 0, armorLeg= 0, AttackSpeed= 0, avoid= 6, recovery= 0, accuracy= 3, HitArmor=0}, 
    [4] = {damageBody = 80, damageHead = 0, damageArm = 0, damageLeg = 0, armorBody = 80, armorHead = 0, armorArm= 0, armorLeg= 0, AttackSpeed= 0, avoid= 8, recovery= 0, accuracy= 4, HitArmor=0}, 
	[5] = {damageBody = 120, damageHead = 0, damageArm = 0, damageLeg = 0, armorBody = 120, armorHead = 0, armorArm= 0, armorLeg= 0, AttackSpeed= 0, avoid= 10, recovery= 0, accuracy= 5, HitArmor=0}, 
  },
  Sys = {
    [1] = {AttackSpeed = -1, recovery = -2, avoid = 5, accuracy = 5, damageBody = 50, armorBody = 50},  -- 门主
    --[2] = {damageBody = 20, armorBody = 10},  --副门
  },
};

--登录属性触发
GuildSys.PlayGuild = function(uSource)
  --获取门派名称
  local GuildName = P_GuildGetName(uSource);
  if GuildName == '' then
   return
  end;
  --获取门派 MaxNum
  local MaxNum = M_GetGuildLevel(GuildName);
  --获取门派配置
  if GuildSys['Level'][MaxNum] ~= nil then
    --附加玩家属性
    P_SetAddLifeData(uSource, 4, '门派属性', 3600*24*30, GuildSys['Level'][MaxNum]);
    --返回提示
    P_saysystem(uSource, '激活门派属性:' .. _GetAttribInfo(GuildSys['Level'][MaxNum]), 17);
  end;
  --获取玩家名称
  local PlayName = B_GetRealName(uSource);	
  --获取职位等级
  local SysOp = M_IsGuildSysOp(GuildName, PlayName);
  if GuildSys.Sys[SysOp] ~= nil then 
    --附加玩家属性
    P_SetAddLifeData(uSource, 8, '门主属性', 3600*24*30, GuildSys.Sys[SysOp]);
    --返回提示
    P_saysystem(uSource, '激活门主属性:' .. _GetAttribInfo(GuildSys.Sys[SysOp]), 17);
  end;
 return;
end;

--关闭属性触发
GuildSys.QuitPlay = function(uSource)
  --获取门派名称
  local GuildName = P_GuildGetName(uSource);
  if GuildName == '' then
   return
  end;
  --附加玩家属性
  local LifeData = {damageBody = 0, damageHead = 0, damageArm = 0, damageLeg = 0, armorBody = 0, armorHead = 0, armorArm= 0, armorLeg= 0, AttackSpeed= 0, avoid= 0, recovery= 0, accuracy= 0, HitArmor=0};
  P_SetAddLifeData(uSource, 4, '门派属性', 3600*24*30, LifeData);
  P_SetAddLifeData(uSource, 8, '门主属性', 3600*24*30, LifeData);
  --返回提示
  P_saysystem(uSource, '[门派属性]与[门主属性]已关闭', 14);
 return;
end;