unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LgInterfaces, PaxScripter, PaxPascal, BASE_PARSER;

  type

  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    PaxScripter: TPaxScripter;
    PaxPascal: TPaxPascal;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  public
    FApplication : ILgApplication;
  end;
var
  Form1: TForm1;


implementation

uses LgApplication, LgUser, IMP_Dialogs, IMP_Classes, IMP_LgInterfaces;


{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
var user: ILgUser;
begin
  FApplication := TLgApplication.Create;

  user := TLgUser.Create;
  user.Name := 'User1';
  user.Age := 24;
  FApplication.UserList.Add(user);

  user := TLgUser.Create;
  user.Name := 'User2';
  user.Age := 55;
  FApplication.UserList.Add(user);

  IMP_LgInterfaces.RegisterIMP_LgInterfaces;
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  PaxScripter.ResetScripter;
  PaxScripter.RegisterObject('Form1', Self);
  PaxScripter.AddModule('main', 'paxPascal');
  PaxScripter.RegisterInterfaceVar('app', @FApplication, ILgApplication);
  PaxScripter.AddCode('main', Memo1.Text);

  PaxScripter.Run();

end;

end.
