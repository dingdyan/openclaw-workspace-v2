program OperatorOverloading;
type
  Complex = record
    re, im: Double;
    class const i: Complex = (0.0, 1.0);
    // "+"
    operator + (x, y: Complex): Complex;
    begin
      result.re := x.re + y.re;
      result.im := x.im + y.im;
    end;
    operator + (x: Complex; y: Double): Complex;
    begin
      result.re := x.re + y;
      result.im := x.im;
    end;
    operator + (x: Double; y: Complex): Complex;
    begin
      result.re := x + y.re;
      result.im := y.im;
    end;
    // "-"
    operator - (x, y: Complex): Complex;
    begin
      result.re := x.re - y.re;
      result.im := x.im - y.im;
    end;
    operator - (x: Complex; y: Double): Complex;
    begin
      result.re := x.re - y;
      result.im := x.im;
    end;
    operator - (x: Double; y: Complex): Complex;
    begin
      result.re := x - y.re;
      result.im := - y.im;
    end;
    // unary "-"
    operator - (x: Complex): Complex;
    begin
      result.re := -x.re;
      result.im := -x.im;
    end;
    // "*"
    operator * (x, y: Complex): Complex;
    begin
      result.re := x.re * y.re - x.im * y.im;
      result.im := x.re * y.im + y.re * x.im;
    end;
    operator * (x: Complex; y: Double): Complex;
    begin
      result.re := x.re * y;
      result.im := x.im * y;
    end;
    operator * (x: Double; y: Complex): Complex;
    begin
      result.re := y.re * x;
      result.im := y.im * x;
    end;
    // "/"
    operator / (x, y: Complex): Complex;
    var
      d: Double;
    begin
      d := y.re * y.re + y.im * y.im;
      result.re := (x.re * y.re + x.im * y.im) / d;
      result.im := (x.im * y.re - x.re * y.im) / d;
    end;
    operator / (x: Complex; y: Double): Complex;
    begin
      result.re := x.re / y;
      result.im := x.im / y;
    end;
    operator / (x: Double; y: Complex): Complex;
    var
      d: Double;
    begin
      d := y.re * y.re + y.im * y.im;
      result.re := x * y.re / d;
      result.im := - x * y.im / d;
    end;
    // "="
    operator = (x, y: Complex): Boolean;
    begin
      result := (x.re = y.re) and (x.im = y.im);
    end;
    operator = (x: Double; y: Complex): Boolean;
    begin
      result := (x = y.re) and (0.0 = y.im);
    end;
    operator = (x: Complex; y: Double): Boolean;
    begin
      result := (x.re = y) and (x.im = 0.0);
    end;
    // "<>"
    operator <> (x, y: Complex): Boolean;
    begin
      result := (x.re <> y.re) or (x.im <> y.im);
    end;
    operator <> (x: Double; y: Complex): Boolean;
    begin
      result := (x <> y.re) or (0.0 <> y.im);
    end;
    operator <> (x: Complex; y: Double): Boolean;
    begin
      result := (x.re <> y) or (x.im <> 0.0);
    end;
  end;
var
  x, y, z: Complex;
begin
  println Complex.i.re;
  println Complex.i.im;

  x.re := 10.3;
  x.im := 100.2;
  y.re := 5.3;
  y.im := 5.5;
  
  println x = y;
  println x <> y;

  z := x + y;
  println z.re;
  println z.im;
  z := z + 5.5;
  println z.re;
  println z.im;
  z := 7 + z;
  println z.re;
  println z.im;
  z := -z;
  println z.re;
  println z.im;
end.


