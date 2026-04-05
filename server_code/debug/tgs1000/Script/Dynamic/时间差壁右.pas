{******************************************************************************
室2塔死亡打开室2门
******************************************************************************}
{
var
    aState          :boolean;

procedure OnUpdate(uManager, curTcik:integer);
begin
    if aState = TRUE then
    begin

        MapChangeDynamicobject('王陵3层', '时间差壁左', 'dos_Openned');
        MapChangeDynamicobject('王陵3层', '时间差壁右', 'dos_Closed');
        aState := false;
    end else
    begin
        MapChangeDynamicobject('王陵3层', '时间差壁左', 'dos_Closed');
        MapChangeDynamicobject('王陵3层', '时间差壁右', 'dos_Openned');
        aState := false;
    end;
end;

procedure OnInitial(uManager, curTcik:integer);
begin
    MapChangeDynamicobject('王陵3层', '时间差壁右', 'dos_Openned');
    MapChangeDynamicobject('王陵3层', '时间差壁左', 'dos_Closed');
    aState := TRUE;
end;

procedure OnTurnOn(uSource, uDest:integer);
begin
    MapChangeDynamicobject('王陵3层', '时间差壁左', 'dos_Openned');
end;
}
