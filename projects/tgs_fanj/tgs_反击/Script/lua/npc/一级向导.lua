package.loaded['Script\\lua\\f'] = nil;
package.loaded['Script\\lua\\任务\\新手任务'] = nil;

require ('Script\\lua\\f');
require ('Script\\lua\\任务\\新手任务');

local PlayMove = {
  {186, 185}, 
  {137, 200}, 
  {146, 235}, 
  {175, 234}, 
};

local Npc_Name = '一级向导';

local MainMenu =
[[
点我领取新手任务和领取推广礼包^^
使用Alt+Q查看任务状态^^
<「游标.bmp」『$FF00FF00| 领取 新手任务』/@xsrw>^^
<「游标.bmp」『$FF00FF00| 领取 推广礼包』/@srkh>^^
<「游标.bmp」『$FF00FF00| 移动 其他坐标』/@move>^
]];


function OnMenu(uSource, uDest)
  P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	
  
  if aStr == 'srkh' then
    --弹出输入框
    P_MsgConfirmDialog(uSource, uDest, 110, '请输入CDK<礼包兑换>')
    return;
  end;

  if aStr == 'xsrw' then
	--获取玩家新手任务ID
	local Value = P_GetTempArr(uSource, NewTask.QuestArr);
	if Value == 0 then 
	  --任务流程==0,分配任务ID1,提示让去杀怪物
	  P_SetTempArr(uSource, NewTask.QuestArr, 1);
	  P_SetTempArr(uSource, NewTask.DieArr, 0);
	  --任务提示
	  P_MenuSay(uSource, '领取到一个新的任务,' .. NewTask.Info[1]);
	  NewTask.Start(uSource);
     return;	
	end	
	--任务流程==1,检测任务是否完成
	if Value == 1 then 
      --检测击杀怪物
      --获取玩家当前所杀怪物
      local PlayDie = P_GetTempArr(uSource, NewTask.DieArr);
	  if PlayDie < NewTask.Kill[Value] then 
        P_MenuSay(uSource, '需要击杀1只猪,任务尚未完成,请继续努力');
       return;	
	  end	
	  --给予奖励
	  for i, v in pairs(NewTask.Award[Value]) do
	    if type(v) == 'table' then
	      P_additem(uSource, v[1], v[2], '新手任务');
	    end
	  end;
	  --改变任务ID
	  P_SetTempArr(uSource, NewTask.QuestArr, Value + 1);
	  P_SetTempArr(uSource, NewTask.DieArr, 0);
	  --提示
      P_MenuSay(uSource, '任务完成,' .. NewTask.Info[Value + 1]);
	  NewTask.Start(uSource);
     return;	
	end	
	--任务流程 > 1, 返回流程提示
	if Value > 1 then 
      P_MenuSay(uSource, NewTask.Info[Value]);
     return;	
	end	
    P_MenuSay(uSource, '有何贵干');
    return;
  end;

  if aStr == 'move' then
     local M = PlayMove[math.random(#PlayMove)];
     if M ~= nil then
	    P_MapMove(uSource, 0, M[1], M[2], 0);
		end;
     return;
  end;
    return;
  end;
  
 function OnConfirmDialog(uSource, uDest, InputId, aStr)
    local key = tonumber(InputId)
   --检测卡号
    if string.len(aStr) ~= 10 then 
      P_MenuSay(uSource, '请输入正确的推广码');
      return;
    end
   if key == 110 then
      local CharName = B_GetRealName(uSource);
      if aStr == '' then
         P_MenuSay(uSource, '请输入有效的 推广礼包 CDK激活码');
	      return
      end;
	 --判断礼包是否存在
    local Data = M_GetMySqlDataSet(string.format('SELECT id, items, name, endtime, state FROM card_read LEFT JOIN card ON card_read.cardid = card.id WHERE cardno = "%s" and torece = 0', aStr));
    --判断读取MYSQL状态
    if Data == -1 or Data == nil or Data[1] == nil then
     P_MenuSay(uSource, '礼包码错误或已领取');
      return
    end;
    local id = tonumber(Data[1]['id']) or 0;
	--获取VIP信息
	local viplevel, viptime = P_GetVipInfo(uSource);
	if id ~= 2 and id ~= 3 and viplevel < 0 then 
      P_MenuSay(uSource, '[会员]才可领取');
     return
    end;
    local items = lua_Strtotable(Data[1]['items'], ';');
    local name = Data[1]['name'];
    if #items < 1 or name == '' then
      return
    end;
    local endtime = tonumber(Data[1]['endtime']) or 0;
    local state = tonumber(Data[1]['money']) or 0;
	if os.time() > endtime or state ~= 0 then
      P_MenuSay(uSource, '礼包已到期');
      return
    end;
	--判断物品栏空位
	if P_getitemspace(uSource) < #items then
      P_MenuSay(uSource, string.format('需要%d个物品栏位置', #items));
      return;
	end;
    --判断是否领取
    local PlayName = B_GetRealName(uSource);
    local Data = M_GetMySqlDataSet(string.format('SELECT torece FROM card_read WHERE playname = "%s" AND cardid = %d', PlayName, id));
    if Data ~= nil and Data[1] ~= nil then
      P_MenuSay(uSource, '不能重复领取同类型礼包');
      return
    end;
	--写入数据
    M_DoMySql(string.format('UPDATE card_read SET torece = 1, playname ="%s" WHERE cardno = "%s"', PlayName, aStr));
	--给予道具
    for i, v in pairs(items) do
      local t = lua_Strtotable(v, ':'); 
      if type(t) == 'table' then
        P_additem(uSource, t[1], t[2], name);
      end
    end;
   P_MenuSay(uSource, string.format('领取了%s', name));
   return
  end;
 end;