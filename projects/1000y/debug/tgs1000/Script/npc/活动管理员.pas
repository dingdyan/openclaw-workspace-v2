procedure OnMenu(uSource, uDest: integer);
begin
  menusay(uSource, '负责管理各项活动以及双倍经验的领取！^^'
    + '    <〖领取双倍经验〗/@GetDoubleExp>^^');
end;

procedure GetDoubleExp(uSource, uDest: integer);
var
  remainDHour: integer;
begin
  remainDHour := MagicExpMulGetDay(uSource);
//查询可领取双倍的剩余时间
  if remainDHour < 1 then
  begin
    menusay(uSource, '你现在暂时没有双倍武功经验可领取，明天再^'
      + '来吧！^^'
      + '    <〖退出〗/@exit>');
    exit;
  end;
  menusay(uSource, '每天可领取2个小时的双倍武功经验^'
    + '你当前还有 ' + inttostr(remainDHour) + ' 天双倍武功经验未领取!^^'
    + '<〖领取双倍〗/@GetDoubleExp1>^^');

end;
//领取2小时

procedure GetDoubleExp1(uSource, uDest: integer);
begin
  MagicExpMulAdd(uSource, 2, 2);
  menusay(uSource, '恭喜你成功领取了2小时的双倍武功经验!^^'
    + '    <〖返回〗/@GetDoubleExp>^^'
    + '    <〖退出〗/@exit>');
end;

