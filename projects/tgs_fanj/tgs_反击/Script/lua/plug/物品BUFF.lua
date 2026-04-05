ItemBuff = {
  Idx = 10,
  item = {
    ['阴阳丹'] = {
      ['Name'] = '阴阳丹',
      ['Time'] = 60 * 10,
      ['Info'] = '增加三功10%^持续10分钟',
      ['LifeData'] = {
	    InPower = 10, OutPower = 10, Magic = 10, 
      },
      ['Icon'] = 330,
      ['Eft'] = 0,
    },
    ['金玉水'] = {
      ['Name'] = '金玉水',
      ['Time'] = 60 * 10,
      ['Info'] = '增加活力%10^持续10分钟',
      ['LifeData'] = {
	    Life = 10
      },
      ['Icon'] = 339,
      ['Eft'] = 0,
    },
    ['保身精'] = {
      ['Name'] = '保身精',
      ['Time'] = 60 * 10,
      ['Info'] = '增加身体破坏力10%^持续10分钟',
      ['LifeData'] = {
	    damageBody = 10, damageHead = 0, damageArm = 0, damageLeg = 0, 
	    armorBody = 0, armorHead = 0, armorArm= 0, armorLeg= 0, 
	    AttackSpeed= 0, avoid= 0, recovery= 0, accuracy= 0, KeepRecovery=0
      },
      ['Icon'] = 328,
      ['Eft'] = 0,
    },
    ['保身精[绑]'] = {
      ['Name'] = '保身精[绑]',
      ['Time'] = 60 * 10,
      ['Info'] = '增加身体破坏力10%^持续10分钟',
      ['LifeData'] = {
	    damageBody = 10, damageHead = 0, damageArm = 0, damageLeg = 0, 
	    armorBody = 0, armorHead = 0, armorArm= 0, armorLeg= 0, 
	    AttackSpeed= 0, avoid= 0, recovery= 0, accuracy= 0, KeepRecovery=0
      },
      ['Icon'] = 328,
      ['Eft'] = 0,
    },
    ['绿晶汤'] = {
      ['Name'] = '绿晶汤',
      ['Time'] = 60 * 10,
      ['Info'] = '增加身体防御10%^持续10分钟',
      ['LifeData'] = {
	    damageBody = 0, damageHead = 0, damageArm = 0, damageLeg = 0, 
	    armorBody = 10, armorHead = 0, armorArm= 0, armorLeg= 0, 
	    AttackSpeed= 0, avoid= 0, recovery= 0, accuracy= 0, KeepRecovery=0
      },
      ['Icon'] = 326,
      ['Eft'] = 0,
    },
    ['大丸丹'] = {
      ['Name'] = '大丸丹',
      ['Time'] = 60 * 15,
      ['Info'] = '破坏力(身体/头/臂/腿)+准确度增加50%^持续15分钟',
      ['LifeData'] = {
	    damageBody = 50, damageHead = 50, damageArm = 50, damageLeg = 50, 
	    armorBody = 0, armorHead = 0, armorArm= 0, armorLeg= 0, 
	    AttackSpeed= 0, avoid= 0, recovery= 0, accuracy= 50, KeepRecovery=0,
	    BowBodyArmor = 0,
      },
      ['Icon'] = 331,
      ['Eft'] = 0,
    },
    ['大丸丹[绑]'] = {
      ['Name'] = '大丸丹[绑]',
      ['Time'] = 60 * 15,
      ['Info'] = '破坏力(身体/头/臂/腿)+准确度增加30%^持续15分钟',
      ['LifeData'] = {
	    damageBody = 30, damageHead = 30, damageArm = 30, damageLeg = 30, 
	    armorBody = 0, armorHead = 0, armorArm= 0, armorLeg= 0, 
	    AttackSpeed= 0, avoid= 0, recovery= 0, accuracy= 30, KeepRecovery=0,
	    BowBodyArmor = 0,
      },
      ['Icon'] = 331,
      ['Eft'] = 0,
    },
    ['高丽红参'] = {
      ['Name'] = '高丽红参',
      ['Time'] = 60 * 15,
      ['Info'] = '防御(身体/头/臂/腿)+躲闪增加50%^持续15分钟',
      ['LifeData'] = {
	    damageBody = 0, damageHead = 0, damageArm = 0, damageLeg = 0, 
	    armorBody = 50, armorHead = 50, armorArm= 50, armorLeg= 50, 
	    AttackSpeed= 0, avoid= 50, recovery= 0, accuracy= 0, KeepRecovery=0,
	    BowBodyArmor = 0,
      },
      ['Icon'] = 337,
      ['Eft'] = 0,
    },
    ['千年山参'] = {
      ['Name'] = '千年山参',
      ['Time'] = 60 * 30,
      ['Info'] = '攻击防御(身体/头/臂/腿)+躲闪+命中增加50%^持续30分钟',
      ['LifeData'] = {
	    damageBody = 50, damageHead = 50, damageArm = 50, damageLeg = 50, 
	    armorBody = 50, armorHead = 50, armorArm= 50, armorLeg= 50, 
	    AttackSpeed= 0, avoid= 50, recovery= 0, accuracy= 50, KeepRecovery=0
      },
      ['Icon'] = 336,
      ['Eft'] = 0,
    },
    ['大丸丹(绑定)'] = {
      ['Name'] = '大丸丹(绑定)',
      ['Time'] = 60 * 15,
      ['Info'] = '破坏力(身体/头/臂/腿)+准确度增加50%^持续15分钟',
      ['LifeData'] = {
	    damageBody = 50, damageHead = 50, damageArm = 50, damageLeg = 50, 
	    armorBody = 0, armorHead = 0, armorArm= 0, armorLeg= 0, 
	    AttackSpeed= 0, avoid= 0, recovery= 0, accuracy= 50, KeepRecovery=0
      },
      ['Icon'] = 331,
      ['Eft'] = 0,
    },
    ['千年山参(绑定)'] = {
      ['Name'] = '千年山参(绑定)',
      ['Time'] = 60 * 30,
      ['Info'] = '攻击防御(身体/头/臂/腿)+躲闪+命中增加50%^持续30分钟',
      ['LifeData'] = {
	    damageBody = 50, damageHead = 50, damageArm = 50, damageLeg = 50, 
	    armorBody = 50, armorHead = 50, armorArm= 50, armorLeg= 50, 
	    AttackSpeed= 0, avoid= 50, recovery= 0, accuracy= 50, KeepRecovery=0
      },
      ['Icon'] = 336,
      ['Eft'] = 0,
    },
  },
}

--上线检测
ItemBuff.Start = function(uSource)
  --获取角色名称
  local PlayName = B_GetRealName(uSource);	
  --读取MYSQL数据
  local SQL = string.format('SELECT item, itime FROM item_buff WHERE playname=\'%s\'', PlayName);
  local Data = M_GetMySqlDataSet(SQL);
  local ItemName = '';
  local ItemTime = 0;
  --判断读取MYSQL状态
  if Data ~= nil and type(Data) == 'table' then
    ItemName = Data[1]['item'];
    ItemTime = tonumber(Data[1]['itime']);
  else
   return;
  end;
  local atime = os.time();
  --有剩余时间给状态
  if ItemTime > atime then
    local t = ItemBuff.item[ItemName];
    if t == nil then
      return;
    end;		
    --增加BUFF
    local sInfo = t['Info'] .. '^到期时间:' .. time_format(atime + (ItemTime - atime));
    P_SetAddMulBuff(uSource, ItemBuff.Idx, t['Name'], ItemTime - atime, t['Icon'], t['Eft'], sInfo, t['LifeData']);	
    --返回消息
    P_saysystem(uSource, string.format('【%s】状态已恢复', t['Name']), 14);
    return;
  end;
  --清理数据
  M_DoMySql(string.format('DELETE FROM item_buff WHERE playname="%s"', PlayName))
end;

--添加数据
ItemBuff.Add = function(PlayName, ItemName, ItemTime)
  M_DoMySql(string.format('INSERT item_buff (playname, item, itime) VALUES (\'%s\', \'%s\', %d) ON DUPLICATE KEY UPDATE item = \'%s\', itime = %d;', PlayName, ItemName, ItemTime, ItemName, ItemTime));
end;