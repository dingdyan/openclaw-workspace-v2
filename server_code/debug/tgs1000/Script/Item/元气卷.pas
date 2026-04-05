{******************************************************************************


******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey: integer; astr: string);
var
  temp: integer;
begin
  temp := _StrToInt(astr);
  SetEnergy(uSource, temp);
end;

