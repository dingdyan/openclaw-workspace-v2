Structure RandomPoint
  Dim X As Integer = rnd(0, 100)
  Dim Y As Integer = rnd(0, 100)
End Structure

Structure RandomCircle
  Inherits RandomPoint
  Dim R As Integer = rnd(0, 100)
End Structure

Dim C As RandomCircle
println C

