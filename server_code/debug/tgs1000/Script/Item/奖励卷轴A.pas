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

  deleteitem(uSource, '奖励卷轴A', 1);
  additem(uSource, '精炼石', 30);
  additem(uSource, '三级白玉之石', 2);
  additem(uSource, '三级青玉之石', 2);
  additem(uSource, '三级蓝玉之石', 2);
  additem(uSource, '三级黑玉之石', 2);
  additem(uSource, '三级黄玉之石', 2);
  saysystem(uSource, '获得奖品：精炼石30个，三级白玉、青玉、蓝玉、黑玉、黄玉之石各2个');
end;

