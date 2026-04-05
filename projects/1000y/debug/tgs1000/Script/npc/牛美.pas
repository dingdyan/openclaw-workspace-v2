procedure OnMenu(uSource, uDest:integer);
begin
    Menusay(uSource, '出售女子衣物,用两个骨头可以作成骨钥匙.^^'
        + '    <〖做骨钥匙〗/@make>^^'
        + '    <〖出售〗/@buy>^^'
        + '    <〖收购〗/@sell>');
end;

procedure make(uSource, uDest:integer);
begin
    if getitemcount(uSource, '骨头一') < 2 then
    begin
        Menusay(uSource, '没骨头做不了骨钥匙^^'
            + '<〖退出〗/@exit>');
        exit;
    end;
    if getitemspace(uSource) < 1 then
    begin
        Menusay(uSource, '背包至少留1个空位^^'
            + '<〖退出〗/@exit>');
        exit;
    end;

    deleteitem(uSource, '骨头一', 2);
    addItem(usource, '骨钥匙', 1);

    Menusay(uSource, '拿好骨钥匙，别丢了^^'
        + '    <〖谢谢〗/@exit>');
end;

