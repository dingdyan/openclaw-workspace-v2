program Demo;
uses
  Classes;
var
  I: Integer;
  L: TList;
  SL: TStringList;
begin
  L := TList.Create;
  SL := TStringList.Create;

  L.Add(2);
  L.Add(TObject.Create);
  L.Add(5);
  L.Add(7);

  for I:=0 to L.Count - 1 do
    writeln(I, L[I]);

  with SL do
  begin
    Add('abc');
    Add('pqr');
    Add('xyx');
  end;

  for I:=0 to SL.Count - 1 do
    writeln(SL[I]);
end;


