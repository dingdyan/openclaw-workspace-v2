var
  I, J, P, S, T;
T := GetTickCount();
S := 0.0;
P := 1.0;
for I:=1 to 100000 do
  for J:=1 to 10 do
  begin
    P := P / 4.0;
    S := S + P;
  end;
println GetTickCount() - T;
.
