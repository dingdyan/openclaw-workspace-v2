//***************************************************
//创建人：何永安
//时间：2009.10.26
//功能：
//***************************************************

procedure OnMenu(uSource, uDest:integer);
var
    CurQuestID, CurQuestStep:integer;
begin
    CurQuestID := getQuestCurrentNo(uSource);
    CurQuestStep := getQuestStep(uSource);
    if CurQuestID <> 5007 then
    begin
        Menusay(uSource, '壮士，小心迷路！^'
            + '^<〖谢谢〗/@exit>');
        exit;
    end;

    case CurQuestStep of
        2:
            begin
                Menusay(uSource, '水... 水...请给我点水...^'
                    + '<〖给玉仙水〗/@givewater>^'
                    + '<〖我自己还不够喝呢〗/@exit>^');
            end;
        3:
            begin
                Menusay(uSource, '啊, 谢谢. 小女子在寻回被忍王一伙儿盗取的^'
                    + '新罗的遗物时,中了暗器身负重伤.现在好多了...^'
                    + '不知您是否能帮助我,替我继续完成我的使命...^'
                    + '侠客的大恩我必将铭记在心!^^'
                    + '<〖我会的〗/@favor>^'
                    + '<〖我还有别的事〗/@exit>^');
            end;
    else
        begin
            Menusay(uSource, '壮士，小心迷路！^'
                + '^<〖谢谢〗/@exit>');
            exit;
        end;
    end;

end;

procedure givewater(uSource, uDest:integer);
var
    int1            :integer;
begin
    int1 := FindItemName(uSource, '竹筒');
    if int1 <= -1 then
    begin
        int1 := FindItemName(uSource, '大型竹筒');
        if int1 <= -1 then
        begin
            Menusay(uSource, '没有竹筒或者大竹筒');
            exit;
        end;
    end;
    if getitemDurability(uSource, int1) = 0 then
    begin
        Menusay(uSource, '竹筒无水');
        exit;
    end;

    setitemDurability(uSource, int1, 0);

    setQuestStep(uSource, 3);
    OnMenu(uSource, uDest);
end;

procedure favor(uSource, uDest:integer);
begin
    setQuestStep(uSource, 4);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5007, 4));

    DelItemQuestID(uSource, 5007);
    AddItemQuest(uSource, '玉仙的无情双刀', 1);

    menusay(uSource, '拿上我的刀，你才能找到黑马武士^'
        + '找到后，把它们交给交给老侠客^^'
        + '<〖我知道了〗/@exit>');
end;

