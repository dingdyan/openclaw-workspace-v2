// Symbolic logic. Theorem proving.
// Compare with Appendix A in "Chang C.L and Lee R.C. Symbolic
// Logic and Mechanical Theorem Proving", Academic Press, New York, 1973

program TheoremProving;
uses
  SysUtils, Classes, Contnrs;

const
  ArrConst = ['$1', '$2', '$3', '$4', '$5', '$6', '$7', '$8'];
  AX       = ['X1', 'X2', 'X3', 'X4', 'X5', 'X6', 'X7', 'X8'];
  AY       = ['Y1', 'Y2', 'Y3', 'Y4', 'Y5', 'Y6', 'Y7', 'Y8'];
type
  TClause = class(TObject)
  private
    E, Params: Variant;
    Number, NParam, NX, NY, ND: Integer;
    InProof: Boolean;
    procedure CreateParams(P: Variant);
  public
    constructor Create(A: Variant);
    procedure PutResolvent(const A, B: TClause; LA, LB: Integer);
    procedure Rename(L: Variant);
    function Length: Integer;
    function Sign(I: Integer): String;
    function Name(I: Integer): String;
    procedure Dump;
  end;

  TClauseList = class(TObject)
  private
    fClauses: TList;
    function GetClause(I: Integer): TClause;
    procedure SetClause(I: Integer; Value: TClause);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(C: TClause): Integer;
    procedure Clear;
    procedure AddClauses(L: TClauseList);
    function Count: Integer;
    procedure MarkTree(I, N: Integer);
    procedure Output(N: Integer);
    procedure Dump;
    property Clauses[I: Integer]: TClause read GetClause write SetClause; default;
  end;
  
var
  Num: Integer; // clause counter

function IsCompound(const Term: Variant): boolean;
begin
  result := isPaxArray(Term);
end;

function IsVar(const P: Variant): boolean;
begin
  result := isString(P);
  if not result then
    Exit;
  result := (Ord(P) >= Ord('U')) and (Ord(P) <= Ord('Z'));
end;

function CopyTerm(A: Variant): Variant;
var
  I: Integer;
  AI: Variant;
begin
  result := PaxArray(A.length);
  for I:=0 to A.length - 1 do
  begin
    AI := @ A[I];
    if IsCompound(AI) then
      result[I] := CopyTerm(AI)
    else
      result[I] := AI;
  end;
end;

function Inside(Key, Term: Variant): boolean;
var
  I: Integer;
begin
  if IsCompound(Term) then
    for I:=1 to Term.length - 1 do
    begin
      result := Inside(Key, Term[I]);
      if result then
        Exit;
    end
  else
    result := Key = Term;
end;

function Unify(N: Integer; T1, T2: Variant): boolean;
var
  I: Integer;
  P1, P2: Variant;
begin
  result := true;
  for I:=N to T1.length - 1 do
  begin
    P1 := @ T1[I];
    P2 := @ T2[I];
    if IsCompound(P1) and IsCompound(P2) then
      result := Unify(0, P1, P2)
    else if IsVar(P1) and (not Inside(P1, P2)) then
      P1^ := @ P2^
    else if IsVar(P2) and (not Inside(P2, P1)) then
      P2^ := @ P1^
    else
      result := P1 = P2;
    if not result then
      Exit;
  end;
end;

constructor TClause.Create(A: Variant);
begin
  inherited Create;
  
  E := A;
  Num := Num + 1;
  Number := Num;
  NX := 1000;
  NY := 0;
  ND := 0;
  NParam := 0;
  Params := PaxArray(10);
  InProof := false;
  
  if A <> null then
    CreateParams(E);
end;

function TClause.Length: Integer;
begin
  result := E.length;
end;

function TClause.Sign(I: Integer): String;
begin
  result := E[I][0];
end;

function TClause.Name(I: Integer): String;
begin
  result := E[I][1];
end;

procedure TClause.CreateParams(P: Variant);
var
  I, J, K: Integer;
  PI: Variant;
begin
  for I:=0 to P.length - 1 do
  begin
    PI := @ P[I];
    if IsCompound(PI) then
      CreateParams(PI)
    else if IsVar(PI) then
    begin
      K := -1;
      for J:=0 to NParam - 1 do
        if Params[J] = PI then
          K := J;
      if K = -1 then
      begin
        K := NParam;
        Params[K] := PI;
        Inc(NParam);
      end;
      P[I] := @ Params[K];
    end;
  end;
end;

procedure TClause.Rename(L: Variant);
var
  I: Integer;
begin
  for I:=0 to NParam - 1 do
  begin
    delete Params[I];
    Params[I] := L[I];
  end;
end;

procedure TClause.Dump;
begin
  writeln(Number,'(',NX,',',NY,',',ND,') E=',E);
end;

procedure TClause.PutResolvent(A, B: TClause; LA, LB: Integer);
var
  I, J: Integer;
begin
  E := PaxArray(A.E.length + B.E.length - 2);
  
  J := -1;
  for I:=0 to A.length - 1 do
  if I <> LA then
  begin
    Inc(J);
    E[J] := CopyTerm(A.E[I]);
  end;

  for I:=0 to B.length - 1 do
  if I <> LB then
  begin
    Inc(J);
    E[J] := CopyTerm(B.E[I]);
  end;

  NX := A.Number;
  NY := B.Number;
  ND := LB;
  
  CreateParams(E);
end;

constructor TClauseList.Create;
begin
  inherited;
  fClauses := TList.Create;
end;

destructor TClauseList.Destroy;
begin
  fClauses.Free;
  inherited;
end;

function TClauseList.GetClause(I: Integer): TClause;
begin
  result := fClauses[I];
end;

procedure TClauseList.SetClause(I: Integer; Value: TClause);
begin
  fClauses[I] := Value;
end;

function TClauseList.Add(C: TClause): Integer;
begin
  result := fClauses.Add(C);
end;

procedure TClauseList.Clear;
begin
  fClauses.Clear;
end;

function TClauseList.Count: Integer;
begin
  result := fClauses.Count;
end;

procedure TClauseList.MarkTree(I, N: Integer);
var
  C: TClause;
begin
  if I > N then
  begin
    C := Clauses[I - 1];
    C.InProof := true;
    MarkTree(C.NX, N);
    MarkTree(C.NY, N);
  end;
end;

procedure TClauseList.Output(N: Integer);
var
  I, NX, NY, HC: Integer;
  C: TClause;
begin
  HC := Count - 1;
  while HC > 0 do
  begin
    C := Clauses[HC];
    if C.E.Length = 0 then
      Break;
    Dec(HC);
  end;

  if HC = 0 then
  begin
    writeln('Not proved');
    Exit;
  end;

  NX := Clauses[HC].NX;
  NY := Clauses[HC].NY;
  MarkTree(NX, N);
  MarkTree(NY, N);
  writeln('Proof: ');
  for I := N + 1 to HC do
  begin
    C := Clauses[I];
    if C.InProof then
      C.Dump;
  end;
  writeln('Contradiction: ', NX, ' ', NY);
  Clauses[HC].Dump;
end;

procedure TClauseList.Dump;
var
  I: Integer;
begin
  for I:=0 to Count - 1 do
    Clauses[I].Dump();
end;

procedure TClauseList.AddClauses(L: TClauseList);
var
  I: Integer;
begin
  for I:=0 to L.Count - 1 do
    fClauses.Add(L[I]);
end;

function Contradict(A, U, V: TClauseList): boolean;
var
  I, J: Integer;
  UI, VJ, R: TClause;
  Name: String;
begin
  result := false;
  for I := 0 to U.Count - 1 do
  begin
    UI := U[I];
    Name := UI.Name(0);
    for J := 0 to V.Count - 1 do
    begin
      VJ := V[J];
      if Name = VJ.Name(0) then
      begin
        UI.Rename(AX);
        VJ.Rename(AY);
        result := Unify(2, UI.E[0], VJ.E[0]);
        if result then
        begin
          R := TClause.Create(null);
          R.PutResolvent(UI, VJ, 0, 0);
          writeln('Resolvent:');
          R.Rename(AX);
          R.Dump();
          
          A.Add(R);

          Exit;
        end;
      end;
    end;
  end;
end;

function STest(S: TClauseList; U: TClause): boolean;
var
  Name: String;
  I: Integer;
  SI: TClause;
begin
  result := false;
  Name := U.Name(0);
  for I := 0 to S.Count - 1 do
  begin
    SI := S[I];
    if Name = SI.Name(0) then
    begin
      SI.Rename(ArrConst);
      U.Rename(AX);
      result := Unify(2, SI.E[0], U.E[0]);
      if result then
        Exit;
    end;
  end;
end;

function GUnit(A, S1, S2, W: TClauseList; C: TClause): boolean;
var
  P, S, POS, NEG: TList;
  I, J: Integer;
  U, R: TClause;
  Sign, Name: String;
  Stack: TStack;
begin
  POS := TClauseList.Create;
  NEG := TClauseList.Create;
  Stack := TStack.Create;

  try
    Stack.Push(C);
    
    repeat
      C := Stack.Pop;
      
      for I := 0 to W.Count - 1 do
      begin
        U := W[I];
        if U.Number < C.NX then
        begin
          Sign := U.Sign(0);
          Name := U.Name(0);
          for J:=0 to C.length - 1 do
            if (Sign <> C.Sign(J)) and (Name = C.Name(J)) then
            begin
              U.Rename(AX);
              C.Rename(AY);

              if Unify(1, U.E[0], C.E[J]) then
              begin
                R := TClause.Create(null);
                R.PutResolvent(U, C, 0, J);

                writeln('Resolvent:');
                R.Rename(AX);
                R.Dump();
                
                A.Add(R);

                if R.length = 1 then
                begin
                  if R.Sign(0) = '+' then
                  begin
                    S := S1;
                    P := POS;
                  end
                  else
                  begin
                    S := S2;
                    P := NEG;
                  end;
                  if (not STest(S, R)) and (not STest(P, R)) then
                    P.Add(R);
                end
                else
                  Stack.Push(R);
              end;
            end;
        end;
      end;
    until Stack.Count = 0;

    result := Contradict(A, S1, NEG);
    if not result then
    begin
      result := Contradict(A, S2, POS);
      if not result then
      begin
        S1.AddClauses(POS);
        S2.AddClauses(NEG);
      end;
    end;
  finally
    POS.Free;
    NEG.Free;
    Stack.Free;
  end;
end;

function TPU(A: TClauseList; SupportSet: TList; TryNumber: Integer): boolean;
var
  S, S1, S2, S3: TClauseList;
  I, J, K, L, N: Integer;
  W: TList;
  C: TClause;
begin
  S1 := TClauseList.Create;
  S2 := TClauseList.Create;
  S3 := TClauseList.Create;
  W := TList.Create;

  try
    for I:=0 to A.Count - 1 do
    begin
      C := A[I];
      if C.length = 1 then
      begin
        if C.Sign(0) = '+' then
          S1.Add(C)
        else
          S2.Add(C);
      end
      else
      begin
        S3.Add(C);
        if SupportSet[I] <> nil then
        begin
          S := TClauseList.Create;
          for J:=0 to SupportSet[I].length - 1  do
          begin
            C := SupportSet[I][J];
            S.Add(C);
          end;
          W.Add(S);
        end;
      end;
    end;

    result := Contradict(A, S1, S2);

    if result then
      Exit;

    K := 0;

    for I:=0 to TryNumber - 1 do
    begin
      N := A.Count;
      result := GUnit(A, S1, S2, W[K], S3[K]);

      if result then
        Exit;

      if A.Count > N then
        for J:=0 to S3.Count - 1 do
        begin
          if J = K then
            W[J].Clear;

          for L:=N to A.Count - 1 do
            if A[L].length = 1 then
              W[J].Add(A[L]);
        end;

      Inc(K);
      if K = S3.Count then
        K := 0;
    end;
  finally
    S1.Free;
    S2.Free;
    S3.Free;
    W.Free;
  end;
end;

const
  A = 'A';
  D = 'D';
  F = 'F';
  H = 'H';
  L = 'L';
  P = 'P';
  X = 'X';
  Y = 'Y';
var
  I, N: Integer;
  Clauses: TClauseList;
  SupportSet: TList;

procedure AddClause(E);
begin
  Clauses.Add(TClause.Create(E));
end;

begin
  Num := 0;
  Clauses := TClauseList.Create;
  SupportSet := TList.Create;

  AddClause([['+',L,X,[F,X]]                      ]);
  AddClause([['-',L,X,X]                          ]);
  AddClause([['-',L,X,Y],['-',L,Y,X]              ]);
  AddClause([['-',D,X,[F,Y]],['+',L,Y,X]          ]);
  AddClause([['+',P,X],['+',D,[H,X],X]            ]);
  AddClause([['+',P,X],['+',P,[H,X]]              ]);
  AddClause([['+',P,X],['+',L,[H,X],X]            ]);
  AddClause([['-',P,X],['-',L,A,X],['+',L,[F,A],X]]);

  for I:=0 to Clauses.Count - 1 do
  begin
    if I >= 2 then
      SupportSet.Add([Clauses[0], Clauses[1]])
    else
      SupportSet.Add(nil);
  end;

  writeln('Source clauses:');
  Clauses.Dump;

  writeln('-------------------------------');
  writeln('Theorem proving');
  writeln('Unit binary resolution');
  writeln('-------------------------------');

  writeln('Theorem :');
  writeln('The set of prime numbers is infinite');

  N := Clauses.Count;
  TPU(Clauses, SupportSet, 20);

  Clauses.Output(N);
  
  for I:=0 to Clauses.Count - 1 do
    Clauses[I].Free;
  Clauses.Free;
  SupportSet.Free;
end.

