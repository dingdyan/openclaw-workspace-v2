procedure OnMenu(uSource, uDest: integer);
begin
  menusay(uSource, '免费负责摆摊和兑换经验!^^'
    + '<〖摆摊〗/@baitan>^^'
    + '<〖兑换经验〗/@ClickIn>^^'
    + '<〖任务〗/@Quest>^^');
end;

procedure Quest(uSOurce, uDest: integer);
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
        if CurQuestStep = 19 then
        begin
          Menusay(uSource, '很高兴认识你啊，我这儿提供摊位供你出售和^'
            + '收购物品，而且不收手续费.需要的话随时可以^'
            + '找我!既然你来拜访我,那我就送你点小礼物吧^^'
            + '<〖谢谢〗/@q4950_j20>^^'
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

procedure q4950_j20(uSource, uDest: integer);
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

  setQuestStep(uSOurce, 20);
  notice := getQuestSubRequest(4950, 20);
  saysystem(uSource, '任务提示：' + notice);

  if getQuestSubItem(4950, 19, 0, aname, acount) = false then exit;
  additem(uSource, aname, acount);

  if getQuestSubItem(4950, 19, 1, aname, acount) = false then exit;
  additem(uSource, aname, acount);
  saysystem(uSource, '获得任务奖励：钱币:1000,天桃:20');
  Menusay(uSOurce, '快去' + notice + '^^'
    + '<〖返回〗/@OnMenu>^^'
    + '<〖退出〗/@exit>');

end;

procedure ClickIn(uSource, uDest: integer);
begin
  menusay(uSource, '请放入已满级的经验珠子,我会帮你转换为武功^经验增加在你当前所使用的武功上!^^'
    + '     <〖确定〗/@ChangeExp>^^'
    + '     <〖返回〗/@OnMenu>^^'
    + '     <〖退出〗/@exit>');
  ItemInputWindowsOpen(uSource, 0, '经验珠子', '放入经验珠子');
  setItemInputWindowsKey(uSource, 0, -1);
end;

procedure baitan(uSource, uDest: integer);
begin
  if getServerTempVar(0) <> 0 then
  begin
    menusay(uSource, '现在正在攻城不能摆摊。^^'
      + '   <〖知道了〗/@exit>');
    exit;
  end;
  Booth_edit_open(uSource);
end;

procedure ChangeExp(uSource, uDest: integer);
var
  aitemKey: integer;
  aMagicName: string;
  addMagicLevel: integer;
  addExp: integer;
begin
  aitemkey := getItemInputWindowsKey(uSource, 0);
    // 检查是否有经验珠子
  if aitemkey = -1 then
  begin
    menusay(uSource, '经验珠子都没有换什么?^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>^^');
    exit;
  end;
    //检查经验珠子是否满级
  if getitemSpecialLevel(uSource, aitemkey) < 9999 then
  begin
    menusay(uSource, '把经验珠子的等级练满再来找我吧!^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>^^');
    exit;
  end;
    //查看当前使用的攻击武功是否满级
  aMagicName := getuserAttackMagic(uSource);
  if aMagicName = '' then
  begin
    menusay(uSource, '请选择攻击类武功再来兑换!^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>^^');
    exit;
  end;
  if getMagicLevel(uSource, aMagicName) >= 9999 then
  begin
    menusay(uSource, '当前武功经验已满,无法继续增加!^^'
      + '<〖返回〗/@OnMenu>^^'
      + '<〖退出〗/@exit>^^');
    exit;
  end;
  addExp := 350000000;
    //武功经验
  if addExp > 1085138172 - getMagicExp(uSource, aMagicName) then
    addexp := 1085138172 - getMagicExp(uSource, aMagicName);
  deleteitemkey(uSource, aitemkey, 1);
  AddMagicExp(uSource, aMagicName, addExp);
  menusay(uSource, '将经验增加在' + aMagicName + '上成功!^^'
    + '<〖返回〗/@OnMenu>^^'
    + '<〖退出〗/@exit>^^');
end;

