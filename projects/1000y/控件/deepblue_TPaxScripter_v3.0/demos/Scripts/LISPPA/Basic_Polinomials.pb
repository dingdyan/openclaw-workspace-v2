' Addition of polynomials (a cyclic linked list application).

Sub Add(InitP, InitQ)
  Dim P, Q
  P = AddressOf InitP
  Q = AddressOf InitQ
  Do
    While P(0)(1) < Q(0)(1)
      Q = AddressOf Q(1)
    End While

    If P(0)(1) > Q(0)(1) Then
      Q = [ + P[0], Q]
    Else
      Q(0)(0) = Q(0)(0) + P(0)(0)
      If Q(0)(0) = 0 Then
        Reduced Q = Q(1)
      Else
        Q = AddressOf Q(1)
      End If
    End If
    P = AddressOf P(1)
  Loop Until P(0)(1) < 0
End Sub

Sub Show(P)
  Println ""
  Do
    Print P(0)(0), "X^", P(0)(1)

    P = AddressOf P(1)

    If P(0)(1) < 0 Then
      Exit Do
    End If

    If P(0)(0) >= 0 Then
      Print "+"
    End If
  Loop Until false
End Sub

Dim P, Q
P = [[0, -1], NULL]
P(1) = AddressOf P
P = [[600, 1], P]
P = [[10, 2], P]
P = [[70, 5], P]
P = [[150, 6], P]
P = [[80, 7], P]

Q = [[0, -1], NULL]
Q(1) = AddressOf Q
Q = [[600, 1], Q]
Q = [[170, 3], Q]
Q = [[ 60, 5], Q]
Q = [[-150, 6], Q]

Println "Source polynomials:"
Show(P)
Show(Q)
Add(P, AddressOf Q)
println "Sum:"
Show(Q)


