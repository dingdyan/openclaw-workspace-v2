{******************************************************************************
创建人:杨李
创建时间:2009.10.27
功能：接太极剑门任务
******************************************************************************}

procedure OnMenu(uSource, uDest: integer);
begin
  Menusay(uSource, '太极老人托付我帮他找些人做点事情，侠客有^'
    + '空不妨去试试!^^'
    + '    <〖 任 务 〗/@quest_menu>');
end;

procedure quest_menu(uSource, uDest: integer);
begin
  //接任务所需完成任务ID
  if getQuestNo(uSOurce) <> 5003 then
  begin
    Menusay(uSource, '我没什么可帮助你的!^^'
      + '<〖退出〗/@exit>');
    exit;
  end;
    //接任务所需境界等级
  if getEnergyLevel(uSource) < 5 then
  begin
    Menusay(uSource, '现在还不能接受我的任务!等境界达到解脱境^'
      + '以上再来找我吧^^'
      + '<〖退出〗/@exit>');
    exit;
  end;
  //接任务所需年龄
  if getage(uSource) < 3000 then
  begin
    Menusay(uSource, '现在还不能接受我的任务!等年龄达到30岁^'
      + '以上再来找我吧^^'
      + '<〖退出〗/@exit>');
    exit;
  end;
  case getQuestCurrentNo(uSource) of
    0: Menusay(uSource, '太极剑门乃是传承千年之久的门派。不久前被^'
        + '一群刺客趁门主不在偷袭剑门，使得剑门败落.^'
        + '太极公子被镇压在太极密室中。太极老人广招^'
        + '天下侠士帮助他消灭袭击剑门的刺客。侠士可^'
        + '愿意前去消灭他们？^^'
        + '<〖我愿意〗/@q5004>^^'
        + '<〖退出〗/@exit>');
    5004:
      begin
        if getQueststep(uSource) = 1 then
        begin
          Menusay(uSource, '带上20个‘赦龙组的魂魄’和10个’刺客^'
            + '的头颅‘去找太极老人吧!^^'
            + '^<〖退出〗/@exit>');
        end else
        begin
          Menusay(uSource, '重建剑门的任务就交给你了!^^'
            + '<〖退出〗/@exit>');
        end;
      end;
  else Menusay(uSource, '我没什么可帮助你的!^^'
      + '<〖退出〗/@exit>');
  end;
end;

procedure q5004(uSource, uDest: integer);
begin
  additemquest(uSource, '风兄令牌q5004s1', 1);
  setQuestCurrentNo(uSource, 5004);
  SetQuestStep(uSource, 1);
  saysystem(uSource, '任务提示：' + getQuestSubRequest(5004, 1));
  Menusay(uSource, '带上20个‘赦龙组的魂魄’和10个’刺客^'
    + '的头颅‘去找太极老人吧!^^'
    + '<〖退出〗/@exit>');
end;

