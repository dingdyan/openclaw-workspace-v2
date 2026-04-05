const
    CON_DELETE_MONEY = 10000;

procedure OnMenu(uSource, uDest:integer);
begin
    menusay(uSource, '将3件相同品级相同名字的装备给我，我可以回炉^把装备属性变回初始值^^'
        + '    <〖装备重铸〗/@newItem>^^'
        + '    <〖装备重铸介绍〗/@introduction>^^'
        + '    <〖 任 务 〗/@Quest>^^');
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
                if CurQuestStep = 14 then
                begin
                    Menusay(uSource, '很高兴认识你啊，我这儿可以重铸各种装备，^'
                        + '需要的话随时可以找我！既然你来拜访我，那我^'
                        + '就送你点小礼物吧^^'
                        + '<〖谢谢〗/@q4950_j15>^^'
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

procedure q4950_j15(uSource, uDest:integer);
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

    setQuestStep(uSOurce, 15);
    notice := getQuestSubRequest(4950, 15);
    saysystem(uSource, '任务提示：' + notice);

    if getQuestSubItem(4950, 14, 0, aname, acount) = false then exit;
    additem(uSource, aname, acount);

    if getQuestSubItem(4950, 14, 1, aname, acount) = false then exit;
    additem(uSource, aname, acount);
    saysystem(uSource, '获得任务奖励：钱币:1000,天桃:20');
    Menusay(uSOurce, '快去' + notice + '^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');

end;

procedure introduction(uSource, uDest:integer);
begin
    menusay(uSource, '装备重铸系统介绍:^^'
        + '装备重铸是将三件名字相同任意属性的物品(可^'
        + '以是鉴定过的,镶嵌过的,1到3星等等)重新生成^'
        + '一件装备,属性为该装备的原始属性，星数为随^'
        + '机1星到3星.^^'
        + '     <〖返回〗/@OnMenu>^^'
        + '     <〖退出〗/@exit>');
end;

procedure newItem(uSource, uDest:integer);
begin
    menusay(uSource, '将3件名字相同任意属性的装备放入下面的^输入框内，点击重铸!^^'
        + '     <〖重铸〗/@chongzhu>^^'
        + '     <〖返回〗/@OnMenu>^^'
        + '     <〖退出〗/@exit>');
    ItemInputWindowsOpen(uSource, 0, '装备', '第一件装备');
    ItemInputWindowsOpen(uSource, 1, '装备', '第二件装备');
    ItemInputWindowsOpen(uSource, 2, '装备', '第三件装备');
    setItemInputWindowsKey(uSource, 0, -1);
    setItemInputWindowsKey(uSource, 1, -1);
    setItemInputWindowsKey(uSource, 2, -1);
end;

procedure chongzhu(uSource, uDest:integer);
var
    aItemKey1, aItemKey2, aItemKey3:integer;
    aItemName1, aItemName2, aItemName3:string;
    agrade          :integer;
    aStarLevel      :integer;
    amoney, aWearArr:integer;
    akind1, akind2, akind3:integer;
begin
    //1.获取并坚持key是否合法
    aItemKey1 := getItemInputWindowsKey(uSource, 0); //获取第一个窗口中的物品在背包中的位置
    aItemKey2 := getItemInputWindowsKey(uSource, 1); //获取第二个窗口中的物品在背包中的位置
    aItemKey3 := getItemInputWindowsKey(uSource, 2); //获取第二个窗口中的物品在背包中的位置
    //检查是不是都放有装备
    if (aItemKey1 = -1) or (aItemKey2 = -1) or (aItemKey3 = -1) then
    begin
        menusay(uSource, '请放入需要重铸的相同3件装备！^^'
            + '     <〖返回〗/@newItem>^^'
            + '     <〖退出〗/@exit>');
        exit;
    end;
    //检查是否是装备
    akind1 := getitemKind(uSource, aItemKey1);
    if akind1 <> 6 then
    begin
        menusay(uSource, '第一个格子内物品不是装备不能重铸！^^'
            + '     <〖返回〗/@newItem>^^'
            + '     <〖退出〗/@exit>');
        exit;
    end;
    akind2 := getitemKind(uSource, aItemKey2);
    if akind2 <> 6 then
    begin
        menusay(uSource, '第二个格子内物品不是装备不能重铸！^^'
            + '     <〖返回〗/@newItem>^^'
            + '     <〖退出〗/@exit>^^');
        exit;
    end;
    akind3 := getitemKind(uSource, aItemKey3);
    if akind3 <> 6 then
    begin
        menusay(uSource, '第三个格子内物品不是装备不能重铸！^^'
            + '     <〖返回〗/@newItem>^^'
            + '     <〖退出〗/@exit>^^');
        exit;
    end;
    //检查key看是否有key重复
    if (aItemKey1 = aItemKey2) or (aItemKey1 = aItemKey3) or (aItemKey2 = aItemKey3) then
    begin
        menusay(uSource, '同一件装备不能多次使用！^^'
            + '     <〖返回〗/@newItem>^^'
            + '     <〖退出〗/@exit>^^');
        exit;
    end;
    //检查三件物品的名字是否相同
    aItemName1 := getitemname(uSource, aItemKey1);
    aItemName2 := getitemname(uSource, aItemKey2);
    aItemName3 := getitemname(uSource, aItemKey3);
    if (aItemName1 <> aItemName2)
        or (aItemName1 <> aItemName3)
        or (aItemName2 <> aItemName3) then
    begin
        menusay(uSource, '三件装备不相同.请重新放入相同的装备！^^'
            + '     <〖返回〗/@newItem>^^'
            + '     <〖退出〗/@exit>');
        exit;
    end;

    //判断部位
    aWearArr := getitemWearArr(uSource, aItemKey1);
    if (aWearArr <> 8)             // 头
    and (aWearArr <> 6)            // 衣服
    and (aWearArr <> 1)            // 手
    and (aWearArr <> 9)            // 武器
    and (aWearArr <> 3) then       // 脚
    begin
        menusay(uSource, '只能重铸武器，头盔，护腕，靴子和铠甲！^^'
            + '     <〖返回〗/@newItem>^^'
            + '     <〖退出〗/@exit>^^');
        exit;
    end;

    //检查品级
    agrade := getitemGrade(uSource, aItemKey1);
    if (agrade <= 0) or (agrade > 12) then
    begin
        menusay(uSource, '只能重铸1品到12品的装备！^^'
            + '     <〖返回〗/@newItem>^^'
            + '     <〖退出〗/@exit>^^');
        exit;
    end;

    amoney := agrade * CON_DELETE_MONEY;
    if getitemcount(uSource, '钱币') < amoney then
    begin
        menusay(uSource, '重铸' + aItemName1 + '需要[钱币]：' + IntToStr(amoney) + '个！^^'
            + '     <〖返回〗/@newItem>^^'
            + '     <〖退出〗/@exit>^^');
        exit;
    end;

    //检查背包空位
    if getitemspace(uSource) < 1 then
    begin
        menusay(uSource, '背包至少保留1个空位！^^'
            + '     <〖返回〗/@newItem>^^'
            + '     <〖退出〗/@exit>^^');
        exit;
    end;

    //删除物品
    deleteitem(uSource, '钱币', amoney);
    deleteItemKey(uSource, aItemKey1, 1);
    deleteItemKey(uSource, aItemKey2, 1);
    deleteItemKey(uSource, aItemKey3, 1);

    //随机星数
    case Random(10000) of
        0..4000:aStarLevel := 1;
        4001..7000:aStarLevel := 2;
        7001..9999:aStarLevel := 3;
    else aStarLevel := 1;
    end;
    addItemEx(uSource, aItemName1, '', aStarLevel, 0, 0, 0, -1, 0);
    menusay(uSource, '此次重铸消耗了[钱币]:' + inttostr(amoney) + '个!^^'
        + '     <〖继续〗/@newItem>^^'
        + '     <〖退出〗/@exit>^^');
end;

