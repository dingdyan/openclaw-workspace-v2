//*************************************************************
//创建人：
//时间：2009.10.28
//功能：
//*************************************************************

procedure OnMenu(uSource, uDest: integer);
begin
  menusay(uSource, '专业裁缝 梅花夫人 需要帮助吗？^^'
    + '    <〖成为裁缝〗/@designer>^'
    + '    <〖转职为裁缝〗/@reqchange>^'
    + '    <〖职业进阶〗/@jobLevel>^'
    + '    <〖出售图纸〗/@buy>^'
    + '    <〖什么是裁剪术〗/@jobhelp>^'
    + '    <〖 任 务 〗/@Quest>^');
end;

procedure Quest(uSource, uDest: integer);
var
  ComQuestId, CurQuestId, CurQuestStep: integer;
begin
  ComQuestId := GetQuestNo(uSOurce);
  if ComQuestId > 4900 then
  begin
    Menusay(uSOurce, '别来烦我，没看见我正忙着吗？^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>');
    exit;
  end;
  CurQuestId := GetQuestCurrentNo(uSource);
  case CurQuestId of
    4950:
      begin
        CurQuestStep := GetQuestStep(uSource);
        if CurQuestStep = 21 then
        begin
          Menusay(uSource, '很高兴认识你啊，我这儿不仅收购出售各种裁^'
            + '缝制造的物品，还可以学习裁缝技术，需要的^'
            + '话随时可以找我！既然你来拜访我，那我就送^'
            + '你点做衣服需要的物品吧^^'
            + '<〖谢谢〗/@q4950_j22>^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        end else
        begin
          Menusay(uSOurce, '你都拜访了吗？^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        end;

      end;
  else
    begin
      Menusay(uSOurce, '别来烦我，没看见我正忙着吗？^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');
    end;
  end;

end;

procedure q4950_j22(uSource, uDest: integer);
var
  aname, notice: string;
  acount: integer;
begin
  if getItemSpace(uSource) < 2 then
  begin
    Menusay(uSource, '背包空位不足，请留出2个位置！^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>');
    exit;
  end;

  setQuestStep(uSOurce, 22);
  notice := getQuestSubRequest(4950, 22);
  saysystem(uSource, '任务提示：' + notice);
  if getQuestSubItem(4950, 21, 0, aname, acount) = false then exit;
  additem(uSource, aname, acount);

  if getQuestSubItem(4950, 21, 1, aname, acount) = false then exit;
  additem(uSource, aname, acount);
  saysystem(uSource, '获得任务奖励：冷却水石:1，青铜:1');
  Menusay(uSOurce, '快去' + notice + '^^'
    + '<〖返回〗/@OnMenu>^^'
    + '<〖退出〗/@exit>');

end;

procedure jobLevel(uSource, uDest: integer);
var
  i, j, NdLevel, level: integer;
  str: string;
begin
    //判断是否为裁缝
  if getJobKind(uSource) <> 3 then
  begin
    Menusay(uSource, '您不是裁缝,不能在我这里选择进阶!^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>');
    exit;
  end;

  i := getJobGrade(uSource);
  j := i + 1;
    //判断等级
  if i = 10 then
  begin
    Menusay(uSource, '你不已经是神工了吗！别将力气消耗在^'
      + '这儿，回去制造神级物品去吧^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>');
    exit;
  end;

  if i = 9 then
  begin
    Menusay(uSource, '我现在已经帮助不了你了,想要进阶神工去找^'
      + '龙师傅吧!^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>');
    exit;
  end;

  i := i * 20000;
  case j of
    2: str := '造化境';
    3: str := '玄妙境';
    4: str := '生死境';
    5: str := '解脱境';
    6: str := '无为境';
    7: str := '神话境';
    8: str := '无上武念';
    9: str := '天人合一';
    10: str := '至尊无上';
  end;
  level := getJobGrade(uSource);
  case level of
    1: NdLevel := 19;
    2: NdLevel := 29;
    3: NdLevel := 39;
    4: NdLevel := 49;
    5: NdLevel := 59;
    6: NdLevel := 69;
    7: NdLevel := 79;
    8: NdLevel := 89;
  end;

  menusay(uSource, '只有不断进阶，才能最终走向成功之路!^'
    + '你现在是裁缝（' + getJobGradeName(uSource) + '）^'
    + '进阶需要[钱币]：' + IntToStr(i) + '个^'
    + '境界要求：' + str + '^'
    + '职业等级要求：' + inttostr(NdLevel) + '.00^'
    + '你确定进阶吗？^^'
    + '<〖确定〗/@jobLevel_OK>^^'
    + '<〖返回〗/@OnMenu>^^'
    + '<〖退出〗/@exit>');
end;

procedure jobLevel_OK(uSource, uDest: integer);
var
  i, j, k, level, ex: integer;
  ax: string;
begin
    //获取当前等级
  i := getJobGrade(uSource);
  case i of
    1: k := 1900;
    2: k := 2900;
    3: k := 3900;
    4: k := 4900;
    5: k := 5900;
    6: k := 6900;
    7: k := 7900;
    8: k := 8900;
  end;

  level := getJobLevel(uSource);
  if (level < k) then
  begin
    ex := level mod 100;
    if ex = 0 then
    begin
      ax := '.00';
    end else
      ax := '.' + inttostr(ex);
    Menusay(uSource, '进阶失败，你当前的职业等级为：' + inttostr(level div 100) + ax + '^'
      + '进阶到下一阶需要职业等级为：' + inttostr(k div 100) + '.00' + '^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>^^');
    exit;
  end;

    //判断境界等级和钱币
  if (getEnergyLevel(uSource) < i + 1) then
  begin
    Menusay(uSource, '进阶失败，当前境界还没能达到进阶下一阶的要^'
      + '求!^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>');
    exit;
  end;
  if (getitemcount(uSource, '钱币') < i * 20000) then
  begin
    Menusay(uSource, '进阶失败，携带的钱币不够！^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>');
    exit;
  end;

  deleteitem(uSource, '钱币', i * 20000);
  SetJobLevel(uSource, k + 100);
  Menusay(uSource, '恭喜你，你现在是裁缝（' + getJobGradeName(uSource) + '）了!^^'
    + '<〖返回〗/@OnMenu>^^'
    + '<〖退出〗/@exit>');
end;

procedure designer(uSource, uDest: integer);
var
  i: integer;
begin
  i := getjobKind(uSource);
    //判断是否有职业
  if (i = 1) or (i = 2) or (i = 4) then
  begin
    menusay(uSource, '您已经有职业了^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>');
    exit;
  end;
    //判断是否是裁缝
  if i = 3 then
  begin
    menusay(uSource, '您已经是裁缝了^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>');
    exit;
  end;

  menusay(uSource, '成为裁缝需要[钱币]30000个，你确定^'
    + '要当裁缝吗^^'
    + '<〖确定〗/@designer_OK>^^'
    + '<〖返回〗/@OnMenu>^^'
    + '<〖退出〗/@exit>');
end;

procedure designer_OK(uSource, uDest: integer);
begin
  if getitemcount(uSource, '钱币') < 30000 then
  begin
    menusay(uSource, '你身上携带的钱币不足^^'
      + '<〖退出〗/@exit>^^');
    exit;
  end;

  deleteitem(uSource, '钱币', 30000);
  setjobKind(uSource, 3);
  menusay(uSource, '恭喜你，你现在是裁缝了^^'
    + '<〖返回〗/@OnMenu>^^'
    + '<〖退出〗/@exit>');
end;

procedure reqchange(uSource, uDest: integer);
var
  i: integer;
begin
  i := getJobKind(uSource);
  if i = 3 then
  begin
    menusay(uSource, '你本来就是裁缝^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>');
    exit;
  end;

  menusay(uSource, '转职为裁缝需要[钱币]50000个^'
    + '技能等级还原到1.00级^'
    + '你确定转职吗?^^'
    + '<〖确定〗/@change>^^'
    + '<〖返回〗/@OnMenu>^^'
    + '<〖退出〗/@exit>');
end;

procedure jobhelp(uSource, uDest: integer);
begin
  menusay(uSource, '裁剪术是制造衣物的技术。^^'
    + '裁缝用皮和决定硬度的石灰质和决定其特性的金^'
    + '属，还有将它们融合到一块儿的水石制造衣物。^^'
    + '<〖返回〗/@OnMenu>^^'
    + '<〖退出〗/@exit>');
end;

procedure change(uSource, uDest: integer);
begin
  if getitemcount(uSource, '钱币') < 50000 then
  begin
    menusay(uSource, '你身上携带的钱币不足^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>');
    exit;
  end;

  deleteitem(uSource, '钱币', 50000);
  setJobKind(uSource, 3);
  menusay(uSource, '恭喜你，你现在是裁缝了^^'
    + '<〖返回〗/@OnMenu>^^'
    + '<〖退出〗/@exit>');
end;

