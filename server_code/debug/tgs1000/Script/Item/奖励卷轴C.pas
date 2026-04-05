{******************************************************************************
创建人:田莉
创建时间:2009.08.28
修改时间:
实现功能:
  使用后将获得礼品


******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey :integer; astr :string);
begin
  if getitemspace(uSource) < 6 then
  begin
    LeftText2(uSource, '背包空位不足，请留出6个空位。', $001188FF);
    exit;
  end;

  deleteitem(uSource, '奖励卷轴C', 1);
  additem(uSource, '精炼石', 10);
  additem(uSource, '二级白玉之石', 5);
  additem(uSource, '二级青玉之石', 5);
  additem(uSource, '二级蓝玉之石', 5);
  additem(uSource, '二级黑玉之石', 5);
  additem(uSource, '二级黄玉之石', 5);
  saysystem(uSource, '获得奖品：精炼石10个，二级白玉、青玉、蓝玉、黑玉、黄玉之石各5个');
end;

