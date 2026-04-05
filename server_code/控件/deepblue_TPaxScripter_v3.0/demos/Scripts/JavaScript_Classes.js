using Classes;

L = new TList();

L.Add(2);
L.Add(new TObject());
L.Add(5);
L.Add(7);

for (I = 0; I < L.Count; I++)
  println L[I];

SL = new TStringList();

with (SL) {
  Add("abc");
  Add("pqr");
  Add("xyx");
}

for (var I = 0; I < SL.Count; I++)
  println SL[I];

