package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '魔教老人';

local MainMenu =
[[
清空怪物,上缴魔教密室钥匙,即可进入下一层^^
<『$00FFFF00| 请前辈送我进入下一层』/@cs>
]];


function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'cs' then
    if P_getitemcount(uSource, '魔教密室钥匙') < 1 then
	  P_MenuSay(uSource, '拥有[魔教密室钥匙]才可进入');
     return;
    end;
    --检测怪物数量
    local n = M_MapFindMonster(98, '', 2);
    if n > 0 then 
	  P_MenuSay(uSource, string.format('歼灭怪物才能通过,怪物(%d)生存', n));
     return;
    end;
    --删除道具
    P_deleteitem(uSource, '魔教密室钥匙', 1, '魔教密室跳点');
    --传送到下一层
    P_MapMove(uSource, 99, 41, 42, 0);
    return;
  end;
  
 return;
end