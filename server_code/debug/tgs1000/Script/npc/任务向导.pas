procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '欢迎来到千年之前的精武时代!^^'
        + '<〖任务〗/@Quest>');

end;

procedure Quest(uSource, uDest:integer);
var
    comQuestId, CurQuestId, CurQuestStep:integer;
begin
    comQuestId := GetQuestNo(uSOurce);
    if comQuestId >= 4950 then
    begin
        Menusay(uSource, '查看任务信息请用快捷键Alt+R^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    CurQuestId := GEtQuestCurrentNo(uSource);
    case CurQuestId of
        0:
            begin
                Menusay(uSOurce, '欢迎来到千年之前的精武时代!我们为你准备了^'
                    + '具有丰厚奖励的新手任务.看你武功平平的想在^'
                    + '江湖混不是那么容易的,现在就为你引见一些成^'
                    + '名人士，你愿意去拜访他们吗？^^'
                    + '<〖愿意〗/@q4950_1>^^'
                    + '<〖没空〗/@exit>');
            end;
        4950:
            begin
                CurQuestStep := GetQuestStep(uSource);
                case CurQuestStep of
                    0:
                        begin
                            Menusay(uSOurce, '欢迎来到千年之前的精武时代!我们为你准备了^'
                                + '具有丰厚奖励的新手任务.看你武功平平的想在^'
                                + '江湖混不是那么容易的,现在就为你引见一些成^'
                                + '名人士，你愿意去拜访他们吗？^^'
                                + '<〖愿意〗/@q4950_1>^^'
                                + '<〖没空〗/@exit>');
                        end;
                    1:
                        begin
                            Menusay(uSOurce, getQuestSubRequest(4950, 1) + '^^'
                                + '<〖退出〗/@exit>');
                        end;
                else
                    begin
                        Menusay(uSource, '快去拜访一下长城以南的名人侠士吧！^^'
                            + '<〖退出〗/@exit>');
                    end;
                end;

            end;
    else
        begin
            Menusay(uSource, '查看任务信息请用快捷键Alt+R^^'
                + '<〖退出〗/@exit>');
        end;
    end;

end;

procedure q4950_1(uSource, uDest:integer);
var
    aqid, akey, acount, astep, aqsubid, i:integer;
    aname, notice   :string;
    j               :integer;
begin
    if getItemspace(uSource) < 12 then
    begin
        Menusay(uSOurce, '背包空位不足，请留出12个空位！^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    setQuestCurrentNo(uSource, 4950);
    setQuestStep(uSource, 1);
    notice := getQuestSubRequest(4950, 1);
    saysystem(uSource, '任务提示：' + notice);

    //10件奖励放在主任务，其余两件放在步骤奖励
    getQuestMainItem(4950, 0, aname, acount); //新手护腕
    addItemEx(uSource, aname, '新手向导', 2, 5, 4, 322, 0, 0);
    getQuestMainItem(4950, 1, aname, acount); //新手鞋
    addItemEx(uSource, aname, '新手向导', 2, 5, 4, 322, 0, 0);
    getQuestMainItem(4950, 2, aname, acount); //新手道袍
    addItemEx(uSource, aname, '新手向导', 2, 5, 4, 322, 0, 0);
    getQuestMainItem(4950, 3, aname, acount); //新手斗笠
    addItemEx(uSource, aname, '新手向导', 2, 5, 4, 322, 0, 0);
    getQuestMainItem(4950, 4, aname, acount); //新手手套
    addItemEx(uSource, aname, '新手向导', 2, 5, 2, 121, 0, 0);
    getQuestMainItem(4950, 5, aname, acount); //新手长剑
    addItemEx(uSource, aname, '新手向导', 2, 5, 2, 121, 0, 0);
    getQuestMainItem(4950, 6, aname, acount); //新手长刀
    addItemEx(uSource, aname, '新手向导', 2, 5, 2, 121, 0, 0);
    getQuestMainItem(4950, 7, aname, acount); //新手铁槌
    addItemEx(uSource, aname, '新手向导', 2, 5, 2, 121, 0, 0);
    getQuestMainItem(4950, 8, aname, acount); //新手长枪
    addItemEx(uSource, aname, '新手向导', 2, 5, 2, 121, 0, 0);
    getQuestMainItem(4950, 9, aname, acount); //新手木弓
    addItemEx(uSource, aname, '新手向导', 2, 5, 2, 121, 0, 0);

    getQuestSubItem(4950, 0, 0, aname, acount); //新手斗甲
    addItemEx(uSource, aname, '新手向导', 2, 5, 2, 121, 0, 0);
    getQuestSubItem(4950, 0, 1, aname, acount);
    additem(uSource, aname, acount);
    Menusay(uSOurce, notice + '^^'
        + '<〖退出〗/@exit>');
end;

