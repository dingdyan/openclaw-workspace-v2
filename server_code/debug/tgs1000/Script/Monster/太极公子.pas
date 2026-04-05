//太极公子死亡 NPC 说话

procedure OnDie(uSource, uDest: integer; aRACE: integer);
var
  nCount: integer;
begin
  nCount := 0;
  //1,检查是否有令牌
  if getitemcount(uSource, '太极书札1') > 0 then
  begin
    inc(nCount);
  end;
  if getitemcount(uSource, '太极书札2') > 0 then
  begin
    inc(nCount);
  end;
  if getitemcount(uSource, '太极书札3') > 0 then
  begin
    inc(nCount);
  end;

  if nCount < 3 then
  begin
    MapDelaySayNPC('太极密室', '密室太极老人', '请帮我们找回门主留下的太极书札', 200);
    MapDelaySayNPC('太极密室', '密室太极老人', '从<黄金沙漠>拿到书函后,毫无音信~', 200);
    MapDelaySayNPC('太极密室', '密室太极老人', '担心<青龙帮>会威胁到本门, ', 200);
    MapDelaySayNPC('太极密室', '密室太极老人', '所以太极公子必须修炼书札上的武功密笈.', 200);
    MapDelaySayNPC('太极密室', '密室太极老人', '门主怎么也不会被小人打败... ', 200);
    MapDelaySayNPC('太极密室', '密室太极老人', '总之找到_[太极书札]之后,拿给我好吗? ', 200);
    MapDelaySayNPC('太极密室', '密室太极老人', '必有重谢. ', 200);
  end;
  if nCount = 3 then
  begin
 //2,检查背包空间
    if getitemspace(uSource) < 1 then
    begin
    //提示背包满
      saysystem(uSource, '背包已满,无法获得物品!');
      exit;
    end;
    if deleteitem(uSource, '太极书札1', 1) = false then
    begin
      //
      saysystem(uSource, '删除太极书札1失败!');
      exit;
    end;
    if deleteitem(uSource, '太极书札2', 1) = false then
    begin
      //
      saysystem(uSource, '删除太极书札2失败!');
      exit;
    end;
    if deleteitem(uSource, '太极书札3', 1) = false then
    begin
      //
      saysystem(uSource, '删除太极书札3失败!');
      exit;
    end;

    additem(uSource, '太极牌', 1);
    saysystem(uSource, '获得太极牌1个');

    MapDelaySayNPC('太极密室', '密室太极老人', '万分感谢...托你的福，我门的武功密笈', 200);
    MapDelaySayNPC('太极密室', '密室太极老人', '终于物归原主了...只要公子掌握了此项武功, ', 200);
    MapDelaySayNPC('太极密室', '密室太极老人', '在门主他老人家回来之前定能重振我们已经败落的  ', 200);
    MapDelaySayNPC('太极密室', '密室太极老人', '太极剑门! ', 200);
    MapDelaySayNPC('太极密室', '密室太极老人', '这里本门的象征给你一个.', 200);
    MapDelaySayNPC('太极密室', '密室太极老人', '后会有期!需要援助时,  ', 200);
    MapDelaySayNPC('太极密室', '密室太极老人', '本门弟子定会助你一臂之力... ', 200);
  end;
  //movespace(uSource, 1, 165, 775);
end;

