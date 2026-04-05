function Fact(N: Integer): Integer;
begin
  if N = 1 then
    result := 1
  else
    result := N * Fact(N - 1);
end;
