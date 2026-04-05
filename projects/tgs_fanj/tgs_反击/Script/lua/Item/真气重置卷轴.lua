package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local MagicList = {
  [1] = '日月神功',
  [2] = '北冥神功',
  [3] = '紫霞神功',
  [4] = '血天魔功',
  [5] = '寒阴指',
  [6] = '金刚指',
  [7] = '玉霄剑法',
  [8] = '六脉神剑',
  [9] = '金蛇剑法',
  [10] = '狂风刀法',
  [11] = '罗汉刀法',
  [12] = '凤凰雷电戟',
  [13] = '昭巫枪法',
  [14] = '乌龙索命枪',
  [15] = '蓉沼抉',
  [16] = '五狐断刎槌',

  [17] = '凌波微步',
  [18] = '乾坤大挪移',
  [19] = '风满长空',
  [20] = '吸星大法',
  [21] = '吸魂夺魄',
  [22] = '会心一击',
  [23] = '混天气功',
  [24] = '风扫落叶',
  [25] = '兰花拂穴手',
  [26] = '雷镇四方',
  [27] = '威震八方',
};

function OnItemDblClick(uSource, uItemKey, astr)
  local Str = '请选择需要洗真气的武功^^';
  for i = 1, #MagicList, 1 do
    if P_GetMagicLevel(uSource, MagicList[i]) > -1 then 
	  Str = string.format('%s<『$00FFFF00| ————【重置 %s 真气】————』/@cz_%d>^', Str, MagicList[i], i);           
	end	
  end
  P_MenuSayItem(uSource, Str, Item_Name, uItemKey);
 return;
end

function OnGetResult(uSource, uItemKey, aStr)
  if aStr == 'close' then
    return;
  end;
  local Left, Right = lua_GetToken(aStr, '_');

  if Left == 'cz' then
    local Index = tonumber(Right);
	if Index == nil or MagicList[Index] == nil then 
	  return;        
	end
	
    if P_GetMagicLevel(uSource, MagicList[Index]) < 0 then 
	  return;        
	end
	
    --检测道具数量
    if P_getitemcount(uSource, '真气还原丹') < 1 then 
	  P_saysystem(uSource, '没有 真气还原丹', 2);
      return;
    end
	--重置真气
	if P_DelStatePointName(uSource, MagicList[Index]) then 
      P_deleteitem(uSource, '真气还原丹', 1, '真气还原丹');
	  P_saysystem(uSource, '真气重置成功', 2);
	else
	  P_saysystem(uSource, '真气重置失败,未加点或未升级招式', 2);
	end;
    return;
  end;	
 return;
end