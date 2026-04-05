package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '装备回收使者';

local _fj = {
  --赤霄系列
  ['赤霄大苍手'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 10},
	},
  },
  ['赤霄阴阳剑'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 10},
	},
  },
  ['赤霄无极刀'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 10},
	},
  },
  ['赤霄幽冥枪'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 10},
	},
  },
  ['赤霄混沌斧'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 10},
	},
  },
  ['赤霄龙胄'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 10},
	},
  },
  ['赤霄神弓'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 10},
	},
  },
  ['男子赤霄战甲'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 20},
	},
  },
  ['女子赤霄战甲'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 20},
	},
  },	
  ['男子赤霄战靴'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 5},
	},
  },
  ['女子赤霄战靴'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 5},
	},
  },	
  ['男子赤霄战盔'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 5},
	},
  },
  ['女子赤霄战盔'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 5},
	},
  },		
  ['男子赤霄护腕'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 5},
	},
  },
  ['女子赤霄护腕'] = {
    ['get'] = {},
    ['set'] = {
	  {'交易币', 5},
	},
  },	
  --王陵系列
}


local MainMenu =
[[
回收装备为交易币,奇侠OL让努力的人得到回报!^^
<『$00FFFF00| 查看可回收装备范围』/@fanwei>^
<『$00FFFF00| 回收装备【将需要回收的装备放置物品栏第一格】』/@fenjie>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'fanhui' then
    P_MenuSay(uSource, MainMenu);
    return;
  end;

  --回收范围
  if aStr == 'fanwei' then
	--组成输出字符
	local Str = '回收以下装备：^^';	
	--循环输出
	local n = 0;
	for k, v in pairs(_fj) do
	 n = n + 1;	
	 Str = string.format('%s[%s] ', Str, k);
	 if n % 3 == 0 then 
	   Str = Str .. '^';
	 end;
	end
	Str = string.format('%s^<『$00FFFF00|返回』/@fanhui>', Str);
    P_MenuSay(uSource, Str);
   return;
  end;
  --回收提示
  if aStr == 'fenjie' then
    --判断密码
    if P_GetItemPassBo(uSource) then 
      P_MenuSay(uSource, '请先取消物品栏密码!');
      return;
    end	
    --获取第一个物品
	local ItemData = P_GetHaveItemInfoTabs(uSource, 0);
	if ItemData == nil then return end;
	if ItemData.Name == '' then
      P_MenuSay(uSource, '请将你需要回收的装备放置物品栏第一个格子!');
      return;
	end;  
	--判断是否可回收道具
	if _fj[ItemData.Name] == nil then
      P_MenuSay(uSource, string.format('%s无法进行回收!', ItemData.ViewName));
      return;
	end;  	
	--判断强化等级
	if ItemData.Upgrade > 0 then 
      P_MenuSay(uSource, '只回收强化等级为0的装备!');
      return;
	end;  		
	--组成输出字符
	local Str = string.format('注意：你确定要回收装备【%s(强化%d级)】吗?^^', ItemData.Name, ItemData.Upgrade);	
	Str = string.format('%s回收后你将获得道具:^%s^', Str, _setitemstr(ItemData.Name));
	--判断精炼等级
	if ItemData.Upgrade > 0 then 
	  Str = string.format('%s%s^', Str, _levelstr(ItemData.Upgrade));
	end
	Str = string.format('%s^<『$00FFFF00|确认回收』/@qrfj>', Str);
	Str = string.format('%s^<『$00FFFF00|取消回收』/@exit>', Str);
    P_MenuSay(uSource, Str);
   return;
  end;

  if aStr == 'qrfj' then
    --判断密码
    if P_GetItemPassBo(uSource) then 
      P_MenuSay(uSource, '请先取消物品栏密码!');
      return;
    end	
    --获取第一个物品
	local ItemData = P_GetHaveItemInfoTabs(uSource, 0);
	if ItemData == nil then return end;
	if ItemData.Name == '' then
      P_MenuSay(uSource, '请将你需要回收的装备放置物品栏第一个格子!');
      return;
	end;  
	--判断是否可回收道具
	if _fj[ItemData.Name] == nil then
      P_MenuSay(uSource, string.format('%s无法进行回收!', ItemData.ViewName));
      return;
	end;  
	--判断强化等级
	if ItemData.SmithingLevel > 0 then 
      P_MenuSay(uSource, '只回收强化等级为0的装备!');
      return;
	end;  
	local t = _fj[ItemData.Name];
	--判断物品栏
	if P_getitemspace(uSource) < #t.set then
      P_MenuSay(uSource, string.format('物品栏请保留%d个空位!', #t.set));
      return;
	end; 
	--删除装备
	P_deleteitem(uSource, ItemData.Name, 1, '装备回收删除');
	--随机给予材料
	local _Str = ''; -- 获取的道具字符
    for i, v in pairs(t.set) do	
      if type(v) == 'table' then
		--给予道具
		P_additem(uSource, v[1], v[2], '装备回收给予');
		--记录给予的道具字符
		_Str = string.format('%s[%d个%s]  ', _Str, v[2], v[1]);
      end
    end;
	--说话
	P_MenuSay(uSource, string.format('恭喜!!回收装备【%s】成功!!^^获得了: %s', ItemData.Name, _Str));	
   return;
  end;
 return;
end


function _setitemstr(ItemName)
  if ItemName == nil or _fj[ItemName] == nil then
   return '';
  end;
  local t = _fj[ItemName];
  local Str = '';
  for i, v in pairs(t.set) do
    if type(v) == 'table' then
      Str = string.format('%s[%d个%s]  ', Str, v[2], v[1]);
    end
  end;
  return Str;
end