--武功附加属性表
MagicAddAttrib = {
  Data = {
    --护体
	['罗汉体'] = {
	  {'armorBody' , 50},
	},
	['金钟罩'] = {
	  {'armorBody' , 20},
	},
	['无名强身'] = {
	  {'armorBody' , 5},
	},
	['铁头功'] = {
	  {'armorBody' , 5},
	},
	['龟甲体'] = {
	  {'armorBody' , 5},
	},
	['金刚不坏'] = {
	  {'armorBody' , 5},
	},
	['大铁人'] = {
	  {'armorBody' , 5},
	},
	['雾水掌'] = {
	  {'armorBody' , 5},
	},
	['黑沙刚体'] = {
	  {'armorBody' , 5},
	},
	['不羁浪人强身'] = {
	  {'armorBody' , 10},
	},
	['僵尸功'] = {
	  {'armorBody' , 10},
	},
	['气甲体'] = {
	  {'armorBody' , 10},
	},
	['金结'] = {
	  {'armorBody' , 10},
	},
	['黄土大力体'] = {
	  {'armorBody' , 10},
	},
	['不灭体'] = {
	  {'armorBody' , 10},
	},
	['回转圆型障'] = {
	  {'armorBody' , 10},
	},
    --心法
	['无名心法'] = {
	  {'accuracy' , 2},
	},
	['伏式气功'] = {
	  {'accuracy' , 2},
	},
	['爆发呼吸'] = {
	  {'accuracy' , 2},
	},
	['易筋经'] = {
	  {'accuracy' , 2},
	},
	['太极气功'] = {
	  {'accuracy' , 2},
	},
	['雷电气功'] = {
	  {'accuracy' , 2},
	},
	['吐纳法'] = {
	  {'accuracy' , 2},
	},
        ['不羁浪人心法'] = {
	  {'accuracy' , 5},
	},
	['活人心法'] = {
	  {'accuracy' , 5},
	},
	['混元气功'] = {
	  {'accuracy' , 5},
	},
	['功力澎胀术'] = {
	  {'accuracy' , 5},
	},
    --步法
	['无名步法'] = {
	  {'avoid' , 3},
	},
	['弓身'] = {
	  {'avoid' , 3},
	},
	['归归步法'] = {
	  {'avoid' , 3},
	},
	['灵空虚徒'] = {
	  {'avoid' , 3},
	},
	['徒步飞'] = {
	  {'avoid' , 3},
	},
	['草上飞'] = {
	  {'avoid' , 3},
	},
	['陆地飞行术'] = {
	  {'avoid' , 3},
	},
	['幻魔身法'] = {
	  {'avoid' , 5},
	},
  },
  --三层
  GData = {
	['日月神功'] = {
	  [0] = {
	    {'armorBody' , 10},
	    {'BowBodyArmor' , 20},
	  },
	  [1] = {
	    {'armorBody' , 30},
	    {'BowBodyArmor' , 50},
	  },
	  [2] = {
	    {'armorBody' , 50},
	    {'BowBodyArmor' , 100},
	  },
	},
	['北冥神功'] = {
	  [0] = {
	    {'armorBody' , 10},
	    {'BowBodyArmor' , 20},
	  },
	  [1] = {
	    {'armorBody' , 30},
	    {'BowBodyArmor' , 50},
	  },
	  [2] = {
	    {'armorBody' , 50},
	    {'BowBodyArmor' , 100},
	  },
	},
	['紫霞神功'] = {
	  [0] = {
	    {'armorBody' , 10},
	    {'BowBodyArmor' , 20},
	  },
	  [1] = {
	    {'armorBody' , 30},
	    {'BowBodyArmor' , 50},
	  },
	  [2] = {
	    {'armorBody' , 50},
	    {'BowBodyArmor' , 100},
	  },
	},
	['血天魔功'] = {
	  [0] = {
	    {'armorBody' , 10},
	    {'BowBodyArmor' , 20},
	  },
	  [1] = {
	    {'armorBody' , 30},
	    {'BowBodyArmor' , 50},
	  },
	  [2] = {
	    {'armorBody' , 50},
	    {'BowBodyArmor' , 100},
	  },
	},
  },
};

--用于修改时表的索引信息
local AttribIndex = {
  ['damageBody'] = '攻击',  ['damageHead'] = '打头',   ['damageArm'] = '打手',   ['damageLeg']    = '打脚',
  ['armorBody']  = '防御',  ['armorHead']  = '头防',   ['armorArm']  = '手防',   ['armorLeg']     = '脚防',
  ['AttackSpeed']= '速度',  ['accuracy']   = '命中',   ['avoid']     = '闪躲',   ['KeepRecovery'] = '维持',  ['recovery'] = '恢复',
  ['HitAdd'] = '加伤', ['HitDel'] = '减伤', ['ZDL'] = '战力', ['BowBodyArmor'] = '远程防御',
};

--开启武功满级附加触发
MagicAddAttrib.Set = function(uSource)
  local LifeData = {
    damageBody = 0, damageHead = 0, damageArm = 0, damageLeg = 0,
    armorBody = 0, armorHead = 0, armorArm= 0, armorLeg= 0,
    AttackSpeed= 0, avoid= 0, recovery= 0, accuracy= 0, HitArmor= 0,
    HitAdd= 0, HitDel= 0, ZDL = 0, BowBodyArmor = 0
  };
  local n = 0;
  --普通武功
  for k,v in pairs(MagicAddAttrib.Data) do
    if type(v) =='table' then
      --检测武功等级
      if P_GetMagicLevel(uSource, k) >= 9999 then
	    --增加属性
		for _k,_v in pairs(v) do
		  LifeData[_v[1]] = LifeData[_v[1]] + _v[2];		
		end
        n = n + 1;
      end;
    end;
  end;
  --三层武功
  for k,v in pairs(MagicAddAttrib.GData) do
    if type(v) =='table' then
      --获取武功 Grade
	  local Grade = P_GetMagicGrade(uSource, k);
	  --等级没满 - 1	
      if P_GetMagicLevel(uSource, k) < 9999 then
	    Grade = Grade - 1;
      end;
	  --附加属性
	  if v[Grade] ~= nil then 
		for _k,_v in pairs(v[Grade]) do
		  LifeData[_v[1]] = LifeData[_v[1]] + _v[2];	
		end
        n = n + 1;
      end;		
    end;
  end;
  if n > 0 then
    P_SetAddLifeData(uSource, 6, '武功满级', 3600*24*30, LifeData);
    P_saysystem(uSource, '激活武学属性:' .. MagicAddAttrib.GetAttribInfo(LifeData), 17);
  end;
 return;
end;

--关闭武功满级附加触发
MagicAddAttrib.Del = function(uSource)
  local LifeData = {
    damageBody = 0, damageHead = 0, damageArm = 0, damageLeg = 0,
    armorBody = 0, armorHead = 0, armorArm= 0, armorLeg= 0,
    AttackSpeed= 0, avoid= 0, recovery= 0, accuracy= 0, HitArmor= 0,
    HitAdd= 0, HitDel= 0, ZDL= 0
  };
  P_SetAddLifeData(uSource, 6, '武功满级', 0, LifeData);
  P_saysystem(uSource, '附加武学属性:已关闭', 17);
 return;
end;

--取属性table字符信息
MagicAddAttrib.GetAttribInfo = function(LifeData)
  local t =''
  for _k, _v in pairs(LifeData) do
    if tonumber(_v) ~= 0 and AttribIndex[_k] ~= nil then 
	  if _k == 'ZDL' then 
	    t = string.format('%s%s:%0.2f ', t, AttribIndex[_k], _v / 100);
	  else
	    t = string.format('%s%s:%d ', t, AttribIndex[_k], _v);
	  end;
	end;
  end
 return t
end;