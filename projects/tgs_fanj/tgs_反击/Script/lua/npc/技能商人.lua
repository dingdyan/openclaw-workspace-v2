package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '技能商人';

--[[<「游标.bmp」『$00FFFF00| 选择职业』/@xzjn>^
<「游标.bmp」『$00FFFF00| 升级神工』/@sjsg>^--]]

local MainMenu =
[[开通技能以及出售各种技能材料^^
<「游标.bmp」『$00FFFF00| 购买技能相关材料』/@buy>
]];

--P_SetVirtueman

local JNMenu =
[[请问想成为什么职业?^^
<「游标.bmp」『$00FFFF00| 成为 铸造师』/@jn_1>^
<「游标.bmp」『$00FFFF00| 成为 炼丹师』/@jn_2>^
<「游标.bmp」『$00FFFF00| 成为 裁缝』/@jn_3>^
<「游标.bmp」『$00FFFF00| 成为 工匠』/@jn_4>^
]];

local SGMenu =
[[技能等级修炼到99.98后获取对应材料即可升级为神工^
对应材料以及合成公式介绍如下:^
铸造师: 黄金钥匙(神锋:1 男子海铜护腕:1 高丽红参:1 女子卧龙裟:1)^
炼丹师: 乾坤日月酒(望月刀:1 孤星爪:1 高丽红参:1 男子卧龙裟:1)^
裁缝: 太极线(耀阳宝剑:1 女子紫云帽:1 高丽红参:1 男子巨龙袍:1)^
工匠: 玻璃戒指(双界斧:1 男子龙云靴:1 高丽红参:1 女子巨龙袍:1)^^
<「游标.bmp」『$00FFFF00| 已获得材料 确认升级神工』/@qrsjsg>^
]];

local JNNAME = {
  [1] = '铸造师',
  [2] = '炼丹师',
  [3] = '裁缝',
  [4] = '工匠',
};

local SGITEM = {
  [1] = '黄金钥匙',
  [2] = '乾坤日月酒',
  [3] = '太极线',
  [4] = '玻璃戒指',
};


function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'sjsg' then
    P_MenuSay(uSource, SGMenu);
    return;
  end;

  if aStr == 'qrsjsg' then
	--获取自己技能
	local JobKind = P_GetJobKind(uSource);
	if JobKind == 0 then 
      P_MenuSay(uSource, '你还没有选择职业');
     return;	
	end
	--判断是否已是神工
	if P_Getjobgrade(uSource) == 6 then 
      P_MenuSay(uSource, '你不已经是神工了吗?');
     return;
	end
	--判断技能等级
	if P_Getsendertalent(uSource) < 9998 then 
      P_MenuSay(uSource, '技能等级需要到达99.98');
     return;
	end
    --检测道具
    if P_getitemcount(uSource, SGITEM[JobKind]) < 1 then 
	   P_MenuSay(uSource, string.format('需要材料%s', SGITEM[JobKind]));
      return;
    end;
    --删除道具
    P_deleteitem(uSource, SGITEM[JobKind], 1, '技能商人');
	--升级神工
	P_SetVirtueman(uSource);
	--升级神工
	P_MenuSay(uSource, '哇！制造物品成功.你已具备神工资格.^从现在起就向制造特级物品挑战吧.');
    return;
  end;

  if aStr == 'xzjn' then
    P_MenuSay(uSource, JNMenu);
    return;
  end;

  local Left, Right = lua_GetToken(aStr, '_');
  --选择技能
  if Left == 'jn' then
    local index = tonumber(Right);
	if index == nil or JNNAME[index] == nil then 
	  return;
	end
	--获取自己技能
	if P_GetJobKind(uSource) ~= 0 then 
      P_MenuSay(uSource, '您已拥有职业了');
     return;
	end
	--写入技能
	P_SetJobKind(uSource, index);	
	P_MenuSay(uSource, string.format('恭喜您成为了%s', JNNAME[index]));
    return;
  end;

 return;
end