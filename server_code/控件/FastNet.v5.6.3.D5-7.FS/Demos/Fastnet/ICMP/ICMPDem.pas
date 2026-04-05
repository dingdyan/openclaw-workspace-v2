unit ICMPDem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, NMICMP, Buttons;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    HostEdit: TEdit;
    PingResults: TMemo;
    Label1: TLabel;
    NMPing1: TNMPing;
    PSizeEdit: TEdit;
    Label2: TLabel;
    NumPacketsEdit: TEdit;
    Label3: TLabel;
    TimeoutEdit: TEdit;
    Label4: TLabel;
    PingBtn: TButton;
    AbortBtn: TButton;
    TraceResults: TMemo;
    NMTraceRt1: TNMTraceRt;
    Label5: TLabel;
    TraceHostEdit: TEdit;
    Label6: TLabel;
    TracePSizeEdit: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    TraceTimeoutEdit: TEdit;
    TraceBtn: TButton;
    TraceAbortBtn: TButton;
    MaxHopsEdit: TEdit;
    Label9: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Label10: TLabel;
    procedure PingBtnClick(Sender: TObject);
    procedure NMPing1Abort(Sender: TObject);
    procedure NMPing1HostUnreachable(Sender: TObject; Host: String);
    procedure NMPing1InvalidHost(Sender: TObject);
    procedure NMPing1Ping(Sender: TObject; Host: String; Size,
      Time: Integer);
    procedure NMPing1TimeOut(Sender: TObject);
    procedure NMPing1Status(Sender: TObject; Status: Integer;
      Host: String);
    procedure AbortBtnClick(Sender: TObject);
    procedure TraceBtnClick(Sender: TObject);
    procedure NMTraceRt1Abort(Sender: TObject);
    procedure NMTraceRt1Hop(Sender: TObject; Host: String; Time1, Time2,
      Time3, HopNo: Integer);
    procedure NMTraceRt1HostUnreachable(Sender: TObject; Host: String);
    procedure NMTraceRt1InvalidHost(Sender: TObject);
    procedure NMTraceRt1Status(Sender: TObject; Status: Integer;
      Host: String);
    procedure NMTraceRt1TraceComplete(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure TraceAbortBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.PingBtnClick(Sender: TObject);
begin
  NMPing1.Host := HostEdit.Text;
  NMPing1.Pings := StrToIntDef(NumPacketsEdit.Text, 4);
  NMPing1.PacketSize := StrToIntDef(PSizeEdit.Text, 32);
  NMPing1.Timeout := StrToIntDef(TimeoutEdit.Text, 2000);
  NMPing1.Ping;
end;

procedure TForm1.NMPing1Abort(Sender: TObject);
begin
  PingResults.Lines.Add('Operation Aborted');
end;

procedure TForm1.NMPing1HostUnreachable(Sender: TObject; Host: String);
begin
  PingResults.Lines.Add(Host+' reports destination unreachable');
end;

procedure TForm1.NMPing1InvalidHost(Sender: TObject);
begin
  PingResults.Lines.Add('Invalid host name or address specified');
end;

procedure TForm1.NMPing1Ping(Sender: TObject; Host: String; Size,
  Time: Integer);
begin
  PingResults.Lines.Add('Reply from '+Host+': size='+IntToStr(Size)+' time='+IntToStr(Time)+'ms');
end;

procedure TForm1.NMPing1TimeOut(Sender: TObject);
begin
  PingResults.Lines.Add('Operation timed out');
end;

procedure TForm1.NMPing1Status(Sender: TObject; Status: Integer;
  Host: String);
begin
  PingResults.Lines.Add(Host+' returned status: '+IntToStr(Status));
end;

procedure TForm1.AbortBtnClick(Sender: TObject);
begin
  NMPing1.Abort;
end;

procedure TForm1.TraceBtnClick(Sender: TObject);
begin
  NMTraceRt1.Host := TraceHostEdit.Text;
  NMTraceRt1.MaxHops := StrToIntDef(MaxHopsEdit.Text, 30);
  NMTraceRt1.PacketSize := StrToIntDef(TracePSizeEdit.Text, 32);
  NMTraceRt1.Timeout := StrToIntDef(TraceTimeoutEdit.Text, 2000);
  NMTraceRt1.Trace;
end;

procedure TForm1.NMTraceRt1Abort(Sender: TObject);
begin
  TraceResults.Lines.Add('Operation Aborted');
end;

procedure TForm1.NMTraceRt1Hop(Sender: TObject; Host: String; Time1, Time2,
  Time3, HopNo: Integer);
begin
  TraceResults.Lines.Add('Hop '+IntToStr(HopNo)+': '+Host+' Times: '+IntToStr(Time1)+'ms '+IntToStr(Time2)+' ms '+IntToStr(Time3)+'ms');
end;

procedure TForm1.NMTraceRt1HostUnreachable(Sender: TObject; Host: String);
begin
  TraceResults.Lines.Add(Host+' reports destination unreachable');
end;

procedure TForm1.NMTraceRt1InvalidHost(Sender: TObject);
begin
  TraceResults.Lines.Add('Invalid host name or address specified');
end;

procedure TForm1.NMTraceRt1Status(Sender: TObject; Status: Integer;
  Host: String);
begin
  TraceResults.Lines.Add(Host+' returned status: '+IntToStr(Status));
end;

procedure TForm1.NMTraceRt1TraceComplete(Sender: TObject);
begin
  TraceResults.Lines.Add('Trace complete');
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  PingResults.Clear;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  TraceResults.Clear;
end;

procedure TForm1.TraceAbortBtnClick(Sender: TObject);
begin
  NMTraceRt1.Abort;
end;

end.
