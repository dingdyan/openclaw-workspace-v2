program Demo;
type
  TRandomPoint = record
    X: Integer = Random(100);
    Y: Integer = Random(100);
    function TRandomPoint(): TRandomPoint;
    begin
      result := Self;
    end;
  end;

   TPascalClass = class(TObject)
   private
     fProp: Integer = 10;
    public
     constructor Create;
     function TPascalClass: TPascalClass; // to use it in paxJavaScript or paxC
     property Prop: Integer read fProp;
   end;

constructor TPascalClass.Create;
begin
  inherited;
end;

function TPascalClass.TPascalClass: TPascalClass;
begin
  result := Self;
end;

begin
end.
