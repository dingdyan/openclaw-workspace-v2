//***************************************************
//创建人：杨李
//时间：2009.10.26
//功能： 做石谷钥匙，南帝王任务步骤
//修改人：何永安
//修改时间：2009.11.20
//修改内容：白字显示为窗口显示
//***************************************************

procedure OnMenu(uSource, uDest:integer);
var
    CurQuestID, CurQuestStep:Integer;
begin
    CurQuestID := getQuestCurrentNo(uSource);
    CurQuestStep := getQuestStep(uSource);
    if CurQuestID <> 5007 then
    begin
        Menusay(uSource, '我正忙着做石谷钥匙呢。。。没事儿别打扰我.^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    case CurQuestStep of
        4:
            begin
                Menusay(uSource, ' 亲自为你打造各类物品，当然不是免费的啦~~^^'
                    + '<〖有关石谷钥匙的制法〗/@about>^^'
                    + '<〖做石谷钥匙〗/@make>^^'
                    + '<〖退出〗/@exit>^^');
            end;
    else
        begin
            Menusay(uSource, '事情进行得还顺利吗?^^'
                + '<〖退出〗/@exit>^^');
        end;
    end;
end;

procedure about(uSource, uDest:integer);
begin
    Menusay(uSource, '只要有 [金毛狮甲]和[蝎子尾巴]就能制得石谷钥匙。^^'
        + '<〖知道了〗/@exit>^^'
        + '<〖返回〗/@OnMenu>^^'
        + '<〖退出〗/@exit>');
end;

procedure make(uSource, uDest:integer);
begin
    if getitemcount(uSource, '石谷钥匙') > 0 then
    begin
        Menusay(uSource, '身上不是有石谷钥匙吗_别太贪心啦^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    if (getitemcount(uSource, '金毛狮甲') < 1)
        or (getitemcount(uSource, '蝎子尾巴') < 1) then
    begin
        Menusay(uSource, '拿金毛狮甲和蝎子尾巴来^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    if getitemspace(uSource) < 1 then
    begin
        Menusay(uSource, '背包至少有1个空位!^^'
            + '<〖返回〗/@OnMenu>^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    deleteitem(uSource, '金毛狮甲', 1);
    deleteitem(uSource, '蝎子尾巴', 1);
    additem(uSource, '石谷钥匙', 1);

    Menusay(uSource, '拿好钥匙，别丢了^^'
        + '<〖退出〗/@exit>');
end;

