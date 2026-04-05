package.loaded['Script\\lua\\f'] = nil;

require ('Script\\lua\\f');

--刷新
function OnTurnoff(uSource)
  M_MapRegenDynamicObject(31, '蜡台');
  M_MapRegenMonster(31, '放火装置1');
  M_MapRegenMonster(31, '放火装置2');
  M_MapRegenMonster(31, '放火装置3');
  M_MapRegenMonster(31, '放火装置4');
  M_MapRegenMonster(31, '放火装置5');
  M_MapRegenMonster(31, '放火装置6');
  M_MapRegenMonster(31, '放火装置7');
  M_MapRegenMonster(31, '放火装置8');
  M_MapRegenMonster(31, '石棺赦龙组');
  M_MapRegenMonster(31, '石棺青龙刺客');
end;