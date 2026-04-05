var a = new Array(3)
a[2] = 12;
println a;
println a.length;
a[5] = 36;
println a;
println a.length;
var d = a.concat([1,2,3]);
println d.length;
println d;
var s = d.join('-');
println s;
println d.pop;
println d.length;
d.push(40, 50);
println d;
println d.length;
d.reverse();
println d;
println d.shift();
println d;
u = d.slice(2, -1);
println u;
d.sort();
println d;
d.unshift('abc', 'pq');
println d;

