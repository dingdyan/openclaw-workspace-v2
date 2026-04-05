program Demo;
type
  TOuter = class(TObject)
    x: Integer = 10;
    class var y: String = 'abc';
  public
    class TInner(TObject)
      x: Integer = 20;
      procedure PrintData;
      begin
        print x, y;
      end;
    end;
  end;

var
  O = TOuter.Create, I = TOuter.TInner.Create;
begin
  println O, I;
  I.PrintData;
end.
