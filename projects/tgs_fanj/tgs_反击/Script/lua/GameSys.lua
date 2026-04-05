package.loaded['Script\\lua\\f'] = nil;
package.loaded['Script\\lua\\plug\\怪物增强'] = nil;
package.loaded['Script\\lua\\plug\\新人配置'] = nil;
package.loaded['Script\\lua\\plug\\门派系统'] = nil;
package.loaded['Script\\lua\\plug\\爆出公告'] = nil;
package.loaded['Script\\lua\\plug\\VIP属性'] = nil;
package.loaded['Script\\lua\\plug\\反外挂'] = nil;
package.loaded['Script\\lua\\任务\\新手任务'] = nil;
package.loaded['Script\\lua\\任务\\主线任务'] = nil;
package.loaded['Script\\lua\\plug\\武功附加'] = nil;

require ('Script\\lua\\f');
require ('Script\\lua\\plug\\怪物增强');
require ('Script\\lua\\plug\\新人配置');
require ('Script\\lua\\plug\\门派系统');
require ('Script\\lua\\plug\\爆出公告');
require ('Script\\lua\\plug\\VIP属性');
require ('Script\\lua\\plug\\反外挂');
require ('Script\\lua\\任务\\主线任务');
require ('Script\\lua\\任务\\新手任务');
require ('Script\\lua\\plug\\武功附加');

local GuildTeamTime = 0; --门派团队 使用口令时间

-- TempArr ID记录
-- 19 = 新人上线
-- 18 = 充值记录
-- 17 = 囚禁记录
-- 16 = 真气记录
-- 15
-- 13-14 = VIP挂机时间
-- 11-12 = 护送任务
-- 9-10 = 修炼场时间记录
-- 8 = VIP福利时间记录
-- 6-7 = 单人副本 记录
-- 4-5 = 挑战精英 记录
-- 2 日常任务记录、新手杀怪记录
-- 1 新手任务ID记录

--角色上线
function OnCharOnline(uSource)
  --[[获取玩家地图ID和坐标
  local MapId, X, Y =  B_GetPosition(uSource);
  --新人出生配置
  BornItem.Start(uSource);
  --获取基属性
  local PlayAttrib = P_GetAttrib(uSource);
  --新手村出去
  if MapId == 131 and PlayAttrib.Age >2500 then
  --传送
    P_saysystem(uSource, '你已超过25岁,已被强制出新手村', 2);
    P_MapMove(uSource, 1, 500, 500, 0);
  end]]
  --新人出生配置
  BornItem.Start(uSource);
  --门派属性触发
  GuildSys.PlayGuild(uSource);
  --任务触发
  ZxQuest.Deltemp(uSource);
  OnQuest(uSource, 0);
  --武功附加
  MagicAddAttrib.Set(uSource);
  --VIP属性触发
  VipAttrib.open(uSource);
  --装备更换触发
  OnChangeWearItem(uSource);
  --反外挂初始化
  AntiPlug.OnCharOnline(uSource);
  --远程挂机
  P_saysystem(uSource, '&0黑牛,犀牛,稻草人,北方魔人,蝎子女王,金毛狮王', 0);
  --自动打怪
  P_saysystem(uSource, '&2全部怪物,牛,马,狗,猪,鹿,熊,老虎,狂犬,犀牛,黑牛,犀牛王,犀牛王后,黑忍者,忍者,赤风,白老虎,土巨人,石巨人,北方魔人,流氓,僵尸,山贼,吸血木,吸血巨木,投石女,豺狼,蝎子,青眼鼠', 0);
  --升段
  P_saysystem(uSource, '&11段:溶华素,2段:逐龙丹,3段:太极液,4段:桂圆丹,保护:防爆丹', 0);
  --sdk充值
  P_saysystem(uSource, '&sdk;1110;recharge0:1:1元=10点券;recharge1:10:10元=100点券;recharge2:20:20元=200点券;recharge3:50:50元=500点券;recharge4:100:100元=1000点券;recharge5:200:200元=2000点券;recharge6:500:500元=5000点券;recharge7:1000:1000元=10000点券;recharge8:2000:2000元=20000点券;', 0);
  --3分钟检测下VIP
  P_SetEventTick(uSource, 99, 100 * 60 * 3);
end;

--离线登录的触发
function OnCharOffline(uSource)
--SDK充值
    P_saysystem(uSource, '&sdk;1110;recharge0:1:1元=10点券;recharge1:10:10元=100点券;recharge2:20:20元=200点券;recharge3:50:50元=500点券;recharge4:100:100元=1000点券;recharge5:200:200元=2000点券;recharge6:500:500元=5000点券;recharge7:1000:1000元=10000点券;recharge8:2000:2000元=20000点券;', 0);
 end;

--角色下线时提示
function OnCharExitGame(uSource)
	--M_worldnoticemsg(string.format('玩家[%s]退出了。', P_getname(uSource)), 65535, 3);
end;

function OnUserSayEx(uSource, ...)
  local arg = {...};
  --传音
  if arg[16] > 0 and arg[1] == '@百里传音' then
    OnCySys(uSource, 1, arg);
   return 'true';	
  elseif arg[16] > 0 and arg[1] == '@千里传音' then
    OnCySys(uSource, 2, arg);
   return 'true';
  elseif arg[16] > 0 and arg[1] == '@万里传音' then
    OnCySys(uSource, 3, arg);
   return 'true';
  end;
end;

local AutoTime = {
  [1] = 3600 * 6,
  [2] = 3600 * 6,
  [3] = 3600 * 6,
  [4] = 3600 * 6,
};

--角色说话提示
function OnUserSay(uSource, ...)
  local arg = {...};
  --[[开始挂机
  if arg[1] == '@开始挂机' then
	--获取VIP信息
	local viplevel, viptime = P_GetVipInfo(uSource);
	if AutoTime[viplevel] == nil then 
      P_saysystem(uSource, 'VIP才可开启自动挂机功能', 14);
     return 'true';
    end;
	--获取领取时间戳
	local aNow = P_GetTempArr(uSource, 13);
	local aTime = P_GetTempArr(uSource, 14);
	--判断日期	
    if os.date("%Y-%m-%d", aNow) ~= os.date("%Y-%m-%d", os.time()) then 
      aTime = AutoTime[viplevel];
	  P_SetTempArr(uSource, 13, os.time());	
	  P_SetTempArr(uSource, 14, aTime);
    end;
	if aTime <= 60 then 
      P_saysystem(uSource, '今日自动挂机剩余时间已用完', 14);
     return 'true';
	end
    P_SetAutoHit(uSource, true);
	P_saysystem(uSource, '已开启-自动挂机功能-辅助界面勾选:自动步法', 14);
   return 'true';
  end;

  if arg[1] == '@停止挂机' then
    P_SetAutoHit(uSource, false);
	P_saysystem(uSource, '已关闭-自动挂机功能', 14);
   return 'true';
  end;]]
  
  --离线挂机
  if arg[1] == '@lxks2022' then
    --检测窗口
    if not P_BoFreedom(uSource) then 
	  P_saysystem(uSource, '请先关闭其他窗口', 25);
      return 'true';
    end
	--[[检测是否是VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then 
      P_saysystem(uSource, '您还不是VIP或者VIP已过期!', 25);
     return 'true';	
    end;]]
    --获取玩家地图ID和坐标
    local MapId, X, Y =  B_GetPosition(uSource);
	if MapId == 0 or MapId == 131 then 
       P_saysystem(uSource, '新手村禁止离线挂机!', 25);	
      return 'true';
	-- elseif (MapId == 1) and (M_GetLargeLength(X, Y, 525, 474) < 35) then 
       -- P_saysystem(uSource, '中央市场范围内禁止离线挂机!', 25);	
     -- return 'true';
    end;
	if arg[2] == '' then 
      return 'true';
    end;
	local Type, uStr = lua_GetToken(arg[2], ':');
	if Type == '0' then
      P_SetBoOffline(uSource, true, 360000*24, 0, uStr);
	elseif Type == '1' then
	  -- --VIP才可离线打怪
	  -- local viplevel, viptime = P_GetVipInfo(uSource);
	  -- if viplevel < 2 then 
        -- P_saysystem(uSource, '[钻石VIP]才可以使用此功能', 25);
       -- return 'true';
      -- end;
      P_SetBoOffline(uSource, true, 360000*24, 1, uStr);
	end;
   return 'true';
  end;
  
  --自动杀怪
   if arg[1] == '@开始挂机' then
 --[[获取VIP信息
 local viplevel, viptime = P_GetVipInfo(uSource);
 if viplevel < 5 then 
      P_saysystem(uSource, '低于[5级VIP]无法激活生效自动杀怪功能', 2);
      return 'true';
     end;
    P_SetAutoHit(uSource, true);
   P_saysystem(uSource, '成功激活生效自动打怪功能【长城以南】才可使用', 2);]]
   --判断身上装备
	local ItemData = P_GetWearItemInfoTabs(uSource, 13);
	   if ItemData.Name ~= '武侠令(30天)' and ItemData.Name ~= '武侠令(3天)' then 
	   P_saysystem(uSource, '您没有[武侠令]或者没有佩戴', 25);
      return 'true';
     end;
	 P_SetAutoHit(uSource, true);
     P_saysystem(uSource, '成功激活生效自动打怪功能【长城以南】才可使用', 25);
   return 'true';
  end;

  if arg[1] == '@停止挂机' then
 if P_GetAutoHit(uSource) then 
      P_saysystem(uSource, '停止挂机', 25);
      P_SetAutoHit(uSource, false);
 end;
   return 'true';
  end;
  
  --声望显示
  if arg[1] == '@test' then
    P_SetDiyExp(uSource, 100);
    P_saysystem(uSource, '===' .. P_GetDiyExp(uSource), 14);
   return 'true';
  end;

  --传音
  if arg[1] == '@百里传音' then
    OnCySys(uSource, 1, arg);
   return 'true';
  end;
  if arg[1] == '@千里传音' then
    OnCySys(uSource, 2, arg);
   return 'true';
  end;
  if arg[1] == '@万里传音' then
    OnCySys(uSource, 3, arg);
   return 'true';
  end;
  
  --探查
  if arg[1] == '@探查' then
    --检测格式
	if arg[2] == '' then 
       P_saysystem(uSource, '口令格式错误,正确格式[@探查 xxx]', 25);
      return 'true';
    end;
    --检测玩家是否在线
	local uObject, BoFind = M_GetUserIsPointer(arg[2]);
    if not BoFind then 
       P_saysystem(uSource, string.format('玩家[%s]不在线', arg[2]), 25);	
      return 'true';
    end;	
    --检测道具
    if P_getitemcount(uSource, '钱币') < 1000 then 
	  P_saysystem(uSource, '无法探查，每次探查需要钱币:1000', 25);
      return 'true';
    end
	--获取玩家地图ID和坐标
    local MapId, X, Y =  B_GetPosition(uSource);
    --循环改变周边玩家团队
    for oName, oSource in pairs(B_GetPosition(uSource)) do
	  if uSource ~= oSource then 
        local _MapId, _X, _Y =  B_GetPosition(oSource);
	  end;
	 end;
	--删除
    P_deleteitem(uSource, '钱币', 1000, '探查');	
   return 'true';
  end
  
  --改变名字
  if arg[1] == '@改名' then
    --检测格式
	if arg[2] == '' then 
       P_saysystem(uSource, '口令格式错误,正确格式[@改名 xxx]', 2);
      return 'true';
    end;			
    --检测窗口
    if not P_BoFreedom(uSource) then 
	  P_saysystem(uSource, '请先关闭其他窗口', 2);
      return 'true';
    end
	--检查物品栏密码状态	
    if P_GetItemPassBo(uSource) then 
	  P_saysystem(uSource, '请先取消物品栏密码', 2);
      return 'true';
    end
    --检测道具
    if P_getitemcount(uSource, '改名卡') < 1 then 
	  P_saysystem(uSource, '没有改名卡', 2);
      return 'true';
    end
	--检测角色名
    local str = P_CheckCharName(arg[2]);
	if str ~= '' then
      P_saysystem(uSource, str, 2);
      return 'true';
	end;	
	--发送改名请求
	if P_ChangeCharName(uSource, arg[2]) then
      P_saysystem(uSource, '成功发送改名请求!', 2);
      return 'true';
	end
    P_saysystem(uSource, '改名请求发送失败,可能角色名已存在!', 2);
   return 'true';
  end;

  --牵手
  if arg[1] == '@牵手' then
	local ConsortName = P_GetConsortName(uSource);	
	if ConsortName == '' then
	  P_saysystem(uSource, '您尚未结婚', 25);
      return 'true';
    end
	--这里可自己家道具 或者 其他限制判断
	 if B_GetCurLife(uSource) < B_GetMaxLife(uSource) * 0.8 then 
    	P_saysystem(uSource, '活力不足百分之八十无法使用', 25);
     return 'true';
   end;
    --检测玩家是否在线
	local uObject, BoFind = M_GetUserIsPointer(ConsortName);
    if not BoFind then 
       P_saysystem(uSource, string.format('[%s]不在线', ConsortName), 25);	
      return 'true';
    end;
	--获取目标坐标
    local MapId, X, Y =  B_GetPosition(uObject);
	if MapId ~= 1 then 
       P_saysystem(uSource, string.format('[%s]不在长城以南', ConsortName), 25);	
      return 'true';
    end
	--传送自己过去
    P_MapMove(uSource, MapId, X, Y, 0);		
   return 'true';
  end;

  
  --[[反击玩家VIP才可以用
  if arg[1] == '@反击玩家开启' then
    --获取VIP信息
    local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then 
      P_saysystem(uSource, 'VIP才可以使用反击玩家功能!', 2);
      return 'true';
    end;
    return 'false';
  end;]]

  --反击怪物限制地图
--[[  if arg[1] == '@反击开启' then
    --获取玩家地图ID和坐标
    local MapId, X, Y =  B_GetPosition(uSource);
	--不是长城以南
    if MapId ~= 1 then 	
      --获取VIP信息
      local viplevel, viptime = P_GetVipInfo(uSource);
      if strtostamp(viptime) < os.time() then 
        P_saysystem(uSource, '【长城以南】以外的地图VIP才可以使用反击功能!', 2);
        return 'true';
      end;
    end;
    return 'false';
  end;--]]
  
  --[[屏蔽门派武功
  if arg[1] == '@申请门派武功' then
	P_saysystem(uSource, '门派武功本区未开放！', 2);
   return 'true';
  end;]]
  
  --屏蔽修改门派武功
  if arg[1] == '@修改门派武功' then
		P_saysystem(uSource, '修改门派武功本区未开放！', 2);
   return 'true';
  end;

  --开启VIP属性
  if arg[1] == '@开启炼体属性' then
    VipAttrib.open(uSource);
   return 'true';
  end;
  --开启VIP属性
  if arg[1] == '@关闭炼体属性' then
    VipAttrib.down(uSource);
   return 'true';
  end;

  --开启门派属性
  if arg[1] == '@开启门派属性' then
    GuildSys.PlayGuild(uSource);
   return 'true';
  end;

  --关闭门派属性
  if arg[1] == '@关闭门派属性' then
    GuildSys.QuitPlay(uSource);
   return 'true';
  end;

   --门派团队设置
  if arg[1] == '@门派团队' then
    --获取玩家地图ID和坐标
    local MapId, X, Y =  B_GetPosition(uSource);
    --检测地图是否统一团队	
    if M_GetboSetGroupKey(MapId) then 
		P_saysystem(uSource, '统一团队地图无法自己设定团队', 2);
     return 'true';
    end;	
    --检测门派
    local GuildName= P_GuildGetName(uSource);
    if GuildName == '' then 
		P_saysystem(uSource, '你还没有加入门派！', 2);
     return 'true';
    end;	
    --没有带参数
	local GroupKey = tonumber(arg[2]);
	if GroupKey == nil then 
		--获取门派当前团队
		local GuildTeam = M_GetGuildTeam(GuildName);
		if GuildTeam <= 0 then 
		  P_saysystem(uSource, '门派没有设定门派团队！', 2);
		 return 'true';
		end;	
		--改变团队
		B_SetGroupKey(uSource, GuildTeam);
		P_saysystem(uSource, '门派团队设定成功！', 2);
		--[[GuildTeamTime = os.time(); --记录时间--]]
	else
	    --检测玩家门派权限
		local PlayName = B_GetRealName(uSource);
		local GuildSys = M_IsGuildSysOp(GuildName, PlayName);
	    if GuildSys ~= 1 and GuildSys ~= 2 then 
           P_saysystem(uSource, '门主或者副门才有权限设定门派团队！', 2);
		 return 'true';
        end		
	    if GroupKey < 10000 or GroupKey > 10999 then 
		  P_saysystem(uSource, '门派团队数值范围10000-10999！', 2);
		 return 'true';
		end;	
		--[[检测当前团队是否有门派在用
		if M_CheckGuildTeam(GroupKey) then 
		  P_saysystem(uSource, GroupKey..'团队已有其他门派正在使用！', 2);
		 return 'true';
		end;]]
	    --改变门派团队
		M_SetGuildTeam(GuildName, GroupKey);
	    --改变自己团队
		B_SetGroupKey(uSource, GroupKey);
	    --获取周边玩家
		local ObjectList = B_FindViewUserObjectList(uSource, 1);
	    --循环改变周边玩家团队
	    for oName, oSource in pairs(ObjectList) do
			if P_GuildGetName(oSource) == GuildName then 
				B_SetGroupKey(oSource, GroupKey);
			end
	    end;
	    --提示
		P_saysystem(uSource, '门派团队设定成功！', 2);
		--[[GuildTeamTime = os.time(); --记录时间--]]
	end
   return 'true';
  end;

  --VIP信息查询
  if arg[1] == '@VIP情报' then
     --获取VIP信息
	 local viplevel, viptime = P_GetVipInfo(uSource);
     if strtostamp(viptime) < os.time() then 
       P_saysystem(uSource, '您还不是VIP或者VIP已过期!', 2);
      return 'true';
     end;
	 P_saysystem(uSource, string.format('您的VIP到期时间是[%s]', viptime), 2);	
   return 'true';
  end;

  --增加玩家道具
  if arg[1] == '@草' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;
	if arg[2] == '' or arg[3] == '' or tonumber(arg[4]) == nil then 
       P_saysystem(uSource, '格式错误,[@操 玩家名称 道具名称 数量]', 2);
      return 'true';
    end;	
    --检测玩家是否在线
	local uObject, BoFind = M_GetUserIsPointer(arg[2]);
    if not BoFind then 
       P_saysystem(uSource, string.format('玩家[%s]不在线', arg[2]), 2);	
      return 'true';
    end;	
    --增加道具
    if P_additem(uObject, arg[3], tonumber(arg[4]), 'GM操作') then 
      P_saysystem(uSource, string.format('增加玩家[%s]%s个%s成功', arg[2], arg[4], arg[3]), 2);
    else
      P_saysystem(uSource, string.format('增加玩家[%s]%s个%s失败', arg[2], arg[4], arg[3]), 2);
    end;
   return 'true';
  end;

  --删除玩家道具
  if arg[1] == '@靠' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;
	if arg[2] == '' or arg[3] == '' or tonumber(arg[4]) == nil then 
       P_saysystem(uSource, '格式错误,[@日 玩家名称 道具名称 数量]', 2);
      return 'true';
    end;	
    --检测玩家是否在线
	local uObject, BoFind = M_GetUserIsPointer(arg[2]);
    if not BoFind then 
       P_saysystem(uSource, string.format('玩家[%s]不在线', arg[2]), 2);	
      return 'true';
    end;	
    --增加道具
    if P_deleteitem(uObject, arg[3], tonumber(arg[4]), 'GM操作') then 
      P_saysystem(uSource, string.format('删除玩家[%s]%s个%s成功', arg[2], arg[4], arg[3]), 2);
    else
      P_saysystem(uSource, string.format('删除玩家[%s]%s个%s失败', arg[2], arg[4], arg[3]), 2);
    end;
   return 'true';
  end;
  
  --添加怪物
  if arg[1] == '@添加怪物_m' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;
	if arg[2] == '' or tonumber(arg[3]) == nil or tonumber(arg[4]) == nil or tonumber(arg[5]) == nil or tonumber(arg[6]) == nil or tonumber(arg[7]) == nil then 
       P_saysystem(uSource, '格式错误,[@添加怪物_m xxx 0 165 220 10 1]', 2);
      return 'true';
    end;
    --添加怪物
	if tonumber(arg[7]) == 1 then 
	  M_MapAddMonster(arg[3], arg[2], arg[4], arg[5], arg[6], 8, '', 0, 0, true, 0);
	else
	  M_MapAddMonster(arg[3], arg[2], arg[4], arg[5], arg[6], 8, '', 0, 0, false, 0);
	end
	P_saysystem(uSource, '添加怪物', 2);
   return 'true';
  end;

  --删除怪物
  if arg[1] == '@删除怪物_m' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;
	if arg[2] == '' or tonumber(arg[3]) == nil then 
       P_saysystem(uSource, '格式错误,[删除怪物_m xxx 0]', 2);
      return 'true';
    end;
    --添加怪物
	M_MapDelMonster(arg[3], arg[2]);
	P_saysystem(uSource, '删除怪物', 2);
   return 'true';
  end;

  --检测进程
  if arg[1] == '@检测进程_m' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;
	if arg[2] == '' then 
       P_saysystem(uSource, '格式错误,[@检测进程_m 玩家名称]', 2);
      return 'true';
    end;	
    --检测玩家是否在线
	local uObject, BoFind = M_GetUserIsPointer(arg[2]);
    if not BoFind then 
       P_saysystem(uSource, string.format('玩家[%s]不在线', arg[2]), 2);	
      return 'true';
    end;	
    --增加真气
    P_SendProcBlackList(uObject);
    P_saysystem(uSource, string.format('检测玩家[%s]进程成功', arg[2]), 2);
   return 'true';
  end;
  
  if arg[1] == '@滚蛋' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;
	if arg[2] == '' then 
       P_saysystem(uSource, '格式错误,[@滚蛋 xxx]', 2);
      return 'true';
    end;
    --检测玩家是否在线
	local uObject, BoFind = M_GetUserIsPointer(arg[2]);
    if not BoFind then 
       P_saysystem(uSource, string.format('玩家[%s]不在线', arg[2]), 2);	
      return 'true';
    end;
	P_MapMove(uObject, 113,38,40);
	P_saysystem(uSource, '处理完毕', 2);
   return 'true';
  end;
  
  --增加年龄
  if arg[1] == '@年龄' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;
	if arg[2] == '' or tonumber(arg[3]) == nil then 
       P_saysystem(uSource, '格式错误,[@增加年龄 玩家名称 经验]', 2);
      return 'true';
    end;	
    --检测玩家是否在线
	local uObject, BoFind = M_GetUserIsPointer(arg[2]);
    if not BoFind then 
       P_saysystem(uSource, string.format('玩家[%s]不在线', arg[2]), 2);	
      return 'true';
    end;	
    --增加道具
    P_UpAgeExp(uObject, tonumber(arg[3]))
    P_saysystem(uSource, string.format('增加玩家[%s]年龄[%s]成功', arg[2], arg[3]), 2);
   return 'true';
  end;
  
   if arg[1] == '@武功' then
    if P_GetSysopScope(uSource) < 100 then
       return 'true'; 
    end;
    if arg[2] == '' or arg[3] == '' or tonumber(arg[4]) == nil then 
       P_saysystem(uSource, '格式错误,[ @修改武功 玩家名称 武功名称 级别 ]', 2);
      return 'true';
    end;
	
    local uObject, BoFind = M_GetUserIsPointer(arg[2]);
    if not BoFind then 
       P_saysystem(uSource, '玩家'..arg[2]..'不在线或者玩家名字未输入正确', 2);	
      return 'true';
    end;
       P_SetMagicLevel(uObject, arg[3], tonumber(arg[4]), 'GM操作')
       P_saysystem(uSource, '命令执行完成.请联系玩家确认是否修改成功', 2);
   return 'true';
  end;
  
  --开启门战
  if arg[1] == '@开启门战' then
     --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;
      M_ScriptOpenGuildWar(true);
      M_topmsg('【系统公告】门派战争已开启', 16776960);
   return 'true';
  end;

  --关闭门战
  if arg[1] == '@关闭门战' then
     --不是GM退出
     if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;
      M_ScriptOpenGuildWar(false);
      M_topmsg('【系统公告】门派战争已关闭', 16776960);
   return 'true';
  end;
  
  --添加怪物
  if arg[1] == '@添加NPC' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;
	if arg[2] == '' or tonumber(arg[3]) == nil or tonumber(arg[4]) == nil or tonumber(arg[5]) == nil then 
       P_saysystem(uSource, '格式错误,[@添加NPC xxx 0 165 220]', 2);
      return 'true';
    end;
	M_MapAddNPC(arg[3], arg[2], arg[4], arg[5], 1, 4, '', 1, 0, 0);
	P_saysystem(uSource, 'NPC添加成功', 2);
   return 'true';
  end;
  
  --修改浩然_m
  if arg[1] == '@修改浩然_m' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;	
	if arg[2] == '' or tonumber(arg[3]) == nil then 
       P_saysystem(uSource, '格式错误,[@修改浩然_m 玩家名称 数值]', 2);
      return 'true';
    end;	
    --检测玩家是否在线
	local uObject, BoFind = M_GetUserIsPointer(arg[2]);
    if not BoFind then 
       P_saysystem(uSource, string.format('玩家[%s]不在线', arg[2]), 2);	
      return 'true';
    end;	
	P_UpVirtueExp(uObject, tonumber(arg[3]));
    P_saysystem(uSource, string.format('增加[%s]浩然经验[%d]', arg[2], arg[3]), 2);	
   return 'true';
  end;
  
  --修改耐性_m
  if arg[1] == '@修改耐性_m' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;	
	if arg[2] == '' or tonumber(arg[3]) == nil then 
       P_saysystem(uSource, '格式错误,[@修改耐性_m 玩家名称 数值]', 2);
      return 'true';
    end;	
    --检测玩家是否在线
	local uObject, BoFind = M_GetUserIsPointer(arg[2]);
    if not BoFind then 
       P_saysystem(uSource, string.format('玩家[%s]不在线', arg[2]), 2);	
      return 'true';
    end;	
	P_UpAdaptiveExp(uObject, tonumber(arg[3]));
    P_saysystem(uSource, string.format('增加[%s]耐性经验[%d]', arg[2], arg[3]), 2);	
   return 'true';
  end;
  
  --禁止发言_m
  if arg[1] == '@外挂' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;	
	if arg[2] == '' then 
       P_saysystem(uSource, '格式错误,[@外挂 玩家名称]', 2);
      return 'true';
    end;	
    --检测玩家是否在线
	local uObject, BoFind = M_GetUserIsPointer(arg[2]);
    if not BoFind then 
       P_saysystem(uSource, string.format('玩家[%s]不在线', arg[2]), 2);	
      return 'true';
    end;	
	AntiPlug.onAntiHelp(uObject);
    P_saysystem(uSource, string.format('已对[%s]进行问题检测', arg[2]), 2);	
   return 'true';
  end;
  
  --VIP信息查询
  if arg[1] == '@玩家位置' then
    --获取玩家地图ID和坐标
    local MapId, X, Y =  B_GetPosition(uSource);
    --获取周边玩家
    local ObjectList = M_GetMapOnlineUser(MapId, 0, 300);
    --循环改变周边玩家团队
    for oName, oSource in pairs(ObjectList) do
	  if uSource ~= oSource then 
        local _MapId, _X, _Y =  B_GetPosition(oSource);
        P_saysystem(uSource, string.format('&9%s;%d;%d', oName, _X, _Y), 0);	
	  end;
    end;
   return 'true';
  end;

  --查询临时变量_m
  if arg[1] == '@查询临时变量_m' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;	
	if arg[2] == '' or tonumber(arg[3]) == nil then 
       P_saysystem(uSource, '格式错误,[@查询临时变量_m 玩家名称 ID]', 2);
      return 'true';
    end;	
    --检测玩家是否在线
	local uObject, BoFind = M_GetUserIsPointer(arg[2]);
    if not BoFind then 
       P_saysystem(uSource, string.format('玩家[%s]不在线', arg[2]), 2);	
      return 'true';
    end;	
	local aValue = P_GetTempArr(uObject, tonumber(arg[3]));
    P_saysystem(uSource, string.format('玩家[%s]变量ID[%s]数值为：%d!', arg[2], arg[3], aValue), 2);	
   return 'true';
  end;

  --更新临时变量_m
  if arg[1] == '@更新临时变量_m' then
    --不是GM退出
    if P_GetSysopScope(uSource) < 100 then
	  return 'true'; 
	end;	
	if arg[2] == '' or tonumber(arg[3]) == nil or tonumber(arg[4]) == nil then 
       P_saysystem(uSource, '格式错误,[@更新临时变量_m 玩家名称 ID 数值]', 2);
      return 'true';
    end;	
    --检测玩家是否在线
	local uObject, BoFind = M_GetUserIsPointer(arg[2]);
    if not BoFind then 
       P_saysystem(uSource, string.format('玩家[%s]不在线', arg[2]), 2);	
      return 'true';
    end;	
	P_SetTempArr(uObject, tonumber(arg[3]), tonumber(arg[4]));
    P_saysystem(uSource, string.format('修改玩家[%s]变量ID[%s]数值分为：%s!', arg[2], arg[3], arg[4]), 2);	
   return 'true';
  end;

 return 'false';
end;

local rHitAdd = {
  [1] = 100,
  [2] = 200,
  [3] = 500,
  [4] = 1000,
};

local WeapLight = {
  --道具配置
  Item = {
    ['雕火龙套'] = 1,
    ['银狼破皇剑'] = 1,
    ['烈爪'] = 1,
    ['龙恨'] = 1,
    ['黄龙斧'] = 1,
    ['黄龙弓'] = 1,
    ['黄龙斗甲'] = 1,
    ['黄金手套'] = 1,
    ['忍者剑'] = 1,
    ['三叉剑'] = 1,
    ['新罗宝剑'] = 1,
    ['日本刀'] = 1,
    ['三叉戟'] = 1,
    ['桂林竹枪'] = 1,
    ['磐龙斧'] = 1,
    ['白龙手套'] = 1,
    ['黑龙手套'] = 1,
    ['白龙剑'] = 1,
    ['黑龙剑'] = 1,
    ['白龙刀'] = 1,
    ['黑龙刀'] = 1,
    ['白龙枪'] = 1,
    ['黑龙枪'] = 1,
    ['白龙斧'] = 1,
    ['黑龙斧'] = 1,
    ['狐狸手套'] = 1,
    ['龙光剑'] = 1,
    ['月光刀'] = 1,
    ['狼牙戟'] = 1,
    ['炎帝火灵斧'] = 1,
    ['四季甲胄'] = 1,
    ['驱魔烈火弓'] = 1,
    ['九法手套'] = 1,
    ['三飞剑'] = 1,
    ['半月刀'] = 1,
    ['罗汉竹枪'] = 1,
    ['背星棍'] = 1,
    ['军神槌'] = 1,
    ['青龙手套'] = 1,
    ['太极手套'] = 1,
    ['太极日剑'] = 1,
    ['太极月刀'] = 1,
    ['太极神枪'] = 1,
    ['太极斧'] = 1,
	['太极神弓'] = 1,
    ['太极斗甲'] = 1,
    ['轰岩手套'] = 1,
    ['断铠手套'] = 1,
    ['九魔密剑'] = 1,
    ['霸王剑'] = 1,
    ['九龙宝刀'] = 1,
    ['天王刀'] = 1,
    ['凤翅镋'] = 1,
    ['西域魔人枪'] = 1,
    ['锯齿大斧'] = 1,
    ['帝王槌'] = 1,
    ['北海连环弓'] = 1,
    ['金丝斗甲'] = 1,
    ['百炼黄金手套'] = 1,
    ['百炼忍者剑'] = 1,
    ['护国神剑'] = 1,
    ['百炼日本刀'] = 1,
    ['百炼三叉戟'] = 1,
    ['百炼桂林竹枪'] = 1,
    ['桂林大斧'] = 1,
    ['鹰雕手'] = 1,
    ['清月天剑'] = 1,
    ['天云宝刀'] = 1,
    ['白骨魔棒'] = 1,
    ['天龙月斧'] = 1,
    ['归魂斗甲'] = 1,
    ['大脉神弓'] = 1,
    ['血狂手'] = 1,
    ['血魔剑'] = 1,
    ['血风刃'] = 1,
    ['血化戟'] = 1,
    ['血皇斧'] = 1,
    ['血雨弓'] = 1,
    ['血魔斗甲'] = 1,
  },
 --颜色配置
  Color = {
    [0] = { --拳
      [1] = {21239, 32736, 65, 60, 160},
      [2] = {31, 32736, 99, 60, 160},
      [3] = {31754, 32736, 99, 60, 160},
      [4] = {32736, 32736, 55, 60, 160},
	},
    [1] = { --剑
      [1] = {21239, 32736, 65, 60, 160},
      [2] = {31, 32736, 99, 60, 160},
      [3] = {31754, 32736, 99, 60, 160},
      [4] = {32736, 32736, 55, 60, 160},
	},
    [2] = { --刀
      [1] = {21239, 32736, 65, 60, 160},
      [2] = {31, 32736, 99, 60, 160},
      [3] = {31754, 32736, 99, 60, 160},
      [4] = {32736, 32736, 55, 60, 160},
	},
    [3] = { --槌
      [1] = {21239, 32736, 65, 60, 160},
      [2] = {31, 32736, 99, 60, 160},
      [3] = {31754, 32736, 99, 60, 160},
      [4] = {32736, 32736, 55, 60, 160},
	},
    [4] = { --枪
      [1] = {21239, 32736, 65, 60, 160},
      [2] = {31, 32736, 99, 60, 160},
      [3] = {31754, 32736, 99, 60, 160},
      [4] = {32736, 32736, 55, 60, 160},
	},
    [5] = { --弓
      [1] = {21239, 32736, 65, 60, 160},
      [2] = {31, 32736, 99, 60, 160},
      [3] = {31754, 32736, 99, 60, 160},
      [4] = {32736, 32736, 55, 60, 160},
	},
    [6] = { --投
      [1] = {21239, 32736, 65, 60, 160},
      [2] = {31, 32736, 99, 60, 160},
      [3] = {31754, 32736, 99, 60, 160},
      [4] = {32736, 32736, 55, 60, 160},
	},
  },
};

--装备更换的时候触发
function OnChangeWearItem(uSource)
  --检查装备部位
  local Index  = {1, 3, 6, 8, 9};
  local _gm = {};
  local n = 1;
  for k = 1, #(Index) do
	local SmithingLevel = P_GetWearItemSmithingLevel(uSource, Index[k]);
    if SmithingLevel ~= nil and SmithingLevel > 0 then 
	  _gm[n] = SmithingLevel;
	  n = n + 1;
	  --table.insert(_gm, SmithingLevel);
	end;
  end;
  --判断buff状态
  if P_GetAddBuff(uSource, 9) > -1 then 
    P_SetAddBuff(uSource, 9, '', 0, 0, 0, '', {});	
  end;
  if #(_gm) >= 5 then 
    --取共鸣最小值
    local min = 99;
    for k = 1, #_gm do
	 if _gm[k] < min then 
	   min = _gm[k];
	 end;
	end;
    --local min = math.min(unpack(_gm));
    if rHitAdd[min] ~= nil then 
      --附加玩家属性
      local LifeData = {
		HitAdd = rHitAdd[min]
      };
      P_SetAddBuff(uSource, 9, string.format('装备共鸣[Lv.%d]', min), 60 * 60 * 365, 995, 0, string.format('装备共鸣[Lv.%d]^伤害增加:%.2f%%', min, rHitAdd[min] // 100), LifeData);		  
    end;
  end;
   --判断装备发光
  P_ClearWeapLight(uSource);--清除发光
   --判断装备发光
  local ItemData = P_GetWearItemInfoTabs(uSource, 9);
  if ItemData.Name ~= '' and WeapLight.Item[ItemData.Name] ~= nil and WeapLight.Color[ItemData.rHitType] ~= nil then
	--判断装备段数
	local t = WeapLight.Color[ItemData.rHitType][ItemData.Upgrade];
	   if t ~= nil then 
        P_SetWeapLight(uSource, t[1], t[2], t[3], t[4], t[5],true);
	end;
  end;
end;

--死亡触发
function OnKilled(uSource, ...)
  local arg = {...};
	--死亡提示
	if arg[1] ==  3 then
		P_saysystem(uSource,  string.format("您在【%s】被玩家【%s】杀死。", time_format(os.time()), arg[3]), 20);
		--对方提示
		local uObject, BoFind = M_GetUserIsPointer(arg[3]);
		if BoFind then 
		  P_saysystem(uObject, string.format("你击杀了玩家[%s]", B_GetRealName(uSource)), 20);
		end;	
	elseif arg[1] ==  2 then
		P_saysystem(uSource,  string.format("您在【%s】被怪物【%s】杀死。", time_format(os.time()), arg[3]), 20);
	elseif arg[1] ==  1 then
		P_saysystem(uSource,  string.format("您在【%s】被NPC【%s】杀死。", time_format(os.time()), arg[3]), 20);
	else
		P_saysystem(uSource,  string.format("您在【%s】被杀死。", time_format(os.time())), 20);
	end;
  --不是VIP传回复活点
  local MapId, X, Y =  B_GetPosition(uSource);
    if MapId ~= 0 then
    --判断身上装备
	local ItemData = P_GetWearItemInfoTabs(uSource, 13);
	if ItemData.Name == '武侠令(24小时)' or ItemData.Name == '武侠令(永久)' then 
     --P_MapMove(uSource, 2, 65 + math.random(-6, 6), 56 + math.random(-6, 6), 0);
	 --P_saysystem(uSource, '你没有武侠令或者没有佩戴，死亡将你传送至大战场', 2);
    else
   --检测是否是VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if viplevel < 3 then 	
	 P_MapMove(uSource, 2, 65 + math.random(-6, 6), 56 + math.random(-6, 6), 0);
	 P_saysystem(uSource, '练体等级未到达[结丹期]或者没有佩戴[武侠令],将你传送至大战场', 2);
    end;
   end;
  end;
 end;

--杀死怪物触发
function OnMonsterDie(uSource, uDest, MonsterName, MapId)
  --新手任务触发
  NewTask.MonsterDie(uSource, MonsterName, MapId);
  --主线任务触发
  ZxQuest.MonsterDie(uSource, MonsterName);
  --击杀怪物
  CheckNoMonster(uSource, MonsterName);
  --反外挂进程检测
  AntiPlug.CheckBlackList(uSource);
end;

--物品爆出
function OnDropItem(uSource, MonsterName, Name, ViewName, Count)
  Equipmentbroke(uSource, MonsterName, Name, ViewName, Count);	
 return;
end;

--[[VIP常用检测触发
--aType(触发类型: 1=交易,2=丢弃,3解锁物品栏)
--返回'true'停止执行TGS后续代码
function OnVipCheck(uSource, aType) 
  if aType == 1 then
    --检测是否是VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then 
   P_saysystem(uSource, 'VIP玩家才允许进行交易操作', 2);
      return 'true';
    end;
  --丢弃
  elseif aType == 2 then
    --检测是否是VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then 
   P_saysystem(uSource, 'VIP玩家才允许进行丢弃操作', 2);
      return 'true';
    end;
  end;
end]]

--任务触发
function OnQuest(uSource, AGid)
    if AGid == 0 then
    --新手任务触发
    NewTask.Start(uSource);
    --主线任务触发
    ZxQuest.Start(uSource);
	end
 return;
end;

--任务完成
function OnQuestConfirm(uSource, AGid, AQid, Atype, Value)
 return;
end;

--商城购买
function OnEmporia(uSource, ItemName, ItemCount, atype)
      --M_worldnoticemsg(ItemName, 65535, 0);
	   --M_worldnoticemsg(ItemCount, 65535, 0);
	return 'true';
end;

--商城限购
local BuyItem = {
  ['小丸丹2'] = {
	['Key'] = 2, --key
	['Type'] = 1, --限制类型 1每日，2永久
	['Max'] = 5, --限制次数
  },
  ['防爆丹2'] = {
	['Key'] = 3, --key
	['Type'] = 1, --限制类型 1每日，2永久
	['Max'] = 5, --限制次数
  },
};
--商城购买检测
local NoHaveItem = {
  ['武侠令(60天)'] = {
   '武侠令(6天)',
  },
};
--atype (0购买前,1购买后)
function OnEmporiaBuy(uSource, ItemName, ItemCount, atype)
  --购买前
  if atype == 0 then 
    --重复购买检测
	if NoHaveItem[ItemName] ~= nil then 
      --获取当前VIP信息
      local viplevel, viptime = P_GetVipInfo(uSource);
	  if viplevel < 1 then 
        P_saysystem(uSource, 'VIP角色可购买', 25);
        return 'true';
	  end;
	  for k, v in ipairs(NoHaveItem[ItemName]) do
	    --判断物品栏
	    if P_getitemcount(uSource, v) >= 1 then 
          P_saysystem(uSource, string.format('抱歉,拥有 %s 无法购买', v), 25);
          return 'true';
	    end;	
	  end
    --限购处理
    elseif BuyItem[ItemName] ~= nil then 
      --获取玩家名称
      local PlayName = B_GetRealName(uSource);
      --获取当前日期
      local CurrentDate = os.date("%Y-%m-%d");
      local PlayDate = '';
      local PlayNum = 0;
      --读取MYSQL数据
      local SQL = string.format('SELECT dates, num FROM item_daynum WHERE playname="%s" and ids=%d', PlayName, BuyItem[ItemName].Key);
      local Data = M_GetMySqlDataSet(SQL);
      --判断读取MYSQL状态
      if Data ~= nil and Data[1] ~= nil then
        PlayDate = Data[1]['dates'];
        PlayNum = tonumber(Data[1]['num']);
      end;
      --类型1重置次数
      if BuyItem[ItemName].Type == 1 and PlayDate ~= CurrentDate then 
        PlayNum = 0;
      end	
      --判断次数
      if BuyItem[ItemName].Type == 1 and PlayNum >= BuyItem[ItemName].Max then 
       P_saysystem(uSource, string.format('抱歉,每日限购%d个!!', BuyItem[ItemName].Max), 25);
       return 'true';
      elseif BuyItem[ItemName].Type == 2 and PlayNum >= BuyItem[ItemName].Max then 
        P_saysystem(uSource, string.format('抱歉,永久限购%d个!!', BuyItem[ItemName].Max), 25);
       return 'true';
      end
    end;
  --购买后
  elseif atype == 1 then 
   --限购处理
    if BuyItem[ItemName] ~= nil then 
     --更新使用次数SQL	
     local PlayName = B_GetRealName(uSource);
     local CurrentDate = os.date("%Y-%m-%d");
     M_DoMySql(string.format('INSERT item_daynum (playname, ids, dates, num) values (\'%s\', %d, \'%s\', %d) ON DUPLICATE KEY UPDATE dates="%s", num=num+%d', PlayName, BuyItem[ItemName].Key, CurrentDate, ItemCount, CurrentDate, ItemCount));	
    end;
  end;
end;
  
--[[    适应：角色。事件在GameSys.lua脚本里。
    功能：加入门派后触发。
    参数：uSource，玩家对象
          GuildName，门派名称		--]]
function OnAddGuild(uSource, GuildName)
  --M_worldnoticemsg('加入了门派=='..GuildName, 65535, 3);
  --新加入门派改门派贡献为0
  P_SetGuildPoint(uSource, 0);
end;

--[[    适应：角色。事件在GameSys.lua脚本里。
    功能：管理踢人后门派后触发。
    参数：uSource，玩家对象
            GuildName，门派名称
            UserName，被踢玩家名称
            UserPoint，被踢玩家门派贡献--]]
function OnDelGuild(uSource, GuildName, UserName, UserPoint)
  --获取门派贡献
  local GuildEnegy = M_GetGuildEnegy(GuildName);
  GuildEnegy = GuildEnegy - UserPoint;
  if GuildEnegy < 0 then GuildEnegy = 0 end;
  --写入门派贡献
  --M_SetGuildEnegy(GuildName, GuildEnegy);
  --门派公告
  --M_GuildSay(GuildName, string.format('[门派公告]%s将%s踢出了门派', B_GetRealName(uSource), UserName), 16);	
  --检测玩家是否在线
  local uObject, BoFind = M_GetUserIsPointer(UserName);
  if not BoFind then 
    GuildSys.QuitPlay(uObject);
  end;	
end;

--[[    适应：角色。事件在GameSys.lua脚本里。
    功能：主动退出门派后触发。
    参数：uSource，玩家对象	
            GuildName，门派名称--]]
function OnExitGuild(uSource, GuildName)
  GuildSys.QuitPlay(uSource);
end;


--[[    适应：角色。事件在GameSys.lua脚本里。
    功能：角色改名后触发。
    参数：uSource，玩家对象	
          OldName，旧名字	
          NewName，新名字--]]
function OnChangeCharName(uSource, OldName, NewName)		
  --公告
  M_worldnoticesysmsg(string.format('【江湖通告】玩家[%s]改名换姓成为了[%s]', OldName, NewName), 18);
  P_saysystem(uSource, '角色改名成功，请重新登陆', 25);
  --改本MYSQL
  local sqllist = {
    ['card_read'] = 'playname', 
    ['email_read'] = 'playname', 
    ['item_daynum'] = 'playname', 
    ['mqn_contact'] = 'aname', 
    ['playzy'] = 'playname', 
    ['userpay'] = 'username', 
	['guild_user'] = 'name',
	['guild_data'] = 'sysop',
	['wxz_fuben_1'] = 'playname',
	['prison'] = 'username',
	['wxz_vipfuli_1'] = 'playname',
	['mqn_dayquest'] = 'playname',
	['mqn_dailyquest_1'] = 'playname',
	['mqn_itemnum_1'] = 'playname',
  };
  for key, value in pairs(sqllist) do
    M_DoMySql(string.format('UPDATE %s SET %s = \'%s\' WHERE %s = \'%s\'', key, value, NewName, value, OldName));	
  end;
  --记录LOG
  local str = string.format('%s->%s(%s)\n', OldName, NewName, time_format(os.time()))
  file = io.open('改名记录.txt', 'a+')
  file:write(str)
  file:close()
  P_BanPlay(uSource);
end;

--外挂检测
function OnGameCheck(uSource, subkey, subindex, str)	
  --M_worldnoticesysmsg(string.format('subkey[%d] -- subindex[%d] -- str[%s]', subkey, subindex, str), 18);
  if subkey == 10 then
     P_SetEventTick(uSource, subkey, 100 * 60 * 5)
  elseif subkey == 11 then
     P_SetEventTick(uSource, subkey, 100 * 60 * 5)
  elseif subkey == 12 then
     P_SetEventTick(uSource, subkey, 100 * 60 * 5)
  elseif subkey == 14 or subkey == 15 then
	P_BanPlay(uSource);
	-- --囚禁	记录记录
	-- local n = P_GetTempArr(uSource, 17) + 1;
	-- P_SetTempArr(uSource, 17, n);
	-- P_PrisonPlay(B_GetRealName(uSource), string.format('C%d', 3 * (n * n)), '外挂使用者'); --囚禁6小时	
  elseif subkey == 16 then --内存特征先踢下线
	P_BanPlay(uSource);
  elseif subkey == 5 then --点击次数统计
--[[     local t = lua_Strtotable(str, ';');
	 if #t == 6 then
	   --左键点击次数>=100次统计  点击像素 <=2 视为连点
	   if t[1] >= 100 and t[2] > 0 and t[2] <= 2 then 
		  P_BanPlay(uSource);
	   end
	 end;
	 zmax = tonumber(zmax); --左键点击总数
	 z1 = tonumber(z1); --左键像素数量
	 z2 = tonumber(z2); --左键坐标数量
	 ymax = tonumber(ymax); --右键点击总数
	 y1 = tonumber(y1); --右键像素数量
	 y2 = tonumber(y2); --右键坐标数量
    -- M_worldnoticesysmsg(string.format('zmax[%d] -- z1[%d] -- z2[%d] -- ymax[%d] -- y1[%d] -- y2[%d]', zmax, z1, z2, ymax, y1, y2), 18);
     --左键点击次数超过100次统计
	 if zmax >= 100 then 
	    --如果左键点击像素位置或者点击坐标比例超过20 视为脚本
		if math.floor(zmax // z1) >= 20 or math.floor(zmax // z2) >= 20 then
		  P_BanPlay(uSource);
		end
	 end;
     --右键键点击次数超过20次统计
	 if ymax >= 20 then 
	    --如果右键点击像素位置或者点击坐标比例超过5 视为脚本
		if math.floor(ymax // y1) >= 5 or math.floor(ymax // y2) >= 5 then
		  P_BanPlay(uSource);
		end
	 end;--]]
  end;
  --进程检测
  AntiPlug.CheckBlackList(uSource);
  --return 'true';
end;

--定时触发
function OnEventTick(uSource, akey)	
  if akey == 10 then
     P_BanPlay(uSource);
  elseif akey == 11 then
     P_BanPlay(uSource);
  elseif akey == 12 then
     P_BanPlay(uSource);
   elseif akey == 13 then --主线任务添加触发
    ZxQuest.Start(uSource);
  elseif akey == 14 then --主线任务删除触发
    ZxQuest.Deltemp(uSource);
  elseif akey == 98 then --VIP属性触发
    VipAttrib.open(uSource);
  elseif akey == 99 then --VIP检测
  elseif akey == 999 then --整点触发
  --[[判断身上装备
	local ItemData = P_GetWearItemInfoTabs(uSource, 13);
	if ItemData.Name ~= '武侠令(30天)' and ItemData.Name ~= '武侠令(3天)' then 
      P_saysystem(uSource, '武侠令已过期或者没有佩戴-已停止挂机', 25);
      P_SetAutoHit(uSource, false);
   end;]]
  end;
 end;

--比例
local bili = 10;
--元宝领取触发
local OnEmporiaClick = {};
--首充道具
local FirstChargeReward = "首充礼包";
--首次领取充值奖励的条件：首次领取时的金额
local FCRewardCondit = 500000;
--累计充值奖励
local payitem = {
  [1] = {
    num = 2000000,
    item = {
	  {'灵动八方', 1},
	},
  },
}

--充值奖励（检测金额,赠送元宝数量比例）
local PayReward = {
  [1] = {200000, 50},
  [2] = {100000, 40}, 
  [3] = {50000, 30}, 
  [4] = {20000, 20}, 	
  [5] = {10000, 10}, 				 
};

function OnEmporiaGet(uSource, datestr)	
  --获取玩家名称
  local PlayName = B_GetRealName(uSource);
  if OnEmporiaClick[PlayName] == nil then 
   OnEmporiaClick[PlayName] = 0;
  end;
  local amp = strtostamp(datestr);
  if amp - OnEmporiaClick[PlayName] <= 3 then
    P_saysystem(uSource, '点击太过频繁,请稍后再试', 0);
    return 'true';
  end;	
  OnEmporiaClick[PlayName] = amp;
  local Data = M_GetMySqlDataSet('SELECT SUM(money) as money FROM userpay WHERE username = "'..PlayName..'" and status = 0');
  --判断读取MYSQL状态
  if Data == -1 or Data == nil or Data[1] == nil then
    P_saysystem(uSource, '没有找到您的充值记录,请稍后尝试!', 0);
    return 'true';
  end;
  --写入数据库
  local sql = string.format('UPDATE userpay SET status = 1, update_time = %d WHERE username = "%s" and status = 0', os.time(), PlayName);
  if M_DoMySql(sql) <= 0 then 
    P_saysystem(uSource, '领取失败,没有找到您的充值记录,请稍后尝试!', 0);
   return 'true';
  end;
  --数据转换
  local money = tonumber(Data[1]['money']);
  local dianjuan = money * bili;
  --获取奖励元宝
  local RewardNum = money * OnPayReward(money) // 100 * bili;
  --更新玩家元宝
  P_AddMysqlDianJuan(uSource, dianjuan * 1 + RewardNum);
  --更新玩家充值记录
  P_SetTempArr(uSource, 18, P_GetTempArr(uSource, 18) + money);
  --发送消息
  P_saysystem(uSource, string.format('您充值了%d元,感谢您的支持。', money), 20);
  --M_topmsg(string.format('公告:玩家[%s]领取了充值的元宝!', PlayName), 16711935, 0);
  --充值超过1000000元
  if money >= 10000000 then 
    P_additem(uSource, '交易币', 200 , Npc_Name);
	end;
  --是否给首冲
  if money >= FCRewardCondit then --检查是否为首次充值
    local FirstChargeYet = M_GetSdbInfo(".\\FirstCharge.sdb", PlayName, 'FirstChargeYet');
	if FirstChargeYet ~= '1' then
      P_additem(uSource, FirstChargeReward, 1, '首冲', 0);
     M_SetSdbInfo(".\\FirstCharge.sdb", PlayName, 'FirstChargeYet', '1'); 
	end
  end
  --获取当前充值金额
  local PayCount = tonumber(M_GetSdbInfo(".\\FirstCharge.sdb", PlayName, 'PayCount')) or 0;
  PayCount = PayCount + money;
   --写入金额
  M_SetSdbInfo(".\\FirstCharge.sdb", PlayName, 'PayCount', PayCount); 
  P_saysystem(uSource, string.format('当前累计充值:%d元', PayCount), 20);
  --获取给与奖励ID
  local PayID = tonumber(M_GetSdbInfo(".\\FirstCharge.sdb", PlayName, 'PayID')) or 0;
  --判断是否给奖励
  if payitem[PayID + 1] ~= nil and PayCount >= payitem[PayID + 1].num then 
    M_SetSdbInfo(".\\FirstCharge.sdb", PlayName, 'PayID', PayID + 1); 
    --给予道具
    for i, v in pairs(payitem[PayID + 1].item) do
      if type(v) == 'table' then
        P_additem(uSource, v[1], v[2], '累计充值奖励');
      end
    end;
    P_saysystem(uSource, string.format('获取累计充值%d元奖励', payitem[PayID + 1].num), 20);
  end;
  OnEmporiaClick[PlayName] = nil;
 return 'true';
end

function OnPayReward(money)
  local RetNum = 0;
  for i = 1, #PayReward do
    if money >= PayReward[i][1] then
      RetNum = PayReward[i][2];
	  break;
    end;  
   end;
  return RetNum;
end;

--修炼场地图ID
local ToMAP = {
  [305] = 9, --地图id=Arr ID
};
--消息提醒
local ToMAPMsg = {};

--地图定时触发(每分钟)
function OnMapUpdate(uSource, ServerID)	
  --修练场地图ID	
  if ToMAP[ServerID] ~= nil then
    local aTime = P_GetTempArr(uSource, ToMAP[ServerID]);
	--时间减少60秒
	aTime = aTime - 60;
	if aTime < 0 then aTime = 0 end;
	--写入时间
	P_SetTempArr(uSource, ToMAP[ServerID], aTime);
	--时间<=0传送回长城以南
	if aTime > 0 then	
      if ToMAPMsg[uSource] == nil then 
	    ToMAPMsg[uSource] = 0;
	  end;
	  ToMAPMsg[uSource] = ToMAPMsg[uSource] + 1;
	  if ToMAPMsg[uSource] == 5 then 
	    --发提示
	    P_LeftText(uSource, string.format('当前修炼场时间剩余 %s', timestostring(aTime)), 65535, 3);
	    --重置
	    ToMAPMsg[uSource] = 0;
	  end;
	else
	  --随机传送
	  math.randomseed(M_GetJavaTime():reverse():sub(1, 6));
	  math.random();
	  local X = 499 - math.random(-8, 8);
	  local Y = 499 - math.random(-8, 8);
	  P_MapMove(uSource, 1, X, Y, 0);
	  P_saysystem(uSource, '修炼场时间已消耗完!', 15);	
	end;
    return;
  end
end

local _cy = {
  [1] = {
    ['Name'] = '百里传音',
    ['Item'] = {'百里传音', 1},
	['t'] = 60,
	['leftcolor'] = 15794175,
	['msgcolor'] = {15794175, 6961226},
	['Effect'] = 10001,
  },
  [2] = {
    ['Name'] = '千里传音',
    ['Item'] = {'千里传音', 1},
	['t'] = 5,
	['leftcolor'] = 12615935,
	['msgcolor'] = {12615935, 8388608},
	['Effect'] = 10002,
  },
  [3] = {
    ['Name'] = '万里传音',
    ['Item'] = {'万里传音', 1},
	['t'] = 0,
    ['leftcolor'] = 65535,
	['msgcolor'] = {65535, 255},
	['Effect'] = 10003,
  },
};

local _cyt = {
 [1] = 0,
 [2] = 0,
 [3] = 0,
 [4] = 0,
 [5] = 0,
 [6] = 0,
};

function OnCySys(uSource, uKey, arg)
  if not P_BoFreedom(uSource) then 
    P_saysystem(uSource, '请先关闭其他窗口', 2);
   return;
  end
  if string.len(arg[2]) == 0 then 
    P_saysystem(uSource, '请输入传音内容!', 2);
   return;
  end
  --获取tab
  local t = _cy[uKey];
  if t == nil then return end;
  --检测道具数量
  if P_getitemcount(uSource, t['Item'][1]) < t['Item'][2] then 
	 P_saysystem(uSource, string.format('没有%d个%s', t['Item'][2], t['Item'][1]), 2);
     return;
  end
  --检测发送时间
  local m = os.time();
  if m - _cyt[uKey] < t['t'] then 
	 P_saysystem(uSource, string.format('%d秒后才可以使用百里传音', t['t'] - (m - _cyt[uKey])), 2);
     return;
  end
  --屏蔽流放地
  local MapId, X, Y =  B_GetPosition(uSource);
  if MapId == 113 then 
    P_saysystem(uSource, '流放地禁止使用!', 2);
   return;
  --屏蔽新手村
  elseif MapId == 0 then 
    P_saysystem(uSource, '新手村禁止使用!', 2);
   return;
  end;
  --记录发送时间
  _cyt[uKey] = m;
  --循环10次，用来处理空格
  --local astr = string.format('『%s-%s』:', B_GetRealName(uSource), t['Name']); 
  local astr = string.format('『%s』:', B_GetRealName(uSource), t['Name']); 
  local saystr = ''; 
  for i= 2, 10 do
    if arg[i] ~= '' then
      saystr = saystr .. arg[i];
    else
      saystr = saystr ..' ';
    end;
  end
  --去除首尾空格
  saystr = string.gsub(saystr, "^%s*(.-)%s*$", "%1");
  astr = astr .. string.sub(saystr, 0, 60);
 -- astr = string.format('『%s-%s』:%s', B_GetRealName(uSource), t['Name'], astr);
  if arg[16] == nil then 
    --发送顶部消息
    M_leftmsg(astr, t['leftcolor'], 14, t['Effect']);
    --发送聊天框消息
    M_worldnoticemsg(astr, t['msgcolor'][1], t['msgcolor'][2]);
  else
    --发送顶部消息
    M_leftmsgitem(astr, t['leftcolor'], 14, t['Effect'], arg[16]);
    --发送聊天框消息
    M_worldnoticemsgitem(astr, t['msgcolor'][1], t['msgcolor'][2], arg[16]);
  end;
  --删除道具
  P_deleteitem(uSource, t['Item'][1], t['Item'][2], '传音');
 return;
end

--点击菜单触发
function OnGetResult(uSource, aStr)
  --分解字符串
  local Left, Right = lua_GetToken(aStr, '_');
  --分解选择分类
  if Left == 'Anti' then
    AntiPlug.onGetResult(uSource, Right)
  end	
end

--[[VIP常用检测触发
--aType(触发类型: 1=交易,2=丢弃,3解锁物品栏)
--返回'true'停止执行TGS后续代码
function OnVipCheck(uSource, aType)	
  if aType == 1 then
    --检测是否是VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then  
      --获取玩家基本属性
      local Attrib = P_GetAttrib(uSource);
      --判断年龄是否到达
      if Attrib.Age < 3500 then 
        P_saysystem(uSource, '非VIP玩家35岁前不允许交易', 25);
        return 'true';
      end;
    end;
  end;
  --丢弃
  if aType == 2 then
    --检测是否是VIP
    local viplevel, viptime = P_GetVipInfo(uSource);
    if strtostamp(viptime) < os.time() then 
      --获取玩家基本属性
      local Attrib = P_GetAttrib(uSource);
      --判断年龄是否到达
      if Attrib.Age < 3500 then 
        P_saysystem(uSource, '非VIP玩家35岁前不允许丢弃', 25);
        return 'true';
      end;
    end;
  end;
end]]
