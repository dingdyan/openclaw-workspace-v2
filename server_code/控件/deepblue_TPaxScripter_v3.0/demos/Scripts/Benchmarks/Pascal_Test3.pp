var
  I, J, S, T;
T := GetTickCount();
S := '';
for I:=1 to 10000 do
  S := S + 'abc';
println GetTickCount() - T;
println S;
println Length(S);


