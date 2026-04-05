type
  TRandomPoint = record
    X: Integer = Random(100);
    Y: Integer = Random(100);

    procedure Initialize;
    begin
      writeln('new point');
    end;

  end;
  
  TRandomCircle = record(TRandomPoint)
    R: Integer = Random(100);

    procedure Initialize;
    begin
      inherited;
      writeln('new circle');
    end;

  end;
  
var
  C: TRandomCircle;
println C;

