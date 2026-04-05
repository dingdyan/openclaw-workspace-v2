var T = GetTickCount();
Hanoi(20, 'A', 'B', 'C');
println GetTickCount() - T;
procedure Hanoi(N, X, Y, Z);
begin
  if N > 0 then
  begin
    Hanoi(N - 1, X, Z, Y);
    Hanoi(N - 1, Z, Y, X);
  end;
end;


