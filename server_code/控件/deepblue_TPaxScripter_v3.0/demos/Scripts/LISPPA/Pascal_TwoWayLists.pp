program Demo;

function Insert(Value, P: Variant): Variant;
begin
  result := [Value, P];
  if P <> null then
    P.Owner := result;
  P := result;
end;

function Add(Value, P: Variant): Variant;
begin
  if P = null then
    result := Insert(Value, P)
  else
  begin
    result := Insert(Value, @ P[1]);
    result.Owner := P;
  end;
end;

function Remove(Value, L: Variant): Variant;
var
  temp: Variant;
begin
  result := @ Find(Value, L);
  if result <> null then
  begin
    temp := result.Owner;
    reduced result := result[1];
    if result <> null then
      result.Owner := temp;
  end;
end;

function Find(Key, P: Variant): Variant;
begin
  result := @ P;
  while result <> null do
  begin
    if result[0] = Key then
      Exit;
    result := @ result[1];
  end;
  result := null;
end;

procedure StraightOrder(A: Variant);
var
  P: Variant;
begin
  P := A;
  while P <> null do
  begin
    writeln(P[0]);
    P := P[1];
  end;
end;

procedure BackOrder(A: Variant);
var
  P: Variant;
begin
  if A = null then
    writeln(A)
  else
  begin
    P := A;
    while P[1] <> null do P := P[1];
    while P <> null do
    begin
      println P[0];
      P := P.Owner;
    end;
  end;
end;

var
  A, P: Variant;
begin
  A := null;

  Add(300, @ A);

  Insert(100, @ A);
  Insert(50, @ A);
  writeln(A);
  BackOrder(A);

  P := Find(300, A);
  Add(400, @ P);
  writeln(A);
  BackOrder(A);

  P := Find(300, A);
  Add(350, @ P);
  writeln(A);
  BackOrder(A);

  P := Find(100, A);
  Add(150, @ P);
  writeln(A);
  BackOrder(A);

  Remove(100, A);
  writeln(A);
  BackOrder(A);

  writeln(A);
  StraightOrder(A);
end.

