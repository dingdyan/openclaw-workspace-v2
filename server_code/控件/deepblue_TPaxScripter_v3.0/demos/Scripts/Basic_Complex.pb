Structure Complex
  Dim re As Double
  Dim im As Double
  Shared Dim i As Complex = (0.0, 1.0)
  ' "+"
  Operator + (x As Complex, y As Complex) As Complex
    Dim result As Complex = (x.re + y.re, x.im + y.im)
    return result
  End Operator
  Operator + (x As Double, y As Complex) As Complex
    Dim result As Complex = (x + y.re, y.im)
    return result
  End Operator
  Operator + (x As Complex, y As Double) As Complex
    Dim result As Complex = (x.re + y, x.im)
    return result
  End Operator
  ' "-"
  Operator - (x As Complex, y As Complex) As Complex
    Dim result As Complex = (x.re - y.re, x.im - y.im)
    return result
  End Operator
  Operator - (x As Double, y As Complex) As Complex
    Dim result As Complex = (x - y.re, - y.im)
    return result
  End Operator
  Operator - (x As Complex, y As Double) As Complex
    Dim result As Complex = (x.re - y, x.im)
    return result
  End Operator
  ' unary "-"
  Operator - (x As Complex) As Complex
    Dim result As Complex = (-x.re, -x.im)
    return result
  End Operator
  ' "*"
  Operator * (x As Complex, y As Complex) As Complex
    Dim result As Complex = (x.re * y.re - x.im * y.im, x.re * y.im + y.re * x.im)
    return result
  End Operator
  Operator * (x As Complex, y As Double) As Complex
    Dim result As Complex = (x.re * y, x.im * y)
    return result
  End Operator
  Operator * (x As Double, y As Complex) As Complex
    Dim result As Complex = (y.re * x, y.im * x)
    return result
  End Operator
  ' "/"
  Operator / (x As Complex, y As Complex) As Complex
    Dim result As Complex
    Dim d As Double = y.re * y.re + y.im * y.im
    result.re = (x.re * y.re + x.im * y.im) / d
    result.im = (x.im * y.re - x.re * y.im) / d
    return result
  End Operator
  Operator / (x As Complex, y As Double) As Complex
    Dim result As Complex = (x.re / y, x.im / y)
    return result
  End Operator
  Operator / (x As Double, y As Complex) As Complex
    Dim result As Complex
    Dim d As Double = y.re * y.re + y.im * y.im
    result.re = x * y.re / d
    result.im = - x * y.im / d
    return result
  End Operator
  ' "="
  Operator = (x As Complex, y As Complex) As Boolean
    return (x.re = y.re) and (x.im = y.im)
  End Operator
  Operator = (x As Double, y As Complex) As Boolean
    return (x = y.re) and (0.0 = y.im)
  End Operator
  Operator = (x As Complex, y As Double) As Boolean
    return (x.re = y) and (x.im = 0.0)
  End Operator
  ' "<>"
  Operator <> (x As Complex, y As Complex) As Boolean
    return (x.re <> y.re) or (x.im <> y.im)
  End Operator
  Operator <> (x As Double, y As Complex) As Boolean
    return (x <> y.re) or (0.0 <> y.im)
  End Operator
  Operator <> (x As Complex, y As Double) As Boolean
    return (x.re <> y) or (x.im <> 0.0)
  End Operator
End Structure

Dim x As Complex, y As Complex, z As Complex

println Complex.i.re

x.re = 56.7
x.im = 8
y.re = 12
y.im = 22.2
z = x + y
println x, y, z
