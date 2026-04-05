uses Classes;
var
  t, i: Integer;
  l: TList;
begin
  t := GetTickCount();
  l := TList.Create;
  for i := 0 to 200000 do
  begin
    l.Add(nil);
    l.Delete(0);
  end;
  println GetTickCount() - t;
end.
