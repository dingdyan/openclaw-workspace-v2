package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

--道具,添加天数
local ItemTab = {
  ['30天VIP卷轴'] = 30,
  ['30天VIP卷轴1'] = 30,
};

function OnItemDblClick(uSource, uItemKey, astr)
  if not P_BoFreedom(uSource) then 
    P_saysystem(uSource, '请先关闭其他窗口', 2);
    return;
  end
   --获取KEY道具
   local ItemData = P_GetHaveItemInfoTabs(uSource, uItemKey);
   if ItemData == nil or ItemData.Name == nil or ItemTab[ItemData.Name] == nil then
     return;
   end;
   --检测道具数量
   if P_getitemcount(uSource, ItemData.Name) < 1 then 
	 P_saysystem(uSource, '你没有这个道具', 2);
     return;
   end
  --获取当前VIP信息
  local viplevel, viptime = P_GetVipInfo(uSource);
  --判断VIP等级
  if viplevel <= 0 then 
    viplevel = 1;
  end;
  --VIP时间转为时间戳
  local settime = strtostamp(viptime);
  --获取当前时间戳
  local times = os.time();
  --判断VIP是否过期
  if settime < times then 
    settime = times;	
  end;	
  --增加30天VIP时间
  settime = settime + ItemTab[ItemData.Name] * 24 * 60 *60;
  --写入VIP信息
  P_SetVipInfo(uSource, viplevel, time_format(settime));
  --删除道具
  P_deleteitem(uSource, ItemData.Name, 1, 'VIP卷轴');
  --提示信息
  P_saysystem(uSource, string.format('成功增加%d天VIP!口令[@VIP情报]可查询剩余时间!', ItemTab[ItemData.Name]), 2);
 return;
end