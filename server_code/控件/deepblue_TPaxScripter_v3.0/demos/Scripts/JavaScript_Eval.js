println eval('3 + 2');

x = new Function("x", "return x + x;");
println x(3);
y = x;
println y(4);

z = eval('function f(x, y, z) {return x + y + z;}');
println f(1, 2, 3);
println z(4, 5, 6);


