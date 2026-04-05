// Symbolic computing. Differentiation.

// Gramma:
// Expression = Term { ( "+"|"-") Term  }
// Term =  Multiplier { "*"|"/" ) Multiplier }
// Multiplier = Factor { "^"  Factor }
// Factor = Number | "X" | "LN"  "(" Expression ")" | "(" Expression ")" "-" Factor
// Number = Digit { Digit }
// Digit = "0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"

program SymbolicDifferentiation;
const
  X       = 'X';
  OP_ADD  = '+';
  OP_MULT = '*';
  OP_SUB  = '-';
  OP_DIV  = '/';
  OP_UN   = '~';
  OP_LOG  = 'ln';
  OP_POW  = '^';

function IsVar(const Term: Variant): boolean;
begin
  result := isString(Term);
  if result then
    result := Term ='X';
end;

function IsConstant(const Term: Variant): boolean;
begin
  result := isNumber(Term);
end;

function IsZero(const Term: Variant): boolean;
begin
  result:= IsConstant(Term);
  if result then
    result := Term = 0;
end;

function IsUnit(const Term: Variant): boolean;
begin
  result := IsConstant(Term);
  if result then
    result := Term = 1;
end;

function IsCompound(const Term: Variant): boolean;
begin
  result := isPaxArray(Term);
end;

function IsPow(const Term: Variant): boolean;
begin
  result := IsCompound(Term);
  if result then
    result := Term[0] = OP_POW;
end;

function IsMult(const Term: Variant): boolean;
begin
  result := IsCompound(Term);
  if result then
    result := Term[0] = OP_MULT;
end;

function IsAdd(const Term: Variant): boolean;
begin
  result := IsCompound(Term);
  if result then
    result := Term[0] = OP_ADD;
end;

function IsSub(const Term: Variant): boolean;
begin
  result := IsCompound(Term);
  if result then
    result := Term[0] = OP_SUB;
end;

function IsNeg(const Term: Variant): boolean;
begin
  result := IsCompound(Term);
  if result then
    result := Term[0] = OP_UN;
end;

function Diff(const A: Variant): Variant;
var
  X1, X2, R1, R2, R3: Variant;
  Oper: String;
begin
  if IsCompound(A) then
  begin
    Oper := A[0];
    X1 := @A[1];
    if A.length >= 3 then
      X2 := @A[2];

    if Oper = OP_ADD then
      result := [Oper, Diff(X1), Diff(X2)]
    else if Oper = OP_SUB then
      result := [Oper, Diff(X1), Diff(X2)]
    else if Oper = OP_UN then
      result := [Oper, Diff(X1)]
    else if Oper = OP_MULT then
      result := [OP_ADD, [OP_MULT, Diff(X1), X2], [OP_MULT, X1, Diff(X2)]]
    else if Oper = OP_DIV then
    begin
      R1 := [OP_DIV, Diff(X1), X2];
      R2 := [OP_MULT, X1, Diff(X2)];
      R3 := [OP_MULT, X2, X2];
      result := [OP_SUB, R1, [OP_DIV, R2, R3]];
    end
    else if Oper = OP_LOG then
      result := [OP_DIV, Diff(X1), X1]
    else if Oper = OP_POW then
    begin
      R1 := [OP_MULT, Diff(X1), [OP_MULT, X2, [OP_POW, X1, [OP_SUB, X2, 1]]]];
      R2 := [OP_MULT, Diff(X2), [OP_MULT, [OP_LOG, X1], [OP_POW, X1, X2 ]]];
      result := [OP_ADD, R1, R2];
    end
    else
      println 'Syntax error !';
  end
  else if IsVar(A) then
    result := 1
  else
    result := 0;
end;

function InOrder(const A: Variant): String;
var
  LL, RR, Oper: String;
begin
  if IsCompound(A) then
  begin
    if A.length = 2 then
    begin
      Oper := A[0];
      if Oper = OP_UN then
        Oper := OP_SUB;

      RR := InOrder(A[1]);

      if (Oper = OP_LOG) and (Copy(RR, 1, 1) <> '(') then
        result :=  'ln' + '(' + RR + ')'
      else
        result := '(' + Oper + RR + ')';
    end
    else if A.length = 3 then
    begin
      Oper := A[0];
      LL := InOrder(A[1]);
      RR := InOrder(A[2]);

      if (Copy(RR, 1, 1) = OP_SUB) and (Oper = OP_ADD) then
        Oper := '';

      result := '(' + LL + oper + RR + ')';
    end;
  end
  else
    result := toString(A);
end;

procedure Compress(R: Variant);
var
  K: Integer;
  Oper: String;
  X1, X2, U, V: Variant;
  Ground: Boolean;
begin
  if IsCompound(R) then
    K := R.length
  else
    K := 0;
    
  if K = 2 then
  begin
    Oper := R[0];
    if Oper = OP_UN then
    begin
      X1 := @ R[1];
      if IsCompound(X1) then
        Compress(X1);
      if IsConstant(X1) then
        X1 := - X1;
    end;
  end
  else if K = 3 then
  begin
    Oper := R[0];
    X1 := @ R[1];
    X2 := @ R[2];

    if IsCompound(X1) then
      Compress(X1);
    if IsCompound(X2) then
      Compress(X2);

    Ground := IsConstant(X1) and IsConstant(X2);

    if Oper = OP_ADD then
    begin
      if Ground then
        reduced R := X1 + X2
      else if IsZero(X1) then
        reduced R := X2
      else if IsZero(X2) then
        reduced R := X1
      else if X1 = X2 then
        reduced R := [OP_MULT, 2, X1]
      else if IsNeg(X1) and (not IsNeg(X2)) then
        reduced R := [OP_SUB, X2, X1[1]]
      else if IsNeg(X2) and (not IsNeg(X1)) then
        reduced R := [OP_SUB, X1, X2[1]]
      else if IsMult(X1) and IsMult(X2) then
      begin
        if X1[1] = X2[1] then
          reduced R := [OP_MULT, X1[1], [OP_ADD, X1[2], X2[2]]]
        else if X1[2] = X2[2] then
          reduced R := [OP_MULT, X1[2], [OP_ADD, X1[1], X2[1]]];
      end
      else if IsMult(X1) then
      begin
        if  X1[1] = X2 then
           reduced R := [OP_MULT, X2, [OP_ADD, X1[2], 1]]
        else if X1[2] = X2 then
           reduced R := [OP_MULT, X2, [OP_ADD, X1[1], 1]];
      end
      else if IsMult(X2) then
      begin
        if  X2[1] = X1 then
           reduced R := [OP_MULT, X1, [OP_ADD, X2[2], 1]]
        else if X2[2] = X1 then
           reduced R := [OP_MULT, X1, [OP_ADD, X2[1], 1]];
      end
      else if IsAdd(X1) and IsConstant(X2) then
      begin
        if IsConstant(X1[1]) then
           reduced R := [OP_ADD, X1[2], X1[1] + X2]
        else if IsConstant(X1[2]) then
           reduced R := [OP_ADD, X1[1], X1[2] + X2];
      end
      else if IsAdd(X2) and IsConstant(X1) then
      begin
        if IsConstant(X2[1]) then
           reduced R := [OP_ADD, X2[2], X2[1] + X1]
        else if IsConstant(X2[2]) then
           reduced R := [OP_ADD, X2[1], X2[2] + X1];
      end
      else if IsSub(X1) and IsConstant(X2) then
      begin
        if IsConstant(X1[1]) then
           reduced R := [OP_SUB, X1[1] + X2, X1[2]]
        else if IsConstant(X1[2]) then
           reduced R := [OP_ADD, X2 - X1[2], X1[1]];
      end
      else if IsSub(X2) and IsConstant(X1) then
      begin
        if IsConstant(X2[1]) then
           reduced R := [OP_SUB, X1 + X2[1], X2[2]]
        else if IsConstant(X2[2]) then
           reduced R := [OP_ADD, X1 - X2[2], X2[1]];
      end;
    end
    else if Oper = OP_SUB then
    begin
      if Ground  then
        reduced R := X1 - X2
      else if IsZero(X1) then
        reduced R := [OP_UN, X2]
      else if IsZero(X2) then
        reduced R := X1
      else if X1 = X2 then
        reduced R := 0
      else if IsNeg(X1) and (not IsNeg(X2)) then
        reduced R := [OP_ADD, X1[1], X2]
      else if IsNeg(X2) and (not IsNeg(X1)) then
        reduced R := [OP_ADD, X1, X2[1]]
      else if IsMult(X1) and IsMult(X2) then
      begin
        if      X1[1] = X2[1] then
          reduced R := [OP_MULT, X1[1], [OP_SUB, X1[2], X2[2]]]
        else if X1[2] = X2[2] then
          reduced R := [OP_MULT, X1[2], [OP_SUB, X1[1], X2[1]]];
      end
      else if IsMult(X1) then
      begin
        if      X1[1] = X2 then
           reduced R := [OP_MULT, X2, [OP_SUB, X1[2], 1]]
        else if X1[2] = X2 then
           reduced R := [OP_MULT, X2, [OP_SUB, X1[1], 1]];
      end
      else if IsMult(X2) then
      begin
        if      X2[1] = X1 then
           reduced R := [OP_MULT, X1, [OP_SUB, X2[2], 1]]
        else if X2[2] = X1 then
           reduced R := [OP_MULT, X1, [OP_SUB, X2[1], 1]];
      end
      else if IsAdd(X1) and IsConstant(X2) then
      begin
        if      IsConstant(X1[1]) then
           reduced R := [OP_ADD, X1[2], X1[1] - X2]
        else if IsConstant(X1[2]) then
           reduced R := [OP_ADD, X1[1], X1[2] - X2];
      end
      else if IsAdd(X2) and IsConstant(X1) then
      begin
        if      IsConstant(X2[1]) then
           reduced R := [OP_ADD, X2[2], X1 - X2[1]]
        else if IsConstant( X2[ 3 ] ) then
           reduced R := [OP_ADD, X2[1], X1 - X2[2]];
      end
      else if IsSub(X1) and IsConstant(X2) then
      begin
        if      IsConstant(X1[1]) then
           reduced R := [OP_SUB, X1[1] - X2, X1[2]]
        else if IsConstant(X1[2]) then
           reduced R := [OP_SUB, X1[1], X2 + X1[2]];
      end
      else if IsSub(X2) and IsConstant(X1) then
      begin
        if      IsConstant(X2[1]) then
           reduced R := [OP_ADD, X1 - X2[1], X2[2]]
        else if IsConstant(X2[2]) then
           reduced R := [OP_SUB, X1 - X2[2], X2[1]];
      end;
    end
    else if Oper = OP_MULT then
    begin
      if Ground  then
        reduced R := X1 * X2
      else if IsZero(X1) then
        reduced R := 0
      else if IsZero(X2) then
        reduced R := 0
      else if IsNeg(X1) then
        reduced R := [OP_MULT, -1, [OP_MULT, X1[1], X2]]
      else if IsNeg(X2) then
        reduced R := [OP_MULT, -1, [OP_MULT, X2[1], X1]]
      else if IsUnit(X1) then
        reduced R := X2
      else if IsUnit(X2) then
        reduced R := X1
      else if X1 = X2 then
        reduced R := [OP_POW, X1, 2]
      else if IsPow(X1) and IsPow(X2) and (X1[1] = X2[1]) then
        reduced R := [OP_POW, X1[1], [OP_ADD, X1[2], X2[2]]]
      else if IsPow(X1) and (X1[1] = X2) then
        reduced R := [OP_POW, X1[1], [OP_ADD, X1[2], 1]]
      else if IsPow(X2) and (X2[1] = X1) then
        reduced R := [OP_POW, X2[1], [OP_ADD, X2[2], 1]]
      else if IsMult(X1) and IsPow(X2) then
      begin
        U := @X2[1];                          // ( A*U ) * ( U^V )
        V := @X2[2];
        if X1[1] = U then
          reduced R := [OP_MULT, X1[2], [OP_POW, U, [OP_ADD, V, 1]]]
        else if X1[2] = U then
          reduced R := [OP_MULT, X1[1], [OP_POW, U, [OP_ADD, V, 1]]]
        else if IsPow(X1[1]) and (X1[1][1] = U) then
          // ( U ^ C )*A  *  ( U ^ V ) = A * ( U ^ ( C + V ) )
          reduced R := [OP_MULT, X1[2], [OP_POW, U, [OP_ADD, V, X1[1][2]]]]
        else if IsPow(X1[2]) and (X1[2][1] = U) then
          // A*( U ^ C )  *  ( U ^ V ) = A * ( U ^ ( C + V ) )
         reduced R := [OP_MULT, X1[1], [OP_POW, U, [OP_ADD, V, X1[2][2]]]];
      end
      else if IsMult(X2) and IsPow(X1) then
      begin
        U := @ X1[1];                           // symmetry
        V := @ X1[2];
        if X2[1] = U then
          reduced R := [OP_MULT, X2[2], [OP_POW, U, [OP_ADD, V, 1]]]
        else if X2[2] = U then
          reduced R := [OP_MULT, X2[1], [OP_POW, U, [OP_ADD, V, 1]]]
        else if IsPow(X2[1]) and (X2[1][1] = U) then
          // ( U ^ C )*A  *  ( U ^ V ) = A * ( U ^ ( C + V ) )
          reduced R := [OP_MULT, X2[2], [OP_POW, U, [OP_ADD, V, X2[1][2]]]]
        else if IsPow(X2[2]) and (X2[2][1] = U) then
          // A*( U ^ C )  *  ( U ^ V ) = A * ( U ^ ( C + V ) )
          reduced R := [OP_MULT, X2[1], [OP_POW, U, [OP_ADD, V, X2[2][2]]]];
      end
      else if IsMult(X1) then
      begin
        if X1[1] = X2 then
          reduced R := [OP_MULT, X1[2], [OP_POW, X2, 2]]
        else if X1[2] = X2 then
          reduced R := [OP_MULT, X1[1], [OP_POW, X2, 2 ]]
        else if IsPow(X1[1]) and (X1[1][1] = X2) then
          reduced R := [OP_MULT, X1[2], [OP_POW, X2, [OP_ADD, X1[1][2], 1]]]
        else if IsPow(X1[2]) and (X1[2][1] = X2) then
          reduced R := [OP_MULT, X1[1], [OP_POW, X2, [OP_ADD, X1[2][2], 1]]];
      end
      else if IsMult(X2) then
      begin
        if X2[1] = X1 then
          reduced R := [OP_MULT, X2[2], [OP_POW, X1, 2]]
        else if X2[2] = X1 then
          reduced R := [OP_MULT, X2[1], [OP_POW, X1, 2]]
        else if IsPow(X2[1]) and (X2[1][1] = X1) then
          reduced R := [OP_MULT, X2[2], [OP_POW, X1, [OP_ADD, X2[1][2], 1]]]
        else if IsPow(X2[2]) and (X2[2][1] = X1) then
          reduced R := [OP_MULT, X2[1], [OP_POW, X1, [OP_ADD, X2[2][2], 1]]];
      end;
    end
    else if Oper = OP_DIV then
    begin
      if IsUnit(X2) then
        reduced R := X1
      else if IsZero(X1) then
        reduced R := X1
      else if IsPow(X2) then
        reduced R := [OP_MULT, X1, [OP_POW, X2[1], [OP_UN, X2[2]]]]
      else if IsZero(X2) then
        println 'Division by zero'
      else
        reduced R := [OP_MULT, X1, [OP_POW, X2, -1]];
    end
    else if Oper = OP_POW then
    begin
      if      IsUnit(X2) then
        reduced R := X1
      else if IsZero(X2) then
        reduced R := 1;
    end;
  end;
end;

var
  E, D: Variant;
begin
  E := ['^',2,X];

  writeln('Source expression in prefix notation:');
  writeln(E);

  writeln('Source expression in infix notation:');
  writeln(InOrder(E));

  D := Diff(E);

  writeln('Derivative in prefix notation:');
  writeln(D);

  writeln('Derivative in infix notation:');
  writeln(InOrder(D));

  Compress(@ D);

  writeln('Final result in prefix notation:');
  writeln(D);

  writeln('Final result in infix notation:');
  writeln(InOrder(D));
end.


