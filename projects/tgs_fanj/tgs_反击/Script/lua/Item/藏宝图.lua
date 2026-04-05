package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

local _bt = {
  --数据保存路径
  File = "Tgsplus\\藏宝图.sdb",
  --数据
  data = {},
};

--读取数据库
_bt.Load = function()
  if file_exists(_bt.File) then
    _bt.data = table.load(_bt.File)
  end
end

--保存数据库
_bt.Save = function()
  table.save(_bt.data, _bt.File)
end

_bt.Load();

--道具,添加天数
local XyTab = {
  {499, 499},
  {333, 328},
};

local ItemTab = {
  {'钱币', 100, 1000},
  {'金元', 100, 1000},
};
  
function OnItemDblClick(uSource, uItemKey, astr)
  if not P_BoFreedom(uSource) then 
    P_saysystem(uSource, '请先关闭其他窗口', 2);
    return;
  end
   --获取KEY道具
   local ItemData = P_GetHaveItemInfoTabs(uSource, uItemKey);
   if ItemData == nil or ItemData.Name == nil or ItemData.Name ~= '藏宝图' then
     return;
   end;
   --检测道具数量
   if P_getitemcount(uSource, ItemData.Name) < 1 then 
	 P_saysystem(uSource, '你没有这个道具', 18);
     return;
   end
   --获取玩家地图ID和坐标
   local MapId, X, Y =  B_GetPosition(uSource);
   --不是长城以南
   if MapId ~= 1 then 	
	 P_saysystem(uSource, '不是长城以南', 18);
     return;
   end;
   --获取宝图的XY
   local XY = _bt.data[ItemData.Id];
   if XY == nil then 
	 math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	 math.random();
     XY = XyTab[math.random(#XyTab)];
	 _bt.data[ItemData.Id] = XY;
	 _bt.Save();
   end;
   if math.abs(X - XY[1]) > 1 or math.abs(Y - XY[2]) > 1 then 
     P_saysystem(uSource, string.format('[%d,%d]开启藏宝图', XY[1], XY[2]), 18);	
     return;
   end;
   --删除道具
   P_DelHaveItemInfo(uSource, uItemKey, 1);
   --随机道具
   math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
   math.random();
   local N = math.random(10);
   if N ~= 1 then 
     local t = ItemTab[math.random(#ItemTab)];
	 local Num = math.random(t[2], t[3]);
	 P_additem(uSource, t[1], Num, '藏宝图');
     --提示信息
     P_saysystem(uSource, string.format('开启藏宝图,获得了[%d个%s]', Num, t[1]), 18);
	 M_topmsg(string.format('%s开启藏宝图,获得了[%d个%s]', B_GetRealName(uSource), Num, t[1]), 33023);
   else
	 M_MapAddMonster(1, '宝图忍王', 525, 474, 1, 25, '', 0, 0, true, 0);
	 M_MapAddMonster(1, '宝图死狼女', 525, 474, 1, 25, '', 0, 0, true, 0);
	 M_MapAddMonster(1, '宝图九尾狐', 525, 474, 1, 25, '', 0, 0, true, 0);
	 M_MapAddMonster(1, '宝图火王', 525, 474, 1, 25, '', 0, 0, true, 0);
	 M_MapAddMonster(1, '宝图太极公子', 525, 474, 1, 25, '', 0, 0, true, 0);
	 M_MapAddMonster(1, '宝图西域魔人', 525, 474, 1, 25, '', 0, 0, true, 0);
	 M_MapAddMonster(1, '宝图东天王', 525, 474, 1, 25, '', 0, 0, true, 0);
	 M_MapAddMonster(1, '宝图北霸王', 525, 474, 1, 25, '', 0, 0, true, 0);
	 M_MapAddMonster(1, '宝图雨中客', 525, 474, 1, 25, '', 0, 0, true, 0);
     --提示信息
     P_saysystem(uSource, '开启藏宝图,在中央市场释放了小妖', 18);
	 M_topmsg(string.format('%s挖宝时不幸挖塌的妖怪的房子,一群无家可归的妖怪正在中央市场寻衅闹事,各路英雄快前往平乱啊！', B_GetRealName(uSource)), 33023);
   end;
 return;
end