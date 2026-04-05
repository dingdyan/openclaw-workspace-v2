var Key = 0, Left = 1, Right = 2;

function AddNode(Root, X){
  if (Root == null)
    Root = [X, null, null];
  else if (X < Root[Key])
    AddNode(& Root[Left], X);
  else if (X > Root[Key])
    AddNode(& Root[Right], X);
}

function Search(Root, X){
  if (Root == null)
    return null;
  else if (X == Root[Key])
    return Root;
  else if (X < Root[Key])
    return Search(Root[Left], X);
  else
    return Search(Root[Right], X);
}

function DeleteNode(Root, X){
  var P, R;
  R = Search(Root, X);

  if (R == null) return;

  if ((R[Left] == null) && (R[Right] == null))
    reduced R = null;
  else if (R[Left] == null)
    reduced R = R[Right];
  else if (R[Right] == null)
    reduced R = R[Left];
  else {
    P = & R[Left];
    while (P[Right] != null) { P = & P[Right]; };
    R[Key] = P[Key];
    reduced P = P[Left];
  }
}

function PreOrder(Root){
  if (Root == null) return;
  println Root[Key];
  PreOrder(Root[Left]);
  PreOrder(Root[Right]);
}

function InOrder(Root){
  if (Root == null) return;
  InOrder(Root[Left]);
  println Root[Key];
  InOrder(Root[Right]);
}

function PostOrder(Root){
  if (Root == null) return;
  PostOrder(Root[Right]);
  PostOrder(Root[Left]);
  println Root[Key];
}

var Tree, X;

AddNode(&Tree, 10);
AddNode(&Tree, 5);
AddNode(&Tree, 15);
AddNode(&Tree, 3);
AddNode(&Tree, 8);
AddNode(&Tree, 13);
AddNode(&Tree, 18);
println Tree;
InOrder(Tree);

X = Search(Tree, 5);
println X;

DeleteNode(&Tree, 10);
println Tree;

