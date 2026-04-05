{******************************************************************************
创建人:田莉
创建时间:2009.09.24
修改时间:
实现功能:
  在精武奖励发放员那里获得的国庆物品


******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey :integer; astr :string);
begin
  //检查背包空位
  if getitemspace(uSource) < 1 then
  begin
    LeftText2(uSource, '背包空位不足，请留出1个空位。', $001188FF);
    exit;
  end;
  //删除国庆大礼包
  if deleteitem(uSource, '国庆大礼包', 1) = false then
  begin
    LeftText2(uSource, '对不起，回收物品失败。', $001188FF);
    exit;
  end;
  //添加宝箱
  if additem(uSource, '宝箱', 10) = false then
  begin
    LeftText2(uSource, '对不起，发放物品失败。', $001188FF);
    exit;
  end;

  saysystem(uSource, '获得奖励物品：宝箱10个');
end;

