local ncount = 0;

--刷新触发
function OnRegen(uSource)
  ncount = 0;
end;
--打开触发
function OnTurnOn(uSource, uDest)
  if ncount < 8 then
    ncount = ncount + 1;
  end
  if ncount == 1 then
    M_MapObjSay(70, '王陵3层_雨中客:有人侵入王陵', 15);
    M_MapObjSay(70, '王陵3层_雨中客:启动机关装置', 15);
	M_MapAddDynamicobject(70, '滚动桥A', '', '', '', '', '', '', 248, 138, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '滚动桥B', '', '', '', '', '', '', 230, 116, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '滚动狮子A', '', '', '', '', '', '', 255, 141, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '滚动狮子A', '', '', '', '', '', '', 247, 132, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '滚动狮子B', '', '', '', '', '', '', 228, 111, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '滚动狮子B', '', '', '', '', '', '', 237, 119, 0, 0, 0, 0);
    return;
  end
  if ncount == 3 then
    M_MapObjSay(70, '王陵3层_雨中客:损失比预计的要惨重', 15);
    M_MapObjSay(70, '王陵3层_雨中客:封锁秘密通道', 15);
	M_MapAddDynamicobject(70, '迷宫门', '', '', '', '', '', '', 281, 83, 0, 0, 0, 0);
    return;
  end

  if ncount == 5 then
    M_MapObjSay(70, '王陵3层_雨中客:再也支撑不住了', 15);
    M_MapObjSay(70, '王陵3层_雨中客:封锁所有的出入口', 15);
	M_MapAddDynamicobject(70, '石门右1', '', '', '', '', '', '', 118, 192, 0, 0, 0, 0);	
	M_MapAddDynamicobject(70, '石门右1', '', '', '', '', '', '', 129, 287, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门右1', '', '', '', '', '', '', 192, 297, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门右1', '', '', '', '', '', '', 240, 313, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门右1', '', '', '', '', '', '', 66, 160, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门右1', '', '', '', '', '', '', 96, 115, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门右1', '', '', '', '', '', '', 98, 113, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门左1', '', '', '', '', '', '', 143, 301, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门左1', '', '', '', '', '', '', 146, 114, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门左1', '', '', '', '', '', '', 148, 116, 0, 0, 0, 0);

	M_MapAddDynamicobject(70, '石门左1', '', '', '', '', '', '', 184, 295, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门左1', '', '', '', '', '', '', 249, 291, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门左1', '', '', '', '', '', '', 278, 233, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门左1', '', '', '', '', '', '', 275, 230, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门左1', '', '', '', '', '', '', 61, 173, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门左1', '', '', '', '', '', '', 73, 139, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门左1', '', '', '', '', '', '', 75, 141, 0, 0, 0, 0);
	M_MapAddDynamicobject(70, '石门左1', '', '', '', '', '', '', 78, 158, 0, 0, 0, 0);
    return;
  end
end;
