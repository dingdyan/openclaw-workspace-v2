var
    log             = false;

    //拖进物品筐
    //确认 合成数量
    //合成

procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, ' 廉价出售，高价收购。^^'
        + '<〖收购〗/@sell>^^'
        + '<〖出售武器与十字镐〗/@buy>^^'
        + '<〖提炼矿物原石〗/@tilian>^^'
        + '<〖交换矿物〗/@hecheng>^^'
        + '<〖修理身上装备〗/@xiuli>');
end;

procedure hecheng(uSource, uDest:integer);
begin

    Menusay(uSource, '交换矿物.材料拖入物品筐后选择交换^^'
        + '<〖交换〗/@hecheng1>^^'
        + '<〖交换矿物查询〗/@jiaohuan_1>^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>'
        );
    ItemInputWindowsOpen(uSource, 0, '交换原材料', '拖入交换材料');

end;

procedure tilian(uSource, uDest:integer);
begin

    Menusay(uSource, '提炼矿物原石..材料拖入物品筐后选择提炼^^'
        + '<〖提炼〗/@tilian1>^^'
        + '<〖提炼矿物查询〗/@tilian_1>^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>'
        );
    ItemInputWindowsOpen(uSource, 0, '提炼原材料', '拖入提炼材料');

end;

procedure hecheng1(uSource, uDest:integer);
var
    aItemKey, aItemcount, i, j:integer;
    aname, amenustr :string;
    ahc_name        :string;
    ahc_price, ahc_count:integer;
begin
    aItemKey := GetItemInputWindowsKey(uSource, 0);
    aname := getitemname(uSource, aItemKey);
    if aname = '' then
    begin
        Menusay(uSource, '请把物品拖入交换物品框^^'
            + '<    〖返回〗/@hecheng>^^'
            + '<    〖退出〗/@exit>');
        exit;
    end;
    aItemcount := getitemcount(uSource, aname);
    if _findItem(aname, ahc_name, ahc_price, ahc_count) = false then
    begin
        Menusay(uSource, '该物品不能交换^^'
            + '<    〖返回〗/@hecheng>^^'
            + '<    〖退出〗/@exit>');
        exit;
    end;

    i := aItemcount div ahc_count;
    if i <= 0 then
    begin
        Menusay(uSource, '数量太少!^^'
            + '<    〖返回〗/@hecheng>^^'
            + '<    〖退出〗/@exit>');
        exit;
    end;
    amenustr := '< 〖交换1个〗/@hecheng_c1>        费用:' + inttostr(ahc_price) + '.^^';
    if i >= 5 then
    begin
        j := ahc_price * 5;
        amenustr := amenustr + '^< 〖交换5个〗/@hecheng_c5>        费用:' + inttostr(j) + '.^^';
    end;

    if i >= 10 then
    begin
        j := ahc_price * i;
        amenustr := amenustr + '^< 〖交换全部〗/@hecheng_cAll>      费用:' + inttostr(j) + '.^^';
    end;

    Menusay(uSource, '选择你要交换的个数!^^'
        + amenustr
        + '<    〖返回〗/@hecheng>^^'
        + '<    〖退出〗/@exit>');
end;

procedure tilian1(uSource, uDest:integer);
var
    aItemKey, aItemcount, i, j:integer;
    aname, amenustr :string;
    ahc_name        :string;
    ahc_price, ahc_count:integer;
begin
    aItemKey := GetItemInputWindowsKey(uSource, 0);
    aname := getitemname(uSource, aItemKey);
    if aname = '' then
    begin
        Menusay(uSource, '请把物品拖入提炼物品框^^'
            + '<    〖返回〗/@tilian>^^'
            + '<    〖退出〗/@exit>');
        exit;
    end;
    aItemcount := getitemcount(uSource, aname);
    if _findItem_tl(aname, ahc_name, ahc_price, ahc_count) = false then
    begin
        Menusay(uSource, '该物品不能提炼^^'
            + '<    〖返回〗/@tilian>^^'
            + '<    〖退出〗/@exit>');
        exit;
    end;

    i := aItemcount div ahc_count;
    if i <= 0 then
    begin
        Menusay(uSource, '数量太少^^'
            + '<    〖返回〗/@tilian>^^'
            + '<    〖退出〗/@exit>');
        exit;
    end;
    amenustr := '< 〖提炼1个〗/@tilian_c1>        费用:' + inttostr(ahc_price) + '.^^';
    if i >= 5 then
    begin
        j := ahc_price * 5;
        amenustr := amenustr + '^< 〖提炼5个〗/@tilian_c5>        费用:' + inttostr(j) + '.^^';
    end;

    if i >= 10 then
    begin
        j := ahc_price * i;
        amenustr := amenustr + '^< 〖提炼全部〗/@tilian_cAll>      费用:' + inttostr(j) + '.^^';
    end;

    Menusay(uSource, ' 确认提炼^^'
        + amenustr
        + '<    〖返回〗/@tilian>^^'
        + '<    〖退出〗/@exit>');
end;

procedure hecheng_c1(uSource, uDest:integer);
begin
    hecheng_c(uSource, uDest, 1);
end;

procedure hecheng_c5(uSource, uDest:integer);
begin
    hecheng_c(uSource, uDest, 5);
end;

procedure hecheng_cAll(uSource, uDest:integer);
begin
    hecheng_c(uSource, uDest, -1);
end;

procedure tilian_c1(uSource, uDest:integer);
begin
    tilian_c(uSource, uDest, 1);
end;

procedure tilian_c5(uSource, uDest:integer);
begin
    tilian_c(uSource, uDest, 5);
end;

procedure tilian_cAll(uSource, uDest:integer);
begin
    tilian_c(uSource, uDest, -1);
end;

function _findItem(aname:string; var outname:string; var outprice, outcount:integer):boolean;
begin
    ///////////////////////////
    {

    ///////////////////////////                      }
    result := false;
    if aname = '青铜' then
    begin
        outname := '黄铜';
        outprice := 100;
        outcount := 10;
    end
    else if aname = '黄铜' then
    begin
        outname := '砂金';
        outprice := 1000;
        outcount := 10;
    end
    else if aname = '砂金' then
    begin
        outname := '黄金';
        outprice := 10000;
        outcount := 10;
    end
    else if aname = '黄金' then
    begin
        outname := '白金';
        outprice := 100000;
        outcount := 10;
    end
    else if aname = '硅石' then
    begin
        outname := '黑石';
        outprice := 100;
        outcount := 10;
    end
    else if aname = '黑石' then
    begin
        outname := '月石';
        outprice := 1000;
        outcount := 10;
    end
    else if aname = '月石' then
    begin
        outname := '玄石';
        outprice := 10000;
        outcount := 10;
    end
    else if aname = '玄石' then
    begin
        outname := '耀阳石';
        outprice := 100000;
        outcount := 10;
    end
    else if aname = '青玉' then
    begin
        outname := '绿玉';
        outprice := 100;
        outcount := 10;
    end
    else if aname = '绿玉' then
    begin
        outname := '黄玉';
        outprice := 1000;
        outcount := 10;
    end
    else if aname = '黄玉' then
    begin
        outname := '白玉';
        outprice := 10000;
        outcount := 10;
    end
    else if aname = '白玉' then
    begin
        outname := '黑珍珠';
        outprice := 100000;
        outcount := 10;
    end
    else
    begin
        exit;
    end;
    result := true;
end;

function _findItem_tl(aname:string; var outname:string; var outprice, outcount:integer):boolean;
begin
    result := false;
    if aname = '生铁' then
    begin
        outname := '钢铁';
        outprice := 100;
        outcount := 10;
    end
    else if aname = '钢铁' then
    begin
        outname := '墨铁';
        outprice := 1000;
        outcount := 10;
    end
    else if aname = '墨铁' then
    begin
        outname := '玄铁';
        outprice := 10000;
        outcount := 10;
    end
    else if aname = '玄铁' then
    begin
        outname := '熔岩铁';
        outprice := 100000;
        outcount := 10;
    end
    else if aname = '熔岩铁' then
    begin
        outname := '千年衔铁';
        outprice := 200000;
        outcount := 10;
    end
    else if aname = '青铜原石' then
    begin
        outname := '青铜';
        outprice := 200;
        outcount := 3;
    end
    else if aname = '黄铜原石' then
    begin
        outname := '黄铜';
        outprice := 500;
        outcount := 3;
    end
    else if aname = '砂金原石' then
    begin
        outname := '砂金';
        outprice := 1000;
        outcount := 3;
    end
    else if aname = '黄金原石' then
    begin
        outname := '黄金';
        outprice := 5000;
        outcount := 3;
    end
    else if aname = '白金原石' then
    begin
        outname := '白金';
        outprice := 10000;
        outcount := 2;
    end
    else if aname = '千年纯金原石' then
    begin
        outname := '千年纯金';
        outprice := 20000;
        outcount := 1;
    end
    else if aname = '硅石原石' then
    begin
        outname := '硅石';
        outprice := 200;
        outcount := 3;
    end
    else if aname = '黑石原石' then
    begin
        outname := '黑石';
        outprice := 500;
        outcount := 3;
    end
    else if aname = '月石原石' then
    begin
        outname := '月石';
        outprice := 1000;
        outcount := 3;
    end
    else if aname = '玄石原石' then
    begin
        outname := '玄石';
        outprice := 5000;
        outcount := 3;
    end
    else if aname = '耀阳原石' then
    begin
        outname := '耀阳石';
        outprice := 10000;
        outcount := 2;
    end
    else if aname = '千年金刚石原石' then
    begin
        outname := '千年金刚石';
        outprice := 20000;
        outcount := 1;
    end
    else if aname = '青玉原石' then
    begin
        outname := '青玉';
        outprice := 200;
        outcount := 3;
    end
    else if aname = '绿玉原石' then
    begin
        outname := '绿玉';
        outprice := 500;
        outcount := 3;
    end
    else if aname = '黄玉原石' then
    begin
        outname := '黄玉';
        outprice := 1000;
        outcount := 3;
    end
    else if aname = '白玉原石' then
    begin
        outname := '白玉';
        outprice := 5000;
        outcount := 3;
    end
    else if aname = '黑珍珠原石' then
    begin
        outname := '黑珍珠';
        outprice := 10000;
        outcount := 2;
    end
    else if aname = '千年水晶原石' then
    begin
        outname := '千年水晶';
        outprice := 20000;
        outcount := 1;
    end
    else
    begin
        exit;
    end;
    result := true;
end;

procedure hecheng_c(uSource, uDest:integer; axz_count:integer);
var
    aItemKey, aItemcount, i, j:integer;
    aname, amenustr :string;
    ahc_name        :string;
    ahc_price, ahc_count, ahavemoney:integer;
begin
    aItemKey := GetItemInputWindowsKey(uSource, 0);
    aname := getitemname(uSource, aItemKey);
    if aname = '' then
    begin
        Menusay(uSource, ' 没有物品^^'
            + '< 〖返回〗/@hecheng>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;
    aItemcount := getitemcount(uSource, aname);
    if _findItem(aname, ahc_name, ahc_price, ahc_count) = false then
    begin
        Menusay(uSource, '该物品不能交换^^'
            + '< 〖返回〗/@hecheng>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;

    i := aItemcount div ahc_count;
    if axz_count = -1 then axz_count := i;
    if i <= 0 then
    begin
        Menusay(uSource, ' 数量错误^^'
            + '< 〖返回〗/@hecheng>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;
    j := i * ahc_price;

    ahavemoney := getitemcount(uSource, '钱币');
    if ahavemoney < j then
    begin
        Menusay(uSource, '失败:需要钱币' + inttostr(j) + '.^^'
            + '< 〖返回〗/@hecheng>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;
    //检查钱
    //检查背包
    if getitemspace(uSource) < 1 then //获取背包空位
    begin
        Menusay(uSource, '物品栏空位不足，请留出1个空位。^^'
            + '< 〖返回〗/@hecheng>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;

    //扣钱

    deleteitem(uSource, '钱币', j);
    //扣物品

    deleteitem(uSource, aname, axz_count * ahc_count);

    //发物品
    additem(uSource, ahc_name, axz_count);

end;

procedure tilian_c(uSource, uDest:integer; axz_count:integer);
var
    aItemKey, aItemcount, i, j:integer;
    aname, amenustr :string;
    ahc_name        :string;
    ahc_price, ahc_count, ahavemoney:integer;
begin
    aItemKey := GetItemInputWindowsKey(uSource, 0);
    aname := getitemname(uSource, aItemKey);
    if aname = '' then
    begin
        Menusay(uSource, ' 没有物品^^'
            + '< 〖返回〗/@tilian>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;
    aItemcount := getitemcount(uSource, aname);
    if _findItem_tl(aname, ahc_name, ahc_price, ahc_count) = false then
    begin
        Menusay(uSource, ' 该物品不能提炼^^'
            + '< 〖返回〗/@tilian>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;

    i := aItemcount div ahc_count;
    if axz_count = -1 then axz_count := i;
    if i <= 0 then
    begin
        Menusay(uSource, ' 数量错误^^'
            + '< 〖返回〗/@tilian>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;
    j := i * ahc_price;

    ahavemoney := getitemcount(uSource, '钱币');
    if ahavemoney < j then
    begin
        Menusay(uSource, '失败:需要钱币' + inttostr(j) + '.^^'
            + '< 〖返回〗/@tilian>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;
    //检查钱
    //检查背包
    if getitemspace(uSource) < 1 then //获取背包空位
    begin
        Menusay(uSource, '物品栏空位不足，请留出1个空位。^^'
            + '< 〖返回〗/@tilian>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;

    //扣钱

    deleteitem(uSource, '钱币', j);
    //扣物品

    deleteitem(uSource, aname, axz_count * ahc_count);

    //发物品
    additem(uSource, ahc_name, axz_count);

end;

procedure tilian_1(uSource, uDest:integer);
begin
    Menusay(uSource, ' 可以提炼的物品^^'
        + '提炼钢铁 (生铁10个) 100钱^'
        + '提炼墨铁 (钢铁10个) 1000钱^'
        + '提炼玄铁 (墨铁10个) 10000钱^'
        + '提炼熔岩铁 (玄铁10个) 100000钱^'
        + '提炼千年衔铁 (熔岩铁10个) 200000钱^'
        + '提炼青铜 (青铜原石3个) 200钱^'
        + '提炼黄铜 (黄铜原石3个) 500钱^^^'
        + '<              〖下一页〗/@tilian_2><     〖返回〗/@tilian>^'
        + '                  第1页,共3页');
end;

procedure tilian_2(uSource, uDest:integer);
begin
    Menusay(uSource, ' 可以提炼的物品^^'
        + '提炼砂金 (砂金原石3个) 1000钱^'
        + '提炼黄金 (黄金原石3个) 5000钱^'
        + '提炼白金 (白金原石2个) 10000钱^'
        + '提炼千年纯金 (千年纯金原石1个) 20000钱^'
        + '提炼硅石 (硅石原石3个) 200钱^'
        + '提炼黑石 (黑石原石3个) 500钱^'
        + '提炼月石 (月石原石3个) 1000钱^^^'
        + '<       〖上一页〗/@tilian_1>< 〖下一页〗/@tilian_3><     〖返回〗/@tilian>^'
        + '                  第2页,共3页');
end;

procedure tilian_3(uSource, uDest:integer);
begin
    Menusay(uSource, ' 可以提炼的物品^^'
        + '提炼玄石 (玄石原石3个) 5000钱^'
        + '提炼耀阳石 (耀阳原石2个) 10000钱^'
        + '提炼千年金刚石 (千年金刚石原石1个) 20000钱^'
        + '提炼青玉 (青玉原石3个) 200钱^'
        + '提炼绿玉 (绿玉原石3个) 500钱^'
        + '提炼黄玉 (黄玉原石3个) 1000钱^'
        + '提炼白玉 (白玉原石3个) 5000钱>^'
        + '提炼黑珍珠 (黑珍珠原石2个) 10000钱^'
        + '提炼千年水晶 (千年水晶原石1个) 20000钱^'
        + '<              〖上一页〗/@tilian_2><     〖返回〗/@tilian>^'
        + '                  第3页,共3页');
end;

procedure jiaohuan_1(uSource, uDest:integer);
begin
    Menusay(uSource, ' 可以交换的矿物^^'
        + '黄铜交换 (青铜10个) 100钱^'
        + '砂金交换 (黄铜10个) 1000钱^'
        + '黄金交换 (砂金10个) 10000钱^'
        + '白金交换 (黄金10个) 100000钱^'
        + '黑石交换 (硅石10个) 100钱^'
        + '月石交换 (黑石10个) 1000钱^^^'
        + '<              〖下一页〗/@jiaohuan_2><       〖返回〗/@hecheng>^'
        + '                  第1页,共2页');
end;

procedure jiaohuan_2(uSource, uDest:integer);
begin
    Menusay(uSource, ' 可以交换的矿物^^'
        + '玄石交换 (月石10个) 10000钱^'
        + '耀阳石交换 (玄石10个) 100000钱^'
        + '绿玉交换 (青玉10个) 100钱^'
        + '黄玉交换 (绿玉10个) 1000钱^'
        + '白玉交换 (黄玉10个) 10000钱^'
        + '黑珍珠交换 (白玉10个) 100000钱^^^'
        + '<              〖上一页〗/@jiaohuan_1><       〖返回〗/@hecheng>^'
        + '                  第2页,共2页');
end;

procedure xiuli(uSource, uDest:integer);
var
    itemname1, itemname3, itemname6, itemname8, itemname9, tempstr:string;
    needmoney, havemoney:integer;
begin
    tempstr := '';
    itemname1 := getwearitemname(uSource, 1);
    itemname3 := getwearitemname(uSource, 3);
    itemname6 := getwearitemname(uSource, 6);
    itemname8 := getwearitemname(uSource, 8);
    itemname9 := getwearitemname(uSource, 9);
    tempstr := itemname1 + itemname3 + itemname6 + itemname8 + itemname9;
    if tempstr = '' then
    begin
        menusay(uSource, '没带要修理的物品!^^'
            + '< 〖返回〗/@OnMenu>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;

    needmoney := WearGETRepairGoldSum(uSource);

    if needmoney <= 0 then
    begin
        menusay(uSource, '都是新的,浪费这钱干嘛?^^'
            + '< 〖返回〗/@OnMenu>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;
    Menusay(uSource, '全部修理需要钱币数量：' + inttostr(needmoney) + '个。^^'
        + '<〖确定修理〗/@Repair>^^'
        + '<〖暂不修理〗/@exit>^^'
        + '< 〖返回〗/@OnMenu>^^'
        + '< 〖退出〗/@exit>');

end;

procedure Repair(uSource, uDest:integer);
var
    itemname1, itemname3, itemname6, itemname8, itemname9, tempstr:string;
    needmoney, havemoney:integer;
begin
    tempstr := '';
    itemname1 := getwearitemname(uSource, 1);
    itemname3 := getwearitemname(uSource, 3);
    itemname6 := getwearitemname(uSource, 6);
    itemname8 := getwearitemname(uSource, 8);
    itemname9 := getwearitemname(uSource, 9);
    tempstr := itemname1 + itemname3 + itemname6 + itemname8 + itemname9;
    if tempstr = '' then
    begin
        menusay(uSource, '没带要修理的物品!^^'
            + '< 〖返回〗/@OnMenu>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;
    needmoney := WearGETRepairGoldSum(uSource);
    if needmoney <= 0 then
    begin
        menusay(uSource, '都是新的,浪费这钱干嘛?^^'
            + '< 〖返回〗/@OnMenu>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;
    havemoney := getitemcount(uSource, '钱币');
    if havemoney < needmoney then
    begin
        menusay(uSource, '修理需要的钱币不够!^^'
            + '全部修理需要钱币数量:' + inttostr(needmoney) + '个。^^'
            + '< 〖返回〗/@OnMenu>^^'
            + '< 〖退出〗/@exit>');
        exit;
    end;

    if WearRepairAll(uSource) = false then
    begin
        menusay(uSource, '修理不了了，还是换一套吧^^'
            + '< 〖返回〗/@OnMenu>^^'
            + '< 〖退出〗/@exit>');
    end else
    begin
        menusay(uSource, '老兄,这不是修修还能用吗!^^'
            + '< 〖返回〗/@OnMenu>^^'
            + '< 〖退出〗/@exit>');
        deleteitem(uSource, '钱币', needmoney);
    end;

end;

