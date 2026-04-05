 var
  t, i, j: Integer;
  s: String;
begin
  t := GetTickCount();
  s := '01234567890';
  for i := 0 to 100000 do
  begin
    s[i mod 10 + 1] := ' ';
    for j := 1 to 10 do
    begin
      s[j] := s[j + 1];
      s[j + 1] := s[j];
    end;
  end;
  println GetTickCount() - t;
end.
