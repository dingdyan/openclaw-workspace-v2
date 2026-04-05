ZxQuest = {
  Monster = {
    ['马'] = {465, 222},
    ['熊'] = {793, 726},
    ['鹿'] = {329, 479},
    ['牛'] = {430, 440},
    ['猪'] = {602, 290},
    ['僵尸'] = {622, 545},
    ['流氓'] = {403, 586},
    ['山贼'] = {770, 300},
    ['蝎子'] = {154, 914},
    ['土巨人'] = {294, 716},
    ['石巨人'] = {434, 710},
    ['豺狼'] = {780, 340},
    ['黑忍者'] = {685, 690},
    ['忍者'] = {346, 134},		
    ['北方魔人'] = {228, 169},
	['吸血木'] = {311, 174},
    ['犀牛'] = {760, 500},
    ['黑牛'] = {799, 533},
    ['白老虎'] = {215, 510},
    ['赤风'] = {799, 666},
    ['老虎'] = {411, 268},
    ['狂犬'] = {515, 543},
  },
  --任务随机条件
  Qday = {
   --[[{1, '鹿茸', 1, 8},
 {1, '鹿角', 1, 8},
 {1, '牛黄', 1, 8},
 {1, '犀牛皮', 1, 8},
 {1, '犀牛角', 1, 8},
 {1, '飞鹰剑', 1, 8},
 {1, '生肉', 1, 8},
 {1, '狐狸裘', 1, 3},
 {1, '陶器', 1, 3},
 {1, '老虎指甲', 1, 8},
 {1, '吸血根', 1, 3},
 {1, '蝎子尾巴', 1, 8},
 {1, '狼牙', 1, 3},
 {1, '狼皮', 1, 3},
 {1, '熊掌', 1, 8},
 {1, '熊皮', 1, 8},
 {1, '熊胆', 1, 8},
 {1, '火箭', 1, 8},]]
	{2, '猪', 1, 4},
{2, '鹿', 1, 4},
{2, '牛', 1, 4},
{2, '犀牛',1, 4},
{2, '黑牛', 1, 4},
{2, '白老虎', 1, 4},
{2, '僵尸', 1, 4},
{2, '山贼',1, 4},
{2, '石巨人', 1, 4},
{2, '土巨人', 1, 4},
{2, '蝎子', 1, 4},
{2, '北方魔人', 1, 4},
{2, '赤风', 1, 4},
{2, '黑忍者', 1, 4},
{2, '忍者', 1, 4},
{2, '熊', 1, 4},
{2, '吸血木', 1, 4},
{2, '流氓',  1, 4},
{2, '狂犬', 1, 4},
  },
  --任务上限
  Qmax = 9999999,
  --任务奖励
  Qitem =  {
    {'绑定生药', 100, 100},
	{'绑定汤药', 100, 100},
  },
  --固定次数额外奖励
  QIndexItem =  {
    [99999999] = {'门派战力', 10},
    [99999999] = {'绑定生药', 100},
  },
  --记录临时杀怪目标
  temp = {},
};

--重置任务状态
ZxQuest.Deltemp = function(uSource)
  P_DelQuestInfo(uSource, 2, 0);
  local PlayName = B_GetRealName(uSource);
  if ZxQuest.temp[PlayName] ~= nil then 
    ZxQuest.temp[PlayName] = nil;
  end;
end;

--删除任务状态
ZxQuest.Deltempa = function(uSource)
  P_DelQuestInfo(uSource, 2, 0);
  P_SetTempArr(uSource, 4, 0);
  P_SetTempStr(uSource, 5, ''); --写入数据
  local PlayName = B_GetRealName(uSource);
  if ZxQuest.temp[PlayName] ~= nil then 
    ZxQuest.temp[PlayName] = nil;
  end;
end;
	
--触发任务提示
ZxQuest.Start = function(uSource)
  --判断主线任务状态
  local Index = P_GetTempArr(uSource, 4);
  if Index < 1 or Index > ZxQuest.Qmax then return end;
  --获取任务信息 分类 目标 数量
  local aStr = P_GetTempStr(uSource, 5); 
  local QData = lua_Strtotable(aStr, ';');
  if #QData ~= 3 then return end;
  local Qtype = tonumber(QData[1]) or 0;
  local Qname = QData[2] or '';
  local Qcount = tonumber(QData[3]) or 0;
  --返回提示
  local queststr = '';
  if Qtype == 1 then 
    queststr = string.format('%s收集道具 [%d个%s]', queststr, Qcount, Qname);
  elseif Qtype == 2 then
    local xy = ZxQuest.Monster[Qname];
	if xy ~= nil then 
      queststr = string.format('%s击杀 %d个『$FF00ff00|[%s:%d_%d]』 已击杀[%d]只', queststr, Qcount, Qname, xy[1], xy[2], P_GetTempArr(uSource, 5));
	else
      queststr = string.format('%s击杀 %d个%s 已击杀[%d]只', queststr, Qcount, Qname, P_GetTempArr(uSource, 5));
	end;
  end;
  --发送任务提示
  local questInfo = string.format('%s<%s>?<%s>', '主线任务', queststr, '主线任务');
  P_SendQuestInfo(uSource, 2, 0, string.format('主线任务[%d]', Index), questInfo, false, true);
 return;
end;


--怪物死亡触发
ZxQuest.MonsterDie = function(uSource, MonsterName)
  if ZxQuest.Monster[MonsterName] == nil then return end;
  --判断主线任务状态
  local Index = P_GetTempArr(uSource, 4);
  if Index < 1 or Index > ZxQuest.Qmax then return end;
  --获取玩家名称
  local PlayName = B_GetRealName(uSource);
  --判断杀怪目标
  if ZxQuest.temp[PlayName] == nil then
    --获取任务信息
    local aStr = P_GetTempStr(uSource, 5); 
    local QData = lua_Strtotable(aStr, ';');
    if #QData ~= 3 then return end;
    local Qtype = tonumber(QData[1]) or 0;
    local Qname = QData[2] or '';
    local Qcount = tonumber(QData[3]) or 0;
	--记录临时变量
	ZxQuest.temp[PlayName] = {Qname, Qcount};
  end;
  --判断击杀的怪物
  if ZxQuest.temp[PlayName][1] ~= MonsterName then return end;
  --获取击杀次数
  local PlayDie = P_GetTempArr(uSource, 5);
  --写入杀怪数量
  P_SetTempArr(uSource, 5, PlayDie + 1);
  --提示杀怪数量
  if PlayDie + 1 > ZxQuest.temp[PlayName][2] then 
    P_sayByCol(uSource, '主线任务 >> 任务已完成', 65280, 0);
  else
    --发送任务提示
	local queststr = '';
    local xy = ZxQuest.Monster[MonsterName];
	if xy ~= nil then 
      queststr = string.format('击杀 %d个『$FF00ff00|[%s:%d_%d]』 已击杀[%d]只', ZxQuest.temp[PlayName][2], MonsterName, xy[1], xy[2], PlayDie + 1);
	else
      queststr = string.format('击杀 %d个%s 已击杀[%d]只', ZxQuest.temp[PlayName][2], MonsterName, PlayDie + 1);
	end;
    local questInfo = string.format('%s<%s>?<%s>', '主线任务', queststr, '主线任务');
    P_SendQuestInfo(uSource, 2, 0, string.format('主线任务[%d]', Index), questInfo, false, true);
  end;	
 return;
end;

--任务完成
ZxQuest.Comp = function(uSource, AGid)
 return;
end;