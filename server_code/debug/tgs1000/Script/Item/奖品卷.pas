{******************************************************************************
创建人:田莉
创建时间:2009.08.18
修改时间:2009.08.28
实现功能:
  使用后可以随机得到一套装备


******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey :integer; astr :string);
var
  aitemname1, aitemname2, aitemname3, aitemname4 :string;
  sex_name :string;
  randomcount :integer;
begin
  case Random(300) of
    0..99 :aitemname1 := '钢铁手套';
    100..199 :aitemname1 := '交锋剑';
  else aitemname1 := '翔龙刀';
  end;
  randomcount := 0;
  randomcount := Random(3) + 1;
  aitemname1 := aitemname1 + inttostr(randomcount);

  sex_name := '';
  case getsex(uSource) of
    1 :sex_name := '男子';
    2 :sex_name := '女子';
  end;
  case Random(300) of
    0..99 :aitemname2 := sex_name + '虎皮';
    100..199 :aitemname2 := sex_name + '白金铠甲';
  else aitemname2 := sex_name + '墨铁战斗服';
  end;

  randomcount := Random(3) + 1;
  aitemname2 := aitemname2 + inttostr(randomcount);

  case Random(300) of
    0..99 :aitemname3 := sex_name + '铁制头盔1';
    100..199 :aitemname3 := sex_name + '铁制头盔2';
  else aitemname3 := sex_name + '铁制头盔3';
  end;
  case Random(300) of
    0..99 :aitemname4 := sex_name + '烈火靴1';
    100..199 :aitemname4 := sex_name + '烈火靴2';
  else aitemname4 := sex_name + '烈火靴3';
  end;
  if getitemspace(uSource) < 4 then
  begin
    LeftText2(uSource, '背包空位不足，请留出4个空位。', $001188FF);
    exit;
  end;
  deleteitem(uSource, '奖品卷', 1);
  additem(uSource, aitemname1, 1);
  additem(uSource, aitemname2, 1);
  additem(uSource, aitemname3, 1);
  additem(uSource, aitemname4, 1);
  saysystem(uSource, '获得奖品：武器、衣服、头盔、鞋子各一件');
end;

