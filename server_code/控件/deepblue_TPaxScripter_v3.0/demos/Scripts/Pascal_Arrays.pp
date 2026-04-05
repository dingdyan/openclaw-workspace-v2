program Demo;
type
  TMyClass = class(TObject)
     fZ = [10, 20, 30, 40, 50];
     function GetZ(I: Integer): Integer;
     begin
       result := fZ[I];
     end;
     procedure SetZ(I, Value: Integer);
     begin
       fZ[I] := Value;
     end;
     property Z[I: Integer]: Integer read GetZ write SetZ; default;
  end;
  
  TMyArray = array[1..Random(10) + 2] of Integer;

var
  X: TMyClass;
  A: TMyArray;
begin
  writeln(A);
  X := TMyClass.Create;
  X[1] := 90;
  writeln(X);
  println A;
end.


