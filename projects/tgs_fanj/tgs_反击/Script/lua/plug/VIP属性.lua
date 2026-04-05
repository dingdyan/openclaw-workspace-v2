--门派系统
VipAttrib = {
  name = {
    [1] = '练气期', 
    [2] = '筑基期?', 
	[3] = '结丹期',
	[4] = '元婴期', 
    [5] = '化神期', 
	[6] = '炼虚期',
	[7] = '合体期', 
    [8] = '大乘期', 
	[9] = '渡劫期',
  },
  sx = {
  [1] = {accuracy = 1, recovery = 1, armorBody = 0, avoid = 1}, 
  [2] = {accuracy = 2, recovery = 2, armorBody = 0, avoid = 2}, 
  [3] = {accuracy = 3, recovery = 3, armorBody = 0, avoid = 3}, 
  [4] = {accuracy = 4, recovery = 4, armorBody = 0, avoid = 4}, 
  [5] = {accuracy = 5, recovery = 5, armorBody = 20, avoid = 5, damageBody = 20}, 
  [6] = {accuracy = 6, recovery = 6, armorBody = 30, avoid = 6, damageBody = 30}, 
  [7] = {accuracy = 7, recovery = 7, armorBody = 40, avoid = 7, damageBody = 40}, 
  [8] = {accuracy = 8, recovery = 8, armorBody = 50, avoid = 8, damageBody = 50}, 
  [9] = {accuracy = 10, recovery = 10, armorBody = 80, avoid = 10, damageBody = 80, AttackSpeed = -1}, 
 }
};

--登录属性触发
VipAttrib.open = function(uSource)
  --获取VIP信息
  local viplevel, viptime = P_GetVipInfo(uSource);
  if viplevel < 1 then 
   return 'true';
  end;
  --VIP属性
  if VipAttrib.sx[viplevel] == nil then 
   return 'true';
  end;
  --附加玩家属性
  P_SetAddLifeData(uSource, 5, VipAttrib.name[viplevel], 3600 * 2400, VipAttrib.sx[viplevel]);
  --返回提示
  P_saysystem(uSource, string.format('激活[%s]属性:%s', VipAttrib.name[viplevel], _GetAttribInfo(VipAttrib.sx[viplevel])), 17);
 return;
end;

--关闭属性触发
VipAttrib.down = function(uSource)
  --获取VIP信息
  local viplevel, viptime = P_GetVipInfo(uSource);
  if viplevel < 1 then 
   return 'true';
  end;
  --获取buff状态
  P_SetAddLifeData(uSource, 5, '炼体属性', 3600 * 2400, {});
  P_saysystem(uSource, string.format('关闭了[%s]属性',VipAttrib.name[viplevel]), 14);
  return;
end;