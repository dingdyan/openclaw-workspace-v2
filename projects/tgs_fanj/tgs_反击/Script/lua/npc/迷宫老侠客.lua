package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '迷宫玉仙';

local MainMenu =
[[
 幸会. 在下乃新罗唯一幸存的花郎老侠客.^
 我的使命是协助雨中客完成守护王陵.^^
<「游标.bmp」『$00FFFF00| 找回新罗遗失的遗物』/@takeback>^
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'takeback' then
    if P_getitemcount(uSource, '玉仙的无情双刀') < 1 then
      P_MenuSay(uSource, '阁下有何指教?');
     return;
    end;
	local count = P_getitemcount(uSource, '黑马武士')
    if count < 20 then
      P_MenuSay(uSource, '找回20个遗失的黑马武士');
     return;
    end;
	

    P_deleteitem(uSource, '玉仙的无情双刀', 1, '迷宫老侠客');
    P_deleteitem(uSource, '黑马武士', count, '迷宫老侠客');
	P_additem(uSource, '青铜武士', 2, '迷宫老侠客');
	
    P_MenuSay(uSource, '玉仙_任务完成得不错 感激不尽^托阁下的福_新罗珍贵的至宝才能完好保存^我们的玉仙能答应吗?');
    return;
  end;

  if aStr == 'makebul' then
    -- if P_GetQuestNo(uSource) ~= 1500 then 
      -- P_MenuSay(uSource, '想要不灭_拿来材料吧');
     -- return;
    -- end;
    -- if P_GetQuestCurrentNo(uSource) ~= 1550 then 
      -- P_MenuSay(uSource, '想要不灭_拿来材料吧');
     -- return;
    -- end;
    if P_getitemcount(uSource, '侠客指环') < 1 then
      P_MenuSay(uSource, '想要不灭_拿来材料吧');
     return;
    end;	
    if P_getitemcount(uSource, '牌王') < 1 then
      P_MenuSay(uSource, '想要不灭_拿来材料吧');
     return;
    end;
    if P_getitemcount(uSource, '珍品玉玺') < 1 then
      P_MenuSay(uSource, '想要不灭_拿来材料吧');
     return;
    end;
    if P_getitemcount(uSource, '珍品新罗金冠') < 1 then
      P_MenuSay(uSource, '想要不灭_拿来材料吧');
     return;
    end;
	
    P_SetQuestNo(uSource, 1600);
    P_SetQuestCurrentNo(uSource, 1600);	

    P_deleteitem(uSource, '侠客指环', 1, '迷宫老侠客');
    P_deleteitem(uSource, '牌王', 1, '迷宫老侠客');
    P_deleteitem(uSource, '珍品玉玺', 1, '迷宫老侠客');
    P_deleteitem(uSource, '珍品新罗金冠', 1, '迷宫老侠客');
	
	P_additem(uSource, '不灭', 1, '迷宫老侠客');
	
    P_MenuSay(uSource, '恭喜您_此戒指遇火不化^用坚硬的钢铁去削也不留任何痕迹');
    return;
   end;

 return;
end