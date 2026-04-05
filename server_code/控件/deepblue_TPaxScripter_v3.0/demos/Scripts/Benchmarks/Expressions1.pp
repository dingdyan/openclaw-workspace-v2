var
  i, j, k, t;
begin
  t := GetTickCount();
  for i := 0 to 100000 do
    for j := 1 to 10 do
      if (j > 5) or (j * 10 + 1 < i div 2 + 1) then
        k := 1;
  println GetTickCount() - t;
end.
