package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Item_Name = '个人武型丹';

local _data = {
  [1] = 0,
  [2] = 1,
  [3] = 2,
  [4] = 4,
  [5] = 3,
};

local MainMenu =
[[
修改所在门派的门武为指定类型(只对自己有效)^
『$0080FF80|注意:修改后重新登录生效』^
<『$00FFFF00| 改为 拳法』/@xg_1>^
<『$00FFFF00| 改为 剑法』/@xg_2>^
<『$00FFFF00| 改为 刀法』/@xg_3>^
<『$00FFFF00| 改为 枪法』/@xg_4>^
<『$00FFFF00| 改为 斧法』/@xg_5>^
<『$00FFFF00| 关闭』/@close>
]];

function OnItemDblClick(uSource, uItemKey, astr)
  if not P_BoFreedom(uSource) then 
    P_saysystem(uSource, '请先关闭其他窗口', 25);
    return;
  end
  P_MenuSayItem(uSource, MainMenu, Item_Name, uItemKey);
 return;
end


function OnGetResult(uSource, uItemKey, aStr)
  if aStr == 'close' then
    return;
  end;
  --分解字符串
  local Left, Right = lua_GetToken(aStr, '_');
  --开始摘取
  if Left == 'xg' then
    local aKey = tonumber(Right);
	if aKey == nil or _data[aKey] == nil then 
      return;
    end;
    --检测是否加入门派
    local GuildName = P_GuildGetName(uSource);
    if GuildName == '' then 
      P_MenuSayItem(uSource, '请先加入门派', Item_Name, uItemKey);
     return;
    end
	--获取门派门武
	local GuildMagic = M_GetGuildMagic(GuildName);
    if GuildMagic == '' then 
      P_MenuSayItem(uSource, '门派没有门武', Item_Name, uItemKey);
     return;
    end
	--检测武功是否重复
	local MagicLevel = P_GetMagicLevel(uSource, GuildMagic);
	if MagicLevel < 100 then 
	  P_MenuSayItem(uSource, '没有修炼本门门武', Item_Name, uItemKey);
	 return;
	end
	--修改数据 千万19这个变量其他地方不要用了
	P_SetTempStr(uSource, 19, GuildMagic ..':' .. _data[aKey]);
    --删除道具
    P_deleteitem(uSource, '个人武型丹', 1, Item_Name);
    --提示
    P_MenuSayItem(uSource, '修改成功,重新登录后生效', Item_Name, uItemKey);
  end;
  
 return;
end