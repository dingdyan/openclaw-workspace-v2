{******************************************************************************
创建人:何永安
创建时间:2009.11.4
修改人：何永安
修改时间:2009.11.17
修改内容:主线5008任务
******************************************************************************}

procedure OnDie(uSource, uDest:integer; aRACE:integer);
begin
    MapDelmonster('王陵3层', '上古雨中客2');
    MapAddmonster('王陵3层', '上古雨中客2', 178, 176, 1, 0, '', 0, 0, TRUE); //增加怪物
end;

procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '我是守护王陵的使者。王陵内布满了很多机关^'
        + '。没我的允许，擅入者格杀勿论！^^'
        + '<〖传送禁止区域〗/@Move>^^'
        + '<〖 任 务 〗/@OnMenuSub>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure Move(uSource, uDest:integer);
begin
    //检查有没有守护印
    if GetItemQuestCount(uSource, '王陵守护印') < 1 then
    begin
        Menusay(uSource, '没有王陵守护印，不能传送禁止区域。^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //获得地图玩家数量
    if MapUserCount('禁止区域') > 0 then
    begin
        Menusay(uSource, '稍等，禁止区域内有人。^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //检查某地图某种怪物活着的数量
    if MapFindMonster('禁止区域', '禁地护卫武士', 'live') <= 0 then
    begin
        Menusay(uSource, '稍等。。。^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //初始化地图
    MapRegen('禁止区域');
    MapIceMonster('禁止区域', '禁地护卫武士', true);

    DelItemQuest(uSource, '王陵守护印', 1); //删除物品
    mapmove(uSource, 76, 14, 21, 0); //传送禁止区域
end;

procedure OnMenuSub(uSource, uDest:integer);
begin
    if getQuestNo(uSource) <> 5007 then
    begin
        Menusay(uSource, '我没什么可以帮助你的！^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    if getEnergyLevel(uSource) < 9 then
    begin
        Menusay(uSource, '人物境界要在天人合一以上才能胜任！^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    if getage(uSource) < 3000 then
    begin
        Menusay(uSource, '人物年龄要在30岁以上才能胜任！^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    case getQuestCurrentNo(uSource) of
        0:
            begin
                menusay(uSource, '看侠士身手不凡，可否帮我扫除地下迷宫的所^^'
                    + '有忍王一伙儿?^^'
                    + '<〖接受委托〗/@q5008_1_j>^^'
                    + '<〖退出〗/@exit>^^');
            end;
        5008:
            begin
                case getQuestStep(uSource) of
                    1:
                        begin
                            Menusay(uSource, '忍王都消灭了吗？^^'
                                + '<〖递上忍王首级〗/@q5008_1_g>^^'
                                + '<〖我还没找到〗/@exit>^');
                        end;
                    2:
                        begin
                            Menusay(uSource, '现在最重要是找回遗失的王陵四大宝物，分别^'
                                + '是王子宝剑、王妃金冠、公主戒指、公主项链^'
                                + '。先到王陵迷宫找到花郎老侠客，打听四大宝^'
                                + '物的下落。你只要将四件宝物带回来就能得到^'
                                + '丰厚的回报。^^'
                                + '<〖接受委任〗/@q5008_3_j>^^'
                                + '<〖退出〗/@exit>^^');
                        end;
                    3:
                        begin
                            Menusay(uSource, '事情还顺利吗？宝物拿来没？^^'
                                + '<〖递上宝物〗/@q5007_3_g>^^'
                                + '<〖退出〗/@exit>^^');
                        end;
                else
                    begin
                        Menusay(uSource, '任务错误，请重置该任务^^'
                            + '<〖重置〗/@q5008_GiveUP>^^'
                            + '<〖退出〗/@exit>^^');
                    end;
                end;
            end;
    else
        begin
            Menusay(uSource, '任务错误，请重置该任务^^'
                + '<〖重置〗/@q5008_GiveUP>^^'
                + '<〖退出〗/@exit>^^');
        end;
    end;
end;

procedure q5008_GiveUP(uSource, uDest);
begin
    DelItemQuestID(uSource, 5008);
    setQuestCurrentNo(uSource, 0);
    setQuestStep(uSource, 0);

    menusay(uSource, '任务重置成功，请重新接任务^^'
        + '<〖退出〗/@exit>^^');
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5008, 0));
end;

procedure q5008_1_j(uSource, uDest:integer);
begin
    AddItemQuest(uSource, '令牌q5008s1', 1);

    setQuestCurrentNo(uSource, 5008);
    setQuestStep(uSource, 1);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5008, 1));

    menusay(uSource, '东瀛的忍者，阴险狡诈。侠士要多加小心呀！^^'
        + '<〖谢谢〗/@exit>^^');
end;

procedure q5008_1_g(uSource, uDest:integer);
begin
    if GetItemQuestCount(uSource, '首级q5008s1') < 5 then
    begin
        Menusay(uSource, '好像还没有全部都消灭^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    DelItemQuestID(uSource, 5008);
    setQuestStep(uSource, 2);

    Menusay(uSource, '现在最重要是找回遗失的王陵四大宝物，分别^'
        + '是王子宝剑、王妃金冠、公主戒指、公主项链^'
        + '。先到王陵迷宫找到花郎老侠客，打听四大宝^'
        + '物的下落。你只要将四件宝物带回来就能得到^'
        + '丰厚的回报。^^'
        + '<〖接受委任〗/@q5008_3_j>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure q5008_3_j(uSource, uDest:integer);
begin
    AddItemQuest(uSource, '地形图q5008s3', 1);

    setQuestStep(uSource, 3);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5008, 3));

    menusay(uSource, '王陵宝物就分别藏在王陵迷宫的几个密室中，^'
        + '一定要小心行事, 密室里有很多敌人把手。^^'
        + '<〖谢谢〗/@exit>^^');
end;

procedure q5007_3_g(uSource, uDest:integer);
var
    count           :integer;
    name            :string;
begin
    if (GetItemQuestCount(uSource, '金冠q5008s3') < 1) then
    begin
        Menusay(uSource, '王妃金冠在哪里？^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    if (GetItemQuestCount(uSource, '戒指q5008s3') < 1) then
    begin
        Menusay(uSource, '公主戒指在哪里？^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    if (GetItemQuestCount(uSource, '项链q5008s3') < 1) then
    begin
        Menusay(uSource, '公主项链在哪里？^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    if (GetItemQuestCount(uSource, '宝剑q5008s3') < 1) then
    begin
        Menusay(uSource, '王子宝剑在哪里？^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    if getitemspace(uSource) < 2 then
    begin
        menusay(uSource, '背包至少要有2个空位^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //删除任务物品
    DelItemQuestID(uSource, 5008);

    //添加任务奖励
    //1-5号位置装备
    getQuestMainItem(5008, Random(5) + 1, name, count);
    addItemEx(uSource, name, '上古雨中客', 3, 0, 0, 0, 0, 0);

    //0位置，钱
    getQuestMainItem(5008, 0, name, count);
    additem(uSource, name, count);

    //设置任务信息
    setQuestNo(uSource, 5008);
    setQuestCurrentNo(uSource, 0);
    setQuestStep(uSource, 0);
    saysystem(uSource, '任务完成');

    Menusay(uSource, '果然是新罗遗失多年的4大宝物，我不知道如^'
        + '何感激你。这把武器跟随我多年，今天我就把^'
        + '他赠与英雄。^^'
        + '<〖谢谢〗/@exit>^^');
end;

