{******************************************************************************
创建人:田莉
创建时间:2009.07
修改时间:2009.08.05
实现功能:
  点击玫瑰脱色药将红玫瑰变成白玫瑰

   //已验证
******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey :integer; astr :string);
begin
  if getitemcount(uSource, '红玫瑰') < 1 then
  begin
    saysystem(uSource, '你背包里没有红玫瑰，不能使用此物品。');
    exit;
  end;

  if (getitemspace(uSource) < 1) and (getitemcount(uSource, '白玫瑰') < 1) then
  begin
    saysystem(uSource, '物品栏已满，请留出1个空位。');
    exit;
  end;
  deleteitem(uSource, '红玫瑰', 1);
  deleteitem(uSource, '玫瑰脱色药', 1);
  additem(uSource, '白玫瑰', 1);
end;

