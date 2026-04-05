program Lists;

var
  L, P: Variant;
  I: Integer;
begin
  writeln('Create a list');
  L := [100, [200, [300, null]]];
  writeln(L);

  writeln('Insert new item at the beginning');
  L := [50, L];
  writeln(L);

  writeln('Add new item at the end');
  P := @L; // Create alias of L
  while P <> null do P := @P[1]; // Find last item
  P := [400, null]; // Add new item
  writeln(L);

  writeln('Insert new item at the middle');
  P := @L[1];
  P := @P[1]; // insert before 200
  P := [150, P];
  writeln(L);

  writeln('Print list');
  P := @L; // create alias of L
  while P <> null do
  begin
    writeln(P[0]);
    P := @P[1]; // go to the next item
  end;

  writeln('Delete the first item of the list');
  reduced L := L[1];
  writeln(L);

  writeln('Delete the last item of the list');
  P := @L; // Create alias of L
  while P[1] <> null do P := @P[1]; // Find last item
  reduced P := P[1];
  writeln(L);

  writeln('Delete item at the middle of the list');
  P := @L;
  P := @P[1];
  reduced P := P[1];
  writeln(L);

  writeln('Delete all items from the list');
  while L <> null do reduced L := L[1];
  writeln(L);

  writeln('Create a cycled list');
  L := [100, [200, [300, null]]];
  L[1][1][1] := @L; // join head and tail of the list
  writeln(L);

  delete L;

  writeln('Another way to create a cycled list');
  L := [100, [200, [300, null]]];
  P := @L; // Create alias of L
  while P <> null do P := @P[1]; // Find last item
  P^ := @L; // join head and tail of the list
  writeln(L);

  writeln('Print the cycled list');
  P := @L;
  I := 0;
  repeat
    writeln(P[0]);
    P := @P[1];
    Inc(I);
  until I = 15;
end.

