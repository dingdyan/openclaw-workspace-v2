Namespace MyTask

  Class B 
    Private x As String = "abc", y As Integer = 700

    Sub New() 
    End Sub

    Shared Function Create()
      Return (New B())
    End Function

  End Class

End Namespace

