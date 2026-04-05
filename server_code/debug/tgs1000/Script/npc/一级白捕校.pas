{******************************************************************************
创建人:田莉
创建时间:2009.07
修改时间:2009.08.06
实现功能:
//传授无名剑法
   //已验证
        ID 99被虚似任务占用(门派管理员：领取福利)，不能再使用
       98被虚似任务占用(奖励发放员：门票任务)，不能再使用
      全局变量：1、2、3已被使用（奖励发放员），不能再使用
      个人变量：1已被使用（上线时修复元气），不能再使用
******************************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '知道剑法的奥秘吗？^^'
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
                    Menusay(uSource, '希望你早日成为一名真正的剑客。');
                    exit;
                end;

                Menusay(uSource, '去找新手接待员，他会给你指导。');
            end;
        100:                       //判断主线
            begin
                int2 := getQueststep(uSource); //取支线任务小序列号
                case int2 of
                    0..6:
                        begin
                            Menusay(uSource, '知道剑法的奥秘吗？');
                        end;
                    7:
                        begin
                            Menusay(uSource, '我现在正在练功，有话就讲，有屁快放。^^'
                                + '    <〖我是捕盗大将介绍来专程向您请教剑法的〗/@quest_100_7_1>'
                                + '^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                    8, 9:
                        begin
                            Menusay(uSource, '猪皮弄到了吗？^^'
                                + '<〖递上猪皮〗/@quest_100_9>^'
                                + '^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                    10:
                        begin
                            Menusay(uSource, '我兄弟黑捕校最近忙着结婚的事情你去看看有^'
                                + '没有什么能帮得上的忙的。^^'
                                + '    <〖那好吧，我去了〗/@Quest_100_11>^^'
                                + '^<〖返回〗/@OnMenu>'
                                + '^<〖退出〗/@exit>');
                        end;
                else Menusay(uSource, '希望你早日成为一名真正的剑客。');
                end;
            end;
    else Menusay(uSource, '希望你早日成为一名真正的剑客。');
    end;
end;

procedure quest_100_7_1(uSource, uDest:integer);
begin
    Menusay(uSource, '哦，原来这样，那我这里有把剑，你拿去给我^弄5张猪皮回来再说^^'
        + '    <〖接受〗/@Quest_100_8>^^'
        + '^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure Quest_100_8(uSource, uDest:integer);
begin
    if getitemspace(uSource) < 1 then
    begin
        Menusay(uSource, '背包已满，请留出1个空位。');
        exit;
    end;
    {
     if additem(uSource, '浪人长剑', 1) = false then
     begin
       Menusay(uSource, '发放物品失败');
       exit;
     end;
     saysystem(uSource, '获得任务奖励：浪人长剑1把');
                }
    setQueststep(uSource, 8);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 8));
end;

procedure quest_100_9(uSource, uDest:integer);
var
    i               :integer;
begin
    i := getitemquestCount(uSource, '猪皮');
    if i < 5 then
    begin
        Menusay(uSource, '我还忙着，你还是得到5张猪皮再回来找我。');
        exit;

    end else
    begin
        Menusay(uSource, '恩，儒子可教也，那我就把无名剑法的功力^传授于你。^^'
            + '    <〖谢谢〗/@Quest_100_9_1> ^^'
            + '^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
    end;
end;

procedure Quest_100_9_1(uSource, uDest:integer);
var
    Magicname       :string;
begin
    Magicname := getuserAttackMagic(uSource); //获取 攻击武功名字
    if Magicname <> '无名剑法' then
    begin
        Menusay(uSource, '我可以提升你的剑法，请使武功：无名剑法^^'
            + '        <〖好的〗/@exit>^ '
            + '^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;

    if getMagicLevel(usource, Magicname) >= 9999 then //获取武功等级
    begin
        Menusay(uSource, '抱歉!!!^^'
            + '当前使用武功：' + Magicname + '武功等级已经满级，^我无法提升^^'
            + '        <〖好的〗/@Quest_100_10_1> '
            + '^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;
    Menusay(uSource, '当前使用武功： ' + Magicname + ' 具备提升条件。^'
        + '你是否将武功经验值追加到 ' + Magicname + ' 上?^^'
        + '            <〖是〗/@tianjiamagic>'
        + '^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure tianjiamagic(uSource, uDest:integer);
var
    Magicname       :string;
    int1, int2      :integer;
begin
    Magicname := getuserAttackMagic(uSource); //获取当前攻击武功名称
    if Magicname <> '无名剑法' then
    begin
        Menusay(uSource, '我可以提升你的剑法，请使用武功：无名剑法^^'
            + '        <〖好的〗/@exit> '
            + '^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;

    int1 := getMagicExp(uSource, Magicname); //获取当前攻击武功经验值
    int2 := 1410065408 - int1;
    if int2 <= 0 then
    begin
        Menusay(uSource, '抱歉!!!^^'
            + '当前使用武功：' + Magicname + '武功等级已经满级，^我无法提升^^'
            + '        <〖好的〗/@Quest_100_10_1> '
            + '^<〖返回〗/@OnMenu>'
            + '^<〖退出〗/@exit>');
        exit;
    end;

    if AddMagicExp(uSource, Magicname, 100000000) = 0 then
    begin
        Menusay(uSource, '武功经验增加失败');
        exit;
    end;                           //给指定 武功 加经验
    saysystem(uSource, Magicname + '获得了经验');
    quest_100_10(uSource, uDest);
    Quest(uSource, uDest);
end;

procedure Quest_100_11(uSource, uDest:integer);
begin
    setQueststep(uSource, 11);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 11));
end;

procedure Quest_100_10_1(uSource, uDest:integer);
begin
    quest_100_10(uSource, uDest);
    Quest(uSource, uDest);
end;

procedure quest_100_10(uSource, uDest:integer);
begin
    delItemquest(uSource, '猪皮', 5);
    setQueststep(uSource, 10);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 10));
end;

