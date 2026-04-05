{******************************************************************************
创建人:田莉
创建时间:2009.07
修改时间:2009.08.06
实现功能:
   引导新、老玩家进入游戏
    //传授无名枪术
   //已验证
       ID 99被虚似任务占用(门派管理员：领取福利)，不能再使用
       98被虚似任务占用(奖励发放员：门票任务)，不能再使用
      全局变量：1、2、3已被使用（奖励发放员），不能再使用
      个人变量：1已被使用（上线时修复元气），不能再使用
******************************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '我正忙呢。^^'
        + '<〖任务〗/@quest>');
end;

procedure quest(uSource, uDest:integer);
var
    int1, int2      :integer;
begin
    int1 := getQuestCurrentNo(uSource);
    case int1 of
        //没有接受100号任务
        0:
            begin
                if getQuestNo(uSource) >= 100 then //已完成的任务
                begin
                    Menusay(uSource, '现在，我没有什么可帮助你的了'
                        + '^^<〖返回〗/@OnMenu>'
                        + '^<〖退出〗/@exit>');
                    exit;
                end;

                Menusay(uSource, '去找新手接待员，他会给你指导。'
                    + '^^<〖返回〗/@OnMenu>'
                    + '^<〖退出〗/@exit>');
            end;
        100:                       //判断主线
            begin
                int2 := getQueststep(uSource);
                case int2 of
                    19:
                        begin
                            Menusay(uSource, '非常感谢你来通知我黑捕校结婚的事情，但是^'
                                + '一时之间，我也没有准备礼物，就麻烦你帮我^'
                                + '带几只野牛回来^^'
                                + '<〖好的〗/@quest_100_20>^^'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                    20, 21:
                        begin
                            MenuSay(uSource, '牛皮带回来了吗？^^'
                                + '<〖递上牛皮〗/@quest_100_21>'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                    22:
                        begin
                            Menusay(uSource, '枪术武功已经传授给你了,我可用这些野牛肉^'
                                + '给黑捕校做点牛肉干去，但是牛美叫我办的事^'
                                + '情我就不能去了，你去帮我一下，快去找牛美。^^'
                                + '<〖好的〗/@quest_100_23>^^'
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

procedure quest_100_20(uSource, uDest:integer);
begin
    if getitemQuestcount(uSource, '请帖一') < 1 then
    begin
        Menusay(uSource, '我的请帖呢？'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;

    if getitemspace(uSource) < 1 then
    begin
        Menusay(uSource, '背包已满，请留出1个空位。'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;

    if delItemQuest(uSource, '请帖一', 1) = false then
    begin
        Menusay(uSource, '回收物品失败'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;
    {if additem(uSource, '浪人长枪', 1) = false then
    begin
      Menusay(uSource, '发放物品失败');
      exit;
    end;
    saysystem(uSource, '获得任务奖励：浪人长枪1把');
            }

    setQueststep(uSource, 20);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 20));
end;

procedure quest_100_21(uSource, uDest:integer);
var
    i               :integer;
begin
    i := GetitemQuestCount(uSource, '牛皮');
    if i < 10 then
    begin
        Menusay(uSource, '我交给你的任务没完成，回来干嘛？^^'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end else
    begin
        Menusay(uSource, '太好了，我把我的枪法传授于你，也许对你会^'
            + '有些帮助。^^'
            + '<〖好的〗/@quest_100_21_1>^^'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');

    end;
end;

procedure quest_100_21_1(uSource, uDest:integer);
var
    Magicname       :string;
begin
    Magicname := getuserAttackMagic(uSource); //获取 攻击武功名字
    if Magicname <> '无名枪术' then
    begin
        Menusay(uSource, '我可以提升你的枪法，请使用武功：无名枪法。^^'
            + '        <〖好的〗/@exit> '
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;
    //武功等级已满
    if getMagicLevel(usource, Magicname) >= 9999 then
    begin
        Menusay(uSource, '抱歉!!!^^'
            + '当前使用武功： ' + Magicname + ' 武功等级已经满级，^^'
            + '我无法提升。^^'
            + '        <〖好的〗/@quest_100_22_1> '
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;
    Menusay(uSource, '当前使用武功： ' + Magicname + ' 具备提升条件。^'
        + '你是否将武功经验值追加到 ' + Magicname + ' 上?^^'
        + '            <〖是〗/@tianjiamagic>'
        + '^^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure tianjiamagic(uSource, uDest:integer);
var
    Magicname       :string;
    int1, int2      :integer;
begin
    Magicname := getuserAttackMagic(uSource);
    if Magicname <> '无名枪术' then
    begin
        Menusay(uSource, '我可以提升你的枪法，请使用武功：无名枪法^^'
            + '        <〖好的〗/@exit> '
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;

    int1 := getMagicExp(uSource, Magicname); //获取当前攻击武功经验值
    int2 := 1410065408 - int1;
    if int2 <= 0 then
    begin
        Menusay(uSource, '抱歉!!!^^'
            + '当前使用武功： ' + Magicname + ' 武功等级已经满级，^^'
            + '我无法提升。^^'
            + '        <〖好的〗/@quest_100_22_1> '
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;
    if AddMagicExp(uSource, Magicname, 100000000) = 0 then
    begin
        Menusay(uSource, '武功经验增加失败'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;
    saysystem(uSource, Magicname + '获得了经验'
        + '^^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
    quest_100_22(uSource, uDest);
    Quest(uSource, uDest);
end;

procedure quest_100_23(uSource, uDest:integer);
begin
    setQueststep(uSource, 23);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 23));
end;

procedure quest_100_22_1(uSource, uDest:integer);
begin
    quest_100_22(uSource, uDest);
    Quest(uSource, uDest);
end;

procedure quest_100_22(uSource, uDest:integer);
begin
    DelitemQuest(uSource, '牛皮', 10);
    setQueststep(uSource, 22);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 22));
end;

