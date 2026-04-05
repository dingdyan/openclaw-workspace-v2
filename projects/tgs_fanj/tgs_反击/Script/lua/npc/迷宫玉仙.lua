package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '迷宫玉仙';

local MainMenu =
[[
 水... 水...请给我点水...^^
<「游标.bmp」『$FF00FF00| 给玉仙水』/@givewater>
]];

local MainMenu1 =
[[
 啊, 谢谢. 小女子在寻回被忍王一伙儿盗取的^
 新罗的遗物时,中了暗器身负重伤.现在好多了...^
 不知您是否能帮助我,替我继续完成我的使命...^
 侠客的大恩我必将铭记在心!^
^
<「游标.bmp」『$FF00FF00| 接受委托』/@favor>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'givewater' then
    local ids = P_FindItemName(uSource, '竹筒');
    if ids == -1 then 
	   ids = P_FindItemName(uSource, '大型竹筒');
	   if ids == -1 then 
	     P_MenuSay(uSource, '没有竹筒_竹筒无水_都拿不到');
	    return;	
	   end;
	end;
	if P_GetItemDurability(uSource, ids) <= 0 then 
	  P_MenuSay(uSource, '没有竹筒_竹筒无水_都拿不到');
	 return;	
	end;
		
	P_SetItemDurability(uSource, ids, 0);
		
	P_MenuSay(uSource, MainMenu1);

    return;
  end;

  if aStr == 'favor' then
    if P_getitemcount(uSource, '玉仙的无情双刀') >= 1 then
      P_MenuSay(uSource, '任务条件不符');
     return;
    end;
    if P_getitemcount(uSource, '雨中客锦囊') >= 1 then
      P_MenuSay(uSource, '任务条件不符');
     return;
    end;
	
    if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满');
     return;
    end; 
	
	P_additem(uSource, '玉仙的无情双刀', 1, '帝王石谷铁匠');
	
    P_MenuSay(uSource, '拿着遗物和本人的刀_去找老侠客会得到嘉奖^搜集20个_新罗遗失的_黑马武士 拿给老侠客');
    return;
   end;

 return;
end