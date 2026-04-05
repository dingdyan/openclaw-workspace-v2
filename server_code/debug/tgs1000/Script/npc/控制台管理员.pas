{******************************************************************************
创建人:李小利
创建时间:2009.09.18
修改时间:2009.09.18
实现功能:

******************************************************************************}

procedure OnNpcMenu(uSource, uDest: integer);
begin
  menusay(uSource, 'GM控制各地图任务的状态!。^^'
    + '    <〖长城以南〗/@South>^^');
end;

procedure South(uSource, uDest: integer);
begin
  menusay(uSource, 'GM控制各地图任务的状态!。^^'
    + '    <〖攻城任务〗/@AttactQuest>^^');
end;

procedure AttactQuest(uSource, uDest: integer);
var
  AttactState: integer;
begin
  AttactState := getServerTempVar(0);
  case AttactState of
    0:
      begin
        menusay(uSource, '要求开启长城以南中央市场攻城战!。^^'
          + '<〖开启攻城〗/@AttackStart>^^');
      end;
    1, 2:
      begin
        menusay(uSource, '要求关闭长城以南中央市场攻城战!。^^'
          + '<〖关闭攻城〗/@AttackEnd>^^');
      end;
  end;
end;

procedure AttackStart(uSource, uDest: integer);
begin
  menusay(uSource, '要求开启长城以南中央市场攻城战!。^^');
  SetServerTempVar(0, 1);
  worldnoticemsg('攻城战即将正式开启,请各位玩家做好防守准备!', $00FF80FF, $00000000);
end;

procedure AttackEnd(uSource, uDest: integer);
begin
  menusay(uSource, '要求关闭长城以南中央市场攻城战!。^^');
  SetServerTempVar(0, 3);
  worldnoticemsg('攻城战已经结束!', $00FF80FF, $00000000);
end;

