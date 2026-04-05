package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

local Npc_Name = '技能使者';

local MainMenu =
[[
请拿1000能量点来开通技能^^
<『$00FFFF00| 申请成为 铸造师』/@kt1>^
<『$00FFFF00| 申请成为 裁缝』/@kt2>^
<『$00FFFF00| 申请成为 工匠』/@kt3>^
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'fanhui' then
    P_MenuSay(uSource, MainMenu);
   return;
  end;
  
  --领取泡点
  if aStr == 'kt1' then
    --检测状态
    if P_GetJobKind(uSource) ~= 0 then 
	   P_MenuSay(uSource, '你已开启过升段功能....');
      return;
    end;
    if P_getitemcount(uSource, '能量点') < 100 then 
       P_MenuSay(uSource, '需要100点能量点');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '能量点', 100, '技能使者')
    --修改状态
    P_SetJobKind(uSource, 1);
	P_SetVirtueman(uSource);
	--提示
	P_MenuSay(uSource, '恭喜,成为了铸造师神工....');
	M_topmsg(string.format('技能使者:[%s]成为了铸造师神工', B_GetRealName(uSource)), 16754943);
   return;
  end;
  
  --领取泡点
  if aStr == 'kt2' then
    --检测状态
    if P_GetJobKind(uSource) ~= 0 then 
	   P_MenuSay(uSource, '你已开启过升段功能....');
      return;
    end;
    if P_getitemcount(uSource, '能量点') < 100 then 
       P_MenuSay(uSource, '需要100点能量点');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '能量点', 100, '技能使者')
    --修改状态
    P_SetJobKind(uSource, 3);
	P_SetVirtueman(uSource);
	--提示
	P_MenuSay(uSource, '恭喜,成为了裁缝神工....');
	M_topmsg(string.format('技能使者:[%s]成为了裁缝神工', B_GetRealName(uSource)), 16754943);
   return;
  end;
  
  --领取泡点
  if aStr == 'kt3' then
    --检测状态
    if P_GetJobKind(uSource) ~= 0 then 
	   P_MenuSay(uSource, '你已开启过升段功能....');
      return;
    end;
    if P_getitemcount(uSource, '能量点') < 100 then 
       P_MenuSay(uSource, '需要100点能量点');
      return;
    end;
    --删除道具
    P_deleteitem(uSource, '能量点', 100, '技能使者')
    --修改状态
    P_SetJobKind(uSource, 4);
	P_SetVirtueman(uSource);
	--提示
	P_MenuSay(uSource, '恭喜,成为了工匠神工....');
	M_topmsg(string.format('技能使者:[%s]成为了工匠神工', B_GetRealName(uSource)), 16754943);
   return;
  end;
  
 return;
end