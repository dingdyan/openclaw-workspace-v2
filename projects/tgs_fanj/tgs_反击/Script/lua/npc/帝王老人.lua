package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '帝王老人';

--侠客令兑换
local sdb = "Script\\lua\\sdb\\神兵兑换.sdb";
--2 二维  1 一维
local Valid = {
  ['Get'] = 2,
  ['Set'] = 1,
};
local _dh = lua_SdbValidStr(sdb, Valid);

local MainMenu =
[[
兑换不灭 出售竹筒,石谷钥匙,降魔符^
注意:不灭40岁可用20金元兑换(活力60.00)^
^
<「游标.bmp」『$00FFFF00| 兑换 不灭』/@bm>^
<「游标.bmp」『$00FFFF00| 兑换 侠客令』/@dhsb>^
<「游标.bmp」『$00FFFF00| 买 物品』/@buy>^
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	
	

  if aStr == 'bm' then
    --获取玩家基本属性
    local Attrib = P_GetAttrib(uSource);
    --判断年龄是否到达
    if Attrib.Age < 4000 then 
      P_MenuSay(uSource, '年龄尚未到达40岁!');
      return;
    end;
    if P_getitemcount(uSource, '金元') < 20 then 
      P_MenuSay(uSource, '你没有20个金元');
     return;
    end;
    --检测背包空位
    if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
    end;  
    --判断物品栏
    if P_getitemcount(uSource, '不灭') >= 1 then 
      P_MenuSay(uSource, '你已拥有不灭,不能重复兑换!');
      return;
    end;
    --判断身上装备
    local ItemData = P_GetWearItemInfoTabs(uSource, 10);
    if ItemData.Name == '不灭' then 
      P_MenuSay(uSource, '你已拥有不灭,不能重复兑换!');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '金元', 20, '帝王老人');
    --给予物品    
    if not P_additem(uSource, '不灭', 1, '帝王老人') then 
      P_MenuSay(uSource, '系统异常,请联系管理员处理');
      return;
    end
    --说话
    P_MenuSay(uSource, '恭喜你获得了不灭');
    --发送全服公告
    M_topmsg(string.format('帝王老人:恭喜[%s]兑换了[不灭]', B_GetRealName(uSource)), 11295231);
    return;
  end;		

  --兑换神兵
  if aStr == 'dhsb' then
     local str = '请问想兑换些什么道具?^^';
     for k = 1, #_dh do
       local t = _dh[k];
	   if t ~= nil then 
	     str = string.format('%s<「游标.bmp」『$00FFFF00| %s』/@dhsbzx_%d>^', str, t.Name, k);	
	   end;	
     end;
     str = string.format('%s<「游标.bmp」『$00FFFF00| 返 回』/@fanhui>', str);	
	 --返回信息
	 P_MenuSay(uSource, str);
    return;
  end;

  local Left, Right = lua_GetToken(aStr, '_');
  --兑换道具提示
  if Left == 'dhsbzx' then
    local index = tonumber(Right);
    if index == nil then return end;
    if _dh[index] == nil then return end;
    local t = _dh[index];
    local str = string.format('确认兑换 %s?^', t.Name);
    str = string.format('%s兑换材料 『$0080FF80|%s』^', str, _GetTableStr(t.Get));
    str = string.format('%s兑换年龄 『$0080FF80|%.2f』^^', str, t.Age / 100);
    str = string.format('%s<「游标.bmp」『$00FFFF00| 确认兑换』/@dhsbqr_%d>^', str, index);
    str = string.format('%s<「游标.bmp」『$00FFFF00| 返 回』/@dhsb>', str);
    --返回信息
    P_MenuSay(uSource, str);
    return;
  end;

  --换道具确认
  if Left == 'dhsbqr' then
    --验证参数
	local Index = tonumber(Right);
	if Index == nil then return end;
    --获取table
	local t = _dh[Index];
    if t == nil then return end;
    --获取玩家基本属性
    local Attrib = P_GetAttrib(uSource);
    --判断年龄是否到达
    if Attrib.Age < t.Age then 
      P_MenuSay(uSource, string.format('兑换年龄 『$0080FF80|%.2f』', t.Age / 100));
      return;
    end;
    --检测玩家道具
    for i, v in pairs(t.Get) do
      if type(v) == 'table' then
        if P_getitemcount(uSource, v[1]) < v[2] then
           P_MenuSay(uSource, string.format('缺少%d个%s', v[2], v[1]));
          return;
        end;
      end
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满');
      return;
	end; 
	--删除材料
    for i, v in pairs(t.Get) do	
      if type(v) == 'table' then
        P_deleteitem(uSource, v[1], v[2], '帝王老人');
      end
    end;
	--给予物品
	P_additem(uSource, t.Set[1], t.Set[2], '帝王老人');
	--说话
	P_MenuSay(uSource, string.format('恭喜你兑换了%d个%s', t.Set[2], t.Set[1]));
	--发送全服公告
	M_topmsg(string.format('帝王老人:恭喜 %s 兑换了 %d个%s', B_GetRealName(uSource), t.Set[2], t.Set[1]), 16726015);
    return;
  end;
 return;
end

function _GetTableStr(t)
  if type(t) ~= 'table' then return '' end;
  local Str = '';
  for i, v in pairs(t) do
    if type(v) == 'table' then
      Str = string.format('%s%d个%s  ', Str, v[2], v[1]);
    end
  end;
  return Str;
end
