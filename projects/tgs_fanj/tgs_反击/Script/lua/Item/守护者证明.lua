package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

dofile('Script\\lua\\plug\\table.lua')

local lifedata = {
  [1] = {armorBody = 150, damageBody = 300, avoid= 15, AttackSpeed = -5},
  [2] = {armorBody = 120, damageBody = 240, avoid= 12, AttackSpeed = -4},
  [3] = {armorBody = 100, damageBody = 200, avoid= 10, AttackSpeed = -3},
  [4] = {armorBody = 80, damageBody = 160, avoid= 8, AttackSpeed = -1},
  [5] = {armorBody = 70, damageBody = 140, avoid= 7, AttackSpeed = -1},
  [6] = {armorBody = 60, damageBody = 120, avoid= 6, AttackSpeed = -1},
  [7] = {armorBody = 50, damageBody = 100, avoid= 5},
  [8] = {armorBody = 40, damageBody = 80, avoid= 4},
  [9] = {armorBody = 30, damageBody = 60, avoid= 3},
  [10] = {armorBody = 20, damageBody = 40, avoid= 2},
};

--用于修改时表的索引信息
local AttribIndex = {
  ['damageBody'] = '攻击',  ['damageHead'] = '打头',   ['damageArm'] = '打手',   ['damageLeg']    = '打脚',
  ['armorBody']  = '防御',  ['armorHead']  = '头防',   ['armorArm']  = '手防',   ['armorLeg']     = '脚防',
  ['AttackSpeed']= '速度',  ['accuracy']   = '命中',   ['avoid']     = '闪躲',   ['KeepRecovery'] = '维持',  ['recovery'] = '恢复'
};

function OnItemDblClick(uSource, uItemKey, astr)
   if not P_BoFreedom(uSource) then 
     P_saysystem(uSource, '请先关闭其他窗口', 2);
    return;
   end
   --获取KEY道具
   local ItemData = P_GetHaveItemInfoTabs(uSource, uItemKey);
   if ItemData == nil or ItemData.Name == nil or ItemData.Name ~= '守护者证明1' then
    return;
   end;
  --判断文件是否存在
  local File = "Tgsplus\\天关排行.sdb";
  if not file_exists(File) then
     return;
  end;
  --读取数据
  local t = table.load(File);
  if #t['Rank'] <= 0 then 
    return;
  end;
  --获取玩家地图ID和坐标
  local MapId, X, Y =  B_GetPosition(uSource);
  if MapId >= 500 and MapId <= 509 then
    P_saysystem(uSource, '君临天下:此地图无法开启', 14);
    return;
  end;
  --获取玩家名
  local PlayName = B_GetRealName(uSource);
  --循环获取排名
  local n = 0;
  for k = 1, #t['Rank'] do
    if t['Rank'][k] ~= nil and PlayName == t['Rank'][k][1] then 
      n = k;
      break;
    end;	
  end;
  --不在排名内删除道具
  if n <= 0 or lifedata[n] == nil then 
    P_saysystem(uSource, '关排行榜前10名才有资格开启属性', 14);
    P_DelHaveItemInfo(uSource, uItemKey, 1);
    --判断BUFF
    if P_GetAddBuff(uSource, 19) > -1 then 
      P_SetAddBuff(uSource, 19, '君临天下', 0, 1358, 0, '', {}); -- 关闭
      P_saysystem(uSource, '君临天下:BUFF已关闭', 14);
    end;
    return;
  end
  --判断BUFF
  if P_GetAddBuff(uSource, 19) > -1 then 
    P_SetAddBuff(uSource, 19, '君临天下', 0, 1358, 0, '', {}); -- 关闭
    P_saysystem(uSource, '君临天下:BUFF已关闭', 14);
  else
    P_SetAddBuff(uSource, 19, '君临天下', 60 * 60 * 24, 1358, 0, string.format('天关排行榜第[%d]玩家^属性:%s', n, GetAttribInfo(lifedata[n])), lifedata[n]); --开启
    P_saysystem(uSource, '君临天下:BUFF已开启', 14);
  end;
 return;
end

--取属性table字符信息
function GetAttribInfo(LifeData)
  local t ='';
  for key, value in pairs(LifeData) do 
    if value ~= '' and tonumber(value) ~= 0 and AttribIndex[key] ~= nil then 
	  if key == 'ZDL' then 
	    t = string.format('%s[%s:%0.2f]', t, AttribIndex[key], value // 100);
	  else
	    t = string.format('%s[%s:%d]', t, AttribIndex[key], value);
	  end; 
	end
  end;
  if t == '' then 
    t = '无属性';
  end
end;