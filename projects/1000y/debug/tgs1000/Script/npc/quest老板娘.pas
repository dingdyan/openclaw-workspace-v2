{******************************************************************************
创建人:杨李
创建时间:2009.10.27
功能：长城以南任务及买卖功能
******************************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, ' 廉价出售，高价收购。^^'
        + '    <〖收购〗/@sell>^^'
        + '    <〖出售〗/@buy>^^'
        + '    <〖任务〗/@quest_menu>');
end;

procedure ResetQuest_5000(uSource, uDest:integer);
begin
    DelItemQuestID(uSource, 5000);
    setQuestCurrentNo(uSource, 0);
    SetQuestStep(uSource, 0);
end;

procedure quest_menu(uSource, uDest:integer);
var
    CurEnergyLevet, CurQuestId, CurQuestStep, completeId:integer; //当前元气值
    str             :string;
begin
    completeID := getQuestNo(uSource);
    //1。完成ID，条件限制
    if completeID <> 4950 then
    begin
        Menusay(uSource, '我没什么可以帮助你的!^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    CurEnergyLevet := getEnergyLevel(uSource);
    if CurEnergyLevet < 1 then
    begin
        Menusay(uSource, '境界尚浅，恐怕不能胜任！到达出入境以上^'
            + '再来找我吧!^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    //2。当前ID<>5000接任务
    CurQuestId := getQuestCurrentNo(uSource);
    case CurQuestId of
        0:
            begin
                Menusay(uSource, '最近在村庄附近有很狂犬出没，他们一天到晚^'
                    + '在村庄附近吼叫，害的人不能安静。侠士可愿^'
                    + '意前去消灭他们，还村庄一个安静.^^'
                    + '<〖这就去消灭他们〗/@q5000_j1>^^'
                    + '<〖返回〗/@OnMenu>^^'
                    + '<〖退出〗/@exit>');
            end;
        5000:
            begin
                CurQuestStep := getQuestStep(uSource);
                case CurQuestStep of
                    1:
                        begin
                            MenuSay(uSource, '叫你杀的的狂犬都消灭了吗？^^'
                                + '<〖递上狗骨头〗/@q5000_1>^^'
                                + '<〖返回〗/@OnMenu>^^'
                                + '<〖退出〗/@exit>');

                        end;
                    2:
                        begin
                            Menusay(uSource, '侠士果然厉害.我还有个更重要的任务交给你.^'
                                + '最近在帝王陵的附近有很多忍者出没，他们企^'
                                + '图盗取王陵的宝藏。已经有很多守护王陵的侠^'
                                + '士死在他们的刀下，你可愿意前去消灭他们，^'
                                + '保护好王陵的宝藏。^^'
                                + '<〖这就去消灭他们〗/@q5000_j2>^^'
                                + '<〖返回〗/@OnMenu>^^'
                                + '<〖退出〗/@exit>');
                        end;
                    3:
                        begin
                            MenuSay(uSource, '黑忍者的首级都带来了吗？^^'
                                + '<〖递上黑忍者的首级〗/@q5000_2>^^'
                                + '<〖返回〗/@OnMenu>^^'
                                + '<〖退出〗/@exit>');

                        end;
                else
                    begin
                        MenuSay(uSource, '任务出错，请取消任务!^^'
                            + '<〖取消任务〗/@ResetQuest_5000>^^'
                            + '<〖返回〗/@OnMenu>^^'
                            + '<〖退出〗/@exit>');
                    end;
                end;
            end;
    else
        begin
            Menusay(uSource, '我没什么可帮助你的!^^'
                + '<〖返回〗/@OnMenu>^^'
                + '<〖退出〗/@exit>');
        end;
    end;
end;

procedure q5000_j1(uSource, uDest:integer);
begin
    additemQuest(uSource, '令牌q5000s1', 1);
    setQuestCurrentNo(uSource, 5000);
    setQueststep(uSource, 1);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5000, 1));

end;

procedure q5000_j2(uSource, uDest:integer);
begin

    additem(uSource, '令牌q5000s2', 1);
    setQueststep(uSource, 3);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5000, 3));

end;

procedure q5000_1(uSource, uDest:integer);
var
    i               :integer;
begin
    i := GetItemQuestCount(uSource, '骨头q5000s1');
    if i < 10 then
    begin
        Menusay(uSource, '我交给你的任务没完成，回来干嘛？^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    delitemquest(uSource, '令牌q5000s1', 1);
    DelItemQuest(uSource, '骨头q5000s1', 10);
    setQueststep(uSource, 2);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5000, 2));
    Menusay(uSource, '侠士果然厉害.我还有个更重要的任务交给你.^'
        + '最近在帝王陵的附近有很多黑忍者出没，他们企^'
        + '图盗取王陵的宝藏。已经有很多守护王陵的侠^'
        + '士死在他们的刀下，你可愿意前去消灭他们，^'
        + '保护好王陵的宝藏。^^'
        + '<〖这就去消灭他们〗/@q5000_j2>^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');
end;

procedure q5000_2(uSource, uDest:integer);
var
    i, aRandom, count:integer;
    name            :string;
begin

    i := getitemquestcount(uSource, '首级q5000s2');
    if i < 20 then
    begin
        Menusay(uSource, '我交给你的任务没完成，回来干嘛？^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');

        exit;
    end;

    if getItemSpace(uSource) < 2 then
    begin
        Menusay(uSource, '背包已满，请留出2个空位。^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    DelItemQuestID(uSource, 5000);

    //1-5号位置装备
    getQuestMainItem(5000, Random(5) + 1, name, count);
    addItemEx(uSource, name, '老板娘', 3, 0, 0, 0, 0, 0);

    //0位置，钱
    getQuestMainItem(5000, 0, name, count);
    additem(uSource, name, count);

    setQuestNo(uSource, 5000);
    setQuestCurrentNo(uSource, 0);
    SetQuestStep(uSource, 0);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5001, 0));

    Menusay(uSource, ' 侠士果然是可托付之人，这是我给侠士的一点^'
        + '奖励，收下吧！^^'
        + '<〖谢谢〗/@exit>^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');

end;

