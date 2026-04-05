procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '出售枪法武功密笈，收购枪类武器。高手起码^'
        + '应该有个二层枪法武功密笈。^^'
        + '    <〖出售枪法秘籍〗/@buy>^^'
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
                if CurQuestStep = 5 then
                begin
                    Menusay(uSource, '很高兴认识你啊，我这儿有各种枪法秘籍，需^'
                        + '要的话随时可以找我！难得你来拜访我，那我^'
                        + '就送你一本枪法秘籍吧^^'
                        + '<〖谢谢〗/@q4950_j6>^^'
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

procedure q4950_j6(uSource, uDest:integer);
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
    setQuestStep(uSOurce, 6);
    notice := getQuestSubRequest(4950, 6);
    saysystem(uSource, '任务提示：' + notice);
    if getQuestSubItem(4950, 5, 0, aname, acount) = false then exit;
    additem(uSource, aname, acount);
    saysystem(uSource, '获得任务奖励：火龙升天术');
    Menusay(uSOurce, notice + '^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');

end;

