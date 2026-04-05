package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Idx = 10;

local ItemTab = {
  ['女儿红'] = {
    ['Name'] = '女儿红',
    ['Time'] = 60 * 10,
    ['Info'] = '攻击增加百分之二十.',
    ['LifeData'] = {
	  damageBody = 20, damageHead = 0, damageArm = 0, damageLeg = 0, 
	  armorBody = 0, armorHead = 0, armorArm= 0, armorLeg= 0, 
	  AttackSpeed= 0, avoid= 0, recovery= 0, accuracy= 0, KeepRecovery=0
    },
    ['Icon'] = 1284,
    ['Eft'] = 0,
  },
  ['培元丹'] = {
    ['Name'] = '培元丹',
    ['Time'] = 60 * 10,
    ['Info'] = '防御增加百分之二十.',
    ['LifeData'] = {
	  damageBody = 0, damageHead = 0, damageArm = 0, damageLeg = 0, 
	  armorBody = 20, armorHead = 0, armorArm= 0, armorLeg= 0, 
	  AttackSpeed= 0, avoid= 0, recovery= 0, accuracy= 0, KeepRecovery=0
    },
    ['Icon'] = 1296,
    ['Eft'] = 0,
  },
  ['七星海棠'] = {
    ['Name'] = '七星海棠',
    ['Time'] = 60 * 15,
    ['Info'] = '攻击和命中增加百分之三十.',
    ['LifeData'] = {
	  damageBody = 30, damageHead = 0, damageArm = 0, damageLeg = 0, 
	  armorBody = 0, armorHead = 0, armorArm= 0, armorLeg= 0, 
	  AttackSpeed= 0, avoid= 0, recovery= 0, accuracy= 30, KeepRecovery=0
    },
    ['Icon'] = 1285,
    ['Eft'] = 0,
  },
  
  ['千年人参'] = {
    ['Name'] = '千年人参',
    ['Time'] = 60 * 30,
    ['Info'] = '攻击/躲闪/命中/防御增加百分之三十.',
    ['LifeData'] = {
	  damageBody = 30, damageHead = 0, damageArm = 0, damageLeg = 0, 
	  armorBody = 30, armorHead = 0, armorArm= 0, armorLeg= 0, 
	  AttackSpeed= 0, avoid= 30, recovery= 0, accuracy= 30, KeepRecovery=0
    },
    ['Icon'] = 336,
    ['Eft'] = 0,
  },
  
  ['天山雪莲'] = {
    ['Name'] = '天山雪莲',
    ['Time'] = 60 * 30,
    ['Info'] = '速度增加百分之二十.',
    ['LifeData'] = {
	  damageBody = 0, damageHead = 0, damageArm = 0, damageLeg = 0, 
	  armorBody = 0, armorHead = 0, armorArm= 0, armorLeg= 0, 
	  AttackSpeed= -20, avoid= 0, recovery= 0, accuracy= 0, KeepRecovery=0
    },
    ['Icon'] = 1291,
    ['Eft'] = 0,
    ['Mul'] = 1,
  },
  
};

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
   --获取KEY道具
   local ItemData = P_GetHaveItemInfoTabs(uSource, uItemKey);
   if ItemData == nil or ItemData.Name == nil or ItemTab[ItemData.Name] == nil then
     return;
   end;
   --检测道具数量
   if P_getitemcount(uSource, ItemData.Name) < 1 then 
	 P_saysystem(uSource, string.format('缺少道具:%s', ItemData.Name), 2);
     return;
   end
   --获取数据table
   local t = ItemTab[ItemData.Name];
   if t == nil then
     P_saysystem(uSource, '非法物品....', 2);
    return;
   end;		
   --获取当前BUFF信息
   local n = P_GetAddMulBuff(uSource, Idx);
   if n > 0 then 
     P_saysystem(uSource, '无法重复服用.', 2);
    return;
   end;
   --增加BUFF
   if t['Mul'] ~= 1 then 
     P_SetAddMulBuff(uSource, Idx, t['Name'], t['Time'], t['Icon'], t['Eft'], t['Info'], t['LifeData']);
   else
     P_SetAddBuff(uSource, Idx, t['Name'], t['Time'], t['Icon'], t['Eft'], t['Info'], t['LifeData']);
   end;
   --删除道具
   P_deleteitem(uSource, ItemData.Name, 1, ItemData.Name);
   --返回消息
   P_saysystem(uSource, string.format('【%s】服用成功', ItemData.Name), 2);
 return;
end