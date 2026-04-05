{******************************************************************************
创建人:田莉
创建时间:2009.07
修改时间:2009.08.06
实现功能:
   引导新、老玩家进入游戏
   //传授无名槌法

   //已验证
        ID 99被虚似任务占用(门派管理员：领取福利)，不能再使用
       98被虚似任务占用(奖励发放员：门票任务)，不能再使用
      全局变量：1、2、3已被使用（奖励发放员），不能再使用
      个人变量：1已被使用（上线时修复元气），不能再使用
******************************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '年轻人，快来帮帮我。^^'
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
                    15:
                        begin
                            Menusay(uSource, '年轻人，快来帮帮我，我还要赶着去黑捕校那^'
                                + '儿喝喜酒^^'
                                + '<〖有事儿您说话〗/@quest_100_15_1>^'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                    16, 17:
                        begin
                            Menusay(uSource, '犀牛都除掉了吗？^^'
                                + '<〖递上犀牛角〗/@quest_100_17>'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                    17:
                        begin
                            Menusay(uSource, '太感谢了，我赶着去喝喜酒，我也没有什么可^'
                                + '以给你的，如果你不嫌弃，我将修炼无名槌法^'
                                + '的秘诀告诉你^^'
                                + '<〖好的〗/@quest_100_17_1>^'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                    18:
                        begin
                            Menusay(uSource, '唉呀有个事情，黑捕校结婚的事情我搞忘了通^知梅花夫人，麻烦你帮我跑一趟^^'
                                + '<〖好的〗/@quest_100_19>^^'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                else Menusay(uSource, '现在，我没有什么可帮助你的了!'
                        + '^^<〖返回〗/@OnMenu>'
                        + '^<〖退出〗/@exit>');
                end;
            end;
    else Menusay(uSource, '现在，我没有什么可帮助你的了!'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
    end;
end;

procedure quest_100_15_1(uSource, uDest:integer);
begin
    Menusay(uSource, '我一路走来，在这里被犀牛拦路多日，请帮我^'
        + '开出一条路来，不过犀牛很凶猛,最好在打怪^的时候使用无名强身。^^'
        + '<〖没问题，包在我身上〗/@quest_100_16>^'
        + '^^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');

end;

procedure quest_100_16(uSource, uDest:integer);
begin
    if getitemspace(uSource) < 1 then
    begin
        Menusay(uSource, '背包已满，请留出1个空位。'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;
    { if additem(uSource, '浪人铁槌', 1) = false then
     begin
       Menusay(uSource, '发放物品失败');
       exit;
     end;
     saysystem(uSource, '获得任务奖励：浪人铁槌1把');
     }
    setQueststep(uSource, 16);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 16));
end;

procedure quest_100_17(uSource, uDest:integer);
var
    i               :integer;
begin
    i := getItemQuestCount(uSource, '犀牛角');
    if i < 10 then
    begin
        Menusay(uSource, '先把拦路的犀牛都消灭了再说！'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end else
    begin
        Menusay(uSource, '太感谢了，我赶着去喝喜酒，我也没有什么可^'
            + '以给你的，如果你不嫌弃，我将修炼无名槌法^'
            + '的秘诀告诉你^^'
            + '<〖好的〗/@quest_100_17_1>^'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
    end;
end;

procedure quest_100_17_1(uSource, uDest:integer);
var
    Magicname       :string;
begin
    Magicname := getuserAttackMagic(uSource); //获取 攻击武功名字
    if Magicname <> '无名槌法' then
    begin
        Menusay(uSource, '我可以提升你的槌法，请使用武功：无名槌法^^'
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
            + '我无法提升^^'
            + '        <〖好的〗/@quest_100_18_1> '
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;

    Menusay(uSource, '当前使用武功： ' + Magicname + ' 具备提升条件.^你是否将武功经验值追加到 ' + Magicname + ' 上?^^'
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
    if Magicname <> '无名槌法' then
    begin
        Menusay(uSource, '我可以提升你的槌法，请使用武功：无名槌法^^'
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
            + '我无法提升^^'
            + '        <〖好的〗/@quest_100_18_1> '
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
    saysystem(uSource, Magicname + '获得了经验');
    quest_100_18(uSource, uDest);
    Quest(uSource, uDest);
end;

procedure quest_100_19(uSource, uDest:integer);
begin
    if getitemspace(uSource) < 1 then
    begin
        Menusay(uSource, '背包已满，请留出1个空位。'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;

    if additem(uSource, '请帖一', 1) = false then
    begin
        Menusay(uSource, '发放物品失败'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;
    delitemquest(uSource, '犀牛角', 10);
    setQueststep(uSource, 19);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 19));
end;

procedure quest_100_18_1(uSource, uDest:integer);
begin

    quest_100_18(uSource, uDest);
    Quest(uSource, uDest);
end;

procedure quest_100_18(uSource, uDest:integer);
begin

    setQueststep(uSource, 18);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 18));
end;

