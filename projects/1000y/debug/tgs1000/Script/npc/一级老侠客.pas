{******************************************************************************
创建人:田莉
创建时间:2009.07
修改时间:2009.08.06
实现功能:
//将玩家传出村
   //已验证
       ID 99被虚似任务占用(门派管理员：领取福利)，不能再使用
       98被虚似任务占用(奖励发放员：门票任务)，不能再使用
      全局变量：1、2、3已被使用（奖励发放员），不能再使用
      个人变量：1已被使用（上线时修复元气），不能再使用
******************************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '你想步入江湖就来找我吧。^^'
        + '<〖任务〗/@quest>');
end;

procedure quest(uSource, uDest:integer);
var
    int1, int2, int3:integer;
begin
    int1 := getQuestCurrentNo(uSource);
    case int1 of
        //没有接受100号任务
        0:
            begin
                int2 := getQuestNo(uSource);
                case int2 of
                    0:
                        begin
                            Menusay(uSource, '去找新手接待员，他会给你指导。'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                    100:
                        begin
                            Menusay(uSource, '那我就送你出村，你初入江湖，老板娘你一定^'
                                + '要去拜访。^^'
                                + '<〖好的，我记住了〗/@quest_101_0>'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                else Menusay(uSource, '现在，我没有什么可帮助你的了'
                        + '^^<〖返回〗/@OnMenu>'
                        + '^<〖退出〗/@exit>');
                end;
            end;
        100:                       //判断主线
            begin
                int3 := getQueststep(uSource);
                case int3 of
                    31:
                        begin
                            Menusay(uSource, '你就是村里传闻中的那位少侠吗？^^'
                                + '    <〖对，正是本人〗/@quest_100_31_1>^^'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                    32, 33:
                        begin
                            Menusay(uSource, '四种怪物都歼灭了吗？^^'
                                + '<〖递上歼灭证据〗/@quest_100_33>'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                else Menusay(uSource, '现在，我没有什么可帮助你的了！'
                        + '^^<〖返回〗/@OnMenu>'
                        + '^<〖退出〗/@exit>');
                end;
            end;
    else Menusay(uSource, '现在，我没有什么可帮助你的了！'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
    end;
end;

procedure quest_100_31_1(uSource, uDest:integer);
begin
    Menusay(uSource, '你如果想步入江湖，那就必须接受我老侠客的试炼^^'
        + '    <〖接受〗/@quest_100_32>^^'
        + '^^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure quest_100_32(uSource, uDest:integer);
begin
    setQueststep(uSource, 32);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 32));
end;

procedure quest_100_33(uSource, uDest:integer);
var
    i1, i2, i3, i4  :integer;
begin
    i1 := getItemQuestCount(uSource, '老虎皮一');
    i2 := getItemQuestCount(uSource, '毒蝎角');
    i3 := getItemQuestCount(uSource, '熊胆');
    i4 := getItemQuestCount(uSource, '黑怪首级');
    if (i1 < 1) or (i2 < 1) or (i3 < 1) or (i4 < 1) then
    begin
        Menusay(uSource, '把怪都杀完了再来找我'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end else
    begin
        Menusay(uSource, '看来你还是有做侠客的潜质，^^'
            + '    <〖谢谢夸奖〗/@quest_100_33_1>^^'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
    end;
end;

procedure quest_100_33_1(uSource, uDest:integer);
begin
    Menusay(uSource, '单击操作界面中间的圆框打开境界，会对你的^攻击能力有所提升。^^'
        + '<〖知道了〗/@quest_100>'
        + '^^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;
//完成100号任务

procedure quest_100(uSource, uDest:integer);
begin
    setQuestNo(uSource, 100);
    setQuestCurrentNo(uSource, 0);
    setQueststep(uSource, 0);
    saysystem(uSource, '提示：新手任务完成');
    DelItemQuestId(uSource, 100);
    Quest(uSource, uDest);
end;

procedure quest_101_0(uSource, uDest:integer);
var
    name            :string;
begin
    Name := getname(uSource);      //返回玩家姓名
    topmsg('恭喜【' + Name + '】正式步入江湖', $00FFFF00);
    saysystem(uSource, '提示：进入长城以南' + getQuestSubRequest(5000, 0));
    MapMove(uSource, 1, 524, 474, 10);
end;

