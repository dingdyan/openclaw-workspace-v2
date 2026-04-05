{******************************************************************************
创建人:杨李
创建时间:2009.10.29
实现功能: 神工之路任务
******************************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '我是追逐古代遗迹的侠客，你需要记载如何进^'
        + '阶为神工的卷轴书吗？拿20个金币来，我就送^'
        + '给你一本！^^'
        + '<〖递上20个金币〗/@Sellpaper>^^'
        + '<〖进阶神工〗/@virtueman>');
end;

procedure Sellpaper(uSource, uDest:integer);
var
    i               :integer;
begin
    i := getJobKind(uSource);
    if (i <> 1) and (i <> 2) and (i <> 3) and (i <> 4) then
    begin
        Menusay(uSource, '我的卷轴不给无业游民，学习完生产技能再来^'
            + '找我吧！^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    if getJobGrade(uSource) >= 11 then
    begin
        menusay(uSource, '你不已经是神工了吗！^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    if getJobLevel(uSource) < 9800 then
    begin
        menusay(uSource, '小子,差远了,还不够资格,继续修炼去吧,火^'
            + '候到了, 再来找老夫.^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    if getitemcount(uSource, '金币') < 20 then
    begin
        menusay(uSource, '金币不足，老夫不给没诚意的人。^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    if getitemspace(uSource) < 1 then
    begin
        menusay(uSource, '背包至少留1个空位。^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    deleteitem(uSource, '金币', 20);
    additem(uSource, '技术密笈', 1);

    menusay(uSource, ' 想升到神工,至少技术得达到一定高度,能够^'
        + '按照书上要求的去做,你的能力就能被认可.^^'
        + '<〖我知道了〗/@exit>');
    exit;
end;

procedure virtueman(uSource, uDest:integer);
var
    i               :integer;
    str             :string;
begin
    i := getjobkind(uSource);
    if (i <> 1) and (i <> 2) and (i <> 3) and (i <> 4) then
    begin
        menusay(uSource, '你还没有职业，回去学习一下生产再来找我吧^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    if getjobgrade(uSource) >= 10 then
    begin
        menusay(uSource, '你不已经是神工了吗！^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    if getEnergyLevel(uSource) < 10 then
    begin
        menusay(uSource, '境界修为不够，不能进阶神工！^^'
            + '<〖退出〗/@exit>');
    end;

    if getJobLevel(uSource) < 9800 then
    begin
        menusay(uSource, '年轻人不能好高骛远，练好生产技能再来找我^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    case i of
        1:str := '黄金钥匙';
        2:str := '乾坤日月酒';
        3:str := '太极线';
        4:str := '玻璃戒指';
    end;

    menusay(uSource, '你现在是' + getJobGradeName(uSource) + '。^'
        + '进阶神工需要：[卷轴]和[' + str + ']^'
        + '境界要求：至尊无上或者更高境界^'
        + '你确定要进阶神工吗？^^'
        + '<〖确定〗/@virtueman_OK>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure virtueman_OK(uSource, uDest:integer);
var
    i               :integer;
    str             :string;
begin
    i := getjobkind(uSource);

    if getitemcount(uSource, '技术密笈') < 1 then
    begin
        menusay(uSource, '卷轴有吗？^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    case i of
        1:str := '黄金钥匙';
        2:str := '乾坤日月酒';
        3:str := '太极线';
        4:str := '玻璃戒指';
    end;

    if getitemcount(uSource, str) < 1 then
    begin
        menusay(uSource, '你有' + str + '吗？^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    deleteitem(uSOurce, '技术密笈', 1);
    deleteitem(uSOurce, str, 1);

    SetJobLevel(uSource, 9900);
    //addJobLevelExp(uSource, 1100000000, 1100000000);
    menusay(uSource, '恭喜你，你现在是神工了^^'
        + '<〖退出〗/@exit>');
    exit;
end;

//////////////////////////////////////////

