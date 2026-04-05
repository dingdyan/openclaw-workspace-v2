package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '雨中客';

local MainMenu =
[[
 请用玉玺与桂林新冠换取磐龙斧.^^
<「游标.bmp」『$FF00FF00| 交换磐龙斧』/@plf>^
]];



function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'plf' then
    --检测道具
    if P_getitemcount(uSource, '玉玺') < 1 then 
	   P_MenuSay(uSource, '拿玉玺来....');
      return;
    end;
     --检测钱币
    if P_getitemcount(uSource, '新罗金冠') < 1 then 
	   P_MenuSay(uSource, '可有新罗金冠?');
       return;
    end;
    --检测包裹
    if P_getitemspace(uSource) < 1 then
	   P_MenuSay(uSource, '包裹已满....');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '玉玺', 1, '雨中客')
    P_deleteitem(uSource, '新罗金冠', 1, '雨中客')
    --给予道具
    P_additem(uSource, '磐龙斧', 1, '雨中客');
	P_MenuSay(uSource, '换上磐龙斧....');
    return;
  end;

  if aStr == 'vip_yc' then
    --检测是否是VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then 
      P_MenuSay(uSource, '您还不是VIP或者VIP已过期!');
     return 'true';	
    end;	
    --获取玩家基本属性
    local Attrib = P_GetAttrib(uSource);
    --判断年龄是否到达
    if Attrib.Age < 2500 then 
      P_MenuSay(uSource, '年龄到达25.00才可进入!');
     return;	
    end;
    --传送到王陵一层
    P_MapMove(uSource, 3, 37, 63, 0);
    return;
  end;	

  --兑换神器开始
  if aStr == 'jgbl' then
     local str = '请选择要您要加工的物品:^^';
     for k = 1, #_dhbl do
	   if type(_dhbl[k]) == 'table' then 
	     str = string.format('%s<「游标.bmp」 『$00FFFF00|%s』/@dhsqif_%d>^', str, _dhbl[k].name, k);	
	   end;	
     end;
     str = string.format('%s<「游标.bmp」 『$00FFFF00|取 消』/@exit>', str);	
	 --返回信息
	 P_MenuSay(uSource, str);
    return;
  end;

 return;
end