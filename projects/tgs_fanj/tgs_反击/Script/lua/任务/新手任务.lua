NewTask = {
  --新手任务
  QuestArr = 1,
  DieArr = 2,
  Info = {
    [1] = '杀2只『$FF00ff00|[猪:182_238]』,完成找『$FF00ff00|[向导:165_223]』',
    [2] = '『$FF00ff00|[捕盗大将:214_252]』找您,快去看看吧',
    [3] = '杀2只『$FF00ff00|[牛:209_247]』完成找『$FF00ff00|[捕盗大将:214_252]』',
    [4] = '『$FF00ff00|[梅花夫人:195_176]』找您,快去看看吧',
    [5] = '杀2只『$FF00ff00|[鹿:198_174]』完成找『$FF00ff00|[梅花夫人:195_176]』',
    [6] = '『$FF00ff00|[黑捕校:268_255]』找您,快去看看吧',
    [7] = '杀2只『$FF00ff00|[马:275_253]』完成找『$FF00ff00|[黑捕校:268_255]』',
    [8] = '『$FF00ff00|[白捕校:208_318]』找您,快去看看吧',
    [9] = '杀2只『$FF00ff00|[熊:196_315]』完成找『$FF00ff00|[白捕校:208_318]』',
    [10] = '『$FF00ff00|[牛俊:72_161]』找您,快去看看吧',
    [11] = '杀1只『$FF00ff00|[犀牛:61_154]』完成找『$FF00ff00|[牛俊:72_161]』',
    [12] = '『$FF00ff00|[老侠客:176_104]』找您,快去看看吧',
    [13] = '杀1只『$FF00ff00|[老虎:155_87]』完成找『$FF00ff00|[老侠客:176_104]』',
    [14] = '『$FF00ff00|[船夫:42_241]』找您,快去看看吧',
  },
  --杀怪数量
  Kill = {
    [1] = 2,
    [3] = 2,
    [5] = 2,
    [7] = 2,
    [9] = 2,
    [11] = 1,
    [13] = 1,
  },
  --杀怪目标
  KillName = {
    [1] = '一级猪',
    [3] = '一级牛',
    [5] = '一级鹿',
    [7] = '一级马',
    [9] = '一级熊',
    [11] = '一级犀牛',
    [13] = '一级老虎',
  },
  Monster = {
    ['一级猪'] = 1,
    ['一级牛'] = 1,
    ['一级鹿'] = 1,
    ['一级马'] = 1,
    ['一级熊'] = 1,
    ['一级犀牛'] = 1,
    ['一级老虎'] = 1,
  },

  --奖励道具
  Award = {
    [1] = {
      {'新手生药', 50, 0, 73},
      {'新手汤药', 50, 0, 71},
	  {'浪人铁槌', 1, 0, 2},
    },
    [3] = {
      {'新手生药', 50, 0, 73},
      {'新手汤药', 50, 0, 71},
	  {'浪人长枪', 1, 0, 6},
    },
    [5] = {
      {'新手生药', 50, 0, 73},
      {'新手汤药', 50, 0, 71},
	  {'浪人长剑', 1, 0, 1},
    },
    [7] = {
      {'新手生药', 50, 0, 73},
      {'新手汤药', 50, 0, 71},
	  {'浪人长刀', 1, 0, 1},
    },
    [9] = {
      {'新手生药', 50, 0, 73},
      {'新手汤药', 50, 0, 71},
	  {'浪人手套', 1, 0, 85},
    },
    [11] = {
      {'新手生药', 100, 0, 73},
      {'新手汤药', 100, 0, 71},
    },
    [13] = {
      {'新手生药', 100, 0, 73},
      {'新手汤药', 100, 0, 71},
    },
    [15] = {
      {'新手生药', 100, 0, 73},
      {'新手汤药', 100, 0, 71},
    },
  },
  --任务名称
  Name = {
    [1] = '新手任务[1]',
    [2] = '新手任务[1]',
    [3] = '新手任务[2]',
    [4] = '新手任务[2]',
    [5] = '新手任务[3]',
    [6] = '新手任务[3]',
    [7] = '新手任务[4]',
    [8] = '新手任务[4]',
    [9] = '新手任务[5]',
    [10] = '新手任务[5]',
    [11] = '新手任务[6]',
    [12] = '新手任务[6]',
    [13] = '新手任务[7]',
    [14] = '新手任务[7]',
  },	
};

--任务触发
NewTask.Start = function(uSource)
  --获取玩家地图ID和坐标
  local MapId, X, Y =  B_GetPosition(uSource);
  --检查地图
  if MapId ~= 0 and MapId ~= 131 then return end;
  --获取玩家新手任务ID
  local Value = P_GetTempArr(uSource, NewTask.QuestArr);
  --有任务返回信息
  if NewTask.Info[Value] ~= nil then
    local AwardStr = '';
	if NewTask.Award[Value] ~= nil then 
	  AwardStr = NewTask.GetQuestAwardStr(NewTask.Award[Value]);
	end
    local questInfo = string.format('%s<%s>?<%s>', '', NewTask.GetInfoStr(uSource, Value), AwardStr);
    P_SendQuestInfo(uSource, NewTask.QuestArr, 0, NewTask.Name[Value], questInfo, false, false);
  end;
end;	

--任务提示信息
NewTask.GetInfoStr = function(uSource, Value)
  local Str = '';
  -- 任务提示
  if NewTask.Info[Value] ~= nil then 
    Str = string.format('%s目标: %s', Str, NewTask.Info[Value]);
  end;
  -- 击杀提示
  if NewTask.Kill[Value] ~= nil then 
    Str = string.format('%s^完成: 已击杀%d/%d', Str, P_GetTempArr(uSource, NewTask.DieArr), NewTask.Kill[Value]);	
  end;
  return Str;
end;

--怪物死亡触发
NewTask.MonsterDie = function(uSource, MonsterName, MapId)
  if MapId ~= 0 and MapId ~= 131 then return end;
  if NewTask.Monster[MonsterName] == nil then return end;
  --获取玩家新手任务ID
  local Value = P_GetTempArr(uSource, NewTask.QuestArr);
  --有杀怪数量信息反馈
  if NewTask.KillName[Value] ~= nil and NewTask.KillName[Value] == MonsterName then
    --获取玩家当前所杀怪物
    local PlayDie = P_GetTempArr(uSource, NewTask.DieArr);
    if PlayDie + 1 > NewTask.Kill[Value] then
      --提示任务完成
      P_sayByCol(uSource, string.format('【任务提示】%s已完成', NewTask.Name[Value]), 65280, 0);
    else
      --写入杀怪数量
      P_SetTempArr(uSource, NewTask.DieArr, PlayDie + 1);
      --提示杀怪数量
      P_sayByCol(uSource, string.format('【任务提示】%s,已经击杀%s(%d/%d个)', NewTask.Name[Value], MonsterName, PlayDie + 1, NewTask.Kill[Value]), 65280, 0);
      --更新任务信息
      local AwardStr = '';
      if NewTask.Award[Value] ~= nil then 
	    AwardStr = NewTask.GetQuestAwardStr(NewTask.Award[Value]);
      end
      local questInfo = string.format('%s<%s>?<%s>', '', NewTask.GetInfoStr(uSource, Value), AwardStr);
      P_SendQuestInfo(uSource, NewTask.QuestArr, 0, NewTask.Name[Value], questInfo, false, false);
    end
  end;
end;

--任务提示信息
NewTask.Confirm = function(uSource)
  P_sayByCol(uSource, '【任务提示】清前往对应NPC完成任务', 65280, 0);
end;

--获取任务奖励字符
NewTask.GetQuestAwardStr = function(Award)
	local Str = '';
	for i, v in pairs(Award) do
		if type(v) == 'table' then
			Str = string.format('%s%s^数量:%d#%d#%d', Str, v[1], v[2], v[3], v[4])
			if i ~= #Award then Str = Str .. ';' end;
		end
	end;
	return Str;
end;