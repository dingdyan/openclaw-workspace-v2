x = new Object
y = new Object

y.p = "abc"
y.javascript_method = f
y.pascal_method = Fact

x.prototype = y

println x.prototype.p
println x.p

x.p = 123

println x.prototype.p
println y.p

println x.javascript_method(2, 3)
println y.javascript_method(2, 3)

println y.pascal_method(5)
println x.pascal_method(5)

function f(u, v){
  return (u + v)
}

