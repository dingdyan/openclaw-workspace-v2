package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

function OnTurnoff(uSource)
  M_MapRegenDynamicObject(31, 'Ô¿³×¾ÆÌ³');
  M_MapRegenDynamicObject(31, 'µç¾ÆÌ³');
  M_MapRegenDynamicObject(31, '±¬ÆÆ¾ÆÌ³');
end;