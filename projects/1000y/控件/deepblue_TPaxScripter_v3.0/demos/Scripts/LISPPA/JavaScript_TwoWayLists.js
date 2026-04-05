function Insert(Value, P){
  result = [Value, P];
  if (P != null) P.Owner = result;
  P = result;
  return result;
}

function Add(Value, P){
  if (P == null)
    return Insert(Value, P);
  else {
    result = Insert(Value, & P[1]);
    result.Owner = P;
    return result;
  }
}

function Remove(Value, L){
  result = & Find(Value, L);
  if (result != null) {
    temp = result.Owner;
    reduced result = result[1];
    if (result != null) result.Owner = temp;
  }
  return result;
}

function Find(Key, P){
  result = & P;
  while (result != null) {
    if (result[0] == Key) return result;
    result = & result[1];
  }
  return null;
}

function StraightOrder(A){
  P = A;
  while (P != null) {
    println P[0];
    P = P[1];
  }
}

function BackOrder(A){
  if (A == null) println A;
  else {
    P = A;
    while (P[1] != null)
      P = P[1];
    while (P != null) {
      println P[0];
      P = P.Owner;
    }
  }
}

var A = null, P;
Add(300, & A);

Insert(100, & A);
Insert(50, & A);
println A;
BackOrder(A);

P = Find(300, A);
Add(400, & P);
println A;
BackOrder(A);

P = Find(300, A);
Add(350, & P);
println A;
BackOrder(A);

P = Find(100, A);
Add(150, & P);
println A;
BackOrder(A);

Remove(100, A);
println A;
BackOrder(A);

println A;
StraightOrder(A);

