package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '拥堵传送员';

--传送表,后面是地图ID,坐标X,坐标y,钱币
local Convey = {
   [1] = {
      ['Name'] = '帝 王 陵', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 709, 680}, 
   }, 
   [2] = {
      ['Name'] = '狐 狸 洞', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 127, 272}, 
   }, 
   [3] = {
      ['Name'] = '刺客神殿', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 797, 683}, 
   }, 
   [4] = {
      ['Name'] = '侠 客 村', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 570, 600}, 
   }, 
   [5] = {
      ['Name'] = '书 生 村', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 305, 404}, 
   }, 
   [6] = {
      ['Name'] = '极 乐 寺', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 532, 814}, 
   }, 
   [7] = {
      ['Name'] = '犀牛森林', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 783, 532}, 
   }, 
   [8] = {
      ['Name'] = '石 头 山', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 747, 207}, 
   }, 
   [9] = {
      ['Name'] = '千 年 村', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 223, 230}, 
   },
   [10] = {
      ['Name'] = '白老虎场', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 220, 520}, 
   },
   [11] = {
      ['Name'] = '地下墓地', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 398, 711}, 
   },
   [12] = {
      ['Name'] = '老虎森林', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 414, 300}, 
   },
   [13] = {
      ['Name'] = '梅花夫人处', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 600, 180}, 
   },
   [14] = {
      ['Name'] = '高丽剑士宅', 
      ['money'] = {'钱币', 1000}, 
      ['Map'] = {1, 439, 183}, 
   },
};

local PlayMove = {
  {540, 488}, 
  {526, 488}, 
  {512, 488}, 
  {512, 461}, 
  {536, 463}, 
  {549, 450}, 
  {546, 495}, 
  {504, 495}, 
  {500, 450}, 
};

local MainMenu =
[[
您好,我可以把你传送到周边?^^

<『$00FFFF00| 移动到周边』/@movezb>
]];


function OnMenu(uSource, uDest)
  P_MenuSay(uSource, MainMenu);
 return;
end

function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;

  if aStr == 'movezb' then
     local M = PlayMove[math.random(#PlayMove)];
     if M ~= nil then
	    P_MapMove(uSource, 1, M[1], M[2], 0);
     end;
    return;
  end;

  if aStr == 'putong' then
    local Str = '请问要去哪里?^^';
    for i = 1, #Convey do
      if type(Convey[i]) == 'table' then
        Str = string.format('%s<『$00FFFF00| %s』 %s:%d/@pcs_%d>^', Str, Convey[i].Name, Convey[i].money[1], Convey[i].money[2], i);
      end;
    end;
    P_MenuSay(uSource, Str);
   return;
  end;

  local Left, Right = lua_GetToken(aStr, "_");
  if Left == 'pcs' then
    local t = Convey[tonumber(Right)];
    if t == nil then return end;
	
    if P_GetTempArr(uSource, 13) ~= 0 then 
      P_MenuSay(uSource, '正在接镖状态,无法传送!');
     return;
    end;
	
    local CurLife = B_GetCurLife(uSource);
    local MaxLife = B_GetMaxLife(uSource);
    if CurLife < MaxLife then 
      P_MenuSay(uSource, '满血才可使用!');
      return;
    end
	
    --检测钱币
    if P_getitemcount(uSource, t.money[1]) < t.money[2] then 
       P_MenuSay(uSource, string.format('你没有 %d个%s！', t.money[2], t.money[1]));
      return;
    end;
    --删除钱币
	P_deleteitem(uSource, t.money[1], t.money[2], '传送');
    --传送
    P_MapMove(uSource, t.Map[1], t.Map[2], t.Map[3], 0);
    return;
  end;

 return;
end