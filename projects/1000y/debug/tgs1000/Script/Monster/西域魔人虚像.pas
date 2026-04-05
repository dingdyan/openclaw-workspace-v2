{******************************************************************************
创建人:何永安
创建时间:2009.11.6
实现功能:
西域魔人任务和南帝王任务
修改人：杨李
修改时间：2009.11.17
修改内容：完善任务
******************************************************************************}
const
    CON_EnergyLevel = 8;           //元气境界限制
    CON_Age         = 3000;        //年龄限制

procedure OnMenu(uSource, uDest:integer);
var
    Level, age, prestige:integer;
    ComQuestID      :integer;
    CurQuestID      :integer;
    CurQuestStep    :integer;
begin
    Level := getEnergyLevel(uSource);
    age := getage(uSource);
    ComQuestID := getQuestNo(uSource);
    CurQuestID := getQuestCurrentNo(uSource);
    CurQuestStep := getQuestStep(uSource);

    if ComQuestID <> 5006 then
    begin
        Menusay(uSource, '没事别来烦我，忙着呢！');
        exit;
    end;

    if level < CON_EnergyLevel then
    begin
        menusay(uSource, '境界尚浅，至少要无上武念境界才能胜任！');
        exit;
    end;

    if age < CON_Age then
    begin
        menusay(uSource, '年纪尚轻，至少30岁才能胜任！');
        exit;
    end;

    case CurQuestID of
        0:
            begin
                menusay(uSource, '噢?你是怎么认识本人的?啊...是老板娘推荐^'
                               + '来的原来如此.你就是收了两大魔头的大英雄.^'
                               + '我替众人感谢你.但是你有所不知, 除了东天^'
                               + '和北霸还有个南帝.这魔头一日不除, 百姓就^'
                               + '一日不得安宁.拜托英雄, 杀了南帝.^^'
                    + '<〖这是我应该做的〗/@q5007_j>^^'
                    + '<〖我还有别的事〗/@exit>');
            end;
        5007:
            begin
                menusay(uSource, '还没擒住？加把劲儿啦.');
            end;
    else
        begin
            Menusay(uSource, '没事别来烦我，忙着呢！');
        end;
    end;
end;

procedure q5007_j(uSource, uDest:integer);
begin
    setQuestCurrentNo(uSource, 5007);
    setQuestStep(uSource, 1);      //设置步骤号
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5007, 1));
end;

