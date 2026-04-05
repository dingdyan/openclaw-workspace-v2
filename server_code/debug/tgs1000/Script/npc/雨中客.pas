{*******************************************************************
创建人：何永安
创建时间：2009-11-4
功能：主线任务
修改人：何永安
修改时间：2009.11.16
修改功能：主线任务号5002 王陵寻宝
********************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    if getQuestNo(uSource) <> 5001 then
    begin
        Menusay(uSource, '我没有什么可以帮助你的^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    if getEnergyLevel(uSource) < 3 then
    begin
        Menusay(uSource, '你的境界修为要在玄妙境以上才能胜任^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    if getage(uSource) < 3000 then
    begin
        Menusay(uSource, '你的年龄要在30以上才能胜任^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    case getQuestCurrentNo(uSource) of
        0:
            begin
                Menusay(uSource, '新罗帝王陵被忍王一伙入侵了，他们抢走的玉^'
                    + '玺与新罗金冠。^'
                    + '侠士你能否帮我找到新罗先帝的遗物？^^'
                    + '<〖接受委任〗/@q5002_1_j>^^'
                    + '<〖退出〗/@exit>^^');
            end;
        5002:
            begin
                case getQuestStep(uSource) of
                    1:Menusay(uSource, '侠士你回来了？找到了没？^^'
                            + '<〖递上宝物〗/@q5002_1_g>^^'
                            + '<〖退出〗/@exit>^^');
                else
                    Menusay(uSource, '任务错误，请重置该任务^^'
                        + '<〖重置〗/@q5002_GiveUP>^^'
                        + '<〖退出〗/@exit>^^');
                end;
            end;
    else
        begin
            Menusay(uSource, '任务错误，请重置该任务^^'
                + '<〖重置〗/@q5002_GiveUP^^>'
                + '<〖退出〗/@exit>^^');
        end;
    end;
end;

procedure q5002_GiveUP(uSource, uDest);
begin
    DelItemQuestID(uSource, 5002);
    setQuestCurrentNo(uSource, 0);
    setQuestStep(uSource, 0);

    menusay(uSource, '任务重置成功，请重新接任务^^'
        + '<〖退出〗/@exit>^^');
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5002, 0));
end;

procedure q5002_1_j(uSource, uDest:integer);
begin
    //DelItemQuestID(uSource, 5002);
    addItemQuest(uSource, '地形图q5002s1', 1);

    setQuestCurrentNo(uSource, 5002);
    setQuestStep(uSource, 1);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5002, 1));
end;

procedure q5002_1_g(uSource, uDest:integer);
var
    count           :integer;
    name            :string;
begin
    if GetItemQuestCount(uSource, '玉玺q5002s1') < 1 then
    begin
        Menusay(uSource, '还没找到玉玺?^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    if GetItemQuestCount(uSource, '金冠q5002s1') < 1 then
    begin
        Menusay(uSource, '还没找到新罗金冠？^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    if getitemspace(uSource) < 2 then
    begin
        menusay(uSource, '背包至少留2个背包位置!^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //删除任务物品
    DelItemQuestID(uSource, 5002);

    //添加任务奖励
    //1-5号位置装备
    getQuestMainItem(5002, Random(5) + 1, name, count);
    addItemEx(uSource, name, '雨中客', 3, 0, 0, 0, 0, 0);

    //0位置，钱
    getQuestMainItem(5002, 0, name, count);
    additem(uSource, name, count);

    //设置任务信息
    setQuestNo(uSource, 5002);
    setQuestCurrentNo(uSource, 0);
    setQuestStep(uSource, 0);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5003, 0));

    menusay(uSource, '非常感谢你将新罗帝王的遗物找回来!^^'
        + '<〖不客气〗/@exit>^^');
end;

