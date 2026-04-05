package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '比武老人';

local MainMenu =
[[
  挑战云霄大帝 需要物品：金元20个^
  用火炬点燃4个火盆  方可对云霄大帝攻击^
^
  挑战成功 有几率获取 属性附加灵符^^
<「游标.bmp」『$00FFFF00| 挑战』/@gonpcroom>
]];


function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'gonpcroom' then
    if P_getitemcount(uSource, '金元') < 20 then
       P_MenuSay(uSource, '没有20个金元 无法进入..');
      return;
    end;
    --检测地图玩家数
    local iCount = M_MapUserCount(110);
    if iCount > 0 then
      P_MenuSay(uSource, '稍等._挑战室好像有人');
     return;
    end;
	--检测NPC存活	
    if M_MapFindMonster(110, '云霄大帝', 2) <= 0 then
      P_MenuSay(uSource, '稍等.');
     return;
    end
    if not M_GetMapEnter(110) then 
      P_MenuSay(uSource, '稍等片刻...');
     return;
    end
	M_MapRegen(110); -- 刷新地图
    P_deleteitem(uSource, '金元', 20, '比武老人');
    P_MapMove(uSource, 110, 14, 12, 0);
	
    M_SetMapEnter(110, false);
    return;
  end;	
 return;
end