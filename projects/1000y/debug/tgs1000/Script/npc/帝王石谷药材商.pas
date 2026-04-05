{****************************************************************
创建人：李小利
创建时间：
修改人：何永安
修改时间：2009-11-9
功能：主线任务
修改人：李小利
修改时间：2009-11-17
功能：主线任务
*****************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    // 完成任务判断
    if getQuestNo(uSource) <> 5004 then
    begin
        menusay(uSource, '没事别来烦我，忙着呢^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    //判断境界
    if getEnergyLevel(uSource) < 6 then
    begin
        menusay(uSource, '境界尚浅，恐怕不能胜任！境界到达无为境^'
            + '或者以上在来找我吧^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    //判断年龄
    if getage(uSource) < 3000 then
    begin
        menusay(uSource, '年纪尚轻，恐怕不能胜任！年龄达到30岁以^'
            + '上在来找我吧^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    case getQuestCurrentNo(uSource) of
        0:
            begin
                Menusay(uSource, '最近村子里的人都得了疟疾，需要大量的野兽^'
                    + '指骨和野神趾骨来做药材，侠士是否能帮我采^'
                    + '集一些药材来？^^'
                    + '<〖接受〗/@QuestYes>^^'
                    + '<〖我还有别的事〗/@exit>');
            end;
        5005:
            begin
                case getQueststep(uSource) of
                    1:
                        begin
                            Menusay(uSource, '侠士你终于回来了？药材带来了没？^^'
                                + '<〖递上药材〗/@QuestGive>^^'
                                + '<〖我还没找到〗/@exit>');
                        end;
                    2:
                        begin
                            Menusay(uSource, '太感谢你了，侠士。但还要麻烦你走一趟！老^'
                                + '母病危，随时都有生命危险。只有野兽之心才^'
                                + '能救他，你能否再帮我杀死东海野兽王取回野^'
                                + '兽之心？^^'
                                + '<〖好的〗/@QuestYes2>^^'
                                + '<〖我还有别的事〗/@exit>');
                        end;
                    3:
                        begin
                            Menusay(uSource, '你回来了呀，野兽之心拿到没？^^'
                                + '<〖递上野兽之心〗/@QuestGive2>^^'
                                + '<〖我还没抓到〗/@exit>');
                        end;
                end;
            end;
    else
        begin
            menusay(uSource, '没事别烦我，忙着呢');
        end;
    end;
end;

//步骤0

procedure QuestYes(uSource, uDest:integer);
begin
    setQuestCurrentNo(uSource, 5005);
    setQueststep(uSource, 1);
    additemquest(uSource, '药方q5005s1', 1);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5005, 1));
    menusay(uSource, '侠士此去应速去速回,村子的人就都看你的了!^^'
        + '<〖退出〗/@exit>');
end;
//步骤1

procedure QuestGive(uSource, uDest:integer);
begin
    //检查任务物品
    if GetItemQuestCount(uSource, '指骨q5005s1') < 10 then
    begin
        saysystem(uSource, inttostr(getitemcount(uSource, '指骨q5005s1')));
        Menusay(uSource, '野兽指骨还没打够怎么就回来了?'
            + '<〖退出〗/@exit>');
        exit;
    end;
    if GetItemQuestCount(uSource, '趾骨q5005s1') < 10 then
    begin
        Menusay(uSource, '野神趾骨还没打够怎么就回来了?'
            + '<〖退出〗/@exit>');
        exit;
    end;
    DelItemQuest(uSource, '药方q5005s1', 1);
    DelItemQuest(uSource, '指骨q5005s1', 10);
    DelItemQuest(uSource, '趾骨q5005s1', 10);
    setQuestStep(uSource, 2);
    Menusay(uSource, '太感谢你了，侠士。但还要麻烦你走一趟！老^'
        + '母病危，随时都有生命危险。只有野兽之心才^'
        + '能救他，你能否再帮我杀死东海野兽王取回野^'
        + '兽之心？^^'
        + '<〖好的〗/@QuestYes2>^^'
        + '<〖我还有别的事〗/@exit>');

end;
//步骤2

procedure QuestYes2(uSource, uDest:integer);
begin
    setQueststep(uSource, 3);
    additemquest(uSource, '药方q5005s3', 1);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5005, 3));
    menusay(uSource, '速去速回，老母病的很重！^^'
        + '<〖退出〗/@exit>');
end;

procedure QuestGive2(uSource, uDest:integer);
var
    name            :string;
    count           :integer;
begin
    if GetItemQuestCount(uSource, '兽心q5005s3') < 1 then
    begin
        Menusay(uSource, '还没收集到？侠士可要抓紧啊,人命关天!'
            + '<〖退出〗/@exit>');
        exit;
    end;

    if getitemspace(uSource) < 2 then
    begin
        Menusay(uSource, '背包至少需要2个空位'
            + '<〖退出〗/@exit>');
        exit;
    end;
    //删除任务品
    DelItemQuestID(uSource, 5005);
    //设置完成任务
    setQuestNo(uSource, 5005);
    setQuestCurrentNo(uSource, 0);
    setQueststep(uSource, 0);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5006, 0));

    //发放奖励
    //1-5号位置装备
    getQuestMainItem(5005, Random(5) + 1, name, count);
    addItemEx(uSource, name, '药材商', 3, 0, 0, 0, 0, 0);

    //0位置，钱
    getQuestMainItem(5005, 0, name, count);
    additem(uSource, name, count);

    menusay(uSource,
        + '果真是野兽之心。事实上野兽之心并不是给老^'
        + '母治病用的，而是要考验你是否有能力完成大^'
        + '人下达的任务。三年前最后见到大人时她交给^'
        + '我一封信，凡是能通过任务的人才有资格获得^'
        + '她留下来的奖励.现在就送给你!^^'
        + '<〖谢谢！但大人是谁?〗/@askBoss>');

end;

procedure askBoss(uSource, uDest:integer);
begin
    menusay(uSource,
        '请恕我现在还不能说。想了解事情的真相就去^'
        + '找北海雪原的老板娘吧。她也许能够解开你的^'
        + '疑问.^^'
        + '<〖我这就去〗/@exit>^^'
        + '<〖退出〗/@exit>'
        );
end;

