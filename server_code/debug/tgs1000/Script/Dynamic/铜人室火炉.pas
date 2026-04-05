{*********************************************************************
创建人：何永安
创建时间：2009.12.2
创建功能：点亮四个火炉，激活怪物
**********************************************************************}

procedure OnTurnOn(uSource, uDest:integer);
var
    t1, t2, t3, t4  :INTEGER;
begin
    t1 := MapFindDynamicobject('禁止区域', '铜人室火炉1', 'dos_Openned');
    t2 := MapFindDynamicobject('禁止区域', '铜人室火炉2', 'dos_Openned');
    t3 := MapFindDynamicobject('禁止区域', '铜人室火炉3', 'dos_Openned');
    t4 := MapFindDynamicobject('禁止区域', '铜人室火炉4', 'dos_Openned');
    t1 := t1 + t2 + t3 + t4;
    saysystem(uSource, '点亮火炉个数：' + IntToStr(t1));
    if (t1 >= 4) then
    begin
        MapIceMonster('禁止区域', '禁地护卫武士', false);
        saysystem(uSource, '禁地护卫武士：闯王陵者死！');
    end;
end;

procedure OnTurnoff(uSource:integer);
begin
    MapIceMonster('禁止区域', '禁地护卫武士', true);
end;

