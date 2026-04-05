{******************************************************************************
创建人:李小利
创建时间:2009.11.6
实现功能:
    合成装备
******************************************************************************}
var
    log             = false;

procedure OnMenu(uSource, uDest:integer);
begin
    menusay(uSource, '本人研究合成之术已有数十载，不知道侠士^'
        + '想合成什么品级的装备？^^'
        //+ '    <〖合成装备〗/@hechengMenu>^^'
        //  + '    <〖合成5品装备〗/@hecheng_5>^^'
        //  + '    <〖合成10品装备〗/@hecheng_10>^^'
        //+ '    <〖合成装备介绍〗/@introduction>^^'
        + '    <〖 任 务 〗/@Quest>^^'
        //+ '    <〖合成11品装备〗/@hecheng_11>^^'
        );
end;

procedure Quest(uSOurce, uDest:integer);
var
    ComQuestId, CurQuestId, CurQuestStep:integer;
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
                if CurQuestStep = 10 then
                begin
                    Menusay(uSource, '很高兴认识你啊，我这儿可以合成各种装备，^'
                        + '需要的话随时可以找我！既然你来拜访我，那^'
                        + '我就送你点小礼物吧^^'
                        + '<〖谢谢〗/@q4950_j11>^^'
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

procedure q4950_j11(uSource, uDest:integer);
var
    aname, notice   :string;
    acount          :integer;
begin
    if getItemSpace(uSource) < 2 then
    begin
        Menusay(uSource, '背包空位不足，请留出2个位置！^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    setQuestStep(uSOurce, 11);
    notice := getQuestSubRequest(4950, 11);
    saysystem(uSource, '任务提示：' + notice);
    if getQuestSubItem(4950, 10, 0, aname, acount) = false then exit;
    additem(uSource, aname, acount);

    if getQuestSubItem(4950, 10, 1, aname, acount) = false then exit;
    additem(uSource, aname, acount);
    saysystem(uSource, '获得任务奖励：钱币:1000,天桃:20');

    Menusay(uSOurce, '快去' + notice + '^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');

end;

procedure introduction(uSource, uDest:integer);
begin
    menusay(uSource, '装备合成系统介绍：^'
        + '将5件不同品级的装备合成一件更高品阶的装备.新^'
        + '生成的装备类型取决于合成菜单处的第一个位置.^'
        + '例如将一把刀放置在第一个位置,那么新生成的物品^'
        + '则为刀.放剑则为剑,以此类推.^^'
        + '目前可以合成的装备有:^'
        + '〖 5  品〗:需要从主装备开始到最后一个副装备^'
        + '分别放置：1品,2品,3品,4品,5品装备各一件^'
        + '〖10 品〗:需要从主装备开始到最后一个副装备^'
        + '分别放置:6品,7品,8品,9品,10品装备各一件^'
        + '注意顺序不能放置错误!^'
        + '     <〖返回〗/@OnMenu>^^'
        );
end;

{procedure hecheng_5(uSource, uDest: integer);
begin
  hechengMenu('1品', '2品', '3品', '4品', uSource, uDest);
end;

procedure hecheng_10(uSource, uDest: integer);
begin
  hechengMenu('6品', '7品', '8品', '9品', uSource, uDest);
end;
 }

procedure hechengMenu(uSource, uDest:integer);
begin
    menusay(uSource,
        '请放入5件不同品级的装备各一件,合成后的装备^'
        + '类型与第一个格子的物品类型相同!^'
        + '1,2,3,4,5品装备合成5品装备^'
        + '6,7,8,9,10品装备合成10品装备^'
        + '荣誉装备,修炼装备不能参与合成!^^'
        + '     <〖合成〗/@hecheng>   <〖返回〗/@OnMenu>    <〖退出〗/@exit>');
    ItemInputWindowsOpen(uSource, 0, '主装备', '请放入装备');
    ItemInputWindowsOpen(uSource, 1, '副装备', '请放入装备');
    ItemInputWindowsOpen(uSource, 2, '副装备', '请放入装备');
    ItemInputWindowsOpen(uSource, 3, '副装备', '请放入装备');
    ItemInputWindowsOpen(uSource, 4, '副装备', '请放入装备');
    setItemInputWindowsKey(uSource, 0, -1);
    setItemInputWindowsKey(uSource, 1, -1);
    setItemInputWindowsKey(uSource, 2, -1);
    setItemInputWindowsKey(uSource, 3, -1);
    setItemInputWindowsKey(uSource, 4, -1);
end;

procedure hecheng(uSource, uDest:integer);
var
    aItemKey1, aItemKey2, aItemKey3, aItemKey4, aItemKey5:integer;
    addname         :string;
    aGrade, akind, aHitType, aWearPos:integer;
    aGrade1, aStarLevel:integer;
    aneedMoney      :integer;
begin
    //1.获取并检查key是否合法
    //获取1-4窗口中的物品在背包中的位置
    aItemKey1 := getItemInputWindowsKey(uSource, 0);
    aItemKey2 := getItemInputWindowsKey(uSource, 1);
    aItemKey3 := getItemInputWindowsKey(uSource, 2);
    aItemKey4 := getItemInputWindowsKey(uSource, 3);
    aItemKey5 := getItemInputWindowsKey(uSource, 4);
    if (aItemKey1 = -1) or (aItemKey2 = -1) or (aItemKey3 = -1)
        or (aItemKey4 = -1) or (aItemKey5 = -1) then
    begin
        menusay(uSource, '请依次把装备放入1号到5号位置，缺一不可!^^'
            + '     <〖返回〗/@hechengMenu>^^'
            + '     <〖退出〗/@exit>^^');
        exit;
    end;
    akind := getitemKind(uSource, aItemKey1);
    if akind <> 6 then
    begin
        menusay(uSource, '第一个格子物品不是装备或者没有物品,不能合成！^请重新放入装备^^'
            + '     <〖返回〗/@hechengMenu>^^'
            + '     <〖退出〗/@exit>^^');
        exit;
    end;
    case getitemSpecialKind(uSource, aItemKey1) of
        3:
            begin
                menusay(uSource, '第一个格子物品错误,荣誉装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
        5:
            begin
                menusay(uSource, '第一个格子物品错误,修炼装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
        6:
            begin
                menusay(uSource, '第一个格子物品错误,任务装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
    end;

    aGrade := getitemGrade(uSource, aItemKey1);
    if (aGrade <> 1) and (aGrade <> 6) then
    begin
        menusay(uSource, '第一个格子物品品级错误,不能合成！请重新放入装备^^'
            + '     <〖返回〗/@hechengMenu>^^'
            + '     <〖退出〗/@exit>^^');
        exit;
    end;
    aHitType := getitemHitType(uSource, aItemKey1);
    aWearPos := getitemWearArr(uSource, aItemKey1);
    addname := FindAddItemName(aGrade, aHitType, aWearPos);
    if addname = '' then
    begin
        //不能合成物品
        menusay(uSource, '不能合成！请重新放入装备^^'
            + '     <〖返回〗/@hechengMenu>^^'
            + '     <〖退出〗/@exit>^^');
        exit;
    end;
    aGrade1 := aGrade;
    inc(aGrade1);
    akind := getitemKind(uSource, aItemKey2);
    if akind <> 6 then
    begin
        menusay(uSource, '第二个格子不是装备或者没有物品,不能合成！^'
            + '请重新放入装备^^'
            + '     <〖返回〗/@hechengMenu>^^'
            + '     <〖退出〗/@exit>^^');
        exit;
    end;
    aGrade := getitemGrade(uSource, aItemKey2);
    if aGrade <> aGrade1 then
    begin
        menusay(uSource, '第二个格子物品品级错误,不能合成！请重新^'
            + '放入装备!^^'
            + '     <〖返回〗/@hechengMenu>^^'
            + '     <〖退出〗/@exit>^^');
        exit;
    end;
    case getitemSpecialKind(uSource, aItemKey2) of
        3:
            begin
                menusay(uSource, '第二个格子物品错误,荣誉装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
        5:
            begin
                menusay(uSource, '第二个格子物品错误,修炼装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
        6:
            begin
                menusay(uSource, '第二个格子物品错误,任务装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
    end;
    inc(aGrade1);
    akind := getitemKind(uSource, aItemKey3);
    if akind <> 6 then
    begin
        menusay(uSource, '第三个格子物品不是装备或者没有物品,不能合成！^'
            + '请重新放入装备!^^'
            + '     <〖返回〗/@hechengMenu>^^'
            + '     <〖退出〗/@exit>');
        exit;
    end;
    aGrade := getitemGrade(uSource, aItemKey3);
    if aGrade <> aGrade1 then
    begin
        menusay(uSource, '第三个格子物品品级错误,不能合成！请重新^'
            + '放入装备^^'
            + '     <〖返回〗/@hechengMenu>^^'
            + '     <〖退出〗/@exit>');
        exit;
    end;
    case getitemSpecialKind(uSource, aItemKey3) of
        3:
            begin
                menusay(uSource, '第三个格子物品错误,荣誉装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
        5:
            begin
                menusay(uSource, '第三个格子物品错误,修炼装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
        6:
            begin
                menusay(uSource, '第三个格子物品错误,任务装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
    end;
    inc(aGrade1);
    akind := getitemKind(uSource, aItemKey4);
    if akind <> 6 then
    begin
        menusay(uSource, '第四个格子物品不是装备或者没有物品,不能合成！^请重新放入装备^^'
            + '     <〖返回〗/@hechengMenu>^^'
            + '     <〖退出〗/@exit>');
        exit;
    end;
    aGrade := getitemGrade(uSource, aItemKey4);
    if aGrade <> aGrade1 then
    begin
        menusay(uSource, '第四个格子物品品级错误,不能合成！请重新^'
            + '放入装备^^'
            + '     <〖返回〗/@hechengMenu>^^'
            + '     <〖退出〗/@exit>');
        exit;
    end;
    case getitemSpecialKind(uSource, aItemKey4) of
        3:
            begin
                menusay(uSource, '第四个格子物品错误,荣誉装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
        5:
            begin
                menusay(uSource, '第四个格子物品错误,修炼装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
        6:
            begin
                menusay(uSource, '第四个格子物品错误,任务装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
    end;
    inc(aGrade1);
    akind := getitemKind(uSource, aItemKey5);
    if akind <> 6 then
    begin
        menusay(uSource, '第五个格子物品不是装备或者没有物品,不能合成！^请重新放入装备^^'
            + '     <〖返回〗/@hechengMenu>^^'
            + '     <〖退出〗/@exit>');
        exit;
    end;
    aGrade := getitemGrade(uSource, aItemKey5);
    if aGrade <> aGrade1 then
    begin
        menusay(uSource, '第五个格子物品品级错误,不能合成！请重新^'
            + '放入装备^^'
            + '     <〖返回〗/@hechengMenu>^^'
            + '     <〖退出〗/@exit>');
        exit;
    end;
    case getitemSpecialKind(uSource, aItemKey5) of
        3:
            begin
                menusay(uSource, '第五个格子物品错误,荣誉装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
        5:
            begin
                menusay(uSource, '第五个格子物品错误,修炼装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
        6:
            begin
                menusay(uSource, '第五个格子物品错误,任务装备不能参与合成！^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>^^');
                exit;
            end;
    end;
    case aGrade of
        5:aneedMoney := 50000;
        10:aneedMoney := 100000;
    else aneedMoney := 50000;
    end;

    if getitemcount(uSource, '钱币') < aneedMoney then
    begin
        case aGrade of
            5:menusay(uSource, '金钱不足,无法合成!^'
                    + '本次合成需要钱币:50000^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>');
            10:menusay(uSource, '金钱不足,无法合成!^^'
                    + '本次合成需要钱币:100000^^'
                    + '     <〖返回〗/@hechengMenu>^^'
                    + '     <〖退出〗/@exit>');
        end;
        exit;
    end;
    if getitemspace(uSource) < 1 then
    begin
        menusay(uSource, '背包已满,无法合成^^'
            + '     <〖退出〗/@exit>');
        exit;
    end;
    //扣东西
    deleteitem(uSource, '钱币', aneedMoney);
    deleteItemKey(uSource, aItemKey1, 1);
    deleteItemKey(uSource, aItemKey2, 1);
    deleteItemKey(uSource, aItemKey3, 1);
    deleteItemKey(uSource, aItemKey4, 1);
    deleteItemKey(uSource, aItemKey5, 1);

    //发 东西
    case Random(10000) of
        0..5000:aStarLevel := 1;
        5001..8000:aStarLevel := 2;
        8001..9999:aStarLevel := 3;
    else aStarLevel := 1;
    end;
    addItemEx(uSource, addname, '', aStarLevel, 0, 0, 0, -1, 0);
    case aGrade of
        5:menusay(uSource, '恭喜你合成成功!^'
                + '本次合成共消耗物品:1品,2品,3品,4^'
                + '品,5品装备各一件.钱币:50000^^'
                + '     <〖继续〗/@hechengMenu>^^'
                + '     <〖退出〗/@exit>^^');
        10:menusay(uSource, '恭喜你合成成功!^'
                + '本次合成共消耗物品:6品,7品,8品,9^'
                + '品,10品装备各一件.钱币:100000^^'
                + '     <〖继续〗/@hechengMenu>^^'
                + '     <〖退出〗/@exit>^^');
    end;
end;

function FindAddItemName(aGrade, aHitType, aWearPos:integer):string;
begin
    result := '';

    case aWearPos of
        1:case aGrade of
                1:result := '无为护腕';
                // 5: result := 'dsf';
                6:result := '至尊护腕';
            end;
        3:case aGrade of
                1:result := '无为靴';
                //5: result := 'dsf';
                6:result := '至尊战靴';
            end;

        6:case aGrade of
                1:result := '无为战袍';
                //5: result := 'dsf';
                6:result := '至尊裟';
            end;
        8:case aGrade of
                1:result := '无为帽';
                //5: result := 'dsf';
                6:result := '至尊帽';
            end;
        9:case aHitType of
                //手套
                0:case aGrade of
                        1:result := '无为手套';
                        //5: result := 'dsf';
                        6:result := '至尊手套';
                    end;
                //剑
                1:case aGrade of
                        1:result := '无为剑';
                        // 5: result := 'dsf';
                        6:result := '至尊剑';
                    end;
                //刀
                2:case aGrade of
                        1:result := '无为刀';
                        // 5: result := 'dsf';
                        6:result := '至尊刀';
                    end;
                //斧
                3:case aGrade of
                        1:result := '无为斧';
                        // 5: result := 'dsf';
                        6:result := '至尊斧';
                    end;
                //枪
                4:case aGrade of
                        1:result := '无为枪';
                        // 5: result := 'dsf';
                        6:result := '至尊枪';
                    end;
            end;
    end;

end;

