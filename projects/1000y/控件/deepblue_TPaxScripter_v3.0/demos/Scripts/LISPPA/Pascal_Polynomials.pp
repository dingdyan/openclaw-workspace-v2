program Polynomials;

procedure Add(InitP, InitQ: Variant);
var
  P, Q: Variant;
begin
  P := @ InitP;
  Q := @ InitQ;
  repeat
    while P[0][1] < Q[0][1] do
      Q := @ Q[1];

    if P[0][1] > Q[0][1] then
      Q := [ + P[0], Q]
    else
    begin
      Q[0][0] := Q[0][0] + P[0][0];
      if Q[0][0] = 0 then
        reduced Q := Q[1]
      else
        Q := @ Q[1];
    end;
    P := @ P[1];
  until P[0][1] < 0;
end;

procedure Show(P: Variant);
begin
  writeln('');
  repeat
    write(P[0][0], 'X^', P[0][1]);
    
    P := @ P[1];

    if P[0][1] < 0 then
      Exit;

    if P[0][0] >= 0 then
      write('+');
  until false;
end;

var
  P, Q: Variant;
begin
  P := [[0, -1], null];
  P[1] := @ P;
  P := [[600, 1], P];
  P := [[10, 2], P];
  P := [[70, 5], P];
  P := [[150, 6], P];
  P := [[80, 7], P];

  Q := [[0, -1], null];
  Q[1] := @ Q;
  Q := [[600, 1], Q];
  Q := [[170, 3], Q];
  Q := [[60, 5], Q];
  Q := [[-150, 6], Q];

  writeln('Source polynomials:');
  Show(P);
  Show(Q);
  Add(P, @ Q);
  writeln('Sum:');
  Show(Q);
end.


