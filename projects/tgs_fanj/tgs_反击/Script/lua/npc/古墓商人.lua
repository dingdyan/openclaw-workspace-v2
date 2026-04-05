package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '古墓商人';

local Teach = {
   ['龙蜒草液'] = {
      ['Set'] = {
         {'龙蜒草液', 1}, 
      },
      ['Get'] = {
         {'龙蜒草', 5}, 
         {'银元', 10}, 
      },
   },
};

local MainMenu =
[[我制作的草液可以还原一些书籍^^
<「游标.bmp」『$FF00FF00|制作 龙蜒草液』/@dh_龙蜒草液>
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
           P_MenuSay(uSource, string.format('缺少%d个%s……', v[2], v[1]));
          return;
        end;
      end
    end;
    --检测包裹	
    if P_getitemspace(uSource) < #t.Set then
      P_MenuSay(uSource, string.format('请保留%d个包裹位置……', #t.Set));
     return;
    end;
    --删除道具
    for i, v in pairs(t.Get) do
      if type(v) == 'table' then 
	    P_deleteitem(uSource, v[1], v[2], '古墓商人');
      end
    end;
    --给道具
    for i, v in pairs(t.Set) do
      if type(v) == 'table' then 
        P_additem(uSource, v[1], v[2], '古墓商人');
      end
    end;
    P_MenuSay(uSource, string.format('请拿好你的%s……', Right));
    return;
  end;

 return;
end