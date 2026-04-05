package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local Npc_Name = '太极老人';

--随机物品(物品名,数量)
Randomitem = {
  {'太极手套', 1},
  {'太极日剑', 1}, 
  {'太极月刀', 1}, 
  {'太极神枪', 1}, 
  {'太极斧', 1}, 
  {'男子太极护腕', 1}, 
  {'女子太极护腕', 1},
  {'男子太极道袍', 1}, 
  {'女子太极道袍', 1},
  {'男子太极鞋', 1}, 
  {'女子太极鞋', 1},
  {'男子太极道冠', 1}, 
  {'女子太极道冠', 1},
}

local MainMenu =
[[把令牌交给我.我领你去见太极公子^^
<「游标.bmp」『$FF00FF00| 交 令牌』/@goroom>^^
<「游标.bmp」『$FF00FF00| 交换太极明珠』/@changeweapon>^^
]];

--副本配置
local fuben = {
  --副本名
  names = '单人房间',
  --地图ID
  mapid = 32,
  --副本地图ID范围
  newid = {600, 609},
  --进入坐标
  XY = {18, 18},
  --进入时间变量
  times = 0,
};

local BoNewMap = false;

function GetNewMap()
  if not BoNewMap then 
    --循环检测创建地图
    for i = fuben.newid[1], fuben.newid[2] do
      --检测地图玩家数
      local iCount = M_MapUserCount(i);
      if iCount == nil or iCount <= 0 then
        --创建刷新地图	
        M_GetNewMap(fuben.mapid, i, string.format('%s(%d)', fuben.names, i));
      end;			
    end	
  end;
  BoNewMap = true;
end


function OnMenu(uSource, uDest)
  if not BoNewMap then
    GetNewMap()
  end;
  P_MenuSay(uSource, MainMenu);
 return;
end


function OnGetResult(uSource, uDest, aStr)
  if aStr == 'close' then
    return;
  end;
  
  if aStr == "dhmz" then
    --1,检测道具
    if P_getitemcount(uSource, '明珠碎片') < 180 then 
      P_MenuSay(uSource, '没有180个明珠碎片');
      return;
    end;
    --检测包裹
    if P_getitemspace(uSource) < 1 then
      P_MenuSay(uSource, '物品栏已满....');
     return;
    end;
    --删除
    P_deleteitem(uSource, '明珠碎片', 180, '太极老人');
    --给予物品
    P_additem(uSource, '太极明珠', 1, '太极老人');
    --给予物品
    P_MenuSay(uSource, '兑换成功');
  end;
  
  if aStr == "goroom" then
      --1,检测道具
      if P_getitemcount(uSource, '令牌') < 1 then 
         P_MenuSay(uSource, '有令牌吗?');
        return;
      end;
	  --判断间隔时间
	  local tm = os.time();
	  if tm < fuben.times then 
         P_MenuSay(uSource, '抱歉,3秒内只允许1个玩家进入,请稍后!');
        return;
      end;
	  --设定地图ID
      local MapID = 0;
	  --2,循环复制检测地图玩家数量
      for i = fuben.newid[1], fuben.newid[2] do
        --检测地图上次退出时间
	    local IsDupTime = M_MapGetboIsDupTime(i);
        if IsDupTime == nil or strtostamp(IsDupTime) + 30 <= os.time() then 
          --检测地图玩家数
          local iCount = M_MapUserCount(i);
          if iCount == nil or iCount <= 0 then
            MapID = i;
           break;
          end;
        end;
      end
      --判断是否有可用地图
      if MapID == 0 then 
         P_MenuSay(uSource, '公子忙...稍等片刻');
        return;
      end;
      --创建刷新地图
      if not M_GetNewMap(fuben.mapid, MapID, fuben.names) then 
        --刷新地图
        if not M_MapRegen(MapID) then 
          P_MenuSay(uSource, '稍等片刻...');
         return;
        end
      end;
	  --4,检测太极公子
	  if M_MapFindMonster(MapID, '太极公子', 0) <= 0 then 
         P_MenuSay(uSource, '公子忙...稍等片刻');
        return;
      end;		
      --5,删除令牌
	  P_deleteitem(uSource, '令牌', 1, '太极老人');
      --6,移动玩家到密室
      P_MapMove(uSource, MapID, 18, 18, 0);
	  --记录时间
	  fuben.times = tm + 3; 
    return;
  end;

  
  if aStr == "changeweapon" then
      --1,检测道具
      if P_getitemcount(uSource, '太极明珠') < 1 then 
         P_MenuSay(uSource, '弄来太极珠子?');
        return;
      end;
      --检测包裹
      if P_getitemspace(uSource) < 1 then
	     P_MenuSay(uSource, '物品栏已满....');
        return;
      end;
      --随机获取东西table
      local AwardItem = {};
      AwardItem = Randomitem[math.random(#Randomitem)];
      if AwardItem == nil then
       return;
      end;
      --删除物品
      P_deleteitem(uSource, '太极明珠', 1, '太极老人');
      --给予物品
      P_additem(uSource, AwardItem[1], AwardItem[2], '太极老人');
      --说话
	  P_MenuSay(uSource, '非常贵重....要妥善保管');
      --公告
	  M_topmsg(string.format('恭喜%s使用[太极明珠]兑换了[%s]', B_GetRealName(uSource), AwardItem[1]), 16043646);
    return;
  end;
  
  if aStr == "giveticket" then
      --1,检测道具
      if (P_getitemcount(uSource, '太极书札1') < 1) or (P_getitemcount(uSource, '太极书札2') < 1) or (P_getitemcount(uSource, '太极书札3') < 1) then 
         P_MenuSay(uSource, '小子._敢愚弄老夫?');
        return;
      end;
      --检测包裹
      if P_getitemspace(uSource) < 1 then
	     P_MenuSay(uSource, '物品栏已满....');
        return;
      end;
      --删除物品
      P_deleteitem(uSource, '太极书札1', 1, '太极老人');
      P_deleteitem(uSource, '太极书札2', 1, '太极老人');
      P_deleteitem(uSource, '太极书札3', 1, '太极老人');
      --给予物品
      P_additem(uSource, '太极牌', 1, '太极老人');
      --公告
	  M_topmsg(string.format('恭喜%s使用[太极书札]兑换了[太极牌]', B_GetRealName(uSource)), 16043646);
      --说话
      B_SayDelayAdd(uDest, '不胜感激...', 200);
      B_SayDelayAdd(uDest, '托你的福_我门的武功密笈', 200);
      B_SayDelayAdd(uDest, '竟安然无恙...', 200);
      B_SayDelayAdd(uDest, '如果太极公子来修炼的话,', 200);
      B_SayDelayAdd(uDest, '门主到来前', 200);
      B_SayDelayAdd(uDest, '败落的剑门', 200);
      B_SayDelayAdd(uDest, '一定能够重建!', 200);
      B_SayDelayAdd(uDest, '本门的象征', 200);
      B_SayDelayAdd(uDest, '给你一个.', 200);
      B_SayDelayAdd(uDest, '后会有期', 200);
      B_SayDelayAdd(uDest, '需要帮助时,', 200);
      B_SayDelayAdd(uDest, '本门弟子将助你一臂之力...', 200);
    return;
  end;


 return;
end