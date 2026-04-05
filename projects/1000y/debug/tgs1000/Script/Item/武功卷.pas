{******************************************************************************


******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey: integer; astr: string);
var
  temp: integer;
  Magicname: string;
  int1, int2: integer;
begin
  Magicname := getuserAttackMagic(uSource); //获取 攻击武功名字
  if getMagicLevel(usource, Magicname) >= 9999 then exit; //获取武功等级
  int1 := getMagicExp(uSource, Magicname); //获取当前攻击武功经验值
  int2 := 1084550000 - int1;
  if astr = '满级' then
  begin
    AddMagicExp(uSource, Magicname, int2);
  end else
  begin
    temp := _StrToInt(astr);
    if temp > int2 then temp := int2;
    AddMagicExp(uSource, Magicname, temp);
  end;
end;

