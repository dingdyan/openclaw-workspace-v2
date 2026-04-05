procedure OnMenu(uSource, uDest:integer);
begin
    menusay(uSource, '我这儿负责寄售各种物品，但要收取一定费用！^^'
        + '     <〖寄售系统〗/@auction>^^'
        + '     <〖 任 务 〗/@Quest>^^');
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
                if CurQuestStep = 16 then
                begin
                    Menusay(uSource, '很高兴认识你啊，我这儿可以寄售各种装备，^'
                        + '需要的话随时可以找我！既然你来拜访我，那^'
                        + '我就送你点小礼物吧^^'
                        + '<〖谢谢〗/@q4950_j17>^^'
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

procedure q4950_j17(uSource, uDest:integer);
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

    setQuestStep(uSOurce, 17);
    notice := getQuestSubRequest(4950, 17);
    saysystem(uSource, '任务提示：' + notice);
    if getQuestSubItem(4950, 16, 0, aname, acount) = false then exit;
    additem(uSource, aname, acount);

    if getQuestSubItem(4950, 16, 1, aname, acount) = false then exit;
    additem(uSource, aname, acount);
    saysystem(uSource, '获得任务奖励：钱币:1000,天桃:20');
    Menusay(uSOurce, '快去' + notice + '^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');

end;

