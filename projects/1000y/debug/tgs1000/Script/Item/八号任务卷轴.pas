{******************************************************************************
创建人:田莉
创建时间:2009.08.28
修改时间:
实现功能:
  使用此卷轴可以完成八号任务

******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey:integer; astr:string);
var
    name            :string;
begin
    if getitemspace(uSource) < 1 then
    begin
        LeftText2(uSource, '背包已满，请留出1个空位。', $001188FF);
        exit;
    end;
    Name := getname(uSource);      //返回完家姓名
    topmsg('恭喜【' + Name + '】正式步入江湖', $00FF80FF);

    setQuestNo(uSource, 100);
    setQuestCurrentNo(uSource, 101);
    setQueststep(uSource, 0);
    saysystem(uSource, '提示：进入长城以南' + getQuestSubRequest(101, 0));

    Mapmove(uSource, 1, 524, 474, 0);
    deleteitem(uSource, '8号任务卷轴', 1);
    additem(uSource, '奖品卷', 1);
    saysystem(uSource, '获得奖品：奖品卷');
end;

