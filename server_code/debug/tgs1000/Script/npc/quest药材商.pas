{******************************************************************************
创建人:杨李
创建时间:2009.10.27
功能：极乐洞任务及买卖仓库功能
修改人：何永安
修改时间：2009.11.16
修改内容：5003号任务 拯救极乐寺
******************************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '需要物品就到我这来吧!我也收购一些物品 ^^'
        + '    <〖 收 购 〗/@sell>^^'
        + '    <〖 出 售 〗/@buy>^^'
        + '    <〖保管物品〗/@notice>^^'
        + '    <〖 任 务 〗/@qMenu>^^');
end;

procedure notice(uSource, uDest:integer);
begin
    Menusay(uSource, '我现在已经不负责保管物品了，想保管物品去^'
        + '找仓库保管员吧^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');
end;

procedure qMenu(uSource, uDest:integer);
begin
    if GetQuestCurrentNo(uSource) = 4950 then
    begin
        case GEtQuestStep(uSource) of
            17:
                begin
                    Menusay(uSOurce, '很高兴认识你啊，我这儿有不仅出售各种药品，^'
                        + '还有很多事情等着你呢，有空的话一定要来找我^'
                        + '既然你第一次来，那我就送你点小礼品吧^^'
                        + '<〖谢谢〗/@q4950_j18>^^'
                        + '<〖返回〗/@OnMenu>^^'
                        + '<〖退出〗/@exit>');
                end;
        else
            begin
                Menusay(uSOurce, '你都拜访了吗？^^'
                    + '<〖返回〗/@OnMenu>^^'
                    + '<〖退出〗/@exit>');
            end;
        end;
        exit;
    end;
    if getQuestNo(uSource) <> 5002 then
    begin
        Menusay(uSource, '我没有什么可以帮助你的^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    if getEnergyLevel(uSource) < 4 then
    begin
        Menusay(uSource, '你的境界要在生死境以上才能胜任^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    if getage(uSource) < 3000 then
    begin
        Menusay(uSource, '你的年龄要在30岁以上才能胜任^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    case getQuestCurrentNo(uSource) of
        0:
            begin
                Menusay(uSource, '极乐寺是在许多年以前由一位得道高人所创建^'
                    + '的，数年之后，一群邪恶的破戒僧占据了这里^'
                    + '，并利用各种手段鱼肉乡民，整间寺庙充满了^'
                    + '邪恶与罪孽。侠士可否前去极乐洞消灭他们？^^'
                    + '<〖接受委任〗/@q5003_1_j>^^'
                    + '<〖退出〗/@exit>^^');
            end;
        5003:
            begin
                case getQuestStep(uSource) of
                    1:
                        begin
                            MenuSay(uSource, '破戒僧都消灭了吗？^^'
                                + '<〖递上魂魄〗/@q5003_1_g>^^'
                                + '<〖退出〗/@exit>^^');
                        end;
                    2:
                        begin
                            Menusay(uSource, '侠士果然厉害。不过，他们的头领还没有铲除^'
                                + '。在极乐洞的最深处有一只火王，是他们的头^'
                                + '领。只有消灭了他，乡民才能真正的安宁。侠^'
                                + '士可愿承担此重任。^^'
                                + '<〖接受委任〗/@q5003_2_j>^^'
                                + '<〖退出〗/@exit>^^');
                        end;
                    3:
                        begin
                            MenuSay(uSource, '火王消灭了吗？^^'
                                + '<〖递上火王尸骨〗/@q5003_3_g>^^'
                                + '<〖退出〗/@exit>^^');
                        end;
                else
                    begin
                        MenuSay(uSource, '任务步骤出错，请重置任务^^'
                            + '<〖重置〗/@q5003_GiveUp>^^'
                            + '<〖退出〗/@exit>^^');
                    end;
                end;
            end;
    else
        begin
            MenuSay(uSource, '任务步骤出错，请重置任务^^'
                + '<〖重置〗/@q5003_GiveUp>^^'
                + '<〖退出〗/@exit>^^');
        end;
    end;
end;

procedure q4950_j18(uSource, uDest:integer);
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
    setQuestStep(uSOurce, 18);
    notice := getQuestSubRequest(4950, 18);
    saysystem(uSource, '任务提示：' + notice);
    if getQuestSubItem(4950, 17, 0, aname, acount) = false then exit;
    additem(uSource, aname, acount);

    if getQuestSubItem(4950, 17, 1, aname, acount) = false then exit;
    additem(uSource, aname, acount);
    saysystem(uSource, '获得任务奖励：生药20个，内力丸20个');
    Menusay(uSOurce, '快去' + notice + '^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');
end;

procedure q5003_GiveUp(uSource, uDest:integer);
begin
    DelItemQuestID(uSource, 5003);
    setQuestCurrentNo(uSource, 0);
    SetQuestStep(uSource, 0);

    menusay(uSource, '任务重置成功，请重新接任务^^'
        + '<〖退出〗/@exit>^^');
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5003, 0));
end;

procedure q5003_1_j(uSource, uDest:integer);
begin
    additemQuest(uSource, '地形图q5003s1', 1);

    setQuestCurrentNo(uSource, 5003);
    setQueststep(uSource, 1);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5003, 1));
end;

procedure q5003_1_g(uSource, uDest:integer);
begin
    if getitemQuestCount(uSource, '魂魄q5003s1') < 12 then
    begin
        Menusay(uSource, '破戒僧魂魄数量不足^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    DelItemQuestID(uSource, 5003);
    setQueststep(uSource, 2);

    Menusay(uSource, '侠士果然厉害。不过，他们的头领还没有铲除^'
        + '。在极乐洞的最深处有一只火王，是他们的头^'
        + '领。只有消灭了他，乡民才能真正的安宁。侠^'
        + '士可愿承担此重任。^^'
        + '<〖接受委任〗/@q5003_2_j>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure q5003_2_j(uSource, uDest:integer);
begin
    additem(uSource, '书札', 1);
    additemQuest(uSource, '地形图q5003s3', 1);
    setQueststep(uSource, 3);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5003, 3));

    menusay(uSource, '在极乐寺的井内藏有一条通往极乐洞的密道入^'
        + '口，不过需要书札才能进去。我这里有一个书^'
        + '札你带着吧。^^'
        + '<〖谢谢〗/@exit>^^');
end;

procedure q5003_3_g(uSource, uDest:integer);
var
    count           :integer;
    name            :string;
begin
    if getitemQuestCount(uSource, '尸骨q5003s3') < 1 then
    begin
        Menusay(uSource, '还没拿到火王的尸骨吗？^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    if getitemspace(uSource) < 2 then //获取背包空位
    begin
        Menusay(uSource, '背包至少留出2个空位^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //删除任务物品
    DelItemQuestID(uSource, 5003);

    //添加任务奖励
    //1-5号位置装备
    getQuestMainItem(5003, Random(5) + 1, name, count);
    addItemEx(uSource, name, '药材商', 3, 0, 0, 0, 0, 0);

    //0位置，钱
    getQuestMainItem(5003, 0, name, count);
    additem(uSource, name, count);

    //设置任务信息
    setQuestNo(uSource, 5003);
    setQuestCurrentNo(uSource, 0);
    SetQuestStep(uSource, 0);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5004, 0));

    Menusay(uSource, '这么难的任务侠士都能完成，将来定非一般人^'
        + '。乡民们可以真正的安宁了！这是对侠士击杀^'
        + '火王的给予一点奖励。^^'
        + '<〖谢谢〗/@exit>^^');
end;

