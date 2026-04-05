{******************************************************************************
创建人:田莉
创建时间:2009.07
修改时间:2009.08.06
实现功能:
   100：引导新、老玩家进入游戏

   //已验证
         ID 99被虚似任务占用(门派管理员：领取福利)，不能再使用
       98被虚似任务占用(奖励发放员：门票任务)，不能再使用
      全局变量：1、2、3已被使用（奖励发放员），不能再使用
      个人变量：1已被使用（上线时修复元气），不能再使用
******************************************************************************}
//点击NPC时触发

procedure OnMenu(uSource, uDest:integer);
var
    int1            :integer;
begin
    int1 := getQuestCurrentNo(uSource); //获取当前任务ID
    case int1 of
        0:
            begin
                if getQuestNo(uSource) <> 0 then //获取已完成任务ID
                begin
                    Menusay(uSource, '请使用ALT+R热键打开任务列表，^' //NPC说话列表
                        + '查看有没有最新的任务信息。^^');
                    exit;
                end;
                Menusay(uSource, '欢迎来到千年之前的精武时代,你怎么没穿衣服。^^' //NPC说话列表
                    + '    <〖我是浪人，没得钱〗/@Quest>^^ '
                    + '    <〖被人打劫身无分文〗/@Quest> ');
            end;
        100:
            begin
                if getQueststep(uSource) <> 0 then //获取任务步骤
                begin
                    Menusay(uSource, '请使用ALT+R热键打开任务列表，^' //NPC说话列表
                        + '查看有没有最新的任务信息。');
                    exit;
                end;
                Menusay(uSource, '看你还是很有休养的人，那你去见见药王，^' //NPC说话列表
                    + '他一定会喜欢你。去的时候使用『无名步法』，^'
                    + '会快一点。^^'
                    + '    <〖好的〗/@Quest_100_1>^^');
            end;
    else Menusay(uSource, '请使用ALT+R热键打开任务列表，^' //NPC说话列表
            + '查看有没有最新的任务信息。');
    end;
end;

procedure Quest(uSource, uDest:integer);
begin
    Menusay(uSource, '看你这么可怜，正好我这儿有不要的衣服想扔^' //NPC说话列表
        + '了，干脆给你遮下羞。^'
        + '【新手提示：逐步完成新手任务可获得任务奖励】 ^^'
        + '    <〖好的，谢谢〗/@Quest_100_0>^^');
end;
//接受 任务100 步骤0

procedure Quest_100_0(uSource, uDest:integer);
var
    sex             :integer;
    asexname        :string;
begin
    if getitemspace(uSource) < 3 then //获取背包空位
    begin
        Menusay(uSource, '物品栏空位不足，请留出3个空位。');
        exit;
    end;
    asexname := '';
    Sex := getsex(uSource);        //性别 返回1是男 返回2是女
    case sex of
        1:asexname := '男子';
        2:asexname := '女子';
    end;

    { if additem(uSource, asexname + '浪人道袍', 1) = false then //发放 东西
     begin
       Menusay(uSource, '发放物品失败。');
       exit;
     end;

     if additem(uSource, asexname + '束发', 1) = false then //发放 东西
     begin
       Menusay(uSource, '发放物品失败。');
       exit;
     end;

     if additem(uSource, asexname + '一级浪人裤', 1) = false then //发放 东西
     begin
       Menusay(uSource, '发放物品失败。');
       exit;
     end;

     saysystem(uSource, '获得任务奖励：浪人道袍1件、束发1个、一级浪人裤1条'); //系统消息
     }
    setQuestCurrentNo(uSource, 100); //设置任务ID
    setQueststep(uSource, 0);      //设置任务步骤

    OnMenu(uSource, uDest);        //调用OnNpcMenu这个过程
end;
//接受 任务100 步骤1

procedure Quest_100_1(uSource, uDest:integer);
begin
    setQueststep(uSource, 1);      //设置任务步骤
    saysystem(uSource, '接到：新手任务'); //系统消息
    saysystem(uSource, '任务提示：' + getQuestSubRequest(100, 1)); //系统消息
end;

