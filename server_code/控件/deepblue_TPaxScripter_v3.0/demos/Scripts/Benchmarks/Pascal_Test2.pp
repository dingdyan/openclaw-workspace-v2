var I, J, K, T;
T := GetTickCount();
for I := 1 to 100000 do
  for J := 1 to 10 do
    If I > J Then
      K := I > 1000
    else
      K := J < 5;
println GetTickCount() - T;


