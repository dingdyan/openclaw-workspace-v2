{******************************************************************************


******************************************************************************}

procedure OnItemDblClick(uSource, uItemKey: integer; astr: string);
var
  str: string;
begin
  deleteitem(uSource, '千里传音', 1);
  str := getname(uSource) + ':' + astr;
  worldnoticemsg('【千里传音】 ' + str, $00FF80FF,$00000000);
end;

