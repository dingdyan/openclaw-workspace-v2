program EulerAlgorithm;

function Cycle(InitV, A: Variant): Variant;
var
  P, Stack, U, V;
begin
  result := null;
  Stack := [InitV, null];
  while Stack <> null do
  begin
    V := Stack[0];
    P := @ A[V];
    if P <> null then
    begin
      U := P[0];
      reduced P := P[1];
      Stack := [U, Stack];
      P := @ A[U];
      while P <> null do
      begin
        if P[0] = V then
        begin
          reduced P := P[1];
          break;
        end;
        P := @ P[1];
      end;
    end
    else
    begin
      reduced Stack := Stack[1];
      result := [V, result];
    end;
  end;
end;

var A[10], Path, P: Variant;

begin
  A[1] := [2, [3, null]];
  A[2] := [1, [3, [7, [8, null]]]];
  A[3] := [1, [2, [4, [5, null]]]];
  A[4] := [3, [5, null]];
  A[5] := [3, [4, [6, [8, null]]]];
  A[6] := [5, [7, [8, [9, null]]]];
  A[7] := [2, [6, [8, [9, null]]]];
  A[8] := [2, [5, [6, [7, null]]]];
  A[9] := [6, [7, null]];

  Path := Cycle(1, @A);

  writeln('Euler path:');
  P := @ Path;
  while P <> null do
  begin
    writeln(P[0]);
    P := @ P[1];
  end;
end.

