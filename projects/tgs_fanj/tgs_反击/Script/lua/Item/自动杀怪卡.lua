function OnHaveDateTimeDel(uSource, uItemKey)
  --获取挂机状态
  if P_GetAutoHit(uSource) then 
    P_SetAutoHit(uSource, false);
    P_saysystem(uSource, '停止挂机', 25);
    P_SetAddBuff(uSource, 99, '挂机中', 0, 0, 0, '', {});	
  end;
  --设置离线不杀怪
  P_SetBoOfflineType(uSource, 0);
 return;
end
