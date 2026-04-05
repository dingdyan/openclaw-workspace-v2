var
  log = false;

const
    //初级装备所需要的荣誉值
  CON_LOW_1 = 10000;
  CON_LOW_2 = 20000;
  CON_LOW_3 = 30000;
  CON_LOW_4 = 40000;
  CON_LOW_5 = 60000;

    //高级装备所需要的荣誉值
  CON_MID_1 = 100000;
  CON_MID_2 = 150000;
  CON_MID_3 = 200000;
  CON_MID_4 = 250000;
  CON_MID_5 = 300000;

    //顶级装备所需要的荣誉值
  CON_HIGH_1 = 1000000;
  CON_HIGH_2 = 1200000;
  CON_HIGH_3 = 1400000;
  CON_HIGH_4 = 1600000;
  CON_HIGH_5 = 2000000;

    //主菜单

procedure OnMenu(uSource, uDest: integer);
begin
  menusay(uSource, '本将军奉命镇守此地，没有要紧事禀报就快快^退下。^^'
    + '    <〖领取初级荣誉装备〗/@getLowerItem>^'
    + '    <〖领取高级荣誉装备〗/@getMiddleItem>^'
    + '    <〖领取顶级荣誉装备〗/@getHighItem>^'
    + '    <〖领取称号〗/@Designation>^'
    + '    <〖 任 务 〗/@Quest>');
end;
///////////////////////////////////荣誉称号////////////////////////////////////////////////////////

procedure Designation(uSource, uDest: integer);
begin
  menusay(uSource, '当荣誉值达到一定的程度,就可以再我这领取称号!^'
    + '称号会附加不同的属性,每个角色最多可同时拥有^'
    + '十个称号。称号达到上限时可删除以前的称号来领^'
    + '取新的称号.^^'
    + '    <〖领取初级荣誉称号〗/@getDesign_1>^^'
    + '    <〖领取高级荣誉称号〗/@getDesign_2>^^'
    + '    <〖领取顶级荣誉称号〗/@getDesign_3>^^'
    + '    <〖返回〗/@OnMenu> <     〖退出〗/@exit>^');
end;

procedure getDesign_1(uSource, uDest: integer);
begin
  menusay(uSource, '请选择你要领取的称号,每个称号所需要的荣誉值不同!^^'
    + '    <〖初出江湖〗/@getLowDesign_1>^^'
    + '    <〖牛刀小试〗/@getLowDesign_2>^^'
    + '    <〖循序渐进〗/@getLowDesign_3>^^'
    + '    <〖学有所长〗/@getLowDesign_4>^^'
    + '    <〖步步为营〗/@getLowDesign_5>^^'
    + '    <〖返回〗/@Designation> <   〖退出〗/@exit>^');
end;

procedure getDesign_2(uSource, uDest: integer);
begin
  menusay(uSource, '请选择你要领取的称号,每个称号所需要的荣誉值不同!^^'
    + '    <〖奋力一搏〗/@getMidDesign_1>^^'
    + '    <〖攻其不备〗/@getMidDesign_2>^^'
    + '    <〖出奇制胜〗/@getMidDesign_3>^^'
    + '    <〖力拔千钧〗/@getMidDesign_4>^^'
    + '    <〖略有小成〗/@getMidDesign_5>^^'
    + '    <〖返回〗/@Designation> <   〖退出〗/@exit>^');
end;

procedure getDesign_3(uSource, uDest: integer);
begin
  menusay(uSource, '请选择你要领取的称号,每个称号所需要的荣誉值不同!^^'
    + '    <〖招招见血〗/@getHighDesign_1>^^'
    + '    <〖进退自如〗/@getHighDesign_2>^^'
    + '    <〖手法娴熟〗/@getHighDesign_3>^^'
    + '    <〖游刃有余〗/@getHighDesign_4>^^'
    + '    <〖力挽狂澜〗/@getHighDesign_5>^^'
    + '    <〖返回〗/@Designation> <   〖退出〗/@exit>^');
end;
///////初级称号///////

procedure getLowDesign_1(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 1, CON_LOW_1);
end;

procedure getLowDesign_2(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 2, CON_LOW_2);
end;

procedure getLowDesign_3(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 3, CON_LOW_3);
end;

procedure getLowDesign_4(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 4, CON_LOW_4);
end;

procedure getLowDesign_5(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 5, CON_LOW_5);
end;
/////////高级称号///////////

procedure getMidDesign_1(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 6, CON_MID_1);
end;

procedure getMidDesign_2(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 7, CON_MID_2);
end;

procedure getMidDesign_3(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 8, CON_MID_3);
end;

procedure getMidDesign_4(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 9, CON_MID_4);
end;

procedure getMidDesign_5(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 10, CON_MID_5);
end;
/////////顶级称号///////////

procedure getHighDesign_1(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 11, CON_HIGH_1);
end;

procedure getHighDesign_2(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 12, CON_HIGH_2);
end;

procedure getHighDesign_3(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 13, CON_HIGH_3);
end;

procedure getHighDesign_4(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 14, CON_HIGH_4);
end;

procedure getHighDesign_5(uSource, uDest: integer);
begin
  getDesignMain(uSource, uDest, 15, CON_HIGH_5);
end;
////////////////////////////

procedure getDesignMain(uSource, uDest: integer; aid, avalue: integer);
begin
  if getprestige(uSource) < avalue then
  begin
    menusay(uSource, '领取此称号需要荣誉值:' + inttostr(avalue) + '.^你现在还无法领取!^^'
      + '    <〖返回〗/@Designation>^^'
      + '    <〖退出〗/@exit>^^'
      );
    exit;
  end;
    //称号已经存在
  if DesignationCheck(uSource, aid) then
  begin
    menusay(uSource, '你已经领取了此称号,无法再次领取!^^'
      + '    <〖返回〗/@Designation>^^'
      + '    <〖退出〗/@exit>^^'
      );
    if log then worldnoticemsg('检查退出，已存在的ID：' + inttostr(aid), $00555500, $00000000);
    exit;
  end;
  if DesignationSpaceCount(uSource) < 1 then
  begin
    menusay(uSource, '获得的称号已达到上限!如果想拥有此称号,^请先删除一个!^^'
      + '    <〖返回〗/@Designation>^^'
      + '    <〖退出〗/@exit>^^'
      );
    exit;
  end;
    //增加称号
  if DesignationAdd(uSource, aid) = false then
  begin
    menusay(uSource, '领取称号失败!请重新领取!^^'
      + '    <〖返回〗/@Designation>^^'
      + '    <〖退出〗/@exit>^^');
    exit;
  end;
  menusay(uSource, '成功获得一个称号!^^'
    + '    <〖返回〗/@Designation>^^'
    + '    <〖退出〗/@exit>^^');
  if log then worldnoticemsg('获得称号成功，ID：' + inttostr(aid), $00555500, $00000000);
end;
///////////////////////////////////荣誉装备////////////////////////////////////////////////////////
 //初级装备领取菜单

procedure getLowerItem(uSource, uDest: integer);
begin
  menusay(uSource, '初级阶段可以领取的荣誉装备有: ^^'
    + '    <〖至尊护腕〗/@getLowItem_huwan>^'
    + '    <〖至尊靴〗/@getLowItem_shoe>^'
    + '    <〖至尊盔〗/@getLowItem_hat>^'
    + '    <〖至尊铠甲〗/@getLowItem_cloth>^'
    + '    <〖至尊拳套〗/@getLowItem_quan>^'
    + '    <〖至尊剑〗/@getLowItem_jian>^'
    + '    <〖至尊刀〗/@getLowItem_dao>^'
    + '    <〖至尊斧〗/@getLowItem_fu>^'
    + '    <〖至尊枪〗/@getLowItem_qiang>^'
    + '    <〖返回〗/@OnMenu>' + '    <〖退出〗/@exit>');
    { menusay(uSource, '初级阶段可以领取的荣誉装备有: ^^'
       + '    <〖侍卫护腕〗/@getLowItem_huwan><       〖侍卫靴〗/@getLowItem_shoe>^^'
       + '    <〖侍卫帽〗/@getLowItem_hat>    <       〖侍卫铠甲〗/@getLowItem_cloth>^^'
       + '    <〖侍卫拳套〗/@getLowItem_quan> <       〖侍卫利刃剑〗/@getLowItem_jian>^^'
       + '    <〖侍卫弯背刀〗/@getLowItem_dao><       〖侍卫罗刹斧〗/@getLowItem_fu>^^'
       + '    <〖侍卫的精铁枪〗/@getLowItem_qiang>^^'
       + '    <〖返回〗/@OnMenu>' + '    <〖退出〗/@exit>');  }

end;
//高级装备领取菜单

procedure getMiddleItem(uSource, uDest: integer);
begin
  menusay(uSource, '初级阶段可以领取的荣誉装备有: ^^'
    + '    <〖霸天护腕〗/@getMidItem_huwan>^'
    + '    <〖霸天靴〗/@getMidItem_shoe>^'
    + '    <〖霸天帽〗/@getMidItem_hat>^'
    + '    <〖霸天铠甲〗/@getMidItem_cloth>^'
    + '    <〖霸天铁手〗/@getMidItem_quan>^'
    + '    <〖霸天剑〗/@getMidItem_jian>^'
    + '    <〖霸天刀〗/@getMidItem_dao>^'
    + '    <〖霸天斧〗/@getMidItem_fu>^'
    + '    <〖霸天枪〗/@getMidItem_qiang>^'
    + '    <〖返回〗/@OnMenu>' + '    <〖退出〗/@exit>');
end;
//顶级装备领取菜单

procedure getHighItem(uSource, uDest: integer);
begin
  menusay(uSource, '初级阶段可以领取的荣誉装备有: ^^'
    + '    <〖王者护腕〗/@getHighItem_huwan>^'
    + '    <〖王者战靴〗/@getHighItem_shoe>^'
    + '    <〖王者斗笠〗/@getHighItem_hat>^'
    + '    <〖王者铠甲〗/@getHighItem_cloth>^'
    + '    <〖王者手套〗/@getHighItem_quan>^'
    + '    <〖王者剑〗/@getHighItem_jian>^'
    + '    <〖王者刀〗/@getHighItem_dao>^'
    + '    <〖王者斧〗/@getHighItem_fu>^'
    + '    <〖王者枪〗/@getHighItem_qiang>^'
    + '    <〖返回〗/@OnMenu>' + '    <〖退出〗/@exit>');
end;

procedure getItemMainMenu(uSource: integer; avalue: integer; aitemname: string);
var
  money: integer;
  akey: integer;
  alevel: integer;
  anumber: integer;
begin

  if getprestige(uSource) < avalue then
  begin
    menusay(uSource, '需要荣誉值 ' + inttostr(avalue) + ',你当前的荣誉值还不够^领取' + aitemname + '.继续努力吧!^^'
      + '    <〖返回〗/@OnMenu>^^'
      + '    <〖退出〗/@exit>^^');
    exit;
  end;
  if log then worldnoticemsg('当前荣誉值：' + inttostr(getprestige(uSource)), $00555500, $00000000);
  if log then worldnoticemsg('所需荣誉值：' + inttostr(avalue), $00555500, $00000000);
  money := avalue / 2;
  if money <= 5000 then money := 5000;
  if getitemcount(uSource, '钱币') < money then
  begin
    menusay(uSource, '需要钱币:' + inttostr(money) + '^筹够钱再来找我吧!^^'
      + '    <〖返回〗/@OnMenu>^^'
      + '    <〖退出〗/@exit>^^');
    exit;
  end;
  if getitemspace(uSource) < 1 then
  begin
    menusay(uSource, '背包满了,整理后再来找我吧!^^'
      + '    <〖返回〗/@OnMenu>^^'
      + '    <〖退出〗/@exit>^^');
    exit;
  end;
  deleteitem(uSource, '钱币', money);
  anumber := Random(10000);
  case anumber of
    0..5000: alevel := 1;
    5001..8000: alevel := 2;
    8001..9999: alevel := 3;
  else alevel := 1;
  end;
  additemEx(uSource, aitemname, '', alevel, 0, 0, 0, 0, 0);
  if log then worldnoticemsg('随机的数字：' + inttostr(anumber), $00555500, $00000000);
  if log then worldnoticemsg('扣除的钱币：' + inttostr(money), $00555500, $00000000);
  if log then worldnoticemsg('背包的位置：' + inttostr(akey), $00555500, $00000000);
  if log then worldnoticemsg('产生的星数：' + inttostr(alevel), $00555500, $00000000);
end;

//==========================初级兑换==================================================

procedure getLowItem_huwan(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_LOW_1, '至尊护腕');
end;

procedure getLowItem_shoe(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_LOW_2, '至尊靴');
end;

procedure getLowItem_hat(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_LOW_3, '至尊盔');
end;

procedure getLowItem_cloth(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_LOW_4, '至尊铠甲');
end;

procedure getLowItem_quan(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_LOW_5, '至尊拳套');
end;

procedure getLowItem_jian(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_LOW_5, '至尊剑');
end;

procedure getLowItem_dao(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_LOW_5, '至尊刀');
end;

procedure getLowItem_fu(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_LOW_5, '至尊斧');
end;

procedure getLowItem_qiang(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_LOW_5, '至尊枪');
end;
//====================================高级兑换=================================================

procedure getMidItem_huwan(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_MID_1, '霸天护腕');
end;

procedure getMidItem_shoe(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_MID_2, '霸天靴');
end;

procedure getMidItem_hat(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_MID_3, '霸天帽');
end;

procedure getMidItem_cloth(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_MID_4, '霸天铠甲');
end;

procedure getMidItem_quan(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_MID_5, '霸天铁手');
end;

procedure getMidItem_jian(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_MID_5, '霸天剑');
end;

procedure getMidItem_dao(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_MID_5, '霸天刀');
end;

procedure getMidItem_fu(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_MID_5, '霸天斧');
end;

procedure getMidItem_qiang(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_MID_5, '霸天枪');
end;
//=========================顶级兑换=======================================================

procedure getHighItem_huwan(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_HIGH_1, '王者护腕');
end;

procedure getHighItem_shoe(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_HIGH_2, '王者战靴');
end;

procedure getHighItem_hat(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_HIGH_3, '王者斗笠');
end;

procedure getHighItem_cloth(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_HIGH_4, '王者铠甲');
end;

procedure getHighItem_quan(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_HIGH_5, '王者手套');
end;

procedure getHighItem_jian(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_HIGH_5, '王者剑');
end;

procedure getHighItem_dao(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_HIGH_5, '王者刀');
end;

procedure getHighItem_fu(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_HIGH_5, '王者斧');
end;

procedure getHighItem_qiang(uSource, uDest: integer);
begin
  getItemMainMenu(uSource, CON_HIGH_5, '王者枪');
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
        if CurQuestStep = 23 then
        begin
          Menusay(uSource, '很高兴认识你啊，我这儿可以用荣誉兑换装备，^'
            + '需要的话随时可以找我！长城以南的成名人士你^'
            + '都拜访过了，大家对你的评价很高啊！^^'
            + '<〖我还得努力〗/@q4950_j5000>^^'
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

procedure q4950_j5000(uSource, uDest: integer);
var
  i: integer;
begin
  i := getprestige(uSource);
  setprestige(uSource, i + 20);
  saysystem(uSource, '获得任务奖励：荣誉20点');
  setquestNo(uSource, 4950);
  setquestCurrentNo(uSource, 0);
  setQuestStep(uSOurce, 0);
  saysystem(uSource, '任务提示：' + getQuestSubRequest(5000, 0));
  Menusay(uSOurce, '好了，长城以南的有名人士你都拜访过了，有^'
    + '空去老板娘那看看吧，她好像需要帮助！^^'
    + '<〖返回〗/@OnMenu>^^'
    + '<〖退出〗/@exit>');

end;

