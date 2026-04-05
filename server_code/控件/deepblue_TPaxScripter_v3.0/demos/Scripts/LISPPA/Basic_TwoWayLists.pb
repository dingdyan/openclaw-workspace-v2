Function Insert(Value, P)
  Dim result = [Value, P]
  If P <> null Then
    P.Owner = result
  End If
  P = result
  return result
End Function

Function Add(Value, P)
  Dim result
  If P = null Then
    result = Insert(Value, P)
  Else
    result = Insert(Value, AddressOf P(1))
    result.Owner = P
  End If
  return result
End Function

Function Remove(Value, L)
  Dim temp, result
  result = AddressOf Find(Value, L)
  If result <> null Then
    temp = result.Owner
    Reduced result = result(1)
    If result <> null Then
      result.Owner = temp
    End If
  End If
End Function

Function Find(Key, P)
  Dim result = AddressOf P
  Do While result <> null
    If result(0) = Key Then
      Return result
    End If
    result = AddressOf result(1)
  Loop
  Return null
End Function

Sub StraightOrder(A)
  Dim P = A
  Do While P <> null
    Println P(0)
    P = P(1)
  Loop
End Sub

Sub BackOrder(A)
  Dim P
  If A = null Then
    println A
  Else
    P = A
    Do While P(1) <> null
      P = P(1)
    Loop
    Do While P <> null
      Println P(0)
      P = P.Owner
    Loop
  End If
End Sub

println "start"

Dim A = null, P

Add(300, AddressOf A)

Insert(100, AddressOf A)
Insert(50, AddressOf A)
Println A
BackOrder(A)

P = Find(300, A)
Add(400, AddressOf P)
Println A
BackOrder(A)

P = Find(300, A)
Add(350, AddressOf P)
Println A
BackOrder(A)

P = Find(100, A)
Add(150, AddressOf P)
Println A
BackOrder(A)

Remove(100, A)
Println A
BackOrder(A)

Println A
StraightOrder(A)

