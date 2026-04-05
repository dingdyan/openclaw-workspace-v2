function Complex(re, im)
{
  this.re = re;
  this.im = im;

  this.op_Addition = function (x, y){ return new Complex(x.re + y.re, x.im + y.im); }
  this.op_Subtraction = function (x, y){ return new Complex(x.re - y.re, x.im - y.im); }
  this.op_Multiply = function (x, y){ return new Complex(x.re * y.re - x.im * y.im,
                                                         x.re * y.im + y.re * x.im); }
  this.op_Division = function (x, y)
                     {
                       result = new Complex(0, 0);
                       d = y.re * y.re + y.im * y.im;
                       result.re = (x.re * y.re + x.im * y.im) / d;
                       result.im = (x.im * y.re - x.re * y.im) / d;
                       return result;
                     }
  this.op_Negation = function (x){ return new Complex(- x.re, - x.im); }
  this.op_Equality = function op_Equality(x, y) { return (x.re == y.re) && (x.im == y.im); }
  this.op_Inequality = function op_Inequality(x, y) { return (x.re != y.re) || (x.im != y.im); }
}

c1 = new Complex(10, 20);
c2 = new Complex(30, 40);
c3 = c1 + c2;
println c3.re, " ", c3.im;
c3 = c1 - c2;
println c3.re, " ", c3.im;
c3 = c1 * c2;
println c3.re, " ", c3.im;
c3 = c1 / c2;
println c3.re, " ", c3.im;
c3 = - c3;
println c3.re, " ", c3.im;
println c1 == c2;
println c1 != c2;

