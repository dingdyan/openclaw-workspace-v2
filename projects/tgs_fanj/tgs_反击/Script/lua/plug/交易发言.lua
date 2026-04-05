dofile('Script\\lua\\plug\\table.lua')

PlayLock = {
  --数据保存路径
  File = "Tgsplus\\玩家锁定.sdb",
  --数据
  data = {
  },
}

--读取数据库
PlayLock.Load = function()
  if file_exists(PlayLock.File) then
    PlayLock.data = table.load(PlayLock.File)
  end
end

--保存数据库
PlayLock.Save = function()
  table.save(PlayLock.data, PlayLock.File)
end

--读取数据库
PlayLock.Load();

--上线检测
PlayLock.Start = function(uSource)
  local PlayName = B_GetRealName(uSource);	
  if PlayLock.data[PlayName] == nil then
    return;
  end;
  if PlayLock.data[PlayName][1] == 0 and PlayLock.data[PlayName][2] == 0 then
    PlayLock.data[PlayName] = nil;
	PlayLock.Save();
    return;
  end;
  if PlayLock.data[PlayName][1] == 1 then
    P_SetTradeExit(uSource, true);
    P_sayByCol(uSource, '交易权限已关闭.', 65535, 7274496);
  end;
  if PlayLock.data[PlayName][2] == 1 then
    P_SetSayExit(uSource, true);
    P_sayByCol(uSource, '说话权限已关闭.', 65535, 7274496);
  end;
 return;
end;

--设置交易
PlayLock.SetTrade = function(PlayName, aVal)
  --获取玩家名称
  if PlayLock.data[PlayName] == nil then
    PlayLock.data[PlayName] = {0, 0};
  end;
  PlayLock.data[PlayName][1] = aVal;
  PlayLock.Save();
 return;
end;

--设置发言
PlayLock.SetSay = function(PlayName, aVal)
  --获取玩家名称
  if PlayLock.data[PlayName] == nil then
    PlayLock.data[PlayName] = {0, 0};
  end;
  PlayLock.data[PlayName][2] = aVal;
  PlayLock.Save();
 return;
end;
