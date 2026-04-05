{******************************************************************************
创建人:田莉
创建时间:2009.07
修改时间:2009.08.06
实现功能:
    100：传授无名拳法
   //已验证
       ID 99被虚似任务占用(门派管理员：领取福利)，不能再使用
       98被虚似任务占用(奖励发放员：门票任务)，不能再使用
      全局变量：1、2、3已被使用（奖励发放员），不能再使用
      个人变量：1已被使用（上线时修复元气），不能再使用
******************************************************************************}

procedure OnMenu(uSource, uDest:integer); //npc主菜单列表
begin
    Menusay(uSource, '最近村里有小偷你可要保管好物品啊！^^'
        + '<〖任务〗/@quest>');
end;

procedure quest(uSource, uDest:integer);
var
    int1, int2, i   :integer;
begin
    int1 := getQuestCurrentNo(uSource); //获取当前任务ID
    case int1 of
        //没有接受100号任务
        0:
            begin
                //已经做完100号任务
                if getQuestNo(uSource) >= 100 then //已完成的任务
                begin
                    Menusay(uSource, '现在村里总算安全了，不过我还得严防警惕。'
                        + '^^<〖返回〗/@OnMenu>'
                        + '^<〖退出〗/@exit>');
                    exit;
                end;
                //未完成100号任务
                Menusay(uSource, '去找新手接待员，他会给你指导。'
                    + '^^<〖返回〗/@OnMenu>'
                    + '^<〖退出〗/@exit>');
            end;
        100:                       //判断主线
            begin
                //获取主线任务100的步骤
                int2 := getQueststep(uSource);
                case int2 of
                    0..2:Menusay(uSource, '最近村里有小偷你可要保管好物品啊！');

                    3:Menusay(uSource, '你也是药王介绍来帮我的吗？^^'
                            + '    <〖是的〗/@quest_100_3_1> ^^'
                            + '^^<〖返回〗/@OnMenu>'
                            + '^<〖退出〗/@exit>');

                    4, 5:
                        begin
                            Menusay(uSource, '我交给你的任务完成了吗？^^'
                                + '<〖递上狗骨头〗/@quest_100_4>'
                                + '^^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');

                        end;
                    6:Menusay(uSource, '听说白捕校的无名剑法已经达到炉火纯青的地^'
                            + '步，如果你对剑法有兴趣可以去请教他。^^'
                            + '    <〖好的〗/@Quest_100_7>'
                            + '^^<〖返回〗/@OnMenu>'
                            + '^<〖退出〗/@exit>');

                else Menusay(uSource, '现在村里总算安全了，不过我还得严防警惕。'
                        + '^^<〖返回〗/@OnMenu>'
                        + '^<〖退出〗/@exit>');
                end;
            end;
    else Menusay(uSource, '现在村里总算安全了，不过我还得严防警惕。'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
    end;
end;

procedure quest_100_4(uSource, uDest:integer);
var
    i               :integer;
begin
    i := getItemQuestCount(uSource, '狗骨头一');
    if i < 5 then
    begin
        Menusay(uSource, '任务完成了再来找我！^^'
            + '^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
    end else
    begin
        //奖励
        Menusay(uSource, '你真是个勇敢的年轻人，这么快就回来了，看^'
            + '来药王没有看错你。^^'
            + '    <〖一般一般〗/@Quest_100_5_1> ^^'
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');

    end;
end;

procedure quest_100_3_1(uSource, uDest:integer);
begin
    Menusay(uSource, '唉，小兄弟，我看你仪表堂堂还是先行回家，^'
        + '我的忙可不是那么容易帮得上的^^'
        + '    <〖没事，我试试〗/@quest_100_3_2>^^'
        + '^^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure quest_100_3_2(uSource, uDest:integer);
begin
    Menusay(uSource, '那你就去帮我把房子周围的野狗杀五只来，不^'
        + '过野狗很凶猛，我这里有一个浪人手套，戴上^'
        + '去收拾它们吧^^'
        + '    <〖好的〗/@Quest_100_4>'
        + '^^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;
//接受 任务100 步骤4

procedure Quest_100_4(uSource, uDest:integer);
begin
    { if getitemspace(uSource) < 1 then
     begin
       Menusay(uSource, '背包已满，请留出1个空位。');
       exit;
     end;

     if additem(uSource, '浪人手套', 1) = false then
     begin
       Menusay(uSource, '发放物品失败');
       exit;
     end;
     saysystem(uSource, '获得任务奖励：浪人手套1个');  }
     //设置任务临时变量

    setQueststep(uSource, 4);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 4));
end;

procedure Quest_100_5_1(uSource, uDest:integer);
begin
    Menusay(uSource, '我也没有什么好给你的，我将无名拳法的功力^'
        + '传授给你。^^'
        + '    <〖非常感谢〗/@Quest_100_5_2>'
        + '^^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure Quest_100_5_2(uSource, uDest:integer);
var
    Magicname       :string;
begin
    Magicname := getuserAttackMagic(uSource); //获取当前攻击武功名字
    if Magicname <> '无名拳法' then
    begin
        Menusay(uSource, '我可以提升你的拳法，请使武功：无名拳法^^'
            + '        <〖好的〗/@exit> '
            + '^^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;
    //武功等级已满
    if getMagicLevel(usource, Magicname) >= 9999 then
    begin
        Menusay(uSource, '抱歉!!!^^'
            + '当前使用武功：' + Magicname + '武功等级已经满级，^我无法提升^^'
            + '        <〖好的〗/@Quest_100_6_1> '
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
    if Magicname <> '无名拳法' then
    begin
        Menusay(uSource, '我可以提升你的拳法，请使用武功：无名拳法^^'
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
            + '        <〖好的〗/@Quest_100_6_1> '
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
    end;                           //给指定 武功 加经验
    saysystem(uSource, Magicname + '获得了经验');
    quest_100_6(uSource, uDest);
    Quest(uSource, uDest);
end;

procedure Quest_100_6_1(uSource, uDest:integer);
begin

    quest_100_6(uSource, uDest);
    Quest(uSource, uDest);
end;
//接受 任务100 步骤6

procedure quest_100_6(uSource, uDest:integer);
begin
    DelItemQuest(uSource, '狗骨头一', 5);
    setQueststep(uSource, 6);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 6));
end;
//接受 任务100 步骤7

procedure Quest_100_7(uSource, uDest:integer);
begin
    setQueststep(uSource, 7);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 7));
end;

