package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Item_Name = '神工牌';

local MainMenu =
[[
请选择要成为的神工职业^^
<『$00FFFF00| 铸造师』/@xz1>^
<『$00FFFF00| 炼丹师』/@xz2>^
<『$00FFFF00| 裁缝』/@xz3>^
<『$00FFFF00| 工匠』/@xz4>^
<『$00FFFF00| 取 消』/@qx>
]];

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
	 P_saysystem(uSource, '请先关闭其他窗口', 2);
     return;
   end
  P_MenuSayItem(uSource, MainMenu, Item_Name, uItemKey);
 return;
end


function OnGetResult(uSource, uItemKey, aStr)
  if aStr == 'close' then
    return;
  end;
  if aStr == 'xz1' then
   --检测道具数量
   if P_getitemcount(uSource, '神工牌') < 1 then 
	 P_saysystem(uSource, '没有神工牌', 2);
     return;
   end
   --删除道具
   P_deleteitem(uSource, '神工牌', 1, '神工牌');
   --改变职业
   P_SetJobKind(uSource, 1);
   --升级神工
   P_SetVirtueman(uSource);
  end;
  if aStr == 'xz2' then
   --检测道具数量
   if P_getitemcount(uSource, '神工牌') < 1 then 
	 P_saysystem(uSource, '没有神工牌', 2);
     return;
   end
   --删除道具
   P_deleteitem(uSource, '神工牌', 1, '神工牌');
   --改变职业
   P_SetJobKind(uSource, 2);
   --升级神工
   P_SetVirtueman(uSource);
  end;
  if aStr == 'xz3' then
   --检测道具数量
   if P_getitemcount(uSource, '神工牌') < 1 then 
	 P_saysystem(uSource, '没有神工牌', 2);
     return;
   end
   --删除道具
   P_deleteitem(uSource, '神工牌', 1, '神工牌');
   --改变职业
   P_SetJobKind(uSource, 3);
   --升级神工
   P_SetVirtueman(uSource);
  end;
  if aStr == 'xz4' then
   --检测道具数量
   if P_getitemcount(uSource, '神工牌') < 1 then 
	 P_saysystem(uSource, '没有神工牌', 2);
     return;
   end
   --删除道具
   P_deleteitem(uSource, '神工牌', 1, '神工牌');
   --改变职业
   P_SetJobKind(uSource, 4);
   --升级神工
   P_SetVirtueman(uSource);
  end;
 return;
end