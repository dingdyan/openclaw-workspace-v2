{******************************************************************************
创建人:田莉
创建时间:2009.08.28
修改时间:
实现功能:
  使用此卷轴可以完成七号任务


******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey :integer; astr :string);
var
  aMagicExp, aaddMagicExp :integer;
begin
  if getitemspace(uSource) < 1 then
  begin
    LeftText2(uSource, '背包已满，请留出1个空位。', $001188FF);
    exit;
  end;
  if getMagicLevel(usource, '无名投法') < 9999 then
  begin
    aMagicExp := getMagicExp(uSource, '无名投法'); //获取当前攻击武功经验值
    aaddMagicExp := 1410065408 - aMagicExp;
    if aaddMagicExp <= 0 then _reward(uSource);
    AddMagicExp(uSource, '无名投法', aaddMagicExp); //给指定 武功 加经验
  end;
  _reward(uSource);
end;

procedure _reward(uSource :integer);
begin
  SETQuestTempArr(uSource, 1, 0);
  SETQuestTempArr(uSource, 2, 0);

  setQueststep(uSource, 30);
  saysystem(uSource, '任务提示：家传秘笈已获得，无名投法已满，' + getQuestSubRequest(100, 30));
  deleteitem(uSource, '7号任务卷轴', 1);
  additem(uSource, '8号任务卷轴', 1);
  saysystem(uSource, '获得奖品：8号任务卷轴');
end;

