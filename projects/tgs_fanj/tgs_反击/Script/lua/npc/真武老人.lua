package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

--真元兑换
local _tf = {
  [1] = {
    ['Name'] = '一层剑法', 
    ['get'] = {
      {'闪光剑破解', 9999}, 
      {'北马剑法', 9999},
      {'圣灵21剑', 9999},
      {'壁射剑法', 9999},
      {'太极剑结', 9999},
      {'雷剑式', 9999},
	},
    ['set'] = {'真元', 1000},	
  },
  [2] = {
    ['Name'] = '一层刀法', 
    ['get'] = {
      {'花郎徒结', 9999}, 
      {'应龙大天神', 9999},
      {'长枪刀法', 9999},
      {'半月式', 9999},
      {'神古土', 9999},
      {'断刀法', 9999},
	},
    ['set'] = {'真元', 1000},	
  },
  [3] = {
    ['Name'] = '一层枪法', 
    ['get'] = {
      {'杨家枪法', 9999}, 
      {'点枪术', 9999},
      {'打狗棒法', 9999},
      {'达摩枪法', 9999},
      {'飞月枪法', 9999},
      {'火龙升天术', 9999},
	},
    ['set'] = {'真元', 1000},	
  },
  [4] = {
    ['Name'] = '一层槌法', 
    ['get'] = {
      {'无击阵', 9999}, 
      {'闪光槌法', 9999},
      {'龙王槌法', 9999},
      {'跃人千墙', 9999},
      {'地狱大血式', 9999},
      {'回转狂天飞', 9999},
	},
    ['set'] = {'真元', 1000},	
  },
  [5] = {
    ['Name'] = '一层拳法', 
    ['get'] = {
      {'如来金刚拳', 9999}, 
      {'少林长拳', 9999},
      {'骨架击', 9999},
      {'太极拳', 9999},
      {'旋风脚', 9999},
      {'无影脚', 9999},
	},
    ['set'] = {'真元', 1000},	
  },
};

local Npc_Name = '武功修炼';

local MainMenu =
[[『$FF00ff00|武功修炼到99.99才能重修武功』^^
<「游标.bmp」『$00FFFF00| 整套武功重修』/@xuanze>^^
<「游标.bmp」『$00FFFF00| 江湖历练 兑换 真元』/@zbdh>^
]];

--2 二维  1 一维
local Valid = {
  ['get'] = 2,
  ['set'] = 1,
};
local _dh = lua_SdbValidStr('Script\\lua\\sdb\\真元兑换.sdb', Valid);
local _dhtemp = {};

--取材料字符串
function _GetTableStr(t, uNum)
  if type(t) ~= 'table' then return '' end;
  local Str = '';
  for i, v in pairs(t) do
    if type(v) == 'table' then
      Str = string.format('%s%d个%s  ', Str, v[2] * uNum, v[1]);
    end
  end;
  return Str;
end


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
  
  if aStr == 'lilian' then
    P_MenuSay(uSource, lilianMenu);
    return;
  end;

  if aStr == 'dandu' then
    P_MenuSay(uSource, QainMenu);
    return;
  end;
  
  if aStr == 'xuanze' then
    local Str = '请选择要兑换的武功类型!^^';
    for i = 1, #_tf do
      if type(_tf[i]) == 'table' then	 
        Str = string.format('%s<「游标.bmp」 『$00FFFF00|重修  %s 』/@queren_%d>^', Str, _tf[i].Name, i);
      end;
    end;
    P_MenuSay(uSource, Str);
    return;
  end;
  
  --装备兑换
  if aStr == 'zbdh' then
     local str = '请选择要您要兑换的真元^^';
     for k = 1, #_dh do
       local t = _dh[k];
	   if t ~= nil then 
	     str = string.format('%s<『$FF00FF00| %s』/@zbdhxz_%d>^^', str, t.name, k);	
	   end;	
     end;
     str = string.format('%s<『$FF00FF00| 返 回』/@fanhui>', str);	
	 --返回信息
	 P_MenuSay(uSource, str);
    return;
  end;

local Left, Right = lua_GetToken(aStr, "_");
if Left == 'queren' then
    --验证参数
	local Right = tonumber(Right);
	if Right == nil then return end;
    --获取table
	local t = _tf[Right];
    if t == nil then return end;	
    local Str = string.format('兑换『$00FFFF00|%s』需要以下武功及等级,确认兑换吗?^^', t.Name);
    for i = 1, #t.get do
      if type(t.get[i]) == 'table' then
        Str = string.format('%s%d: [『$00FFFF00|%s』]修炼等级需要达到:%d^', Str, i, t.get[i][1], t.get[i][2]);
      end;
    end;
	Str = string.format('%s{%d}^', Str, #t.get + 1);		
	Str = string.format('%s<「游标.bmp」『$00FFFF00| 确认重修』/@tf_%d>^<「游标.bmp」『$00FFFF00| 返回』/@fanhui>', Str, Right);
    P_MenuSay(uSource, Str);
    return;
  end;

  if Left == 'tf' then 
    --验证参数
	local Right = tonumber(Right);
	if Right == nil then return end;
    --获取table
	local t = _tf[Right];
    if t == nil then return end;	
	--判断材料
    for i, v in pairs(t.get) do
      if type(v) == 'table' then
      --检测兑换的武功修炼等级有没有满级 99.99		
        if  P_GetMagicLevel(uSource, v[1]) < v[2] then
           P_MenuSay(uSource, string.format('[ %s ]未修炼或者等级未达到:%d', v[1], v[2]));
          return;
        end;
		--检测人物当前使用武功是否是兑换武功的一个
		if P_GetCurUseMagic(uSource, 0) == v[1] then
		 P_MenuSay(uSource, string.format('正在使用武功:%s ,请切换使用:无名武功', v[1]));
		return;
        end;
    end;
	end; 
	 --检查物品栏密码状态    
    if P_GetItemPassBo(uSource) then 
      P_MenuSay(uSource, '请先取消物品栏密码');
      return;
    end
	--删除武功
    for i, v in pairs(t.get) do	
      if type(v) == 'table' then
        P_DelMagicName(uSource, v[1]);
      end
    end;	
	--给予真元
	  P_additem(uSource, t.set[1], t.set[2], '真武老人');	
	--说话
	P_MenuSay(uSource, string.format('兑换成功! 使用[ %s ]兑换[%s]:%d个', t.Name,t.set[1],t.set[2]));	
    return;
  end;
  
  --合成道具提示
  if Left == 'zbdhxz' then
    local index = tonumber(Right);
    if _dh == nil then return end;
    if _dh[index] == nil then return end;
    --记录选择ID
	_dhtemp[B_GetRealName(uSource)] = index;
	if _dh[index].type == 0 then 
	  OnDHDJQR(uSource, uDest, 1);
	else
	--弹出输入
	  P_MsgConfirmDialog(uSource, uDest, 112, '输入兑换的真元数量');
	end;
    return;
  end;
  --换道具确认
  if Left == 'zbdhqr' then
    --验证参数
	local Index, Num = lua_GetToken(Right, '_');
	Index = tonumber(Index);
	Num = tonumber(Num);
	if Index == nil then return end;
	if Num == nil then return end;
    --获取table
	local t = _dh[Index];
    if t == nil then return end;
    --检测玩家道具
    for i, v in pairs(t.get) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] * Num then
           P_MenuSay(uSource, string.format('你没有%d个%s', v[2] * Num, v[1]));
          return;
        end;
      end
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end; 
	--删除材料
    for i, v in pairs(t.get) do	
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2] * Num, '真武老人');
      end
    end;
	--给予物品
	local sex = '';
	if t.sex == 1 then 
	  if P_getsex(uSource) == 1 then
	    sex = '男子'
	  else
	    sex = '女子'
	  end	
	end;
	--给予物品
	P_additem(uSource, sex .. t.set[1], t.set[2] * Num, '真武老人');
	--说话
	P_MenuSay(uSource, string.format('恭喜你兑换到了%d个%s', t.set[2] * Num, sex .. t.set[1]));
	--发送全服公告
	M_topmsg(string.format('恭喜[%s]兑换了%d个%s', B_GetRealName(uSource), t.set[2] * Num, sex .. t.set[1]), 7266299, 5775368);
    return;
  end;
 return;
end

--兑换确认
function OnDHDJQR(uSource, uDest, uNum)
  if uNum < 1 or uNum > 10000 then 
    P_MenuSay(uSource, '兑换范围[1-10000]');
    return;
  end; 
  local PlayName = B_GetRealName(uSource);
  local index = _dhtemp[PlayName];
  if index == nil then 
    return;
  end;
  local t = _dh[index];
  if t == nil then 
    return;
  end;
  local str = string.format('确认兑换 %d个%s 吗?^', uNum, t.name);
  str = string.format('%s本次兑换需要 『$0080FF80|%s』^^', str, _GetTableStr(t.get, uNum));
  str = string.format('%s<『$FF00FF00| 确认兑换』/@zbdhqr_%d_%d>^^', str, index, uNum);
  str = string.format('%s<『$FF00FF00| 返 回』/@zbdh>', str);
  --返回信息
  P_MenuSay(uSource, str);
  return;
end

function OnConfirmDialog(uSource, uDest, key, aStr)
   --判断KEY
  if key == 112 then 
	local Num = tonumber(aStr);
    if Num == nil then 
      P_MenuSay(uSource, '数量输入错误');
      return;
    end
    OnDHDJQR(uSource, uDest, Num);
  end;
 return;
end