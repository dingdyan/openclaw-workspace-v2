{******************************************************************************
创建人:田莉
创建时间:2009.07
修改时间:2009.08.05
实现功能:
  满活力情况下实现玩家回城

   //已验证
******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey:integer; astr:string);
var
    int1, int2      :integer;
begin
    int1 := getMaxLife(uSource);   //获取最大活力
    int2 := getCurLife(uSource);   //获取当前活力
    //活力不足
    if int2 < int1 then
    begin
        saysystem(uSource, '你活力不够，不能回到了长城以南。');
        exit;
    end;
    deleteitem(uSource, '买卖回城卷', 1);
    Mapmove(uSource, 1, 500, 500, 0); //移动到指定的位置
    saysystem(uSource, '你回到了长城以南。');
end;

