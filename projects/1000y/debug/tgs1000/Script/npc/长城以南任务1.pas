{*************************************************************
创建人：何永安
创建时间：2009-11-4
功能：任务管理员
**************************************************************}
const
    //任务1的一些信息
    C_p_Age         = 100;         //限制条件 年龄
    C_p_Energy      = 1;           //限制条件 元气境界
    C_p_ID          = 8001;        //任务ID
    C_p_ItemPre     = '令牌8001';  //前驱任务品
    C_p_Item        = '头颅8001';  //任务真是物品
    C_p_ItemPreView = '缉拿令牌';  //前驱任务品显示名字
    C_p_ItemView    = '忍者头颅';  //任务物品显示名字
    C_p_ItemSum     = 15;          //任务物品个数
    C_p_Reward      = 10;          //任务奖励
    C_p_Multiple    = 2;           //奖励倍数
    C_p_MenuName    = '剿灭忍者1'; //任务名字
    C_p_Des         = '一群可恶的忍者，目无王法，鱼肉百姓。^'
        + '你能帮我去消灭他们吗？'; //接任务描述
    C_p_Des_end     = '那么快就回来了，消灭他们了吗？'; //交任务描述
    C_p_Des_help    = '任务要求：出入境或更高^'
        + '任务奖励：荣誉^'
        + '任务规则：该任务每天只能重复做10次，^'
        + '重复次数越多，奖励越多^'; //任务帮助
    //任务2的一些信息
    C_x_Energy      = 1;           //限制条件 元气境界
    C_x_ID          = 8201;        //任务ID
    C_x_ItemPre     = '令牌8201';  //前驱任务品
    C_x_Item        = '头颅8201';  //任务物品
    C_x_ItemPreView = '缉拿令牌';  //前驱任务品显示名字
    C_x_ItemView    = '忍者头颅';  //任务物品显示名字
    C_x_ItemSum     = 15;          //任务物品个数
    C_x_Reward      = 5000000;     //任务奖励
    C_x_Multiple    = 2;           //奖励倍数
    C_x_MenuName    = '剿灭忍者2'; //任务名字
    C_x_Des         = '一群可恶的忍者，目无王法，鱼肉百姓。^'
        + '你能帮我去消灭他们吗？'; //接任务描述
    C_x_Des_end     = '那么快就回来了，消灭他们了吗？'; //交任务描述
    C_x_Des_Help    = '任务要求：出入境或更高^'
        + '任务奖励：武功经验^'
        + '任务规则：该任务每天只能重复做10次，^'
        + '重复次数越多，奖励越多^'; //任务帮助

    C_m_Energy      = 1;           //限制条件 元气境界
    C_m_ID          = 8101;        //任务ID
    C_m_ItemPre     = '令牌8101';  //前驱任务品
    C_m_Item        = '首级8101';  //任务物品
    C_m_ItemPreView = '缉拿令牌';
    C_m_ItemView    = '忍者首级';
    C_m_ItemSum     = 15;          //任务物品个数
    C_m_Reward      = 10000;       //任务奖励
    C_m_Multiple    = 2;           //奖励倍数
    C_m_MenuName    = '剿灭忍者3'; //任务名字
    C_m_Des         = '一群可恶的忍者，目无王法，鱼肉百姓。^'
        + '你能帮我去消灭他们吗？'; //接任务描述
    C_m_Des_end     = '我交给你的任务完成得怎么样了？'; //交任务描述
    C_m_Des_help    = '任务要求：出入境或更高^'
        + '任务奖励：钱币^'
        + '任务规则：该任务每天只能重复做10次，^'
        + '重复次数越多，奖励越多^'; //任务帮助

procedure OnMenu(uSource, uDest:integer);
begin
    if (GetQuestCurrentNo(uSource) = 4950) then
    begin
        if (GetQuestStep(uSource) = 6) then
        begin
            Menusay(uSource, '动乱之世，欢迎各位侠士前来帮助平乱！^^'
                + '<〖拜访任务〗/@SeeYou>^^'
                + '<〖每日任务〗/@SubMenu>^^'
                + '<〖退出〗/@exit>');
            exit;
        end;
    end;

    Menusay(uSource, '动乱之世，欢迎各位侠士前来帮助平乱！^^'
        + '<〖每日任务〗/@SubMenu>^^'
        + '<〖退出〗/@exit>');
end;

procedure SeeYou(uSOurce, uDest:integer);
var
    ComQuestId, CurQuestId, CurQuestStep:integer;
begin
    ComQuestId := GetQuestNo(uSOurce);
    if ComQuestId > 4900 then
    begin
        Menusay(uSOurce, '别来烦我，没看见我正忙着吗？^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    CurQuestId := GetQuestCurrentNo(uSource);
    case CurQuestId of
        4950:
            begin
                CurQuestStep := GetQuestStep(uSource);
                if CurQuestStep = 6 then
                begin
                    Menusay(uSource, '很高兴认识你啊，我这儿有很多平魔，钱粮，^'
                        + '经验任务等着你呢，有空的话一定要来找我！^'
                        + '既然你第一次来，那我就送你点小礼品吧^^'
                        + '<〖谢谢〗/@q4950_thanks>^^'
                        + '<〖返回〗/@OnMenu>^^'
                        + '<〖退出〗/@exit>');
                end else
                begin
                    Menusay(uSOurce, '拜访其他人了吗？^^'
                        + '<〖返回〗/@OnMenu>^^'
                        + '<〖退出〗/@exit>');
                end;

            end;
    else
        begin
            Menusay(uSOurce, '别来烦我，没看见我正忙着吗？^^'
                + '<〖返回〗/@OnMenu>^^'
                + '<〖退出〗/@exit>');
        end;
    end;

end;

procedure q4950_thanks(uSource, uDest:integer);
var
    Magicname       :string;
begin

    if getItemSpace(uSource) < 2 then
    begin
        Menusay(uSource, '背包空位不足，请留出2个位置！^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    Magicname := getuserAttackMagic(uSource);
    if Magicname = '' then
    begin
        Menusay(uSource, '我将奖励你一点攻击武功经验^'
            + '请重新选择武功！^^'
            + '<〖确定〗/@exit>^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    Menusay(uSource, '我将奖励你一点武功经验^'
        + '你的当前武功是：' + Magicname + '^'
        + '你确定要加到该武功上吗？^^'
        + '<〖确定〗/@tianjia>^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');

end;

procedure tianjia(uSource, uDest:integer);
var
    Magicname, aname, notice:string;
    magicExp, i, acount:integer;
begin
    if getItemSpace(uSource) < 2 then
    begin
        Menusay(uSource, '背包空位不足，请留出2个位置！^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    Magicname := getuserAttackMagic(uSource);
    if getMagicLevel(usource, Magicname) >= 9999 then //获取武功等级
    begin
        Menusay(uSource, '该武功已达最高级，不能增加经验！请选择:^^'
            + '<〖选择其他武功〗/@exit>^^'
            + '<〖放弃武功经验〗/@getOther>^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    magicExp := getMagicExp(uSource, Magicname);
    if (magicExp + 5000000) > 1085138172 then
    begin
        magicExp := 1085138172 - magicExp;

    end else magicExp := 5000000;
    AddMagicExp(uSource, Magicname, magicExp);

    i := getprestige(uSource);
    setprestige(uSource, i + 20);

    setQuestStep(uSOurce, 7);
    notice := getQuestSubRequest(4950, 7);
    saysystem(uSource, '任务提示：' + notice);
    if getQuestSubItem(4950, 6, 0, aname, acount) = false then exit;
    additem(uSource, aname, acount);
    saysystem(uSource, '获得任务奖励：钱币:10000,荣誉:20,经验：' + inttostr(magicExp));
    Menusay(uSOurce, '快去' + notice + '^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');
end;

procedure getOther(uSource, uDest:integer);
var
    i               :integer;
    aname           :string;
    acount          :integer;
begin
    if getQuestSubItem(4950, 6, 0, aname, acount) = false then exit;
    additem(uSource, aname, acount);
    i := getprestige(uSource);
    setprestige(uSource, i + 20);
    saysystem(uSource, '获得任务奖励：钱币:10000,荣誉:20');
    setQuestStep(uSOurce, 7);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(4950, 7));
    Menusay(uSOurce, '快去' + getQuestSubRequest(4950, 7) + '^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');

end;

procedure SubMenu(uSource, uDest:integer);
var
    CurEnergyValue, i:integer;
begin
    CurEnergyValue := getEnergyLevel(uSource);
    i := getAge(uSource);
    if (CurEnergyValue >= C_p_Energy) and (i >= C_p_Age) then
    begin
        Menusay(uSource, '动乱之世，欢迎各位侠士前来帮助平乱！^^'
            + '<〖平魔任务〗/@qMenu_p>^^'
            + '<〖修炼任务〗/@qMenu_x>^^'
            + '<〖钱粮任务〗/@qMenu_m>^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>^^');
    end else
    begin
        Menusay(uSource, '你的武功修为还很低，恐怕不能胜任吧！^^'
            + '<〖平魔任务帮助〗/@qMenu_Help_p>^^'
            + '<〖修炼任务帮助〗/@qMenu_Help_x>^^'
            + '<〖钱粮任务帮助〗/@qMenu_Help_m>^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>^^');
    end;
end;
//////////////////////////////////////////

procedure qMenu_p(uSource, uDest:integer);
var
    i               :integer;
begin
    i := getRegSubQuestIdCount(uSource, C_p_ID);
    if i >= 10 then
    begin
        Menusay(uSource, '明天再来吧，每天只能重复做10次^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    Menusay(uSource, '动乱之世，欢迎各位侠士前来帮助平乱！^^'
        + '<〖' + C_p_MenuName + '〗/@qMenu_p_0>^^'
        + '<〖平魔任务帮助〗/@qMenu_Help_p>^^'
        + '<〖返回〗/@SubMenu>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_Help_p(uSource, uDest:integer);
begin
    Menusay(uSource, C_p_Des_Help + '^^'
        + '<〖返回〗/@SubMenu>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_p_0(uSource, uDest:integer);
var
    CurQuestID      :integer;
begin
    CurQuestID := getSubQuestCurrentNo(uSource);

    case CurQuestID of
        0:
            begin
                Menusay(uSource, C_p_Des + '^^'
                    + '<〖接受〗/@qMenu_p_j>^^'
                    + '<〖返回〗/@qMenu_p>^^'
                    + '<〖退出〗/@exit>^^');
            end;
        C_p_ID:
            begin
                Menusay(uSource, C_p_Des_end + '^^'
                    + '<〖递上任务凭证〗/@qMenu_p_1>^^'
                    + '<〖取消任务〗/@qMenu_p_del>^^'
                    + '<〖返回〗/@qMenu_p>^^'
                    + '<〖退出〗/@exit>^^');
            end;
    else
        begin
            Menusay(uSource, '我没什么可帮你的.^^'
                + '<〖返回〗/@SubMenu>^^'
                + '<〖退出〗/@exit>^^');
        end;
    end;

end;

procedure qMenu_p_delok(uSource, uDest:integer);
begin
    setSubQuestCurrentNo(uSource, 0);
    setSubQueststep(uSource, 0);
    DelItemQuestID(uSource, C_p_ID);
    Menusay(uSource, '做事不能半途而废，你去反省反省！^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_p_del(uSource, uDest:integer);
begin
    Menusay(uSource, '你真的要取消本次任务？^^'
        + '<〖确认取消〗/@qMenu_p_delok>^^'
        + '<〖返回〗/@qMenu_p>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_p_j(uSource, uDest:integer);
var
    i               :integer;
begin
    setSubQuestCurrentNo(uSource, C_p_ID);
    setSubQueststep(uSource, 1);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(C_p_ID, 1));
    AddItemQuest(uSource, C_p_ItemPre, 1);

    i := getRegSubQuestIdCount(uSource, C_p_ID);
    Menusay(uSource, '第' + IntToStr(i + 1) + '次接受任务，已完成' + IntToStr(i) + '次任务^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_p_1(uSource, uDest:integer);
var
    i, j            :integer;
begin
    //检查物品
    i := GetItemQuestCount(uSource, C_p_Item);
    if i < C_p_ItemSum then
    begin
        Menusay(uSource, '你没有足够的' + C_p_ItemView + '^^'
            + '<〖返回〗/@qMenu_p>^^'
            + '<〖退出〗/@exit>^^');
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

    if getRegSubQuestIdCount(uSource, C_p_ID) <= 0 then
    begin
        setRegSubQuest(uSource, C_p_ID, 1440);
    end
    else
    begin
        SubQuestRegAdd(uSource, C_p_ID);
    end;
    i := getRegSubQuestIdCount(uSource, C_p_ID);
    Menusay(uSource, '第' + inttostr(i) + '次任务完成，获得荣誉值：' + inttostr(j) + '^^'
        + '<〖返回〗/@qMenu_p>^^'
        + '<〖退出〗/@exit>^^');
end;
////////////////////////

procedure qMenu_x(uSource, uDest:integer);
var
    i               :integer;
begin
    i := getRegSubQuestIdCount(uSource, C_x_ID);
    if i >= 10 then
    begin
        Menusay(uSource, '明天再来吧，每天只能重复做10次^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    Menusay(uSource, '动乱之世，欢迎各位侠士前来帮助平乱！^^'
        + '<〖' + C_x_MenuName + '〗/@qMenu_x_0>^^'
        + '<〖修炼任务帮助〗/@qMenu_Help_x>^^'
        + '<〖返回〗/@SubMenu>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_Help_x(uSource, uDest:integer);
begin
    Menusay(uSource, C_x_Des_Help + '^^'
        + '<〖返回〗/@SubMenu>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_x_0(uSource, uDest:integer);
var
    CurQuestID      :integer;
begin
    CurQuestID := getSubQuestCurrentNo(uSource);

    case CurQuestID of
        0:
            begin
                Menusay(uSource, C_x_Des + '^^'
                    + '<〖接受〗/@qMenu_x_j>^^'
                    + '<〖返回〗/@qMenu_x>^^'
                    + '<〖退出〗/@exit>^^');
            end;
        C_x_ID:
            begin

                Menusay(uSource, C_x_Des_end + '^^'
                    + '<〖递上任务凭证〗/@qMenu_x_1>^^'
                    + '<〖取消任务〗/@qMenu_x_del>^^'
                    + '<〖返回〗/@qMenu_x>^^'
                    + '<〖退出〗/@exit>^^');
            end;
    else
        begin
            Menusay(uSource, '我没什么可帮你的.^^'
                + '<〖返回〗/@SubMenu>^^'
                + '<〖退出〗/@exit>^^');
        end;
    end;

end;

procedure qMenu_x_delok(uSource, uDest:integer);
begin
    setSubQuestCurrentNo(uSource, 0);
    setSubQueststep(uSource, 0);
    DelItemQuestID(uSource, C_x_ID);
    Menusay(uSource, '做事不能半途而废，你去反省反省！^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_x_del(uSource, uDest:integer);
begin
    Menusay(uSource, '你真的要取消本次任务？^^'
        + '<〖确认取消〗/@qMenu_x_delok>^^'
        + '<〖返回〗/@qMenu_x>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_x_j(uSource, uDest:integer);
var
    i               :integer;
begin
    setSubQuestCurrentNo(uSource, C_x_ID);
    setSubQueststep(uSource, 1);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(C_x_ID, 1));
    AddItemQuest(uSource, C_x_ItemPre, 1);

    i := getRegSubQuestIdCount(uSource, C_x_ID);
    Menusay(uSource, '第' + IntToStr(i + 1) + '次接受任务，已完成' + IntToStr(i) + '次任务^^'
        + '<〖退出〗/@exit>^^');
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
        Menusay(uSource, '你没有足够的' + C_x_ItemView + '^^'
            + '<〖返回〗/@qMenu_x>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    str := getuserAttackMagic(uSource);
    if str = '' then
    begin
        Menusay(uSource, '当前没有攻击武功^^'
            + '<〖返回〗/@qMenu_x>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    i := getMagicLevel(uSource, str);
    if i >= 9999 then
    begin
        Menusay(uSource, '当前武功已满级^^'
            + '<〖返回〗/@qMenu_x>^^'
            + '<〖退出〗/@exit>^^');
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

    if j > 1100000000 then j := 1100000000 - i else j := k;
    AddMagicExp(uSource, str, j);
    //saysystem(uSource, '获得经验：' + IntToStr(j));

    DelItemQuestID(uSource, C_x_ID);
    setSubQuestCurrentNo(uSource, 0);
    setSubQueststep(uSource, 0);

    if getRegSubQuestIdCount(uSource, C_x_ID) <= 0 then
    begin
        setRegSubQuest(uSource, C_x_ID, 1440);
    end
    else
    begin
        SubQuestRegAdd(uSource, C_x_ID);
    end;
    i := getRegSubQuestIdCount(uSource, C_x_ID);
    Menusay(uSource, '第' + inttostr(i) + '次任务完成，获得武功经验:' + inttostr(k div 10000) + '^^'
        + '<〖返回〗/@qMenu_x>^^'
        + '<〖退出〗/@exit>^^');
end;

/////////////////////////

procedure qMenu_m(uSource, uDest:integer);
var
    i               :integer;
begin
    i := getRegSubQuestIdCount(uSource, C_m_ID);
    if i >= 10 then
    begin
        Menusay(uSource, '明天再来吧，每天只能重复做10次^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    Menusay(uSource, '动乱之世，欢迎各位侠士前来帮助平乱！^^'
        + '<〖' + C_m_MenuName + '〗/@qMenu_m_0>^^'
        + '<〖钱粮任务帮助〗/@qMenu_Help_m>^^'
        + '<〖返回〗/@SubMenu>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_Help_m(uSource, uDest:integer);
begin
    Menusay(uSource, C_m_Des_Help + '^^'
        + '<〖返回〗/@SubMenu>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_m_0(uSource, uDest:integer);
var
    CurQuestID      :integer;
begin
    CurQuestID := getSubQuestCurrentNo(uSource);

    case CurQuestID of
        0:
            begin
                Menusay(uSource, C_m_Des + '^^'
                    + '<〖接受〗/@qMenu_m_j>^^'
                    + '<〖返回〗/@qMenu_m>^^'
                    + '<〖退出〗/@exit>^^');
            end;
        C_m_ID:
            begin

                Menusay(uSource, C_m_Des_end + '^^'
                    + '<〖递上任务凭证〗/@qMenu_m_1>^^'
                    + '<〖取消任务〗/@qMenu_m_del>^^'
                    + '<〖返回〗/@qMenu_m>^^'
                    + '<〖退出〗/@exit>^^');
            end;
    else
        begin
            Menusay(uSource, '我没什么可帮你的.^^'
                + '<〖返回〗/@SubMenu>^^'
                + '<〖退出〗/@exit>^^');
        end;
    end;

end;

procedure qMenu_m_delok(uSource, uDest:integer);
begin
    setSubQuestCurrentNo(uSource, 0);
    setSubQueststep(uSource, 0);
    DelItemQuestID(uSource, C_m_ID);
    Menusay(uSource, '做事不能半途而废，你去反省反省！^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_m_del(uSource, uDest:integer);
begin
    Menusay(uSource, '你真的要取消本次任务？^^'
        + '<〖确认取消〗/@qMenu_m_delok>^^'
        + '<〖返回〗/@qMenu_m>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_m_j(uSource, uDest:integer);
var
    i               :integer;
begin
    setSubQuestCurrentNo(uSource, C_m_ID);
    setSubQueststep(uSource, 1);
    saysystem(uSource, '任务提示：' + getQuestSubRequest(C_m_ID, 1));
    AddItemQuest(uSource, C_m_ItemPre, 1);

    i := getRegSubQuestIdCount(uSource, C_m_ID);
    Menusay(uSource, '第' + IntToStr(i + 1) + '次接受任务，已完成' + IntToStr(i) + '次任务^^'
        + '<〖退出〗/@exit>^^');
end;

procedure qMenu_m_1(uSource, uDest:integer);
var
    i, j            :integer;
begin
    //检查物品
    i := GetItemQuestCount(uSource, C_m_Item);
    if i < C_m_ItemSum then
    begin
        Menusay(uSource, '你没有足够的' + C_m_ItemView + '^^'
            + '<〖返回〗/@qMenu_m>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    if getitemspace(uSource) < 1 then
    begin
        Menusay(uSource, '背包至少要有1个空位^^'
            + '<〖返回〗/@qMenu_m>^^'
            + '<〖退出〗/@exit>^^');
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

    if getRegSubQuestIdCount(uSource, C_m_ID) <= 0 then
    begin
        setRegSubQuest(uSource, C_m_ID, 1440);
    end
    else
    begin
        SubQuestRegAdd(uSource, C_m_ID);
    end;
    i := getRegSubQuestIdCount(uSource, C_m_ID);
    Menusay(uSource, '第' + inttostr(i) + '次任务完成，获得钱币：' + inttostr(j) + '^^'
        + '<〖返回〗/@qMenu_m>^^'
        + '<〖退出〗/@exit>^^');
end;

