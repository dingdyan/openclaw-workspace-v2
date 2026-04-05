package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');
dofile('Script\\lua\\plug\\table.lua')

--幸运大抽奖
_hs = {
  --数据保存路径
  File = "Tgsplus\\护送变量.sdb",
  --数据
  data = {
  },
}

--读取数据库
_hs.Load = function()
  if file_exists(_hs.File) then
    _hs.data = table.load(_hs.File)
  end
end

--保存数据库
_hs.Save = function()
  table.save(_hs.data, _hs.File)
end

_hs.Load();

--目标配置
local ToNpc = {
  [1] = '九尾狐酒母',
  [2] = '捕盗大将',
  [3] = '牛俊',
  [4] = '梅花夫人',
  [5] = '老侠客',
  [6] = '白捕校',
  [7] = '黑捕校',
}

--刷新触发
function OnRegen(uDest)
  --获取护送人姓名
  local PlayName = B_GetObjectGuild(uDest);
  if PlayName == '' then 
    B_DelObjByID(uDest, 'MONSTER');
    _hs.data[uDest] = nil;
    _hs.Save();
    return;
  end;
  local sql = string.format('SELECT ids FROM yabiao WHERE playname=\'%s\'', PlayName);
  local Data = M_GetMySqlDataSet(sql);
  local ids = 1;
  if Data ~= nil and Data[1] ~= nil then
    ids = tonumber(Data[1]['ids']) or 1;
  end;
  --记录上出生时间戳
  _hs.data[uDest] = {0, os.time(), ids};
  _hs.Save();
  --说话
  B_SAY(uDest, string.format('尊敬的%s,快护送我前往[%s]处吧!', PlayName, ToNpc[ids]));
end;


--定时触发
function OnUpdate(uDest, CurTick)
  if _hs.data[uDest] == nil then 
    _hs.data[uDest] = {0, os.time(), 1};
  end;
  --计次+1
  _hs.data[uDest][1] = _hs.data[uDest][1] + 1;
  --3秒处理次
  if _hs.data[uDest][1] >= 3 then 
    _hs.data[uDest][1] = 0;
    --获取护送人姓名
    local PlayName = B_GetObjectGuild(uDest);
    if PlayName == '' then 
      B_DelObjByID(uDest, 'MONSTER');
	  _hs.data[uDest] = nil;
	  _hs.Save();
	  return;
    end;
	--判断怪物超过30分钟
	if os.time() - _hs.data[uDest][2] > 1800 then 
      B_DelObjByID(uDest, 'MONSTER');
	  _hs.data[uDest] = nil;
	  _hs.Save();
	  return;
    end;
    --判断是否在视线内
    local uObject, BoFind = B_FindObjectByName(uDest, PlayName, 1);
    if BoFind then 
	  --任务已完成	
      if P_GetTempArr(uObject, 13) ~= 1 then 
        B_DelObjByID(uDest, 'MONSTER');
	    _hs.data[uDest] = nil;
	    _hs.Save();
	    return;
      end;
	  --移动
      local MapId, X, Y =  B_GetPosition(uObject); 
      --B_SAY(uDest, string.format('MapId = %d, X = %d, Y = %d ', MapId, X, Y));
	  B_SetCreateXY(uDest, X, Y);
	  B_GotoXyStand(uDest, X, Y);
	  return;
    end;
	--是否在线
	local uObject, BoFind = M_GetUserIsPointer(PlayName);
    if BoFind then 
       local MapId, X, Y =  B_GetPosition(uDest); 
       P_saysystem(uObject, string.format('护送目标:我在 %d,%d,快护送我前往[%s]处吧', X, Y, ToNpc[_hs.data[uDest][3]]), 2);	
      return 'true';
    end;	
  end;
end


--死亡
function OnPlayDie(uSource, uDest)
  if _hs.data[uDest] ~= nil then 
    _hs.data[uDest] = nil;
    _hs.Save();
  end;
end;