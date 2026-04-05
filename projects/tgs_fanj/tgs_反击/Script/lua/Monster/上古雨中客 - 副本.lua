local Npc_Name = '上古雨中客';

local times = 0;

local MainMenu =
[[幸会. 我是肩负守护王陵重任的雨中客. ^
现今夜贼频出,不知侠客是否愿拔刀相助.^^

<『$00FFFF00| 请雨中客转送至禁区.』/@goarea>^
]];

--死亡
function OnDie(uSource, uDest, race)
  local MapId, AX, AY = B_GetPosition(uDest);
  --查找地图中怪物是否存在
  if M_MapFindMonster(MapId, '上古雨中客2', 0) > 0 then
    M_MapDelMonster(MapId, '上古雨中客2');
  end
  M_MapAddMonster(MapId, '上古雨中客2', 178, 21, 1, 2, '', 0, 0, true, 0);
  return;
end;

function OnMenu(uSource, uDest)
   P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'request' then
    if P_getitemcount(uSource, '雨中客锦囊') >= 1 then
      P_MenuSay(uSource, '看来._准备还是有些不足哇');
     return;
    end;
    if P_getitemcount(uSource, '玉仙的无情双刀') >= 1 then
      P_MenuSay(uSource, '看来._准备还是有些不足哇');
     return;
    end;
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end;  
	P_additem(uSource, '雨中客锦囊', 1, '上古雨中客');
	P_MenuSay(uSource, '我的眼力还不错吧');
    P_saysystem(uSource, '拿20个_疾风灵符来', 2);
    return;
  end;

  if aStr == 'removal' then
    if P_getitemcount(uSource, '雨中客锦囊') < 1 then
      P_MenuSay(uSource, '阁下似乎帮不上我什么忙');
     return;
    end;
	local count = P_getitemcount(uSource, '疾风灵符');
    if count < 20 then
      P_MenuSay(uSource, '拿_20个疾风灵符来');
     return;
    end;
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end;  
	P_deleteitem(uSource, '雨中客锦囊', 1, '上古雨中客');
	P_deleteitem(uSource, '疾风灵符', count, '上古雨中客');
	P_additem(uSource, '龙虎灵符', 2, '上古雨中客');

	P_MenuSay(uSource, '辛苦了_终于可以安稳入睡了');
    P_saysystem(uSource, '雨中客任务顺利完成', 2);
    return;
  end;

  --取回王陵4大宝物拿给雨中客
  if aStr == 'returntreasure' then
    if P_getitemcount(uSource, '王妃金冠') < 1 then
      P_MenuSay(uSource, '阁下..江湖上传得..沸沸扬扬的..^王陵四大宝物..王妃金冠..是否有所耳闻?');
     return;
    end;
    if P_getitemcount(uSource, '公主戒指') < 1 then
      P_MenuSay(uSource, '阁下..江湖上传得..沸沸扬扬的..^王陵四大宝物..公主戒指..是否有所耳闻?');
     return;
    end;
    if P_getitemcount(uSource, '公主项链') < 1 then
      P_MenuSay(uSource, '阁下..江湖上传得..沸沸扬扬的..^王陵四大宝物..公主项链..是否有所耳闻?');
     return;
    end;
    if P_getitemcount(uSource, '王子宝剑') < 1 then
      P_MenuSay(uSource, '阁下..江湖上传得..沸沸扬扬的..^王陵四大宝物..王子宝剑..是否有所耳闻?');
     return;
    end;
	--检测背包空位
	if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满!');
      return;
	end;  
	P_deleteitem(uSource, '王妃金冠', 1, '上古雨中客');
	P_deleteitem(uSource, '公主戒指', 1, '上古雨中客');
	P_deleteitem(uSource, '公主项链', 1, '上古雨中客');
	P_deleteitem(uSource, '王子宝剑', 1, '上古雨中客');
	--获取玩家性别
	local sex = P_getsex(uSource);
	if P_getsex(uSource) == 1 then
	  P_additem(uSource, '男子雨中客斗笠', 1, '上古雨中客');
	else
	  P_additem(uSource, '女子雨中客斗笠', 1, '上古雨中客');
	end	
	P_MenuSay(uSource, '如此贵重之物_阁下是如何获得的!^作为_酬劳_请收下本人的斗笠');
    return;
  end;
  
  --请雨中客转送至禁区
  if aStr == 'goarea' then
    local MapId, AX, AY = B_GetPosition(uDest);
    --获取地图剩余时间 
    local iTick = M_GetMapRemainTickById(MapId)
	if iTick <= 30000 then
      P_MenuSay(uSource, '时间...来不及了...再会...');
      return;
	end
	if times + 3 > os.time() then 
      P_MenuSay(uSource, '稍等._禁区好像有人...');
      return;
	end
	--判断物品
    if P_getitemcount(uSource, '王陵守护印') < 1 then
      P_MenuSay(uSource, '手上没有王陵守护印吧...');
     return;
    end;
	--判断辅助武功
    if P_GetCurUseMagic(uSource, 4) ~= '' then
      P_MenuSay(uSource, '禁止使用辅助性武功...');
     return;
    end;
    if P_CheckCurUseRMagic(uSource, 2) == true then 
      P_MenuSay(uSource, '禁止使用辅助性武功');
      return;
    end;
	local ToMap = 77;
	if MapId == 26 then 
	  ToMap = 46;
	end;
    --检测地图玩家数
    if M_MapUserCount(ToMap) > 0 then
      P_MenuSay(uSource, '稍等._禁区好像有人...');
     return;
    end;
    --刷新地图
    if not M_MapRegen(ToMap) then 
      P_MenuSay(uSource, '稍等片刻...');
     return;
    end
    --检测怪物
    -- if M_MapFindMonster(ToMap, '禁地护卫武士', 0) <= 0 then 
      -- P_MenuSay(uSource, '稍等...');
     -- return;
    -- end;	
    --删除道具
    P_deleteitem(uSource, '王陵守护印', 1, '上古雨中客');
    --1秒后传送
	P_MapMove(uSource, ToMap, 26, 46, 100);
    --NPC说话
	B_SAY(uDest, '小子_明年的今天就是你的忌日');
	--记录时间
	times = os.time();
    return;
  end;
 return;
end