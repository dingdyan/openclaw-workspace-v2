program Demo;
uses
  StdCtrls, Forms;

type
  TMyForm = class(TForm)
   private
     Memo: TMemo;
   public
     constructor Create(Owner: TComponent);
   end;

constructor TMyForm.Create(Owner: TComponent);
begin
  inherited;
  Top := 100;
  Left := 200;
  Caption := 'MyForm';
    
  Memo := TMemo.Create(Self);
  Memo.Parent := Self;
  Memo.Width := 100;
  Memo.Align := 'alClient';
end;

var
  F: TMyForm;
begin
  F := TMyForm.Create(nil);
  F.Show;
end.
