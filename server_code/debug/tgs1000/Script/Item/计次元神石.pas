{******************************************************************************
创建人:何永安
创建时间:2009.10.17
修改时间:
实现功能:
  创建一个元神

******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey:integer; astr:string);
begin
    deleteitem(uSource, '计次元神石', 1);
    if MonsterCreate(uSource, 'X计次元神') = false then
    begin
        saysystem(uSource, '获得元神失败');
    end;
end;

