package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '安全传送员';

--VIP 护送目标 次数
local VipNum = {
  [1] = 3,
  [2] = 5,
};

--目标配置
local ToNpc = {
  [1] = '九尾狐酒母',
  [2] = '捕盗大将',
  [3] = '牛俊',
  [4] = '梅花夫人',
  [5] = '老侠客',
  [6] = '白捕校',
  [7] = '黑捕校',
}

local MainMenu =
[[
每次押金2万，失败不返还，成功返还押金^
有几率奖励金元、药品、材料。^
将目标带到【指定NPC处】处完成任务^
劫镖成功后必爆100个银元.^
注意：30分钟不送达，任务自动算失败^^
^
<『$00FFFF00| 接取 护送任务』/@hsrwqr>^
]];

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;	
  
  --确认接取
  if aStr == 'hsrwqr' then
    --检测是否是VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if viplevel < 1 then 
      P_MenuSay(uSource, 'VIP玩家才可参与护送');
     return;	
    end;
    --获取境界
	if P_GetEnergyLevel(uSource) < 4 then
      P_MenuSay(uSource, '生死境 可以领取');
     return;
	end;
	local Hour = tonumber(os.date("%H"));
    if Hour < 13 then 
      P_MenuSay(uSource, '开放时间 13-24点');
     return;
	end;
	--状态
	local aStats = P_GetTempArr(uSource, 13);
	--领取时间戳和次数
	local aNow = 0;
	local aNum = 0;
	--读取MYSQL下数据
    local PlayName = B_GetRealName(uSource);
    local sql = string.format('SELECT ids, now, num FROM yabiao WHERE playname=\'%s\'', PlayName);
    local Data = M_GetMySqlDataSet(sql);
    if Data ~= nil and Data[1] ~= nil then
	  aNow = tonumber(Data[1]['now']) or 0;
	  aNum = tonumber(Data[1]['num']) or 0;
    end;
	--判断日期	
	local _time = os.time();
    if os.date("%Y-%m-%d", aNow) ~= os.date("%Y-%m-%d", _time) then 
      aNum = 0;
	  aStats = 0;
    end;
	if VipNum[viplevel] == nil or aNum >= VipNum[viplevel] then
      P_MenuSay(uSource, '今日次数已满');
     return;
    end;
	if aStats ~= 0 then 
      P_MenuSay(uSource, '不能重复领取');
     return;
    end;
    --检测玩家道具
    if P_getitemcount(uSource, '钱币') < 20000 then 
      P_MenuSay(uSource, '你没有20000个钱币');
     return;
    end;
	--删除道具
	P_deleteitem(uSource, '钱币', 20000, '活动专员');
	--随机目标
	math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	math.random(100);
	local ids = math.random(#ToNpc);
	aNum = aNum + 1;
	--写入数据
	local SQL = string.format('INSERT yabiao (playname, ids, now, num) values (\'%s\', %d, %d, %d) ON DUPLICATE KEY UPDATE ids=%d, now=%d, num=%d', PlayName, ids, _time, aNum, ids, _time, aNum);
    if M_DoMySql(SQL) <= 0 then 
       P_saysystem(uSource, '领取失败,请联系管理员!', 2);
       return;        
    end;	
	P_SetTempArr(uSource, 13, 1);
	--提示
	P_MenuSay(uSource, string.format('前往【%s】处完成任务^请快去快回', ToNpc[ids]));
    P_sayByCol(uSource, string.format('护送任务 >> 前往【%s】处完成任务', ToNpc[ids]), 65280, 0);
	--召唤怪物
	local MapId, X, Y =  B_GetPosition(uSource);
	M_MapAddMonster(MapId, '护送目标', X, Y, 1, 5, '', 0, 0, true, 0, PlayName);
	--公告
	M_worldnoticemsg(string.format('[全服提示]%s 领取了护送任务', PlayName), 33023, 3355443);
    return;
  end; 	
 return;
end
