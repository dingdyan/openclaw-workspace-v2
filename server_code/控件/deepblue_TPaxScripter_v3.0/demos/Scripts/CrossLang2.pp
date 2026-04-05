program Demo;
var
  A, B: Variant;
begin
  A := paxJavaScriptNamespace.Array.Create(10, 20, 30);
  println A;
  println A.length;
  A[10] := 100;
  A.push(110);
  println A;
  println A.length;
  
  B := paxJavaScriptNamespace.Object.Create();
  B.NewProp := 'abc';
  println B.NewProp;
end.

