package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Item_Name = '上层武学卷轴';

local wuxue = {
  [1] = {
    [1] = {'疾影拳', '幻影拳'},
    [2] = {'降魔掌', '旋风肘'},
    [3] = {'金刚掌', '扫堂腿'},
    [4] = {'伏虎掌', '铁膝盖'},
    [5] = {'如来神掌', '散花拳'},
  },
  [2] = {
    [1] = {'快剑诀', '华山剑法'},
    [2] = {'怒剑诀', '衡山剑法'},
    [3] = {'意剑诀', '泰山剑法'},
    [4] = {'灵剑诀', '嵩山剑法'},
    [5] = {'残剑诀', '吾夷剑法'},
  },
  [3] = {
    [1] = {'金乌斩', '龙门刀法'},
    [2] = {'风卷云', '玄虚刀法'},
    [3] = {'龙潜杀', '少林刀法'},
    [4] = {'乱刃斩', '峨眉刀法'},
    [5] = {'逆水行', '武当刀法'},
  },
  [4] = {
    [1] = {'破势枪', '少林枪法'},
    [2] = {'伏虎枪', '齐眉棍法'},
    [3] = {'天龙戟', '五郎棍法'},
    [4] = {'降魔戟', '呼延枪法'},
    [5] = {'六合戟', '九龙枪法'},
  },
  [5] = {
    [1] = {'混元神槌', '霹雳槌'},
    [2] = {'牛俊槌法', '断情斧'},
    [3] = {'斗转神槌', '乾坤槌法'},
    [4] = {'斩龙槌法', '战龙槌法'},
    [5] = {'玄冥槌法', '乱披风槌法	'},
  },
}

local MainMenu =
[[请选择你要学习的上层武学^必须浩然到达60.00、元气到达80.00、且必须满对应的下级武学^^
<「游标.bmp」『$00FFFF00| 学习拳法上层武学』/@xuan_1>
<「游标.bmp」『$00FFFF00| 学习剑法上层武学』/@xuan_2>
<「游标.bmp」『$00FFFF00| 学习刀法上层武学』/@xuan_3>
<「游标.bmp」『$00FFFF00| 学习枪法上层武学』/@xuan_4>
<「游标.bmp」『$00FFFF00| 学习斧法上层武学』/@xuan_5>
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
    local Str = '请选择要学习的上层武学?^^';
    for i = 1, #t do
      if type(t[i]) == 'table' then
        Str = string.format('%s<「游标.bmp」『$00FFFF00| 学习: %s』 - 对应下层:%s/@xue_%d_%d>^', Str, t[i][1], t[i][2], tonumber(Right), i);
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
    if P_getitemcount(uSource, '上层武学卷轴') < 1 then 
	  P_saysystem(uSource, '上层武学卷轴', 2);
      return;
    end
    --获取玩家基本属性
    local Attrib = P_GetAttrib(uSource);
	--检测浩然
	if Attrib.Virtue < 6000 then 
	  P_saysystem(uSource, '浩然到达60.00才可学习!', 2);
	 return;
	end;	
	--检测元气
	if Attrib.Energy < 8000 then 
	  P_saysystem(uSource, '元气到达80.00才可学习!', 2);
	 return;
	end;
	--检测下层
	local MagicLevel = P_GetMagicLevel(uSource, tw[2]);
	if MagicLevel < 9999 then 
	  P_saysystem(uSource, '对应的下层武学[' .. tw[2] ..']没有满级!', 2);
	 return;
	end
	--检测武功是否重复
	local MagicLevel = P_GetMagicLevel(uSource, tw[1]);
	if MagicLevel > 0 then 
	  P_saysystem(uSource, '不能重复学习[' .. tw[1] ..']', 2);
	 return;
	end
	--添加武功
	if not P_AddMagicAndLevel(uSource, tw[1], 100) then 
	  P_saysystem(uSource, '学习[' .. tw[1] ..']失败!', 2);
	 return;
	end
	--扣除道具
    P_deleteitem(uSource, '上层武学卷轴', 1, '上层武学卷轴');
    P_saysystem(uSource, '恭喜,成功学习了[' .. tw[1] ..']', 2);
    return;
  end;	

 return;
end