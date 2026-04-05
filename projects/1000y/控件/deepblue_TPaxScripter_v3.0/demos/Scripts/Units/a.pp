unit a;

interface
type
  TMyClass = class(TObject)
    procedure Proc(x);
  end;

const
  x = 10;
var
  y: Integer;
  z: TMyClass;

procedure P(u, v);

implementation

procedure P(u, v);
begin
  println u + v;
end;

procedure TMyClass.Proc(x);
begin
  println x;
end;

initialization

  println 'start';
  y := 1;
  z := TMyClass.Create;

finalization

  z.Free;
  println 'fin';

end.
