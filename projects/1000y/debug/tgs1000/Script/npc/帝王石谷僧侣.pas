{*********************************************************************
主要功能：
1.描述任务剧情
2.竹筒换大型竹筒
修改人：杨李
功能：5007任务
*********************************************************************}

procedure OnMenu(uSource, uDest:integer);
var
    CurQuestNo      :Integer;
    CurQuestStep    :integer;
begin

    CurQuestNo := getQuestCurrentNo(uSource);
    CurQuestStep := getQuestStep(uSource);

    if CurQuestNo <> 5007 then
    begin
        menusay(uSource, '我没什么可以帮助你的^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    if CurQuestStep = 2 then
    begin
        Menusay(uSource, '你是来调查西域魔人的？听我慢慢跟你讲。当^'
            + '年南帝王，东天王和北霸王他们3人都是江湖^'
            + '上响当当的人物，而西域魔人是貌美如花的小^'
            + '女子。那3人为了得到她的芳心，各个都把自^'
            + '己的独门武功教给了她，她的实力一天一天变^'
            + '强。突然有一天，她走火入魔，魔性大发。把^'
            + '南帝王打伤困在了帝王石谷，将东天王封在东^'
            + '海沼泽，而北霸王也被压在了北海雪原。她之^'
            + '所以一直年轻，是因为每天要吸取一个年轻姑^'
            + '娘的灵气.^^'
            + '<〖原来如此〗/@q5007_2>'
            + '<〖退出〗/@exit>');
    end else if CurQuestStep = 1 then
    begin
        menusay(uSource, '我没什么可以帮助你的^^'
            + '<〖退出〗/@exit>');
    end else
    begin
        Menusay(uSource, '我知道的都告诉你了^^'
            + '<〖退出〗/@exit>');
    end;
end;

procedure q5007_2(uSource, uDest:integer);
begin
    setQuestStep(uSource, 3);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(5007, 3));
end;

