DayQuest = {
  QuestArr = 12,
  Monster = {
    ['牛'] = 1,
    ['马'] = 1,
    ['鹿'] = 1,
    ['犀牛'] = 1,
	['狂犬'] = 1,
    ['僵尸'] = 1,
    ['山贼'] = 1,
    ['流氓'] = 1,
    ['蝎子'] = 1,
	['石巨人'] = 1,
    ['土巨人'] = 1,
  },
  --记录临时杀怪目标
  temp = {};
};

--删除任务状态
DayQuest.Deltempa = function(uSource)
  P_DelQuestInfo(uSource, DayQuest.QuestArr, 0);
  P_SetTempArr(uSource, 4, 0);
  P_SetTempStr(uSource, 5, ''); --写入数据
  local PlayName = B_GetRealName(uSource);
  if DayQuest.temp[PlayName] ~= nil then 
    DayQuest.temp[PlayName] = nil;
  end;
end;

--上线重置任务状态
DayQuest.Deltemp = function(uSource)
  --获取玩家名称
  local PlayName = B_GetRealName(uSource);
  if DayQuest.temp[PlayName] ~= nil then 
    DayQuest.temp[PlayName] = nil;
  end;
end;
	
--上线触发任务提示
DayQuest.Start = function(uSource)
  --判断武侠任务状态
  if P_GetTempArr(uSource, 4) ~= 1 then return end;
  --获取玩家名称
  local PlayName = B_GetRealName(uSource);
  --获取当前日期
  local CurrentDate = os.date("%Y-%m-%d");
  --任务状态检查
  local QState = 0;
  local Qtype = 0;
  local Qname = '';
  local Qnum = 0;
  local Data = M_GetMySqlDataSet('SELECT state, type, name, num FROM wxz_xkquest WHERE playname="'..PlayName..'" and dates="'..CurrentDate..'" and state=1');	
  --判断读取MYSQL状态
  if Data == -1 then return end;
  if Data ~= nil and Data[1] ~= nil then
    QState = tonumber(Data[1]['state']);
    Qtype = tonumber(Data[1]['type']);
    Qname = Data[1]['name'];
    Qnum = tonumber(Data[1]['num']);
  else
    P_sayByCol(uSource, '武侠任务 >> 任务已过期', 65280, 0);
    --重置任务状态
	DayQuest.temp[PlayName] = nil;
    return;	
  end;
  --检测状态是否为1
  if QState ~= 1 then return end;
  --返回提示
  local queststr = '';
  if Qtype == 1 then 
    queststr = string.format('%s收集道具 [%d个%s]', queststr, Qnum, Qname);
  elseif Qtype == 2 then
    queststr = string.format('%s击杀怪物 [%d个%s] 已击杀[%d]只', queststr, Qnum, Qname, P_GetTempArr(uSource, 5));
  end;
  --删除任务提示
  P_DelQuestInfo(uSource, DayQuest.QuestArr, 0);
  --发送任务提示
  local questInfo = string.format('%s<%s>?<%s>', '武侠任务', queststr, '武侠任务');
  P_SendQuestInfo(uSource, DayQuest.QuestArr, 0, '武侠任务', questInfo, false, true);
 return;
end;


--怪物死亡触发
DayQuest.MonsterDie = function(uSource, MonsterName)
  if DayQuest.Monster[MonsterName] == nil then return end;
  --判断武侠任务状态
  if P_GetTempArr(uSource, 4) ~= 1 then return end;
  --获取玩家名称
  local PlayName = B_GetRealName(uSource);
  --获取当前日期 日期不一样重置 temp
  local CurrentDate = os.date("%Y-%m-%d");
  if DayQuest.temp[PlayName] ~= nil and DayQuest.temp[PlayName][3] ~= CurrentDate then 
    DayQuest.temp[PlayName] = nil;
  end;
  --判断杀怪目标
  if DayQuest.temp[PlayName] == nil then 
    --读取MYSQL
    local Data = M_GetMySqlDataSet('SELECT name,num FROM wxz_xkquest WHERE playname="'..PlayName..'" and dates="'..CurrentDate..'" and state=1');	
    --判断读取MYSQL状态
    if Data == -1 then return end;
    if Data == nil or Data[1] == nil then
      P_sayByCol(uSource, '武侠任务 >> 任务已过期', 65280, 0);
      --重置任务状态
      DayQuest.temp[PlayName] = nil;
      P_SetTempArr(uSource, 4, 0);
      P_SetTempArr(uSource, 5, 0);
      return;
    end;
	--记录临时变量
	local name = Data[1]['name'];
	local num = tonumber(Data[1]['num']);
	if num == nil then num = 0 end;
	DayQuest.temp[PlayName] = {name, num, CurrentDate};
  end;
  --判断击杀的怪物
  if DayQuest.temp[PlayName][1] ~= MonsterName then return end;
  --获取击杀次数
  local PlayDie = P_GetTempArr(uSource, 5);
  --写入杀怪数量
  P_SetTempArr(uSource, 5, PlayDie + 1);
  --提示杀怪数量
  if PlayDie + 1 >= DayQuest.temp[PlayName][2] then 
    P_sayByCol(uSource, '武侠任务 >> 任务已完成,请前往[任务管理员]处提交任务', 65280, 0);
      DayQuest.Deltemp(uSource);
  else
    P_sayByCol(uSource, string.format('武侠任务 >> 已经击杀%s(%d/%d个)', MonsterName, PlayDie + 1, DayQuest.temp[PlayName][2]), 65280, 0);
  end;	
 return;
end;

--任务完成
DayQuest.Comp = function(uSource, AGid)
  P_sayByCol(uSource, '武侠任务 >> 请前往[任务管理员]处提交任务', 65280, 0);
 return;
end;