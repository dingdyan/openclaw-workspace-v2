//***************************************************
//创建人：何永安
//时间：2009.10.26
//功能：
//***************************************************

procedure OnDie(uSource, uDest:integer; aRACE:integer);
begin
    //获取地图当前怪物总数
    if MapFindMonster('禁止区域', '禁地护卫武士', 'live') <= 0 then
    begin
        saysystem(uSource, '移至王的寝宫');
        Mapmove(uSource, 77, 26, 46, 0);
        exit;
    end;
    saysystem(uSource, '解决所有怪物才能移至王的寝宫');
end;

