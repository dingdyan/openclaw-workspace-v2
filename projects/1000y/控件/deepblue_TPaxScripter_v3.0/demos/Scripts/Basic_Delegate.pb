Imports StdCtrls, Forms

Dim F As TForm = new TForm(NULL)
Dim B As TButton = new TButton(F)

F.Show
B.Parent = F
B.Caption = "Click Me"
B.OnMouseDown = AddressOf MouseHandler

Sub MouseHandler(Sender, Button, Shift, X, Y)
  println Sender.Caption
  println Button
  println Shift
  println X
  println Y
End Sub

