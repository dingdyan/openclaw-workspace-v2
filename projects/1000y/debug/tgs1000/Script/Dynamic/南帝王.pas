{******************************************************************************
创建人:杨李
创建时间:2009.10.28
修改人：何永安
修改时间：2009.11.13
实现功能: 主线任务恍然大悟
修改人：杨李
修改时间：2009.11.17
实现功能: 主线任务恍然大悟
*******************************************************************************}

procedure OnMenu(uSource, uDest:integer);
var
    CurQuestNo      :integer;      //当前任务号
    CurQuestStep    :integer;      //当前任务步骤号
begin
    CurQuestNo := getQuestCurrentNo(uSource);
    CurQuestStep := getQuestStep(uSource);

    if CurQuestNo <> 5007 then
    begin
        menusay(uSource, ' 我没什么可以帮助你的^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    case CurQuestStep of
        1:
            begin
                menusay(uSource, '什么？你要杀我？是西域魔人派你来的？^^'
                    + '<〖是又怎样〗/@q5007_1_1>^^'
                    + '<〖退出〗/@exit>');
            end;
        2:
            begin
                menusay(uSource, '为何还不去调查?^^'
                    + '<〖退出〗/@exit>');
            end;
        3:
            begin
                menusay(uSource, '少侠回来了？现在还要杀我吗？^^'
                    + '<〖我错了〗/@q5007_3_1>^^'
                    + '<〖退出〗/@exit>');
            end;
        4:
            begin
                menusay(uSource, '事情进行的怎么样？顺利吗？^^'
                    + '<〖递上西域魔人首级〗/@q5007_4_1>^^'
                    + '<〖打听石谷钥匙〗/@q5007_4_sgys>^^'
                    + '<〖打听降魔符〗/@howtogetticket>^^'
                    + '<〖退出〗/@exit>');
            end;
    end;
end;

procedure q5007_1_1(uSource, uDest:integer);
begin
    menusay(uSource, '原来你是西域魔人派来的，年轻人不要走上歪^'
        + '路，听任魔头摆布。我都剩下半条命的人了，^'
        + '我还能作恶吗？^^'
        + '<〖了解真相〗/@q5007_1_2>^^'
        + '<〖退出〗/@exit>');
end;

procedure q5007_1_2(uSource, uDest:integer);
begin
    menusay(uSource, '你去黄金沙漠调查一下就知道真相了，那里有^'
        + '个僧侣从来不说谎话，看他怎么说。^^'
        + '<〖调查真相〗/@q5007_1_3>^^'
        + '<〖退出〗/@exit>');
end;

procedure q5007_1_3(uSource, uDest:integer);
begin
    setQuestStep(uSource, 2);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5007, 2));
end;

procedure q5007_3_1(uSource, uDest:integer);
begin
    menusay(uSource, '知错能改，善莫大焉？既然你来找我，肯定也^'
        + '见过东天王和北霸王了吧？他们还好吗？^^'
        + '<〖我收了他们的魂〗/@q5007_3_2>^^'
        + '<〖退出〗/@exit>');
end;

procedure q5007_3_2(uSource, uDest:integer);
begin
    menusay(uSource, '什么？你把他们两个魂收进了葫芦？不好，如^'
        + '果你不把他们放出来的话，那他们就永世^'
        + '不得超生了。除非西域魔人死掉，才能释^'
        + '放他们的灵魂。^^'
        + '<〖我去杀了她〗/@q5007_3_3>^^'
        + '<〖退出〗/@exit>');
end;

procedure q5007_3_3(uSource, uDest:integer);
begin
    menusay(uSource, '你看见的可能不是她的真身，据说她住在西域^'
        + '魔人屋，你想进去就要拿到石谷钥匙和降^'
        + '魔符。^^'
        + '<〖誓杀魔头〗/@q5007_4_j>^^'
        + '<〖退出〗/@exit>');
end;

procedure q5007_4(uSource, uDest:integer);
begin
    menusay(uSource, '这是石谷地形图你带上，以备不时之需。^^'
        + '<〖谢谢〗/@exit>');
end;

procedure q5007_4_sgys(uSource, uDest:integer);
begin
    menusay(uSource, '石谷钥匙用蝎子尾巴和金毛狮甲做成.详细部^'
        + '分要向黄金沙漠铁匠（124，382）请教.^^'
        + '<〖我去找铁匠〗/@exit>');
end;

procedure howtogetticket(uSource, uDest:integer);
begin
    menusay(uSource, '降魔符帮你突破西域魔人设的机关,通向她所^ '
        + '在的空间.具体做法要请教东海沼泽阴阳师^'
        + '(158，243).^^'
        + '<〖我去找阴阳师〗/@exit>');
end;

procedure q5007_4_j(uSource, uDest:integer);
begin
    additemquest(uSource, '地形图q5007s4', 1);
    setQuestStep(uSource, 4);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5007, 4));
    menusay(uSource, '降魔符帮你突破西域魔人设的机关,通向她所^'
        + '在的空间.具体做法要请教东海沼泽阴阳师^'
        + '(158，243).^'
        + '石谷钥匙用蝎子尾巴和金毛狮甲做成.详细部^'
        + '分要向黄金沙漠铁匠（124，382）请教.^^'
        + '<〖知道了〗/@q5007_4>');
end;

procedure q5007_4_1(uSource, uDest:integer);
var
    count           :integer;
    name            :string;
begin
    if GetItemQuestCount(uSource, '首级q5007s5') < 1 then
    begin
        menusay(uSource, '西域魔人首级在哪里？^^'
            + '<〖我还没去呢〗/@exit>');
        exit;
    end;

    if getitemspace(uSource) < 2 then
    begin
        menusay(uSource, '背包至少留出2个空位。^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    DelItemQuestId(uSource, 5007);

    //1-5号位置装备
    getQuestMainItem(5007, Random(5) + 1, name, count);
    addItemEx(uSource, name, '南帝王', 3, 0, 0, 0, 0, 0);

    //0位置，钱
    getQuestMainItem(5007, 0, name, count);
    additem(uSource, name, count);

    setQuestNo(uSource, 5007);
    setQuestCurrentNo(uSource, 0);
    setQuestStep(uSource, 0);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5008, 0));
    Menusay(uSource, '这么难的任务侠士都能完成，将来定非一般人^'
        + '。乡民们可以真正的安宁了！这是对侠士击杀^'
        + '西域魔人给予的一点奖励。^^'
        + '<〖谢谢〗/@exit>^^');
end;

