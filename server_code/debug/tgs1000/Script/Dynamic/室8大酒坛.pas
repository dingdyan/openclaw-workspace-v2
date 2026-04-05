  //打开

procedure OnTurnOn(uSource, uDest: integer);
begin
  MapIceMonster('王陵3层', '室8四臂金刚', false);
  MapIceMonster('王陵3层', '室8护卫武士', false);
end;
 //复活

procedure OnTurnOff(uSource: integer);
begin
  MapIceMonster('王陵3层', '室8四臂金刚', true);
  MapIceMonster('王陵3层', '室8护卫武士', true);
end;

