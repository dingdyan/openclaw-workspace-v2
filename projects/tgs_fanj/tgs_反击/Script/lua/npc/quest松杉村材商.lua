package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = 'quest松杉村材商';

local MainMenu =
[[
需要物品就到我这来吧!我也收购一些物品!^^
<「游标.bmp」『$00FFFF00| 买 物品』/@buy>^
<「游标.bmp」『$00FFFF00| 卖 物品』/@sell>^
<「游标.bmp」『$00FFFF00| 完成 护送任务』/@wchs>^
]];


local HSMenu =
[[
完成护送任务请确保您的【护送怪】在我的周边^
如确认护送失败请点击 确认任务失败^^
<「游标.bmp」『$00FFFF00| 确认任务完成』/@qrwcrw>^
<「游标.bmp」『$00FFFF00| 确认任务失败』/@sbwcrw>^
<「游标.bmp」『$00FFFF00| 返回』/@fanhui>
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;


  if aStr == 'wchs' then
    P_MenuSay(uSource, HSMenu);
    return;
  end;	

  if aStr == 'qrwcrw' then
    if P_GetTempArr(uSource, 12) ~= 1 then 
      P_MenuSay(uSource, '请先接取任务!');
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end; 
	local PlayName = B_GetRealName(uSource);
    --获取周边怪物
    local ObjectList = B_FindViewUserObjectList(uDest, 3);
    --循环改变周边玩家团队
	local rb = false;
    for oName, oSource in pairs(ObjectList) do		
      --怪物在周边 
	  if oName == '护送怪' and PlayName == B_GetObjectGuild(oSource) and B_Getfeaturestate(oSource) ~= 3 then
	    B_DelObjByID(oSource, 'MONSTER');
	    rb = true;
		break;
	  end;
    end;
	if rb == false then
      P_MenuSay(uSource, '护送怪不在周边!');
      return;
	end; 	
	--改变任务状态
	P_SetTempArr(uSource, 12, 0);
	--任务完成 
	P_additem(uSource, '60分钟双倍卷轴', 1, '药材商');
	P_MenuSay(uSource, '恭喜您完成了护送任务,奖励60分钟双倍');	
	--公告
	M_worldnoticemsg(string.format('药材商:恭喜[%s]完成了护送任务', PlayName), 4832764, 2302755)	
    return;
  end;

  if aStr == 'sbwcrw' then
    if P_GetTempArr(uSource, 12) ~= 1 then 
      P_MenuSay(uSource, '请先接取任务!');
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end; 
	local PlayName = B_GetRealName(uSource);
    --获取周边怪物
    local ObjectList = B_FindViewUserObjectList(uDest, 3);
    --循环改变周边玩家团队
	local rb = false;
    for oName, oSource in pairs(ObjectList) do	
      --怪物在周边 
	  if oName == '护送怪' and PlayName == B_GetObjectGuild(oSource) and B_Getfeaturestate(oSource) ~= 3 then
	    rb = true;
		break;
	  end;
    end;
	if rb == true then
      P_MenuSay(uSource, '护送怪在周边 请点击 确认任务完成');
      return;
	end; 	
	--改变任务状态
	P_SetTempArr(uSource, 12, 0);
	--任务完成 
	P_additem(uSource, '30分钟双倍卷轴', 1, '药材商');
	P_MenuSay(uSource, '很可惜,任务完成失败,奖励30分钟双倍');	
    return;
  end;
  
 return;
end