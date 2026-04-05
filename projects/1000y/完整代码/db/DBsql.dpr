program DBsql;

uses
  FastMM4,
  FastMM4Messages,
  Forms,
  FMain in 'FMain.pas' {frmMain},
  uConnector in 'uConnector.pas',
  uBuffer in '..\common\uBuffer.pas',
  uUtil in '..\common\uUtil.pas',
  uPackets in '..\common\uPackets.pas',
  uCrypt in '..\common\uCrypt.pas',
  uEasyList in '..\common\uEasyList.pas',
  uKeyClass in '..\common\uKeyClass.pas',
  deftype in '..\1000ydef\deftype.pas',
  uEmaildata in '..\tgs1000\uEmaildata.pas',
  uPaidConnector in 'uPaidConnector.pas',
  AUtil32 in '..\alib\AUtil32.pas',
  uAnsTick in '..\alib\uAnsTick.pas',
  uDBFile in 'uDBFile.pas',
  uDBAdapter in 'uDBAdapter.pas',
  frmAuction in 'frmAuction.pas' {FormAuction},
  frmEmail in 'frmEmail.pas' {FormEmail},
  frmLogin in 'frmLogin.pas' {FormLogin},
  frmPaid in 'frmPaid.pas' {FormPaid},
  frmUser in 'frmuser.pas' {FormUser},
  UnitItemEditWin in 'UnitItemEditWin.pas' {frmItemEdit};

{$R *.RES}

begin
    Application.Initialize;
    Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

