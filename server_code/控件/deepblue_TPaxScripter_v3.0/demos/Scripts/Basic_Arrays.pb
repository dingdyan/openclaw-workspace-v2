Class AClass

   Dim fZ = [10, 20, 30, 40, 50]
   
   Sub New()
   End Sub
   
   Default Property Z(I As Integer) As Integer
     Get
       return fZ(I)
     End Get
     Set
       fZ(I) = Value
     End Set
   End Property
   
End Class

Dim X = new AClass()
X(1) = 90
println X


