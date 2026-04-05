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
        Menusay(uSource, '壮士，这里机关重重！^'
            + '^<〖谢谢〗/@exit>');
        exit;
    end;

    case CurQuestStep of
        4:
            begin
                Menusay(uSource, '幸会. 在下乃新罗唯一幸存的花郎老侠客. ^'
                    + '我的使命是协助雨中客完成守护王陵.^^'
                    + '<〖递上黑马武士〗/@questGive>^^'
                    + '<〖我还有别的事〗/@exit>^^');
            end;

        5:
            begin
                Menusay(uSource, '自从王陵被入侵之后，王陵四宝就遗失了^'
                    + '不知道壮士是否可以帮我寻回，然后交到^'
                    + '雨中客手里？^^'
                    + '<〖我可以〗/@questYes>^^'
                    + '<〖我还有别的事〗/@exit>^^');
            end;
        7:
            begin
                Menusay(uSource, '四宝找到了吧？但是还丢了2件宝物^'
                    + '那两件宝物就在王的寝宫，你去帮我找回来^^'
                    + '<〖好的〗/@questYes2>^^'
                    + '<〖我还有别的事〗/@exit>^^');
            end;
        8:
            begin
                Menusay(uSource, '这么快就回来了，东西带来了吗？^^'
                    + '<〖递上宝物〗/@questGive2>^^'
                    + '<〖我还有别的事〗/@exit>^^');
            end;
    else
        begin
            Menusay(uSource, '壮士，这里机关重重！^'
                + '^<〖谢谢〗/@exit>');
            exit;
        end;
    end;
end;

procedure questGive(uSource, uDest:integer);
begin
    if GetItemQuestCount(uSource, '黑马武士') < 20 then
    begin
        Menusay(uSource, '黑马武士数量不够^'
            + '^<〖离开〗/@exit>');
        exit;
    end;

    setQuestStep(uSource, 5);
    DelItemQuestID(uSource, 5007);
    OnMenu(uSource, uDest);
end;

procedure questYes(uSource, uDest:integer);
begin
    setQuestStep(uSource, 6);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5007, 6));
    DelItemQuestID(uSource, 5007);
    AddItemQuest(uSource, '地形图50071', 1);
end;

procedure questYes2(uSource, uDest:integer);
begin
    setQuestStep(uSource, 8);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5007, 8));
    DelItemQuestID(uSource, 5007);
    AddItemQuest(uSource, '地形图50072', 1);
end;

procedure questGive2(uSource, uDest:integer);
begin
    if (GetItemCount(uSource, '侠客指环') < 1)
        or (GetItemCount(uSource, '牌王') < 1) then
    begin
        Menusay(uSource, '你手上没有侠客指环或者牌王？');
        exit;
    end;
    if (GetItemQuestCount(uSource, '珍品玉玺') < 1)
        or (GetItemQuestCount(uSource, '珍品新罗金冠') < 1) then
    begin
        Menusay(uSource, '宝物在哪里？');
        exit;
    end;

    if getitemspace(uSource) < 1 then
    begin
        Menusay(uDest, '背包至少有1个空位');
        exit;
    end;
    deleteitem(uSource, '侠客指环', 1);
    deleteitem(uSource, '牌王', 1);
    DelItemQuestID(uSource, 5007);
    additem(uSource, '不灭', 1);
    say(uDest, '做的不错，这个不灭戒指送你了！');

    setQuestNo(uSource, 5007);
    setQuestCurrentNo(uSource, 0);
    setQuestStep(uSource, 0);
    saysystem(uSource, '任务完成，获得不灭戒指1个');
end;

