package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '至善方丈';

local Teach = {
   ['金钟罩'] = {
      ['Set'] = {
         {'金钟罩', 1}, 
      },
      ['Get'] = {
         {'熊掌', 200}, 
         {'熊胆', 30}, 
         {'老虎指甲', 100}, 
      },
   },
   ['血手印'] = {
      ['Set'] = {
         {'血手印', 1}, 
      },
      ['Get'] = {
         {'龙蜒草液', 1}, 
         {'空白秘籍', 1}, 
      },
   },
   ['噬魂枪'] = {
      ['Set'] = {
         {'噬魂枪', 1}, 
      },
      ['Get'] = {
         {'噬魂枪上卷', 1}, 
         {'噬魂枪下卷', 1}, 
      },
   },
};

local MainMenu =
[[神功绝学，有缘者得之……^^
<「游标.bmp」『$FF00FF00|兑换 金钟罩』/@dh_金钟罩>^^
<「游标.bmp」『$FF00FF00|兑换 血手印』/@dh_血手印>^^
<「游标.bmp」『$FF00FF00|兑换 噬魂枪』/@dh_噬魂枪>
]];


function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;
  
  local Left, Right = lua_GetToken(aStr, "_");
  if Left == 'dh' then
    local t = Teach[Right]
	if t == nil then return end;
	--检测道具
	for i, v in pairs(t.Get) do
      if type(v) == 'table' then 
        if P_getitemcount(uSource, v[1]) < v[2] then 
           P_MenuSay(uSource, string.format('施主,你缺少%d个%s……', v[2], v[1]));
          return;
        end;
      end
    end;
    --检测包裹	
    if P_getitemspace(uSource) < #t.Set then
      P_MenuSay(uSource, string.format('施主,请保留%d个包裹位置……', #t.Set));
     return;
    end;
    --删除道具
    for i, v in pairs(t.Get) do
      if type(v) == 'table' then 
	    P_deleteitem(uSource, v[1], v[2], '至善方丈');
      end
    end;
    --给道具
    for i, v in pairs(t.Set) do
      if type(v) == 'table' then 
        P_additem(uSource, v[1], v[2], '至善方丈');
      end
    end;
    P_MenuSay(uSource, string.format('施主,看来你与%s有缘呀……', Right));
	--发送全服公告
	M_topmsg(string.format('【至善方丈】恭喜[%s]获得了%s', B_GetRealName(uSource), Right), 33023);
    return;
  end;

 return;
end