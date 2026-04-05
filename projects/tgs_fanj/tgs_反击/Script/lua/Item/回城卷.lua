package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Item_Name = '回城卷';

local MainMenu =
[[
确认回城吗?满血时才可使用^^
<『$00FFFF00| 回 城』/@hc>^
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
  if aStr == 'hc' then
   --检测道具数量
   if P_getitemcount(uSource, '回城卷') < 1 then 
	 P_saysystem(uSource, '没有回城卷', 2);
     return;
   end
   local MapId, X, Y =  B_GetPosition(uSource);
   if MapId ~= 1 then 
	 P_saysystem(uSource, '长城以南才可使用', 2);
     return;
   end
   local CurLife = B_GetCurLife(uSource);
   local MaxLife = B_GetMaxLife(uSource);
   if CurLife + 100 < MaxLife then 
	 P_saysystem(uSource, '满血才可使用', 2);
     return;
   end
   --传送
   P_MapMove(uSource, 1, 524, 474, 0);
   --删除道具
   ---P_deleteitem(uSource, '回城卷', 1, '回城卷');
  end;
 return;
end