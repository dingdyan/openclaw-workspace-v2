package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local MagicList = {
  [1] = '无名步法',
  [2] = '弓身',
  [3] = '归归步法',
  [4] = '灵空虚徒',
  [5] = '徒步飞',
  [6] = '草上飞',
  [7] = '陆地飞行术',
  [8] = '幻魔身法',
  [9] = '无名心法',
  [10] = '伏式气功',
  [11] = '爆发呼吸',
  [12] = '太极气功',
  [13] = '易筋经',
  [14] = '雷电气功',
  [15] = '吐纳法',
  [16] = '风灵旋',
  [17] = '灵动八方',
};

function OnItemDblClick(uSource, uItemKey, astr)
  local Str = '请选择需要提升的武功^^';
  for i = 1, #MagicList, 1 do
    if P_GetMagicLevel(uSource, MagicList[i]) > -1 then 
	  Str = string.format('%s<「游标.bmp」『$00FFFF00|[提升 %s 等级]』/@cz_%d>^', Str, MagicList[i], i);           
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

  --检测道具数量
    if P_getitemcount(uSource, '真武丹') < 1 then 
	  P_saysystem(uSource, '没有真武丹', 2);
      return;
    end

  --获取武功等级
   local dj = P_GetMagicLevel(uSource, MagicList[Index]);
   if dj == 0 then
      P_saysystem(uSource, '未修炼该武功.', 2);
     return;
   end;
   if dj >= 9999 then
      P_saysystem(uSource, '要提升的等级已满,无法使用.', 2);
     return;
   end;

  --修改等级
   P_SetMagicLevel(uSource, MagicList[Index], 9999);
  --删除道具
   P_deleteitem(uSource, '真武丹', 1, '真武丹');
  --返回消息
   P_saysystem(uSource, '服用成功,显示可能会有延迟,请稍后查看!', 2);
 return;
end

 return;
end



