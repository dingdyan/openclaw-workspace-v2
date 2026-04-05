{******************************************************************************
创建人:杨李
创建时间:2009.07
修改时间:2009.08.05
实现功能:
  当 '九尾狐变身’死亡  删除 '九尾狐变身' 增加'九尾狐酒母

   //已验证
修改人：何永安
修改时间：2009.11.15
修改功能：主线任务千年封印
******************************************************************************}

procedure OnDie(uSource, uDest:integer; aRACE:integer);
begin
    MapDelmonster('长城以南', '九尾狐变身');
    if MapFindNPC('长城以南', '九尾狐酒母', 'all') > 0 then
    begin
        Mapdelnpc('长城以南', '九尾狐酒母');
    end;
    MapAddnpc('长城以南', '九尾狐酒母', 127, 328, 1, 4, '', 1, 0, TRUE);
end;

procedure OnDragItem(uUser, uDest, aUserHaveItemKey:integer); //物品拖到怪物身上触发
var
    maxlife, curlife:integer;
    itemname        :string;
begin
    itemname := getitemname(uUser, aUserHaveItemKey);
    if itemname = '封魔符q5001s2' then
    begin
        maxlife := getMaxLife(uDest);
        curlife := getCurLife(uDest);
        if curlife <= (maxlife div 3) then
        begin
            ObjectKill(uUser, uDest);
            DelItemQuestID(uUser, 5001);
            AddItemQuest(uUser, '封印符q5001s2', 1);
            deleteitem(uUser, '封魔符q5001s2', 1);
        end;
    end;
end;

