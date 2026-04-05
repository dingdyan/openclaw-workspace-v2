{******************************************************************************
创建人:何永安
创建时间:2009.11.21
创建功能：主线5006号任务 弥天大谎 任务相关
*******************************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '廉价出售物品，高价收购物品^^'
        + '<〖出售〗/@buy>^^'
        + '<〖收购〗/@sell>^^'
        + '<〖任务〗/@qMenu>^^');
end;

procedure qMenu(uSource, uDest:integer);
begin
    if getQuestNo(uSource) <> 5005 then
    begin
        Menusay(uSource, '我没什么可以帮助你的^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    if getEnergyLevel(uSource) < 7 then
    begin
        menusay(uSource, '神话境或者更高境界才能胜任！^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    if getage(uSource) < 3000 then
    begin
        menusay(uSource, '年龄要在30岁以上才能胜任！^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    case getQuestCurrentNo(uSource) of
        0:
            begin
                menusay(uSource, '看样子你是药材商介绍来的吧?即使有他的介^'
                    + '绍还是要通过我的考验才能解答你的疑惑.去^'
                    + '帮我把雪参采集回来, 我就告诉你!^^'
                    + '<〖接受委任〗/@q5006_1_j>^^'
                    + '<〖退出〗/@exit>^^');
            end;
        5006:
            begin
                case getQuestStep(uSource) of
                    1:
                        begin
                            menusay(uSource, '那么快就回来了？感谢上苍。^^'
                                + '<〖递上雪参〗/@q5006_1_g>^^'
                                + '<〖退出〗/@exit>^^');
                        end;
                    2:
                        begin
                            menusay(uSource, '果然是雪参，厉害厉害。其实我是想考验一下^'
                                + '少侠的能力。大人一直想找到一个武功高强的^'
                                + '侠客，帮她收回东天王和北霸王的魂。不知少^'
                                + '侠可否帮大人完成此项任务？^^'
                                + '<〖继续询问〗/@q5006_3_w>^^');
                        end;
                    3:
                        begin
                            menusay(uSource, '那么快就回来了，他们的魂收了吗？^^'
                                + '<〖递上葫芦〗/@q5006_3_g>^^'
                                + '<〖退出〗/@exit>^^');
                        end;
                else
                    begin
                        MenuSay(uSource, '任务错误，请重置该任务^^'
                            + '<〖重置〗/@q5006_GiveUp>^^'
                            + '<〖退出〗/@exit>^^');
                    end;
                end;
            end;
    else
        begin
            MenuSay(uSource, '任务错误，请重置该任务^^'
                + '<〖重置〗/@q5006_GiveUp>^^'
                + '<〖退出〗/@exit>^^');
        end;
    end;
end;

procedure q5006_GiveUp(uSource, uDest:integer);
begin
    DelItemQuestID(uSource, 5006);
    setQuestCurrentNo(uSource, 0);
    setQueststep(uSource, 0);

    menusay(uSource, '任务重置成功，请重新接任务^^'
        + '<〖退出〗/@exit>^^');
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5006, 0));
end;

procedure q5006_1_j(uSource, uDest:integer);
begin
    //DelItemQuestID(uSource, 5006);
    addItemQuest(uSource, '空筐q5006s1', 1);

    setQuestCurrentNo(uSource, 5006);
    setQuestStep(uSource, 1);      //设置步骤号
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5006, 1));
end;

procedure q5006_1_g(uSource, uDest:integer);
begin
    if getItemQuestCount(uSource, '满筐q5006s1') < 1 then
    begin
        menusay(uSource, '雪参在哪里？^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    DelItemQuestID(uSource, 5006);
    setQuestStep(uSource, 2);      //设置步骤号

    menusay(uSource, '果然是雪参，厉害厉害。其实我是想考验一下^'
        + '少侠的能力。大人一直想找到一个武功高强的^'
        + '侠客，帮她收回东天王和北霸王的魂。不知少^'
        + '侠可否帮大人完成此项任务？^^'
        + '<〖继续询问〗/@q5006_3_w>^^');
end;

procedure q5006_3_w(uSource, uDest:integer);
begin
    menusay(uSource, '他们曾经在江湖上赫赫有名，后来练功走火入^'
        + '魔，危害百姓，大人不得已将其二人肉身封上^'
        + '，但他们二人却用分身术，继续作恶，你能否^'
        + '去把他们的魂收回来？^^'
        + '<〖接受委任〗/@q5006_3_j>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure q5006_3_j(uSource, uDest:integer);
begin
    //DelItemQuestID(uSource, 5006);
    addItemQuest(uSource, '东葫芦q5006s3', 1);
    addItemQuest(uSource, '北葫芦q5006s3', 1);
    additem(uSource, '召唤符', 2);

    setQuestStep(uSource, 3);      //设置步骤号
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5006, 3));
    menusay(uSource, '我这里有两个葫芦和两道召唤符。你把召唤符^'
        + '放到火炉上，就能召唤出他们的魂魄，然后把^'
        + '他们收到我给你的葫芦里面。^^'
        + '<〖知道了〗/@exit>^^');
end;

procedure q5006_3_g(uSource, uDest:integer);
var
    count           :integer;
    name            :string;
begin
    if (getItemQuestCount(uSource, '东魂葫芦q5006s3') < 1)
        or (getItemQuestCount(uSource, '北魂葫芦q5006s3') < 1) then
    begin
        menusay(uSource, '葫芦里好像是空的呀，赶快收了他们的魂魄^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    if getitemspace(uSource) < 3 then
    begin
        menusay(uSource, '背包至少留3个空位!^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //删除任务物品
    DelItemQuestID(uSource, 5006);

    //添加任务奖励
    //1-5号位置装备
    getQuestMainItem(5006, Random(5) + 1, name, count);
    addItemEx(uSource, name, '老板娘', 3, 0, 0, 0, 0, 0);

    //0位置，钱
    getQuestMainItem(5006, 0, name, count);
    additem(uSource, name, count);
    additem(uSource, '竹筒', 1);

    //设置任务信息
    setQuestNo(uSource, 5006);
    setQuestCurrentNo(uSource, 0);
    setQuestStep(uSource, 0);      //设置步骤号
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5007, 0));

    menusay(uSource, '果然英雄出少年，很多人都是有去无回。大人^'
        + '很想见见你，你不是也想见见大人吗？她就在^'
        + '黄金沙漠，带上这个竹筒。^^'
        + '<〖谢谢，我去了〗/@exit>');
end;

