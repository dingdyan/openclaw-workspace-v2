--攻击触发
function OnHit(uSource, uDest, declife)
  --给予道具
  P_additem(uSource, '钱币', 1, '修炼火炉');
end;
