package.loaded['Script\\lua\\f'] = nil;
--package.loaded['Script\\lua\\plug\\传送装备检测'] = nil;

require ('Script\\lua\\f');
--require ('Script\\lua\\plug\\传送装备检测');

local Npc_Name = '传送员';

local MainMenu =
[[
想去哪里呢?^^
<「游标.bmp」『$FF00FF00| 基本传送』/@ptcs>^^
<「游标.bmp」『$FF00FF00| 副本传送』/@fbcs>^^
<「游标.bmp」『$FF00FF00| 进入修炼场』/@jrxlc>^^
]];
--<「游标.bmp」『$00FFFF00| 副本传送』/@fbcs>^^
--<「游标.bmp」『$00FFFF00| 进入 VIP修练场』/@vipxl>^^
local XLDMenu =
[[
进入前请先领取VIP修炼场时间(每日领取)^
每日领取8小时修炼时间^
未使用的修炼时间可叠加^^
<「游标.bmp」『$00FFFF00| 进入 VIP修炼场』/@vipxljr>^
<「游标.bmp」『$00FFFF00| 领取 VIP修炼场时间』/@vipxllq>^
<「游标.bmp」『$00FFFF00| 查询 VIP修炼场时间』/@vipxlcx>^
<「游标.bmp」『$00FFFF00| 返回』/@fanhui>
]];

local _fuben = {
   [1] = {
      ['Name'] = '太极老人处', 
      ['Map'] = {31, 35, 56}, 
	  ['Item'] = {'钱币', 5000},
   }, 
  
  --[[[2] = {
    ['Name'] = '帝王石谷', 
    ['Map'] = {46, 29, 49},
    --['Zb'] = {3, 3, '穿戴3件以上极乐系列装备才可进入'}, 
  }, 
  
  [3] = {
    ['Name'] = '黄金沙漠', 
    ['Map'] = {44, 149, 412},
    --['Zb'] = {3, 3, '穿戴3件以上极乐系列装备才可进入'}, 
  },
  
  [2] = {
    ['Name'] = '轩辕谷', 
    ['Map'] = {110, 110, 150}, 
    ['Time'] = {180000, 60000},
    --['Zb'] = {1, 3, '穿戴3件以上王陵系列装备才可进入'}, 
  }, 
  [3] = {
    ['Name'] = '秦皇宫', 
    ['Map'] = {126, 86, 96}, 
    ['Time'] = {360000, 60000},
    --['Zb'] = {3, 3, '穿戴3件以上极乐系列装备才可进入'}, 
  }, 
  [4] = {
    ['Name'] = '日月王城', 
    ['Map'] = {120, 145, 160}, 
    ['Time'] = {1080000, 60000}, 
    ['Item'] = {'日月门票', 1},
    --['Zb'] = {4, 3, '穿戴3件以上太极系列装备才可进入'}, 
  }, ]]
}

--传送表,后面是地图ID,坐标X,坐标y,钱币
local Convey = {
   [1] = {
      ['Name'] = '帝王陵', 
      ['money'] = {'钱币', 500}, 
      ['Map'] = {1, 702, 687}, 
   }, 

   [2] = {
      ['Name'] = '狐狸洞', 
      ['money'] = {'钱币', 500}, 
      ['Map'] = {1, 129, 270}, 
   }, 
   
   [3] = {
      ['Name'] = '极乐寺', 
      ['money'] = {'钱币', 500}, 
      ['Map'] = {1, 538, 810}, 
   }, 
   
   [4] = {
      ['Name'] = '犀牛森林', 
      ['money'] = {'钱币', 500}, 
      ['Map'] = {1, 780, 530}, 
   }, 
   
   [5] = {
      ['Name'] = '石头山', 
      ['money'] = {'钱币', 500}, 
      ['Map'] = {1, 749, 206}, 
   }, 
   
   [6] = {
      ['Name'] = '千年村', 
      ['money'] = {'钱币', 500}, 
      ['Map'] = {1, 271, 215}, 
   },
   
   [7] = {
      ['Name'] = '老虎森林', 
      ['money'] = {'钱币', 500}, 
      ['Map'] = {1, 390, 301}, 
   },
   
   [8] = {
      ['Name'] = '地下墓地', 
      ['money'] = {'钱币', 500}, 
      ['Map'] = {1, 397, 707}, 
   }, 
   [9] = {
      ['Name'] = '太极剑门', 
      ['money'] = {'钱币', 500}, 
      ['Map'] = {1, 151, 725}, 
   }, 
   [10] = {
      ['Name'] = '帝王石谷', 
      ['money'] = {'钱币', 500}, 
      ['Map'] = {1, 108, 884}, 
   }, 
   [11] = {
      ['Name'] = '侠客村', 
      ['money'] = {'钱币', 500}, 
      ['Map'] = {1, 571, 599}, 
   }, 
   [12] = {
      ['Name'] = '白虎场', 
      ['money'] = {'钱币', 500}, 
      ['Map'] = {1, 253, 544}, 
   }, 
   [13] = {
      ['Name'] = '双花店', 
      ['money'] = {'钱币', 500}, 
      ['Map'] = {1, 588, 200}, 
   }, 
};


function OnMenu(uSource, uDest)
 P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;
  
  --VIP修练场
  if aStr == 'vipxl' then
    P_MenuSay(uSource, XLDMenu);
   return;
  end;
  
  if aStr == 'fanhui' then
    P_MenuSay(uSource, MainMenu);
   return;
  end;
  
  --进入免费修炼场
  if aStr == 'jrxlc' then
	--传送玩家
    P_MapMove(uSource, 105, 122, 103, 5);	
    return;
  end;	
  
  --进入VIP修炼场
  if aStr == 'vipxljr' then
    --获取当前时间
	 local aTime = P_GetTempArr(uSource, 9);
     if aTime <= 0 then 
       P_MenuSay(uSource, '你没有VIP修炼场时间,无法进入!');
      return;
     end;
	--传送玩家
    P_MapMove(uSource, 105, 122, 103, 5);	
	--提示时间
    P_saysystem(uSource, string.format('VIP修练场时间剩余 %s', timestostring(aTime)), 15);	
    return;
  end;	

  --领取VIP修炼场时间
  if aStr == 'vipxllq' then
    --获取VIP信息
    local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then 
      P_MenuSay(uSource, '会员才可领取!');
      return 'true';
    end;
    --获取当前时间
	local aTime = P_GetTempArr(uSource, 9);
    if aTime > 60 * 60 * 100 then 
      P_MenuSay(uSource, '当前剩余时间超过100个小时,无法继续领取');
     return;
    end;
	--获取领取时间戳
	local aNow = P_GetTempArr(uSource, 10);
	--判断日期	
    if os.date("%Y-%m-%d", aNow) == os.date("%Y-%m-%d", os.time()) then 
      P_MenuSay(uSource, '今日已领取过!');
     return;
    end;
	--判断VIP等级
	if viplevel == 3 then 
	  aTime = aTime + 60 * 60 * 8;	
	end
	if viplevel == 2 then
	  aTime = aTime + 60 * 60 * 8;	  
    end 
	if viplevel == 1 then
	  aTime = aTime + 60 * 60 * 8;	  
    end 

	--修改修炼场时间
	P_SetTempArr(uSource, 9, aTime);
	--修改领取时间戳
	P_SetTempArr(uSource, 10, os.time());	
    --随机传送到修炼场
    P_MenuSay(uSource, '恭喜你领取了VIP修炼场时间!');
    return;
  end;	

  --查询VIP修炼场时间
  if aStr == 'vipxlcx' then
	local aTime = P_GetTempArr(uSource, 9);
    P_MenuSay(uSource, string.format('当前VIP修练场时间: %s', timestostring(aTime)));
    return;
  end;	
  
  if aStr == 'ptcs' then
    local Str = '请问要去哪里?^^';
    for i = 1, #Convey do
      if type(Convey[i]) == 'table' then
        Str = string.format('%s<「游标.bmp」『$FF00FF00| %s』 - (%s:%d)/@pcs_%d>^', Str, Convey[i].Name, Convey[i].money[1], Convey[i].money[2], i);
      end;
    end;
    P_MenuSay(uSource, Str);
    return;
  end;
  
    if aStr == 'fbcs' then
    local Str = '请选择要进入的副本^^';
    for i = 1, #_fuben do
      if type(_fuben[i]) == 'table' then
        Str = string.format('%s<「游标.bmp」『$FF00FF00| %s』/@fcs_%d>^^', Str, _fuben[i].Name, i);
      end;
    end;
    P_MenuSay(uSource, Str);
    return;
  end;
  
  if aStr == 'fbcs' then
    local Str = '请选择要进入的副本^^1,日月王城共3层,3小时开放一次,前10分钟进入^2,进入王城2层和王城3层需要:日月令1个^3,日月令在1层和2层怪物有爆出^^';
    for i = 1, #_fuben do
      if type(_fuben[i]) == 'table' then
        Str = string.format('%s<「游标.bmp」『$FF00FF00| %s』 - (%s:%d)/@fcs_%d>^', Str, _fuben[i].Name, _fuben[i].Item[1], _fuben[i].Item[2], i);
      end;
    end;
    P_MenuSay(uSource, Str);
    return;
  end;
  

  local Left, Right = lua_GetToken(aStr, "_");
  if Left == 'pcs' then
    local t = Convey[tonumber(Right)];
    if t == nil then return end;
    --检测道具
    if P_getitemcount(uSource, t.money[1]) < t.money[2] then 
      P_MenuSay(uSource, string.format('请拿来%d个%s', t.money[2], t.money[1]));
     return;
    end;
    --删除道具
    P_deleteitem(uSource, t.money[1], t.money[2], '传送员');
    --传送
    P_MapMove(uSource, t.Map[1], t.Map[2], t.Map[3], 0);
    return;
  end;
  if Left == 'fcs' then
    local t = _fuben[tonumber(Right)];
    if t == nil then return end;
	--判断时间
	if t['Time'] ~= nil then 
      local i =  M_GetMapRemainTickById(t['Map'][1]);
	  if i <= t['Time'][1] - t['Time'][2] then 
        P_MenuSay(uSource, string.format('地图剩余[%s]可进入', timestostring(i // 100)));
        return;
	  end;
	end;
	--判断材料
	if t['Item'] ~= nil then 
	  if P_getitemcount(uSource, t['Item'][1]) < t['Item'][2] then
        P_MenuSay(uSource, string.format('需要%d个%s', t['Item'][2], t['Item'][1]));
       return;
	  end;
	end;
	--[[判断装备
	if CheckWear.Get(uSource, t['Zb'][1], t['Zb'][2]) ~= true then 
      P_MenuSay(uSource, t['Zb'][3]);
      return;
	end;]]
	--判断元气
	 if t.Map[1] == 1 or t.Map[1] == 31 then
	  if P_GetAttrib(uSource).Energy < 48000 then
	   P_MenuSay(uSource, '境界到达[神话境]才能进入');
         return;
       end;
	 end
     if t.Map[1] == 2 or t.Map[1] == 46 then
	  if P_GetAttrib(uSource).Energy < 78000 then
	   P_MenuSay(uSource, '境界到达[天人合一]才能进入');
	    return;
       end;
	 end 
	 if t.Map[1] == 3 or t.Map[1] == 44 then
	  if P_GetAttrib(uSource).Energy < 78000 then
	   P_MenuSay(uSource, '境界到达[天人合一]才能进入');
	    return;
       end;
	 end 
	 if t.Map[1] == 4 or t.Map[1] == 110 then
	  if P_GetAttrib(uSource).Energy < 36000 then
	   P_MenuSay(uSource, '境界到达[无为境]才能进入');
         return;
       end;
	 end
     if t.Map[1] == 5 or t.Map[1] == 126 then
	  if P_GetAttrib(uSource).Energy < 62000 then
	   P_MenuSay(uSource, '境界到达[无上无念]才能进入');
	    return;
       end;
	 end 
	 if t.Map[1] == 6 or t.Map[1] == 120 then
	  if P_GetAttrib(uSource).Energy < 96000 then
	   P_MenuSay(uSource, '境界到达[至尊无上]才能进入');
	    return;
       end;
	 end 
	--删除材料
	if t['Item'] ~= nil then 
	  P_deleteitem(uSource, t['Item'][1], t['Item'][2], '传送员');
	end;
    --传送
    P_MapMove(uSource, t['Map'][1], t['Map'][2], t['Map'][3], 0);
    return;
  end;
 return;
end