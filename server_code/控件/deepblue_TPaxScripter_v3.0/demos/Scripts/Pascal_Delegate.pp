uses StdCtrls, Forms;
var
  F = TForm.Create(nil),
  B = TButton.Create(F);

F.Show;
B.Parent := F;
B.OnMouseDown := @ MouseHandler;
B.Caption := 'Click Me';

procedure MouseHandler(Sender, Button, Shift, X, Y);
begin
  println Sender.Caption;
  println Button;
  println Shift;
  println X;
  println Y;
end;




