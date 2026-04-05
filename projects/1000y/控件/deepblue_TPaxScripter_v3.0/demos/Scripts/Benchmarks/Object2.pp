uses Classes;
var
  t, i: Integer;
  c: TComponent;
begin
  t := GetTickCount();
  c := TComponent.Create(nil);
  for i := 0 to 500000 do
    if c.Tag = 0 then
    begin
      c.Tag := 0;
      c.Name := 'c';
    end;
  println GetTickCount() - t;
end.
