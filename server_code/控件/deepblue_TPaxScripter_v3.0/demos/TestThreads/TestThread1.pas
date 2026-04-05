unit TestThread1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PaxScripter, PaxPascal;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    cbStop: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    fThreadCount: Integer;
  public
    { Public declarations }
  end;

 TMyThread = class(TThread)
 private
   Scripter: TPaxScripter;
   Language: TPaxPascal;
   UnsafeInstructions: array[1..100] of Boolean;
   procedure MarkInstructions;
   procedure InvokeInstruction;
   procedure InstructionHandler(Sender: TPaxScripter; N: Integer;
                                var Handled: Boolean);
 public
   constructor Create;
   destructor Destroy; override;
   procedure Execute; override;
 end;

var
  Form1: TForm1;

implementation

uses
  IMP_SysUtils, IMP_Classes, IMP_StdCtrls, IMP_Controls, IMP_Forms, IMP_Graphics;

{$R *.DFM}

constructor TMyThread.Create;
begin
  inherited create(True);
  FreeOnTerminate := true;
  InterlockedIncrement(Form1.fThreadCount);
  resume;
end;

destructor TMyThread.Destroy;
begin
  InterlockedDecrement(Form1.fThreadCount);
  inherited;
end;

procedure TMyThread.MarkInstructions;
var
  N: Integer;
  S: String;
  Instruction: TPaxInstruction;
begin
  for N:=1 to Scripter.InstructionCount do
  begin
    UnsafeInstructions[N] := false;
    Instruction := Scripter.GetInstruction(N);
    if Instruction.Op = _OP_CALL then
    begin
      S := Scripter.GetName(Instruction.Arg1);
      if S = 'Add' then
        UnsafeInstructions[N] := true
      else if S = 'TextOut' then
        UnsafeInstructions[N] := true;
    end;
  end;
end;

procedure TMyThread.InvokeInstruction;
begin
  Scripter.RunInstruction;
end;

procedure TMyThread.InstructionHandler(Sender: TPaxScripter; N: Integer;
                                       var Handled: Boolean);
begin
  if UnsafeInstructions[N] then
  begin
    Synchronize(InvokeInstruction);
    Handled := true;
  end;
end;

procedure TMythread.Execute;
begin
  while not form1.cbStop.Checked do
  try
    Scripter := TPaxScripter.Create(nil);
    Language := TPaxPascal.Create(nil);
    try
      Scripter.RegisterLanguage(Language);
      Scripter.RegisterObject('Form1', Form1);
      Scripter.RegisterVariable('ThreadCount', 'Integer', @Form1.fThreadCount);

      Scripter.AddModule('1', Language.LanguageName);
      Scripter.AddCode('1', 'uses SysUtils, Classes, StdCtrls, Controls, Forms, Graphics;');
      Scripter.AddCode('1','Form1.Memo1.Lines.Add(IntToStr(ThreadCount));');
      Scripter.AddCode('1','Form1.Canvas.TextOut(0, 0, IntToStr(ThreadCount));');

      Scripter.Compile;
      MarkInstructions;

      Scripter.OnRunning := InstructionHandler;
      Scripter.Run;
      if Scripter.IsError then
        raise Exception.create(Scripter.ErrorDescription);
    finally
      FreeAndNil(Language);
      FreeAndNil(Scripter);
    end;
  except
    Application.HandleException(self);
    terminate;
    break;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  cbStop.Checked := false;
  for I:=1 to 100 do
    TMyThread.Create;
  while fThreadCount > 0 do
    Application.ProcessMessages;
  Memo1.Lines.Add('Finished');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RegisterClassType(TForm1, -1);
end;

end.
