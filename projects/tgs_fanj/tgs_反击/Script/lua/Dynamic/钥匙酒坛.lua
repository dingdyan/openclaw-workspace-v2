package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');


local n = 0;

function OnRegen(uSource)
   if n > 0 then
      n = n - 1;
   end;
end;


function OnTurnOn(uSource, uDest)
   n = n + 1;

   if n == 1 then
      M_MapChangeDynamicobject(31, '铁闸门1', 2);
      M_MapChangeDynamicobject(31, '铁闸门2', 2);
      M_MapChangeDynamicobject(31, '铁闸门3', 2);
     return;
   end;

   if n == 2 then
      M_MapChangeDynamicobject(31, '铁闸门1', 2);
      M_MapChangeDynamicobject(31, '铁闸门2', 2);
      M_MapChangeDynamicobject(31, '铁闸门3', 2);
     return;
   end;

   if n == 3 then
      M_MapChangeDynamicobject(31, '铁闸门1', 2);
      M_MapChangeDynamicobject(31, '铁闸门2', 2);
      M_MapChangeDynamicobject(31, '铁闸门3', 2);
     return;
   end;

   if n == 4 then
      M_MapChangeDynamicobject(31, '铁闸门1', 2);
      M_MapChangeDynamicobject(31, '铁闸门2', 2);
      M_MapChangeDynamicobject(31, '铁闸门3', 2);
     return;
   end;

   if n == 5 then
      M_MapChangeDynamicobject(31, '铁闸门1', 2);
      M_MapChangeDynamicobject(31, '铁闸门2', 2);
      M_MapChangeDynamicobject(31, '铁闸门3', 2);
      M_MapObjSay(31, '铁闸门已开启', 2);
      n = 0;
     return;
   end;

  return;
end;