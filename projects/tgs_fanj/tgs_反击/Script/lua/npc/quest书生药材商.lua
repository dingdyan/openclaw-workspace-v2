package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = 'quest侠客药材商';

local MainMenu_6 =
[[
我向来是廉价出售,高价收购的~^
^
<「游标.bmp」『$00FFFF00| 交给 所需材料』/@sendmaterial>^
<「游标.bmp」『$00FFFF00| 买 物品』/@buy>^
<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>
]];


local MainMenu_4_4 =
[[
这是长城以南药材商让送来的? 嗯...果然不错...
]];

local MainMenu_4_6 =
[[
山贼最可恶了. 无论你多辛苦,攒了多长时间,^
他都会给你洗劫一空..^
^
<「游标.bmp」『$00FFFF00| 继续』/@continue>^
<「游标.bmp」『$00FFFF00| 放弃』/@giveup>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu_6);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'sendmaterial' then
    if P_getitemcount(uSource, '药材商材料书札') < 1 then
      P_MenuSay(uSource, '给衣服染上色吧..');
     return;
    end;
    if P_getitemcount(uSource, '药材商材料1') < 1 then
      P_MenuSay(uSource, MainMenu_4_6);
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满...');
      return;
	end;
	P_deleteitem(uSource, '药材商材料1', 1, 'quest药材商');
    P_MenuSay(uSource, MainMenu_4_4);
   return;
  end;

  if aStr == 'continue' then
    return;
  end;

  if aStr == 'giveup' then
    P_deleteitem(uSource, '药材商材料书札', 1, 'quest药材商');
    P_deleteitem(uSource, '药材商材料1', 1, 'quest药材商');
    P_deleteitem(uSource, '药材商材料2', 1, 'quest药材商');
    P_deleteitem(uSource, '药材商材料3', 1, 'quest药材商');            
    return
  end;
 return;
end