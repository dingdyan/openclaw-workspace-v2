procedure OnMenu(uSource, uDest: integer);
begin
  Menusay(uSource, '需要物品就到我这来吧!我也收购一些物品 ^^'
    + '    <〖卖 物品〗/@sell>^^'
    + '    <〖买 物品〗/@buy>^^'
    + '    <〖保管物品〗/@logitem>');
end;
