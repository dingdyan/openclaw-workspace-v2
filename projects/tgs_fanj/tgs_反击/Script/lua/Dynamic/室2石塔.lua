--打开触发
function OnTurnOn(uSource, uDest)
  M_MapIceMonster(70, '室2四臂金刚', false);
  M_MapIceMonster(70, '室2护卫武士', false);
  M_MapboNotHItMonster(70, '室2四臂金刚', false);
  M_MapboNotHItMonster(70, '室2护卫武士', false);
  --打开室2门
  M_MapChangeDynamicobject(70, '室2门', 2);
end;

--关闭触发
function OnTurnOff(uSource)
  M_MapIceMonster(70, '室2四臂金刚', true);
  M_MapIceMonster(70, '室2护卫武士', true);
  M_MapboNotHItMonster(70, '室2四臂金刚', true);
  M_MapboNotHItMonster(70, '室2护卫武士', true);
end;

