using StdCtrls, Forms;

var F = new TForm(NULL);
var B = new TButton(F);

F.Show();
B.Parent = F;
B.OnMouseDown = MouseHandler;
B.Caption = 'Click Me';

function MouseHandler(Sender, Button, Shift, X, Y){
  println Sender.Caption;
  println Button;
  println Shift;
  println X;
  println Y;
}


