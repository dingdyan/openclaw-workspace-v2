unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BASE_PARSER, PaxScripter, PaxPascal, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    PaxScripter1: TPaxScripter;
    PaxPascal1: TPaxPascal;
    procedure Button1Click(Sender: TObject);
    procedure PaxScripter1Include(Sender: TObject;
      const IncludedFileName: String; var SourceCode: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  PaxScripter1.ResetScripter;
  PaxScripter1.AddModule('1', 'paxPascal');
  PaxScripter1.AddCode('1', '{$I myfile}');
  PaxScripter1.AddCode('1', 'print F();');
  PaxScripter1.Run();
end;

procedure TForm1.PaxScripter1Include(Sender: TObject;
                                     const IncludedFileName: String; var SourceCode: String);
begin
  if IncludedFileName = 'myfile' then
    SourceCode := 'function F(); begin result := 123; end;';
end;

end.
