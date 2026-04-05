{******************************************************************************
创建人:田莉
创建时间:2009.07
修改时间:2009.08.06
实现功能:
//传授无名刀法
   //已验证
       ID 99被虚似任务占用(门派管理员：领取福利)，不能再使用
       98被虚似任务占用(奖励发放员：门票任务)，不能再使用
      全局变量：1、2、3已被使用（奖励发放员），不能再使用
      个人变量：1已被使用（上线时修复元气），不能再使用
******************************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '我正忙着操办婚礼的事情呢！^^'
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
                int2 := getQueststep(uSource); //取支线任务小序列号
                case int2 of
                    0..10:
                        begin
                            Menusay(uSource, '我正忙着操办婚礼的事情呢！'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                    11:
                        begin
                            Menusay(uSource, '唉，最近累死我了^^'
                                + '    <〖我就是专程来帮你的忙的〗/@quest_100_11_1> ^^'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                    12, 13:
                        begin
                            Menusay(uSource, '鹿茸都弄齐了吗？^^'
                                + '<〖递上鹿茸〗/@quest_100_13>^'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');

                        end;
                    14:
                        begin
                            Menusay(uSource, '等一下，牛俊最近遇到一些麻烦，连我的喜酒^'
                                + '都不能来喝，你快去帮帮他^^'
                                + '    <〖好的，我去了〗/@Quest_100_15>'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                else Menusay(uSource, '举办婚礼的时候我会联系你的。'
                        + '^^<〖返回〗/@OnMenu>'
                        + '^<〖退出〗/@exit>');
                end;
            end;
    else Menusay(uSource, '举办婚礼的时候我会联系你的。'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
    end;
end;

procedure quest_100_11_1(uSource, uDest:integer);
begin
    Menusay(uSource, '最近筹办婚礼遇到点麻烦，需要一些鹿茸，你^'
        + '去帮我弄点来，为了你尽快能回来，我给你一^把我珍藏多年的浪人长刀^^'
        + '    <〖我这就去办〗/@quest_100_12>'
        + '^^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure quest_100_12(uSource, uDest:integer);
begin
    if getitemspace(uSource) < 1 then
    begin
        Menusay(uSource, '背包已满，请留出1个空位。'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;

    {   if additem(uSource, '浪人长刀', 1) = false then
       begin
           Menusay(uSource, '发放物品失败');
           exit;
       end;
       saysystem(uSource, '获得任务奖励：浪人长刀1把');  }

    setQueststep(uSource, 12);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 12));
end;

procedure quest_100_13(uSource, uDest:integer);
var
    i               :integer;
begin
    i := getitemQuestCount(uSOurce, '鹿茸');
    if i < 5 then
    begin
        Menusay(uSource, '你怎么还没得到5个鹿茸呀？'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end else
    begin
        Menusay(uSource, '哈哈，小伙子真不错，你就留在这里喝我的喜^'
            + '酒吧，等我婚礼一完，我把我毕生所学无名刀^法传授于你。^^'
            + '    <〖我还需要煅炼一下，以后再来拜访您〗/@quest_100_13_1> ^^'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
    end;

end;

procedure quest_100_13_1(uSource, uDest:integer);
begin
    Menusay(uSource, '既然这样，我现在就传授你武功，让你行走江湖^能有一技防身^^'
        + '    <〖好的，那我有空再来拜访你〗/@quest_100_13_2> ^^'
        + '^^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure quest_100_13_2(uSource, uDest:integer);
var
    Magicname       :string;
begin
    Magicname := getuserAttackMagic(uSource); //获取 攻击武功名字

    if Magicname <> '无名刀法' then
    begin
        Menusay(uSource, '我可以提升你的刀法，请使武功：无名刀法^^'
            + '        <〖好的〗/@exit> '
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;

    if getMagicLevel(usource, Magicname) >= 9999 then //获取武功等级
    begin
        Menusay(uSource, '抱歉!!!^^'
            + '当前使用武功：' + Magicname + '武功等级已经满级，^我无法提升^^'
            + '        <〖好的〗/@Quest_100_14_1> '
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
    Magicname := getuserAttackMagic(uSource); //获取当前攻击武功名称

    if Magicname <> '无名刀法' then
    begin
        Menusay(uSource, '我可以提升你的刀法，请使武功：无名刀法^^'
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
            + '当前使用武功：' + Magicname + '武功等级已经满级，^我无法提升^^'
            + '        <〖好的〗/@Quest_100_14_1> '
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;

    if AddMagicExp(uSource, Magicname, 100000000) = 0 then
    begin
        Menusay(uSource, '武功经验增加失败');
        exit;
    end;
    saysystem(uSource, Magicname + '获得了经验');
    quest_100_14(uSource, uDest);
    Quest(uSource, uDest);
end;

procedure Quest_100_15(uSource, uDest:integer);
begin
    delitemQuest(uSource, '鹿茸', 5);
    setQueststep(uSource, 15);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 15));
end;

procedure Quest_100_14_1(uSource, uDest:integer);
begin
    quest_100_14(uSource, uDest);
    Quest(uSource, uDest);
end;

procedure quest_100_14(uSource, uDest:integer);
begin

    setQueststep(uSource, 14);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 14));
end;

