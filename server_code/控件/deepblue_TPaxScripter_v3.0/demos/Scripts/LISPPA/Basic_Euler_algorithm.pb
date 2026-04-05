' Euler algorithm

Function Cycle(InitV, A)
  Dim  P, Stack, U, V, result
  result = NULL
  Stack = [InitV, NULL]
  Do Until Stack = NULL
    V = Stack(0)
    P = AddressOf A(V)
    If P <> NULL Then
      U = P(0)
      Reduced P = P(1)
      Stack = [U, Stack]
      P = AddressOf A(U)
      Do Until P = NULL
        If P(0) = V Then
          Reduced P = P(1)
          Exit Do
        End If
        P = AddressOf P(1)
      Loop
    Else
      Reduced Stack = Stack(1)
      result = [V, result]
    End If
  Loop
  Return result
End Function

Dim A[10], Path, P

A[1] = [2, [3, NULL]]
A[2] = [1, [3, [7, [8, NULL]]]]
A[3] = [1, [2, [4, [5, NULL]]]]
A[4] = [3, [5, NULL]]
A[5] = [3, [4, [6, [8, NULL]]]]
A[6] = [5, [7, [8, [9, NULL]]]]
A[7] = [2, [6, [8, [9, NULL]]]]
A[8] = [2, [5, [6, [7, NULL]]]]
A[9] = [6, [7, NULL]]

Path = Cycle(1, A)

println "Euler path: "
P = AddressOf Path
Do Until P = NULL
  println P(0)
  P = AddressOf P(1)
Loop

