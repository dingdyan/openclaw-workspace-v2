program BinaryTrees;
const
  Key   = 0;
  Left  = 1;
  Right = 2;
  
procedure AddNode(const Root, X: Variant);
begin
  if Root = null then
    Root := [X, null, null]
  else if X < Root[Key] then
    AddNode(@Root[Left], X)
  else if X > Root[Key] then
    AddNode(@Root[Right], X);
end;

function Search(const Root, X: Variant);
begin
  if Root = null then
    result := null
  else if X = Root[Key] then
    result := Root
  else if X < Root[Key] then
    result := Search(Root[Left], X)
  else
    result := Search(Root[Right], X);
end;

procedure DeleteNode(Root, X: Variant);
var
  P, R: Variant;
begin
  R := Search(Root, X);

  if R = null then Exit;

  if (R[Left] = null) and (R[Right] = null) then
    reduced R := null
  else if R[Left] = null then
    reduced R := R[Right]
  else if R[Right] = null then
    reduced R := R[Left]
  else
  begin
    P := @ R[Left];
    while P[Right] <> null do P := @ P[Right];
    R[Key] := P[Key];
    reduced P := P[Left];
  end;
end;

procedure PreOrder(const Root: Variant);
begin
  if Root = null then Exit;
  writeln(Root[Key]);
  PreOrder(Root[Left]);
  PreOrder(Root[Right]);
end;

procedure InOrder(const Root: Variant);
begin
  if Root = null then Exit;
  InOrder(Root[Left]);
  writeln(Root[Key]);
  InOrder(Root[Right]);
end;

procedure PostOrder(const Root: Variant);
begin
  if Root = null then Exit;
  PostOrder(Root[Right]);
  PostOrder(Root[Left]);
  writeln(Root[Key]);
end;

var
  Tree, X: Variant;
begin
  AddNode(@Tree, 10);
  AddNode(@Tree, 5);
  AddNode(@Tree, 15);
  AddNode(@Tree, 3);
  AddNode(@Tree, 8);
  AddNode(@Tree, 13);
  AddNode(@Tree, 18);
  writeln(Tree);
  InOrder(Tree);

  X := Search(Tree, 5);
  writeln(X);

  DeleteNode(@Tree, 10);
  writeln(Tree);
end.


