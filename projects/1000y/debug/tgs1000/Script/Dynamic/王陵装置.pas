{******************************************************************************
王陵装置
******************************************************************************}

var
  ncount: integer = 0;

procedure OnRegen(uSource: integer);
begin
  ncount := 0;
end;

procedure OnTurnOn(uSource, uDest: integer);
begin
  if ncount < 8 then
  begin
    inc(ncount);
  end;
  if ncount = 1 then
  begin

    MapSendChatMsg('王陵3层', '<雨中客>_有人侵入王陵', $00222222);
    MapSendChatMsg('王陵3层', '<雨中客>_启动机关装置', $00222222);

    MapAdddynamicobject('王陵3层', '滚动桥A', '', '', '', '', '', '', '248', '138', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '滚动桥B', '', '', '', '', '', '', '230', '116', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '滚动狮子A', '', '', '', '', '', '', '255', '141', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '滚动狮子A', '', '', '', '', '', '', '247', '132', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '滚动狮子B', '', '', '', '', '', '', '228', '111', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '滚动狮子B', '', '', '', '', '', '', '237', '119', 0, 0, 0);

    exit;
  end;
  if ncount = 3 then
  begin
    MapSendChatMsg('王陵3层', '<雨中客>_损失比预计的要惨重', $00222222);
    MapSendChatMsg('王陵3层', '<雨中客>_封锁秘密通道', 2);
    MapAdddynamicobject('王陵3层', '迷宫门', '', '', '', '', '', '', '281', '83', 0, 0, 0);
    exit;
  end;
  if ncount = 5 then
  begin
    MapSendChatMsg('王陵3层', '<雨中客>_再也支撑不住了', $00222222);
    MapSendChatMsg('王陵3层', '<雨中客>_封锁所有的出入口', $00222222);

    MapAdddynamicobject('王陵3层', '石门右1', '', '', '', '', '', '', '118', '192', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门右1', '', '', '', '', '', '', '129', '287', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门右1', '', '', '', '', '', '', '192', '297', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门右1', '', '', '', '', '', '', '240', '313', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门右1', '', '', '', '', '', '', '66', '160', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门右1', '', '', '', '', '', '', '96', '115', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门右1', '', '', '', '', '', '', '98', '113', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门左1', '', '', '', '', '', '', '143', '301', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门左1', '', '', '', '', '', '', '146', '114', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门左1', '', '', '', '', '', '', '148', '116', 0, 0, 0);

    MapAdddynamicobject('王陵3层', '石门左1', '', '', '', '', '', '', '184', '295', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门左1', '', '', '', '', '', '', '249', '291', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门左1', '', '', '', '', '', '', '278', '233', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门左1', '', '', '', '', '', '', '275', '230', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门左1', '', '', '', '', '', '', '61', '173', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门左1', '', '', '', '', '', '', '73', '139', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门左1', '', '', '', '', '', '', '75', '141', 0, 0, 0);
    MapAdddynamicobject('王陵3层', '石门左1', '', '', '', '', '', '', '78', '158', 0, 0, 0);
    exit;
  end;
end;

