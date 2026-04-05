Dim Key = 0, Left = 1, Right = 2

Sub AddNode(Root, X)
  If Root = NULL Then
    Root = [X, NULL, NULL]
  ElseIf X < Root(Key) Then
    AddNode(AddressOf Root(Left), X)
  ElseIf X > Root(Key) Then
    AddNode(AddressOf Root(Right), X)
  End If
End Sub

Function Search(Root, X)
  If Root = NULL Then
    Return NULL
  ElseIf X = Root(Key) Then
    Return Root
  ElseIf X < Root(Key) Then
    Return Search(Root(Left), X)
  Else
    Return Search(Root(Right), X)
  End If
End Function

Sub DeleteNode(Root, X)
  Dim  P, R
  
  R = Search(Root, X)

  If R = NULL Then
    Exit Sub
  ElseIf (R(Left) = NULL) And (R(Right) = NULL) Then
    Reduced R = NULL
  ElseIf R(Left) = NULL Then
    Reduced R = R(Right)
  ElseIF R(Right) = NULL Then
    Reduced R = R[Left]
  Else
    P = AddressOf R(Left)
    Do Until P(Right) = NULL
      P = AddressOf P(Right)
    Loop
    R(Key) = P(Key)
    Reduced P = P(Left)
  End If
End Sub

Sub PreOrder(Root)
  If Root <> NULL Then
    println Root(Key)
    PreOrder(Root(Left))
    PreOrder(Root(Right))
  End If
End Sub

Sub InOrder(Root)
  If Root <> NULL Then
    InOrder(Root(Left))
    println Root(Key)
    InOrder(Root(Right))
  End If
End Sub

Sub PostOrder(Root)
  If Root <> NULL Then
    PostOrder(Root(Right))
    PostOrder(Root(Left))
    println Root(Key)
  End If
End Sub

Dim Tree, X

AddNode(AddressOf Tree, 10)
AddNode(AddressOf Tree, 5)
AddNode(AddressOf Tree, 15)
AddNode(AddressOf Tree, 3)
AddNode(AddressOf Tree, 8)
AddNode(AddressOf Tree, 13)
AddNode(AddressOf Tree, 18)
println Tree
PreOrder(Tree)

X = Search(Tree, 5)
println X

DeleteNode(AddressOf Tree, 10)
println Tree
