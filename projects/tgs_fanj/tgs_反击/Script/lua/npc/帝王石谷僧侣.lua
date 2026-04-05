package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '帝王石谷僧侣';

local MainMenu_1 =
[[
 西域魔人那魔头与东天、北霸、南帝三天王争夺霸权已经^
 是数百年以前了。之所以她能长生不老是由于采用滋阴补^
 阳法，每天都吸入一个未出嫁的少女的气。^
^
 几百年间，为了长生不老不知有多少人死在她的手上。^
^
^
 西域魔人为达目的不择手段。最近听说骗了哪个侠客，不^
 费吹灰之力就收了东天、北霸二王，恢复了不少功力，如^
 今只差收了南帝王，如果真的如了那魔头的愿，世界将长^
 期处在水深火热之中。^
 ^
 年轻人，你可千万不能上了那魔头的当呀。
]];

local MainMenu_2 =
[[
 这一路，辛苦了.你让很多人能够安居乐业。。。^
 请收下这个竹筒，略表心意。去黄金沙漠它^
 可是必不可少。预祝你马到成功。
]];


function OnMenu(uSource, uDest)
  --获取任务变量
  local CompleteQuest = P_GetQuestNo(uSource);
  local CurrentQuest = P_GetQuestCurrentNo(uSource);


  if CurrentQuest < 1300 then
    B_SAY(uDest, '切记_经过沙漠时_竹筒里要装水');
   return;
  end;

  if CurrentQuest == 1300 then
    B_SAY(uDest, '日后想知道西域魔人的底细就仅管过来');
   return;
  end;
   
  --柳角阑 茫扁困秦 胶丛阑 茫酒吭阑 版快
  if CurrentQuest == 1350 then
    P_SetQuestNo(uSource, 1350);
    P_SetQuestCurrentNo(uSource, 1400);	
    P_MenuSay(uSource, MainMenu_1);
   return;
  end;

  if CurrentQuest == 1400 or CurrentQuest == 1450 or CurrentQuest == 1500 then
    B_SAY(uDest, '得知真相了就该知道怎么做了吧_佛祖保佑');
   return;
  end;


  --巢力空 Quest甫 辆丰茄饶 胶丛阑 茫酒吭阑版快
  if CurrentQuest == 1550 then
    B_SAY(uDest, '快来_我的英雄.');
	
    if P_getitemcount(uSource, '大型竹筒') >= 1 then
      return;
    end;
	
    if P_getitemcount(uSource, '竹筒') >= 1 then	
      P_deleteitem(uSource, '竹筒', 1, '帝王石谷僧侣');
	  P_additem(uSource, '大型竹筒', 1, '帝王石谷僧侣');
      P_MenuSay(uSource, MainMenu_2);
      return;
    end;
  end;

 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

 return;
end