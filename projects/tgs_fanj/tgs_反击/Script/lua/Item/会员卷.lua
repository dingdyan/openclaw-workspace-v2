package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

local ItemTab = {
  ['1级VIP'] = {
    ['Name'] = '1级VIP',
    ['Level'] = 1,
    ['Time'] = 946080000,
    ['GG'] = 57472,
    ['YB'] = 0,
  },
  ['黄金VIP'] = {
    ['Name'] = '黄金VIP',
    ['Level'] = 2,
    ['Time'] = 946080000,
    ['GG'] = 57472,
    ['YB'] = 0,
  },
  ['御史会员'] = {
    ['Name'] = '御史会员',
    ['Level'] = 3,
    ['Time'] = 946080000,
    ['GG'] = 7446527,
    ['YB'] = 0,
  },
};

local YB = {
  [1] = 0,
  [2] = 0,
  [3] = 0,
}

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
     return;
   end
   --获取道具table
   local t = ItemTab[ItemData.Name];
   if t == nil then
    return;
   end;	
  --获取当前VIP信息
  local viplevel, viptime = P_GetVipInfo(uSource);
  --判断VIP等级
  if viplevel >= t['Level'] then 
     P_saysystem(uSource, '无需使用当前等级或者低级VIP卷轴', 2);
    return;
  end;
  --获取当前时间戳
  local times = os.time() + t['Time'];
  --写入VIP信息
  P_SetVipInfo(uSource, t['Level'], time_format(times));
  --删除道具
  P_deleteitem(uSource, ItemData.Name, 1, ItemData.Name);
  --提示信息
  P_saysystem(uSource, string.format('使用成功,恭喜你成为了[%s]', t['Name']), 16);
  --判断是否需要反元宝
  if t['Level'] > viplevel and viplevel ~= 0 then 
   --增加元宝
   P_AddMysqlDianJuan(uSource, YB[viplevel]);	
   P_saysystem(uSource, string.format('由于VIP等级提升,系统已反还您[%d]元宝', YB[viplevel]), 16);
  end;
  --提示信息
  M_topmsg(string.format('%s 恭喜你,成为了[%s]', B_GetRealName(uSource), t['Name']), t['GG']);
  --[[新手扶持
  if ItemData.Name == '黄金VIP' then
	  --P_additem(uSource, '2小时双倍卷轴', 60, ItemData.Name);
	  local aTime = P_GetTempArr(uSource, 9) + 60 * 60 * 24 * 2;
	  P_SetTempArr(uSource, 9, aTime);
	  P_saysystem(uSource, '恭喜您获得了黄金VIP奖励道具[2天修炼场时间]', 16);
    end;
  --新手扶持
  if ItemData.Name == '钻石VIP' then
	  --P_additem(uSource, '2小时双倍卷轴', 60, ItemData.Name);
	  local aTime = P_GetTempArr(uSource, 9) + 60 * 60 * 24 * 6;
	  P_SetTempArr(uSource, 9, aTime);
	  P_saysystem(uSource, '恭喜您获得了钻石VIP奖励道具[6天修炼场时间]', 16);
    end;]]
 return;
end