'Symbolic logic. Theorem proving.
'Compare with Appendix A in "Chang C.L and Lee R.C. Symbolic
'Logic and Mechanical Theorem Proving", Academic Press, New York, 1973

Imports SysUtils, Classes, Contnrs

Dim ArrConst = ["$1", "$2", "$3", "$4", "$5", "$6", "$7", "$8"]
Dim AX       = ["X1", "X2", "X3", "X4", "X5", "X6", "X7", "X8"]
Dim AY       = ["Y1", "Y2", "Y3", "Y4", "Y5", "Y6", "Y7", "Y8"]

Dim Num As Integer = 0

Function IsCompound(Term As Variant) As Boolean
  return isPaxArray(Term)
End Function

Function IsVar(P As Variant) As Boolean
  Dim result
  result = isString(P)
  If Not result Then
    Return false
  Else
    Return (Asc(P) >= Asc("U")) And (Asc(P) <= Asc("Z"))
  End If
End Function

Function CopyTerm(A As Variant) As Variant
  Dim I As Integer
  Dim AI, result As Variant
  result = PaxArray(A.length)
  For I=0 To A.length - 1
    AI = AddressOf A(I)
    If IsCompound(AI) Then
      result(I) = CopyTerm(AI)
    Else
      result[I] = AI
    End If
  Next
  Return result
End Function

Function Inside(Key As Variant, Term As Variant) As Boolean
  Dim I As Integer
  If IsCompound(Term) Then
    For I=1 to Term.length - 1
      If Inside(Key, Term(I)) Then
        Return true
      End If
    Next
    Return false
  Else
    Return (Key = Term)
  End If
End Function

Function Unify(N As Integer, T1 As Variant, T2 As Variant) As Boolean
  Dim I As Integer
  Dim P1, P2 As Variant
  For I=N to T1.length - 1
    P1 = AddressOf T1(I)
    P2 = AddressOf T2(I)
    If IsCompound(P1) And IsCompound(P2) Then
      If Not Unify(0, P1, P2) Then
        Return false
      End If
    ElseIf IsVar(P1) And (Not Inside(P1, P2)) Then
      TerminalOf P1 = AddressOf TerminalOf P2
    ElseIf IsVar(P2) And (Not Inside(P2, P1)) Then
      TerminalOf P2 = AddressOf TerminalOf P1
    ElseIf P1 <> P2 Then
      Return false
    End If
  Next
  Return true
End Function

Class TClause
  Inherits TObject
  
  Dim E, Params As Variant
  Dim Number, NParam, NX, NY, ND As Integer
  Dim InProof As Boolean
  
  Sub New(A As Variant)
    Me = MyBase.Create()

    E = A
    Num = Num + 1
    Number = Num
    NX = 1000
    NY = 0
    ND = 0
    NParam = 0
    Params = PaxArray(10)
    InProof = false

    If A <> NULL then
      CreateParams(E)
    End If
  End Sub
  
  Sub Dispose()
    MyBase.Free
  End Sub

  Sub CreateParams(P As Variant)
    Dim I, J, K As Integer
    Dim PI As Variant
    For I=0 To P.length - 1
      PI = AddressOf P(I)
      If IsCompound(PI) Then
        CreateParams(PI)
      ElseIf IsVar(PI) Then
        K = -1
        For J=0 To NParam - 1
          If Params(J) = PI Then
            K = J
          End If
        Next
        If K = -1 Then
          K = NParam
          Params(K) = PI
          NParam += 1
        End If
        P(I) = AddressOf Params(K)
      End If
    Next
  End Sub
  
  Function Length As Integer
    Return E.length
  End Function

  Function Sign(I As Integer) As String
    Return E(I)(0)
  End Function

  Function Name(I As Integer) As String
    return E(I)(1)
  End Function
  
  Sub Rename(L As Variant)
    Dim I As Integer
    For I=0 To NParam - 1
      Delete Params(I)
      Params(I) = L(I)
    Next
  End Sub
  
  Sub Dump
    println Number,"(",NX,",",NY,",",ND,") E=",E
  End Sub

  Sub PutResolvent(A As TClause, B As TClause, LA As Integer, LB As Integer)
    Dim I, J As Integer
    E = PaxArray(A.E.length + B.E.length - 2)

    J = -1
    For I=0 To A.length - 1
      If I <> LA Then
        J += 1
        E(J) = CopyTerm(A.E(I))
      End If
    Next

    For I=0 To B.length - 1
      If I <> LB Then
        J += 1
        E(J) = CopyTerm(B.E(I))
      End If
    Next

    NX = A.Number
    NY = B.Number
    ND = LB

    CreateParams(E)
  End Sub

End Class

Class TClauseList
  Inherits TObject
  
  Dim fClauses As TList
  
  Sub New()
    Me = MyBase.Create()
    fClauses = New TList()
  End Sub
  
  Sub Dispose()
    fClauses.Free
    MyBase.Free
  End Sub
  
  Function Add(C As TClause) As Integer
    Return fClauses.Add(C)
  End Function
  
  Sub Clear()
    fClauses.Clear
  End Sub
  
  Function Count() As Integer
    return fClauses.Count
  End Function
  
  Sub MarkTree(I, N As Integer)
    Dim C As TClause
    If I > N Then
      C = Clauses(I - 1)
      C.InProof = true
      MarkTree(C.NX, N)
      MarkTree(C.NY, N)
    End If
  End Sub
  
  Sub Output(N As Integer)
    Dim I, NX, NY, HC As Integer, C As TClause
    HC = Count - 1
    Do While (HC > 0)
      C = Clauses(HC)
      If C.E.Length = 0 Then
        Exit Do
      End If
      HC = HC - 1
    Loop

    If HC = 0 Then
      println "Not proved"
      Exit Sub
    End If

    NX = Clauses(HC).NX
    NY = Clauses(HC).NY
    MarkTree(NX, N)
    MarkTree(NY, N)
    println "Proof: "
    For I = N + 1 To HC
      C = Clauses(I)
      If C.InProof Then
        C.Dump
      End If
    Next
    println "Contradiction: ", NX, " ", NY
    Clauses(HC).Dump
  End Sub
  
  Sub AddClauses(L As TClauseList)
    Dim I As Integer
    For I=0 To L.Count - 1
      fClauses.Add(L(I))
    Next
  End Sub

  Sub Dump()
    Dim I As Integer
    For I = 0 To Count - 1
      Clauses[I].Dump()
    Next
  End Sub

  Default Property Clauses(I As Integer) As Integer
    Get
      return fClauses(I)
    End Get
    Set
      fClauses(I) = Value
    End Set
  End Property
End Class

Function Contradict(A As TClauseList, U As TClauseList, V As TClauseList) As Boolean
  Dim I, J As Integer
  Dim UI, VJ, R As TClause
  Dim Name As String
  
  For I = 0 To U.Count - 1
    UI = U(I)
    Name = UI.Name(0)
    For J = 0 To V.Count - 1
      VJ = V(J)
      If Name = VJ.Name(0) Then
        UI.Rename(AX)
        VJ.Rename(AY)
        If Unify(2, UI.E(0), VJ.E(0)) Then
          R = New TClause(NULL)
          R.PutResolvent(UI, VJ, 0, 0)
          println "Resolvent:"
          R.Dump()
          A.Add(R)
          
          Return True
        End If
      End If
    Next
  Next
  Return false
End Function

Function STest(S As TClauseList, U As TClause) As Boolean
  Dim Name As String
  Dim I As Integer
  Dim SI As TClause
  
  Name = U.Name(0)
  For I = 0 to S.Count - 1
    SI = S(I)
    If Name = SI.Name(0) Then
      SI.Rename(ArrConst)
      U.Rename(AX)
      If Unify(2, SI.E[0], U.E[0]) Then
        Return true
      End If
    End If
  Next
  Return false
End Function

Function GUnit(A As TClauseList, S1 As TClauseList, S2 As TClauseList, W As TClauseList, C As TClause) As Boolean
  Dim P, S, POS, NEG As TClauseList
  Dim I, J As Integer
  Dim U, R As TClause
  Dim Sign, Name As String
  Dim Stack As TStack
  Dim result As Boolean
  
  POS = new TClauseList()
  NEG = new TClauseList()
  Stack = new TStack()

  Try
    Stack.Push(C)

    Do
      C = Stack.Pop

      For I = 0 to W.Count - 1
        U = W[I]
        If U.Number < C.NX Then
          Sign = U.Sign(0)
          Name = U.Name(0)
          For J=0 to C.length - 1
            If (Sign <> C.Sign(J)) And (Name = C.Name(J)) Then
              U.Rename(AX)
              C.Rename(AY)

              If Unify(1, U.E(0), C.E(J)) Then
                R = new TClause(NULL)
                R.PutResolvent(U, C, 0, J)

                println "Resolvent:"
                R.Dump()
                
                A.Add(R)

                If R.length = 1 Then
                  If R.Sign(0) = "+" Then
                    S = S1
                    P = POS
                  Else
                    S = S2
                    P = NEG
                  End If
                  If (Not STest(S, R)) And (Not STest(P, R)) Then
                    P.Add(R)
                  End If
                Else
                  Stack.Push(R)
                End If
              End If
            End If
          Next
        End If
      Next
    Loop Until Stack.Count = 0

    result = Contradict(A, S1, NEG)
    If Not result Then
      result = Contradict(A, S2, POS)
      If Not result Then
        S1.AddClauses(POS)
        S2.AddClauses(NEG)
      End If
    End If
  Finally
    POS.Dispose()
    NEG.Dispose()
    Stack.Free()
    
    Return result
  End Try
End Function

Function TPU(A As TClauseList, SupportSet As TList, TryNumber As Integer) As Boolean
  Dim S, S1, S2, S3 As TClauseList
  Dim I, J, K, L, N AS Integer
  Dim W As TList
  Dim C As TClause
  
  S1 = New TClauseList()
  S2 = New TClauseList()
  S3 = New TClauseList()
  
  W = New TList()

  Try
    For I=0 to A.Count - 1
      C = A(I)
      If C.length = 1 Then
        If C.Sign(0) = "+" Then
          S1.Add(C)
        Else
          S2.Add(C)
        End If
      Else
        S3.Add(C)
        If SupportSet(I) <> NULL Then
          S = New TClauseList()
          For J=0 To SupportSet(I).length - 1
            C = SupportSet(I)(J)
            S.Add(C)
          Next
          W.Add(S)
        End If
      End If
    Next

    If Contradict(A, S1, S2) Then
      Return true
    End If

    K = 0

    For I=0 to TryNumber - 1
      N = A.Count()
      If GUnit(A, S1, S2, W[K], S3[K]) Then
        Return true
      End If

      If A.Count > N Then
        For J=0 To S3.Count - 1
          If J = K Then
            W(J).Clear
          End If

          For L=N To A.Count - 1
            If A(L).length = 1 Then
              W(J).Add(A(L))
            End If
          Next
        Next
      End If

      K = K + 1
      If K = S3.Count Then
        K = 0
      End If
    Next
  Finally
    S1.Dispose()
    S2.Dispose()
    S3.Dispose()
  End Try
  Return false
End Function

Dim A = "A"
Dim D = "D"
Dim F = "F"
Dim H = "H"
Dim L = "L"
Dim P = "P"
Dim X = "X"
Dim Y = "Y"

Dim I, N As Integer
Dim Clauses As TClauseList
Dim SupportSet As TList

Sub AddClause(E As Variant)
  Clauses.Add(New TClause(E))
End Sub

Num = 0
Clauses = New TClauseList()
SupportSet = New TList()

AddClause([["+",L,X,[F,X]]                      ])
AddClause([["-",L,X,X]                          ])
AddClause([["-",L,X,Y],["-",L,Y,X]              ])
AddClause([["-",D,X,[F,Y]],["+",L,Y,X]          ])
AddClause([["+",P,X],["+",D,[H,X],X]            ])
AddClause([["+",P,X],["+",P,[H,X]]              ])
AddClause([["+",P,X],["+",L,[H,X],X]            ])
AddClause([["-",P,X],["-",L,A,X],["+",L,[F,A],X]])

For I=0 To Clauses.Count - 1
  If I >= 2 Then
    SupportSet.Add([Clauses(0), Clauses(1)])
  Else
    SupportSet.Add(NULL)
  End If
Next

println "Source clauses:"
Clauses.Dump()

println "-------------------------------"
println "Theorem proving"
println "Unit binary resolution"
println "-------------------------------"

println "Theorem :"
println "The set of prime numbers is infinite"

N = Clauses.Count()
TPU(Clauses, SupportSet, 20)

Clauses.Output(N)

For I=0 To Clauses.Count - 1
  Clauses(I).Free
Next
Clauses.Dispose
SupportSet.Free


