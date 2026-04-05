procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '这么远的路途，侠士找在下到底有何贵干?是^'
        + '需要槌法密笈吗?便宜出售,不如买回去吧.^^'
        //+ '    <〖卖 槌法兵器〗/@sell>^^'
        + '    <〖出售 槌法秘籍〗/@buy>^^'
        + '    <〖 任 务 〗/@Quest>^^');
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
                if CurQuestStep = 4 then
                begin
                    Menusay(uSource, '很高兴认识你啊，我这儿有各种槌法秘籍，需^'
                        + '要的话随时可以找我！难得你来拜访我，那我^'
                        + '就送你一本槌法秘籍吧^^'
                        + '<〖谢谢〗/@q4950_j5>^^'
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

procedure q4950_j5(uSource, uDest:integer);
var
    aname, notice   :string;
    acount          :integer;
begin
    if getItemSpace(uSource) < 1 then
    begin
        Menusay(uSource, '背包空位不足，请留出1个位置！^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    setQuestStep(uSOurce, 5);
    notice := getQuestSubRequest(4950, 5);
    saysystem(uSource, '任务提示：' + notice);
    if getQuestSubItem(4950, 4, 0, aname, acount) = false then exit;
    additem(uSource, aname, acount);
    saysystem(uSource, '获得任务奖励：回转狂天飞');
    Menusay(uSOurce, '快去' + notice + '^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');

end;

