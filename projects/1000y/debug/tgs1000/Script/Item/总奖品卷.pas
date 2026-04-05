{******************************************************************************
创建人:田莉
创建时间:2009.08.28
修改时间:
实现功能:
  使用此卷可以让你早日步入江湖


******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey :integer; astr :string);
begin
  if getitemspace(uSource) < 1 then
  begin
    LeftText2(uSource, '背包已满，请留出1个空位。', $001188FF);
    exit;
  end;
  deleteitem(uSource, '总奖品卷', 1);
  additem(uSource, '1号任务卷轴', 1);
  saysystem(uSource, '获得奖品：1号任务卷轴');
end;

