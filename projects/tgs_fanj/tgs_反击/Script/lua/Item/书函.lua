package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Item_Name = '书函';

local QuestNotice = {
  [1100] = [[
万年雪参长于北海雪原蚕茧中，乃起死回生之灵药。^
蚕茧坚硬无比，需用雪巨人指甲。取得雪参，回药材商处。
  ]],

  [1150] = [[
到东海沼泽和北海雪原祭坛上烧掉召唤符，召回东天、^
北霸二王魂魄。收了二王魂，回到药材商处。
  ]],

  [1200] = [[
侠客指环【象征侠客的戒指】。^
侠客指环藏在位于东南角的草棚里。^
草棚在小地图上很容易就能找到。
  ]],

  [1300] = [[
到帝王石谷杀了南帝王。
  ]],

  [1350] = [[
徘徊在黄金沙漠村子里，收集情报，揭开西域魔人真面目。
  ]],

  [1400] = [[
找南帝王，听他述说事情的来龙去脉。
  ]],

  [1450] = [[
石谷钥匙帮你进入西域魔人实体所藏石谷，黄金沙漠铁匠造。^
降魔符帮你解除西域魔人隐居密室的禁制，阴阳师造。^
两项条件都具备，就出发吧！替天行道，惩恶除奸。
  ]],

  [1500] = [[
与黄金沙漠西域魔人石谷的西域魔人展开最后比试，^
分出胜负后去找南帝王。^
（务必要带除掉西域魔人的凭证-戒指）
  ]],

  [9998] = [[
从极乐洞火王身上取[火王牌],从石头山的石大王身上^
取得[霸王牌],从九尾狐身上取[妖狐牌].^
有[侠客任务卷轴]才能弄到这些东西.^
带上这些去找老侠客。
  ]],

  [9999] = [[
从极乐寺2馆的魔道士处拿到[术士牌],太极密室的太极公子处^
拿到[公子牌],王的寝宫的上古雨中客处拿到[守护牌].^
^
有[仙人卷轴] 才能得到以上物品.^
带上这些去找老侠客。
  ]],
};

function OnItemDblClick(uSource, uItemKey, astr)

  local CurrentQuest = P_GetQuestCurrentNo(uSource);
  if QuestNotice[CurrentQuest] ~= nil then 
    P_MenuSayItem(uSource, QuestNotice[CurrentQuest], Item_Name, uItemKey);
  end
 return;
end


function OnGetResult(uSource, uItemKey, aStr)
  if aStr == 'close' then
    return;
  end;
 return;
end