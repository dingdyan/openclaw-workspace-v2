Imports Classes

Dim I As Integer
Dim L As TList = New TList()
Dim SL As TStringList = New TStringList()

L.Add(2)
L.Add(New TObject())
L.Add(5)
L.Add(7)

For I = 0 to L.Count - 1
  println L(I)
Next I

With SL
  .Add("abc")
  .Add("pqr")
  .Add("xyx")
End With

For I = 0 to SL.Count - 1
  println SL(I)
Next

