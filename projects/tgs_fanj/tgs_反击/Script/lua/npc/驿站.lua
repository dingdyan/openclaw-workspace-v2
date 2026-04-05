package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '传送员';

--传送表,后面是地图ID,坐标X,坐标y,钱币
local Convey = {
   [1] = {
      ['Name'] = '帝 王 陵', 
      ['money'] = 500, 
      ['Map'] = {1, 709, 680}, 
   }, 
   [2] = {
      ['Name'] = '狐 狸 洞', 
      ['money'] = 500, 
      ['Map'] = {1, 127, 272}, 
   }, 

   [3] = {
      ['Name'] = '太极剑门', 
      ['money'] = 500, 
      ['Map'] = {1, 142, 715}, 
   }, 
   [4] = {
      ['Name'] = '刺客神殿', 
      ['money'] = 500, 
      ['Map'] = {1, 797, 683}, 
   }, 
   [5] = {
      ['Name'] = '侠 客 村', 
      ['money'] = 500, 
      ['Map'] = {1, 570, 600}, 
   }, 
   [6] = {
      ['Name'] = '书 生 村', 
      ['money'] = 500, 
      ['Map'] = {1, 305, 404}, 
   }, 
   [7] = {
      ['Name'] = '极 乐 寺', 
      ['money'] = 500, 
      ['Map'] = {1, 532, 814}, 
   }, 
   [8] = {
      ['Name'] = '犀牛森林', 
      ['money'] = 500, 
      ['Map'] = {1, 783, 532}, 
   }, 
   [9] = {
      ['Name'] = '石 头 山', 
      ['money'] = 500, 
      ['Map'] = {1, 747, 207}, 
   }, 
   [10] = {
      ['Name'] = '千 年 村', 
      ['money'] = 500, 
      ['Map'] = {1, 223, 230}, 
   },
   [11] = {
      ['Name'] = '白老虎场', 
      ['money'] = 500, 
      ['Map'] = {1, 220, 520}, 
   },
   [12] = {
      ['Name'] = '地下墓地', 
      ['money'] = 500, 
      ['Map'] = {1, 398, 711}, 
   },
   [13] = {
      ['Name'] = '帝王石谷', 
      ['money'] = 500, 
      ['Map'] = {1, 120, 874}, 
   },
   [14] = {
      ['Name'] = '老虎森林', 
      ['money'] = 500, 
      ['Map'] = {1, 414, 300}, 
   },
   [15] = {
      ['Name'] = '梅花夫人处', 
      ['money'] = 500, 
      ['Map'] = {1, 600, 180}, 
   },
   [16] = {
      ['Name'] = '高丽剑士宅', 
      ['money'] = 500, 
      ['Map'] = {1, 439, 183}, 
   },
};
--VIP传送表,后面是地图ID,坐标X,坐标y,钱币
local FBConvey = {
   [1] = {
      ['Name'] = '帝王陵',  
      ['money'] = 1000, 
      ['Map'] = {3, 37, 63}, 
      ['Time'] = {360000, 60000}, 
   }, 
   [2] = {
      ['Name'] = '狐狸洞',  
      ['money'] = 1000, 
      ['Map'] = {19, 60, 116}, 
      ['Time'] = {180000, 30000}, 
   }, 
   [3] = {
      ['Name'] = '极乐洞一馆',  
      ['money'] = 2000, 
      ['Map'] = {27, 39, 30}, 
   }, 
   [4] = {
      ['Name'] = '极乐洞二馆',  
      ['money'] = 2000, 
      ['Map'] = {28, 50, 21}, 
   }, 
   [5] = {
      ['Name'] = '极乐洞本馆',  
      ['money'] = 2000, 
      ['Map'] = {29, 28, 32}, 
   }, 
   [6] = {
      ['Name'] = '太极剑门内', 
      ['money'] = 2000, 
      ['Map'] = {31, 146, 155}, 
   }, 
   [7] = {
      ['Name'] = '太极老人处', 
      ['money'] = 2000, 
      ['Map'] = {31, 33, 33}, 
   }, 
   [8] = {
      ['Name'] = '东海沼泽', 
      ['money'] = 2000, 
      ['Map'] = {43, 202, 224}, 
   }, 
   [9] = {
      ['Name'] = '北海雪原', 
      ['money'] = 2000, 
      ['Map'] = {45, 24, 236}, 
   }, 
   [10] = {
      ['Name'] = '黄金沙漠', 
      ['money'] = 2000, 
      ['Map'] = {44, 186, 420}, 
   }, 
   [11] = {
      ['Name'] = '西域魔人石谷', 
      ['money'] = 3000, 
      ['Map'] = {44, 368, 371}, 
   }, 
   [12] = {
      ['Name'] = '王陵3层', 
      ['money'] = 3000, 
      ['Map'] = {70, 95, 257}, 
      ['Time'] = {360000, 60000}, 
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
[[您好,很高兴为您服务!!^^
<『$00FFFF00| ————【大地图传送】————』/@putong>^
<『$00FFFF00| ————【 副本传送 】————』/@gaoji>^
<『$00FFFF00| ————【移动到周边】————』/@movezb>^
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

  if aStr == 'gaoji' then
    local Str = '请问要去哪里?^^';
    for i = 1, #FBConvey do
      if type(FBConvey[i]) == 'table' then
        Str = string.format('%s<「游标.bmp」『$00FFFF00| %s』 钱币:%d/@gcs_%d>^', Str, FBConvey[i].Name, FBConvey[i].money, i);
      end;
    end;
    P_MenuSay(uSource, Str);
   return;
  end;

  if aStr == 'putong' then
    local Str = '请问要去哪里?^^';
    for i = 1, #Convey do
      if type(Convey[i]) == 'table' then
        Str = string.format('%s<「游标.bmp」『$00FFFF00| %s』 钱币:%d/@pcs_%d>^', Str, Convey[i].Name, Convey[i].money, i);
      end;
    end;
    P_MenuSay(uSource, Str);
   return;
  end;

  local Left, Right = lua_GetToken(aStr, "_");
  if Left == 'pcs' then
    local t = Convey[tonumber(Right)];
    if t == nil then return end;
    --检测钱币
    if P_getitemcount(uSource, '钱币') < t.money then 
       P_MenuSay(uSource, string.format('你没有%d个钱币！', t.money));
      return;
    end;
    --删除钱币
	P_deleteitem(uSource, '钱币', t.money, '传送');
    --传送
    P_MapMove(uSource, t.Map[1], t.Map[2], t.Map[3], 0);
    return;
  end;

  if Left == 'gcs' then
    local t = FBConvey[tonumber(Right)];
    if t == nil then return end;
    --检测钱币
    if P_getitemcount(uSource, '钱币') < t.money then 
       P_MenuSay(uSource, string.format('你没有%d个钱币！', t.money));
      return;
    end;
    --删除钱币
	P_deleteitem(uSource, '钱币', t.money, '传送');
	--王陵删除王陵守护印
	if t.Map[1] == 3 or t.Map[1] == 70 then
	  if P_getitemcount(uSource, '王陵守护印') >= 1 then 
	    P_deleteitem(uSource, '王陵守护印', 1, '传送');
	  end;	
    end;
    --传送
    P_MapMove(uSource, t.Map[1], t.Map[2], t.Map[3], 0);
    return;
  end;
 return;
end