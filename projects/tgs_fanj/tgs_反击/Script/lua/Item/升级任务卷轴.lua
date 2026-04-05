package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Item_Name = '任务卷轴';

local QuestNotice = {
  ['侠客任务卷轴'] = [[
从极乐洞火王身上取[火王牌],从石头山的石大王身上^
取得[霸王牌],从九尾狐身上取[妖狐牌].^
有[侠客任务卷轴]才能弄到这些东西.^
带上这些去找老侠客。
  ]],

  ['仙人卷轴'] = [[
从极乐寺2馆的魔道士处拿到[术士牌],太极密室的太极公子处^
拿到[公子牌],王的寝宫的上古雨中客处拿到[守护牌].^
^
有[仙人卷轴] 才能得到以上物品.^
带上这些去找老侠客。
  ]],
};

function OnItemDblClick(uSource, uItemKey, astr)
  --获取KEY道具
  local ItemData = P_GetHaveItemInfoTabs(uSource, uItemKey);
  if ItemData == nil or ItemData.Name == nil or QuestNotice[ItemData.Name] == nil then
    return;
  end;
  P_MenuSayItem(uSource, QuestNotice[ItemData.Name], Item_Name, uItemKey);
 return;
end


function OnGetResult(uSource, uItemKey, aStr)
  if aStr == 'close' then
    return;
  end;
 return;
end