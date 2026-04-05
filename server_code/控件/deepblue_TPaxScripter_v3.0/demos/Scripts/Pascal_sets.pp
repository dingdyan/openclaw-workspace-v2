type
  TMyEnum = (one, two, three);
  
var x: set;
    y: set of TMyEnum;

x := ["abc", 123, 3.14];
y := [one, two];

x := x + [123, 345];

println x;

println two in y;
