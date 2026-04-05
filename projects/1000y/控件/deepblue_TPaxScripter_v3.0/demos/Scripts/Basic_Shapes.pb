Namespace Shapes
  Class Point
    Private X As Integer, Y As Integer
    Sub New (X As Integer, Y As Integer)
      Me.X = X
      Me.Y = Y
    End Sub
  End Class

  Class Circle
    Inherits Point
    Private R As Integer
    Sub New(X As Integer, Y As Integer, R As Integer)
      MyBase.New(X, Y)
      Me.R = R
    End Sub
  End Class
End Namespace

Dim P = New Shapes.Point(3, 5), C = New Shapes.Circle(3, 5, 7)
println P, C

