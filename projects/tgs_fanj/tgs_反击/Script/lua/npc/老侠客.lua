package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '老侠客';

--三层升级
local _sjsc = {
  ['Magic'] = {
    ['日月神功'] = 1,
    ['北冥神功'] = 1,
    ['紫霞神功'] = 1,
    ['血天魔功'] = 1,
  },
};	

local MainMenu =
[[
你需要武功密笈吗?我高价收购陶器与瓷器^^
<「游标.bmp」『$FF00FF00| 买 物品』/@buy>^^
<「游标.bmp」『$FF00FF00| 卖 物品』/@sell>^
]];

local MainMenu_2 =
[[
你不会是徒有其表吧?^^
<「游标.bmp」『$00FFFF00| 申请2级任务』/@grade2>^
<「游标.bmp」『$00FFFF00| 申请3级任务』/@grade3>^
<「游标.bmp」『$00FFFF00| 申请升2级』/@giveitem2>^
<「游标.bmp」『$00FFFF00| 申请升3级』/@giveitem3>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'getquest' then
    P_MenuSay(uSource, MainMenu_2);
    return;
  end;

  if aStr == 'grade2' then	
    if P_getitemcount(uSource, '侠客任务卷轴') > 0 then
      P_MenuSay(uSource, '你已经在做升级任务');
     return;
    end;
    if P_getitemcount(uSource, '仙人卷轴') > 0 then
      P_MenuSay(uSource, '你已经在做升级任务');
     return;
    end;
    --获取当前武功
	local CurMagic = P_GetCurUseMagic(uSource, 1);
	if CurMagic == nil or _sjsc['Magic'][CurMagic] == nil then 
      P_MenuSay(uSource, '要开启一个满1级的神功');
     return;
	end
	--获取当前等级
	local GradeUp = P_GetUseMagicGradeUp(uSource, 0);
	if GradeUp ~= 0 then 
      P_MenuSay(uSource, '要开启一个满1级的神功');
     return;
	end
    local MagicLevel = P_GetMagicLevel(uSource, CurMagic);
	if MagicLevel ~= 9999 then 
      P_MenuSay(uSource, '要开启一个满1级的神功');
     return;
	end
	
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '要空出一个物品栏栏位');
      return;
	end;	
	
    if P_getitemcount(uSource, '金元') < 60 then
      P_MenuSay(uSource, '要接2级任务,需支付60个金元');
     return;
    end;
    P_deleteitem(uSource, '金元', 60, '老侠客');
	P_additem(uSource, '侠客任务卷轴', 1, '老侠客');
	P_MenuSay(uSource, '等你的好消息');
	return;
  end;

  if aStr == 'grade3' then	
    if P_getitemcount(uSource, '侠客任务卷轴') > 0 then
      P_MenuSay(uSource, '你已经在做升级任务');
     return;
    end;
    if P_getitemcount(uSource, '仙人卷轴') > 0 then
      P_MenuSay(uSource, '你已经在做升级任务');
     return;
    end;
    --获取当前武功
	local CurMagic = P_GetCurUseMagic(uSource, 1);
	if CurMagic == nil or _sjsc['Magic'][CurMagic] == nil then 
      P_MenuSay(uSource, '要开启一个满2级的神功');
     return;
	end
	--获取当前等级
	local GradeUp = P_GetUseMagicGradeUp(uSource, 0);
	if GradeUp ~= 1 then 
      P_MenuSay(uSource, '要开启一个满2级的神功');
     return;
	end
    local MagicLevel = P_GetMagicLevel(uSource, CurMagic);
	if MagicLevel ~= 9999 then 
      P_MenuSay(uSource, '要开启一个满2级的神功');
     return;
	end
	
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '要空出一个物品栏栏位');
      return;
	end;	
	
    if P_getitemcount(uSource, '金元') < 80 then
      P_MenuSay(uSource, '要接2级任务,需支付80个金元');
     return;
    end;
    P_deleteitem(uSource, '金元', 80, '老侠客');
	P_additem(uSource, '仙人卷轴', 1, '老侠客');
	P_MenuSay(uSource, '等你的好消息');
	return;
  end;

  if aStr == 'giveitem2' then
    if P_getitemcount(uSource, '侠客任务卷轴') < 1 then
      P_MenuSay(uSource, '你没有 侠客任务卷轴');
     return;
    end;
    if P_getitemcount(uSource, '火王牌') < 1 then
      P_MenuSay(uSource, '你没有 火王牌');
     return;
    end;
    if P_getitemcount(uSource, '霸王牌') < 1 then
      P_MenuSay(uSource, '你没有 霸王牌');
     return;
    end;
    if P_getitemcount(uSource, '妖狐牌') < 1 then
      P_MenuSay(uSource, '你没有 妖狐牌');
     return;
    end;
    --获取当前武功
	local CurMagic = P_GetCurUseMagic(uSource, 1);
	if CurMagic == nil or _sjsc['Magic'][CurMagic] == nil then 
      P_MenuSay(uSource, '要升级的武功必须要在使用状态');
     return;
	end
    local MagicLevel = P_GetMagicLevel(uSource, CurMagic);
	if MagicLevel ~= 9999 then 
      P_MenuSay(uSource, string.format('%s 需要修炼到99.99', CurMagic));
     return;
	end
	local GradeUp = P_GetUseMagicGradeUp(uSource, 0);
	if GradeUp ~= 0 then 
      P_MenuSay(uSource, string.format('%s 不是1级武功', CurMagic));
     return;
	end
	--升级武功
	if not P_SetUseMagicGradeUp(uSource, 0, GradeUp + 1) then 
      P_MenuSay(uSource, '升级失败,请确认武功等级为99.99');
     return;
	end
	
    P_deleteitem(uSource, '侠客任务卷轴', 1, '老侠客');
    P_deleteitem(uSource, '火王牌', 1, '老侠客');
    P_deleteitem(uSource, '霸王牌', 1, '老侠客');
    P_deleteitem(uSource, '妖狐牌', 1, '老侠客');
	
	--提示
	P_MenuSay(uSource, '阁下对武功很痴迷吗?');
	--公告
	M_topmsg(string.format('%s 恭喜你,%s升到了%d级', B_GetRealName(uSource), CurMagic, GradeUp + 2), 65280);
   return;
  end;

  if aStr == 'giveitem3' then
    if P_getitemcount(uSource, '仙人卷轴') < 1 then
      P_MenuSay(uSource, '你没有 仙人卷轴');
     return;
    end;
    if P_getitemcount(uSource, '术士牌') < 1 then
      P_MenuSay(uSource, '你没有 术士牌');
     return;
    end;
    if P_getitemcount(uSource, '公子牌') < 1 then
      P_MenuSay(uSource, '你没有 公子牌');
     return;
    end;
    if P_getitemcount(uSource, '守护牌') < 1 then
      P_MenuSay(uSource, '你没有 守护牌');
     return;
    end;
    --获取当前武功
	local CurMagic = P_GetCurUseMagic(uSource, 1);
	if CurMagic == nil or _sjsc['Magic'][CurMagic] == nil then 
      P_MenuSay(uSource, '要升级的武功必须要在使用状态');
     return;
	end
    local MagicLevel = P_GetMagicLevel(uSource, CurMagic);
	if MagicLevel ~= 9999 then 
      P_MenuSay(uSource, string.format('%s 需要修炼到99.99', CurMagic));
     return;
	end
	local GradeUp = P_GetUseMagicGradeUp(uSource, 0);
	if GradeUp ~= 1 then 
      P_MenuSay(uSource, string.format('%s 不是2级武功', CurMagic));
     return;
	end
	--升级武功
	if not P_SetUseMagicGradeUp(uSource, 0, GradeUp + 1) then 
      P_MenuSay(uSource, '升级失败,请确认武功等级为99.99');
     return;
	end
	
    P_deleteitem(uSource, '仙人卷轴', 1, '老侠客');
    P_deleteitem(uSource, '术士牌', 1, '老侠客');
    P_deleteitem(uSource, '公子牌', 1, '老侠客');
    P_deleteitem(uSource, '守护牌', 1, '老侠客');
	
	--提示
	P_MenuSay(uSource, '阁下对武功很痴迷吗?');
	--公告
	M_topmsg(string.format('%s 恭喜你,%s升到了%d级', B_GetRealName(uSource), CurMagic, GradeUp + 2), 65280);
   return;
  end;

 return;
end