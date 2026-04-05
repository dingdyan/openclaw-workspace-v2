package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '阴阳师';

local MainMenu =
[[怎么没有人要二级弓术武功书?^请拿潜行术来换透视符^^
<「游标.bmp」『$FF00FF00| 买 物品』/@buy>^
]];

--<「游标.bmp」『$00FFFF00| 用潜行术换透视符』/@tsf>^

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'tsf' then
    --检测道具
    if P_getitemcount(uSource, '潜行术') < 1 then 
	   P_MenuSay(uSource, '拿潜行术来....');
      return;
    end;
    --检测包裹
    if P_getitemspace(uSource) < 1 then
	   P_MenuSay(uSource, '包裹已满....');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '潜行术', 1, '阴阳师')
    --给予道具
    P_additem(uSource, '透视符', 1, '阴阳师');
	P_MenuSay(uSource, '交换透视符成功....');
    return;
  end;


  local Left, Right = lua_GetToken(aStr, "_");
  if aStr == 'make' then
      local Teach = {
             ['Date'] = {'透视符', 1}, 
             ['Item'] = {
                 {'潜行术', 1}, 
             },
      };
      --检测道具
      for i, v in pairs(Teach.Item) do
        if type(v) == 'table' then 
           if P_getitemcount(uSource, v[1]) < v[2] then 
              P_MenuSay(uSource, '缺少道具['..v[1]..':'..v[2]..']！');
             return;
           end;
        end
      end;
      --检测包裹
      if P_getitemspace(uSource) < 1 then
	     P_MenuSay(uSource, '包裹已满....');
        return;
      end;
      --删除道具
      for i, v in pairs(Teach.Item) do
        if type(v) == 'table' then 
           P_deleteitem(uSource, v[1], v[2], '阴阳师');
        end
      end;
      --给道具
	  P_additem(uSource, Teach.Date[1], Teach.Date[2], '阴阳师');
      P_MenuSay(uSource, '恭喜,您获得了['..Teach.Date[1]..':'..Teach.Date[2]..']');
    return;
  end;

 return;
end