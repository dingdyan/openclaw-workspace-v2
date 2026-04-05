{******************************************************************************
室2塔死亡打开室2门
******************************************************************************}

   //打开

procedure OnTurnOn(uSource, uDest: integer);
begin
  MapIceMonster('王陵3层', '室3四臂金刚', false);
  MapIceMonster('王陵3层', '室3护卫武士', false);
  //打开室2门
  MapChangeDynamicobject('王陵3层', '室3墙壁', 'dos_Openning');

end;
 //复活

procedure OnTurnOff(uSource: integer);
begin
  MapIceMonster('王陵3层', '室3四臂金刚', true);
  MapIceMonster('王陵3层', '室3护卫武士', true);
end;

