{*************************************************************
创建人：何永安
创建时间：2009-11-4
功能：荣誉任务管理员
**************************************************************}
const
    //任务1信息
    C_p_Energy      = 1;           //限制条件 元气境界
    C_p_ID          = 8002;        //任务ID
    C_p_ItemPre     = '令牌8002';  //前驱任务品
    C_p_Item        = '头颅8002';  //任务物品
    C_p_ItemPreView = '缉拿令牌';  //前驱任务品
    C_p_ItemView    = '山贼的头颅'; //任务物品
    C_p_ItemSum     = 15;          //任务物品个数
    C_p_Reward      = 20;          //任务奖励
    C_p_Multiple    = 2;           //奖励倍数
    C_p_MenuName    = '剿灭山贼';  //任务名字
    C_p_Des         = '一群可恶的山贼，目无王法，鱼肉百姓。^'
        + '你能帮我去消灭他们吗？^'; //接任务描述
    C_p_Des_end     = '那么快就回来了，消灭他们了吗？^'; //交任务描述
    C_p_Des_Help    = '你的修为要在出入境才能胜任。^'; //交任务描述
    //任务2信息
    C_x_Energy      = 1;           //限制条件 元气境界
    C_x_ID          = 8202;        //任务ID
    C_x_ItemPre     = '令牌8202';  //前驱任务品
    C_x_Item        = '头颅8202';  //任务物品
    C_x_ItemPreView = '缉拿令牌';  //前驱任务品
    C_x_ItemView    = '山贼的头颅'; //任务物品
    C_x_ItemSum     = 15;          //任务物品个数
    C_x_Reward      = 6000000;     //任务奖励
    C_x_Multiple    = 2;           //奖励倍数
    C_x_MenuName    = '剿灭山贼2'; //任务名字
    C_x_Des         = '一群可恶的山贼，目无王法，鱼肉百姓。^'
        + '你能帮我去消灭他们吗？^'; //接任务描述
    C_x_Des_end     = '那么快就回来了，消灭他们了吗？^'; //交任务描述
    C_x_Des_help    = '你的修为要在出入境才能胜任。^'; //交任务描述

    C_m_Energy      = 1;           //限制条件 元气境界
    C_m_ID          = 8102;        //任务ID
    C_m_ItemPre     = '令牌8102';  //前驱任务品
    C_m_Item        = '首级8102';  //任务物品
    C_m_ItemPreView = '缉拿令牌';
    C_m_ItemView    = '老虎首级';
    C_m_ItemSum     = 10;          //任务物品个数
    C_m_Reward      = 20000;       //任务奖励
    C_m_Multiple    = 2;           //奖励倍数
    C_m_MenuName    = '打虎英雄';  //任务名字
    C_m_Des         = '北边老虎经常下山做乱，你能除掉它们给村子^一片安宁吗^'; //接任务描述
    C_m_Des_end     = '我交给你的任务完成得怎么样了？^'; //交任务描述
    C_m_Des_help    = '你的修为要在出入境才能胜任。^'; //交任务描述

procedure OnMenu(uSource, uDest:integer);
var
    CurEnergyValue  :integer;
begin
    CurEnergyValue := getEnergyLevel(uSource);
    if CurEnergyValue >= C_p_Energy then
    begin
        Menusay(uSource, '动乱之世，欢迎各位侠士前来帮助平乱！^'
            + '^<〖平魔任务〗/@qMenu_p>'
            + '^<〖修炼任务〗/@qMenu_x>'
            + '^<〖钱粮任务〗/@qMenu_m>'
            + '^<〖退出〗/@exit>');
    end else
    begin
        Menusay(uSource, '你的武功修为还很低，恐怕不能胜任吧！^'
            + '^<〖平魔任务帮助〗/@qMenu_Help_p>'
            + '^<〖修炼任务帮助〗/@qMenu_Help_x>'
            + '^<〖钱粮任务帮助〗/@qMenu_Help_m>'
            + '^<〖退出〗/@exit>');
    end;
end;
//////////////////////////////////////////

procedure qMenu_p(uSource, uDest:integer);
begin
    Menusay(uSource, '动乱之世，欢迎各位侠士前来帮助平乱！^'
        + '^<〖' + C_p_MenuName + '〗/@qMenu_p_0>'
        + '^<〖平魔任务帮助〗/@qMenu_Help_p>'
        + '^<〖退出〗/@exit>');
end;

procedure qMenu_Help_p(uSource, uDest:integer);
begin
    Menusay(uSource, C_p_Des_Help
        + '^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure qMenu_p_0(uSource, uDest:integer);
var
    CurQuestID      :integer;
begin
    CurQuestID := getSubQuestCurrentNo(uSource);

    case CurQuestID of
        0:
            begin
                Menusay(uSource, C_p_Des
                    + '^<〖接受〗/@qMenu_p_j>'
                    + '^<〖返回〗/@qMenu_p>'
                    + '^<〖退出〗/@exit>');
            end;
        C_p_ID:
            begin
                Menusay(uSource, C_p_Des_end
                    + '^<〖递上任务凭证〗/@qMenu_p_1>'
                    + '^<〖取消任务〗/@qMenu_p_del>'
                    + '^<〖返回〗/@qMenu_p>'
                    + '^<〖退出〗/@exit>');
            end;
    else
        begin
            Menusay(uSource, '我没什么可帮你的.^'
                + '^<〖返回〗/@OnMenu>'
                + '^<〖退出〗/@exit>');
        end;
    end;

end;

procedure qMenu_p_delok(uSource, uDest:integer);
begin
    setSubQuestCurrentNo(uSource, 0);
    setSubQueststep(uSource, 0);
    DelItemQuestID(uSource, C_p_ID);
    Menusay(uSource, '做事不能半途而废，你去反省反省！^'
        + '^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure qMenu_p_del(uSource, uDest:integer);
begin
    Menusay(uSource, '你真的要取消本次任务？^'
        + '^<〖确认取消〗/@qMenu_p_delok>'
        + '^<〖返回〗/@qMenu_p>'
        + '^<〖退出〗/@exit>');
end;

procedure qMenu_p_j(uSource, uDest:integer);
var
    i               :integer;
begin
    i := getRegSubQuestIdCount(uSource, C_p_ID);
    if i <= 0 then
    begin
        setRegSubQuest(uSource, C_p_ID, 1440);
    end
    else
    begin
        SubQuestRegAdd(uSource, C_p_ID);
    end;
    setSubQuestCurrentNo(uSource, C_p_ID);
    setSubQueststep(uSource, 1);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(C_p_ID, 1));
    AddItemQuest(uSource, C_p_ItemPre, 1);
end;

procedure qMenu_p_1(uSource, uDest:integer);
var
    i, j            :integer;
begin
    //检查物品
    i := GetItemQuestCount(uSource, C_p_Item);
    if i < C_p_ItemSum then
    begin
        Menusay(uSource, '你没有足够的' + C_p_ItemView
            + '^^<〖返回〗/@qMenu_p>'
            + '^<〖退出〗/@exit>');
        exit;
    end;
    i := getprestige(uSource);
    j := getRegSubQuestIdCount(uSource, C_p_ID);
    if j <= 10 then
        j := j * 3 + C_p_Reward
    else
        j := (j mod 10) * 3 div C_p_Multiple + C_p_Reward;

    i := i + j;
    setprestige(uSource, i);

    DelItemQuestID(uSource, C_p_ID);
    setSubQuestCurrentNo(uSource, 0);
    setSubQueststep(uSource, 0);

    Menusay(uSource, '任务完成，获得荣誉值：' + inttostr(j)
        + '^^<〖返回〗/@qMenu_p>'
        + '^<〖退出〗/@exit>');

end;
////////////////////////

procedure qMenu_x(uSource, uDest:integer);
begin
    Menusay(uSource, '动乱之世，欢迎各位侠士前来帮助平乱！^'
        + '^<〖' + C_x_MenuName + '〗/@qMenu_x_0>'
        + '^<〖修炼任务帮助〗/@qMenu_Help_x>'
        + '^<〖退出〗/@exit>');
end;

procedure qMenu_Help_x(uSource, uDest:integer);
begin
    Menusay(uSource, C_x_Des_Help
        + '^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure qMenu_x_0(uSource, uDest:integer);
var
    CurQuestID      :integer;
begin
    CurQuestID := getSubQuestCurrentNo(uSource);

    case CurQuestID of
        0:
            begin
                Menusay(uSource, C_x_Des
                    + '^<〖接受〗/@qMenu_x_j>'
                    + '^<〖返回〗/@qMenu_x>'
                    + '^<〖退出〗/@exit>');
            end;
        C_x_ID:
            begin

                Menusay(uSource, C_x_Des_end
                    + '^<〖递上任务凭证〗/@qMenu_x_1>'
                    + '^<〖取消任务〗/@qMenu_x_del>'
                    + '^<〖返回〗/@qMenu_x>'
                    + '^<〖退出〗/@exit>');
            end;
    else
        begin
            Menusay(uSource, '我没什么可帮你的.^'
                + '^<〖返回〗/@OnMenu>'
                + '^<〖退出〗/@exit>');
        end;
    end;

end;

procedure qMenu_x_delok(uSource, uDest:integer);
begin
    setSubQuestCurrentNo(uSource, 0);
    setSubQueststep(uSource, 0);
    DelItemQuestID(uSource, C_x_ID);
    Menusay(uSource, '做事不能半途而废，你去反省反省！^'
        + '^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure qMenu_x_del(uSource, uDest:integer);
begin
    Menusay(uSource, '你真的要取消本次任务？^'
        + '^<〖确认取消〗/@qMenu_x_delok>'
        + '^<〖返回〗/@qMenu_x>'
        + '^<〖退出〗/@exit>');
end;

procedure qMenu_x_j(uSource, uDest:integer);
var
    i               :integer;
begin
    i := getRegSubQuestIdCount(uSource, C_x_ID);
    if i <= 0 then
    begin
        setRegSubQuest(uSource, C_x_ID, 1440);
    end
    else
    begin
        SubQuestRegAdd(uSource, C_x_ID);
    end;
    setSubQuestCurrentNo(uSource, C_x_ID);
    setSubQueststep(uSource, 1);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(C_x_ID, 1));
    AddItemQuest(uSource, C_x_ItemPre, 1);
end;

procedure qMenu_x_1(uSource, uDest:integer);
var
    i, j, k         :integer;
    str             :string;
begin
    //检查物品
    i := GetItemQuestCount(uSource, C_x_Item);
    if i < C_x_ItemSum then
    begin
        Menusay(uSource, '你没有足够的' + C_x_ItemView
            + '^^<〖返回〗/@qMenu_x>'
            + '^<〖退出〗/@exit>');
        exit;
    end;
    str := getuserAttackMagic(uSource);
    if str = '' then
    begin
        Menusay(uSource, '当前没有攻击武功^'
            + '^<〖返回〗/@qMenu_x>'
            + '^<〖退出〗/@exit>');
        exit;
    end;
    i := getMagicLevel(uSource, str);
    if i >= 9999 then
    begin
        Menusay(uSource, '当前武功已满级^'
            + '^<〖返回〗/@qMenu_x>'
            + '^<〖退出〗/@exit>');
        exit;
    end;
    i := getMagicExp(uSource, str);
    j := getRegSubQuestIdCount(uSource, C_x_ID);
    if j <= 10 then
        j := j * 300000 + C_x_Reward
    else
        j := (j mod 10) * 300000 div C_x_Multiple + C_x_Reward;

    k := j;
    j := i + j;

    if j > 1100000000 then j := 1100000000 - i;

    AddMagicExp(uSource, str, j);

    DelItemQuestID(uSource, C_x_ID);
    setSubQuestCurrentNo(uSource, 0);
    setSubQueststep(uSource, 0);

    Menusay(uSource, '任务完成，获得武功经验:' + inttostr(k div 10000)
        + '^^<〖返回〗/@qMenu_x>'
        + '^<〖退出〗/@exit>');

end;

/////////////////////////

procedure qMenu_m(uSource, uDest:integer);
begin
    Menusay(uSource, '动乱之世，欢迎各位侠士前来帮助平乱！^'
        + '^<〖' + C_m_MenuName + '〗/@qMenu_m_0>'
        + '^<〖平魔任务帮助〗/@qMenu_Help_m>'
        + '^<〖退出〗/@exit>');
end;

procedure qMenu_Help_m(uSource, uDest:integer);
begin
    Menusay(uSource, C_m_Des_Help
        + '^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure qMenu_m_0(uSource, uDest:integer);
var
    CurQuestID      :integer;
begin
    CurQuestID := getSubQuestCurrentNo(uSource);

    case CurQuestID of
        0:
            begin
                Menusay(uSource, C_m_Des
                    + '^<〖接受〗/@qMenu_m_j>'
                    + '^<〖返回〗/@qMenu_m>'
                    + '^<〖退出〗/@exit>');
            end;
        C_m_ID:
            begin

                Menusay(uSource, C_m_Des_end
                    + '^<〖递上任务凭证〗/@qMenu_m_1>'
                    + '^<〖取消任务〗/@qMenu_m_del>'
                    + '^<〖返回〗/@qMenu_m>'
                    + '^<〖退出〗/@exit>');
            end;
    else
        begin
            Menusay(uSource, '我没什么可帮你的.^'
                + '^<〖返回〗/@OnMenu>'
                + '^<〖退出〗/@exit>');
        end;
    end;

end;

procedure qMenu_m_delok(uSource, uDest:integer);
begin
    setSubQuestCurrentNo(uSource, 0);
    setSubQueststep(uSource, 0);
    DelItemQuestID(uSource, C_p_ID);
    Menusay(uSource, '做事不能半途而废，你去反省反省！^'
        + '^<〖返回〗/@OnMenu>'
        + '^<〖退出〗/@exit>');
end;

procedure qMenu_m_del(uSource, uDest:integer);
begin
    Menusay(uSource, '你真的要取消本次任务？^'
        + '^<〖确认取消〗/@qMenu_m_delok>'
        + '^<〖返回〗/@qMenu_m>'
        + '^<〖退出〗/@exit>');
end;

procedure qMenu_m_j(uSource, uDest:integer);
var
    i               :integer;
begin
    i := getRegSubQuestIdCount(uSource, C_m_ID);
    if i <= 0 then
    begin
        setRegSubQuest(uSource, C_m_ID, 1440);
    end
    else
    begin
        SubQuestRegAdd(uSource, C_m_ID);
    end;
    setSubQuestCurrentNo(uSource, C_m_ID);
    setSubQueststep(uSource, 1);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(C_m_ID, 1));
    AddItemQuest(uSource, C_m_ItemPre, 1);
end;

procedure qMenu_m_1(uSource, uDest:integer);
var
    i, j            :integer;
begin
    //检查物品
    i := GetItemQuestCount(uSource, C_m_Item);
    if i < C_m_ItemSum then
    begin
        Menusay(uSource, '你没有足够的' + C_m_ItemView
            + '^^<〖返回〗/@qMenu_m>'
            + '^<〖退出〗/@exit>');
        exit;
    end;

    if getitemspace(uSource) < 1 then
    begin
        Menusay(uSource, '背包至少要有1个空位^^'
            + '^<〖返回〗/@qMenu_m>'
            + '^<〖退出〗/@exit>');
        exit;
    end;

    j := getRegSubQuestIdCount(uSource, C_m_ID);
    if j <= 10 then
        j := j * 3000 + C_m_Reward
    else
        j := (j mod 10) * 3000 div C_m_Multiple + C_m_Reward;

    additem(uSource, '钱币', j);

    DelItemQuestID(uSource, C_m_ID);
    setSubQuestCurrentNo(uSource, 0);
    setSubQueststep(uSource, 0);

    Menusay(uSource, '任务完成，获得钱币：' + inttostr(j)
        + '^^<〖返回〗/@qMenu_m>'
        + '^<〖退出〗/@exit>');
end;

