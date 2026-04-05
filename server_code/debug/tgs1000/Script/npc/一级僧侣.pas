
procedure OnMenu(uSource, uDest: integer);
begin
 // ObjectDelaySay(uSource, '南无阿弥陀佛...', 200);
  //ObjectDelaySay(uSource, '施给僧侣，给您带来好运...', 200);
  MenuSay(uSource, '还望施主慈悲为怀，施舍些天桃汁给贫僧。^'
    + '佛祖保佑，阿弥陀佛。^'
    + '路见不平、拔剑相助，行侠仗义、除恶扬善。^^'
    + '    <〖施舍给和尚天桃汁〗/@give_ok>^^');
end;

procedure give_ok(uSource, uDest: integer);
var
  iRandom, ikind: integer;
  str: string;
begin
  if getitemcount(uSource, '天桃汁儿') < 1 then
  begin
    MapDelaySayNPC('新手村', '一级僧侣', '没有天桃汁儿还说什么!!', 100);
    exit;
  end;
  deleteitem(uSource, '天桃汁儿', 1);
  MapDelaySayNPC('新手村', '一级僧侣', '佛祖保佑..._南无阿弥陀佛....', 100);
  iRandom := Random(500);
  if iRandom <> 1 then exit;
  if getitemspace(uSource) < 1 then
  begin
    MapDelaySayNPC('新手村', '一级僧侣', '背包已满!', 100);
    exit;
  end;
  iKind := Random(11);
  case ikind of
    0: additem(uSource, '如来天王拳', 1);
    1: additem(uSource, '飞龙剑法', 1) ;
    2: additem(uSource, '花郎斩', 1) ;
    3: additem(uSource, '岳家枪法', 1) ;
    4: additem(uSource, '帝王槌法', 1) ;
    5: additem(uSource, '不灭体', 1);
    6: additem(uSource, '吸着水石', 1) ;
    7: additem(uSource, '生死梦幻丹', 1) ;
    8: additem(uSource, '狐狸内丹三', 1) ;
    9: additem(uSource, '男子凤凰鞋', 1) ;
    10: additem(uSource, '女子凤凰鞋', 1) ;
  end;
  MapDelaySayNPC('新手村', '一级僧侣', '这不正是昨天在路上捡到的那件东西吗~', 100);   
end;

