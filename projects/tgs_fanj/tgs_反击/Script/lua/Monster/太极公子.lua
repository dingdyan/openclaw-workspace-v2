package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

--死亡
function OnDie(uSource, uDest, race)
  --获取种族
  local Race = B_GetRace(uSource);
  if Race ~= 1 then
    return;
  end;
  --获取材料
  local astr = P_getitemcount(uSource, '太极书札1');
  local bstr = P_getitemcount(uSource, '太极书札2');
  local cstr = P_getitemcount(uSource, '太极书札3');
  --取公子地图坐标
  local MapId, AX, AY = B_GetPosition(uSource);
  --不满足
  if (astr <= 0) or (bstr <= 0) or (cstr <= 0) then
      --查找密室太极老人
      local lrobj = M_MapFindName(MapId, '密室太极老人', 4);
      --密室太极老人说话
	  if lrobj >= 0 then 
        B_SayDelayAdd(lrobj, '门主留下的', 100);
        B_SayDelayAdd(lrobj, '帮我们找回太极书札?', 200);
        B_SayDelayAdd(lrobj, '从<本馆>', 200);
        B_SayDelayAdd(lrobj, '拿到书函后', 200);
        B_SayDelayAdd(lrobj, '毫无音信~', 200);
        B_SayDelayAdd(lrobj, '[青龙帮]_[本门]', 200);
        B_SayDelayAdd(lrobj, '担心会受到制止,', 200);
        B_SayDelayAdd(lrobj, '太极公子必须修炼的', 200);
        B_SayDelayAdd(lrobj, '武功密笈', 200);
        B_SayDelayAdd(lrobj, '密笈.', 200);
        B_SayDelayAdd(lrobj, '门主', 200);
        B_SayDelayAdd(lrobj, '怎么也不会被浪人', 200);
        B_SayDelayAdd(lrobj, '打败...', 200);
        B_SayDelayAdd(lrobj, '总之找到_[太极书札]', 200);
        B_SayDelayAdd(lrobj, '找到之后,', 200);
        B_SayDelayAdd(lrobj, '拿给我好吗?', 200);
        B_SayDelayAdd(lrobj, '必有重谢.', 200);		
	  end		
   end;
   --满足
   if (astr >= 0) and (bstr >= 0) and (cstr >= 0) then
      --检测空位
      if P_getitemspace(uSource) < 1 then
         B_SayDelayAdd(uDest, '物品栏已满', 0);		
        return;
      end;
      --删除材料
      P_deleteitem(uSource, '太极书札1', 1, '太极公子')
      P_deleteitem(uSource, '太极书札2', 1, '太极公子')
      P_deleteitem(uSource, '太极书札3', 1, '太极公子')
      --给予材料
      P_additem(uSource, '太极牌', 1, '太极公子');
      --查找密室太极老人
      local lrobj = M_MapFindName(MapId, '密室太极老人', 4);
      --密室太极老人说话
	  if lrobj >= 0 then 
        B_SayDelayAdd(lrobj, '门主留下的', 100);
        B_SayDelayAdd(lrobj, '万分感谢...', 100);
        B_SayDelayAdd(lrobj, '托你的福，我门的武功密笈', 200);
        B_SayDelayAdd(lrobj, '终于物归原主了...', 200);
        B_SayDelayAdd(lrobj, '只要公子掌握了此项武功,', 200);
        B_SayDelayAdd(lrobj, '门主他老人家来之前', 200);
        B_SayDelayAdd(lrobj, '将已经败落的我门', 200);
        B_SayDelayAdd(lrobj, '重振!', 200);
        B_SayDelayAdd(lrobj, '本门的象征', 200);
        B_SayDelayAdd(lrobj, '给你一个.', 200);
        B_SayDelayAdd(lrobj, '后会有期', 200);
        B_SayDelayAdd(lrobj, '需要援助时,', 200);
        B_SayDelayAdd(lrobj, '有本门弟子助你一臂之力...', 200);
	  end		
   end;
   --30秒后传送玩家
   P_MapMove(uSource, 1, 535, 465, 3000);
  return;
end;

--周边玩家改变状态
function OnChangeState(uSource, uDest, aStr)
   if aStr ~= 'die' then
      return;
   end;
   --获取种族
   local Race = B_GetRace(uSource);
   if Race ~= 1 then
     return;
   end;
   --说话
   B_SayDelayAdd(uDest, '武功这么弱。。。自不量力的小子', 0);
   --传送玩家
   P_MapMove(uSource, 1, 535, 465, 1000)
  return;
end;