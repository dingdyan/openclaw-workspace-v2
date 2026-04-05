package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = 'quest玉仙';

local DelItem = {
  ['神秘箱子'] = 1,
  ['老板娘材料书札'] = 1,
  ['铁匠材料书札'] = 1,
  ['梅花夫人材料书札'] = 1,
  ['药材商材料书札'] = 1,
  ['风兄材料书札'] = 1,
  ['老板娘书札'] = 1,
  ['铁匠书札'] = 1,
  ['梅花夫人书札'] = 1,
  ['药材商书札'] = 1,
  ['风兄书札'] = 1,
  ['阴阳师书札'] = 1,
  ['捕盗大将书札'] = 1,
  ['神医书札'] = 1,
  ['老侠客书札'] = 1, 
  ['牛俊书札'] = 1,                  
  ['千年冰玉2'] = 1,
  ['凋谢的花'] = 1,                        
  ['雪花'] = 1,      
  ['脚镣'] = 1,            
  ['布条'] = 1,
  ['老侠客'] = 1,            
  ['药材商材料1'] = 1,
  ['药材商材料2'] = 1,
  ['药材商材料3'] = 1,                  
  ['玉簪'] = 1,
  ['封印符'] = 1,
  ['封符'] = 1,
  ['男尸的魂魄'] = 1,
  ['帐本'] = 1,
  ['东海野兽王内丹'] = 1,
  ['死者灵魂'] = 1,
  ['石大王内丹'] = 1,
  ['石巨人心脏'] = 1,
  ['四臂金刚内丹'] = 1,
  ['千年冰玉1'] = 1,
  ['北方魔人内丹'] = 1,
  ['蜘蛛血'] = 1,
  ['北方魔人魂'] = 1,
  ['石大王魂'] = 1,
  ['四臂金刚魂'] = 1,
  ['东海野兽王魂'] = 1,
  ['玩具'] = 1,
};

local MainMenu_1 =
[[
在完成神秘箱子的任务中,如果不顺利,可以进行任务初始化,^
但要切记初始化之后,神秘箱子任务要重新来做.^^
<「游标.bmp」『$00FFFF00| 买 物品』/@buy>^
<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>^
<「游标.bmp」『$00FFFF00| 四大神功任务初始化』/@initial>
]];

local MainMenu_2 =
[[
确认初始化四大神功任务吗?^
^
<「游标.bmp」『$00FFFF00| 确认初始化』/@qrinitial>^
<「游标.bmp」『$00FFFF00| 取消初始化』/@exit>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu_1);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	
  
  if aStr == 'initial' then
    P_MenuSay(uSource, MainMenu_2);
    return;
  end;

  if aStr == 'qrinitial' then
    for aKey = 0, 29, 1 do
	  local aItemData = P_GetHaveItemInfoTabs(uSource, aKey);
	  if aItemData ~= nil and aItemData.Name ~= '' and DelItem[aItemData.Name] ~= nil then
	    P_DelHaveItemInfo(uSource, aKey, -1);
	  end;		
	end
	P_MenuSay(uSource, '任务已经初始化');
    return;
  end;	

 return;
end