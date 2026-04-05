uses SysUtils;
var
  i, k, t: Integer;
begin
  t := GetTickCount();
  k := 1;
  
  for i := 0 to 200000 do
    k := StrToInt(IntToStr(i));
  println GetTickCount() - t;
end.
