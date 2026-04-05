unit SVMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, ComCtrls, Spin;

type
  TFrmMain = class(TForm)
    TimerProcess: TTimer;
    TimerDisplay: TTimer;
    TimerSave: TTimer;
    TimerClose: TTimer;
    SEProcessListCount: TSpinEdit;
    MainMenu1: TMainMenu;
    Files1: TMenuItem;
    Save1: TMenuItem;
    Exit1: TMenuItem;
    Env1: TMenuItem;
    LoadBadIpAndNotice1: TMenuItem;
    StatusBar1: TStatusBar;
    TimerRain: TTimer;
    MRain: TMenuItem;
    TimerRainning: TTimer;
    MConnection: TMenuItem;
    MDrop100: TMenuItem;
    MView: TMenuItem;
    MGate: TMenuItem;
    chkSaveUserData: TCheckBox;
    chkWeather: TCheckBox;
    MDelGuild: TMenuItem;
    Label1: TLabel;
    GroupBox_MAP: TGroupBox;
    SESelServer: TSpinEdit;
    Label2: TLabel;
    LbMonster: TLabel;
    GroupBox2: TGroupBox;
    LbConnection: TLabel;
    LbUser: TLabel;
    LbNpc: TLabel;
    LbItem: TLabel;
    LbProcess: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Log1: TMenuItem;
    SpinEditMoveTime: TSpinEdit;
    Label7: TLabel;
    ListBoxEvent: TListBox;
    SpinEditMaxExp: TSpinEdit;
    SpinEditAttackMagic: TSpinEdit;
    SpinEditBreathngMagic: TSpinEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    SpinEditRunningMagic: TSpinEdit;
    SpinEditProtectingMagic: TSpinEdit;
    SpinEditEctMagic: TSpinEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    SEProcessListUserCount: TSpinEdit;
    CheckBox_speed: TCheckBox;
    
    N4: TMenuItem;
    N5: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerProcessTimer(Sender: TObject);
    procedure TimerDisplayTimer(Sender: TObject);
    procedure TimerSaveTimer(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure LoadBadIpAndNotice1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TimerCloseTimer(Sender: TObject);
    procedure MRainClick(Sender: TObject);

    procedure MDrop100Click(Sender: TObject);
    procedure MGateClick(Sender: TObject);
    procedure MDelGuildClick(Sender: TObject);
    procedure SEProcessListCountChange(Sender: TObject);
    procedure Log1Click(Sender: TObject);
    procedure SpinEditMoveTimeChange(Sender: TObject);
    procedure SpinEditMaxExpChange(Sender: TObject);
    procedure SpinEditAttackMagicChange(Sender: TObject);
    procedure SpinEditBreathngMagicChange(Sender: TObject);
    procedure SpinEditRunningMagicChange(Sender: TObject);
    procedure SpinEditProtectingMagicChange(Sender: TObject);
    procedure SpinEditEctMagicChange(Sender: TObject);
    procedure SEProcessListUserCountChange(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure log2Click(Sender: TObject);
    procedure CheckBox_speedClick(Sender: TObject);
    procedure FCheckBox_CounterAttackClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
  private
    BadIpStringList: TStringList;
    NoticeStringList: TStringList;
    EventStringList: TStringList;
    procedure LoadBadIpAddr;
    procedure LoadNotice;
    procedure DisplayProcess;
  public
    //procedure   sendSoc(sSoc:string);
  end;

var
  FrmMain: TFrmMain;

implementation

uses uConnect, uGConnect, uManager, uUser, uSendCls, uMopSub, uGuild, uSkills,
  deftype, uLuaEngine;

{$R *.dfm}

procedure TFrmMain.FormCreate(Sender: TObject);
var
    cnt: integer;
    Manager: TManager;
begin
    FCheckBox_CounterAttack := TCheckBox.Create(Self);
    with FCheckBox_CounterAttack do
    begin
        Parent := Self;
        Left := 8; 
        Top := 350; 
        Width := 150;
        Caption := '开启反击系�?;
        Name := 'FCheckBox_CounterAttack';
        OnClick := FCheckBox_CounterAttackClick;
    end;

    SpinEditCounterRate := TSpinEdit.Create(Self);
    with SpinEditCounterRate do
    begin
        Parent := Self;
        Left := 160;
        Top := 350;
        Width := 50;
        Value := 50;
        Name := 'SpinEditCounterRate';
    end;

    WriteLogInfo('GameServer Started');
    tmlog := TsTMLogClass.Create('tmlog.dat');
    tmmoneylist := TsTMMoneyLogListClass.Create('tmlist.dat');
    CurrentDate := Date;
    SEProcessListCount.Value := ProcessListCount;
    EventStringList := TStringList.Create;
    boConnectRemote := FALSE;
    boCloseFlag := FALSE;
    Randomize;
    BadIpStringList := TStringList.Create;
    NoticeStringList := TStringList.Create;
end;

procedure TFrmMain.FCheckBox_CounterAttackClick(Sender: TObject);
begin
  if Assigned(g_LuaEngine) then
    g_LuaEngine.CallFunction('SetCounterAttackState', [FCheckBox_CounterAttack.Checked, SpinEditCounterRate.Value]);
end;

// ... other procedures ...

end.


