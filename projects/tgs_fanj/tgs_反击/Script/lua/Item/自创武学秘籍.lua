package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Item_Name = '自创武学秘籍';

local wuxue = {
  [1] = {
    [1] = {'无极玄功拳', 1},
    [2] = {'韦陀伏魔剑', 1},
    [3] = {'雁翎飞天刀', 1},
    [4] = {'紧罗那王枪', 1},
	[5] = {'回风落雁槌', 1},
  },
}

local MainMenu =
[[请选择你要学习的绝世武功^^
<「游标.bmp」『$00FFFF00| 选择修炼自创绝世武功』/@xuan_1>^^
]];

function OnItemDblClick(uSource, uItemKey, astr)
   P_MenuSayItem(uSource, MainMenu, Item_Name, uItemKey);
 return;
end


function OnGetResult(uSource, uItemKey, aStr)
  if aStr == 'close' then
    return;
  end;
  local Left, Right = lua_GetToken(aStr, '_');

  if Left == 'xuan' then
    if tonumber(Right) == nil then return end;
	--获取table
	local t = wuxue[tonumber(Right)];
    if t == nil then return end;
	--循环输出
    local Str = '请选择要修炼的自创绝世武学?^^';
    for i = 1, #t do
      if type(t[i]) == 'table' then
        Str = string.format('%s<「游标.bmp」『$00FFFF00| 修炼: %s』:%s/@xue_%d_%d>^', Str, t[i][1], t[i][2], tonumber(Right), i);
      end;
    end;
	P_MenuSayItem(uSource, Str, Item_Name, uItemKey);
    return;
  end;	

  if Left == 'xue' then
    local Class, Index = lua_GetToken(Right, '_');
	if tonumber(Class) == nil or tonumber(Index) == nil then return end;
	--获取table
	local tx = wuxue[tonumber(Class)];
    if tx == nil then return end;
	local tw = tx[tonumber(Index)];
    if tw == nil then return end;
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
    --检测道具数量
    if P_getitemcount(uSource, '自创武学秘籍') < 1 then 
	  P_saysystem(uSource, '自创武学秘籍', 2);
      return;
    end
    --检测道具
    if P_getitemcount(uSource, '金元') < 100 then
	  P_saysystem (uSource, '需要[金元:100]才能学习',2);
      return;
    end;		
    --检测包裹
    if P_getitemspace(uSource) < 1 then
	 P_saysystem(uSource, '物品栏已满', 2);
      return;
    end;
	--扣除道具
    P_deleteitem(uSource, '自创武学秘籍', 1, '自创武学秘籍');
    P_deleteitem(uSource, '金元', 100, '自创武学秘籍');
	P_additem(uSource, tw[1], tw[2], '自创武学秘籍');
    P_saysystem(uSource, '恭喜,成功学习了[' .. tw[1] ..']', 2);
	M_topmsg(string.format('恭喜[%s]开启[自创武学秘籍]修炼了[%s]', B_GetRealName(uSource), tw[1]), 16043646);
    return;
  end;	

 return;
end