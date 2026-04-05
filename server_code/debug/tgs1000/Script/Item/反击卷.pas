{******************************************************************************
创建人:田莉
创建时间:2009.09.01
修改时间:
实现功能:
  使用此卷可以攻击主动攻击你的怪物、NPC、玩家


******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey :integer; astr :string);
var
  astate :boolean;
begin
  astate := true;
  NewCounterAttack_hit(uSource, astate, 24);
  deleteitem(uSource, '反击卷', 1);
end;

