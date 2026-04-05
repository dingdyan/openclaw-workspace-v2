package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '神医';

local SGITEM = {
  [1] = '黄金钥匙',
  [2] = '乾坤日月酒',
  [3] = '太极线',
  [4] = '玻璃戒指',
};

local MainMenu =
[[
我是追逐古代遗迹的侠客，你需要记载如何升为神工的卷轴书吗？^
是有代价的,付12个金元吧！^^
<「游标.bmp」『$FF00FF00| 出12个金元 得到信息』/@rollpaper>^
<「游标.bmp」『$FF00FF00| 递上我所要求做出的物品』/@virtueman>
]];

local MainMenu_1 =
[[
 想升到神工,至少技术得达到一定高度,^
 能够按照书上要求的去做,你的能力就能被认可.
]];

local MainMenu_2 =
[[
小子,差远了,还不够资格,继续修炼去吧,^
火候到了, 再来找老夫.
]];

local MainMenu_3 =
[[
老兄，你不已经是神工了吗！^
别将力气消耗在这儿，回去制造特级物品去吧
]];

local MainMenu_4 =
[[
哇！制造物品成功.你已具备神工资格.^
从现在起就向制造特级物品挑战吧.
]];


function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'rollpaper' then
    if P_GetJobKind(uSource) == 0 then 
      P_MenuSay(uSource, '老兄_还没职业呢？');
     return;
    end
    local grade = P_Getjobgrade(uSource);
    if grade == 6 then 
      P_MenuSay(uSource, MainMenu_3);
     return;
    end
    if P_Getsendertalent(uSource) < 9998 then 
      P_MenuSay(uSource, MainMenu_2);
     return;
    end
    if P_getitemcount(uSource, '金元') < 12 then
      P_MenuSay(uSource, '不足12个金元...');
     return;
    end;
    if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
    end; 
    P_deleteitem(uSource, '金元', 12, '龙师父');
    P_additem(uSource, '技术密笈', 1, '龙师父');
    P_MenuSay(uSource, MainMenu_1);
   return;
  end;

  if aStr == 'virtueman' then
    local JobKind = P_GetJobKind(uSource);
    if JobKind == 0 then 
      P_MenuSay(uSource, '竟敢戏弄老夫?');
     return;
    end
    local grade = P_Getjobgrade(uSource);
    if grade == 6 then 
      P_MenuSay(uSource, '竟敢戏弄老夫?');
     return;
    end
    if P_Getsendertalent(uSource) < 9998 then 
      P_MenuSay(uSource, '竟敢戏弄老夫?');
     return;
    end
    if P_getitemcount(uSource, '技术密笈') < 1 then
      P_MenuSay(uSource, '竟敢戏弄老夫?');
     return;
    end;
    --检测道具
    if P_getitemcount(uSource, SGITEM[JobKind]) < 1 then 
       P_MenuSay(uSource, '竟敢戏弄老夫?');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '技术密笈', 1, '龙师父');
    P_deleteitem(uSource, SGITEM[JobKind], 1, '龙师父');	
    P_SetVirtueman(uSource);
    P_MenuSay(uSource, MainMenu_4);
   return;
  end;
 return;
end