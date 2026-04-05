package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '药材商';

local MainMenu_1_1 =
[[
 简直不可思议，您就是我等了许久的人。。。^
 三年前最后见到大人时她交给我一封信，^
 让我务必转交给找她的侠客，没想到就是您。^
 真是有眼不识泰山。^
^
 小生还有一事相求，老母病危，只有北海雪参能医治。^
 可否帮我寻得雪参，此恩此德没齿难忘。^
^
<「游标.bmp」『$00FFFF00| 答应去寻雪参。』/@getok>
]];

local MainMenu_1_2 =
[[
 我没听错吧？你要帮我寻来雪参。。。^
 你把雪参装进竹筐里给我。切记，根也要保存好，^
 不然会影响到药效。^
^
 (完成任务时，双击书函可以确认任务进行状况。)^
^
<「游标.bmp」『$00FFFF00| 询问弄得雪参的方法。』/@howto>
]];

local MainMenu_1_3 =
[[
 雪参乃起死回生之灵药。^
 我也只听说雪参长在北海雪原的蚕蛹里。
]];

local MainMenu_2_1 =
[[
 果真是雪参，根部也完好无损。事实上雪参并不是给老母治病用的，^
 而是要考验你是否有能力完成大人下达的任务。^
 现在由我来告诉你真正要完成的任务吧。就是收回东天、北霸二王^
 的魂魄。^
^
 其实，我也是从大人的口中得知内幕的。^
 东天、北霸二王当年名满江湖，号称“义侠”，^
 但后来走火入魔，残害百姓，杀人放火，无恶不作。^
 忍无可忍的大人只好将二人的肉体封上，^
 可这两个魔头竟然用分身术，继续作恶。 ^
 这儿有两个葫芦，用来收这两个恶人。^
^
 <「游标.bmp」『$00FFFF00| 怎样收这两个恶人』/@howtofight>^
 <「游标.bmp」『$00FFFF00| 询问两个魔头所处位置』/@wheretheyare>^
 <「游标.bmp」『$00FFFF00| 返回』/@2_1>
]];

local MainMenu_2_2 =
[[
 据大人说，招魂要有召唤符，^
 将符投到火炉里，两大魔头就出现了。^
 由于停留时间有限，要尽快解决。^
^
<「游标.bmp」『$00FFFF00| 召唤符怎样才能弄到手。』/@howtogetCallticket>^
]];

local MainMenu_2_3 =
[[
 东天王被绑在东海沼泽东北角的大树上。^
 北霸王被封在北海雪原东北角的祭坛上。^
 ^
 虽说他们都不比当年了，却不能掉以轻心，^
 他们可不好对付。
]];

local MainMenu_2_4 =
[[
阴阳师知道怎样制得召唤符，去找他吧。
]];


local MainMenu_3_1 =
[[
 实在让小人刮目相看。很多人都有去无回，长话短说吧。。。^
 这是抽屉钥匙.大人为答谢收了魂魄的侠客，特预备了礼物。^
 他能开启东侧草屋的抽屉。^
^
 你想见大人？那就去黄金沙漠吧。那里干燥炎热，^
 不能不带竹筒。看我俩这么有缘就送你一个吧。^
^
<「游标.bmp」『$00FFFF00| 询问竹筒的使用方法。』/@usewatercase>
]];

local MainMenu_3_2 =
[[
 手拿竹筒，沙漠无惧。^
 竹筒的水没了，去绿洲灌满。
]];

function OnMenu(uSource, uDest)
  P_MenuSay(uSource, '狂犬直接出不灭戒指');
	
--[[  --获取任务变量
  local CompleteQuest = P_GetQuestNo(uSource);
  local CurrentQuest = P_GetQuestCurrentNo(uSource);
  --初始化任务
  if CompleteQuest <= 1000 then
    P_MenuSay(uSource, MainMenu_1_1);
    return;
  end;

  if CompleteQuest == 1050 then
    if P_getitemcount(uSource, '装雪参的筐') < 1 then
	  B_SAY(uDest, '老母病危_求您快帮我弄些雪参来');
	  return;
    end;
    if P_getitemspace(uSource) < 2 then
      P_MenuSay(uSource, '请保留2个物品栏空格');
     return;
    end; 
    P_SetQuestNo(uSource, 1100);
    P_SetQuestCurrentNo(uSource, 1150);	
	
	P_deleteitem(uSource, '装雪参的筐', 1, '帝王石谷药材商');
    P_additem(uSource, '葫芦1', 1, '帝王石谷药材商');
    P_additem(uSource, '葫芦2', 1, '帝王石谷药材商');
    P_MenuSay(uSource, MainMenu_2_1);
    return;
  end;

  if CompleteQuest == 1100 then
    local nCount = 0;
    if P_getitemcount(uSource, '收了魂的葫芦1') < 1 then
	  nCount = nCount + 1;
    end;
    if P_getitemcount(uSource, '收了魂的葫芦2') < 1 then
	  nCount = nCount + 1;
    end;
	if nCount == 1 then 
      P_MenuSay(uSource, '连南帝王的灵也帮我收了吧');
     return;
	end
	if nCount == 2 then 
      P_MenuSay(uSource, '至今谁的魂也没收着_抓紧喽');
     return;
	end
	if nCount == 0 then 
      P_SetQuestNo(uSource, 1150);
      P_SetQuestCurrentNo(uSource, 1200);	
	
      P_deleteitem(uSource, '收了魂的葫芦1', 1, '帝王石谷药材商');
      P_deleteitem(uSource, '收了魂的葫芦2', 1, '帝王石谷药材商');
	
      if P_getitemcount(uSource, '竹筒') < 1 and P_getitemcount(uSource, '大型竹筒') < 1 then
	    P_additem(uSource, '竹筒', 1, '帝王石谷药材商');
      end;
	  P_additem(uSource, '抽屉钥匙', 1, '帝王石谷药材商');
      P_MenuSay(uSource, MainMenu_3_1);
	end
    return;
  end;

  if CurrentQuest > 1150 and CurrentQuest < 1550 then
	B_SAY(uDest, '壮士，你的雪参救了老母的病');
	if CurrentQuest == 1250 then
	  --判断物品栏
      if P_getitemcount(uSource, '侠客指环') < 1 then
        --判断身上
        local ItemData = P_GetWearItemInfoTabs(uSource, 10);
        if ItemData.Name ~= '侠客指环' then 
          P_SetQuestNo(uSource, 1000);
          P_SetQuestCurrentNo(uSource, 1000);	
          CurrentQuest = 1000;
          CompleteQuest = 1000;
        end; 
      end;	
	end
  end

  if CurrentQuest == 1550 then
	B_SAY(uDest, '你也听说大人的死讯了吗?');
	--判断物品栏
    if P_getitemcount(uSource, '牌王') < 1 then
      --判断身上
      local ItemData = P_GetWearItemInfoTabs(uSource, 10);
      if ItemData.Name ~= '牌王' then 
        P_SetQuestNo(uSource, 1200);
        P_SetQuestCurrentNo(uSource, 1250);	
        CompleteQuest = 1200;
        CurrentQuest = 1250;
      end; 
    end;	
	--判断物品栏
    if P_getitemcount(uSource, '侠客指环') < 1 then
      --判断身上
      local ItemData = P_GetWearItemInfoTabs(uSource, 10);
      if ItemData.Name ~= '侠客指环' then 
        P_SetQuestNo(uSource, 1000);
        P_SetQuestCurrentNo(uSource, 1000);	
        CurrentQuest = 1000;
        CompleteQuest = 1000;
      end; 
    end;
  end;--]]
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'getok' then
    --检测背包空位
    if P_getitemspace(uSource) < 2 then
      P_MenuSay(uSource, '请保留2个物品栏空格');
     return;
    end; 
    if P_getitemcount(uSource, '书函') < 1 then
	  P_additem(uSource, '书函', 1, '帝王石谷药材商');
    end;
    if P_getitemcount(uSource, '竹筐') < 1 then
	  P_additem(uSource, '竹筐', 1, '帝王石谷药材商');
    end;
    P_SetQuestNo(uSource, 1050);
    P_SetQuestCurrentNo(uSource, 1100);	
    P_MenuSay(uSource, MainMenu_1_2);
    return;
  end;

  if aStr == '2_1' then
    P_MenuSay(uSource, MainMenu_2_1);
    return;
  end;

  if aStr == 'howto' then
    P_MenuSay(uSource, MainMenu_1_3);
    return;
  end;

  if aStr == 'usewatercase' then
    P_MenuSay(uSource, MainMenu_3_2);
    return;
  end;

  if aStr == 'howtofight' then
    P_MenuSay(uSource, MainMenu_2_2);
    return;
  end;

  if aStr == 'wheretheyare' then
    P_MenuSay(uSource, MainMenu_2_3);
    return;
  end;

  if aStr == 'howtogetCallticket' then
    P_MenuSay(uSource, MainMenu_2_4);
    return;
  end;

 return;
end