var
  i, j, k, m, t: Integer;
begin
  t := GetTickCount();
  k := 1;
  m := 1;
  for i := 0 to 100000 do
  begin
    k := k + 1;
    for j := 1 to 50 do
    begin
      k := k + j * 2;
      m := k div 3;
    end;
  end;
  println GetTickCount() - t;
end.
