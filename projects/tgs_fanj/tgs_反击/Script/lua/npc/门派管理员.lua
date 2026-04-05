package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

local Npc_Name = '门派管理员';

--允许捐赠道具 数量, 积分
local _jz = {
  [1] = {'钱币', 1000, 6},
  [2] = {'金元', 1, 60},
};
local _jztemp = {};

--门派商城道具 道具 数量 货币 价格 类型(0不用输入数量 1输入数量)
local _shop = {
  --0 级门派
  [0] = {
    [1] = {'白酒', 30, '贡献', 60, 1},
	[2] = {'金铜弥勒菩萨', 8, '贡献', 600, 1},
	[3] = {'圣灵卷轴', 8, '贡献', 600, 1},
	[4] = {'天神灵符', 8, '贡献', 600, 1},
  },
  --1 级门派
  [1] = {
    [1] = {'白酒', 30, '贡献', 60, 1},
	[2] = {'金铜弥勒菩萨', 8, '贡献', 600, 1},
	[3] = {'圣灵卷轴', 8, '贡献', 600, 1},
	[4] = {'天神灵符', 8, '贡献', 600, 1},
  },
  --2 级门派
  [2] = {
    [1] = {'白酒', 30, '贡献', 60, 1},
	[2] = {'金铜弥勒菩萨', 8, '贡献', 600, 1},
	[3] = {'圣灵卷轴', 8, '贡献', 600, 1},
	[4] = {'天神灵符', 8, '贡献', 600, 1},
  },
  --3 级门派
  [3] = {
    [1] = {'白酒', 30, '贡献', 60, 1},
	[2] = {'金铜弥勒菩萨', 8, '贡献', 600, 1},
	[3] = {'圣灵卷轴', 8, '贡献', 600, 1},
	[4] = {'天神灵符', 8, '贡献', 600, 1},
  },
  --4 级门派
  [4] = {
    [1] = {'白酒', 30, '贡献', 60, 1},
	[2] = {'金铜弥勒菩萨', 8, '贡献', 600, 1},
	[3] = {'圣灵卷轴', 8, '贡献', 600, 1},
	[4] = {'天神灵符', 8, '贡献', 600, 1},
  },
  --5 级门派
  [5] = {
    [1] = {'白酒', 30, '贡献', 60, 1},
	[2] = {'金铜弥勒菩萨', 8, '贡献', 600, 1},
	[3] = {'圣灵卷轴', 8, '贡献', 600, 1},
	[4] = {'天神灵符', 8, '贡献', 600, 1},
  },
};

local _sctemp = {};


local UPITEM = {
  [1] = {
	{'贡献', 3000},
  },
  [2] = {	
	{'贡献', 6000},
  },
  [3] = {
	{'贡献', 11000},
  },
  [4] = {
	{'贡献', 15000},
  },
  [5] = {
	{'贡献', 25000},
  },
};

local MainMenu =
[[
1，你好,200个金元可直接兑换门派石^
2，升级门派需要门派战力值^
3，门派战力：门派成员可以使用~金元~钱币~进行捐赠获取^
4，『$0080FF80|@开启门派属性  可以重新刷新当前门派属性和门主属性』^
5，『$0080FF80|@关闭门派属性  可以关闭当前门派属性和门主属性』^^
<「游标.bmp」『$FF00FF00| 兑换 门派石』/@mps>^^
<「游标.bmp」『$FF00FF00| 升级 门派等级』/@sj>^^
<「游标.bmp」『$FF00FF00| 捐赠 门派战力』/@jz>^^
]];

--<「游标.bmp」『$FF00FF00| 进入 门派商城』/@sc>^

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;
  
  --返回
  if aStr == 'fanhui' then
    P_MenuSay(uSource, MainMenu);
    return;
  end;
  
  --捐赠贡献
  if aStr == 'jz' then
    --获取门派名称
    local GuildName = P_GuildGetName(uSource);
    if GuildName == '' then
	  P_MenuSay(uSource, '请先加入门派!');
      return;
    end;
	--展示数据列表
	local str = '请选择要捐赠道具^^';
	for i = 1, #_jz, 1 do
	  str = string.format('%s<『$FF00FF00| 捐赠: [%s:%d]兑换[%d点]门派战力』/@xzjz_%d>^^', str, _jz[i][1], _jz[i][2], _jz[i][3], i);	
	end
	str = string.format('%s<『$FF00FF00| 返 回』/@fanhui>', str);	
	--返回信息
	P_MenuSay(uSource, str);
    return;
  end;
  
  --门派商城
  if aStr == 'sc' then
    --获取门派名称
    local GuildName = P_GuildGetName(uSource);
    if GuildName == '' then
	  P_MenuSay(uSource, '请先加入门派!');
      return;
    end;
	--获取门派等级
    local Level = M_GetGuildLevel(GuildName);
	local t = _shop[Level];
	if t == nil then 
	  P_MenuSay(uSource, '没有可兑换道具!');
      return;
    end;
	--展示数据列表
	local str = '请选择要兑换道具^^';
	for i = 1, #t, 1 do
	  str = string.format('%s<『$FF00FF00| 个人贡献 兑换 %s*%d』/@scxz_%d>^^', str, t[i][1], t[i][2], i);	
	end
	str = string.format('%s<『$FF00FF00| 返 回』/@fanhui>', str);	
	--返回信息
	P_MenuSay(uSource, str);
    return;
  end;
  

  if aStr == 'mps' then
    --检测道具
    if P_getitemcount(uSource, '金元') < 200 then 
	   P_MenuSay(uSource, '需要200个金元....');
      return;
    end;
    --检测包裹
    if P_getitemspace(uSource) < 1 then
	   P_MenuSay(uSource, '包裹已满....');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '金元', 200, '门派管理员')
    --给予道具
    P_additem(uSource, '门派石', 1, '门派管理员');
	P_MenuSay(uSource, '兑换门派石成功....');
	M_topmsg(string.format('恭喜:玩家['..B_GetRealName(uSource)..']兑换了门派石'), 16726736);
    return;
  end;
  
  if aStr == 'sj' then
  --检测是否加入门派
     local GuildName = P_GuildGetName(uSource);
     if GuildName == '' then 
       P_MenuSay(uSource, '请先加入门派');
      return;
     end
     --获取玩家名称
     local PlayName = B_GetRealName(uSource);
     --检测是否门主
	 if M_IsGuildSysOp(GuildName, PlayName) ~= 1 then 
       P_MenuSay(uSource, '门主才可升级');
      return;
     end
     --获取门派等级
     local GuildLevel = M_GetGuildLevel(GuildName);
     if GuildLevel == 5 then
       P_MenuSay(uSource, '你的门派已经是最高等级了');
      return;
     end
	  --获取升级道具
      local t = UPITEM[GuildLevel + 1];
         if t == nil then 
        return '已经是最高级';
       end
	 --检测升级材料是否足够
  for i, v in pairs(t) do
    if type(v) == 'table' then 
	  if v[1] == '贡献' then 
	    local GuildEnegy = M_GetGuildEnegy(GuildName);
		if GuildEnegy < v[2] then 
		 P_MenuSay(uSource, string.format('升级失败,需要[%d点门派战力],当前门派战力[%d]', v[2], GuildEnegy));
          return
		end;
	  else
        if P_getitemcount(uSource, v[1]) < v[2] then 
		 P_MenuSay(uSource, string.format('升级失败,需要[%d个%s]', v[2], v[1]));
          return
        end;
	  end;
    end
  end;
  --删除材料
  for i, v in pairs(t) do
    if type(v) == 'table' then 
	  if v[1] == '贡献' then 
	    M_SetGuildEnegy(GuildName, M_GetGuildEnegy(GuildName) - v[2]);
	  else
        P_deleteitem(uSource, v[1], v[2], '门派管理员');
	  end;
    end
  end;
	 --升级门派
     M_SetGuildLevel(GuildName, GuildLevel + 1);
	 --加门石血量
	 M_SetGuildDurability(GuildName, M_GetGuildDurability(GuildName) + 100000);
	 --发送全服公告
	 M_topmsg(string.format('恭喜[%s]门派等级提升为了%d级', GuildName, GuildLevel + 1), 55512, 0)
	 --返回信息
	 P_MenuSay(uSource, '恭喜,您的门派升级成功!');
    return;
  end;
  
  local Left, Right = lua_GetToken(aStr, '_');
  --商城 提示
  if Left == 'scxz' then
    local Index = tonumber(Right);
    if Index == nil then return end;
    --获取门派名称
    local GuildName = P_GuildGetName(uSource);
    if GuildName == '' then
	  P_MenuSay(uSource, '请先加入门派!');
      return;
    end;
	--获取门派等级
    local Level = M_GetGuildLevel(GuildName);
	if _shop[Level] == nil then 
	  P_MenuSay(uSource, '没有可兑换道具!');
      return;
    end;
    if _shop[Level][Index] == nil then return end;
    --记录选择ID
	_sctemp[B_GetRealName(uSource)] = Index;
	if _shop[Level][Index][5] == 0 then 
	  OnDHDJQR(uSource, uDest, 1);
	else
	--弹出输入
	  P_MsgConfirmDialog(uSource, uDest, 112, '输入兑换数量');
	end;
    return;
  end;
  
  --兑换  确认
  if Left == 'scqr' then
    --验证参数
	local Index, Num = lua_GetToken(Right, '_');
	Index = tonumber(Index);
	Num = tonumber(Num);
	if Index == nil then return end;
	if Num == nil then return end;
    --获取门派名称
    local GuildName = P_GuildGetName(uSource);
    if GuildName == '' then
	  P_MenuSay(uSource, '请先加入门派!');
      return;
    end;
	--获取门派等级
    local Level = M_GetGuildLevel(GuildName);
	if _shop[Level] == nil then 
	  P_MenuSay(uSource, '没有可兑换道具!');
      return;
    end;
    local t = _shop[Level][Index];
    if t == nil then 
      return;
    end;
    --判断道具
    if t[3] == '贡献' then 
      local Point = P_GetGuildPoint(uSource);
      if Point < t[4] * Num then
	     P_MenuSay(uSource, string.format('需要[%d点个人贡献],当前个人贡献[%d]', t[4], Point));
	    return
      end;
    else
      if P_getitemcount(uSource, t[3]) < t[4] * Num then
        P_MenuSay(uSource, string.format('缺少%s*%d', t[3], t[4] * Num));
        return;
      end;
    end;
	--删除道具
    if t[3] == '贡献' then
	  P_SetGuildPoint(uSource, P_GetGuildPoint(uSource) - t[4] * Num);
    else
	  P_deleteitem(uSource, t[3], t[4] * Num, '门派管理员');
    end;
	--给予道具
	P_additem(uSource, t[1], t[2] * Num, '门派管理员');
	--提示
	P_MenuSay(uSource, string.format('兑换了 %d个%s', t[2] * Num, t[1]));
	--全服公告
    M_worldnoticesysmsg(string.format('门派管理员:%s 在门派商城兑换了%d个%s', B_GetRealName(uSource), t[2] * Num, t[1]), 17)
    return;
  end;
  
  --捐赠 提示
  if Left == 'xzjz' then
    local Index = tonumber(Right);
    if Index == nil then return end;
    if _jz[Index] == nil then return end;
    --记录选择ID
	_jztemp[B_GetRealName(uSource)] = Index;
	--弹出输入
	P_MsgConfirmDialog(uSource, uDest, 111, '请输入捐赠的数量');
    return;
  end;
  
  --捐赠  确认
  if Left == 'qrjz' then
    --验证参数
	local Index, Num = lua_GetToken(Right, '_');
	Index = tonumber(Index);
	Num = tonumber(Num);
	if Index == nil then return end;
	if Num == nil then return end;
    if _jz[Index] == nil then return end;
    --获取门派名称
    local GuildName = P_GuildGetName(uSource);
    if GuildName == '' then
	  P_MenuSay(uSource, '请先加入门派!');
      return;
    end;
    --判断道具
    if P_getitemcount(uSource, _jz[Index][1]) < _jz[Index][2] * Num then
      P_MenuSay(uSource, string.format('缺少%s*%d', _jz[Index][1], _jz[Index][2] * Num));
      return;
    end;
	--删除道具
	P_deleteitem(uSource, _jz[Index][1], _jz[Index][2] * Num, '门派管理员');
	--增加门派贡献
	P_SetGuildPoint(uSource, P_GetGuildPoint(uSource) + _jz[Index][3] * Num);
	--增加门派贡献
	M_SetGuildEnegy(GuildName, M_GetGuildEnegy(GuildName) + _jz[Index][3] * Num)
	--提示
	P_MenuSay(uSource, string.format('捐献%s*%d,获得了门派战力:%d', _jz[Index][1], _jz[Index][2] * Num, _jz[Index][3] * Num));
	M_GuildSay(GuildName, string.format('感谢成员[%s]捐献%s*%d,门派战力增加了:%d点',B_GetRealName(uSource), _jz[Index][1], _jz[Index][2] * Num, _jz[Index][3] * Num),16);
    return;
  end;

 return;
end

function OnConfirmDialog(uSource, uDest, key, aStr)
  local Num = tonumber(aStr);
  if Num == nil then 
    P_MenuSay(uSource, '数量输入错误');
    return;
  end
  --判断KEY
  if key == 111 then 
    OnJZQR(uSource, uDest, Num);
  elseif key == 112 then 
    OnDHDJQR(uSource, uDest, Num);
  end;
 return;
end

--捐赠确认
function OnJZQR(uSource, uDest, uNum)
  if uNum < 1 or uNum > 10000 then 
    P_MenuSay(uSource, '数量范围[1-10000]');
    return;
  end; 
  local PlayName = B_GetRealName(uSource);
  local Index = _jztemp[PlayName];
  if Index == nil then 
    return;
  end;
  local t = _jz[Index];
  if t == nil then 
    return;
  end;
  local str = string.format('确认捐赠 %d个%s 吗?^', uNum * t[2], t[1]);
  str = string.format('%s捐赠后可获得门派战力: 『$0080FF80|%d』点^^', str, uNum * t[3]);
  str = string.format('%s<「游标.bmp」『$FF00FF00| 确认捐赠』/@qrjz_%d_%d>^^', str, Index, uNum);
  str = string.format('%s<「游标.bmp」『$FF00FF00| 返 回』/@fanhui>', str);
  --返回信息
  P_MenuSay(uSource, str);
  return;
end

--兑换道具确认
function OnDHDJQR(uSource, uDest, uNum)
  if uNum < 1 or uNum > 10000 then 
    P_MenuSay(uSource, '数量范围[1-10000]');
    return;
  end; 
  local PlayName = B_GetRealName(uSource);
  local Index = _sctemp[PlayName];
  if Index == nil then 
    return;
  end;
  --获取门派名称
  local GuildName = P_GuildGetName(uSource);
  if GuildName == '' then
    P_MenuSay(uSource, '请先加入门派!');
    return;
  end;
  --获取门派等级
  local Level = M_GetGuildLevel(GuildName);
  if _shop[Level] == nil then 
    P_MenuSay(uSource, '没有可兑换道具!');
    return;
  end;
  local t = _shop[Level][Index];
  if t == nil then 
    return;
  end;
  local str = string.format('确认兑换 %d个%s 吗?^', uNum * t[2], t[1]);
  str = string.format('%s本次兑换需要: 『$0080FF80|%d个人%s』^^', str, uNum * t[4], t[3]);
  str = string.format('%s<「游标.bmp」『$FF00FF00| 确认兑换』/@scqr_%d_%d>^^', str, Index, uNum);
  str = string.format('%s<「游标.bmp」『$FF00FF00| 返 回』/@fanhui>', str);
  --返回信息
  P_MenuSay(uSource, str);
  return;
end

function _GetTableStr(t)
  if type(t) ~= 'table' then return '' end;
  local Str = '';
  for i, v in pairs(t) do
    if type(v) == 'table' then
      Str = string.format('%s[%d个%s]  ', Str, v[2], v[1]);
    end
  end;
  return Str;
end
