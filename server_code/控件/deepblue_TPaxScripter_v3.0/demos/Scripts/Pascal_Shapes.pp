namespace Shapes
  type
    TPoint = class(TObject)
       X, Y: Integer;
       constructor Create(X, Y: Integer);
       begin
         inherited Create;
         Self.X := X;
         Self.Y := Y;
       end;
    end;

    TCircle = class(TPoint)
      R: Integer;
      constructor Create(X, Y, R);
    end;
    
  constructor TCircle.Create(X, Y, R);
  begin
    inherited Create(X, Y);
    Self.R := R;
  end;

end;

var
  Point = Shapes.TPoint.Create(3, 5);
  Circle = Shapes.TCircle.Create(3, 5, 8);
println '';
println Point, Circle;
