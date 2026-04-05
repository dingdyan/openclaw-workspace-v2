package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '风兄';

--装备置换
local ChangeTable = {
  [1] = {
    name = '时装系列', 
    list = {
      {1, '男子道服(时装)', 1, 0, 60000, 8}, 
      {1, '女子道服(时装)', 1, 0, 60000, 8}, 
      {1, '男子七彩雨衣', 1, 0, 60000, 8}, 
      {1, '女子七彩雨衣', 1, 0, 60000, 8}, 
      {1, '男子白武者服', 1, 0, 60000, 8}, 
      {1, '男子黑武者服', 1, 0, 60000, 8}, 
      {1, '女子白色皮衣', 1, 0, 60000, 8}, 
      {1, '女子黑色皮衣', 1, 0, 60000, 8}, 
      {1, '男子西服', 1, 0, 60000, 8}, 
      {1, '女子旗袍', 1, 0, 60000, 8}, 
      {1, '男子礼服', 1, 0, 60000, 8}, 
      {1, '女子婚纱', 1, 0, 60000, 8}, 
	  {1, '男子朱雀服', 1, 0, 60000, 8}, 
      {1, '女子朱雀服', 1, 0, 60000, 8}, 
      {1, '男子玄武服', 1, 0, 60000, 8}, 
      {1, '女子玄武服', 1, 0, 60000, 8}, 
      {1, '男子白虎服', 1, 0, 60000, 8}, 
      {1, '女子白虎服', 1, 0, 60000, 8}, 
      {1, '男子青龙服', 1, 0, 60000, 8}, 
      {1, '男子青龙服', 1, 0, 60000, 8}, 
      {1, '女子麒麟服', 1, 0, 60000, 8}, 
      {1, '女子麒麟服', 1, 0, 60000, 8}, 	  
	  {1, '男子灰长服', 1, 0, 60000, 8}, 
      {1, '女子灰长服', 1, 0, 60000, 8}, 
      {1, '男子霸王服', 1, 0, 60000, 8}, 
      {1, '女子霸王服', 1, 0, 60000, 8}, 
      {1, '男子龙鳞服', 1, 0, 60000, 8}, 
      {1, '女子龙鳞服', 1, 0, 60000, 8}, 
      {1, '男子沙滩服', 1, 0, 60000, 8}, 
      {1, '女子沙滩服', 1, 0, 60000, 8}, 
      {1, '男子龙王服', 1, 0, 60000, 8}, 
      {1, '女子龙王服', 1, 0, 60000, 8}, 
      {1, '男子夹克服', 1, 0, 60000, 8}, 
      {1, '女子夹克服', 1, 0, 60000, 8}, 
      {1, '男子刺客服', 1, 0, 60000, 8}, 
      {1, '女子刺客服', 1, 0, 60000, 8}, 
	  {1, '男子游龙服', 1, 0, 60000, 8}, 
      {1, '女子游龙服', 1, 0, 60000, 8}, 
      {1, '男子千寻服', 1, 0, 60000, 8}, 
      {1, '女子千寻服', 1, 0, 60000, 8}, 
    }
  } 
};

local MainMenu =
[[
 专业冶炼师风兄 需要帮助吗?^^
<「游标.bmp」『$FF00FF00| 买 物品』/@buy>^^
<「游标.bmp」『$FF00FF00| 开通技能升段』/@craftsman>^^
<「游标.bmp」『$FF00FF00| 进行 时装转换』/@szzh>^^
]];

local SZZHMenu =
[[
请在下面放入需要换购的时装^
『$0080FF80|注意:每次换购需要200交易币』^
^
<「游标.bmp」『$FF00FF00| 已放入 开始换购』/@xzhg_1>^^
<「游标.bmp」『$FF00FF00| 返回』/@fanhui>^
]];

local MainMenu_2 =
[[
 真要转职吗?^
^
<「游标.bmp」『$FF00FF00| 转职』/@change>^
<「游标.bmp」『$FF00FF00| 稍加考虑』/@close>
]];


local MainMenu_3 =
[[
制炼武器的技术,透过铸造术可以制造出多样武器,^
这需要有决定基本强度的铁矿与皮革与决定其特性的^
宝石/金属/岩石,最后还需要将此类材料融合的水石.
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
  
  --转换时装
  if aStr == 'szzh' then
    P_MenuSay(uSource, SZZHMenu, true);
     P_ItemInputWindowsOpen(uSource, 0, '转换时装', '');
     P_setItemInputWindowsKey(uSource, 0, -1);
   return;
  end;

  if aStr == 'gys' then
    --检测道具
    if P_getitemcount(uSource, '骨头') < 5 then 
	   P_MenuSay(uSource, '拿5个骨头来....');
      return;
    end;
    --检测包裹
    if P_getitemspace(uSource) < 1 then
	   P_MenuSay(uSource, '包裹已满....');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '骨头', 5, '风兄')
    --给予道具
    P_additem(uSource, '骨钥匙', 1, '风兄');
	P_MenuSay(uSource, '制作骨钥匙成功....');
    return;
  end;
  
  if aStr == 'kqqh' then
    --检测状态
    if P_GetJobKind(uSource) ~= 0 then 
	   P_MenuSay(uSource, '你已开启过升段功能....');
      return;
    end;
    --修改状态
    P_SetJobKind(uSource, 1);
	--提示
	P_MenuSay(uSource, '恭喜,现在你可以开始技能升段了....');
    return;
  end;

  if aStr == 'craftsman' then
    if P_GetJobKind(uSource) ~= 0 then 
      P_MenuSay(uSource, '不能重复学习技能');
     return;
    end
    if P_getitemcount(uSource, '钱币') < 30000 then
      P_MenuSay(uSource, '持有的金额不足，需钱币30000.');
     return;
    end;
    P_deleteitem(uSource, '钱币', 30000, '风兄');
    P_SetJobKind(uSource, 4);
	P_SetVirtueman(uSource);
    P_MenuSay(uSource, '恭喜！恭喜！您是工匠了～ ');
    return;
  end;
   
  if aStr == 'reqchange' then
     P_MenuSay(uSource, MainMenu_2);
   return;
  end;

  if aStr == 'change' then
    if P_GetJobKind(uSource) == 4 then 
      P_MenuSay(uSource, '你已是工匠了');
     return;
    end
	local talent = P_Getsendertalent(uSource);
	if talent < 2000 or talent > 4000 then
      P_MenuSay(uSource, '想转职技能值要在20。00～40。00');
     return;
    end
    if P_getitemcount(uSource, '钱币') < 50000 then
      P_MenuSay(uSource, '转职费用为钱币50000');
     return;
    end;
    P_deleteitem(uSource, '钱币', 50000, '风兄');
    P_SetJobKind(uSource, 4);
    P_MenuSay(uSource, '恭喜你有了新的职业');
    return;
  end;

  if aStr == 'virtueman' then 
    local grade = P_Getjobgrade(uSource);
    if grade == 6 then 
      P_MenuSay(uSource, '你已经是神工了');
     return;
    end
    if grade ~= 5 then 
      P_MenuSay(uSource, '还不具备资格~');
     return;
    end
    P_MenuSay(uSource, '去找龙师傅问问 得到顶级技能书^也许知晓升为神工的秘诀');
    return;
  end;

  if aStr == 'jobhelp' then
     P_MenuSay(uSource, MainMenu_3);
   return;
  end;

  local Left, Right = lua_GetToken(aStr, '_');
  
  --选择分类
  if Left == 'xzhg' then
    local _type = tonumber(Right);
    if _type == nil then return end;
    if ChangeTable[_type] == nil then return end;
    --判断放入物品
	local Key = P_getItemInputWindowsKey(uSource, 0);
	if Key < 0 or Key > 47 then 
      P_MenuSay(uSource, '请放入需要换购的装备');
      return;
	end;
	--查找物品
    local TargetItem = nil; --自身道具
    --获取第一个物品
	local ItemData = P_GetHaveItemInfoTabs(uSource, Key);
	if ItemData.Name == '' then
      P_MenuSay(uSource, '请放入需要换购的装备');
      return;
	end;
	for key, value in pairs(ChangeTable) do
      for key2, value2 in pairs(value.list) do
         if value2[2] == ItemData.Name and ItemData.Upgrade == value2[4] then
            TargetItem = value2;
            break;
         end
      end
	end
    if TargetItem == nil then
      P_MenuSay(uSource, string.format('%s 无法进行换购', ItemData.ViewName));
      return;
	end;
    local boNULL = true;
    local str = '请选择要换购的道具^^';
	local t = ChangeTable[_type].list;
    for k = 1, #t do
      if t[k][6] == TargetItem[6] and t[k][2] ~= TargetItem[2] then
        if t[k][5] >= TargetItem[5] then
          local ViewName = t[k][2];
          local ViewLevel = t[k][4];
          local difference = t[k][5] - TargetItem[5];
		  if difference <= 0 then difference = 200 end;
		  str = string.format('%s<「游标.bmp」『$FF00FF00| 换购 %s - %d交易币』/@kshg_%d_%d>^', str, ViewName, difference, _type, k);
		  boNULL = false;		
		end
	  end
    end;
    str = string.format('%s<「游标.bmp」『$FF00FF00| 返回』/@fanhui>^', str);
    if boNULL then
      P_MenuSay(uSource, '没有可兑换的物品');
      return;
    end
	--返回信息
	P_MenuSay(uSource, str);
    return;
  end;

  --开始换购
  if Left == 'kshg' then
    local _type, _index = lua_GetToken(Right, '_');
    local _type = tonumber(_type);
    local _index = tonumber(_index);
    if _type == nil or _index == nil then return end;
    if ChangeTable[_type] == nil then return end;
    if ChangeTable[_type].list[_index] == nil then return end;
    --判断放入物品
	local Key = P_getItemInputWindowsKey(uSource, 0);
	if Key < 0 or Key > 47 then 
      P_MenuSay(uSource, '请放入需要换购的装备');
      return;
	end;
    --获取第一个物品
	local ItemData = P_GetHaveItemInfoTabs(uSource, Key);
	if ItemData.Name == '' then
      P_MenuSay(uSource, '请放入需要换购的装备');
      return;
	end;
    local TargetItem = ChangeTable[_type].list[_index]; -- 目标道具
    local UserItem = nil; --原始道具
	--循环获取自己道具
	for key, value in pairs(ChangeTable) do
      for key2, value2 in pairs(value.list) do
         if value2[2] == ItemData.Name and value2[4] == ItemData.Upgrade then
            UserItem = value2;
            break;
         end
      end
	end
    if TargetItem == nil or UserItem == nil then
      P_MenuSay(uSource, string.format('%s 无法进行换购', ItemData.ViewName));
      return;
	end;
    local difference = TargetItem[5] - UserItem[5];		 
    if difference <= 0 then difference = 200 end;
	--组成输出字符
	local Str = string.format('注意：确认换购 %s 吗?^^', UserItem[2]);	
    Str = string.format('%s『$0080FF80|本次换购目标: %s』^', Str, TargetItem[2]);
    Str = string.format('%s『$0080FF80|换购需要交易币: %d个』^', Str, difference);
	Str = string.format('%s^<「游标.bmp」『$FF00FF00| 确认换购』/@qrhg_%d_%d>', Str, _type, _index);
	Str = string.format('%s^<「游标.bmp」『$FF00FF00| 返回』/@fanhui>', Str);
    P_MenuSay(uSource, Str);	
	
    return;
  end;

  --开始换购
  if Left == 'qrhg' then
    local _type, _index = lua_GetToken(Right, '_');
    local _type = tonumber(_type);
    local _index = tonumber(_index);
    if _type == nil or _index == nil then return end;
    if ChangeTable[_type] == nil then return end;
    if ChangeTable[_type].list[_index] == nil then return end;
    --检查物品栏密码状态    
    if P_GetItemPassBo(uSource) then 
      P_MenuSay(uSource, '请先取消物品栏密码');
      return;
    end
    --判断放入物品
	local Key = P_getItemInputWindowsKey(uSource, 0);
	if Key < 0 or Key > 47 then 
      P_MenuSay(uSource, '请放入需要换购的装备');
      return;
	end;
    --获取第一个物品
	local ItemData = P_GetHaveItemInfoTabs(uSource, Key);
	if ItemData.Name == '' then
      P_MenuSay(uSource, '请放入需要换购的装备');
      return;
	end;
	if ItemData.lockState ~= 0 then 
      P_MenuSay(uSource, ItemData.Name..' 是锁定状态');
      return;
	end;
	--获取装备DIY属性
    local DiyTable = P_GetHaveItemDiyLifeData(uSource, Key);
	if DiyTable['DiyNum'] > 0 then 
      P_MenuSay(uSource, string.format('请先将 %s 鉴定属性转移走', ItemData.ViewName));
      return;
	end;	
    local TargetItem = ChangeTable[_type].list[_index]; -- 目标道具
    local UserItem = nil; --原始道具
	local atype = 0;
	--循环获取自己道具
	for key, value in pairs(ChangeTable) do
      for key2, value2 in pairs(value.list) do
         if value2[2] == ItemData.Name and value2[4] == ItemData.Upgrade then
            UserItem = value2;
			atype = key;
            break;
         end
      end
	end
    if TargetItem == nil or UserItem == nil then
      P_MenuSay(uSource, string.format('%s 无法进行换购', ItemData.ViewName));
      return;
	end;
	
	if atype ~= _type and ItemData.AddType > 0 then 
      P_MenuSay(uSource, ItemData.Name..' 有金字属性,无法换购,请先清洗');
      return;
	end;
	
    local difference = TargetItem[5] - UserItem[5];		 
    if difference <= 0 then difference = 200 end;
    if P_getitemcount(uSource, '交易币') < difference then
      P_MenuSay(uSource, '需要交易币 '..difference..'个');
     return;
    end; 
	
	P_DelHaveItemInfo(uSource, Key, 1);
    P_deleteitem(uSource, '交易币', difference, '一代宗师');
	--给转换后道具
	local ToItem = {};
	ToItem['Name'] = TargetItem[2];
	ToItem['Count'] = 1;
	ToItem['Color'] = 1;
	ToItem['Id'] = ItemData.Id;
	ToItem['Upgrade'] = TargetItem[4];
	ToItem['AddType'] = ItemData.AddType;
	if strtostamp(ItemData.DateTime) > os.time() then 
	  ToItem['DateTime'] = ItemData.DateTime;
    end;
	P_AddItemTabsToHave(uSource, ToItem, '一代宗师');
	--P_addItemUpgrade(uSource, TargetItem[2], 1, TargetItem[4], '一代宗师')
	P_MenuSay(uSource, '换购了物品 '..TargetItem[2]);
	--公告
    M_topmsg(string.format('恭喜:[%s]消耗[%d个交易币]换购了[%s]', B_GetRealName(uSource), difference, TargetItem[2]), 16711935);   
    return;
  end;

 return;
end