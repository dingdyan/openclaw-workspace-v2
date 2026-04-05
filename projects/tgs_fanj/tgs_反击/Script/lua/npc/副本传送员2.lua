package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '副本传送员';

--安全副本次数
local VipNum = {
  [1] = 1,
  [2] = 2,
  [3] = 3,
  [4] = 5,
}

--传送表,后面是地图ID,坐标X,坐标y,钱币

local Convey = {
  ['pt'] = {
    [1] = {
      ['Name'] = '极乐洞(需钱币1)', 
      ['Map'] = {21, 110, 39}, 
      --['Time'] = {360000, 60000}, 
      ['Age'] = 100, 
      ['money'] = {'钱币', 1}, 
    }, 
  },
  ['aq'] = {
   [1] = {
      ['Name'] = '安全极乐洞-1馆(需钱币1000)', 
      ['Map'] = {150, 39, 30}, 
      ['Time'] = {360000, 60000}, 
      ['Age'] = 3000, 
      ['money'] = {'钱币', 1000}, 
   }, 
   [2] = {
      ['Name'] = '安全极乐洞-2馆(需钱币1000)', 
      ['Map'] = {151, 50, 21}, 
      ['Time'] = {360000, 60000}, 
      ['Age'] = 3000, 
      ['money'] = {'钱币', 1000}, 
   }, 
   [3] = {
      ['Name'] = '安全极乐洞-本馆(需钱币1000)', 
      ['Map'] = {152, 28, 32}, 
      ['Time'] = {360000, 60000}, 
      ['Age'] = 3000, 
      ['money'] = {'钱币', 1000}, 
   }, 
  },
};
local MainMenu =
[[
尊敬的玩家,想前往哪个副本^
^
<『$00FFFF00| 传送 普通副本』/@pt>^

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
  
  if aStr == 'pt' then
    local Str = '请问要去哪里?^^';
    for i = 1, #Convey['pt'] do
      if type(Convey['pt'][i]) == 'table' then
        Str = string.format('%s<『$00FFFF00| %s』/@cs_pt_%d>^', Str, Convey['pt'][i].Name, i);
      end;
    end;
	Str = string.format('%s<『$00FFFF00| 返 回』/@fanhui>', Str);	
    P_MenuSay(uSource, Str);
    return;
  end;
  
  if aStr == 'aq' then
    local Str = '请问要去哪里?^^';
    for i = 1, #Convey['aq'] do
      if type(Convey['aq'][i]) == 'table' then
        Str = string.format('%s<『$00FFFF00| %s』/@cs_aq_%d>^', Str, Convey['aq'][i].Name, i);
      end;
    end;
	Str = string.format('%s<『$00FFFF00| 返 回』/@fanhui>', Str);	
    P_MenuSay(uSource, Str);
    return;
  end;

  local Left, Right = lua_GetToken(aStr, "_");
  if Left == 'cs' then
    local Type, Index = lua_GetToken(Right, "_");
    local t = Convey[Type];
    if t == nil then return end;
    t = t[tonumber(Index)];
    if t == nil then return end;
	--判断时间
	if t['Time'] ~= nil then 
      local i =  M_GetMapRemainTickById(t['Map'][1]);
	  if i <= t['Time'][1] - t['Time'][2] then 
        P_MenuSay(uSource, string.format('地图剩余[%s]可进入', timestostring(i // 100)));
        return;
	  end;
	end;
	--检测年龄
	if t['Age'] ~= nil then
      local Attrib = P_GetAttrib(uSource);
	  if Attrib.Age < t['Age'] then 
	    P_MenuSay(uSource, string.format('年龄到达%0.2f才可进入!', t['Age'] // 100));
	   return;
	  end; 
	end;
	--检测元气
	if t['Energy'] ~= nil then
      local Attrib = P_GetAttrib(uSource);
	  if Attrib.Energy < t['Energy'] then 
	    P_MenuSay(uSource, string.format('元气到达%0.2f才可进入!', t['Energy'] // 100));
	   return;
	  end; 
	end;
    --检测道具
    if P_getitemcount(uSource, t.money[1]) < t.money[2] then 
      P_MenuSay(uSource, string.format('请拿来%d个%s', t.money[2], t.money[1]));
     return;
    end;
	--安全副本判断次数
	if Type == 'aq' then 
	  --获取VIP
	  local viplevel, viptime = P_GetVipInfo(uSource);
	  local freenum = 0;
	  local _max = VipNum[viplevel];
	  if _max == nil then 
        P_MenuSay(uSource, '你的VIP等级无法进入');
       return;
	  end;
	  --获取领取时间戳
	  local aNow = P_GetTempArr(uSource, 2);
	  --判断日期相同,读取今日次数	
	  if os.date("%Y-%m-%d", aNow) == os.date("%Y-%m-%d", os.time()) then 
	    freenum = P_GetTempArr(uSource, 3);
	  end;
	  --判断进入次数
	  if freenum >= _max then 
	    P_MenuSay(uSource, string.format('今日已进入%d次安全副本,无法在进入了', freenum));
	    return;
	  end;
	  --vip记录时间和进入次数
	  P_SetTempArr(uSource, 2, os.time());	
	  P_SetTempArr(uSource, 3, freenum + 1);
	end;
    --删除道具
    P_deleteitem(uSource, t.money[1], t.money[2], '驿站传送');
    --传送
    P_MapMove(uSource, t.Map[1], t.Map[2], t.Map[3], 0);
    return;
  end;
 return;
end