package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

function OnGate(uSource, uGateOb)
  if P_getitemcount(uSource, '魔教密室钥匙') < 1 then
    P_saysystem(uSource, '拥有[魔教密室钥匙]才可进入', 2);
    P_MapMove(uSource, 98, 94, 103, 0);
   return 'true';
  end;
  --检测怪物数量
  local n = M_MapFindMonster(98, '', 2);
  if n > 0 then 
    P_saysystem(uSource, string.format('歼灭怪物才能通过,怪物(%d)生存', n), 2);
    P_MapMove(uSource, 98, 94, 103, 0);
   return 'true';
  end;
  --删除道具
  P_deleteitem(uSource, '魔教密室钥匙', 1, '魔教密室跳点');
  --传送到下一层
  P_MapMove(uSource, 99, 41, 42, 50);
 return 'true';
end