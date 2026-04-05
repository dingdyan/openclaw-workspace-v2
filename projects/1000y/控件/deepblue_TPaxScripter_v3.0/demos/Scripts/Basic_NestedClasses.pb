Class Outer
  Inherits TObject
  Private x As Integer = 10
  Shared Dim y = "abc"
  
  Sub New()
    Me = MyBase.Create()
  End Sub

  Class Inner
    Inherits TObject
    Private x As Integer = 20
    
    Sub PrintData
      println x, y
    End Sub
    
    Sub New()
      Me = MyBase.Create()
    End Sub
    
  End Class
End Class

Dim O = New Outer(), I = New Outer.Inner()
println O, I
I.PrintData
