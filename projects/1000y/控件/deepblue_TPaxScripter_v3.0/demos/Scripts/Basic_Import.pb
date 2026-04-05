Imports StdCtrls, Forms

Class MyForm
  Inherits TForm
  Private Memo As TMemo
  
  Sub New(Owner As TComponent)
    Me = MyBase.Create(Owner)
    Top = 100
    Left = 200
    Caption = "MyForm"
    
    Memo = New TMemo(Me)
    Memo.Parent = Me
    Memo.Width = 100
    Memo.Align = "alClient"
  End Sub
End Class

Dim F As MyForm = New MyForm(NULL)
F.Show
