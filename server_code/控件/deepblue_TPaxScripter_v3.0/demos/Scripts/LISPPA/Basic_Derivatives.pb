' Symbolic computing. Differentiation.
'
' Gramma:
' Expression = Term { ( "+"|"-") Term  }
' Term =  Multiplier { "*"|"/" ) Multiplier }
' Multiplier = Factor { "^"  Factor }
' Factor = Number | "X" | "LN"  "(" Expression ")" | "(" Expression ")" "-" Factor
' Number = Digit { Digit }
' Digit = "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"

Dim  X       = "X"
Dim  OP_ADD  = "+"
Dim  OP_MULT = "*"
Dim  OP_SUB  = "-"
Dim  OP_DIV  = "/"
Dim  OP_UN   = "~"
Dim  OP_LOG  = "ln"
Dim  OP_POW  = "^"

Function IsVar(Term As Variant) As Boolean
  If isString(Term) Then
    If Term = "X" Then
      Return true
    End If
  End If
  Return false
End Function

Function IsConstant(Term As Variant) As Boolean
  Return isNumber(Term)
End Function

Function IsZero(Term As Variant) As Boolean
  If IsConstant(Term) Then
    If Term = 0 Then
      Return true
    End If
  End If
  Return false
End Function

Function IsUnit(Term As Variant) As Boolean
  If IsConstant(Term) Then
    If Term = 1 Then
      Return true
    End If
  End If
  Return false
End Function

Function IsCompound(Term As Variant) As Boolean
  Return isPaxArray(Term)
End Function

Function IsPow(Term As Variant) As Boolean
  If IsCompound(Term) Then
    If Term(0) = OP_POW Then
      Return true
    End If
  End If
  Return false
End Function

Function IsMult(Term As Variant) As Boolean
  If IsCompound(Term) Then
    If Term(0) = OP_MULT Then
      Return true
    End If
  End If
  Return false
End Function

Function IsAdd(Term As Variant) As Boolean
  If IsCompound(Term) Then
    If Term(0) = OP_ADD Then
      Return true
    End If
  End If
  Return false
End Function

Function IsSub(Term As Variant) As Boolean
  If IsCompound(Term) Then
    If Term(0) = OP_SUB Then
      Return true
    End If
  End If
  Return false
End Function

Function IsNeg(Term As Variant) As Boolean
  If IsCompound(Term) Then
    If Term(0) = OP_UN Then
      Return true
    End If
  End If
  Return false
End Function

Function Diff(A As Variant) As Variant
  Dim X1, X2, R1, R2, R3 As Variant
  Dim Oper As String
  If IsCompound(A) Then
    Oper = A(0)
    X1 = AddressOf A(1)
    If A.length >= 3 Then
      X2 = AddressOf A(2)
    End If

    If Oper = OP_ADD Then
      Return [Oper, Diff(X1), Diff(X2)]
    ElseIf Oper = OP_SUB Then
      Return [Oper, Diff(X1), Diff(X2)]
    ElseIf Oper = OP_UN Then
      Return [Oper, Diff(X1)]
    ElseIf Oper = OP_MULT Then
      Return [OP_ADD, [OP_MULT, Diff(X1), X2], [OP_MULT, X1, Diff(X2)]]
    ElseIf Oper = OP_DIV Then
      R1 = [OP_DIV, Diff(X1), X2]
      R2 = [OP_MULT, X1, Diff(X2)]
      R3 = [OP_MULT, X2, X2]
      Return [OP_SUB, R1, [OP_DIV, R2, R3]]
    ElseIf Oper = OP_LOG Then
      Return [OP_DIV, Diff(X1), X1]
    ElseIf Oper = OP_POW Then
      R1 = [OP_MULT, Diff(X1), [OP_MULT, X2, [OP_POW, X1, [OP_SUB, X2, 1]]]]
      R2 = [OP_MULT, Diff(X2), [OP_MULT, [OP_LOG, X1], [OP_POW, X1, X2 ]]]
      Return [OP_ADD, R1, R2]
    Else
      println "Syntax error !"
    End If
  ElseIf IsVar(A) Then
    Return 1
  Else
    Return 0
  End If
End Function

Function InOrder(A As Variant) As String
  Dim LL, RR, Oper As String
  If IsCompound(A) Then
    If A.length = 2 Then
      Oper = A(0)
      If Oper = OP_UN Then
        Oper = OP_SUB
      End If

      RR = InOrder(A(1))

      If (Oper = OP_LOG) And (Substr(RR, 1, 1) <> "(") Then
        Return "ln" + "(" + RR + ")"
      Else
        Return "(" + Oper + RR + ")"
      End If
    ElseIf A.length = 3 Then
      Oper = A(0)
      LL = InOrder(A(1))
      RR = InOrder(A(2))

      If (Substr(RR, 1, 1) = OP_SUB) And (Oper = OP_ADD) Then
        Oper = ""
      End If

      Return "(" + LL + Oper + RR + ")"
    End If
  Else
    Return toString(A)
  End If
End Function

Sub Compress(R As Variant)
  Dim K As Integer
  Dim Oper As String
  Dim X1, X2, U, V As Variant
  Dim Ground As Boolean
  
  If IsCompound(R) Then
    K = R.length
  Else
    K = 0
  End If

  If K = 2 Then
    Oper = R(0)
    If Oper = OP_UN Then
      X1 = AddressOf R(1)
      If IsCompound(X1) Then
        Compress(X1)
      End If
      If IsConstant(X1) Then
        X1 = - X1
      End If
    End If
  ElseIf K = 3 Then
    Oper = R(0)
    X1 = AddressOf R(1)
    X2 = AddressOf R(2)

    If IsCompound(X1) Then
      Compress(X1)
    End If
    
    If IsCompound(X2) Then
      Compress(X2)
    End If

    Ground = IsConstant(X1) And IsConstant(X2)

    If Oper = OP_ADD Then
      If Ground Then
        reduced R = X1 + X2
      ElseIf IsZero(X1) Then
        reduced R = X2
      ElseIf IsZero(X2) Then
        reduced R = X1
      ElseIf X1 = X2 Then
        reduced R = [OP_MULT, 2, X1]
      ElseIf IsNeg(X1) And (Not IsNeg(X2)) Then
        reduced R = [OP_SUB, X2, X1(1)]
      ElseIf IsNeg(X2) And (Not IsNeg(X1)) Then
        reduced R = [OP_SUB, X1, X2(1)]
      ElseIf IsMult(X1) And IsMult(X2) Then
        If X1(1) = X2(1) Then
          reduced R = [OP_MULT, X1(1), [OP_ADD, X1(2), X2(2)]]
        ElseIf X1(2) = X2(2) Then
          reduced R = [OP_MULT, X1(2), [OP_ADD, X1(1), X2(1)]]
        End If
      ElseIf IsMult(X1) Then
        If X1(1) = X2 Then
           reduced R = [OP_MULT, X2, [OP_ADD, X1(2), 1]]
        ElseIf X1(2) = X2 Then
           reduced R = [OP_MULT, X2, [OP_ADD, X1(1), 1]]
        End If
      ElseIf IsMult(X2) Then
        If X2(1) = X1 Then
           reduced R = [OP_MULT, X1, [OP_ADD, X2(2), 1]]
        ElseIf X2(2) = X1 Then
           reduced R = [OP_MULT, X1, [OP_ADD, X2(1), 1]]
        End If
      ElseIf IsAdd(X1) And IsConstant(X2) Then
        If IsConstant(X1(1)) Then
           reduced R = [OP_ADD, X1(2), X1(1) + X2]
        ElseIf IsConstant(X1(2)) Then
           reduced R = [OP_ADD, X1(1), X1(2) + X2]
        End If
      ElseIf IsAdd(X2) And IsConstant(X1) Then
        If IsConstant(X2(1)) Then
           reduced R = [OP_ADD, X2(2), X2(1) + X1]
        ElseIf IsConstant(X2(2)) Then
           reduced R = [OP_ADD, X2(1), X2(2) + X1]
        End If
      ElseIf IsSub(X1) And IsConstant(X2) Then
        If IsConstant(X1(1)) Then
           reduced R = [OP_SUB, X1(1) + X2, X1(2)]
        ElseIf IsConstant(X1(2)) Then
           reduced R = [OP_ADD, X2 - X1(2), X1(1)]
        End If
      ElseIf IsSub(X2) And IsConstant(X1) Then
        If IsConstant(X2(1)) Then
           reduced R = [OP_SUB, X1 + X2(1), X2(2)]
        ElseIf IsConstant(X2(2)) Then
           reduced R = [OP_ADD, X1 - X2(2), X2(1)]
        End If
      End If
    ElseIf Oper = OP_SUB Then
      If Ground  Then
        reduced R = X1 - X2
      ElseIf IsZero(X1) Then
        reduced R = [OP_UN, X2]
      ElseIf IsZero(X2) Then
        reduced R = X1
      ElseIf X1 = X2 Then
        reduced R = 0
      ElseIf IsNeg(X1) And (not IsNeg(X2)) Then
        reduced R = [OP_ADD, X1(1), X2]
      ElseIf IsNeg(X2) And (not IsNeg(X1)) Then
        reduced R = [OP_ADD, X1, X2(1)]
      ElseIf IsMult(X1) And IsMult(X2) Then
        If      X1(1) = X2(1) Then
          reduced R = [OP_MULT, X1(1), [OP_SUB, X1(2), X2(2)]]
        ElseIf X1(2) = X2(2) Then
          reduced R = [OP_MULT, X1(2), [OP_SUB, X1(1), X2(1)]]
        End If
      ElseIf IsMult(X1) Then
        If      X1(1) = X2 Then
           reduced R = [OP_MULT, X2, [OP_SUB, X1(2), 1]]
        ElseIf X1(2) = X2 Then
           reduced R = [OP_MULT, X2, [OP_SUB, X1(1), 1]]
        End If
      ElseIf IsMult(X2) Then
        If      X2(1) = X1 Then
           reduced R = [OP_MULT, X1, [OP_SUB, X2(2), 1]]
        ElseIf X2(2) = X1 Then
           reduced R = [OP_MULT, X1, [OP_SUB, X2(1), 1]] 
        End If
      ElseIf IsAdd(X1) And IsConstant(X2) Then
        If      IsConstant(X1(1)) Then
           reduced R = [OP_ADD, X1(2), X1(1) - X2]
        ElseIf IsConstant(X1(2)) Then
           reduced R = [OP_ADD, X1(1), X1(2) - X2] 
        End If
      ElseIf IsAdd(X2) And IsConstant(X1) Then
        If      IsConstant(X2(1)) Then
           reduced R = [OP_ADD, X2(2), X1 - X2(1)]
        ElseIf IsConstant( X2[ 3 ] ) Then
           reduced R = [OP_ADD, X2(1), X1 - X2(2)] 
        End If
      ElseIf IsSub(X1) And IsConstant(X2) Then
        If      IsConstant(X1(1)) Then
           reduced R = [OP_SUB, X1(1) - X2, X1(2)]
        ElseIf IsConstant(X1(2)) Then
           reduced R = [OP_SUB, X1(1), X2 + X1(2)] 
        End If
      ElseIf IsSub(X2) And IsConstant(X1) Then
        If      IsConstant(X2(1)) Then
           reduced R = [OP_ADD, X1 - X2(1), X2(2)]
        ElseIf IsConstant(X2(2)) Then
           reduced R = [OP_SUB, X1 - X2(2), X2(1)] 
        End If
      End If
    ElseIf Oper = OP_MULT Then
      If Ground  Then
        reduced R = X1 * X2
      ElseIf IsZero(X1) Then
        reduced R = 0
      ElseIf IsZero(X2) Then
        reduced R = 0
      ElseIf IsNeg(X1) Then
        reduced R = [OP_MULT, -1, [OP_MULT, X1(1), X2]]
      ElseIf IsNeg(X2) Then
        reduced R = [OP_MULT, -1, [OP_MULT, X2(1), X1]]
      ElseIf IsUnit(X1) Then
        reduced R = X2
      ElseIf IsUnit(X2) Then
        reduced R = X1
      ElseIf X1 = X2 Then
        reduced R = [OP_POW, X1, 2]
      ElseIf IsPow(X1) And IsPow(X2) And (X1(1) = X2(1)) Then
        reduced R = [OP_POW, X1(1), [OP_ADD, X1(2), X2(2)]]
      ElseIf IsPow(X1) And (X1(1) = X2) Then
        reduced R = [OP_POW, X1(1), [OP_ADD, X1(2), 1]]
      ElseIf IsPow(X2) And (X2(1) = X1) Then
        reduced R = [OP_POW, X2(1), [OP_ADD, X2(2), 1]]
      ElseIf IsMult(X1) And IsPow(X2) Then
        U = AddressOf X2(1)
        V = AddressOf X2(2)
        If X1(1) = U Then
          reduced R = [OP_MULT, X1(2), [OP_POW, U, [OP_ADD, V, 1]]]
        ElseIf X1(2) = U Then
          reduced R = [OP_MULT, X1(1), [OP_POW, U, [OP_ADD, V, 1]]]
        ElseIf IsPow(X1(1)) And (X1(1)(1) = U) Then
          reduced R = [OP_MULT, X1(2), [OP_POW, U, [OP_ADD, V, X1(1)(2)]]]
        ElseIf IsPow(X1(2)) And (X1(2)(1) = U) Then
          reduced R = [OP_MULT, X1(1), [OP_POW, U, [OP_ADD, V, X1(2)(2)]]]
        End If
      ElseIf IsMult(X2) And IsPow(X1) Then
        U = AddressOf X1(1)
        V = AddressOf X1(2)
        If X2(1) = U Then
          reduced R = [OP_MULT, X2(2), [OP_POW, U, [OP_ADD, V, 1]]]
        ElseIf X2(2) = U Then
          reduced R = [OP_MULT, X2(1), [OP_POW, U, [OP_ADD, V, 1]]]
        ElseIf IsPow(X2(1)) And (X2(1)(1) = U) Then
          reduced R = [OP_MULT, X2(2), [OP_POW, U, [OP_ADD, V, X2(1)(2)]]]
        ElseIf IsPow(X2(2)) And (X2(2)(1) = U) Then
          reduced R = [OP_MULT, X2(1), [OP_POW, U, [OP_ADD, V, X2(2)(2)]]]
        End If
      ElseIf IsMult(X1) Then
        If X1(1) = X2 Then
          reduced R = [OP_MULT, X1(2), [OP_POW, X2, 2]]
        ElseIf X1(2) = X2 Then
          reduced R = [OP_MULT, X1(1), [OP_POW, X2, 2 ]]
        ElseIf IsPow(X1(1)) And (X1(1)(1) = X2) Then
          reduced R = [OP_MULT, X1(2), [OP_POW, X2, [OP_ADD, X1(1)(2), 1]]]
        ElseIf IsPow(X1(2)) And (X1(2)(1) = X2) Then
          reduced R = [OP_MULT, X1(1), [OP_POW, X2, [OP_ADD, X1(2)(2), 1]]] 
        End If
      ElseIf IsMult(X2) Then
        If X2(1) = X1 Then
          reduced R = [OP_MULT, X2(2), [OP_POW, X1, 2]]
        ElseIf X2(2) = X1 Then
          reduced R = [OP_MULT, X2(1), [OP_POW, X1, 2]]
        ElseIf IsPow(X2(1)) And (X2(1)(1) = X1) Then
          reduced R = [OP_MULT, X2(2), [OP_POW, X1, [OP_ADD, X2(1)(2), 1]]]
        ElseIf IsPow(X2(2)) And (X2(2)(1) = X1) Then
          reduced R = [OP_MULT, X2(1), [OP_POW, X1, [OP_ADD, X2(2)(2), 1]]] 
        End If
      End If
    ElseIf Oper = OP_DIV Then
      If IsUnit(X2) Then
        reduced R = X1
      ElseIf IsZero(X1) Then
        reduced R = X1
      ElseIf IsPow(X2) Then
        reduced R = [OP_MULT, X1, [OP_POW, X2(1), [OP_UN, X2(2)]]]
      ElseIf IsZero(X2) Then
        println "Division by zero"
      Else
        reduced R = [OP_MULT, X1, [OP_POW, X2, -1]]
      End If
    ElseIf Oper = OP_POW Then
      If      IsUnit(X2) Then
        reduced R = X1
      ElseIf IsZero(X2) Then
        reduced R = 1
      End If
    End If
  End If
End Sub

Dim E, D
E = ["^",2,X]

println "Source expression in prefix notation:"
println E

println "Source expression in infix notation:"
println InOrder(E) 

D = Diff(E)

println "Derivative in prefix notation:"
println D 

println "Derivative in infix notation:"
println InOrder(D) 

Compress(AddressOf D)

println "Finally result in prefix notation:"
println D 

println "Finally result in infix notation:"
println InOrder(D)


