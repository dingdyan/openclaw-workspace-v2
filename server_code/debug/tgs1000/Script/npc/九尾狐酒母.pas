{******************************************************************************
创建人：
创建时间：
修改人：何永安
修改时间：2009.11.20
修改内容：将NPC白字显示的信息窗口显示
******************************************************************************}

procedure OnMenu(uSource, uDest:integer);
begin
    MenuSay(uSource, '拿99朵白玫瑰与妖华尾巴可以换狐狸内丹^^'
        + '<〖换取狐狸内丹〗/@ExChange>^^'
        + '<〖退出〗/@exit>^^');
end;

procedure ExChange(uSource, uDest:integer);
begin
    if getitemcount(uSource, '白玫瑰一') < 99 then
    begin
        menusay(uSource, '白玫瑰不足99朵。^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    if getitemcount(uSource, '妖华尾巴') < 1 then
    begin
        menusay(uSource, '没有妖华尾巴。^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    if getitemspace(uSource) < 1 then
    begin
        menusay(uSource, '背包至少要留1个空位^^'
            + '<〖退出〗/@exit>^^');
        exit;
    end;

    deleteitem(uSource, '白玫瑰一', 99);
    deleteitem(uSource, '妖华尾巴', 1);
    additem(uSource, '狐狸内丹三', 1);
    menusay(uSource, '获得[狐狸内丹]1个^^'
        + '<〖退出〗/@exit>^^');
end;

