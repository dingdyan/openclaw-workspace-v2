package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Item_Name = '技术密笈';

local QuestJob = {
  [1] = [[
千年以前传说中的炼金术神工[雪楚]用毕生精力作成黄金钥匙,^
据史料记载黄金钥匙是四大技术名人融合的结晶^
当打造出黄金钥匙后你将成为世人注目的神工
  ]],

  [2] = [[
千年以前,传说中的炼丹师神工[云中子]用毕生精力作出乾坤日月酒,^
据史料记载,乾坤日月酒是由四大名人努力的结晶
  ]],

  [3] = [[
一千年前，传说中的裁缝神工[方士严],用毕生经历作出太级线，^
据史料记载太级线是四大技术名人努力的结晶．^
四合为一作出太极线,成为世人注目的神工.
  ]],

  [4] = [[
千年之前传说中的铁匠神工[狂星子],用毕生经历作出玻璃戒，^
据史料记载玻璃戒是四大技术名人努力的结晶．^
四合为一作出玻璃戒，成为世人注目的神工.
  ]],
};



function OnItemDblClick(uSource, uItemKey, astr)
  local JobKind = P_GetJobKind(uSource);
  if JobKind == 0 then 
    P_MenuSayItem(uSource, '老兄_还没职业呢？', Item_Name, uItemKey);
   return;
  end
  P_MenuSayItem(uSource, QuestJob[JobKind], Item_Name, uItemKey);
 return;
end


function OnGetResult(uSource, uItemKey, aStr)
  if aStr == 'close' then
    return;
  end;
 return;
end