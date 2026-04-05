{******************************************************************************
创建人：何永安
创建时间：2009.11.10
功能：装备的鉴定

******************************************************************************}
var
    log             = false;

procedure OnMenu(uSource, uDest:integer);
begin
    menusay(uSource, '不知客官是否知道，在江湖中，看似平平的物^'
        + '品，往往需要经过仔细揣摩之后，才能发现其^'
        + '中之奥妙，客官若有需要，可随时来找我。^^'
        + '<〖鉴定装备〗/@Menu_Jd>^'
        + '<〖鉴定装备介绍〗/@Menu_Jd_Help>^'
        + '<〖淬炼宝石〗/@Menu_Cl>^'
        + '<〖淬炼宝石介绍〗/@Menu_Cl_Help>^'
        + '<〖 任 务 〗/@Quest>^^');
end;

procedure Menu_Jd_Help(uSource, uDest:integer);
begin
    Menusay(uSOurce, '所谓鉴定就是将装备的隐藏属性挖掘出来。^'
        + '通过鉴定，装备可以获得孔数和特殊属性，^'
        + '但是需要按装备品级收取一定的费用。^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');
end;

procedure Menu_Cl_Help(uSource, uDest:integer);
begin
    Menusay(uSOurce, '所谓淬炼，就是合成宝石。^'
        + '十个相同的宝石可以淬炼出一个相同类别的下^'
        + '一等级的宝石，但会根据宝石等级收取一定费^'
        + '用。^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');
end;

procedure Quest(uSOurce, uDest:integer);
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
                if CurQuestStep = 11 then
                begin
                    Menusay(uSource, '很高兴认识你啊，我这儿可以鉴定各种装备，^'
                        + '需要的话随时可以找我！既然你来拜访我，那^'
                        + '我就送你点小礼物吧^^'
                        + '<〖谢谢〗/@q4950_j12>^^'
                        + '<〖返回〗/@OnMenu>^^'
                        + '<〖退出〗/@exit>');
                end else
                begin
                    Menusay(uSOurce, '你都拜访了吗？^^'
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

procedure q4950_j12(uSource, uDest:integer);
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

    setQuestStep(uSOurce, 12);
    notice := getQuestSubRequest(4950, 12);
    saysystem(uSource, '任务提示：' + notice);

    if getQuestSubItem(4950, 11, 0, aname, acount) = false then exit;
    additem(uSource, aname, acount);

    if getQuestSubItem(4950, 11, 1, aname, acount) = false then exit;
    additem(uSource, aname, acount);
    saysystem(uSource, '获得任务奖励：钱币:1000,天桃:20');
    Menusay(uSOurce, '快去' + notice + '^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');
end;

//鉴定主菜单

procedure Menu_Jd(uSource, uDest:integer);
begin
    menusay(uSource, '未鉴定过的装备才能进行鉴定，请把你要鉴定^'
        + '的物品放入左下角物品框里，手续费由装备的^'
        + '品级而定。^^'
        + '              <〖装备鉴定〗/@Jd_Begin>'
        + '              <〖放弃鉴定〗/@exit>');
    ItemInputWindowsOpen(uSource, 0, '装备栏', '请放入要鉴定的装备');
    setItemInputWindowsKey(uSource, 0, -1);
end;

procedure Jd_Begin(uSource, uDest:integer);
var
    aItemKey,                      //装备在背包的位置
    akind,                         //物品的类型
    aWearArr,                      //装备的穿戴位置
    acount,                        //打孔的孔数
    id,                            //随机属性数
    aNeedMoney,                    //需要的钱数
    aNumber,                       //随机数
    aGrade          :integer;      //装备的品级
begin
    aItemKey := getItemInputWindowsKey(uSource, 0);

    //检查装备框是否为空
    if aitemkey < 0 then
    begin
        menusay(uSource, '请放入要鉴定的武器或者防具！^^'
            + '<〖返回〗/@Menu_Jd>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //检查物品是否为装备
    akind := getitemKind(uSource, aItemKey);
    if akind <> 6 then
    begin
        menusay(uSource, '只能鉴定武器和防具装备！^^'
            + '<〖返回〗/@Menu_Jd>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //判断部位
    aWearArr := getitemWearArr(uSource, aItemKey);
    if (aWearArr <> 8)             // 头
    and (aWearArr <> 6)            // 衣服
    and (aWearArr <> 1)            // 手
    and (aWearArr <> 9)            // 武器
    and (aWearArr <> 3) then       // 脚
    begin
        menusay(uSource, '只能鉴定武器，头盔，护腕，靴子和铠甲！^^'
            + '<〖返回〗/@Menu_Jd>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //检查品级
    aGrade := getitemGrade(uSource, aItemKey);
    if (aGrade <= 0) or (aGrade > 12) then
    begin
        menusay(uSource, '只能鉴定1至12品的武器和防具！^^'
            + '<〖返回〗/@Menu_Jd>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //检查装备是否可鉴定
    if getitemboident(uSource, aItemKey) = false then //不可以鉴定
    begin
        menusay(uSource, '该装备已经被鉴定或者不可鉴定！^^'
            + '<〖返回〗/@Menu_Jd>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //检查身上的钱
    case aGrade of
        1:aNeedMoney := 2000;
        2:aNeedMoney := 4000;
        3:aNeedMoney := 6000;
        4:aNeedMoney := 8000;
        5:aNeedMoney := 12000;
        6:aNeedMoney := 16000;
        7:aNeedMoney := 20000;
        8:aNeedMoney := 26000;
        9:aNeedMoney := 32000;
        10:aNeedMoney := 40000;
        11:aNeedMoney := 50000;
        12:aNeedMoney := 65000;
    else aNeedMoney := 65000;
    end;
    if getitemcount(uSource, '钱币') < aNeedMoney then
    begin
        menusay(uSource, '鉴定该装备需要钱币：' + inttostr(aNeedMoney) + '个^^'
            + '<〖返回〗/@Menu_Jd>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //打孔成功几率 通过穿戴部位区分
    if aWearArr = 9 then
    begin
        /////////////////////////////////武器/////////////////////////////////
        //普通武器
        if getitemSpecialKind(uSource, aItemKey) <> 3 then
        begin
            if log then worldnoticemsg('普通武器', $00FF80FF, $00000000);
            if random(50) = 25 then acount := 2 else acount := 1;
        end else
        begin
            //荣誉武器
            if log then worldnoticemsg('荣誉武器', $00FF80FF, $00000000);
            if random(25) = 12 then acount := 2 else acount := 1;
        end;
    end else
    begin
        /////////////////////////////////装备/////////////////////////////////
        //普通装备
        if getitemSpecialKind(uSource, aItemKey) <> 3 then
        begin
            if log then worldnoticemsg('普通装备', $00FF80FF, $00000000);
            aNumber := random(100);
            case aNumber of
                99:acount := 4;    //1%
                97..98:acount := 3; //2%
                96..86:acount := 2; //10%
                0..85:acount := 1; //87%
            else
                acount := 1;       //87%
            end;
        end else
        begin
            //荣誉装备几率翻倍
            if log then worldnoticemsg('荣誉装备', $00FF80FF, $00000000);
            aNumber := random(50);
            case aNumber of
                49:acount := 4;    //2%
                47..48:acount := 3; //4%
                36..46:acount := 2; //20%
                0..35:acount := 1; //76%
            else
                acount := 1;       //76%
            end;
        end;
    end;
    //给孔
    // 鉴定完
    setItemSettingCount(uSource, aItemKey, acount);

    ////////////////////////////////////////////////////////////////////////////////
    //1.先判断是否有附加属性
    //2。判断是否给特殊属性  给几个属性
    //3。是否给攻击
      //判断品级 品级不同 增加的攻击力不同

        //增加附加属性
    if random(100) > 30 then
    begin
        id := 0;
        //允许增加附加属性
        if random(100) > 50 then
            id := random(8) + 1    //ID为1-8  没有附加攻击属性的
        else
        begin
            case aGrade of
                1..3:id := random(18) + 9; //ID为9-26
                4..6:id := random(27) + 27; //27-53
                7..9:id := random(36) + 54; //54-89
                10..12:id := random(45) + 90; //90-134
            end;
        end;
        //增加附加属性
        if aWearArr <> 9 then id := id + 300;
        setitemAttach(uSource, aItemKey, id);
    end;
    //鉴定成功扣除物品
    deleteitem(uSource, '钱币', aNeedMoney);
    setitemboident(uSource, aItemKey, false);

    menusay(uSource, '恭喜你，[' + getitemname(uSource, aItemKey) + ']鉴定成功！^'
        + '消费[钱币]：' + inttostr(aNeedMoney) + '个^^'
        + '<〖返回〗/@Menu_Jd>^^'
        + '<〖退出〗/@exit>^^');
end;

/////////////////////////////////////////////////////////////

procedure Menu_Cl(uSource, uDest:integer);
var
    aItemKey        :integer;
begin
    menusay(uSource, '本店提供各种宝石的淬炼服务，侠士若有需要^'
        + '可随时来找我。请将要淬炼的宝石放到左下角^'
        + '的框里.淬炼成功后将得到下一等级的宝石。^^'
        + '              <〖淬炼〗/@Cl_Begin>'
        + '              <〖放弃〗/@exit>');
    ItemInputWindowsOpen(uSource, 0, '宝石栏', '放入要淬炼的宝石');
    setItemInputWindowsKey(uSource, 0, -1);
end;

procedure Cl_Begin(uSource, uDest:integer);
var
    aItemKey        :integer;      //背包位置
    aKind           :integer;      //宝石类型
    aName           :string;       //合成石头的名字
    aNum            :integer;
    aLevel          :integer;      //宝石等级
begin
    aItemKey := getItemInputWindowsKey(uSource, 0);
    //检查淬炼框内是否有东西
    if aItemKey <= -1 then
    begin
        menusay(uSource, '请放入要淬炼的宝石！^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //检查是不是宝石
    aKind := getitemKind(uSource, aItemKey);
    if aKind <> 121 then
    begin
        menusay(uSource, '只能淬炼镶嵌宝石！^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //检查宝石等级
    aLevel := getitemSpecialKind(uSource, aItemKey);
    if aLevel >= 5 then
    begin
        menusay(uSource, '该宝石已经是最高级的宝石了！^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //检查是否能淬炼
    aName := getitemMixName(uSource, aItemKey);
    if aName = '' then
    begin
        menusay(uSource, '该宝石不能被淬炼！^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    //检查淬炼宝石最低数量  10个
    aNum := getitemKeyCount(uSource, aItemKey);
    if aNum < 10 then
    begin
        menusay(uSource, '淬炼一次至少需要10个宝石！^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    menusay(uSource, '请选择你要淬炼的个数！^^'
        + '<〖淬炼1个〗/@Cl_1>^^'
        + '<〖淬炼5个〗/@Cl_5>^^'
        + '<〖淬炼10个〗/@Cl_10>^^'
        + '<〖淬炼全部〗/@Cl_all>^^'
        + '<〖返回〗/@Menu_Cl>^^'
        + '<〖退出〗/@exit>^');
end;

procedure Cl_1(uSource, uDest:integer);
var
    aItemKey        :integer;      //背包位置
    aLevel          :integer;      //宝石等级
    aNeedMoney      :integer;
    aNum            :integer;
    aName, str      :string;
begin
    aItemKey := getItemInputWindowsKey(uSource, 0);
    if aItemKey <= -1 then
    begin
        menusay(uSource, '请放入要淬炼的宝石！^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    aName := getitemMixName(uSource, aItemKey);
    str := getitemName(uSource, aItemKey);
    aNum := getitemKeyCount(uSource, aItemKey);
    if aNum < 10 then
    begin
        menusay(uSource, '淬炼一次至少需要10个宝石！^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    aLevel := getitemSpecialKind(uSource, aItemKey);
    case aLevel of
        1:aNeedMoney := 10000;
        2:aNeedMoney := 20000;
        3:aNeedMoney := 30000;
        4:aNeedMoney := 40000;
    else
        begin
            menusay(uSource, '该宝石等级未知！^^'
                + '<〖返回〗/@Menu_Cl>^^'
                + '<〖退出〗/@exit>^^');
            exit;
        end;
    end;

    aNeedMoney := aNeedMoney * 1;
    if getitemcount(uSource, '钱币') < aNeedMoney then
    begin
        menusay(uSource, '钱币不足，此次淬炼需要收取钱币：' + IntToStr(aNeedMoney) + '个^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    deleteItemKey(uSource, aItemKey, 10);
    deleteitem(uSource, '钱币', aNeedMoney);
    additem(uSource, aName, 1);

    menusay(uSource, '恭喜你，淬炼成功！^'
        + '获得[' + aName + ']：1个^'
        + '消耗[' + str + ']：10个^'
        + '消费[钱币]：' + IntToStr(aNeedMoney) + '个^^'
        + '<〖返回〗/@Menu_Cl>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure Cl_5(uSource, uDest:integer);
var
    aItemKey        :integer;      //背包位置
    aLevel          :integer;      //宝石等级
    aNeedMoney      :integer;
    aNum            :integer;
    aName, str      :string;
begin
    aItemKey := getItemInputWindowsKey(uSource, 0);
    if aItemKey <= -1 then
    begin
        menusay(uSource, '请放入要淬炼的宝石！^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    aName := getitemMixName(uSource, aItemKey);
    str := getitemName(uSource, aItemKey);
    aNum := getitemKeyCount(uSource, aItemKey);
    if aNum < 50 then
    begin
        menusay(uSource, '该宝石个数不足50个！^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    aLevel := getitemSpecialKind(uSource, aItemKey);
    case aLevel of
        1:aNeedMoney := 10000;
        2:aNeedMoney := 20000;
        3:aNeedMoney := 30000;
        4:aNeedMoney := 40000;
    else
        begin
            menusay(uSource, '该宝石等级未知！^^'
                + '<〖返回〗/@Menu_Cl>^^'
                + '<〖退出〗/@exit>^^');
            exit;
        end;
    end;

    aNeedMoney := aNeedMoney * 5;
    if getitemcount(uSource, '钱币') < aNeedMoney then
    begin
        menusay(uSource, '钱币不足，此次淬炼需要收取钱币：' + IntToStr(aNeedMoney) + '个^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    deleteItemKey(uSource, aItemKey, 50);
    deleteitem(uSource, '钱币', aNeedMoney);
    additem(uSource, aName, 5);
    menusay(uSource, '恭喜你，淬炼成功！^'
        + '获得[' + aName + ']：5个^'
        + '消耗[' + str + ']：50个^'
        + '消费[钱币]：' + IntToStr(aNeedMoney) + '个^^'
        + '<〖返回〗/@Menu_Cl>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure Cl_10(uSource, uDest:integer);
var
    aItemKey        :integer;      //背包位置
    aLevel          :integer;      //宝石等级
    aNeedMoney      :integer;
    aNum            :integer;
    aName, str      :string;
begin
    aItemKey := getItemInputWindowsKey(uSource, 0);
    if aItemKey <= -1 then
    begin
        menusay(uSource, '请放入要淬炼的宝石！^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    aNum := getitemKeyCount(uSource, aItemKey);
    if aNum < 100 then
    begin
        menusay(uSource, '该宝石个数不足100个！^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    aLevel := getitemSpecialKind(uSource, aItemKey);
    case aLevel of
        1:aNeedMoney := 10000;
        2:aNeedMoney := 20000;
        3:aNeedMoney := 30000;
        4:aNeedMoney := 40000;
    else
        begin
            menusay(uSource, '该宝石等级未知！^^'
                + '<〖返回〗/@Menu_Cl>^^'
                + '<〖退出〗/@exit>^^');
            exit;
        end;
    end;

    aNeedMoney := aNeedMoney * 10;
    if getitemcount(uSource, '钱币') < aNeedMoney then
    begin
        menusay(uSource, '钱币不足，此次淬炼需要收取钱币：' + IntToStr(aNeedMoney) + '个^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    aName := getitemMixName(uSource, aItemKey);
    str := getitemName(uSource, aItemKey);
    deleteItemKey(uSource, aItemKey, 100);
    deleteitem(uSource, '钱币', aNeedMoney);
    additem(uSource, aName, 10);

    menusay(uSource, '恭喜你，淬炼成功！^'
        + '获得[' + aName + ']：10个^'
        + '消耗[' + str + ']：100个^'
        + '消费[钱币]：' + IntToStr(aNeedMoney) + '个^^'
        + '<〖返回〗/@Menu_Cl>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure Cl_all(uSource, uDest:integer);
var
    aItemKey        :integer;      //背包位置
    aNum, aNewNum   :integer;
    aLevel          :integer;      //宝石等级
    aNeedMoney      :integer;
    aName, str      :string;
begin
    aItemKey := getItemInputWindowsKey(uSource, 0);
    if aItemKey <= -1 then
    begin
        menusay(uSource, '请放入要淬炼的宝石！^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    aLevel := getitemSpecialKind(uSource, aItemKey);
    case aLevel of
        1:aNeedMoney := 10000;
        2:aNeedMoney := 20000;
        3:aNeedMoney := 30000;
        4:aNeedMoney := 40000;
    else
        begin
            menusay(uSource, '该宝石等级未知！^^'
                + '<〖返回〗/@Menu_Cl>^^'
                + '<〖退出〗/@exit>^^');
            exit;
        end;
    end;
    aNum := getitemKeyCount(uSource, aItemKey);
    aNewNum := aNum div 10;
    aNeedMoney := aNeedMoney * aNewNum;
    if getitemcount(uSource, '钱币') < aNeedMoney then
    begin
        menusay(uSource, '钱币不足，此次淬炼需要收取钱币：' + IntToStr(aNeedMoney) + '个^^'
            + '<〖返回〗/@Menu_Cl>^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;
    aName := getitemMixName(uSource, aItemKey);
    str := getitemname(uSource, aItemKey);
    deleteItemKey(uSource, aItemKey, aNewNum * 10);
    deleteitem(uSource, '钱币', aNeedMoney);
    additem(uSource, aName, aNewNum);
    if log then worldnoticemsg('淬炼前宝石总数：' + IntToStr(aNum), $00FF80FF, $00000000);
    if log then worldnoticemsg('淬炼宝石个数：' + IntToStr(aNum div 10), $00FF80FF, $00000000);
    if log then worldnoticemsg('扣除钱币个数：' + IntToStr(aNeedMoney), $00FF80FF, $00000000);

    menusay(uSource, '恭喜你，淬炼成功！^'
        + '获得[' + aName + ']：' + IntToStr(aNewNum) + '个^'
        + '消耗[' + str + ']：' + IntToStr(aNewNum * 10) + '个^'
        + '消费[钱币]：' + IntToStr(aNeedMoney) + '个^^'
        + '<〖返回〗/@Menu_Cl>^^'
        + '<〖退出〗/@exit>^^');
end;

